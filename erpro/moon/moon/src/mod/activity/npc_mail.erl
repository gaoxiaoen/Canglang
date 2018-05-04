
%% 远方的来信
%% NPC_MAIL
-module(npc_mail).

-export([
        login/1
        ,reward/2
        ,push/2
        ,push/1
        ,sweep_dungeon/6
        ,special_event/6
        ,kill_npc/6
        ,finish_task/6
        ,do_gains/3
    ]).

-include("common.hrl").
-include("role.hrl").
-include("task.hrl").
-include("dungeon.hrl").
-include("gain.hrl").
-include("trigger.hrl").
-include("npc_mail.hrl").

login(Role = #role{npc_mail = []}) ->
    Role;
login(Role = #role{npc_mail = NpcMail, trigger = Trigger = #trigger{}}) ->
    push(Role, [Id || #npc_mail{id = Id, status = 1} <- NpcMail]),
    {_NewActions, Trg1} = reg_trigger(NpcMail, [], Trigger),
    Role#role{trigger = Trg1}.

%% @spec reward(Role, Id) -> {ok, NewRole} | {fail, Why}
%% Role = NewRole = record(role)
%% Id = integer() 奖励id
%% @doc 领取一个奖励
reward(Id, Role = #role{npc_mail = NpcMail}) ->
    case lists:keyfind(Id, #npc_mail.id, NpcMail) of
        #npc_mail{status = 0} ->
            {fail, not_enough};
        #npc_mail{} ->
            %% TODO:发放奖励
            [{Label, V}] = npc_mail_data:get_gain(Id),
            G = [#gain{label = Label, val = V}],
            {ok, Role1} = role_gain:do(G, Role),
            NpcMail1 = lists:keydelete(Id, #npc_mail.id, NpcMail),
            {ok, Role1#role{npc_mail = NpcMail1}};
        _ ->
            {fail, not_found}
    end.

push(Role = #role{npc_mail = NpcMail}) ->
    push(Role, [Id || #npc_mail{id = Id, status = 1} <- NpcMail]).

push(#role{pid = Pid}, EventIdList) when is_list(EventIdList) ->
    role:pack_send(Pid, 13807, {EventIdList});
push(#role{pid = Pid}, EventId) ->
    role:pack_send(Pid, 13807, {[EventId]}).

%% 注册触发器
%% 未完成的要加一下监听
reg_trigger([#npc_mail{status = 1} | Rest], NewEvents, Trigger) ->
    reg_trigger(Rest, NewEvents, Trigger);
reg_trigger([E = #npc_mail{id = Id, label = Label, type = EventId, target = TargetVal, status = 0} | Rest], NewEvents, Trigger) ->
    case role_trigger:add(Label, Trigger, {?MODULE, Label, [Id, EventId, TargetVal]}) of 
        {ok, TriggerId, NewTrigger} ->
            reg_trigger(Rest, [E#npc_mail{trigger_id = TriggerId} | NewEvents], NewTrigger);
        _ ->
            reg_trigger(Rest, [E#npc_mail{trigger_id = 0} | NewEvents], Trigger)
    end;
reg_trigger(_, NewEvents, Trigger) ->
    {NewEvents, Trigger}.

%% 触发器回调
sweep_dungeon(Role, {DungeonId, Num}, _TriggerId, _AId, _EventId, _TargetVal) ->
    special_event(Role, {DungeonId, Num}, _TriggerId, _AId, _EventId, _TargetVal);
sweep_dungeon(_Role, _Param, _TriggerId, _AId, _EventId, _TargetVal) ->
    ok.

special_event(Role, {1061, EventId}, _TriggerId, _AId, EventId, _TargetVal) -> %% 学习了某个技能
    ?DEBUG("  触发技能   EventId ~w", [EventId]),
    special_event(Role, {EventId, 1}, _TriggerId, _AId, EventId, _TargetVal);

special_event(Role, {1062, EventId}, _TriggerId, _AId, EventId, _TargetVal) -> %% 获得了某个勋章
    ?DEBUG("  获得勋章  "),
    special_event(Role, {EventId, 1}, _TriggerId, _AId, EventId, _TargetVal);

special_event(Role, {1070, EventId}, _TriggerId, _AId, EventId, _TargetVal) -> %% 套装触发
    ?DEBUG("  触发套装  "),
    special_event(Role, {EventId, 1}, _TriggerId, _AId, EventId, _TargetVal);

special_event(Role, {1071, EventId}, _TriggerId, _AId, EventId, _TargetVal) ->
    ?DEBUG("  触发宠物技能   EventId: ~w", [EventId]),
    special_event(Role, {EventId, 1}, _TriggerId, _AId, EventId, _TargetVal);

special_event(Role, {1074, EventId}, _TriggerId, _AId, EventId, _TargetVal) ->
    ?DEBUG("  加入军团  "),
    special_event(Role, {0, 1}, _TriggerId, _AId, EventId, _TargetVal);

special_event(Role, {1075, EventId}, _TriggerId, _AId, EventId, _TargetVal) -> %% 获得拳王
    ?DEBUG("  获得拳王  "),
    special_event(Role, {EventId, 1}, _TriggerId, _AId, EventId, _TargetVal);

special_event(Role, {1076, EventId}, _TriggerId, _AId, EventId, _TargetVal) -> %% 通关试炼场
    ?DEBUG("  通关试炼场  "),
    special_event(Role, {EventId, 1}, _TriggerId, _AId, EventId, _TargetVal);

special_event(_Role, {Key, _SpecArg}, _TriggerId, _AId, EventId, _TargetVal) when Key =/= EventId ->
 %%   ?DEBUG("  不是远方来信的触发事件 key : ~w  EventId : ~w", [Key, EventId]),
    ok;

%% 活跃度的触发器都统一采用以下方式更新
special_event(Role = #role{npc_mail = NpcMail}, {_, SpecArg}, _TriggerId, AId, _EventId, _TargetVal) ->
    ?DEBUG("值是trigger: ~w event: ~w val: ~w", [_TriggerId, _EventId, SpecArg]),
    case lists:keyfind(AId, #npc_mail.id, NpcMail) of
        #npc_mail{status = 1} ->
             ok;
        E = #npc_mail{target = TargetVal, current = CurrentVal, id = Id} ->
                case CurrentVal + SpecArg >= TargetVal of
                    true ->
                        ?DEBUG("  《〈〈〈〈完成一个事件  "),
                        push(Role, Id),
                        NpcMail1 = lists:keyreplace(AId, #npc_mail.id, NpcMail, E#npc_mail{current = CurrentVal + SpecArg, status = 1}),
                        {ok, Role#role{npc_mail = NpcMail1}};
                    false ->
                        ?DEBUG("  更新事件   "),
                        NpcMail1 = lists:keyreplace(AId, #npc_mail.id, NpcMail, E#npc_mail{current = CurrentVal + SpecArg}),
                        {ok, Role#role{npc_mail = NpcMail1}}
                end;
        _ ->
            ok
    end.

%% 击杀npc事件处理接口，这里采用和special_event一样的处理方式
kill_npc(Role, {NpcBaseId, Num}, TriggerId, AId, NpcBaseId, TargetVal) ->
    ?DEBUG(" KILL NPC "),
    special_event(Role, {NpcBaseId, Num}, TriggerId, AId, NpcBaseId, TargetVal);
kill_npc(_Role, _EventVal, _TriggerId, _AId, _EventId, _TargetVal) ->
    ok.

finish_task(Role, TaskId, TriggerId, AId, TaskId, TargetVal) ->
    ?DEBUG(" FINISH TASK "),
    special_event(Role, {TaskId, 1}, TriggerId, AId, TaskId, TargetVal);
finish_task(_Role, _TaskId, _TriggerId, _AId, _EventId, _TargetVal) ->
    ok.

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

