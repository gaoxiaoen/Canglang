%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 十一月 2015 19:47
%%%-------------------------------------------------------------------
-module(team).
-author("hxming").
-behaviour(gen_server).

-include("team.hrl").
-include("common.hrl").
-include("server.hrl").

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-define(SERVER, ?MODULE).

%% API
-export([start/1, stop/1]).

%%创建队伍
start(Mb) ->
    gen_server:start(?MODULE, [Mb], []).

%%停止队伍
stop(TeamPid) ->
    case is_pid(TeamPid) of
        false -> skip;
        true ->
            TeamPid ! {stop}
    end.

init([Mb]) ->
    Team = #team{
        key = Mb#t_mb.team_key,
        pid = self(),
        name = team_util:team_name(Mb#t_mb.nickname),
        pkey = Mb#t_mb.pkey,
        num = 1
    },
    team_util:set_team(Team),
    NewMb = Mb#t_mb{team_pid = Team#team.pid},
    team_util:set_team_mb(NewMb),
    team_util:refresh_team(Team#team.key),
    put(timer, erlang:send_after(10000, self(), timer)),
    {ok, #st_team{key = Team#team.key}}.

handle_call(Request, From, State) ->
    case catch team_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("team_handle handle_call ~p/~p~n", [Request, Reason]),
            {reply, error, State}
    end.


handle_cast({player_logout, Player}, State) ->
    team_util:refresh_team(State#st_team.key, 0),
    if Player#player.team_leader == 1 ->
        erlang:send_after(?TEAM_LOGOUT_LEADER_TIME * 1000, self(), {update_leader, Player#player.key, Player#player.team_key});
        true -> skip
    end,
    erlang:send_after(?TEAM_LOGOUT_TIME * 1000, self(), {logout_update}),
    {noreply, State};

handle_cast(Request, State) ->
    case catch team_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("team_handle handle_cast ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

handle_info({logout_update}, State) ->
    Mbs = team_util:get_team_mbs(State#st_team.key),
    Now = util:unixtime(),
    F = fun(Mb, List) ->
        if
            Mb#t_mb.is_online == 0 andalso Now - Mb#t_mb.logout_time >= ?TEAM_LOGOUT_TIME ->
                case team_util:get_team(Mb#t_mb.pkey) of
                    false ->
                        team_util:erase_team_mb(Mb#t_mb.pkey);
                    Team ->
                        team_util:do_leave_team(Mb#t_mb.pkey, Team)
                end,
                List;
            true ->
                [Mb | List]
        end
        end,
    lists:foldl(F, [], Mbs),
    team_util:refresh_team(State#st_team.key, 0),
    {noreply, State};

handle_info({update_leader, Pkey, TeamKey}, State) ->
    Mbs = team_util:get_team_mbs(TeamKey),
    Team = team_util:get_team(TeamKey),
    if
        Team#team.pkey /= Pkey -> skip;
        true -> case [Mb || Mb <- Mbs, Mb#t_mb.is_online == 1, Mb#t_mb.pkey /= Pkey] of
                    [] ->
                        skip;
                    NewMbs ->
                        %% 改变自身队长状态
                        case team_util:get_team_mb(Pkey) of
                            false -> skip;
                            MyMbs ->
                                NewMyMbs = MyMbs#t_mb{team_leader = 0},
                                team_util:set_team_mb(NewMyMbs)
                        end,
                        %%按照入队先后任下一个队长
                        LMb = hd(lists:keysort(#t_mb.join_time, NewMbs)),
                        NewLMb = LMb#t_mb{team_leader = 1},
                        team_util:set_team_mb(NewLMb),
                            catch NewLMb#t_mb.pid ! {update_team, Team#team.key, Team#team.pid, 1},
                        NewTeam = Team#team{pkey = NewLMb#t_mb.pkey, name = team_util:team_name(NewLMb#t_mb.nickname), num = Team#team.num - 1},
                        team_util:set_team(NewTeam),
                        team_util:refresh_team(Team#team.key)
                end
    end,
    {noreply, State};

handle_info(Request, State) ->
    case catch team_handle:handle_info(Request, State) of
        {stop, normal, NewState} ->
            {stop, normal, NewState};
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("dungeon handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    %%乱斗 队伍解散
    ?CAST(cross_scuffle_proc:get_server_pid(), {{team_dissolve, _State#st_team.key}}),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================