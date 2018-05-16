%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 十一月 2016 14:04
%%%-------------------------------------------------------------------
-module(cross_dungeon_guard_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("dungeon.hrl").
-include("daily.hrl").
-include("cross_dungeon_guard.hrl").
%% API
-export([handle/3]).

%%获取副本通关状态
handle(65100, Player, {}) ->
    Data = cross_dungeon_guard_util:get_dun_list(Player),
    {ok, Bin} = pt_651:write(65100, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取房间列表
handle(65101, Player, {DunId}) ->
    cross_all:apply(cross_dungeon_guard_proc, room_list, [node(), config:get_server_num(), Player#player.sid, DunId, Player#player.key, Player#player.cbp, Player#player.lv]),
    ok;

%%创建房间
handle(65102, Player, {DunId, Password, IsFast}) ->
    Ret =
        case data_dungeon:get(DunId) of
            [] -> 6;
            BaseDun ->
                if BaseDun#dungeon.lv > Player#player.lv -> 11;
                    Player#player.convoy_state > 0 -> 9;
                    Player#player.marry#marry.cruise_state > 0 -> 25;
                    Player#player.cross_dun_guard_state > 0 -> 5;
                    Player#player.match_state > 0 -> 24;
                    true ->
                        case scene:is_normal_scene(Player#player.scene) of
                            false -> 4;
                            true ->
                                St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
                                Type =
                                    case lists:keyfind(DunId, 1, St#st_cross_dun_guard.dun_list) of
                                        false ->
                                            1;
                                        {_, Times, _Floor0, _Time0, _, _CountList} ->
                                            ?DEBUG("Times ~p~n", [Times]),
                                            if
                                                Times >= 3 -> 7;
                                                true -> 1
                                            end
                                    end,
                                if
                                    Type =/= 1 -> Type;
                                    true ->
                                        Mb = dungeon_util:make_dungeon_mb(Player, util:unixtime()),
                                        cross_all:apply(cross_dungeon_guard_proc, create_room, [Mb#dungeon_mb{is_ready = 1}, DunId, BaseDun#dungeon.lv, Password, IsFast]),
                                        ok
                                end
                        end
                end
        end,
    ?DEBUG("Ret ~p~n", [Ret]),
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_651:write(65102, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%65103更新房间状态

%%65104房间数据
handle(65104, Player, {}) ->
    if Player#player.cross_dun_guard_state /= 0 ->
        cross_all:apply(cross_dungeon_guard_proc, room_info, [node(), Player#player.sid, Player#player.cross_dun_guard_state, Player#player.key]);
        true ->
            skip
    end,
    ok;

%%退出房间
handle(65105, Player, {}) ->
    cross_all:apply(cross_dungeon_guard_proc, quit_room, [node(), Player#player.sid, Player#player.cross_dun_guard_state, Player#player.key]),
    {ok, Player#player{match_state = ?MATCH_STATE_NO}};

%%房间踢人
handle(65106, Player, {Dkey}) ->
    cross_all:apply(cross_dungeon_guard_proc, kickout, [node(), Player#player.sid, Player#player.cross_dun_guard_state, Player#player.key, Dkey]),
    ok;


%%通知被踢65107

%%加入房间
handle(65108, Player, {DunId, Key, Password, AutoReady}) ->
    Ret =
        case data_dungeon:get(DunId) of
            [] -> 6;
            BaseDun ->
                if BaseDun#dungeon.lv > Player#player.lv -> 11;
                    Player#player.convoy_state > 0 -> 9;
                    Player#player.marry#marry.cruise_state > 0 -> 25;
                    Player#player.match_state > 0 -> 24;
                    Player#player.cross_dun_guard_state > 0 -> 5;
                    true ->
                        case scene:is_normal_scene(Player#player.scene) of
                            false -> 4;
                            true ->
                                St = lib_dict:get(?PROC_STATUS_CROSS_DUNGEON_GUARD),
                                Type =
                                    case lists:keyfind(DunId, 1, St#st_cross_dun_guard.dun_list) of
                                        false ->
                                            1;
                                        {_, Times, _Floor0, _Time0, _, _CountList} ->
                                            ?DEBUG("Times ~p~n", [Times]),
                                            if
                                                Times >= 3 -> 7;
                                                true -> 1
                                            end
                                    end,
                                if
                                    Type /= 1 -> Type;
                                    true ->
                                        Mb = dungeon_util:make_dungeon_mb(Player, util:unixtime()),
                                        cross_all:apply(cross_dungeon_guard_proc, enter_room, [Mb#dungeon_mb{is_ready = AutoReady}, DunId, Key, Password]),
                                        ok
                                end
                        end
                end
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_651:write(65108, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%准备
handle(65109, Player, {}) ->
    cross_all:apply(cross_dungeon_guard_proc, ready_room, [node(), Player#player.sid, Player#player.cross_dun_guard_state, Player#player.key]),
    ok;

%%准备通知 65110

%%获取邀请列表
handle(65111, Player, {DunId, Type}) ->
    Data = cross_dungeon_guard_util:get_invite_list(Player, DunId, Type),
    {ok, Bin} = pt_651:write(65111, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%邀请玩家
handle(65112, Player, {Pkey}) ->
    Ret =
        if Player#player.cross_dun_guard_state == 0 -> 3;
            true ->
                case ets:lookup(?ETS_ONLINE, Pkey) of
                    [] -> 18;
                    [Online] ->
                        cross_all:apply(cross_dungeon_guard_proc, check_invite, [node(), Player#player.cross_dun_guard_state, Player#player.nickname, Online#ets_online.pid]),
                        1
                end
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_651:write(65112, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%收到邀请65113

%%发招募公告
handle(65114, Player, {}) ->
    Ret =
        if Player#player.cross_dun_guard_state == 0 -> 3;
            true ->
                cross_all:apply(cross_dungeon_guard_proc, invite_notice, [node(), Player#player.sid, Player#player.cross_dun_guard_state, Player#player.nickname]),
                ok
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_651:write(65114, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%手动开启副本
handle(65115, Player, {}) ->
    Ret =
        if Player#player.cross_dun_guard_state == 0 -> 3;
            true ->
                cross_all:apply(cross_dungeon_guard_proc, open_dungeon, [node(), Player#player.sid, Player#player.cross_dun_guard_state, Player#player.key]),
                ok
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_651:write(65115, {Ret, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%退出跨服副本
handle(65120, Player, {}) ->
    case dungeon_util:is_dungeon_guard_cross(Player#player.scene) of
        false -> ok;
        true ->
            cross_all:apply(cross_dungeon_guard, quit, [Player#player.key, Player#player.copy]),
            BuffId = cross_dungeon_guard_util:get_buff(Player#player.scene),
            Player1_1 = buff:del_buff(Player, BuffId),
            Player1 = scene_change:change_scene_back(Player1_1),
            Player2 = Player1#player{group = 0},
            {ok, Bin} = pt_120:write(12027, {Player#player.key, 0}),
            server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
            dungeon_record:erase(Player#player.key),
            {ok, Player2}
    end;

%%获取副本目标,倒计时
handle(65121, Player, {}) ->
    case dungeon_util:is_dungeon_guard_cross(Player#player.scene) of
        false -> ok;
        true ->
            cross_all:apply(cross_dungeon_guard, check_target, [node(), Player#player.sid, Player#player.copy]),
            ok
    end;

%%65122结算


%%有密码回到房间
handle(65123, Player, {DunId, Key, Password, IsFast, AutoReady}) ->
    Ret =
        case data_dungeon:get(DunId) of
            [] -> 6;
            BaseDun ->
                if BaseDun#dungeon.lv > Player#player.lv -> 11;
                    Player#player.convoy_state > 0 -> 9;
                    Player#player.marry#marry.cruise_state > 0 -> 25;
                    Player#player.cross_dun_guard_state > 0 -> 5;
                    Player#player.match_state > 0 -> 24;
                    true ->
%%                        case scene:is_normal_scene(Player#player.scene) of
%%                            false -> 4;
%%                            true ->
                        Mb = dungeon_util:make_dungeon_mb(Player, util:unixtime()),
                        cross_all:apply(cross_dungeon_guard_proc, back_room, [Mb#dungeon_mb{is_ready = AutoReady}, DunId, BaseDun#dungeon.lv, Key, Password, IsFast]),
                        ok
%%                        end
                end
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_651:write(65123, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%查看里程碑
handle(65126, Player, {}) ->
    Data = cross_dungeon_guard_util:get_milestone_info(Player),
    {ok, Bin} = pt_651:write(65126, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%领取里程碑奖励
handle(65127, Player, {DunId, Floor}) ->
    {Res, NewPlayer} = cross_dungeon_guard_util:get_milestone_reward(Player, DunId, Floor),
    ?DEBUG("Res ~p~n", [Res]),
    {ok, Bin} = pt_651:write(65127, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%发送场景消息
handle(65129, Player, {Type}) ->
    case dungeon_util:is_dungeon_guard_cross(Player#player.scene) of
        true ->
            {ok, Bin} = pt_651:write(65129, {Player#player.key, Player#player.nickname, Type}),
            server_send:send_to_scene(Player#player.scene, Player#player.copy, Bin);
        false ->
            cross_all:apply(cross_dungeon_guard_proc, send_info, [ Player#player.cross_dun_guard_state,Player#player.key, Player#player.nickname, Type])
    end,
    ok;

%%获取里程碑记录
handle(65130, Player, {DunId, Floor}) ->
    cross_dungeon_guard_util:get_milestone_ets(Player, DunId, Floor),
    ok;

handle(_cmd, _Player, _Data) ->
    ?DEBUG("cmd ~p err~n", [_cmd]),
    ok.
