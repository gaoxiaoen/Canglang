%% 配置生成时间 2018-04-23 20:11:23
-module(data_hqg_daily_charge).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000}],gs_id=[],open_day=1,end_day=1,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        acc_charge_list=[{1 ,  10 ,  8300501,  8300500},{2 ,  99 ,  8300561 ,  8300560},{3 ,  880 ,  8300571,  8300570}],
        act_info=#act_info{}
    };

get(2) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000}],gs_id=[],open_day=2,end_day=2,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=2,
        acc_charge_list=[{1 ,  10 ,  8300502 ,  8300500},{2 ,  99 ,  8300562 ,  8300560},{3 ,  500 ,  8300572,  8300570}],
        act_info=#act_info{}
    };

get(3) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000}],gs_id=[],open_day=3,end_day=3,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=3,
        acc_charge_list=[{1 ,  10 ,  8300503 ,  8300500},{2 ,  99 ,  8300563 ,  8300560},{3 ,  500 ,  8300573,  8300570}],
        act_info=#act_info{}
    };

get(4) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000}],gs_id=[],open_day=4,end_day=4,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=4,
        acc_charge_list=[{1 ,  10 ,  8300504 ,  8300500},{2 ,  99 ,  8300564 ,  8300560},{3 ,  500 ,  8300574,  8300570}],
        act_info=#act_info{}
    };

get(5) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000}],gs_id=[],open_day=5,end_day=5,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=5,
        acc_charge_list=[{1 ,  10 ,  8300505 ,  8300500},{2 ,  99 ,  8300565 ,  8300560},{3 ,  500 ,  8300575,  8300570}],
        act_info=#act_info{}
    };

get(6) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500}],gs_id=[],open_day=6,end_day=6,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=6,
        acc_charge_list=[{1 ,  10 ,  8300506 ,  8300500},{2 ,  99 ,  8300566 ,  8300560},{3 ,  500 ,  8300576,  8300570}],
        act_info=#act_info{}
    };

get(7) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500}],gs_id=[],open_day=7,end_day=7,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=7,
        acc_charge_list=[{1 ,  10 ,  8300507 ,  8300500},{2 ,  99 ,  8300567 ,  8300560},{3 ,  500 ,  8300577,  8300570}],
        act_info=#act_info{}
    };

get(8) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500}],gs_id=[],open_day=15,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=8,
        acc_charge_list=[{1 ,  10 ,  8300508 ,  8300500},{2 ,  99 ,  8300568 ,  8300560},{3 ,  500 ,  8300578 ,  8300570}],
        act_info=#act_info{}
    };

get(9) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500}],gs_id=[],open_day=8,end_day=8,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=9,
        acc_charge_list=[{1 ,  10 ,  8300511 ,  8300500},{2 ,  99 ,  8301561 ,  8300560},{3 ,  500 ,  8301571,  8300570}],
        act_info=#act_info{}
    };

get(10) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500}],gs_id=[],open_day=9,end_day=9,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=10,
        acc_charge_list=[{1 ,  10 ,  8300512 ,  8300500},{2 ,  99 ,  8301562 ,  8300560},{3 ,  500 ,  8301572,  8300570}],
        act_info=#act_info{}
    };

get(11) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500}],gs_id=[],open_day=10,end_day=10,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=11,
        acc_charge_list=[{1 ,  10 ,  8300513 ,  8300500},{2 ,  99 ,  8301563 ,  8300560},{3 ,  500 ,  8301573,  8300570}],
        act_info=#act_info{}
    };

get(12) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500}],gs_id=[],open_day=11,end_day=11,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=12,
        acc_charge_list=[{1 ,  10 ,  8300514 ,  8300500},{2 ,  99 ,  8301564 ,  8300560},{3 ,  500 ,  8301574,  8300570}],
        act_info=#act_info{}
    };

get(13) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500}],gs_id=[],open_day=12,end_day=12,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=13,
        acc_charge_list=[{1 ,  10 ,  8300515 ,  8300500},{2 ,  99 ,  8301565 ,  8300560},{3 ,  500 ,  8301575,  8300570}],
        act_info=#act_info{}
    };

get(14) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500}],gs_id=[],open_day=13,end_day=13,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=14,
        acc_charge_list=[{1 ,  10 ,  8300516 ,  8300500},{2 ,  99 ,  8301566 ,  8300560},{3 ,  500 ,  8301576,  8300570}],
        act_info=#act_info{}
    };

get(15) ->
    #base_hqg_daily_charge{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500}],gs_id=[],open_day=14,end_day=14,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=15,
        acc_charge_list=[{1 ,  10 ,  8300517 ,  8300500},{2 ,  99 ,  8301567 ,  8300560},{3 ,  500 ,  8301577,  8300570}],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15].
