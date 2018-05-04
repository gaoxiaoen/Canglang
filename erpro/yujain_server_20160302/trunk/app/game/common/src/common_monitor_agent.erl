%%%-------------------------------------------------------------------
%%% File        :common_monitor_agent.erl
%%% @doc
%%%     common_monitor_agent 每个erlang节点对应的监控agent
%%% @end
%%% Created : 2010-12-15
%%%-------------------------------------------------------------------
-module(common_monitor_agent).
-behaviour(gen_server).
-record(state,{sup_list}).


-export([start_link/1]).
-export([top_msg/1,top_msg/2]).

-export([
         set_monitor_alert/1,
         set_monitor_sys/1,
         set_monitor_map_msg/1,
         set_monitor_line_msg/1,
         set_monitor_mnesia/1
        ]).


%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%%定时发消息给monitor_server
-define(MONITOR_INTERVAL, 60 * 1000).
-define(MSG_DO_MONITOR, msg_do_monitor).
-define(ALERT_MSG_LEN,300).
-define(MONITOR_DATA_QUEUE,monitor_data_queue).
-define(LAST_NODESLIST,last_nodeslist).


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-include("common_server.hrl").
-define(SERVER,monitor_agent).


%% ====================================================================
%% API functions
%% ====================================================================

top_msg(TopN) when is_integer(TopN)->
    top_msg(sup,TopN);
top_msg(Type) when is_atom(Type)->
    top_msg(Type,10).

top_msg(Type,TopN) when (Type=:=sup) orelse (Type=:=all) ->
    gen_server:call(?SERVER, {top_msg,Type,TopN}).

-define(MONITOR_ALERT,monitor_alert).
-define(MONITOR_SYS,monitor_sys).
-define(MONITOR_MAP_MSG,monitor_map_msg).
-define(MONITOR_LINE_MSG,monitor_line_msg).
-define(MONITOR_MNESIA,monitor_mnesia).

set_monitor_alert(BoolVal) when is_boolean(BoolVal)->
    gen_server:call(?SERVER,{set_monitor,?MONITOR_ALERT,BoolVal}).
set_monitor_sys(BoolVal) when is_boolean(BoolVal)->
    gen_server:call(?SERVER,{set_monitor,?MONITOR_SYS,BoolVal}).
set_monitor_map_msg(BoolVal) when is_boolean(BoolVal)->
    gen_server:call(?SERVER,{set_monitor,?MONITOR_MAP_MSG,BoolVal}).
set_monitor_line_msg(BoolVal) when is_boolean(BoolVal)->
    gen_server:call(?SERVER,{set_monitor,?MONITOR_LINE_MSG,BoolVal}).
set_monitor_mnesia(BoolVal) when is_boolean(BoolVal)->
    gen_server:call(?SERVER,{set_monitor,?MONITOR_MNESIA,BoolVal}).

%% ====================================================================
%% External functions
%% ====================================================================

start_link(SupList) when is_list(SupList) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [SupList],[]).

init([SupList]) ->
    erlang:send_after(?MONITOR_INTERVAL, self(), ?MSG_DO_MONITOR),
    
    put(?MONITOR_ALERT,true),
    put(?MONITOR_DATA_QUEUE,[]),
    State = #state{sup_list=SupList},
    {ok, State}.
 
 
%% ====================================================================
%% Server functions
%%      gen_server callbacks
%% ====================================================================
handle_call(Request, _From, State) ->
    Reply = try 
                do_handle_call(Request,State) 
            catch _:Reason -> 
                      ?ERROR_MSG("Req:~w,State=~w, Reason: ~w, strace:~w", [Request,State, Reason, erlang:get_stacktrace()]),
                      error
            end,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info,State),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
get_sup_process_list()->
    erlang:processes().

do_handle_call({top_msg,sup,TopN},_State)->
    get_top_msg_list( get_sup_process_list(),TopN);
do_handle_call({top_msg,all,TopN},_State)->
    get_top_msg_list( erlang:processes(),TopN);


do_handle_call({set_monitor,Type,Val},_State)->
    put(Type,Val),
    ok;
do_handle_call(_Request, State) ->
    Reply = ok,
    {reply, Reply, State}.

