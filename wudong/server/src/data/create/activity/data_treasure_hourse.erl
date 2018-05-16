%% 配置生成时间 2018-04-23 20:11:24
-module(data_treasure_hourse).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_treasure_hourse{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=1,end_day=999,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        treasure_hourse_sub_list=[
            #base_treasure_hourse_sub{limit_charge_gold=10,act_open_day=1,login_gift=[{8002403,1}],buy_gift_list=[{1,300,150,1,[{3101000,10}],0,0},{2,150,75,1,[{3102000,1}],0,0}],show_day=8},
            #base_treasure_hourse_sub{limit_charge_gold=10,act_open_day=2,login_gift=[{8002403,1}],buy_gift_list=[{1,300,150,1,[{3201000,10}],0,0},{2,6000,2000,1,[{3108015,1}],1,6}],show_day=8},
            #base_treasure_hourse_sub{limit_charge_gold=10,act_open_day=3,login_gift=[{6101000,500}],buy_gift_list=[{1,300,150,1,[{3401000,10}],0,0},{2,6000,2000,1,[{3208015,1}],2,6}],show_day=8},
            #base_treasure_hourse_sub{limit_charge_gold=10,act_open_day=4,login_gift=[{8002404,1}],buy_gift_list=[{1,300,150,1,[{3501000,10}],0,0},{2,6000,2000,1,[{3408015,1}],4,6}],show_day=8},
            #base_treasure_hourse_sub{limit_charge_gold=10,act_open_day=5,login_gift=[{8002404,1}],buy_gift_list=[{1,300,150,1,[{3301000,10}],0,0},{2,6000,2000,1,[{3508015,1}],5,6}],show_day=8},
            #base_treasure_hourse_sub{limit_charge_gold=10,act_open_day=6,login_gift=[{10400,1000}],buy_gift_list=[{1,300,150,1,[{3601000,10}],0,0},{2,6000,2000,1,[{3308015,1}],3,6}],show_day=8},
            #base_treasure_hourse_sub{limit_charge_gold=10,act_open_day=7,login_gift=[{8002405,1}],buy_gift_list=[{1,300,150,1,[{3701000,10}],0,0},{2,6000,2000,1,[{3608015,1}],8,6}],show_day=8},
            #base_treasure_hourse_sub{limit_charge_gold=10,act_open_day=8,login_gift=[{8002405,1}],buy_gift_list=[{1,300,150,1,[{8002516,10}],0,0},{2,6000,2000,1,[{3708015,1}],9,6}],show_day=8}
        ],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1].
