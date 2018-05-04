%%----------------------------------------------------
%% IP封禁管理器
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(ip_block).
-behaviour(gen_server).
-export([
        start_link/0,
        is_blocked/1,
        add/1,
        del/1,
        reload/0,
        stop/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {}).
-include("common.hrl").


%% is_blocked(Ip) -> true | false
%% @doc 是否被封禁的IP
is_blocked(Ip) ->
    gen_server:call({global, ?MODULE}, {is_blocked, Ip}).

%% add([Ip]) -> ok
%% @doc 加入被封禁的Ip列表
add(AddIps) ->
    gen_server:cast({global, ?MODULE}, {add, AddIps}).

%% del([Ip]) -> ok
%% @doc 删除被封禁的Ip
del(DelIps) ->
    gen_server:cast({global, ?MODULE}, {del, DelIps}).

%% reload() -> ok
%% @doc 重新加载被封禁ip列表
reload() ->
    gen_server:cast({global, ?MODULE}, reload).

%% stop() -> ok
%% @doc 停止
stop() ->
    gen_server:cast({global, ?MODULE}, stop).

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(ip_block, [set, named_table, public, {keypos, 1}]),
    load(),
    State = #state{},
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call({is_blocked, Ip}, _From, State) ->
    Result = case ets:lookup(ip_block, Ip) of
        [{Ip}] -> true;
        [] -> false;
        _Err -> ?ERR("查询是否被封禁ip时发生错误:~w", [_Err]), false
    end,
    ?DEBUG("判断该ip[~w]是否被封禁:~w", [Ip, Result]),
    {reply, Result, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast({add, AddIps}, State) ->
    lists:foreach(fun(Ip) ->
                ets:delete(ip_block, Ip)
            end, AddIps),
    lists:foreach(fun(Ip) ->
                ets:insert(ip_block, {Ip})
            end, AddIps),
    ?DEBUG("增加的IPs:~w", [AddIps]),
    {noreply, State};

handle_cast({del, DelIps}, State) ->
    lists:foreach(fun(Ip) ->
                ets:delete(ip_block, Ip)
            end, DelIps),
    ?DEBUG("移除的IPs:~w", [DelIps]),
    {noreply, State};

handle_cast(reload, State) ->
    load(),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(stop, State) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 加载数据库中保存的被封禁的ip
load() ->
    case db:get_all("select ip from admin_blockip") of
        {ok, L} ->
            ?DEBUG("封禁的ip列表: ~w", [L]),
            ets:delete_all_objects(ip_block),
            lists:foreach(fun([Ip]) ->
                        ets:insert(ip_block, {Ip})
                    end, L);
        {error, _Err} -> 
            ?ERR("加载封禁ip列表时发生错误: ~w", _Err)
    end,
    ok.

