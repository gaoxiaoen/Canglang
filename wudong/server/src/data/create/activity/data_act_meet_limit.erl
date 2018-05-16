%% 配置生成时间 2018-05-14 17:03:03
-module(data_act_meet_limit).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(2) -> #base_act_meet_limit{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=1,end_day=2,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=2,c_act_list = [
   #base_child_act_meet_limit{ type=1,id=1,limit_timer=7200,open_limit = [{lv,58}],online_time = 2700,kill_mon = 200,gold = 100,title = ?T("新手奇遇"),goods_list = [{3101000,10},{1016003,1},{1401004,1},{2003000,30}]}],act_info=#act_info{} };
get(1) -> #base_act_meet_limit{open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,27},{15,36,05}},end_time={{2018,04,28},{15,36,08}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,c_act_list = [
   #base_child_act_meet_limit{ type=1,id=1,limit_timer=7200,open_limit = [{lv,35}],online_time = 300,kill_mon = 50,gold = 100,title = ?T("奇遇礼包"),goods_list = [{3421063,1},{3321063,1},{3321063,1},{3321063,1}]},
   #base_child_act_meet_limit{ type=1,id=2,limit_timer=7200,open_limit = [{lv,61}],online_time = 300,kill_mon = 50,gold = 380,title = ?T("二度奇遇"),goods_list = [{4105026,1},{3321063,1},{3321063,1},{3321063,1}]},
   #base_child_act_meet_limit{ type=1,id=3,limit_timer=3600,open_limit = [{lv,70},{vip,5}],online_time = 300,kill_mon = 50,gold = 880,title = ?T("奇遇礼包"),goods_list = [{3421063,1},{3321063,1},{3321063,1},{3321063,1}]},
   #base_child_act_meet_limit{ type=2,id=1,limit_timer=7200,open_limit = [{vip,3},{open,[2]}],online_time = 300,kill_mon = 50,gold = 688,title = ?T("特权奇遇·一"),goods_list = [{3421063,1},{3321063,1},{3321063,1},{3321063,1}]},
   #base_child_act_meet_limit{ type=2,id=2,limit_timer=7200,open_limit = [{vip,4},{open,[3]}],online_time = 300,kill_mon = 50,gold = 1688,title = ?T("特权奇遇·二"),goods_list = [{3421063,1},{3321063,1},{3321063,1},{3321063,1}]},
   #base_child_act_meet_limit{ type=2,id=3,limit_timer=3600,open_limit = [{vip,5},{open,[4]}],online_time = 300,kill_mon = 50,gold = 4880,title = ?T("特权奇遇·三"),goods_list = [{3421063,1},{3321063,1},{3321063,1},{3321063,1}]},
   #base_child_act_meet_limit{ type=3,id=1,limit_timer=7200,open_limit = [{vip,2},{merge,[1]}],online_time = 300,kill_mon = 50,gold = 100,title = ?T("合服奇遇·一"),goods_list = [{3421063,1},{3321063,1},{3321063,1},{3321063,1}]},
   #base_child_act_meet_limit{ type=3,id=2,limit_timer=7200,open_limit = [{vip,4},{merge,[2]}],online_time = 300,kill_mon = 50,gold = 100,title = ?T("合服奇遇·二"),goods_list = [{3421063,1},{3321063,1},{3321063,1},{3321063,1}]},
   #base_child_act_meet_limit{ type=3,id=3,limit_timer=3600,open_limit = [{vip,5},{merge,[3]}],online_time = 300,kill_mon = 50,gold = 100,title = ?T("合服奇遇·三"),goods_list = [{3421063,1},{3321063,1},{3321063,1},{3321063,1}]}],act_info=#act_info{} };
