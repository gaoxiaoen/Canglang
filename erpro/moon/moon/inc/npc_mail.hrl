
-record(npc_mail, {
        id     %% 事件id
        ,label %% 事件类型
        ,trigger_id = 0 %% 触发器id
        ,type = 0       %% 事件类型id
        ,target = 1     %% 目标次数
        ,current = 0    %% 当前值
        ,status = 0     %% 当前状态
    }).
