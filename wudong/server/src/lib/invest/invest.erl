%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2016 下午3:56
%%%-------------------------------------------------------------------
-module(invest).
-author("and_me").
-include("server.hrl").
-include("common.hrl").
-include("invest.hrl").
-include("g_daily.hrl").

%% 协议接口
-export([
	invest_info/1,
    get_invest_award/3,
	get_notice_state/1,
	buy_invest/2,
	is_open/0,
	remaining_time/0
]).

remaining_time()->
	max(0, config:get_opening_time() + get_invest_over_time() - util:unixtime()).

is_open()->
	util:unixtime() < config:get_opening_time() + get_invest_over_time().

get_invest_over_time()->
	case config:get_server_num() of
        20009-> 999 * 3600 *24;
		20007-> 999 * 3600 *24;
		4001-> 10 * 3600 *24;
		4002-> 8 * 3600 *24;
		4003-> 7 * 3600 *24;
		4004-> 6 * 3600 *24;
		4005-> 5 * 3600 *24;
		4006-> 4 * 3600 *24;
		4007-> 4 * 3600 *24;
		_-> 7*3600*24
	end.

invest_info(Player)->
	InvestSt = lib_dict:get(?PROC_STATUS_INVEST),
	RedList = can_get_award(Player,InvestSt),
	OpenTime = config:get_opening_time(),
	Now = util:unixtime(),
	{ok,Bin} = pt_270:write(27000,{max(0,OpenTime + get_invest_over_time() - Now),
						InvestSt#st_invest.is_buy_luxury,
						InvestSt#st_invest.is_buy_extreme,
						g_forever:get_count(?G_FOREVER_TYPE_INVEST),
						RedList,
						[[K,V]||{K,V}<-InvestSt#st_invest.luxury_award],
						[[K,V]||{K,V}<-InvestSt#st_invest.extreme_award],
						[[K,V]||{K,V}<-InvestSt#st_invest.invest_award]}),
	server_send:send_to_sid(Player#player.sid,Bin),
	ok.




buy_invest(Player,Type)->
	InvestSt = lib_dict:get(?PROC_STATUS_INVEST),
	Count = g_forever:increment(?G_FOREVER_TYPE_INVEST),
	case lists:member(Count+1,data_invest:get_free_num()) of
		true->
			Msg1 = io_lib:format(t_tv:get(109), [integer_to_list(Count+1)]),
			notice:add_sys_notice(Msg1, 109);
		_->
			skip
	end,
	{ok,Bin} = pt_270:write(27003 ,{Count+1}),
	server_send:send_to_all(Bin),
	if
		Type == 1->
			NewInvestSt = InvestSt#st_invest{is_buy_luxury = 1},
			invest_load:update_luxury(Player,1);
		Type == 2->
			Msg = io_lib:format(t_tv:get(108), [t_tv:pn(Player)]),
			notice:add_sys_notice(Msg, 108),
			NewInvestSt = InvestSt#st_invest{is_buy_extreme = 1},
			invest_load:update_extreme(Player,1)
	end,
	{ok, BinS} = pt_270:write(27001,{1}),
	server_send:send_to_sid(Player#player.sid,BinS),
	lib_dict:put(?PROC_STATUS_INVEST,NewInvestSt),
	invest_info(Player),
	activity:get_notice(Player,[79],true),
	ok.


check_buy_award(Player,InvestSt,1,BaseInves,AwardId)->
	?ASSERT(Player#player.lv >= BaseInves#base_invest.need_num,{false,7}),
	?ASSERT(InvestSt#st_invest.is_buy_luxury == 1,{false,9}),
	case lists:keyfind(AwardId,1,InvestSt#st_invest.luxury_award) of
		false->
			InvestSt#st_invest{luxury_award = [{AwardId,1}|InvestSt#st_invest.luxury_award]};
		_->
			throw({false,4})
	end;

check_buy_award(Player,InvestSt,2,BaseInves,AwardId)->
	?ASSERT(Player#player.lv >= BaseInves#base_invest.need_num,{false,7}),
	?ASSERT(InvestSt#st_invest.is_buy_extreme == 1,{false,9}),
	case lists:keyfind(AwardId,1,InvestSt#st_invest.extreme_award) of
		false->
			InvestSt#st_invest{extreme_award = [{AwardId,1}|InvestSt#st_invest.extreme_award]};
		_->
			throw({false,4})
	end;

check_buy_award(Player,InvestSt,3,BaseInves,AwardId)->
	?ASSERT(Player#player.vip_lv >= BaseInves#base_invest.need_vip,{false,10}),
	PlayerNum = g_forever:get_count(?G_FOREVER_TYPE_INVEST),
	?ASSERT(PlayerNum >= BaseInves#base_invest.need_num,{false,9}),
	case lists:keyfind(AwardId,1,InvestSt#st_invest.invest_award) of
		false->
			InvestSt#st_invest{invest_award = [{AwardId,1}|InvestSt#st_invest.invest_award]};
		_->
			throw({false,4})
	end;

check_buy_award(_,_,_,_,_)->
	throw({false,44444}).

get_invest_award(Player,Type,AwardId)->
	InvestSt = lib_dict:get(?PROC_STATUS_INVEST),
	BaseInvest = data_invest:get(AwardId),
	NewInvestSt = check_buy_award(Player,InvestSt,Type,BaseInvest,AwardId),
	{ok,NewPlayer} = goods:give_goods_throw(Player,goods:make_give_goods_list(148,BaseInvest#base_invest.goods_list)),
	lib_dict:put(?PROC_STATUS_INVEST,NewInvestSt),
	invest_load:update_award(Player,Type,NewInvestSt),
	{ok,NewPlayer}.


can_get_award1(_,0,_,_)->
	0;

can_get_award1([],_,_,_)->
	0;
can_get_award1([Id|Talil],_IsBuy,AwardList,Num)->
	BaseInvest = data_invest:get(Id),
	case lists:keyfind(Id,1,AwardList) of
		false when Num>= BaseInvest#base_invest.need_num->1;
		_-> can_get_award1(Talil,_IsBuy,AwardList,Num)
	end.

can_get_award(Player,InvestSt)->
	PlayerNum = g_forever:get_count(?G_FOREVER_TYPE_INVEST),
	[[1,can_get_award1(data_invest:get_id_by_type(1),InvestSt#st_invest.is_buy_luxury,InvestSt#st_invest.luxury_award,Player#player.lv)],
		[2,can_get_award1(data_invest:get_id_by_type(2),InvestSt#st_invest.is_buy_extreme,InvestSt#st_invest.extreme_award,Player#player.lv)],
		[3,can_get_award1(data_invest:get_id_by_type(3),1,InvestSt#st_invest.invest_award,PlayerNum)]
		].

get_notice_state(Player)->
	OpenTime = config:get_opening_time(),
	Now = util:unixtime(),
	InvestSt = lib_dict:get(?PROC_STATUS_INVEST),
	AwardInfoList = can_get_award(Player,InvestSt),
	IsTimeOut = Now > OpenTime + get_invest_over_time(),
	if
		InvestSt#st_invest.is_buy_luxury == 0 andalso InvestSt#st_invest.is_buy_extreme == 0 andalso IsTimeOut == true->
			-1;
		true->
			case lists:any(fun([_,Aw])-> Aw == 1 end,AwardInfoList) of
						true-> 1;
						_-> 0
			end
	end.


