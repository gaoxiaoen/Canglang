%% 配置生成时间 2018-05-14 17:02:09
-module(data_act_jbp).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(2) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,10},{00,00,00}},end_time={{2017,11,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},
        act_id=2,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=300,list=[{1,[{10199,100},{8002516,5},{8001055,3},{2003000,10}]},{2,[{10199,100},{8002516,5},{8001055,3},{2003000,10}]},{3,[{10199,100},{8002516,5},{8001055,3},{2003000,10}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=1980,list=[{1,[{10199,660},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{2,[{10199,660},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{3,[{10199,660},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{2,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{3,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(1) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,15},{00,00,01}},end_time={{2017,11,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        list=[
#base_act_jbp_sub{id=1, login_flag=android, charge_gold=60,list=[{1,[{10199,350},{3307006,1},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{2,[{10199,350},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{3,[{10199,550},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]}]},
#base_act_jbp_sub{id=2, login_flag=android, charge_gold=3280,list=[{1,[{10199,1500},{3307006,1},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{2,[{10199,1500},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{3,[{10199,1880},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]}]},
#base_act_jbp_sub{id=3, login_flag=android, charge_gold=20000,list=[{1,[{10199,6800},{3307006,1},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{2,[{10199,8800},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{3,[{10199,13220},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]}]},
#base_act_jbp_sub{id=1, login_flag=ios, charge_gold=600,list=[{1,[{10199,350},{3307006,1},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{2,[{10199,350},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{3,[{10199,550},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]}]},
#base_act_jbp_sub{id=2, login_flag=ios, charge_gold=1980,list=[{1,[{10199,1500},{3307006,1},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{2,[{10199,1500},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{3,[{10199,1880},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]}]},
#base_act_jbp_sub{id=3, login_flag=ios, charge_gold=6480,list=[{1,[{10199,6800},{3307006,1},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{2,[{10199,8800},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]},{3,[{10199,13220},{3307006,2},{8001301,1},{8001302,1},{8002401,1},{8002401,1}]}]}],
        act_info=#act_info{}
    };

get(3) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,18},{00,00,00}},end_time={{2017,11,21},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=3,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]},{2,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]},{3,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{2,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{3,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{2,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{3,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(4) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,25},{00,00,00}},end_time={{2017,11,27},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=4,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]},{2,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]},{3,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{2,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{3,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{2,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{3,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(5) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,11},{00,00,00}},end_time={{2017,12,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=5},
        act_id=5,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]},{2,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]},{3,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{2,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{3,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{2,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{3,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(6) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,23},{00,00,00}},end_time={{2017,12,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=6,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]},{2,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]},{3,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{2,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{3,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{2,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{3,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(7) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,03},{00,00,00}},end_time={{2018,01,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=7,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]},{2,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]},{3,[{10199,660},{8002516,5},{8001055,3},{2003000,10}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{2,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]},{3,[{10199,1094},{1015001,5},{8002516,10},{8001055,5},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{2,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]},{3,[{10199,2160},{7415001,10},{1015001,10},{8002516,15},{8001055,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(8) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,12},{00,00,00}},end_time={{2018,01,14},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=8,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,275},{8002516,5},{1501000,5},{2003000,10}]},{2,[{10199,275},{8001054,5},{1504000,5},{2005000,20}]},{3,[{10199,275},{8001163,10},{3103000,5},{10101,200000}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,458},{1015001,5},{8001002,15},{8001161,5},{4503001,2}]},{2,[{10199,458},{2014001,3},{8002403,10},{3203000,10},{2005000,40}]},{3,[{10199,459},{11601,1},{8002516,10},{1504000,10},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,966},{6604085,3},{4503002,2},{8001002,10},{1502000,10},{10101,50000}]},{2,[{10199,966},{6604085,3},{8001058,2},{20340,20},{1503000,10},{2003000,30}]},{3,[{10199,967},{6604085,4},{1015001,10},{1010005,20},{1501000,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(9) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,17},{00,00,00}},end_time={{2018,01,19},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=9,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,275},{8002516,5},{1501000,5},{2003000,10}]},{2,[{10199,275},{8001054,5},{1504000,5},{2005000,20}]},{3,[{10199,275},{8001163,10},{3103000,5},{10101,200000}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,458},{1015001,5},{8001002,15},{8001161,5},{4503001,2}]},{2,[{10199,458},{2014001,3},{8002403,10},{3203000,10},{2005000,40}]},{3,[{10199,459},{11601,1},{8002516,10},{1504000,10},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,966},{6604085,3},{4503002,2},{8001002,10},{1502000,10},{10101,50000}]},{2,[{10199,966},{6604085,3},{8001058,2},{20340,20},{1503000,10},{2003000,30}]},{3,[{10199,967},{6604085,4},{1015001,10},{1010005,20},{1501000,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(10) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2018,01,27},{00,00,00}},end_time={{2018,01,29},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=4},
        act_id=10,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,275},{8002516,5},{1501000,5},{2003000,10}]},{2,[{10199,275},{8001054,5},{1504000,5},{2005000,20}]},{3,[{10199,275},{8001163,10},{3103000,5},{10101,200000}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,458},{1015001,5},{8001002,15},{8001161,5},{4503001,2}]},{2,[{10199,458},{2014001,3},{8002403,10},{3203000,10},{2005000,40}]},{3,[{10199,459},{11601,1},{8002516,10},{1504000,10},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,966},{6604085,3},{4503002,2},{8001002,10},{1502000,10},{10101,50000}]},{2,[{10199,966},{6604085,3},{8001058,2},{20340,20},{1503000,10},{2003000,30}]},{3,[{10199,967},{6604085,4},{1015001,10},{1010005,20},{1501000,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(11) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,02,14},{00,00,00}},end_time={{2018,02,16},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=11,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,275},{8002516,5},{1501000,5},{2003000,10}]},{2,[{10199,275},{8001054,5},{1504000,5},{2005000,20}]},{3,[{10199,275},{8001163,10},{3103000,5},{10101,200000}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,458},{1015001,5},{8001002,15},{8001161,5},{4503001,2}]},{2,[{10199,458},{2014001,3},{8002403,10},{3203000,10},{2005000,40}]},{3,[{10199,459},{11601,1},{8002516,10},{1504000,10},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,966},{6604085,3},{4503002,2},{8001002,10},{1502000,10},{10101,50000}]},{2,[{10199,966},{6604085,3},{8001058,2},{20340,20},{1503000,10},{2003000,30}]},{3,[{10199,967},{6604085,4},{1015001,10},{1010005,20},{1501000,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(12) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,11},{00,00,00}},end_time={{2018,03,13},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=12,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,275},{8002516,5},{1501000,5},{2003000,10}]},{2,[{10199,275},{8001054,5},{1504000,5},{2005000,20}]},{3,[{10199,275},{8001163,10},{3103000,5},{10101,200000}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,458},{1015001,5},{8001002,15},{8001161,5},{4503001,2}]},{2,[{10199,458},{2014001,3},{8002403,10},{3203000,10},{2005000,40}]},{3,[{10199,459},{11601,1},{8002516,10},{1504000,10},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,966},{6604085,3},{4503002,2},{8001002,10},{1502000,10},{10101,50000}]},{2,[{10199,966},{6604085,3},{8001058,2},{20340,20},{1503000,10},{2003000,30}]},{3,[{10199,967},{6604085,4},{1015001,10},{1010005,20},{1501000,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(13) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,03,18},{00,00,00}},end_time={{2018,03,20},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=13,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,275},{8002516,5},{1501000,5},{2003000,10}]},{2,[{10199,275},{8001054,5},{1504000,5},{2005000,20}]},{3,[{10199,275},{8001163,10},{3103000,5},{10101,200000}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,458},{1015001,5},{8001002,15},{8001161,5},{4503001,2}]},{2,[{10199,458},{2014001,3},{8002403,10},{3203000,10},{2005000,40}]},{3,[{10199,459},{11601,1},{8002516,10},{1504000,10},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,966},{6604085,3},{4503002,2},{8001002,10},{1502000,10},{10101,50000}]},{2,[{10199,966},{6604085,3},{8001058,2},{20340,20},{1503000,10},{2003000,30}]},{3,[{10199,967},{6604085,4},{1015001,10},{1010005,20},{1501000,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };

get(14) ->
    #base_act_jbp{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,04,16},{00,00,00}},end_time={{2018,04,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},
        act_id=14,
        list=[
#base_act_jbp_sub{id=1, login_flag=all, charge_gold=1980,list=[{1,[{10199,500},{8002516,5},{1501000,5},{2003000,10}]},{2,[{10199,600},{8001054,5},{1504000,5},{2005000,20}]},{3,[{10199,880},{8001163,10},{3103000,5},{10101,200000}]}]},
#base_act_jbp_sub{id=2, login_flag=all, charge_gold=3280,list=[{1,[{10199,800},{1015001,5},{8001002,15},{8001161,5},{4503001,2}]},{2,[{10199,1000},{2014001,3},{8002403,10},{3203000,10},{2005000,40}]},{3,[{10199,1480},{11601,1},{8002516,10},{1504000,10},{2003000,20}]}]},
#base_act_jbp_sub{id=3, login_flag=all, charge_gold=6480,list=[{1,[{10199,1500},{6604084,3},{4503002,2},{8001002,10},{1502000,10},{10101,50000}]},{2,[{10199,2000},{6604084,3},{8001058,2},{20340,20},{1503000,10},{2003000,30}]},{3,[{10199,2980},{6604084,4},{1015001,10},{1010005,20},{1501000,10},{2003000,30}]}]}],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [2,1,3,4,5,6,7,8,9,10,11,12,13,14].
