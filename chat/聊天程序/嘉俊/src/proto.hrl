%% 内部rpc通信简单协议格式
-record(proto, {
    pid = null,   %% 发送方进程id
    id = null,    %% 玩家id
    data = null,  %% 数据
    name = null   %% 玩家姓名
}).