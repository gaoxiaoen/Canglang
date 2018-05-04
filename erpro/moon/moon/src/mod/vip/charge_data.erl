
-module(charge_data).
-export([get/1, get_discount_info/1]).

get(30) -> 3900;
get(6) -> 60;
get(68) -> 680;
get(128) -> 1280;
get(328) -> 3280;
get(648) -> 6480;
get(1280) -> 12800;
get(_Id) -> false.

get_discount_info(_Id) -> false.


