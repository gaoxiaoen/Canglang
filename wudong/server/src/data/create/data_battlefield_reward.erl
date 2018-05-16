%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield_reward
	%%% @Created : 2016-06-23 17:48:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield_reward).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").

    ids() ->
    [1,2,3,4,5].
get(1)->{1,1,[{27113,2}]};
get(2)->{2,3,[{27113,1}]};
get(3)->{4,10,[{27112,1}]};
get(4)->{11,50,[{27111,2}]};
get(5)->{51,999,[{27111,1}]};
get(_) -> [].
