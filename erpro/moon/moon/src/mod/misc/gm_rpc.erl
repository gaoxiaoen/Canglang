%% --------------------------------------------------------------------
%% GM相关功能
%% --------------------------------------------------------------------
-module(gm_rpc).

-export([
        handle/3
%%      ,test/0
%%      ,test1/0
        ,modify_role_lock_status/2
        ,check_role_lock/2
        ,role_login_check/2
        ,insert_gm_log/7
    ]).

%% include file
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").

%% 
-define(gm_feedback_ok, ?L(<<"亲，非常感谢您宝贵的意见!">>)).
-define(gm_feedback_fail, ?L(<<"非常抱歉，您的意见提交失败，请再试一次">>)).
-define(gm_kick_fail, ?L(<<"只有GM才能执行该操作">>)).
-define(gm_role_free, 0). %%解封
-define(gm_role_lock, 1). %%封号
-define(gm_role_silent, 2). %%禁言
-define(gm_role_lock_and_silent, 3).%%封号+禁言
-define(gm_api_base_url, "http://games.yeahworld.com").  %% gm接口基础url

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% 玩家反馈
handle(14501, {_Type, _Phone, _QQ, <<"">>}, _Role = #role{link = #link{conn_pid = ConnPid}}) ->
    notice:alert(error,ConnPid,?L(<<"亲，意见内容不能为空哦">>)),
    {ok};
handle(14501, {Type, Phone, QQ, Content}, _Role = #role{link = #link{conn_pid = ConnPid}, id = {RoleId, SrvId}, name = RoleName, platform = Platform, account = Account}) ->
%    case do_save_feedback({Type, Phone, QQ, Content}, Role) of
%        ok ->
%            notice:alert(succ, ConnPid, ?gm_feedback_ok),
%            {reply, {1}};
%        _ ->
%            notice:alert(error, ConnPid, ?gm_feedback_fail),
%            {reply, {0}}
%    end;
    Url = case Type of
        1 -> ?gm_api_base_url ++ "/dc/auth/report/bug.html";
        _ -> ?gm_api_base_url ++ "/dc/auth/report/suggest.html"
    end,
    Account1 = util:urlencode(Account),
    RoleName1 = util:urlencode(RoleName),
    Content1 = util:urlencode(Content),
    Phone1 = util:urlencode(Phone),
    QQ1 = util:urlencode(QQ),
    Post = list_to_binary(io_lib:format("gid=moon&sid=~s&username=~s&role_id=~p&rolename=~s&content=~s&tel=~s&qq=~s&platform=~s", [SrvId, Account1, RoleId, RoleName1, Content1, Phone1, QQ1, Platform])),
    ?DEBUG("~s", [Post]),
    Request = {Url, [], "application/x-www-form-urlencoded", Post},
    case httpc:request(post, Request, [{timeout, 5000}], [{sync, true}]) of
        {ok, {_Status, _Header, Body}} ->
            ?DEBUG("~ts", [Body]),
            case rfc4627:decode(Body) of
                {ok, {obj, Obj}, _} ->
                    case lists:keyfind("error_code", 1, Obj) of
                        {"error_code", ErrCode} when ErrCode=:=200 orelse ErrCode =:= <<"200">> ->
                            notice:alert(succ, ConnPid, ?gm_feedback_ok),
                            {reply, {?true}};
                        _ ->
                            ?ERR("json:decode ~p", [Obj]),
                            notice:alert(error, ConnPid, ?gm_feedback_fail),
                            {reply, {?false}}
                    end;
                JsonResult ->
                    ?ERR("json:decode ~p", [JsonResult]),
                    notice:alert(error, ConnPid, ?gm_feedback_fail),
                    {reply, {?false}}
            end;
        {error, _Reason} ->
            ?ERR("request: ~p", [_Reason]),
            notice:alert(error, ConnPid, ?gm_feedback_fail),
            {reply, {?false}}
    end; 

%% 踢玩家下线
handle(14502, {RoleId, SrvId, Msg}, Role) ->
    case do_kick_role(Role, RoleId, SrvId, Msg) of
        {ok} ->
            {reply, {?true, <<>>}};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;

%% 禁言
handle(14503, {Rid, SrvId, 0, Flag, Msg}, Role) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _, #role{name = Name, pid = RolePid}} ->
            case do_silent_role({RolePid, Rid, SrvId}, 2, 0, Flag, Msg, Role) of
                ok -> 
                    {reply, {?true, util:fbin(?L(<<"~s已被禁言">>), [Name])}};
                false -> {reply, {?false, ?L(<<"禁言失败">>)}}
            end;
        _ -> {reply, {?false, ?L(<<"玩家不在线,禁言请到后台进行操作">>)}} 
    end;

handle(14503, {Rid, SrvId, Time, Flag, Msg}, Role) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _, #role{name = Name, pid = RolePid}} ->
            case do_silent_role({RolePid, Rid, SrvId}, 1, Time, Flag, Msg, Role) of
                ok ->
                    {reply, {?true, util:fbin(?L(<<"~s已被禁言">>), [Name])}};
                false -> {reply, {?false, ?L(<<"禁言失败">>)}}
            end;
        _ -> {reply, {?false, ?L(<<"玩家不在线,禁言请到后台进行操作">>)}} 
    end;

%% 封号
handle(14504, {Rid, SrvId, 0, Msg}, Role) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _, #role{name = Name, pid = RolePid}} ->
            case do_lock_role({RolePid, Rid, SrvId}, 2, 0, Msg, Role) of
                ok -> {reply, {?true, util:fbin(?L(<<"~s已被封号">>), [Name])}};
                false -> {reply, {?false, ?L(<<"封号失败">>)}};
                ignore -> {ok}
            end;
        _ -> {reply, {?false, ?L(<<"玩家不在线,封号请到后台进行操作">>)}} 
    end;

handle(14504, {Rid, SrvId, Time, Msg}, Role) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _, #role{name = Name, pid = RolePid}} ->
            case do_lock_role({RolePid, Rid, SrvId}, 1, Time, Msg, Role) of
                ok -> {reply, {?true, util:fbin(?L(<<"~s已被封号">>), [Name])}};
                false -> {reply, {?false, ?L(<<"封号失败">>)}};
                ignore -> {ok}
            end;
        _ -> {reply, {?false, ?L(<<"玩家不在线,封号请到后台进行操作">>)}} 
    end;

%% 封IP
handle(14505, {Rid, SrvId, Msg}, Role) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _, #role{name = Name, link = #link{ip = LoginIp}}} ->
            case do_block_ip(LoginIp, Msg, Role) of
                ok -> 
                    case do_kick_role(Role, Rid, SrvId, Msg) of
                        {ok} ->
                            {reply, {?true, util:fbin(?L(<<"~s的登陆IP已被封且已踢下线">>), [Name])}};
                        {false, _Reason} ->
                            {reply, {?true, util:fbin(?L(<<"~s的登陆IP已被封但踢下线时失败">>), [Name])}}
                    end;
                false -> {reply, {?false, ?L(<<"封IP失败">>)}};
                ignore -> {ok}
            end;
        _ -> {reply, {?false, ?L(<<"玩家不在线,封IP请到后台进行操作">>)}} 
    end;

%% 客服系统：发送
handle(14506, {Msg}, _Role = #role{id = {RoleId, SrvId}, account = Account, name = RoleName, platform = Platform}) ->
    Url = ?gm_api_base_url ++ "/auth/feedback/post.html",
    %Url = "http://xysj.duoku.com/auth/feedback/post.html",
    %Url = "http://s0.moon.yeahworld.com/x.php",
    Account1 = util:urlencode(Account),
    RoleName1 = util:urlencode(RoleName),
    Msg1 = util:urlencode(Msg),
    Post = list_to_binary(io_lib:format("gid=moon&sid=~s&qid=~s&format=jsonEncode&role_id=~p&rolename=~s&time=~p&msg=~s&is_client=1&platform=~s", [SrvId, Account1, RoleId, RoleName1, util:unixtime(), Msg1, Platform])),
    ?DEBUG("~s", [Post]),
    Request = {Url, [], "application/x-www-form-urlencoded", Post},
    case httpc:request(post, Request, [{timeout, 5000}], [{sync, true}]) of
        {ok, {_Status, _Header, Body}} ->
            ?DEBUG("~ts", [Body]),
            case rfc4627:decode(Body) of
                {ok, {obj, Obj}, _} ->
                    case lists:keyfind("state", 1, Obj) of
                        {"state", State} when State=:=1 orelse State =:= <<"1">> ->
                            {reply, {?true}};
                        _ ->
                            ?ERR("json:decode ~p", [Obj]),
                            {reply, {?false}}
                    end;
                JsonResult ->
                    ?ERR("json:decode ~p", [JsonResult]),
                    {reply, {?false}}
            end;
        {error, _Reason} ->
            ?ERR("request: ~p", [_Reason]),
            {reply, {?false}}
    end;    

%% 客服系统：新消息
handle(14507, {}, Role = #role{}) ->
    gm_adm:push_unread_msg(Role),
    {noreply};
%    Url = "http://games.yeahworld.com/auth/feedback/get_reply.html",
%    Account1 = util:urlencode(Account),
%    RoleName1 = util:urlencode(RoleName),
%    Post = list_to_binary(io_lib:format("gid=moon&sid=~s&qid=~s&format=json&role_id=~p&rolename=~s&time=~p&is_client=1&platform=~s", [SrvId, Account1, RoleId, RoleName1, util:unixtime(), Platform])),
%    Request = {Url, [], "application/x-www-form-urlencoded", Post},
%    case httpc:request(post, Request, [{timeout, 5000}], [{sync, true}]) of
%        {ok, {_Status, _Header, Body}} ->
%            ?DEBUG("~ts", [Body]),
%            case rfc4627:decode(Body) of
%                {ok, {obj, Obj}, _} ->
%                    case lists:keyfind("state", 1, Obj) of
%                        {"state", State} when State=:=1 orelse State =:= <<"1">> ->
%                            case lists:keyfind("clist", 1, Obj) of
%                                false ->
%                                    {reply, {[]}};
%                                {Clist, 1} -> 
%                                    List = lists:map(fun(Row)->
%                                        Msg = proplists:get_value("msg", Row),
%                                        Time = proplists:get_value("time", Row),
%                                        [Time, Msg]
%                                    end, Clist),
%                                    {reply, {List}}
%                            end;
%                        _ ->
%                            ?ERR("json:decode ~p", [Obj]),
%                            {reply, {[]}}
%                    end;
%                JsonResult ->
%                    ?ERR("json:decode ~p", [JsonResult]),
%                    {reply, {[]}}
%            end;
%        {error, _Reason} ->
%            ?ERR("request: ~p", [_Reason]),
%            {reply, {[]}}
%    end;    

handle(_Cmd, _Data, _Role) ->
    ?DEBUG("接到无效请求 cmd = ~w, data = ~w", [_Cmd, _Data]),
    {ok}.

%% --------------------------------------------------------------------
%% 内部函数
%% --------------------------------------------------------------------

%% 上线修复人物锁定状态
role_login_check(lock, Role = #role{lock_info = ?gm_role_free}) -> {ok, Role};
role_login_check(lock, Role = #role{id = {Rid, SrvId}, lock_info = ?gm_role_lock}) ->
    Sql = <<"select lock_type, lock_ctime, lock_timeout from sys_lock_role_info where rid = ~s and srv_id = ~s">>,
    Time = util:unixtime(),
    case db:get_row(Sql, [Rid, SrvId]) of
        {ok, [0, _, _]} -> 
            ?DEBUG("后台已经修复过,或者之前封号存数据库失败"),
            {ok, Role#role{lock_info = ?gm_role_lock}};
        {ok, [2, _, _]} -> 
            ?DEBUG("永久封号"),
            {false, ?L(<<"角色被封,无法登陆">>)}; 
        {ok, [1, _Ctime, TimeOut]} when Time >= TimeOut ->
            Sql1 = <<"update sys_lock_role_info set lock_type = ~s, lock_ctime =~s, lock_timeout=~s, lock_info = ~s where rid = ~s and srv_id = ~s">>,
            case db:execute(Sql1, [0, 0, 0, <<"">>, Rid, SrvId]) of
                {ok, _} -> ok;
                _Other ->
                    ?ELOG("封号上线修复失败:~w",[_Other]),
                    false
            end,
            {ok, Role#role{lock_info = ?gm_role_free}};
        {ok, [1, _, _]} -> 
            ?DEBUG("时间未到,无法登陆"),
            {false, ?L(<<"角色被封,无法登陆">>)}; 
        {error, undefined} -> {ok, Role#role{lock_info = ?gm_role_free}};
        _ -> {false, ?L(<<"角色状态异常,无法登陆">>)}
    end;

role_login_check(lock, Role = #role{id = {Rid, SrvId}, lock_info = ?gm_role_silent}) ->
    Sql = <<"select silent_type, silent_ctime, silent_timeout from sys_lock_role_info where rid = ~s and srv_id = ~s">>,
    Time = util:unixtime(),
    case db:get_row(Sql, [Rid, SrvId]) of
        {ok, [0, _, _]} -> {ok, Role#role{lock_info = ?gm_role_free}};
        {ok, [2, _, _]} -> {ok, Role};
        {ok, [1, _Ctime, TimeOut]} when Time >= TimeOut ->
            Sql1 = <<"update sys_lock_role_info set silent_type = ~s, silent_ctime =~s, silent_timeout=~s, silent_hide=~s, silent_info = ~s where rid = ~s and srv_id = ~s">>,
            case db:execute(Sql1, [0, 0, 0, 0, <<"">>, Rid, SrvId]) of
                {ok, _} -> ok;
                _Other ->
                    ?ELOG("禁言上线修复失败:~w",[_Other]),
                    false
            end,
            {ok, Role#role{lock_info = ?gm_role_free}};
        {ok, [1, _, _]} -> {ok, Role};
        {error, undefined} ->
            ?ELOG("角色状态异常,数据库无法找到禁言记录"),
            {ok, Role#role{lock_info = ?gm_role_free}};
        _ -> {ok, Role}
    end;
role_login_check(lock, Role = #role{id = {Rid, SrvId}, lock_info = ?gm_role_lock_and_silent}) ->
    Sql = <<"select lock_type, lock_ctime, lock_timeout, lock_info, silent_type, silent_ctime, silent_timeout, silent_hide, silent_info from sys_lock_role_info where rid = ~s and srv_id = ~s">>,
    Time = util:unixtime(),
    case db:get_row(Sql, [Rid, SrvId]) of
        {ok, [2, _LockTime, _LockTimeOut, _, _, _, _, _, _]} -> {false, ?L(<<"角色被封,无法登陆">>)};
        {ok, [0, _, _, _, SilentType, Ctime, TimeOut, Hide, Smsg]} ->
            {Silent, Stime, Stimeout, Shide, Msg, NewRole} = case SilentType of
                0 -> {?gm_role_free, 0, 0, 0, <<"">>, Role#role{lock_info = ?gm_role_free}};
                1 when Time >= TimeOut -> {?gm_role_free, 0, 0, 0, <<"">>, Role#role{lock_info = ?gm_role_free}};
                1 -> {?gm_role_silent, Ctime, TimeOut, Hide, Smsg, Role#role{lock_info = ?gm_role_silent}};
                2 -> {?gm_role_silent, Ctime, TimeOut, Hide, Smsg, Role#role{lock_info = ?gm_role_silent}}
            end,
            Sql1 = <<"update sys_lock_role_info set lock_type = ~s, lock_ctime =~s, lock_timeout=~s, lock_info = ~s, silent_type = ~s, silent_ctime =~s, silent_timeout=~s, silent_hide=~s, silent_info = ~s where rid = ~s and srv_id = ~s">>,
            case db:execute(Sql1, [0, 0, 0, <<"">>, Silent, Stime, Stimeout, Shide, Msg, Rid, SrvId]) of
                {ok, _} -> ok;
                _Other ->
                    ?ELOG("封号且禁言上线修复失败:~w",[_Other]),
                    false
            end,
            {ok, NewRole};
        {ok, [1, _, LtimeOut, _, SilentType, Ctime, TimeOut, Hide, Smsg]} when Time >= LtimeOut ->
            {Silent, Stime, Stimeout, Shide, Msg, NewRole} = case SilentType of
                0 -> {?gm_role_free, 0, 0, 0, <<"">>, Role#role{lock_info = ?gm_role_free}};
                1 when Time >= TimeOut -> {?gm_role_free, 0, 0, 0, <<"">>, Role#role{lock_info = ?gm_role_free}};
                1 -> {?gm_role_silent, Ctime, TimeOut, Hide, Smsg, Role#role{lock_info = ?gm_role_silent}};
                2 -> {?gm_role_silent, Ctime, TimeOut, Hide, Smsg, Role#role{lock_info = ?gm_role_silent}}
            end,
            Sql1 = <<"update sys_lock_role_info set lock_type = ~s, lock_ctime =~s, lock_timeout=~s, lock_info = ~s, silent_type = ~s, silent_ctime =~s, silent_timeout=~s, silent_hide=~s, silent_info = ~s where rid = ~s and srv_id = ~s">>,
            case db:execute(Sql1, [0, 0, 0, <<"">>, Silent, Stime, Stimeout, Shide, Msg, Rid, SrvId]) of
                {ok, _} -> ok;
                _Other ->
                    ?ELOG("封号且禁言上线修复失败:~w",[_Other]),
                    false
            end,
            {ok, NewRole};
        {ok, [1 | _]} -> {false, ?L(<<"角色被封,无法登陆">>)};
        {error, undefined} -> {ok, Role#role{lock_info = ?gm_role_free}}
    end.

%% 查询人物禁言状态
check_role_lock(silent, #role{lock_info = ?gm_role_free}) -> ok; 
check_role_lock(silent, Role = #role{lock_info = ?gm_role_silent, id = {Rid, SrvId}}) ->
    Sql = <<"select silent_type, silent_ctime, silent_timeout, silent_hide from sys_lock_role_info where rid = ~s and srv_id = ~s">>,
    Time = util:unixtime(),
    case db:get_row(Sql, [Rid, SrvId]) of
        {ok, [0, _Ctime, _TimeOut, _Hide]} -> ok;
        {ok, [2, _, _, 1]} -> callback;
        {ok, [2, _, _, 2]} -> false;
        {ok, [1, _Ctime, TimeOut, _]} when Time >= TimeOut -> 
            Sql1 = <<"update sys_lock_role_info set silent_type = ~s, silent_ctime =~s, silent_timeout=~s, silent_hide=~s, silent_info = ~s where rid = ~s and srv_id = ~s">>,
            case db:execute(Sql1, [0, 0, 0, 0, "", Rid, SrvId]) of
                {ok, _} -> ok;
                _Other -> 
                    ?ELOG("禁言时间已过修改人物禁言状态失败:~s",[_Other]),
                    false
            end,
            {ok, Role#role{lock_info = ?gm_role_free}};
        {ok, [1, _, _, 1]} -> callback;
        {ok, [1, _, _, 2]} -> false;
        {error, undefined} -> false
    end.

%% 修改人物的封号禁言状态
%% 0 解封 1封号 2禁言 3禁言和封号
modify_role_lock_status(#role{lock_info = ?gm_role_free}, ?gm_role_free) -> {ok, ok};
modify_role_lock_status(Role = #role{lock_info = _LockInfo}, ?gm_role_free) -> 
    {ok, ok, Role#role{lock_info = ?gm_role_free}};

modify_role_lock_status(Role = #role{lock_info = LockInfo}, Type) ->
    {Flag, NewLockInfo} = case LockInfo of
        ?gm_role_free -> {ok, Type};
        ?gm_role_silent when Type =:= ?gm_role_lock -> {ok, ?gm_role_lock_and_silent};
        ?gm_role_lock when Type =:= ?gm_role_silent -> {ok, ?gm_role_lock_and_silent};
        _ -> {false, LockInfo} 
    end,
    case Flag =:= false of
        true -> {ok, ok};
        false -> {ok, ok, Role#role{lock_info = NewLockInfo}} 
    end.

%% 保存反馈
%do_save_feedback({Type, Phone, QQ, Content}, #role{id = {RoleId, SrvId}, name = RoleName}) ->
%    Sql = "insert into admin_feedback2(role_id, srv_id, role_name, type, phone, qq, content, post_time) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
%    case db:execute(Sql, [RoleId, SrvId, RoleName, Type, Phone, QQ, Content, util:unixtime()]) of
%        {ok, _} -> ok;
%        _Other -> false
%    end.

%% GM封号
%% 封号类型 1:时间型, 2:永久型
do_lock_role({LockRolePid, LockRid, LockSrvId}, 1, Time, Msg, #role{label = ?role_label_gm, name = AdminName}) ->
    Ctime = util:unixtime(),
    TimeOut = Ctime + Time * 3600,
    catch do_update_role({AdminName, Msg, ?gm_role_lock, 1, Ctime, TimeOut}, {LockRid, LockSrvId}),
    case role:apply(sync, LockRolePid, {fun modify_role_lock_status/2, [?gm_role_lock]}) of
        ok ->
            role:stop(async, LockRolePid, ?L(<<"亲,你干坏事了,被封号咯~">>)),
            insert_gm_log(LockRid, LockSrvId, AdminName, 1, Ctime, TimeOut, Msg),
            ok;
        _X -> 
            ?ELOG("修改角色状态失败:~w",[_X]),
            false
    end;
do_lock_role({LockRolePid, LockRid, LockSrvId}, 2, _Time, Msg, #role{label = ?role_label_gm, name = AdminName}) ->
    Ctime = util:unixtime(),
    catch do_update_role({AdminName, Msg, ?gm_role_lock, 2, Ctime, 0}, {LockRid, LockSrvId}),
    case role:apply(sync, LockRolePid, {fun modify_role_lock_status/2, [?gm_role_lock]}) of
        ok ->
            role:stop(async, LockRolePid, ?L(<<"亲,你干坏事了,被封号咯~">>)),
            %%role_api:kick(by_pid, {LockRolePid}, ?L(<<"封号踢下线">>)),
            insert_gm_log(LockRid, LockSrvId, AdminName, 2, Ctime, 0, Msg),
            ok;
        _X -> 
            ?ELOG("修改角色状态失败:~w",[_X]),
            ok
    end;
do_lock_role({_, _, _}, _, _, _, _) -> ignore.

%% GM禁言
%% 禁言类型 1:时间型, 2:永久型
do_silent_role({SilentRolePid, SilentRid, SilentSrvId}, 1, Time, Flag, Msg, #role{label = ?role_label_gm, name = AdminName}) ->
    Ctime = util:unixtime(),
    TimeOut = Ctime + Time * 3600,
    catch do_update_role({AdminName, Flag, Msg, ?gm_role_silent, 1, Ctime, TimeOut}, {SilentRid, SilentSrvId}),
    case role:apply(sync, SilentRolePid, {fun modify_role_lock_status/2, [?gm_role_silent]}) of
        ok -> 
            insert_gm_log(SilentRid, SilentSrvId, AdminName, 3, Ctime, TimeOut, Msg),
            ok;
        _X -> 
            ?ELOG("修改角色状态失败:~w",[_X]),
            false
    end;
do_silent_role({SilentRolePid, SilentRid, SilentSrvId}, 2, _Time, Flag, Msg, #role{label = ?role_label_gm, name = AdminName}) ->
    Ctime = util:unixtime(),
    catch do_update_role({AdminName, Flag, Msg, ?gm_role_silent, 2, Ctime, 0}, {SilentRid, SilentSrvId}),
    case role:apply(sync, SilentRolePid, {fun modify_role_lock_status/2, [?gm_role_silent]}) of
        ok ->
            insert_gm_log(SilentRid, SilentSrvId, AdminName, 4, Ctime, 0, Msg),
            ok;
        _X -> 
            ?ELOG("修改角色状态失败:~w",[_X]),
            ok
    end;
do_silent_role({_, _, _}, _, _, _, _, _) -> ignore.

%% GM封IP
do_block_ip(LoginIp, Msg, #role{label = ?role_label_gm, name = AdminName}) ->
    LoginIp1 = log_conv:ip2bitstring(LoginIp),
    Ctime = util:unixtime(),
    SqlSel = <<"select ip from admin_blockip where ip=~s">>,
    SqlInsert = <<"insert into admin_blockip(ip, admin_name, memo, ctime) values(~s, ~s, ~s, ~s)">>,
    case db:get_row(SqlSel, [LoginIp1]) of
        {ok, _} -> ok;
        _ ->
            case catch db:execute(SqlInsert, [LoginIp1, AdminName, Msg, Ctime]) of
                {ok, _} -> ok;
                {error, _Reason} ->
                    ?ERR("封Ip:~s时发生错误:~s", [LoginIp1, _Reason]),
                    false;
                _Other ->
                    ?DEBUG("封Ip:~s时发生错误:~w", [LoginIp1, _Other]),
                    false
            end
    end;
do_block_ip(_, _, _) -> ignore.

%% 更新玩家封号信息
do_update_role({AdminName, Msg, ?gm_role_lock, Value, Ctime, TimeOut}, {Rid, SrvId}) ->
    Sql = <<"insert into sys_lock_role_info(rid, srv_id, admin_name, lock_type, lock_ctime, lock_timeout, lock_info, silent_type, silent_ctime, silent_timeout, silent_hide, silent_info) values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s) ON DUPLICATE KEY UPDATE admin_name = ~s, lock_type = ~s, lock_ctime = ~s, lock_timeout = ~s, lock_info = ~s">>,
    case db:execute(Sql, [Rid, SrvId, AdminName, Value, Ctime, TimeOut, Msg, 0, 0, 0, 0, <<"">>, AdminName, Value, Ctime, TimeOut, Msg]) of
        {ok, _} -> ok;
        _Other ->
            ?ELOG("封号修改数据库失败,AdminName:~s,Rid:~w,Srvid:~s,Reason:~s",[AdminName,Rid,SrvId,_Other]),
            false
    end;

%% 更新玩家禁言信息
do_update_role({AdminName, Flag, Msg, ?gm_role_silent, Value, Ctime, TimeOut}, {Rid, SrvId}) ->
    Sql = <<"insert into sys_lock_role_info(rid, srv_id, admin_name, lock_type, lock_ctime, lock_timeout, lock_info, silent_type, silent_ctime, silent_timeout, silent_hide, silent_info) values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s) ON DUPLICATE KEY UPDATE admin_name = ~s, silent_type = ~s, silent_ctime = ~s, silent_timeout = ~s, silent_hide= ~s, silent_info = ~s">>,
    case db:execute(Sql, [Rid, SrvId, AdminName, 0, 0, 0, <<"">>, Value, Ctime, TimeOut, Flag, Msg, AdminName, Value, Ctime, TimeOut, Flag, Msg]) of
        {ok, _} -> ok;
        _Other ->
            ?ELOG("禁言修改数据库失败,AdminName:~s,Rid:~w,Srvid:~s,Reason:~s",[AdminName,Rid,SrvId,_Other]),
            false
    end.

%% 踢玩家下线
do_kick_role(Role, RoleId, SrvId, Msg) ->
    case Role#role.label =:= ?role_label_gm of
        true ->
            role_api:kick(by_id, {RoleId, SrvId}, Msg),
            {ok};
        false ->
            {false, ?gm_kick_fail}
    end.

%%-------------------------------------------------------------------------
%% GM操作日志
%%-------------------------------------------------------------------------
insert_gm_log(Rid, SrvId, AdminName, Type, Ctime, TimeOut, Info) ->
    Sql = <<"insert into log_lock_role(rid, srv_id, admin_name, type, ctime, timeout, info) values(~s,~s,~s,~s,~s,~s,~s)">>,
    case db:execute(Sql, [Rid, SrvId, AdminName, Type, Ctime, TimeOut, Info]) of
        {error, _Why} ->
            ?ELOG("GM操作写入日志出错，[Reason: ~w]", [_Why]),
            false;
        {ok, _Result} ->
            true
    end.
