%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 三月 2017 20:22
%%%-------------------------------------------------------------------
-module(buff_load).
-author("hxming").

-include("skill.hrl").

%% API
-compile(export_all).

load_buff(Pkey) ->
    Sql = io_lib:format("select buff_list from buff where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_buff(StBuff) ->
    Sql = io_lib:format("replace into buff set pkey=~p,buff_list='~s'",
        [StBuff#st_buff.pkey, util:term_to_bitstring(StBuff#st_buff.buff_list)]),
    db:execute(Sql).


