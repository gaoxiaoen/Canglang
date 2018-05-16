%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 五月 2017 15:17
%%%-------------------------------------------------------------------
-module(fuwen_load).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("fuwen.hrl").

%% API
-export([
    dbget_self_fuwen_info/1,
    dbup_self_fuwen_info/1
]).

dbget_self_fuwen_info(Pkey) ->
    Sql = io_lib:format("select fuwen_exp,fuwen_chip,pos from player_fuwen where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [FuwenExp, FuwenChip, Pos] ->
            #st_fuwen{
                pkey = Pkey,
                exp = FuwenExp,
                chips = FuwenChip,
                pos = Pos
            };
        _ ->
            #st_fuwen{pkey = Pkey}
    end.

dbup_self_fuwen_info(#st_fuwen{pkey = Pkey, exp = FuwenExp, chips = FuwenChip, pos = Pos}) ->
    Sql = io_lib:format("replace into player_fuwen set pkey=~p,fuwen_exp=~p,fuwen_chip=~p,pos=~p", [Pkey,FuwenExp,FuwenChip,Pos]),
    db:execute(Sql),
    ok.
