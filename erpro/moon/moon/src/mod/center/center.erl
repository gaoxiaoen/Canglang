%%----------------------------------------------------
%% 跨服通讯接口
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(center).
-behaviour(gen_server).
-export([
        start_link/0
        ,ready/2
        ,ready/3
        ,call/3
        ,call/4
        ,cast/3
        ,cast/4
        ,srv_info/1
        ,is_connect/0
        ,is_cross_center/0
        ,update_platform_and_srv/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("center.hrl").

-record(state, {
        node        %% 中央服节点名称
        ,mpid       %% 中央服镜像进程pid
        ,mref       %% 进程监控ref
        ,ver        %% 当前系统版本
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 当中央服节点启动后会通知当前节点
ready(_, _) -> ok.
ready(Node, Mpid, CenterVer) ->
    gen_server:cast(?MODULE, {ready, Node, Mpid, CenterVer}).

%% 对中央服发起同步调用
call(M, F, A) ->
    case sys_env:get(center) of
        undefined ->
            {error, center_not_ready};
        {Node, _Mpid} ->
            rpc:call(Node, M, F, A)
    end.

%% 对指定服发起同步调用
call(#srv{node = Node}, M, F, A) ->
    rpc:call(Node, M, F, A);
call(SrvId, M, F, A) ->
    %% case ets:lookup(srv_list, SrvId) of
    %%     [#srv{node = Node}] ->
    %%         rpc:call(Node, M, F, A);
    %%     _ ->
    %%         {error, disallow}
    %% end.
    center:call(c_mirror_group, call, [node, SrvId, M, F, A]).

%% 对中央服发起异步调用
cast(M, F, A) ->
    case sys_env:get(center) of
        undefined ->
            {error, center_not_ready};
        {Node, _Mpid} ->
            rpc:cast(Node, M, F, A)
    end.

%% 对指定服发起异步调用
cast(#srv{node = Node}, M, F, A) ->
    rpc:cast(Node, M, F, A);
cast(SrvId, M, F, A) ->
    %% case ets:lookup(srv_list, SrvId) of
    %%     [#srv{node = Node}] ->
    %%         rpc:cast(Node, M, F, A);
    %%     _ ->
    %%         {error, disallow}
    %% end.
    center:cast(c_mirror_group, cast, [node, SrvId, M, F, A]).

%% 取得某个服务器的信息
srv_info(SrvId) ->
    case ets:lookup(srv_list, SrvId) of
        [S] -> {ok, S};
        _ -> false
    end.

%% 判断是否与中央服建立连接
%% @spec is_connect() -> {true, {Node, Pid}} | false
is_connect() ->
    case sys_env:get(center) of
        {Node, Pid} when is_pid(Pid) ->
            {true, {Node, Pid}};
        _ ->
            false
    end.

%% 判断本节点是否中央服
is_cross_center() ->
    case sys_env:get(is_cross_center) of
        true -> true;
        _ -> false
    end.

%% 更新所有平台和拥有服的信息
update_platform_and_srv(PlatformSrvList) when is_list(PlatformSrvList) ->
    PlatformList = [Platform || {Platform, _} <- PlatformSrvList],
    sys_env:save(platform_list, PlatformList),
    sys_env:save(platform_srv_list, PlatformSrvList);
update_platform_and_srv(_) -> ignore.

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(srv_list, [set, named_table, public, {keypos, #srv.id}]), %% 当前节点上已开启的地图
    State = #state{ver = sys_env:get(version)},
    sys_env:save(is_cross_center, false),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({ready, _Node, _Pid}, State = #state{node = undefined}) ->
    {noreply, State};
handle_cast({ready, _Node, _Pid, CenterVer}, State = #state{node = undefined, ver = LocalVer}) when CenterVer =/= LocalVer ->
    ?DEBUG("无法与中央服[~w]建立连接，版本不一致", [_Node]),
    {noreply, State};
handle_cast({ready, Node, Pid, CenterVer}, State = #state{node = undefined, ver = CenterVer}) ->
    ?INFO("已经与中央服[~w]建立连接", [Node]),
    Mref = erlang:monitor(process, Pid),
    sys_env:set(center, {Node, Pid}),
    SrvIds = case sys_env:get(srv_ids) of
        L = [_|_] -> L;
        _ -> []
    end,
    erlang:send(Pid, {ready, self(), SrvIds}),
    {noreply, State#state{mpid = Pid, node = Node, mref = Mref}};

handle_cast(Msg, State) ->
    ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

handle_info({'DOWN', Mref, _Type, _Object, Reason}, State = #state{node = Node, mref = Mref}) ->
    ?INFO("与中央服[~w]的连接已经断开: ~w", [Node, Reason]),
    sys_env:set(center, undefined),
    {noreply, State#state{node = undefined, mpid = undefined, mref = undefined}};

%% 收到中央服发来的压缩过的连接配置和合服映射信息，就交给gs_mirror_group处理
handle_info({update_cfg, CompressedData}, State) ->
    gs_mirror_group:update_cfg(CompressedData),
    {noreply, State};

handle_info(Info, State) ->
    ?ERR("收到未知消息: ~w", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
