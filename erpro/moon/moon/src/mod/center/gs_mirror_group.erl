%%----------------------------------------------------
%% 远端服务器镜像分组管理
%%
%% 说明：
%% 1，与c_mirror_group类似，供game server互联用
%% 2，互联需要的配置由中央服推送，每次中央服和当前节点连接时就推送一次配置列表和合服映射，
%%    当前节点根据最新的配置列表和合服映射来连接
%%
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(gs_mirror_group).
-behaviour(gen_server).
-export([
        start_link/0,
        ready/5,
        update_cfg/1,
        cast/5,
        call/5
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("center.hrl").

-define(RETRY_GET_CFG_TIME, 30000).


-record(state, {
        ver = undefined
    }).

%% ----------------------------------------------------
%% 对外接口
%% ----------------------------------------------------
%% @spec start_link() -> {ok, Pid} | {error, Reason}
%% @doc 创建镜像服务器群组管理进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 远端服务器尝试连接本服
ready(SrvId, Platform, Node, Mpid, RemoteVer) ->
    gen_server:cast(?MODULE, {ready, SrvId, Platform, Node, Mpid, RemoteVer}).

%% 更新连接配置和合服映射
update_cfg(CompressedData) ->
    gen_server:cast(?MODULE, {update_cfg, CompressedData}).

%% @spec cast(node, SrvId, M, F, A) -> ok
%% @doc 发送异步消息到指定srv_id的远端服务器
cast(node, SrvId, M, F, A) ->
    DestSrvId = get_merge_dest_srv_id(SrvId),
    case ets:lookup(gs_mirror_online, DestSrvId) of
        [#mirror{node = Node, mpid = Mpid}] when is_pid(Mpid) ->
            rpc:cast(Node, M, F, A);
        _ ->
            ?ERR("还没有连接上[~s]，无法发送该异步消息[~w, ~w, ~w]", [SrvId, M, F, A])
    end.

%% @spec call(node, SrvId, M, F, A) -> ok | {error, Reason}
%% @doc 发送同步消息到指定srv_id的远端服务器
call(node, SrvId, M, F, A) ->
    DestSrvId = get_merge_dest_srv_id(SrvId),
    case ets:lookup(gs_mirror_online, DestSrvId) of
        [#mirror{node = Node, mpid = Mpid}] when is_pid(Mpid) ->
            rpc:call(Node, M, F, A);
        _ ->
            ?ERR("还没有连接上[~s]，无法发送该同步消息[~w, ~w, ~w]", [SrvId, M, F, A]),
            {error, not_connected}
    end.

%% 获取合服后的目标srv_id（如果没有合服，则返回自己）
get_merge_dest_srv_id(SrvId) ->
    Mapping = get_merge_srv_mapping(),
    case lists:keyfind(SrvId, 1, Mapping) of
        {SrvId, DestSrvId} -> DestSrvId;
        _ -> SrvId
    end.

%% 获取所有的合服映射
get_merge_srv_mapping() ->
    case sys_env:get(merge_srv_mapping) of
        undefined -> [];
        L -> L
    end.


%% ----------------------------------------------------
%% 内部处理
%% ----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(gs_mirror_online, [set, named_table, public, {keypos, #mirror.srv_id}]),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{ver = sys_env:get(version)}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({ready, _SrvId, _Platform, _Node, _Mpid, RemoteVer}, State = #state{ver = LocalVer}) when RemoteVer =/= LocalVer ->
    ?DEBUG("无法与远端服务器[~w]建立连接，版本不一致", [_Node]),
    {noreply, State};
handle_cast({ready, SrvId, Platform, Node, Mpid, RemoteVer}, State = #state{ver = RemoteVer}) ->
    case ets:lookup(gs_mirror_online, SrvId) of
        [#mirror{mpid = OldMpid}] when is_pid(OldMpid) -> %% 已经连接上了就不管
            ignore;
        _ -> 
            Mref = erlang:monitor(process, Mpid),
            Mirror = #mirror{srv_id = SrvId, platform = Platform, name = SrvId, node = Node, host = "", ver = RemoteVer, pid = self(), mpid = Mpid, mref = Mref},
            ets:insert(gs_mirror_online, Mirror),
            ?INFO("已经与远端服务器[~w]建立连接", [Node]),
            SrvIds = case sys_env:get(srv_ids) of
                L = [_|_] -> L;
                _ -> []
            end,
            erlang:send(Mpid, {ready, self(), SrvIds})
    end,
    {noreply, State};

handle_cast({update_cfg, CompressedData}, State) ->
    case binary_to_term(CompressedData) of
        [MappingCfg, MirrorCfg] ->
            update_merge_srv_mapping(MappingCfg),
            update_mirror(MirrorCfg);
        _ -> ?ERR("收到中央服推送过来的更新配置信息，不过解压后内容不正确!")
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    %%?INFO("[~s]的镜像进程已经退出", [Node]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------
%% 更新合服映射
update_merge_srv_mapping(Mapping) ->
    sys_env:set(merge_srv_mapping, Mapping).

%% 更新所有镜像服务器
%% MirrorList = [#mirror{}]
update_mirror(MirrorList) ->
    do_update_mirror(MirrorList).
do_update_mirror([]) -> ok;
do_update_mirror([Mirror = #mirror{srv_id = SrvId, platform = Platform, name = Name, node = Node, ver = Ver, cookie = Cookie}|T]) ->
    case cross_util:is_local_srv(SrvId) of
        true -> ignore;
        false ->
            case ets:lookup(gs_mirror_online, SrvId) of
                [OldMirror = #mirror{node = Node, cookie = Cookie}] -> %% 如果node和cookie没有变化，则只修改其他信息
                    ets:insert(gs_mirror_online, OldMirror#mirror{platform = Platform, name = Name, ver = Ver});
                [#mirror{pid = Pid}] -> %% 如果node或者cookie变化，则要断开重连
                    case is_pid(Pid) of
                        true -> Pid ! stop;
                        false -> ignore
                    end,
                    Mirror1 = Mirror#mirror{pid = undefined, mpid = undefined, mref = undefined, timer_ref = undefined},
                    gs_mirror:create(Mirror1);
                [] ->
                    Mirror1 = Mirror#mirror{pid = undefined, mpid = undefined, mref = undefined, timer_ref = undefined},
                    gs_mirror:create(Mirror1);
                _ -> ignore
            end
    end,
    do_update_mirror(T);
do_update_mirror([Mirror|T]) ->
    ?ERR("错误的镜像服务器配置数据:~w", [Mirror]),
    do_update_mirror(T).
