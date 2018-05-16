%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 任务
%%% @end
%%% Created : 07. 九月 2015 下午12:13
%%%-------------------------------------------------------------------
-module(task).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("task.hrl").
-include("goods.hrl").
%% API
-export([
    get_task_list/1,
    get_task/1,
    get_task_active_list/0,
    get_task_by_type/1,
    get_npc_task/1,
    auto_accept_task/1,
    accept_task/2,
    accept_guild_task/3,
    upgrade_guild_task/1,
    accept_cycle_task/3,
    upgrade_cycle_task/1,
    accept_reward_task/3,
    accept_special_task/3,
    finish_task/2,
    auto_finish/2,
    finish_guild_task/2,
    check_finish/1,
    midnight_refresh/2,
    refresh_client_task_all/1,
    refresh_client_task_one/2,
    refresh_client_new_task/2,
    refresh_client_del_task/2,
    is_guild_task/1,
    check_task_timeout/2,
    in_finish/1,
    in_trigger/1,
    in_can_trigger/1,
    del_task_by_type/2,
    del_task_by_type/1,
    del_task/1,
    story/4,
    trans_task_goods_list/3,
    reset_task_times/1,
    accept_manor_task/2,
    refresh_task/1

]).

-export([
    cmd_trigger_task/2,
    cmd_finish_task/1,
    cmd_finish_lv_task/1,
    cmd_task_check/0,
    cmd_del_task/2,
    cmd_reset_times/0,
    cmd_check_task/0,
    cmd_check_task1/0,
    cmd_tlv/2,
    cmd_refresh_task/0,
    cmd_auto_main_task/1,
    cmd_auto_cycle_task/1,
    cmd_finish_task_by_taskid/2,
    gm_test/0
]).
%%获取所有任务列表
get_task_list(Player) ->
    StTask = task_init:get_task_st(),
