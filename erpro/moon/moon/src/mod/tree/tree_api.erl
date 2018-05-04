%%----------------------------------------------------
%% 世界树api
%%
%% @author mobin
%%----------------------------------------------------
-module(tree_api).
-export([
        enter/1
        ,exit_lose/2
        ,forward/1
        ,charge/1
        ,open/1
        ,attack/1
        ,get_tree_role/1
        ,async_combat_over_leave/2
        ,next_day/1
        ,gm_boss/2
    ]).
-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("tree.hrl").
-include("item.hrl").
-include("npc.hrl").
-include("combat.hrl").
-include("pos.hrl").

-define(floors_per_stage, 3).
-define(max_floor, 180).

-define(npc_id, 1).

-define(award_id, 103000).
-define(combat_award_id, 107000).

-define(lose_cost, 1).


%% 请求进入世界树
enter(Role = #role{id = Rid, link = #link{conn_pid = ConnPid}}) ->
    #tree_role{floor = Floor, status = Status, exp = Exp, coin = Coin, material = Material, strange = Strange,
        stage = Stage} = get_tree_role(Rid),
    sys_conn:pack_send(ConnPid, 13600, {Floor, Status, Exp, Coin, Material, Strange}),
    %%Boss下发要晚于13600
    case Status =:= ?boss orelse Status =:= ?lose of
        true ->
            create_boss(Stage, ConnPid);
        false ->
            ignore
    end,

    %%位置在客户端重新修改
    sys_conn:pack_send(ConnPid, 10110, {1022, 0, 0}),  %%进入世界树地图

    %%勋章处理监听
    {ok, Role2} = medal:join_activity(Role, tree_climb_times),
    random_award:tree_climb_times(Role),
    log:log(log_activity_activeness, {<<"世界树玩法">>, 3, Role}),

    Role3 = role_listener:special_event(Role2, {1073, finish}), %% 参加世界树事件

    Role3#role{event = ?event_tree}.

