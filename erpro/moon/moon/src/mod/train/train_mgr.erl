%% --------------------------------------------------------------------
%% @doc 飞仙历练管理进程
%% @author weihua@jieyou.cn
%% --------------------------------------------------------------------
-module(train_mgr).
-behavior(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([cast/1, call/1]).

-include("common.hrl").

%% ---------------------------------------------------------------
%% API
%% ---------------------------------------------------------------
%% @spec cast(Msg) -> ok
%% Msg = term()
%% @doc 向历练管理进程发送一个异步消息
cast(Msg) -> gen_server:cast({global, ?MODULE}, Msg).

%% @spec call(Msg) -> {error, Reason} | term()
%% Msg = term()
%% @doc 向历练管理进程发送一个 同步消息
call(Msg) ->
    try gen_server:call({global, ?MODULE}, Msg) of
        Reply -> Reply 
    catch
        exit:{timeout, _} -> 
            ?ERR("向飞仙历练管理进程 发起的请求{~w}发生timeout", [Msg]),
            {error, timeout};
        exit:{noproc, _} -> 
            ?ERR("向飞仙历练管理进程 发起的请求{~w}发生noproc", [Msg]),
            {error, noproc};
        Error:Info ->
            ?ERR("向飞仙历练管理进程 发起的请求{~w}发生异常{~w:~w}", [Msg, Error, Info]),
            {error, Error}
    end.

%% ---------------------------------------------------------------
%% 系统服务
%% --------------------------------------------------------------
%% @doc 启动飞仙历练管理进程
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% @doc 飞仙历练管理进程初始化 载入数据，启动子进程
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    NewFields = train_mgr_common:init(?MODULE),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, NewFields}.

%%-----------------------------------------------------------
%% 同步请求
%%-----------------------------------------------------------
handle_call({lookup, Fun, Args}, _From, State) ->
    try Fun([State | Args]) of
        Reply -> {reply, Reply, State}
    catch
        _E:_I -> {reply, {_E, _I}, State}
    end;

handle_call(_Data, _From, State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% 异步请求
%%-----------------------------------------------------------
%% 更新玩家历练场数据
handle_cast({update_role, TrainRole}, State) ->
    Reply =  train_mgr_common:update_role(?MODULE, TrainRole, State),
    handle_outer_state(Reply, State);

%% %% 更新劫匪数据
%% handle_cast({update_rob, TrainRob}, State) ->
%%     Reply =  train_mgr_common:update_rob(TrainRob, State),
%%     handle_outer_state(Reply, State);
%% 
%% 更新游客数据
handle_cast({visitor, Visitor}, State) ->
    Reply = train_mgr_common:visitor(Visitor, State),
    handle_outer_state(Reply, State);

%% 更新玩家历练场数据
handle_cast({delete_role, {Fid, RoleId}}, State) ->
    Reply = train_mgr_common:delete_role(?MODULE, {Fid, RoleId}, State),
    handle_outer_state(Reply, State);

%% 更新玩家历练场数据
%% handle_cast({delete_rob, {Fid, RoleId}}, State) ->
%%     Reply = train_mgr_common:delete_rob({Fid, RoleId}, State),
%%     handle_outer_state(Reply, State);

%% 更新玩家历练场数据
%% handle_cast({delete_visitor, {Fid, RoleId}}, State) ->
%%     Reply = train_mgr_common:delete_visitor({Fid, RoleId}, State),
%%     handle_outer_state(Reply, State);

%% 检测是否场区需要新增
handle_cast({check_area_load, Lid}, State) ->
    Reply = train_mgr_common:check_area_load(?MODULE, Lid, State),
    handle_outer_state(Reply, State);

%% 给玩家分配场区
handle_cast({assign, Pid, FC}, State) ->
    Reply = train_mgr_common:assign(?MODULE, Pid, FC, State),
    handle_outer_state(Reply, State);

%% 给玩家重新分配场区
handle_cast({change_grade, Pid, FC}, State) ->
    Reply = train_mgr_common:change_grade(?MODULE, Pid, FC, State),
    handle_outer_state(Reply, State);

%% 启动指定场区
handle_cast({start_specify, List}, State) ->
    Reply = train_mgr_common:start_specify_train(?MODULE, List, State),
    handle_outer_state(Reply, State);

%% 广播场区负荷
handle_cast({update_area_num, Lid, Aid, Num}, State) ->
    Reply = train_mgr_common:update_area_num(?MODULE, Lid, Aid, Num, State),
    handle_outer_state(Reply, State);

handle_cast(_Data, State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% 系统消息
%%-----------------------------------------------------------
%% 捕捉退出消息
handle_info({'EXIT', _, normal}, State) ->
    {noreply, State};

%% 重启退出的飞仙历练场区进程
handle_info({'EXIT', Pid, REASON}, State) ->
    Reply =  train_mgr_common:restart(?MODULE, Pid, REASON, State),
    handle_outer_state(Reply, State);

%% 保存数据
handle_info(save, State) ->
    train_mgr_common:save(State),
    {noreply, State};

handle_info(_Data, State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% 系统关闭
%%-----------------------------------------------------------
terminate(_Reason, State) ->
    train_mgr_common:save(State),
    {noreply, State}.

%%-----------------------------------------------------------
%% 热代码切换
%%-----------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% -----------------------------------------------------------------------
%% 私有函数
%% -----------------------------------------------------------------------
%% 统一处理外部模块返回的进程数据
handle_outer_state({ok}, State) ->
    {noreply, State};
handle_outer_state({ok, NewState}, _State) ->
    {noreply, NewState};
handle_outer_state(_Data, State) ->
    ?ERR("更新历练数据时，返回错误的格式, ~w", [_Data]),
    {noreply, State}.
