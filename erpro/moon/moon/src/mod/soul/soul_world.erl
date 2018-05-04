%%----------------------------------------------------
%% @doc 灵戒洞天模块
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(soul_world).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
        login/1
        ,call_out/3
        ,wake_up/2
        ,feed/3
        ,seal/3
        ,unseal/2
        ,upgrade_array/2
        ,fast_upgrade_array/3
        ,speed_up/3
        ,finish_upgrade_array/2
        ,upgrade_magic/3
        ,calc/1
        ,calc_fight_capacity/1
        ,calc_pet/1
        ,calc_pet_fc/1
        ,get_shop/0
        ,exchange/3
        ,merge_spirits/3
        ,view_merge_spirits/3
        ,unlock_workshop/2
        ,start_produce/3
        ,get_product/2
        ,fast_get_product/2
        ,cancel_producing/2
        ,add_product_line/1
        ,get_rank/0
        ,get_friends/0
        ,lookup/1
        ,listener/1
        ,adm_upgrade_array/2
        ,adm_upgrade_array_pet/2
        ,adm_upgrade_magic/3
        ,adm_make/1
        ,ver_parse/1
    ]).


-record(state, {
        rank = []   %% 排行榜
        ,ref = 0    %% 倒计时引用
        ,synced = 1 %% 排行榜同步次数
    }).


