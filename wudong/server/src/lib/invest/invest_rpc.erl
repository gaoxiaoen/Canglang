%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2016 下午3:56
%%%-------------------------------------------------------------------
-module(invest_rpc).
-author("and_me").

-include("common.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).


handle(27000,Player,_) ->
	invest:invest_info(Player),
    ok;

handle(27002,Player,{Type,Id}) ->
	case catch invest:get_invest_award(Player,Type,Id) of
		{false, Res} ->
			?PRINT("27002 ~p ~p ~n",[Res,Id]),
			{ok, Bin} = pt_270:write(27002,{Res}),
			server_send:send_to_sid(Player#player.sid,Bin),
			ok;
		{ok, NewPlayer} ->
			activity:get_notice(NewPlayer, [79], true),
			{ok, Bin} = pt_270:write(27002,{1}),
			server_send:send_to_sid(Player#player.sid,Bin),
			{ok, NewPlayer}
	end;

handle(_cmd,_Player,_Data) ->
    ?ERR("crazy_click cmd ~p~n",[_cmd]),
    ok.