%%    NextList = get_next_lv_task(Player#player.lv, StTask),
    ConvoyTask = task_convoy:convoy_task(Player),
    GuildTask = task_guild:get_guild_task(Player),
    %%已接+可接+下一级主线+未接护送任务
    TaskList = StTask#st_task.activelist ++ ConvoyTask ++ GuildTask,
    task_pack:trans30001(TaskList).


%%根据id获取已接任务
get_task(TaskId) ->
    StTask = task_init:get_task_st(),
    ActiveList = StTask#st_task.activelist,
    case lists:keyfind(TaskId, #task.taskid, ActiveList) of
        false -> [];
        Task ->
            Task
    end.

%%根据类型获取已接任务
get_task_by_type(Type) ->
    StTask = task_init:get_task_st(),
    ActiveList = StTask#st_task.activelist,
    [Task || Task <- ActiveList, Task#task.type == Type].

%%获取已接任务列表
get_task_active_list() ->
    StTask = task_init:get_task_st(),
    StTask#st_task.activelist.

%%根据id获取已接或可接任务
get_npc_task(TaskId) ->
    StTask = task_init:get_task_st(),
    AllTask = StTask#st_task.tasklist ++ StTask#st_task.activelist,
    case lists:keyfind(TaskId, #task.taskid, AllTask) of
        false -> [];
        Task ->
            Task
    end.

%%查询任务是否已接
in_trigger(TaskId) ->
    case get_task(TaskId) of
        [] -> false;
        _Task -> true
    end.

%%查询任务是否完成
in_finish(TaskId) ->
    StTask = task_init:get_task_st(),
    lists:member(TaskId, StTask#st_task.loglist).

%%查询是否有任务可接
in_can_trigger(TaskId) ->
    StTask = task_init:get_task_st(),
    lists:keymember(TaskId, #task.taskid, StTask#st_task.tasklist).

%%刷新客户端
%%更新全部任务数据
refresh_client_task_all(Player) ->
    StTask = task_init:get_task_st(),
    ConvoyTask = task_convoy:convoy_task(Player),
    GuildTask = task_guild:get_guild_task(Player),
    %%已接+可接+下一级主线
    TaskList = StTask#st_task.activelist ++ ConvoyTask ++ GuildTask,
    TaskPack = task_pack:trans30001(TaskList),
    {ok, Bin} = pt_300:write(30001, {TaskPack}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%更新单个任务数据
refresh_client_task_one(Pid, Task) ->
    TaskPack = {Task#task.taskid, Task#task.state, Task#task.act, Task#task.times, Task#task.times_lim, task_pack:pack_state_data(Task#task.state_data)},
    {ok, Bin} = pt_300:write(30004, TaskPack),
    server_send:send_to_pid(Pid, Bin),
    ok.

%%新增任务更新到客户端
refresh_client_new_task(Sid, Task) ->
    {ok, Bin} = pack_client_new_task(Task),
    server_send:send_to_sid(Sid, Bin).

pack_client_new_task(Task) ->
    TaskPack = {Task#task.taskid, Task#task.state, Task#task.act, Task#task.times, Task#task.times_lim, task_pack:pack_state_data(Task#task.state_data)},
    pt_300:write(30005, TaskPack).

%%删除任务，更新到客户端
refresh_client_del_task(Sid, Tid) ->
    {ok, Bin} = pack_client_del_task(Tid),
    server_send:send_to_sid(Sid, Bin).

pack_client_del_task(Tid) ->
    pt_300:write(30006, {Tid}).

%%零点刷新任务
midnight_refresh(Player, NowTime) ->
    StTask = task_init:get_task_st(),
    NewStTask = StTask#st_task{loglist_cl = [], timestamp = NowTime},
    task_init:set_task_st(NewStTask),
    %%刷新跑环任务
    task_cycle:midnight_refresh(Player, NowTime),
    %%刷新护送任务
    task_convoy:midnight_refresh(Player, NowTime),
    %%刷新公会
    task_guild:midnight_refresh(Player, NowTime),
    %%刷新悬赏任务
    task_reward:midnight_refresh(Player),
    task_bet:refresh_task(Player, NowTime, true),
    task_dark:midnight_refresh(Player),
    task_equip:midnight_refresh(Player),
%%    refresh_client_task_all(Player),
    ok.

%%刷新任务
refresh_task(Player) ->
    StTask = task_init:get_task_st(),
    TaskList = get_acceptable_task(Player, StTask),
    NewStTask = StTask#st_task{tasklist = TaskList},
    task_init:set_task_st(NewStTask),
    NewStTask.

%%获取下一级主线
get_next_lv_task(Plv, StTask) ->
    case [Task || Task <- StTask#st_task.activelist ++ StTask#st_task.tasklist, Task#task.type == ?TASK_TYPE_MAIN] of
        [] ->
            %%主线没有已接以及可接，获取下一级可接任务
            next_lv_loop(data_task_main:task_ids(), Plv, StTask#st_task.loglist);
        _ ->
            []
    end.

next_lv_loop([], _Plv, _Log) -> [];
next_lv_loop([Tid | T], Plv, Log) ->
    case lists:member(Tid, Log) of
        true ->
            next_lv_loop(T, Plv, Log);
        false ->
            Task = data_task_main:get(Tid),
            case lists:keyfind(lv, 1, Task#task.accept) of
                {_, Lv} when Lv == Plv + 1 ->
                    %%下一等级
                    case lists:keyfind(task, 1, Task#task.accept) of
                        false ->
                            next_lv_loop(T, Plv, Log);
                        {_, TaskId} ->
                            %%获取前置任务已完成的任务
                            case lists:member(TaskId, Log) of
                                true ->
                                    [Task];
                                false ->
                                    next_lv_loop(T, Plv, Log)
                            end
                    end;
                _ ->
                    next_lv_loop(T, Plv, Log)
            end
    end.

%%获取可接任务列表
get_acceptable_task(Player, StTask) ->
    MainTids = data_task_main:task_ids(),
    MainTaskList = check_acceptable_task(Player, StTask, MainTids, ?TASK_TYPE_MAIN),
    BranchTids = data_task_branch:task_ids(),
    BranchTaskList = check_acceptable_task(Player, StTask, BranchTids, ?TASK_TYPE_BRANCH),
    CareerTids = data_task_change_career:task_ids(),
    CareerTaskList = check_acceptable_task(Player, StTask, CareerTids, ?TASK_TYPE_CHARGE_CRAEER),
    MainTaskList ++ BranchTaskList ++ CareerTaskList.

check_acceptable_task(Player, StTask, Tids, Type) ->
    ActiveList = StTask#st_task.activelist,
    LogList = StTask#st_task.loglist,
    F = fun(Tid) ->
        case task_init:task_data(Tid, Type) of
            [] -> [];
            Task ->
                case check_accept(Player, Task, LogList) of
                    ok ->
                        case lists:member(Tid, LogList) of
                            false ->
                                case lists:keyfind(Tid, #task.taskid, ActiveList) of
                                    false ->
                                        [Task#task{state = ?TASK_ST_ACTIVE}];
                                    _ ->
                                        []
                                end;
                            true ->
                                []
                        end;
                    _ ->
                        []
                end
        end
    end,
    lists:flatmap(F, Tids).


%%检查是否有新的任务可接
auto_accept_task(Player) ->
    NowTime = util:unixtime(),
    StTask = refresh_task(Player),
    %%自动接主支线
    case StTask#st_task.tasklist of
        [] ->
            ok;
%%            IsAccept = false;
        _ ->
%%            IsAccept = true,
            F = fun(Task, St) ->
                NewTask = task_init:new_task(Task, NowTime),
                ActiveList = [NewTask | St#st_task.activelist],
                refresh_client_new_task(Player#player.sid, NewTask),
                task_cron:set_accept(Task#task.taskid, Task#task.name, Task#task.type),
                St#st_task{activelist = ActiveList}
            end,
            NewStTask = lists:foldl(F, StTask#st_task{tasklist = []}, StTask#st_task.tasklist),
            task_init:set_task_st(NewStTask),
            task_event:preact_finish(Player)
    end,
    case Player#player.lv == task_convoy:task_lv() of
        true ->
            [refresh_client_new_task(Player#player.sid, Task) || Task <- task_convoy:convoy_task(Player)];
        false ->
            skip
    end,
    task_cycle:upgrade_lv(Player),
    task_guild:upgrade_lv(Player),
    task_bet:refresh_task(Player, NowTime, true),
    task_dark:upgrade_lv(Player),
    task_equip:midnight_refresh(Player),
    task_xian:upgrade_lv(Player),
    Player.

%%接受领地任务
accept_manor_task(Player, TaskList) ->
    StTask = task_init:get_task_st(),
    NowTime = util:unixtime(),
    F = fun(TaskId, St) ->
        case lists:keymember(TaskId, #task.taskid, St#st_task.activelist) of
            true -> St;
            false ->
                case lists:member(TaskId, St#st_task.loglist_cl) of
                    true -> St;
                    false ->
                        case task_init:task_data(TaskId, ?TASK_TYPE_MANOR_WAR) of
                            [] -> St;
                            Task ->
                                NewTask = task_init:new_task(Task, NowTime),
                                ActiveList = [NewTask | St#st_task.activelist],
                                refresh_client_new_task(Player#player.sid, NewTask),
                                task_cron:set_accept(Task#task.taskid, Task#task.name, Task#task.type),
                                St#st_task{activelist = ActiveList}
                        end
                end
        end
    end,
    NewStTask = lists:foldl(F, StTask, TaskList),
    task_init:set_task_st(NewStTask),
    ok.

%%接受任务
accept_task(Player, TaskId) when TaskId /= 0 ->
    StTask = task_init:get_task_st(),
    ActiveList = StTask#st_task.activelist,
    TaskList = StTask#st_task.tasklist,
    LogList = StTask#st_task.loglist,
    case lists:keyfind(TaskId, #task.taskid, TaskList) of
        false ->
            {err, 3};
        Task ->
            case check_accept(Player, Task, LogList) of
                {err, Code} ->
                    {err, Code};
                ok ->
                    NewTask = task_init:new_task(Task, util:unixtime()),
                    TaskList2 = lists:keydelete(TaskId, #task.taskid, TaskList),
                    ActiveList2 = [NewTask | ActiveList],
                    NewStTask = StTask#st_task{tasklist = TaskList2, activelist = ActiveList2},
                    task_init:set_task_st(NewStTask),
%%                    spawn(fun() ->
%%                        util:sleep(1000),
%%                        %%任务预完成处理
%%                        Player#player.pid ! {preact_finish, NewTask}
%%                          end),
                    task_cron:set_accept(Task#task.taskid, Task#task.name, Task#task.type),
                    pack_client_new_task(NewTask)
            end
    end;
accept_task(_Player, _TaskId) ->
    {err, 3}.

%%接受仙盟任务
accept_guild_task(Sid, Task, IsNotice) ->
    StTask = task_init:get_task_st(),
    NowTime = util:unixtime(),
    NewTask = task_init:new_task(Task, NowTime),
    F = fun(TK) ->
        if TK#task.type == ?TASK_TYPE_GUILD ->
            ?DO_IF(IsNotice, refresh_client_del_task(Sid, TK#task.taskid)),
            [];
            true ->
                [TK]
        end
    end,
    ActiveList = lists:flatmap(F, StTask#st_task.activelist),
    NewActiveList = [NewTask | ActiveList],
    NewStTask = StTask#st_task{activelist = NewActiveList},
    task_init:set_task_st(NewStTask),
    if IsNotice ->
        spawn(fun() ->
            util:sleep(300),
            refresh_client_new_task(Sid, NewTask) end);
        true -> skip
    end,
    NewTask.

upgrade_guild_task(Task) ->
    StTask = task_init:get_task_st(),
    NowTime = util:unixtime(),
    NewTask = task_init:new_task(Task, NowTime),
    F = fun(TK) ->
        if TK#task.type == ?TASK_TYPE_GUILD ->
            [];
            true ->
                [TK]
        end
    end,
    ActiveList = lists:flatmap(F, StTask#st_task.activelist),
    NewActiveList = [NewTask | ActiveList],
    NewStTask = StTask#st_task{activelist = NewActiveList},
    task_init:set_task_st(NewStTask).
%%接受跑环任务
accept_cycle_task(Sid, Task, IsNotice) ->
    StTask = task_init:get_task_st(),
    NowTime = util:unixtime(),
    NewTask = task_init:new_task(Task, NowTime),
    F = fun(TK) ->
        if TK#task.type == ?TASK_TYPE_CYCLE ->

            ?DO_IF(IsNotice, refresh_client_del_task(Sid, TK#task.taskid)),
            [];
            true ->
                [TK]
        end
    end,
    ActiveList = lists:flatmap(F, StTask#st_task.activelist),
    NewActiveList = [NewTask | ActiveList],
    NewStTask = StTask#st_task{activelist = NewActiveList},
    task_init:set_task_st(NewStTask),
    if IsNotice ->
        spawn(fun() ->
            util:sleep(300),
            refresh_client_new_task(Sid, NewTask) end);
        true -> skip
    end,
    NewTask.

upgrade_cycle_task(Task) ->
    StTask = task_init:get_task_st(),
    NowTime = util:unixtime(),
    NewTask = task_init:new_task(Task, NowTime),
    F = fun(TK) ->
        if TK#task.type == ?TASK_TYPE_CYCLE ->
            [];
            true ->
                [TK]
        end
    end,
    ActiveList = lists:flatmap(F, StTask#st_task.activelist),
    NewActiveList = [NewTask | ActiveList],
    NewStTask = StTask#st_task{activelist = NewActiveList},
    task_init:set_task_st(NewStTask).

accept_reward_task(Sid, Task, IsNotice) ->
    StTask = task_init:get_task_st(),
    NowTime = util:unixtime(),
    NewTask = task_init:new_task(Task, NowTime),
    NewActiveList = [NewTask | StTask#st_task.activelist],
    NewStTask = StTask#st_task{activelist = NewActiveList},
    task_init:set_task_st(NewStTask),
    if IsNotice ->
        spawn(fun() ->
            util:sleep(300),
            refresh_client_new_task(Sid, NewTask) end);
        true -> skip
    end,
    NewTask.

%%接受护送任务/其他任务
accept_special_task(Sid, Task, IsNotice) ->
    StTask = task_init:get_task_st(),
    NowTime = util:unixtime(),
    NewTask = task_init:new_task(Task, NowTime),
    ActiveList = [NewTask | StTask#st_task.activelist],
    NewStTask = StTask#st_task{activelist = ActiveList},
    task_init:set_task_st(NewStTask),
    if IsNotice ->
        spawn(fun() -> util:sleep(500),
            refresh_client_new_task(Sid, NewTask)
        end);
        true -> skip
    end,
    NewTask.


%%判断是否仙盟任务
is_guild_task(TaskId) ->
    case task_init:task_data(TaskId, ?TASK_TYPE_GUILD) of
        [] -> false;
        Task -> Task#task.type == ?TASK_TYPE_GUILD
    end.

%%检查任务是否可接
check_accept(Player, Task, TaskLog) ->
    NowTime = util:unixtime(),
    check_accept_helper(Task#task.accept, Player, TaskLog, NowTime).


check_accept_helper([], _Player, _TaskLog, _NowTime) -> ok;
%%等级判断
check_accept_helper([{lv, Lv} | L], Player, TaskLog, NowTime) ->
    if
        Player#player.lv >= Lv ->
            check_accept_helper(L, Player, TaskLog, NowTime);
        true ->
            {err, 5}
    end;
%%前置任务
check_accept_helper([{task, TaskId} | L], Player, TaskLog, NowTime) ->
    case lists:member(TaskId, TaskLog) of
        true ->
            check_accept_helper(L, Player, TaskLog, NowTime);
        false ->
            {err, 8}
    end;

%%职业限制任务
check_accept_helper([{career, Career} | L], Player, TaskLog, NowTime) ->
    if
        Player#player.new_career >= Career ->
            check_accept_helper(L, Player, TaskLog, NowTime);
        true -> {err, 8}
    end;

%%特定关卡
%% check_accept_helper([_|T],Player,TaskLog,NowTime)->
%%     check_accept_helper(T,Player,TaskLog,NowTime);
%%特定时间
check_accept_helper([{time, StartTime, EndTime} | T], Player, TaskLog, NowTime) ->
    if NowTime >= StartTime andalso NowTime =< EndTime ->
        check_accept_helper(T, Player, TaskLog, NowTime);
        true ->
            {err, 9}
    end;
check_accept_helper([_ | L], Player, TaskLog, NowTime) ->
    check_accept_helper(L, Player, TaskLog, NowTime).

auto_finish(Player, TaskId) ->
    StTask = task_init:get_task_st(),
    ActiveList = StTask#st_task.activelist,
    LogList = StTask#st_task.loglist,
    case lists:keytake(TaskId, #task.taskid, ActiveList) of
        false ->
            ok;
        {value, Task, T} ->
            refresh_client_del_task(Player#player.sid, TaskId),
            case to_log(Task#task.type) of
                true ->
                    LogList2 = [TaskId | LogList],
                    LogListCl = StTask#st_task.loglist_cl;
                false ->
                    LogList2 = LogList,
                    LogListCl = [TaskId | StTask#st_task.loglist_cl]
            end,
            NewStTask = StTask#st_task{activelist = T, loglist = LogList2, loglist_cl = LogListCl},
            task_init:set_task_st(NewStTask),
            ok
    end.


%%完成任务
finish_task(Player, TaskId) ->
    StTask = task_init:get_task_st(),
    ActiveList = StTask#st_task.activelist,
    LogList = StTask#st_task.loglist,
    case lists:keyfind(TaskId, #task.taskid, ActiveList) of
        false ->
            refresh_client_task_all(Player),
            {err, 7, Player};
        Task ->
            if %% 机器人暂时屏蔽
                Task#task.state =/= ?TASK_ST_FINISH andalso Player#player.pf =/= 888 ->
                    {err, 6, Player};
                true ->
                    case check_npc_position(Task#task.remote, Task#task.endnpcid, Player#player.scene, Player#player.x, Player#player.y, Player#player.lv) of
                        true ->
                            ActiveList2 = lists:keydelete(TaskId, #task.taskid, ActiveList),
                            {ok, BinDel} = pack_client_del_task(TaskId),
                            case to_log(Task#task.type) of
                                true ->
                                    LogList2 = [TaskId | LogList],
                                    LogListCl = StTask#st_task.loglist_cl;
                                false ->
                                    LogList2 = LogList,
                                    LogListCl = [TaskId | StTask#st_task.loglist_cl]
                            end,
                            NewStTask = StTask#st_task{activelist = ActiveList2, loglist = LogList2, loglist_cl = LogListCl},
                            task_init:set_task_st(NewStTask),
                            refresh_task(Player),

                            %%任务额外处理
                            Player1 =
                                if Task#task.type == ?TASK_TYPE_CYCLE ->
                                    %%大富翁
                                    self() ! {m_task_trigger, 4, 1},
                                    %%资源找回
                                    findback_src:fb_trigger_src(Player, 20, {1, 0}),
                                    act_hi_fan_tian:trigger_finish_api(Player, 4, 1),
                                    task_cycle:finish_task_cycle(Player);
                                    Task#task.type == ?TASK_TYPE_GUILD ->
                                        %%资源找回
                                        act_hi_fan_tian:trigger_finish_api(Player, 5, 1),
                                        findback_src:fb_trigger_src(Player, 30, {1, 0}),
                                        task_guild:finish_task_guild(Player);
                                    Task#task.type == ?TASK_TYPE_REWARD ->
                                        %%资源找回
                                        act_hi_fan_tian:trigger_finish_api(Player, 6, 1),
                                        findback_src:fb_trigger_src(Player, 25, 1),
                                        task_reward:finish_task(Player);
                                    Task#task.type == ?TASK_TYPE_DARK ->
                                        task_dark:finish_task(Player);
                                    Task#task.type == ?TASK_TYPE_XIAN ->
                                        task_xian:finish_task(Player, TaskId),
                                        Player;
                                    Task#task.type == ?TASK_TYPE_CHARGE_CRAEER ->
                                        NewPlayer = task_change_career:finish_task(Player, Task),
                                        NewPlayer;
                                    true -> Player
                                end,

                            {ok, Player2} =
                                if Task#task.type == ?TASK_TYPE_CONVOY ->
                                    act_hi_fan_tian:trigger_finish_api(Player, 10, 1),
                                    task_event:event(?TASK_ACT_TASK_TYPE, {Task#task.type, 1}),
                                    task_convoy:finish_convoy(Player1);
                                    Task#task.type == ?TASK_TYPE_CYCLE ->
                                        task_event:event(?TASK_ACT_TASK_TYPE, {Task#task.type, 1}),
                                        goods:give_goods(Player1, trans_task_goods_list(Player1, TaskId, Task#task.goods));
                                    Task#task.type == ?TASK_TYPE_REWARD ->
                                        goods:give_goods(Player1, trans_task_goods_list(Player1, TaskId, Task#task.goods));
                                    true ->
                                        goods:give_goods(Player1, trans_task_goods_list(Player1, TaskId, Task#task.goods))
                                end,

                            task_cron:set_finish(TaskId, Task#task.name, Task#task.type),
                            Reply =
                                case accept_task(Player, Task#task.next) of
                                    {ok, BinNew} ->
                                        server_send:send_to_sid(Player#player.sid, <<BinDel/binary, BinNew/binary>>),
                                        {ok, Task#task.next};
                                    _ ->
                                        server_send:send_to_sid(Player#player.sid, BinDel),
                                        ok
                                end,
                            {ok, Reply, Player2};
                        false ->
                            {err, 29, Player}
                    end
            end
    end.

%%检查位置
check_npc_position(PosType, NpcId, TarScene, TarX, TarY, Plv) ->
    if PosType /= 0 -> true;
        true ->
            case data_npc_transport:get(NpcId) of
                [] -> true;
                [Sid, X, Y] ->
                    case scene:is_cross_normal_scene(Sid) of
                        false ->
                            TarScene == Sid andalso abs(TarX - X) =< 3 andalso abs(TarY - Y) =< 3;
                        true ->
                            case data_scene_cross:get(Plv) of
                                [] -> false;
                                Data ->
                                    NewSid = hd(Data),
                                    TarScene == NewSid andalso abs(TarX - X) =< 3 andalso abs(TarY - Y) =< 3
                            end
                    end
            end
    end.

%%完成任务
finish_guild_task(Player, TaskId) ->
    StTask = task_init:get_task_st(),
    ActiveList = StTask#st_task.activelist,
    case lists:keyfind(TaskId, #task.taskid, ActiveList) of
        false ->
            {err, 7};
        Task ->
            if Task#task.state /= ?TASK_ST_FINISH -> {err, 6};
                true ->
%%            case check_finish(Task) of
%%                {err, Code} ->
%%                    {err, Code};
%%                ok ->
                    LogListCl = [TaskId | StTask#st_task.loglist_cl],
                    ActiveList2 = lists:keydelete(TaskId, #task.taskid, ActiveList),
                    NewStTask = StTask#st_task{activelist = ActiveList2, loglist_cl = LogListCl},
                    task_init:set_task_st(NewStTask),
                    refresh_client_del_task(Player#player.sid, TaskId),
                    {ok, Task}
            end
    end.

to_log(Type) ->
    %%主线，支线,转职,飞仙任务才写日志
    Type == ?TASK_TYPE_MAIN orelse Type == ?TASK_TYPE_BRANCH orelse Type == ?TASK_TYPE_CHARGE_CRAEER orelse Type == ?TASK_TYPE_EQUIP orelse Type == ?TASK_TYPE_XIAN.


%%检查任务是否已完成
check_finish(Task) ->
    check_finish_helper(Task#task.finish, Task#task.state_data).


check_finish_helper([], _StateData) -> ok;

check_finish_helper([{Event, _Param} | L], StateData) ->
    case task_init:event_to_act(Event) of
        false -> {err, 11};
        Act ->
            case lists:keyfind(Act, 1, StateData) of
                false -> {err, 7};
                {Act, _, Cur, Tar} when Cur == Tar ->
                    check_finish_helper(L, StateData);
                _ ->
                    {err, 6}
            end
    end;
check_finish_helper([{Event, _, _} | L], StateData) ->
    case task_init:event_to_act(Event) of
        false -> {err, 11};
        Act ->
            case lists:keyfind(Act, 1, StateData) of
                false -> {err, 7};
                {Act, _, TarNum, CurNum} when TarNum == CurNum ->
                    check_finish_helper(L, StateData);
                _ ->
                    {err, 6}
            end
    end;

check_finish_helper(_, _StateData) ->
    {err, 11}.


%%根据类型删除任务
del_task_by_type(Type, Sid) ->
    StTask = task_init:get_task_st(),
    ActiveList = StTask#st_task.activelist,
    F = fun(Task, List) ->
        if Task#task.type == Type ->
            task:refresh_client_del_task(Sid, Task#task.taskid),
            List;
            true ->
                [Task | List]
        end
    end,
    NewActiveList = lists:foldl(F, [], ActiveList),
    NewStTask = StTask#st_task{activelist = NewActiveList},
    task_init:set_task_st(NewStTask).

del_task_by_type(Type) ->
    StTask = task_init:get_task_st(),
    ActiveList = StTask#st_task.activelist,
    F = fun(Task, List) ->
        if Task#task.type == Type ->
            List;
            true ->
                [Task | List]
        end
    end,
    NewActiveList = lists:foldl(F, [], ActiveList),
    NewStTask = StTask#st_task{activelist = NewActiveList},
    task_init:set_task_st(NewStTask).

%%删除任务
del_task(TaskId) ->
    StTask = task_init:get_task_st(),
    case lists:keytake(TaskId, #task.taskid, StTask#st_task.activelist) of
        false -> skip;
        {value, _, T} ->
            NewStTask = StTask#st_task{activelist = T, is_change = 1},
            task_init:set_task_st(NewStTask)
    end.


%%检查任务过期
check_task_timeout(Player, NowTime) ->
    StTask = task_init:get_task_st(),
    ActiveList = StTask#st_task.activelist,
    F = fun(Task, {List, P, Refresh}) ->
        if Task#task.drop_time > 0 andalso Task#task.drop_time < NowTime ->
            refresh_client_del_task(Player#player.sid, Task#task.taskid),
            {List, P, true};
            true ->
                {[Task | List], P, Refresh}
        end
    end,
    {NewPlayer, NewActiveList, IsRefresh} = lists:foldr(F, {[], Player, false}, ActiveList),
    if IsRefresh ->
        NewStTask = StTask#st_task{activelist = NewActiveList},
        task_init:set_task_st(NewStTask),
        task:refresh_task(NewPlayer),
%%        task:refresh_client_task_all(NewPlayer),
        NewPlayer;
        true ->
            NewPlayer
    end.

%%剧情ID存储
story(0, _Key, _Val, Sid) ->
    StTask = task_init:get_task_st(),
    {ok, Bin} = pt_300:write(30007, {[tuple_to_list(Item) || Item <- StTask#st_task.story]}),
    server_send:send_to_sid(Sid, Bin);
story(1, Key, Val, Sid) ->
    StTask = task_init:get_task_st(),
    KVList =
        case lists:keymember(Key, 1, StTask#st_task.story) of
            false ->
                [{Key, Val} | StTask#st_task.story];
            true ->
                lists:keyreplace(Key, 1, StTask#st_task.story, {Key, Val})
        end,
    NewStTask = StTask#st_task{story = KVList},
    task_init:set_task_st(NewStTask),
    {ok, Bin} = pt_300:write(30007, {[tuple_to_list(Item) || Item <- NewStTask#st_task.story]}),
    server_send:send_to_sid(Sid, Bin);
story(_, _Key, _Val, _Sid) ->
    ok.


cmd_trigger_task(Player, TaskId) ->
    F = fun(Type) ->
        case task_init:task_data(TaskId, Type) of
            [] -> skip;
            Task ->
                StTask = task_init:get_task_st(),
                case lists:keyfind(TaskId, #task.taskid, StTask#st_task.activelist) of
                    false -> skip;
                    _ -> refresh_client_del_task(Player#player.sid, TaskId)
                end,
                NowTime = util:unixtime(),
                NewTask = task_init:new_task(Task, NowTime),
                ActiveList = [NewTask | lists:keydelete(TaskId, #task.taskid, StTask#st_task.activelist)],
                NewStTask = StTask#st_task{activelist = ActiveList},
                task_init:set_task_st(NewStTask),
                refresh_client_new_task(Player#player.sid, NewTask)
        end
    end,
    lists:foreach(F, lists:seq(1, 10)).

cmd_del_task(Sid, TaskId) ->
    StTask = task_init:get_task_st(),
    case lists:keyfind(TaskId, #task.taskid, StTask#st_task.activelist) of
        false -> skip;
        _ ->
            NewStTask = StTask#st_task{activelist = lists:keydelete(TaskId, #task.taskid, StTask#st_task.activelist)},
            task_init:set_task_st(NewStTask),
            refresh_client_del_task(Sid, TaskId)
    end.

cmd_finish_task(Player) ->
    StTask = task_init:get_task_st(),
    F = fun(Task, {Log, CLog}) ->
        refresh_client_del_task(Player#player.sid, Task#task.taskid),
        goods:give_goods(Player, trans_task_goods_list(Player, Task#task.talkid, Task#task.goods)),
        if Task#task.type == ?TASK_TYPE_CYCLE ->
            ok;
            Task#task.type == ?TASK_TYPE_CONVOY ->
                Player#player.pid ! {finish_convoy};
            ok;
            true -> skip
        end,
        case to_log(Task#task.type) of
            true ->
                {[Task#task.taskid | Log], CLog};
            false ->
                {Log, [Task#task.taskid | CLog]}
        end
    end,
    {LogList, CLogList} = lists:foldl(F, {StTask#st_task.loglist, StTask#st_task.loglist_cl}, StTask#st_task.activelist),
    NewStTask = StTask#st_task{activelist = [], loglist = LogList, loglist_cl = CLogList},
    task_init:set_task_st(NewStTask),
    auto_accept_task(Player).

cmd_finish_lv_task(Player) ->
    StTask = task_init:get_task_st(),
    F = fun(Id) ->
        Task = data_task_main:get(Id),
        case lists:keyfind(lv, 1, Task#task.accept) of
            false -> [];
            {_, Lv} ->
                if Lv < Player#player.lv ->
                    [Id];
                    true ->
                        []
                end
        end
    end,
    LogIds1 = lists:flatmap(F, data_task_main:task_ids()),
    F1 = fun(Id) ->
        Task = data_task_branch:get(Id),
        case lists:keyfind(lv, 1, Task#task.accept) of
            false -> [];
            {_, Lv} ->
                if Lv < Player#player.lv ->
                    [Id];
                    true ->
                        []
                end
        end
    end,
    LogIds2 = lists:flatmap(F1, data_task_branch:task_ids()),

    F2 = fun(Id) ->
        Task = data_task_change_career:get(Id),
        case lists:keyfind(lv, 1, Task#task.accept) of
            false -> [];
            {_, Lv} ->
                if Lv < Player#player.lv ->
                    [Id];
                    true ->
                        []
                end
        end
    end,
    LogIds3 = lists:flatmap(F2, data_task_change_career:task_ids()),
    ?DEBUG("LogIds3 ~p~n", [LogIds3]),
    NewStTask = StTask#st_task{tasklist = [], activelist = [], loglist = LogIds1 ++ LogIds2 ++ LogIds3, loglist_cl = []},
    task_init:set_task_st(NewStTask),
    refresh_task(Player),
    auto_accept_task(Player),
    refresh_client_task_all(Player),
    ok.

trans_task_goods_list(Player, _TaskId, GoodsList) ->
    Fun = fun(Award, Out) ->
        case Award of
            {Career, GoodsType, Num} when Player#player.career =:= Career orelse Career =:= 0 ->
                [#give_goods{goods_id = GoodsType, num = Num, location = ?GOODS_LOCATION_BAG, bind = ?BIND, from = 1} | Out];
            {GoodsType, Num} ->
                [#give_goods{goods_id = GoodsType, num = Num, location = ?GOODS_LOCATION_BAG, bind = ?BIND, from = 1} | Out];
            _ ->
                %?PRINT("trans_task_goods_list error ~p TaskId ~p ~n",[Award,TaskId]),
                Out
        end
    end,
    lists:foldl(Fun, [], GoodsList).


cmd_task_check() ->
%%    F = fun(Tid) ->
%%        case data_task_main:get(Tid) of
%%            [] -> skip;
%%            Task ->
%%                SNpc = data_npc_transport:get(Task#task.npcid),
%%                ENpc = data_npc_transport:get(Task#task.endnpcid),
%%                if SNpc == [] ->
%%                    ?ERR(" main tid ~p startnpc ~p ~n", [Tid,Task#task.npcid]);
%%                     ENpc == [] ->
%%                    ?ERR("main  tid ~p endnpc ~p~n", [Tid,Task#task.endnpcid]);
%%                    true ->
%%                        skip
%%                end
%%        end
%%        end,
%%    lists:foreach(F, data_task_main:task_ids()),
%%    F1 = fun(Tid) ->
%%        case data_task_branch:get(Tid) of
%%            [] -> skip;
%%            Task ->
%%                SNpc = data_npc_transport:get(Task#task.npcid),
%%                ENpc = data_npc_transport:get(Task#task.endnpcid),
%%                if SNpc == [] ->
%%                    ?ERR("br tid ~p startnpc ~p ~n", [Tid,Task#task.npcid]);
%%                    ENpc == [] ->
%%                        ?ERR("br tid ~p endnpc ~p~n", [Tid,Task#task.endnpcid]);
%%                    true ->
%%                        skip
%%                end
%%        end
%%        end,
%%    lists:foreach(F1, data_task_branch:task_ids()),
    F = fun(Tid) ->
        case data_task_main:get(Tid) of
            [] -> skip;
            Task ->
                SNpc = data_talk:get(Task#task.talkid),
                ENpc = data_talk:get(Task#task.endtalkid),
                if SNpc == [] ->
                    ?ERR(" main tid ~p talkid ~p ~n", [Tid, Task#task.talkid]);
                    ENpc == [] ->
                        ?ERR("main  tid ~p endtalkid ~p~n", [Tid, Task#task.endtalkid]);
                    true ->
                        skip
                end
        end
    end,
    lists:foreach(F, data_task_main:task_ids()),
    F1 = fun(Tid) ->
        case data_task_branch:get(Tid) of
            [] -> skip;
            Task ->
                SNpc = data_talk:get(Task#task.talkid),
                ENpc = data_talk:get(Task#task.endtalkid),
                if SNpc == [] ->
                    ?ERR(" br tid ~p talkid ~p ~n", [Tid, Task#task.talkid]);
                    ENpc == [] ->
                        ?ERR("br  tid ~p endtalkid ~p~n", [Tid, Task#task.endtalkid]);
                    true ->
                        skip
                end
        end
    end,
    lists:foreach(F1, data_task_branch:task_ids()),
    ok.

cmd_reset_times() ->
%%    db:execute("update player_task_cycle set cycle =0,is_reward=0"),
    Sql = "select pc.pkey,ps.vip_lv from player_convoy as pc left join player_state as ps on pc.pkey = ps.pkey",
    Data = db:get_all(Sql),
    F = fun([Pkey, Vip]) ->
        case ets:lookup(?ETS_ONLINE, Pkey) of
            [] ->
                Sql1 = io_lib:format(<<"update player_convoy set times = ~p where pkey = ~p">>, [?TASK_CONVOY_TIMES(Vip), Pkey]),
                db:execute(Sql1),
                ok;
            [Online] ->
                Online#ets_online.pid ! reset_task_times,
                ok
        end
    end,
    lists:foreach(F, Data),
    ok.

reset_task_times(Player) ->
    Convoy = task_convoy:get_convoy(),
    task_convoy:set_convoy(Convoy#task_convoy{times = ?TASK_CONVOY_TIMES(Player#player.vip_lv)}),
%%    Cycle = task_cycle:get_cycle_task(),
%%    task_cycle:set_cycle_task(Cycle#task_cycle{cycle = 0, is_reward = 0}),
    ok.

%%
cmd_check_task1() ->
    MainIds = data_task_main:task_ids(),
    cmd_check_loop1(hd(MainIds), MainIds).

cmd_check_loop1(Tid, Ids) ->
    case data_task_main:get(Tid) of
        [] ->
            ?ERR(" tid ~p/~p~n", [Tid, Ids]),
            err;
        Task ->
            cmd_check_loop1(Task#task.next, lists:delete(Tid, Ids))
    end.


cmd_check_task() ->
    MainIds = data_task_main:task_ids(),
    cmd_check_loop(lists:last(MainIds), MainIds).

cmd_check_loop(Tid, Ids) ->
    case data_task_main:get(Tid) of
        [] ->
            ?ERR(" tid ~p/~p~n", [Tid, Ids]),
            err;
        Task ->
            case lists:keyfind(task, 1, Task#task.accept) of
                false ->
                    ?ERR(" udef tid ~p/~p~n", [Tid, Ids]);
                {_, Id} ->

                    cmd_check_loop(Id, lists:delete(Tid, Ids))
            end
    end.

cmd_tlv(Player, Lv) ->
    StTask = task_init:get_task_st(),
    F = fun(Task) ->
        refresh_client_del_task(Player#player.sid, Task#task.taskid)
    end,
    lists:foreach(F, StTask#st_task.activelist),
    NewStTask = StTask#st_task{activelist = []},
    task_init:set_task_st(NewStTask),
    Player1 = cmd_loop_main(hd(data_task_main:task_ids()), Player, Lv),
    auto_accept_task(Player1),
    {ok, Player1}.


cmd_loop_main(Tid, Player, Lv) ->
    if Player#player.lv > Lv -> Player;
        true ->
            case data_task_main:get(Tid) of
                [] -> Player;
                Task ->
                    StTask = task_init:get_task_st(),
                    case lists:member(Tid, StTask#st_task.loglist) of
                        true ->
                            cmd_loop_main(Task#task.next, Player, Lv);
                        false ->
                            case check_accept(Player, Task, StTask#st_task.loglist) of
                                ok ->
                                    case lists:keyfind(uplv, 1, Task#task.finish) of
                                        false ->
                                            NewStTask = StTask#st_task{loglist = [Tid | lists:delete(Tid, StTask#st_task.loglist)], loglist_cl = []},
                                            task_init:set_task_st(NewStTask),
                                            {ok, NewPlayer} = goods:give_goods(Player, trans_task_goods_list(Player, Tid, Task#task.goods)),
                                            cmd_loop_main(Task#task.next, NewPlayer, Lv);
                                        {uplv, UpLv} ->
                                            if Player#player.lv >= UpLv ->
                                                NewStTask = StTask#st_task{loglist = [Tid | lists:delete(Tid, StTask#st_task.loglist)], loglist_cl = []},
                                                task_init:set_task_st(NewStTask),
                                                {ok, NewPlayer} = goods:give_goods(Player, trans_task_goods_list(Player, Tid, Task#task.goods)),
                                                cmd_loop_main(Task#task.next, NewPlayer, Lv);
                                                true ->
                                                    Player
                                            end
                                    end
                            end;
                        _ ->
                            Player
                    end
            end
    end.


cmd_refresh_task() ->
    F = fun(Online) ->
        Online#ets_online.pid ! cmd_refresh_task
    end,
    lists:foreach(F, ets:tab2list(?ETS_ONLINE)).

cmd_auto_main_task(Player) ->
    StTask = task_init:get_task_st(),
    MainTasks = [Task || Task <- StTask#st_task.activelist, Task#task.type == ?TASK_TYPE_MAIN],
    if
        MainTasks == [] ->
            {ok, Bin1} = pt_130:write(13099, {221, util:term_to_string(0), util:term_to_string(0), util:term_to_string(0), util:term_to_string(0)}),
            server_send:send_to_sid(Player#player.sid, Bin1),
            {ok, Bin2} = pt_130:write(13099, {223, util:term_to_string(0), util:term_to_string(0), util:term_to_string(0), util:term_to_string(0)}),
            server_send:send_to_sid(Player#player.sid, Bin2),
            Player;
        true ->
            [FirstTask | _] = MainTasks,
            case FirstTask#task.state of
                ?TASK_ST_FINISH when FirstTask#task.endnpcid =/= 0 ->
                    self() ! {robot_end_task, FirstTask#task.endnpcid, FirstTask},
                    Player;
                ?TASK_ST_FINISH ->
                    {ok, Bin} = pt_130:write(13099, {225, util:term_to_string(FirstTask#task.taskid), util:term_to_string(0), util:term_to_string(0), util:term_to_string(0)}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    Player;
                _ ->
                    case FirstTask#task.finish of
                        [{dungeon, Did, _N}] ->
                            self() ! {robot_finish_dungeon, Did, FirstTask},
                            Player;
                        [{uplv, _NeedLv}] ->
                            {ok, Bin2} = pt_130:write(13099, {223, util:term_to_string(0), util:term_to_string(0), util:term_to_string(0), util:term_to_string(0)}),
                            server_send:send_to_sid(Player#player.sid, Bin2),
                            Player;
                        [{npc, NpcId}] ->
                            self() ! {robot_finish_npctask, NpcId, FirstTask},
                            Player;
                        [{kill, MonId, _Count}] ->
                            self() ! {robot_finish_killmontask, MonId, FirstTask},
                            Player;
                        _ ->
                            NewPlayer = cmd_finish_task_by_taskid(Player, FirstTask#task.taskid),
                            NewPlayer
                    end
            end
    end.

cmd_auto_cycle_task(Player) ->
    StTask = task_init:get_task_st(),
    CycleTasks = [Task || Task <- StTask#st_task.activelist, Task#task.type == ?TASK_TYPE_CYCLE],
    if
        CycleTasks == [] ->
%%            io:format("player cannot finish cycle task, current lv ===~p~n",[Player#player.lv]),
            {ok, Bin} = pt_130:write(13099, {224, util:term_to_string(0), util:term_to_string(0), util:term_to_string(0), util:term_to_string(0)}),
            server_send:send_to_sid(Player#player.sid, Bin),
            Player;
        true ->
            [FirstTask | _] = CycleTasks,
            case FirstTask#task.state of
                ?TASK_ST_FINISH when FirstTask#task.endnpcid =/= 0 ->
                    self() ! {robot_end_task, FirstTask#task.endnpcid, FirstTask},
                    Player;
                ?TASK_ST_FINISH ->
%%                    io:format("finish cycle taskid = ~p~n",[FirstTask#task.taskid]),
                    {ok, Bin} = pt_130:write(13099, {225, util:term_to_string(FirstTask#task.taskid), util:term_to_string(0), util:term_to_string(0), util:term_to_string(0)}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    Player;
                _ ->
                    case FirstTask#task.finish of
                        [{dungeon, Did, _N}] ->
                            self() ! {robot_finish_dungeon, Did, FirstTask},
                            Player;
                        [{uplv, _NeedLv}] ->
                            {ok, Bin2} = pt_130:write(13099, {223, util:term_to_string(0), util:term_to_string(0), util:term_to_string(0), util:term_to_string(0)}),
                            server_send:send_to_sid(Player#player.sid, Bin2),
                            Player;
                        [{npc, NpcId}] ->
                            self() ! {robot_finish_npctask, NpcId, FirstTask},
                            Player;
                        [{kill, MonId, _Count}] ->
                            self() ! {robot_finish_killmontask, MonId, FirstTask},
                            Player;
                        _ ->
                            NewPlayer = cmd_finish_task_by_taskid(Player, FirstTask#task.taskid),
                            NewPlayer
                    end
            end
    end.

cmd_finish_task_by_taskid(Player, Tid) ->
    StTask = task_init:get_task_st(),
    F = fun(Task, {Log, CLog, AccPlayer}) ->
        refresh_client_del_task(Player#player.sid, Task#task.taskid),
        {ok, NewAccPlayer} = goods:give_goods(AccPlayer, trans_task_goods_list(Player, Task#task.talkid, Task#task.goods)),
        if
            Task#task.type == ?TASK_TYPE_CYCLE ->
                ok;
            Task#task.type == ?TASK_TYPE_CONVOY ->
                Player#player.pid ! {finish_convoy};
            ok;
            true -> skip
        end,
        case to_log(Task#task.type) of
            true ->
                {[Task#task.taskid | Log], CLog, NewAccPlayer};
            false ->
                {Log, [Task#task.taskid | CLog], NewAccPlayer}
        end
    end,
    {LogList, CLogList, NewPlayer} = lists:foldl(F, {StTask#st_task.loglist, StTask#st_task.loglist_cl, Player}, [T || T <- StTask#st_task.activelist, T#task.taskid == Tid]),
    NewStTask = StTask#st_task{activelist = [], loglist = LogList, loglist_cl = CLogList},
    task_init:set_task_st(NewStTask),
    io:format("player finish task ~p~n,current player lv ~p~n", [Tid, NewPlayer#player.lv]),
    NewPlayer2 = do_after_finish_task(NewPlayer, Tid),
    lib_dict:put(robot_collect_mkeys, []),
    auto_accept_task(NewPlayer2).

do_after_finish_task(_, _) -> ok.

gm_test() ->
    Data = task_init:get_task_st(),
    ?ERR("Data ~p~n", [Data]),
    ok.


