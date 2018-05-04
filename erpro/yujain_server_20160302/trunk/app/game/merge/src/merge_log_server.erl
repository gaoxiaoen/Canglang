%% @filename merge_log_server.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016?1?29? 
%% @doc 
%% TODO Add description.

-module(merge_log_server).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1]).

%% 启动合服日志进程
-spec start(LogFile) -> Result when 
          LogFile :: string(),
          Result :: {ok,PId} | ignore | {error,Error},
          PId :: erlang:pid(),
          Error :: {already_started,PId} | term().
start(LogFile) ->
    gen_server:start({local, ?MODULE}, ?MODULE, [LogFile], []).

%% ====================================================================
%% Behavioural functions
%% ====================================================================
-record(state, {log_file=undefined}).

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
init([LogFile]) ->
    {ok, #state{log_file=LogFile}}.


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
handle_info({log,LogInfo}, State) ->
    do_log(State#state.log_file,LogInfo),
    {noreply, State};
handle_info({statistics,Info},State) ->
    do_statistics(State#state.log_file,Info),
    {noreply, State};
handle_info(_Info, State) ->
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

%% 书写日志到日志文件中
do_log(LogFile,{Module,Line,LogTime,Format,Args}) ->
    {{Y,Mo,D},{H,Mi,S}} = LogTime,
    Header = io_lib:format("[Merge]~w-~.2.0w-~.2.0w ~.2.0w:~.2.0w:~.2.0w ~s:~w  ", [Y, Mo, D, H, Mi, S, Module, Line]),
    HeaderBin = unicode:characters_to_binary(Header),
    file:write_file(LogFile, HeaderBin, [append, delayed_write]),
    try 
        LogMsg = io_lib:format(Format ++ "~n", Args),
        file:write_file(LogFile, LogMsg, [append, delayed_write])
    catch _:Error ->
            ErrMsg = io_lib:format("dump log to file error, Args=~w,Error=~w~n",[Args,Error]),
            file:write_file(LogFile, ErrMsg, [append, delayed_write])
    end,
    ok.
%% 写一行日志
do_line(LogFile,Format,Args) ->
    try 
        LogMsg = io_lib:format(Format ++ "~n", Args),
        file:write_file(LogFile, LogMsg, [append, delayed_write])
    catch _:Error ->
            ErrMsg = io_lib:format("dump log to file error, Args=~w,Error=~w~n",[Args,Error]),
            file:write_file(LogFile, ErrMsg, [append, delayed_write])
    end,
    ok.

%% 合服统计信息
do_statistics(LogFile,{0,MainDataList}) ->
    InfoList = get_statistics_info(),
    erase_statistics_info(),
    {{Y,Mo,D},{H,Mi,S}} = erlang:localtime(),
    Header = io_lib:format("[Merge] ~w-~.2.0w-~.2.0w ~.2.0w:~.2.0w:~.2.0w", [Y, Mo, D, H, Mi, S]),
    do_line(LogFile,"=====================================~s statistics report=====================================",[Header]),
    do_statistics(MainDataList,LogFile,InfoList),
    do_line(LogFile,"=======================================================================================================================",[]),
    erlang:whereis(merge_misc:get_merge_master_name()) ! ok,
    ok;
do_statistics(_LogFile,{ServerId,DataList}) ->
    add_statistics_info(ServerId,DataList),
    ok.

%% 处理统计信息，写入日志
do_statistics([],_LogFile,_InfoList) -> ok;
do_statistics([{SrcTab,_Tab,Size}|MainDataList],LogFile,InfoList) ->
    SubDataList = do_statistics2(InfoList,SrcTab,[]),
    case SubDataList of
        [] -> %% 此表没有参与数据合并不需要打印信息
            next;
        _ ->
            do_statistics3(LogFile,SrcTab,Size,SubDataList)
    end,
    do_statistics(MainDataList,LogFile,InfoList).
do_statistics2([],_SrcTab,DataList) -> DataList;
do_statistics2([{ServerId,SubDataList}|InfoList],SrcTab,DataList) ->
    case lists:keyfind(SrcTab, 1, SubDataList) of
        {SrcTab,_Tab,Size} ->
            do_statistics2(InfoList,SrcTab,[{ServerId,Size}|DataList]);
        _ ->
            do_statistics2(InfoList,SrcTab,DataList)
    end. 
do_statistics3(LogFile,SrcTab,Size,SubDataList) ->
    TotalSize = lists:sum([PSize || {_PServerId,PSize} <- SubDataList]),
    SortSubDataList = lists:sort(fun({A1,_A2},{B1,_B2}) -> A1 < B1 end, SubDataList),
    SubInfo = 
        lists:foldl(
          fun({PServerId,PSize},Acc) ->
                  case Acc of
                      "" ->
                          io_lib:format("    ~5s[~.6w]", [lists:concat(["S",PServerId]),PSize]);
                      _ ->
                          io_lib:format("~s    ~5s[~.6w]", [Acc,lists:concat(["S",PServerId]),PSize])
                  end
          end, "", SortSubDataList),
    StrTab = erlang:atom_to_list(SrcTab),
    case TotalSize == Size of
        true ->
            Str = io_lib:format("~-30s~s        ~.6w            OK", [StrTab,SubInfo,Size]);
        _ ->
            Str = io_lib:format("~-30s~s        ~.6w[~.6w]    WARNING", [StrTab,SubInfo,Size,TotalSize])
    end,
    do_line(LogFile,Str,[]),
    ok.



%% 统计数据缓存
get_statistics_info() ->
    case erlang:get(statistics_info) of
        undefined -> [];
        InfoList -> InfoList
    end.
add_statistics_info(ServerId,DataList) ->
    InfoList = get_statistics_info(),
    erlang:put(statistics_info, [{ServerId,DataList}|InfoList]).
erase_statistics_info() ->
    erlang:erase(statistics_info).
    
