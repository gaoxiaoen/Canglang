%% 配置生成时间 2018-05-14 17:02:54
-module(data_act_wishing_well).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_act_wishing_well{open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,27},{00,00,00}},end_time={{2018,02,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,
        coin_draw=#base_act_wishing_well_gold{ one_cost = 1,one_score = 10,
		reward_list = [
             {0,5,[{6601021,1,0,0},{6603086,1,0,0},{6607007,1,0,0},{8002408,1,500,0},{11601,2,1000,0},{2014001,10,1500,0},{8001058,5,1500,0},{7321002,5,1500,0},{8001054,15,2000,0},{8001002,15,2000,0}]},
             {6,7,[{6601021,1,0,0},{6603086,1,0,0},{6607007,1,250,0},{8002408,1,750,0},{11601,2,2000,0},{2014001,10,2000,0},{8001058,5,0,0},{7321002,5,0,0},{8001054,15,0,0},{8001002,15,0,0}]},
             {8,15,[{6601021,1,0,0},{6603086,1,250,0},{6607007,1,250,0},{8002408,1,500,0},{11601,2,1000,0},{2014001,10,1500,0},{8001058,5,1500,0},{7321002,5,1500,0},{8001054,15,1750,0},{8001002,15,1750,0}]},
             {16,17,[{6601021,1,0,0},{6603086,1,250,0},{6607007,1,250,0},{8002408,1,500,0},{11601,2,2000,0},{2014001,10,2000,0},{8001058,5,0,0},{7321002,5,0,0},{8001054,15,0,0},{8001002,15,0,0}]},
             {18,25,[{6601021,1,0,0},{6603086,1,250,0},{6607007,1,250,0},{8002408,1,750,0},{11601,2,1250,0},{2014001,10,1500,0},{8001058,5,1500,0},{7321002,5,1500,0},{8001054,15,1500,0},{8001002,15,1500,0}]},
             {26,27,[{6601021,1,250,0},{6603086,1,250,0},{6607007,1,250,0},{8002408,1,750,0},{11601,2,1500,0},{2014001,10,2000,0},{8001058,5,0,0},{7321002,5,0,0},{8001054,15,0,0},{8001002,15,0,0}]},
             {28,999,[{6601021,1,250,0},{6603086,1,250,0},{6607007,1,250,0},{8002408,1,750,0},{11601,2,1500,0},{2014001,10,1500,0},{8001058,5,1500,0},{7321002,5,1500,0},{8001054,15,1500,0},{8001002,15,1000,0}]}]
		},
        gold_draw =#base_act_wishing_well_gold{one_cost=30, one_score=1,ten_score = 10,
		reward_list = [
             {0,20,[{2603003,3,2500,1},{2601003,3,2500,0},{2608003,3,2500,0},{2602003,3,2500,0},{2603003,6,800,0},{2601003,6,800,0},{2608003,6,800,0},{2602003,6,800,0},{2014001,2,250,0},{11601,1,250,0}]},
             {21,60,[{2603003,3,2500,1},{2601003,3,2500,0},{2608003,3,2500,0},{2602003,3,2500,0},{2603003,6,800,0},{2601003,6,800,0},{2608003,6,800,0},{2602003,6,800,0},{2014001,2,250,0},{11601,1,250,0}]},
             {61,999,[{2603003,3,2500,1},{2601003,3,2500,0},{2608003,3,2500,0},{2602003,3,2500,0},{2603003,6,800,0},{2601003,6,800,0},{2608003,6,800,0},{2602003,6,800,0},{2014001,2,250,0},{11601,1,250,0}]}]
		},
		rank_list = [
             {1,1,[{6604096,10},{8001054,30},{8001663,15}]},
             {2,3,[{11601,1},{8001054,20},{8001663,10}]},
             {4,10,[{8002516,10},{8001054,10},{8001663,5}]},
             {11,50,[{20340,10},{8001663,5}]},
             {51,999,[{20340,5},{8001663,3}]}],
		next_list = [{4,300},{14,900},{24,1200},{9999,2000}],
        act_info=#act_info{} };
get(_) -> [].

get_all() -> [1].
