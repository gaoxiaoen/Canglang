%%----------------------------------------------------
%% 同级游戏服务器镜像进程
%% 
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(gs_mirror).
-behaviour(gen_server).
-export([
        create/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("center.hrl").

-define(re_conn_time, 20000).   %% 重新连接的时间（毫秒）

%% ----------------------------------------------------
%% 对外接口
%% ----------------------------------------------------
%% @spec create(Mirror) -> {ok, Pid} | {error, Reason}
%% Mirror = #mirror{}
%% @doc 创建镜像服务器进程
create(Mirror) ->
    gen_server:start_link(?MODULE, [Mirror], []).

%% ----------------------------------------------------
%% 内部处理
%% ----------------------------------------------------
init([M = #mirror{node = Node, cookie = Cookie}]) ->
    erlang:set_cookie(Node, Cookie),
    rpc:cast(Node, gs_mirror_group, ready, [util:to_binary(sys_env:get(srv_id)), util:to_binary(sys_env:get(platform)), node(), self(), sys_env:get(version)]),
    TimerRef = erlang:send_after(?re_conn_time, self(), {check_online, 0}),
    NewM = M#mirror{pid = self(), timer_ref = TimerRef},
    ets:insert(gs_mirror_online, NewM),
    {ok, NewM}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 定时检查远端服务器是否上线
handle_info({check_online, N}, State = #mirror{node = Node, mpid = undefined}) ->
    rpc:cast(Node, gs_mirror_group, ready, [sys_env:get(srv_id), sys_env:get(platform), node(), self(), sys_env:get(version)]),
    TimerRef = erlang:send_after(?re_conn_time, self(), {check_online, N+1}),
    NewState = State#mirror{timer_ref = TimerRef},
    {noreply, NewState};

%% 远端服务器已连接
handle_info({ready, Pid, _SrvIds}, State = #mirror{srv_id = _SrvId, node = Node, timer_ref = TimerRef}) ->
    ?INFO("已经与服务器[~w]建立连接", [Node]),
    Mref = erlang:monitor(process, Pid),
    erlang:cancel_timer(TimerRef),
    NewState = State#mirror{mpid = Pid, mref = Mref, timer_ref = undefined},
    %% Mapping = [{util:to_binary(SrcSrvId), SrvId} || SrcSrvId <- SrvIds] ++ [{SrvId, SrvId}],
    %% gs_mirror_group:add_to_merge_srv_mapping(Mapping),
    {noreply, NewState};

%% 远端服务器已断开连接
handle_info({'DOWN', Mref, _Type, _Object, _Reason} = R, State = #mirror{node = Node, mref = Mref}) ->
    ?INFO("与服务器[~w]的连接已经断开: ~w", [Node, R]),
    TimerRef = erlang:send_after(?re_conn_time, self(), {check_online, 0}),
    NewState = State#mirror{mpid = undefined, mref = undefined, timer_ref = TimerRef},
    {noreply, NewState};

handle_info(stop, State) ->
    {stop, normal, State};

handle_info(Info, State = #mirror{node = Node}) ->
    ?ERR("[~s]的镜像进程收到未知消息: ~w", [Node, Info]),
    {noreply, State}.

terminate(Reason, #mirror{srv_id = SrvId, node = Node}) ->
    case Reason of
        normal -> ?INFO("连接到[~s, ~w]的镜像进程已经正常退出", [SrvId, Node]);
        _ -> ?ERR("连接到[~s, ~w]的镜像进程异常退出:~w", [SrvId, Node, Reason])
    end,
    ets:delete(gs_mirror_online, SrvId),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

