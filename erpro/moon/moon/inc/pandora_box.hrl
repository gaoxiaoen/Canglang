%%----------------------------------------------------
%% 梦幻宝盒相关数据结构定义
%% 
%% @author wpf(wprehard@qq.com)
%%----------------------------------------------------

%% 随机物品基础结构
-record(rand_base, {
        base_id = 0             %% 物品BaseId
        ,name = <<>>            %% 物品名称
        ,price = 0              %% 晶钻单价
        ,num = 1                %% 可售数量(默认1)
        ,bind = 1               %% 是否绑定
        ,rand = 0               %% 随机因子
        ,limit = 0              %% 限制类型[1-系统, 2-单人]
        ,limit_time = {0, 0}    %% 单位时间内个数限制{X, Y}, X秒时间内只出Y个; Y等于0时表示此项限制无效% 时间限制信息
        ,limit_num = {0, 0}     %% {X,Y} 物品出X个后，需要再抽Y次才能出; Y等于0时表示此项限制无效
        ,must_num = 0           %% X次抽奖未出后必出; 等于0时表示此项限制无效 -- 【 %% 暂时不用 】
        ,is_notice = 0          %% 是否需要公告
    }).

%% 随机产出/刷新限制信息
-record(rand_info, {
        id = 0                  %% 物品ID
        ,last_time = 0          %% 上次产出时间
        ,time_info = {0, 0}     %% {X,Y}:X表示时间限制终点；Y标示目前已开出次数；超时后重置
        ,num_info = {0, 0}      %% {X,Y}:X表示已抽中个数；Y表示抽空次数；超次数后重置
        ,lucky_num = 0          %% 已刷新X次
    }).


-record(limit_state, {
        flag = {0, 0}           %% {职业，性别}
        ,limit = []             %% 全服限制：[#rand_info{}]
    }).

-record(role_pandora_box, {
        rid = {0, <<>>}
        ,name = <<>>
        ,limit = []             %% 玩家限制：[#rand_info{}]
    }).
