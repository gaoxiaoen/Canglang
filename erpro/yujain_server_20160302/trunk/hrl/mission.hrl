
%% 任务类型
-define(MISSION_TYPE_MAIN,1).          %% 主线
-define(MISSION_TYPE_BRANCH,2).        %% 支线
-define(MISSION_TYPE_LOOP,3).          %% 循环

%% 任务状态
-define(MISSION_STATUS_NOT_ACCEPT,1).  %% 1未接
-define(MISSION_STATUS_DOING,2).       %% 2已接
-define(MISSION_STATUS_FINISH,3).      %% 3可提交

%% 任务显示类型
-define(MISSION_SHOW_TYPE_NORMAL,0).   %% 0正常任务显示
-define(MISSION_SHOW_TYPE_NO,1).       %% 1不在可接任务显示

%% 委托状态
-define(MISSION_AUTO_STATUS_NO,0).     %% 0未委托
-define(MISSION_AUTO_STATUS_START,1).  %% 1开始委托

%% 任务DO OP TYPE 类型定义
-define(MISSION_DO_OP_TYPE_ACCEPT,10).  %% 接受任务
-define(MISSION_DO_OP_TYPE_FINISH,30).  %% 提交任务

%% 任务模型
-define(MISSION_MODEL_1,1). %% 对话模型,选择题
-define(MISSION_MODEL_2,2). %% 打怪
-define(MISSION_MODEL_3,3). %% 打怪收集
-define(MISSION_MODEL_4,4). %% 特殊事件的侦听器 - 3次对话 - 中间状态去完成事件
-define(MISSION_MODEL_5,5). %% 指定接下来连接的任务id

%% 任务奖励基本类型
-define(MISSION_REWARD_FORMULA_BASE_NO,0).                  %% 0没有奖励
-define(MISSION_REWARD_FORMULA_BASE_NORMAL,1).              %% 1按配置的奖励
-define(MISSION_REWARD_FORMULA_BASE_CALC_ALL_TIMES,2).      %% 2所有基本基础奖励按照次数累计计算
-define(MISSION_REWARD_FORMULA_BASE_CALC_EXP_TIMES,3).      %% 3经验按照次数累计计算
-define(MISSION_REWARD_FORMULA_BASE_CALC_PRESTIGE_TIMES,4). %% 4军功按照次数累计计算

%% 任务奖励道具类型
-define(MISSION_REWARD_FORMULA_ITEM_NO,0).                  %% 0没有奖励
-define(MISSION_REWARD_FORMULA_ITEM_CHOOSE_ONE,1).          %% 1多个先一个
-define(MISSION_REWARD_FORMULA_ITEM_RANDOM_ONE,2).          %% 2随机赠送一个
-define(MISSION_REWARD_FORMULA_ITEM_ALL,3).                 %% 3全部

%% 侦听器类型
-define(MISSION_LISTENER_TYPE_MONSTER,1).                   %% 1怪物
-define(MISSION_LISTENER_TYPE_PROP,2).                      %% 2道具
-define(MISSION_LISTENER_TYPE_SPECIAL_EVENT,3).             %% 3特殊事件侦听器
-define(MISSION_LISTENER_TYPE_GIVE_USE_PROP,4).             %% 4赠送使用道具
-define(MISSION_LISTENER_TYPE_COLLECT_PROP,5).              %% 5收集道具

%% 任务模型状态未接状态,任务模型状态从0开始计起
-define(MISSION_MODEL_STATUS_FIRST, 0).


-define(DO_TRANS_FUN(TransFun),
        case common_transaction:transaction(TransFun) of
            {atomic,TransResult}->
                TransResult;
            {aborted,TransError}->
                case TransError of
                    {bag_error,not_enough_pos} ->
                        {error,?_RC_MISSION_DO_013,""};
                    _ ->
                        TransError
                end
        end).

%% 特列任务事件的定义
-define(MISSION_EVENT_JOIN_FAMILY,1003). %% 创建加入帮派

-define(MISSION_EVENT_LOOP_MISSION_1,4001). %% 接取任意一种循环任务并提交
-define(MISSION_EVENT_LOOP_MISSION_2,4002). %% 委托一次循环任务