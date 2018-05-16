%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 八月 2017 21:28
%%%-------------------------------------------------------------------
-module(cross_boss_load).
-author("li").
-include("common.hrl").
-include("server.hrl").
-include("cross_boss.hrl").

%% API
-export([
    load/1,
    update/1
]).

load(Pkey) ->
    Sql = io_lib:format("select drop_num, op_time from player_cross_boss where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [DropNum, OpTime] ->
            #st_player_cross_boss{
                pkey = Pkey,
                drop_num = DropNum,
                op_time = OpTime
            };
        _ -> #st_player_cross_boss{pkey = Pkey}
    end.

update(#st_player_cross_boss{pkey = Pkey, drop_num = DropNum, op_time = OpTime}) ->
    Sql = io_lib:format("replace into player_cross_boss set pkey=~p, drop_num=~p, op_time=~p", [Pkey, DropNum, OpTime]),
    db:execute(Sql),
    ok.


