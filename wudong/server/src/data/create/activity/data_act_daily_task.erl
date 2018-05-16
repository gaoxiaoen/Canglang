%% 配置生成时间 2018-05-14 17:01:51
-module(data_act_daily_task).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_daily_task{open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,award_list = [{1, 1, 5, [{5101421, 1}, {10101, 10000}]},{2, 1, 10, [{5101421, 1}, {10101, 10000}]},{3, 1, 30, [{5101421, 1}, {10101, 10000}]},{4, 1, 50, [{5101421, 1}, {10101, 10000}]},{5, 1, 100, [{5101421, 1}, {10101, 10000}]},{6, 2, 2, [{5101421, 1}, {10101, 10000}]},{7, 2, 5, [{5101421, 1}, {10101, 10000}]},{8, 2, 10, [{5101421, 1}, {10101, 10000}]},{9, 2, 15, [{5101421, 1}, {10101, 10000}]},{10, 2, 20, [{5101421, 1}, {10101, 10000}]}],act_info=#act_info{} };
get(2) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,09,30},{00,00,00}},end_time={{2017,10,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=2,award_list = [{1,1,20,[{1045002,1},{1045003,5},{8002401,1},{8001002,3},{8001304,1}]},{2,1,50,[{1045002,1},{1045003,10},{8002402,1},{8001002,5},{8001304,3}]},{3,1,120,[{1045002,1},{1045003,20},{8002403,1},{8001002,10},{8001304,5}]},{4,1,300,[{1045002,2},{1045003,30},{8002404,1},{8001002,20},{8001305,5}]},{5,1,500,[{1045002,2},{1045003,50},{8002405,1},{8001002,30},{8001305,8}]},{6,1,800,[{1045002,3},{1045003,90},{8002406,1},{8001002,50},{8001305,12}]}],act_info=#act_info{} };
get(3) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,29},{00,00,00}},end_time={{2017,10,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=3,award_list = [{1,1,20,[{1045004,1},{1045005,5},{8002401,1},{8002516,3},{8001306,1}]},{2,1,50,[{1045004,1},{1045005,10},{8002402,1},{8002516,5},{8001306,3}]},{3,1,120,[{1045004,1},{1045005,20},{8002403,1},{8002516,10},{8001306,5}]},{4,1,300,[{1045004,2},{1045005,30},{8002404,1},{8002516,20},{8001307,5}]},{5,1,500,[{1045004,2},{1045005,50},{8002405,1},{8002516,30},{8001307,8}]},{6,1,800,[{1045004,3},{1045005,90},{8002406,1},{8002516,50},{8001307,12}]}],act_info=#act_info{} };
get(4) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,31},{00,00,00}},end_time={{2017,11,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=4,award_list = [{1,3,20,[{1045004,1},{1045005,5},{8002401,1},{8002516,3},{8001306,1}]},{2,3,50,[{1045004,1},{1045005,10},{8002402,1},{8002516,5},{8001306,3}]},{3,3,120,[{1045004,1},{1045005,20},{8002403,1},{8002516,10},{8001306,5}]},{4,3,300,[{1045004,2},{1045005,30},{8002404,1},{8002516,20},{8001307,5}]},{5,3,500,[{1045004,2},{1045005,50},{8002405,1},{8002516,30},{8001307,8}]},{6,3,800,[{1045004,3},{1045005,90},{8002406,1},{8002516,50},{8001307,12}]}],act_info=#act_info{} };
get(5) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,10},{00,00,00}},end_time={{2017,11,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=5,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002401,1},{8002516,3},{8001304,1}]},{2,1,50,[{1045006,1},{1045007,10},{8002402,1},{8002516,5},{8001304,3}]},{3,1,120,[{1045006,1},{1045007,20},{8002403,1},{8002516,10},{8001304,5}]},{4,1,300,[{1045006,2},{1045007,30},{8002404,1},{8002516,20},{8001305,5}]},{5,1,500,[{1045006,2},{1045007,50},{8002405,1},{8002516,30},{8001305,8}]},{6,1,800,[{1045006,3},{1045007,90},{8002406,1},{8002516,50},{8001305,12}]}],act_info=#act_info{} };
get(6) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,12},{00,00,00}},end_time={{2017,11,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=6,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002401,1},{8002516,3},{8001304,1}]},{2,3,50,[{1045006,1},{1045007,10},{8002402,1},{8002516,5},{8001304,3}]},{3,3,120,[{1045006,1},{1045007,20},{8002403,1},{8002516,10},{8001304,5}]},{4,3,300,[{1045006,2},{1045007,30},{8002404,1},{8002516,20},{8001305,5}]},{5,3,500,[{1045006,2},{1045007,50},{8002405,1},{8002516,30},{8001305,8}]},{6,3,800,[{1045006,3},{1045007,90},{8002406,1},{8002516,50},{8001305,12}]}],act_info=#act_info{} };
get(7) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,23},{00,00,00}},end_time={{2017,11,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=7,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002401,1},{8002516,3},{8001304,1}]},{2,1,50,[{1045006,1},{1045007,10},{8002402,1},{8002516,5},{8001304,3}]},{3,1,120,[{1045006,1},{1045007,20},{8002403,1},{8002516,10},{8001304,5}]},{4,1,300,[{1045006,2},{1045007,30},{8002404,1},{8002516,20},{8001305,5}]},{5,1,500,[{1045006,2},{1045007,50},{8002405,1},{8002516,30},{8001305,8}]},{6,1,800,[{1045006,3},{1045007,90},{8002406,1},{8002516,50},{8001305,12}]}],act_info=#act_info{} };
get(8) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,25},{00,00,00}},end_time={{2017,11,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=8,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002401,1},{8002516,3},{8001304,1}]},{2,3,50,[{1045006,1},{1045007,10},{8002402,1},{8002516,5},{8001304,3}]},{3,3,120,[{1045006,1},{1045007,20},{8002403,1},{8002516,10},{8001304,5}]},{4,3,300,[{1045006,2},{1045007,30},{8002404,1},{8002516,20},{8001305,5}]},{5,3,500,[{1045006,2},{1045007,50},{8002405,1},{8002516,30},{8001305,8}]},{6,3,800,[{1045006,3},{1045007,90},{8002406,1},{8002516,50},{8001305,12}]}],act_info=#act_info{} };
get(9) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,11},{00,00,00}},end_time={{2017,12,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=9,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002401,1},{8002516,3},{8001304,1}]},{2,1,50,[{1045006,1},{1045007,10},{8002402,1},{8002516,5},{8001304,3}]},{3,1,120,[{1045006,1},{1045007,20},{8002403,1},{8002516,10},{8001304,5}]},{4,1,300,[{1045006,2},{1045007,30},{8002404,1},{8002516,20},{8001305,5}]},{5,1,500,[{1045006,2},{1045007,50},{8002405,1},{8002516,30},{8001305,8}]},{6,1,800,[{1045006,3},{1045007,90},{8002406,1},{8002516,50},{8001305,12}]}],act_info=#act_info{} };
get(10) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,13},{00,00,00}},end_time={{2017,12,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=10,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002401,1},{8002516,3},{8001304,1}]},{2,3,50,[{1045006,1},{1045007,10},{8002402,1},{8002516,5},{8001304,3}]},{3,3,120,[{1045006,1},{1045007,20},{8002403,1},{8002516,10},{8001304,5}]},{4,3,300,[{1045006,2},{1045007,30},{8002404,1},{8002516,20},{8001305,5}]},{5,3,500,[{1045006,2},{1045007,50},{8002405,1},{8002516,30},{8001305,8}]},{6,3,800,[{1045006,3},{1045007,90},{8002406,1},{8002516,50},{8001305,12}]}],act_info=#act_info{} };
get(11) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,23},{00,00,00}},end_time={{2017,12,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=11,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002401,1},{8002516,3},{8001304,1}]},{2,1,50,[{1045006,1},{1045007,10},{8002402,1},{8002516,5},{8001304,3}]},{3,1,120,[{1045006,1},{1045007,20},{8002403,1},{8002516,10},{8001304,5}]},{4,1,300,[{1045006,2},{1045007,30},{8002404,1},{8002516,20},{8001305,5}]},{5,1,500,[{1045006,2},{1045007,50},{8002405,1},{8002516,30},{8001305,8}]},{6,1,800,[{1045006,3},{1045007,90},{8002406,1},{8002516,50},{8001305,12}]}],act_info=#act_info{} };
get(12) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,25},{00,00,00}},end_time={{2017,12,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},act_id=12,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002401,1},{8002516,3},{8001304,1}]},{2,3,50,[{1045006,1},{1045007,10},{8002402,1},{8002516,5},{8001304,3}]},{3,3,120,[{1045006,1},{1045007,20},{8002403,1},{8002516,10},{8001304,5}]},{4,3,300,[{1045006,2},{1045007,30},{8002404,1},{8002516,20},{8001305,5}]},{5,3,500,[{1045006,2},{1045007,50},{8002405,1},{8002516,30},{8001305,8}]},{6,3,800,[{1045006,3},{1045007,90},{8002406,1},{8002516,50},{8001305,12}]}],act_info=#act_info{} };
get(13) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,17},{00,00,00}},end_time={{2018,01,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=13,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,1,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,1,120,[{1045006,1},{1045007,20},{8002404,2},{8001002,10},{8001304,5}]},{4,1,300,[{1045006,2},{1045007,30},{8002405,1},{8001002,20},{8001305,5}]},{5,1,500,[{1045006,2},{1045007,50},{8002405,2},{8001002,30},{8001305,8}]},{6,1,800,[{1045006,3},{1045007,90},{8002406,1},{8001002,50},{8001305,12}]}],act_info=#act_info{} };
get(14) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,18},{00,00,00}},end_time={{2018,01,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=14,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,3,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,3,120,[{1045006,1},{1045007,20},{8002404,2},{8001002,10},{8001304,5}]},{4,3,300,[{1045006,2},{1045007,30},{8002405,1},{8001002,20},{8001305,5}]},{5,3,500,[{1045006,2},{1045007,50},{8002405,2},{8001002,30},{8001305,8}]},{6,3,800,[{1045006,3},{1045007,90},{8002406,1},{8001002,50},{8001305,12}]}],act_info=#act_info{} };
get(17) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,12},{00,00,00}},end_time={{2018,02,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=17,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,3,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,3,120,[{1045006,1},{1045007,20},{8002404,2},{8001002,10},{8001304,5}]},{4,3,300,[{1045006,2},{1045007,30},{8002405,1},{8001002,20},{8001305,5}]},{5,3,500,[{1045006,2},{1045007,50},{8002405,2},{8001002,30},{8001305,8}]},{6,3,800,[{1045006,3},{1045007,90},{8002406,1},{8001002,50},{8001305,12}]}],act_info=#act_info{} };
get(18) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,13},{00,00,00}},end_time={{2018,02,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=18,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,1,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,1,120,[{1045006,1},{1045007,20},{8002404,2},{8001002,10},{8001304,5}]},{4,1,300,[{1045006,2},{1045007,30},{8002405,1},{8001002,20},{8001305,5}]},{5,1,500,[{1045006,2},{1045007,50},{8002405,2},{8001002,30},{8001305,8}]},{6,1,800,[{1045006,3},{1045007,90},{8002406,1},{8001002,50},{8001305,12}]}],act_info=#act_info{} };
get(15) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,15},{00,00,00}},end_time={{2018,02,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=15,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,3,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,3,120,[{1045006,1},{1045007,20},{8002404,2},{8001002,10},{8001304,5}]},{4,3,300,[{1045006,2},{1045007,30},{8002405,1},{8001002,20},{8001305,5}]},{5,3,500,[{1045006,2},{1045007,50},{8002405,2},{8001002,30},{8001305,8}]},{6,3,800,[{1045006,3},{1045007,90},{8002406,1},{8001002,50},{8001305,12}]}],act_info=#act_info{} };
get(16) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,16},{00,00,00}},end_time={{2018,02,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=16,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,1,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,1,120,[{1045006,1},{1045007,20},{8002404,2},{8001002,10},{8001304,5}]},{4,1,300,[{1045006,2},{1045007,30},{8002405,1},{8001002,20},{8001305,5}]},{5,1,500,[{1045006,2},{1045007,50},{8002405,2},{8001002,30},{8001305,8}]},{6,1,800,[{1045006,3},{1045007,90},{8002406,1},{8001002,50},{8001305,12}]}],act_info=#act_info{} };
get(19) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,03},{00,00,00}},end_time={{2018,03,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=19,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,1,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,1,120,[{1045006,1},{1045007,20},{8002404,2},{8001002,10},{8001304,5}]},{4,1,300,[{1045006,2},{1045007,30},{8002405,1},{8001002,20},{8001305,5}]},{5,1,500,[{1045006,2},{1045007,50},{8002405,2},{8001002,30},{8001305,8}]},{6,1,800,[{1045006,3},{1045007,90},{8002406,1},{8001002,50},{8001305,12}]}],act_info=#act_info{} };
get(20) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,31},{00,00,00}},end_time={{2018,04,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=20,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,3,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,3,120,[{1045006,1},{1045007,20},{8002404,2},{8001002,10},{8001304,5}]},{4,3,300,[{1045006,2},{1045007,30},{8002405,1},{8001002,20},{8001305,5}]},{5,3,500,[{1045006,2},{1045007,50},{8002405,2},{8001002,30},{8001305,8}]},{6,3,800,[{1045006,3},{1045007,90},{8002406,1},{8001002,50},{8001305,12}]}],act_info=#act_info{} };
get(21) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,02},{00,00,00}},end_time={{2018,04,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=21,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,1,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,1,120,[{1045006,1},{1045007,20},{8002404,2},{8001002,10},{8001304,5}]},{4,1,300,[{1045006,2},{1045007,30},{8002405,1},{8001002,20},{8001305,5}]},{5,1,500,[{1045006,2},{1045007,50},{8002405,2},{8001002,30},{8001305,8}]},{6,1,800,[{1045006,3},{1045007,90},{8002406,1},{8001002,50},{8001305,12}]}],act_info=#act_info{} };
get(30) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,29},{00,00,00}},end_time={{2018,04,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=30,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,1,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,1,120,[{1045006,1},{1045007,20},{8002404,2},{40001,10},{8001304,5}]},{4,1,300,[{1045006,2},{1045007,30},{8002407,1},{40001,20},{8001305,5}]},{5,1,500,[{1045006,2},{1045007,50},{8002408,1},{40001,30},{8001305,8}]},{6,1,800,[{1045006,3},{1045007,90},{8002409,1},{40001,50},{8001305,12}]}],act_info=#act_info{} };
get(31) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,01},{00,00,00}},end_time={{2018,05,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=31,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002403,1}]},{2,3,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]},{3,3,120,[{1045006,1},{1045007,20},{8002404,2},{40001,10},{8001304,5}]},{4,3,300,[{1045006,2},{1045007,30},{8002407,1},{40001,20},{8001305,5}]},{5,3,500,[{1045006,2},{1045007,50},{8002408,1},{40001,30},{8001305,8}]},{6,3,800,[{1045006,3},{1045007,90},{8002409,1},{40001,50},{8001305,12}]}],act_info=#act_info{} };
get(33) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,13},{00,00,00}},end_time={{2018,05,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=33,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002403,1}]			},{2,3,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]			},{3,3,120,[{1045006,1},{1045007,20},{8002404,2},{40001,10},{8001304,5}]			},{4,3,300,[{1045006,2},{1045007,30},{40012,10},{40001,20},{8001305,5}]			},{5,3,500,[{1045006,2},{1045007,50},{40002,10},{40001,30},{8001305,8}]			},{6,3,800,[{1045006,3},{1045007,90},{40032,10},{40001,50},{8001305,12}]}],act_info=#act_info{} };
get(32) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,12},{00,00,00}},end_time={{2018,05,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=32,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002403,1}]		},{2,1,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]		},{3,1,120,[{1045006,1},{1045007,20},{8002404,2},{40001,10},{8001304,5}]		},{4,1,300,[{1045006,2},{1045007,30},{40013,10},{40001,20},{8001305,5}]		},{5,1,500,[{1045006,2},{1045007,50},{40002,10},{40001,30},{8001305,8}]		},{6,1,800,[{1045006,3},{1045007,90},{40033,10},{40001,50},{8001305,12}]}],act_info=#act_info{} };
get(34) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,14},{00,00,00}},end_time={{2018,05,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=34,award_list = [{1,1,20,[{1045006,1},{1045007,5},{8002403,1}]			},{2,1,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]			},{3,1,120,[{1045006,1},{1045007,20},{8002404,2},{40001,10},{8001304,5}]			},{4,1,300,[{1045006,2},{1045007,30},{40013,10},{40001,20},{8001305,5}]			},{5,1,500,[{1045006,2},{1045007,50},{40002,10},{40001,30},{8001305,8}]			},{6,1,800,[{1045006,3},{1045007,90},{40033,10},{40001,50},{8001305,12}]}],act_info=#act_info{} };
get(35) -> #base_daily_task{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,15},{00,00,00}},end_time={{2018,05,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=35,award_list = [{1,3,20,[{1045006,1},{1045007,5},{8002403,1}]			},{2,3,50,[{1045006,1},{1045007,10},{8002404,1},{8001304,3}]			},{3,3,120,[{1045006,1},{1045007,20},{8002404,2},{40001,10},{8001304,5}]			},{4,3,300,[{1045006,2},{1045007,30},{40012,10},{40001,20},{8001305,5}]			},{5,3,500,[{1045006,2},{1045007,50},{40002,10},{40001,30},{8001305,8}]			},{6,3,800,[{1045006,3},{1045007,90},{40032,10},{40001,50},{8001305,12}]}],act_info=#act_info{} };
get(_) -> [].

get_all() -> [1,2,3,4,5,6,7,8,9,10,11,12,13,14,17,18,15,16,19,20,21,30,31,33,32,34,35].