%% 配置生成时间 2018-04-23 20:11:24
-module(data_return_exchange).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(2) ->
    #base_return_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,16},{00,00,00}},end_time={{2017,12,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=2,
        list=[
            #base_return_exchange_sub{id=1,exchange_cost=[{1045008,3},{10199,200}],exchange_get=[{3107007,1}],exchange_num=10},
            #base_return_exchange_sub{id=2,exchange_cost=[{1045008,10},{10199,200}],exchange_get=[{6604094,10}],exchange_num=1},
            #base_return_exchange_sub{id=3,exchange_cost=[{1045008,5},{10199,100}],exchange_get=[{5101407,5}],exchange_num=1},
            #base_return_exchange_sub{id=4,exchange_cost=[{1045008,5},{10199,100}],exchange_get=[{5101437,5}],exchange_num=1},
            #base_return_exchange_sub{id=5,exchange_cost=[{1045008,5},{10199,100}],exchange_get=[{5101427,5}],exchange_num=1},
            #base_return_exchange_sub{id=6,exchange_cost=[{1045008,8},{10199,200}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_return_exchange_sub{id=7,exchange_cost=[{1045008,5},{10199,100}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_return_exchange_sub{id=8,exchange_cost=[{1045008,1},{10106,100}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_return_exchange_sub{id=9,exchange_cost=[{1045008,1},{10106,100}],exchange_get=[{8001058,1}],exchange_num=50},
            #base_return_exchange_sub{id=10,exchange_cost=[{1045008,1},{10106,50}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_return_exchange_sub{id=11,exchange_cost=[{10106,50}],exchange_get=[{8002517,1}],exchange_num=10},
            #base_return_exchange_sub{id=12,exchange_cost=[{10106,30}],exchange_get=[{8002518,1}],exchange_num=10},
            #base_return_exchange_sub{id=14,exchange_cost=[{10106,88}],exchange_get=[{5101403,1}],exchange_num=10},
            #base_return_exchange_sub{id=15,exchange_cost=[{10106,88}],exchange_get=[{5101423,100}],exchange_num=10},
            #base_return_exchange_sub{id=16,exchange_cost=[{10106,88}],exchange_get=[{5101413,100}],exchange_num=10}
        ],
        act_info=#act_info{}
    };

get(1) ->
    #base_return_exchange{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,25},{00,00,00}},end_time={{2017,12,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        list=[
            #base_return_exchange_sub{id=1,exchange_cost=[{1045008,30},{10199,100}],exchange_get=[{6602012,10}],exchange_num=1},
            #base_return_exchange_sub{id=2,exchange_cost=[{1045008,15},{10199,1000}],exchange_get=[{3307006,10}],exchange_num=1},
            #base_return_exchange_sub{id=3,exchange_cost=[{1045008,15},{10106,8000}],exchange_get=[{3107007,10}],exchange_num=1},
            #base_return_exchange_sub{id=4,exchange_cost=[{1045008,80}],exchange_get=[{3207001,10}],exchange_num=1},
            #base_return_exchange_sub{id=5,exchange_cost=[{1045008,1},{10106,800}],exchange_get=[{4105002,1}],exchange_num=1},
            #base_return_exchange_sub{id=6,exchange_cost=[{1045008,5}],exchange_get=[{6610015,10}],exchange_num=1},
            #base_return_exchange_sub{id=7,exchange_cost=[{1045008,3},{10199,20}],exchange_get=[{6604069,10}],exchange_num=1},
            #base_return_exchange_sub{id=8,exchange_cost=[{1045008,5},{10106,500}],exchange_get=[{6604072,10}],exchange_num=1},
            #base_return_exchange_sub{id=9,exchange_cost=[{1045008,3},{10106,500}],exchange_get=[{11601,1}],exchange_num=10},
            #base_return_exchange_sub{id=10,exchange_cost=[{1045008,6},{10106,100}],exchange_get=[{8001002,80}],exchange_num=1},
            #base_return_exchange_sub{id=11,exchange_cost=[{1045008,3},{10199,10}],exchange_get=[{8001002,30}],exchange_num=1},
            #base_return_exchange_sub{id=12,exchange_cost=[{1045008,1},{10199,10}],exchange_get=[{8001002,10}],exchange_num=1}
        ],
        act_info=#act_info{}
    };

get(3) ->
    #base_return_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,30},{00,00,00}},end_time={{2018,01,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=3,
        list=[
            #base_return_exchange_sub{id=1,exchange_cost=[{1045008,3},{10199,200}],exchange_get=[{3107007,1}],exchange_num=10},
            #base_return_exchange_sub{id=2,exchange_cost=[{1045008,10},{10199,200}],exchange_get=[{6604094,10}],exchange_num=1},
            #base_return_exchange_sub{id=3,exchange_cost=[{1045008,5},{10199,100}],exchange_get=[{5101407,5}],exchange_num=1},
            #base_return_exchange_sub{id=4,exchange_cost=[{1045008,5},{10199,100}],exchange_get=[{5101437,5}],exchange_num=1},
            #base_return_exchange_sub{id=5,exchange_cost=[{1045008,5},{10199,100}],exchange_get=[{5101427,5}],exchange_num=1},
            #base_return_exchange_sub{id=6,exchange_cost=[{1045008,8},{10199,200}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_return_exchange_sub{id=7,exchange_cost=[{1045008,5},{10199,100}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_return_exchange_sub{id=8,exchange_cost=[{1045008,1},{10106,100}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_return_exchange_sub{id=9,exchange_cost=[{1045008,1},{10106,100}],exchange_get=[{8001058,1}],exchange_num=50},
            #base_return_exchange_sub{id=10,exchange_cost=[{1045008,1},{10106,50}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_return_exchange_sub{id=11,exchange_cost=[{10106,50}],exchange_get=[{8002517,1}],exchange_num=10},
            #base_return_exchange_sub{id=12,exchange_cost=[{10106,30}],exchange_get=[{8002518,1}],exchange_num=10},
            #base_return_exchange_sub{id=14,exchange_cost=[{10106,88}],exchange_get=[{5101403,1}],exchange_num=10},
            #base_return_exchange_sub{id=15,exchange_cost=[{10106,88}],exchange_get=[{5101423,100}],exchange_num=10},
            #base_return_exchange_sub{id=16,exchange_cost=[{10106,88}],exchange_get=[{5101413,100}],exchange_num=10}
        ],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [2,1,3].
