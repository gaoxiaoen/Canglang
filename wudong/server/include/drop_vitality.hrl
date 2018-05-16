%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 七月 2016 上午11:31
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-record(st_drop_vitality,{
    pkey = 0,
    task_list = [],  %%任务列表 [#d_v{}]
    history_list = [],  %%历史分数[{point,time}]
    sum_point = 0,
    update_time = 0
}).

-record(d_v,{
    id = 0,
    arg1 = 0,
    arg2 = 0,
    state = 0,  %%状态 0未完成 1已完成
    update_time = 0
}).

-record(base_d_v,{
    id = 0,
    type = 0,
    args = {},
    point = 0,  %%完成获得分数
    refresh_type = 0 %%刷新类型 1永久 2每天刷新
}).