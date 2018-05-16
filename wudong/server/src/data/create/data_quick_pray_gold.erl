%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_quick_pray_gold
	%%% @Created : 2016-02-01 21:00:48
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_quick_pray_gold).
-export([get/1]).
-export([get_max_times/0]).
-include("common.hrl").
get(1) ->10;
get(2) ->10;
get(3) ->10;
get(4) ->20;
get(5) ->20;
get(6) ->30;
get(7) ->30;
get(8) ->50;
get(9) ->50;
get(10) ->50;
get(11) ->50;
get(12) ->50;
get(13) ->100;
get(_) -> 99999.

get_max_times()-> 13.