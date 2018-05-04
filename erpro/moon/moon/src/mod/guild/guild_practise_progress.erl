%%----------------------------------------------------
%% 成就系统条件进度转换 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(guild_practise_progress).
-export([
        acc_event/4
        ,special_event/4
        ,kill_elite_npc/4
        ,finish_task_type/4
        ,kill_npc/4
        ,buy_item_shop/4
        ,convert/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("condition.hrl").
-include("guild_practise.hrl").
-include("task.hrl").
-include("guild.hrl").
-include("item.hrl").
-include("npc.hrl").

%% @spec buy_item_shop(Role, Item, TriggerId, AId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% Item = #item{} 物品记录
%% </pre>
buy_item_shop(_Role, _Item = #item{base_id = BaseId}, _TriggerId, Target) when BaseId =/= Target andalso Target =/= 0 ->
    ok;
buy_item_shop(Role, Item, TriggerId, _Target) ->
    update_progress(Role, TriggerId, Item).

%% @spec kill_npc(Role, {NpcBaseId, Num}, TriggerId, AId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% <pre>
%% 杀死指定NPC Num次
%% NpcBaseId = integer() Npc Base Id
%% Num = integer() 斩杀数量
%% </pre>
kill_npc(_Role, {124003, _}, _TriggerId, _Target) -> %% 捉宠
    ok;
kill_npc(_Role, {NpcBaseId, _Num}, _TriggerId, Target) when NpcBaseId =/= Target andalso Target =/= 0 ->
    ok;
kill_npc(Role, {NpcBaseId, Num}, TriggerId, _Target) ->
    update_progress(Role, TriggerId, {NpcBaseId, Num}).

%% 完成某种类型任务
finish_task_type(Role, TaskId, TriggerId, Target) ->
    case task_data:get(TaskId) of
        {ok, Task = #task_base{type = Target}} ->
            update_progress(Role, TriggerId, Task);
        _ ->
            ok
    end.

%% 杀死狂暴怪
kill_elite_npc(Role, {NpcBaseId, Num}, TriggerId, _Target) ->
   case npc_data:get(NpcBaseId) of
        {ok, #npc_base{fun_type = ?npc_fun_type_frenzy}} -> 
            update_progress(Role, TriggerId, {NpcBaseId, Num});
        _ ->
            ok
    end.

%% 完成特殊任务
special_event(_Role, {Key, _SpecArg}, _TriggerId, Target) when Key =/= Target ->
    ok;
special_event(Role, {Key, SpecArg}, TriggerId, _Target) ->
    update_progress(Role, TriggerId, {Key, SpecArg}).

%% 完成累计类事件
acc_event(_Role, {Key, _Args}, _TriggerId, Target) when Key =/= Target ->
    ok;
acc_event(_Role, {Key, 0}, _TriggerId, Target) when Key =/= Target ->
    ok;
acc_event(Role, {Key, Args}, TriggerId, _Target) ->
    update_progress(Role, TriggerId, {Key, Args}).

%%-----------------------------------------
%% 条件转换成进度
%%-----------------------------------------

%% 判断某类型任务已做次数
convert(Cond = #condition{label = finish_task_type, target = 4, target_value = TargetVal}, _Role) ->
    Num = case role:get_dict(task_finish_sm) of 
        {ok, L} when is_list(L) -> length(L);
        _ -> 0
    end,
    {Status, Val} = status(Num, TargetVal),
    convert(Cond, Status, Val);
convert(Cond = #condition{label = finish_task_type, target = 5, target_value = TargetVal}, _Role) ->
    Num = case role:get_dict(task_finish_bh) of 
        {ok, L} when is_list(L) -> length(L);
        _ -> 0
    end,
    {Status, Val} = status(Num, TargetVal),
    convert(Cond, Status, Val);
convert(Cond = #condition{label = finish_task_type, target = Target, target_value = TargetVal}, _Role) ->
    Num = case role:get_dict(task_finish_rc) of 
        {ok, L} when is_list(L) ->
            length([Task || Task <- L, Task#task_finish.type =:= Target]);
        _ -> 0
    end,
    {Status, Val} = status(Num, TargetVal),
    convert(Cond, Status, Val);

%% 判断当天护送美女次数
convert(Cond = #condition{label = acc_event, target = 104, target_value = TargetVal}, _Role) ->
    Num = case role:get_dict(task_finish_rc) of 
        {ok, L} when is_list(L) ->
            length([Task || Task <- L, Task#task_finish.type =:= 7 andalso Task#task_finish.sec_type =:= 1]);
        _ -> 0
    end,
    {Status, Val} = status(Num, TargetVal),
    convert(Cond, Status, Val);

%% 点位函数
convert(Cond = #condition{}, _Role) ->
    convert(Cond, 0, 0);

%% 多个条件转换
convert(Conds, Role) -> 
    do_convert(1, Conds, Role, []).
do_convert(_No, [], _Role, L) -> L;
do_convert(No, [Cond | T], Role, L) ->
    Prog = convert(Cond, Role), 
    do_convert(No + 1, T, Role, [Prog#guild_practise_progress{code = No} | L]).

%%----------------------------------------------------
%% 内部方法
%%----------------------------------------------------

%% 特殊条件转换
convert(#condition{label = Label, target = Target, target_ext = TargetExt, target_value = TargetVal}, Status, Val) ->
    #guild_practise_progress{
        trg_label = cond_trg_mapping(Label)
        ,cond_label = Label
        ,target = Target
        ,target_ext = TargetExt
        ,value = Val
        ,target_value = TargetVal
        ,status = Status
    }.

%% 根据当前值与目标值作状态判断
status(Value, TargetVal) ->
    case Value >= TargetVal of
        true -> {1, TargetVal};
        false -> {0, Value}
    end.

%% 返回两个值中较少的
min_value(V1, V2) ->
    case V1 > V2 of
        true -> V2;
        false -> V1
    end.

%% 条件标签与触发器标签对应关系
cond_trg_mapping(get_item) -> get_item;
cond_trg_mapping(use_item) -> use_item;
cond_trg_mapping(kill_npc) -> kill_npc;
cond_trg_mapping(kill_boss) -> kill_npc;
cond_trg_mapping(world_boss) -> kill_npc;
cond_trg_mapping(kill_elite_npc) -> kill_npc;
cond_trg_mapping(vip) -> vip;
cond_trg_mapping(get_task) -> get_task;
cond_trg_mapping(finish_task) -> finish_task;
cond_trg_mapping(finish_task_type) -> finish_task;
cond_trg_mapping(coin) -> coin;
cond_trg_mapping(get_coin) -> coin;
cond_trg_mapping(lev) -> lev;
cond_trg_mapping(buy_item_store) -> buy_item_store;
cond_trg_mapping(buy_item_shop) -> buy_item_shop;
cond_trg_mapping(special_event) -> special_event;
cond_trg_mapping(make_friend) -> make_friend;
cond_trg_mapping(has_friend) -> make_friend;
cond_trg_mapping(acc_event) -> acc_event;
cond_trg_mapping(eqm_event) -> eqm_event;
cond_trg_mapping(_Label) -> false. 

%%-------------------------------------------
%% 任务进度更新
%%-------------------------------------------

%% 更新进度信息
update_progress(Role = #role{id = Rid, trigger = Trigger, guild_practise = GuildPra = #guild_practise{status = ?guild_practise_status_doing, progress = Progs}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}, TriggerId, Arg) ->
    case do_update(Role, Progs, Trigger, TriggerId, Arg, [], false) of
        {_, _NProgs, _NTrigger, false} -> %% 进度未变化
            ok;
        {false, NProgs, NTrigger, true} -> %% 进度有变化，未全部完成
            NewRole = Role#role{trigger = NTrigger, guild_practise = GuildPra#guild_practise{progress = NProgs}},
            guild_practise:push_progress(NewRole),
            {ok, NewRole};
        {true, NProgs, NTrigger, _} -> %% 全部进度完成
            NewStatus = ?guild_practise_status_finish,
            NewRole = Role#role{trigger = NTrigger, guild_practise = GuildPra#guild_practise{status = NewStatus, progress = NProgs}},
            guild_practise_mgr:apply(async, {update_status, {Gid, Gsrvid}, Rid, NewStatus}),
            guild_practise:push_progress(NewRole),
            {ok, NewRole}
    end;
update_progress(_Role, _TriggerId, _Arg) -> ok.

%% 执行更新
do_update(_Role, [], Trigger, _Tid, _Arg, Progs, Bool) -> %% 检测完成
    PL = [P || P <- Progs, P#guild_practise_progress.status =:= 0],
    {length(PL) =:= 0, Progs, Trigger, Bool};
do_update(Role, [P = #guild_practise_progress{status = 1} | T], Trigger, Tid, Arg, Progs, Bool) -> %% 已完成
    do_update(Role, T, Trigger, Tid, Arg, [P | Progs], Bool);
do_update(Role, [P = #guild_practise_progress{id = Tid, trg_label = Label, value = OldVal, target_value = TargetVal} | T], Trigger, Tid, Arg, Progs, Bool) -> %% 当前触发进度
    NewVal = upd(Role, P, Arg),
    case NewVal >= TargetVal of
        false when NewVal =< OldVal -> %% 进度未完成 新值比原值小 结果不变
            do_update(Role, T, Trigger, Tid, Arg, [P | Progs], Bool);
        false -> %% 进度未完成
            do_update(Role, T, Trigger, Tid, Arg, [P#guild_practise_progress{value = NewVal} | Progs], NewVal =/= OldVal);
        true -> %% 完成进度
            NP = P#guild_practise_progress{value = TargetVal, status = 1},
            case role_trigger:del(Label, Trigger, Tid) of
                {ok, NewTrigger} -> %% 进度完成 删除触发器成功
                    ?DEBUG("删除触发器Label:~w TriggerId:~w", [Label, Tid]),
                    do_update(Role, T, NewTrigger, Tid, Arg, [NP | Progs], true);
                _ ->
                    ?DEBUG("删除触发器失败Label:~w TriggerId:~w", [Label, Tid]),
                    do_update(Role, T, Trigger, Tid, Arg, [NP | Progs], true)
            end
    end;
do_update(Role, [P | T], Trigger, Tid, Arg, Progs, Bool) ->
    do_update(Role, T, Trigger, Tid, Arg, [P | Progs], Bool).

%% 到商城买一个物品
upd(_Role, #guild_practise_progress{cond_label = buy_item_shop, value = Value, target_value = TargetVal}, _Item = #item{quantity = Quantity}) ->
    min_value(Value + Quantity, TargetVal);

%% <pre>
%% 要求杀死指定的NPC N次
%% Npc = #npc{} 被杀NPC
%% Num = integer() 被杀NPC数量
%% NewVal = integer() 新已杀NPC数量
%% </pre>
upd(_Role, #guild_practise_progress{cond_label = kill_npc, target_ext = TargetExt, value = Value, target_value = TargetVal}, {NpcBaseId, Num}) when is_list(TargetExt) ->
    case lists:member(NpcBaseId, TargetExt) of
        true -> min_value(Value + Num, TargetVal);
        false -> Value 
    end;

upd(_Role, #guild_practise_progress{cond_label = kill_npc, value = Value, target_value = TargetVal}, {_NpcBaseId, Num}) ->
    min_value(Value + Num, TargetVal);

%% 杀狂暴数量
upd(_Role, #guild_practise_progress{cond_label = kill_elite_npc, value = Value, target_value = TargetVal}, {_NpcBaseId, Num}) ->
    min_value(Value + Num, TargetVal);

%% 完成某种类型任务
upd(_Role, #guild_practise_progress{cond_label = finish_task_type, value = Value, target_ext = TargetExt, target_value = TargetVal}, #task_base{sec_type = SecType}) when is_list(TargetExt) ->
    case lists:member(SecType, TargetExt) of
        true -> min_value(Value + 1, TargetVal);
        false -> Value 
    end;
upd(_Role, #guild_practise_progress{cond_label = finish_task_type, value = Value, target_value = TargetVal}, _Task) ->
    min_value(Value + 1, TargetVal);

%% 完成一个特殊任务
%% Arg = {Key, SpecArg}
upd(_Role, #guild_practise_progress{cond_label = special_event, target_ext = TargetExt, target_value = TargetVal}, {_Key, SpecArg}) when is_integer(TargetExt) andalso TargetExt > 0 ->
    if
        SpecArg =:= finish -> TargetVal;
        is_integer(SpecArg) andalso TargetExt =< SpecArg -> TargetVal;
        is_integer(SpecArg) -> SpecArg;
        true -> 0
    end;
upd(_Role, #guild_practise_progress{cond_label = special_event, target_value = TargetVal}, {_Key, SpecArg}) ->
    if
        SpecArg =:= finish -> TargetVal;
        is_integer(SpecArg) andalso TargetVal =< SpecArg -> TargetVal;
        is_integer(SpecArg) -> SpecArg;
        true -> 0
    end;

%% 完成一个特殊累加任务
%% Arg = {Key, SpecArg}
upd(_Role, #guild_practise_progress{cond_label = acc_event, value = Value, target_value = TargetVal}, {_Key, {N, _}}) when is_integer(N) ->
    %% ?DEBUG("~s--------~p", [_Role#role.name, N]),
    min_value(Value + N, TargetVal);
upd(_Role, #guild_practise_progress{cond_label = acc_event, value = Value, target_value = TargetVal}, {_Key, N}) when is_integer(N) ->
    %% ?DEBUG("~s--------~p", [_Role#role.name, N]),
    min_value(Value + N, TargetVal);
upd(_Role, #guild_practise_progress{cond_label = acc_event, value = Value, target_value = TargetVal}, {_Key, _Args}) ->
    min_value(Value + 1, TargetVal);

%% 容错函数
upd(_Role, Prg = #guild_practise_progress{value = Value}, Arg) -> 
    ?ERR("没有匹配的upd函数Prg:~w, Arg:~w", [Prg, Arg]),
    Value.
