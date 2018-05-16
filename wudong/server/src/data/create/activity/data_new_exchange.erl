%% 配置生成时间 2018-05-14 17:01:05
-module(data_new_exchange).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(5) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=5,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,1},{2005000,1}],exchange_get=[{21001,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,3},{2005000,3}],exchange_get=[{6604001,1}],exchange_num=3},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,5},{2005000,5}],exchange_get=[{6602001,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2003000,10},{10199,800}],exchange_get=[{21005,1}],exchange_num=1}
        ],
        act_info=#act_info{}
    };

get(21) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=6,end_day=7,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=21,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1045001,150}],exchange_get=[{3307004,10}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{1045001,88}],exchange_get=[{4104028,1}],exchange_num=1},
            #base_new_exchange_sub{id=3,exchange_cost=[{1045001,2}],exchange_get=[{8001054,1}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1045001,10}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=5,exchange_cost=[{1045001,10}],exchange_get=[{2014001,1}],exchange_num=5},
            #base_new_exchange_sub{id=6,exchange_cost=[{1045001,10}],exchange_get=[{8002405,1}],exchange_num=3},
            #base_new_exchange_sub{id=7,exchange_cost=[{1045001,3}],exchange_get=[{8002403,1}],exchange_num=3},
            #base_new_exchange_sub{id=8,exchange_cost=[{1045001,1}],exchange_get=[{8002401,1}],exchange_num=3},
            #base_new_exchange_sub{id=9,exchange_cost=[{1045001,1}],exchange_get=[{2003000,5}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(22) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=12,end_day=13,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=22,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1045001,20}],exchange_get=[{3107003,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1045001,18}],exchange_get=[{7303005,1}],exchange_num=1},
            #base_new_exchange_sub{id=3,exchange_cost=[{1045001,2}],exchange_get=[{8001054,1}],exchange_num=1},
            #base_new_exchange_sub{id=4,exchange_cost=[{1045001,10}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=5,exchange_cost=[{1045001,10}],exchange_get=[{11601,1}],exchange_num=5},
            #base_new_exchange_sub{id=6,exchange_cost=[{1045001,10}],exchange_get=[{8002405,1}],exchange_num=3},
            #base_new_exchange_sub{id=7,exchange_cost=[{1045001,3}],exchange_get=[{8002403,1}],exchange_num=3},
            #base_new_exchange_sub{id=8,exchange_cost=[{1045001,1}],exchange_get=[{8002401,1}],exchange_num=3},
            #base_new_exchange_sub{id=9,exchange_cost=[{1045001,1}],exchange_get=[{2003000,5}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(30) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=4,end_day=5,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=30,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,888}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606007,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(23) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,25},{00,00,00}},end_time={{2017,10,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=23,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,1},{2005000,1}],exchange_get=[{21001,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,1},{2005000,1}],exchange_get=[{1025001,1}],exchange_num=5},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,5},{10106,200}],exchange_get=[{6602004,1}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{2003000,10},{10199,200}],exchange_get=[{3307008,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(24) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,01},{00,00,00}},end_time={{2017,11,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=24,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,1},{2005000,1}],exchange_get=[{21001,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,1},{2005000,1}],exchange_get=[{1025001,1}],exchange_num=5},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,5},{10106,200}],exchange_get=[{6602003,1}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{2003000,10},{10199,88}],exchange_get=[{6604073,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(25) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,08},{00,00,00}},end_time={{2017,11,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=25,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,888}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606002,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=5},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=5},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=5}
        ],
        act_info=#act_info{}
    };

