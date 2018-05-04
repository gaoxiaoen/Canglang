%%----------------------------------------------------
%% 活动管理进程

%% @author whjing2011@gmail.com
%%----------------------------------------------------

-module(campaign_adm).
-behaviour(gen_server).
-export([
        start_link/0
        ,is_camp_time/1
        ,get_camp_time/1
        ,get_camp_time/2
        ,get_camp_id/2
        ,get_camp_conf/4
        ,get_camp_task/1
        ,get_camp_pay_ico/1
        ,get_camp_pay_ico2/1
        ,get_camp_pay_new_ico/1
        ,get_camp_loss_ico/1
        ,lookup/1
        ,lookup/2
        ,lookup/3
        ,lookup_open/1
        ,lookup_open/2
        ,lookup_open/3
        ,apply/2
        ,list_all/0
        ,list_all/1
        ,list_type/1
        ,list_type/2
        ,list_all_not_finish/0
        ,reload/0
        ,check_can_reward/2
        ,get_luck_list/0
        ,get_main_camp_total/0
        ,get_main_camp_total/1
        ,get_main_camp_total_id/0
        ,pack_send_camp_info/2
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {}).
-record(campaign_rewarded, { %% 已领取列表 存于ETS中，防止数据库失效时被刷
        key = {0, 0}
        ,num = 1
        ,last_time = 0     %% 最后奖励时间
    }
).

-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").
-include("rank.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("item.hrl").

-define(max_nexttime, 10 * 24 * 3600).

%% 判断指定类型是否在活动时间 true | false
is_camp_time(spring_double) -> is_camp_time(?camp_type_play_spring_double);
is_camp_time(casino3) -> is_camp_time(?camp_type_play_casino3);
is_camp_time(casino4) -> is_camp_time(?camp_type_play_casino4);
is_camp_time(npc_store_sm) -> is_camp_time(?camp_type_play_npc_store_sm);
is_camp_time(lottery_camp) -> is_camp_time(?camp_type_play_lottery_camp);
is_camp_time(escort_double) -> is_camp_time(?camp_type_play_escort_double);
is_camp_time(arena_double) -> is_camp_time(?camp_type_play_arena_double);
is_camp_time(longzhu) -> is_camp_time(?camp_type_play_longzhu);
is_camp_time(world_compete) -> is_camp_time(?camp_type_play_world_compete);
is_camp_time(guild_arena) -> is_camp_time(?camp_type_play_guild_arena);
is_camp_time(task_xx_double) -> is_camp_time(?camp_type_play_task_xx_double);
is_camp_time(sworn) -> is_camp_time(?camp_type_game_sworn_price);
is_camp_time(camp_tree) -> is_camp_time(?camp_type_play_tree);
is_camp_time(lottery_gold) -> is_camp_time(?camp_type_play_lottery_gold);
is_camp_time(Type) when is_integer(Type) -> 
    list_type(now, Type) =/= [];
%% 判断指定类型是否在活动时间
is_camp_time(_Label) -> false.

%% 获取指定活动的时间段 {StartTime, EndTime}
get_camp_time(casino3) -> get_camp_time(?camp_type_play_casino3);
get_camp_time(casino4) -> get_camp_time(?camp_type_play_casino4);
get_camp_time(lottery_camp) -> get_camp_time(?camp_type_play_lottery_camp);
get_camp_time(luck) -> get_camp_time(?camp_type_play_luck);
get_camp_time(dungeon_poetry) -> get_camp_time(?camp_type_play_dungeon_poetry);
get_camp_time(charge_card) -> get_camp_time(?camp_type_play_charge_card);
get_camp_time(charge_card_reward) -> get_camp_time(?camp_type_play_charge_card_reward);
get_camp_time(repay_consume) -> get_camp_time(?camp_type_play_repay_consume);
get_camp_time(lottery_gold) -> get_camp_time(?camp_type_play_lottery_gold);
get_camp_time(Type) when is_integer(Type) ->
    case list_type(now, Type) of
        [{_, #campaign_adm{start_time = StartTime, end_time = EndTime}, _} | _] -> {StartTime, EndTime};
        _1 ->
            case list_type(not_finish, Type) of
                [{_, #campaign_adm{start_time = StartTime, end_time = EndTime}, _} | _] -> {StartTime, EndTime};
                _ -> {0, 0}
            end
    end;
get_camp_time(_) -> {0, 0}.

%% 获取活动时间
get_camp_time(Type, {ST1, ET1}) ->
    {ST2, ET2} = get_camp_time(Type),
    Now = util:unixtime(),
    if
        ET1 < Now andalso ET2 < Now -> {ST1, ET1};   %% 两个活动时间段都已结束
        ET1 < Now -> {ST2, ET2};  %% 其中一个时间段结束 取另外一个
        ET2 < Now -> {ST1, ET1};
        ST1 < ST2 -> {ST1, ET1};  %% 两个都没结束 取时间段开始时间小的
        true -> {ST2, ET2}
    end.

%% 获取指定类型的活动 {TotalID, CampId, CondId};
get_camp_id(charge_card, Default) -> get_camp_id(?camp_type_play_charge_card, Default);
get_camp_id(charge_card_reward, Default) -> get_camp_id(?camp_type_play_charge_card_reward, Default);
get_camp_id(Type, Default) when is_integer(Type) ->
    case list_type(now, Type) of
        [{#campaign_total{id = TotalID}, #campaign_adm{id = CampId}, #campaign_cond{id = CondId}} | _] -> 
            {TotalID, CampId, CondId};
        _ ->
            case list_type(not_finish, Type) of
                [{#campaign_total{id = TotalID}, #campaign_adm{id = CampId}, #campaign_cond{id = CondId}} | _] -> 
                    {TotalID, CampId, CondId};
                _ -> Default
            end
    end;
get_camp_id(_Type, Default) ->
    Default.

%% @spec get_camp_conf(Type::integer(), CampId::term(), STime::integer(), ETime::integer()) -> {NewCampId::integer(), StartTime::integer(), EndTime::integer()}
%% 获取活动ID和活动时间信息
get_camp_conf(Type, CampId, STime, ETime) when is_integer(Type) ->
    case list_type(now, Type) of
        [{#campaign_total{id = _TotalID}, #campaign_adm{id = _CampId, start_time = StartTime, end_time = EndTime}, #campaign_cond{id = CondId}} | _] -> 
            {CondId, StartTime, EndTime};
        _ ->
            case list_type(not_finish, Type) of
                [{#campaign_total{id = _TotalID}, #campaign_adm{id = _CampId, start_time = StartTime, end_time = EndTime}, #campaign_cond{id = CondId}} | _] -> 
                    {CondId, StartTime, EndTime};
                _ -> {CampId, STime, ETime} 
            end
    end;
get_camp_conf(_Type, CampId, StartTime, EndTime) -> {CampId, StartTime, EndTime}.


%% 获取运势顺序
get_luck_list() ->
    L = list_type(now, ?camp_type_play_luck),
    [{LuckType1, LuckType2} || {_, _, #campaign_cond{conds = [{luck_type, LuckType1, LuckType2}]}} <- L].

%% 获取活动任务
get_camp_task(Role) ->
    case list_type(now, [?camp_type_pay_each_task, ?camp_type_pay_acc_task]) of
        [{TotalCamp = #campaign_total{id = TotalID}
                ,Camp = #campaign_adm{id = CampId}
                ,Cond = #campaign_cond{id = CondId, type = Type, sec_type = SecType, hf = HF, skin_type = SkinType, skin_id = SkinId, attr_msg = AttrMsg, say_msg = SayMsg, items = Items, flash_items = FlashItems}} 
            | _] -> 
            case campaign_adm_reward:check_reward(TotalCamp, Camp, Cond, Role) of
                true -> {TotalID, CampId, CondId, Type, SecType, HF, SkinType, SkinId, AttrMsg, SayMsg, Items, FlashItems};
                false -> {0, 0, 0, 0, 0, <<>>, 0, 0, <<>>, <<>>, [], []}
            end;
        _ -> {0, 0, 0, 0, 0, <<>>, 0, 0, <<>>, <<>>, [], []}
    end.

%% 获取日常充值图标
get_camp_pay_ico(Role = #role{id = {Rid, SrvId}}) ->
    Now = util:unixtime(),
    L = list_all(Now),
    case list_type(?camp_type_pay_acc_ico, L) of
        [] -> 
            {0, 0, 0, 0, 0, []};
        [{#campaign_total{id = TotalID}, #campaign_adm{id = CampId, start_time = StartTime, end_time = EndTime, is_show_time = IsShowTime}, _} | _] ->
            PayL = list_type([?camp_type_pay_acc_ico, ?camp_type_pay_acc_task], L),
            DayStart = util:unixtime(today),
            Acc = campaign_dao:calc_charge(Rid, SrvId, begin_time, StartTime),
            DayAcc = case StartTime > DayStart of
                true -> Acc;
                false -> campaign_dao:calc_charge(Rid, SrvId, begin_time, DayStart)
            end,
            Fun = fun({TotalCamp, Camp, Cond = #campaign_cond{id = CondId, type = Type, sec_type = SecType, msg = Msg, conds = [{_, NeedGold, _}], sort_val = SortVal, items = Items, flash_items = FlashItems, settlement_type = SettlementType}}) -> 
                    Rewarded = case campaign_adm_reward:check_reward(TotalCamp, Camp, Cond, Role) of
                        true -> 0;
                        _ -> 1
                    end,
                    PayGold = case SettlementType of
                        ?camp_settlement_type_everyday -> DayAcc;
                        _ -> Acc
                    end,
                    {CondId, SortVal, Type, SecType, Msg, NeedGold, PayGold, Rewarded, Items, FlashItems}
            end,
            CondL = lists:map(Fun, PayL),
            {TotalID, CampId, StartTime, EndTime, IsShowTime, CondL}
    end.

%% 获取活动充值图标
get_camp_pay_ico2(Role = #role{id = {Rid, SrvId}}) ->
    Now = util:unixtime(),
    L = list_all(Now),
    case list_type(?camp_type_pay_acc_ico2, L) of
        [] -> 
            {0, 0, 0, 0, 0, []};
        PayL = [{#campaign_total{id = TotalID}, #campaign_adm{id = CampId, start_time = StartTime, end_time = EndTime, is_show_time = IsShowTime}, _} | _] ->
            DayStart = util:unixtime(today),
            Acc = campaign_dao:calc_charge(Rid, SrvId, begin_time, StartTime),
            DayAcc = case StartTime > DayStart of
                true -> Acc;
                false -> campaign_dao:calc_charge(Rid, SrvId, begin_time, DayStart)
            end,
            Fun = fun({TotalCamp, Camp, Cond = #campaign_cond{id = CondId, type = Type, sec_type = SecType, msg = Msg, conds = [{_, NeedGold, _}], sort_val = SortVal, items = Items, flash_items = FlashItems, settlement_type = SettlementType}}) -> 
                    Rewarded = case campaign_adm_reward:check_reward(TotalCamp, Camp, Cond, Role) of
                        true -> 0;
                        _ -> 1
                    end,
                    PayGold = case SettlementType of
                        ?camp_settlement_type_everyday -> DayAcc;
                        _ -> Acc
                    end,
                    {CondId, SortVal, Type, SecType, Msg, NeedGold, PayGold, Rewarded, Items, FlashItems}
            end,
            CondL = lists:map(Fun, PayL),
            {TotalID, CampId, StartTime, EndTime, IsShowTime, CondL}
    end.

%% 获取新版手动领取活动图标
get_camp_pay_new_ico(Role = #role{id = {Rid, SrvId}, campaign = #campaign_role{acc_gold = AccGoldList}}) ->
    Now = util:unixtime(),
    L = list_all(Now),
    case list_type(?camp_type_pay_acc_ico3, L) of
        [] -> 
            {0, 0, 0, 0, 0, [], [], []};
        PayL1 = [{TotalCamp = #campaign_total{id = TotalID}, Camp = #campaign_adm{id = CampId, start_time = StartTime, end_time = EndTime, is_show_time = IsShowTime}, _Cond = #campaign_cond{id = CondId, type = Type, sec_type = SecType, msg = Msg, conds = [{_, NeedGold, _}], sort_val = SortVal, flash_items = FlashItems, settlement_type = SettlementType}} | _] ->
            DayStart = util:unixtime(today),
            Acc = campaign_dao:calc_charge(Rid, SrvId, begin_time, StartTime),
            DayAcc = case StartTime > DayStart of
                true -> Acc;
                false -> campaign_dao:calc_charge(Rid, SrvId, begin_time, DayStart)
            end,
            Conds = [Cond || {_, _, Cond} <- PayL1],
            Rewarded = case campaign_adm_reward:check_reward(TotalCamp, Camp, Conds, Role) of
                true -> 0;
                _ -> 1
            end,
            PayGold = case SettlementType of
                ?camp_settlement_type_everyday -> DayAcc;
                _ -> Acc
            end,
            %% 充值
            Fun = fun({_TotalCamp, _Camp, #campaign_cond{items = Items}}) -> 
                    {CondId, Items}
            end,
            SpliceItems = lists:map(Fun, PayL1),
            Cond1 = {CondId, SortVal, Type, SecType, Msg, NeedGold, PayGold, Rewarded, SpliceItems, FlashItems},
            PayL2 = list_type([?camp_type_pay_acc_task], L),
            Fun2 = fun({TotalCamp2, Camp2, Cond2 = #campaign_cond{id = CondId2, type = Type2, sec_type = SecType2, msg = Msg2, conds = [{_, NeedGold2, _}], sort_val = SortVal2, items = Items2, flash_items = FlashItems2, settlement_type = SettlementType2}}) -> 
                    Rewarded2 = case campaign_adm_reward:check_reward(TotalCamp2, Camp2, Cond2, Role) of
                        true -> 0;
                        _ -> 1
                    end,
                    PayGold2 = case SettlementType2 of
                        ?camp_settlement_type_everyday -> DayAcc;
                        _ -> Acc
                    end,
                    {CondId2, SortVal2, Type2, SecType2, Msg2, NeedGold2, PayGold2, Rewarded2, [{CondId2, Items2}], FlashItems2}
            end,
            CondL2 = lists:map(Fun2, PayL2),
            CondL = [Cond1 | CondL2],
            %% 消耗
            PayL3 = list_type([?camp_type_gold_loss_gold_all_new_ico], L),
            CostFun = fun({TotalCamp3, Camp3, Cond3 = #campaign_cond{id = CondId3, type = Type3, sec_type = SecType3, msg = Msg3, conds = [{_, NeedGold3}], sort_val = SortVal3, items = Items3, flash_items = FlashItems3, settlement_type = SettType3}}) -> 
                    Rewarded3 = case campaign_adm_reward:check_reward(TotalCamp3, Camp3, Cond3, Role) of
                        true -> 0;
                        _ -> 1
                    end,
                    HadGold = case lists:keyfind(CondId3, 1, AccGoldList) of
                        {_, Acc1, _Acc2, Time} when SettType3 =:= ?camp_settlement_type_everyday -> %% 每天重新计算
                            case util:is_same_day2(Time, Now) of
                                true -> Acc1; %% 同一天 
                                false -> 0
                            end;
                        {_, Acc1, _Acc2, _Time} -> %% 
                            Acc1;
                        _ -> 0
                    end,
                    {CondId3, SortVal3, Type3, SecType3, Msg3, NeedGold3, HadGold, Rewarded3, Items3, FlashItems3}
            end,
            CostCondL = lists:map(CostFun, PayL3),
            %% 兑换
            PayL4 = list_type([?camp_type_play_new_exchange], L),
            ExchangeFun = fun({_TotalCamp4, _Camp4, _Cond4 = #campaign_cond{id = CondId4, type = Type4, sec_type = SecType4, msg = Msg4, conds = [{_, ItemId4, ItemNum4}], sort_val = SortVal4, items = Items4, flash_items = FlashItems4, reward_msg = RewardMsg}}) -> 
                    LossItem = [{ItemId4, 0, ItemNum4}],
                    PreviewItems = case catch util:bitstring_to_term(RewardMsg) of
                        {ok, PreItems} when is_list(PreItems) -> [{Baseid4, Bind4, Num4} || {Baseid4, Bind4, Num4} <- PreItems, is_integer(Baseid4)];
                        _ -> []
                    end,
                    {CondId4, SortVal4, Type4, SecType4, Msg4, NeedGold, PayGold, LossItem, Items4, PreviewItems, FlashItems4}
            end,
            ExchangeCondL = lists:map(ExchangeFun, PayL4),
            {TotalID, CampId, StartTime, EndTime, IsShowTime, CondL, CostCondL, ExchangeCondL}
    end.

%% 获取消费图标
get_camp_loss_ico(Role = #role{campaign = #campaign_role{acc_gold = AccGoldList}}) ->
    Now = util:unixtime(),
    L = list_all(Now),
    case list_type([?camp_type_gold_casino_shop_sm_ico, ?camp_type_gold_loss_gold_all_ico], L) of
        [] -> 
            {0, 0, 0, 0, 0, 0, []};
        PayL = [{#campaign_total{id = TotalID}, #campaign_adm{id = CampId, start_time = StartTime, end_time = EndTime, is_show_time = IsShowTime}, #campaign_cond{id = CondId1, settlement_type = SettType}} | _] ->
            LossGold = case lists:keyfind(CondId1, 1, AccGoldList) of
                {_, Acc1, _Acc2, Time} when SettType =:= ?camp_settlement_type_everyday -> %% 每天重新计算
                    case util:is_same_day2(Time, Now) of
                        true -> Acc1; %% 同一天 
                        false -> 0
                    end;
                {_, Acc1, _Acc2, _Time} -> %% 
                    Acc1;
                _ -> 0
            end,
            Fun = fun({TotalCamp, Camp, Cond = #campaign_cond{id = CondId, type = Type, sec_type = SecType, msg = Msg, conds = [{_, NeedGold}], sort_val = SortVal, items = Items, flash_items = FlashItems}}) -> 
                    Rewarded = case campaign_adm_reward:check_reward(TotalCamp, Camp, Cond, Role) of
                        true -> 0;
                        _ -> 1
                    end,
                    {CondId, SortVal, Type, SecType, Msg, NeedGold, Rewarded, Items, FlashItems}
            end,
            CondL = lists:map(Fun, PayL),
            {TotalID, CampId, StartTime, EndTime, IsShowTime, LossGold, CondL}
    end.

%% 所有总活动
list_all() ->
    case catch ets:tab2list(campaign_adm_data_list) of
        L when is_list(L) -> L;
        _ -> []
    end.

%% 获取所有当前时间有效活动
list_all(Now) ->
    L = list_all(),
    list_all(Now, L).
list_all(Now, L) ->
    NewL = [TotalCamp#campaign_total{camp_list = [Camp || Camp = #campaign_adm{start_time = STime, end_time = ETime} <- CampList, Now >= STime, (Now < ETime orelse ETime =:= 0)]} || TotalCamp = #campaign_total{camp_list = CampList, start_time = StartTime, end_time = EndTime} <- L, StartTime =< Now, (Now < EndTime orelse EndTime =:= 0)],
    [TotalCamp1 || TotalCamp1 = #campaign_total{camp_list = CampList1} <- NewL, CampList1 =/= []].

%% 获取所有正在进行或未开始的活动总和，即未结束
list_all_not_finish() ->
    Now = util:unixtime(),
    L = list_all(),
    [Camp || Camp = #campaign_total{end_time = EndTime} <- L, (Now < EndTime orelse EndTime =:= 0)].

%% 获取指定活动数据
lookup(Id) ->
    case catch ets:lookup(campaign_adm_data_list, Id) of
        [] ->
            false;
        [H] when is_record(H, campaign_total) ->
            H;
        _Err ->
            ?ERR("ETS活动数据异常，[Data:~w]", [_Err]),
            false
    end.

%% 获取指定活动数据
lookup(TotalID, CampId) ->
    case lookup(TotalID) of
        false -> false;
        TotalCamp = #campaign_total{camp_list = CampList} ->
            case lists:keyfind(CampId, #campaign_adm.id, CampList) of
                false -> false;
                Camp -> {ok, TotalCamp, Camp}
            end 
    end.

%% 获取指定活动数据
lookup(TotalID, CampId, CondId) ->
    case lookup(TotalID, CampId) of
        false -> false;
        {ok, TotalCamp, Camp = #campaign_adm{conds = Conds}} ->
            case lists:keyfind(CondId, #campaign_cond.id, Conds) of
                false -> false;
                Cond -> {ok, TotalCamp, Camp, Cond}
            end 
    end.

%% 获取一个正在进行的总活动数据
lookup_open(TotalID) ->
    Now = util:unixtime(),
    case lookup(TotalID) of
        TotalCamp = #campaign_total{start_time = StartTime, end_time = EndTime, camp_list = CampList} when StartTime =< Now andalso (Now < EndTime orelse EndTime =:= 0) -> 
            NewCampList = [Camp || Camp <- CampList, Camp#campaign_adm.start_time =< Now, (Now < Camp#campaign_adm.end_time orelse Camp#campaign_adm.end_time =:= 0)],
            TotalCamp#campaign_total{camp_list = NewCampList};
        _ -> false
    end.

%% 根据角色信息获取一个正在进行的总活动数据
lookup_open(Role, TotalID) ->
    lookup_open(Role, TotalID, reward).
lookup_open(Role, TotalID, Label) ->
    case lookup_open(TotalID) of
        false -> false;
        TotalCamp = #campaign_total{camp_list = CampList} ->
            NewCampList = [Camp#campaign_adm{conds = [to_client_cond(Cond) || Cond <- Conds, check_cond(Label, Role, Cond)]} || Camp = #campaign_adm{conds = Conds} <- CampList, Camp#campaign_adm.ico =/= <<"hide">>],
            TotalCamp#campaign_total{camp_list = NewCampList}
    end.
check_cond(_Label, #role{sex = Sex}, #campaign_cond{sex = NeedSex}) when Sex =/= NeedSex andalso NeedSex =/= 99 -> false; %% 性别需求不符
check_cond(_Label, #role{career = Career}, #campaign_cond{career = NeedCareer}) when Career =/= NeedCareer andalso NeedCareer =/= 0 -> false; %% 职业需求不符

check_cond(rpc, _Role, #campaign_cond{sec_type = SecType}) when SecType =:= ?camp_type_pay_acc_ico3 orelse SecType =:= ?camp_type_play_new_exchange orelse SecType =:= ?camp_type_gold_loss_gold_all_new_ico -> false; %% 新版福利

check_cond(_Label, _Role, #campaign_cond{reward_msg = <<"hide">>}) -> false; %% 辅助规则不显示在客户端
check_cond(_Label, _Role, _Cond) -> true.
to_client_cond(Cond = #campaign_cond{sec_type = ?camp_type_pay_rate}) -> Cond#campaign_cond{gold = 0};
to_client_cond(Cond) -> Cond.

%% 获取指定类型所有活动列表[{TotalCamp, Camp, Cond}...]
list_type(TypeList) ->
    list_type(not_finish, TypeList).
list_type(not_finish, TypeList) ->
    L = list_all_not_finish(),
    list_type(TypeList, L);
list_type(now, TypeList) ->
    Now = util:unixtime(),
    L = list_all(Now),
    list_type(TypeList, L);
list_type(TypeList, L) ->
    do_list_type(TypeList, L, []).

%% 判断角色是否可领取
check_can_reward(Rid, #campaign_cond{id = CondId, reward_num = RewardNum, settlement_type = SettlementType}) ->
    L = ets:tab2list(campaign_rewarded_list),
    case lists:keyfind({Rid, CondId}, #campaign_rewarded.key, L) of
        #campaign_rewarded{num = Num, last_time = LastTime} when SettlementType =:= ?camp_settlement_type_everyday andalso Num >= RewardNum -> %% 之前领取过
            Now = util:unixtime(),
            util:is_same_day2(LastTime, Now) =:= false;
        #campaign_rewarded{num = Num} -> %% 之前领取过
            Num < RewardNum;
        _ ->
            true
    end.

apply(async, {handle, Label, RoleInfo, Args}) ->
    Now = util:unixtime(),
    case Label of
        kill_npc -> campaign_reward:handle(kill_npc, RoleInfo, Args);
        _ -> ok
    end,
    case list_all(Now) of
        L when length(L) > 0 -> 
            gen_server:cast(?MODULE, {handle, Label, RoleInfo, Args});
        _ -> ok
    end;
apply(async, Args) ->
    gen_server:cast(?MODULE, Args);
apply(sync, Args) ->
    gen_server:call(?MODULE, Args).

%% 过滤掉根职业、性别有关的信息
get_main_camp_total(Role) ->
    case get_main_camp_total_id() of
        undefined -> undefined;
        TotalId ->
            case campaign_adm:lookup_open(Role, TotalId, rpc) of
                CampTotal = #campaign_total{} ->
                    CampTotal;
                _ ->
                    undefined
            end
    end.

%% -> #campaign_total{} | undefined
get_main_camp_total() ->
    L = campaign_adm:list_all(util:unixtime()),
    CamL = [CampTotal || CampTotal <- L, CampTotal#campaign_total.ico =/= <<"hide">>],
    case CamL of
        [CampT|_] -> CampT;
        _ -> undefined
    end.

get_main_camp_total_id() ->
    case get_main_camp_total() of
        undefined -> undefined;
        #campaign_total{id = TotalId} -> TotalId
    end.

pack_send_camp_info(Role=#role{link=#link{conn_pid=ConnPid}}, Camp = #campaign_adm{conds = Conds}) ->
    case Conds of
        [#campaign_cond{type = Type, sec_type = SecType}|_] ->
            case pack_camp_info({Type, SecType}, Role, Camp) of
                {ok, Bin} -> sys_conn:send(ConnPid, Bin);
                _ -> ignore
            end;
        _ -> %% 无条件类型，公告类型
            case pack_camp_info(notice, Role, Camp) of
                {ok, Bin} -> sys_conn:send(ConnPid, Bin);
                _ -> ignore
            end
    end;
pack_send_camp_info(_ConnPid, _Camp) ->
    ignore.

%% 循环累计充值
pack_camp_info({?camp_type_pay, ?camp_type_pay_acc_each},
        _Role = #role{id = {RoleId, SrvId}}, 
        Camp = #campaign_adm{start_time = StartTime, conds = Conds, id = CampId}) ->
    %%
    ?DEBUG("循环累计充值类活动"),
    %CampTotal = get_main_camp_total(Role),
    PayAcc = campaign_dao:calc_charge(RoleId, SrvId, begin_time, StartTime),
    [#campaign_cond{
        conds = CondRule, 
        id = CondId,
        coin = Coin,
        gold = Gold,
        gold_bind = GoldBind,
        items = Items
        }|_] = Conds,
    CondTarget = case CondRule of
        [{pay_acc_each, CondVal}|_] -> CondVal;
        _ -> 0
    end,
    Reward = campaign_adm_reward:get_reward(RoleId, SrvId, CampId, CondId),
    {Available, Num, CurrVal} = case Reward of
        #campaign_role_reward{num = _Num} when _Num > 0 ->
            {1, _Num, PayAcc rem CondTarget};
        _ ->
            {0, 1, PayAcc rem CondTarget}
    end,
    sys_conn:pack(15833, {
        Camp#campaign_adm.id        
        ,Camp#campaign_adm.title
        ,Camp#campaign_adm.publicity
        ,Camp#campaign_adm.content
        ,Camp#campaign_adm.start_time
        ,Camp#campaign_adm.end_time
        ,Camp#campaign_adm.msg
        ,CurrVal
        ,CondTarget   
        ,Available
        ,0   % CondId = 0 领取所有奖励
        ,Coin * Num
        ,Gold * Num
        ,GoldBind * Num
        ,[ {ItemId, ItemBind, ItemNum * Num} || {ItemId, ItemBind, ItemNum} <- Items]
        ,<<>>
        ,<<>>
    });
%% 累计充值
pack_camp_info({?camp_type_pay, ?camp_type_pay_acc}, 
        _Role = #role{id = {RoleId, SrvId}}, 
        Camp = #campaign_adm{id = CampId, start_time = StartTime, conds = Conds0}) ->
    %
    ?DEBUG("累计充值类活动"),
    PayAcc = campaign_dao:calc_charge(RoleId, SrvId, begin_time, StartTime),
    Conds = [ C || C = #campaign_cond{conds = [{pay_acc, _, _}|_]} <- Conds0 ],
    % CondData0 = lists:usort([ Min || #campaign_cond{conds = [{pay_acc, Min, _}|_]} <- Conds ]),
    SortedConds = lists:usort(fun(#campaign_cond{conds = [{pay_acc, Aacc, _}]}, 
                #campaign_cond{conds = [{pay_acc, Bacc, _}]}) ->
        Aacc < Bacc 
    end, Conds),
    SubConds = (catch lists:foldl(fun(#campaign_cond{conds = [{pay_acc, Acc, _}]}, Index) ->
        case PayAcc < Acc of 
            true -> throw(lists:sublist(SortedConds, (Index - 1) div 3 * 3 + 1, 3));  %% 只取3个
            _ -> Index + 1
        end
    end, 1, SortedConds)),
    CondData0 = case SubConds of
        [_|_] -> SubConds;
        _ -> []
    end,
    CondData = lists:map(fun(#campaign_cond{id = CondId, conds = [{pay_acc, Acc0, _}]})->
            case campaign_adm_reward:has_reward(RoleId, SrvId, CampId, CondId) of
                true -> {Acc0, 1};
                _ -> {Acc0, 0}
            end
    end, CondData0),
    %
    Rewards = campaign_adm_reward:get_rewards(RoleId, SrvId, Camp),
    {Available, {Coin, Gold, GoldBind, Items}} = case Rewards of
        [_|_] -> %% 已发送但未领取的奖励
            Gains = campaign_adm_reward:rewards_to_gains(Rewards),
            Ret = lists:foldl(fun(#gain{label = Label, val = Val}, {Coin0, Gold0, GoldBind0, Items0})->
                case Label of 
                    coin -> {Val, Gold0, GoldBind0, Items0};
                    gold -> {Coin0, Val, GoldBind0, Items0};
                    gold_bind -> {Coin0, Gold0, Val, Items0};
                    item -> {Coin0, Gold0, GoldBind0, [list_to_tuple(Val)]}
                end
            end, {0, 0, 0, []}, Gains),
            {1, Ret};
        _ -> %% 下一个可以领取的奖励
            CL = lists:sort(fun(#campaign_cond{conds = A}, #campaign_cond{conds = B})-> 
                 [{pay_acc, AccA, _}|_] = A,
                 [{pay_acc, AccB, _}|_] = B,
                 AccA < AccB
            end, Conds),
            Cond0 = case lists:filter(fun(#campaign_cond{conds = [{pay_acc, C, _}|_]})-> C > PayAcc end, CL) of
                [C_|_] -> C_;
                _ -> #campaign_cond{}
            end,
            #campaign_cond{
                coin = Coin0,
                gold = Gold0,
                gold_bind = GoldBind0,
                items = Items0
                } = Cond0,
            {0, {Coin0, Gold0, GoldBind0, Items0}}
    end,
    sys_conn:pack(15834, {
        Camp#campaign_adm.id        
        ,Camp#campaign_adm.title
        ,Camp#campaign_adm.publicity
        ,Camp#campaign_adm.content
        ,Camp#campaign_adm.start_time
        ,Camp#campaign_adm.end_time
        ,Camp#campaign_adm.msg
        ,PayAcc
        ,CondData
        ,0   % CondId = 0 领取所有奖励 
        ,Available
        ,Coin
        ,Gold
        ,GoldBind
        ,Items
        ,<<>>
        ,<<>>
    });
%% 兑换
pack_camp_info({?camp_type_play, ?camp_type_play_exchange}, Role, Camp = #campaign_adm{conds = Conds0}) ->
    ?DEBUG("兑换类活动"),
    %CampTotal = get_main_camp_total(Role),
    Conds = lists:concat([ C || #campaign_cond{conds = C} <- Conds0 ]),
    NeedItemIds = lists:usort([ ItemId || {loss, item, ItemId, _} <- Conds]),
    {StrList, CurrItems} = lists:foldr(fun(ItemId, {A,B})->
        Cnt = storage:count(Role#role.bag, ItemId),
        {ok, Item} = item_data:get(ItemId),
        {
            [lists:concat([binary_to_list(Item#item_base.name), "*", integer_to_list(Cnt)])|A]
            ,[{ItemId, Cnt}|B]
        }
    end, {[], []}, NeedItemIds),
    CurrItemsStr = list_to_binary(string:join(StrList, ", ")),
    %%
    CondL = lists:map(fun(C=#campaign_cond{conds = Cs})->
        NotEnough = lists:any(fun({loss, item, ItemId, NeedNum})->
            case lists:keyfind(ItemId, 1, CurrItems) of
                false -> true;
                Num -> Num < NeedNum
            end
        end, Cs),
        CanExchange = case NotEnough of
            true -> 0;
            _ -> 1
        end,
        {C, CanExchange}
    end, Conds0),
    sys_conn:pack(15835, {
        Camp#campaign_adm.id        
        ,Camp#campaign_adm.title
        ,Camp#campaign_adm.publicity
        ,Camp#campaign_adm.content
        ,Camp#campaign_adm.start_time
        ,Camp#campaign_adm.end_time
        ,Camp#campaign_adm.msg
        ,CurrItemsStr 
        ,[[
            Cond#campaign_cond.id
            ,CanExchange
            ,Cond#campaign_cond.reward_num
            ,Cond#campaign_cond.coin
            ,Cond#campaign_cond.gold
            ,Cond#campaign_cond.gold_bind
            ,Cond#campaign_cond.items
            ,Cond#campaign_cond.msg
            ,Cond#campaign_cond.reward_msg
            ]|| {Cond, CanExchange} <- CondL ]
    });
%% 激活码
pack_camp_info({?camp_type_play, ?camp_type_play_card}, _Role, Camp = #campaign_adm{conds = Conds}) ->
    [#campaign_cond{
        id = CondId
        }|_] = Conds,
    case Conds of
        [#campaign_cond{id = CondId}|_] ->
            sys_conn:pack(15837, {
                Camp#campaign_adm.id        
                ,Camp#campaign_adm.title
                ,Camp#campaign_adm.publicity
                ,Camp#campaign_adm.content
                ,Camp#campaign_adm.start_time
                ,Camp#campaign_adm.end_time
                ,Camp#campaign_adm.msg
                ,CondId
            });
        _ ->
            ok
    end;
%% 公告
pack_camp_info({?camp_type_play, ?camp_type_play_nothing}, Role, Camp) ->
    pack_camp_info(notice, Role, Camp);    
pack_camp_info(_Type, _Role, Camp = #campaign_adm{conds = Conds0}) ->
    ?DEBUG("公告类活动"),
    Conds = [ Cond || Cond <- Conds0, is_record(Cond, campaign_cond), 
                Cond#campaign_cond.button =:= ?camp_button_type_jump ],
    {ButtonContent, ButtonBind} = case Conds of
        [] -> {<<>>, <<>>};
        [Cond|_] -> {Cond#campaign_cond.button_content, Cond#campaign_cond.button_bind} 
    end,
    sys_conn:pack(15836, {
        Camp#campaign_adm.id        
        ,Camp#campaign_adm.title
        ,Camp#campaign_adm.publicity
        ,Camp#campaign_adm.content
        ,Camp#campaign_adm.start_time
        ,Camp#campaign_adm.end_time
        ,Camp#campaign_adm.msg
        ,ButtonContent
        ,ButtonBind
    }).
%pack_camp_info(_Type, _Role, _Camp) ->
%    ?ERR("暂不可用的活动类型~p : ~p", [_Type, _Camp]),
%    undefined.

%% 重载数据
reload() ->
    gen_server:cast(?MODULE, reload).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(campaign_adm_data_list, [set, named_table, protected, {keypos, #campaign_total.id}]),
    ets:new(campaign_rewarded_list, [set, named_table, protected, {keypos, #campaign_rewarded.key}]),
    ets:new(campaign_role_reward, [set, named_table, protected, {keypos, #campaign_role_reward.key}]),
    do_reload(),
    State = #state{},
    erlang:send_after(2000, self(), update_escort_child),
    erlang:send_after(util:unixtime({nexttime, 2}) * 1000, self(), update_hour_24), %% 每天0时过2秒执行
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

%% 激活卡兑换，确保同时只能有一个人兑换
handle_call({exchange, Role, TotalCamp, Camp, Cond, Card}, _From, State) ->
    Reply = campaign_adm_reward:do_exchange_card(Role, TotalCamp, Camp, Cond, Card),
    {reply, Reply, State};

%% 获取奖励信息
handle_call({get_reward, RoleId, SrvId, CampId, CondId}, _From, State) ->
    Ret = do_get_reward(RoleId, SrvId, CampId, CondId),
    {reply, Ret, State};

%% 设置奖励领取状态
handle_call({fetch_reward, RoleId, SrvId, Rewards}, _From, State) ->
    lists:foreach(fun(#campaign_role_reward{cond_id = CondId, camp_id = CampId, num = Num}) ->
        ets:update_element(campaign_role_reward, {{RoleId, SrvId}, CondId}, {#campaign_role_reward.num, 0}),
        campaign_dao:mark_reward_fetched(RoleId, SrvId, CampId, CondId),
        campaign_dao:log_campaign_reward(RoleId, SrvId, CampId, CondId, Num, 1)
    end, Rewards),
    {reply, ok, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(reload, State) ->
    ?INFO("开始重载活动数据"),
    OldL = list_all_not_finish(),
    NewL = do_reload(),
    refresh_client_camp_list(NewL),
    update_camp(?camp_type_play_escort_child, OldL, NewL),
    update_camp(?camp_type_play_luck, OldL, NewL),
    update_camp([?camp_type_play_charge_card, ?camp_type_play_charge_card_reward], OldL, NewL),
    ?INFO("重载活动数据成功...[原:~p,新:~p]", [length(OldL), length(NewL)]),
    {noreply, State};

%% 清除所有总活动
handle_cast(clear, State) ->
    ets:delete_all_objects(campaign_adm_data_list),
    refresh_client_camp_list([]),
    {noreply, State};

%% 删除指定总活动
handle_cast({delete, TotalID}, State) ->
    ets:delete(campaign_adm_data_list, TotalID),
    refresh_client_camp_list(),
    {noreply, State};

%% 删除指定总活动下的某个子活动
handle_cast({delete, TotalID, CampId}, State) ->
    case lookup(TotalID) of
        false -> ok;
        TotalCamp = #campaign_total{camp_list = CampList} ->
            NewCampList = lists:keydelete(CampId, #campaign_adm.id, CampList),
            NewTotalCamp = TotalCamp#campaign_total{camp_list = NewCampList},
            ets:insert(campaign_adm_data_list, NewTotalCamp)
    end,
    {noreply, State};

%% 为了减轻其它系统的压力 部分接口可异步到活动线程上执行
%% campaign_adm:apply(async, {handle, Label, Role, Args}),
%% Label Role, Args 参数参考 campaign_listener:handle(Label, Role, Args).
handle_cast({handle, Label, Role, Args}, State) when is_record(Role, role) ->
    campaign_listener:handle(Label, Role, Args),
    {noreply, State};
handle_cast({handle, Label, RInfo, Args}, State) ->
    campaign_listener:handle_async(1, Label, RInfo, Args),
    {noreply, State};

%% 领取奖励成功 更新缓存ETS奖励发放列表
handle_cast({rewarded, Rid, #campaign_cond{id = CondId, settlement_type = SettlementType}}, State) ->
    L = ets:tab2list(campaign_rewarded_list),
    Now = util:unixtime(),
    NewRe = case lists:keyfind({Rid, CondId}, #campaign_rewarded.key, L) of
        Re = #campaign_rewarded{num = Num, last_time = LastTime} when SettlementType =:= ?camp_settlement_type_everyday -> %% 每天重新结算
            case util:is_same_day2(LastTime, Now) of
                true -> %% 同一天 累计
                    Re#campaign_rewarded{num = Num + 1, last_time = Now};
                false -> %% 不是同一天 重新计算
                    #campaign_rewarded{key = {Rid, CondId}, last_time = Now}
            end;
        Re = #campaign_rewarded{num = Num} -> %% 之前领取过 次数+1
            Re#campaign_rewarded{num = Num + 1, last_time = Now};
        _ ->
            #campaign_rewarded{key = {Rid, CondId}, last_time = Now}
    end,
    ets:insert(campaign_rewarded_list, NewRe),
    {noreply, State};

%% 重置奖励领取次数
handle_cast({rewarded, Rid, #campaign_cond{id = CondId}, Num, Time}, State) ->
    L = ets:tab2list(campaign_rewarded_list),
    case lists:keyfind({Rid, CondId}, #campaign_rewarded.key, L) of
        #campaign_rewarded{num = OldNum} when OldNum >= Num -> ok;
        _ ->
            Re = #campaign_rewarded{key = {Rid, CondId}, last_time = Time, num = Num},
            ets:insert(campaign_rewarded_list, Re)
    end,
    {noreply, State};

%% 发奖励（非邮件方式）
handle_cast({send_reward, RoleId, SrvId, CampId, CondId, Gains, AddNum}, State) ->
    Time = util:unixtime(),
    Reward = case do_get_reward(RoleId, SrvId, CampId, CondId) of
        Reward0 = #campaign_role_reward{num = OldNum} ->
            Reward0#campaign_role_reward{
                last_time = Time, 
                num = OldNum + AddNum, 
                gains = Gains
            };
        undefined ->
            #campaign_role_reward{
                key = {{RoleId, SrvId}, CondId},
                last_time = Time, 
                camp_id = CampId,
                cond_id = CondId,
                num = AddNum, 
                gains = Gains
            };
        _ ->
            error
    end,
    case Reward of
        #campaign_role_reward{} ->
            ets:insert(campaign_role_reward, Reward),
            campaign_dao:insert_role_reward(RoleId, SrvId, CampId, CondId, Gains, AddNum, Time);
        _ ->
            ignore
    end,
    {noreply, State};


handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(reg_rank_reward, State) ->
    L = list_all(),
    reg_time_to_reward(rank, L),
    {noreply, State};

%% 定时奖励活动发放
handle_info({reward, Mod, TotalID, CampId, CondId}, State) -> 
    ?DEBUG("开始发放奖励[mod:~w total_id:~p, camp_id:~p, cond_id:~p]", [Mod, TotalID, CampId, CondId]),
    reward(Mod, TotalID, CampId, CondId),
    {noreply, State};

%% 活动开启/关闭刷新窗户端活动列表
handle_info(refresh_client_camp_list, State) ->
    ?DEBUG("开始更新客户端总活动信息"),
    L = list_all(),
    refresh_client_camp_list(L),
    reg_time_refresh_camp_list(L),
    {noreply, State};

%% 更新通知护送小屁孩活动开启
handle_info(update_escort_child, State) ->
    L = list_all_not_finish(),
    update_camp(?camp_type_play_escort_child, [], L),
    {noreply, State};

%% 0点更新通知
handle_info(update_hour_24, State) ->
    refresh_client_camp_list(),
    % role_group:pack_cast(world, 15853, {1}),
    erlang:send_after(util:unixtime({nexttime, 2}) * 1000, self(), update_hour_24),
    %% 一些特殊结算
    ?CATCH( daily_check_calc() ),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 活动变化
update_camp(TypeList, OldL, NewL) ->
    L1 = list_type(TypeList, OldL),
    L2 = list_type(TypeList, NewL),
    do_update_camp(TypeList, L1, L2).
do_update_camp(_TypeList, L, L) -> %% 活动没有变化 不处理
    ok;
do_update_camp([?camp_type_play_charge_card | _], _L1, _L2) ->
    campaign_card:reload();
do_update_camp(_TypeList, _L1, _L2) ->
    ok.

%%------------------------------
%% 内部方法
%%------------------------------

%% 重载后台活动配置数据
do_reload() ->
    L = campaign_dao:load_all() ++ campaign_adm_data:list(),
    ets:delete_all_objects(campaign_adm_data_list),
    ets:insert(campaign_adm_data_list, L),
    reg_time_to_reward(rank, L),
    reg_time_refresh_camp_list(L),
    L.

%% 重新广播活动列表
refresh_client_camp_list() ->
    L = list_all(),
    refresh_client_camp_list(L).
refresh_client_camp_list(L) ->
    Now = util:unixtime(),
    OpenL = list_all(Now, L), %% 获取正在进行的活动
    NeedShowL = [CampTotal || CampTotal <- OpenL, CampTotal#campaign_total.ico =/= <<"hide">>],
    ?DEBUG("重新广播总活动数据列表给客户端...[~p/~p]", [length(NeedShowL), length(OpenL)]),
    %role_group:pack_cast(world, 15850, {NeedShowL}),
    %role_group:pack_cast(world, 15853, {1}).
    case NeedShowL of
        [#campaign_total{name = CampName, title = CampTitle, camp_list = CampList}|_] ->
            ?CATCH( role_group:pack_cast(world, 15830, {CampName, CampTitle, CampList}) );
        _ ->
            ok
    end.

%% 注册下一次活动列表发生变化时间
reg_time_refresh_camp_list(L) ->
    Now = util:unixtime(),
    case get_next_refresh_time(L, Now, 0) of
        NextTime when NextTime > Now ->
            T = lists:min([NextTime - Now, ?max_nexttime]),
            ?DEBUG("活动开启/关闭时间注册，定时更新客户端活动状态[~p]", [T]),
            NewRef = erlang:send_after(T * 1000, self(), refresh_client_camp_list),
            reset_send_after(refresh_client_camp_list, NewRef);
        _ ->
            ok
    end.

%% 获取下一次有活动列表更新的最近时间(活动失效、活动开启)
get_next_refresh_time([], _Now, Time) -> Time;
get_next_refresh_time([#campaign_total{start_time = StartTime} | T], Now, Time) when StartTime > Now -> %% 当前总活动未开始
    case StartTime < Time orelse Time < Now of
        true -> get_next_refresh_time(T, Now, StartTime); %% 当前活动开始时间最接近当前时间
        _ -> get_next_refresh_time(T, Now, Time)
    end;
get_next_refresh_time([#campaign_total{end_time = EndTime, camp_list = CampList} | T], Now, Time) when EndTime > Now -> %% 当前总活动未结束
    NewTime = get_next_refresh_time(CampList, Now, Time),
    case EndTime < NewTime orelse NewTime < Now of
        true -> get_next_refresh_time(T, Now, EndTime); %% 当前活动结束时间最接近当前时间
        _ -> get_next_refresh_time(T, Now, NewTime)
    end;
get_next_refresh_time([#campaign_adm{start_time = StartTime} | T], Now, Time) when StartTime > Now -> %% 当前子活动未开始
    case StartTime < Time orelse Time < Now of
        true -> get_next_refresh_time(T, Now, StartTime); %% 当前活动开始时间最接近当前时间
        _ -> get_next_refresh_time(T, Now, Time)
    end;
get_next_refresh_time([#campaign_adm{end_time = EndTime} | T], Now, Time) when EndTime > Now -> %% 当前子活动未结束
    case EndTime < Time orelse Time < Now of
        true -> get_next_refresh_time(T, Now, EndTime); %% 当前活动结束时间最接近当前时间
        _ -> get_next_refresh_time(T, Now, Time)
    end;
get_next_refresh_time([_ | T], Now, Time) ->
    get_next_refresh_time(T, Now, Time).

%%--------------------------------
%% 对排行榜类注册定时发放奖励
%%--------------------------------
reg_time_to_reward(_Mod, []) -> ok;
reg_time_to_reward(Mod, [TotalCamp = #campaign_total{camp_list = CampList} | T]) ->
    reg_time_to_reward(Mod, TotalCamp, CampList),
    reg_time_to_reward(Mod, T).

reg_time_to_reward(_Mod, _TotalCamp, []) -> ok;
reg_time_to_reward(Mod, TotalCamp, [Camp = #campaign_adm{conds = Conds} | T]) ->
    reg_time_to_reward(Mod, TotalCamp, Camp, Conds),
    reg_time_to_reward(Mod, TotalCamp, T).

reg_time_to_reward(Mod, TotalCamp, Camp, [I | T]) ->
    reg_time_to_reward(Mod, TotalCamp, Camp, I),
    reg_time_to_reward(Mod, TotalCamp, Camp, T);
reg_time_to_reward(Mod, #campaign_total{id = TotalID}, #campaign_adm{id = CampId, start_time = StartTime, end_time = EndTime}, #campaign_cond{id = CondId, settlement_type = SettlementType, button = ?camp_button_type_mail, conds = [{rank, RTime, _StartIndex, _EndIndex}]}) ->
    Now = util:unixtime(),
    RewardTime = case SettlementType of
        ?camp_settlement_type_everyday -> %% 活动期间每天
            Time = RTime - util:unixtime({today, RTime}),
            Now + util:unixtime({nexttime, Time});
        ?camp_settlement_type_end ->
            EndTime;
        _ -> 
            RTime
    end, 
    ?DEBUG("排行榜奖励时间:~p, ~p", [RewardTime, Now]),
    case RewardTime > Now andalso (RewardTime =< EndTime orelse EndTime =:= 0) of
        true when RewardTime < StartTime -> %% 活动未开始 等活动开始再注册时间
            T = StartTime - Now,
            ?DEBUG("排行榜奖励活动未开始，将在~p秒活动开启后开始注册奖励发放时间", [T]),
            erlang:send_after(T * 1000, self(), reg_rank_reward);
        true ->
            T = lists:min([RewardTime - Now, ?max_nexttime]),
            ?DEBUG("排行榜奖励注册发放时间[~p]", [T]),
            NewRef = erlang:send_after(T * 1000, self(), {reward, Mod, TotalID, CampId, CondId}),
            reset_send_after({reg_time_to_reward_rank, CondId}, NewRef);
        _ -> %% 活动已过期 或时间配置非法
            ok
    end;
reg_time_to_reward(_Mod, _TotalCamp, _Camp, _) -> ok.

%% 重置定时器
reset_send_after(Key, NewRef) ->
    case get(Key) of
        undefined -> ok;
        Ref -> catch erlang:cancel_timer(Ref)
    end,
    put(Key, NewRef).

%% 查找指定类型规则列表
do_list_type(_TypeList, [], L) -> 
    camp_qsort(L);
do_list_type(Type, TotalCampL, L) when is_integer(Type) ->
    do_list_type([Type], TotalCampL, L);
do_list_type(TypeList, [TotalCamp = #campaign_total{camp_list = CampList} | T], L) ->
    NewL = do_list_type(TypeList, TotalCamp, CampList, L),
    do_list_type(TypeList, T, NewL).
do_list_type(_TypeList, _TotalCamp, [], L) -> 
    L;
do_list_type(TypeList, TotalCamp, [Camp = #campaign_adm{conds = Conds} | T], L) ->
    NewL = do_list_type(TypeList, TotalCamp, Camp, Conds, L),
    do_list_type(TypeList, TotalCamp, T, NewL).
do_list_type(_TypeList, _TotalCamp, _Camp, [], L) -> L;
do_list_type(TypeList, TotalCamp, Camp, [Cond = #campaign_cond{sec_type = Type} | T], L) ->
    case lists:member(Type, TypeList) of
        true ->
            do_list_type(TypeList, TotalCamp, Camp, T, [{TotalCamp, Camp, Cond} | L]);
        false ->
            do_list_type(TypeList, TotalCamp, Camp, T, L)
    end.

%% 按子活动时间快速排序
camp_qsort([]) ->
    [];
camp_qsort([I]) ->
    [I];
camp_qsort([I = {_, #campaign_adm{start_time = StartT}, _} | T]) ->
    camp_qsort([I1 || I1 = {_, #campaign_adm{start_time = StartT1}, _} <- T, StartT1 =< StartT])
    ++ [I] ++
    camp_qsort([I2 || I2 = {_, #campaign_adm{start_time = StartT2}, _} <- T, StartT2 > StartT]).


%%----------------------------------------
%% 奖励发放实现
%%----------------------------------------
reward(Mod, TotalID, CampId, CondId) ->
    case lookup(TotalID) of
        false -> ok;
        TotalCamp = #campaign_total{camp_list = CampList} ->
            case lists:keyfind(CampId, #campaign_adm.id, CampList) of
                false -> ok;
                Camp = #campaign_adm{conds = Conds} ->
                    case lists:keyfind(CondId, #campaign_cond.id, Conds) of
                        false -> ok;
                        Cond = #campaign_cond{settlement_type = ?camp_settlement_type_everyday} -> %% 注册下一天发放时间
                            do_reward(Mod, TotalCamp, Camp, Cond),
                            reg_time_to_reward(Mod, TotalCamp, Camp, Cond);
                        Cond ->
                            do_reward(Mod, TotalCamp, Camp, Cond)
                    end 
            end 
    end.
do_reward(rank, TotalCamp, Camp, Cond = #campaign_cond{button = ?camp_button_type_mail, sec_type = Type, conds = [{rank, _Time, StartIndex, EndIndex}]}) ->
    RankL = rank:list(Type),
    rank_reward(TotalCamp, Camp, Cond, RankL, 1, StartIndex, EndIndex);
do_reward(_Mod, _TotalCamp, _Camp, _Cond) -> ok.

rank_reward(TotalCamp, Camp, Cond, [I | T], Index, StartIndex, EndIndex) when Index >= StartIndex andalso Index =< EndIndex ->
    case get_rank_role_info(I) of
        false -> ok;
        {two, RoleInfo1, RoleInfo2} ->
            campaign_adm_reward:send_reward(Cond, Camp, TotalCamp, RoleInfo1, Index),
            campaign_adm_reward:send_reward(Cond, Camp, TotalCamp, RoleInfo2, Index);
        RoleInfo ->
            campaign_adm_reward:send_reward(Cond, Camp, TotalCamp, RoleInfo, Index)
    end,
    rank_reward(TotalCamp, Camp, Cond, T, Index + 1, StartIndex, EndIndex);
rank_reward(TotalCamp, Camp, Cond, [_I | T], Index, StartIndex, EndIndex) when Index < StartIndex ->
    rank_reward(TotalCamp, Camp, Cond, T, Index + 1, StartIndex, EndIndex);
rank_reward(_TotalCamp, _Camp, _Cond, _, _Index, _StartIndex, _EndIndex) ->
    ok.

get_rank_role_info(#rank_role_lev{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_role_coin{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_role_pet{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_role_pet_power{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_role_achieve{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_role_power{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_role_soul{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_role_skill{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_pet_grow{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_pet_potential{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_equip_arms{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_equip_armor{id = {Rid, Srvid, _}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_guild_lev{chief_rid = Rid, chief_srv_id = Srvid, cName = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_vie_acc{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_vie_kill{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_wit_acc{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_flower_acc{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_flower_day{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_flower{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_glamor_acc{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_glamor_day{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_glamor{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_dungeon{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_mount_power{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_mount_lev{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_total_power{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_practice{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_total_power{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_darren_coin{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_darren_casino{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_darren_exp{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_darren_attainment{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};

get_rank_role_info(#rank_cross_pet_lev{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_role_pet_power{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_pet_grow{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_pet_potential{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_role_lev{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_role_power{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_role_coin{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_role_skill{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_role_achieve{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_role_soul{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_mount_lev{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_mount_power{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_equip_arms{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_equip_armor{id = {Rid, Srvid, _}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_guild_lev{chief_rid = Rid, chief_srv_id = Srvid, cName = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_vie_kill{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_world_compete_win{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_soul_world{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_soul_world_array{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_soul_world_spirit{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_soul_world{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_soul_world_array{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};
get_rank_role_info(#rank_cross_soul_world_spirit{id = {Rid, Srvid}, name = Name}) -> {Rid, Srvid, Name};

get_rank_role_info(_) -> false.


do_get_reward(RoleId, SrvId, CampId, CondId) ->
    case ets:lookup(campaign_role_reward, {{RoleId, SrvId}, CondId}) of
        [Reward|_] ->
            Reward;
        _ ->
            case campaign_dao:get_role_reward(RoleId, SrvId, CampId, CondId) of
                undefined -> undefined;
                Reward = #campaign_role_reward{} -> 
                    ets:insert(campaign_role_reward, Reward),
                    Reward;
                _ -> error
            end
    end.

daily_check_calc() ->
    daily_check_calc(list_all()).

daily_check_calc([]) ->
    ok;
daily_check_calc([#campaign_total{start_time = StartTime, end_time = EndTime, camp_list = CampList}|T]) ->
    Now = util:unixtime(),
    case StartTime =< Now andalso (Now - EndTime) < 3600 * 24 of %% 结束时间为当天，允许误差时间为1天
        true ->
            daily_check_calc(CampList);
        _ ->
            ignore
    end,
    daily_check_calc(T);
daily_check_calc([Camp = #campaign_adm{start_time = StartTime, end_time = EndTime}|T]) ->
    Now = util:unixtime(),
    case StartTime =< Now andalso (Now - EndTime) < 3600 * 24 of %% 结束时间为当天，允许误差时间为1天
        true ->
            daily_check_calc(Camp);
        _ ->
            ignore
    end,
    daily_check_calc(T);
%% 领取类奖励（如：充值奖励）
daily_check_calc(_Camp = #campaign_adm{id = CampId, end_time = EndTime, conds = _Conds}) -> %% 活动结束当天
    Now = util:unixtime(),
    case Now >= EndTime andalso (Now - EndTime) < 3600 * 24 of %% 结束时间为当天，允许误差时间为1天
        true ->
            campaign_adm_reward:return_reward(CampId),
            ok;
        _ ->
            ignore
    end.


