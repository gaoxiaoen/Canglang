
-module(energy_data).
-export([get/1, get_gold/1]).

get(0) -> 1;
get(1) -> 2;
get(2) -> 3;
get(3) -> 4;
get(4) -> 5;
get(5) -> 6;
get(6) -> 7;
get(7) -> 8;
get(8) -> 9;
get(9) -> 10;
get(10) -> 11;
get(_VipLvl) -> false.

get_gold(1) -> 50;
get_gold(2) -> 50;
get_gold(3) -> 100;
get_gold(4) -> 100;
get_gold(5) -> 200;
get_gold(6) -> 200;
get_gold(7) -> 400;
get_gold(8) -> 400;
get_gold(9) -> 800;
get_gold(10) -> 800;
get_gold(11) -> 1600;
get_gold(_) -> 0.



