%%----------------------------------------------------
%% client
%% 
%% @author Qingxuan
%%----------------------------------------------------
-module(beer_machine).
-compile(export_all).

-define(TCP_OPTS, [binary, {active, false}, {packet, 0}, {nodelay, false}, {delay_send, true}, {exit_on_close, false}]).

%-define(D(F,A), io:format(F++"\n", A)).
%-define(D(S), io:format(S++"\n")).
% -define(D(F,A), ignore).
% -define(D(S), ignore).
-define(D(Msg), io:format("[~p:~p]" ++ Msg, [?MODULE, ?LINE])).
-define(D(Msg, Args), io:format("[~p:~p]" ++ Msg, [?MODULE, ?LINE] ++ Args)).

-define(I(F,A), io:format(F++"\n", A)).
-define(I(S), io:format(S++"\n")).

-record(acc, {
    role_id = 0
   ,role_name = <<>>
   ,acc_id = <<>>
   ,acc_name = <<>>
   ,career = 1
   ,sex = 1
   ,scene = 101070
   ,socket
}).
%-define(DEF_HOST, "113.107.161.112").
-define(DEF_HOST, "192.168.8.103").
%-define(DEF_HOST, "119.147.112.6").
-define(DEF_PORT, 8010).
-define(DEF_INTERVAL, 500).
-define(srv_id, <<"215_10043">>).
-define(pos_x_left, 300).
-define(pos_x_right, 1100).
-define(speed, 70).

-define(DEBUG(Msg), io:format("[~p:~p]" ++ Msg, [?MODULE, ?LINE])).
-define(DEBUG(Msg, Args), io:format("[~p:~p]" ++ Msg, [?MODULE, ?LINE] ++ Args)).

% -include("common.hrl").
% -include("conn.hrl").

start(FromAccId, ToAccId) ->
    start(FromAccId, ToAccId, ?DEF_HOST, ?DEF_PORT, ?DEF_INTERVAL).

start(FromAccId, ToAccId, Port) ->
    start(FromAccId, ToAccId, ?DEF_HOST, Port, ?DEF_INTERVAL).

start(FromAccId, ToAccId, Host, Port, Interval) when FromAccId=<ToAccId ->
    AccName = list_to_binary("bicoo_"++integer_to_list(FromAccId)),
    spawn(?MODULE, start_client, [FromAccId, AccName, Host, Port]),
    timer:sleep(Interval),
    start(FromAccId+1, ToAccId, Host, Port, Interval);
start(_FromAccId, _ToAccId, _Host, _Port, _Interval) ->
    ok.

