%% 配置生成时间 2018-04-23 20:11:23
-module(data_marry_rank).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_marry_rank{open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=1,merge_et_day=7,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,reward_list = [{6603053,1},{7206001,99},{7207001,66},{1025001,9},{10106,20},{2003000,10}],act_info=#act_info{} };
get(2) -> #base_marry_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000}],gs_id=[],open_day=1,end_day=15,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=2,reward_list = [{6603053,1},{7206001,99},{7207001,66},{1025001,9},{10106,20},{2003000,10}],act_info=#act_info{} };
get(3) -> #base_marry_rank{open_info=#open_info{gp_id = [{50001,60000}],gs_id=[],open_day=1,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=3,reward_list = [{6603053,1},{7206001,99},{7207001,66},{1025001,9},{10106,20},{2003000,10}],act_info=#act_info{} };
get(_) -> [].

get_all() -> [1,2,3].
