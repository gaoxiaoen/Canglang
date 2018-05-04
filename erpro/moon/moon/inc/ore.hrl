%% ******************************
%% 跨服抢矿玩法相关结构
%% @author wpf(wprehard@qq.com)
%% ******************************

%% 仙府状态
-define(ORE_STATUS_NORMAL, 0).  %% 正常
-define(ORE_STATUS_FIGHT,  1).  %% 战斗中（被打劫或争夺）
%% 仙府标识
-define(ORE_FLAG_NO, 0).    %% 普通
-define(ORE_FLAG_ROLE, 1).  %% 玩家占领
%% 分区数
-define(ORE_AREA_MAX, 8).
-define(ORE_AREA_ROLE_MAX, 450).
%% 战力限制
-define(FIGHT_MIN, 18000).
-define(ROB_CD, 600).

%% 分区内仙府ID初始值
-define(ORE_ROOM_MIN_ID, 1).

%% 仙府（矿）的ID由管理器指定活动时间内唯一

%% 仙府分区
-record(ore_area, {
        id = 0             %% 编号
        ,pid = 0            %% 分区进程PID
        ,map_id = 0         %% 对应地图ID
        ,map_pid = 0        %% 对应地图PID
        ,list = []          %% 仙府ID列表
        ,cnt = 0            %% 分区人数
    }).

%% 仙府信息
-record(ore_room, {
        id = 0              %% 仙府ID(地图元素ID)
        ,name = <<>>        %% 仙府名称
        ,lev = 0            %% 仙府等级
        ,elem_id = 0        %% 地图元素的基础ID
        ,area_pid = 0       %% 分区PID
        ,map_id = 0         %% 地图ID
        ,flag = 0           %% 标识：0-普通 1-玩家占领
        ,combat_pid = 0     %% 仙府参战PID，0表示正常
        ,roles = []         %% 仙府角色列表[{Rid, SrvId, Name} | ...]
        ,robed_cnt = 0      %% 已被打劫次数：1、每天清0；2、占领后清0
        ,log1 = []          %% 日志-成为主人[{RoomName, RoomLev, Time} | ...]
        ,log2 = []          %% 日志-产出资源[{[{BaseId, Bind, Num}], Time} | ...]
        ,log3 = []          %% 日志-收获资源[{[{ItemId, Bind, Num}], Time} | ...]
        ,log4 = []          %% 日志-抢夺[{Result, Roles, Items, Time} | ...]
    }).

%% 玩家仙府的记录信息
-record(ore_role_info, {
        role_id = {0, <<>>} %% 角色ID信息
        ,name = <<>>        %% 角色名称
        ,pid = 0            %% 角色PID信息，0表示没有进入仙府分区参加活动
        ,room_id = 0        %% 仙府ID（0-无）
        ,award = []         %% 可收获资源列表[{BaseId, IsBind, Num} | ...]
        ,award_time = 0     %% 资源收获下次时间戳
        ,npc_1 = 0         %% 镇府神兽金乌{Id, Name, Lev}
        ,npc_2 = 0         %% 镇府神兽离珠{Id, Name, Lev}
    }).

%% 玩家附加记录信息
-record(ore_role_misc, {
        role_id = {0, <<>>} %% 角色ID信息
        ,name = <<>>        %% 角色名
        ,last_rob = 0       %% 上一场打劫的仙府ID
        ,last_time = 0      %% 上一场打劫的仙府时间
        ,rob_cnt = 0        %% 打劫次数
        ,combat_cache = 0   %% 战斗用的缓存信息{Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks}
    }).

%% 跨服仙府抢矿系统数据
-record(cross_ore_state, {
        areas = []          %% 分区表[#ore_area{} | ...]
        ,next_room_id = 1   %% 仙府ID的分配
        ,next_area_id = 1   %% 分区ID分配
        ,ts = 0             %% 状态机切换时间戳
        ,t_cd = 0           %% 当前状态持续时间(秒)
    }).

%% 分区进程系统数据
-record(cross_ore_area, {
        id = 0              %% 分区ID
        ,map_id = 0         %% 分区地图
        ,rooms = []         %% 分区仙府ID列表
        ,timers = []        %% 当前分区定时器列表[{OreRoomId, Timer} | ...]
    }).
