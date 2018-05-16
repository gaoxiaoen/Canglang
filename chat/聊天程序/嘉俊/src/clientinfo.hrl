%% 玩家状态信息
-record(clientinfo, {
    id = null,
    name = null,    %% 账号名字
    login = 0,   %% 是否已经通过登录验证
    pid = null,
    socket = null
}).