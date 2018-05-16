%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 一月 2015 14:04
%%%-------------------------------------------------------------------
-module(random_shop_rpc).
-include("common.hrl").
-include("server.hrl").
-include("shop.hrl").
-include("error_code.hrl").
-include("achieve.hrl").
%% API
-export([
    handle/3
]).

%%获取神秘商店的物品
handle(18001, Player, {Type}) ->
    random_shop_init:online_refresh(Type, Player),
    random_shop_pack:send_mystycal_shop_info(Player, Type),
    ok;

%%购买神秘商店的物品
handle(18002, Player, {Type, ShopId}) ->
    case catch random_shop:buy_mystycal_shop(Player, Type, ShopId) of
        {ok, NewPlayer, LeftNum} ->
            {ok, Bin} = pt_180:write(18002, {?ER_SUCCEED, Type, ShopId, LeftNum}),
            server_send:send_to_sid(Player#player.sid, Bin),
            case Type of
                ?RANDOM_SHOP_STAR -> star_luck:get_star_luck_info(Player);
                _ -> skip
            end,
            {ok, NewPlayer};
        ErrorCode when is_integer(ErrorCode) ->
            {ok, Bin} = pt_180:write(18002, {ErrorCode, 0, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {false, 2} ->
            {ok, Bin} = pt_180:write(18002, {8, 0, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {false, ErrorCode} ->
            {ok, Bin} = pt_180:write(18002, {ErrorCode, 0, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _OtherError ->
            ?PRINT("18002 _OtherError ~p ~n", [_OtherError]),
            {ok, Bin} = pt_180:write(18002, {?ER_FAIL, 0, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%手动刷新商店
handle(18003, Player, {Type}) ->
    case catch random_shop:refresh(Player, Type) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_180:write(18003, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            random_shop_pack:send_mystycal_shop_info(Player, Type),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4013, 0, 1),
            {ok, NewPlayer};
        ErrorCode when is_integer(ErrorCode) ->
            {ok, Bin} = pt_180:write(18003, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _OtherError ->
            ?PRINT("18003 _OtherError ~p ~n", [_OtherError]),
            {ok, Bin} = pt_180:write(18003, {?ER_FAIL}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

handle(_Cmd, _Player, _Data) ->
    ok.
