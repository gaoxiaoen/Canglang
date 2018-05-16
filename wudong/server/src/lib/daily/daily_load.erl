%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 一月 2015 17:26
%%%-------------------------------------------------------------------
-module(daily_load).

-include("daily.hrl").
%% API
-export([
    dbclear_daily_data/0,
    dbload_daily_data/1,
    dbreplace_daily_data/1
]).

%%清除所有的日常计数
dbclear_daily_data()->
    Sql = "truncate player_daily_count",
    db:execute(Sql).

%%加载玩家的所有日常计数
dbload_daily_data(Pkey) ->
    Sql = io_lib:format("select daily_count,time from player_daily_count where pkey=~p",[Pkey]),
    db:get_row(Sql).

%%更新替换计数信息
dbreplace_daily_data(Daily) ->
    Sql = io_lib:format("replace into player_daily_count set pkey=~p,daily_count ='~s',time=~p",
        [
            Daily#st_daily_count.pkey,
            util:term_to_bitstring(dict:to_list(Daily#st_daily_count.daily_count)),
            Daily#st_daily_count.time]),
    db:execute(Sql).
