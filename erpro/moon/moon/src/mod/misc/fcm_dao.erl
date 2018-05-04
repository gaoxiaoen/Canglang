%%----------------------------------------------------
%% 防沉迷 数据库接口 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(fcm_dao).
-export([
        add/2
        ,add/1
        ,check/1
        ,get_online_info/1
        ,save_online_info/1
        ,get_auth_info/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("fcm.hrl").

%% GM 在棒子服玩专用()
add(Account) ->
    Sql = "insert into sys_fcm(account, sfz, name, ctime) values(~s, ~s, ~s, ~s)",
    case db:execute(Sql, [Account, 20, 1, util:unixtime()]) of
        {ok, Rows} when is_integer(Rows) andalso Rows > 0 -> 
            {ok, Rows};
        _ -> {false, <<"插入防沉迷失败">>}
    end.

%% 插入防沉迷数据
add(#role{account = Account}, {Sfz, Name}) -> 
    Sql = "insert into sys_fcm(account, sfz, name, ctime) values(~s, ~s, ~s, ~s)",
    case db:execute(Sql, [Account, Sfz, Name, util:unixtime()]) of
        {ok, Rows} when is_integer(Rows) andalso Rows > 0 -> 
            del_online_info(Account),
            {ok, Rows};
        _ -> {false, <<"插入防沉迷失败">>}
    end.

%% 查看玩家是否已通过防沉迷验证
check(#role{account = Account}) ->
    Sql = "select count(*) from sys_fcm where account = ~s",
    case db:get_one(Sql, [Account]) of
        {ok, Count} when is_integer(Count) andalso Count > 0 -> true;
        _ -> false
    end.

%% 查询玩家年龄(韩国)
get_auth_info(#role{account = Account}) ->
    Sql = <<"select sfz, name from sys_fcm where account = ~s">>,
    case db:get_row(Sql, [Account]) of
        {ok, [AgeStr, AuthStr]} when is_binary(AgeStr), is_binary(AuthStr) -> 
            try list_to_integer(binary_to_list(AgeStr)) of
                Age ->
                    try list_to_integer(binary_to_list(AuthStr)) of
                        Auth -> {ok, Age, Auth}
                    catch
                        _Error:_Info -> 
                            ?ERR("无法将表 sys_fcm 中帐号为的 【~s】玩家的 name 字段数据转换成 整型数据(认证状态), 防沉迷验证失败", [Account]),
                            error
                    end
            catch
                _Error:_Info -> 
                    ?ERR("无法将表 sys_fcm 中帐号为的 【~s】玩家的 sfz 字段数据转换成 整型数据(年龄), 防沉迷验证失败", [Account]),
                    error
            end;
        {ok, [AgeStr, AuthStr]} when is_list(AgeStr), is_list(AuthStr) -> 
            try list_to_integer(AgeStr) of
                Age ->
                    try list_to_integer(AuthStr) of
                        Auth -> {ok, Age, Auth}
                    catch
                        _Error:_Info -> 
                            ?ERR("无法将表 sys_fcm 中帐号为的 【~s】玩家的 name 字段数据转换成 整型数据(认证状态), 防沉迷验证失败", [Account]),
                            error
                    end
            catch
                _Error:_Info -> 
                    ?ERR("无法将表 sys_fcm 中帐号为的 【~s】玩家的 sfz 字段数据转换成 整型数据(年龄), 防沉迷验证失败", [Account]),
                    error
            end;
        _ -> error
    end.

%% 删除在线信息
del_online_info(Account) ->
    Sql = "delete from sys_login where account = ~s",
    db:execute(Sql, [Account]).

%% 获取玩家在线信息情况
get_online_info(#role{account = Account}) ->
    Sql = "select logout_time, acc_time from sys_login where account = ~s",
    case db:get_row(Sql, [Account]) of
        {ok, [LTime, ATime]} ->
            Now = util:unixtime(),
            {ok, #fcm{login_time = Now, logout_time = Now - LTime, acc_time = ATime}};
        {error, undefined} -> {ok, #fcm{login_time = util:unixtime()}};
        _ -> false
    end.

%% 保存防沉迷信息
save_online_info(#role{fcm = #fcm{is_auth = 1}}) -> ok;  %% 已通过认证账号
save_online_info(#role{fcm = #fcm{msg_id = 0}}) -> ok; %% 登录未成功退出
save_online_info(#role{account = Account, fcm = #fcm{acc_time = AccTime, login_time = LoginTime}}) ->
    Sql = "replace into sys_login (account, logout_time, acc_time) values(~s, ~s, ~s)",
    Now = util:unixtime(),
    case db:execute(Sql, [Account, Now, AccTime + (Now - LoginTime)]) of
        {ok, _Rows} -> ok;
        _ -> false
    end;
save_online_info(_) -> ok. %% 容错
