%%----------------------------------------------------
%% @doc 客户端日志
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-record(log_client_msg, {
        role_id = 0         %% 角色id     
        ,srv_id = <<>>      %% 标志符
        ,account = <<>>     %% 账号名
        ,name = <<>>        %% 角色名称
        ,md5 = <<>>         %% md5
        ,system = <<>>      %% 系统
        ,browser = <<>>     %% 浏览器
        ,fp_version = <<>>  %% fp版本
        ,client_version = <<>> %% 客户端版本
        ,error_code = 0     %% 错误代码
        ,msg = <<>>         %% 错误信息
        ,time = 0           %% 时间
    }
).
