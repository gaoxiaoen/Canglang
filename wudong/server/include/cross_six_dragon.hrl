%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 二月 2017 上午10:22
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(SD_TEAM_1,  1).     %%六龙分组 2人组
-define(SD_TEAM_2,  2).     %%六龙分组 4人组

-define(ETS_SIX_DRAGON_PLAYER,  ets_six_dragon_player).     %%六龙玩家ets
-define(ETS_SIX_DRAGON_TEAM,  ets_six_dragon_team).     %%六龙队伍ets

-define(MATCH_TIMER,  3).  %%匹配时间 10秒
-define(MATCH_TIME_OUT, 8).   %%匹配超时1
-define(MATCH_TIME_OUT_2, 15).   %%匹配超时2
-define(MATCH_NUM, 6).  %%匹配人数
-define(DUNGEON_TIME, 180).  %%副本时间

-define(FIGHT_SCENE_XY, [{7,14}, {41,54}]).   %%战斗场景出生点

-define(WIN_POINT,  30).
-define(FAIL_POINT, 10).
-define(MVP_POINT, 5).

-define(SIX_DRAGON_BUFF_1, 56603).  %%二人组buff
-define(SIX_DRAGON_BUFF_2, 56602).  %%四人组buff

-record(six_dargon_st,{
    state = 0  %%开启状态 0关闭 1开始 2即将开启
    , start_time = 0
    , ent_time = 0
    , end_ref = 0
    , end_notice_ref = 0
    , match_ref = 0     %%匹配计时器
}).

-record(sd_team,{
    copy = 0             %%房间
    , player_list = []    %%玩家列表 [#sd_team_md{}]
    , life1 = 5          %%组1剩余共享生命数
    , life2 = 5          %%组2剩余共享生命数
    , start_time = 0    %%开始时间
    , end_time = 0      %%结束时间
    , end_ref = 0
}).

-record(sd_team_md,{
    pkey = 0
    , team = 0
    , kill = 0
    , die = 0
    , last_kill_time = 0 %%最后击杀时间
}).

-record(sd_player, {
    pkey = 0        %%玩家key
    , sn = 0
    , pf = 0
    , node = 0
    , name = ""
    , lv = 0
    , cbp = 0
    , sid = 0
    , sex = 0
    , career = 0
    , avatar = ""

    , point = 0     %%活动总积分
    , fight_times = 0%%战斗次数
    , win_times = 0  %%胜利次数

    , copy = 0      %%当前所在房间

    , apply_state = 0   %%匹配状态 0无需匹配 1匹配中
    , apply_time = 0    %%申请匹配时间

}).


