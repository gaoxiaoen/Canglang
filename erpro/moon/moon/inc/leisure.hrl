%%----------------------------------------------------
%% 休闲玩法相关数据结构定义
%% 
%% @author wangweibiao
%%----------------------------------------------------

%% 动作类型
-define(energy, 1).    %% 蓄力
-define(attack, 2).    %% 攻击
-define(defence, 3).   %% 格挡

-define(max_energy, 5). %%最大的蓄力次数

%% 副本星星目标
-record(leisure_goal, {
        id = 0,                 %% 目标id , 也评分等级
        npc_hp_left = 0, 		%% npc 剩余血量
        role_hp_left = 0, 		%% 人物 剩余血量
    	round = 0, 				%% 回合数
    	kill_npc = 0			%% 回合数
}).

%% 动作类型
-record(act, {
		id = 0,  				%% 动作的序号
        type = 0,               %% 动作类型
        power = 0,              %% 伤害值
        is_crit = 0             %% 伤害类型 0:普通 1:暴击 2:格挡
}).
