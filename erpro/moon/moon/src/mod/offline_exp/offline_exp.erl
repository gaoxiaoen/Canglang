%%----------------------------------------------------
%% 离线经验 
%% 
%% @author Shawn 
%% @modify wpf (wprehard@qq.com)
%%----------------------------------------------------
-module(offline_exp).
-export([
        calc_time_to_exp/1
       ,init/0
       ,login/1
       ,logout/1
       ,ver_parse/1
       ,day_check/1
       ,get_item/2
       ,clean_login_line/1
       ,pack_login_table/1
       ,pack_offtime_table/1
       ,clean_offtime_table/3
       ,add_sit_exp_buff/2
       ,check_num_of_sitexp/3
       ,get_camp_item/1
       ,get_camp/0
    ]

).

-include("role.hrl").
-include("common.hrl").
-include("offline_exp.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("assets.hrl").
%%

%% @spec get_role_info(Role) ->
%% @doc 获取玩家离线累计经验
calc_time_to_exp(#role{offline_exp = #offline_exp{all_time = AllTime, all_exp = AllExp}}) ->
    {AllExp, AllTime}.

%% @spec init() -> OffInfo
init() ->
    Now = util:unixtime(),
    #offline_exp{all_time = 0, login_line = {1, 1, Now}}.

clean_offtime_table(Role = #role{offline_exp = OffInfo}, Exp, Time) ->
    NewOffInfo = OffInfo#offline_exp{all_time = Time, all_exp = Exp},
    NewRole = Role#role{offline_exp = NewOffInfo},
    pack_offtime_table(NewRole),
    NewRole.

%% @spec ver_parse(OldOffline) -> NewOffline
%% @doc 版本更新解析接口
ver_parse({offline_exp, AllTime, AllExp, LastLogout, LoginLine, SitExp}) ->
    ver_parse({offline_exp, AllTime, AllExp, LastLogout, LoginLine, SitExp, 0});
ver_parse({offline_exp, AllTime, AllExp, LastLogout, {_Id, _Day, Time}, SitExp, Award5Day}) ->
    NewLoginLine = {1, 1, Time}, 
    ver_parse({offline_exp, 0, AllTime, AllExp, LastLogout, NewLoginLine, SitExp, Award5Day});
ver_parse({offline_exp, 0, AllTime, AllExp, LastLogout, LoginLine, SitExp, Award5Day}) ->
    CampLine = {0, 0, 0}, %% 活动ID, 连续天数, 是否领取
    ver_parse({offline_exp, 1, AllTime, AllExp, LastLogout, LoginLine, SitExp, Award5Day, CampLine});
ver_parse(OffLine = #offline_exp{ver = ?offline_exp_ver}) ->
    {ok, OffLine};
ver_parse(_) -> {false, ?L(<<"角色离线数据版本转换错误">>)}.


%% 获取当前活动的时间
get_camp() ->
    BeginTime = util:datetime_to_seconds({{2012, 9,28},{0,0,1}}),
    EndTime = util:datetime_to_seconds({{2012,10,7},{23,59,59}}),
    {BeginTime, EndTime}.

%% 获取当前活动的ID
get_camp_id() -> 1. %% 国庆

%% @spec online_update(Role) -> NewRole
%% @doc 上线更新玩家离线累计经验
login(Role = #role{lev = Lev, offline_exp = OffInfo = #offline_exp{camp_line = CampLine = {OldCampId, _, _}}}) ->
    Now = util:unixtime(),
    Last = OffInfo#offline_exp.last_logout_time,
    NewInfo = case Last =:= 0 of
        true -> OffInfo#offline_exp{login_line = {1, 1, Now}};
        false -> calc_newtime(Last, Now, Lev, OffInfo)
    end,
    NewCampLine = {CampId, CampDay, CampFlag} = case OldCampId =:= get_camp_id() of
        false -> {get_camp_id(), 0, 0};
        true -> CampLine
    end,
    {CampBeginTime, CampEndTime} = get_camp(),
    CampCheckDay = util:unixtime({today, CampBeginTime}),
    Tomorrow = util:unixtime({today,Now}) + 86410,
    {Id, KeepDay, Time} = NewInfo#offline_exp.login_line,
    {NewLoginLine, NewCampLine1} = case day_diff(Now, Time) of
        0 ->
            {{Id, KeepDay, Now}, NewCampLine};
        1 ->
            case Now >= CampBeginTime andalso Now =< CampEndTime of
                true ->
                    case util:unixtime({today, Now}) =< CampCheckDay of
                        true ->
                            {{Id, KeepDay + 1, Now}, NewCampLine};
                        false -> 
                            {{Id, KeepDay + 1, Now}, {CampId, CampDay + 1, CampFlag}}
                    end;
                false ->
                    {{Id, KeepDay + 1, Now}, NewCampLine}
            end;
        _ -> {{1, 1, Now}, {CampId, 0, CampFlag}}
    end,
    NewAward5day = case day_diff(Now, Last) of
        Day when Day >= 6 andalso Lev >= 45 andalso Last =/= 0 ->
            1;
        _D when Last =:= 0 ->
            ?DEBUG("首次登陆,无礼包"),
            OffInfo#offline_exp.award_logout5day;
        _X ->
            ?DEBUG("离线:~w天,等级:~w,Last:~w",[_X, Lev, Last]),
            OffInfo#offline_exp.award_logout5day
    end,
    NewOffInfo = NewInfo#offline_exp{login_line = NewLoginLine, award_logout5day = NewAward5day, camp_line = NewCampLine1},
    NewRole = Role#role{offline_exp = NewOffInfo},
    role_timer:set_timer(loginline, (Tomorrow - Now) * 1000, {offline_exp, day_check, []}, 1, NewRole),
    %% 登陆重置5倍修炼
    case util:is_same_day2(Last, Now) of
        true -> NewRole;
        false -> NewRole#role{offline_exp = NewOffInfo#offline_exp{sit_exp5 = {0, 0}}}
    end.

%% 隔天检查
day_check(Role = #role{offline_exp = OffInfo = #offline_exp{login_line = {Id, KeepDay, Time}, camp_line = CampLine = {OldCampId, _, _}}}) ->
    Now = util:unixtime(),
    NewCampLine = {CampId, CampDay, CampFlag} = case OldCampId =:= get_camp_id() of
        false -> {get_camp_id(), 0, 0};
        true -> CampLine
    end,
    {CampBeginTime, CampEndTime} = get_camp(),
    CampCheckDay = util:unixtime({today, CampBeginTime}),
    {NewLoginLine, NewCampLine1} = case day_diff(Now, Time) of
        0 ->
            {{Id, KeepDay, Now}, NewCampLine};
        1 ->
            case Now >= CampBeginTime andalso Now =< CampEndTime of
                true ->
                    case util:unixtime({today, Now}) =< CampCheckDay of
                        true ->
                            {{Id, KeepDay + 1, Now}, NewCampLine};
                        false ->
                            {{Id, KeepDay + 1, Now}, {CampId, CampDay + 1, CampFlag}}
                    end;
                false ->
                    {{Id, KeepDay + 1, Now}, NewCampLine}
            end;
        _ ->
            {{1, 1, Now}, {CampId, 0, CampFlag}}
    end,
    NewOffInfo = OffInfo#offline_exp{login_line = NewLoginLine, camp_line = NewCampLine1},
    Nr = Role#role{offline_exp = NewOffInfo},
    pack_login_table(Nr),
    role_timer:set_timer(loginline, 86410 * 1000, {offline_exp, day_check, []}, 1, Nr),
    {ok, Nr}.

%% 领取活动物品
get_camp_item(#role{offline_exp = #offline_exp{camp_line = {_, _, 1}}}) -> {false, ?L(<<"您已经领取过奖励,活动期间仅能领取一次奖励">>)};
get_camp_item(Role = #role{offline_exp = OffInfo = #offline_exp{camp_line = {CampId, Day, _}}}) ->
    case CampId =:= get_camp_id() of
        false -> {false, ?L(<<"您当前未达到活动条件">>)};
        true ->
            {GainFlag, Gain} = if
                Day =:= 1 ->
                    {true, [#gain{label = item, val = [29266, 1, 1]}]};
                Day =:= 2 ->
                    {true, [#gain{label = item, val = [29266, 1, 2]}]};
                Day =:= 3 ->
                    {true, [#gain{label = item, val = [29266, 1, 3]}]};
                Day =:= 4 ->
                    {true, [#gain{label = item, val = [29266, 1, 4]}]};
                Day =:= 5 ->
                    {true, [#gain{label = item, val = [29266, 1, 5]}]};
                Day =:= 6 ->
                    {true, [#gain{label = item, val = [29266, 1, 6]}]};
                Day =:= 7 ->
                    {true, [#gain{label = item, val = [29266, 1, 7]}]};
                Day =:= 8 ->
                    {true, [#gain{label = item, val = [29266, 1, 8]}]};
                Day >= 9 ->
                    {true, [#gain{label = item, val = [29266, 1, 9]}
                            ,#gain{label = item, val = [21022, 1, 2]}]};
                true ->
                    {false, []}
            end,
            case GainFlag of
                false -> {false, ?L(<<"您未达到活动条件,无法领取">>)};
                true ->
                    case role_gain:do(Gain, Role) of
                        {false, _G} -> {false, ?L(<<"背包已满, 请整理背包再来领取">>)};
                        {ok, NewRole} ->
                            NewCamp = {CampId, Day, 1},
                            Nr = NewRole#role{offline_exp = OffInfo#offline_exp{camp_line = NewCamp}},
                            log:log(log_handle_all, {13915, <<"活动领取">>, util:fbin(<<"领取连续登陆天数:~w">>,[Day]), Nr}),
                            {ok, Nr}
                    end
            end
    end.

%% @spec logout(Role) -> NewRole
%% @doc 下线保存离线时间
logout(Role = #role{offline_exp = OffInfo}) ->
    Now = util:unixtime(),
    {ok, Role#role{offline_exp = OffInfo#offline_exp{last_logout_time = Now}}}.

%% @spec get_item(Role) -> {ok, NewRole} | {false, Reason}
%% @doc 领取连续登陆奖励
get_item(#role{assets = #assets{charge = Charge}}, 1) when Charge =< 0 -> 
    {false, ?L(<<"只有充值玩家才能领取">>)};
get_item(#role{assets = #assets{charge = Charge}}, 0) when Charge > 0 -> 
    {false, ?L(<<"只有非充值玩家才能领取">>)};

get_item(Role = #role{assets = #assets{charge = Charge}, offline_exp = OffInfo = #offline_exp{login_line = {Id, KeepDay, Time}}}, 1) when Charge > 0 ->
    Now = util:unixtime(),
    {Id, Day, ItemId, Num} = lists:keyfind(Id, 1, ?RMB_AWARD),
    case KeepDay >= Day of
        true -> 
            case role_gain:do([#gain{label = item, val = [ItemId, 1, Num]}], Role) of
                {false, _G} -> {false, ?L(<<"背包已满,请整理背包之后再来领取">>)};
                {ok, NewRole} ->
                    NewLoginLine = case Id =:= 20 of
                        true -> {1, 1, Now};
                        false -> {Id + 1, KeepDay, Time}
                    end,
                    Nr = NewRole#role{offline_exp = OffInfo#offline_exp{login_line = NewLoginLine}},
                    pack_login_table(Nr),
                    {ok, Nr}
            end;
        false -> {false, ?L(<<"天数不足,无法领取">>)}
    end;

get_item(Role = #role{assets = #assets{charge = Charge}, offline_exp = OffInfo = #offline_exp{login_line = {Id, KeepDay, Time}}}, 0) when Charge =< 0 ->
    Now = util:unixtime(),
    {Id, Day, ItemId, Num} = lists:keyfind(Id, 1, ?NORMAL_AWARD),
    case KeepDay >= Day of
        true -> 
            case role_gain:do([#gain{label = item, val = [ItemId, 1, Num]}], Role) of
                {false, _G} -> {false, ?L(<<"背包已满,请整理背包之后再来领取">>)};
                {ok, NewRole} ->
                    NewLoginLine = case Id =:= 20 of
                        true -> {1, 1, Now};
                        false -> {Id + 1, KeepDay, Time}
                    end,
                    Nr = NewRole#role{offline_exp = OffInfo#offline_exp{login_line = NewLoginLine}},
                    pack_login_table(Nr),
                    {ok, Nr}
            end;
        false -> {false, ?L(<<"天数不足,无法领取">>)}
    end.

%% @spec pack_login_table(Role) -> ok
%% @doc 刷新连续登陆面板
pack_login_table(#role{assets = #assets{charge = Charge}, link = #link{conn_pid = ConnPid}, offline_exp = #offline_exp{login_line = {Id, KeepDay, _Time}}}) when Charge > 0 ->
    sys_conn:pack_send(ConnPid, 13900, {1, KeepDay, Id}); 
pack_login_table(#role{assets = #assets{charge = Charge}, link = #link{conn_pid = ConnPid}, offline_exp = #offline_exp{login_line = {Id, KeepDay, _Time}}}) when Charge =:= 0 ->
    sys_conn:pack_send(ConnPid, 13900, {0, KeepDay, Id}). 

%% @spec pack_offtime_table(Role) -> ok
%% @doc 刷新离线经验面板
pack_offtime_table(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    Data = calc_time_to_exp(Role),
    sys_conn:pack_send(ConnPid, 13903, Data). 

calc_newtime(_Last, _Now, Lev, OffInfo) when Lev < 40 -> OffInfo;
calc_newtime(Last, Now, Lev, OffInfo = #offline_exp{all_time = AllTime, all_exp = AllExp}) ->
    {NewTime, NewExp} = case AllTime + (Now - Last) > 86400 * 7 of
        %% TODO: true -> {86400 * 7, AllExp + (Now - Last) div 60 * role_exp_data:get_sit_exp(Lev)};
        true -> {86400 * 7, AllExp + ((86400*7-AllTime) div 60 * role_exp_data:get_sit_exp(Lev))};
        false -> {AllTime + (Now - Last), AllExp + (Now - Last) div 60 * role_exp_data:get_sit_exp(Lev)}
    end,
    OffInfo#offline_exp{all_time = NewTime, all_exp = NewExp}.

clean_login_line(Role = #role{offline_exp = OffInfo}) ->
    Now = util:unixtime(),
    Nr = Role#role{offline_exp = OffInfo#offline_exp{login_line = {1, 1, Now}}},
    pack_login_table(Nr),
    Nr.

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

%% @spec add_sit_exp_buff(Role, Num) -> {ok, NewRole} | {false, Reason}
%% @doc 增加5倍修炼buff
add_sit_exp_buff(Role, 1) ->
    buff:add(Role, sit_exp5_1);
add_sit_exp_buff(Role, 3) ->
    buff:add(Role, sit_exp5_3);
add_sit_exp_buff(Role, _) ->
    {ok, Role}.

%% @spec check_num_of_sitexp(MaxNum, RecNum, NowNum) -> {ok, NewNum} | {false, Reason}
%% @doc 计算是否可领取，可领多长时间
check_num_of_sitexp(MaxNum, RecNum, NowNum) ->
    case NowNum >= MaxNum of
        true ->
            {false, ?L(<<"您当天的5倍修炼时间已全部领取">>)};
        false ->
            NewNum = NowNum + RecNum,
            case NewNum =< MaxNum of
                false ->
                    {false, util:fbin(?L(<<"您当天的5倍修炼时间只剩~w小时">>), [MaxNum - NowNum])};
                true ->
                    {ok, NewNum}
            end
    end.
