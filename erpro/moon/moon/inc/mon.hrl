-define(cmd(Cmd), self() ! {cmd, ?MODULE, Cmd, {}}).
-define(cmd(Cmd, Params), self() ! {cmd, ?MODULE, Cmd, Params}).
-define(cmd(Mod, Cmd, Params), self() ! {cmd, Mod, Cmd, Params}).
-define(cmd(Mod, Cmd, Params, After), erlang:send_after(After, self(), {cmd, Mod, Cmd, Params})).

-record(mon, {
        pid                 %% 监控进程ID
        ,account = <<>>     %% 登录服务器时使用的帐号名
        ,host = <<>>        %% 监控的目标
        ,port               %% 监控目标的端口号
        ,socket
        ,send_count = 0
        ,connect_time       %% 建立连接的时间
    }
).
