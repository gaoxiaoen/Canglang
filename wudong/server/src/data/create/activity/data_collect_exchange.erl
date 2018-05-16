%% 配置生成时间 2018-04-23 20:11:23
-module(data_collect_exchange).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(1) -> #base_act_collect_exchange{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=3,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=1,merge_et_day=999,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        exchange_list=[
   #base_ce{ id=1,get_goods={2601002,1},cost_goods=[{1027001,2},{1027002,2},{1027003,2},{1027004,2}],limit_list=[2201003,2301003,2201004,2301004,2601002]},
   #base_ce{ id=2,get_goods={2602002,1},cost_goods=[{1027001,2},{1027002,2},{1027003,2},{1027004,2}],limit_list=[2102003,2602002,2102004]},
   #base_ce{ id=3,get_goods={2603002,1},cost_goods=[{1027001,2},{1027002,2},{1027003,2},{1027004,2}],limit_list=[2103003,2603002,2103004]},
   #base_ce{ id=4,get_goods={2604002,1},cost_goods=[{1027001,2},{1027002,2},{1027003,2},{1027004,2}],limit_list=[2104003,2604002,2104004]},
   #base_ce{ id=5,get_goods={2605002,1},cost_goods=[{1027001,2},{1027002,2},{1027003,2},{1027004,2}],limit_list=[2105003,2605002,2105004]},
   #base_ce{ id=6,get_goods={2606002,1},cost_goods=[{1027001,2},{1027002,2},{1027003,2},{1027004,2}],limit_list=[2106003,2606002,2106004]},
   #base_ce{ id=7,get_goods={2607002,1},cost_goods=[{1027001,2},{1027002,2},{1027003,2},{1027004,2}],limit_list=[2107003,2607002,2107004]},
   #base_ce{ id=8,get_goods={2608002,1},cost_goods=[{1027001,2},{1027002,2},{1027003,2},{1027004,2}],limit_list=[2108003,2608002,2108004]},
   #base_ce{ id=9,get_goods={2005000,1},cost_goods=[{1027001,2},{1027002,2},{1027003,2},{1027004,2}],limit_list=[]}],
        act_info=#act_info{} };
get(_) -> [].

get_all() -> [1].