get(30) -> #base_act_meet_limit{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=3,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=30,c_act_list = [
   #base_child_act_meet_limit{ type=1,id=1,limit_timer=21600,open_limit = [{lv,50}],online_time = 60,kill_mon = 50,gold = 1800,title = ?T("奇遇礼包"),goods_list = [{3101000,50},{3201000,50},{3301000,50},{3401000,50}]},
   #base_child_act_meet_limit{ type=1,id=2,limit_timer=21600,open_limit = [{lv,60}],online_time = 60,kill_mon = 50,gold = 1800,title = ?T("奇遇礼包"),goods_list = [{1016003,5},{1016004,5},{1016005,5},{6601018,1}]},
   #base_child_act_meet_limit{ type=1,id=3,limit_timer=21600,open_limit = [{lv,75}],online_time = 60,kill_mon = 50,gold = 3600,title = ?T("奇遇礼包"),goods_list = [{2003000,100},{8002516,100},{10101,500000},{10106,1800}]},
   #base_child_act_meet_limit{ type=1,id=4,limit_timer=21600,open_limit = [{lv,90}],online_time = 60,kill_mon = 50,gold = 3600,title = ?T("奇遇礼包"),goods_list = [{8001303,50},{8001054,50},{8002406,2},{10106,1800}]},
   #base_child_act_meet_limit{ type=1,id=5,limit_timer=21600,open_limit = [{lv,105}],online_time = 60,kill_mon = 50,gold = 3600,title = ?T("奇遇礼包"),goods_list = [{2014001,20},{11601,10},{2005000,500},{10106,1800}]},
   #base_child_act_meet_limit{ type=1,id=6,limit_timer=21600,open_limit = [{lv,120}],online_time = 60,kill_mon = 50,gold = 3600,title = ?T("奇遇礼包"),goods_list = [{7501100,50},{7500002,15},{7500101,1},{10106,1800}]},
   #base_child_act_meet_limit{ type=1,id=7,limit_timer=21600,open_limit = [{lv,135}],online_time = 60,kill_mon = 50,gold = 3600,title = ?T("奇遇礼包"),goods_list = [{1016003,10},{1016004,10},{1016005,10},{6601018,1}]},
   #base_child_act_meet_limit{ type=1,id=8,limit_timer=21600,open_limit = [{lv,151}],online_time = 60,kill_mon = 50,gold = 6600,title = ?T("奇遇礼包"),goods_list = [{10199,6600},{11117,500000},{8002408,1},{10106,3300}]},
   #base_child_act_meet_limit{ type=1,id=9,limit_timer=21600,open_limit = [{lv,156}],online_time = 60,kill_mon = 50,gold = 6600,title = ?T("奇遇礼包"),goods_list = [{8301104,1},{11117,500000},{8002408,1},{10106,3300}]},
   #base_child_act_meet_limit{ type=1,id=10,limit_timer=21600,open_limit = [{lv,161}],online_time = 60,kill_mon = 50,gold = 6600,title = ?T("奇遇礼包"),goods_list = [{8002409,1},{11117,500000},{8002408,1},{10106,3300}]},
   #base_child_act_meet_limit{ type=1,id=11,limit_timer=21600,open_limit = [{lv,166}],online_time = 60,kill_mon = 50,gold = 6600,title = ?T("奇遇礼包"),goods_list = [{10199,6600},{11117,500000},{8002408,1},{10106,3300}]},
   #base_child_act_meet_limit{ type=1,id=12,limit_timer=21600,open_limit = [{lv,171}],online_time = 60,kill_mon = 50,gold = 6600,title = ?T("奇遇礼包"),goods_list = [{8301104,1},{11117,500000},{8002408,1},{10106,3300}]},
   #base_child_act_meet_limit{ type=3,id=1,limit_timer=21600,open_limit = [{merge,[1]}],online_time = 60,kill_mon = 50,gold = 5800,title = ?T("奇遇礼包"),goods_list = [{3101000,200},{3201000,200},{8002501,3},{8002502,3}]},
   #base_child_act_meet_limit{ type=3,id=2,limit_timer=21600,open_limit = [{merge,[2]}],online_time = 60,kill_mon = 50,gold = 5800,title = ?T("奇遇礼包"),goods_list = [{3201000,200},{3401000,200},{3202000,5},{8002503,3}]},
   #base_child_act_meet_limit{ type=3,id=3,limit_timer=21600,open_limit = [{merge,[3]}],online_time = 60,kill_mon = 50,gold = 5800,title = ?T("奇遇礼包"),goods_list = [{3401000,200},{3501000,200},{3402000,5},{8002504,3}]},
   #base_child_act_meet_limit{ type=3,id=4,limit_timer=21600,open_limit = [{merge,[4]}],online_time = 60,kill_mon = 50,gold = 5800,title = ?T("奇遇礼包"),goods_list = [{3501000,200},{3301000,200},{3502000,5},{8002505,3}]},
   #base_child_act_meet_limit{ type=3,id=5,limit_timer=21600,open_limit = [{merge,[5]}],online_time = 60,kill_mon = 50,gold = 5800,title = ?T("奇遇礼包"),goods_list = [{3301000,200},{3601000,200},{3302000,5},{8002506,3}]},
   #base_child_act_meet_limit{ type=3,id=6,limit_timer=21600,open_limit = [{merge,[6]}],online_time = 60,kill_mon = 50,gold = 5800,title = ?T("奇遇礼包"),goods_list = [{3601000,200},{3701000,200},{3602000,5},{8002507,3}]},
   #base_child_act_meet_limit{ type=3,id=7,limit_timer=21600,open_limit = [{merge,[7]}],online_time = 60,kill_mon = 50,gold = 5800,title = ?T("奇遇礼包"),goods_list = [{3701000,200},{3801000,200},{3702000,5},{8001208,60}]}],act_info=#act_info{} };
get(_) -> [].

get_all() -> [2,1,30].
