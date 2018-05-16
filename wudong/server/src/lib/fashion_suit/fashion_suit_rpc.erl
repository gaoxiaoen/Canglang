%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十月 2017 16:49
%%%-------------------------------------------------------------------
-module(fashion_suit_rpc).
-include("common.hrl").
-include("server.hrl").

-author("lzx").

%% API
-export([handle/3]).


%%请求时装套装信息
handle(44101, Player, {}) ->
    fashion_suit:fashion_suit_list(Player),
    ok;


%%请求激活套装
handle(44102, Player, {SuitId}) ->
    case fashion_suit:active_suit_id(Player, SuitId) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [164], true),
            {ok, BinData} = pt_441:write(44102, {1}),
            server_send:send_to_sid(Player#player.sid, BinData),
            handle(44105, NewPlayer, {SuitId});
        {fail, Res} ->
            {ok, BinData} = pt_441:write(44102, {Res}),
            server_send:send_to_sid(Player#player.sid, BinData),
            ok
    end;

%%请求激活套装
handle(44104, Player, {GoodsId}) ->
    fashion_suit:fashion_suit_info(Player, GoodsId),
    ok;

%%请求激活套装等级属性
handle(44105, Player, {SuitId}) ->
    {Res, NewPlayer} = fashion_suit:active_suit_lv_attr(Player, SuitId),
    activity:get_notice(NewPlayer, [164], true),
    {ok, BinData} = pt_441:write(44105, {Res}),
    server_send:send_to_sid(Player#player.sid, BinData),
    {ok, attr, NewPlayer};

handle(Cmd, _Player, Args) ->
    ?ERR("Cmd not match ~w, ~w", [Cmd, Args]),
    ok.
