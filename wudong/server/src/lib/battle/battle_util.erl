%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 八月 2015 下午6:23
%%%-------------------------------------------------------------------
-module(battle_util).
-author("fancy").

%% API
-export([
    battle_fail/3
]).

battle_fail(Code,Node,Sid) ->
    {ok,Bin} = pt_200:write(20002,{Code}),
    server_send:send_to_sid(Node,Sid,Bin).