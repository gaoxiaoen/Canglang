-ifndef(MON_PHOTO_HRL).
-define(MON_PHOTO_HRL, 1).

-include("server.hrl").

-record(st_mon_photo, {
    pkey = 0,
    photo_list = [],
    mon_list = [],
    attribute = #attribute{},
    cbp = 0,
    is_change = 0
}).

-record(mon_photo, {
    mid = 0,
    num = 0,
    lv = 0
}).

-record(base_mon_photo_upgrade,
{mid = 0, lv = 0, num_lim = 0, attrs = []}).

-endif.