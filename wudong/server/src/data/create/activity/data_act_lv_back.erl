%% 配置生成时间 2018-04-23 20:11:24
-module(data_act_lv_back).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_act_lv_back{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=1,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,award_list=[{1,500,[{50,150},{60,150},{70,150},{80,150},{90,150},{100,150},{110,150},{120,150},{130,150},{140,150},{150,150},{160,200},{170,200},{180,200},{190,200},{200,200},{210,200},{220,200},{230,200},{240,200},{250,200}]},{2,2000,[{50,600},{60,600},{70,600},{80,600},{90,600},{100,600},{110,600},{120,600},{130,600},{140,600},{150,600},{160,800},{170,800},{180,800},{190,800},{200,800},{210,800},{220,800},{230,800},{240,800},{250,800}]}],act_info=#act_info{}};
get(_) -> [].

get_all() -> [1].
