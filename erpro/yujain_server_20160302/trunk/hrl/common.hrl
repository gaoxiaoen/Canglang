%%%-------------------------------------------------------------------
%%% File        :common.hrl
%%% @doc
%%%     公共的hrl文件
%%% @end
%%%-------------------------------------------------------------------

%%包含其他文件
-include("mnesia.hrl").
-include("mm_define.hrl").
-include("all_pb.hrl").
-include("reason_code.hrl").
-include("global_lang.hrl").
-include("common_records.hrl").
-include("fight.hrl").
-include("log.hrl").
-include("letter.hrl").
-include("mission.hrl").
-include("family.hrl").
-include("log_record.hrl").

%% 定义单元测试相关宏
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-define(BOOL_TO_INT(Val),case Val of true -> 1; _ -> 0 end).

-ifdef(IF).
-undef(IF).
-define(IF(B,T,F), begin (case (B) of true->(T); false->(F) end) end).
-endif.

-define(BREAK_MSG(T), {break, T}).
-define(BREAK(T), erlang:throw(?BREAK_MSG(T))).
-define(BREAK_IF(B, T), begin (case (B) of true ->?BREAK((T)); false -> ignore end) end).
-define(BREAK_IF_NOT(B, T), begin (case (B) of true -> ignore; false -> ?BREAK((T)) end) end).

%%日志相关
-define(PRINT(Format, Args),
        io:format(Format, Args)).

-define(TRY_CATCH(Fun,ErrType,ErrReason), 
        try 
            Fun
        catch ErrType:ErrReason -> 
                ?ERROR_MSG("ErrType=~w,Reason=~w,Stacktrace=~w", [ErrType,ErrReason,erlang:get_stacktrace()]) 
        end).
-define(TRY_CATCH(Fun,ErrReason), 
        try 
            Fun
        catch 
            _:ErrReason -> 
                ?ERROR_MSG("Reason=~w,Stacktrace=~w", [ErrReason,erlang:get_stacktrace()]) 
        end).

-define(DO_HANDLE_INFO(Info,State),  
        try 
            do_handle_info(Info) 
        catch _:Reason -> 
                  ?ERROR_MSG("Info:~w,State=~w, Reason: ~w, strace:~w", [Info,State, Reason, erlang:get_stacktrace()]) 
        end).

%% 返回错误宏
%% 这不是因为装逼定的宏，这是为避免拼写错误定的宏！
-define(THROW_ERR(ErrCode),erlang:throw({error,ErrCode})).

-define(START_SERVER_STATUS_0,0).         %% 服务启动成功
-define(START_SERVER_STATUS_1,1).         %% 开启启动服务
-define(START_SERVER_STATUS_2,2).         %% 数据库服务启动成功
-define(START_SERVER_STATUS_3,3).         %% 聊天服务启动成功
-define(START_SERVER_STATUS_4,4).         %% 游戏世界服务启动成功
-define(START_SERVER_STATUS_5,5).         %% 游戏地图服务启动成功
-define(START_SERVER_STATUS_6,6).         %% 游戏端口服务启动成功
-define(START_SERVER_STATUS_7,7).         %% Mochiweb 服务启动成功
-define(START_SERVER_STATUS_8,8).         %% 日志服务启动成功
-define(START_SERVER_STATUS_9,9).         %% 登录服务启动成功
-define(START_SERVER_STATUS_10,10).       %% 初始化地图失败
-define(START_SERVER_STATUS_11,11).       %% 初始化数据成功
-define(START_SERVER_STATUS_12,12).       %% EMysql服务启动成功
-define(START_SERVER_STATUS_99,99).       %% 服务启动异常，启动失败



%% 配置游戏玩家名称，帮派名称是否自动添加后缀.S0----.S1
-define(IS_NAME_SUFFIX,false).

%% 种族定义
-define(FACTION_ID_0,0).
-define(FACTION_ID_1,1).
-define(FACTION_ID_2,2).
-define(FACTION_ID_3,3).

