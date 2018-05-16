%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 五月 2016 14:31
%%%-------------------------------------------------------------------
-module(cross_battlefield_handle).
-author("hxming").
-include("common.hrl").
-include("scene.hrl").
-include("cross_battlefield.hrl").
%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

-define(TIMER, 30).
-define(TOP_MON_TIMER, 180).

handle_call(_msg, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {reply, ok, State}.

%%查询活动状态
handle_cast({check_state, Node, Sid, Now}, State) ->
    if State#st_cross_battlefield.open_state == ?CROSS_BATTLEFIELD_STATE_CLOSE -> skip;
        true ->
            {ok, Bin} = pt_550:write(55001, {State#st_cross_battlefield.open_state, max(0, State#st_cross_battlefield.time - Now)}),
            server_send:send_to_sid(Node, Sid, Bin)
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
    end,
    {noreply, State};

handle_cast({check_rank, Node, Pkey, Sid, Page}, State) ->
    if State#st_cross_battlefield.open_state == ?CROSS_BATTLEFIELD_STATE_START ->
        handle_cast({check_rank_now, Node, Pkey, Sid, Page}, State);
        true ->
            handle_cast({check_rank_last, Node, Pkey, Sid, Page}, State)
    end;

%%排行榜
handle_cast({check_rank_last, Node, Pkey, Sid, Page}, State) ->
    F = fun(Mb) ->
        [Mb#cross_bf_mb.rank, Mb#cross_bf_mb.pf, Mb#cross_bf_mb.sn, Mb#cross_bf_mb.nickname, Mb#cross_bf_mb.score, Mb#cross_bf_mb.layer_h, Mb#cross_bf_mb.acc_kill, Mb#cross_bf_mb.acc_combo_kill]
        end,
    Len = length(State#st_cross_battlefield.rank_list),
    MaxPage = ?IF_ELSE(Len >= 100, 10, util:ceil(Len / 10)),
    NowPage = ?IF_ELSE(Page =< 0 orelse Page > MaxPage, 1, Page),
    List = lists:map(F, lists:sublist(State#st_cross_battlefield.rank_list, NowPage * 10 - 9, 10)),
    {Score, Rank, Layer, AccKill, AccCombo} =
        case lists:keyfind(Pkey, #cross_bf_mb.pkey, State#st_cross_battlefield.rank_list) of
            false -> {0, 0, 0, 0, 0};
            Mb ->
                {Mb#cross_bf_mb.score, Mb#cross_bf_mb.rank, Mb#cross_bf_mb.layer_h, Mb#cross_bf_mb.acc_kill, Mb#cross_bf_mb.acc_combo_kill}
        end,
    {ok, Bin} = pt_550:write(55007, {NowPage, MaxPage, Score, Rank, Layer, AccKill, AccCombo, List}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast({check_rank_now, Node, Pkey, Sid, Page}, State) ->
    MbList = [Mb || {_, Mb} <- dict:to_list(State#st_cross_battlefield.p_dict)],
    MbList1 = lists:keysort(#cross_bf_mb.score, MbList),
    F = fun(Mb, {Rank, L}) ->
        {Rank + 1, L ++ [Mb#cross_bf_mb{rank = Rank}]}
        end,
    {_, MbList2} = lists:foldr(F, {1, []}, MbList1),

    F1 = fun(Mb) ->
        [Mb#cross_bf_mb.rank, Mb#cross_bf_mb.pf, Mb#cross_bf_mb.sn, Mb#cross_bf_mb.nickname, Mb#cross_bf_mb.score, Mb#cross_bf_mb.layer_h, Mb#cross_bf_mb.acc_kill, Mb#cross_bf_mb.acc_combo_kill]
         end,

    Len = length(MbList),
    MaxPage = ?IF_ELSE(Len >= 100, 10, util:ceil(Len / 10)),
    NowPage = ?IF_ELSE(Page =< 0 orelse Page > MaxPage, 1, Page),
    List = lists:map(F1, lists:sublist(MbList2, NowPage * 10 - 9, 10)),

    {Score, Rank, Layer, AccKill, AccCombo} =
        case lists:keyfind(Pkey, #cross_bf_mb.pkey, MbList2) of
            false -> {0, 0, 0, 0, 0};
            Mb ->
                {Mb#cross_bf_mb.score, Mb#cross_bf_mb.rank, Mb#cross_bf_mb.layer_h, Mb#cross_bf_mb.acc_kill, Mb#cross_bf_mb.acc_combo_kill}
        end,
    {ok, Bin} = pt_550:write(55007, {NowPage, MaxPage, Score, Rank, Layer, AccKill, AccCombo, List}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};


%%检查进入
handle_cast({check_enter, Mb}, State) ->
    {Ret, NewState} =
        if State#st_cross_battlefield.open_state /= ?CROSS_BATTLEFIELD_STATE_START ->
            {4, State};
            true ->
                Mb1 =
                    case dict:is_key(Mb#cross_bf_mb.pkey, State#st_cross_battlefield.p_dict) of
                        false -> Mb;
                        true ->
                            Old = dict:fetch(Mb#cross_bf_mb.pkey, State#st_cross_battlefield.p_dict),
                            Score = cross_battlefield:calc_score_for_quit(Old#cross_bf_mb.score, Old#cross_bf_mb.layer, Old#cross_bf_mb.quit_time),
                            Old#cross_bf_mb{pid = Mb#cross_bf_mb.pid, sid = Mb#cross_bf_mb.sid, score = Score, quit_time = 0}
                    end,
                Copy = cross_battlefield:match_copy(Mb1#cross_bf_mb.layer, State#st_cross_battlefield.p_dict),
                NewMb = Mb1#cross_bf_mb{copy = Copy},
                Dict = dict:store(NewMb#cross_bf_mb.pkey, NewMb, State#st_cross_battlefield.p_dict),
                Msg = {enter_cross_battlefield, NewMb#cross_bf_mb.layer, Copy},
                server_send:send_node_pid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.pid, Msg),
                {1, State#st_cross_battlefield{p_dict = Dict}}
        end,
    {ok, Bin} = pt_550:write(55002, {Ret}),
    server_send:send_to_sid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.sid, Bin),
%%    center:apply(Mb#cross_bf_mb.node, server_send, send_to_sid, [Mb#cross_bf_mb.sid, Bin]),
    {noreply, NewState};


%%检查退出
handle_cast({check_quit, Pkey, _Type}, State) ->
    NewState =
        case dict:is_key(Pkey, State#st_cross_battlefield.p_dict) of
            false ->
                State;
            true ->
                Mb = dict:fetch(Pkey, State#st_cross_battlefield.p_dict),
                NewMb = Mb#cross_bf_mb{quit_time = util:unixtime(), pid = none, sid = {}},
                Dict = dict:store(Pkey, NewMb, State#st_cross_battlefield.p_dict),
                MaxLayer = cross_battlefield:max_layer(),
                if MaxLayer =/= Mb#cross_bf_mb.layer ->
                    State#st_cross_battlefield{p_dict = Dict};
                    true ->
                        case lists:keytake(Mb#cross_bf_mb.pkey, #cross_bf_box.pkey, State#st_cross_battlefield.box_list) of
                            false ->
                                State#st_cross_battlefield{p_dict = Dict};
                            {value, Box, T} ->
                                misc:cancel_timer({reset_top_box, Box#cross_bf_box.copy}),
                                Timer = data_cross_battlefield_top:logout_refresh_time(),
%%                                 notice_sys:add_notice(cross_bf_box_ready1, [data_cross_battlefield_top:logout_refresh_time()]),
                                Ref1 = erlang:send_after(Timer * 1000, self(), {reset_top_box, Box#cross_bf_box.copy, quit}),
                                put({reset_top_box, Box#cross_bf_box.copy}, Ref1),
                                BoxList = [#cross_bf_box{copy = Box#cross_bf_box.copy, refresh_time = util:unixtime() + Timer} | T],
                                State#st_cross_battlefield{p_dict = Dict, box_list = BoxList}
                        end
                end
        end,
    {noreply, NewState};

%%挑战信息
handle_cast({check_info, Pkey}, State) ->
    if State#st_cross_battlefield.open_state == ?CROSS_BATTLEFIELD_STATE_START ->
        case dict:is_key(Pkey, State#st_cross_battlefield.p_dict) of
            false -> skip;
            true ->
                Mb = dict:fetch(Pkey, State#st_cross_battlefield.p_dict),
                Now = util:unixtime(),
                LeftTime = max(0, State#st_cross_battlefield.time - Now),
                {Sn, Nickname} = State#st_cross_battlefield.first_info,
                MaxLayer = cross_battlefield:max_layer(),
                {BoxTime, BoxNickname, BuffId} =
                    if Mb#cross_bf_mb.layer =/= MaxLayer -> {0, <<>>, 0};
                        Now < State#st_cross_battlefield.box_first_time ->
                            {State#st_cross_battlefield.box_first_time - Now, <<>>, 0};
                        true ->
                            case lists:keyfind(Mb#cross_bf_mb.copy, #cross_bf_box.copy, State#st_cross_battlefield.box_list) of
                                false -> {0, <<>>, 0};
                                Box ->
                                    {max(0, Box#cross_bf_box.refresh_time - Now), Box#cross_bf_box.nickname, Box#cross_bf_box.buff_id}
                            end
                    end,
                DieLim = data_cross_battlefield:drop_layer_ratio(Mb#cross_bf_mb.layer),
                {ok, Bin} = pt_550:write(55004, {Mb#cross_bf_mb.layer, Mb#cross_bf_mb.score, Mb#cross_bf_mb.kill, LeftTime, Sn, Nickname, BoxTime, BoxNickname, BuffId, Mb#cross_bf_mb.acc_die, DieLim}),
                server_send:send_to_sid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.sid, Bin),
%%                center:apply(Mb#cross_bf_mb.node, server_send, send_to_sid, [Mb#cross_bf_mb.sid, Bin]),
                ok
        end;
        true -> skip
    end,
    {noreply, State};

%%击杀玩家
handle_cast({kill, SceneId, _Copy, DieKey, KillerKey}, State) ->
    if State#st_cross_battlefield.open_state == ?CROSS_BATTLEFIELD_STATE_START ->
        {Dict, DieMb} = die(DieKey, State#st_cross_battlefield.p_dict),
        NewState =
            case dict:is_key(KillerKey, Dict) of
                false ->
                    State#st_cross_battlefield{p_dict = Dict};
                true ->
                    Mb = kill(SceneId, KillerKey, Dict, State),
                    BoxList =
                        case lists:keytake(DieKey, #cross_bf_box.pkey, State#st_cross_battlefield.box_list) of
                            false ->
                                State#st_cross_battlefield.box_list;
                            {value, Box, T} ->
                                ?DO_IF(DieMb#cross_bf_mb.pid /= none, server_send:send_node_pid(DieMb#cross_bf_mb.node, DieMb#cross_bf_mb.pid, {cross_bf_buff, 0, Box#cross_bf_box.buff_id})),
                                ?DO_IF(Mb#cross_bf_mb.pid /= none, server_send:send_node_pid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.pid, {cross_bf_buff, Box#cross_bf_box.buff_id, 0})),
                                [Box#cross_bf_box{pkey = KillerKey, nickname = Mb#cross_bf_mb.nickname} | T]
                        end,
                    NewDict = dict:store(KillerKey, Mb, Dict),
                    State#st_cross_battlefield{p_dict = NewDict, box_list = BoxList}
            end,
        {noreply, NewState};
        true ->
            {noreply, State}
    end;

%%击杀怪物
handle_cast({check_kill_mon, SceneId, Pkey}, State) ->
    if State#st_cross_battlefield.open_state == ?CROSS_BATTLEFIELD_STATE_START ->
        Dict = kill_mon(SceneId, State#st_cross_battlefield.p_dict, Pkey, State),
        {noreply, State#st_cross_battlefield{p_dict = Dict}};
        true ->
            {noreply, State}
    end;

handle_cast({crash_buff, Node, Pid, Sid, Mkey, SceneId, Copy, X, Y}, State) ->
    BuffList =
        case lists:keytake(Mkey, 1, State#st_cross_battlefield.buff_list) of
            false ->
                mon_util:hide_mon(Mkey, Node, Sid),
                State#st_cross_battlefield.buff_list;
            {value, {Mkey, Mpid, Mid, M_SceneId, M_CopyId, M_X, M_Y}, T} ->
                if SceneId == M_SceneId andalso Copy == M_CopyId ->
                    case abs(M_X - X) =< 2 andalso abs(M_Y - Y) =< 2 of
                        true ->
                                catch monster:stop_broadcast(Mpid),
                            case data_cross_battlefield_mon_buff:get(Mid) of
                                [] -> ok;
                                BuffId ->
                                    server_send:send_node_pid(Node, Pid, {buff, BuffId})
                            end,
                            RefreshTime = data_cross_battlefield:buff_time(SceneId),
                            misc:cancel_timer({refresh_buff, SceneId, Copy, X, Y}),
                            Ref = erlang:send_after(RefreshTime * 1000, self(), {refresh_buff, SceneId, Copy, X, Y}),
                            put({refresh_buff, SceneId, Copy, X, Y}, Ref),
                            T;
                        false ->
                            State#st_cross_battlefield.buff_list
                    end;
                    true ->
                        State#st_cross_battlefield.buff_list
                end
        end,
    {noreply, State#st_cross_battlefield{buff_list = BuffList}};

%%采集顶层宝箱
handle_cast({check_collect_box, Pkey, Copy}, State) when State#st_cross_battlefield.open_state == ?CROSS_BATTLEFIELD_STATE_START ->
    NewState =
        case dict:is_key(Pkey, State#st_cross_battlefield.p_dict) of
            false ->
                MaxLayer = cross_battlefield:max_layer(),
                cross_battlefield:refresh_top_layer_box(MaxLayer, [Copy]),
                State;
            true ->
                misc:cancel_timer({box_score, Copy}),
                Ref = erlang:send_after(data_cross_battlefield_top:timer() * 1000, self(), {box_score, Copy}),
                put({box_score, Copy}, Ref),

                Timer = data_cross_battlefield_top:normal_refresh_time(),
                misc:cancel_timer({reset_top_box, Copy}),
                Ref1 = erlang:send_after(Timer * 1000, self(), {reset_top_box, Copy, reset}),
                put({reset_top_box, Copy}, Ref1),

                Mb = dict:fetch(Pkey, State#st_cross_battlefield.p_dict),
                BuffId = get_buff_id(Copy, State#st_cross_battlefield.p_dict),
                Box = #cross_bf_box{copy = Copy, pkey = Pkey, nickname = Mb#cross_bf_mb.nickname, refresh_time = util:unixtime() + Timer, buff_id = BuffId},
                BoxList = [Box | lists:keydelete(Copy, #cross_bf_box.copy, State#st_cross_battlefield.box_list)],
                ?DO_IF(Mb#cross_bf_mb.pid /= none, server_send:send_node_pid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.pid, {cross_bf_buff, BuffId, Box#cross_bf_box.buff_id})),
                State1 = State#st_cross_battlefield{box_list = BoxList},
%%                case data_cross_battlefield_top:box_goods_list() of
%%                    {} -> ok;
%%                    GoodsList ->
%%                        center:apply(Mb#cross_bf_mb.node, cross_battlefield, box_reward_msg, [Mb#cross_bf_mb.pkey, tuple_to_list(GoodsList)])
%%                end,
                spawn(fun() -> refresh_top_layer_msg(State1, Copy) end),
                State1
        end,
    {noreply, NewState};

%%%%复活检查切层
handle_cast({check_layer, Pkey, Rtype}, State) ->
    NewState =
        if State#st_cross_battlefield.open_state =/= ?CROSS_BATTLEFIELD_STATE_START -> State;
            true ->
                case dict:is_key(Pkey, State#st_cross_battlefield.p_dict) of
                    false -> State;
                    true ->
                        Mb = dict:fetch(Pkey, State#st_cross_battlefield.p_dict),
                        %%Rtype 元宝复活
                        if Rtype /= 0 -> State;
                            true ->
                                AccDie = Mb#cross_bf_mb.acc_die + 1,
                                case data_cross_battlefield:drop_layer_ratio(Mb#cross_bf_mb.layer) of
                                    0 -> State;
                                    DieLim ->
                                        case AccDie >= DieLim of
                                            false ->
                                                NewMb = Mb#cross_bf_mb{acc_die = AccDie},
                                                Dict = dict:store(Pkey, NewMb, State#st_cross_battlefield.p_dict),
                                                spawn(fun() -> refresh_client(NewMb, State) end),
                                                State#st_cross_battlefield{p_dict = Dict};
                                            true ->
                                                %%概率降层
                                                Layer = max(1, Mb#cross_bf_mb.layer - 1),
                                                Copy = cross_battlefield:match_copy(Layer, State#st_cross_battlefield.p_dict),
                                                Msg = {change_cross_battlefield, Layer, Copy, 2},
                                                spawn(fun() -> util:sleep(500),
                                                    server_send:send_node_pid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.pid, Msg) end),
                                                NewMb = Mb#cross_bf_mb{kill = 0, layer = Layer, copy = Copy, acc_die = 0, enter_time = util:unixtime()},
                                                Dict = dict:store(Pkey, NewMb, State#st_cross_battlefield.p_dict),
                                                State#st_cross_battlefield{p_dict = Dict}
                                        end
                                end
                        end
                end
        end,
    {noreply, NewState};

handle_cast(_msg, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {noreply, State}.

handle_info({cmd_jump, Pkey, Layer}, State) ->
    NewState =
        if State#st_cross_battlefield.open_state =/= ?CROSS_BATTLEFIELD_STATE_START -> State;
            true ->
                case dict:is_key(Pkey, State#st_cross_battlefield.p_dict) of
                    false -> State;
                    true ->
                        case lists:member(Layer, lists:seq(1, 9)) of
                            false -> State;
                            true ->
                                Mb = dict:fetch(Pkey, State#st_cross_battlefield.p_dict),
                                Copy = cross_battlefield:match_copy(Layer, State#st_cross_battlefield.p_dict),
                                NewMb = Mb#cross_bf_mb{kill = 0, layer = Layer, layer_h = max(Layer, Mb#cross_bf_mb.layer_h), acc_die = 0, copy = Copy, enter_time = util:unixtime()},
                                Msg =
                                    if Mb#cross_bf_mb.layer < Layer ->
                                        {change_cross_battlefield, Layer, Copy, 1};
                                        true ->
                                            {change_cross_battlefield, Layer, Copy, 2}
                                    end,
                                server_send:send_node_pid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.pid, Msg),
                                Dict = dict:store(Pkey, NewMb, State#st_cross_battlefield.p_dict),
                                spawn(fun() ->
                                    refresh_client(NewMb, State) end),
                                State#st_cross_battlefield{p_dict = Dict}
                        end

                end
        end,
    {noreply, NewState};



handle_info(cmd_force_close, State) ->
    scene_cross:send_out_cross(?SCENE_TYPE_CROSS_BATTLEFIELD),
    util:cancel_ref([State#st_cross_battlefield.ref]),
    State1 = #st_cross_battlefield{ref = [], is_finish = 1},
    NewState = cross_battlefield_proc:set_timer(State1#st_cross_battlefield{}, util:unixtime()),
    {ok, Bin} = pt_550:write(55001, {?CROSS_BATTLEFIELD_STATE_CLOSE, 0}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
        end,
    lists:foreach(F, center:get_nodes()),
    %%结算
    {noreply, NewState};

handle_info(cmd_reward, State) ->
    case catch finish_reward(State#st_cross_battlefield.p_dict, 2) of
        {NewDict, RankList} ->
            {noreply, State#st_cross_battlefield{p_dict = NewDict, rank_list = RankList}};
        _ERR ->
            ?ERR("finish_reward err ~p~n", [_ERR]),
            {noreply, State}
    end;


handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_cross_battlefield.ref]),
    NewState = cross_battlefield_proc:set_timer(State, Now),
    {noreply, NewState};


%%准备
handle_info({ready, ReadyTime, LastTime}, State) when State#st_cross_battlefield.open_state == ?CROSS_BATTLEFIELD_STATE_CLOSE ->
    ?DEBUG("cross battlefield ready ~p~n", [ReadyTime]),
    util:cancel_ref([State#st_cross_battlefield.ref]),
    misc:cancel_timer(clean),
    Now = util:unixtime(),
    {ok, Bin} = pt_550:write(55001, {?CROSS_BATTLEFIELD_STATE_READY, ReadyTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_battlefield_ready, []])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_cross_battlefield{open_state = ?CROSS_BATTLEFIELD_STATE_READY, time = Now + ReadyTime, ref = Ref},
    {noreply, NewState};

%%开始
handle_info({start, LastTime}, State) when State#st_cross_battlefield.open_state /= ?CROSS_BATTLEFIELD_STATE_START ->
    util:cancel_ref([State#st_cross_battlefield.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_550:write(55001, {?CROSS_BATTLEFIELD_STATE_START, LastTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_battlefield_start, []])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    TimerRef = erlang:send_after(?TIMER * 1000, self(), score_timer),
    put(score_timer, TimerRef),
    NewState = State#st_cross_battlefield{
        open_state = ?CROSS_BATTLEFIELD_STATE_START,
        is_finish = 0,
        time = Now + LastTime,
        ref = Ref,
        p_dict = dict:new(),
        mon_list = [],
        copy_list = [],
        first_info = {0, <<>>},
        box_first_time = 0,%%顶层宝箱首次时间
        box_list = []
    },
    %%顶层事件
    self() ! top_layer_event,
    %%玩法找回
    findback_src:update_act_time(34, Now),
    {noreply, NewState};

%%关闭
handle_info(close, State) ->
    ?DEBUG("cross battlefield close ~n"),
    util:cancel_ref([State#st_cross_battlefield.ref]),
    misc:cancel_timer(score_timer),
    [misc:cancel_timer({reset_top_box, Copy}) || Copy <- State#st_cross_battlefield.copy_list],
    Now = util:unixtime(),
    {ok, Bin} = pt_550:write(55001, {?CROSS_BATTLEFIELD_STATE_CLOSE, 0}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
%%         center:apply(Node, notice_sys, add_notice, [cross_battlefield_close, []])
        end,
    lists:foreach(F, center:get_nodes()),
    State1 = State#st_cross_battlefield{ref = [], is_finish = 1},
    NewState = cross_battlefield_proc:set_timer(State1#st_cross_battlefield{}, Now),
    CleanRef = erlang:send_after(15 * 1000, self(), {clean, State#st_cross_battlefield.copy_list}),
    put(clean, CleanRef),
    %%宝箱奖励
    F1 = fun(Box) ->
        case dict:is_key(Box#cross_bf_box.pkey, State#st_cross_battlefield.p_dict) of
            false -> ok;
            true ->
                Mb = dict:fetch(Box#cross_bf_box.pkey, State#st_cross_battlefield.p_dict),
                case data_cross_battlefield_top:box_goods_list() of
                    {} -> ok;
                    GoodsList ->
                        center:apply(Mb#cross_bf_mb.node, cross_battlefield, box_reward_msg, [Mb#cross_bf_mb.pkey, tuple_to_list(GoodsList)])
                end
        end
         end,
    lists:foreach(F1, State#st_cross_battlefield.box_list),
    %%结算
    case catch finish_reward(State#st_cross_battlefield.p_dict, 1) of
        {NewDict, RankList} ->
            spawn(fun() -> final_msg(RankList) end),
            {noreply, NewState#st_cross_battlefield{p_dict = NewDict, rank_list = RankList}};
        _ERR ->
            ?ERR("finish_reward err ~p~n", [_ERR]),
            {noreply, NewState}
    end;

handle_info({cmd_type, Type}, State) ->
    case Type of
        size ->
            ?ERR("size len ~p~n", [dict:size(State#st_cross_battlefield.p_dict)]),
            ok;
        _ ->
            ok
    end,
    {noreply, State};

%%顶层事件
handle_info(top_layer_event, State) ->
    Timer = data_cross_battlefield_top:first_refresh_time(),
    Ref1 = erlang:send_after(Timer * 1000, self(), refresh_top_box),
    put(refresh_top_box, Ref1),

    Ref2 = erlang:send_after(max(0, (Timer - 60)) * 1000, self(), refresh_top_box_msg),
    put(refresh_top_box_msg, Ref2),
    {noreply, State#st_cross_battlefield{box_first_time = util:unixtime() + Timer, box_list = []}};

handle_info(refresh_top_box_msg, State) ->
%%     notice_sys:add_notice(cross_bf_box_ready, []),
    {noreply, State};

%%刷新顶层宝箱
handle_info(refresh_top_box, State) ->
    MaxLayer = cross_battlefield:max_layer(),
    CopyList = [Copy || Copy <- State#st_cross_battlefield.copy_list, Copy >= MaxLayer * 100],
    cross_battlefield:refresh_top_layer_box(MaxLayer, CopyList),
    BoxList = [#cross_bf_box{copy = Copy} || Copy <- CopyList],
%%     notice_sys:add_notice(cross_bf_box, []),
    {noreply, State#st_cross_battlefield{box_list = BoxList}};

%%刷新单个宝箱
handle_info({reset_top_box, Copy, Type}, State) when State#st_cross_battlefield.open_state == ?CROSS_BATTLEFIELD_STATE_START ->
    misc:cancel_timer({reset_top_box, Copy}),
    MaxLayer = cross_battlefield:max_layer(),
%%     notice_sys:add_notice(cross_bf_box1, []),
    cross_battlefield:refresh_top_layer_box(MaxLayer, [Copy]),
    BoxList =
        case lists:keytake(Copy, #cross_bf_box.copy, State#st_cross_battlefield.box_list) of
            false ->
                State#st_cross_battlefield.box_list;
            {value, Box, T} ->
                case dict:is_key(Box#cross_bf_box.pkey, State#st_cross_battlefield.p_dict) of
                    false -> State#st_cross_battlefield.box_list;
                    true ->
                        Mb = dict:fetch(Box#cross_bf_box.pkey, State#st_cross_battlefield.p_dict),
                        %%清buff
                        ?DO_IF(Mb#cross_bf_mb.pid /= none, server_send:send_node_pid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.pid, {cross_bf_buff, 0, Box#cross_bf_box.buff_id})),
                        if Type == reset ->
                            case data_cross_battlefield_top:box_goods_list() of
                                {} -> ok;
                                GoodsList ->
                                    center:apply(Mb#cross_bf_mb.node, cross_battlefield, box_reward_msg, [Mb#cross_bf_mb.pkey, tuple_to_list(GoodsList)])
                            end;
                            true ->
                                ok
                        end,
                        [#cross_bf_box{copy = Copy} | T]
                end
        end,
    NewState = State#st_cross_battlefield{box_list = BoxList},
    spawn(fun() -> refresh_top_layer_msg(NewState, Copy) end),
    {noreply, NewState};

%%清除数据--譬如踢人
handle_info({clean, CopyList}, State) ->
    misc:cancel_timer(clean),
    scene_cross:send_out_cross(?SCENE_TYPE_CROSS_BATTLEFIELD),

    F = fun(Sid) ->
        [scene_init:stop_scene(Sid, Copy) || Copy <- CopyList]
%%        [scene_agent:clean_scene_area(Sid, Copy) || Copy <- CopyList],
%%        [catch monster:stop_broadcast(Aid) || Aid <- mon_agent:get_scene_mon_pids(Sid)]
        end,
    lists:foreach(F, data_cross_battlefield:scene_ids()),
    {noreply, State};

%%定时积分
handle_info(score_timer, State) ->
    misc:cancel_timer(score_timer),
    Ref = erlang:send_after(?TIMER * 1000, self(), score_timer),
    put(score_timer, Ref),
    Dict = score_timer(State#st_cross_battlefield.p_dict, State),
    {noreply, State#st_cross_battlefield{p_dict = Dict}};

%%刷新线路层怪物
handle_info({refresh_mon_layer, Layer, Copy}, State) ->
    case lists:member(Copy, State#st_cross_battlefield.copy_list) of
        true ->
            {noreply, State};
        false ->
            cross_battlefield:refresh_mon_layer(Layer, Copy),
            BuffList = cross_battlefield:refresh_buff_layer(Layer, Copy),
            MaxLayer = cross_battlefield:max_layer(),
            Now = util:unixtime(),
            ?DO_IF(Layer == MaxLayer andalso State#st_cross_battlefield.box_first_time < Now,
                cross_battlefield:refresh_top_layer_box(Layer, [Copy])),
            CopyList = [Copy | State#st_cross_battlefield.copy_list],
            NewBuffList = State#st_cross_battlefield.buff_list ++ BuffList,
            {noreply, State#st_cross_battlefield{copy_list = CopyList, buff_list = NewBuffList}}
    end;

%%刷新buff
handle_info({refresh_buff, SceneId, Copy, X, Y}, State) ->
    misc:cancel_timer({refresh_buff, SceneId, Copy, X, Y}),
    BuffList =
        case data_cross_battlefield:buff_list(SceneId) of
            [] ->
                State#st_cross_battlefield.buff_list;
            BuffIds ->
                Mid = util:list_rand(BuffIds),
                {Mkey, Mpid} = mon_agent:create_mon([Mid, SceneId, X, Y, Copy, 1, [{return_id_pid, true}]]),
                [{Mkey, Mpid, Mid, SceneId, Copy, X, Y} | State#st_cross_battlefield.buff_list]
        end,
    {noreply, State#st_cross_battlefield{buff_list = BuffList}};

%%顶层宝箱积分
handle_info({box_score, Copy}, State) ->
    case lists:keytake(Copy, #cross_bf_box.copy, State#st_cross_battlefield.box_list) of
        false -> {noreply, State};
        {value, Box, T} ->
            case dict:is_key(Box#cross_bf_box.pkey, State#st_cross_battlefield.p_dict) of
                false ->
                    {noreply, State};
                true ->
                    misc:cancel_timer(box_score),
                    Ref = erlang:send_after(data_cross_battlefield_top:timer() * 1000, self(), {box_score, Copy}),
                    put(box_score, Ref),
                    Mb = dict:fetch(Box#cross_bf_box.pkey, State#st_cross_battlefield.p_dict),
                    Score = data_cross_battlefield_top:timer_score() + Mb#cross_bf_mb.score,
                    NewMb = Mb#cross_bf_mb{score = Score,h_score = max(Score,Mb#cross_bf_mb.h_score)},
                    Dict = dict:store(Mb#cross_bf_mb.pkey, NewMb, State#st_cross_battlefield.p_dict),
                    BuffId = get_buff_id(Copy, State#st_cross_battlefield.p_dict),
                    BoxList =
                        if Box#cross_bf_box.buff_id == BuffId ->
                            State#st_cross_battlefield.box_list;
                            true ->
                                %%更新buff
                                ?DO_IF(Mb#cross_bf_mb.pid /= none, server_send:send_node_pid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.pid, {cross_bf_buff, BuffId, Box#cross_bf_box.buff_id})),
                                [Box#cross_bf_box{buff_id = BuffId} | T]
                        end,
                    NewState = State#st_cross_battlefield{p_dict = Dict, box_list = BoxList},
                    spawn(fun() -> refresh_top_layer_msg(NewState, Copy) end),
                    {noreply, NewState}
            end
    end;

%%首位登顶
handle_info({first_info, Node, Sn, Pkey, Nickname}, State) ->
    case State#st_cross_battlefield.first_info of
        {0, <<>>} ->
            case data_cross_battlefield_top:first_goods_list() of
                {} -> ok;
                GoodsList ->
                    center:apply(Node, cross_battlefield, first_reward_msg, [Pkey, tuple_to_list(GoodsList)])
            end,
            {noreply, State#st_cross_battlefield{first_info = {Sn, Nickname}}};
        _ ->
            {noreply, State}
    end;

handle_info(_msg, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {noreply, State}.

%%击杀获得积分
kill(SceneId, Pkey, Dict, State) ->
    Mb = dict:fetch(Pkey, Dict),
    case SceneId == data_cross_battlefield:scene(Mb#cross_bf_mb.layer) of
        false -> Mb;
        true ->
            Now = util:unixtime(),

            ComboKill =
                if Mb#cross_bf_mb.combo_time == 0 orelse Mb#cross_bf_mb.combo_time > Now ->
                    Mb#cross_bf_mb.combo_kill + 1;
                    true ->
                        1
                end,
            ComboTime =
                case data_cross_battlefield_combo:get(ComboKill) of
                    [] -> 0;
                    Sec -> Sec
                end,
            ?DEBUG("ComboKill ~p~n", [ComboKill]),
            {ok, Bin} = pt_550:write(55012, {ComboKill, ComboTime}),
            ?DO_IF(Mb#cross_bf_mb.pid /= none,
                server_send:send_to_sid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.sid, Bin)
%%                center:apply(Mb#cross_bf_mb.node, server_send, send_to_sid, [Mb#cross_bf_mb.sid, Bin])
            ),
            %%连杀积分
            ComboScore = data_cross_battlefield_combo_score:get(ComboKill),
            %%增加击杀积分
            Score = data_cross_battlefield:kill_score(Mb#cross_bf_mb.layer) + Mb#cross_bf_mb.score + ComboScore,
            Mb1 = Mb#cross_bf_mb{
                score = Score,
                h_score = max(Score, Mb#cross_bf_mb.h_score),
                kill = Mb#cross_bf_mb.kill + 1,
                acc_kill = Mb#cross_bf_mb.acc_kill + 1,
                combo_kill = ComboKill,
                combo_time = Now + ComboTime,
                acc_combo_kill = max(Mb#cross_bf_mb.acc_combo_kill, ComboKill)
            },
            combo_msg(Mb1),
            %%目标检查
            check_score_target(Mb1, Mb#cross_bf_mb.h_score),
            MaxLayer = cross_battlefield:max_layer(),
            NewMb =
                if Mb#cross_bf_mb.layer >= MaxLayer -> Mb1;
                    true ->
                        case data_cross_battlefield:up_layer_kill(Mb#cross_bf_mb.layer) of
                            0 -> Mb1;
                            KillLim ->
                                if Mb1#cross_bf_mb.kill >= KillLim ->
                                    NewLayer = Mb#cross_bf_mb.layer + 1,
                                    Copy = cross_battlefield:match_copy(NewLayer, Dict),
                                    %%通知玩家切层
                                    Msg = {change_cross_battlefield, NewLayer, Copy, 1},
                                    spawn(fun() -> util:sleep(500),
                                        server_send:send_node_pid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.pid, Msg) end),
                                    check_first_enter(Mb, NewLayer, Mb#cross_bf_mb.layer_h, MaxLayer),
                                    Mb1#cross_bf_mb{kill = 0, layer = NewLayer, layer_h = max(Mb#cross_bf_mb.layer_h, NewLayer), acc_die = 0, copy = Copy, enter_time = util:unixtime()};
                                    true ->
                                        Mb1
                                end
                        end
                end,
            spawn(fun() -> refresh_client(NewMb, State) end),
            NewMb
    end.

combo_msg(Mb) ->
    case Mb#cross_bf_mb.combo_kill > 0 andalso Mb#cross_bf_mb.combo_kill rem 5 of
        0 ->
            skip;
%%             if Mb#cross_bf_mb.combo_kill =< 20 ->
%%                 notice_sys:add_notice(cross_bf_comob1, [Mb#cross_bf_mb.nickname, Mb#cross_bf_mb.combo_kill]);
%%                 true ->
%%                     notice_sys:add_notice(cross_bf_comob2, [Mb#cross_bf_mb.nickname, Mb#cross_bf_mb.combo_kill])
%%             end;
        _ ->
            skip
    end.


%%玩家死亡
die(Pkey, Dict) ->
    case dict:is_key(Pkey, Dict) of
        false -> {Dict, false};
        true ->
            Mb = dict:fetch(Pkey, Dict),
            NewMb = Mb#cross_bf_mb{combo_kill = 0, combo_time = 0, last_combo_kill = Mb#cross_bf_mb.last_combo_kill},
            {dict:store(Pkey, NewMb, Dict), NewMb}
    end.

%%击杀怪物获得积分+击杀数
kill_mon(SceneId, Dict, Pkey, State) ->
    case dict:is_key(Pkey, Dict) of
        false -> Dict;
        true ->
            Mb = dict:fetch(Pkey, Dict),
            case SceneId == data_cross_battlefield:scene(Mb#cross_bf_mb.layer) of
                false -> Dict;
                true ->
                    Score = data_cross_battlefield:mon_score(Mb#cross_bf_mb.layer) + Mb#cross_bf_mb.score,
                    Mb1 = Mb#cross_bf_mb{kill = Mb#cross_bf_mb.kill + 1, score = Score, h_score = max(Score, Mb#cross_bf_mb.h_score)},
                    check_score_target(Mb1, Mb#cross_bf_mb.h_score),
                    MaxLayer = cross_battlefield:max_layer(),
                    NewMb =
                        if Mb#cross_bf_mb.layer >= MaxLayer -> Mb1;
                            true ->
                                case data_cross_battlefield:up_layer_kill(Mb#cross_bf_mb.layer) of
                                    0 -> Mb1;
                                    KillLim ->
                                        if Mb1#cross_bf_mb.kill >= KillLim ->
                                            NewLayer = Mb#cross_bf_mb.layer + 1,
                                            Copy = cross_battlefield:match_copy(NewLayer, Dict),
                                            %%通知玩家切层
                                            Msg = {change_cross_battlefield, NewLayer, Copy, 1},
                                            spawn(fun() -> util:sleep(500),
                                                server_send:send_node_pid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.pid, Msg) end),
                                            check_first_enter(Mb, NewLayer, Mb#cross_bf_mb.layer_h, MaxLayer),
                                            Mb1#cross_bf_mb{kill = 0, layer = NewLayer, layer_h = max(Mb#cross_bf_mb.layer_h, NewLayer), acc_die = 0, copy = Copy, enter_time = util:unixtime()};
                                            true ->
                                                Mb1
                                        end
                                end
                        end,
                    spawn(fun() -> refresh_client(NewMb, State) end),
                    dict:store(Pkey, NewMb, Dict)
            end
    end.

%%定时增加积分
score_timer(Dict, State) ->
    Now = util:unixtime(),
    F = fun(_Key, Mb) ->
        case data_cross_battlefield:timer_score(Mb#cross_bf_mb.layer) of
            0 -> Mb;
            Score ->
                if Now - Mb#cross_bf_mb.enter_time >= ?TIMER andalso Mb#cross_bf_mb.pid /= none ->
                    NowScore = Mb#cross_bf_mb.score + Score,
                    NewMb = Mb#cross_bf_mb{score = NowScore, h_score = max(NowScore, Mb#cross_bf_mb.h_score)},
                    check_score_target(NewMb, Mb#cross_bf_mb.h_score),
                    spawn(fun() -> refresh_client(NewMb, State) end),
                    NewMb;
                    true ->
                        Mb
                end
        end
        end,
    dict:map(F, Dict).

%%活动结算
finish_reward(Dict, Type) ->
    MbList =
        case Type of
            1 ->
                [Mb#cross_bf_mb{score = cross_battlefield:calc_score_for_quit(Mb#cross_bf_mb.score, Mb#cross_bf_mb.layer, Mb#cross_bf_mb.quit_time)} || {_, Mb} <- dict:to_list(Dict)];
            _ ->
                [Mb || {_, Mb} <- dict:to_list(Dict)]
        end,
    MbList1 = lists:keysort(#cross_bf_mb.score, MbList),
    F = fun(Mb, {Rank, L, D}) ->
        GoodsList = cross_battlefield:get_reward_list(Rank),
        center:apply(Mb#cross_bf_mb.node, cross_battlefield, reward_msg, [Mb#cross_bf_mb.pkey, Mb#cross_bf_mb.nickname, Rank, Mb#cross_bf_mb.layer, Mb#cross_bf_mb.score, GoodsList]),
        L1 = L ++ [Mb#cross_bf_mb{rank = Rank}],
        D1 = dict:store(Mb#cross_bf_mb.pkey, Mb, D),
        {Rank + 1, L1, D1}
        end,
    {_, MbList2, NewDict} = lists:foldr(F, {1, [], dict:new()}, MbList1),
    {NewDict, MbList2}.


refresh_client(Mb, State) ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_cross_battlefield.time - Now),
    {Sn, Nickname} = State#st_cross_battlefield.first_info,
    MaxLayer = cross_battlefield:max_layer(),
    {BoxTime, BoxNickname, BuffId} =
        if Mb#cross_bf_mb.layer =/= MaxLayer -> {0, <<>>, 0};
            Now < State#st_cross_battlefield.box_first_time ->
                {State#st_cross_battlefield.box_first_time - Now, <<>>, 0};
            true ->
                case lists:keyfind(Mb#cross_bf_mb.copy, #cross_bf_box.copy, State#st_cross_battlefield.box_list) of
                    false -> {0, <<>>, 0};
                    Box ->
                        {max(0, Box#cross_bf_box.refresh_time - Now), Box#cross_bf_box.nickname, Box#cross_bf_box.buff_id}
                end
        end,
    DieLim = data_cross_battlefield:drop_layer_ratio(Mb#cross_bf_mb.layer),
    {ok, Bin} = pt_550:write(55004, {Mb#cross_bf_mb.layer, Mb#cross_bf_mb.score, Mb#cross_bf_mb.kill, LeftTime, Sn, Nickname, BoxTime, BoxNickname, BuffId, Mb#cross_bf_mb.acc_die, DieLim}),
    ?DO_IF(Mb#cross_bf_mb.pid /= none,
        server_send:send_to_sid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.sid, Bin)
%%        center:apply(Mb#cross_bf_mb.node, server_send, send_to_sid, [Mb#cross_bf_mb.sid, Bin])
    ),
    ok.

%%积分目标
check_score_target(Mb, OldScore) ->
    F = fun(Score) ->
        if Mb#cross_bf_mb.h_score >= Score andalso Score > OldScore ->
            tuple_to_list(data_cross_battlefield_target:get(Score));
            true -> []
        end
        end,
    case lists:flatmap(F, data_cross_battlefield_target:ids()) of
        [] -> ok;
        GoodsList ->
            center:apply(Mb#cross_bf_mb.node, cross_battlefield, target_reward_msg, [Mb#cross_bf_mb.pkey, Mb#cross_bf_mb.score, GoodsList])
    end.

%%进入奖励
check_first_enter(Mb, NowLayer, LayerHigh, MaxLayer) ->
    ?DO_IF(NowLayer == MaxLayer, self() ! {first_info, Mb#cross_bf_mb.node, Mb#cross_bf_mb.sn, Mb#cross_bf_mb.pkey, Mb#cross_bf_mb.nickname}),
    if NowLayer =< LayerHigh -> ok;
        true ->
            case data_cross_battlefield:enter_goods_list(NowLayer) of
                [] -> ok;
                GoodsList ->
                    center:apply(Mb#cross_bf_mb.node, cross_battlefield, enter_reward_msg, [Mb#cross_bf_mb.pkey, NowLayer, tuple_to_list(GoodsList)])
            end
    end.



get_buff_id(Copy, Dict) ->
    MaxLayer = cross_battlefield:max_layer(),
%%    SceneId = data_cross_battlefield:scene(MaxLayer),
    F = fun(_, Mb) ->
        Mb#cross_bf_mb.layer == MaxLayer andalso Mb#cross_bf_mb.copy == Copy
        end,
    MbDict = dict:filter(F, Dict),
    SceneCount = dict:size(MbDict),
    ?DEBUG("SceneCount ~p~n", [SceneCount]),
%%        scene_agent:get_scene_count(SceneId, Copy),
    case data_cross_battlefield_buff:get(SceneCount) of
        [] -> 0;
        BuffId -> BuffId
    end.

refresh_top_layer_msg(State, Copy) ->
    MaxLayer = cross_battlefield:max_layer(),
    F = fun(_, Mb) ->
        if Mb#cross_bf_mb.copy == Copy andalso Mb#cross_bf_mb.layer == MaxLayer ->
            refresh_client(Mb, State);
            true ->
                ok
        end
        end,
    dict:map(F, State#st_cross_battlefield.p_dict),
    ok.

%%结算
final_msg(RankList) ->
    F = fun(Mb) ->
        {ok, Bin} = pt_550:write(55006, {Mb#cross_bf_mb.layer_h, Mb#cross_bf_mb.score, Mb#cross_bf_mb.rank}),
        ?DO_IF(Mb#cross_bf_mb.pid /= none,
            server_send:send_to_sid(Mb#cross_bf_mb.node, Mb#cross_bf_mb.sid, Bin)
%%            center:apply(Mb#cross_bf_mb.node, server_send, send_to_sid, [Mb#cross_bf_mb.sid, Bin])
        )
        end,
    lists:foreach(F, RankList),
    ok.

