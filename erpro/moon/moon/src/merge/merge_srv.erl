%%---------------------------------------------------
%% @doc 加载库数据并 
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_srv).

-behaviour(gen_server).

-export([
        start_link/1
        ,start_merge/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("merge.hrl").

-record(state, {
        process = <<>>
    }
).

%%----------------------------------------------------
%% 接口
%%----------------------------------------------------
%% 启动进程
start_link(SrvName) ->
    gen_server:start_link({global, SrvName}, ?MODULE, [SrvName], []).

%% 启动合服过程
start_merge(SrvName) ->
    gen_server:cast({global, SrvName}, start_merge).

%%----------------------------------------------------
%% gen_server函数
%%----------------------------------------------------
init([SrvName]) ->
    ?INFO("[~w] 正在启动...", [SrvName]),
    State = #state{process = SrvName},
    ?INFO("[~w] 启动完成", [SrvName]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(start_merge, State = #state{process = Process}) ->
    tables_merge(Process),
    merge_context:merge_finish(Process),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------

%% 加载所有数据
tables_merge(Process) ->
    {ok, List} = merge_data:tables(),
    TabList = [Table || Table = #merge_table{process = TProcess} <- List, TProcess =:= Process],
    SrvList = merge_util:all_server(),
    tables_merge_srv(TabList, SrvList),
    ok.

tables_merge_srv(_, []) -> ok;
tables_merge_srv(TabList, [Server| T]) ->
    tables_merge(TabList, Server),
    tables_merge_srv(TabList, T).
tables_merge([], _) -> ok;
tables_merge([Table = #merge_table{table = TableName} | T], Server = #merge_server{platform = Platform}) ->
    ?INFO("正在处理~s库表~-20s", [Platform, TableName]),
    S = util:unixtime(),
    merge_dao_behaviour:merge(Table#merge_table{server = Server}),
    E = util:unixtime(),
    {H, M, SS} = calendar:seconds_to_time(E - S),
    Time = util:fbin(<<"~w:~w:~w">>, [H, M, SS]),
    ?INFO("完成处理~s库表~-20s [~s]", [Platform, TableName, Time]),
    tables_merge(T, Server).
