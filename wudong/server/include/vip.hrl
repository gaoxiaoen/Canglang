%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 下午12:09
%%%-------------------------------------------------------------------
-author("fengzhenlin").
-record(st_vip, {
    pkey = 0,
    sum_val = 0,  %%总额度
    charge_val = 0,  %%充值额度
    other_val = 0,  %%其他额度
    lv = 0,  %%vip等级
    buy_list = [],  %%已抢购列表[VipLv1,VipLv2]
    free_lv = 0,  %%体验等级
    free_time = 0,  %%体验到期时间
    week_num = 0,  %% 每周奖励领取数量
    week_get_time = 0  %% 每周领取更新时间
}).


-record(base_time_limit_vip, {
    open_lv = 0,    %% 开启等级
    close_lv = 0,   %% 关闭等级
    time = 0,       %% 体验时间
    re_time = 0,    %% 续费时间
    att = []
}).
