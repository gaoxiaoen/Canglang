-record(notification, {
    type        
    ,msg
    ,args
}).

%% 消息类型
-define(notify_type_example, -1).
-define(notify_type_hall, 1).
-define(notify_type_wanted, 2).
-define(notify_type_arena_career_win, 3).
-define(notify_type_arena_career_lose, 4).
-define(notify_type_join_guild, 5).

-define(notify_color_num(Num), list_to_binary(["<font color='fffeb300'>", integer_to_list(Num), "</font>"])).