%% 职位定义
-define(CATEGORY_0,0).                     %% 无职业
-define(CATEGORY_1,1).                     %% 1：战士
-define(CATEGORY_2,2).                     %% 2：刺客
-define(CATEGORY_3,3).                     %% 3：法师
-define(CATEGORY_4,4).                     %% 4：医生
-define(CATEGORY_5,5).                     %% 5：控制
-define(CATEGORY_6,6).                     %% 6：辅助

%% 性别
-define(MALE,1).                           %% 1:公 
-define(FEMALE,2).                         %% 2:母

-define(TRUE,1).                           %% 真
-define(FALSE,0).                          %% 假

-export_type([category_type/0]).
-type category_type() :: ?CATEGORY_1 | ?CATEGORY_2 | ?CATEGORY_3 | ?CATEGORY_4 | ?CATEGORY_5 | ?CATEGORY_6.


%% 帐号来源
-define(ACCOUNT_VIA_ADMIN,"-1").           %% 后台管理来源
-define(ACCOUNT_VIA_NORMAL,"0").           %% 未标识来源
-define(ACCOUNT_VIA_SELF,"self").          %% 自主平台
-define(ACCOUNT_VIA_APP_STORE,"store").    %% apple app store
-define(ACCOUNT_VIA_GOOGLE_PLAY,"play").   %% google play
-define(ACCOUNT_VIA_UC,"uc").              %% uc 平台
-define(ACCOUNT_VIA_360,"360").            %% 360 平台
-define(ACCOUNT_VIA_A_91,"a_91").          %% 91 平台 android
-define(ACCOUNT_VIA_I_91,"i_91").          %% 91 平台 apple
-define(ACCOUNT_VIA_A_WDJ,"a_wdj").        %% 豌豆荚 android
-define(ACCOUNT_VIA_A_OUWAN,"a_ouwan").    %% 偶玩 android
-define(ACCOUNT_VIA_I_OUWAN,"i_ouwan").    %% 偶玩 apple
-define(ACCOUNT_VIA_A_MM,"a_mm").          %% 移动MM android
-define(ACCOUNT_VIA_I_MM,"i_mm").          %% 移动MM apple

%% 帐号类型
-define(ACCOUNT_TYPE_NORMAL,0).            %% 0正常
-define(ACCOUNT_TYPE_GM,1).                %% GM帐号
-define(ACCOUNT_TYPE_ADMIN,2).             %% 后台模拟帐号
-define(ACCOUNT_TYPE_INTERNAL,3).          %% 内部帐号
-define(ACCOUNT_TYPE_GUEST,4).             %% 游客帐号 

%% 帐号状态
-define(ACCOUNT_STATUS_NORMAL,0).          %% 帐号状态正常
-define(ACCOUNT_STATUS_BAN,1).             %% 帐号状态禁止状态

%% 角色状态
-define(ACTOR_STATUS_NORMAL,0).            %% 正常
-define(ACTOR_STATUS_ROLE_LOADING_MAP,1).  %% 加载地图中，前端加载地图资源，不需要接受地图广播
-define(ACTOR_STATUS_DIE,2).               %% 死亡

%% 增加经验类型
-define(ADD_EXP_TYPE_NORMAL,0).            %% 一般情况
-define(ADD_EXP_TYPE_MISSION,1).           %% 任务加经验
-define(ADD_EXP_TYPE_GM,2).                %% GM命令加经验
-define(ADD_EXP_TYPE_EXP_GOODS,3).         %% 使用经验符获得经验
-define(ADD_EXP_TYPE_MONSTER,4).           %% 打怪获得经验
-define(ADD_EXP_TYPE_ARENA_DEAL,5).        %% 竞技场提讨好安抚折磨获得经验
-define(ADD_EXP_TYPE_ARENA_SLAVE,6).       %% 竞技场提取经验获得经验
-define(ADD_EXP_TYPE_TRAINING,7).          %% 训练获得经验
-define(ADD_EXP_TYPE_GM_MISSION,8).        %% GM命令完成任务加经验

%% 地图对象类型
-define(ACTOR_TYPE_MAP, 0).                %% 地图（特殊）
-define(ACTOR_TYPE_ROLE,1).                %% 玩家
-define(ACTOR_TYPE_PET,2).                 %% 宠物
-define(ACTOR_TYPE_MONSTER,3).             %% 怪物
-define(ACTOR_TYPE_AVATAR,4).              %% avatar



