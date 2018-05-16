%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 十月 2017 20:28
%%%-------------------------------------------------------------------
-module(cross_scuffle_elite_log).
-author("Administrator").

%% API
-compile(export_all).

log_guild(Wtkey, Wtname, Pkey, Pname, Type, Time) ->
    Sql = io_lib:format("insert into log_war_team set pkey=~p,nickname = '~s',wtkey=~p,wtname = '~s',type=~p,time=~p",
        [Pkey, Pname, Wtkey, Wtname, Type, Time]),
    log_proc:log(Sql),
    ok.

log_final_war(Wtkey, Wtname, Score, Pkey, Pname, Rank, Time) ->
    Sql = io_lib:format("insert into log_final_war set pkey=~p,nickname = '~s',wtkey=~p,wtname = '~s',score=~p,rank = ~p,time=~p",
        [Pkey, Pname, Wtkey, Wtname, Score, Rank, Time]),
    log_proc:log(Sql),
    ok.
