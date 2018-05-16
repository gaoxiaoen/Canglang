%% 配置生成时间 2018-04-23 20:11:23
-module(data_act_baby_equip_sex).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_act_baby_equip_sex{open_info=#open_info{gp_id = [],gs_id=[],open_day=1,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,act_info=#act_info{}};
get(_) -> [].

get_all() -> [1].
