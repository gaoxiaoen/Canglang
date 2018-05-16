%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2016 上午10:47
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(MONTH_CARD_ETS, month_card_ets).  %%全服月卡购买

%%月卡
-record(st_month_card,{
    pkey = 0,
    start_time = 0,  %%开始时间
    end_time = 0,   %%结束时间
    get_day = 0 %%已领取天数
}).

-record(month_card,{
    buy_time = 0,
    start_time = 0,
    end_time = 0
}).

-record(base_month_card,{
    day = 0,
    gift_id = 0
}).

%%终身卡
-record(st_live_card,{
    pkey = 0,
    start_time = 0,
    last_get_time = 0
}).

-record(base_live_card,{
    day = 0,
    gift_id = 0
}).

%%全民福利
-record(st_month_card_gift,{
    pkey = 0,
    get_list = [],  %%已领取记录
    month_card_time = 0,  %%月卡激活时间
    live_card_time = 0,  %%终身卡激活时间
    update_time = 0
}).

-record(base_month_card_gift,{
    buy_num = 0,
    gift_id = 0,
    need_vip = 0
}).