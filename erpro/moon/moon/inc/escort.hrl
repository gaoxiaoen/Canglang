%%----------------------------------------------------
%% @doc 运镖系统
%%
%% <pre>
%% 运镖系统
%% </pre> 
%% @author yqhuang(QQ:19123767)
%%----------------------------------------------------

%% 操作结果
-define(escort_op_fail,  0).    %% 失败
-define(escort_op_succ,  1).    %% 成功

-define(escort_times,    3).    %% 当天押镖次数

-define(escort_token_green, 31001). %% 飞仙令牌.绿
-define(escort_token_blue, 31002). %% 飞仙令牌.蓝

-define(escort_child_refresh_item, 33083).  %% 小屁孩刷新物品 奥运火炬
-define(escort_child_award_item, 33082).    %% 小屁孩子品质奖励 奥运火炬
-define(escort_child_buff_label, escort_olympic).    %% buff标签

-define(escort_cyj_buff_label, escort_cyj). %% buff标签

%% 镖车品质
-define(escort_quality_white,  0).
-define(escort_quality_green,  1).
-define(escort_quality_blue,   2).
-define(escort_quality_purple, 3).
-define(escort_quality_orange, 4).
-define(escort_quality_fail,   9).  %% 操作失败点位值

%% 镖车类型
-define(escort_type_coin,      1).  %% 金币
-define(escort_type_bind_coin, 2).  %% 绑定金币

%% 运镖任务Id
-define(escort_task_ids,    [95002]). %% 运镖任务Id

%% 双倍运镖时间
-define(escort_double_award,  55620).           %% 15:27 开始广播时间
-define(escort_timeout_notice, 180 * 1000).     %% 通知时间
-define(escort_timeout_escorting, 1800 * 1000). %% 运镖时间

%% 护送小屁孩次数
-define(escort_child_total_times, 2).           %% 护送小屁孩总次数

-define(escort_max_time, 429496 * 1000).

%% 特别节日护送活动类型
-define(escort_act_type_child, 1).    %% 小屁孩
-define(escort_act_type_cyj, 2).    %% 重阳节
-define(escort_act_type_chrismas, 3).   %% 圣诞节
-define(escort_act_type_gen, 4).   %% 通用版


%% 运镖系统主记录
-record(escort, {
        refresh_time = 0        %% 刷新时间
        ,quality = 0            %% 品质
        ,accept_time = 0        %% 接镖时间 要在双倍时间内才可以获取双倍奖励
        ,escort_times = {0, 0}  %% 运镖次数{日期(20111019), 数量} 在任务那边控制了
        ,type = 1               %% 镖车类型 1:金币 2:绑定金币
        ,rob = {0, 0}       %% 当前打动次数{日期, 数量}
        ,lose = {0, 0}          %% 被动次数{日期, 数量} 
    }
).

%% 护送小屁孩
-record(escort_child, {
        refresh_time = 0        %% 刷新时间
        ,quality = 0            %% 品质
        ,accept_time = 0        %% 接镖时间 要在双倍时间内才可以获取双倍奖励
        ,type = 1               %% 镖车类型 1:金币 2:绑定金币
        ,rob = {0, 0}           %% 当前打动次数{日期, 数量}
        ,lose = {0, 0}          %% 被动次数{日期, 数量} 
    }
).
