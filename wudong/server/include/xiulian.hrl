%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 下午9:03
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-record(st_xiulian,{
    pkey = 0,
    dict = dict:new(),  %%
    tupo_lv = 0,     %%突破等级
    cd_time = 0,     %%cd到期时间
    spec_times = 0,  %%半价使用次数
    spec_update_time = 0, %%半价使用更新时间
    dirty = 0       %%标识db更新
}).

-record(xiulian,{
    id = 0,  %%编号1-6
    lv = 0  %%等级
}).

-record(base_xiulian,{
    id = 0,
    lv = 0,
    cost_gold = 0,
    attrs = [],  %%属性 #attribute{}
    cd_time = 0,
    need_lv = 0,
    need_vip = 0
}).

-record(base_xiulian_tupo,{
    lv = 0,
    pro = 0,
    cost_num = 0,
    attrs = []
}).