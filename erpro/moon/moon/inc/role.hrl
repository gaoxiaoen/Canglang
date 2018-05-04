%%----------------------------------------------------
%% 角色相关数据结构定义
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------

%% 角色状态
-define(status_normal, 0).              %% 正常
-define(status_die, 1).                 %% 死亡
-define(status_fight, 2).               %% 战斗
-define(status_transfer, 4).            %% 传送中

%% 活动事件
-define(event_no, 0).                   %% 当前无任何活动
-define(event_trade, 1).                %% 正在跑商
-define(event_escort, 2).               %% 运镖中
-define(event_dungeon, 3).              %% 普通副本中
-define(event_arena_match, 4).          %% 参加竞技比赛中
-define(event_arena_prepare, 5).        %% 竞技准备中
-define(event_guild_war, 6).            %% 帮战中
-define(event_combat_xmz, 7).           %% 仙盟战中
-define(event_marry, 8).                %% 举行婚礼中
-define(event_marry_tour, 9).           %% 婚礼巡游中
-define(event_jiebai, 10).              %% 结拜
-define(event_yuehui, 12).              %% 约会
-define(event_kuafu, 13).               %% 跨服
-define(event_guaji, 14).               %% 挂机
-define(event_guild, 15).               %% 帮会领地中
-define(event_spring_bank, 16).         %% 温泉岸上
-define(event_spring_water, 17).        %% 温泉水中
-define(event_super_boss, 18).          %% 超级世界boss
-define(event_guild_td, 19).            %% 帮会副本 
-define(event_guild_arena, 20).         %% 新帮战
-define(event_escort_child, 21).        %% 护送小屁孩
-define(event_c_world_compete_11, 22).  %% 仙道会1v1
-define(event_c_world_compete_22, 23).  %% 仙道会1v1
-define(event_c_world_compete_33, 24).  %% 仙道会3v3
-define(event_hall, 25).                %% 大厅状态
-define(event_pk_duel, 26).             %% 跨服决斗状态
-define(event_cross_king_prepare, 27).  %% 至尊王者准备中 
-define(event_cross_king_match, 28).  %% 至尊王者比赛中 
-define(event_top_fight_match, 29).          %% 巅峰对决比赛中
-define(event_top_fight_prepare, 30).        %% 巅峰对决准备中
-define(event_cross_ore, 31).           %% 跨服抢矿活动中
-define(event_escort_cyj, 32).        %% 重阳节护送美女
-define(event_cross_warlord_prepare, 33).      %% 武神坛报名区
-define(event_cross_warlord_match, 34).        %% 武神坛正式区
-define(event_guard_counter, 35).       %% 洛水反击战里面
-define(event_puzzle, 37).              %% 猜灯谜
-define(event_train, 38).               %% 飞仙历练
-define(event_tree, 39).                %% 世界树
-define(event_wanted, 40).              %% 悬赏Boss
-define(event_arena_career, 41).        %% 离线竞技/中庭战神
-define(event_trial, 42).               %% 荣耀学院试炼场
-define(event_tutorial, 43).            %% 新手引导
-define(event_demon_challenge, 44).     %% 妖精碎片抢夺
-define(event_compete, 45).              %% 竞技场
-define(event_jail, 46).              %% 雪山地牢
-define(event_beer, 47).              %% 酒桶节

%% 动作状态
-define(action_no, 0).                  %% 无动作
%% -define(action_collect, 1).          %% 采集
%% -define(action_follow, 2).           %% 跟随
%% -define(action_follow_team, 3).      %% 队伍跟随(队员不可移动操作)
-define(action_sit, 10).                %% 打坐
-define(action_sit_both, 11).           %% 双修打坐
-define(action_sit_brother, 12).        %% 结拜双修
-define(action_sit_master, 13).         %% 师徒双修
-define(action_sit_lovers, 14).         %% 情侣双修
-define(action_sit_demon, 15).          %% 个人守护双修
-define(action_ride_both, 20).          %% 双人骑乘

