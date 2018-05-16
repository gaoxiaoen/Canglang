-ifndef(MARKET_HRL).
-define(MARKET_HRL, 1).


-define(MARKET_SHELVES_TIME_LIST, [6 * 3600, 12 * 3600, 24 * 3600]).

-record(st_market, {market_list = []}).

-record(market, {
    mkey = 0,
    pkey = 0,
    price = 0,
    tip = 0,
    time = 0,
    goods_id = 0,
    goods_name = <<>>,
    num = 0,
    type = 0,
    args = [],
    subtype = 0
}).

-record(st_market_p, {
    key = 0
    , sell_num = 0
    , buy_num = 0
    , op_time = 0
}).

-endif.

