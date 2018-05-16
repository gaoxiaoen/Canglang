%%%-------------------------------------------------------------------
%%% @author and_me
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 13:49
%%%-------------------------------------------------------------------
-module(wish_tree_util).
-author("and_me").

-include("wish_tree.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").

%% API
-export([init_tree/0,
		 add_exp/2,
		 get_tree/1,
		 put_tree/1,
		 refresh_goods/1,
		 harvest_friends/1,
		 get_add_mul/3,
		 get_pick_goods/1,
		 get_notice_state/1,
		 get_notice_state/2,
		 check_upgrade_state/1,
		 self_wish_pack_send/2]).

init_tree()->
	ok.

refresh_goods(WishTree)->
	refresh_goods(WishTree,false).
refresh_goods(WishTree,IsFirst)->
	BaseWish = data_wish_tree:get_wish(WishTree#wish_tree.lv),
	if
		IsFirst == true-> %%第一次刷新配合新手引导
			AddPR = 0, List = BaseWish#base_wish.goods_list;
		true->
			AddPR = ?IF_ELSE(WishTree#wish_tree.lv =:= 1 andalso WishTree#wish_tree.exp =:= 0,BaseWish#base_wish.max_ref_process,BaseWish#base_wish.add_ref),
			List = BaseWish#base_wish.goods_list ++ BaseWish#base_wish.orange_goods_list
	end,
	OldRP = WishTree#wish_tree.refresh_progress,
	MaxPR = BaseWish#base_wish.max_ref_process,
	Value = ?IF_ELSE(OldRP >= MaxPR,AddPR,min(OldRP + AddPR,MaxPR)),
	Fun = fun(_,{OrageOut,Out,IsMax,TimeOut})->
			if
				IsMax == true->
					{GoodsId,Num,_P,NeedTime} = util:get_weight_item(3,BaseWish#base_wish.orange_goods_list),
					{[GoodsId|OrageOut],[{GoodsId,Num,1}|Out],clear,TimeOut+NeedTime};
				true->
					{GoodsId,Num,_P,NeedTime} = util:get_weight_item(3,List),
					case lists:keyfind(GoodsId,1,BaseWish#base_wish.orange_goods_list) of
						false->
							{OrageOut,[{GoodsId,Num,1}|Out],IsMax,TimeOut+NeedTime};
						_->
							{[GoodsId|OrageOut],[{GoodsId,Num,1}|Out],IsMax,TimeOut+NeedTime}
					end
			end
			end,
	{OrangeGoodsList,GoodsList,_,NeedTime} = lists:foldl(Fun,{[],[],Value >= BaseWish#base_wish.max_ref_process,0},lists:seq(1,6)),
	NewWishTree = WishTree#wish_tree{
									  all_visit_record	= NeedTime,
									  max_maturity_degree = BaseWish#base_wish.maturity_degree,
									  orange_goods_list	= OrangeGoodsList,
									  client_rank_value = util:rand(1,50),
									  refresh_progress = Value,
		  							  goods_list = GoodsList},
%	?PRINT("GoodsList ~p NewRefreshProgress ~p ~n",[GoodsList,NewRefreshProgress]),
	NewWishTree.



get_pick_goods(WishTree)->
	GoodsList = WishTree#wish_tree.goods_list,
	OrangeGoodsList = WishTree#wish_tree.orange_goods_list,
	PickGoodsList = [{GoodsId,Num,Multiple}||{GoodsId,Num,Multiple}<-GoodsList,lists:member(GoodsId,OrangeGoodsList) =:= false,Multiple > 0],
	PcikMinNum = 3 - length(OrangeGoodsList),
	case PcikMinNum > 0 andalso length(PickGoodsList) > PcikMinNum of
		true->
			lists:nth(util:rand(1,length(PickGoodsList)),PickGoodsList);
		false->
			taking_goods_list(PickGoodsList)
	end.

taking_goods_list([])-> false;
taking_goods_list(GoodsList)->
	case lists:nth(util:rand(1,length(GoodsList)),GoodsList) of
		{Goods,Num,Mul} when Mul > 1->
			{Goods,Num,Mul};
		{Goods,Num,Mul}->
			taking_goods_list(lists:delete({Goods,Num,Mul},GoodsList))
	end.

harvest_friends(WishTree)->
	case util:rand(1,2) =:= 1 of
		false->
			{18,[],WishTree};
		_->
			GoodsList = WishTree#wish_tree.goods_list,
			case lists:member(WishTree#wish_tree.pick_goods,WishTree#wish_tree.goods_list) of
				false->
					%?ERR("pick_goods ~p goods_list ~p ~n",[WishTree#wish_tree.pick_goods,WishTree#wish_tree.goods_list]),
					{18,[],WishTree};
				_->
					{GoodsId,Num,Mul} = WishTree#wish_tree.pick_goods,
					NewGoodsList = [{GoodsId,Num,Mul-1}|lists:delete(WishTree#wish_tree.pick_goods,GoodsList)],
					WishTree1 = WishTree#wish_tree{pick_goods_record = [[GoodsId,Num]|WishTree#wish_tree.pick_goods_record],
												    goods_list = NewGoodsList},
					NewPickGoods = get_pick_goods(WishTree1),
					{1,[{GoodsId,Num}],WishTree1#wish_tree{pick_goods = NewPickGoods}}
			end
	end.


new_tree(Pkey)->
	WishTree = #wish_tree{lv = 1,pkey = Pkey},
	WishTree1 = refresh_goods(WishTree,true),
	WishTree1#wish_tree{refresh_progress = 0}.

get_tree(Pkey)->
	case ets:lookup(?ETS_WISH_TREE,Pkey) of
		[]->
			NewWishTree = new_tree(Pkey),
			wish_tree_load:add_wish_tree(NewWishTree),
			ets:insert(?ETS_WISH_TREE,NewWishTree),
			NewWishTree;
		[WishTree]->
			WishTree
	end.

put_tree(WishTree)->
	ets:insert(?ETS_WISH_TREE,WishTree),
	ok.

self_wish_pack_send(WishTree,Sid)->
	Now = util:unixtime(),
	Time = ?IF_ELSE(WishTree#wish_tree.harvest_time == -1,-1,max(0,WishTree#wish_tree.harvest_time - Now)),
	WishTreeFertilize = data_wish_tree:get_self_fertilize(WishTree#wish_tree.fertilizer_times + 1),
	Money = ?IF_ELSE(WishTreeFertilize == [],0,WishTreeFertilize#base_wish_tree_fertilize.need_money),
	WishTreeFertilize = data_wish_tree:get_self_fertilize(WishTree#wish_tree.fertilizer_times + 1),
	RefMoney = ?IF_ELSE(WishTree#wish_tree.free_times >=5,?REFRESH_MONEY,0),
	BaseWish = data_wish_tree:get_wish(WishTree#wish_tree.lv),
	{ok,Bin} = pt_370:write(37002 ,{WishTree#wish_tree.lv,WishTree#wish_tree.exp,Time,WishTree#wish_tree.maturity_degree,WishTree#wish_tree.max_maturity_degree,
									max(0,WishTree#wish_tree.last_watering_time - Now),Money,RefMoney,
									5 - WishTree#wish_tree.free_times,5,
									trunc(WishTree#wish_tree.refresh_progress/BaseWish#base_wish.max_ref_process*100),
		                            WishTree#wish_tree.client_rank_value,
									[[GoodsId,Num,Mul]||{GoodsId,Num,Mul}<- WishTree#wish_tree.goods_list]}),
	server_send:send_to_sid(Sid,Bin),
	ok.


add_exp(WishTree,Exp)->
	BaseWish = data_wish_tree:get_wish(WishTree#wish_tree.lv),
	Next = data_wish_tree:get_wish(WishTree#wish_tree.lv + 1),
	if
		WishTree#wish_tree.exp + Exp > BaseWish#base_wish.lv_up_exp andalso Next =/= []->
			add_exp(WishTree#wish_tree{lv = WishTree#wish_tree.lv + 1,exp = 0},WishTree#wish_tree.exp + Exp - BaseWish#base_wish.lv_up_exp);
		WishTree#wish_tree.exp + Exp >= BaseWish#base_wish.lv_up_exp andalso Next == []->
			WishTree#wish_tree{exp = BaseWish#base_wish.lv_up_exp};
		true->
			WishTree#wish_tree{exp =WishTree#wish_tree.exp + Exp}
	end.

get_add_mul(OldValue,NewValue,MaxValue)->
	if
		NewValue/MaxValue >= 1 andalso OldValue/MaxValue < 1->
			1;
		true->
			0
	end.

get_notice_state(_,Player)->
	activity:get_notice(Player, [84], true),
	ok.

get_notice_state(Player)->
	Now = util:unixtime(),
	case ets:lookup(?ETS_WISH_TREE,Player#player.key) of
		[]-> 0;
		[WishTree] when WishTree#wish_tree.harvest_time =:= -1-> 0;
		[WishTree] when WishTree#wish_tree.harvest_time =< Now-> 1;
		[WishTree] when WishTree#wish_tree.harvest_time> Now->
			catch erlang:cancel_timer(get(wish_tree_self_timer)),
			Ref = erlang:send_after((WishTree#wish_tree.harvest_time -Now) *1000,self(),{wish_tree_util,get_notice_state,[]}),
			put(wish_tree_self_timer,Ref),
			0;
		_->0
	end.

check_upgrade_state(Player)->
	Now = util:unixtime(),
	case ets:lookup(?ETS_WISH_TREE,Player#player.key) of
		[]-> 1;
		[WishTree] when WishTree#wish_tree.harvest_time < Now-> 1;
		_->0
	end.
