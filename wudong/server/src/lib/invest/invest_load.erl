%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2016 下午3:56
%%%-------------------------------------------------------------------
-module(invest_load).
-author("and_me").
-include("common.hrl").
-include("server.hrl").
-include("invest.hrl").

%% API
-export([
	dbget_invest/1,
	update_luxury/2,
	update_extreme/2,
	update_award/3
]).

dbget_invest(Player) ->
	Sql = io_lib:format("select is_buy_luxury,is_buy_extreme,luxury_award,extreme_award,invest_award from invest where pkey =~p",[Player#player.key]),
	case db:get_row(Sql) of
                [] ->
					SqlIn = io_lib:format(<<"insert into invest set pkey=~p,is_buy_luxury=~p,is_buy_extreme=~p,luxury_award='~s',extreme_award='~s',invest_award='~s'">>, [Player#player.key, 0, 0, "[]", "[]", "[]"]),
					db:execute(SqlIn),
					{0,0,<<"[]">>,<<"[]">>,<<"[]">>};
                [Is_buy_luxury,Is_buy_extreme,Luxury_award,Extreme_award,Invest_award] ->
					{Is_buy_luxury,Is_buy_extreme,Luxury_award,Extreme_award,Invest_award}
    end.

update_luxury(Player,Res)->
	Sql = io_lib:format("update invest set is_buy_luxury=~p where pkey = ~p", [Res,Player#player.key]),
	db:execute(Sql).

update_extreme(Player,Res)->
	Sql = io_lib:format("update invest set is_buy_extreme=~p where pkey = ~p", [Res,Player#player.key]),
	db:execute(Sql).

update_award(Player,1,InvestSt)->
	Sql = io_lib:format("update invest set luxury_award='~s' where pkey = ~p", [util:term_to_bitstring(InvestSt#st_invest.luxury_award),Player#player.key]),
	db:execute(Sql);

update_award(Player,2,InvestSt)->
	Sql = io_lib:format("update invest set extreme_award='~s' where pkey = ~p", [util:term_to_bitstring(InvestSt#st_invest.extreme_award),Player#player.key]),
	db:execute(Sql);

update_award(Player,3,InvestSt)->
	Sql = io_lib:format("update invest set invest_award='~s' where pkey = ~p", [util:term_to_bitstring(InvestSt#st_invest.invest_award),Player#player.key]),
	db:execute(Sql).
