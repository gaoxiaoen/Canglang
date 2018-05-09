-module(tcp).
-compile(export_all).
-import(ets,[insert_new/2]).

%服务端
start_parallel_server() ->
    %创建一个全局的ets表，存放客户端的id
    ets:new(id, [ordered_set, public, named_table, {write_concurrency, true}, {read_concurrency, true}]),

    case gen_tcp:listen(1234, [binary, {packet,0}, {active,true}]) of
        {ok, ListenSocket} ->
            spawn(fun()-> par_connect(ListenSocket) end);
        {error, Reason} ->
            io:format("~p~n", [Reason])
    end.

par_connect(ListenSocket) ->
    case gen_tcp:accept(ListenSocket) of
        {ok,Socket} ->
            %每连接到一个客户端，把id插入到ets表中
            case ets:last(id) of
                '$end_of_table' ->
                    ets:insert(id, {1, Socket});
                Other ->
                    ets:insert(id, {Other+1, Socket})
            end,
            spawn(fun() -> par_connect(ListenSocket) end),   			     %每连接一个客户端都新开一个进程
            loop(Socket);
        {error, Reason} ->
            io:format("~p~n", [Reason])
    end.

loop(Socket) ->
    receive
        {tcp, Socket, Bin} ->
            [ID, Msg] = binary_to_term(Bin),
            io:format("Messages is ~p~n", [Msg]),
            [{Id, Socket1}] = ets:lookup(id,ID),
            gen_tcp:send(Socket1, term_to_binary(Msg)),
            loop(Socket);
        {tcp_closed, Socket} ->
            io:format("Server socket closed ~n")
    end.



%客户端
start_client() ->
    {ok, Socket1} = gen_tcp:connect("localhost", 1234, [binary, {packet,0}]),  %连接服务器
    %新建一个进程负责接收消息
    Pid = spawn(fun() -> loop1() end),
    %监听指定进程
    gen_tcp:controlling_process(Socket1, Pid),

    %负责发送信息
    sendMsg(Socket1).

loop1() ->
    receive
        {tcp, Socket, Bin} ->
            Res = binary_to_term(Bin),
            io:format("Receive massages = ~p ~p~n", [Res,Socket]),
            loop1();
        {tcp_closed, Socket} ->
            io:format("Scoket is closed! ~p~n",[Socket])
    end.

sendMsg(Socket1) ->
    I = io:get_line("id:"),
    M = io:get_line("say:"),
    {Ii, Info} = string:to_integer(I),
    io:format("sendMsg is come! ~p~n",[Info]),
    gen_tcp:send(Socket1, term_to_binary([Ii, M])),
    sendMsg(Socket1).