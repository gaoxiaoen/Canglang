%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 二月 2017 20:47
%%%-------------------------------------------------------------------
-module(task_guild).


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
    , midnight_refresh/2        %%零点刷新任务
    , finish_task_guild/1        %%提交跑环任务
    , finish_cost/1
    , finish_all/1    %%一键完成跑环任务
    , timer_update/0
    , get_state/0
    , get_guild_task/0
    , get_notice_state/0
    , get_guild_times/0
    , enter_guild/1
    , quit_guild/1
    , get_guild_task/1
    , upgrade_lv/1
]).
-export([refresh_no_guild/1]).
-export([cmd_guild/1, cmd_reset/1, cmd_task_check/0]).

%%初始化玩家跑环数据
init(Player, NowTime) ->
    case player_util:is_new_role(Player) of
        true ->
            TaskGuild = #task_guild{pkey = Player#player.key, timestamp = NowTime},
            lib_dict:put(?PROC_STATUS_TASK_GUILD, TaskGuild);
        false ->
            case task_load:get_task_guild(Player#player.key) of
                [] ->
                    TaskGuild =
                        case get_task(Player#player.lv) of
                            Tid when Tid > 0 andalso Player#player.guild#st_guild.guild_key /= 0 ->
                                Task = task_init:task_data(Tid, ?TASK_TYPE_GUILD),
                                task:accept_guild_task(Player#player.sid, Task#task{times = 1, times_lim = ?TASK_GUILD_LIMIT}, false),
                                #task_guild{pkey = Player#player.key, tid = Tid, timestamp = NowTime, is_change = 1};
                            Tid1 ->
                                #task_guild{pkey = Player#player.key, tid = Tid1, timestamp = NowTime}
                        end,
                    lib_dict:put(?PROC_STATUS_TASK_GUILD, TaskGuild);
                [Cycle, Tid, Log, Timestamp, IsReward] ->
                    case util:is_same_date(Timestamp, NowTime) of
                        true ->
                            TaskGuild = #task_guild{
                                pkey = Player#player.key,
                                tid = Tid,
                                cycle = Cycle,
                                log = util:bitstring_to_term(Log),
                                timestamp = Timestamp,
                                is_reward = IsReward
                            },
                            lib_dict:put(?PROC_STATUS_TASK_GUILD, TaskGuild);
                        false ->
                            case task:get_task_by_type(?TASK_TYPE_GUILD) of
                                [] ->
                                    TaskGuild =
                                        case get_task(Player#player.lv) of
                                            NewTid when NewTid > 0 andalso Player#player.guild#st_guild.guild_key /= 0 ->
                                                Task = task_init:task_data(NewTid, ?TASK_TYPE_GUILD),
                                                task:accept_guild_task(Player#player.sid, Task#task{times = 1, times_lim = ?TASK_GUILD_LIMIT}, false),
                                                #task_guild{pkey = Player#player.key, tid = NewTid, timestamp = NowTime, is_change = 1};
                                            NewTid1 ->
                                                #task_guild{pkey = Player#player.key, tid = NewTid1, timestamp = NowTime, is_change = 1}
                                        end;
                                [Task | _] ->
                                    task:upgrade_guild_task(Task#task{times = 1}),
                                    TaskGuild = #task_guild{pkey = Player#player.key, tid = Task#task.taskid, timestamp = NowTime, is_change = 1}
                            end,
                            lib_dict:put(?PROC_STATUS_TASK_GUILD, TaskGuild)
                    end
            end
    end.

logout() ->
    TaskGuild = get_guild_task(),
    if TaskGuild#task_guild.is_change /= 0 ->
        task_load:replace_task_guild(TaskGuild);
        true -> skip
    end.

timer_update() ->
    TaskGuild = get_guild_task(),
    if TaskGuild#task_guild.is_change /= 0 ->
        TaskGuild = get_guild_task(),
        task_load:replace_task_guild(TaskGuild),
        lib_dict:put(?PROC_STATUS_TASK_GUILD, TaskGuild#task_guild{is_change = 0});
        true -> skip
    end,
    ok.

%%零点刷新任务
midnight_refresh(Player, NowTime) ->
    TaskGuild = get_guild_task(),
    if Player#player.guild#st_guild.guild_key /= 0 ->
        NewTaskGuild =
            case task:get_task_by_type(?TASK_TYPE_GUILD) of
                [] ->
                    case get_task(Player#player.lv) of
                        0 ->
                            TaskGuild#task_guild{cycle = 0, log = [], is_reward = ?TASK_CYCLE_REWARD_STATE_UNFINISH, timestamp = NowTime, is_change = 1};
                        Tid ->
                            Task = task_init:task_data(Tid, ?TASK_TYPE_GUILD),
                            task:accept_guild_task(Player#player.sid, Task#task{times = 1, times_lim = ?TASK_GUILD_LIMIT}, true),
                            TaskGuild#task_guild{cycle = 0, tid = Tid, log = [], is_reward = ?TASK_CYCLE_REWARD_STATE_UNFINISH, timestamp = NowTime, is_change = 1}
                    end;
                [Task | _] ->
                    task:accept_guild_task(Player#player.sid, Task#task{times = 1}, true),
                    TaskGuild#task_guild{cycle = 0, tid = Task#task.taskid, log = [], is_reward = ?TASK_CYCLE_REWARD_STATE_UNFINISH, timestamp = NowTime, is_change = 1}
            end,
        lib_dict:put(?PROC_STATUS_TASK_GUILD, NewTaskGuild);
        true ->
            NewTaskGuild = TaskGuild#task_guild{cycle = 0, log = [], is_reward = ?TASK_CYCLE_REWARD_STATE_UNFINISH, timestamp = NowTime, is_change = 1},
            lib_dict:put(?PROC_STATUS_TASK_GUILD, NewTaskGuild),
            refresh_no_guild(Player)
    end.

upgrade_lv(Player) ->
    TaskGuild = get_guild_task(),
    if TaskGuild#task_guild.cycle < ?TASK_GUILD_LIMIT ->
        if Player#player.guild#st_guild.guild_key /= 0 ->
            case task:get_task_by_type(?TASK_TYPE_GUILD) of
                [] ->
                    Tid = ?IF_ELSE(TaskGuild#task_guild.tid == 0, get_task(Player#player.lv), TaskGuild#task_guild.tid),
                    case Tid of
                        0 -> ok;
                        _ ->
                            Task = task_init:task_data(Tid, ?TASK_TYPE_GUILD),
                            Times = ?IF_ELSE(TaskGuild#task_guild.cycle == 0, 1, TaskGuild#task_guild.cycle + 1),
                            task:accept_guild_task(Player#player.sid, Task#task{times = Times, times_lim = ?TASK_GUILD_LIMIT}, true),
                            NewTaskGuild = TaskGuild#task_guild{tid = Tid, is_change = 1},
                            lib_dict:put(?PROC_STATUS_TASK_GUILD, NewTaskGuild)
                    end;
                _ -> ok
            end;
            true ->
                refresh_no_guild(Player)
        end;
        true -> ok
    end.

refresh_no_guild(Player) ->
    case do_refresh_no_guild(Player) of
        [] -> ok;
        [Task] ->
            %%已接+可接+下一级主线
            task:refresh_client_new_task(Player#player.sid, Task)
    end.

do_refresh_no_guild(Player) ->
    if Player#player.guild#st_guild.guild_key /= 0 -> [];
        true ->
            case task:get_task_by_type(?TASK_TYPE_GUILD) of
                [] ->
                    TaskGuild = get_guild_task(),
                    if TaskGuild#task_guild.cycle >= ?TASK_GUILD_LIMIT -> [];
                        true ->
                            if TaskGuild#task_guild.tid == 0 ->
                                case get_task(Player#player.lv) of
                                    0 -> [];
                                    Tid ->
                                        Task = task_init:task_data(Tid, ?TASK_TYPE_GUILD),
                                        NewTaskGuild = TaskGuild#task_guild{tid = Tid, is_change = 1},
                                        lib_dict:put(?PROC_STATUS_TASK_GUILD, NewTaskGuild),
                                        [Task#task{state = ?TASK_ST_ACTIVE, times = TaskGuild#task_guild.cycle, times_lim = ?TASK_GUILD_LIMIT}]
                                end;
                                true ->
                                    case task_init:task_data(TaskGuild#task_guild.tid, ?TASK_TYPE_GUILD) of
                                        [] -> [];
                                        Task ->
                                            [Task#task{state = ?TASK_ST_ACTIVE, times = TaskGuild#task_guild.cycle, times_lim = ?TASK_GUILD_LIMIT}]
                                    end
                            end
                    end;
                _ -> []
            end
    end.
%%加入仙盟
enter_guild(Player) ->
    TaskGuild = get_guild_task(),
    if TaskGuild#task_guild.cycle < ?TASK_GUILD_LIMIT ->
        NewTaskGuild =
            case task:get_task_by_type(?TASK_TYPE_GUILD) of
                [] ->
                    Tid = ?IF_ELSE(TaskGuild#task_guild.tid == 0, get_task(Player#player.lv), TaskGuild#task_guild.tid),
                    case Tid of
                        0 ->
                            TaskGuild;
                        _ ->
                            Task = task_init:task_data(Tid, ?TASK_TYPE_GUILD),
                            Times = ?IF_ELSE(TaskGuild#task_guild.cycle == 0, 1, TaskGuild#task_guild.cycle + 1),
                            task:accept_guild_task(Player#player.sid, Task#task{times = Times, times_lim = ?TASK_GUILD_LIMIT}, true),
                            TaskGuild#task_guild{tid = Tid, is_change = 1}
                    end;
                _ ->
                    TaskGuild
            end,
        lib_dict:put(?PROC_STATUS_TASK_GUILD, NewTaskGuild);
        true -> ok
    end.

%%退出仙盟
quit_guild(Player) ->
    task:del_task_by_type(?TASK_TYPE_GUILD, Player#player.sid),
    refresh_no_guild(Player),
    ok.

get_guild_task(Player) ->
    if Player#player.guild#st_guild.guild_key /= 0 -> [];
        true ->
            case task:get_task_by_type(?TASK_TYPE_GUILD) of
                [] ->
                    TaskGuild = get_guild_task(),
                    if TaskGuild#task_guild.cycle >= ?TASK_GUILD_LIMIT -> [];
                        true ->
                            if TaskGuild#task_guild.tid == 0 ->
                                case get_task(Player#player.lv) of
                                    0 -> [];
                                    Tid ->
                                        Task = task_init:task_data(Tid, ?TASK_TYPE_GUILD),
                                        NewTaskGuild = TaskGuild#task_guild{tid = Tid, is_change = 1},
                                        lib_dict:put(?PROC_STATUS_TASK_GUILD, NewTaskGuild),
                                        [Task#task{state = ?TASK_ST_ACTIVE, times = TaskGuild#task_guild.cycle, times_lim = ?TASK_GUILD_LIMIT}]
                                end;
                                true ->
                                    case task_init:task_data(TaskGuild#task_guild.tid, ?TASK_TYPE_GUILD) of
                                        [] -> [];
                                        Task ->
                                            [Task#task{state = ?TASK_ST_ACTIVE, times = TaskGuild#task_guild.cycle, times_lim = ?TASK_GUILD_LIMIT}]
                                    end
                            end
                    end;
                _ -> []
            end
    end.


%%获取任务ID
get_task(Plv) ->
    case data_task_guild_conf:get_task(Plv) of
        [] -> 0;
        TaskIds ->
            Tid = util:list_rand(TaskIds),
            case task_init:task_data(Tid, ?TASK_TYPE_GUILD) of
                [] -> 0;
                _ -> Tid
            end
    end.

get_guild_task() ->
    lib_dict:get(?PROC_STATUS_TASK_GUILD).


%%提交了跑环任务，新环处理
finish_task_guild(Player) ->
    sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_TASK_GUILD),
    TaskGuild = get_guild_task(),
    %%满环了，发放满换奖励
    Cycle = TaskGuild#task_guild.cycle + 1,
    if Cycle >= ?TASK_GUILD_LIMIT ->
        NewTaskGuild = TaskGuild#task_guild{tid = 0, is_reward = ?TASK_CYCLE_REWARD_STATE_FINISH, cycle = Cycle, is_change = 1},
        lib_dict:put(?PROC_STATUS_TASK_GUILD, NewTaskGuild),
        ExtraAward = data_task_guild_reward:get_award(Player#player.lv),
        {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(7, ExtraAward)),
        achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2002, 0, 1),
        %%资源找回
        findback_src:fb_trigger_src(Player, 30, {0, util:unixtime()}),
        NewPlayer;
        true ->
            case task:get_task_by_type(?TASK_TYPE_GUILD) of
                [] ->
                    Tid = get_task(Player#player.lv),
                    NewTaskGuild = TaskGuild#task_guild{tid = Tid, cycle = Cycle, is_change = 1},
                    lib_dict:put(?PROC_STATUS_TASK_GUILD, NewTaskGuild),
                    if Player#player.guild#st_guild.guild_key /= 0 ->
                        case task_init:task_data(Tid, ?TASK_TYPE_GUILD) of
                            [] -> ok;
                            Task ->
                                task:accept_guild_task(Player#player.sid, Task#task{times = Cycle + 1, times_lim = ?TASK_GUILD_LIMIT}, true)
                        end;
                        true -> ok
                    end;
                _ ->
                    ok
            end,
            Player
    end.

finish_cost(Player) ->
    {GoldCost, GoldBack} = get_cost(Player),
    State = ?IF_ELSE(GoldCost == 0, 0, 1),
    TaskGuild = get_guild_task(),
    Times = ?TASK_GUILD_LIMIT - TaskGuild#task_guild.cycle,
    TaskGoods =
        if TaskGuild#task_guild.tid == 0 -> [];
            true ->
                case task_init:task_data(TaskGuild#task_guild.tid, ?TASK_TYPE_GUILD) of
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
    FinishGoods = goods:pack_goods(data_task_guild_reward:get_award(Player#player.lv)),
    {State, GoldCost * Times, GoldBack * Times, TaskGoods, FinishGoods}.

get_cost(_Player) ->
    {GoldCost, GoldBack} = {3, 1},
%%        data_vip_args:get(24, Player#player.vip_lv),
    {GoldCost, GoldBack}.
%%一键完成
finish_all(Player) ->
    {GoldCost, GoldBack} = get_cost(Player),
    if GoldCost == 0 -> {28, Player};
        Player#player.guild#st_guild.guild_key == 0 -> {43, Player};
        true ->
            TaskGuild = get_guild_task(),
            {Times, TidList} = get_can_finish_times(TaskGuild, Player#player.lv),
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
                                    _ -> Player1
                                end,
                            Player3 = give_task_reward(Player2, TidList),
                            NewTaskGuild = TaskGuild#task_guild{cycle = ?TASK_GUILD_LIMIT, is_reward = ?TASK_CYCLE_REWARD_STATE_FINISH, tid = 0, is_change = 1},
                            lib_dict:put(?PROC_STATUS_TASK_GUILD, NewTaskGuild),
                            %%删除任务
                            task:refresh_client_del_task(Player#player.sid, TaskGuild#task_guild.tid),
                            task:del_task_by_type(?TASK_TYPE_GUILD, Player#player.sid),
                            task_event:event(?TASK_ACT_TASK_TYPE, {?TASK_TYPE_GUILD, Times}),
                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2002, 0, 1),
                            sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_TASK_GUILD, Times),
                            %%资源找回
                            act_hi_fan_tian:trigger_finish_api(Player,5,Times),
                            findback_src:fb_trigger_src(Player, 30, {Times, 0}),
                            {1, Player3}
                    end
            end
    end.

%%获取可完成的环数
%%Return guild,tid
get_can_finish_times(TaskGuild, Plv) ->
    if TaskGuild#task_guild.cycle >= ?TASK_GUILD_LIMIT -> {0, []};
        true ->
            case task:get_task_by_type(?TASK_TYPE_GUILD) of
                [] ->
                    TidList = lists:map(fun(_) ->
                        get_task(Plv) end, lists:seq(1, ?TASK_GUILD_LIMIT - TaskGuild#task_guild.cycle)),
                    {?TASK_GUILD_LIMIT - TaskGuild#task_guild.cycle, TidList};
                [_Task | _] ->
                    TidList = lists:map(fun(_) ->
                        get_task(Plv) end, lists:seq(1, ?TASK_GUILD_LIMIT - TaskGuild#task_guild.cycle - 1)),
                    {?TASK_GUILD_LIMIT - TaskGuild#task_guild.cycle, [_Task#task.taskid | TidList]}
            end
    end.

%%一键完成奖励
give_task_reward(Player, TidList) ->
    %%一键完成奖励
    ExtraAward = data_task_guild_reward:get_award(Player#player.lv),
    F = fun(Tid) ->
        case task_init:task_data(Tid, ?TASK_TYPE_GUILD) of
            [] -> [];
            Task ->
                task:trans_task_goods_list(Player, Tid, Task#task.goods)
        end
        end,
    GoodsList = lists:flatmap(F, TidList) ++ goods:make_give_goods_list(1, ExtraAward),
    {ok, NewPlayer} = goods:give_goods(Player, GoodsList),
    %%资源找回
    findback_src:fb_trigger_src(Player, 30, {0, util:unixtime()}),
    NewPlayer.

get_state() ->
    TaskGuild = get_guild_task(),
    if TaskGuild#task_guild.is_reward == ?TASK_CYCLE_REWARD_STATE_UNREWARD -> 1;
        true ->
            TaskList = task:get_task_by_type(?TASK_TYPE_GUILD),
            F = fun(Task) ->
                Task#task.state == ?TASK_ST_FINISH
                end,
            case lists:any(F, TaskList) of
                true -> 1;
                false -> 0
            end
    end.

cmd_guild(Cycle) ->
    TaskGuild = get_guild_task(),
    NewCycle = ?IF_ELSE(Cycle < 0 orelse Cycle > ?TASK_GUILD_LIMIT, 1, Cycle),
    lib_dict:put(?PROC_STATUS_TASK_GUILD, TaskGuild#task_guild{cycle = NewCycle, is_change = 1}),
    ok.

cmd_reset(Player) ->
    Now = util:unixtime(),
    task:del_task_by_type(?TASK_TYPE_GUILD, Player#player.sid),
    NewTaskGuild = #task_guild{pkey = Player#player.key, timestamp = Now, is_change = 1},
    lib_dict:put(?PROC_STATUS_TASK_GUILD, NewTaskGuild),
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
    TaskGuild = get_guild_task(),
    ?IF_ELSE(TaskGuild#task_guild.cycle >= ?TASK_GUILD_LIMIT, {0, [{time, 0}]}, {1, [{time, ?TASK_GUILD_LIMIT - TaskGuild#task_guild.cycle}]}).

get_guild_times() ->
    TaskGuild = get_guild_task(),
    Cycle = if TaskGuild#task_guild.cycle == 0 -> 1;
                TaskGuild#task_guild.cycle > ?TASK_GUILD_LIMIT -> ?TASK_GUILD_LIMIT;
                true -> TaskGuild#task_guild.cycle
            end,
    {Cycle, ?TASK_GUILD_LIMIT}.
