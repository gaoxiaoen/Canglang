%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2015 下午7:00
%%%-------------------------------------------------------------------
-module(player_login).
-author("fancy").
-include("server.hrl").
-include("common.hrl").
%% API
-export([handle/3, server_stop_all/0, check_name/2, kickout_all/0,stop_by_pkey/1,check_reboot_warning/1]).

handle(10000, Client, {Ts, Accname, Pf, Ticket}) ->
    Now = util:unixtime(),
    if Accname == "" ->
        {ok, BinData} = pt_100:write(10000, {0, Now}),
        server_send:send_one(Client#client.socket, BinData),
        {ok, Client};
        true ->
            case check_login_limit() of
                true ->
                    case is_bad_pass({Ts, Accname, Pf, Ticket}) of
                        true ->
                            IP = util:get_ip(Client#client.socket),
                            Pkey = ?EMPTY_DEFAULT(player_load:dbget_player_key_by_accname(Accname, Pf, version:get_lan_config()), []),
                            Code = ?IF_ELSE(Pkey == [], 4, 1),
                            ?IF_ELSE(Code == 4, online_queue_proc:delete(Accname), skip),
                            {ok, BinData} = pt_100:write(10000, {Code, Now}),
                            server_send:send_one(Client#client.socket, BinData),
                            {ok, Client#client{login = 1, accname = Accname, ip = IP, pf = Pf}};
                        false ->
                            {ok, BinData} = pt_100:write(10000, {3, Now}),
                            server_send:send_one(Client#client.socket, BinData),
                            {ok, Client}
                    end;
                false ->
                    {ok, BinData} = pt_100:write(10000, {2, Now}),
                    server_send:send_one(Client#client.socket, BinData),
                    {ok, Client}
            end
    end;


%%退出当前角色
handle(10001, _Client, _) ->
    ok;

%%获取角色列表
handle(10002, Client, {}) when Client#client.login == 1 ->
    PlayerList = player_load:dbget_player_list(Client#client.accname, Client#client.pf, version:get_lan_config()),
    F = fun(Item) ->
        Sn = lists:last(Item),
        Item ++ [config:get_server_name(Sn)]
        end,
    PlayerList1 = lists:map(F, PlayerList),
    {ok, Bin} = pt_100:write(10002, {PlayerList1}),
    server_send:send_one(Client#client.socket, Bin),
    ok;

%%注册角色
handle(10003, Client, {Career, Sex, Name, Source, Pf, PhoneID, OS, GameChannelId, GameId})
    when is_list(Client#client.accname) andalso is_list(Name) andalso Client#client.login == 1 ->
    try
        IP = Client#client.ip,
        Accname = Client#client.accname,
        case check_name(Source, Name) of
            {false, Code} ->
                throw({fail, Code});
            {true, NameList} ->
                case player_load:create_role(Accname, NameList, Career, Sex, IP, Source, Pf, PhoneID, OS, GameChannelId, GameId) of
                    {err, _} ->
                        throw({fail, 0});
                    {ok, Pkey} ->
                        {ok, Bin} = pt_100:write(10003, {1, Pkey}),
                        server_send:send_one(Client#client.socket, Bin)
                end
        end
    catch
        _:{fail, Code2} ->
            {ok, Bin2} = pt_100:write(10003, {Code2, 0}),
            server_send:send_one(Client#client.socket, Bin2);
        _:_Err ->
            ?ERR("create err:~p~n", [_Err]),
            {ok, Bin3} = pt_100:write(10003, {5, 0}),
            server_send:send_one(Client#client.socket, Bin3)
    end;

%%进入游戏
handle(10004, Client, {Pkey, Time, Ticket, LoginFlag}) when Client#client.login == 1 ->
    try
        case check_char_encrypt(Pkey, Time, Ticket) of
            true ->
                case player_init:check_login_time(Pkey) of
                    false -> throw({fail, 8});
                    true ->
                        {ok, Pid} = do_login_action(Pkey, Client#client.pf, Client#client.accname, Client#client.socket, Client#client.ip, LoginFlag),
                        {ok, Bin} = pt_100:write(10004, {1}),
                        server_send:send_one(Client#client.socket, Bin),
                        {ok, Client#client{pid = Pid}}
                end;
            false ->
                throw({fail, 3})
        end
    catch
        _:{fail, Code2} ->
            {ok, Bin2} = pt_100:write(10004, {Code2}),
            server_send:send_one(Client#client.socket, Bin2),
            {error, Code2};
        _:_ERR ->
            {ok, Bin3} = pt_100:write(10004, {0}),
            server_send:send_one(Client#client.socket, Bin3),
            ?ERR("login err:~p~n", [_ERR]),
            {error, _ERR}
    end;

%%心跳
handle(10009, Client, _) ->
    Now = util:unixtime(),
    case get(?HEARTBEAT) of
        undefined ->
            put(?HEARTBEAT, Now),
            put(?HEARTBEAT_SPEEDUP, 0);
        LastTime ->
            SpeedUp = get(?HEARTBEAT_SPEEDUP),
            SpeedUp2 = ?IF_ELSE(Now - LastTime < 5, SpeedUp + 1, max(0, SpeedUp - 1)),
            put(?HEARTBEAT, Now),
            put(?HEARTBEAT_SPEEDUP, SpeedUp2),
            if
                SpeedUp2 >= 20 ->
                    {ok, BinSpeed} = pt_100:write(10008, {8, 1}),
                    server_send:send_one(Client#client.socket, BinSpeed),
                    Self = self(),
                    spawn(fun() ->
                        util:sleep(1000),
                        ?CAST(Self, stop)
                          end);
                true ->
                    ok
            end

    end,
    {ok, Bin} = pt_100:write(10009, {Now}),
    server_send:send_one(Client#client.socket, Bin),
    ok;

%% 获取登陆排队信息
handle(10010, Client, {Accname, Pf}) ->
    Pkey = ?EMPTY_DEFAULT(player_load:dbget_player_key_by_accname(Accname, Pf, version:get_lan_config()), []),
    Ver = version:get_lan_config(),
    if
        Ver /= vietnam ->
            {ok, Bin} = pt_100:write(10010, {0, 1}),
            server_send:send_one(Client#client.socket, Bin); %% 非越南玩家直接放行
        Pkey /= [] ->
            {ok, Bin} = pt_100:write(10010, {0, 1}),
            server_send:send_one(Client#client.socket, Bin); %% 老玩家直接放行
        true ->
            online_queue_proc:get_token(Accname, Client)
    end;

%% sdk 协议
handle(10101, Client, {Uid, SessionId, ChannelId}) ->
    Pf = util:to_integer(ChannelId),
    Now = util:unixtime(),
    case check_login_limit() of
        true ->
            case login_junhai:login([Uid, SessionId, ChannelId, 39]) of
                [1, Accname, JSON] ->
                    IP = util:get_ip(Client#client.socket),
                    Pkey = ?EMPTY_DEFAULT(player_load:dbget_player_key_by_accname(Accname, Pf, version:get_lan_config()), []),
                    Code = ?IF_ELSE(Pkey == [], 4, 1),
                    {ok, BinData} = pt_101:write(10101, {Code, Now, Accname, JSON}),
                    server_send:send_one(Client#client.socket, BinData),
                    {ok, Client#client{login = 1, accname = Accname, ip = IP, pf = Pf}};
                [_Code, Accname, JSON] ->
                    {ok, BinData} = pt_101:write(10101, {0, Now, Accname, JSON}),
                    server_send:send_one(Client#client.socket, BinData),
                    {ok, Client};
                _ ->
                    {ok, BinData} = pt_101:write(10101, {0, Now, "", ""}),
                    server_send:send_one(Client#client.socket, BinData),
                    {ok, Client}
            end;
        false ->
            {ok, BinData} = pt_101:write(10101, {2, Now, "", ""}),
            server_send:send_one(Client#client.socket, BinData),
            {ok, Client}
    end;

%%正版
handle(10102, Client, {Appkey, AuthorizeCode, ChannelId}) ->
    Pf = util:to_integer(ChannelId),
    Now = util:unixtime(),
    case login_junhai:login2([Appkey, AuthorizeCode, ChannelId]) of
        [1, Accname, Token] ->
            IP = util:get_ip(Client#client.socket),
            Pkey = ?EMPTY_DEFAULT(player_load:dbget_player_key_by_accname(Accname, Pf, version:get_lan_config()), []),
            Code = ?IF_ELSE(Pkey == [], 4, 1),
            {ok, BinData} = pt_101:write(10102, {Code, Now, Accname, Token}),
            server_send:send_one(Client#client.socket, BinData),
            {ok, Client#client{login = 1, accname = Accname, ip = IP, pf = Pf}};
        [_Code, Accname, Token] ->
            {ok, BinData} = pt_101:write(10102, {0, Now, Accname, Token}),
            server_send:send_one(Client#client.socket, BinData),
            {ok, Client};
        _ ->
            {ok, BinData} = pt_101:write(10102, {0, Now, "", ""}),
            server_send:send_one(Client#client.socket, BinData),
            {ok, Client}
    end;


handle(_Cmd, _Status, _Data) ->
    {error, "no match"}.


do_login_action(Pkey, Pf, Accname, Socket, IP, LoginFlag) ->
    case player_load:dbget_player_ass_by_idpf(Pkey) of
        [DataAccname, Sn, Status] ->
            case string:to_lower(util:to_list(DataAccname)) == string:to_lower(Accname) of
                true ->
                    case Status of
                        0 ->
                            case check_duplicate_login(Pkey) of
                                ok ->
                                    case player:start([Pkey, Sn, Pf, Socket, IP, LoginFlag]) of
                                        {'EXIT', _Error} ->
                                            ?ERR("login start error:~p~n", [_Error]),
                                            throw({fail, 14});
                                        {ok, Pid} ->
                                            %%?PRINT("login success ~n"),
                                            {ok, Pid}
                                    end;
                                _R ->
                                    ?ERR("check_duplicate_login _R ~w===========", [_R]),
                                    throw({fail, 14})
                            end;
                        _ ->
                            throw({fail, 11}) %%封号状态码
                    end;
                false ->
                    throw({fail, 15}) %%账号不一致
            end;
        _ ->
            throw({fail, 16}) %%玩家ID不存在
    end.

%%检查用户是否登陆了
check_duplicate_login(Id) ->
    case player_util:get_player_pid(Id) of
        false ->
            ok;
        Pid ->
            do_duplicate_login(Id, Pid),
            check_duplicate_login2(Id, Pid)
    end.


do_duplicate_login(_Pkey, Pid) ->
    {ok, Bin} = pt_100:write(10008, {10, 1}),
    server_send:send_to_pid(Pid, Bin),
    util:sleep(1000),
    case misc:is_process_alive(Pid) of
        true ->
            player:stop(Pid);
        false ->
            skip
    end.



-define(STOP_PID_TIME(Id), {stop_pid_time, Id}).
check_duplicate_login2(Id, Pid) ->
    util:wait_stop(Pid),
    util:sleep(1000),
    case misc:is_process_alive(Pid) of
        true ->
            N = ?GLOBAL_DATA_RAM:get(?STOP_PID_TIME(Id), 0),
            ?WARNING("Stop Id:~w,Pid:~w fail,Time:~w~n", [Id, Pid, N]),
            case N >= 1 of
                true ->
                    CurrentFun = erlang:process_info(Pid, current_function),
                    CurrentFun2 = util:term_to_string(CurrentFun),
                    Content = lists:concat(["UserId:", Id, CurrentFun2]),
                    erlang:exit(Pid, kill),
                    ?GLOBAL_DATA_RAM:del(?STOP_PID_TIME(Id)),
                    ?ERR("login fail:~w~n", [Content]),
                    ok;
                false ->
                    ?GLOBAL_DATA_RAM:set(?STOP_PID_TIME(Id), N + 1),
                    error
            end;
        false ->
            ?GLOBAL_DATA_RAM:del(?STOP_PID_TIME(Id)),
            ok
    end.


%% 角色名合法性检测
check_name(Source, Name) ->
    if
        Source == "robot" ->
            {true, Name};
        true ->
            validate_name(len, Name)
    end.

validate_name(len, Name) ->
    Len = util:char_len(xmerl_ucs:to_unicode(Name, 'utf-8')),
    {Min, Max} = version:get_name_len(),
    case Len =< Max andalso Len >= Min of
        true ->
            validate_name(utf8, Name);
        false ->
            {false, 6}
    end;

validate_name(utf8, Name) ->
    case util:filter_utf8(Name) of
        [] ->
            {false, 5};
        Name -> validate_name(digital, Name);
        _NameList ->
            {false, 5}
    end;

validate_name(digital, Name) ->
    Name1 = re:replace(Name, "(^\\s+)|(\\s+$)", "", [global, {return, list}]),
    Name2 = re:replace(Name1, "\\.", "", [global, {return, list}]),
    Name3 = re:replace(Name2, "\\-", "", [global, {return, list}]),
    case catch list_to_integer(Name3) of
        Int when is_integer(Int) ->
            {false, 5};
        _ ->
            validate_name(keyword, Name3)
    end;

validate_name(keyword, Name) ->
    case util:check_keyword(Name) of
        false ->
            validate_name(existed, Name);
        _err ->
            {false, 9}
    end;

validate_name(existed, Name) ->
    FQKEY = {?PROC_GLOBAL_REG_REQUEST, Name},
    Now = util:unixtime(),
    case get(FQKEY) of
        undefined ->
            NamePass = true;
        LastTime ->
            if
                Now - LastTime >= 2 ->
                    NamePass = true;
                true ->
                    NamePass = false
            end
    end,
    if
        NamePass ->
            case player_load:dbget_name_key(Name) of
                [] ->
                    ?IF_ELSE(version:get_name_unique(), validate_name(global_unique, Name), {true, Name});
                _ ->
                    put(FQKEY, Now),
                    %角色名称已经被使用
                    {false, 7}
            end;
        true ->
            {false, 8}
    end;

%%全服唯一检查 国内不使用
validate_name(global_unique, Name) ->
    Query = io_lib:format("~s/rename.php?name=~s", [config:get_api_url(), Name]),
    Query2 = unicode:characters_to_list(Query, unicode),
    Result = httpc:request(get, {Query2, []}, [{timeout, 2000}], []),
    case Result of
        {ok, {_, _, Body}} ->
            if
                Body == "1" ->
                    {true, Name};
                true ->
                    {false, 7}
            end;
        _ ->
            {false, 8}

    end;


validate_name(_, _Name) ->
    {false, 0}.


is_bad_pass({Ts, Accname, Pf, Ticket}) ->
    TICKET = config:get_ticket(),
    Hex = util:md5(lists:concat([Accname, Pf, Ts, TICKET])),
    Hex =:= Ticket.

%% 字符加密
check_char_encrypt(Pkey, Tstamp, TK) ->
    TICKET = config:get_ticket(),
    Hex = util:md5(lists:concat([Pkey, Tstamp, TICKET])),
    Hex =:= TK.


%%服务器维护
server_stop_all() ->
    OnlinePlayer = ets:tab2list(?ETS_ONLINE),
    {ok, Bin} = pt_100:write(10008, {12, 1}),
    F = fun(Online) ->
        Pid = Online#ets_online.pid,
        server_send:send_to_pid(Pid, Bin)
        end,
    lists:foreach(F, OnlinePlayer),
    timer:sleep(1000),
    F1 = fun(#ets_online{pid = Pid} = _Online) ->
        ?CALL(Pid, stop)
         end,
    lists:foreach(F1, OnlinePlayer).

%%系统踢人
kickout_all() ->
    OnlinePlayer = ets:tab2list(?ETS_ONLINE),
    {ok, Bin} = pt_100:write(10008, {13, 1}),
    F = fun(Online) ->
        Pid = Online#ets_online.pid,
        server_send:send_to_pid(Pid, Bin)
        end,
    lists:foreach(F, OnlinePlayer),
    timer:sleep(1000),
    F1 = fun(#ets_online{pid = Pid} = _Online) ->
        ?CALL(Pid, stop)
         end,
    lists:foreach(F1, OnlinePlayer).



check_login_limit() ->
    ServerId = config:get_server_num(),
    case lists:member(ServerId, []) of
        true ->
            OnlineNum = ets:info(?ETS_ONLINE, size),
            if
                OnlineNum >= 200 ->
                    false;
                true ->
                    true
            end;
        false ->
            case not config:is_debug() andalso (config:get_start_time() + 30 > util:unixtime()) of
                true ->
                    false;
                false ->
                    true
            end
    end.

stop_by_pkey(KeyList) when is_list(KeyList) ->
    lists:foreach(fun(PKey) -> stop_by_pkey(PKey) end, KeyList);
stop_by_pkey(Pkey) ->
    case player_util:get_player_pid(Pkey) of
        false -> skip;
        Pid ->
            {ok, Bin} = pt_100:write(10008, {17, 1}),
            server_send:send_to_pid(Pid, Bin),
            timer:sleep(1000),
            ?CALL(Pid, stop)
    end.

check_reboot_warning(Player) ->
    case config:is_debug() of
        false -> skip;
        true ->
            case cache:get(reboot_warning) of
                true ->
                    {ok, Bin} = pt_100:write(10011, {1}),
                    server_send:send_to_sid(Player#player.sid,Bin),
                    ok;
                _ -> skip
            end
    end.