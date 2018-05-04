%%----------------------------------------------------
%% 掉落规则数据结构定义
%% 
%% @author yeahoo2000@gmail.com, yqhuang*
%%----------------------------------------------------

%% 掉落触发率基础信息 
-record(drop_rule_prob_base, {
        npc_id = 0          %% 怪物ID
        ,superb_prob = 0    %% 极品触发率 概率分母为10000
        ,first_prob = 0     %% 第一次掉落触发率 概率分母为10000
        ,second_prob = 0    %% 第二次掉落触发率 概率分母为10000
        ,third_prob = 0     %% 第三次掉落触发率 概率分母为10000
        ,fragile_prob = 0   %% 妖精碎片掉落触发率
    }
).

%% 极品装备掉落数据
-record(drop_rule_superb_base, {
        npc_id = 0          %% 怪物ID
        ,item_id = 0        %% 物品ID
        ,domain = 0         %% 概率分子
        ,time_limit = 0     %% 限制时间
        ,upper_limit = 0    %% 时间内个数上限
        ,num_limit = 0      %% 限制次数
        ,bind = 0           %% 是否绑定[0:不绑定 1:绑定]
        ,notice = 0         %% 是否公告[0:不公告 1:公告]
        ,music = 0          %% 是否有音效[0:没有音效 1:有音效]
    }
).

%% 普通装备掉落数据
-record(drop_rule_normal_base, {
        npc_id = 0          %% 怪物ID
        ,item_id = 0        %% 物品ID
        ,domain = 0        %% 概率分子
        ,bind = 0           %% 是否绑定[0:不绑定 1:绑定]
        ,notice = 0         %% 是否公告[0:不公告 1:公告]
        ,music = 0          %% 是否有音效[0:没有音效 1:有音效]
    }
).

%% 极品装备掉落进程
-record(drop_rule_superb_prog, {
        npc_id = 0          %% 怪物ID
        ,item_id = 0        %% 物品基础ID
        ,time_limit = 0     %% 限制时间
        ,time_start = 0     %% 本轮开始计算时间
        ,upper_limit = 0    %% 时间内个数上限
        ,drop_num = 0       %% 掉落数
        ,num_limit = 0      %% 限制斩杀次数内只能产生一件极品物品
        ,kill_num = 0       %% 怪物杀死次数
        ,modified  = 1      %% 修改标志位，用于标识是否需保存到数据库中0:未修改 1:已修改 
    }
).

%% 掉落概率 全局
-record(drop_rule_prog, {
        key                 %% 掉落规则key,不可以出现重复的掉落规则
        ,prog = 100         %% 掉落概率加成 100为不变
        ,type = 1           %% 0:全部装备 1:极品装备 2:普通装备
        ,time_start = 0     %% 开始时间
        ,time_end = 0       %% 结束时间
    }
).

%% 任务物品掉落规则
-record(drop_rule_task, {
        task_id = 0         %% 任务ID
        ,npc_id = 0         %% 梆定的NPC
        ,item_id = 0        %% 物品基础ID
        ,num = 0            %% 掉落总量
        ,prob = 0           %% 掉落概率
    }
).

%% 掉落物品
-record(drop_rule_career, { 
        present_id = 0          %% 礼包ID
        ,career = 0             %% 职业
        ,item_id = 0            %% 物品ID
        ,bind = 0               %% 是否绑定[0:不绑定 1:绑定]
        ,notice = 0             %% 公告[0:不公告 1:公告]
    }
).

-define(DROP_SUPERB_PROB, 10000).    %% 装备概率分母
