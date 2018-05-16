-ifndef(EQUIP_SMELT_HRL).
-define(EQUIP_SMELT_HRL, 1).

-include("server.hrl").


-define(SMELT_OPEN_LV,data_menu_open:get(32)).

-record(st_smelt, {
    pkey = 0,
    stage = 0,
    exp = 0,
    attribute = #attribute{},
    cbp = 0,
    is_change = 0,
    is_upgrade = false
}).

%%熔炼
-record(base_smelt, {
    stage = 0,
    exp = 0,
    attrs = []
}).

-endif.
