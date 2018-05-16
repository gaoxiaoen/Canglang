%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 六月 2016 19:07
%%%-------------------------------------------------------------------
-module(cross_elite).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("cross_elite.hrl").
-include("scene.hrl").
-include("achieve.hrl").
-include("designation.hrl").

%% API
-compile(export_all).

%%检查活动状态
check_state(Node, Sid, Now) ->
    ?CAST(cross_elite_proc:get_server_pid(), {check_state, Node, Sid, Now}),
    ok.

%%比赛信息
check_info() ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    DailyPtState =
        case lists:member(0, StElite#st_elite.reward) of
            true -> 0;
            false -> 1
        end,
    BaseScore = data_cross_elite:get(StElite#st_elite.lv),
    Score = StElite#st_elite.score,
    ScoreLim = BaseScore#base_cross_elite.score,
    F = fun(Id) ->
        Base = data_cross_elite_daily_reward:get(Id),
        TimesState =
            if StElite#st_elite.times < Base#base_cross_elite_daily.times -> 0;
                true ->
                    case lists:member(Id, StElite#st_elite.reward) of
                        false -> 1;
                        true -> 2
                    end
            end,
        [Id, TimesState]
        end,
    RewardList = lists:map(F, data_cross_elite_daily_reward:ids()),
    {StElite#st_elite.lv, Score, ScoreLim, DailyPtState, StElite#st_elite.times, StElite#st_elite.daily_score, RewardList}.

%%获取积分
get_score() ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    {StElite#st_elite.lv, StElite#st_elite.daily_score}.

%%匹配玩家
check_match(Mb) ->
    ?CAST(cross_elite_proc:get_server_pid(), {check_match, Mb}),
    ok.

%%取消匹配
check_cancel(Node, Pkey, Sid) ->
    ?CAST(cross_elite_proc:get_server_pid(), {check_cancel, Node, Pkey, Sid}),
    ok.
check_cancel_only(Pkey) ->
    ?CAST(cross_elite_proc:get_server_pid(), {check_cancel_only, Pkey}),
    ok.

%%离线
check_quit(Pkey) ->
    ?CAST(cross_elite_proc:get_server_pid(), {check_quit, Pkey}),
    ok.

%%排行榜
check_rank(Node, Pkey, Sid, Page) ->
    ?CAST(cross_elite_proc:get_server_pid(), {check_rank, Node, Pkey, Sid, Page}),
    ok.

%%进入副本,活动取消匹配
check_cancel_match(Pkey) ->
    case ets:lookup(?ETS_CROSS_ELITE, Pkey) of
        [] -> skip;
        _ ->
            cross_area:apply(cross_elite, check_cancel_only, [Pkey])
    end,
    ok.

%%玩家掉线
logout(Player) ->
    case ets:lookup(?ETS_CROSS_ELITE, Player#player.key) of
        [] -> skip;
        _ ->
            cross_area:apply(cross_elite, check_quit, [Player#player.key])
    end.

%%退出
quit(Copy, Pkey) ->
        catch Copy ! {logout, Pkey}.

%%查询挑战信息
check_vs_info(Pkey, Copy) ->
        catch Copy ! {vs_info, Pkey}.

%%玩家死亡
role_die(Copy, DieKey) ->
    cross_area:apply(cross_elite, check_die, [Copy, DieKey]),
    ok.

check_die(Copy, DieKey) ->
        catch Copy ! {die, DieKey}.

shadow_die(Mon) ->
    case scene:is_cross_elite_scene(Mon#mon.scene) of
        false -> ok;
        true ->
            Mon#mon.copy ! {die, Mon#mon.shadow_key}
    end.

%%玩家信息
make_mb(Player) ->
    {Lv, Score} = get_score(),
    #ce_mb{
        sn = config:get_server_num(),
        key = Player#player.key,
        pid = Player#player.pid,
        sid = Player#player.sid,
        name = Player#player.nickname,
        avatar = Player#player.avatar,
        career = Player#player.career,
        sex = Player#player.sex,
        node = node(),
        cbp = Player#player.highest_cbp,
        old_lv = Lv,
        lv = Lv,
        hp = Player#player.attribute#attribute.hp_lim,
        score = Score
    }.

%%玩家匹配信息
make_gamer(Mb) ->
    #ce_vs{
        sn = Mb#ce_mb.sn,
        key = Mb#ce_mb.key,
        pid = Mb#ce_mb.pid,
        sid = Mb#ce_mb.sid,
        name = Mb#ce_mb.name,
        avatar = Mb#ce_mb.avatar,
        career = Mb#ce_mb.career,
        sex = Mb#ce_mb.sex,
        node = Mb#ce_mb.node,
        cbp = Mb#ce_mb.cbp,
        hp = Mb#ce_mb.hp,
        lv = Mb#ce_mb.lv,
        time = util:unixtime()
    }.

make_gamer_sys(Shadow) ->
    #ce_vs{
        type = 1,
        sn = Shadow#player.sn,
        key = Shadow#player.key,
        name = Shadow#player.nickname,
        career = Shadow#player.career,
        sex = Shadow#player.sex,
        cbp = Shadow#player.cbp,
        time = util:unixtime(),
        shadow = Shadow,
        lv = 1,
        hp = Shadow#player.attribute#attribute.hp_lim
    }.

%%活动关闭,清除单服数据
clean_vs_data() ->
    ets:delete_all_objects(?ETS_CROSS_ELITE).


%%单场结算
cross_elite_msg(Ret, Pkey) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
            cross_elite_msg_offline(Pkey, Ret);
        [Online] ->
            Online#ets_online.pid ! {cross_elite_msg_online, Ret}
    end.

cross_elite_msg_online(Player, Ret) ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    Base = data_cross_elite:get(StElite#st_elite.lv),
    AddScore = ?IF_ELSE(Ret == 1, Base#base_cross_elite.win_score, Base#base_cross_elite.fail_score),
    {Lv, Score} = add_score(StElite#st_elite.lv, StElite#st_elite.score, AddScore),
    DailyScore = max(0, StElite#st_elite.daily_score + AddScore),
    lib_dict:put(?PROC_STATUS_ELITE, StElite#st_elite{lv = Lv, score = Score, times = StElite#st_elite.times + 1, daily_score = DailyScore, is_change = 1}),
    {ok, Bin} = pt_580:write(58008, {Ret, AddScore, Lv}),
    server_send:send_to_sid(Player#player.sid, Bin),
    cross_area:apply(cross_elite, upgrade_score, [Player#player.key, Lv, DailyScore, Ret]),
    log_cross_elite(Player#player.key, Player#player.nickname, Lv, Score, Ret, AddScore),
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3017, 0, Lv),
    ok.

cross_elite_msg_offline(Pkey, Ret) ->
    StElite = cross_elite_init:init_data(Pkey),
    Base = data_cross_elite:get(StElite#st_elite.lv),
    AddScore = ?IF_ELSE(Ret == 1, Base#base_cross_elite.win_score, Base#base_cross_elite.fail_score),
    {Lv, Score} = add_score(StElite#st_elite.lv, StElite#st_elite.score, AddScore),
    DailyScore = max(0, StElite#st_elite.daily_score + AddScore),
    NewStElite = StElite#st_elite{lv = Lv, score = Score, times = StElite#st_elite.times + 1, daily_score = DailyScore, is_change = 1},
    cross_elite_load:replace_elite(NewStElite),
    cross_area:apply(cross_elite, upgrade_score, [Pkey, Lv, DailyScore, Ret]),
    log_cross_elite(Pkey, shadow_proc:get_name(Pkey), Lv, Score, Ret, AddScore),
    achieve:trigger_achieve(Pkey, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3017, 0, Lv),
    ok.

cmd_score(AddScore) ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    {Lv, Score} = add_score(StElite#st_elite.lv, StElite#st_elite.score, AddScore),
    DailyScore = max(0, StElite#st_elite.daily_score + AddScore),
    ?DEBUG("lv ~p/~p ,score ~p/~p~n", [Lv, StElite#st_elite.lv, Score, StElite#st_elite.score]),
    lib_dict:put(?PROC_STATUS_ELITE, StElite#st_elite{lv = Lv, score = Score, daily_score = DailyScore, is_change = 1}),
    ok.


upgrade_score(Pkey, Lv, Score, Ret) ->
    ?CAST(cross_elite_proc:get_server_pid(), {upgrade_score, Pkey, Lv, Score, Ret}).

add_score(Lv, Score, Add) ->
    Score1 = Score + Add,
    Base = data_cross_elite:get(Lv),
    %%降级
    if Score1 < 0 ->
        if Lv == 1 -> {Lv, 0};
            true ->
                BaseDown = data_cross_elite:get(Lv - 1),
                {Lv - 1, BaseDown#base_cross_elite.score + Score1}
        end;
    %%满级
        Base#base_cross_elite.score == 0 ->
            {Lv, Score1};
    %%升级
        Score1 >= Base#base_cross_elite.score ->
            {Lv + 1, Score1 - Base#base_cross_elite.score};
        true ->
            {Lv, Score1}
    end.

%%奖励信息
reward_msg(Pkey, Rank, Lv, OldLv, FightTimes, WinTimes, Score) ->
    GoodsList =
        case data_cross_elite_rank_reward:get(Rank) of
            [] ->
                [];
            L ->
                L1 = tuple_to_list(L),
                Content = io_lib:format(?T("您在跨服1v1战斗中战绩卓越,排名第~p,获得奖励,请查收!"), [Rank]),
                mail:sys_send_mail([Pkey], ?T("跨服1v1"), Content, L1),
                L1
        end,
    DesId = case data_cross_elite_rank_reward:get_des(Rank) of
                [] -> 0;
                Id ->
                    case data_designation:get(Id) of
                        [] -> 0;
                        DesBase ->
                            Content1 = io_lib:format(?T("您在跨服1v1战斗中战绩卓越,排名第~p,获得~s称号奖励!"), [Rank, DesBase#base_designation.name]),
                            mail:sys_send_mail([Pkey], ?T("跨服1v1"), Content1),
                            Id
                    end
            end,
    ?DO_IF(DesId /= 0, designation_proc:add_des(DesId, [Pkey])),
    {ok, Bin} = pt_580:write(58010, {Rank, Lv, OldLv, FightTimes, WinTimes, Score, DesId, goods:pack_goods(GoodsList)}),
    server_send:send_to_key(Pkey, Bin).



log_cross_elite(Pkey, NickName, Lv, Exp, Ret, Score) ->
    Sql = io_lib:format("insert into log_cross_elite set pkey = ~p,nickname = '~s',lv=~p,exp=~p,ret=~p,score=~p,time =~p",
        [Pkey, NickName, Lv, Exp, Ret, Score, util:unixtime()]),
    log_proc:log(Sql).

%%排序
sort_mb_list(MbList) ->
    F = fun(M1, M2) ->
        if M1#ce_mb.score > M2#ce_mb.score -> true;
            M1#ce_mb.score == M2#ce_mb.score andalso M1#ce_mb.lv > M2#ce_mb.lv -> true;
            M1#ce_mb.score == M2#ce_mb.score andalso M1#ce_mb.lv == M2#ce_mb.lv andalso M1#ce_mb.cbp < M2#ce_mb.cbp ->
                true;
            true ->
                false
        end
        end,
    lists:sort(F, MbList).

%%初始化机器人
init_robot() ->
    Sql = io_lib:format("select pkey,cbp from cross_arena where node ='~s'", [node()]),
    F = fun([Key, Cbp], D) ->
        dict:store(Key, Cbp, D)
        end,
    Dict = lists:foldl(F, dict:new(), db:get_all(Sql)),
    put(robot, Dict).

get_notice_player(_Player) ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    case lists:member(0, StElite#st_elite.reward) of
        true ->
            F = fun(Id) ->
                Base = data_cross_elite_daily_reward:get(Id),
                if
                    StElite#st_elite.times < Base#base_cross_elite_daily.times ->
                        [];
                    true ->
                        case lists:member(Id, StElite#st_elite.reward) of
                            true -> [];
                            false -> [1]
                        end
                end
                end,
            List = lists:flatmap(F, data_cross_elite_daily_reward:ids()),
            ?IF_ELSE(List == [], 0, 1);
        false -> 1
    end.

%%每日段位奖励
daily_reward(Player) ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    case lists:member(0, StElite#st_elite.reward) of
        true -> {0, [], Player};
        false ->
            Base = data_cross_elite:get(StElite#st_elite.lv),
            GoodsList = tuple_to_list(Base#base_cross_elite.daily_reward),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(89, GoodsList)),
            NewStElite = StElite#st_elite{reward = [0 | StElite#st_elite.reward], is_change = 1},
            lib_dict:put(?PROC_STATUS_ELITE, NewStElite),
            {1, goods:pack_goods(GoodsList), NewPlayer}
    end.

%%每日挑战奖励
times_reward(Player, Id) ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    case data_cross_elite_daily_reward:get(Id) of
        [] -> {0, [], Player};
        Base ->
            if StElite#st_elite.times < Base#base_cross_elite_daily.times -> {0, [], Player};
                true ->
                    case lists:member(Id, StElite#st_elite.reward) of
                        true -> {0, [], Player};
                        false ->
                            GoodsList = tuple_to_list(Base#base_cross_elite_daily.goods_list),
                            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(89, GoodsList)),
                            NewStElite = StElite#st_elite{reward = [Id | StElite#st_elite.reward], is_change = 1},
                            lib_dict:put(?PROC_STATUS_ELITE, NewStElite),
                            {1, goods:pack_goods(GoodsList), NewPlayer}
                    end
            end
    end.


cmd_test() ->
    StElite = lib_dict:get(?PROC_STATUS_ELITE),
    ?DEBUG("~p~n", [StElite]).