%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_eliminate_challenge_reward
	%%% @Created : 2017-11-23 20:28:57
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_eliminate_challenge_reward).
-export([get_win/1]).
-export([get_fail/1]).
-include("common.hrl").
get_win(Lv)when Lv>=1 andalso Lv =< 60->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=61 andalso Lv =< 65->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=66 andalso Lv =< 68->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=69 andalso Lv =< 71->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=72 andalso Lv =< 74->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=75 andalso Lv =< 77->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=78 andalso Lv =< 79->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=80 andalso Lv =< 91->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=92 andalso Lv =< 112->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=113 andalso Lv =< 127->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=128 andalso Lv =< 142->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=143 andalso Lv =< 157->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=158 andalso Lv =< 172->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=173 andalso Lv =< 192->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=193 andalso Lv =< 212->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=213 andalso Lv =< 242->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=243 andalso Lv =< 272->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=273 andalso Lv =< 302->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=303 andalso Lv =< 332->{{8001301,2},{8001171,1},{8001302,2}};
get_win(Lv)when Lv>=333 andalso Lv =< 999->{{8001301,2},{8001171,1},{8001302,2}};
get_win(_) -> [].
get_fail(Lv)when Lv>=1 andalso Lv =< 60->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=61 andalso Lv =< 65->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=66 andalso Lv =< 68->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=69 andalso Lv =< 71->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=72 andalso Lv =< 74->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=75 andalso Lv =< 77->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=78 andalso Lv =< 79->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=80 andalso Lv =< 91->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=92 andalso Lv =< 112->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=113 andalso Lv =< 127->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=128 andalso Lv =< 142->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=143 andalso Lv =< 157->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=158 andalso Lv =< 172->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=173 andalso Lv =< 192->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=193 andalso Lv =< 212->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=213 andalso Lv =< 242->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=243 andalso Lv =< 272->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=273 andalso Lv =< 302->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=303 andalso Lv =< 332->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(Lv)when Lv>=333 andalso Lv =< 999->{{8001301,1},{8001172,1},{8001302,1}};
get_fail(_) -> [].
