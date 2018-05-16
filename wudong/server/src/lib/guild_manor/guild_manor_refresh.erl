%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 二月 2017 17:10
%%%-------------------------------------------------------------------
-module(guild_manor_refresh).
-author("hxming").

-include("guild_manor.hrl").
-include("common.hrl").

%% API
-compile(export_all).


%%刷新建筑以及任务
check_refresh_building(Manor, Now) ->
    F = fun(Building, M) ->
        {Building1, ManorExp} = check_finish_task(Manor#g_manor.gkey, Building, Now),
        BuildingList = [Building1 | lists:keydelete(Building#manor_building.type, #manor_building.type, M#g_manor.building_list)],
        add_manor_exp(M#g_manor{building_list = BuildingList}, ManorExp)
        end,
    Manor1 = lists:foldl(F, Manor, Manor#g_manor.building_list),

    F1 = fun(Type, M1) ->
        case lists:keymember(Type, #manor_building.type, Manor1#g_manor.building_list) of
            false ->
                Base = data_manor_building:get(Type),
                if Manor#g_manor.lv >= Base#base_manor_building.manor_lv ->
                    M1#g_manor{building_list = [#manor_building{type = Type, lv = 1} | M1#g_manor.building_list]};
                    true ->
                        M1
                end;
            true ->
                M1
        end
         end,
    Manor2 = lists:foldl(F1, Manor1, data_manor_building:type_list()),
    Manor3 = check_refresh_retinue(Manor2, Now),
    if Manor3 == Manor -> Manor;
        true ->
            NewManor = Manor3#g_manor{is_change = 1},
            guild_manor_ets:set_guild_manor(NewManor),
            NewManor
    end.


%%检查完成任务
check_finish_task(_Gkey, Building, Now) ->
    F = fun(Task, {Building1, Exp}) ->
        if Task#manor_building_task.pkey > 0 andalso Task#manor_building_task.time < Now ->
            TaskData = data_building_task:get(Task#manor_building_task.task_id),
            %%发布人奖励邮件
            mail:sys_send_mail([Task#manor_building_task.pkey], ?T("建筑任务"), ?T("亲爱的玩家,您开始的建筑任务已完成,奖励请查收!"), tuple_to_list(TaskData#base_building_task.start_reward)),
            %%宝箱
            BoxList = random_box(Task, TaskData),
            Building2 = add_building_exp(Building1, TaskData#base_building_task.building_exp),
            ManorExp = ?IF_ELSE(Building1#manor_building.lv /= Building2#manor_building.lv, data_guild_manor_exp_up:get(Building#manor_building.type, Building#manor_building.lv), 0),
%%            notice_sys:add_notice(guild_manor_task, [Gkey, TaskData#base_building_task.desc]),
            {Building2#manor_building{box_list = BoxList ++ Building1#manor_building.box_list},
                Exp + ManorExp};
            true ->
                {Building1#manor_building{task = [Task | Building1#manor_building.task]}, Exp}
        end
        end,
    lists:foldl(F, {Building#manor_building{task = []}, 0}, Building#manor_building.task).


%%几率宝箱
random_box(Task, TaskData) ->
    case util:odds(Task#manor_building_task.ratio, 100) of
        false -> [];
        true ->
            Box = #manor_building_box{key = misc:unique_key(), box_id = TaskData#base_building_task.box_id,
                open_times = TaskData#base_building_task.open_times},
            [Box]
    end.

%%增加建筑经验
add_building_exp(Building, Exp) ->
    ExpLim = data_manor_building_exp:get(Building#manor_building.lv),
    NewExp = Building#manor_building.exp + Exp,
    MaxLv = data_manor_building_exp:max_lv(),
    if Building#manor_building.lv >= MaxLv orelse ExpLim > NewExp ->
        Building#manor_building{exp = NewExp};
        true ->
            Building#manor_building{exp = NewExp - ExpLim, lv = Building#manor_building.lv + 1}
    end.

%%增加家园经验
add_manor_exp(Manor, Exp) ->
    NewExp = Manor#g_manor.exp + Exp,
    MaxLv = data_guild_manor_exp:max_lv(),
    ExpLim = data_guild_manor_exp:get(Manor#g_manor.lv),
    if Manor#g_manor.lv >= MaxLv orelse NewExp < ExpLim ->
        Manor#g_manor{exp = NewExp};
        true ->
            Manor#g_manor{lv = Manor#g_manor.lv + 1, exp = NewExp - ExpLim}
    end.

%%计算随从状态
check_refresh_retinue(Manor, Now) ->
    F = fun(Retinue) ->
        if Retinue#manor_retinue.time =< Now -> Retinue;
            Retinue#manor_retinue.state_cd > Now -> Retinue;
            true ->
                case random_retinue_state(Retinue#manor_retinue.state_log) of
                    false ->
                        Retinue;
                    Id ->
                        Base = data_manor_retinue_state:get(Id),
                        Cd = min(Retinue#manor_retinue.time, Now + Base#base_manor_retinue_state.cd),
                        Log = ?IF_ELSE(Base#base_manor_retinue_state.repeat == 1, Retinue#manor_retinue.state_log, [Id | Retinue#manor_retinue.state_log]),
                        Retinue#manor_retinue{state = Id, state_cd = Cd, state_log = Log}
                end
        end
        end,
    RetinueList = lists:map(F, Manor#g_manor.retinue_list),
    Manor#g_manor{retinue_list = RetinueList}.


%%随机随从状态
random_retinue_state(Log) ->
    F = fun(Id) ->
        case lists:member(Id, Log) of
            true -> [];
            false ->
                Base = data_manor_retinue_state:get(Id),
                [{Id, Base#base_manor_retinue_state.ratio}]
        end
        end,
    RatioList = lists:flatmap(F, data_manor_retinue_state:state_list()),
    case RatioList of
        [] -> false;
        _ -> util:list_rand_ratio(RatioList)
    end.


%%刷新任务数据
refresh_task(Building, Now) ->
    Base = data_building_task_rule:get(Building#manor_building.type, Building#manor_building.lv),
    if Now < Building#manor_building.refresh_time -> Building;
        Base == [] ->
            ?ERR("can not find building_task_rule data ~p~n", [{Building#manor_building.type, Building#manor_building.lv}]),
            Building;
        true ->
            F = fun(Task, {L1, L2}) ->
                if Task#manor_building_task.time > 0 ->
                    if Task#manor_building_task.type == 1 ->
                        {[Task | L1], L2};
                        true ->
                            {L1, [Task | L2]}
                    end;
                    true ->
                        {L1, L2}
                end
                end,
            {OldNormalTask, OldSpecialTask} = lists:foldl(F, {[], []}, Building#manor_building.task),

            {SpecialCd, SpecialTask} = refresh_special(Building, Now, OldSpecialTask, Base),
            NormalTask = refresh_normal(Now, Base#base_building_task_rule.task_normal, Base#base_building_task_rule.task_num - length(SpecialTask), OldNormalTask),
            RefreshTime = case data_manor_building:get(Building#manor_building.type) of
                              [] -> ?ONE_HOUR_SECONDS;
                              BaseBuild -> BaseBuild#base_manor_building.task_refresh_time
                          end,
            Building#manor_building{task = SpecialTask ++ NormalTask, special_task_cd = SpecialCd, refresh_time = Now + RefreshTime}
    end.


%%刷新稀有
refresh_special(Building, Now, OldSpecialTask, Base) ->
    case Building#manor_building.special_task_cd > Now of
        true ->
            {Building#manor_building.special_task_cd, OldSpecialTask};
        false ->
            case length(OldSpecialTask) > 0 of
                true ->
                    {Building#manor_building.special_task_cd, OldSpecialTask};
                false ->
                    case util:odds(Base#base_building_task_rule.ratio, 100) of
                        false ->
                            {Building#manor_building.special_task_cd, OldSpecialTask};
                        true ->
                            TaskId = util:list_rand(Base#base_building_task_rule.task_special),
                            case data_building_task:get(TaskId) of
                                [] ->
                                    {Building#manor_building.special_task_cd, OldSpecialTask};
                                TaskData ->
                                    Task = #manor_building_task{
                                        task_id = TaskId,
                                        type = TaskData#base_building_task.type
                                    },
                                    {Base#base_building_task_rule.cd + Now, [Task]}
                            end
                    end
            end
    end.

%% 刷新普通任务
refresh_normal(_Now, TaskIds, Num, OldNormalTask) ->
    HadNum = length(OldNormalTask),
    if HadNum >= Num -> OldNormalTask;
        true ->
            F = fun(TaskId) ->
                case data_building_task:get(TaskId) of
                    [] -> [];
                    TaskData ->
                        [#manor_building_task{
                            task_id = TaskId,
                            type = TaskData#base_building_task.type
                        }]
                end
                end,
            OldNormalTask ++ lists:flatmap(F, util:get_random_list(TaskIds, Num - HadNum))


    end.