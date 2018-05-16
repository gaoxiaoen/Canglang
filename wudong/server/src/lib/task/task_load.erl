%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 十一月 2015 14:47
%%%-------------------------------------------------------------------
-module(task_load).
-author("hxming").

-include("task.hrl").
%% API
-compile(export_all).

%%获取任务包信息
get_task_bag(Pkey) ->
    Sql = io_lib:format("select bag ,log,log_clean,timestamp,story from player_task where pkey = ~p", [Pkey]),
    db:get_row(Sql).

%%更新任务包信息
replace_task_bag(Pkey, TaskBag, TaskLog, TaskLogClean, Timestamp, Story) ->
    SQL = io_lib:format("replace into player_task set pkey = ~p ,bag = '~s',log = '~s',log_clean = '~s',timestamp=~p,story='~s'",
        [Pkey, util:term_to_bitstring(TaskBag), util:term_to_bitstring(TaskLog), util:term_to_bitstring(TaskLogClean), Timestamp, util:term_to_bitstring(Story)]),
    db:execute(SQL).

%%获取跑环任务信息
get_task_cycle(Pkey) ->
    Sql = io_lib:format(<<"select cycle,tid,log,timestamp,is_reward from player_task_cycle where pkey = ~p">>, [Pkey]),
    db:get_row(Sql).

%%更新跑环任务信息
replace_task_cycle(TaskCycle) ->
    Sql = io_lib:format(<<"replace into player_task_cycle set pkey = ~p,cycle=~p,tid = ~p,log = '~s',timestamp=~p,is_reward = ~p">>,
        [TaskCycle#task_cycle.pkey,
            TaskCycle#task_cycle.cycle,
            TaskCycle#task_cycle.tid,
            util:term_to_bitstring(TaskCycle#task_cycle.log),
            TaskCycle#task_cycle.timestamp,
            TaskCycle#task_cycle.is_reward]),
    db:execute(Sql).


%%获取护送任务信息
select_task_convoy(Pkey) ->
    Sql = io_lib:format(<<"select color,times,extra_times,times_total,rob_times,time,refresh_free,godt,help_times from player_convoy where pkey = ~p">>, [Pkey]),
    db:get_row(Sql).

update_task_convoy(Convoy) ->
    Sql = io_lib:format(<<"replace into player_convoy set pkey =~p,color = ~p,times=~p,extra_times=~p,times_total=~p,rob_times=~p,time=~p,refresh_free = ~p,godt=~p,help_times=~p">>,
        [Convoy#task_convoy.pkey,
            Convoy#task_convoy.color,
            Convoy#task_convoy.times,
            Convoy#task_convoy.extra_times,
            Convoy#task_convoy.times_total,
            Convoy#task_convoy.rob_times,
            Convoy#task_convoy.time,
            Convoy#task_convoy.refresh_free,
            Convoy#task_convoy.godt,
            Convoy#task_convoy.help_times
        ]),
    db:execute(Sql).


log_convoy(Pkey, Nickname, Color, Time) ->
    Sql = io_lib:format(<<"insert into log_convoy set pkey=~p,nickname = '~s',color=~p,time=~p">>, [Pkey, Nickname, Color, Time]),
    log_proc:log(Sql),
    ok.


load_task_cron() ->
    db:get_all("select task_id,name,type,acc_accept,acc_finish from cron_task").

replace_task_cron(TaskCron) ->
    Sql = io_lib:format(<<"replace into cron_task set task_id=~p,name='~s',type=~p,acc_accept=~p,acc_finish=~p">>,
        [TaskCron#task_cron.task_id,
            TaskCron#task_cron.name,
            TaskCron#task_cron.type,
            TaskCron#task_cron.acc_accept,
            TaskCron#task_cron.acc_finish]),
    db:execute(Sql).


%%获取跑环任务信息
get_task_guild(Pkey) ->
    Sql = io_lib:format(<<"select cycle,tid,log,timestamp,is_reward from player_task_guild where pkey = ~p">>, [Pkey]),
    db:get_row(Sql).

%%更新跑环任务信息
replace_task_guild(TaskGuild) ->
    Sql = io_lib:format(<<"replace into player_task_guild set pkey = ~p,cycle=~p,tid = ~p,log = '~s',timestamp=~p,is_reward = ~p">>,
        [TaskGuild#task_guild.pkey,
            TaskGuild#task_guild.cycle,
            TaskGuild#task_guild.tid,
            util:term_to_bitstring(TaskGuild#task_guild.log),
            TaskGuild#task_guild.timestamp,
            TaskGuild#task_guild.is_reward]),
    db:execute(Sql).
