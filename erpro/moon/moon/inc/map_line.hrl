%----------------------------------------------------
%% 
%% @author qingxuan
%%----------------------------------------------------

-define(LINE_MAX, 30). %% 最多30条线
-define(LINE_DEF_COUNT, 3). %% 默认只开3条线
%-define(LINE_CAPACITY, 200).  %% 每条线容量
%-define(LINE_CREATE_CONDITION, 100).  %% 剩余空位不足100时，自动开新线
-define(LINE_CAPACITY, 100).  %% 每条线容量
-define(LINE_CREATE_CONDITION, 50).  %% 剩余空位不足50时，自动开新线
-define(LINE_RESET_INTERVL, 60000). %% 毫秒
-define(LINE_OFFLINE_TIMEOUT, 300). %% 离线5分钟/300秒后自动换线, 5分钟内进入上次的线路
