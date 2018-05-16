%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield_dh
	%%% @Created : 2016-06-23 17:48:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield_dh).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").

    ids() ->
    [1,2,3].
get(1)->{3,7,12};
get(2)->{8,15,15};
get(3)->{16,9999,20};
get(_) -> [].
