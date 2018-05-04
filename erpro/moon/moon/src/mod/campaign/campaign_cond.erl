%%----------------------------------------------------
%% 后台活动条件判断
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(campaign_cond).
-export([do_all/6, do/6]).

-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").
-include("gain.hrl").
-include("attr.hrl").
-include("pet.hrl").
-include("item.hrl").
-include("skill.hrl").
-include("channel.hrl").
-include("assets.hrl").
-include("vip.hrl").
-include("activity2.hrl").
-include("task.hrl").

do_all(Role, TotalCamp, Camp, Cond, Args, Conds) ->
    case check(Role, TotalCamp) of
        {false, Reason} -> {false, Reason};
        true ->
            case check(Role, TotalCamp, Camp) of
                {false, Reason} -> {false, Reason};
                true ->
                    case check(Role, TotalCamp, Camp, Cond) of
                        {false, Reason} -> {false, Reason};
                        true ->
                            do(Role, TotalCamp, Camp, Cond, Args, Conds)
                    end
            end
    end.

do(Role, _TotalCamp, _Camp, _Cond, _Args, []) -> {ok, Role};
do(Role, TotalCamp, Camp, Cond, Args, [I | T]) -> 
    case do(Role, TotalCamp, Camp, Cond, Args, I) of
        {ok, NewRole} -> do(NewRole, TotalCamp, Camp, Cond, Args, T);
        {false, Reason} -> {false, Reason}
    end;
