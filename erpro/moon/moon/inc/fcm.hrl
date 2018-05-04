%%---------------------------------------------
%% 防沉迷数据结构
%% @author 252563398@qq.com
%%---------------------------------------------

-define(fcm_version_close, 0).   %% 关闭版本
-define(fcm_version_strict, 1).  %% 严格版本
-define(fcm_version_nor, 2).     %% 普通版本

-define(fcm_allow_online_time, 10800). %% 允许连续在线时间最大值 3 * 60 * 60
-define(fcm_offline_reset_time, 18000).  %% 离线重置时间 5 * 60 * 60

-record(fcm, {
        is_auth = 0       %% 是否通过防沉迷认证 (0:未通过 1:通过)
        ,login_time = 0   %% 登录时间
        ,logout_time = 0  %% 上次登录退出时间与登录时间差
        ,acc_time = 0     %% 累计在线时间
        ,msg_id = 0       %% 信息提示索引
    }
).
