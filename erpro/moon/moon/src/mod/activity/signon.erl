%% ******************************
%%  每日签到模块
%% @author wangweibiao
%% ******************************
-module(signon).
-export([
        login/1,
        get_signon_info/1,
        signon/1,
        check_signon/1,
        push_sign_info/1
    ]).

-include("common.hrl").
-include("role.hrl").
-include("vip.hrl").
-include("gain.hrl").
-include("link.hrl").

%%登录检查是否需要刷新淘宝界面剩余未爆炸的物品
login(Role) ->
    notify_if_need(Role),
    role_timer:set_timer(check_signon, util:unixtime({nexttime, 86403}) * 1000, {signon, check_signon, []}, 1, Role).
    % role_timer:set_timer(check_casino, 10* 1000, {casino_refresh_items, check_casino, []}, 1, Role).

check_signon(Role = #role{link = #link{conn_pid = ConnPid}}) ->
  
    sys_conn:pack_send(ConnPid, 13822, {}),        
    Time0 = util:unixtime(today),
    Tomorrow0 = (Time0 + 86400) - util:unixtime(),
    {ok, role_timer:set_timer(check_signon2, Tomorrow0*1000, {signon, check_signon, []}, day_check, Role)}. 

notify_if_need(Role = #role{id = _Id, link = #link{conn_pid = ConnPid}}) ->
    case check_signon_type(Role) of 
        0 -> ok;
        _Other ->
            ?DEBUG("notify_if_need:~s, Other:~s~n~n", [_Id, _Other]), 
            sys_conn:pack_send(ConnPid, 13822, {})
    end.

get_signon_info(Id = {Rid, SrvId}) ->
    %% 要清空上个月的数据
    Sql = "select info, month, lasttime from sys_signon where rid = ~s and srv_id = ~s ",
    {SignonInfo, LastTime, OldMonth} = 
        case db:get_row(Sql, [Rid, SrvId]) of
            {ok, [Info1, M, LastTime1]} ->
                {ok, Info2} = util:bitstring_to_term(Info1),
                {Info2, LastTime1, M};
            {error, _Msg} ->
                % ?ERR(_Msg),
                {[], 0, 12}
        end,

    {{_, Month, _}, _} = calendar:local_time(), 
    case SignonInfo of 
        [] -> {[], 0};
        _ -> 
            case Month > OldMonth of  %% 跨过一个月
                false ->
                    {SignonInfo, LastTime};
                true -> 
                    update_data(Id, Month, [], 0),
                    {[], 0}
            end
    end;
    % {[{1, 1, 0}, {2, 1, 0}... ]};


get_signon_info(_) ->
    ?ERR("params error"),
    {[], 0}.

signon(Role = #role{id = Id, vip = #vip{type = Lev}}) ->
    {Info, LastTime} = get_signon_info(Id),
    Info1 = lists:keysort(1, Info),

    {Nth, Double, _} = %%{最后领取的序号，是否领取}
        case Info1 of 
            [] -> {0, 0, 0}; 
            _ ->lists:last(Info1) %% 最后一次领的序号
        end,

    {{_, Month, Day}, _} = calendar:local_time(), %% Day表示这个月的第几天

    Now = util:unixtime(),
    if
        Day < Nth -> %% 正常情况不可能发生
            ?ERR("数据有问题"),
            {{0}, Role}; %% 已经领过 
        true ->
            case util:is_same_day2(LastTime, Now) of 
                true -> %% 上次是今天
                    case Double of 
                        ?true ->
                            {{0}, Role}; %% 已经领取
                        ?false ->
                            case check_vip(Lev, Nth, Month) of 
                                true -> %%可领取更高vip的东西
                                    signon_today(single, Month, Nth, Lev, Info1, Role);
                                false ->
                                    {{0}, Role} %% 已经领取
                            end
                    end;
                false -> %%上次不是今天，就领今天
                    signon_today(can_double, Month, Nth + 1, Lev, Info1, Role)
            end
    end;

signon(_) ->
    ?ERR("params error"),
    {}.


push_sign_info(Role) ->
    notify_if_need(Role),
    ok.

signon_today(can_double, Month, Nth, Lev, OldInfo, Role) ->
    case signon_data:get(Month, Nth) of 
        {Double, Vip, Gain, DoubleGain} ->
            {GDouble, Gain1} = 
                case Lev >= Vip of 
                    true ->
                        case Double of 
                            ?true -> {?true, DoubleGain};
                            ?false -> {?false, Gain}
                        end;
                    false -> {?false, Gain}
                end,
            NewRole =     
                case role_gain:do(Gain1, Role) of
                    {false, _} -> 
                        notice:alert(error, Role, ?MSGID(<<"背包已满, 物品发送至奖励大厅！">>)),
                        %%处理物品
                        deal_item(Role, Gain1),
                        Role;
                    {ok, NewRole1} ->
                        NewRole1
                end,
            update_last_signon(Role, Month, Nth, GDouble, Lev, OldInfo),
            {{1}, NewRole};
        _ ->
            ?ERR(" 找不到数据！！"),
            {{1}, Role}
    end;

%% 用于已经领取过且vip变化的情况
signon_today(single, Month, Nth, Lev, OldInfo, Role) ->
    case signon_data:get(Month, Nth) of 
        {_Double, _Vip, Gain, _DoubleGain} ->
            NewRole = 
                case role_gain:do(Gain, Role) of
                    {false, _} -> 
                        notice:alert(error, Role, ?MSGID(<<"背包已满, 物品发送至奖励大厅！">>)),
                        %%处理物品
                        deal_item(Role, Gain),
                        Role;
                    {ok, NewRole1} ->
                        NewRole1
                end,
            update_last_signon(Role, Month, Nth, 1, Lev, OldInfo),
            {{1}, NewRole};
        _ ->
            ?ERR(" 找不到数据！！"),
            {{1}, Role}
    end;

signon_today(_, _, _, _, _, Role) ->
    ?ERR("params error"),
    {{5}, Role}.


update_last_signon(#role{id = Id}, Month, Nth, Double, Vip, OldInfo) ->
    case lists:keyfind(Nth, 1, OldInfo) of
        false ->
            Info1 = [{Nth, Double, Vip}] ++ OldInfo,
            update_data(Id, Month, Info1, util:unixtime());
        _ -> 
            Info1 = lists:keydelete(Nth, 1, OldInfo),
            Info2 = [{Nth, Double, Vip}] ++ Info1,
            update_data(Id, Month, Info2, util:unixtime())
    end.

update_data({Rid, SrvId}, Month, Info, LastTime) ->
    Sql = "delete from sys_signon where rid = ~s and srv_id = ~s",
    db:execute(Sql, [Rid, SrvId]),
    Sql1 = "insert into sys_signon (rid, srv_id, month, lasttime, info) values (~s, ~s, ~s, ~s, ~s)",
    db:execute(Sql1, [Rid, SrvId, Month, LastTime, util:term_to_string(Info)]),
    ok.

deal_item(#role{}, []) -> ok;
deal_item(#role{id = Id}, Gain) ->
    Items = select_item(Gain, []),
    case Items of 
        [] -> ok;
        _ ->
            award:send(Id, 302001, Items),
            ok
    end.

select_item([], Ret) -> Ret;
select_item([Gain = #gain{label = item}|T], Ret) ->
    select_item(T, [Gain|Ret]).


check_vip(VipLev, Day, Month) ->
    case signon_data:get(Month, Day) of 
        {Double, Vip, _Gain, _DoubleGain} ->
            case Double of 
                1 ->
                    case VipLev >= Vip of 
                        true -> true;
                        false -> false
                    end;
                0 -> false
            end;
        _ -> false
    end.


%% 0表示已签到 1表示可以再签到一次(vip变化) 2还没签到
check_signon_type(Role = #role{id = Id, vip = #vip{type = Lev}}) ->
    {Info, LastTime} = get_signon_info(Id),
    Info1 = lists:keysort(1, Info),

    {Nth, Double, _} =
        case Info1 of 
            [] -> {0, 0, 0}; 
            _ ->lists:last(Info1) %% 最后一次领的时间Nth
        end,

    {{_, Month, Day}, _} = calendar:local_time(), %% Day表示这个月的第几天

    Now = util:unixtime(),
    if
        Day < Nth -> %% 正常情况不可能发生
             ?ERR("数据有问题"),
            {{0}, Role}; %% 已经领过 
        true ->
            case util:is_same_day2(LastTime, Now) of 
                true -> %% 上次是今天
                    case Double of 
                        ?true ->
                            0;
                        ?false ->
                            case check_vip(Lev, Nth, Month) of 
                                true -> %%可领取更高vip的东西
                                    1;
                                false ->
                                    0
                            end
                    end;
                false -> %%上次不是今天，就领今天
                    2
            end
    end.

