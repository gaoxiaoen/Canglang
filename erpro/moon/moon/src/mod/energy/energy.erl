%%----------------------------------------------------
%%  1，处理角色体力相关
%%  2，处理军团在线一小相关逻辑
%%
%%----------------------------------------------------
-module(energy).
-export(
    [
        login/1
       ,logout/1
       ,day_check/1
       ,auto_add_energy/1
       ,spec_timer_callback/2
       ,get_online_time/1
       ,lev_up/1
       ,try_reset_auto_timer/1
       ,time2online_info/0
       ,have_new_energy/1
       ,id2detail/2
       ,use_energy_water/4
       ,get_auto_time/1
       ,push_energy_status/1
       ,add_energy_limit/2
       ,fire/1
       ,clear_recover_info/1
       ,notify_recv_timeout/1
       ,pack_send_19600/1
       ,pack_send_19605/1
       ,pack_send_energy_status/1
       ,init_guild_online/1
       ,guild_online_callback/1
       ,stop_guild_online_timer/1
   ]
).

-include("energy.hrl").
-include("role.hrl").
-include("common.hrl").
-include("link.hrl").
-include("assets.hrl").
-include("gain.hrl").
-include("vip.hrl").
-include("guild.hrl").

-define(half_hour_energy, 5).       %% 半个小时自动恢复的体力
-define(auto_energy_time, 1800).    %% 半个小时 30*60 = 1800
-define(GUILD_ONLINETIME, 3600).    %% 军团在线时长

