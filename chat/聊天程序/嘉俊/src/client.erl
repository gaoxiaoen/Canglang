-module(client).

%% API
-export([start/0, gateway/1]).

-define(Port, 2345).

start() ->
    login().

%% 登录流程
login() ->
    io:format("input cmd 1 or 2. 1 for login, 2 for register. ~n"),
    Str = io:get_line("input cmd, username and passsword: "),
    Len = string:len(Str),

    Msg = string:sub_string(Str, 1, Len - 1),
    Res = string:tokens(Msg, " "),
    InputLen = length(Res),

    if
        InputLen < 3 ->
            io:format("input error, input again~n"),
            login();
        true ->
            ok
    end,

    [No, Name, PassWd] = Res,

    {ok, Sock} = gen_tcp:connect("localhost", ?Port, [{packet, 0}]),

    if
        No == "1" ->
            gen_tcp:send(Sock, term_to_binary([login, Name, PassWd]));
        No == "2" ->
            gen_tcp:send(Sock, term_to_binary([register, Name, PassWd]));
        true ->
            io:format("cmd no error, input again~n"),
            login()
    end,


    receive
        {tcp, Sock, Bin} ->
            Ret = binary_to_term(list_to_binary(Bin)),
            case Ret of
                ok ->
                    io:format("login success~n"),
                    true;
                Reason ->
                    io:format("~p~n", [Reason]),
                    login()
            end
    end,

    SocketPid = spawn(fun() -> gateway(Sock) end),
    gen_tcp:controlling_process(Sock, SocketPid),

    help_info(),
    input_loop(SocketPid),

    ok.

gateway(Sock) ->
    network_handle(Sock).


%% 网络消息收发处理
network_handle(Sock) ->
    receive
        {tcp, Sock, Bin} ->
            case is_list(Bin) of
                true ->
                    io:format("-receive msg: ~p~n", [binary_to_term(list_to_binary(Bin))]);
                false ->
                    io:format("+receive msg: ~p~n", [binary_to_term(Bin)])
            end;
        {outer, Bin} ->
            gen_tcp:send(Sock, Bin)
    end,
    network_handle(Sock).


%%  信息输入循环
input_loop(SocketPid) ->
    io:format("you can get help info by enter 'help'~n"),
    Str = io:get_line("enter no: "),
    Len = string:len(Str),
    Msg = string:sub_string(Str, 1, Len - 1),

    if
        Msg == "help" ->
            help_info(),
            input_loop(SocketPid);
        true ->
            ok
    end,

    [Cmd | _Param] = string:tokens(Msg, " "),
    NoCmd = list_to_integer(Cmd),
    IsNum = is_number(NoCmd),
    if
        IsNum == false ->
            io:format("cmd must be number, please input again.~n"),
            input_loop(SocketPid);
        IsNum == true ->
            ok
    end,

    if
        NoCmd == 1 ->
            send_packet(SocketPid, term_to_binary([get_room_list])),
            io:format("localprint: send get room list request.~n");
        NoCmd == 2 ->
            send_packet(SocketPid, term_to_binary([create_room])),
            io:format("localprint: send create room list request.~n");
        NoCmd == 3 ->
            send_packet(SocketPid, term_to_binary([leave_room])),
            io:format("localprint: send leave room request.~n");
        NoCmd == 4 ->
            [Param1 | _] = _Param,
            NoParam1 = list_to_integer(Param1),
            send_packet(SocketPid, term_to_binary([join_room, NoParam1])),
            io:format("localprint: send join room request. ~p~n", [NoParam1]);
        NoCmd == 5 ->
            [Param1 | _] = _Param,
            send_packet(SocketPid, term_to_binary([chat, Param1])),
            io:format("localprint: send chat content request. ~p~n", [Param1]);
        NoCmd == 6 ->
            send_packet(SocketPid, term_to_binary([transform_admin])),
            io:format("localprint: send transform admin request.~n");
        NoCmd == 7 ->
            send_packet(SocketPid, term_to_binary([close_room])),
            io:format("localprint: send close room request.~n");
        true ->
            io:format("localprint: cmd error, input again ~p ~n", [NoCmd])
    end,
    input_loop(SocketPid).

send_packet(Pid, Data) ->
    Pid ! {outer, Data}.

help_info() ->
    io:format("1. get room list.~n2. create room.~n3. leave room.~n4. join room.~n5. chat.~n6. transform_admin.~n7. close room.~n").


