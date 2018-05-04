%%----------------------------------------------------
%% @doc 新活跃度系统，原来的activity模块现在已经用来专门处理精力值，现在活跃度统一在这里处理
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
%% 角色活跃度数据结构
-record(activity2, {
        last_active = 0   %% 最后更新时间
        ,actions = []       %% 要监听的事件
        ,rewarded = []      %% 已领取的奖励
        ,current = 0           %% 当前活跃值
    }).

%% 事件数据结构
-record(activity2_event, {
        id     %% 事件id
        ,label %% 事件类型
        ,trigger_id = 0 %% 触发器id
        ,type = 0       %% 事件类型id
        ,target = 1     %% 目标次数
        ,point  = 3     %% 可得活跃值
        ,current = 0    %% 当前值
        ,status = 0     %% 状态
        ,lev    = 30     %% 等级限制
    }).

%% 数据中心统计记录
-record(activity2_log_role, {
        id = {0, <<>>}      %% 角色id
        ,lev = 0            %% 角色等级
        ,date = {0, 0, 0}   %% 统计时间{年，月，日}
        ,activitys = []
    }).

%% 单个活动参与记录
-record(activity2_log_event, {
        id = 0      %% 事件id
        ,finish = 0     %% 参与次数
        ,has_task = 0   %% 0没接任务，1有接任务，2完成任务
    }).
