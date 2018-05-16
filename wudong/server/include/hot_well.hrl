%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 五月 2017 下午8:08
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(ETS_HOT_WELL, ets_hot_well).

-define(HOT_WELL_OPEN_TIME, [{12,0},{18,0}]).  %%开始时间
-define(HOT_WELL_READY_TIME, [{11,30},{17,30}]).  %%准备时间

-define(HOT_WELL_TIME, 1800).  %%活动持续时间
-define(EXP_TIME, 5).  %%定时给经验
-define(SX_TIME, 1).  %%双修匹配时间
-define(MAX_JOKE_TIMES, 10).  %%可整蛊次数
-define(JOKE_CD_TIME, 10).  %%整蛊cd

-record(hot_well_st, {
    state = 0,  %%状态 0未开启1开启2准备开启
    open_time = 0,
    end_time = 0,
    end_ref = 0,
    exp_ref = 0,  %%定时给经验
    sx_ref = 0  %%双修匹配计时器
}).

-record(hot_well, {
    pkey = 0,
    pf = 0,
    sn = 0, %% 玩家服号
    node = 0,
    vip_lv = 0,
    sex = 0,
    sid = [],
    pid = 0,
    sx_state = 0,  %%双修状态 0没1有
    sx_pkey = 0,  %%双修玩家key
    sx_apply_time = 0,  %%双修开始申请时间
    sum_exp = 0,   %%总经验
    is_leave = 0,  %%是否已经离开场景
    joke_times = 0,  %%整蛊次数
    joke_cd_time = 0,   %%整蛊时间
    joke_exp = 0,    %%整蛊经验
    copy = 0
}).