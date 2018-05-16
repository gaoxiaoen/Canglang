-module(mod_db).

-export([verify/2, register/2]).

%% 验证账号密码
verify(Name, Passwd) ->
    SqlList = ["select *from account where username = '", Name, "' and password = '", Passwd, "'"],
    Sql = lists:concat(SqlList),
    case mysql:fetch(pollId, Sql) of
        {data, Result} ->
            AllRows = mysql:get_result_rows(Result),
            case length(AllRows) of
                0 ->
                    error;
                _Other ->
                    ok
            end;
        _Other ->
            io:format("sql verify failed, ret: ~p~n", [Sql]),
            error
    end.


register(Name, PassWd) ->
    SqlList = ["select *from account where username = '", Name, "'"],
    Sql = lists:concat(SqlList),
    case mysql:fetch(pollId, Sql) of
        {data, Result} ->
            AllRows = mysql:get_result_rows(Result),
            case length(AllRows) of
                0 ->
                    InsertSqlList = ["insert into account (username,password) value('", Name, "','", PassWd, "')"],
                    InsertSql = lists:concat(InsertSqlList),
                    mysql:fetch(pollId, InsertSql),
                    ok;
                _Other ->
                    error
            end;
        _Other ->
            io:format("sql register failed, ret: ~p~n", [Sql]),
            error
    end.