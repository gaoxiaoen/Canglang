%%----------------------------------------------------
%% @doc 自动出售货物
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(market_data_auto).
-export([
        all/0
        ,get/1
    ]
).

-include("market.hrl").

%% 获取所有序号
all() ->
    [2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17].

%% 获取自动出售记录
get(2) ->
    {ok, #market_auto_sale{id = 2, item_base_id = 25021, item_name = <<"紫精魂">>, quantity = 1, price_type = 1, price = 60, range = 10, time = 6, valid_time = 0}};
get(3) ->
    {ok, #market_auto_sale{id = 3, item_base_id = 22201, item_name = <<"三级星辰石">>, quantity = 1, price_type = 1, price = 20, range = 10, time = 6, valid_time = 0}};
get(4) ->
    {ok, #market_auto_sale{id = 4, item_base_id = 23003, item_name = <<"宠物潜力保护符">>, quantity = 1, price_type = 1, price = 60, range = 10, time = 6, valid_time = 0}};
get(5) ->
    {ok, #market_auto_sale{id = 5, item_base_id = 32001, item_name = <<"护神丹">>, quantity = 1, price_type = 1, price = 80, range = 10, time = 6, valid_time = 0}};
get(6) ->
    {ok, #market_auto_sale{id = 6, item_base_id = 22202, item_name = <<"四级星辰石">>, quantity = 1, price_type = 1, price = 100, range = 10, time = 6, valid_time = 0}};
get(7) ->
    {ok, #market_auto_sale{id = 7, item_base_id = 21020, item_name = <<"幸运石">>, quantity = 1, price_type = 1, price = 40, range = 10, time = 6, valid_time = 0}};
get(8) ->
    {ok, #market_auto_sale{id = 8, item_base_id = 21021, item_name = <<"精品幸运石">>, quantity = 1, price_type = 1, price = 100, range = 10, time = 6, valid_time = 0}};
get(9) ->
    {ok, #market_auto_sale{id = 9, item_base_id = 22201, item_name = <<"三级星辰石">>, quantity = 3, price_type = 1, price = 20, range = 10, time = 6, valid_time = 0}};
get(11) ->
    {ok, #market_auto_sale{id = 11, item_base_id = 22201, item_name = <<"三级星辰石">>, quantity = 1, price_type = 1, price = 15, range = 10, time = 6, valid_time = 259200}};
get(12) ->
    {ok, #market_auto_sale{id = 12, item_base_id = 22201, item_name = <<"三级星辰石">>, quantity = 1, price_type = 1, price = 15, range = 10, time = 6, valid_time = 259200}};
get(13) ->
    {ok, #market_auto_sale{id = 13, item_base_id = 22201, item_name = <<"三级星辰石">>, quantity = 1, price_type = 1, price = 15, range = 10, time = 6, valid_time = 259200}};
get(14) ->
    {ok, #market_auto_sale{id = 14, item_base_id = 22202, item_name = <<"四级星辰石">>, quantity = 1, price_type = 1, price = 75, range = 10, time = 6, valid_time = 259200}};
get(15) ->
    {ok, #market_auto_sale{id = 15, item_base_id = 22202, item_name = <<"四级星辰石">>, quantity = 1, price_type = 1, price = 75, range = 10, time = 6, valid_time = 259200}};
get(16) ->
    {ok, #market_auto_sale{id = 16, item_base_id = 25021, item_name = <<"紫精魂">>, quantity = 1, price_type = 1, price = 60, range = 10, time = 6, valid_time = 259200}};
get(17) ->
    {ok, #market_auto_sale{id = 17, item_base_id = 25021, item_name = <<"紫精魂">>, quantity = 1, price_type = 1, price = 60, range = 10, time = 6, valid_time = 259200}};
get(_ID) ->
    {false, <<"没有找到对应的信息">>}.
