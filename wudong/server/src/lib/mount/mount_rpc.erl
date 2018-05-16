%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 一月 2015 14:04
%%%-------------------------------------------------------------------
-module(mount_rpc).
-include("common.hrl").
-include("server.hrl").
-include("mount.hrl").
-include("goods.hrl").
-include("scene.hrl").
-include("error_code.hrl").
-include("task.hrl").

%% API
-export([
    handle/3
]).

%%获取当前坐骑信息
handle(17001, Player, _) ->
    Mount = mount_util:get_mount(),
    mount_pack:send_mount_info(Mount, Player),
    ok;

%%坐骑升阶
handle(17002, Player, {Auto}) ->
    case mount_stage:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_170:write(17002, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            task_event:event(?TASK_ACT_MOUNT_STEP, {1}),
            {ok, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_170:write(17002, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%选择外观
handle(17004, Player, {ImageId}) ->
    ?DEBUG("ImageId ~p~n",[ImageId]),
    case catch mount:select_image(ImageId, Player) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_170:write(17004, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            case mount_rpc:handle(17020, NewPlayer, []) of
                {ok, NewPlayer1} -> {ok, NewPlayer1};
                _ -> {ok, NewPlayer}
            end;
        {false, ErrorCode} ->
            {ok, Bin} = pt_170:write(17004, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%使用道具激活坐骑
%%handle(17005, Player, {ImageId}) ->
%%    case catch mount:activate(Player, ImageId) of
%%        {ok, NewPlayer} ->
%%            {ok, Bin} = pt_170:write(17005, {?ER_SUCCEED}),
%%            server_send:send_to_sid(Player#player.sid, Bin),
%%            {ok, mount, NewPlayer};
%%        _OtherError ->
%%            %?PRINT("17004 _OtherError ~p ~n", [_OtherError]),
%%            {ok, Bin} = pt_170:write(17005, {?ER_FAIL}),
%%            server_send:send_to_sid(Player#player.sid, Bin),
%%            ok
%%    end;

%%上坐骑
handle(17006, Player, {Type, MountType}) ->
    case Type of
        ?MOUNT_STATE_OFF ->
            Player1 = Player#player{mount_id = 0},
            {ok, Bin} = pt_170:write(17006, {?ER_SUCCEED, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            NewPlayer = player_util:count_player_speed(Player1, true),
            {ok, mount, NewPlayer};
        _ ->
            if
                Player#player.scene == ?SCENE_ID_BATTLEFIELD orelse Player#player.scene == ?SCENE_ID_CROSS_ELIMINATE orelse Player#player.scene == ?SCENE_ID_CROSS_WAR ->
                    %%战场，不能上坐骑
                    {ok, Bin} = pt_170:write(17006, {20, 0}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                true ->
                    MountId = mount_util:get_mount_image(MountType),
                    Player1 = Player#player{mount_id = MountId},
                    {ok, Bin} = pt_170:write(17006, {?ER_SUCCEED, MountId}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    NewPlayer = player_util:count_player_speed(Player1, true),
                    {ok, mount, NewPlayer}
            end
    end;

handle(17007, Player, {}) ->
    Mount = mount_util:get_mount(),
    StarList = [tuple_to_list(Star) || Star <- Mount#st_mount.star_list],
    {ok, Bin} = pt_170:write(17007, StarList),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%坐骑升星
handle(17013, Player, {MountId}) ->
    case catch mount:upgrade_star(Player, MountId) of
        {ok, NewPlayer} ->
            fashion_suit:active_icon_push(NewPlayer),
            {ok, Bin} = pt_170:write(17013, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {false, Code} ->
            %?PRINT("17013 _OtherError ~p ~n",[Code]),
            {ok, Bin} = pt_170:write(17013, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%邀请玩家共乘
handle(17017, Player, {Pkey, Type}) ->
    NowTime = util:unixtime(),
    case catch data_mount:get(Player#player.mount_id) of
        _ when Player#player.convoy_state > 0 ->
            {ok, Bin} = pt_170:write(17017, {33}),
            server_send:send_to_sid(Player#player.sid, Bin);
        _ when Player#player.time_mark#time_mark.lat > 0 andalso Player#player.time_mark#time_mark.lat + 3 > NowTime ->
            {ok, Bin} = pt_170:write(17017, {33}),
            server_send:send_to_sid(Player#player.sid, Bin);
        _ when Player#player.common_riding#common_riding.state > 0 ->
            {ok, Bin} = pt_170:write(17017, {32}),
            server_send:send_to_sid(Player#player.sid, Bin);
        _ when Player#player.scene == ?SCENE_ID_PRISON ->
            {ok, Bin1} = pt_170:write(17017, {35}),
            server_send:send_to_sid(Player#player.sid, Bin1);
        {false, _} when Type == 1 ->
            {ok, Bin1} = pt_170:write(17017, {30}),
            server_send:send_to_sid(Player#player.sid, Bin1);
        BaseMount when (is_record(BaseMount, base_mount) andalso BaseMount#base_mount.is_double =:= 1) orelse Type =:= 2 ->
            case player_util:get_player_online(Pkey) of
                [] ->
                    {ok, Bin} = pt_170:write(17017, {31}),
                    server_send:send_to_sid(Player#player.sid, Bin);
                Online ->
                    Online#ets_online.pid ! {invite_double_mount, Player#player.key, Player#player.nickname, Player#player.sid, Type}
            end;
        _ ->
            {ok, Bin} = pt_170:write(17017, {30}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok;

%同意共骑
handle(17019, Player, {Pkey, Type, 1}) when Type == 1 orelse Type == 2 ->
    case player_util:get_player(Pkey) of
        [] ->
            ok;
        OtherPlayer when OtherPlayer#player.scene =/= Player#player.scene orelse OtherPlayer#player.copy =/= Player#player.copy ->
            {ok, Bin} = pt_170:write(17017, {34}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        OtherPlayer ->
            ?DEBUG("OtherPlayer#player.mount_id ~p~n", [OtherPlayer#player.mount_id]),
            case scene_calc:is_area_scene(OtherPlayer#player.x, OtherPlayer#player.y, Player#player.x, Player#player.y) of
                false ->
                    {ok, Bin} = pt_170:write(17017, {34}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                true ->
                    if Type == 1 ->
                        Mount = data_mount:get(OtherPlayer#player.mount_id),
                        if
                            Mount == [] -> Flag = 29;
                            Mount#base_mount.is_double =/= 1 -> Flag = 29;
                            Player#player.common_riding#common_riding.state =/= 0 orelse
                                OtherPlayer#player.common_riding#common_riding.state =/= 0 ->
                                Flag = 0;
                            true -> Flag = 1
                        end;
                        true ->
                            Mount = data_mount:get(Player#player.mount_id),
                            if
                                Mount == [] -> Flag = 29;
                                Mount#base_mount.is_double =/= 1 -> Flag = 30;
                                Player#player.common_riding#common_riding.state =/= 0 orelse OtherPlayer#player.common_riding#common_riding.state =/= 0 ->
                                    Flag = 0;
                                true -> Flag = 1
                            end
                    end,
                    if Flag =/= 1 ->
                        {ok, Bin} = pt_170:write(17017, {Flag}),
                        server_send:send_to_sid(Player#player.sid, Bin),
                        ok;
                        true ->
                            case Type of
                                1 ->  %同意邀请,自己是共骑者，别人是主骑者
                                    SelfCommonRiding = #common_riding{state = 2, main_pkey = Pkey, common_pkey = Player#player.key, common_pid = OtherPlayer#player.pid},
                                    OtherCommonRiding = #common_riding{state = 1, main_pkey = Pkey, common_pkey = Player#player.key, common_pid = self()};
                                2 -> %同意请求,自己是主骑者，别人共骑者
                                    SelfCommonRiding = #common_riding{state = 1, main_pkey = Player#player.key, common_pkey = Pkey, common_pid = OtherPlayer#player.pid},
                                    OtherCommonRiding = #common_riding{state = 2, main_pkey = Player#player.key, common_pkey = Pkey, common_pid = self()}
                            end,
                            NewPlayer = Player#player{common_riding = SelfCommonRiding},
                            {ok, Bin} = pt_170:write(17019, {1, Player#player.nickname, 1}),
                            server_send:send_to_sid(OtherPlayer#player.sid, Bin),
                            OtherPlayer#player.pid ! {accept_commom_mount, OtherCommonRiding, Player#player.x, Player#player.y},
                            scene_agent_dispatch:common_riding(NewPlayer),
                            if
                                Player#player.mount_id == 0 ->
                                    Mount1 = mount_util:get_mount(),
                                    NewPlayer1 = NewPlayer#player{mount_id = Mount1#st_mount.current_image_id},
                                    {ok, Bin17006} = pt_170:write(17006, {?ER_SUCCEED, Mount1#st_mount.current_image_id}),
                                    server_send:send_to_sid(Player#player.sid, Bin17006);
                                true ->
                                    NewPlayer1 = NewPlayer
                            end,
                            {ok, NewPlayer1}
                    end
            end
    end;

%拒绝共同骑行
handle(17019, Player, {Pkey, Type, 2}) ->
    case player_util:get_player_online(Pkey) of
        [] ->
            ok;
        Online ->
            {ok, Bin} = pt_170:write(17021, {Player#player.nickname, Type}),
            server_send:send_to_sid(Online#ets_online.sid, Bin),
            ok
    end;

%共骑下马
handle(17020, Player, _) ->
    if
        Player#player.common_riding#common_riding.state > 0 ->
            catch Player#player.common_riding#common_riding.common_pid ! cancel_commom_mount,
            NewPlayer = Player#player{common_riding = Player#player.common_riding#common_riding{state = 0}},
            scene_agent_dispatch:common_riding(NewPlayer),
            {ok, Bin} = pt_170:write(17020, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, Bin12307} = pt_120:write(12037, {Player#player.common_riding#common_riding.main_pkey, Player#player.common_riding#common_riding.common_pkey, 0}),
            server_send:send_to_sid(Player#player.sid, Bin12307),
            {ok, NewPlayer};
        true ->
            ok
    end;

%%激活技能
handle(17030, Player, {Cell}) ->
    {Ret, NewPlayer} = mount_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_170:write(17030, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(17031, Player, {Cell}) ->
    {Ret, NewPlayer} = mount_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_170:write(17031, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(17032, Player, {}) ->
    Mount = mount_util:get_mount(),
    Data = mount_skill:get_mount_skill_list(Mount#st_mount.skill_list),
    {ok, Bin} = pt_170:write(17032, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%装备
handle(17033, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = mount:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_170:write(17033, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;


%% 使用坐骑成长丹
handle(17034, Player, {}) ->
    case mount:use_mount_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_170:write(17034, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_170:write(17034, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;


%%领取外观
handle(17035, Player, {}) ->
    NewPlayer = mount_init:mount_activate(Player),
    {ok, Bin} = pt_170:write(17035, {?ER_SUCCEED}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


handle(17036, Player, {}) ->
    Data = mount_spirit:spirit_info(),
    {ok, Bin} = pt_170:write(17036, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%灵脉升级
handle(17037, Player, {}) ->
    {Ret, NewPlayer} = mount_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_170:write(17037, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;

%% 获取场景中可邀请玩家
handle(17038, Player, {}) ->
    Data = mount:get_near_people(Player),
    {ok, Bin} = pt_170:write(17038, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取好友
handle(17039, Player, {}) ->
    Data = mount:get_friends(Player),
    {ok, Bin} = pt_170:write(17039, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%激活等级加成
handle(17040, Player, {MountId}) ->
    {Ret, NewPlayer} = mount:activation_stage_lv(Player, MountId),
    {ok, Bin} = pt_170:write(17040, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_Cmd, _Player, _Data) ->
    ?PRINT("_Cmd ~p _Data ~p ~n", [_Cmd, _Data]),
    ok.
