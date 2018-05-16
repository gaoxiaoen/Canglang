%% 配置生成时间 2018-05-14 17:02:19
-module(data_small_charge_d).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,29},{10,30,11}},end_time={{2017,11,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{3307006, 1},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=window},
#base_small_charge_d_sub{num = 1, charge_gold = 300, reward_list = [{3307006, 1},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=window},
#base_small_charge_d_sub{num = 1, charge_gold = 500, reward_list = [{3307006, 1},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=window},
#base_small_charge_d_sub{num = 1, charge_gold = 500, reward_list = [{3307006, 1},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=android},
#base_small_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{3307006, 3},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=android},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{3307006, 5},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=android},
#base_small_charge_d_sub{num = 1, charge_gold = 180, reward_list = [{3307006, 2},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=ios},
#base_small_charge_d_sub{num = 1, charge_gold = 600, reward_list = [{3307006, 3},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=ios},
#base_small_charge_d_sub{num = 1, charge_gold = 1280, reward_list = [{3307006, 4},{8001301, 1},{8001302, 1},{8002401, 1},{2003000, 1}],login_flag=ios}],
        act_info=#act_info{}
    };

get(2) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,09},{00,00,00}},end_time={{2017,12,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=2,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,8},{7321001,5},{8002516,15},{2003000,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{6604094,10},{1015001,10},{8002405,1},{8001057,20},{2003000,50}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{11601,3},{1015001,20},{8002405,3},{8001057,40},{2003000,120}],login_flag=all}],
        act_info=#act_info{}
    };

get(3) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,10},{00,00,00}},end_time={{2017,12,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=3,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{6605005,1},{8001663,8},{8002516,15},{2003000,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{6608024,10},{1015001,10},{8002405,1},{8001057,20},{2003000,50}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{4103029,1},{1015001,20},{8002405,3},{8001057,40},{2003000,120}],login_flag=all}],
        act_info=#act_info{}
    };

get(4) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{50001,60000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[2656,2655,2654,2653,2652,2651,2645,2644,2643,2642,2640,2638,2636,2635,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3013,3011,3010,3009,3008,3007,3006,3553,3552,3550,3549,3547,3546,3545,3542,3539,3534,3526,3521,3513,3501,8545,8544,8543,8542,8539,8538,8537,8536,8534,8533,8531,8530,8529,8527,8523,8521,8507,8505,8501,9001,9512,9511,9510,9509,9508,9507,9506,9501],open_day=0,end_day=0,start_time={{2017,12,13},{00,00,00}},end_time={{2017,12,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=4,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,8},{7321001,5},{8002516,15},{2003000,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 980, reward_list = [{6604094,10},{1015001,10},{8002405,1},{8001057,20},{2003000,50}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{11601,3},{1015001,20},{8002405,3},{8001057,40},{2003000,120}],login_flag=all}],
        act_info=#act_info{}
    };

get(5) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30010,30009,30007,30006,30005,30004,30003,30002,30001,8003,8001,1001,1505,2002,2001,2657,2656,2655,2654,2653,2652,2651,2647,2646,2645,2643,2642,2640,2638,2636,2635,2633,2631,2626,2625,2619,2614,2613,2605,2603,2596,2589,2585,2578,2575,2570,2566,2544,2542,2540,2536,2519,2501,3013,3011,3010,3553,3552,3550,3549,3547,3546,3545,3542,3539,3534,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8546,8545,8544,8543,8540,8539,8537,8534,8531,8530,8529,8527,8521,8507,8505,8501,9003,9002,9001,9514,9513,9512,9511,9510,9509,9508,9507,9506,9502,9501],open_day=0,end_day=0,start_time={{2017,12,16},{00,00,00}},end_time={{2017,12,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=5,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{6603071,1},{8001663,8},{8002516,15},{2003000,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608019,10},{1015001,10},{8002405,2},{8001057,25},{2003000,60}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105031,1},{1015001,20},{8002406,1},{8001057,45},{2003000,150}],login_flag=all}],
        act_info=#act_info{}
    };

get(6) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[9516,9515,9514,9513,9512,9511,9510,9509,9508,9507,9506,9504,9503,9502,9501],open_day=0,end_day=0,start_time={{2017,12,19},{00,00,00}},end_time={{2017,12,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=6,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,8},{7321001,5},{8002516,15},{2003000,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610026,10},{1015001,10},{8002405,1},{8001057,20},{2003000,50}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{11601,3},{1015001,20},{8002405,3},{8001057,40},{2003000,120}],login_flag=all}],
        act_info=#act_info{}
    };

