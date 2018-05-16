%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 六月 2016 10:40
%%%-------------------------------------------------------------------
-module(cross_eliminate_play).
-author("hxming").

-behaviour(gen_server).

-include("cross_eliminate.hrl").
-include("scene.hrl").
-include("common.hrl").

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-record(state, {
    mb_list = [],
    is_finish = 0,
    ref = 0,
    time = 0
}).
-define(SERVER, ?MODULE).

%% API
-export([start/1, stop/1, mon_die/2, check_info/2]).

-define(TIMER, 180).
-define(SHOT_TIME, 3000).
-define(EFFECT_TIME, 2000).
-define(SHOT_TIME1, 800).

%%创建房间
start(MbList) ->
    gen_server:start(?MODULE, [MbList], []).

%%停止
stop(Pid) ->
    case is_pid(Pid) of
        false -> skip;
        true ->
            Pid ! close
    end.

%%怪物死亡
mon_die(Mon, Pkey) ->
    case scene:is_cross_eliminate_scene(Mon#mon.scene) of
        false -> skip;
        true ->
            Mon#mon.copy ! {client_eliminate, Mon#mon.key, Pkey}
    end.

%%查询挑战信息
check_info(Pkey, Copy) ->
        catch Copy ! {score_info, Pkey}.

init([MbList]) ->
    scene_init:priv_create_scene(?SCENE_ID_CROSS_ELIMINATE, self()),
    Ref = erlang:send_after(100, self(), ready),
    {ok, #state{mb_list = MbList, ref = Ref}}.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.


handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(Request, State) ->
    case catch info(Request, State) of
        {stop, NewState} ->
            {stop, normal, NewState};
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross eliminate play handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.


terminate(_Reason, State) ->
    util:cancel_ref([State#state.ref]),
    [monster:stop_broadcast(Aid) || Aid <- mon_agent:get_scene_mon_pids(?SCENE_ID_CROSS_ELIMINATE, self())],
%%    scene_agent:clean_scene_area(?SCENE_ID_CROSS_ELIMINATE, self()),
    scene_init:priv_stop_scene(?SCENE_ID_CROSS_ELIMINATE, self()),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

info(ready, State) ->
    Timer = 5,
    F = fun(Mb) ->
        if Mb#eliminate_mb.pid == none -> ok;
            true ->
                [Fighter | _] = lists:keydelete(Mb#eliminate_mb.pkey, #eliminate_mb.pkey, State#state.mb_list),
                {ok, Bin} = pt_590:write(59007, {Fighter#eliminate_mb.sn, Fighter#eliminate_mb.pkey, Fighter#eliminate_mb.nickname,
                    Fighter#eliminate_mb.career, Fighter#eliminate_mb.sex, Fighter#eliminate_mb.cbp, Fighter#eliminate_mb.vip,
                    Fighter#eliminate_mb.fashion_cloth_id, Fighter#eliminate_mb.light_weaponid,
                    Fighter#eliminate_mb.wing_id, Fighter#eliminate_mb.clothing_id,
                    Fighter#eliminate_mb.weapon_id,
                    Timer, Fighter#eliminate_mb.avatar}),
                server_send:send_node_pid(Mb#eliminate_mb.node, Mb#eliminate_mb.pid, eliminate_times),
                server_send:send_to_sid(Mb#eliminate_mb.node, Mb#eliminate_mb.sid, Bin)
%%                center:apply(Mb#eliminate_mb.node, server_send, send_to_sid, [Mb#eliminate_mb.sid, Bin])
        end
        end,
    lists:foreach(F, State#state.mb_list),
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(Timer * 1000, self(), fight),
    %%分组
    MbList = init_group(State#state.mb_list),
    {noreply, State#state{ref = Ref, mb_list = MbList}};

%%通知玩家进入
info(fight, State) ->
    F = fun(Mb) ->
        if Mb#eliminate_mb.type == ?CROSS_ELIMINATE_MB_TYPE_ROBOT ->
            shadow:create_shadow_for_eliminate(Mb#eliminate_mb.shadow, ?SCENE_ID_CROSS_ELIMINATE, self(), Mb#eliminate_mb.x, Mb#eliminate_mb.y),
            Ref1 = erlang:send_after(5 * 1000, self(), {ai_eliminate, Mb#eliminate_mb.pkey}),
            put({ai_eliminate, Mb#eliminate_mb.pkey}, Ref1);
            Mb#eliminate_mb.pid == none -> skip;
            true ->
                server_send:send_node_pid(Mb#eliminate_mb.node, Mb#eliminate_mb.pid, {enter_cross_eliminate, self(), Mb#eliminate_mb.x, Mb#eliminate_mb.y, Mb#eliminate_mb.group})
        end
        end,
    lists:foreach(F, State#state.mb_list),
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(?TIMER * 1000, self(), finish),
    %%初始化怪物数据
    MbList = init_eliminate_mon(State#state.mb_list),
    {noreply, State#state{mb_list = MbList, ref = Ref, time = util:unixtime() + ?TIMER}};


%%比分信息
info({score_info, PKey}, State) ->
    case lists:keyfind(PKey, #eliminate_mb.pkey, State#state.mb_list) of
        false -> skip;
        Mb ->
            Now = util:unixtime(),
            LeftTime = max(0, State#state.time - Now),
            F = fun(M) -> [M#eliminate_mb.pkey, M#eliminate_mb.score, ?CROSS_ELIMINATE_SCORE] end,
            ScoreList = lists:map(F, State#state.mb_list),
            {ok, Bin} = pt_590:write(59008, {LeftTime, ScoreList}),
            server_send:send_to_sid(Mb#eliminate_mb.node, Mb#eliminate_mb.sid, Bin),
%%            center:apply(Mb#eliminate_mb.node, server_send, send_to_sid, [Mb#eliminate_mb.sid, Bin]),
            refresh_buff_list(State#state.mb_list)
    end,
    {noreply, State};


%%怪物死亡,计算消除
info({client_eliminate, MKey, PKey}, State) when State#state.is_finish == 0 ->
    MbList =
        case lists:keytake(PKey, #eliminate_mb.pkey, State#state.mb_list) of
            false ->
                State#state.mb_list;
            {value, Mb, T} ->
                NewMb = client_eliminate(Mb, MKey, State#state.mb_list),
                [NewMb | T]
        end,
    if MbList /= State#state.mb_list ->
        refresh_score_list(MbList, State#state.time),
        refresh_buff_list(MbList);
        true -> skip
    end,
    {noreply, State#state{mb_list = MbList}};

%%查找系统AI可消除的怪物
info({ai_eliminate, PKey}, State) when State#state.is_finish == 0 ->
    misc:cancel_timer({ai_eliminate, PKey}),
    MbList =
        case lists:keytake(PKey, #eliminate_mb.pkey, State#state.mb_list) of
            false -> State#state.mb_list;
            {value, Mb, T} ->
                NewMb = ai_eliminate(Mb),
                [NewMb | T]
        end,
    {noreply, State#state{mb_list = MbList}};

%%检查是否可连击消除
info({sys_eliminate, Pkey}, State) when State#state.is_finish == 0 ->
    misc:cancel_timer({sys_eliminate, Pkey}),
    MbList =
        case lists:keytake(Pkey, #eliminate_mb.pkey, State#state.mb_list) of
            false -> State#state.mb_list;
            {value, Mb, T} ->
                NewMb = sys_eliminate(Mb, State#state.mb_list),
                [NewMb | T]
        end,
    if MbList /= State#state.mb_list ->
        refresh_score_list(MbList, State#state.time),
        refresh_buff_list(MbList);
        true -> skip
    end,
    {noreply, State#state{mb_list = MbList}};

info({sys_buff_effect, Pkey}, State) when State#state.is_finish == 0 ->
    misc:cancel_timer({ai_eliminate, Pkey}),
    Ref = erlang:send_after(?EFFECT_TIME, self(), {ai_eliminate, Pkey}),
    put({ai_eliminate, Pkey}, Ref),
    {noreply, State};

info({logout, Key}, State) when State#state.is_finish == 0 ->
    MbList =
        case lists:keytake(Key, #eliminate_mb.pkey, State#state.mb_list) of
            false -> State#state.mb_list;
            {value, Mb, T} ->
                [Mb#eliminate_mb{pid = none} | T]
        end,
    case lists:all(fun(Mb) -> Mb#eliminate_mb.pid == none andalso Mb#eliminate_mb.type == 0 end, MbList) of
        true ->
            self() ! finish,
            {noreply, State#state{mb_list = MbList}};
        false ->
            {noreply, State#state{mb_list = MbList}}
    end;

%%结束判断胜负结算
info(finish, State) when State#state.is_finish == 0 ->
    [Mb1, Mb2] = State#state.mb_list,
    cross_eliminate:update_qinmidu(Mb1, Mb2),
    MbList = ?IF_ELSE(Mb1#eliminate_mb.score > Mb2#eliminate_mb.score, [{win, Mb1}, {lose, Mb2}], [{win, Mb2}, {lose, Mb1}]),
    play_ret(MbList),
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(?SHOT_TIME, self(), stop),
    {noreply, State#state{is_finish = 1, ref = Ref}};

info(stop, State) ->
    send_out(),
    {stop, State};

info(_Msg, State) ->
    {noreply, State}.


send_out() ->
    PlayerList = scene_agent:get_copy_scene_player(?SCENE_ID_CROSS_ELIMINATE, self()),
    F1 = fun(ScenePlayer) ->
        server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_eliminate)
         end,
    lists:foreach(F1, PlayerList).

%%结算
play_ret(MbList) ->
    F = fun({Type, Mb}) ->
        Ret = ?IF_ELSE(Type == win, 1, 0),
        GoodsList =
            if Mb#eliminate_mb.type == ?CROSS_ELIMINATE_MB_TYPE_ROBOT ->
                [];
                Mb#eliminate_mb.times >= ?CROSS_ELIMINATE_MAX_TIMES ->
                    center:apply(Mb#eliminate_mb.node, cross_eliminate, eliminate_ret, [Mb#eliminate_mb.pkey, Ret]),
                    [];
                true ->
                    RewardList = tuple_to_list(?IF_ELSE(Type == win, data_cross_eliminate_challenge_reward:get_win(Mb#eliminate_mb.lv), data_cross_eliminate_challenge_reward:get_fail(Mb#eliminate_mb.lv))),
                    IsMail = ?IF_ELSE(Mb#eliminate_mb.pid == none, true, false),
                    center:apply(Mb#eliminate_mb.node, cross_eliminate, reward_msg, [Mb#eliminate_mb.pkey, Ret, RewardList, IsMail]),
                    RewardList
            end,
        [Mb#eliminate_mb.sn, Mb#eliminate_mb.pkey, Mb#eliminate_mb.nickname, Mb#eliminate_mb.career, Mb#eliminate_mb.sex, Mb#eliminate_mb.avatar, Mb#eliminate_mb.vip,
            Mb#eliminate_mb.score, Ret, goods:pack_goods(GoodsList)]
        end,
    Data = lists:map(F, MbList),
    {ok, Bin} = pt_590:write(59012, {Data}),
    server_send:send_to_scene(?SCENE_ID_CROSS_ELIMINATE, self(), Bin),
    F1 = fun({Type, Mb}) ->
        if Mb#eliminate_mb.type == ?CROSS_ELIMINATE_MB_TYPE_ROBOT -> [];
            true ->
                Wins = ?IF_ELSE(Type == win, 1, 0),
                [#eliminate_log{pkey = Mb#eliminate_mb.pkey, nickname = Mb#eliminate_mb.nickname, sn = Mb#eliminate_mb.sn, wins = Wins}]
        end
         end,
    RetList = lists:flatmap(F1, MbList),
    cross_eliminate_proc:get_server_pid() ! {play_ret, RetList},
    ok.

init_group(MbList) ->
    F = fun(Mb, {Group, L}) ->
        {X, Y} = ?IF_ELSE(Group == 1, data_cross_eliminate_pos:get(-1), data_cross_eliminate_pos:get(0)),
        {Group + 1, [Mb#eliminate_mb{group = Group, x = X, y = Y} | L]}
        end,
    {_, NewMbList} = lists:foldl(F, {1, []}, MbList),
    NewMbList.

%%初始化怪物
init_eliminate_mon(MbList) ->
    F = fun(Mb) ->
        Mb#eliminate_mb{mon_list = cross_eliminate_init:default(Mb#eliminate_mb.group)}
        end,
    lists:map(F, MbList).


%%客户端玩家主动消除
client_eliminate(Mb, MKey, MbList) ->
    case lists:keytake(MKey, #eliminate_mon.key, Mb#eliminate_mb.mon_list) of
        false ->
            Mb;
        {value, Mon, T} ->
            CleanList = eliminate_type(Mon#eliminate_mon.type, Mon, T),
            Score = lists:sum([M#eliminate_mon.eli_score || M <- lists:keydelete(MKey, #eliminate_mon.key, CleanList)]) + Mon#eliminate_mon.score,
            NewScore = min(Mb#eliminate_mb.score + Score, ?CROSS_ELIMINATE_SCORE),
            %%积分达成
            ?IF_ELSE(NewScore >= ?CROSS_ELIMINATE_SCORE, self() ! finish, ok),
            NewMb = Mb#eliminate_mb{score = NewScore, combo = 0},
            %%广播怪物消失
            clean_mon_list(NewMb, CleanList, 1, MKey),
            %%buff效果
            buff_effect(MbList, lists:keydelete(MKey, #eliminate_mon.key, CleanList), Mb#eliminate_mb.pkey),
            %%刷新怪物
            MonList = refresh_mon_list(CleanList, Mb#eliminate_mb.mon_list, Mb#eliminate_mb.hp_lim),
            %%检查是否连击
            misc:cancel_timer({sys_eliminate, Mb#eliminate_mb.pkey}),
            Ref = erlang:send_after(?SHOT_TIME1, self(), {sys_eliminate, Mb#eliminate_mb.pkey}),
            put({sys_eliminate, Mb#eliminate_mb.pkey}, Ref),
            NewMb#eliminate_mb{mon_list = MonList}
    end.

%%系统AI查找可消除怪物
ai_eliminate(Mb) ->
    %%查找一列或者一行中是否有两个相同的
    %%检查是否行相同
    F = fun(LineNum, List) ->
        List ++ check_line_mon(LineNum, Mb#eliminate_mb.mon_list)
        end,
    FilterLineList = lists:foldl(F, [], lists:seq(1, 3)),
    %%检查是否列相同
    F1 = fun(RowNum, List) ->
        List ++ check_row_mon(RowNum, Mb#eliminate_mb.mon_list)
         end,
    FilterRowList = lists:foldl(F1, [], lists:seq(1, 3)),
    MonList =
        case util:list_filter_repeat(FilterLineList ++ FilterRowList) of
            [] ->
                case [M || M <- Mb#eliminate_mb.mon_list, M#eliminate_mon.type == 1] of
                    [] ->
                        Mb#eliminate_mb.mon_list;
                    List -> List
                end;
            FilterList -> FilterList
        end,
    case MonList of
        [] -> Mb;
        _ ->
            {Range, Mon} = hd(lists:keysort(1, [{util:calc_coord_range(Mb#eliminate_mb.x, Mb#eliminate_mb.y, M#eliminate_mon.x, M#eliminate_mon.y), M} || M <- MonList])),
            Timer = ?IF_ELSE(Range == 0, 1, 2),
            erlang:send_after(Timer * 1000, self(), {client_eliminate, Mon#eliminate_mon.key, Mb#eliminate_mb.pkey}),
            if Mb#eliminate_mb.x == Mon#eliminate_mon.x andalso Mb#eliminate_mb.y == Mon#eliminate_mon.y ->
                Mb;
                true ->
                    case misc:is_process_alive(Mon#eliminate_mon.pid) of
                        true ->
                            PidList = mon_agent:get_scene_shadow_pids(?SCENE_ID_CROSS_ELIMINATE, self()),
                            %%分身走动
                            F2 = fun(Pid) ->
                                Pid ! {move, Mon#eliminate_mon.x, Mon#eliminate_mon.y}
                                 end,
                            lists:foreach(F2, PidList);
                        false -> skip
                    end,
                    Mb#eliminate_mb{x = Mon#eliminate_mon.x, y = Mon#eliminate_mon.y}
            end
    end.


%%系统检查行列相同消除/特殊消除,连击
sys_eliminate(Mb, MbList) ->
    %%检查是否行相同
    F = fun(LineNum, List) ->
        List ++ get_line_mon(LineNum, Mb#eliminate_mb.mon_list)
        end,
    FilterLineList = lists:foldl(F, [], lists:seq(1, 3)),
    %%检查是否列相同
    F1 = fun(RowNum, List) ->
        List ++ get_row_mon(RowNum, Mb#eliminate_mb.mon_list)
         end,
    FilterRowList = lists:foldl(F1, [], lists:seq(1, 3)),
    %%特殊怪物
    F2 = fun(Mon) ->
        if Mon#eliminate_mon.type == 1 orelse Mon#eliminate_mon.type == 6 -> [];
            true -> [Mon]
        end
         end,
    FilterSpecialList = lists:flatmap(F2, Mb#eliminate_mb.mon_list),
    case util:list_filter_repeat(FilterLineList ++ FilterRowList ++ FilterSpecialList) of
        [] ->
            if Mb#eliminate_mb.type == ?CROSS_ELIMINATE_MB_TYPE_ROBOT ->
                Ref = erlang:send_after(?SHOT_TIME1, self(), {ai_eliminate, Mb#eliminate_mb.pkey}),
                put({ai_eliminate, Mb#eliminate_mb.pkey}, Ref);
                true -> ok
            end,
            Mb;
        FilterList ->
            F3 = fun(Mon) ->
                eliminate_type(Mon#eliminate_mon.type, Mon, Mb#eliminate_mb.mon_list)
                 end,
            FilterList1 = lists:flatmap(F3, FilterList),
            CleanList = util:list_filter_repeat(FilterList1),
            Multiple =
                case Mb#eliminate_mb.combo of
                    0 -> 1.5;
                    1 -> 2;
                    _ -> 3
                end,
            Score = round(lists:sum([M#eliminate_mon.eli_score || M <- CleanList]) * Multiple),
            NewScore = min(Mb#eliminate_mb.score + Score, ?CROSS_ELIMINATE_SCORE),
            %%积分达成
            ?IF_ELSE(NewScore >= ?CROSS_ELIMINATE_SCORE, self() ! finish, ok),
            NewMb = Mb#eliminate_mb{score = NewScore, combo = Mb#eliminate_mb.combo + 1},
            %%广播怪物消失
            clean_mon_list(NewMb, CleanList, Multiple, 0),
            %%buff效果
            buff_effect(MbList, CleanList, Mb#eliminate_mb.pkey),
            %%刷新怪物
            MonList = refresh_mon_list(CleanList, Mb#eliminate_mb.mon_list, Mb#eliminate_mb.hp_lim),
            %%检查是否连击
            Ref = erlang:send_after(?SHOT_TIME1, self(), {sys_eliminate, Mb#eliminate_mb.pkey}),
            put({sys_eliminate, Mb#eliminate_mb.pkey}, Ref),
            NewMb#eliminate_mb{mon_list = MonList}
    end.

%%获取同行列表
get_line_mon(LineNum, MonList) ->
    F = fun(Mon) ->
        case cross_eliminate_init:line(Mon#eliminate_mon.id) == LineNum of
            true -> [Mon];
            false -> []
        end
        end,
    LineMonList = lists:flatmap(F, MonList),
    case length(util:list_filter_repeat([M#eliminate_mon.mid || M <- LineMonList])) == 1 of
        true -> LineMonList;
        false -> []
    end.
%%获取同列列表
get_row_mon(RowNum, MonList) ->
    F = fun(Mon) ->
        case cross_eliminate_init:row(Mon#eliminate_mon.id) == RowNum of
            true -> [Mon];
            false -> []
        end
        end,
    RowMonList = lists:flatmap(F, MonList),
    case length(util:list_filter_repeat([M#eliminate_mon.mid || M <- RowMonList])) == 1 of
        true -> RowMonList;
        false -> []
    end.

%%检查一行是否有俩相同
check_line_mon(LineNum, MonList) ->
    F = fun(Mon) ->
        case cross_eliminate_init:line(Mon#eliminate_mon.id) == LineNum of
            true -> [Mon];
            false -> []
        end
        end,
    LineMonList = lists:flatmap(F, MonList),
    MidList = util:list_filter_repeat([M#eliminate_mon.mid || M <- LineMonList]),
    case length(MidList) == 2 of
        true ->
            F1 = fun(Mid, L) ->
                L1 = [M || M <- LineMonList, M#eliminate_mon.mid == Mid, M#eliminate_mon.type == 1],
                case length(L1) == 1 of
                    true -> L1 ++ L;
                    false -> L
                end
                 end,
            lists:foldl(F1, [], MidList);
        false -> []
    end.

%%检查一列是否有俩相同
check_row_mon(RowNum, MonList) ->
    F = fun(Mon) ->
        case cross_eliminate_init:row(Mon#eliminate_mon.id) == RowNum of
            true -> [Mon];
            false -> []
        end
        end,
    RowMonList = lists:flatmap(F, MonList),
    MidList = util:list_filter_repeat([M#eliminate_mon.mid || M <- RowMonList]),
    case length(MidList) == 2 of
        true ->
            F1 = fun(Mid, L) ->
                L1 = [M || M <- RowMonList, M#eliminate_mon.mid == Mid, M#eliminate_mon.type == 1],
                case length(L1) == 1 of
                    true -> L1 ++ L;
                    false -> L
                end
                 end,
            lists:foldl(F1, [], MidList);
        false -> []
    end.

eliminate_type(Type, Mon, MonList) ->
    CleanList = do_eliminate_type(Type, Mon, MonList),
    CleanList.

%%单独消除
do_eliminate_type(1, Mon, _MonList) ->
    [Mon];
%%消除行
do_eliminate_type(2, Mon, MonList) ->
    LineNum = cross_eliminate_init:line(Mon#eliminate_mon.id),
    F = fun(M, L) ->
        case cross_eliminate_init:line(M#eliminate_mon.id) == LineNum of
            false -> L;
            true ->
                List = do_eliminate_type(M#eliminate_mon.type, M, lists:keydelete(M#eliminate_mon.id, #eliminate_mon.id, MonList)),
                [M | L] ++ List
        end
        end,
    CleanList = lists:foldl(F, [], MonList),
    util:list_filter_repeat(CleanList ++ [Mon]);
%%消除列
do_eliminate_type(3, Mon, MonList) ->
    RowNum = cross_eliminate_init:row(Mon#eliminate_mon.id),
    F = fun(M, L) ->
        case cross_eliminate_init:row(M#eliminate_mon.id) == RowNum of
            false -> L;
            true ->
                List = do_eliminate_type(M#eliminate_mon.type, M, lists:keydelete(M#eliminate_mon.id, #eliminate_mon.id, MonList)),
                [M | L] ++ List
        end
        end,
    CleanList = lists:foldl(F, [], MonList),
    util:list_filter_repeat(CleanList ++ [Mon]);
%%十字消除
do_eliminate_type(4, Mon, MonList) ->
    LineNum = cross_eliminate_init:line(Mon#eliminate_mon.id),
    RowNum = cross_eliminate_init:row(Mon#eliminate_mon.id),
    F = fun(M, L) ->
        case cross_eliminate_init:line(M#eliminate_mon.id) == LineNum orelse cross_eliminate_init:row(M#eliminate_mon.id) == RowNum of
            false -> L;
            true ->
                List = do_eliminate_type(M#eliminate_mon.type, M, lists:keydelete(M#eliminate_mon.id, #eliminate_mon.id, MonList)),
                [M | L] ++ List
        end
        end,
    CleanList = lists:foldl(F, [], MonList),
    util:list_filter_repeat(CleanList ++ [Mon]);
%%九宫消除
do_eliminate_type(5, Mon, MonList) ->
    MonList ++ [Mon];
%%攻击怪
do_eliminate_type(6, Mon, _MonList) ->
    [Mon].

%%刷新怪物列表
refresh_mon_list(CleanList, MonList, HpLim) ->
    F = fun(Mon) ->
        case lists:keymember(Mon#eliminate_mon.id, #eliminate_mon.id, CleanList) of
            true -> [];
            false -> [Mon]
        end
        end,
    LiveList = lists:flatmap(F, MonList),
    F1 = fun(Mon, L) -> [new_mon(Mon, L, HpLim) | L] end,
    lists:foldl(F1, LiveList, CleanList).

new_mon(Mon, MonList, _HpLim) ->
    %%特殊怪物唯一性,存在则不会再次刷出/同一位置不重复出现
    FilterIds = [M#eliminate_mon.mid || M <- MonList, M#eliminate_mon.type /= 1] ++ [Mon#eliminate_mon.mid],
    Mid = cross_eliminate_init:random_mon_single(FilterIds),
    Type = data_cross_eliminate:get_type(Mid),
    case Type of
        6 ->
            Hp = 3,
            {MKey, Pid} = mon_agent:create_mon([Mid, ?SCENE_ID_CROSS_ELIMINATE, Mon#eliminate_mon.x, Mon#eliminate_mon.y, self(), 1, [{hp, Hp}, {hp_lim, Hp}, {return_id_pid, true}, {eliminate_group, Mon#eliminate_mon.group}]]);
        _ ->
            {MKey, Pid} = mon_agent:create_mon([Mid, ?SCENE_ID_CROSS_ELIMINATE, Mon#eliminate_mon.x, Mon#eliminate_mon.y, self(), 1, [{return_id_pid, true}, {eliminate_group, Mon#eliminate_mon.group}]])
    end,
    BuffId = cross_eliminate_init:random_mon_buff(Mid),
    Score = data_cross_eliminate:get_score(Mid),
    EliScore = data_cross_eliminate:get_eli_score(Mid),
    Mon#eliminate_mon{mid = Mid, type = Type, key = MKey, pid = Pid, buff = BuffId, score = Score, eli_score = EliScore}.


%%广播更新buff信息到客户端
refresh_buff_list(MbList) ->
    F = fun(Mb) ->
        F1 = fun(M) -> [M#eliminate_mon.id, M#eliminate_mon.buff, M#eliminate_mon.x, M#eliminate_mon.y] end,
        lists:map(F1, Mb#eliminate_mb.mon_list)
        end,
    BuffList = lists:flatmap(F, MbList),
    {ok, Bin} = pt_590:write(59009, {BuffList}),
    server_send:send_to_scene(?SCENE_ID_CROSS_ELIMINATE, self(), Bin),
    ok.

%%buff效果
buff_effect(MbList, MonList, Pkey) ->
    case lists:keydelete(Pkey, #eliminate_mb.pkey, MbList) of
        [] -> skip;
        [Mb | _] ->
            case util:list_filter_repeat([Mon#eliminate_mon.buff || Mon <- MonList, Mon#eliminate_mon.buff > 0]) of
                [] -> skip;
                BuffList ->
                    if Mb#eliminate_mb.type == ?CROSS_ELIMINATE_MB_TYPE_ROBOT ->
                        self() ! {sys_buff_effect, Mb#eliminate_mb.pkey};
                        true ->
                            ?DO_IF(Mb#eliminate_mb.pid /= none, server_send:send_node_pid(Mb#eliminate_mb.node, Mb#eliminate_mb.pid, {eliminate_buff, BuffList})),
                            F = fun(M) ->
                                if M#eliminate_mon.buff > 0 ->
                                    [[M#eliminate_mon.id, M#eliminate_mon.buff, M#eliminate_mon.x, M#eliminate_mon.y]];
                                    true -> []
                                end
                                end,
                            Data = lists:flatmap(F, MonList),
                            {ok, Bin} = pt_590:write(59010, {Mb#eliminate_mb.pkey, Data}),
                            server_send:send_to_scene(?SCENE_ID_CROSS_ELIMINATE, self(), Bin)
                    end

            end
    end,
    ok.

%%清除,广播怪物消失
clean_mon_list(Mb, MonList, Multiple, Mkey) ->
    F = fun(Mon) ->
        case misc:is_process_alive(Mon#eliminate_mon.pid) of
            false -> skip;
            true ->
                monster:stop_broadcast(Mon#eliminate_mon.pid)
        end
        end,
    lists:foreach(F, MonList),

    F1 = fun(Mon) ->
        Score =
            if Mkey == Mon#eliminate_mon.key ->
                round(Mon#eliminate_mon.score * Multiple);
                true ->
                    round(Mon#eliminate_mon.eli_score * Multiple)
            end,
        [Mon#eliminate_mon.id, Mon#eliminate_mon.x, Mon#eliminate_mon.y, Score]
         end,
    Ids = lists:map(F1, MonList),
    {ok, Bin} = pt_590:write(59011, {Mb#eliminate_mb.pkey, Mb#eliminate_mb.combo, Ids}),
    server_send:send_to_scene(?SCENE_ID_CROSS_ELIMINATE, self(), Bin).

%%更新积分
refresh_score_list(MbList, Time) ->
    Now = util:unixtime(),
    LeftTime = max(0, Time - Now),
    F = fun(M) -> [M#eliminate_mb.pkey, M#eliminate_mb.score, ?CROSS_ELIMINATE_SCORE] end,
    ScoreList = lists:map(F, MbList),
    {ok, Bin} = pt_590:write(59008, {LeftTime, ScoreList}),
    server_send:send_to_scene(?SCENE_ID_CROSS_ELIMINATE, self(), Bin).
