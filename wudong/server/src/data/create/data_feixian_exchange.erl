%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_feixian_exchange
	%%% @Created : 2018-05-03 16:44:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_feixian_exchange).
-export([get/1]).
-export([get_all/0]).
-include("xian.hrl").
get(1) -> #base_xian_exchange{
			id = 1,
			exchange_cost = [{7415001, 90}],
			exchange_get = [{7415006, 1}],
			exchange_num=1
		};
get(2) -> #base_xian_exchange{
			id = 2,
			exchange_cost = [{7415001, 105}],
			exchange_get = [{7415007, 1}],
			exchange_num=1
		};
get(3) -> #base_xian_exchange{
			id = 3,
			exchange_cost = [{7415001,120}],
			exchange_get = [{7415008, 1}],
			exchange_num=1
		};
get(4) -> #base_xian_exchange{
			id = 4,
			exchange_cost = [{7415001, 80}],
			exchange_get = [{7415009, 1}],
			exchange_num=1
		};
get(5) -> #base_xian_exchange{
			id = 5,
			exchange_cost = [{7415002, 30}],
			exchange_get = [{7415006, 1}],
			exchange_num=2
		};
get(6) -> #base_xian_exchange{
			id = 6,
			exchange_cost = [{7415003, 30}],
			exchange_get = [{7415007, 1}],
			exchange_num=2
		};
get(7) -> #base_xian_exchange{
			id = 7,
			exchange_cost = [{7415004, 30}],
			exchange_get = [{7415008, 1}],
			exchange_num=2
		};
get(8) -> #base_xian_exchange{
			id = 8,
			exchange_cost = [{7415005, 30}],
			exchange_get = [{7415009, 1}],
			exchange_num=2
		};
get(_id) -> [].

get_all() -> [1,2,3,4,5,6,7,8].
