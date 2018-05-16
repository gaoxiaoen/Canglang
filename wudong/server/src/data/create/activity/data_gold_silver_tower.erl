%% 配置生成时间 2018-05-14 17:01:14
-module(data_gold_silver_tower).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(22) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=10,end_day=11,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=22,
        cost_one=25	,
        cost_ten = 
250	,
        cost_fifty = 
1250	,
        fashion_id = 
6601005	,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,4,30},{2,8002402,1,10},{3,10106,20,10},{4,1016002,1,10},{5,1008000,1,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,25,15},{2,8001002,1,15},{3,1016002,1,15},{4,8001054,1,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8001163,1,25},{3,8002403,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,2,33},{2,8001057,1,33},{3,8001186,1,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002404,1,50},{2,8001186,1,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6602005,2,100}] }],
        act_info=#act_info{} };
get(31) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=5,end_day=6,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=31,
        cost_one=25	,
        cost_ten = 
250	,
        cost_fifty = 
1250	,
        fashion_id = 
3312005	,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,2,30},{2,8002402,1,10},{3,10106,30,10},{4,1016002,1,10},{5,1008000,1,10},{6,8001054,1,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,35,15},{2,8001002,1,15},{3,1016002,1,15},{4,8001054,2,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8001163,1,25},{3,8002403,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,2,33},{2,8001057,1,33},{3,8001186,1,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002404,1,50},{2,8001186,1,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3312005,1,100}] }],
        act_info=#act_info{} };
get(7) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,08,05},{00,00,00}},end_time={{2017,08,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=7},act_id=7,
        cost_one=25	,
        cost_ten = 
250	,
        cost_fifty = 
1250	,
        fashion_id = 
6601007	,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,10},{2,2005000,15,10},{3,10106,30,10},{4,1016002,1,10},{5,1009002,1,10},{6,1008000,3,50}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,30,15},{2,8001002,2,15},{3,1016002,1,15},{4,8001055,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8001163,2,25},{3,2005000,10,40},{4,8001002,4,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,4,33},{2,8001057,3,33},{3,8001186,1,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,2005000,20,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6602007,5,100}] }],
        act_info=#act_info{} };
get(25) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,15},{00,00,00}},end_time={{2017,10,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},act_id=25,
        cost_one=25	,
        cost_ten = 
250	,
        cost_fifty = 
1250	,
        fashion_id = 
6602015	,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,4,30},{2,8002402,1,10},{3,10106,20,10},{4,1016002,1,10},{5,1008000,1,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,25,15},{2,8001002,1,15},{3,1016002,1,15},{4,8001054,1,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8001163,1,25},{3,8002403,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,2,33},{2,8001057,1,33},{3,8001186,1,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002404,1,50},{2,8001186,1,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6602015,2,100}] }],
        act_info=#act_info{} };
get(26) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,22},{00,00,00}},end_time={{2017,10,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=15},act_id=26,
        cost_one=25	,
        cost_ten = 
250	,
        cost_fifty = 
1250	,
        fashion_id = 
6602012	,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,4,30},{2,8002402,1,10},{3,10106,20,10},{4,1016002,1,10},{5,1008000,1,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,25,15},{2,8001002,1,15},{3,1016002,1,15},{4,8001054,1,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8001163,1,25},{3,8002403,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,2,33},{2,8001057,1,33},{3,8001186,1,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002404,1,50},{2,8001186,1,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6602012,2,100}] }],
        act_info=#act_info{} };
get(27) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,28},{00,00,00}},end_time={{2017,10,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},act_id=27,
        cost_one=25	,
        cost_ten = 
250	,
        cost_fifty = 
1250	,
        fashion_id = 
3307007	,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,4,30},{2,8002402,1,10},{3,10106,20,10},{4,1016002,1,10},{5,1008000,1,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,25,15},{2,8001002,1,15},{3,1016002,1,15},{4,8001054,1,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8001163,1,25},{3,8002403,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,2,33},{2,8001057,1,33},{3,8001186,1,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002404,1,50},{2,8001186,1,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3307007,2,100}] }],
        act_info=#act_info{} };
get(28) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,04},{00,00,00}},end_time={{2017,11,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},act_id=28,
        cost_one=25	,
        cost_ten = 
250	,
        cost_fifty = 
1250	,
        fashion_id = 
3107001	,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3107001,1,100}] }],
        act_info=#act_info{} };
get(29) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,18},{00,00,00}},end_time={{2017,11,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},act_id=29,
        cost_one=25	,
        cost_ten = 
250	,
        cost_fifty = 
1250	,
        fashion_id = 
8001522	,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,8001522,1,100}] }],
        act_info=#act_info{} };
