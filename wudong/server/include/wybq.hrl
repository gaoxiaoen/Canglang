%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 我要变强
%%% @end
%%% Created : 15. 三月 2017 14:41
%%%-------------------------------------------------------------------
-author("li").

-record(base_wybq,{
    type = 0 %% 大类
    ,percent = 0 %% 万分比
    ,desc = ""
}).

-record(st_wybq, {
    pkey = 0
    ,cbp = 0
    ,lv = 0
    ,cbp_list = [] %% [{类型, 战力}]
}).

%% 缓存数据
-record(ets_sys_wybq, {
    pkey = 0
    ,cbp = 0 %% 当前总战力
    ,lv = 0
    ,cbp_list = [] %% [{类型, 战力}]
}).

%% 我要变强 每隔5min中动态更新一次
-record(wybq_state, {
    total_cbp_list = [], %% [{type, total_cbp}, ... ]
    min_100_cbp = 0, %% 当前第100名战力，5min更新
    lv = 0, %% 当前推荐等级
    update_time = 0 %% 更新时间
}).

-define(ETS_SYS_WYBQ, ets_sys_wybq).

-define(WYBQ_TOTAL_NUM, 10).