%%----------------------------------------------------
%% 数据库API封装
%% 
%% @author yeahoo2000@gmail.com
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_db).
-export(
    [
        execute/2
        ,execute/3
        ,select_limit/4
        ,select_limit/5
        ,get_one/2
        ,get_one/3
        ,get_row/2
        ,get_row/3
        ,get_all/2
        ,get_all/3
        ,get_all4page/4
        ,get_all4page_cb/6
        ,format_sql/2
        ,tx/2
        %% ,t_init/0
        %% ,t/1
    ]
).

-define(mysql_standalone_timeout, 4294967294).

-include("common.hrl").

%% @spec execute(Sql) -> {ok, Affected} | {error, bitstring()}
%% Sql = iolist()
%% Affected = integer()
%% @doc 执行一个SQL查询,返回影响的行数
execute(DataSource, Sql) ->
    case catch mysql:fetch(DataSource, Sql, ?mysql_standalone_timeout) of
        {updated, {_, _, _, R, _}} -> {ok, R};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end.

%% @spec execute(Sql, Args) -> {ok, Affected} | {error, bitstring()}
%% Sql = iolist()
%% Args = list()
%% Affected = integer()
%% @doc 执行一个带格式化参数的SQL查询,返回影响的行数
execute(DataSource, Sql, Args) when is_atom(Sql) ->
    case catch mysql:execute(DataSource, Sql, Args, ?mysql_standalone_timeout) of
        {updated, {_, _, _, R, _}} -> {ok, R};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end;
execute(DataSource, Sql, Args) ->
    Query = format_sql(Sql, Args),
    case catch mysql:fetch(DataSource, Query, ?mysql_standalone_timeout) of
        {updated, {_, _, _, R, _}} -> {ok, R};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end.

%% @spec select_limit(Sql, Offset, Num) -> {ok, list()} | {error, bitstring()}
%% Sql = iolist() | string()
%% Offset = integer()
%% Num = integer()
%% @doc 执行分页查询，返回结果中的所有行
select_limit(DataSource, Sql, Offset, Num) ->
    S = list_to_binary([Sql, <<" limit ">>, integer_to_list(Offset), <<", ">>, integer_to_list(Num)]),
    case catch mysql:fetch(DataSource, S, ?mysql_standalone_timeout) of
        {data, {_, _, R, _, _}} -> {ok, R};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end.

%% @spec select_limit(Sql, Args, Offset, Num) -> {ok, list()} | {error, bitstring()}
%% Sql = iolist() | string()
%% Args = list()
%% Offset = integer()
%% Num = integer()
%% @doc 执行分页查询(带格式化参数)，返回结果中的所有行
select_limit(DataSource, Sql, Args, Offset, Num) ->
    S = list_to_binary([Sql, <<" limit ">>, list_to_binary(integer_to_list(Offset)), <<", ">>, list_to_binary(integer_to_list(Num))]),
    mysql:prepare(s, S),
    case catch mysql:execute(DataSource, s, Args, ?mysql_standalone_timeout) of
        {data, {_, _, R, _, _}} -> {ok, R};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end.

%% @spec get_one(Sql) -> {ok, term()} | {error, bitstring()}
%% Sql = iolist()
%% @doc 取出查询结果中的第一行第一列(不带格式化参数)
%% <div>注意：必须确保返回结果中不会多于一行一列，其它情况或未找到时返回{error, undefined}</div>
get_one(DataSource, Sql) ->
    case catch mysql:fetch(DataSource, Sql, ?mysql_standalone_timeout) of
        {data, {_, _, [[R]], _, _}} -> {ok, R};
        {data, {_, _, [], _, _}} -> {error, undefined};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end.

%% @spec get_one(Sql, Args) -> {ok, term()} | {error, bitstring()}
%% Sql = iolist() | string()
%% Args = list()
%% @doc 取出查询结果中的第一行第一列(带有格式化参数)
%% <div>注意：必须确保返回结果中不会多于一行一列，其它情况或未找到时返回{error, undefined}</div>
get_one(DataSource, Sql, Args) when is_atom(Sql) ->
    case catch mysql:execute(DataSource, Sql, Args, ?mysql_standalone_timeout) of
        {data, {_, _, [[R]], _, _}} -> {ok, R};
        {data, {_, _, [], _, _}} -> {error, undefined};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end;
get_one(DataSource, Sql, Args) ->
    Query = format_sql(Sql, Args),
    case catch mysql:fetch(DataSource, Query, ?mysql_standalone_timeout) of
        {data, {_, _, [[R]], _, _}} -> {ok, R};
        {data, {_, _, [], _, _}} -> {error, undefined};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end.

%% @spec get_row(Sql) -> {ok, term()} | {error, bitstring()}
%% Sql = iolist()
%% @doc 取出查询结果中的第一行
%% <div>注意：必须确保返回结果中不会多于一行，其它情况或未找到时返回{error, undefined}</div>
get_row(DataSource, Sql) ->
    case catch mysql:fetch(DataSource, Sql, ?mysql_standalone_timeout) of
        {data, {_, _, [R], _, _}} -> {ok, R};
        {data, {_, _, [], _, _}} -> {error, undefined};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end.