%% 进程字典key定义

-define(DATA_COPY,data_copy).

%%物品类型
%% 背包的特殊定义
-define(MAX_ITEM_NUMBER,600).              %% 物品的最大个数
-define(MAIN_BAG_ID,1).                    %% 主背包id
-define(ACT_BAG_ID,2).                     %% 活动背包id

%% 道具来源
-define(GOODS_VIA_NORMAL,0).                      %% 一般情况创建
-define(GOODS_VIA_MISSION,1).                     %% 任务获得 
-define(GOODS_VIA_SHOP,2).                        %% 商城购买创建
-define(GOODS_VIA_SHOP_GROUP_BUY,3).              %% 团购创建
-define(GOODS_VIA_ADMIN_SENND_GOODS,4).           %% 管理后台发送创建
-define(GOODS_VIA_MISSION_MONSTER,5).             %% 任务打怪掉落创建

%% 绑定类型 0不绑定1绑定2装备后绑定
-define(GOODS_BIND_TYPE_UNBIND,0).
-define(GOODS_BIND_TYPE_BIND,1).
-define(GOODS_BIND_TYPE_USE_BIND,2).

%% 物品状态, 0正常,1摆摊状态,2装备无效状态,3上锁状态
-define(GOODS_STATUS_NORMAL,0).                   %% 正常状态
-define(GOODS_STATUS_STALL,1).                    %% 摆摊状态
-define(GOODS_STATUS_INVALID,2).                  %% 无效状态
-define(GOODS_STATUS_LOCK,3).                     %% 上锁状态

-define(TYPE_ITEM,  1). %% 道具
-define(TYPE_STONE, 2). %% 宝石
-define(TYPE_EQUIP, 3). %% 装备

-define(CAN_OVERLAP,1). %% 物品可重叠
-define(NOT_OVERLAP,2). %% 物品不可重叠

-define(COLOR_WHITE, 1).    %% 白色
-define(COLOR_GREEN, 2).    %% 绿色
-define(COLOR_BLUE, 3).     %% 蓝色
-define(COLOR_PURPLE, 4).   %% 紫色
-define(COLOR_ORANGE,5).    %% 橙色
-define(COLOR_GOLD,6).      %% 金色

-define(QUALITY_GENERAL, 1).    %% 普通
-define(QUALITY_WELL, 2).       %% 精良
-define(QUALITY_GOOD, 3).       %% 优质
-define(QUALITY_FLAWLESS, 4).   %% 无暇
-define(QUALITY_PERFECT, 5).    %% 完美 

%% 运态道具
-define(DYNAMIC_TYPE_ID_GOLD,10101003).                    %% 10101003 金币锦盒
-define(DYNAMIC_TYPE_ID_SILVER,10101003).                  %% 10101004 银币锦盒
-define(DYNAMIC_TYPE_ID_COIN,10101003).                    %% 10101005 铜币锦盒
-define(DYNAMIC_TYPE_ID_ROLE_EXP,10101003).                %% 10102005 角色经验符
-define(DYNAMIC_TYPE_ID_MAIN_HERO_EXP,10101003).           %% 10103005 将领经验药
-define(DYNAMIC_TYPE_ID_RES_WOOD,10101003).                %% 10105019 木料锦盒
-define(DYNAMIC_TYPE_ID_RES_STONE,10101003).               %% 10105020 石料锦盒
-define(DYNAMIC_TYPE_ID_RES_IRON,10101003).                %% 10105021 铁矿锦盒

%% 聊天
-define(CHANNEL_TYPE_SYSTEM, 0).                           %% 0:系统 【聊频道类型】
-define(CHANNEL_TYPE_WORLD, 1).                            %% 1:世界
-define(CHANNEL_TYPE_CATEGORY, 2).                         %% 2:门派
-define(CHANNEL_TYPE_FAMILY, 3).                           %% 3:帮派
-define(CHANNEL_TYPE_TEAM, 4).                             %% 4:队伍
-define(CHANNEL_TYPE_MAP, 5).                              %% 5:当前【表示当前地图所有人】

