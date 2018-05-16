%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%     韩文限时激活码领取
%%% @end
%%% Created : 22. 一月 2018 14:14
%%%-------------------------------------------------------------------
-module(card_custom).
-author("hxming").


-include("server.hrl").
-include("common.hrl").
-define(CARD_SERVER_URL, lists:concat([config:get_api_url(), "/use_card_custom.php"])).

%% API
-export([
    get_card_gift/2
]).

-export([http_get_card_gift/2]).

get_card_gift(Player, CardId) ->
    case http_get_card_gift(Player#player.key, CardId) of
        {false, Res} ->
            {false, Res};
        {ok, GiftId} ->
            GiveGoodsList = goods:make_give_goods_list(120, [{GiftId, 1}]),
            goods:give_goods(Player, GiveGoodsList)
    end.



http_get_card_gift(Pkey, CardId) ->
    %%发送卡号验证
    PostData = io_lib:format("pkey=~p&card=~s&sign=~s", [Pkey, CardId, "Z0uEBKg2DuBRQgbA"]),
    PostData2 = unicode:characters_to_list(PostData, unicode),
    %%接收服务器验证卡号的返回信息
    case httpc:request(post, {?CARD_SERVER_URL, [], "application/x-www-form-urlencoded", PostData2}, [{timeout, 2000}], []) of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, JSONlist}, _} ->
                    case lists:keyfind("ret", 1, JSONlist) of
                        false ->
                            ?WARNING("JSONlist err ~p~n", [JSONlist]),
                            {false, 0};
                        {_, Res} ->
                            case Res =/= 1 of
                                true ->
                                    case is_integer(Res) of
                                        false ->
                                            ?DEBUG("Res err ~p~n", [JSONlist]),
                                            {false, 0};
                                        true ->
                                            ?DEBUG("Res true res ~p~n", [JSONlist]),
                                            {false, Res}
                                    end;
                                false ->
                                    case lists:keyfind("giftid", 1, JSONlist) of
                                        false ->
                                            ?DEBUG("http card josn giftid err:~p~n", [false]),
                                            {false, 0};
                                        {_, GiftId} ->
                                            {ok, util:to_integer(GiftId)}
                                    end
                            end
                    end;
                _E1 ->
                    ?ERR("http card josn err:~p~n", [_E1]),
                    {false, 0}
            end;
        {error, _Reason} ->
            ?ERR("http request card err:~p~n", [_Reason]),
            {false, 0}
    end.

