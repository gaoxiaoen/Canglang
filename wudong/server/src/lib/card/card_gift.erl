%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 一月 2016 下午8:36
%%%-------------------------------------------------------------------
-module(card_gift).
-author("fengzhenlin").

-include("server.hrl").
-include("common.hrl").
-define(CARD_SERVER_URL, lists:concat([config:get_api_url(),"/use_card.php"])).

%% API
-export([
    get_card_gift/2
]).

get_card_gift(Player,CardId) ->
    case check_get_card_gift(Player,CardId) of
        {false, Res} ->
            {false, Res};
        ok ->
            case http_get_card_gift(Player,CardId) of
                {false, Res} ->
                    {false, Res+10};
                {ok, GiftId} ->
                    GiveGoodsList = goods:make_give_goods_list(120,[{GiftId,1}]),
                    goods:give_goods(Player, GiveGoodsList)
            end
    end.

check_get_card_gift(_Player,CardId) ->
    Len = length(CardId),
    if
        Len =/= 12 ->
            {false, 2};
        true ->
            ok
    end.

http_get_card_gift(Player,CardId) ->
    %%发送卡号验证
    PostData=io_lib:format("ac=use&card=~s&pkey=~p&sn=~p&pf=~p",[CardId,Player#player.key,
        Player#player.sn,
        Player#player.pf]),
    PostData2= unicode:characters_to_list(PostData,unicode),
    %%接收服务器验证卡号的返回信息
    case httpc:request(post,{?CARD_SERVER_URL,[],"application/x-www-form-urlencoded",PostData2},[{timeout,2000}],[]) of
        {ok, {_,_,Body}}->
            case rfc4627:decode(Body) of
                {ok,{obj,JSONlist},_} ->
                    case lists:keyfind("ret",1,JSONlist) of
                        false ->
                            ?ERR("JSONlist err ~p~n",[JSONlist]),
                            {false, 0};
                        {_,Res} ->
                            case Res =/= 1 of
                                true ->
                                    case is_integer(Res) of
                                        false ->
                                            ?DEBUG("Res err ~p~n",[JSONlist]),
                                            {false, 0};
                                        true ->
                                            ?DEBUG("Res true res ~p~n",[JSONlist]),
                                            {false, Res}
                                    end;
                                false ->
                                    case lists:keyfind("giftid",1,JSONlist) of
                                        false ->
                                            ?DEBUG("http card josn giftid err:~p~n",[false]),
                                            {false, 0};
                                        {_,GiftId} ->
                                            {ok, util:to_integer(GiftId)}
                                    end
                            end
                    end;
                _E1->
                    ?ERR("http card josn err:~p~n",[_E1]),
                    {false,0}
            end;
        {error, _Reason}->
            ?ERR("http request card err:~p~n",[_Reason]),
            {false, 0}
    end.
