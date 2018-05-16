%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 下午4:37
%%%-------------------------------------------------------------------
-module(day7login_rpc).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).

handle(52000,Player,_) ->
    day7login:get_day7login_info(Player),
    ok;

handle(52001,Player,{Days}) ->
    case day7login:get_gift(Player,Days) of
        {false, Res} ->
            ?DEBUG("Res ~p~n",[Res]),
            {ok, Bin} = pt_520:write(52001,{Res}),
            server_send:send_to_sid(Player#player.sid,Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_520:write(52001,{1}),
            server_send:send_to_sid(Player#player.sid,Bin),
            {ok, NewPlayer}
    end;

handle(_cmd,_Player,_Data) ->
    ?ERR("day7login bad cmd ~p~n",[_cmd]),
    ok.