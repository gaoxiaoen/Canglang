%%----------------------------------------------------
%% @doc 指定时间内累计某功能次数类活动
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(campaign_accumulative).
-export([
        login/1
        ,day_check/1
        ,listener/3
    ]).

-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").

%% 当前已有活动
-ifdef(debug).
-define(campaign_accumulative, [
        #campaign_accumulative{
            type = casino_acc, 
            label = casino_count, 
            target = 4, 
            start_time = util:datetime_to_seconds({{2013, 5, 16}, {0, 0, 0}}),
            end_time = util:datetime_to_seconds({{2013, 5, 22}, {23, 59, 0}}),
            mail = {?L(<<"累积探宝，福利满怀">>), ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持，倾情回馈活动期间，您在仙魂探宝累积探宝达~w次，获得了以下超值奖励，请注意查收！谢谢您的支持，祝您游戏愉快！">>)}, 
            rewards = [
                {300, [{29282, 1, 2}, {26035, 1, 2}]},
                {500, [{29282, 1, 3}, {26055, 1, 1}]},
                {1500, [{29517, 1, 1}, {32001, 1, 25}]},
                {3000, [{29517, 1, 2}, {32001, 1, 50}]}
            ]}
    ]).
-else.
-define(campaign_accumulative, [
        #campaign_accumulative{
            type = casino_acc, 
            label = casino_count, 
            target = 4, 
            start_time = util:datetime_to_seconds({{2013, 5, 18}, {0, 0, 0}}),
            end_time = util:datetime_to_seconds({{2013, 5, 22}, {23, 59, 59}}),
            mail = {?L(<<"累积探宝，福利满怀">>), ?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持，活动期间您在仙魂探宝累积探宝达~w次，获得了以下超值奖励，请注意查收！谢谢您的支持，祝您游戏愉快！">>)}, 
            rewards = [
                {300, [{29282, 1, 2}, {26035, 1, 2}]},
                {500, [{29282, 1, 3}, {26055, 1, 1}]},
                {1500, [{29517, 1, 1}, {32001, 1, 25}]},
                {3000, [{29517, 1, 2}, {32001, 1, 50}]}
            ]}
    ]).
-endif.

%% -------------------- 外部接口 -------------------------
%% @spec login(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 登录处理
login(Role = #role{campaign = Camp = #campaign_role{accumulative = Accs}}) ->
    Now = util:unixtime(),
    {Accs1, Mails} = do_rewards(Accs, [], [], Now),
    NewAcc = add_campaign(?campaign_accumulative, Accs1, Now),
    [mail_mgr:deliver(Role, {T, C, [], I}) || {T, C, I} <- Mails],
    NewCamp = Camp#campaign_role{accumulative = NewAcc},
    Role1 = Role#role{campaign = NewCamp},
    case get_soonest_time(NewAcc, 0) of
        0 -> 
            Role1;
        T ->
            case util:day_diff(T, Now) < 2 of
                true ->
                    role_timer:set_timer(campaign_accumulative, (T - Now) * 1000, {?MODULE, day_check, []}, 1, Role1);
                _ ->
                    Role1
            end
    end.

%% @spec listener(Role, Label, Val) -> NewRole
%% Role = NewRole = #role{}
%% Label = atom()
%% Val = integer()
%% @doc 活动监听器
listener(Role = #role{campaign = Camp = #campaign_role{accumulative = Accs}}, Label, Val) ->
    Now = util:unixtime(),
    NewAcc = add_campaign(?campaign_accumulative, Accs, Now),
    Accs1 = do_listener(NewAcc, [], Now, Label, Val),
    NewCamp = Camp#campaign_role{accumulative = Accs1},
    Role#role{campaign = NewCamp}.

%% @spec day_check(Role) -> {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 跨天检查
day_check(Role) ->
    Role1 = login(Role),
    {ok, Role1}.

%% ------------------- 内部方法 ---------------------------
%% 找出符合发奖励条件的
do_rewards([], Accs, Mails, _) ->
    {Accs, Mails};
do_rewards([#campaign_accumulative{type = Type, start_time = StartTime, end_time = EndTime, current = Val} | T], Accs, Mails, Now) when Now >= EndTime ->
    case lists:keyfind(Type, #campaign_accumulative.type, ?campaign_accumulative) of
        #campaign_accumulative{start_time = StartTime, rewards = Rewards, mail = {Title, Format}} ->
            %% 奖励先从大到小排序，只能发一个
            F = fun({Cond1, _}, {Cond2, _}) ->
                    Cond1 > Cond2
            end,
            case get_reward(lists:sort(F, Rewards), Val) of
                [] ->
                    do_rewards(T, Accs, Mails, Now);
                Reward ->
                    NewMails = [{Title, util:fbin(Format, [Val]), Reward} | Mails],
                    do_rewards(T, Accs, NewMails, Now)
            end;
        %% 新同类活动开始，旧活动果断抛弃
        _ ->
            do_rewards(T, Accs, Mails, Now)
    end;
do_rewards([H = #campaign_accumulative{} | T], Accs, Mails, Now) ->
    ?DEBUG("未过期活动 ~w, ~w", [H, Now]),
    do_rewards(T, [H | Accs], Mails, Now);
do_rewards([_H | T], Accs, Mails, Now) ->
    do_rewards(T, Accs, Mails, Now).

%% 根据当前值看看是否可以领取奖励
get_reward([], _) -> 
    [];
get_reward([{Cond, Reward} | T], Val) ->
    case Val >= Cond of
        true ->
            Reward;
        _ ->
            get_reward(T, Val)
    end.

%% 看看有没新活动
add_campaign([], Accs, _Now) ->
    Accs;
add_campaign([H = #campaign_accumulative{type = Type, start_time = StartTime, end_time = EndTime} | T], Accs, Now) when Now >= StartTime andalso Now < EndTime ->
    case lists:keyfind(Type, #campaign_accumulative.type, Accs) of
        false ->
            add_campaign(T, [H#campaign_accumulative{rewards = [], mail = {}} | Accs], Now);
        _ ->
            add_campaign(T, Accs, Now)
    end;
add_campaign([_H | T], Accs, Now) ->
    add_campaign(T, Accs, Now).

%% 批量处理相同类型的监听
do_listener([], Accs, _Now, _Label, _Val) ->
    Accs;
%% 探宝类
do_listener([H = #campaign_accumulative{end_time = EndTime, label = casino_count, current = Current, target = Target} | T], Accs, Now, casino_count, {Target, Val}) when EndTime >= Now ->
    do_listener(T, [H#campaign_accumulative{current = Current + Val} | Accs], Now, casino_count, Val);
do_listener([H = #campaign_accumulative{} | T], Accs, Now, Label, Val)  ->
    do_listener(T, [H | Accs], Now, Label, Val);
do_listener([_H | T], Accs, Now, Label, Val)  ->
    do_listener(T, Accs, Now, Label, Val).

%% 获取最快结束的那个活动的结束时间
get_soonest_time([], Time) ->
    Time;
get_soonest_time([#campaign_accumulative{end_time = EndTime} | T], 0) ->
    get_soonest_time(T, EndTime);
get_soonest_time([#campaign_accumulative{end_time = EndTime} | T], Time) ->
    case EndTime < Time of
        true ->
            get_soonest_time(T, EndTime);
        _ ->
            get_soonest_time(T, Time)
    end.
