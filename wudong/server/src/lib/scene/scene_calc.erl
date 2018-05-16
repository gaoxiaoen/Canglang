%%%-----------------------------------
%%% @Module  : scene_calc
%%% @Author  : hzj
%%% @Email   : 1812338@qq.com
%%% @Created : 2015.7
%%% @Description: 场景广播算法
%%%-----------------------------------
-module(scene_calc).
-export([
    get_xy/2,
    get_round_point/4,
    move_broadcast/9,
    is_area_scene/4,
    get_the_area/2,
    move_mon_broadcast/4
]).
-export([cmd_test/0]).

-include("common.hrl").
-include("scene.hrl").
-define(LENGTH, 8). %x  x个x坐标为一格
-define(WIDTH, 10). %y   x个y坐标为一格
-define(MAP_LENGTH, 200).  %假设横坐标的格子数
% 以九宫格为坐标原点的参考坐标系
-define(MAP_LENGTH_M, 0).                   % 九宫格中间格子
-define(MAP_LENGTH_R, 1).                   % 九宫格右边格子
-define(MAP_LENGTH_L, -1).                  % 九宫格左边格子 
-define(MAP_LENGTH_U, -?MAP_LENGTH).        % 九宫格上边格子
-define(MAP_LENGTH_D, ?MAP_LENGTH).         % 九宫格下边格子
-define(MAP_LENGTH_LU, -(?MAP_LENGTH + 1)).   % 九宫格左上边格子
-define(MAP_LENGTH_LD, (?MAP_LENGTH - 1)).    % 九宫格左下边格子
-define(MAP_LENGTH_RU, -(?MAP_LENGTH - 1)).   % 九宫格右上边格子
-define(MAP_LENGTH_RD, ?MAP_LENGTH + 1).      % 九宫格右下边格子

%% 获取当前所在的格子的编号
get_xy(X, Y) ->
    Y div ?WIDTH * ?MAP_LENGTH + X div ?LENGTH + 1.

%% 获取九宫格编号列表
get_the_area(X, Y) ->
    XY = get_xy(X, Y),
    [XY, XY + ?MAP_LENGTH_R, XY + ?MAP_LENGTH_L, XY + ?MAP_LENGTH_U, XY + ?MAP_LENGTH_D, XY + ?MAP_LENGTH_LU, XY + ?MAP_LENGTH_RD, XY + ?MAP_LENGTH_RU, XY + ?MAP_LENGTH_LD].

%% 获取范围坐标
get_round_point(X, Y, X2, Y2) ->
    if X > 2 andalso Y > 2 ->
        Plist =
            case util:get_direction(X, Y, X2, Y2) of
                1 ->
                    [{X + 1, Y}, {X + 2, Y}, {X + 1, Y + 1}, {X + 1, Y + 2}, {X + 2, Y + 1}, {X + 1, Y - 1}, {X + 1, Y - 2}, {X + 2, Y - 1}];
                2 ->
                    [{X, Y + 1}, {X, Y + 2}, {X + 1, Y + 1}, {X + 2, Y + 1}, {X + 1, Y + 2}, {X - 1, Y + 1}, {X - 2, Y + 1}, {X - 1, Y + 2}];
                3 ->
                    [{X - 1, Y}, {X - 2, Y}, {X - 1, Y + 1}, {X - 2, Y + 2}, {X - 2, Y + 1}, {X - 1, Y - 1}, {X - 1, Y - 2}, {X - 2, Y - 1}];
                4 ->
                    [{X, Y - 1}, {X, Y - 2}, {X - 1, Y - 1}, {X - 2, Y - 1}, {X - 1, Y - 2}, {X + 1, Y - 1}, {X + 2, Y - 1}, {X + 1, Y - 2}];
                5 -> [{X + 1, Y}, {X, Y - 1}, {X + 1, Y - 1}, {X + 2, Y - 1}, {X + 1, Y - 2}];
                6 -> [{X + 1, Y}, {X + 2, Y + 1}, {X + 1, Y + 1}, {X + 1, Y + 2}, {X, Y + 1}];
                7 -> [{X, Y + 1}, {X - 1, Y}, {X - 2, Y + 1}, {X - 1, Y + 1}, {X - 1, Y + 2}];
                8 -> [{X - 1, Y}, {X, Y - 1}, {X - 1, Y - 1}, {X - 1, Y - 2}, {X - 2, Y - 1}];
                _ -> [{X, Y}]
            end,
        util:list_rand(Plist);
        true ->
            {X, Y}
    end.

