%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 一月 2015 下午4:53
%%%-------------------------------------------------------------------
-module(scene_rpc).
-author("fancy").
-include("server.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("drop.hrl").
-include("goods.hrl").
-include("robot.hrl").
-include("cross_war.hrl").
-include("cross_boss.hrl").
-include("daily.hrl").
%% API
-export([handle/3]).

%% 共骑状态下玩家不能自己移动
handle(12001, Player, _) when Player#player.common_riding#common_riding.state =:= 2 ->
    ok;

%% 走路
handle(12001, Player, {X, Y, Type}) ->
    NowTime = util:unixtime(),
    X0 = Player#player.x, Y0 = Player#player.y,
%%    ?PRINT(" pkey ~p handle_12001 move new ~p/ ~p/~p   old ~p/~p longtime ~p~n", [Player#player.key, X, Y, Type, X0, Y0, util:longunixtime()]),
    UnMoveTime = Player#player.time_mark#time_mark.umt,
    case UnMoveTime > 0 andalso UnMoveTime > NowTime of
        true ->
%%            ?ERR("pkey ~p scene ~p x ~p y ~p unmove ~p Type ~p~n", [Player#player.key, Player#player.scene, X, Y, UnMoveTime, Type]),
            {ok, Player};
        false ->
            {X2, Y2} =
                if
                    Type == 1 ->  %%走路
                        if Player#player.figure > 0 ->
                            {X, Y};
                            true ->
                                case abs(X0 - X) > 8 orelse abs(Y0 - Y) > 10 of
                                    true ->
                                        {X0, Y0};
                                    false ->
                                        {X, Y}
                                end
                        end;
                    Type == 2 ->%%轻功
                        case scene:is_cross_eliminate_scene(Player#player.scene) orelse scene:is_prison_scene(Player#player.scene) of
                            false ->
                                case abs(X0 - X) > 8 orelse abs(Y0 - Y) > 10 of
                                    true ->
                                        {X0, Y0};
                                    false ->
                                        {X, Y}
                                end;
                            true ->
                                {X0, Y0}
                        end;
                    Type == 3 -> %%剧情
                        ?IF_ELSE(Player#player.lv < 40, {X, Y}, {X0, Y0});
                    Type == 4 -> %%修正
                        Can =
                            case get(jump_time) of
                                undefined ->
                                    true;
                                T ->
                                    ?IF_ELSE(NowTime - T > 10, true, false)
                            end,
                        put(jump_time, NowTime),
                        ?IF_ELSE(Can, {X, Y}, {X0, Y0});
                    Type == 5 ->%%跳跃点
                        {X, Y};
                    Type == 6 ->%%攻击位移
                        {X, Y};
                    Type == 7 ->%%主动跳跃
                        {X, Y};
                    Type == 88 andalso Player#player.pf == 888 ->  %%机器人
                        {X, Y};
                    true ->
                        case abs(X0 - X) > 8 orelse abs(Y0 - Y) > 12 of
                            true ->
                                ?ERR(" key ~p scene ~p walk err old ~p/~p new ~p/~p~n", [Player#player.key, Player#player.scene, X0, Y0, X, Y]),
                                {X0, Y0};
                            false ->
                                {X, Y}
                        end
                end,
            %%util:write("walk",io_lib:format("{~p,~p},",[X2,Y2])),
            scene_agent_dispatch:move(Player, X2, Y2, Type, NowTime),
            NewPlayer = Player#player{x = X2, y = Y2, sit_state = 0},
            %%队伍广播我的位置
            team_util:broadcast_position(NewPlayer, NowTime),
            %%双人坐骑状态需要带着另外一个人走
            mount:double_follow(Player, X2, Y2),
            if Player#player.sit_state == 1 ->
                scene_agent_dispatch:update_sit(NewPlayer),
                {ok, Bin} = pt_120:write(12059, {Player#player.key, 0,Player#player.show_golden_body}),
                server_send:send_to_sid(Player#player.sid, Bin);
                true ->
                    ok
            end,
            {ok, NewPlayer}

    end;

%% 加载场景
handle(12002, Player, _) ->
    TimeMark = Player#player.time_mark,
    %%每日进入场景增加保护
    Now = util:unixtime(),
    NewTimeMark = TimeMark#time_mark{godt = Now + 5},
    NewPlayer = Player#player{time_mark = NewTimeMark, sit_state = 0},
    scene_agent_dispatch:request_scene_data(NewPlayer),
    %%更新队伍成员位置
    team_util:broadcast_position(Player),
%%    put(enter_scene, {Player#player.scene, Player#player.copy}),
%%    put(msg_re_enter_scene, ok),
    if Player#player.sit_state == 0 -> ok;
        true ->
            {ok, Bin} = pt_120:write(12059, {Player#player.key, 0,Player#player.show_golden_body}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    {ok, NewPlayer};

%% 离开场景
handle(12004, Player, _) ->
    scene_agent_dispatch:leave_scene(Player),
    ok;


%% 共骑状态下玩家不能自己动
%%handle(12005, Player, _) when Player#player.common_riding#common_riding.state =:= 2 ->
%%    {ok, Bin} = pt_120:write(12038, {16}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ok;

%% 切换场景
handle(12005, Player, {Scene, TarCopy}) ->
    Now = util:unixtime(),
    Can =
        case get(change_scene) of
            {LastScene, LastCopy, LastTime} when LastScene /= Scene orelse LastCopy /= TarCopy orelse Now > LastTime + 3 ->
                true;
            undefined ->
                true;
            _ ->
                false
        end,
    ?DO_IF(Can, put(change_scene, {Scene, TarCopy, Now})),
    Copy = scene_copy_proc:get_scene_copy(Scene, TarCopy),
    case Player#player.scene == Scene andalso Player#player.copy == Copy of
        true when Can ->
            DataScene = data_scene:get(Scene),
            NewPlayer = scene_change:change_scene(Player, Scene, Copy, DataScene#scene.x, DataScene#scene.y, false),
            {ok, NewPlayer};
        false when Can ->
            case scene_check:check_enter(Player, Scene, Copy) of
                {false, Msg} ->
                    {ok, Bin} = pt_120:write(12005, {0, 0, 0, 0, Msg}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                {true, Player2, Scene2, Copy2, X, Y, _SceneName, _ResId} ->
                    NewPlayer = scene_change:change_scene(Player2, Scene2, Copy2, X, Y, false),
                    {ok, NewPlayer}
            end;
        _ ->
            {ok, Player}
    end;

%% 共骑状态下玩家不能自己动
handle(12015, Player, _) when Player#player.common_riding#common_riding.state =:= 2 ->
    {ok, Bin} = pt_120:write(12038, {16}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%场景目标传送
handle(12015, Player, {TargetType, TargetId, PosType}) ->
    {Ret, NewPlayer} = scene_transport:target_transport(TargetType, Player, TargetId, PosType),
    {ok, Bin} = pt_120:write(12015, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    NewPlayer1 = mount:double_leave_scene(NewPlayer, NewPlayer#player.scene, NewPlayer#player.copy, NewPlayer#player.x, NewPlayer#player.y),
    {ok, NewPlayer1};

%% 获取场景掉落物品列表
handle(12021, Player, _) ->
    case scene:is_cross_scene(Player#player.scene) of
        false ->
            DropGoodsList = drop_scene:get_scene_drop_list(Player#player.scene, Player#player.copy, Player#player.key),
            {ok, Bin} = pt_120:write(12021, {DropGoodsList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            cross_area:apply(drop_scene, get_cross_scene_drop_list, [node(), Player#player.pid, Player#player.scene, Player#player.copy, Player#player.key]),
            ok
    end;


%% 拾取掉落
handle(12023, Player, {[Key | _]}) ->
    case scene:is_cross_scene(Player#player.scene) of
        true ->
            case scene:is_cross_boss_scene(Player#player.scene) of
                true ->
                    St = lib_dict:get(?PROC_STATUS_CROSS_BOSS_DROP_NUM),
                    if
                        true ->
                            cross_area:apply(drop_scene, cross_pickup, [node(), Player#player.pid, Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Key, Player#player.key, Player#player.lv, St#st_player_cross_boss.drop_num, Player#player.sid]),
                            ok
                    end;
                _ ->
                    cross_area:apply(drop_scene, cross_pickup, [node(), Player#player.pid, Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Key, Player#player.key, Player#player.lv, 0, Player#player.sid])
            end;
        false ->
            DailyPickUpRedDrop = daily:get_count(?DAILY_RED_PICKUP),
            case drop_scene:pickup(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Key, Player#player.key,DailyPickUpRedDrop) of
                {fail, Code} ->
                    {ok, Bin} = pt_120:write(12023, {Code, Key, 0, 0, 0}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                {ok, DropGoods} ->
                    Player2 = drop:pickup(Player, DropGoods#drop_goods.mid, DropGoods#drop_goods.goodstype, DropGoods#drop_goods.num, DropGoods#drop_goods.bindtype, DropGoods#drop_goods.from, DropGoods#drop_goods.args),
                    {ok, Bin2} = pt_120:write(12023, {1, Key, DropGoods#drop_goods.goodstype, DropGoods#drop_goods.x, DropGoods#drop_goods.y}),
                    server_send:send_to_sid(Player#player.sid, Bin2),
                    ?DO_IF(DropGoods#drop_goods.from == 307, daily:increment(?DAILY_RED_PICKUP, 1)),
                    case scene:is_field_boss_scene(Player#player.scene) of
                        true ->
                            field_boss:log_field_boss(Player#player.key, Player#player.nickname, Player#player.scene, 0, [{DropGoods#drop_goods.goodstype, DropGoods#drop_goods.num}]);
                        false ->
                            skip
                    end,
                    {ok, Player2}
            end
    end;

%%飞鞋移动
handle(12047, Player, {SceneId, X0, Y0, Copy, MonId}) ->
    GoodsId = 1015000,
    {X, Y, CanMove} =
        case MonId > 0 of
            true ->
                case data_mon_transport:get(MonId) of
                    [] ->
                        {X0, Y0, scene:can_moved(SceneId, X0, Y0)};
                    [_, TarX, TarY] ->
                        {TarX1, TarY1} = scene:random_xy(SceneId, TarX, TarY),
                        {TarX1, TarY1, true}
                end;
            false -> {X0, Y0, scene:can_moved(SceneId, X0, Y0)}
        end,
    Res =
        if
            not CanMove -> {false, 19};
            true ->
                case Player#player.vip_lv < 2 of
                    true ->
                        GoodsCount = goods_util:get_goods_count(GoodsId),
                        if
                            GoodsCount =< 0 -> {false, 18};
                            true ->
                                {ok, 1}
                        end;
                    false ->
                        {ok, 0}
                end
        end,
    case Res of
        {false, Reason} ->
            {ok, Bin} = pt_120:write(12047, {Reason, 0, SceneId, X, Y}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, DelNum} ->
            case DelNum > 0 of
                true -> goods:subtract_good(Player, [{GoodsId, 1}], 510);
                false -> skip
            end,
            case SceneId == Player#player.scene of
                true ->
                    {ok, Bin} = pt_120:write(12047, {1, 1, SceneId, X, Y}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                false ->
                    Player1 = scene_change:change_scene(Player, SceneId, Copy, X, Y, false),
                    {ok, Bin} = pt_120:write(12047, {1, 0, SceneId, X, Y}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    {ok, Player1}
            end
    end;

%% 取消特效buff
handle(12049, Player, {BuffId}) ->
    buff_init:del_buff(BuffId),
    Player1 = buff:del_buff(Player, BuffId),
    {ok, Bin} = pt_120:write(12049, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player1};

handle(12051, Player, {}) ->
    {ok, Bin} = pt_120:write(12051, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    scene_agent_dispatch:transport_update(Player, 1),
    ok;

handle(12062, Player, {SceneId, Id}) ->
    PlayerSign = cross_area:war_apply_call(cross_war, get_player_sign, [Player]),
    case PlayerSign of
        ?CROSS_WAR_TYPE_DEF ->
            {Code, NewPlayer} = scene_transport:target_transport_x_y(Player, SceneId, Id),
            {ok, Bin} = pt_120:write(12062, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        _ -> ok
    end;

handle(_cmd, _Player, _Data) ->
    ok.

