%%----------------------------------------------------
%% 角色资产类属性数据结构
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------

%% 各数值上限（数据库数值上限：21亿)
-define(MAX_GOLD,       100000000).
-define(MAX_COIN,       1000000000).
-define(MAX_COIN_BIND,  1000000000).
-define(MAX_ATTAINMENT, 10000000).
-define(MAX_PSYCHIC,    1000000000).
%% 单次增益数值上限
-define(SINGLE_GOLD,       100000000).
-define(SINGLE_COIN,       10000000).
-define(SINGLE_COIN_BIND,  1000000).
-define(SINGLE_EXP,        5000000).
-define(SINGLE_PSYCHIC,    2500000).
-define(SINGLE_ATTAINMENT, 2000).
-define(SINGLE_ENERGY,     100).

%% 角色资产类属性
-record(assets, {
         exp = 0                %% 经验
        ,gold = 0               %% 晶钻
        ,gold_bind = 0          %% 梆定晶钻
        ,coin = 0               %% 铜币
        ,coin_bind = 0          %% 梆定铜
        ,psychic = 0            %% 灵力值
        ,honor = 0              %% 荣誉值
        ,badge = 0              %% 纹章值
        ,energy =  200          %% 精力值/活跃度
        ,attainment = 0         %% 阅历值
        ,prestige = 0           %% 声望值/功勋值
        ,hearsay = 0            %% 传音次数
        ,charm = 0              %% 魅力值
        ,flower = 0             %% 送花积分
        ,gold_integral = 0      %% 充值返还晶钻积分
        ,arena = 0              %% 竞技场积分
        ,acc_arena = 0          %% 竞技场累计总积分(不会扣除)
        ,charge = 0             %% 充值数, 单位:晶钻
        ,career_devote = 0      %% 师门贡献值
        ,both_time = 0          %% 双修时间
        ,guild_war = 0          %% 帮战积分
        ,guild_war_acc = 0      %% 帮战累计积分
        ,guard_acc = 0          %% 守卫洛水累计积分
        ,lilian = 0             %% 仙道历练
        ,wc_lev = 0             %% 仙道勋章等级
        ,practice_acc = 0       %% 试练总积分
        ,practice = 0           %% 试练积分
        ,seal_exp = 0           %% 封印中的经验值
        ,soul = 0               %% 魂气
        ,soul_acc = 0           %% 魂气 累积
        ,scale = 0              %% 龙鳞
        ,cooperation = 0          %% 合作值（远征王军）
        ,stone = 0              %% 符石
    }
).
