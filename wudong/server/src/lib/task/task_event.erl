%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 任务触发
%%% @end
%%% Created : 09. 九月 2015 上午10:44
%%%-------------------------------------------------------------------
-module(task_event).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("task.hrl").
-include("dungeon.hrl").
-include("goods.hrl").

%% API
-export([event/2, task_event/3, preact_finish/1, preact_finish/2]).


%% 有部分任务内容在触发的时候可能就完成了
preact_finish(Player) ->
    ActiveList = task:get_task_active_list(),
    F = fun(Task) ->
        preact_finish(Task, Player)
        end,
    lists:foreach(F, ActiveList).

preact_finish(TaskId, Player) when is_integer(TaskId) ->
    case task:get_task(TaskId) of
        [] -> skip;
        Task ->
            preact_finish(Task, Player)
    end;

preact_finish(Task, Player) when is_record(Task, task) ->
    if Task#task.state == ?TASK_ST_FINISH -> skip;
        true ->
            F = fun({Act, Item, Num, NowNum}) ->
                preact_finish_check({Act, Item, Num, NowNum}, Player)
                end,
            lists:foreach(F, Task#task.state_data)
    end;

preact_finish(_, _) -> skip.


%%进入副本任务3
preact_finish_check({?TASK_ACT_DUNGEON, DunId, _Times, _NowTimes}, _Player) ->
    case data_dungeon:get(DunId) of
        [] -> skip;
        _Dun ->
            IsFuwen = dungeon_util:is_dungeon_fuwen_tower(DunId),
            IsEquip = dungeon_util:is_dungeon_equip(DunId),
            if IsFuwen ->
                StDunFuwenTower = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
                ?DO_IF(lists:member(DunId, StDunFuwenTower#st_dun_fuwen_tower.dun_list), event(?TASK_ACT_DUNGEON, {DunId, 1}));
                IsEquip ->
                    ?DO_IF(dungeon_equip:is_pass(DunId), event(?TASK_ACT_DUNGEON, {DunId, 1}));
                true ->
                    Count = dungeon_util:get_dungeon_times(DunId),
                    ?DO_IF(Count > 0, event(?TASK_ACT_DUNGEON, {DunId, Count}))
            end
    end;

preact_finish_check({?TASK_ACT_ARENA, _Times, _, _}, _Player) ->
    Count = dungeon_util:get_dungeon_times(?SCENE_ID_ARENA),
    if Count > 0 ->
        event(?TASK_ACT_ARENA, {Count});
        true -> skip
    end;

preact_finish_check({?TASK_ACT_DUN_EXP, _Round, _, _}, _Player) ->
    Round = dungeon_exp:get_enter_dungeon_round(),
    if Round > 0 ->
        event(?TASK_ACT_DUN_EXP, {Round});
        true -> skip
    end;

%%指定时间段登陆
preact_finish_check({?TASK_ACT_LOGIN, StartTime, EndTime, _}, _Player) ->
    NowTime = util:unixtime(),
    if NowTime >= StartTime andalso NowTime =< EndTime ->
        event(?TASK_ACT_LOGIN, NowTime);
        true -> skip
    end;
%%
%%%%参与指定活动
%%preact_finish_check({?TASK_ACT_ACTIVITY, ActivityType, _Times, _NowTimes}, _Player) ->
%%    Count = 0,
%%    if Count > 0 ->
%%        event(?TASK_ACT_ACTIVITY, {ActivityType, Count});
%%        true -> skip
%%    end;
%%
%%%%收集指定宠物
%%preact_finish_check({?TASK_ACT_PET, PetId, _Num, _NowNum}, _Player) ->
%%    Count = 0,
%%    if Count > 0 ->
%%        event(?TASK_ACT_PET, {PetId, Count});
%%        true -> skip
%%    end;

%%收集指定货币
preact_finish_check({?TASK_ACT_MONEY, MoneyType, _Num, _NowNum}, Player) ->
    Count =
        case MoneyType of
            1 -> Player#player.gold;
            2 -> Player#player.bgold;
            3 -> Player#player.coin;
            _ -> 0
        end,
    if Count > 0 ->
        event(?TASK_ACT_MONEY, {MoneyType, Count});
        true -> skip
    end;

%%收集物品
%%preact_finish_check({?TASK_ACT_GOODS, GoodsId, _Num, _NowNum}, _Player) ->
%%    Count = goods_util:get_goods_count(GoodsId),
%%    if Count > 0 ->
%%        event(?TASK_ACT_GOODS, {GoodsId, Count});
%%        true -> skip
%%    end;

%%升级任务
preact_finish_check({?TASK_ACT_UPLV, TarLv, _TarState, _CurState}, Player) ->
    if Player#player.lv >= TarLv ->
        event(?TASK_ACT_UPLV, {Player#player.lv});
        true -> skip
    end;

preact_finish_check({?TASK_ACT_TASK_TYPE, TarType, _Num, _NowNum}, _Player) ->
    case TarType of
        ?TASK_TYPE_CYCLE ->
            TaskCycle = task_cycle:get_cycle_task(),
            if TaskCycle#task_cycle.cycle > 0 ->
                event(?TASK_ACT_TASK_TYPE, {TarType, TaskCycle#task_cycle.cycle});
                true -> skip
            end;
        ?TASK_TYPE_GUILD ->
            ok;
        _ -> skip
    end;

preact_finish_check({?TASK_ACT_EQUIP_STRENGTH, _TarSten, _TarNum, _CurNum}, _Player) ->
    EquipList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    EquipStrengthList = equip_util:get_equip_stren_list(EquipList),
    F2 = fun({Stren, StrenCount}) ->
        event(?TASK_ACT_EQUIP_STRENGTH, {Stren, StrenCount})
         end,
    lists:foreach(F2, EquipStrengthList),
    ok;

preact_finish_check({?TASK_ACT_CHARGE, _, _, _}, _Player) ->
    case charge:get_charge_acc_times() of
        0 -> ok;
        Times ->
            task_event:event(?TASK_ACT_CHARGE, {Times})
    end;

preact_finish_check({?TASK_ACT_DUN_GOD_WEAPON, DunId, Round, _}, _Player) ->
    StDunGodWeapon = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    Layer = data_dungeon_god_weapon:scene2layer(DunId),
    if Layer < StDunGodWeapon#st_dun_god_weapon.layer_h ->
        task_event:event(?TASK_ACT_DUN_GOD_WEAPON, {DunId, Round});
        Layer == StDunGodWeapon#st_dun_god_weapon.layer_h ->
            ?DO_IF(Round =< StDunGodWeapon#st_dun_god_weapon.round_h, task_event:event(?TASK_ACT_DUN_GOD_WEAPON, {DunId, Round}));
        true -> ok
    end;


preact_finish_check(_, _) ->
    false.

%%玩家进程外调用触发任务事件
task_event(Act, ParamList, Pid) when is_pid(Pid) ->
    Pid ! {task_event, [Act, ParamList]};
task_event(Act, ParamList, Pkey) ->
    case player_util:get_player_pid(Pkey) of
        false -> skip;
        Pid ->
            Pid ! {task_event, [Act, ParamList]}
    end.


%%触发任务动作事件
%%npc对话
event(?TASK_ACT_NPC, {TaskId, NpcId}) ->
    action(TaskId, ?TASK_ACT_NPC, [NpcId]);
%%击杀怪物
event(?TASK_ACT_KILL, {MonId, MonNum}) ->
    action(0, ?TASK_ACT_KILL, [MonId, MonNum]);
%%击杀怪物
event(?TASK_ACT_KILL, MonId) ->
    action(0, ?TASK_ACT_KILL, [MonId]);
%%采集物品
event(?TASK_ACT_COLLECT, MonId) ->
    action(0, ?TASK_ACT_COLLECT, [MonId]);
%%收集物品
event(?TASK_ACT_GOODS, {GoodsId, Num}) ->
    action(0, ?TASK_ACT_GOODS, [GoodsId, Num]);
%%通关副本
event(?TASK_ACT_DUNGEON, {DunId, Times}) ->
    action(0, ?TASK_ACT_DUNGEON, [DunId, Times]);
%%收集货币
event(?TASK_ACT_MONEY, {MoneyType, Num}) ->
    action(0, ?TASK_ACT_MONEY, [MoneyType, Num]);
event(?TASK_ACT_ACC_MONEY, {MoneyType, Num}) ->
    action(0, ?TASK_ACT_ACC_MONEY, [MoneyType, Num]);
%%购买物品
event(?TASK_ACT_SHOP, {GoodsId, Num}) ->
    action(0, ?TASK_ACT_SHOP, [GoodsId, Num]);
%%指定时间段登陆
event(?TASK_ACT_LOGIN, Time) ->
    action(0, ?TASK_ACT_LOGIN, [Time]);
%%收集宠物
event(?TASK_ACT_PET, {PetId, Num}) ->
    action(0, ?TASK_ACT_PET, [PetId, Num]);
%%参与活动
event(?TASK_ACT_ACTIVITY, Times) ->
    action(0, ?TASK_ACT_ACTIVITY, [Times]);
%%寻宝
event(?TASK_ACT_TREASURE, {Times}) ->
    action(0, ?TASK_ACT_TREASURE, [Times]);
%%按类型寻宝
event(?TASK_ACT_TREASURE_BY_ID, {GoodsId, Times}) ->
    action(0, ?TASK_ACT_TREASURE_BY_ID, [GoodsId, Times]);
%%升级
event(?TASK_ACT_UPLV, {Lv}) ->
    action(0, ?TASK_ACT_UPLV, [Lv]);
%%完成指定类型任务
event(?TASK_ACT_TASK_TYPE, {TaskType, Times}) ->
    action(0, ?TASK_ACT_TASK_TYPE, [TaskType, Times]);
%%装备强化
event(?TASK_ACT_STRENGTHEN, {Times}) ->
    action(0, ?TASK_ACT_STRENGTHEN, [Times]);

%%准备洗练
event(?TASK_ACT_WASH, {Times}) ->
    action(0, ?TASK_ACT_WASH, [Times]);

%%镶嵌宝石
event(?TASK_ACT_STONE, {Times}) ->
    action(0, ?TASK_ACT_STONE, [Times]);
%%穿戴坐骑装备
event(?TASK_ACT_MOUNT_EQUIP, {Times}) ->
    action(0, ?TASK_ACT_MOUNT_EQUIP, [Times]);
%%坐骑装备强化
event(?TASK_ACT_MOUNT_EQUIP_STRENGTHEN, {Times}) ->
    action(0, ?TASK_ACT_MOUNT_EQUIP_STRENGTHEN, [Times]);
%%坐骑进阶
event(?TASK_ACT_MOUNT_STEP, {Times}) ->
    action(0, ?TASK_ACT_MOUNT_STEP, [Times]);
%%战力跑分
event(?TASK_ACT_CBP_EVA, {Times}) ->
    action(0, ?TASK_ACT_CBP_EVA, [Times]);
%%疯狂点击
event(?TASK_ACT_CLICK, {Times}) ->
    action(0, ?TASK_ACT_CLICK, [Times]);
%%竞技场
event(?TASK_ACT_ARENA, {Times}) ->
    action(0, ?TASK_ACT_ARENA, [Times]);
%%击杀服务器玩家
event(?TASK_ACT_KMB, {Times}) ->
    action(0, ?TASK_ACT_KMB, [Times]);
%%充值
event(?TASK_ACT_CHARGE, {Times}) ->
    action(0, ?TASK_ACT_CHARGE, [Times]);
%%X件强化Y的装备
event(?TASK_ACT_EQUIP_STRENGTH, {Strength, Count}) ->
    action(0, ?TASK_ACT_EQUIP_STRENGTH, [Strength, Count]);
%%经验副本
event(?TASK_ACT_DUN_EXP, {Round}) ->
    action(0, ?TASK_ACT_DUN_EXP, [Round]);
%%击杀等级怪
event(?TASK_ACT_MLV, {Mlv}) ->
    action(0, ?TASK_ACT_MLV, [Mlv]);
%%点金
event(?TASK_ACT_BET, {Times}) ->
    action(0, ?TASK_ACT_BET, [Times]);
%%宠物升阶
event(?TASK_ACT_PET_STAGE, {Times}) ->
    action(0, ?TASK_ACT_PET_STAGE, [Times]);
%%宠物升星
event(?TASK_ACT_PET_STAR, {Times}) ->
    action(0, ?TASK_ACT_PET_STAR, [Times]);
event(?TASK_ACT_DUN_GOD_WEAPON, {DunId, Round}) ->
    action(0, ?TASK_ACT_DUN_GOD_WEAPON, [DunId, Round]);
event(?TASK_ACT_GET_GOODS, {GoodsId, Num}) ->
    action(0, ?TASK_ACT_GET_GOODS, [GoodsId, Num]);
%%未定义
event(_, _) -> skip.


action(0, Act, ParamList) ->
    case task_init:get_task_st() of
        [] -> false;
        StTask ->
            F = fun(Task) ->
                action_check(Task, Act, ParamList)
                end,
            Result = lists:map(F, StTask#st_task.activelist),
            lists:member(true, Result)
    end;


action(TaskId, Act, ParamList) ->
    case task:get_task(TaskId) of
        [] -> false;
        Task ->
            action_check(Task, Act, ParamList)
    end.


action_check(Task, Act, ParamList) ->
    if Task#task.state == ?TASK_ST_FINISH -> false;
        true ->
            case lists:keymember(Act, 1, Task#task.state_data) of
                false -> false;
                true ->
                    action_one(Task, ParamList)
            end
    end.


action_one(Task, ParamList) ->
    F = fun(Action, Update) ->
        {Action2, Update2} = update(Action, ParamList),
        case Update2 of
            true -> {Action2, true};
            false -> {Action2, Update}
        end
        end,
    {StateData, UpdateAble} = lists:mapfoldl(F, false, Task#task.state_data),
    case UpdateAble of
        false ->
            false;
        true ->
            Task2 = Task#task{state_data = StateData},
            State = ?IF_ELSE(task:check_finish(Task2) == ok, ?TASK_ST_FINISH, Task#task.state),
            Task3 = Task2#task{state = State},
            task_init:update_one_task(Task3),
            Self = self(),
            if StateData == ?TASK_ST_FINISH ->
                spawn(fun() ->
                    util:sleep(1000),
                    task:refresh_client_task_one(Self, Task3) end);
                true ->
                    task:refresh_client_task_one(Self, Task3)
            end,
            true

    end.

%%更新任务事件内容

%%NPC对话
update({?TASK_ACT_NPC, MonId, TarNum, CurNum}, [NpcId]) ->
    case MonId =:= NpcId of
        false ->
            {{?TASK_ACT_NPC, MonId, TarNum, CurNum}, false};
        true ->
            case CurNum + 1 >= TarNum of
                true -> {{?TASK_ACT_NPC, MonId, TarNum, TarNum}, true};
                false -> {{?TASK_ACT_NPC, MonId, TarNum, CurNum + 1}, true}
            end
    end;
%%击杀怪物
update({?TASK_ACT_KILL, MonId, TarNum, CurNum}, [TarMonId]) ->
    case MonId =:= TarMonId of
        false ->
            {{?TASK_ACT_KILL, MonId, TarNum, CurNum}, false};
        true ->
            case CurNum + 1 >= TarNum of
                true -> {{?TASK_ACT_KILL, MonId, TarNum, TarNum}, true};
                false -> {{?TASK_ACT_KILL, MonId, TarNum, CurNum + 1}, true}
            end
    end;
%%击杀怪物2
update({?TASK_ACT_KILL, MonId, TarNum, CurNum}, [TarMonId, MonNum]) ->
    case MonId =:= TarMonId of
        false ->
            {{?TASK_ACT_KILL, MonId, TarNum, CurNum}, false};
        true ->
            case CurNum + MonNum >= TarNum of
                true -> {{?TASK_ACT_KILL, MonId, TarNum, TarNum}, true};
                false -> {{?TASK_ACT_KILL, MonId, TarNum, CurNum + MonNum}, true}
            end
    end;
%%采集物品
update({?TASK_ACT_COLLECT, MonId, TarNum, CurNum}, [TarMonId]) ->
    case MonId =:= TarMonId of
        false ->
            {{?TASK_ACT_COLLECT, MonId, TarNum, CurNum}, false};
        true ->
            case CurNum + 1 >= TarNum of
                true -> {{?TASK_ACT_COLLECT, MonId, TarNum, TarNum}, true};
                false -> {{?TASK_ACT_COLLECT, MonId, TarNum, CurNum + 1}, true}
            end
    end;
%%收集掉落物
update({?TASK_ACT_GOODS, TarGoodsId, TarNum, CurNum}, [GoodsId, Num]) ->
    case TarGoodsId == GoodsId of
        false ->
            {{?TASK_ACT_GOODS, TarGoodsId, TarNum, CurNum}, false};
        true ->
            case CurNum + Num >= TarNum of
                true ->
                    {{?TASK_ACT_GOODS, TarGoodsId, TarNum, TarNum}, true};
                false ->
                    {{?TASK_ACT_GOODS, TarGoodsId, TarNum, CurNum + Num}, true}
            end
    end;

%%通关副本
update({?TASK_ACT_DUNGEON, TarDunId, TarTimes, CurTimes}, [DunId, Times]) ->
    case TarDunId == DunId of
        false ->
            {{?TASK_ACT_DUNGEON, TarDunId, TarTimes, CurTimes}, false};
        true ->
            case CurTimes + Times >= TarTimes of
                true ->
                    {{?TASK_ACT_DUNGEON, TarDunId, TarTimes, TarTimes}, true};
                false ->
                    {{?TASK_ACT_DUNGEON, TarDunId, TarTimes, CurTimes + Times}, true}
            end
    end;

%%收集货币--瞬时
update({?TASK_ACT_MONEY, TarMoney, TarNum, CurNum}, [Money, Num]) ->
    case TarMoney == Money of
        false ->
            {{?TASK_ACT_MONEY, TarMoney, TarNum, CurNum}, false};
        true ->
            case Num >= TarNum of
                true ->
                    {{?TASK_ACT_MONEY, TarMoney, TarNum, TarNum}, true};
                false ->
                    {{?TASK_ACT_MONEY, TarMoney, TarNum, Num}, true}
            end
    end;
%%收集货币--累加
update({?TASK_ACT_ACC_MONEY, TarMoney, TarNum, CurNum}, [Money, Num]) ->
    case TarMoney == Money of
        false ->
            {{?TASK_ACT_ACC_MONEY, TarMoney, TarNum, CurNum}, false};
        true ->
            case CurNum + Num >= TarNum of
                true ->
                    {{?TASK_ACT_ACC_MONEY, TarMoney, TarNum, TarNum}, true};
                false ->
                    {{?TASK_ACT_ACC_MONEY, TarMoney, TarNum, CurNum + Num}, true}
            end
    end;
%%购买物品
update({?TASK_ACT_SHOP, TarGoodsId, TarNum, CurNum}, [GoodsId, Num]) ->
    case TarGoodsId == GoodsId of
        false ->
            {{?TASK_ACT_SHOP, TarGoodsId, TarNum, CurNum}, false};
        true ->
            case CurNum + Num >= TarNum of
                true ->
                    {{?TASK_ACT_SHOP, TarGoodsId, TarNum, TarNum}, true};
                false ->
                    {{?TASK_ACT_SHOP, TarGoodsId, TarNum, CurNum + Num}, true}
            end
    end;
%%指定时间登陆
update({?TASK_ACT_LOGIN, StartTime, EndTime, Times}, [Time]) ->
    case StartTime =< Time andalso EndTime >= Time of
        false ->
            {{?TASK_ACT_LOGIN, StartTime, EndTime, Times}, false};
        true ->
            {{?TASK_ACT_LOGIN, StartTime, EndTime, 1}, true}
    end;
%%收集指定宠物
update({?TASK_ACT_PET, TarPetId, TarNum, CurNum}, [PetId, Num]) ->
    case TarPetId == PetId of
        false ->
            {{?TASK_ACT_PET, TarPetId, TarNum, CurNum}, false};
        true ->
            case CurNum + Num >= TarNum of
                true ->
                    {{?TASK_ACT_PET, TarPetId, TarNum, TarNum}, true};
                false ->
                    {{?TASK_ACT_PET, TarPetId, TarNum, CurNum + Num}, true}
            end
    end;
%%参与活动
update({?TASK_ACT_ACTIVITY, TarType, TarTimes, CurTimes}, [Type, Times]) ->
    case TarType == Type of
        false ->
            {{?TASK_ACT_ACTIVITY, TarType, TarTimes, CurTimes}, false};
        true ->
            case CurTimes + Times >= TarTimes of
                true ->
                    {{?TASK_ACT_ACTIVITY, TarType, TarTimes, TarTimes}, true};
                false ->
                    {{?TASK_ACT_ACTIVITY, TarType, TarTimes, CurTimes + Times}, true}
            end
    end;
%%寻宝
update({?TASK_ACT_TREASURE, CurTimes, TarTimes, Param}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_TREASURE, TarTimes, TarTimes, Param}, true};
        false ->
            {{?TASK_ACT_TREASURE, CurTimes + Times, TarTimes, Param}, true}
    end;

update({?TASK_ACT_TREASURE_BY_ID, TarType, TarTimes, CurTimes}, [MapId, Times]) ->
    case TarType == MapId of
        false ->
            {{?TASK_ACT_TREASURE_BY_ID, TarType, TarTimes, CurTimes}, false};
        true ->
            case CurTimes + Times >= TarTimes of
                true ->
                    {{?TASK_ACT_TREASURE_BY_ID, TarType, TarTimes, TarTimes}, true};
                false ->
                    {{?TASK_ACT_TREASURE_BY_ID, TarType, TarTimes, CurTimes + Times}, true}
            end
    end;

%%升级
update({?TASK_ACT_UPLV, TarLv, _State, _CurLv}, [Lv]) ->
    case Lv >= TarLv of
        true ->
            {{?TASK_ACT_UPLV, TarLv, _State, _State}, true};
        false ->
            {{?TASK_ACT_UPLV, TarLv, _State, _CurLv}, false}
    end;


%%完成指定类型任务
update({?TASK_ACT_TASK_TYPE, TarType, TarTimes, CurTimes}, [TaskType, Times]) ->
    case TarType == TaskType of
        false ->
            {{?TASK_ACT_TASK_TYPE, TarType, TarTimes, CurTimes}, false};
        true ->
            case CurTimes + Times >= TarTimes of
                true ->
                    {{?TASK_ACT_TASK_TYPE, TarType, TarTimes, TarTimes}, true};
                false ->
                    {{?TASK_ACT_TASK_TYPE, TarType, TarTimes, CurTimes + Times}, true}
            end
    end;

%%装备强化
update({?TASK_ACT_STRENGTHEN, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_STRENGTHEN, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_STRENGTHEN, Param, TarTimes, CurTimes + Times}, true}
    end;

%%装备洗练
update({?TASK_ACT_WASH, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_WASH, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_WASH, Param, TarTimes, CurTimes + Times}, true}
    end;
%%镶嵌宝石
update({?TASK_ACT_STONE, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_STONE, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_STONE, Param, TarTimes, CurTimes + Times}, true}
    end;
%%坐骑装备穿戴
update({?TASK_ACT_MOUNT_EQUIP, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_MOUNT_EQUIP, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_MOUNT_EQUIP, Param, TarTimes, CurTimes + Times}, true}
    end;
%%坐骑装备强化
update({?TASK_ACT_MOUNT_EQUIP_STRENGTHEN, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_MOUNT_EQUIP_STRENGTHEN, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_MOUNT_EQUIP_STRENGTHEN, Param, TarTimes, CurTimes + Times}, true}
    end;
%%坐骑进阶
update({?TASK_ACT_MOUNT_STEP, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_MOUNT_STEP, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_MOUNT_STEP, Param, TarTimes, CurTimes + Times}, true}
    end;

%%战力跑分
update({?TASK_ACT_CBP_EVA, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_CBP_EVA, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_CBP_EVA, Param, TarTimes, CurTimes + Times}, true}
    end;
%%疯狂点击
update({?TASK_ACT_CLICK, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_CLICK, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_CLICK, Param, TarTimes, CurTimes + Times}, true}
    end;
update({?TASK_ACT_ARENA, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_ARENA, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_ARENA, Param, TarTimes, CurTimes + Times}, true}
    end;
%%击杀服务器玩家
update({?TASK_ACT_KMB, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_KMB, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_KMB, Param, TarTimes, CurTimes + Times}, true}
    end;
%%充值
update({?TASK_ACT_CHARGE, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_CHARGE, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_CHARGE, Param, TarTimes, CurTimes + Times}, true}
    end;

%%X件Y强化的装备
update({?TASK_ACT_EQUIP_STRENGTH, TarStrength, TarNum, CurNum}, [NowStrength, NowNum]) ->
    case TarStrength =:= NowStrength of
        false ->
            {{?TASK_ACT_EQUIP_STRENGTH, TarStrength, TarNum, CurNum}, false};
        true ->
            case NowNum >= TarNum of
                true -> {{?TASK_ACT_EQUIP_STRENGTH, TarStrength, TarNum, TarNum}, true};
                false -> {{?TASK_ACT_EQUIP_STRENGTH, TarStrength, TarNum, max(CurNum, NowNum)}, true}
            end
    end;
%%经验副本
update({?TASK_ACT_DUN_EXP, Param, TarTimes, _CurTimes}, [Times]) ->
    case Times >= TarTimes of
        true ->
            {{?TASK_ACT_DUN_EXP, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_DUN_EXP, Param, TarTimes, max(_CurTimes, Times)}, true}
    end;

%%计算等级怪
update({?TASK_ACT_MLV, TarLv, TarTimes, CurTimes}, [Mlv]) ->
    MaxLv = TarLv + 9,
    case Mlv >= TarLv andalso Mlv =< MaxLv of
        false ->
            {{?TASK_ACT_MLV, TarLv, TarTimes, CurTimes}, false};
        true ->
            case CurTimes + 1 >= TarTimes of
                true ->
                    {{?TASK_ACT_MLV, TarLv, TarTimes, TarTimes}, true};
                false ->
                    {{?TASK_ACT_MLV, TarLv, TarTimes, CurTimes + 1}, true}
            end
    end;
%%点金
update({?TASK_ACT_BET, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_BET, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_BET, Param, TarTimes, CurTimes + Times}, true}
    end;
%%宠物升阶
update({?TASK_ACT_PET_STAGE, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_PET_STAGE, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_PET_STAGE, Param, TarTimes, CurTimes + Times}, true}
    end;
update({?TASK_ACT_PET_STAR, Param, TarTimes, CurTimes}, [Times]) ->
    case CurTimes + Times >= TarTimes of
        true ->
            {{?TASK_ACT_PET_STAR, Param, TarTimes, TarTimes}, true};
        false ->
            {{?TASK_ACT_PET_STAR, Param, TarTimes, CurTimes + Times}, true}
    end;

update({?TASK_ACT_DUN_GOD_WEAPON, TarDunId, TarRound, _Param}, [DunId, Round]) ->
    case TarDunId == DunId of
        true ->
            if Round >= TarRound ->
                {{?TASK_ACT_DUN_GOD_WEAPON, TarDunId, TarRound, TarRound}, true};
                true ->
                    {{?TASK_ACT_DUN_GOD_WEAPON, TarDunId, TarRound, Round}, true}
            end;
        false ->
            {{?TASK_ACT_DUN_GOD_WEAPON, TarDunId, TarRound, _Param}, true}
    end;

%%收集物品
update({?TASK_ACT_GET_GOODS, TarGoodsId, TarNum, CurNum}, [GoodsId, Num]) ->
    case TarGoodsId == GoodsId of
        false ->
            {{?TASK_ACT_GET_GOODS, TarGoodsId, TarNum, CurNum}, false};
        true ->
            case Num >= TarNum of
                true ->
                    {{?TASK_ACT_GET_GOODS, TarGoodsId, TarNum, TarNum}, true};
                false ->
                    {{?TASK_ACT_GET_GOODS, TarGoodsId, TarNum, Num}, true}
            end
    end;

update(Action, _ParamList) ->
    ?ERR("task event update ~p undef ~p~n", [Action]),
    {Action, false}.