login(Role = #role{energy = Energy = #energy{date = Date}}) ->
    Now = util:unixtime(),
    Role1 = 
    case util:is_today(Date) of
        true -> Role;
        false -> Role#role{energy = Energy#energy{date = Now, buy_times = 0, online_time = 0, has_rcv_id=[]}}
    end,

    Role2 = init(Role1),
    Role3 = init_guild_online(Role2),
    pack_send_19605(Role3),
    pack_send_energy_status(Role3), 
    Tomorrow = util:unixtime({today,Now}) + 86403,
    role_timer:set_timer(energy_day_check, (Tomorrow - Now) * 1000, {?MODULE, day_check, []}, day_check, Role3).        

%% @spec logout(Role) -> NewRole
%% @doc 下线记录玩家在线时间
logout(Role = #role{guild = #role_guild{gid = Gid}}) when Gid =:= 0 ->
    {ok, Role};
logout(Role = #role{energy = Eng}) ->
    OT = get_online_time(Role),
    {ok, Role#role{energy = Eng#energy{online_time = OT}}}. 


%% 日期检测,异步调用,返回格式 {ok, NewRole}
day_check(Role = #role{energy = Eng}) ->
        Now = util:unixtime(),
        Role1 = Role#role{energy = Eng#energy{has_rcv_id = [], date = Now, buy_times = 0, online_time = 0}},
        pack_send_19605(Role1),
        Role2 = init_guild_online(Role1),
        {ok, rebuild_timer(Role2)}.

%% 获取本次登录时间
get_login_time() ->
    case role:get_dict(energy_login) of
        {ok, undefined} -> util:unixtime();
        {ok, Time} -> Time;
        _ -> util:unixtime()
    end.

init(Role) ->
    Role1 = init_recover_energy(Role),
    init_spec_energy(Role1).

rebuild_timer(Role) ->
    init_spec_energy(Role).

set_auto_recover_energy_timer(Role, Time) ->
    role_timer:set_timer(auto_energy_timer, Time * 1000, {?MODULE, auto_add_energy, []}, 1, Role).

clear_recover_info(Role = #role{energy = Eng}) ->
    case role_timer:del_timer(auto_energy_timer, Role) of
        {ok, {_Timeout, _Remain}, Role1} ->
            Role1#role{energy = Eng#energy{recover_time = 0, next_time = 0}};
        false ->
            Role
    end.

auto_add_energy(Role = #role{assets = #assets{energy = E}, link = #link{conn_pid = _ConnPid}, energy = Eng}) ->
    Now = util:unixtime(),
    case E + ?half_hour_energy >= ?max_energy of
        true ->
            role_gain:do([#gain{label=energy, val=?max_energy-E}], Role#role{energy = Eng#energy{recover_time = 0, next_time = 0}});
        false ->
            {ok, NewRole0} = role_gain:do([#gain{label=energy, val=?half_hour_energy}], Role),
            NewRole1 = set_auto_recover_energy_timer(NewRole0, ?auto_energy_time),
            {ok, NewRole1#role{energy = Eng#energy{next_time = ?auto_energy_time, recover_time = Now}}}
    end.

%% 初始化每半小时送的体力
init_recover_energy(Role = #role{assets = Ast = #assets{energy = E}, energy = Eng = #energy{recover_time = Time}}) ->
    case E >= ?max_energy of
        true -> %% 体力已满
            Role#role{energy = Eng#energy{next_time = 0, recover_time = 0}};
        false ->
            Now = util:unixtime(),
            case Time =/= 0 of
                true ->
                    ElapseTime = Now  - Time,
                    CanAddEnergy = (ElapseTime div ?auto_energy_time) * ?half_hour_energy,
                    T = ElapseTime rem ?auto_energy_time,
                    case E + CanAddEnergy >= ?max_energy of
                        true ->
                            Role#role{assets = Ast#assets{energy = ?max_energy}, energy=Eng#energy{next_time = 0, recover_time = 0}};
                        false ->
                            NextTime = get_auto_time(Role),
                            RTime = case CanAddEnergy > 0 of true -> Now - T; false -> Time end,
                            NewRole = set_auto_recover_energy_timer(Role, NextTime),
                            NewRole#role{assets = Ast#assets{energy = E + CanAddEnergy}, energy = Eng#energy{recover_time = RTime, next_time = NextTime}}
                    end;
                false ->
                        NewRole1 = set_auto_recover_energy_timer(Role, ?auto_energy_time),
                        NewRole1#role{energy=Eng#energy{recover_time=Now, next_time = ?auto_energy_time}}
            end
    end.

%% 两个特定时间点的体力
%% init_spec_energy(Role = #role{lev = Lev}) when Lev < 35  -> Role;
init_spec_energy(Role = #role{energy = #energy{has_rcv_id = HasRcvId}}) ->
    Now = util:unixtime(),
    Offset = Now - util:unixtime(today), %% 距离今天凌晨的秒数
    {T1, T2, T3, T4} = time_to_seconds(),
    if
        Offset < T1 -> 
            case lists:member(?online2, HasRcvId) of
                true ->
                    Role;
                false ->
                    Role1 = role_timer:set_timer(energy_recv_timeout, (T2 - Offset) * 1000, {?MODULE, notify_recv_timeout, []}, 1, Role),%%延迟5秒
                    role_timer:set_timer(energy_timer2, (T1-Offset) * 1000, {?MODULE, spec_timer_callback, [?online2]}, 1, Role1)
            end;
        Offset >= T2 andalso Offset < T3 -> 
            case lists:member(?online3, HasRcvId) of
                true ->
                    Role;
                false ->
                    Role1 = role_timer:set_timer(energy_recv_timeout, (T4 - Offset) * 1000, {?MODULE, notify_recv_timeout, []}, 1, Role),
                    role_timer:set_timer(energy_timer3, (T3-Offset) * 1000, {?MODULE, spec_timer_callback, [?online3]}, 1, Role1)
            end;
        true -> Role
    end.

%% 特定时间点回调，通知客户端可以领体力
spec_timer_callback(Role, Id) ->
    {_T1, _T2, T3, T4} = time_to_seconds(),
    Role2 = 
    case Id =:= ?online2 of
        true -> 
            Now = util:unixtime(),
            Offset = Now - util:unixtime(today),
            ?DEBUG("  超时定时器  ~w", [T4 - Offset]),
            Role1 = role_timer:set_timer(energy_recv_timeout1, (T4 - Offset) * 1000, {?MODULE, notify_recv_timeout, []}, 1, Role),
            role_timer:set_timer(energy_timer3, (T3-Offset) * 1000, {?MODULE, spec_timer_callback, [?online3]}, 1, Role1);
        false ->
            Role
    end,
    pack_send_energy_status(Role2),
    {ok, Role2}.

%% 通知客户端可领取体力过期，去掉特效
notify_recv_timeout(Role) ->
    pack_send_energy_status(Role),
    {ok}.

get_online_time(#role{energy = #energy{online_time = OT}}) ->  OT + util:unixtime() - get_login_time().

%% 获取一下时刻恢复体力的时间
get_auto_time(#role{energy = #energy{recover_time = Time}}) ->
    case Time =/= 0 of
        true ->
            ElapseTime = util:unixtime() - Time,
            ?auto_energy_time - (ElapseTime rem ?auto_energy_time);
        false ->
            0
    end.
  
lev_up(Role) -> Role.
%%    {ok, Role1} = add_energy_limit(10, Role),
%%    Role1.

push_energy_status(Role = #role{lev = _Lev, link=#link{conn_pid = ConnPid}, energy = #energy{has_rcv_id = HasRcv}}) ->
    case have_new_energy(Role) of
        [] ->
            sys_conn:pack_send(ConnPid, 19602, {HasRcv, []});
        CanGetList ->
            L = id2detail(CanGetList, []),
            ?DEBUG(" 体力信息   ~w", [L]),
            sys_conn:pack_send(ConnPid, 19602, {HasRcv, L})
    end.

try_reset_auto_timer(Role = #role{assets = #assets{energy = E}, energy = Eng = #energy{next_time = NextTime}}) ->
    case E >= ?max_energy of
        true -> Role;
        false ->
            case NextTime > 0 of
                true ->
                    Role; 
                false ->
                    NewRole = set_auto_recover_energy_timer(Role, ?auto_energy_time),
                    Now = util:unixtime(),
                    NewRole#role{energy=Eng#energy{recover_time=Now, next_time = ?auto_energy_time}}
            end
    end.

time2online_info() ->
    Now = util:unixtime(),
    Offset = Now - util:unixtime(today),
    {T1,T2,T3,T4} = time_to_seconds(),
    if
        Offset >= T1 andalso Offset < T2 ->
            [?online2];
        Offset >= T3 andalso Offset < T4 ->
            [?online3];
        true -> []
    end.

have_new_energy(#role{energy = #energy{has_rcv_id = HasRcv}}) ->
    L1 = time2online_info(),
    L1 -- HasRcv.

%% 去掉使用次数
use_energy_water(UseType, Id, Num, Role = #role{}) ->
    case loss_energy_water(UseType, Id, Num, Role) of
        {ok, Role1} ->
            {ok, Role2} = role_gain:do([#gain{label = energy, val = 25 * Num}], Role1),
            pack_send_19605(Role2),
            notice:alert(succ, Role2, util:fbin(?L(<<"获得了~w体力">>), [25 * Num])),
            {ok, Role2};
        {false, _} ->
            {false, ?L(<<"没有足够的体力药水">>)}
    end.

loss_energy_water(by_base_id, BaseId, Num, Role) ->
    role_gain:do([#loss{label = item, val = [BaseId, 1, Num]}], Role);
loss_energy_water(by_id, Id, Num, Role) ->
    role_gain:do([#loss{label = item_id, val = [{Id, Num}]}], Role).


get_remain_time(?online2) -> calendar:time_to_seconds(?time2) - (util:unixtime()-util:unixtime(today));
get_remain_time(?online3) -> calendar:time_to_seconds(?time4) - (util:unixtime()-util:unixtime(today));
get_remain_time(_Id) -> 0.

get_energy_num(?online2) -> 1;
get_energy_num(?online3) -> 1;
get_energy_num(_Id) -> 0.

id2detail([], L) -> L;
id2detail([Id|T], L) ->
    L1 = [{Id,  get_energy_num(Id), get_remain_time(Id)}| L],
    id2detail(T, L1).

time_to_seconds() ->
    {
        calendar:time_to_seconds(?time1),
        calendar:time_to_seconds(?time2),
        calendar:time_to_seconds(?time3),
        calendar:time_to_seconds(?time4)
    }.

%% 系统加体力,不能超过最大值
add_energy_limit(ToAdd, Role = #role{assets = #assets{energy = E}}) ->
    CanAdd = case ToAdd + E > ?max_energy of true -> ?max_energy - E; false -> ToAdd end,
    role_gain:do([#gain{label=energy, val = CanAdd}], Role).

%% VIP等级变化触发
fire(Role) ->
    pack_send_19605(Role).

pack_send_19600(#role{link = #link{conn_pid = ConnPid}, vip = #vip{type = Vip},energy = #energy{next_time = NextTime, recover_time = Time, buy_times = BuyTimes}}) ->
    SumTime = energy_data:get(Vip),
    case NextTime > 0 of
        true ->
            sys_conn:pack_send(ConnPid, 19600, {NextTime - (util:unixtime()-Time), SumTime - BuyTimes});
        false ->
            sys_conn:pack_send(ConnPid, 19600, {0, SumTime - BuyTimes})
    end.

pack_send_19605(#role{link = #link{conn_pid = ConnPid}, vip = #vip{type = Vip}, energy = #energy{buy_times = BuyTimes}}) ->
    SumTime = energy_data:get(Vip),
    RemainTime = SumTime - BuyTimes,
    Gold = energy_data:get_gold(BuyTimes+1),
    sys_conn:pack_send(ConnPid, 19605, {RemainTime, BuyTimes, Gold}).

%% 客户端体力面板状态
%% 时间没到         -- 0
%% 时间到了可领     -- 1
%% 时间过了已领     -- 2
%% 时间过了没领     -- 3
pack_send_energy_status(#role{link = #link{conn_pid = ConnPid}, energy = #energy{has_rcv_id = HasRcvId}}) ->
    Now = util:unixtime(),
    Offset = Now - util:unixtime(today), %% 距离今天凌晨的秒数
    {T1, T2, T3, T4} = time_to_seconds(),

    Flags=
    if
        Offset < T1 ->
            [0,0];
        Offset >= T1 andalso Offset < T2 ->
            case lists:member(?online2, HasRcvId) of true->[2,0]; false ->[1,0] end;
        Offset >= T2 andalso Offset < T3 ->
            case lists:member(?online2, HasRcvId) of true->[2,0]; false ->[3,0] end;
        Offset >= T3 andalso Offset < T4 ->
            F1 = case lists:member(?online2,HasRcvId) of true->[2]; false->[3] end,
            F2 = case lists:member(?online3,HasRcvId) of true->[2]; false->[1] end,
            F1++F2;
        Offset > T4 ->
            F1 = case lists:member(?online2,HasRcvId) of true->[2]; false->[3] end,
            F2 = case lists:member(?online3,HasRcvId) of true->[2]; false->[3] end,
            F1++F2;
        true ->
            [0,0]
    end,
    [N1, N2] = Flags,
    sys_conn:pack_send(ConnPid, 19602, {N1, N2}).


%% 军团在线一个小时活跃
init_guild_online(Role = #role{guild = #role_guild{gid = Gid}}) when Gid =:= 0 ->
    Role;
init_guild_online(Role = #role{energy = #energy{online_time = OL}}) when OL >= ?GUILD_ONLINETIME ->
    Role;
init_guild_online(Role = #role{energy = #energy{online_time = OL}}) ->
?DEBUG("设置军团在线定时器 ~w 秒", [?GUILD_ONLINETIME - OL]),
    Now = util:unixtime(),
    role:put_dict(energy_login, Now),
    role_timer:set_timer(guild_online, (?GUILD_ONLINETIME - OL)*1000, {?MODULE, guild_online_callback, []}, 1, Role).

guild_online_callback(Role) ->
    ?DEBUG("<<<<<<<<< 军团活跃度触发"),
    role_listener:guild_activity(Role, {}),
    {ok}.

%% 中途退团，要清一下定时器
stop_guild_online_timer(Role) ->
    case role_timer:del_timer(guild_online, Role) of
        {ok, _, Role1} ->
            Role1;
        false ->
            Role
    end.
