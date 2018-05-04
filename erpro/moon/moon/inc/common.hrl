%%----------------------------------------------------
%% 公共定义文件
%% (不要随意在此添加新的定义)
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-define(DB, mysql_conn_pool).
-define(DB_ASYNC, mysql_conn_async_pool).
-define(DB_SYS, mysql_conn_sys_pool).
-ifdef(debug).
-define(DEBUG(Msg), file_logger:debug(Msg, [], ?MODULE, ?LINE)).     %% 输出调试信息
-define(DEBUG(F, A), file_logger:debug(F, A, ?MODULE, ?LINE)).
-else.
-define(DEBUG(Msg), ok).     %% 停止输出调试信息
-define(DEBUG(F, A), ok).
-endif.

-define(DUMP(P), ?DEBUG("~p = ~p", [??P, P]) ).

-define(CATCH(X), (fun() -> try begin X end catch A:B -> ?ERR("~p : ~p : ~p", [A, B, erlang:get_stacktrace()]), {A, B} end end)()).

%% 带catch的gen_server:call/2，返回{error, timeout} | {error, noproc} | {error, term()} | term() | {exit, normal}
%% 此宏只会返回简略信息，如果需要获得更详细的信息，请使用以下方式自行处理:
%% case catch gen_server:call(Pid, Request)
-define(CALL(Pid, Request),
    case catch gen_server:call(Pid, Request) of
        {'EXIT', {timeout, _}} -> {error, timeout};
        {'EXIT', {noproc, _}} -> {error, noproc};
        {'EXIT', normal} -> {exit, normal};
        {'EXIT', Reason} -> {error, Reason};
        Rtn -> Rtn
    end
).

%% 数字型的bool值
-define(false, 0).
-define(true, 1).
-define(bool_not(Bool), (1 bxor Bool)). %% ?true -> ?false, ?false -> ?true

-define(lookup_cd_time, 1).  %% 查看其它玩家cd时间控制

%% 返回给客户端协议编号
%% 0  失败
%% 1  成功
-define(coin_all_less, 10).  %% 10 所有金币不足
-define(coin_less, 11).  %% 11 金币不足
-define(coin_bind_less, 12).  %% 12 绑定金币不足
-define(gold_less, 13).  %% 13 晶钻不足
-define(gold_bind_less, 14).  %% 14 绑定晶钻不足
-define(gold_all_less, 15).  %% 10 所有晶钻不足

-ifdef(debug).
-define(INFO(Msg), catch file_logger:info(Msg, [], ?MODULE, ?LINE)).       %% 输出普通信息
-define(INFO(F, A), catch file_logger:info(F, A, ?MODULE, ?LINE)).
-define(ERR(Msg), catch file_logger:error(Msg, [], ?MODULE, ?LINE)).       %% 输出错误信息
-define(ERR(F, A), catch file_logger:error(F, A, ?MODULE, ?LINE)).
%% 只输出错误信息，不再记录到数据库(已弃用，都使用?ERR代替)
-define(ELOG(Msg), catch file_logger:error(Msg, [], ?MODULE, ?LINE)).
-define(ELOG(F, A), catch file_logger:error(F, A, ?MODULE, ?LINE)).
-else.
-define(INFO(Msg), catch logger:info(Msg, [], ?MODULE, ?LINE)).       %% 输出普通信息
-define(INFO(F, A), catch logger:info(F, A, ?MODULE, ?LINE)).
-define(ERR(Msg), catch logger:error(Msg, [], ?MODULE, ?LINE)).       %% 输出错误信息
-define(ERR(F, A), catch logger:error(F, A, ?MODULE, ?LINE)).
%% 只输出错误信息，不再记录到数据库(已弃用，都使用?ERR代替)
-define(ELOG(Msg), catch logger:error(Msg, [], ?MODULE, ?LINE)).
-define(ELOG(F, A), catch logger:error(F, A, ?MODULE, ?LINE)).
-endif.

%% 未实现的函数请加入下面这个宏到函数体中
-define(NYI, io:format("*** NYI ~p ~p~n", [?MODULE, ?LINE]), exit(nyi)).

%% 语言转换
-define(L(Bin), language:get(Bin)).
%% 活动类 语言转换
-define(LA(Bin), lactivity:get(Bin)).

%% 协议使用: 文字消息转化为数字编号, 且作为国际化使用
%% MsgId::int(),  Msg::binary()
-define(MSG(MsgId, _Msg), MsgId).
-define(MSG(Msg), Msg).
-define(MSG_NULL, 0).
-define(MSGID(Msg), i18n:id(Msg)).