do(Role = #role{id = {Rid, SrvId}}, _TotalCamp, _Camp = #campaign_adm{start_time = StartTime}, _Cond = #campaign_cond{settlement_type = ?camp_settlement_type_everyday}, _Args, {pay_acc, Min, Max}) -> %% 要求活动期间每天累计充值
    DayStart = util:unixtime(today),
    Acc = case StartTime > DayStart of
        true -> campaign_dao:calc_charge(Rid, SrvId, begin_time, StartTime);
        false -> campaign_dao:calc_charge(Rid, SrvId, begin_time, DayStart)
    end,
    case Acc >= Min andalso (Acc =< Max orelse Max =:= 0) of
        true -> {ok, Role};
        false -> {false, util:fbin(?L(<<"活动期间每天累计充值~p方可领取">>), [Min])}
    end;
do(Role = #role{id = {Rid, SrvId}}, _TotalCamp, _Camp = #campaign_adm{start_time = StartTime}, _Cond, _Args, {pay_acc, Min, Max}) -> %% 要求活动期间累计充值
    Acc = campaign_dao:calc_charge(Rid, SrvId, begin_time, StartTime),
    case Acc >= Min andalso (Acc =< Max orelse Max =:= 0) of
        true -> {ok, Role};
        false -> {false, util:fbin(?L(<<"活动期间累计充值~p方可领取">>), [Min])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Args, {pay_each, Min, Max}) -> %% 要求每次充值
    case Args >= Min andalso (Args =< Max orelse Max =:= 0) of
        true -> {ok, Role};
        false -> {false, util:fbin(?L(<<"单次充值~p至~p方可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Args, {pay_update, Min, Max}) -> %% 更新首次充值
    case Args >= Min andalso (Args =< Max orelse Max =:= 0) of
        true -> {ok, Role};
        false -> {false, util:fbin(?L(<<"更新首次充值~p至~p方可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Args, {pay_everyday, Min, Max}) -> %% 每天首次充值
    case Args >= Min andalso (Args =< Max orelse Max =:= 0) of
        true -> {ok, Role};
        false -> {false, util:fbin(?L(<<"活动期间每天首次充值~p至~p方可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = Campaign}, _TotalCamp, _Camp, _Cond, Args, {pay_first, Min, Max}) -> %% 历史首次充值
    case Args >= Min andalso (Args =< Max orelse Max =:= 0) of
        true -> {ok, Role#role{campaign = Campaign#campaign_role{first_charge = 1}}};
        false -> {false, util:fbin(?L(<<"历史单次充值~p至~p方可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{last_gold = LastGold}}, _TotalCamp, _Camp, _Cond, AddGold, {pay_gold_each, Min}) -> %% 单次充值每X晶钻
    Val = case AddGold of
        0 -> LastGold;
        _ -> AddGold
    end,
    case Val >= Min of
        true -> {ok, Role#role{campaign = Campaign#campaign_role{last_gold = Val - Min}}};
        false -> {false, util:fbin(?L(<<"单次充值每~p晶钻可领取">>), [Min])}
    end;
% do(Role = #role{campaign = Campaign = #campaign_role{last_gold = LastGold}}, _TotalCamp, _Camp, _Cond, AddGold, {pay_acc_each, Min}) -> %% 累计充值每X晶钻
%     Val = case AddGold of
%         0 -> LastGold;
%         _ -> AddGold
%     end,
%     case Val >= Min of
%         true -> {ok, Role#role{campaign = Campaign#campaign_role{last_gold = Val - Min}}};
%         false -> {false, util:fbin(?L(<<"累计充值每~p晶钻可领取">>), [Min])}
%     end;
%% 旧版本是只适用活动结束后统计发放
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _AddGold, {pay_acc_each, Min}) -> %% 累计充值每X晶
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, Time} ->
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, Time}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                false -> {false, util:fbin(?L(<<"累计充值每~p晶钻可领取">>), [Min])}
            end;
        _ ->
            {false, util:fbin(?L(<<"累计充值每~p晶钻可领取">>), [Min])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, _Args, {loss, item, ItemList}) when is_list(ItemList) ->
    Loss = [#loss{label = item, val = [BaseId, 0, Num]} || {BaseId, Num} <- ItemList],
    case role_gain:do(Loss, Role) of
        {false, _} -> {false, ?L(<<"相关物品数量不足">>)};
        {ok, NRole} -> {ok, NRole}
    end;
do(Role, _TotalCamp, _Camp, _Cond, _Args, {loss, item, BaseId, Num}) -> %% 扣除物品
    Loss = [#loss{label = item, val = [BaseId, 0, Num]}],
    case role_gain:do(Loss, Role) of
        {false, _} -> {false, ?L(<<"相关物品数量不足">>)};
        {ok, NRole} -> {ok, NRole}
    end;
do(Role, _TotalCamp, _Camp, _Cond, _Args, {loss_item, BaseId, Num}) -> %% 扣除物品
    Loss = [#loss{label = item, val = [BaseId, 0, Num]}],
    case role_gain:do(Loss, Role) of
        {false, _} -> {false, ?L(<<"相关物品数量不足">>)};
        {ok, NRole} -> {ok, NRole}
    end;
do(Role, _TotalCamp, _Camp, _Cond, _Args, {loss, Type, Val}) -> %% 扣除资产类
    Loss = [#loss{label = Type, val = Val}],
    case role_gain:do(Loss, Role) of
        {false, _} when Type =:= coin orelse Type =:= coin_bind orelse Type =:= gold orelse Type =:= gold_bind orelse Type =:= coin_all -> {false, Type};
        {false, _} -> {false, ?L(<<"相关资产不足">>)};
        {ok, NRole} -> {ok, NRole}
    end;
do(Role = #role{campaign = #campaign_role{day_online = {T, OnlineTime}}}, _TotalCamp, _Camp, _Cond, _Args, {online_buy, NeedOnlineTime, Gold}) -> %% 扣除资产类
    Now = util:unixtime(),
    DayOnlineTime = case util:is_same_day2(Now, T) of
        true -> OnlineTime + (Now - T);
        _ -> 0
    end,
    case DayOnlineTime >= NeedOnlineTime of
        true ->
            Loss = [#loss{label = gold, val = Gold}],
            case role_gain:do(Loss, Role) of
                {false, _} -> {false, gold_less};
                {ok, NRole} -> {ok, NRole}
            end;
        false ->
            Diff = NeedOnlineTime - DayOnlineTime,
            {false, util:fbin(?L(<<"还需在线~p分~p秒">>), [Diff div 60, Diff rem 60])}
    end;
do(Role = #role{attr = #attr{fight_capacity = Power}}, _TotalCamp, _Camp, _Cond, _Args, {power, MinPower, MaxPower}) -> %% 角色战斗力
    case Power >= MinPower of
        true when Power =< MaxPower orelse MaxPower =:= 0 -> {ok, Role};
        _ -> {false, ?L(<<"战斗力不达要求">>)}
    end;
do(Role = #role{attr = #attr{fight_capacity = RolePower}}, _TotalCamp, _Camp, _Cond, _Args, {total_power, MinPower, MaxPower}) -> %% 角色综合战斗力
    PetPower = case pet_api:get_max(#pet.fight_capacity, Role) of
        #pet{fight_capacity = PetPower1} -> PetPower1;
        _ -> 0
    end,
    TotalPower = PetPower + RolePower,
    case TotalPower >= MinPower of
        true when TotalPower =< MaxPower orelse MaxPower =:= 0 -> {ok, Role};
        _ -> {false, ?L(<<"综合战斗力不达要求">>)}
    end;
do(Role, _TotalCamp, _Camp, _Cond, _Args, {petpower, MinPower, MaxPower}) -> %% 宠物战斗力
    PetPower = case pet_api:get_max(#pet.fight_capacity, Role) of
        #pet{fight_capacity = PetPower1} -> PetPower1;
        _ -> 0
    end,
    case PetPower >= MinPower of
        true when PetPower =< MaxPower orelse MaxPower =:= 0 -> {ok, Role};
        _ -> {false, ?L(<<"宠物战斗力不达要求">>)}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {eqm_enchant, Min, Max}) -> %% 装备强化
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"装备强化到~p至~p才可领取">>), [Min, Max])}
    end;
do(Role = #role{eqm = Eqm}, _TotalCamp, _Camp, _Cond, _Item, {eqm_purple, Min, Max}) -> %% 紫色装备数量
    L = [Item || Item <- Eqm, Item#item.quality =:= ?quality_purple],
    Val = length(L),
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"紫色装备数量拥有~p至~p才可领取">>), [Min, Max])}
    end;
do(Role = #role{eqm = Eqm}, _TotalCamp, _Camp, _Cond, _Item, {eqm_orange, Min, Max}) -> %% 橙色装备数量
    L = [Item || Item <- Eqm, Item#item.quality =:= ?quality_orange],
    Val = length(L),
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"橙色装备数据拥有~p至~p才可领取">>), [Min, Max])}
    end;
do(Role = #role{eqm = Eqm}, _TotalCamp, _Camp, _Cond, _Item, {eqm_polish, Min, Max}) -> %% 洗练橙色装备数量
    L = [Item || Item <- Eqm, Item#item.quality =:= ?quality_orange, check_other(item_polish, Item)],
    Val = length(L),
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"洗练橙色装备数据拥有~p至~p才可领取">>), [Min, Max])}
    end;
do(Role = #role{skill = #skill_all{skill_list = Skills}}, _TotalCamp, _Camp, _Cond, _Args, {skill, Min, Max}) -> %% 人物技能阶数达到XX至XX
    Val = case [Skill#skill.lev || Skill <- Skills] of
        [] -> 0;
        L -> lists:max(L)
    end,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"技能阶数升到~p至~p才可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {pet_potential_avg, Min, Max}) -> %% 宠物平均潜力
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"宠物平均潜力达~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {pet_grow, Min, Max}) -> %% 宠物成长
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"宠物成长达~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, #pet{skill = Skills}, {pet_skill_lev, Min, Max}) -> %% 宠物技能等级
    S1 = [pet_data_skill:get(SkillId) || {SkillId, _, _, _} <- Skills],
    Val = case [S#pet_skill.lev || S <- S1] of
        [] -> 0;
        S2 -> lists:max(S2)
    end,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"宠物技能等级达~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {mount_step, Min, Max}) -> %% 坐骑进阶等级
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"坐骑进阶等级达~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {mount_lev, Min, Max}) -> %% 坐骑等级
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"坐骑等级达~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {channel_lev, Min, Max}) -> %% 元神等级
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"元神等级达~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {channel_step, Min, Max}) -> %% 元神境界等级
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"元神境界达~p至~p可领取">>), [Min, Max])}
    end;
do(Role = #role{activity2 = #activity2{current = Val}}, _TotalCamp, _Camp, _Cond, _Arts, {activity, Min, Max}) -> %% 活跃度
    case Val >= Min of
        true when Max =:= 0 orelse Val =< Max -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"活跃度达到~w可领取">>), [Min])}
    end;
do(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {casino_acc, Min, Max}) -> %% 仙境寻宝总消耗X到Y晶钻
    Val = case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc, _, _} -> Acc;
        _ -> 0
    end,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"仙境寻宝总消耗达~p至~p可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {casino_acc_each, Min}) -> %% 仙境寻宝每消耗X晶钻
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, _} -> 
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, util:unixtime()}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                _ -> {false, util:fbin(?L(<<"仙境寻宝每消耗达~p可领取">>), [Min])}
            end;
        _ -> {false, util:fbin(?L(<<"仙境寻宝每消耗达~p可领取">>), [Min])}
    end;
do(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {npc_store_sm_acc, Min, Max}) -> %% 神秘商店总消耗X到Y晶钻
    Val = case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc, _, _} -> Acc;
        _ -> 0
    end,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"神秘商店总消耗达~p至~p可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {npc_store_sm_acc_each, Min}) -> %% 神秘商店每消耗X晶钻
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, _} -> 
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, util:unixtime()}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                _ -> {false, util:fbin(?L(<<"神秘商店每消耗达~p可领取">>), [Min])}
            end;
        _ -> {false, util:fbin(?L(<<"神秘商店每消耗达~p可领取">>), [Min])}
    end;
do(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {casino_sm_acc, Min, Max}) -> %% 仙境寻宝与神秘商店总消耗X到Y晶钻
    Val = case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc, _, _} -> Acc;
        _ -> 0
    end,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"仙境寻宝和神秘商店总消耗达~p至~p可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {casino_sm_acc_each, Min}) -> %% 仙境寻宝与神秘商店每消耗X晶钻
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, _} -> 
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, util:unixtime()}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                _ -> {false, util:fbin(?L(<<"仙境寻宝和神秘商店每消耗达~p可领取">>), [Min])}
            end;
        _ -> {false, util:fbin(?L(<<"仙境寻宝和神秘商店每消耗达~p可领取">>), [Min])}
    end;
do(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {shop_acc, Min, Max}) -> %% 商城总消耗X到Y晶钻
    Val = case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc, _, _} -> Acc;
        _ -> 0
    end,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"商城总消耗达~p至~p可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {shop_acc_each, Min}) -> %% 商城每消耗X晶钻
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, _} -> 
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, util:unixtime()}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                _ -> {false, util:fbin(?L(<<"商城每消耗达~p可领取">>), [Min])}
            end;
        _ -> {false, util:fbin(?L(<<"商城每消耗达~p可领取">>), [Min])}
    end;
do(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {casino_shop_sm, Min, Max}) -> %% 仙境/神秘商店/商城总消耗X到Y晶钻
    Val = case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc, _, _} -> Acc;
        _ -> 0
    end,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"仙境/神秘商店/商城总消耗达~p至~p可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {casino_shop_sm_each, Min}) -> %% 仙境/神秘商店/商城每消耗X晶钻
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, _} -> 
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, util:unixtime()}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                _ -> {false, util:fbin(?L(<<"仙境/神秘商店/商城每消耗达~p可领取">>), [Min])}
            end;
        _ -> {false, util:fbin(?L(<<"仙境/神秘商店/商城每消耗达~p可领取">>), [Min])}
    end;
do(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {loss_gold_all, Min, Max}) -> %% 所有总消耗(市场除外)X到Y晶钻
    Val = case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc, _, _} -> Acc;
        _ -> 0
    end,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"所有总消耗(市场除外)达~p至~p可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {loss_gold_all_each, Min}) -> %% 所有总消耗(市场除外)每消耗X晶钻
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, _} -> 
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, util:unixtime()}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                _ -> {false, util:fbin(?L(<<"所有总消耗(市场除外)每消耗达~p可领取">>), [Min])}
            end;
        _ -> {false, util:fbin(?L(<<"所有总消耗(市场除外)每消耗达~p可领取">>), [Min])}
    end;
