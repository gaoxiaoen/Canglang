%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 三月 2017 10:03
%%%-------------------------------------------------------------------
-module(manor_war_score).
-author("hxming").
-include("guild.hrl").
-include("manor_war.hrl").
-include("battle.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("achieve.hrl").
%% API
-compile(export_all).

%%计算攻击旗帜积分
calc_hurt_flag_score(KList) ->
    F = fun(Hatred, L) ->
        if Hatred#st_hatred.gkey == 0 -> L;
            true ->
                case lists:keytake(Hatred#st_hatred.gkey, 1, L) of
                    false -> [{Hatred#st_hatred.gkey, Hatred#st_hatred.gname, [Hatred]} | L];
                    {value, {_, _, HatredList}, T} ->
                        [{Hatred#st_hatred.gkey, Hatred#st_hatred.gname, [Hatred | HatredList]} | T]
                end
        end
        end,
    MergeList = lists:foldl(F, [], KList),
    F1 = fun({Gkey, Gname, HatredList}) ->
        ManorWar = manor_war_init:get_manor_war(Gkey, Gname),
        F2 = fun(Hatred2, L2) ->
            Score = data_manor_war_score:get(1) * Hatred2#st_hatred.hurt,
            case lists:keytake(Hatred2#st_hatred.key, #manor_war_mb.pkey, L2) of
                false ->
                    TargetList = update_target_list(Hatred2#st_hatred.key, ?MANOR_WAR_TARGET_FLAG_ATTACK, Hatred2#st_hatred.hurt, []),
                    Mb = #manor_war_mb{pkey = Hatred2#st_hatred.key, nickname = Hatred2#st_hatred.nickname, score = Score, target_list = TargetList},
                    [Mb | L2];
                {value, Mb, T2} ->
                    TargetList = update_target_list(Hatred2#st_hatred.key, ?MANOR_WAR_TARGET_FLAG_ATTACK, Hatred2#st_hatred.hurt, Mb#manor_war_mb.target_list),
                    [Mb#manor_war_mb{score = Mb#manor_war_mb.score + Score, target_list = TargetList} | T2]
            end
             end,
        MbList = lists:foldl(F2, ManorWar#manor_war.mb_list, HatredList),
        NewManorWar = ManorWar#manor_war{mb_list = MbList, is_change = 1},
        ets:insert(?ETS_MANOR_WAR, NewManorWar)
         end,
    lists:foreach(F1, MergeList).

%%更新任务目标
update_target_list(Key, TargetId, Times, TargetList) ->
    case lists:keytake(TargetId, 1, TargetList) of
        false ->
            check_target_stage_done(Key, TargetId, 0, Times),
            [{TargetId, Times, []} | TargetList];
        {value, {_, CurTimes, StageList}, T} ->
            check_target_stage_done(Key, TargetId, CurTimes, CurTimes + Times),
            [{TargetId, Times + CurTimes, StageList} | T]
    end.

%%检查目标达成状态
check_target_stage_done(Key, TargetId, OleTimes, NowTimes) ->
    F = fun(Stage) ->
        Base = data_manor_war_target:get(TargetId, Stage),
        if OleTimes < Base#base_manor_war_target.times andalso NowTimes >= Base#base_manor_war_target.times ->
            {ok, Bin} = pt_402:write(40206, {TargetId, Stage}),
            server_send:send_to_key(Key, Bin),
            ok;
            true ->
                ok
        end
        end,
    lists:foreach(F, lists:seq(1, data_manor_war_target:target_stage_lim(TargetId))),
    ok.

%%计算击杀旗帜积分
calc_kill_flag_score(Attacker) ->
    ManorWar = manor_war_init:get_manor_war(Attacker#attacker.gkey, Attacker#attacker.gname),
    Score = data_manor_war_score:get(2),
    MbList =
        case lists:keytake(Attacker#attacker.key, #manor_war_mb.pkey, ManorWar#manor_war.mb_list) of
            false ->
                [#manor_war_mb{pkey = Attacker#attacker.key, nickname = Attacker#attacker.name, score = Score} | ManorWar#manor_war.mb_list];
            {value, Mb, T} ->

                [Mb#manor_war_mb{score = Mb#manor_war_mb.score + Score} | T]
        end,
    NewManorWar = ManorWar#manor_war{mb_list = MbList, is_change = 1},
    ets:insert(?ETS_MANOR_WAR, NewManorWar),
    ok.

%%击杀玩家,增加积分
kill_role_score(Attacker) ->
    ManorWar = manor_war_init:get_manor_war(Attacker#attacker.gkey, Attacker#attacker.gname),
    Score = data_manor_war_score:get(4),
    MbList =
        case lists:keytake(Attacker#attacker.key, #manor_war_mb.pkey, ManorWar#manor_war.mb_list) of
            false ->
                TargetList = update_target_list(Attacker#attacker.key, ?MANOR_WAR_TARGET_KILL_ROLE, 1, []),
                [#manor_war_mb{pkey = Attacker#attacker.key, nickname = Attacker#attacker.name, score = Score, target_list = TargetList} | ManorWar#manor_war.mb_list];
            {value, Mb, T} ->
                TargetList = update_target_list(Attacker#attacker.key, ?MANOR_WAR_TARGET_KILL_ROLE, 1, Mb#manor_war_mb.target_list),
                [Mb#manor_war_mb{score = Mb#manor_war_mb.score + Score, target_list = TargetList} | T]
        end,
    NewManorWar = ManorWar#manor_war{mb_list = MbList, is_change = 1},
    ets:insert(?ETS_MANOR_WAR, NewManorWar).


%%击杀boss积分
kill_boss_score(Attacker, Klist) ->
    ManorWar = manor_war_init:get_manor_war(Attacker#attacker.gkey, Attacker#attacker.gname),
    Score = data_manor_war_score:get(3),
    MbList =
        case lists:keytake(Attacker#attacker.key, #manor_war_mb.pkey, ManorWar#manor_war.mb_list) of
            false ->
                [#manor_war_mb{pkey = Attacker#attacker.key, nickname = Attacker#attacker.name, score = Score} | ManorWar#manor_war.mb_list];
            {value, Mb, T} ->
                [Mb#manor_war_mb{score = Mb#manor_war_mb.score + Score} | T]
        end,
    NewManorWar = ManorWar#manor_war{mb_list = MbList, is_change = 1},
    ets:insert(?ETS_MANOR_WAR, NewManorWar),

    target_attack_boss(Klist),
    ok.

target_attack_boss(Klist) ->
    %%参加boss目标
    F = fun(Hatred, L1) ->
        case lists:keytake(Hatred#st_hatred.gkey, 1, L1) of
            false -> [{Hatred#st_hatred.gkey, Hatred#st_hatred.gname, [Hatred]} | L1];
            {value, {_, _, L11}, T1} ->
                [{Hatred#st_hatred.gkey, Hatred#st_hatred.gname, [Hatred | L11]} | T1]
        end
        end,
    MergeList = lists:foldl(F, [], Klist),
    F1 = fun({GuildKey, GuildName, HatredList}) ->
        ManorWar2 = manor_war_init:get_manor_war(GuildKey, GuildName),
        F2 = fun(Hatred2, L2) ->
            case lists:keytake(Hatred2#st_hatred.key, #manor_war_mb.pkey, L2) of
                false ->
                    TargetList = update_target_list(Hatred2#st_hatred.key, ?MANOR_WAR_TARGET_BOSS_ATTACK, 1, []),
                    [#manor_war_mb{pkey = Hatred2#st_hatred.key, nickname = Hatred2#st_hatred.nickname, target_list = TargetList} | L2];
                {value, Mb2, T2} ->
                    TargetList = update_target_list(Hatred2#st_hatred.key, ?MANOR_WAR_TARGET_BOSS_ATTACK, 1, Mb2#manor_war_mb.target_list),
                    [Mb2#manor_war_mb{target_list = TargetList} | T2]
            end
             end,
        MbList = lists:foldl(F2, ManorWar2#manor_war.mb_list, HatredList),
        NewManorWar2 = ManorWar2#manor_war{mb_list = MbList, is_change = 1},
        ets:insert(?ETS_MANOR_WAR, NewManorWar2)
         end,
    lists:foreach(F1, MergeList),
    ok.


%%积分奖励
score_reward() ->
    MbList = score_rank(),
    F = fun(Mb) ->
        Content = io_lib:format(?T("恭喜您在领土争霸积分排名获得第~p名，获得奖励。"), [Mb#manor_war_mb.rank]),
        GoodsList = data_manor_war_score_reward:get(Mb#manor_war_mb.rank),
        NewGoodsList = case is_tuple(GoodsList) of
                           true -> tuple_to_list(GoodsList);
                           false -> GoodsList
                       end,
        mail:sys_send_mail([Mb#manor_war_mb.pkey], ?T("领地战积分奖励"), Content, NewGoodsList),
        case data_manor_war_score_reward:get_des(Mb#manor_war_mb.rank) of
            0 -> ok;
            DesId ->
                designation_proc:add_des(DesId, [Mb#manor_war_mb.pkey])
        end
        end,
    lists:foreach(F, MbList),
    spawn(fun() -> achieve(MbList) end),
    ok.


score_rank() ->
    F = fun(ManorWar) ->
        [M#manor_war_mb{gname = ManorWar#manor_war.name} || M <- ManorWar#manor_war.mb_list] end,
    MbList = lists:flatmap(F, ets:tab2list(?ETS_MANOR_WAR)),
    MbList1 = lists:keysort(#manor_war_mb.score, MbList),
    F1 = fun(Mb, {Rank, L}) ->
        {Rank - 1, [Mb#manor_war_mb{rank = Rank} | L]}
         end,
    {_, MbList2} = lists:foldl(F1, {length(MbList1), []}, MbList1),
    MbList2.


achieve(MbList) ->
    F = fun(Mb) ->
        achieve:trigger_achieve(Mb#manor_war_mb.pkey, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3008, 0, Mb#manor_war_mb.rank)
        end,
    lists:foreach(F, MbList),
    ok.