do_handle_info(?MSG_DO_MONITOR)->
    do_monitor_data(),
    
    erlang:send_after(?MONITOR_INTERVAL, self(), ?MSG_DO_MONITOR);

do_handle_info({set_monitor,Type,Val})->
    put(Type,Val);

do_handle_info(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]),
    ignore.

%%@doc 获取所有进程的 top_msg
get_top_msg_list(ProcList,TopN)->
    List = [ get_proc_msg(P) ||P<-ProcList],
    RList = lists:filter(fun({_P,_Name,Len})-> Len>0 end,List),
    sort_top_msg_list(RList,TopN).

%% get_children_process(SupRef)->
%%     List = supervisor:which_children(SupRef),
%%     ChildList = lists:filter(fun({_Id,Child,Type,_Modules})-> 
%%                                      Child =/= undefined andalso Type =:=worker
%%                              end, List),
%%     [ Child||{_Id,Child,_Type,_Modules}<-ChildList ].

%%@doc 对结果进行排序
sort_top_msg_list(List1,TopN)->
    List2 = 
        lists:sort(
          fun(E1,E2)->
                  {_,_,Len1} = E1,
                  {_,_,Len2} = E2,
                  Len1>Len2
          end, List1),
    case TopN of
        0-> List2;
        _ ->
            lists:sublist(List2, TopN)
    end.

%%@doc 获取指定进程的消息队列长度
get_proc_msg(undefined)->
    {undefined, [], 0};
get_proc_msg(P)->
    RegName = case erlang:process_info(P, registered_name) of
                  {registered_name,RegName2}-> RegName2;
                  _ -> []
              end,
    MLen = case erlang:process_info(P,message_queue_len) of
               {message_queue_len,MLen2} -> MLen2;
               _ -> 0
           end,
    {P, RegName, MLen}.

-define(CHECK_UPDATE_QUEUE(Key,ValList),
        case get(Key) of
            true->
                update_monitor_data_queue(Key, ValList );
            _-> ignore
        end).

do_monitor_data()->
    ?CHECK_UPDATE_QUEUE( ?MONITOR_ALERT,get_monitor_alert_list() ),
    ?CHECK_UPDATE_QUEUE( ?MONITOR_SYS,get_monitor_sys_list() ),
    ?CHECK_UPDATE_QUEUE( ?MONITOR_MAP_MSG,get_monitor_map_list() ),
    ?CHECK_UPDATE_QUEUE( ?MONITOR_LINE_MSG,get_monitor_line_list() ),
    ?CHECK_UPDATE_QUEUE( ?MONITOR_MNESIA,get_monitor_mnesia() ),

    send_monitor(),
    ok.

%%@doc 获取消息长度超过警告值的列表
get_monitor_alert_list()->
    ProcList = get_sup_process_list(),
    RList = get_monitor_alert_list2(ProcList,[]),
    case RList of
        []->[];
        _ ->
            sort_top_msg_list(RList,5)
    end.
get_monitor_alert_list2([],MsgLenList) ->
    MsgLenList;
get_monitor_alert_list2([PId|T],MsgLenList) ->
    {P, RegName, MLen} = get_proc_msg(PId),
    case MLen > ?ALERT_MSG_LEN of
        true ->
            get_monitor_alert_list2(T,[{P, RegName, MLen}|MsgLenList]);
        _ ->
            get_monitor_alert_list2(T,MsgLenList)
    end.
    
get_last_nodeslist()->
    case get(?LAST_NODESLIST) of
        undefined->
            [];
        List ->
            List
    end.
    
%%@doc 获取系统的监控信息
get_monitor_sys_list()->
    PortsCount   = length( erlang:ports() ),
    ProcCount    = erlang:system_info(process_count),  
    
    CurNodesList = lists:sort( [node()|nodes()] ),
    LastNodesList = get_last_nodeslist(),
    NodesCount  = length(CurNodesList),
    LastNodesCount = length(LastNodesList),
    case NodesCount=/=LastNodesCount orelse CurNodesList =/= LastNodesList of
        true->
            PrintNodes = {nodes,LastNodesList},
            put(?LAST_NODESLIST,CurNodesList);
        _ ->
            PrintNodes = {nodes,[]}
    end,
    
    MemTotal     = ( erlang:memory(total) div 1024 div 1024 ), %% 换算之后单位为M
    
    [{ports,PortsCount},{proc_count,ProcCount},{nodes_count,NodesCount},PrintNodes,{mem_total,MemTotal}].


