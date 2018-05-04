-module(manor_enchant_data).
-export([get/1]).

get(Enchant) when Enchant >= 1 andalso Enchant =< 45-> {1021,3,3};
get(Enchant) when Enchant >= 46 andalso Enchant =< 75-> {1022,2,2};
get(Enchant) when Enchant >= 76 andalso Enchant =< 90-> {1023,2,2};
	get(_E) -> false.



