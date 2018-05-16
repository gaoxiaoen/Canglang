-ifndef(PANIC_BUYING_HRL).
-define(PANIC_BUYING_HRL, 1).


-define(PANIC_BUYING_STATE_BUY, 0).
-define(PANIC_BUYING_STATE_REWARD, 1).
-define(PANIC_BUYING_STATE_FINISH, 2).

%%券id
-define(PANIC_BUYING_GOODS_ID, 0).
-define(PANIC_BUYING_CONFORT_GOODS_ID, 0).

-record(st_panic_buying, {
    goods_list = [],
    cache_list = [],
    ref = [],
    open_state = 0,
    time = 0
}).

%%
-record(pb_goods, {
    id = 0,
    type = 0,
    date = 0,
    goods_id = 0,
    num = 0,
    times = 0,
    buy_log = [],
    time = 0,
    ref = [],
    state = 0,
    lucky_num = 0,
    pkey = 0
}).

-record(pb_mb, {
    sn = 0,
    pkey = 0,
    nickname = <<>>,
    num_list = [],
    time = 0
}).

-record(log_panic_buying, {
    sn = 0,
    pkey = 0,
    nickname = <<>>,
    goods_id = 0,
    num = 0,
    time = 0
}).

-record(base_panic_buying, {
    id = 0,
    type = 0,
    goods_id = 0,
    num = 0,
    times = 0,
    time = 0,
    ratio = 0
}).

-endif.