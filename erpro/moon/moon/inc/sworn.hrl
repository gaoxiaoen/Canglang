%% ****************************
%% 结拜相关数据定义
%% @author lishen@jieyou.cn
%% ****************************
%% 结拜活动地图ID
-define(SWORN_MAP, 10003).
%% 结拜标准
-define(SWORN_COMMON, 1). %% 普通结拜
-define(SWORN_LOD, 2).    %% 生死结拜
%% 结拜亲密度要求
-define(SWORN_INTIMACY, 1000).
%% 结拜花费
-define(SWORN_COMMON_COIN, 500000).
-define(SWORN_LOD_GOLD, pay:price(sworn, sworn_log_gold, null)).
-define(CAMP_SWORN_LOD_GOLD, pay:price(sworn, camp_sworn_lod_gold, null)).
%% 结拜各阶段时间(ms)
-define(SWORN_IDEL_TIMEOUT,     1000000).   %% 进程空闲循环时间
-define(SWORN_PRE_TIMEOUT,      60000).     %% 结拜准备时间
-define(SWORN_CEREMONY_TIMEOUT, 30000).     %% 结拜仪式时间
-define(SWORN_READY_FIGHT,      3000).      %% 准备战斗时间
-define(SWORN_FIGHTING,         60000).     %% 战斗循环时间

%% 3人结拜位置配置
-define(MEMBER_3_POS1,   {4602, 894}).
-define(MEMBER_3_POS2,   {4667, 854}).
-define(MEMBER_3_POS3,   {4726, 824}).
%% 2人结拜位置配置
-define(MEMBER_2_POS1,   {4615, 880}).
-define(MEMBER_2_POS2,   {4687, 839}).
%% 场景相关elem
-define(ELEM_DESK, [{60299, 60299, 4515,857}]).
%% 结拜动作
-define(special_val_ceremony, 0).       %% 无动作
-define(special_val_ceremony_1, 1).     %% 拜石像
-define(special_val_ceremony_2, 2).     %% 喝酒
-define(special_val_ceremony_3, 3).     %% 再拜石像
%% 结拜称号ID
-define(SWORN_CUSTOM_TITLE_ID, 40003).  %% 自定义称号
-define(SWORN_COMMON_TITLE_ID, 40004).  %% 普通结拜称号


%% 结拜State
-record(sworn, {
        leader_id = {0, 0}      %% 队长ID
        ,member1_id = {0, 0}    %% 成员1ID
        ,member2_id = {0, 0}    %% 成员2ID
        ,leader_pid = 0         %% 队长角色进程PID
        ,member1_pid = 0        %% 成员1角色进程PID
        ,member2_pid = 0        %% 成员2角色进程PID
        ,leader_conn_pid = 0    %% 队长连接进程PID
        ,member1_conn_pid = 0   %% 成员1连接进程PID
        ,member2_conn_pid = 0   %% 成员2连接进程PID
        ,leader_rank = 0        %% 队长结拜排名
        ,member1_rank = 0       %% 成员1结拜排名
        ,member2_rank = 0       %% 成员2结拜排名
        ,team_pid = 0           %% 队伍进程PID
        ,num = 0                %% 成员人数
        ,map_pid = 0            %% 地图进程PID
        ,leader_name = <<>>     %% 队长名称
        ,member1_name = <<>>    %% 成员1名称
        ,member2_name = <<>>    %% 成员2名称
        ,type = 0               %% 结拜类型 1:普通 2:生死
        ,time = 0               %% 结拜时间
        ,ceremony = 0           %% 仪式白帝说话步骤
        ,elem_id = []           %% 其他元素ID，用于活动结束清除
        ,is_swearing = 0        %% 是否正在进行结拜，限制同一时间只能有一对人结拜，1表示结拜进行中
        ,title = <<>>           %% 结拜称号
        ,ts = 0                 %% 状态时间戳
        ,t_cd = 0               %% 状态剩余时间（毫秒）
    }).

%% 结拜后保存数据
-record(sworn_info, {
        id = {0, 0}             %% ID
        ,name = <<>>            %% 名字
        ,rank = 0               %% 排名
        ,member = []            %% 成员[#sworn_member{},...]
        ,out_member_id = {0, 0} %% 退出成员ID
        ,num = 0                %% 结拜人数
        ,type = 0               %% 结拜类型
        ,is_award = 0           %% 是否领取奖励 0-未领 1-已领
        ,title_id = 0           %% 称号ID
        ,title_h = <<>>         %% 结拜称号头(如：无敌)
        ,title_t = <<>>         %% 结拜称号尾(如：雄)
        ,title = <<>>           %% 结拜称号(如：无敌双雄)
        ,time = 0               %% 结拜时间
    }).

-record(sworn_member, {
        id = {0, 0}             %% 角色ID
        ,name = <<>>            %% 名字
        ,rank = 0               %% 排名
    }).
