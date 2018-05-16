%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 17:17
%%%-------------------------------------------------------------------
-module(market_load).
-author("hxming").

-include("market.hrl").
%% API
-compile(export_all).

load_market() ->
    Sql = "select `mkey`,pkey,goods_id,num,price,tip,args,time from market",
    db:get_all(Sql).

new_market(MarketShop) ->
    SQL = io_lib:format("insert into market (`mkey`,pkey,goods_id,num,price,tip,args,time) values(~p,~p,~p,~p,~p,~p,'~s',~p)",
        [MarketShop#market.mkey,
            MarketShop#market.pkey,
            MarketShop#market.goods_id,
            MarketShop#market.num,
            MarketShop#market.price,
            MarketShop#market.tip,
            util:term_to_bitstring(MarketShop#market.args),
            MarketShop#market.time
        ]),
    db:execute(SQL).

del_market(Key) ->
    SQL = io_lib:format("DELETE FROM market where `mkey` = ~p", [Key]),
    db:execute(SQL).


log_market(Pkey, Nickname, Type, GoodsId, Num, Price, Time) ->
    Sql = io_lib:format("insert into log_market set pkey=~p,nickname='~s',type=~p,goods_id=~p,num=~p,price=~p,time=~p",
        [Pkey, Nickname, Type, GoodsId, Num, Price, Time]),
    log_proc:log(Sql).

load_market_p(Pkey) ->
    Sql = io_lib:format("select sell_num, buy_num, op_time from player_market where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [SellNum, BuyNum, OpTime] ->
            #st_market_p{
                key = Pkey,
                sell_num = SellNum,
                buy_num = BuyNum,
                op_time = OpTime
            };
        _ ->
            #st_market_p{key = Pkey}
    end.

update_market_p(St) ->
    #st_market_p{
        key = Pkey,
        sell_num = SellNum,
        buy_num = BuyNum,
        op_time = OpTime
    } = St,
    Sql = io_lib:format("replace into player_market set pkey=~p, sell_num=~p, buy_num=~p, op_time=~p",
        [Pkey, SellNum, BuyNum, OpTime]),
    db:execute(Sql).

clean_market_p_data() ->
    Sql = io_lib:format("update player_market set sell_num = 0", []),
    db:execute(Sql),
    ok.