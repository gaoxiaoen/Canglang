%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 十一月 2016 14:04
%%%-------------------------------------------------------------------
-module(cross_dungeon_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("dungeon.hrl").
-include("daily.hrl").

%% API
-export([handle/3]).


%%获取副本通关状态
handle(12300, Player, {}) ->
    Data = cross_dungeon_util:get_dun_list(Player),
    {ok, Bin} = pt_123:write(12300, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取房间列表
handle(12301, Player, {DunId}) ->
    cross_all:apply(cross_dungeon_proc, room_list, [node(), config:get_server_num(), Player#player.sid, DunId, Player#player.key, Player#player.cbp,Player#player.lv]),
    ok;

%%创建房间
handle(12302, Player, {DunId, Password, IsFast}) ->
    Ret =
        case data_dungeon:get(DunId) of
            [] -> 6;
            BaseDun ->
                if BaseDun#dungeon.lv > Player#player.lv -> 11;
                    Player#player.convoy_state > 0 -> 9;
                    Player#player.marry#marry.cruise_state > 0 -> 25;
                    Player#player.cross_dun_state > 0 -> 5;
                    Player#player.match_state > 0 -> 24;
                    true ->
                        case scene:is_normal_scene(Player#player.scene) of
                            false -> 4;
                            true ->
                                Mb = dungeon_util:make_dungeon_mb(Player, util:unixtime()),
                                cross_all:apply(cross_dungeon_proc, create_room, [Mb#dungeon_mb{is_ready = 1}, DunId, BaseDun#dungeon.lv, Password, IsFast]),
                                ok
                        end
                end
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_123:write(12302, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%12303更新房间状态

%%12304房间数据
handle(12304, Player, {}) ->
    if Player#player.cross_dun_state /= 0 ->
        cross_all:apply(cross_dungeon_proc, room_info, [node(), Player#player.sid, Player#player.cross_dun_state, Player#player.key]);
        true ->
            skip
    end,
    ok;

%%退出房间
handle(12305, Player, {}) ->
    cross_all:apply(cross_dungeon_proc, quit_room, [node(), Player#player.sid, Player#player.cross_dun_state, Player#player.key]),
    {ok, Player#player{match_state = ?MATCH_STATE_NO}};

%%房间踢人
handle(12306, Player, {Dkey}) ->
    cross_all:apply(cross_dungeon_proc, kickout, [node(), Player#player.sid, Player#player.cross_dun_state, Player#player.key, Dkey]),
    ok;


%%通知被踢12307

%%加入房间
handle(12308, Player, {DunId, Key, Password, AutoReady}) ->
    Ret =
        case data_dungeon:get(DunId) of
            [] -> 6;
            BaseDun ->
                if BaseDun#dungeon.lv > Player#player.lv -> 11;
                    Player#player.convoy_state > 0 -> 9;
                    Player#player.marry#marry.cruise_state > 0 -> 25;
                    Player#player.match_state > 0 -> 24;
                    Player#player.cross_dun_state > 0 -> 5;
                    true ->
                        case scene:is_normal_scene(Player#player.scene) of
                            false -> 4;
                            true ->
                                Mb = dungeon_util:make_dungeon_mb(Player, util:unixtime()),
                                cross_all:apply(cross_dungeon_proc, enter_room, [Mb#dungeon_mb{is_ready = AutoReady}, DunId, Key, Password]),
                                ok
                        end
                end
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_123:write(12308, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%准备
handle(12309, Player, {}) ->
    cross_all:apply(cross_dungeon_proc, ready_room, [node(), Player#player.sid, Player#player.cross_dun_state, Player#player.key]),
    ok;

%%准备通知 12310

%%获取邀请列表
handle(12311, Player, {DunId, Type}) ->
    Data = cross_dungeon_util:get_invite_list(Player, DunId, Type),
    {ok, Bin} = pt_123:write(12311, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%邀请玩家
handle(12312, Player, {Pkey}) ->
    Ret =
        if Player#player.cross_dun_state == 0 -> 3;
            true ->
                case ets:lookup(?ETS_ONLINE, Pkey) of
                    [] -> 18;
                    [Online] ->
                        cross_all:apply(cross_dungeon_proc, check_invite, [node(), Player#player.cross_dun_state, Player#player.nickname, Online#ets_online.pid]),
                        1
                end
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_123:write(12312, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%收到邀请12313

%%发招募公告
handle(12314, Player, {}) ->
    Ret =
        if Player#player.cross_dun_state == 0 -> 3;
            true ->
                cross_all:apply(cross_dungeon_proc, invite_notice, [node(), Player#player.sid, Player#player.cross_dun_state, Player#player.nickname]),
                ok
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_123:write(12314, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%手动开启副本
handle(12315, Player, {}) ->
    Ret =
        if Player#player.cross_dun_state == 0 -> 3;
            true ->
                cross_all:apply(cross_dungeon_proc, open_dungeon, [node(), Player#player.sid, Player#player.cross_dun_state, Player#player.key]),
                ok
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_123:write(12315, {Ret, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%退出跨服副本
handle(12320, Player, {}) ->
    case dungeon_util:is_dungeon_cross(Player#player.scene) of
        false -> ok;
        true ->
            cross_all:apply(cross_dungeon, quit, [Player#player.key, Player#player.copy]),
            BuffId = cross_dungeon_util:get_buff(Player#player.scene),
            Player1_1 = buff:del_buff(Player, BuffId),
            Player1 = scene_change:change_scene_back(Player1_1),
            Player2 = Player1#player{group = 0},
            {ok, Bin} = pt_120:write(12027, {Player#player.key, 0}),
            server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
            dungeon_record:erase(Player#player.key),
            {ok, Player2}
    end;

%%获取副本目标,倒计时
handle(12321, Player, {}) ->
    case dungeon_util:is_dungeon_cross(Player#player.scene) of
        false -> ok;
        true ->
            cross_all:apply(cross_dungeon, check_target, [node(), Player#player.sid, Player#player.copy]),
            ok
    end;

%%12322结算


%%有密码回到房间
handle(12323, Player, {DunId, Key, Password, IsFast, AutoReady}) ->
    Ret =
        case data_dungeon:get(DunId) of
            [] -> 6;
            BaseDun ->
                if BaseDun#dungeon.lv > Player#player.lv -> 11;
                    Player#player.convoy_state > 0 -> 9;
                    Player#player.marry#marry.cruise_state > 0 -> 25;
                    Player#player.cross_dun_state > 0 -> 5;
                    Player#player.match_state > 0 -> 24;
                    true ->
%%                        case scene:is_normal_scene(Player#player.scene) of
%%                            false -> 4;
%%                            true ->
                        Mb = dungeon_util:make_dungeon_mb(Player, util:unixtime()),
                        cross_all:apply(cross_dungeon_proc, back_room, [Mb#dungeon_mb{is_ready = AutoReady}, DunId, BaseDun#dungeon.lv, Key, Password, IsFast]),
                        ok
%%                        end
                end
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_123:write(12323, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;



%%领取跨服试炼副本奖励
handle(12325, Player, {Times}) ->
    {Ret,NewPlayer}= cross_dungeon_util:get_times_reward(Player,Times),
    {ok, Bin} = pt_123:write(12325, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok,NewPlayer};


handle(_cmd, _Player, _Data) ->
    ?DEBUG("cmd ~p err~n", [_cmd]),
    ok.
