%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_exp_round
	%%% @Created : 2017-11-08 14:37:35
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_exp_round).
-export([dun_list/0]).
-export([get_scene/1]).
-export([get_round/1]).
-export([check_round/2]).
-include("common.hrl").
-include("dungeon.hrl").

    dun_list() ->
    [55001,55002,55003,55004,55005,55006,55007,55008,55009,55010,55011,55012,55013].
get_round(55001)->[ 1,15];
get_round(55002)->[ 16,30];
get_round(55003)->[ 31,45];
get_round(55004)->[ 46,60];
get_round(55005)->[ 61,75];
get_round(55006)->[ 76,90];
get_round(55007)->[ 91,105];
get_round(55008)->[ 106,120];
get_round(55009)->[ 121,135];
get_round(55010)->[ 136,150];
get_round(55011)->[ 151,165];
get_round(55012)->[ 166,180];
get_round(55013)->[ 181,195];
get_round(_) ->[].
get_scene(Round) when Round>= 1 andalso Round=<15->55001;
get_scene(Round) when Round>= 16 andalso Round=<30->55002;
get_scene(Round) when Round>= 31 andalso Round=<45->55003;
get_scene(Round) when Round>= 46 andalso Round=<60->55004;
get_scene(Round) when Round>= 61 andalso Round=<75->55005;
get_scene(Round) when Round>= 76 andalso Round=<90->55006;
get_scene(Round) when Round>= 91 andalso Round=<105->55007;
get_scene(Round) when Round>= 106 andalso Round=<120->55008;
get_scene(Round) when Round>= 121 andalso Round=<135->55009;
get_scene(Round) when Round>= 136 andalso Round=<150->55010;
get_scene(Round) when Round>= 151 andalso Round=<165->55011;
get_scene(Round) when Round>= 166 andalso Round=<180->55012;
get_scene(Round) when Round>= 181 andalso Round=<195->55013;
get_scene(_) ->[].
check_round(55001,Round) when Round >= 1 andalso Round =<15->true;
check_round(55002,Round) when Round >= 16 andalso Round =<30->true;
check_round(55003,Round) when Round >= 31 andalso Round =<45->true;
check_round(55004,Round) when Round >= 46 andalso Round =<60->true;
check_round(55005,Round) when Round >= 61 andalso Round =<75->true;
check_round(55006,Round) when Round >= 76 andalso Round =<90->true;
check_round(55007,Round) when Round >= 91 andalso Round =<105->true;
check_round(55008,Round) when Round >= 106 andalso Round =<120->true;
check_round(55009,Round) when Round >= 121 andalso Round =<135->true;
check_round(55010,Round) when Round >= 136 andalso Round =<150->true;
check_round(55011,Round) when Round >= 151 andalso Round =<165->true;
check_round(55012,Round) when Round >= 166 andalso Round =<180->true;
check_round(55013,Round) when Round >= 181 andalso Round =<195->true;
check_round(_,_) -> false.
