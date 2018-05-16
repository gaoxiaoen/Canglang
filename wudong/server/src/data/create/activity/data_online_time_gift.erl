%% 配置生成时间 2018-05-14 16:57:35
-module(data_online_time_gift).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_online_time_gift{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=1,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,gift_list=[
#base_ot_gift{
    online_time = 300,
    goods_list = [{2003000,1,1},{10106,10,1},{1025001,1,1}]
    },
#base_ot_gift{
    online_time = 1200,
    goods_list = [{10106,10,1},{2003000,1,1},{8002401,1,1},{8002402,1,1}]
    },
#base_ot_gift{
    online_time = 3600,
    goods_list = [{3101000,1,1},{3201000,1,1},{3301000,1,1},{3401000,1,1},{3501000,1,1},{3601000,1,1},{3701000,1,1}]
    },
#base_ot_gift{
    online_time = 7200,
    goods_list = [{10106,25,1},{10106,50,1},{10106,75,1},{1025001,2,1}]
    }],act_info=#act_info{}};
get(_) -> [].

get_all() -> [1].
        