get(7) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,21},{00,00,00}},end_time={{2017,12,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=7,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{6605001,1},{8001663,8},{8002516,15},{2003000,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608007,10},{1015001,10},{8002405,2},{8001057,25},{2003000,60}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105032,1},{1015001,20},{8002406,1},{8001057,45},{2003000,150}],login_flag=all}],
        act_info=#act_info{}
    };

get(8) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,26},{00,00,00}},end_time={{2017,12,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=8,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{6604085,10},{8001663,8},{8002516,15},{2003000,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6609027,10},{1015001,10},{8002405,2},{8001057,25},{2003000,60}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105032,1},{1015001,20},{8002406,1},{8001057,45},{2003000,150}],login_flag=all}],
        act_info=#act_info{}
    };

get(9) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,28},{00,00,00}},end_time={{2017,12,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=9,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{6604071,10},{8001663,8},{8002516,15},{2003000,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608019,10},{1015001,10},{8002405,2},{8001057,25},{2003000,60}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105031,1},{1015001,20},{8002406,1},{8001057,45},{2003000,150}],login_flag=all}],
        act_info=#act_info{}
    };

get(10) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,30},{00,00,00}},end_time={{2017,12,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=10,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{6605005,1},{8001663,8},{8002516,15},{2003000,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608024,10},{1015001,10},{8002405,2},{8001057,25},{2003000,60}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105029,1},{1015001,20},{8002406,1},{8001057,45},{2003000,150}],login_flag=all}],
        act_info=#act_info{}
    };

get(11) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,02},{00,00,00}},end_time={{2018,01,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=11,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{7321001,8},{8002516,20},{2003000,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610026,10},{1015001,20},{8002406,1},{8001057,30},{2003000,50}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{11601,3},{8001054,50},{8002407,1},{8001057,50},{2003000,150}],login_flag=all}],
        act_info=#act_info{}
    };

get(20) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,04},{00,00,00}},end_time={{2018,01,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=20,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{6606001,10},{8002516,20},{2003000,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608007,10},{1015001,20},{8002406,1},{8001057,30},{2003000,50}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105032,1},{8001054,50},{8002407,1},{8001057,50},{2003000,150}],login_flag=all}],
        act_info=#act_info{}
    };

get(21) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,06},{00,00,00}},end_time={{2018,01,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=21,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{6610009,10},{8002516,20},{2003000,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{3307004,10},{1015001,20},{8002406,1},{8001057,30},{2003000,50}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{3207003,10},{8001054,50},{8002407,1},{8001057,50},{2003000,150}],login_flag=all}],
        act_info=#act_info{}
    };

