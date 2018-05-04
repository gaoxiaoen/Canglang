



%%----------------------------------------------------
%% 掉落系统数据
%%              
%%----------------------------------------------------
-module(drop_data).
-export([
        get_prob/1
        ,get_superb/2
        ,get_normal/2
        ,get_superb_items/1
        ,get_normal_items/1
        ,career_item/2
		,all_pet_item_by_id/1
		
        ,get_time/1
        ,get_prob_open/1
        ,get_superb_open/2
        ,get_normal_open/2
        ,get_superb_items_open/1
        ,get_normal_items_open/1

        ,get_period/1
        ,get_prob_act/1
        ,get_superb_act/2
        ,get_normal_act/2
        ,get_superb_items_act/1
        ,get_normal_items_act/1
		
		,get_pet_item/1
	   ,pet_item_type/0
	   
	   ,get_fragile_items/1
	   ,get_fragile/2
    ]
).
-include("drop.hrl").

%% 获取怪物ID对应的极品物品列表
%% @spec get_superb_items(NpcId) -> ItemList
%% NpcId = integer() 怪物ID
%% ItemList = list() of integer() 极品物品ID列表
get_superb_items(_NpcId) ->
    [].

%% 获取怪物ID对应的普通物品列表
%% @spec get_normal_items(NpcId) -> ItemList
%% NpcId = integer() 怪物ID
%% ItemList = list() of integer() 普通物品ID列表
get_normal_items(_NpcId) ->
    [].


%% 获取怪物ID对应的碎片
%% @spec get_fragile_items(NpcId) -> ItemList
%% NpcId = integer() 怪物ID
%% ItemList = list() of integer() 普通物品ID列表
get_fragile_items(_NpcId) ->
    [].	
	
	
%% 获取掉落触发率基础信息
%% @spec get_prob(NpcId) -> {ok, ProbBase} | {false, Reason}
%% NpcId = integer() 怪物ID
%% ProbBase = #drop_rule_prob_base{} 掉落触发率基础信息
%% Reason = binary() 失败原因
get_prob(_ItemId) ->
    {false, <<"不存在此记录">>}.

%% 极品装备掉落数据
%% @spec get_superb(NpcId, ItemId) -> {ok, SuperbBase} | {false, Reason}
%% NpcId = integer() 怪物ID
%% ItemId = integer() 物品ID
%% SuperbBase = #drop_rule_superb_base{} 极品装备掉落数据
get_superb(_NpcId, _ItemId) ->
    {false, <<"不存在此记录">>}.

%% 普通装备掉落数据
%% @spec get_normal(NpcId, ItemId) -> {ok, NormalBase} | {false, Reason}
%% NpcId = integer() 怪物ID
%% ItemId = integer() 物品ID
%% NormalBase = #drop_rule_normal_base{} 普通装备掉落数据
%% Reason = binary() 失败原因

get_normal(_NpcId, _ItemId) ->
    {false, <<"不存在此记录">>}.

%% 碎片掉落
%% @spec get_fragile(NpcId, ItemId) -> {ok, NormalBase} | {false, Reason}
%% NpcId = integer() 怪物ID
%% ItemId = integer() 物品ID
%% NormalBase = #drop_rule_normal_base{} 普通装备掉落数据
%% Reason = binary() 失败原因

get_fragile(_NpcId, _ItemId) ->
    {false, <<"不存在此记录">>}.	
	
	
%% @spec career_item(PresentId, Career) -> {ok, DropRuleCareer::#drop_rule_career{}} | {false, Reason::binary()}
%% 职业物品
career_item(_PresentId, _Career) ->
    {false, util:fbin(<<"职业物品没有找到相应信息[~w, ~w]">>, [_PresentId, _Career])}.

all_pet_item_by_id(_Id)->
	[].	
	

%%------------------------------------------------------
%% 开服配置
%%------------------------------------------------------

get_time(_NpcId) ->
    undefined.

get_superb_items_open(_NpcId) ->
    undefined.


get_normal_items_open(_NpcId) ->
    undefined.
    
%% 获取掉落触发率基础信息
%% @spec get_prob_open(NpcId) -> {ok, ProbBase} | undefined
%% NpcId = integer() 怪物ID
%% ProbBase = #drop_rule_prob_base{} 掉落触发率基础信息
%% Reason = binary() 失败原因

get_prob_open(_ItemId) ->
    undefined.

%% 极品装备掉落数据
%% @spec get_superb_open(NpcId, ItemId) -> {ok, SuperbBase} | undefined
%% NpcId = integer() 怪物ID
%% ItemId = integer() 物品ID
%% SuperbBase = #drop_rule_superb_base{} 极品装备掉落数据

get_superb_open(_NpcId, _ItemId) ->
    undefined.

%% 普通装备掉落数据
%% @spec get_normal_open(NpcId, ItemId) -> {ok, NormalBase} | undefined
%% NpcId = integer() 怪物ID
%% ItemId = integer() 物品ID
%% NormalBase = #drop_rule_normal_base{} 普通装备掉落数据
%% Reason = binary() 失败原因

get_normal_open(_NpcId, _ItemId) ->
    undefined.


%%------------------------------------------------------
%% 活动配置
%%------------------------------------------------------
%% 获取该Npc的活动掉落时间区间
%% spec get_period(NpcId) -> PeriodList | undefined
%% NpcId = integer() 怪物ID
%% PeriodList = [{{Y,M,D,h,m,s}, {Y,M,D,h,m,s}}]

get_period(_NpcId) ->
    undefined.

%% 获取怪物ID对应的极品物品列表
%% @spec get_superb_items_act(NpcId) -> ItemList | undefined
%% NpcId = integer() 怪物ID
%% ItemList = list() of integer() 极品物品ID列表
get_superb_items_act(_NpcId) ->
    undefined.

%% 获取怪物ID对应的普通物品列表
%% @spec get_normal_items_act(NpcId) -> ItemList | undefined
%% NpcId = integer() 怪物ID
%% ItemList = list() of integer() 普通物品ID列表
get_normal_items_act(_NpcId) ->
    undefined.
    
%% 获取掉落触发率基础信息
%% @spec get_prob_act(NpcId) -> {ok, ProbBase} | undefined
%% NpcId = integer() 怪物ID
%% ProbBase = #drop_rule_prob_base{} 掉落触发率基础信息
%% Reason = binary() 失败原因
get_prob_act(_ItemId) ->
    undefined.

%% 极品装备掉落数据
%% @spec get_superb_act(NpcId, ItemId) -> {ok, SuperbBase} | undefined
%% NpcId = integer() 怪物ID
%% ItemId = integer() 物品ID
%% SuperbBase = #drop_rule_superb_base{} 极品装备掉落数据
get_superb_act(_NpcId, _ItemId) ->
    undefined.

%% 普通装备掉落数据
%% @spec get_normal_act(NpcId, ItemId) -> {ok, NormalBase} | undefined
%% NpcId = integer() 怪物ID
%% ItemId = integer() 物品ID
%% NormalBase = #drop_rule_normal_base{} 普通装备掉落数据
%% Reason = binary() 失败原因
get_normal_act(_NpcId, _ItemId) ->
    undefined.

get_pet_item(_Id) -> [].

pet_item_type() -> [].	
	
	
	
