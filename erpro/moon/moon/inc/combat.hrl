%%----------------------------------------------------
%% 战斗相关数据结构定义
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------

-define(default_max_round, 255).    %% 最大回合数
-define(combat_group_len, 3).         %% 战斗站位数

%-define(skill_attack, 100).     %% 普攻技能ID
%-define(skill_escape, 110).     %% 逃跑技能ID
%-define(skill_item, 120).       %% 使用物品技能ID

-define(dmg_type_physical, 0).  %% 物理伤害
-define(dmg_type_magic, 1).     %% 法术伤害
-define(dmg_type_etc, 2).       %% 其它类型

-define(attack_type_melee, 0).  %% 近程伤害
-define(attack_type_range, 1).  %% 远程伤害
-define(attack_type_pet, 2).  %% 宠物施法伤害

-define(elem_type_none, 0).     %% 五行属性：无
-define(elem_type_metal, 1).    %% 金属性攻击
-define(elem_type_wood, 2).     %% 木属性攻击
-define(elem_type_water, 3).    %% 水属性攻击
-define(elem_type_fire, 4).     %% 火属性攻击
-define(elem_type_earth, 5).    %% 土属性攻击

-define(fighter_type_role, 0).  %% 角色
-define(fighter_type_npc, 1).   %% NPC
-define(fighter_type_pet, 2).   %% 宠物
-define(fighter_type_demon, 3). %% 契约兽

-define(fighter_subtype_common, 0).  %% 一般类型
-define(fighter_subtype_story,  1).   %% 剧情npc
-define(fighter_subtype_demon,  2).   %% 契约兽npc
-define(fighter_subtype_wanted,  3).   %% 玩家海盗
-define(fighter_subtype_demon_virtual_role,  4).   %% 妖精碎片掠夺虚拟玩家
-define(fighter_subtype_demon_real_role,  5).   %% 妖精碎片掠夺真实玩家


-define(combat_result_win, 1).      %% 个人战斗结果：战斗胜利
-define(combat_result_lost, 0).     %% 个人战斗结果：战斗失败
-define(combat_result_escape, 2).   %% 个人战斗结果：战斗逃离
-define(combat_result_abort, 3).    %% 战斗结果：战斗中止

-define(c_world_compete_result_draw, 0).            %% 仙道会战斗结果：平局
-define(c_world_compete_result_ko_perfect, 1).      %% 仙道会战斗结果：完胜
-define(c_world_compete_result_ko, 2).              %% 仙道会战斗结果：险胜
-define(c_world_compete_result_loss_perfect, 3).    %% 仙道会战斗结果：完败
-define(c_world_compete_result_loss, 4).            %% 仙道会战斗结果：小败

-define(combat_round_result_draw_game, 0).        %% 战斗结果：平局
-define(combat_round_result_atk_win, 1).          %% 战斗结果：进攻方获胜
-define(combat_round_result_dfd_win, 2).          %% 战斗结果：防守方获胜
-define(combat_round_result_next, 3).             %% 战斗结果：继续下一个回合

-define(enter_combat_type_normal, 0).       %% 进入战斗方式：正常进入
-define(enter_combat_type_playing, 1).      %% 进入战斗方式：播放未完成
-define(enter_combat_type_play_done, 2).    %% 进入战斗方式：播放完成（选招）

-define(skill_type_passive, 0).     %% 技能类型：被动
-define(skill_type_active, 1).      %% 技能类型：主动
-define(skill_type_assist, 2).      %% 技能类型：辅助
-define(skill_type_lineup, 3).      %% 技能类型：阵法
-define(skill_type_anger, 4).       %% 技能类型：怒气
-define(skill_type_anger_passive, 5).   %% 技能类型：怒气被动
-define(skill_type_partner, 10).   %% 技能类型：夫妻主动
-define(skill_type_shape, 11).      %% 技能类型：精灵化形

-define(item_type_direct, 0).       %% 物品类型：可以直接使用（技能：“使用物品”），但是不能作为技能消耗
-define(item_type_skill, 1).        %% 物品类型：不能直接使用，仅供技能消耗
-define(item_type_both, 2).         %% 物品类型：既可以直接使用，又可以作为技能消耗

