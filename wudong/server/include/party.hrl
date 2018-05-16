-ifndef(PARTY_HRL).
-define(PARTY_HRL, 1).

%%-define(ETS_PARTY, ets_party).

-define(PARTY_TIME, 1800).

-define(EAT_TIME_LIM, 20).

-record(st_party, {
    date_list = [],
    log = [],
    party_list = [],
    party_state = 0,
    party_time = 0,
    ref = []

}).

-record(party, {
    akey = 0,
    date = 0,
    time = 0,
    pkey = 0,
    type = 0,
    status = 0,
    price_type = 0,
    price = 0,
    invite_list = [],%%[{pkey,times}]
    nickname = <<>>,
    career = 0,
    sex = 0,
    avatar = "",
    mon_key_list = []
}).
-record(party_state, {
    party_key = 0,
    pkey = 0,
    price_type = 0,
    price = 0
}).
-record(base_party, {
    type = 0,
    desc = <<>>,
    price_type = 0,
    price = 0,
    daily_times = 0,
    table_num = 0,
    guest_num = 0,
    master_goods = {},
    master_goods_ratio = {},
    guest_goods = {},
    eat_times = 0,
    exp_add = 0,
    table_list = []
}).

-endif.

