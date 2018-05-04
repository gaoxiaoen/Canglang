%% **************************
%% 抽奖系统
%% @author wpf(wprehard@qq.com)
%% **************************
-module(lottery).
-behaviour(gen_server).
-export([
        start_link/0 
        ,login/1
        ,get_pool/1
        ,lucky/1
        ,to_award_gain/3
        ,send_award_mail/1
        ,cast/3
        ,day_check/1
        %% --------------
        ,gm_lucky/2
        ,gm_lucker/1
        ,gm_get_state/0
        ,gm_get_state1/0
        ,adm_restart/0
        ,adm_reload/0
        ,adm_stop/0
        ,adm_stop1/0
        ,adm_set_state/1
        ,adm_temp_test/1
        ,adm_merge/2
    ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("lottery.hrl").
%%

%% ---------------------------------------
%% @doc GM命令
%% ---------------------------------------
gm_lucky(0, Role) -> {ok, Role};
gm_lucky(N, Role) ->
    case lucky(pay, util:unixtime(), Role) of
        {true, Type, LI = #lottery_item{base_id = BaseId, num = Num}, _, Role0} ->
            GL = lottery:to_award_gain(Type, BaseId, Num),
            lottery:cast(Type, Role, LI),
            case BaseId =:= ?FIRST_PRIZE_ID of
                true ->
                    notice:effect(5, <<>>); %% 特效广播
                false ->
                    ignore
            end,
            case role_gain:do(GL, Role0) of
                {false, _} ->
                    gm_lucky(N-1, Role0);
                {ok, NewRole} ->
                    log:log(log_lottery, {Type, BaseId, <<"">>, Num, Role}),
                    gm_lucky(N-1, NewRole)
            end;
        {false, _Type, #lottery_item{base_id = _BaseId, num = _Num}, _, Role0} ->
            ?DEBUG("看到我说明异常了，现在的数据不会产生 [抽中又限制不能中] 的情况[TYPE:~w, BASEID:~w, NUM:~w]", [_Type, _BaseId, _Num]),
            gm_lucky(N-1, Role0);
        {false, Msg} -> {false, Msg}
    end.
gm_get_state() ->
    gen_server:call(?MODULE, get_state).
gm_get_state1() ->
    {ok, #lottery_state{bonus = Bonus
        ,interval_free = IntervalFree
        ,interval_pay = IntervalPay
        ,rands = Rands
        ,last_first = LastF
        ,last_time = LastT
    }} = gen_server:call(?MODULE, get_state),
    [Bonus, LastF, LastT, IntervalFree, IntervalPay, Rands].

%% ---------------------------------------
%% 外部函数
%% ---------------------------------------

%% @spec login(Role) -> NewRole;
%% @doc 登陆检测重置玩家的免费次数
login(Role = #role{lottery = Lot = #lottery{last_time = LastTime}}) ->
    Today = util:unixtime(today),
    Tomorrow = Today + 86410,
    Now = util:unixtime(),
    NewRole = case LastTime > Today of
        true -> Role;
        false -> Role#role{lottery = Lot#lottery{free = ?LUCKY_FREE}}
    end,
    role_timer:set_timer(lottery, (Tomorrow - Now) * 1000, {lottery, day_check, []}, day_check, NewRole);
login(Role) ->
    Tomorrow = util:unixtime(today) + 86410,
    Now = util:unixtime(),
    NewRole = Role#role{lottery = #lottery{
            free = ?LUCKY_FREE
            ,free_info = check_reset_limit(free, [])
            ,pay_info = check_reset_limit(pay, [])
        }},
    role_timer:set_timer(lottery, (Tomorrow - Now) * 1000, {lottery, day_check, []}, day_check, NewRole).

%% 日期检测,异步调用,返回格式 {ok, NewRole}
day_check(Role = #role{lottery = Lottery = #lottery{last_time = LastTime}}) ->
    NewRole = case LastTime > util:unixtime(today) of
        true -> Role;
        false -> Role#role{lottery = Lottery#lottery{free = ?LUCKY_FREE}}
    end,
    {ok, NewRole}.

%% @spec get_pool() -> ok
%% @doc 获取奖池历史记录；客户端打开界面时请求，或者定时
get_pool(#role{link = #link{conn_pid = ConnPid}, lottery = #lottery{free = Free}}) ->
    gen_server:cast(?MODULE, {get_pool, ConnPid, Free}).

%% @spec lucky(Role) -> {true, Type, LI, State, NewRole} | {false, Type, LI, State, Reason}
%% Type = pay | free
%% @doc 抽奖
lucky(Role = #role{lottery = #lottery{free = Free, last_time = LastTime}})
when Free =< 0 ->
    Now = util:unixtime(),
    case LastTime + ?LUCKY_CD >= Now of
        true -> {false, ?L(<<"别心急，头奖会有的">>)};
        false ->
            LossList = [#loss{label = coin, val = ?LUCKY_LOSS}],
            case role_gain:do(LossList, Role) of
                {false, #loss{label = coin, err_code = ErrCode}} ->
                    {false, {ErrCode, ?L(<<"金币不足">>)}};
                {ok, NewRole} ->
                    lucky(pay, Now, NewRole)
            end
    end;
lucky(Role = #role{lottery = Lot = #lottery{free = Free}}) ->
    Now = util:unixtime(),
    lucky(free, Now, Role#role{lottery = Lot#lottery{free = Free - 1}});
lucky(_) ->
    {false, ?L(<<"抽奖异常">>)}.

lucky(Type, Now, Role = #role{id = RoleId, name = Name, lottery = Lottery}) ->
    case gen_server:call(?MODULE, {lucky, RoleId, Name, Type, Now, Lottery#lottery{last_time = Now}}) of
        {true, LI, NewLottery, LotteryState} ->
            {true, Type, LI, LotteryState, Role#role{lottery = NewLottery}};
        {false, LI, NewLottery, LotteryState} ->
            ?DEBUG("抽中后不符合限制条件，不可出"),
            {false, Type, LI, LotteryState, Role#role{lottery = NewLottery}};
        _E ->
            ?ERR("抽奖返回奖品错误:~w", [_E]),
            {false, <<"">>}
    end.

%% @spec to_award_gain(AwardId, Num) -> [#gain{}]
%% 转换奖励
to_award_gain(_Type, ?FIRST_PRIZE_ID, Num) -> %% 头奖啊
    [#gain{label = coin, val = Num}];
to_award_gain(_Type, ?SECOND_PRIZE_ID, Num) -> %% 二等奖
    [#gain{label = coin, val = Num}];
to_award_gain(_Type, ?THIRD_PRIZE_ID, Num) -> %% 三等奖
    [#gain{label = coin, val = Num}];
to_award_gain(_Type, ?LAST_PRIZE_ID, Num) -> %% 安慰奖
    [#gain{label = coin_bind, val = Num}];
to_award_gain(_Type, BaseId, Num) -> %% 绑定物品
    [#gain{label = item, val = [BaseId, 1, Num]}].

%% @spec send_award_mail(Role) -> ok | {false, Reason}
%% @doc 奖品邮件发送
send_award_mail(Role = #role{lottery = #lottery{last_award = AwardList}}) ->
    ItemList = base_to_item(AwardList),
    Info = {?L(<<"幸运抽奖">>), ?L(<<"由于您的背包空位不足，奖品发至您的邮箱，请点击附件图标领取。">>), [], ItemList},
    mail:send_system(Role, Info).

%% 奖品生成物品#item{}数据
base_to_item(List) ->
    base_to_item(List, []).
base_to_item([], Items) -> Items;
base_to_item([{_Type, #lottery_item{base_id = BaseId, num = Num}} | T], Items) ->
    case item:make(BaseId, 1, Num) of
        {ok, ItemList} ->
            base_to_item(T, (ItemList ++ Items));
        false ->
            ?ELOG("角色奖励物品生成邮件出错：~w", [BaseId, Num]),
            base_to_item(T, Items)
    end.

%% @spec adm_reload() -> ok | false
%% @doc 管理重新导入并初始化抽奖信息
adm_reload() ->
    gen_server:call(?MODULE, adm_reload).

%% @spec adm_restart() -> ok | false
%% @doc 管理重新导入并初始化抽奖信息
adm_restart() ->
    supervisor:terminate_child(sup_master, lottery),
    supervisor:restart_child(sup_master, lottery).

%% @spec adm_set_state() -> ok | false
%% @doc 设置奖池信息
adm_set_state(State = #lottery_state{}) ->
    gen_server:call(?MODULE, {adm_set_state, State});
adm_set_state(_State) ->
    ?ERR("数据设置异常，设置失败").
%% 返回新的数据 -- 12/03/02
adm_temp_test({X1, X2, X3, X4, X5, X6, X7, X8, X9, X10}) ->
    {X1, X2, X3, X4, X5, X6, util:unixtime(), X7, X8, X9, X10};
adm_temp_test(D) -> D.

%% @spec adm_stop() -> ok | false
%% @doc 关闭
adm_stop() ->
    gen_server:call(?MODULE, adm_stop).

%% @spec gm_luck(id) -> ok | false
%% @doc 指定获奖者
gm_lucker(Role = #role{id = Id}) when is_record(Role, role) ->
    gen_server:cast(?MODULE, {lottery_lucker, Id});
gm_lucker(Name) when is_bitstring(Name) ->
    case role_api:lookup(by_name, Name, #role.id) of
        {ok, _, Id} ->
            gen_server:cast(?MODULE, {lottery_lucker, Id});
        _ ->
            false
    end;
gm_lucker(Id) ->
    case role_api:lookup(by_id, Id, #role.id) of
        {ok, _, Id} ->
            gen_server:cast(?MODULE, {lottery_lucker, Id});
        _ ->
            false
    end.

%% @spec adm_stop1() -> ok | false
%% @doc 测试关闭
adm_stop1() ->
    Pid = gen_server:call(?MODULE, pid),
    erlang:exit(Pid, kill).

%% @spec adm_merge(State1, State2) -> NewState
%% @doc 合服处理
adm_merge(#lottery_state{bonus = Bonus1, rands = Rands1, float_end = FloatEnd1, info = Info1}, #lottery_state{bonus = Bonus2, float_end = FloatEnd2}) ->
    End = erlang:min(FloatEnd1, FloatEnd2),
    #lottery_state{
        bonus = Bonus1 + Bonus2
        ,float_end = End
        ,rands = Rands1
        ,info = Info1
    }.

%% @spec start_link() -> pid()
%% @doc 创建抽奖系统进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ------------------------------
%% 内部函数
%% ------------------------------

%% 广播消息
cast(_, Role, #lottery_item{base_id = ?FIRST_PRIZE_ID, num = N}) ->
    RoleMsg = notice:role_to_msg(Role),
    notice:send(53, util:fbin(?L(<<"神了...~s在{open, 8, 飞仙嘉年华, #00ff24}中转动幸运转盘，竟然中得至尊大奖: ~w铜币！">>), [RoleMsg, N]));
cast(_, Role, #lottery_item{base_id = ?SECOND_PRIZE_ID, num = N}) ->
    RoleMsg = notice:role_to_msg(Role),
    notice:send(52, util:fbin(?L(<<"神了...~s在{open, 8, 飞仙嘉年华, #00ff24}中转动幸运转盘，获得二等奖: ~w铜币！">>), [RoleMsg, N]));
cast(_, Role, #lottery_item{base_id = ?THIRD_PRIZE_ID, num = N}) ->
    RoleMsg = notice:role_to_msg(Role),
    notice:send(52, util:fbin(?L(<<"神了...~s在{open, 8, 飞仙嘉年华, #00ff24}中转动幸运转盘，获得三等奖: ~w铜币！">>), [RoleMsg, N]));
cast(pay, Role, #lottery_item{base_id = BaseId, num = N, is_notice = ?true}) ->
    RoleMsg = notice:role_to_msg(Role),
    case item:make(BaseId, 1, N) of
        {ok, Items} ->
            ItemMsg = notice:item_to_msg(Items),
            notice:send(52, util:fbin(?L(<<"神了...~s在{open, 8, 飞仙嘉年华, #00ff24}中转动幸运转盘，获得珍稀物品: ~s！">>), [RoleMsg, ItemMsg]));
        _ ->
            ignore
    end;
cast(free, Role, #lottery_item{base_id = BaseId, num = N, is_notice = ?true}) ->
    RoleMsg = notice:role_to_msg(Role),
    case item:make(BaseId, 1, N) of
        {ok, Items} ->
            ItemMsg = notice:item_to_msg(Items),
            notice:send(52, util:fbin(?L(<<"神了...~s在{open, 8, 飞仙嘉年华, #00ff24}中免费转动幸运转盘，获得珍稀物品: ~s！">>), [RoleMsg, ItemMsg]));
        _ ->
            ignore
    end;
cast(_, _, _) ->
    ignore.

%% ************
%% 随机选择奖品
rand_award(Interval, L) ->
    RandVal = util:rand(1, Interval),
    do_rand_award(RandVal, L).
do_rand_award(_RandVal, [H]) ->
    %% ?DEBUG("落到最后RandVal:~w,   H:~w", [_RandVal, H]),
    H;
do_rand_award(RandVal, [LI = #lottery_item{base_id = _Id, rand = Rand} | _T])
when RandVal =< Rand ->
    %% ?DEBUG("RandVal:~w, ID:~w, Rand:~w", [RandVal, _Id, Rand]),
    LI;
do_rand_award(RandVal, [#lottery_item{base_id = _Id, rand = Rand} | T]) ->
    %% ?DEBUG("RandVal:~w, ID:~w, Rand:~w", [RandVal, _Id, Rand]),
    do_rand_award(RandVal - Rand, T);
%% 其他错误情况默认给安慰奖
do_rand_award(_RandVal, _L) ->
    ?ERR("嘉年华随机奖品失败RandVal:~w, L:~w", [_RandVal, _L]),
    {ok, LI} = lottery_data:get(pay, ?LAST_PRIZE_ID),
    LI.

%% 获取最新奖品概率列表
award_list(Type, Rands) ->
    L = lottery_data:award_list(Type),
    Fun = fun(Id) ->
            {ok, X} = lottery_data:get(Type, Id),
            X
    end,
    LI = [Fun(Id) || Id <- L],
    check_float_rand(LI, Rands).
%% 抽奖前检查浮动概率表
check_float_rand(AwardList, []) -> AwardList;
check_float_rand(AwardList, [{Id, Rand, _} | T]) ->
    NewList = case lists:keyfind(Id, #lottery_info.base_id, AwardList) of
        LI = #lottery_item{rand = _OldRand} ->
            %% 替换为浮动概率
            lists:keyreplace(Id, #lottery_item.base_id, AwardList, LI#lottery_item{rand = Rand});
        _ ->
            AwardList
    end,
    check_float_rand(NewList, T).

%% 根据当前的奖品列表计算概率总区间
calc_interval(AwardList) ->
    calc_interval(AwardList, 0).
calc_interval([], Interval) -> Interval;
calc_interval([#lottery_item{rand = Rand} | T], Interval) ->
    calc_interval(T, Rand + Interval);
calc_interval([_ | T], Interval) ->
    calc_interval(T, Interval).

%% TODO: 需考量每次抽奖前检查是否有压力
%% 抽奖前检查并初始化角色的抽奖信息，如果奖品列表有变更，则更新抽奖因子信息记录
check_and_reset(pay, Lottery = #lottery{pay_info = InfoList}) ->
    PayInfo = check_reset_limit(pay, InfoList),
    Lottery#lottery{pay_info = PayInfo};
check_and_reset(free, Lottery = #lottery{free_info = InfoList}) ->
    FreeInfo = check_reset_limit(free, InfoList),
    Lottery#lottery{free_info = FreeInfo};
check_and_reset(global, LotteryState = #lottery_state{info = InfoList}) ->
    GlobalInfo = check_reset_limit(global, InfoList),
    LotteryState#lottery_state{info = GlobalInfo};
check_and_reset(_, Lottery) ->
    Lottery.
%% ID列表转换为相对应类型的物品列表
id_to_award(Type, IdList) ->
    id_to_award(Type, IdList, []).
id_to_award(_Type, [], L) -> L;
id_to_award(global, [Id | T], L) ->
    case lottery_data:get(pay, Id) of
        {ok, LI = #lottery_item{limit = ?LIMIT_GLOBAL}} ->
            id_to_award(pay, T, [LI | L]);
        _ ->
            id_to_award(pay, T, L)
    end;
id_to_award(Type, [Id | T], L) ->
    case lottery_data:get(Type, Id) of
        {ok, LI = #lottery_item{limit = ?LIMIT_ROLE}} ->
            id_to_award(Type, T, [LI | L]);
        _ ->
            id_to_award(Type, T, L)
    end.
%% 重置全服的奖品抽奖限制因子信息列表
check_reset_limit(global, GlobalInfo) ->
    L0 = lottery_data:award_list(pay),
    L1 = id_to_award(global, L0),
    do_check_reset_limit(L1, GlobalInfo);
%% 重置玩家的奖品抽奖限制因子信息列表
check_reset_limit(free, FreeInfo) ->
    L0 = lottery_data:award_list(free),
    L1 = id_to_award(free, L0),
    do_check_reset_limit(L1, FreeInfo);
check_reset_limit(pay, PayInfo) ->
    L0 = lottery_data:award_list(pay),
    L1 = id_to_award(pay, L0),
    do_check_reset_limit(L1, PayInfo).
do_check_reset_limit([], InfoList) -> InfoList;
do_check_reset_limit([#lottery_item{base_id = BaseId} | T], InfoList) ->
    case lists:keyfind(BaseId, #lottery_item.base_id, InfoList) of
        false ->
            Info = #lottery_info{base_id = BaseId},
            do_check_reset_limit(T, [Info | InfoList]);
        _ ->
            do_check_reset_limit(T, InfoList)
    end;
do_check_reset_limit([_ | T], InfoList) ->
    do_check_reset_limit(T, InfoList).

%% 浮动概率表初始化，默认从付费奖品列表取概率
do_init_float_rand() ->
    L = lottery_data:award_list_float(),
    Fun = fun(Id) ->
            case lottery_data:get(pay, Id) of
                {ok, #lottery_item{base_id = Id, rand = Rand}} ->
                    {Id, Rand, 0}; %% {浮动概率奖品ID，当前初始浮动概率为默认，已抽中次数（大于0则下次浮动概率翻倍）}
                _ ->
                    {30008, 15, 0} %% 默认值 TODO: 
            end
    end,
    [Fun(Id) || Id <- L].

%% 检查特殊限制
check_special(RoleId, LI, #lottery_state{log = Logs}) ->
    check_special(RoleId, LI, Logs);
check_special(_, _, []) ->
    true;
check_special({Rid, SrvId}, #lottery_item{base_id = BaseId}, [#lottery_log{rid = Rid, srv_id = SrvId, award_id = BaseId} | _T]) ->
    false;
check_special(RoleId, LI, [_H | T]) ->
    check_special(RoleId, LI, T).

%% 检查系统全服信息是否可中
check(global, _Now, #lottery_item{limit = ?LIMIT_ROLE}, _) -> true;
check(global, Now, #lottery_item{base_id = BaseId, limit = ?LIMIT_GLOBAL, limit_time = {_, Xt}, limit_num = {Ln, Xn}, must_num = Xm},
    #lottery_state{info = Info}) ->
    case lists:keyfind(BaseId, #lottery_info.base_id, Info) of
        false ->
            true; %% 全服没有限制, 可通过
        #lottery_info{lucky_num = Lnum} when Xm =/= 0 andalso Lnum >= Xm ->
            true; %% 必出
        #lottery_info{time_info = {ToTime, Xtn}} when Xt =/= 0 andalso Now =< ToTime andalso Xtn >= Xt ->
            false; %% 限制时间内不出
        #lottery_info{num_info = {Nn, Xno}} when Xn =/= 0 andalso Nn >= Ln andalso Xno =< Xn ->
            false; %% 中Ln次该物品后，Xn次内不能再中
        _ ->
            true
    end;
%% 检查玩家是否可抽中
check(free, Now, #lottery_item{base_id = BaseId, limit = ?LIMIT_ROLE, limit_time = {_, Xt}, limit_num = {Ln, Xn}, must_num = Xm},
    #lottery{free_info = FreeInfo}) ->
    case lists:keyfind(BaseId, #lottery_info.base_id, FreeInfo) of
        false ->
            true;
        #lottery_info{lucky_num = Lnum} when Xm =/= 0 andalso Lnum >= Xm ->
            true; %% 必出
        #lottery_info{time_info = {ToTime, Xtn}} when Xt =/= 0 andalso Now =< ToTime andalso Xtn >= Xt ->
            false; %% 限制时间抽中次数超出限制，不出
        #lottery_info{num_info = {Nn, Xno}} when Xn =/= 0 andalso Nn >= Ln andalso Xno =< Xn ->
            false; %% 中Ln次该物品后，Xn次内不能再中
        _ -> true
    end;
check(pay, Now, #lottery_item{base_id = BaseId, limit = ?LIMIT_ROLE, limit_time = {_, Xt}, limit_num = {Ln, Xn}, must_num = Xm},
    #lottery{pay_info = PayInfo}) ->
    case lists:keyfind(BaseId, #lottery_info.base_id, PayInfo) of
        false ->
            true;
        #lottery_info{lucky_num = Lnum} when Xm =/= 0 andalso Lnum >= Xm ->
            true; %% 必出
        #lottery_info{time_info = {ToTime, Xtn}} when Xt =/= 0 andalso Now =< ToTime andalso Xtn >= Xt ->
            %% ?DEBUG("Xt:~w Now:~w ToTime:~w, Xtn:~w", [Xt, Now, ToTime, Xtn]),
            false; %% 限制时间内抽中次数超出限制，不出
        _I = #lottery_info{num_info = {Nn, Xno}} when Xn =/= 0 andalso Nn >= Ln andalso Xno =< Xn ->
            %% ?DEBUG("Nn:~w Xno:~w, Ln:~w, Xn:~w~n I:~w", [Nn, Xno, Ln, Xn, _I]),
            false; %% 中Ln次该物品后，Xn次内不能再中
        _ -> true
    end;
check(_, _, _, _) ->
    true.

%% 抽奖后的全服因子信息记录更新
update_global(free, Now, LI, LotteryState = #lottery_state{info = GlobalInfo}) ->
    NewGlobalInfo = do_update(free, Now, LI, GlobalInfo, []),
    LotteryState#lottery_state{info = NewGlobalInfo}; %% 不可能抽中头奖
update_global(pay, Now, LI = #lottery_item{base_id = ?FIRST_PRIZE_ID}, LotteryState = #lottery_state{info = GlobalInfo}) -> %% 有人抽到头奖
    NewGlobalInfo = do_update(pay, Now, LI, GlobalInfo, []),
    %% 重置浮动概率定时器
    case get(lottery_float_rand) of
        undefined ->
            put(lottery_float_rand, erlang:send_after(?FLOAT_INTERVAL_TIMER * 1000, self(), interval_update));
        Timer ->
            erlang:cancel_timer(Timer),
            put(lottery_float_rand, erlang:send_after(?FLOAT_INTERVAL_TIMER * 1000, self(), interval_update))
    end,
    NewState = interval_update(reset_float, LotteryState),
    NewState#lottery_state{
        bonus = ?FIRST_PRIZE_NUM,
        float_end = Now + ?FLOAT_INTERVAL_TIMER,
        info = NewGlobalInfo
    }; %% 抽中头奖，奖池重置
update_global(pay, Now, LI = #lottery_item{base_id = AwardId, num = Num},
    LotteryState = #lottery_state{bonus = Bonus, info = GlobalInfo})
when AwardId =:= ?SECOND_PRIZE_ID orelse AwardId =:= ?THIRD_PRIZE_ID ->
    %% 有人抽到二/三等奖
    NewGlobalInfo = do_update(pay, Now, LI, GlobalInfo, []),
    LotteryState#lottery_state{bonus = Bonus - Num, info = NewGlobalInfo}; %% 奖池奖金更新
update_global(pay, Now, LI, LotteryState = #lottery_state{bonus = Bonus, info = GlobalInfo}) ->
    NewGlobalInfo = do_update(pay, Now, LI, GlobalInfo, []),
    LotteryState#lottery_state{bonus = Bonus + ?LUCKY_TO_POOL, info = NewGlobalInfo}. %% 未中头奖，奖池累加
%% 抽奖后玩家抽奖因子信息更新
update(free, Now, LI, Lottery = #lottery{free_info = FreeInfo}) ->
    NewFreeInfo = do_update(free, Now, LI, FreeInfo, []),
    Lottery#lottery{free_info = NewFreeInfo};
update(pay, Now, LI, Lottery = #lottery{pay_info = PayInfo}) ->
    NewPayInfo = do_update(pay, Now, LI, PayInfo, []),
    Lottery#lottery{pay_info = NewPayInfo};
update(_, _, _, L) ->
    ?DEBUG("更新调用出错"),
    L.

do_update(_Type, _Now, _LI, [], NewInfoList) -> NewInfoList;
do_update(Type, Now, LI = #lottery_item{base_id = BaseId, limit_time = {Lt, Xt}},
    [Info = #lottery_info{base_id = BaseId, time_info = {ToTime, ToXt}, num_info = {Nn, _Xno}} | T], NewInfoList) ->
    %% 已抽中当前奖品
    NewInfo0 = Info#lottery_info{last_time = Now, lucky_num = 0},
    NewInfo1 = case Xt =/= 0 of
        false -> %% 无效因子
            NewInfo0;
        true ->
            case Now >= ToTime of
                true -> %% Limit时间限制因子：时间累加，次数重置
                    NewInfo0#lottery_info{time_info = {Now + Lt, ToXt + 1}};
                false -> %% 时间不变，次数累加
                    NewInfo0#lottery_info{time_info = {ToTime, ToXt + 1}}
            end
    end,
    NewInfo2 = NewInfo1#lottery_info{num_info = {Nn + 1, 0}},
    do_update(Type, Now, LI, T, [NewInfo2 | NewInfoList]);
do_update(Type, Now, LI,
    _I = [Info = #lottery_info{base_id = BaseId, time_info = {ToTime, _ToXt}, num_info = {Nn, Xno}, lucky_num = Lnum} | T], NewInfoList) ->
    case lottery_data:get(Type, BaseId) of
        {ok, #lottery_item{base_id = _BaseId, limit_time = {Lt, Xt}, limit_num = {Ln, Xn}}} ->
            %% 没抽中当前奖品
            NewInfo0 = Info#lottery_info{lucky_num = Lnum + 1},
            NewInfo1 = case Xt =/= 0 of
                false -> %% 无效因子忽略
                    NewInfo0;
                true ->
                    case Now >= ToTime of
                        true -> %% 时间限制已结束
                            NewInfo0#lottery_info{time_info = {Now + Lt, 0}};
                        false ->
                            NewInfo0
                    end
            end,
            NewInfo2 = case Xno >= Xn of %% 抽空足够次数
                true ->
                    NewInfo1#lottery_info{num_info = {0, 0}};
                false when Ln >= Nn -> %% 实际抽中数小于等于限制数
                    NewInfo1#lottery_info{num_info = {Nn, Xno + 1}};
                false ->        %% 实际抽中数如果大于Nn, 说明前面抽奖判断可能有错误
                    ?ELOG("抽奖更新异常[BASE:~w, INFOList:~w, NewList:~w]", [LI, _I, NewInfoList]),
                    NewInfo1#lottery_info{num_info = {Nn, Xno + 1}}
            end,
            do_update(Type, Now, LI, T, [NewInfo2 | NewInfoList]);
        _ ->
            do_update(Type, Now, LI, T, NewInfoList)
    end;
do_update(_, _, _, _, NewInfoList) ->
    ?DEBUG("抽奖更新异常2"),
    NewInfoList.

%% 更新抽奖奖品日志
update_log(global, Now, {Rid, SrvId}, Name, #lottery_item{base_id = ?FIRST_PRIZE_ID, num = Num}, State = #lottery_state{log = LogList}) ->
    Log = #lottery_log{rid = Rid, srv_id = SrvId, name = Name, award_id = ?FIRST_PRIZE_ID, award_num = Num, ctime = Now},
    NewLogList = case LogList of
        [L1, L2, L3, L4, L5, L6, L7, L8, L9, _L10] ->
            [Log, L1, L2, L3, L4, L5, L6, L7, L8, L9];
        L -> [Log | L]
    end,
    LastFirst = {Rid, SrvId, Name, Num},
    State#lottery_state{last_first = LastFirst, log = NewLogList};
update_log(global, Now, {Rid, SrvId}, Name, #lottery_item{base_id = BaseId, num = Num, is_notice = ?true}, State = #lottery_state{log = LogList}) ->
    Log = #lottery_log{rid = Rid, srv_id = SrvId, name = Name, award_id = BaseId, award_num = Num, ctime = Now},
    NewLogList = case LogList of
        [L1, L2, L3, L4, L5, L6, L7, L8, L9, _L10] ->
            [Log, L1, L2, L3, L4, L5, L6, L7, L8, L9];
        L -> [Log | L]
    end,
    State#lottery_state{log = NewLogList};
update_log(_, _, _, _, _, State) ->
    State.

%% 奖池信息更新
%% 浮动翻倍, 规定小时内没有人中头奖，则大奖(暂时只包括头奖)的概率翻倍
interval_update(float, State = #lottery_state{rands = Rands}) ->
    NewRands = float_rand(Rands, []),
    PayAwardList = award_list(pay, NewRands),
    FreeAwardList = award_list(free, []),
    NewIntervalPay = calc_interval(PayAwardList),
    NewIntervalFree = calc_interval(FreeAwardList),
    put(pay_award_list, PayAwardList),
    put(free_award_list, FreeAwardList),
    State#lottery_state{interval_pay = NewIntervalPay, interval_free = NewIntervalFree, rands = NewRands};
%% 初始化
interval_update(init, State) ->
    Rands = do_init_float_rand(),
    PayAwardList = award_list(pay, Rands),
    FreeAwardList = award_list(free, []),
    put(free_award_list, FreeAwardList),
    put(pay_award_list, PayAwardList),
    State#lottery_state{
        interval_free = calc_interval(FreeAwardList),
        interval_pay = calc_interval(PayAwardList),
        rands = Rands
    };
%% 重置浮动概率
interval_update(reset_float, State = #lottery_state{rands = Rands}) ->
    {ok, #lottery_item{rand = Rand}} = lottery_data:get(pay, ?FIRST_PRIZE_ID),
    NewRands = lists:keyreplace(?FIRST_PRIZE_ID, 1, Rands, {?FIRST_PRIZE_ID, Rand, 0}),
    PayAwardList = award_list(pay, NewRands),
    put(pay_award_list, PayAwardList),
    State#lottery_state{
        rands = NewRands,
        interval_pay = calc_interval(PayAwardList)
    }; %% 抽中头奖，奖池重置
interval_update(_, State) ->
    State.

%% 浮动概率结算
float_rand([], L) -> L;
float_rand([{Id, R, _} | T], L) when R =< 0 -> %% 容错
    case lottery_data:get(pay, Id) of
        {ok, #lottery_item{rand = Rand}} ->
            float_rand(T, [{Id, Rand * 2, 0} | L]);
        _ ->
            float_rand(T, L)
    end;
float_rand([{Id, R, _} | T], L) -> %% 浮动概率 翻倍
    case lottery_data:get(pay, Id) of
        {ok, #lottery_item{}} ->
            float_rand(T, [{Id, R * 2, 0} | L]);
        _ ->
            float_rand(T, L)
    end;
float_rand(_, L) -> L.

%% 抽中金币奖(头奖、二等奖、三等奖)后返回新的奖金
is_special_prize(LI = #lottery_item{base_id = ?FIRST_PRIZE_ID}, #lottery_state{bonus = Bonus}) ->
    LI#lottery_item{num = Bonus};
is_special_prize(LI = #lottery_item{base_id = ?SECOND_PRIZE_ID}, #lottery_state{bonus = Bonus}) ->
    LI#lottery_item{num = Bonus * 10 div 100};
is_special_prize(LI = #lottery_item{base_id = ?THIRD_PRIZE_ID}, #lottery_state{bonus = Bonus}) ->
    LI#lottery_item{num = Bonus * 3 div 100};
is_special_prize(LI, _) ->
    LI.

%% ------------------------------
%% 内部处理
%% ------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    State = case catch sys_env:get(lottery_state) of
        S = #lottery_state{float_end = EndTime} when EndTime > 0 -> S;
        _ -> #lottery_state{}
    end,
    self() ! init,
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

%% 获取state
handle_call(get_state, _From, State = #lottery_state{}) ->
    {reply, {ok, State}, State};
handle_call(get_state, _From, State) ->
    {reply, {false, State}, State};

%% 抽奖一次
handle_call({lucky, RoleId, Name, Type, Now, Lottery}, _From, State = #lottery_state{interval_free = Interval})
when Type =:= free ->
    case platform_cfg:get_cfg(lottery_open) of
        ?false ->
            {reply, {false, <<"************">>}, State};
        _ ->
            NewLot0 = check_and_reset(free, Lottery),
            AwardList = get(free_award_list),
            ?DEBUG("INTER:~w, AwardList:~w", [Interval, AwardList]),
            LI = rand_award(Interval, AwardList), %% 先随机奖品
            Ret = case check(global, Now, LI, State) of
                false ->
                    ?DEBUG("LI:~w~nState:~w", [LI, State]),
                    false;
                true ->
                    case check(Type, Now, LI, Lottery) of
                        false -> 
                            ?DEBUG("LI:~w~nState: ~p~nLot: ~p", [LI, State, Lottery]),
                            false;
                        true -> true
                    end
            end,
            %% ?DEBUG("免费抽奖---------------"),
            %% ?DEBUG("是否抽中：~w  随机物品：~w", [Ret, LI]),
            NewLI = case Ret of
                true -> 
                    is_special_prize(LI, State); %% 头奖奖池的数量是刷新的
                _ -> 
                    {ok, LastLI} = lottery_data:get(pay, ?LAST_PRIZE_ID), %% 抽中又不可中的替换为安慰奖
                    LastLI
            end,
            NewLottery = update(Type, Now, NewLI, NewLot0),
            NewState0 = update_global(Type, Now, NewLI, State),
            NewState = update_log(global, Now, RoleId, Name, NewLI, NewState0),
            %% ?DEBUG("免费抽奖完---------------"),
            %% ?DEBUG("NewLI: ~w", [NewLI]),
            %% ?DEBUG("LOT: ~w", [NewLottery]),
            %% ?DEBUG("STATE: ~w", [NewState]),
            {reply, {Ret, NewLI, NewLottery, NewState}, NewState}
    end;
handle_call({lucky, RoleId, Name, Type, Now, Lottery}, _From, State = #lottery_state{interval_pay = Interval})
when Type =:= pay ->
    case platform_cfg:get_cfg(lottery_open) of
        ?false ->
            {reply, {false, <<"************">>}, State};
        _ ->
            NewLot0 = check_and_reset(pay, Lottery),
            AwardList = get(pay_award_list),
            ?DEBUG("INTER:~w, AwardList:~w", [Interval, AwardList]),
            %% ?DEBUG("抽奖列表:~p", [AwardList]),
            %% -----------------gm指定获奖者
            LI = case get(lottery_lucker) of
                undefined -> rand_award(Interval, AwardList);
                RoleId ->
                    ?INFO("截获指定抽奖玩家：~w", [RoleId]),
                    case lists:member(30008, AwardList) of
                        true ->
                            case lottery_data:get(pay, 30008) of
                                {ok, L}->
                                    put(lottery_lucker, undefined),
                                    L;
                                _ -> rand_award(Interval, AwardList)
                            end;
                        false -> rand_award(Interval, AwardList)
                    end;
                _X -> rand_award(Interval, AwardList) %% 先随机奖品
            end,
            %% -----------------
            Ret = case check(global, Now, LI, State) of
                false ->
                    ?DEBUG("LI:~w~nState:~w", [LI, State]),
                    false;
                true ->
                    case check(Type, Now, LI, Lottery) of
                        false ->
                            ?DEBUG("LI:~w~nState: ~p~nLot: ~p", [LI, State, Lottery]),
                            false;
                        true -> true
                    end
            end,
            %% ?DEBUG("付费抽奖---------------"),
            %% ?DEBUG("是否抽中：~w  随机物品：~w", [Ret, LI]),
            NewLI = case Ret of
                true -> 
                    case check_special(RoleId, LI, State) of
                        true ->
                            case LI of
                                #lottery_item{base_id = ?FIRST_PRIZE_ID} ->
                                    ?INFO("玩家[Name: ~s]抽中大奖，个人抽奖信息：~w~n奖池信息：~w", [Name, Lottery, State]);
                                _ -> ignore
                            end,
                            is_special_prize(LI, State); %% 头奖奖池的数量是刷新的
                        false ->
                            {ok, LastLI} = lottery_data:get(pay, ?LAST_PRIZE_ID), %% 抽中又不可中的替换为安慰奖
                            LastLI
                    end;
                _ -> 
                    ?DEBUG("抽中不可中:~w", [LI]),
                    {ok, LastLI} = lottery_data:get(pay, ?LAST_PRIZE_ID), %% 抽中又不可中的替换为安慰奖
                    LastLI
            end,
            NewLottery = update(Type, Now, NewLI, NewLot0),
            NewState0 = update_global(Type, Now, NewLI, State),
            NewState = update_log(global, Now, RoleId, Name, NewLI, NewState0),
            %% ?DEBUG("付费抽奖完---------------"),
            %% ?DEBUG("NewLI: ~w", [NewLI]),
            %% ?DEBUG("LOT: ~w", [NewLottery]),
            %% ?DEBUG("STATE: ~w", [NewState]),
            {reply, {Ret, NewLI, NewLottery, NewState}, NewState}
    end;

%% 重载
handle_call(adm_reload, _From, State) ->
    self() ! init,
    {reply, ok, State};

%% 关闭
handle_call(adm_stop, _From, State) ->
    self() ! stop,
    {reply, ok, State};

%% 重置奖池信息
handle_call({adm_set_state, NewState}, _From, _State) ->
    self() ! init,
    {reply, ok, NewState};

handle_call(pid, _, State) ->
    {reply, self(), State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 获取奖池当前信息
handle_cast({get_pool, ConnPid, Free}, State = #lottery_state{bonus = Bonus,
        last_first = {Rid, SrvId, Name, Num}, log = List}) ->
    sys_conn:pack_send(ConnPid, 14700, {Free, Bonus, Rid, SrvId, Name, Num, List}),
    {noreply, State};
handle_cast({get_pool, ConnPid, Free}, State = #lottery_state{bonus = Bonus,
        last_first = _, log = List}) ->
    sys_conn:pack_send(ConnPid, 14700, {Free, Bonus, 0, <<>>, <<>>, 0, List}),
    {noreply, State};

handle_cast({lottery_lucker, Id}, State) ->
    put(lottery_lucker, Id),
    {noreply, State};    

handle_cast(_Data, State) ->
    {noreply, State}.

%% 初始化
handle_info(init, State = #lottery_state{rands = RandList, float_end = EndTime})
when EndTime > 0 andalso is_list(RandList) ->
    Now = util:unixtime(),
    NewState = case Now >= EndTime of
        true ->
            put(free_award_list, award_list(free, [])),
            interval_update(float, State); %% 浮动概率翻倍
        false ->
            PayList = award_list(pay, RandList),
            FreeList = award_list(free, []),
            put(pay_award_list, PayList),
            put(free_award_list, FreeList),
            put(lottery_float_rand, erlang:send_after((EndTime - Now) * 1000, self(), interval_update)),
            ?DEBUG("初始化时重置抽奖列表：~w", [PayList]),
            State#lottery_state{interval_free = calc_interval(FreeList), interval_pay = calc_interval(PayList)}
    end,
    erlang:send_after(180 * 1000, self(), save_state),
    ?DEBUG("幸运抽奖服务初始化*1*完成:~w", [NewState]),
    {noreply, NewState};
handle_info(init, State) ->
    Now = util:unixtime(),
    State0 = interval_update(init, State),
    put(lottery_float_rand, erlang:send_after(?FLOAT_INTERVAL_TIMER * 1000, self(), interval_update)),
    erlang:send_after(180 * 1000, self(), save_state),
    NewState = State0#lottery_state{
        bonus = ?FIRST_PRIZE_NUM
        ,float_end = Now + ?FLOAT_INTERVAL_TIMER
        ,info = check_reset_limit(global, [])
    },
    ?DEBUG("幸运抽奖服务初始化*2*完成:~w", [NewState]),
    {noreply, NewState};

%% interval_update
handle_info(interval_update, State) ->
    State0 = interval_update(float, State),
    put(lottery_float_rand, erlang:send_after(?FLOAT_INTERVAL_TIMER * 1000, self(), interval_update)),
    NewState = State0#lottery_state{float_end = util:unixtime() + ?FLOAT_INTERVAL_TIMER},
    ?DEBUG("完成浮动概率翻倍：~w", [NewState]),
    {noreply, NewState};

%% 保存信息
handle_info(save_state, State) ->
    case sys_env:save(lottery_state, State) of
        ok -> ?DEBUG("抽奖机保存信息成功");
        _E -> ?ERR("抽奖机保存信息失败:~w", [_E])
    end,
    erlang:send_after(180 * 1000, self(), save_state),
    {noreply, State};

%% stop
handle_info(stop, State) ->
    {stop, normal, State};

%% 容错
handle_info(_Data, State) ->
    ?ERR("错误的异步消息处理：DATA:~w, State:~w", [_Data, State]),
    {noreply, State}.

terminate(_Reason, State) ->
    ?DEBUG("抽奖机进程关闭:~w~n抽奖机信息记录：~w", [_Reason, State]),
    case sys_env:save(lottery_state, State) of
        ok -> ?DEBUG("抽奖机保存信息成功");
        _E -> ?ERR("抽奖机保存信息失败:~w", [_E])
    end,
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
