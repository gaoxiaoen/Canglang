%%----------------------------------------------------
%% 地图元素操作
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(map_elem_action).
-export([def/2, do/4, check/1]).
-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("gain.hrl").
-include("item.hrl").
%%

%% macro
-define(pick_cooldown, 2).
-define(pick_cooldown_flag, last_pick_time).

%% @spec gen(Elem, Status) -> false | EventName 
%% Elem = #map_elem{}
%% Status = integer()
%% EventName = atom()
%% @doc 跟据玩家的操作码，转换成操作类型
def(#map_elem{type = ?elem_tele}, _) -> trigger;    %% 触发传送阵
def(#map_elem{type = ?elem_box}, 0) -> pickup;      %% 拾取宝箱
def(#map_elem{type = ?elem_mine}, _) -> pickup;     %% 获取矿石
def(#map_elem{type = ?elem_task_mine}, _) ->pickup; %% 获取任务矿石
def(#map_elem{type = ?elem_gate}, 0) -> open;       %% 打开
def(#map_elem{type = ?elem_gate}, 1) -> close;      %% 关闭
def(#map_elem{type = ?elem_cast}, 0) -> open_cast;  %% 打开效果
def(#map_elem{type = ?elem_cast}, _) -> close_cast; %% 关闭效果
def(#map_elem{type = ?elem_sit}, _) -> guild_sit;   %% 帮会上座
def(#map_elem{type = ?elem_no_cast}, _) -> handle_no_cast; %%操作不广播的元素 
def(#map_elem{type = ?elem_onetime}, _) -> pickup_onetime;  %% 一次性采集
def(#map_elem{type = ?elem_guild_war}, _) -> click_guild_war;  %% 点击帮战元素
def(#map_elem{type = ?elem_guild_arena}, _) -> click_guild_arena;  %% 点击新帮战元素
def(#map_elem{type = ?elem_multi_status}, _) -> pickup_multi;  %% 采集多状态元素
def(#map_elem{type = ?elem_qixi_box}, _) -> pickup; %% 点击七夕宝盒
def(#map_elem{type = ?elem_guard_counter}, _) -> click_guard_counter; %% 点击洛水反击战元素
def(#map_elem{type = ?elem_dun_liang}, _) -> pickup_multi;  %% 阆风阁副本元素
def(_Elem, _Status) -> undefined.  %% 未定义的操作

%% 触发传送阵
do(trigger, #map_elem{type = ?elem_tele}, #map{base_id = BaseId}, Role = #role{event = ?event_guild_war, event_pid = Epid})
when BaseId =:= 33001 orelse BaseId =:= 33002 ->
    guild_war:enter_war_map(Epid, Role),
    {ok};
do(trigger, #map_elem{type = ?elem_tele, data = {DestId, DestX, DestY}}, _MapPid, #role{id = Rid, team_pid = TeamPid})
when is_pid(TeamPid) ->
    team:enter(TeamPid, Rid, {DestId, DestX, DestY}),
    {ok};
do(trigger, #map_elem{type = ?elem_tele, data = {DestId, DestX, DestY}, trigger_msg = Tmsg}, _MapPid, Role) ->
    case map:role_enter(DestId, DestX, DestY, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} -> {ok, NewRole, Tmsg}
    end;

%% 拾取隐藏副本的宝箱
do(pickup, MapElem = #map_elem{name = _Name, id = ElemId, type = ?elem_box, data = ElemEvts}, #map{pid = MapPid}, Role) ->
    case do_elem_event(ElemEvts, Role, MapElem, []) of
        {ok, NewRole} ->
            map:elem_change(MapPid, ElemId, 1),
            {ok, NewRole};
        {false, Msg} -> 
            {false, Msg}
    end;

%% 拾取元素（独占）
do(pickup, MapElem = #map_elem{id = ElemId, type = ?elem_mine, data = ElemEvts, name = Name, trigger_msg = Tmsg}, #map{pid = MapPid}, Role) ->
    case check(Role) of
        true ->
            case map:elem_fetch(MapPid, ElemId) of
                false -> {false, util:fbin(?L(<<"你手慢了，~s 已经被其他人获取">>), [Name])};
                true ->
                    put(?pick_cooldown_flag, util:unixtime()),
                    MapPid ! {recreate_elem, MapElem, 3000},
                    case do_elem_event(ElemEvts, Role, MapElem, []) of
                        {ok, NewRole} ->
                            activity:pack_send_table([], NewRole),
                            {ok, NewRole, Tmsg};
                        {false, #gain{msg = Msg}} when Msg =/= <<>> ->
                            {false, Msg};
                        {false, #loss{msg = Msg}} when Msg =/= <<>> ->
                            {false, Msg};
                        {false, Msg} -> {false, Msg};
                        Other ->
                            Other
                    end
            end;
        {false, Reason} ->
            {false, Reason}
    end;

%% 拾取元素（非独占）
do(pickup, MapElem = #map_elem{id = _ElemId, type = ?elem_task_mine, data = ElemEvts, trigger_msg = Tmsg}, #map{pid = _MapPid}, Role) ->
    case check(Role) of
        true ->
            case do_elem_event(ElemEvts, Role, MapElem, []) of
                {ok, NewRole} ->
                    activity:pack_send_table([], NewRole),
                    {ok, NewRole, Tmsg};
                {false, #gain{msg = Msg}} when Msg =/= <<>> ->
                    {false, Msg};
                {false, #loss{msg = Msg}} when Msg =/= <<>> ->
                    {false, Msg};
                {false, Msg} -> {false, Msg}
            end;
        {false, Reason} ->
            {false, Reason}
    end;

%% 拾取烟花活动宝盒
do(pickup, MapElem = #map_elem{id = ElemId, type = ?elem_qixi_box, data = ElemEvts, name = Name, trigger_msg = Tmsg}, #map{pid = MapPid}, Role) ->
    case check(Role) of
        true ->
            put(?pick_cooldown_flag, util:unixtime()),
            case do_elem_event(ElemEvts, Role, MapElem, []) of
                {ok, NewRole} ->
                    case map:elem_fetch(MapPid, ElemId) of
                        false -> {false, util:fbin(?L(<<"你手慢了，~s 已经被其他人获取">>), [Name])};
                        true -> {ok, NewRole, Tmsg}
                    end;
                {false, #gain{msg = Msg}} when Msg =/= <<>> ->
                    {false, Msg};
                {false, #loss{msg = Msg}} when Msg =/= <<>> ->
                    {false, Msg};
                {false, Msg} -> {false, Msg};
                Other ->
                    Other
            end;
        {false, Reason} ->
            {false, Reason}
    end; 

%% 开门
do(open, #map_elem{id = ElemId, type = ?elem_gate, trigger_msg = Tmsg}, #map{pid = MapPid}, Role) ->
    map:elem_change(MapPid, ElemId, ?true),
    {ok, Role, Tmsg};

%% 关门
do(close, #map_elem{id = ElemId, type = ?elem_gate}, #map{pid = MapPid}, _Role) ->
    map:elem_change(MapPid, ElemId, ?false),
    {ok};

%% 打开效果
do(open_cast, MapElem = #map_elem{id = ElemId, type = ?elem_cast, data = ElemEvts, trigger_status = Tstatus, trigger_msg = Tmsg}, #map{pid = MapPid}, Role) ->
    map:elem_change(MapPid, ElemId, Tstatus),
    case do_elem_event(ElemEvts, Role, MapElem, []) of
        {ok, NewRole} ->
            {ok, NewRole, Tmsg};
        {false, #gain{msg = Msg}} when Msg =/= <<>> ->
            {false, Msg};
        {false, #loss{msg = Msg}} when Msg =/= <<>> ->
            {false, Msg};
        {false, Msg} -> {false, Msg}
    end;

%% 关闭效果
do(close_cast, #map_elem{id = ElemId, type = ?elem_cast}, #map{pid = MapPid}, _Role) ->
    map:elem_change(MapPid, ElemId, ?false),
    {ok};

%% 操作非广播元素
do(handle_no_cast, MapElem = #map_elem{type = ?elem_no_cast, data = ElemEvts}, #map{}, Role) ->
    case do_elem_event(ElemEvts, Role, MapElem, []) of
        {ok, NewRole} ->
            {ok, NewRole};
        {false, #gain{msg = Msg}} when Msg =/= <<>> ->
            {false, Msg};
        {false, #loss{msg = Msg}} when Msg =/= <<>> ->
            {false, Msg};
        {false, Msg} -> {false, Msg}
    end;

%% 帮会领地上座
do(guild_sit, #map_elem{id = ElemId, status = ?false, trigger_msg = Tmsg}, #map{pid = MapPid}, Role) ->
    case check(Role) of
        true ->
            map:elem_change(MapPid, ElemId, 1),
            {ok, guild_area:sit(ElemId, Role), Tmsg};
        {false, Reason} ->
            {false, Reason}
    end;

%% 帮会领地上座
do(guild_sit, #map_elem{id = ElemId, status = ?true}, _, Role = #role{special = Spec}) ->
    case check(Role) of
        true ->
            case lists:keyfind(?special_guild_sit, 1, Spec) of
                {_, ElemId, _} ->
                    {false, <<>>};
                _ ->
                    {false, ?L(<<"该座位上有人!">>)}
            end;
        {false, Reason} ->
            {false, Reason}
    end;

%% 拾取一次性元素
do(pickup_onetime, MapElem = #map_elem{id = ElemId, type = ?elem_onetime, data = ElemEvts, name = Name, trigger_msg = Tmsg}, #map{pid = MapPid}, Role) ->
    case check(Role) of
        true ->
            put(?pick_cooldown_flag, util:unixtime()),
            case map:elem_fetch(MapPid, ElemId) of
                false -> {false, util:fbin(?L(<<"你手慢了，~s 已经被其他人获取">>), [Name])};
                true ->
                    case do_elem_event(ElemEvts, Role, MapElem, []) of
                        {ok, NewRole} ->
                            {ok, NewRole, Tmsg};
                        {false, #gain{msg = Msg}} when Msg =/= <<>> ->
                            {false, Msg};
                        {false, #loss{msg = Msg}} when Msg =/= <<>> ->
                            {false, Msg};
                        {false, Msg} -> {false, Msg};
                        Other ->
                            Other
                    end
            end;
        {false, Reason} ->
            put(?pick_cooldown_flag, util:unixtime()),
            {false, Reason}
    end;

%% 点击帮战元素
do(click_guild_war, MapElem = #map_elem{}, #map{}, Role) ->
    case guild_war:click_elem(Role, MapElem) of
        {false, Reason} ->
            {false, Reason};
        _ ->
            {ok}
    end;

%% 点击洛水反击元素
do(click_guard_counter, MapElem = #map_elem{}, #map{}, Role) ->
    case guard_counter:click_elem(Role, MapElem) of
        {false, Reason} ->
            {false, Reason};
        _ ->
            {ok}
    end;

%% 点击新帮战元素
do(click_guild_arena, MapElem = #map_elem{}, #map{}, Role) ->
    case guild_arena:click_elem(Role, MapElem) of
        {false, Reason} ->
            {false, Reason};
        _ ->
            {ok}
    end;

%% 多状态地图元素操作
do(pickup_multi, MapElem = #map_elem{type = ?elem_multi_status, data = ElemEvts, trigger_msg = Tmsg}, #map{}, Role) ->
    case check(Role) of
        true ->
            case do_elem_event(ElemEvts, Role, MapElem, []) of
                {ok, NewRole} ->
                    {ok, NewRole, Tmsg};
                {false, #gain{msg = Msg}} when Msg =/= <<>> ->
                    {false, Msg};
                {false, #loss{msg = Msg}} when Msg =/= <<>> ->
                    {false, Msg};
                {false, Msg} -> {false, Msg};
                Other ->
                    Other
            end;
        {false, Reason} ->
            {false, Reason}
    end;

%% 多状态地图元素操作
do(pickup_multi, MapElem = #map_elem{type = ?elem_dun_liang, data = ElemEvts, trigger_msg = Tmsg}, #map{}, Role) ->
    case check(Role) of
        true ->
            case do_elem_event(ElemEvts, Role, MapElem, []) of
                {ok, NewRole} ->
                    {ok, NewRole, Tmsg};
                {false, #gain{msg = Msg}} when Msg =/= <<>> ->
                    {false, Msg};
                {false, #loss{msg = Msg}} when Msg =/= <<>> ->
                    {false, Msg};
                {false, Msg} -> {false, Msg};
                Other ->
                    Other
            end;
        {false, Reason} ->
            {false, Reason}
    end;

%% 无效操作
do(_Action, _Elem, _MapPid, _Role) ->
    ?DEBUG("elem action: ~w~n", [{_Action, _Elem#map_elem.id, _Elem#map_elem.type}]),
    {false, <<>>}.


%% 处理操作地图元素引起的事件
%% GainLoss 用于保存#gain, #loss到最后一次性执行
%% 其它情况交由map_elem_event处理
do_elem_event([], Role, _MapElem, GainLoss) ->
    case role_gain:do(GainLoss, Role) of
        {ok, NewRole} ->
            {ok, NewRole};
        Other ->
            Other
    end;
%% gain, loss
do_elem_event([H | T], Role, MapElem, GainLoss) when is_record(H, gain) orelse is_record(H, loss) ->
    do_elem_event(T, Role, MapElem, [H | GainLoss]);
%% 其它情况交由map_elem_event处理
do_elem_event([H | T], Role, MapElem, GainLoss) ->
    case map_elem_event:do(H, Role, MapElem) of
        {ok, NewRole} ->
            do_elem_event(T, NewRole, MapElem, GainLoss);
        {false, Reason} ->
            {false, Reason}
    end.

%% 判断当前状态是否可采集
check(Role) ->
    Now = util:unixtime(),
    case get(?pick_cooldown_flag) of
        Lp when is_integer(Lp) andalso Now - Lp < ?pick_cooldown ->
            {false, ?L(<<"请过一会再采集">>)};
        _ ->
            check_status(role, Role)
    end.

%% 采集状态校验
check_status(role, _Role = #role{ride = ?ride_fly}) -> {false, ?L(<<"飞行状态不能操作">>)};
%% check_status(role, Role = #role{action = Action}) ->
%%     case team_api:is_member(Role) of
%%         {true, _} -> {false, <<"队员不能操作">>};
%%         _ ->check_status(action, Action) 
%%     end;
check_status(action, ?action_sit) -> {false, ?L(<<"打坐状态不能操作">>)};
check_status(action, ?action_sit_both) -> {false, ?L(<<"双修状态不能操作">>)};
check_status(action, ?action_sit_brother) -> {false, ?L(<<"双修状态不能操作">>)};
check_status(action, ?action_sit_master) -> {false, ?L(<<"双修状态不能操作">>)};
check_status(action, ?action_sit_lovers) -> {false, ?L(<<"双修状态不能操作">>)};
check_status(_, _) -> true.


