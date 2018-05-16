%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2016 下午3:56
%%%-------------------------------------------------------------------
-module(crazy_click_rpc).
-author("fengzhenlin").

-include("common.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).


handle(39000,Player,_) ->
    crazy_click:get_crazy_click_info(Player),
    activity:get_notice(Player,[69],true),
    ok;

handle(39001,Player,_) ->
    case crazy_click:att_mon(Player) of
        {false, Res} ->
            PackMon = crazy_click:pack_mon(Player),
            {ok, Bin} = pt_390:write(39001,{Res,0,0,0,0,0,[],PackMon}),
            server_send:send_to_sid(Player#player.sid,Bin),
            ok;
        {ok, NewPlayer, Hurt,Mul,Coin,Exp,MonState,GoodsList,PackMon} ->
            {ok, Bin} = pt_390:write(39001,{1,Hurt,Mul,Coin,Exp,MonState,GoodsList,PackMon}),
            server_send:send_to_sid(Player#player.sid,Bin),
            activity:get_notice(Player,[69],true),
            {ok, NewPlayer}
    end;

handle(_cmd,_Player,_Data) ->
    ?ERR("crazy_click cmd ~p~n",[_cmd]),
    ok.

