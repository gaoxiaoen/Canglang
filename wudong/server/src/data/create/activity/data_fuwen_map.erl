%% 配置生成时间 2018-05-14 17:03:14
-module(data_fuwen_map).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_fuwen_map{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=3,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        one_cost = 100,
        ten_cost = 800,
        chip_min = 13,
        chip_max = 16,
        cd_time = 3600,
        list = [{1,100,10,1000,[{5101321,1,1,1},{5101301,1,10,0},{5101201,1,100,0},{11120,10,400,0},{5101202,1,100,0},{11117,1000,400,0},{11120,5,400,0},{11117,5000,400,0},{5101222,1,5,1},{5101303,1,10,0},{5101203,1,100,0},{11120,15,400,0},{5101204,1,100,0},{11117,100,400,0},{11120,30,400,0},{11117,500,400,0}]}],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1].
