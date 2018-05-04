%%----------------------------------------------------
%% 2014/7/17 将活跃度包装成日常任务
%% 
%%
%%
%%----------------------------------------------------
-module(activity2).
-export([
        get_info/1
        ,reward/2
        ,day_check/1
        ,push/2
        ,special_event/6
        ,acc_event/6
        ,kill_npc/6
        ,finish_task/6
        ,special_event/5
        ,acc_event/5
        ,kill_npc/5
        ,finish_task/5
        ,lev_up/1
        ,login/1
        ,online_timer_callback/1
        ,get_actions/1
        ,fire_tasks/1
        ,push_13803/2
%% gm
        ,reset/1
        ,add_a_task/2
    ]).

-include("common.hrl").
-include("role.hrl").
-include("task.hrl").
-include("activity2.hrl").
-include("dungeon.hrl").
-include("gain.hrl").
-include("trigger.hrl").
-include("link.hrl").

-define(activity2_total, 200).  %% 每天最多可获得总的活跃值
-define(activity2_rewarded, 2). %% 已领奖
-define(activity2_finish, 1).   %% 已完成
-define(activity2_process, 0).  %% 未领取
-define(activity2_min_lev, 18). %% 活跃度启动最低等级
-define(MAX_ACTIONS, 8).       %% 可领取的最多任务数

