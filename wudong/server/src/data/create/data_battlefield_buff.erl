%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield_buff
	%%% @Created : 2016-06-23 17:48:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield_buff).
-export([ids/0,get/1]).
-include("common.hrl").
-include("battlefield.hrl").

    ids() ->
    [42111,42112,42113,42114,42115,42116,42117,42118].
get(42111)->[18,49];
get(42112)->[30,59];
get(42113)->[41,82];
get(42114)->[47,68];
get(42115)->[57,59];
get(42116)->[69,49];
get(42117)->[46,25];
get(42118)->[39,37];
get(_) -> [].
