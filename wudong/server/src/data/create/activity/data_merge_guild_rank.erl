%% 配置生成时间 2018-04-23 20:11:23
-module(data_merge_guild_rank).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_merge_act_guild_rank{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=1,merge_et_day=4,merge_times_list=[0,1],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        list=[{1 , 1 , 8300421},{1 , 2 , 8300422},{2 , 1 , 8300423},{2 , 2 , 8300424},{3 , 1 , 8300425},{3 , 2 , 8300431}],
        act_info=#act_info{}
    };

get(2) ->
    #base_merge_act_guild_rank{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=5,merge_et_day=7,merge_times_list=[0,1],ignore_gs=[],priority=0,after_open_day=0},
        act_id=2,
        list=[{1 , 1 , 8300421},{1 , 2 , 8300422},{2 , 1 , 8300423},{2 , 2 , 8300424},{3 , 1 , 8300425},{3 , 2 , 8300431}],
        act_info=#act_info{}
    };

get(3) ->
    #base_merge_act_guild_rank{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=1,merge_et_day=4,merge_times_list=[2,3,4,5,6,7,8,9,10],ignore_gs=[],priority=0,after_open_day=0},
        act_id=3,
        list=[{1 , 1 , 8501143},{1 , 2 , 8501144},{2 , 1 , 8501145},{2 , 2 , 8501146},{3 , 1 , 8501147},{3 , 2 , 8501148}],
        act_info=#act_info{}
    };

get(4) ->
    #base_merge_act_guild_rank{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=5,merge_et_day=7,merge_times_list=[2,3,4,5,6,7,8,9,10],ignore_gs=[],priority=0,after_open_day=0},
        act_id=4,
        list=[{1 , 1 , 8501143},{1 , 2 , 8501144},{2 , 1 , 8501145},{2 , 2 , 8501146},{3 , 1 , 8501147},{3 , 2 , 8501148}],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1,2,3,4].
