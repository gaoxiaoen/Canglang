%% 配置生成时间 2018-05-14 16:57:35
-module(data_online_gift).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").
-include("common.hrl").
get(2) -> #base_online_gift{open_info=#open_info{gp_id = [{0,60000},{30001,50000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},act_id=2,open_time=[{0,1},{8,59}],gift_list=[{10199,5000},{10101,20000}],mail_title=?T("时段礼包"),mail_content=?T("欢迎来到《花千骨》，为了各位仙友能更好地闯荡江湖，小骨特意奉上福利一份，记得常来哦，祝游戏愉快！"),act_info=#act_info{} };
get(_) -> [].

get_all() -> [2].

        