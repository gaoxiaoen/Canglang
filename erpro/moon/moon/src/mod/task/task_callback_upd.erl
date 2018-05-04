%%----------------------------------------------------
%% @doc task_callback_upd
%%
%% <pre>
%% 任务系统回调函数的update方法
%% </pre>
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(task_callback_upd).

-include("common.hrl").
-include("vip.hrl").
-include("task.hrl").
-include("item.hrl").
-include("role.hrl").
-include("dungeon.hrl").

-export([
        value_replace/3
        ,value_inc/3
        ,upd/2
    ]
).

%% @spec value_replace(V1, V2,  _V3) -> V2
%% @doc
%% <pre>
%% 任务进度值的处理方法
%% 将V2替换掉V1的值
%% </pre>
value_replace(_V1, V2, _) -> V2.

%% @spec value_inc(V1, V2, TVal) -> Rs
%% @doc
%% <pre>
%% 累加
%% </pre>
value_inc(V1, V2, TVal) ->
    V = V1 + V2,
    case V >= TVal of
        true -> TVal;
        false -> V
    end.

%% @upd(Prg, Arg) -> NewVal
%% @doc
%% <pre>
%% Arg = term() 回调函数触发参数,也就是回调函数的第二个参数
%% NewVal = #task_progress.value 新的任务进度的当前值
%% 当返回值用于修改进度当前值,当等于目标值时,进度完成
%% 对任务进度状态修改
%% </pre>

