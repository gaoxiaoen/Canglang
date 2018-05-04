%% --------------------------------------------------------------------
%% 地图元素引起的事件处理
%% @author abu@jieyou.cn
%% --------------------------------------------------------------------
-module(map_elem_event).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("item.hrl").
-include("gain.hrl").
-include("task.hrl").
-include("dungeon.hrl").
%%
-include("combat.hrl").
-include("attr.hrl").

-export([do/3]).

%% @spec do(Event, Role, MapElem) -> {ok, NewRolw} | {false, Reason}
%% Event = #map_elem_event{}
%% Role = NewRole = #role{}
%% MapElem = #map_elem{}
%% Reason = bitstring()
%% 处理 操作地图元素 引起的事件
do(#map_elem_event{label = hide_box, value = BoxId}, Role = #role{event = ?event_dungeon, event_pid = Pid},
    #map_elem{id = ElementId}) ->
    case do_config_rewards(BoxId, Role) of
        {ok, Role2, CastItems} ->
            dungeon:post_event(Pid, {open_hide_box, ElementId, CastItems}),
            {ok, Role2};
        {false, Reason} ->
            {false, Reason}
    end;

%% 其它不处理
do(_Evt, Role, _MapElem) ->
    ?ERR("map elem config error: ~w~n", [_Evt]),
    {ok, Role}.

%% 处理配置
do_config_rewards(ConId, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case item_gift_data:get_box(ConId) of
        {false, Reason} -> {false, Reason};
        {Bind, Type, Num, L} -> 
            GetL = item:get_gift_list(Type, Num, Bind, L, Role),
            case item:make_gift_list(GetL) of
                {false, Reason} -> {false, Reason};
                {ok, GainList, CastItems} ->
                    case role_gain:do(GainList, Role) of
                        {false, G} -> 
                            sys_conn:pack_send(ConnPid, 10150, {[]}),
                            {false, G#gain.msg};
                        {ok, NewRole} ->
                            ProtoGains = get_proto_gains(GainList),
                            sys_conn:pack_send(ConnPid, 10150, {ProtoGains}),
                            {ok, NewRole, CastItems}
                    end
            end
    end.

get_proto_gains(Gains) ->
    get_proto_gains(Gains, []).
get_proto_gains([], Return) ->
    Return;
get_proto_gains([#gain{label = item, val = [ItemBaseId, Bind, Count]} | T], Return) ->
    get_proto_gains(T, [{ItemBaseId, Bind, Count} | Return]);
get_proto_gains([_ | T], Return) ->
    get_proto_gains(T, Return).
