%% 配置生成时间 2018-05-14 17:01:45
-module(data_online_reward).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_online_reward{open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,
        time_list=[5,10,15,20,30,35,40,45,50,55,60],
        reward = [{1, 7303001, 1, 1}, {2, 7303002, 1, 1}, {3, 7303003, 1, 1}, {4, 7303004, 1, 1}, {5, 7303005, 1, 1},{6, 12008, 1, 1}, {7, 12036, 1, 1}, {8, 12103, 1, 1}, {9, 21003, 1, 1}, {10, 1015001, 1, 1},{11, 1016002, 1, 1}, {12, 1025001, 1, 1}, {13, 3104000, 1, 1}, {14, 3206000, 1, 1}, {15, 2003000, 20, 1},{16,2001000, 10, 1}],
        act_info=#act_info{} };
get(2) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,09,30},{00,00,00}},end_time={{2017,10,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=2,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045003,2,0},{2,10106,10,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045003,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,5101402,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045003,2,11},{13,2011000,1,12},{14,2012000,1,13},{15,2013000,1,14},{16,1045002,1,15}],
        act_info=#act_info{} };
get(3) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,29},{00,00,00}},end_time={{2017,11,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=3,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045005,2,0},{2,8001308,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045005,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047001,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045005,2,11},{13,2011000,1,12},{14,2012000,1,13},{15,2013000,1,14},{16,1045004,1,15}],
        act_info=#act_info{} };
get(4) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,10},{00,00,00}},end_time={{2017,11,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=4,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045007,2,0},{2,8001309,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045007,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047002,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045007,2,11},{13,2011000,1,12},{14,2012000,1,13},{15,2013000,1,14},{16,1045006,1,15}],
        act_info=#act_info{} };
get(5) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,23},{00,00,00}},end_time={{2017,11,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=5,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045007,2,0},{2,8001309,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045007,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047002,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045007,2,11},{13,2011000,1,12},{14,2012000,1,13},{15,2013000,1,14},{16,1045006,1,15}],
        act_info=#act_info{} };
get(6) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,11},{00,00,00}},end_time={{2017,12,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=6,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045007,2,0},{2,8001309,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045007,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047002,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045007,2,11},{13,2011000,1,12},{14,2012000,1,13},{15,2013000,1,14},{16,1045006,1,15}],
        act_info=#act_info{} };
get(7) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,23},{00,00,00}},end_time={{2017,12,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=7,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045007,2,0},{2,8001309,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045007,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047002,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045007,2,11},{13,2011000,1,12},{14,2012000,1,13},{15,2013000,1,14},{16,1045006,1,15}],
        act_info=#act_info{} };
get(8) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,17},{00,00,00}},end_time={{2018,01,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=8,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045007,2,0},{2,8001309,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045007,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047002,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045007,2,11},{13,2011000,1,12},{14,2012000,1,13},{15,2013000,1,14},{16,1045006,1,15}],
        act_info=#act_info{} };
get(9) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,12},{00,00,00}},end_time={{2018,02,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=9,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045007,2,0},{2,8001309,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045007,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047002,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045007,2,11},{13,2011000,1,12},{14,2012000,1,13},{15,2013000,1,14},{16,1045006,1,15}],
        act_info=#act_info{} };
get(10) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,03},{00,00,00}},end_time={{2018,03,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=10,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045007,2,0},{2,8001309,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045007,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047002,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045007,2,11},{13,2011000,1,12},{14,2012000,1,13},{15,2013000,1,14},{16,1045006,1,15}],
        act_info=#act_info{} };
get(11) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,31},{00,00,00}},end_time={{2018,04,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=11,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045007,2,0},{2,8001309,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045007,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047002,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045007,2,11},{13,2011000,1,12},{14,2012000,1,13},{15,2013000,1,14},{16,1045006,1,15}],
        act_info=#act_info{} };
get(30) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,29},{00,00,00}},end_time={{2018,05,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=30,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045007,2,0},{2,8001309,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045007,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047002,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045007,2,11},{13,40001,1,12},{14,40021,1,13},{15,40022,1,14},{16,1045006,1,15}],
        act_info=#act_info{} };
get(31) -> #base_online_reward{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,12},{00,00,00}},end_time={{2018,05,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=31,
        time_list=[3,10,20,30,60,90,120,150,180,210,240],
        reward = [{1,1045007,2,0},{2,8001309,3,1},{3,1046001,2,2},{4,5101402,1,3},{5,1045007,2,4},{6,5101422,2,5},{7,1046001,2,6},{8,1047002,1,7},{9,5101412,1,8},{10,1046001,2,9},{11,10106,10,10},{12,1045007,2,11},{13,40001,1,12},{14,40023,1,13},{15,40022,1,14},{16,1045006,1,15}],
        act_info=#act_info{} };
get(_) -> [].

get_all() -> [1,2,3,4,5,6,7,8,9,10,11,30,31].
