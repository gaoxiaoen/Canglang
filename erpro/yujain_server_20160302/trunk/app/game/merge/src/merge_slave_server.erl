%% @filename merge_slave_server.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-02-01 
%% @doc 
%% 合服操作进程.

-module(merge_slave_server).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("merge.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/2]).

%% 启动合服进程
-spec start(ServerId,MasterPId) -> Result when 
          ServerId :: integer(),
          MasterPId :: erlang:pid(),
          Result :: {ok,PId} | ignore | {error,Error},
          PId :: erlang:pid(),
          Error :: {already_started,PId} | term().
start(ServerId,MasterPId) ->
    gen_server:start({local, ?MODULE}, ?MODULE, [ServerId,MasterPId], []).

%% ====================================================================
%% Behavioural functions
%% ====================================================================
-record(state, {server_id=0,master_pid=undefined}).

%% init/1
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:init-1">gen_server:init/1</a>
-spec init(Args :: term()) -> Result when
	Result :: {ok, State}
			| {ok, State, Timeout}
			| {ok, State, hibernate}
			| {stop, Reason :: term()}
			| ignore,
	State :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
init([ServerId,MasterPId]) ->
    case catch do_init(ServerId,MasterPId) of
        ok ->
            State = #state{server_id=ServerId,master_pid=MasterPId},
            set_process_state(State),
            {ok, State};
        {error,Reason} ->
            {stop,Reason}
    end.

%% handle_call/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_call-3">gen_server:handle_call/3</a>
-spec handle_call(Request :: term(), From :: {pid(), Tag :: term()}, State :: term()) -> Result when
	Result :: {reply, Reply, NewState}
			| {reply, Reply, NewState, Timeout}
			| {reply, Reply, NewState, hibernate}
			| {noreply, NewState}
			| {noreply, NewState, Timeout}
			| {noreply, NewState, hibernate}
			| {stop, Reason, Reply, NewState}
			| {stop, Reason, NewState},
	Reply :: term(),
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity,
	Reason :: term().
%% ====================================================================
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.


%% handle_cast/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_cast-2">gen_server:handle_cast/2</a>
-spec handle_cast(Request :: term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
			| {noreply, NewState, Timeout}
			| {noreply, NewState, hibernate}
			| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_cast(_Msg, State) ->
    {noreply, State}.


%% handle_info/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:handle_info-2">gen_server:handle_info/2</a>
-spec handle_info(Info :: timeout | term(), State :: term()) -> Result when
	Result :: {noreply, NewState}
			| {noreply, NewState, Timeout}
			| {noreply, NewState, hibernate}
			| {stop, Reason :: term(), NewState},
	NewState :: term(),
	Timeout :: non_neg_integer() | infinity.
%% ====================================================================
handle_info({'EXIT', _PId, _Reason}, State) ->
    {stop, normal, State};
handle_info(Info, State) ->
    try 
        do_handle_info(Info) 
    catch _:Reason -> 
              io:format("Info:~w,State=~w, Reason: ~w, strace:~w", [Info,State, Reason, erlang:get_stacktrace()]) 
    end,
    {noreply, State}.


%% terminate/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:terminate-2">gen_server:terminate/2</a>
-spec terminate(Reason, State :: term()) -> Any :: term() when
	Reason :: normal
			| shutdown
			| {shutdown, term()}
			| term().
%% ====================================================================
terminate(_Reason, _State) ->
    ok.


%% code_change/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_server.html#Module:code_change-3">gen_server:code_change/3</a>
-spec code_change(OldVsn, State :: term(), Extra :: term()) -> Result when
	Result :: {ok, NewState :: term()} | {error, Reason :: term()},
	OldVsn :: Vsn | {down, Vsn},
	Vsn :: term().
%% ====================================================================
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================
-define(LOOP_MILLISECONDS,200).

do_handle_info(slave_exec) ->
    slave_exec();

do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?MERGE_LOG("procces func apply result=~w",[Ret]),
    ok;

do_handle_info(Info)->
    ?MERGE_LOG("receive unknown message,Info=~w",[Info]),
    ok.

%% 初始化操作
do_init(ServerId,_MasterPId) ->
    DataFile = merge_misc:get_server_data_file(ServerId),
    case filelib:is_file(DataFile) of
        true ->
            next;
        _ ->
            erlang:throw({error,data_file_not_found})
    end,
    %% 执行
    erlang:self() ! slave_exec,
    ok.

%% 获取进程状态
get_process_state() ->
    erlang:get(process_state).
%% 设置进程状态
set_process_state(State) ->
    erlang:put(process_state, State).

%% 执行出错处理
-spec do_error(OpCode) -> ok when OpCode :: integer().
do_error(OpCode) ->
    #state{master_pid=MasterPId} = get_process_state(),
    MasterPId ! {error,OpCode},
    timer:sleep(1000),
    erlang:exit(erlang:self(), run_error_close),
    ok.
    

%% 执行合服
slave_exec() ->
    case catch do_slave_exec() of
        ok ->
            #state{master_pid=MasterPId} = get_process_state(),
            MasterPId ! ok,
            erlang:exit(erlang:self(), normal),
            ok;
        {error,OpCode} ->
            do_error(OpCode)
    end.
do_slave_exec() ->
    #state{server_id=ServerId} = get_process_state(),
    %% 恢复数据
    MergeTabFragList = do_restore(ServerId),
    %% 打印合并数据基本数据，即玩家数,宠物数,帮派数
    merge_misc:do_statistics(ServerId),
    %% 合并数据
    merge_migration:do(ServerId),
    %% 清除数据
    do_clean(MergeTabFragList,ServerId),
    ok.
%% 恢复数据
do_restore(ServerId) ->
    TabList = cfg_mnesia:find(tab_list),
    AllTableList = [T || #r_tab{table_name=T} <- TabList],
    [SkipTableList] = common_config_dyn:find(merge, skip_tables),
    MergeTableList = [T || T <- AllTableList, lists:member(T, SkipTableList) =:= false],
    %% 每次加载表的个数，0表示一次加载全部
    [RestoreTableNumber]=common_config_dyn:find(merge,restore_table_number),
    %% 处理分表
    TabFragList = lists:foldl(fun(T,AccTabList) -> db_misc:get_all_tab(T) ++ AccTabList end, [], AllTableList),
    MergeTabFragList = lists:foldl(fun(T,AccMergeTabList) -> db_misc:get_all_tab(T) ++ AccMergeTabList end, [], MergeTableList),
    TabFragDefList = lists:foldl(
                       fun(#r_tab{table_name=T}=TabDef,AccTabFragDefList) -> 
                               TabNameList = db_misc:get_all_tab(T),
                               [ TabDef#r_tab{table_name=TT} || TT <- TabNameList] ++ AccTabFragDefList 
                       end, [], TabList),
    %% 读取数据
    ok = do_restore(MergeTabFragList,ServerId,TabFragList,RestoreTableNumber),
    %% 创建新表
    ok = create_slave_table(MergeTabFragList,ServerId,TabFragDefList),
    %% 迁移数据
    ok = do_data_migration(MergeTabFragList,ServerId),
    %% 清除无用数据
    [mnesia:clear_table(T) || T <- MergeTabFragList],
    MergeTabFragList.
do_restore([],_ServerId,_AllTableList,_RestoreTableNumber) -> ok;
do_restore(MergeTableList,ServerId,AllTableList,RestoreTableNumber) ->
    case RestoreTableNumber =:= 0 
        orelse erlang:length(MergeTableList) >= RestoreTableNumber of
        true->
            NextMergeTableList= [],
            TableList = MergeTableList;
        false ->
            {TableList,NextMergeTableList} = lists:split(RestoreTableNumber, MergeTableList)
    end,
    SkipTableList = [ T || T <- AllTableList, lists:member(T, TableList) == false],
    ok = do_restore_data(ServerId,TableList,SkipTableList),
    do_restore(NextMergeTableList,ServerId,AllTableList,RestoreTableNumber).
%% 恢复表数据
do_restore_data(ServerId,TableList,SkipTableList) ->
    DataFile = merge_misc:get_server_data_file(ServerId),
    case mnesia:restore(DataFile, [{skip_tables, SkipTableList}]) of
        {atomic, _} ->
            next;
        {aborted, Error} ->
            ?MERGE_LOG("data restore fail.ServerId=~w,TableList=~w,Error=~w", [ServerId,TableList,Error]),
            erlang:throw({error,?MERGE_OP_CODE_904})
    end,
    ok.
%% 创建新表
create_slave_table([],_ServerId,_TabList) -> ok;
create_slave_table([Tab | MergeTableList],ServerId,TabList) ->
    #r_tab{type=Type,
           record_name=RecordName,
           record_fields= RecordFields,
           index_list=Intlist} = lists:keyfind(Tab, #r_tab.table_name, TabList),
    TableDef = [{ram_copies, [erlang:node()]},
                {type, Type},
                {record_name, RecordName},
                {attributes, RecordFields},
                {local_content, true},
                {index, Intlist}],
    NewTab = merge_misc:get_merge_table_name(Tab, ServerId),
    mnesia:create_table(NewTab, TableDef),
    create_slave_table(MergeTableList,ServerId,TabList).

%% 迁移数据
do_data_migration([],_ServerId) -> ok;
do_data_migration([Tab | MergeTableList],ServerId) ->
    NewTab = merge_misc:get_merge_table_name(Tab, ServerId),
    merge_misc:do_migration_record(Tab,NewTab),
    do_data_migration(MergeTableList,ServerId).

%% 清除已经完成合并操作的数据
do_clean([],_ServerId) -> ok;
do_clean([Tab | TabList],ServerId) ->
    NewTab = merge_misc:get_merge_table_name(Tab, ServerId),
    case mnesia:delete_table(NewTab) of
        {atomic, _} ->
            next;
        {aborted, Error} ->
            ?MERGE_LOG("delete table error.ServerId=~w,NewTab=~w,Error=~w", [ServerId,NewTab,Error])
    end,
    do_clean(TabList,ServerId).
