%%----------------------------------------------------
%% 日常目标
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-module(achievement_everyday).
-export([
        login/1
        ,reset/1
        ,lev_up/1
        ,reward/1
    ]
).
-include("common.hrl").
-include("role.hrl").
-include("achievement.hrl").
-include("gain.hrl").

%% 角色登录
login(Role = #role{achievement = Ach = #role_achievement{day_list = DayList, day_reward = DayReward}}) ->
    NewDayList = [A || A = #achievement{accept_time = AcceptTime} <- DayList, util:is_today(AcceptTime)],
    {NewDayReward, NewList} = case length(DayList) =:= length(NewDayList) andalso length(DayList) >= 3 of
        true -> {DayReward, DayList};
        false -> {0, reset_list(Role)}
    end,
    {ok, NRole, NList} = achievement:add_trigger(Role, NewList, []),
    NewRole = NRole#role{achievement = Ach#role_achievement{day_reward = NewDayReward, day_list = NList}},
    add_reset_timer(NewRole);
login(Role) -> 
    Role.

%% 玩家升级
lev_up(Role = #role{achievement = #role_achievement{day_list = []}}) ->
    {ok, NRole} = reset(Role),
    NRole;
lev_up(Role) ->
    Role.

%% 领取奖励
reward(Role = #role{achievement = Ach = #role_achievement{day_reward = 0, day_list = DayList}}) ->
    FinishList = [A || A = #achievement{status = ?achievement_status_finish} <- DayList],
    case length(FinishList) >= 3 of
        false ->
            {false, ?L(<<"需要完成3个每日目标才能领取奖励的哦">>)};
        true ->
            GL = [#gain{label = item, val = [29461, 1, 1]}],
            case role_gain:do(GL, Role) of
                {false, _} -> 
                    {false, ?L(<<"背包已满，请先整理背包">>)};
                {ok, NRole} ->
                    notice:inform(Role#role.pid, notice_inform:gain_loss(GL, ?L(<<"日常目标奖励">>))),
                    {ok, NRole#role{achievement = Ach#role_achievement{day_reward = 1}}}
            end
    end;
reward(_Role) ->
    {false, ?L(<<"不能重复领取奖励哦">>)}.

%% 增加日常目标重置时间(下一天0点或过期时间)
add_reset_timer(Role) ->
    NRole = case role_timer:del_timer(achievement_everyday_reset, Role) of
        {ok, _, NR} -> NR;
        false -> Role
    end,
    NextCheckTime = util:unixtime({nexttime, 1}),
    role_timer:set_timer(achievement_everyday_reset, NextCheckTime * 1000, {achievement_everyday, reset, []}, 1, NRole).

%% 重置数据
reset(Role = #role{achievement = Ach = #role_achievement{day_list = DayList}}) ->
    Role0 = del_trigger(Role, DayList),
    NewList = reset_list(Role0),
    {ok, NRole, NList} = achievement:add_trigger(Role0, NewList, []),
    ?DEBUG("[~s]更新日常目标:~p", [Role#role.name, length(NList)]),
    NewRole = NRole#role{achievement = Ach#role_achievement{day_reward = 0, day_list = NList}},
    achievement:push_info(reset_day_target, do, NewRole),
    {ok, add_reset_timer(NewRole)}.

%%---------------------------------------------------------
%% 内部方法
%%---------------------------------------------------------

%% 删除相关触发器
del_trigger(Role, []) ->
    Role;
del_trigger(Role, [A = #achievement{progress = Progs} | T]) ->
    NRole = del_trigger(Role, A, Progs),
    del_trigger(NRole, T).
del_trigger(Role, _A, []) ->
    Role;
del_trigger(Role = #role{trigger = Trigger}, A, [#achievement_progress{id = Tid, trg_label = Label} | T]) ->
    case role_trigger:del(Label, Trigger, Tid) of
        {ok, NewTrigger} -> %% 进度完成 删除触发器成功
            ?DEBUG("[~p]删除触发器Label:~w TriggerId:~w", [A#achievement.id, Label, Tid]),
            del_trigger(Role#role{trigger = NewTrigger}, A, T);
        _ ->
            ?DEBUG("[~p]删除触发器失败Label:~w TriggerId:~w", [A#achievement.id, Label, Tid]),
            del_trigger(Role, A, T)
    end.

%% 随机生成10个日常目标
reset_list(Role) ->
    AcceptList = find_accept_list(Role),
    List = del_extends(AcceptList, AcceptList),
    RandList = rand_list(List, []),
    convert_list(Role, RandList, []).

%% 转换成角色目标数据
convert_list(_Role, [], List) ->
    List;
convert_list(Role, [Id | T], List) ->
    {ok, #achievement_base{finish_cond = Conds}} = achievement_data_everyday:get(Id),
    Progs = achievement_progress:convert(Conds, Role),
    PL = [P || P <- Progs, P#achievement_progress.status =:= 0],
    {FT, Status} = case PL of %% 判断条件是否已完成
        [] -> {util:unixtime(), 1};
        _ -> {0, 0}
    end,
    A = #achievement{
        id = Id
        ,status = Status
        ,system_type = ?target_type_everyday
        ,progress = Progs
        ,accept_time = util:unixtime()
        ,finish_time = FT
    },
    convert_list(Role, T, [A | List]).

%% 从可出列表中随机出10个
rand_list([], List) ->
    List;
rand_list(AllList, []) when length(AllList) =< 10 ->
    AllList;
rand_list(_AllList, List) when length(List) >= 10 ->
    List;
rand_list(AllList, List) ->
    I = rand_list(AllList, List, 0),
    rand_list(AllList -- [I], [I | List]).

rand_list(AllList, _List, N) when N >= 200 ->
    util:rand_list(AllList);
rand_list(AllList, List, N) ->
    Id = util:rand_list(AllList),
    L = [Id1 || Id1 <- List, Id1 >= 1900, Id1 < 2000],
    case length(L) >= 2 andalso (Id >= 1900 andalso Id < 2000) of
        true -> rand_list(AllList, List, N + 1);
        _ -> Id
    end.

%% 查找可接受列表
find_accept_list(Role) ->
    AllL = achievement_data_everyday:list(),
    find_accept_list(Role, AllL, []).
find_accept_list(_Role, [], AcceptList) -> 
    AcceptList;
find_accept_list(Role, [Id | T], AcceptList) ->
    case achievement_data_everyday:get(Id) of
        {ok, #achievement_base{accept_cond = Conds}} ->
            case achievement:check_accept(Conds, Role) of
                true ->
                    find_accept_list(Role, T, [Id | AcceptList]);
                false ->
                    find_accept_list(Role, T, AcceptList)
            end;
        _ ->
            find_accept_list(Role, T, AcceptList)
    end.

%% 踢除掉继承中较低级的数据
del_extends(AcceptList, []) ->
    AcceptList;
del_extends(AcceptList, [Id | T]) ->
    NewAcceptList = if
        Id =:= 1912 orelse Id =:= 1913 orelse Id =:= 1914 orelse Id =:= 1915 -> 
            WeekDay = calendar:day_of_the_week(date()),
            case WeekDay =:= 1 orelse WeekDay =:= 3 orelse WeekDay =:= 5 of
                true -> AcceptList;
                _ -> AcceptList -- [Id]
            end;
        true -> AcceptList
    end,
    case achievement_data_everyday:get(Id) of
        {ok, #achievement_base{extends = Extends}} when is_integer(Extends) -> %% 需要踢除上一级数据
            del_extends(NewAcceptList -- [Extends], T);
        _ ->
            del_extends(NewAcceptList, T)
    end.