get(30) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,02},{00,00,00}},end_time={{2017,12,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},act_id=30,
        cost_one=25	,
        cost_ten = 
250	,
        cost_fifty = 
1250	,
        fashion_id = 
3112001	,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3112001,1,100}] }],
        act_info=#act_info{} };
get(32) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,06},{00,00,00}},end_time={{2018,01,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=32,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6602021,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6602021,1,100}] }],
        act_info=#act_info{} };
get(33) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,13},{00,00,00}},end_time={{2018,01,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=33,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3307007,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3307007,1,100}] }],
        act_info=#act_info{} };
get(34) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,20},{00,00,00}},end_time={{2018,01,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=34,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6602014,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6602014,1,100}] }],
        act_info=#act_info{} };
get(35) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,27},{00,00,00}},end_time={{2018,01,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=35,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6633013,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6633013,1,100}] }],
        act_info=#act_info{} };
get(36) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,29},{00,00,00}},end_time={{2018,01,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=36,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6602023,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6602023,1,100}] }],
        act_info=#act_info{} };
get(37) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,05},{00,00,00}},end_time={{2018,02,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=37,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3107004,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3107004,1,100}] }],
        act_info=#act_info{} };
get(38) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,12},{00,00,00}},end_time={{2018,02,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=38,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6602016,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6602016,1,100}] }],
        act_info=#act_info{} };
get(39) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,19},{00,00,00}},end_time={{2018,02,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=39,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3207003,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3207003,1,100}] }],
        act_info=#act_info{} };
get(40) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,26},{00,00,00}},end_time={{2018,02,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=40,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6602013,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6602013,1,100}] }],
        act_info=#act_info{} };
get(41) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,05},{00,00,00}},end_time={{2018,03,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=41,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3107012,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3107012,1,100}] }],
        act_info=#act_info{} };
get(42) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,12},{00,00,00}},end_time={{2018,03,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=42,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3107011,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,10,30},{2,8002403,1,10},{3,10106,40,10},{4,7415001,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,50,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,25},{3,8002404,1,40},{4,8001002,2,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,3,33},{2,8001057,2,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002405,1,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3107011,1,100}] }],
        act_info=#act_info{} };
get(43) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,19},{00,00,00}},end_time={{2018,03,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=43,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3112010,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,7415001,7,30},{2,8002404,1,10},{3,10106,50,10},{4,11120,10,10},{5,7405001,10,10},{6,8001054,3,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,100,15},{2,8002516,5,15},{3,7415001,14,15},{4,8001054,5,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,5,25},{3,8002405,1,40},{4,10106,150,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001663,3,33},{2,8001057,10,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,8002406,1,50},{2,8001186,4,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3112010,1,100}] }],
        act_info=#act_info{} };
get(44) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,26},{00,00,00}},end_time={{2018,03,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=44,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3312009,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,7415001,10,30},{2,8002404,1,10},{3,10106,20,10},{4,11120,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,30,15},{2,8002516,2,15},{3,7415001,5,15},{4,8001002,1,10},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8002518,2,40},{3,8002405,1,25},{4,10199,30,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001663,1,33},{2,10106,80,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,10106,100,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3312009,1,100}] }],
        act_info=#act_info{} };
get(45) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,02},{00,00,00}},end_time={{2018,04,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=45,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6633007,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,7415001,10,30},{2,8002404,1,10},{3,10106,40,10},{4,11120,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,60,15},{2,8002516,2,15},{3,7415001,5,15},{4,10199,30,5},{5,8001186,1,15}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,30},{2,10199,40,5},{3,8002405,1,30},{4,8002518,10,30}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001663,1,45},{2,10199,50,5},{3,8001186,2,45}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,10106,100,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6633007,1,100}] }],
        act_info=#act_info{} };
get(46) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,09},{00,00,00}},end_time={{2018,04,09},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=46,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3312007,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,7415001,10,30},{2,8002404,1,10},{3,10106,40,10},{4,11120,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,60,15},{2,8002516,2,15},{3,7415001,5,15},{4,10199,30,5},{5,8001186,1,15}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,30},{2,10199,40,5},{3,8002405,1,30},{4,8002518,10,30}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001663,1,45},{2,10199,50,5},{3,8001186,2,45}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,10106,100,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3312007,1,100}] }],
        act_info=#act_info{} };
get(47) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,16},{00,00,00}},end_time={{2018,04,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=47,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6602020,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,5,10},{2,2005000,10,10},{3,10106,25,10},{4,11601,1,10},{5,1009002,1,10},{6,1008000,3,50}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,30,15},{2,8001002,1,15},{3,2014001,1,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8001163,2,25},{3,8002517,1,40},{4,8001002,3,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,4,33},{2,8001057,3,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,2005000,20,50},{2,8001186,3,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6602020,1,100}] }],
        act_info=#act_info{} };
