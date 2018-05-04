%%----------------------------------------------------
%% 至尊王者场数据结构
%% @author shawn 
%%----------------------------------------------------

%% 竞技场玩家状态
-define(cross_king_role_status_idel,  0). %% 阵亡
-define(cross_king_role_status_prepare,  1). %% 准备区
-define(cross_king_role_status_match,    2). %% 战区
-define(cross_king_role_status_leave,    3). %% 离开竞技场
-define(cross_king_role_status_logout,   4). %% 下线

-define(cross_king_exit, [{10003, 5940, 1050}, {10003, 5880, 1290}, {10003, 6060, 1170}]). %% 退出点

%% 分区信息
-record(cross_king_pre, {
        map_id = 0          %% 地图Id
        ,map_pid             %% 地图进程Id
        ,role_size = 0       %% 角色数量
    }
).

%% 分区信息
-record(cross_king_zone, {
        id = 0               %% 战区编号
        ,pid                 %% 战区进程Id
    }
).

-record(cross_king_role, {
        id = {0, <<>>}     %% 角色id {RoleId, SrvId}
        ,pid               %% 角色进程id
        ,name = <<>>            %% 角色名称
        ,lev = 0                %% 角色级别
        ,sex = 0                %% 性别
        ,vip = 0                %% VIP类型
        ,career = 6             %% 角色职业
        ,pre_map_id = 0         %% 准备区地图id
        ,pre_map_pid            %% 准备区地图Pid
        ,group = 0              %% 0:屌丝 1:高富帅
        ,fight_capacity = 0     %% 战斗力
        ,pet_fight = 0          %% 仙宠战斗力
        ,death = 0              %% 死记次数
        ,zone_id = 0            %% 战区id
        ,zone_pid               %% 战区进程id
        ,combat = 0             %% 是否在战斗中
        ,kill = 0               %% 高富帅连杀数
        ,dmg = 0                %% 屌丝造成伤害值
        ,try_time = 0           %% 尝试发起战斗次数
        ,pet_status = []        %% 宠物状态 [{PetId, {Hp, Mp}} | ..]
        ,status = 1             %% 玩家状态 0:挂掉了 1:准备区 2:正式区 3:离开了 4:下线了
    }
).

-record(cross_king_rank, {
        id = {0, <<>>}
        ,rid = 0
        ,srv_id = <<>>
        ,group = 0     
        ,rank = 0
        ,name = <<>>
        ,sex = 0 
        ,lev = 0
        ,vip = 0
        ,fight_capacity = 0
        ,pet_fight = 0
        ,career = 6
        ,death = 0
        ,score = 0
        ,looks = []
    }
).