%% <pre>
%% 当得到物品时，更新任务进度 
%% Item = #item{} 得到的物品
%% </pre>
upd(#task_progress{cond_label = get_item, value = Value, target_value = TargetVal}, #item{quantity = Q}) ->
    value_inc(Value, Q, TargetVal);

%% <pre>
%% 当得到物品时，更新任务进度 
%% Item = #item{} 得到的物品
%% </pre>
upd(#task_progress{cond_label = use_item, value = Value, target_value = TargetVal}, #item{quantity = Q}) ->
    value_inc(Value, Q, TargetVal);

%% <pre>
%% 要求金币大于或等于指定值
%% Coin = integer() 角色现有金币数
%% </pre>
upd(#task_progress{cond_label = coin, value = _Value, target_value = TargetVal}, Coin) ->
    case Coin >= TargetVal of
        true -> TargetVal;
        false -> 0
    end;

%% <pre>
%% 要求金币大于或等于指定值
%% Coin = integer() 涉及到金币数量,负数为减少数量
%% </pre>
upd(#task_progress{cond_label = get_coin, value = Value, target_value = TargetVal}, Coin) ->
    case Coin > 0 of
        true ->
            value_inc(Value, Coin, TargetVal);
        false -> %% 负数忽略
            Value
    end;

%% <pre>
%% vip状态改变时，对任务进度状态修改
%% Arg = #vip{} 角色VIP属性
%% NewVal = #task_progress.value 0:非VIP 1:是VIP
%% </pre>
upd(#task_progress{cond_label = vip, value = _Value, target_value = _TargetVal}, Vip) ->
    case Vip#vip.type =:= 0 of
        true -> 0;
        false -> 1
    end;

%% <pre>
%% 要求杀死指定的NPC N次
%% Npc = #npc{} 被杀NPC
%% Num = integer() 被杀NPC数量
%% NewVal = integer() 新已杀NPC数量
%% </pre>
upd(#task_progress{cond_label = kill_npc, value = Value, target_value = TargetVal}, {_NpcBaseId, Num}) ->
    V = Num + Value,
    case V >= TargetVal of
        true -> TargetVal;
        false -> V
    end;

%% <pre>
%% 要求完成指定的任务N次
%% @upd_finish_task(Value, TaskId, TargetVal) -> NewVal
%% Value = interger() 已完成次数
%% Arg = TaskId = integer() 完成的任务ID
%% TargetVal = integer() 目标完成次数
%% NewVal = integer() 新已完成次数
%% </pre>
upd(#task_progress{cond_label = finish_task, value = Value, target_value = TargetVal}, _TaskId) ->
    V = Value + 1,
    case V >= TargetVal of
        true -> TargetVal;
        false -> V
    end;

%% <pre>
%% 获取某任务触发
%% Arg = GetTaskId = integer() 获取的任务ID
%% NewVal = integer() 目标任务ID
%% </pre>
upd(#task_progress{cond_label = get_task, value = _Value, target_value = TargetVal}, GetTaskId) ->
    case GetTaskId =:= TargetVal of
        true ->
            TargetVal;
        false ->
            0
    end;

%% <pre>
%% 要求等级大于或等于指定值
%% Lev = integer() 当前角色等级
%% </pre>
upd(#task_progress{cond_label = lev, value = _Value, target_value = TargetVal}, Lev) ->
    case Lev >= TargetVal of
        true -> TargetVal;
        false -> 0
    end;

%% 到商城买一个物品
upd(#task_progress{cond_label = buy_item_shop, value = Value, target_value = TargetVal}, _Item = #item{quantity = Quantity}) ->
    case (Value + Quantity) > TargetVal of
        true -> TargetVal;
        false -> Value + Quantity
    end;

%% 完成一个特殊任务
%% Arg = {Key, SpecArg}
upd(#task_progress{cond_label = special_event, target = Target, value = Value, target_value = TargetVal}, {_Key, SpecArg}) ->
    case {Target, SpecArg} of
        {_, finish} ->
            TargetVal;
        {1061, _} -> %% 技能
            TargetVal;
        {1017, 10001} -> %% 进入青松峰副本
            TargetVal;
        {1025, _} when SpecArg >= TargetVal ->
            TargetVal;
        {1045, _} ->
            case (Value + SpecArg) >= TargetVal of
                true -> TargetVal;
                false -> (Value + SpecArg)
            end;
        _Other when is_integer(Target) andalso Target >= 1055 andalso 1068 >= Target ->
            case (Value + SpecArg) >= TargetVal of
                true -> TargetVal;
                false -> (Value + SpecArg)
            end;
        {1069, V} -> V;
        {1070, V} -> V;
        {1071, V} -> V;
        {1072, V} -> V;
        {30018, _} ->
            case (Value + 1) >= TargetVal of
                true -> TargetVal;
                false -> (Value + SpecArg)
            end;
        _Other ->
            Value
    end;

%% 到商店买一个物品
upd(#task_progress{cond_label = buy_item_store, value = Value, target_value = TargetVal}, _Item = #item{quantity = Quantity}) ->
    case (Value + Quantity) > TargetVal of
        true -> TargetVal;
        false -> Value + Quantity
    end;

%% 添加N个好友
upd(#task_progress{cond_label = make_friend, value = Value, target_value = TargetVal}, _Friend) ->
    case (Value + 1) > TargetVal of
        true -> TargetVal;
        false -> Value + 1 
    end;

%% 扫荡某个副本达到N次
upd(#task_progress{cond_label = sweep_dungeon, value = Value, target_value = TargetVal}, {_Dungeon,Num}) ->
    case (Value + Num) > TargetVal of
        true -> TargetVal;
        false -> Value + Num 
    end;

%% 通关休闲副本
upd(#task_progress{cond_label = ease_dungeon, value = Value, target_value = TargetVal}, {_Dungeon,Num}) ->
    case (Value + Num) > TargetVal of
        true -> TargetVal;
        false -> Value + Num 
    end;

%% 通关副本
upd(#task_progress{cond_label = once_dungeon, value = Value, target_value = TargetVal}, {_Dungeon,Num}) ->
    case (Value + Num) > TargetVal of
        true -> TargetVal;
        false -> Value + Num 
    end;

%% 星级副本
upd(#task_progress{cond_label = star_dungeon, value = Value, target_value = TargetVal, map_id = MapId}, RoleDungeons) ->
    case lists:keyfind(MapId, #role_dungeon.id, RoleDungeons) of
        #role_dungeon{clear_count = ClearCount} when ClearCount >= TargetVal ->
            TargetVal;
        #role_dungeon{clear_count = ClearCount} ->
            ClearCount;
        _ ->
            Value
    end;

%% 容错函数
upd(Prg, Arg) -> 
    ?ELOG("没有匹配的upd函数Prg:~w, Arg:~w", [Prg, Arg]).