-export_type([chat_channel_type/0]).
-type chat_channel_type() :: ?CHANNEL_TYPE_SYSTEM | ?CHANNEL_TYPE_WORLD | ?CHANNEL_TYPE_CATEGORY | ?CHANNEL_TYPE_FAMILY | ?CHANNEL_TYPE_TEAM | ?CHANNEL_TYPE_MAP.

-define(CHAT_MSG_TYPE_NORMAL, 0).                          %% 0:正常【聊天消息类型】
-define(CHAT_MSG_TYPE_JSON, 1).                            %% 1:JSON格式

%% 消息广播类型定义
-define(BC_MSG_TYPE_WORLD, 1).                             %% 1:广播消息，在底部显示
-define(BC_MSG_TYPE_CHAT, 2).                              %% 2:聊天频道
-define(BC_MSG_SUB_TYPE_NONE, 0).                          %% 消息广播类型默认子类型

-export_type([bc_message_type/0]).
-type bc_message_type() :: ?BC_MSG_TYPE_WORLD | ?BC_MSG_TYPE_CHAT.

%% 系统设置
-define(SYS_SCENCE_VOL,1).%%场景音乐
-define(SYS_GAME_VOL,2).  %% 游戏音乐
-define(SYS_BACK_SOUND,3).  %% 背景音乐
-define(SYS_GAME_SOUND,4).   %%游戏音乐
-define(SYS_IMAGE_QUALITY,5).%%画面质量
-define(SYS_CHAT,6). %%开启私聊频道
-define(SYS_SHOW_CLOTH,7).  %% 显示衣服
-define(SYS_PUSH,8).  %% 推送消息

-define(ROLE_ATTR_OP_TYPE_NORMAL,0).                  %% 无分类【属性通知类型】

%% 角色属性定义 编码为四位 XXXX
%% p_role_base
-define(ROLE_BASE_ROLE_NAME,1003).                    %%角色名称
-define(ROLE_BASE_ACCOUNT_VIA,1004).                  %%帐号来源
-define(ROLE_BASE_ACCOUNT_NAME,1005).                 %%帐号名称
-define(ROLE_BASE_ACCOUNT_TYPE,1006).                 %%帐号类型:0正常,1GM帐号,2后台模拟帐号,3内部帐号,4游客帐号
-define(ROLE_BASE_ACCOUNT_STATUS,1007).               %%帐号状态0正常,1禁止登录
-define(ROLE_BASE_CREATE_TIME,1008).                  %%角色创建时间
-define(ROLE_BASE_SEX,1009).                          %%性别：1男，2女
-define(ROLE_BASE_FACTION_ID,1011).                   %%阵营ID
-define(ROLE_BASE_CATEGORY,1012).                     %%角色职业
-define(ROLE_BASE_EXP,1013).                          %%经验值
-define(ROLE_BASE_NEXT_LEVEL_EXP,1014).               %%升级经验
-define(ROLE_BASE_LEVEL,1015).                        %%角色等级
-define(ROLE_BASE_FAMILY_ID,1016).                    %%帮派ID
-define(ROLE_BASE_FAMILY_NAME,1017).                  %%帮派名称
-define(ROLE_BASE_COUPLE_ID,1018).                    %%配偶ID
-define(ROLE_BASE_COUPLE_NAME,1019).                  %%配偶名称
-define(ROLE_BASE_TEAM_ID,1020).                      %%组队ID
-define(ROLE_BASE_IS_PAY,1021).                       %%是否充值过
-define(ROLE_BASE_TOTAL_GOLD,1022).                   %%总元宝
-define(ROLE_BASE_GOLD,1023).                         %%元宝
-define(ROLE_BASE_SILVER,1024).                       %%金币
-define(ROLE_BASE_COIN,1025).                         %%银币
-define(ROLE_BASE_ACTIVITY,1026).                     %%活跃度
-define(ROLE_BASE_GONGXUN,1027).                      %%功勋值
-define(ROLE_BASE_DEVICE_ID,1028).                    %%设备Id,可为空
-define(ROLE_BASE_LAST_DEVICE_ID,1029).               %%最后登录备Id,可为空
-define(ROLE_BASE_LAST_LOGIN_IP,1030).                %%最后一次登陆的IP
-define(ROLE_BASE_LAST_LOGIN_TIME,1031).              %%最后一次登录时间
-define(ROLE_BASE_LAST_OFFLINE_TIME,1032).            %%上次下线时间
-define(ROLE_BASE_TOTAL_ONLINE_TIME,1033).            %%总在线时间
-define(ROLE_BASE_ENERGY,1034).                       %%活力值