get_monitor_map_info(MapName,OnlineNum)->
    case erlang:whereis(MapName) of
        undefined->
            {undefined,MapName,0,0};
        PID->
            {message_queue_len,MLen} = erlang:process_info(PID,message_queue_len),
            {PID,MapName,OnlineNum,MLen}
    end.

%%@doc 获取（本节点的）地图进程的监控信息
%%  【优化】只获取MsgLen>0的数据
get_monitor_map_list()->
    get_monitor_map_list2(erlang:processes(),[]).
get_monitor_map_list2([],ResultList) ->
    ResultList;
get_monitor_map_list2([PId|T],ResultList) ->
    case erlang:process_info(PId,registered_name) of
        {registered_name,ProcessName} ->
            case common_tool:to_list(ProcessName) of
                "map_" ++ _ ->
                    case get_monitor_map_info(ProcessName,0) of
                        {_,_,_,0}->
                            get_monitor_map_list2(T,ResultList);
                        Info ->
                            get_monitor_map_list2(T,[Info|ResultList])
                    end;
                _ ->
                    get_monitor_map_list2(T,ResultList)
            end;
        _ ->
            get_monitor_map_list2(T,ResultList)
    end.
    
%%@doc 获取分线服务器的监控信息
get_monitor_line_list()->
    [[{_IntranetIP,_ExternalIP,PortList}|_]] = common_config_dyn:find_common(gateway),
    [ begin 
          UC_PID = erlang:whereis(common_misc:get_unicast_server_name(Port)),
          get_proc_msg(UC_PID)  
      end || Port <- PortList].


%% 获取Mnesia表更新数据
get_monitor_mnesia() ->
    TableList = lists:delete(schema, mnesia:system_info(local_tables)),
    DataList = get_monitor_mnesia2(TableList,[]),
    lists:sort(
          fun({_TableA,SizeA},{_TableB,SizeB})->
                  SizeA>SizeB
          end, DataList).

get_monitor_mnesia2([],DataList) ->
    DataList;
get_monitor_mnesia2([Table | TableList],DataList) ->
    Size = mnesia:table_info(Table,memory),
%%     case Size > 0 of %% 1024 * 1024 * 100 = 104857600 = 100M
    case Size * 8 > 104857600 of %%  1024 * 1024 * 100 = 104857600 = 100M
        true ->
            get_monitor_mnesia2(TableList,[{Table,erlang:integer_to_list(erlang:trunc(Size * 8 div 104857600)) ++ "M"}|DataList]);
        _ ->
            get_monitor_mnesia2(TableList,DataList)
    end.


%%@doc 更新监控数据Queue
%% MonitorRec = {{Node,Type},TimeStamp,DataList}
update_monitor_data_queue(_Type,[])->
    ignore;
update_monitor_data_queue(Type,DataList)->
    Node = node(),
    TimeStamp = common_tool:now(),
    MonitorRec = {{Node,Type},TimeStamp,DataList},
    case get(?MONITOR_DATA_QUEUE) of
        undefined->
            put(?MONITOR_DATA_QUEUE,[MonitorRec]);
        Queue ->
            put(?MONITOR_DATA_QUEUE,[MonitorRec|Queue])
    end.


    

%%@doc 发送监控数据
%% MonitorRecList = [MonitorRec]
%% MonitorRec = {{Node,Type},TimeStamp,DataList}
send_monitor()->
    case erlang:whereis(mgeew_monitor_server) of
        undefined-> %%monitor_server可能还没启动 
            ignore;
        PID ->
            case get(?MONITOR_DATA_QUEUE) of
                []->ignore;
                MonitorRecList ->
                    erlang:send(PID, {monitor_data,MonitorRecList})
            end
    end,
    put(?MONITOR_DATA_QUEUE,[]).