-define(passive_type_none, 0).          %% 被动触发类型：无
-define(passive_type_attack, 1).        %% 被动触发类型：主动攻击时
-define(passive_type_defence, 2).       %% 被动触发类型：被攻击时
-define(passive_type_hp_below, 3).      %% 被动触发类型：气血低于XXX时
-define(passive_type_hp_beyond, 4).     %% 被动触发类型：气血高于XXX时
-define(passive_type_die, 5).           %% 被动触发类型：死的时候
-define(passive_type_before_attack, 6).        %% 被动触发类型：主动攻击前

-define(passive_type_pre_action, 100).      %% 被动触发类型：每回合人物动作播放前
-define(passive_type_attack_dmg_hp, 110).   %% 被动触发类型：直接扣气血
-define(passive_type_attack_dmg_mp, 120).   %% 被动触发类型：直接扣魔法
-define(passive_type_attack_buff, 130).     %% 被动触发类型：攻击时施加BUFF

%% 战斗类型
%% 如果是跨服的，中间加一个'c'来表示
-define(combat_type_npc, 1).             %% 杀NPC - kill_npc
-define(combat_type_tree, 2).    %% 世界树
-define(combat_type_wanted_npc, 3).    %% 悬赏Boss NPC海盗
-define(combat_type_wanted_role, 4).    %% 悬赏Boss 玩家海盗
-define(combat_type_expedition, 5).    %% 远征王军
-define(combat_type_arena_career, 6).  %% 离线竞技(中庭战神)
-define(combat_type_trial, 7).          %% 试炼场
-define(combat_type_tutorial, 8).          %% 新手副本
-define(combat_type_survive, 9).          %% 生存模式 
-define(combat_type_time, 10).          %% 限时模式
-define(combat_type_leisure, 11).          %% 休闲模式
-define(combat_type_demon_challenge, 12).          %% 妖精碎片掠夺
-define(combat_type_compete, 13).          %% 竞技场模式
-define(combat_type_jail, 14).          %% 雪山地牢模式
-define(combat_type_guild_td, 15).      %% 帮会副本 - guild_td

%% 飞仙历史遗留
%% -define(combat_type_guild_td, 101).      %% 帮会副本 - guild_td
-define(combat_type_sworn, 102).              %% 生死结拜战斗
-define(combat_type_practice, 103).        %% 无尽的试炼
-define(combat_type_c_boss, 104).  %% 跨服boss
-define(combat_type_c_duel, 105).  %% 跨服决斗
-define(combat_type_c_ore, 106).  %% 跨服仙府
-define(combat_type_guild_monster, 107).  %% 帮会怪
-define(combat_type_train_rob, 110).    %% 飞仙历练
-define(combat_type_train_arrest, 111).    %% 飞仙历练
-define(combat_type_challenge, 112).      %% 切磋 - challenge
-define(combat_type_kill, 113).                %% 刺杀 - kill
-define(combat_type_rob_trade, 114).      %% 劫商 - rob_trade
-define(combat_type_rob_escort, 115).    %% 劫镖 - rob_escort
-define(combat_type_rob_escort_child, 116).    %% 劫镖小孩 - rob_escort_child
-define(combat_type_rob_escort_cyj, 117).    %% 劫镖重阳节美女 - rob_escort_cyj
-define(combat_type_arena, 118).        %% 竞技场 - arena_match
-define(combat_type_top_fight, 119).        %% 巅峰对决
-define(combat_type_guild_war, 120).      %% 帮战 - guild_war
-define(combat_type_guild_war_compete, 121).      %% 帮战主将赛 - guild_war_compete
-define(combat_type_guild_arena, 122).      %% 新帮战
-define(combat_type_guild_war_robot, 123).      %% 帮战内击杀机器人 - guild_war_robot
-define(combat_type_arena_robot, 124).  %% 竞技场杀NPC - arena_match_robot
-define(combat_type_c_arena_career, 125).  %% 挑战跨服排行榜杀模拟玩家的NPC
-define(combat_type_guild_arena_robot, 126).  %% 新帮战杀NPC - guild_arena_robot
-define(combat_type_c_world_compete, 127).  %% 跨服仙道会
-define(combat_type_cross_king, 128).  %% 至尊王者
-define(combat_type_lottery_secret, 129).    %% 幻灵秘境
-define(combat_type_cross_warlord, 130).    %% 武神坛 
-define(combat_type_guard_counter, 131).    %% 洛水反击小怪 

