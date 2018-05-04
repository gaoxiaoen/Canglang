-module(seven_day_award).

-export(
    [
        login/1
        ,logout/1
        ,online_timer_callback/1
        ,day_check/1
        ,push/1
        ,get_award/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("seven_day_award.hrl").


-define(three_day_sec, 86400*3).
-define(one_houre_sec, 3600).
-define(award_1, 1). %% 第一类七天
-define(award_2, 2). %% 第二类七天奖励

-define(unactivate, 0). %% 未激活
-define(can_get, 1).    %% 可以领取
-define(has_got, 2).    %% 已经领取

%% -------------------  对外接口  --------------------------

%login(Role = #role{lev = Lev, seven_day_award = SevenDayAward = #seven_day_award{online_info = I}}) when Lev < 20 ->
%    Role#role{seven_day_award = SevenDayAward#seven_day_award{online_info = I#online_info{last_login = util:unixtime()}}};
login(Role = #role{seven_day_award = SevenDayAward = 
                #seven_day_award{ online_info = #online_info{last_login = LastLogin}}}) ->

    Now = util:unixtime(),

    Role2 = #role{seven_day_award = SevenDayAward1} =
    case {is_award1_finish(Role), is_get_all_award(Role), (Now - LastLogin) >= ?three_day_sec} of
        {true, true, true} ->
            do_login(LastLogin, Role#role{seven_day_award = SevenDayAward#seven_day_award{type = ?award_2, awards = ?init_awards_info}});
        _ ->
            do_login(LastLogin, Role)
    end,

    Role3 = Role2#role{seven_day_award = SevenDayAward1#seven_day_award{online_info = #online_info{last_login = Now}}},
    push(Role3),
    Tomorrow = util:unixtime({tomorrow, Now}) - Now,
    role_timer:set_timer(seven_day_award_day_check, Tomorrow * 1000, {?MODULE, day_check, []}, 1, Role3).


%% 下线纪录在线时间
logout(Role = #role{seven_day_award = SevenDayAward = #seven_day_award{online_info = Info = #online_info{online_time = OT, last_login = LastLogin}}}) ->
    Now = util:unixtime(),
    Role1 = Role#role{seven_day_award = SevenDayAward#seven_day_award{online_info = Info#online_info{online_time = OT + Now - LastLogin, last_login = Now}}},
    {ok, Role1}.


online_timer_callback(Role = #role{seven_day_award = SevenDayAward = #seven_day_award{awards = Awds}}) ->
    Len = get_unactivity_award_num(Role),
    case Len >= 7 of
        true -> 
            {ok, Role};
        false ->
            Day = Len + 1,
            case lists:keyfind(Day, #award.day, Awds) of
                A = #award{} ->
                    L = lists:keyreplace(Day, #award.day, Awds, A#award{flag = ?can_get}),
                    {ok, Role#role{seven_day_award = SevenDayAward#seven_day_award{awards = L}}};
                false ->
                    Awds1 = [#award{day = Day, flag = 1} | Awds],
                    Role1 = Role#role{seven_day_award = SevenDayAward#seven_day_award{awards = Awds1}},
                    push(Role1),
                    {ok, Role1}
            end
    end.

%% 登陆激活一个奖励
activate_award(Role = #role{seven_day_award = SevenDayAward = #seven_day_award{awards = Awds}}) ->
    N = get_unactivity_award_num(Role),
    Len = 7 - N,
    case Len >= 7 of
        true -> 
            Role;
        false ->
            Day = Len + 1,
            case lists:keyfind(Day, #award.day, Awds) of
                A = #award{} ->
                    L = lists:keyreplace(Day, #award.day, Awds, A#award{flag = ?can_get}),
                    Role#role{seven_day_award = SevenDayAward#seven_day_award{awards = L}};
                false ->
                    Awds1 = [#award{day = Day, flag = 1} | Awds],
                    Role1 = Role#role{seven_day_award = SevenDayAward#seven_day_award{awards = Awds1}},
                    %% push(Role1),
                    Role1
            end
    end.


day_check(Role) ->
    Now = util:unixtime(),
    Role1 = #role{seven_day_award = SevenDayAward} = activate_award(Role),
    Role2 = Role1#role{seven_day_award = SevenDayAward#seven_day_award{online_info = #online_info{last_login = Now}}},
    Tomorrow = util:unixtime({tomorrow, Now}) - Now,
    Role3 = role_timer:set_timer(seven_day_award_day_check, Tomorrow * 1000, {?MODULE, day_check, []}, 1, Role2),
    push(Role3),
    {ok, Role3}.

push(#role{link = #link{conn_pid = ConnPid}, seven_day_award = #seven_day_award{type = Type, awards = Awds}}) ->
    All = [{D,F} || #award{day = D, flag = F} <- Awds],
    sys_conn:pack_send(ConnPid, 19700, {Type, All}).

%% 领取奖励
get_award(Day, Role = #role{seven_day_award = SevenDayAward = #seven_day_award{type = Type, awards = Awds}}) ->
    case lists:keyfind(Day, #award.day, Awds) of
        #award{flag = ?can_get} ->
            List = lists:keyreplace(Day, #award.day, Awds, #award{day = Day, flag = ?has_got}),
            Role1 = Role#role{seven_day_award = SevenDayAward#seven_day_award{awards = List}},
            case sevenday_award_data:get({Type, Day}) of
                false ->
                    ?DEBUG(" 没有奖励配置  "),
                    {ok,Role1};
                Gains ->
                    {ok, do_gains(Gains, Role1, 0)}
            end;
        #award{flag = ?has_got} ->
            {?false, ?L(<<"不能重复领取">>)};
        #award{flag = ?unactivate} ->
            {?false, ?L(<<"还没激活，不能领取">>)};
        false ->
            {?false, ?L(<<"不能领取此奖励">>)}
    end.


%% ----------------------  私有函数  -----------------------

%% 计算是否已领完所有奖励
is_get_all_award(#role{seven_day_award = #seven_day_award{awards = Awards}}) ->
    lists:foldl(fun(#award{flag = Flag}, Sum)-> Sum + Flag end, 0, Awards) =:= 14.

do_gains([], Role, Len) ->
    case Len > 0 of
        true ->
            notice:alert(succ, Role, ?MSGID(<<"背包已满，奖励发送到奖励大厅">>));
        false ->
            skip
    end,
    Role;
do_gains([{Label, V} | T], Role = #role{id = Rid}, Len) ->
    case role_gain:do(G = [#gain{label = Label, val = V}], Role) of
        {false, _R} ->
            award:send(Rid, 301001, G),
            do_gains(T, Role, Len+1);
        {ok, Role1} ->
            do_gains(T, Role1, Len)
    end.

get_unactivity_award_num(#role{seven_day_award = #seven_day_award{awards = Awds}}) ->
    L = [F || #award{flag = F} <- Awds, F =:= ?unactivate],
    length(L).

is_award1_finish(#role{seven_day_award = #seven_day_award{type = Type, awards = Awds}}) ->
    case Type =:= award_2 of
        true -> true;
        false ->
            lists:foldl(fun(#award{flag = F}, Sum)-> F+Sum end, 0, Awds) =:= 14 %% 7个，如果每个都是已领取，就是14
    end.

do_login(LastLogin, Role) ->
    case util:is_today(LastLogin) of
        true ->
            Role;
        false ->
            activate_award(Role)
    end.