%% 骑乘状态
-define(ride_no, 0).                    %% 无骑乘
%% -define(ride_land, 1).               %% 陆地骑乘
%% -define(ride_can_fly, 2).            %% 飞行骑乘(但是不一定进入飞行状态)
-define(ride_fly, 3).                   %% 飞行状态

%% 角色标识代号
-define(role_label_player, 0).          %% 普通玩家
-define(role_label_gm, 1).              %% 这是GM
-define(role_label_zhi_dao_yuan, 2).    %% 新手指导员
-define(role_label_baobei, 10).         %% 普通玩家带"飞仙宝贝"标识（部分平台）

%% 角色聊天特殊标识代号
-define(role_special_player, 0).          %% 普通玩家
-define(role_special_gm, 1).              %% 这是GM
-define(role_special_zhi_dao_yuan, 2).    %% 新手指导员
-define(role_special_baobei, 50).         %% 普通玩家带"飞仙宝贝"标识（部分平台）
-define(role_special_liansai_1, 51).      %% 普通玩家带"联赛冠军"标识（部分平台）
-define(role_special_liansai_2, 52).      %% 普通玩家带"联赛亚军"标识（部分平台）
-define(role_special_liansai_3, 53).      %% 普通玩家带"联赛季军"标识（部分平台）

%% 战斗模式
-define(mod_peace, 1).
-define(mod_pk, 2).
-define(mod_wanted, 5). %% 被通缉

%% 性别代号
-define(female, 0).     %% 女性
-define(male, 1).       %% 男性

%% 职业代号
-define(career_zhenwu, 1).      %% 真武
%-define(career_cike, 2).     %% 魅影 刺客
%-define(career_xianzhe, 3).     %% 天师 贤者
-define(career_feiyu, 4).       %% 飞羽
%-define(career_qishi, 5).     %% 天尊 骑士
%-define(career_xinshou, 6).     %% 少侠 新手
%% 职业代号
-define(career_cike, 2).     %% 刺客
-define(career_xianzhe, 3).     %% 贤者
-define(career_qishi, 5).     %% 骑士
-define(career_xinshou, 6).     %% 新手
-define(career_none, 7).        %% 没有职业


%% 所属阵营 
-define(role_realm_default, 0).     %% 无阵营
-define(role_realm_a, 1).           %% 阵营蓬莱 
-define(role_realm_b, 2).           %% 阵营逍遥
-define(role_realms, [?role_realm_default, ?role_realm_a, ?role_realm_b]).  %% 阵营列表

%% special字段的定义如下：
%% 附加信息类型type
-define(special_both_sit_x, 8).         %% 双修对象X
-define(special_both_sit_y, 9).         %% 双修对象Y
-define(special_both_sit_dir, 10).      %% 双修对象朝向
-define(special_both_sit, 11).          %% 双修对象
-define(special_team_leader, 12).       %% 队伍队长
-define(special_following, 13).         %% 跟随对象
-define(special_guild_sit, 14).         %% 帮会宝座
-define(special_marry_ceremony, 15).    %% 结婚交拜仪式状态，不能移动
-define(special_marry_title, 16).       %% 结婚称号
-define(special_honor, 17).             %% 角色称号
-define(special_sworn_ceremony, 18).    %% 结拜仪式状态，不能移动
-define(special_medal, 25).             %% 最高勋章称号
-define(special_trial_id, 26).          %% 试炼场id
-define(special_demon, 27).             %% 出战妖兽id
-define(special_compete_medal, 28).     %% 佩戴竞技勋章
-define(special_vip_gift, 29).          %% 购买vip礼包数量
%% 双人骑乘
-define(special_ride_both_role, 19).     %% 双人骑乘信息
-define(special_ride_both_name, 20).     %% 双人骑乘信息
%% 宠物special信息类型
-define(special_pet, 30). %% 宠物基础ID和名称
-define(special_pet_color, 31). %% 宠物颜色
-define(special_pet_grow, 32).  %% 宠物长成[0:无 1:灵宠 2:仙宠 3:神宠 4:圣宠]
%% 雇佣npc信息类型
-define(special_npc_employ, 40).    %% npc基础ID和名称
-define(special_story_npc, 41).         %% 剧情npc

