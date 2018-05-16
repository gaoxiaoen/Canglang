%% 配置生成时间 2018-04-23 20:11:24
-module(data_act_other_charge).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_act_other_charge{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        charge_list=[{1,120,  [{10199,120}]},{2,1000,  [{10199,1000}]},{3,3000,  [{8002405,1},{8001002,100}]},{4,6000,  [{8001002,100},{10101,1000000}]},{5,12000,  [{6602007,10}]}],
        act_info=#act_info{}
    };

get(2) ->
    #base_act_other_charge{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=2,
        charge_list=[{1,120,  [{10199,120}]},{2,1000,  [{10199,1000}]},{3,3000,  [{8002405,1},{8001002,100}]},{4,6000,  [{8001002,100},{10101,1000000}]},{5,12000,  [{6602007,10}]}],
        act_info=#act_info{}
    };

get(3) ->
    #base_act_other_charge{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=3,
        charge_list=[{1,120,  [{10199,120}]},{2,1000,  [{10199,1000}]},{3,3000,  [{8002405,1},{8001002,100}]},{4,6000,  [{8001002,100},{10101,1000000}]},{5,12000,  [{6602007,10}]}],
        act_info=#act_info{}
    };

get(4) ->
    #base_act_other_charge{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=4,
        charge_list=[{1,120,  [{10199,120}]},{2,1000,  [{10199,1000}]},{3,3000,  [{8002405,1},{8001002,100}]},{4,6000,  [{8001002,100},{10101,1000000}]},{5,12000,  [{6602007,10}]}],
        act_info=#act_info{}
    };

get(5) ->
    #base_act_other_charge{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=5,
        charge_list=[{1,120,  [{10199,120}]},{2,1000,  [{10199,1000}]},{3,3000,  [{8002405,1},{8001002,100}]},{4,6000,  [{8001002,100},{10101,1000000}]},{5,12000,  [{6602007,10}]}],
        act_info=#act_info{}
    };

get(6) ->
    #base_act_other_charge{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=6,
        charge_list=[{1,120,  [{10199,120}]},{2,1000,  [{10199,1000}]},{3,3000,  [{8002405,1},{8001002,100}]},{4,6000,  [{8001002,100},{10101,1000000}]},{5,12000,  [{6602007,10}]}],
        act_info=#act_info{}
    };

get(7) ->
    #base_act_other_charge{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=7,
        charge_list=[{1,120,  [{10199,120}]},{2,1000,  [{10199,1000}]},{3,3000,  [{8002405,1},{8001002,100}]},{4,6000,  [{8001002,100},{10101,1000000}]},{5,12000,  [{6602007,10}]}],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1,2,3,4,5,6,7].