do(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {pet_magic, Min, Max}) -> %% 魔晶消耗X到Y晶钻
    Val = case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc, _, _} -> Acc;
        _ -> 0
    end,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"魔晶消耗达~p至~p可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {pet_magic_each, Min}) -> %% 魔晶每消耗X晶钻
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, _} -> 
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, util:unixtime()}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                _ -> {false, util:fbin(?L(<<"魔晶每消耗达~p可领取">>), [Min])}
            end;
        _ -> {false, util:fbin(?L(<<"魔晶每消耗达~p可领取">>), [Min])}
    end;
do(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {loss_gold, MinGold}) -> %% 消耗X晶钻
    Val = case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc, _, _} -> Acc;
        _ -> 0
    end,
    case Val >= MinGold of
        true -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"消耗达~p可领取">>), [MinGold])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {loss_gold_each, Min}) -> %% 每消耗X晶钻
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, _} -> 
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, util:unixtime()}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                _ -> {false, util:fbin(?L(<<"每消耗达~p可领取">>), [Min])}
            end;
        _ -> {false, util:fbin(?L(<<"每消耗达~p可领取">>), [Min])}
    end;
do(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {flower_acc, Min, Max}) -> %% 累计送花X到Y朵
    Val = case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc, _, _} -> Acc;
        _ -> 0
    end,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"累计送花达~p至~p朵可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {flower_acc_each, Min}) -> %% 每累计送花X朵
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, _} -> 
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, util:unixtime()}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                _ -> {false, util:fbin(?L(<<"每累计送花~p可领取">>), [Min])}
            end;
        _ -> {false, util:fbin(?L(<<"每累计送花~p可领取">>), [Min])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {flower, Min, Max}) -> %% 单次送花X朵
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"单次送花达~p至~p朵可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {min_val, Min}) -> %% 累计X次
    Val = case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc, _, _} -> Acc;
        _ -> 0
    end,
    case Val >= Min of
        true -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"累计达~p可领取">>), [Min])}
    end;
