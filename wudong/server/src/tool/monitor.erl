%% @author zj
%% @created 2014.3.19
%% @email 1812338@gmail.com
%% @doc 游戏系统监控进程


-module(monitor).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-define(MONITORPID,"MONITOR_PID").
-define(RTIME,3600000).
-define(RTIMEDAY,86400000).
%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).
-include("common.hrl").
start_link() ->
    gen_server:start_link({local,?MODULE},?MODULE, [], []).

%%获取进程
get_pid() ->
    case get(?MONITORPID) of
        undefined ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid)->
                    put(?MONITORPID,Pid),
                    Pid;
                _ ->
                    undefined
            end;
        Pid ->
            Pid
    end.

%手动触发记录接口
state_log() ->
    get_pid() ! state_log ,
    ok.
system_log() ->
    get_pid() ! system_log,
    ok.

%% ====================================================================
%% Behavioural functions 
%% ====================================================================
-record(state, {
    node = 0,
    cmdin = {},        %%dict
    cmdout = {}        %%dict
  }).

%% init/1
init([]) ->
    NodeId = mod_disperse:node_id(),
    State = #state{node = NodeId,
                   cmdin = dict:new() ,
                   cmdout = dict:new()
                  },
    erlang:send_after(?RTIME, self(), state_log),
%%    TodaySeconds = util:get_seconds_from_midnight(),
%%     if
%%         TodaySeconds > 86000 ->
%%             erlang:send_after(1000, self(), system_log);
%%         true ->
%%             TimeDiff = 86000 - TodaySeconds,
%%             erlang:send_after(TimeDiff * 1000 ,self(),system_log)
%%     end,
    {ok, State}.


%% handle_call/3
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.


%% handle_cast/2
handle_cast(_Msg, State) ->
    {noreply, State}.


