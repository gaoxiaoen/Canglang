-record(chatroomstatus, {
    rooms = maps:new(),       %% 房间
    plyToRoomId = maps:new(), %% 玩家所在房间号,玩家id到房间号的映射
    roomAllocId = 1           %% 房间自增id
}).