%% p_map_role属性变化
-define(MAP_ROLE_GROUP_ID,1200).                     %% 组id变化

%% p_map_pet属性变化
-define(MAP_PET_GROUP_ID,1300).                      %% 组id变化

%% 玩家属性
-define(BASE_ATTR_POWER,1).                           %% 力量
-define(BASE_ATTR_MAGIC,2).                           %% 魔力
-define(BASE_ATTR_BODY,3).                            %% 体质
-define(BASE_ATTR_SPIRIT,4).                          %% 念力
-define(BASE_ATTR_AGILE,5).                           %% 敏捷

%% 战斗属性
-define(FIGHT_ATTR_MAX_HP,1).                         %% 满血
-define(FIGHT_ATTR_HP,2).                             %%
-define(FIGHT_ATTR_MAX_MP,3).                         %% 满魔
-define(FIGHT_ATTR_MP,4).                             %%
-define(FIGHT_ATTR_MAX_ANGER,5).                      %% 满怒
-define(FIGHT_ATTR_ANGER,6).                          %%
-define(FIGHT_ATTR_PHY_ATTACK,7).                     %% 物理攻击力
-define(FIGHT_ATTR_MAGIC_ATTACK,8).                   %% 魔法攻击力
-define(FIGHT_ATTR_PHY_DEFENCE,9).                    %% 物理防御
-define(FIGHT_ATTR_MAGIC_DEFENCE,10).                 %% 魔法防御
-define(FIGHT_ATTR_HIT,11).                           %% 命中
-define(FIGHT_ATTR_MISS,12).                          %% 闪避
-define(FIGHT_ATTR_DOUBLE_ATTACK,13).                 %% 暴击
-define(FIGHT_ATTR_TOUGH,14).                         %% 坚韧
-define(FIGHT_ATTR_SEAL,15).                          %% 封印
-define(FIGHT_ATTR_ANTI_SEAL,16).                     %% 抗封
-define(FIGHT_ATTR_CURE_EFFECT,17).                   %% 治疗强度
-define(FIGHT_ATTR_ATTACK_SKILL,18).                  %% 物法修炼，功击修炼
-define(FIGHT_ATTR_PHY_DEFENCE_SKILL,19).             %% 物防修炼
-define(FIGHT_ATTR_MAGIC_DEFENCE_SKILL,20).           %% 魔防修炼
-define(FIGHT_ATTR_SEAL_SKILL,21).                    %% 抗封修炼

%% 帮派属性定义
-define(FAMILY_FAMILY_ID,6001).                       %% 帮派Id
-define(FAMILY_FAMILY_NAME,6002).                     %% 帮派名称
-define(FAMILY_CREATE_ROLE_ID,6003).                  %% 创建者Id
-define(FAMILY_CREATE_ROLE_NAME,6004).                %% 创建者名称
-define(FAMILY_OWNER_ROLE_ID,6005).                   %% 帮派团长id
-define(FAMILY_OWNER_ROLE_NAME,6006).                 %% 帮派团长名称
-define(FAMILY_FACTION_ID,6007).                      %% 国家Id
-define(FAMILY_LEVEL,6008).                           %% 帮派等级
-define(FAMILY_CREATE_TIME,6009).                     %% 创建时间
-define(FAMILY_CUR_POP,6010).                         %% 当前人口
-define(FAMILY_MAX_POP,6011).                         %% 最大人口
-define(FAMILY_ICON_LEVEL,6012).                      %% 军微等级
-define(FAMILY_TOTAL_CONTRIBUTE,6013).                %% 总贡献度
-define(FAMILY_PUBLIC_NOTICE,6014).                   %% 对外公告
-define(FAMILY_PRIVATE_NOTICE,6015).                  %% 对内公告（暂时未使用）
-define(FAMILY_QQ,6016).                              %% 帮派QQ群

