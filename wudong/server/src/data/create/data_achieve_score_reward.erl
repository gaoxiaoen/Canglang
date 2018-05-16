%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_achieve_score_reward
	%%% @Created : 2017-08-21 14:00:40
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_achieve_score_reward).
-export([id_list/0]).
-export([get_lv/1]).
-export([get_goods/1]).
-include("common.hrl").
-include("achieve.hrl").

    id_list() ->
    [1,2,3,4,5].
get_lv(1) ->10;
get_lv(2) ->20;
get_lv(3) ->30;
get_lv(4) ->40;
get_lv(5) ->50;
get_lv(_) -> [].


get_goods(1) ->{{20340,50}};
get_goods(2) ->{{8001069,20}};
get_goods(3) ->{{8001085,50}};
get_goods(4) ->{{8001057,100}};
get_goods(5) ->{{4103004,1}};
get_goods(_) -> [].


