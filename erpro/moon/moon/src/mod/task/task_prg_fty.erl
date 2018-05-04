%%----------------------------------------------------
%% Author: yqhuang(QQ:19123767)
%% Created: 2011-8-3
%% Description: 任务进度工厂
%%----------------------------------------------------
-module(task_prg_fty).

-include("common.hrl").
-include("task.hrl").
-include("role.hrl").
-include("vip.hrl").
-include("assets.hrl").
-include("condition.hrl").
-include("sns.hrl").
-include("activity.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("guild.hrl").
-include("channel.hrl").
-include("skill.hrl").
-include("attr.hrl").
-include("soul_world.hrl").
-include("dungeon.hrl").

-export([
        create/2
        ,create/3
        ,get_trg_label/1
    ]
).

%% 根据#role状态有#condition{}创建任务进度信息
%% @spec create(Id, Cond, Role) -> NewPrg
%% Id = integer() 触发器返回的ID,也就是进度的ID
%% Cond = #task_cond{} 条件
%% Role = #role{} 角色信息
%% NewPrg = #task_progress{} 新的任务信息
%% 如跟角色状态无关，直接生成进度信息
%% 如跟角色状态相关，先进行判断再生成进度信息

%% 要求获得指定的物品N个
create(Id, Cond = #task_cond{label = get_item}, _Role) ->
    create(Id, Cond);

%% 要求用掉指定的物品N个
create(Id, Cond = #task_cond{label = use_item}, _Role) ->
    create(Id, Cond);

%% 要求杀死指定的NPC N次
create(Id, Cond = #task_cond{label = kill_npc}, _Role) ->
    create(Id, Cond);

%% 要求VIP状态为指定状态 0:非VIP 1:是VIP
create(Id, #task_cond{label = vip, target = Target, target_value = TrgVal, map_id = MapId}, Role) ->
    CLabel = vip,
    TrgLabel = get_trg_label(CLabel),
    ?DEBUG("role vip:~w", [Role#role.vip]),
    #vip{expire = Expire} = Role#role.vip,
    NewVal = 
        case util:unixtime() < Expire of
            true -> 1;
            false -> 0
        end,
    Status = satatus(TrgVal, NewVal),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = TrgVal, value = NewVal, status = Status, map_id = MapId};


%% 要求已接下指定的任务
create(Id, #task_cond{label = get_task, target = Target, target_value = TaskId}, Role) ->
    CLabel = get_task,
    TrgLabel = get_trg_label(CLabel),
    Tasks = [Tsk || Tsk <- Role#role.task, Tsk#task.task_id =:= TaskId],
    NewVal =
        case length(Tasks) > 0 of
            true -> TaskId;
            false -> 0
        end,
    Status = satatus(TaskId, NewVal),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = TaskId, value = NewVal, status = Status};

%% 要求完成指定的任务N次
create(Id, #task_cond{label = finish_task, target = TaskId, target_value = Num}, #role{id = {_RoleId, _SrvId}}) ->
    CLabel = finish_task,
    TrgLabel = get_trg_label(CLabel),
    Task = task_data:get_conf(TaskId),
    NewVal =
        case Task of
            #task_base{type = Type} ->
                case lists:member(Type, [1, 2]) of
                    true ->
                        case task:get_count(log, TaskId) >= Num of
                            true -> Num;
                            false -> 0
                        end;
                    false ->
                        case task:get_count(log_daily, TaskId) >= Num of
                            true -> Num;
                            false -> 0
                        end
                end;
            {false, _Reason} ->
                ?ELOG("未定义任务TaskId:~s", [TaskId]),
                0
        end,
    Status = satatus(Num, NewVal),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = TaskId, target_value = TaskId, value = NewVal, status = Status};

%% 要求金币大于或等于指定值
create(Id, #task_cond{label = coin, target = Target, target_value = Num}, #role{assets = #assets{coin = Coin}}) ->
    CLabel = coin,
    TrgLabel = get_trg_label(CLabel),
    NewVal =
        case Coin >= Num of
            true -> Num;
            false -> Coin
        end,
    Status = satatus(Num, NewVal),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Num, value = NewVal, status = Status};

%% 要求得到金币大于或等于指定值
create(Id, Cond = #task_cond{label = get_coin}, _Role) ->
    create(Id, Cond);

%% 要求等级大于或等于指定值
create(Id, #task_cond{label = lev, target = Target, target_value = Lev}, #role{lev = RLev}) ->
    CLabel = lev,
    TrgLabel = get_trg_label(CLabel),
    NewVal =
        case RLev >= Lev of
            true -> Lev;
            false -> RLev
        end,
    Status = satatus(Lev, NewVal),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Lev, value = NewVal, status = Status};

%% 要求杀死NpcId列表随机一种怪物，N次
create(Id, #task_cond{label = kill_npc_random, target = Target, target_value = Val, map_id = MapId}, _Role) ->
    CLabel = kill_npc, %% 使用kill_npc逻辑
    TrgLabel = get_trg_label(CLabel),
    NewTrg = lists:nth(random:uniform(length(Target)), Target),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = NewTrg, target_value = Val, value = 0, map_id = MapId};

%% 要求获得物品列表随机一种物品N个
create(Id, #task_cond{label = get_item_random, target = Target, target_value = Val, map_id = MapId}, _Role) ->
    CLabel = get_item, %% 使用get_item逻辑
    TrgLabel = get_trg_label(CLabel),
    NewTrg = lists:nth(random:uniform(length(Target)), Target),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = NewTrg, target_value = Val, value = 0, map_id = MapId};

%% 要求向商店购买N个指定物品
create(Id, #task_cond{label = buy_item_store, target = Target, target_value = Val, map_id = MapId}, _Role) ->
    CLabel = buy_item_store,
    TrgLabel = get_trg_label(CLabel),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = 0, map_id = MapId, status = 0};

%% 要求向商店购买N个指定物品
create(Id, #task_cond{label = buy_item_shop, target = Target, target_value = Val, map_id = MapId}, _Role) ->
    CLabel = buy_item_shop,
    TrgLabel = get_trg_label(CLabel),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = 0, map_id = MapId, status = 0};

%% 特殊任务 使用选定
create(Id, #task_cond{label = special_event, target = Key, target_value = TargetVal, map_id = MapId}, Role) ->
    CLabel = special_event,
    TrgLabel = get_trg_label(CLabel),
    NewVal = init_target(Key, Role, TargetVal),
    Status = satatus(TargetVal, NewVal),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Key, target_value = NewVal, value = NewVal, map_id = MapId, status = Status};
    
%% 添加N个好友
create(Id, #task_cond{label = make_friend, target = Target, target_value = TargetValue}, _Role) ->
    CLabel = make_friend,
    TrgLabel = get_trg_label(make_friend),
    FriendList = friend:get_friend_list(),
    FriendHy = [Friend || Friend = #friend{type = Type} <- FriendList, Type =:= ?sns_friend_type_hy],
    NewVal = case length(FriendHy) >= TargetValue of
        true -> TargetValue;
        false -> length(FriendHy)
    end,
    Status = satatus(TargetValue, NewVal),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = TargetValue, value = NewVal, status = Status};

%% 活跃度
create(Id, #task_cond{label = activity, target_value = TargetValue}, #role{activity = #activity{summary = Summary}}) ->
    CLabel = activity,
    TrgLabel = get_trg_label(activity),
    {Status, NewVal} = case Summary >= TargetValue of
        true -> {1, TargetValue};
        false -> {0, Summary}
    end,
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target_value = TargetValue, value = NewVal, status = Status};

%% 拥有N个物品 
create(Id, #task_cond{label = has_item, target = ItemBaseId, target_value = Quantity, map_id = MapId}, #role{bag = #bag{items = Items}, task_bag = #task_bag{items = TaskItems}}) ->
    CLabel = get_item, %% 使用get_item逻辑
    TrgLabel = get_trg_label(CLabel),
    Val = case storage:find(Items, #item.base_id, ItemBaseId) of
        {ok, Num, _, _, _} when Num > Quantity -> Quantity;
        {ok, Num, _, _, _}  -> Num;
        _ -> 0
    end,
    NewVal = case Val > 0 of
        true -> Val;
        false ->
            case storage:find(TaskItems, #item.base_id, ItemBaseId) of
                {ok, CNum, _, _, _} when CNum > Quantity -> Quantity;
                {ok, CNum, _, _, _}  -> CNum;
                _ -> 0
            end
    end,
    Status = satatus(Quantity, NewVal),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = ItemBaseId, target_value = Quantity, value = Val, status = Status, map_id = MapId};

%% 要求扫荡副本N次
create(Id, #task_cond{label = sweep_dungeon, target = Target, target_value = Val, map_id = MapId}, _Role) ->
    CLabel = sweep_dungeon,
    TrgLabel = get_trg_label(CLabel),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = 0, status = 0, map_id = MapId};

%% 通关休闲副本
create(Id, #task_cond{label = ease_dungeon, target = Target, target_value = Val, map_id = MapId}, _Role) ->
    CLabel = ease_dungeon,
    TrgLabel = get_trg_label(CLabel),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = 0, status = 0, map_id = MapId};

%% 是否通关副本
create(Id, #task_cond{label = once_dungeon, target = Target, target_value = Val, map_id = MapId}, #role{dungeon = RoleDungeons}) ->
    CLabel = once_dungeon,
    TrgLabel = get_trg_label(CLabel),
    case lists:keyfind(Target, #role_dungeon.id, RoleDungeons) of
        #role_dungeon{clear_count = N} when N > 0 ->
            #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = 0, status = 1, map_id = MapId};
        _ ->
            #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = 0, status = 0, map_id = MapId}
    end;

%% 星级通关副本
create(Id, #task_cond{label = star_dungeon, target = Target = {DungeonId, NeedStar}, target_value = Val, map_id = MapId}, #role{dungeon = RoleDungeons}) ->
    CLabel = star_dungeon,
    TrgLabel = get_trg_label(CLabel),
    case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        #role_dungeon{best_star = BestStar, clear_count = ClearCount} when ClearCount >= Val, BestStar >= NeedStar ->
            #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = Val, status = 1, map_id = MapId};
        #role_dungeon{best_star = BestStar, clear_count = ClearCount} when BestStar >= NeedStar ->
            #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = ClearCount, status = 0, map_id = MapId};
        _ ->
            #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = 0, status = 0, map_id = MapId}
    end;

%% 占位函数
create(Id, #task_cond{label = CLabel, target = Target, target_value = Val, map_id = MapId}, _Role) ->
    TrgLabel = get_trg_label(CLabel),
    ?ELOG("没有匹配的进度信息:Id:~w, TrgLabel:~w, CLabel:~w", [Id, TrgLabel, CLabel]),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = 0, map_id = MapId}.


%%----------------------------------------------------
%% create/5 end.
%%----------------------------------------------------

%% 跟角色状态无关，直接生成进度信息
create(Id, #task_cond{label = CLabel, target = Target, target_value = Val, map_id = MapId}) ->
    TrgLabel = get_trg_label(CLabel),
    #task_progress{id = Id, code = get_code(CLabel), trg_label = TrgLabel, cond_label= CLabel, target = Target, target_value = Val, value = 0, map_id = MapId};

create(_Id, BadMatch) ->
    ?ELOG("创建进度信息出错，没有找到匹配的方法:~s", [BadMatch]).

%% 获得触发器标签
%% @spec get_trg_label(CLabel) -> TLabel
%% CLabel = term() 条件标签
%% TLabel = term() 触发器标签
get_trg_label(CLabel) ->
    case task_util:cond_trg_mapping(CLabel) of
        false ->
            ?ELOG("没有找到匹配的触发器标签:~w", [CLabel]),
            CLabel;
        TrgLabel ->
            TrgLabel
    end.

%% 获取状态值
%% @spec satatus(TrgVal, Val) -> Status
%% TrgVal = integer() 目标值
%% Val = integer() 当前值
%% Status = integer() 状态值 (0:未完成, 1:已完成)
satatus(TrgVal, Val) ->
    case TrgVal =:= Val of
        true -> 1;
        false -> 0
    end.

get_code(Label) ->
    task_util:get_cond_code(Label).

%% 特殊事件初始值判断
%% 强化
init_target(1002, _Role, 2) -> 0;
init_target(1002, _Role = #role{eqm = ItemList, bag = #bag{items = BagItemList}}, TargetVal) ->
    case is_enchant(ItemList ++ BagItemList) of
        true -> TargetVal;
        false -> 0
    end;
init_target(1008, _Role, TargetVal) -> TargetVal; %% 运镖
init_target(1012, _Role, TargetVal) -> TargetVal; %% 与NPC战斗
%% 洗炼
init_target(1013, _Role, 2) -> 0;
init_target(1013, _Role = #role{eqm = ItemList, bag = #bag{items = BagItemList}}, TargetVal) ->
    case is_polish(ItemList ++ BagItemList) of
        true -> TargetVal;
        false -> 0
    end;
init_target(1014, _Role = #role{guild = #role_guild{gid = GuildId}}, TargetVal) -> %% 加入帮会
    case GuildId of
        0 -> 0;
        _ -> TargetVal
    end;
init_target(1017, _Role = #role{dungeon = Dungeon}, TargetVal) -> %% 青松峰副本
    case lists:keyfind(10001, 1, Dungeon) of
        {_, Count, _} when Count >= 2 -> TargetVal;
        _ -> 0
    end;
init_target(1018, _Role = #role{channels = #channels{list = Channels}}, TargetVal) -> %% 元神境界
    case channels_done(Channels) of
        true -> TargetVal;
        false -> 0
    end;
init_target(1019, _Role = #role{skill = #skill_all{skill_list = SkillList}}, TargetVal) -> %% 元神境界
    case is_learn(SkillList) of
        true -> TargetVal;
        false -> 0
    end;
init_target(1024, _Role, TargetVal) -> TargetVal; %% 护送小屁孩

%% 战斗力
init_target(1025, _Role = #role{attr = #attr{fight_capacity = Fight}}, TargetVal) ->
    case Fight >= TargetVal of
        true -> TargetVal;
        false -> Fight
    end;

%% 紫装
init_target(1027, _Role = #role{eqm = ItemList}, TargetVal) ->
    case is_purple(ItemList) of
        true -> TargetVal;
        false -> 0
    end;
%% 橙装
init_target(1029, _Role = #role{eqm = ItemList}, TargetVal) ->
    case is_orange(ItemList) of
        true -> TargetVal;
        false -> 0
    end;
%% 灭除心魔
init_target(1051, _Role, TargetVal) -> TargetVal;
%% 唤醒妖灵
init_target(1061, #role{soul_world = #soul_world{spirit_num = SpiritNum}}, TargetVal) -> 
    min(SpiritNum, TargetVal);
%% 封印妖灵
init_target(1062, #role{soul_world = #soul_world{arrays = Arrays}}, TargetVal) -> 
    case [SpId || #soul_world_array{spirit_id = SpId} <- Arrays, SpId =/= 0] of
        [] -> 0;
        Sealed -> min(length(Sealed), TargetVal)
    end;
%% 提升妖灵法宝
init_target(1063, #role{soul_world = #soul_world{spirits = Spirits}}, TargetVal) -> 
    case [Sp || Sp = #soul_world_spirit{magics = [#soul_world_spirit_magic{lev = Lev1}, #soul_world_spirit_magic{lev = Lev2}]} <- Spirits, Lev1 > 1 orelse Lev2 > 1] of
        [] -> 0;
        _ -> TargetVal
    end;
%% 职业进阶
init_target(1064, Role, TargetVal) -> 
    case ascend:get_ascend(Role) of
        0 -> 0;
        _ -> TargetVal
    end;

%% 开信任务
init_target(1065, #role{id = {_RoleId, _SrvId}}, TargetVal) -> TargetVal;

init_target(EventId, #role{id = {_RoleId, _SrvId}, career = Career}, TargetVal) when EventId =:= 1069  ->
    case lists:keyfind(Career, 1, TargetVal) of
        false ->
            ?DEBUG("错误的装备..."),
            0;
         {_Career, [ItemBaseId, _Bind, _Quantity]}->
            ItemBaseId
    end;

init_target(_Target, _Role, _TargetVal) -> 0.

%% 是否强化过
is_enchant([#item{enchant = Enchant} | _T]) when Enchant > 0 -> true;
is_enchant([_Item | T]) -> is_enchant(T);
is_enchant([]) -> false.

%% 是否洗炼过
is_polish([#item{attr = AttrList} | T]) ->
    case flag_is_rank(AttrList) of
        true -> true;
        false -> is_polish(T)
    end;
is_polish([_Item | T]) -> is_polish(T);
is_polish([]) -> false.

%% 紫橙装
is_purple([]) -> false;
is_purple([#item{require_lev = Lev} | T]) when Lev < 40 -> is_purple(T);
is_purple([#item{quality = ?quality_purple} | _T]) -> true;
is_purple([#item{quality = ?quality_orange} | _T]) -> true;
is_purple([_Item | T]) -> is_purple(T).

%% 橙装
is_orange([]) -> false;
is_orange([#item{quality = ?quality_orange} | _T]) -> true;
is_orange([_Item | T]) -> is_orange(T).

flag_is_rank([{_Label, Flag, _Value} | _T]) when Flag > 1000 andalso Flag < 10100 -> true;
flag_is_rank([_A | T]) -> flag_is_rank(T);
flag_is_rank([]) -> false.

channels_done([#role_channel{state = State} | _T]) when State > 0 -> true;
channels_done([_C | T]) -> channels_done(T);
channels_done([]) -> false.

is_learn([]) -> false;
is_learn([#skill{lev = Lev, cond_lev = CondLev, type = Type} | _T]) when Lev > 0 andalso CondLev >= 30 andalso (Type =:= 0 orelse Type =:= 1) -> true;
is_learn([_Skill | T]) -> is_learn(T).