do(Role = #role{campaign = Campaign = #campaign_role{acc_gold = AccGoldList}}, _TotalCamp, _Camp, _Cond = #campaign_cond{id = CondId}, _Args, {val_each, Min}) -> %% 每累计X次
    case lists:keyfind(CondId, 1, AccGoldList) of
        {_, Acc1, Acc2, _} -> 
            case Acc1 >= Min of
                true -> 
                    NewAccGoldList = lists:keyreplace(CondId, 1, AccGoldList, {CondId, Acc1 - Min, Acc2, util:unixtime()}),
                    {ok, Role#role{campaign = Campaign#campaign_role{acc_gold = NewAccGoldList}}};
                _ -> {false, util:fbin(?L(<<"每累计~p可领取">>), [Min])}
            end;
        _ -> {false, util:fbin(?L(<<"每累计~p可领取">>), [Min])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {practice, Min, Max}) -> %% 无限试练波数
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"无限试练达~p至~p波可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {stone_quech, Min, Max}) -> %% 宝石淬炼
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"宝石淬炼在~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {stone_smelt, Min, Max}) -> %% 宝石熔炼
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"宝石熔炼在~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {wing_step, Min, Max}) -> %% 翅膀进阶
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"翅膀进阶在~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {answer_rank, Min, Max}) -> %% 每天答题排行
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"答题排行在~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {guild_td_score, Min, Max}) -> %% 帮会降妖排行
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"帮会降妖排行在~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {guard_rank, Min, Max}) -> %% 洛水攻城排行
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"洛水攻城排行在~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {super_boss_total_dmg_rank, Min, Max}) -> %% 远古巨龙总伤害排行
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"远古巨龙总伤害排行在~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {super_boss_dmg_rank, Min, Max}) -> %% 远古巨龙单次伤害排行
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"远古巨龙单次伤害排行在~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {guild_arena_rank, Min, Max}) -> %% 帮会战排行
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"帮会战排行在~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {guild_war_rank, Min, Max}) -> %% 阵营战排行
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"阵营战排行在~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {arena_rank, Min, Max}) -> %% 竞技场各组排行
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"竞技场各组排行在~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, NpcBaseId, {dungeon_domen, Min, Max}) -> %% 精灵幻境层
    Val = npc_to_index(dungeon_domen, NpcBaseId),
    case Val > 0 andalso Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"精灵幻境达~p至~p层可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, NpcBaseId, {dungeon_tower, Min, Max}) -> %% 表镇妖塔层数
    Val = npc_to_index(dungeon_tower, NpcBaseId),
    case Val > 0 andalso Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"表镇妖塔达~p至~p层可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, NpcBaseId, {dungeon_tower_hard, Min, Max}) -> %% 里镇妖塔层数
    Val = npc_to_index(dungeon_tower_hard, NpcBaseId),
    case Val > 0 andalso Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"地狱镇妖塔达~p至~p层可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, NpcBaseId, {dungeon_tower_all, Min, Max}) -> %% 镇妖塔层数(不区分里表)
    Val = case npc_to_index(dungeon_tower_hard, NpcBaseId) of
        0 -> npc_to_index(dungeon_tower, NpcBaseId);
        Val1 -> Val1
    end,
    case Val > 0 andalso Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"镇妖塔达~p至~p层可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, NpcBaseId, {dungeon_loong, Min, Max}) -> %% 表洛水龙宫层数
    Val = npc_to_index(dungeon_loong, NpcBaseId),
    case Val > 0 andalso Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"表洛水龙宫达~p至~p层可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, NpcBaseId, {dungeon_loong_hard, Min, Max}) -> %% 里洛水龙宫层数
    Val = npc_to_index(dungeon_loong_hard, NpcBaseId),
    case Val > 0 andalso Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"里洛水龙宫达~p至~p层可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, NpcBaseId, {dungeon_loong_all, Min, Max}) -> %% 洛水龙宫层数
    Val = case npc_to_index(dungeon_loong_hard, NpcBaseId) of
        0 -> npc_to_index(dungeon_loong, NpcBaseId);
        Val1 -> Val1
    end,
    case Val > 0 andalso Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"洛水龙宫达~p至~p层可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = #campaign_role{day_online = {_, Val}}}, _TotalCamp, _Camp, _Cond, _Args, {online_time, Min, Max}) -> %% 在线时长
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"在线时长在~p至~p秒可领取">>), [Min, Max])}
    end;
