%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield_kdh
	%%% @Created : 2016-06-23 17:48:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield_kdh).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").

    ids() ->
    [1,2,3].
get(1)->{3,7,10};
get(2)->{8,15,40};
get(3)->{16,9999,200};
get(_) -> [].
