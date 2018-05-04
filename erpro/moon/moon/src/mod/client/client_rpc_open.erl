%%----------------------------------------------------
%% 客户端登录处理
%% **注意**以下调用都是开放的，请注意安全性
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(client_rpc_open).
-export([handle/3]).
-include("common.hrl").
-include("conn.hrl").

-define(TIME_VALID, 120). %% Ticket有效时间，单位:秒

%% 处理game客户端登录
handle(1010, {Platform, Account, SrvId, Ts, Ticket, DeviceId}, Conn = #conn{ip = LoginIp, account = <<>>, type = game}) ->
    case is_blocked(log_conv:ip2bitstring(LoginIp)) of
        true -> 
            ?INFO("IP地址被封[Account:~s, SrvId:~s, LoginIp:~s]", [Account, SrvId, log_conv:ip2bitstring(LoginIp)]),
            {reply, {0, ?MSGID(<<"您的角色已被禁止登陆">>), 0, <<>>, 0}};
        false ->
            case auth_ticket(Platform, Account, SrvId, Ticket, Ts, LoginIp) of
                true ->
                    case account_mgr:is_binded({Account, Platform}) of  %% 被GM绑定帐号
                        true ->
                            {reply, {0, ?MSGID(<<"您的帐号已被锁定，请联系GM">>), 0, <<>>, 0}};
                        false ->
                            {Acc0, Platform0} = case account_mgr:get_binding({Account, Platform}) of %% GM绑定帐号
                                {PlayerAcc, PlayerPlatform} -> {PlayerAcc, PlayerPlatform};
                                _ -> {Account, Platform}
                            end,
                            ?INFO("帐号[~s:~s]绑定[~s:~s]登录~p", [Account, Platform, Acc0, Platform0, LoginIp]),
                            Acc1 = list_to_binary(string:to_lower(binary_to_list(Acc0))),  %% 转成小写
                            Acc = account_mgr:rename_lookup(Acc1, Platform0), %% 绑定帐号检查
                            case account_mgr:whereis(Acc, Platform0) of
                                ConnPid when is_pid(ConnPid) ->
                                   sys_conn:pack_send(ConnPid, 1024, {?disconn_login_conflict, <<>>}),
                                   timer:sleep(20),
                                   sys_conn:close(ConnPid);
                                _ -> ignore
                            end,
                            account_mgr:register(self(), Acc, Platform0),
                            InvCode = invitation:get_invitee_code(Acc, DeviceId),
                            GmCmd = is_gm_cmd_enabled(),
                            {reply, {1, ?MSG_NULL, util:unixtime(), InvCode, GmCmd}, Conn#conn{account = Acc, device_id = DeviceId, platform = Platform0}}
                    end;
                {false, ticket_timeout} -> %% ticket超时
                    {reply, {2, ?MSGID(<<"登录验证失败，请重试">>), 0, <<>>, 0}};
                {false, bad_ticket} -> %% ticket签名错误
                    {reply, {2, ?MSGID(<<"登录验证失败，请重试">>), 0, <<>>, 0}};
                {false, _Reason} ->
                    {reply, {2, ?MSGID(<<"登录验证失败，请重试">>), 0, <<>>, 0}}
            end
    end;

%% 接收心跳包
%handle(1099, _, #conn{account = Account}) ->
%    Now = util:unixtime(),
%    Diff = case get(last_heartbeat) of
%        0 -> 0;
%        Last -> abs(Now - Last - 20) 
%    end,
%    put(last_heartbeat, Now),
%    case Diff > 5 of
%        false ->
%            {reply, {}};
%        true ->
%            ?ERR("帐号[~s]的网络不稳定或者使用了加速器[Ping:~w Diff:~w]", [Account, Diff]),
%            %{stop, ?L(<<"网络不稳定，无法继续游戏，请重新登录。">>)}
%            {reply, {}}  %% 手机网络比较差，改为不踢人
%    end;
%% 手机网络比较差，改为不踢人
handle(1099, _, #conn{account = _Account}) ->
    Now = util:unixtime(),
    put(last_heartbeat, Now),
    {reply, {}};

handle(_Cmd, _Data, _Conn) ->
    {error, unknow_command}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 验证ticket
-ifdef(debug).
auth_ticket(_ClientType, _Account, _SrvId, _Ticket, _Ts, _Ip) -> true.
-else.
auth_ticket(ClientType, Account, SrvId, Ticket, Ts, Ip) ->
    case sys_env:get(ignore_auth_ticket) of
        true ->
            true;
        _ ->
            do_auth_ticket(ClientType, Account, SrvId, Ticket, Ts, Ip)
    end.

%% 215平台
do_auth_ticket(_ClientType, Account, SrvId, Ticket, Ts, Ip) ->
    ServerKey = util:server_key(SrvId),
    E = util:unixtime() - Ts,
    T = util:md5(lists:concat([binary_to_list(Account), Ts, ServerKey])),
    ?ERR("Acc:~s Ts:~w Ticket:~s T:~s E:~w time_valid:~w", [Account, Ts, Ticket, T, E, ?TIME_VALID]),
    case Ticket =:= T of
        true ->
            case E < ?TIME_VALID of
                true -> 
                    last_ip_cache:set_ip(Account, Ip),
                    true;
                false ->
                    case last_ip_cache:is_last_ip(Account, Ip) of
                        true -> true;
                        _ -> 
                            ?ERR("~s : ticket_timeout", [Account]),
                            {false, ticket_timeout}
                    end
            end;
        false ->
            ?ERR("~s : bad_ticket : remote = ~s : local = ~s : Ts = ~p", [Account, Ticket, T, Ts]),
            {false, bad_ticket}
    end.
-endif.


%% is_blocked(Ip) -> true | false
%% @doc 是否被封禁的IP
is_blocked(Ip) ->
    case catch ets:lookup(ip_block, Ip) of
        [{Ip}] -> true;
        [] -> false;
        _Err -> ?ERR("查询是否被封禁ip时发生错误:~w", [_Err]), false
    end.

-ifdef(debug).
is_gm_cmd_enabled() -> 1.
-else.
is_gm_cmd_enabled() ->
    case sys_env:get(is_gm_available) =:= 1 of
        true -> 1;
        _ -> 0
    end.
-endif.

