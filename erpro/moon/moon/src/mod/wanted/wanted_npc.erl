%%----------------------------------------------------
%% @doc 悬赏boss模块
%%
%% @author mobin
%%----------------------------------------------------
-module(wanted_npc).

-behaviour(gen_server).

-export([
        start_link/2
        ,create_wanted_role/2
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("combat.hrl").
-include("role.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("gain.hrl").
-include("npc.hrl").
-include("wanted.hrl").
-include("wanted_config.hrl").
-include("wanted_lang.hrl").
-include("demon.hrl").
-include("notification.hrl").

-define(map_base_id, 101).
-define(enter_x, 420).
-define(enter_y, 433).

-define(npc_id, 1).
-define(npc_x, 1200).
-define(npc_y, 433).

-record(state, {
        id = 0,
        boss_count = 0,
        benefit_num = 0,
        next_num = 0
    }).


%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
%% @spec start_link() ->
start_link(Id, BossCount) ->
    gen_server:start_link(?MODULE, [Id, BossCount], []).

create_wanted_role(Pid, RoleCount) ->
    gen_server:call(Pid, {create_wanted_role, RoleCount}).

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------
%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([Id, BossCount]) ->
    ?INFO("创建NPC海盗[~w]...", [Id]),
    {ok, #state{id = Id, boss_count = BossCount,
            benefit_num = util:rand(1, 1000), next_num = util:rand(1, 1000)}}.

handle_call({create_wanted_role, RoleCount}, _From, State = #state{id = Id}) ->
    Reply = case get(next_role) of
        Role = #role{id = Rid, name = Name, lev = Lev, career = Career, sex = Sex, looks = Looks} ->
            WantedRole = wanted_data:wanted_role(Id),
            ets:insert(wanted_role, WantedRole#wanted_role{rid = Rid, name = Name, lev = Lev, career = Career, sex = Sex, looks = Looks}),
            wanted_role:start_link(Id, Role, RoleCount);
        undefined ->
            ignore
    end,
    erlang:send_after(5000, self(), stop),
    {reply, Reply, State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({enter, Id, Rid, RolePid}, State) ->
    case ets:lookup(wanted_role_action, Rid) of
        [{Rid, _L}] ->
            ignore;
        _ ->
            ets:insert(wanted_role_action, {Rid, []}),
            ets:insert(wanted_scene_info, {Rid, self(), 0}),
            #wanted_npc{base_id = BaseId} = wanted_data:wanted_npc(Id),
            role:apply(async, RolePid, {fun async_enter_and_trigger/3, [Id, BaseId]})
    end,
    {noreply, State};

handle_info({login_enter, RolePid}, State = #state{id = Id}) ->
    #wanted_npc{base_id = BaseId} = wanted_data:wanted_npc(Id),
    role:apply(async, RolePid, {fun async_enter/3, [Id, BaseId]}),
    {noreply, State};

handle_info({combat_start, Role}, State = #state{id = Id}) ->
    #wanted_npc{base_id = BaseId} = wanted_data:wanted_npc(Id),
    {ok, NpcBase} = npc_data:get(BaseId),
    Npc = npc_convert:base_to_npc(?npc_id, NpcBase, #pos{x = ?npc_x, y = ?npc_y}),
    {ok, Fighter} = npc_convert:do(to_fighter, Npc),
    combat:start(?combat_type_wanted_npc, role_api:fighter_group(Role), [Fighter]),
    {noreply, State};

handle_info({combat_over_leave, #fighter{rid = RoleId, srv_id = SrvId, name = Name, result = Result}},
    State = #state{id = Id, boss_count = BossCount, benefit_num = BenefitNum, next_num = NextNum}) ->

    [WantedNpc = #wanted_npc{kill_count = KillCount, killed_count = KilledCount, base_id = BaseId}] = ets:lookup(wanted_npc, Id),
    case Result of
        ?combat_result_win ->
            case BossCount =:= Id of
                true ->
                    wanted_mgr ! add_kill_count;
                false ->
                    ignore
            end,
            ets:insert(wanted_npc, WantedNpc#wanted_npc{killed_count = KilledCount + 1}),
            choose_winner({RoleId, SrvId}, Name, BenefitNum, NextNum),

            %%勋章处理监听击杀悬赏boss
            case role_api:lookup(by_id, {RoleId, SrvId}, #role.pid) of
                {ok, _, Pid} ->

                    role:apply(async, Pid, {medal, kill_npc_pirate, [BaseId]});
                _ -> ignore
            end;

        _ ->
            ets:insert(wanted_npc, WantedNpc#wanted_npc{kill_count = KillCount + 1})
    end,
    {noreply, State};

handle_info({steal, Id, Rid, ConnPid, RolePid}, State = #state{boss_count = BossCount}) ->
    case update_steal_list(Rid, ConnPid, Id, BossCount) of
        false ->
            ignore;
        true ->
            {StealCoin, StealStone} = case BossCount =:= Id of
                true ->
                    %%最后一个海盗被打死前偷取必定失败
                    case get(prev_benefit) of
                        undefined ->
                            {0, 0};
                        _ ->
                            get_steal_rewards(Id)
                    end;
                false ->
                    get_steal_rewards(Id)
            end,
            Gains = get_wanted_gains(0, StealCoin, StealStone),
            case Gains of
                [] ->
                    ignore;
                _ ->
                    role:apply(async, RolePid, {fun async_gain/3, [Gains, ?steal_award_id]})
            end,
            sys_conn:pack_send(ConnPid, 15002, {StealCoin, StealStone})
    end,
    {noreply, State};

handle_info({exit, Rid, RolePid, Lev}, State = #state{}) ->
    ets:delete(wanted_scene_info, Rid),
    {Exp, Coin, Stone} = case wanted_data:rewards(Lev) of
        undefined ->
            {0, 0, 0};
        Rewards ->
            Rewards
    end,

    Gains = get_wanted_gains(Exp, Coin, Stone),
    role:apply(async, RolePid, {fun async_exit/5, [Gains, Exp, Coin, Stone]}),
    {noreply, State};

handle_info(timeout, State = #state{id = Id}) ->
    case ets:first(wanted_scene_info) of
        '$end_of_table' ->
            #wanted_npc{base_id = BaseId} = wanted_data:wanted_npc(Id),
            {ok, #npc_base{name = NpcName}} = npc_data:get(BaseId),
            Rumor = case get(prev_next_num) of
                undefined ->
                    util:fbin(?wanted_npc_run, [notice:get_npc_msg(BaseId)]);
                _ ->
                    [WantedNpc] = ets:lookup(wanted_npc, Id),
                    #wanted_npc{origin_coin = OriginCoin, origin_stone = OriginStone,
                        kill_count = KillCount} = WantedNpc,
                    #wanted_assets{coin_index = CoinIndex, coin_factor = CoinFactor,
                        stone_index = StoneIndex, stone_factor = StoneFactor} = wanted_data:npc_assets(Id),

                    Coin = OriginCoin + util:floor(math:pow(KillCount, CoinIndex) * CoinFactor),
                    Stone = OriginStone + util:floor(math:pow(KillCount, StoneIndex) * StoneFactor),

                    %%缴获宝藏
                    {BenefitRid, BenefitName, _} = get(prev_benefit),
                    Gains = get_wanted_gains(0, Coin, Stone),
                    award:send(BenefitRid, ?npc_box_award_id, Gains),

                    %%下任海盗
                    #role{id = NextRid, name = NextName} = get(next_role),
                    %%离线消息通知
                    Msg = util:fbin(?wanted_npc_next, [NpcName]),
                    notification:send(offline, NextRid, ?notify_type_wanted, Msg, []),

                    WantedNpc2 = WantedNpc#wanted_npc{benefit_name = BenefitName, next_name = NextName},
                    ets:insert(wanted_npc, WantedNpc2),
                    util:fbin(?wanted_npc_die, [notice:get_npc_msg(BaseId), notice:get_role_msg(BenefitName, BenefitRid),
                            notice:get_role_msg(NextName, NextRid)])
            end,
            %%传闻
            role_group:pack_cast(world, 10932, {7, 1, Rumor});
        _ ->
            erlang:send_after(500, self(), timeout)
    end,
    {noreply, State};

handle_info(stop, State) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    ?DEBUG("收到无效消息:~w", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%------------------------------------------------------
%% 内部实现
%%------------------------------------------------------
update_steal_list(Rid, ConnPid, Id, Count) ->
    {Result, Length} = case ets:lookup(wanted_role_action, Rid) of
        [{Rid, L}] ->
            case lists:member(Id, L) of
                true ->
                    {false, -1};
                false ->
                    L2 = [Id | L],
                    ets:insert(wanted_role_action, {Rid, L2}),
                    {true, length(L2)}
            end;
        _ ->
            ets:insert(wanted_role_action, {Rid, [Id]}),
            {true, 1}
    end,
    case Length < Count of
        true ->
            ignore;
        false ->
            %%推送不可玩
            sys_conn:pack_send(ConnPid, 15006, {?false})
    end,
    Result.

async_enter_and_trigger(Role, Id, NpcBaseId) ->
    {ok, Role1} = async_enter(Role, Id, NpcBaseId),
    %%军团目标监听
    role_listener:guild_kill_pirate(Role1, {}),

    Role2 = role_listener:special_event(Role1, {2009, 1}),
    Role3 = role_listener:special_event(Role2, {3001, 1}),  %% 触发日常任务
    %%勋章处理监听 ->{ok, NRole}
    random_award:pirate(Role3),
    log:log(log_activity_activeness, {<<"缉猎海盗玩法">>, 4, Role3}),
    medal:join_activity(Role3, pirate).


async_enter(Role = #role{pid = RolePid, id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid},
        pos = #pos{map_pid = MapPid, x = X, y = Y}}, Id, NpcBaseId) ->
    map:role_leave(MapPid, RolePid, RoleId, SrvId, X, Y), %% 离开上一个地图
    

    sys_conn:pack_send(ConnPid, 10110, {?map_base_id, ?enter_x, ?enter_y}),
    
    {ok, #npc_base{name = _Name, id = BaseId, nature = _Nature, lev = _Lev, speed = Speed}} = npc_data:get(NpcBaseId),
    sys_conn:pack_send(ConnPid, 10120, {?npc_id, 0, BaseId, Speed, ?npc_x, ?npc_y}),
    %%注册战斗区域
    sys_conn:pack_send(ConnPid, 10140, {3, ?npc_id, <<>>}),

    sys_conn:pack_send(ConnPid, 15001, {Id}),

    Role1 = Role#role{event = ?event_wanted},
    {ok, Role1}.

async_gain(Role = #role{id = Rid}, Gains, AwardId) ->
    case role_gain:do(Gains, Role) of
        {ok, Role2} ->
            log:log(log_coin, {<<"悬赏boss奖励">>, <<"悬赏boss奖励">>, Role, Role2}),
            log:log(log_stone, {<<"悬赏boss奖励">>, <<"悬赏boss奖励">>, Role, Role2}),
            {ok, Role2};
        _ ->
            award:send(Rid, AwardId, Gains),
            {ok, Role}
    end.

get_steal_rewards(Id) ->
%    #wanted_assets{coin = Coin, stone = Stone, odds = Odds} = wanted_data:npc_assets(Id),
%    RandValue = util:rand(1, 10000),
%    case RandValue =< Odds of
%        true ->
%            [WantedNpc = #wanted_npc{origin_coin = OriginCoin, origin_stone = OriginStone}]
%                = ets:lookup(wanted_npc, Id),
%            Percent = get_percent(),
%            StealCoin = erlang:min(OriginCoin, util:ceil(Coin * Percent)),
%            StealStone = erlang:min(OriginStone, util:ceil(Stone * Percent)),
%            ets:insert(wanted_npc, WantedNpc#wanted_npc{origin_coin = OriginCoin - StealCoin,
%                    origin_stone = OriginStone - StealStone}),
%            {StealCoin, StealStone};
%        false ->
%            {0, 0}
%    end.
    %% 改为不扣除海盗身上的宝藏，2014/8/30 qingxuan
    #wanted_assets{coin = Coin, stone = Stone, odds = Odds} = wanted_data:npc_assets(Id),
    RandValue = util:rand(1, 10000),
    case RandValue =< Odds of
        true ->
            Percent = get_percent(),
            StealCoin = util:ceil(Coin * Percent),
            StealStone = util:ceil(Stone * Percent),
            {StealCoin, StealStone};
        false ->
            {0, 0}
    end.    

get_percent() ->
    Percents = wanted_data:wanted_assets_weights(),
    Rands = [Rand || {_, Rand} <- Percents],
    SumRand = lists:sum(Rands),

    RandValue = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    get_percent(RandValue, Percents).
get_percent(RandValue, [{Percent, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
    Percent / 100;
get_percent(RandValue, [{_, Rand} | T]) ->
    get_percent(RandValue - Rand, T).

get_wanted_gains(Exp, Coin, Stone) ->
    Gains = case Exp =:= 0 of
        true ->
            [];
        false ->
            [#gain{label = exp, val = Exp}]
    end,
    Gains1 = case Coin =:= 0 of
        true ->
            Gains;
        false ->
            [#gain{label = coin, val = Coin} | Gains]
    end,
    case Stone =:= 0 of
        true ->
            Gains1;
        false ->
            [#gain{label = item, val = [?stone_base_id, 1, Stone]} | Gains1]
    end.

choose_winner(Rid, Name, BenefitNum, NextNum) ->
    RandValue = util:rand(1, 1000),
    case get(prev_benefit) of
        undefined ->
            put(prev_benefit, {Rid, Name, util:rand(1, BenefitNum)});
        {_, _, BenefitValue} ->
            case RandValue =< BenefitNum andalso RandValue > BenefitValue of
                true ->
                    put(prev_benefit, {Rid, Name, RandValue});
                false ->
                    ignore
            end
    end,
    
    case get(prev_next_num) of
        undefined ->
            case role_api:lookup(by_id, Rid) of
                {ok, _, Role} ->
                    put(prev_next_num, util:rand(1, NextNum)),
                    put(next_role, to_fight_role(Role));
                _ ->
                    ignore
            end;
        NextValue ->
            case RandValue =< NextNum andalso RandValue > NextValue of
                true ->
                    case role_api:lookup(by_id, Rid) of
                        {ok, _, Role} ->
                            put(prev_next_num, RandValue),
                            put(next_role, to_fight_role(Role));
                        _ ->
                            ignore
                    end;
                false ->
                    ignore
            end
    end.

async_exit(Role = #role{link = #link{conn_pid = ConnPid}, pos = #pos{map = MapId, x = X, y = Y}},
    Gains, Exp, Coin, Stone) ->
    case map:role_enter(MapId, X, Y, Role) of
        {false, Reason} ->
            notice:alert(error, Role, Reason),
            {ok};
        {ok, Role2} -> 
            Role3 = Role2#role{event = ?event_no},
            sys_conn:pack_send(ConnPid, 15004, {Exp, Coin, Stone}),
            async_gain(Role3, Gains, ?join_award_id)
    end.

to_fight_role(#role{id = Rid, name = Name, sex = Sex, career = Career, lev = Lev, hp_max = HpMax,
        mp_max = MpMax, attr = Attr, looks = Looks, eqm = Eqm, skill = Skill}) ->
    #role{id = Rid, name = Name, sex = Sex, career = Career, lev = Lev, hp = HpMax, mp = MpMax, hp_max = HpMax,
        mp_max = MpMax, attr = Attr, looks = Looks, skill = Skill, eqm = Eqm, demon = #role_demon{}}.

