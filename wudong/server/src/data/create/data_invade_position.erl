%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_invade_position
	%%% @Created : 2016-06-07 20:56:20
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_invade_position).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").
-include("invade.hrl").

    ids() ->
    [1,2,3,4,5,6,7,8,9,10].
get(1)->{34,46};
get(2)->{56,72};
get(3)->{72,96};
get(4)->{31,88};
get(5)->{41,23};
get(6)->{62,39};
get(7)->{11,29};
get(8)->{14,65};
get(9)->{69,61};
get(10)->{19,97};
get(_) -> [].
