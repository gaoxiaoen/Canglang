%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_panic_buying
%%% @Created : 2016-08-17 17:28:54
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_panic_buying).
-export([ids/0]).
-export([get/1]).
-include("panic_buying.hrl").

    ids() ->
    [1,2,3,4,5,6,7].
get(1) ->
	#base_panic_buying{id = 1 ,type = 1 ,goods_id = 22517 ,num = 1 ,times = 2000 ,time = 28800 ,ratio = 10000 };
get(2) ->
	#base_panic_buying{id = 2 ,type = 2 ,goods_id = 53036 ,num = 1 ,times = 1000 ,time = 28800 ,ratio = 3333 };
get(3) ->
	#base_panic_buying{id = 3 ,type = 2 ,goods_id = 53031 ,num = 1 ,times = 1000 ,time = 28800 ,ratio = 3333 };
get(4) ->
	#base_panic_buying{id = 4 ,type = 2 ,goods_id = 53035 ,num = 1 ,times = 1000 ,time = 28800 ,ratio = 3333 };
get(5) ->
	#base_panic_buying{id = 5 ,type = 3 ,goods_id = 24506 ,num = 1 ,times = 200 ,time = 500 ,ratio = 3333 };
get(6) ->
	#base_panic_buying{id = 6 ,type = 3 ,goods_id = 24637 ,num = 1 ,times = 300 ,time = 500 ,ratio = 3333 };
get(7) ->
	#base_panic_buying{id = 7 ,type = 3 ,goods_id = 24505 ,num = 1 ,times = 50 ,time = 500 ,ratio = 3333 };
get(_) -> [].