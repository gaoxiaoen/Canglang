%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 七月 2017 11:13
%%%-------------------------------------------------------------------
-module(act_wealth_cat).
-include("activity.hrl").
-include("daily.hrl").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    get_info/1
    , draw/2
    , init_ets/0
    , get_act/0
    , get_state/1
    , reset/0
]).

get_info(_Player) ->
    LeaveTime = activity:get_leave_time(data_act_wealth_cat),
    Count = max(0, 1 - daily:get_count(?DAILY_PLANT_WEALTH_CAT)),
    {Vals, Ratios} =
        case get_act() of
            [] -> {[], []};
            Base ->
                Vals0 = Base#base_wealth_cat.vals,
                Ratios0 = [[Id, Mul] || {Id, Mul, _} <- Base#base_wealth_cat.ratio_list],
                {Vals0, Ratios0}
        end,
    LogList = get_log(),
    {LeaveTime, Count, Vals, Ratios, LogList}.

draw(Player, Val) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            Vals = Base#base_wealth_cat.vals,
            RatioList = Base#base_wealth_cat.ratio_list,
            case lists:member(Val, Vals) of
                false -> {false, 22}; %% 没有相应档次
                true ->
                    case money:is_enough(Player, Val, gold) of
                        false -> {false, 5}; %% 元宝不足
                        true ->
                            Daily = daily:get_count(?DAILY_PLANT_WEALTH_CAT),
                            if
                                Daily >= 1 -> {false, 23}; %% 今日已参与
                                true ->
                                    RatioList0 = [{Mul, Ratio0} || {_, Mul, Ratio0} <- RatioList],
                                    Ratio = util:list_rand_ratio(RatioList0),
                                    {Id, _, _} = lists:keyfind(Ratio, 2, RatioList),
                                    daily:increment(?DAILY_PLANT_WEALTH_CAT, 1),
                                    NewPlayer = money:add_no_bind_gold(Player, -Val, 293, 0, 0),
                                    NewPlayer1 = money:add_bind_gold(NewPlayer, util:ceil(Val * (Ratio / 100)), 293, 0, 0),
                                    log_act_wealth(Player#player.key, Player#player.nickname, Player#player.lv, Val, util:ceil(Val * (Ratio / 100))),
                                    insert(Base#base_wealth_cat.act_id, Player#player.nickname, Val, Ratio),
                                    activity:get_notice(Player, [140], true),
                                    {ok, Id, util:ceil(Val * (Ratio / 100)), NewPlayer1}
                            end
                    end
            end
    end.

get_act() ->
    case activity:get_work_list(data_act_wealth_cat) of
        [] -> [];
        [Base | _] -> Base
    end.

init_ets() ->
    ets:new(?ETS_ACT_WEALTH_CAT_LOG, [{keypos, #act_wealth_cat_log.act_id} | ?ETS_OPTIONS]),
    ok.

get_log() ->
    case get_act() of
        [] ->
            [];
        #base_wealth_cat{act_id = BaseActId} ->
            Ets = look_up(BaseActId),
            LogList = Ets#act_wealth_cat_log.log,
            lists:sublist(LogList, 15)
    end.

look_up(ActId) ->
    case ets:lookup(?ETS_ACT_WEALTH_CAT_LOG, ActId) of
        [] ->
            ets:insert(?ETS_ACT_WEALTH_CAT_LOG, #act_wealth_cat_log{act_id = ActId}),
            #act_wealth_cat_log{act_id = ActId};
        [Ets] ->
            Ets
    end.

insert(ActId, Nickname, Cost, Ratio) ->
    Ets = look_up(ActId),
    NewLog = [[Nickname, Cost, Ratio] | Ets#act_wealth_cat_log.log],
    NewEts = Ets#act_wealth_cat_log{log = NewLog},
    ets:insert(?ETS_ACT_WEALTH_CAT_LOG, NewEts),
    ok.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        #base_wealth_cat{act_info = ActInfo} ->
            Daily = daily:get_count(?DAILY_PLANT_WEALTH_CAT),
            Args = activity:get_base_state(ActInfo),
            if
                Daily >= 1 -> {0, Args};
                true -> {1, Args}
            end
    end.

reset() ->
    daily:set_count(?DAILY_PLANT_WEALTH_CAT, 0),
    ok.

log_act_wealth(Pkey, Nickname, Lv, CostGold, AddGold) ->
    Sql = io_lib:format("insert into  log_act_wealth_cat (pkey, nickname,lv,cost_gold,add_gold,time) VALUES(~p,'~s',~p,~p,~p,~p)",
        [Pkey, Nickname, Lv, CostGold, AddGold, util:unixtime()]),
    log_proc:log(Sql),
    ok.