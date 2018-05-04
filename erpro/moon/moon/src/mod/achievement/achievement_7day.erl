%%----------------------------------------------------
%% @doc 开服7日目标
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(achievement_7day).
-export([
        login/1
        ,reward/2
        ,list/1
        ,lev/5
        ,special_event/5
        ,acc_event/5
        ,kill_npc/5
        ,eqm_event/5
    ]).
-include("common.hrl").
-include("role.hrl").
-include("achievement.hrl").
-include("gain.hrl").
-include("item.hrl").
-include("condition.hrl").

%% @spec login(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 角色登录
login(Role = #role{achievement = Ach = #role_achievement{srv_open_7day = DayList}, trigger = Trigger}) ->
    Now = util:unixtime(),
    case util:day_diff(Now, sys_env:get(srv_open_time)) of
        Day when Day > 6 ->
            Role;
        Day ->
            DayList1 = case [D || D = #achievement{} <- DayList] of
                [] ->
                    %%  新角色初始化
                    F = fun(#achievement_base{id = Id, finish_cond = FConds, system_type = SystemType}) ->
                            St = case Day >= Id of
                                true -> 3;
                                _ -> 0
                            end,
                            Progs = achievement_progress:convert(FConds, Role),
                            #achievement{id = Id, status = St, progress = Progs, system_type = SystemType}  
                    end,
                    [F(O) || O <- get_targets()];
                _ -> 
                    %% 处理已过期部分
                    F = fun(A = #achievement{id = Id, status = St}) ->
                            NewSt = case Day >= Id of
                                true when St =:= 0 -> 3;
                                _ -> St
                            end,
                            A#achievement{status = NewSt}
                    end,
                    [F(O) || O <- DayList]
            end,
            {DayList2, NewTrigger} = add_trigger(DayList1, Trigger, []),
            Role#role{achievement = Ach#role_achievement{srv_open_7day = DayList2}, trigger = NewTrigger}
    end;
login(Role) -> 
    Role.

%% @spec reward(Role, Id) -> {ok, NewRole} | FailReason
%% Role = NewRole = #role{}
%% Id = integer()
%% FailReason = atom()
%% @doc 领取奖励
reward(Role = #role{pid = Pid, achievement = Ach = #role_achievement{srv_open_7day = DayList}}, Id) ->
    case lists:keyfind(Id, #achievement.id, DayList) of
        #achievement{status = 0} ->
            not_finish;
        #achievement{status = 2} ->
            rewarded;
        #achievement{status = 3} ->
            day_over;
        A = #achievement{status = 1} ->
            case lists:keyfind(Id, #achievement_base.id, get_targets()) of
                #achievement_base{rewards = Rewards} ->
                    case role_gain:do(Rewards, Role) of
                        {ok, Role1} ->
                            DayList1 = lists:keyreplace(Id, #achievement.id, DayList, A#achievement{status = 2}),
                            NewRole = Role1#role{achievement = Ach#role_achievement{srv_open_7day = DayList1}},
                            Str = notice:gain_to_item3_inform(Rewards),
                            notice:inform(Pid, util:fbin(?L(<<"获得~s">>), [Str])),
                            push(13053, NewRole),
                            {ok, NewRole};
                        Other ->
                            Other
                    end;
                _ ->
                    no_rewards
            end;
        _T ->
            ?DEBUG("未知七日目标数据 id ~w ~w", [Id, _T]),
            no_target
    end.

%% @spec list(Role) -> list()
%% Role = #role{}
%% @doc 获取7日目标列表
list(#role{achievement = #role_achievement{srv_open_7day = DayList}}) ->
    OpenTime = sys_env:get(srv_open_time),
    OpenDay = util:unixtime({today, OpenTime}),
    Now = util:unixtime(),
    F = fun(#achievement{id = Id, status = St}) ->
            {Id, St, max(0, OpenDay + Id * 3600 * 24 - Now)}
    end,
    {[F(A) || A <- DayList]}.


%% 玩家升级
lev(Role, Lev, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, Lev).

%% 身上装备变化事件
eqm_event(Role, Args, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, Args).

%% 击杀npc
kill_npc(_Role, {NpcBaseId, _Num}, _TriggerId, _AId, Target) when NpcBaseId =/= Target andalso Target =/= 0 ->
    ok;
kill_npc(Role, {NpcBaseId, Num}, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, {NpcBaseId, Num}).

%% 累积事件
acc_event(_Role, {Key, _Val}, _TriggerId, _AId, Target) when Key =/= Target ->
    ok;
acc_event(Role, {Key, Val}, TriggerId, AId, _Target) ->
    ?DEBUG("触发 acc_event"),
    update_progress(Role, TriggerId, AId, {Key, Val}).

%% 其他事件
special_event(_Role, {Key, _Val}, _TriggerId, _AId, Target) when Key =/= Target ->
    ok;
special_event(Role, {Key, Val}, TriggerId, AId, _Target) ->
    update_progress(Role, TriggerId, AId, {Key, Val}).

%% ------------------------------内部方法----------------------------------------
%% 更新进度
update_progress(Role = #role{achievement = Ach = #role_achievement{srv_open_7day = DayList}, trigger = Trigger}, TriggerId, AId, Arg) ->
    case lists:keyfind(AId, #achievement.id, DayList) of
        A = #achievement{status = 0, id = OverDay, progress = Progs} ->
            Now = util:unixtime(),
            case util:day_diff(Now, sys_env:get(srv_open_time)) of
                Day when Day >= OverDay ->
                    ok;
                _ ->
                    case do_update(AId, Role, Progs, Trigger, TriggerId, Arg, [], false) of
                        {_, _NProgs, _NTrigger, false} -> %% 进度未变化
                            ok;
                        {false, NProgs, NTrigger, true} -> %% 进度有变化，未全部完成
                            NewA = A#achievement{progress = NProgs},
                            NDList = lists:keyreplace(AId, #achievement.id, DayList, NewA),
                            NewRole = Role#role{trigger = NTrigger, achievement = Ach#role_achievement{srv_open_7day = NDList}},
                            push(13053, NewRole),
                            {ok, NewRole};
                        {true, NProgs, NTrigger, _} -> %% 全部进度完成
                            NA = A#achievement{status = ?achievement_status_finish, progress = NProgs, finish_time = util:unixtime()},
                            NDList = lists:keyreplace(AId, #achievement.id, DayList, NA),
                            NRole = Role#role{trigger = NTrigger, achievement = Ach#role_achievement{srv_open_7day = NDList}},
                            push(13053, NRole),
                            {ok, NRole}
                    end
            end;
        _ ->
            ok
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

%% 推送一个目标
push(13053, Role = #role{pid = Pid}) ->
    Data = list(Role),
    role:pack_send(Pid, 13053, Data).


%% 注册触发器
add_trigger([], Trigger, DayList) ->
    {DayList, Trigger};
add_trigger([A = #achievement{status = St} | T], Trigger, DayList) when St > 0 ->
    add_trigger(T, Trigger, [A | DayList]);
add_trigger([A = #achievement{id = Id, progress = Progs, status = St}  | T], Trigger, DayList) ->
    {ok, NewProgs, NewTrigger} = reg_trigger(Progs, [], Id, Trigger),
    NewSt = case [S || S = #achievement_progress{status = 0} <- NewProgs] of
        [] -> 1;
        _ -> St
    end,
    NewA = A#achievement{progress = NewProgs, status = NewSt},
    add_trigger(T, NewTrigger, [NewA | DayList]).

%% 注册触发器，监控成就目标进度
reg_trigger([], Progs, _AId, Trigger) -> {ok, Progs, Trigger};
reg_trigger([P = #achievement_progress{status = 0, cond_label = CLabel, trg_label = TrgLabel, target = Target} | T], Progs, AId, Trigger) -> %% 未完成进度且没有注册过触发器
    case role_trigger:add(TrgLabel, Trigger, {?MODULE, CLabel, [AId, Target]}) of 
        {ok, Id, NewTrigger} ->
            reg_trigger(T, [P#achievement_progress{id = Id} | Progs], AId, NewTrigger);
        _ ->
            ?DEBUG("创建成就进度信息出错:TrgLabel~w, progress:~w", [TrgLabel, P]),
            reg_trigger(T, [P | Progs], AId, Trigger)
    end;
reg_trigger([P | T], Progs, AId, Trigger) -> %% 容错
    reg_trigger(T, [P | Progs], AId, Trigger).

%% 目标配置
get_targets() ->
    [
        #achievement_base{
            id = 1
            ,name = <<"提升等级">>
            ,type = 1
            ,system_type = 3
            ,extends = false
            ,accept_cond = []
            ,finish_cond = [#condition{label = lev, target = 0, target_value = 42} ]
            ,rewards = [
                #gain{label = item, val = [25021, 1, 3]}
               ,#gain{label = item, val = [30011, 1, 5]}
            ]
        },

        #achievement_base{
            id = 2
            ,name = <<"生产任意一件紫装">>
            ,type = 1
            ,system_type = 3
            ,extends = false
            ,accept_cond = []
            ,finish_cond = [#condition{label = eqm_event, target = 1, target_ext = [?eqm_type, -1, -1, 3], target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [27002, 1, 2]}
               ,#gain{label = item, val = [21020, 1, 1]}
            ]
        },

        #achievement_base{
            id = 3
            ,name = <<"竞技场">>
            ,type = 1
            ,system_type = 3
            ,extends = false
            ,accept_cond = []
            ,finish_cond = [#condition{label = acc_event, target = 106, target_value = 3}
            ]
            ,rewards = [
                #gain{label = item, val = [25024, 1, 1]}
               ,#gain{label = item, val = [30011, 1, 5]}
            ]
        },

        #achievement_base{
            id = 4
            ,name = <<"镇妖塔">>
            ,type = 1
            ,system_type = 3
            ,extends = false
            ,accept_cond = []
            ,finish_cond = [#condition{label = kill_npc, target = 30056, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [30210, 1, 3]}
               ,#gain{label = item, val = [32531, 1, 3]}
            ]
        },

        #achievement_base{
            id = 5
            ,name = <<"40级世界boss">>
            ,type = 1
            ,system_type = 3
            ,extends = false
            ,accept_cond = []
            ,finish_cond = [
                #condition{label = kill_npc, target = 25000, target_value = 1}
                ,#condition{label = kill_npc, target = 25016, target_value = 1}
                ,#condition{label = kill_npc, target = 25020, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [32000, 1, 2]}
               ,#gain{label = item, val = [32001, 1, 1]}
            ]
        },

        #achievement_base{
            id = 6
            ,name = <<"每日目标">>
            ,type = 1
            ,system_type = 3
            ,extends = false
            ,accept_cond = []
            ,finish_cond = [
                #condition{label = special_event, target = 30031, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [22201, 1, 3]}
               ,#gain{label = item, val = [30011, 1, 8]}
            ]
        },

        #achievement_base{
            id = 7
            ,name = <<"获得任意一件橙装">>
            ,type = 1
            ,system_type = 3
            ,extends = false
            ,accept_cond = []
            ,finish_cond = [#condition{label = eqm_event, target = 1, target_ext = [?eqm_type, -1, -1, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [27003, 1, 2]}
               ,#gain{label = item, val = [21020, 1, 1]}
            ]
        }
    ].

