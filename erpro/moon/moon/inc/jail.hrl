%%---------------------------------------------------
%% 雪山地牢相关数据结构定义
%% @author mobin
%%----------------------------------------------------

-define(forward, 1).
-define(gamble, 2).   %%走到了牢门前
-define(prepare, 3). %%已抽取Boss
-define(attack, 4). %%战斗中
-define(lose, 5). %%已失败

-define(jail_map_id, 190).
-define(combat_map_id, 191).
-define(jail_x, 420).
-define(jail_y, 420).

%% 玩家数据
-record(jail_role, {
        rid                 %% 玩家id
        ,floor = 1          %% 层数
        ,status = ?forward  %% 状态
        ,life = 0           %% 命
        ,left_time = 0           %% 剩余时间(秒)
        ,bosses = []
        ,last = 0
        ,left_count = 2           %% 剩余次数
        ,anti_stun = 0      %% 抗眩晕
        ,anti_taunt = 0     %% 抗嘲讽
        ,anti_sleep = 0     %% 抗睡眠
        ,anti_stone = 0     %% 抗冰封
        ,best_floor = 0     %% 历史最好
}).