%% @spec get_row(Sql, Args) -> {ok, term()} | {error, bitstring()}
%% Sql = iolist() | string()
%% @doc 取出查询结果中的第一行(带有格式化参数)
%% <div>注意：必须确保返回结果中不会多于一行，其它情况或未找到时返回{error, undefined}</div>
get_row(DataSource, Sql, Args) when is_atom(Sql) ->
    case catch mysql:execute(DataSource, Sql, Args, ?mysql_standalone_timeout) of
        {data, {_, _, [R], _, _}} -> {ok, R};
        {data, {_, _, [], _, _}} -> {error, undefined};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end;
get_row(DataSource, Sql, Args) ->
    Query = format_sql(Sql, Args),
    case catch mysql:fetch(DataSource, Query, ?mysql_standalone_timeout) of
        {data, {_, _, [R], _, _}} -> {ok, R};
        {data, {_, _, [], _, _}} -> {error, undefined};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end.

%% @spec get_all(Sql) -> {ok, term()} | {error, bitstring()}
%% Sql = iolist()
%% @doc 取出查询结果中的所有行
get_all(DataSource, Sql) ->
    case catch mysql:fetch(DataSource, Sql, ?mysql_standalone_timeout) of
        {data, {_, _, R, _, _}} -> {ok, R};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end.

%% @spec get_all(Sql, Args) -> {ok, term()} | {error, bitstring()}
%% Sql = iolist() | string()
%% @doc 取出查询结果中的所有行
get_all(DataSource, Sql, Args) when is_atom(Sql) ->
    case catch mysql:execute(DataSource, Sql, Args, ?mysql_standalone_timeout) of
        {data, {_, _, R, _, _}} -> {ok, R};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end;
get_all(DataSource, Sql, Args) ->
    Query = format_sql(Sql, Args),
    case catch mysql:fetch(DataSource, Query, ?mysql_standalone_timeout) of
        {data, {_, _, R, _, _}} -> {ok, R};
        {error, {_, _, _, _, Err}} -> format_error(Sql, Err);
        Err -> {error, Err}
    end.

%% 翻页读取数据
get_all4page(DataSource, Sql, Args, PageSize) when is_bitstring(Sql) ->
    get_all4page(DataSource, bitstring_to_list(Sql), Args, PageSize);
get_all4page(DataSource, Sql, Args, PageSize) when is_list(Sql) ->
    NewSql = Sql ++ " limit ~s, ~s",
    get_all4page(DataSource, NewSql, Args, 0, PageSize).
get_all4page(DataSource, NewSql, Args, PageIndex, PageSize) ->
    case get_all(DataSource, NewSql, Args ++ [PageIndex * PageSize, PageSize]) of
        {ok, []} -> {ok, []};
        {ok, Rs} -> 
            case get_all4page(DataSource, NewSql, Args, PageIndex + 1, PageSize) of
                {ok, RsNext} -> {ok, Rs ++ RsNext};
                {error, Reason} -> 
                    {error, Reason}
            end;
        {error, Reason} -> 
            {error, Reason}
    end.

%% 翻页读取数据
get_all4page_cb(DataSource, Sql, Args, PageSize, CallBack, Table) when is_bitstring(Sql) ->
    get_all4page_cb(DataSource, bitstring_to_list(Sql), Args, PageSize, CallBack, Table);
get_all4page_cb(DataSource, Sql, Args, PageSize, CallBack, Table) when is_list(Sql) ->
    NewSql = Sql ++ " limit ~s, ~s",
    get_all4page_cb(DataSource, NewSql, Args, 0, PageSize, CallBack, Table).
get_all4page_cb(DataSource, NewSql, Args, PageIndex, PageSize, CallBack, Table) ->
    case get_all(DataSource, NewSql, Args ++ [PageIndex * PageSize, PageSize]) of
        {ok, []} -> {ok, Table};
        {ok, Rs} -> 
            case CallBack(Rs, Table) of
                {ok, NewTable} ->
                    get_all4page_cb(DataSource, NewSql, Args, PageIndex + 1, PageSize, CallBack, NewTable);
                {error, Reason} -> {error, Reason} 
            end;
        {error, Reason} -> 
            {error, Reason}
    end.

%% @spec tx(Fun) -> {ok, Result} | {error, Reason}
%% Fun = function()
%% Result = term()
%% Reason = atom()
%% @doc 执行一个事务操作
tx(DataSource, Fun) -> tx(DataSource, Fun, undefined).

%% @spec tx(Fun, Timeout) -> {ok, Result} | {error, Reason}
%% Fun = function()
%% Timeout = integer()
%% Result = term()
%% Reason = atom()
%% @doc 执行一个事务操作(带超时设定)
tx(DataSource, Fun, Timeout) ->
    case catch mysql:transaction(DataSource, Fun, Timeout) of
        {atomic, Result} -> {ok, Result};
        {aborted, {Reason, {rollback_result, _Result}}} -> {error, Reason};
        Err -> {error, Err}
    end.

%% @spec format_sql(Sql, Args) -> iolist()
%% Sql = string() | iolist()
%% Args = list()
%% @doc 格式化sql语句
format_sql(Sql, Args) when is_list(Sql) ->
    S = re:replace(Sql, "\\?", "~s", [global, {return, list}]),
    L = [mysql:encode(A) || A <- Args],
    list_to_bitstring(io_lib:format(S, L));
format_sql(Sql, Args) when is_bitstring(Sql) ->
    format_sql(bitstring_to_list(Sql), Args).

%% 格式化SQL错误
format_error(Sql, Error) ->
    Emsg = util:fbin(<<"执行SQL语句出错:~n[SQL] ~s~n[ERR] ~s">>, [Sql, Error]),
    ?ERR("~s", Emsg),
    {error, Emsg}.
