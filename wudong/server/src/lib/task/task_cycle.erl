%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 天天跑环
%%% @end
%%% Created : 02. 十一月 2015 14:26
%%%-------------------------------------------------------------------
-module(task_cycle).
-author("hxming").

-include("task.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("money.hrl").
-include("achieve.hrl").
-include("sword_pool.hrl").
%% API
-export([
    init/2     %%初始化
    , logout/0
    , upgrade_lv/1
    , midnight_refresh/2        %%零点刷新任务
    , finish_task_cycle/1        %%提交跑环任务
    , finish_cost/1
    , finish_all/1    %%一键完成跑环任务
    , timer_update/0
    , get_state/0
    , get_cycle_task/0
    , get_notice_state/0
    , get_cycle_times/0
]).
-export([is_finish/0]).

-export([cmd_cycle/1, cmd_reset/1, cmd_task_check/0]).

%%初始化玩家跑环数据
init(Player, NowTime) ->
    case player_util:is_new_role(Player) of
        true ->
            TaskCycle = #task_cycle{pkey = Player#player.key, timestamp = NowTime},
            lib_dict:put(?PROC_STATUS_TASK_CYCLE, TaskCycle);
        false ->
            case task_load:get_task_cycle(Player#player.key) of
                [] ->
                    TaskCycle =
                        case get_task(Player#player.lv) of
                            0 ->
                                #task_cycle{pkey = Player#player.key, timestamp = NowTime};
                            Tid ->
                                Task = task_init:task_data(Tid, ?TASK_TYPE_CYCLE),
                                task:accept_cycle_task(Player#player.sid, Task#task{times = 1, times_lim = ?TASK_CYCLE_LIMIT}, false),
                                #task_cycle{pkey = Player#player.key, tid = Tid, timestamp = NowTime, is_change = 1}
                        end,
                    lib_dict:put(?PROC_STATUS_TASK_CYCLE, TaskCycle);
                [Cycle, Tid, Log, Timestamp, IsReward] ->
                    case util:is_same_date(Timestamp, NowTime) of
                        true ->
                            TaskCycle = #task_cycle{
                                pkey = Player#player.key,
                                tid = Tid,
                                cycle = Cycle,
                                log = util:bitstring_to_term(Log),
                                timestamp = Timestamp,
                                is_reward = IsReward
                            },
                            lib_dict:put(?PROC_STATUS_TASK_CYCLE, TaskCycle);
                        false ->
                            case task:get_task_by_type(?TASK_TYPE_CYCLE) of
                                [] ->
                                    TaskCycle =
                                        case get_task(Player#player.lv) of
                                            0 ->
                                                #task_cycle{pkey = Player#player.key, timestamp = NowTime, is_change = 1};
                                            NewTid ->
                                                Task = task_init:task_data(NewTid, ?TASK_TYPE_CYCLE),
                                                task:accept_cycle_task(Player#player.sid, Task#task{times = 1, times_lim = ?TASK_CYCLE_LIMIT}, false),
                                                #task_cycle{pkey = Player#player.key, tid = NewTid, timestamp = NowTime, is_change = 1}
                                        end;
                                [Task | _] ->
                                    task:upgrade_cycle_task(Task#task{times = 1}),
                                    TaskCycle = #task_cycle{pkey = Player#player.key, tid = Task#task.taskid, timestamp = NowTime, is_change = 1}
                            end,
                            lib_dict:put(?PROC_STATUS_TASK_CYCLE, TaskCycle)
                    end
            end
    end.

logout() ->
    TaskCycle = get_cycle_task(),
    if TaskCycle#task_cycle.is_change /= 0 ->
        task_load:replace_task_cycle(TaskCycle);
        true -> skip
    end.

timer_update() ->
    TaskCycle = get_cycle_task(),
    if TaskCycle#task_cycle.is_change /= 0 ->
        TaskCycle = get_cycle_task(),
        task_load:replace_task_cycle(TaskCycle),
        lib_dict:put(?PROC_STATUS_TASK_CYCLE, TaskCycle#task_cycle{is_change = 0});
        true -> skip
    end,
    ok.

%%零点刷新任务
midnight_refresh(Player, NowTime) ->
    TaskCycle = get_cycle_task(),
    NewTaskCycle =
        case task:get_task_by_type(?TASK_TYPE_CYCLE) of
            [] ->
                case get_task(Player#player.lv) of
                    0 ->
                        TaskCycle#task_cycle{cycle = 0, log = [], is_reward = ?TASK_CYCLE_REWARD_STATE_UNFINISH, timestamp = NowTime, is_change = 1};
                    Tid ->
                        Task = task_init:task_data(Tid, ?TASK_TYPE_CYCLE),
                        task:accept_cycle_task(Player#player.sid, Task#task{times = 1, times_lim = ?TASK_CYCLE_LIMIT}, true),
                        TaskCycle#task_cycle{cycle = 0, tid = Tid, log = [], is_reward = ?TASK_CYCLE_REWARD_STATE_UNFINISH, timestamp = NowTime, is_change = 1}
                end;
            [Task | _] ->
                task:accept_cycle_task(Player#player.sid, Task#task{times = 1}, true),
                TaskCycle#task_cycle{cycle = 0, tid = Task#task.taskid, log = [], is_reward = ?TASK_CYCLE_REWARD_STATE_UNFINISH, timestamp = NowTime, is_change = 1}
        end,
    lib_dict:put(?PROC_STATUS_TASK_CYCLE, NewTaskCycle).

%%升级,自动接任务
upgrade_lv(Player) ->
    MinLv = data_task_cycle_conf:min_lv(),
    if Player#player.lv >= MinLv ->
        case task:get_task_by_type(?TASK_TYPE_CYCLE) of
            [] ->
                TaskCycle = get_cycle_task(),
                if TaskCycle#task_cycle.cycle < ?TASK_CYCLE_LIMIT ->
                    case get_task(Player#player.lv) of
                        0 ->
                            skip;
                        Tid ->
                            Task = task_init:task_data(Tid, ?TASK_TYPE_CYCLE),
                            task:accept_cycle_task(Player#player.sid, Task#task{times = 1, times_lim = ?TASK_CYCLE_LIMIT}, true),
                            NewTaskCycle = TaskCycle#task_cycle{tid = Tid, is_change = 1},
                            lib_dict:put(?PROC_STATUS_TASK_CYCLE, NewTaskCycle)
                    end;
                    true -> skip
                end;
            _ ->
                skip
        end;
        true ->
            skip
    end.


%%获取任务ID
get_task(Plv) ->
    case data_task_cycle_conf:get_task(Plv) of
        [] -> 0;
        TaskIds ->
            util:list_rand(TaskIds)
    end.

get_cycle_task() ->
    lib_dict:get(?PROC_STATUS_TASK_CYCLE).


%%提交了跑环任务，新环处理
finish_task_cycle(Player) ->
    sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_TASK_CYCLE),
    TaskCycle = get_cycle_task(),
    %%满环了，发放满换奖励
    Cycle = TaskCycle#task_cycle.cycle + 1,
    if Cycle >= ?TASK_CYCLE_LIMIT ->
        NewTaskCycle = TaskCycle#task_cycle{tid = 0, is_reward = ?TASK_CYCLE_REWARD_STATE_FINISH, cycle = Cycle, is_change = 1},
        lib_dict:put(?PROC_STATUS_TASK_CYCLE, NewTaskCycle),
        ExtraAward = data_task_cycle_reward:get_award(Player#player.lv),
        {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(7, ExtraAward)),
        achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2001, 0, 1),
        %%资源找回
        findback_src:fb_trigger_src(Player, 20, {0, util:unixtime()}),
        task_reward:refresh_task(Player, true),
        NewPlayer;
        true ->
            case task:get_task_by_type(?TASK_TYPE_CYCLE) of
                [] ->
                    Tid = get_task(Player#player.lv),
                    NewTaskCycle = TaskCycle#task_cycle{tid = Tid, cycle = Cycle, is_change = 1},
                    lib_dict:put(?PROC_STATUS_TASK_CYCLE, NewTaskCycle),
                    case task_init:task_data(Tid, ?TASK_TYPE_CYCLE) of
                        [] -> ok;
                        Task ->
                            task:accept_cycle_task(Player#player.sid, Task#task{times = Cycle + 1, times_lim = ?TASK_CYCLE_LIMIT}, true)
                    end;
                _ ->
                    ok
            end,
            Player
    end.

finish_cost(Player) ->
    {GoldCost, GoldBack} = get_cost(Player),
    State = ?IF_ELSE(GoldCost == 0, 0, 1),
    TaskCycle = get_cycle_task(),
    Times = ?TASK_CYCLE_LIMIT - TaskCycle#task_cycle.cycle,
    TaskGoods =
        if TaskCycle#task_cycle.tid == 0 -> [];
            true ->
                case task_init:task_data(TaskCycle#task_cycle.tid, ?TASK_TYPE_CYCLE) of
                    [] -> [];
                    Task ->
                        lists:foldl(fun(Award, Out) ->
                            case Award of
                                {Career, GoodsType, Num} when Player#player.career =:= Career orelse Career == 0 ->
                                    [[GoodsType, Num] | Out];
                                {GoodsType, Num} ->
                                    [[GoodsType, Num] | Out];
                                _ ->
                                    Out
                            end
                                    end, [], Task#task.goods)
                end
        end,
    FinishGoods = goods:pack_goods(data_task_cycle_reward:get_award(Player#player.lv)),
    {State, GoldCost * Times, GoldBack * Times, TaskGoods, FinishGoods}.

get_cost(_Player) ->
    {GoldCost, GoldBack} = {3, 1},
%%        data_vip_args:get(24, Player#player.vip_lv),
    {GoldCost, GoldBack}.
%%一键完成
finish_all(Player) ->
    {GoldCost, GoldBack} = get_cost(Player),
    if GoldCost == 0 -> {28, Player};
        true ->
            TaskCycle = get_cycle_task(),
            {Times, TidList} = get_can_finish_times(TaskCycle, Player#player.lv),
            if Times == 0 -> {9, Player};
                true ->
                    Gold = GoldCost * Times,
                    BGold = GoldBack * Times,
                    case money:is_enough(Player, Gold, gold) of
                        false -> {10, Player};
                        true ->
                            Player1 = money:add_no_bind_gold(Player, -Gold, 8, 0, 0),
                            Player2 =
                                case data_vip_args:get(55, Player#player.vip_lv) of
                                    1 ->
                                        money:add_bind_gold(Player1, BGold, 8, 0, 0);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           _ ->
                                        Player1
                                end,
                            Player3 = give_task_reward(Player2, TidList),
                            NewTaskCycle = TaskCycle#task_cycle{cycle = ?TASK_CYCLE_LIMIT, is_reward = ?TASK_CYCLE_REWARD_STATE_FINISH, tid = 0, is_change = 1},
                            lib_dict:put(?PROC_STATUS_TASK_CYCLE, NewTaskCycle),
                            %%删除任务
                            task:refresh_client_del_task(Player#player.sid, TaskCycle#task_cycle.tid),
                            task:del_task_by_type(?TASK_TYPE_CYCLE, Player#player.sid),
                            task_event:event(?TASK_ACT_TASK_TYPE, {?TASK_TYPE_CYCLE, Times}),
                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2001, 0, 1),
                            sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_TASK_CYCLE, Times),
                            %%资源找回
                            act_hi_fan_tian:trigger_finish_api(Player,4,Times),
                            findback_src:fb_trigger_src(Player, 20, {Times, 0}),
                            task_reward:refresh_task(Player, true),
                            {1, Player3}
                    end
            end
    end.

%%获取可完成的环数
%%Return cycle,tid
get_can_finish_times(TaskCycle, Plv) ->
    if TaskCycle#task_cycle.cycle >= ?TASK_CYCLE_LIMIT -> {0, []};
        true ->
            case task:get_task_by_type(?TASK_TYPE_CYCLE) of
                [] ->
                    TidList = lists:map(fun(_) ->
                        get_task(Plv) end, lists:seq(1, ?TASK_CYCLE_LIMIT - TaskCycle#task_cycle.cycle)),
                    {?TASK_CYCLE_LIMIT - TaskCycle#task_cycle.cycle, TidList};
                [_Task | _] ->
                    TidList = lists:map(fun(_) ->
                        get_task(Plv) end, lists:seq(1, ?TASK_CYCLE_LIMIT - TaskCycle#task_cycle.cycle - 1)),
                    {?TASK_CYCLE_LIMIT - TaskCycle#task_cycle.cycle, [_Task#task.taskid | TidList]}
            end
    end.


%%一键完成奖励
give_task_reward(Player, TidList) ->
    ExtraAward = data_task_cycle_reward:get_award(Player#player.lv),
    F = fun(Tid) ->
        case task_init:task_data(Tid, ?TASK_TYPE_CYCLE) of
            [] -> [];
            Task ->
                task:trans_task_goods_list(Player, Tid, Task#task.goods)
        end
        end,
    GoodsList = lists:flatmap(F, TidList) ++ goods:make_give_goods_list(1, ExtraAward),
    {ok, NewPlayer} = goods:give_goods(Player, GoodsList),
    %%资源找回
    findback_src:fb_trigger_src(Player, 20, {0, util:unixtime()}),
    NewPlayer.

get_state() ->
    TaskCycle = get_cycle_task(),
    if TaskCycle#task_cycle.is_reward == ?TASK_CYCLE_REWARD_STATE_UNREWARD -> 1;
        true ->
            TaskList = task:get_task_by_type(?TASK_TYPE_CYCLE),
            F = fun(Task) ->
                Task#task.state == ?TASK_ST_FINISH
                end,
            case lists:any(F, TaskList) of
                true -> 1;
                false -> 0
            end
    end.

cmd_cycle(Cycle) ->
    TaskCycle = get_cycle_task(),
    NewCycle = ?IF_ELSE(Cycle < 0 orelse Cycle > ?TASK_CYCLE_LIMIT, 1, Cycle),
    lib_dict:put(?PROC_STATUS_TASK_CYCLE, TaskCycle#task_cycle{cycle = NewCycle, is_change = 1}),
    ok.

cmd_reset(Player) ->
    Now = util:unixtime(),
    task:del_task_by_type(?TASK_TYPE_CYCLE, Player#player.sid),
    NewTaskCycle = #task_cycle{pkey = Player#player.key, timestamp = Now},
    lib_dict:put(?PROC_STATUS_TASK_CYCLE, NewTaskCycle),
    ok.

cmd_task_check() ->
    F = fun(Tid) ->
        Task = data_task_guild:get(Tid),
        F1 = fun({_Type, TarId, _TarNum}) ->
            case data_mon_transport:get(TarId) of
                [] ->
                    ?ERR("tid ~p,tarid ~p~n", [Tid, TarId]);
                _ -> skip
            end
             end,
        lists:foreach(F1, Task#task.finish)
        end,
    lists:foreach(F, data_task_guild:task_ids()).

get_notice_state() ->
    TaskCycle = get_cycle_task(),
    ?IF_ELSE(TaskCycle#task_cycle.cycle >= ?TASK_CYCLE_LIMIT, {0, [{time, 0}]}, {1, [{time, ?TASK_CYCLE_LIMIT - TaskCycle#task_cycle.cycle}]}).


get_cycle_times() ->
    TaskCycle = get_cycle_task(),
    max(0, ?TASK_CYCLE_LIMIT - TaskCycle#task_cycle.cycle).

%%经常跑环任务是否全部完成
is_finish() ->
    TaskCycle = get_cycle_task(),
    if TaskCycle#task_cycle.cycle >= ?TASK_CYCLE_LIMIT -> true;
        true ->
            false
    end.
