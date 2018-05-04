%% *****************************
%% 组队系统数据结构
%% @author wpf(wprehard@qq.com)
%% *****************************

-define(APPLY_TIMEOUT,      180).   %% 申请/邀请的超时时间(单位：s)
-define(MEMBER_COUNT_MIN,   0).     %% 队员人数下限
-define(MEMBER_COUNT_MAX,   2).     %% 队员人数上限

%% 队员状态
-define(MODE_NORMAL,        0).     %% 正常
-define(MODE_TEMPOUT,       1).     %% 暂离
-define(MODE_OFFLINE,       2).     %% 离线

%% 入队距离
-define(BACK_GRID,          50).     %% 入队或归队距离（单位：pixel）
-define(CHECK_GRID,         2).     %% 队伍检测队员间距（单位：grid）
%% 队伍内的操作
-define(DO_NOTHING,         1).     %% 无动作, 仅更新信息
-define(DO_TRANSFER,        2).     %% 队伍传送场景
-define(DO_CHANGE_LEADER,   10).    %% 移交队长
-define(DO_TEMPOUT,         11).    %% 暂离
-define(DO_TEMPOUT_COMBAT,  12).    %% 战斗退出暂离
-define(DO_BACK,            13).    %% 归队

%% 队伍结构
-record(team, {
        team_id = 0         %% 队伍ID
        ,team_pid = 0       %% 队伍PID
        ,dung_id = 0        %% 报名招募的副本ID：0表示未报名
        ,applied = 0        %% 设置是否默认同意申请 0:否 1:是
        ,leader             %% 队长信息
        ,ride = 0           %% 飞行状态
        ,member = []        %% 成员#team_member{}，不包括队长
    }).

%% 队员结构
-record(team_member, {
        id = {0, 0}         %% 成员角色ID标识
        ,name = <<>>        %% 队员名称
        ,pid = 0            %% 队员角色进程PID
        ,conn_pid = 0       %% 队员连接进程
        ,lev = 0            %% 等级
        ,career = 0         %% 职业
        ,sex = 0            %% 性别
        ,hp = 0             %% 血量
        ,mp = 0             %% 法力
        ,hp_max = 0         %% 血量上限
        ,mp_max = 0         %% 法力上限
        ,fight = 0          %% 战斗力
        ,pet_fight = 0      %% 宠物战斗力
        ,vip_type = 0       %% vip类型
        ,face_id = 0        %% 头像ID
        ,mode = 0           %% 0-正常 1-暂离 2-离线
        %% -----------------以下3项仅作缓存，需要即时更新
        ,lineup = 0         %% 阵法ID
        ,speed = 0          %% 移动速度(队员实际的速度，需要实时更新)
        ,dung_cnt = 0       %% 副本剩余次数
        %% ----------------
    }).

%% 角色数据中队伍的缓存数据
-record(role_team, {
        team_id = 0         %% 队伍ID
        ,is_leader = 0      %% 是否队长0:不是 1:是
        ,follow = 0         %% 是否在队伍中跟随 0:不是 1-~:是
        ,event = 0          %% 队伍的事件状态
        ,speed = 0          %% 队伍移动速度
        ,lineup = 0         %% 队伍选择的阵法
    }).

%% 全局的成员信息保存: 用于上下线时记录信息
-record(member_global, {
        member_id = 0       %% 队员ID
        ,team_pid = 0       %% 队伍进程PID
    }).

%% ************************************ 2012/06/14弃用
%% 申请与邀请信息
-record(team_apply_msg, {
        id = {0, 0}         %% 角色ID 此时可能没队伍
        ,pid = 0            %% 角色进程PID
        ,conn_pid = 0       %% 角色连接进程
        ,name = <<>>        %% 名称
%%        ,lev = 0            %% 等级
%%        ,career = 0         %% 职业
        ,s_time = 0         %% 邀请/申请时间: 被邀请人返回应答时判断是否超时，超时清除
    }).

%% 被邀请列表数据 作为ETS数据---被邀请的角色进入队伍后清除此数据
-record(team_invited, {
        invited_id = 0      %% 被邀请人的ID
        ,list = []          %% [#apply_msg{}, ...]
    }).
%% 被申请列表数据 作为ETS数据---被申请的队伍人数满员后清除此数据
-record(team_apply, {
        applied_id = 0      %% 队伍ID
        ,list = []          %% [#apply_msg{}, ...]
    }).

%% *********************************** 2012/06/14弃用
%% 副本组队招募相关
-define(DUNGEON_HALL_ID, [10001, 10002, 10003, 10004, 20000, 20100]).

%% 一个副本门口一个大厅
-record(team_hall, {
        dung_id = 0         %% 副本组的ID(如洛水殿副本组)
        ,team_list = []     %% 已报名队伍
        ,role_list = []     %% 已报名玩家
    }).
%% 队伍小房间
-record(team_room, {
        team_id = 0         %% 队伍ID
        ,team_pid = 0       %% 队伍PID
        ,leader = 0         %% 报名队长#role_regist{}
        ,num = 0            %% 成员个数(包括队长)
    }).
%% 报名玩家信息
-record(role_regist, {
        id = 0              %% ID
        ,name = <<>>        %% 名称
        ,fight = 0          %% 战斗力
        ,lev = 0            %% 等级
        ,sex = 0            %% 性别
        ,career = 0         %% 职业
        ,count = 0          %% 副本进度
        ,pid = 0            %% 玩家角色进程PID
        ,conn_pid = 0       %% 连接进程PID
    }).
