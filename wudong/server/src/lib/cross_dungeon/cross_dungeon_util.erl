%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 十一月 2016 14:04
%%%-------------------------------------------------------------------
-module(cross_dungeon_util).
-author("hxming").
-include("common.hrl").
-include("dungeon.hrl").
-include("cross_dungeon.hrl").
-include("drop.hrl").
-include("achieve.hrl").
-include("sword_pool.hrl").
-include("goods.hrl").
-include("player_mask.hrl").
-include("daily.hrl").

%% API
-compile(export_all).

get_notice_player(_Player) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON),
    ?IF_ELSE(St#st_cross_dun.times >= ?CROSS_DUNGEON_TIMES, 0, 1).

set_times(Times) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON),
    lib_dict:put(?PROC_STATUS_CROSS_DUNGEON, St#st_cross_dun{times = Times}),
    ok.

%%获取副本通关信息
get_dun_list(Player) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON),
    F = fun(DunId) ->
        case lists:keymember(DunId, 1, St#st_cross_dun.dun_list) of
            false -> [DunId, 0];
            true -> [DunId, 1]
        end
    end,
    DunList = lists:map(F, data_dungeon_cross:dun_list()),

    TmesList = data_dungeon_cross_reward_lv:times_list(),
    F0 = fun(Times) ->
        case data_dungeon_cross_reward_lv:get(Times, Player#player.lv) of
            [] ->
                [];
            Base ->
                State = daily:get_count(?DAILY_CROSS_DUNGEON_DAILY_REWARD(Times), 0),
                FirstState = player_mask:get(?PLAYER_CROSS_DUNGEON_FIRST_REWARD(Times), 0),
                FirstReward =  goods:pack_goods(tuple_to_list(Base#base_dun_cross_reward_lv.first_reward)),
%%                Reward =  goods:pack_goods(tuple_to_list(Base#base_dun_cross_reward_lv.reward)),
                if
                    State == 1 ->
                        IsSameDate = util:is_same_date(util:unixtime(), FirstState),
                        if
                            (IsSameDate == true orelse FirstState == 0) andalso FirstReward  /= []->
                                [{Times, 2,2, goods:pack_goods(tuple_to_list(Base#base_dun_cross_reward_lv.first_reward))}];
                            true ->
                                [{Times, 2,1, goods:pack_goods(tuple_to_list(Base#base_dun_cross_reward_lv.reward))}]
                        end;
                    true ->
                        if
                            St#st_cross_dun.times >= Times ->
                                if
                                    FirstState == 0  andalso FirstReward  /= []->
                                        [{Times, 1,2, goods:pack_goods(tuple_to_list(Base#base_dun_cross_reward_lv.first_reward))}];
                                    true ->
                                        [{Times, 1,1, goods:pack_goods(tuple_to_list(Base#base_dun_cross_reward_lv.reward))}]
                                end;
                            true ->
                                IsSameDate = util:is_same_date(util:unixtime(), FirstState),
                                if
                                    (IsSameDate == true orelse FirstState == 0)  andalso FirstReward  /= []->
                                        [{Times, 0,2, goods:pack_goods(tuple_to_list(Base#base_dun_cross_reward_lv.first_reward))}];
                                    true ->
                                        [{Times, 0,1, goods:pack_goods(tuple_to_list(Base#base_dun_cross_reward_lv.reward))}]
                                end
                        end
                end
        end
    end,
    TimesReward = lists:flatmap(F0, TmesList),

    TmesList1 = data_dungeon_cross_reward:times_list(),
    F1 = fun(Times) ->
        XianStage = Player#player.xian_stage,
        case data_dungeon_cross_reward:get(Times) of
            [] -> [];
            Base ->
                GoodsList =
                    case XianStage of
                        0 -> Base#base_dun_cross_reward.dixian;
                        1 -> Base#base_dun_cross_reward.dixian;
                        2 -> Base#base_dun_cross_reward.tianxian;
                        3 -> Base#base_dun_cross_reward.jinxian;
                        4 -> Base#base_dun_cross_reward.xingjun;
                        5 -> Base#base_dun_cross_reward.xiandi;
                        6 -> Base#base_dun_cross_reward.shenzi;
                        7 -> Base#base_dun_cross_reward.tianshen;
                        _ -> Base#base_dun_cross_reward.manjie
                    end,
                RewardList = goods:pack_goods(tuple_to_list(GoodsList)),
                State = daily:get_count(?DAILY_CROSS_DUNGEON_DAILY_REWARD(Times), 0),
                if
                    State == 1 ->
                        [{Times, 2,1, RewardList}];
                    true ->
                        if
                            St#st_cross_dun.times >= Times ->
                                [{Times, 1,1, RewardList}];
                            true ->
                                [{Times, 0,1, RewardList}]
                        end
                end
        end
    end,
    TimesReward1 = lists:flatmap(F1, TmesList1),
    List1 = TimesReward ++ TimesReward1,
    List2 = lists:keysort(1, List1),
    ?DEBUG("List2 ~p~n",[List2]),
    {St#st_cross_dun.times, ?CROSS_DUNGEON_TIMES, Player#player.repute, DunList, [tuple_to_list(X) || X <- List2]}.

get_times_reward(Player, Times) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON),
    State = daily:get_count(?DAILY_CROSS_DUNGEON_DAILY_REWARD(Times), 0),
    if
        State == 1 -> {26, Player};
        true ->
            if
                St#st_cross_dun.times >= Times ->
                    daily:set_count(?DAILY_CROSS_DUNGEON_DAILY_REWARD(Times), 1),
                    case data_dungeon_cross_reward_lv:get(Times, Player#player.lv) of
                        [] ->
                            case cross_dungeon_util:get_extra_times_reward(Times, Player#player.xian_stage) of
                                [] -> {0, Player};
                                Reward ->
                                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(335, Reward)),
                                    {1, NewPlayer}
                            end;
                        Base ->
                            FirstState = player_mask:get(?PLAYER_CROSS_DUNGEON_FIRST_REWARD(Times), 0),
                            if
                                FirstState == 0 ->
                                    player_mask:set(?PLAYER_CROSS_DUNGEON_FIRST_REWARD(Times), util:unixtime()),
                                   Reward0 = tuple_to_list(Base#base_dun_cross_reward_lv.first_reward),
                                    if
                                        Reward0 == [] ->
                                            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(335, tuple_to_list(Base#base_dun_cross_reward_lv.reward))),
                                            {1, NewPlayer};
                                        true -> {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(335, tuple_to_list(Base#base_dun_cross_reward_lv.first_reward))),
                                            {1, NewPlayer}
                                    end;
                                true ->
                                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(335, tuple_to_list(Base#base_dun_cross_reward_lv.reward))),
                                    {1, NewPlayer}
                            end
                    end;
                true ->
                    {27, Player}
            end
    end.

%%增加系统玩家
add_shadow(Key) ->
    case get_room(Key) of
        [] -> false;
        Room ->
            MbLen = length(Room#ets_cross_dun_room.mb_list),
            ShadowLen = length([Mb#dungeon_mb.pkey || Mb <- Room#ets_cross_dun_room.mb_list, Mb#dungeon_mb.type == 1]),
            case MbLen >= ?CROSS_DUNGEON_Mb_LIM orelse ShadowLen >= MbLen of
                true -> false;
                false ->
                    KeyList = [Mb#dungeon_mb.pkey || Mb <- Room#ets_cross_dun_room.mb_list],
                    case shadow_proc:match_shadow_by_cbp(Room#ets_cross_dun_room.cbp, 1, KeyList, Room#ets_cross_dun_room.lv) of
                        [] -> false;
                        [Shadow] ->
                            Now = util:unixtime(),
                            Mb = dungeon_util:make_dungeon_mb(Shadow, Now),
                            NewMb = Mb#dungeon_mb{type = 1, node = none, is_ready = 1, sn = Shadow#player.sn, shadow = Shadow},
                            MbList = [NewMb | Room#ets_cross_dun_room.mb_list],
                            NewRoom = Room#ets_cross_dun_room{mb_list = MbList},
                            update_room(NewRoom),
                            refresh_room(NewRoom),
                            check_open(NewRoom),
                            {true, Room#ets_cross_dun_room.shadow_time}
                    end
            end
    end.

%%离线
logout(Player) ->
    cross_dungeon_init:logout(),
    if Player#player.cross_dun_state /= 0 ->
        cross_all:apply(cross_dungeon_proc, logout, [Player#player.cross_dun_state, Player#player.key]);
        true ->
            ok
    end,
    case dungeon_util:is_dungeon_cross(Player#player.scene) of
        false -> ok;
        true ->
            cross_all:apply(cross_dungeon, logout, [Player#player.key, Player#player.copy])
    end,
    ok.

%%离开房间处理
do_quit(Room, Pkey, IsUpdate) ->
    MbList =
        case lists:keytake(Pkey, #dungeon_mb.pkey, Room#ets_cross_dun_room.mb_list) of
            false -> Room#ets_cross_dun_room.mb_list;
            {value, QMb, T} ->
                if IsUpdate ->
                    server_send:send_node_pid(QMb#dungeon_mb.node, QMb#dungeon_mb.pid, {cross_dun_state, 0});
                    true -> ok
                end,
                T
        end,

    case [MbItem || MbItem <- MbList, MbItem#dungeon_mb.type == 0] of
        [] ->
            %%没人了,解散房间
            delete_room(Room#ets_cross_dun_room.key);
        MbList1 ->
            ShadowTime = max(?CROSS_DUNGEON_SHADOW_SUB, Room#ets_cross_dun_room.shadow_time - ?CROSS_DUNGEON_SHADOW_SUB),
            NewRoom =
                if Pkey == Room#ets_cross_dun_room.pkey ->
                    %%房主切换
                    Mb = hd(lists:keysort(#dungeon_mb.join_time, MbList1)),
                    Room#ets_cross_dun_room{
                        mb_list = MbList,
                        sn = Mb#dungeon_mb.sn,
                        pkey = Mb#dungeon_mb.pkey,
                        nickname = Mb#dungeon_mb.nickname,
                        career = Mb#dungeon_mb.career,
                        sex = Mb#dungeon_mb.sex,
                        shadow_time = ShadowTime,
                        ready_ref = none};
                    true ->
                        Room#ets_cross_dun_room{mb_list = MbList, ready_ref = none, shadow_time = ShadowTime}
                end,
            ?DO_IF(Room#ets_cross_dun_room.password == "", self() ! {check_add_shadow, Room#ets_cross_dun_room.key, ShadowTime}),
            update_room(NewRoom),
            check_cancel_ready(Room),
            refresh_room(NewRoom)
    end.


%%检查取消准备
check_cancel_ready(Room) ->
    if Room#ets_cross_dun_room.ready_ref == none ->
        ok;
        true ->
            {ok, Bin} = pt_123:write(12310, {0, 0}),
            send_to_leader(Room, Bin),
            self() ! {cancel_ready, Room#ets_cross_dun_room.ready_ref}
    end.

%%通知退出
notice_kickout(Mb) ->
    if Mb#dungeon_mb.node /= none ->
        {ok, Bin} = pt_123:write(12307, {17}),
        server_send:send_to_sid(Mb#dungeon_mb.node, Mb#dungeon_mb.sid, Bin);
%%        center:apply(Mb#dungeon_mb.node, server_send, send_to_sid, [Mb#dungeon_mb.sid, Bin]);
        true ->
            ok
    end.


%%刷新房间信息
refresh_room(Room) ->
    Data = pack_room(Room),
    {ok, Bin} = pt_123:write(12304, Data),
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
    lists:foreach(F, Room#ets_cross_dun_room.mb_list).

%%通知房主
send_to_leader(Room, Bin) ->
    case lists:keyfind(Room#ets_cross_dun_room.pkey, #dungeon_mb.pkey, Room#ets_cross_dun_room.mb_list) of
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
    MbList = lists:map(F, Room#ets_cross_dun_room.mb_list),
    Cd = max(0, Room#ets_cross_dun_room.cd - util:unixtime()),
    {Room#ets_cross_dun_room.dun_id, Room#ets_cross_dun_room.key, Room#ets_cross_dun_room.pkey, Room#ets_cross_dun_room.is_fast, Room#ets_cross_dun_room.password, Cd, MbList}.


%%检查开启
check_open(Room) ->
    case length(Room#ets_cross_dun_room.mb_list) >= ?CROSS_DUNGEON_Mb_LIM of
        false -> ok;
        true ->
            F = fun(Mb) -> Mb#dungeon_mb.is_ready > 0 end,
            case lists:all(F, Room#ets_cross_dun_room.mb_list) of
                false ->
                    ok;
                true ->
                    self() ! {ready_dungeon, Room#ets_cross_dun_room.key}
            end
    end.

%%开启副本处理
do_open_dungeon(Key) ->
    case get_room(Key) of
        [] -> ok;
        Room ->
            util:cancel_ref([Room#ets_cross_dun_room.ready_ref]),
            delete_room(Room#ets_cross_dun_room.key),
            add_in_pro_room(Room),
            %%通知玩家进入
            WaitTime = 3,
            {ok, Bin} = pt_123:write(12315, {1, WaitTime}),
            F = fun(Mb) ->
                if Mb#dungeon_mb.node /= none andalso Mb#dungeon_mb.type == ?DUN_MB_TYPE_NORMAL ->
                    server_send:send_to_sid(Mb#dungeon_mb.node, Mb#dungeon_mb.sid, Bin);
%%                    center:apply(Mb#dungeon_mb.node, server_send, send_to_sid, [Mb#dungeon_mb.sid, Bin]),
                    ok;
                    true ->
                        ok
                end
            end,
            lists:foreach(F, Room#ets_cross_dun_room.mb_list),
            spawn(fun() -> util:sleep(WaitTime * 1000), create_dungeon(Room) end),
            ok
    end,
    ok.

cmd_enter(Mb, DunId) ->
    DunList = data_dungeon_cross:dun_list(),
    case lists:member(DunId, DunList) of
        false -> ok;
        true ->
            Now = util:unixtime(),
            Base = data_dungeon:get(DunId),
            Room = #ets_cross_dun_room{
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
                shadow_time = ?CROSS_DUNGEON_SHADOW_TIME
            },
            Scene = data_scene:get(Room#ets_cross_dun_room.dun_id),
            DunPid = cross_dungeon:start(Room, Now),
            server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, {enter_cross_dungeon_scene, Room#ets_cross_dun_room.dun_id, DunPid, Scene#scene.x, Scene#scene.y, ?GROUP_DUNGEON, 0}),
            ok
    end.


create_dungeon(Room) ->
    Now = util:unixtime(),
    Scene = data_scene:get(Room#ets_cross_dun_room.dun_id),
    BuffId = check_buff(Room#ets_cross_dun_room.dun_id, Room#ets_cross_dun_room.mb_list),
    DunPid = cross_dungeon:start(Room#ets_cross_dun_room{buff_id = BuffId}, Now),
    F = fun(Mb) ->
        if Mb#dungeon_mb.node /= none andalso Mb#dungeon_mb.type == ?DUN_MB_TYPE_NORMAL ->
            server_send:send_node_pid(Mb#dungeon_mb.node, Mb#dungeon_mb.pid, {enter_cross_dungeon_scene, Room#ets_cross_dun_room.dun_id, DunPid, Scene#scene.x, Scene#scene.y, ?GROUP_DUNGEON, BuffId}),
            ok;
            true ->
                {NewX, NewY} = scene:random_xy(Scene#scene.id, Scene#scene.x, Scene#scene.y),
                %%AI创建
                shadow:create_shadow_for_dungeon_team(Mb#dungeon_mb.shadow, Room#ets_cross_dun_room.dun_id, DunPid, NewX, NewY),
                ok
        end
    end,
    lists:foreach(F, Room#ets_cross_dun_room.mb_list).

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
    case data_dungeon_cross:get(DunId) of
        [] -> 0;
        Base -> Base#base_dun_cross.buff_id
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
    if Player#player.cross_dun_state /= 0 -> ok;
        true ->
            case scene:is_normal_scene(Player#player.scene) of
                false -> ok;
                true ->
                    {ok, Bin} = pt_123:write(12313, {Nickname, DunId, Key, Password}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end
    end,
    ok.


%%副本结算
dun_cross_ret(1, DunId, Player, Key, Password, IsFast, AutoReady, IsExtraPt) ->
    St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON),
    NewSt = cross_dungeon_init:update_dungeon_times(St, DunId),
    Base = data_dungeon_cross:get(DunId),
    GoodsList1 = get_reward(NewSt, DunId, Base, IsExtraPt, Player#player.world_lv_add, St#st_cross_dun.dun_list),
%%     GoodsList2 = get_extra_times_reward(NewSt#st_cross_dun.times, Player#player.xian_stage),
%%     GoodsList3 = get_extra_times_reward_lv(NewSt#st_cross_dun.times, Player#player.lv),
%%     GoodsList4 = get_extra_times_reward_first(DunId, NewSt#st_cross_dun.times),
    GoodsList = GoodsList1,
    RewardList = goods:make_give_goods_list(201, GoodsList),
    {ok, NewPlayer} =
        case RewardList of
            [] -> {ok, Player};
            _ ->
                goods:give_goods(Player, RewardList)
        end,
    PackGoodsList = [[Gid, Num, 1] || {Gid, Num} <- GoodsList1],
    {ok, Bin} = pt_123:write(12322, {1, DunId, Key, Password, IsFast, AutoReady, PackGoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    log_cross_dun(Player#player.key, Player#player.nickname, DunId, GoodsList),
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2011, 0, 1),
    act_hi_fan_tian:trigger_finish_api(Player, 8, 1),
    sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_DUN_CROSS),
    dungeon_util:add_dungeon_times(DunId),
    findback_src:fb_trigger_src(Player, 44, 1),
    activity:get_notice(NewPlayer, [104], true),
    NewPlayer;

dun_cross_ret(_, DunId, Player, Key, Password, IsFast, AutoReady, _IsExtraPt) ->
    {ok, Bin} = pt_123:write(12322, {0, DunId, Key, Password, IsFast, AutoReady, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player.

get_reward(St, DunId, Base, IsExtraPt, WorldLvAdd, DunList) ->
    GoodsList =
        case St#st_cross_dun.times > ?CROSS_DUNGEON_TIMES of
            true ->
                ExtraReward = extra_reward(Base#base_dun_cross.extra_drop),
                FirstReward = first_reward(DunList, DunId, Base#base_dun_cross.first_drop),
                goods:merge_goods(FirstReward ++ ExtraReward);
            false ->
                FirstReward = first_reward(DunList, DunId, Base#base_dun_cross.first_drop),
                PassReward = pass_reward(Base#base_dun_cross.pass_drop),
                ExtraReward = extra_reward(Base#base_dun_cross.extra_drop),
                goods:merge_goods(FirstReward ++ PassReward ++ ExtraReward)
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

%%获取额外固定次数奖励(飞仙)
get_extra_times_reward(Times, XianStage) ->
    case data_dungeon_cross_reward:get(Times) of
        [] -> [];
        Base ->
            GoodsList =
                case XianStage of
                    0 -> Base#base_dun_cross_reward.dixian;
                    1 -> Base#base_dun_cross_reward.dixian;
                    2 -> Base#base_dun_cross_reward.tianxian;
                    3 -> Base#base_dun_cross_reward.jinxian;
                    4 -> Base#base_dun_cross_reward.xingjun;
                    5 -> Base#base_dun_cross_reward.xiandi;
                    6 -> Base#base_dun_cross_reward.shenzi;
                    7 -> Base#base_dun_cross_reward.tianshen;
                    _ -> Base#base_dun_cross_reward.manjie
                end,
            tuple_to_list(GoodsList)
    end.



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
        if Room#ets_cross_dun_room.dun_id == DunId -> [Room];
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
            Room = #ets_cross_dun_room{
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
                shadow_time = ?CROSS_DUNGEON_SHADOW_TIME
            },
            update_room(Room),
            self() ! {set_timeout, Room#ets_cross_dun_room.key},
            [Room]
    end.

%%获取房间
get_room(Key) ->
    case get(room_list) of
        undefined ->
            [];
        L ->
            case lists:keyfind(Key, #ets_cross_dun_room.key, L) of
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
            put(room_list, [Room | lists:keydelete(Room#ets_cross_dun_room.key, #ets_cross_dun_room.key, L)])
    end.

%%删除房间
delete_room(Key) ->
    self() ! {cancel_timeout, Key},
    case get(room_list) of
        undefined ->
            put(room_list, []);
        L ->
            case lists:keytake(Key, #ets_cross_dun_room.key, L) of
                false ->
                    ok;
                {value, _, L1} ->
                    put(room_list, L1)
            end
    end.


%%检查是否在房间中[Mon || {_Key, Mon} <- AllData, is_record(Mon, mon)].
check_in_room(Pkey) ->
    F = fun(Room) ->
        case lists:keyfind(Pkey, #dungeon_mb.pkey, Room#ets_cross_dun_room.mb_list) of
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
            lists:sublist([Room || Room <- L, Room#ets_cross_dun_room.dun_id == DunId, Room#ets_cross_dun_room.pkey /= Pkey], 3)
    end.

%%增加进行中的房间
add_in_pro_room(Room) ->
    ?DEBUG("add_in_pro_room ~p~n", [Room#ets_cross_dun_room.key]),
    case get(in_pro_room_list) of
        undefined ->
            put(in_pro_room_list, [Room#ets_cross_dun_room{state = 1}]);
        L ->
            put(in_pro_room_list, lists:keydelete(Room#ets_cross_dun_room.key, #ets_cross_dun_room.key, L) ++ [Room#ets_cross_dun_room{state = 1}])
    end.

delete_in_pro_room(Key) ->
    case get(in_pro_room_list) of
        undefined ->
            put(in_pro_room_list, []);
        L ->
            case lists:keytake(Key, #ets_cross_dun_room.key, L) of
                false ->
                    ok;
                {value, _, L1} ->
                    ?DEBUG("del_in_pro_room ~p~n", [Key]),
                    put(in_pro_room_list, L1)
            end
    end.