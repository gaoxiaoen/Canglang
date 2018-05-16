%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_battlefield_target
	%%% @Created : 2017-11-15 14:28:34
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_battlefield_target).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").

    ids() ->
    [100,200,500,1000,2000,5000].
get(100) ->{{8001085,1},{8002401,2},{1007000,1}};
get(200) ->{{8001085,1},{8002401,2},{1007000,1}};
get(500) ->{{8001085,2},{8002401,3},{1007000,1}};
get(1000) ->{{8001085,2},{8002401,3},{1007000,1}};
get(2000) ->{{8001085,3},{8002401,4},{1007000,1}};
get(5000) ->{{8001085,3},{8002401,5},{1007000,1}};
get(_) -> [].
