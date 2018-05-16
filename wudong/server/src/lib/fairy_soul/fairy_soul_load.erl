%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 10:35
%%%-------------------------------------------------------------------
-module(fairy_soul_load).
-author("Administrator").
-include("fairy_soul.hrl").

%% API
-export([
    dbget_fairy_soul_info/1
    , dbup_fairy_soul_info/1
]).
dbget_fairy_soul_info(Pkey) ->
    Sql = io_lib:format("select exp,chip,pos,floor,max_floor,list,is_first from player_fairl_soul where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [Exp, Chip, Pos, Floor, MaxFloor, List, IsFirst] ->
            #st_fairy_soul{
                pkey = Pkey,
                pos = Pos,
                exp = Exp,
                chips = Chip,
                floor = Floor,
                max_floor = MaxFloor,
                list = util:bitstring_to_term(List),
                is_first = IsFirst
            };
        _ ->
            #st_fairy_soul{pkey = Pkey}
    end.

dbup_fairy_soul_info(St) ->
    #st_fairy_soul{
        pkey = Pkey,
        pos = Pos,
        exp = Exp,
        chips = Chip,
        floor = Floor,
        max_floor = MaxFloor,
        list = List,
        is_first = IsFirst
    } = St,
    Sql = io_lib:format("replace into player_fairl_soul set pkey=~p,exp=~p,chip=~p,pos=~p,floor =~p,max_floor =~p,list = '~s',is_first = ~p",
        [Pkey, Exp, Chip, Pos, Floor, MaxFloor, util:term_to_bitstring(List), IsFirst]),
    db:execute(Sql),
    ok.
