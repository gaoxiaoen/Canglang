%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_fruit_rank_reward
	%%% @Created : 2017-11-23 20:34:00
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_fruit_rank_reward).
-export([get/1]).
-export([get_all/0]).
-include("cross_fruit.hrl").
get(Rank) when 1 =< Rank andalso 1 >= Rank -> #base_week_rank{min_rank = 1,max_rank = 1, goods_list = [{2001000,5},{2002000,15},{2005000,10}]};
get(Rank) when 2 =< Rank andalso 2 >= Rank -> #base_week_rank{min_rank = 2,max_rank = 2, goods_list = [{2001000,4},{2002000,12},{2005000,9}]};
get(Rank) when 3 =< Rank andalso 3 >= Rank -> #base_week_rank{min_rank = 3,max_rank = 3, goods_list = [{2001000,4},{2002000,10},{2005000,8}]};
get(Rank) when 4 =< Rank andalso 10 >= Rank -> #base_week_rank{min_rank = 4,max_rank = 10, goods_list = [{2001000,3},{2002000,8},{2005000,8}]};
get(Rank) when 11 =< Rank andalso 20 >= Rank -> #base_week_rank{min_rank = 11,max_rank = 20, goods_list = [{2001000,3},{2002000,7},{2005000,7}]};
get(Rank) when 51 =< Rank andalso 100 >= Rank -> #base_week_rank{min_rank = 51,max_rank = 100, goods_list = [{2001000,2},{2002000,6},{2005000,7}]};
get(Rank) when 101 =< Rank andalso 10000 >= Rank -> #base_week_rank{min_rank = 101,max_rank = 10000, goods_list = [{2001000,2},{2002000,5},{2005000,6}]};
get(_) -> [].

get_all() -> [1,2,3,4,11,51,101].