get(26) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,15},{00,00,00}},end_time={{2017,11,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=26,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,888}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606007,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(27) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,22},{00,00,00}},end_time={{2017,11,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=27,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,888}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606007,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(28) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,29},{00,00,00}},end_time={{2017,12,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=28,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,666}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606013,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(29) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,06},{00,00,00}},end_time={{2017,12,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=29,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,666}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606007,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(31) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{50001,60000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[2656,2655,2654,2653,2652,2651,2645,2644,2643,2642,2640,2638,2636,2635,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3013,3011,3010,3009,3008,3007,3006,3553,3552,3550,3549,3547,3546,3545,3542,3539,3534,3526,3521,3513,3501,8545,8544,8543,8542,8539,8538,8537,8536,8534,8533,8531,8530,8529,8527,8523,8521,8507,8505,8501,9001,9512,9511,9510,9509,9508,9507,9506,9501],open_day=0,end_day=0,start_time={{2017,12,13},{00,00,00}},end_time={{2017,12,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=31,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,666}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606013,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(32) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,20},{00,00,00}},end_time={{2017,12,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=32,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,666}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606002,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(33) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,27},{00,00,00}},end_time={{2017,12,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=33,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,666}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606007,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(34) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,03},{00,00,00}},end_time={{2018,01,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=34,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,666}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606001,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(35) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,10},{00,00,00}},end_time={{2018,01,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=35,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,666}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606007,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(36) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,17},{00,00,00}},end_time={{2018,01,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=36,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,666}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606012,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(37) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,18},{00,00,00}},end_time={{2018,01,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=37,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,666}],exchange_get=[{21003,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,100}],exchange_get=[{6606012,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(38) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,24},{00,00,00}},end_time={{2018,01,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=38,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,1500}],exchange_get=[{21005,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,150}],exchange_get=[{6606009,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(39) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,31},{00,00,00}},end_time={{2018,02,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=39,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,1500}],exchange_get=[{21005,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,150}],exchange_get=[{6606004,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(40) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,07},{00,00,00}},end_time={{2018,02,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=40,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,1500}],exchange_get=[{21005,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,150}],exchange_get=[{6610008,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(41) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,14},{00,00,00}},end_time={{2018,02,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=41,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,1500}],exchange_get=[{21005,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,150}],exchange_get=[{6606015,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(42) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,21},{00,00,00}},end_time={{2018,02,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=42,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,1500}],exchange_get=[{21005,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,150}],exchange_get=[{6606001,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(43) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,28},{00,00,00}},end_time={{2018,03,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=43,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,1500}],exchange_get=[{21005,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,150}],exchange_get=[{6606012,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(44) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,07},{00,00,00}},end_time={{2018,03,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=44,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,1500}],exchange_get=[{21005,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,150}],exchange_get=[{6604109,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(45) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,14},{00,00,00}},end_time={{2018,03,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=45,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,1500}],exchange_get=[{21005,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,150}],exchange_get=[{6604107,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(46) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,21},{00,00,00}},end_time={{2018,03,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=46,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{2003000,5},{10106,1500}],exchange_get=[{21005,1}],exchange_num=1},
            #base_new_exchange_sub{id=2,exchange_cost=[{2003000,10},{10106,150}],exchange_get=[{6610024,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{2003000,10},{10106,88}],exchange_get=[{8001058,1}],exchange_num=3},
            #base_new_exchange_sub{id=4,exchange_cost=[{2005000,10},{10101,10000}],exchange_get=[{8001054,1}],exchange_num=30},
            #base_new_exchange_sub{id=5,exchange_cost=[{2005000,15},{10101,20000}],exchange_get=[{4503001,1}],exchange_num=3},
            #base_new_exchange_sub{id=6,exchange_cost=[{2005000,20},{10101,30000}],exchange_get=[{4503002,1}],exchange_num=3}
        ],
        act_info=#act_info{}
    };

