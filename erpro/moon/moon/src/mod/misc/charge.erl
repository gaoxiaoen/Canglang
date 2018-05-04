%----------------------------------------------------
%% 充值处理
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(charge).
-export([
        notice/3
        ,pay/2
        ,login/1
        ,role_lev/2
        ,online_pay/3
        ,use_month_card/1
        ,month_card_check/1
        ,month_card_timer_callback/1
        ,push_month_card_info/1
    ]
).
-include("common.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("link.hrl").
-include("month_card.hrl").
-include("gain.hrl").


%% TODO： 离线冲值，要考虑重复冲值月卡

%% 充值方式
%% 0 - 直接充元宝
%% 1 - 月卡方式

%% @spec notice(Rid, SrvId, Sn) -> ok
%% Rid = integer()
%% SrvId = string()
%% Sn = string()
%% @doc 充值通知
notice(Rid, SrvId, Sn)->
    BSrvId = list_to_binary(SrvId),
    BSn = list_to_binary(Sn),
    case role_api:lookup(by_id, {Rid, BSrvId}, #role.pid) of
        {ok, _, RolePid} ->
            role:apply(async, RolePid, {fun pay/2, [BSn]});
        _Msg -> 
            ignore
    end,
    ok.

%% @spec pay(Sn) -> ok
%% Sn = string()
%% @doc 充值处理
pay(Role = #role{id = {Rid, SrvId}}, Sn) ->
    case db:get_row(<<"select status, gold, rid, srv_id from sys_charge where sn = ~s and status = 0">>, [Sn]) of
        {ok, [0, Gold, Rid, SrvId]} -> %% 订单未处理，下面开始处理
            case db:execute(<<"update sys_charge set status = 1, time_deal = ~s where sn = ~s and status = 0">>, [util:unixtime(), Sn]) of
                {ok, 1} -> 
                    Role1 = online_pay(Role, Gold, <<"充值">>),
                    {ok, Role1};
                Err ->
                    ?ELOG("角色[~w, ~s]处理订单[~s]时发生异常: ~w", [Rid, SrvId, Sn, Err]),
                    {ok}
            end;
        {ok, [1, _Gold, Rid, SrvId]} -> %% 订单未处理，下面开始处理
            ?ELOG("角色[~w, ~s]无法处理订单,该订单已经处理[~s]", [Rid, SrvId, Sn]),
            {ok};
        {ok, R} -> %% 订单无法处理，可能是重复处理
            ?ELOG("角色[~w, ~s]无法处理订单[~s]: ~w", [Rid, SrvId, Sn, R]),
            {ok};
        {error, undefined} ->
            ?ELOG("对不存在的订单[~s]发起处理请求", [Sn]),
            {ok};
        Err ->
            ?ELOG("处理订单[~s]时发生异常:~w", [Sn, Err]),
            {ok}
    end.

%% 角色登录，查询处理订单
login(Role = #role{id = {Rid, SrvId}}) ->
    Role1 = month_card_check(Role),

    Role2 =
    case db:get_all(<<"select sn, status, gold, rid, srv_id from sys_charge where rid = ~s and srv_id = ~s and status = 0">>, [Rid, SrvId]) of
        {ok, Data} ->
            deal_charge(Role1, Data);
        {error, Err} ->
            ?ELOG("角色[~w, ~s]登陆处理订单时发生异常:~w", [Rid, SrvId, Err]),
            Role1
    end,
    month_card_fix(Role2).

month_card_fix(Role = #role{month_card = #month_card{charge_time = ChargeTime}}) when ChargeTime =/= 0 -> Role; %% 已有月卡并已激活
month_card_fix(Role = #role{id = {Rid, SrvId}, month_card = #month_card{}}) ->
     case db:get_all(<<"select gold from sys_charge where rid = ~s and srv_id = ~s and status = 1 and gold = 300">>, [Rid, SrvId]) of
        {ok, Data} ->
            case length(Data) >= 1 of
                true ->
                    month_card_init(Role);
                false ->
                    Role
            end;
        {error, _Err} ->
            Role
    end.   

%% 处理订单
deal_charge(Role, []) -> Role;
deal_charge(Role = #role{name = Name, assets = Assets = #assets{gold = G, charge = Charge}}, [[Sn, 0, Gold, Rid, SrvId] | T]) ->
    case db:execute(<<"update sys_charge set status = 1, time_deal = ~s where sn = ~s and status = 0">>, [util:unixtime(), Sn]) of
        {ok, 1} -> 

            Role1 =
            case Gold of 
                ?MONTH_CARD_GOLD ->
                    month_card_init(Role);
                _ -> 
                    Role
            end,

            NewRole = Role1#role{assets = Assets#assets{gold = G + Gold, charge = Charge + Gold}},
            campaign:on_charge(NewRole, Gold),
            log:log(log_gold, {<<"充值">>, util:fbin(<<"离线充值:~w, 共:~w">>, [Gold, Charge + Gold]), Role, NewRole}),
            charge_mail:send_mail({{Rid, SrvId, Name}, Charge + Gold, Gold}),
            NewRole3 = campaign_listener:handle(pay, NewRole, Gold), %% 活动事件监听
            NewRole4 = role_listener:special_event(NewRole3, {1055, Gold}),
            NewRole5 = campaign_special:pay(NewRole4), %% 登陆活动事件监听
            NewRole7 = campaign_card:listen(NewRole5, Gold),
            NewRole8 = campaign_model_worker:listen(NewRole7, charge, Gold),
            NewRole9 = vip:listener(Gold, NewRole8),
            notice:charge(NewRole9, Gold),
            deal_charge(NewRole9, T);
        Err ->
            ?ELOG("角色[~w, ~s]登陆处理订单[~s]时发生异常: ~w", [Rid, SrvId, Sn, Err]),
            deal_charge(Role, T)
    end;
deal_charge(Role, [[_Status, _Status, _Gold, _Rid, _SrvId] | T]) ->
    deal_charge(Role, T).

%% 获取角色等级
role_lev(Rid, SrvId)->
    BSrvId = list_to_binary(SrvId),
    case role_api:lookup(by_id, {Rid, BSrvId}, #role.lev) of
        {ok, _, Lev} ->
            Lev;
        _Msg -> 
            case db:get_row(<<"select lev from role where id = ~s and srv_id = ~s">>, [Rid, BSrvId]) of
                {ok, [Lev]} -> Lev;
                _Other -> 
                    ?ELOG("获取角色信息出错:~w", [_Other]),
                    1
            end
    end.

%% 在线充值 充值卡也使用该方法
online_pay(Role = #role{}, ?MONTH_CARD_GOLD, Type) ->
%    Role1 = Role#role{month_card = #month_card{charge_time = util:unixtime(), charge_0_time = util:unixtime(today)}},
%    Role2 = month_card_check(Role1),
    Role2 = month_card_init(Role),
    #role{id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}, name = Name, assets = Assets = #assets{gold = G, charge = Charge}} = Role2,
    Gold = ?MONTH_CARD_GOLD,
    Role3 = Role2#role{assets = Assets#assets{gold = G + Gold, charge = Charge + Gold}},
    Role4 = role_api:push_assets(Role2, Role3),
    campaign:on_charge(Role4, Gold),
    charge_mail:send_mail({{Rid, SrvId, Name}, Charge + Gold, Gold}),
    log:log(log_gold, {Type, util:fbin(<<"充值:~w, 共:~w">>, [Gold, Charge]), Role, Role4}),
    Msg = util:fbin(?L(<<"充值成功\n获得 ~w晶钻">>), [Gold]),
    notice:alert(succ, ConnPid, Msg),
    notice:inform(util:fbin(?L(<<"充值成功\n获得 ~w晶钻">>), [Gold])),
    Role5 = campaign_listener:handle(pay, Role4, Gold), %% 活动事件监听
    Role6 = role_listener:special_event(Role5, {1055, Gold}),
    Role7 = campaign_special:pay(Role6),
    Role8 = campaign_card:listen(Role7, Gold),
    Role9 = campaign_model_worker:listen(Role8, charge, Gold),
    Role10 = vip:listener(Gold, Role9),
    notice:charge(Role10, Gold),
    Role10;

online_pay(Role = #role{id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}, name = Name, assets = Assets = #assets{gold = G, charge = Charge}}, Gold, Type) ->
    NewRole0 = Role#role{assets = Assets#assets{gold = G + Gold, charge = Charge + Gold}},
    NewRole1 = role_api:push_assets(Role, NewRole0),
    campaign:on_charge(NewRole1, Gold),
    charge_mail:send_mail({{Rid, SrvId, Name}, Charge + Gold, Gold}),
    log:log(log_gold, {Type, util:fbin(<<"充值:~w, 共:~w">>, [Gold, Charge]), Role, NewRole1}),
    Msg = util:fbin(?L(<<"充值成功\n获得 ~w晶钻">>), [Gold]),
    notice:alert(succ, ConnPid, Msg),
    notice:inform(util:fbin(?L(<<"充值成功\n获得 ~w晶钻">>), [Gold])),
    NewRole3 = campaign_listener:handle(pay, NewRole1, Gold), %% 活动事件监听
    NewRole4 = role_listener:special_event(NewRole3, {1055, Gold}),
    NewRole5 = campaign_special:pay(NewRole4),
    NewRole7 = campaign_card:listen(NewRole5, Gold),
    NewRole8 = campaign_model_worker:listen(NewRole7, charge, Gold),
    NewRole9 = vip:listener(Gold, NewRole8),
    notice:charge(NewRole9, Gold),
    NewRole9.
 
%% 使用月卡
use_month_card(Role) ->
    Role2 = month_card_init(Role),
    #role{assets = Assets = #assets{gold = G, charge = Charge}} = Role2,
    Gold = ?MONTH_CARD_GOLD,
    Role3 = Role2#role{assets = Assets#assets{gold = G + Gold, charge = Charge + Gold}},
    log:log(log_gold, {<<"使用月卡">>, <<"月卡">>, Role, Role3}),
    role_api:push_assets(Role2, Role3).
    

month_card_init(Role) ->
    Role1 = Role#role{month_card = #month_card{charge_time = util:unixtime(), charge_0_time = util:unixtime(today)}},
    month_card_check(Role1).

%% 月卡相关业务
%% 处理冲值单，初始化#mont_card为charge_time = 处理时间，charge_0_time = 当天凌晨时间
%% 检查月卡信息
month_card_check(Role = #role{month_card = #month_card{charge_time = 0}}) ->  %% 没有月卡充值
    Role;
month_card_check(Role) ->
    Role1 = month_card_business(Role),
    push_month_card_info(Role1),
    set_month_card_timer(Role1).

%% 内部函数，处理月卡相关业务
month_card_business(Role = #role{id = Rid, month_card = Mon = #month_card{last_gold_day = Day}}) ->
    EplaseDay = month_get_day(Role),
    case EplaseDay of
        N when N > ?MONTH_DAY ->   %% 月卡过期
            Role#role{month_card = #month_card{}};
        _ ->
            GoldDay = EplaseDay,
            case GoldDay =:= Day of
                true -> %% 当天已发
                    Role;
                false ->
                    G = [#gain{label = gold, val = ?MONTH_DAY_GOLD}],
                    award:send(Rid, 304000, G),
                    case GoldDay =:= ?MONTH_DAY of
                        true -> %% 最后一天领取
                            Role#role{month_card = Mon#month_card{}};
                        false ->
                            Role#role{month_card = Mon#month_card{last_gold_day = GoldDay}}
                    end
            end
    end.

%% 午夜回调
month_card_timer_callback(Role) ->
    Role1 = month_card_business(Role),
    push_month_card_info(Role1),
    #role{month_card = #month_card{last_gold_day = Day}} = Role1,
    ?DEBUG("月卡定时器回调  DAY ~w", [Day]),
    case Day =:= ?MONTH_DAY of
        true ->
            {ok, _, Role2} = role_timer:del_timer(month_card_timer, Role1),
            {ok, Role2#role{month_card = #month_card{}}};
        false ->    %% 因为设了day_check, 不用重设定时器
            {ok, Role1}
    end.

set_month_card_timer(Role = #role{month_card = #month_card{charge_time = 0}}) -> Role;
set_month_card_timer(Role) ->
    Now = util:unixtime(),
    Tomorrow = util:unixtime({today,Now}) + 86402,
    role_timer:set_timer(month_card_timer, (Tomorrow - Now) * 1000, {?MODULE, month_card_timer_callback, []}, day_check, Role).

%% 获取当前是月卡第几天  注意：充值当天为第一天
month_get_day(#role{month_card = #month_card{charge_0_time = Charge0Time}}) ->
    Now = util:unixtime(),
    Seconds = Now - Charge0Time,
    EplaseDay = Seconds div 86400 + case Seconds rem 86400 of 0 -> 0; _ -> 1 end,
    ?DEBUG("EplaseDay : ~w", [EplaseDay]),
    EplaseDay.

%% 推送月卡剩余天数给客户端
push_month_card_info(#role{link = #link{conn_pid = ConnPid}, month_card = #month_card{charge_time = 0}}) ->
    sys_conn:pack_send(ConnPid, 19900, {0});
push_month_card_info(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    Day = month_get_day(Role),
    Day1 = ?MONTH_DAY - Day,
    ?DEBUG("剩余天数 : ~w", [Day1]),
    sys_conn:pack_send(ConnPid, 19900, {Day1}).
