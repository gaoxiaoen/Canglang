%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 三月 2017 15:42
%%%-------------------------------------------------------------------
-module(cross_elite_load).
-author("hxming").

-include("cross_elite.hrl").
%% API
-compile(export_all).

load_elite(Pkey) ->
    Sql = io_lib:format("select lv,score,times,daily_score,reward,time from cross_elite where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_elite(StElite) ->
    Sql = io_lib:format("replace into cross_elite set pkey=~p,lv=~p,score=~p,times=~p,daily_score=~p,reward='~s',time=~p",
        [StElite#st_elite.pkey,
            StElite#st_elite.lv,
            StElite#st_elite.score,
            StElite#st_elite.times,
            StElite#st_elite.daily_score,
            util:term_to_bitstring(StElite#st_elite.reward),
            StElite#st_elite.time]),
    db:execute(Sql).