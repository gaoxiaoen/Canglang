-module(pet_config).
-export([get_config/1]).
-include("common.hrl").

get_config(101) ->
	{ok,
		{pet, [{base_id, 101},{name, <<"光辉圣龙">>}, {potential, 0, 0, 0, 0}, {per, 25, 25, 25, 25}]}
		};
get_config(102) ->
	{ok,
		{pet, [{base_id, 102},{name, <<"吟游晶龙">>}, {potential, 0, 0, 0, 0}, {per, 25, 25, 25, 25}]}
		};
get_config(103) ->
	{ok,
		{pet, [{base_id, 103},{name, <<"荒古地龙">>}, {potential, 0, 0, 0, 0}, {per, 25, 25, 25, 25}]}
		};
get_config(_BaseId) ->
	{false, ?L(<<"伙伴初始化数据不存在">>)}.