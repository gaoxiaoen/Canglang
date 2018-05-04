%%----------------------------------------------------
%% VIP相关数据结构定义 
%% @author yeahoo2000@gmail.com
%% @author 252563398@qq.com
%%----------------------------------------------------
-define(VIP_VER, 4).

%% VIP类型
-define(vip_no,         0). %% 非vip
-define(vip_week,       1). %% 周卡
-define(vip_month,      2). %% 月卡
-define(vip_half_year,  4). %% 半年卡
-define(vip_try,       10). %% VIP体验卡
-define(vip_list, [?vip_no, ?vip_week, ?vip_month, ?vip_half_year, ?vip_try]).  %% 所有的VIP列表，即，系统合法VIP列表

%% vip类型  过期时间(单位：秒)
-define(vip_expire_week,    604800).
-define(vip_expire_month,   2592000).
-define(vip_expire_half,    23328000).

-define(vip_reward_gold_bind, 1). %% 绑定晶钻奖励
-define(vip_reward_in_map, 2).    %% 进入VIP挂机地图
-define(vip_reward_out_map, 3).   %% 退出VIP挂机

-define(vip_boss_list, [25026, 25027, 25028, 25054, 22905]).       %% VIP挂机地图BOSS列表

%% vip礼包基础
-record(risk_gift_base, {
        lev = 0
        ,time = 0
        ,coin = 0
        ,effect = []       %% vip礼包所具有的特权
    }).

%% vip礼包基础
-record(vip_gift_base, {
        base_id = 0
        ,price = 0
    }).

%% vip基础
-record(vip_base, {
        type = 0
        ,name = <<>>
        ,title = <<>>
        ,time = 0
        ,buff              %% 指向BUFF
        ,effect = []       %% vip等级所具有的特权
    }).


%% 角色VIP属性
-record(vip, {
        ver = ?VIP_VER
        ,type = 0            %% VIP类型
        ,expire = 0         %% VIP过期时间
        ,portrait_id = 0    %% VIP头像ID
        ,special_time = 0   %% 最后一次领取特权福利时间
        ,buff_time = 0      %% 最后一次领取BUFF时间
        ,hearsay = 0        %% 传音次数
        ,fly_sign = 0       %% 飞天符
        ,is_try = 0         %% 是否试用过体验卡
        ,reward_times = []  %% 奖励领取时间 [{类型, 最后领取时间}...]
        ,face_list = []     %% 头像列表
        ,all_gold = 0       %% 累积晶砖
        ,effect = []        %% 总的特权
        ,charge_cnt = 0     %% 累积充值次数
        ,mail_list = []     %% 神秘来信
        ,item_flag = 0      %% 0-可以接收首次缺卷轴的神秘来信
    }
).
