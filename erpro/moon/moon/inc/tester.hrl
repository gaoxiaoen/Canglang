-record(tester, {
         id = 0                 %% 角色ID
        ,srv_id = <<>>
        ,pid = 0                %% 进程ID
        ,name = <<>>            %% 角色名
        ,acc_name = <<>>        %% 帐号名
        ,socket
        ,send_count = 0
        ,connect_time
        ,read_head = false      %% 标识正在读取数据包头

        ,x = 0                  %% 当前X坐标
        ,y = 0                  %% 当前Y坐标
    }
).
