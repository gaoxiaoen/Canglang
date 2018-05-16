%% 配置生成时间 2018-04-23 20:11:23
-module(data_flower_rank).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(3) -> #base_act_flower_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000}],gs_id=[],open_day=3,end_day=5,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=3,
        give_list=[
   #base_flower_rank{ id=1,must=100,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=250,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=500,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=800,award=[{8001058,1}] }],
        get_list = [
   #base_flower_rank{ id=1,must=200,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=500,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=1000,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=1600,award=[{8001058,1}] }],
        give_rank_info = [
   #rank_info{ top=1,down=1,reward = {{6603040,1},{6605001,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605001,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605001,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        get_rank_info = [
   #rank_info{ top=1,down=1,reward = {{6603041,1},{6605001,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605001,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605001,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        act_info=#act_info{} };
get(9) -> #base_act_flower_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=7},act_id=9,
        give_list=[
   #base_flower_rank{ id=1,must=30,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=60,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=120,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=200,award=[{8001058,1}] }],
        get_list = [
   #base_flower_rank{ id=1,must=60,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=120,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=240,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=400,award=[{8001058,1}] }],
        give_rank_info = [],
        get_rank_info = [],
        act_info=#act_info{} };
get(16) -> #base_act_flower_rank{open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=8,end_day=9,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=16,
        give_list=[
   #base_flower_rank{ id=1,must=30,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=100,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=120,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=150,award=[{8001058,1}] }],
        get_list = [
   #base_flower_rank{ id=1,must=50,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=200,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=300,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=500,award=[{8001058,1}] }],
        give_rank_info = [
   #rank_info{ top=1,down=1,reward = {{3307002,10},{6605004,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605004,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605004,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        get_rank_info = [
   #rank_info{ top=1,down=1,reward = {{3307002,10},{6605004,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605004,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605004,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        act_info=#act_info{} };
get(17) -> #base_act_flower_rank{open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=12,end_day=13,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=17,
        give_list=[
   #base_flower_rank{ id=1,must=30,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=100,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=120,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=150,award=[{8001058,1}] }],
        get_list = [
   #base_flower_rank{ id=1,must=50,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=200,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=300,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=500,award=[{8001058,1}] }],
        give_rank_info = [
   #rank_info{ top=1,down=1,reward = {{3307003,10},{6605005,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605005,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605005,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        get_rank_info = [
   #rank_info{ top=1,down=1,reward = {{3307003,10},{6605005,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605005,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605005,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        act_info=#act_info{} };
get(15) -> #base_act_flower_rank{open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{50001,60000}],gs_id=[20086],open_day=0,end_day=0,start_time={{2017,09,05},{00,00,00}},end_time={{2017,09,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},act_id=15,
        give_list=[
   #base_flower_rank{ id=1,must=30,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=100,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=120,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=150,award=[{8001058,1}] }],
        get_list = [
   #base_flower_rank{ id=1,must=50,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=200,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=300,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=500,award=[{8001058,1}] }],
        give_rank_info = [
   #rank_info{ top=1,down=1,reward = {{6603040,1},{6605005,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605005,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605005,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        get_rank_info = [
   #rank_info{ top=1,down=1,reward = {{6603041,1},{6605005,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605005,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605005,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        act_info=#act_info{} };
get(10) -> #base_act_flower_rank{open_info=#open_info{gp_id = [{8001,8500},{1001,1500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,10},{11,43,04}},end_time={{2017,10,10},{11,50,06}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=10,
        give_list=[
   #base_flower_rank{ id=1,must=30,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=60,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=120,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=200,award=[{8001058,1}] }],
        get_list = [
   #base_flower_rank{ id=1,must=60,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=120,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=240,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=400,award=[{8001058,1}] }],
        give_rank_info = [],
        get_rank_info = [],
        act_info=#act_info{} };
get(11) -> #base_act_flower_rank{open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,11},{15,46,21}},end_time={{2017,10,11},{15,50,23}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=11,
        give_list=[
   #base_flower_rank{ id=1,must=30,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=60,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=120,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=200,award=[{8001058,1}] }],
        get_list = [
   #base_flower_rank{ id=1,must=60,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=120,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=240,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=400,award=[{8001058,1}] }],
        give_rank_info = [],
        get_rank_info = [],
        act_info=#act_info{} };
get(13) -> #base_act_flower_rank{open_info=#open_info{gp_id = [{30001,50000},{1501,2000},{2501,3000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,16},{11,44,13}},end_time={{2017,10,16},{11,50,15}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},act_id=13,
        give_list=[
   #base_flower_rank{ id=1,must=30,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=100,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=120,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=150,award=[{8001058,1}] }],
        get_list = [
   #base_flower_rank{ id=1,must=50,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=200,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=300,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=500,award=[{8001058,1}] }],
        give_rank_info = [
   #rank_info{ top=1,down=1,reward = {{6603040,1},{6605005,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605005,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605005,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        get_rank_info = [
   #rank_info{ top=1,down=1,reward = {{6603041,1},{6605005,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605005,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605005,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        act_info=#act_info{} };
get(14) -> #base_act_flower_rank{open_info=#open_info{gp_id = [{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{50001,60000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,13},{20,55,21}},end_time={{2017,12,13},{21,10,23}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},act_id=14,
        give_list=[
   #base_flower_rank{ id=1,must=30,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=100,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=120,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=150,award=[{8001058,1}] }],
        get_list = [
   #base_flower_rank{ id=1,must=50,award=[{1025001,3},{2003000,5}] },
   #base_flower_rank{ id=2,must=200,award=[{2001000,5},{8001055,3}] },
   #base_flower_rank{ id=3,must=300,award=[{8001163,3},{8001056,5}] },
   #base_flower_rank{ id=4,must=500,award=[{8001058,1}] }],
        give_rank_info = [
   #rank_info{ top=1,down=1,reward = {{6603040,1},{6605001,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605001,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605001,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        get_rank_info = [
   #rank_info{ top=1,down=1,reward = {{6603041,1},{6605001,1},{20340,30},{1010005,30}}},
   #rank_info{ top=2,down=2,reward = {{6605001,1},{20340,25},{1010005,25}}},
   #rank_info{ top=3,down=3,reward = {{6605001,1},{20340,20},{1010005,20}}},
   #rank_info{ top=4,down=10,reward = {{5101403,1},{20340,15},{1010005,15}}},
   #rank_info{ top=11,down=20,reward = {{5101423,1},{20340,10},{1010005,10}}},
   #rank_info{ top=21,down=50,reward = {{5101413,1},{20340,8},{1010005,8}}},
   #rank_info{ top=51,down=100,reward = {{5101402,1},{20340,5},{1010005,5}}}],
        act_info=#act_info{} };
get(_) -> [].

get_all() -> [3,9,16,17,15,10,11,13,14].
