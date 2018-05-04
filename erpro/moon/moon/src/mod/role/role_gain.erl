%%----------------------------------------------------
%% 损益处理
%% @author yeahoo2000@gmail.com, yqhuang*
%%
%% 所有模块都统一对#gain.label和loss.label的描述
%%----------------------------------------------------
-module(role_gain).
-export([
        convert/1
        ,do/2
        ,do_misc/2
        ,recalc_npc_gain/2
        ,merge_gains/1
        ,separate_items/1
    ]
).
-include("common.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("attr.hrl").
-include("storage.hrl").
%%
-include("ratio.hrl").
-include("item.hrl").
-include("guild.hrl").
-include("activity.hrl").
-include("task.hrl").
-include("npc.hrl").
-include("achievement.hrl").
-include("pos.hrl").
-include("setting.hrl").
-include("energy.hrl").

%% @spec convert(Rec) -> NewRec
%% Rec = #gain{} | #loss{} | list()
%% NewRec = #gain{} | #loss{} | list()
%% @doc gain和loss互相转换，可同时处理多个 TODO:必须保证gain，loss是成对出现的，且参数格式要一致
convert(Rec = #gain{}) ->
    [_ | V] = tuple_to_list(Rec),
    list_to_tuple([loss | V]);
convert(Rec = #loss{}) ->
    [_ | V] = tuple_to_list(Rec),
    list_to_tuple([gain | V]);
convert(Rec) when is_list(Rec) ->
    do_convert(Rec, []).
do_convert([], L) -> L;
do_convert([H | T], L) ->
    do_convert(T, [convert(H) | L]).

%%触发任务 目前世界树用到
do_special(Misc = [{task, TaskId}], Role) ->
    case task:accept_chain(#task_param_accept{role = Role, task_id = TaskId}) of
        {ok, #task_param_accept{role = Role2}} ->
            {ok, Role2};
        _ ->
            {false, Misc}
    end;
do_special(Misc, _Role) ->
    {false, Misc}.

%% @spec do(GainLoss, Role) -> {ok, NewRole} | {ok, NewRole, {AddList, DelList, RefList}} | {false, #gain{}} | {false, #loss{}}
%% GainLoss = list() | #gain{} | #loss{}
%% Role = NewRole = #role{}
%% @doc 处理损益数据
%% <div>注意：处理单个损益数据时，如果操作物品损益，注意返回值的不同</div>
do([], Role) -> 
    {ok, Role};
do(List, Role = #role{lev = Lev}) when is_list(List) ->
    put(item_del, undefined),
    Result = case do_refresh(List, Role, [], Role) of
        {ok, NewRole = #role{lev = Lev}} -> 
            {ok, role_listener:coin(NewRole, NewRole#role.assets#assets.coin - Role#role.assets#assets.coin)};
        {ok, Role0 = #role{id = {_Rid, SrvId}, hp_max = HpMax, mp_max = MpMax, account = Account, name = Name, link = #link{conn_pid = ConnPid}}} -> %% 升级
            Role1 = Role0#role{hp = HpMax, mp = MpMax},
            Role2 = role_listener:lev_up(Role1),
            Role3 = role_api:push_attr(Role2),
            map:role_update(Role3), %% 升级广播,跨进程,不可回滚
            arena_career_mgr:sign(Role3),
            notice:send_interface({connpid, ConnPid}, 6, Account, SrvId, Name, <<"">>, []),
            log:log(log_role_up_lev, Role3), %% 升级日志
            {ok, role_listener:coin(Role3, Role3#role.assets#assets.coin - Role#role.assets#assets.coin)};
        Else -> Else
    end,
    
    List1 = [E || E <- List, is_record(E, gain)],
    case {length(List1) > 0, Result} of
        {true, {ok, Role4}} ->
            Role7 = lists:foldl(fun(#gain{misc = Misc}, Role5) ->
                        case do_special(Misc, Role5) of
                            {ok, Role6} ->
                                Role6;
                            _ ->
                                Role5
                        end
                end, Role4, List1),
            {ok, Role7};
        {_, Other} ->
            Other
    end;

%% 普通经验 ---
do(#gain{label = exp, val = Val}, Role = #role{pid = Pid, name = Name, lev = Lev, assets = Assets = #assets{exp = Exp, seal_exp = SealExp}, setting = Setting = #setting{exp_seal = ExpSeal}}) when Val < ?SINGLE_EXP ->
    {NewVal, NewExpSeal, NewSealExp} = setting:handle_exp_seal(ExpSeal, SealExp, Val, Pid),
    Role1 = demon:gain_exp(NewVal, Role),
    {NewLev, NewExp} = can_upgrade(Lev, Exp, NewVal),
    check_update_role_online(Name, Lev, NewLev),
    {ok, Role1#role{lev = NewLev, assets = Assets#assets{exp = NewExp, seal_exp = NewSealExp}, setting = Setting#setting{exp_seal = NewExpSeal}}};
do(#gain{label = exp, val = Val}, Role = #role{pid = Pid, name = Name, lev = Lev, assets = Assets = #assets{exp = Exp, seal_exp = SealExp}, setting = Setting = #setting{exp_seal = ExpSeal}}) ->
    %% TODO: 超限日志预警
    {NewVal, NewExpSeal, NewSealExp} = setting:handle_exp_seal(ExpSeal, SealExp, Val, Pid),
    Role1 = demon:gain_exp(NewVal, Role),
    {NewLev, NewExp} = can_upgrade(Lev, Exp, NewVal),
    check_update_role_online(Name, Lev, NewLev),
    {ok, Role1#role{lev = NewLev, assets = Assets#assets{exp = NewExp, seal_exp = NewSealExp}, setting = Setting#setting{exp_seal = NewExpSeal}}};
do(#loss{label = exp, val = Val}, Role = #role{assets = Assets = #assets{exp = Exp}}) when Val >= 0 ->
    V = case Exp < Val of
        true -> 0;
        false -> Exp - Val
    end,
    {ok, Role#role{assets = Assets#assets{exp = V}}};

%% 灵力
do(#gain{label = psychic, val = Val}, Role = #role{assets = Assets = #assets{psychic = Psychic}}) when Val >= ?SINGLE_PSYCHIC ->
    %% TODO: 超限日志预警
    {ok, Role#role{assets = Assets#assets{psychic = Psychic + Val}}};
do(#gain{label = psychic, val = _Val}, Role = #role{assets = #assets{psychic = Psychic}}) when Psychic >= ?MAX_PSYCHIC ->
    {ok, Role};
do(#gain{label = psychic, val = Val}, Role = #role{assets = Assets = #assets{psychic = Psychic}}) ->
    {ok, Role#role{assets = Assets#assets{psychic = Psychic + Val}}};
do(L = #loss{label = psychic, val = Val}, Role = #role{assets = Assets = #assets{psychic = Psychic}}) when Val >= 0 ->
    case Psychic < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{psychic = Psychic - Val}}}
    end;

%% 经验百分比操作
do(L = #loss{label = exp_per, val = Val}, Role = #role{assets = Assets = #assets{exp = Exp}}) when Val >= 0 ->
    V = erlang:round(Val * Exp / 100),
    case Exp < V of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{exp = Exp - V}}}
    end;

%% 灵力百分比操作
do(L = #loss{label = psychic_per, val = Val}, Role = #role{assets = Assets = #assets{psychic = Psychic}}) when Val >= 0 ->
    V = erlang:round(Val * Psychic / 100),
    case Psychic < V of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{psychic = Psychic - V}}}
    end;

%% 打怪经验 --- TODO:未计算战斗结算面板
do(#gain{label = exp_npc}, Role = #role{lev = Lev, career = ?career_xinshou}) when Lev >= 11 ->
    {ok, Role};
do(#gain{label = exp_npc, val = Val}, Role = #role{lev = Lev, assets = Assets = #assets{exp = Exp}, ratio = #ratio{exp = ExpPer}}) ->
    ExpAdd = erlang:trunc(Val * ExpPer / 100), %% 结算经验加成
    Role1 = demon:gain_exp(ExpAdd, Role),
    {NewLev, NewExp} = can_upgrade(Lev, Exp, ExpAdd),
    {ok, Role1#role{lev = NewLev, assets = Assets#assets{exp = NewExp}}};

%% 打怪灵力
do(#gain{label = psychic_npc, val = Val}, Role = #role{assets = Assets = #assets{psychic = Psychic}, ratio = #ratio{psychic = PsyPer}}) ->
    PsyAdd = erlang:trunc(Val * PsyPer / 100), %% 计算灵力加成
    {ok, Role#role{assets = Assets#assets{psychic = Psychic + PsyAdd}}};

%% 晶钻
do(#gain{label = gold, val = Val}, Role = #role{assets = Assets = #assets{gold = Gold}}) ->
    NRole = Role#role{assets = Assets#assets{gold = Gold + Val}},
    %NR1 = vip:listener(Val, NRole), 
    NR2 = medal:listener(wing, NRole),
    random_award:gold(NR2, Gold + Val),
    {ok, NR2};
do(L = #loss{label = gold, val = Val}, Role = #role{assets = Assets = #assets{gold = Gold}}) when Val >= 0 ->
    case Gold < Val of
        true -> {false, L#loss{err_code = ?gold_less}};
        false -> {ok, Role#role{assets = Assets#assets{gold = Gold - Val}}}
    end;

%% 绑定晶钻
do(#gain{label = gold_bind, val = _Val}, Role = #role{assets = #assets{gold_bind = Gold}}) when Gold >= ?MAX_GOLD ->
    {ok, Role};
do(#gain{label = gold_bind, val = Val}, Role = #role{assets = Assets = #assets{gold_bind = Gold}}) ->
    {ok, Role#role{assets = Assets#assets{gold_bind = Gold + Val}}};
do(L = #loss{label = gold_bind, val = Val}, Role = #role{assets = Assets = #assets{gold_bind = Gold}}) when Val >= 0 ->
    case Gold < Val of
        true -> {false, L#loss{err_code = ?gold_bind_less}};
        false -> {ok, Role#role{assets = Assets#assets{gold_bind = Gold - Val}}}
    end;

%% 金币
do(#gain{label = coin, val = Val}, Role = #role{assets = Assets = #assets{coin = Coin}}) when Val >= ?SINGLE_COIN ->
    %% TODO: 超限日志预警
    {ok, Role#role{assets = Assets#assets{coin = Coin + Val}}};
do(#gain{label = coin, val = _Val}, Role = #role{assets = #assets{coin = Coin}}) when Coin >= ?MAX_COIN ->
    {ok, Role};
do(#gain{label = coin, val = Val}, Role = #role{assets = Assets = #assets{coin = Coin}}) ->
    NRole = Role#role{assets = Assets#assets{coin = Coin + Val}},
    NR = medal:listener(coin, NRole),
    random_award:coin(NR, Coin + Val),
    {ok, NR};
do(L = #loss{label = coin, val = Val}, Role = #role{assets = Assets = #assets{coin = Coin}}) when Val >= 0 ->
    case Coin < Val of
        true -> {false, L#loss{err_code = ?coin_less}};
        false -> {ok, Role#role{assets = Assets#assets{coin = Coin - Val}}}
    end;

%% 绑定金币
do(#gain{label = coin_bind, val = Val}, Role = #role{assets = Assets = #assets{coin_bind = Coin}}) when Val >= ?SINGLE_COIN_BIND ->
    %% TODO: 超限日志预警
    {ok, Role#role{assets = Assets#assets{coin_bind = Coin + Val}}};
do(#gain{label = coin_bind, val = _Val}, Role = #role{assets = #assets{coin_bind = Coin}}) when Coin >= ?MAX_COIN_BIND ->
    {ok, Role};
do(#gain{label = coin_bind, val = Val}, Role = #role{assets = Assets = #assets{coin_bind = Coin}}) ->
    {ok, Role#role{assets = Assets#assets{coin_bind = Coin + Val}}};
do(L = #loss{label = coin_bind, val = Val}, Role = #role{assets = Assets = #assets{coin_bind = Coin}}) when Val >= 0 ->
    case Coin < Val of
        true -> {false, L#loss{err_code = ?coin_bind_less}};
        false -> {ok, Role#role{assets = Assets#assets{coin_bind = Coin - Val}}}
    end;

%% 先扣绑定金币，再扣非绑定金币
do(L = #loss{label = coin_all, val = Val}, Role = #role{assets = Assets = #assets{coin_bind = CoinBind, coin = Coin}}) when Val >= 0 ->
    case Val > Coin + CoinBind of
        true -> {false, L#loss{err_code = ?coin_all_less}};
        false ->
            DiffBind = CoinBind - Val,  %% 先扣绑定铜
            case DiffBind >= 0 of %% DiffBind可能为负数
                true -> {ok, Role#role{assets = Assets#assets{coin_bind = DiffBind}}};
                false -> {ok, Role#role{assets = Assets#assets{coin_bind = 0, coin = Coin + DiffBind}}}
            end
    end;

%% 先扣绑定晶钻，再扣非绑定晶钻
do(L = #loss{label = gold_all, val = Val}, Role = #role{assets = Assets = #assets{gold_bind = GoldBind, gold = Gold}}) when Val >= 0 ->
    case Val > Gold + GoldBind of
        true -> {false, L#loss{err_code = ?gold_all_less}};
        false ->
            DiffBind = GoldBind - Val,  %% 先扣绑定晶钻
            case DiffBind >= 0 of %% DiffBind可能为负数
                true -> {ok, Role#role{assets = Assets#assets{gold_bind = DiffBind}}};
                false -> {ok, Role#role{assets = Assets#assets{gold_bind = 0, gold = Gold + DiffBind}}}
            end
    end;

%% 符石
do(#gain{label = stone, val = Val}, Role = #role{assets = Assets = #assets{stone = Stone}}) ->
    {ok, Role#role{assets = Assets#assets{stone = Stone + Val}}};
do(L = #loss{label = stone, val = Val}, Role = #role{assets = Assets = #assets{stone = Stone}}) when Val >= 0 ->
    case Stone < Val of
        true -> {false, L#loss{err_code = ?coin_bind_less}};
        false -> {ok, Role#role{assets = Assets#assets{stone = Stone - Val}}}
    end;

%% 扣除传音次数 @author liuweihua
do(L = #loss{label = hearsay, val = Val}, Role = #role{assets = Assets = #assets{hearsay = Hearsay}}) when Val >= 0 ->
    case Val > Hearsay of
        true -> {false, L};
        false ->
            {ok, Role#role{assets = Assets#assets{hearsay = Hearsay - Val}}}
    end;

%% 荣誉值
do(#gain{label = honor, val = Val}, Role = #role{assets = Assets = #assets{honor = Honor}}) ->
    NRole = Role#role{assets = Assets#assets{honor = Honor + Val}},
    NRole1 = medal_compete:check_medal(NRole, compete_2v2, {0, 0}),
    {ok, NRole1};
do(L = #loss{label = honor, val = Val}, Role = #role{assets = Assets = #assets{honor = Honor}}) when Val >= 0 ->
    case Honor < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{honor = Honor - Val}}}
    end;

%% 纹章值
do(#gain{label = badge, val = Val}, Role = #role{assets = Assets = #assets{badge = Badge}}) ->
    {ok, Role#role{assets = Assets#assets{badge = Badge + Val}}};

do(L = #loss{label = badge, val = Val}, Role = #role{assets = Assets = #assets{badge = Badge}}) when Val >= 0 ->
    case Badge < Val of 
        true -> {false, L};
        false ->
            {ok, Role#role{assets = Assets#assets{badge = Badge - Val}}}
    end;

%% 体力值
do(#gain{label = energy, val = Val}, Role = #role{assets = Assets = #assets{energy = Energy}}) when Val >= ?SINGLE_ENERGY ->
    %%TODO: 超限日志预警
    {ok, Role#role{assets = Assets#assets{energy = Energy + Val}}};
do(#gain{label = energy, val = Val}, Role = #role{assets = Assets = #assets{energy = Energy}}) ->
    Role1 = 
    case Energy + Val >= ?max_energy of
        true ->
            energy:clear_recover_info(Role);
        false ->
            Role
    end,
    {ok, Role1#role{assets = Assets#assets{energy = Energy + Val}}};
do(L = #loss{label = energy, val = Val}, Role = #role{assets = Assets = #assets{energy = Energy}}) when Val >= 0 ->
    case Energy < Val of
        true -> {false, L};
        false -> 
            NewRole = Role#role{assets = Assets#assets{energy = Energy - Val}},
            NewRole1 = energy:try_reset_auto_timer(NewRole),
            {ok, NewRole1}
    end;

%% 阅历值
do(#gain{label = attainment, val = Val}, Role = #role{assets = Assets = #assets{attainment = Attainment}}) when Val >= ?SINGLE_ATTAINMENT ->
    %%TODO: 超限日志预警
    Role1 = role_listener:special_event(Role, {20004, Attainment + Val}),
    NewRole = Role1#role{assets = Assets#assets{attainment = Attainment + Val}},
    {ok, NewRole};
do(#gain{label = attainment, val = _Val}, Role = #role{assets = #assets{attainment = Attainment}}) when Attainment >= ?MAX_ATTAINMENT ->
    {ok, Role};
do(#gain{label = attainment, val = Val}, Role = #role{assets = Assets = #assets{attainment = Attainment}}) ->
    Role1 = role_listener:special_event(Role, {20004, Attainment + Val}),
    NewRole = Role1#role{assets = Assets#assets{attainment = Attainment + Val}},
    {ok, NewRole};
do(L = #loss{label = attainment, val = Val}, Role = #role{assets = Assets = #assets{attainment = Attainment}}) when Val >= 0 ->
    case Attainment < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{attainment = Attainment - Val}}}
    end;

%% 魅力值
do(#gain{label = charm, val = Val}, Role = #role{assets = Assets = #assets{charm = Charm}}) ->
    NewRole = Role#role{assets = Assets#assets{charm = Charm + Val}},
    {ok, NewRole};
do(L = #loss{label = charm, val = Val}, Role = #role{assets = Assets = #assets{charm = Charm}}) when Val >= 0 ->
    case Charm < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{charm = Charm - Val}}}
    end;

%% 送花积分
do(#gain{label = flower, val = Val}, Role = #role{assets = Assets = #assets{flower = Flower}}) ->
    NewRole = Role#role{assets = Assets#assets{flower = Flower + Val}},
    {ok, NewRole};
do(L = #loss{label = flower, val = Val}, Role = #role{assets = Assets = #assets{flower = Flower}}) when Val >= 0 ->
    case Flower < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{flower = Flower - Val}}}
    end;

%% 仙道历练
do(#gain{label = lilian, val = Val}, Role = #role{assets = Assets = #assets{lilian = LL}}) ->
    NewRole = Role#role{assets = Assets#assets{lilian = LL + Val}},
    NewRole1 = role_listener:acc_event(NewRole, {135, Val}), %%仙道历练积分    
    {ok, NewRole1};
do(L = #loss{label = lilian, val = Val}, Role = #role{assets = Assets = #assets{lilian = LL}}) when Val >= 0 ->
    case LL < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{lilian = LL - Val}}}
    end;

%% 活跃值
do(#gain{label = activity, val = Val}, Role = #role{activity = Act = #activity{summary = Summary, sum_limit = Limit}}) ->
    NewSummary = case Summary + Val > Limit of
                true -> Limit; 
                false -> Summary + Val
    end,
    NewRole = Role#role{activity = Act#activity{summary = NewSummary}},
    {ok, NewRole};
do(L = #loss{label = activity, val = Val}, Role = #role{activity = Act = #activity{summary = Summary}}) when Val >= 0 ->
    case Summary < Val of
        true -> {false, L};
        false -> {ok, Role#role{activity = Act#activity{summary = Summary - Val}}}
    end;

%% 龙鳞
do(#gain{label = scale, val = Val}, Role = #role{assets = Assets = #assets{scale = Scale}}) ->
    {ok, Role#role{assets = Assets#assets{scale = Scale + Val}}};
do(L = #loss{label = scale, val = Val}, Role = #role{assets = Assets = #assets{scale = Scale}}) when Val >= 0 ->
    case Scale < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{scale = Scale - Val}}}
    end;

%% 合作值
do(#gain{label = cooperation, val = Val}, Role = #role{assets = Assets = #assets{cooperation = Cooperation}}) ->
    {ok, Role#role{assets = Assets#assets{cooperation = Cooperation + Val}}};


%% 妖精碎片
do(#gain{label = fragile, val = [BaseId, Num]}, Role) ->
    ?DEBUG("**** 获得妖精碎片 ~w ~w", [BaseId, Num]),
    demon:gain_debris(Role, [{BaseId, Num}]);

do(#loss{label = fragile, val = [BaseId, Num]}, Role) ->
    ?DEBUG("**** 消耗妖精碎片 ~w ~w", [BaseId, Num]),
    demon:loss_debris(Role, [{BaseId, Num}]);

%% 获得矿石物品
do(G = #gain{label = c_item, val = [BaseId, Bind, Quantity]}, Role = #role{collect = Collect}) ->
    case item:make(BaseId, Bind, Quantity) of
        {ok, [Item | T]} ->
            case collect:addItem(Collect, [Item | T]) of
                {ok, NewCollect, NewItems} ->
                    NewRole = role_listener:get_item(Role, Item),
                    {ok, NewRole#role{collect = NewCollect}, {?storage_collect, NewItems, [], []}};
                {false, Reason} -> {false, G#gain{msg = Reason}}
            end;
        _ ->
            ?ELOG("奖励矿石物品时发生异常:无法生成矿石物品[BaseId: ~w]", [BaseId]),
            {false, G}
    end;
do(L = #loss{label = c_item, val = [BaseId, _Bind, Quantity]}, Role = #role{collect = Collect}) ->
    case storage:del(Collect, BaseId, Quantity, [], []) of
        false -> {false, L}; 
        {ok, NewCollect, DelList, FreshList} ->
            {ok, Role#role{collect = NewCollect}, {?storage_collect, [], DelList, FreshList}}
    end;

%% 先从采集背包删除，如不成功再从背包上删除
do(L = #loss{label = cn_item, val = [BaseId, _Bind, Quantity]}, Role = #role{collect = Collect}) ->
    case storage:del(Collect, BaseId, Quantity, [], []) of
        false -> 
            do(L#loss{label = item}, Role);
        {ok, NewCollect, DelList, FreshList} ->
            {ok, Role#role{collect = NewCollect}, {?storage_collect, [], DelList, FreshList}}
    end;

%% 获得物品
do(G = #gain{label = item, val = [BaseId, Bind, Quantity]}, Role = #role{}) ->
    case dress:is_dress(BaseId) of
        true ->
            case item:make(BaseId, Bind, Quantity) of
                {ok, [Item = #item{special = Spec}]} ->
                    {ok, #item_base{effect = Effect}} = item_data:get(BaseId),
                    Effect1 = [A || A = {Label, _F, _V} <- Effect, Label =/= ?attr_looks_id],
                    Item1 = Item#item{special = [{?special_expire_time, -1} | Spec], attr = Effect1, durability = util:unixtime()},
                    {_Id, Role1} = dress:add_dress(Item1, Role),
                    dress:pack_send_dress_info(Role1),
                    {ok, Role1};
                {false, _} ->
                    {false, #gain{err_code = ?gain_item_error}}
            end;
        false ->
            case item:make(BaseId, Bind, Quantity) of
                {ok, [Item | T]} ->
                    {NRole, NItem} = storage:deal_pet_eqm(Role, Item),
                    case storage:add_no_refresh(NRole#role.bag, [NItem | T]) of
                        {ok, NewBag, NewItems} ->
                            NewRole = role_listener:get_item(NRole#role{bag = NewBag}, NItem),
                            NewRole1 = medal:listener(item, NewRole, {BaseId, Quantity}),
                            random_award:item(NewRole1, BaseId, Quantity),
                            {ok, NewRole1, {?storage_bag, NewItems, [], []}};
                        false -> {false, G#gain{err_code = ?gain_bag_full, msg = ?L(<<"背包已满,无法增加">>)}}
                    end;
                _ ->
                    ?ELOG("Name:~s 奖励物品时发生异常:无法生成物品[BaseId: ~w]", [Role#role.name, BaseId]),
                    {false, G#gain{err_code = ?gain_item_error}}
            end
    end;

%% 按照BaseID扣除物品
do(L = #loss{label = item, val = [BaseId, _Bind, Quantity]}, Role = #role{bag = Bag}) ->
    case item_data:get(BaseId) of
        {ok, #item_base{}} ->
            case storage:del(Bag, BaseId, Quantity, [], []) of
                false -> {false, L}; 
                {ok, NewStorage, DelList, FreshList} ->
                    {ok, Role#role{bag = NewStorage}, {?storage_bag, [], DelList, FreshList}}
            end;
        _ -> {false, L}
    end;

%% 按照BaseId扣除一组背包物品，其中List=[{BaseId, Bind, Quantity}, ...]
do(L = #loss{label = items, val = List}, Role = #role{bag = Bag}) ->
    TmpList = [{Id, Quantity} || {Id, _, Quantity} <- List],
    case storage:del(Bag, TmpList) of
        false -> {false, L}; 
        {ok, NewBag, DelList, FreshList} -> {ok, Role#role{bag = NewBag}, {?storage_bag, [], DelList, FreshList}}
    end;

%% 按照BaseId扣除一组背包物品，其中List=[{BaseId, Quantity}, ...]
do(L = #loss{label = itemsall, val = List}, Role = #role{bag = Bag}) ->
    TmpList = [{Id, Quantity} || {Id, Quantity} <- List],
    case storage:del(Bag, TmpList) of
        false -> {false, L}; 
        {ok, NewBag, DelList, FreshList} -> {ok, Role#role{bag = NewBag}, {?storage_bag, [], DelList, FreshList}}
    end;

%% 按照BaseId优先扣除绑定的背包物品,不足时再扣除非绑定,其中List=[{BaseId, Quantity}|..]
do(L = #loss{label = items_bind_fst, val = List}, Role = #role{bag = Bag}) ->
    case storage:get_del_base_bindlist(Role, List, [], []) of
        {false, R} -> {false, L#loss{msg = R}};
        {ok, Del, _} ->
            case storage:del_item_by_id(Bag, Del, true) of
                false -> {false, L};
                {ok, NewBag, DelList, FreshList} -> {ok, Role#role{bag = NewBag}, {?storage_bag, [], DelList, FreshList}}
            end
    end;

%% 按照BaseId优先扣除非绑定的背包物品,不足时再扣除绑定,其中List=[{BaseId, Quantity}|..]
do(L = #loss{label = items_ubind_fst, val = List}, Role = #role{bag = Bag}) ->
    case storage:get_del_base_ubindlist(Role, List, [], []) of
        {false, R} -> {false, L#loss{msg = R}};
        {ok, Del, _} ->
            case storage:del_item_by_id(Bag, Del, true) of
                false -> {false, L};
                {ok, NewBag, DelList, FreshList} -> {ok, Role#role{bag = NewBag}, {?storage_bag, [], DelList, FreshList}}
            end
    end;

%% 按ItemID扣除一组背包物品
%% List = [{ItemId, Num} | ...]
do(L = #loss{label = item_id, val = List}, Role = #role{bag = Bag}) ->
    case storage:del_item_by_id(Bag, List, true) of
        {false, R} -> {false, L#loss{msg = R}}; 
        {ok, NewBag, DelList, FreshList} -> {ok, Role#role{bag = NewBag}, {?storage_bag, [], DelList, FreshList}}
    end;

%% 选择损益物品
do(#gain{label = item_random, val = ItemList, msg = Msg}, Role) ->
    L = length(ItemList),
    case L > 0 of
        true ->
            Item = lists:nth(random:uniform(L), ItemList),
            role_gain:do(#gain{label = item, val = Item, msg = Msg},Role);
        false ->
            {ok, Role}
    end;
do(#loss{label = item_random, val = ItemList, msg = Msg}, Role) ->
    L = length(ItemList),
    case L > 0 of
        true ->
            Item = lists:nth(random:uniform(L), ItemList),
            role_gain:do(#loss{label = item, val = Item, msg = Msg}, Role);
        false ->
            {ok, Role}
    end;

%% 按职业类型奖励或扣除物品
do(G = #gain{label = item_career, val = CarItemList, msg = Msg}, Role = #role{career = RCareer}) ->
    case lists:keyfind(RCareer, 1, CarItemList) of
        false -> {false, G};
        Item ->
            {_Career, [ItemBaseId, Bind, Quantity]} = Item,
            case item:main_type(ItemBaseId) =:= ?item_equip of
                true -> 
                    {ok, Role}; %% 过滤掉装备
                    %case eqm:puton_init_eqm(ItemBaseId, Role) of 
                    %    {ok, Role1} ->
                    %        {ok, Role1};
                    %    {false, _Reason} ->
                    %        ?DEBUG("新手装备失败: ~p", [_Reason]),
                    %        role_gain:do(#gain{label = item, val = [ItemBaseId, Bind, Quantity], msg = Msg}, Role)
                    %end;
                false ->
                    role_gain:do(#gain{label = item, val = [ItemBaseId, Bind, Quantity], msg = Msg}, Role)
            end
    end;
do(L = #loss{label = item_career, val = CarItemList, msg = Msg}, Role = #role{career = RCareer}) ->
    case lists:keyfind(RCareer, 1, CarItemList) of
        false -> {false, L};
        Item ->
            role_gain:do(#loss{label = item, val = Item, msg = Msg}, Role)
    end;

%% 按优先级扣除物品
do(#loss{label = item_first, val = ItemList, msg = Msg}, Role) ->
    %% TODO: 判断角色背包上是否有该物品
    [Item | _] = ItemList, %% tast code
    role_gain:do(#loss{label = item, val = Item, msg = Msg}, Role);

%% 手动扣除物品 
do(#loss{label = action_item}, Role) ->
    %% 啥也不干
    {ok, Role};

%% 扣除不同物品，获得不同的资产值
do(#gain{label = item_quality_assets, val = [[-1, _Quantity, {Assets, Val}] | _T]}, Role) ->
    Gain = case Assets of
        exp  -> #gain{label = exp, val = Val};
        gold -> #gain{label = gold, val = Val};
        gold_bind -> #gain{label = gold_bind, val = Val};
        coin -> #gain{label = coin, val = Val};
        coin_bind -> #gain{label = coin_bind, val = Val};
        psychic -> #gain{label = psychic, val = Val};
        honor -> #gain{label = honor, val = Val};
        energy -> #gain{label = energy, val = Val};
        attainment -> #gain{label = attainment, val = Val};
        _ -> #gain{label = exp, val = Val}
    end,
    do([Gain], Role);
do(G = #gain{label = item_quality_assets, val = [[ItemBaseId, Quantity, {Assets, Val}] | T]}, Role = #role{bag = Bag}) ->
    case storage:count(Bag, ItemBaseId) >= Quantity of
        true ->
            LossItem = #loss{label = item, val =  [ItemBaseId, 9, Quantity]},
            Gain = case Assets of
                exp  -> #gain{label = exp, val = Val};
                gold -> #gain{label = gold, val = Val};
                gold_bind -> #gain{label = gold_bind, val = Val};
                coin -> #gain{label = coin, val = Val};
                coin_bind -> #gain{label = coin_bind, val = Val};
                psychic -> #gain{label = psychic, val = Val};
                honor -> #gain{label = honor, val = Val};
                energy -> #gain{label = energy, val = Val};
                attainment -> #gain{label = attainment, val = Val};
                _ -> #gain{label = exp, val = Val}
            end,
            do([LossItem, Gain], Role);
        false ->
            do(G#gain{val = T}, Role)
    end;
do(G = #gain{label = item_quality_exp, val = []}, _Role) ->
    {false, G};

%% 获得一个宠物
do(#gain{label = pet, val = BaseId}, Role) ->
    NewRole = pet:task_reward(Role, BaseId),
    {ok, NewRole};

%% 竞技场积分
do(#gain{label = arena, val = Val}, Role = #role{assets = Assets = #assets{arena = Arena, acc_arena = AccArena}}) ->
    NewRole = Role#role{assets = Assets#assets{arena = Arena + Val, acc_arena = AccArena + Val}},
    catch rank:listener(vie_acc, NewRole),
    {ok, NewRole};
do(L = #loss{label = arena, val = Val}, Role = #role{assets = Assets = #assets{arena = Arena}}) when Val >= 0 ->
    case Arena < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{arena = Arena - Val}}}
    end;

%% 帮会贡献获得
do(#gain{label = guild_devote, val = Val}, Role = #role{guild = #role_guild{devote = De, donation = Do, day_donation = #day_donation{donation = Donation}}}) ->
    guild:gain(Val, Role), %% 帮会获得贡献
    NewDo = Do + Val,
    %% ?DEBUG("更新可用帮会贡献为======================>>~p~n", [De + Val]),
    Role1 = guild_role:alters([{devote, De + Val}, {donation, NewDo}, {day_donation, #day_donation{donation=Donation+Val, timestamp=util:unixtime()}}], Role),
    Role2 = role_listener:special_event(Role1, {20005, NewDo}),
    Role3 = role_listener:acc_event(Role2, {138, Val}), %% 帮贡累计
    NewRole = role_listener:special_event(Role3, {1045, Val}), %% 获得指点数值的帮会贡献
    {ok, NewRole};

%% 帮会贡献获得，不会增加帮会资金，比如归还帮会贡献给角色
do(#gain{label = guild_devote_role, val = Val}, Role = #role{guild = #role_guild{devote = De}}) ->
    NewRole = guild_role:alters([{devote, De + Val}], Role),
    {ok, NewRole};

%% 帮贡扣取
do(L = #loss{label = guild_devote, val = Val}, Role = #role{guild = #role_guild{devote = De}}) ->
    %% ?DEBUG("==============  玩家当前团项:~p, 要扣除的团贡:~p~n", [De, Val]),
    case Val =< De of
        false ->
            {false, L};
        true ->
            NewRole = guild_role:alter(devote, De - Val, Role),
            {ok, NewRole}
    end;

%% 师门贡献 
do(#gain{label = career_devote, val = Val}, Role = #role{assets = Assets = #assets{career_devote = CareerDevote}}) ->
    NewRole = Role#role{assets = Assets#assets{career_devote = CareerDevote + Val}},
    {ok, NewRole};
do(L = #loss{label = career_devote, val = Val}, Role = #role{assets = Assets = #assets{career_devote = CareerDevote}}) ->
    case CareerDevote < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{career_devote = CareerDevote - Val}}}
    end;

%% 任务系统专属:扣除指定的任务进程中的随机物品 
do(#loss{label = trace_item_random, val = TaskId, msg = Msg}, Role = #role{task = TaskList}) ->
    case lists:keyfind(TaskId, #task.task_id, TaskList) of
        #task{progress = ProgList} ->
            case lists:keyfind(get_item, #task_progress.trg_label, ProgList) of
                #task_progress{target = Target, target_value = TargetVal} ->
                    role_gain:do(#loss{label = item, val = [Target, 0, TargetVal], msg = Msg}, Role);
                _ -> {ok, Role}
            end;
        _ -> {ok, Role}
    end;

%% 任务系统:根据概率信息产出
do(G = #gain{label = task_gain_prog, val = {Key, Lev, Bind, Quantity}, msg = Msg}, Role) ->
    case task:task_gain_prog({Key, Lev}) of
        {false, _Reason} -> {false, G};
        ItemBaseId -> role_gain:do(#gain{label = item, val = [ItemBaseId, Bind, Quantity], msg = Msg}, Role)
    end;

%% 发放成就值
do(#gain{label = achievement, val = Val}, Role = #role{achievement = Ach = #role_achievement{value = N}}) ->
    {ok, Role#role{achievement = Ach#role_achievement{value = N + Val}}};

%% 发放称号
do(#gain{label = honor_name, val = {HonorId, HonorName, Time}}, Role = #role{achievement = Ach = #role_achievement{honor_all = Honors}}) ->
    case lists:keyfind(HonorId, 1, Honors) of
        false ->
            {ok, Role#role{achievement = Ach#role_achievement{honor_all = [{HonorId, util:to_binary(HonorName), Time} | Honors]}}};
        _ ->
            {ok, Role}
    end;
do(#gain{label = honor_name, val = HonorId}, Role = #role{achievement = Ach = #role_achievement{honor_all = Honors}}) ->
    case lists:keyfind(HonorId, 1, Honors) of
        false ->
            {ok, Role#role{achievement = Ach#role_achievement{honor_all = [{HonorId, <<>>, 0} | Honors]}}};
        _ ->
            {ok, Role}
    end;

%% 帮战积分
do(#gain{label = guild_war, val = Val}, Role = #role{assets = Assets = #assets{guild_war = GuildWar, guild_war_acc = GuildWarAcc}}) ->
    NRole = Role#role{assets = Assets#assets{guild_war = GuildWar + Val, guild_war_acc = GuildWarAcc + Val}},
    NRole1 = role_listener:special_event(NRole, {20019, NRole#role.assets#assets.guild_war_acc}), %% 个人帮战累积积分变化 N:当前个人帮战累积积分
    NewRole = role_listener:special_event(NRole1, {20028, Val}), %% 本日【帮战】积分
    {ok, NewRole};
do(L = #loss{label = guild_war, val = Val}, Role = #role{assets = Assets = #assets{guild_war = GuildWar}}) ->
    case GuildWar < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{guild_war = GuildWar - Val}}}
    end;

%% 试练积分
do(#gain{label = practice, val = Val}, Role = #role{assets = Assets = #assets{practice = Prac, practice_acc = PracAcc}}) ->
    NRole = Role#role{assets = Assets#assets{practice = Prac + Val, practice_acc = PracAcc + Val}},
    {ok, NRole};
do(L = #loss{label = practice, val = Val}, Role = #role{assets = Assets = #assets{practice = Prac}}) ->
    case Prac < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{practice = Prac - Val}}}
    end;

%% 魂气
do(#gain{label = soul, val = Val}, Role = #role{assets = Assets = #assets{soul = Soul, soul_acc = SoulAcc}}) ->
    NRole = Role#role{assets = Assets#assets{soul = Soul + Val, soul_acc = SoulAcc + Val}},
    {ok, NRole};
do(L = #loss{label = soul, val = Val}, Role = #role{assets = Assets = #assets{soul = Soul}}) ->
    case Soul < Val of
        true -> {false, L};
        false -> {ok, Role#role{assets = Assets#assets{soul = Soul - Val}}}
    end;

%% 容错处理
do(G, _Role) ->
    ?ERR("无法处理的损益数据:~w", [G]),
    {false, G}.

%% @spec do_misc(GL, Role) -> {ok, NewRole} | {false, MiscCell}
%% @doc 处理附加信息
%% 掉落音效
do_misc([], Role) -> {ok, Role};
do_misc([MiscCell | T], Role) ->
    case do_misc(MiscCell, Role) of
        {ok, NewRole} -> do_misc(T, NewRole);
        {false, Cell} -> {false, Cell}
    end;
do_misc({DropNoticeType, {NpcBaseId, ItemBaseId, Bind}}, Role = #role{id = {_RoleId, SrvId}, pos = #pos{map_base_id = MapBaseId}, guild = #role_guild{gid = GuildId}}) when DropNoticeType =:= drop_notice orelse DropNoticeType =:= drop_notice2 ->
    {ok, [Item]} = item:make(ItemBaseId, Bind, 1),
    ItemMsg = notice:get_item_msg(Item),
    _NameList = notice:items_to_name([Item]), 
    RoleMsg = notice:get_role_msg(Role),
    NpcName = case npc_data:get(NpcBaseId) of
        {ok, #npc_base{name = Name}} -> Name;
        _ -> ?L(<<"未命名">>)
    end,
    case MapBaseId of %% 帮会副本
        31003 ->
            guild:pack_send({GuildId, SrvId}, 10931, {53, util:fbin(?L(<<"~s在帮会降妖中英勇的击杀了{npc, ~s, #f65e6a}，获得~s">>), [RoleMsg, NpcName, ItemMsg]), []});
        10003 -> %% 守卫洛水
            case npc_data:get(NpcBaseId) of
                {ok, #npc_base{fun_type = ?npc_fun_type_guard}} ->
                    notice:send(62, util:fbin(?L(<<"在群妖的围攻下，~s英勇奋战，击败{npc, ~s, #f65e6a}，获得了~s">>), [RoleMsg, NpcName, ItemMsg]));
                _ -> 
                    notice:send(62, util:fbin(?L(<<"~s与{npc, ~s, #f65e6a}艰苦战斗后，获得~s">>), [RoleMsg, NpcName, ItemMsg]))
            end;
        _ ->
            case DropNoticeType of
                drop_notice ->
                    role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"冒险家~s英勇奋战，击败了~s获得了~s">>),[RoleMsg, NpcName, ItemMsg])});
                drop_notice2 ->
                    role_group:pack_cast(world, 10932, {7, 1, util:fbin(?L(<<"冒险家~s英勇奋战，击败了~s获得了~s">>),[RoleMsg, NpcName, ItemMsg])})
            end
            %notice:send_interface({connpid, ConnPid}, 4, Account, SrvId, RoleName, <<"">>, NameList),
            %notice:send(62, util:fbin(?L(<<"~s与{npc, ~s, #f65e6a}艰苦战斗后，获得~s">>), [RoleMsg, NpcName, ItemMsg]))
    end,
    {ok, Role};
do_misc({owned_by_npc, _}, Role) ->
    {ok ,Role};
do_misc(Misc, _Role) ->
    ?ERR("无法处理的损益数据中的附加信息:~w", [Misc]),
    {false, Misc}.

%% @spec recalc_npc_gain(G, Role) -> NewG
%% G = NewG = #gain{}
%% @doc 重算打怪的获取收益
recalc_npc_gain(G = #gain{label = exp_npc, val = Val}, #role{ratio = #ratio{exp = ExpPer}}) ->
    ExpAdd = erlang:trunc(Val * ExpPer / 100), %% 结算经验加成
    G#gain{label = exp, val = ExpAdd};
recalc_npc_gain(G = #gain{label = psychic_npc, val = Val}, #role{ratio = #ratio{psychic = PsyPer}}) ->
    PsyAdd = erlang:trunc(Val * PsyPer / 100), %% 结算经验加成
    G#gain{label = psychic, val = PsyAdd};
recalc_npc_gain(G, _) -> G.

%% 分离物品收益和其它属性收益
%% -> {AttrGains = [#gain{}], ItemGains = [#gain{}]}
separate_items(Gains) ->
    separate_items(Gains, [], []).
separate_items([], AttrGains, ItemGains) ->
    {AttrGains, ItemGains};
separate_items([Gain = #gain{label = item}|T], AttrGains, ItemGains) ->
    separate_items(T, AttrGains, [Gain|ItemGains]);
separate_items([Gain = #gain{}|T], AttrGains, ItemGains) ->
    separate_items(T, [Gain|AttrGains], ItemGains).

merge_gains(Gains) ->
    merge_gains(Gains, []).
merge_gains([], Return) ->
    Return;
merge_gains([H | T], Return) ->
    Return2 = merge(H, Return),
    merge_gains(T, Return2).

%% --------------------------
%% 内部函数
%% --------------------------
merge(Gain, Gains) ->
    merge(Gain, Gains, []). 
merge(Gain, [], Return) ->
    [Gain | Return];
merge(Gain = #gain{label = Label, val = Value}, [Gain2 = #gain{label = Label2, val = Value2} | T], Return) ->
    case Label =:= Label2 of
        false ->
            merge(Gain, T, [Gain2 | Return]);
        true ->
            case Label of
                item ->
                    [ItemBaseId, Bind, Num] = Value,
                    [ItemBaseId2, _Bind2, Num2] = Value2,
                    case ItemBaseId =:= ItemBaseId2 of
                        false ->
                            merge(Gain, T, [Gain2 | Return]);
                        true ->
                            [Gain#gain{val = [ItemBaseId, Bind, Num + Num2]} | T] ++ Return
                    end;
                fragile ->
                    [ItemBaseId, Num] = Value,
                    [ItemBaseId2, Num2] = Value2,
                    case ItemBaseId =:= ItemBaseId2 of 
                        true ->
                            [Gain#gain{val = Num + Num2} | T] ++ Return;
                        false ->
                            merge(Gain, T, [Gain2 | Return])
                    end;
                _ ->
                    [Gain#gain{val = Value + Value2} | T] ++ Return
            end
    end.

%% 物品和资产分开检测，成功才同步客户端
do_refresh([], Role = #role{link = #link{conn_pid = ConnPid}}, RefreshList, OldRole) ->
    sys_conn:pack_send(ConnPid, 10006, role_api:pack_proto_10006(OldRole, Role)),
    storage_api:refresh_client(RefreshList, ConnPid),
    put(item_del, log_conv:parse_item(RefreshList, [])),
    {ok, Role};
do_refresh([H | T], Role, RefreshList, OldRole) ->
    case do(H, Role) of
        {ok, NewRole} -> do_refresh(T, NewRole, RefreshList, OldRole);
        {ok, NewRole, {Type, NewAdd, NewDel, NewFresh}} -> 
            case lists:keyfind(Type, 1, RefreshList) of
                false ->
                    do_refresh(T, NewRole, [{Type, NewAdd, NewDel, NewFresh} | RefreshList], OldRole);
                {Type, Add, Del, Fresh} ->
                    NewFreshList = lists:keyreplace(Type, 1, RefreshList, {Type, NewAdd++Add, NewDel++Del, NewFresh++Fresh}),
                    do_refresh(T, NewRole, NewFreshList, OldRole)
            end;
        {false, G} -> {false, G}
    end.

%% 判断并计算升级
can_upgrade(?ROLE_LEV_LIMIT, _, _) -> {?ROLE_LEV_LIMIT, 0}; %% 等级限制
can_upgrade(Lev, Now, Val) ->
    Need = role_exp_data:get(Lev),
    case Now + Val >= Need of
        true ->
            can_upgrade(Lev + 1, 0, Now + Val - Need);
        false ->
            {Lev, Now + Val}
    end.

check_update_role_online(Name, Lev, Nlev) ->
    case Nlev > Lev of 
        true ->
            role_adm:update_lev(Name, Nlev),
            ok;
        false ->
            ok
    end.
%%----------------------------------------------------
%% 单元测试
%%----------------------------------------------------
-ifdef(debug).
-include_lib("eunit/include/eunit.hrl").

base_test_() ->
    %% 升级测试
    TestUpgrade = fun() ->
            Lev = 1,
            Exp = 10,
            Add1 = 30,
            Add2 = 40,
            Add3 = 220,
            {NL1, NE1} = can_upgrade(Lev, Exp, Add1),
            ?assertEqual(NL1, 1),
            ?assertEqual(NE1, 40),
            {NL2, NE2} = can_upgrade(Lev, Exp, Add2),
            ?assertEqual(NL2, 2),
            ?assertEqual(NE2, 0),
            {NL3, NE3} = can_upgrade(Lev, Exp, Add3),
            ?assertEqual(NL3, 3),
            ?assertEqual(NE3, 80),
            true
    end,
    %% 测试
    [
        ?_assert(TestUpgrade())
    ].
-endif.
