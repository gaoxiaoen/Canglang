%%----------------------------------------------------
%% @doc 定义所有活动的时间   海外活动 时间 控制 专用
%% @author liuweihua
%%----------------------------------------------------
%% 每次活动需要处理前期引用的

%% 活动时间，有引用到这个 hrl 文件的，需要开启活动的使用 open 系列
%% 过期的时间，有引用到这个 hrl 文件的，但又不需要开启活动的使用 close 系列
%% 每次新活动，需要将 open 系列 替换成 close系列，

%% =============================================================
%% 开启中的活动
%% =============================================================

%% -------------------------------------------------------------
%% 测试时间
%% -------------------------------------------------------------

-ifdef(debug).

%% 活动开始时间
-define(time_open_beg, {{2013, 04, 09}, {12, 00, 00}}).
%% 活动开始时间 秒
%% -define(time_open_beg_sec, 1357704000).
%% 活动开始当天 0 点
%% -define(time_open_beg_zero, {{2013, 01, 09}, {00, 00, 00}}).
%% 活动开始当天 0 点 秒
%% -define(time_open_beg_zero_sec, 1357660800).

%% 活动开始时间 前一天
%% -define(time_open_pre, {{2013, 01, 08}, {12, 00, 00}}).
%% 活动开始时间 前一天 秒
%% -define(time_open_pre_sec, (?time_open_beg_sec - 86400)).
%% 活动开始前一天 0 点
%% -define(time_open_pre_zero, {{2013, 01, 08}, {00, 00, 00}}).
%% 活动开始前一天 0 点 秒
%% -define(time_open_pre_zero_sec, (?time_open_beg_zero_sec - 86400)).

%% 活动结束时间
-define(time_open_end, {{2013, 04, 15}, {23, 59, 59}}).
%% 活动结束时间 秒
%% -define(time_open_end_sec, 0).
%% 活动结束当天 0 点
%% -define(time_open_end_zero, {{2012, 11, 05}, {0, 0, 0}}).
%% 活动结束当天 0 点 秒
%% -define(time_open_end_zero_sec, 0).

-else.

%% -------------------------------------------------------------
%% 正式活动时间
%% -------------------------------------------------------------

%% 活动开始时间
-define(time_open_beg, {{2013, 04, 11}, {12, 00, 00}}).
%% 活动开始时间 秒
%% -define(time_open_beg_sec, 0).
%% 活动开始当天 0 点
%% -define(time_open_beg_zero, {{2012, 11, 01}, {00, 00, 00}}).
%% 活动开始当天 0 点 秒
%% -define(time_open_beg_zero_sec, 0).

%% 活动开始时间 前一天
%% -define(time_open_pre, {{2012, 11, 01}, {12, 00, 00}}).
%% 活动开始时间 前一天 秒
%% -define(time_open_pre_sec, (?time_open_beg_sec - 86400)).
%% 活动开始前一天 0 点
%% -define(time_open_pre_zero, {{2012, 11, 01}, {00, 00, 00}}).
%% 活动开始前一天 0 点 秒
%% -define(time_open_pre_zero_sec, (?time_open_beg_zero_sec - 86400)).

%% 活动结束时间
-define(time_open_end, {{2013, 04, 25}, {23, 59, 59}}).
%% 活动结束时间 秒
%% -define(time_open_end_sec, 0).
%% 活动结束当天 0 点
%% -define(time_open_end_zero, {{2012, 11, 05}, {0, 0, 0}}).
%% 活动结束当天 0 点 秒
%% -define(time_open_end_zero_sec, 0).

-endif.

%% -------------------------------------------------------------
%% 过期活动
%% -------------------------------------------------------------
%% 活动开始时间
-define(time_close_beg, {{2012, 11, 01}, {12, 00, 00}}).
%% 活动开始时间 秒
-define(time_close_beg_sec, 0).
%% 活动开始当天 0 点
-define(time_close_beg_zero, {{2012, 11, 01}, {00, 00, 00}}).
%% 活动开始当天 0 点 秒
-define(time_close_beg_zero_sec, 0).

%% 活动开始时间 前一天
-define(time_close_pre, {{2012, 11, 01}, {12, 00, 00}}).
%% 活动开始时间 前一天 秒
-define(time_close_pre_sec, 0).
%% 活动开始前一天 0 点
-define(time_close_pre_zero, {{2012, 11, 01}, {00, 00, 00}}).
%% 活动开始前一天 0 点 秒
-define(time_close_pre_zero_sec, 0).

%% 活动结束时间
-define(time_close_end, {{2012, 11, 05}, {23, 59, 59}}).
%% 活动结束时间 秒
-define(time_close_end_sec, 0).
%% 活动结束当天 0 点
-define(time_close_end_zero, {{2012, 11, 05}, {0, 0, 0}}).
%% 活动结束当天 0 点 秒
-define(time_close_end_zero_sec, 0).