%%是否在9宫格内
is_area_scene(X1, Y1, X2, Y2) ->
    XY2 = get_xy(X2, Y2),
    XY = get_xy(X1, Y1),
    if
        XY == XY2 orelse XY == XY2 + ?MAP_LENGTH_R orelse XY == XY2 + ?MAP_LENGTH_L orelse XY == XY2 + ?MAP_LENGTH_U orelse XY == XY2 + ?MAP_LENGTH_D orelse XY == XY2 + ?MAP_LENGTH_LU orelse XY == XY2 + ?MAP_LENGTH_RD orelse XY == XY2 + ?MAP_LENGTH_RU orelse XY == XY2 + ?MAP_LENGTH_LD ->
            true;
        true ->
            false
    end.


%%当人物或者怪物移动时候的广播
%%终点要X1，Y1，原点是X2,Y2
%%BinData走路协议包, BinData1移除玩家包 BinData2有玩家进入
%%MoveInfoList [Key,sid]
move_broadcast(Copy, X1, Y1, X2, Y2, BinData, BinData1, BinData2, MoveInfoList) ->
    XY1 = get_xy(X1, Y1),
    XY2 = get_xy(X2, Y2),
    move_user_broadcast(Copy, XY1, XY2, BinData, BinData1, BinData2, MoveInfoList),
    %%人物移动MoveInfoList非空
    case MoveInfoList =/= [] of
        true ->
            move_mon_broadcast(Copy, XY1, XY2, MoveInfoList);
        false ->
            skip
    end.

