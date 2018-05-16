%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十一月 2015 下午8:17
%%%-------------------------------------------------------------------
-module(sign_in_rpc).
-author("fengzhenlin").

-include("server.hrl").
-include("common.hrl").

%% API
-export([
    handle/3
]).

handle(51000, Player, {}) ->
    sign_in:get_sign_in_info(Player),
    ok;

handle(51001, Player, {}) ->
    case sign_in:sign_in(Player) of
        {false, Res} ->
            {ok, Bin} = pt_510:write(51001, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_510:write(51001, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(51002, Player, {Id}) ->
    {Ret, NewPlayer} = sign_in:acc_reward(Player, Id),
    {ok, Bin} = pt_510:write(51002, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ?ERR("sign_in_rpc unknow cmd ~p~n", [_cmd]),
    ok.