%% 帮派成员属性变化
-define(FAMILY_ROLE_ROLE_NAME,6301).                 %% 玩家名称
-define(FAMILY_ROLE_SEX,6302).                       %% 玩家性别
-define(FAMILY_ROLE_LEVEL,6304).                     %% 玩家等级
-define(FAMILY_ROLE_CATEGORY,6305).                  %% 玩家职业
-define(FAMILY_ROLE_VIP_LEVEL,6306).                 %% VIP等级
-define(FAMILY_ROLE_LAST_LOGIN_TIME,6307).           %% 最后登录时间
-define(FAMILY_ROLE_IS_ONLINE,6308).                 %% 是否在线,0不在线,1在线
-define(FAMILY_ROLE_JOIN_TIME,6309).                 %% 加入帮派时间
-define(FAMILY_ROLE_OFFICE_CODE,6310).               %% 官职编码
-define(FAMILY_ROLE_CUR_CONTRIBUTE,6311).            %% 当强帮派贡献度
-define(FAMILY_ROLE_TOTAL_CONTRIBUTE,6312).          %% 总帮派贡献度
-define(FAMILY_ROLE_CUR_WAR_SCORE,6313).             %% 当前战功
-define(FAMILY_ROLE_TOTAL_WAR_SCORE,6314).           %% 总战功
-define(FAMILY_ROLE_QQ,6315).                        %% QQ号码




%% 锻造定义
-define(FORGING_PARAM_TYPE_TARGET,1).                 %% 1目标
-define(FORGING_PARAM_TYPE_MATERIAL,2).               %% 2材料

-define(FORGING_PARAM_SUB_TYPE_BAG,1).                %% 1背包
-define(FORGING_PARAM_SUB_TYPE_ROLE,2).               %% 2玩家身上


%% #r_equip_info.slot_num 定义
-define(EQUIP_SLOT_NUM_ARMET,1).                      %%  1：头盔
-define(EQUIP_SLOT_NUM_HAND,2).                       %%  2：护肩
-define(EQUIP_SLOT_NUM_BREAST,3).                     %%  3：铠甲
-define(EQUIP_SLOT_NUM_CAESTUS,4).                    %%  4：腰带
-define(EQUIP_SLOT_NUM_SHOES,5).                      %%  5：靴子
-define(EQUIP_SLOT_NUM_ARM,6).                        %%  6：武器
-define(EQUIP_SLOT_NUM_NECKLACE,7).                   %%  7：项链
-define(EQUIP_SLOT_NUM_FINGER,8).                     %%  8：戒指

%% #p_goods.load_position 定义 
-define(UI_LOAD_POSITION_ARMET,1).                    %%  1：头盔
-define(UI_LOAD_POSITION_HAND,2).                     %%  2：护肩
-define(UI_LOAD_POSITION_BREAST,3).                   %%  3：铠甲
-define(UI_LOAD_POSITION_CAESTUS,4).                  %%  4：腰带
-define(UI_LOAD_POSITION_SHOES,5).                    %%  5：靴子
-define(UI_LOAD_POSITION_ARM,6).                      %%  6：武器
-define(UI_LOAD_POSITION_NECKLACE,7).                 %%  7：项链
-define(UI_LOAD_POSITION_FINGER,8).                   %%  8：戒指



%% 宠物宏定义
-define(PET_BAG_ID_MAIN,1).                           %% 1：随身宠物背包
-define(PET_BAG_ID_DEPOT,2).                          %% 2：宠物仓库
-define(PET_BAG_MAIN_MAX_GRID_NUMBER,8).              %% 宠物背包最大格子数
-define(PET_BAG_DEPOT_MAX_GRID_NUMBER,3).             %% 宠物仓库最大格子数

