%% --------------------------------------------------------------------
%% @doc 飞仙历练
%% @author weihua@jieyou.cn
%% --------------------------------------------------------------------
%% 飞仙历练数据版本
-define(train_ver, 1).
%% 玩家每日免费历练次数
-define(train_role_times, 3).
%% 玩家劫持次数
-define(train_role_rob, 5).
%% 玩家缉拿次数
-define(train_role_arrest, 5).
%% 结算检测
-define(check_train_gain, 8).
%% 魂气允许最大打劫
-define(rob_soul_max(Soul), trunc(Soul * 40 / 100)).
%% 魂气收益
-define(train_soul_gain(Time, Soul), trunc(Soul / 120 * Time / 60)).
%% 魂气打劫奖励
-define(rob_soul_gain(Lid, Time, Soul, Frole, Frob), 
    case Lid >= 5 of
        true ->
            case trunc(Soul / 120 * Time / 60 * 10 / 100 * (1-(Frob-Frole)/Frole)) of
                Val when Val >0 -> Val;
                _ -> 0
            end;
        false ->
            case trunc(Soul / 120 * Time / 60 * 10 / 100 * (1-(Frob-Frole)/10000)) of
                Val when Val >0 -> Val;
                _ -> 0
            end
    end).

%% 清理时间
-define(clear_time, 86390).
%% 劫匪速度
-define(rob_speed, 5).
%% 战斗异常自动解锁时间差值 1 个小时
-define(dead_status_gap, 3600).
%% 早上4点清理观众数据
-define(clear_visitor_time, 14400).

%% 每个场区最大人数
-ifdef(debug).
-define(train_field_max_num, 3).
-define(train_time_cost, 600).
-else.
-define(train_field_max_num, 60).
-define(train_time_cost, 7200).
-endif.

-define(train_lev_limit, 47).

%% 历练段
-record(train_field, {
        id = {0, 0}     %% {战斗力段，分区}
        ,lid = 0        %% 战力段
        ,pid = 0        %% 进程PID
        ,ver = 0        %% 数据版本
        ,num = 0        %% 当前历练人数
        ,roles = []     %% 修炼角色
        ,robs = []      %% 打劫者数据
        ,visitors = []  %% 游览者数据
        ,xys = []       %% 位置
    }
).

%% role 保存 数据
-record(role_train, {
        id = {0, 0}                     %% {战斗力段，分区}
        ,train = ?train_role_times      %% 剩余历练次数
        ,rob = ?train_role_rob          %% 剩余打劫次数
        ,arrest = ?train_role_arrest    %% 剩余缉拿次数
        ,fight = 0                      %% 替身战斗力
        ,stamp = 0                      %% 戳，标记当前数据日期版本
        ,center = 0                     %% 标记是否在中央服历练
    }
).

%% 历练role
-record(train_role, {
        id = {0, <<>>}
        ,pid = 0                                %% 角色PID
        ,name = <<>>                            %% 角色名字
        ,grade = 0                              %% 战力段
        ,area = 0                               %% 历练区
        ,type = 0                               %% 修炼类型
        ,train_time = 0                         %% 历练开始时间
        ,rob_time = 0                           %% 被劫持成功时间
        ,pause_time = 0                         %% 累积中断时间
        ,robbing = 0                            %% 是否在打劫别人
        ,loss = 0                               %% 损失魂气值
        ,x = 0                                  %% 坐标
        ,y = 0                                  %% 坐标
        ,sex = 0                                %% 性别
        ,lev = 0                                %% 等级
        ,career = 0                             %% 职业
        ,hp_max = 0                             %% 血上限
        ,mp_max = 0                             %% 魔上限
        ,eqm = 0                                %% 装备
        ,skill = 0                              %% 技能
        ,attr = 0                               %% 属性
        ,pet_bag = 0                            %% 宠物
        ,demon = 0                              %% 守护
        ,looks = 0                              %% 外观
        ,ascend = 0                             %% 副职
        ,fight = 0                              %% 战斗力
    }
).

%% 劫匪信息
-record(train_rob, {
        id = {0, <<>>}                          %% 劫匪ID
        ,fid = {0, 0}                           %% 劫匪入住的场区
        ,oid = {0, <<>>}                        %% 劫持对象ID
        ,pid = 0                                %% 角色PID
        ,name = <<>>                            %% 角色名字
        ,grade = 0                              %% 战力段
        ,area = 0                               %% 历练区
        ,x = 0                                  %% 坐标
        ,y = 0                                  %% 坐标
        ,des = 0                                %% 目标人贩子
        ,desxy = {0, 0}                         %% 终点XY
        ,viaxy = {0, 0}                         %% 途径XY
        ,speed = 0                              %% 速度
        ,sex = 0                                %% 性别
        ,lev = 0                                %% 等级
        ,career = 0                             %% 职业
        ,hp_max = 0                             %% 血上限
        ,mp_max = 0                             %% 魔上限
        ,eqm = 0                                %% 装备
        ,skill = 0                              %% 技能
        ,attr = 0                               %% 属性
        ,pet_bag = 0                            %% 宠物
        ,demon = 0                              %% 守护
        ,looks = 0                              %% 外观
        ,ascend = 0                             %% 副职
        ,fight = 0                              %% 战斗力
        ,soul = 0                               %% 当前打劫收益
        ,busy = 0                               %% 是否正在战斗
        ,time = 0                               %% 劫匪劫持成功时间
        ,run = 0                                %% 开始逃跑时间，用于校正贩卖是否可以提交
        ,arrest = 0                             %% 开始被缉拿时间
        ,pause = 0                              %% 中途中断时间（被缉拿）
        ,cost = 0                               %% 完成交付需要消耗时间
    }
).

%% 历练场游客
-record(train_visitor, {
        id = {0, <<>>}
        ,pid = 0
        ,fid = 0
        ,ctime = 0
    }
).
