-ifndef(GUILD_ANSWER_HRL).
-define(GUILD_ANSWER_HRL, 1).


-define(GUILD_ANSWER_STATE_CLOSE, 0).
-define(GUILD_ANSWER_STATE_READY, 1).
-define(GUILD_ANSWER_STATE_START, 2).

%%-define(GUILD_ANSWER_TIME_LIST, [[{11, 00}, {11, 10}], [{22, 00}, {22, 10}]]).
-define(GUILD_ANSWER_READY_TIME, 1800).
-define(GUILD_ANSWER_TIMEOUT, 60).

-define(GUILD_ANSWER_NUM,10).

-record(st_guild_answer, {
    state = 0,
    ref = [],
    time = 0,
    answer_list = []
}).

-record(guild_answer, {
    gkey = 0,
    gname = <<>>,
    question = [],
    time = 0,
    ref = [],
    is_finish = 0, %%1|0
    calc_time = 0,
    pkey = 0,
    nickname = <<>>
}).

-endif.