-define(PET_STATUS_NORMAL,0).                         %% 0：正常状态
-define(PET_STATUS_BATTLE,1).                         %% 1：出战
-define(PET_STATUS_DEAD,2).                           %% 2：死亡

-define(PET_BIND_TYPE_NORMAL,0).                      %% 0：正常
-define(PET_BIND_TYPE_BIND,1).                        %% 1：绑定

-define(PET_DISPLAY_TYPE_NORMAL,0).                   %% 0：所有地图显示
-define(PET_DISPLAY_TYPE_FB,1).                       %% 1：只在副本地图显示

-define(PET_BACK_TYPE_NORMAL,0).                      %% 0正常【收回类型】
-define(PET_BACK_TYPE_DEAD,1).                        %% 1宠物死亡

-define(PET_BATTLE_MIN_CD,10).                        %% 宠物出战最小间隔时间，单位：秒
%% 宠物获得来源定义
-define(PET_VIA_CREATE_ROLE,1).                       %% 1：创建角色时获得


%% 怪物宏定义
-define(MONSTER_TYPE_NORMAL,1).                       %% 1：普通怪 【怪物类型】
-define(MONSTER_TYPE_ELITE,2).                        %% 2：精英怪物
-define(MONSTER_TYPE_BOSS,3).                         %% 3：Boss怪物

-define(MONSTER_REBORN_TYPE_NORMAL,0).                %% 0：死掉
-define(MONSTER_REBORN_TYPE_REVIVE,1).                %% 1：复活

-define(MONSTER_ATTACK_MODE_PHY,1).                   %% 1：物理【攻击类型】
-define(MONSTER_ATTACK_MODE_MAGIC,2).                 %% 2：法术

-define(MONSTER_BORN_TYPE_NORMAL,0).                  %% 0：正常出生
-define(MONSTER_BORN_TYPE_NOW,1).                     %% 1：立即出生

%% 【怪物状态】
-define(MONSTER_STATUS_BORN,1).                       %% 1：出生
-define(MONSTER_STATUS_GUARD,2).                      %% 2：警戒 
-define(MONSTER_STATUS_FIGHT,3).                      %% 3：战斗
-define(MONSTER_STATUS_PATROL,4).                     %% 4：巡逻
-define(MONSTER_STATUS_HOLD,5).                       %% 5：保持状态  啥都不做
-define(MONSTER_STATUS_DEAD,6).                       %% 6：死亡
-define(MONSTER_STATUS_FLEE,7).                       %% 7：逃跑 返回到出生点
-define(MONSTER_STATUS_PAUSE,8).                      %% 8：停顿，只需设置下次检查时间，其它操作不变

-define(MONSTER_SKILL_DELAY_YES,1).                   %% 1：是【怪物是否进入技能延迟释放】
-define(MONSTER_SKILL_DELAY_NO,0).                    %% 0：不是

-define(MONSTER_EFFECT_STATUS_FANIT,1).               %% 1：眩晕

-define(MONSTER_WORK_TICK_MIN,200).                   %% 怪物轮询最小时间间隔
-define(MONSTER_WORK_TICK_NORMAL,1000).               %% 怪物轮询正常时间间隔
-define(MONSTER_WORK_TICK_MAX,5000).                  %% 怪物轮询最大时间间隔
-define(MONSTER_MOVE_SPEED,500).                      %% 1秒怪物移动的距离[单位：厘米] 500厘米/1秒
-define(MONSTER_WORK_MIN_TILE,3).                     %% 每一次怪物走路最小格子设置同步一下坐标

-define(MONSTER_MAX_ENEMY_DISTANCE,700).              %% 怪物获取仇恨列表时，超过这个距离的优先级低

-define(MONSTER_AI_ATTACK_TYPE_NONE,0).               %% 0：不攻击 【攻击类型】
-define(MONSTER_AI_ATTACK_TYPE_ACTIVE,1).             %% 1：被动攻击
-define(MONSTER_AI_ATTACK_TYPE_PASSIVE,2).            %% 2：主动攻击

-define(MONSTER_AI_MOVE_TYPE_NO,0).                   %% 0：不会移动 【移动类型】
-define(MONSTER_AI_MOVE_TYPE_CAN,1).                  %% 1：会移动

