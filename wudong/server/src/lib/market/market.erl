%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 三月 2018 15:49
%%%-------------------------------------------------------------------
-module(market).
-author("li").

-include("market.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").

%% API
-export([
    midnight_refresh/0,
    update/0,
    clean_fail_reward/0,
    update_sell_num/1,
    update_sell_num/2
]).

update_sell_num(_Market, Player) ->
    St = lib_dict:get(?PROC_STATUS_MARKET),
    NewSt = St#st_market_p{sell_num = St#st_market_p.sell_num+1},
    lib_dict:put(?PROC_STATUS_MARKET, NewSt),
    market_load:update_market_p(NewSt),
    {ok, Player}.

update_sell_num(Market) ->
    #market{pkey = Pkey} = Market,
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
            St = market_load:load_market_p(Pkey),
            NewSt = St#st_market_p{sell_num = St#st_market_p.sell_num+1},
            market_load:update_market_p(NewSt);
        [#ets_online{pid = Pid}] ->
            player:apply_state(async, Pid, {?MODULE, update_sell_num, Market})
    end.

clean_fail_reward() ->
    market_load:clean_market_p_data(),
    ok.

midnight_refresh() ->
    midnight_refresh_update(),
    ok.

midnight_refresh_update() ->
    St = lib_dict:get(?PROC_STATUS_MARKET),
    #st_market_p{op_time = OpTime} = St,
    Now = util:unixtime(),
    case util:is_same_date(OpTime, Now) of
        false -> NewSt = St#st_market_p{buy_num = 0, sell_num = 0, op_time = Now};
        true -> NewSt = St
    end,
    lib_dict:put(?PROC_STATUS_MARKET, NewSt).

update() ->
    St = lib_dict:get(?PROC_STATUS_MARKET),
    #st_market_p{op_time = OpTime} = St,
    Now = util:unixtime(),
    case util:is_same_date(OpTime, Now) of
        false -> NewSt = St#st_market_p{buy_num = 0, op_time = Now};
        true -> NewSt = St
    end,
    lib_dict:put(?PROC_STATUS_MARKET, NewSt).
