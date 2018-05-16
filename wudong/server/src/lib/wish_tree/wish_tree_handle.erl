%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十一月 2015 10:58
%%%-------------------------------------------------------------------
-module(wish_tree_handle).
-author("hxming").
-include("common.hrl").
-include("server.hrl").
-include("wish_tree.hrl").
%% API
-export([handle_call/3,handle_cast/2,handle_info/2]).

%% 调用接口 player:apply
handle_call({apply,{Module,Function,Args}},_From,State) ->
    Reply =  apply(Module,Function,Args),
    {reply,Reply,State};

%%刷新物品
handle_call({refresh_goods,Player},_From,State) ->
	WishTree = wish_tree_util:get_tree(Player#player.key),
	if
		WishTree#wish_tree.harvest_time =/= -1->
			{reply,{false,7},State};
		WishTree#wish_tree.free_times >= 5 ->
			[Gold,BGold] = money:get_gold(Player#player.key),
			if
				Gold + BGold< ?REFRESH_MONEY->
					{reply,{false,2},State};
				true->
					NewWishTree = wish_tree_util:refresh_goods(WishTree),
					wish_tree_util:put_tree(NewWishTree),
					wish_tree_util:self_wish_pack_send(NewWishTree,Player#player.sid),
					{reply,{ok,?REFRESH_MONEY},State}
			end;
		true ->
			WishTree1 = wish_tree_util:refresh_goods(WishTree),
			NewWishTree = WishTree1#wish_tree{free_times = WishTree#wish_tree.free_times + 1},
			wish_tree_util:put_tree(NewWishTree),
			wish_tree_util:self_wish_pack_send(NewWishTree,Player#player.sid),
			{reply,{ok,0},State}
	end;


%%许愿
handle_call({wish,Player},_From, State) ->
	WishTree = wish_tree_util:get_tree(Player#player.key),
	if
		WishTree#wish_tree.harvest_time > 0 ->
			{ok,Bin} = pt_370:write(37005 ,{8}),
			server_send:send_to_sid(Player#player.sid,Bin),
			{reply,{false,2},State};
		true ->
			if
				WishTree#wish_tree.exp == 0 andalso WishTree#wish_tree.lv == 1 ->
					Harvest_time = util:unixtime() + 5*60;
				is_integer(WishTree#wish_tree.all_visit_record) andalso WishTree#wish_tree.all_visit_record > 0 ->
					Harvest_time = util:unixtime() + WishTree#wish_tree.all_visit_record;
				true ->
					Harvest_time = util:unixtime() + 600*12
			end,
			BaseWish = data_wish_tree:get_wish(WishTree#wish_tree.lv),
			NewWishTree = WishTree#wish_tree{
				pick_goods = wish_tree_util:get_pick_goods(WishTree),
				max_maturity_degree = BaseWish#base_wish.maturity_degree,
				harvest_time = Harvest_time},
			{ok,Bin} = pt_370:write(37005 ,{1}),
			server_send:send_to_sid(Player#player.sid,Bin),
			wish_tree_util:put_tree(NewWishTree),
			wish_tree_load:updata_wish_tree(NewWishTree),
			wish_tree_util:self_wish_pack_send(NewWishTree,Player#player.sid),
			Player#player.pid!{apply_state,{wish_tree_util,get_notice_state,[]}},
			{reply,ok,State}
	end;

%%给自己施肥
handle_call({fertilization_self,Player},_From,State) ->
	WishTree = wish_tree_util:get_tree(Player#player.key),
	[Gold,BGold] = money:get_gold(Player#player.key),
	Now = util:unixtime(),
	case data_wish_tree:get_self_fertilize(WishTree#wish_tree.fertilizer_times + 1) of
		[]->
			{reply,{false,9},State};
		_ when WishTree#wish_tree.harvest_time < Now->
			{reply,{false,14},State};
		_ when WishTree#wish_tree.maturity_degree >= WishTree#wish_tree.max_maturity_degree->
			{reply,{false,10},State};
		BaseWishTree when BaseWishTree#base_wish_tree_fertilize.need_money > Gold + BGold->
			{reply,{false,2},State};
		BaseWishTree ->
			OldMaturityDegree = WishTree#wish_tree.maturity_degree,
			AddMY = ?IF_ELSE(WishTree#wish_tree.lv =:= 1 andalso WishTree#wish_tree.exp =:= 0,WishTree#wish_tree.max_maturity_degree,BaseWishTree#base_wish_tree_fertilize.add_maturity),
			NewValue = OldMaturityDegree + AddMY,
			NewMaturityDegree = ?IF_ELSE(NewValue > WishTree#wish_tree.max_maturity_degree,WishTree#wish_tree.max_maturity_degree,NewValue),
			AddMul = wish_tree_util:get_add_mul(OldMaturityDegree,NewMaturityDegree,WishTree#wish_tree.max_maturity_degree),
			GoodsList = [{GoodsId,Num,Mul+AddMul}||{GoodsId,Num,Mul}<-WishTree#wish_tree.goods_list],
			case WishTree#wish_tree.pick_goods of
				{GoodsIdP,NumP,Mp}->
					NewPickGoods = {GoodsIdP,NumP,Mp+AddMul};
				_->
					NewPickGoods = WishTree#wish_tree.pick_goods
			end,
			NewWishTree = WishTree#wish_tree{
								pick_goods = NewPickGoods,
								goods_list = GoodsList,
								maturity_degree = NewMaturityDegree},
			NewWishTree11 = wish_tree_util:add_exp(NewWishTree, BaseWishTree#base_wish_tree_fertilize.add_exp),
			wish_tree_util:put_tree(NewWishTree11),
			wish_tree_util:self_wish_pack_send(NewWishTree11,Player#player.sid),
			{reply,{ok,BaseWishTree#base_wish_tree_fertilize.need_money,BaseWishTree#base_wish_tree_fertilize.add_maturity},State}
	end;

%%给好友施肥
handle_call({fertilizer_friends,Player,Pkey},_From,State) ->
	WishTree = wish_tree_util:get_tree(Pkey),
	MyWishTree = wish_tree_util:get_tree(Player#player.key),
	Now = util:unixtime(),
	if
		WishTree#wish_tree.harvest_time =:= -1->
			{reply,{false,4},State};
		WishTree#wish_tree.harvest_time < Now->
			{reply,{false,14},State};
		WishTree#wish_tree.maturity_degree >= 100->
			{reply,{false,10},State};
		true->
			[Gold,BGold] = money:get_gold(Player#player.key),
			case lists:keytake(Player#player.key,#visit_record.pkey,WishTree#wish_tree.visit_record) of
				{value,VisitRecord,_L1} when VisitRecord#visit_record.fertilizer_times > 0->
					{reply,{false,9},State};
				VisitRecordOther->
					VisitRecord1 =
					case VisitRecordOther of
						false-> [#visit_record{pkey = Player#player.key,fertilizer_times = 1}|WishTree#wish_tree.visit_record];
						{value,VisitRecord,L1}-> [VisitRecord#visit_record{pkey = Player#player.key,fertilizer_times = VisitRecord#visit_record.fertilizer_times + 1}|L1]
					end,
					case data_wish_tree:get_friends_fertilize(1) of
						[]->
							{reply,{false,9},State};
						BaseWishTreeFertilize when Gold + BGold < BaseWishTreeFertilize#base_wish_tree_fertilize.need_money->
							{reply,{false,2},State};
						BaseWishTreeFertilize->
							MyWishTree11 = wish_tree_util:add_exp(MyWishTree, BaseWishTreeFertilize#base_wish_tree_fertilize.add_exp),
							wish_tree_util:put_tree(MyWishTree11),

							OldMaturityDegree = WishTree#wish_tree.maturity_degree,
							NewValue = OldMaturityDegree + BaseWishTreeFertilize#base_wish_tree_fertilize.add_maturity,
							NewMaturityDegree = ?IF_ELSE(NewValue > WishTree#wish_tree.max_maturity_degree,WishTree#wish_tree.max_maturity_degree,NewValue),
							AddMul = wish_tree_util:get_add_mul(OldMaturityDegree,NewMaturityDegree,WishTree#wish_tree.max_maturity_degree),
							GoodsList = [{GoodsId,Num,Mul+AddMul}||{GoodsId,Num,Mul}<-WishTree#wish_tree.goods_list],
							case WishTree#wish_tree.pick_goods of
								{GoodsIdP,NumP,Mp}->
									NewPickGoods = {GoodsIdP,NumP,Mp+AddMul};
								_->
									NewPickGoods = WishTree#wish_tree.pick_goods
							end,
							NewWishTree = WishTree#wish_tree{
								pick_goods = NewPickGoods,
								goods_list = GoodsList,
								visit_record = VisitRecord1,
								maturity_degree = NewMaturityDegree},
							wish_tree_util:put_tree(NewWishTree),
							case player_util:get_player_online(Pkey) of
								[] -> skip;
								Online ->
									Online#ets_online.pid  ! {add_qinmidu, Player#player.key,{no_db,BaseWishTreeFertilize#base_wish_tree_fertilize.add_intimacy}}
							end,
							{reply,{ok,BaseWishTreeFertilize#base_wish_tree_fertilize.add_intimacy,BaseWishTreeFertilize#base_wish_tree_fertilize.need_money,BaseWishTreeFertilize#base_wish_tree_fertilize.add_maturity},State}
					end
				 end
	end;


handle_call(_Request, _From, State) ->
    {reply, ok, State}.



%% 调用接口 player:apply
handle_cast({apply,{Module,Function,Args}},State) ->
    case apply(Module, Function, Args) of
        {ok, NewState} ->
            {noreply,NewState};
        ok ->
            {noreply, State};
        _Err ->
            ?ERR("apply unkonw return val ~p~n",[_Err]),
            {noreply, State}
    end;


%%获取自己的许愿树信息
handle_cast({get_self_tree_info,Player}, State) ->
	WishTree = wish_tree_util:get_tree(Player#player.key),
	wish_tree_util:self_wish_pack_send(WishTree,Player#player.sid),
	{noreply, State};

%%提醒许愿
handle_cast({remind_wish,SelfPkey,Pkey}, State) ->
	WishTree = wish_tree_util:get_tree(Pkey),
	case lists:keytake(SelfPkey,#visit_record.pkey,WishTree#wish_tree.visit_record) of
		{value,VisitRecord,L1} when VisitRecord#visit_record.watering_time > 0->
			VisitRecord1 = [VisitRecord#visit_record{is_remind = 1}|L1];
		false->
			VisitRecord1 = [#visit_record{pkey =SelfPkey,is_remind = 1}|WishTree#wish_tree.visit_record]
	end,
	wish_tree_util:put_tree(WishTree#wish_tree{visit_record = VisitRecord1}),
	{noreply, State};

%%给自己浇水
handle_cast({watering_self,Player},State) ->
	WishTree = wish_tree_util:get_tree(Player#player.key),
	Now = util:unixtime(),
	if
		WishTree#wish_tree.harvest_time < Now->
			{ok,Bin} = pt_370:write(37007 ,{11,0}),
			server_send:send_to_sid(Player#player.sid,Bin),
			{noreply, State};
		WishTree#wish_tree.last_watering_time > Now->
			{ok,Bin} = pt_370:write(37007 ,{6,0}),
			server_send:send_to_sid(Player#player.sid,Bin),
			{noreply, State};
		true->
			case data_wish_tree:get_self_watering(WishTree#wish_tree.watering_times + 1) of
				[]->
					{ok,Bin} = pt_370:write(37007 ,{15,0}),
					server_send:send_to_sid(Player#player.sid,Bin),
					{noreply, State};
				BaseWishTree ->
					NewWishTree = WishTree#wish_tree{
						last_watering_time = Now + BaseWishTree#base_wish_tree_watering.cd_times,
						watering_times = WishTree#wish_tree.watering_times + 1,
						harvest_time = WishTree#wish_tree.harvest_time - BaseWishTree#base_wish_tree_watering.reduce_times},
					NewWishTree1 = wish_tree_util:add_exp(NewWishTree,BaseWishTree#base_wish_tree_watering.add_exp),
					wish_tree_util:put_tree(NewWishTree1),
					wish_tree_util:self_wish_pack_send(NewWishTree1,Player#player.sid),
					{ok,Bin} = pt_370:write(37007 ,{1,BaseWishTree#base_wish_tree_watering.reduce_times}),
					server_send:send_to_sid(Player#player.sid,Bin),
					Player#player.pid!{apply_state,{wish_tree_util,get_notice_state,[]}},
					{noreply, State}
			end
	end;

%%给好友浇水
handle_cast({watering_friends,Player,Pkey},State) ->
	WishTree = wish_tree_util:get_tree(Pkey),
	MyWishTree = wish_tree_util:get_tree(Player#player.key),
	Now = util:unixtime(),
	if
		WishTree#wish_tree.harvest_time =:= -1->
			{ok,Bin} = pt_370:write(37009  ,{5,Pkey,0}),
			server_send:send_to_sid(Player#player.sid,Bin),
			{noreply, State};
		WishTree#wish_tree.harvest_time < Now->
			{ok,Bin} = pt_370:write(37009  ,{11,Pkey,0}),
			server_send:send_to_sid(Player#player.sid,Bin),
			{noreply, State};
		true->
			BaseWish_tree_watering = data_wish_tree:get_friends_watering(1),
			case lists:keytake(Player#player.key,#visit_record.pkey,WishTree#wish_tree.visit_record) of
				{value,VisitRecord,_L1} when VisitRecord#visit_record.watering_time > 0->
					{ok,Bin} = pt_370:write(37009  ,{15,Pkey,0}),
					server_send:send_to_sid(Player#player.sid,Bin);
				OtherRecord->
					MyWishTree1 = wish_tree_util:add_exp(MyWishTree,BaseWish_tree_watering#base_wish_tree_watering.add_exp),
					wish_tree_util:put_tree(MyWishTree1),
					VisitRecord1 =
					case OtherRecord of
						false->  [#visit_record{pkey = Player#player.key,watering_time = Now}|WishTree#wish_tree.visit_record];
						{value,VisitRecord,L1}->[VisitRecord#visit_record{pkey = Player#player.key,watering_time = Now}|L1]
					end,
					NewWishTree = WishTree#wish_tree{
							visit_record = VisitRecord1,
							harvest_time = WishTree#wish_tree.harvest_time - BaseWish_tree_watering#base_wish_tree_watering.reduce_times},
					wish_tree_util:put_tree(NewWishTree),
					Player#player.pid ! {add_qinmidu, Pkey,BaseWish_tree_watering#base_wish_tree_watering.add_intimacy},
					case player_util:get_player_online(Pkey) of
						[] -> skip;
						Online ->
							Online#ets_online.pid  ! {add_qinmidu, Player#player.key,{no_db,BaseWish_tree_watering#base_wish_tree_watering.add_intimacy}},
							Online#ets_online.pid  ! {apply_state,{wish_tree_util,get_notice_state,[]}}
					end,
					{ok,Bin} = pt_370:write(37009  ,{1,Pkey,BaseWish_tree_watering#base_wish_tree_watering.reduce_times}),
					server_send:send_to_sid(Player#player.sid,Bin),
                    Player#player.pid ! {d_v_trigger, 7, 1}
			end,
			{noreply, State}
	end;


%%收获
handle_cast({harvest_self,Player}, State) ->
	WishTree = wish_tree_util:get_tree(Player#player.key),
	Now = util:unixtime(),
	if
		WishTree#wish_tree.harvest_time == -1 orelse WishTree#wish_tree.harvest_time > Now->
			{ok,Bin} = pt_370:write(37010  ,{16}),
			server_send:send_to_sid(Player#player.sid,Bin);
		true->
			WishTree1 = WishTree#wish_tree{
						pick_goods_record = [],
					    pick_goods = false,
						maturity_degree = 0,
						visit_record = [],
						last_watering_time = 0,
						watering_times = 0,
						fertilizer_times = 0,
						refresh_progress = 0,
						harvest_time = -1
						},
			BaseWish = data_wish_tree:get_wish(WishTree#wish_tree.lv),
			WishTree2 = wish_tree_util:add_exp(WishTree1,BaseWish#base_wish.add_exp),
			WishTree3 = wish_tree_util:refresh_goods(WishTree2),
			NewWishTree = WishTree3#wish_tree{refresh_progress = 0},
			wish_tree_util:put_tree(NewWishTree),
			wish_tree_load:updata_wish_tree(NewWishTree),
			wish_tree_util:self_wish_pack_send(NewWishTree,Player#player.sid),
			Player#player.pid ! {give_goods, [{GoodsId,Num * Mul}||{GoodsId,Num,Mul}<-WishTree#wish_tree.goods_list,Mul>0],163},
			{ok,Bin} = pt_370:write(37010 ,{1}),
			server_send:send_to_sid(Player#player.sid,Bin)
	end,
	{noreply, State};

%%收获好友的果实
handle_cast({harvest_friends,Player,Pkey}, State) ->
	WishTree = wish_tree_util:get_tree(Pkey),
	Now = util:unixtime(),
	if
		WishTree#wish_tree.pick_goods == false->
			{ok,Bin} = pt_370:write(37011  ,{20,Pkey}),
			server_send:send_to_sid(Player#player.sid,Bin);
		WishTree#wish_tree.harvest_time == -1 orelse WishTree#wish_tree.harvest_time > Now->
			{ok,Bin} = pt_370:write(37011  ,{19,Pkey}),
			server_send:send_to_sid(Player#player.sid,Bin);
		true->
			case lists:keytake(Player#player.key,#visit_record.pkey,WishTree#wish_tree.visit_record) of
				{value,VisitRecord,_L1} when VisitRecord#visit_record.is_pick > 0->
					{ok,Bin} = pt_370:write(37011  ,{21,Pkey}),
					server_send:send_to_sid(Player#player.sid,Bin);
				false->
					{ErrorCode,GiveGoods,WishTree1} = wish_tree_util:harvest_friends(WishTree),
					NewWishTree = WishTree1#wish_tree{visit_record = [#visit_record{pkey = Player#player.key,is_pick = 1}|WishTree#wish_tree.visit_record]},
					wish_tree_util:put_tree(NewWishTree),
					Player#player.pid ! {give_goods, GiveGoods,164},
					{ok,Bin} = pt_370:write(37011  ,{ErrorCode,Pkey}),
					server_send:send_to_sid(Player#player.sid,Bin);
				{value,VisitRecord,L1}->
					{ErrorCode,GiveGoods,WishTree1} = wish_tree_util:harvest_friends(WishTree),
					NewWishTree = WishTree1#wish_tree{visit_record = [VisitRecord#visit_record{pkey = Player#player.key,is_pick = 1}|L1]},
					wish_tree_util:put_tree(NewWishTree),
					Player#player.pid ! {give_goods, GiveGoods,ErrorCode},
					{ok,Bin} = pt_370:write(37011  ,{ErrorCode,Pkey}),
					server_send:send_to_sid(Player#player.sid,Bin)
			end
	end,
	{noreply, State};


%%感谢一个好友
handle_cast({thks_friends,Player,Pkey},State) ->
	WishTree = wish_tree_util:get_tree(Player#player.key),
	case lists:keytake(Pkey,#visit_record.pkey,WishTree#wish_tree.visit_record) of
		false->
			{ok,Bin} = pt_370:write(37014 ,{22,0,0}),
			server_send:send_to_sid(Player#player.sid,Bin);
		{value,VisitRecord,_L1} when VisitRecord#visit_record.is_thks =:= 1->
			{ok,Bin} = pt_370:write(37014 ,{23,0,0}),
			server_send:send_to_sid(Player#player.sid,Bin);
		{value,VisitRecord,L1} when VisitRecord#visit_record.is_thks =:= 0->
				WishTree1 = wish_tree_util:add_exp(WishTree,5),
				NewWishTree = WishTree1#wish_tree{visit_record = [VisitRecord#visit_record{is_thks = 1}|L1]},
				wish_tree_util:put_tree(NewWishTree),
				wish_tree_util:self_wish_pack_send(NewWishTree,Player#player.sid),
				{ok,Bin} = pt_370:write(37014 ,{1,1,5}),
				Player#player.pid ! {add_qinmidu, Pkey,1},
				case player_util:get_player_online(Pkey) of
					[] -> skip;
					Online -> Online#ets_online.pid  ! {add_qinmidu, Player#player.key,{no_db,1}}
				end,
				server_send:send_to_sid(Player#player.sid,Bin)
	end,
	{noreply, State};

%%感谢所有的好友
handle_cast({thks_all_friends,Player},State) ->
	WishTree = wish_tree_util:get_tree(Player#player.key),
	Fun = fun(VisitRecord,{Num,Out})->
			if
				VisitRecord#visit_record.is_thks == 0->
					Player#player.pid ! {add_qinmidu, VisitRecord#visit_record.pkey,1},
					case player_util:get_player_online(VisitRecord#visit_record.pkey) of
						[] -> skip;
						Online -> Online#ets_online.pid  ! {add_qinmidu, Player#player.key,{no_db,1}}
					end,
					{Num+1,[VisitRecord#visit_record{is_thks = 1}|Out]};
				true ->
					{Num,[VisitRecord#visit_record{is_thks = 1}|Out]}
			end
		end,
	{SumNum,NewvisitRecord} = lists:foldl(Fun,{0,[]},WishTree#wish_tree.visit_record),
	WishTree1 = wish_tree_util:add_exp(WishTree,5*SumNum),
	NewWishTree = WishTree1#wish_tree{visit_record = NewvisitRecord},
	wish_tree_util:put_tree(NewWishTree),
	wish_tree_util:self_wish_pack_send(NewWishTree,Player#player.sid),
	{ok,Bin} = pt_370:write(37015 ,{1,SumNum,SumNum,5*SumNum}),
	server_send:send_to_sid(Player#player.sid,Bin),
	{noreply, State};

%%一键浇水
handle_cast({all_watering,Player,PkeyKeyList},State) ->
	Now = util:unixtime(),
	BaseWish_tree_watering = data_wish_tree:get_friends_watering(1),
	Fun = fun(Pkey,Num)->
			WishTree = wish_tree_util:get_tree(Pkey),
			if
				WishTree#wish_tree.harvest_time =:= -1 orelse WishTree#wish_tree.harvest_time < Now ->
					Num;
				true->
					case lists:keytake(Player#player.key,#visit_record.pkey,WishTree#wish_tree.visit_record) of
						{value,VisitRecord,_L1} when VisitRecord#visit_record.watering_time > 0->
							Num;
						false->
							Player#player.pid ! {add_qinmidu, Pkey,BaseWish_tree_watering#base_wish_tree_watering.add_intimacy},
							VisitRecord1 = [#visit_record{pkey = Player#player.key,watering_time = Now}|WishTree#wish_tree.visit_record],
							NewWishTree = WishTree#wish_tree{
								visit_record = VisitRecord1,
								harvest_time = WishTree#wish_tree.harvest_time - BaseWish_tree_watering#base_wish_tree_watering.reduce_times},
							wish_tree_util:put_tree(NewWishTree),
							Num+1;
						{value,VisitRecord,L1} when VisitRecord#visit_record.watering_time =:= 0->
							Player#player.pid ! {add_qinmidu, Pkey,BaseWish_tree_watering#base_wish_tree_watering.add_intimacy},
							VisitRecord1 = [VisitRecord#visit_record{pkey = Player#player.key,watering_time = Now}|L1],
							NewWishTree = WishTree#wish_tree{
								visit_record = VisitRecord1,
								harvest_time = WishTree#wish_tree.harvest_time - BaseWish_tree_watering#base_wish_tree_watering.reduce_times},
							wish_tree_util:put_tree(NewWishTree),
							Num+1
					end
			end
		end,
	AddNum = lists:foldl(Fun,0,PkeyKeyList),
	MyWishTree = wish_tree_util:get_tree(Player#player.key),
	NewWishTree = wish_tree_util:add_exp(MyWishTree,5*AddNum),
	wish_tree_util:put_tree(NewWishTree),
	wish_tree_util:self_wish_pack_send(NewWishTree,Player#player.sid),
	{ok,Bin} = pt_370:write(37016 ,{1,AddNum,AddNum,5*AddNum,BaseWish_tree_watering#base_wish_tree_watering.reduce_times}),
	server_send:send_to_sid(Player#player.sid,Bin),
	{noreply, State};


%%快速成熟GM命令
handle_cast({cs_gm,Player},State) ->
	WishTree = wish_tree_util:get_tree(Player#player.key),
	if
		WishTree#wish_tree.harvest_time == -1 -> skip;
		true ->
			NewWishTree = WishTree#wish_tree{harvest_time = util:unixtime()},
			wish_tree_util:put_tree(NewWishTree),
			wish_tree_util:self_wish_pack_send(NewWishTree,Player#player.sid)

	end,
	{noreply, State};

handle_cast(_Request, State) ->
    {noreply, State}.


%% 调用接口 player:apply
handle_info({apply,{Module,Function,Args}},State) ->
    case Module:Function(Args) of
        {ok, NewState} ->
            {noreply, NewState};
        ok ->
            {noreply, State};
        _Err ->
            ?ERR("apply unkonw return val ~p~n",[_Err]),
            {noreply, State}
    end;

%%第二天刷新免费次数
handle_info(midnight_refresh, State) ->
	erlang:send_after(24*3600*1000,self(),midnight_refresh),
	lists:foreach(fun(Wisher)->
						wish_tree_util:put_tree(Wisher#wish_tree{free_times = 0})
				  end,ets:tab2list(?ETS_WISH_TREE)),
	{noreply, State};

%%停止
handle_info({stop}, State) ->
    {stop,normal,State};

handle_info(_Info, State) ->
    {noreply, State}.