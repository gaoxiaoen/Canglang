%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 一月 2018 14:04
%%%-------------------------------------------------------------------
-module(elite_boss_handle).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("elite_boss.hrl").
-include("scene.hrl").
-include("battle.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2, send_back_mail/3, center_send_reward_to_client/6]).

handle_call({get_enter_info, Pkey, SceneId}, _From, State) ->
    Reply = get_enter_info(State, Pkey, SceneId),
    {reply, Reply, State};

handle_call(_Msg, _from, State) ->
    ?ERR("handle call nomatch ~p~n", [_Msg]),
    {reply, ok, State}.

handle_cast({kill_boss, Mon, Attacker, Klist}, State) ->
    NewState = kill_boss(State, Mon, Attacker, Klist),
    {noreply, NewState};

handle_cast(midnight_refresh, State) ->
    F = fun(#elite_boss{scene_id = SceneId, pid = MonPid}) ->
        case misc:is_process_alive(MonPid) of
            true -> %% 关闭当前还存活的怪物进程
                monster:stop_broadcast(MonPid);
            false ->
                skip
        end,
        scene_agent:clean_scene_area(SceneId, 0)
    end,
    lists:map(F, State#st_elite_boss.elite_boss_list),
    NewState = elite_boss_init:sys_init_data(State),
    {noreply, NewState};

handle_cast({get_boss_data, SceneId, Pkey, Sid}, State) ->
    get_boss_data(State, SceneId, Pkey, Sid),
    {noreply, State};

handle_cast({get_cross_act_info, SnList, Sid, IsRecv, VipDunIdList}, State) ->
    get_cross_act_info(State, SnList, Sid, IsRecv, VipDunIdList),
    {noreply, State};

handle_cast({get_act_into, Sid, IsRecv, VipDunIdList}, State) ->
    get_act_into(State, Sid, IsRecv, VipDunIdList),
    {noreply, State};

handle_cast({check_quit, Pkey, SceneId}, State) ->
    NewState = check_quit(State, Pkey, SceneId),
    {noreply, NewState};

handle_cast({check_enter, Mb, SceneId}, State) ->
    NewState = check_enter(State, Mb, SceneId),
    {noreply, NewState};

handle_cast(_Msg, State) ->
    ?ERR("handle cast nomatch ~p~n", [_Msg]),
    {noreply, State}.

handle_info({clean_scene, SceneId}, State) ->
    scene_agent:clean_scene_area(SceneId, 0),
    %% 剔除玩家退出场景
    NewState = clean_scene_player(State, SceneId),
    {noreply, NewState};

handle_info(make_back, State) ->
    util:cancel_ref([State#st_elite_boss.back_ref]),
    NewState = make_back(State),
    case NewState#st_elite_boss.back_list == [] of
        true -> {noreply, NewState};
        false ->
            Ref = erlang:send_after(?ELITE_BOSS_BACK_TIME * 1000, self(), make_back),
            {noreply, NewState#st_elite_boss{back_ref = Ref}}
    end;

handle_info(make_init_back, State) ->
    NewState = make_init_back(State),
    case NewState#st_elite_boss.back_list == [] of
        true -> {noreply, NewState};
        false ->
            Ref = erlang:send_after(?ELITE_BOSS_BACK_TIME * 1000, self(), make_back),
            {noreply, NewState#st_elite_boss{back_ref = Ref}}
    end;

handle_info(update_boss_notice, State) ->
    util:cancel_ref([State#st_elite_boss.ref]),
    NewRef = erlang:send_after(?ELITE_BOSS_NOTICE_TIME * 1000, self(), update_boss_notice),
    NState = State#st_elite_boss{ref = NewRef},
    NewState = re_cacl_rank(NState),
    spawn(fun() -> update_boss_notice(NewState) end),
    {noreply, NewState};

handle_info(sys_init_data, State) ->
    NewState = elite_boss_init:sys_init_data(State),
    {noreply, NewState};

handle_info({update_elite_boss, Mon, KList}, State) ->
    NewState = update_elite_boss(State, Mon, KList),
    {noreply, NewState};

handle_info({refresh_boss, SceneId}, State) ->
    NewState = refresh_boss(State, SceneId),
    {noreply, NewState};

handle_info(_Msg, State) ->
    ?ERR("handle info nomatch ~p~n", [_Msg]),
    {noreply, State}.

get_enter_info(State, Pkey, SceneId) ->
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    case lists:keyfind(SceneId, #elite_boss.scene_id, EliteBossList) of
        false -> false;
        #elite_boss{damage_list = DamageList, boss_state = BossState} ->
            case BossState == ?ELITE_BOSS_CLOSE of
                true -> 4;
                false ->
                    case lists:keyfind(Pkey, #f_damage.pkey, DamageList) of
                        false -> 0;
                        _EliteBoss -> 1
                    end
            end
    end.

make_back(State) ->
    #st_elite_boss{back_list = SysBackList} = State,
    F = fun({Pkey, Sn, SceneId, _Node, BackList} = R) ->
        case center:get_node_by_sn(Sn) of
            false -> [R];
            GameNode ->
                case scene:is_cross_elite_boss_scene(SceneId) of
                    true ->
                        center:apply(GameNode, ?MODULE, send_back_mail, [Pkey, SceneId, BackList]),
                        elite_boss_load:delete(Pkey, SceneId),
                        [];
                    false ->
                        []
                end
        end
    end,
    NewSysBackList = lists:flatmap(F, SysBackList),
    State#st_elite_boss{back_list = NewSysBackList}.

send_back_mail(Pkey, SceneId, BackList) ->
    {Title, Content} = t_mail:mail_content(163),
    mail:sys_send_mail([Pkey], Title, Content, BackList),
    Sql = io_lib:format("insert into log_elite_boss_back set pkey=~p,scene_id=~p,back_list='~s',`time`=~p",
        [Pkey, SceneId, util:term_to_bitstring(BackList), util:unixtime()]),
    log_proc:log(Sql).

make_init_back(State) ->
    SysBackList =
        case elite_boss_load:load_all() of
            Rows when is_list(Rows) ->
                IsCenter = config:is_center_node(),
                F = fun([Pkey, Node, Sn, SceneId, BackListBin]) ->
                    BackList = util:bitstring_to_term(BackListBin),
                    {Title, Content} = t_mail:mail_content(163),
                    if
                        IsCenter == false ->
                            case scene:is_elite_boss_scene(SceneId) of
                                true ->
                                    mail:sys_send_mail([Pkey], Title, Content, BackList),
                                    elite_boss_load:delete(Pkey, SceneId),
                                    Sql = io_lib:format("insert into log_elite_boss_back set pkey=~p,scene_id=~p,back_list='~s',`time`=~p",
                                        [Pkey, SceneId, util:term_to_bitstring(BackList), util:unixtime()]),
                                    log_proc:log(Sql),
                                    [];
                                false ->
                                    []
                            end;
                        true ->
                            [{Pkey, Sn, SceneId, Node, BackList}]
                    end
                end,
                lists:flatmap(F, Rows);
            _ -> []
        end,
    State#st_elite_boss{back_list = SysBackList}.

re_cacl_rank(State) ->
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    F = fun(#elite_boss{damage_list = DamaList} = E) ->
        Fsort = fun(#f_damage{damage_ratio = D1}, #f_damage{damage_ratio = D2}) ->
            D1 > D2
        end,
        NDamaList = lists:sort(Fsort, DamaList),
        Frank = fun(FDamage, {AccRank, AccList}) ->
            if
                FDamage#f_damage.damage_ratio == 0 -> {AccRank, AccList};
                true -> {AccRank + 1, [FDamage#f_damage{rank = AccRank} | AccList]}
            end
        end,
        {_Count, NewDamaList} = lists:foldl(Frank, {1, []}, NDamaList),
        [E#elite_boss{cache_rank_data = NewDamaList}]
    end,
    NewEliteBossList = lists:flatmap(F, EliteBossList),
    State#st_elite_boss{elite_boss_list = NewEliteBossList}.

get_boss_data(State, SceneId, Pkey, Sid) ->
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    case lists:keyfind(SceneId, #elite_boss.scene_id, EliteBossList) of
        false -> skip;
        EliteBoss ->
            #elite_boss{boss_state = BossState, next_bron_time = CdTime, cache_rank_data = CacheRankData} = EliteBoss,
            case lists:keyfind(Pkey, #f_damage.pkey, CacheRankData) of
                false ->
                    MyRank = 0, MyPercent = 0;
                #f_damage{rank = MyRank0, damage_ratio = MyPercent0} ->
                    MyRank = MyRank0, MyPercent = MyPercent0
            end,
            F = fun(#f_damage{rank = Rank, name = Name, damage_ratio = Percent}) ->
                if
                    Rank =< 10 andalso Rank /= 0 -> [[Rank, Name, Percent]];
                    true -> []
                end
            end,
            Prodata = lists:flatmap(F, CacheRankData),
            {ok, Bin} = pt_445:write(44504, {BossState, max(CdTime - util:unixtime(), 0), MyRank, MyPercent, Prodata}),
            server_send:send_to_sid(Sid, Bin)
    end.

get_cross_act_info(State, SnList, Sid, IsRecv, VipDunIdList) ->
    Now =
        case config:is_debug() of
            true ->
                {M, S, _} = erlang:timestamp(),
                M * 1000000 + S;
            false ->
                util:unixtime()
        end,
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    F = fun(#elite_boss{scene_id = SceneId, boss_state = BossState, next_bron_time = CdTime}) ->
        case scene:is_cross_elite_boss_scene(SceneId) of
            true -> [{SceneId, BossState, max(0, CdTime - Now)}];
            false -> []
        end
    end,
    CrossList = lists:flatmap(F, EliteBossList),
    ProList = util:list_tuple_to_list(SnList ++ CrossList),
    {ok, Bin} = pt_445:write(44501, {IsRecv, ProList, VipDunIdList}),
    server_send:send_to_sid(Sid, Bin).

get_act_into(State, Sid, IsRecv, VipDunIdList) ->
    Now =
        case config:is_debug() of
            true ->
                {M, S, _} = erlang:timestamp(),
                M * 1000000 + S;
            false ->
                util:unixtime()
        end,
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    F = fun(#elite_boss{scene_id = SceneId, boss_state = BossState, next_bron_time = CdTime}) ->
        case scene:is_elite_boss_scene(SceneId) of
            true -> [{SceneId, BossState, max(0, CdTime - Now)}];
            false -> []
        end
    end,
    SnList = lists:flatmap(F, EliteBossList),
    cross_area:apply(elite_boss, get_cross_act_info, [SnList, Sid, IsRecv, VipDunIdList]).

check_quit(State, Pkey, SceneId) ->
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    case lists:keytake(SceneId, #elite_boss.scene_id, EliteBossList) of
        false ->
            State;
        {value, EliteBoss, RestList} ->
            #elite_boss{damage_list = DamageList} = EliteBoss,
            case lists:keytake(Pkey, #f_damage.pkey, DamageList) of
                false ->
                    NewDamageList = DamageList;
                {value, FDamage, Rest} ->
                    NewFDamage =
                        FDamage#f_damage{
                            online = 0,
                            sid = null
                        },
                    NewDamageList = [NewFDamage | Rest],
                    server_send:send_node_pid(NewFDamage#f_damage.node, NewFDamage#f_damage.pid, quit_elite_boss)
            end,
            NewEliteBoss = EliteBoss#elite_boss{damage_list = NewDamageList},
            State#st_elite_boss{elite_boss_list = [NewEliteBoss | RestList]}
    end.

check_enter(State, Mb, SceneId) ->
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    case lists:keytake(SceneId, #elite_boss.scene_id, EliteBossList) of
        false ->
            {ok, Bin} = pt_445:write(44502, {0}),
            server_send:send_to_sid(Mb#f_damage.sid, Bin),
            State;
        {value, EliteBoss, RestList} ->
            #elite_boss{damage_list = DamageList, boss_state = BossState, scene_id = SceneId} = EliteBoss,
            if
                BossState == ?ELITE_BOSS_CLOSE ->
                    {ok, Bin} = pt_445:write(44502, {1}),
                    server_send:send_to_sid(Mb#f_damage.sid, Bin),
                    State;
                true ->
                    case lists:keytake(Mb#f_damage.pkey, #f_damage.pkey, DamageList) of
                        false ->
                            NewDamageList = [Mb | DamageList];
                        {value, FDamage, Rest} ->
                            NewFDamage =
                                FDamage#f_damage{
                                    online = 1,
                                    sid = Mb#f_damage.sid,
                                    pid = Mb#f_damage.pid
                                },
                            NewDamageList = [NewFDamage | Rest]
                    end,
                    NewEliteBoss = EliteBoss#elite_boss{damage_list = NewDamageList},
                    {ok, Bin} = pt_445:write(44502, {1}),
                    server_send:send_to_sid(Mb#f_damage.sid, Bin),
                    #scene{x = X, y = Y} = data_scene:get(SceneId),
                    server_send:send_node_pid(Mb#f_damage.node, Mb#f_damage.pid, {enter_elite_boss, 0, X, Y, SceneId}),
                    State#st_elite_boss{elite_boss_list = [NewEliteBoss | RestList]}
            end
    end.

clean_scene_player(State, SceneId) ->
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    case lists:keytake(SceneId, #elite_boss.scene_id, EliteBossList) of
        false ->
            State;
        {value, EliteBoss, Ret} ->
            #elite_boss{damage_list = DamageList} = EliteBoss,
            F = fun(#f_damage{node = Node, online = Online, pid = Pid} = PP) ->
                if
                    Online == 0 -> PP;
                    true ->
                        server_send:send_node_pid(Node, Pid, quit_elite_boss),
                        PP#f_damage{online = 0}
                end
            end,
            NewDamaList = lists:map(F, DamageList),
            State#st_elite_boss{elite_boss_list = [EliteBoss#elite_boss{damage_list = NewDamaList} | Ret]}
    end.

refresh_boss(State, SceneId) ->
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    case lists:keytake(SceneId, #elite_boss.scene_id, EliteBossList) of
        false -> State;
        {value, EliteBoss, Rest} ->
            #elite_boss{ref = Ref} = EliteBoss,
            util:cancel_ref([Ref]),
            NewEliteBoss = elite_boss_init:init_boss_data(EliteBoss),
            State#st_elite_boss{elite_boss_list = [NewEliteBoss | Rest]}
    end.

kill_boss(OldState, Mon, Attacker, Klist) ->
    OldState99 = update_elite_boss(OldState, Mon, Klist),
    State = re_cacl_rank(OldState99),
    spawn(fun() -> update_boss_notice(State) end),
    #mon{scene = SceneId} = Mon,
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    case lists:keytake(SceneId, #elite_boss.scene_id, EliteBossList) of
        false -> State;
        {value, EliteBoss, Rest} ->
            spawn(fun() -> send_reward_to_client(EliteBoss) end),
            #elite_boss{ref = Ref} = EliteBoss,
            #elite_boss{refresh_cd_time = RefreshCdTime} = data_elite_boss:get_by_scene(SceneId),
            util:cancel_ref([Ref]),
            WeekDay = util:get_day_of_week(),
            {_, {H, Min, _S}} = erlang:localtime(),
            RemainSec = ?ONE_DAY_SECONDS - util:get_seconds_from_midnight(),
            IsCenter = config:is_center_node(),
            if
                IsCenter == true andalso WeekDay == 7 andalso H == 23 andalso Min >= 30 ->
                    CdTime = max(RefreshCdTime, RemainSec);
                true ->
                    CdTime = RefreshCdTime
            end,
            NewRef = erlang:send_after(CdTime * 1000, self(), {refresh_boss, SceneId}),
            spawn(fun() -> notice_cd_time_to_client(CdTime, EliteBoss) end),
            NewEliteBoss =
                EliteBoss#elite_boss{
                    ref = NewRef,
                    kill_pkey = Attacker#attacker.key,
                    boss_state = ?ELITE_BOSS_CLOSE,
                    next_bron_time = util:unixtime() + CdTime
                },
            erlang:send_after(30000, self(), {clean_scene, SceneId}),
            State#st_elite_boss{elite_boss_list = [NewEliteBoss | Rest]}
    end.

notice_cd_time_to_client(CdTime, EliteBoss) ->
    {ok, Bin} = pt_445:write(44506, {CdTime}),
    #elite_boss{damage_list = DamageList} = EliteBoss,
    F = fun(#f_damage{online = Online, sid = Sid}) ->
        if
            Online == 0 -> skip;
            true -> server_send:send_to_sid(Sid, Bin)
        end
    end,
    lists:map(F, DamageList),
    ok.

send_reward_to_client(EliteBoss) ->
    #elite_boss{scene_id = SceneId, boss_id = BossId, damage_list = DamageList, cache_rank_data = RankList} = EliteBoss,
    #mon{name = MonName} = data_mon:get(BossId),
    case scene:is_elite_boss_scene(SceneId) of
        true ->
            F = fun(#f_damage{pkey = Pkey, name = Name}) ->
                case lists:keyfind(Pkey, #f_damage.pkey, RankList) of
                    false -> skip;
                    #f_damage{rank = Rank} ->
                        #elite_boss{
                            rank_reward = RankReward
                        } = data_elite_boss:get_by_scene(SceneId),
                        F0 = fun({RankMin, RankMax, Reward}) ->
                            if
                                Rank >= RankMin andalso Rank =< RankMax -> tuple_to_list(Reward);
                                true -> []
                            end
                        end,
                        RewardList = lists:flatmap(F0, RankReward),
                        {Title, Content0} = t_mail:mail_content(164),
                        Content = io_lib:format(Content0, [Name, MonName, Rank]),
                        ?IF_ELSE(RewardList == [], skip, mail:sys_send_mail([Pkey], Title, Content, RewardList)),
                        Sql = io_lib:format("insert into log_elite_boss_rank set pkey=~p,scene_id=~p,rank=~p,reward='~s',`time`=~p",
                            [Pkey, SceneId, Rank, util:term_to_bitstring(RewardList), util:unixtime()]),
                        log_proc:log(Sql)
                end
            end,
            lists:map(F, DamageList);
        false ->
            F = fun(#f_damage{pkey = Pkey, node = Node, name = Name}) ->
                case lists:keyfind(Pkey, #f_damage.pkey, RankList) of
                    false -> skip;
                    #f_damage{rank = Rank} ->
                        #elite_boss{
                            rank_reward = RankReward,
                            scene_id = SceneId
                        } = data_elite_boss:get_by_scene(SceneId),
                        F0 = fun({RankMin, RankMax, Reward}) ->
                            if
                                Rank >= RankMin andalso Rank =< RankMax -> tuple_to_list(Reward);
                                true -> []
                            end
                        end,
                        RewardList = lists:flatmap(F0, RankReward),
                        center:apply(Node, ?MODULE, center_send_reward_to_client, [Pkey, SceneId, Rank, RewardList, Name, MonName])
                end
            end,
            lists:map(F, DamageList)
    end.

center_send_reward_to_client(Pkey, SceneId, Rank, RewardList, Name, MonName) ->
    {Title, Content0} = t_mail:mail_content(164),
    Content = io_lib:format(Content0, [Name, MonName, Rank]),
    ?IF_ELSE(RewardList == [], skip, mail:sys_send_mail([Pkey], Title, Content, RewardList)),
    Sql = io_lib:format("insert into log_elite_boss_rank set pkey=~p,scene_id=~p,rank=~p,reward='~s',`time`=~p",
        [Pkey, SceneId, Rank, util:term_to_bitstring(RewardList), util:unixtime()]),
    log_proc:log(Sql).

update_boss_notice(State) ->
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    Now = util:unixtime(),
    F = fun(#elite_boss{cache_rank_data = CacheRankData, damage_list = DamageList, next_bron_time = CdTime, boss_state = BossState}) ->
        F0 = fun(#f_damage{rank = Rank, name = Name, damage_ratio = Percent}) ->
            [[Rank, Name, Percent]]
        end,
        L = lists:flatmap(F0, CacheRankData),
        F1 = fun(#f_damage{online = Online, sid = Sid, pkey = Pkey}) ->
            if
                Online == 0 -> skip;
                true ->
                    case lists:keyfind(Pkey, #f_damage.pkey, CacheRankData) of
                        false ->
                            MyRank = 0, MyPercent = 0;
                        #f_damage{rank = MyRank0, damage_ratio = MyPercent0} ->
                            MyRank = MyRank0, MyPercent = MyPercent0
                    end,
                    {ok, Bin} = pt_445:write(44504, {BossState, max(0, CdTime - Now), MyRank, MyPercent, L}),
                    server_send:send_to_sid(Sid, Bin)
            end
        end,
        lists:map(F1, DamageList)
    end,
    lists:map(F, EliteBossList),
    ok.

%% 重新加载个人伤害
update_elite_boss(State, Mon, KList) ->
    #mon{key = MonKey} = Mon,
    #st_elite_boss{elite_boss_list = EliteBossList} = State,
    case lists:keytake(MonKey, #elite_boss.key, EliteBossList) of
        false -> State;
        {value, EliteBoss, Rest} ->
            #elite_boss{damage_list = DamageList, hp_lim = HpLim} = EliteBoss,
            F = fun(#f_damage{online = Online, pkey = Pkey} = FDamage) ->
                if
                    Online == 0 -> [FDamage];
                    true ->
                        case lists:keyfind(Pkey, #st_hatred.key, KList) of
                            false -> [FDamage];
                            StHatred ->
                                [FDamage#f_damage{damage = StHatred#st_hatred.hurt, damage_ratio = round(StHatred#st_hatred.hurt * 1000 / HpLim)}]
                        end
                end
            end,
            NewDamageList = lists:flatmap(F, DamageList),
            NewEliteBoss = EliteBoss#elite_boss{hp = Mon#mon.hp, damage_list = NewDamageList},
            State#st_elite_boss{elite_boss_list = [NewEliteBoss | Rest]}
    end.