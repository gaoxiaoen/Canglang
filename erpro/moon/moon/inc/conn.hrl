%%----------------------------------------------------
%% 连接器相关数据结构定义
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-record(conn, {
        object              %% 控制对象
        ,type               %% 连接器类型
        ,account = <<>>     %% 连接器的所有者帐号名
        ,platform = <<>>    %% 渠道平台
        ,pid_object         %% 控制对象pid
        ,socket             %% socket
        ,ip                 %% 客户端IP
        ,port               %% 客户端连接端口
        ,connect_time = 0   %% 建立连接的时间
        ,length = 0         %% 包体长度
        ,seq = 0            %% 当前包序
        ,read_head = false  %% 标识正在读取数据包头
        ,recv_count = 0     %% 已接收的消息数量
        ,send_count = 0     %% 已发送的消息数量
        ,error_send = 0     %% 发送错误次数
        ,bad_req_count = 0  %% 记录客户端发送的错误数据包个数
        ,suspend = false    %% 暂停、挂起收包 
        ,heartbeat          %% 心跳定时器
        ,suspend_cnt = 0   %% 挂起的时间
        ,device_id = <<>>
    }
).

%% 断开连接原因
-define(disconn_kick, 1).  %% 被踢下线(跳回登录界面)
-define(disconn_login_conflict, 2). %% 登录冲突，在异地登录，被挤下线