%% 主从关系
-define(ms_rela_none, 0).       %% 无
-define(ms_rela_employ, 1).     %% 雇佣兵
-define(ms_rela_escort, 2).     %% 被护送者
-define(ms_rela_story, 3).      %% 剧情安排

%% 世界boss类型
-define(world_boss_type_none, 0).      %% 不是boss
-define(world_boss_type_normal, 1).    %% 一般boss
-define(world_boss_type_super, 2).     %% 超级boss

%% 播放被动技能时机
-define(show_passive_skills_before, 0).     %% 前
-define(show_passive_skills_hit, 1).        %% 被命中时
-define(show_passive_skills_after, 2).      %% 后

-define(TIMEOUT_LOADING,     8000).     %% 加载超时时间
-define(MAX_PLAY_TIME, 4000).           %% 每一个参战者最长的播放等待时间(单位：毫秒)
-define(MIN_PLAY_TIME, 1500).           %% 每一个参战者最小的播放等待时间(单位：毫秒)
-define(TIME_END_CALC, 1200).              %% 结算面板显示时间(客户端用，单位：毫秒)
%% -define(TIMEOUT_END_CALC, 2000).        %% 结算面板超时时间(单位：毫秒)
-define(TIMEOUT_END_CALC, 0).        %% 结算面板超时时间(单位：毫秒)
-define(NO_COMBAT_TIME, 3000).          %% 战斗保护时间(战斗结束后的一小段时间内不能再战斗)
-define(FIRST_ROUND_AUTO_DELAY_TIME, 500).  %% 第一回合的延迟时间
-define(MAX_ANGER, 100).                %% 怒气最大值
-define(MAX_POWER, 10000).                %% 天威最大值

-define(combat_special_npc_kill_max, 1200).    %% 刷某些怪的每天上限

%% 战斗录像版本号
%% 注意：如果10710和10720有修改，则必须修改这个版本号，或者把保存录像的dets内容清了
-define(COMBAT_REPLAY_VER, 1).          %% 战斗录像当前版本号

%% 特殊信息类型
-define(combat_special_ms_rela, 0).     %% 主从关系
-define(combat_special_is_clone, 1).    %% 是否师门竞技里的克隆人
-define(combat_special_is_room_master, 2).  %% 是否房主
-define(combat_special_is_story_npc, 3).  %% 是否剧情npc
-define(combat_special_demon_master, 4).  %% 契约兽npc主人参战者id

-define(combat_range, 340).  %% 战斗线距离
-define(combat_distance, 300). %% 战斗中双方的距离
%-define(combat_upper_pos_y, 448).  %% 战斗上方站位y坐标, 640-192
%-define(combat_lower_pos_y, 576).  %% 战斗下方站位y坐标, 640-64

%% 一般站位
-define(combat_upper_pos_y, 416).  %% 战斗上方站位y坐标, 640-210-14
-define(combat_lower_pos_y, 496).  %% 战斗下方站位y坐标, 640-180-14

%% 多人副本
-define(combat_upper_pos_y2, 336).  %% 战斗上方站位y坐标, 640-290-14
-define(combat_middle_pos_y2, 416).  %% 战斗下方站位y坐标, 640-210-14
-define(combat_lower_pos_y2, 496).  %% 战斗下方站位y坐标, 640-130-14

%% 新手站位
-define(combat_upper_pos_y3, 496).  %% 战斗上方站位y坐标, 一般站位下移80
-define(combat_lower_pos_y3, 526).  %% 战斗下方站位y坐标, 一般站位下移80

-define(combat_miss, 2).   %% 闪避（完全不受伤害）
-define(combat_hit, 1).    %% =?true 命中(100%伤害)
-define(combat_parry, 0).    %% =?false 格挡(50%伤害)

-define(buff_immune, 2).   %% buff免疫
-define(buff_resist, 3).   %% buff抵抗

-define(EXEC_FUNC(Func, DefaultValue, Args),  %% 执行函数，如果函数为空，则返回默认值
    case Func of
        undefined -> DefaultValue;
        _ -> Func(Args)
    end).


