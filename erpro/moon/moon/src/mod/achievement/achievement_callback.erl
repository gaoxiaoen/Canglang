%%----------------------------------------------------
%% 成就系统触发器回调模块  
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(achievement_callback).
-export([
        coin/5
        ,get_coin/5
        ,get_item/5
        ,use_item/5
        ,vip/5
        ,kill_npc/5
        ,kill_boss/5
        ,world_boss/5
        ,get_task/5
        ,finish_task/5
        ,finish_task_type/5
        ,finish_task_kind/5
        ,lev/5
        ,buy_item_shop/5
        ,special_event/5
        ,buy_item_store/5
        ,make_friend/5
        ,has_friend/5
        ,acc_event/5
        ,eqm_event/5
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("achievement.hrl").
-include("assets.hrl").
-include("sns.hrl").
-include("item.hrl").
-include("npc.hrl").
-include("task.hrl").

%% @spec con(Role, Coin, TriggerId, AId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% 要求金币大于或等于指定值
%% Coin = integer() 涉及金币数
%% </pre>target = ".str_replace(".", ",", trim($arr_cond[1])).",
coin(Role = #role{assets = #assets{coin = ACoin, coin_bind = BCoin}}, _Coin, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, ACoin + BCoin).

%% @spec get_coin(Role, Coin, TriggerId, AId, _Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% 要求得到金币大于或等于指定值
%% Coin = integer() 涉及金币数
%% </pre>
get_coin(_Role, Coin, _TriggerId, _AId, _Target) when Coin =< 0 ->
    ok;
get_coin(Role, Coin, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, Coin).

%% @spec get_item(Role, Item, TriggerId, AId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% 当得到物品时，更新任务进度 
%% Item = #item{} 得到的物品
%% </pre>
get_item(_Role, #item{base_id = BaseId}, _TriggerId, _AId, Target) when BaseId =/= Target andalso Target =/= 0 ->
    ok; %% 非关注的物品，不作任何处理
get_item(Role, Item, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, Item).

%% @spec use_item(Role, Item, TriggerId, AId, Target) -> ok | {ok, NewRole} 
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% 当得到物品时，更新任务进度 
%% Item = #item{} 得到的物品
%% </pre>
use_item(_Role, #item{base_id = BaseId}, _TriggerId, _AId, Target) when BaseId =/= Target andalso Target =/= 0 ->
    ok; %% 非关注的物品，不作任何处理
use_item(Role, Item, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, Item).

%% @spec vip(Role, Vip, TriggerId, AId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% 当得到物品时，更新任务进度 
%% Vip = #vip{} 角色vip属性
%% </pre>
vip(Role, Vip, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, Vip).

%% @spec kill_npc(Role, {NpcBaseId, Num}, TriggerId, AId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% <pre>
%% 杀死指定NPC Num次
%% NpcBaseId = integer() Npc Base Id
%% Num = integer() 斩杀数量
%% </pre>
kill_npc(_Role, {124003, _}, _TriggerId, _AId, _Target) -> %% 捉宠
    ok;
kill_npc(_Role, {NpcBaseId, _Num}, _TriggerId, _AId, Target) when NpcBaseId =/= Target andalso Target =/= 0 ->
    ok;
kill_npc(Role, {NpcBaseId, Num}, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, {NpcBaseId, Num}).

%% 杀死BOSS
kill_boss(Role, {NpcBaseId, Num}, TriggerId, AId, _Target) ->
    case npc_data:get(NpcBaseId) of
        {ok, #npc_base{looks_type = Type}} when Type =:= 5 orelse Type =:= 6 -> 
            update_progress(Role, TriggerId, AId, {NpcBaseId, Num});
        _ ->
            ok
    end.

%% 杀死世界BOSS
world_boss(Role, {NpcBaseId, Num}, TriggerId, AId, _Target) ->
    BossL = boss_data:get(all),
    case lists:member(NpcBaseId, BossL) of
        false -> ok;
        true -> update_progress(Role, TriggerId, AId, {NpcBaseId, Num})
    end.

%% @spec get_task(Role, GetTaskId, TriggerId, AId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% <pre>
%% GetTaskId = integer() 接受任务的Id
%% 要求已接下指定的任务 target = 0 target_value = 任务ID
%% </pre>
get_task(Role, GetTaskId, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, GetTaskId).

%% @spec finish_task(Role, TaskId, TriggerId, AId, Target) -> ok | {ok, NewRole} 
%% @equiv callback_fun/5
%% <pre>
%% AId = integer() 完成任务的Id
%% 完成任务触发器
%% </prie>
finish_task(_Role, TaskId, _TriggerId, _AId, Target) when TaskId =/= Target andalso Target =/= 0 ->
    ok;
finish_task(Role, TaskId, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, TaskId).

%% 完成某种类型任务
finish_task_type(Role, TaskId, TriggerId, AId, Target) ->
    case task_data:get_conf(TaskId) of
        {ok, Task = #task_base{type = Target}} ->
            update_progress(Role, TriggerId, AId, Task);
        _ ->
            ok
    end.

%% 完成某种类型任务
finish_task_kind(Role, TaskId, TriggerId, AId, Target) ->
    case task_data:get_conf(TaskId) of
        {ok, Task = #task_base{kind = Target}} ->
            update_progress(Role, TriggerId, AId, Task);
        _ ->
            ok
    end.

%% @spec lev(Role, Lev, TriggerId, AId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% <pre>
%% Lev = integer() 当前角色等级
%% 要求等级大于或等于指定值
%% </pre>
lev(Role, Lev, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, Lev).

%% @spec buy_item_shop(Role, Item, TriggerId, AId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% Item = #item{} 物品记录
%% </pre>
buy_item_shop(_Role, _Item = #item{base_id = BaseId}, _TriggerId, _AId, Target) when BaseId =/= Target andalso Target =/= 0 ->
    ok;
buy_item_shop(Role, Item, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, Item).
 
%% 完成特殊任务
special_event(_Role, {Key, _SpecArg}, _TriggerId, _AId, Target) when Key =/= Target ->
    ok;
special_event(Role, {Key, SpecArg}, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, {Key, SpecArg}).

%% 到商店购买物品
buy_item_store(_Role, _Item = #item{base_id = BaseId}, _TriggerId, _AId, Target) when BaseId =/= Target andalso Target =/= 0 ->
    ok;
buy_item_store(Role, Item, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, Item).

%% 添加一位好友
make_friend(_Role, #friend{type = Type}, _TriggerId, _TaskId, _Target) when Type =/= ?sns_friend_type_hy ->
    ok;
make_friend(Role, Friend, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, Friend).

%% 拥有好友
has_friend(_Role, #friend{type = Type}, _TriggerId, _TaskId, _Target) when Type =/= ?sns_friend_type_hy ->
    ok;
has_friend(Role, Friend, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, Friend).

%% 完成累计类事件
acc_event(_Role, {Key, _Args}, _TriggerId, _AId, Target) when Key =/= Target ->
    ok;
acc_event(_Role, {_Key, N}, _TriggerId, _AId, _Target) when is_integer(N) andalso N =< 0 ->
    ok;
acc_event(Role, {Key, Args}, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, {Key, Args}).

%% 身上装备变化事件
eqm_event(Role, Args, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, Args).

%%--------------------------------------------------------------
%% 内部函数
%%--------------------------------------------------------------

%% 更新进度信息
update_progress(Role = #role{trigger = Trigger, achievement = Ach = #role_achievement{day_list = DList}}, TriggerId, AId, Arg) when AId < 10000 -> %% 日常目标
    case lists:keyfind(AId, #achievement.id, DList) of
        false -> ok;
        #achievement{status = 1} -> ok; %% 已完成
        A = #achievement{progress = Progs} ->
            case do_update(AId, Role, Progs, Trigger, TriggerId, Arg, [], false) of
                {_, _NProgs, _NTrigger, false} -> %% 进度未变化
                    ok;
                {false, NProgs, NTrigger, true} -> %% 进度有变化，未全部完成
                    NewA = A#achievement{progress = NProgs},
                    NDList = lists:keyreplace(AId, #achievement.id, DList, NewA),
                    NewRole = Role#role{trigger = NTrigger, achievement = Ach#role_achievement{day_list = NDList}},
                    {ok, NewRole};
                {true, NProgs, NTrigger, _} -> %% 全部进度完成
                    NA = A#achievement{status = ?achievement_status_finish, progress = NProgs, finish_time = util:unixtime()},
                    achievement:push_info(refresh, NA, Role),
                    NDList = lists:keyreplace(AId, #achievement.id, DList, NA),
                    NRole = Role#role{trigger = NTrigger, achievement = Ach#role_achievement{day_list = NDList}},
                    NewRole = role_listener:special_event(NRole, {30031, 1}), %%完成一次每日目标
                    {ok, NewRole}
            end
    end;
update_progress(Role = #role{trigger = Trigger, achievement = Ach = #role_achievement{d_list = DList}}, TriggerId, AId, Arg) ->
    case lists:keyfind(AId, #achievement.id, DList) of
        false -> ok;
        #achievement{status = 1} -> ok; %% 已完成
        A = #achievement{progress = Progs} ->
            case do_update(AId, Role, Progs, Trigger, TriggerId, Arg, [], false) of
                {_, _NProgs, _NTrigger, false} -> %% 进度未变化
                    ok;
                {false, NProgs, NTrigger, true} -> %% 进度有变化，未全部完成
                    NewA = A#achievement{progress = NProgs},
                    NDList = lists:keyreplace(AId, #achievement.id, DList, NewA),
                    NewRole = Role#role{trigger = NTrigger, achievement = Ach#role_achievement{d_list = NDList}},
                    achievement:push_info(refresh, NewA, NewRole),
                    {ok, NewRole};
                {true, NProgs, NTrigger, _} -> %% 全部进度完成
                    NA = A#achievement{status = ?achievement_status_finish, progress = NProgs, finish_time = util:unixtime()},
                    NDList = lists:keyreplace(AId, #achievement.id, DList, NA),
                    NRole = Role#role{trigger = NTrigger, achievement = Ach#role_achievement{d_list = NDList}},
                    achievement:push_info(refresh, NA, NRole),
                    NRole1 = role_listener:special_event(NRole, {20016, AId}),
                    case achievement:add_new_accept(NRole1) of
                        {ok, NewRole} when is_record(NewRole, role) -> 
                            {ok, NewRole};
                        _ -> 
                            {ok, NRole1}
                    end
            end
    end.

%% 执行更新
do_update(_AId, _Role, [], Trigger, _Tid, _Arg, Progs, Bool) -> %% 检测完成
    PL = [P || P <- Progs, P#achievement_progress.status =:= 0],
    {length(PL) =:= 0, Progs, Trigger, Bool};
do_update(AId, Role, [P = #achievement_progress{status = 1} | T], Trigger, Tid, Arg, Progs, Bool) -> %% 已完成
    do_update(AId, Role, T, Trigger, Tid, Arg, [P | Progs], Bool);
do_update(AId, Role, [P = #achievement_progress{id = Tid, trg_label = Label, value = OldVal, target_value = TargetVal} | T], Trigger, Tid, Arg, Progs, Bool) -> %% 当前触发进度
    NewVal = achievement_callback_upd:upd(AId, Role, P, Arg),
    case NewVal >= TargetVal of
        false when NewVal =< OldVal -> %% 进度未完成 新值比原值小 结果不变
            do_update(AId, Role, T, Trigger, Tid, Arg, [P | Progs], Bool);
        false -> %% 进度未完成
            do_update(AId, Role, T, Trigger, Tid, Arg, [P#achievement_progress{value = NewVal} | Progs], NewVal =/= OldVal);
        true -> %% 完成进度
            NP = P#achievement_progress{value = TargetVal, status = 1},
            case role_trigger:del(Label, Trigger, Tid) of
                {ok, NewTrigger} -> %% 进度完成 删除触发器成功
                    ?DEBUG("[~p]删除触发器Label:~w TriggerId:~w", [AId, Label, Tid]),
                    do_update(AId, Role, T, NewTrigger, Tid, Arg, [NP | Progs], true);
                _ ->
                    ?DEBUG("[~p]删除触发器失败Label:~w TriggerId:~w", [AId, Label, Tid]),
                    do_update(AId, Role, T, Trigger, Tid, Arg, [NP | Progs], true)
            end
    end;
do_update(AId, Role, [P | T], Trigger, Tid, Arg, Progs, Bool) ->
    do_update(AId, Role, T, Trigger, Tid, Arg, [P | Progs], Bool).
