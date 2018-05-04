%% --------------------------------------------------------------------
%% 大厅模式相关的数据结构
%% @author abu
%% @end
%% --------------------------------------------------------------------

%% 玩家在房间的状态
-define(hall_role_status_common, 0).        %% 普通，未准备
-define(hall_role_status_prepare, 1).       %% 已准备
-define(hall_role_status_offline, 2).       %% 下线

%% 房间状态
-define(hall_room_status_common, 0).        %% 未发起
-define(hall_room_status_fight, 1).        %% 已进入活动


%% 大厅类型
-define(hall_type_expedition, 1).                %% 远征王军大厅
-define(hall_type_compete, 2).                %% 竞技大厅

%%飞仙旧数据
-define(hall_type_practice, 29).             %% 试练大厅
-define(hall_type_cross_boss, 4).           %% 跨服boss大厅
-define(hall_type_dungeon_loong, 5).                %% 龙宫副本塔大厅
-define(hall_type_dungeon_loong_hard, 6).           %% 里龙宫副本塔大厅
-define(hall_type_dungeon_tower_cross, 7).                %% 跨服镇妖塔副本塔大厅
-define(hall_type_dungeon_tower_hard_cross, 8).           %% 跨服里镇妖塔副本塔大厅
-define(hall_type_dungeon_loong_cross, 9).                %% 跨服龙宫副本塔大厅
-define(hall_type_dungeon_loong_hard_cross, 10).           %% 跨服里龙宫副本塔大厅
-define(hall_type_dungeon_5xing, 11).                %% 五行结界塔大厅
-define(hall_type_dungeon_5xing_cross, 12).                %% 五行结界跨服塔大厅
-define(hall_type_practice_cross, 13).                %% 无尽试炼跨服塔大厅
-define(hall_type_dungeon_poetry4, 14).                %% 古诗大乱斗本服大厅40级
-define(hall_type_dungeon_poetry5, 15).                %% 古诗大乱斗本服大厅50级
-define(hall_type_dungeon_poetry6, 16).                %% 古诗大乱斗本服大厅60
-define(hall_type_dungeon_poetry7, 17).                %% 古诗大乱斗本服大厅70
-define(hall_type_dungeon_poetry8, 18).                %% 古诗大乱斗本服大厅80
-define(hall_type_dungeon_poetry9, 19).                %% 古诗大乱斗本服大厅90
-define(hall_type_dungeon_poetry_cross4, 20).                %% 古诗大乱斗跨服大厅40级
-define(hall_type_dungeon_poetry_cross5, 21).                %% 古诗大乱斗跨服大厅50级
-define(hall_type_dungeon_poetry_cross6, 22).                %% 古诗大乱斗跨服大厅60级
-define(hall_type_dungeon_poetry_cross7, 23).                %% 古诗大乱斗跨服大厅70级
-define(hall_type_dungeon_poetry_cross8, 24).                %% 古诗大乱斗跨服大厅80级
-define(hall_type_dungeon_poetry_cross9, 25).                %% 古诗大乱斗跨服大厅90级
-define(hall_type_dungeon_liang_corss, 26).                  %% 阆风苑副本

-define(hall_type_test, 255).               %% 试练大厅

%% 房间类型标识
-define(hall_room_type_practice, 1).        %% 试练房间

%% 跨服大厅
-define(cross_hall_types, [
                        ?hall_type_dungeon_tower_cross,
                        ?hall_type_dungeon_tower_hard_cross,
                        ?hall_type_dungeon_loong_cross,
                        ?hall_type_dungeon_loong_hard_cross,
                        ?hall_type_dungeon_5xing_cross,
                        ?hall_type_dungeon_poetry_cross4,
                        ?hall_type_dungeon_poetry_cross5,
                        ?hall_type_dungeon_poetry_cross6,
                        ?hall_type_dungeon_poetry_cross7,
                        ?hall_type_dungeon_poetry_cross8,
                        ?hall_type_dungeon_poetry_cross9,
                        ?hall_type_dungeon_liang_corss
    ]).

%% 大厅数据
-record(hall, {
        id
        ,pid            %%  
        ,type           %% 类型
        ,base_room_no = 0   %% 房间的起始记号
        ,map_base_id    %% TODO 目前已不用。房间的地图基础id
    }).

%% 房间数据
-record(hall_room, {
        room_no                    %% 房间号
        ,room_type = 0              %% 房间的类型
        ,map                        %% 房间地图{MapId, MapPid}
        ,limit_count = 3            %% 房间的人数限制
        ,leader                     %% 房主
        ,members = []               %% 房间内的人
        ,password = <<>>            %% 房间的密码
        ,fight_capacity_limit = 0   %% 战斗力要求
        ,status = 0                 %% 房间状态
        ,optional_room_types = []   %% 房间支持的类型
        ,mates = []                 %% 开战的队友，目前用于远征王军推送好友
    }).

%% 玩家
-record(hall_role, {
        id              %% 玩家id
        ,pid = 0            %% 玩家pid
        ,conn_pid = 0       
        ,name = <<>>           %% 玩家名称
        ,room_no = 0    %% 玩家当前所在的房间号, 为0时表示没有房间
        ,status = 0     %% 玩家状态
        ,lev = 0            %% 等级
        ,fight_capacity %% 战斗力
        ,pet_fight_capacity %% 宠物战斗力
        ,career = 0         %% 职业
        ,sex = 0            %% 性别
        ,is_owner = 0   %% 是否房主， 0：不是， 1：是
        ,vip_type       %% vip类型
        ,guild_name     %% 帮会名称
        ,looks = []     %% 玩家外观
    }).

%% 角色里的大厅信息
-record(role_hall, {
        id = 0,         %% 大厅id
        pid = 0         %% 大厅pid
    }).
