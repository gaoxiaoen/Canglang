%%----------------------------------------------------
%% 武神坛数据结构
%% @author shawn 
%%----------------------------------------------------


%% 队伍资格
-define(cross_warlord_quality_0, 0). %% 无资格
-define(cross_warlord_quality_trial_0, 1). %% 1024强资格 
-define(cross_warlord_quality_trial_1, 2). %% 256强资格 
-define(cross_warlord_quality_trial_2, 3). %% 128强资格
-define(cross_warlord_quality_trial_3, 4). %% 64强资格
-define(cross_warlord_quality_top_32, 5). %% 32强资格
-define(cross_warlord_quality_top_16, 6). %% 16强资格
-define(cross_warlord_quality_top_8, 7). %% 8强资格
-define(cross_warlord_quality_top_4_1, 8). %% 4强第一组资格
-define(cross_warlord_quality_top_4_2, 9). %% 4强第二组资格 
-define(cross_warlord_quality_semi_final, 10). %% 季军决赛资格  
-define(cross_warlord_quality_final, 11). %% 决赛资格
-define(cross_warlord_quality_winer, 12). %% 冠军 
-define(cross_warlord_quality_second_place, 13). %% 亚军 
-define(cross_warlord_quality_third_place, 14). %% 季军 
-define(cross_warlord_quality_4th_place, 15). %% 第4名 

-define(cross_warlord_label_sky, 0).  %% 天榜
-define(cross_warlord_label_land, 1). %% 地榜

-define(cross_warlord_exit, [{10003, 4800, 930}, {10003, 4980, 1170}, {10003, 5160, 1440}]). %% 退出点

%% 准备区信息
-record(cross_warlord_pre, {
        id = 0
        ,map_id = 0          %% 地图Id
        ,map_pid             %% 地图进程Id
        ,role_size = 0       %% 角色数量
        ,role_list = []      %% 当前地图角色列表
    }
).

%% 分区信息
-record(cross_warlord_zone, {
        seq = 0             %% 战区组号
        ,pid                 %% 战区进程Id
    }
).

%% 队伍数据
-record(cross_warlord_team, {
        team_code = 0             %% 队伍编号 
        ,team_srv_id              %% 队长服务器标识
        ,team_name                %% 队伍名
        ,team_fight = 0           %% 队伍战斗力 
        ,team_label = 0           %% 0:天龙 1:玄虎 
        ,team_quality = 0         %% 队伍当前资格 
        ,team_zone_seq            %% 战区序号, 每次比赛前需更新
        ,team_zone_pid            %% 战区进程PID, 每次比赛前需更新
        ,team_32code = 0          %% 32强队伍编号
        %% --预选赛组别
        ,team_group_512 = 0       %% 512强组别
        ,team_group_256 = 0       %% 256强组别
        ,team_group_128 = 0       %% 128强组别
        ,team_group_64 = 0        %% 64强组别
        %% -- 32强赛组别
        ,team_group_32 = 0        %% 32强组别
        ,team_group_16 = 0        %% 16强组别
        ,team_group_8 = 0         %% 8强组别
        ,team_group_4 = 0         %% 4强组别
        ,team_trial_seq = 0       %% 预选赛赛区 
        ,team_trial_code = 0      %% 预选赛编号 
        ,team_member = []         %% 队伍角色 
        ,lineup_id = 0            %% 当前阵法
        ,lineup_list = []         %% 阵法列表
    }
).

%% 角色数据
-record(cross_warlord_role, {
        id = {0, <<>>}          %% 角色id {RoleId, SrvId}
        ,rid = 0                %% 角色ID
        ,srv_id = <<>>          %% 角色服务器标识
        ,team_code = 0          %% 所属队伍编号
        ,pid                    %% 角色进程id
        ,name = <<>>            %% 角色名称
        ,lev = 0                %% 角色级别
        ,sex = 0                %% 性别
        ,vip = 0                %% VIP类型
        ,career = 6             %% 角色职业
        ,fight_capacity = 0     %% 战斗力
        ,pet_fight = 0          %% 仙宠战斗力
        ,looks = []             %% 外观
        ,face_id = 0            %% 头像
        ,combat_cache = 0       %% 战斗用的缓存信息{Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks}
        ,zone_seq = 0           %% 战区序号, 同队伍数据一致
        ,zone_pid               %% 战区进程PID
    }
).

%% 排行榜数据
-record(cross_warlord_rank, {
        team_code = 0             %% 队伍编号 
        ,team_name                %% 队伍名
        ,team_rank                %% 队伍排行
        ,team_fight = 0           %% 队伍战斗力 
        ,team_member = []         %% [{Rid, Srvid, Name} | ..]
    }
).


%% 准备区角色数据
-record(cross_warlord_pre_role, {
        id = {0, <<>>}          %% 角色id {RoleId, SrvId}
        ,rid = 0                %% 角色ID
        ,srv_id = <<>>          %% 角色服务器标识
        ,pid              
    }
).


%% 战斗日志
-record(cross_warlord_log, {
        id = {0, <<>>}           %% 角色ID
        ,war_quality = 0         %% 对战阶段 
        ,ctime = 0               %% 对战时间
        ,rival = []              %% 对手列表 {Rid, Srvid, Name} |...]
        ,point = 0               %% 战胜次数 
        ,rival_point = 0         %% 对手胜次数 
    }
).

%% 角色投注信息
-record(cross_warlord_bet, {
        id = {0, <<>>}
        ,top_3 = []            %% [{Teamlabel, Teamcode1, Teamname1, Teamcode2, Teamname2, Teamcode3, Teamname3, Coin, WinCoin}]
        ,bet_log = []          %% [{Quality, Label, Seq, {_Name1, _Name2}, _TeamCode, _TeamName, _Coin, _Rate, _WinCoin} | ]
        ,bet_16 = []           %% [{TeamLabel, [{GroupId, TeamCode1, TeamName1} |..], Coin, WinCoin} | ..]
    }
).

%% 直播
-record(cross_warlord_live, {
        id = {0, 0}
        ,combat_pid
    }
).