get(48) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,23},{00,00,00}},end_time={{2018,04,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=48,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3107010,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,5,10},{2,2005000,10,10},{3,10106,25,10},{4,11601,1,10},{5,1009002,1,10},{6,1008000,3,50}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,30,15},{2,8001002,1,15},{3,2014001,1,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8001163,2,25},{3,8002517,1,40},{4,8001002,3,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,4,33},{2,8001057,3,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,2005000,20,50},{2,8001186,3,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3107010,1,100}] }],
        act_info=#act_info{} };
get(49) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,30},{00,00,00}},end_time={{2018,04,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=49,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6633016,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,2003000,5,10},{2,2005000,10,10},{3,10106,25,10},{4,11601,1,10},{5,1009002,1,10},{6,1008000,3,50}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,30,15},{2,8001002,1,15},{3,2014001,1,15},{4,8001054,3,15},{5,8001186,1,40}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,5},{2,8001163,2,25},{3,8002517,1,40},{4,8001002,3,25}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001054,4,33},{2,8001057,3,33},{3,8001186,2,33}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,2005000,20,50},{2,8001186,3,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6633016,1,100}] }],
        act_info=#act_info{} };
get(200) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,07},{00,00,00}},end_time={{2018,05,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=200,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3312007,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,7415001,10,30},{2,8002404,1,10},{3,10106,40,10},{4,11120,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,60,15},{2,8002516,2,15},{3,7415001,5,15},{4,10199,30,5},{5,8001186,1,15}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,30},{2,10199,40,5},{3,8002405,1,30},{4,8002518,10,30}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001663,1,45},{2,10199,50,5},{3,8001186,2,45}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,10106,100,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3312007,1,100}] }],
        act_info=#act_info{} };
get(201) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,14},{00,00,00}},end_time={{2018,05,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=201,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6633020,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,7415001,10,30},{2,8002404,1,10},{3,10106,40,10},{4,11120,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,60,15},{2,8002516,2,15},{3,7415001,5,15},{4,10199,30,5},{5,8001186,1,15}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,30},{2,10199,40,5},{3,8002405,1,30},{4,8002518,10,30}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001663,1,45},{2,10199,50,5},{3,8001186,2,45}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,10106,100,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6633020,1,100}] }],
        act_info=#act_info{} };
get(202) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,21},{00,00,00}},end_time={{2018,05,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=202,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
3312010,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,7415001,10,30},{2,8002404,1,10},{3,10106,40,10},{4,11120,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,60,15},{2,8002516,2,15},{3,7415001,5,15},{4,10199,30,5},{5,8001186,1,15}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,30},{2,10199,40,5},{3,8002405,1,30},{4,8002518,10,30}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001663,1,45},{2,10199,50,5},{3,8001186,2,45}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,10106,100,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,3312010,1,100}] }],
        act_info=#act_info{} };
get(203) -> #base_gold_silver_tower{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,28},{00,00,00}},end_time={{2018,05,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=203,
        cost_one=25,
        cost_ten = 
250,
        cost_fifty = 
1250,
        fashion_id = 
6633016,
        reward_list = [
   #base_gold_silver_tower_goods{ floor=1,reset_id=6,lower=1,up = 3,goods_list = [{1,7415001,10,30},{2,8002404,1,10},{3,10106,40,10},{4,11120,5,10},{5,7405001,10,10},{6,8001054,2,30}] },
   #base_gold_silver_tower_goods{ floor=2,reset_id=5,lower=1,up = 4,goods_list = [{1,10106,60,15},{2,8002516,2,15},{3,7415001,5,15},{4,10199,30,5},{5,8001186,1,15}] },
   #base_gold_silver_tower_goods{ floor=3,reset_id=4,lower=3,up = 5,goods_list = [{1,8001058,1,30},{2,10199,40,5},{3,8002405,1,30},{4,8002518,10,30}] },
   #base_gold_silver_tower_goods{ floor=4,reset_id=3,lower=5,up = 10,goods_list = [{1,8001663,1,45},{2,10199,50,5},{3,8001186,2,45}] },
   #base_gold_silver_tower_goods{ floor=5,reset_id=2,lower=5,up = 6,goods_list = [{1,10106,100,50},{2,8001186,2,50}] },
   #base_gold_silver_tower_goods{ floor=6,reset_id=1,lower=0,up = 0,goods_list = [{1,6633016,1,100}] }],
        act_info=#act_info{} };
get(_) -> [].

get_all() -> [22,31,7,25,26,27,28,29,30,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,200,201,202,203].
