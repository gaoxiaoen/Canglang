%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 下午2:26
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-record(st_yuanli,{
    pkey = 0,
    dict = dict:new(),  %%原力
    tupo_lv = 0,     %%突破等级
    cd_time = 0,     %%cd到期时间
    spec_times = 0,  %%特殊优惠使用次数
    spec_update_time = 0,  %%特殊优惠更新时间
    dirty = 0
}).

-record(yuanli,{
    id = 0,  %%编号1-6
    lv = 0  %%等级
}).

-record(base_yuanli,{
    id = 0,
    lv = 0,
    cost_coin = 0,
    attrs = [],  %%属性 #attribute{}
    cd_time = 0,
    need_lv = 0
}).

-record(base_yuanli_tupo,{
    lv = 0,
    pro = 0,
    cost_num = 0,
    attrs = []  %%突破属性 #attribute{}
}).