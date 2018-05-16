%% 配置生成时间 2018-05-14 17:02:07
-module(data_cs_charge_d).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(2) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=2,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1280, reward_list = [{11601,1},{6609019,1},{1015001,10},{8002404,3}],login_flag=all}],
        act_info=#act_info{}
    };

get(22) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=3,end_day=3,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=22,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{8002407,1},{3401000,10},{3403000,10},{8001204,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(3) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,13},{00,00,00}},end_time={{2017,11,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=3,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{11601,1},{6609019,1},{1015001,10},{8002404,3}],login_flag=all}],
        act_info=#act_info{}
    };

get(4) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,15},{00,00,00}},end_time={{2017,11,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=4,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6602014,2},{1015001,5},{8002404,3},{8001085,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(5) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,16},{00,00,00}},end_time={{2017,11,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=5,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{3107007,3},{1015001,5},{8002404,3},{8001085,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(6) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,17},{00,00,00}},end_time={{2017,11,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=6,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,5},{8001542,1},{8002404,3},{8001085,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(7) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,19},{00,00,00}},end_time={{2017,11,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=7,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,5},{8001532,1},{8002404,3},{8001085,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(8) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,20},{00,00,00}},end_time={{2017,11,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=8,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,5},{8001532,1},{8002404,3},{8001085,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(9) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,22},{00,00,00}},end_time={{2017,11,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=9,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,5},{4101017,1},{8002404,3},{8001085,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(10) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,23},{00,00,00}},end_time={{2017,11,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=10,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,5},{1045101,1},{8002405,1},{8001057,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(11) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,27},{00,00,00}},end_time={{2017,11,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=11,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{6608025,10},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(12) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,28},{00,00,00}},end_time={{2017,11,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=12,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{11601,2},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(13) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,29},{00,00,00}},end_time={{2017,11,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=13,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{2014001,10},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(14) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,30},{00,00,00}},end_time={{2017,11,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=14,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{5101407,1},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(15) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,01},{00,00,00}},end_time={{2017,12,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=15,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{6208001,1},{6608020,10},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(16) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,03},{00,00,00}},end_time={{2017,12,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=16,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{6308001,1},{6604072,10},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(17) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,04},{00,00,00}},end_time={{2017,12,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=17,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,5},{4101017,1},{8002404,3},{8001085,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(18) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,05},{00,00,00}},end_time={{2017,12,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=18,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,5},{3312003,1},{8002404,3},{8001085,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(1) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,05},{14,41,55}},end_time={{2017,12,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{3307006, 1},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=window},
#base_cs_charge_d_sub{num = 1, charge_gold = 6480, reward_list = [{3307006, 1},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=ios},
#base_cs_charge_d_sub{num = 1, charge_gold = 20000, reward_list = [{3307006, 1},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=android}],
        act_info=#act_info{}
    };

get(19) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,06},{00,00,00}},end_time={{2017,12,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=19,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{2014001,10},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(20) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,07},{00,00,00}},end_time={{2017,12,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=20,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{5101407,1},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(21) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,08},{00,00,00}},end_time={{2017,12,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=21,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{6610017,10},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(23) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,11},{00,00,00}},end_time={{2017,12,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=23,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{2014001,10},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(24) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,12},{00,00,00}},end_time={{2017,12,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=24,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{5101427,1},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(25) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{50001,60000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[2656,2655,2654,2653,2652,2651,2646,2645,2644,2643,2642,2640,2638,2636,2635,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3013,3011,3010,3009,3008,3007,3006,3553,3552,3550,3549,3547,3546,3545,3542,3539,3534,3526,3521,3513,3501,8545,8544,8543,8539,8538,8537,8536,8534,8533,8531,8530,8529,8527,8523,8521,8507,8505,8501,9002,9001,9512,9511,9510,9509,9508,9507,9506,9501],open_day=0,end_day=0,start_time={{2017,12,14},{00,00,00}},end_time={{2017,12,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=25,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{6608025,10},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(26) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{50001,60000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[2656,2655,2654,2653,2652,2651,2646,2645,2644,2643,2642,2640,2638,2636,2635,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3013,3011,3010,3009,3008,3007,3006,3553,3552,3550,3549,3547,3546,3545,3542,3539,3534,3526,3521,3513,3501,8545,8544,8543,8542,8540,8539,8538,8537,8536,8534,8533,8531,8530,8529,8527,8523,8521,8507,8505,8501,9002,9001,9512,9511,9510,9509,9508,9507,9506,9501],open_day=0,end_day=0,start_time={{2017,12,15},{00,00,00}},end_time={{2017,12,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=26,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{1015001,10},{5101437,1},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(27) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[2657,2656,2655,2654,2653,2652,2651,2648,2647,2646,2645,2643,2642,2640,2638,2636,2635,2633,2631,2626,2625,2619,2614,2613,2605,2603,2596,2589,2585,2578,2575,2570,2566,2544,2542,2540,2536,2519,2501,8546,8545,8544,8543,8541,8540,8539,8537,8534,8531,8530,8529,8527,8521,8507,8505,8501,9003,9002,9001,9514,9513,9512,9511,9510,9509,9508,9507,9506,9504,9503,9502,9501],open_day=0,end_day=0,start_time={{2017,12,17},{00,00,00}},end_time={{2017,12,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=27,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,10},{3112006,1},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(28) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{9001,9500}],gs_id=[2660,2659,2658,2657,2656,2655,2654,2653,2652,2651,2649,2648,2647,2646,2645,2643,2642,2640,2638,2636,2635,2633,2631,2626,2625,2619,2614,2613,2605,2603,2596,2589,2585,2578,2575,2570,2566,2544,2542,2540,2536,2519,2501,8546,8545,8544,8543,8541,8540,8539,8537,8534,8531,8530,8529,8527,8521,8507,8505,8501,9516,9515,9514,9513,9512,9511,9510,9509,9508,9507,9506,9504,9503,9502,9501],open_day=0,end_day=0,start_time={{2017,12,18},{00,00,00}},end_time={{2017,12,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=28,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,10},{6606022,10},{8002405,1},{8001057,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(29) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,20},{00,00,00}},end_time={{2017,12,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=29,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,10},{5101437,1},{8002405,3},{8001057,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(30) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,22},{00,00,00}},end_time={{2017,12,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=30,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,10},{6610017,10},{8002405,3},{8001057,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(31) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,24},{00,00,00}},end_time={{2017,12,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=31,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,10},{5101447,1},{8002405,3},{8001057,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(32) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,25},{00,00,00}},end_time={{2017,12,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=32,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,10},{5101407,1},{8002405,3},{8001057,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(33) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,27},{00,00,00}},end_time={{2017,12,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=33,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,10},{6610028,10},{8002405,3},{8001057,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(34) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,29},{00,00,00}},end_time={{2017,12,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=34,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,10},{6606022,10},{8002405,3},{8001057,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(35) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,31},{00,00,00}},end_time={{2017,12,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=35,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,10},{5101427,1},{8002405,3},{8001057,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(36) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,01},{00,00,00}},end_time={{2018,01,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=36,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,20},{6608019,10},{8002406,1},{8001085,30}],login_flag=all}],
        act_info=#act_info{}
    };

get(37) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,03},{00,00,00}},end_time={{2018,01,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=37,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,20},{5101428,1},{8002406,1},{8001057,30}],login_flag=all}],
        act_info=#act_info{}
    };