do(Role = #role{campaign = #campaign_role{keep_days = {Days, _}}}, _TotalCamp, _Camp = #campaign_adm{start_time = StartTime}, _Cond, _Args, {keep_days, Min, Max}) -> %% 在线时长
    Now = util:unixtime(),
    CampDays = util:day_diff(Now, StartTime) + 1,  %% 活动开始多少天了
    Val = lists:min([CampDays, Days]), %% 取连续在线天数据和活动开始天数最小值作为活动连续登录天数
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"连续在线天数在~p至~p秒可领取">>), [Min, Max])}
    end;
do(Role = #role{vip = #vip{type = Type}, campaign = #campaign_role{day_online = {_, Val}}}, _TotalCamp, _Camp, _Cond, _Args, {online_time_vip_week, Min, Max}) when Type =:= ?vip_week -> %% 周VIP在线时长
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"在线时长在~p至~p秒可领取">>), [Min, Max])}
    end;
do(Role = #role{vip = #vip{type = Type}, campaign = #campaign_role{day_online = {_, Val}}}, _TotalCamp, _Camp, _Cond, _Args, {online_time_vip_month, Min, Max}) when Type =:= ?vip_month -> %% 月VIP在线时长
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"在线时长在~p至~p秒可领取">>), [Min, Max])}
    end;
