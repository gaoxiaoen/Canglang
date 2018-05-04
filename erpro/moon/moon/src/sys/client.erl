%%----------------------------------------------------
%% client
%% 
%% @author Qingxuan
%%----------------------------------------------------
-module(client).
-compile(export_all).

-define(TCP_OPTS, [binary, {active, false}, {packet, 0}, {nodelay, false}, {delay_send, true}, {exit_on_close, false}]).

%-define(D(F,A), io:format(F++"\n", A)).
%-define(D(S), io:format(S++"\n")).
-define(D(F,A), ignore).
-define(D(S), ignore).

-define(I(F,A), io:format(F++"\n", A)).
-define(I(S), io:format(S++"\n")).

-define(capital_map_id, 1400).      %% 主城地图id
-define(capital_map_id2, 1405).
-define(capital_map_id3, 1410).
-define(capital_map_id4, 1415).
-define(capital_map_id5, 1420).

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
%-define(DEF_HOST, "114.112.100.101").
%-define(DEF_HOST, "114.112.100.101").
%-define(DEF_HOST, "119.147.112.6").
-define(DEF_HOST, "203.195.201.237").
-define(DEF_PORT, 8010).
-define(DEF_INTERVAL, 500).
%-define(srv_id, <<"215_10040">>).
-define(srv_id, <<"215_10004">>).
-define(pos_x_left, 535).
-define(pos_x_right, 3139).
-define(speed, 70).

start(FromAccId, ToAccId) ->
    start(FromAccId, ToAccId, ?DEF_HOST, ?DEF_PORT, ?DEF_INTERVAL).

start(FromAccId, ToAccId, Port) ->
    start(FromAccId, ToAccId, ?DEF_HOST, Port, ?DEF_INTERVAL).

start(FromAccId, ToAccId, Host, Port, Interval) when FromAccId=<ToAccId ->
    AccName = list_to_binary("tacc_"++integer_to_list(FromAccId)),
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
    ok = send(Sock, 1010, {AccName, ?srv_id, util:unixtime(), <<>>, <<>>}),
    timer:send_interval(20000, Pid, heartbeat),
    ok.

%% 接收消息
base_recv_loop(Socket, Acc) ->
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
            Acc1 = case recv(Cmd, {}, Acc) of
                {Cmd1, Bin1, Acc0} -> 
                    send(Socket, Cmd1, Bin1),
                    Acc0;
                _ -> Acc
            end,
            base_recv_loop(Socket, Acc1);
        {Cmd, Bin} ->
            ?D("recv: ~p ~p~n", [Cmd, Bin]),
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

recv(1010, _Bin = {Status, MsgId, _Time, _Code}, Acc) ->
    ?I("1010 ~p ~p", [Status, MsgId]),
    {1100, {?srv_id}, Acc};

recv(1100, {_Msg, _Ck0, _Ck1, _Xz0, _Xz1, _Qs0, _Qs1, RoleL}, Acc) ->
    case RoleL of
        [] -> 
            Sex = util:rand(0, 1),
            CareerIndex = util:rand(1, 3),
            Career = lists:nth(CareerIndex, [2, 3, 5]),
            {1105, {Acc#acc.acc_name, Sex, Career, ?srv_id, <<>>}, Acc};
        [[RoleId, _SrvId, _Status, _Name, _Sex, _Lev, _Career]|_] ->
            {1120, {RoleId, ?srv_id}, Acc}
    end;

recv(1105, {RoleId, _MsgId}, Acc) ->
    {1120, {RoleId, ?srv_id}, Acc};

recv(1120, {Code, _MsgId}, Acc) ->
    case Code of
        1 -> 
            {10100, {0, 0}, Acc};
        _ ->
            ?D("~p : ~p", [Code, i18n:text(_MsgId)]),
            ok
    end;

recv(10110, {Map, _, _}, Acc) ->
    put(map, Map),
    {10111, {}, Acc};

recv(10111, _, Acc = #acc{socket = Socket}) ->
    case get(map) of
        120 ->
            send(Socket, 9910, {<<"stat">>}),
            Maps = [?capital_map_id, ?capital_map_id2, ?capital_map_id3, ?capital_map_id4, ?capital_map_id5],
            MapId = util:rand(1, length(Maps)),
            {10101, {MapId}, Acc};
        MapId when MapId =:= ?capital_map_id
            orelse MapId =:= ?capital_map_id2
            orelse MapId =:= ?capital_map_id3
            orelse MapId =:= ?capital_map_id4
            orelse MapId =:= ?capital_map_id5 ->
            spawn(fun()->
                %talk(Acc#acc.socket),
                move(Acc#acc.socket, 1)
            end);
        _ ->
            ok
    end;

recv(_Cmd, _Data, _Acc) ->
    ?D("recv unknown: ~p ~p", [_Cmd, _Data]),
    noreply.

send(Socket, Bin) when is_binary(Bin) ->
    gen_tcp:send(Socket, Bin).
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
    Y = util:rand(400, 600),
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

%talk(_Socket) ->
%    spawn_link(fun()-> loop_talk(Socket) end).

%loop_talk(Socket) ->
%    send(Socket, 10910, {1, <<"新月世界好好玩好好玩">>}),
%    timer:sleep(5000),
%    loop_talk(Socket).
    
