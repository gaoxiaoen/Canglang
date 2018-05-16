%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 任务加载
%%% @end
%%% Created : 06. 九月 2015 上午11:01
%%%-------------------------------------------------------------------
-module(task_init).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("task.hrl").

%% API
-export([
    init/1,
    init_delete_task/0,
    pack_task_content/1,
    event_to_act/1,
    logout/0,
    timer_update/0,
    new_task/2,
    get_task_st/0,
    set_task_st/1,
    update_one_task/1,
    task_data/2,
    task_act/2,
    cmd_delete_task/1,
    delete_task/2,
    update_to_db/1
]).

filter_task() ->
    [600001, 600002, 600003, 600004, 600005].
init_delete_task() ->
    ets:insert(?ETS_TASK_FILTER, #task_filter{tid = filter_task()}).

%% stateData = [{type,id,tarnum,curnum}]
init(Player) ->
    NowTime = util:unixtime(),
    FilterList = filter_task(),
    F = fun({Tid, Type, State, StateData, AcceptTime, DropTime, Times, TimesLim}) ->
        if DropTime > 0 andalso NowTime > DropTime ->
            %%任务过期
            [];
        %%退出仙盟
            Type == ?TASK_TYPE_GUILD andalso Player#player.guild#st_guild.guild_key == 0 ->
                [];
            true ->
                case lists:member(Tid, FilterList) of
                    true -> [];
                    false ->
                        case task_data(Tid, Type) of
                            [] -> [];
                            Task ->
                                NewStateData = check_statedata(Task, StateData),
                                Act = task_act(NewStateData, 0),
                                [
                                    Task#task{talkid = Tid, type = Type, accept_time = AcceptTime, drop_time = DropTime, state = State, state_data = NewStateData, act = Act, times = Times, times_lim = TimesLim}
                                ]
                        end
                end
        end
    end,
    StTask =
        case player_util:is_new_role(Player) of
            true ->
                first_task(Player, NowTime);
            false ->
                case task_load:get_task_bag(Player#player.key) of
                    [] ->
                        first_task(Player, NowTime);
                    [TaskBag, TaskLog, TaskLogClean, Timestamp, Story] ->
                        ActiveList = lists:flatmap(F, util:bitstring_to_term(TaskBag)),
                        LogList = util:bitstring_to_term(TaskLog),
                        LogCleanList =
                            case util:is_same_date(Timestamp, NowTime) of
                                true ->
                                    util:bitstring_to_term(TaskLogClean);
                                false ->
                                    []
                            end,
                        #st_task{pkey = Player#player.key, activelist = ActiveList, loglist = LogList, loglist_cl = LogCleanList, timestamp = NowTime, story = util:bitstring_to_term(Story)}
                end
        end,
    lib_dict:put(?PROC_STATUS_TASK, StTask),
    %%初始化跑环任务
    task_cycle:init(Player, NowTime),
    task_guild:init(Player, NowTime),
    Player1 = task_convoy:init(Player, NowTime),
    manor_war_task:init(Player),
    task_reward:refresh_task(Player, false),
    task_bet:refresh_task(Player, NowTime, false),
    task_event:preact_finish(Player),
    task_dark:refresh_task(Player, false),
    task_xian:refresh_task(Player, false),
    task:auto_accept_task(Player),
    task_equip:init(Player),
    Player1.


%% 任务内容修正检查
check_statedata(Task, StateData) ->
    NewStateData = finish_content(Task#task.finish, []),
    F = fun({Act, Param1, _, _}) ->
        case Act of
            ?TASK_ACT_DUNGEON ->
                case lists:keyfind(Act, 1, NewStateData) of
                    false -> false;
                    {_, Param1_1, _, _} ->
                        Param1 == Param1_1
                end;
            _ ->
                lists:keymember(Act, 1, NewStateData)
        end
    end,
    Data =
        case lists:all(F, StateData) of
            true ->
                StateData;
            false ->
                NewStateData
        end,
    Data.

%%fix_statedata(Tid, StateData) ->
%%    F = fun({Act, P1, P2, P3}) ->
%%        case Act of
%%            ?TASK_ACT_NPC when Tid == 15220 ->
%%                {Act, 13012, P2, P3};
%%            _ ->
%%                {Act, P1, P2, P3}
%%        end
%%    end,
%%    lists:map(F, StateData).


%%获取任务基础数据
task_data(TaskId, Type) when Type == ?TASK_TYPE_MAIN ->
    case data_task_main:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_BRANCH ->
    case data_task_branch:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_GUILD ->
    case data_task_guild:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_CYCLE ->
    case data_task_cycle:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_CONVOY ->
    case data_task_convoy:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_BET ->
    case data_task_bet:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_MANOR_WAR ->
    case data_task_manor:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_REWARD ->
    case data_task_reward:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_DARK ->
    case data_task_dark:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_CHARGE_CRAEER ->
    case data_task_change_career:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_EQUIP ->
    case data_task_equip:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(TaskId, Type) when Type == ?TASK_TYPE_XIAN ->
    case data_task_xian:get(TaskId) of
        [] -> [];
        Task ->
            pack_task_content(Task)
    end;
task_data(_TaskId, _Type) -> [].


%%第一个任务
first_task(Player, NowTime) ->
    Tid = hd(data_task_main:task_ids()),
    Task1 = task_data(Tid, ?TASK_TYPE_MAIN),
    Task2 = new_task(Task1, util:unixtime()),
    StTask = #st_task{pkey = Player#player.key, activelist = [Task2], timestamp = NowTime, is_change = 1},
    set_task_st(StTask),
    task_cron:set_accept(Task2#task.taskid, Task2#task.name, Task2#task.type),
    StTask.


%%创建新任务
new_task(Task, Now) ->
    Task#task{state = ?TASK_ST_ACCEPT, accept_time = Now}.

%%    StateData = finish_content(Task#task.finish, []),
%%    Act = task_act(Task#task.state_data, 0),
%%    if Task#task.taskid == 11440 ->
%%        StateData = [{Act, Tar, TarNum, TarNum} || {Act, Tar, TarNum, _CurNum} <- Task#task.state_data],
%%        Task#task{state = ?TASK_ST_FINISH, accept_time = Now, state_data = StateData};
%%        true ->
%%            Task#task{state = ?TASK_ST_ACCEPT, accept_time = Now}
%%    end.


pack_task_content(Task) ->
    StateData = finish_content(Task#task.finish, []),
    Act = task_act(StateData, 0),
    Task#task{state_data = StateData, act = Act}.

event_to_act(Event) ->
    case lists:keyfind(Event, 1, ?TASK_ACT_EVENT_LIST) of
        false ->
            ?ERR("task_act_event ~p undefined", [Event]),
            false;
        {_, Act} -> Act
    end.

%%任务动作类型（任务内容）
finish_content([], State) -> State;
finish_content([{Event, Param} | L], State) ->
    case event_to_act(Event) of
        false ->
            finish_content(L, State);
        Act ->
            case lists:member(Event, ?TASK_SPEC_ACT_EVENT_LIST) of
                true ->
                    finish_content(L, [{Act, 0, Param, 0} | State]);
                false ->
                    finish_content(L, [{Act, Param, 1, 0} | State])
            end
    end;
finish_content([{Event, Param1, Param2} | L], State) ->
    case event_to_act(Event) of
        false ->
            finish_content(L, State);
        Act ->
            finish_content(L, [{Act, Param1, Param2, 0} | State])
    end;
finish_content([_ | L], State) ->
    finish_content(L, State).

task_act([], Act) -> Act;
task_act([{TaskAct, _type, _n1, _n2} | L], _Act) ->
    task_act(L, TaskAct).


%%更新已接任务 (不写数据库)
update_one_task(Task) ->
    StTask = get_task_st(),
    case lists:keyfind(Task#task.taskid, #task.taskid, StTask#st_task.activelist) of
        false ->
            ?ERR("update task fail undef ~p~n", [Task#task.taskid]),
            false;
        _Task2 ->
            ActiveList = lists:keyreplace(Task#task.taskid, #task.taskid, StTask#st_task.activelist, Task),
            set_task_st(StTask#st_task{activelist = ActiveList})
    end.

%%更新任务数据 to dict
set_task_st(StTask) ->
    lib_dict:put(?PROC_STATUS_TASK, StTask#st_task{is_change = 1}).
set_task_st1(StTask) ->
    lib_dict:put(?PROC_STATUS_TASK, StTask).


%%获取任务数据
get_task_st() ->
    lib_dict:get(?PROC_STATUS_TASK).

%%玩家下线，同步任务数据
logout() ->
    StTask = get_task_st(),
    if StTask#st_task.is_change /= 0 ->
        update_to_db(StTask);
        true -> skip
    end,
    task_cycle:logout(),
    task_convoy:logout(),
    task_guild:logout(),
    ok.

%%定时同步任务数据
timer_update() ->
    StTask = get_task_st(),
    if StTask#st_task.is_change /= 0 ->
        update_to_db(StTask),
        set_task_st1(StTask#st_task{is_change = 0});
        true -> skip
    end,
    task_cycle:timer_update(),
    task_convoy:timer_update(),
    task_guild:timer_update(),
    ok.

%%更新任务数据到库
update_to_db(StTask) ->
    ActiveTaskList = StTask#st_task.activelist,
    F = fun(Task) ->
        {Task#task.taskid, Task#task.type, Task#task.state, Task#task.state_data, Task#task.accept_time, Task#task.drop_time, Task#task.times, Task#task.times_lim}
    end,
    TaskBag = lists:map(F, ActiveTaskList),
    task_load:replace_task_bag(StTask#st_task.pkey, TaskBag, StTask#st_task.loglist, StTask#st_task.loglist_cl, StTask#st_task.timestamp, StTask#st_task.story).


%%删除任务
cmd_delete_task(TaskId) ->
    case ets:lookup(?ETS_TASK_FILTER, 0) of
        [] ->
            ets:insert(?ETS_TASK_FILTER, #task_filter{tid = [TaskId]});
        [Ets] ->
            ets:insert(?ETS_TASK_FILTER, Ets#task_filter{tid = [TaskId | lists:delete(TaskId, Ets#task_filter.tid)]})
    end,
    F = fun(Online) ->
        Online#ets_online.pid ! {delete_task, TaskId}
    end,
    lists:foreach(F, ets:tab2list(?ETS_ONLINE)),
    ok.

delete_task(Sid, TaskId) ->
    St = get_task_st(),
    NewSt = St#st_task{
        tasklist = lists:keydelete(TaskId, #task.taskid, St#st_task.tasklist),
        activelist = lists:keydelete(TaskId, #task.taskid, St#st_task.activelist),
        loglist = lists:delete(TaskId, St#st_task.loglist)
    },
    set_task_st(NewSt),
    task:refresh_client_del_task(Sid, TaskId),
    ok.