do(Role = #role{vip = #vip{type = Type}, campaign = #campaign_role{day_online = {_, Val}}}, _TotalCamp, _Camp, _Cond, _Args, {online_time_vip_half_year, Min, Max}) when Type =:= ?vip_half_year -> %% 半年VIP在线时长
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"在线时长在~p至~p秒可领取">>), [Min, Max])}
    end;
do(Role = #role{vip = #vip{type = Type}, campaign = #campaign_role{day_online = {_, Val}}}, _TotalCamp, _Camp, _Cond, _Args, {online_time_vip, Min, Max}) when Type =:= ?vip_week orelse Type =:= ?vip_month orelse Type =:= ?vip_half_year -> %% VIP在线时长
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"在线时长在~p至~p秒可领取">>), [Min, Max])}
    end;
do(Role = #role{vip = #vip{type = Type}, campaign = #campaign_role{day_online = {_, Val}}}, _TotalCamp, _Camp, _Cond, _Args, {online_time_vip_no, Min, Max}) when Type =:= ?vip_no orelse Type =:= ?vip_try -> %% 非VIP在线时长
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"在线时长在~p至~p秒可领取">>), [Min, Max])}
    end;
do(Role = #role{login_info = #login_info{last_logout = LogoutTime}}, _TotalCamp, _Camp, _Cond, _Args, {offline_time, Min, Max}) -> %% 离线时长
    Now = util:unixtime(),
    Val = (Now - LogoutTime) / 3600,
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"离线时长在~p至~p小时可领取">>), [Min, Max])}
    end;
