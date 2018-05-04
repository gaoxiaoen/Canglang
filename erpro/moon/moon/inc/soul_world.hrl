%%----------------------------------------------------
%% @doc 个人灵魂数据结构
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-define(soul_world_gold_call_max_luck, 300). %% 晶钻召唤最大幸运值
-define(soul_world_gold_call_start_luck, 16). %% 晶钻召唤开始出现值
-define(soul_world_coin_call_max_luck, 300). %% 金币召唤最大幸运值
-define(soul_world_coin_call_start_luck, 16). %% 金币召唤最开始出现值
-define(soul_world_ver, 4).     %% 玩家数据版本
-define(soul_world_free_call_time, 2). %% 每天可免费刷新次数
-record(soul_world, {
        ver = ?soul_world_ver   %% 版本号
        ,spirits = []    %% 获得的妖灵
        ,spirit_num = 0 %% 获得的妖灵数量
        ,calleds = []     %% 召唤但未唤醒的妖灵
        ,arrays = []     %% 封魔阵
        ,quality_nums = []     %% 各品质的妖灵数量列表
        ,array_lev = 1  %% 神魔阵总等级
        ,orange_luck = 0  %% 刷出橙色妖灵的幸运值
        ,purple_luck= 0  %% 刷出紫色色妖灵的幸运值
        ,last_called = 0    %% 最后召唤时间
        ,today_called = 0   %% 今天召唤次数
        ,pet_arrays = []    %% 宠物阵
        ,pet_array_lev = 1  %% 宠物阵等级
        ,workshop = []     %% 生产坊激活列表
        ,product_line = 1   %% 生产线数量
        ,workshop_spirit_id = 0 %% 封印在生产坊妖灵id
        ,workshop_id = 1    %% 当前可用工作坊id
        ,workshop_producing = [] %% 当前生产列表
    }).

%% 排行榜数据
-record(soul_world_role, {
        id = {0, <<>>}  %% 角色id
        ,name = <<>>    %% 性别
        ,career = 6     %% 职业
        ,sex = 0        %% 性别
        ,face_id = 0    %% 头像id
        ,array_lev = 1  %% 神魔阵总等级
        ,spirits = []    %% 获得的妖灵
        ,spirit_num = 0 %% 获得的妖灵数量
        ,arrays = []     %% 封魔阵
        ,pet_arrays = []    %% 宠物阵
        ,pet_array_lev = 1  %% 宠物阵等级
    }).

%% 妖灵法宝数据
-record(soul_world_spirit_magic, {
        type            %% 法宝类型
        ,lev = 1        %% 法宝等级
        ,fc = 0   %% 加成效果
        ,addition = 0   %% 加成效果（万分率）
        ,luck = 0    %% 幸运值
        ,max_luck= 15    %% 最大幸运值
    }).

%% 妖灵属性结构
-record(soul_world_spirit, {
        id              %% 妖灵id  
        ,name           %% 名字
        ,lev = 1        %% 等级
        ,quality = 1    %% 品质
        ,exp = 0        %% 经验
        ,max_exp = 0    %% 本级最大经验
        ,fc = 0         %% 战力
        ,array_id = 0   %% 是否被封印
        ,generation = 0   %% 生产
        ,magics = [     %% 法宝
            #soul_world_spirit_magic{type = 1, fc = 40, max_luck = 15}
            ,#soul_world_spirit_magic{type = 2, addition = 18, max_luck = 15}
        ]      
        ,called = 0       %% 是否召唤过
    }).

%% 阵法数据
-record(soul_world_array, {
        id              %% 封印id
        ,lev = 0        %% 封印等级
        ,spirit_id = 0  %% 封印的妖灵id
        ,fc = 0         %% 封印的基础值
        ,upgrade_finish = 0    %% 升级结束时间
        ,attr = 0       %% 转换成的战斗力
    }).

%% 生产坊配置
-record(soul_world_workshop_base, {
        item_id %% 生产的物品类型
        ,unlock_fc = 0  %% 激活所需总战力要求
        ,unlock_coin = 0    %% 激活所需金币
        ,unlock_gold = 0    %% 激活所需晶钻
        ,produce_coin = 0   %% 生产所需金币
        ,produce_gold = 0   %% 生产所需晶钻
        ,produce_time = 0   %% 生产所需时间
    }).
-record(soul_world_workshop, {
        id
        ,item_id %% 生产的物品类型
        ,num = 1    %% 生产数量
        ,produce_time = 0   %% 生产所需时间
    }).
