%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 17:17
%%%-------------------------------------------------------------------
-module(wish_tree_load).
-author("hxming").

-include("wish_tree.hrl").
%% API
-compile(export_all).

add_wish_tree(WishTree)->
    SQL = io_lib:format("insert into wish_tree (pkey,goods_list,lv,exp,free_times,refresh_progress,orange_goods_list,client_rank_value,maturity_degree,max_maturity_degree,last_watering_time,pick_goods,watering_times,fertilizer_times,harvest_time) values
    (~p,'~s',~p,~p,~p,~p,'~s',~p,~p,~p,~p,'~s',~p,~p,~p)",
     [WishTree#wish_tree.pkey,
	  util:term_to_bitstring(WishTree#wish_tree.goods_list),
	  WishTree#wish_tree.lv,
	  WishTree#wish_tree.exp,
	  WishTree#wish_tree.free_times,
	  WishTree#wish_tree.refresh_progress,
		 util:term_to_bitstring(WishTree#wish_tree.orange_goods_list),
	  WishTree#wish_tree.client_rank_value,
	  WishTree#wish_tree.maturity_degree,
		 WishTree#wish_tree.max_maturity_degree,
		 WishTree#wish_tree.last_watering_time,
		 util:term_to_bitstring(WishTree#wish_tree.pick_goods),
		 WishTree#wish_tree.watering_times,
		 WishTree#wish_tree.fertilizer_times,
		 WishTree#wish_tree.harvest_time
		 ]),
    db:execute(SQL).

updata_wish_tree(WishTree)->
	 Sql = io_lib:format("update wish_tree set lv = ~p,exp = ~p,goods_list = '~s',orange_goods_list = '~s',harvest_time = ~p,max_maturity_degree = ~p,maturity_degree = ~p,pick_goods = '~s' where pkey = ~p",
						 [WishTree#wish_tree.lv,
						  WishTree#wish_tree.exp,
							 util:term_to_bitstring(WishTree#wish_tree.goods_list),
							 util:term_to_bitstring(WishTree#wish_tree.orange_goods_list),
							 WishTree#wish_tree.harvest_time,
							 WishTree#wish_tree.max_maturity_degree,
							 WishTree#wish_tree.maturity_degree,
							 util:term_to_bitstring(WishTree#wish_tree.pick_goods),
							 WishTree#wish_tree.pkey]),

     db:execute(Sql).

