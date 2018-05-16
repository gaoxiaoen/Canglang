%% 配置生成时间 2018-05-14 17:01:54
-module(data_festival_exchange).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1027011,1},{1027012,1}],exchange_get=[{21001,1}],exchange_num=1},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1027011,3},{1027012,3}],exchange_get=[{6604001,1}],exchange_num=3},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1027011,5},{1027012,5}],exchange_get=[{6602001,1}],exchange_num=3},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1027011,10},{1027012,20}],exchange_get=[{21005,1}],exchange_num=1}
        ],
        act_info=#act_info{}
    };

get(2) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,09,30},{00,00,00}},end_time={{2017,10,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=2,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045002,30},{1045003,100}],exchange_get=[{6602012,10}],exchange_num=1},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045002,15},{1045003,80}],exchange_get=[{3307006,10}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045002,40},{1045003,300}],exchange_get=[{3107007,10}],exchange_num=1},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045002,40},{1045003,300}],exchange_get=[{3207001,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045002,30},{1045003,100}],exchange_get=[{4105002,1}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045002,5},{1045003,50}],exchange_get=[{6610015,10}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045002,3},{1045003,20}],exchange_get=[{6604069,10}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045002,5},{1045003,50}],exchange_get=[{6604072,10}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045002,3},{1045003,50}],exchange_get=[{11601,1}],exchange_num=10},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045002,6},{1045003,10}],exchange_get=[{8001002,80}],exchange_num=1},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045002,3},{1045003,10}],exchange_get=[{8001002,30}],exchange_num=1},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045002,1},{1045003,10}],exchange_get=[{8001002,10}],exchange_num=1},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045002,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045002,1}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045003,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=16,exchange_cost=[{1045003,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=17,exchange_cost=[{1045003,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=18,exchange_cost=[{1045003,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=19,exchange_cost=[{1045003,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=20,exchange_cost=[{1045003,10}],exchange_get=[{6101000,100}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(3) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,05},{00,00,00}},end_time={{2017,10,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=3,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045002,30},{1045003,100}],exchange_get=[{6602014,10}],exchange_num=1},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045002,15},{1045003,80}],exchange_get=[{3307005,10}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045002,40},{1045003,300}],exchange_get=[{3107006,10}],exchange_num=1},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045002,40},{1045003,300}],exchange_get=[{3207001,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045002,30},{1045003,100}],exchange_get=[{4105019,1}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045002,5},{1045003,50}],exchange_get=[{6610016,10}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045002,3},{1045003,20}],exchange_get=[{6604070,10}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045002,5},{1045003,50}],exchange_get=[{6604071,10}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045002,3},{1045003,50}],exchange_get=[{11601,1}],exchange_num=10},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045002,6},{1045003,10}],exchange_get=[{8001002,80}],exchange_num=1},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045002,3},{1045003,10}],exchange_get=[{8001002,30}],exchange_num=1},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045002,1},{1045003,10}],exchange_get=[{8001002,10}],exchange_num=1},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045002,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045002,1}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045003,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=16,exchange_cost=[{1045003,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=17,exchange_cost=[{1045003,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=18,exchange_cost=[{1045003,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=19,exchange_cost=[{1045003,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=20,exchange_cost=[{1045003,10}],exchange_get=[{6101000,100}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(4) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,29},{00,00,00}},end_time={{2017,11,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=4,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045004,3},{1045005,20}],exchange_get=[{6602016,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045004,2},{1045005,10}],exchange_get=[{3307009,1}],exchange_num=10},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045004,3},{1045005,30}],exchange_get=[{3107008,1}],exchange_num=10},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045004,3},{1045005,30}],exchange_get=[{3207001,1}],exchange_num=10},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045004,5},{1045005,20}],exchange_get=[{6607016,1}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045004,30},{1045005,100}],exchange_get=[{4105023,1}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045004,5},{1045005,50}],exchange_get=[{6610021,10}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045004,3},{1045005,20}],exchange_get=[{6604081,10}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045004,5},{1045005,50}],exchange_get=[{6604080,10}],exchange_num=1},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045004,1},{1045005,10}],exchange_get=[{11601,1}],exchange_num=10},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045004,6},{1045005,10}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045004,3},{1045005,10}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045004,1},{1045005,10}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045004,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045005,10}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=16,exchange_cost=[{1045005,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=17,exchange_cost=[{1045005,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=18,exchange_cost=[{1045005,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=19,exchange_cost=[{1045005,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=20,exchange_cost=[{1045005,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=21,exchange_cost=[{1045005,10}],exchange_get=[{6101000,100}],exchange_num=50},
            #base_festival_exchange_sub{id=22,exchange_cost=[{1045005,20}],exchange_get=[{1047001,1}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(5) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,10},{00,00,00}},end_time={{2017,11,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},
        act_id=5,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{6602019,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,3},{1045007,10}],exchange_get=[{3207003,1}],exchange_num=10},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,6},{1045007,20}],exchange_get=[{6608020,10}],exchange_num=1},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,4},{1045007,20}],exchange_get=[{6610020,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,2},{1045007,20}],exchange_get=[{6604085,10}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,5},{1045007,20}],exchange_get=[{6604086,10}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{11601,1}],exchange_num=10},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,6},{1045007,10}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045006,3},{1045007,10}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045006,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045007,10}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=16,exchange_cost=[{1045007,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=17,exchange_cost=[{1045007,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=18,exchange_cost=[{1045007,10}],exchange_get=[{6101000,100}],exchange_num=50},
            #base_festival_exchange_sub{id=19,exchange_cost=[{1045007,20}],exchange_get=[{1047002,1}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(6) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,23},{00,00,00}},end_time={{2017,11,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},
        act_id=6,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{3107009,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{3307010,1}],exchange_num=10},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,10},{1045007,20}],exchange_get=[{6608024,10}],exchange_num=1},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,6},{1045007,20}],exchange_get=[{6610023,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,5},{1045007,20}],exchange_get=[{6604093,10}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,10},{1045007,20}],exchange_get=[{6604092,10}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,30},{1045007,20}],exchange_get=[{4105027,1}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{11601,1}],exchange_num=10},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045006,6},{1045007,10}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045006,3},{1045007,10}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045006,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,10}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=16,exchange_cost=[{1045007,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=17,exchange_cost=[{1045007,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=18,exchange_cost=[{1045007,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=19,exchange_cost=[{1045007,10}],exchange_get=[{6101000,100}],exchange_num=50},
            #base_festival_exchange_sub{id=20,exchange_cost=[{1045007,20}],exchange_get=[{1047002,1}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(7) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,11},{00,00,00}},end_time={{2017,12,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},
        act_id=7,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{6602021,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,3},{1045007,15}],exchange_get=[{3207004,1}],exchange_num=10},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6604097,10}],exchange_num=1},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,1},{1045007,20}],exchange_get=[{11601,1}],exchange_num=10},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045007,20}],exchange_get=[{1047002,1}],exchange_num=50},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,30},{1045007,100}],exchange_get=[{4105018,1}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,10},{1045007,35}],exchange_get=[{6610026,10}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,6},{1045007,20}],exchange_get=[{6610024,10}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045006,4},{1045007,20}],exchange_get=[{6604095,10}],exchange_num=1},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045006,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,10}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=16,exchange_cost=[{1045007,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=17,exchange_cost=[{1045007,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=18,exchange_cost=[{1045007,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=19,exchange_cost=[{1045007,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=20,exchange_cost=[{1045007,10}],exchange_get=[{6101000,100}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(8) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,23},{00,00,00}},end_time={{2017,12,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},
        act_id=8,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{6602022,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,12},{1045007,50}],exchange_get=[{6604100,10}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,1},{1045007,20}],exchange_get=[{11601,1}],exchange_num=10},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045007,20}],exchange_get=[{1047002,1}],exchange_num=50},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,30},{1045007,100}],exchange_get=[{4105024,1}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,8},{1045007,20}],exchange_get=[{6606026,10}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6606025,10}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,8},{1045007,20}],exchange_get=[{6604099,10}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045006,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,10}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=16,exchange_cost=[{1045007,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=17,exchange_cost=[{1045007,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=18,exchange_cost=[{1045007,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=19,exchange_cost=[{1045007,10}],exchange_get=[{6101000,100}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(9) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,17},{00,00,00}},end_time={{2018,01,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=9,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,40},{1045007,300}],exchange_get=[{6602023,10}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,12},{1045007,50}],exchange_get=[{6610029,10}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,1},{1045007,20}],exchange_get=[{11601,1}],exchange_num=10},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045007,20}],exchange_get=[{1047002,1}],exchange_num=50},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,30},{1045007,100}],exchange_get=[{4105035,1}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6606028,10}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6604106,10}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,6},{1045007,20}],exchange_get=[{6604107,10}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045006,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,10}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=16,exchange_cost=[{1045007,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=17,exchange_cost=[{1045007,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=18,exchange_cost=[{1045007,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=19,exchange_cost=[{1045007,10}],exchange_get=[{6101000,100}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(11) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,12},{00,00,00}},end_time={{2018,02,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=11,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,10},{1045007,30}],exchange_get=[{6602026,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,50},{1045007,100}],exchange_get=[{4105041,1}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{3307014,1}],exchange_num=10},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6604115,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6604113,10}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6606033,10}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045006,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045007,10}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045007,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=16,exchange_cost=[{1045007,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=17,exchange_cost=[{1045007,10}],exchange_get=[{6101000,100}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(10) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,15},{00,00,00}},end_time={{2018,02,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=10,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,10},{1045007,30}],exchange_get=[{6602024,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,50},{1045007,100}],exchange_get=[{4105041,1}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{3307014,1}],exchange_num=10},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6604110,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6604108,10}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6606029,10}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045006,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045007,10}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045007,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=16,exchange_cost=[{1045007,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=17,exchange_cost=[{1045007,10}],exchange_get=[{6101000,100}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(12) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,03},{00,00,00}},end_time={{2018,03,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=12,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,10},{1045007,30}],exchange_get=[{3207006,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,50},{1045007,100}],exchange_get=[{4105036,1}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,12},{1045007,50}],exchange_get=[{6610035,10}],exchange_num=10},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6604110,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045007,10}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045007,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045007,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045007,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,5}],exchange_get=[{8002402,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,20}],exchange_get=[{10400,100}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,10}],exchange_get=[{6101000,100}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(13) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,31},{00,00,00}},end_time={{2018,04,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=13,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,20},{1045007,50}],exchange_get=[{6602027,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,20},{1045007,50}],exchange_get=[{6602028,1}],exchange_num=10},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{3307015,1}],exchange_num=10},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6603126,1}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6605035,1}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6609038,1}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{8002516,30}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{8002516,10}],exchange_num=1},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045006,2}],exchange_get=[{8001058,1}],exchange_num=10},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045007,10}],exchange_get=[{1015001,1}],exchange_num=50},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045007,10}],exchange_get=[{2003000,5}],exchange_num=50},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,6}],exchange_get=[{8001057,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,10}],exchange_get=[{8001161,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,5}],exchange_get=[{8002402,1}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(30) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,29},{00,00,00}},end_time={{2018,04,30},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=30,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,12},{1045007,50}],exchange_get=[{6602029,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6610040,10}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6604140,10}],exchange_num=1},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6606039,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{40001,80}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{40001,30}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{40001,10}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045007,15}],exchange_get=[{40002,1}],exchange_num=50},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045007,15}],exchange_get=[{40011,1}],exchange_num=50},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045007,15}],exchange_get=[{40012,1}],exchange_num=50},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045007,6}],exchange_get=[{40021,1}],exchange_num=50},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,6}],exchange_get=[{40022,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,20}],exchange_get=[{40031,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,20}],exchange_get=[{40032,1}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(31) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,01},{00,00,00}},end_time={{2018,05,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=31,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,12},{1045007,50}],exchange_get=[{6602030,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6610041,10}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6606040,10}],exchange_num=1},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6604136,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{40001,80}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{40001,30}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{40001,10}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045007,15}],exchange_get=[{40002,1}],exchange_num=50},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045007,15}],exchange_get=[{40011,1}],exchange_num=50},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045007,15}],exchange_get=[{40012,1}],exchange_num=50},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045007,6}],exchange_get=[{40021,1}],exchange_num=50},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,6}],exchange_get=[{40022,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,20}],exchange_get=[{40031,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,20}],exchange_get=[{40032,1}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(32) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,12},{00,00,00}},end_time={{2018,05,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=32,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,20},{1045007,50}],exchange_get=[{6602029,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6604132,10}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6606041,10}],exchange_num=1},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6610042,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{40001,80}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{40001,30}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{40001,10}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045007,15}],exchange_get=[{40002,1}],exchange_num=50},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045007,15}],exchange_get=[{40013,1}],exchange_num=50},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045007,15}],exchange_get=[{40012,1}],exchange_num=50},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045007,6}],exchange_get=[{40023,1}],exchange_num=50},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,6}],exchange_get=[{40022,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,20}],exchange_get=[{40033,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,20}],exchange_get=[{40032,1}],exchange_num=50}
        ],
        act_info=#act_info{}
    };

