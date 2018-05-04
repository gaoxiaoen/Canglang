%%----------------------------------------------------
%% 成就数据登录修正
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(achievement_revise).
-export([to_update_new/1]).

-include("common.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("condition.hrl").
-include("achievement.hrl").
-include("sns.hrl").
-include("task.hrl").
-include("guild.hrl").
-include("skill.hrl").
-include("channel.hrl").
-include("attr.hrl").
-include("pet.hrl").
-include("soul_world.hrl").

%% 每次登录 对单事件未完成目标或成就重置目标需求 以更新到最后需求事件 
to_update_new(Role = #role{achievement = Ach = #role_achievement{d_list = DList}}) ->
    NewList = to_update_new(Role, DList, []),
    Role#role{achievement = Ach#role_achievement{d_list = NewList}}.

to_update_new(_Role, [], L) -> L;
to_update_new(Role, [I = #achievement{id = Id, status = ?achievement_status_progress, progress = [Prog = #achievement_progress{cond_label = CLabel}]} | T], L) ->
    case achievement_data:get(Id) of
        {ok, #achievement_base{finish_cond = [#condition{label = CLabel, target = Target, target_ext = TargetExt, target_value = TargetVal}]}} ->
            NPorg = Prog#achievement_progress{target = Target, target_ext = TargetExt, target_value = TargetVal},
            NewI = check_status(I#achievement{progress = [NPorg]}, Role),
            to_update_new(Role, T, [NewI | L]);
         {ok, #achievement_base{finish_cond = [#condition{label = finish_task_type, target = Target, target_ext = TargetExt, target_value = TargetVal}]}} when CLabel =:= finish_task_kind -> %% 条件转换
            NPorg = Prog#achievement_progress{cond_label = finish_task_type, target = Target, target_ext = TargetExt, target_value = TargetVal},
            NewI = check_status(I#achievement{progress = [NPorg]}, Role),
            to_update_new(Role, T, [NewI | L]);
        {ok, #achievement_base{finish_cond = [#condition{label = CLabel1}]}} when CLabel =/= CLabel1 -> %% 条件变化 重接
            ?DEBUG("成就条件变化,丢弃重接:[~p]", [Id]),
            to_update_new(Role, T, L);
        {ok, _} ->
            NewI = check_status(I, Role),
            to_update_new(Role, T, [NewI | L]);
        _ ->
            ?DEBUG("成就条件基础数据已被删除，直接丢弃:[~p]", [Id]),
            to_update_new(Role, T, L)
    end;
to_update_new(Role, [I | T], L) ->
    to_update_new(Role, T, [I | L]).

%%---------------------------------------------------
%% 内部方法
%%---------------------------------------------------

check_status(Ach = #achievement{id = AID, status = ?achievement_status_progress, progress = Progs}, Role) ->
    NewProgs = [check_progress_status(AID, Prog, Role) || Prog <- Progs],
     {FT, Status} = case [P || P <- NewProgs, P#achievement_progress.status =:= 0] of %% 判断条件是否已完成
         [] -> {util:unixtime(), 1};
         _ -> {0, 0}
     end,
    Ach#achievement{progress = NewProgs, status = Status, finish_time = FT};
check_status(Ach, _Role) -> Ach. %% 容错

%%----------------------------------------
%% 判断进度
%%---------------------------------------

%% 判断角色是否已入帮
check_progress_status(_AID, Prog = #achievement_progress{cond_label = special_event, target = 20001, status = 0}, #role{guild = #role_guild{gid = Gid}}) ->
    Status = case Gid =/= 0 of
        true -> 1;
        false -> 0
    end,
    Prog#achievement_progress{status = Status, value = Status};

%% 判断角色等级
check_progress_status(_AID, Prog = #achievement_progress{cond_label = lev, status = 0, target_value = NeedLev}, #role{lev = Lev}) when Lev >= NeedLev ->
    Prog#achievement_progress{status = 1, value = Lev};

%% 对目标 封印蛟妖 特殊处理
check_progress_status(_AID, Prog = #achievement_progress{cond_label = kill_npc, target = 30005, status = 0}, #role{lev = Lev}) ->
    Status = case Lev >= 30 of
        true -> 1;
        false -> 0
    end,
    Prog#achievement_progress{status = Status, value = Status};

%% 元神修炼升级 将任意N个元神修炼到X级
check_progress_status(_AID, Prog = #achievement_progress{cond_label = special_event, target = 1004, status = 0, target_ext = TargetExt, target_value = TargetVal}, #role{channels = #channels{list = Channels}}) when is_integer(TargetExt) ->
    L = [Channel || Channel <- Channels, Channel#role_channel.lev >= TargetExt],
    {Status, Val} = status(length(L), TargetVal),
    Prog#achievement_progress{status = Status, value = Val};

%% 元神境界提升 将任意N个元神境界提升到X级
check_progress_status(_AID, Prog = #achievement_progress{cond_label = special_event, target = 20012, status = 0, target_ext = TargetExt, target_value = TargetVal}, #role{channels = #channels{list = Channels}}) when is_integer(TargetExt) ->
    L = [Channel || Channel <- Channels, Channel#role_channel.state >= TargetExt * 10],
    {Status, Val} = status(length(L), TargetVal),
    Prog#achievement_progress{status = Status, value = Val};

%% 技能变化 N个技能修炼至X级
check_progress_status(_AID, Prog = #achievement_progress{cond_label = special_event, target = 20013, status = 0, target_ext = TargetExt, target_value = TargetVal}, Role) when is_integer(TargetExt) ->
    Skills = skill:calc_result_skill(Role),
    L = [Skill || Skill <- Skills, (Skill#skill.type =:= ?type_active orelse Skill#skill.type =:= ?type_passive), Skill#skill.lev >= TargetExt],
    {Status, Val} = status(length(L), TargetVal),
    Prog#achievement_progress{status = Status, value = Val};

%% 神魔阵等级同步
check_progress_status(_AID, Prog = #achievement_progress{cond_label = special_event, target = 20027, status = 0, target_value = TargetVal, value = OldVal}, #role{soul_world = #soul_world{array_lev = NewVal}}) when NewVal > OldVal ->
    {Status, Val} = status(NewVal, TargetVal),
    Prog#achievement_progress{status = Status, value = Val};

%% 巡狩四方
check_progress_status(90303, Prog = #achievement_progress{cond_label = kill_npc, status = 0}, #role{lev = RoleLev}) when RoleLev >= 70 ->
    Prog#achievement_progress{status = 1, value = 1};

%% 金币值
check_progress_status(_AID, Prog = #achievement_progress{cond_label = coin, status = 0, target_value = TargetVal, value = OldVal}, #role{assets = #assets{coin = Coin, coin_bind = CoinBind}}) when Coin + CoinBind > OldVal ->
    {Status, Val} = status(Coin + CoinBind, TargetVal),
    Prog#achievement_progress{status = Status, value = Val};

check_progress_status(_AID, Prog, _Role) -> Prog. %% 容错

%% 根据当前值与目标值作状态判断
status(Value, TargetVal) ->
    case Value >= TargetVal of
        true -> {1, TargetVal};
        false -> {0, Value}
    end.
