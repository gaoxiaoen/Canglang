%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 十一月 2015 下午8:27
%%%-------------------------------------------------------------------
-module(gift_rpc).
-author("fengzhenlin").

-include("common.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).

handle(53000,Player,{}) ->
    lv_gift:get_lv_gift_info(Player),
    ok;

handle(53001,Player,{Lv}) ->
    case lv_gift:get_gift(Player,Lv) of
        {false, Res} ->
            {ok, Bin} = pt_530:write(53001,{Res,0,0}),
            server_send:send_to_sid(Player#player.sid,Bin),
            ok;
        {ok, NewPlayer, NewState} ->
            {ok, Bin} = pt_530:write(53001,{1,Lv,NewState}),
            server_send:send_to_sid(Player#player.sid,Bin),
            {ok, NewPlayer}
    end;

handle(53002, Player, {Type}) ->
    ?DEBUG("53002 ~n"),
    Data = res_gift:check_gift_state(Type, Player),
    {ok, Bin} = pt_530:write(53002, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(53003, Player, {Type}) ->
    ?DEBUG("53003 ~n"),
    {Ret, NewPlayer} = res_gift:get_gift(Type, Player),
    {ok, Bin} = pt_530:write(53003, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(53004,Player,{})->
    res_gift:praise_gift(Player),
    ok;

handle(53005,Player,{})->
    res_gift:set_is_get(Player),
    {ok, Bin} = pt_530:write(53005, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;



handle(_cmd,_Player,_Data) ->
    ?ERR("lv gift bad cmd ~p~n",[_cmd]),
    ok.
