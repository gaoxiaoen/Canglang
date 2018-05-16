%% 配置生成时间 2018-04-23 20:11:23
-module(data_stone_ident).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_act_stone_ident{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000}],gs_id=[],open_day=3,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=1,merge_et_day=999,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        exchange_list=[
   #base_stone_ident{ id=1,cost_goods=[{1027005,1},{1027008,1}],get_goods=[{2003000,1,20},{2005000,3,20},{1025001,1,20},{8001057,1,10},{1027009,1,20},{8001161,1,10}]},
   #base_stone_ident{ id=2,cost_goods=[{1027006,1},{1027009,1}],get_goods=[{2003000,3,20},{8001161,1,10},{8001054,3,20},{6101000,10,20},{1010005,2,10},{1027010,1,20}]},
   #base_stone_ident{ id=3,cost_goods=[{1027007,1},{1027010,1}],get_goods=[{2003000,20,20},{8001161,1,10},{8001054,10,20},{1010005,5,20},{8001058,1,10},{8001162,10,20}]}],
        act_info=#act_info{} };
get(_) -> [].

get_all() -> [1].
