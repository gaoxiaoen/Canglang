%%----------------------------------------------------
%% @doc 记录客户端日志
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(log_client).

-behaviour(gen_server).

-export([
        start_link/0
        ,insert/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("log_client.hrl").

-record(state, {
        count = 0   %% 数量
    }
).
%%----------------------------------------------------
%% 接口
%%----------------------------------------------------
%% @doc 启动进程 
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% @doc 插入记录
insert(LogClientMsg) ->
    gen_server:cast({global, ?MODULE}, {insert, LogClientMsg}).

%%----------------------------------------------------
%% gen_server函数
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    case ets:info(log_client_ets) of
        undefined ->
            ets:new(log_client_ets, [set, named_table, public, {keypos, #log_client_msg.md5}]);
        _Any ->
            ?DEBUG("测试:当你看到我的时候，请你告诉我!"),
            skip
    end,
    erlang:send_after(60 * 1000, self(), {write_db}),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{count = 0}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 插入新记录
handle_cast({insert, LogClientMsg = #log_client_msg{md5 = Md5}}, State = #state{count = Count}) ->
    case ets:lookup(log_client_ets, Md5) of
        [] -> 
            ets:insert(log_client_ets, LogClientMsg),
            case Count >= 1000 of
                true -> self() ! {write_db_notransfer};
                false -> ignore
            end,
            {noreply, State#state{count = (Count + 1)}};
        _ -> 
            {noreply, State}
    end;

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({write_db}, State) ->
    write_and_clean(),
    erlang:send_after(60 * 1000, self(), {write_db}),
    {noreply, State#state{count = 0}};

%% 不会再发送write_db信号
handle_info({write_db_notransfer}, State) ->
    write_and_clean(),
    %% erlang:send_after(60 * 1000, self(), {write_db}),
    {noreply, State#state{count = 0}};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    write_and_clean(),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------
write_and_clean() ->
    case ets:tab2list(log_client_ets) of
        [] -> ok;
        LogClientMsgList ->
            case db:tx(fun() -> write_db(LogClientMsgList) end) of
                {ok, _X} -> 
                    ?DEBUG("客户端日志信息写入数据库成功"),
                    ok;
                _E -> ?ELOG("客户端日志信息写入出错：~w", [_E])
            end,
            ets:delete_all_objects(log_client_ets)
    end.

write_db([]) -> ok;
write_db([_Log = #log_client_msg{role_id = RoleId, srv_id = SrvId, account = Account, name = Name, md5 = Md5, system = System, browser = Browser, fp_version = FpVersion, client_version = ClientVarsion, error_code = ErrorCode, msg = Msg, time = Time} | T]) ->
    Sql = <<"insert into log_client(role_id, srv_id, account, name, md5, system, browser, fp_version, client_version, error_code, msg, time) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [RoleId, SrvId, Account, Name, Md5, System, Browser, FpVersion, ClientVarsion, ErrorCode, Msg, Time]) of
        {ok, _Rows} -> ignore;
        _ -> 
            ?DEBUG("[客户端日志]插入客户日志信息出错[Log:~w]", [_Log]),
            ignore
    end,
    write_db(T).
