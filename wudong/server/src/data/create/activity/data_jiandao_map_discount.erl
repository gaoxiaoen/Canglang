%% 配置生成时间 2018-04-23 20:11:24
-module(data_jiandao_map_discount).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_jiandao_map_discount{
        open_info=#open_info{gp_id = [],gs_id=[30999,30100,30098,30097,30050,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30010,30009,30007,30006,30005,30004,30003,30002,30001,8003,1001,1505,2002,2723,2722,2721,2720,2719,2717,2716,2715,2711,2705,2696,2692,2651,2613,3021,3576,3575,3574,3573,5025,6012,4006,8552,9004,9003,9547,10003],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        discount = 80,
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1].
