%%----------------------------------------------------
%% 活动任务
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(campaign_task).
-export([
        listener/3
        ,task_list/1
        ,reward/2
    ]
).
-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("task.hrl").

-define(campaign_task_list, [
        #campaign_task{id = 1, name = ?L(<<"仙法竞技">>), label = arena, items = [{33116, 1, 1}]}
        ,#campaign_task{id = 2, name = ?L(<<"帮会战">>), label = guild_war, items = [{33116, 1, 1}]}
        ,#campaign_task{id = 3, name = ?L(<<"仙道会">>), label = world_compete, items = [{33116, 1, 1}]}
        ,#campaign_task{id = 4, name = ?L(<<"正义护送">>), label = escort, target_val = 1, items = [{33116, 1, 1}]}
        ,#campaign_task{id = 5, name = ?L(<<"橙色修行任务">>), label = task, target_val = 1, target = {?task_type_xx, 4}, items = [{33116, 1, 1}]}
        %%,#campaign_task{id = 6, name = ?L(<<"精灵幻境">>), target = [20600], label = dungeon, items = [{33116, 1, 1}]}
        ,#campaign_task{id = 7, name = ?L(<<"镇妖塔">>), target = [20100, 20101], label = dungeon, items = [{33116, 1, 1}]}
        ,#campaign_task{id = 8, name = ?L(<<"洛水龙宫">>), target = [20300, 20301], label = dungeon, items = [{33116, 1, 1}]}
        ,#campaign_task{id = 9, name = ?L(<<"无尽试练">>), label = practice, items = [{33116, 1, 1}]}
        ,#campaign_task{id = 10, name = ?L(<<"神秘商店">>), label = npc_store_sm, items = [{33116, 1, 1}]}
        ,#campaign_task{id = 11, name = ?L(<<"仙境寻宝">>), label = casino, items = [{33116, 1, 1}]}
        ,#campaign_task{id = 12, name = ?L(<<"商城购买">>), label = shop, items = [{33116, 1, 1}]}
        %%,#campaign_task{id = 13, name = ?L(<<"飞仙历练">>), label = train, target_val = 1, items = [{33226, 1, 1}]}
        %%,#campaign_task{id = 14, name = ?L(<<"神秘商店消费30晶钻">>), label = npc_store_sm_gold, target_val = 30, items = [{33226, 1, 1}]}
        %%,#campaign_task{id = 15, name = ?L(<<"神秘商店消费120晶钻">>), label = npc_store_sm_gold, target_val = 120, items = [{33226, 1, 3}]}
        %%,#campaign_task{id = 16, name = ?L(<<"龙宫寻宝10次">>), label = casino_count, target = 1, target_val = 10, items = [{33226, 1, 3}]}
        %%,#campaign_task{id = 17, name = ?L(<<"龙宫寻宝60次">>), label = casino_count, target = 1, target_val = 60, items = [{33226, 1, 13}]}
        %%,#campaign_task{id = 18, name = ?L(<<"仙府寻宝5次">>), label = casino_count, target = 2,  target_val = 5, items = [{33226, 1, 3}]}
        %%,#campaign_task{id = 19, name = ?L(<<"仙府寻宝30次">>), label = casino_count, target = 2,  target_val = 30, items = [{33226, 1, 13}]}
        %%,#campaign_task{id = 20, name = ?L(<<"仙魂探宝5次">>), label = casino_count, target = 4,  target_val = 5, items = [{33226, 1, 3}]}
        %%,#campaign_task{id = 21, name = ?L(<<"仙魂探宝30次">>), label = casino_count, target = 4,  target_val = 30, items = [{33226, 1, 13}]}
        %%,#campaign_task{id = 22, name = ?L(<<"仙魂探宝100次">>), label = casino_count, target = 4,  target_val = 100, items = [{26035, 1, 2}]}
    ]
).

%% 任务监听
%% listener(Role, arena, 1)  仙法竞技
%% listener(Role, guild_war, 1)  帮会战
%% listener(Role, world_compete, 1)  仙道会
%% listener(Role, escort, EscortType)  护送
%% listener(Role, task, Task)    橙色修行任务
%% listener(Role, dungeon, Id)    进入副本
%% listener(Role, practice, 1)    无限试练
%% listener(Role, casino, 1)      寻宝
%% listener(Role, npc_store_sm, 1)    神秘商店
%% listener(Role, shop, 1)    商城
%% listener(Role, train, 1)   参加一个飞仙历练
%% listener(Role, npc_store_sm_gold, Num) 神秘商店消费N晶钻
%% listener(Role, casino_count, Num) 龙宫仙境(target = 1)/仙府秘境(target = 2)/天官赐福(target = 3)N次

