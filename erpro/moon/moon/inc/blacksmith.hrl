%%----------------------------------------------------
%% 锻造系统 
%%
%% @author Shawn
%%----------------------------------------------------

%% 仙玉强化类型
-define(weapon_type, [ ?item_weapon, ?item_hu_fu, ?item_xiang_lian, ?item_jie_zhi ]
).

%% 灵石强化类型
-define(armor_type, [
        ?item_hu_shou, ?item_hu_wan, ?item_yao_dai, ?item_xie_zi, ?item_yi_fu, ?item_ku_zi       
    ]).

%% 仙玉ID列表
-define(jade_list, [21000, 21001, 21002]).
%% 灵石ID列表
-define(stone_list, [21010, 21011, 21012]).

%% 可打孔类型
-define(blacksmith_hole, [
        ?item_weapon, ?item_hu_wan, ?item_yi_fu, ?item_ku_zi, ?item_xie_zi, ?item_yao_dai, ?item_hu_shou,
        ?item_hu_fu, ?item_jie_zhi, ?item_xiang_lian ]
).

%% 神佑
-define(MAX_GS_LEV, 20). %% 升级最高级
-define(MAX80_GS_LEV, 15). %% 80级升级最高级
-define(MAX70_GS_LEV, 10). %% 70级升级最高级
