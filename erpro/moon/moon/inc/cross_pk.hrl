%%----------------------------------------------------
%% 跨服PK场数据结构
%% @author whjing2011@gmail.com
%%----------------------------------------------------

-define(CROSS_PK_MAP_MAX_NUM, 300).   %% 最大人数限制
-define(CROSS_PK_PAGE_SIZE, 7).      %% 每页显示角色数
%% -define(CROSS_PK_MAP, 10003).         %% 地图ID
-define(CROSS_PK_MAP, 30015).         %% 地图ID

-define(cross_pk_status_idle, 0).     %% 空闲状态
-define(cross_pk_status_active, 1).   %% 开启状态
-define(cross_pk_status_pre, 2).      %% 准备状态
%% 决斗书相关
-define(CROSS_DUEL_BOOK, 33107).    %% 决斗书
-define(CROSS_DUEL_IDEL_CD, 60).    %% 决斗倒计时(秒)
-define(CROSS_DUEL_DUEL_CD, 3600).  %% 决斗时间上限(秒)

%% 跨服场境角色信息
-record(cross_pk_role, {
        id = {0, <<>>}     %% 角色信息
        ,name = <<>>       %% 角色名称
        ,sex               %% 角色性别
        ,career            %% 角色职业
        ,lev               %% 角色等级
        ,vip               %% 角色VIP类型
        ,guild             %% 角色帮会名称
        ,fight_capacity    %% 角色战斗力
        ,pet_fight         %% 宠物战斗力
        ,team_pid          %% 角色组队状态[0:单人 1:组队]
        ,status = 0        %% 角色状态
        ,event = 0         %% 角色活动
    }
).

%% 跨服比武场的决斗玩家信息
-record(cross_duel_role, {
        id = {0, <<>>}     %% 角色ID
        ,pid = 0           %% 角色进程PID
        ,info = 0          %% 角色信息#cross_pk_role{}
        ,pk_id = {0, <<>>} %% 决战对手角色ID
        ,pk_pid = 0        %% 角色进程PID
        ,pk_info = 0       %% 角色信息#cross_pk_role{}
        ,room_id = 0       %% 分区Id
        ,duel_pid = 0      %% 决斗进程Pid，0表示未进入战斗
    }).

%% 分区信息
-record(cross_pk_map, {
        id = 0              %% 分区ID
        ,map_id = 0         %% 地图ID
        ,map_pid
        ,num = 0            %% 当前人数
        ,roles = []         %% 当前分区角色列表[#cross_pk_role{}]
    }
).


