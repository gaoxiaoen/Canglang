%%----------------------------------------------------
%% client
%% 
%% @author Qingxuan
%%----------------------------------------------------
-module(cli).
-compile(export_all).
-include("cli.hrl").

start(AccFrom, AccTo) ->
    case file:consult("cli.config") of
        {ok, [Config|_]} ->
            ?I("config: ~p", [Config]),
            Platform = proplists:get_value(platform, Config),
            SrvId = proplists:get_value(srv_id, Config),
            Host = proplists:get_value(host, Config),
            Port = proplists:get_value(port, Config),
            Interval = proplists:get_value(interval, Config, 500),
            util:for(AccFrom, AccTo, fun(I) ->
                timer:sleep(Interval),
                Acc = list_to_binary(lists:concat(["ttacc", I])),
                spawn(fun()->
                    start(Host, Port, Acc, SrvId, Platform)
                end)
            end),
            ok;
        Other ->
            Other
    end.

start(Host, Port, Acc, SrvId, Platform) ->
    {ok, Socket} = gen_tcp:connect(Host, Port, ?TCP_OPTS),
    ?I("~p connected", [Acc]),
    Client = #client{socket = Socket, acc = Acc, srv_id = SrvId, platform = Platform, pid = self()},
    ConnPid = spawn_link(?MODULE, recv_loop, [Socket, self()]),
    ok = gen_tcp:controlling_process(Socket, self()), 
    Client1 = cli_handle:on_connect(Client#client{conn_pid = ConnPid}), 
    Client2 = Client1#client{director = cli_director:steps()},
    handle_loop(Client2),
    {disconnect, Acc}.

%% 接收消息
recv_loop(Socket, HandlePid) ->
    Res = 
        case gen_tcp:recv(Socket, 6) of %% len of the packet and proto number
            {ok, P1} ->
                <<Len:32, Proto:16>> = P1,
                ?D("recv Len=~p Cmd=~p", [Len, Proto]),
                case Len > 2 of 
                    true -> %% not empty binary
                        case gen_tcp:recv(Socket, Len - 2) of 
                            {ok, B1} ->
                                {Proto, B1};
                            {error, _} -> 
                                ignore
                        end;
                    false ->
                        {Proto, <<>>}
                end;
            {error, _} -> ignore
        end, 

    case Res of 
        {Cmd, <<>>} -> 
            HandlePid ! {recv, Cmd, {}},
            recv_loop(Socket, HandlePid);
        {Cmd, Bin} ->
            ?D("recv: ~p ~p~n", [Cmd, Bin]),
            case unpack(Cmd, Bin) of
                error -> error;
                Data -> HandlePid ! {recv, Cmd, Data}
            end,
            recv_loop(Socket, HandlePid);
        ignore -> 
            recv_loop(Socket, HandlePid)
    end.

send(#client{socket = Socket}, Bin) ->
    gen_tcp:send(Socket, Bin);
send(Socket, Bin) when is_binary(Bin) ->
    gen_tcp:send(Socket, Bin).

send(#client{socket = Socket}, Cmd, Data) ->
    send(Socket, Cmd, Data);
send(Socket, Cmd, Data) when is_tuple(Data) ->
    case mapping:module(game_server, Cmd) of
        {ok, _Auth, _Caller, Proto, _ModName} ->
            case catch Proto:pack(cli, Cmd, Data) of
                {ok, Bin} -> 
                    ?D("~p pack: ~p", [Cmd, Bin]),
                    send(Socket, Bin);
                _Err ->
                    _Err
            end;
        {error, _Code} ->
            _Code
    end.

unpack(Cmd, Bin) ->
    case mapping:module(game_server, Cmd) of
        {ok, _Auth, _Caller, Proto, _ModName} ->
            case catch Proto:unpack(cli, Cmd, Bin) of
                {ok, Data} -> 
                    ?D("~p unpack: ~p", [Cmd, Data]),
                    Data;
                _Err ->
                    ?D("proto unpack err: ~p", [_Err]),
                    error
            end;
        {error, _Code} ->
            ?D("unknown proto unpack mod: ~p", [_Code]),
            error
    end.


handle_loop(Client) ->
    receive
        {recv, Cmd, Data} ->
            case catch cli_handle:recv(Cmd, Data, Client) of
                {RespCmd, RespData, NewClient = #client{}} ->
                    send(Client, RespCmd, RespData),
                    NewClient1 = director(Cmd, NewClient),
                    handle_loop(NewClient1);
                NewClient = #client{} ->
                    NewClient1 = director(Cmd, NewClient),
                    handle_loop(NewClient1);
                {'EXIT', _Reason} ->
                    handle_loop(Client);
                stop ->
                    loop_break;
                _ ->
                    handle_loop(Client)
            end; 
        {'EXIT', _From, _Reason} ->
            loop_break;
        Msg ->
            case catch cli_handle:on_msg(Msg, Client) of
                {RespCmd, RespData, NewClient = #client{}} ->
                    send(Client, RespCmd, RespData),
                    NewClient1 = director(Msg, NewClient),
                    handle_loop(NewClient1);
                NewClient = #client{} ->
                    NewClient1 = director(Msg, NewClient),
                    handle_loop(NewClient1);
                {'EXIT', _Reason} ->
                    handle_loop(Client);
                stop ->
                    loop_break;
                _ ->
                    handle_loop(Client)
            end
    end.

%director(Cmd, Client) ->
%    Step = cli_director:get_step(),
%    case cli_director:do(Step, Cmd, Client) of
%        {true, RespCmd, RespData} ->
%            send(RespCmd, RespData),
%            cli_director:step_up();
%        true ->
%            cli_director:step_up();
%        _ ->
%            ignore
%    end.

director(Cmd, Client = #client{director = [Step|Steps]}) ->
    case Step of
        {Cmd, Action} ->
            case cli_director:Action(Client) of
                {true, RespCmd, RespData} ->
                    send(Client, RespCmd, RespData),
                    Client#client{director = Steps};
                true ->
                    Client#client{director = Steps};
                _ ->
                    Client
            end;
        _ ->
            Client
    end;
director(_Cmd, Client = #client{director = []}) ->
    Client.

