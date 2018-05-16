%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 十一月 2016 14:04
%%%-------------------------------------------------------------------
-module(cross_dungeon_guard_util).
-author("hxming").
-include("common.hrl").
-include("dungeon.hrl").
-include("cross_dungeon_guard.hrl").
-include("drop.hrl").
-include("achieve.hrl").
-include("sword_pool.hrl").
-include("goods.hrl").

%% API
-compile(export_all).

get_notice_player(_Player) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    ?IF_ELSE(St#st_cross_dun_guard.times >= ?CROSS_DUNGEON_GUARD_TIMES, 0, 1).

%%获取副本通关信息
get_dun_list(Player) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    F = fun(DunId) ->
        Base = data_dungeon_cross_guard:get(DunId),
        case data_dungeon_cross_guard:get(DunId) of
            [] -> [0, 0, []];
            Base ->
                case lists:keytake(DunId, 1, St#st_cross_dun_guard.dun_list) of
                    false ->
                        [DunId, 0, 3, goods:pack_goods(Base#base_dun_cross_guard.reward)];
                    {value, {_, Times, _Floor0, _Time0, _State, _CountList}, _T} ->
                        [DunId, Times, 3, goods:pack_goods(Base#base_dun_cross_guard.reward)]
                end
        end
    end,
    DunList = lists:map(F, data_dungeon_cross_guard:dun_list()),
    {Lv, Count} =
        case data_dungeon_cross_guard_count:get(St#st_cross_dun_guard.lv) of
            [] -> {0, 0};
            Other -> Other
        end,
    CountReward = data_dungeon_cross_guard_count:get(Lv, Count),
    {St#st_cross_dun_guard.times, Count, Player#player.repute, goods:pack_goods(CountReward), DunList}.


%%增加系统玩家
add_shadow(Key) ->
    case get_room(Key) of
        [] -> false;
        Room ->
            MbLen = length(Room#ets_cross_dun_guard_room.mb_list),
            ShadowLen = length([Mb#dungeon_mb.pkey || Mb <- Room#ets_cross_dun_guard_room.mb_list, Mb#dungeon_mb.type == 1]),
            case MbLen >= ?CROSS_DUNGEON_GUARD_Mb_LIM orelse ShadowLen >= MbLen of
                true -> false;
                false ->
                    KeyList = [Mb#dungeon_mb.pkey || Mb <- Room#ets_cross_dun_guard_room.mb_list],
                    case shadow_proc:match_shadow_by_cbp(Room#ets_cross_dun_guard_room.cbp, 1, KeyList, Room#ets_cross_dun_guard_room.lv) of
                        [] -> false;
                        [Shadow] ->
                            Now = util:unixtime(),
                            Mb = dungeon_util:make_dungeon_mb(Shadow, Now),
                            NewMb = Mb#dungeon_mb{type = 1, node = none, is_ready = 1, sn = Shadow#player.sn, shadow = Shadow},
                            MbList = [NewMb | Room#ets_cross_dun_guard_room.mb_list],
                            NewRoom = Room#ets_cross_dun_guard_room{mb_list = MbList},
                            update_room(NewRoom),
                            refresh_room(NewRoom),
                            check_open(NewRoom),
                            {true, Room#ets_cross_dun_guard_room.shadow_time}
                    end
            end
    end.

%%离线
logout(Player) ->
    cross_dungeon_guard_init:logout(),
    if Player#player.cross_dun_guard_state /= 0 ->
        cross_all:apply(cross_dungeon_guard_proc, logout, [Player#player.cross_dun_guard_state, Player#player.key]);
        true ->
            ok
    end,
    case dungeon_util:is_dungeon_guard_cross(Player#player.scene) of
        false -> ok;
        true ->
            cross_all:apply(cross_dungeon_guard, logout, [Player#player.key, Player#player.copy])
    end,
    ok.

%%离开房间处理
do_quit(Room, Pkey, IsUpdate) ->
    MbList =
        case lists:keytake(Pkey, #dungeon_mb.pkey, Room#ets_cross_dun_guard_room.mb_list) of
            false -> Room#ets_cross_dun_guard_room.mb_list;
            {value, QMb, T} ->
                if IsUpdate ->
                    server_send:send_node_pid(QMb#dungeon_mb.node, QMb#dungeon_mb.pid, {cross_dun_guard_state, 0});
                    true -> ok
                end,
                T
        end,

    case [MbItem || MbItem <- MbList, MbItem#dungeon_mb.type == 0] of
        [] ->
            %%没人了,解散房间
            delete_room(Room#ets_cross_dun_guard_room.key);
        MbList1 ->
            ShadowTime = max(?CROSS_DUNGEON_GUARD_SHADOW_SUB, Room#ets_cross_dun_guard_room.shadow_time - ?CROSS_DUNGEON_GUARD_SHADOW_SUB),
            NewRoom =
                if Pkey == Room#ets_cross_dun_guard_room.pkey ->
                    %%房主切换
                    Mb = hd(lists:keysort(#dungeon_mb.join_time, MbList1)),
                    Room#ets_cross_dun_guard_room{
                        mb_list = MbList,
                        sn = Mb#dungeon_mb.sn,
                        pkey = Mb#dungeon_mb.pkey,
                        nickname = Mb#dungeon_mb.nickname,
                        career = Mb#dungeon_mb.career,
                        sex = Mb#dungeon_mb.sex,
                        shadow_time = ShadowTime,
                        ready_ref = none};
                    true ->
                        Room#ets_cross_dun_guard_room{mb_list = MbList, ready_ref = none, shadow_time = ShadowTime}
                end,
            ?DO_IF(Room#ets_cross_dun_guard_room.password == "", self() ! {check_add_shadow, Room#ets_cross_dun_guard_room.key, ShadowTime}),
            update_room(NewRoom),
            check_cancel_ready(Room),
            refresh_room(NewRoom)
    end.


%%检查取消准备
check_cancel_ready(Room) ->
    if Room#ets_cross_dun_guard_room.ready_ref == none ->
        ok;
        true ->
            {ok, Bin} = pt_651:write(65110, {0, 0}),
            send_to_leader(Room, Bin),
            self() ! {cancel_ready, Room#ets_cross_dun_guard_room.ready_ref}
    end.

%%通知退出
notice_kickout(Mb) ->
    if Mb#dungeon_mb.node /= none ->
        {ok, Bin} = pt_651:write(65107, {17}),
        server_send:send_to_sid(Mb#dungeon_mb.node, Mb#dungeon_mb.sid, Bin);
%%        center:apply(Mb#dungeon_mb.node, server_send, send_to_sid, [Mb#dungeon_mb.sid, Bin]);
        true ->
            ok
    end.


%%刷新房间信息
refresh_room(Room) ->
    Data = pack_room(Room),
    {ok, Bin} = pt_651:write(65104, Data),
    send_to_mb(Room, Bin),
    ok.

send_to_mb(Room, Bin) ->
    F = fun(Mb) ->
        if Mb#dungeon_mb.node /= none ->
            server_send:send_to_sid(Mb#dungeon_mb.node, Mb#dungeon_mb.sid, Bin);
%%            center:apply(Mb#dungeon_mb.node, server_send, send_to_sid, [Mb#dungeon_mb.sid, Bin]);
            true -> ok
        end
    end,
    lists:foreach(F, Room#ets_cross_dun_guard_room.mb_list).

%%通知房主
send_to_leader(Room, Bin) ->
    case lists:keyfind(Room#ets_cross_dun_guard_room.pkey, #dungeon_mb.pkey, Room#ets_cross_dun_guard_room.mb_list) of
        false -> ok;
        Mb ->
            if Mb#dungeon_mb.node /= none ->
                server_send:send_to_sid(Mb#dungeon_mb.node, Mb#dungeon_mb.sid, Bin);
%%                center:apply(Mb#dungeon_mb.node, server_send, send_to_sid, [Mb#dungeon_mb.sid, Bin]);
                true -> ok
            end
    end,
    ok.

pack_room(Room) ->
    F = fun(Mb) ->
        [
            Mb#dungeon_mb.sn,
            Mb#dungeon_mb.pkey,
            Mb#dungeon_mb.nickname,
            Mb#dungeon_mb.career,
            Mb#dungeon_mb.sex,
            Mb#dungeon_mb.power,
            Mb#dungeon_mb.is_ready,
            Mb#dungeon_mb.avatar
        ]
    end,
    MbList = lists:map(F, Room#ets_cross_dun_guard_room.mb_list),
    Cd = max(0, Room#ets_cross_dun_guard_room.cd - util:unixtime()),
    {Room#ets_cross_dun_guard_room.dun_id, Room#ets_cross_dun_guard_room.key, Room#ets_cross_dun_guard_room.pkey, Room#ets_cross_dun_guard_room.is_fast, Room#ets_cross_dun_guard_room.password, Cd, MbList}.


%%检查开启
check_open(Room) ->
    case length(Room#ets_cross_dun_guard_room.mb_list) >= ?CROSS_DUNGEON_GUARD_Mb_LIM of
        false -> ok;
        true ->
            F = fun(Mb) -> Mb#dungeon_mb.is_ready > 0 end,
            case lists:all(F, Room#ets_cross_dun_guard_room.mb_list) of
                false ->
                    ok;
                true ->
                    self() ! {ready_dungeon, Room#ets_cross_dun_guard_room.key}
            end
    end.

%%开启副本处理
do_open_dungeon(Key) ->
    case get_room(Key) of
        [] -> ok;
        Room ->
            util:cancel_ref([Room#ets_cross_dun_guard_room.ready_ref]),
            delete_room(Room#ets_cross_dun_guard_room.key),
            add_in_pro_room(Room),
            %%通知玩家进入
            WaitTime = 3,
            {ok, Bin} = pt_651:write(65115, {1, WaitTime}),
            F = fun(Mb) ->
                if Mb#dungeon_mb.node /= none andalso Mb#dungeon_mb.type == ?DUN_MB_TYPE_NORMAL ->
                    server_send:send_to_sid(Mb#dungeon_mb.node, Mb#dungeon_mb.sid, Bin);
%%                    center:apply(Mb#dungeon_mb.node, server_send, send_to_sid, [Mb#dungeon_mb.sid, Bin]),
                    ok;
                    true ->
                        ok
                end
            end,
            lists:foreach(F, Room#ets_cross_dun_guard_room.mb_list),
            spawn(fun() -> util:sleep(WaitTime * 1000), create_dungeon(Room) end),
            ok
    end,
    ok.

cmd_enter(Mb, DunId) ->
    DunList = data_dungeon_cross_guard:dun_list(),
    case lists:member(DunId, DunList) of
        false -> ok;
        true ->
            Now = util:unixtime(),
            Base = data_dungeon:get(DunId),
            Room = #ets_cross_dun_guard_room{
                create_time = Now,
                key = misc:unique_key_auto(),
                dun_id = DunId,
                lv = Base#dungeon.lv,
                password = "",
                mb_list = [Mb],
                sn = Mb#dungeon_mb.sn,
                pkey = Mb#dungeon_mb.pkey,
                nickname = Mb#dungeon_mb.nickname,
                career = Mb#dungeon_mb.career,
                sex = Mb#dungeon_mb.sex,
                is_fast = 1,
                cbp = Mb#dungeon_mb.power,
                shadow_time = ?CROSS_DUNGEON_GUARD_SHADOW_TIME
            },
            Scene = data_scene:get(Room#ets_cross_dun_guard_room.dun_id),
            DunPid = cross_dungeon_guard:start(Room, Now, DunId),
            server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, {enter_cross_dungeon_guard_scene, Room#ets_cross_dun_guard_room.dun_id, DunPid, Scene#scene.x, Scene#scene.y, ?GROUP_DUNGEON, 0}),
            ok
    end.


create_dungeon(Room) ->
    Now = util:unixtime(),
    Scene = data_scene:get(Room#ets_cross_dun_guard_room.dun_id),
    BuffId = check_buff(Room#ets_cross_dun_guard_room.dun_id, Room#ets_cross_dun_guard_room.mb_list),
    DunPid = cross_dungeon_guard:start(Room#ets_cross_dun_guard_room{buff_id = BuffId}, Now, Scene#scene.id),
    F = fun(Mb) ->
        if Mb#dungeon_mb.node /= none andalso Mb#dungeon_mb.type == ?DUN_MB_TYPE_NORMAL ->
            server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, {enter_cross_dungeon_guard_scene, Room#ets_cross_dun_guard_room.dun_id, DunPid, Scene#scene.x, Scene#scene.y, ?GROUP_DUNGEON, BuffId}),
            ok;
            true ->
                {NewX, NewY} = scene:random_xy(Scene#scene.id, Scene#scene.x, Scene#scene.y),
                %%AI创建
                shadow:create_shadow_for_dungeon_team(Mb#dungeon_mb.shadow, Room#ets_cross_dun_guard_room.dun_id, DunPid, NewX, NewY),
                ok
        end
    end,
    lists:foreach(F, Room#ets_cross_dun_guard_room.mb_list).

check_buff(DunId, MbList) ->
    SnList = [Mb#dungeon_mb.sn || Mb <- MbList, Mb#dungeon_mb.type == 0],
    case length(SnList) >= 3 of
        false -> 0;
        true ->
            case length(util:list_filter_repeat(SnList)) == 1 of
                false -> 0;
                true ->
                    get_buff(DunId)
            end
    end.

get_buff(DunId) ->
    case data_dungeon_cross_guard:get(DunId) of
        [] -> 0;
        _Base ->
            56901
    end.

%%获取邀请列表 1帮会,2好友
get_invite_list(Player, DunId, Type) ->
    Lv = dungeon_util:get_dungeon_lv(DunId),
    case Type of
        1 ->
            relation:get_friend_info_list_for_dun_cross(Lv);
        2 ->
            guild_util:get_member_for_dun_cross(Player#player.guild#st_guild.guild_key, Player#player.key, Lv);
        _ -> []
    end.


%%收到邀请
invite_msg(Player, Nickname, DunId, Key, Password) ->
    if Player#player.cross_dun_guard_state /= 0 -> ok;
        true ->
            case scene:is_normal_scene(Player#player.scene) of
                false -> ok;
                true ->
                    {ok, Bin} = pt_651:write(65113, {Nickname, DunId, Key, Password}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end
    end,
    ok.


%%副本结算
dun_cross_ret(1, DunId, Player, Key, Password, IsFast, AutoReady, IsExtraPt, Floor, Time, BoxCount, PassGoodslist) ->
    ?DEBUG("1111111111 ~n"),
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    {NewSt, Times, IsNew, MaxFloor, Reward0} = cross_dungeon_guard_init:update_dungeon_times(St, DunId, Floor, Time, 1),
    Base = data_dungeon_cross_guard:get(DunId),
    GoodsList1 = get_reward(NewSt, DunId, Base, IsExtraPt, Player#player.world_lv_add, St#st_cross_dun_guard.dun_list, Times, PassGoodslist), %% 通关奖励
    GoodsList2 = Reward0, %% 次数奖励
    BoxReward = data_dungeon_cross_guard_box_rewrad:get(DunId),
    GoodsList3 = ?IF_ELSE(BoxCount == 0, [], [{Id, Num * BoxCount} || {Id, Num} <- BoxReward]), %% 宝箱奖励
    ?DEBUG("GoodsList1 ~p~n", [GoodsList1]),
    ?DEBUG("GoodsList2 ~p~n", [GoodsList2]),
    ?DEBUG("GoodsList3 ~p~n", [GoodsList3]),
    GoodsList = GoodsList1 ++ GoodsList2 ++ GoodsList3,
    RewardList = goods:make_give_goods_list(320, GoodsList),
    {ok, NewPlayer} =
        case RewardList of
            [] -> {ok, Player};
            _ ->
                goods:give_goods(Player, RewardList)
        end,
    GoodsList11 = [[Gid, Num, 1] || {Gid, Num} <- GoodsList1],
    GoodsList21 = [[Gid, Num, 2] || {Gid, Num} <- GoodsList2],
    GoodsList31 = [[Gid, Num, 3] || {Gid, Num} <- GoodsList3],
    PackGoodsList = GoodsList11 ++ GoodsList21 ++ GoodsList31,
    ?DEBUG("Floor,IsNew,MaxFloor ~p~n", [{Floor, IsNew, MaxFloor}]),
    {ok, Bin} = pt_651:write(65122, {1, DunId, Key, Password, IsFast, AutoReady, Floor, IsNew, MaxFloor, PackGoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    dungeon_util:add_dungeon_times(DunId),
    activity:get_notice(NewPlayer, [104], true),
    NewPlayer;

dun_cross_ret(_, DunId, Player, Key, Password, IsFast, AutoReady, _IsExtraPt, Floor, _Time, BoxCount, PassGoodslist) ->
    ?DEBUG("22222222 ~n"),

    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    {NewSt, Times, IsNew, MaxFloor, RewardList0} = cross_dungeon_guard_init:update_dungeon_times(St, DunId, Floor, St#st_cross_dun_guard.time, 0),
    Base = data_dungeon_cross_guard:get(DunId),
    GoodsList1 = get_reward(NewSt, DunId, Base, _IsExtraPt, Player#player.world_lv_add, St#st_cross_dun_guard.dun_list, Times, PassGoodslist),
%%     GoodsList2 = get_extra_times_reward(NewSt#st_cross_dun_guard.times, Player#player.xian_stage),
    GoodsList2 = RewardList0,
    BoxReward = data_dungeon_cross_guard_box_rewrad:get(DunId),
    GoodsList3 = ?IF_ELSE(BoxCount == 0, [], [{Id, Num * BoxCount} || {Id, Num} <- BoxReward]),
    GoodsList = GoodsList1 ++ GoodsList2 ++ GoodsList3,
    ?DEBUG("GoodsList1 ~p~n", [GoodsList1]),
    ?DEBUG("GoodsList2 ~p~n", [GoodsList2]),
    ?DEBUG("GoodsList3 ~p~n", [GoodsList3]),
    RewardList = goods:make_give_goods_list(320, GoodsList),
    {ok, NewPlayer} =
        case RewardList of
            [] -> {ok, Player};
            _ ->
                goods:give_goods(Player, RewardList)
        end,
    GoodsList11 = [[Gid, Num, 1] || {Gid, Num} <- GoodsList1],
    GoodsList21 = [[Gid, Num, 2] || {Gid, Num} <- GoodsList2],
    GoodsList31 = [[Gid, Num, 3] || {Gid, Num} <- GoodsList3],
    PackGoodsList = GoodsList11 ++ GoodsList21 ++ GoodsList31,
    ?DEBUG("Floor,IsNew,MaxFloor ~p~n", [{Floor, IsNew, MaxFloor}]),
    {ok, Bin} = pt_651:write(65122, {1, DunId, Key, Password, IsFast, AutoReady, Floor, IsNew, MaxFloor, PackGoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    dungeon_util:add_dungeon_times(DunId),
    activity:get_notice(NewPlayer, [104], true),
    NewPlayer.

get_reward(_St, _DunId, _Base, IsExtraPt, WorldLvAdd, _DunList, Times, PassGoodslist) ->
    GoodsList =
        case Times > 3 of
            true ->
                [];
            false ->
                goods:merge_goods(PassGoodslist)
        end,
    %%组队满人声望额外增加20%
    F = fun({Gid, Num}) ->
        if Gid == 1023000 andalso IsExtraPt ->
            {Gid, round(Num * 1.2)};
            Gid == ?GOODS_ID_EXP ->
                {Gid, round(Num * (1 + WorldLvAdd))};
            true ->
                {Gid, Num}
        end
    end,
    lists:map(F, GoodsList).

%%获取额外固定次数奖励
get_extra_times_reward(Lv, Times) ->
    data_dungeon_cross_guard_count:get(Lv, Times).

log_cross_dun(Pkey, Nickname, DunId, GoodsList) ->
    Sql = io_lib:format("insert into log_cross_dun set pkey=~p,nickname='~s',dun_id=~p,goods_list='~s',time=~p",
        [Pkey, Nickname, DunId, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql).

%%首通奖励
first_reward(DunList, DunId, GoodsList) ->
    case lists:keymember(DunId, 1, DunList) of
        true -> [];
        false ->
            tuple_to_list(GoodsList)
    end.

%%通关奖励
pass_reward(GoodsList) -> tuple_to_list(GoodsList).

%%额外掉落
extra_reward(GoodsList) ->
    RatioList = [{Gid, Ratio} || {Gid, _, Ratio} <- GoodsList],
    case util:list_rand_ratio(RatioList) of
        0 -> [];
        Gid ->
            case lists:keyfind(Gid, 1, GoodsList) of
                false -> [];
                {_, Num, _} ->
                    [{Gid, Num}]
            end
    end.

%%掉落库
drop_goods(Player, DropId) ->
    DropInfo = #drop_info{lvdown = Player#player.lv, lvup = Player#player.lv, career = Player#player.career, order = 1, rank = 1, perc = 100},
    drop:get_goods_from_drop_rule(DropId, DropInfo).

%%
%%======================================ets
%%根据副本id获取房间列表
fetch_room_list(DunId, Sn, KeyList, Cbp, Lv) ->
    F = fun(Room) ->
        if Room#ets_cross_dun_guard_room.dun_id == DunId -> [Room];
            true -> []
        end
    end,
    case lists:flatmap(F, get(room_list)) of
        [] ->
            new_room_sys(DunId, Sn, KeyList, Cbp, Lv);
        L ->
            L
    end.

%%系统房间
new_room_sys(DunId, Sn, KeyList, Cbp, _PLv) ->
    Lv = dungeon_util:get_dungeon_lv(DunId),
    case shadow_proc:match_shadow_by_cbp(Cbp, 1, KeyList, Lv) of
        [] -> [];
        [Shadow] ->
            Lv = dungeon_util:get_dungeon_lv(DunId),
            Now = util:unixtime(),
            Mb = dungeon_util:make_dungeon_mb(Shadow, Now),
            NewMb = Mb#dungeon_mb{node = none, type = 1, sn = Shadow#player.sn, is_ready = 1, shadow = Shadow},
            Room = #ets_cross_dun_guard_room{
                key = misc:unique_key_auto(),
                dun_id = DunId,
                lv = Lv,
                type = 1,
                create_time = Now,
                mb_list = [NewMb],%%[#dungeon_mb]
                sn = Sn,
                pkey = Shadow#player.key,
                nickname = Shadow#player.nickname,
                career = Shadow#player.career,
                sex = Shadow#player.sex,
                is_fast = 1,
                cbp = Shadow#player.cbp,
                shadow_time = ?CROSS_DUNGEON_GUARD_SHADOW_TIME
            },
            update_room(Room),
            self() ! {set_timeout, Room#ets_cross_dun_guard_room.key},
            [Room]
    end.

%%获取房间
get_room(Key) ->
    case get(room_list) of
        undefined ->
            [];
        L ->
            case lists:keyfind(Key, #ets_cross_dun_guard_room.key, L) of
                false -> [];
                Room -> Room
            end
    end.

%%更新房间列表
update_room(Room) ->
    case get(room_list) of
        undefined ->
            put(room_list, [Room]);
        L ->
            put(room_list, [Room | lists:keydelete(Room#ets_cross_dun_guard_room.key, #ets_cross_dun_guard_room.key, L)])
    end.

%%删除房间
delete_room(Key) ->
    self() ! {cancel_timeout, Key},
    case get(room_list) of
        undefined ->
            put(room_list, []);
        L ->
            case lists:keytake(Key, #ets_cross_dun_guard_room.key, L) of
                false ->
                    ok;
                {value, _, L1} ->
                    put(room_list, L1)
            end
    end.


%%检查是否在房间中[Mon || {_Key, Mon} <- AllData, is_record(Mon, mon)].
check_in_room(Pkey) ->
    F = fun(Room) ->
        case lists:keyfind(Pkey, #dungeon_mb.pkey, Room#ets_cross_dun_guard_room.mb_list) of
            false -> false;
            Mb ->
                Mb#dungeon_mb.type == 0
        end
    end,
    lists:any(F, get(room_list)).


%%获取进行中的房间
get_in_pro_room_list(DunId, Pkey) ->
    case get(in_pro_room_list) of
        undefined -> [];
        L ->
            lists:sublist([Room || Room <- L, Room#ets_cross_dun_guard_room.dun_id == DunId, Room#ets_cross_dun_guard_room.pkey /= Pkey], 3)
    end.

%%增加进行中的房间
add_in_pro_room(Room) ->
    case get(in_pro_room_list) of
        undefined ->
            put(in_pro_room_list, [Room#ets_cross_dun_guard_room{state = 1}]);
        L ->
            put(in_pro_room_list, lists:keydelete(Room#ets_cross_dun_guard_room.key, #ets_cross_dun_guard_room.key, L) ++ [Room#ets_cross_dun_guard_room{state = 1}])
    end.

delete_in_pro_room(Key) ->
    case get(in_pro_room_list) of
        undefined ->
            put(in_pro_room_list, []);
        L ->
            case lists:keytake(Key, #ets_cross_dun_guard_room.key, L) of
                false ->
                    ok;
                {value, _, L1} ->
                    put(in_pro_room_list, L1)
            end
    end.


%%判断是否是守卫
is_guard_mon(Mid) ->
    case lists:member(Mid, [50301, 50302, 50303]) of
        false -> false;
        _ -> true
    end.

%%     BaseDun = data_dungeon:get(?SCENE_ID_KINDOM_GUARD_ID),
%%     case lists:keyfind(Mid, 1, BaseDun#dungeon.mon) of
%%         false -> false;
%%         _ -> true
%%     end.

%%副本启动--创建守卫怪物
start_init(StDungeon, SceneId, DunId, IsBc) ->
    BaseDun = data_dungeon:get(SceneId),
    F = fun({MonId, X, Y, Hp}) ->
        mon_agent:create_mon_cast([MonId, DunId, X, Y, self(), IsBc, [{type, ?ATTACK_TENDENCY_PEACE}, {group, 9}, {hp, Hp}, {hp_lim, Hp}]])
    end,
    lists:foreach(F, BaseDun#dungeon.mon),
    Now = util:unixtime(),
    StDungeon#st_dungeon{
        round_time = Now + 10
    }.

%%怪物刷新通知
mon_refresh_notice(SceneId, Copy, Floor, Time) ->
    {ok, Bin} = pt_651:write(65125, {Floor, Time}),
    server_send:send_to_scene(SceneId, Copy, Bin),
    ok.


%%怪物被杀，创建怪物宝箱
create_mon_box(Mid, X, Y, Copy, Scene) ->
    Base = data_dungeon_cross_guard_box:get(Mid),
    case Base of
        [] -> skip;
        _ ->
            BoxNum = get_box_num(Scene),
            case BoxNum < 40 of %%最大只能存在40个宝箱
                true ->
                    #base_mon_drop_box{
                        ratio = Ratio
                    } = Base,
                    case util:odds(Ratio, 10000) of
                        true ->
                            Len = length(Base#base_mon_drop_box.box_list),
                            XYList = get_create_mon_box_xy_list(Scene, X, Y, Len),
                            case XYList of
                                [] -> skip;
                                _ ->
                                    F1 = fun(Mid1, AccXYList) ->
                                        [{X1, Y1} | Tail] = AccXYList,
                                        mon_agent:create_mon_cast([Mid1, Scene, X1, Y1, Copy, 1, []]),
                                        Tail ++ [{X1, Y1}]
                                    end,
                                    lists:foldl(F1, XYList, Base#base_mon_drop_box.box_list)
                            end;
                        false ->
                            skip
                    end;
                false ->
                    skip
            end
    end.

get_create_mon_box_xy_list(SceneId, X, Y, GetNum) ->
    L = [{X, Y}, {X - 1, Y}, {X, Y - 1}, {X + 1, Y}, {X, Y + 1}, {X - 1, Y - 1}, {X + 1, Y + 1}, {X - 2, Y}, {X, Y - 2}, {X - 2, Y - 2}],
    get_create_mon_box_xy_list_1(GetNum, SceneId, L, []).
get_create_mon_box_xy_list_1(0, _SceneId, _XYList, AccList) -> AccList;
get_create_mon_box_xy_list_1(_GetNum, _SceneId, [], AccList) -> AccList;
get_create_mon_box_xy_list_1(GetNum, SceneId, [{X, Y} | Tail], AccList) ->
    case scene:can_moved(SceneId, X, Y) of
        false -> get_create_mon_box_xy_list_1(GetNum, SceneId, Tail, AccList);
        true -> get_create_mon_box_xy_list_1(GetNum - 1, SceneId, Tail, [{X, Y} | AccList])
    end.

get_box_num(Scene) ->
    Now = util:unixtime(),
    case get(cross_guard_box_num) of
        undefined ->
            Num = length(mon_agent:get_scene_mon_by_kind(Scene, self(), ?MON_KIND_CROSS_GUARD_BOX)),
            put(cross_guard_box_num, {Num, Now}),
            Num;
        {Num, Time} ->
            case Now - Time > 8 of
                true ->
                    put(cross_guard_box_num, undefined),
                    get_box_num(Scene);
                false ->
                    Num
            end
    end.

%%创建波数宝箱
create_floor_box(Floor, Scene, Copy) ->
    Base = data_dungeon_cross_guard_floor:get(Scene, Floor),
    case Base of
        [] -> skip;
        _ ->
            F1 = fun({Mid, X, Y}) ->
                mon_agent:create_mon_cast([Mid, Scene, X, Y, Copy, 1, []])
            end,
            lists:foreach(F1, Base#base_cross_guard_dun.box_list)
    end.

%%击杀怪物公告
kill_mon_noitce(Mon, KillerName) ->
    #mon{
        mid = Mid,
        scene = Scene,
        copy = Copy
    } = Mon,
    Base = data_dungeon_cross_guard_box:get(Mid),
    case Base of
        [] -> skip;
        _ ->
            case Base#base_mon_drop_box.is_notice of
                1 ->
                    notice_sys:add_notice(cross_guard_kill_boss, [KillerName, Mon#mon.name, Scene, Copy]),
                    ok;
                _ -> skip
            end
    end.

get_milestone_info(_Player) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    F = fun(DunId) ->
        FloorList = data_dungeon_cross_guard_milestone:get_all(DunId),
        F0 = fun(Floor) ->
            Reward = data_dungeon_cross_guard_milestone:get(DunId, Floor),
            State = check_milestone(DunId, Floor, St),
            [DunId, Floor, State, goods:pack_goods(Reward)]
        end,
        lists:map(F0, FloorList)
    end,
    DunList = lists:flatmap(F, data_dungeon_cross_guard:dun_list()),
    DunList.


get_milestone_reward(Player, DunId, Floor) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    case check_milestone(DunId, Floor, St) of
        0 -> %% 不可领取
            {26, Player};
        1 -> %% 可领取
            NewMilestoneList =
                case lists:keytake({DunId, Floor}, 1, St#st_cross_dun_guard.milestone_list) of
                    false ->
                        [{{DunId, Floor}, 1, 0} | St#st_cross_dun_guard.milestone_list];
                    {value, {_, _, Time}, List} ->
                        [{{DunId, Floor}, 1, Time} | List]
                end,
            ?DEBUG("NewMilestoneList ~p~n", [NewMilestoneList]),
            NewSt = St#st_cross_dun_guard{milestone_list = NewMilestoneList, is_change = 1},
            lib_dict:put(?PROC_STATUS_CROSS_DUNGEON_GUARD, NewSt),
            Reward = data_dungeon_cross_guard_milestone:get(DunId, Floor),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(321, Reward)),
            {1, NewPlayer};
        2 -> %%已领取
            {27, Player}
    end.

check_milestone(DunId, Floor, St) ->
    case data_dungeon_cross_guard_milestone:get(DunId, Floor) of
        [] -> 0;
        _ ->
            case lists:keytake(DunId, 1, St#st_cross_dun_guard.dun_list) of
                false ->
                    0;
                {value, {_, _Times, MaxFloor, _Time0, _State, _CountList}, _T} ->
                    if
                        MaxFloor < Floor ->
                            0;
                        true ->
                            case lists:keyfind({DunId, Floor}, 1, St#st_cross_dun_guard.milestone_list) of
                                false ->
                                    1;
                                {{DunId, Floor}, State, _Time} ->
                                    if
                                        State == 1 ->
                                            2;
                                        true ->
                                            1
                                    end

                            end
                    end
            end
    end.

get_milestone_state() ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    F = fun(DunId) ->
        FloorList = data_dungeon_cross_guard_milestone:get_all(DunId),
        F0 = fun(Floor) ->
            State = check_milestone(DunId, Floor, St),
            ?IF_ELSE(State == 1, 1, 0)
        end,
        lists:map(F0, FloorList)
    end,
    StateList = lists:flatmap(F, data_dungeon_cross_guard:dun_list()),
    Sum = lists:sum(StateList),
    ?IF_ELSE(Sum > 0, 1, 0).

update_ets(PlayerList, UseTime, DunId, Floor) ->
    case ets:lookup(?ETS_CROSS_DUNGEON_GUARD_MILESTONE, {DunId, Floor}) of
        [CrossGuardMilestone] ->
            if
                CrossGuardMilestone#cross_guard_milestone.time =< UseTime andalso CrossGuardMilestone#cross_guard_milestone.time /= 0 ->
                    skip;
                true ->
                    F = fun(DungeonMb) ->
                        make_cross_guard_mileston(DungeonMb)
                    end,
                    NewPlayerList = lists:map(F, PlayerList),
                    NewCrossGuardMilestone =
                        #cross_guard_milestone{
                            key = {DunId, Floor},
                            time = UseTime,
                            player_list = NewPlayerList},
                    ets:insert(?ETS_CROSS_DUNGEON_GUARD_MILESTONE, NewCrossGuardMilestone),
                    dbup_milestone_ets(NewCrossGuardMilestone)
            end;
        [] ->
            F = fun(DungeonMb) ->
                make_cross_guard_mileston(DungeonMb)
            end,
            NewPlayerList = lists:map(F, PlayerList),
            NewCrossGuardMilestone =
                #cross_guard_milestone{
                    key = {DunId, Floor},
                    time = UseTime,
                    player_list = NewPlayerList},
            ets:insert(?ETS_CROSS_DUNGEON_GUARD_MILESTONE, NewCrossGuardMilestone),
            dbup_milestone_ets(NewCrossGuardMilestone)
    end.

make_cross_guard_mileston(DungeonMb) ->
    #milestone_player_info{
        pkey = DungeonMb#dungeon_mb.pkey,
        sn = DungeonMb#dungeon_mb.sn,
        sex = DungeonMb#dungeon_mb.sex,
        nickname = DungeonMb#dungeon_mb.nickname,
        power = DungeonMb#dungeon_mb.power,
        fashion_cloth_id = DungeonMb#dungeon_mb.fashion_cloth_id,
        light_weaponid = DungeonMb#dungeon_mb.light_weaponid,
        wing_id = DungeonMb#dungeon_mb.wing_id,
        clothing_id = DungeonMb#dungeon_mb.clothing_id,
        weapon_id = DungeonMb#dungeon_mb.weapon_id
    }.

get_milestone_ets(Player, DunId, Floor) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
    Time =
        case lists:keyfind({DunId, Floor}, 1, St#st_cross_dun_guard.milestone_list) of
            false -> 0;
            {{DunId, Floor}, _State, Time0} ->
                Time0
        end,
    cross_all:apply(cross_dungeon_guard_util, do_get_milestone_ets, [Player#player.sid, DunId, Floor, Time]),
    ok.

do_get_milestone_ets(Sid, DunId, Floor, MyTime) ->
    case ets:lookup(?ETS_CROSS_DUNGEON_GUARD_MILESTONE, {DunId, Floor}) of
        [CrossGuardMilestone] ->
            F = fun(Info) ->
                [
                    Info#milestone_player_info.sn,
                    Info#milestone_player_info.power,
                    Info#milestone_player_info.nickname,
                    Info#milestone_player_info.sex,
                    Info#milestone_player_info.fashion_cloth_id,
                    Info#milestone_player_info.light_weaponid,
                    Info#milestone_player_info.wing_id,
                    Info#milestone_player_info.clothing_id
                ]
            end,
            List = lists:map(F, CrossGuardMilestone#cross_guard_milestone.player_list),
            {ok, Bin} = pt_651:write(65130, {MyTime, DunId, Floor, CrossGuardMilestone#cross_guard_milestone.time, List}),
            server_send:send_to_sid(Sid, Bin);
        [] ->
            {ok, Bin} = pt_651:write(65130, {MyTime, DunId, Floor, 0, []}),
            server_send:send_to_sid(Sid, Bin)
    end.

update_milestone(PlayerList, Dunid, Floor, Time) ->
    F = fun(Mb) ->
        if
            Mb#dungeon_mb.node == none -> skip;
            true ->
                case misc:is_process_alive(Mb#dungeon_mb.pid) of
                    true ->
                        Mb#dungeon_mb.pid ! {update_milestone, Dunid, Floor, Time};
                    false -> skip
                end
        end
    end,
    lists:foreach(F, PlayerList),
    ok.

dbup_milestone_ets(CrossGuardMilestone) ->
    F = fun(MilestonePlayerInfo) ->
        {
            MilestonePlayerInfo#milestone_player_info.pkey,
            MilestonePlayerInfo#milestone_player_info.sn,
            MilestonePlayerInfo#milestone_player_info.sex,
            MilestonePlayerInfo#milestone_player_info.nickname,
            MilestonePlayerInfo#milestone_player_info.power,
            MilestonePlayerInfo#milestone_player_info.fashion_cloth_id,
            MilestonePlayerInfo#milestone_player_info.light_weaponid,
            MilestonePlayerInfo#milestone_player_info.wing_id,
            MilestonePlayerInfo#milestone_player_info.clothing_id,
            MilestonePlayerInfo#milestone_player_info.weapon_id
        }
    end,
    List = lists:map(F, CrossGuardMilestone#cross_guard_milestone.player_list),
    Sql = io_lib:format("replace into dun_cross_guard_ets set `key`='~s',player_list='~s', time=~p",
        [util:term_to_bitstring(CrossGuardMilestone#cross_guard_milestone.key),
            util:term_to_bitstring(List),
            CrossGuardMilestone#cross_guard_milestone.time]),
    db:execute(Sql),
    ok.

dbload_milestone_ets() ->
    Data = db:get_all("select `key`,player_list,`time` from dun_cross_guard_ets"),
    F = fun([Key, PlayerList, Time]) ->
        F0 = fun({Pkey, Sn, Sex, NickName, Power, Fashionclothid, LightWeaponid, WingId, ClothingId, WeaponId}) ->
            #milestone_player_info{
                pkey = Pkey,
                sn = Sn,
                sex = Sex,
                nickname = NickName,
                power = Power,
                fashion_cloth_id = Fashionclothid,
                light_weaponid = LightWeaponid,
                wing_id = WingId,
                clothing_id = ClothingId,
                weapon_id = WeaponId
            }
        end,
        List = lists:map(F0, util:bitstring_to_term(PlayerList)),
        CrossGuardMilestone = #cross_guard_milestone{
            key = util:bitstring_to_term(Key),
            time = Time,
            player_list = List
        },
        ets:insert(?ETS_CROSS_DUNGEON_GUARD_MILESTONE, CrossGuardMilestone)
    end,
    lists:foreach(F, Data),
    ok.

log_cross_dungeon_guard(Key, Nickname, DunId, Floor, NewTime) ->
    ?DEBUG("*******~n"),
    Sql = io_lib:format("insert into  log_cross_dungeon_guard (pkey,nickname,dun_id,floor, use_time,time) VALUES(~p,'~s',~p,~p,~p,~p)",
        [Key, Nickname, DunId, Floor, NewTime, util:unixtime()]),
    log_proc:log(Sql),
    ok.
