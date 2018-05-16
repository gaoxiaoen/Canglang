%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 五月 2016 14:48
%%%-------------------------------------------------------------------
-module(field_boss_handle).
-author("hxming").

-include("field_boss.hrl").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("battle.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).


handle_call(_Msg, _from, State) ->
    ?ERR("handle call nomatch ~p~n", [_Msg]),
    {reply, ok, State}.

%%获取boss状态
handle_cast({get_state_info, Sid}, State) ->
    Now = util:unixtime(),
    {St, LeaveTime} =
        if
            State#st_field_boss.state == 0 -> {0, 0};
            State#st_field_boss.state == 1 andalso State#st_field_boss.end_time > Now ->
                {1, State#st_field_boss.end_time - Now};
            State#st_field_boss.state == 1 -> {0, 0};
            State#st_field_boss.state == 2 ->
                {2, max(0, State#st_field_boss.end_time - Now)}
        end,
    {ok, Bin} = pt_560:write(56011, {St, LeaveTime}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%获取周排名信息
handle_cast({get_week_rank, Node, Sid, RankList}, State) ->
    AllId = data_field_boss:ids(),
    F = fun(Sceneid, AccList) ->
        B = data_field_boss:get(Sceneid),
        case B#field_boss.type == ?SERVER_TYPE_CROSS of
            true ->
                [field_boss:get_rank_player_info(Sceneid) | AccList];
            false ->
                AccList
        end
        end,
    RankPlayerList = lists:foldl(F, [], AllId),
    {ok, Bin} = pt_560:write(56004, {RankList ++ RankPlayerList}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%同步单服排行信息
handle_cast({sync_node_rank, FPointList}, State) ->
    F = fun(FPoint) ->
        field_boss:update_ets_point(FPoint)
        end,
    lists:foreach(F, FPointList),
    {noreply, State};

%%增加roll
handle_cast({add_roll, Mkey, Mid, SceneId, Copy}, State) ->
    field_boss_roll:create_roll(Mkey, Mid, SceneId, Copy),
    {noreply, State};

%%开始roll
handle_cast({start_roll, Mkey}, State) ->
    field_boss_roll:refresh_roll(Mkey),
    {noreply, State};

handle_cast(_Msg, State) ->
    ?ERR("handle cast nomatch ~p~n", [_Msg]),
    {noreply, State}.


handle_info(refresh_all, State) ->
    util:cancel_ref([State#st_field_boss.ref]),
    field_boss:refresh_boss_all(),
    NextRefreshTime = field_boss:get_next_refresh_time(),
    Ref = erlang:send_after(NextRefreshTime * 1000, self(), refresh_all),
    {ReadyTime, Time} =
        case NextRefreshTime > ?READY_TIME of
            true -> {(NextRefreshTime - ?READY_TIME), ?READY_TIME};
            false -> {1, NextRefreshTime}
        end,
    ReadyRef = erlang:send_after(ReadyTime * 1000, self(), {ready_refresh, Time}),
    %%刷新通知
    {ok, Bin} = pt_560:write(56011, {1, 1800}),
    spawn(fun() -> timer:sleep(3000), server_send:send_to_all(Bin) end),
    EndRef = erlang:send_after(1800 * 1000, self(), refresh_end),
    {noreply, State#st_field_boss{ref = Ref, state = 1, end_time = util:unixtime() + 1800, ready_ref = ReadyRef, end_ref = EndRef}};

handle_info({ready_refresh, Time}, State) ->
    util:cancel_ref([State#st_field_boss.ready_ref]),
    %%刷新通知
    {ok, Bin} = pt_560:write(56011, {2, Time}),
    spawn(fun() -> server_send:send_to_all(Bin) end),
    {noreply, State#st_field_boss{state = 2, end_time = util:unixtime() + Time}};

handle_info(refresh_end, State) ->
    util:cancel_ref([State#st_field_boss.end_ref]),
    %%刷新通知
    {ok, Bin} = pt_560:write(56011, {0, 0}),
    spawn(fun() -> server_send:send_to_all(Bin) end),
    spawn(fun() -> field_boss:updb() end),
    {noreply, State#st_field_boss{state = 0, end_time = 0}};

%%更新boss气血
handle_info({update_field_boss, SceneId, Hp, LimHp, KList, AttKey, FieldBossTimes}, State) ->
    case field_boss:get_ets_boss(SceneId) of
        [] -> ok;
        Boss ->
            if
                Boss#field_boss.boss_state == ?FIELD_BOSS_CLOSE -> ok;
                true ->
                    DamageList = field_boss:rank_damage_list(SceneId, KList, Boss#field_boss.damage_list, LimHp, Hp, Boss#field_boss.lv),
                    if
                        Hp =< 0 ->
                            spawn(fun() -> field_boss:log_join(Boss#field_boss.boss_id, DamageList) end),
                            NewBoss = Boss#field_boss{boss_state = ?FIELD_BOSS_CLOSE, damage_list = DamageList, kill_pkey = AttKey},
                            field_boss:sync_cross_field_boss(NewBoss),
                            %%发送积分
                            field_boss:reward_point(NewBoss),
                            %%击杀奖励
                            spawn(fun() -> timer:sleep(1500), field_boss:kill_mon(NewBoss, FieldBossTimes) end),
                            spawn(fun() -> timer:sleep(3000), field_boss:sync_node_rank(SceneId) end),
                            spawn(fun() -> timer:sleep(2000), field_boss:notice_field_boss(SceneId) end),
                            ets:insert(?ETS_FIELD_BOSS, NewBoss);
                        true ->
                            NewBoss = Boss#field_boss{damage_list = DamageList},
                            field_boss:sync_cross_field_boss(NewBoss),
                            ets:insert(?ETS_FIELD_BOSS, NewBoss)
                    end
            end
    end,
    {noreply, State};

%%定时检查
handle_info({check_time, NowTime}, State) ->
    {_, {H, _, _}} = util:seconds_to_localtime(NowTime),
    case H == 1 of
        true -> %%晚上凌晨1点，检查已切换掉的服
            case center:is_center_area() of
                false -> skip;
                true ->
                    F = fun(FPoint) ->
                        case center:get_node_by_sn(FPoint#f_point.sn) of
                            false ->
                                ets:delete(?ETS_FIELD_BOSS_POINT, FPoint#f_point.pkey);
                            _ -> ok
                        end
                        end,
                    lists:foreach(F, ets:tab2list(?ETS_FIELD_BOSS_POINT)),
                    ok
            end,
            %%同步各排行
            F1 = fun(SceneId) ->
                B = data_field_boss:get(SceneId),
                case B#field_boss.type == ?SERVER_TYPE_CROSS of
                    false -> skip;
                    true -> field_boss:sync_rank_to_corss(SceneId)
                end
                 end,
            lists:foreach(F1, data_field_boss:ids()),
            ok;
        false ->
            skip
    end,
    %%礼拜天 晚上 11点 发周榜奖励
    WeekDay = util:get_day_of_week(NowTime),
    case WeekDay == 7 andalso H == 23 of
        true ->
            field_boss:week_rank_reward(),
            spawn(fun() -> timer:sleep(5000), Sql = io_lib:format("truncate player_field_point;", []),
                db:execute(Sql) end),
            ok;
        false ->
            ok
    end,
    {noreply, State};

%%roll时间到
handle_info({roll_time_end, Mkey}, State) ->
    field_boss_roll:open_roll(Mkey),
    {noreply, State};

handle_info(_Msg, State) ->
    ?ERR("handle info nomatch ~p~n", [_Msg]),
    {noreply, State}.
