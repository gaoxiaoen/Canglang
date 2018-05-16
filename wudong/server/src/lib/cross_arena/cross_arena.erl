%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 六月 2016 10:44
%%%-------------------------------------------------------------------
-module(cross_arena).

-author("hxming").
-include("cross_arena.hrl").
-include("server.hrl").
-include("daily.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("dungeon.hrl").
-include("goods.hrl").
-include("arena.hrl").
-define(ARENA_PT_WIN, 30).  %%挑战胜利荣誉
-define(ARENA_PT_LOST, 15).%%挑战失败荣誉

%% API
-compile(export_all).

get_arena_info(Pkey) ->
    ?CALL_TIME_OUT(cross_arena_proc:get_server_pid(), {get_arena_info, Pkey}, 2000).

%%竞技场数据
add_new_arena(Player) ->
    if Player#player.lv >= ?CROSS_ARENA_LV ->
        Arena = make_arena(Player, false),
        cross_area:apply(cross_arena_proc, new_arena_data, [Arena]);
        true -> skip
    end.

%%竞技场数据
make_arena(Player, From) ->
    Mb = ?IF_ELSE(From, lib_dict:get(?PROC_STATUS_CROSS_ARENA), #cross_arena_mb{}),
    Sn = config:get_server_num(),
    #cross_arena{
        pid = Player#player.pid,
        pkey = Player#player.key,
        nickname = Player#player.nickname,
        career = Player#player.career,
        sex = Player#player.sex,
        lv = Player#player.lv,
        cbp = Player#player.cbp,
        shadow = shadow_init:init_shadow(Player#player{sn = Sn}),
        time = util:unixtime(),
        times = Mb#cross_arena_mb.times,
        reset_time = Mb#cross_arena_mb.reset_time,
        buy_times = Mb#cross_arena_mb.buy_times,
        in_cd = Mb#cross_arena_mb.in_cd,
        cd = Mb#cross_arena_mb.cd,
        node = node()
    }.

%%获取竞技场列表
check_arena(Node, Sid, Arena, IsScoreReward) ->
    ?CAST(cross_arena_proc:get_server_pid(), {check_arena, Node, Sid, Arena, IsScoreReward}).


%%竞技场信息
check_arena_self(Arena1, IsScoreReward) ->
    Now = util:unixtime(),
    {Arena, RankDict} =
        case cross_arena_init:get_cross_arena(Arena1#cross_arena.pkey) of
            false ->
                new_arena(Arena1);
            Old ->
                refresh_arena(Arena1, Old, Now)
        end,

    ArenaList = cross_arena_util:arena_list(Arena, RankDict, Now),
    RewardTime = arena:get_reward_time(),
    GoodsList = goods:pack_goods(data_cross_arena_daily_reward:get(Arena#cross_arena.rank)),
    Cd = max(0, Arena#cross_arena.cd - Now),
    InCd = ?IF_ELSE(Arena#cross_arena.in_cd == 1 andalso Cd > 0, 1, 0),
    {
        Arena#cross_arena.rank,
        Arena#cross_arena.times,
        Arena#cross_arena.buy_times,
        RewardTime,
        GoodsList,
        InCd,
        Cd,
        IsScoreReward,
        ArenaList
    }.

new_arena(Arena) ->
    RankDict = cross_arena_init:get_cross_rank(),
    Size = dict:size(RankDict),
    Rank = ?IF_ELSE(Size >= ?CROSS_ARENA_RANK_MAX, 0, Size + 1),
    NewArena = Arena#cross_arena{rank = Rank},
    cross_arena_init:set_cross_arena(NewArena),
    cross_arena_load:insert_cross_arena(NewArena),
    NewRankDict = dict:store(Rank, Arena#cross_arena.pkey, RankDict),
    cross_arena_init:set_cross_rank(NewRankDict),
    {NewArena, NewRankDict}.

new_arena_data(Arena) ->
    case cross_arena_init:get_cross_arena(Arena#cross_arena.pkey) of
        false ->
            RankDict = cross_arena_init:get_cross_rank(),
            Size = dict:size(RankDict),
            if Size >= ?CROSS_ARENA_RANK_MAX -> skip;
                true ->
                    Rank = ?IF_ELSE(Size >= ?CROSS_ARENA_RANK_MAX, 0, Size + 1),
                    NewArena = Arena#cross_arena{rank = Rank},
                    cross_arena_init:set_cross_arena(NewArena),
                    cross_arena_load:insert_cross_arena(NewArena),
                    NewRankDict = dict:store(Rank, Arena#cross_arena.pkey, RankDict),
                    cross_arena_init:set_cross_rank(NewRankDict)
            end;
        Old ->
            NewArena = Arena#cross_arena{
                rank = Old#cross_arena.rank,
                vs = Old#cross_arena.vs,
                log = Old#cross_arena.log
            },
            cross_arena_init:set_cross_arena(NewArena)

    end.


refresh_arena(Arena, Old, _Now) ->
    NewArena = Arena#cross_arena{
        rank = Old#cross_arena.rank,
        vs = Old#cross_arena.vs,
        challenge = Old#cross_arena.challenge,
        log = Old#cross_arena.log
    },
    cross_arena_init:set_cross_arena(NewArena),
    RankDict = cross_arena_init:get_cross_rank(),
    {NewArena, RankDict}.


check_refresh(Node, Sid, Pkey) ->
    ?CAST(cross_arena_proc:get_server_pid(), {check_refresh, Node, Sid, Pkey}).


%%竞技场刷新
check_refresh_self(Pkey) ->
    case cross_arena_init:get_cross_arena(Pkey) of
        false -> {2, []};
        Arena ->
            Now = util:unixtime(),
            if Arena#cross_arena.refresh_cd > Now ->
                {9, []};
                true ->
                    RankDict = cross_arena_init:get_cross_rank(),
                    ChallengeList = cross_arena_util:challenge_list(Arena, RankDict),
                    NewArena = Arena#cross_arena{challenge = ChallengeList, refresh_cd = Now + 10},
                    cross_arena_init:set_cross_arena(NewArena),
                    {1, cross_arena_util:pack_challenge(ChallengeList)}
            end
    end.

%%购买次数
buy_times(Player) ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    if Mb#cross_arena_mb.times > 0 ->
        {16, 0, 0, 0};
        true ->
            case data_cross_arena_times:get(Player#player.vip_lv, Mb#cross_arena_mb.buy_times + 1) of
                [] -> {4, Mb#cross_arena_mb.times, Mb#cross_arena_mb.buy_times, 0};
                Base ->
                    case money:is_enough(Player, Base#base_cross_arena_times.gold, gold) of
                        false -> {5, Mb#cross_arena_mb.times, Mb#cross_arena_mb.buy_times, 0};
                        true ->
                            NewMb = Mb#cross_arena_mb{
                                times = Mb#cross_arena_mb.times + Base#base_cross_arena_times.add_times,
                                buy_times = Mb#cross_arena_mb.buy_times + 1,
                                is_change = 1
                            },
                            lib_dict:put(?PROC_STATUS_CROSS_ARENA, NewMb),
                            {1, NewMb#cross_arena_mb.times, NewMb#cross_arena_mb.buy_times, Base#base_cross_arena_times.gold}
                    end
            end
    end.

%%清除CD
clean_cd(Player) ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    Now = util:unixtime(),
    if Mb#cross_arena_mb.in_cd == 1 andalso Mb#cross_arena_mb.cd > Now ->
        case money:is_enough(Player, ?CROSS_ARENA_CLEAN_CD_GOLD, gold) of
            false -> {5, Player};
            true ->
                NewMb = Mb#cross_arena_mb{in_cd = 0, cd = 0, is_change = 1},
                lib_dict:put(?PROC_STATUS_CROSS_ARENA, NewMb),
                NewPlayer = money:add_no_bind_gold(Player, -?CROSS_ARENA_CLEAN_CD_GOLD, 28, 0, 0),
                {1, NewPlayer}
        end;
        true -> {22, Player}
    end.

get_notice_player(_Player) ->
    Mb = lib_dict:get(?PROC_STATUS_CROSS_ARENA),
    Now = util:unixtime(),
    if
        Mb#cross_arena_mb.times =< 0 -> 0;
        Mb#cross_arena_mb.in_cd == 1 andalso Mb#cross_arena_mb.cd > Now -> 0;
        true -> 1
    end.


%%竞技场挑战
check_challenge(Node, Player, Arena, Pkey) ->
    ?CAST(cross_arena_proc:get_server_pid(), {check_challenge, Node, Player, Arena, Pkey}).

check_rank_challenge(Node, Player, Arena, Pkey) ->
    ?CAST(cross_arena_proc:get_server_pid(), {check_rank_challenge, Node, Player, Arena, Pkey}).

%%排行榜挑战
check_challenge_self(Player, ArenaData, Node, Pkey) ->
    case cross_arena_init:get_cross_arena(ArenaData#cross_arena.pkey) of
        false -> 2;
        Arena ->
            case cross_arena_init:get_cross_arena(Pkey) of
                false ->
                    7;
                ArenaAmy ->
                    case lists:keymember(Pkey, #cross_challenge.pkey, Arena#cross_arena.challenge) of
                        false ->
                            7;
                        true ->
                            %%创建对手
                            Shadow = ArenaAmy#cross_arena.shadow,
                            %%创建竞技场挑战副本
                            Info1 = #dun_arena{type = 1, pkey = Player#player.key, nickname = Player#player.nickname, career = Player#player.career, sex = Player#player.sex, avatar = Player#player.avatar, hp_lim = Player#player.attribute#attribute.hp_lim, cbp = Player#player.cbp},
                            Info2 = #dun_arena{type = 0, pkey = Shadow#player.key, nickname = Shadow#player.nickname, career = Shadow#player.career, sex = Shadow#player.sex, avatar = Shadow#player.avatar, hp_lim = Shadow#player.attribute#attribute.hp_lim, cbp = Shadow#player.cbp},
                            {ok, Pid} = cross_arena_room:start(Arena#cross_arena.pkey, Pkey, [Info1, Info2]),
                            [{X1, Y1}, {X2, Y2}, {X3, Y3}] = ?ARENA_POS_LIST,
                            shadow:create_shadow_for_cross_arena(Player#player{attribute = Player#player.attribute#attribute{att_area = 99}}, ?SCENE_ID_CROSS_ARENA, Pid, X1, Y1, 0),
                            shadow:create_shadow_for_cross_arena(Shadow#player{attribute = Shadow#player.attribute#attribute{att_area = 99}}, ?SCENE_ID_CROSS_ARENA, Pid, X2, Y2, 1),
                            server_send:send_node_pid(Node, ArenaData#cross_arena.pid, {enter_cross_arena, Pid, X3, Y3}),
                            1
                    end
            end
    end.

check_rank_challenge_self(Player, ArenaData, Node, Pkey) ->
    case cross_arena_init:get_cross_arena(ArenaData#cross_arena.pkey) of
        false -> 2;
        Arena ->
            case cross_arena_init:get_cross_arena(Pkey) of
                false ->
                    7;
                ArenaAmy ->
                    if
                        Arena#cross_arena.rank > 50 orelse ArenaAmy#cross_arena.rank > 50 -> 8;
                        true ->
                            %%创建对手
                            Shadow = ArenaAmy#cross_arena.shadow,
                            Challenge = cross_arena_util:init_challenge(Shadow, ArenaAmy#cross_arena.rank),
                            cross_arena_init:set_cross_arena(Arena#cross_arena{challenge = [Challenge]}),
                            Info1 = #dun_arena{type = 1, pkey = Player#player.key, nickname = Player#player.nickname, career = Player#player.career, sex = Player#player.sex, avatar = Player#player.avatar, hp_lim = Player#player.attribute#attribute.hp_lim, cbp = Player#player.cbp},
                            Info2 = #dun_arena{type = 0, pkey = Shadow#player.key, nickname = Shadow#player.nickname, career = Shadow#player.career, sex = Shadow#player.sex, avatar = Shadow#player.avatar, hp_lim = Shadow#player.attribute#attribute.hp_lim, cbp = Shadow#player.cbp},
                            %%创建竞技场挑战副本
                            {ok, Pid} = cross_arena_room:start(Arena#cross_arena.pkey, Pkey, [Info1, Info2]),
                            [{X1, Y1}, {X2, Y2}, {X3, Y3}] = ?ARENA_POS_LIST,
                            shadow:create_shadow_for_cross_arena(Player#player{attribute = Player#player.attribute#attribute{att_area = 99}}, ?SCENE_ID_CROSS_ARENA, Pid, X1, Y1, 0),
                            shadow:create_shadow_for_cross_arena(Shadow#player{attribute = Shadow#player.attribute#attribute{att_area = 99}}, ?SCENE_ID_CROSS_ARENA, Pid, X2, Y2, 1),
                            server_send:send_node_pid(Node, ArenaData#cross_arena.pid, {enter_cross_arena, Pid, X3, Y3}),
                            1
                    end
            end
    end.

%%竞技场掉线
logout(Player) ->
    case scene:is_cross_arena_scene(Player#player.scene) of
        false -> skip;
        true ->
            cross_area:apply(cross_arena_room, logout, [Player#player.copy])
    end.

%%挑战结算奖励
reward_msg(Pkey, Ret, RankOld, RankNew, Score) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] -> skip;
        [Online] ->
            GoodsList =
                case Ret of
                    0 -> data_cross_arena_reward:get(2);
                    _ -> data_cross_arena_reward:get(1)
                end,
            {ok, Bin} = pt_231:write(23105, {Ret, RankOld, RankNew, goods:pack_goods(GoodsList)}),
            server_send:send_to_pid(Online#ets_online.pid, Bin),
            Online#ets_online.pid ! {cross_arena_reward, GoodsList, RankNew, Score}
    end.

%%竞技场挑战结果
arena_challenge_ret(PkeyA, PkeyB, Ret) ->
    case cross_arena_init:get_cross_arena(PkeyA) of
        false ->
            skip;
        ArenaA ->
            case lists:keyfind(PkeyB, #cross_challenge.pkey, ArenaA#cross_arena.challenge) of
                false -> skip;
                _Challenge ->
                    case cross_arena_init:get_cross_arena(PkeyB) of
                        false -> skip;
                        ArenaB ->
                            Now = util:unixtime(),
                            case Ret of
                                0 ->
                                    ALog = arena:add_log_att(1, ArenaA#cross_arena.log, Ret, Now, ArenaB#cross_arena.nickname, ArenaA#cross_arena.rank),
                                    NewArenaA = ArenaA#cross_arena{log = ALog, challenge = [], vs = ArenaA#cross_arena.vs + 1},
                                    cross_arena_init:set_cross_arena(NewArenaA),
                                    cross_arena_load:update_cross_arena(NewArenaA),
                                    BLog = arena:add_log_def(1, ArenaB#cross_arena.log, Ret, Now, ArenaA#cross_arena.nickname, ArenaA#cross_arena.rank),
                                    NewArenaB = ArenaB#cross_arena{log = BLog},
                                    cross_arena_init:set_cross_arena(NewArenaB),
                                    center:apply(NewArenaA#cross_arena.node, cross_arena, reward_msg, [PkeyA, Ret, ArenaA#cross_arena.rank, ArenaA#cross_arena.rank, ?ARENA_SCORE_LOSE]),
                                    ok;
                                1 ->
                                    RankDict = cross_arena_init:get_cross_rank(),
                                    %%交换排名
                                    if (ArenaA#cross_arena.rank == 0 orelse ArenaA#cross_arena.rank > ArenaB#cross_arena.rank) andalso ArenaB#cross_arena.rank > 0 ->
                                        ALog = arena:add_log_att(1, ArenaA#cross_arena.log, Ret, Now, ArenaB#cross_arena.nickname, ArenaB#cross_arena.rank),
                                        NewArenaA = ArenaA#cross_arena{log = ALog, rank = ArenaB#cross_arena.rank, challenge = [], vs = ArenaA#cross_arena.vs + 1},
                                        RankDict1 = dict:store(NewArenaA#cross_arena.rank, PkeyA, RankDict),
                                        cross_arena_init:set_cross_arena(NewArenaA),
                                        cross_arena_load:update_cross_arena(NewArenaA),

                                        %%更新被挑战玩家
                                        BLog = arena:add_log_def(1, ArenaB#cross_arena.log, Ret, Now, ArenaA#cross_arena.nickname, ArenaA#cross_arena.rank),
                                        NewArenaB = ArenaB#cross_arena{log = BLog, rank = ArenaA#cross_arena.rank},
                                        RankDict2 = dict:store(NewArenaB#cross_arena.rank, PkeyB, RankDict1),
                                        cross_arena_init:set_cross_arena(NewArenaB),
                                        cross_arena_load:update_cross_arena(NewArenaB),
                                        cross_arena_init:set_cross_rank(RankDict2),

                                        center:apply(NewArenaA#cross_arena.node, cross_arena, reward_msg, [PkeyA, Ret, ArenaA#cross_arena.rank, NewArenaA#cross_arena.rank, ?ARENA_SCORE_WIN]),
                                        notice_msg(ArenaA, ArenaB),
                                        ok;
                                        true ->
                                            ALog = arena:add_log_att(1, ArenaA#cross_arena.log, Ret, Now, ArenaB#cross_arena.nickname, ArenaA#cross_arena.rank),
                                            NewArenaA = ArenaA#cross_arena{log = ALog, challenge = [], vs = ArenaA#cross_arena.vs + 1},
                                            cross_arena_init:set_cross_arena(NewArenaA),
                                            cross_arena_load:update_cross_arena(NewArenaA),
                                            BLog = arena:add_log_def(1, ArenaB#cross_arena.log, Ret, Now, ArenaA#cross_arena.nickname, ArenaB#cross_arena.rank),
                                            NewArenaB = ArenaB#cross_arena{log = BLog},
                                            cross_arena_init:set_cross_arena(NewArenaB),

                                            center:apply(NewArenaA#cross_arena.node, cross_arena, reward_msg, [PkeyA, Ret, ArenaA#cross_arena.rank, ArenaA#cross_arena.rank, ?ARENA_SCORE_WIN]),
                                            ok
                                    end
                            end

                    end
            end
    end.

notice_msg(ArenaA, ArenaB) ->
    if ArenaB#cross_arena.rank == 1 ->
        F = fun(Node) ->
            center:apply(Node, notice_sys, add_notice, [cross_arena_challenge, [ArenaA, ArenaB]])
        end,
        lists:foreach(F, center:get_nodes());
        true ->
            ok
    end.


%%竞技场排名奖励
arena_daily_reward(NowTime) ->
    F = fun({_, Key}) ->
        case cross_arena_init:get_cross_arena(Key) of
            false -> [];
            Arena ->
                case util:get_diff_days(Arena#cross_arena.time, NowTime) =< 3 andalso Arena#cross_arena.vs > 0 andalso Arena#cross_arena.rank > 0 of
                    true -> [{Arena#cross_arena.shadow#player.sn, Arena#cross_arena.pkey, Arena#cross_arena.rank}];
                    false -> []
                end
        end
    end,
    ArenaList = lists:flatmap(F, dict:to_list(cross_arena_init:get_cross_rank())),
    spawn(fun() -> send_daily_reward(ArenaList, 1) end),
    ok.

send_daily_reward([], _) -> ok;
send_daily_reward([{Sn, Pkey, Rank} | T], Count) ->
    daily_reward(Sn, Pkey, Rank),
    if Count >= 500 ->
        util:sleep(1000),
        send_daily_reward(T, 1);
        true ->
            send_daily_reward(T, Count)
    end.

daily_reward(Sn, Pkey, Rank) ->
    case data_cross_arena_daily_reward:get(Rank) of
        [] -> ok;
        GoodsList ->
            {Title, Content} = t_mail:mail_content(44),
            NewContent = io_lib:format(Content, [Rank]),
            case center:get_node_by_sn(Sn) of
                false -> skip;
                Node ->
                    center:apply(Node, cross_arena, daily_mail, [Pkey, Title, NewContent, GoodsList])
            end
    end.


daily_mail(Pkey, Title, Content, GoodsList) ->
    mail:sys_send_mail([Pkey], Title, Content, GoodsList).


%%竞技场日志
arena_log(Pkey) ->
    case cross_arena_init:get_cross_arena(Pkey) of
        false -> [];
        Arena ->
            Now = util:unixtime(),
            [[Now - Time, Msg] || {Time, Msg} <- Arena#cross_arena.log]
    end.

%%竞技场排行榜
arena_rank(Pkey, Page) ->
    RankDict = cross_arena_init:get_cross_rank(),
    MaxPage = min(5, util:ceil(dict:size(RankDict) / 10)),
    NowPage = ?IF_ELSE(Page =< 0 orelse Page > MaxPage, 1, Page),
    F = fun(Rank) ->
        case dict:is_key(Rank, RankDict) of
            false -> [];
            true ->
                Key = dict:fetch(Rank, RankDict),
                case cross_arena_init:get_cross_arena(Key) of
                    false -> [];
                    Arena ->
                        GoodsList = goods:pack_goods(data_cross_arena_daily_reward:get(Rank)),
                        [[Rank, Arena#cross_arena.shadow#player.sn,
                            Arena#cross_arena.pkey, Arena#cross_arena.nickname,
                            Arena#cross_arena.career, Arena#cross_arena.sex,
                            Arena#cross_arena.cbp, Arena#cross_arena.shadow#player.guild#st_guild.guild_name,
                            Arena#cross_arena.shadow#player.avatar,
                            GoodsList]]
                end
        end
    end,
    MyRank = case cross_arena_init:get_cross_arena(Pkey) of
                 false -> 0;
                 ArenaMy -> ArenaMy#cross_arena.rank
             end,
    RankList = lists:flatmap(F, lists:seq((NowPage - 1) * 10 + 1, NowPage * 10)),
    {NowPage, MaxPage, MyRank, RankList}.
