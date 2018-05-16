%% 配置生成时间 2018-04-23 20:11:23
-module(data_merge_exchange).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=1,merge_et_day=1,merge_times_list=[0,1],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,1},{2005000,1}] ,exchange_get= [{10101,10000}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3101000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3301000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3401000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(2) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=2,merge_et_day=2,merge_times_list=[0,1],ignore_gs=[],priority=0,after_open_day=0},
        act_id=2,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,1},{2005000,1}] ,exchange_get= [{10101,10000}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3101000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3301000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3401000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(3) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=3,merge_et_day=3,merge_times_list=[0,1],ignore_gs=[],priority=0,after_open_day=0},
        act_id=3,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,1},{2005000,1}] ,exchange_get= [{10101,10000}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3101000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3301000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3401000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(4) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=4,merge_et_day=4,merge_times_list=[0,1],ignore_gs=[],priority=0,after_open_day=0},
        act_id=4,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,1},{2005000,1}] ,exchange_get= [{10101,10000}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3101000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3301000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3401000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(5) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=5,merge_et_day=5,merge_times_list=[0,1],ignore_gs=[],priority=0,after_open_day=0},
        act_id=5,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,1},{2005000,1}] ,exchange_get= [{10101,10000}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3101000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3301000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3401000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(6) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=6,merge_et_day=6,merge_times_list=[0,1],ignore_gs=[],priority=0,after_open_day=0},
        act_id=6,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,1},{2005000,1}] ,exchange_get= [{10101,10000}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3101000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3301000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3401000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(7) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=7,merge_et_day=7,merge_times_list=[0,1],ignore_gs=[],priority=0,after_open_day=0},
        act_id=7,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,1},{2005000,1}] ,exchange_get= [{10101,10000}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3101000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3301000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,10},{10199,20}] ,exchange_get= [{3401000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(8) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=1,merge_et_day=1,merge_times_list=[2,3,4,5,6,7,8,9,10],ignore_gs=[],priority=0,after_open_day=0},
        act_id=8,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3701000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3801000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3901000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{4001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=6 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=7 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6301000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(9) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=2,merge_et_day=2,merge_times_list=[2,3,4,5,6,7,8,9,10],ignore_gs=[],priority=0,after_open_day=0},
        act_id=9,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3701000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3801000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3901000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{4001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=6 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=7 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6301000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(10) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=3,merge_et_day=3,merge_times_list=[2,3,4,5,6,7,8,9,10],ignore_gs=[],priority=0,after_open_day=0},
        act_id=10,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3701000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3801000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3901000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{4001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=6 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=7 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6301000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(11) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=4,merge_et_day=4,merge_times_list=[2,3,4,5,6,7,8,9,10],ignore_gs=[],priority=0,after_open_day=0},
        act_id=11,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3701000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3801000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3901000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{4001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=6 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=7 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6301000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(12) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=5,merge_et_day=5,merge_times_list=[2,3,4,5,6,7,8,9,10],ignore_gs=[],priority=0,after_open_day=0},
        act_id=12,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3701000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3801000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3901000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{4001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=6 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=7 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6301000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(13) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=6,merge_et_day=6,merge_times_list=[2,3,4,5,6,7,8,9,10],ignore_gs=[],priority=0,after_open_day=0},
        act_id=13,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3701000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3801000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3901000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{4001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=6 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=7 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6301000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };

get(14) ->
    #base_merge_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=7,merge_et_day=7,merge_times_list=[2,3,4,5,6,7,8,9,10],ignore_gs=[],priority=0,after_open_day=0},
        act_id=14,
        list=[
            #base_merge_exchange_sub{id=1 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3701000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=2 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3801000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=3 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{3901000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=4 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{4001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=5 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6001000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=6 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6201000,1}] ,exchange_num= 10},
            #base_merge_exchange_sub{id=7 ,exchange_cost= [{2003000,5},{10199,20}] ,exchange_get= [{6301000,1}] ,exchange_num= 10}
        ],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1,2,3,4,5,6,7,8,9,10,11,12,13,14].
