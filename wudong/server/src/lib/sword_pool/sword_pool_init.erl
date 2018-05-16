%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2016 10:04
%%%-------------------------------------------------------------------
-module(sword_pool_init).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("sword_pool.hrl").

%% API
-export([
    init/1
    , midnight_refresh/2
    , timer_update/0
    , logout/0
    , calc_sword_pool_attribute/1
    , get_sword_pool_attribute/0
    , fetch_base_times/2
]).

%%初始化
init(Player) ->
    Now = util:unixtime(),
    NowFigure =
        case player_util:is_new_role(Player) of
            true ->
                lib_dict:put(?PROC_STATUS_SWORD_POOL, #st_sword_pool{pkey = Player#player.key, time = Now}),
                0;
            false ->
                case sword_pool_load:load(Player#player.key) of
                    [] ->
                        lib_dict:put(?PROC_STATUS_SWORD_POOL, #st_sword_pool{pkey = Player#player.key, time = Now}),
                        0;
                    [Figure, Lv, Exp, TargetList, ExpDaily, GoodsDaily, Time, FindBackList] ->
                        Attribute = calc_sword_pool_attribute(Lv),
                        Cbp = attribute_util:calc_combat_power(Attribute),
                        St = #st_sword_pool{pkey = Player#player.key, figure = Figure, lv = Lv, exp = Exp, attribute = Attribute, cbp = Cbp},
                        TargetList1 = util:bitstring_to_term(TargetList),
                        case util:is_same_date(Now, Time) of
                            true ->
                                lib_dict:put(?PROC_STATUS_SWORD_POOL, St#st_sword_pool{exp_daily = ExpDaily, goods_daily = GoodsDaily, time = Time, target_list = TargetList1, find_back_list = util:bitstring_to_term(FindBackList)});
                            false ->
                                FindBackList1 = calc_find_back(Player#player.lv, TargetList1),
                                lib_dict:put(?PROC_STATUS_SWORD_POOL, St#st_sword_pool{exp_daily = 0, goods_daily = 0, time = Now, find_back_list = FindBackList1, is_change = 1})
                        end,
                        Figure
                end
        end,
    Player#player{sword_pool_figure = NowFigure}.

%%定时更新
timer_update() ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    if St#st_sword_pool.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_SWORD_POOL, St#st_sword_pool{is_change = 0}),
        sword_pool_load:replace(St);
        true -> ok
    end.


%%离线
logout() ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    if St#st_sword_pool.is_change == 1 ->
        sword_pool_load:replace(St);
        true -> ok
    end.

%%零点
midnight_refresh(Player, Now) ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    FindBackList = calc_find_back(Player#player.lv, St#st_sword_pool.target_list),
    lib_dict:put(?PROC_STATUS_SWORD_POOL, St#st_sword_pool{is_change = 1, time = Now, exp_daily = 0, goods_daily = 0, target_list = [], find_back_list = FindBackList}),
    ok.

%%计算剑池属性
calc_sword_pool_attribute(NowLv) ->
    F = fun(Lv) ->
        case data_sword_pool_upgrade:get(Lv) of
            [] -> [];
            Base -> Base#base_sword_pool.attrs
        end
        end,
    AttrList = lists:flatmap(F, lists:seq(0, NowLv)),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%获取剑池属性
get_sword_pool_attribute() ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    St#st_sword_pool.attribute.

%%计算可找回
calc_find_back(Plv, TargetList) ->
    F = fun(Type) ->
        Base = data_sword_pool_exp:get(Type),
        Times = fetch_base_times(Plv, Base#base_sword_pool_exp.times),
        Total = Times,
        case lists:keyfind(Type, 1, TargetList) of
            false -> [{Type, Total}];
            {_, FinishTimes, _BuyTimes} ->
                if Total =< FinishTimes -> [];
                    true ->
                        [{Type, Total - FinishTimes}]
                end
        end
        end,
    lists:flatmap(F, data_sword_pool_exp:type_list()).

fetch_base_times(Plv, TimesList) ->
    case [Times || {LvMin, LvMax, Times} <- tuple_to_list(TimesList), Plv >= LvMin, Plv =< LvMax] of
        [] -> 0;
        L -> hd(L)
    end.