%% 战斗进程状态数据结构
-record(combat, {
        type                %% 战斗类型
        ,pid = 0            %% 战斗进程ID
        ,round = 0          %% 当前回合数
        ,replay = 0         %% 是否需要录像
        ,referees = []      %% 裁判进程组  [{common, Pid1}, {dungeon_score, Pid2}...]
        ,ready = []         %% 已准备好参战的队员
        ,wait = []          %% 还未发送指令的参战队员
        ,die = []           %% 已战败的参战队员
        ,observer = []      %% 观战者列表
        ,live_srvs = []     %% 直播服务器ID列表 [bitstring()]
        ,ts = 0             %% 时间戳
        ,t_round = 15000    %% 回合时间
        ,t_idel = 0         %% 每回合最小播放时间
        ,t_play = 0         %% 每回合最小播放时间
        ,t_play_max = 0     %% 每回合最长播放时间

        ,over = false       %% 是否结束
        ,winner = []        %% 胜利者
        ,loser = []         %% 失败者
    }
).


%% 参战者数据结构
-record(fighter, {
        pid                 %% 角色进程ID或NPC进程ID
        ,type = ?fighter_type_role %% 参战者类型
        ,subtype = 0        %% 0 = 一般, 1 = 剧情npc
        ,rid = 0            %% 角色ID或NpcId或宠物Id
        ,base_id = 0        %% NpcBaseId或宠物BaseId
        ,srv_id = <<>>      %% 服务器标识，如果是NPC则此值为: npc，如果是宠物则此值为: pet
        ,name = <<>>        %% 角色名称或NPC名称
        ,sex = 0
        ,career = 0         %% 职业
        ,lev = 0            %% 等级
        ,hp = 1             %% 当前血量
        ,mp = 1             %% 当前魔量
        ,anger = 0          %% 当前怒气
        ,hp_max = 1         %% 血量上限
        ,mp_max = 1         %% 魔量上限
        ,anger_max = ?MAX_ANGER    %% 怒气上限
        ,attack_type = ?attack_type_melee   %% 默认攻击方式，对NPC有用
        ,last_skill = 0     %% 最近一次使用的技能ID
        ,shortcutlist = undefined %% 挂机技能列表
        ,portrait_id = 0    %% 角色头像id
        ,vip_type = 0       %% VIP类型
        ,power = 0          %% 当前天威值
        ,power_max = ?MAX_POWER %% 天威上限

        %% 战斗状态
        ,id                 %% 当前战斗中的编号
        ,group              %% atk_group | dfd_group 所在组，进攻方或防守方
        ,attr               %% 战斗属性 #attr{} 或 #pet_attr{}
        ,attr_ext           %% 扩展属性 #attr_ext{}
        ,is_auto = 0        %% 是否开启自动战斗
        ,is_hook = 0        %% 是否挂机中
        ,is_die = 0         %% 是否已经死亡
        ,is_escape = 0      %% 是否已经逃跑
        ,is_loaded = 0      %% 是否已经加载战场(对于未加载战场的需要自动出招)
        ,is_online = 1      %% 是否在线状态
        ,is_stun = 0        %% 被晕状态/晕眩
        ,is_taunt = 0       %% 被嘲讽状态
        ,is_silent = 0      %% 被沉默状态
        ,is_sleep = 0       %% 睡眠状态
        ,is_stone = 0       %% 石化状态/冰封
        ,is_defencing = 0   %% 是否处于防御状态
        ,is_nocrit = 0      %% 不能暴击状态
        ,is_nopassive = 0   %% 不能使用被动技能状态
        ,heal_ratio = 100   %% 治疗量比例
        ,stone_dmg_reduce_ratio = 50    %% 石化伤害减免比例
        ,protector_pid = undefined      %% 保护者的进程ID
        ,taunt_pid = undefined       %% 嘲讽者的进程ID
        ,buff_atk = []      %% 攻击时触发的BUFF
        ,buff_hit = []      %% 被攻击时触发的BUFF
        ,buff_round = []    %% 回合结束时触发的BUFF
        %,is_unbeatable = 0  %% 无敌的，不受任何伤害
        ,is_undying = 0     %% 不死/濒死状态，气血最低为1    
        ,shield = 0         %% 护盾值, 屏障buff，可抵消伤害
        ,super_crit = 0     %% 是否超暴击状态, ?true | ?false
        ,life = 0           %% 拥有多少条生命，每次死亡前减一条命原地满状态复活

        %% 行动相关数据
        ,act = undefined    %% 当前的行动数据 {#c_skill{}, tuple()}
        ,talk = <<>>        %% 说话数据 bitstring()
        ,ai = {[], []}      %% 记录npc的可以使用的ai列表、在本次战斗使用过的ai
        ,ai_skills = []         %% 供ai选择的主动技能列表 [{SkillIdPrefix, SkillId}] SkillIdPrefix是技能id的高3位
        ,ai_anger_skills = []   %% 供ai选择的怒气技能列表 [{SkillIdPrefix, SkillId}]
        ,die_round = 0      %% 死亡的时候是第几回合

        %% 战斗结算相关信息
        ,result = ?combat_result_lost %% 战斗结果
        ,gl_flag = []       %% 影响损益的参数，内容:[{double_drop, tuple()} ...]
        ,gl = []            %% 普通损益数据
        ,gl_special = []    %% 特殊损益
        ,npc_killed = []    %% 本次战斗中杀掉的怪物，内容:[NpcBaseId | ...]
        ,pet_catch = []     %% 本次战斗中抓到的宠物，内容:[NpcBaseId | ...]
        ,role_killed = []   %% 本次战斗中杀死的玩家
        ,last_combat_time = 0   %% 上次战斗日期 timestamp()
        ,last_combat_result = ?combat_result_lost   %% 上次战斗结果
        ,special_npc_killed_count = 0   %% 特殊怪物击杀数量

        %% 其他数据（护送、雇佣NPC等功能用到）
        ,ms_rela = ?ms_rela_none    %% 主从关系
        ,ms_rela_master_pid = 0     %% 主从关系-主人的Pid
        ,impression = 0             %% 主人与该npc的好感度（只有npc有用）
        ,is_clone = 0               %% 是否克隆人（挑战排行榜时用到）
        ,pet_speak = []             %% 宠物自定义说话:[{Id, <<>>}, ...]
        ,partner = 0                %% 伴侣的ID
        ,secret_ai = 0              %% 幻灵秘境AI
        ,special_ai = 0             %% 特殊AI的判断字段
        ,x = 0  %% 站位x坐标
        ,y = 0

        ,act_state = []         %% 当前回合动作自定义状态值集合{key, value}对
    }
).

%% 参战者扩展信息(玩家)
-record(fighter_ext_role, {
        id,
        pid,
        lineup_id = 0,
        looks = [],
        skills = [],
        passive_skills = [],
        anger_skills = [],
        anger_passive_skills = [],
        active_pet = undefined, %% 战斗宠物 #c_pet{}
        backup_pets = [],       %% 备战宠物 [#c_pet{}]
        rewards = [],           %% 身上带的奖励
        pet_num = 0,            %% 宠物是否抓宠(1:可以，0: 不可以) (包括出战和非出战，方便计算抓宠时背包是否满了)
        items = [],             %% 战斗物品[#c_item{}]，包括可以直接使用和技能消耗
        event = 0,              %% 对应#role{}的event
        event_pid = 0,          %% 对应#role{}的event_pid
        demon_shape_dmg = 0,    %% 守护精灵化形攻击力
        demon_shape_dmg_magic = 0   %% 守护精灵化形魔法伤害
    }
).

%% 参战者扩展信息(NPC)
-record(fighter_ext_npc, {
        id,
        pid,
        skills = [],
        passive_skills = [],
        active_pet = undefined, %% 战斗宠物 #c_pet{}
        rewards = [],
        prepare_time = 15,
        npc_id = 0,             %% 如果type是NPC的话，这个值就是npc的编号
        npc_base_id = 0,        %% 如果type是NPC的话，这个值就是npc的基础编号
        world_boss_type = ?world_boss_type_none,     %% 世界boss类型
        world_boss_createtime = 0,                   %% 世界boss创建时间
        fun_type = 0,                                 %% npc功能类型
        master_id = 0,      %% 主人（剧情npc，契约兽）
        master_pid = 0
    }
).

%% 参战者扩展信息(宠物)
-record(fighter_ext_pet, {
        id = 0,
        pid = 0,
        original_id = 0,        %% 对应#c_pet.id
        master_id = 0,
        master_pid = 0,
        first_summon = 0,       %% 是否刚召唤出来，如果是则那个回合不能行动
        skills = [],
        passive_skills = []
    }
).

%% 参战者扩展信息(契约兽)
-record(fighter_ext_demon, {
        id = 0,
        pid = 0,
        base_id = 0,  
        master_id = 0,
        master_pid = 0,
        skills = [],
        passive_skills = []
    }
).

%% 原始参战者数据结构
-record(converted_fighter, {
        pid,
        fighter,        %% #fighter{}
        fighter_ext,    %% #fighter_ext_role{} or #fighter_ext_npc{}
        skill_mapping = [],  %% [{原始技能id, 装备加成后的最终技能id}]
        employ_npc = undefined,      %% #npc_base{}  雇佣过来参战的npc
        story_npcs = [],         %% 剧情npc
        demon = []              %% 契约兽
    }
).


%% 参战者信息(告诉客户端参战者信息时用)
-record(fighter_info, {
        group,
        id,
        type,
        rid,                %% 角色id，npc id，宠物id
        base_id = 0,      %% NpcBaseId或宠物BaseId
        srv_id,
        name,
        sex = 0,
        career = 0,
        lev = 1,
        portrait_id = 0,
        fight_capacity = 0,
        hp = 0,
        mp = 0,
        hp_max = 0,
        mp_max = 0,
        anger = 0,
        anger_max = 0,
        power = 0,
        power_max = 0,
        lineup_id = 0,
        master_id = 0,
        is_die = 0,
        looks = [],
        skills = [],
        items = [],
        pets = [],
        specials = [],
        x = 0,  %% 战斗中站位x坐标
        y = 0  %% 战斗中站位y坐标
    }
).

%% 战斗技能
-record(c_skill, {
        id                              %% 技能编号(最终值 = 原始值 + 装备加成值)
        ,name = <<>>                    %% 名称
        ,script                         %% 脚本模块名
        ,skill_type = ?skill_type_active    %% 技能类型
        ,attack_type = ?attack_type_melee   %% 攻击方式
        ,target = enemy                 %% 目标类型(any:敌我均可 self:只能自已 ally:可对盟友使用 enemy:可对敌人使用)
        ,range = 0                      %% 是否远程施法
        ,target_num = 1                 %% 可作用的目标个数
        ,times = 1                      %% 攻击次数    
        ,dmg_type = ?dmg_type_etc       %% 伤害类型
        ,dmg_magic = 0                  %% 附加法术伤害
        ,dmg_ratio = 100                %% 攻击修正,单位：百分率
        ,hitrate_ratio = 1000           %% 命中修正,单位：千分率
        ,hitrate_low = 0                %% 命中保底,单位：千分率
        ,hitrate_max = 1000             %% 命中上限,单位：千分率
        ,hitrate_reduce = 0             %% 命中值衰减,单位：千分率
        ,cd = 0                         %% 冷却时间
        ,delay_round = 0                %% 延迟发动回合数
        ,delay_eff = []                 %% 延迟发动效果 [{act_first, ?true | ?false} ...]
        ,last_use = 0                   %% 最后一次使用时间(回合数)
        ,cost_mp = 0                    %% 魔法消耗
        ,cost_item = 0                  %% 使用消耗{物品ID, 个数}，为0时表示不用消耗物品
        ,cost_anger = 0                 %% 怒气消耗
        ,other_cost = []                %% 其他消耗[{hp, integer()}...]
        ,before = undefined             %% 前置效果
        ,attack = undefined             %% 攻击效果
        ,args = []                      %% 技能参数
        ,buff_self = []                 %% 作用于自身的BUFF
        ,buff_target = []               %% 作用于目标的BUFF
        ,elem_type = ?elem_type_none    %% 五行属性：无
        ,script_id = undefined          %% 技能脚本编号(模板编号)
        ,passive_type = ?passive_type_none  %% 被动触发类型
        ,show_type = [{hp, 0}, {mp, 0}] %% skill_play中的XX_show_type用到的参数
        ,special = []                  %% 特殊参数(使用物品、怒气技能等用到) [{0, ItemBaseId}, {1, PetId}, {2, AngerSkillId}]
        %% 某些被动技能会动态修改这些值
        ,crit_dmg_ratio = 150          %% 暴击伤害值，默认是一般伤害的1.5倍
        ,critrate_ratio = 100          %% 暴击率修改倍率，默认是100%，即不修改暴击
    }
).

%% 战斗BUFF
-record(c_buff, {
        id = 0                  %% BUFF编号
        ,caster = 0             %% 施放者ID
        ,type = atk             %% 触发类型(atk:攻击 hit:被攻击 round:回合 atk_hit:攻击和被攻击)
        ,eff_type = buff        %% BUFF类型(buff:有益 debuff:有害)
        ,dispel = 1             %% 是否可驱散(0:不可以 1:可以)
        ,args = []              %% 触发参数
        ,duration = 2           %% 持续回合
        ,hitrate = 100          %% Buff命中率
        ,eff_before = undefined  %% 前置效果
        ,eff = undefined        %% 触发效果
        ,eff_after = undefined  %% 结束效果
        ,eff_refresh = undefined %% 刷新效果(BUFF覆盖时修改时间和tips用的)
        ,compare = undefined    %% 效果比较(此方法包含4个参数，返回0表示效果一样，>0表示前者效果大于后者，<0表示前者效果小于后者)
        ,is_hit = undefined     %% 命中计算(缺省情况下只计算buff本身命中，不计算对方抗性)
        ,calc = undefined       %% 用输入的参数和自身的参数计算得出结果
        ,recalc_args = undefined    %% 重新计算参数的方法
        ,desc = <<>>            %% 描述
        ,eff_passive = undefined  %% 类辅助技能效果
    }
).

%% 战斗宠物
-record(c_pet, {
        id = 0,                 %% ID 跟#pet{}的id一样，是宠物背包中的原始id
        base_id = 0,            %% 基础ID
        fighter_id = 0,         %% 转换成#fighter{}时的ID
        master_pid = 0,         %% 主人PID
        name = <<>>,            %% 名称
        lev = 0,                %% 等级
        attr,                   %% 战斗属性 #pet_attr{}
        skills = [],            %% 技能 #c_pet_skill
        can_summon = 1,         %% 是否可以召唤
        happy_val = 0,          %% 快乐值
        type = 0,               %% 宠物类型(0:白宠 1:绿宠 2:蓝宠 3:紫宠 4:橙宠)
        fight_capacity = 0      %% 战斗力
    }
).

%% 战斗宠物技能
-record(c_pet_skill, {
        id = 0,
        args = [],              %% 技能参数
        talent_args = [],       %% 天赋附加参数
        action = undefined,
        script_id = undefined,
        passive_type = ?passive_type_none,
        cost_mp = 0,
        cd = 0,
        attack_type = ?attack_type_melee,
        buff_self = [],                 %% 作用于自身的BUFF, [#c_buff{}]
        buff_target = []               %% 作用于目标的BUFF, [#c_buff{}]
    }
).

%% 战斗物品
-record(c_item, {
        base_id = 0,            %% 物品基础ID
        quantity = 0,           %% 数量
        target = ally,          %% 物品使用对象
        type = ?item_type_both, %% 物品类型
        script_id = undefined,  %% 脚本ID
        args = [],              %% 参数
        buff_self = [],         %% 作用于自身的BUFF
        buff_target = [],       %% 作用于目标的BUFF
        target_base_ids = [],   %% 目标BaseId，不为空时需要判断对方BaseId是否在这个列表中
        action = undefined,     %% 使用后的动作 is_function()
        cooldown = 0,           %% 冷却时间
        last_use = 0            %% 最后一次使用时间(回合数)
    }
).


%% 战斗阵法
-record(c_lineup, {
        id = 0,                 %% 阵法ID
        script_id = 0,          %% 脚本ID
        args = [],              %% 参数 [{atom(), integer()}]
        eff = undefined         %% 阵法对参战者的影响 is_function()
    }
).

%% 战斗行为播放数据
-record(skill_play, {
        order = 0           %% 播放序列
        ,sub_order = 0      %% 子序列(用于连击)
        ,action_type = 0    %% 行动类型(0是攻击和施法，1是反击，2是保护，3是反弹，4是自杀，5是使用物品，6是角色不动单纯释放特效)
        ,skill_id = 0       %% 技能ID
        ,id = 0             %% 参战者ID
        ,hp = 0             %% 自身血量变化数据(若施放技能需要hp)
        ,hp_show_type = 0   %% 自身血量变化的时机(0是行动前，1是行动中，2是行动后)
        ,mp = 0             %% 自身魔量变化数据(若施放技能需要mp)
        ,mp_show_type = 0   %% 自身血量变化的时机(0是行动前，1是行动中，2是行动后)
        ,anger = 0          %% 自身怒气变化数据
        ,power = 0          %% 自身天威变化数据
        ,attack_type = 0    %% 攻击类型(0:近战 1:远程)
        ,target_id = 0      %% 目标ID
        ,target_hp = 0      %% 目标血量变化
        ,target_mp = 0      %% 目标魔量变化
        ,target_anger = 0   %% 目标怒气值变化
        ,target_power = 0   %% 目标天威值变化
        ,is_hit = 1         %% 是否命中
        ,is_crit = 0        %% 是否爆击
        ,is_self_die = 0    %% 自身是否死亡
        ,is_target_die = 0  %% 目标是否死亡
        ,talk = <<>>        %% 说话内容
        ,show_passive_skills = []   %% 要展示特效的被动技能, [{Id, SkillId, Type}], Id = 执行该被动技能的参战者的ID = integer(), SkillId = integer(), Type = integer()
    }
).

%% BUFF播放数据
-record(buff_play, {
        order = 0       %% 播放序列
        ,sub_order = 0  %% 子序列(用于连击)
        ,duration = 0   %% 剩余回合数(大于0表示存在，等于0表示消失)
        ,buff_id = 0    %% BUFF ID
        ,is_hit = 1     %% 是否命中
        ,dispel = 1     %% 是否可驱散(0:不可以 1:可以)
        ,target_id = 0
        ,target_hp = 0
        ,target_mp = 0
        ,is_target_die = 0  %% 目标是否死亡
        ,tips_args = [] %% TIPS参数
    }
).

%% 召唤播放数据
-record(summon_play, {
        order = 0,
        sub_order = 0,
        summoner_id = 0,        %% 召唤者的参战者ID
        summons_id = 0,         %% 召唤物的参战者ID
        summons_base_id = 0,    %% 召唤物的基础ID(NPC的话是base_id，宠物的话是original_id)
        group = 1,              %% 进攻方(0)或防守方(1)（目前只有在回合初动态加入怪时才用到，普通召唤技用不到）
        type = 1,
        name = <<>>,
        lev = 0,
        hp = 0,
        mp = 0,
        hp_max = 0,
        mp_max = 0,
        skills = [],
        passive_skills = [],
        x = 0,
        y = 0
    }
).

%% 观战者数据
-record(c_observer, {
        id = 0,         %% 角色ID，#role.id
        pid = 0,        %% 观战者pid
        name = <<>>,    %% 名字
        conn_pid = 0,
        target_pid      %% 被观战者的pid
    }
).

%% 战斗录像
-record(combat_replay, {
        id = 0,                 %% 录像ID
        version = ?COMBAT_REPLAY_VER,            %% 版本号
        combat_type = 0,               %% 战斗类型
        create_time = 0,         %% 创建日期 unixtime()
        rp_10710 = undefined,    %% 10710播报（参战者信息）
        rp_10720 = [],           %% 10720播报
        rp_10721 = []            %% 10721播报
    }
).

%% 扩展属性
-record(attr_ext, {
        %% BUFF抗性
        anti_debuff_injure = 0,     %% 抗伤害加深
        anti_debuff_atk = 0,        %% 抗攻击降低
        anti_debuff_hitrate = 0,    %% 抗命中降低
        anti_debuff_evasion = 0,    %% 抗躲闪降低
        anti_debuff_critrate = 0,   %% 抗暴击降低

        %% 神佑属性
        buff_target_on_attack = []  %% 攻击时对对方施加buff
    }
).

-define(log_open, true).
-ifdef(debug).
-ifdef(log_open).
-define(log_open_, true).
-endif.
-endif.

-ifdef(log_open_).
-define(p(A), io:format(erlang:get(log_file_), A, [])).
-define(p(F, A), io:format(erlang:get(log_file_), F, A)).
-define(log_init, begin {_, _Log_fd_} = file:open("../var/logs/"++integer_to_list(util:unixtime())++".txt", [write]), erlang:put(log_file_, _Log_fd_) end).
-define(log(A), begin ?p("~p:~p ", [?MODULE, ?LINE]), ?p(A), ?p("\n") end).
-define(logv(A), begin ?p("~p:~p ", [?MODULE, ?LINE]), ?p("~p = ~p", [??A, A]), ?p("\n") end).
-define(log(F, A), begin ?p("~p:~p ", [?MODULE, ?LINE]), ?p(F, A), ?p("\n") end).
-define(logif(Exp), Exp).
-else.
-define(log_init, ignore).
-define(log(_A), ignore).
-define(logv(_A), ignore).
-define(log(_F, _A), ignore).
-define(logif(_Exp), ignore).
-endif.
