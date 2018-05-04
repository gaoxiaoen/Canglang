%%----------------------------------------------------
%% @doc 劳模活动
%%
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(campaign_model_worker).
-behaviour(gen_fsm).
-export(
    [
        start_link/0
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
%% 外部方法
-export([
        login/1
        ,sign_up/2
        ,listen/3
        ,apply_finish/2
        ,apply_reset/1
        ,info/1
        ,info/2
        ,adm_restart/0
        ,adm_stop/0
    ]).
%% 活动状态api
-export([
        idle/2
        ,active/2
    ]).

-include("common.hrl").
-include("role.hrl").
-include("campaign.hrl").
-include("vip.hrl").

-define(model_worker_open_lev, 45). %% 开放等级
-define(model_worker_campaign_id, 20130428). %% 默认活动id
-define(model_worker_panel_size, 10). %% 面板显示前几名
-define(model_worker_start_time, util:datetime_to_seconds({2013, 4, 28, 0, 0, 0})).
-define(model_worker_end_time, util:datetime_to_seconds({2013, 5, 3, 23, 59, 59})).
-define(model_worker_rank_fresh_timeout, 120).    %% 排行榜刷新间隔（秒）
-define(model_worker_finish_timeout, 86400).   %% 结束后再停留1天
-define(model_worker_charge_to_core, 100).  %% 没充值100晶钻就有5积分

%% 活动状态数据
-record(state, {
        ver = 1         %% 版本号
        ,id = 1         %% 活动id
        ,start_time     %% 开始时间
        ,finish_time    %% 结束时间
        ,team_a = []    %% 队伍a
        ,team_b = []    %% 队伍b
        ,num_a = 0      %% a队人数
        ,num_b = 0      %% b队人数
        ,score_a = 0    %% 队伍a总积分
        ,score_b = 0    %% 队伍b总积分
        ,reward_a = 0   %% a组平均分奖励
        ,reward_b = 0   %% b组平均分奖励
        ,next_refresh = 0 %% 下次刷新时间
    }).

%% 活动角色数据
-record(model_worker_role, {
        ver = 2
        ,id = {0, <<>>} %% 角色id
        ,name = <<>>    %% 角色名
        ,lev = 0        %% 等级
        ,sex            %% 性别
        ,career         %% 职业
        ,vip = 0        %% vip
        ,charge = 0     %% 充值积分
        ,active = 0     %% 活跃度积分
        ,score = 0      %% 总积分
        ,rank = 0       %% 排行
        ,reward = 0     %% 个人奖励领取记录
        ,team_reward = 0 %% 参与时队伍已发奖励记录
    }).

%% --------------- 外部方法 --------------------------------

%% @spec login(#role{}) -> ok
%% @doc 登录处理
login(#role{lev = Lev}) when Lev < ?model_worker_open_lev ->
    ok;
login(#role{campaign = #campaign_role{model_worker = #model_worker{rank = Rank}}, pid = Pid}) when Rank > 0 ->
    role:apply(async, Pid, {?MODULE, apply_finish, [Rank]});
login(Role = #role{campaign = #campaign_role{model_worker = #model_worker{id = ActId, score = _Score, team = Team}}, pid = Pid}) ->
    case Team > 0 of
        true ->
            Worker = convert(Role, to_worker),
            gen_fsm:send_all_state_event(?MODULE, {login, Worker, ActId, Pid, Team});
        _ -> ok
    end.

%% @spec sign_up(Role, Team) -> {ok, NewRole} | {false, Why}
%% Role = NewRole = #role{}
%% Team = integer()
%% Why = bitstring()
%% @doc 报名参加活动
sign_up(_Role, Team) when Team > 2 orelse Team < 1 ->
    {false, ?L(<<"无效队伍">>)};
sign_up(#role{lev = Lev}, _T) when Lev < ?model_worker_open_lev ->
    {false, ?L(<<"需要等级40以上才能报名">>)};
sign_up(#role{campaign = #campaign_role{model_worker = #model_worker{team = Team}}}, _T) when Team =/= 0 ->
    {false, ?L(<<"你已经报名了">>)};
sign_up(Role = #role{campaign = Camp, pid = Pid}, Team) ->
    Worker = #model_worker_role{score = Score, active = Active, charge = Charge} = convert(Role, to_worker),
    case gen_fsm:sync_send_all_state_event(?MODULE, {sign_up, Worker, Team}) of
        {ok, ActId, Panel} ->
            Data = panel_to_proto(Panel, Team, Score, Active, Charge),
            role:pack_send(Pid, 15878, Data),
            {ok, Role#role{campaign = Camp#campaign_role{model_worker = #model_worker{id = ActId, team = Team}}}};
        wrong_time ->
            {false, ?L(<<"现在不能报名">>)};
        _R ->
            ?DEBUG("报名失败 ~w", [_R]),
            {false, ?L(<<"报名失败">>)}
    end.

%% @spec listen(Role, Type, AddVal) -> NewRole
listen(Role = #role{campaign = #campaign_role{model_worker = #model_worker{team = 0}}}, _Type, _AddVal) ->
    Role;
%% 充值
listen(Role = #role{pid = Pid, campaign = Camp = #campaign_role{model_worker = Worker = #model_worker{start_time = _Start, finish_time = _Finish, charge = Charge, score = Score}}}, charge, AddVal) ->
    NewCharge = Charge + AddVal,
    AddScore = max(0, NewCharge div ?model_worker_charge_to_core - Charge div ?model_worker_charge_to_core) * 5,
    NewWorker = #model_worker{id = ActId, team = Team} = Worker#model_worker{
        charge = Charge + AddVal,
        score = Score + AddScore 
    },
    NewCamp = Camp#campaign_role{model_worker = NewWorker},
    NewRole = Role#role{campaign = NewCamp},
    gen_fsm:send_all_state_event(?MODULE, {update, convert(NewRole, to_worker), ActId, Team}),
    role:pack_send(Pid, 15880, convert(NewRole, to_15880)),
    NewRole;
%% 活跃度
listen(Role = #role{pid = Pid, campaign = Camp = #campaign_role{model_worker = Worker = #model_worker{start_time = _Start, finish_time = _Finish, active = Active, score = Score}}}, active, AddVal) ->
    NewWorker = #model_worker{id = ActId, team = Team} = Worker#model_worker{
        active = Active + AddVal,
        score = Score + AddVal
    },
    NewCamp = Camp#campaign_role{model_worker = NewWorker},
    NewRole = Role#role{campaign = NewCamp},
    gen_fsm:send_all_state_event(?MODULE, {update, convert(NewRole, to_worker), ActId, Team}),
    role:pack_send(Pid, 15880, convert(NewRole, to_15880)),
    NewRole;
listen(Role, _T, _A) ->
    ?DEBUG("未知监听 ~w", [_T]),
    Role.

%% 获取所有状态信息
info(all) ->
    gen_fsm:sync_send_all_state_event(?MODULE, all).
info(#role{id = Id, campaign = #campaign_role{model_worker = #model_worker{score = Score, active = Active, charge = Charge, team = Team}}}, panel) ->
    case gen_fsm:sync_send_all_state_event(?MODULE, {panel, Id, Team}) of
        Panel when is_tuple(Panel) ->
            Data = panel_to_proto(Panel, Team, Score, Active, Charge),
            ?DEBUG("返回协议 ~w", [Data]),
            Data;
        _ ->
            idle
            %% {[], [], 0, 0, 0, 0, Score, Active, Charge}
    end.


%% @spec apply_finish(Role, Rank) -> {ok, NewRole} | {ok}
%% Role = NewRole = #role{}
%% Rank = integer()
%% @doc 发放称号
apply_finish(Role = #role{campaign = Camp = #campaign_role{model_worker = Worker}}, Rank) ->
    NewWorker = Worker#model_worker{
        active = 0, 
        charge = 0,
        team = 0,
        score = 0,
        rank = Rank},
    {ok, Role#role{campaign = Camp#campaign_role{model_worker = NewWorker}}}.

%% @spec apply_reset(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 重置玩家状态
apply_reset(Role = #role{campaign = Camp = #campaign_role{model_worker = Worker}}) ->
    NewWorker = Worker#model_worker{
        active = 0, 
        charge = 0,
        team = 0,
        score = 0
    },
    {ok, Role#role{campaign = Camp#campaign_role{model_worker = NewWorker}}}.

%% gm或后台命令
-ifdef(debug).
adm_restart() ->
    Now = util:unixtime(),
    Finish = Now + 1800,
    gen_fsm:sync_send_all_state_event(?MODULE, {restart, Now, Now, Finish}).
-else.
adm_restart() ->
    {Id, Start, Finish} = get_campaign(),
    gen_fsm:sync_send_all_state_event(?MODULE, {restart, Id, Start, Finish}).
-endif.
%% 结束
adm_stop() ->
    gen_fsm:send_all_state_event(?MODULE, adm_stop).

%% ---------------- otp apis ---------------------------------
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

init([])->
    State = case sys_env:get(campaign_model_worker) of
        S when is_tuple(S) -> ver_parse(S);
        _ -> #state{}
    end,
    {Id, Start, End} = get_campaign(),
    NewState = State#state{
        id = Id,
        start_time = Start,
        finish_time = End
    },
    case continue(idle, NewState) of
        {active, Timeout} ->
            Now = util:unixtime(),
            Ref = erlang:send_after(?model_worker_rank_fresh_timeout * 1000, self(), fresh_rank),
            put(rank_fresh_timer, Ref),
            {ok, active, NewState#state{next_refresh = Now + ?model_worker_rank_fresh_timeout}, Timeout};
        {StateName, Timeout} ->
            {ok, StateName, NewState, Timeout}
    end.

%% 登录处理
%% 活动结束给他发奖励
handle_event({login, #model_worker_role{id = Rid}, ActId, Pid, Team}, idle, State = #state{id = ActId, team_a = TeamA, team_b = TeamB}) ->
    TeamT = case Team of
        1 -> TeamA;
        _ -> TeamB
    end,
    case lists:keyfind(Rid, #model_worker_role.id, TeamT) of
        #model_worker_role{rank = Rank} -> 
            role:apply(async, Pid, {?MODULE, apply_finish, [Rank]});
        _ -> 
            role:apply(async, Pid, {?MODULE, apply_reset, []})
    end,
    continue(next_state, idle, State);
%% 活动中，更新状态
handle_event({login, Worker = #model_worker_role{}, ActId, _Pid, Team}, active, State = #state{id = ActId}) ->
    NewState = update_worker(Worker, Team, State),
    continue(next_state, active, NewState);
%% 不是同一个活动
handle_event({login, _Worker, _ActId, Pid, _Team}, StateName, State) ->
    ?DEBUG("不是同一个活动 ~w", [_ActId]),
    role:apply(async, Pid, {?MODULE, apply_reset, []}),
    continue(next_state, StateName, State);

%% 活动中，更新状态
handle_event({update, Worker = #model_worker_role{}, ActId, Team}, active, State = #state{id = ActId}) ->
    NewState = update_worker(Worker, Team, State),
    continue(next_state, active, NewState);
%% 不在活动中忽略
handle_event({update, _Worker, _ActId, _Team}, StateName, State) ->
    continue(next_state, StateName, State);

%%  gm命令结束
handle_event(adm_stop, _StateName, State) ->
    active(timeout, State#state{finish_time = util:unixtime()});

handle_event(_Event, StateName, State) ->
    ?DEBUG("未知异步事件 ~w", [_Event]),
    continue(next_state, StateName, State).

%% 报名处理
handle_sync_event({sign_up, Worker = #model_worker_role{id = Rid}, Team}, _From, active, State = #state{id = ActId}) ->
    NewState = update_worker(Worker, Team, State),
    Panel = state_to_panel(Rid, Team, NewState),
    Reply = {ok, ActId, Panel},
    continue(Reply, active, NewState);
%% 活动未开启不能报名
handle_sync_event({sign_up, _Worker, _Team}, _From, StateName, State) ->
    Reply = wrong_time,
    continue(Reply, StateName, State);

%% 获取所有信息
handle_sync_event(all, _From, StateName, State) ->
    continue(State, StateName, State);

%% 获取面板信息
handle_sync_event({panel, Rid, Team}, _From, active, State) ->
    Reply = state_to_panel(Rid, Team, State),
    continue(Reply, active, State);
handle_sync_event({panel, _Rid, _Team}, _From, StateName, State) ->
    continue(idle, StateName, State);

%% gm命令设置开始及结束时间
handle_sync_event({restart, Id, _Start, _Finish}, _From, StateName, State = #state{id = Id}) ->
    Reply = {false, ?L(<<"当前活动已使用这个id">>)},
    continue(Reply, StateName, State);
handle_sync_event({restart, Id, Start, Finish}, _From, _StateName, _State) ->
    NewState = #state{
        id = Id,
        start_time = Start,
        finish_time = Finish
    },
    continue(ok, idle, NewState);

handle_sync_event(_Event, _From, StateName, State) ->
    ?DEBUG("未知同步事件 ~w", [_Event]),
    Reply = ok,
    continue(Reply, StateName, State).

%% 更新排行榜
handle_info(fresh_rank, active, State = #state{team_a = TeamA, team_b = TeamB, reward_a = RewardA, reward_b = RewardB, num_a = NumA, num_b = NumB}) ->
    %% 以防多个定时器出现
    case erlang:get(rank_fresh_timer) of
        OldRef when erlang:is_reference(OldRef) ->
            erlang:cancel_timer(OldRef);
        _ -> ok
    end,
    %% 排行规则目前只按总积分
    F = fun(#model_worker_role{score = A}, #model_worker_role{score = B}) ->
            A > B
    end,
    NewTeamA = lists:sort(F, TeamA),
    NewTeamB = lists:sort(F, TeamB),
    ScoreA = lists:sum([Sa || #model_worker_role{score = Sa} <- NewTeamA]),
    ScoreB = lists:sum([Sb || #model_worker_role{score = Sb} <- NewTeamB]),
    Ref = erlang:send_after(?model_worker_rank_fresh_timeout * 1000, self(), fresh_rank),
    put(rank_fresh_timer, Ref),
    NextRefresh = ?model_worker_rank_fresh_timeout + util:unixtime(),
    %% 平均积分每突破200就发一次奖励
    AveA = case NumA of
        0 -> 0;
        _ -> (ScoreA div NumA) div 200
    end,
    ItemMsg = notice:item_to_msg(reward_items({per_200, 1})),
    %% a队
    NewRewardA = case AveA - RewardA of
        Ca when RewardA =:= 0 andalso Ca > 0 -> 
            notice:send(52, util:fbin(?L(<<"辛勤耕耘，争当劳模。在众仙友的共同努力下，【{str, 诛仙组, #ffff00}】平均积分竟首次达到200，该组所有成员获得了~s，再接再厉，还有更多奖励等着您哦！">>), [ItemMsg])),
            RewardA + Ca;
        Ca when Ca > 0  -> 
            notice:send(52, util:fbin(?L(<<"辛勤耕耘，争当劳模。在众仙友的共同努力下，【{str, 诛仙组, #ffff00}】平均积分竟再次增长200，该组所有成员再次获得了~s，光荣劳模即将诞生！">>), [ItemMsg])),
            RewardA + Ca;
        _ -> 
            RewardA
    end,
    NewTeamA2 = [do_reward({per_200, AveA}, Ra) || Ra <- NewTeamA],
    %% b队
    AveB = case NumB of
        0 -> 0;
        _ -> (ScoreB div NumB) div 200
    end,
    NewRewardB = case AveB - RewardB of
        Cb when Cb > 0 andalso RewardB =:= 0 -> 
            notice:send(52, util:fbin(?L(<<"辛勤耕耘，争当劳模。在众仙友的共同努力下，【{str, 伏魔组, #ffff00}】平均积分竟首次达到200，该组所有成员获得了~s，再接再厉，还有更多奖励等着您哦！">>), [ItemMsg])),
            RewardB + Cb;
        Cb when Cb > 0 -> 
            notice:send(52, util:fbin(?L(<<"辛勤耕耘，争当劳模。在众仙友的共同努力下，【{str, 伏魔组, #ffff00}】平均积分竟再次增长200，该组所有成员再次获得了~s，光荣劳模即将诞生！">>), [ItemMsg])),
            RewardB + Cb;
        _ -> 
            RewardB
    end,
    NewTeamB2 = [do_reward({per_200, AveB}, Rb) || Rb <- NewTeamB],
    NewState = State#state{
        team_a = NewTeamA2, 
        team_b = NewTeamB2, 
        score_a = ScoreA, 
        score_b = ScoreB, 
        reward_a = NewRewardA,
        reward_b = NewRewardB,
        next_refresh = NextRefresh
    },
    sys_env:save(campaign_model_worker, NewState),
    continue(next_state, active, NewState);
handle_info(_Info, StateName, State) ->
    ?DEBUG("未知消息 ~w", [_Info]),
    continue(next_state, StateName, State).

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% ------------------------ 活动各状态 -----------------------------
%% 活动开始处理
idle(timeout, State) ->
    case erlang:get(rank_fresh_timer) of
        OldRef when erlang:is_reference(OldRef) ->
            erlang:cancel_timer(OldRef);
        _ -> ok
    end,
    notice:send(52, ?L(<<"辛勤耕耘，争当劳模活动现在开始了，广大仙友赶快报名吧，有丰富的奖品等着您哦。">>)),
    Now = util:unixtime(),
    Ref = erlang:send_after(?model_worker_rank_fresh_timeout * 1000, self(), fresh_rank),
    put(rank_fresh_timer, Ref),
    continue(next_state, active, State#state{next_refresh = Now + ?model_worker_rank_fresh_timeout});
idle(_Else, State) ->
    continue(next_state, idle, State).

%% 活动结束处理
active(timeout, State = #state{team_a = TeamA, team_b = TeamB}) ->
    F = fun(#model_worker_role{score = A}, #model_worker_role{score = B}) ->
            A > B
    end,
    NewTeamA = add_rank_num(1, lists:sort(F, TeamA)),
    NewTeamB = add_rank_num(1, lists:sort(F, TeamB)),
    ScoreA = lists:sum([Sa || #model_worker_role{score = Sa} <- NewTeamA]),
    ScoreB = lists:sum([Sb || #model_worker_role{score = Sb} <- NewTeamB]),
    ItemMsg = notice:item_to_msg(reward_items(winner)),
    case ScoreA >= ScoreB of
        true ->
            notice:send(52, util:fbin(?L(<<"恭喜【{str, 诛仙组, #ffff00}】在诛仙伏魔劳模对抗赛中取得胜利，该组所有贡献大于250积分的仙友均获得了~s，真是可喜可贺！">>), [ItemMsg])),
            [do_reward(winner, Ra) || Ra <- NewTeamA],
            [do_reward(loser, Rb) || Rb <- NewTeamB];
        _ ->
            notice:send(52, util:fbin(?L(<<"恭喜【{str, 伏魔组, #ffff00}】在诛仙伏魔劳模对抗赛中取得胜利，该组所有贡献大于250积分的仙友均获得了~s，真是可喜可贺！">>), [ItemMsg])),
            [do_reward(loser, Ra) || Ra <- NewTeamA],
            [do_reward(winner, Rb) || Rb <- NewTeamB]
    end,
    rank_3_notice([Rra || Rra = #model_worker_role{score = RraScore} <- NewTeamA, RraScore >= 250], a),
    rank_3_notice([Rrb || Rrb = #model_worker_role{score = RrbScore} <- NewTeamB, RrbScore >= 250], b),
    NewState = State#state{team_a = NewTeamA, team_b = NewTeamB, score_a = ScoreA, score_b = ScoreB},
    sys_env:save(campaign_model_worker, NewState),
    continue(next_state, idle, NewState);
active(_Else, State) ->
    continue(next_state, active, State).

%% --------------- 内部方法 ------------------------------
%% 版本转换
ver_parse(Data = #state{team_a = TeamA, team_b = TeamB}) ->
    NewTeamA = [ver_parse_role(A) || A <- TeamA],
    NewTeamB = [ver_parse_role(B) || B <- TeamB],
    Data#state{team_a = NewTeamA, team_b = NewTeamB}.

ver_parse_role({model_worker_role, Ver = 0, Id, Name, Lev, Sex, Career, Vip, Charge, Active, Score, Rank}) ->
    ver_parse_role({model_worker_role, Ver + 1, Id, Name, Lev, Sex, Career, Vip, Charge, Active, Score, Rank, 0});
ver_parse_role({model_worker_role, Ver = 1, Id, Name, Lev, Sex, Career, Vip, Charge, Active, Score, Rank, Reward}) ->
    ver_parse_role({model_worker_role, Ver + 1, Id, Name, Lev, Sex, Career, Vip, Charge, Active, Score, Rank, Reward, 0});
ver_parse_role(Data = #model_worker_role{}) ->
    Data.

%% 更新劳模信息，参与人数处理都统一放在这里是为了进程重启，也可以同步参与玩家信息
%% update_worker(#model_worker_role{}, Team::integer(), #state{}) -> NewState::#state{}
update_worker(Worker = #model_worker_role{id = Rid}, Team, State = #state{team_a = TeamA, team_b = TeamB, num_a = NumA, num_b = NumB, reward_a = RewardA, reward_b = RewardB}) ->
    {TeamT, NumT} = case Team of
        1 -> {TeamA, NumA};
        2 -> {TeamB, NumB}
    end,
    {NewTeamT, NewNumT} = case lists:keyfind(Rid, #model_worker_role.id, TeamT) of
        #model_worker_role{reward = OldReward, team_reward = OldTeamReward} -> {lists:keyreplace(Rid, #model_worker_role.id, TeamT, Worker#model_worker_role{reward = OldReward, team_reward = OldTeamReward}), NumT};
        _ -> 
            %% 防止奖励重复发，新加入队的角色要记录下队伍已领情况
            TeamReward = case Team of
                1 -> RewardA;
                2 -> RewardB
            end,
            {[Worker#model_worker_role{team_reward = TeamReward} | TeamT], NumT + 1}
    end,
    {NewTeamA, NewTeamB, NewNumA, NewNumB} = case Team of
        1 -> {NewTeamT, TeamB, NewNumT, NumB};
        _ -> {TeamA, NewTeamT, NumA, NewNumT}
    end,
    State#state{team_a = NewTeamA, team_b = NewTeamB, num_a = NewNumA, num_b = NewNumB}.

%% 获取活动时间
get_campaign() ->
    {?model_worker_campaign_id, ?model_worker_start_time, ?model_worker_end_time}.


%% 数据转换
convert(#role{id = Id, name = Name, lev = Lev, vip = #vip{type = Vip}, campaign = #campaign_role{model_worker = #model_worker{score = Score, active = Active, charge = Charge}}, sex = Sex, career = Career}, to_worker) ->
    #model_worker_role{id = Id, name = Name, lev = Lev, vip = Vip, sex = Sex, career = Career, score = Score, active = Active, charge = Charge};
convert(#model_worker_role{id = {Id, SrvId}, name = Name}, to_msg) ->
    notice:role_to_msg({Id, SrvId, Name});
convert(#model_worker_role{id = {Rid, SrvId}, name = Name, lev = Lev, sex = Sex, career = Career, vip = Vip, score = Score, active = Active, charge = Charge}, to_proto) ->
    {Rid, SrvId, Name, Lev, Sex, Career, Vip, Score, Active, (Charge div ?model_worker_charge_to_core) * 5};
convert(#role{campaign = #campaign_role{model_worker = #model_worker{team = Team, score = Score, active = Active, charge = Charge}}}, to_15880) ->
    {Team, Score, Active, (Charge div ?model_worker_charge_to_core) * 5}.

%% 面板信息处理
state_to_panel(Rid, Team, #state{team_a = TeamA, team_b = TeamB, score_a = ScoreA, score_b = ScoreB, num_a = NumA, num_b = NumB, next_refresh = NextRefresh}) ->
    TeamT = case Team of
        0 -> [];
        1 -> TeamA;
        _ -> TeamB
    end,
    Rank = case lists:keyfind(Rid, #model_worker_role.id, TeamT) of
        #model_worker_role{rank = K} -> K;
        _ -> 0
    end,
    Ta = lists:sublist(TeamA, 1, ?model_worker_panel_size),
    Tb = lists:sublist(TeamB, 1, ?model_worker_panel_size),
    {Ta, Tb, ScoreA, ScoreB, NumA, NumB, NextRefresh, Rank}.

%% 面板转换成协议内容
panel_to_proto({TeamA, TeamB, ScoreA, ScoreB, NumA, NumB, NextRefresh, Rank}, Team, Score, Active, Charge) ->
    Now = util:unixtime(),
    {[convert(Ra, to_proto) || Ra <- TeamA], [convert(Rb, to_proto) || Rb <- TeamB], ScoreA, ScoreB, NumA, NumB, max(0, NextRefresh - Now), Rank, Team, Score, Active, (Charge div ?model_worker_charge_to_core) * 5}.

%% 前三名公告
rank_3_notice(Msg) when is_bitstring(Msg) ->
    notice:send(52, Msg).
rank_3_notice([A, B, C | _], Team) ->
    Args = [convert(R, to_msg) || R <- [A, B, C]],
    Msg = case Team of
        a ->
            util:fbin(?L(<<"恭喜【{str, 诛仙组, #ffff00}】的 ~s ~s ~s 在劳模对抗赛中取得该组前三名的优异成绩，分别获得了额外惊喜大礼，赶紧送上祝福吧！">>), Args);
        _ ->
            util:fbin(?L(<<"恭喜【{str, 伏魔组, #ffff00}】的 ~s ~s ~s 在劳模对抗赛中取得该组前三名的优异成绩，分别获得了额外惊喜大礼，赶紧送上祝福吧！">>), Args)
    end,
    rank_3_notice(Msg);
rank_3_notice([A, B], Team) ->
    Args = [convert(R, to_msg) || R <- [A, B]],
    Msg = case Team of
        a ->
            util:fbin(?L(<<"恭喜【{str, 诛仙组, #ffff00}】的 ~s ~s 在劳模对抗赛中取得该组前两名的优异成绩，分别获得了额外惊喜大礼，赶紧送上祝福吧！">>), Args);
        _ ->
            util:fbin(?L(<<"恭喜【{str, 伏魔组, #ffff00}】的 ~s ~s 在劳模对抗赛中取得该组前两名的优异成绩，分别获得了额外惊喜大礼，赶紧送上祝福吧！">>), Args)
    end,
    rank_3_notice(Msg);
rank_3_notice([A], Team) ->
    Args = [convert(A, to_msg)],
    Msg = case Team of
        a ->
            util:fbin(?L(<<"恭喜【{str, 诛仙组, #ffff00}】的 ~s 在劳模对抗赛中取得该组第一名的优异成绩，分别获得了额外惊喜大礼，赶紧送上祝福吧！">>), Args);
        _ ->
            util:fbin(?L(<<"恭喜【{str, 伏魔组, #ffff00}】的 ~s 在劳模对抗赛中取得该组第一名的优异成绩，分别获得了额外惊喜大礼，赶紧送上祝福吧！">>), Args)
    end,
    rank_3_notice(Msg);
rank_3_notice(_, _) ->
    ok.

%% 加入排行号
add_rank_num(_, []) -> [];
add_rank_num(Num, [H | T]) ->
    [H#model_worker_role{rank = Num} | add_rank_num(Num + 1, T)].

%% 状态切换
continue(next_state, StateName, State) ->
    {NewStateName, Timeout} = continue(StateName, State),
    {next_state, NewStateName, State, Timeout};
continue(Reply, StateName, State) ->
    {NewStateName, Timeout} = continue(StateName, State),
    {reply, Reply, NewStateName, State, Timeout}.

continue(StateName, #state{start_time = Start, finish_time = FinishTime}) ->
    Now = util:unixtime(),
    {Name, Timeout} = case StateName of
        idle when Now >= FinishTime -> {idle, infinity};
        idle when Now >= Start -> {idle, 0};
        idle -> {idle, (Start - Now) * 1000};
        active when Now >= FinishTime -> {active, 0};
        active when Now >= Start -> {active, (FinishTime - Now) * 1000};
        _ -> {idle, infinity}
    end,
    ?DEBUG("新状态 ~w, 超时 ~w", [Name, Timeout]),
    {Name, Timeout}.

%% 奖励发放处理
do_reward({per_200, Ave}, R = #model_worker_role{reward = Reward}) when Reward >= Ave ->
    R;
%% 后来加入还没领过奖励的人
do_reward({per_200, Ave}, R = #model_worker_role{id = {Rid, RSrvId}, name = RName, reward = 0, team_reward = TeamReward}) ->
    Reward = max(1, Ave - TeamReward),
    Items = reward_items({per_200, Reward}),
    mail_mgr:deliver({Rid, RSrvId, RName}, {?L(<<"诛仙伏魔劳模对抗活跃奖励">>), ?L(<<"亲爱的仙友，诛仙伏魔劳模对抗活动中，您所在小组平均积分达到200，您也获得了如下额外惊喜奖励，请注意查收！">>), [], Items}),
    R#model_worker_role{reward = Ave};
%% 已经领过奖励的人
do_reward({per_200, Ave}, R = #model_worker_role{id = {Rid, RSrvId}, name = RName, reward = Reward}) ->
    Items = reward_items({per_200, Ave - Reward}),
    mail_mgr:deliver({Rid, RSrvId, RName}, {?L(<<"诛仙伏魔劳模对抗活跃奖励">>), ?L(<<"亲爱的仙友，诛仙伏魔劳模对抗活动中，您所在小组平均积分达到200，您也获得了如下额外惊喜奖励，请注意查收！">>), [], Items}),
    R#model_worker_role{reward = Ave};

%% 活动结束时发的奖励
do_reward(winner, R = #model_worker_role{id = {Rid, RSrvId}, name = RName, score = Score}) when Score >= 250 ->
    do_reward(rank, R),
    Items = reward_items(winner),
    mail_mgr:deliver({Rid, RSrvId, RName}, {?L(<<"诛仙伏魔劳模对抗获胜奖励">>), ?L(<<"亲爱的仙友，诛仙伏魔劳模对抗活动中，您所在小组平均积分领先，因此取得了胜利，您也获得了如下额外惊喜奖励，请注意查收！">>), [], Items});
do_reward(loser, R = #model_worker_role{id = {Rid, RSrvId}, name = RName, score = Score}) when Score >= 250 ->
    do_reward(rank, R),
    Items = reward_items(loser),
    mail_mgr:deliver({Rid, RSrvId, RName}, {?L(<<"诛仙伏魔劳模对抗参与奖励">>), ?L(<<"亲爱的仙友，诛仙伏魔劳模对抗活动中，很遗憾您所在小组平均积分稍微落后，但是您也获得了如下额外奖励，请注意查收！">>), [], Items});
do_reward(rank, #model_worker_role{id = {Rid, RSrvId}, name = RName, rank = Rank}) when Rank < 4 ->
    Items = reward_items(Rank),
    mail_mgr:deliver({Rid, RSrvId, RName}, {?L(<<"诛仙伏魔劳模对抗前三奖励">>), util:fbin(?L(<<"亲爱的仙友，诛仙伏魔劳模对抗活动中，恭喜您在本组取得了第~w名的优异成绩，获得了如下豪华礼包奖励，请注意查收！">>), [Rank]), [], Items});
do_reward(rank, #model_worker_role{id = {Rid, RSrvId}, name = RName, rank = Rank}) when Rank < 11 ->
    Items = reward_items(Rank),
    mail_mgr:deliver({Rid, RSrvId, RName}, {?L(<<"诛仙伏魔劳模对抗前十奖励">>), util:fbin(?L(<<"亲爱的仙友，诛仙伏魔劳模对抗活动中，恭喜您在本组取得了第~w名的优异成绩，获得了精美称号卡奖励，请注意查收！">>), [Rank]), [], Items});
do_reward(rank, #model_worker_role{id = {Rid, RSrvId}, name = RName, rank = Rank}) ->
    Items = reward_items(Rank),
    mail_mgr:deliver({Rid, RSrvId, RName}, {?L(<<"诛仙伏魔劳模对抗个人奖励">>), ?L(<<"亲爱的仙友，诛仙伏魔劳模对抗活动中，您获得了精美称号卡奖励，请注意查收！">>), [], Items});
do_reward(_, _) ->
    ok.

%% 奖励物品配置
reward_items({per_200, Add}) ->
    [{29592, 1, Add}];
reward_items(winner) ->
    [{29587, 1, 1}];
reward_items(loser) ->
    [{29588, 1, 1}];
%% 接下几个根据排名
reward_items(1) ->
    [{29589, 1, 1}, {33260, 1, 1}];
reward_items(2) ->
    [{29590, 1, 1}, {33261, 1, 1}];
reward_items(3) ->
    [{29591, 1, 1}, {33261, 1, 1}];
reward_items(4) ->
    [{33262, 1, 1}];
reward_items(5) ->
    [{33262, 1, 1}];
reward_items(Rank) when Rank < 11 ->
    [{33263, 1, 1}];
reward_items(_Rank) ->
    [{33264, 1, 1}].
