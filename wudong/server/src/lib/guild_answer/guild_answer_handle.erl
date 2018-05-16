%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2018 15:32
%%%-------------------------------------------------------------------
-module(guild_answer_handle).
-author("hxming").

-include("common.hrl").
-include("guild_answer.hrl").
-include("guild.hrl").
-include("server.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

handle_call(_Request, _From, State) ->
    {reply, ok, State}.


handle_cast({check_state, Sid}, State) ->
    if State#st_guild_answer.state == ?GUILD_ANSWER_STATE_CLOSE -> skip;
        true ->
            LeftTime = max(0, State#st_guild_answer.time - util:unixtime()),
            {ok, Bin} = pt_405:write(40501, {State#st_guild_answer.state, LeftTime}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end,
    {noreply, State};

handle_cast({check_question, Sid, Gkey}, State) ->
    case lists:keyfind(Gkey, #guild_answer.gkey, State#st_guild_answer.answer_list) of
        false ->
            {ok, Bin} = pt_405:write(40502, {0, 0, 0, 0, 0, <<>>});
        GuildAnswer ->
            case GuildAnswer#guild_answer.question of
                [] ->
                    {ok, Bin} = pt_405:write(40502, {0, 0, 0, 0, 0, <<>>});
                _ ->
                    Qid = hd(GuildAnswer#guild_answer.question),
                    Num = guild_answer_util:get_question_num() - length(GuildAnswer#guild_answer.question) + 1,
                    LeftTime = max(0, GuildAnswer#guild_answer.time - util:unixtime()),
%%                    ?DEBUG("qid ~p num ~p time ~p~n", [Qid, Num, LeftTime]),
                    {ok, Bin} = pt_405:write(40502, {1, Qid, LeftTime, Num, GuildAnswer#guild_answer.pkey, GuildAnswer#guild_answer.nickname})
            end
    end,
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%答题
handle_cast({check_answer, Pkey, Pid, Nickname, Sid, Gkey, Qid, Answer}, State) ->
    {Ret, AnswerList} =
        case lists:keytake(Gkey, #guild_answer.gkey, State#st_guild_answer.answer_list) of
            false ->
                {3, State#st_guild_answer.answer_list};
            {value, GuildAnswer, T} ->
                case GuildAnswer#guild_answer.question of
                    [] ->
                        {3, State#st_guild_answer.answer_list};
                    [CurQid | _] ->
                        if CurQid /= Qid ->
                            {4, State#st_guild_answer.answer_list};
                            true ->
                                DefaultList = [util:make_sure_list(Default) || Default <- data_guild_answer:get(Qid)],
                                case lists:member(util:make_sure_list(Answer), DefaultList) of
                                    false ->
                                        {5, State#st_guild_answer.answer_list};
                                    true ->
                                        NewGuildAnswer = refresh_question(GuildAnswer#guild_answer{pkey = Pkey, nickname = Nickname}),
                                        GoodsList = tuple_to_list(data_guild_answer:get_reward(Qid)),
                                        Pid ! {guild_answer, GoodsList},
                                        {ok, BinRet} = pt_405:write(40504, {Qid, Answer, Pkey, Nickname}),
                                        server_send:send_to_guild(Gkey, BinRet),
                                        {1, [NewGuildAnswer | T]}
                                end
                        end
                end
        end,
    {ok, Bin} = pt_405:write(40503, {Ret}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State#st_guild_answer{answer_list = AnswerList}};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_guild_answer.ref]),
    NewState = guild_answer_proc:set_timer(#st_guild_answer{}, Now),
    {noreply, NewState};


handle_info({ready, ReadyTime, ActTime}, State) ->
    ?DEBUG("guild answer ready ready time ~p acttime ~p~n", [ReadyTime, ActTime]),
    util:cancel_ref([State#st_guild_answer.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_405:write(40501, {?GUILD_ANSWER_STATE_READY, ReadyTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, ActTime}),
    NewState = State#st_guild_answer{ref = Ref, time = Now + ReadyTime, state = ?GUILD_ANSWER_STATE_READY},
    {noreply, NewState};

handle_info({start, ActTime}, State) when State#st_guild_answer.state =/= ?GUILD_ANSWER_STATE_START ->
    ?DEBUG("guild answer start acttime ~p~n", [ActTime]),
    util:cancel_ref([State#st_guild_answer.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_405:write(40501, {?GUILD_ANSWER_STATE_START, ActTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(ActTime * 1000, self(), close),
    AnswerList = guild_answer_util:init_answer(),
    NewState = State#st_guild_answer{ref = Ref, time = Now + ActTime, state = ?GUILD_ANSWER_STATE_START, answer_list = AnswerList},
    notice_sys:add_notice(guild_answer_start, []),
    {noreply, NewState};

handle_info(close, State) ->
    ?DEBUG("guild answer close~n"),
    util:cancel_ref([State#st_guild_answer.ref]),
    {ok, Bin} = pt_405:write(40501, {?GUILD_ANSWER_STATE_CLOSE, 0}),
    server_send:send_to_all(Bin),
    RefList = [GA#guild_answer.ref || GA <- State#st_guild_answer.answer_list],
    util:cancel_ref(RefList),
    NewState = guild_answer_proc:set_timer(#st_guild_answer{time = 0, state = ?GUILD_ANSWER_STATE_CLOSE}, util:unixtime()),
    notice_sys:add_notice(guild_answer_close, []),
    {noreply, NewState};

handle_info({next, Gkey}, State) ->
    AnswerList =
        case lists:keytake(Gkey, #guild_answer.gkey, State#st_guild_answer.answer_list) of
            false ->
                State#st_guild_answer.answer_list;
            {value, GuildAnswer, T} ->
                Qid = hd(GuildAnswer#guild_answer.question),
                Answer = data_guild_answer:get(Qid),
                {ok, Bin} = pt_405:write(40504, {Qid, Answer, 0, <<>>}),
                server_send:send_to_guild(Gkey, Bin),
                NewGuildAnswer = refresh_question(GuildAnswer#guild_answer{pkey = 0, nickname = <<>>}),
                [NewGuildAnswer | T]
        end,
    {noreply, State#st_guild_answer{answer_list = AnswerList}};

handle_info(_Request, State) ->
    {noreply, State}.


refresh_question(GuildAnswer) ->
    util:cancel_ref([GuildAnswer#guild_answer.ref]),
    [_ | QuestionIds] = GuildAnswer#guild_answer.question,
    Now = util:unixtime(),
    Ref = ?IF_ELSE(QuestionIds == [], [], guild_answer_util:timeout_ref(GuildAnswer#guild_answer.gkey)),
    Time = ?IF_ELSE(QuestionIds == [], 0, Now + ?GUILD_ANSWER_TIMEOUT),
    IsFinish = ?IF_ELSE(QuestionIds == [], 1, 0),
    NewGuildAnswer = GuildAnswer#guild_answer{ref = Ref, time = Time, question = QuestionIds, is_finish = IsFinish},
    guild_answer_util:refresh_question(NewGuildAnswer),
    NewGuildAnswer.