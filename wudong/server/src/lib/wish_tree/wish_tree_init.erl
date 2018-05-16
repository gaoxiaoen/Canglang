%%%-------------------------------------------------------------------
%%% @author and_me
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 15:23
%%%-------------------------------------------------------------------
-module(wish_tree_init).
-author("and_me").

-include("wish_tree.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([init_wish_tree/0]).

init_wish_tree()->
		SQL = "select pkey,goods_list,lv,exp,free_times,refresh_progress,orange_goods_list,client_rank_value,maturity_degree,max_maturity_degree,last_watering_time,pick_goods,watering_times,fertilizer_times,harvest_time from wish_tree",
		case db:get_all(SQL) of
			[]->
				skip;
			List->
				Fun = fun([Pkey,Goods_list,Lv,Exp,Free_times,Fefresh_progress,Orange_goods_list,Client_rank_value,Maturity_degree,Max_maturity_degree,Last_watering_time,Pick_goodsBin,Watering_times,Fertilizer_times,Harvest_time])->
					Pick_goods = util:bitstring_to_term(Pick_goodsBin),
					NewWishTree = #wish_tree{
							pkey = Pkey,
							lv = Lv,
							exp = Exp,
							goods_list = util:bitstring_to_term(Goods_list),
							free_times = Free_times,
							refresh_progress = Fefresh_progress,
							orange_goods_list = util:bitstring_to_term(Orange_goods_list),
							client_rank_value = Client_rank_value,
							maturity_degree = Maturity_degree,
							max_maturity_degree = Max_maturity_degree,
							last_watering_time = Last_watering_time,
							pick_goods = ?IF_ELSE(is_tuple(Pick_goods),Pick_goods,false),
							watering_times = Watering_times,
							fertilizer_times = Fertilizer_times,
							harvest_time = Harvest_time
						},
						ets:insert(?ETS_WISH_TREE,NewWishTree)
					end,
					lists:foreach(Fun, List)
		end.



