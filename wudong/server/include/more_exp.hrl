%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 二月 2017 17:48
%%%-------------------------------------------------------------------
-author("Administrator").

-define(ETS_MORE_EXP, ets_more_exp).%%多倍经验


-record(base_more_exp_time, {
    id = 0,
    time = [],
    reward = 0,
    start_time = 0,
    lv = 1,
    end_time = 0
}).

-record(more_exp, {
    state = 0,      %% 活动状态
    reward = 1,     %% 奖励倍数
    start_time = 0, %% 开始时间
    end_time = 0    %% 结束时间
}).