%% 最高等级限制
-define(ROLE_LEV_LIMIT, 60).

%% 当前状态不能进行穿脱装备改变战力
%% -define(EventCantPutItem, Event =:= ?event_arena_match orelse Event =:= ?event_arena_prepare orelse Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 orelse Event =:= ?event_cross_king_prepare orelse Event =:= ?event_cross_king_match orelse Event =:= ?event_top_fight_match orelse Event =:= ?event_top_fight_prepare orelse Event =:= ?event_cross_warlord_match). 
-define(EventCantPutItem, Event =:= -1). 

%% 10005协议用到
-define(idx_hp, 0).
-define(idx_mp, 1).
-define(idx_hp_max,2). %% 血量用这个
-define(idx_mp_max, 3). %% 魔法用这个
-define(idx_dmg_magic, 4).
-define(idx_dmg_min, 5).
-define(idx_dmg_max, 6).
-define(idx_defence, 7).
-define(idx_evasion, 8).
-define(idx_hitrate, 9). 
-define(idx_critrate, 10).
-define(idx_tenacity, 11).
-define(idx_js, 12).
-define(idx_aspd, 13).
-define(idx_resist_metal, 14). %%用这个代表全抗
-define(idx_resist_wood, 15).  %%
-define(idx_resist_water, 16). %%
-define(idx_resist_fire, 17).
-define(idx_resist_earth, 18).
-define(idx_dmg_wuxing, 19).
-define(idx_anti_stun, 20).
-define(idx_anti_taunt, 21).
-define(idx_anti_slient, 22).
-define(idx_anti_sleep, 23).
-define(idx_anti_stone, 24).
-define(idx_anti_poison, 25).
-define(idx_anti_seal, 26).
-define(idx_fight_capacity, 27).

%% 10006协议用到
-define(asset_lev, 1).
-define(asset_exp_need, 2).
-define(asset_exp, 3).
-define(asset_gold_bind, 5).
-define(asset_coin, 6).
-define(asset_gold, 7).
-define(asset_energy, 8).
-define(asset_attainment, 9).
-define(asset_stone, 10).
-define(asset_vip, 11).
-define(asset_badge, 12).
-define(asset_honor, 13).

%%11170 协议用到
-define(pet_asc_potential, 1).

%% 登入登出基础时间戳信息
-record(login_info, {
        reg_time = 0        %% 注册时间戳
        ,last_login = 0     %% 上次登录时间戳，从未登录的角色上次时间戳为0
        ,last_logout = 0    %% 上次离线时间戳，从未登录的角色上次时间戳为0
        ,login_time = 0     %% 本次登录时间戳
        ,logout_time = 0    %% 本次离线时间戳，本次离线时间只在离线时记录,默认为0
        ,device_id          %% 创建角色时的设备唯一标识 
        ,reg_code           %% 创建角色时使用的邀请码
    }).

