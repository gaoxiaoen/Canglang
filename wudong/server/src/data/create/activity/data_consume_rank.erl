%% 配置生成时间 2018-04-23 20:11:23
-module(data_consume_rank).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,rank_info = [
   #rank_info{ top=1,down=1,limit=2000,reward = {{8001054,20},{2003000,30},{8001002,10}}},
   #rank_info{ top=2,down=3,limit=1000,reward = {{8001054,15},{2003000,20},{8001002,5}}},
   #rank_info{ top=4,down=10,limit=500,reward = {{8001054,10},{2003000,10},{8001002,3}}},
   #rank_info{ top=11,down=50,limit=100,reward = {{8001054,5},{2003000,5},{8001002,2}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{2003000,10},{2005000,10}}}],act_info=#act_info{} };
get(3) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=5,end_day=6,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=3,rank_info = [
   #rank_info{ top=1,down=1,limit=3000,reward = {{6606017,10},{8001002,10},{2003000,15}}},
   #rank_info{ top=2,down=3,limit=2000,reward = {{6606017,10},{8001002,5},{2003000,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002405,1},{8001002,3}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002404,1},{8001002,2}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,2}}}],act_info=#act_info{} };
get(21) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=1,end_day=2,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=21,rank_info = [
   #rank_info{ top=1,down=1,limit=3000,reward = {{8002407,1},{8001002,10},{2003000,15}}},
   #rank_info{ top=2,down=3,limit=2000,reward = {{8002406,1},{8001002,5},{2003000,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002405,1},{8001002,3}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002404,1},{8001002,2}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,2}}}],act_info=#act_info{} };
get(26) -> #base_consume_rank{open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=9,end_day=10,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=26,rank_info = [
   #rank_info{ top=1,down=1,limit=3000,reward = {{6606008,10},{8001002,10},{2003000,15}}},
   #rank_info{ top=2,down=3,limit=2000,reward = {{6606008,10},{8001002,5},{2003000,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002405,1},{8001002,3}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002404,1},{8001002,2}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,2}}}],act_info=#act_info{} };
get(27) -> #base_consume_rank{open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=13,end_day=14,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=27,rank_info = [
   #rank_info{ top=1,down=1,limit=3000,reward = {{6610010,10},{8001002,10},{2003000,15}}},
   #rank_info{ top=2,down=3,limit=2000,reward = {{6610010,10},{8001002,5},{2003000,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002405,1},{8001002,3}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002404,1},{8001002,2}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,2}}}],act_info=#act_info{} };
get(11) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,09,25},{21,37,08}},end_time={{2017,09,25},{23,37,14}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=7},act_id=11,rank_info = [
   #rank_info{ top=1,down=1,limit=3500,reward = {{11601,1},{2003000,30},{8001002,20}}},
   #rank_info{ top=2,down=3,limit=1500,reward = {{8001054,8},{2003000,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=800,reward = {{8001054,4},{2003000,10},{8001002,6}}},
   #rank_info{ top=11,down=50,limit=100,reward = {{8001054,2},{2003000,6},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{2003000,10},{2005000,10}}}],act_info=#act_info{} };
get(28) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,01},{00,00,00}},end_time={{2017,10,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=28,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602007,10},{8001054,20},{8001002,10}}},
   #rank_info{ top=2,down=3,limit=3000,reward = {{8002407,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001054,15},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,6}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(29) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,15},{00,00,00}},end_time={{2017,10,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},act_id=29,rank_info = [
   #rank_info{ top=1,down=1,limit=2000,reward = {{6606013,10},{8001054,15},{8001002,10}}},
   #rank_info{ top=2,down=3,limit=1000,reward = {{6606013,10},{8001054,15},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=500,reward = {{8001054,15},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,6}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(30) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,21},{00,00,00}},end_time={{2017,10,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=15},act_id=30,rank_info = [
   #rank_info{ top=1,down=1,limit=1000,reward = {{6610011,10},{8001054,20},{8001002,15}}},
   #rank_info{ top=2,down=3,limit=800,reward = {{6610011,10},{8001054,15},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=500,reward = {{8001054,15},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,6}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(31) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,23},{00,00,00}},end_time={{2017,10,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=31,rank_info = [
   #rank_info{ top=1,down=1,limit=1000,reward = {{6610006,10},{8001054,20},{8001002,15}}},
   #rank_info{ top=2,down=3,limit=800,reward = {{6610006,10},{8001054,15},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=500,reward = {{8001054,15},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,6}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(32) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,27},{00,00,00}},end_time={{2017,10,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=32,rank_info = [
   #rank_info{ top=1,down=1,limit=1000,reward = {{6610009,10},{8001054,20},{8001002,15}}},
   #rank_info{ top=2,down=3,limit=800,reward = {{6610009,10},{8001054,15},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=500,reward = {{8001054,15},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,6}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(33) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,31},{00,00,00}},end_time={{2017,11,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=33,rank_info = [
   #rank_info{ top=1,down=1,limit=1000,reward = {{6610012,10},{8001054,20},{8001002,15}}},
   #rank_info{ top=2,down=3,limit=800,reward = {{6610012,10},{8001054,15},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=500,reward = {{8001054,15},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,6}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(34) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,04},{00,00,00}},end_time={{2017,11,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=34,rank_info = [
   #rank_info{ top=1,down=1,limit=1000,reward = {{6610003,10},{8001054,20},{8001002,15}}},
   #rank_info{ top=2,down=3,limit=800,reward = {{6610003,10},{8001054,15},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=500,reward = {{8001054,15},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,6}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(35) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,08},{00,00,00}},end_time={{2017,11,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=35,rank_info = [
   #rank_info{ top=1,down=1,limit=1000,reward = {{6606001,10},{8001054,20},{8001002,15}}},
   #rank_info{ top=2,down=3,limit=800,reward = {{6606001,10},{8001054,15},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=500,reward = {{8001054,15},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,6}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(36) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,12},{00,00,00}},end_time={{2017,11,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=36,rank_info = [
   #rank_info{ top=1,down=1,limit=1000,reward = {{6604083,10},{8001054,20},{8001002,15}}},
   #rank_info{ top=2,down=3,limit=800,reward = {{6604083,10},{8001054,15},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=500,reward = {{8001054,15},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,6}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(37) -> #base_consume_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,20},{00,00,00}},end_time={{2017,11,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=37,rank_info = [
   #rank_info{ top=1,down=1,limit=1000,reward = {{6610013,10},{8001054,20},{8001002,15}}},
   #rank_info{ top=2,down=3,limit=800,reward = {{6610013,10},{8001054,15},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=500,reward = {{8001054,15},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,6}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(_) -> [].

get_all() -> [1,3,21,26,27,11,28,29,30,31,32,33,34,35,36,37].
