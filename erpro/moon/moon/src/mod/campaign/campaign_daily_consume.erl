%%----------------------------------------------------
%% @doc 日常消费记录表(目前周年庆红包用)
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(campaign_daily_consume).
-export([
        login/1
        ,push/2
        ,listener/3
        ,reward/2
        ,adm_set_days/3
    ]).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("campaign.hrl").

-define(campaign_daily_consume_base, 80). %% 每100晶钻奖励一个
-define(campaign_daily_consume_start, {{2013, 3, 9}, {0, 0, 0}}). %% 活动开始
-define(campaign_daily_consume_end, {{2013, 3, 31}, {23, 59, 59}}). %% 活动结束

%% 登录处理
login(Role = #role{campaign_daily_consume = #campaign_daily_consume{}}) ->
    Role;
login(Role) ->
    Role#role{campaign_daily_consume = #campaign_daily_consume{}}.

%% 获取消耗和奖励领取情况
push(15864, #role{campaign_daily_consume = #campaign_daily_consume{consume_days = Days}, pid = Pid}) ->
    Start = util:datetime_to_seconds(?campaign_daily_consume_start),
    End = util:datetime_to_seconds(?campaign_daily_consume_end),
    Now = util:unixtime(),
    case [1 || {_, G, 1} <- Days, G > ?campaign_daily_consume_base] of
        [] when Now < Start orelse Now > End ->
            ok;
        _ ->
            List = [{Y, M, D, Gold div ?campaign_daily_consume_base, St} || {{Y, M, D}, Gold, St} <- Days, Gold > ?campaign_daily_consume_base],
            role:pack_send(Pid, 15864, {List, Now})
    end;
%% 这个推送是领取完最后一个奖励时用的
push(done, #role{campaign_daily_consume = #campaign_daily_consume{consume_days = Days}, pid = Pid}) ->
    Start = util:datetime_to_seconds(?campaign_daily_consume_start),
    End = util:datetime_to_seconds(?campaign_daily_consume_end),
    Now = util:unixtime(),
    case [1 || {_, G, 1} <- Days, G > ?campaign_daily_consume_base] of
        [] when Now < Start orelse Now > End ->
            List = [{Y, M, D, Gold div ?campaign_daily_consume_base, St} || {{Y, M, D}, Gold, St} <- Days, Gold > ?campaign_daily_consume_base],
            role:pack_send(Pid, 15864, {List, Now});
        _ ->
            ok
    end.


%% 监听晶钻消耗
listener(Role = #role{campaign_daily_consume = Daily = #campaign_daily_consume{consume_days = Days}}, _Label, Gold) ->
    Start = util:datetime_to_seconds(?campaign_daily_consume_start),
    End = util:datetime_to_seconds(?campaign_daily_consume_end),
    Now = util:unixtime(),
    case Now >= Start andalso End >= Now of
        true ->
            Day = erlang:date(),
            NewDays = case lists:keyfind(Day, 1, Days) of
                {Day, Num, St} -> lists:keyreplace(Day, 1, Days, {Day, Num + Gold, St});
                _ -> [{Day, Gold, 1} | Days]
            end,
            Role#role{campaign_daily_consume = Daily#campaign_daily_consume{consume_days = NewDays}};
        _ ->
            Role
    end.

%% 领取今天前奖励
reward(Role = #role{campaign_daily_consume = Daily = #campaign_daily_consume{consume_days = Days}}, Day) ->
    case erlang:date() of
        Day ->
            {false, ?L(<<"今天的还不能领取">>)};
        _ ->
            case lists:keyfind(Day, 1, Days) of
                {_, _, 2} ->
                    {false, ?L(<<"你已经领过该奖励了">>)};
                {_, Num, _} when Num < ?campaign_daily_consume_base ->
                    {false, ?L(<<"这天消费额不足，不能领取奖励">>)};
                {_, Num, _} ->
                    NewDays = lists:keyreplace(Day, 1, Days, {Day, Num, 2}),
                    Role1 = Role#role{campaign_daily_consume = Daily#campaign_daily_consume{consume_days = NewDays}},
                    case role_gain:do([#gain{label = item, val = [33118, 1, Num div ?campaign_daily_consume_base]}], Role1) of
                        {ok, NewRole} ->
                            push(15864, NewRole),
                            push(done, NewRole),
                            {ok, NewRole};
                        _ ->
                            {false, ?L(<<"背包不足吧？">>)}
                    end;
                _ ->
                    {false, ?L(<<"这天你好像没有消费哦">>)}
            end
    end.

%% gm命令设可领取天数
adm_set_days(_, Day, _) when Day > 31 orelse Day < 1 ->
    {ok, ?L(<<"天数范围是1~31">>)};
adm_set_days(_, _, Gold) when Gold < 1 ->
    {ok, ?L(<<"晶钻数请输入一个大于0的整数">>)};
adm_set_days(Role, Day, Gold) ->
    Days = [{{2013, 3, D}, Gold, 1} || D <- lists:seq(1, Day)],
    Role1 = Role#role{campaign_daily_consume = #campaign_daily_consume{consume_days = Days}},
    push(15864, Role1),
    {ok, Role1}.