start_client(AccId, AccName, Host, Port) ->
    Acc = #acc{acc_id=AccId, acc_name=AccName},
    {ok, Sock} = gen_tcp:connect(Host, Port, ?TCP_OPTS),
    ?I("~p connected", [AccId]),
    Pid = spawn_link(?MODULE, base_recv_loop, [Sock, Acc#acc{socket=Sock}]),
    ok = gen_tcp:controlling_process(Sock, Pid),    
    timer:sleep(500),
    
    % ok = send(Sock, 1105, {AccName, 1, 2, ?srv_id, <<>>}),

    ok = send(Sock, 1010, {<<"bicolol8">>, ?srv_id, util:unixtime(), <<>>, <<>>}),

    % timer:send_interval(20000, Pid, heartbeat),
    ok.

%% 接收消息
base_recv_loop(Socket, Acc) ->
    Res = 
        case gen_tcp:recv(Socket, 6) of %% len of the packet and proto number
            {ok, P1} ->
                <<Len:32, Proto:16>> = P1,
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
            Acc1 = case recv(Cmd, {}, Acc) of
                {Cmd1, Bin1, Acc0} -> 
                    send(Socket, Cmd1, Bin1),
                    Acc0;
                _ -> Acc
            end,
            base_recv_loop(Socket, Acc1);
        {Cmd, Bin} ->
            ?DEBUG("recv: ~p ~p~n", [Cmd, Bin]),
            Acc1 = case unpack(Cmd, Bin) of
                error ->
                    Acc;
                Data ->
                    case recv(Cmd, Data, Acc) of
                        {Cmd1, Bin1, Acc0} -> 
                            send(Socket, Cmd1, Bin1),
                            Acc0;
                        _ -> Acc
                    end
            end,
            base_recv_loop(Socket, Acc1);
        ignore -> 
            base_recv_loop(Socket, Acc)
    end.






recv(1010, _Bin, Acc) ->
    ?DEBUG("--recv 1010---~n~n"),
    {1100, {?srv_id}, Acc};

recv(1100, _Msg, Acc) ->
    ?DEBUG("--recv 1100---~n~n"),
    % case RoleL of
    %     [] -> 
    %         Sex = util:rand(0, 1),
    %         CareerIndex = util:rand(1, 3),
    %         Career = lists:nth(CareerIndex, [2, 3, 5]),
    %         {1105, {Acc#acc.acc_name, Sex, Career, ?srv_id}, Acc};
    %     [[RoleId, _SrvId, _Status, _Name, _Sex, _Lev, _Career]|_] ->
    %         {1120, {RoleId, ?srv_id}, Acc}
    % end;
    Sex = util:rand(0, 1),
    CareerIndex = util:rand(1, 3),
    Career = lists:nth(CareerIndex, [2, 3, 5]),
    {1105, {Acc#acc.acc_name, Sex, Career, ?srv_id, <<>>}, Acc};

recv(1105, {RoleId, _MsgId}, Acc) ->
    ?DEBUG("--recv 1105---~n~n"),
    {1120, {RoleId, ?srv_id}, Acc};

recv(1120, {Code, _MsgId}, Acc) ->
    ?DEBUG("--recv 1120---~n~n"),
    case Code of
        1 -> 
            {10100, {0, 0}, Acc};
        _ ->
            ?DEBUG("~p : ~p~n", [Code, i18n:text(_MsgId)]),
            ok
    end;
    % {14430, {}, Acc};
    % ok;


recv(14430, _, _Acc) ->
    % move(Acc#acc.socket, 1),
    ok;

recv(14431, _, _Acc) ->
    ok;
recv(14432, _, _Acc) ->
    ok;
recv(14433, _, _Acc) ->
    ok;
recv(14434, _, _Acc) ->
    ok;
recv(14435, _, _Acc) ->
    ok;
recv(14437, _, _Acc) ->
    ok;
recv(14438, _, _Acc) ->
    ok;

% recv(14430, {Data}, Acc) ->
%     ok;

recv(9910, _, Acc) ->
    {14430, {}, Acc};

recv(10110, {Map, _, _}, Acc) ->
    put(map, Map),
    {10111, {}, Acc};

recv(10111, _, Acc) ->
    case get(map) of
        120 ->
            % {10101, {1400}, Acc};
            % {14430, {}, Acc};
            {9910, {<<"stat">>}, Acc};
        1400 ->
            talk(Acc#acc.socket),
            move(Acc#acc.socket, 1);
        180 ->
            move(Acc#acc.socket, 1);
        _ ->
            move(Acc#acc.socket, 1),
            ok
    end;

recv(_Cmd, _Data, _Acc) ->
    ?DEBUG("recv unknown: ~p ~p~n", [_Cmd, _Data]),
    noreply.

send(Socket, Bin) when is_binary(Bin) ->
    gen_tcp:send(Socket, Bin).
send(Socket, Cmd, Data) when is_tuple(Data) ->
    case mapping:module(game_server, Cmd) of
        {ok, _Auth, _Caller, Proto, _ModName} ->
            case catch Proto:pack(cli, Cmd, Data) of
                {ok, Bin} -> 
                    % ?D("~p pack: ~p", [Cmd, Bin]),
                    ?DEBUG("~p pack: ~p~n", [Cmd, Bin]),
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
                    ?D("~p unpack: ~p~n", [Cmd, Data]),
                    Data;
                _Err ->
                    ?D("proto unpack err: ~p~n", [_Err]),
                    error
            end;
        {error, _Code} ->
            ?D("unknown proto unpack mod: ~p~n", [_Code]),
            error
    end.


move(Socket, Direct) ->
    {X, Y, NewDirect} = step(Direct),
    send(Socket, 10115, {X, Y, 0}),
    timer:sleep(800),
    move(Socket, NewDirect).

step(Direct) ->
    X = case get(x) of
        undefined -> ?pos_x_left;
        _X -> _X
    end,
    XOffset = util:rand(0, 50),
    Y = util:rand(430, 480),
    case X + Direct * (XOffset + ?speed) of
        NewX when NewX >= ?pos_x_right ->
            put(x, ?pos_x_right),
            {?pos_x_right, Y, -Direct};
        NewX when NewX =< ?pos_x_left ->
            put(x, ?pos_x_left),
            {?pos_x_left, Y, -Direct};
        NewX ->
            put(x, NewX),
            {NewX, Y, Direct}
    end.

talk(Socket) ->
    spawn_link(fun()-> loop_talk(Socket) end).

loop_talk(Socket) ->
    send(Socket, 10910, {1, <<"新月世界好好玩好好玩">>}),
    timer:sleep(5000),
    loop_talk(Socket).
    
