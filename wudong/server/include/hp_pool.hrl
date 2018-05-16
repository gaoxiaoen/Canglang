-ifndef(HP_POOL_HRL).
-define(HP_POOL_HRL, 1).


-record(st_hp_pool, {
    pkey = 0,
    hp = 1000000,
    recover = 100,
    cd = 0,
    is_change = 0
}).

-record(base_hp_pool_goods, {
    goods_id = 0,
    hp = 0,
    price_type = 0,
    price = 0
}).

-endif.