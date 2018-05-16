%% 配置生成时间 2018-04-23 20:11:23
-module(data_hundred_return).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_hundred_return{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=1,end_day=7,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,
        cost=88,
        value = 8888,
        get_list=[{6603042,1},{8001061,1},{6605004,1},{3102000,2},{3101000,5},{10106,300}],
        act_info = #act_info{} };
get(_) -> [].

get_all() -> [1].