do(Role = #role{vip = #vip{type = VipType}, assets = #assets{charge = Charge}}, _TotalCamp, _Camp, _Cond, _Args, {login, Type}) -> %% 玩家登录
    case Type of
        1 -> {ok, Role};   %% 所有玩家
        2 when VipType =:= ?vip_week orelse VipType =:= ?vip_month orelse VipType =:= ?vip_half_year -> {ok, Role};
        3 when VipType =:= ?vip_no orelse VipType =:= ?vip_try -> {ok, Role};
        4 when Charge > 0 -> {ok, Role};
        5 when Charge =:= 0 -> {ok, Role};
        6 when VipType =:= ?vip_week -> {ok, Role};
        7 when VipType =:= ?vip_month -> {ok, Role};
        8 when VipType =:= ?vip_half_year -> {ok, Role};
        _ -> {false, ?L(<<"登录类型不正确">>)}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Type, {sworn, NeedType}) -> %% 结拜
    case Type =:= NeedType orelse NeedType =:= 0 of
        true -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"结拜类型为~p可领取">>), [NeedType])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, {Type, _}, {world_compete, NeedType}) -> %% 仙道会
    case Type =:= NeedType orelse NeedType =:= 0 of
        true -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"仙道会类型为~p可领取">>), [NeedType])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, {_, Val}, {world_compete_wins, Min, Max}) -> 
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"仙道会连胜达~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, {Type, Color}, {escort, NeedType, NeedColor}) -> %% 护送
    case (Type =:= NeedType orelse NeedType =:= 0) andalso (Color =:= NeedColor orelse NeedColor =:= 99) of
        true -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"护送类型为~p、~p可领取">>), [NeedType, NeedColor])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, {Quality, Lev}, {eqm_make, NeedQ, NeedLev}) -> %% 装备生产
    case (Quality =:= NeedQ orelse NeedQ =:= 99) andalso (Lev div 10 =:= NeedLev orelse NeedLev =:= 0) of
        true -> {ok, Role};
        _ -> {false, <<>>}
    end;
