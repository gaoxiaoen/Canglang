%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 三月 2016 16:50
%%%-------------------------------------------------------------------
-module(battlefield_handle).
-author("hxming").

-include("battlefield.hrl").
-include("server.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("goods.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).
-export([reward_goods_list/1, test_apply/1]).

handle_call(_msg, _From, State) ->
    {reply, ok, State}.

%%查询活动状态
handle_cast({check_state, Node, Sid, Now}, State) ->
    if State#st_battlefield.open_state == ?BATTLEFIELD_STATE_CLOSE -> skip;
        true ->
            {ok, Bin} = pt_640:write(64001, {State#st_battlefield.open_state, max(0, State#st_battlefield.time - Now)}),
            server_send:send_to_sid(Node, Sid, Bin)
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
    end,
    {noreply, State};


%%玩家离线
handle_cast({check_logout, Pkey}, State) ->
    NewState =
        case dict:is_key(Pkey, State#st_battlefield.p_dict) of
            false ->
                State;
            true ->
                Mb = dict:fetch(Pkey, State#st_battlefield.p_dict),
                NewMb = Mb#bf_mb{is_online = 0, logout_time = util:unixtime()},
                PDict = dict:store(Pkey, NewMb, State#st_battlefield.p_dict),
                State#st_battlefield{p_dict = PDict}
        end,
    {noreply, NewState};

%%战场报名
handle_cast({check_apply, Mb}, State) ->
    {Ret, NewState} =
        if State#st_battlefield.open_state /= ?BATTLEFIELD_STATE_READY ->
            {3, State};
            true ->
                case dict:is_key(Mb#bf_mb.pkey, State#st_battlefield.p_dict) of
                    true ->
                        {2, State};
                    false ->
                        Dict = dict:store(Mb#bf_mb.pkey, Mb, State#st_battlefield.p_dict),
                        {1, State#st_battlefield{p_dict = Dict}}
                end
        end,
    {ok, Bin} = pt_640:write(64010, {Ret}),
    server_send:send_to_sid(Mb#bf_mb.node, Mb#bf_mb.sid, Bin),
%%    center:apply(Mb#bf_mb.node, server_send, send_to_sid, [Mb#bf_mb.sid, Bin]),
    {noreply, NewState};

handle_cast({check_enter, Mb}, State) ->
    if State#st_battlefield.open_state /= ?BATTLEFIELD_STATE_START ->
        {ok, Bin} = pt_640:write(64002, {202}),
        server_send:send_to_sid(Mb#bf_mb.node, Mb#bf_mb.sid, Bin),
%%        center:apply(Mb#bf_mb.node, server_send, send_to_sid, [Mb#bf_mb.sid, Bin]),
        {noreply, State};
        true ->
            {Ret, NewMb, PDict, CopyList} = check_enter(Mb, State#st_battlefield.p_dict, State#st_battlefield.copy_list),
            {ok, Bin} = pt_640:write(64002, {Ret}),
            server_send:send_to_sid(Mb#bf_mb.node, Mb#bf_mb.sid, Bin),
%%            center:apply(Mb#bf_mb.node, server_send, send_to_sid, [Mb#bf_mb.sid, Bin]),
            if Ret == 1 ->
                Msg = {enter_battlefield, NewMb#bf_mb.copy, NewMb#bf_mb.group, NewMb#bf_mb.combo, NewMb#bf_mb.score},
                server_send:send_node_pid(Mb#bf_mb.node, Mb#bf_mb.pid, Msg);
                true -> skip
            end,
            {noreply, State#st_battlefield{p_dict = PDict, copy_list = CopyList}}
    end;

%%退出战场
handle_cast({check_quit, Pkey}, State) ->
    case dict:is_key(Pkey, State#st_battlefield.p_dict) of
        false ->
            {noreply, State};
        true ->
            Mb = dict:fetch(Pkey, State#st_battlefield.p_dict),
            NewMb = Mb#bf_mb{is_online = 0, quit_time = util:unixtime()},
            PDict = dict:store(Pkey, NewMb, State#st_battlefield.p_dict),
            {noreply, State#st_battlefield{p_dict = PDict}}
    end;

%%战场信息
handle_cast({check_info, Node, PKey, Sid}, State) ->
    LeftTime = max(State#st_battlefield.time - util:unixtime(), 0),
    Data =
        case dict:is_key(PKey, State#st_battlefield.p_dict) of
            false ->
                {0, 0, 0, 0, 0, 0, LeftTime};
            true ->
                Mb = dict:fetch(PKey, State#st_battlefield.p_dict),
                Lim = data_battlefield:lim_energy(),
                {Mb#bf_mb.acc_kill, Mb#bf_mb.acc_assists, Mb#bf_mb.combo, Mb#bf_mb.acc_energy, Lim, Mb#bf_mb.score, LeftTime}
        end,
    {ok, Bin} = pt_640:write(64004, Data),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%积分前十
handle_cast({check_top_ten, Node, Sid}, State) ->
    MbList =
        lists:keysort(#bf_mb.score, [Mb || {_, Mb} <- dict:to_list(State#st_battlefield.p_dict)]),
    MbList1 = lists:sublist(lists:reverse(MbList), 10),
    F = fun(Mb) ->
        [Mb#bf_mb.nickname, Mb#bf_mb.acc_kill, Mb#bf_mb.score]
        end,
    Data = lists:map(F, MbList1),
    {ok, Bin} = pt_640:write(64005, {Data}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%查看排行榜
handle_cast({check_rank, Node, Sid, Type, Page}, State) ->
    RankList = rank(Type, State#st_battlefield.p_dict),
    MaxPage = length(RankList) div 10 + 1,
    NowPage = ?IF_ELSE(Page =< 0 orelse Page > MaxPage, 1, Page),
    Rank = NowPage * 10 - 9,
    NewRankList =
        case RankList of
            [] -> [];
            _ ->
                lists:sublist(RankList, Rank, 10)
        end,
    F = fun(Mb) ->
        [Mb#bf_mb.rank, Mb#bf_mb.pkey, Mb#bf_mb.nickname, Mb#bf_mb.vip, Mb#bf_mb.rank_val, Mb#bf_mb.gname]
        end,
    Data = lists:map(F, NewRankList),
    {ok, Bin} = pt_640:write(64006, {Type, NowPage, MaxPage, Data}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%宝箱信息
handle_cast({check_box, Node, Sid, Copy}, State) ->
    Bin = box_list(State#st_battlefield.pos_list, Copy),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};


%%触发无敌buff
handle_cast({check_buff, Pkey}, State) ->
    NewState =
        case dict:is_key(Pkey, State#st_battlefield.p_dict) of
            false -> State;
            true ->
                Mb = dict:fetch(Pkey, State#st_battlefield.p_dict),
                Lim = data_battlefield:lim_energy(),
                if Mb#bf_mb.acc_energy >= Lim ->
                    server_send:send_node_pid(Mb#bf_mb.node, Mb#bf_mb.pid, {bf_buff, data_battlefield:buff_id()}),
                    NewMb = Mb#bf_mb{acc_energy = 0, acc_die = 0},
                    spawn(fun() -> refresh_to_client(NewMb, Mb#bf_mb.score, State#st_battlefield.time) end),
                    PDict = dict:store(Pkey, NewMb, State#st_battlefield.p_dict),
                    State#st_battlefield{p_dict = PDict};
                    true -> State
                end
        end,
    {noreply, NewState};


%%击杀玩家
handle_cast({kill, Pkey, AttKey, Copy, X, Y, Sign}, State) ->
    if State#st_battlefield.is_finish == 1 ->
        {noreply, State};
        true ->
            %%被杀处理
            {Dict1, Combo} = die(Pkey, State#st_battlefield.p_dict, State#st_battlefield.time, Sign),
            %%击杀加分
            Dict2 = kill(AttKey, Dict1, Combo, State#st_battlefield.time),
            %%助攻加分
            KeyList = scene_agent:get_area_scene_pkeys(?SCENE_ID_BATTLEFIELD, Copy, X, Y),
            Dict3 = assists(KeyList, [AttKey, Pkey], Dict2, State#st_battlefield.time),
            NewState = State#st_battlefield{p_dict = Dict3},
            {noreply, NewState}
    end;


%%采集到物品获得积分
handle_cast({collect, Pkey, MPid, Copy}, State) ->
    if State#st_battlefield.is_finish == 1 ->
        {noreply, State};
        true ->
            Pdict =
                case dict:is_key(Pkey, State#st_battlefield.p_dict) of
                    false -> State#st_battlefield.p_dict;
                    true ->
                        Mb = dict:fetch(Pkey, State#st_battlefield.p_dict),
                        Score = Mb#bf_mb.score + data_battlefield:collect_score(),
                        NewMb = Mb#bf_mb{score = Score},
                        spawn(fun() -> refresh_to_client(NewMb, Mb#bf_mb.score, State#st_battlefield.time) end),
                        dict:store(Pkey, NewMb, State#st_battlefield.p_dict)
                end,
            CollectList = lists:keydelete(MPid, 1, State#st_battlefield.collect_list),
            spawn(fun() -> update_box_single(State#st_battlefield.pos_list, Copy) end),
            {noreply, State#st_battlefield{p_dict = Pdict, collect_list = CollectList}}
    end;



handle_cast(_msg, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {noreply, State}.

handle_info(cmd_reward, State) ->
    Now = util:unixtime(),
    battlefield_finish(State#st_battlefield.p_dict, Now),
    scene_cross:send_out_cross(?SCENE_TYPE_BATTLEFIELD),
    {noreply, State};

handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_battlefield.ref]),
    NewState = battlefield_proc:set_timer(State, Now),
    {noreply, NewState};


%%准备
handle_info({ready, ReadyTime, LastTime}, State) when State#st_battlefield.open_state == ?BATTLEFIELD_STATE_CLOSE ->
    ?DEBUG("battlefield ready ~p~n", [ReadyTime]),
    util:cancel_ref([State#st_battlefield.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_640:write(64001, {?BATTLEFIELD_STATE_READY, ReadyTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
%%         center:apply(Node, notice_sys, add_notice, [battlefield_ready, []])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_battlefield{
        open_state = ?BATTLEFIELD_STATE_READY,
        time = Now + ReadyTime,
        p_dict = dict:new(),
        copy_list = [],
        ref = Ref
    },
    {noreply, NewState};

%%开始
handle_info({start, LastTime}, State) when State#st_battlefield.open_state /= ?BATTLEFIELD_STATE_START ->
    util:cancel_ref([State#st_battlefield.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_640:write(64001, {?BATTLEFIELD_STATE_START, LastTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
%%         center:apply(Node, notice_sys, add_notice, [battlefield_start, []])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    PosList = battlefield:create_box_timer(Now),
    {Dict, CopyList} = init_apply(State#st_battlefield.p_dict),
    NewState = State#st_battlefield{
        open_state = ?BATTLEFIELD_STATE_START,
        is_finish = 0,
        time = Now + LastTime,
        ref = Ref,
        pos_list = PosList,
        p_dict = Dict,
        copy_list = CopyList
    },
    ?DEBUG("battlefield start ~n"),
    {noreply, NewState};

%%关闭
handle_info(close, State) ->
    ?DEBUG("battlefield close ~n"),
    util:cancel_ref([State#st_battlefield.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_640:write(64001, {?BATTLEFIELD_STATE_CLOSE, 0}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, battlefield, clean_bf_skill, [])
        end,
    lists:foreach(F, center:get_nodes()),
    State1 = State#st_battlefield{ref = [], copy_list = [], collect_list = [], pos_list = [], is_finish = 1},
    NewState = battlefield_proc:set_timer(State1#st_battlefield{}, Now),

    battlefield:cancel_box_timer(State#st_battlefield.pos_list),
    erlang:send_after(5000, self(), {clean, State#st_battlefield.copy_list}),
    battlefield_finish(State#st_battlefield.p_dict, Now),
    {noreply, NewState};


%%清除数据--譬如踢人
handle_info({clean, CopyList}, State) ->
    battlefield:clean_scene(CopyList),
    F = fun(Node) ->
        center:apply(Node, battlefield, clean_bf_skill, [])
        end,
    lists:foreach(F, center:get_nodes()),
    {noreply, State};

%%刷新资源
handle_info({refresh_box, Id}, State) ->
    NewPosList = battlefield:refresh_box(Id, State#st_battlefield.pos_list, State#st_battlefield.copy_list),
    spawn(fun() -> update_box_list(NewPosList, State#st_battlefield.copy_list) end),
    {noreply, State#st_battlefield{pos_list = NewPosList}};

handle_info({refresh_notice, Id}, State) ->
    battlefield:refresh_box_notice(Id, State#st_battlefield.pos_list),
    {noreply, State};



handle_info(_msg, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {noreply, State}.

%%检查加入战场
check_enter(Mb, PDict, CopyList) ->
    Now = util:unixtime(),
    case dict:is_key(Mb#bf_mb.pkey, PDict) of
        true ->
            OldMb = dict:fetch(Mb#bf_mb.pkey, PDict),
            Cd = data_battlefield:quit_cd(),
            %%你刚才从战场逃跑了，暂时无法进入战场
            if Now - OldMb#bf_mb.quit_time < Cd ->
                {204, Mb, PDict, CopyList};
                true ->
                    Filter = player_filter(PDict, Mb#bf_mb.copy, Now),
                    case dict:size(Filter) =< data_battlefield:scene_lim() of
                        true ->
                            NewMb = OldMb#bf_mb{pid = Mb#bf_mb.pid, is_online = 1, logout_time = 0, quit_time = 0},
                            NewPDict = dict:store(NewMb#bf_mb.pkey, NewMb, PDict),
                            {1, NewMb, NewPDict, CopyList};
                        false ->
                            {Copy, NewCopyList} = match_copy(Now, CopyList, PDict),
                            Group = match_group(Mb#bf_mb.cbp, Copy, PDict, Now),
                            NewMb = OldMb#bf_mb{pid = Mb#bf_mb.pid, copy = Copy, group = Group, is_online = 1, logout_time = 0, quit_time = 0},
                            NewPDict = dict:store(NewMb#bf_mb.pkey, NewMb, PDict),
                            {1, NewMb, NewPDict, NewCopyList}
                    end
            end;
        false ->
            {Copy, NewCopyList} = match_copy(Now, CopyList, PDict),
            Group = match_group(Mb#bf_mb.cbp, Copy, PDict, Now),
            NewMb = Mb#bf_mb{copy = Copy, group = Group},
            NewPDict = dict:store(Mb#bf_mb.pkey, NewMb, PDict),
            {1, NewMb, NewPDict, NewCopyList}
    end.

test_apply(N) ->
    F = fun(Id, D) ->
        Mb = #bf_mb{pkey = Id, cbp = Id},
        dict:store(Id, Mb, D)
        end,
    Dict = lists:foldl(F, dict:new(), lists:seq(1, N)),
    {NewDict, CopyList} = init_apply(Dict),
    ?DEBUG("Copylist ~p~n", [CopyList]),
    F1 = fun(Copy) ->
        Filter = dict:filter(fun(_, Mb) -> Mb#bf_mb.copy == Copy end, NewDict),
        ?DEBUG("copy ~p ids ~p~n", [Copy, lists:sort(dict:fetch_keys(Filter))])
         end,
    lists:foreach(F1, CopyList),
    ok.

%%初始化报名玩家
init_apply(Dict) ->
    case dict:size(Dict) of
        0 -> {Dict, []};
        Len ->
            F = fun(Mb, {L, R}) ->
                {[Mb#bf_mb{step = R} | L], R + 1}
                end,
            {MbList, _} =
                lists:foldr(F, {[], 0}, lists:keysort(#bf_mb.cbp, [Mb || {_, Mb} <- dict:to_list(Dict)])),
            Step = Len div 10,
            do_init_apply(MbList, Step, Dict, [])
    end.

do_init_apply([], _Step, Dict, CopyList) ->
    {Dict, CopyList};
do_init_apply(MbList, Step, Dict, CopyList) ->
    Copy = length(CopyList),
    battlefield:create_def_mon(Copy),
    battlefield:create_buff_mon(Copy),
    case length(MbList) >= data_battlefield:scene_lim() of
        false ->
            NewDict = lists:foldl(fun(Mb, D) ->
                dict:store(Mb#bf_mb.pkey, Mb, D) end, Dict, distribute_group(MbList, Copy)),
            {NewDict, [Copy | CopyList]};
        true ->
            {NewMbList, MatchList} = distribute_copy(MbList, Copy, Step),
            NewDict = lists:foldl(fun(Mb, D) ->
                dict:store(Mb#bf_mb.pkey, Mb, D) end, Dict, MatchList),
            do_init_apply(NewMbList, Step, NewDict, [Copy | CopyList])
    end.

distribute_copy(MbList, Copy, Step) ->
    F = fun(Val, List) ->
        Min = (Val - 1) * Step,
        Max = Val * Step - 1,
        List ++ random_mb(MbList, Min, Max, Copy)
        end,
    MatchList = lists:foldl(F, [], lists:seq(1, 10)),
    F1 = fun(Mb) ->
        case lists:keymember(Mb#bf_mb.pkey, #bf_mb.pkey, MatchList) of
            false -> [Mb];
            true -> []
        end
         end,
    NewMbList = lists:flatmap(F1, MbList),
    {NewMbList, MatchList}.

distribute_group(MbList, Copy) ->
    F = fun(Mb, {[Group | T], L}) ->
        {?IF_ELSE(T == [], [1, 2, 3], T),
            [Mb#bf_mb{group = Group, copy = Copy} | L]}
        end,
    {_, NewMbList} = lists:foldl(F, {[1, 2, 3], []}, MbList),
    NewMbList.

random_mb(MbList, Min, Max, Copy) ->
    List = util:get_random_list([Mb || Mb <- MbList, Mb#bf_mb.step >= Min, Mb#bf_mb.step =< Max], 3),
    F = fun(Mb, {Group, L}) ->
        {Group + 1, [Mb#bf_mb{copy = Copy, group = Group} | L]}
        end,
    {_, L1} = lists:foldl(F, {1, []}, List),
    L1.

%%分配线路
match_copy(Now, CopyList, PDict) ->
    F = fun(Copy) ->
        Filter = player_filter(PDict, Copy, Now),
        Size = dict:size(Filter),
        case Size < data_battlefield:scene_lim() of
            true ->
                [{Copy, Size}];
            false ->
                []
        end
        end,
    case lists:keysort(2, lists:flatmap(F, CopyList)) of
        [] ->
            NewCopy = length(CopyList),
            battlefield:create_def_mon(NewCopy),
            battlefield:create_buff_mon(NewCopy),
            {NewCopy, [NewCopy | CopyList]};
        CountList ->
            {NewCopy, _} = hd(CountList),
            {NewCopy, CopyList}
    end.

%%分配分组
match_group(Cbp, Copy, PDict, Now) ->
    Filter = player_filter(PDict, Copy, Now),
    F = fun({_, Mb}, {CbpTotal, CountTotal, GroupCbpList}) ->
        case lists:keyfind(Mb#bf_mb.group, 1, GroupCbpList) of
            false -> {CbpTotal, CountTotal, GroupCbpList};
            {Group, GroupCount, GroupCbp} ->
                {CbpTotal + Mb#bf_mb.cbp, CountTotal + 1, lists:keyreplace(Group, 1, GroupCbpList, {Group, GroupCount + 1, GroupCbp + Mb#bf_mb.cbp})}
        end
        end,
    {CbpTotal1, CountTotal1, GroupCbpList1} = lists:foldl(F, {0, 0, [{1, 0, 0}, {2, 0, 0}, {3, 0, 0}]}, dict:to_list(Filter)),
    case CountTotal1 rem 3 == 0 of
        true ->
            %%人数一样情况下,大于平均战力的,优先战力最低的阵营
            CbpPer = ?IF_ELSE(CbpTotal1 > 0, CbpTotal1 div CountTotal1, 0),
            if Cbp >= CbpPer ->
                {MatchGroup, _, _} = hd(lists:keysort(3, GroupCbpList1)),
                MatchGroup;
                true ->
                    {MatchGroup, _, _} = lists:last(lists:keysort(3, GroupCbpList1)),
                    MatchGroup
            end;
        false ->
            %%人数不一样,优先人数最少的阵营
            {MatchGroup, _, _} = hd(lists:keysort(2, GroupCbpList1)),
            MatchGroup
    end.


player_filter(PDict, Copy, Now) ->
    Cd = data_battlefield:logout_cd(),
    dict:filter(fun(_, Mb) ->
        Mb#bf_mb.copy == Copy andalso (Mb#bf_mb.logout_time == 0 orelse Now - Mb#bf_mb.logout_time < Cd) end, PDict).


%%积分排行
rank(1, PDict) ->
    PList = lists:keysort(#bf_mb.score, [Mb || {_, Mb} <- dict:to_list(PDict)]),
    F = fun(Mb, {List, RankId}) ->
        {[Mb#bf_mb{rank = RankId, rank_val = Mb#bf_mb.score} | List], RankId + 1}
        end,
    {NewPList, _} = lists:foldl(F, {[], 1}, lists:reverse(PList)),
    lists:reverse(NewPList);
%%击杀排行
rank(2, PDict) ->
    PList = lists:keysort(#bf_mb.acc_kill, [Mb || {_, Mb} <- dict:to_list(PDict)]),
    F = fun(Mb, {List, RankId}) ->
        {[Mb#bf_mb{rank = RankId, rank_val = Mb#bf_mb.acc_kill} | List], RankId + 1}
        end,
    {NewPList, _} = lists:foldl(F, {[], 1}, lists:reverse(PList)),
    lists:reverse(NewPList);
rank(_, _) ->
    [].

%%死亡处理,获得能量,掉积分
die(Pkey, Pdict, Time, Sign) ->
    case dict:is_key(Pkey, Pdict) of
        false ->
            {Pdict, 0};
        true ->
            Mb = dict:fetch(Pkey, Pdict),
            {AccEnergy, AccDie} =
                if Sign == ?SIGN_MON -> {Mb#bf_mb.acc_energy, Mb#bf_mb.acc_die};
                    true ->
                        Die = Mb#bf_mb.acc_die + 1,
                        {Mb#bf_mb.acc_energy + energy(Die), Die}
                end,
            Score = die_lost_score(Mb#bf_mb.score),
            Score1 = combo_lost_score(Score, Mb#bf_mb.combo),
            NewMb = Mb#bf_mb{combo = 0, score = Score1, acc_die = AccDie, acc_energy = AccEnergy},
            spawn(fun() -> refresh_to_client(NewMb, Mb#bf_mb.score, Time) end),
            NewPdict = dict:store(Pkey, NewMb, Pdict),
            {NewPdict, Mb#bf_mb.combo}
    end.

%%死亡掉积分
die_lost_score(Score) ->
    F = fun(Id) ->
        {Min, Max, Add} = data_battlefield_die:get(Id),
        if Score >= Min andalso Score =< Max ->
            [Add];
            true ->
                []
        end
        end,
    case lists:flatmap(F, data_battlefield_die:ids()) of
        [] -> Score;
        [Val | _] ->
            max(0, Score - Val)
    end.


%%死亡掉积分
combo_lost_score(Score, Combo) ->
    F = fun(Id) ->
        {Min, Max, Add} = data_battlefield_die:get(Id),
        if Combo >= Min andalso Combo =< Max ->
            [Add];
            true ->
                []
        end
        end,
    case lists:flatmap(F, data_battlefield_die:ids()) of
        [] -> Score;
        [Val | _] ->
            max(0, Score - Val)
    end.


%%增加能量
energy(AccDie) ->
    Add = data_battlefield:energy_add(),
    ExtraList = data_battlefield:energy_extra(),
    {_, Extra} =
        case lists:keyfind(AccDie, 1, ExtraList) of
            false ->
                lists:last(ExtraList);
            Val -> Val

        end,
    Add + Extra.


%%击杀玩家,获得积分
kill(Pkey, Pdict, Combo, Time) ->
    case dict:is_key(Pkey, Pdict) of
        false -> Pdict;
        true ->
            Mb = dict:fetch(Pkey, Pdict),
            MyCombo = Mb#bf_mb.combo + 1,
            Score = Mb#bf_mb.score + data_battlefield:kill_score() + extra_combo(MyCombo) + extra_end_combo(Combo),
            NewMb = Mb#bf_mb{acc_kill = Mb#bf_mb.acc_kill + 1, combo = MyCombo, score = Score, acc_die = 0},
            spawn(fun() -> refresh_to_client(NewMb, Mb#bf_mb.score, Time),
                msg_combo(NewMb) end),
            dict:store(Pkey, NewMb, Pdict)
    end.

msg_combo(_Mb) ->
%%     case Mb#bf_mb.combo of
%%         3 ->
%%             F = fun(Node) ->
%%                 center:apply(Node, notice_sys, add_notice, [battlefield_combo_3, [#player{key = Mb#bf_mb.pkey, nickname = Mb#bf_mb.nickname, vip_lv = Mb#bf_mb.vip}]])
%%                 end,
%%             lists:foreach(F, center:get_nodes());
%%         8 ->
%%             F = fun(Node) ->
%%                 center:apply(Node, notice_sys, add_notice, [battlefield_combo_8, [#player{key = Mb#bf_mb.pkey, nickname = Mb#bf_mb.nickname, vip_lv = Mb#bf_mb.vip}]])
%%                 end,
%%             lists:foreach(F, center:get_nodes());
%%         15 ->
%%             F = fun(Node) ->
%%                 center:apply(Node, notice_sys, add_notice, [battlefield_combo_15, [#player{key = Mb#bf_mb.pkey, nickname = Mb#bf_mb.nickname, vip_lv = Mb#bf_mb.vip}]])
%%                 end,
%%             lists:foreach(F, center:get_nodes());
%%         _ -> skip
%%     end.
    ok.

%%获取连杀额外积分
extra_combo(Combo) ->
    F = fun(Id) ->
        {Min, Max, Score} = data_battlefield_dh:get(Id),
        if Combo >= Min andalso Combo =< Max ->
            [Score];
            true ->
                []
        end
        end,
    case lists:flatmap(F, data_battlefield_dh:ids()) of
        [] -> 0;
        [Val | _] ->
            Val
    end.

%%终止连杀额外积分
extra_end_combo(Combo) ->
    F = fun(Id) ->
        {Min, Max, Score} = data_battlefield_kdh:get(Id),
        if Combo >= Min andalso Combo =< Max ->
            [Score];
            true ->
                []
        end
        end,
    case lists:flatmap(F, data_battlefield_kdh:ids()) of
        [] -> 0;
        [Val | _] ->
            Val
    end.

%%助攻
assists(KeyList, FilterList, PDict, Time) ->
    F = fun(Pkey, D) ->
        case lists:member(Pkey, FilterList) of
            true -> D;
            false ->
                case dict:is_key(Pkey, D) of
                    false ->
                        D;
                    true ->
                        Mb = dict:fetch(Pkey, D),
                        Score = Mb#bf_mb.score + data_battlefield:assists_score(),
                        NewMb = Mb#bf_mb{acc_assists = Mb#bf_mb.acc_assists + 1, score = Score},
                        spawn(fun() -> refresh_to_client(NewMb, Mb#bf_mb.score, Time) end),
                        dict:store(Pkey, NewMb, D)
                end
        end
        end,
    lists:foldl(F, PDict, KeyList).

%%更新个人数据到客户端
refresh_to_client(Mb, _Score, Time) ->
    if Mb#bf_mb.is_online == 1 ->
        LeftTime = max(0, Time - util:unixtime()),
        Lim = data_battlefield:lim_energy(),
        Data = {Mb#bf_mb.acc_kill, Mb#bf_mb.acc_assists, Mb#bf_mb.combo, Mb#bf_mb.acc_energy, Lim, Mb#bf_mb.score, LeftTime},
        {ok, Bin} = pt_640:write(64004, Data),
        server_send:send_to_sid(Mb#bf_mb.node, Mb#bf_mb.sid, Bin),
%%        center:apply(Mb#bf_mb.node, server_send, send_to_sid, [Mb#bf_mb.sid, Bin]),
        server_send:send_node_pid(Mb#bf_mb.node, Mb#bf_mb.pid, {battlefield, Mb#bf_mb.score, Mb#bf_mb.combo}),
        ok;
        true -> skip
    end,
%%     Score1 = 500,
%%     if Mb#bf_mb.score >= Score1 andalso Score =< Score1 ->
%%         F = fun(Node) ->
%%             center:apply(Node, notice_sys, add_notice, [battlefield_score, [#player{key = Mb#bf_mb.pkey, nickname = Mb#bf_mb.nickname, vip_lv = Mb#bf_mb.vip}, Score1]])
%%             end,
%%         lists:foreach(F, center:get_nodes());
%%         true -> skip
%%     end,
    ok.

%%宝箱位置信息
box_list(PosList, Copy) ->
    Now = util:unixtime(),
    F = fun(Base) ->
        case lists:keyfind(Copy, 1, Base#base_battlefield_box.pid_list) of
            false ->
                case [T || T <- Base#base_battlefield_box.refresh_time, T > Now] of
                    [] -> [];
                    [Time | _] ->
                        [[Base#base_battlefield_box.mon_id, Base#base_battlefield_box.x, Base#base_battlefield_box.y, 0, Time - Now]]
                end;
            {_, Pid} ->
                case misc:is_process_alive(Pid) of
                    false ->
                        case [T || T <- Base#base_battlefield_box.refresh_time, T > Now] of
                            [] -> [];
                            [Time | _] ->
                                [[Base#base_battlefield_box.mon_id, Base#base_battlefield_box.x, Base#base_battlefield_box.y, 0, Time - Now]]
                        end;
                    true -> []
                end
        end
        end,
    Data = lists:flatmap(F, PosList),
    {ok, Bin} = pt_640:write(64007, {Data}),
    Bin.

%%更新水晶信息
update_box_list(PosList, CopyList) ->
    F = fun(Copy) ->
        update_box_single(PosList, Copy)
        end,
    lists:foreach(F, CopyList),
    ok.

update_box_single(PosList, Copy) ->
    Bin = box_list(PosList, Copy),
    UserList = scene_agent:get_copy_scene_player(?SCENE_ID_BATTLEFIELD, Copy),
    F = fun(ScenePlayer) ->
        server_send:send_to_sid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.sid, Bin)
%%        center:apply(ScenePlayer#scene_player.node, server_send, send_to_sid, [ScenePlayer#scene_player.sid, Bin])
        end,
    lists:foreach(F, UserList).


%%战场结算了喂
battlefield_finish(Pdict, Now) ->
    MbList = rank(1, Pdict),
    spawn(fun() -> reward(MbList, Now),
        util:sleep(500),
        title_score(MbList),
        util:sleep(500),
        title_kill(Pdict)
          end),

    ok.

reward([], _) -> ok;
reward([Mb | T], Now) ->
    GoodsList = reward_goods_list(Mb#bf_mb.rank),
    Honor = round(100 + 35 * math:pow(Mb#bf_mb.score, 0.5)),
    ActivityGoods = data_activity_dun_drop:get(10),
    NewGoodsList = GoodsList ++ [{?GOODS_ID_HONOR, Honor}] ++ ActivityGoods,
    center:apply(Mb#bf_mb.node, battlefield, reward_msg, [Mb#bf_mb.pkey, Mb#bf_mb.nickname, Mb#bf_mb.rank, Mb#bf_mb.score, Honor, NewGoodsList]),
    reward(T, Now).


%%排名奖励
reward_goods_list(Rank) ->
    F = fun(Id) ->
        {Min, Max, GoodsList} = data_battlefield_reward:get(Id),
        if Rank >= Min andalso Rank =< Max ->
            GoodsList;
            true ->
                []
        end
        end,
    lists:flatmap(F, data_battlefield_reward:ids()).

%%积分第一称号
title_score(MbList) ->
    case MbList of
        [] -> skip;
        _ -> ok
%%             Mb = hd(MbList),
%%             F = fun(Node) ->
%%                 center:apply(Node, notice_sys, add_notice, [battlefield_title_score, [#player{key = Mb#bf_mb.pkey, nickname = Mb#bf_mb.nickname, vip_lv = Mb#bf_mb.vip}]])
%%                 end,
%%             lists:foreach(F, center:get_nodes())
    end.

%%击杀第一称号
title_kill(Pdict) ->
    case rank(1, Pdict) of
        [] -> skip;
        _MbList -> ok
%%             Mb = hd(MbList),
%%             F = fun(Node) ->
%%                 center:apply(Node, notice_sys, add_notice, [battlefield_title_kill, [#player{key = Mb#bf_mb.pkey, nickname = Mb#bf_mb.nickname, vip_lv = Mb#bf_mb.vip}]])
%%                 end,
%%             lists:foreach(F, center:get_nodes())
    end.
