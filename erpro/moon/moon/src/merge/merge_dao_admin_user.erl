%%----------------------------------------------------
%% @doc 后台管理员帐号
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_admin_user).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

-record(merge_admin_user, {
        username
    }
).

do_init(Table = #merge_table{server = #merge_server{data_source = DataSource, index = Index}}) ->
    Sql = "select id, gid, username, status, passwd, name, description, last_visit, last_ip, last_addr, login_times, ip_limit, error_ip, error_time, error_num from admin_user",
    case merge_db:get_all4page(DataSource, Sql, [], 3000) of
        {ok, Data} -> 
            case Index =:= 1 of
                true ->
                    ets:new(ets_merge_admin_user, [set, named_table, public, {keypos, #merge_admin_user.username}]);
                _ -> ignore
            end,
            {ok, Data, Table};
        {error, Reason} -> {error, Reason}
    end.

%% 处理数据
do_convert([], Table) -> {ok, Table};
do_convert([[_Id, Gid, Username, Status, Passwd, Name, Description, LastVisit, LastIp, LastAddr, LoginTimes, IpLimit, ErrorIp, ErrorTime, ErrorNum] | T], Table = #merge_table{server = #merge_server{index = 1}}) ->
    Sql = "insert into admin_user(gid, username, status, passwd, name, description, last_visit, last_ip, last_addr, login_times, ip_limit, error_ip, error_time, error_num) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case merge_db:execute(?merge_target, Sql, [Gid, Username, Status, Passwd, Name, Description, LastVisit, LastIp, LastAddr, LoginTimes, IpLimit, ErrorIp, ErrorTime, ErrorNum]) of
        {ok, 1} ->
            ets:insert(ets_merge_admin_user, #merge_admin_user{username = Username}),
            do_convert(T, Table);
        {error, Reason} ->
            {error, Reason}
    end;
do_convert([[_Id, Gid, Username, Status, Passwd, Name, Description, LastVisit, LastIp, LastAddr, LoginTimes, IpLimit, ErrorIp, ErrorTime, ErrorNum] | T], Table) ->
    case ets:lookup(ets_merge_admin_user, Username) of
        [] ->
            Sql = "insert into admin_user(gid, username, status, passwd, name, description, last_visit, last_ip, last_addr, login_times, ip_limit, error_ip, error_time, error_num) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
            case merge_db:execute(?merge_target, Sql, [Gid, Username, Status, Passwd, Name, Description, LastVisit, LastIp, LastAddr, LoginTimes, IpLimit, ErrorIp, ErrorTime, ErrorNum]) of
                {ok, 1} -> 
                    ets:insert(ets_merge_admin_user, #merge_admin_user{username = Username}),
                    do_convert(T, Table);
                {error, Reason} -> {error, Reason}
            end;
        _ -> 
            do_convert(T, Table)
    end.

%% 最后执行一下,释放资源
do_end(#merge_table{server = #merge_server{index = Index, size = Size}}) when Index =:= Size -> 
    ets:delete(ets_merge_admin_user),
    ignore;
do_end(_Table) -> ignore.
