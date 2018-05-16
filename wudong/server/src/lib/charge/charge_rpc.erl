%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 05. 三月 2015 20:25
%%%-------------------------------------------------------------------
-module(charge_rpc).
-author("fzl").

%% API
-export([
    handle/3
]).

handle(46000,Player,_) ->
    charge:get_charge_info(Player),
    ok;

handle(_cmd,_Player,_Data) ->
    ok.
