%% 配置生成时间 2018-04-23 20:11:24
-module(data_re_recharge_inf).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
get(2) -> #base_re_recharge_inf{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,16},{00,00,00}},end_time={{2017,12,23},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=2,
        val=500,
        rank_info = [
   #rank_info{ top=1,down=999,reward=[{1045008,1},{10106,388},{1044005,1},{8001055,10},{8001056,10},{2003000,30}]}],
        act_info=#act_info{} };
get(1) -> #base_re_recharge_inf{open_info=#open_info{gp_id = [{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,25},{00,00,00}},end_time={{2017,12,31},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=1,
        val=500,
        rank_info = [
   #rank_info{ top=1,down=1,reward=[{1045008,5},{1047002,1},{1016002,1},{2003000,1},{8001055,1},{1045007,3}]},
   #rank_info{ top=2,down=3,reward=[{1045008,12},{1047002,1},{1016002,1},{2003000,1},{8001055,1},{1045007,3}]},
   #rank_info{ top=4,down=10,reward=[{1045008,18},{1047002,1},{1016002,1},{2003000,1},{8001055,1},{1045007,3}]},
   #rank_info{ top=11,down=50,reward=[{1045008,32},{1047002,1},{1016002,1},{2003000,1},{8001055,1},{1045007,3}]},
   #rank_info{ top=51,down=999,reward=[{1045008,40},{1047002,1},{1016002,1},{2003000,1},{8001055,1},{1045007,3}]}],
        act_info=#act_info{} };
get(3) -> #base_re_recharge_inf{open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,12,30},{00,00,00}},end_time={{2018,01,05},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=8},act_id=3,
        val=500,
        rank_info = [
   #rank_info{ top=1,down=999,reward=[{1045008,1},{10106,388},{1044005,1},{8001055,10},{8001056,10},{2003000,30}]}],
        act_info=#act_info{} };
get(_) -> [].

get_all() -> [2,1,3].
