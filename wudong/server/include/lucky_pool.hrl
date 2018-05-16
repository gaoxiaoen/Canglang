-ifndef(LUCKY_POOL_HRL).
-define(LUCKY_POOL_HRL, 1).



-define(LUCKY_POOL_READY_TIME, 5 * 60).


-define(LUCKY_POOL_STATE_CLOSE, 0).
-define(LUCKY_POOL_STATE_READY, 1).
-define(LUCKY_POOL_STATE_START, 2).




-record(st_lucky_pool, {
    open_state = 0,
    time = 0,
    ref = [],
    coin = 0,
    log_coin = [],
    log_goods = [],
    p_dict = dict:new()

}).


-record(base_lucky_pool, {
    pos = 0,
    goods_id = 0,
    num = 0,
    type = 0,
    ratio = 0,
    is_show = 0


}).

-record(lp_log_coin, {
    pkey = 0,
    nickname = 0,
    career = 0,
    coin = 0,
    time = 0
}).


-record(lp_log_goods, {
    pkey = 0,
    nickname = 0,
    career = 0,
    goods_id = 0,
    num = 0
}).

-endif.
