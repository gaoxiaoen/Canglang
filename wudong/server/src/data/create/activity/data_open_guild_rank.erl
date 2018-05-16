%% 配置生成时间 2018-04-23 20:11:23
-module(data_open_guild_rank).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_open_act_guild_rank{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500}],gs_id=[],open_day=1,end_day=4,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        list=[{1 , 1 , 8300421},{1 , 2 , 8300422},{2 , 1 , 8300423},{2 , 2 , 8300424},{3 , 1 , 8300425},{3 , 2 , 8300431}],
        act_info=#act_info{}
    };

get(2) ->
    #base_open_act_guild_rank{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000}],gs_id=[],open_day=5,end_day=7,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=2,
        list=[{1 , 1 , 8300421},{1 , 2 , 8300422},{2 , 1 , 8300423},{2 , 2 , 8300424},{3 , 1 , 8300425},{3 , 2 , 8300431}],
        act_info=#act_info{}
    };

get(3) ->
    #base_open_act_guild_rank{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000}],gs_id=[],open_day=8,end_day=11,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=3,
        list=[{1 , 1 , 8309421},{1 , 2 , 8309422},{2 , 1 , 8309423},{2 , 2 , 8309424},{3 , 1 , 8309425},{3 , 2 , 8309431}],
        act_info=#act_info{}
    };

get(4) ->
    #base_open_act_guild_rank{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500}],gs_id=[],open_day=12,end_day=14,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=4,
        list=[{1 , 1 , 8309421},{1 , 2 , 8309422},{2 , 1 , 8309423},{2 , 2 , 8309424},{3 , 1 , 8309425},{3 , 2 , 8309431}],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1,2,3,4].
