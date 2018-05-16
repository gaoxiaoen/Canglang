%% 配置生成时间 2018-05-14 17:02:27
-module(data_act_one_gold_buy).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

%%%%%%%%%%一元抢购

get(8) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,13},{00,00,00}},end_time={{2017,10,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=8,
        act_type=1 ,
        price_list= [{1,10}, {10,100},{50,500},{100,1000}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(9) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,20},{00,00,00}},end_time={{2017,10,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=15},
        act_id=9,
        act_type=1 ,
        price_list= [{1,10}, {10,100},{50,500},{100,1000}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(20) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,23},{00,00,00}},end_time={{2017,10,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},
        act_id=20,
        act_type=1 ,
        price_list= [{1,10}, {10,100},{50,500},{100,1000}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(21) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,31},{00,00,00}},end_time={{2017,10,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=21,
        act_type=1 ,
        price_list= [{1,10}, {10,100},{50,500},{100,1000}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(22) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,01},{00,00,00}},end_time={{2017,11,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=22,
        act_type=1 ,
        price_list= [{1,10}, {10,100},{50,500},{100,1000}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(23) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,06},{00,00,00}},end_time={{2017,11,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=23,
        act_type=1 ,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(24) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,08},{00,00,00}},end_time={{2017,11,12},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=24,
        act_type=1 ,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(25) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,13},{00,00,00}},end_time={{2017,11,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=25,
        act_type=2 ,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(26) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,20},{00,00,00}},end_time={{2017,11,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=26,
        act_type=3 ,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(27) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,27},{00,00,00}},end_time={{2017,12,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=27,
        act_type=4 ,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(28) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,04},{00,00,00}},end_time={{2017,12,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},
        act_id=28,
        act_type=5 ,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(29) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,11},{00,00,00}},end_time={{2017,12,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},
        act_id=29,
        act_type=1 ,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(30) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,18},{00,00,00}},end_time={{2017,12,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},
        act_id=30,
        act_type=6,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(31) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,25},{00,00,00}},end_time={{2017,12,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},
        act_id=31,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(32) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,28},{00,00,00}},end_time={{2017,12,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},
        act_id=32,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(33) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,01},{00,00,00}},end_time={{2018,01,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},
        act_id=33,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(34) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,04},{00,00,00}},end_time={{2018,01,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},
        act_id=34,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(35) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,08},{00,00,00}},end_time={{2018,01,10},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},
        act_id=35,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(36) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,11},{00,00,00}},end_time={{2018,01,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=3},
        act_id=36,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(37) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,15},{00,00,00}},end_time={{2018,01,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=37,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(38) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,16},{00,00,00}},end_time={{2018,01,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=38,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(39) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,18},{00,00,00}},end_time={{2018,01,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=39,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(40) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,22},{00,00,00}},end_time={{2018,01,24},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=40,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(41) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,25},{00,00,00}},end_time={{2018,01,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=41,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(42) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,29},{00,00,00}},end_time={{2018,01,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=42,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(43) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,01},{00,00,00}},end_time={{2018,02,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=43,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(44) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,05},{00,00,00}},end_time={{2018,02,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=44,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(45) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,08},{00,00,00}},end_time={{2018,02,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=45,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(46) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,12},{00,00,00}},end_time={{2018,02,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=46,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(47) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,15},{00,00,00}},end_time={{2018,02,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=47,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(48) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,19},{00,00,00}},end_time={{2018,02,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=48,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(49) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,22},{00,00,00}},end_time={{2018,02,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=49,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(50) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,26},{00,00,00}},end_time={{2018,02,28},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=50,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(51) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,01},{00,00,00}},end_time={{2018,03,04},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=51,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(52) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,05},{00,00,00}},end_time={{2018,03,07},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=52,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(53) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,08},{00,00,00}},end_time={{2018,03,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=53,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(54) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,12},{00,00,00}},end_time={{2018,03,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=54,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(55) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,15},{00,00,00}},end_time={{2018,03,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=55,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(56) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,19},{00,00,00}},end_time={{2018,03,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=56,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(57) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,22},{00,00,00}},end_time={{2018,03,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=57,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(58) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,26},{00,00,00}},end_time={{2018,04,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=58,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(59) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,02},{00,00,00}},end_time={{2018,04,08},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=59,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(60) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,09},{00,00,00}},end_time={{2018,04,15},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=60,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(61) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,16},{00,00,00}},end_time={{2018,04,22},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=61,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(62) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,23},{00,00,00}},end_time={{2018,04,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=62,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(63) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,30},{00,00,00}},end_time={{2018,05,06},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=63,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(200) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,07},{00,00,00}},end_time={{2018,05,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=200,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(201) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,14},{00,00,00}},end_time={{2018,05,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=201,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(202) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,21},{00,00,00}},end_time={{2018,05,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=202,
        act_type=7,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };

%%%%%%%%%%一元抢购

get(203) ->
    #base_act_one_gold_buy{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,28},{00,00,00}},end_time={{2018,06,03},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=203,
        act_type=8,
        price_list= [{1,10}, {5,50},{10,100},{20,200}],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [8,9,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,200,201,202,203].
