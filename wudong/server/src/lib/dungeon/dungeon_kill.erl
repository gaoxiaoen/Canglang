%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 一月 2016 20:54
%%%-------------------------------------------------------------------
-module(dungeon_kill).
-author("hxming").
-include("common.hrl").
-include("dungeon.hrl").
-include("goods.hrl").
-include("kindom_guard.hrl").
-include("guild.hrl").
%% API
-compile(export_all).

%%九霄塔击杀
tower_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    %%击杀完毕
                    if CurKill >= StDun#st_dungeon.need_kill_num ->
                        util:cancel_ref([StDun#st_dungeon.close_timer]),
                        Ref = erlang:send_after(1000, self(), dungeon_finish),
                        StDun#st_dungeon{cur_kill_num = CurKill, is_pass = ?DUNGEON_PASS, close_timer = Ref};
                        true ->
                            StDun#st_dungeon{cur_kill_num = CurKill}
                    end
            end
    end.

%%普通副本击杀怪物
normal_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    NewStDun = StDun#st_dungeon{cur_kill_num = CurKill},
                    %%击杀完毕
                    if CurKill == StDun#st_dungeon.need_kill_num ->
                        util:cancel_ref([StDun#st_dungeon.close_timer]),
                        Ref = erlang:send_after(1000, self(), dungeon_finish),
                        NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS, close_timer = Ref};
                        true ->
                            NewStDun
                    end

            end
    end.

%%每日副本击杀
daily_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    NewStDun = StDun#st_dungeon{cur_kill_num = CurKill, kill_list = KillList},
                    %%击杀完毕
                    if CurKill == StDun#st_dungeon.need_kill_num ->
                        if StDun#st_dungeon.round == StDun#st_dungeon.max_round ->
                            util:cancel_ref([StDun#st_dungeon.close_timer]),
                            Ref = erlang:send_after(1000, self(), dungeon_finish),
                            NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS, close_timer = Ref};
                            true ->
                                erlang:send_after(200, self(), {next_round}),
                                NewStDun
                        end;
                        true ->
                            NewStDun
                    end

            end
    end.

%%主线副本击杀
task_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    NewStDun = StDun#st_dungeon{cur_kill_num = CurKill, kill_list = KillList},
                    %%击杀完毕
                    if CurKill == StDun#st_dungeon.need_kill_num ->
                        util:cancel_ref([StDun#st_dungeon.close_timer]),
                        Ref = erlang:send_after(1000, self(), dungeon_finish),
                        NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS, close_timer = Ref};
                        true ->
                            NewStDun
                    end

            end
    end.

%%材料副本
material_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    NewStDun = StDun#st_dungeon{cur_kill_num = CurKill, kill_list = KillList},
                    %%击杀完毕
                    if CurKill == StDun#st_dungeon.need_kill_num ->
                        if StDun#st_dungeon.round == StDun#st_dungeon.max_round ->
                            util:cancel_ref([StDun#st_dungeon.close_timer]),
                            Ref = erlang:send_after(1000, self(), dungeon_finish),
                            NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS, close_timer = Ref};
                            true ->
                                erlang:send_after(200, self(), {next_round}),
                                NewStDun
                        end;
                        true ->
                            NewStDun
                    end

            end
    end.

equip_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    NewStDun = StDun#st_dungeon{cur_kill_num = CurKill, kill_list = KillList},
                    %%击杀完毕
                    if CurKill == StDun#st_dungeon.need_kill_num ->
                        if StDun#st_dungeon.round == StDun#st_dungeon.max_round ->
                            util:cancel_ref([StDun#st_dungeon.close_timer]),
                            Ref = erlang:send_after(1000, self(), dungeon_finish),
                            NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS, close_timer = Ref};
                            true ->
                                erlang:send_after(200, self(), {next_round}),
                                NewStDun
                        end;
                        true ->
                            NewStDun
                    end

            end
    end.

jiandao_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    #base_dun_jiandao{score = AddScore} = data_dun_jiandao:get(StDun#st_dungeon.dungeon_id),
                    DunJiandao = StDun#st_dungeon.dun_jiandao,
                    NewStDun =
                        StDun#st_dungeon{
                            cur_kill_num = CurKill,
                            kill_list = KillList,
                            dun_jiandao = DunJiandao#dun_jiandao{score = AddScore+DunJiandao#dun_jiandao.score}
                        },
                    %%击杀完毕
                    if
                        CurKill == StDun#st_dungeon.need_kill_num ->
                            if
                                StDun#st_dungeon.round == StDun#st_dungeon.max_round ->
                                    util:cancel_ref([StDun#st_dungeon.close_timer]),
                                    Ref = erlang:send_after(1000, self(), dungeon_finish),
                                    NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS, close_timer = Ref};
                                true ->
                                    erlang:send_after(100, self(), {next_round}),
                                    NewStDun
                            end;
                        true ->
                            NewStDun
                    end
            end
    end.

%% 元素副本击杀
element_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    NewStDun =
                        StDun#st_dungeon{
                            cur_kill_num = CurKill,
                            kill_list = KillList
                        },
                    %%击杀完毕
                    if
                        CurKill == StDun#st_dungeon.need_kill_num ->
                            if
                                StDun#st_dungeon.round == StDun#st_dungeon.max_round ->
                                    util:cancel_ref([StDun#st_dungeon.close_timer]),
                                    Ref = erlang:send_after(1000, self(), dungeon_finish),
                                    NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS, close_timer = Ref};
                                true ->
                                    erlang:send_after(100, self(), {next_round}),
                                    NewStDun
                            end;
                        true ->
                            NewStDun
                    end
            end
    end.

%%经验副本
exp_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    NewStDun = StDun#st_dungeon{cur_kill_num = CurKill, kill_list = KillList},
                    %%击杀完毕
                    if CurKill == StDun#st_dungeon.need_kill_num ->
                        PassGoodsList = case data_dungeon_exp:get_pass_goods(StDun#st_dungeon.round) of
                                            [] -> [];
                                            GList -> tuple_to_list(GList)
                                        end,
                        Exp = case lists:keyfind(?GOODS_ID_EXP, 1, PassGoodsList) of
                                  false -> StDun#st_dungeon.exp;
                                  {_, ExpAdd} ->
                                      StDun#st_dungeon.exp + ExpAdd
                              end,
                        FirstGoodsList =
                            if StDun#st_dungeon.round > StDun#st_dungeon.dun_exp#dun_exp.round_h ->
                                case data_dungeon_exp:get_first_goods(StDun#st_dungeon.round) of
                                    [] -> [];
                                    FGoods ->
                                        tuple_to_list(FGoods)
                                end;
                                true ->
                                    []
                            end,
                        RoundH = max(StDun#st_dungeon.dun_exp#dun_exp.round_h, StDun#st_dungeon.round),
                        GoodsList = goods:merge_goods(StDun#st_dungeon.goods_list ++ PassGoodsList ++ FirstGoodsList),
                        DunExp = StDun#st_dungeon.dun_exp,
                        RoundAcc = DunExp#dun_exp.round_acc + 1,
                        IsRoundAccFinal =
                            case StDun#st_dungeon.player_list of
                                [] -> false;
                                [Mb | _] ->
                                    case data_dungeon_exp_round_acc:get(Mb#dungeon_mb.lv) of
                                        [] -> false;
                                        RoundAcc1 ->
                                            RoundAcc >= RoundAcc1
                                    end
                            end,
                        NewDunExp = DunExp#dun_exp{round_h = RoundH, round_acc = RoundAcc},
                        [DungeonPlayer#dungeon_mb.pid ! {update_dun_exp_round, StDun#st_dungeon.round, PassGoodsList, FirstGoodsList} || DungeonPlayer <- StDun#st_dungeon.player_list],
                        if StDun#st_dungeon.round == StDun#st_dungeon.max_round orelse IsRoundAccFinal ->
                            util:cancel_ref([StDun#st_dungeon.close_timer]),
                            Ref = erlang:send_after(1000, self(), dungeon_finish),
                            NewStDun#st_dungeon{dun_exp = NewDunExp, goods_list = GoodsList, exp = Exp, is_pass = ?DUNGEON_PASS, close_timer = Ref};
                            true ->
                                erlang:send_after(100, self(), {next_round}),
                                NewStDun#st_dungeon{dun_exp = NewDunExp, goods_list = GoodsList, exp = Exp}
                        end;
                        true ->
                            NewStDun
                    end

            end
    end.

%%神器副本击杀
god_weapon_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    NewStDun = StDun#st_dungeon{cur_kill_num = CurKill, kill_list = KillList},
                    [self() ! {dungeon_target, DungeonPlayer#dungeon_mb.sid} || DungeonPlayer <- StDun#st_dungeon.player_list],
                    %%击杀完毕
                    if CurKill == StDun#st_dungeon.need_kill_num ->
                        Layer = data_dungeon_god_weapon:scene2layer(StDun#st_dungeon.dungeon_id),
                        DunGodWeapon = StDun#st_dungeon.dun_god_weapon,
                        IsFirst = dungeon_god_weapon:is_first_pass(Layer, StDun#st_dungeon.round, DunGodWeapon#dun_god_weapon.layer_h, DunGodWeapon#dun_god_weapon.round_h),
                        PassGoodsList =
                            if IsFirst ->
                                case data_dungeon_god_weapon:get_first_goods(Layer, StDun#st_dungeon.round) of
                                    [] -> [];
                                    L -> tuple_to_list(L)
                                end;
                                true ->
                                    case data_dungeon_god_weapon:get_goods(Layer, StDun#st_dungeon.round) of
                                        [] -> [];
                                        L -> tuple_to_list(L)
                                    end
                            end,
                        GoodsList = goods:merge_goods(StDun#st_dungeon.goods_list ++ PassGoodsList),
                        [DungeonPlayer#dungeon_mb.pid ! {update_dun_god_weapon_layer, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.round, PassGoodsList} || DungeonPlayer <- StDun#st_dungeon.player_list],
                        if StDun#st_dungeon.round == StDun#st_dungeon.max_round ->
                            util:cancel_ref([StDun#st_dungeon.close_timer]),
                            Ref = erlang:send_after(1000, self(), dungeon_finish),
                            NewStDun#st_dungeon{goods_list = GoodsList, is_pass = ?DUNGEON_PASS, close_timer = Ref};
                            true ->
                                erlang:send_after(100, self(), {next_round}),
                                NewStDun#st_dungeon{goods_list = GoodsList}
                        end;
                        true ->
                            NewStDun
                    end

            end
    end.

%%竞技场击杀
arena_kill(StDun, ShadowKey) ->
    case lists:keyfind(ShadowKey, #dun_arena.pkey, StDun#st_dungeon.dun_arena) of
        false -> StDun;
        DunArena ->
            if DunArena#dun_arena.type == 0 ->
                util:cancel_ref([StDun#st_dungeon.close_timer]),
                Ref = erlang:send_after(1000, self(), dungeon_finish),
                StDun#st_dungeon{cur_kill_num = StDun#st_dungeon.need_kill_num, is_pass = ?DUNGEON_PASS, close_timer = Ref};
                true ->
                    util:cancel_ref([StDun#st_dungeon.close_timer]),
                    Ref = erlang:send_after(1000, self(), dungeon_finish),
                    StDun#st_dungeon{cur_kill_num = StDun#st_dungeon.need_kill_num, close_timer = Ref}
            end
    end.

guild_fight_kill(StDun, ShadowKey) ->
    case lists:keyfind(ShadowKey, #dun_arena.pkey, StDun#st_dungeon.dun_arena) of
        false -> StDun;
        DunArena ->
            if DunArena#dun_arena.type == 0 ->
                util:cancel_ref([StDun#st_dungeon.close_timer]),
                Ref = erlang:send_after(1000, self(), dungeon_finish),
                StDun#st_dungeon{cur_kill_num = StDun#st_dungeon.need_kill_num, is_pass = ?DUNGEON_PASS, close_timer = Ref};
                true ->
                    util:cancel_ref([StDun#st_dungeon.close_timer]),
                    Ref = erlang:send_after(1000, self(), dungeon_finish),
                    StDun#st_dungeon{cur_kill_num = StDun#st_dungeon.need_kill_num, close_timer = Ref}
            end
    end.

calc_exp(DunId) ->
    case data_dungeon:get(DunId) of
        [] -> skip;
        Dun ->
            %%[{1,[{31010,17,18}]}]
            F = fun({_, MonList}) ->
                F1 = fun({MonId, _, _}) ->
                    Mon = data_mon:get(MonId),
                    Mon#mon.exp
                end,
                lists:sum(lists:map(F1, MonList))
            end,
            lists:sum(lists:map(F, Dun#dungeon.mon))
    end.


calc_revive(DunId) ->
    case data_dungeon:get(DunId) of
        [] -> skip;
        Dun ->
            %%[{1,[{31010,17,18}]}]
            F = fun({_, MonList}) ->
                F1 = fun({MonId, _, _}) ->
                    Mon = data_mon:get(MonId),
                    ?DEBUG("Mon#mon.retime ~p~n", [Mon#mon.retime])
                end,
                lists:map(F1, MonList)
            end,
            lists:map(F, Dun#dungeon.mon)
    end.

%%活动副本击杀怪物
activity_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    case data_mon:get(Mid) of
                        [] -> StDun;
                        Mon when Mon#mon.boss == ?DUNGEON_BOSS_TYPE ->
                            CurKill = StDun#st_dungeon.cur_kill_num + 1,
                            %%击杀完毕
                            if CurKill >= StDun#st_dungeon.need_kill_num ->
                                util:cancel_ref([StDun#st_dungeon.close_timer]),
                                Ref = erlang:send_after(1000, self(), dungeon_finish),
                                StDun#st_dungeon{
                                    cur_kill_num = CurKill,
                                    is_pass = ?DUNGEON_PASS,
                                    close_timer = Ref
                                };
                                true ->
                                    StDun#st_dungeon{cur_kill_num = CurKill}
                            end;
                        _ -> StDun
                    end
            end
    end.


%%王城守卫副本击杀
kindom_kill(StDun, Mid, Extra) ->
    BaseMon = data_mon:get(Mid),
    case BaseMon#mon.kind == ?MON_KIND_KINDOM_GUARD_BOX of
        true -> StDun;
        false ->
            Wave =
                case lists:keyfind(wave, 1, Extra) of
                    false -> 0;
                    {_, Wave0} -> Wave0
                end,
            {_, {X, Y}} = lists:keyfind(xy, 1, Extra),
            IsGuardMon = kindom_guard:is_guard_mon(Mid),
            case IsGuardMon of
                true -> %%守卫被杀
                    kindom_kill_guard(StDun);
                false ->
                    NewStDun = kindom_kill_mon(StDun, Mid, Wave, X, Y),
                    MaxFloor = data_dungeon_kindom_guard:get_max_floor(),
                    if
                        NewStDun#st_dungeon.dun_kindom#dun_kindom.kill_floor >= MaxFloor -> %%通关
                            NewStDun1 = NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS},
                            util:cancel_ref([StDun#st_dungeon.close_timer, NewStDun#st_dungeon.dun_kindom#dun_kindom.mon_notice_ref]),
                            erlang:send_after(10, self(), {kindom_finish, ?KINDOM_NOTICE_STATE_SUCCESS}),
                            NewStDun1;
                        NewStDun#st_dungeon.kill_list == [] -> %%出现的怪物都杀光了
                            util:cancel_ref([NewStDun#st_dungeon.next_round_timer, NewStDun#st_dungeon.dun_kindom#dun_kindom.mon_notice_ref]),
                            Ref = erlang:send_after(10000, self(), {time_to_next_round}),
                            RoundTime = util:unixtime() + 10,
                            kindom_guard:mon_refresh_notice(?SCENE_ID_KINDOM_GUARD_ID, self(), NewStDun#st_dungeon.dun_kindom#dun_kindom.cur_floor + 1, 10),
                            self() ! {dungeon_target, 0},
                            NewStDun#st_dungeon{next_round_timer = Ref, round_time = RoundTime};
                        true ->
                            NewStDun
                    end
            end
    end.

kindom_kill_guard(StDun) -> %%王城守卫击杀守卫
    L = mon_agent:get_scene_mon_by_kind(?SCENE_ID_KINDOM_GUARD_ID, self(), ?MON_KIND_KINDOM_GUARD),
    case [M || M <- L, M#mon.hp > 0] of
        [] ->
            NewStDun = StDun#st_dungeon{is_pass = 0},
            util:cancel_ref([StDun#st_dungeon.close_timer, NewStDun#st_dungeon.next_round_timer, NewStDun#st_dungeon.dun_kindom#dun_kindom.mon_notice_ref]),
            erlang:send_after(10, self(), {kindom_finish, ?KINDOM_NOTICE_STATE_KILL}),
            kindom_guard:mon_refresh_notice(?SCENE_ID_KINDOM_GUARD_ID, self(), -2, 10),
            NewStDun;
        _ ->
            StDun
    end.
kindom_kill_mon(StDun, Mid, Wave, X, Y) -> %%王城守卫击杀普通怪
    KillList =
        case lists:keyfind(Wave, 1, StDun#st_dungeon.kill_list) of
            false -> StDun#st_dungeon.kill_list;
            {Wave, OldKillList} ->
                NewKillList =
                    case lists:keyfind(Mid, 1, OldKillList) of
                        false -> OldKillList;
                        {_, Need, Cur} ->
                            {Wave, lists:keyreplace(Mid, 1, OldKillList, {Mid, Need, Cur + 1})}
                    end,
                lists:keyreplace(Wave, 1, StDun#st_dungeon.kill_list, NewKillList)
        end,
    %%怪物被杀，创建宝箱
    kindom_guard:create_mon_box(Mid, X, Y, self()),
    MaxFloor = data_dungeon_kindom_guard:get_max_floor(),
    %%处理完成击杀的最低N层
    Ff = fun(CheckWave, {AccSt, IsCheck}) ->
        case IsCheck of
            false -> {AccSt, IsCheck};
            true ->
                case lists:keyfind(CheckWave, 1, AccSt#st_dungeon.kill_list) of
                    false -> {AccSt, false};
                    {_, MonList} ->
                        Fm = fun({_MonId, MonNeed, MonCur}, {AccMonNeed, AccMonCur}) ->
                            {AccMonNeed + MonNeed, AccMonCur + MonCur}
                        end,
                        {NeedKill, CurKill} = lists:foldl(Fm, {0, 0}, MonList),
                        if
                            CurKill >= NeedKill -> %%最低一层杀完;
                                BaseGuard = data_dungeon_kindom_guard:get(CheckWave),
                                #base_kindom_dun{
                                    goods_list = GoodsList
                                } = BaseGuard,
                                Fr = fun(ScenePlayer) ->
                                    catch ScenePlayer#scene_player.pid ! {kindom_guard_add_goods, GoodsList}
                                end,
                                ScenePlayerList = scene_agent:get_copy_scene_player(AccSt#st_dungeon.dungeon_id, self()),
                                lists:foreach(Fr, ScenePlayerList),
                                Now = util:unixtime(),
                                kindom_guard:create_floor_box(CheckWave, self()),
                                Fg = fun({GoodsId, Num}, AccGoodsList) ->
                                    case lists:keyfind(GoodsId, 1, AccGoodsList) of
                                        false -> [{GoodsId, Num} | AccGoodsList];
                                        {_, OldNum} ->
                                            [{GoodsId, Num + OldNum} | lists:keydelete(GoodsId, 1, AccGoodsList)]
                                    end
                                end,
                                NewGoodsList = lists:foldl(Fg, StDun#st_dungeon.goods_list, GoodsList),
                                AccSt1 = AccSt#st_dungeon{
                                    kill_list = lists:keydelete(CheckWave, 1, AccSt#st_dungeon.kill_list),
                                    dun_kindom = AccSt#st_dungeon.dun_kindom#dun_kindom{
                                        kill_floor = CheckWave,
                                        kill_floor_time = Now
                                    },
                                    goods_list = NewGoodsList
                                },
                                {AccSt1, true};
                            true ->
                                {AccSt, false}
                        end
                end
        end
    end,
    CheckWaveList = lists:seq(max(1, StDun#st_dungeon.dun_kindom#dun_kindom.kill_floor + 1), MaxFloor),
    {NewStDun, _} = lists:foldl(Ff, {StDun#st_dungeon{kill_list = KillList}, true}, CheckWaveList),
    NewStDun.


%%******************************%%
%% 跨服试炼副本
cross_guard_kill(StDun, Mid, Extra) ->
    BaseMon = data_mon:get(Mid),
    case BaseMon#mon.kind == ?MON_KIND_CROSS_GUARD_BOX of
        true ->
            NewDunCrossGuard = StDun#st_dungeon.dun_cross_guard#dun_cross_guard{box_count = StDun#st_dungeon.dun_cross_guard#dun_cross_guard.box_count + 1},
            StDun#st_dungeon{
                dun_cross_guard = NewDunCrossGuard
            };
        false ->
            Wave =
                case lists:keyfind(wave, 1, Extra) of
                    false -> 0;
                    {_, Wave0} -> Wave0
                end,
            {_, {X, Y}} = lists:keyfind(xy, 1, Extra),
            Scene =
                case lists:keyfind(scene, 1, Extra) of
                    false -> 0;
                    {_, Scene0} -> Scene0
                end,
            IsGuardMon = cross_dungeon_guard_util:is_guard_mon(Mid),
            case IsGuardMon of
                true -> %%守卫被杀
                    cross_guard_kill_guard(StDun, Scene);
                false ->
                    NewStDun = cross_guard_kill_mon(StDun, Mid, Wave, X, Y, Scene),
                    MaxFloor = data_dungeon_cross_guard_floor:get_max_floor(Scene),
                    if
                        NewStDun#st_dungeon.dun_cross_guard#dun_cross_guard.kill_floor >= MaxFloor -> %%通关
                            NewStDun1 = NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS},
                            util:cancel_ref([StDun#st_dungeon.close_timer, NewStDun#st_dungeon.dun_cross_guard#dun_cross_guard.mon_notice_ref]),
                            UseTime = util:unixtime() - NewStDun#st_dungeon.begin_time,
                            ?DEBUG("Wave ~p~n",[Wave]),
                            spawn(cross_dungeon_guard_util, update_ets,
                                [[XX || XX <- NewStDun#st_dungeon.player_list, XX#dungeon_mb.node /= none], UseTime, NewStDun#st_dungeon.dungeon_id, Wave]),
                            spawn(fun() ->
                                cross_dungeon_guard_util:update_milestone(NewStDun#st_dungeon.player_list, NewStDun#st_dungeon.dungeon_id, Wave, UseTime) end),
                            erlang:send_after(10, self(), {cross_guard_finish, NewStDun#st_dungeon.dungeon_id, ?KINDOM_NOTICE_STATE_SUCCESS}),
                            CrossGuardDun = NewStDun#st_dungeon.dun_cross_guard,
                            NewStDun1#st_dungeon{
                                dun_cross_guard = CrossGuardDun#dun_cross_guard{cur_floor = Wave}
                            };
                        NewStDun#st_dungeon.kill_list == [] -> %%出现的怪物都杀光了
                            ?DEBUG("Wave ~p~n",[Wave]),
                            UseTime = util:unixtime() - NewStDun#st_dungeon.begin_time,
                            spawn(cross_dungeon_guard_util, update_ets,
                                [[XX || XX <- NewStDun#st_dungeon.player_list, XX#dungeon_mb.node /= none], UseTime, NewStDun#st_dungeon.dungeon_id, NewStDun#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor]),
                            spawn(fun() ->
                                cross_dungeon_guard_util:update_milestone(NewStDun#st_dungeon.player_list, NewStDun#st_dungeon.dungeon_id, NewStDun#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor, UseTime) end),

                            util:cancel_ref([NewStDun#st_dungeon.next_round_timer, NewStDun#st_dungeon.dun_cross_guard#dun_cross_guard.mon_notice_ref]),
                            Ref = erlang:send_after(1000, self(), next_round),
                            RoundTime = util:unixtime() + 10,
                            cross_dungeon_guard_util:mon_refresh_notice(Scene, self(), NewStDun#st_dungeon.dun_cross_guard#dun_cross_guard.cur_floor + 1, 0),
                            self() ! {dungeon_target, 0},

                            CrossGuardDun = NewStDun#st_dungeon.dun_cross_guard,
                            NewStDun#st_dungeon{next_round_timer = Ref, round_time = RoundTime,
                                dun_cross_guard = CrossGuardDun#dun_cross_guard{cur_floor = Wave}};
                        true ->
                            NewStDun
                    end
            end
    end.

cross_guard_kill_guard(StDun, Scene) -> %%跨服试炼副本击杀守卫
    L = mon_agent:get_scene_mon_by_kind(Scene, self(), ?MON_KIND_CROSS_GUARD),
    case [M || M <- L, M#mon.hp > 0] of
        [] ->
            NewStDun = StDun#st_dungeon{is_pass = 0},
            util:cancel_ref([StDun#st_dungeon.close_timer, NewStDun#st_dungeon.next_round_timer, NewStDun#st_dungeon.dun_cross_guard#dun_cross_guard.mon_notice_ref]),
            erlang:send_after(1, self(), {cross_guard_finish, Scene, ?KINDOM_NOTICE_STATE_KILL}),
            cross_dungeon_guard_util:mon_refresh_notice(Scene, self(), -2, 0),
            NewStDun;
        _ ->
            StDun
    end.
cross_guard_kill_mon(StDun, Mid, Wave, X, Y, Scene) -> %%跨服试炼副本击杀普通怪
    KillList =
        case lists:keyfind(Wave, 1, StDun#st_dungeon.kill_list) of
            false -> StDun#st_dungeon.kill_list;
            {Wave, OldKillList} ->
                NewKillList =
                    case lists:keyfind(Mid, 1, OldKillList) of
                        false -> OldKillList;
                        {_, Need, Cur} ->
                            {Wave, lists:keyreplace(Mid, 1, OldKillList, {Mid, Need, Cur + 1})}
                    end,
                lists:keyreplace(Wave, 1, StDun#st_dungeon.kill_list, NewKillList)
        end,
    %%怪物被杀，创建宝箱
    cross_dungeon_guard_util:create_mon_box(Mid, X, Y, self(), Scene),
    MaxFloor = data_dungeon_cross_guard_floor:get_max_floor(Scene),
    %%处理完成击杀的最低N层
    Ff = fun(CheckWave, {AccSt, IsCheck}) ->
        case IsCheck of
            false -> {AccSt, IsCheck};
            true ->
                case lists:keyfind(CheckWave, 1, AccSt#st_dungeon.kill_list) of
                    false -> {AccSt, false};
                    {_, MonList} ->
                        Fm = fun({_MonId, MonNeed, MonCur}, {AccMonNeed, AccMonCur}) ->
                            {AccMonNeed + MonNeed, AccMonCur + MonCur}
                        end,
                        {NeedKill, CurKill} = lists:foldl(Fm, {0, 0}, MonList),
                        if
                            CurKill >= NeedKill -> %%最低一层杀完;
                                BaseGuard = data_dungeon_cross_guard_floor:get(Scene, CheckWave),
                                #base_cross_guard_dun{
                                    goods_list = GoodsList
                                } = BaseGuard,
%%                                 Fr = fun(ScenePlayer) ->
%%                                     catch ScenePlayer#scene_player.pid ! {kindom_guard_add_goods, GoodsList}
%%                                 end,
%%                                 ScenePlayerList = scene_agent:get_copy_scene_player(Scene, self()),
%%                                 lists:foreach(Fr, ScenePlayerList),
                                Now = util:unixtime(),
                                cross_dungeon_guard_util:create_floor_box(CheckWave, Scene, self()),
                                NewGoodsList = ?IF_ELSE(GoodsList == [], StDun#st_dungeon.goods_list, GoodsList),
                                AccSt1 = AccSt#st_dungeon{
                                    kill_list = lists:keydelete(CheckWave, 1, AccSt#st_dungeon.kill_list),
                                    dun_cross_guard = AccSt#st_dungeon.dun_cross_guard#dun_cross_guard{
                                        kill_floor = CheckWave,
                                        kill_floor_time = Now
                                    },
                                    goods_list = NewGoodsList
                                },
                                {AccSt1, true};
                            true ->
                                {AccSt, false}
                        end
                end
        end
    end,
    CheckWaveList = lists:seq(max(1, StDun#st_dungeon.dun_cross_guard#dun_cross_guard.kill_floor + 1), MaxFloor),
    {NewStDun, _} = lists:foldl(Ff, {StDun#st_dungeon{kill_list = KillList}, true}, CheckWaveList),
    NewStDun.
%%******************************%%

%%妖魔入侵副本
demon_kill(StDun, Mid) ->
    Base = data_dungeon_demon:get(StDun#st_dungeon.round),
    case Base == [] of
        true -> StDun;
        false ->
            case lists:keyfind(Mid, 1, Base#base_dun_demon.mon_list) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    NewStDun = StDun#st_dungeon{cur_kill_num = CurKill, kill_list = KillList},
                    [self() ! {dungeon_target, Mb#dungeon_mb.sid} || Mb <- StDun#st_dungeon.player_list],
                    %%击杀完毕
                    if
                        CurKill >= StDun#st_dungeon.need_kill_num ->
                            Exp =
                                case data_dungeon_demon:get(StDun#st_dungeon.round) of
                                    [] -> 0;
                                    BaseDemon -> BaseDemon#base_dun_demon.exp
                                end,
                            NewExp = Exp + StDun#st_dungeon.exp,
                            [DungeonPlayer#dungeon_mb.pid ! {pass_dun_demon_round, StDun#st_dungeon.begin_time, StDun#st_dungeon.round, Exp} || DungeonPlayer <- StDun#st_dungeon.player_list],
                            MaxRound =
                                case StDun#st_dungeon.player_list of
                                    [] -> StDun#st_dungeon.max_round;
                                    [DunMem | _] -> guild_demon:get_max_can_pass_floor(DunMem#dungeon_mb.pid)
                                end,
                            if
                                StDun#st_dungeon.round >= MaxRound ->
                                    util:cancel_ref([StDun#st_dungeon.close_timer]),
                                    Ref = erlang:send_after(1000, self(), dungeon_finish),
                                    NewStDun#st_dungeon{exp = NewExp, is_pass = ?DUNGEON_PASS, close_timer = Ref};
                                true ->
                                    erlang:send_after(200, self(), {next_round}),
                                    NewStDun#st_dungeon{exp = NewExp}
                            end;
                        true ->
                            NewStDun
                    end
            end
    end.

%%vip 副本击杀
vip_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    NewStDun = StDun#st_dungeon{cur_kill_num = CurKill, kill_list = KillList},
                    dungeon_vip:update_vip_dungeon_target(NewStDun),
                    %%击杀完毕
                    if CurKill == StDun#st_dungeon.need_kill_num ->
                        util:cancel_ref([StDun#st_dungeon.close_timer]),
                        Ref = erlang:send_after(1000, self(), dungeon_finish),
                        NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS, close_timer = Ref};
                        true ->
                            NewStDun
                    end
            end
    end.

%%转职 副本击杀
change_career_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    KillList =
                        case lists:keyfind(Mid, 1, StDun#st_dungeon.kill_list) of
                            false -> StDun#st_dungeon.kill_list;
                            {_, Need, Cur} ->
                                lists:keyreplace(Mid, 1, StDun#st_dungeon.kill_list, {Mid, Need, Cur + 1})
                        end,
                    NewStDun = StDun#st_dungeon{cur_kill_num = CurKill, kill_list = KillList},
                    dungeon_change_career:update_change_career_dungeon_target(NewStDun),
                    %%击杀完毕
                    if CurKill == StDun#st_dungeon.need_kill_num ->
                        util:cancel_ref([StDun#st_dungeon.close_timer]),
                        Ref = erlang:send_after(1000, self(), dungeon_finish),
                        NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS, close_timer = Ref};
                        true ->
                            NewStDun
                    end
            end
    end.

%% 符文副本击杀
fuwen_tower_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    %%击杀完毕
                    if CurKill >= StDun#st_dungeon.need_kill_num ->
                        util:cancel_ref([StDun#st_dungeon.close_timer]),
                        Ref = erlang:send_after(1000, self(), dungeon_finish),
                        StDun#st_dungeon{cur_kill_num = CurKill, is_pass = ?DUNGEON_PASS, close_timer = Ref};
                        true ->
                            StDun#st_dungeon{cur_kill_num = CurKill}
                    end
            end
    end.


%% 爱情试炼副本击杀
dun_marry_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    %%击杀完毕
                    if
                        CurKill >= StDun#st_dungeon.need_kill_num ->
                            MaxRound = data_dungeon_marry:max_round(),
                            if
                                StDun#st_dungeon.round >= MaxRound ->
                                    erlang:send_after(200, self(), {next_round}),
                                    StDun#st_dungeon{cur_kill_num = CurKill, is_pass = ?DROP_TYPE_PASS};
                                true ->
                                    erlang:send_after(200, self(), {next_round}),
                                    StDun#st_dungeon{cur_kill_num = CurKill}
                            end;
                        true ->
                            StDun#st_dungeon{cur_kill_num = CurKill}
                    end
            end
    end.

%% 仙装副本击杀
xian_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    %%击杀完毕
                    if CurKill >= StDun#st_dungeon.need_kill_num ->
                        util:cancel_ref([StDun#st_dungeon.close_timer]),
                        Ref = erlang:send_after(1000, self(), dungeon_finish),
                        StDun#st_dungeon{cur_kill_num = CurKill, is_pass = ?DUNGEON_PASS, close_timer = Ref};
                        true ->
                            StDun#st_dungeon{cur_kill_num = CurKill}
                    end
            end
    end.

%% 神祇副本击杀
godness_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    %%击杀完毕
                    if
                        CurKill >= StDun#st_dungeon.need_kill_num ->
                            util:cancel_ref([StDun#st_dungeon.close_timer]),
                            Ref = erlang:send_after(1000, self(), dungeon_finish),
                            StDun#st_dungeon{cur_kill_num = CurKill, is_pass = ?DUNGEON_PASS, close_timer = Ref};
                        true ->
                            StDun#st_dungeon{cur_kill_num = CurKill}
                    end
            end
    end.

%% 精英boss副本击杀
elite_boss_kill(StDun, Mid) ->
    case lists:keyfind(StDun#st_dungeon.round, 1, StDun#st_dungeon.mon) of
        false -> StDun;
        {_, MonList} ->
            case lists:keyfind(Mid, 1, MonList) of
                false -> StDun;
                _ ->
                    CurKill = StDun#st_dungeon.cur_kill_num + 1,
                    %%击杀完毕
                    if
                        CurKill >= StDun#st_dungeon.need_kill_num ->
                            util:cancel_ref([StDun#st_dungeon.close_timer]),
                            Ref = erlang:send_after(1000, self(), dungeon_finish),
                            StDun#st_dungeon{cur_kill_num = CurKill, is_pass = ?DUNGEON_PASS, close_timer = Ref};
                        true ->
                            StDun#st_dungeon{cur_kill_num = CurKill}
                    end
            end
    end.

%% 守护副本击杀
guard_kill(StDun, Mid, Extra) ->
    MaxRound = StDun#st_dungeon.dun_guard#dun_guard.round, %% 当前最大波数
    Wave =
        case lists:keyfind(wave, 1, Extra) of
            false -> 0;
            {_, Wave0} -> Wave0
        end,
    {GodId, _X, _Y} = dungeon_guard:get_god_mon(),
    case Mid == GodId of
        true -> %% 女神被杀
            NewStDun = StDun#st_dungeon{is_pass = 0},
            util:cancel_ref([StDun#st_dungeon.close_timer]),
            erlang:send_after(100, self(), dungeon_finish),
            NewStDun;
        false ->
            KillList =
                case lists:keyfind(Wave, 1, StDun#st_dungeon.kill_list) of
                    false -> StDun#st_dungeon.kill_list;
                    {Wave, OldKillList} ->
                        NewKillList0 =
                            case lists:keyfind(Mid, 1, OldKillList) of
                                false -> OldKillList;
                                {_, Need, Cur} ->
                                    {Wave, lists:keyreplace(Mid, 1, OldKillList, {Mid, Need, Cur + 1})}
                            end,
                        lists:keyreplace(Wave, 1, StDun#st_dungeon.kill_list, NewKillList0)
                end,
            [self() ! {dungeon_target, Mb#dungeon_mb.pid} || Mb <- StDun#st_dungeon.player_list],

            case KillList of
                [] -> CurKill = 0, NeedKill = 1;
                _ ->
                    case lists:keyfind(Wave, 1, KillList) of
                        false -> CurKill = 0, NeedKill = 1;
                        {Wave, MonList} ->
                            F = fun({_MonId, MonNeed, MonCur}, {AccMonNeed, AccMonCur}) ->
                                {AccMonNeed + MonNeed, AccMonCur + MonCur}
                            end,
                            {NeedKill, CurKill} = lists:foldl(F, {0, 0}, MonList)
                    end
            end,
            NewStDun =
                if
                    CurKill >= NeedKill -> %% 某一层杀完
                        {KillFloor, NewKillList} = get_index_round(KillList, Wave, MaxRound),
                        Mb = hd(StDun#st_dungeon.player_list),
                        Reward = data_dungeon_guard:get_reward_list(Wave),
                        GuardDun = StDun#st_dungeon.dun_guard,
                        Now = util:unixtime(),
                        catch Mb#dungeon_mb.pid ! {update_guard_pass_wave, KillFloor, Wave, StDun#st_dungeon.dun_guard#dun_guard.start_floor},
                        util:cancel_ref([StDun#st_dungeon.close_timer]),
                        Ref0 = erlang:send_after(300 * 1000, self(), dungeon_finish),
                        StDun#st_dungeon{
                            kill_list = NewKillList,
                            goods_list = StDun#st_dungeon.goods_list ++ Reward,
                            dun_guard = GuardDun#dun_guard{kill_floor = KillFloor, kill_floor_time = Now},
                            coin = StDun#st_dungeon.coin + 1,
                            exp = StDun#st_dungeon.exp + 1,
                            end_time = Now + 300,
                            close_timer = Ref0
                        };
                    true ->
                        StDun#st_dungeon{
                            kill_list = KillList
                        }
                end,
            MaxFloor = data_dungeon_guard:get_max_floor(),
            if
                NewStDun#st_dungeon.dun_guard#dun_guard.kill_floor >= MaxFloor -> %%通关
                    util:cancel_ref([StDun#st_dungeon.next_round_timer]),
                    Ref = erlang:send_after(1000, self(), dungeon_finish),
                    NewStDun#st_dungeon{is_pass = ?DUNGEON_PASS, close_timer = Ref};
                NewStDun#st_dungeon.kill_list == [] -> %%出现的怪物都杀光了
                    Mb0 = hd(StDun#st_dungeon.player_list),
                    {ok, Bin} = pt_121:write(12196, {1}),
                    server_send:send_to_sid(Mb0#dungeon_mb.sid, Bin),
                    util:cancel_ref([NewStDun#st_dungeon.next_round_timer]),
                    Ref = erlang:send_after(3000, self(), {time_to_next_round}),
                    RoundTime = util:unixtime() + 3,
                    NewStDun#st_dungeon{next_round_timer = Ref, round_time = RoundTime};
                true ->
                    NewStDun
            end
    end.

get_index_round(KillList, Wave, MaxRound) ->
    case KillList of
        [] -> {MaxRound, []};
        _ ->
            NewKillList = lists:keydelete(Wave, 1, KillList),
            case NewKillList of
                [] -> {MaxRound, []};
                [{MinRound, _MonList} | _Tail] -> {MinRound, NewKillList}
            end
    end.
