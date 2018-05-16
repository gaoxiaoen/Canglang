%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 十一月 2015 20:01
%%%-------------------------------------------------------------------
-module(team_handle).
-author("hxming").

-include("team.hrl").
-include("common.hrl").
-include("task.hrl").
%% API
-compile(export_all).

handle_call(_Request, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_Request]),
    {reply, ok, State}.

handle_cast(_Request, State) ->
    ?DEBUG("udef msg ~p~n", [_Request]),
    {noreply, State}.

%%广播位置
handle_info({position, Pkey, SceneId, Copy, X, Y, Hp, HpLim}, State) ->
    Mbs = team_util:get_team_mbs(State#st_team.key),
    case lists:keyfind(Pkey, #t_mb.pkey, Mbs) of
        false -> skip;
        Mb ->
            NewCopy = ?IF_ELSE(is_integer(Copy), Copy + 1, 1),
            NewMb = Mb#t_mb{scene = SceneId, copy = NewCopy, x = X, y = Y, hp = Hp, hp_lim = HpLim},
            team_util:set_team_mb(NewMb),
            {ok, Bin} = pt_220:write(22014, {Pkey, SceneId, NewCopy, X, Y, Hp, HpLim}),
            F = fun(Tmb) ->
                if Tmb#t_mb.is_online == 1 ->
                    server_send:send_to_pid(Tmb#t_mb.pid, Bin);
                    true -> skip
                end
            end,
            lists:foreach(F, Mbs)
    end,
    {noreply, State};

%%组队采集任务事件
handle_info({task_event_collect, [Mid, Pkey]}, State) ->
    Mbs = team_util:get_team_mbs(State#st_team.key),
    F = fun(Mb) ->
        if Mb#t_mb.is_online == 1 andalso Mb#t_mb.pkey /= Pkey ->
            task_event:task_event(?TASK_ACT_COLLECT, Mid, Mb#t_mb.pid);
            true ->
                skip
        end
    end,
    lists:foreach(F, Mbs),
    {noreply, State};

%%组队杀怪任务事件
handle_info({task_event_kill, [Mid, Scene, Copy]}, State) ->
    Mbs = team_util:get_team_mbs(State#st_team.key),
    F = fun(Mb) ->
        if Mb#t_mb.is_online == 1 andalso Mb#t_mb.scene == Scene andalso Mb#t_mb.copy == Copy + 1 ->
            task_event:task_event(?TASK_ACT_KILL, Mid, Mb#t_mb.pid);
            true -> skip
        end
    end,
    lists:foreach(F, Mbs),
    {noreply, State};

%%组队人数变更
handle_info({update_team_num}, State) ->
    Mbs = team_util:get_team_mbs(State#st_team.key),
    TeamNum = length(Mbs),
    Team = team_util:get_team(State#st_team.key),
    team_util:set_team(Team#team{num = TeamNum}),
    F = fun(Mb) ->
        if Mb#t_mb.is_online == 1 ->
            Mb#t_mb.pid ! {update_team_num,TeamNum};
            true -> skip
        end
    end,
    lists:foreach(F, Mbs),
    {noreply, State};

%%杀怪掉落
handle_info({drop, DropRule, DropInfo}, State) ->
    Mbs = team_util:get_team_mbs(State#st_team.key),
    F = fun(Mb) ->
        if Mb#t_mb.is_online == 1 ->
            catch Mb#t_mb.pid ! {drop, DropRule, DropInfo};
            true -> skip
        end
    end,
    lists:foreach(F, Mbs),
    {noreply, State};

handle_info({stop}, State) ->
    Mbs = team_util:get_team_mbs(State#st_team.key),
    F = fun(Mb) ->
        if Mb#t_mb.is_online == 1 ->
            Mb#t_mb.pid ! {update_team, 0, undefined, 0};
            true -> skip
        end
    end,
    lists:foreach(F, Mbs),
    team_util:erase_team(State#st_team.key),
    team_util:erase_team_mbs(State#st_team.key),
    {stop, normal, State};

%%队伍定时器
handle_info(timer, State) ->
    misc:cancel_timer(timer),
    put(timer, erlang:send_after(10000, self(), timer)),
    {noreply, State};

handle_info(_msg, Team) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {noreply, Team}.