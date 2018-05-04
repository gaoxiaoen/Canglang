%%----------------------------------------------------
%% 累计充值返利
%% 指定时间内累积充值1000晶钻额外返还1000晶钻（每一天返还100晶钻，返10天）
%%
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(campaign_repay_bystages).
-behaviour(gen_fsm).
-export(
    [
        start_link/0
        ,charge/2
        ,next/1
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export(
    [
        idel/2
        ,activity/2
        ,date_2/2
        ,date_3/2
        ,date_4/2
        ,date_5/2
        ,date_6/2
        ,date_7/2
        ,date_8/2
        ,date_9/2
        ,date_10/2
        ,overtime/2
    ]
).

-record(state, {
        ts = 0
        ,timeout_val
    }
).

-record(camp_bystages_role, {
        id = {0, <<>>}      %% 角色id
        ,charge_sum = 0     %% 汇总
    }
).

-include("common.hrl").
-include("role.hrl").
-include("mail.hrl").

-define(camp_repay_bystages_start, util:datetime_to_seconds({{2013, 2, 26}, {14, 20, 1}})).      %% 活动开始时间 
-define(camp_repay_bystages_end, util:datetime_to_seconds({{2013, 2, 26}, {23, 59, 59}})).      %% 活动结束时间
-define(camp_repay_bystages_second, util:datetime_to_seconds({{2013, 2, 27}, {11, 0, 0}})).     %% 第二天发放时间
-define(camp_repay_bystages_goldsum, 1000). %% 每次活动都不一样

%%----------------------------------------------------
%% API
%%----------------------------------------------------
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

charge(_Role = #role{id = {RoleId, SrvId}}, Gold) ->
    gen_fsm:send_all_state_event(?MODULE, {charge, {RoleId, SrvId}, Gold}).

%% 下一个状态
next(Event) ->
    gen_fsm:send_event(?MODULE, Event).

%%----------------------------------------------------
%% gen_fsm function
%%----------------------------------------------------
init([])->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    {StateName, T} = get_idel_time(),
    ets:new(ets_camp_repay_bystages_role, [set, named_table, public, {keypos, #camp_bystages_role.id}]),
    ets:new(ets_camp_repay_bystages_enough, [set, named_table, public, {keypos, #camp_bystages_role.id}]),
    case init_ets(StateName) of
        ok ->
            ?INFO("[~w] 启动完成 ~w", [?MODULE, StateName]),
            {ok, StateName, #state{ts = erlang:now(), timeout_val = T}, T};
        _Err ->
            ?ERR("[~w] 启动失败~w", [?MODULE, _Err]),
            ?INFO("[~w] 启动失败", [?MODULE]),
            {stop, normal}
    end.

handle_event({charge, {RoleId, SrvId}, Gold}, activity, State) ->
    Key = {RoleId, SrvId},
    case ets:lookup(ets_camp_repay_bystages_enough, Key) of
        [] ->
            case ets:lookup(ets_camp_repay_bystages_role, Key) of
                [] ->
                    GRole = #camp_bystages_role{id = {RoleId, SrvId}, charge_sum = Gold},
                    ets:insert(ets_camp_repay_bystages_role, GRole),
                    case Gold >= ?camp_repay_bystages_goldsum of
                        true -> 
                            send_mail(RoleId, SrvId),
                            ets:insert(ets_camp_repay_bystages_enough, GRole);
                        _ -> ignore
                    end;
                [#camp_bystages_role{charge_sum = OGold}] ->
                    GRole = #camp_bystages_role{id = {RoleId, SrvId}, charge_sum = (Gold + OGold)},
                    ets:insert(ets_camp_repay_bystages_role, GRole),
                    case (Gold + OGold) >= ?camp_repay_bystages_goldsum of
                        true -> 
                            send_mail(RoleId, SrvId),
                            ets:insert(ets_camp_repay_bystages_enough, GRole);
                        _ -> ignore
                    end;
                _Other ->
                    ?ERR("累计充值返利有误:~w", [_Other])
            end;
        _ -> ignore
    end,
    continue(activity, State);

handle_event({charge, {_RoleId, _SrvId}, _Gold}, StateName, State) ->
    ?DEBUG("不是活动期间不处理[RoleId:~w, SrvId:~s, Gold:~w]", [_RoleId, _SrvId, _Gold]),
    continue(StateName, State);

handle_event(_Event, StateName, State) ->
    continue(StateName, State).

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(StateName, Reply, State).

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%----------------------------------------------------
%% state function
%%----------------------------------------------------
%% 空闲状态结束
idel(timeout, State) ->
    ?DEBUG("空闲状态结束"),
    {StateName, Timeout} = get_idel_time(),
    {next_state, StateName, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
idel(_Any, State) ->
    continue(idel, State).

activity(timeout, State) ->
    ?DEBUG("~w状态结束", [activity]),
    Timeout = (?camp_repay_bystages_second - ?camp_repay_bystages_end) * 1000,
    {next_state, date_2, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
activity(_Any, State) ->
    continue(activity, State).

date_2(timeout, State) ->
    ?DEBUG("~w状态结束", [date_2]),
    List = ets:tab2list(ets_camp_repay_bystages_enough),
    do_send_mail(List),
    Timeout = 86400 * 1000,
    {next_state, date_3, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
date_2(_Any, State) ->
    continue(date_2, State).

date_3(timeout, State) ->
    ?DEBUG("~w状态结束", [date_3]),
    List = ets:tab2list(ets_camp_repay_bystages_enough),
    do_send_mail(List),
    Timeout = 86400 * 1000,
    {next_state, date_4, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
date_3(_Any, State) ->
    continue(date_3, State).

date_4(timeout, State) ->
    ?DEBUG("~w状态结束", [date_4]),
    List = ets:tab2list(ets_camp_repay_bystages_enough),
    do_send_mail(List),
    Timeout = 86400 * 1000,
    {next_state, date_5, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
date_4(_Any, State) ->
    continue(date_4, State).

date_5(timeout, State) ->
    ?DEBUG("~w状态结束", [date_5]),
    List = ets:tab2list(ets_camp_repay_bystages_enough),
    do_send_mail(List),
    Timeout = 86400 * 1000,
    {next_state, date_6, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
date_5(_Any, State) ->
    continue(date_5, State).

date_6(timeout, State) ->
    ?DEBUG("~w状态结束", [date_6]),
    List = ets:tab2list(ets_camp_repay_bystages_enough),
    do_send_mail(List),
    Timeout = 86400 * 1000,
    {next_state, date_7, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
date_6(_Any, State) ->
    continue(date_6, State).

date_7(timeout, State) ->
    ?DEBUG("~w状态结束", [date_7]),
    List = ets:tab2list(ets_camp_repay_bystages_enough),
    do_send_mail(List),
    Timeout = 86400 * 1000,
    {next_state, date_8, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
date_7(_Any, State) ->
    continue(date_7, State).

date_8(timeout, State) ->
    ?DEBUG("~w状态结束", [date_8]),
    List = ets:tab2list(ets_camp_repay_bystages_enough),
    do_send_mail(List),
    Timeout = 86400 * 1000,
    {next_state, date_9, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
date_8(_Any, State) ->
    continue(date_8, State).

date_9(timeout, State) ->
    ?DEBUG("~w状态结束", [date_9]),
    List = ets:tab2list(ets_camp_repay_bystages_enough),
    do_send_mail(List),
    Timeout = 86400 * 1000,
    {next_state, date_10, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
date_9(_Any, State) ->
    continue(date_9, State).

date_10(timeout, State) ->
    ?DEBUG("~w状态结束", [date_10]),
    List = ets:tab2list(ets_camp_repay_bystages_enough),
    do_send_mail(List),
    Timeout = 86400 * 1000,
    {next_state, overtime, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
date_10(_Any, State) ->
    continue(date_10, State).

overtime(timeout, State) ->
    ?DEBUG("~w状态结束", [overtime]),
    %% List = ets:tab2list(ets_camp_repay_bystages_enough),
    %% do_send_mail(List),
    {StateName, Timeout} = get_idel_time(),
    {next_state, StateName, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
overtime(_Any, State) ->
    continue(overtime, State).
%%----------------------------------------------------
%% internal
%%----------------------------------------------------
%% 获取空闲时间 - 状态机为毫秒
get_idel_time() ->
    Now = util:unixtime(),
    {St, T}= case {?camp_repay_bystages_start < Now, Now < ?camp_repay_bystages_end} of
        {false, _} ->
            {idel, (?camp_repay_bystages_start - Now)}; %% 时间还没到
        {true, true} ->
            {activity, (?camp_repay_bystages_end - Now)}; %% 活动期间
        {_, false} ->
            SecTime = ?camp_repay_bystages_second,
            if
                SecTime > Now -> {date_2, (SecTime - Now)};
                (SecTime + 86400) > Now -> {date_3, (SecTime + 86400) - Now};
                (SecTime + 86400 * 2) > Now -> {date_4, (SecTime + 86400 * 2) - Now};
                (SecTime + 86400 * 3) > Now -> {date_5, (SecTime + 86400 * 3) - Now};
                (SecTime + 86400 * 4) > Now -> {date_6, (SecTime + 86400 * 4) - Now};
                (SecTime + 86400 * 5) > Now -> {date_7, (SecTime + 86400 * 5) - Now};
                (SecTime + 86400 * 6) > Now -> {date_8, (SecTime + 86400 * 6) - Now};
                (SecTime + 86400 * 7) > Now -> {date_9, (SecTime + 86400 * 7) - Now};
                (SecTime + 86400 * 8) > Now -> {date_10, (SecTime + 86400 * 8) - Now};
                true -> {overtime, 86400}
            end
    end,
    {St, T * 1000}.

init_ets(StateName) when StateName =/= idel orelse StateName =/= overtime ->
    Sql = <<"select rid, srv_id, sum(gold) goldsum from sys_charge where ts > ~s and ts < ~s group by rid, srv_id">>,
    case db:get_all(Sql, [?camp_repay_bystages_start, ?camp_repay_bystages_end]) of
        {ok, Data} ->
            init_ets_role(Data),
            ok;
        {error, _Msg} ->
            ?ERR("读取充值信息失败:~w", [_Msg]),
            {false, _Msg}
    end;
init_ets(_StateName) -> ok.

init_ets_role([]) -> ok;
init_ets_role([[RoleId, SrvId, Gold] | T]) ->
    GRole = #camp_bystages_role{id = {RoleId, SrvId}, charge_sum = Gold},
    ets:insert(ets_camp_repay_bystages_role, GRole),
    case Gold >= ?camp_repay_bystages_goldsum of
        true -> ets:insert(ets_camp_repay_bystages_enough, GRole);
        _ -> ignore
    end,
    init_ets_role(T).

do_send_mail([]) -> ok;
do_send_mail([#camp_bystages_role{id = {RoleId, SrvId}} | T]) ->
    send_mail(RoleId, SrvId),
    do_send_mail(T).

send_mail(RoleId, SrvId) ->
    Subject = ?L(<<"春暖花开，100%好礼">>),
    Content = util:fbin(?L(<<"亲爱的玩家您好，您于2月26日参与春暖花开活动，累积充值达到1000晶钻，恭喜您获得额外1000晶钻返现（分十次返还），现给您返还100晶钻，祝您游戏愉快。">>), []),
    MailGold = [{?mail_gold, 100}],
    mail_mgr:deliver({RoleId, SrvId}, {Subject, Content, MailGold, []}).


%% continue
continue(StateName, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {next_state, StateName, State, util:time_left(TimeVal, Ts)}.
continue(StateName, Reply, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {reply, Reply, StateName, State, util:time_left(TimeVal, Ts)}.
