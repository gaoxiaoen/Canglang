%% 配置生成时间 2018-04-23 20:11:23
-module(data_debris_exchange).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(2) -> #base_debris_exchange{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[],open_day=3,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=2,
        cost_id=11601,
        exchange_list = [
   #base_debris_exchange_list{ id=1,index=7,cost_num=1,goods_id = 2601003,get_num = 15 },
   #base_debris_exchange_list{ id=2,index=2,cost_num=1,goods_id = 2602003,get_num = 20 },
   #base_debris_exchange_list{ id=3,index=130,cost_num=1,goods_id = 2603003,get_num = 20 },
   #base_debris_exchange_list{ id=4,index=6,cost_num=1,goods_id = 2604003,get_num = 20 },
   #base_debris_exchange_list{ id=5,index=5,cost_num=1,goods_id = 2605003,get_num = 20 },
   #base_debris_exchange_list{ id=6,index=1,cost_num=1,goods_id = 2606003,get_num = 20 },
   #base_debris_exchange_list{ id=7,index=3,cost_num=1,goods_id = 2607003,get_num = 20 },
   #base_debris_exchange_list{ id=8,index=4,cost_num=1,goods_id = 2608003,get_num = 20 }],
        act_info=#act_info{} };
get(_) -> [].

get_all() -> [2].
