-define(TCP_OPTS, [binary, {active, false}, {packet, 0}, {nodelay, false}, {delay_send, true}, {exit_on_close, false}]).

%-define(D(F,A), io:format(F++"\n", A)).
%-define(D(S), io:format(S++"\n")).
-define(D(F,A), ignore).
-define(D(S), ignore).

-define(I(F,A), io:format(F++"\n", A)).
-define(I(S), io:format(S++"\n")).

-record(client, {
    role_id = 0
   ,director
   ,pid 
   ,platform = <<>>
   ,role_name = <<>>
   ,srv_id = <<>>
   ,acc = <<>>
   ,career = 1
   ,sex = 1
   ,scene = 0
   ,socket
   ,conn_pid
   ,map
   ,x
   ,y
   ,npcs
}).

-record(cli_map_npc, {
   id 
   ,base_id
   ,x
   ,y
}).

-define(DEF_HOST, "114.112.100.101").
-define(DEF_PORT, 8010).
-define(DEF_INTERVAL, 500).
-define(srv_id, <<"10001">>).

