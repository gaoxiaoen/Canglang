%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 二月 2016 上午11:29
%%%-------------------------------------------------------------------
-module(new_shop_rpc).
-author("fengzhenlin").

-include("common.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).

%%获取普通商店信息
handle(38000, Player, {ShopType}) ->
    new_shop:get_shop_info(Player,ShopType),
    ok;

%%购买商店商品
handle(38001, Player, {ShopType, GoodsId, BuyNum}) ->
    case new_shop:buy_shop_goods(Player, ShopType, GoodsId, BuyNum) of
        {false, Res} ->
            {ok, Bin} = pt_380:write(38001, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_380:write(38001, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;


%%获取抢购商店
handle(38010, Player, _) ->
    lim_shop:get_lim_shop_info(Player),
    ok;

%%购买抢购商店
handle(38011, Player, {Id, GoodsId}) ->
    case lim_shop:buy_lim_shop(Player, Id, GoodsId) of
        {false, Res} ->
            {ok, Bin} = pt_380:write(38011, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_380:write(38011, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(_Cmd, _Player, _Data) ->
    ok.