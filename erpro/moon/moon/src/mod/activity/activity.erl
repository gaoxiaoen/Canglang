%%----------------------------------------------------
%%  活跃度系统
%%
%% @author shawnoyc@163.com
%%----------------------------------------------------
-module(activity).
-export([
        login/1
       ,logout/1
       ,update_act_limit/1
       ,day_check/1
       ,award_act/2
       ,update_award_time/0
       ,get_activity_table/1
       ,get_online_award/1
       ,pack_send_table/1
       ,pack_send_table/2
   ]
).

-include("activity.hrl").
-include("role.hrl").
-include("common.hrl").
-include("vip.hrl").
-include("link.hrl").
-include("arena_career.hrl").
-include("world_compete.hrl").

%% @spec login(Role) -> NewRole
%% @doc 登录加载,或者创建角色活跃度信息
login(Role = #role{id = {_, _SrvId}, account = _Account, name = _Name, link = #link{conn_pid = _ConnPid}}) ->
    Now = util:unixtime(),
    NewRole = create(Role),
    role:put_dict(act_login, Now),
    role:put_dict(act_award_time, Now),
    OnlineTime = get_online_time(NewRole#role.activity),
    Tomorrow = util:unixtime({today,Now}) + 86420,
    Nrole = case (Tomorrow - Now + OnlineTime) > ?ACT_ONLINE_TIME of
        true ->
            Time = 
            case OnlineTime > ?ACT_ONLINE_TIME of
                true -> 20; %%延时5秒执行
                false -> (?ACT_ONLINE_TIME - OnlineTime)
            end,
            role_timer:set_timer(act_online, Time * 1000, {activity, award_act, [act_online]}, 1, NewRole);
        false -> NewRole 
    end,
    role_timer:set_timer(act_tomorrow, (Tomorrow - Now) * 1000, {activity, day_check, []}, 1, Nrole).

%% 奖励回调
%% Award = {atom, Value}  AwardNum = {atom, Num}
award_act(Role = #role{day_activity = DayAct, activity = Activity = #activity{sum_limit = Limit, summary = Summary, award_detail = AwardDetail}}, Type) ->
    {Id, Type, Award, AwardNum} = lists:keyfind(Type, 2, ?ACTIVITY_AWARD),
    case lists:keyfind(Type, 2, AwardDetail) of
        false -> 
            NewSummary = case Summary + Award > Limit of
                true -> Limit; false -> Summary + Award
            end,
            NewActivity = Activity#activity{award_detail = [{Id, Type, Award, 1} | AwardDetail],
                summary = NewSummary},
            NewDayAct = DayAct + Award,
            %%TODO 保存数据库,写日志
            case Award =:= 0 of
                false ->
                    log:log(log_activity, {Summary, NewSummary, Award, <<"">>, Role});
                    % notice:inform(util:fbin(?L(<<"获得 {str, 精力值, #ffe500} ~w">>),[Award]));
                true -> ignore
            end,
            NewRole = role_listener:acc_event(Role, {116, Award}), %%获得精力值
            Nr = NewRole#role{day_activity = NewDayAct, activity = NewActivity},
            pack_send_table(Nr),
            {ok, Nr};
        {Id, Type, Raward, Num} when Num < AwardNum ->
            NewSummary = case Summary + Award > Limit of
                true -> Limit; false -> Summary + Award
            end,
            NewActivity=Activity#activity{award_detail = lists:keyreplace(Type, 2, AwardDetail, {Id,Type,Raward+Award,Num+1}),
             summary = NewSummary},
            NewDayAct = DayAct + Award,
            %%TODO 保存数据库,写日志
            case Award =:= 0 of
                false ->
                    log:log(log_activity, {Summary, NewSummary, Award, <<"">>, Role});
                    % notice:inform(util:fbin(?L(<<"获得 {str, 精力值, #ffe500} ~w">>),[Award]));
                true -> ignore
            end,
            NewRole = role_listener:acc_event(Role, {116, Award}), %%获得精力值
            Nr = NewRole#role{day_activity = NewDayAct, activity = NewActivity},
            pack_send_table(Nr),
            {ok, Nr};
        {Id, Type, Raward, Num} ->
            NewActivity=Activity#activity{award_detail = lists:keyreplace(Type, 2, AwardDetail, {Id,Type,Raward,Num+1})},
            NewRole = Role#role{activity = NewActivity},
            pack_send_table(NewRole),
            {ok, NewRole};
        _ -> {ok}
    end.


%% @spec update_act_limit(Role, Value) ->
%% @doc 更新活跃度上限
update_act_limit(Role = #role{vip = Vip, activity = Activity = #activity{summary = Sum}}) ->
    Value = case Vip#vip.type of
        ?vip_week -> 700; ?vip_month -> 800; ?vip_half_year -> 1000; _ -> 500
    end,
    NewSum = case Sum > Value of
        true -> Value; false -> Sum
    end,
    NewActivity = Activity#activity{summary = NewSum, sum_limit = Value},
    NewRole = Role#role{activity = NewActivity},
    pack_send_table(NewRole),
    NewRole.

%% @spec logout(Role) -> NewRole
%% @doc 下线记录玩家在线时间
logout(Role = #role{id = {_, _SrvId}, name = _Name, account = _Account, link = #link{conn_pid = _ConnPid}, activity = Activity = #activity{online_award = {Tag, OnlineTime}, assistant = Assistant}}) ->
    Ot = get_online_time(Activity) + (util:unixtime() - get_login_time()),
    Not = util:unixtime() - update_award_time() + OnlineTime,  
%%  notice:send_interface({connpid, ConnPid}, 13, Account, SrvId, Name, <<"">>, []),
    {ok, Role#role{activity = Activity#activity{online_award = {Tag, Not}, assistant = update_onlinetime(Assistant, Ot)}}}. 

%% 更新在线时间
update_onlinetime(Assistant, OnlineTime) ->
    case lists:keyfind(online_time, 1, Assistant) of
        false -> [{online_time, OnlineTime} | Assistant];
        {online_time, _} -> lists:keyreplace(online_time, 1, Assistant, {online_time, OnlineTime})
    end.

%% 领取在线奖励
get_online_award(Role = #role{activity = Activity = #activity{online_award = {Tag, OnlineTime}}})
when Tag >= 1 andalso Tag =< 12 ->
    Now = util:unixtime(),
    LastCheckTime = update_award_time(),
    {Tag, Label, Value, Time} = lists:keyfind(Tag, 1, ?ONLINE_AWARD),       
    {_, NextLabel, NextVal, NextTime} = case Tag =/= 12 of
        true -> lists:keyfind(Tag + 1, 1, ?ONLINE_AWARD);
        false -> {0, 0, 0, 0}
    end,
    NewTime = OnlineTime + (Now - LastCheckTime),
    case NewTime >= Time of
        true -> {true, Role#role{activity = Activity#activity{online_award = {Tag + 1, 0}}},
                Label, Value, NextLabel, NextVal, NextTime};
        false -> {false, Role#role{activity = Activity#activity{online_award = {Tag, NewTime}}}, Time - NewTime}
    end;
get_online_award(Role) -> {skip, Role}.
    

%% 日期检测,异步调用,返回格式 {ok, NewRole}
day_check(Role = #role{activity = Activity}) ->
    Now = util:unixtime(),
    case day_diff(Activity#activity.date, Now) =/= 0 of
        false -> {ok};
        true ->
            NewRole = create(Role),
            pack_send_table(NewRole),
            {ok, role_timer:set_timer(act_online, ?ACT_ONLINE_TIME * 1000,
                    {activity, award_act, [act_online]}, 1, NewRole)}
    end.

create(Role = #role{day_activity = DayAct, id = {Rid, SrvId}, activity = Activity = #activity{date = Date}}) ->
    {NewDayAct, Ractivity} =  case Date =:= 0 of
        true ->  %% 新号,第一次登录
            NewActivity = #activity{
                rid = Rid,     %%角色ID
                srvid = SrvId,
                date = util:unixtime(),
                award_detail = [],
                summary = 100,
                sum_limit = 500,
                use_detail = [],
                assistant = [],
                online_award ={1, 0},
                reg_time = util:unixtime()
            },
            {0, NewActivity};
        false -> %% 已经有记录的号
            case day_diff(Date, util:unixtime()) > 0 of %% 人物保存的是昨天之前的活跃度信息,清空
                true ->
                    NewActivity = Activity#activity{
                        date = util:unixtime(),
                        award_detail = [],
                        use_detail = [],
                        assistant = []
                    },
                    {0, NewActivity};
                false ->  %% 今天的记录,不做处理
                    {DayAct, Activity}
            end
    end,
    Role#role{day_activity = NewDayAct, activity = Ractivity}.

%% 获取已经在线的时间
get_online_time(#activity{assistant = Assistant}) ->
    case lists:keyfind(online_time, 1, Assistant) of
        false -> 0;
        {online_time, V} -> V
    end.

%% 更新奖励时间
update_award_time() ->
    Now = util:unixtime(),
    case role:get_dict(act_award_time) of
        {ok, undefined} ->
            role:put_dict(act_award_time, Now),
            Now;
        {ok, Time} ->
            role:put_dict(act_award_time, Now),
            Time;
        _ ->
            role:put_dict(act_award_time, Now),
            Now
    end.

%% 获取本次登录时间
get_login_time() ->
    case role:get_dict(act_login) of
        {ok, undefined} -> util:unixtime();
        {ok, Time} -> Time;
        _ -> util:unixtime()
    end.

get_activity_table(#role{activity = #activity{summary = Sum, sum_limit = SumLimit, award_detail = AwardDetail, use_detail = UseDetail}, dungeon = _Dun}) ->
    L = [{Id, Num} || {Id, _Type, _Award, Num} <- AwardDetail],
    L2 = [{Id, Num} || {Id, _Type, _Use, Num} <- UseDetail],
%%    {L ++ L2 ++ L3, Sum, SumLimit}. 
    {L ++ L2, Sum, SumLimit}. 

%% List = [{Id, Num}]
pack_send_table(List, #role{link = #link{conn_pid = ConnPid}, activity = #activity{summary = Sum, sum_limit = SumLimit}}) ->
    sys_conn:pack_send(ConnPid, 13800, {List, Sum, SumLimit}).

pack_send_table(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 13800, get_activity_table(Role)).

%% @spec day_diff(UnixTime, UnixTime) -> int()
%% @doc 两个unixtime相差的天数,相邻2天返回1
%% return int() 相差的天数
day_diff(FromTime, ToTime) when ToTime > FromTime ->
    FromDate = util:unixtime({today, FromTime}),
    ToDate = util:unixtime({today, ToTime}),
    case (ToDate - FromDate) / (3600 * 24) of
        Diff when Diff < 0 -> 0;
        Diff -> round(Diff)
    end;

day_diff(FromTime, ToTime) when ToTime=:=FromTime ->
    0;

day_diff(FromTime, ToTime) ->
    day_diff(ToTime, FromTime).