get(40) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,05},{00,00,00}},end_time={{2018,01,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=40,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,20},{6610021,10},{8002406,1},{8001085,30}],login_flag=all}],
        act_info=#act_info{}
    };

get(41) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,07},{00,00,00}},end_time={{2018,01,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=41,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,20},{3112006,1},{8002406,1},{8001057,30}],login_flag=all}],
        act_info=#act_info{}
    };

get(42) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,08},{00,00,00}},end_time={{2018,01,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=42,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{1015001,20},{3312009,1},{8002405,3},{8001057,30}],login_flag=all}],
        act_info=#act_info{}
    };

get(43) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,10},{00,00,00}},end_time={{2018,01,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=43,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606025,10},{8001057,30},{8002406,1},{8001161,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(44) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,12},{00,00,00}},end_time={{2018,01,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=44,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604092,10},{3202000,2},{8001202,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(45) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,14},{00,00,00}},end_time={{2018,01,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=45,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606019,10},{3502000,2},{8001205,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(46) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,15},{00,00,00}},end_time={{2018,01,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=46,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{3312010,1},{1015001,20},{8002405,3},{8001057,30}],login_flag=all}],
        act_info=#act_info{}
    };

get(47) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,17},{00,00,00}},end_time={{2018,01,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=47,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606022,10},{3202000,2},{8001202,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(48) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,19},{00,00,00}},end_time={{2018,01,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=48,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604094,10},{3202000,2},{8001202,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(49) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,21},{00,00,00}},end_time={{2018,01,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=49,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610029,10},{3202000,2},{8001202,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(50) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,22},{00,00,00}},end_time={{2018,01,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=50,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6633020,1},{3202000,2},{8001202,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(51) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,26},{00,00,00}},end_time={{2018,01,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=51,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6609030,1},{3902000,2},{8001209,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(52) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,28},{00,00,00}},end_time={{2018,01,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=52,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603101,1},{4002000,2},{8001210,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(53) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,29},{00,00,00}},end_time={{2018,01,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=53,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6605027,1},{4002000,2},{8001210,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(54) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,31},{00,00,00}},end_time={{2018,01,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=54,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603088,1},{6002000,2},{8001211,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(55) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,02},{00,00,00}},end_time={{2018,02,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=55,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6605028,1},{8001058,3},{8001212,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(56) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,04},{00,00,00}},end_time={{2018,02,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=56,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6609021,1},{8001058,3},{8001085,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(57) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,05},{00,00,00}},end_time={{2018,02,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=57,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6609015,1},{8001058,3},{8001085,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(58) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,07},{00,00,00}},end_time={{2018,02,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=58,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6609014,1},{8001058,3},{8001085,20},{10106,1888}],login_flag=all}],
        act_info=#act_info{}
    };

