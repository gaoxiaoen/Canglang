%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2017 15:33
%%%-------------------------------------------------------------------
-module(party_init).
-author("hxming").

-include("common.hrl").
-include("goods.hrl").
-include("party.hrl").
%% API
-export([init/0, init_party_state/0, mail_gold_back/3]).


init() ->
    Now = util:unixtime(),
    Midnight = util:get_today_midnight(Now),
    F = fun([Akey, Date, Time, Pkey, Type, Status, PriceType, Price]) ->
        if Date < Midnight ->
            if Status == 0 ->
                party_load:delete_party(Akey),
                party_load:delete_party_state(Akey),
                mail_gold_back(Pkey, PriceType, Price),
                [];
                true ->
                    []
            end;
            true ->
                if Time < Now andalso Status == 0 ->
                    party_load:delete_party(Akey),
                    party_load:delete_party_state(Akey),
                    mail_gold_back(Pkey, PriceType, Price);
                    true -> ok
                end,
                [#party{akey = Akey, date = Date, time = Time, pkey = Pkey, type = Type, status = Status, price_type = PriceType, price = Price}]
        end
        end,
    lists:flatmap(F, party_load:load_party_all()).

%%退还资金
mail_gold_back(Pkey, PriceType, Price) ->
    GoodsId =
        case PriceType of
            1 -> ?GOODS_ID_BGOLD;
            _ -> ?GOODS_ID_GOLD
        end,
    mail:sys_send_mail([Pkey], ?T("晚宴退款"), ?T("您预约的晚宴未能预期举行,退还费用,请查收"), [{GoodsId, Price}]),
    ok.


init_party_state() ->
    F = fun([PartyKey, Pkey, PriceType, Price]) ->
        #party_state{party_key = PartyKey, pkey = Pkey, price = Price, price_type = PriceType}
        end,
    lists:map(F, party_load:load_party_state()).

