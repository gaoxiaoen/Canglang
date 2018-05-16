%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十二月 2016 10:09
%%%-------------------------------------------------------------------
-module(manor_war).
-author("hxming").

-include("common.hrl").
-include("manor_war.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("guild.hrl").
-include("achieve.hrl").
%% API
-compile(export_all).

%%仙盟解散
del_guild(Gkey) ->
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] -> ok;
        [ManorWar] ->
            ets:delete(?ETS_MANOR_WAR, Gkey),
            manor_war_load:delete_manor_war(Gkey),
            F = fun({SceneId, _}) ->
                ets:delete(?ETS_MANOR, SceneId),
                manor_war_load:delete_manor(SceneId)
                end,
            lists:foreach(F, ManorWar#manor_war.scene_list)
    end,
    ok.

%%获取占领仙盟名称
get_manor_guild_name(SceneId) ->
    case ets:lookup(?ETS_MANOR, SceneId) of
        [] -> <<>>;
        [Manor] -> Manor#manor.name
    end.

online_num() ->
    ets:info(?ETS_ONLINE, size).


%%创建旗帜
create_flag_all() ->
    Copy = 0,
    F = fun(Sid) ->
        scene_copy_proc:set_default(Sid, true),
        Base = data_manor_war_scene:get(Sid),
        mon_agent:create_mon_cast([Base#base_manor_war.flag_id, Sid, Base#base_manor_war.flag_x, Base#base_manor_war.flag_y, Copy, 1, []])
        end,
    lists:foreach(F, data_manor_war_scene:scene_list()).

%%刷新boss准备
refresh_boss() ->
    F = fun(Sid) ->
        Base = data_manor_war_scene:get(Sid),
        [{Sid, Mid, X, Y} || {Mid, X, Y} <- Base#base_manor_war.boss_list]
        end,
    BossList = lists:flatmap(F, data_manor_war_scene:scene_list()),
    case BossList of
        [] -> ok;
        _ ->
            {SceneId, BossId, TarX, TarY} = util:list_rand(BossList),
            set_boss_timer(BossId, SceneId, TarX, TarY, ?MANOR_WAR_BOSS_REFRESH_TIME)
    end.

set_boss_timer(BossId, Sid, X, Y, Time) ->
    MsgTime = 30,
    misc:cancel_timer({boss, Sid, X, Y}),
    Ref = erlang:send_after(Time * 1000, self(), {refresh_boss, BossId, Sid, X, Y}),
    put({boss, Sid, X, Y}, Ref),
    misc:cancel_timer({boss_msg, Sid, X, Y}),
    Ref1 = erlang:send_after(max(1, (Time - MsgTime)) * 1000, self(), {refresh_boss_msg, BossId, Sid, MsgTime}),
    put({boss_msg, Sid, X, Y}, Ref1),
    ok.


%%场景指定场景旗帜
refresh_flag(SceneId, Attacker) ->
    Base = data_manor_war_scene:get(SceneId),
    Time = 10,
    GodTime = util:unixtime() + Time,
    Args = [{mon_name, Attacker#attacker.gname}, {godt, GodTime}, {set_godt, Time, 0}, {guild_key, Attacker#attacker.gkey}, {show_time, GodTime}],
    mon_agent:create_mon_cast([Base#base_manor_war.flag_id, SceneId, Base#base_manor_war.flag_x, Base#base_manor_war.flag_y, 0, 1, Args]),
    ok.


%%清除怪物
clean_mon() ->
    F = fun(Sid) ->
        MonList = mon_agent:get_scene_mon_by_kind(Sid, 0, ?MON_KIND_MANOR) ++ mon_agent:get_scene_mon_by_kind(Sid, 0, ?MON_KIND_MANOR_BOSS),
        [monster:stop_broadcast(Mon#mon.pid) || Mon <- MonList]
        end,
    lists:foreach(F, data_manor_war_scene:scene_list()).

%%更新旗帜伤害
update_flag_hurt(Mon, Attacker, KList) ->
    case Mon#mon.kind == ?MON_KIND_MANOR of
        false -> KList;
        true ->
            if Mon#mon.hp =< 0 ->
                achieve:trigger_achieve(Attacker#attacker.key, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3010, 0, 1),
                manor_war_proc:get_server_pid() ! {update_flag, Mon#mon.scene, KList, Attacker},
                [];
                true ->
                    Now = util:unixtime(),
                    Key = update_manor_flag_klist,
                    case get(Key) of
                        undefined ->
                            put(Key, Now),
                            manor_war_proc:get_server_pid() ! {update_flag, Mon#mon.scene, KList, false},
                            [];
                        Time ->
                            case Now - Time >= 3 of
                                true ->
                                    put(Key, Now),
                                    manor_war_proc:get_server_pid() ! {update_flag, Mon#mon.scene, KList, false},
                                    [];
                                false -> KList
                            end
                    end
            end
    end.

%%检查是否可攻击旗帜
check_attack_flag(Mon, AttackerGkey) ->
    if Mon#mon.time_mark#time_mark.godt > 0 -> {false, 30};
        AttackerGkey == 0 -> {false, 28};
        Mon#mon.guild_key == AttackerGkey -> {false, 27};
        true ->
            true
    end.

check_attack_boss(Mon, AttackerGkey) ->
    if AttackerGkey == 0 -> {false, 28};
        Mon#mon.guild_key == AttackerGkey -> {false, 31};
        true ->
            true
    end.


%%检查击杀boss
check_kill_boss(Mon, Attacker, Klist) ->
    if Mon#mon.kind == ?MON_KIND_MANOR_BOSS andalso Mon#mon.guild_key == 0 andalso Mon#mon.hp =< 0 ->
        achieve:trigger_achieve(Attacker#attacker.key, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3012, 0, 1),
        manor_war_proc:get_server_pid() ! {kill_boss, Mon#mon.mid, Mon#mon.scene, Attacker, Klist},
        ok;
        true -> ok
    end.


%%击杀玩家
check_kill_role(Player, Attacker) ->
    case lists:member(Player#player.scene, data_manor_war_scene:scene_list()) of
        false -> ok;
        true ->
            if Player#player.guild#st_guild.guild_key == Attacker#attacker.gkey -> ok;
                Attacker#attacker.gkey == 0 -> skip;
                true ->
                    case ets:info(?ETS_MANOR_WAR_STATE, size) > 0 of
                        false -> ok;
                        true ->
                            achieve:trigger_achieve(Attacker#attacker.key, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3011, 0, 1),
                            manor_war_proc:get_server_pid() ! {kill_role, Attacker}
                    end
            end
    end,
    ok.

%%更新占领信息
upgrade_manor(SceneId, Attacker) ->
    if Attacker#attacker.gkey /= 0 ->
        Now = util:unixtime(),
        NewManor =
            case ets:lookup(?ETS_MANOR, SceneId) of
                [] ->
                    #manor{scene_id = SceneId, gkey = Attacker#attacker.gkey, name = Attacker#attacker.gname, time = Now,is_change = 1};
                [Manor] ->
                    case ets:lookup(?ETS_MANOR_WAR, Manor#manor.gkey) of
                        [] -> ok;
                        [ManorWar] ->
                            SceneList = lists:keydelete(SceneId, 1, ManorWar#manor_war.scene_list),
                            NewManorWar = ManorWar#manor_war{scene_list = SceneList, is_change = 1},
                            ets:insert(?ETS_MANOR_WAR, NewManorWar)
                    end,
                    Manor#manor{gkey = Attacker#attacker.gkey, name = Attacker#attacker.gname, time = Now,is_change = 1}
            end,
        ?DO_IF(SceneId == ?SCENE_ID_MAIN, scene_agent_dispatch:manor_name(SceneId, Attacker#attacker.gname)),
        ets:insert(?ETS_MANOR, NewManor),
        ManorWar1 = manor_war_init:get_manor_war(Attacker#attacker.gkey, Attacker#attacker.gname),
        SceneList1 = [{SceneId, Now} | lists:keydelete(SceneId, 1, ManorWar1#manor_war.scene_list)],
        NewManorWar1 = ManorWar1#manor_war{scene_list = SceneList1, is_change = 1},
        ets:insert(?ETS_MANOR_WAR, NewManorWar1);
        true ->
            ok
    end.
%%前十
check_top_ten(Pkey) ->
    Len = 10,
    RankList = manor_war_score:score_rank(),
    TopList = lists:sublist(RankList, Len),
    F = fun(Mb) ->
        [Mb#manor_war_mb.rank, Mb#manor_war_mb.gname, Mb#manor_war_mb.nickname, Mb#manor_war_mb.score]
        end,
    InfoList = lists:map(F, TopList),
    {Rank, Score} =
        case lists:keyfind(Pkey, #manor_war_mb.pkey, RankList) of
            false -> {0, 0};
            My ->
                {My#manor_war_mb.rank, My#manor_war_mb.score}
        end,
    NewRank = ?IF_ELSE(Rank > Len orelse Rank == 0, 0, Rank),
    {Score, NewRank, InfoList}.


%%获取目标
target(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    if Gkey == 0 -> {0, []};
        true ->
%%            case ets:info(?ETS_MANOR_WAR_STATE, size) > 0 of
%%                false -> {0, []};
%%                true ->
            ManorWar = manor_war_init:get_manor_war(Gkey, Player#player.guild#st_guild.guild_name),
            Mb =
                case lists:keyfind(Player#player.key, #manor_war_mb.pkey, ManorWar#manor_war.mb_list) of
                    false -> #manor_war_mb{};
                    Val -> Val
                end,
            F = fun(TargetId) ->
                case lists:keyfind(TargetId, 1, Mb#manor_war_mb.target_list) of
                    false ->
                        Base = data_manor_war_target:get(TargetId, 1),
                        RewardList = goods:pack_goods(Base#base_manor_war_target.reward),
                        [TargetId, 1, 0, Base#base_manor_war_target.times, 0, RewardList];
                    {_, Times, StageList} ->
                        Base = check_stage(TargetId, 1, StageList),
                        RewardList = goods:pack_goods(Base#base_manor_war_target.reward),
                        IsReward =
                            case lists:member(Base#base_manor_war_target.stage, StageList) of
                                true -> 2;
                                false ->
                                    if Times >= Base#base_manor_war_target.times -> 1;
                                        true -> 0
                                    end
                            end,
                        [TargetId, Base#base_manor_war_target.stage, Times, Base#base_manor_war_target.times, IsReward, RewardList]
                end
                end,
            TargetList = lists:map(F, data_manor_war_target:target_list()),
            {1, TargetList}
%%            end
    end.

check_stage(TargetId, Stage, StageList) ->
    case lists:member(Stage, StageList) of
        true ->
            check_stage(TargetId, Stage + 1, StageList);
        false ->
            StageLim = data_manor_war_target:target_stage_lim(TargetId),
            if Stage >= StageLim ->
                data_manor_war_target:get(TargetId, StageLim);
                true ->
                    data_manor_war_target:get(TargetId, Stage)
            end
    end.

%%目标奖励
target_reward(Player, TargetId, Stage) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case ets:lookup(?ETS_MANOR_WAR, Gkey) of
        [] -> {2, Player};
        [ManorWar] ->
            case lists:keytake(Player#player.key, #manor_war_mb.pkey, ManorWar#manor_war.mb_list) of
                false -> {6, Player};
                {value, Mb, L} ->
                    case data_manor_war_target:get(TargetId, Stage) of
                        [] -> {8, Player};
                        Base ->
                            case lists:keytake(TargetId, 1, Mb#manor_war_mb.target_list) of
                                false -> {6, Player};
                                {value, {_, Times, StageList}, T} ->
                                    case lists:member(Stage, StageList) of
                                        true -> {7, Player};
                                        false ->
                                            if Times < Base#base_manor_war_target.times -> {6, Player};
                                                true ->
                                                    TargetList = [{TargetId, Times, [Stage | StageList]} | T],
                                                    NewMb = Mb#manor_war_mb{target_list = TargetList},
                                                    NewManorWar = ManorWar#manor_war{mb_list = [NewMb | L], is_change = 1},
                                                    ets:insert(?ETS_MANOR_WAR, NewManorWar),
                                                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(209, Base#base_manor_war_target.reward)),
                                                    {1, NewPlayer}
                                            end
                                    end
                            end
                    end
            end
    end.

%%获取指定场景的领主
get_scene_manor_guild(SceneId) ->
    case ets:lookup(?ETS_MANOR, SceneId) of
        [] ->
            [];
        [Manor] ->
            case guild_ets:get_guild(Manor#manor.gkey) of
                false -> [];
                Guild -> Guild
            end
    end.

%%change_pk() ->
%%    F = fun(ManorWar) ->
%%        PidList = guild_util:get_guild_member_pids_online(ManorWar#manor_war.gkey),
%%        [Pid ! manor_war_pk || Pid <- PidList]
%%        end,
%%    lists:foreach(F, ets:tab2list(?ETS_MANOR_WAR)),
%%    ok.