get(59) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,09},{00,00,00}},end_time={{2018,02,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=59,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603072,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(60) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,11},{00,00,00}},end_time={{2018,02,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=60,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6605019,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(61) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,12},{00,00,00}},end_time={{2018,02,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=61,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6609012,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(62) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,14},{00,00,00}},end_time={{2018,02,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=62,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6609026,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(63) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,16},{00,00,00}},end_time={{2018,02,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=63,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603092,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(64) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,18},{00,00,00}},end_time={{2018,02,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=64,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6609028,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(65) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,19},{00,00,00}},end_time={{2018,02,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=65,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603096,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(66) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,21},{00,00,00}},end_time={{2018,02,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=66,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603084,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(67) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,23},{00,00,00}},end_time={{2018,02,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=67,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603080,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(68) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,25},{00,00,00}},end_time={{2018,02,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=68,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603088,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(69) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,26},{00,00,00}},end_time={{2018,02,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=69,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603104,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(70) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,28},{00,00,00}},end_time={{2018,02,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=70,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603098,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(71) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,02},{00,00,00}},end_time={{2018,03,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=71,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603095,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(72) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,04},{00,00,00}},end_time={{2018,03,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=72,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604091,1},{8001057,30},{8001170,30},{8001002,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(73) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,05},{00,00,00}},end_time={{2018,03,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=73,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6605029,1},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(74) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,07},{00,00,00}},end_time={{2018,03,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=74,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603120,1},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(75) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,09},{00,00,00}},end_time={{2018,03,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=75,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610033,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(76) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,11},{00,00,00}},end_time={{2018,03,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=76,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610031,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(77) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,12},{00,00,00}},end_time={{2018,03,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=77,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606031,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(78) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,14},{00,00,00}},end_time={{2018,03,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=78,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610034,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(79) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,16},{00,00,00}},end_time={{2018,03,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=79,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604113,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(80) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,18},{00,00,00}},end_time={{2018,03,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=80,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606034,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(81) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,19},{00,00,00}},end_time={{2018,03,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=81,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604114,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(82) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,21},{00,00,00}},end_time={{2018,03,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=82,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604116,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(83) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,23},{00,00,00}},end_time={{2018,03,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=83,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604117,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(84) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,25},{00,00,00}},end_time={{2018,03,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=84,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604123,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(85) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,26},{00,00,00}},end_time={{2018,03,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=85,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610015,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(86) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,28},{00,00,00}},end_time={{2018,03,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=86,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604125,10},{8001057,30},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(87) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,30},{00,00,00}},end_time={{2018,03,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=87,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606003,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(88) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,01},{00,00,00}},end_time={{2018,04,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=88,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610021,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(89) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,02},{00,00,00}},end_time={{2018,04,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=89,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606029,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(90) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,04},{00,00,00}},end_time={{2018,04,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=90,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604119,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(91) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,06},{00,00,00}},end_time={{2018,04,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=91,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610033,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(92) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,08},{00,00,00}},end_time={{2018,04,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=92,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610031,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(93) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,09},{00,00,00}},end_time={{2018,04,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=93,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606031,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(94) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,11},{00,00,00}},end_time={{2018,04,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=94,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610034,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(95) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,13},{00,00,00}},end_time={{2018,04,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=95,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604113,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(96) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,15},{00,00,00}},end_time={{2018,04,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=96,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606034,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(97) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,16},{00,00,00}},end_time={{2018,04,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=97,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604114,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(98) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,18},{00,00,00}},end_time={{2018,04,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=98,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604116,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(99) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,20},{00,00,00}},end_time={{2018,04,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=99,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606003,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(100) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,22},{00,00,00}},end_time={{2018,04,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=100,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610030,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(102) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,25},{00,00,00}},end_time={{2018,04,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=102,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604125,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(103) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,27},{00,00,00}},end_time={{2018,04,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=103,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606003,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(104) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,29},{00,00,00}},end_time={{2018,04,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=104,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610021,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(106) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,02},{00,00,00}},end_time={{2018,05,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=106,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604090,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(107) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,04},{00,00,00}},end_time={{2018,05,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=107,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604094,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(108) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,06},{00,00,00}},end_time={{2018,05,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=108,
        list = [
#base_cs_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604100,10},{8001652,1},{8001170,30},{8001663,20}],login_flag=all}],
        act_info=#act_info{}
    };

get(200) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,09},{00,00,00}},end_time={{2018,05,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=200,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{40001,125},{40002,5},{40013,5},{40023,30},{40033,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(201) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,11},{00,00,00}},end_time={{2018,05,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=201,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{8002409,1},{8001002,150},{8001663,20},{8001170,70},{8001085,70}],login_flag=all}],
        act_info=#act_info{}
    };

