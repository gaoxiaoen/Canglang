%%----------------------------------------------------
%% 游戏客户端RPC处理
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(client_rpc_game).
-export([handle/3]).
-include("common.hrl").
-include("conn.hrl").
-include("link.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("mail.hrl").

-define(MAX_ROLE_NUM, 3).   %% 可创建角色的数量上限
-define(VALID_CAREER, [
                %?career_zhenwu,      %% 真武
                %% 职业代号
                ?career_cike,     %% 刺客
                ?career_xianzhe,     %% 贤者
                %?career_feiyu,       %% 飞羽
                ?career_qishi     %% 骑士
                %?career_xinshou     %% 新手
            ]
).        %% 没有职业



%% 获取角色列表
handle(1100, {_SrvId}, #conn{type = game, account = Account, platform = Platform}) ->
    %[PlatformPrefix | _T] = re:split(util:to_list(SrvId), "_", [{return, list}]),
    % Sql = "select id, srv_id, status, name, sex, lev, career from role where account=~s and SUBSTRING_INDEX(srv_id,  '_', 1 ) = ~s order by lev desc",
    Sql = "select id, srv_id, status, name, sex, lev, career from role where account=~s and platform = ~s and is_delete <> 1 order by lev desc",
    case db:get_all(Sql, [Account, Platform]) of
        {error, _Err} ->
            {reply, {?L(<<"获取角色列表失败，请稍后再试">>), 0,0,0,0,0,0,[]}};
        {ok, L} ->
            {_, Ck0, Ck1, Xj0, Xj1, Qs0, Qs1} = role_num_counter:lookup(),
            {reply, {<<>>, Ck0, Ck1, Xj0, Xj1, Qs0, Qs1, L}}
    end;

%% 创建角色
handle(1105, {Name, Sex, Career, TSrvId, RegCode}, #conn{type = game, ip = Ip, account = Account, device_id = DeviceId, platform = Platform}) ->
    case account_mgr:is_binded({Account, Platform}) of  %% 被GM绑定帐号
    true -> 
        {reply, {?false, ?MSGID(<<"帐号被锁定，不能创建角色">>)}};
    false ->
        Reply = case util:check_name2(Name) of
            {false, Msg} -> 
                {?false, Msg};
            ok ->
                case db:get_one("select count(*) from role where name = ~s", [Name]) of
                    {error, _Err} -> 
                        {?false, ?MSGID(<<"访问数据库时发生异常，请稍后再重试">>)};
                    {ok, Num} when Num >= 1 -> %% 已经存在同名的角色
                        {?false, ?MSGID(<<"角色名称已经被使用">>)};
                    {ok, _} ->
                        case role_api:is_name_used(Name) of
                            true ->
                                {?false, ?MSGID(<<"角色名称已经被使用">>)};
                            _ ->
                                case RegCode == <<>> orelse invitation:is_valid_code(Account, RegCode) of
                                    false ->
                                        {?false, ?MSGID(<<"您输入的邀请码不正确">>)};
                                    true -> 
                                        case is_valid_career(Career) of
                                            false ->
                                                {?false, ?MSGID(<<"职业不合法">>)};
                                            true ->
                                                %[PlatformPrefix | _T] = re:split(util:to_list(TSrvId), "_", [{return, list}]),
                                                case db:get_one("select count(*) from role where account=~s and platform = ~s and is_delete = 0", [Account, Platform]) of
                                                    {error, _Err} -> 
                                                        {?false, ?MSGID(<<"访问数据库时发生异常，请稍后再重试">>)};
                                                    {ok, N} when N >= ?MAX_ROLE_NUM -> %% 当前帐号创建的角色数据超过上限
                                                        {?false, ?MSGID(<<"创建失败，最多只能创建3个角色">>)};
                                                    {ok, N} ->
                                                        case get_srv_info(TSrvId) of
                                                            {ok, SrvId, Realm} ->
                                                                RegTime = util:unixtime(),
                                                                Sql = "insert into role (srv_id, platform, status, account, name, sex, career, realm, lev, hp, mp, reg_time, reg_ip, device_id, reg_code, `nth`) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
                                                                case db:execute(Sql, [SrvId, Platform, 0, Account, Name, Sex, Career, Realm, 0, 100, 100, RegTime, log_conv:ip2bitstring(Ip), DeviceId, RegCode, N + 1]) of
                                                                    {ok, 1} -> 
                                                                        case Platform of
                                                                            <<"renren">> ->
                                                                                http_callback(renren, Account, SrvId);
                                                                            _ -> ignore
                                                                        end,
                                                                        notice:send_interface({connpid, self()}, 8, Account, list_to_bitstring(SrvId), Name, <<"">>, []),
                                                                        RoleId = get_role_id(TSrvId, Account, Name),
                                                                        %封测奖励
                                                                        %award:send({RoleId, TSrvId}, 305000),
                                                                        % %%全服邮件
                                                                        % Content = <<"公测【不删档】赠送晶钻好礼！<br>只要在右下角的客服面板登记您的手机号码，我们将会在公测开启前向您的手机发送激活码。届时可以通过激活码在游戏内领取【非绑晶钻大礼包】！<br>P.S.非绑晶钻在公测后只能通过充值获得哦！<br>开发团队不会泄露您的任何隐私信息！<br>感谢您的支持！">>,
                                                                        % mail:send_system(0, {RoleId, TSrvId}, {<<"系统邮件">>, Content}),
                                                                        role_num_counter:update({Career, Sex, 1}),
                                                                        {RoleId, ?MSG_NULL};
                                                                    {ok, _M} ->
                                                                        ?ERR("创建角色插入数据库异常记录：~w", [_M]),
                                                                        {?true, ?MSG_NULL};
                                                                    _Error -> 
                                                                        ?ERR("创建角色插入数据库异常：~w", [_Error]),
                                                                        {?false, ?MSGID(<<"创建角色失败">>)}
                                                                end;
                                                            {false, _Reason} ->
                                                                ?ERR("发生错误：~p", [_Reason]),
                                                                {?false, ?MSGID(<<"创建角色失败ERROR-1">>)}
                                                        end
                                                end
                                        end
                                end
                        end
                end
        end,
        {reply, Reply}
    end;

%% 删除角色
handle(1110, {Rid, SrvId}, #conn{type = game, account = Account}) ->
    Sql = "select lev from role where id = ~s and srv_id = ~s and account = ~s",
    Args = [Rid, SrvId],
    case db:get_row(Sql, Args ++ [Account]) of
        {error, undefined} -> {reply, {?false, ?MSGID(<<"不存在的账号或角色">>)}};
        {error, Why} ->
            ?ERR("fetch_base时发生异常: ~s", [Why]),
            {reply, {?false, ?MSGID(<<"删除角色失败">>)}};
        {ok, [_Lev]} -> %%when Lev < 35 ->
            % case db:execute("delete from role where id = ~s and srv_id = ~s", Args) of
            case db:execute("update role set is_delete = ~s where id = ~s and srv_id = ~s and account = ~s", [1] ++ Args ++ [Account]) of
                {ok, 1} -> {reply, {?true, ?MSGID(<<"删除角色成功">>)}};
                _ -> {reply, {?false, ?MSGID(<<"删除角色失败">>)}}
            end;
        _ ->
            {reply, {?false, ?MSGID(<<"等级超过35的角色不能删除">>)}}

    end;

%% 登录指定角色
handle(1120, {_Rid, _SrvId}, #conn{type = game, pid_object = ObjectPid}) when ObjectPid =/= undefined ->
    {reply, {0, ?MSGID(<<"角色已经在线，不能重复登录">>)}}; %% 阻止重复登录
handle(1120, {Rid, SrvId}, Conn = #conn{type = game, account = Account, socket = Socket, ip = Ip, port = Port}) ->
    Link = #link{
        socket = Socket
        ,conn_pid = self()
        ,ip = Ip
        ,port = Port
    },
    case role_api:lookup(by_id, {Rid, SrvId}, [#role.pid, #role.account]) of
        {ok, _N, [Pid, Acc]} ->  % when Acc =:= Account -> %% 角色已经在线，且属于当前帐号
            case string:to_lower(binary_to_list(Acc)) =:= string:to_lower(binary_to_list(Account)) of
               true -> 
                  %role_switch(Pid, Link, Conn);
                  role:connect(Pid, Link, Conn),
                  {reply, {1, ?MSG_NULL}, Conn#conn{object = role, pid_object = Pid}};
               _->
                  {reply, {0, ?MSGID(<<"该角色和帐号不相匹配!">>)}}
            end;
        {error, not_found} -> %% 角色不在线
            role_login(Rid, SrvId, Link, Conn);
        _E ->
            ?ERR("角色[Rid:~w, SrvId:~s]登录失败: ~w", [Rid, SrvId, _E]),
            {reply, {0, ?MSGID(<<"该角色和帐号不相匹配">>)}}
    end;

handle(_Cmd, _Data, _Conn) ->
    {error, unknow_command}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 接管角色
%role_switch(Pid, Link, Conn) ->
%    case role:apply(sync, Pid, {fun fix_link/2, [Link]}) of
%        true -> {reply, {1, ?MSG_NULL}, Conn#conn{object = role, pid_object = Pid}};
%        _ -> {reply, {0, ?MSGID(<<"登录角色失败，请稍后重试">>)}}
%    end.

%% 角色登录
role_login(Rid, SrvId, Link, Conn = #conn{account = Account}) ->
    case role:create(Rid, SrvId, Account, Link) of
        {error, {already_started, Pid}} ->
            %?ERR("角色[Rid:~w, SrvId:~s]登录失败，原因: 该角色已经在线", [Rid, SrvId]),
            %{reply, {0, ?MSGID(<<"角色已经在线，不能重复登录">>)}};
            role:connect(Pid, Link, Conn),
            {reply, {1, ?MSG_NULL}, Conn#conn{object = role, pid_object = Pid}};
        {error, not_exists} ->
            ?ERR("无法加载不存在的角色[Account:~s, Rid:~w, SrvId:~s]", [Account, Rid, SrvId]),
            {reply, {0, ?MSGID(<<"无法加载不存在的角色">>)}};
        {error, Err} when is_binary(Err) orelse is_integer(Err) ->
            notice:alert(error, self(), Err),
            {reply, {0, ?MSG_NULL}};
        {error, Err} ->
            ?ERR("加载角色数据[Rid:~w, SrvId:~s]时发生异常: ~w", [Rid, SrvId, Err]),
            {reply, {0, ?MSGID(<<"加载角色数据时发生异常">>)}};
        {ok, Pid} ->
            %erlang:link(Pid),
            role:connect(Pid, Link, Conn),
            {reply, {1, ?MSG_NULL}, Conn#conn{object = role, pid_object = Pid}}
    end.

%% @spec fix_link(Role, NewLink) -> {ok, Reply, NewRole}
%% Role = #role{}
%% NewLink = #link{}
%% @doc 替换角色梆定的连接器(用户顶号操作)
%fix_link(Role = #role{link = #link{conn_pid = ConnPid}}, NewLink) ->
%    NewRole = Role#role{link = NewLink},
%    role_group:leave(all, Role),
%    role_group:join(all, NewRole),
%    erlang:unlink(ConnPid),
%    erlang:link(NewLink#link.conn_pid),
%    put(conn_pid, NewLink#link.conn_pid),
%    %% 清除disconnect的定时器，如果有的话
%    case get(ref_timer_disconnect) of
%        undefined -> ignore;
%        Ref -> erlang:cancel_timer(Ref)
%    end,
%    spawn(
%        fun() ->
%                sys_conn:pack_send(ConnPid, 10940, {2, ?MSG(<<"当前角色已经在别处登录，你被迫下线。">>)}),
%                util:sleep(500),
%                %% 强制关闭之前的连接器
%                erlang:exit(ConnPid, kill)
%        end
%    ),
%    {ok, true, role_listener:switch(NewRole)}.

%% 获取服务器标志及阵营信息
get_srv_info(TSrvId) ->
    case sys_env:get(srv_ids) of
        [] -> 
            SrvId = sys_env:get(srv_id),
            case util:to_list(TSrvId) =:= SrvId of
                true -> {ok, SrvId, 0};
                false -> 
                    ?DEBUG("非法服务器标识~s", [TSrvId]),
                    {false, ?L(<<"非法的服务标志符">>)}
            end;
        SrvList when is_list(SrvList) ->
            StrSrvId = util:to_list(TSrvId),
            case lists:member(StrSrvId, SrvList) of
                true ->
                    case sys_env:get(realm_a) of
                        _Any ->  {ok, StrSrvId, 0} %%暂时返回OK
                        %%[] -> {ok, StrSrvId, 0};
                        %%RealmA ->
                        %%    ?DEBUG("{{{{{{  sys_env:get(realm_a) of : ~p~n", [RealmA]),
                        %%    RealmB = sys_env:get(realm_b),
                        %%    case lists:member(StrSrvId, RealmA) of
                        %%        true -> {ok, StrSrvId, ?role_realm_a};
                        %%        false ->
                        %%            case lists:member(StrSrvId, RealmB) of
                        %%                true -> {ok, StrSrvId, ?role_realm_b};
                        %%                false -> {false, ?L(<<"服务器阵营信息有误">>)}
                        %%            end
                        %%    end
                    end;
                false -> {false, ?L(<<"缺少srv_ids">>)}
            end;
        _ -> {false, ?L(<<"缺少srv_ids">>)}
    end.

%% 回调
http_callback(taiwan, Account, SrvId) ->
    inets:start(),
    [SrvSn | _T] = lists:reverse(re:split(util:to_list(SrvId), "_", [{return, list}])),
    ServerUrl = "fc" ++ SrvSn ++ ".cmwebgame.com",
    Md5 = util:md5(lists:concat(["@@!#$cmwebgame8#$DE", util:to_list(Account), ServerUrl])),
    Url = "http://main.cmwebgame.com/api/loggame.shtml?user_account=" ++ util:to_list(Account) ++ "&serverurl=" ++ ServerUrl ++ "&hash=" ++ util:to_list(Md5),
    %% catch ?INFO("create role callbak url:~s", [Url]),
    catch httpc:request(Url);
http_callback(taiwanxmfx, Account, SrvId) ->
    inets:start(),
    [SrvSn | _T] = lists:reverse(re:split(util:to_list(SrvId), "_", [{return, list}])),
    ServerUrl = "kfc" ++ SrvSn ++ ".cmwebgame.com",
    Md5 = util:md5(lists:concat(["@@!#$cmwebgame8#$DE", util:to_list(Account), ServerUrl])),
    Url = "http://main.cmwebgame.com/api/loggame.shtml?user_account=" ++ util:to_list(Account) ++ "&serverurl=" ++ ServerUrl ++ "&hash=" ++ util:to_list(Md5),
    %% catch ?INFO("create role callbak url:~s", [Url]),
    catch httpc:request(Url);
http_callback(renren, Account, SrvId) ->
    inets:start(),
    case sys_env:get(host) of
        undefined -> ignore;
        Host when is_list(Host) andalso length(Host) > 0 ->
            RRSql = "select id from role where account = ~s and srv_id = ~s",
            case db:get_one(RRSql, [Account, SrvId]) of
                {ok, RoleId} ->
                    Url = "http://" ++ Host ++ "/api/renren/addrolereport.php?role_id=" ++ util:to_list(RoleId) ++ "&srv_id=" ++ SrvId,
                    catch httpc:request(Url);
                _ -> ignore
            end;
        _ -> ignore
    end.

is_valid_career(Career) when is_integer(Career) ->
    case lists:member(Career, ?VALID_CAREER) of
        true -> true;
        false -> false
    end;
is_valid_career(_Career) -> false.

%% 获取角色Id
get_role_id(SrvId, Account, Name) ->
    Sql = "select id from role where srv_id = ~s and account=~s and name = ~s",
    case db:get_all(Sql, [SrvId, Account, Name]) of
        {error, _Err} ->
            0;
        {ok, []} ->
            0;
        {ok, [RidList]} ->
            [Rid] = RidList,
            Rid
    end.


