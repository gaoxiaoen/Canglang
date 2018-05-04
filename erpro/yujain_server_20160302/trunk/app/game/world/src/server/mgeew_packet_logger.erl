%% Author: Haiming Li
%% Created: 2013-3-4
%% Description: 玩家消息包日志进程
-module(mgeew_packet_logger).
-behaviour(gen_server).
-include("mgeew.hrl").

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
-export([start/0,
         start_link/0,
         set_statistic_action/2
        ]).
-record(state, {}).

-define(DUMP_INTERVAL, 15). %%15秒写一次到文件里面 
-define(statistic_type_receive,rece).       %% 接收包统计
-define(statistic_type_send,send).          %% 发送包统计
start() ->
    {ok, _} = supervisor:start_child(mgeew_sup, {?MODULE,
                                                 {?MODULE, start_link, []},
                                                 permanent, 30000, worker, 
                                                 [?MODULE]}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    filelib:ensure_dir(get_log_file_dir()),
    erlang:send_after(1000, self(), {self_loop}),
    set_role_list([]),
    set_last_dump_seconds(common_tool:now()),
    {ok, #state{}}.

handle_call(Request, _From, State) ->
    Reply = do_handle_call(Request),
    {reply, Reply, State}.
handle_cast(_Msg, State) ->
    {noreply, State}.
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info,State),
    {noreply, State}.
terminate(_Reason, _State) ->
    case get_role_list() of
        RoleIdList when is_list(RoleIdList) andalso length(RoleIdList) > 0 ->
            [begin ?TRY_CATCH(dump_role_logs(RoleId), Err) end || RoleId <- RoleIdList];
        _ ->
            ignore
    end,
    ok.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_call(Request) ->
    ?ERROR_MSG("receive unknown call request,Info=~w", [Request]),
    ok.

do_handle_info({self_loop}) ->
    self_loop(common_tool:now());

do_handle_info({packet, Info}) ->
    do_log_packet(Info);

do_handle_info({statistic, Info}) ->
    do_statistic(Info);
do_handle_info({statistic_action, RoleId, Action}) ->
    do_statistic_action(RoleId, Action),
    ok;

do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;

do_handle_info(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]),
    ignore.

set_statistic_action(RoleId,Action) ->
    ?TRY_CATCH(erlang:send(mgeew_packet_logger, {statistic_action,RoleId,Action}),ErrPacketLogger),
    ok.

self_loop(NowSeconds) ->
    erlang:send_after(1000, self(), {self_loop}),
    do_dump_logs(NowSeconds),
    dump_role_statistic(NowSeconds),
    ok.

do_dump_logs(NowSeconds) ->
    %% dump数据
    case NowSeconds - get_last_dump_seconds() > ?DUMP_INTERVAL of
        true ->
            set_last_dump_seconds(NowSeconds),
            case get_role_list() of
                RoleIdList when is_list(RoleIdList) andalso length(RoleIdList) > 0 ->
                    [begin ?TRY_CATCH(dump_role_logs(RoleId), Err) end || RoleId <- RoleIdList];
                _ ->
                    ignore
            end;
        _ -> ignore
    end.

dump_role_logs(RoleId) ->
    RoleLogs = get_role_logs(RoleId),
    case length(RoleLogs) > 0 of
        true ->
            LogFile = get_log_file(RoleId),
            BinContent = list_to_binary(lists:reverse(RoleLogs)),
            ok = file:write_file(LogFile, BinContent, [append]),
            set_role_logs(RoleId, []);
        _ -> ignore
    end.
    
    
do_log_packet({RoleId, Module, Method, Record, ByteSize}) ->
    RoleIdList = get_role_list(),
    case lists:member(RoleId, RoleIdList) of 
        true -> ignore;
        _ -> set_role_list([RoleId | RoleIdList])
    end,
    Log = format_log(Module, Method, Record),
    append_role_log(RoleId, Log),
    %% 统计接收包大小
    Data = {Method,ByteSize},
    add_role_statistic(RoleId,?statistic_type_receive,Data),
    add_statistic_role_list(RoleId,?statistic_type_receive),
    ok.