listener({Rid, Srvid}, Label, Args) ->
    case check_camp_time() of
        false -> 
            ok;
        true ->
            case role_api:lookup(by_id, {Rid, Srvid}, #role.pid) of
                {ok, _N, Pid} -> %% 角色在线 通过异步方式发放称号
                    listener(Pid, Label, Args);
                _ -> %% 角色不在线 通过更新数据库发放称号
                    ok
            end
    end;
listener(#role{pid = Pid}, Label, Args) ->
    listener(Pid, Label, Args);
listener(Pid, Label, Args) when is_pid(Pid) ->
    case check_camp_time() of
        false ->
            ok;
        true ->
            role:apply(async, Pid, {fun do_listener/3, [Label, Args]})
    end;
listener(_RoleInfo, _Label, _Args) ->
    ok.

%% 获取活动任务列表
task_list(#role{campaign = #campaign_role{task_list = TaskList}}) ->
    reset_task_list(TaskList).

%% 领取任务奖励
reward(Role = #role{campaign = Campaign = #campaign_role{task_list = TaskList}}, Id) ->
    NewTaskList = reset_task_list(TaskList),
    case lists:keyfind(Id, #campaign_task.id, NewTaskList) of
        false -> 
            {false, ?L(<<"活动任务不存在">>)};
        #campaign_task{status = 1} ->
            {false, ?L(<<"活动任务没有完成，不能领取哦">>)};
        #campaign_task{status = 3} ->
            {false, ?L(<<"不能重复领取奖励哦">>)};
        Task = #campaign_task{name = TaskName, count = Count, max_count = MaxCount, items = Items} ->
            GL = [#gain{label = item, val = [BaseId, Bind, Num]} || {BaseId, Bind, Num} <- Items],
            case role_gain:do(GL, Role) of
                {false, _} ->
                    {false, ?L(<<"您的背包已满，先整理背包再领取吧">>)};
                {ok, NRole} ->
                    Msg = notice_inform:gain_loss(GL, ?L(<<"活动奖励">>)),
                    notice:inform(Role#role.pid, Msg),
                    NewTask = case Count >= MaxCount of
                        true -> Task#campaign_task{status = 3};
                        false -> Task#campaign_task{count = Count + 1, status = 1, value = 0}
                    end,
                    NewTaskList0 = lists:keyreplace(Id, #campaign_task.id, NewTaskList, NewTask),
                    NewRole = NRole#role{campaign = Campaign#campaign_role{task_list = NewTaskList0}},
                    push_task(task, [NewTask], Role),
                    log:log(log_handle_all, {15812, <<"活动任务">>, util:fbin("[任务:~p ~s", [Id, TaskName]), Role}),
                    {ok, NewRole}
            end
    end.    

%%--------------------------------------
%% 内部方法
%%--------------------------------------

%% 判断是否活动时间
check_camp_time() ->
    Now = util:unixtime(),
    StartT = util:datetime_to_seconds({{2013, 3, 29}, {0, 0, 1}}),
    EndT = util:datetime_to_seconds({{2013, 4, 2}, {23, 59, 59}}),
    Now >= StartT andalso Now < EndT.

%% 重置任务数据
reset_task_list(TaskList) ->
    Now = util:unixtime(),
    case check_camp_time() of
        false -> [];
        true -> 
            NewTaskList = [Task || Task <- TaskList, check_task(Task, Now)],
            reset_task_list(?campaign_task_list, NewTaskList)
    end.
reset_task_list([], NewTaskList) -> NewTaskList;
reset_task_list([Task = #campaign_task{id = Id} | T], NewTaskList) ->
    case lists:keyfind(Id, #campaign_task.id, NewTaskList) of
        false -> 
            NewTask = Task#campaign_task{start_time = util:unixtime()},
            reset_task_list(T, [NewTask | NewTaskList]);
        _ -> 
            reset_task_list(T, NewTaskList)
    end.
check_task(#campaign_task{type = 2, start_time = Time}, Now) ->
    util:is_same_day2(Time, Now);
check_task(Task, _Now) -> 
    is_record(Task, campaign_task). 

%% 执行任务监听
do_listener(Role = #role{campaign = Campaign = #campaign_role{task_list = TaskList}}, Label, Args) ->
    NewTaskList0 = reset_task_list(TaskList),
    NewTaskList = update_progress(Role, NewTaskList0, [], Label, Args),
    Role1 = Role#role{campaign = Campaign#campaign_role{task_list = NewTaskList}},
    {ok, Role1};
do_listener(_Role, _Label, _Args) ->
    {ok}.

%% 更新任务进度
update_progress(_Role, [], NewTaskList, _Label, _Args) ->
    NewTaskList;
update_progress(Role, [Task = #campaign_task{label = Label, target = Target, status = 1} | T], NewTaskList, Label = dungeon, Args) ->
    case lists:member(Args, Target) of
        false -> 
            update_progress(Role, T, [Task | NewTaskList], Label, Args);
        true -> 
            NewTask = do_update_progress(Role, Task, 1),
            push_task(task, [NewTask], Role),
            update_progress(Role, T, [NewTask | NewTaskList], Label, Args)
    end;
update_progress(Role, [Task = #campaign_task{label = Label, target = {Type, Quality}, status = 1} | T], NewTaskList, Label = task, Args) ->
    case Args of
        #task{type = Type, quality = Quality} -> 
            NewTask = do_update_progress(Role, Task, 1),
            push_task(task, [NewTask], Role),
            update_progress(Role, T, [NewTask | NewTaskList], Label, Args);
        _ -> 
            update_progress(Role, T, [Task | NewTaskList], Label, Args)
    end;
update_progress(Role, [Task = #campaign_task{label = Label, status = 1} | T], NewTaskList, Label = escort, Args) ->
    case Args of
        1 -> 
            NewTask = do_update_progress(Role, Task, 1),
            push_task(task, [NewTask], Role),
            update_progress(Role, T, [NewTask | NewTaskList], Label, Args);
        _ -> 
            update_progress(Role, T, [Task | NewTaskList], Label, Args)
    end;

%% 神秘商店晶钻数量
update_progress(Role, [Task = #campaign_task{label = npc_store_sm_gold, status = 1} | T], NewTaskList, npc_store_sm, Args) when is_integer(Args) andalso Args > 0 ->
    NewTask = do_update_progress(Role, Task, Args),
    push_task(task, [NewTask], Role),
    update_progress(Role, T, [NewTask | NewTaskList], npc_store_sm, Args);

%% casino次数
update_progress(Role, [Task = #campaign_task{label = casino_count, target = Target, status = 1} | T], NewTaskList, Label, Args = {Target, Num}) ->
    NewTask = do_update_progress(Role, Task, Num),
    push_task(task, [NewTask], Role),
    update_progress(Role, T, [NewTask | NewTaskList], Label, Args);
update_progress(Role, [Task = #campaign_task{label = Label, status = 1} | T], NewTaskList, Label, Args) when Label =/= casino_count ->
    NewTask = do_update_progress(Role, Task, 1),
    push_task(task, [NewTask], Role),
    update_progress(Role, T, [NewTask | NewTaskList], Label, Args);
update_progress(Role, [Task | T], NewTaskList, Label, Args) ->
    update_progress(Role, T, [Task | NewTaskList], Label, Args).

do_update_progress(Role, Task = #campaign_task{id = CampId, value = Val, name = TName, target_val = TargetVal, items = Items = [{_, _, ItemNum}]}, Num) ->
    NewVal = Val + Num,
    Status = case NewVal >= TargetVal of
        true -> %% 1 未完成 2 已完成未领取 3 已领取
            case CampId of
                22 -> mail_mgr:deliver(Role, {?L(<<"仙魂探宝，幸运有礼">>), util:fbin(?L(<<"亲爱的玩家，活动期间您参加了~s，获得了二级控制强化石*~w额外奖励，此活动每天可参与一次，明天不要错过哦！祝您游戏愉快！">>), [TName, ItemNum]), [], Items});
                _ -> mail_mgr:deliver(Role, {?L(<<"辛勤耕耘，铸就富翁">>), util:fbin(?L(<<"亲爱的玩家，活动期间您参加了~s，获得了幸运骰子*~w额外奖励，此道具可用于在秘境大富翁中抽取超值惊喜奖励哦，请注意查收！谢谢您的支持，祝您游戏愉快！">>), [TName, ItemNum]), [], Items})
            end,
            3;
        _ -> 1
    end,
    Task#campaign_task{status = Status, value = NewVal}.

%% 活动任务变化推送
push_task(task, TaskList, #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 15811, {TaskList}).

