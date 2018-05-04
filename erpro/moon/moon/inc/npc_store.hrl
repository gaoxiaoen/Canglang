%%----------------------------------------------------
%% NPC商店相关数据结构定义
%% 
%% @author 252563398.com
%%----------------------------------------------------

-define(NPC_STORE_VER, 1).

%% 价格类型
-define(npc_store_refresh_sm, -1). %% 神秘商店刷新(特殊标志)
-define(npc_store_nor_coin, 0).    %% 普通金币商店类型
-define(npc_store_bind_coin, 1).   %% 绑定金币商店类型
-define(npc_store_arena_score, 2). %% 竞技场积分商店类型
-define(npc_store_nor_gold, 3).    %% 晶钻
-define(npc_store_bind_gold, 4).   %% 绑定晶钻
-define(npc_store_coin_all, 5).    %% 绑定金币与金币商店类型（优先扣除绑定金币）
-define(npc_store_career_devote, 6). %% 师门积分
-define(npc_store_guild_war, 7).     %% 帮战积分
-define(npc_store_guild_devote, 8).  %% 帮会贡献
-define(npc_store_practice, 10).     %% 试练积分
-define(npc_store_lilian, 11).       %% 仙道历练
-define(npc_store_buchong, 12).       %% 捕宠达人

%% 神秘商店
-define(refresh_time, 21600). %% 神秘商店超时刷新时间 
-define(npc_store_sm_num, 8).      %% 神秘商店出现物品个数
-define(npc_store_sm_log_num, 18). %% 神秘商店日志显示数量

%% 神秘商店限制类型
-define(npc_store_sm_limit_global, 1).   %% 全服限制类型
-define(npc_store_sm_limit_role, 2).     %% 个人限制类型
-define(limit_global, 1).   %% 全服限制类型
-define(limit_role, 2).     %% 个人限制类型
-define(base_free, 2).     %% 个人基础免费次数

-define(npc_store_live_min_activity, 50). %% 玩家活跃下限值
-define(npc_store_live_base, [
        {30020, 10000, 100}
        ,{30021, 1000, 10}
    ]).  %% 动态商店基础数据
-define(npc_store_live_bind_items, [
        {30020, 10000}, {30021, 1000}, {30022, 10000}, {30023, 1000}
    ]
). %% 动态商店基础数据 产出绑定金币物品价格列表

%% NPC商店数据
-record(npc_store_base, {
        npc_id        %% NPC基础ID
        ,name = <<>>  %% NPC名称 
        ,type = 0     %% 出售类型 0:金币和绑定金币 2:积分
        ,price_key    %% 价格键 指向物品项 #item_base.value
        ,items = []   %% 出售物品基础ID
    }
).

%% 神秘NPC商店
-record(npc_store_base_sm, {
        base_id        %% 物品基础ID
        ,name          %% 物品名称
        ,price         %% 物品价格
        ,price_type    %% 价格类型
        ,rand          %% 随机概率分子 分母为:10000
        ,limit_type = 1%% 限制类型:(1:全服 2:个人)
        ,limit_time    %% 限制时间内出现次数（秒）:{Time, N}
        ,limit_num     %% 限制物品出现N次后需要刷新X次之后才可能再次出现格式：{N,X}
        ,is_notice = 0 %% 是否公告 0:不公告 1:公告
        ,is_music = 0  %% 是否音乐 0:不音乐 1:音乐
    }
).

%% 个人神秘商店物品数据
-record(npc_store_sm_item, {
        id = 0         %% 物品唯一ID  
        ,base_id       %% 物品基础ID
        ,price         %% 物品价格
        ,price_type    %% 价格类型
        ,num = 1       %% 物品数量
        ,is_notice = 0 %% 是否公告 0:不公告 1:公告
        ,is_music = 0  %% 是否音乐 0:不音乐 1:音乐
    }
).

%% 个人神秘商店数据
-record(npc_store_sm_role, {
        id                  %% 角色ID {rid, srv_id}
        ,refresh_time = 0   %% 下次刷新时间
        ,refresh_type = 0   %% 1:到点刷新 0:晶钻刷新
        ,items = []         %% 物品列表 #npc_store_sm_item{} 
    }
).

%% 神秘商店刷新操作情况
-record(npc_store_sm_refresh, {
        base_id          %% 物品基础ID
        ,limit_time = 0  %% 上次物品刷新次数限制开始时间
        ,time_num = 0    %% 限制时间开始刷新次数
        ,limit_num = 0   %% 物品出现次数:N + X 次数后重新从0计算
        ,refresh_num = 0 %% 在限制次数后刷新次数
    }
).

%% 神秘商店购买记录日志
-record(npc_store_sm_log, {
        rid         %% 角色Id
        ,srv_id     %% 角色服务器标志
        ,name       %% 角色名称
        ,base_id    %% 购买物品
        ,num        %% 购买数量
        ,price      %% 物品单价
        ,price_type %% 价格类型
        ,buy_time   %% 购买时间
    }
).