get(22) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,09},{00,00,00}},end_time={{2018,01,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=22,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{6606023,10},{8001663,10},{8002516,20},{2003000,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608020,10},{8001161,10},{8002406,2},{8001054,30},{2003000,50}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{6633022,1},{8001054,50},{8002407,1},{8001057,50},{1015001,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(23) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,11},{00,00,00}},end_time={{2018,01,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=23,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{8002516,20},{2003000,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{2014001,10},{6002002,10},{5101426,2},{2603003,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{6633012,1},{5101417,1},{1015001,10},{2603003,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(24) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,13},{00,00,00}},end_time={{2018,01,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=24,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{8002516,20},{7405001,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{2014001,10},{6002004,10},{5101416,2},{2606003,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{3312007,1},{5101427,1},{1015001,10},{2606003,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(25) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,16},{00,00,00}},end_time={{2018,01,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=25,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{8002516,20},{7405001,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{2014001,10},{6002004,10},{5101416,2},{2606003,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{6633019,1},{5101427,1},{1015001,10},{2606003,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(26) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,18},{00,00,00}},end_time={{2018,01,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=26,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{8002516,20},{7405001,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{2014001,10},{6002004,10},{5101416,2},{2606003,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{6633013,1},{5101427,1},{1015001,10},{2606003,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(27) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,20},{00,00,00}},end_time={{2018,01,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=27,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{6610022,10},{8001663,10},{8002516,20},{2003000,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608019,10},{1015001,20},{8002406,1},{8001057,30},{2003000,50}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{6633014,1},{8001054,50},{8002407,1},{8001057,50},{2003000,150}],login_flag=all}],
        act_info=#act_info{}
    };

get(28) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,24},{00,00,00}},end_time={{2018,01,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=28,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{8002516,20},{7405001,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{2014001,10},{6002004,10},{5101416,2},{2602003,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{3112007,1},{5101427,1},{1015001,10},{2603003,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(29) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,25},{00,00,00}},end_time={{2018,01,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=29,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{8002516,20},{7405001,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{2014001,10},{6002004,10},{5101416,2},{2602003,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7307011,1},{5101427,1},{1015001,10},{2603003,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(30) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,27},{00,00,00}},end_time={{2018,01,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=30,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{6609011,1},{8002516,20},{7405001,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608020,10},{8002517,10},{5101416,2},{2602003,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7307013,1},{5101427,1},{1015001,10},{2603003,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(31) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,30},{00,00,00}},end_time={{2018,01,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=31,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{6610003,10},{8002516,20},{2003000,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610019,10},{8002517,10},{8002406,2},{2607003,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7307012,1},{8002407,1},{1015001,10},{2601003,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(32) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,01},{00,00,00}},end_time={{2018,02,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=32,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{8002516,20},{7405001,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606025,10},{6002004,10},{5101416,2},{2602003,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{3307011,10},{5101427,1},{1015001,10},{2603003,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(33) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,03},{00,00,00}},end_time={{2018,02,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=33,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{8002516,20},{7405001,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608007,10},{6002004,10},{5101416,2},{2602003,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4107029,1},{5101427,1},{1015001,10},{2603003,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(34) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,06},{00,00,00}},end_time={{2018,02,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=34,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001663,10},{8002516,20},{7405001,30}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610018,10},{8002517,10},{8002406,2},{8001054,20}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105005,1},{8002407,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(35) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,08},{00,00,00}},end_time={{2018,02,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=35,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608025,10},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105013,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(36) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,10},{00,00,00}},end_time={{2018,02,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=36,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606028,10},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{3307004,10},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(37) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,13},{00,00,00}},end_time={{2018,02,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=37,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606021,10},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{6608024,10},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(38) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,15},{00,00,00}},end_time={{2018,02,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=38,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6608006,10},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105040,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(39) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,17},{00,00,00}},end_time={{2018,02,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=39,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604084,10},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{3307003,10},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(40) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,20},{00,00,00}},end_time={{2018,02,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=40,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604089,10},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105029,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(41) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,22},{00,00,00}},end_time={{2018,02,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=41,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604075,10},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105034,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(42) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,24},{00,00,00}},end_time={{2018,02,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=42,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604071,10},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105014,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(43) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,27},{00,00,00}},end_time={{2018,02,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=43,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604083,10},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105018,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(44) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,01},{00,00,00}},end_time={{2018,03,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=44,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{2014001,3},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7307011,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(45) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,03},{00,00,00}},end_time={{2018,03,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=45,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610011,10},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7307013,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(46) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{10001,10500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{30001,50000},{3001,3500},{3501,4000},{4001,4500},{50001,60000},{5001,5500},{6001,6500},{8001,8500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,06},{00,00,00}},end_time={{2018,03,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=46,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603109,1},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105014,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(47) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,08},{00,00,00}},end_time={{2018,03,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=47,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6605030,1},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105015,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(48) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,10},{00,00,00}},end_time={{2018,03,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=48,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603112,1},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7308011,10},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(49) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,13},{00,00,00}},end_time={{2018,03,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=49,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6603113,1},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105008,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(50) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,15},{00,00,00}},end_time={{2018,03,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=50,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6605032,1},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7308012,10},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(51) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,17},{00,00,00}},end_time={{2018,03,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=51,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6609035,1},{8002517,10},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{4105028,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(52) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,20},{00,00,00}},end_time={{2018,03,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=52,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610036,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{6608020,10},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(53) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,22},{00,00,00}},end_time={{2018,03,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=53,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610037,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7307013,1},{8001652,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(54) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,24},{00,00,00}},end_time={{2018,03,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=54,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604122,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7401020,1},{7415006,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(55) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,27},{00,00,00}},end_time={{2018,03,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=55,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604124,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7404020,1},{7415009,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(56) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,29},{00,00,00}},end_time={{2018,03,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=56,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610020,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7402020,1},{7415007,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(57) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,31},{00,00,00}},end_time={{2018,03,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=57,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606010,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7403020,1},{7415008,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(58) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,03},{00,00,00}},end_time={{2018,04,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=58,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604108,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7401020,1},{7415006,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(59) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,05},{00,00,00}},end_time={{2018,04,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=59,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606030,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7404020,1},{7415009,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(60) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,07},{00,00,00}},end_time={{2018,04,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=60,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604111,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7402020,1},{7415007,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(61) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,10},{00,00,00}},end_time={{2018,04,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=61,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604112,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7403020,1},{7415008,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(63) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,14},{00,00,00}},end_time={{2018,04,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=63,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610035,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7404020,1},{7415009,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(64) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,17},{00,00,00}},end_time={{2018,04,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=64,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610036,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7402020,1},{7415007,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(66) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,21},{00,00,00}},end_time={{2018,04,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=66,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604122,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7401020,1},{7415006,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(67) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,24},{00,00,00}},end_time={{2018,04,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=67,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6606029,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7404020,1},{7415009,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(69) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,28},{00,00,00}},end_time={{2018,04,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=69,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610017,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7403020,1},{7415008,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(70) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,01},{00,00,00}},end_time={{2018,05,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=70,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604086,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7401020,1},{7415006,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(72) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,05},{00,00,00}},end_time={{2018,05,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=72,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6604097,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7402020,1},{7415007,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(73) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,07},{00,00,00}},end_time={{2018,05,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=73,
        list = [
#base_small_charge_d_sub{num = 1, charge_gold = 60, reward_list = [{8001662,20},{8002516,20},{7405001,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 1980, reward_list = [{6610019,10},{8001056,5},{8002406,2},{8001054,20},{1015001,10}],login_flag=all},
#base_small_charge_d_sub{num = 1, charge_gold = 3280, reward_list = [{7403020,1},{7415008,1},{1015001,10},{8001054,30},{8001057,50}],login_flag=all}],
        act_info=#act_info{}
    };

get(200) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,08},{00,00,00}},end_time={{2018,05,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=200,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{10106,2500},{1016003,20},{1016004,20},{1016005,20},{2003000,500}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{10106,4000},{8001054,150},{2014001,30},{11117,600000}],login_flag=all}],
        act_info=#act_info{}
    };

