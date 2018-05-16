%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_luck_value
	%%% @Created : 2016-09-13 15:58:36
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_luck_value).
-export([get/1]).
-include("error_code.hrl").
get(1) ->20;
get(11) ->20;
get(21) ->20;
get(31) ->20;
get(41) ->20;
get(51) ->50;
get(61) ->100;
get(71) ->100;
get(81) ->100;
get(91) ->100;
get(101) ->100;
get(_Data) -> throw({false,0}).