%% 广播给玩家
move_user_broadcast(Copy, XY1, XY2, BinData, BinData1, BinData2, MoveInfoList) ->
    [SceneUserList, SceneUserKey] = if
                                        XY2 == XY1 -> %% 同一个格子内移动
                                            move_ZERO([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList);
                                        XY2 + ?MAP_LENGTH_R == XY1 -> %% 向右移动
                                            move_R([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList);
                                        XY2 + ?MAP_LENGTH_L == XY1 -> %% 向左移动
                                            move_L([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList);
                                        XY2 + ?MAP_LENGTH_U == XY1 -> %% 向上移动
                                            move_U([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList);
                                        XY2 + ?MAP_LENGTH_D == XY1 -> %% 向下移动
                                            move_D([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList);
                                        XY2 + ?MAP_LENGTH_LU == XY1 -> %% 向左上移动
                                            move_LU([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList);
                                        XY2 + ?MAP_LENGTH_LD == XY1 -> %% 向左下移动
                                            move_LD([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList);
                                        XY2 + ?MAP_LENGTH_RU == XY1 -> %% 向右上移动
                                            move_RU([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList);
                                        XY2 + ?MAP_LENGTH_RD == XY1 -> %% 向右下移动
                                            move_RD([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList);
                                        true -> %% 跨相邻九宫格移动
                                            move_OTHER_ZERO([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList)
                                    end,
%%    ?PRINT("SceneUserList:~p~n", [length(SceneUserList)]),
    case MoveInfoList =:= [] orelse (SceneUserList == [] andalso SceneUserKey == []) of
        true ->
            ok;
        false ->
            %%加入和移除玩家,如果加入和移除的是同一目标的情况,则不处理
            {ok, BinData3} = pt_120:write(12009, {scene_pack:pack_scene_player_helper(SceneUserList), SceneUserKey}),
            [_pkey, Sid] = MoveInfoList,
            server_send:send_to_sid(Sid, BinData3)
    end.

move_ZERO([Copy, _XY1, XY2, BinData, _BinData1, _BinData2], MoveInfoList) ->
    Area = [XY2, XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_RU, XY2 + ?MAP_LENGTH_LD],
    scene_agent:move_send_to_any_area(Area, Copy, BinData, MoveInfoList),
    [[], []].

move_OTHER_ZERO([Copy, XY1, XY2, _BinData, BinData1, BinData2], _MoveInfoList) ->
    Area1 = [XY1, XY1 + ?MAP_LENGTH_R, XY1 + ?MAP_LENGTH_L, XY1 + ?MAP_LENGTH_U, XY1 + ?MAP_LENGTH_D, XY1 + ?MAP_LENGTH_LU, XY1 + ?MAP_LENGTH_RD, XY1 + ?MAP_LENGTH_RU, XY1 + ?MAP_LENGTH_LD],
    User1 = scene_agent:move_send_and_getuser(Area1, Copy, BinData2),
    Area2 = [XY2, XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_RU, XY2 + ?MAP_LENGTH_LD],
    User2 = scene_agent:move_send_and_getkey(Area2, Copy, BinData1),
    F = fun(Key, [L, KeyL]) ->
        case lists:keytake(Key, #scene_player.key, L) of
            false ->
                [L, [Key | KeyL]];
            {value, _, T} ->
                [T, KeyL]
        end
        end,
    lists:foldl(F, [User1, []], User2).

move_R([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList) ->
    Area1 = [XY1 + ?MAP_LENGTH_R, XY1 + ?MAP_LENGTH_RD, XY1 + ?MAP_LENGTH_RU],
    User1 = scene_agent:move_send_and_getuser(Area1, Copy, BinData2),

    Area2 = [XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_LD],
    User2 = scene_agent:move_send_and_getkey(Area2, Copy, BinData1),
    Area3 = [XY2, XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_RU],
    scene_agent:move_send_to_any_area(Area3, Copy, BinData, MoveInfoList),
    [User1, User2].

move_L([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList) ->
    Area1 = [XY1 + ?MAP_LENGTH_L, XY1 + ?MAP_LENGTH_LU, XY1 + ?MAP_LENGTH_LD],
    User1 = scene_agent:move_send_and_getuser(Area1, Copy, BinData2),

    Area2 = [XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_RU],
    User2 = scene_agent:move_send_and_getkey(Area2, Copy, BinData1),
    Area3 = [XY2, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_LD],
    scene_agent:move_send_to_any_area(Area3, Copy, BinData, MoveInfoList),
    [User1, User2].

move_U([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList) ->
    Area1 = [XY1 + ?MAP_LENGTH_U, XY1 + ?MAP_LENGTH_LU, XY1 + ?MAP_LENGTH_RU],
    User1 = scene_agent:move_send_and_getuser(Area1, Copy, BinData2),

    Area2 = [XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_LD],
    User2 = scene_agent:move_send_and_getkey(Area2, Copy, BinData1),

    Area3 = [XY2, XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_RU],
    scene_agent:move_send_to_any_area(Area3, Copy, BinData, MoveInfoList),
    [User1, User2].

move_D([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList) ->
    Area1 = [XY1 + ?MAP_LENGTH_D, XY1 + ?MAP_LENGTH_RD, XY1 + ?MAP_LENGTH_LD],
    User1 = scene_agent:move_send_and_getuser(Area1, Copy, BinData2),

    Area2 = [XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_RU],
    User2 = scene_agent:move_send_and_getkey(Area2, Copy, BinData1),

    Area3 = [XY2, XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_LD],
    scene_agent:move_send_to_any_area(Area3, Copy, BinData, MoveInfoList),
    [User1, User2].

move_LU([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList) ->
    Area1 = [XY1 + ?MAP_LENGTH_L, XY1 + ?MAP_LENGTH_LU, XY1 + ?MAP_LENGTH_U, XY1 + ?MAP_LENGTH_RU, XY1 + ?MAP_LENGTH_LD],
    User1 = scene_agent:move_send_and_getuser(Area1, Copy, BinData2),

    Area2 = [XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_LD, XY2 + ?MAP_LENGTH_RU],
    User2 = scene_agent:move_send_and_getkey(Area2, Copy, BinData1),

    Area3 = [XY2, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_U],
    scene_agent:move_send_to_any_area(Area3, Copy, BinData, MoveInfoList),
    [User1, User2].

move_LD([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList) ->
    Area1 = [XY1 + ?MAP_LENGTH_LU, XY1 + ?MAP_LENGTH_L, XY1 + ?MAP_LENGTH_LD, XY1 + ?MAP_LENGTH_D, XY1 + ?MAP_LENGTH_RD],
    User1 = scene_agent:move_send_and_getuser(Area1, Copy, BinData2),

    Area2 = [XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_RU, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_LU],
    User2 = scene_agent:move_send_and_getkey(Area2, Copy, BinData1),

    Area3 = [XY2, XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_LD],
    scene_agent:move_send_to_any_area(Area3, Copy, BinData, MoveInfoList),
    [User1, User2].

move_RU([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList) ->
    Area1 = [XY1 + ?MAP_LENGTH_R, XY1 + ?MAP_LENGTH_RD, XY1 + ?MAP_LENGTH_RU, XY1 + ?MAP_LENGTH_U, XY1 + ?MAP_LENGTH_LU],
    User1 = scene_agent:move_send_and_getuser(Area1, Copy, BinData2),

    Area2 = [XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_LD, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_RD],
    User2 = scene_agent:move_send_and_getkey(Area2, Copy, BinData1),

    Area3 = [XY2, XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_RU],
    scene_agent:move_send_to_any_area(Area3, Copy, BinData, MoveInfoList),
    [User1, User2].

move_RD([Copy, XY1, XY2, BinData, BinData1, BinData2], MoveInfoList) ->
    Area1 = [XY1 + ?MAP_LENGTH_R, XY1 + ?MAP_LENGTH_LD, XY1 + ?MAP_LENGTH_D, XY1 + ?MAP_LENGTH_RD, XY1 + ?MAP_LENGTH_RU],
    User1 = scene_agent:move_send_and_getuser(Area1, Copy, BinData2),

    Area2 = [XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_RU, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_LD],
    User2 = scene_agent:move_send_and_getkey(Area2, Copy, BinData1),

    Area3 = [XY2, XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_RD],
    scene_agent:move_send_to_any_area(Area3, Copy, BinData, MoveInfoList),
    [User1, User2].


%% =====================================
%% =============== 怪物 ================
%% =====================================
%% 广播给怪物
move_mon_broadcast(Copy, XY1, XY2, MoveInfoList) ->
    [SceneMonList, SceneMonKey] = if
                                      XY2 == XY1 -> %% 同一个格子内移动
                                          [[], []];
                                      XY2 + ?MAP_LENGTH_R == XY1 -> %% 向右移动
                                          move_mon_R(Copy, XY1, XY2);
                                      XY2 + ?MAP_LENGTH_L == XY1 -> %% 向左移动
                                          move_mon_L(Copy, XY1, XY2);
                                      XY2 + ?MAP_LENGTH_U == XY1 -> %% 向上移动
                                          move_mon_U(Copy, XY1, XY2);
                                      XY2 + ?MAP_LENGTH_D == XY1 -> %% 向下移动
                                          move_mon_D(Copy, XY1, XY2);
                                      XY2 + ?MAP_LENGTH_LU == XY1 -> %% 向左上移动
                                          move_mon_LU(Copy, XY1, XY2);
                                      XY2 + ?MAP_LENGTH_LD == XY1 -> %% 向左下移动
                                          move_mon_LD(Copy, XY1, XY2);
                                      XY2 + ?MAP_LENGTH_RU == XY1 -> %% 向右上移动
                                          move_mon_RU(Copy, XY1, XY2);
                                      XY2 + ?MAP_LENGTH_RD == XY1 -> %% 向右下移动
                                          move_mon_RD(Copy, XY1, XY2);
                                      true -> %% 跨相邻九宫格移动
                                          move_mon_zero(Copy, XY1, XY2)
                                  end,
    case SceneMonList == [] andalso SceneMonKey == [] of
        true ->
            ok;
        false ->
            %%加入和移除怪物,如果加入和移除的是同一目标的情况,则不处理
            {ok, BinData4} = pt_120:write(12010, {scene_pack:pack_scene_mon_helper(SceneMonList), SceneMonKey}),
            [_pkey, Sid] = MoveInfoList,
            server_send:send_to_sid(Sid, BinData4)
    end.

move_mon_R(Copy, XY1, XY2) ->
    Area1 = [XY1 + ?MAP_LENGTH_R, XY1 + ?MAP_LENGTH_RD, XY1 + ?MAP_LENGTH_RU],
    Mon1 = mon_agent:dict_get_all_area_mon(Area1, Copy),

    Area2 = [XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_LD],
    Mon2 = mon_agent:dict_get_all_area(Area2, Copy),

    [Mon1, Mon2].

move_mon_L(Copy, XY1, XY2) ->
    Area1 = [XY1 + ?MAP_LENGTH_L, XY1 + ?MAP_LENGTH_LU, XY1 + ?MAP_LENGTH_LD],
    Mon1 = mon_agent:dict_get_all_area_mon(Area1, Copy),

    Area2 = [XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_RU],
    Mon2 = mon_agent:dict_get_all_area(Area2, Copy),

    [Mon1, Mon2].

move_mon_U(Copy, XY1, XY2) ->
    Area1 = [XY1 + ?MAP_LENGTH_U, XY1 + ?MAP_LENGTH_LU, XY1 + ?MAP_LENGTH_RU],
    Mon1 = mon_agent:dict_get_all_area_mon(Area1, Copy),

    Area2 = [XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_LD],
    Mon2 = mon_agent:dict_get_all_area(Area2, Copy),

    [Mon1, Mon2].

move_mon_D(Copy, XY1, XY2) ->
    Area1 = [XY1 + ?MAP_LENGTH_D, XY1 + ?MAP_LENGTH_RD, XY1 + ?MAP_LENGTH_LD],
    Mon1 = mon_agent:dict_get_all_area_mon(Area1, Copy),

    Area2 = [XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_RU],
    Mon2 = mon_agent:dict_get_all_area(Area2, Copy),

    [Mon1, Mon2].

move_mon_LU(Copy, XY1, XY2) ->
    Area1 = [XY1 + ?MAP_LENGTH_L, XY1 + ?MAP_LENGTH_LU, XY1 + ?MAP_LENGTH_U, XY1 + ?MAP_LENGTH_RU, XY1 + ?MAP_LENGTH_LD],
    Mon1 = mon_agent:dict_get_all_area_mon(Area1, Copy),

    Area2 = [XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_LD, XY2 + ?MAP_LENGTH_RU],
    Mon2 = mon_agent:dict_get_all_area(Area2, Copy),

    [Mon1, Mon2].

move_mon_LD(Copy, XY1, XY2) ->
    Area1 = [XY1 + ?MAP_LENGTH_LU, XY1 + ?MAP_LENGTH_L, XY1 + ?MAP_LENGTH_LD, XY1 + ?MAP_LENGTH_D, XY1 + ?MAP_LENGTH_RD],
    Mon1 = mon_agent:dict_get_all_area_mon(Area1, Copy),

    Area2 = [XY2 + ?MAP_LENGTH_RD, XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_RU, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_LU],
    Mon2 = mon_agent:dict_get_all_area(Area2, Copy),

    [Mon1, Mon2].

move_mon_RU(Copy, XY1, XY2) ->
    Area1 = [XY1 + ?MAP_LENGTH_R, XY1 + ?MAP_LENGTH_RD, XY1 + ?MAP_LENGTH_RU, XY1 + ?MAP_LENGTH_U, XY1 + ?MAP_LENGTH_LU],
    Mon1 = mon_agent:dict_get_all_area_mon(Area1, Copy),

    Area2 = [XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_LD, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_RD],
    Mon2 = mon_agent:dict_get_all_area(Area2, Copy),

    [Mon1, Mon2].

move_mon_RD(Copy, XY1, XY2) ->
    Area1 = [XY1 + ?MAP_LENGTH_R, XY1 + ?MAP_LENGTH_LD, XY1 + ?MAP_LENGTH_D, XY1 + ?MAP_LENGTH_RD, XY1 + ?MAP_LENGTH_RU],
    Mon1 = mon_agent:dict_get_all_area_mon(Area1, Copy),

    Area2 = [XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_RU, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_LD],
    Mon2 = mon_agent:dict_get_all_area(Area2, Copy),

    [Mon1, Mon2].

move_mon_zero(Copy, XY1, XY2) ->
    Area1 = [XY1, XY1 + ?MAP_LENGTH_LU, XY1 + ?MAP_LENGTH_U, XY1 + ?MAP_LENGTH_RU, XY1 + ?MAP_LENGTH_L, XY1 + ?MAP_LENGTH_R, XY1 + ?MAP_LENGTH_LD, XY1 + ?MAP_LENGTH_D, XY1 + ?MAP_LENGTH_RD],
    MonList = mon_agent:dict_get_all_area_mon(Area1, Copy),

    Area2 = [XY2, XY2 + ?MAP_LENGTH_LU, XY2 + ?MAP_LENGTH_U, XY2 + ?MAP_LENGTH_RU, XY2 + ?MAP_LENGTH_L, XY2 + ?MAP_LENGTH_R, XY2 + ?MAP_LENGTH_LD, XY2 + ?MAP_LENGTH_D, XY2 + ?MAP_LENGTH_RD],
    KeyList = mon_agent:dict_get_all_area(Area2, Copy),
    F = fun(Key, {MonList1, KeyList1}) ->
        case lists:keytake(Key, #mon.key, MonList1) of
            false ->
                {MonList, [Key | KeyList1]};
            {value, _, T} ->
                {T, KeyList1}
        end
        end,
    {MonList2, KeyList2} = lists:foldl(F, {MonList, []}, KeyList),
    [MonList2, KeyList2].


cmd_test() ->
    List = test(lists:seq(1, 255), []),
    F = fun({XY, List0}) ->
        ?ERR("XY ~p len ~p  ~n", [XY, length(List0)])
        end,
    lists:foreach(F, List).

test([], List) -> List;
test([X | T], List) ->
    F = fun(Y, L) ->
        XY = get_xy(X, Y),
        case lists:keyfind(XY, 1, L) of
            false ->
                [{XY, [{X, Y}]} | L];
            {_, Val} ->
                [{XY, [{X, Y} | Val]} | lists:keydelete(XY, 1, L)]
        end
        end,
    NewList = lists:foldl(F, List, lists:seq(1, 255)),
    test(T, NewList).