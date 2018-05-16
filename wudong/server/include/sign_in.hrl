%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十一月 2015 下午6:15
%%%-------------------------------------------------------------------
-author("fengzhenlin").


-record(st_sign_in, {
    pkey = 0,  %%玩家key
    days = 0,  %%累登天数
    sign_in = [],%%签到列表
    acc_reward = [],%%累积登陆奖励
    time = 0,  %%时间戳
    is_change = 0
}).

-record(base_sign_in, {
    days = 0,  %%天数
    goods_id = 0,
    goods_num = 0,
    icon = 0
}).

-record(base_sign_in_acc, {
    id = 0,
    days = 0,
    goods_list = {}
}).