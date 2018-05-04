%%----------------------------------------------------
%% @doc drop
%%
%% 掉落系统模块相关业务逻辑处理 
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------
-module(drop).

-export([
        produce/2
        ,produce4gm/2
        ,produce/3
        ,get_superb_total_domain/2
        ,get_normal_total_domain/2
        ,get_global_drop_rule_prob/2
        ,check_superb_prob/3
        ,get_domain_item/2
    ]
).

-include("common.hrl").
-include("drop.hrl").
-include("role.hrl").
-include("ratio.hrl").
-include("gain.hrl").

-define(PET_IDS, [1,2,3,4]).

%%----------------------------------------------------
%% 角色进程接口
%%----------------------------------------------------
%% @spec produce(NpcBaseIdList::[integer()], DropRatio::integer()) ->  {SupNpcItemList, NormalItemList}
%% @doc
%% <pre>
%% 根据斩杀怪物ID，获得产生物品
%% 注： 返回的极品装备列表跟普通装备列表的格式不一样
%%      SupNpcItemList = [{NpcBaseId::integer{}, #gain{}}] 极品装备掉落列表 如ItemId = -1 则不考虑
%%      NormalItemList = [{NpcBaseId::integer{}, [#gain{}]}] 普通装备掉落列表
%% </pre>
produce(NpcIdList, DropRatio) when is_list(NpcIdList)->
    case catch produce_catch(NpcIdList, DropRatio) of
        {NewSup, NewNormal} when is_list(NewSup) -> {NewSup, NewNormal};
        _Err ->
            ?ERR("计算掉落有误[~w]:~w", [NpcIdList, _Err]),
            {[], []}
    end;
produce(_NpcIdList, _DropRatio) ->
    {[], []}.
produce_catch(NpcIdList, DropRatio) ->
    {GlobalRules} = drop_mgr:get_global_drop_rules(),
    {ok} = drop_mgr:update_kill_num(NpcIdList),
    SupNpcIdList = check_superb_prob(NpcIdList, GlobalRules, DropRatio), %% 计算出可产出极品装备的NpcId
    SupNpcItemList = case length(SupNpcIdList) > 0 of
        true ->
            drop_mgr:produce(SupNpcIdList); %% {NpcId, ItemId}列表
        false ->
            []
    end,
    NormalNpcIdList = NpcIdList -- SupNpcIdList, %% 没有参与极品装备运算的物品
    AllNItemList = produce_normal(all, NormalNpcIdList),
    TwoNItemList = produce_normal(two, SupNpcIdList),
    Fragiles = produce_fragile(NpcIdList),
    %% ?DEBUG("获得碎片 ~w", [Fragiles]),
    %%  ?DEBUG("[[[[[[[[[[[ 掉落NPC ITEM 数据  ~w", [AllNItemList ++ TwoNItemList]),
    NorNpcItem = convert_pet_item(AllNItemList ++ TwoNItemList, []),
    SupNpcItemList1 = convert_pet_item(SupNpcItemList, []),
    NewSup = filter(superb, SupNpcItemList1),
    %%NewNormal = filter(normal, AllNItemList ++ TwoNItemList),
    NewNormal = filter(normal, NorNpcItem),
    FragilesGain = filter(fragile, Fragiles),
    %%?DEBUG("  **** 转换后数据  : ~w", [NorNpcItem ++ SupNpcItemList1]),
    %%?DEBUG("============== NewSup ~w,  NewNormal:~w, 碎片 ~w", [NewSup, NewNormal, FragilesGain]),
    {NewSup, NewNormal ++ FragilesGain}.

%% @spec produce(NpcBaseIdList::[integer()], DropRatio::integer()) ->  {NewRole, SupNpcItemList, NormalItemList}
%% @doc
%% <pre>
%% GM命令
%% 根据斩杀怪物ID，获得产生物品
%% 注： 返回的极品装备列表跟普通装备列表的格式不一样
%%      SupNpcItemList = [{NpcBaseId::integer{}, ItemBaseId::integer{}}] 极品装备掉落列表 如ItemId = -1 则不考虑
%%      NormalItemList = [{NpcBaseId::integer{}, [ItemBaseId::integer{}]}] 普通装备掉落列表
%% </pre>
produce4gm(NpcIdList, DropRatio) when is_list(NpcIdList)->
    {GlobalRules} = drop_mgr:get_global_drop_rules(),
    {ok} = drop_mgr:update_kill_num(NpcIdList),
    SupNpcIdList = check_superb_prob(NpcIdList, GlobalRules, DropRatio), %% 计算出可产出极品装备的NpcId
    SupNpcItemList =
        case length(SupNpcIdList) > 0 of
            true ->
                drop_mgr:produce(SupNpcIdList); %% {NpcId, ItemId}列表
            false ->
                []
        end,
    NormalNpcIdList = NpcIdList -- SupNpcIdList, %% 没有参与极品装备运算的物品
    AllNItemList = produce_normal(all, NormalNpcIdList),
    TwoNItemList = produce_normal(two, SupNpcIdList),
    %Fragiles = produce_fragile(NpcIdList),
    %?DEBUG("获得碎片 ~w", [Fragiles]),
    NorNpcItem = convert_pet_item(AllNItemList ++ TwoNItemList, []),
    SupNpcItemList1 = convert_pet_item(SupNpcItemList, []),
    NewSup = filter4gm(superb, SupNpcItemList1),
    NewNormal = filter4gm(normal, NorNpcItem),
    {NewSup, NewNormal}.

%% @spec produce(NpcId, Num, Role) -> {NewRole, SupItemIds, NormalItemIds}
%% NpcId = integer()
%% Num = integer()
%% Role = #role{}
%% SupItemIds = [integer()]
%% @doc GM命令
produce(NpcId, Num, Role) ->
    NpcIds = make_npcids(NpcId, Num),
    {SupNpcItemList, NormalNpcItemList} = produce4gm(NpcIds, 100),
    NewRole1 = add_item(sup, Role, SupNpcItemList),
    NewRole2 = add_item(normal, NewRole1, NormalNpcItemList),
    {NewRole2, SupNpcItemList, NormalNpcItemList}.

%%----------------------------------------------------
%% 业务函数 begin
%%----------------------------------------------------

%% @spec get_superb_total_domain(NpcId, ItemList) -> Num
%% NpcId = integer()
%% ItemList = [integer()]
%% Num = integer()
%% @doc 获取指定怪物极品物品的总区间
get_superb_total_domain(NpcId, [ItemId | T]) ->
    case drop_data_mgr:get_superb(NpcId, ItemId) of
        {ok, #drop_rule_superb_base{domain = Domain}} ->
            Domain + get_superb_total_domain(NpcId, T);
        {false, _Reason} ->
            ?DEBUG("不存在极品物品掉落数据NpcId:~w ItemId:~w", [NpcId, ItemId]),
            get_superb_total_domain(NpcId, T)
    end;
get_superb_total_domain(_NpcId, []) ->
    0.

%% @spec get_normal_total_domain(NpcId, ItemList) -> Num
%% NpcId = integer()
%% ItemList = [integer()]
%% Num = integer()
%% @doc 获取指定怪物普通物品的总区间
get_normal_total_domain(NpcId, [ItemId | T]) ->
    case drop_data_mgr:get_normal(NpcId, ItemId) of
        {ok, #drop_rule_normal_base{domain = Domain}} ->
            Domain + get_normal_total_domain(NpcId, T);
        {false, _Reason} ->
            ?DEBUG("不存在普通物品掉落数据NpcId:~w ItemId:~w", [NpcId, ItemId]),
            get_normal_total_domain(NpcId, T)
    end;
get_normal_total_domain(_NpcId, []) ->
    0.

%% 妖精碎片的总概率
get_fragile_total_domain(NpcId, [ItemId | T]) ->
    case drop_data_mgr:get_fragile(NpcId, ItemId) of
        {ok, #drop_rule_normal_base{domain = Domain}} ->
            Domain + get_fragile_total_domain(NpcId, T);
        {false, _Reason} ->
            ?DEBUG("不存在普通物品掉落数据NpcId:~w ItemId:~w", [NpcId, ItemId]),
            get_fragile_total_domain(NpcId, T)
    end;
get_fragile_total_domain(_NpcId, []) ->
    0.


%% @spec get_domain_item(Type, NpcId) -> ItemId
%% Type = superb | normal
%% NpcId = integer()
%% ItemId = integer()
%% @doc 获取对应NPC的极品物品ID
get_domain_item(superb, NpcId) ->
    ItemList = drop_data_mgr:get_superb_items(NpcId), 
    Total = case get_superb_total_domain(NpcId, ItemList) of
        0 ->
            1;
        Num ->
            Num
    end,
    RandomDomain = util:rand(1, Total),
    get_domain_item_rdm({superb, RandomDomain}, NpcId, ItemList);

get_domain_item(normal, NpcId) ->
    ItemList = drop_data_mgr:get_normal_items(NpcId),
    Total = case get_normal_total_domain(NpcId, ItemList) of
        0 ->
            1;
        Num ->
            Num
    end,
    RandomDomain = util:rand(1, Total),
    get_domain_item_rdm({normal, RandomDomain}, NpcId, ItemList);

%% 妖精碎片
get_domain_item(fragile, NpcId) ->
    ItemList = drop_data_mgr:get_fragile_items(NpcId),
    Total = case get_fragile_total_domain(NpcId, ItemList) of
        0 ->
            1;
        Num ->
            Num
    end,
    RandomDomain = util:rand(1, Total),
    get_domain_item_rdm({fragile, RandomDomain}, NpcId, ItemList).

%% @spec get_domain_item_rdm(Type, NpcId, ItemList) -> ItemId
%% Type = superb | normal
%% NpcId = integer()
%% ItemList = [integer()]
%% ItemId = integer()
%% @doc 根据区间获取极品物品ID
get_domain_item_rdm({superb, RandomDomain}, NpcId, [ItemId | T]) ->
    case drop_data_mgr:get_superb(NpcId, ItemId) of
        {ok, #drop_rule_superb_base{domain = Domain}} ->
            case RandomDomain =< Domain of
                true ->
                    ItemId;
                false ->
                    get_domain_item_rdm({superb, (RandomDomain - Domain)}, NpcId, T)
            end;
        {false, _Reason} ->
            ?DEBUG("不存在极品物品掉落数据NpcId:~w ItemId:~w", [NpcId, ItemId]),
            get_domain_item_rdm({superb, RandomDomain}, NpcId, T)
    end;
get_domain_item_rdm({superb, _RandomDomain}, _NpcId, []) ->
    0;

get_domain_item_rdm({normal, RandomDomain}, NpcId, [ItemId | T]) ->
    case drop_data_mgr:get_normal(NpcId, ItemId) of
        {ok, #drop_rule_normal_base{domain = Domain}} ->
            case RandomDomain =< Domain of
                true ->
                    ItemId;
                false ->
                    get_domain_item_rdm({normal, (RandomDomain - Domain)}, NpcId, T)
            end;
        {false, _Reason} ->
            ?DEBUG("不存在极品物品掉落数据NpcId:~w ItemId:~w", [NpcId, ItemId]),
            get_domain_item_rdm({normal, RandomDomain}, NpcId, T)
    end;
get_domain_item_rdm({normal, _RandomDomain}, _NpcId, []) ->
    0;

get_domain_item_rdm({fragile, RandomDomain}, NpcId, [ItemId | T]) ->
    case drop_data_mgr:get_fragile(NpcId, ItemId) of
        {ok, #drop_rule_normal_base{domain = Domain}} ->
            case RandomDomain =< Domain of
                true ->
                    ItemId;
                false ->
                    get_domain_item_rdm({fragile, (RandomDomain - Domain)}, NpcId, T)
            end;
        {false, _Reason} ->
            ?DEBUG("不存在极品物品掉落数据NpcId:~w ItemId:~w", [NpcId, ItemId]),
            get_domain_item_rdm({fragile, RandomDomain}, NpcId, T)
    end;
get_domain_item_rdm({fragile, _RandomDomain}, _NpcId, []) ->
    0.

%% @spec check_superb_prob(NpcIdList, DropRuleList, DropRatio) -> SupNpcIdList
%% NpcIdList = [integer()]
%% SupNpcIdList = [integer()]
%% DropRatio = integer() 个人掉率 
%% @doc 判断NPC是否可产出极品物品
%% 任务物品不会出现在正常的背包里，所以极品物品掉落概率不需要考虑任务的影响
check_superb_prob([NpcId | T], DropRuleList, DropRatio) ->
    case drop_data_mgr:get_prob(NpcId) of
        {ok, #drop_rule_prob_base{superb_prob = SuperbProb}} ->
            Random = util:rand(1, ?DROP_SUPERB_PROB),
            Addition = get_global_drop_rule_prob(superb, DropRuleList),
            FinalProb = ((DropRatio - 100) + Addition + 100) / 100 * SuperbProb,
            case FinalProb >= Random of
                true ->
                    [NpcId | check_superb_prob(T, DropRuleList, DropRatio)];
                false ->
                    check_superb_prob(T, DropRuleList, DropRatio)
            end;
        {false, _Reason} ->
            ?DEBUG("不存在掉落触发率基础信息[NpcId:~w]", [NpcId]),
            check_superb_prob(T, DropRuleList, DropRatio)
    end;
check_superb_prob([], _DropRuleList, _DropRatio) ->
    [].

%% @spec get_global_drop_rule_prob(Type, DropRuleList) -> ProbAddition
%% Type = superb | normal
%% DropRuleList = [#drop_rule_task{}]
%% ProbAddition = integer()
%% @doc 获取极品物品掉率增量 返回0意为维持原来概率
get_global_drop_rule_prob(superb, [#drop_rule_prog{prog = Prog, type = Type, time_start = Begin, time_end = End} | T]) ->
    Now = util:unixtime(),
    case (Type =:= 0 orelse Type =:= 1) andalso Now >= Begin andalso Now =< End of
        true ->
            (Prog - 100) + get_global_drop_rule_prob(superb, T);
        false ->
            get_global_drop_rule_prob(superb, T)
    end;
get_global_drop_rule_prob(superb, []) ->
    0;
get_global_drop_rule_prob(normal, [#drop_rule_prog{prog = Prog, type = Type, time_start = Begin, time_end = End} | T]) ->
    Now = util:unixtime(),
    case Type =:= 2 andalso Now >= Begin andalso Now =< End of
        true ->
            (Prog - 100) + get_global_drop_rule_prob(superb, T);
        false ->
            get_global_drop_rule_prob(superb, T)
    end;
get_global_drop_rule_prob(normal, []) ->
    0.

%% @spec produce_normal(Type, NpcIdList) -> NpcItemList
%% Type = all | two
%% NpcId = integer()
%% NpcItemList = [{NpcId, ItemIdList}]
%% @doc 计算怪物产出物品
%% Type类型 all:从第一次普通物品开始算起 | two:从第二次普通物品开始算起
produce_normal(all, [NpcId | T]) ->
    ItemIdList = produce_normal_by_npcid(all, NpcId),
    Rs = produce_normal(all, T),
    [{NpcId, ItemIdList} | Rs];
produce_normal(two, [NpcId | T]) ->
    ItemIdList = produce_normal_by_npcid(two, NpcId),
    Rs = produce_normal(two, T),
    [{NpcId, ItemIdList} | Rs];
produce_normal(_Type, []) ->
    [].

produce_fragile([NpcId | T]) ->
    ItemIdList = produce_fragile_by_npcid(NpcId),
    Remain = produce_fragile(T),
    [{NpcId, ItemIdList} | Remain];
produce_fragile([]) -> [].

produce_fragile_by_npcid(NpcId) ->
    case drop_data_mgr:get_prob(NpcId) of
        {ok, #drop_rule_prob_base{fragile_prob = FrageileProb}} ->
            case produce_fragile_by_prob(NpcId, FrageileProb) of
                -1 ->
                    [];
                ItemId ->
                    [ItemId]
            end;
        {false, _R} ->
            []
    end.

%% @spec produce_normal_by_npcid(Type, NpcId) -> ItemIdList
%% Type = all | two
%% NpcId = integer()
%% ItemIdList = [integer()]
%% @doc 计算单个怪物产生普通物品列表, 类型 all:从第一次普通物品开始算起 | two:从第二次普通物品开始算起
produce_normal_by_npcid(all, NpcId) ->
    case drop_data_mgr:get_prob(NpcId) of
        {ok, #drop_rule_prob_base{first_prob = FirstProb, second_prob = SecProb, third_prob = ThdProb}} ->
            case produce_normal_by_prob(NpcId, FirstProb) of
                -1 ->
                    [];
                FItemId ->
                    case produce_normal_by_prob(NpcId, SecProb) of
                        -1 ->
                            [FItemId];
                        SItemId ->
                            case produce_normal_by_prob(NpcId, ThdProb) of
                                -1 ->
                                    [FItemId, SItemId];
                                TItemId ->
                                    [FItemId, SItemId, TItemId]
                            end
                    end
            end;
        {false, _Reason} ->
            ?DEBUG("不存在掉落触发率基础信息[NpcId:~w]", [NpcId]),
            []
    end;

produce_normal_by_npcid(two, NpcId) ->
    case drop_data_mgr:get_prob(NpcId) of
        {ok, #drop_rule_prob_base{second_prob = SecProb, third_prob = ThdProb}} ->
            case produce_normal_by_prob(NpcId, SecProb) of
                -1 ->
                    [];
                SItemId ->
                    case produce_normal_by_prob(NpcId, ThdProb) of
                        -1 ->
                            [SItemId];
                        TItemId ->
                            [SItemId, TItemId]
                    end
            end;
        {false, _Reason} ->
            ?DEBUG("不存在掉落触发率基础信息[NpcId:~w]", [NpcId]),
            []
    end.

%% @spec produce_normal_by_prob(NpcId, Prob) -> ItemId
%% NpcId = integer()
%% Prob = integer()
%% ItemId = integer()
%% @doc 根据NpcId的掉落率,产生出该NpcId对应的一个物品ID
produce_normal_by_prob(NpcId, Prob) ->
    Num = util:rand(1, 10000),
    case Num =< Prob of
        true -> 
            ItemId = get_domain_item(normal, NpcId),
            ItemId;
        false ->
            -1
    end.

produce_fragile_by_prob(NpcId, Prob) ->
    Num = util:rand(1, 10000),
    case Num =< Prob of
        true -> 
            ItemId = get_domain_item(fragile, NpcId),
            ItemId;
        false ->
            -1
    end.

%% @hidden 测试使用
%% @doc 创建NpcId列表
make_npcids(NpcId, Num) ->
    case Num > 0 of
        true ->
            [NpcId | make_npcids(NpcId, Num - 1)];
        false ->
            []
    end.

%% 发物品到背包里 
%% 极品
add_item(sup, Role, [{_NpcId, -1} | T]) ->
    add_item(sup, Role, T);
add_item(sup, Role, [{NpcId, ItemId} | T]) when ItemId =/= -1->
    case drop_data_mgr:get_superb(NpcId, ItemId) of
        {ok, #drop_rule_superb_base{bind = Bind, notice = Notice}} ->
            case storage:make_and_add_fresh(ItemId, Bind, 1, Role) of
                {ok, NewRole, _} ->
                    case Notice of
                        1 -> 
                            role_gain:do_misc([{drop_notice, {NpcId, ItemId, Bind}}], NewRole);
                        _ -> ignore 
                    end,
                    add_item(sup, NewRole, T);
                {make_error, _Reason} ->
                    ?DEBUG("产生物品出错了[ItemId:~w]:~s", [ItemId, _Reason]),
                    add_item(sup, Role, T);
                {add_error, _Reason} ->
                    ?DEBUG("添加物品出错了[ItemId:~w]:~s", [ItemId, _Reason]),
                    add_item(sup, Role, T)
            end;
        _ ->
            ?DEBUG("没有找到极品掉落的基础信息[NpcId:~w ItemId:~w]:~s", [NpcId, ItemId]),
            add_item(sup, Role, T)
    end;
add_item(sup, Role, []) ->
    Role;

%% 普通的
add_item(normal, Role, [{NpcId, ItemList} | T]) ->
    NewRole = add_item(item_list, NpcId, Role, ItemList),
    add_item(normal, NewRole, T);
add_item(normal, Role, []) ->
    Role.

%% 物品列表
add_item(item_list, NpcId, Role, [ItemId | T]) ->
    case drop_data_mgr:get_normal(NpcId, ItemId) of
        {ok, #drop_rule_normal_base{bind = Bind, notice = Notice}} ->
            case storage:make_and_add_fresh(ItemId, Bind, 1, Role) of
                {ok, NewRole, _} ->
                    case Notice of
                        1 -> 
                            role_gain:do_misc([{drop_notice, {NpcId, ItemId, Bind}}], NewRole);
                        _ -> ignore 
                    end,
                    add_item(item_list, NpcId, NewRole, T);
                {make_error, _Reason} ->
                    ?DEBUG("产生物品出错了[ItemId:~w]:~s", [ItemId, _Reason]),
                    add_item(item_list, NpcId, Role, T);
                {add_error, _Reason} ->
                    ?DEBUG("添加物品出错了[ItemId:~w]:~s", [ItemId, _Reason]),
                    add_item(item_list, NpcId, Role, T)
            end;
        _ ->
            ?DEBUG("没有找到普通掉落的基础信息[NpcId:~w ItemId:~w]:~s", [NpcId, ItemId]),
            add_item(item_list, NpcId, Role, T)
    end;
add_item(item_list, _NpcId, Role, []) ->
    Role.

%% 过滤多余数据
filter(superb, []) -> [];
filter(superb, [{NpcBaseId, ItemBaseId} | T]) ->
    case ItemBaseId > 0 of
        false -> filter(superb, T);
        true -> 
            case drop_data_mgr:get_superb(NpcBaseId, ItemBaseId) of
                {ok, #drop_rule_superb_base{bind = BindRate, notice = Notice}} ->
                    Bind = calc_bind(BindRate),
                    Misc = case Notice of
                        1 -> [{drop_notice, {NpcBaseId, ItemBaseId, Bind}}];
                        2 -> [{drop_notice2, {NpcBaseId, ItemBaseId, Bind}}];
                        _ -> []
                    end,
                    [{NpcBaseId, #gain{label = item, val = [ItemBaseId, Bind, 1], misc = Misc}} | filter(superb, T)];
                _ ->
                    ?DEBUG("[掉落]极品掉落没找到对应的设置信息[NpcBaseId:~w,  ItemBaseId:~w]", [NpcBaseId, ItemBaseId]),
                    filter(superb, T)
            end
    end;

filter(normal, []) -> [];
filter(normal, [{NpcBaseId, ItemList} | T]) when is_list(ItemList) ->
    NewItemList = [ItemBaseId || ItemBaseId <- ItemList, ItemBaseId > 0],
    case length(NewItemList) > 0 of
        true -> [{NpcBaseId, make_normal_gain(NpcBaseId, NewItemList)} | filter(normal, T)];
        false -> [{NpcBaseId, []} |filter(normal, T)]
    end;
filter(normal, [{_NpcBaseId, _ItemList} | T]) ->
    filter(normal, T);

filter(fragile, []) -> [];
filter(fragile, [{NpcBaseId, ItemList} | T]) when is_list(ItemList) ->
    NewItemList = [ItemBaseId || ItemBaseId <- ItemList, ItemBaseId > 0],
    case length(NewItemList) > 0 of
        true -> [{NpcBaseId, make_fragile_gain(NpcBaseId, NewItemList)} | filter(fragile, T)];
        false -> [{NpcBaseId, []} | filter(fragile, T)]
    end;
filter(fragile, [{_NpcBaseId, _ItemList} | T]) ->
    filter(fragile, T).

make_normal_gain(NpcBaseId, [ItemBaseId | T]) ->
    case drop_data_mgr:get_normal(NpcBaseId, ItemBaseId) of
        {ok, #drop_rule_normal_base{bind = BindRate, notice = Notice}} ->
            Bind = calc_bind(BindRate),
            Misc = case Notice of
                1 -> [{drop_notice, {NpcBaseId, ItemBaseId, Bind}}];
                2 -> [{drop_notice2, {NpcBaseId, ItemBaseId, Bind}}];
                _ -> []
            end,
            [#gain{label = item, val = [ItemBaseId, Bind, 1], misc = Misc} | make_normal_gain(NpcBaseId, T)];
        _ ->
            ?DEBUG("[掉落]普通掉落没找到对应的设置信息[NpcBaseId:~w,  ItemBaseId:~w]", [NpcBaseId, ItemBaseId]),
            make_normal_gain(NpcBaseId, T)
    end;
make_normal_gain(_NpcBaseId, []) ->
    [].


make_fragile_gain(NpcBaseId, [ItemBaseId | T]) ->
    case drop_data_mgr:get_fragile(NpcBaseId, ItemBaseId) of
        {ok, #drop_rule_normal_base{notice = Notice}} ->
            Misc = case Notice of
                1 -> [{drop_notice, {NpcBaseId, ItemBaseId, 0}}];
                2 -> [{drop_notice2, {NpcBaseId, ItemBaseId, 0}}];
                _ -> []
            end,

            [#gain{label = fragile, val = [ItemBaseId, 1], misc = Misc} | make_fragile_gain(NpcBaseId, T)];
        _ ->
            ?DEBUG("[掉落]普通掉落没找到对应的设置信息[NpcBaseId:~w,  ItemBaseId:~w]", [NpcBaseId, ItemBaseId]),
            make_fragile_gain(NpcBaseId, T)
    end;
make_fragile_gain(_NpcBaseId, []) ->
    [].

%% 转换宠物物品
convert_pet_item([], Res) -> Res;
convert_pet_item([{NpcId, ItemId} | T], Res) when is_integer(ItemId) ->
    Converted = do_convert_pet_item(ItemId),
    convert_pet_item(T, [{NpcId, Converted} | Res]);
convert_pet_item([{NpcId, ItemIdList} | T], Res) when is_list(ItemIdList) ->
    Converted = [do_convert_pet_item(ItemId) || ItemId <- ItemIdList],
    convert_pet_item(T, [{NpcId, Converted} | Res]).

do_convert_pet_item(ItemId) ->
    case lists:member(ItemId, ?PET_IDS) of
        true ->
            PetItemIds = drop_data:all_pet_item_by_id(ItemId),
            lists:nth(util:rand(1, length(PetItemIds)), PetItemIds);
        false ->
            ItemId
    end.

%% 过滤多余数据GM命令
filter4gm(superb, []) -> [];
filter4gm(superb, [{NpcBaseId, ItemBaseId} | T]) ->
    case ItemBaseId > 0 of
        false -> filter4gm(superb, T);
        true -> [{NpcBaseId, ItemBaseId} | filter4gm(superb, T)]
    end;
filter4gm(normal, []) -> [];
filter4gm(normal, [{NpcBaseId, ItemList} | T]) when is_list(ItemList) ->
    NewItemList = [ItemBaseId || ItemBaseId <- ItemList, ItemBaseId > 0],
    case length(NewItemList) > 0 of
        true -> [{NpcBaseId, NewItemList} | filter4gm(normal, T)];
        false -> [{NpcBaseId, []} |filter4gm(normal, T)]
    end;
filter4gm(normal, [{_NpcBaseId, _ItemList} | T]) ->
    filter4gm(normal, T).

%% 计算绑定数值
calc_bind(BindRate) ->
    case util:rand(1, 10000) =< BindRate of
        true -> 1;
        false -> 0
    end.
