-define(ALL_SERVER_PLAYERS, 10000).

%%tcp_server监听参数
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).

%%在线角色信息
-define(ETS_ONLINE, ets_online).

%%错误处理
-define(DEBUG(F, A), util:log("debug", F, A, ?MODULE, ?LINE)).
-define(ERR(F, A), util:log("error", F, A, ?MODULE, ?LINE)).

%%数据库连接
-define(DB, sd_mysql_conn).
-define(DB_HOST, "localhost").
-define(DB_PORT, 3306).·
-define(DB_USER, "sdzmmo").
-define(DB_PASS, "sdzmmo123456").
-define(DB_NAME, "sdzmmo").
-define(DB_ENCODE, utf8).

%%打开发送消息客户端进程数量
-define(SEND_MSG, 3).