get(202) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,13},{00,00,00}},end_time={{2018,05,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=202,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{6603135,1},{8001161,50},{8001163,100},{8002519,100},{7750001,30}],login_flag=all}],
        act_info=#act_info{}
    };

get(203) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,16},{00,00,00}},end_time={{2018,05,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=203,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{40001,125},{40002,5},{40012,5},{40022,30},{40032,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(204) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,18},{00,00,00}},end_time={{2018,05,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=204,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{8002409,1},{8002516,150},{1015001,30},{11117,500000},{1016005,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(205) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,20},{00,00,00}},end_time={{2018,05,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=205,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{6609040,1},{8001161,50},{8001163,100},{8002519,100},{7750001,30}],login_flag=all}],
        act_info=#act_info{}
    };

get(206) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,23},{00,00,00}},end_time={{2018,05,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=206,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{40001,125},{40002,5},{40014,5},{40024,30},{40034,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(207) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,25},{00,00,00}},end_time={{2018,05,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=207,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{8002409,1},{8001002,150},{8001663,20},{8001170,70},{8001085,70}],login_flag=all}],
        act_info=#act_info{}
    };

get(208) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,27},{00,00,00}},end_time={{2018,05,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=208,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{6603128,1},{8001161,50},{8001163,100},{8002519,100},{7750001,30}],login_flag=all}],
        act_info=#act_info{}
    };

get(209) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,30},{00,00,00}},end_time={{2018,05,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=209,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{40001,125},{40002,5},{40011,5},{40021,30},{40031,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(210) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,06,01},{00,00,00}},end_time={{2018,06,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=210,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{8002409,1},{8002516,150},{1015001,30},{11117,500000},{1016005,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(211) ->
    #base_cs_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,06,03},{00,00,00}},end_time={{2018,06,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=211,
        list = [
#base_cs_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{6603132,1},{8001161,50},{8001163,100},{8002519,100},{7750001,30}],login_flag=all}],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [2,22,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,1,19,20,21,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,102,103,104,106,107,108,200,201,202,203,204,205,206,207,208,209,210,211].
