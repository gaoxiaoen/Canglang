%%----------------------------------------------------
%% 中庭战神数据结构定义
%% @author shawn 
%%----------------------------------------------------

-define(arena_career_lev, 16).  %% 功能开放等级

-define(arena_career_lose, 0). %% 输
-define(arena_career_win, 1). %% 赢

-define(arena_career_rank_down, 0). %% 排名下降
-define(arena_career_rank_normal, 1). %% 排名不变
-define(arena_career_rank_up, 2). %% 排名上升

-define(award_time, 18 * 3600). %% 统计奖励时间

-define(award_career_times, 5). %% 每天基础可挑战次数
-define(arena_career_add_times_max, 1).  %% 付费购买挑战次数上限

-define(arena_career_cooldown, 600).  %% 挑战冷却时间(秒)，10分钟

-define(arena_career_map_id, 1028).   %% 场景
-define(arena_career_left_pos_x, 480).  %% 左边站位坐标
-define(arena_career_right_pos_x, 780).  %% 右边站位坐标

-define(arena_career_award_id, 106001).  %% 奖励base id

%% 赢奖励
-define(arena_career_combat_winner_award, [#gain{
        label = coin    
        ,val = 2000
    }, #gain{
        label = exp
        ,val = 1000
    }]).
%% 输奖励
-define(arena_career_combat_loser_award, [#gain{
        label = coin    
        ,val = 1000 
    }, #gain{
        label = exp
        ,val = 500
    }]).

%% 角色基础数据
-record(arena_career, {
        free_count = ?award_career_times     %% 免费次数
        ,pay_count = 0 %% 购买剩余次数
        ,pay_time = 0  %% 购买次数
        ,cooldown = 0  %% cd过期时间 
        ,last_time = 0 %% 上一次挑战时间
        ,latest_wins = 0  %% 最近5次挑战的胜利次数
        ,latest_result = []  %% 最近5次挑战的结果，如：[?win,?lost,?win,?lost,?win]
        ,target    %% 正在挑战的对手{roleid, srvid}
    }
).

%% 对战结果
-record(arena_career_result, {
        fight_rid
        ,fight_srv_id
        ,fight_name
        ,fight_career
        ,to_fight_rid
        ,to_fight_srv_id
        ,to_fight_name
        ,to_fight_career
        ,result               %% 挑战结果
    }
).

%% 对战日志
-record(arena_career_log, {
        fight_rid
        ,fight_srv_id
        ,fight_name
        ,result                  %% 对战结果
        ,to_fight_rid
        ,to_fight_srv_id
        ,to_fight_name             
        ,up_or_down             %% 排名变化
        ,rank                   %% 更新后的排名
        ,ctime                  %% 日志时间
    }
).

%% 角色竞技数据
-record(arena_career_role, {
        rid
        ,srv_id
        ,career                 %% 职业
        ,name                   %% 角色名
        ,rank                   %% 排名
        ,sex                    %% 性别
        ,lev                    %% 等级
        ,face                   %% 头像
        ,hp_max                 %% 血量上限
        ,mp_max                 %% 法力上限
        ,attr                   %% 属性
        ,looks                  %% 外观
        ,eqm                    %% 装备列表
        ,pet_bag                %% 宠物列表 
        ,skill                 %% 技能列表
        ,fight_capacity = 1     %% 战斗力
        ,ascend                 %% 职业进阶
        ,con_wins = 0           %% 连胜次数
        ,award_rank = 0         %% 领取奖励时的排名，领取奖励后清0
        ,max_con_wins = 0       %% 最大连胜记录
        ,last_sign_time =0      %% 最后登记时间
    }
).

%% 跨服角色数据
-record(c_arena_career_role, {
        id
        ,rid
        ,srv_id
        ,name                   %% 角色名
        ,career                 %% 职业
        ,rank                   %% 排名
        ,sex                    %% 性别
        ,lev                    %% 等级
        ,face                   %% 头像
        ,hp                     %% 血量
        ,mp                     %% 法力
        ,hp_max                 %% 血量上限
        ,mp_max                 %% 法力上限
        ,attr                   %% 属性
        ,looks                  %% 外观
        ,eqm                    %% 装备列表
        ,pet_bag                %% 宠物列表 
        ,skill                 %% 技能列表
        ,fight_capacity = 1     %% 战斗力
        ,ascend                 %% 职业进阶
    }
).
