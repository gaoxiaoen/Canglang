%%----------------------------------------------------
%% @doc 悬赏boss模块
%%
%% @author mobin
%%----------------------------------------------------
-module(wanted_role).

-behaviour(gen_server).

-export([
        start_link/3
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("combat.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("gain.hrl").
-include("npc.hrl").
-include("wanted.hrl").
-include("wanted_config.hrl").
-include("wanted_lang.hrl").

-define(map_base_id, 101).
-define(enter_x, 420).
-define(enter_y, 433).

-define(npc_x, 1200).
-define(npc_y, 433).

-record(state, {
        id = 0,
        role_count = 0,
        benefit_num = 0
    }).


%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
%% @spec start_link() ->
start_link(Id, Role, RoleCount) ->
    gen_server:start_link(?MODULE, [Id, Role, RoleCount], []).

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------
%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([Id, Role =#role{name = _Name, hp = Hp, hp_max = HpMax, attr = Attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}},
        RoleCount]) ->
    Hp2 = util:ceil(Hp * ?wanted_role_hp_factor),
    HpMax2 = util:ceil(HpMax * ?wanted_role_hp_factor),
    DmgMin2 = util:ceil(DmgMin * ?wanted_role_dmg_factor),
    DmgMax2 = util:ceil(DmgMax * ?wanted_role_dmg_factor),
    ?INFO("创建玩家海盗[~w], Hp[~w], Dmg[~w]...", [_Name, HpMax2, DmgMax2]),
    Role2 = Role#role{hp = Hp2, hp_max = HpMax2, attr = Attr#attr{dmg_min = DmgMin2, dmg_max = DmgMax2}},
    put(role, Role2),
    {ok, #state{id = Id, role_count = RoleCount, benefit_num = util:rand(1, 1000)}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({enter, Id, Rid, RolePid, ConnPid}, State) ->
    #role{id = TargetRid} = get(role),
    case TargetRid =:= Rid of
        true ->
            notice:alert(error, ConnPid, ?MSGID(<<"亲，不要做缉拿自己的傻事啊。">>));
        false ->
            case ets:lookup(wanted_role_action, Rid) of
                [{Rid, _L}] ->
                    ignore;
                _ ->
                    ets:insert(wanted_role_action, {Rid, []}),
                    ets:insert(wanted_scene_info, {Rid, self(), 0}),
                    role:apply(async, RolePid, {fun async_enter_and_trigger/3, [Id, get(role)]})
            end
    end,
    {noreply, State};

handle_info({login_enter, RolePid}, State = #state{id = Id}) ->
    role:apply(async, RolePid, {fun async_enter/3, [Id, get(role)]}),
    {noreply, State};

handle_info({combat_start, Role}, State = #state{}) ->
    Role2 = #role{career = Career} = get(role),
    {ok, CF} = role_convert:do(to_fighter, {Role2#role{pos = #pos{x = ?npc_x, y = ?npc_y}}, clone}),
    #converted_fighter{fighter = Fighter} = CF,
    CF2 = CF#converted_fighter{fighter = Fighter#fighter{special_ai = Career + 10}},
    combat:start(?combat_type_wanted_role, role_api:fighter_group(Role), [CF2]),
    {noreply, State};

handle_info({combat_over_leave, #fighter{rid = RoleId, srv_id = SrvId, name = Name, result = Result}},
    State = #state{id = Id, benefit_num = BenefitNum}) -> 
    [WantedRole = #wanted_role{kill_count = KillCount, killed_count = KilledCount}] = ets:lookup(wanted_role, Id),
    case Result of
        ?combat_result_win ->
            ets:insert(wanted_role, WantedRole#wanted_role{killed_count = KilledCount + 1}),
            choose_winner({RoleId, SrvId}, Name, BenefitNum);
        _ ->
            ets:insert(wanted_role, WantedRole#wanted_role{kill_count = KillCount + 1})
    end,
    {noreply, State};

handle_info({steal, Id, Rid, ConnPid, RolePid}, State = #state{role_count = RoleCount}) ->
    case update_steal_list(Rid, ConnPid, Id, RoleCount) of
        false ->
            ignore;
        true ->
            {StealCoin, StealStone} = get_steal_rewards(Id),
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
            [WantedRole] = ets:lookup(wanted_role, Id),
            #wanted_role{origin_coin = OriginCoin, origin_stone = OriginStone,
                kill_count = KillCount} = WantedRole,
            #wanted_assets{coin_index = CoinIndex, coin_factor = CoinFactor,
                stone_index = StoneIndex, stone_factor = StoneFactor} = wanted_data:role_assets(Id),

            Coin = OriginCoin + util:floor(math:pow(KillCount, CoinIndex) * CoinFactor),
            Stone = OriginStone + util:floor(math:pow(KillCount, StoneIndex) * StoneFactor),

            #role{id = Rid, name = Name} = get(role),

            Rumor = case get(prev_benefit) of
                {BenefitRid, BenefitName, _} ->
                    %%缴获50%宝藏
                    Gains = get_wanted_gains(0, Coin div 2, Stone div 2),
                    award:send(BenefitRid, ?role_box_award_id, Gains),
                    award:send(Rid, ?role_award_id, Gains),
                    
                    WantedRole2 = WantedRole#wanted_role{benefit_name = BenefitName},
                    ets:insert(wanted_role, WantedRole2),
                    util:fbin(?wanted_role_die, [notice:get_role_msg(Name, Rid), notice:get_role_msg(BenefitName, BenefitRid)]);
                _ -> 
                    %%带走所有宝藏
                    AllGains = get_wanted_gains(0, Coin, Stone),
                    award:send(Rid, ?role_award_id, AllGains),
                    util:fbin(?wanted_role_run, [notice:get_role_msg(Name, Rid)])
            end,
            %%传闻
            role_group:pack_cast(world, 10932, {7, 1, Rumor}),

            %%关闭玩家海盗进程
            erlang:send_after(5000, self(), stop);
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

    %%排除自己是海盗
    Count2 = case wanted_mgr:is_wanted_role(Rid) of
        true ->
            Count - 1;
        false ->
            Count
    end,
    case Length < Count2 of
        true ->
            ignore;
        false ->
            %%推送不可玩
            sys_conn:pack_send(ConnPid, 15006, {?false})
    end,
    Result.

async_enter_and_trigger(Role, Id, TargetRole) ->
    {ok, Role1} = async_enter(Role, Id, TargetRole),
    %%军团目标监听
    role_listener:guild_kill_pirate(Role1, {}),

    Role2 = role_listener:special_event(Role1, {3001, 1}),  %% 触发日常任务

    %%勋章处理监听 ->{ok, NRole}
    random_award:pirate(Role2),
    log:log(log_activity_activeness, {<<"缉猎海盗玩法">>, 4, Role2}),
    medal:join_activity(Role2, pirate).

async_enter(Role = #role{pid = RolePid, id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid},
        pos = #pos{map_pid = MapPid, x = X, y = Y}}, Id, Role2 = #role{id = {RoleId2, SrvId2}}) ->
    map:role_leave(MapPid, RolePid, RoleId, SrvId, X, Y), %% 离开上一个地图
    sys_conn:pack_send(ConnPid, 10110, {?map_base_id, ?enter_x, ?enter_y}),
    
    Reply = to_proto_role(Role2),
    sys_conn:pack_send(ConnPid, 10113, Reply),
    %%注册战斗区域
    sys_conn:pack_send(ConnPid, 10140, {3, RoleId2, SrvId2}),
    
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
%    #wanted_assets{coin = Coin, stone = Stone, odds = Odds} = wanted_data:role_assets(Id),
%    RandValue = util:rand(1, 10000),
%    case RandValue =< Odds of
%        true ->
%            [WantedRole = #wanted_role{origin_coin = OriginCoin, origin_stone = OriginStone}]
%                = ets:lookup(wanted_role, Id),
%            Percent = get_percent(),
%            StealCoin = erlang:min(OriginCoin, util:ceil(Coin * Percent)),
%            StealStone = erlang:min(OriginStone, util:ceil(Stone * Percent)),
%            ets:insert(wanted_role, WantedRole#wanted_role{origin_coin = OriginCoin - StealCoin,
%                    origin_stone = OriginStone - StealStone}),
%            {StealCoin, StealStone};
%        false ->
%            {0, 0}
%    end.
    %% 改为不扣除海盗身上的宝藏，2014/8/30 qingxuan
    #wanted_assets{coin = Coin, stone = Stone, odds = Odds} = wanted_data:role_assets(Id),
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

choose_winner(Rid, Name, BenefitNum) ->
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

to_proto_role(#role{id = {RoleId, SrvId}, name = Name, lev = _Lev, sex = Sex,
        career = Career, speed = Speed, looks = Looks}) ->
    {RoleId, SrvId, Name, Speed, 1, ?npc_x, ?npc_y, ?npc_x, ?npc_y, 0, 0, Sex, Career, 0, Looks, []}.