-define(MONSTER_ATTACK_INTERVAL,250).                 %% 怪物受击时间：单位：毫秒
-define(MONSTER_ATTACK_CHANGE_TARGET,5000).           %% 怪物攻击切换目标，间隔时间，单位：毫秒
-define(MONSTER_ATTACK_CHANGE_TARGET_BOSS,8000).      %% 怪物攻击切换目标，间隔时间，单位：毫秒

%% 怪物AI触发类型
-define(MONSTER_AI_TRIGGER_SKILL_CD,1).               %% 1：技能CD
-define(MONSTER_AI_TRIGGER_HP,2).                     %% 2：血量从上往下经过x%线,触发值A表示当前血量的占总血量百分比
-define(MONSTER_AI_TRIGGER_BE_ATTACKED,3).            %% 3：被攻击时概率触发,触发值A表示触发万分比
-define(MONSTER_AI_TRIGGER_FIGHT,4).                  %% 4：攻击时概率触发,触发值A表示触发万分比
-define(MONSTER_AI_TRIGGER_FIRST_FIGHT,5).            %% 5：首次攻击状态触发,触发值A表示触发万分比
-define(MONSTER_AI_TRIGGER_TIME_INTERVAL,6).          %% 6：进入攻击状态，间隔时间触发，单毫秒
-define(MONSTER_AI_TRIGGER_IN_TIME,7).                %% 7：进入攻击状态，第几毫少触发

%% 怪物AI事件类型
-define(MONSTER_AI_EVENT_TYPE_SKILL,1).               %% 1：触发技能，事件值A表示技能ID,事件值B表示技能等级
-define(MONSTER_AI_EVENT_TYPE_SUICIDE,2).             %% 2：怪物自杀，事件A表示命中万分比
-define(MONSTER_AI_EVENT_TYPE_FLEE,3).                %% 3：怪物逃跑，逃跑到出生点，事件A表示命中万分比

%% 副本系统
-define(FB_FB_TYPE_NONE,0).                           %% 0：未知
-define(FB_FB_TYPE_PERSON,1).                         %% 1：单人副本
-define(FB_FB_TYPE_TEAM,2).                           %% 2：组队副本

-define(FB_CREATE_AVATAR_NO,0).                       %% 0：不创建【在副本入口创建角色镜像】
-define(FB_CREATE_AVATAR_YES,1).                      %% 1：创建

-define(FB_CREATE_MAP_PROCESS_TYPE_NO,0).             %% 0：进入副本创建【创建地图进程类型】 1：游戏启动创建
-define(FB_CREATE_MAP_PROCESS_TYPE_YES,1).            %% 1：游戏启动创建

-define(FB_TIMES_TYPE_NONE,0).                        %% 0：未知
-define(FB_TIMES_TYPE_DAY,1).                         %% 1：每日清零【副本次数类型】
-define(FB_TIMES_TYPE_WEEK,2).                        %% 2：每周清零

-define(FB_BORN_TYPE_NONE,0).                         %% 0：直接全部怪物出生
-define(FB_BORN_TYPE_BATCH_1,1).                      %% 1：一波一波出生，一波怪物被清光，立即出生下一波怪物
-define(FB_BORN_TYPE_BATCH_2,2).                      %% 2：一波一波出生，按每一波怪的出生时间间隔，出生下一波怪物
-define(FB_BORN_TYPE_BATCH_3,3).                      %% 3：一波一波出生，一波怪清光，等待间隔时间，出生下一波怪物
-define(FB_BORN_TYPE_BATCH_4,4).                      %% 4：一波一波出生，一波怪物被清光，立即出生下一波怪物，同时间隔时间到了，也出生下一波怪物

-define(FB_MONSTER_BORN_STATUS_INIT,0).               %% 0:未开始【副本怪物出生状态】
-define(FB_MONSTER_BORN_STATUS_IN,1).                 %% 1:开始
-define(FB_MONSTER_BORN_STATUS_DONE,2).               %% 2:完成

-export_type([actor_type/0]).
-type actor_type() :: ?ACTOR_TYPE_MONSTER | ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET.