do(Role, _TotalCamp, _Camp, _Cond, {_Color, Val}, {pet_magic_lev, Min, Max}) -> %% 魔晶等级
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"魔晶等级达~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, {Color, Val}, {pet_magic_lev_qua, Min, Max, Quality}) -> %% 魔晶等级与品质
    case Color =:= Quality orelse Quality =:= 99 of
        true ->
            case Val >= Min of
                true when Val =< Max orelse Max =:= 0 -> {ok, Role};
                _ -> {false, util:fbin(?L(<<"魔晶等级达~p至~p级可领取">>), [Min, Max])}
            end;
        false -> {false, util:fbin(?L(<<"魔晶等级达~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {god_lev, Min, Max}) -> %% 神佑等级
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"神佑等级达~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {soul_world_magic_lev, Min, Max}) -> %% 灵戒洞天法宝等级
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"灵戒洞天法宝等级达~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, {_Color, Val}, {soul_world_spirit_lev, Min, Max}) -> 
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"灵戒洞天妖灵等级达~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, {Color, Val}, {soul_world_spirit_lev_qua, Min, Max, Quality}) -> %% 妖灵等级与品质
    case Color =:= Quality orelse Quality =:= 99 of
        true ->
            case Val >= Min of
                true when Val =< Max orelse Max =:= 0 -> {ok, Role};
                _ -> {false, util:fbin(?L(<<"灵戒洞天妖灵等级达~p至~p级可领取">>), [Min, Max])}
            end;
        false -> {false, util:fbin(?L(<<"灵戒洞天妖灵等级达~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {demon_shape_lev, Min, Max}) -> 
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"守护化形等级达~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {demon_lev, Min, Max}) -> 
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"守护等级达~p至~p级可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, #task{type = ?task_type_xx, quality = Quality}, {task_xx, NeedColor}) -> 
    case NeedColor =:= Quality orelse NeedColor =:= 99 of
        true -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"完成指定品质[~p]修行任务可领取">>), [NeedColor])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {wing_skill_step, NeedLev}) -> 
    case Val =:= NeedLev orelse NeedLev =:= 0 of
        true -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"翅膀技能达~p级可领取">>), [NeedLev])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {king_kills, Min, Max}) -> 
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"至尊王者连斩达~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {demon_skill_step, NeedLev}) -> 
    case Val =:= NeedLev orelse NeedLev =:= 0 of
        true -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"守护神通等级达~p可领取">>), [NeedLev])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Lev, {condense, NeedLev}) -> 
    case Lev div 10 =:= NeedLev orelse NeedLev =:= 0 of
        true -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"凝炼装备[~p]可领取">>), [NeedLev])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Val, {range, Min, Max}) ->
    case Val >= Min of
        true when Val =< Max orelse Max =:= 0 -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"数值范围在~p至~p可领取">>), [Min, Max])}
    end;
do(Role, _TotalCamp, _Camp, _Cond, Quality, {pet_rb_qua, NeedColor}) ->
    case NeedColor =:= Quality orelse NeedColor =:= 99 of
        true -> {ok, Role};
        _ -> {false, util:fbin(?L(<<"激活指定品质宠物真身[~p]可领取">>), [NeedColor])}
    end;
do(_Role, _TotalCamp, _Camp, _Cond, _Args, _C) ->
    %% ?ERR("非法条件[~w]", [_C]),
    {false, ?L(<<"条件没有达成，不能领取">>)}.

%%--------------------------------------
%% 内部方法
%%--------------------------------------

%%判断总活动
check(_Role, _TotalCamp) -> true.

%% 判断子活动
check(_Role, _TotalCamp, _Camp) -> true.

%% 判断活动规则
check(#role{lev = RoleLev}, _TotalCamp, _Camp, #campaign_cond{min_lev = MinLev, max_lev = MaxLev}) when RoleLev < MinLev orelse (RoleLev > MaxLev andalso MaxLev =/= 0) -> {false, ?L(<<"等级不符，不能参与本次活动！">>)};
check(_Role, _TotalCamp, _Camp, _Cond) -> true.


%% 特殊判断
check_other(item_polish, #item{attr = Attr}) -> %% 判断装备是否洗练
    Sattr = [{Name, Flag, Value} || {Name, Flag, Value} <- Attr, Flag >= 100010 andalso Flag =< 1010051],    
    length(Sattr) > 0;
check_other(_Label, _) -> false.

npc_to_index(_Label, _NpcBaseId) -> 0.


