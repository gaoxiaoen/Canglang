%%%-------------------------------------------------------------------
%%% File        :mgeew_monitor_server.erl
%%% @doc
%%%     性能监控服务器
%%% @end
%%%-------------------------------------------------------------------
-module(mgeew_monitor_server).
-behaviour(gen_server).
-record(state,{}).


-export([start_link/0]).
-export([send_monitor/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(ETS_MONITOR_DATA,ets_monitor_data).
%%定时发消息进行持久化
-define(DUMP_INTERVAL, 60 * 1000).
-define(MSG_DUMP_LOG, dump_monitor_data).
-define(LOG_QUEUE, log_queue).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("mgeew.hrl").


%% ====================================================================
%% API functions
%% ====================================================================

send_monitor(MonitorRec)->
    case erlang:whereis(?MODULE) of
        undefined-> ignore;
        PID ->
            erlang:send(PID, {monitor_data,MonitorRec})
    end.


%% ====================================================================
%% External functions
%% ====================================================================

start_link()  ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [],[]).

init([]) -> 
    ets:new(?ETS_MONITOR_DATA, [named_table, set, protected]),
    erlang:send_after(?DUMP_INTERVAL, self(), ?MSG_DUMP_LOG),
    State = #state{},
    {ok, State}.
 
 
%% ====================================================================
%% Server functions
%%      gen_server callbacks
%% ====================================================================
handle_call(_Request, _From, State) ->
    Reply = ok,
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

%% MonitorRec = {Node,Type,TimeStamp,DataList}
do_handle_info({monitor_data,MonitorRec})->
    ets:insert(?ETS_MONITOR_DATA, MonitorRec);

do_handle_info(?MSG_DUMP_LOG)->
    do_dump_monitor_data(),
    erlang:send_after(?DUMP_INTERVAL, self(), ?MSG_DUMP_LOG);

do_handle_info(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]),
    ignore.

do_dump_monitor_data()->
    %% 将ets数据dump到文件或DB中
    LogDir = main_exec:get_log_dir(),
    MonitorLogDir = lists:concat([LogDir,"/monitor/"]),
    case create_log_dir(MonitorLogDir) of
        ok->
            LogFileName = get_log_file_name(MonitorLogDir),
            LogList = ets:tab2list(?ETS_MONITOR_DATA),
            Now = common_tool:time_format(erlang:now()),
            NodeList = do_dump_monitor_data2(LogList,[]),
            Format = "~s:{~w,~w},~w\n",
            lists:foreach(
              fun(PNode) ->
                      case erlang:get(PNode) of
                          undefined ->
                              next;
                          LogDataList ->
                              [ begin 
                                    case file:write_file(LogFileName, common_tool:to_binary( io_lib:format( Format,[Now,Node,Type,DataList]) ), [append]) of
                                        ok -> ok;
                                        {error,Reason} ->
                                            ?WARNING_MSG("write the log data for the mcs monitor is fail, ~p\n",[Reason]),
                                            ignore
                                    end
                                end || {{Node,Type},_TimeStamp,DataList} <- LogDataList],
                              erlang:erase(PNode)
                      end
              end, NodeList),
            file:write_file(LogFileName, <<"=====================\n">>, [append]);
        {error,Reason}->
            ?ERROR_MSG("create_log_dir failed!Path=~w,Reason=~w",[MonitorLogDir,Reason])
    end,
    ets:delete_all_objects(?ETS_MONITOR_DATA),
    ok.

do_dump_monitor_data2([],NodeList) ->
    NodeList;
do_dump_monitor_data2([H|T],NodeList) ->
    {{Node,Type},TimeStamp,DataList} = H,
    case Type of
        monitor_map_msg ->
            %%dump to mysql
            ValList = [[ TimeStamp,MapName,Node,OnlineNum,MLen ] ||{_PID,MapName,OnlineNum,MLen}<-DataList],
            update_queue(?LOG_QUEUE,ValList);
        _ -> 
            case erlang:get(Node) of
                undefined ->
                    erlang:put(Node, [H]);
                Queues ->
                    erlang:put(Node,[H|Queues])
            end,
            case lists:member(Node, NodeList) of
                true ->
                    do_dump_monitor_data2(T,NodeList);
                _ ->
                    do_dump_monitor_data2(T,[Node|NodeList])
            end
    end.

%%@doc 将数据更新到log的队列
update_queue(TheKey,ValList)->
    case get(TheKey) of
        undefined ->
            put(TheKey, ValList);
        Queues ->
            put( TheKey,ValList ++ Queues )
    end.

%% @spec create_log_dir(LogDir)-> ok | {error, Reason}
create_log_dir(LogDir)->
    case filelib:is_dir(LogDir) of
        false ->
            file:make_dir(LogDir);
        true -> 
            ok
    end.

%% @spec get_log_file_name(LogDir,LogMode,Suffix)-> string()
get_log_file_name(LogDir)->
    [GameName] = common_config_dyn:find_common(game_name),
    [AgentName] = common_config_dyn:find_common(agent_name),
    [ServerName] = common_config_dyn:find_common(server_name),
    FileName = common_tool:date_format(),
    lists:concat([LogDir, "/",GameName,"_",AgentName,"_",ServerName,"_", FileName, ".log"]).