get(33) ->
    #base_festival_exchange{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,14},{00,00,00}},end_time={{2018,05,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=33,
        list=[
            #base_festival_exchange_sub{id=1,exchange_cost=[{1045006,20},{1045007,50}],exchange_get=[{6602030,1}],exchange_num=10},
            #base_festival_exchange_sub{id=2,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6604131,10}],exchange_num=1},
            #base_festival_exchange_sub{id=3,exchange_cost=[{1045006,10},{1045007,50}],exchange_get=[{6604133,10}],exchange_num=1},
            #base_festival_exchange_sub{id=4,exchange_cost=[{1045006,8},{1045007,50}],exchange_get=[{6610043,10}],exchange_num=1},
            #base_festival_exchange_sub{id=5,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{8002516,80}],exchange_num=1},
            #base_festival_exchange_sub{id=6,exchange_cost=[{1045006,6},{1045007,30}],exchange_get=[{40001,80}],exchange_num=1},
            #base_festival_exchange_sub{id=7,exchange_cost=[{1045006,3},{1045007,20}],exchange_get=[{40001,30}],exchange_num=1},
            #base_festival_exchange_sub{id=8,exchange_cost=[{1045006,1},{1045007,10}],exchange_get=[{40001,10}],exchange_num=1},
            #base_festival_exchange_sub{id=9,exchange_cost=[{1045007,15}],exchange_get=[{40002,1}],exchange_num=50},
            #base_festival_exchange_sub{id=10,exchange_cost=[{1045007,15}],exchange_get=[{40013,1}],exchange_num=50},
            #base_festival_exchange_sub{id=11,exchange_cost=[{1045007,15}],exchange_get=[{40012,1}],exchange_num=50},
            #base_festival_exchange_sub{id=12,exchange_cost=[{1045007,6}],exchange_get=[{40023,1}],exchange_num=50},
            #base_festival_exchange_sub{id=13,exchange_cost=[{1045007,6}],exchange_get=[{40022,1}],exchange_num=50},
            #base_festival_exchange_sub{id=14,exchange_cost=[{1045007,20}],exchange_get=[{40033,1}],exchange_num=50},
            #base_festival_exchange_sub{id=15,exchange_cost=[{1045007,20}],exchange_get=[{40032,1}],exchange_num=50}
        ],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1,2,3,4,5,6,7,8,9,11,10,12,13,30,31,32,33].
