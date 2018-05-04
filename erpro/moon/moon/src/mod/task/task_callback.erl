%%----------------------------------------------------
%% @doc task_callback
%% 
%% <pre>
%% 任务触发器回调处理
%% 回调函数的作用是修改任务进度及检查任务状态是否完成
%% 每个条件生成一个进度信息和向触发器注册一个回调函数
%% 每个回调函数都对应一个任务进度信息
%% </pre>
%% <pre>
%% spec callback_fun(Role, Arg, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% Role = NewRole = #role{} 角色属性
%% Arg = 这部分根据不同的监听器会得到不同的参数，具体请看监听器的说明
%% TriggerId = integer() 触发器ID 所有回调函数都有一个TriggerId，也就是仅针对一个进度信息操作
%% TaskId = integer() 梆定的任务ID
%% Target 关注的东西ID
%% 注：回调函数名称与#condition 标签字段一一对应，根据业务将不同的回调函数注册到触发器trigger的不同字段中
%% 所有的回调函数结构都如下所示
%% </pre>
%% @author yeahoo2000@gmail.com
%% @author yqhuang (QQ:19123767)
%% @end
%%----------------------------------------------------
-module(task_callback).
-export([
        coin/5
        ,get_coin/5
        ,get_item/5
        ,use_item/5
        ,vip/5
        ,kill_npc/5
        ,get_task/5
        ,finish_task/5
        ,lev/5
        ,buy_item_shop/5
        ,special_event/5
        ,buy_item_store/5
        ,make_friend/5
        ,sweep_dungeon/5
        ,ease_dungeon/5
        ,once_dungeon/5
        ,star_dungeon/5
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("task.hrl").
-include("item.hrl").
-include("vip.hrl").
-include("npc.hrl").
-include("assets.hrl").
-include("link.hrl").
-include("sns.hrl").
-include("boss.hrl").
-include("team.hrl").

-define(KEY_POS, 2).

%% @spec con(Role, Coin, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% 要求金币大于或等于指定值
%% Coin = integer() 涉及金币数
%% </pre>
coin(Role = #role{assets = #assets{coin = ACoin}}, _Coin, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, ACoin).

%% @spec get_coin(Role, Coin, TriggerId, TaskId, _Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% 要求得到金币大于或等于指定值
%% Coin = integer() 涉及金币数
%% </pre>
get_coin(Role, Coin, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, Coin).

%% @spec get_item(Role, Item, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% 当得到物品时，更新任务进度 
%% Item = #item{} 得到的物品
%% </pre>
get_item(_Role, #item{base_id = BaseId}, _TriggerId, _TaskId, Target) when BaseId =/= Target ->
    ok; %% 非关注的物品，不作任何处理
get_item(Role, Item, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, Item).

%% @spec use_item(Role, Item, TriggerId, TaskId, Target) -> ok | {ok, NewRole} 
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% 当得到物品时，更新任务进度 
%% Item = #item{} 得到的物品
%% </pre>
use_item(_Role, #item{base_id = BaseId}, _TriggerId, _TaskId, Target) when BaseId =/= Target ->
    ok; %% 非关注的物品，不作任何处理
use_item(Role, Item, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, Item).

%% @spec vip(Role, Vip, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% 当得到物品时，更新任务进度 
%% Vip = #vip{} 角色vip属性
%% </pre>
vip(Role, Vip, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, Vip).

%% @spec kill_npc(Role, {NpcBaseId, Num}, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% <pre>
%% 杀死指定NPC Num次
%% NpcBaseId = integer() Npc Base Id
%% Num = integer() 斩杀数量
%% </pre>
kill_npc(Role, {NpcBaseId, Num}, TriggerId, TaskId, Target) when NpcBaseId =:= Target ->
    update_progress(Role, TriggerId, TaskId, {NpcBaseId, Num});
%% 表里镇妖塔boss兼容
kill_npc(Role, {30194, Num}, TriggerId, TaskId, 30054) ->
    update_progress(Role, TriggerId, TaskId, {30054, Num});
kill_npc(Role, {24050, Num}, TriggerId, TaskId, 30054) ->
    update_progress(Role, TriggerId, TaskId, {30054, Num});
kill_npc(Role, {24051, Num}, TriggerId, TaskId, 30055) ->
    update_progress(Role, TriggerId, TaskId, {30055, Num});
kill_npc(Role, {24052, Num}, TriggerId, TaskId, 30056) ->
    update_progress(Role, TriggerId, TaskId, {30056, Num});
kill_npc(Role, {24053, Num}, TriggerId, TaskId, 30057) ->
    update_progress(Role, TriggerId, TaskId, {30057, Num});
kill_npc(Role, {24054, Num}, TriggerId, TaskId, 30058) ->
    update_progress(Role, TriggerId, TaskId, {30058, Num});
kill_npc(Role, {24055, Num}, TriggerId, TaskId, 30059) ->
    update_progress(Role, TriggerId, TaskId, {30059, Num});
kill_npc(Role, {24056, Num}, TriggerId, TaskId, 30060) ->
    update_progress(Role, TriggerId, TaskId, {30060, Num});
kill_npc(Role, {24057, Num}, TriggerId, TaskId, 30061) ->
    update_progress(Role, TriggerId, TaskId, {30061, Num});
kill_npc(Role, {24058, Num}, TriggerId, TaskId, 30062) ->
    update_progress(Role, TriggerId, TaskId, {30062, Num});
kill_npc(Role, {24059, Num}, TriggerId, TaskId, 30063) ->
    update_progress(Role, TriggerId, TaskId, {30063, Num});
kill_npc(Role, {24060, Num}, TriggerId, TaskId, 30064) ->
    update_progress(Role, TriggerId, TaskId, {30064, Num});
kill_npc(Role, {24061, Num}, TriggerId, TaskId, 30065) ->
    update_progress(Role, TriggerId, TaskId, {30065, Num});
%% 表里龙宫boss兼容
kill_npc(Role, {24150, Num}, TriggerId, TaskId, 25038) ->
    update_progress(Role, TriggerId, TaskId, {25038, Num});
kill_npc(Role, {24151, Num}, TriggerId, TaskId, 25039) ->
    update_progress(Role, TriggerId, TaskId, {25039, Num});
kill_npc(Role, {24152, Num}, TriggerId, TaskId, 25040) ->
    update_progress(Role, TriggerId, TaskId, {25040, Num});
kill_npc(Role, {24153, Num}, TriggerId, TaskId, 25041) ->
    update_progress(Role, TriggerId, TaskId, {25041, Num});
kill_npc(Role, {24154, Num}, TriggerId, TaskId, 25042) ->
    update_progress(Role, TriggerId, TaskId, {25042, Num});
kill_npc(Role, {24155, Num}, TriggerId, TaskId, 25043) ->
    update_progress(Role, TriggerId, TaskId, {25043, Num});
kill_npc(Role, {24156, Num}, TriggerId, TaskId, 25044) ->
    update_progress(Role, TriggerId, TaskId, {25044, Num});
kill_npc(Role, {24157, Num}, TriggerId, TaskId, 25045) ->
    update_progress(Role, TriggerId, TaskId, {25045, Num});
kill_npc(Role, {24158, Num}, TriggerId, TaskId, 25046) ->
    update_progress(Role, TriggerId, TaskId, {25046, Num});
kill_npc(Role, {24159, Num}, TriggerId, TaskId, 25047) ->
    update_progress(Role, TriggerId, TaskId, {25047, Num});
kill_npc(Role, {24160, Num}, TriggerId, TaskId, 25048) ->
    update_progress(Role, TriggerId, TaskId, {25048, Num});
kill_npc(Role, {24161, Num}, TriggerId, TaskId, 25049) ->
    update_progress(Role, TriggerId, TaskId, {25049, Num});
kill_npc(_, _, _TriggerId, _TaskId, _Target) ->
    ok.

%% @spec get_task(Role, GetTaskId, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% <pre>
%% GetTaskId = integer() 接受任务的Id
%% 要求已接下指定的任务 target = 0 target_value = 任务ID
%% </pre>
get_task(Role, GetTaskId, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, GetTaskId).

%% @spec finish_task(Role, TaskId, TriggerId, TaskId, Target) -> ok | {ok, NewRole} 
%% @equiv callback_fun/5
%% <pre>
%% TaskId = integer() 完成任务的Id
%% 完成任务触发器
%% </prie>
finish_task(_Role, TaskId, _TriggerId, _TaskId, Target) when TaskId =/= Target ->
    ok;
finish_task(Role, TaskId, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, TaskId).

%% @spec lev(Role, Lev, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% <pre>
%% Lev = integer() 当前角色等级
%% 要求等级大于或等于指定值
%% </pre>
lev(Role, Lev, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, Lev).

%% @spec buy_item_shop(Role, Item, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% @equiv callback_fun/5
%% @doc
%% <pre>
%% Item = #item{} 物品记录
%% </pre>
buy_item_shop(_Role, _Item = #item{base_id = BaseId}, _TriggerId, _TaskId, Target) when BaseId =/= Target ->
    ok;
buy_item_shop(Role, Item, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, Item).

    
%% 完成特殊任务
special_event(_Role, {Key, _SpecArg}, _TriggerId, _TaskId, Target) when Key =/= Target ->
    ok;
special_event(Role, {Key, SpecArg}, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, {Key, SpecArg}).

%% 到商店购买物品
buy_item_store(_Role, _Item = #item{base_id = BaseId}, _TriggerId, _TaskId, Target) when BaseId =/= Target ->
    ok;
buy_item_store(Role, Item, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, Item).

%% 添加一位好友
make_friend(_Role, #friend{type = Type}, _TriggerId, _TaskId, _Target) when Type =/= ?sns_friend_type_hy ->
    ok;
make_friend(Role, Friend, TriggerId, TaskId, _Target) ->
    update_progress(Role, TriggerId, TaskId, Friend).

%% @spec sweep_dungeon(Role, {DunId, Num}, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% <pre>
%% 当扫荡完副本时，更新任务进度 
%% DunId 扫荡完的副本ID
%% </pre>
sweep_dungeon(Role, Arg = {DunId, _Num}, TriggerId, TaskId, DunId1) when DunId =:= DunId1 ->
    update_progress(Role, TriggerId, TaskId, Arg);
sweep_dungeon(_Role, _Arg, _TriggerId, _TaskId, _Target) ->
    ok.

%% @spec ease_dungeon(Role, {DunId, Num}, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% <pre>
%% 通关休闲副本时，更新任务进度 
%% DunId 副本ID
%% </pre>
ease_dungeon(Role, Arg = {DunId, _Num}, TriggerId, TaskId, DunId1) when DunId =:= DunId1 ->
    update_progress(Role, TriggerId, TaskId, Arg);
ease_dungeon(_Role, _Arg, _TriggerId, _TaskId, _Target) ->
    ok.

%% @spec once_dungeon(Role, {DunId, Num}, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% <pre>
%% 通关休闲副本时，更新任务进度 
%% DunId 副本ID
%% </pre>
once_dungeon(Role, Arg = {DunId, _Num}, TriggerId, TaskId, DunId1) when DunId =:= DunId1 ->
    update_progress(Role, TriggerId, TaskId, Arg);
once_dungeon(_Role, _Arg, _TriggerId, _TaskId, _Target) ->
    ok.

%% @spec star_dungeon(Role, {DunId, Num}, TriggerId, TaskId, Target) -> ok | {ok, NewRole}
%% <pre>
%% 通关星级困副本时，更新任务进度 
%% DunId 副本ID
%% </pre>
star_dungeon(Role = #role{dungeon = RoleDungeons}, {DunId, Star}, TriggerId, TaskId, {DunId, NeedStar}) when Star >= NeedStar ->
    ?DEBUG(" 更新 star_dungeon  ~w  ~w", [DunId, Star]),
    update_progress(Role, TriggerId, TaskId, RoleDungeons);
star_dungeon(_Role, _Arg, _TriggerId, _TaskId, _Target) ->
    ?DEBUG(" 无法找到 star_dungeon  ~w  ~w", [_Arg, _Target]),
    ok.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------

%% @spec update_progress(Role, TriggerId, TaskId, Arg) -> ok | {ok, NewRole} 
%% @doc
%% <pre>
%% Role = #role{} 角色信息
%% TriggerId = integer() 触发器Id
%% TaskId = integer() 任务Id
%% Arg = term() 角色事件时传递的参数，可能是单简/复杂的数据结构
%% NewRole = #role{} 新的角色信息
%%
%% 更新任务进度
%% </pre>
update_progress(Role = #role{id = _Rid, task = TaskList, trigger = Trigger, link = #link{conn_pid = ConnPid}}, TriggerId, TaskId, Arg) -> 
    case lists:keyfind(TaskId, ?KEY_POS, TaskList) of
        false ->
            ok;
        Task = #task{progress = Progress, accept_num = AcceptNum, item_base_id = ItemBaseId, item_num = ItemNum} ->
            case do_update(Role, Progress, Trigger, TriggerId, Arg, []) of
                {true, Np, Nt, Role1} -> %% 所有进度已经完成
                    L = lists:keyreplace(TaskId, ?KEY_POS, TaskList, Task#task{status = 1, progress = Np}),
                    %% 发送进度变更
                    #task{status = Status, progress = NewProgress} = lists:keyfind(TaskId, ?KEY_POS, L),
                    %% Role1 = task:add_eqm(Role, Np),
                    {ok, #task_base{npc_accept = NpcAccept, npc_commit = NpcCommit}} = task_data:get_conf(TaskId),
                    sys_conn:pack_send(ConnPid, 10202, {TaskId, Status, AcceptNum, ItemBaseId, ItemNum, task_rpc:convert_progress(NewProgress)}),
                    task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 0}]),
                    task_rpc:send_upd_npc_status(ConnPid, [{NpcCommit, TaskId, 3}]),
                    {ok, Role1#role{task = L, trigger = Nt}};
                {false, Np, Nt, Role1} -> %% 未完成所有进度
                    L = lists:keyreplace(TaskId, ?KEY_POS, TaskList, Task#task{progress = Np}),
                    #task{status = Status, progress = NewProgress} = lists:keyfind(TaskId, ?KEY_POS, L),
                    %% Role1 = task:add_eqm(Role, Np),
                    %% 发送进度变更
                    sys_conn:pack_send(ConnPid, 10202, {TaskId, Status, AcceptNum, ItemBaseId, ItemNum, task_rpc:convert_progress(NewProgress)}),
                    {ok, Role1#role{task = L, trigger = Nt}}
            end
    end.

%% @spec do_update(TaskProgList, Trigger, Tid, Arg, RtnProg) -> {ok, NewTrigger}
%% @doc
%% <pre>
%% TaskProgList = list() of #task_progress{} 任务进度信息
%% Trigger = #trigger{} 触发器
%% Tid = integer() 触发器Id
%% Arg = 触发事件时传递的参数，可能是简单/复杂的参数类型
%%
%% 调用task_callback_upd:upd/2方法更新任务进度
%% </pre>
do_update(Role, [P = #task_progress{id = ProgId, trg_label = Label, cond_label = CLabel, target = Target, target_value = TargetVal, status = Status} | PT], Trigger, Tid, Arg, RtnProg) when ProgId =:= Tid andalso Status =:= 0 ->
    NewVal = erlang:apply(task_callback_upd, upd, [P, Arg]),
    P1 = P#task_progress{value = NewVal},
    Role2 =
    case {CLabel, TargetVal =:= NewVal, lists:member(Target, [1069])} of
        {special_event, true, true} ->
            case task:add_eqm(Role, TargetVal) of
                {ok, Role1} -> Role1;
                {false, Role1} -> ?DEBUG("穿戴装备失败..."), Role1
            end;
        _ ->
            Role
    end,
    {P2, Trigger2} = 
        case NewVal =:= TargetVal of
             true -> %% 完成进度
                 {ok, Nt} = 
                     case role_trigger:del(Label, Trigger, Tid) of
                        {ok, Nt1} ->
                            {ok, Nt1};
                        _ ->
                            ?DEBUG("删除触发器失败"),
                            {ok, Trigger}
                     end,
                 {P1#task_progress{status = 1}, Nt};
             false ->
                 {P1, Trigger}
         end,
    do_update(Role2, PT, Trigger2, Tid, Arg, [P2 | RtnProg]);

do_update(Role, [P = #task_progress{id = _ProgId} | PT], Trigger, Tid, Arg, RtnProg) ->
    do_update(Role, PT, Trigger, Tid, Arg, [P | RtnProg]);

do_update(Role, [], Trigger, _Tid, _Arg, RtnProg) ->
    PL = [P || P <- RtnProg, P#task_progress.status =:= 0],
    case length(PL) =:= 0 of
        true ->
            {true, RtnProg, Trigger, Role};
        false ->
            {false, RtnProg, Trigger, Role}
    end.
