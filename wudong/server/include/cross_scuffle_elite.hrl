%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十月 2017 18:00
%%%-------------------------------------------------------------------
-author("Administrator").
-define(CREAT_COST, data_version_different:get(8)).%% 创建花费
-define(ETS_WAR_TEAM, ets_war_team).                 %% 战队ets表
-define(ETS_WAR_TEAM_MEMBER, ets_war_team_member).  %%战队成员ets表
-define(ETS_WAR_TEAM_APPLY, ets_war_team_apply).    %%战队申请列表

-define(ETS_CROSS_SCUFFLE_ELITE_RECORD, ets_cross_scuffle_elite_record).

%%准备时间
-define(CROSS_SCUFFLE_ELITE_READY_TIME, 1800).

-define(CROSS_SCUFFLE_ELITE_FINAL_READY_TIME, 300).

-define(WAR_TEAM_POSITION_CHAIRMAN, 1).  %%队长
-define(WAR_TEAM_POSITION_NORMAL, 2).  %%队员

%%分组--红
-define(CROSS_SCUFFLE_ELITE_GROUP_RED, 1).
%%分组--蓝
-define(CROSS_SCUFFLE_ELITE_GROUP_BLUE, 2).

%%活动状态--关闭
-define(CROSS_SCUFFLE_ELITE_STATE_CLOSE, 0).
%%活动状态--准备
-define(CROSS_SCUFFLE_ELITE_STATE_READY, 1).
%%活动状态--预赛开启
-define(CROSS_SCUFFLE_ELITE_STATE_START, 2).
%%活动状态--精英赛准备
-define(CROSS_SCUFFLE_ELITE_STATE_FAINAL_READY, 3).
%%活动状态--精英赛开启
-define(CROSS_SCUFFLE_ELITE_STATE_FAINAL_START, 4).

%% 决赛每一轮时间
-define(CROSS_SCUFFLE_ELITE_STATE_FAINAL_INTERVAL, 8 * 60).
%% 决赛准备时间
-define(CROSS_SCUFFLE_ELITE_STATE_FAINAL_READY_TIME, 35 * 60).

%% 活动总时间
-define(CROSS_SCUFFLE_ELITE_STATE_ALL_TIME, 70 * 60).



-define(CROSS_SCUFFLE_ELITE_TEAM_TIMEOUT, 60).

%%单局总时间
-define(CROSS_SCUFFLE_ELITE_PLAY_TIME, 210).


-define(WAR_TEAM_APPLY_MAX, 20). %% 战队可申请人数

-define(SCUFFLE_ELITE_COMBO_BUFF_ID, 56721).

%%每日奖励次数
-define(DAILY_CROSS_SCUFFLE_ELITE_TIMES_LIM, 10).

-define(WAR_TEAM_TIMER_UPDATE, 900).  %%定时更新时间


