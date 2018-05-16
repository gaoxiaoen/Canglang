%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_eliminate_reward
	%%% @Created : 2017-11-23 20:28:57
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_eliminate_reward).
-export([get/1]).
-include("common.hrl").
get(Rank) when Rank>=1 andalso Rank =< 1->{{2001000,5},{2002000,15},{2005000,10}};
get(Rank) when Rank>=2 andalso Rank =< 2->{{2001000,4},{2002000,12},{2005000,9}};
get(Rank) when Rank>=3 andalso Rank =< 3->{{2001000,4},{2002000,10},{2005000,8}};
get(Rank) when Rank>=4 andalso Rank =< 10->{{2001000,3},{2002000,8},{2005000,8}};
get(Rank) when Rank>=11 andalso Rank =< 20->{{2001000,3},{2002000,7},{2005000,7}};
get(Rank) when Rank>=51 andalso Rank =< 100->{{2001000,2},{2002000,6},{2005000,7}};
get(Rank) when Rank>=101 andalso Rank =< 10000->{{2001000,2},{2002000,5},{2005000,6}};
get(_) -> [].