get(47) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,28},{00,00,00}},end_time={{2018,03,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=47,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1027011,50}],exchange_get=[{7308011,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1027011,40}],exchange_get=[{8001303,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{1027011,20}],exchange_get=[{8001054,10}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1027011,10}],exchange_get=[{8001661,10}],exchange_num=10},
            #base_new_exchange_sub{id=5,exchange_cost=[{1027011,5}],exchange_get=[{8001002,5}],exchange_num=10},
            #base_new_exchange_sub{id=6,exchange_cost=[{1027011,1}],exchange_get=[{8001301,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(48) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,04},{00,00,00}},end_time={{2018,04,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=48,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1027011,50}],exchange_get=[{7308011,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1027011,40}],exchange_get=[{8001303,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{1027011,20}],exchange_get=[{8001054,10}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1027011,10}],exchange_get=[{8001661,10}],exchange_num=10},
            #base_new_exchange_sub{id=5,exchange_cost=[{1027011,5}],exchange_get=[{8001002,5}],exchange_num=10},
            #base_new_exchange_sub{id=6,exchange_cost=[{1027011,1}],exchange_get=[{8001301,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(49) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,11},{00,00,00}},end_time={{2018,04,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=49,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1027011,50}],exchange_get=[{7308011,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1027011,40}],exchange_get=[{8001303,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{1027011,20}],exchange_get=[{8001054,10}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1027011,10}],exchange_get=[{8001661,10}],exchange_num=10},
            #base_new_exchange_sub{id=5,exchange_cost=[{1027011,5}],exchange_get=[{8001002,5}],exchange_num=10},
            #base_new_exchange_sub{id=6,exchange_cost=[{1027011,1}],exchange_get=[{8001301,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(50) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,18},{00,00,00}},end_time={{2018,04,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=50,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1027011,50}],exchange_get=[{7308011,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1027011,40}],exchange_get=[{8001303,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{1027011,20}],exchange_get=[{8001054,10}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1027011,10}],exchange_get=[{8001661,10}],exchange_num=10},
            #base_new_exchange_sub{id=5,exchange_cost=[{1027011,5}],exchange_get=[{8001002,5}],exchange_num=10},
            #base_new_exchange_sub{id=6,exchange_cost=[{1027011,1}],exchange_get=[{8001301,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(51) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,25},{00,00,00}},end_time={{2018,04,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=51,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1027011,50}],exchange_get=[{7308011,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1027011,40}],exchange_get=[{8001303,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{1027011,20}],exchange_get=[{8001054,10}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1027011,10}],exchange_get=[{8001661,10}],exchange_num=10},
            #base_new_exchange_sub{id=5,exchange_cost=[{1027011,5}],exchange_get=[{8001002,5}],exchange_num=10},
            #base_new_exchange_sub{id=6,exchange_cost=[{1027011,1}],exchange_get=[{8001301,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(52) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,02},{00,00,00}},end_time={{2018,05,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=52,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1027011,50}],exchange_get=[{7308011,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1027011,40}],exchange_get=[{8001303,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{1027011,20}],exchange_get=[{8001054,10}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1027011,10}],exchange_get=[{8001661,10}],exchange_num=10},
            #base_new_exchange_sub{id=5,exchange_cost=[{1027011,5}],exchange_get=[{8001002,5}],exchange_num=10},
            #base_new_exchange_sub{id=6,exchange_cost=[{1027011,1}],exchange_get=[{8001301,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(200) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,09},{00,00,00}},end_time={{2018,05,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=200,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1027011,50}],exchange_get=[{7308011,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1027011,40}],exchange_get=[{8001303,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{1027011,20}],exchange_get=[{8001054,10}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1027011,10}],exchange_get=[{8001661,10}],exchange_num=10},
            #base_new_exchange_sub{id=5,exchange_cost=[{1027011,5}],exchange_get=[{8001002,5}],exchange_num=10},
            #base_new_exchange_sub{id=6,exchange_cost=[{1027011,1}],exchange_get=[{8001301,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(201) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,16},{00,00,00}},end_time={{2018,05,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=201,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1027011,50}],exchange_get=[{7308011,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1027011,40}],exchange_get=[{8001303,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{1027011,20}],exchange_get=[{8001054,10}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1027011,10}],exchange_get=[{8001661,10}],exchange_num=10},
            #base_new_exchange_sub{id=5,exchange_cost=[{1027011,5}],exchange_get=[{8001002,5}],exchange_num=10},
            #base_new_exchange_sub{id=6,exchange_cost=[{1027011,1}],exchange_get=[{8001301,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(202) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,23},{00,00,00}},end_time={{2018,05,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=202,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1027011,50}],exchange_get=[{7308011,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1027011,40}],exchange_get=[{8001303,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{1027011,20}],exchange_get=[{8001054,10}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1027011,10}],exchange_get=[{8001661,10}],exchange_num=10},
            #base_new_exchange_sub{id=5,exchange_cost=[{1027011,5}],exchange_get=[{8001002,5}],exchange_num=10},
            #base_new_exchange_sub{id=6,exchange_cost=[{1027011,1}],exchange_get=[{8001301,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(203) ->
    #base_new_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,30},{00,00,00}},end_time={{2018,05,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=203,
        list=[
            #base_new_exchange_sub{id=1,exchange_cost=[{1027011,50}],exchange_get=[{7308011,1}],exchange_num=10},
            #base_new_exchange_sub{id=2,exchange_cost=[{1027011,40}],exchange_get=[{8001303,1}],exchange_num=10},
            #base_new_exchange_sub{id=3,exchange_cost=[{1027011,20}],exchange_get=[{8001054,10}],exchange_num=10},
            #base_new_exchange_sub{id=4,exchange_cost=[{1027011,10}],exchange_get=[{8001661,10}],exchange_num=10},
            #base_new_exchange_sub{id=5,exchange_cost=[{1027011,5}],exchange_get=[{8001002,5}],exchange_num=10},
            #base_new_exchange_sub{id=6,exchange_cost=[{1027011,1}],exchange_get=[{8001301,1}],exchange_num=10}
        ],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [5,21,22,30,23,24,25,26,27,28,29,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,200,201,202,203].
