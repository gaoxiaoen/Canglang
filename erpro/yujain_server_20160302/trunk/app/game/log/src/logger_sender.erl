%%% -------------------------------------------------------------------
%%% Author  :markycai<tomarky.cai@gmail.com>
%%% Description : 发送日志
%%% 游戏服进程，发送日志失败后会将日志写文件，通过该进程尝试写回游戏服
%%% Created : 2013-10-21
%%% -------------------------------------------------------------------
-module(logger_sender).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("logger.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start/0,
         start_link/0,
         log/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% 将日志写文件时间间隔
-define(write_log_interval,60).
%% 每次批量发送日志长度
-define(multi_send_log_num,20).
%% ====================================================================
%% External functions
%% ====================================================================

start()->
    {ok,_} = supervisor:start_child(mgeew_sup,{?MODULE,
                                               {?MODULE,start_link,[]},
                                               temporary, infinity, worker,
                                               [?MODULE]}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).


log(Log)->
    AcceptorName = logger_tool:get_receiver_name(),
    case catch global:send(AcceptorName, {log,Log}) of
        Pid when is_pid(Pid) ->
            ok;
        _->
            ?TRY_CATCH(erlang:send(?MODULE, {log,Log}),Err)
    end.


%% ====================================================================
%% Server functions
%% ====================================================================
init([]) ->
    erlang:process_flag(trap_exit, true),
    
    %% 日志列表
    set_log_list([]),
    %% 写数据倒计时
    set_dump_count_down(?write_log_interval),
    %% 创建日志目录
    LogDir= cfg_logger:find(log_dir),
    file:make_dir(LogDir),
    %% 创建日志文件
    erlang:send_after(1000, self(), loop),
    {ok,[]}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Request, State) ->
    {noreply,  State}.

handle_info({'EXIT', _, _Reason}, State) ->
    {stop, normal, State};

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info,State),
    {noreply, State}.

terminate(Reason, State) ->
    dump_log3(),
    {stop,Reason, State}.

code_change(_Request,_Code,_State)->
    ok.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

%% 当日志无法写入日志服，则将日志写入本地文件
do_handle_info({log,Log})->
    add_log_list(Log);

do_handle_info(loop)->
    erlang:send_after(1000,self(),loop),
    loop();

%% 执行函数处理
do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok.

%% 1.将日志队列写入文件
%% 2.判断当前与日志服的连接状态
%% 3.读取日志文件日志
%% 4.删除日志文件
%% 5.将日志文件发送到日志服
loop()->
    dump_log(),
    resend_log(),
    ok.


%% 持久化日志
dump_log()->
    catch dump_log2().

dump_log2()->
    Count = get_dump_count_down(),
    case Count > 0 of
        true->
            set_dump_count_down(Count-1),
            erlang:throw(ignore);
        false->
            set_dump_count_down(?write_log_interval)
    end,
    dump_log3().

dump_log3()->
    case get_log_list() of
        []->
            ignore;
        LogList->
            LogContent = 
                lists:foldl(
                  fun(Log,Acc)->
                          io_lib:format("~p.\n", [Log])++Acc
                  end, [], LogList),
            LogDir= cfg_logger:find(log_dir),
            {Y,M,D} = erlang:date(),
            {HH,MM,SS}=erlang:time(),
            LogFile = common_lang:get_format_lang_resources("~s/~s_~s_~s_~s_~s_~s.log", [LogDir,Y,M,D,HH,MM,SS]),
            file:write_file(LogFile, LogContent),
            set_log_list([])
    end.
    


resend_log()->
    catch resend_log2().

resend_log2()->
    %% 是否有日志接收进程
    AcceptorName = logger_tool:get_receiver_name(),
    case global:whereis_name(AcceptorName) of
        undefined->
            erlang:throw(ignore);
        _->
            next
    end,
    %% 获取游戏服保留的日志
    case get_log_list() of
        []->
            %% 从日志文件中获取日志
            LogDir= cfg_logger:find(log_dir),
            {ok,LogFileList}=file:list_dir(LogDir),
            case LogFileList of
                []->
                    erlang:throw(ignore),
                    LogList = [];
                [LogFileName|_]->
                    FileDir = LogDir++LogFileName,
                    {ok,LogList} = file:consult(FileDir),
                    file:delete(FileDir)
            end;
        LogList->
            next
    end,
    case LogList  of
        []->
            erlang:throw(ignore);
        _->
            ignore
    end,
    case erlang:length(LogList) > ?multi_send_log_num of
        true->
            {SendList,RestLogList} = lists:split(?multi_send_log_num, LogList);
        false->
            SendList = LogList,
            RestLogList = []
    end,
    resend_log3(SendList),
    set_log_list(RestLogList).

resend_log3(SendList)->
    SendList2 = 
        lists:foldl(
          fun(Log,Acc)->
                  [LogKey|LogData] = tuple_to_list(Log),
                  case lists:keyfind(LogKey, #r_log_type.record_name, cfg_logger:find(log_type_list)) of
                      false->
                          ?ERROR_MSG("LogType does not exist.：~w",[{LogKey,LogData}]),
                          Acc;
                      #r_log_type{default_record=DefaultRecord}->
                          DefLog=tuple_to_list(DefaultRecord),
                          [format_data([LogKey|LogData],DefLog)|Acc]
                  end
          end,[],SendList),
    log(SendList2).

format_data(Log,DefLog)->
    Length1 = erlang:length(Log),
    Length2 = erlang:length(DefLog),
    if 
        Length1 < Length2 ->
            list_to_tuple(Log ++ lists:sublist(DefLog, Length1+1, Length2 - Length1));
        true ->
            list_to_tuple(lists:sublist(Log, Length2))
    end.

get_dump_count_down()->
    erlang:get(log_dump_count_down).

set_dump_count_down(Count)->
    erlang:put(log_dump_count_down,Count).


add_log_list(LogList) when is_list(LogList)->
    set_log_list(LogList ++ get_log_list());
add_log_list(Log) ->
    set_log_list([Log|get_log_list()]).

set_log_list(Queue)->
    erlang:put(log_list, Queue).

get_log_list()->
    erlang:get(log_list).
