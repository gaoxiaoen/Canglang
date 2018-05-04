%:w%----------------------------------------------------
%% 地图事件处理
%% @author yeahoo2000@gmail.com, abu@jieyou.cn
%% @end
%%----------------------------------------------------
-module(map_event).
-export([dispatch/3]).
-include("common.hrl").
-include("map.hrl").
-include("npc.hrl").

%-define(debug_log(P), ?DEBUG("type=~w, value=~w", P)).
-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%% api functions
%% --------------------------------------------------------------------

%% @spec dispatch() 
%% 提交事件
dispatch({role_enter, {Rid, Rpid}}, _Params, Map = #map{id = Mid, base_id = MbaseId, owner_pid = Opid}) ->
    dungeon:post_event(Opid, {role_enter_map, {Rid, Rpid}, {Mid, MbaseId}}),
    Map;
dispatch(Event, Params, Map = #map{event = Listeners}) ->
    ?debug_log([dispatch_evt, Event]),
    ?debug_log([dispatch_listener, Listeners]),
    NewListeners = do_dispatch(Event, Params, Listeners, Map, []),
    Map#map{event = NewListeners}.

%% --------------------------------------------------------------------
%% 内部函数
%% --------------------------------------------------------------------
do_dispatch(_Event, _Params, _Listeners = [], _Map, Back) ->
    Back;
do_dispatch(Event, Params, _Listeners = [H | T], Map, Back) ->
    NewListener = do_listener(Event, Params, H, Map),
    do_dispatch(Event, Params, T, Map, [NewListener | Back]).

%% 处理事件与监听器
do_listener(Event, Params, Listener = #map_listener{events = Elabels, actions = Actions, repeat = Repeat, trigger_count = Tcount, prob = Prob, msg = Msg}, Map) when Repeat > Tcount ->
    ?debug_log([do_listener, {Event, Listener}]),
    case match_event(Event, Elabels) of
        {true, NewElabels} ->
            ?debug_log([match_true, {Elabels, NewElabels}]),
            case match_prob(Prob) of
                true ->
                    ?debug_log([prob, true]),
                    action(Actions, Params, Map),
                    info_msg(Map#map.pid, Msg),
                    Listener#map_listener{trigger_count = Tcount + 1, events = NewElabels};
                false ->
                    ?debug_log([prob, false]),
                    Listener#map_listener{trigger_count = Tcount + 1, events = NewElabels}
            end;
        {false, NewElabels} ->
            ?debug_log([match_false, {Elabels, NewElabels}]),
            Listener#map_listener{events = NewElabels}
    end;
do_listener(_Event, _Params, Listener, _Map) ->
    ?debug_log([do_listener_limit_count, Listener]),
    Listener.

%% 匹配事件监听器
match_event(Event, Elabels) ->
    NewElabels = [do_match_label(Event, Elabel) || Elabel <- Elabels],
    case [Ne || Ne = {_, F} <- NewElabels, F =:= ?false] of
        [] ->
            {true, [{E, ?false} || {E, _} <- NewElabels]};
        _ ->
            {false, NewElabels}
    end.

%% 匹配事件
do_match_label(Event, Elabel = {E, Flag}) when Flag =:= ?false ->
    case Event =:= E of 
        true -> 
            {E, ?true};
        false ->
            Elabel
    end;
do_match_label(_Event, Elabel) ->
    Elabel.

%% 配置概率
match_prob(Prob) ->
    util:rand(1, 100) =< Prob.

%%
%% 触发动作
action(Acts, Params, Map) when is_list(Acts) ->
    [action(Act, Params, Map) || Act <- Acts];

%% 创建NPC
action({create_npc, NpcBaseId, X, Y}, _, #map{id = MapId}) when NpcBaseId =:= 11203 ->
    ?debug_log([create_npc, NpcBaseId]),
    case npc_mgr:create(NpcBaseId, MapId, X, Y) of
        {ok, NpcId} ->
            case npc_mgr:lookup(by_id, NpcId) of
                #npc{id = NpcId, pos = Pos} ->
                    npc_store_dung:create(NpcId, Pos);
                _E -> 
                    ?ERR("创建npc[~w]神秘商店失败：~w", [NpcBaseId, _E])
            end;
        _ -> ?ERR("副本神秘老人创建失败")
    end;
action({create_npc, NpcBaseId, X, Y}, _, #map{id = MapId}) ->
    ?debug_log([create_npc, NpcBaseId]),
    npc_mgr:create(NpcBaseId, MapId, X, Y);

%% 清除某个NPC
action({remove_npc, _NpcBaseId}, _, _Map) ->
    todo;

%% 设置某个NPC的禁止击杀状态
action({enable_npc, NpcBaseId}, _, _Map) ->
    ?debug_log([enable_npc, NpcBaseId]),
    NpcList = get(npc_list),
    Targets = [ npc_mgr:lookup(by_id, NpcId) || #map_npc{base_id = BaseId, id = NpcId } <- NpcList, BaseId =:= NpcBaseId],
    [npc:enable(Pid) || #npc{pid = Pid} <- Targets];

%% 取消某个NPC的禁止击杀状态
action({disable_npc, NpcBaseId, Reason}, _, _Map) ->
    ?debug_log([disable_npc, NpcBaseId]),
    NpcList = get(npc_list),
    Targets = [npc_mgr:lookup(by_id, NpcId) || #map_npc{base_id = BaseId, id = NpcId} <- NpcList, BaseId =:= NpcBaseId],
    [npc:disable(Pid, Reason) || #npc{pid = Pid} <- Targets];

%% 创建地图元素
action({create_elem, Id, ElemBaseId, Status, X, Y, Disabled}, _, #map{pid = Mpid}) ->
    ?debug_log([create_elem, ElemBaseId]),
    case map_data_elem:get(ElemBaseId) of
        false ->
            ?ELOG("地图事件配置错误:找不到地图元素[~w]的配置数据", [ElemBaseId]),
            {false};
        E ->
            map:elem_enter(Mpid, E#map_elem{id = Id, base_id = ElemBaseId, status = Status, x = X, y = Y, disabled = Disabled})
    end;

%% 创建传送阵
action({create_dun_tele, Id, BaseId, Name, X, Y, Disabled, Data}, _, #map{owner_pid = Opid}) ->
    dungeon:post_event(Opid, {create_dun_tele, Id, BaseId, Name, X, Y, Disabled, Data});

%% 创建暗雷怪
action({create_hide_npc, NpcInfo}, _, #map{owner_pid = Opid}) ->
    dungeon:post_event(Opid, {create_hide_npc, NpcInfo});

%% 清除某个地图元素
action({remove_elem, ElemId}, _, _Map = #map{pid = Pid}) ->
    ?debug_log([remove_elem, ElemId]),
    map:elem_leave(Pid, ElemId);

%% 取消地图元素禁用状态
action({enable_elem, ElemId}, _, #map{pid = MapPid}) ->
    ?debug_log([enable_elem, ElemId]),
    map:elem_enable(MapPid, ElemId);

%% 禁用地图元素
action({disable_elem, ElemId, Reason}, _, #map{pid = Mpid}) ->
    ?debug_log([disable_elem, ElemId]),
    map:elem_disable(Mpid, ElemId, Reason);

%% 修改地图元素的状态
action({elem_status, ElemId, Status}, _, #map{pid = Mpid}) ->
    ?debug_log([elem_status, {ElemId, Status}]),
    map:elem_change(Mpid, ElemId, Status); 

%% 副本处理杀死怪物的处理
action({dun_kill_npc}, {NpcBaseId, Round}, #map{id = Mid, base_id = MbaseId, owner_pid = Opid}) ->
    dungeon:post_event(Opid, {kill_npc, {Mid, MbaseId}, NpcBaseId, Round});

%% 副本事件
action({dungeon_event, Event}, _, #map{owner_pid = Opid}) ->
    dungeon:post_event(Opid, Event);

%% 容错
action(Action, _Params, _Map) ->
    ?ERR("未知的地图事件处理器:~w", [Action]).

%% 提示地图事件
info_msg(Mpid, Msg) ->
    map:pack_send_to_all(Mpid, 10931, {55, Msg, []}),
    map:pack_send_to_all(Mpid, 10932, {8, 0, Msg}).



