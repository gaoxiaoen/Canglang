%% 配置生成时间 2018-04-23 20:11:23
-module(data_cross_recharge_rank).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,09,25},{21,38,58}},end_time={{2017,09,25},{23,39,00}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,rank_info = [],act_info=#act_info{} };
get(8) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,01},{00,00,00}},end_time={{2017,10,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=8,rank_info = [
   #rank_info{ top=1,down=1,limit=6480,reward = {{8301104,1},{2014001,5},{8001002,20}}},
   #rank_info{ top=2,down=3,limit=3280,reward = {{8301104,1},{2014001,3},{8001002,10}}},
   #rank_info{ top=4,down=10,limit=1280,reward = {{8301104,1},{2014001,2}}},
   #rank_info{ top=11,down=50,limit=300,reward = {{8001002,5},{2003000,10}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,1},{2003000,5}}}],act_info=#act_info{} };
get(9) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,11},{00,00,00}},end_time={{2018,01,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=17},act_id=9,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3107003,10},{6604096,10},{8001002,20}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{5101448,1},{6604096,10},{8001002,15}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(10) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,13},{00,00,00}},end_time={{2018,01,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=10,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3107002,10},{11601,1},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{5101418,1},{8001054,20},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(11) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,20},{00,00,00}},end_time={{2018,01,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=11,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3307012,10},{11601,1},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{5101418,1},{8001054,20},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(12) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,24},{00,00,00}},end_time={{2018,01,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=12,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602023,10},{11601,1},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{5101408,1},{8001054,20},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(13) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,26},{00,00,00}},end_time={{2018,01,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=13,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3207005,10},{11601,1},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{5101408,1},{8001054,20},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(14) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,29},{00,00,00}},end_time={{2018,01,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=14,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3107004,10},{11601,1},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{5101408,1},{8001054,20},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,3},{2003000,3}}}],act_info=#act_info{} };
get(15) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,03},{00,00,00}},end_time={{2018,02,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=15,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602005,10},{11601,1},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(16) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,05},{00,00,00}},end_time={{2018,02,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=16,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602019,10},{11601,1},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,20},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,10},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,5},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(17) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,06},{00,00,00}},end_time={{2018,02,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=17,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3207003,10},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,25},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(18) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,08},{00,00,00}},end_time={{2018,02,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=18,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602006,10},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,25},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(19) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,10},{00,00,00}},end_time={{2018,02,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=19,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3207001,10},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,25},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(20) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,16},{00,00,00}},end_time={{2018,02,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=20,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3107007,10},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,25},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(21) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,18},{00,00,00}},end_time={{2018,02,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},act_id=21,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{6602012,10},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,25},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(22) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,05},{00,00,00}},end_time={{2018,03,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=22,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3107004,10},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,25},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(23) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,11},{00,00,00}},end_time={{2018,03,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=23,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3307014,10},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,25},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(24) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,19},{00,00,00}},end_time={{2018,03,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=24,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{3207006,10},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{8002408,1},{8001054,25},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8002407,1},{8001054,15},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8002406,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(26) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,25},{00,00,00}},end_time={{2018,03,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=26,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7401020,10},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7401019,1},{8001054,25},{8001002,20}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001652,1},{8001054,15},{8001002,10}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8001651,1},{8001054,10},{8001002,5}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(27) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,02},{00,00,00}},end_time={{2018,04,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=27,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7402021,1},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7402020,1},{8001054,25},{8001303,5}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001652,1},{8001054,15},{8001303,2}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8001651,1},{8001054,10},{8001303,1}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(28) -> #base_act_cross_recharge_rank{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,08},{00,00,00}},end_time={{2018,04,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=28,rank_info = [
   #rank_info{ top=1,down=1,limit=10000,reward = {{7404021,1},{11601,5},{8001303,10}}},
   #rank_info{ top=2,down=3,limit=5000,reward = {{7404020,1},{8001054,25},{8001303,5}}},
   #rank_info{ top=4,down=10,limit=1000,reward = {{8001652,1},{8001054,15},{8001303,2}}},
   #rank_info{ top=11,down=50,limit=500,reward = {{8001651,1},{8001054,10},{8001303,1}}},
   #rank_info{ top=51,down=999,limit=0,reward = {{8001002,5},{2003000,3}}}],act_info=#act_info{} };
get(_) -> [].

get_all() -> [1,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,26,27,28].
