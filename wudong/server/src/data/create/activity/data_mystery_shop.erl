%% 配置生成时间 2018-05-14 17:03:08
-module(data_mystery_shop).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

%%%%%神秘商城%%%%%

get(6) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=12,end_day=13,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id = 6,
        act_info=#act_info{},
        act_type = 2,
        show_list = [{3107001,1},{3107003,1},{6602005,1},{6602008,1},{6602006,1},{3307004,1},{4103028,1},{8002406,1},{7302001,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(7) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,11},{00,00,00}},end_time={{2017,10,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=15},
        act_id = 7,
        act_info=#act_info{},
        act_type = 1,
        show_list = [{3107002,1},{6602013,1},{6602005,1},{6602007,1},{6602006,1},{4104034,1},{4103015,1},{8002406,1},{7302001,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(8) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,18},{00,00,00}},end_time={{2017,10,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=15},
        act_id = 8,
        act_info=#act_info{},
        act_type = 1,
        show_list = [{3107002,1},{6602013,1},{6602005,1},{6602007,1},{6602006,1},{4104034,1},{4103015,1},{8002406,1},{7302001,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(9) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,28},{00,00,00}},end_time={{2017,10,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id = 9,
        act_info=#act_info{},
        act_type = 1,
        show_list = [{3107003,1},{6602013,1},{6602005,1},{6602007,1},{6602008,1},{4104038,1},{4103028,1},{8002406,1},{7302001,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(10) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,04},{00,00,00}},end_time={{2017,11,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id = 10,
        act_info=#act_info{},
        act_type = 1,
        show_list = [{3107003,1},{6602013,1},{6602005,1},{6602007,1},{6602008,1},{4104038,1},{4103028,1},{8002406,1},{7302001,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(11) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,11},{00,00,00}},end_time={{2017,11,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id = 11,
        act_info=#act_info{},
        act_type = 1,
        show_list = [{11601,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{2014001,1},{8002406,1},{7302001,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(12) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,17},{00,00,00}},end_time={{2017,11,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id = 12,
        act_info=#act_info{},
        act_type = 3,
        show_list = [{8001542,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(13) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,01},{00,00,00}},end_time={{2017,12,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id = 13,
        act_info=#act_info{},
        act_type = 4,
        show_list = [{3207002,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(14) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,08},{00,00,00}},end_time={{2017,12,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id = 14,
        act_info=#act_info{},
        act_type = 5,
        show_list = [{7308012,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(15) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{50001,60000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[2656,2655,2654,2653,2652,2651,2646,2645,2644,2643,2642,2640,2638,2636,2635,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3013,3011,3010,3009,3008,3007,3006,3553,3552,3550,3549,3547,3546,3545,3542,3539,3534,3526,3521,3513,3501,8545,8544,8543,8542,8540,8539,8538,8537,8536,8534,8533,8531,8530,8529,8527,8523,8521,8507,8505,8501,9002,9001,9512,9511,9510,9509,9508,9507,9506,9501],open_day=0,end_day=0,start_time={{2017,12,15},{00,00,00}},end_time={{2017,12,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id = 15,
        act_info=#act_info{},
        act_type = 6,
        show_list = [{6602012,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(16) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,22},{00,00,00}},end_time={{2017,12,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 16,
        act_info=#act_info{},
        act_type = 7,
        show_list = [{7308013,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(17) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,29},{00,00,00}},end_time={{2017,12,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 17,
        act_info=#act_info{},
        act_type = 8,
        show_list = [{7308011,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(32) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,05},{00,00,00}},end_time={{2018,01,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 32,
        act_info=#act_info{},
        act_type = 9,
        show_list = [{7308013,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 50,
        refresh_cd_time = 3600
        };

get(33) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,11},{00,00,00}},end_time={{2018,01,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 33,
        act_info=#act_info{},
        act_type = 10,
        show_list = [{8001653,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(34) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,18},{00,00,00}},end_time={{2018,01,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 34,
        act_info=#act_info{},
        act_type = 11,
        show_list = [{8001653,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(35) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,23},{00,00,00}},end_time={{2018,01,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 35,
        act_info=#act_info{},
        act_type = 12,
        show_list = [{8001653,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{7303015,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(36) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,25},{00,00,00}},end_time={{2018,01,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 36,
        act_info=#act_info{},
        act_type = 13,
        show_list = [{3107003,1},{11601,1},{6602005,1},{6602007,1},{6602008,1},{4104038,1},{4103028,1},{8002406,1},{7303016,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(37) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,01},{00,00,00}},end_time={{2018,02,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 37,
        act_info=#act_info{},
        act_type = 14,
        show_list = [{8001653,1},{11601,1},{2014001,1},{5101407,1},{5101417,1},{5101427,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(38) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,10},{00,00,00}},end_time={{2018,02,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 38,
        act_info=#act_info{},
        act_type = 15,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(39) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,13},{00,00,00}},end_time={{2018,02,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 39,
        act_info=#act_info{},
        act_type = 16,
        show_list = [{4105020,1},{6602007,1},{3107002,1},{3307003,1},{6606012,1},{6604085,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(40) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,17},{00,00,00}},end_time={{2018,02,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 40,
        act_info=#act_info{},
        act_type = 17,
        show_list = [{4105040,1},{6602014,1},{3107005,1},{3307005,1},{6606003,1},{6604087,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(41) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,21},{00,00,00}},end_time={{2018,02,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 41,
        act_info=#act_info{},
        act_type = 15,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(42) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,25},{00,00,00}},end_time={{2018,02,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 42,
        act_info=#act_info{},
        act_type = 16,
        show_list = [{4105020,1},{6602007,1},{3107002,1},{3307003,1},{6606012,1},{6604085,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(43) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,01},{00,00,00}},end_time={{2018,03,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 43,
        act_info=#act_info{},
        act_type = 17,
        show_list = [{4105040,1},{6602014,1},{3107005,1},{3307005,1},{6606003,1},{6604087,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(44) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,08},{00,00,00}},end_time={{2018,03,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 44,
        act_info=#act_info{},
        act_type = 15,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(45) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{50001,60000},{1001,1500},{1501,2000},{3001,3500},{4001,4500},{5001,5500},{6001,6500},{8501,9000},{9501,10000},{10001,10500},{2001,2500},{8001,8500},{9001,9500},{3501,4000},{2501,3000},{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,12},{00,00,00}},end_time={{2018,03,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 45,
        act_info=#act_info{},
        act_type = 16,
        show_list = [{4105020,1},{6602007,1},{3107002,1},{3307003,1},{6606012,1},{6604085,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(46) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,16},{00,00,00}},end_time={{2018,03,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 46,
        act_info=#act_info{},
        act_type = 17,
        show_list = [{4105040,1},{6602014,1},{3107005,1},{3307005,1},{6606003,1},{6604087,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(47) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,20},{00,00,00}},end_time={{2018,03,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 47,
        act_info=#act_info{},
        act_type = 18,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(48) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,24},{00,00,00}},end_time={{2018,03,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 48,
        act_info=#act_info{},
        act_type = 19,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(49) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,28},{00,00,00}},end_time={{2018,03,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 49,
        act_info=#act_info{},
        act_type = 20,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(50) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,01},{00,00,00}},end_time={{2018,04,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 50,
        act_info=#act_info{},
        act_type = 21,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(51) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,05},{00,00,00}},end_time={{2018,04,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 51,
        act_info=#act_info{},
        act_type = 22,
        show_list = [{4105028,1},{6602013,1},{3107008,1},{3307013,1},{6610025,1},{6604079,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(52) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,09},{00,00,00}},end_time={{2018,04,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 52,
        act_info=#act_info{},
        act_type = 23,
        show_list = [{4105039,1},{6602020,1},{3107009,1},{3307008,1},{6610010,1},{6604093,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(53) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,13},{00,00,00}},end_time={{2018,04,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 53,
        act_info=#act_info{},
        act_type = 18,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(54) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,17},{00,00,00}},end_time={{2018,04,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 54,
        act_info=#act_info{},
        act_type = 19,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(55) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,21},{00,00,00}},end_time={{2018,04,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 55,
        act_info=#act_info{},
        act_type = 20,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(56) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,25},{00,00,00}},end_time={{2018,04,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 56,
        act_info=#act_info{},
        act_type = 21,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(57) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,29},{00,00,00}},end_time={{2018,04,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 57,
        act_info=#act_info{},
        act_type = 22,
        show_list = [{4105028,1},{6602013,1},{3107008,1},{3307013,1},{6610025,1},{6604079,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(58) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,03},{00,00,00}},end_time={{2018,05,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 58,
        act_info=#act_info{},
        act_type = 23,
        show_list = [{4105039,1},{6602020,1},{3107009,1},{3307008,1},{6610010,1},{6604093,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(200) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,07},{00,00,00}},end_time={{2018,05,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 200,
        act_info=#act_info{},
        act_type = 23,
        show_list = [{4105039,1},{6602020,1},{3107009,1},{3307008,1},{6610010,1},{6604093,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(201) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,11},{00,00,00}},end_time={{2018,05,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 201,
        act_info=#act_info{},
        act_type = 18,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(202) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,15},{00,00,00}},end_time={{2018,05,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 202,
        act_info=#act_info{},
        act_type = 19,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(203) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,19},{00,00,00}},end_time={{2018,05,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 203,
        act_info=#act_info{},
        act_type = 20,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(204) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,23},{00,00,00}},end_time={{2018,05,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 204,
        act_info=#act_info{},
        act_type = 21,
        show_list = [{4105031,1},{6602007,1},{3107007,1},{3307002,1},{6610011,1},{6604083,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(205) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,27},{00,00,00}},end_time={{2018,05,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 205,
        act_info=#act_info{},
        act_type = 22,
        show_list = [{4105028,1},{6602013,1},{3107008,1},{3307013,1},{6610025,1},{6604079,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };

get(206) ->
    #base_mystery_shop{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,31},{00,00,00}},end_time={{2018,05,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id = 206,
        act_info=#act_info{},
        act_type = 23,
        show_list = [{4105039,1},{6602020,1},{3107009,1},{3307008,1},{6610010,1},{6604093,1},{7321001,1},{7321002,1},{8002406,1}],
        refresh_cost = 10,
        refresh_cd_time = 3600
        };
get(_) -> [].

get_all() -> [6,7,8,9,10,11,12,13,14,15,16,17,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,200,201,202,203,204,205,206].
