%%%-------------------------------------------------------------------
%%%
%%%
%%% @doc
%%%     mt_common  提供一些常用的维护脚本
%%% @end
%%% Created : 2010-10-25
%%%-------------------------------------------------------------------
-module(mt_common).

%%
%% Include files
%%
%%
%% Include files
%%
 
-define( PRINTME(F,D),io:format(F, D) ).
-compile(export_all).
-include("common.hrl").
-include("common_server.hrl").

%%
%% Exported Functions
%%
-export([]).

%%
%% API Functions
%%

%%@doc 将指定模块热更新到所有Node
load_nodes(CodeModule)->
    Args = [CodeModule],
    Nodes = [node()|nodes()],
    [ rpc:call(Nod, c, l, Args) ||Nod<-Nodes ].

%%@doc 对所有的Node进行rpc:call 指定的MFA
call_nodes(Module,Method)->
    call_nodes(Module,Method,[]).

call_nodes(Module,Method,Args)->
    Nodes = [node()|nodes()],
    [ rpc:call(Nod, Module, Method, Args) ||Nod<-Nodes ].


load_config(ConfigFileName) when is_atom(ConfigFileName)->
    call_nodes(common_config_dyn,reload,[ConfigFileName]).


%%@spec sys_info/0
sys_info()->

    PortsCount   = length( erlang:ports() ),
    ProcCount    = erlang:system_info(process_count),  
    NodesList = [node()|nodes()],
    NodesCount  = length(NodesList),
    MemTotal     = ( erlang:memory(total) div 1024 div 1024 ),
    
    %% eg: acceptors:   10 ports:   20  memory: 5000    processes:  20 nodes: [xx,xx]
    Res = concat(["ports:\t",PortsCount,"\tmemory:\t",MemTotal,"MB\tprocesses:\t",ProcCount,"\tnodescount:\t",NodesCount]),
    ?PRINTME("~s~n",[Res]).

%%@spec fun_info/0
fun_info()->
    Processes = erlang:processes(),
    Header = io_lib:format( "Processes's length=~p~n",[ erlang:length( Processes ) ] ) ,
    
    Body = lists:foldl(fun(P,AccIn)->
                               case erlang:process_info(P,current_function) of
                                   undefined -> AccIn;
                                   [] -> AccIn;
                                   {current_function,{gen_server,loop,_}} ->
                                       case erlang:process_info(P,dictionary) of
                                           {dictionary,List} ->
                                               case lists:keyfind('$initial_call', 1, List) of
                                                   {'$initial_call',V}-> 
                                                       StrRes = io_lib:format("~p:gen_server:~p",[P,V]),
                                                       concat([AccIn,"\n",StrRes]);
                                                    _ ->  AccIn
                                               end;
                                           _ -> AccIn
                                       end;
                                   {current_function,{application_master,_,_}} -> AccIn;
                                   Res -> 
                                       StrRes = io_lib:format("~p:~p",[P,Res]),
                                       concat([AccIn,"\n",StrRes])
                               end
                       end ,Header, Processes),
    do_write_log(Body,"./fun_info.log"),
    ok.

%% Local Functions
%%

do_write_log(Body,Filename)->
    Bytes = common_tool:to_binary(Body),
    file:write_file(Filename, Bytes,[write]).

concat(Things)->
    lists:concat(Things).



get_pid_list(Type) ->
    get_pid_list2(erlang:registered(),Type,[]).

get_pid_list2([],_Type,ResultList) ->
    ResultList;
get_pid_list2([ProcessName|ProcessNameList],map,ResultList) ->
    case common_tool:to_list(ProcessName) of
        "map_" ++ _ ->
            get_pid_list2(ProcessNameList,map,[ProcessName|ResultList]);
        _ ->
            get_pid_list2(ProcessNameList,map,ResultList)
    end;
get_pid_list2([ProcessName|ProcessNameList],gateway,ResultList) ->
    case common_tool:to_list(ProcessName) of
        "gateway_" ++ _ ->
            get_pid_list2(ProcessNameList,gateway,[ProcessName|ResultList]);
        _ ->
            get_pid_list2(ProcessNameList,gateway,ResultList)
    end;
get_pid_list2([ProcessName|ProcessNameList],world,ResultList) ->
    case common_tool:to_list(ProcessName) of
        "world_" ++ _ ->
            get_pid_list2(ProcessNameList,world,[ProcessName|ResultList]);
        _ ->
            get_pid_list2(ProcessNameList,world,ResultList)
    end;
get_pid_list2([ProcessName|ProcessNameList],chat,ResultList) ->
    case common_tool:to_list(ProcessName) of
        "chat_role_" ++ _ ->
            get_pid_list2(ProcessNameList,chat,[ProcessName|ResultList]);
        _ ->
            get_pid_list2(ProcessNameList,chat,ResultList)
    end;
get_pid_list2(ProcessNameList,Type,ResultList) ->
    get_pid_list2([],Type,ProcessNameList ++ ResultList).


    

