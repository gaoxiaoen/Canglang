
-module(newhand_equip_data).
-export([get/1]).

get(5) -> [101001];
get(3) -> [102001];
get(2) -> [103001];
get(_Career) -> [].


