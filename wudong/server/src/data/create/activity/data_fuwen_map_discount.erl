%% 配置生成时间 2018-04-23 23:21:01
-module(data_fuwen_map_discount).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_fuwen_map_discount{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        discount = 80,
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1].
