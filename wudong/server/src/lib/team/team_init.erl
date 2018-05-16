%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 十一月 2015 15:36
%%%-------------------------------------------------------------------
-module(team_init).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("team.hrl").

%% API
-export([init/1, logout/2]).


%%玩家上线，重新回到队伍中处理
init(Player) ->
    case team_util:get_team_mb(Player#player.key) of
        false ->
            Player#player{team =0, team_key = 0,team_num = 0};
        Mb ->
            NewMb = Mb#t_mb{is_online = 1, pid = Player#player.pid},
            team_util:set_team_mb(NewMb),
            team_util:refresh_team(Mb#t_mb.team_key, Player#player.key),
            {Num,Leader} =
                case team_util:get_team(Mb#t_mb.team_key) of
                    false -> {0,0};
                    Team ->
                        IsLeader = ?IF_ELSE(Team#team.pkey == Player#player.key,1,0),
                        {Team#team.num,IsLeader}
                end,
            Player#player{team = Mb#t_mb.team_pid, team_key = Mb#t_mb.team_key,team_num = Num,team_leader = Leader}
    end.

%%玩家离线
logout(Player, NowTime) ->
    if Player#player.team_key == 0 -> skip;
        true ->
            case team_util:get_team(Player#player.team_key) of
                false -> skip;
                _ ->
                    team_util:logout(Player#player.key, NowTime, Player)
            end
    end.