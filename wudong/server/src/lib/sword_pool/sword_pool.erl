%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2016 10:03
%%%-------------------------------------------------------------------
-module(sword_pool).
-author("hxming").
-include("server.hrl").
-include("common.hrl").
-include("sword_pool.hrl").
-include("tips.hrl").
-include("achieve.hrl").
-include("daily.hrl").

%% API
-export([
    sword_pool_info/1
    , add_exp_by_type/2
    , add_exp_by_type/3
    , add_buy_times/1
    , add_exp/2
    , upgrade/1
    , figure/2
    , daily_goods/1
    , find_back_list/0
    , find_back/1
    , check_upgrade_state/2
    , get_notice_state/0
    , gm_add_exp/1
]).

gm_add_exp(AddExp) ->
    player:apply_state(async, self(), {activity, sys_notice, [91]}),
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    lib_dict:put(?PROC_STATUS_SWORD_POOL, St#st_sword_pool{exp = AddExp}).

%%剑池信息
sword_pool_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    AttrList = attribute_util:pack_attr(St#st_sword_pool.attribute),
    Cbp = attribute_util:calc_combat_power(St#st_sword_pool.attribute),
    F = fun(Type) ->
        Base = data_sword_pool_exp:get(Type),
        case sword_pool_init:fetch_base_times(Player#player.lv, Base#base_sword_pool_exp.times) of
            0 -> [];
            _ ->
                case lists:keyfind(Type, 1, St#st_sword_pool.target_list) of
                    false -> [[Type, 0, 0]];
                    {_, FinishTimes, HadBuy} ->
                        [[Type, FinishTimes, HadBuy]]
                end
        end
        end,
    TargetList = lists:flatmap(F, data_sword_pool_exp:type_list()),
    Base = data_sword_pool_upgrade:get(St#st_sword_pool.lv),
    GoodsDaily = if St#st_sword_pool.goods_daily > 0 -> 2;
                     Base#base_sword_pool.exp_daily >= St#st_sword_pool.exp_daily -> 1;
                     true -> 0
                 end,

    {St#st_sword_pool.lv, St#st_sword_pool.exp, St#st_sword_pool.figure, St#st_sword_pool.exp_daily, GoodsDaily, Cbp, AttrList, TargetList}.

%%根据类型增加经验
add_exp_by_type(Plv, Type) ->
    case data_sword_pool_exp:get(Type) of
        [] -> ok;
        Base ->
            St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
            case lists:keytake(Type, 1, St#st_sword_pool.target_list) of
                false ->
                    TargetList = [{Type, 1, 0} | St#st_sword_pool.target_list],
                    add_exp(St#st_sword_pool{target_list = TargetList}, Base#base_sword_pool_exp.exp);
                {value, {_, Times, BuyTimes}, T} ->
                    BaseTimes = sword_pool_init:fetch_base_times(Plv, Base#base_sword_pool_exp.times),
                    if BaseTimes + Base#base_sword_pool_exp.buy_times > Times ->
                        TargetList = [{Type, Times + 1, BuyTimes} | T],
                        add_exp(St#st_sword_pool{target_list = TargetList}, Base#base_sword_pool_exp.exp);
                        true ->
                            ok
                    end
            end
    end.

add_exp_by_type(Plv, Type, AddTimes) ->
    case data_sword_pool_exp:get(Type) of
        [] -> ok;
        Base ->
            St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
            case lists:keytake(Type, 1, St#st_sword_pool.target_list) of
                false ->
                    TargetList = [{Type, AddTimes, 0} | St#st_sword_pool.target_list],
                    add_exp(St#st_sword_pool{target_list = TargetList}, Base#base_sword_pool_exp.exp * AddTimes);
                {value, {_, Times, BuyTimes}, T} ->
                    BaseTimes = sword_pool_init:fetch_base_times(Plv, Base#base_sword_pool_exp.times),
                    if BaseTimes + Base#base_sword_pool_exp.buy_times > Times ->
                        TargetList = [{Type, Times + AddTimes, BuyTimes} | T],
                        add_exp(St#st_sword_pool{target_list = TargetList}, Base#base_sword_pool_exp.exp * AddTimes);
                        true ->
                            ok
                    end
            end
    end.

add_exp(St, Exp) ->
    player:apply_state(async, self(), {activity, sys_notice, [91]}),
    NewSt = St#st_sword_pool{exp = St#st_sword_pool.exp + Exp, exp_daily = St#st_sword_pool.exp_daily + Exp, is_change = 1},
    %%更新帮派成员活跃度
    guild_hy:update_member_jc_hy(St#st_sword_pool.pkey, NewSt#st_sword_pool.exp_daily),
    %%剑池活跃度
    sword_d_v(Exp),
    lib_dict:put(?PROC_STATUS_SWORD_POOL, NewSt).

add_exp_only(St, Exp) ->
    player:apply_state(async, self(), {activity, sys_notice, [91]}),
    NewSt = St#st_sword_pool{exp = St#st_sword_pool.exp + Exp, is_change = 1},
    %%剑池活跃度
    sword_d_v(Exp),
    lib_dict:put(?PROC_STATUS_SWORD_POOL, NewSt).

%%增加购买次数
add_buy_times(Type) ->
    case data_sword_pool_exp:get(Type) of
        [] -> ok;
        Base ->
            if Base#base_sword_pool_exp.buy_times == 0 -> ok;
                true ->
                    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
                    NewSt =
                        case lists:keytake(Type, 1, St#st_sword_pool.target_list) of
                            false ->
                                TargetList = [{Type, 0, 1} | St#st_sword_pool.target_list],
                                St#st_sword_pool{target_list = TargetList, is_change = 1};
                            {value, {_, Times, BuyTimes}, T} ->
                                TargetList = [{Type, Times, BuyTimes + 1} | T],
                                St#st_sword_pool{target_list = TargetList, is_change = 1}
                        end,
                    lib_dict:put(?PROC_STATUS_SWORD_POOL, NewSt)
            end
    end.


%%升级
upgrade(Player) ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    case data_sword_pool_upgrade:get(St#st_sword_pool.lv) of
        [] -> {2, Player};
        Base ->
            if Base#base_sword_pool.exp == 0 -> {3, Player};
                Base#base_sword_pool.exp > St#st_sword_pool.exp -> {4, Player};
                true ->
                    Lv = St#st_sword_pool.lv + 1,
                    Exp = St#st_sword_pool.exp - Base#base_sword_pool.exp,
                    Attribute = sword_pool_init:calc_sword_pool_attribute(Lv),
                    Cbp = attribute_util:calc_combat_power(Attribute),
                    GoodsList = goods:make_give_goods_list(200, tuple_to_list(Base#base_sword_pool.goods)),
                    {ok, Player1} = goods:give_goods(Player, GoodsList),
                    Figure =
                        case data_sword_pool_upgrade:get(Lv) of
                            [] -> St#st_sword_pool.figure;
                            Base1 -> Base1#base_sword_pool.figure
                        end,
                    NewSt = St#st_sword_pool{lv = Lv, exp = Exp, figure = Figure, attribute = Attribute, cbp = Cbp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_SWORD_POOL, NewSt),
                    NewPlayer = player_util:count_player_attribute(Player1, true),
                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1002, 0, Lv),
                    sword_pool_load:log_sword_pool(Player#player.key, Player#player.nickname, 1, Lv),
                    activity:get_notice(NewPlayer, [91], true),
                    {1, NewPlayer#player{sword_pool_figure = Figure}}
            end
    end.

%% 检查
check_upgrade_state(_Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    case data_sword_pool_upgrade:get(St#st_sword_pool.lv) of
        [] -> Tips;
        Base ->
            if Base#base_sword_pool.exp == 0 -> Tips;
                Base#base_sword_pool.exp > St#st_sword_pool.exp -> Tips;
                true ->
                    Tips#tips{state = 1}
            end
    end.

%% 获取红点状态
get_notice_state() ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    case data_sword_pool_upgrade:get(St#st_sword_pool.lv) of
        [] -> 0;
        Base ->
            if Base#base_sword_pool.exp == 0 -> 0;
                Base#base_sword_pool.exp > St#st_sword_pool.exp -> 0;
                true -> 1
            end
    end.

%%切换形象
figure(Player, Figure) ->
    case data_sword_pool_upgrade:figure2lv(Figure) of
        [] -> {5, Player};
        Lv ->
            St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
            if St#st_sword_pool.lv < Lv -> {6, Player};
                true ->
                    NewSt = St#st_sword_pool{figure = Figure, is_change = 1},
                    lib_dict:put(?PROC_STATUS_SWORD_POOL, NewSt),
                    {1, Player#player{sword_pool_figure = Figure}}
            end
    end.

%%每日额外奖励
daily_goods(Player) ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    Base = data_sword_pool_upgrade:get(St#st_sword_pool.lv),
    if St#st_sword_pool.goods_daily > 0 -> {7, Player};
        St#st_sword_pool.exp_daily < Base#base_sword_pool.exp_daily -> {8, Player};
        true ->
            NewSt = St#st_sword_pool{goods_daily = 1, is_change = 1},
            lib_dict:put(?PROC_STATUS_SWORD_POOL, NewSt),
            GoodsList = goods:make_give_goods_list(200, tuple_to_list(Base#base_sword_pool.goods_daily)),
            {ok, NewPlayer} = goods:give_goods(Player, GoodsList),
            sword_pool_load:log_sword_pool(Player#player.key, Player#player.nickname, 2, 0),
            {1, NewPlayer}
    end.


%%可找回列表
find_back_list() ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    F = fun({Type, Times}, {Price, L}) ->
        case data_sword_pool_exp:get(Type) of
            [] -> {Price, L};
            Base ->
                {Price + Base#base_sword_pool_exp.price * Times, [[Type, Times] | L]}
        end
        end,
    lists:foldl(F, {0, []}, St#st_sword_pool.find_back_list).

%%找回
find_back(Player) ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    case St#st_sword_pool.find_back_list of
        [] ->
            {9, Player};
        _ ->
            F = fun({Type, Times}, {Price, Exp}) ->
                case data_sword_pool_exp:get(Type) of
                    [] -> {Price, Exp};
                    Base ->
                        {Price + Base#base_sword_pool_exp.price * Times,
                            Exp + round(Base#base_sword_pool_exp.exp * Times)}
                end
                end,
            {Price, AddExp} = lists:foldl(F, {0, 0}, St#st_sword_pool.find_back_list),
            case money:is_enough(Player, Price, gold) of
                false -> {10, Player};
                true ->
                    add_exp_only(St#st_sword_pool{find_back_list = []}, AddExp),
                    NewPlayer = money:add_no_bind_gold(Player, -Price, 230, 0, 0),
                    sword_pool_load:log_sword_pool(Player#player.key, Player#player.nickname, 3, 0),
                    {1, NewPlayer}
            end
    end.

%%掉落活跃度处理
sword_d_v(Exp) ->
    %%掉落活跃度
    DVal = daily:get_count(?DAILY_SWORD_POOL_EXP),
    NewDVal = DVal + Exp,
    daily:set_count(?DAILY_SWORD_POOL_EXP, NewDVal),
    self() ! {d_v_trigger, 14, {NewDVal}}.


%%
%%update_target(Player, Type) ->
%%    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
%%    case data_sword_pool_exp:get(Type) of
%%        [] -> ok;
%%        Base ->
%%            case lists:keytake(Type, 1, St#st_sword_pool.target_list) of
%%                false ->
%%                    TargetList = [{Type,1,0}|St#st_sword_pool.target_list],
%%                    true;
%%                {value,{_, FinishTimes, BuyTimes} ,T}->
%%                    if FinishTimes>= Base#base_sword_pool_exp.times ->
%%                        TargetList = St#st_sword_pool.target_list,
%%                        false;
%%
%%            end,
%%            ok
%%    end,
%%    ok.
