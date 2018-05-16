%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 14:05
%%%-------------------------------------------------------------------
-module(dungeon_material).
-author("hxming").

-include("dungeon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("drop.hrl").
-include("sword_pool.hrl").
-include("tips.hrl").
-include("achieve.hrl").
-include("task.hrl").
%% API
-compile(export_all).

-define(DUN_STATE_CLOSE, 0).
-define(DUN_STATE_OPEN, 1).
-define(DUN_STATE_BUY, 2).
-define(DUN_STATE_SWEEP, 3).
-define(DUN_STATE_FINISH, 4).


init(Player, Now) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_DUN_MATERIAL, #st_dun_material{pkey = Player#player.key, time = Now});
        false ->
            case dungeon_load:load_dun_material(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_DUN_MATERIAL, #st_dun_material{pkey = Player#player.key, time = Now});
                [DunList1, Time] ->
                    DunList = list2dun(DunList1),
                    case util:is_same_date(Now, Time) of
                        true ->
                            lib_dict:put(?PROC_STATUS_DUN_MATERIAL, #st_dun_material{pkey = Player#player.key, dun_list = DunList, time = Time});
                        false ->
                            lib_dict:put(?PROC_STATUS_DUN_MATERIAL, #st_dun_material{pkey = Player#player.key, dun_list = reset_dun_list(DunList), time = Now, is_change = 1})
                    end
            end
    end,
    ok.

dun2list(DunList) ->
    F = fun(Dun) ->
        {Dun#dun_material.dun_id, Dun#dun_material.times, Dun#dun_material.sweep}
    end,
    util:term_to_bitstring(lists:map(F, DunList)).

list2dun(DunList) ->
    F = fun({DunId, Times, Sweep}) ->
        #dun_material{dun_id = DunId, times = Times, sweep = Sweep}
    end,
    lists:map(F, util:bitstring_to_term(DunList)).

timer_update() ->
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    if St#st_dun_material.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_DUN_MATERIAL, St#st_dun_material{is_change = 0}),
        dungeon_load:replace_dun_material(St);
        true -> ok
    end.

logout() ->
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    if St#st_dun_material.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_DUN_MATERIAL, St#st_dun_material{is_change = 0}),
        dungeon_load:replace_dun_material(St);
        true -> ok
    end.

midnight_refresh(Now) ->
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    lib_dict:put(?PROC_STATUS_DUN_MATERIAL, St#st_dun_material{dun_list = reset_dun_list(St#st_dun_material.dun_list), time = Now, is_change = 1}).

reset_dun_list(DunList) ->
    F = fun(DunMaterial) ->
        DunMaterial#dun_material{times = 0, sweep = 0}
    end,
    lists:map(F, DunList).

%%查询是否有可挑战
check_dungeon_state(Player) ->
    F = fun(DunId) ->
        case data_dungeon:get(DunId) of
            [] ->
                false;
            Base ->
                if
                    Base#dungeon.lv > Player#player.lv -> false;
                    true ->
                        Count = dungeon_util:get_dungeon_times(DunId),
                        Count < 1
                end
        end
    end,
    IsDouble = act_double:get_dungeon_mult(),
    case lists:any(F, data_dungeon_material:ids()) of
        true ->
            ?IF_ELSE(IsDouble == 2, 3, 1);
        false ->
            ?IF_ELSE(IsDouble == 2, 2, 0)
    end.

%%查询升级是否有可挑战
check_uplv_dungeon_state(Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    F = fun(DunId) ->
        case data_dungeon:get(DunId) of
            [] ->
                [];
            Base ->
                case lists:keyfind(DunId, #dun_material.dun_id, St#st_dun_material.dun_list) of
                    false ->
                        if
                            Base#dungeon.lv > Player#player.lv -> [];
                            true -> [DunId]
                        end;
                    _ ->
                        []
                end
        end
    end,
    case lists:flatmap(F, data_dungeon_material:ids()) of
        [] -> Tips;
        DunIdList ->
            [DunId | _] = lists:sort(DunIdList),
            Tips#tips{state = 1, args6 = DunId, uplv_dungeon_list = [?TIPS_DUNGEON_TYPE_MATERIAL | Tips#tips.uplv_dungeon_list]}
    end.

dungeon_list(Player) ->
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    F = fun(DunId) ->
        case data_dungeon:get(DunId) of
            [] ->
                [];
            Base ->
                case lists:keyfind(DunId, #dun_material.dun_id, St#st_dun_material.dun_list) of
                    false ->
                        Gold = get_reset_price(Player, 0),
                        State = check_state(Player, Base, #dun_material{}),
                        [[DunId, 0, Base#dungeon.count, State, 0, Gold]];
                    Dun ->
                        State = check_state(Player, Base, Dun),
                        Gold = get_reset_price(Player, Dun#dun_material.times),
                        [[DunId, Dun#dun_material.times, Base#dungeon.count, State, 1, Gold]]
                end
        end
    end,
    lists:flatmap(F, data_dungeon_material:ids()).


get_reset_price(Player, Times) ->
    case data_dungeon_material_reset:get(Times) of
        [] -> 0;
        {_, Gold} ->
            if Times == 1 andalso Player#player.d_vip#dvip.vip_type > 0 -> 0;
                true ->
                    Gold
            end
    end.

check_state(Player, BaseData, DunMaterial) ->
    if BaseData#dungeon.lv > Player#player.lv -> ?DUN_STATE_CLOSE;
        DunMaterial#dun_material.times >= BaseData#dungeon.count -> ?DUN_STATE_FINISH;
        DunMaterial#dun_material.times == 0 -> ?DUN_STATE_OPEN;
        DunMaterial#dun_material.sweep == 0 -> ?DUN_STATE_BUY;
        true ->
            ?DUN_STATE_SWEEP
    end.


check_enter(DunId) ->
    case dungeon_util:is_dungeon_material(DunId) of
        false -> true;
        true ->
            St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
            case lists:keyfind(DunId, #dun_material.dun_id, St#st_dun_material.dun_list) of
                false -> true;
                DunMaterial ->
                    if DunMaterial#dun_material.times == 0 -> true;
                        true -> {false, ?T("您今日免费挑战次数已用完")}
                    end

            end
    end.

get_enter_dungeon_extra(DunId) ->
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    case lists:keymember(DunId, #dun_material.dun_id, St#st_dun_material.dun_list) of
        false -> [];
        true ->
            [{first_pass, 1}]
    end.

%%购买次数
buy(Player, DunId) ->
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    case data_dungeon:get(DunId) of
        [] -> {2, Player};
        Base ->
            case lists:keytake(DunId, #dun_material.dun_id, St#st_dun_material.dun_list) of
                false -> {3, Player};
                {value, DunMaterial, T} ->
                    case check_state(Player, Base, DunMaterial) of
                        ?DUN_STATE_CLOSE -> {4, Player};
                        ?DUN_STATE_OPEN -> {3, Player};
                        ?DUN_STATE_SWEEP -> {5, Player};
                        ?DUN_STATE_FINISH -> {6, Player};
                        ?DUN_STATE_BUY ->
                            case data_dungeon_material_reset:get(DunMaterial#dun_material.times) of
                                [] -> {6, Player};
                                {Vip, Gold} ->
                                    case DunMaterial#dun_material.times == 1 andalso Player#player.d_vip#dvip.vip_type > 0 of
                                        true ->
                                            NewDunMaterial = DunMaterial#dun_material{sweep = DunMaterial#dun_material.sweep + 1},
                                            NewSt = St#st_dun_material{dun_list = [NewDunMaterial | T], is_change = 1},
                                            lib_dict:put(?PROC_STATUS_DUN_MATERIAL, NewSt),
                                            {1, Player};
                                        false ->
                                            if Player#player.vip_lv < Vip -> {7, Player};
                                                true ->
                                                    case money:is_enough(Player, Gold, gold) of
                                                        false -> {8, Player};
                                                        true ->
                                                            NewPlayer = money:add_no_bind_gold(Player, -Gold, 9, 0, 0),
                                                            NewDunMaterial = DunMaterial#dun_material{sweep = DunMaterial#dun_material.sweep + 1},
                                                            NewSt = St#st_dun_material{dun_list = [NewDunMaterial | T], is_change = 1},
                                                            lib_dict:put(?PROC_STATUS_DUN_MATERIAL, NewSt),
                                                            {1, NewPlayer}
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.

%%扫荡
sweep(Player, DunId) ->
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    case lists:keytake(DunId, #dun_material.dun_id, St#st_dun_material.dun_list) of
        false -> {9, [], Player};
        {value, DunMaterial, T} ->
            if DunMaterial#dun_material.sweep =< 0 -> {9, [], Player};
                true ->
                    DunTimes = dungeon_util:get_dungeon_times(DunId),
                    PassGoods = pass_goods(DunId, Player#player.lv),
                    SweepGoods = sweep_goods(DunId, DunTimes, Player#player.lv),
                    DropGoods = drop_goods(DunId, Player#player.lv),
                    GoodsList = goods:merge_goods(PassGoods ++ DropGoods ++ SweepGoods),
                    NewDunMaterial = DunMaterial#dun_material{times = DunMaterial#dun_material.times + 1, sweep = DunMaterial#dun_material.sweep - 1},
                    NewSt = St#st_dun_material{dun_list = [NewDunMaterial | T], is_change = 1},
                    lib_dict:put(?PROC_STATUS_DUN_MATERIAL, NewSt),
                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(10, GoodsList)),
                    extra_trigger(Player, DunId, 1),
                    PackGoodsList = [[Gid, Num, ?DROP_TYPE_PASS] || {Gid, Num} <- PassGoods] ++ [[Gid, Num, ?DROP_TYPE_RATIO] || {Gid, Num} <- DropGoods] ++ [[Gid, Num, ?DROP_TYPE_EXTRA] || {Gid, Num} <- SweepGoods],
                    {1, PackGoodsList, NewPlayer}
            end
    end.


extra_trigger(Player, DunId, Times) ->
    dungeon_util:add_dungeon_times(DunId, Times),
    sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_DUN_MATERIAL, Times),
    FindType =
        %%TODO 材料副本找回协议类型转换匹配,要注意
    case data_dungeon_material:get_subtype(DunId) of
        11 -> 41;
        12 -> 32;
        13 -> 43;
        [] -> 0;
        14 -> 46;
        15 -> 45;
        FType -> FType
%%             _ -> 0
    end,

    if
        FindType == 0 -> skip;
        true ->
            findback_src:fb_trigger_src(Player, FindType, Times),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2003, 0, Times),
            act_hi_fan_tian:trigger_finish_api(Player, 1, Times),
            task_event:event(?TASK_ACT_DUNGEON, {DunId, Times})
    end,
    ok.

%%check_sweep_free(Player, DunId, Lv) ->
%%    Base = data_dungeon:get(DunId),
%%    IsFree = dvip_util:check_buy_dungeon_free(Player, Base),
%%    case IsFree > 0 of
%%        true ->
%%            {1, pass_goods(DunId, Lv)};
%%        _ ->
%%            {0, []}
%%    end.


%% 免费扫荡信息
get_free_sweep(#player{lv = Lv} = Player) ->
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    F = fun(DunId, {AccNum, AccGoodsList, AccFirstGoodsList}) -> %%未通关可以扫荡?
        Base = data_dungeon:get(DunId),
        case lists:keytake(DunId, #dun_material.dun_id, St#st_dun_material.dun_list) of
            false ->
                State = check_state(Player, Base, #dun_material{}),
                case State of
                    ?DUN_STATE_OPEN ->
                        PassGoods = pass_goods(DunId, Lv),
                        FirstGoods = first_goods(DunId, Player#player.lv),
                        {AccNum + 2, PassGoods ++ PassGoods ++ AccGoodsList, FirstGoods ++ AccFirstGoodsList};
                    _ ->
                        {AccNum, AccGoodsList, AccFirstGoodsList}
                end;
            {value, DunMaterial, _T} ->
                if DunMaterial#dun_material.times >= 2 ->
                    {AccNum, AccGoodsList, AccFirstGoodsList};
                    DunMaterial#dun_material.times == 1 ->
                        PassGoods = pass_goods(DunId, Lv),
                        {AccNum + 1, PassGoods ++ AccGoodsList, AccFirstGoodsList};
                    true ->
                        PassGoods = pass_goods(DunId, Lv),
                        {AccNum + 2, PassGoods ++ PassGoods ++ AccGoodsList, AccFirstGoodsList}

                end
        end
    end,
    {FreeNum, PassGoodsList, FirstGoodsList} =
        lists:foldl(F, {0, [], []}, data_dungeon_material:ids()),
    ResetSGoodsList = [[GoodsId, GoodsNum, ?DROP_TYPE_PASS] || {GoodsId, GoodsNum} <- goods:merge_goods(FirstGoodsList)] ++
        [[GoodsId, GoodsNum, ?DROP_TYPE_FIRST] || {GoodsId, GoodsNum} <- goods:merge_goods(PassGoodsList)],
    {FreeNum, ResetSGoodsList}.


%% 付费扫荡
get_cost_sweep(#player{lv = Lv} = Player) ->
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    F = fun(DunId, {AccNum, AccGoodsList, AccFirstGoodsList, AccSweepGoodsList, CostGold}) -> %%未通关可以扫荡?
        Base = data_dungeon:get(DunId),
        case lists:keytake(DunId, #dun_material.dun_id, St#st_dun_material.dun_list) of
            false ->
                State = check_state(Player, Base, #dun_material{}),
                case State of
                    ?DUN_STATE_OPEN ->
                        {SweepTime, TotalCost} = get_cost_gold(Player, 0, 0, State, 0),
                        ?PRINT("State222 ============= ~w  Times : ~w, TotalCost:~w", [State, SweepTime, TotalCost]),
                        PassGoods = pass_goods(DunId, Lv),
                        NewAccGoodsList = lists:foldl(fun(_, AccGoods2) ->
                            PassGoods ++ AccGoods2
                        end, AccGoodsList, lists:seq(1, SweepTime)),
                        FirstGoods = first_goods(DunId, Player#player.lv),
                        SweepGoods1 = lists:flatmap(fun(Times) ->
                            sweep_goods(DunId, Times, Lv) end, lists:seq(0, SweepTime - 1)),
                        {AccNum + SweepTime, NewAccGoodsList, FirstGoods ++ AccFirstGoodsList, AccSweepGoodsList ++ SweepGoods1, TotalCost + CostGold};
                    _ ->
                        {AccNum, AccGoodsList, AccFirstGoodsList, AccSweepGoodsList, CostGold}
                end;
            {value, DunMaterial, _T} ->
%%                ?PRINT("times  ============== ~w ~w",[DunId,DunMaterial#dun_material.times]),
                State = check_state(Player, Base, DunMaterial),
                {SweepTime, TotalCost} = get_cost_gold(Player, DunMaterial#dun_material.times, 0, State, DunMaterial#dun_material.times),
                AddNum = SweepTime - DunMaterial#dun_material.times,
                ?PRINT("State ============= ~w  Times : ~w, TotalCost:~w", [State, AddNum, TotalCost]),
                PassGoods = pass_goods(DunId, Lv),
                NewAccGoodsList = lists:foldl(fun(_, AccGoods2) ->
                    PassGoods ++ AccGoods2
                end, AccGoodsList, lists:seq(1, AddNum)),
                ?DEBUG("DunMaterial#dun_material.times ~p/~p~n", [DunMaterial#dun_material.times, SweepTime]),
                SweepGoods1 =
                    ?IF_ELSE(AddNum > 0,
                        lists:flatmap(fun(Times) ->
                            sweep_goods(DunId, Times, Lv) end, lists:seq(DunMaterial#dun_material.times, DunMaterial#dun_material.times + AddNum - 1)), []),
                {AccNum + AddNum, NewAccGoodsList, AccFirstGoodsList, AccSweepGoodsList ++ SweepGoods1, CostGold + TotalCost}

        end
    end,
    {FreeNum, PassGoodsList, FirstGoodsList, SweepGoodsList, AllCost} =
        lists:foldl(F, {0, [], [], [], 0}, data_dungeon_material:ids()),
    ResetSGoodsList = [[GoodsId, GoodsNum, ?DROP_TYPE_PASS] || {GoodsId, GoodsNum} <- goods:merge_goods(FirstGoodsList)] ++
        [[GoodsId, GoodsNum, ?DROP_TYPE_FIRST] || {GoodsId, GoodsNum} <- goods:merge_goods(PassGoodsList)] ++
        [[GoodsId, GoodsNum, ?DROP_TYPE_EXTRA] || {GoodsId, GoodsNum} <- goods:merge_goods(SweepGoodsList)],
    {FreeNum, ResetSGoodsList, AllCost}.


%%
get_cost_gold(#player{vip_lv = VipLv} = Player, Time, SumCost, State, CurTime) ->
    if Time =< 1 ->  %% 前面2次都是免费的
        get_cost_gold(Player, Time + 1, SumCost, State, CurTime);
        Time == CurTime andalso State == ?DUN_STATE_SWEEP ->
            get_cost_gold(Player, Time + 1, SumCost, State, CurTime);
        true ->
            case data_dungeon_material_reset:get(Time) of
                {NeedVipLv, CostGold} when VipLv >= NeedVipLv ->
                    SumCost2 = SumCost + CostGold,
                    get_cost_gold(Player, Time + 1, SumCost2, State, CurTime);
                _ ->
                    {Time, SumCost}
            end
    end.


%% 扫荡信息
sweep_info(#player{d_vip = #dvip{vip_type = _VipType, time = _LeftTime}} = Player) ->
    {FreeNum, FreeSweepList} = get_free_sweep(Player),
    {CostNum, CostSweepList, CostGold} = get_cost_sweep(Player),
    ?PRINT("sweep_info ============= ~w ~w ~w", [CostNum, CostSweepList, CostGold]),
    Data = {FreeNum, 0, FreeSweepList, CostNum, CostGold, CostSweepList},
    Data.


%% @doc 扫荡所有的副本
sweep_all_dungeon(#player{d_vip = #dvip{vip_type = _VipType, time = _LeftTime}} = Player, Type) ->
    case _VipType == 2 of
        true ->
            case Type of
                1 ->
                    free_sweep(Player);
                _ ->
                    cost_sweep(Player)
            end;
        _ ->
            {fail, 17}
    end.


%%
cost_sweep(Player) ->
    Lv = Player#player.lv,
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    F = fun(DunId, {DunList, AccFirstList, AccPassList, AccDropList, AccSweepList, CostGold}) ->
        Base = data_dungeon:get(DunId),
        case lists:keytake(DunId, #dun_material.dun_id, DunList) of
            false ->
                State = check_state(Player, Base, #dun_material{}),
                case State of
                    ?DUN_STATE_OPEN ->
                        PassGoods = pass_goods(DunId, Lv),
                        {SweepTime, TotalCost} = get_cost_gold(Player, 0, 0, State, 0),
                        DropGoods = drop_goods(DunId, Player#player.lv),
                        {NewAccPassList2, NewAccDropList2} = lists:foldl(fun(_, {AccPassGoods2, AccDropList2}) ->
                            {PassGoods ++ AccPassGoods2, DropGoods ++ AccDropList2}
                        end, {AccPassList, AccDropList}, lists:seq(1, SweepTime)),
                        FirstGoods = first_goods(DunId, Player#player.lv),

                        SweepGoods1 = lists:flatmap(fun(Times) ->
                            sweep_goods(DunId, Times, Lv) end, lists:seq(0, SweepTime - 1)),

                        DunList1 = [#dun_material{dun_id = DunId, times = SweepTime} | DunList],
%%                        extra_trigger(Player, DunId, SweepTime),
                        {DunList1, AccFirstList ++ FirstGoods, NewAccPassList2, NewAccDropList2, AccSweepList ++ SweepGoods1, TotalCost + CostGold};
                    _ ->
                        {DunList, AccFirstList, AccPassList, AccDropList, AccSweepList, CostGold}
                end;
            {value, DunMaterial, _T} ->
                State = check_state(Player, Base, DunMaterial),
                {SweepTime, TotalCost} = get_cost_gold(Player, DunMaterial#dun_material.times, 0, State, DunMaterial#dun_material.times),
                AddNum = SweepTime - DunMaterial#dun_material.times,
                DropGoods = drop_goods(DunId, Player#player.lv),
                PassGoods = pass_goods(DunId, Lv),
                {NewAccPassList2, NewAccDropList2} = lists:foldl(fun(_, {AccPassGoods2, AccDropList2}) ->
                    {PassGoods ++ AccPassGoods2, DropGoods ++ AccDropList2}
                end, {AccPassList, AccDropList}, lists:seq(1, AddNum)),

                SweepGoods1 =
                    ?IF_ELSE(AddNum > 0,
                        lists:flatmap(fun(Times) ->
                            sweep_goods(DunId, Times, Lv) end, lists:seq(DunMaterial#dun_material.times, DunMaterial#dun_material.times + AddNum - 1)), []),

                DunList1 = [DunMaterial#dun_material{dun_id = DunId, times = SweepTime, sweep = 0} | _T],
%%                extra_trigger(Player, DunId, AddNum),
                {DunList1, AccFirstList, NewAccPassList2, NewAccDropList2, AccSweepList ++ SweepGoods1, TotalCost + CostGold}

        end
    end,
    {NewDunList, FirstGoodsList, PassGoodsList, DropGoodsList, SweepGoodsList, CostGold} =
        lists:foldl(F, {St#st_dun_material.dun_list, [], [], [], [], 0}, data_dungeon_material:ids()),
    GoodsList = PassGoodsList ++ FirstGoodsList ++ DropGoodsList ++ SweepGoodsList,
    case GoodsList of
        [] -> {false, 15};
        _ ->
            IsEnough = money:is_enough(Player, CostGold, gold),
            case IsEnough of
                true ->
                    NewPlayer = money:cost_money(Player, gold, -CostGold, 552, 0, 0),
                    NewGoodsList = goods:merge_goods(GoodsList),
                    NewSt = St#st_dun_material{dun_list = NewDunList, is_change = 1},
                    lib_dict:put(?PROC_STATUS_DUN_MATERIAL, NewSt),
                    {ok, NewPlayer2} = goods:give_goods(NewPlayer, goods:make_give_goods_list(10, NewGoodsList)),
                    PackGoodsList = [[Gid, Num, ?DROP_TYPE_PASS] || {Gid, Num} <- goods:merge_goods(PassGoodsList)] ++
                        [[Gid, Num, ?DROP_TYPE_RATIO] || {Gid, Num} <- goods:merge_goods(DropGoodsList)] ++
                        [[Gid, Num, ?DROP_TYPE_FIRST] || {Gid, Num} <- goods:merge_goods(FirstGoodsList)] ++
                        [[Gid, Num, ?DROP_TYPE_EXTRA] || {Gid, Num} <- goods:merge_goods(SweepGoodsList)],
                    do_extra(Player, NewDunList, St#st_dun_material.dun_list),
                    {ok, NewPlayer2, PackGoodsList};
                _ ->
                    {false, 8}
            end
    end.

do_extra(Player, NewDungeonList, OldDungeonList) ->
    F = fun(DunM) ->
        case lists:keyfind(DunM#dun_material.dun_id, #dun_material.dun_id, OldDungeonList) of
            false ->
                extra_trigger(Player, DunM#dun_material.dun_id, DunM#dun_material.times);
            OldDumM ->
                if DunM#dun_material.times > OldDumM#dun_material.times ->
                    extra_trigger(Player, DunM#dun_material.dun_id, DunM#dun_material.times - OldDumM#dun_material.times);
                    true -> skip
                end
        end
    end,
    lists:foreach(F, NewDungeonList),
    ok.



free_sweep(Player) ->
    Lv = Player#player.lv,
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    F = fun(DunId, {DunList, AccFirstList, AccPassList, AccDropList}) -> %%未通关可以扫荡?
        Base = data_dungeon:get(DunId),
        case lists:keytake(DunId, #dun_material.dun_id, DunList) of
            false ->
                State = check_state(Player, Base, #dun_material{}),
                case State of
                    ?DUN_STATE_OPEN ->
                        PassGoods = pass_goods(DunId, Lv),
                        FirstGoods = first_goods(DunId, Player#player.lv),
                        DropGoods = drop_goods(DunId, Player#player.lv),
                        DropGoods1 = drop_goods(DunId, Player#player.lv),
                        DunList1 = [#dun_material{dun_id = DunId, times = 2} | DunList],
                        extra_trigger(Player, DunId, 2),
                        {DunList1, AccFirstList ++ FirstGoods, PassGoods ++ PassGoods ++ AccPassList, DropGoods ++ DropGoods1 ++ AccDropList};
                    _ ->
                        {DunList, AccFirstList, AccPassList, AccDropList}
                end;
            {value, DunMaterial, _T} ->
                if DunMaterial#dun_material.times >= 2 ->
                    {DunList, AccFirstList, AccPassList, AccDropList};
                    DunMaterial#dun_material.times == 1 ->
                        PassGoods = pass_goods(DunId, Lv),
                        DropGoods = drop_goods(DunId, Player#player.lv),
                        DunList1 = [DunMaterial#dun_material{dun_id = DunId, times = DunMaterial#dun_material.times + 1, sweep = 0} | _T],
                        extra_trigger(Player, DunId, 1),
                        {DunList1, AccFirstList, PassGoods ++ AccPassList, DropGoods ++ AccDropList};
                    true ->
                        PassGoods = pass_goods(DunId, Lv),
                        DropGoods = drop_goods(DunId, Player#player.lv),
                        DropGoods1 = drop_goods(DunId, Player#player.lv),
                        DunList1 = [DunMaterial#dun_material{dun_id = DunId, times = 2, sweep = 0} | _T],
                        extra_trigger(Player, DunId, 2),
                        {DunList1, AccFirstList, PassGoods ++ PassGoods ++ AccPassList, DropGoods ++ DropGoods1 ++ AccDropList}

                end
        end
    end,
    {NewDunList, FirstGoodsList, PassGoodsList, DropGoodsList} =
        lists:foldl(F, {St#st_dun_material.dun_list, [], [], []}, data_dungeon_material:ids()),
    GoodsList = PassGoodsList ++ FirstGoodsList ++ DropGoodsList,
    case GoodsList of
        [] -> {false, 15};
        _ ->
            NewGoodsList = goods:merge_goods(GoodsList),
            NewSt = St#st_dun_material{dun_list = NewDunList, is_change = 1},
            lib_dict:put(?PROC_STATUS_DUN_MATERIAL, NewSt),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(10, NewGoodsList)),
            PackGoodsList = [[Gid, Num, ?DROP_TYPE_PASS] || {Gid, Num} <- goods:merge_goods(PassGoodsList)] ++
                [[Gid, Num, ?DROP_TYPE_RATIO] || {Gid, Num} <- goods:merge_goods(DropGoodsList)] ++
                [[Gid, Num, ?DROP_TYPE_FIRST] || {Gid, Num} <- goods:merge_goods(FirstGoodsList)],
            {ok, NewPlayer, PackGoodsList}
    end.



pass_goods(DunId, Lv) ->
    case data_dungeon_material:pass_goods(DunId, Lv) of
        [] -> [];
        GoodsList ->
            IsDungeonDouble = act_double:get_dungeon_mult(),
            if
                IsDungeonDouble == 1 -> tuple_to_list(GoodsList);
                true -> lists:map(fun({Id, N}) -> {Id, N * IsDungeonDouble} end, tuple_to_list(GoodsList))
            end
    end.

first_goods(DunId, Lv) ->
    case data_dungeon_material:first_goods(DunId, Lv) of
        [] -> [];
        GoodsList -> tuple_to_list(GoodsList)
    end.

drop_goods(DunId, Lv) ->
    case data_dungeon_material:drop_goods(DunId, Lv) of
        [] -> [];
        GoodsList ->
            IsDungeonDouble = act_double:get_dungeon_mult(),
            RatioList = [{Gid, Ratio} || {Gid, _, Ratio} <- GoodsList],
            case util:list_rand_ratio(RatioList) of
                0 -> [];
                Gid ->
                    case lists:keyfind(Gid, 1, GoodsList) of
                        false -> [];
                        {_, Num, _} ->
                            [{Gid, Num * IsDungeonDouble}]
                    end
            end
    end.

sweep_goods(DunId, Times, Lv) ->
    if
        Times >= 2 ->
            IsDungeonDouble = act_double:get_dungeon_mult(),
            L = data_dungeon_material:sweep_goods(DunId, Lv),
            lists:map(fun({Id, N}) -> {Id, N * IsDungeonDouble} end, L);
        true -> []
    end.


%%副本挑战结果
dungeon_material_ret(1, Player, DunId) ->
    dungeon_util:add_dungeon_times(DunId),
    St = lib_dict:get(?PROC_STATUS_DUN_MATERIAL),
    FirstGoods =
        case lists:keytake(DunId, #dun_material.dun_id, St#st_dun_material.dun_list) of
            false ->
                DunList = [#dun_material{dun_id = DunId, times = 1} | St#st_dun_material.dun_list],
                NewSt = St#st_dun_material{dun_list = DunList, is_change = 1},
                lib_dict:put(?PROC_STATUS_DUN_MATERIAL, NewSt),
                first_goods(DunId, Player#player.lv);
            {value, DunMaterial, T} ->
                DunList = [DunMaterial#dun_material{times = DunMaterial#dun_material.times + 1} | T],
                NewSt = St#st_dun_material{dun_list = DunList, is_change = 1},
                lib_dict:put(?PROC_STATUS_DUN_MATERIAL, NewSt),
                []
        end,
    PassGoods = pass_goods(DunId, Player#player.lv),
    DropGoods = drop_goods(DunId, Player#player.lv),
    GoodsList = goods:merge_goods(PassGoods ++ DropGoods ++ FirstGoods),
    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(10, GoodsList)),
    PackGoodsList = [[Gid, Num, ?DROP_TYPE_PASS] || {Gid, Num} <- PassGoods] ++ [[Gid, Num, ?DROP_TYPE_RATIO] || {Gid, Num} <- DropGoods] ++ [[Gid, Num, ?DROP_TYPE_FIRST] || {Gid, Num} <- FirstGoods],
    {ok, Bin} = pt_121:write(12172, {1, DunId, PackGoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_DUN_MATERIAL),
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2003, 0, 1),

    activity:get_notice(Player, [97], true),
    NewPlayer;
dungeon_material_ret(0, Player, DunId) ->
    {ok, Bin} = pt_121:write(12172, {0, DunId, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player.


check_score([], _UseTime) ->
    false;
check_score([{Type, Time} | T], UseTime) ->
    if UseTime < Time ->
        {Type, Time};
        true ->
            check_score(T, UseTime)
    end.



get_notice_state(DunId) ->
    case data_dungeon:get(DunId) of
        [] ->
            {0, []};
        Base ->
            Count = dungeon_util:get_dungeon_times(DunId),
            ?IF_ELSE(Base#dungeon.count - Count > 0, {1, [{time, Base#dungeon.count - Count}]}, {0, []})
    end.

get_dungeon_times_total(Player) ->
    F = fun(DunId) ->
        case data_dungeon:get(DunId) of
            [] ->
                0;
            Base ->
                Count = dungeon_util:get_dungeon_times(DunId),
                ?IF_ELSE(Base#dungeon.count - Count > 0 andalso Player#player.lv > Base#dungeon.lv, Base#dungeon.count - Count, 0)
        end
    end,
    TimesList = lists:map(F, data_dungeon_material:ids()),
    lists:sum(TimesList).


get_activity_by_dup(DunId) ->
    case DunId of
        50002 -> 63;
        50003 -> 64;
        50001 -> 65;
        50004 -> 66;
        50006 -> 74;
        50005 -> 75;
        _ -> 0
    end.
