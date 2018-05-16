%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 二月 2017 13:59
%%%-------------------------------------------------------------------
-module(scene_copy_proc).

-author("hxming").
-include("scene.hrl").

%% API
-behaviour(gen_server).

-include("common.hrl").

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-define(SERVER, ?MODULE).

-define(MAX_MEMBERS_OF_COPY_SCENE(Sid), data_scene_copy:get(Sid)).%%线路人数上限
%%-define(MAX_MEMBERS_OF_COPY_SCENE(Sid), 1).%%线路人数上限
-define(TIME_LIM, 7200).

-define(SCENE_COPY_TYPE_NORMAL, 1).
-define(SCENE_COPY_TYPE_CROSS, 2).

-record(state, {scene_copy_list = []}).

%% API
-export([
    start_link/0
    , get_server_pid/0
]).

-export([
    init_scene_copy/2,
    erase_scene_copy/2,
    enter_scene/3,
    leave_scene/3,
    get_scene_copy/2,
    get_scene_copy_ids/1,
    get_scene_copy_list/1,
    set_default/2,
    cross_copy_list_to_local/2
]).

-export([
    do_get_scene_copy/2,
    reset_scene_copy/1
]).
%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%获取进程PID
get_server_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

%%初始化线路
init_scene_copy(SceneId, Copy) ->
%%    case is_can_copy_scene(SceneId) of
%%        false -> ok;
%%        true ->
    get_server_pid() ! {init_scene_copy, SceneId, Copy}.
%%    end.

erase_scene_copy(SceneId, Copy) ->
    get_server_pid() ! {erase_scene_copy, SceneId, Copy}.

%%玩家加入场景
enter_scene(SceneId, CopyId, Sn) ->
    case is_can_copy_scene(SceneId) of
        false -> ok;
        true ->
            get_server_pid() ! {enter_scene, SceneId, CopyId, Sn}
    end.

%%玩家离开场景
leave_scene(SceneId, CopyId, Sn) ->
    case is_can_copy_scene(SceneId) of
        false -> ok;
        true ->
            get_server_pid() ! {leave_scene, SceneId, CopyId, Sn}
    end.

is_can_copy_scene(SceneId) ->
    SceneType = scene:get_scene_type(SceneId),
    lists:member(SceneType, ?SCENE_TYPE_CAN_COPY).

%%获取线路
get_scene_copy(SceneId, OldCopyId) ->
    case is_can_copy_scene(SceneId) of
        true ->
            SceneType = scene:get_scene_type(SceneId),
            case config:is_center_node() of
                true ->
                    do_get_scene_copy(SceneId, OldCopyId);
                false ->
                    case lists:member(SceneType, ?SCENE_TYPE_CROSS_AREA_LIST) of
                        true -> cross_area:apply_call(scene_copy_proc, do_get_scene_copy, [SceneId, OldCopyId]);
                        false ->
                            case lists:member(SceneType, ?SCENE_TYPE_CROSS_ALL_LIST) of
                                true ->
                                    cross_all:apply_call(scene_copy_proc, do_get_scene_copy, [SceneId, OldCopyId]);
                                false ->
                                    do_get_scene_copy(SceneId, OldCopyId)
                            end
                    end
            end;
        false ->
            0
    end.

do_get_scene_copy(SceneId, OldCopyId) ->
    case ?CALL(get_server_pid(), {get_scene_copy, SceneId, OldCopyId}) of
        [] ->

            0;
        Copy -> Copy
    end.


%%获取场景线路id列表
get_scene_copy_ids(SceneId) ->
    ?CALL(get_server_pid(), {get_scene_copy_ids, SceneId}).


%%获取场景线路信息
get_scene_copy_list(SceneId) ->
    get_server_pid() ! {get_scene_copy_list, SceneId}.

%%设置默认线路
set_default(SceneId, Default) ->
    get_server_pid() ! {set_default, SceneId, Default}.


%%跨服主城线路数据同步
cross_copy_list_to_local(SceneId, CopyList) ->
    get_server_pid() ! {cross_copy_list_to_local, SceneId, CopyList}.


reset_scene_copy(SceneId) ->
    get_server_pid() ! {reset_scene_copy, SceneId}.

