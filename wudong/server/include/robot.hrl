%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 三月 2017 21:21
%%%-------------------------------------------------------------------
-author("li").

-record(robot_step, {
    scene = 0
    ,step_list = []
}).

-define(ETS_ROBOT_STEP, ets_robot_step).

-define(IP, "192.168.2.50").
-define(PORT, 8001).
-define(PLATFORM,888).
-define(TICKET,"3e1f8f56ad582a7e76f8ef8adef0a54c").

-record(player_state, {
    socket = none,
    self = none,
    accname = none,
    pkey = none,
    scene = 0,
    point = [],
    back = [],
    cmd_list = [],
    heartbeat_ref = null,
    login_time = 0,
    x = 0,
    y = 0,
    scene_name = <<>>
}).

-define(ROBOT_MONKEY_LIST, robot_monkey_list).
-define(OPEN_CLIENT_TIME, 1000). %% 每隔1秒钟开启1个客户端
-define(HEARTBEAT_TIME, 8000). %% 心跳时间间隔
