%% Description: 开启一个服务器连接器
-module(chat_acceptor).

-export([start/1,accept_loop/1]).


%%start listen server
start(Port)->
    case (do_init(Port))of
        {ok,ListenSocket}->
            io:format("server start ok!"),
            accept_loop(ListenSocket);  %% 监听成功，开始接受客户端的连接请求
        _Els ->
            error
    end.

%%监听端口,判断字符串端口，如果是，则转换为整型
do_init(Port) when is_list(Port)->
    start(list_to_integer(Port))
;
%% 如果是原子，则将原子转换为整型
do_init([Port]) when is_atom(Port)->
    start(list_to_integer(atom_to_list(Port)))
;
%% 如果是整型，则正常设置监听端口
do_init(Port) when is_integer(Port)->
    Options=[binary,
        {packet, 0},
        {reuseaddr, true},
        {backlog, 1024},
        {active, true}],   %% 采用非阻塞的方式
    case gen_tcp:listen(Port, Options) of
        {ok,ListenSocket}->
            {ok,ListenSocket};
        {error,Reason} ->
            {error,Reason}
    end.

%%接受客户端的连接
accept_loop(ListenSocket)->
    case (gen_tcp:accept(ListenSocket, 3000))of
        {ok,Socket} ->
            process_clientSocket(Socket),
            ?MODULE:accept_loop(ListenSocket);
        {error,Reason} ->
            ?MODULE:accept_loop(ListenSocket);
        {exit,Reason}->
            ?MODULE:accept_loop(ListenSocket)
    end.

%%process client socket
%%we should start new thread to handle client
%%generate new id using id_generator
process_clientSocket(Socket)->
    Record=chat_room:getPid(),
    chat_room:bindPid(Record, Socket),
    ok.
%%
%% Local Functions
%%

