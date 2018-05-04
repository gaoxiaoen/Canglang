%%% -------------------------------------------------------------------
%%% Author  :markycai<tomarky.cai@gmail.com>
%%% Description :接收日志进程
%%% 在日志服务器启动  
%%% 与游戏服1对1
%%% 整理数据直接入库
%%% Created : 2013-10-18
%%% -------------------------------------------------------------------
-module(logger_receiver).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("logger.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start/2,
         start_link/3]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([get_pool_name/0]).

-record(state,{agent_id,server_id,pool_name,dump_mod_name}).

%% ====================================================================
%% External functions
%% ====================================================================

%% temporary 模式  进程启动由游戏服驱动 不自动重启
start(AgentId,ServerId)->
    ProcessName = logger_tool:get_receiver_name(AgentId,ServerId),
    ChildSpec = {ProcessName,
                 {?MODULE,start_link,[ProcessName,AgentId,ServerId]},
                 temporary,
                 infinity,
                 worker,
                 [?MODULE]
                 },
    supervisor:start_child(logger_sup, ChildSpec).

%% 作为global 进程可以给游戏服注册
start_link(ProcessName,AgentId,ServerId) ->
    gen_server:start_link({global, ProcessName}, ?MODULE, [AgentId,ServerId], []).


%% ====================================================================
%% Server functions
%% ====================================================================

init([AgentId,ServerId]) ->
    %% 秒循环日志入库处理
    erlang:send_after(1000, self(), loop),
    %% 捕捉进程结束信号 进行日志入库
    erlang:process_flag(trap_exit, true),
    %% 创建mysql连接进程池
    ?ERROR_MSG("---------------------AgentId:~w ServerId:~w ",[AgentId,ServerId]),
    [{Host,User,Password,Database}]=common_config_dyn:find(common, {mysql_config,AgentId,ServerId}),
    ?ERROR_MSG("---------------------Host:~w,User:~w,Password:~w,Database:~w ",[Host,User,Password,Database]),
    PoolName = logger_tool:get_pool_name(AgentId,ServerId),
    emysql:add_pool(PoolName, ?POOL_SIZE, User, Password, Host, ?POOL_PORT, Database, ?ENCODING),
    ModName = logger_tool:get_dump_mod(AgentId, ServerId),
    set_state(#state{agent_id=AgentId,server_id=ServerId,pool_name=PoolName,dump_mod_name=ModName}),
    {ok,[]}.

handle_call(Request, _From, State) ->
    ?TRY_CATCH(do_handle_call(Request),Err),
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
    #state{dump_mod_name = Mod}=get_state(),
    %% 持久化数据
    case code:is_loaded(Mod) of
        {file,_}->?TRY_CATCH(Mod:dump_all(),Err);
        _->ignore
    end,
    %% 关闭连接池
    emysql:remove_pool(get_pool_name()),
    {stop,Reason, State}.

code_change(_Request,_Code,_State)->
    ok.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

do_handle_info(loop)->
    erlang:send_after(1000, self(), loop),
    #state{dump_mod_name = Mod}=get_state(),
    catch Mod:loop(common_tool:now());
    

do_handle_info({log,Log})->
    #state{dump_mod_name = Mod}=get_state(),
    Mod:log(Log);

%% 执行函数处理
do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;

do_handle_info(Msg)->
    ?ERROR_MSG("----Msg:~w",[Msg]).

%% call的方式更新入库代码
%% 防止代码与数据版本不吻合导致数据丢失
do_handle_call({load_beam,Module,Binary})->
    case code:is_loaded(Module) of
        {file,_}->?TRY_CATCH(Module:dump_all(),Err);
        _->ignore
    end,
    code:load_binary(Module, atom_to_list(Module)++".erl", Binary),
    ?TRY_CATCH(Module:init(),Err2);

do_handle_call(Msg)->
    ?ERROR_MSG("----Msg:~w",[Msg]).

get_pool_name()->
    #state{pool_name=PoolName} = get_state(),
    PoolName.

set_state(State)->
    erlang:put(receiver_state,State).

get_state()->
    erlang:get(receiver_state).