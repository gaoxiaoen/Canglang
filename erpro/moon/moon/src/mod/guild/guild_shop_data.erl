
-module(guild_shop_data).
-export([get/1, cost/1]).






get(1) -> {ok,[111001,131001]};
get(2) -> {ok,[621100,611101,641201,621501,111001,131001]};
get(_ShopLvl) -> {false}.

cost(111001) -> 20;
cost(131001) -> 100;
cost(621100) -> 50;
cost(611101) -> 500;
cost(641201) -> 100;
cost(621501) -> 400;
cost(111301) -> 80;
cost(231001) -> 100;
cost(_ID) -> false.





