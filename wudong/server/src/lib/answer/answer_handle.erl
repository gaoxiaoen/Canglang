%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2017 下午8:10
%%%-------------------------------------------------------------------
-module(answer_handle).
-author("fengzhenlin").
-include("common.hrl").
-include("answer.hrl").
-include("scene.hrl").
-include("achieve.hrl").
%% API
-export([
    handle_call/3, handle_cast/2, handle_info/2
]).

handle_call({get_anwer_rank_top_n, N}, _From, State) ->
    List = get_rank_list(-1),
    Res =
        case List of
            [] -> [];
            _ ->
                lists:sublist(List, N)
        end,
    {reply, Res, State};

handle_call(_Info, _From, State) ->
    ?ERR("answer_handle call info ~p~n", [_Info]),
    {reply, ok, State}.

%%获取答题活动状态
handle_cast({get_answer_state, Sid, Node}, State) ->
    #answer_st{
        state = AState,
        start_time = StartTime,
        end_time = EndTime
    } = State,
    {S, T} =
        if
            AState == 1 ->
                Now = util:unixtime(),
                {1, max(0, EndTime - Now)};
            AState == 2 ->
                Now = util:unixtime(),
                {2, max(0, StartTime - Now)};
            true ->
                {0, 0}
        end,
    {ok, Bin} = pt_260:write(26000, {S, T}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%检查进入答题场景
handle_cast({check_enter_answer_scene, MyPinfo, CurScene}, State) ->
    #a_pinfo{
        pkey = Pkey,
        lv = Lv,
        node = Node,
        sid = Sid
    } = MyPinfo,
    Res =
        if
            Lv < ?ANSWER_OPEN_LV -> {false, 5};
            CurScene == ?SCENE_ID_ANSWER -> {false, 2};
            State#answer_st.state == 0 -> {false, 8};
            true ->
                case scene:is_normal_scene(CurScene) of
                    false -> {false, 3};
                    true ->
                        if
                            State#answer_st.state == 0 -> {false, 4};
                            true ->
                                Copy = get_copy(MyPinfo, State#answer_st.copy_list),
                                Base = data_scene:get(?SCENE_ID_ANSWER),
                                {X, Y} =
                                    case ets_get_pinfo(Pkey) of
                                        [] ->
                                            {Base#scene.x, Base#scene.y};
                                        OldPinfo ->
                                            CurQId = get_cur_question_id(State),
                                            case OldPinfo#a_pinfo.question_id == CurQId of
                                                true ->
                                                    case OldPinfo#a_pinfo.my_answer of
                                                        1 -> ?ANSWER_SCENE_XY_1;
                                                        2 -> ?ANSWER_SCENE_XY_2;
                                                        _ -> {Base#scene.x, Base#scene.y}
                                                    end;
                                                false ->
                                                    {Base#scene.x, Base#scene.y}
                                            end
                                    end,
                                {ok, Copy, X, Y}
                        end
                end
        end,
    case Res of
        {false, Reason} ->
            {ok, Bin} = pt_260:write(26001, {Reason}),
            server_send:send_to_sid(Node, Sid, Bin),
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
            ok;
        {ok, SceneCopy, X1, Y1} ->
            center:apply(Node, answer, send_enter_answer_scene, [Pkey, SceneCopy, X1, Y1]),
            ok
    end,
    {noreply, State};

%%进入答题场景
handle_cast({enter_answer_scene, Pinfo}, State) ->
    QuestionId = get_cur_question_id(State),
    case ets_get_pinfo(Pinfo#a_pinfo.pkey) of
        [] ->
            NewPinfo = Pinfo#a_pinfo{
                question_id = QuestionId
            },
            ets_update_pinfo(NewPinfo);
        OldPinfo ->
            {NewQId, NewAn, NewAnTime} =
                case OldPinfo#a_pinfo.question_id == QuestionId of
                    true -> {QuestionId, OldPinfo#a_pinfo.my_answer, OldPinfo#a_pinfo.answer_time};
                    false -> {QuestionId, 0, 0}
                end,
            NewPinfo = OldPinfo#a_pinfo{
                name = Pinfo#a_pinfo.name,
                lv = Pinfo#a_pinfo.lv,
                career = Pinfo#a_pinfo.career,
                sex = Pinfo#a_pinfo.sex,
                gkey = Pinfo#a_pinfo.gkey,
                node = Pinfo#a_pinfo.node,
                sid = Pinfo#a_pinfo.sid,
                copy = Pinfo#a_pinfo.copy,
                question_id = NewQId,
                my_answer = NewAn,
                answer_time = NewAnTime
            },
            ets_update_pinfo(NewPinfo)
    end,
    erlang:send_after(1000, self(), {update_copy_count, NewPinfo#a_pinfo.copy}),
    refresh_rank_list(NewPinfo#a_pinfo.copy, normal),
    send_question_info(NewPinfo, State),
    notice_scene_player(State, NewPinfo#a_pinfo.copy),
    {noreply, State};

%%退出答题场景
handle_cast({exit_scene, Pkey}, State) ->
    case ets_get_pinfo(Pkey) of
        [] -> ?ERR("exit scene can not find pinfo ~n"), skip;
        Pinfo when Pinfo#a_pinfo.copy == 9999 ->
            skip;
        Pinfo ->
            NewPinfo = Pinfo#a_pinfo{
                copy = 9999
            },
            ets_update_pinfo(NewPinfo),
            refresh_rank_list(Pinfo#a_pinfo.copy, normal),
            notice_scene_player(State, Pinfo#a_pinfo.copy),
            self() ! {update_copy_count, Pinfo#a_pinfo.copy}
    end,
    {noreply, State};


%%选择答案
handle_cast({select_answer, Pkey, Select}, State) ->
    case ets_get_pinfo(Pkey) of
        [] -> ?ERR("can not find pinfo when answer question ~n"), skip;
        Pinfo ->
            QuestionId = get_cur_question_id(State),
            Now = util:unixtime(),
            NewPinfo =
                case Pinfo#a_pinfo.question_id == QuestionId andalso Pinfo#a_pinfo.my_answer == Select of
                    true -> Pinfo;
                    false ->
                        Pinfo#a_pinfo{
                            question_id = QuestionId,
                            my_answer = Select,
                            answer_time = Now
                        }
                end,
            ets_update_pinfo(NewPinfo),
            {ok, Bin} = pt_260:write(26005, {1}),
            server_send:send_to_sid(Pinfo#a_pinfo.node, Pinfo#a_pinfo.sid, Bin),
%%            center:apply(Pinfo#a_pinfo.node, server_send, send_to_sid, [Pinfo#a_pinfo.sid, Bin]),
            ok
    end,
    {noreply, State};

%%使用道具
handle_cast({use_daoju, Pkey, Type}, State) ->
    case ets_get_pinfo(Pkey) of
        [] -> ?ERR("can not find pinfo when use daoju ~n"), skip;
        Pinfo ->
            #a_pinfo{
                use_type_list = UseTypeList,
                cur_use_type = CurUseType
            } = Pinfo,
            Res =
                if
                    CurUseType =/= 0 -> {false, 6};
                    Type =< 0 orelse Type > 2 -> {false, 0};
                    true ->
                        case lists:keyfind(Type, 1, UseTypeList) of
                            false -> ok;
                            {_, UseTime} ->
                                case UseTime >= ?DAOJU_USE_TIMES of
                                    true -> {false, 7};
                                    false -> ok
                                end
                        end
                end,
            case Res of
                {false, Reason} ->
                    {ok, Bin} = pt_260:write(26006, {Reason, Type}),
                    server_send:send_to_sid(Pinfo#a_pinfo.node, Pinfo#a_pinfo.sid, Bin),
%%                    center:apply(Pinfo#a_pinfo.node, server_send, send_to_sid, [Pinfo#a_pinfo.sid, Bin]),
                    ok;
                ok ->
                    NewUseTypeList =
                        case lists:keyfind(Type, 1, UseTypeList) of
                            false -> [{Type, 1} | UseTypeList];
                            {_, OldTimes} ->
                                [{Type, OldTimes + 1} | lists:keydelete(Type, 1, UseTypeList)]
                        end,
                    NewPinfo = Pinfo#a_pinfo{
                        cur_use_type = Type,
                        use_type_list = NewUseTypeList
                    },
                    ets_update_pinfo(NewPinfo),
                    {ok, Bin} = pt_260:write(26006, {1, Type}),
                    server_send:send_to_sid(Pinfo#a_pinfo.node, Pinfo#a_pinfo.sid, Bin),
%%                    center:apply(Pinfo#a_pinfo.node, server_send, send_to_sid, [Pinfo#a_pinfo.sid, Bin]),
                    send_question_info(NewPinfo, State),
                    ok
            end
    end,
    {noreply, State};

%%查看排名
handle_cast({get_rank, _Pkey, Node, Sid}, State) ->
    CopyList = [-1] ++ [Copy || {Copy, _Num} <- State#answer_st.copy_list],
    F = fun(Copy, AccList) ->
        List = get_rank_list(Copy),
        case List == [] of
            true -> AccList;
            false ->
                List1 = util:list_tuple_to_list(List),
                AccList ++ [[Copy + 1, List1]]
        end
        end,
    ListInfo = lists:foldl(F, [], CopyList),
    All = data_question_rank:get_all(),
    Fr = fun(Rank) ->
        {MinRank, MaxRank, GoodsList} = data_question_rank:get(Rank),
        [MinRank, MaxRank, util:list_tuple_to_list(GoodsList)]
         end,
    RewardList = lists:map(Fr, All),
    {ok, Bin} = pt_260:write(26008, {ListInfo, RewardList}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast(_Info, State) ->
    ?ERR("answer_handle cast info ~p~n", [_Info]),
    {noreply, State}.

%%即将开启
handle_info({ready_open, OpenTime}, State) ->
    NewState = State#answer_st{
        state = 2,
        start_time = OpenTime
    },
    Data = {2, max(0, OpenTime - util:unixtime())},
    {ok, Bin} = pt_260:write(26000, Data),
    send_to_all_node(Bin),
    AllNode = center:get_nodes(),
    [center:apply(N, notice_sys, add_notice, [answer_ready, []]) || N <- AllNode],
    {noreply, NewState};

%%开启
handle_info({open_answer, LongTime}, State) ->
    ets:delete_all_objects(?ETS_ANSWER_PLAYER),
    util:cancel_ref([State#answer_st.end_ref]),
    Ref = erlang:send_after(LongTime * 1000, self(), end_answer),
    Now = util:unixtime(),
    EndTime = Now + LongTime,
    ReadyRef = erlang:send_after(?QUESTION_READY_TIME * 1000, self(), next_question),
    NewState = State#answer_st{
        state = 1,
        start_time = Now,
        end_time = EndTime,
        end_ref = Ref,
        copy_list = [{0, 0}],
        ready_ref = ReadyRef,

        question_num = 0,
        question_time = 0,
        question_list = []
    },
    Data = {1, max(0, EndTime - Now)},
    {ok, Bin} = pt_260:write(26000, Data),
    send_to_all_node(Bin),
    %%玩法找回
    findback_src:update_act_time(35, Now),
    AllNode = center:get_nodes(),
    [center:apply(N, notice_sys, add_notice, [answer_open, []]) || N <- AllNode],
    scene_copy_proc:reset_scene_copy(?SCENE_ID_ANSWER),
    {noreply, NewState};

%%结束
handle_info(end_answer, State) ->
    util:cancel_ref([State#answer_st.end_ref, State#answer_st.ready_ref, State#answer_st.result_ref]),

    %%结算
    refresh_rank_list(-1, final),
    reward(),
    NewState = State#answer_st{
        state = 0,
        start_time = 0,
        end_time = 0,
        end_ref = 0
    },
    send_out_all(),

    Data = {0, 0},
    {ok, Bin} = pt_260:write(26000, Data),
    send_to_all_node(Bin),
    %%关闭非0线
    [scene_init:stop_scene(?SCENE_ID_ANSWER, Copy) || {Copy, _} <- State#answer_st.copy_list, Copy /= 0],
    {noreply, NewState};
%%gm结束
handle_info(gm_end, State) ->
    NewState = State#answer_st{
        state = 0,
        start_time = 0,
        end_time = 0,
        end_ref = 0
    },
    {noreply, NewState};

%%更新房间统计
handle_info({update_copy_count, Copy}, State) ->
    Num = length(ets:match_object(?ETS_ANSWER_PLAYER, #a_pinfo{copy = Copy, _ = '_'})),
    ?DEBUG("update copy count ~p~n",[Num]),
%%    Num = scene_agent:get_scene_count(?SCENE_ID_ANSWER, Copy),
    #answer_st{
        copy_list = CopyList
    } = State,
    NewCopyList = [{Copy, Num} | lists:keydelete(Copy, 1, CopyList)],
    NewState = State#answer_st{
        copy_list = NewCopyList
    },
    %%检查是否开新房间
    L = [{C, CNum} || {C, CNum} <- NewCopyList, CNum < ?COPY_MAX_PLAYER_NUM],
    case L of
        [] -> self() ! new_copy;
        _ -> skip
    end,
    {noreply, NewState};

%%开启新房间
handle_info(new_copy, State) ->
    #answer_st{
        copy_list = CopyList
    } = State,
    MaxCopy = lists:max([Copy || {Copy, _Num} <- CopyList]),
    NewCopy = MaxCopy + 1,
    NewCopyList = [{NewCopy, 0} | CopyList],
    NewState = State#answer_st{
        copy_list = NewCopyList
    },
    scene_init:create_scene(?SCENE_ID_ANSWER, NewCopy),
    {noreply, NewState};

%%开始下一道题
handle_info(next_question, State) ->
    util:cancel_ref([State#answer_st.ready_ref]),
    ResultRef = erlang:send_after(?QUESTION_RESULT_TIME * 1000, self(), result),
    State1 = do_next_question(State),
    NewState = State1#answer_st{
        ready_ref = 0,
        result_ref = ResultRef
    },
    %%更新玩家答题题目
    CurQuestId = get_cur_question_id(NewState),
    F = fun(Pinfo) ->
        if Pinfo#a_pinfo.copy == 9999 -> ok;
            true ->
                NewPinfo = Pinfo#a_pinfo{
                    question_id = CurQuestId
                },
                ets_update_pinfo(NewPinfo)
        end
        end,
    lists:foreach(F, ets:tab2list(?ETS_ANSWER_PLAYER)),
    {noreply, NewState};

%%公布答案
handle_info(result, State) ->
    util:cancel_ref([State#answer_st.result_ref]),
    case State#answer_st.question_num >= ?QUESTION_NUM of
        true ->
            erlang:send_after(5000, self(), end_answer),
            State1 = State;
        false ->
            NextRef = erlang:send_after(?QUESTION_READY_TIME * 1000, self(), next_question),
            State1 = State#answer_st{
                ready_ref = NextRef,
                result_ref = 0
            }
    end,
    NewState = do_question_result(State1),
    {ok, Bin} = pt_260:write(26003, {?QUESTION_READY_TIME}),
    server_send:send_to_scene(?SCENE_ID_ANSWER, Bin),
    %%刷新排名
    [refresh_rank_list(Copy, normal) || {Copy, _Num} <- State#answer_st.copy_list],
    notice_scene_player(NewState),
    {noreply, NewState};

handle_info(_Info, State) ->
    ?ERR("answer_handle info ~p~n", [_Info]),
    {noreply, State}.

%%选择最优房间进入
get_copy(Pinfo, CopyList) ->
    L = [{Copy, Num} || {Copy, Num} <- CopyList, Num < ?COPY_MAX_PLAYER_NUM],
    case L of
        [] ->
            self() ! new_copy,
            case CopyList of
                [] -> 0;
                _ ->
                    {C, _N} = util:list_rand(CopyList),
                    C
            end;
        _ ->
            SortL = lists:reverse(lists:keysort(2, L)),
            case Pinfo#a_pinfo.gkey == 0 of
                true ->
                    {C, _N} = hd(SortL),
                    C;
                false ->
                    Key = lists:concat(["guild_key_", Pinfo#a_pinfo.gkey]),
                    Now = util:unixtime(),
                    case get(Key) of
                        undefined ->
                            C = get_copy_by_guild_key(Pinfo#a_pinfo.gkey, SortL),
                            put(Key, {C, Now}),
                            C;
                        {C, Time} ->
                            case Now - Time > 5 of
                                true ->
                                    C1 = get_copy_by_guild_key(Pinfo#a_pinfo.gkey, SortL),
                                    put(Key, {C1, Now}),
                                    C1;
                                false ->
                                    C
                            end

                    end
            end
    end.
get_copy_by_guild_key(Gkey, CopyList) ->
    SameGuildList = ets:match_object(?ETS_ANSWER_PLAYER, #a_pinfo{gkey = Gkey, _ = '_'}),
    F = fun(P, AccL) ->
        case lists:keyfind(P#a_pinfo.copy, 1, CopyList) of
            false -> AccL;
            _ ->
                case lists:keyfind(P#a_pinfo.copy, 1, AccL) of
                    false -> [{P#a_pinfo.copy, 1} | AccL];
                    {_, OldNum} ->
                        [{P#a_pinfo.copy, OldNum + 1} | lists:keydelete(P#a_pinfo.copy, 1, AccL)]
                end
        end
        end,
    CopyL = lists:foldl(F, [], SameGuildList),
    case CopyL of
        [] ->
            {C, _N} = hd(CopyList),
            C;
        _ ->
            {C, _N} = hd(lists:reverse(lists:keysort(2, CopyL))),
            C
    end.

%%下一道题
do_next_question(State) ->
    #answer_st{
        question_list = QuestionList
    } = State,
    All = data_question:all_question(),
    ShufList = util:list_shuffle(All),
    Id = get_next_question(ShufList, QuestionList),
    NewQuestionList = QuestionList ++ [Id],
    NewState = State#answer_st{
        question_list = NewQuestionList,
        question_num = length(NewQuestionList),
        question_time = util:unixtime()
    },
    notice_scene_player(NewState),
    NewState.
get_next_question([], _QuestionList) -> 1;
get_next_question([Id | Tail], QuestionList) ->
    case lists:member(Id, QuestionList) of
        true -> get_next_question(Tail, QuestionList);
        false -> Id
    end.

%%通知场景玩家
notice_scene_player(State) ->
    notice_scene_player(State, -1).
notice_scene_player(State, Copy) ->
    F = fun(Pinfo) ->
        if Pinfo#a_pinfo.copy == 9999 -> skip;
            Copy == -1 ->
                send_question_info(Pinfo, State);
            Pinfo#a_pinfo.copy == Copy ->
                send_question_info(Pinfo, State);
            true ->
                skip
        end
        end,
    lists:foreach(F, ets:tab2list(?ETS_ANSWER_PLAYER)),
    ok.

%%发送指定玩家的答题信息
send_question_info(Pinfo, State) ->
    #answer_st{
        question_num = QNum
    } = State,
    Now = util:unixtime(),
    QId = get_cur_question_id(State),
    LeaveTime =
        case QId == 0 of
            true -> 0;
            false ->
                max(0, State#answer_st.question_time + ?QUESTION_RESULT_TIME - Now)
        end,
    #a_pinfo{
        pkey = Pkey,
        copy = Copy,
        right_num = RightNum,
        cur_use_type = CurUseType,
        use_type_list = UseTypeList,
        question_id = MyQuestionId,
        my_answer = MySelect,
        point = MyPoint,
        exp = MyExp
    } = Pinfo,
    MyCopy = Copy + 1,
    LeaveQNum = ?QUESTION_NUM - QNum,
    F = fun(Type) ->
        case lists:keyfind(Type, 1, UseTypeList) of
            false -> [Type, ?DAOJU_USE_TIMES];
            {_, UseTimes} ->
                [Type, max(?DAOJU_USE_TIMES - UseTimes, 0)]
        end
        end,
    TypeListInfo = lists:map(F, lists:seq(1, 2)),
    RankList = get_rank_list(Copy),
    RankList1 = util:list_tuple_to_list(RankList),
    MyRank =
        case lists:keyfind(Pkey, 2, RankList) of
            false -> 0;
            {R, _, _, _, _} -> R
        end,
    CurSelect1 =
        case MyQuestionId == QId of
            true -> MySelect;
            false -> 0
        end,
    Data = {QId, LeaveTime, LeaveQNum, RightNum, CurUseType, TypeListInfo, RankList1, MyRank, MyPoint, MyExp, MyCopy, CurSelect1},
    {ok, Bin} = pt_260:write(26004, Data),
    server_send:send_to_sid(Pinfo#a_pinfo.node, Pinfo#a_pinfo.sid, Bin),
%%    center:apply(Pinfo#a_pinfo.node, server_send, send_to_sid, [Pinfo#a_pinfo.sid, Bin]),
    ok.

%%公布答案
do_question_result(State) ->
    #answer_st{
        question_time = QuestionTime
    } = State,
    Id = get_cur_question_id(State),
    Base = data_question:get(Id),
    #base_question{
        answer = Answer
    } = Base,
    AnswerList = ets:match_object(?ETS_ANSWER_PLAYER, #a_pinfo{question_id = Id, _ = '_'}),
    F = fun(Apinfo) ->
        #a_pinfo{
            pkey = Pkey,
            sid = Sid,
            node = Node,
            lv = Lv,
            my_answer = MyAnswer,
            answer_time = AnswerTime,
            cur_use_type = CurUseType,
            right_combo = RightCombo
        } = Apinfo,
        UseTime = max(1, AnswerTime - QuestionTime),
        Point = data_question_point:get(UseTime),
        MaxPoint = data_question_point:get(0),

        Exp = data_question_reward_exp:get(Lv),
        {IsRight, GetPoint, AddExp} =
            if
                CurUseType == ?DAOJU_MUST_RIGHT -> {1, MaxPoint, Exp};
                MyAnswer == Answer ->
                    AddPoint =
                        case CurUseType == ?DAOJU_DOUBLE_POINT of
                            true -> round(Point * 2);
                            false -> Point
                        end,
                    {1, AddPoint, Exp};
                true -> {0, 0, round(Exp / 2)}
            end,
        NewApinfo = Apinfo#a_pinfo{
            my_answer = 0,
            answer_time = 0,
            cur_use_type = 0,
            right_num = Apinfo#a_pinfo.right_num + IsRight,
            right_combo = ?IF_ELSE(IsRight == 1, RightCombo + 1, 0),
            exp = Apinfo#a_pinfo.exp + AddExp,
            point = Apinfo#a_pinfo.point + GetPoint
        },
        ets_update_pinfo(NewApinfo),
        {ok, Bin} = pt_260:write(26007, {Id, IsRight, GetPoint, Answer}),
        server_send:send_to_sid(Node, Sid, Bin),
%%        center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
        center:apply(Node, answer, answer_add_exp, [Pkey, AddExp]),
        center:apply(Node, achieve, trigger_achieve, [Pkey, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4022, 0, NewApinfo#a_pinfo.right_combo])
        end,
    lists:foreach(F, AnswerList),
    State.

send_to_all_node(Bin) ->
    AllNode = center:get_nodes(),
    [center:apply(Node, server_send, send_to_all, [Bin]) || Node <- AllNode],
    ok.

%%更新答题玩家
ets_update_pinfo(Pinfo) ->
    ets:insert(?ETS_ANSWER_PLAYER, Pinfo).

%%获取答题玩家
ets_get_pinfo(Pkey) ->
    case ets:lookup(?ETS_ANSWER_PLAYER, Pkey) of
        [] -> [];
        [Pinfo | _] -> Pinfo
    end.

%%获取当前问题id
get_cur_question_id(State) ->
    case State#answer_st.question_list of
        [] -> 0;
        _ -> lists:last(State#answer_st.question_list)
    end.

%%送出所有玩家
send_out_all() ->
    AllScenePlayer = scene_agent:get_scene_player(?SCENE_ID_ANSWER),
    F = fun(ScenePlayer) ->
        center:apply(ScenePlayer#scene_player.node, answer, sendout_scene_to_main, [ScenePlayer#scene_player.key])
        end,
    lists:foreach(F, AllScenePlayer),
    ok.

%%获取排名
get_rank_list(Copy) ->
    get_rank_list(Copy, 20).
get_rank_list(Copy, Num) ->
    Now = util:unixtime(),
    Key = {answer_rank, Copy},
    List1 =
        case get(Key) of
            undefined ->
                refresh_rank_list(Copy, normal);
            {List, Time} ->
                case Now - Time > 10 of
                    true ->
                        refresh_rank_list(Copy, normal);
                    false ->
                        List
                end
        end,
    lists:sublist(List1, Num).

%%刷新排名
refresh_rank_list(Copy, Type) ->
    List =
        case Copy of
            -1 -> ets:tab2list(?ETS_ANSWER_PLAYER);
            _ -> ets:match_object(?ETS_ANSWER_PLAYER, #a_pinfo{copy = Copy, _ = '_'})
        end,
    SortList = lists:reverse(lists:keysort(#a_pinfo.point, List)),
    SunNum =
        case Type of
            final -> 1000;
            _ -> 100
        end,
    SubList = lists:sublist(SortList, SunNum),
    F = fun(Apinfo, Order) ->
        #a_pinfo{
            pkey = Pkey,
            name = Name,
            point = Point,
            node = Node,
            right_num = RightNum
        } = Apinfo,
        ?DO_IF(Type == final, center:apply(Node, achieve, trigger_achieve, [Pkey, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4021, 0, Order])),
        {{Order, Pkey, Name, Point, RightNum}, Order + 1}
        end,
    {Ranklist, _} = lists:mapfoldl(F, 1, SubList),
    Now = util:unixtime(),
    put({answer_rank, Copy}, {Ranklist, Now}),
    Ranklist.

%%结算
reward() ->
    All = ets:tab2list(?ETS_ANSWER_PLAYER),
    RankList = get_rank_list(-1, 1000),
    spawn(fun() -> do_reward(All, RankList, util:unixtime()) end),
    ok.
do_reward([], _RankList, _Now) -> skip;
do_reward([Pinfo | Tail], RankList, Now) ->
    #a_pinfo{
        pkey = Pkey,
        name = Name,
        point = Point,
        right_num = RightNum,
        exp = AddExp
    } = Pinfo,
    Order =
        case lists:keyfind(Pkey, 2, RankList) of
            false -> 0;
            {R, _, _, _, _} -> R
        end,
    {_MinRank, _MaxRank, GoodsList} =
        case data_question_rank:get(Order) of
            [] ->
                ?ERR("can not find answer reward data ~p~n", [Order]),
                {0, 0, []};
            OrderData -> OrderData
        end,
    case ets_get_pinfo(Pkey) of
        [] ->
            ?ERR("answer can not find pinfo when reward ~n"),
            skip;
        Pinfo1 ->
            case GoodsList of
                [] -> skip;
                _ ->
                    SubRankList = util:list_tuple_to_list(lists:sublist(RankList, 20)),
                    center:apply(Pinfo1#a_pinfo.node, answer, reward, [Pkey, ?QUESTION_NUM, RightNum, Point, Order, AddExp, GoodsList, SubRankList])
            end
    end,
    %%公告
    case Order == 1 of
        true ->
            AllNodes = center:get_nodes(),
            F = fun(Node) ->
                center:apply(Node, notice_sys, add_notice, [answer, [Name]])
                end,
            spawn(fun() -> lists:foreach(F, AllNodes) end);
        false ->
            skip
    end,
    Sql = io_lib:format("insert into log_answer_rank set pkey=~p,sn=0,goods='~s',rank=~p,point=~p,time=~p",
        [Pkey, util:term_to_bitstring(GoodsList), Order, Point, Now]),
    db:execute(Sql),
    do_reward(Tail, RankList, Now).