format_log(Module, Method, Record)->
    DateNow = common_tool:seconds_to_datetime_string(common_tool:now()),
    {StrMod,StrMethod}=get_mm(Module,Method),
    io_lib:format("[~s]:[~w][~w]:~w~n", [DateNow, StrMod, StrMethod, Record]).

get_mm(Mod,Method)-> 
    case mm_map:mod(Mod) of
        undefined ->
            StrMod = Mod;
        StrMod ->
            next
    end,
    case mm_map:method(Method) of
        undefined ->
            StrMethod = Method;
        StrMethod ->
            next
    end,
    {StrMod,StrMethod}. 

get_role_list() ->
    get({packet_logger, role_list}).
set_role_list(List) ->
    put({packet_logger, role_list}, List).

get_role_logs(RoleID) ->
    case get({packet_logger, RoleID}) of
        undefined -> [];
        Logs -> Logs
    end.
set_role_logs(RoleID, Logs) ->
    put({packet_logger, RoleID}, Logs).
append_role_log(RoleID, Log) ->
    set_role_logs(RoleID, [Log | get_role_logs(RoleID)]).

get_last_dump_seconds() ->
    get({packet_logger, last_dump_seconds}).

set_last_dump_seconds(Seconds) ->
    put({packet_logger, last_dump_seconds}, Seconds).

get_log_file_dir() ->
    LogDir = main_exec:get_log_dir(),
    lists:concat([LogDir,"/packet.logs/"]).

get_log_file(RoleId) ->
    lists:concat( [get_log_file_dir(),RoleId,".log"] ).

%% 统计发包
do_statistic({RoleId,Method,ByteSize}) ->
    Data = {Method,ByteSize},
    add_role_statistic(RoleId,?statistic_type_send,Data),
    add_statistic_role_list(RoleId,?statistic_type_send),
    ok.


get_statistic_role_list() ->
    case erlang:get({role_statistic, role_list}) of
        undefined -> [];
        RoleIdList -> RoleIdList
    end.
set_statistic_role_list(RoleIdList) ->
    erlang:put({role_statistic, role_list}, RoleIdList).
add_statistic_role_list(RoleId,StatisticType) ->
    RoleIdList = get_statistic_role_list(),
    case lists:member({StatisticType,RoleId}, RoleIdList) of
        true ->
            next;
        _ ->
            set_statistic_role_list([{StatisticType,RoleId} | RoleIdList])
    end.

%% StatisticType :: ?statistic_type_receive | ?statistic_type_send
get_role_statistic(RoleId,StatisticType) ->
    case erlang:get({role_statistic,StatisticType,RoleId}) of
        undefined -> [];
        DataList -> DataList
    end.
set_role_statistic(RoleId,StatisticType,DataList) ->
    erlang:put({role_statistic,StatisticType,RoleId}, DataList).
add_role_statistic(RoleId,StatisticType,Data) ->
    set_role_statistic(RoleId, StatisticType, [Data | get_role_statistic(RoleId,StatisticType)]).

get_role_statistic_lock(RoleId) ->
    case erlang:get({role_statistic_lock,RoleId}) of
        undefined -> false;
        Flag -> Flag
    end.
set_role_statistic_lock(RoleId,Lock) ->
    case get_role_statistic_lock(RoleId) of
        Lock ->
            ignore;
        _ ->
            erlang:put({role_statistic_lock,RoleId}, Lock)
    end.
erase_role_statistic_lock(RoleId) ->
    erlang:erase({role_statistic_lock,RoleId}).

