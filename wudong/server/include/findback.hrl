%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 四月 2016 上午10:32
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(ETS_FINDBACK_ACT_TIME, ets_findback_act_time).  %%活动找回时间

%%找回活动最后开启时间
-record(fd_act_time, {
    type = 0,  %%类型
    last_open_time = 0,
    args = []
}).

-record(base_findback_exp,{
    min_lv = 0,
    max_lv = 0,
    exp = 0,   %%每秒可找回经验值
    need_vip1 = 0,   %%双倍找回所需vip等级
    need_vip2 = 0   %%三倍找回所需vip等级
}).

-record(st_findback_exp,{
    pkey = 0,
    outline_time = 0,  %%离线累计时间
    is_get = 1  %%是否领取过
}).


-record(st_findback_src,{
    pkey = 0,
    type_list = [],  %%功能找回信息列表 [#fb_src{}]
    is_update_db = 0
}).

-record(fb_src, {
    type = 0,

    fb_leave_times = 0,  %%可找回次数
    today_use_times = 0,  %%今日使用次数

    fb_exp_round = {0,0},  %%经验副本可找回波数段
    exp_round = 0,  %%经验副本扫荡/通关波数

    fb_guard_round = {0,0},  %%守护副本可找回波数段
    guard_round = 0,  %%守护副本扫荡/通关波数

    fb_dun_ids = [],  %%可找回副本id
    pass_dun_ids = [],  %%副本通关列表 [{dunid,time}]

    fb_daily_task_gift = 0,    %%日常任务找回完成奖励是否可找回
    get_daily_task_gift_time = 0,  %%日常任务完成奖励领取时间

    fb_guild_task_gift = 0,   %%帮派任务完成奖励是否可找回
    get_guild_task_gift_time = 0,  %%帮派任务完成奖励领取时间

    last_update_time = 0,  %%最后使用/通关时间
    last_findback_time = 0  %%最后找回时间
}).

-record(base_findback_src,{
    type = 0,  %%找回的功能类型
    min_lv = 0,
    max_lv = 0,
    name = "",
    cost_gold = 0,
    find_goods = []  %%特殊类型 直接找回奖励
}).