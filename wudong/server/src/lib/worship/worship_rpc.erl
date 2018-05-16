%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 三月 2016 下午2:26
%%%-------------------------------------------------------------------
-module(worship_rpc).
-author("fengzhenlin").
-include("worship.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).

handle(_cmd,_Player,_Data) ->
    ?ERR("worship cmd ~p~n",[_cmd]),
    ok.