do_statistic_action(RoleId, Action) ->
    case Action of
        dump ->
            NowSeconds = common_tool:now(),
            dump_role_statistic({?statistic_type_receive,RoleId},NowSeconds,0),
            dump_role_statistic({?statistic_type_send,RoleId},NowSeconds,0),
            set_role_statistic_lock(RoleId,true);
        clean ->
            erase_role_statistic_lock(RoleId),
            NowSeconds = common_tool:now(),
            dump_role_statistic({?statistic_type_receive,RoleId},NowSeconds,0),
            dump_role_statistic({?statistic_type_send,RoleId},NowSeconds,0);
        _ ->
            ignore
    end.

%% 统计分析
dump_role_statistic(NowSeconds) ->
    Interval = 60, %% 每多少秒统计分析一下发送的包数量
    case NowSeconds rem Interval of
        0 ->
            RoleIdList = get_statistic_role_list(),
            dump_role_statistic2(RoleIdList,NowSeconds,Interval),
            ok;
        _ ->
            ok
    end.

dump_role_statistic({StatisticType,RoleId},NowSeconds,Interval) ->
    dump_role_statistic2([{StatisticType,RoleId}],NowSeconds,Interval).

dump_role_statistic2([],_NowSeconds,_Interval) ->
    ok;
dump_role_statistic2([{StatisticType,RoleId}|RoleIdList],NowSeconds,Interval) ->
    case get_role_statistic_lock(RoleId) of
        true ->
            dump_role_statistic2(RoleIdList,NowSeconds,Interval);
        _ ->
            case get_role_statistic(RoleId,StatisticType) of
                [] ->
                    next;
                DataList ->
                    set_role_statistic(RoleId,StatisticType,[]),
                    dump_role_statistic3(RoleId,StatisticType,NowSeconds,Interval,DataList)
            end,
            dump_role_statistic2(RoleIdList,NowSeconds,Interval)
    end.

dump_role_statistic3(RoleId,StatisticType,NowSeconds,Interval,DataList) ->
    {TotalNumber,TotalByteSize,StatisticList} = dump_role_statistic4(DataList,0,0,[]),
    DateNow = common_tool:seconds_to_datetime_string(NowSeconds),
    HMsg = io_lib:format("[~s]:statistic ~w seconds:TotalPacketNumber=~w,TotalByteSize=~wKB=~wB~n", [DateNow, Interval, TotalNumber, TotalByteSize div 1024, TotalByteSize]),
    LogFile = get_statistic_file(RoleId,StatisticType),
    HMsgBin = erlang:list_to_binary(HMsg),
    ok = file:write_file(LogFile, HMsgBin, [append]),
    SortStatisticList = lists:sort(
                          fun({_,NumberA,_},{_,NumberB,_}) -> 
                                  NumberA > NumberB
                          end, StatisticList),
    lists:foreach(
      fun({Method,Number,ByteSize}) ->
              Msg = io_lib:format("statistics:Method=~w,PacketNumber=~w,ByteSize=~wKB=~wB~n", [Method,Number,ByteSize div 1024, ByteSize]),
              MsgBin = erlang:list_to_binary(Msg),
              ok = file:write_file(LogFile, MsgBin, [append]) 
      end, SortStatisticList),
    ok.

dump_role_statistic4([],TotalNumber,TotalByteSize,StatisticList) ->
    {TotalNumber,TotalByteSize,StatisticList};
dump_role_statistic4([{Method,ByteSize}|DataList],TotalNumber,TotalByteSize,StatisticList) ->
    case lists:keyfind(Method, 1, StatisticList) of
        false ->
            NewStatisticList = [{Method,1,ByteSize} | StatisticList];
        {Method,OldNumber,OldByteSize} ->
            NewStatisticList = lists:keyreplace(Method, 1, StatisticList, {Method,OldNumber + 1,OldByteSize + ByteSize})
    end,
    dump_role_statistic4(DataList,TotalNumber + 1,TotalByteSize + ByteSize,NewStatisticList).
            

get_statistic_file(RoleId,StatisticType) ->
    LogDir = main_exec:get_log_dir(),
    lists:concat([LogDir,"/packet.logs/statistic_",StatisticType,"_",RoleId,".log"]).