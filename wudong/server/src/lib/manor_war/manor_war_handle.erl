%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十二月 2016 10:07
%%%-------------------------------------------------------------------
-module(manor_war_handle).
-author("hxming").

-include("common.hrl").
-include("manor_war.hrl").
-include("battle.hrl").
-include("server.hrl").
-include("guild.hrl").
-include("scene.hrl").
%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

%%查询活动状态
handle_call(get_state, _From, State) ->
    {reply, State#st_manor_war.war_state, State};

handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

%%查询活动状态
handle_cast({check_state, Sid, Now}, State) ->
    if State#st_manor_war.war_state == ?MANOR_WAR_STATE_CLOSE ->
        skip;
        true ->
            LeftTime = max(0, State#st_manor_war.end_time - Now),
            {ok, Bin} = pt_402:write(40201, {State#st_manor_war.war_state, LeftTime}),
            server_send:send_to_sid(Sid, Bin)
    end,
    {noreply, State};

%%查询领地占领状态
handle_cast({manor_state, Sid, _Gkey}, State) ->
    F = fun(SceneId) ->
        case ets:lookup(?ETS_MANOR, SceneId) of
            [] ->
                [SceneId, <<>>];
            [Manor] ->
                [SceneId, Manor#manor.name]
        end
        end,
    SceneInfo = lists:map(F, data_manor_war_scene:scene_list()),
    LeftTime = max(0, State#st_manor_war.end_time - util:unixtime()),
    IsApply = 1,
    {ok, Bin} = pt_402:write(40202, {State#st_manor_war.war_state, LeftTime, IsApply, SceneInfo}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%%初始化
handle_info(init, State) ->
    manor_war_init:init(),
    erlang:send_after(10 * 1000, self(), timer_update),
    {noreply, State};

handle_info(timer_update, State) ->
    manor_war_init:timer_update(),
    erlang:send_after(300 * 1000, self(), timer_update),
    {noreply, State};

%%每日定时器重置
handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_manor_war.ref]),
    NewState = manor_war_proc:set_timer(Now, State),
    case lists:member(util:get_day_of_week(Now), data_manor_war_time:get_week()) of
        false ->
            manor_war_task:midnight_refresh();
        true ->
            ok
    end,
    {noreply, NewState};

%%准备通知
handle_info({ready, ReadyTime, LastTime}, State) when State#st_manor_war.war_state == ?MANOR_WAR_STATE_CLOSE ->
    ?DEBUG("manor war ready ~p~n", [ReadyTime]),
    F = fun(Sid) ->
        MonList = mon_agent:get_scene_mon_by_kind(Sid, 0, ?MON_KIND_MANOR_PARTY_TABLE) ++ mon_agent:get_scene_mon_by_kind(Sid, 0, ?MON_KIND_MANOR_PARTY_VIEW),
        [monster:stop_broadcast(Mon#mon.pid) || Mon <- MonList]
        end,
    lists:foreach(F, data_manor_war_scene:scene_list()),

    util:cancel_ref([State#st_manor_war.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_402:write(40201, {?MANOR_WAR_STATE_READY, ReadyTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_manor_war{war_state = ?MANOR_WAR_STATE_READY, end_time = Now + ReadyTime, ref = Ref},
    notice_sys:add_notice(manor_war_ready, []),
    {noreply, NewState};

%%领地战开始
handle_info({start, LastTime}, State) when State#st_manor_war.war_state /= ?MANOR_WAR_STATE_START ->
    ?DEBUG("manor war start ~p~n", [LastTime]),

    util:cancel_ref([State#st_manor_war.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_402:write(40201, {?MANOR_WAR_STATE_START, LastTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
%%    manor_war_init:upgrade_manor_war(1),
    manor_war_init:clean_manor_war(),
    manor_war_init:clean_manor(),

    manor_war:create_flag_all(),
    manor_war:refresh_boss(),
    NewState = State#st_manor_war{war_state = ?MANOR_WAR_STATE_START, end_time = Now + LastTime, ref = Ref},
    notice_sys:add_notice(manor_war_start, []),
    %%玩法找回
    findback_src:update_act_time(36, Now, []),
    ets:insert(?ETS_MANOR_WAR_STATE, {Now + LastTime}),
%%    manor_war:change_pk(),
    {noreply, NewState};

%%领地战结束
handle_info(close, State) ->
    ?DEBUG("manor war close ~p~n", [ok]),
    util:cancel_ref([State#st_manor_war.ref]),
    {ok, Bin} = pt_402:write(40201, {?MANOR_WAR_STATE_CLOSE, 0}),
    server_send:send_to_all(Bin),
    manor_war:clean_mon(),
    manor_war_init:upgrade_manor_final(),
    manor_war_score:score_reward(),
    NewState = State#st_manor_war{war_state = ?MANOR_WAR_STATE_CLOSE},
    ets:delete_all_objects(?ETS_MANOR_WAR_STATE),
    [scene_copy_proc:set_default(Sid, false) || Sid <- data_manor_war_scene:scene_list()],
    {noreply, NewState};

%%更新旗帜
handle_info({update_flag, SceneId, KList, Attacker}, State) when State#st_manor_war.war_state == ?MANOR_WAR_STATE_START ->
    manor_war_score:calc_hurt_flag_score(KList),
    case Attacker of
        false -> ok;
        _ ->
            manor_war_score:calc_kill_flag_score(Attacker),
            manor_war:refresh_flag(SceneId, Attacker),
            manor_war:upgrade_manor(SceneId, Attacker),
            notice_sys:add_notice(manor_war_flag, [Attacker#attacker.gkey, Attacker#attacker.gname, Attacker#attacker.key, Attacker#attacker.name, Attacker#attacker.vip, SceneId])

    end,
    {noreply, State};

%%击杀玩家
handle_info({kill_role, Attacker}, State) when State#st_manor_war.war_state == ?MANOR_WAR_STATE_START ->
    manor_war_score:kill_role_score(Attacker),
    {noreply, State};

%%{refresh_boss, BossId, Sid, X, Y}
handle_info({refresh_boss, BossId, SceneId, X, Y}, State) when State#st_manor_war.war_state == ?MANOR_WAR_STATE_START ->
    WorldLv = rank:get_world_lv(),
    mon_agent:create_mon_cast([BossId, SceneId, X, Y, 0, 1, [{type, ?ATTACK_TENDENCY_PEACE}, {world_lv_mon, WorldLv}]]),
    notice_sys:add_notice(manor_war_boss, [BossId, SceneId, X, Y]),
    {noreply, State};

handle_info({refresh_boss_msg, BossId, SceneId, Time}, State) when State#st_manor_war.war_state == ?MANOR_WAR_STATE_START ->
    notice_sys:add_notice(manor_war_boss_ready, [BossId, SceneId, Time]),
    {noreply, State};

handle_info({kill_boss, BossId, SceneId, Attacker, KeyList}, State) when State#st_manor_war.war_state == ?MANOR_WAR_STATE_START ->
    manor_war:refresh_boss(),
    manor_war_score:kill_boss_score(Attacker, KeyList),
    Base = data_manor_war_scene:get(SceneId),
    WorldLv = rank:get_world_lv(),
    Args = [{guild_key, Attacker#attacker.gkey}, {life, 30}, {show_time, 30 + util:unixtime()}, {world_lv_mon, WorldLv}, {mon_name, Attacker#attacker.gname}],
    {NewX, NewY} = scene:random_xy(SceneId, Base#base_manor_war.flag_x, Base#base_manor_war.flag_y),
    mon_agent:create_mon_cast([BossId, SceneId, NewX, NewY, 0, 1, Args]),
    notice_sys:add_notice(manor_war_boss_kill, [BossId, Attacker#attacker.gkey, Attacker#attacker.gname, Attacker#attacker.key, Attacker#attacker.name, Attacker#attacker.vip, SceneId]),
    {noreply, State};

handle_info({party_drop, Gkey, X, Y}, State) ->
    misc:cancel_timer({do_party_drop, Gkey}),
    Ref = erlang:send_after(?MANOR_WAR_PARTY_DROP_TIME * 1000, self(), {do_party_drop, Gkey, X, Y}),
    put({do_party_drop, Gkey}, Ref),
    {noreply, State};

handle_info({do_party_drop, Gkey, X, Y}, State) ->
    misc:cancel_timer({do_party_drop, Gkey}),
    case manor_war_party:party_drop(Gkey, X, Y) of
        true ->
            Ref = erlang:send_after(?MANOR_WAR_PARTY_DROP_TIME * 1000, self(), {do_party_drop, Gkey, X, Y}),
            put({do_party_drop, Gkey}, Ref),
            {noreply, State};
        false ->
            {noreply, State}
    end;



handle_info(_Msg, State) ->
    ?DEBUG("udef _msg ~p/~p~n", [_Msg, State#st_manor_war.war_state]),
    {noreply, State}.