get(201) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,10},{00,00,00}},end_time={{2018,05,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=201,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{10106,2500},{1016003,20},{1016004,20},{1016005,20},{2003000,500}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{10106,4000},{7501100,20},{7500101,1},{7500002,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(202) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,12},{00,00,00}},end_time={{2018,05,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=202,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{1017002,10},{1016003,10},{1016004,10},{2003000,500},{7501100,10}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 6480, reward_list = [{7501103,10},{7500101,1},{7500003,5},{10106,2000},{1016005,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(203) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,15},{00,00,00}},end_time={{2018,05,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=203,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{10106,2500},{1016003,20},{1016004,20},{1016005,20},{2003000,500}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{10106,4000},{8001054,150},{2014001,30},{11117,600000}],login_flag=all}],
        act_info=#act_info{}
    };

get(204) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,17},{00,00,00}},end_time={{2018,05,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=204,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{10106,2500},{1016003,20},{1016004,20},{1016005,20},{2003000,500}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{10106,4000},{7501100,20},{7500101,1},{7500002,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(205) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,19},{00,00,00}},end_time={{2018,05,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=205,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{1017002,10},{1016003,10},{1016004,10},{2003000,500},{7501100,10}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 6480, reward_list = [{7501103,10},{7500101,1},{7500003,5},{10106,2000},{1016005,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(206) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,22},{00,00,00}},end_time={{2018,05,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=206,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{10106,2500},{1016003,20},{1016004,20},{1016005,20},{2003000,500}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{10106,4000},{8001054,150},{2014001,30},{11117,600000}],login_flag=all}],
        act_info=#act_info{}
    };

get(207) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,24},{00,00,00}},end_time={{2018,05,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=207,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{10106,2500},{1016003,20},{1016004,20},{1016005,20},{2003000,500}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{10106,4000},{7501100,20},{7500101,1},{7500002,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(208) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,26},{00,00,00}},end_time={{2018,05,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=208,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{1017002,10},{1016003,10},{1016004,10},{2003000,500},{7501100,10}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 6480, reward_list = [{7501103,10},{7500101,1},{7500003,5},{10106,2000},{1016005,5}],login_flag=all}],
        act_info=#act_info{}
    };

get(209) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,29},{00,00,00}},end_time={{2018,05,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=209,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{10106,2500},{1016003,20},{1016004,20},{1016005,20},{2003000,500}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{10106,4000},{8001054,150},{2014001,30},{11117,600000}],login_flag=all}],
        act_info=#act_info{}
    };

get(210) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,31},{00,00,00}},end_time={{2018,05,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=210,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{10106,2500},{1016003,20},{1016004,20},{1016005,20},{2003000,500}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 3280, reward_list = [{10106,4000},{7501100,20},{7500101,1},{7500002,10}],login_flag=all}],
        act_info=#act_info{}
    };

get(211) ->
    #base_small_charge_d{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,06,02},{00,00,00}},end_time={{2018,06,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=211,
        list = [
#base_small_charge_d_sub{num = 2, charge_gold = 60, reward_list = [{10106,100},{2003000,30},{8001002,30},{10101,100000}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 1980, reward_list = [{1017002,10},{1016003,10},{1016004,10},{2003000,500},{7501100,10}],login_flag=all},
#base_small_charge_d_sub{num = 2, charge_gold = 6480, reward_list = [{7501103,10},{7500101,1},{7500003,5},{10106,2000},{1016005,5}],login_flag=all}],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1,2,3,4,5,6,7,8,9,10,11,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,63,64,66,67,69,70,72,73,200,201,202,203,204,205,206,207,208,209,210,211].
