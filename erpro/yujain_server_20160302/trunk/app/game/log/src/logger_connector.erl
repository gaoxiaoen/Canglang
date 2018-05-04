%%% -------------------------------------------------------------------
%%% Author  :markycai<tomarky.cai@gmail.com>
%%% Description : 日志连接器
%%% 在游戏进程  每隔10秒钟检测一次是否存在并且做一次重连
%%% Created : 2013-10-24
%%% -------------------------------------------------------------------

-module(logger_connector).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("logger.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start/0,
         start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% External functions
%% ====================================================================
start()->
    {ok,_} = supervisor:start_child(mgeew_sup, {?MODULE,
                                                {?MODULE,start_link,[]},
                                                permanent,30000,worker,
                                                [?MODULE]
                                                }).
start_link()->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).


%% ====================================================================
%% Server functions
%% ====================================================================
init([]) ->
    erlang:send_after(10000, self(), loop),
    connect(),
    {ok,[]}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Request, State) ->
    {noreply,  State}.

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info,State),
    {noreply, State}.

terminate(Reason, State) ->
    {stop,Reason, State}.

code_change(_Request,_Code,_State)->
    ok.
%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

%% 每隔10秒检查一次日志服进程的状态
do_handle_info(loop)->
    check_connect(),
    erlang:send_after(10000, self(), loop);

%% 执行函数处理
do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok.

%% 检查日志进程状态
check_connect()->
    case global:whereis_name(logger_tool:get_receiver_name()) of
        undefined->
            connect();
        Pid when is_pid(Pid)->
            ok
    end.

%% 连接日志服的进程
connect()->
    catch connect2().

connect2()->
    %% 是否有日志节点
    case logger_tool:get_logger_node() of
        {ok,Node}->
            next;
        _->
            erlang:throw(ignore),
            Node = undefined
    end,
    %% 是否拼通日志节点
    case net_adm:ping(Node) of
        pong->
            next;
        pang->
            erlang:throw(ignore)
    end,
    %% 获取接受日志进程id并在游戏服注册，发送最新持久化代码
    ServerId = common_config:get_server_id(),
    AgentId = common_config:get_agent_id(),
    ReceiverName = logger_tool:get_receiver_name(AgentId,ServerId),
    case rpc:call(Node, global,whereis_name,[ReceiverName]) of
        Pid when is_pid(Pid)->
            %% 必须先同步代码才注册进程
            case catch logger_dump_code:sync_code(Pid) of
                ok->
                    global:register_name(ReceiverName, Pid);
                Error->
                    ?ERROR_MSG("-----sync code error:~w",[Error]),
                    ignore
            end,
            erlang:throw(ignore);
        _->
            next
    end,
    %% 远程连接
    case rpc:call(Node, logger_receiver, start, [AgentId,ServerId]) of
        {ok,Pid2} ->
            %% 必须先同步代码才注册进程
            case catch logger_dump_code:sync_code(Pid2) of
                ok->
                    global:register_name(ReceiverName, Pid2);
                Err->
                    ?ERROR_MSG("-----sync code error:~w",[Err]),
                    ignore
            end;
        Err->
            ?ERROR_MSG("----Info:~w",[Err]),
            ignore
    end.