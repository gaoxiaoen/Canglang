%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2017 上午10:27
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(ETS_CROSS_FRUIT,  ets_cross_fruit).  %%跨服水果大作战
-define(ETS_CROSS_FRUIT_PLAYER, ets_cross_fruit_player).  %%参与玩家

-define(FRUIT_TYPE_1,  1).  %%水果类型
-define(FRUIT_TYPE_2,  2).
-define(FRUIT_TYPE_3,  3).
-define(FRUIT_TYPE_DCR_TH, 4).  %%水果类型 替换稻草人
-define(FRUIT_TYPE_DCR, 5).  %%水果类型 点击稻草人
-define(FRUIT_TYPE_STONE, 6).  %%水果类型 岩石
-define(FRUIT_TYPE_BOOM, 7).  %%水果类型 炸弹

-define(MATCH_TIMEOUT,  30).  %%匹配超时时间
-define(MATCH_TIME,  3).  %%定时匹配时间
-define(INVITE_ITME, 10).  %%邀请超时时间

-define(MAX_WIN_ROUND, 3).  %%3局2胜制

-define(NEXT_ROUND_WAIT_TIME, 3).  %%下一回合等待时间
-define(ROBOT_SHOT_TIME_1, 500).  %%机器人反应短时间 毫秒
-define(ROBOT_SHOT_TIME, 1000).  %%机器人反应短时间 毫秒
-define(ROBOT_LONG_TIME, 3000).

-define(MAX_GET_GIFT_TIEMS,  5).  %%每天最大可领取奖励次数

-record(st_cross_fruit, {
    pkey = 0,
    get_times = 0,  %%今日获取奖励次数
    update_time = 0,  %%更新时间
    win_times = 0,  %%胜利次数
    win_update_time = 0,  %%胜利更新时间
    state = 0       %%状态0未开始 1开始中
}).

-record(cf_state, {
    match_ref = 0,   %%匹配计时器
    rank_list = []  %%上周排行可领取玩家[{rank,pkey,get_state}]
}).

-record(cross_fruit, {
    fkey = 0,
    pkey1 = 0,
    pkey2 = 0,
    start_time = 0,
    win = [], %%胜利列表 [1,2,1] 1代表pkey1 2代表pkey2
    cur_round = 0,  %%当前局数
    cur_target = []  %%当前目标
}).

-record(cross_fruit_player, {
    pkey = 0,
    fkey = 0,  %%当前作战key
    is_robot = 0,  %%是否机器人
    node = none,
    name = "",
    sn = 0,
    career = 0,
    sex = 0,
    vatar = "",
    sid = none,

    win_times = 0,

    state = 0,  %%0未开始 1开始中
    next_round_time = 0,  %%下一局开始时间
    target = [],  %%当前目标 [#tg{}]
    click_times = 0,  %%当前局点击次数
    apply_time = 0,  %%开始申请匹配时间
    invite_time = 0  %%开始邀请时间
}).

-record(tg, {
    pos = 0,
    type = 0,
    click_times = 0,
    boom_time = 0,  %%炸弹开始时间
    boom_ref = 0,  %%炸弹计时器
    change_type = 0  %%变化类型
}).

-record(base_week_rank,{
    min_rank = 0,
    max_rank = 0,
    goods_list = []
}).
