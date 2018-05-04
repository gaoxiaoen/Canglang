%----------------------------------------------------
%% 世界树相关数据结构定义
%% @author mobin
%%----------------------------------------------------

-define(forward, 1).
-define(charge, 2).
-define(box, 3).
-define(boss, 4).
-define(lose, 5).   %%战斗失败状态
-define(limit, 10).   %%顶层，只用于协议13602

-define(exp, 1).
-define(coin, 2).
-define(material, 3).
-define(strange, 4).

%% 玩家数据
-record(tree_role, {
        rid                 %% 玩家id
        ,floor = 0          %% 层数
        ,status = ?forward  %% 状态
        ,exp = 0            %% 经验
        ,coin = 0           %% 金币
        ,material = 0       %% 材料数
        ,strange = 0        %% 奇怪物品数
        ,material_items = [] %% [{BaseId, Bind, Count}]
        ,strange_items = [] %% [{BaseId, Bind, TaskId}]
        ,stage = 0          %% 当前阶段
        ,is_clear = 0       %% 是否已通过当前阶段
        ,last = 0
        ,best_stage = 0     %%已通过的最高阶段
        ,is_lose = 0        %%是否已输       
}).

-record(tree_stage, {
        id
        ,boss_id
        ,kill_odds
        ,exp
        ,coin
        ,strange_limit
        ,weights
        ,boss_coin
        ,boss_exp
        ,boss_material_odds
        ,boss_strange_odds
}).
