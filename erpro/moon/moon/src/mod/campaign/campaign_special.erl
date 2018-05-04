%%----------------------------------------------------
%% 活动任务
%% @author shanw
%%----------------------------------------------------
-module(campaign_special).
-export([
        reward/1
        ,special_list/1
        ,check_special_list/1
        ,pay/1
        ,online/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("vip.hrl").
-include("activity2.hrl").

-define(camp_spe_time_30, 1).
-define(camp_spe_activity, 2).
-define(camp_spe_charge, 3).
-define(camp_spe_vip, 4).

-define(campaign_special_list, [
        #campaign_special{id = 1, items = [{1, [{29090, 1, 1}]}, {2, [{29090, 1, 1}, {33125, 1, 1}]}, {3, [{29090, 1, 1}, {33125, 1, 2}]}, {4, [{29090, 1, 1}, {33125, 1, 3}]}], cond_list = [{?camp_spe_vip, 0}, {?camp_spe_time_30, 0}, {?camp_spe_activity, 0}, {?camp_spe_charge, 0}]}
    ]
).

special_list(Role) ->
    reset_special_list(Role).

reset_special_list(Role = #role{campaign = #campaign_role{special_list = SpecialList}}) ->
    Now = util:unixtime(),
    StartT = util:datetime_to_seconds({{2012, 10, 30}, {0, 0, 1}}),
    EndT = util:datetime_to_seconds({{2012, 11, 1}, {23, 59, 59}}),
    case Now >= StartT andalso Now < EndT of
        false -> {Role, []};
        true -> 
            NewSpecialList = [Spe || Spe <- SpecialList, check_task(Spe, Now)],
            reset_special_list(Role, ?campaign_special_list, NewSpecialList)
    end.
reset_special_list(Role, [], NewSpecialList) ->
    do_check_cond(Role, NewSpecialList, []);
reset_special_list(Role, [Spe = #campaign_special{id = Id} | T], NewSpecialList) ->
    case lists:keyfind(Id, #campaign_special.id, NewSpecialList) of
        false -> 
            NewSpe = Spe#campaign_special{start_time = util:unixtime()},
            reset_special_list(Role, T, [NewSpe | NewSpecialList]);
        _ -> 
            reset_special_list(Role, T, NewSpecialList)
    end.

do_check_cond(Role = #role{campaign = Campaign}, [], NewSpecialList) ->
    {Role#role{campaign = Campaign#campaign_role{special_list = NewSpecialList}}, NewSpecialList};
do_check_cond(Role, [Spe = #campaign_special{cond_list = CondList} | T], NewSpe) ->
    NewCondList = check_cond_list(Role, CondList, []),
    do_check_cond(Role, T, [Spe#campaign_special{cond_list = NewCondList} | NewSpe]).

%% 对个别条件进行判断
check_cond_list(_Role, [], NewCondList) -> NewCondList;
check_cond_list(Role = #role{vip = #vip{type = ?vip_half_year}}, [{?camp_spe_vip, 0} | T], NewCondList) ->
    check_cond_list(Role, T, [{?camp_spe_vip, 1} | NewCondList]);
check_cond_list(Role = #role{activity2 = #activity2{current = Current}}, [{?camp_spe_activity, 0} | T], NewCondList) when Current >= 100 ->
    check_cond_list(Role, T, [{?camp_spe_activity, 1} | NewCondList]);
check_cond_list(Role, [Spe | T], NewCondList) ->
    check_cond_list(Role, T, [Spe | NewCondList]).
    
check_task(#campaign_special{start_time = Time}, Now) ->
    util:is_same_day2(Time, Now);
check_task(Spe, _Now) -> 
    is_record(Spe, campaign_special). 

%% 领取任务奖励
reward(Role = #role{campaign = Campaign = #campaign_role{special_list = SpecialList}}) ->
    Flag = check_special_list(SpecialList),
    case Flag of
        0 -> {false, ?L(<<"您尚未达成条件, 无法领取礼包">>)};
        _ ->
            case lists:keyfind(1, #campaign_special.id, SpecialList) of
                false -> 
                    {false, ?L(<<"活动数据不存在">>)};
                #campaign_special{status = 1} ->
                    {false, ?L(<<"你已经领取过该礼包，活动期间每天仅能领取一次哦">>)};
                Spe = #campaign_special{items = Items} ->
                    case lists:keyfind(Flag, 1, Items) of
                        {Flag, L} when is_list(L) ->
                            GL = [#gain{label = item, val = [BaseId, Bind, Num]} || {BaseId, Bind, Num} <- L],
                            case role_gain:do(GL, Role) of
                                {false, _} ->
                                    {false, ?L(<<"您的背包已满，先整理背包再领取吧">>)};
                                {ok, NRole} ->
                                    Msg = notice_inform:gain_loss(GL, ?L(<<"活动奖励">>)),
                                    notice:inform(Role#role.pid, Msg),
                                    NewSpe = Spe#campaign_special{status = 1},
                                    NewSpecialList = lists:keyreplace(1, #campaign_special.id, SpecialList, NewSpe),
                                    NewRole = NRole#role{campaign = Campaign#campaign_role{special_list = NewSpecialList}},
                                    log:log(log_handle_all, {15814, <<"登陆活动">>, util:fbin("领取类型:~w",[Flag]), Role}),
                                    {ok, NewRole}
                            end;
                        _Err ->
                            ?DEBUG("~w",[_Err]),
                            {false, ?L(<<"不存在该阶段的奖励">>)}
                    end
            end
    end.

pay(Role) ->
    {NewRole = #role{campaign = Campaign = #campaign_role{special_list = SpecialList}}, _} = special_list(Role), 
    case lists:keyfind(1, #campaign_special.id, SpecialList) of
        #campaign_special{status = 1} -> NewRole;
        Spe = #campaign_special{cond_list = CondList} ->
            NewCondList = case lists:keyfind(?camp_spe_charge, 1, CondList) of
                {?camp_spe_charge, 0} ->
                    lists:keyreplace(?camp_spe_charge, 1, CondList, {?camp_spe_charge, 1});
                _ ->
                    CondList
            end,
            NewSpe = Spe#campaign_special{cond_list = NewCondList},
            NewRole#role{campaign = Campaign#campaign_role{special_list = lists:keyreplace(1, #campaign_special.id, SpecialList, NewSpe)}};
        _ -> NewRole
    end.

online(Role = #role{campaign = #campaign_role{day_online = {_, Time}}}) when Time >= 1800 ->
    {NewRole = #role{campaign = Campaign = #campaign_role{special_list = SpecialList}}, _} = special_list(Role),
    case lists:keyfind(1, #campaign_special.id, SpecialList) of
        #campaign_special{status = 1} -> NewRole;
        Spe = #campaign_special{cond_list = CondList} ->
            NewCondList = case lists:keyfind(?camp_spe_time_30, 1, CondList) of
                {?camp_spe_time_30, 0} ->
                    lists:keyreplace(?camp_spe_time_30, 1, CondList, {?camp_spe_time_30, 1});
                _ ->
                    CondList
            end,
            NewSpe = Spe#campaign_special{cond_list = NewCondList},
            NewRole#role{campaign = Campaign#campaign_role{special_list = lists:keyreplace(1, #campaign_special.id, SpecialList, NewSpe)}};
        _ -> NewRole
    end;
online(Role) ->
    Role.

%% 检测符合第几阶段 
check_special_list(SpecialList) ->
    check_special_list(SpecialList, []).
check_special_list([], Acc) ->
    A1 = [1] -- Acc,
    A2 = [1, 2] -- Acc,
    A3 = [1, 2, 3] -- Acc,
    A4 = [1, 2, 3, 4] -- Acc,
    if
        A4 =:= [] -> 4;
        A3 =:= [] -> 3;
        A2 =:= [] -> 2;
        A1 =:= [] -> 1;
        true -> 0
    end;
check_special_list([#campaign_special{cond_list = CondList} | T], Acc) ->
    Ac = do_check_cond(CondList, []),
    check_special_list(T, Ac ++ Acc).

do_check_cond([], Ac) -> Ac;
do_check_cond([{Flag, 1} | T], Ac) -> do_check_cond(T, [Flag | Ac]);
do_check_cond([_ | T], Ac) -> do_check_cond(T, Ac).
