%%----------------------------------------------------
%% 地图管理器
%% 
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(map_mgr).
-behaviour(gen_server).
-export([
        info/1
        ,get_map_info/2
        ,start_link/0
        ,start_link/1
        ,create/1
        ,create/2
        ,stop/1
        ,is_blocked/3
        ,get_path/3
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("map.hrl").
-include("map_line.hrl").

%%
-record(state, {
        next_id = 100000    %% 下个动态地图ID，小于100000的为普通地图
    }
).

-define(CLIENT_X_GRID, 60).
-define(CLIENT_Y_GRID, 30).

%% 动态创建地图
-define(CREATE(MapBaseId, F),
    case map_data:get(MapBaseId) of
        false -> {false, ?L(<<"地图不存在">>)};
        #map_data{id = MapBaseId, elem = Elems, condition = Cond, npc = _NpcList, width = W, height = H, type = Type} ->
            Id = gen_server:call({global, ?MODULE}, fetch_id),
            Map = #map{gid = {?map_def_line, Id}, id = Id, base_id = MapBaseId, owner_pid = self(), elem = handle_elems(Elems), condition = Cond, width = W, height = H, event = handle_evt_listener(map_event_data:get(MapBaseId)), type = Type},
            case catch map:start_link(Map) of
                {ok, MapPid} ->
                    F,
                    {ok, MapPid, Id};
                _Err ->
                    ?ELOG("创建地图进程失败:~w", [_Err]),
                    {false, map_create_error}
            end
    end
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% @spec info(MapGid={Line, MapId}) -> {ok, #map{}} | false
%% MapId = integer()
%% @doc 查询指定地图的信息
info(MapGid) ->
    case ets:lookup(map_info, MapGid) of
        [M] -> {ok, M};
        _ -> false
    end.

get_map_info(<<>>, MapGid) ->
    ?DEBUG("get map_info from local: map_id = ~w", [MapGid]),
    ets:lookup(map_info, MapGid);
get_map_info(<<"center">>, MapGid) ->
    ?DEBUG("get map_info from center, map_id = ~w", [MapGid]),
    case center:call(map_mgr, info, [MapGid]) of
        {ok, Map} ->
            [Map];
        Other ->
            Other
    end;
get_map_info(CrossSrvId, MapId) ->
    ?DEBUG("get map_info from cross_srv: cross_srv_id = ~w, map_id = ~w", [CrossSrvId, MapId]),
    case cross_util:is_local_srv(CrossSrvId) of
        true -> ets:lookup(map_info, MapId);
        false ->
            case gs_mirror_group:call(node, CrossSrvId, map_mgr, info, [MapId]) of
                {ok, Map} ->
                    [Map];
                Other ->
                    Other
            end
    end.

%% @spec stop(MapGid) -> true | false
%% MapId = integer()
%% @doc 关闭指定地图进程
stop(MapGid) ->
    case ets:lookup(map_info, MapGid) of
        [#map{pid = Pid}] ->
            map:stop(Pid),
            true;
        _ -> false
    end.

%% @spec create(MapBaseId) -> {ok, MapPid, Id} | {false, Reason}
%% MapBaseId = integer()
%% MapPid = pid()
%% Reason = binary()
%% @doc 动态创建地图，并创建地图关联的NPC
create(MapBaseId) ->
    ?CREATE(MapBaseId, create_npc(_NpcList, Id)).

%% @spec create(MapBaseId) -> {ok, MapPid, Id} | {false, Reason}
%% MapBaseId = integer()
%% MapPid = pid()
%% Reason = binary()
%% @doc 动态创建地图，但不创建地图关联的NPC
create(no_npc, MapBaseId) ->
    ?CREATE(MapBaseId, no_npc).

%% @doc 查询指定地图的某个点是否为不可行走区域
%% X, Y 数值为服务端的坐标，而非客户端的格子
is_blocked(BaseId, X, Y) ->
    is_client_blocked(BaseId, X div ?CLIENT_X_GRID, Y div ?CLIENT_Y_GRID).

%% @spec get_path(BaseId, From, To) -> blocked | {integer(), integer()}
%% BaseId = integer()
%% From = To = {integer(), integer()}
%% @doc 取得一个可到达的离终点最接近的坐标{X, Y}, 如果一格也动不了则返回:blocked
get_path(BaseId, {X1, Y1}, {X2, Y2}) ->
    Fx = util:ceil(X1 / ?CLIENT_X_GRID),
    Fy = util:ceil(Y1 / ?CLIENT_Y_GRID),
    Tx = util:ceil(X2 / ?CLIENT_X_GRID),
    Ty = util:ceil(Y2 / ?CLIENT_Y_GRID),
    get_path(BaseId, {Fx, Fy}, {Fx, Fy}, {Tx, Ty}).
get_path(BaseId, From, {X1, Y1}, {X2, Y2}) ->
    %% 计算下一个行进点
    X = if X1 < X2 -> X1 + 1; X1 > X2 -> X1 - 1; true -> X1 end,
    Y = if Y1 < Y2 -> Y1 + 1; Y1 > Y2 -> Y1 - 1; true -> Y1 end,
    %% 检查是否可到达
    case is_client_blocked(BaseId, X, Y) of
        true -> 
            case {X1, Y1} =:= From of
                true  -> blocked; %% 还在原点，说明一格也不能移动
                false -> {X1 * ?CLIENT_X_GRID, Y1 * ?CLIENT_Y_GRID}
            end;
        false -> 
            case X =:= X2 andalso Y =:= Y2 of %% 已到达终点
                true  -> {X * ?CLIENT_X_GRID, Y * ?CLIENT_Y_GRID};
                false -> get_path(BaseId, From, {X, Y}, {X2, Y2})
            end
    end.

%% @spec start_link() -> ok
%% @doc 启动地图进程管理器
start_link() ->
    start_link(true).

start_link(IsStartUp) ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [IsStartUp], []).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([IsStartUp]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(map_info, [set, named_table, public, {keypos, #map.gid}]),
    ets:new(map_info_block, [set, named_table, protected]),
    load_walkable(map_data:all()),
    case IsStartUp of
        true ->
            case center:is_cross_center() of
                true ->
                    util:for(1, ?LINE_MAX, fun(Line) ->
                        create_startup(Line, map_data_cross:startup())
                    end);
                false ->
                    util:for(1, ?LINE_MAX, fun(Line) ->
                        create_startup(Line, map_data:startup())
                    end)
            end;
        _ ->
            ok
    end,
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% 申请一个地图ID
handle_call(fetch_id, _From, State = #state{next_id = Id}) ->
    {reply, Id, State#state{next_id = Id + 1}};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 处理地图进程正常退出
handle_info({'EXIT', _Pid, normal}, State) ->
    ?DEBUG("连接的进程[~w]已经正常退出", [_Pid]),
    {noreply, State};

%% 处理地图进程异常退出
handle_info({'EXIT', Pid, Why}, State) ->
    ?ELOG("连接的进程[~w]异常退出: ~w", [Pid, Why]),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% 启动普通地图
create_startup(_Line, []) -> ok;
create_startup(Line, [BaseId | T]) when BaseId > 100000 ->
    ?ELOG("创建地图进程失败:普通地图的ID[~w]不能大于100000", [BaseId]),
    create_startup(Line, T);
create_startup(Line, [BaseId | T]) ->
    case map_data:get(BaseId) of
        false -> ?ELOG("创建地图进程失败:不存在的地图[~w]", [BaseId]);
        #map_data{id = BaseId, elem = Elems, condition = Cond, npc = NpcList, width = W, height = H, type = Type} ->
            Map = #map{gid = MapGid = {Line, BaseId}, id = BaseId, owner_pid = self(), base_id = BaseId, elem = handle_elems(Elems), condition = Cond, width = W, height = H, type = Type},
            case catch map:start_link(Map) of
                {ok, _MapPid} ->
                    create_npc(NpcList, MapGid); %% 启动地图关联的NPC
                _Err -> ?ELOG("创建地图进程失败:~w", [_Err])
            end
    end,
    create_startup(Line, T).

%% 创建关联NPC
create_npc([], _MapGid) -> ok;
create_npc([{NpcBaseId, {X, Y}, Disabled, Paths} | T], MapGid) ->
    npc_mgr:create(NpcBaseId, MapGid, X, Y, Disabled, Paths),
    create_npc(T, MapGid).

%% 加载可行走区块信息
load_walkable([]) -> ok;
load_walkable([BaseId | T]) ->
    case map_data_walkable:get(BaseId) of
        false -> ?ERR("地图[~w]不存在", [BaseId]);
        Block ->
            do_load_walkable(BaseId, Block)
    end,
    load_walkable(T).
do_load_walkable(_BaseId, []) -> ok;
do_load_walkable(BaseId, [{X, Y} | T]) ->
    ets:insert(map_info_block, {{BaseId, X, Y}}),
    do_load_walkable(BaseId, T).

%% 处理地图元素配置数据
handle_elems(Elems) -> handle_elems(Elems, []).
handle_elems([], L) -> L;
handle_elems([{Id, BaseId, Name, X, Y, Disabled, {_, _, _} = D} | T], L) ->
    handle_elems(T, [#map_elem{id = Id, base_id = BaseId, type = ?elem_tele, status = 0, name = Name, x = X, y = Y, disabled = Disabled, data = D} | L]);
handle_elems([{Id, BaseId, Status, X, Y, Disabled} | T], L) ->
    case map_data_elem:get(BaseId) of
        false ->
            ?ELOG("地图数据配置错误:找不到地图元素[~w]的配置数据", [Id]),
            handle_elems(T, L);
        E ->
            handle_elems(T, [E#map_elem{id = Id, base_id = BaseId, status = Status, x = X, y = Y, disabled = Disabled} | L])
    end.

%% 处理事件监听器
handle_evt_listener(Events) -> handle_evt_listener(Events, []).
handle_evt_listener([], Back) -> Back;
handle_evt_listener([{Evts, Actions, Prob, Repeat, Msg} | T], Back) ->
    handle_evt_listener(T, [#map_listener{events = handle_evt_label(Evts), actions = Actions, prob = Prob, repeat = Repeat, msg = Msg} | Back]);
handle_evt_listener([{Evts, Actions} | T], Back) ->
    handle_evt_listener(T, [#map_listener{events = handle_evt_label([Evts]), actions = Actions, prob = 100, repeat = 1} | Back]);
handle_evt_listener([H | T], Back) ->
    ?ELOG("地图数据配置错误:错误的事件配置 [~w]", [H]),
    handle_evt_listener(T, Back).

%% 处理事件标识
handle_evt_label(Elabels) -> handle_evt_label(Elabels, []).
handle_evt_label([], Back) -> Back;
handle_evt_label([H | T], Back) ->
    handle_evt_label(T, [{H, ?false} | Back]).

%% 根据客户端坐标判断是否可行走
is_client_blocked(BaseId, Cx, Cy) ->
    case catch ets:lookup(map_info_block, {BaseId, Cx, Cy}) of
        [] -> true;
        [_] -> false;
        _ -> true
    end.

