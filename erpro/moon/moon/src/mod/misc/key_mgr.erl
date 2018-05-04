%%----------------------------------------------------
%% @doc 唯一健值生成器
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(key_mgr).

-behaviour(gen_server).

-export([
        start_link/0
        ,generate/1
        %%,test/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% -include_lib("stdlib/include/ms_transform.hrl").
-include("common.hrl").

%% 进程状态数据
-record(state, {
        cache_list = []
    }
).
-record(key_cache, {
        type
        ,next = 0
        ,max = 0
    }
).
%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
%% @spec start_link() ->
%% @doc
%% <pre>
%% 启动进程 
%% </pre>
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% @spec generate(KeyType::atom()) -> {ok, Value::integer()} | {false, Reason::binary()}
%% @doc
%% <pre>
%% 产生健值
%% </pre>
generate(KeyType) ->
    gen_server:call({global, ?MODULE}, {generate, KeyType}).

%%----------------------------------------------------
%% gen_server函数 
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, #state{}}.

handle_call({generate, KeyType}, _From, State) ->
    case do_generate(KeyType, State) of
        {ok, Value, NewState} ->
            {reply, {ok, Value}, NewState};
        {false, Reason} ->
            {reply, {false, Reason}, State}
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State = #state{cache_list = List}) ->
    save(List),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
%%----------------------------------------------------
%% 私有函数 
%%----------------------------------------------------

save([]) -> ok;
save([#key_cache{type = KeyType, next = NextVal, max = Maxvalue} | T]) when NextVal < Maxvalue ->
    update_key(KeyType, NextVal),
    save(T);
save([_KeyCache | T]) -> save(T).

%% 产出健值
do_generate(KeyType, State = #state{cache_list = List}) ->
    case lists:keyfind(KeyType, #key_cache.type, List) of
        false ->
            {InitVal, CacheSize} = key_info(KeyType),
            case get_key(KeyType) of
                {ok, Value} ->
                    case update_key(KeyType, Value + CacheSize) of
                        {ok, _Affected} ->
                            KeyCache = #key_cache{type = KeyType, next = Value + 1, max = Value + CacheSize},
                            {ok, Value, State#state{cache_list = [KeyCache | List]}};
                        {false, Reason} ->
                            {false, Reason}
                    end;
                {false, undefined} ->
                    case insert_key(KeyType, InitVal + CacheSize) of
                        {ok, _Affected} ->
                            KeyCache = #key_cache{type = KeyType, next = InitVal + 1, max = InitVal + CacheSize},
                            {ok, InitVal, State#state{cache_list = [KeyCache | List]}};
                        {false, Reason} ->
                            {false, Reason}
                    end;
                {false, Reason} ->
                    {false, Reason}
            end;
        Cache = #key_cache{next = NextVal, max= Maxvalue} ->
            case NextVal < Maxvalue of
                true ->
                    NewCache = Cache#key_cache{next = NextVal + 1},
                    NewList = lists:keyreplace(KeyType, #key_cache.type, List, NewCache),
                    {ok, NextVal, State#state{cache_list = NewList}};
                false ->
                    {_InitVal, CacheSize} = key_info(KeyType),
                    NewCache = Cache#key_cache{next = NextVal + 1, max = NextVal + CacheSize},
                    case update_key(KeyType, NextVal + CacheSize) of
                        {ok, _Affected} ->
                            NewList = lists:keyreplace(KeyType, #key_cache.type, List, NewCache),
                            {ok, NextVal, State#state{cache_list = NewList}};
                        {false, Reason} -> {false, Reason}
                    end
            end
    end.

%% 获取得主键值
get_key(KeyType) ->
    Sql = <<"select value from sys_keyval where key_type = ~s">>,
    case db:get_one(Sql, [KeyType]) of
        {error, undefined} ->
            {false, undefined};
        {error, Reason} ->
            ?ELOG("查询出错了[KeyType:~w, Msg:~w]", [KeyType, Reason]),
            {false, Reason};
        {ok, Value} ->
            {ok, Value}
    end.

%% 新增一条主键类型
insert_key(KeyType, InitVal) ->
    Sql = <<"insert into sys_keyval (key_type, value) values (~s, ~s)">>,
    case db:execute(Sql, [KeyType, InitVal]) of
        {ok, Affected} -> {ok, Affected};
        {error, Reason} ->
            ?ELOG("插入健值出错了[KeyType:~w, Msg:~w]", [KeyType, Reason]),
            {false, Reason}
    end.

%% 更新键值
update_key(KeyType, NewVal) ->
    Sql = <<"update sys_keyval set value = ~s where key_type = ~s">>,
    case db:execute(Sql, [NewVal, KeyType]) of
        {ok, Affected} -> {ok, Affected};
        {error, Reason} ->
            ?ELOG("更新健值出错了[KeyType:~w, Msg:~w]", [KeyType, Reason]),
            {false, Reason}
    end.

%% @spec key_info(KeyType) -> {InitVal, CacheSize}
%% @doc 缓存大小
key_info(market_key_sale) -> {1000000, 1000};
key_info(market_key_buy) -> {1000000, 1000};
key_info(_KeyType) -> {1, 100}.

%% test(N) ->
%% 	F = fun(_I) ->
%%             generate(test_1)
%% 		end,
%% 	F1 = fun(_I) ->
%%             generate(test1)
%% 		end,
%% 	F2 = fun(_I) ->
%%             generate(test2)
%% 		end,
%% 	F3 = fun(_I) ->
%%             generate(test3)
%% 		end,
%% 	F4 = fun(_I) ->
%%             generate(test4)
%% 		end,
%% 	F5 = fun(_I) ->
%%             generate(by_state)
%% 		end,
%% 	ptester:run(N, [
%%             {"cache size(1)", F}
%%             ,{"cache size(5)", F1}
%%             ,{"cache size(10)", F2}
%%             ,{"cache size(50)", F3}
%%             ,{"cache size(500)", F4}
%%             ,{"by_state", F5}
%%         ]
%%     ).
    