init([]) ->
    {ok, #state{}}.



handle_call(Request, _From, State) ->
    case catch call(Request, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("scene copy handle_call ~p/~p~n", [Request, Reason]),
            {reply, error, State}
    end.


handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(Request, State) ->
    case catch info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("scene copy handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
call({get_scene_copy, SceneId, OldCopyId}, State) ->
    case lists:keytake(SceneId, #scene_copy.scene_id, State#state.scene_copy_list) of
        false ->
            {reply, OldCopyId, State};
        {value, SceneCopy, T} ->
            NewSceneCopy = refresh_scene_copy(SceneCopy),
            NewCopyId = fetch_copy(NewSceneCopy, OldCopyId),
%%            ?DEBUG("SceneId ~p NewCopyId ~p~n", [SceneId, NewCopyId]),
            {reply, NewCopyId, State#state{scene_copy_list = [NewSceneCopy | T]}}
    end;

call({get_scene_copy_ids, SceneId}, State) ->
    Reply =
        case lists:keyfind(SceneId, #scene_copy.scene_id, State#state.scene_copy_list) of
            false -> [];
            SceneCopy ->
                {_, NewCopyList} = filter_scene_copy(SceneCopy),
                [CopyCount#scene_copy_count.copy || CopyCount <- NewCopyList]
        end,
    {reply, Reply, State};

call(_Msg, State) ->
    {reply, ok, State}.

%%设置场景线路数据
info({init_scene_copy, SceneId, Copy}, State) ->
    SceneCopyList =
        case lists:keytake(SceneId, #scene_copy.scene_id, State#state.scene_copy_list) of
            false ->
                SceneCopy = #scene_copy{scene_id = SceneId, copy_list = [#scene_copy_count{copy = Copy, time = util:unixtime()}]},
                [SceneCopy | State#state.scene_copy_list];
            {value, Old, T} ->
                CopyList =
                    case lists:keymember(Copy, #scene_copy_count.copy, Old#scene_copy.copy_list) of
                        false ->
                            [#scene_copy_count{copy = Copy, time = util:unixtime()} | Old#scene_copy.copy_list];
                        true ->
                            Old#scene_copy.copy_list
                    end,
                [Old#scene_copy{copy_list = CopyList} | T]
        end,
    {noreply, State#state{scene_copy_list = SceneCopyList}};

info({reset_scene_copy, SceneId}, State) ->
    SceneCopy = #scene_copy{scene_id = SceneId, copy_list = [#scene_copy_count{copy = 0, time = util:unixtime()}]},
    SceneCopyList = [SceneCopy | lists:keydelete(SceneId, #scene_copy.scene_id, State#state.scene_copy_list)],
    {noreply, State#state{scene_copy_list = SceneCopyList}};

%%删除线路信息
info({erase_scene_copy, SceneId, Copy}, State) ->
    SceneCopyList =
        case lists:keytake(SceneId, #scene_copy.scene_id, State#state.scene_copy_list) of
            false ->
                State#state.scene_copy_list;
            {value, SceneCopy, T} ->
                CopyList = lists:keydelete(Copy, #scene_copy_count.copy, SceneCopy#scene_copy.copy_list),
                [SceneCopy#scene_copy{copy_list = CopyList} | T]

        end,
    {noreply, State#state{scene_copy_list = SceneCopyList}};

%%加入场景
info({enter_scene, SceneId, CopyId, Sn}, State) ->
    SceneCopyList =
        case lists:keytake(SceneId, #scene_copy.scene_id, State#state.scene_copy_list) of
            false ->
                SceneCopyCount = #scene_copy_count{copy = CopyId, count = 1, time = util:unixtime(), log_sn = [{Sn, 1}]},
                SceneCopy = #scene_copy{scene_id = SceneId, copy_list = [SceneCopyCount]},
                [SceneCopy | State#state.scene_copy_list];
            {value, SceneCopy, T} ->
                case lists:keytake(CopyId, #scene_copy_count.copy, SceneCopy#scene_copy.copy_list) of
                    false ->
                        [];
                    {value, SceneCopyCount, L} ->
                        LogSn = case lists:keytake(Sn, 1, SceneCopyCount#scene_copy_count.log_sn) of
                                    false -> [{Sn, 1} | SceneCopyCount#scene_copy_count.log_sn];
                                    {value, {_, SnCount}, T1} ->
                                        [{Sn, SnCount + 1} | T1]
                                end,
                        NewSceneCopyCount = SceneCopyCount#scene_copy_count{count = SceneCopyCount#scene_copy_count.count + 1, log_sn = LogSn},
                        NewSceneCopy = SceneCopy#scene_copy{copy_list = [NewSceneCopyCount | L]},
                        [NewSceneCopy | T]
                end
        end,
%%    ?DEBUG("enter scenecopylist ~p~n", [SceneCopyList]),
    {noreply, State#state{scene_copy_list = SceneCopyList}};

%%离开场景
info({leave_scene, SceneId, CopyId, Sn}, State) ->
    SceneCopyList =
        case lists:keytake(SceneId, #scene_copy.scene_id, State#state.scene_copy_list) of
            false ->
                State#state.scene_copy_list;
            {value, SceneCopy, T} ->
                case lists:keytake(CopyId, #scene_copy_count.copy, SceneCopy#scene_copy.copy_list) of
                    false ->
                        State#state.scene_copy_list;
                    {value, SceneCopyCount, L} ->
                        LogSn = case lists:keytake(Sn, 1, SceneCopyCount#scene_copy_count.log_sn) of
                                    false -> SceneCopyCount#scene_copy_count.log_sn;
                                    {value, {_, SnCount}, T1} ->
                                        [{Sn, max(0, SnCount - 1)} | T1]
                                end,
                        NewSceneCopyCount = SceneCopyCount#scene_copy_count{count = max(0, SceneCopyCount#scene_copy_count.count - 1), log_sn = LogSn},
                        NewSceneCopy = SceneCopy#scene_copy{copy_list = [NewSceneCopyCount | L]},
                        [NewSceneCopy | T]
                end
        end,
%%    ?DEBUG("leave scenecopylist ~p~n", [SceneCopyList]),
    {noreply, State#state{scene_copy_list = SceneCopyList}};

info({get_scene_copy_list, SceneId}, State) ->
    Info =
        case lists:keyfind(SceneId, #scene_copy.scene_id, State#state.scene_copy_list) of
            false ->
                {0, []};
            SceneCopy ->
                {_, NewCopyList} = filter_scene_copy(SceneCopy),
                DefaultCopyId = default_scene_copy(?SCENE_COPY_TYPE_NORMAL, NewCopyList),
                L = lists:keysort(#scene_copy_count.copy, NewCopyList),
                {DefaultCopyId, L}
        end,
    ?ERR("get_scene_copy_list sid ~p /~p~n ", [SceneId, Info]),
    {noreply, State};

%%设置默认线路
info({set_default, SceneId, Default}, State) ->
    SceneCopyList =
        case lists:keytake(SceneId, #scene_copy.scene_id, State#state.scene_copy_list) of
            false -> State#state.scene_copy_list;
            {value, SceneCopy, T} ->
                [SceneCopy#scene_copy{default = Default} | T]
        end,
    {noreply, State#state{scene_copy_list = SceneCopyList}};

info({cross_copy_list_to_local, SceneId, CopyList}, State) ->
    SceneCopyList =
        case lists:keytake(SceneId, #scene_copy.scene_id, State#state.scene_copy_list) of
            [] -> [#scene_copy{scene_id = SceneId, cross_copy_list = CopyList} | State#state.scene_copy_list];
            {value, SceneCopy, T} ->
                [SceneCopy#scene_copy{cross_copy_list = CopyList} | T]
        end,
    {noreply, State#state{scene_copy_list = SceneCopyList}};

info(all,State)->
    ?WARNING("scene_copy_list ~p~n",[State#state.scene_copy_list]),
    {noreply,State};

info(_Msg, State) ->
    {noreply, State}.


%%刷新线路
refresh_scene_copy(SceneCopy) ->
    F = fun(SceneCopyCount) ->
        ?IF_ELSE(SceneCopyCount#scene_copy_count.count == 0, check_close(SceneCopy#scene_copy.scene_id, SceneCopyCount), [SceneCopyCount])
        end,
    CopyList = lists:flatmap(F, SceneCopy#scene_copy.copy_list),
    %%检查线路是否爆满,是则开启新的线路
    F1 = fun(SceneCopyCount) ->
        SceneCopyCount#scene_copy_count.count >= ?MAX_MEMBERS_OF_COPY_SCENE(SceneCopy#scene_copy.scene_id) end,
    NewCopyList =
        case lists:all(F1, CopyList) of
            false -> CopyList;
            true ->
                NewCopy = get_copy_id([CopyCount#scene_copy_count.copy || CopyCount <- CopyList], 0),
                scene_init:create_scene(SceneCopy#scene_copy.scene_id, NewCopy),
%%                scene_agent:load_scene_data(SceneCopy#scene_copy.scene_id, NewCopy),
                [#scene_copy_count{copy = NewCopy, time = util:unixtime()} | CopyList]
        end,
    ?DO_IF(NewCopyList /= SceneCopy#scene_copy.copy_list, sync_copy_list(SceneCopy#scene_copy.scene_id, NewCopyList)),
    SceneCopy#scene_copy{copy_list = NewCopyList}.


%%检查线路是否需关闭
check_close(SceneId, CopyCount) ->
    if CopyCount#scene_copy_count.copy == 0 -> [CopyCount];
        true ->
            case util:unixtime() - CopyCount#scene_copy_count.time >= ?TIME_LIM of
                true ->
                    case CopyCount#scene_copy_count.count / ?MAX_MEMBERS_OF_COPY_SCENE(SceneId) >= 0.1 of
                        true -> [CopyCount];
                        false ->
                            %%线路没人了，关闭线路
                            if CopyCount#scene_copy_count.count == 0 ->
                                scene_init:stop_scene(SceneId, CopyCount#scene_copy_count.copy),
%%                                [monster:stop_broadcast(MonPid) || MonPid <- mon_agent:get_scene_mon_pids(SceneId, CopyCount#scene_copy_count.copy)],
%%                                scene_agent:clean_scene_area(SceneId, CopyCount#scene_copy_count.copy),
                                [];
                                true -> [CopyCount]
                            end
                    end;
                false ->
                    [CopyCount]
            end
    end.

%%获取新的线路id
get_copy_id([], Copy) -> Copy;
get_copy_id(CopyList, Copy) ->
    case lists:member(Copy, CopyList) of
        true ->
            get_copy_id(CopyList, Copy + 1);
        false -> Copy
    end.


%%获取线路
fetch_copy(SceneCopy, OldCopyId) ->
    if SceneCopy#scene_copy.default -> 0;
        true ->
            {Type, NewCopyList} = filter_scene_copy(SceneCopy),
            case lists:keyfind(OldCopyId, #scene_copy_count.copy, NewCopyList) of
                false ->
                    %%新场景没有上一场景的线路，切换新的
                    default_scene_copy(Type, NewCopyList);
                CopyCount ->
                    MaxCount = ?MAX_MEMBERS_OF_COPY_SCENE(SceneCopy#scene_copy.scene_id),
                    if CopyCount#scene_copy_count.count >= MaxCount ->
                        default_scene_copy(Type, NewCopyList);
                    %%原房间线路如果符合原来的的进入规则，不切换
                        true -> OldCopyId
                    end
            end
    end.

%%过滤掉需关闭的线路，人数不足，线路开放大于2小时以上的才检查
%%0线路不过滤，
filter_scene_copy(SceneCopy) ->
    SceneId = SceneCopy#scene_copy.scene_id,
    NowTime = util:unixtime(),
    F = fun(CopyCount) ->
        if CopyCount#scene_copy_count.copy == 0 -> [CopyCount];
            NowTime - CopyCount#scene_copy_count.time >= ?TIME_LIM ->
                case CopyCount#scene_copy_count.count / ?MAX_MEMBERS_OF_COPY_SCENE(SceneId) >= 0.1 of
                    true -> [CopyCount];
                    false -> []
                end;
            true -> [CopyCount]
        end
        end,
    case scene:check_normal_scene_cross_state(SceneCopy#scene_copy.scene_id) of
        false ->
            {?SCENE_COPY_TYPE_NORMAL, lists:flatmap(F, SceneCopy#scene_copy.copy_list)};
        _ ->
            {?SCENE_COPY_TYPE_CROSS, lists:flatmap(F, SceneCopy#scene_copy.cross_copy_list)}
    end.


%%查找人数最少场景线路
default_scene_copy(_, CopyList) ->
    NewCopyList = lists:keysort(#scene_copy_count.count, CopyList),
    case NewCopyList of
        [] -> 0;
        [Find | _] -> Find#scene_copy_count.copy
    end.
%%优先同服玩家最多的线路
%%default_scene_copy(?SCENE_COPY_TYPE_CROSS, CopyList) ->
%%    Sn = config:get_server_num(),
%%    F = fun(CopyCount) ->
%%        Count =
%%            case lists:keyfind(Sn, 1, CopyCount#scene_copy_count.log_sn) of
%%                false -> 0;
%%                {_, Val} -> Val
%%            end,
%%        CopyCount#scene_copy_count{count = Count}
%%        end,
%%    NewCopyList = lists:map(F, CopyList),
%%    NewCopyList = lists:reverse(lists:keysort(#scene_copy_count.count, NewCopyList)),
%%    case NewCopyList of
%%        [] -> 0;
%%        [Find | _] -> Find#scene_copy_count.copy
%%    end.


%%同步跨服线路数据
sync_copy_list(SceneId, CopyList) ->
    case center:is_center_all() of
        true ->
            F = fun(Node) -> center:apply(Node, scene_copy_proc, cross_copy_list_to_local, [SceneId, CopyList]) end,
            lists:foreach(F, center:get_nodes());
        false -> skip
    end.