%%----------------------------------------------------
%% 竞技场相关数据结构定义
%% 
%% @author mobin
%%----------------------------------------------------

-define(compete_limit_count, 15).

-define(compete_prepare_map_id, 1036).
-define(compete_prepare_x, 420).
-define(compete_prepare_y, 420).

-define(compete_status_normal, 0).      %%没匹配
-define(compete_status_teammate, 1).      %%匹配队友
-define(compete_status_team, 2).      %%匹配对手
-define(compete_status_matched, 3).      %%已匹配
-define(compete_status_map, 4).      %%已进入地图

-define(compete_rank_down, 0). %% 排名下降
-define(compete_rank_normal, 1). %% 排名不变
-define(compete_rank_up, 2). %% 排名上升

%% 报名队伍
-record(sign_up_team, {
        id = [],                %% [Rid, ...]
        total_power = 0,
        match_count = 0,        %% 匹配次数
        match_latitude = 0     %% 匹配波动值
    }
).

%% 报名队伍中的一个人
-record(sign_up_role, {
        id = {0, 0},        %% 角色id
        name = <<>>,        %% 名称
        pid = 0,            %% 玩家pid
        conn_pid = 0,       
        total_power = 0, %% 战力
        career = 0,         %% 职业
        
        hall_id = 0,        %% 大厅
        room_no = 0,        %% 房间号
        is_leader = 0,      %% 是否房主
        match_count = 0,    %% 匹配次数

        status = 0         %% 状态
    }
).

%% 荣誉排名
-record(compete_rank, {
        id = {0, 0},        %% 角色id
        name = <<>>,        %% 名称
        total_power = 0, %% 战力
        honor = 0,          %% 今日荣誉
        last_rank = 10000,       %% 上次排名
        rank = 0,          %% 排名
        trend = 0          %% 趋势
    }
).
