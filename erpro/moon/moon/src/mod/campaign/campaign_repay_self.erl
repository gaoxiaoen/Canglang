%%----------------------------------------------------
%% 充值结束后给充值玩家返还晶钻
%%
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(campaign_repay_self).
-behaviour(gen_fsm).
-export(
    [
        start_link/0
        ,get_start_time/0
        ,next/1
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([
        idel/2
        ,activity/2
        ,repay/2
        ,overtime/2
    ]
).

-record(state, {
        ts = 0
        ,timeout_val
    }
).

%% 个人信息
-record(camp_repay_self_role, {
        id = {0, <<>>, undefined}
        ,role_id
        ,srv_id
        ,name
        ,repay_gold
    }
).

-include("common.hrl").
-include("mail.hrl").

%% 活动开始时间
-ifdef(debug).
-define(camp_repay_start_4399, util:datetime_to_seconds({{2013, 2, 22}, {0, 00, 01}})).
-define(camp_repay_start_other, util:datetime_to_seconds({{2013, 2, 22}, {0, 00, 01}})).
-else.
-define(camp_repay_start_4399, util:datetime_to_seconds({{2013, 2, 22}, {0, 00, 01}})).
-define(camp_repay_start_other, util:datetime_to_seconds({{2013, 2, 22}, {8, 00, 01}})).
-endif.
%% 活动结束时间
-define(camp_repay_end, util:datetime_to_seconds({{2013, 2, 26}, {23, 59, 59}})).

-define(camp_repay_wait4pay, 30 * 60 * 1000). %% 活动结束后等待时间返还晶钻
-define(camp_repay_self_id, camp_repay_self_20130217). %% 每次活动都不一样
-define(camp_repay_sum, 5000). %% 充值多少返还晶钻

%%----------------------------------------------------
%% api
%%----------------------------------------------------
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

get_start_time() ->
    case sys_env:get(srv_id) of
        "4399_mhfx_1" -> ?camp_repay_start_4399;
        _ -> ?camp_repay_start_other
    end.

%% 下一个状态
next(Event) ->
    gen_fsm:send_event(?MODULE, Event).

%%----------------------------------------------------
%% gen_fsm
%%----------------------------------------------------
init([])->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    {StateName, T} = get_idel_time(),
    ets:new(ets_camp_repay_self, [set, named_table, public, {keypos, #camp_repay_self_role.id}]),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, StateName, #state{ts = erlang:now(), timeout_val = T}, T}.

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
    continue(StateName, State).
%%----------------------------------------------------
%% state
%%----------------------------------------------------
%% 空闲状态结束
idel(timeout, State) ->
    ?INFO("空闲状态结束"),
    {StateName, Timeout} = get_idel_time(),
    {next_state, StateName, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
idel(_Any, State) ->
    continue(idel, State).

%% 活动结束
activity(timeout, State) ->
    ?DEBUG("活动状态结束"),
    Timeout = ?camp_repay_wait4pay,
    {next_state, repay, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
activity(_Any, State) ->
    continue(activity, State).

%% 返还
repay(timeout, State) ->
    ?DEBUG("返还状态结束"),
    case {charge_info(), init_ets()} of
        {{ok, Data}, ok} ->
            do_repay(Data),
            Timeout = 86400,
            {next_state, overtime, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
        _ ->
            ?ERR("返还失败，半小时后重试"),
            Timeout = 30 * 60, %% 半小时后重试
            {next_state, repay, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout}
    end;
repay(_Any, State) ->
    continue(repay, State).

%% 过期
overtime(timeout, State) ->
    ?DEBUG("过期状态结束"),
    {StateName, Timeout} = get_idel_time(),
    {next_state, StateName, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
overtime(_Any, State) ->
    continue(overtime, State).

%%----------------------------------------------------
%% internal
%%----------------------------------------------------
init_ets() ->
    Sql = <<"select role_id, srv_id, camp_id, name, repay_gold from role_camp_repay_self where camp_id = ~s">>,
    case db:get_all(Sql, [?camp_repay_self_id]) of
        {ok, Data} ->
            ets:delete_all_objects(ets_camp_repay_self),
            init_ets(Data),
            ok;
        {error, _Msg} ->
            ?ERR("读取返还信息失败:~w", [_Msg]),
            {false, _Msg}
    end.
init_ets([]) -> ok;
init_ets([[RoleId, SrvId, CampId, Name, RepayGold] | T]) ->
    NewCampId = case util:bitstring_to_term(CampId) of
        {ok, TCampId} -> TCampId;
        _ -> CampId
    end,
    CampRole = #camp_repay_self_role{id = {RoleId, SrvId, NewCampId}, role_id = RoleId, srv_id = SrvId, name = Name, repay_gold = RepayGold},
    ets:insert(ets_camp_repay_self, CampRole),
    init_ets(T).

charge_info() ->
    Sql = <<"select rid, srv_id, sum(gold) from sys_charge where ts > ~s and ts < ~s group by rid, srv_id having sum(gold) >= ~s">>,
    case db:get_all(Sql, [get_start_time(), ?camp_repay_end, ?camp_repay_sum]) of
        {ok, Data} ->
            {ok, Data};
        {error, _Msg} ->
            ?ERR("读取充值信息失败:~w", [_Msg]),
            {false, _Msg}
    end.

sale_log(RoleId, SrvId, Gold) ->
    Sql = <<"insert into role_camp_repay_self(role_id, srv_id, camp_id, camp_start_time, camp_end_time, repay_gold, ct) values (~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    case db:execute(Sql, [RoleId, SrvId, ?camp_repay_self_id, get_start_time(), ?camp_repay_end, Gold, util:unixtime()]) of
        {ok, _Affected} -> ignore;
        {error, Msg} ->
            ?ERR("插入日志出错了:~w", [Msg]),
            {error, Msg}
    end.

do_repay([]) -> ok;
do_repay([[Rid, SrvId, Gold] | T]) ->
    Key = {Rid, SrvId, ?camp_repay_self_id},
    case ets:lookup(ets_camp_repay_self, Key) of
        [] ->
            Subject = ?L(<<"欢乐元宵，晶钻返现">>),
            G = round(Gold * 0.1),
            Content = util:fbin(?L(<<"亲爱的玩家，元宵节活动期间，您累积充值达~w晶钻，获得了10%非绑定晶钻返现，请注意查收！感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您和家人元宵佳节阖家欢乐、健康团圆！">>), [Gold]),
            MailGold = [{?mail_gold, G}],
            mail_mgr:deliver({Rid, SrvId}, {Subject, Content, MailGold, []}),
            sale_log(Rid, SrvId, G);
        _ -> ignore
    end,
    do_repay(T).

%% 获取空闲时间 - 状态机为毫秒
get_idel_time() ->
    Now = util:unixtime(),
    {St, T}= case {get_start_time() < Now, Now < ?camp_repay_end} of
        {false, _} ->
            {idel, (get_start_time() - Now)}; %% 时间还没到
        {true, true} ->
            {activity, (?camp_repay_end- Now)}; %% 活动期间
        {_, false} -> %% 过期 没有返还状态了
            {overtime, 86400}
    end,
    {St, T * 1000}.

%% continue
continue(StateName, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {next_state, StateName, State, util:time_left(TimeVal, Ts)}.
continue(StateName, Reply, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {reply, Reply, StateName, State, util:time_left(TimeVal, Ts)}.
