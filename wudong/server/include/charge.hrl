%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 05. 三月 2015 19:56
%%%-------------------------------------------------------------------
-author("fzl").

-record(st_charge, {
    pkey = 0,  %%玩家key
    pf = 0,
    total_fee = 0,
    total_gold = 0,
    dict = dict:new(),  %%充值项信息 #charge{}
    return_time = 0  %%充值返还时间
}).

-record(charge, {
    id = 0,  %%充值项ID
    times = 0,  %%充值次数
    last_time = 0 %%最后充值时间
}).

-record(base_charge, {
    id = 0,
    pf = 0,  %%平台
    type = 0,  %%货币类型 0人民币1美金
    min_price = 0, %%该档最少充值价格
    max_price = 0, %%该档最大充值价格
    price = 0,  %%价格 客户端显示用
    get_gold = 0,  %%充值可得元宝数 客户端显示用
    first_get_gold = 0,  %%首充赠送元宝数
    second_get_gold = 0,  %%首充后，每次充值赠送元宝数
    refresh_time = [],  %%刷新首充时间列表 [{weekday,1},{monthday,1},{openday,7},all,once] 依次代表周一，每月一号，开服第七天，永久, 一次有效
    goods_id = 0,  %%充值赠送物品id
    is_month_card = 0,  %%是否月卡
    charge_gift_day = 0,%%绑元礼包天数
    charge_gift_bgold = 0,%%绑元礼包返回元宝
    commend = 0  %%角标类型 0没有1推荐
}).

-record(st_week_card, {
    remain_day = 0, %% 当前剩余天数
    use_time = 0 %% 上次邮件奖励时间
}).