-include("common.hrl").
-include("role.hrl").
-include("sns.hrl").
-include("vip.hrl").
-include("gain.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("soul_world.hrl").
%%

-define(soul_world_max_spirits_num, 28).    %% 最多可以拥有精灵数量
-define(soul_world_gold_call, 1).   %% 晶钻召唤
-define(soul_world_coin_call, 0).   %% 金币召唤
-define(soul_world_coin_call_cost, 100000). %% 金币召唤花费
-define(soul_world_spirit_max_lev, 20). %% 妖灵最高等级
-define(soul_world_feed_item_type, 61). %% 可以用来喂养妖灵的物品类型
-define(soul_world_open_lev, 62). %% 开放等级
-define(soul_world_rank_timeout, 600000). %% 排行榜更新时间(10分钟一次)
-define(soul_world_magic_max_lev, 20). %% 妖灵法宝最高等级
-define(soul_world_array_max_lev, 80). %% 神魔阵最高等级
-define(soul_world_array_base_attr, {720, 7000, 210, 2268, 1008, 2205, 2205, 2205, 2205, 2205}). %% 阵法基础属性
-define(soul_world_call_start_luck1, 50).
-define(soul_world_call_start_luck2, 100).
-define(soul_world_call_start_luck3, 150).
-define(soul_world_call_start_luck4, 200).
-define(soul_world_call_start_luck5, 250).
-define(soul_world_call_start_luck6, 280).
-define(soul_world_shop_items, [{1, 33128, 1}, {1, 33127, 1}]). %% 兑换商城里的物品
-define(soul_world_exchange_orange_price, 30). %% 兑换橙妖灵所需的物品数
-define(soul_world_exchange_purple_price, 10). %% 兑换紫妖灵所需的物品数
-define(soul_world_pet_array_start_id, 11). %% 宠物阵开始id
-define(soul_world_max_produce_line, 5).    %% 生产线最大数
-define(soul_world_array_workshop, 18).     %% 生产坊封印id

%% ---------------------------- 外部方法 ---------------------------------

%% 登录处理
login(Role = #role{soul_world = Soul = #soul_world{spirits = Spirits, calleds = Calleds, arrays = Arrays, last_called = LastCalled, today_called = TodayCalled, pet_arrays = PetArrays}}) ->
    %% 先简单验证下数据
    NewCalleds = case [One || One = #soul_world_spirit{} <- Calleds] of
        [H | T] when length(T) =/= 8 andalso length(T) =/= 7 -> [H];
        L -> L
    end,
    NewSpirits = update_ver(Spirits, []),

    F = fun(A = #soul_world_array{spirit_id = 0}) ->
            A;
        %% 修正一下已封印妖灵部分
        (A = #soul_world_array{spirit_id = ASpId}) ->
            case lists:keyfind(ASpId, #soul_world_spirit.id, NewSpirits) of
                #soul_world_spirit{fc = AFc} ->
                    A#soul_world_array{fc = AFc};
                _ ->
                    A
            end;
        ({soul_world_array, Aid, ALev, ASpId, AFc, ATimeout}) ->
            NewAttr = get_add_attr(Aid, ALev, AFc),
            #soul_world_array{id = Aid, lev = ALev, spirit_id = ASpId, fc = AFc, upgrade_finish = ATimeout, attr = NewAttr}
    end,
    NewArrays = case [F(A) || A <- Arrays] of
        [] -> [#soul_world_array{id = I, lev = 1 div I} || I <- lists:seq(1, 10)];
        As -> As
    end,
    {NewArrays1, NewRole} = check_upgrade_array(NewArrays, [], Role),
    NewAllLev = lists:sum([OneLv || #soul_world_array{lev = OneLv} <- NewArrays1]),
    %% 免费次数隔天清理
    NewTodayCalled = case util:is_same_day2(util:unixtime(), LastCalled) of
        true -> TodayCalled;
        _ -> 0
    end,
    %% 仙宠阵
    NewPetArrays = case PetArrays of
        [] -> [#soul_world_array{id = I2, lev = ?soul_world_pet_array_start_id div I2} || I2 <- lists:seq(?soul_world_pet_array_start_id, 17)];
        _ -> PetArrays
    end,
    {NewPetArrays1, NewRole1} = check_upgrade_array(NewPetArrays, [], NewRole),
    NewPetAllLev = lists:sum([PetOneLv || #soul_world_array{lev = PetOneLv} <- NewPetArrays1]),
    QNums = get_quality_nums(NewSpirits, []),
    NewSoul = Soul#soul_world{calleds = NewCalleds, 
        spirits = NewSpirits, 
        spirit_num = length(NewSpirits), 
        arrays = NewArrays1, 
        array_lev = NewAllLev, 
        today_called = NewTodayCalled,
        quality_nums = QNums,
        pet_arrays = NewPetArrays1,
        pet_array_lev = NewPetAllLev
    },
    NewRole2 = NewRole1#role{soul_world = NewSoul},
    update_ets(NewRole2),
    NewRole2;
login(Role) ->
    As = [#soul_world_array{id = I, lev = 1 div I} || I <- lists:seq(1, 10)],
    NewRole = Role#role{soul_world = #soul_world{arrays = As}},
    update_ets(NewRole),
    NewRole.

%% @spec call_one(Role, Type) -> {ok, NewRole} | Why
%% Role = #role{}
%% Type = integer() 0 金币召唤，1晶钻召唤
%% Why = atom()
%% @doc 召唤一个妖灵
call_out(#role{lev = Lev}, _Type, _IsBatch) when Lev < ?soul_world_open_lev  ->
    role_lev_lower;
call_out(#role{event = Event}, _Type, _IsBatch) when Event =/= ?event_no andalso Event =/= ?event_guild andalso Event =/= ?event_dungeon ->
    wrong_event;
call_out(Role = #role{soul_world = Soul = #soul_world{orange_luck = OrangeLuck, calleds = Calleds}}, ?soul_world_gold_call, IsBatch) ->
    Cost = pay:price(?MODULE, soul_world_gold_call_cost, IsBatch),
    case role_gain:do([#loss{label = gold, val = Cost}], Role) of
        {ok, NewRole} ->
            {NewCalleds, _NewColor} = case IsBatch of
                0 ->
                    case Calleds of
                        [_One | T] when length(T) =:= 8 -> 
                            {[CalledOne], IsLuck}  = make_spirits(?soul_world_gold_call, [Ex || #soul_world_spirit{id = Ex} <- T], 1, [], 1, OrangeLuck),
                            {[CalledOne | T], IsLuck};
                        _ when length(Calleds) =:= 8 -> 
                            {[CalledOne], IsLuck} = make_spirits(?soul_world_gold_call, [Ex || #soul_world_spirit{id = Ex} <- Calleds], 1, [], 1, OrangeLuck),
                            {[CalledOne | Calleds], IsLuck};
                        _ -> 
                            make_spirits(?soul_world_gold_call, [], 1, [], 1, OrangeLuck)
                    end;
                _ ->
                    case Calleds of
                        [One | T] when length(T) =:= 8 -> 
                            {NewSps, IsLuck} = make_spirits(?soul_world_gold_call, [One#soul_world_spirit.id], 8, [], 1, OrangeLuck),
                            {[One | NewSps], IsLuck};
                        [One] -> 
                            {NewSps, IsLuck} = make_spirits(?soul_world_gold_call, [One#soul_world_spirit.id], 8, [], 1, OrangeLuck),
                            {[One | NewSps], IsLuck};
                        _ -> 
                            make_spirits(?soul_world_gold_call, [], 8, [], 1, OrangeLuck)
                    end
            end,
            NewOrangeLuck = if
                IsBatch =:= 1 -> min(?soul_world_gold_call_max_luck, OrangeLuck + 8);
                true -> min(OrangeLuck + 1, ?soul_world_gold_call_max_luck)
            end,
            NewRole1 = NewRole#role{soul_world = Soul#soul_world{orange_luck = NewOrangeLuck, calleds = NewCalleds}},
            {ok, NewRole1};
        _R ->
            ?DEBUG("错误 ~w", [_R]),
            gold_less
    end;
call_out(Role = #role{soul_world = Soul = #soul_world{purple_luck = PurpleLuck, calleds = Calleds, last_called = LastCalled, today_called = TodayCalled}}, _Type, IsBatch) ->
    Now = util:unixtime(),
    case util:is_same_day2(Now, LastCalled) of
        %% 用光免费次数或者批洗都是要收费的
        true when TodayCalled >= ?soul_world_free_call_time orelse IsBatch =:= 1 ->
            Cost = case IsBatch of
                1 -> 8 * ?soul_world_coin_call_cost;
                _ -> ?soul_world_coin_call_cost
            end,
            case role_gain:do([#loss{label = coin_all, val = Cost}], Role) of
                {ok, NewRole} ->
                    {NewCalleds, _NewColor} = case IsBatch of
                        0 ->
                            case Calleds of
                                [_One | T] when length(T) =:= 8 -> 
                                    {[CalledOne], IsLuck} = make_spirits(?soul_world_coin_call, [Ex || #soul_world_spirit{id = Ex} <- T], 1, [], 1, PurpleLuck),
                                    {[CalledOne | T], IsLuck};
                                _ when length(Calleds) =:= 8 -> 
                                    {[CalledOne], IsLuck} = make_spirits(?soul_world_coin_call, [Ex || #soul_world_spirit{id = Ex} <- Calleds], 1, [], 1, PurpleLuck),
                                    {[CalledOne | Calleds], IsLuck};
                                _ -> 
                                    make_spirits(?soul_world_coin_call, [], 1, [], 1, PurpleLuck)
                            end;
                        _ ->
                            case Calleds of
                                [One | T] when length(T) =:= 8 -> 
                                    {NewSps, IsLuck} = make_spirits(?soul_world_coin_call, [One#soul_world_spirit.id], 8, [], 1, PurpleLuck),
                                    {[One | NewSps], IsLuck};
                                [One] -> 
                                    {NewSps, IsLuck} = make_spirits(?soul_world_coin_call, [One#soul_world_spirit.id], 8, [], 1, PurpleLuck),
                                    {[One | NewSps], IsLuck};
                                _ -> 
                                    make_spirits(?soul_world_coin_call, [], 8, [], 1, PurpleLuck)
                            end
                    end,
                    NewPurpleLuck = if
                        IsBatch =:= 1 -> min(PurpleLuck + 8, ?soul_world_coin_call_max_luck);
                        true -> min(PurpleLuck + 1, ?soul_world_coin_call_max_luck)
                    end,
                    NewRole1 = NewRole#role{soul_world = Soul#soul_world{purple_luck = NewPurpleLuck, calleds = NewCalleds}},
                    log:log(log_coin, {<<"召唤妖灵">>, <<"">>, Role, NewRole1}),
                    {ok, NewRole1};
                _ ->
                    coin_less
            end;
        %% 免费刷新一次
        Else ->
            {NewCalleds, _NewColor} = case Calleds of
                [_One | T] when length(T) =:= 8 -> 
                    {[CalledOne], IsLuck} = make_spirits(?soul_world_coin_call, [Ex || #soul_world_spirit{id = Ex} <- T], 1, [], 1, PurpleLuck),
                    {[CalledOne | T], IsLuck};
                _ when length(Calleds) =:= 8 -> 
                    {[CalledOne], IsLuck} = make_spirits(?soul_world_coin_call, [Ex || #soul_world_spirit{id = Ex} <- Calleds], 1, [], 1, PurpleLuck),
                    {[CalledOne | Calleds], IsLuck};
                _ -> 
                    make_spirits(?soul_world_coin_call, [], 1, [], 1, PurpleLuck)
            end,
            NewTodayCalled = case Else of
                true -> TodayCalled + 1;
                _ -> 1
            end,
            NewRole1 = Role#role{soul_world = Soul#soul_world{calleds = NewCalleds, last_called = Now, today_called = NewTodayCalled}},
            {ok, NewRole1}
    end.

%% @spec wake_up(Role) -> {ok, NewRole} | Why
%% Role = NewRole = #role{}
%% Why = atom()
%% @doc 唤醒一个妖灵
wake_up(#role{lev = Lev}, _SpId) when Lev < ?soul_world_open_lev ->
    role_lev_lower;
wake_up(#role{event = Event}, _SpId) when Event =/= ?event_no andalso Event =/= ?event_guild andalso Event =/= ?event_dungeon ->
    wrong_event;
wake_up(Role = #role{id = {Rid, RSrvId}, name = RName, soul_world = Soul = #soul_world{calleds = Calleds, spirits = Spirits, spirit_num = SpiritNum, quality_nums = QNums}}, SpId) when SpId =/= 0 andalso Calleds =/= [] ->
    case lists:keyfind(SpId, #soul_world_spirit.id, Spirits) of
        #soul_world_spirit{} -> 
            exist;
        _ ->
            case lists:keyfind(SpId, #soul_world_spirit.id, Calleds) of
                Spirit = #soul_world_spirit{quality = Q, name = SpName} ->
                    %% 要区分是选择了批量召唤还是单个召唤
                    NewCalleds = case Calleds of
                        [#soul_world_spirit{id = SpId}] -> 
                            [];
                        [#soul_world_spirit{id = SpId} | T] when length(T) =:= 8 -> 
                            T; 
                        [H | T] when length(T) =:= 8 -> 
                            [H];
                        _ ->
                            []
                    end,
                    NewQNums = case lists:keyfind(Q, 1, QNums) of
                        {4, QNum} ->
                            notice:send(52, util:fbin(?L(<<"~s在{open, 47, 灵戒洞天, ffe100}中的唤灵坛，通过仪式召唤，唤醒了【<font color='#fff9600'>~s</font>】。">>),[notice:role_to_msg({Rid, RSrvId, RName}), SpName])),
                            lists:keyreplace(Q, 1, QNums, {Q, QNum + 1});
                        {Q, QNum} ->
                            lists:keyreplace(Q, 1, QNums, {Q, QNum + 1});
                        _ when Q =:= 4 ->
                            notice:send(52, util:fbin(?L(<<"~s在{open, 47, 灵戒洞天, ffe100}中的唤灵坛，通过仪式召唤，唤醒了【<font color='#fff9600'>~s</font>】。">>),[notice:role_to_msg({Rid, RSrvId, RName}), SpName])),
                            [{Q, 1} | QNums];
                        _ ->
                            [{Q, 1} | QNums]
                    end,
                    NewRole = Role#role{soul_world = Soul#soul_world{orange_luck = 0, purple_luck = 0, calleds = NewCalleds, spirits = [Spirit | Spirits], spirit_num = SpiritNum + 1, quality_nums = NewQNums}},
                    update_ets(NewRole),
                    NewRole2 = role_listener:special_event(NewRole, {1061, 1}),
                    NewRole3 = role_listener:acc_event(NewRole2, {124, Q}),
                    {ok, NewRole3};
                _ ->
                    wrong_id
            end
    end;
wake_up(_R, _Type) ->
    no_called.

%% @spec feed(Role, FeedItems, SpId) -> {ok, NewRole, AddExp} | FailReason
%% Role = NewRole = #role{}
%% FeedItems = lists() = [{integer(), integer()},...]
%% SpId = AddExp = integer()
%% FailReason = atom()
%% @doc 喂养妖灵
feed(#role{lev = Lev}, _FeedItems, _SpId) when Lev < ?soul_world_open_lev ->
    role_lev_lower;
feed(#role{event = Event}, _FeedItems, _SpId) when Event =/= ?event_no andalso Event =/= ?event_guild andalso Event =/= ?event_dungeon ->
    wrong_event;
feed(Role = #role{pid = Pid, soul_world = Soul = #soul_world{spirits = Spirits, arrays = Arrays, pet_arrays = PetArrays}, bag = #bag{items = Items}}, FeedItems, SpId) ->
    case lists:keyfind(SpId, #soul_world_spirit.id, Spirits) of
        #soul_world_spirit{lev = ?soul_world_spirit_max_lev} ->
            max_lev;
        Sp = #soul_world_spirit{lev = OldLev, exp = Exp, array_id = ArrayId, fc = Fc, quality = Q} ->
            {BaseIdQList, IdQList} = check_items_in_bag(FeedItems, Items, [], []),
            AddExp = calc_item_exp(BaseIdQList, 0),
            case soul_world_data:get_upgrade(?soul_world_spirit_max_lev - 1, Q) of
                {TopExp, _} when TopExp + 20 < Exp + AddExp ->
                    exp_over;
                _ ->
                    case role_gain:do([#loss{label = item_id, val = IdQList}], Role) of
                        {ok, NewRole} ->
                            %% 如果一下子吃太多的经验就提示下吧
                            NewSp = #soul_world_spirit{lev = NewLev} = update_spirit(Sp#soul_world_spirit{exp = Exp + AddExp}),
                            soul_world_rpc:push(17904, Pid, NewSp),
                            campaign_listener:handle({soul_world_spirit_lev, Q}, Role, OldLev, NewLev), %% 后台活动事件
                            NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Spirits, NewSp),
                            {NewArrays, NewPetArrays} = case NewSp of
                                #soul_world_spirit{fc = NewFc} when NewFc =/= Fc andalso ArrayId >= ?soul_world_pet_array_start_id ->
                                    {Arrays, update_array(ArrayId, PetArrays, NewFc)};
                                #soul_world_spirit{fc = NewFc} when NewFc =/= Fc ->
                                    {update_array(ArrayId, Arrays, NewFc), PetArrays};
                                _ ->
                                    {Arrays, PetArrays}
                            end,
                            log:log(log_soul_world, {feed, item_to_desc(BaseIdQList, <<>>), make_desc(feed, Sp), make_desc(feed, NewSp), Role}),
                            NewRole2 = NewRole#role{soul_world = Soul#soul_world{spirits = NewSpirits, arrays = NewArrays, pet_arrays = NewPetArrays}}, 
                            NewRole3 = role_listener:special_event(NewRole2, {1060, 1}),
                            NewRole4 = case ArrayId >= ?soul_world_pet_array_start_id of
                                _ when ArrayId =:= ?soul_world_array_workshop ->
                                    NewRole3;
                                true ->
                                    soul_world_rpc:push(17917, Pid, NewRole3),
                                    pet_api:reset_all(NewRole3);
                                _ ->
                                    soul_world_rpc:push(17905, Pid, NewRole3),
                                    role_api:push_attr(NewRole3)
                            end,
                            {ok, NewRole4, AddExp, _IsDouble=false};
                        {false, L} ->
                            {false, L#loss.msg}
                    end
            end;
        _ ->
            not_found
    end.

%% @spec seal(Role, SpId, ArrayId) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% SpId = ArrayId = integer()
%% FailReason = atom()
%% @doc 封印妖灵
seal(#role{event = Event}, _SpId, _ArrayId) when Event =/= ?event_no andalso Event =/= ?event_guild andalso Event =/= ?event_dungeon ->
    wrong_event;
%% 生产坊
seal(Role = #role{pid = Pid, soul_world = Soul = #soul_world{spirits = Spirits, workshop_producing = Producing, workshop_spirit_id = WorkerId}}, SpId, ?soul_world_array_workshop) ->
    case Producing of
        [_H | _] -> 
            workshop_busy;
        _ ->
            case lists:keyfind(SpId, #soul_world_spirit.id, Spirits) of
                #soul_world_spirit{array_id = AId} when AId =/= 0 ->
                    sealed;
                Sp = #soul_world_spirit{} when WorkerId =:= 0 ->
                    NewSp = Sp#soul_world_spirit{array_id = ?soul_world_array_workshop},
                    NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Spirits, NewSp),
                    NewRole = Role#role{soul_world = Soul#soul_world{spirits = NewSpirits, workshop_spirit_id = SpId}},
                    soul_world_rpc:push(17904, Pid, NewSp),
                    soul_world_rpc:push(17926, Pid, SpId),
                    NewRole2 = role_listener:special_event(NewRole, {1062, 1}),
                    {ok, NewRole2};
                Sp = #soul_world_spirit{} ->
                    NewSp = Sp#soul_world_spirit{array_id = ?soul_world_array_workshop},
                    Sps1 = case lists:keyfind(WorkerId, #soul_world_spirit.id, Spirits) of
                        Worker = #soul_world_spirit{} ->
                            soul_world_rpc:push(17904, Pid, Worker#soul_world_spirit{array_id = 0}),
                            lists:keyreplace(WorkerId, #soul_world_spirit.id, Spirits, Worker#soul_world_spirit{array_id = 0});
                        _ ->
                            Spirits
                    end,
                    NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Sps1, NewSp),
                    NewRole = Role#role{soul_world = Soul#soul_world{spirits = NewSpirits, workshop_spirit_id = SpId}},
                    soul_world_rpc:push(17904, Pid, NewSp),
                    soul_world_rpc:push(17926, Pid, SpId),
                    NewRole2 = role_listener:special_event(NewRole, {1062, 1}),
                    {ok, NewRole2};
                _ ->
                    spirit_not_found
            end
    end;
%% 神魔阵和灵宠阵
seal(Role = #role{pid = Pid, soul_world = Soul = #soul_world{spirits = Spirits, arrays = Arrays, pet_arrays = PetArrays}}, SpId, ArrayId) ->
    case lists:keyfind(SpId, #soul_world_spirit.id, Spirits) of
        #soul_world_spirit{array_id = AId} when AId =/= 0 ->
            sealed;
        %% 宠物阵
        Sp = #soul_world_spirit{array_id = 0, fc = SpFc} when ArrayId >= ?soul_world_pet_array_start_id ->
            case lists:keyfind(ArrayId, #soul_world_array.id, PetArrays) of
                #soul_world_array{lev = 0}  ->
                    lev_lower;
                #soul_world_array{spirit_id = SealedId} when SealedId =/= 0 ->
                    array_used;
                Array = #soul_world_array{spirit_id = 0, lev = Lev, fc = ArrayFc} ->
                    NewSp = Sp#soul_world_spirit{array_id = ArrayId},
                    NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Spirits, NewSp),
                    NewFc = ArrayFc + SpFc,
                    NewAttr = get_add_attr(ArrayId, Lev, NewFc),
                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, PetArrays, Array#soul_world_array{spirit_id = SpId, fc = NewFc, attr = NewAttr}),
                    NewRole = Role#role{soul_world = Soul#soul_world{spirits = NewSpirits, pet_arrays = NewArrays}}, 
                    soul_world_rpc:push(17904, Pid, NewSp),
                    NewRole2 = role_listener:special_event(NewRole, {1062, 1}),
                    soul_world_rpc:push(17917, Pid, NewRole2),
                    NewRole3 = pet_api:reset_all(NewRole2),
                    {ok, NewRole3};
                _ ->
                    array_not_found
            end;
        Sp = #soul_world_spirit{array_id = 0, fc = SpFc} ->
            case lists:keyfind(ArrayId, #soul_world_array.id, Arrays) of
                #soul_world_array{lev = 0}  ->
                    lev_lower;
                #soul_world_array{spirit_id = SealedId} when SealedId =/= 0 ->
                    array_used;
                Array = #soul_world_array{spirit_id = 0, lev = Lev} ->
                    NewSp = Sp#soul_world_spirit{array_id = ArrayId},
                    NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Spirits, NewSp),
                    NewFc = SpFc,
                    NewAttr = get_add_attr(ArrayId, Lev, NewFc),
                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, Array#soul_world_array{spirit_id = SpId, fc = NewFc, attr = NewAttr}),
                    NewRole = Role#role{soul_world = Soul#soul_world{spirits = NewSpirits, arrays = NewArrays}}, 
                    soul_world_rpc:push(17904, Pid, NewSp),
                    soul_world_rpc:push(17905, Pid, NewRole),
                    NewRole2 = role_listener:special_event(NewRole, {1062, 1}),
                    NewRole3 = role_api:push_attr(NewRole2),
                    {ok, NewRole3};
                _ ->
                    array_not_found
            end;
        _ ->
            spirit_not_found
    end.

%% @spec unseal(Role, SpId) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% SpId = integer()
%% FailReason = atom()
%% @doc 释放妖灵
unseal(#role{event = Event}, _SpId) when Event =/= ?event_no andalso Event =/= ?event_guild andalso Event =/= ?event_dungeon ->
    wrong_event;
unseal(Role = #role{pid = Pid, soul_world = Soul = #soul_world{spirits = Spirits, arrays = Arrays, pet_arrays = PetArrays, workshop_producing = Producing}}, SpId) ->
    case lists:keyfind(SpId, #soul_world_spirit.id, Spirits) of
        #soul_world_spirit{array_id = 0} ->
            unsealed;
        %% 生产坊
        Sp = #soul_world_spirit{array_id = ?soul_world_array_workshop} ->
            case Producing of
                [_H | _] -> 
                    workshop_busy;
                _ ->
                    NewSp = Sp#soul_world_spirit{array_id = 0},
                    NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Spirits, NewSp),
                    soul_world_rpc:push(17904, Pid, NewSp),
                    soul_world_rpc:push(17926, Pid, 0),
                    NewRole = Role#role{soul_world = Soul#soul_world{spirits = NewSpirits, workshop_spirit_id = 0}}, 
                    {ok, NewRole}
            end;
        %% 宠物阵
        Sp = #soul_world_spirit{array_id = ArrayId} when ArrayId >= ?soul_world_pet_array_start_id ->
            case lists:keyfind(ArrayId, #soul_world_array.id, PetArrays) of
                Array = #soul_world_array{} ->
                    NewSp = Sp#soul_world_spirit{array_id = 0},
                    NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Spirits, NewSp),
                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, PetArrays, Array#soul_world_array{spirit_id = 0, fc = 0, attr = 0}),
                    soul_world_rpc:push(17904, Pid, NewSp),
                    NewRole = Role#role{soul_world = Soul#soul_world{spirits = NewSpirits, pet_arrays = NewArrays}}, 
                    soul_world_rpc:push(17917, Pid, NewRole),
                    NewRole1 = pet_api:reset_all(NewRole),
                    {ok, NewRole1};
                _ ->
                    ?DEBUG("没发现对应的封印 ~w", [ArrayId]),
                    NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Spirits, Sp#soul_world_spirit{array_id = 0}),
                    {ok, Role#role{soul_world = Soul#soul_world{spirits = NewSpirits}}}
            end;
        %% 神魔阵
        Sp = #soul_world_spirit{array_id = ArrayId} ->
            case lists:keyfind(ArrayId, #soul_world_array.id, Arrays) of
                Array = #soul_world_array{} ->
                    NewSp = Sp#soul_world_spirit{array_id = 0},
                    NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Spirits, NewSp),
                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, Array#soul_world_array{spirit_id = 0, fc = 0, attr = 0}),
                    soul_world_rpc:push(17904, Pid, NewSp),
                    NewRole = Role#role{soul_world = Soul#soul_world{spirits = NewSpirits, arrays = NewArrays}}, 
                    soul_world_rpc:push(17905, Pid, NewRole),
                    NewRole1 = role_api:push_attr(NewRole),
                    {ok, NewRole1};
                _ ->
                    ?DEBUG("没发现对应的封印 ~w", [ArrayId]),
                    NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Spirits, Sp#soul_world_spirit{array_id = 0}),
                    {ok, Role#role{soul_world = Soul#soul_world{spirits = NewSpirits}}}
            end;
        _ ->
            spirit_not_found
    end.

%% @spec upgrade_array(Role, ArrayId) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% ArrayId = integer()
%% FailReason = atom()
%% @doc 升级封印
upgrade_array(#role{lev = Lev}, _ArrayId) when Lev < ?soul_world_open_lev ->
    role_lev_lower;
upgrade_array(#role{event = Event}, _ArrayId) when Event =/= ?event_no andalso Event =/= ?event_guild andalso Event =/= ?event_spring_bank andalso Event =/= ?event_spring_water andalso Event =/= ?event_dungeon ->
    wrong_event;
%% 宠物阵
upgrade_array(Role = #role{pid = Pid, soul_world = Soul = #soul_world{pet_arrays = Arrays}}, ArrayId) when ArrayId >= ?soul_world_pet_array_start_id ->
    case [Ing || #soul_world_array{upgrade_finish = Ing} <- Arrays, Ing =/= 0] of
        [] ->
            case lists:keyfind(ArrayId, #soul_world_array.id, Arrays) of
                #soul_world_array{lev = ?soul_world_array_max_lev} ->
                    max_lev;
                %% 第一个的前置封印是最后一个
                A = #soul_world_array{id = ?soul_world_pet_array_start_id, lev = Lev} ->
                    case lists:keyfind(17, #soul_world_array.id, Arrays) of
                        #soul_world_array{lev = PreLev} when PreLev < Lev ->
                            pre_lev_lower;
                        _ ->
                            case get_pet_upgrade_time(Lev + 1) of
                                {TimeNeed, Cost} ->
                                    NewA = A#soul_world_array{upgrade_finish = TimeNeed + util:unixtime()},
                                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, NewA),
                                    case role_gain:do(Cost, Role#role{soul_world = Soul#soul_world{pet_arrays = NewArrays}}) of
                                        {ok, NewRole} ->
                                            Items = get_loss_item(Cost, []),
                                            log:log(log_soul_world, {upgrade_array, item_to_desc(Items, <<>>), make_desc(upgrade_array, A), make_desc(upgrade_array, NewA), Role}),
                                            soul_world_rpc:push(17917, Pid, NewRole),
                                            {ok, role_timer:set_timer(soul_world_array_pet, (TimeNeed + 1) * 1000, {soul_world, finish_upgrade_array, [ArrayId]}, 1, NewRole)};
                                        {false, #loss{err_code = ?coin_all_less}} ->
                                            coin_less;
                                        _ ->
                                            item_less
                                    end;
                                _ ->
                                    max_lev
                            end
                    end;
                %% 其他则是id减1
                A = #soul_world_array{lev = Lev} ->
                    case lists:keyfind(ArrayId - 1, #soul_world_array.id, Arrays) of
                        #soul_world_array{lev = PreLev} when PreLev < Lev + 1 ->
                            pre_lev_lower;
                        _ ->
                            case get_pet_upgrade_time(Lev + 1) of
                                {TimeNeed, Cost} ->
                                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{upgrade_finish = TimeNeed + util:unixtime()}),
                                    case role_gain:do(Cost, Role#role{soul_world = Soul#soul_world{pet_arrays = NewArrays}}) of
                                        {ok, NewRole} ->
                                            soul_world_rpc:push(17917, Pid, NewRole),
                                            {ok, role_timer:set_timer(soul_world_array_pet, (TimeNeed + 1) * 1000, {soul_world, finish_upgrade_array, [ArrayId]}, 1, NewRole)};
                                        {false, #loss{err_code = ?coin_all_less}} ->
                                            coin_less;
                                         _ ->
                                             item_less
                                    end;
                                _ ->
                                    max_lev
                            end
                    end;
                _ ->
                    array_not_found
            end;
        _ ->
            upgrading
    end;
%% 神魔阵
upgrade_array(Role = #role{pid = Pid, soul_world = Soul = #soul_world{arrays = Arrays}}, ArrayId) ->
    case [Ing || #soul_world_array{upgrade_finish = Ing} <- Arrays, Ing =/= 0] of
        [] ->
            case lists:keyfind(ArrayId, #soul_world_array.id, Arrays) of
                #soul_world_array{lev = ?soul_world_array_max_lev} ->
                    max_lev;
                %% 第一个的前置封印是最后一个
                A = #soul_world_array{id = 1, lev = Lev} ->
                    case lists:keyfind(10, #soul_world_array.id, Arrays) of
                        #soul_world_array{lev = PreLev} when PreLev < Lev ->
                            pre_lev_lower;
                        _ ->
                            case get_upgrade_time(Lev + 1) of
                                {TimeNeed, Cost} ->
                                    NewA = A#soul_world_array{upgrade_finish = TimeNeed + util:unixtime()},
                                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, NewA),
                                    case role_gain:do(Cost, Role#role{soul_world = Soul#soul_world{arrays = NewArrays}}) of
                                        {ok, NewRole} ->
                                            Items = get_loss_item(Cost, []),
                                            log:log(log_soul_world, {upgrade_array, item_to_desc(Items, <<>>), make_desc(upgrade_array, A), make_desc(upgrade_array, NewA), Role}),
                                            soul_world_rpc:push(17905, Pid, NewRole),
                                            {ok, role_timer:set_timer(soul_world_array, TimeNeed * 1000, {soul_world, finish_upgrade_array, [ArrayId]}, 1, NewRole)};
                                        {false, #loss{err_code = ?coin_all_less}} ->
                                            coin_less;
                                        _ ->
                                            item_less
                                    end;
                                _ ->
                                    max_lev
                            end
                    end;
                %% 其他则是id减1
                A = #soul_world_array{lev = Lev} ->
                    case lists:keyfind(ArrayId - 1, #soul_world_array.id, Arrays) of
                        #soul_world_array{lev = PreLev} when PreLev < Lev + 1 ->
                            pre_lev_lower;
                        _ ->
                            case get_upgrade_time(Lev + 1) of
                                {TimeNeed, Cost} ->
                                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{upgrade_finish = TimeNeed + util:unixtime()}),
                                    case role_gain:do(Cost, Role#role{soul_world = Soul#soul_world{arrays = NewArrays}}) of
                                        {ok, NewRole} ->
                                            soul_world_rpc:push(17905, Pid, NewRole),
                                            {ok, role_timer:set_timer(soul_world_array, TimeNeed * 1000, {soul_world, finish_upgrade_array, [ArrayId]}, 1, NewRole)};
                                        {false, #loss{err_code = ?coin_all_less}} ->
                                            coin_less;
                                         _ ->
                                             item_less
                                    end;
                                _ ->
                                    max_lev
                            end
                    end;
                _ ->
                    array_not_found
            end;
        _ ->
            upgrading
    end.

%% @spec speed_up(Role, ArrayId) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% ArrayId = integer()
%% FailReason = atom()
%% @doc 封印升级加速
speed_up(#role{event = Event}, _ArrayId, _Reduce) when Event =/= ?event_no andalso Event =/= ?event_guild andalso Event =/= ?event_dungeon ->
    wrong_event;
%% 宠物阵
speed_up(Role = #role{pid = Pid, soul_world = Soul = #soul_world{pet_arrays = Arrays, pet_array_lev = ArrayLev}}, ArrayId, Reduce) when ArrayId >= ?soul_world_pet_array_start_id ->
    case lists:keyfind(ArrayId, #soul_world_array.id, Arrays) of
        #soul_world_array{upgrade_finish = 0} ->
            no_upgrading;
        %% 加速多少分钟
        A = #soul_world_array{lev = Lev, upgrade_finish = Timeout, fc = Fc} when is_integer(Reduce) andalso Reduce > 0 ->
            Now = util:unixtime(),
            {Secs, RestTime} = case Timeout - Now of
                T when T > Reduce * 60 -> {Reduce * 60, T};
                T when T > 0 -> {T, T};
                _ -> {1, 1}
            end,
            ?DEBUG("加速了 ~w秒", [Secs]),
            case role_gain:do([#loss{label = gold, val = pay:price(?MODULE, speed_up, Secs)}], Role) of
                %% 完成升级
                {ok, NewRole} when Reduce * 60 >= RestTime ->
                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{upgrade_finish = 0, lev = Lev + 1, attr = get_add_attr(ArrayId, Lev + 1, Fc)}),
                    NewRole1 = NewRole#role{soul_world = Soul#soul_world{pet_arrays = NewArrays, pet_array_lev = ArrayLev + 1}},
                    case role_timer:del_timer(soul_world_array_pet, NewRole1) of
                        {ok, _, NewRole2} ->
                            update_ets(NewRole2),
                            soul_world_rpc:push(17917, Pid, NewRole2),
                            NewRole3 = pet_api:reset_all(NewRole2),
                            {ok, NewRole3};
                        _ ->
                            fail
                    end;
                {ok, NewRole} ->
                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{upgrade_finish = Timeout - Secs, lev = Lev}),
                    NewRole1 = NewRole#role{soul_world = Soul#soul_world{pet_arrays = NewArrays}},
                    case role_timer:del_timer(soul_world_array_et, NewRole1) of
                        {ok, _, NewRole2} ->
                            soul_world_rpc:push(17917, Pid, NewRole2),
                            {ok, role_timer:set_timer(soul_world_array_pet, (Timeout - Secs - Now) * 1000, {soul_world, finish_upgrade_array, [ArrayId]}, 1, NewRole2)};
                        _ ->
                            fail
                    end;
                _ ->
                    gold_less
            end;
        %% 加速到完成
        A = #soul_world_array{lev = Lev, upgrade_finish = Timeout, fc = Fc} ->
            ?DEBUG("全部加速 ~w", [Reduce]),
            Secs = case Timeout - util:unixtime() of
                T when T > 0 -> T;
                _ -> 1
            end,
            case role_gain:do([#loss{label = gold, val = pay:price(?MODULE, all_speed_up, Secs)}], Role) of
                {ok, NewRole} ->
                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{upgrade_finish = 0, lev = Lev + 1, attr = get_add_attr(ArrayId, Lev + 1, Fc)}),
                    NewRole1 = NewRole#role{soul_world = Soul#soul_world{pet_arrays = NewArrays, pet_array_lev = ArrayLev + 1}},
                    case role_timer:del_timer(soul_world_array_pet, NewRole1) of
                        {ok, _, NewRole2} ->
                            update_ets(NewRole2),
                            soul_world_rpc:push(17917, Pid, NewRole2),
                            NewRole3 = pet_api:reset_all(NewRole2),
                            {ok, NewRole3};
                        _ ->
                            fail
                    end;
                _ ->
                    gold_less
            end;
        _ ->
            not_found
    end;
speed_up(Role = #role{pid = Pid, soul_world = Soul = #soul_world{arrays = Arrays, array_lev = ArrayLev}}, ArrayId, Reduce) ->
    ?DEBUG("加速类型 ~w", [Reduce]),
    case lists:keyfind(ArrayId, #soul_world_array.id, Arrays) of
        #soul_world_array{upgrade_finish = 0} ->
            no_upgrading;
        %% 加速多少分钟
        A = #soul_world_array{lev = Lev, upgrade_finish = Timeout, fc = Fc} when is_integer(Reduce) andalso Reduce > 0 ->
            Now = util:unixtime(),
            {Secs, RestTime} = case Timeout - Now of
                T when T > Reduce * 60 -> {Reduce * 60, T};
                T when T > 0 -> {T, T};
                _ -> {1, 1}
            end,
            ?DEBUG("加速了 ~w秒", [Secs]),
            case role_gain:do([#loss{label = gold, val = pay:price(?MODULE, do_speed, Secs)}], Role) of
                %% 完成升级
                {ok, NewRole} when Reduce * 60 >= RestTime ->
                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{upgrade_finish = 0, lev = Lev + 1, attr = get_add_attr(ArrayId, Lev + 1, Fc)}),
                    NewRole1 = NewRole#role{soul_world = Soul#soul_world{arrays = NewArrays, array_lev = ArrayLev + 1}},
                    case role_timer:del_timer(soul_world_array, NewRole1) of
                        {ok, _, NewRole2} ->
                            soul_world_rpc:push(17905, Pid, NewRole2),
                            update_ets(NewRole2),
                            NewRole3 = role_api:push_attr(NewRole2),
                            NewRole4 = role_listener:special_event(NewRole3, {20027, ArrayLev + 1}),
                            {ok, NewRole4};
                        _ ->
                            fail
                    end;
                {ok, NewRole} ->
                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{upgrade_finish = Timeout - Secs, lev = Lev}),
                    NewRole1 = NewRole#role{soul_world = Soul#soul_world{arrays = NewArrays}},
                    case role_timer:del_timer(soul_world_array, NewRole1) of
                        {ok, _, NewRole2} ->
                            soul_world_rpc:push(17905, Pid, NewRole2),
                            {ok, role_timer:set_timer(soul_world_array, (Timeout - Secs - Now) * 1000, {soul_world, finish_upgrade_array, [ArrayId]}, 1, NewRole2)};
                        _ ->
                            fail
                    end;
                _ ->
                    gold_less
            end;
        %% 加速到完成
        A = #soul_world_array{lev = Lev, upgrade_finish = Timeout, fc = Fc} ->
            ?DEBUG("全部加速 ~w", [Reduce]),
            Secs = case Timeout - util:unixtime() of
                T when T > 0 -> T;
                _ -> 1
            end,
            case role_gain:do([#loss{label = gold, val = pay:price(?MODULE, speed_finish, Secs)}], Role) of
                {ok, NewRole} ->
                    NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{upgrade_finish = 0, lev = Lev + 1, attr = get_add_attr(ArrayId, Lev + 1, Fc)}),
                    NewRole1 = NewRole#role{soul_world = Soul#soul_world{arrays = NewArrays, array_lev = ArrayLev + 1}},
                    case role_timer:del_timer(soul_world_array, NewRole1) of
                        {ok, _, NewRole2} ->
                            update_ets(NewRole2),
                            soul_world_rpc:push(17905, Pid, NewRole2),
                            NewRole3 = role_api:push_attr(NewRole2),
                            NewRole4 = role_listener:special_event(NewRole3, {20027, ArrayLev + 1}),
                            {ok, NewRole4};
                        _ ->
                            fail
                    end;
                _ ->
                    gold_less
            end;
        _ ->
            not_found
    end.

%% 升级封印倒计时结束的处理
%% 仙宠阵
finish_upgrade_array(Role = #role{pid = Pid, soul_world = Soul = #soul_world{pet_arrays = Arrays, pet_array_lev = AllLev}}, ArrayId) when ArrayId >= ?soul_world_pet_array_start_id ->
    case lists:keyfind(ArrayId, #soul_world_array.id, Arrays) of
        A = #soul_world_array{lev = Lev, fc = Fc} ->
            NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{upgrade_finish = 0, lev = Lev + 1,attr = get_add_attr(ArrayId, Lev + 1, Fc)}),
            NewRole = Role#role{soul_world = Soul#soul_world{pet_arrays = NewArrays, pet_array_lev = AllLev + 1}},
            soul_world_rpc:push(17917, Pid, NewRole),
            update_ets(NewRole),
            NewRole1 = pet_api:reset_all(NewRole),
            {ok, NewRole1};
        _ ->
            {ok}
    end;
%% 神魔阵
finish_upgrade_array(Role = #role{pid = Pid, soul_world = Soul = #soul_world{arrays = Arrays, array_lev = AllLev}}, ArrayId) ->
    case lists:keyfind(ArrayId, #soul_world_array.id, Arrays) of
        A = #soul_world_array{lev = Lev, fc = Fc} ->
            NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{upgrade_finish = 0, lev = Lev + 1,attr = get_add_attr(ArrayId, Lev + 1, Fc)}),
            NewRole = Role#role{soul_world = Soul#soul_world{arrays = NewArrays, array_lev = AllLev + 1}},
            soul_world_rpc:push(17905, Pid, NewRole),
            NewRole2 = role_api:push_attr(NewRole),
            update_ets(NewRole2),
            rank:listener(soul_world, NewRole2),
            NewRole3 = role_listener:special_event(NewRole2, {20027, AllLev + 1}),
            {ok, NewRole3};
        _ ->
            {ok}
    end.

%% @spec upgrade_magic(Role, SpId, Type) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% SpId = Type = integer()
%% FailReason = atom()
%% @doc 妖灵法宝升级
upgrade_magic(#role{event = Event}, _SpId, _Type) when Event =/= ?event_no andalso Event =/= ?event_guild andalso Event =/= ?event_dungeon ->
    wrong_event;
upgrade_magic(Role = #role{id = {Rid, RSrvId}, name = RName, pid = Pid, soul_world = Soul = #soul_world{spirits = Spirits, arrays = Arrays, pet_arrays = PetArrays}}, SpId, Type) ->
    case lists:keyfind(SpId, #soul_world_spirit.id, Spirits) of
        Sp = #soul_world_spirit{magics = Magics, array_id = ArrayId, fc = Fc} ->
            case lists:keyfind(Type, #soul_world_spirit_magic.type, Magics) of
                #soul_world_spirit_magic{lev = ?soul_world_magic_max_lev} ->
                    max_lev;
                Magic = #soul_world_spirit_magic{lev = Lev, luck = Luck, max_luck = MaxLuck} ->
                    case role_gain:do([#loss{label = item, val = [33151, 0, 1]}, #loss{label = coin_all, val = 2000}], Role) of
                        {ok, NewRole} ->
                            case soul_world_data:get_magic_by_lev(Lev) of
                                {_Fc, _Addtion, _MaxLuck, LuckPer, Ratio} ->
                                    %% 幸运值只有达到一定比例时才会触发升级判断
                                    AddLuck = util:rand(1, 3),
                                    {FinalLuck, NewLev} = case Luck + AddLuck of
                                        NewLuck when NewLuck >= MaxLuck ->
                                            {0, Lev + 1};
                                        NewLuck when NewLuck >= LuckPer -> 
                                            case Ratio >= util:rand(1, 100) of
                                                true -> {0, Lev + 1};
                                                _ -> {NewLuck, Lev}
                                            end;
                                        NewLuck ->
                                            {NewLuck, Lev}
                                    end,
                                    NewMagic = update_magic(Magic#soul_world_spirit_magic{lev = NewLev, luck = FinalLuck}),
                                    NewMagics = lists:keyreplace(Type, #soul_world_spirit_magic.type, Magics, NewMagic),
                                    NewSp = update_spirit(Sp#soul_world_spirit{magics = NewMagics}),
                                    soul_world_rpc:push(17904, Pid, NewSp),
                                    NewSpirits = lists:keyreplace(SpId, #soul_world_spirit.id, Spirits, NewSp),
                                    {NewArrays, NewPetArrays} = case NewSp of
                                        #soul_world_spirit{fc = NewFc} when NewFc =/= Fc andalso ArrayId >= ?soul_world_pet_array_start_id ->
                                            {Arrays, update_array(ArrayId, PetArrays, NewFc)};
                                        #soul_world_spirit{fc = NewFc} when NewFc =/= Fc ->
                                            {update_array(ArrayId, Arrays, NewFc), PetArrays};
                                        _ ->
                                            {Arrays, PetArrays}
                                    end,
                                    log:log(log_soul_world, {upgrade_magic, item_to_desc([{33151, 1}], <<>>), make_desc(upgrade_magic, Sp), make_desc(upgrade_magic, NewSp), Role}),
                                    NewRole1 = NewRole#role{soul_world = Soul#soul_world{spirits = NewSpirits, arrays = NewArrays, pet_arrays = NewPetArrays}},
                                    update_ets(NewRole1),
                                    case ArrayId >= ?soul_world_pet_array_start_id of
                                        _ when ArrayId =:= ?soul_world_array_workshop ->
                                            ok;
                                        true ->
                                            soul_world_rpc:push(17917, Pid, NewRole);
                                        _ ->
                                            soul_world_rpc:push(17905, Pid, NewRole1)
                                    end,
                                    campaign_listener:handle(soul_world_magic_lev, Role, Lev, NewLev), %% 后台活动事件
                                    case {NewLev > Lev, Type} of
                                        {true, 1} when NewLev >= 13 ->
                                            notice:send(52, util:fbin(?L(<<"~s通过升级妖灵法宝，使【<font color='#fff9600'>~s</font>】达到了~w级，妖灵战力值大大提升。">>),[notice:role_to_msg({Rid, RSrvId, RName}), ?L(<<"五蕊莲灯">>), NewLev])),
                                            {up, NewLev, NewRole1};
                                        {true, 2} when NewLev >= 13 ->
                                            notice:send(52, util:fbin(?L(<<"~s通过升级妖灵法宝，使【<font color='#fff9600'>~s</font>】达到了~w级，妖灵战力值大大提升。">>),[notice:role_to_msg({Rid, RSrvId, RName}), ?L(<<"七彩葫芦">>), NewLev])),
                                            {up, NewLev, NewRole1};
                                        {true, _} -> 
                                            {up, NewLev, NewRole1};
                                        _ -> 
                                            {ok, AddLuck, NewRole1}
                                    end;
                                _ ->
                                    over
                            end;
                        {false, #loss{err_code = ?coin_all_less}} ->
                            coin_less;
                        _ ->
                            item_less
                    end;
                _ ->
                    no_maigc
            end;
        _ ->
            spirit_not_found
    end.

%% @spec calc(Role) -> NewRole
%% @doc 神魔阵的属性计算
calc(R = #role{lev = Lev}) when Lev < ?soul_world_open_lev ->
    R;
calc(R = #role{soul_world = #soul_world{arrays = []}}) ->
    R;
calc(Role = #role{soul_world = #soul_world{arrays = Arrays, quality_nums = QualityNums}}) ->
    Fun = fun(Id, Attr) ->
            trans_attr(Id, Attr)
    end,
    AttrList1 = [Fun(Id, Attr) || #soul_world_array{id = Id, attr = Attr, spirit_id = SpId} <- Arrays, SpId =/= 0],
    case role_attr:do_attr(AttrList1, Role) of
        {false, _Reason} ->
            ?ERR("角色[ID:~w]神魔阵属性计算错误:~w", [Role#role.id, _Reason]),
            Role;
        {ok, NewRole1} ->
            calc_quality_num_add(QualityNums, NewRole1)
    end;
calc(Role) ->
    ?ELOG("计算神魔阵出错[arrays: ~w]", [Role#role.soul_world]),
    Role.

%% @spec calc_fight_capacity(Role) -> Fc
%% Role = #role{} | #soul_world_role{}
%% Fc = integer()
%% @doc 计算神魔阵所附加的战斗力
calc_fight_capacity(#soul_world_role{career = Career, arrays = Arrays}) ->
    F = fun(#soul_world_array{id = Id, attr = Attr}) ->
            case eqm_api:get_fightcapacity_point(Career) of
                {_Paspd, Pjs, Pdmg, Pdefence, Pmetal, Pwood, Pwater, Pfire, Pearth, Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal} ->
                    P = erlang:element(Id, {Pdmg, Php, Pjs, Pdefence, Pmagic, Pmetal, Pwood, Pwater, Pfire, Pearth}),
                    Attr * P;
                _ ->
                    0
            end
    end,
    round(lists:sum([F(A) || A <- Arrays]) / 18);
calc_fight_capacity(#role{career = Career, soul_world = #soul_world{arrays = Arrays}}) ->
    F = fun(#soul_world_array{id = Id, attr = Attr}) ->
            case eqm_api:get_fightcapacity_point(Career) of
                {_Paspd, Pjs, Pdmg, Pdefence, Pmetal, Pwood, Pwater, Pfire, Pearth, Php, _Pmp, _Phitrate, _Peva, _Pcri, _Pten, Pmagic, _Pstun, _Psilent, _Psleep, _Pstone, _Ptaunt, _Ppoison, _Pseal} ->
                    P = erlang:element(Id, {Pdmg, Php, Pjs, Pdefence, Pmagic, Pmetal, Pwood, Pwater, Pfire, Pearth}),
                    Attr * P;
                _ ->
                    0
            end
    end,
    round(lists:sum([F(A) || A <- Arrays]) / 18);
calc_fight_capacity(_) ->
    0.

%% @spec calc_pet(Role) -> list()
%% Role = #role{}
%% @doc 获取宠物阵增加的属性
calc_pet(#role{lev = Lev}) when Lev < ?soul_world_open_lev ->
    [];
calc_pet(#role{soul_world = #soul_world{pet_arrays = Arrays, pet_array_lev = PetArrayLev}}) ->
    Fun = fun(Id, Attr) ->
            trans_attr(Id, Attr)
    end,
    Attrs = [Fun(Id, Attr) || #soul_world_array{id = Id, attr = Attr, spirit_id = SpId} <- Arrays, SpId =/= 0],
    ?DEBUG("附加属性 ~w", [Attrs]),
    AvgLev = round(PetArrayLev / 7),
    CommonRate = round(AvgLev * 0.1 + 1),
    ReliveRate = round(AvgLev * 0.2 + 1),
    %% 连接触发
    Rehit = {skill_rate, 110000, CommonRate},
    %% 破甲触发
    Scare = {skill_rate, 130000, CommonRate},
    %% 攻击触发
    Hit = {skill_rate, 121000, CommonRate},
    %% 涅槃触发
    ReLive = {skill_rate, 117000, ReliveRate},
    %% 抗性触发
    Resist = {skill_rate, 118000, CommonRate},
    %% 坚韧触发
    Tan = {skill_rate, 114000, CommonRate},
    %% 防御触发
    Defence = {skill_rate, 119000, CommonRate},
    %% 回蓝强化
    BackMp = {skill_effect, 190000, round(AvgLev * 50 + 200)},
    %% 回血强化
    BackHp = {skill_effect, 180000, round(AvgLev * 100 + 400)},

    SumFc = lists:sum([Fc || #soul_world_array{fc = Fc, spirit_id = SpId} <- Arrays, SpId =/= 0]),
    if
        SumFc >= 15000 ->
            [Rehit, Scare, Hit, ReLive, Resist, Tan, Defence, BackMp, BackHp | Attrs];
        SumFc >= 11500 ->
            [Scare, Hit, ReLive, Resist, Tan, Defence, BackMp, BackHp | Attrs];
        SumFc >= 8500 ->
            [Hit, ReLive, Resist, Tan, Defence, BackMp, BackHp | Attrs];
        SumFc >= 6000 ->
            [ReLive, Resist, Tan, Defence, BackMp, BackHp | Attrs];
        SumFc >= 4000 ->
            [Resist, Tan, Defence, BackMp, BackHp | Attrs];
        SumFc >= 2500 ->
            [Tan, Defence, BackMp, BackHp | Attrs];
        SumFc >= 1500 ->
            [Defence, BackMp, BackHp | Attrs];
        SumFc >= 1000 ->
            [BackMp, BackHp | Attrs];
        SumFc >= 500 ->
            [BackHp | Attrs];
        true ->
            Attrs
    end;
calc_pet(_) ->
    [].

%% @spec calc_pet_fc(Role) -> integer()
%% Role = #role{} || #soul_world_role{}
%% @doc 计算宠物阵给宠物增加多少战斗力
calc_pet_fc(#role{lev = Lev}) when Lev < ?soul_world_open_lev ->
    0;
calc_pet_fc(#role{soul_world = #soul_world{pet_arrays = Arrays}}) ->
    F = fun(#soul_world_array{id = Id, attr = Attr}) ->
            case Id of
                11 -> Attr * 0.25;
                12 -> Attr * 7.7;
                _ -> Attr
            end
    end,
    round(lists:sum([F(A) || A <- Arrays]) / 4 * 0.4);
calc_pet_fc(#soul_world_role{pet_arrays = Arrays}) ->
    F = fun(#soul_world_array{id = Id, attr = Attr}) ->
            case Id of
                11 -> Attr * 0.25;
                12 -> Attr * 7.7;
                _ -> Attr
            end
    end,
    round(lists:sum([F(A) || A <- Arrays]) / 4 * 0.4).



%% @spec get_shop() -> list()
%% @doc 获取兑换商城信息
get_shop() ->
    Oranges = [{2, OId, ?soul_world_exchange_orange_price} || OId <- soul_world_data:get_quality_ids(4)],
    Purples = [{2, PId, ?soul_world_exchange_purple_price} || PId <- soul_world_data:get_quality_ids(3)],
    ?soul_world_shop_items ++ Oranges ++ Purples.

%% @spec exchange(Role, Type, Id) -> {ok, NewRole} | FailReason
%% Role = #role{}
%% Type = Id = integer()
%% FailReason = atom()
%% @doc 兑换商品
%% 兑换妖魂
exchange(Role, 1, Id) ->
    case lists:keyfind(Id, 2, ?soul_world_shop_items) of
        {_, _, Price} ->
            Num = case Id of
                33128 -> 2;
                _ -> 4
            end,
            case role_gain:do([#loss{label = item, val = [33150, 1, Price]}], Role) of
                {ok, NewRole} ->
                    case role_gain:do([#gain{label = item, val = [Id, 1, Num]}], NewRole) of
                        {ok, NewRole1} ->
                            {ok, NewRole1};
                        _ ->
                            false
                    end;
                _ ->
                    item_less
            end;
        _ ->
            no_goods
    end;
%% 兑换妖灵
exchange(Role = #role{pid = Pid, soul_world = Soul = #soul_world{spirits = Spirits, quality_nums = QNums}}, _, Id) ->
    case lists:keyfind(Id, #soul_world_spirit.id, Spirits) of
        #soul_world_spirit{} ->
            exist;
        _ ->
            case soul_world_data:get(Id) of
                Sp = #soul_world_spirit{quality = Q} when Q >= 3 ->
                    Price = case Q of
                        4 -> ?soul_world_exchange_orange_price;
                        _ -> ?soul_world_exchange_purple_price
                    end,
                    case role_gain:do([#loss{label = item, val = [33150, 1, Price]}], Role) of
                        {ok, NewRole} ->
                            NewQNums = case lists:keyfind(Q, 1, QNums) of
                                {Q, QNum} ->
                                    lists:keyreplace(Q, 1, QNums, {Q, QNum + 1});
                                _ ->
                                    [{Q, 1} | QNums]
                            end,
                            NewRole1 = NewRole#role{soul_world = Soul#soul_world{spirits = [Sp | Spirits], quality_nums = NewQNums}}, 
                            soul_world_rpc:push(17900, Pid, NewRole1),
                            NewRole2 = role_listener:acc_event(NewRole1, {124, Q}),
                            {ok, NewRole2};
                        _ ->
                            item_less
                    end;
                _ ->
                    no_goods
            end
    end.

%% @spec merge_spirits(Role, MasterId, SlaveId) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% MasterId = SlaveId = integer()
%% FailReason = atom()
%% @doc 妖灵吞噬
merge_spirits(Role = #role{soul_world = Soul = #soul_world{spirits = Spirits, arrays = Arrays, pet_arrays = PetArrays}}, MasterId, SlaveId) ->
    case lists:keyfind(MasterId, #soul_world_spirit.id, Spirits) of
        MSp = #soul_world_spirit{quality = MQuality, exp = MExp, magics = MMagics, array_id = MArrayId} ->
            case lists:keyfind(SlaveId, #soul_world_spirit.id, Spirits) of
                #soul_world_spirit{quality = SQuality} when SQuality >= MQuality ->
                    quality_wrong;
                #soul_world_spirit{exp = SExp, magics = SMagics, array_id = SArrayId} ->
                    NewMagics = get_stronger_magics(MMagics, SMagics),
                    NewMSp = #soul_world_spirit{fc = MFc} = update_spirit(MSp#soul_world_spirit{exp = MExp + SExp, magics = NewMagics}),
                    SSp = #soul_world_spirit{fc = SFc} = soul_world_data:get(SlaveId),
                    Sps1 = lists:keyreplace(MasterId, #soul_world_spirit.id, Spirits, NewMSp),
                    Sps2 = lists:keyreplace(SlaveId, #soul_world_spirit.id, Sps1, SSp#soul_world_spirit{array_id = SArrayId}),
                    {NewArrays1, NewPetArrays1} = case MArrayId >= ?soul_world_pet_array_start_id of
                        true -> {Arrays, update_array(MArrayId, PetArrays, MFc)};
                        _ -> {update_array(MArrayId, Arrays, MFc), PetArrays}
                    end,
                    {NewArrays2, NewPetArrays2} = case SArrayId >= ?soul_world_pet_array_start_id of
                        true -> {NewArrays1, update_array(SArrayId, NewPetArrays1, SFc)};
                        _ -> {update_array(SArrayId, NewArrays1, SFc), NewPetArrays1}
                    end,
                    {ok, Role#role{soul_world = Soul#soul_world{spirits = Sps2, arrays = NewArrays2, pet_arrays = NewPetArrays2}}};
                _ ->
                    spirit_not_found
            end;
        _ ->
            spirit_not_found
    end.

%% @spec view_merge_spirits(Role, MasterId, SlaveId) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% MasterId = SlaveId = integer()
%% FailReason = atom()
%% @doc 预览妖灵吞噬
view_merge_spirits(#role{soul_world = #soul_world{spirits = Spirits}}, MasterId, SlaveId) ->
    case lists:keyfind(MasterId, #soul_world_spirit.id, Spirits) of
        MSp = #soul_world_spirit{quality = MQuality, exp = MExp, magics = MMagics} ->
            case lists:keyfind(SlaveId, #soul_world_spirit.id, Spirits) of
                #soul_world_spirit{quality = SQuality} when SQuality >= MQuality ->
                    quality_wrong;
                #soul_world_spirit{exp = SExp, magics = SMagics} ->
                    NewMagics = get_stronger_magics(MMagics, SMagics),
                    update_spirit(MSp#soul_world_spirit{exp = MExp + SExp, magics = NewMagics});
                _ ->
                    spirit_not_found
            end;
        _ ->
            spirit_not_found
    end.

%% @spec unlock_workshop(Role, Id) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% Id = integer()
%% FailReason = atom()
%% @doc 激活一个生产坊
unlock_workshop(Role = #role{soul_world = Soul = #soul_world{spirits = Spirits, workshop = WorkShop}}, ItemId) ->
        case lists:keyfind(ItemId, #soul_world_workshop.item_id, WorkShop) of
            #soul_world_workshop{} ->
                unlocked;
            _ ->
                case soul_world_data:get_workshop(ItemId) of
                    #soul_world_workshop_base{unlock_fc = UnlockFc, unlock_coin = UnlockCoin, unlock_gold = UnlockGold, item_id = ItemId} ->
                        AllFc = lists:sum([Fc || #soul_world_spirit{fc = Fc} <- Spirits]),
                        case AllFc >= UnlockFc of
                            true ->
                                Cost = case {UnlockCoin, UnlockGold} of
                                    {0, _} -> [#loss{label = gold, val = UnlockGold}];
                                    {_, 0} -> [#loss{label = coin_all, val = UnlockCoin}];
                                    _ -> [#loss{label = gold, val = UnlockGold}, #loss{label = coin_all, val = UnlockCoin}]
                                end,
                                case role_gain:do(Cost, Role) of
                                    {ok, NewRole} ->
                                        {ok, NewRole#role{soul_world = Soul#soul_world{workshop = [#soul_world_workshop{item_id = ItemId} | WorkShop]}}};
                                    {false, #loss{err_code = ?coin_all_less}} ->
                                        coin_less;
                                    _ ->
                                        gold_less
                                end;
                            _ ->
                                fc_lower
                        end;
                    _ ->
                        no_workshop
                end
        end.

%% @spec start_produce(Role, Id) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% ItemId = integer()
%% FailReason = atom()
%% @doc 开始生产一个物品
start_produce(_R, _ItemId, Num) when Num < 1 ->
    wrong_num;
start_produce(Role = #role{soul_world = Soul = #soul_world{spirits = Spirits, workshop = WorkShop, product_line = ProductLine, workshop_producing = Producing, workshop_id = WorkShopId}}, ItemId, Num) ->
    case length(Producing) >= ProductLine of
        true ->
            workshop_busy;
        _ ->
            case lists:keyfind(ItemId, #soul_world_workshop.item_id, WorkShop) of
                Work = #soul_world_workshop{} ->
                    case soul_world_data:get_workshop(ItemId) of
                        #soul_world_workshop_base{produce_coin = ProduceCoin, produce_gold = ProduceGold, produce_time = ProduceTime} ->
                            AllFc = lists:sum([Fc || #soul_world_spirit{fc = Fc} <- Spirits]),
                            %% 实际时间 =（1-n/100000)*时间
                            %% n=激活妖灵总战力
                            %% 实际时间>=时间*30%
                            Time = util:unixtime() + max(round(ProduceTime * 0.3), round((1 - AllFc / 100000) * ProduceTime)) * Num,
                            Cost = case {ProduceCoin, ProduceGold} of
                                {0, _} -> [#loss{label = gold, val = ProduceGold * Num}];
                                {_, 0} -> [#loss{label = coin_all, val = ProduceCoin * Num}];
                                _ -> [#loss{label = gold, val = ProduceGold * Num}, #loss{label = coin_all, val = ProduceCoin * Num}]
                            end,
                            case role_gain:do(Cost, Role) of
                                {ok, NewRole} ->
                                    NewProducing = [Work#soul_world_workshop{id = WorkShopId, num = Num, produce_time = Time} | Producing],
                                    {ok, NewRole#role{soul_world = Soul#soul_world{workshop_producing = NewProducing, workshop_id = WorkShopId + 1}}};
                                {false, #loss{err_code = ?coin_all_less}} ->
                                    coin_less;
                                _ ->
                                    gold_less
                            end;
                        _ ->
                            no_workshop
                    end;
                _ ->
                    no_workshop
            end
    end.

%% @spec get_product(Role, Id) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% Id = integer()
%% FailReason = atom()
%% @doc 获取生产的物品
get_product(Role = #role{soul_world = Soul = #soul_world{workshop_producing = Producing}}, Id) ->
    Now = util:unixtime(),
    case lists:keyfind(Id, #soul_world_workshop.id, Producing) of
        #soul_world_workshop{produce_time = ProduceTime} when ProduceTime > Now ->
            not_finish;
        #soul_world_workshop{item_id = ItemId, num = Num} ->
            Gain = [#gain{label = item, val = [ItemId, 1, Num]}],
            case role_gain:do(Gain, Role) of
                {ok, NewRole} ->
                    NewProducing = lists:keydelete(Id, #soul_world_workshop.id, Producing),
                    {ok, NewRole#role{soul_world = Soul#soul_world{workshop_producing = NewProducing}}};
                _ ->
                    fail
            end;
        _ ->
            not_producing
    end.

%% @spec fast_get_product(Role, Id) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% Id = integer()
%% FailReason = atom()
%% @doc 花晶钻快速获取生产的物品
fast_get_product(Role = #role{soul_world = Soul = #soul_world{workshop_producing = Producing}}, Id) ->
    Now = util:unixtime(),
    case lists:keyfind(Id, #soul_world_workshop.id, Producing) of
        #soul_world_workshop{produce_time = ProduceTime, item_id = ItemId, num = Num} ->
            Cost = case ProduceTime - Now of
                Time when Time > 0 ->
                    [#loss{label = gold, val = pay:price(?MODULE, fast_get_product, Time)}];
                _ ->
                    [#loss{label = gold, val = pay:price(?MODULE, fast_get_product, 1)}]
            end,
            case role_gain:do(Cost, Role) of
                {ok, Role1} ->
                    Gain = [#gain{label = item, val = [ItemId, 1, Num]}],
                    case role_gain:do(Gain, Role1) of
                        {ok, NewRole} ->
                            NewProducing = lists:keydelete(Id, #soul_world_workshop.id, Producing),
                            {ok, NewRole#role{soul_world = Soul#soul_world{workshop_producing = NewProducing}}};
                        _ ->
                            fail
                    end;
                _ ->
                    gold_less
            end;
        _ ->
            not_producing
    end.

%% @spec cancel_producing(Role, Id) -> {ok, NewRole} | {false, Reason}
%% Role = NewRole = #role{}
%% Id = integer()
%% Reason = bitstring()
%% @doc 取消生产
cancel_producing(Role = #role{soul_world = Soul = #soul_world{workshop_producing = Producing}, pid = Pid}, Id) ->
    case lists:keyfind(Id, #soul_world_workshop.id, Producing) of
        #soul_world_workshop{} ->
            NewProducing = lists:keydelete(Id, #soul_world_workshop.id, Producing),
            NewRole = Role#role{
                soul_world = Soul#soul_world{workshop_producing = NewProducing}
            },
            soul_world_rpc:push(17925, Pid, NewRole),
            {ok, NewRole};
        _ ->
            {false, ?L(<<"不在生产中">>)}
    end.

%% @spec add_product_line(Role) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% FailReason = atom()
%% @doc 增加生产线
add_product_line(#role{soul_world = #soul_world{product_line = ?soul_world_max_produce_line}}) ->
    max_product_line;
add_product_line(Role = #role{soul_world = Soul = #soul_world{product_line = ProductLine}}) ->
    Cost = case ProductLine of
        1 -> [#loss{label = coin_all, val = 500000}];
        2 -> [#loss{label = gold, val = pay:price(?MODULE, add_product_line, 2)}];
        3 -> [#loss{label = gold, val = pay:price(?MODULE, add_product_line, 3)}];
        _ -> [#loss{label = gold, val = pay:price(?MODULE, add_product_line, null)}]
    end,
    case role_gain:do(Cost, Role) of
        {ok, NewRole} ->
            {ok, NewRole#role{soul_world = Soul#soul_world{product_line = ProductLine + 1}}};
        {false, #loss{err_code = ?coin_all_less}} ->
            coin_less;
        _ ->
            gold_less
    end.

%% @spec fast_upgrade_array(Role, Type, Lev) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% Type = 1 | 2
%% Lev = integer(),
%% FailReason = atom()
%% @doc 一键提升阵法到指定等级
fast_upgrade_array(#role{event = Event}, _SpId, _ArrayId) when Event =/= ?event_no andalso Event =/= ?event_guild andalso Event =/= ?event_dungeon ->
    wrong_event;
fast_upgrade_array(Role = #role{pid = Pid, soul_world = Soul = #soul_world{pet_array_lev = ArrayLev, pet_arrays = Arrays}}, 2, Lev) when Lev =< ?soul_world_array_max_lev ->
    NewArrayLev = Lev * 7,
    case ArrayLev >= NewArrayLev of
        true ->
            too_low;
        _ ->
            {Coin, Gold} = calc_total_cost(ArrayLev, Lev),
            case role_gain:do([#loss{label = gold, val = Gold}, #loss{label = coin_all, val = Coin}], Role) of
                {ok, NewRole} ->
                    NewArrays = [A#soul_world_array{lev = Lev, upgrade_finish = 0, attr = get_add_attr(Id, Lev, Fc)} || A = #soul_world_array{id = Id, fc = Fc} <- Arrays],
                    NewRole1 = NewRole#role{soul_world = Soul#soul_world{pet_arrays = NewArrays, pet_array_lev = Lev * 7}},
                    soul_world_rpc:push(17917, Pid, NewRole1),
                    {ok, pet_api:reset_all(NewRole1)};
                {false, #loss{err_code = ?gold_less}} ->
                    gold_less;
                _ ->
                    coin_less
            end
    end;
fast_upgrade_array(_Role, _, _) ->
    no_suport.

%% @spec ver_parse(Data) -> #soul_world{}
%% @doc 玩家数据版本转换
ver_parse({soul_world, Ver = 1, Spirits, Spirit_num, Calleds, Arrays, Quality_nums, Array_lev, Orange_luck, Purple_luck}) ->
    ver_parse({soul_world, Ver + 1, Spirits, Spirit_num, Calleds, Arrays, Quality_nums, Array_lev, Orange_luck, Purple_luck, 0, 0});
ver_parse({soul_world, Ver = 2, Spirits, Spirit_num, Calleds, Arrays, Quality_nums, Array_lev, Orange_luck, Purple_luck, LastCalled, TodayCalled}) ->
    ver_parse({soul_world, Ver + 1, Spirits, Spirit_num, Calleds, Arrays, Quality_nums, Array_lev, Orange_luck, Purple_luck, LastCalled, TodayCalled, [], 1});
ver_parse({soul_world, Ver = 3, Spirits, Spirit_num, Calleds, Arrays, Quality_nums, Array_lev, Orange_luck, Purple_luck, LastCalled, TodayCalled, PetArrays, PetArrayLev}) ->
    ver_parse({soul_world, Ver + 1, Spirits, Spirit_num, Calleds, Arrays, Quality_nums, Array_lev, Orange_luck, Purple_luck, LastCalled, TodayCalled, PetArrays, PetArrayLev, [], 1, 0, 1, []});
ver_parse(Data = #soul_world{ver = ?soul_world_ver}) ->
    Data.


%% @spec adm_upgrade_array(Role, Lev) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% Lev = integer()
%% FailReason = atom()
%% @doc GM命令升级封印
adm_upgrade_array(Role = #role{pid = Pid, soul_world = Soul = #soul_world{arrays = Arrays}}, Lev) when is_integer(Lev) andalso Lev > 0 andalso Lev =< ?soul_world_array_max_lev ->
    NewArrays = [A#soul_world_array{lev = Lev, upgrade_finish = 0, attr = get_add_attr(Id, Lev, Fc)} || A = #soul_world_array{id = Id, fc = Fc} <- Arrays],
    NewRole = Role#role{soul_world = Soul#soul_world{arrays = NewArrays, array_lev = Lev * 10}},
    soul_world_rpc:push(17905, Pid, NewRole),
    role_api:push_attr(NewRole);
adm_upgrade_array(Role, _) ->
    Role.
adm_upgrade_array_pet(Role = #role{pid = Pid, soul_world = Soul = #soul_world{pet_arrays = Arrays}}, Lev) when is_integer(Lev) andalso Lev > 0 andalso Lev =< ?soul_world_array_max_lev ->
    NewArrays = [A#soul_world_array{lev = Lev, upgrade_finish = 0, attr = get_add_attr(Id, Lev, Fc)} || A = #soul_world_array{id = Id, fc = Fc} <- Arrays],
    NewRole = Role#role{soul_world = Soul#soul_world{pet_arrays = NewArrays, pet_array_lev = Lev * 7}},
    soul_world_rpc:push(17917, Pid, NewRole),
    pet_api:reset_all(NewRole);
adm_upgrade_array_pet(Role, _) ->
    Role.

%% @spec adm_upgrade_magic(Role, Type, Lev) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% Lev = integer()
%% FailReason = atom()
%% @doc GM命令升级法宝
adm_upgrade_magic(Role = #role{pid = Pid, soul_world = Soul = #soul_world{arrays = Arrays, spirits = Spirits}}, Type, Lev) when is_integer(Lev) andalso Lev > 0 andalso ?soul_world_magic_max_lev >= Lev ->
    F = fun(Sp = #soul_world_spirit{id = SpId, array_id = ArrayId, fc = Fc, magics = Magics}, {Sps, As}) ->
            case lists:keyfind(Type, #soul_world_spirit_magic.type, Magics) of
                Magic = #soul_world_spirit_magic{} ->
                    NewMagic = update_magic(Magic#soul_world_spirit_magic{lev = Lev, luck = 0}),
                    NewMagics = lists:keyreplace(Type, #soul_world_spirit_magic.type, Magics, NewMagic),
                    NewSp = update_spirit(Sp#soul_world_spirit{magics = NewMagics}),
                    NewSps = lists:keyreplace(SpId, #soul_world_spirit.id, Sps, NewSp),
                    NewAs = case NewSp of
                        #soul_world_spirit{fc = NewFc} when NewFc =/= Fc ->
                            update_array(ArrayId, As, NewFc);
                        _ ->
                            As
                    end,
                    {NewSps, NewAs};
                _ ->
                    {Sps, As}
            end
    end,
    {NewSpirits, NewArrays} = lists:foldl(F, {Spirits, Arrays}, Spirits),
    NewRole = Role#role{soul_world = Soul#soul_world{arrays = NewArrays, spirits = NewSpirits}},
    soul_world_rpc:push(17905, Pid, NewRole),
    soul_world_rpc:push(17900, Pid, NewRole),
    role_api:push_attr(NewRole);
adm_upgrade_magic(Role, _, _) ->
    Role.

%% 根据等级范围生成灵戒洞天数据
adm_make(Mod) ->
    {SpsBase, ALev} = dungeon_poetry_data:get_soul_world(Mod),
    Arrays = [#soul_world_array{id = I, lev = ALev} || I <- lists:seq(1, 10)],
    F = fun({SpId, SpLev, AId}, {As, Sps}) ->
            case soul_world_data:get(SpId) of
                Sp = #soul_world_spirit{magics = Magics} -> 
                    NewMagics = case soul_world_data:get_magic_by_lev(SpLev) of
                        {AddFc, Addtion, MaxLuck, _LuckPer, _Ratio} ->
                            [#soul_world_spirit_magic{type = 1, lev = SpLev, fc = AddFc, max_luck = MaxLuck}, #soul_world_spirit_magic{type = 2, addition = Addtion, max_luck = MaxLuck}];
                        _ ->
                            Magics
                    end,
                    NewSp = #soul_world_spirit{fc = Fc} = update_spirit(Sp#soul_world_spirit{lev = SpLev, array_id = AId, magics = NewMagics}),
                    NewAs = lists:keyreplace(AId, #soul_world_array.id, As, #soul_world_array{id = AId, lev = ALev, spirit_id = SpId}),
                    NewAs2 = update_array(AId, NewAs, Fc),
                    {NewAs2, [NewSp | Sps]};
                _ ->
                    {As, Sps}
            end
    end,
    {NewArrays, NewSpirits} = lists:foldl(F, {Arrays, []}, SpsBase),
    NewAllLev = ALev * 10,
    {NewSpirits, NewArrays, NewAllLev}.

%% 获取排行榜数据
get_rank() ->
    gen_server:call(?MODULE, get_rank).

%% 获取好友灵戒洞天数据
get_friends() ->
    case friend:get_friend_list() of
        Friends when is_list(Friends) ->
            NewFriends = [{Rid, SrvId} || #friend{role_id = Rid, srv_id = SrvId, type = ?sns_friend_type_hy} <- Friends],
            find_soul_world_friend(NewFriends, []);
        _ -> []
    end.

%% 仙园好友查找
find_soul_world_friend([], L) -> 
    SortL = lists:keysort(#soul_world_role.array_lev, L),
    lists:reverse(SortL);
find_soul_world_friend([Id | T], L) ->
    case ets:lookup(soul_world_role, Id) of
        [One = #soul_world_role{}] ->
            find_soul_world_friend(T, [One | L]);
        _ ->
            find_soul_world_friend(T, L)
    end.

%% @spec lookup({integer(), bitstring()}) -> #soul_world_role{} | none
%% 查看一个玩家的数据
lookup(Id = {_, SrvId}) ->
    case role_api:is_local_role(SrvId) of
        true ->
            case ets:lookup(soul_world_role, Id) of
                [One = #soul_world_role{}] ->
                    One;
                _ ->
                    none
            end;
        _ ->
            %% 跨服查看
            case center:call(c_mirror_group, call, [node, SrvId, ets, lookup, [soul_world_role, Id]]) of
                [One = #soul_world_role{}] ->
                    One;
                _ ->
                    none
            end
    end.

%% @spec listener(Role) -> NewRole
%% Role = NewRole = #role{}
%% 各类战力改变的触发
listener(Role = #role{soul_world = #soul_world{spirits = Spirits}}) ->
        AllFc = calc_fight_capacity(Role),
        Role1 = role_listener:special_event(Role, {20025, AllFc}),
        SumFc = case [Fc || #soul_world_spirit{fc = Fc} <- Spirits] of
            [] -> 0;
            Fcs -> lists:max(Fcs)
        end,
        Role2 = role_listener:special_event(Role1, {20026, SumFc}),
        rank:listener(soul_world, Role2),
        Role2.

%% -------------- opt接口 --------

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ets:new(soul_world_role, [set, named_table, public, {keypos, #soul_world_role.id}]),
    Ref = erlang:send_after(1000, self(), update_rank),
    case sys_env:get(soul_world_role) of
        [H | T] ->
            F = fun(One = #soul_world_role{spirits = Spirits, arrays = Arrays}) ->
                    NewSpirits = update_ver(Spirits, []),
                    NewArrays = [A || A = #soul_world_array{} <- Arrays],
                    ets:insert(soul_world_role, One#soul_world_role{spirits = NewSpirits, arrays = NewArrays});
                %% 版本转换
                ({soul_world_role, Id, Name ,Career ,Sex ,FaceId ,ArrayLev ,Spirits ,SpiritNum ,Arrays}) ->
                    NewSpirits = update_ver(Spirits, []),
                    NewArrays = [A || A = #soul_world_array{} <- Arrays],
                    One = #soul_world_role{
                        id = Id, 
                        name = Name, 
                        career = Career,
                        sex = Sex,
                        face_id = FaceId,
                        array_lev = ArrayLev,
                        spirits = NewSpirits, 
                        spirit_num = SpiritNum,
                        arrays = NewArrays},
                    ets:insert(soul_world_role, One);
                (_) ->
                    ok
            end,
            lists:foreach(F, [H | T]),
            {ok, #state{ref = Ref}};
        _ ->
            {ok, #state{ref = Ref}}
    end.

%% 获取排行榜数据
handle_call(get_rank, _From, State = #state{rank = Rank}) ->
    {reply, Rank, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 根据间隔同步数据
handle_info(update_rank, State = #state{ref = Ref, synced = Synced}) ->
    case erlang:is_reference(Ref) of
        true -> erlang:cancel_timer(Ref);
        _ -> ok
    end,
    List = ets:tab2list(soul_world_role),
    Rank = update_rank(List),
    NewRef = erlang:send_after(?soul_world_rank_timeout, self(), update_rank),
    case Synced rem 5 of
        6 -> sys_env:save(soul_world_role, List);
        _ -> ok
    end,
    {noreply, State#state{ref = NewRef, rank = Rank, synced = Synced + 1}};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    sys_env:save(soul_world_role, ets:tab2list(soul_world_role)),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------ 私有函数 --------
get_quality_nums([], Nums) ->
    Nums;
get_quality_nums([#soul_world_spirit{quality = Q} | T], Nums) ->
    NewQNums = case lists:keyfind(Q, 1, Nums) of
        {Q, QNum} ->
            lists:keyreplace(Q, 1, Nums, {Q, QNum + 1});
        _ ->
            [{Q, 1} | Nums]
    end,
    get_quality_nums(T, NewQNums).

%% 收集全某品质妖灵的加成
calc_quality_num_add([], Role) ->
    Role;
%% 集齐10个橙色妖灵(6/6) 防御 + 50 气血 + 200 全抗 + 50 精神 + 30 攻击 + 30 法伤 + 30
calc_quality_num_add([{4, 10} | T], Role) ->
    AttrList = [{defence, 50}, {hp_max, 200}, {dmg, 30}, {dmg_magic, 30}, {js, 30}, {resist_all, 50}],
    case role_attr:do_attr(AttrList, Role) of
        {false, _Reason} ->
            ?DEBUG("角色[ID:~w]妖灵加成属性计算错误:~w", [Role#role.id, _Reason]),
            Role;
        {ok, NewRole1} ->
            calc_quality_num_add(T, NewRole1)
    end;
%% 集齐6个紫色妖灵(6/6) 防御 + 50 气血 + 200 全抗 + 50 精神 + 30
calc_quality_num_add([{3, 6} | T], Role) ->
    AttrList = [{defence, 50}, {hp_max, 200}, {resist_all, 50}, {js, 30}],
    case role_attr:do_attr(AttrList, Role) of
        {false, _Reason} ->
            ?DEBUG("角色[ID:~w]妖灵加成属性计算错误:~w", [Role#role.id, _Reason]),
            Role;
        {ok, NewRole1} ->
            calc_quality_num_add(T, NewRole1)
    end;
%% 6蓝： 集齐6个蓝色妖灵(6/6) 防御 + 50 气血 + 200 全抗 + 50
calc_quality_num_add([{2, 6} | T], Role) ->
    AttrList = [{defence, 50}, {hp_max, 200}, {resist_all, 50}],
    case role_attr:do_attr(AttrList, Role) of
        {false, _Reason} ->
            ?DEBUG("角色[ID:~w]妖灵加成属性计算错误:~w", [Role#role.id, _Reason]),
            Role;
        {ok, NewRole1} ->
            calc_quality_num_add(T, NewRole1)
    end;
%% 集齐6个绿色妖灵(6/6) 防御 + 50 气血 + 200
calc_quality_num_add([{1, 6} | T], Role) ->
    AttrList = [{defence, 50}, {hp_max, 200}],
    case role_attr:do_attr(AttrList, Role) of
        {false, _Reason} ->
            ?DEBUG("角色[ID:~w]妖灵加成属性计算错误:~w", [Role#role.id, _Reason]),
            Role;
        {ok, NewRole1} ->
            calc_quality_num_add(T, NewRole1)
    end;
calc_quality_num_add([_ | T], Role) ->
    calc_quality_num_add(T, Role).

%% 灵戒洞天榜
update_rank([H | T]) ->
    F = fun(#soul_world_role{array_lev = LevA}, #soul_world_role{array_lev = LevB}) ->
            LevA > LevB
    end,
    List1 = lists:sort(F, [H | T]),
    lists:sublist(List1, 30);
update_rank(_) ->
    [].

%% 同步数据到ets
update_ets(#role{id = Id, name = Name, sex = Sex, career = Career, vip = #vip{portrait_id = FaceId}, soul_world = #soul_world{spirits = Spirits, spirit_num = SpiritNum, arrays = Arrays, array_lev = ArrayLev, pet_arrays = PetArrays, pet_array_lev = PetArrayLev}, lev = Lev}) when Lev >= ?soul_world_open_lev ->
        R = #soul_world_role{
            id = Id
            ,name = Name
            ,sex = Sex
            ,career = Career
            ,face_id = FaceId
            ,spirits = Spirits
            ,spirit_num = SpiritNum
            ,arrays = Arrays
            ,array_lev = ArrayLev
            ,pet_arrays = PetArrays
            ,pet_array_lev = PetArrayLev
        },
        ets:insert(soul_world_role, R);
update_ets(_) ->
        ok.

%% 神魔阵要检查下有没要升级的封印
check_upgrade_array([], NewArrays, Role) ->
    {lists:reverse(NewArrays), Role};
check_upgrade_array([Array = #soul_world_array{id = Aid, lev = Lev, upgrade_finish = FinishTime, fc = Fc} | T], Arrays, Role) when FinishTime =/= 0 ->
    case FinishTime - util:unixtime() of
        Timeout when Timeout > 0 andalso Aid >= ?soul_world_pet_array_start_id ->
            case role_timer:set_timer(soul_world_array_pet, Timeout * 1000, {soul_world, finish_upgrade_array, [Aid]}, 1, Role) of
                NewRole = #role{} ->
                    check_upgrade_array(T, [Array | Arrays], NewRole);
                _ ->
                    check_upgrade_array(T, [Array | Arrays], Role)
            end;
        Timeout when Timeout > 0 ->
            case role_timer:set_timer(soul_world_array, Timeout * 1000, {soul_world, finish_upgrade_array, [Aid]}, 1, Role) of
                NewRole = #role{} ->
                    check_upgrade_array(T, [Array | Arrays], NewRole);
                _ ->
                    check_upgrade_array(T, [Array | Arrays], Role)
            end;
        _ ->
            NewLev = min(Lev + 1, ?soul_world_array_max_lev),
            check_upgrade_array(T, [Array#soul_world_array{lev = NewLev, upgrade_finish = 0, attr = get_add_attr(Aid, NewLev, Fc)} | Arrays], Role)
    end;
check_upgrade_array([Array | T], Arrays, Role) ->
    check_upgrade_array(T, [Array | Arrays], Role).

%% 获取升级封印所需时间
get_upgrade_time(Lev) ->
    case soul_world_data:get_array_by_lev(Lev) of
        {_, TimeNeed, Cost} ->
            {TimeNeed, Cost};
        _ ->
            over
    end.

get_pet_upgrade_time(Lev) ->
    case soul_world_data:get_pet_array(Lev) of
        Data when is_tuple(Data) andalso tuple_size(Data) =:= 9 ->
            {erlang:element(8, Data), [#loss{label = coin_all, val = erlang:element(9, Data)}]};
        _ ->
            over
    end.

%% 更新封印数据
update_array(0, Arrays, _) ->
    Arrays;
update_array(ArrayId, Arrays, Fc) ->
    case lists:keyfind(ArrayId, #soul_world_array.id, Arrays) of
        A = #soul_world_array{lev = Lev} ->
            NewAttr = get_add_attr(ArrayId, Lev, Fc),
            NewArrays = lists:keyreplace(ArrayId, #soul_world_array.id, Arrays, A#soul_world_array{fc = Fc, attr = NewAttr}),
            NewArrays;
        _ ->
            Arrays
    end.

%% 更新妖灵数据
update_spirit(Sp = #soul_world_spirit{id = Id, lev = ?soul_world_spirit_max_lev, quality = Quality, max_exp = MaxExp, magics = Magics}) ->
    case soul_world_data:get_upgrade(?soul_world_spirit_max_lev, Quality) of
        {0, 0} ->
            Sp#soul_world_spirit{exp = MaxExp};
        {_, BaseFc} ->
            SpFc = round(BaseFc * soul_world_data:get_spirit_factor(Id)),
            FinalFc = calc_magic_add(Magics, SpFc, SpFc),
            Sp#soul_world_spirit{exp = MaxExp, fc = FinalFc}
    end;
update_spirit(Sp = #soul_world_spirit{id = Id, lev = Lev, magics = Magics, quality = Quality, exp = Exp, max_exp = MaxExp}) when MaxExp > Exp ->
    case soul_world_data:get_upgrade(Lev, Quality) of
        {0, 0} ->
            Sp;
        {_, BaseFc} ->
            SpFc = round(BaseFc * soul_world_data:get_spirit_factor(Id)),
            FinalFc = calc_magic_add(Magics, SpFc, SpFc),
            Sp#soul_world_spirit{fc = FinalFc}
    end;
update_spirit(Sp = #soul_world_spirit{id = Id, quality = Quality, lev = Lev, max_exp = MaxExp, magics = Magics}) ->
    case soul_world_data:get_upgrade(Lev + 1, Quality) of
        {0, 0} -> 
            Sp#soul_world_spirit{exp = MaxExp};
        {BaseMaxExp, BaseFc} -> 
            SpFc = round(BaseFc * soul_world_data:get_spirit_factor(Id)),
            FinalFc = calc_magic_add(Magics, SpFc, SpFc),
            update_spirit(Sp#soul_world_spirit{lev = Lev + 1, max_exp = BaseMaxExp, fc = FinalFc});
        _ ->
            Sp
    end.

%% 更新法宝数据
update_magic(M = #soul_world_spirit_magic{type = 1, lev = Lev}) ->
    case soul_world_data:get_magic_by_lev(Lev) of
        {Fc, _Addtion, MaxLuck, _LuckPer, _Ratio} when Lev =:= ?soul_world_magic_max_lev ->
            M#soul_world_spirit_magic{fc = Fc, luck = MaxLuck, max_luck = MaxLuck};
        {Fc, _Addtion, MaxLuck, _LuckPer, _Ratio} ->
            M#soul_world_spirit_magic{fc = Fc, max_luck = MaxLuck};
        _ ->
            M
    end;
%% 类型二的法宝是加成
update_magic(M = #soul_world_spirit_magic{type = 2, lev = Lev}) ->
    case soul_world_data:get_magic_by_lev(Lev) of
        {_Fc, Addtion, MaxLuck, _LuckPer, _Ratio} when Lev =:= ?soul_world_magic_max_lev ->
            M#soul_world_spirit_magic{addition = Addtion, luck = MaxLuck, max_luck = MaxLuck};
        {_Fc, Addtion, MaxLuck, _LuckPer, _Ratio} ->
            M#soul_world_spirit_magic{addition = Addtion, max_luck = MaxLuck};
        _ ->
            M
    end;
update_magic(M) ->
    M.

%% 计算法宝加成效果
calc_magic_add([], _, NewFc) ->
    NewFc;
calc_magic_add([#soul_world_spirit_magic{type = 1, fc = MFc} | T], Fc, NewFc) ->
    calc_magic_add(T, Fc, NewFc + MFc);
calc_magic_add([#soul_world_spirit_magic{type = 2, addition = Addtion} | T], Fc, NewFc) ->
    calc_magic_add(T, Fc, NewFc + round(Fc * Addtion / 1000)).

calc_item_exp([], Exp) ->
    Exp;
calc_item_exp([{BaseId, Num} | T], Exp) ->
    case item_data:get(BaseId) of
        {ok, #item_base{feed_exp = FeedExp}} ->
            calc_item_exp(T, FeedExp * Num + Exp);
        _ ->
            calc_item_exp(T, Exp)
    end.

%% 生成召唤妖灵
make_spirits(_Type, _Excludes, 0, Calleds, BestColor, _) ->
    {Calleds, BestColor};
make_spirits(?soul_world_gold_call, Excludes, Num, Calleds, BestColor, Luck) ->
    {Quality, NewLuck} = case util:rand(1, 100) of
        R when R > 70 andalso Luck + 1 >= ?soul_world_gold_call_max_luck -> {4, Luck + 1};
        R when R > 77 andalso Luck + 1 >= ?soul_world_call_start_luck5 -> {4, Luck + 1};
        R when R > 88 andalso Luck + 1 >= ?soul_world_call_start_luck4 -> {4, Luck + 1};
        R when R > 93 andalso Luck + 1 >= ?soul_world_call_start_luck3 -> {4, Luck + 1};
        R when R > 96 andalso Luck + 1 >= ?soul_world_call_start_luck2 -> {4, Luck + 1};
        R when R > 98 andalso Luck + 1 >= ?soul_world_call_start_luck1 -> {4, Luck + 1};
        R when R > 45 -> {3,  Luck + 1};
        R when R > 14 -> {2,  Luck + 1};
        _ when Luck + 1 >= ?soul_world_call_start_luck6 -> {2, Luck + 1};
        _ -> {1, Luck + 1}
    end,
    Id = util:rand_list(soul_world_data:get_quality_ids(Quality)),
    NewColor = max(BestColor, Quality),
    case soul_world_data:get(Id) of
        One = #soul_world_spirit{} ->
            make_spirits(?soul_world_gold_call, [Id | Excludes], Num - 1, [One | Calleds], NewColor, NewLuck);
        _ ->
            ?DEBUG("无效ID:~w", [Id])
    end;
make_spirits(?soul_world_coin_call, Excludes, Num, Calleds, BestColor, Luck) ->
    {Quality, NewLuck} = case util:rand(1, 100) of
        R when R > 70 andalso Luck + 1 >= ?soul_world_coin_call_max_luck -> {3, Luck + 1};
        R when R > 77 andalso Luck + 1 >= ?soul_world_call_start_luck5 -> {3, Luck + 1};
        R when R > 88 andalso Luck + 1 >= ?soul_world_call_start_luck4 -> {3, Luck + 1};
        R when R > 93 andalso Luck + 1 >= ?soul_world_call_start_luck3 -> {3, Luck + 1};
        R when R > 96 andalso Luck + 1 >= ?soul_world_call_start_luck2 -> {3, Luck + 1};
        R when R > 98 andalso Luck + 1 >= ?soul_world_call_start_luck1 -> {3, Luck + 1};
        R when R > 55 -> {2, Luck + 1};
        _ when Luck + 1 >= ?soul_world_call_start_luck6 -> {2, Luck + 1};
        _ -> {1, Luck + 1}
    end,
    Id = util:rand_list(soul_world_data:get_quality_ids(Quality)),
    NewColor = max(Quality, BestColor),
    case soul_world_data:get(Id) of
        One = #soul_world_spirit{} ->
            make_spirits(?soul_world_coin_call, [Id | Excludes], Num - 1, [One | Calleds], NewColor, NewLuck);
        _ ->
            ?DEBUG("无效ID:~w", [Id])
    end.

%% 数据版本转换
update_ver([], Spirits) ->
    Spirits;
update_ver([H = #soul_world_spirit{array_id = ArrayId} | T], Spirits) ->
    case ArrayId of
        ?soul_world_array_workshop ->
            update_ver(T, [H#soul_world_spirit{array_id = 0} | Spirits]);
        _ ->
            update_ver(T, [H | Spirits])
    end;
update_ver([{soul_world_spirit, Id, Name, Lev, Quality, Exp, MaxExp, Fc, ArrayId, Generation, Magics} | T], Spirits) ->
    update_ver(T, [#soul_world_spirit{id = Id, name = Name, lev = Lev, quality = Quality, exp = Exp, max_exp = MaxExp, fc = Fc, array_id = ArrayId, generation = Generation, magics = Magics} | Spirits]);
update_ver([_H | T], Spirits) ->
    update_ver(T, Spirits).

%% @spec check_items_in_bag(ItemList, Items, BaseIdQList, IdQList) -> IdQList
%% ItemList = Items = BaseIdQList = IdQList = list()
%% @doc 检查喂养物品
check_items_in_bag([], _Items, BaseIdQList, IdQList) -> {BaseIdQList, IdQList};
check_items_in_bag([[Id, Num] | T], Items, BaseIdQList, IdQList) ->
    case storage:find(Items, #item.id, Id) of
        {ok, Item = #item{id = Id, base_id = BaseId, quantity = Q, type = ?soul_world_feed_item_type}} when Q > Num ->
            NewItems = lists:keyreplace(Item#item.id, #item.id, Items, Item#item{quantity = Q - Num}),
            check_items_in_bag(T, NewItems, [{BaseId, Num} | BaseIdQList], [{Id, Num} | IdQList]);
        {ok, Item = #item{id = Id, base_id = BaseId, quantity = Q, type = ?soul_world_feed_item_type}} when Q =:= Num ->
            NewItems = Items -- [Item],
            check_items_in_bag(T, NewItems, [{BaseId, Q} | BaseIdQList], [{Id, Q} | IdQList]);
        _ ->
            check_items_in_bag(T, Items, BaseIdQList, IdQList)
    end.

%% 妖灵融合时查找比较强的那个法宝
get_stronger_magics([], Magics) ->
    Magics;
get_stronger_magics([M = #soul_world_spirit_magic{type = Type, lev = Lev} | T], Magics) ->
    case lists:keyfind(Type, #soul_world_spirit_magic.type, Magics) of
        #soul_world_spirit_magic{lev = Lev2} when Lev > Lev2 ->
            get_stronger_magics(T, lists:keyreplace(Type, #soul_world_spirit_magic.type, Magics, M));
        _ ->
            get_stronger_magics(T, Magics)
    end.
    


%% 计算获得的属性值
%% 附加属性=基础数值*妖灵战力/1000*阵法系数				
get_add_attr(_Id, _Lev, 0) ->
    0;
%% 宠物阵特殊处理
get_add_attr(Id, Lev, _Fc) when Id >= ?soul_world_pet_array_start_id ->
    case soul_world_data:get_pet_array(Lev) of
        Data when is_tuple(Data) ->
            erlang:element(Id - ?soul_world_pet_array_start_id + 1, Data);
        _ ->
            0
    end;
get_add_attr(Id, Lev, Fc) ->
    BaseAttr = erlang:element(Id, ?soul_world_array_base_attr),
    case soul_world_data:get_array_by_lev(Lev) of
        {Addtion, _, _} ->
            round(BaseAttr * Fc / 1000 * ((Addtion / 1000) + 1));
        _ ->
            0
    end.
            


%% 增加攻击力
trans_attr(1, Val) ->
    {dmg, Val};
%% 增加气血上限
trans_attr(2, Val) ->
    {hp_max, Val};
%% 增加精神
trans_attr(3, Val) ->
    {js, Val};
%% 增加防御
trans_attr(4, Val) ->
    {defence, Val};
%% 增加法术伤害
trans_attr(5, Val) ->
    {dmg_magic, Val};
%% 增加抗性
trans_attr(6, Val) ->
    {resist_metal, Val};
trans_attr(7, Val) ->
    {resist_wood, Val};
trans_attr(8, Val) ->
    {resist_water, Val};
trans_attr(9, Val) -> 
    {resist_fire, Val};
trans_attr(10, Val) ->
    {resist_earth, Val};

%% 宠物阵部分
%% 增加气血上限
trans_attr(11, Val) ->
    {hp, Val};
%% 增加法术伤害
trans_attr(12, Val) ->
    {dmg_magic, Val};
%% 增加抗性
trans_attr(13, Val) ->
    {resist_metal, Val};
trans_attr(14, Val) ->
    {resist_wood, Val};
trans_attr(15, Val) ->
    {resist_water, Val};
trans_attr(16, Val) -> 
    {resist_fire, Val};
trans_attr(17, Val) ->
    {resist_earth, Val};

trans_attr(_Id, _Val) ->
    ?ERR("意外的封印数据 ~w", [{_Id, _Val}]).

%% 生成日志记录相关的描述
make_desc(feed, #soul_world_spirit{name = Name, lev = Lev, exp = Exp, fc = Fc}) ->
    util:fbin("妖灵：[~s], 等级：~w, 经验： ~w, 战力：~w", [Name, Lev, Exp, Fc]);
make_desc(upgrade_magic, #soul_world_spirit{name = Name, fc = Fc, magics = Magics}) ->
    F = fun(#soul_world_spirit_magic{type = 1, fc = MFc, luck = Luck, lev = Lev}) ->
            bitstring_to_list(util:fbin("{法宝：~s, 等级：~w, 幸运值： ~w, 加战力：~w}", [?L(<<"五蕊莲灯">>), Lev, Luck, MFc]));
        (#soul_world_spirit_magic{type = 2, addition = Addtion, luck = Luck, lev = Lev}) ->
            bitstring_to_list(util:fbin("{法宝：~s, 等级：~w, 幸运值： ~w, 加成值：~w}", [?L(<<"七彩葫芦">>), Lev, Luck, Addtion]));
        (_R) ->
            ""
    end,
    Val = string:join([F(One) || One <- Magics], ","),
    util:fbin("妖灵：[~s], 战力：~w, 法宝：[~s]", [Name, Fc, Val]);
make_desc(upgrade_array, #soul_world_array{id = Id, fc = Fc, attr = Attr, upgrade_finish = Finish}) ->
    util:fbin("封印id：[~w], 战力：~w, 附加属性：~w, 升级结束时间 ~w", [Id, Fc, Attr, Finish]);
make_desc(_, _) ->
    "未知数据".

%% 生成物品列表描述
item_to_desc([], Str) -> Str;
item_to_desc([{BaseId, Num} | T], Str) ->
    {ok, #item_base{name = Name}} = item_data:get(BaseId),
    NewS = util:fbin("[~sx~w]", [Name, Num]),
    item_to_desc(T, <<Str/binary, NewS/binary>>).

%% 是否消耗物品
get_loss_item([#loss{label = item, val = [Id, _, Num]} | T], Loss) ->
    get_loss_item(T, [{Id, Num} | Loss]);
get_loss_item([_H | T], Loss) ->
    get_loss_item(T, Loss);
get_loss_item(_, Loss) ->
    Loss.

%% calc_total_cost(ArrayLev, NewLev) -> {Coin, Gold}
%% 计算一键升级所需晶钻和金币
calc_total_cost(ArrayLev, NewLev) ->
    LowLv = ArrayLev div 7,
    HighNum = ArrayLev rem 7,
    LowNum = 7 - HighNum,
    {LowCoin, LowTime} = do_calc_cost(LowLv, NewLev, 0, 0),
    {HighCoin, HighTime} = do_calc_cost(LowLv + 1, NewLev, 0, 0),
    Gold = pay:price(?MODULE, fast_upgrade_array, (HighTime * HighNum + LowTime * LowNum)),
    {LowCoin * LowNum + HighCoin * HighNum, Gold}.

do_calc_cost(Lev, NewLev, Coin, Time) when Lev >= NewLev ->
    {Coin, Time};
do_calc_cost(Lev, NewLev, Coin, Time) ->
    case soul_world_data:get_pet_array(Lev + 1) of
        Data when is_tuple(Data) andalso tuple_size(Data) =:= 9 ->
            AddTime = erlang:element(8, Data), 
            AddCoin = erlang:element(9, Data),
            do_calc_cost(Lev + 1, NewLev, Coin + AddCoin, Time + AddTime);
        _ ->
            {Coin, Time}
    end.