-record(st_cross_scuffle_elite, {
    open_state = 0,             %%活动状态0未开启，1已开启
    time = 0,
    total_time = 0,        %% 活动总时间
    ref = none,
    team_list = [],             %%待匹配的队伍列表
    match_list = [],            %%匹配列表[{team_key,num}],team_key 战队key
    final_list = [],            %% 决赛列表[#final_war{}]
    next_fight_num = 1,         %% 下一轮
    next_fight_time = 0,        %% 下一轮时间
    fight_record = [],          %% 战斗记录 [#fight_record{}]
    join_team_list = [],        %% 本次活动参与玩家
    mb_list = [],
    play_list = [],
    timer_update_ref = 0
}).

-record(final_war, {
    wtkey = 0,
    wtname = <<>>,
    sn = 0,
    rank = 0
}).

-record(fight_record, {
    id = 0, %%战斗id 1-15
    final_war1 = #final_war{},
    final_war2 = #final_war{},
    win_key = 0, %%胜利者 1 pkey1 2 pkey2
    bet_list = [],  %%投注列表 [{pkey,wtkey,id,node}]
    is_finish = 0
%%     name1 = 0,
%%     sn1 = 0,
%%     rank1 = 0,
%%     wtkey2 = 0,
%%     name2 = 0,
%%     sn2 = 0,
%%     rank2 = 0,
}).

-record(scuffle_elite_mb, {
    node = 0,
    sn = 0,
    pkey = 0,
    pid = 0,
    nickname = <<>>,
    career = 0,
    sex = 0,
    s_career = 0,
    avatar = "",    %%头像
    times = 0,
    is_agree = 0,   %%是否同意 1是0否
    team_key = 0,  %%队伍key,如果没有队伍则为玩家自身key
    team_name = <<>>,  %%战队名称
    position = 0,
    match_time = 0, %%匹配时间
    group = 0,
    score = 0,
    acc_kill = 0,
    acc_die = 0,
    acc_kill_mon = 0,
    acc_kill_mon_time = 0,
    acc_damage = 0,
    acc_damage_time = 0,
    att_damage = 0,
    att_damage_time = 0,
    is_alive = true,
    combo = 0,
    situ_revive = 0,
    acc_combo = 0,
    time = 0,
    rank = 0
}).

-record(scuffle_elite_team, {
    team_key = 0,
    time = 0,
    mb_list = []
}).

-record(ets_cross_scuffle_elite_record, {
    pkey = 0,
    pid = 0,
    figure = 0,
    group = 0,
    time = 0
}).

-record(base_scuffle_elite_career, {
    career = 0,
    figure = 0,
    name = <<>>,
    attrs = [],
    skill = [],
    move_speed = 0,
    att_speed = 0,
    att_area = 0
}).


-record(base_cross_scuffle_elite_bet, {
    id = 0,
    goods_id = 0,
    num = 0

}).


%% war_team 战队部分
%% **********************************************************

%%战队信息
-record(war_team, {
    wtkey = 0          %%战队ID
    , name = <<>>      %%战队名称
    , num = 1           %%战队人数
    , pkey = 0          %%队长Key
    , pname = <<>>      %%队长昵称
    , pcareer = 0
    , pvip = 0
    , create_time = 0
    , cbp = 0           %%成员战力总和
    , rank = 0           %%战队排名
    , sn = 0            %%服号
    , win = 0            %%胜场
    , lose = 0            %%败场
    , score = 0         %%积分
    , score_change_time = 0         %% 积分更新时间
    , is_change = 0
}).

%%战队成员信息
-record(wt_member, {
    pkey = 0                 %%玩家key
    , cbp = 0              %%战力
    , pid = undefined        %%玩家进程pid
    , wtkey = 0               %%战队ID
    , position = 0           %%职位 1会长 2普通成员
    , name = <<>>              %%玩家名称
    , career = 0             %%玩家职业
    , sex = 1                %%性别
    , lv = 0                 %%玩家等
    , avatar = ""            %%头像
    , vip = 0                %%VIP等
    , dvip = 0               %%钻石VIP等
    , is_online = 0          %%状态 0离线 1在线
    , last_login_time = 0    %%上一次登陆时间
    , login_day = 0
    , is_change = 0
    , use_role = []
    , join_time = 0  %% 加入时间
    , att = 0   %% 造成伤害
    , kill = 0   %% 杀人数
    , der = 0 %% 承受伤害
    , rank = 0 %% 最高排名
    , count = 0 %% 参与次数
}).

%%战队申请列表
-record(wt_apply, {
    akey = 0
    , pkey = 0            %%玩家key
    , wtkey = 0          %%战队key
    , nickname = ""     %%玩家昵称
    , career = 0        %%职业
    , lv = 0            %%等级
    , cbp = 0         %%战力
    , vip = 0           %%VIP
    , timestamp = 0      %%申请时间
    , rank = 0           %% 最高名次
}).


-define(WELFARE_DESK_TIME, 210).
-define(WELFARE_DESK_LIFE_TIME, 270).
%%  全名福利
-record(base_desk, {
    round = 0,
    desk_list = [],
    pos_list = [],
    count = 0
}).
