%%----------------------------------------------------
%% 远端服务器镜像进程
%% 
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(c_mirror).
-behaviour(gen_server).
-export([
        create/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("center.hrl").

-define(re_conn_time, 15000).   %% 重新连接的时间（毫秒）

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
    rpc:cast(Node, center, ready, [node(), self(), sys_env:get(version)]),
    TimerRef = erlang:send_after(?re_conn_time, self(), {check_online, 0}),
    NewM = M#mirror{pid = self(), timer_ref = TimerRef},
    ets:insert(mirror_online, NewM),
    {ok, NewM}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 定时检查远端服务器是否上线
handle_info({check_online, N}, State = #mirror{srv_id = SrvId, node = Node, mpid = undefined}) ->
    case N > 0 of
        true -> ?INFO("[~w]连接不上，尝试了~w次，正在重连", [SrvId, Node, N]);
        false -> ignore
    end,
    rpc:cast(Node, center, ready, [node(), self(), sys_env:get(version)]),
    TimerRef = erlang:send_after(?re_conn_time, self(), {check_online, N+1}),
    NewState = State#mirror{timer_ref = TimerRef},
    sync(NewState),
    {noreply, NewState};

%% 远端服务器已连接
handle_info({ready, Pid, SrvIds}, State = #mirror{srv_id = SrvId, node = Node, timer_ref = TimerRef}) ->
    ?INFO("已经与服务器[~w]建立连接", [Node]),
    Mref = erlang:monitor(process, Pid),
    erlang:cancel_timer(TimerRef),
    %% sync_maps(State),
    NewState = State#mirror{mpid = Pid, mref = Mref, timer_ref = undefined},
    sync(NewState),
    Mapping = [{util:to_binary(SrcSrvId), SrvId} || SrcSrvId <- SrvIds] ++ [{SrvId, SrvId}],
    ?DEBUG("连接时收到[~s]的合服映射信息为:", [SrvId]),
    lists:foreach(fun({_A, _B}) -> ?DEBUG("[~s] -> [~s]", [_A, _B]) end, Mapping),
    c_mirror_group:add_to_merge_srv_mapping(Mapping),
    case ?cross_trip_flag of
        1 -> self() ! update_cfg;
        _ -> ignore
    end,
    rpc:cast(Node, center, update_platform_and_srv, [sys_env:get(platform_srv_list)]),
    {noreply, NewState};

%% 通知远端服务器更新连接配置列表和合服映射信息
handle_info(update_cfg, State = #mirror{node = Node, mpid = Mpid}) when is_pid(Mpid) ->
    MappingCfg = sys_env:get(merge_srv_mapping),
    MirrorCfg = ets:tab2list(mirror_online),
    AllCfg = term_to_binary([MappingCfg, MirrorCfg], [compressed]),
    rpc:cast(Node, gs_mirror_group, update_cfg, [AllCfg]),
    {noreply, State};

handle_info({center_exists, _N}, State) ->
    {noreply, State};

%% 远端服务器已断开连接
handle_info({'DOWN', Mref, _Type, _Object, _Reason} = R, State = #mirror{node = Node, mref = Mref}) ->
    ?INFO("与服务器[~w]的连接已经断开: ~w", [Node, R]),
    TimerRef = erlang:send_after(?re_conn_time, self(), {check_online, 0}),
    NewState = State#mirror{mpid = undefined, mref = undefined, timer_ref = TimerRef},
    sync(NewState),
    {noreply, NewState};

%% 广播到远端服务器
handle_info({cast, M, F, A}, State = #mirror{mpid = Mpid, node = Node}) when is_pid(Mpid) ->
    rpc:cast(Node, M, F, A),
    {noreply, State};
handle_info({cast, _, _, _}, State) ->
    {noreply, State};

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
    ets:delete(mirror_online, SrvId),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 同步服务器数据
sync(M) -> ets:insert(mirror_online, M).

%% 同步地图数据
%%sync_maps(#mirror{node = Node}) ->
%%    Maps = ets:tab2list(map_info),
%%    rpc:cast(Node, map_mgr, update_mirror, [Maps]).