%% 角色数据
-record(role, {
        pid                %% 进程PID
        ,combat_pid = 0     %% 战斗进程PID
        ,combat = []        %% 战斗相关数据，格式: [tuple()]
        ,team_pid = 0       %% 组队进程PID
        ,exchange_pid = 0   %% 交易进程PID
        ,event_pid = 0      %% 活动管理器进程PID
        ,lock_info = 0      %% 角色锁定状态 1封号中,2禁言中 3封号且禁言
        ,login_info         %% #login_info{}

        %% 跨服
        ,cross_srv_id = <<>>    %% 标识用户当前游览到哪个服; 为空时，表示在本服。 

        %% 角色基础数据
        ,id = {0, 0}        %% 角色ID，格式:{RoleId, SrvId}
        ,account = <<>>     %% 帐号名称
        ,platform = <<>>    %% 平台
        ,name = <<>>        %% 名称
        ,status = 0         %% 角色状态，状态代号参见上面
        ,action = 0         %% 动作状态
        ,ride = 0           %% 骑乘状态
        ,event = 0          %% 活动状态，标示玩家当前正在进行的活动
        ,label = 0          %% 特殊标识，比如标记是否GM，是否新手指导员等
        ,sex = 0            %% 性别
        ,career = 6         %% 职业
        ,realm = 0          %% 所属阵营[0:无阵营 1:阵营A, 2:阵营B]
        ,lev = 0            %% 等级
        ,soul_lev = 1       %% 武魂等级
        ,mod = {1, 0}       %% 模式{Mod, Time}：1-和平  2-杀戮
        ,speed = 336        %% 默认移动速度
        ,hp = 1             %% 当前血量
        ,mp = 1             %% 当前法力
        ,hp_max = 1         %% 血量最大值
        ,mp_max = 1         %% 法力最大值
        ,day_activity = 0   %% 每天累积活跃值
        ,power = 0          %% 体力     真正的体力在#assets里面的energy

        ,assets             %% 角色的资产类属性 #assets{}
        ,ratio              %% 数值比率控制属性 #ratio{}
        ,attr               %% 战斗属性 #attr{}
        ,link               %% 连接属性 #link{}
        ,team               %% 队伍数据
        ,timer = []         %% 定时器数据 #timing{}
        ,looks = []         %% 外观效果数据[{?LOOKS_WEAPON, ID, Val}, ...]
        ,special = []       %% 外观相关特殊信息[{Type, ValInt, ValStr} | ...]

        %% 模块相关数据
        ,trigger            %% 动态触发器 #trigger{}
        ,buff               %% buff数据 #rbuff{}
        ,guild              %% 帮会属性 #role_guild{}
        ,pos                %% 位置信息 #pos{}
        ,skill              %% 已学技能 #skill_all{}
        ,sns                %% 社交相关信息 #sns{}
        ,vip                %% VIP信息 #vip{}
        ,pet                %% 宠物系统相关数据 #pet_bag{}
        ,channels           %% 经脉系统相关数据 #channels{}
        ,escort             %% 运镖系统相关数据 #escort{}
        ,achievement        %% 成就系统相关数据 #role_achievement{}
        ,disciple           %% 师门系统数据 #teacher_disciple{}
        ,npc_store          %% NPC商店兑换信息 #npc_store{}
        ,fcm                %% 防沉迷系统相关数据 {LoginTime, LogoutTime, AccTime}
        ,auto               %% 自动挂机等相关数据 {IsHook, Count, Time}
        ,offline_exp        %% 离线累计经验 #offline_exp
        ,activity           %% 活跃度模块 #activity{}
        ,task = []          %% 已接任务数据 [#task{} | ...]
        ,dungeon = []       %% 副本相关数据 [#role_dungeon{} | ...]
        ,dungeon_map = []   %% 副本地图数据 [{map_id, blue, purple, blue_is_taken, purple_is_taken, is_opened}]
        ,max_map_id = 0     %% 开启的大地图id
        ,dungeon_ext        %% 副本的附加信息 #dungeon_ex{}
        ,expedition = {0, 0}%% 远征王军进入次数{Count, lastTime}
        ,compete = {0, 0}   %% 竞技场进入次数{Count, lastTime}
        ,setting            %% 玩家个人设置数据#setting{}
        ,lottery            %% 幸运转盘 #lottery{}
        ,rank = []          %% 排行榜特殊数值 {排行榜类型, 数值}
        ,guild_practise     %% 帮会历练数据 #guild_practise{}
        ,suit_attr          %% 套装锁定属性
        ,mounts             %% 坐骑栏 #mounts{}
        ,arena_career       %% 师门竞技 #arena_career{}
        ,escort_child       %% 护送小屁孩系统相关数据 #escort_child{}
        ,super_boss_store   %% 地下集市仓库 #super_boss_store{}
        % ,super_boss_store   %% 盘龙洞探宝仓库 #super_boss_store{}
        ,campaign           %% 后台活动相关信息 #campaign_role{}
        ,task_role          %% 任务系统个人信息 #task_role{}
        ,pet_magic          %% 宠物魔晶背包 #pet_magic{}
        ,hall               %% 大厅信息 #role_hall{}
        ,practice           %% 试练相关数据
        ,wing               %% 翅膀 #wing{}
        ,money_tree         %% 摇钱树 #money_tree{}
        ,activity2          %% 新的活跃度模块 #activity2{}
        ,treasure           %% 宝图数据 #treasure{}
        ,soul_mark          %% 灵魂刻印 #soul_mark{}
        ,lottery_camp       %% 活动转盘
        ,demon              %% 契约兽 #role_demon{}
        ,secret             %% 幻灵秘境 #secret{}
        ,fate               %% 缘分摇一摇 #fate{}
        ,soul_world         %% 灵戒洞天 #soul_world{}
        ,fate_pid           %% 缘分互动PID
        ,ascend             %% 职业进阶 #ascend{}
        ,max_fc             %% 最高战力信息 #max_fc{}
        ,pet_rb = []        %% 宠物真身数据
        ,train              %% 飞仙历练
        ,campaign_daily_consume %% 活动日常消费记录(周年庆红包)#campaign_daily_consume{}
        ,name_used = <<>>     %% 角色曾用名
        ,pet_cards_collect = [] %% 星宠
        ,item_gift_luck = [] %% 礼包幸运值{BaseId, LuckVal}

        %% 物品包裹
        ,cooldown = []      %% 物品等相关CD数据
        ,eqm = []           %% 身上穿戴的装备[#item{}, ...]
        ,bag                %% 背包数据 #bag{}
        ,store              %% 个人仓库 #store{}
        ,collect            %% 采集背包 #collect{}
        ,task_bag           %% 任务背包 #task_bag{}
        ,casino             %% 仙境寻宝--开宝箱仓库 #casino{}
        ,dress = []         %% 衣柜 [{ItemBaseId, Flag, #item{}}, ...] ItemBaseId:冗如，方便实现， Flag:0未穿，1：已穿 
        ,anticrack          %% 反外挂数据
        ,award = []         %% 未领取奖励的{id, base_id}列表
        ,daily_task = []    %% 接收到的日常任务 [#daily_task{}]
        ,manor_baoshi       %% 庄园宝石系统 #manor_baoshi{}
        ,manor_moyao        %% 庄园炼药系统 #manor_moyao{}
        ,medal              %% 勋章系统 #medal{}
        ,manor_trade        %% 庄园行商系统 #manor_trade{}
        ,manor_train        %% 庄园训龙系统 #manor_train{}
        ,energy             %% 体力系统 #energy{}
        ,tutorial           %% 新手引导
        ,manor_enchant      %% 庄园辅助强化 #manor_baoshi{}
        ,story              %% 剧情
        ,seven_day_award    %% 7天奖励 #seven_day_award{}
        ,scene_id = 0       %% 即将进入的主城ID
        ,npc_mail   = []    %% 远方来信
        ,invitation         %% 好友邀请码相关
        ,guaguale           %% 刮刮乐数据  [{itembaseid, bind, num} ..]
        ,beer_guide = []    %% 酒桶节新手引导信息  [0未发晶钻1发了晶钻未完成引导2完成引导]
        ,month_card         %% 月卡
    }
).

%% 角色改名记录
-record(role_name_used, {
        ver = 1             %% 版本号
        ,id = {0, <<>>}     %% 角色id
        ,name = <<>>        %% 曾用名
        ,new_name = <<>>    %% 新名字
        ,sex                %% 性别
        ,career             %% 职业
        ,realm              %% 阵营
        ,vip                %% vip
        ,ctime              %% 修改时间
    }).
