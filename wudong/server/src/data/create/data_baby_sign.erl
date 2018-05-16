%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_baby_sign
	%%% @Created : 2018-03-28 11:26:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_baby_sign).
-export([get/2]).
-export([get_all/1]).
-include("common.hrl").
-include("baby.hrl").
get(1,1) ->
	#base_baby_sign{type = 1 ,dayt = 1 ,award = [{7301001,1}] };
get(1,2) ->
	#base_baby_sign{type = 1 ,dayt = 2 ,award = [{7301001,1}] };
get(1,3) ->
	#base_baby_sign{type = 1 ,dayt = 3 ,award = [{7301001,1}] };
get(1,4) ->
	#base_baby_sign{type = 1 ,dayt = 4 ,award = [{7301001,1}] };
get(1,5) ->
	#base_baby_sign{type = 1 ,dayt = 5 ,award = [{7301001,1}] };
get(1,6) ->
	#base_baby_sign{type = 1 ,dayt = 6 ,award = [{7301001,1}] };
get(1,7) ->
	#base_baby_sign{type = 1 ,dayt = 7 ,award = [{7301001,3}] };
get(2,1) ->
	#base_baby_sign{type = 2 ,dayt = 1 ,award = [{7301001,1}] };
get(2,2) ->
	#base_baby_sign{type = 2 ,dayt = 2 ,award = [{7301001,1}] };
get(2,3) ->
	#base_baby_sign{type = 2 ,dayt = 3 ,award = [{7301001,1}] };
get(2,4) ->
	#base_baby_sign{type = 2 ,dayt = 4 ,award = [{7301001,1}] };
get(2,5) ->
	#base_baby_sign{type = 2 ,dayt = 5 ,award = [{7301001,1}] };
get(2,6) ->
	#base_baby_sign{type = 2 ,dayt = 6 ,award = [{7301001,1}] };
get(2,7) ->
	#base_baby_sign{type = 2 ,dayt = 7 ,award = [{7301001,3}] };
get(_,_) -> [].

get_all(1) -> [1,2,3,4,5,6,7];
get_all(2) -> [1,2,3,4,5,6,7];
get_all(_) -> [].
