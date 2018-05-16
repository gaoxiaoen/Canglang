%% 配置生成时间 2018-05-14 17:02:00
-module(data_area_recharge_rank).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(2) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,25},{00,00,00}},end_time={{2017,11,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=2,rank_info = [
   #rank_info{ top=1,down=1,limit=8000,reward = {{8001653,1},{8002407,1},{8002516,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{8002407,1},{8002516,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(3) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,02},{00,00,00}},end_time={{2017,12,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=3,rank_info = [
   #rank_info{ top=1,down=1,limit=8000,reward = {{6602013,10},{8002407,1},{8002516,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{8002407,1},{8002516,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(4) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,09},{00,00,00}},end_time={{2017,12,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=4,rank_info = [
   #rank_info{ top=1,down=1,limit=8000,reward = {{3107009,10},{8002407,1},{8001002,30}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{8002407,1},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,5}}}],act_info=#act_info{} };
get(1) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{30001,50000},{50001,60000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,12},{00,00,00}},end_time={{2017,12,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=1,rank_info = [
   #rank_info{ top=1,down=1,limit=8000,reward = {{8001653,1},{8002407,1},{8001002,30}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{8002407,1},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,5}}}],act_info=#act_info{} };
get(5) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{50001,60000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[2656,2655,2654,2653,2652,2651,2646,2645,2644,2643,2642,2640,2638,2636,2635,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3013,3011,3010,3009,3008,3007,3006,3553,3552,3550,3549,3547,3546,3545,3542,3539,3534,3526,3521,3513,3501,8545,8544,8543,8539,8538,8537,8536,8534,8533,8531,8530,8529,8527,8523,8521,8507,8505,8501,9002,9001,9512,9511,9510,9509,9508,9507,9506,9501],open_day=0,end_day=0,start_time={{2017,12,14},{00,00,00}},end_time={{2017,12,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=5,rank_info = [
   #rank_info{ top=1,down=1,limit=8000,reward = {{8001653,1},{8002407,1},{8001002,30}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{8002407,1},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,5}}}],act_info=#act_info{} };
get(9) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{30001,50000},{50001,60000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,20},{00,00,00}},end_time={{2017,12,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=9,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{8001653,1},{8002407,1},{8002516,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{8002407,1},{8002516,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8002516,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8002516,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(7) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,21},{00,00,00}},end_time={{2017,12,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=7,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{8001653,1},{8002407,1},{8002516,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{8002407,1},{8002516,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8002516,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8002516,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(8) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,22},{00,00,00}},end_time={{2017,12,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=8,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{8001653,1},{8002407,1},{8002516,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{8002407,1},{8002516,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8002516,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8002516,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(10) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,28},{00,00,00}},end_time={{2017,12,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=10,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602008,10},{8002407,1},{8002516,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{8002407,1},{8002516,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8002516,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8002516,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(11) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,30},{00,00,00}},end_time={{2017,12,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=11,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3107009,10},{8002407,1},{8002516,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{8002407,1},{8002516,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8002516,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8002516,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(20) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,04},{00,00,00}},end_time={{2018,01,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=20,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{8001653,1},{6604091,10},{8002516,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8001652,1},{6604091,10},{8002516,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8002516,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8002516,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(21) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,06},{00,00,00}},end_time={{2018,01,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=21,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602019,10},{6604091,10},{8002516,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602019,5},{6604091,10},{8002516,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8002516,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8002516,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(22) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,18},{00,00,00}},end_time={{2018,01,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=22,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3107003,10},{6604096,10},{8001002,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{5101448,5},{6604096,10},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(23) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,27},{00,00,00}},end_time={{2018,01,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=23,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602016,10},{6604096,10},{8001002,15}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602016,5},{6604096,10},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(24) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,31},{00,00,00}},end_time={{2018,01,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=24,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602008,10},{11601,1},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(25) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,02},{00,00,00}},end_time={{2018,02,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=25,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3107003,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(26) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,12},{00,00,00}},end_time={{2018,02,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=26,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602021,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(27) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,14},{00,00,00}},end_time={{2018,02,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=27,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3307011,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(28) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,20},{00,00,00}},end_time={{2018,02,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=28,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602013,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(29) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,22},{00,00,00}},end_time={{2018,02,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=29,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3107003,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(30) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,24},{00,00,00}},end_time={{2018,02,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=30,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602005,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(31) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,26},{00,00,00}},end_time={{2018,02,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=31,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602015,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(32) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,28},{00,00,00}},end_time={{2018,02,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=32,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602018,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(33) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,02},{00,00,00}},end_time={{2018,03,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=33,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3307008,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(34) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,04},{00,00,00}},end_time={{2018,03,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=34,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602020,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(35) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,07},{00,00,00}},end_time={{2018,03,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=35,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3207001,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(36) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,09},{00,00,00}},end_time={{2018,03,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=36,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602019,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(38) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,13},{00,00,00}},end_time={{2018,03,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=38,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3307012,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(37) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,15},{00,00,00}},end_time={{2018,03,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=37,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602025,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(39) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,17},{00,00,00}},end_time={{2018,03,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=39,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602020,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(40) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,21},{00,00,00}},end_time={{2018,03,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=40,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602007,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(41) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,23},{00,00,00}},end_time={{2018,03,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=41,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7404019,1},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7404017,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001652,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(42) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,27},{00,00,00}},end_time={{2018,03,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=42,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7403019,10},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7403017,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001652,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(43) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,29},{00,00,00}},end_time={{2018,03,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=43,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7402019,1},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7402017,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001652,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(44) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,31},{00,00,00}},end_time={{2018,03,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=44,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7401019,1},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7401017,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001652,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(45) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,04},{00,00,00}},end_time={{2018,04,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=45,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7404020,1},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7404019,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001652,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(46) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,06},{00,00,00}},end_time={{2018,04,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=46,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7403020,1},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7403019,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001652,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(47) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,10},{00,00,00}},end_time={{2018,04,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=47,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7402020,1},{11601,3},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7402019,1},{8001054,20},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001652,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(48) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,12},{00,00,00}},end_time={{2018,04,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=48,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7403020,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7403019,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,3}}}],act_info=#act_info{} };
get(49) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,14},{00,00,00}},end_time={{2018,04,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=49,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7401020,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7401019,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(50) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,16},{00,00,00}},end_time={{2018,04,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=50,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602027,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602027,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(51) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,18},{00,00,00}},end_time={{2018,04,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=51,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7404020,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7404019,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(52) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,19},{00,00,00}},end_time={{2018,04,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=52,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602024,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602024,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(53) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,20},{00,00,00}},end_time={{2018,04,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=53,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7402020,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7402019,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(54) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,22},{00,00,00}},end_time={{2018,04,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=54,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3307015,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{3307015,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(55) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,23},{00,00,00}},end_time={{2018,04,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=55,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7404021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7404019,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(56) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,24},{00,00,00}},end_time={{2018,04,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=56,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602026,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602026,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(57) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,26},{00,00,00}},end_time={{2018,04,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=57,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602028,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602028,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(58) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,28},{00,00,00}},end_time={{2018,04,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=58,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7401021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7401019,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(59) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,30},{00,00,00}},end_time={{2018,04,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=59,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602019,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602019,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(60) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,02},{00,00,00}},end_time={{2018,05,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=60,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7501102,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7501102,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(61) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,03},{00,00,00}},end_time={{2018,05,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=61,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3307012,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{3307012,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(62) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,04},{00,00,00}},end_time={{2018,05,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=62,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602023,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602023,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(63) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,06},{00,00,00}},end_time={{2018,05,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=63,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7403021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7403019,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(200) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,07},{00,00,00}},end_time={{2018,05,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=200,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602031,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602031,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(201) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,08},{00,00,00}},end_time={{2018,05,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=201,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7402021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7402020,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(202) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,10},{00,00,00}},end_time={{2018,05,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=202,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602032,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602032,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(203) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,12},{00,00,00}},end_time={{2018,05,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=203,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7401021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7401020,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(204) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,14},{00,00,00}},end_time={{2018,05,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=204,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602027,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602027,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(205) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,16},{00,00,00}},end_time={{2018,05,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=205,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7404021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7404020,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(206) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,17},{00,00,00}},end_time={{2018,05,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=206,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602024,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602024,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(207) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,18},{00,00,00}},end_time={{2018,05,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=207,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7403021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7403020,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(208) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,20},{00,00,00}},end_time={{2018,05,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=208,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3307015,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{3307015,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(209) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,21},{00,00,00}},end_time={{2018,05,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=209,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7404021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7404020,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(210) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,22},{00,00,00}},end_time={{2018,05,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=210,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602026,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602026,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(211) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,24},{00,00,00}},end_time={{2018,05,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=211,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602028,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602028,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(212) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,26},{00,00,00}},end_time={{2018,05,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=212,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7401021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7401020,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(213) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,28},{00,00,00}},end_time={{2018,05,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=213,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602019,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602019,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(214) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,30},{00,00,00}},end_time={{2018,05,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=214,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7501102,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7501102,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(215) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,31},{00,00,00}},end_time={{2018,05,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=215,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7401021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7401020,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(216) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,06,01},{00,00,00}},end_time={{2018,06,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=216,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602023,10},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{6602023,4},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(217) -> #base_act_area_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,06,03},{00,00,00}},end_time={{2018,06,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=217,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7403021,1},{8002410,1},{8001663,50}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7403020,1},{8002408,1},{8001663,30}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,15}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(_) -> [].

get_all() -> [2,3,4,1,5,9,7,8,10,11,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,38,37,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217].
