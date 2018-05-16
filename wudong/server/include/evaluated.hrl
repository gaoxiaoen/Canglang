-ifndef(EVALUATED_HRL).
-define(EVALUATED_HRL, 1).


-define(ETS_CBP_EVALUATED,ets_cbp_evaluated).

%%战力跑分
-record(ets_cbp_evaluated,{
    pkey = 0,
    point = 0,
    evaluated = []
}).

-record(base_cbp_evaluated, {
    id = 0,
    type = 0,
    subtype = 0,
    name = "",
    lv = 0,
    expected = 0,
    eva_list = [],
    percent = 0,
    open_lv = 0

}).

-endif.