%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2016 下午3:56
%%%-------------------------------------------------------------------
-module(invest_init).
-author("and_me").
-include("server.hrl").
-include("common.hrl").
-include("invest.hrl").

%% API
-export([
    init/1
]).

init(Player) ->
	case player_util:is_new_role(Player) of
		true->
			SqlIn = io_lib:format("insert into invest set pkey=~p,is_buy_luxury=~p,is_buy_extreme=~p,luxury_award='~s',extreme_award='~s',invest_award='~s'", [Player#player.key, 0, 0, "[]", "[]", "[]"]),
			db:execute(SqlIn),
			StInvest = #st_invest{};
		false->
			{Is_buy_luxury,Is_buy_extreme,Luxury_award,Extreme_award,Invest_award} = invest_load:dbget_invest(Player),
			LuxuryAward = old_data(Player,1,util:bitstring_to_term(Luxury_award)),
			ExtremeAward = old_data(Player,2,util:bitstring_to_term(Extreme_award)),
			InvestAward = old_data(Player,3,util:bitstring_to_term(Invest_award)),
			StInvest = #st_invest{
									is_buy_luxury = Is_buy_luxury,
									is_buy_extreme = Is_buy_extreme,
									luxury_award = LuxuryAward,
									extreme_award = ExtremeAward,
									invest_award = InvestAward}
	end,

    lib_dict:put(?PROC_STATUS_INVEST, StInvest),
    Player.


old_data(_Player,3,AwardList)->
	PlayerNum = g_forever:get_count(1),
	List = data_invest:get_id_by_type(3),
	AwardList1 = [{Id,State}||{Id,State}<-AwardList,lists:member(Id,List)],
	Fun = fun({IId,State},Out)->
		BaseInvest = data_invest:get(IId),
		if BaseInvest#base_invest.need_num =< PlayerNum->
			[{IId,State}|Out];
			true->
				Out
		end
		  end,
	lists:foldl(Fun,[],AwardList1);

old_data(Player,Type,AwardList)->
	List = data_invest:get_id_by_type(Type),
	AwardList1 = [{Id,State}||{Id,State}<-AwardList,lists:member(Id,List)],
	Fun = fun({IId,State},Out)->
				BaseInvest = data_invest:get(IId),
				if BaseInvest#base_invest.need_num =< Player#player.lv->
					[{IId,State}|Out];
					true->
						Out
				end
		  end,
	lists:foldl(Fun,[],AwardList1).


