%%----------------------------------------------------
%%  条件检查接口
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(role_cond).
-export([
        check/2
    ]
).

-include("common.hrl").
-include("condition.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("vip.hrl").
-include("activity.hrl").
-include("task.hrl").
-include("guild.hrl").
-include("attr.hrl").
%%

-define(RTN(Cond, Result, Msg),
    case Result of
        true -> true;
        false ->
            case Cond#condition.msg =:= <<>> of
                true -> {false, Cond#condition{msg = Msg}};
                false -> {false, Cond}
            end
    end
).

%% 执行列表中的所有判定
%% 当所有判定均为true时返回true，否则返回引起失败的判定条件
%% @spec check(CondList, Role) -> true | {false, Cond}
%% CondList = [#condition{} | ...] 条件列表
%% Role = #role{} 角色数据
%% Cond = #condition{} 引起失败的判定条件
check([], _Role) -> true;
check([C | T], Role) ->
    case check(C, Role) of
        true -> check(T, Role);
        {false, Cond} -> {false, Cond}
    end;

%% 02 use_item
%% 要求用掉指定的物品N个
check(Cond = #condition{label = use_item}, _Role) ->
    %% TODO:判断角色是否拥有N个物品
    ?RTN(Cond, true, ?L(<<"物品不足">>));

%% 要求角色是飞行状态
check(Cond = #condition{label = fly}, #role{ride = Ride}) ->
    ?RTN(Cond, Ride =:= ?ride_fly, ?L(<<"角色当前不在飞行状态">>));

%% 04 vip
%% 检查VIP状态
check(Cond = #condition{label = vip, target_value = Val}, #role{vip = #vip{expire = Expire}}) ->
    ?RTN(Cond, util:bool2int(util:unixtime() > Expire) =:= Val, ?L(<<"当前Vip状态不允许此操作">>));

%% 05 get_task
%% 是否已经接下了指定的任务
check(Cond = #condition{label = get_task, target = TaskId}, #role{task = TaskList}) ->
    V = case lists:keyfind(TaskId, 2, TaskList) of
        false -> false;
        _ -> true
    end,
    ?RTN(Cond, V, ?L(<<"没有接受任务">>));

%% 是否已经接下了指定的任务的其中一个 
check(Cond = #condition{label = get_any_task, target = TaskIds}, #role{task = TaskList}) ->
    V = case [TaskId || TaskId <- TaskIds, lists:keyfind(TaskId, 2, TaskList) =/= false] of
        [] -> false;
        _ -> true
    end,
    ?RTN(Cond, V, ?L(<<"没有接受任务">>));

%% 06 finish_task
%% 要求完成指定的任务N次
check(Cond = #condition{label = finish_task, target = Target, target_value = TargetVal}, #role{id = {_RoleId, _SrvId}}) ->
    Task = task_data:get_conf(Target),
    case Task of
        #task_base{type = Type} ->
            case lists:member(Type, [1, 2]) of
                true ->
                    case task:get_count(log, Target) > TargetVal of
                        true -> true;
                        false -> ?RTN(Cond, false, <<>>)
                    end;
                false ->
                    case task:get_count(log_daily, Target) > TargetVal of
                        true -> true;
                        false -> ?RTN(Cond, false, <<>>)
                    end
            end;
        {false, _Reason} ->
            ?RTN(Cond, false, <<>>)
    end;

%% 07 coin
%% 判定金币是否大于或等于指定值
check(Cond = #condition{label = coin, target_value = Val}, #role{assets = #assets{coin = Coin}}) ->
    ?RTN(Cond, Coin >= Val, ?L(<<"金币不足">>));

%% 08 get_coin
%% 此判定永远返回false，在此只是占位
check(Cond = #condition{label = get_coin}, _Role) ->
    ?RTN(Cond, false, <<>>);

%% 10 lev
%% 判定是否大于或等于指定等级
check(Cond = #condition{label = lev, target_value = Val}, #role{lev = Lev}) ->
    ?RTN(Cond, Lev >= Val, ?L(<<"您的等级不够">>));

%% 10 lev
%% 判定是否小于或等于指定等级
check(Cond = #condition{label = lev_less, target_value = Val}, #role{lev = Lev}) ->
    ?RTN(Cond, Lev =< Val, ?L(<<"您的等级过高">>));

%% 11 make_friend
%% 要求添加N个好友
check(Cond = #condition{label = make_friend, target_value = _Val}, #role{lev = _Lev}) ->
    ?RTN(Cond, false, ?L(<<"您添加的好友人数不足">>));

%% 12 has_friend
%% 要求有N个好友
check(Cond = #condition{label = has_friend}, _Role) ->
    %% TODO:判断角色是否拥有N个好友
    ?RTN(Cond, true, ?L(<<"您拥有的好友人数不足">>));

%% 13 in_team
%% 要求当前队伍大于N个队友
check(Cond = #condition{label = in_team}, _Role) ->
    %% TODO:判断当前队伍大于N个队友
    ?RTN(Cond, true, ?L(<<"队伍人员不足">>));

%% 14 sex
%% 要求为指定性别
check(Cond = #condition{label = sex, target_value = TargetVal}, #role{sex = Sex}) ->
    ?RTN(Cond, TargetVal =:= Sex, ?L(<<"您的性别不满足条件">>));

%% 15 career
%% 要求为指定职业
check(Cond = #condition{label = career, target_value = TargetVal}, #role{career = Career}) ->
    case TargetVal =:= 9 of %%不限职业
        true ->
            ?RTN(Cond, true, <<>>);
        false ->
            ?RTN(Cond, TargetVal =:= Career, ?L(<<"您的职业不满足条件">>))
    end;

%% 要求为指定 进阶职业
check(Cond = #condition{label = career_ascend, target_value = TargetVal}, Role = #role{career = Career}) ->
    case TargetVal =:= 9 of %%不限职业
        true ->
            ?RTN(Cond, ascend:check_is_ascend(Role), ?L(<<"您的职业不满足条件">>));
        false ->
            ?RTN(Cond, lists:member({Career, ascend:get_ascend(Role)}, TargetVal), ?L(<<"您的职业不满足条件">>))
    end;

%% 16 attainment
%% 要求阅历值达到多少
check(Cond = #condition{label = attainment, target_value = TargetVal}, #role{assets = #assets{attainment = Att}}) ->
    ?RTN(Cond, TargetVal =< Att, ?L(<<"您的阅历值不足">>));

%% 检查是否已经拥有了某物品
check(Cond = #condition{label = has_item, target = ItemBaseId, target_value = Val}, #role{bag = Bag}) ->
    ?RTN(Cond, storage:count(Bag, ItemBaseId) >= Val, <<>>);

%% TODO:是否击杀了指定的NPC
check(Cond = #condition{label = killed_npc}, _Role) ->
    ?RTN(Cond, false, <<>>);

%% 角色活动状态限制 
check(Cond = #condition{label = event,  target = EventIds, target_value = TargetVal}, _Role = #role{event = RoleEventId}) when is_list(EventIds) ->
    Rtn = case {TargetVal =:= 1, lists:member(RoleEventId, EventIds)} of
        {true, true}  -> true;
        {true, false} -> false;
        {false, true} -> false;
        {false, false} -> true
    end,
    case RoleEventId of
        ?event_arena_match -> ?RTN(Cond, Rtn, ?L(<<"仙法竞技中不能使用非战斗药品">>));
        ?event_guild_arena -> ?RTN(Cond, Rtn, ?L(<<"帮战中不能使用非战斗药品">>));
        ?event_cross_king_match -> ?RTN(Cond, Rtn, ?L(<<"至尊王者赛中不能使用非战斗药品">>));
        _ -> ?RTN(Cond, Rtn, ?L(<<"当前状态下不能使用此物品">>))
    end;


%% 角色活动状态限制 
check(Cond = #condition{label = event,  target = EventId, target_value = TargetVal}, _Role = #role{event = RoleEventId}) ->
    Rtn = case {TargetVal =:= 1, EventId =:= RoleEventId} of
        {true, true}  -> true;
        {true, false} -> false;
        {false, true} -> false;
        {false, false} -> true
    end,
    case RoleEventId of
        ?event_arena_match -> ?RTN(Cond, Rtn, ?L(<<"仙法竞技中不能使用非战斗药品">>));
        ?event_guild_arena -> ?RTN(Cond, Rtn, ?L(<<"帮战中不能使用非战斗药品">>));
        ?event_cross_king_match -> ?RTN(Cond, Rtn, ?L(<<"至尊王者赛中不能使用非战斗药品">>));
        _ -> ?RTN(Cond, Rtn, ?L(<<"当前状态下不能使用此物品">>))
    end;

%% 副本进入次数限制
check(Cond = #condition{label = dun_count, target_value = _TargetVal, target = Target}, _Role = #role{dungeon = RoleDungeons}) ->
    case dungeon_type:get_left_count(Target, RoleDungeons) of
        0 ->
            ?RTN(Cond, false, ?L(<<"已达次数上限">>));
        _ ->
            ?RTN(Cond, true, <<>>)
    end;

%% 试练进入次数限制
check(Cond = #condition{label = practice_count, target_value = TargetVal}, Role) ->
    EnterCount = practice_mgr:get_enter_count(Role),
    ?RTN(Cond, EnterCount < TargetVal, ?L(<<"您今天进入试练的次数已满">>));

%% 精力值
check(Cond = #condition{label = energy, target_value = TargetVal}, #role{assets = #assets{energy = Att}}) ->
    ?RTN(Cond, TargetVal =< Att, ?L(<<"您的精力值不足">>));

%% 活跃度
check(Cond = #condition{label = activity, target_value = TargetVal}, #role{activity = #activity{summary = Summary}}) ->
    ?RTN(Cond, TargetVal =< Summary, ?L(<<"您的精力值不足">>));

%% 是否为帮主
check(Cond = #condition{label = chief}, #role{guild = #role_guild{authority = ?chief_op}}) ->
    ?RTN(Cond, true, <<>>);

check(Cond = #condition{label = chief}, #role{guild = #role_guild{authority = ?elder_op}}) ->
    ?RTN(Cond, false, ?L(<<"你准备谋朝夺位么？还是坐回你的长老座吧！">>));

check(Cond = #condition{label = chief}, #role{guild = #role_guild{authority = ?lord_op}}) ->
    ?RTN(Cond, false, ?L(<<"小小堂主，岂能以下犯上，还是坐回您的堂主座吧！">>));

check(Cond = #condition{label = chief}, _Role) ->
    ?RTN(Cond, false, ?L(<<"莫非你一个弟子要起义造反？帮主专属宝座不容侵犯！">>));

%% 是否为长老
check(Cond = #condition{label = elder}, #role{guild = #role_guild{authority = ?chief_op}}) ->
    ?RTN(Cond, false, ?L(<<"尊贵的帮主大人，请坐回您的专属宝座！">>));

check(Cond = #condition{label = elder}, #role{guild = #role_guild{authority = ?elder_op}}) ->
    ?RTN(Cond, true, <<>>);

check(Cond = #condition{label = elder}, #role{guild = #role_guild{authority = ?lord_op}}) ->
    ?RTN(Cond, false, ?L(<<"再努力一点，你就能晋升长老了。">>));

check(Cond = #condition{label = elder}, _Role) ->
    ?RTN(Cond, false, ?L(<<"不想当长老的弟子不是好弟子。努力为帮会做贡献，将来才有机会坐上宝座！">>));

%% 是否为堂主
check(Cond = #condition{label = lord}, #role{guild = #role_guild{authority = ?chief_op}}) ->
    ?RTN(Cond, false, ?L(<<"尊贵的帮主大人，请坐回您的专属宝座！">>));

check(Cond = #condition{label = lord}, #role{guild = #role_guild{authority = ?elder_op}}) ->
    ?RTN(Cond, false, ?L(<<"贵为长老，还是坐回您的长老宝座吧！">>));

check(Cond = #condition{label = lord}, #role{guild = #role_guild{authority = ?lord_op}}) ->
    ?RTN(Cond, true, <<>>);

check(Cond = #condition{label = lord}, _Role) ->
    ?RTN(Cond, false, ?L(<<"努力为帮会贡献，将来你就有机会坐上堂主宝座了。">>));

%% 角色是否在帮会领地
check(Cond = #condition{label = event_guild}, #role{event = Event}) ->
    ?RTN(Cond, Event =:= ?event_guild, <<>>);

%% 判断开始时间
check(Cond = #condition{label = start_time, target_value = Val}, _Role) ->
    ?RTN(Cond, util:unixtime() >= Val, <<>>);

%% 判断结束时间
check(Cond = #condition{label = end_time, target_value = Val}, _Role) ->
    ?RTN(Cond, Val >= util:unixtime(), <<>>);

%% 判定战力
check(Cond = #condition{label = fight_capacity, target_value = Val}, #role{attr = #attr{fight_capacity = FightCapacity}}) ->
    ?RTN(Cond, FightCapacity >= Val, ?L(<<"您的战斗力不够">>));

%% 判定晶钻是否大于或等于指定值
check(Cond = #condition{label = gold, target_value = Val}, #role{assets = #assets{gold = Gold}}) ->
    ?RTN(Cond, Gold >= Val, ?L(<<"晶钻不足">>));

%% 容错处理
check(Cond, _Role) ->
    ?ELOG("不支持的判定条件: ~w", [Cond]),
    ?RTN(Cond, false, ?L(<<"不支持的判定条件">>)).
