
%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十一月 2015 16:44
%%%-------------------------------------------------------------------
-module(arena).
-author("hxming").
-include("arena.hrl").
-include("server.hrl").
-include("daily.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("dungeon.hrl").
-include("goods.hrl").
-include("task.hrl").
-include("tips.hrl").

-define(ARENA_PT_WIN, 30).  %%挑战胜利荣誉
-define(ARENA_PT_LOST, 15).%%挑战失败荣誉

%% API
-export([
    cmd_arena/1
    , arena_info/2
    , arena_refresh/1
    , buy_times/1
    , clean_cd/1
    , arena_challenge/2
    , arena_rank_challenge/2
    , arena_challenge_ret/5
    , arena_daily_reward/1
    , get_rank_pkey/3
    , get_arena_rank/1
    , get_arena_for_rank/1
    , reset_arena/0
    , get_notice_state/1
    , arena_log/2
    , update_cd/2
    , get_reward_time/0
    , add_log_att/6
    , add_log_def/6
    , get_rank_list/3
    , get_my_arena/1
    , get_notice_player/1
    , get_notice_player/2
]).

-export([
    check_rank/2
]).

-export([cmd_arena_times/1]).

%获取玩家排名奖励
%%get_max_rank(Pkey, Sid) ->
%%    Ret =
%%        case arena_init:get_arena(Pkey) of
%%            false -> {0, 0, ?ROBOT_NUM, []};
%%            Arena ->
%%                GoodsList = data_arena_daily_reward:get(Arena#arena.rank),
%%                {Arena#arena.max_rank, Arena#arena.rank, ?ROBOT_NUM, goods:pack_goods(GoodsList)}
%%        end,
%%    {ok, Bin} = pt_230:write(23007, Ret),
%%    server_send:send_to_sid(Sid, Bin),
%%    ok.



get_my_arena(Player) ->
    Now = util:unixtime(),
    Arena =
        case arena_init:get_arena(Player#player.key) of
            false ->
                new_arena(Player, Now);
            Are ->
                check_reset(Are, Now)
        end,
    Arena.

%%竞技场信息
arena_info(Player, IsScoreReward) ->
    Now = util:unixtime(),
    Arena =
        case arena_init:get_arena(Player#player.key) of
            false ->
                new_arena(Player, Now);
            Are ->
                check_reset(Are, Now)
        end,

    RankDict = arena_init:get_rank(),
    ArenaList = arena_util:arena_list(Arena, RankDict, Now, Player#player.cbp),
    RewardTime = get_reward_time(),
    GoodsList = goods:pack_goods(data_arena_daily_reward:get(Arena#arena.rank)),
    Cd = max(0, Arena#arena.cd - Now),
    InCd = ?IF_ELSE(Arena#arena.in_cd == 1 andalso Cd > 0, 1, 0),
    Data = {
        Arena#arena.rank,
        Arena#arena.times,
        Arena#arena.buy_times,
        RewardTime,
        GoodsList,
        InCd,
        Cd,
        IsScoreReward,
        ArenaList
    },
    {ok, Bin} = pt_230:write(23001, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%获取奖励时间
get_reward_time() ->
    NowSec = util:get_seconds_from_midnight(),
    RewardTime = ?ARENA_REWARD_TIME,
    if NowSec < RewardTime -> RewardTime - NowSec;
        true ->
            ?ONE_DAY_SECONDS - NowSec + RewardTime
    end.

%%新玩家竞技场数据
new_arena(Player, Now) ->
    Arena = #arena{
        pkey = Player#player.key,
        realm = Player#player.realm,
        career = Player#player.career,
        times = ?ARENA_TIMES,
        type = ?ARENA_TYPE_PLAYER,
        time = Now
    },
    arena_init:set_arena(Arena),
    Arena.

%%次数重置
check_reset(Arena, Now) ->
    case util:is_same_date(Now, Arena#arena.time) of
        false ->
            NewArena = Arena#arena{time = Now, times = ?ARENA_TIMES, buy_times = 0, reset_time = Now},
            arena_init:set_arena(NewArena),
            NewArena;
        true ->
            NewArena = Arena#arena{time = Now, reset_time = Now},
            arena_init:set_arena_new(NewArena),
            NewArena
    end.


%%竞技场刷新
arena_refresh(Player) ->
    Data =
        case arena_init:get_arena(Player#player.key) of
            false -> {2, []};
            Arena ->
                Now = util:unixtime(),
                if Arena#arena.refresh_cd > Now ->
                    {9, []};
                    true ->
                        RankDict = arena_init:get_rank(),
                        ChallengeList = arena_util:challenge_list(Arena, RankDict, refresh, Player#player.cbp),
                        NewArena = Arena#arena{challenge = ChallengeList, refresh_cd = Now + 2},
                        arena_init:set_arena_new(NewArena),
                        {1, arena_util:pack_challenge(ChallengeList)}
                end
        end,
    {ok, Bin} = pt_230:write(23002, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%购买次数
buy_times(Player) ->
    case arena_init:get_arena(Player#player.key) of
        false -> {2, 0, 0, 0};
        Arena ->
            if Arena#arena.times > 0 ->
                {16, 0, 0, 0};
                true ->
                    case data_arena_times:get(Player#player.vip_lv, Arena#arena.buy_times + 1) of
                        [] -> {4, Arena#arena.times, Arena#arena.buy_times, 0};
                        Base ->
                            case money:is_enough(Player, Base#base_arena_times.gold, gold) of
                                false -> {5, Arena#arena.times, Arena#arena.buy_times, 0};
                                true ->
                                    NewArena = Arena#arena{
                                        times = Arena#arena.times + Base#base_arena_times.add_times,
                                        buy_times = Arena#arena.buy_times + 1
                                    },
                                    arena_init:set_arena(NewArena),
                                    {1, NewArena#arena.times, NewArena#arena.buy_times, Base#base_arena_times.gold}
                            end
                    end
            end
    end.

%%清除CD
clean_cd(Player) ->
    case arena_init:get_arena(Player#player.key) of
        false -> {2, 0};
        Arena ->
            Now = util:unixtime(),
            if Arena#arena.in_cd == 1 andalso Arena#arena.cd > Now ->
                case money:is_enough(Player, ?ARENA_CLEAN_CD_GOLD, gold) of
                    false -> {13, 0};
                    true ->
                        NewArena = Arena#arena{in_cd = 0, cd = 0},
                        arena_init:set_arena(NewArena),
                        {1, ?ARENA_CLEAN_CD_GOLD}
                end;
                true ->
                    {12, 0}
            end
    end.


%%竞技场挑战
arena_challenge(Player, Pkey) ->
    IsNormalScene = scene:is_normal_scene(Player#player.scene),
    Ret =
        case arena_init:get_arena(Player#player.key) of
            false -> 2;
            Arena ->
                Now = util:unixtime(),
                if
                    Player#player.key == Pkey -> 11;
                    Arena#arena.times =< 0 -> 6;
                    Arena#arena.in_cd == 1 andalso Arena#arena.cd > Now -> 10;
                    Player#player.convoy_state > 0 -> 14;
                    Player#player.marry#marry.cruise_state > 0 -> 25;
                    Player#player.match_state > 0 -> 24;
                    IsNormalScene == false -> 15;
                    true ->
                        case lists:keyfind(Pkey, #challenge.pkey, Arena#arena.challenge) of
                            false ->
                                7;
                            Challenge ->
                                PlayerList = [dungeon_util:make_dungeon_mb(Player, Now)],
                                %%创建对手
                                Shadow = arena_util:get_player(Challenge#challenge.type, #arena{nickname = Challenge#challenge.nickname, pkey = Challenge#challenge.pkey, career = Challenge#challenge.career, sex = Challenge#challenge.sex, rank = Challenge#challenge.rank}),
                                %%第一次挑战,继承挑战者属性
                                Attribute =
                                    if Arena#arena.wins >= 2 ->
                                        Shadow#player.attribute#attribute{att_area = 99};
                                        true ->
                                            Player#player.attribute#attribute{att_area = 99, hp_lim = round(0.9 * Player#player.attribute#attribute.hp_lim), att = round(0.65 * Player#player.attribute#attribute.att), def = round(0.7 * Player#player.attribute#attribute.def)}
                                    end,
                                ShadowId = ?IF_ELSE(Arena#arena.wins == 0, 0, Shadow#player.shadow#st_shadow.shadow_id),
                                StShadow = Shadow#player.shadow,
                                NewStShadow = StShadow#st_shadow{shadow_id = ShadowId},
                                NewShadow = Shadow#player{attribute = Attribute, shadow = NewStShadow},
                                %%创建竞技场挑战副本
                                MbInfo1 = #dun_arena{type = 1, pkey = Player#player.key, nickname = Player#player.nickname, career = Player#player.career, sex = Player#player.sex, avatar = Player#player.avatar, hp_lim = Player#player.attribute#attribute.hp_lim, cbp = Player#player.cbp},
                                MbInfo2 = #dun_arena{type = 0, pkey = Shadow#player.key, nickname = Shadow#player.nickname, career = Shadow#player.career, sex = Shadow#player.sex, avatar = Shadow#player.avatar, hp_lim = NewShadow#player.attribute#attribute.hp_lim, cbp = Challenge#challenge.cbp},
                                Pid = dungeon:start(PlayerList, ?SCENE_ID_ARENA, Now, [{arena, [MbInfo1, MbInfo2]}]),
                                [{X1, Y1}, {X2, Y2}, {X3, Y3}] = ?ARENA_POS_LIST,
                                shadow:create_shadow_for_arena(Player#player{attribute = Player#player.attribute#attribute{att_area = 99}}, ?SCENE_ID_ARENA, Pid, X1, Y1, 0),
                                shadow:create_shadow_for_arena(NewShadow, ?SCENE_ID_ARENA, Pid, X2, Y2, 1),
                                Player#player.pid ! {change_scene, ?SCENE_ID_ARENA, Pid, X3, Y3, false},
                                act_hi_fan_tian:trigger_finish_api(Player, 7, 1),
                                Player#player.pid ! {task_event, [?TASK_ACT_ARENA, {1}]},
                                1
                        end
                end
        end,
    DungeonTime = dungeon_util:get_dungeon_time(?SCENE_ID_ARENA),
    {ok, Bin} = pt_230:write(23004, {Ret, DungeonTime}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%排行榜挑战
arena_rank_challenge(Player, Pkey) ->
    IsNormalScene = scene:is_normal_scene(Player#player.scene),
    Ret =
        case arena_init:get_arena(Player#player.key) of
            false -> 2;
            Arena ->
                Now = util:unixtime(),
                if
                    Player#player.key == Pkey -> 11;
                    Arena#arena.times =< 0 -> 6;
                    Arena#arena.in_cd == 1 andalso Arena#arena.cd > Now -> 10;
                    Player#player.convoy_state > 0 -> 14;
                    Player#player.marry#marry.cruise_state > 0 -> 25;
                    Player#player.match_state > 0 -> 24;
                    IsNormalScene == false -> 15;
                    Arena#arena.rank == 0 orelse Arena#arena.rank > 50 -> 8;
                    true ->
                        case arena_init:get_arena(Pkey) of
                            false -> 7;
                            ArenaDef ->
                                if ArenaDef#arena.rank == 0 orelse ArenaDef#arena.rank > 50 -> 8;
                                    true ->
                                        PlayerList = [dungeon_util:make_dungeon_mb(Player, Now)],
                                        %%创建对手
                                        Shadow = arena_util:get_player(ArenaDef#arena.type, ArenaDef),
                                        Challenge = arena_util:init_challenge(ArenaDef#arena.type, Shadow, ArenaDef#arena.rank, Shadow#player.cbp),
                                        arena_init:set_arena(Arena#arena{challenge = [Challenge]}),
                                        %%创建竞技场挑战副本
                                        MbInfo1 = #dun_arena{type = 1, pkey = Player#player.key, nickname = Player#player.nickname, career = Player#player.career, sex = Player#player.sex, avatar = Player#player.avatar, hp_lim = Player#player.attribute#attribute.hp_lim, cbp = Player#player.cbp},
                                        MbInfo2 = #dun_arena{type = 0, pkey = Shadow#player.key, nickname = Shadow#player.nickname, career = Shadow#player.career, sex = Shadow#player.sex, avatar = Shadow#player.avatar, hp_lim = Shadow#player.attribute#attribute.hp_lim, cbp = Shadow#player.cbp},
                                        Pid = dungeon:start(PlayerList, ?SCENE_ID_ARENA, Now, [{arena, [MbInfo1, MbInfo2]}]),
                                        [{X1, Y1}, {X2, Y2}, {X3, Y3}] = ?ARENA_POS_LIST,
                                        shadow:create_shadow_for_arena(Player#player{attribute = Player#player.attribute#attribute{att_area = 99}}, ?SCENE_ID_ARENA, Pid, X1, Y1, 0),
                                        shadow:create_shadow_for_arena(Shadow#player{attribute = Shadow#player.attribute#attribute{att_area = 99}}, ?SCENE_ID_ARENA, Pid, X2, Y2, 1),
                                        Player#player.pid ! {change_scene, ?SCENE_ID_ARENA, Pid, X3, Y3, false},
                                        Player#player.pid ! {task_event, [?TASK_ACT_ARENA, {1}]},
                                        act_hi_fan_tian:trigger_finish_api(Player, 7, 1),
                                        1
                                end
                        end
                end
        end,
    DungeonTime = dungeon_util:get_dungeon_time(?SCENE_ID_ARENA),
    {ok, Bin} = pt_230:write(23011, {Ret, DungeonTime}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%检查排名是否在可挑战范围
check_rank(MyRank, RankId) ->
    if MyRank == 1 ->
        lists:member(RankId, lists:seq(2, 19));
        true ->
            NewMyRank =
                if MyRank == 0 ->
                    ?ROBOT_NUM;
                    true -> MyRank
                end,
            Rank = round(NewMyRank * 0.3),
            RankId >= Rank andalso RankId < NewMyRank
    end.

%%竞技场挑战结果
arena_challenge_ret(PkeyA, NicknameA, PkeyB, NicknameB, Ret) ->
    case arena_init:get_arena(PkeyA) of
        false ->
            skip;
        ArenaA ->
            case lists:keyfind(PkeyB, #challenge.pkey, ArenaA#arena.challenge) of
                false ->
                    skip;
                _Challenge ->
                    case arena_init:get_arena(PkeyB) of
                        false ->
                            skip;
                        ArenaB ->
                            Now = util:unixtime(),
                            {Cd, InCd} = update_cd(ArenaA#arena.cd, Now),
                            case Ret of
                                0 ->
                                    ALog = add_log_att(ArenaA#arena.type, ArenaA#arena.log, Ret, Now, NicknameB, ArenaA#arena.rank),
                                    NewArenaA = ArenaA#arena{challenge = [], cd = Cd, in_cd = InCd, time = Now, times = ArenaA#arena.times - 1, log = ALog, combo = 0},
                                    arena_init:set_arena(NewArenaA),
                                    BLog = add_log_def(ArenaB#arena.type, ArenaB#arena.log, Ret, Now, NicknameA, ArenaA#arena.rank),
                                    NewArenaB = ArenaB#arena{log = BLog},
                                    arena_init:set_arena_new(NewArenaB),
                                    GoodsList = data_arena_reward:get(2),
                                    case player_util:get_player_online(ArenaA#arena.pkey) of
                                        [] -> skip;
                                        Online ->
                                            Online#ets_online.pid ! {arena_reward, Ret, GoodsList, NewArenaA#arena.rank, NewArenaA#arena.wins, NewArenaA#arena.combo, ?ARENA_SCORE_LOSE}
                                    end,
                                    {ok, Bin} = pt_230:write(23005, {Ret, 0, 0, goods:pack_goods(GoodsList)}),
                                    server_send:send_to_key(PkeyA, Bin),
                                    arena_load:log_arena(PkeyA, Ret, ArenaA#arena.rank, ArenaA#arena.rank, util:unixtime()),
                                    ok;
                                1 ->
                                    %%7天目标 胜利
                                    OnLinePid =
                                        case player_util:get_player_online(ArenaA#arena.pkey) of
                                            [] -> skip;
                                            Online ->
                                                Online#ets_online.pid ! {m_task_trigger, 1, 1},
                                                Online#ets_online.pid
                                        end,
                                    RankDict = arena_init:get_rank(),
                                    %%交换排名
                                    if (ArenaA#arena.rank == 0 orelse ArenaA#arena.rank > ArenaB#arena.rank) andalso ArenaB#arena.rank > 0 ->
                                        MaxRank = ?IF_ELSE(ArenaA#arena.max_rank == 0, ArenaB#arena.rank, min(ArenaA#arena.max_rank, ArenaB#arena.rank)),
                                        ALog = add_log_att(ArenaA#arena.type, ArenaA#arena.log, Ret, Now, NicknameB, ArenaB#arena.rank),
                                        NewArenaA = ArenaA#arena{log = ALog, in_cd = InCd, cd = Cd, wins = ArenaA#arena.wins + 1, combo = ArenaA#arena.combo + 1, rank = ArenaB#arena.rank, challenge = [], time = Now, times = ArenaA#arena.times - 1, max_rank = MaxRank},
                                        RankDict1 = dict:store(NewArenaA#arena.rank, PkeyA, RankDict),
                                        arena_init:set_arena(NewArenaA),

                                        %%更新被挑战玩家
                                        BLog = add_log_def(ArenaB#arena.type, ArenaB#arena.log, Ret, Now, NicknameA, ArenaA#arena.rank),
                                        NewArenaB = ArenaB#arena{rank = ArenaA#arena.rank, log = BLog},
                                        RankDict2 = dict:store(NewArenaB#arena.rank, PkeyB, RankDict1),
                                        arena_init:set_arena(NewArenaB),

                                        arena_init:set_rank(RankDict2),

                                        GoodsList = data_arena_reward:get(1),
                                        {ok, Bin} = pt_230:write(23005, {Ret, ArenaA#arena.rank, NewArenaA#arena.rank, goods:pack_goods(GoodsList)}),
                                        server_send:send_to_key(PkeyA, Bin),
                                        %% 排名
                                        case OnLinePid of
                                            skip -> skip;
                                            _ ->
                                                OnLinePid ! {arena_reward, Ret, GoodsList, NewArenaA#arena.rank, NewArenaA#arena.wins, NewArenaA#arena.combo, ?ARENA_SCORE_WIN}
                                        end,
                                        ?DO_IF(ArenaB#arena.rank == 1, notice_sys:add_notice(arena_challenge, [ArenaA, ArenaB])),
                                        arena_load:log_arena(PkeyA, Ret, ArenaA#arena.rank, ArenaB#arena.rank, util:unixtime()),
                                        ok;
                                        true ->
                                            ALog = add_log_att(ArenaA#arena.type, ArenaA#arena.log, Ret, Now, NicknameB, ArenaA#arena.rank),
                                            NewArenaA = ArenaA#arena{log = ALog, cd = Cd, in_cd = InCd, wins = ArenaA#arena.wins + 1, combo = ArenaA#arena.combo + 1, challenge = [], time = Now, times = ArenaA#arena.times - 1},
                                            arena_init:set_arena(NewArenaA),
                                            BLog = add_log_def(ArenaB#arena.type, ArenaB#arena.log, Ret, Now, NicknameA, ArenaB#arena.rank),
                                            NewArenaB = ArenaB#arena{log = BLog},
                                            arena_init:set_arena_new(NewArenaB),
                                            GoodsList = data_arena_reward:get(1),
                                            case OnLinePid of
                                                skip -> skip;
                                                _ ->
                                                    OnLinePid ! {arena_reward, Ret, GoodsList, NewArenaA#arena.rank, NewArenaA#arena.wins, NewArenaA#arena.combo, ?ARENA_SCORE_WIN}
                                            end,
                                            {ok, Bin} = pt_230:write(23005, {Ret, ArenaA#arena.rank, ArenaA#arena.rank, goods:pack_goods(GoodsList)}),
                                            server_send:send_to_key(PkeyA, Bin),
                                            arena_load:log_arena(PkeyA, Ret, ArenaA#arena.rank, ArenaA#arena.rank, util:unixtime()),
                                            ok
                                    end
                            end

                    end
            end
    end.

%%更新CD
update_cd(Cd, Now) ->
    if Cd < Now ->
        {Now + ?ARENA_CD, 0};
        true ->
            NewCd = Cd + ?ARENA_CD,
            if NewCd - Now > ?ARENA_CD_LIM ->
                {NewCd, 1};
                true -> {NewCd, 0}
            end
    end.

%%增加日志
%%你挑战了xx成功/失败了,排名不变 / 上升//下降到底X位
add_log_att(Type, Log, Ret, Now, NickName, Rank) ->
    if Type == ?ARENA_TYPE_PLAYER ->
        Msg =
            case Ret of
                0 ->
                    io_lib:format(?T("你挑战了[#$a type=1 color=1]~s[#$/a]失败了,排名不变"), [NickName]);
                _ ->
                    io_lib:format(?T("你挑战了[#$a type=1 color=1]~s[#$/a]成功了,上升第[#$a type=1 color=1]~p[#$/a]位"), [NickName, Rank])
            end,
        lists:sublist([{Now, Msg} | Log], 10);
        true -> Log
    end.
add_log_def(Type, Log, Ret, Now, NickName, Rank) ->
    if Type == ?ARENA_TYPE_PLAYER ->
        Msg =
            case Ret of
                1 ->
                    io_lib:format(?T("你防守了[#$a type=1 color=1]~s[#$/a]成功了,排名不变"), [NickName]);
                _ ->
                    NewRank = ?IF_ELSE(Rank == 0, ?ROBOT_NUM, Rank),
                    io_lib:format(?T("你防守了[#$a type=1 color=5]~s[#$/a]失败了,排名下降到第[#$a type=1 color=5]~p[#$/a]位"), [NickName, NewRank])
            end,
        lists:sublist([{Now, Msg} | Log], 10);
        true -> Log
    end.


%%challenge_mail(Challenge, ArenaA, PkeyB) ->
%%    if Challenge#challenge.type == ?ARENA_TYPE_PLAYER ->
%%        NewContent =
%%            if ArenaA#arena.rank == 0 ->
%%                {Title, Content} = t_mail:mail_content(37),
%%                io_lib:format(Content, [shadow_proc:get_name(ArenaA#arena.pkey)]);
%%                true ->
%%                    {Title, Content} = t_mail:mail_content(5),
%%                    io_lib:format(Content, [shadow_proc:get_name(ArenaA#arena.pkey), ArenaA#arena.rank])
%%            end,
%%        mail:sys_send_mail([PkeyB], Title, NewContent);
%%        true -> skip
%%    end.


%%竞技场每日奖励
arena_daily_reward(NowTime) ->
    F = fun({_, Arena}) ->
        case is_record(Arena, arena) of
            true ->
                if Arena#arena.type == ?ARENA_TYPE_PLAYER andalso Arena#arena.rank > 0 ->
                    case util:get_diff_days(Arena#arena.time, NowTime) =< 3 of
                        true -> [Arena];
                        false -> []
                    end;
                    true -> []
                end;
            false -> []
        end
    end,
    ArenaList = lists:flatmap(F, get()),
    spawn(fun() -> send_daily_reward(ArenaList, 1) end),
    ok.

send_daily_reward([], _) -> ok;
send_daily_reward([Arena | T], Count) ->
    daily_reward(Arena),
    if Count >= 500 ->
        util:sleep(1000),
        send_daily_reward(T, 1);
        true ->
            send_daily_reward(T, Count)
    end.

daily_reward(Arena) ->
    case data_arena_daily_reward:get(Arena#arena.rank) of
        [] -> skip;
        GoodsList ->
            {Title, Content} = t_mail:mail_content(1),
            NewContent = io_lib:format(Content, [Arena#arena.rank]),
            mail:sys_send_mail([Arena#arena.pkey], Title, NewContent, GoodsList),
            ok
    end.


%%获取范围排名的玩家
get_rank_pkey(Pkey, MinRank, MaxRank) ->
    case arena_init:get_arena(Pkey) of
        false -> [];
        Arena ->
            if Arena#arena.rank == 0 -> [];
                true ->
                    RankIds = lists:seq(MaxRank, MinRank),
                    RankDict = arena_init:get_rank(),
                    F = fun(Rank) ->
                        case dict:is_key(Rank, RankDict) of
                            false -> [];
                            true ->
                                Key = dict:fetch(Rank, RankDict),
                                A = arena_init:get_arena(Key),
                                if Key == Pkey -> [];
                                    A#arena.type == 1 ->
                                        [Key];
                                    true -> []
                                end
                        end
                    end,
                    lists:flatmap(F, RankIds)
            end

    end.

%%获取玩家排名
get_arena_rank(KeyList) ->
    F = fun(Key) ->
        case arena_init:get_arena(Key) of
            false -> {Key, 0};
            Arena ->
                {Key, Arena#arena.rank, Arena#arena.max_rank}
        end
    end,
    lists:map(F, KeyList).

%%竞技场排行榜
get_arena_for_rank(Num) ->
    RankDict = arena_init:get_rank(),
    F = fun(Rank) ->
        {Type, Player} =
            case dict:is_key(Rank, RankDict) of
                false ->
                    P = arena_util:get_player(?ARENA_TYPE_ROBOT, #arena{pkey = misc:unique_key_auto(), career = arena_util:arena_career(Rank), sex = player_util:rand_sex(), rank = Rank}),
                    {?ARENA_TYPE_ROBOT, P};
                true ->
                    Pkey = dict:fetch(Rank, RankDict),
                    case arena_init:get_arena(Pkey) of
                        false ->
                            P = arena_util:get_player(?ARENA_TYPE_ROBOT, #arena{pkey = misc:unique_key_auto(), career = arena_util:arena_career(Rank), sex = player_util:rand_sex(), rank = Rank}),
                            {?ARENA_TYPE_ROBOT, P};
                        Arena ->
                            P = arena_util:get_player(Arena#arena.type, Arena),
                            {Arena#arena.type, P}
                    end
            end,
        [
            Type, Player#player.key, Rank, Player#player.pf, Player#player.sn, Player#player.lv, Player#player.career, Player#player.nickname, Player#player.realm, Player#player.vip_lv, Player#player.cbp
        ]
    end,
    lists:map(F, lists:seq(1, Num)).


cmd_arena(Player) ->
    arena_proc:apply_info(arena, cmd_arena_times, [Player]),
    ok.

cmd_arena_times([Player]) ->
    case arena_init:get_arena(Player#player.key) of
        false -> ok;
        Arena ->
            NewArena = Arena#arena{times = ?ARENA_TIMES},
            arena_init:set_arena(NewArena),
            ok
    end.

reset_arena() ->
    arena_proc:get_server_pid() ! {load_arena},
    ok.

get_notice_state(Player) ->
    case ?CALL(arena_proc:get_server_pid(), {get_arena_info, Player#player.key}) of
        false ->
            {1, [{time, 10}]};
        Are when Are#arena.times > 0 ->
            {1, [{time, Are#arena.times}]};
        _ ->
            {0, [{time, 0}]}
    end.

get_notice_player(Player) ->
    ?CAST(arena_proc:get_server_pid(), {get_notice_player, Player, Player#player.key}).

get_notice_player(Player, _Pkey) ->
    Ret =
        case arena_init:get_arena(Player#player.key) of
            false -> 0;
            Arena ->
                Now = util:unixtime(),
                if
                    Arena#arena.times =< 0 -> 0;
                    Arena#arena.in_cd == 1 andalso Arena#arena.cd > Now -> 0;
                    true -> 1
                end
        end,
    activity:send_act_state(Player, {[[105, Ret] ++ activity:pack_act_state([])]}).


%%查看竞技场日志
arena_log(Pkey, Sid) ->
    Data =
        case arena_init:get_arena(Pkey) of
            false -> [];
            Arena ->
                Now = util:unixtime(),
                [[Now - Time, Msg] || {Time, Msg} <- Arena#arena.log]
        end,
    {ok, Bin} = pt_230:write(23007, {Data}),
    server_send:send_to_sid(Sid, Bin).


%%排行榜
get_rank_list(Key, Sid, Page) ->
    RankDict = arena_init:get_rank(),
    MaxPage = min(5, util:ceil(dict:size(RankDict) / 10)),
    NowPage = ?IF_ELSE(Page =< 0 orelse Page > MaxPage, 1, Page),
    F = fun(Rank) ->
        case dict:is_key(Rank, RankDict) of
            false ->
                [];
            true ->
                Pkey = dict:fetch(Rank, RankDict),
                case arena_init:get_arena(Pkey) of
                    false ->
                        Player = arena_util:get_player(?ARENA_TYPE_ROBOT, #arena{pkey = misc:unique_key_auto(), career = arena_util:arena_career(Rank), sex = player_util:rand_sex(), rank = Rank}),
                        GoodsList = goods:pack_goods(data_arena_daily_reward:get(Rank)),
                        [[
                            Rank, ?ARENA_TYPE_ROBOT, Player#player.key, Player#player.nickname, Player#player.career, Player#player.sex, Player#player.cbp, Player#player.guild#st_guild.guild_name, Player#player.avatar, GoodsList
                        ]];
                    Arena ->
                        Player = arena_util:get_player(Arena#arena.type, Arena),
                        GoodsList = goods:pack_goods(data_arena_daily_reward:get(Rank)),
                        [[
                            Rank, Arena#arena.type, Player#player.key, Player#player.nickname, Player#player.career, Player#player.sex, Player#player.cbp, Player#player.guild#st_guild.guild_name, Player#player.avatar, GoodsList
                        ]]
                end
        end
    end,
    RankList = lists:flatmap(F, lists:seq((NowPage - 1) * 10 + 1, NowPage * 10)),
    MyRank = case arena_init:get_arena(Key) of
                 [] -> 0;
                 MyArena -> MyArena#arena.rank
             end,
    Data = {NowPage, MaxPage, MyRank, RankList},
    {ok, Bin} = pt_230:write(23010, Data),
    server_send:send_to_sid(Sid, Bin),
    ok.


%%%%查询是否有排名奖励可领取
%%check_rank_reward(Arena) ->
%%    F = fun(Id) ->
%%        case lists:member(Id, Arena#arena.rank_reward) of
%%            true -> false;
%%            false ->
%%                [_MaxRank, MinRank, _] = data_arena_rank_reward:get(Id),
%%                if
%%                    Arena#arena.max_rank > MinRank -> false;
%%                    true ->
%%                        true
%%                end
%%        end
%%        end,
%%    if Arena#arena.max_rank == 0 -> 0;
%%        true ->
%%            case lists:any(F, data_arena_rank_reward:ids()) of
%%                true -> 1;
%%                false -> 0
%%            end
%%    end.
%%
%%
%%%% 获取排名奖励列表
%%get_rank_reward_list(Pkey, Sid) ->
%%    Data =
%%        case arena_init:get_arena(Pkey) of
%%            false -> {0, []};
%%            Arena ->
%%                F = fun(Id) ->
%%                    [_MaxRank, MinRank, GoodsList] = data_arena_rank_reward:get(Id),
%%                    State =
%%                        if Arena#arena.max_rank == 0 -> 0;
%%                            true ->
%%                                case lists:member(Id, Arena#arena.rank_reward) of
%%                                    true -> 2;
%%                                    false ->
%%                                        if Arena#arena.max_rank > MinRank -> 0;
%%                                            true ->
%%                                                1
%%                                        end
%%                                end
%%                        end,
%%                    [Id, MinRank, State, [tuple_to_list(Item) || Item <- GoodsList]]
%%                    end,
%%                RewardList = lists:map(F, data_arena_rank_reward:ids()),
%%                {Arena#arena.max_rank, RewardList}
%%        end,
%%    {ok, Bin} = pt_230:write(23010, Data),
%%    server_send:send_to_sid(Sid, Bin).
%%
%%rank_reward(Pkey, Id) ->
%%    case arena_init:get_arena(Pkey) of
%%        false -> {2, [], 0};
%%        Arena ->
%%            case lists:member(Id, Arena#arena.rank_reward) of
%%                true ->
%%                    IsReward = check_rank_reward(Arena),
%%                    {23, [], IsReward};
%%                false ->
%%                    case data_arena_rank_reward:get(Id) of
%%                        [] ->
%%                            IsReward = check_rank_reward(Arena),
%%                            {21, [], IsReward};
%%                        [_MaxRank, MinRank, GoodsList] ->
%%                            if Arena#arena.max_rank == 0 orelse Arena#arena.max_rank > MinRank ->
%%                                IsReward = check_rank_reward(Arena),
%%                                {22, [], IsReward};
%%                                true ->
%%                                    NewArena = Arena#arena{rank_reward = [Id | Arena#arena.rank_reward]},
%%                                    arena_init:set_arena(NewArena),
%%%%                                    arena_load:replace_arena(NewArena),
%%                                    IsReward = check_rank_reward(NewArena),
%%                                    {1, GoodsList, IsReward}
%%                            end
%%                    end
%%            end
%%    end.