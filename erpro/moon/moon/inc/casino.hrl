%%----------------------------------------------------
%% 仙境寻宝--开宝箱 数据结构
%% @author whjing2011@gmail.com
%%----------------------------------------------------

%% 限制类型
-define(casino_limit_type_role, 1).    %% 个人
-define(casino_limit_type_global, 2).  %% 全服

-define(casino_max_log_num, 20).  %% 限制日志数据量

-define(casino_type_one, 1).            %% 类型:龙宫仙境
-define(casino_type_two, 2).            %% 类型:仙府秘境
-define(casino_type_three, 3).          %% 类型:天官赐福
-define(casino_type_four, 4).           %% 类型:吉祥道场
-define(new_item, 1).                   %% 类型:刚爆炸出的物品，未被整理
-define(old_item, 0).                   %% 类型:旧物品


-define(casino_type_list, [?casino_type_one, ?casino_type_two, ?casino_type_three, ?casino_type_four]). %% 类型列表

%% 物品基础数据
-record(casino_base_data, {
        type                    %% 揭开类型
        ,is_default = 0         %% 是否默认类型
        ,base_id                %% 物品ID
        ,name = <<>>            %% 物品名称
        ,rand = 0               %% 掉落概率分子
        ,limit_type = 1         %% 限制类型 (1:个人 2:全服)
        ,limit_time = {0, 0}    %% 时间限制 {X, Y}时间X内只会出现Y个该物品
        ,limit_num = {0, 0}     %% 限制物品出现N次后需要刷新X次之后才可能再次出现格式：{N,X}
        ,must_out = 0           %% N次没有出之后，必然会出现物品
        ,is_notice = 0          %% 是否公告 0:不公告 1:公告
        ,sort = -1              %% 物品排序
        ,bind = 0               %% 是否绑定物品 0:非绑定 1:绑定
        ,num = 1                %% 数量
        ,sex = -1               %% 性别 -1为无限制
        ,career = -1            %% 职业 -1为无限制
        ,can_out = 0            %% 必需需新多少次后才有可能出现 0:无限制
    }
).

%% 开宝箱操作情况
-record(casino_open, {
        base_id                 %% 物品ID
        ,limit_time = {0, 0}    %% 限制时间开始刷新次数{X, Y} X时候内最多出现Y次  Y为0表示不限制
        ,limit_num = {0, 0}     %% 物品出现次数:{X, Y} 物品出现X次后需揭开Y次才能再出现 X+Y次数后重新从0计算 Y为0表示不限制
        ,open_num = 0           %% 揭开次数,达到必出次数后出现此物品后清0
        ,acc_open = 0           %% 累计揭开次数
    }
).

%% 揭开记录日志
-record(casino_log, {
        rid         %% 角色Id
        ,srv_id     %% 角色服务器标志
        ,name       %% 角色名称
        ,type       %% 揭开类型
        ,base_id    %% 购买物品
        ,num = 1    %% 购买数量
        ,get_time   %% 购买时间
        ,bind = 0   %% 物品绑定类型 (0:非绑定 1:绑定)
        ,is_notice = 0 %% 是否公告
    }
).

%%--------------------------------
%% 盘龙探宝
%%--------------------------------

%% 物品基础数据
-record(super_boss_casino_base, {
        is_default = 0         %% 是否默认类型
        ,base_id                %% 物品ID
        ,name = <<>>            %% 物品名称
        ,rand = 0               %% 掉落概率分子
        ,limit_type = 1         %% 限制类型 (1:个人 2:全服)
        ,limit_time = {0, 0}    %% 时间限制 {X, Y}时间X内只会出现Y个该物品
        ,limit_num = {0, 0}     %% 限制物品出现N次后需要刷新X次之后才可能再次出现格式：{N,X}
        ,must_out = 0           %% N次没有出之后，必然会出现物品
        ,is_notice = 0          %% 是否公告 0:不公告 1:公告
        ,bind = 0               %% 是否绑定物品 0:非绑定 1:绑定
        ,num = 1                %% 数量
        ,sort = -1              %% 物品排序
    }
).

%% 开宝箱操作情况
-record(super_boss_casino_open, {
        base_id                 %% 物品ID
        ,limit_time = {0, 0}    %% 限制时间开始刷新次数{X, Y} X时候内最多出现Y次  Y为0表示不限制
        ,limit_num = {0, 0}     %% 物品出现次数:{X, Y} 物品出现X次后需揭开Y次才能再出现 X+Y次数后重新从0计算 Y为0表示不限制
        ,open_num = 0        %% 揭开次数,达到必出次数后出现此物品后清0
    }
).

%% 揭开记录日志
-record(super_boss_casino_log, {
        rid         %% 角色Id
        ,srv_id     %% 角色服务器标志
        ,name       %% 角色名称
        ,type       %% 揭开类型
        ,base_id    %% 物品
        ,num = 1    %% 数量
        ,get_time   %% 时间
        ,bind = 0   %% 物品绑定类型 (0:非绑定 1:绑定)
        ,is_notice = 0 %% 是否公告
    }).


%% 地下集市物品数据结构 by bwang
-record(casino_base_item, {
        item_id = 0                    %% 物品id
        ,weight = 0                    %% 权重
        ,weight_temp = 0               %% 存放暂时的权重
        ,times_max = 0                 %% 保底次数，表示连续N次内必须出现 
        ,times_max_undisplay = 0       %% 表示连续N次未出现 
        ,times_limit_display = 0       %% 限制次数内已经出现的次数 
        ,times_limit = 0               %% 限制次数 
        ,times_terminate = 0           %% 禁用次数
        ,count = 0                     %% 计算刷新的次数，概率被清零时开始计算，概率恢复则清零计数器 
        ,is_notice = 0                 %% 1公告，0不公告（系统消息）
    }).

