%% 配置生成时间 2018-05-03 17:55:21
-module(data_new_free_gift).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_act_new_free_gift{open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,02},{00,00,00}},end_time={{2018,05,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,
        gift_list = [
   #base_act_new_free_gift_help{ type=1,cost=100,delay_day=7,reward = [{7501101,1},{3321063,1},{3521063,1},{5101402,2},{5101412,2},{5101422,2}],re_reward = [{10106, 1388}],desc = ?T("绝世仙姬") },
   #base_act_new_free_gift_help{ type=2,cost=1688,delay_day=12,reward = [{7501103,3},{6609002,1},{7206001,20},{3101000,8},{3302000,2},{7207001,20}],re_reward = [{10199, 1688}],desc = ?T("神笔判官") },
   #base_act_new_free_gift_help{ type=3,cost=3988,delay_day=18,reward = [{3207006,1},{3301000,60},{8001203,2},{3302000,2},{3303000,3},{8001231,1}],re_reward = [{10199, 3988}],desc = ?T("锦鲤背饰") }],
        act_info=#act_info{} };
get(_) -> [].

get_all() -> [1].
