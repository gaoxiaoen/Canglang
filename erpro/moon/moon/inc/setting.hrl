%%----------------------------------------------------
%% 角色设置 
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------

%% 经验封印操作种类
-define(exp_seal_opt_read, 1).
-define(exp_seal_opt_open, 2).
-define(exp_seal_opt_close, 3).
-define(exp_seal_opt_upgrade, 4).
-define(exp_seal_opt_release, 5).
%% 经验封印状态
-define(exp_seal_status_zero, 0).
-define(exp_seal_status_open, 1).
-define(exp_seal_status_close, 2).

%%各种屏蔽
-define(shield_private_chat, 1).
-define(shield_world_chat, 2).
-define(shield_guild_chat, 3).
-define(shield_role, 4).
-define(shield_pet, 5).
-define(shield_medal, 6).
-define(shield_fashion, 7).

%% 外观显示开关
%% 时装, 武器时装, 饰品时装
-record(dress_looks, {
        dress = 1
        ,weapon_dress = 1
        ,all_looks = 1             %% 全身强化
        ,mount_dress = 1          %% 坐骑外观
        ,footprint = 1            %% 足迹外观
        ,chat_frame = 1           %% 聊天框
        ,wing = 1               %% 翅膀
    }).

%% 经验封印
-record(exp_seal, {
        status = ?exp_seal_status_zero      %% 开闭状态 0=从未开启，1=开启，2=关闭
        ,top = 0                            %% 经验上限
        ,exdata = 0                         %% 无用
    }).

%% 在线角色数据集合
-record(setting, {
        dress_looks = #dress_looks{}     %% #dress_looks 外观显示列表 
        ,plock                           %% #plock{} 密码锁
        ,skill                           %% #skill_shortcuts{} 挂机快捷栏(可重复)
        ,hook_status = 0                 %% 是否启用挂机技能列表
        ,exp_seal = #exp_seal{}          %% #exp_seal{} 经验封印
        ,shield = []                     %% 各种屏蔽[Label...] :: ?shield_xx
    }).


%% ------------------------------
%% 密码、保护锁相关
%% 保护锁按照操作类型进行保护：
%%     物品操作、市场交易、晶钻消费、帮派贡献、铸造
-record(plock, {
        is_lock = 0     %% 是否已解锁0:已解 1:未解
        ,has_lock = 0   %% 是否有锁0:无 1:有
        ,password       %% 密码
        ,q1             %% 密保问题1 string()
        ,a1             %% 密保答案1
        ,q2             %% 密保问题2
        ,a2             %% 密保答案2
        ,log = []       %% 操作日志
    }).
