%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 一月 2016 下午8:45
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(ETS_GOODS_COUNT, ets_goods_count).  %%物品统计

-record(cgoods,{
    goods_id = 0,
    num = 0,  %%当天产出的总计数 (全服)
    add_num = 0  %%增量cache
}).