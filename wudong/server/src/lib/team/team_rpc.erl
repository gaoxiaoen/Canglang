%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 十一月 2015 11:16
%%%-------------------------------------------------------------------
-module(team_rpc).
-author("hxming").
-include("team.hrl").
-include("server.hrl").
-include("common.hrl").
-include("money.hrl").
%% API
-export([handle/3]).

%%获取场景队伍列表
handle(22001, Player, _) ->
    case scene:is_cross_scene(Player#player.scene) of
        false ->
            TeamList = team_util:get_scene_team(Player#player.scene, Player#player.copy, node()),
            NewTeamTuple = [[H | T] || [H | T] <- TeamList, H /= Player#player.team_key], %% 去除自身队伍
            {ok, Bin} = pt_220:write(22001, {NewTeamTuple}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            cross_area:apply(team_util, get_cross_scene_team, [node(), Player#player.sid, Player#player.scene, Player#player.copy]),
            ok
    end;

%%创建队伍
handle(22002, Player, _) ->
    OpenLv = ?TEAM_LIM_LV,
    {Ret, NewPlayer} =
        if Player#player.team_key /= 0 -> {2, Player};
            Player#player.lv < OpenLv -> {14, Player}; %% 等级不足
            true ->
                Player1 = team_util:create_team(Player),
                {1, Player1}
        end,
    {ok, Bin} = pt_220:write(22002, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, team, NewPlayer};

%%获取队伍成员信息
handle(22003, Player, _) ->
    if Player#player.team_key == 0 ->
        {ok, Bin} = pt_220:write(22003, {[]}),
        server_send:send_to_sid(Player#player.sid, Bin);
        true ->
            Mbs = team_util:get_team_mbs(Player#player.team_key),
            F = fun(Mb1, Mb2) ->
                if
                    Mb1#t_mb.pkey == Player#player.key -> true;
                    Mb2#t_mb.pkey == Player#player.key -> false;
                    true -> Mb1#t_mb.join_time < Mb2#t_mb.join_time
                end
                end,
            NewMbs = lists:sort(F, Mbs),
            MbList = team_util:pack_team_mb_list(NewMbs),
            {ok, Bin} = pt_220:write(22003, {MbList}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok;

%%发起组队，A->B。
%%1、A和B没有队伍则A创建队伍并发起邀请；2、A拥有队伍，则对B发起邀请，
%%3、A没有队伍，B拥有队伍，则A申请入B的队伍，4、A和B都拥有队伍，则不能操作
%%邀请玩家入队
%%ERR 1成功，2队伍人数已满
handle(22004, Player, {Pkey}) ->
    case player_util:get_player(Pkey) of
        [] ->
            ok;
        Role0 ->
            OpenLv = ?TEAM_LIM_LV,
            if
                Player#player.lv < OpenLv ->
                    {ok, Bin22004} = pt_220:write(22004, {14}),
                    server_send:send_to_sid(Player#player.sid, Bin22004), ok;
                Role0#player.lv < OpenLv ->
                    {ok, Bin22004} = pt_220:write(22004, {15}),
                    server_send:send_to_sid(Player#player.sid, Bin22004), ok;
                Player#player.team_key == 0 ->
                    case player_util:get_player(Pkey) of
                        [] ->
                            ok;
                        Role ->
                            if
                                Role#player.team_key == 0 ->
                                    NewPlayer = team_util:create_team(Player),
                                    {ok, Bin22005} = pt_220:write(22005, {Player#player.key, Player#player.nickname, NewPlayer#player.team_key}),
                                    server_send:send_to_key(Pkey, Bin22005),
                                    {ok, Bin22004} = pt_220:write(22004, {1}),
                                    server_send:send_to_sid(Player#player.sid, Bin22004),
                                    {ok, team, NewPlayer};
                                true ->
                                    handle(22007, Player, {Role#player.team_key})
                            end
                    end;
                true ->
                    case team_util:get_team(Player#player.team_key) of
                        false ->
                            {ok, Bin22004} = pt_220:write(22004, {5}),
                            server_send:send_to_sid(Player#player.sid, Bin22004),
                            team_util:erase_team_mb(Player#player.key),
                            {ok, team, Player#player{team_key = 0, team_leader = 0, team = 0}};
                        Team ->
                            if Team#team.num >= ?TEAM_MAX_NUM ->
                                {ok, Bin22004} = pt_220:write(22004, {7}),
                                server_send:send_to_sid(Player#player.sid, Bin22004),
                                ok;
                                true ->
                                    %%拥有队伍，发起邀请即可
                                    {ok, Bin22005} = pt_220:write(22005, {Player#player.key, Player#player.nickname, Player#player.team_key}),
                                    server_send:send_to_key(Pkey, Bin22005),
                                    {ok, Bin22004} = pt_220:write(22004, {1}),
                                    server_send:send_to_sid(Player#player.sid, Bin22004),
                                    ok
                            end
                    end
            end
    end;

%%回应组队邀请
handle(22006, Player, {Result, TeamKey, Pkey}) ->
    case Result of
        1 ->
            OpenLv = ?TEAM_LIM_LV,
            {Ret, NewPlayer} =
                if Player#player.team_key /= 0 -> {2, Player};
                    Player#player.lv < OpenLv -> {14, Player}; %% 等级不足
                    true ->
                        case team_util:get_team(TeamKey) of
                            false -> {5, Player};
                            Team ->
                                if Team#team.num >= ?TEAM_MAX_NUM -> {7, Player};
                                    true ->
                                        Player1 = team_util:enter_team(Player, Team),
                                        {1, Player1}
                                end
                        end
                end,
            {ok, Bin} = pt_220:write(22006, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            if Ret == 1 ->
                {ok, team, NewPlayer};
                true -> ok
            end;
        _ ->
            {ok, Bin} = pt_220:write(22015, {Player#player.nickname}),
            server_send:send_to_key(Pkey, Bin),
            ok
    end;


%%申请入队
handle(22007, Player, {TeamKey}) ->
    {Ret, _NewPlayer} = team_util:apply_join_team(Player, TeamKey),
    {ok, Bin} = pt_220:write(22007, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%离开队伍
handle(22008, Player, _) ->
    {Ret, NewPlayer} =
        if Player#player.team_key == 0 -> {3, Player};
            true ->
                Player1 = team_util:leave_team(Player),
                {1, Player1}
        end,
    {ok, Bin} = pt_220:write(22008, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        cross_scuffle:quit_team(Player#player.key, Player#player.team_key),
        {ok, team, NewPlayer};
        true -> ok
    end;

%%踢出队伍
handle(22009, Player, {Pkey}) ->
    Ret =
        if Player#player.team_key == 0 -> 3;
            Player#player.team_leader /= 1 -> 4;
            Player#player.key == Pkey -> 13;
            true ->
                case team_util:get_team(Player#player.team_key) of
                    false -> 5;
                    Team ->
                        case team_util:get_team_mb(Pkey) of
                            false -> 6;
                            Mb ->
                                if Mb#t_mb.team_key /= Team#team.key -> 6;
                                    true ->
                                        team_util:kickout_team(Team, Mb),
                                        {ok, Bin1} = pt_220:write(22009, {9}),
                                        server_send:send_to_key(Pkey, Bin1),
                                        cross_scuffle:quit_team(Pkey, Player#player.team_key),
                                        1
                                end
                        end
                end
        end,
    {ok, Bin} = pt_220:write(22009, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%解散队伍
handle(22010, Player, _) ->
    Ret =
        if Player#player.team_key == 0 -> 3;
            Player#player.team_leader /= 1 -> 4;
            true ->
                team:stop(Player#player.team),
                1
        end,
    {ok, Bin} = pt_220:write(22010, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%转让队长
handle(22011, Player, {Pkey}) ->
    {Ret, NewPlayer} =
        if Player#player.team_key == 0 -> {3, Player};
            Player#player.team_leader /= 1 -> {4, Player};
            true ->
                case team_util:get_team(Player#player.team_key) of
                    false -> {5, Player};
                    Team ->
                        case team_util:get_team_mb(Player#player.key) of
                            false -> {6, Player};
                            Mb1 ->
                                case team_util:get_team_mb(Pkey) of
                                    false -> {6, Player};
                                    Mb2 ->
                                        if Mb1#t_mb.team_key /= Mb2#t_mb.team_key ->
                                            {8, Player};
                                            Mb2#t_mb.is_online /= 1 ->
                                                {12, Player};
                                            true ->
                                                team_util:change_leader(Team, Mb1, Mb2),
                                                {1, Player#player{team_leader = 0}}
                                        end
                                end
                        end
                end
        end,
    {ok, Bin} = pt_220:write(22011, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, team, NewPlayer};
        true -> ok
    end;

%%获取可邀请成员列表
handle(22012, Player, {Type}) ->
    case scene:is_cross_scene(Player#player.scene) andalso Type == 0 of
        false ->
            PlayerList = team_util:get_scene_not_team(Player, Type, Player#player.scene, Player#player.copy, node()),
            {ok, Bin} = pt_220:write(22012, {PlayerList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            OpenLv = ?TEAM_LIM_LV,
            cross_area:apply(team_util, get_cross_scene_not_team, [node(), Player#player.sid, Player#player.scene, Player#player.copy, OpenLv]),
            ok
    end;

%%发布队伍招募
handle(22013, Player, {Id}) ->
    {Ret, NewPlayer} =
        if Player#player.team_key == 0 -> {3, Player};
            true ->
                case data_team_recruit:get(Id) of
                    [] -> {10, Player};
                    Msg ->
                        case money:is_enough(Player, ?TEAM_RECRUIT_COIN, coin) of
                            false -> {11, Player};
                            true ->
                                Player1 = money:add_coin(Player, -?TEAM_RECRUIT_COIN, 11, 0, 0),
                                notice:add_sys_notice(Msg),
                                {1, Player1}
                        end
                end
        end,
    {ok, Bin} = pt_220:write(22013, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%处理组队申请
handle(22017, Player, {Result, Pkey}) ->
    case Result of
        1 ->
            OpenLv = ?TEAM_LIM_LV,
            Ret =
                if Player#player.team_key == 0 -> 3;
                    Player#player.lv < OpenLv -> 14;%% 等级不足
                    true ->
                        case team_util:get_team(Player#player.team_key) of
                            false -> 5;%% 队伍不存在
                            Team ->
                                if Team#team.num >= ?TEAM_MAX_NUM -> 7;%% 队伍人数已满
                                    true ->
                                        case player_util:get_player_online(Pkey) of
                                            [] -> 12;%% 玩家离线
                                            Online ->
                                                Online#ets_online.pid ! {enter_team, Team}
                                        end,
                                        1
                                end
                        end
                end,
            {ok, Bin} = pt_220:write(22017, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _ ->
            {ok, Bin} = pt_220:write(22017, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%快速加入
handle(22019, Player, {}) ->
    {Res, NewPlayer} = team_util:quick_join(Player),
    {ok, Bin} = pt_220:write(22019, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ?PRINT("_cmd ~p _Data ~p ~n", [_cmd, _Data]),
    ok.