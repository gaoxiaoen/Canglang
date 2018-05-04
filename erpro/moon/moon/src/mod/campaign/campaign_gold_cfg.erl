%%----------------------------------------------------
%% 活动晶钻消费监听事件处理
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(campaign_gold_cfg).
-export([check/3]).

%% @spec check(Mod, Cmd, Date) -> false | Label
%% Mod = atom()     协议模块名
%% Cmd = integer()  协议号
%% Data = tuple{}   协议参数
%% 返回值说明
%%     false 过滤 不算入所有消费中
%%     Label = atom() 消费类型标识 算入所有消费中
%% 不算入消费模块协议过滤
check(market_rpc, _Cmd, _Data) -> false; %% 市场模块
check(wanted_rpc, _Cmd, _Data) -> false; %% 通缉模块
check(_Mod, 14013, _Data) -> false;      %% 投资飞仙基金

%% 需要监听事件
check(blacksmith_rpc, _Cmd, _Data) -> shop; %% 加工/强化模块 当商城
check(campaign_rpc, _Cmd, _Data) -> shop; %% 活动模块
check(_Mod, 12033, _Data) -> shop_camp; %% 活动商城
check(_Mod, 12034, _Data) -> shop_camp; %% 活动商城
check(shop_rpc, _Cmd, _Data) -> shop; %% 商城模块
check(_Mod, 12404, _Data) -> shop; %% VIP卡购买使用模块
check(_Mod, 12670, _Data) -> shop; %% 魔晶物品洗炼
check(_Mod, 12671, _Data) -> shop; %% 魔晶物品洗炼

%% 寻宝
check(casino_rpc, _Cmd, _Data) -> casino; %% 寻宝模块

%% 神秘商店
check(npc_store_rpc, _Cmd, _Data) -> npc_store_sm; %% 商店模块

%% 猎魔
check(_Mod, 12661, _Data) -> pet_magic; %% 召唤猎魔NPC
check(_Mod, 12662, _Data) -> pet_magic; %% 猎魔

%% 翅膀
check(_Mod, 16708, _Data) -> wing_skill_gold;  %% 翅膀技能刷新

%% 守护
check(_Mod, 17225, _Data) -> demon_skill_gold; %% 神通技能刷新

%% 灵戒洞天
check(_Mod, 17901, _Data) -> soul_world_call_gold; %% 召唤

%% 宠物蛋刷新
check(_Mod, 12614, _Data) -> refresh_pet_egg; %% 宠物蛋刷新

check(_Mod, _Cmd, _Data) -> other. %% 其它消费