%% @spec login(Role) -> NewRole
%% Role = record(role)
%% @doc 活跃度登录处理
login(Role = #role{lev = Lev, activity2 = Act = #activity2{actions = Actions, last_active = LastActive, current = _Current}, trigger = Trigger = #trigger{special_event = _Spec}}) ->
    activity2_log:login(Role),
    Now = util:unixtime(),
    ?DEBUG("last_active ~w", [LastActive]),
    NR1 = case util:is_same_day2(Now, LastActive) of
        true ->
            {_NewActions, Trg2} = reg_trigger(Actions, [], Trigger),
            Role#role{trigger = Trg2};
        _ -> 
            Actions1 = get_actions(Lev, Role),
            {Actions2, Trigger2} = reg_trigger(Actions1, [], Trigger),
            Role#role{activity2 = Act#activity2{actions = Actions2, last_active = Now}, trigger = Trigger2}
    end,
    push(13804, NR1),
    Tomorrow = util:unixtime({today, Now}) + 86403 - Now,
    NR2 = role_timer:set_timer(activity2_day_check, Tomorrow * 1000, {activity2, day_check, []}, day_check, NR1),
    NR3 = set_online_timer(NR2),
    NR4 = npc_mail:login(NR3),
    NR4;

login(Role = #role{activity2 = _A}) ->
    ?DEBUG("没有新活跃度信息~w", [_A]),
    activity2_log:login(Role),
    Role#role{activity2 = #activity2{}}.

%% @spec day_check(Role) -> {ok, NewRole}
%% Role = NewRole = record(role)
%% @doc 隔天活跃度清零
day_check(Role = #role{lev = Lev, name = _Name, activity2 = #activity2{actions = _Actions, last_active = _LastActive}}) ->
    ?DEBUG("~s 隔天检查活跃度：~w", [_Name, _LastActive]),
    Now = util:unixtime(),
    Role1 = #role{trigger = Trigger1} = clear_trigger(Role),
    Actions1 = get_actions(Lev, Role1),
    {Actions2, Trigger2} = reg_trigger(Actions1, [], Trigger1),
    Role2 = Role1#role{trigger = Trigger2, activity2 = #activity2{actions = Actions2, current = 0, last_active = Now}},
    push(13804, Role2),
    Role3 = set_online_timer(Role2),
    {ok, Role3}.

%% @spec get_info(Role) -> {Current, Rewards}
%% Current = integer()
%% Rewards = list() = [{Id, ConditionNum, Status},..]
%% @doc 获取活跃度当前状态
get_info(#role{activity2 = #activity2{actions = Actions}}) ->
    Ret = [A || A = #activity2_event{status = Status} <- Actions, Status =/= ?activity2_rewarded],
    ?DEBUG("当前日常信息 ~w", [Ret]),
    {Ret};
get_info(_) ->
    {[]}.

%% @spec reward(Role, Id) -> {ok, NewRole} | {fail, Why}
%% Role = NewRole = record(role)
%% Id = integer() 奖励id
%% @doc 领取一个奖励
reward(Role = #role{activity2 = Act2 = #activity2{actions = Actions}}, Id) ->
    case lists:keyfind(Id, #activity2_event.id, Actions) of
        E = #activity2_event{status = ?activity2_finish} ->
            Actions1 = lists:keyreplace(Id, #activity2_event.id, Actions, E#activity2_event{status = ?activity2_rewarded}),
            Role1 = Role#role{activity2 = Act2#activity2{actions = Actions1}},           
            {_,_,_,_,Gains} = activity2_data:get(Id),
            Role2 = do_gains(Gains, Role1, 0),
            {ok, Role2};
        _ ->
            {fail, not_found}
    end.

%% @spec push(13804, Role) ->
%% Role = record(role)
%% @doc 推送13804协议
push(13804, Role = #role{pid = Pid}) ->
    Data = get_info(Role),
    role:pack_send(Pid, 13804, Data).

%% 注册触发器
reg_trigger([E = #activity2_event{status = St} | Rest], NewEvents, Trigger) when St =/= ?activity2_process ->
    reg_trigger(Rest, [E#activity2_event{trigger_id = 0} | NewEvents], Trigger);
%% 未完成的要加一下监听
reg_trigger([E = #activity2_event{id = Id, label = Label, type = EventId, target = TargetVal} | Rest], NewEvents, Trigger) ->
    case role_trigger:add(Label, Trigger, {?MODULE, Label, [Id, EventId, TargetVal]}) of 
        {ok, TriggerId, NewTrigger} ->
            reg_trigger(Rest, [E#activity2_event{trigger_id = TriggerId} | NewEvents], NewTrigger);
        _ ->
            reg_trigger(Rest, [E#activity2_event{trigger_id = 0} | NewEvents], Trigger)
    end;
reg_trigger(_, NewEvents, Trigger) ->
    {NewEvents, Trigger}.

%% 触发器回调
special_event(Role, {Key, _SpecArg}, _TriggerId, _AId, _EventId, _TargetVal) when Key =:= 1073 ->   %% 世界树转换
    special_event(Role, {3003, 1}, _TriggerId, _AId, _EventId, _TargetVal);

special_event(_Role, {Key, _SpecArg}, _TriggerId, _AId, EventId, _TargetVal) when Key =/= EventId ->
    ok;

%% 活跃度的触发器都统一采用以下方式更新
special_event(Role = #role{link = #link{conn_pid=ConnPid}, activity2 = Act = #activity2{actions = Actions}}, {_, SpecArg}, _TriggerId, AId, _EventId, _TargetVal) ->
    ?DEBUG("值是trigger: ~w event: ~w val: ~w, AID: ~w", [_TriggerId, _EventId, SpecArg, AId]),
    Now = util:unixtime(),
    case lists:keyfind(AId, #activity2_event.id, Actions) of
        E = #activity2_event{id = TaskId, target = TargetVal, current = CurrentVal, status = OldStatus} when OldStatus=:=?activity2_process ->
            activity2_log:log(Role, AId),

            SpecArg1 = case SpecArg of finish -> 1; _ -> SpecArg end,
            {ECurrent, EStatus} =
                 case CurrentVal + SpecArg1 >= TargetVal of
                    true when _EventId =:= 2001 ->
                        role_listener:guild_activity(Role, {}), %% 在线满一小时，满足军团在线一小时
                        {TargetVal, ?activity2_finish};
                    true  ->
                        {TargetVal, ?activity2_finish};
                    false ->
                        {CurrentVal+SpecArg1, ?activity2_process}
                end,
            ?DEBUG("TASK_ID  ~w, Current ~w, Status ~w", [TaskId, ECurrent, EStatus]),
            Actions1 = lists:keyreplace(AId, #activity2_event.id, Actions, E#activity2_event{current = ECurrent, status = EStatus}),
            Role1 = Role#role{activity2 = Act#activity2{last_active = Now, actions = Actions1}},
            sys_conn:pack_send(ConnPid, 13806, {TaskId, ECurrent, EStatus}),
            {ok, Role1};
        _ ->
            ok
    end.

%% 叠加事件处理接口，这里采用和special_event一样的处理方式
acc_event(Role, EventVal, TriggerId, AId, EventId, TargetVal) ->
    special_event(Role, EventVal, TriggerId, AId, EventId, TargetVal).
%% 击杀npc事件处理接口，这里采用和special_event一样的处理方式
kill_npc(Role, EventVal, TriggerId, AId, EventId, TargetVal) ->
    special_event(Role, EventVal, TriggerId, AId, EventId, TargetVal).
%% 完成任务事件处理接口，这里采用和special_event一样的处理方式
%% 师门任务特殊处理
finish_task(Role, 41110, TriggerId, AId, 41110, TargetVal) ->
    special_event(Role, {41110, 1}, TriggerId, AId, 41110, TargetVal);
%% 帮派任务特殊处理
finish_task(Role, 60010, TriggerId, AId, 60010, TargetVal) ->
    special_event(Role, {60010, 1}, TriggerId, AId, 60010, TargetVal);
finish_task(Role, TaskId, TriggerId, AId, 60010, TargetVal) ->
    Tasks = task_data_ring:get_ring_tail(?task_type_bh),
    case lists:member(TaskId, Tasks) of
        true ->
            finish_task(Role, 60010, TriggerId, AId, 60010, TargetVal);
        _ ->
            ok
    end;
finish_task(Role, TaskId, TriggerId, AId, EventId, TargetVal) ->
    special_event(Role, {TaskId, 1}, TriggerId, AId, EventId, TargetVal).
%% 等级提升事件
lev_up(Role = #role{}) ->
    {Role1, TaskIds} = levup_fire(Role),
    ?DEBUG("新增加任务  ~w", [TaskIds]),
    push_13803(Role1, TaskIds),
    Role1.


%% 几个容错处理
acc_event(_Role, _EventVal, _TriggerId, _AId, _EventId) ->
    ok.
finish_task(_Role, _TaskId, _TriggerId, _AId, _EventId) ->
    ok.
kill_npc(_Role, _EventVal, _TriggerId, _AId, _EventId) ->
    ok.
special_event(_Role = #role{name = _Name}, {Key, _SpecArg}, _TriggerId, _AId, EventId) when Key =/= EventId ->
    ok;
special_event(Role = #role{name = _Name, trigger = Trigger}, _EventVal, TriggerId, _AId, _EventId) ->
    ?ERR("角色[~s]残留着旧监听 [~w, ~w]", [_Name, _AId, _EventId]),
    NewTrigger = case role_trigger:del(special_event, Trigger, TriggerId) of
        {ok, NewTrig} -> 
            NewTrig;
        _ -> 
            Trigger
    end,
    {ok, Role#role{trigger = NewTrigger}}.

%% 清理所有special_event监听触发器
clear_trigger(Role = #role{trigger = Trigger, activity2 = #activity2{actions = Actions}}) ->
    Trigger1 = do_clear_trigger(Actions, Trigger),
    Role#role{trigger = Trigger1}.
do_clear_trigger([], Trigger) -> Trigger;
do_clear_trigger([#activity2_event{trigger_id = TriggerId} | T], Trigger) ->
    Trigger1 = case role_trigger:del(special_event, Trigger, TriggerId) of
        {ok, NewTrig} -> 
            NewTrig;
        _ -> 
            Trigger
    end,
    do_clear_trigger(T, Trigger1).


%% L -> [{labe, Val}]
%% do_gains -> NewRole
do_gains([], Role, Len) ->
    case Len > 0 of
        true ->
            notice:alert(succ, Role, ?MSGID(<<"背包已满，奖励发送到奖励大厅">>));
        false ->
            skip
    end,
    Role;
do_gains([{Label, V} | T], Role = #role{id = Rid}, Len) ->
    case role_gain:do(G = [#gain{label = Label, val = V}], Role) of
        {false, _R} ->
            award:send(Rid, 301002, G),
            do_gains(T, Role, Len+1);
        {ok, Role1} ->
            do_gains(T, Role1, Len)
    end.

set_online_timer(Role = #role{activity2 = #activity2{current = _Current, actions = Actions}}) ->
    Role2 = 
    case role_timer:del_timer(activity2_online_timer, Role) of
        {ok, {_,_}, Role1} -> Role1;
        false -> Role
    end,
    case lists:keyfind(2001, #activity2_event.type, Actions) of
        #activity2_event{status = ?activity2_process } ->
            role_timer:set_timer(activity2_online_timer, 60000, {?MODULE, online_timer_callback, []}, 1, Role2);
        #activity2_event{} ->
            Role2;
        false ->
            Role2
    end.

online_timer_callback(Role = #role{}) ->
    Role1 = role_listener:special_event(Role, {2001, 1}),
    {ok, set_online_timer(Role1)}.

get_actions(Lev, Role) ->
    All = [activity2_data:get(ActId) || ActId <- activity2_data:all()],
    Filted = [A || A = {Id, _Targe, _Order, NeedLev, _Gain} <- All, Lev >= NeedLev, check_can_accept(Role, Id)],
    SortFun = fun({_, _, Order1, _, _}, {_, _, Order2, _, _}) -> Order1 < Order2 end,
    Filted1 = lists:sort(SortFun, Filted),
    to_events(Filted1, []).

check_can_accept(Role, ActionId) ->
    {TaskId, Flag} = activity2_data:get_accept_cond(ActionId),
    case Flag of
        0 ->
            case task:is_zhux_finish(TaskId) of
                true ->
                    true;
                false ->
                    task:is_accepted(Role, TaskId)
            end;
        1 ->
            task:is_zhux_finish(TaskId)
    end.

%% [{_Id, _Target, _Order, _NeedLev, _Gain} | T]
to_events([], Actions) -> Actions;
to_events([{Id, Target, _, _, _} | T], Actions) ->    
    to_events(T, [#activity2_event{id=Id, label=special_event, type=Id, target=Target, status = ?activity2_process} | Actions]).

levup_fire(Role = #role{lev = Lev, trigger = Trigger, activity2 = Act = #activity2{actions = ActionsOld}}) ->
    Actions = get_actions(Lev, Role),
    Ids = [Id || #activity2_event{id=Id} <- Actions],
    HasIds = [Id1 || #activity2_event{id=Id1} <- ActionsOld],
    CanGetIds = Ids -- HasIds,
    Events = to_events([activity2_data:get(AID) || AID <- CanGetIds], []),
    {Actions2, Trigger1} = reg_trigger(Events, [], Trigger),
    {Role#role{trigger = Trigger1, activity2 = Act#activity2{actions = ActionsOld++Actions2}}, CanGetIds}.

%% 触发日常任务
fire_tasks(Role = #role{trigger = Trigger, activity2 = Act2 = #activity2{actions = Actions}}) ->
%%    Act1 = [A || A = #activity2_event{status = Status} <- Actions, Status =/= ?activity2_rewarded],
    case get_actions(Role) of
        [] ->
            ?DEBUG("没有触到日常任务"),
            {Role, []};
        Actions1 ->
            {Actions2, Trigger1} = reg_trigger(Actions1, [], Trigger),
            TaskIds = [TaskId || #activity2_event{id = TaskId, target = _Target, current = _Current} <- Actions2],
            ?DEBUG("新加日常任务 ~w", [TaskIds]),
            {Role#role{trigger = Trigger1, activity2 = Act2#activity2{actions = Actions++Actions2}}, TaskIds}
    end.

get_actions(Role = #role{lev = Lev, activity2 = #activity2{actions = Actions}}) ->
    MyActions = [Id || #activity2_event{id = Id} <- Actions],
    Filted = activity2_data:all() -- MyActions,
    Conf = [activity2_data:get(Id) || Id <- Filted],
    Filted1 = [A || A = {Id1, _Targe, _Order, NeedLev, _Gain} <- Conf, Lev >= NeedLev, check_can_accept(Role, Id1)],
    SortFun = fun({_, _, Order1, _, _}, {_, _, Order2, _, _}) -> Order1 < Order2 end,
    Filted2 = lists:sort(SortFun, Filted1),
    to_events(Filted2, []).

%% Ids -> [ID | ...]
push_13803(#role{link = #link{conn_pid = ConnPid}}, Ids) ->
    sys_conn:pack_send(ConnPid, 13803, {Ids}).

%% ------------------------- gm  ---------------------------
reset(Role = #role{lev = Lev, activity2 = #activity2{actions = _Actions}}) ->
    Now = util:unixtime(),
    Role1 = #role{trigger = Trigger} = clear_trigger(Role),
    Actions1 = get_actions(Lev, Role),
    {Actions2, Trigger1} = reg_trigger(Actions1, [], Trigger),
    Role2 = Role1#role{trigger = Trigger1, activity2 = #activity2{actions = Actions2, last_active = Now}},
    push(13804, Role2),
    Role2.

add_a_task(TaskId, Role = #role{trigger = Trigger, activity2 = Act2 = #activity2{actions = Actions}}) ->
     case activity2_data:get(TaskId) of
         false ->
             ?DEBUG(" 没有此任务喔 "),
             {ok};
         C = {_TaskId, _Target, _, _, _} ->
             Actions1 = to_events([C], []),
             {Actions2, Trigger1} = reg_trigger(Actions1, [], Trigger),
             {ok, Role#role{trigger = Trigger1, activity2 = Act2#activity2{ actions = Actions ++ Actions2}}}
    end.

%% 配置版本修正
%do_version([], NewData, _) ->
%    NewData;
%do_version([#activity2_event{id = Id, current = CVal, type = Type, label = Label} | T], NewData, Bases) ->
    %% 重新检查完成条件，如果条件已满足则标识下
%    case lists:keyfind(Id, #activity2_event.id, Bases) of
%        E = #activity2_event{target = TargetVal, type = Type, label = Label} when CVal >= TargetVal ->
%            do_version(T, [E#activity2_event{current = TargetVal, status = ?activity2_finish} | NewData], Bases);
%        E = #activity2_event{id = Id, type = Type, label = Label} ->
%            do_version(T, [E#activity2_event{current = CVal} | NewData], Bases);
%        _ ->
%            do_version(T, NewData, Bases)
%    end;
%do_version([_ | T], NewData, Bases) ->
%    do_version(T, NewData, Bases).
