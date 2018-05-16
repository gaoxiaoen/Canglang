%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_guild_reward
	%%% @Created : 2017-10-12 17:28:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_guild_reward).
-export([get_award/1]).
-include("common.hrl").
-include("task.hrl").
get_award(Lv)when Lv>=48 andalso Lv=<55->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=56 andalso Lv=<60->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=61 andalso Lv=<63->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=64 andalso Lv=<66->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=67 andalso Lv=<68->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=69 andalso Lv=<70->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=71 andalso Lv=<71->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=72 andalso Lv=<80->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=81 andalso Lv=<95->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=96 andalso Lv=<107->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=108 andalso Lv=<122->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=123 andalso Lv=<137->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=138 andalso Lv=<152->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=153 andalso Lv=<172->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=173 andalso Lv=<192->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=193 andalso Lv=<222->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=223 andalso Lv=<252->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=253 andalso Lv=<282->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=283 andalso Lv=<312->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=313 andalso Lv=<342->[{1007000,3},{8001055,1},{1008000,3}];
get_award(Lv)when Lv>=343 andalso Lv=<362->[{1007000,3},{8001055,1},{1008000,3}];
get_award(_) -> [].
