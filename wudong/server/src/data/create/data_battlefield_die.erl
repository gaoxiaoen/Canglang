%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield_die
	%%% @Created : 2016-06-23 17:48:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield_die).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").

    ids() ->
    [1,2,3,4].
get(1)->{0,200,0};
get(2)->{200,300,20};
get(3)->{301,500,50};
get(4)->{501,99999999,100};
get(_) -> [].