%% 人物NPC商店操作记录
-record(npc_store, {
        ver = ?NPC_STORE_VER
        ,day = 0           %% 当天时间，不是当天重新初始化
        ,log = []          %% 角色NPC商店操作记录:{积分类型, 次数, 数量} = {2,1,1}
        ,sm_refresh = []   %% 个人神秘商店刷新记录
        ,acc_gold = {0, 0}  %% 累计消费晶钻 {仙境寻宝, 神秘商店}
    }
).

%% 人物NPC商店操作记录
-record(npc_store2, {
        ver = ?NPC_STORE_VER
        ,free_times = 2         %%免费刷新的次数
        ,last_time = 0          %%上次刷新的时间
        ,last_refresh_item = [] %%物品id
    }
).

%% 龙族遗迹物品数据结构by bwang
-record(npc_store_base_item, {
        item_id = 0                    %% 物品id
        ,weight = 0                    %% 权重
        ,weight_temp = 0               %% 存放暂时的权重
        ,times_max                     %% 保底次数，表示连续N次内必须出现 
        ,times_max_undisplay           %% 表示连续N次未出现 
        ,times_limit_display           %% 限制次数内已经出现的次数 
        ,times_limit                   %% 限制次数 
        ,times_terminate               %% 禁用次数
        ,count                         %% 计算刷新的次数，概率被清零时开始计算，概率恢复则清零计数器 
        ,order = 0                     %% 由于相同物品有不同价格，添加order作为主键用
    }
).
%% 龙族遗迹物品数据结构by bwang
-record(npc_store_item2, {
        item_id = 0                    %% 物品id
        ,item_name = <<>>              %% 物品名称
        ,price = 0                     %% 购买的价格
        ,price_type = 0                %% 消费类型
        ,is_notice = 0                 %% 1公告，0不公告（系统消息）
        ,is_music = 0                  %% 1为播放音乐，0不播放
        ,is_recommend = 0              %% 1为推荐，0非推荐
    }
).




%% ---------------------------------------------
%% 高级副本随机神秘商店(部分结构定义与神秘商店类似)
-define(npc_store_dung_item_all, 4).        %% npc商品列表个数
-define(npc_store_dung_sale_per_role, 1).   %% 单个角色可购买数量

%% 单个副本神秘商店
-record(dung_store, {
        npc_id = 0          %% Npc老人ID
        ,map = 0            %% npc商店所在地图ID
        ,map_base = 0       %% npc商店所在地图基础ID
        ,items = []         %% 当前产出可售物品列表[#store_item{} | ...]
        ,log = []           %% 已售记录[{{RoleId, BaseId}, Num} | ...]
        ,ctime = 0          %% 出现时间
    }).

%% 玩家副本神秘商店相关信息(ets缓存, sys_env持久化)
-record(dung_store_role, {
        id = {0, <<>>}      %% 玩家{角色ID, 服务器标识}
        ,info = []          %% 限制信息
    }).

%% 随机产出/刷新限制信息
-record(rand_info, {
        id = 0              %% 商品ID
        ,last_time = 0      %% 上次产出时间
        ,time_info = {0, 0} %% {X,Y}:X表示时间限制终点；Y标示目前已开出次数；超时后重置
        ,num_info = {0, 0}  %% {X,Y}:X表示已抽中个数；Y表示抽空次数；超次数后重置
        ,lucky_num = 0      %% 已抽中X次
    }).

%% 商店物品基础结构
-record(store_item_base, {
        base_id = 0             %% 物品BaseId
        ,name = <<>>            %% 物品名称
        ,price_type = 0         %% 价格类型
        ,price = 0              %% 单价
        ,num = 1                %% 可售数量(默认1)
        ,rand = 0               %% 随机因子
        ,limit = 1              %% 限制类型
        ,limit_time = {0, 0}    %% 单位时间内个数限制{X, Y}, X秒时间内只出Y个; Y等于0时表示此项限制无效% 时间限制信息
        ,limit_num = {0, 0}     %% {X,Y} 物品出X个后，需要再抽Y次才能出; Y等于0时表示此项限制无效
        ,must_num = 0           %% X次抽奖未出后必出; 等于0时表示此项限制无效 -- 【 %% 暂时不用 】
        ,is_notice = 0          %% 是否需要公告
    }).

%% 商店购买记录日志
-record(npc_store_dung_log, {
        rid                     %% 角色Id
        ,srv_id                 %% 服务器标志
        ,name                   %% 角色名称
        ,base_id                %% 购买物品(非商品ID)
        ,num                    %% 购买数量
        ,price                  %% 物品单价
        ,price_type             %% 价格类型
        ,buy_time               %% 购买时间
    }).
