%%----------------------------------------------------
%% 离线经验 
%% 
%% @author Shawn 
%%----------------------------------------------------
-module(offline_exp_rpc).
-export([
        handle/3
    ]
).

-include("role.hrl").
-include("offline_exp.hrl").
-include("gain.hrl").
-include("common.hrl").
-include("assets.hrl").
%%

%% 获取连续登陆面板
handle(13900, {}, #role{assets = #assets{charge = Charge}, offline_exp = #offline_exp{login_line = {Id, KeepDay, _Time}}}) ->
    Flag = case Charge > 0 of
        true -> 1; false -> 0
    end,
    {reply, {Flag, KeepDay, Id}};

%% 领取连续登陆奖励
handle(13901, _, #role{lev = Lev}) when Lev < 40 -> {reply, {0, ?L(<<"40级以上的玩家才能领取奖励">>)}};
handle(13901, {Type}, Role = #role{offline_exp = #offline_exp{login_line = {Id, KeepDay, Time}}}) ->
    case offline_exp:get_item(Role, Type) of
        {false, Reason} ->
            {reply, {0, Reason}};
        {ok, NewRole = #role{offline_exp = #offline_exp{login_line = {Id2, KeepDay2, Time2}}}} ->
            log:log(log_handle_all, {13901, <<"领取连续奖励">>, util:fbin(<<"领取前[~w:~w:~w],领取后[~w:~w:~w]">>, [Id, KeepDay, Time, Id2, KeepDay2, Time2]), NewRole}),
            {reply, {1, <<>>}, NewRole}
    end;

%% 登陆天数清零
handle(13902, {}, Role) ->
    NewRole = offline_exp:clean_login_line(Role),
    {reply, {1, ?L(<<"清零成功">>)}, NewRole};

%% 获取离线经验数
handle(13903, {}, Role) ->
    {AllExp, AllTime} = offline_exp:calc_time_to_exp(Role),
    {reply, {AllExp div 4, AllTime}};

%% 领取离线经验
handle(13904, {1, Hour}, Role) when Hour > 0 ->
    {Exp, Time} = offline_exp:calc_time_to_exp(Role),
    AllHour = Time div 3600,
    case Hour =< AllHour of
        true ->
            NormalHourExp = Exp div AllHour,
            HourExp = NormalHourExp div 4,
            {GetExp, NewExp, NewTime} = case AllHour =:= Hour of
                true -> {Exp div 4, 0, 0};
                false -> {HourExp * Hour, Exp - (NormalHourExp * Hour), Time - (Hour*3600)}
            end,
            case role_gain:do([#gain{label = exp, val = GetExp}], Role) of
                {false, _G} -> {reply, {0, ?L(<<"领取离线经验失败">>)}};
                {ok, NewRole} ->
                    Nrole = offline_exp:clean_offtime_table(NewRole, NewExp, NewTime),
                    notice:inform(util:fbin(?L(<<"成功领取离线经验:~w">>),[GetExp])),
                    log:log(log_handle_all, {13904, <<"领取离线经验">>, util:fbin("免费领取[时间:~w 经验:~w]", [Hour, GetExp]), Role}),
                    {reply, {1, util:fbin(?L(<<"成功领取离线经验:~w">>),[GetExp])}, Nrole}
            end;
        false -> {reply, {0, ?L(<<"没有足够的小时领取">>)}}
    end;

handle(13904, {2, Hour}, Role) when Hour > 0 ->
    {Exp, Time} = offline_exp:calc_time_to_exp(Role),
    AllHour = Time div 3600,
    case Hour =< AllHour of
        true ->
            NormalHourExp = Exp div AllHour,
            HourExp = NormalHourExp div 2,
            {GetExp, NewExp, NewTime} = case AllHour =:= Hour of
                true -> {Exp div 2, 0, 0};
                false -> {HourExp * Hour, Exp - (NormalHourExp * Hour), Time - (Hour*3600)}
            end,
            Coin = util:ceil(GetExp / 5),
            case role_gain:do([#loss{label = coin_all, val = Coin, msg = ?L(<<"金币不足,无法领取">>)},
                        #gain{label = exp, val = GetExp}], Role) of
                {false, #gain{}} -> {reply, {0, ?L(<<"领取离线经验失败">>)}};
                {false, #loss{msg = Msg, err_code = ErrCode}} -> {reply, {ErrCode, Msg}};
                {ok, NewRole} ->
                    Nrole = offline_exp:clean_offtime_table(NewRole, NewExp, NewTime),
                    notice:inform(util:fbin(?L(<<"成功领取离线经验:~w">>),[GetExp])),
                    log:log(log_coin, {<<"领取离线经验">>, util:fbin(<<"经验~w">>, [GetExp]), Role, NewRole}),
                    {reply, {1, util:fbin(?L(<<"成功领取离线经验:~w">>),[GetExp])}, Nrole}
            end;
        false -> {reply, {0, ?L(<<"没有足够的小时领取">>)}}
    end;

handle(13904, {3, Hour}, Role) when Hour > 0 ->
    {Exp, Time} = offline_exp:calc_time_to_exp(Role),
    AllHour = Time div 3600,
    case Hour =< AllHour of
        true ->
            HourExp = Exp div AllHour, 
            {GetExp, NewTime} = case AllHour =:= Hour of
                true -> {Exp, 0};
                false -> {HourExp * Hour, Time - (Hour *3600)}
            end,
            Coin = pay:price(?MODULE, offline_exp, GetExp),
            NewExp = Exp - GetExp,
            case role_gain:do([#loss{label = gold, val = Coin, msg = ?L(<<"晶钻不足,无法领取">>)},
                        #gain{label = exp, val = GetExp}], Role) of
                {false, #gain{}} -> {reply, {0, ?L(<<"领取离线经验失败">>)}};
                {false, L} -> {reply, {0, L#loss.msg}};
                {ok, NewRole} ->
                    Nrole = offline_exp:clean_offtime_table(NewRole, NewExp, NewTime),
                    notice:inform(util:fbin(?L(<<"成功领取离线经验:~w">>),[GetExp])),
                    {reply, {1, util:fbin(?L(<<"成功领取离线经验:~w">>),[GetExp])}, Nrole}
            end;
        false -> {reply, {0, ?L(<<"没有足够的小时领取">>)}}
    end;

%% 领取5倍修炼
handle(13910, {_Num}, #role{lev = Lev}) when Lev < 40 ->
    {reply, {?false, 3, ?L(<<"40级以上的玩家才能领取奖励">>)}};
handle(13910, {Num}, Role = #role{lev = Lev, offline_exp = Off = #offline_exp{sit_exp5 = {NowNum, Last}}})
when Num =:= 1 orelse Num =:= 3 ->
    Now = util:unixtime(),
    Val = Num * Lev * 144,
    LossList = [#loss{label = coin_all, val = Val}],
    case util:is_same_day2(Last, Now) of
        false -> %% 上次领取在前一天
            case role_gain:do(LossList, Role) of
                {false, #loss{err_code = ErrCode}} ->
                    {reply, {ErrCode, (3 - NowNum), ?L(<<"金币不足,无法领取">>)}};
                {ok, NR0} ->
                    case offline_exp:add_sit_exp_buff(NR0, Num) of
                        {ok, NR1} ->
                            NewRole = NR1#role{offline_exp = Off#offline_exp{sit_exp5 = {Num, Now}}},
                            notice:inform(util:fbin(?L(<<"领取5倍修炼~w小时\n消耗 ~w铜币">>), [Num, Val])),
                            log:log(log_coin, {<<"领取5倍修炼">>, <<"">>, Role, NewRole}),
                            NewRole1 = role_listener:special_event(NewRole, {30008, 1}),
                            {reply, {?true, (3 - Num), util:fbin(?L(<<"领取成功，您当天的5倍修炼时间还剩~w小时">>), [3 - Num])}, role_api:push_attr(NewRole1)};
                        {false, Reason} ->
                            {reply, {?false, (3 - NowNum), Reason}}
                    end
            end;
        true -> %% 当天已领过
            case offline_exp:check_num_of_sitexp(3, Num, NowNum) of
                {false, Msg} ->
                    {reply, {?false, (3 - NowNum), Msg}};
                {ok, NewNum} ->
                    case role_gain:do(LossList, Role) of
                        {false, #loss{err_code = ErrCode}} ->
                            {reply, {ErrCode, (3 - NowNum), ?L(<<"金币不足,无法领取">>)}};
                        {ok, NR0} ->
                            case offline_exp:add_sit_exp_buff(NR0, Num) of
                                {ok, NR1} ->
                                    NewRole = NR1#role{offline_exp = Off#offline_exp{sit_exp5 = {NewNum, Now}}},
                                    notice:inform(util:fbin(?L(<<"领取5倍修炼~w小时\n消耗 ~w铜币">>), [Num, Val])),
                                    log:log(log_coin, {<<"领取5倍修炼">>, <<"">>, Role, NewRole}),
                                    NewRole1 = role_listener:special_event(NewRole, {30008, 1}),
                                    {reply, {?true, (3 - NewNum), util:fbin(?L(<<"领取成功，您当天的5倍修炼时间还剩~w小时">>), [3 - NewNum])}, role_api:push_attr(NewRole1)};
                                {false, Reason} ->
                                    {reply, {?false, (3 - NowNum), Reason}}
                            end
                    end
            end
    end;
handle(13910, {Num}, R = #role{offline_exp = Off}) when Num =:= 1 orelse Num =:= 3 ->
    ?ELOG("角色[NAME:~s]领取5倍修炼修复OFF:~w", [R#role.name, R#role.offline_exp]),
    {ok, R#role{offline_exp = Off#offline_exp{sit_exp5 = {0, 0}}}};
handle(13910, _D, _R) ->
    ?ELOG("角色[NAME:~s]领取5倍修炼异常DATA:~w, OFF:~w", [_R#role.name, _D, _R#role.offline_exp]),
    {ok};

%% 获取五倍修炼信息
handle(13911, {}, #role{offline_exp = #offline_exp{sit_exp5 = {NewNum, _}}}) ->
    {reply, {3, (3 - NewNum)}};
handle(13911, {}, _R) ->
    ?ERR("获取五倍修炼时间出错：~w", [_R#role.offline_exp]),
    {reply, {3, 3}};

%% 请求5天离线礼包
handle(13912, {}, #role{offline_exp = #offline_exp{award_logout5day = Award5day}})
when Award5day =:= ?true ->
    case campaign_data:get_offline_camp() of
        true -> {reply, {?true}};
        false -> {reply, {?false}}
    end;
handle(13912, {}, _Role) -> {reply, {?false}};

%% 领取5天离线礼包
handle(13913, {}, Role = #role{offline_exp = OffInfo = #offline_exp{award_logout5day = Award5day}})
when Award5day =:= ?true ->
    case campaign_data:get_offline_camp() of
        true ->
            case role_gain:do([#gain{label = item, val = [29041, 1, 1], msg = ?L(<<"背包已满, 请整理背包后再来领取">>)}], Role) of
                {false, G} -> {reply, {?false, G#gain.msg}};
                {ok, NewRole} ->
                    notice:inform(util:fbin(?L(<<"领取礼包\n获得{item3, ~w, ~w, ~w}">>),[29041, 1, 1])),
                    log:log(log_gift_award, {<<"王者礼包">>, 1, <<>>, <<"离线5天,领取王者礼包">>, Role}),
                    {reply, {?true, ?L(<<"成功领取王者归来礼包一份">>)}, NewRole#role{offline_exp = OffInfo#offline_exp{award_logout5day = ?false}}}
            end;
        false -> {ok}
    end;
handle(13913, {}, _Role) -> {reply, {?false, ?L(<<"条件不满足,无法领取">>)}};

%% 查询活动领取
handle(13914, {}, #role{offline_exp = #offline_exp{camp_line = {_, Day, Flag}}}) ->
    {CampBeginTime, CampEndTime} = offline_exp:get_camp(),
    Now = util:unixtime(),
    case Now >= CampBeginTime andalso Now =< CampEndTime of
        false -> {ok};
        true ->
            {reply, {Day, Flag}}
    end;

%% 领取活动物品
handle(13915, {}, Role) ->
    {CampBeginTime, CampEndTime} = offline_exp:get_camp(),
    Now = util:unixtime(),
    case Now >= CampBeginTime andalso Now =< CampEndTime of
        false -> {reply, {?false, ?L(<<"活动时间已过, 不可以领取奖励">>)}};
        true ->
            case offline_exp:get_camp_item(Role) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole} ->
                    {reply, {?true, ?L(<<"领取奖励成功">>)}, NewRole}
            end
    end;

%% 容错匹配
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