%% handle_info/2
%% 协议信息收集
handle_info({cmdin,Cmd,Size},State) ->
    %%?PRINT("cmdin:~p:~p~n",[Cmd,Size]),
    CDIn = State#state.cmdin,
    case dict:is_key(Cmd, CDIn) of
        true ->
            {Cmd,N,S} = dict:fetch(Cmd, CDIn),
            CDIn2 = dict:store(Cmd,{Cmd,N + 1,S + Size},CDIn);
        false ->
            CDIn2 = dict:store(Cmd, {Cmd,1,Size}, CDIn)
    end,
    {noreply,State#state{cmdin = CDIn2}};

handle_info({cmdout,Cmd,Size0,Size1},State) ->
    %%?PRINT("cmdout:~p:~p/~p ~n",[Cmd,Size0,Size1]),
    CDOut = State#state.cmdout,
    case dict:is_key(Cmd, CDOut) of
        true ->
            {Cmd,N,S0,S1} = dict:fetch(Cmd, CDOut),
            CDOut2 = dict:store(Cmd,{Cmd,N + 1,S0 + Size0,S1 + Size1},CDOut);
        false ->
            CDOut2 = dict:store(Cmd, {Cmd,1,Size0, Size1}, CDOut)
    end,
    {noreply,State#state{cmdout = CDOut2}};

%% 协议号记录
handle_info(state_log,State) ->
    NewState = State#state{cmdin = dict:new(),cmdout = dict:new()},
    spawn(fun() -> state_log(State) end),
    erlang:send_after(?RTIME, self(), state_log),
    {noreply,NewState};

%% 服务器状态记录
handle_info(system_log,State) ->
%%     spawn(fun() -> system_log(State) end),
%%     erlang:send_after(?RTIMEDAY, self(), system_log),
    {noreply,State};

handle_info(_Info, State) ->
    {noreply, State}.


%% terminate/2
terminate(_Reason, _State) ->
    ok.


%% code_change/3
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================
state_log(State) ->
    Now = util:unixtime(),
    InList = util:term_to_string(util:dict_to_list(State#state.cmdin)),
    %%记录接收输出协议信息
    OutList = util:term_to_string(util:dict_to_list(State#state.cmdout)),
    Sql1 = io_lib:format(<<"INSERT INTO `monitor_system` set `type` = 1 ,`nodeid` = ~p ,`data` = '~s' ,time = ~p">>,[State#state.node,InList,Now]),
    Sql2 = io_lib:format(<<"INSERT INTO `monitor_system` set `type` = 2 ,`nodeid` = ~p ,`data` = '~s' ,time = ~p">>,[State#state.node,OutList,Now]), 
    if
        InList /= "[]" ->
            db:execute(Sql1);
        true -> skip
    end,
    if
        OutList /= "[]" ->
            db:execute(Sql2);
        true -> skip
    end,
    %%当前vm部分状态信息
    Online = 
        case ets:info(ets_online, size) of
            undefined ->
                0;
            Num ->
                Num
        end,
    Schedulers = tool:system_info(schedulers),
    SchedulerId = tool:system_info(scheduler_id),
    %%Ports = length(erlang:ports()),
    ProcessLimit = tool:system_info(process_limit),
    ProcessCount = tool:system_info(process_count),
    [AtomSize,AtomLimt,AtomEntries] = tool:system_info(atom),
    MemTotal = tool:system_mem(total),
    MemProcessUsed = tool:system_mem(processes_used),
    MemAtomUsed = tool:system_mem(atom_used),
    MemBinary = tool:system_mem(binary),
    MemCode = tool:system_mem(code),
    MemEts = tool:system_mem(ets),
    Sql3 = io_lib:format(<<"INSERT INTO `monitor_state` set `nodeid` = ~p ,`online_num` = ~p ,`schedulers` = ~p ,`schedule_id` = ~p ,`process_limit` = ~p ,`process_count` = ~p ,`atom_size` = ~p ,`atom_limit` = ~p ,`atom_entries` = ~p ,`mem_total` = ~p ,`mem_process_used` = ~p ,`mem_atom_used` = ~p ,`mem_binary` = ~p ,`mem_code` = ~p ,`mem_ets` = ~p ,`time` = ~p">>, 
                         [State#state.node,Online,Schedulers,SchedulerId,ProcessLimit,ProcessCount,AtomSize,AtomLimt,AtomEntries,MemTotal,MemProcessUsed,MemAtomUsed,MemBinary,MemCode,MemEts,Now]),
    db:execute(Sql3),
    ok.

system_log(State) ->
    Now = util:unixtime(),
    %%记录当前vm状态
    SystemInfo = tool:system_info(),
    Sql3 = io_lib:format(<<"INSERT INTO `monitor_system` set `type` = 3 ,`nodeid` = ~p ,`data` = '~s' ,time = ~p">>,[State#state.node,SystemInfo,Now]),
    db:execute(Sql3),
    %%记录进程信息
    RdTop = util:term_to_string(tool:get_nodes_cmq(1)),
    MeTop = util:term_to_string(tool:get_nodes_cmq(2)),
    MqTop = util:term_to_string(tool:get_nodes_cmq(3)),
    Sql4 = io_lib:format(<<"INSERT INTO `monitor_system` set `type` = 4 ,`nodeid` = ~p ,`data` = '~s' ,time = ~p">>,[State#state.node,RdTop,Now]),
    Sql5 = io_lib:format(<<"INSERT INTO `monitor_system` set `type` = 5 ,`nodeid` = ~p ,`data` = '~s' ,time = ~p">>,[State#state.node,MeTop,Now]),
    Sql6 = io_lib:format(<<"INSERT INTO `monitor_system` set `type` = 6 ,`nodeid` = ~p ,`data` = '~s' ,time = ~p">>,[State#state.node,MqTop,Now]),
    db:execute(Sql4),
    db:execute(Sql5),
    db:execute(Sql6),
    ok.
