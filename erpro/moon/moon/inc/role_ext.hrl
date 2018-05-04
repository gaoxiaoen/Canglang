%%----------------------------------------------------
%% 角色扩展数据
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------


%% 角色扩展数据
%% 此结构中的数据在下线后都将保存进MySQL表role_ext中的data字段
-record(role_ext, {
        state                    %% 各个状态模式:{Ride, Event, Mod} 分别为{骑乘，活动，模式}
                                 %% 其中Event字段加载后需要检测是否有效，或者保证下线前清除过期的活动状态
        ,pos
        ,storage                 %% {[#item{}], #bag{}, #store{}, #collect{}, #task_bag{}, #casino{}, [#item{}]}
        ,r_buff
        ,looks
        ,sns                     %% 社交模块
        ,skill                   %% 技能模块:{SkillList, ShortcutsRecord}
        ,vip                     %% vip模块
        ,guild                   %% 角色帮会属性 #guild{}
        ,channels                %% 元神数据
        ,pet                     %% 仙宠数据
        ,escort                  %% 运镖系统相关
        ,npc_store               %% NPC商店交易信息
        ,disciple                %% 师门系统数据 #teacher_disciple{}
        ,offline_exp             %% 离线累计经验 #offline_exp
        ,dungeon                 %% 副本相关数据
        ,dungeon_map             %% 副本地图数据
        ,max_map_id              %% 开启的大地图id
        ,expedition              %% 远征王军
        ,compete                 %% 竞技场
        ,activity                %% 活跃度模块 #activity{}
        ,cooldown                %% 冷却时间相关 list()
        ,auto                    %% 挂机战斗数据 tuple()
        ,award                   %% 领取奖励记录 #award{}
        ,setting                 %% 个人设置 #setting{}
        ,rank                    %% 排行榜数据 []
        ,combat                  %% 战斗数据 [{key, value}]
        ,achievement             %% 成就系统 #role_achievement{}
        ,lottery                 %% 幸运抽奖 #lottery{}
        ,guild_practise          %% 帮会历练数据 #guild_practise{}
        ,suit_attr               %% 锁定套装属性
        ,mounts                  %% 坐骑系统 #mounts{}
        ,arena_career            %% 师门竞技 #arena_career{}
        ,escort_child            %% 护送小孩 #escort_child{}
        ,cross_srv_id            %% 跨服状态
        ,super_boss_store        %% 盘龙仓库
        ,task_role               %% 个人任务信息
        ,pet_magic               %% 魔晶背包
        ,hall                    %% 大厅信息
        ,practice                %% 试练信息
        ,campaign                %% 后台活动
        ,money_tree              %% 摇钱树信息
        ,wing                    %% 翅膀数据 #wing{}
        ,activity2               %% 新活跃度数据#activity2{}
        ,treasure                %% 宝图数据 #treasure{}
        ,soul_mark               %% 灵魂水晶 #soul_mark{}
        ,lottery_camp            %% 活动转盘 #lottery_role{}
        ,touch_game              %% 碰撞小游戏 #touch_game{}
        ,demon                   %% 精灵守护 #role_demon{}
		,secret                  %% 幻灵秘境 #secret{}
        ,fate                    %% 缘分摇一摇 #fate{}
        ,soul_world              %% 灵戒洞天 #soul_world{}
        ,ascend                  %% 职业进阶 #ascend{}
        ,max_fc                  %% 最高战力信息 #max_fc{}
        ,pet_rb = []             %% 宠物真身数据
        ,train                   %% 飞仙历练
        ,campaign_daily_consume  %% 日常消费记录（周年庆红包用）#campaign_daily_consume{}
        ,treasure_store             %% 珍宝阁 #role_treasure_store{}
        ,pet_cards_collect = []     %% 星宠
        ,item_gift_luck = []    %% 礼包幸运值{BaseId, LuckVal}
        ,anticrack              %% 反外挂信息#anticrack{}
        ,manor_baoshi           %% 庄园宝石系统 #manor_baoshi{}
        ,manor_moyao            %% 庄园魔药系统 #manor_moyao{}
        ,medal                  %% 勋章系统 #medal{}
        ,manor_trade            %% 庄园行商系统 #manor_trade{}
        ,manor_train            %% 庄园训龙系统 #manor_train{}
        ,energy
        ,tutorial
        ,manor_enchant
        ,story
        ,seven_day_award        %% 七天奖励
        ,scene_id               %% 篇章
        ,npc_mail               %% 远方的来信
        ,invitation             %% 好友招募
        ,guaguale               %% 瓜瓜乐物品数据 [{ItemBaseId, Bind, Num} ...]
        ,beer_guide             %% 酒桶节引导信息 
        ,month_card             %% 月卡
    }
).
