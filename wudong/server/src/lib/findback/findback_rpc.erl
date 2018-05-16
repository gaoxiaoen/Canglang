%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 四月 2016 上午11:17
%%%-------------------------------------------------------------------
-module(findback_rpc).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("achieve.hrl").
%% API
-export([
    handle/3
]).

handle(38100, Player, _) ->
    findback_exp:get_findback_exp_info(Player),
    ok;

handle(38101, Player, {Mul}) ->
    case findback_exp:get_findback_exp(Player, Mul) of
        {false, Res} ->
            {ok, Bin} = pt_381:write(38101, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_381:write(38101, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(38110, Player, _) ->
    findback_src:get_findback_src_info(Player),
    ok;

handle(38111, Player, {Type, CostType}) ->
    case findback_src:get_findback_src(Player, Type, CostType) of
        {false, Res} ->
            {ok, Bin} = pt_381:write(38111, {Res, Type, CostType, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, GoodsList} ->
            {ok, Bin} = pt_381:write(38111, {1, Type, CostType, GoodsList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ?DO_IF(Type == 0, achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4003, 0, 1)),
            {ok, NewPlayer}
    end;

handle(_cmd, _Player, _Data) ->
    ?ERR("findback_rpc cmd ~p~n", [_cmd]),
    ok.
