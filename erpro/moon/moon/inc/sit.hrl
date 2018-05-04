%% ****************************
%% 打坐双修的双方数据缓存结构
%% wprehard@qq.com
%% ****************************

%% 11601协议返回的类型
-define(sit_ok, 0).         %% 打坐成功
-define(sit_sync, 1).       %% 打坐同步数据
-define(sit_cancel, 2).     %% 取消打坐
-define(sit_fail, 3).       %% 打坐请求失败

%% 正在双修打坐的列表数据
-record(sit_both, {
        id_one = 0          %% 双修一方
        ,id_two = 0         %% 双修另一方
        ,pid_two = 0        %% 对方进程PID
        ,type = 0           %% 双修类型：11-普通 12-结拜 13-师徒 14-情侣
        ,s_time = 0         %% 开始时间
    }).