exit_lose(Role = #role{pid = _RolePid, id = Rid}, IsBuy) ->
    TreeRole = #tree_role{status = Status} = get_tree_role(Rid),
    {IsBuy2, Role4} = case Status of
        ?lose ->
            {_IsBuy, TreeRole2, Role2} = case IsBuy of
                1 ->
                    case role_gain:do([#loss{label = gold, val = ?lose_cost}], Role) of
                        {ok, _Role} ->
                            {IsBuy, TreeRole#tree_role{status = ?boss}, _Role};
                        _ ->
                            {0, TreeRole, Role}
                    end;
                0 ->
                    {IsBuy, TreeRole, Role}
            end,
            {TreeRole3, Role3, _IsBag} = obtain_rewards(TreeRole2, Role2),
            TreeRole4 = TreeRole3#tree_role{status = ?boss},
            put(tree_role, TreeRole4),
            {_IsBuy, Role3};
        _ ->
            {IsBuy, Role}
    end,
    {IsBuy2, Role4#role{event = ?event_no}}.

forward(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    TreeRole = #tree_role{floor = Floor, stage = Stage, is_clear = IsClear} = get(tree_role),
    case Floor >= ?max_floor of
        true ->
            sys_conn:pack_send(ConnPid, 13609, {0}),
            false;
        false ->
            Floor2 = Floor + 1,
            Stage2 = (Floor2 - 1) div ?floors_per_stage + 1,
            IsClear2 = case Stage2 =:= Stage of
                true ->
                    IsClear;
                false ->
                    ?false
            end,
            Status2 = case (IsClear2 =:= ?false andalso is_boss_turn(Floor2)) of
                false ->
                    ?box; 
                true ->
                    create_boss(Stage2, ConnPid),
                    ?boss
            end,
            put(tree_role, TreeRole#tree_role{floor = Floor2, status = Status2, stage = Stage2, is_clear = IsClear2}),

            %%勋章信息
            Role2 = medal:listener(tree_climb, Role, Floor2),

            {Status2, Role2}
    end.

charge(Role = #role{link = #link{conn_pid = ConnPid}, bag = #bag{items = BagItems}}) ->
    TreeRole = #tree_role{floor = Floor, stage = Stage, is_clear = IsClear} = get(tree_role),
    Stage2 = case IsClear == ?true orelse Stage =:= 0 of
        true ->
            Stage + 1;
        false ->
            Stage
    end,
    MaxFloor = Stage2 * ?floors_per_stage,
    MinFloor = case IsClear of
        ?true ->
            Stage * ?floors_per_stage + 1;
        ?false ->
            Floor + 1
    end,
    Floor2 = util:rand(MinFloor, MaxFloor),
    
    ClearFloor = Floor2 - Floor,
    create_boss(Stage2, ConnPid),
    {TreeRole2, Rewards} = get_charge_rewards(ClearFloor - 1, TreeRole, BagItems),
    put(tree_role, TreeRole2#tree_role{floor = Floor2, is_clear = ?false, stage = Stage2, status = ?boss}),

    %%军团目标监听
    role_listener:guild_tree(Role, {ClearFloor}),
    NRole = medal:listener(tree_climb, Role, Floor2),
    {{Floor2, Rewards}, NRole}.

open(Role = #role{bag = #bag{items = BagItems}, link = #link{conn_pid = ConnPid}}) ->
    TreeRole = #tree_role{is_clear = IsClear, stage = Stage, best_stage = BestStage, floor = Floor} = get(tree_role),
    {TreeRole2, Type, ItemId, Count} = get_reward(TreeRole, BagItems),    

    {TreeRole3, Role2} = case Floor >= ?max_floor of 
        true ->
            %%顶层则直接结算奖励
            {_TreeRole, _Role, _IsBag} = obtain_rewards(TreeRole2, Role),
            sys_conn:pack_send(ConnPid, 13612, {}),
            {_TreeRole, _Role};
        false ->
            {TreeRole2, Role}
    end,
    %%更新状态
    Status2 = forward_or_charge(Stage, IsClear, BestStage),
    TreeRole4 = TreeRole3#tree_role{status = Status2},
    put(tree_role, TreeRole4),

    %%军团目标监听
    role_listener:guild_tree(Role2, {1}),

    {{Status2, Type, ItemId, Count}, Role2}.

attack(Role = #role{id = Rid, link = #link{conn_pid = ConnPid}}) ->
    #tree_role{stage = Stage, best_stage = BestStage} = get(tree_role),
    #tree_stage{boss_id = BossId, kill_odds = KillOdds} = tree_data:get(Stage),
    case BestStage >= Stage andalso is_kill_directly(KillOdds) of
        true ->
            {Role1, Status, IsBag} = win(Role),

            %%战斗胜利奖励
            NpcRewards = get_npc_rewards(BossId),
            DropItems = get_drop([BossId]),
            Gains = NpcRewards ++ DropItems,
            {Role3, WinIsBag} = case role_gain:do(Gains, Role1) of
                {ok, Role2} ->
                    {Role2, ?true};
                _ ->
                    award:send(Rid, ?combat_award_id, Gains),
                    {Role1, ?false}
            end,
            ProtoGains = get_proto_gains(Gains),

            sys_conn:pack_send(ConnPid, 13605, {Status, IsBag, WinIsBag, ProtoGains}),
            Role3;
        false ->
            start_combat(Role, BossId),
            Role
    end.

%%必须在角色进程内判断
get_tree_role(Rid) ->
    Today = util:unixtime({today, util:unixtime()}),
    TreeRole2 = case get(tree_role) of
        undefined ->
            case fetch_tree_role(Rid) of
                false ->
                    #tree_role{rid = Rid, last = util:unixtime()};
                TreeRole ->
                    TreeRole#tree_role{last = util:unixtime()}
            end;
        TreeRole = #tree_role{last = Last} when Last >= Today ->
            TreeRole#tree_role{last = util:unixtime()};
        #tree_role{status = LastStatus, exp = Exp, coin = Coin, material = Material, strange = Strange,
            material_items = MaterialItems, strange_items = StrangeItems, best_stage = BestStage} ->
            case LastStatus of
                ?lose ->
                    obtain_lose_rewards(Exp, Coin, Material, Strange, MaterialItems, StrangeItems, Rid);
                _ ->
                    ignore
            end,
            Status = case BestStage > 0 of
                false ->
                    ?forward;
                true ->
                    ?charge
            end,
            #tree_role{rid = Rid, status = Status, best_stage = BestStage, last = util:unixtime()}
    end,
    put(tree_role, TreeRole2),
    TreeRole2.

async_combat_over_leave(Role = #role{link = #link{conn_pid = ConnPid}}, Result) ->
    Role2 = case Result of
        ?combat_result_win ->
            {Role1, Status, IsBag} = win(Role),
            sys_conn:pack_send(ConnPid, 13606, {Status, IsBag}),
            Role1;
        _ ->
            lose(Role)
    end,
    {ok, Role2}.

next_day(Rid) ->
    TreeRole = get_tree_role(Rid),
    put(tree_role, TreeRole#tree_role{last = 0}).

gm_boss(Rid, Stage) ->
    TreeRole = get_tree_role(Rid),
    put(tree_role, TreeRole#tree_role{status = ?boss, stage = Stage, is_clear = ?false,
        floor = Stage * ?floors_per_stage}).

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
win(Role = #role{link = #link{conn_pid = ConnPid}, bag = #bag{items = BagItems}}) ->
    ?DEBUG("win tree", []),
    TreeRole = #tree_role{stage = Stage, best_stage = BestStage, strange = Strange} = get(tree_role),
    BestStage2 = case Stage > BestStage of
        true ->
            Stage;
        false ->
            BestStage
    end,

    %%Boss大宝箱
    #tree_stage{strange_limit = StrangeLimit, boss_exp = Exp, boss_coin = Coin, boss_material_odds = MaterialOdds,
        boss_strange_odds = StrangeOdds} = tree_data:get(Stage),
    {TreeRole2, _, _, ExpCount} = get_certain_reward(?exp, TreeRole, Exp, Coin, BagItems),
    {TreeRole3, _, _, CoinCount} = get_certain_reward(?coin, TreeRole2, Exp, Coin, BagItems),
    {TreeRole4, _, _, MaterialCount} = case is_hit(MaterialOdds) of
        true ->
            get_certain_reward(?material, TreeRole3, Exp, Coin, BagItems);
        false ->
            {TreeRole3, 0, 0, 0}
    end,
    {TreeRole5, CoinCount2, StrangeCount} = case StrangeLimit > Strange andalso is_hit(StrangeOdds) of
        true ->
            case get_certain_reward(?strange, TreeRole4, Exp, Coin, BagItems) of
                {_TreeRole, ?coin, _, _CoinCount} ->
                    {_TreeRole, _CoinCount, 0};
                {_TreeRole, ?strange, _, _StrangeCount} ->
                    {_TreeRole, 0, _StrangeCount}
            end;
        false ->
            {TreeRole4, 0, 0}
    end,
    sys_conn:pack_send(ConnPid, 13610, {ExpCount, CoinCount + CoinCount2, MaterialCount, StrangeCount}),

    %%确保先获得奖励后计算下一状态
    {TreeRole6, Role2, IsBag} = obtain_rewards(TreeRole5, Role),
    Status2 = forward_or_charge(Stage, ?true, BestStage2),
    TreeRole7 = TreeRole6#tree_role{is_clear = ?true, status = Status2, best_stage = BestStage2},
    put(tree_role, TreeRole7),

    %%军团目标监听
    role_listener:guild_tree(Role, {1}),

    {Role2, Status2, IsBag}.

lose(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    ?DEBUG("lose tree", []),
    TreeRole = get(tree_role),
    put(tree_role, TreeRole#tree_role{status = ?lose, is_lose = ?true}),
    sys_conn:pack_send(ConnPid, 13609, {0}),
    Role#role{status = ?status_normal, hp = Role#role.hp_max, mp = Role#role.mp_max}.

%% 由gain产生物品
get_proto_gains(Gains) ->
    get_proto_gains(Gains, []).
get_proto_gains([], Return) ->
    Return;
get_proto_gains([#gain{label = item, val = [ItemBaseId, Bind, Count]} | T], Return) ->
    Type = case Bind of
        ?item_unbind ->
            10;
        _ ->
            11
    end,
    get_proto_gains(T, [{Type, ItemBaseId, Count} | Return]);
get_proto_gains([#gain{label = exp_npc, val = Value} | T], Return) ->
    get_proto_gains(T, [{0, 0, Value} | Return]);
get_proto_gains([#gain{label = fragile, val = [ItemBaseId, Count]} | T], Return) ->
    get_proto_gains(T, [{14, ItemBaseId, Count} | Return]);
get_proto_gains([#gain{label = coin, val = Value} | T], Return) ->
    get_proto_gains(T, [{3, 3, Value} | Return]).

%% 掉落
get_drop(NpcBaseIds) ->
    DropRatio = case platform_cfg:get_cfg(drop_ratio) of
        false -> 1;
        Value -> Value / 100
    end,
    Ratio2 = erlang:round(100 * DropRatio),
    {Sitems, Items} = drop:produce(NpcBaseIds, Ratio2),
    [G || {_, G} <- Sitems] ++ flat([Gs || {_, Gs} <- Items]).

%% 合并列表
flat(L) ->
    flat(L, []).
flat([], Back) ->
    Back;
flat([H | T], Back) ->
    flat(T, Back ++ H).

get_npc_rewards(NpcBaseId) ->
    case npc_data:get(NpcBaseId) of
        {ok, #npc_base{rewards = Rewards}} ->
            Rewards;
        _ ->
            []
    end.

obtain_rewards(TreeRole = #tree_role{status = Status, exp = Exp, coin = Coin, material = Material,
    strange = Strange, material_items = MaterialItems, strange_items = StrangeItems}, Role = #role{id = Rid}) ->
    Gains = case Status of
        ?box ->
            get_tree_gains(Exp, Coin, MaterialItems, StrangeItems);
        ?boss ->
            get_tree_gains(Exp, Coin, MaterialItems, StrangeItems);
        ?lose ->
            MaterialItems2 = lists:sublist(MaterialItems, Material div 2),
            StrangeItems2 = lists:sublist(StrangeItems, Strange div 2),
            get_tree_gains(Exp div 2, Coin div 2, MaterialItems2, StrangeItems2);
        _ ->
            []
    end,
    {Role3, IsBag} = case role_gain:do(Gains, Role) of
        {ok, Role2} ->
            {Role2, ?true};
        _ ->
            award:send(Rid, ?award_id, Gains),
            {Role, ?false}
    end,
    {TreeRole#tree_role{exp = 0, coin = 0, material = 0, strange = 0, material_items = [],
            strange_items = []}, Role3, IsBag}.

obtain_lose_rewards(Exp, Coin, Material, Strange, MaterialItems, StrangeItems, Rid) ->
    MaterialItems2 = lists:sublist(MaterialItems, Material div 2),
    StrangeItems2 = lists:sublist(StrangeItems, Strange div 2),
    Gains = get_tree_gains(Exp div 2, Coin div 2, MaterialItems2, StrangeItems2),
    award:send(Rid, ?award_id, Gains).

get_tree_gains(Exp, Coin, Materials, Stranges) ->
    Gains = case Exp =:= 0 of
        true ->
            [];
        false ->
            [#gain{label = exp, val = Exp}]
    end,
    Gains1 = case Coin =:= 0 of
        true ->
            Gains;
        false ->
            [#gain{label = coin, val = Coin} | Gains]
    end,
    
    Gains2 = lists:foldl(fun({BaseId, Bind, Count}, Return) ->
                [#gain{label = item, val = [BaseId, Bind, Count]} | Return]
        end, Gains1, Materials),

    Gains3 = role_gain:merge_gains(Gains2),
    
    lists:foldl(fun({BaseId, Bind, TaskId}, Return) ->
                [#gain{label = item, val = [BaseId, Bind, 1], misc = [{task, TaskId}]} | Return]
        end, Gains3, Stranges).

is_boss_turn(NextFloor) ->
    Rate = case (NextFloor rem ?floors_per_stage) of
        1 ->
            33;
        2 ->
            50;
        0 ->
            100
    end,
    Value = util:rand(1, 100),
    (Value =< Rate).

is_kill_directly(KillOdds) ->
    Value = util:rand(1, 1000),
    (Value =< KillOdds).

is_hit(Odds) ->
    Value = util:rand(1, 10000),
    (Value =< Odds).

start_combat(Role, BossId) ->
    {ok, NpcBase} = npc_data:get(BossId),
    %%位置在客户端重新修改
    Npc = npc_convert:base_to_npc(?npc_id, NpcBase, #pos{x = 600, y = 448}),
    {ok, Fighter} = npc_convert:do(to_fighter, Npc),
    combat:start(?combat_type_tree, role_api:fighter_group(Role), [Fighter]).


create_boss(Stage, ConnPid) ->
    #tree_stage{boss_id = BossId} = tree_data:get(Stage),
    sys_conn:pack_send(ConnPid, 13607, {BossId}).

forward_or_charge(Stage, IsClear, BestStage) ->
    case BestStage > Stage orelse (BestStage =:= Stage andalso IsClear =:= ?false) of
        true ->
            ?charge;
        false ->
            ?forward
    end.

get_charge_rewards(Floors, TreeRole, BagItems) ->
    get_charge_rewards(Floors, TreeRole, BagItems, []).
get_charge_rewards(Floors, TreeRole, _, Return) when Floors =:= 0 ->
    {TreeRole, Return};
get_charge_rewards(Floors, TreeRole = #tree_role{floor = Floor}, BagItems, Return) ->
    Floor2 = Floor + 1,
    Stage2 = (Floor2 - 1) div ?floors_per_stage + 1,
    TreeRole2 = TreeRole#tree_role{stage = Stage2, floor = Floor2},
    {TreeRole3, Type, _ItemId, Count} = get_reward(TreeRole2, BagItems),
    get_charge_rewards(Floors - 1, TreeRole3, BagItems, [{Type, Count} | Return]).

get_reward(TreeRole = #tree_role{stage = Stage, strange = Strange}, BagItems) ->
    %%随机奖励
    #tree_stage{weights = Weights, strange_limit = StrangeLimit, exp = Exp, coin = Coin} = tree_data:get(Stage),
    BoxType = get_box_type(Weights, Strange, StrangeLimit),
    get_certain_reward(BoxType, TreeRole, Exp, Coin, BagItems).

get_certain_reward(BoxType, TreeRole = #tree_role{stage = Stage, material_items = MaterialItems, strange_items = StrangeItems},
    Exp, Coin, BagItems) ->
    case BoxType of
        ?exp ->
            Exp2 = Exp * util:rand(50, 100) div 100,
            {TreeRole#tree_role{exp = TreeRole#tree_role.exp + Exp2}, ?exp, 0, Exp2};
        ?coin ->
            Coin2 = Coin * util:rand(50, 100) div 100,
            {TreeRole#tree_role{coin = TreeRole#tree_role.coin + Coin2}, ?coin, 0, Coin2};
        ?material ->
            {ItemId, Count} = get_material_item(Stage),
            {TreeRole#tree_role{material = TreeRole#tree_role.material + Count,
                    material_items = [{ItemId, ?item_bind, Count} | MaterialItems]}, ?material, ItemId, Count};
        ?strange ->
            Items = tree_data:strange_items(),
            FilterFun = fun({ItemBaseId, _, _}) ->
                    %%先找收集包，再找背包
                    case lists:keyfind(ItemBaseId, 1, StrangeItems) of
                        false ->
                            case lists:keyfind(ItemBaseId, #item.base_id, BagItems) of
                                false ->
                                    true;
                                _ ->
                                    false
                            end;
                        _ ->
                            false
                    end
            end,
            Items2 = lists:filter(FilterFun, Items),
            %%背包里或收集包有所有奇怪物品则给金币，只能亏不能赚
            case Items2 of
                [] ->
                    Coin2 = Coin * util:rand(50, 100) div 100,
                    {TreeRole#tree_role{coin = TreeRole#tree_role.coin + Coin2}, ?coin, 0, Coin2};
                _ ->
                    {ItemId, TaskId} = get_strange_item(Items2),
                    {TreeRole#tree_role{strange = TreeRole#tree_role.strange + 1,
                            strange_items = [{ItemId, ?item_bind, TaskId} | StrangeItems]}, ?strange, ItemId, 1}
            end
    end.


get_strange_item(Items) ->
    Rands = [Rand || {_, _, Rand} <- Items],
    SumRand = lists:sum(Rands),

    RandValue = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    {ItemId, Tasks} = get_strange_item(RandValue, Items),
    {ItemId, get_strange_task(Tasks)}.
get_strange_item(RandValue, [{ItemId, Tasks, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
    {ItemId, Tasks};
get_strange_item(RandValue, [{_, _, Rand} | T]) ->
    get_strange_item(RandValue - Rand, T).

get_strange_task(Tasks) ->
    Rands = [Rand || {_, Rand} <- Tasks],
    SumRand = lists:sum(Rands),

    RandValue = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    get_strange_task(RandValue, Tasks).
get_strange_task(RandValue, [{TaskId, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
    TaskId;
get_strange_task(RandValue, [{_, Rand} | T]) ->
    get_strange_task(RandValue - Rand, T).

get_material_item(Stage) ->
    Items = tree_data:material_items(Stage),
    Rands = [Rand || {_, _, Rand} <- Items],
    SumRand = lists:sum(Rands),

    RandValue = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    {ItemId, Limit} = get_material_item(RandValue, Items),
    {ItemId, util:rand(1, Limit)}.
get_material_item(RandValue, [{ItemId, Limit, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
    {ItemId, Limit};
get_material_item(RandValue, [{_, _, Rand} | T]) ->
    get_material_item(RandValue - Rand, T).

get_box_type(Weights, Strange, StrangeLimit) ->
    Rands = case Strange >= StrangeLimit of
        true ->
            [Rand || {Type, Rand} <- Weights, Type =/= ?strange];
        false ->
            [Rand || {_, Rand} <- Weights]
    end,
    SumRand = lists:sum(Rands),

    RandValue = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    get_box_type(RandValue, Weights).
get_box_type(RandValue, [{Type, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
    Type;
%%get_box_type(RandValue, [{_Type, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
%%   ?strange;
get_box_type(RandValue, [{_, Rand} | T]) ->
    get_box_type(RandValue - Rand, T).

fetch_tree_role(Rid = {RoleId, SrvId}) ->
    Today = util:unixtime({today, util:unixtime()}),
    Sql = "select floor, status, stage, exp, coin, material, strange, material_items, strange_items, is_clear, last, best_stage, is_lose from sys_tree where role_id = ~s and srv_id = ~s",
    case db:get_row(Sql, [RoleId, SrvId]) of
        {ok, [Floor, Status, Stage, Exp, Coin, Material, Strange, MaterialItems, StrangeItems, IsClear, Last, BestStage, IsLose]} when Last >= Today ->
            case {util:bitstring_to_term(MaterialItems), util:bitstring_to_term(StrangeItems)} of
                {{ok, MaterialTerm}, {ok, StrangeTerm}} ->
                    #tree_role{rid = Rid, floor = Floor, status = Status, stage = Stage, exp = Exp, coin = Coin,
                        material = Material, strange = Strange, material_items = MaterialTerm, strange_items = StrangeTerm,
                        is_clear = IsClear, best_stage = BestStage, is_lose = IsLose};
                _ ->
                    false
            end;
        {ok, [_, LastStatus, _, Exp, Coin, Material, Strange, MaterialItems, StrangeItems, _, _, BestStage, _]} ->
            case LastStatus of
                ?lose ->
                    case {util:bitstring_to_term(MaterialItems), util:bitstring_to_term(StrangeItems)} of
                        {{ok, MaterialTerm2}, {ok, StrangeTerm2}} ->
                            obtain_lose_rewards(Exp, Coin, Material, Strange, MaterialTerm2, StrangeTerm2, Rid);
                        _ ->
                            ignore
                    end;
                _ ->
                    ignore
            end,
            Status = case BestStage > 0 of
                false ->
                    ?forward;
                true ->
                    ?charge
            end,
            #tree_role{rid = Rid, status = Status, best_stage = BestStage};
        {_, _} ->
            false
    end.
