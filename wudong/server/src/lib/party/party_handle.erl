%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2017 15:36
%%%-------------------------------------------------------------------
-module(party_handle).
-author("hxming").

-include("common.hrl").
-include("party.hrl").
-include("scene.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

%%预约
handle_call({party_app, Type, DayType, Id, Player}, _From, State) ->
    Midnight = util:get_today_midnight(),
    Date =
        case DayType of
            1 -> Midnight;
            2 -> Midnight + ?ONE_DAY_SECONDS;
            _ -> Midnight + 2 * ?ONE_DAY_SECONDS
        end,
    case party:party_app(Type, Date, Id, Player, State#st_party.date_list) of
        {true, PriceType, Price, Time, BaseData, DateList, Party} ->
            Log = #party_state{party_key = Party#party.akey, pkey = Player#player.key, price = Price, price_type = Party#party.price_type},
            LogList = [Log | State#st_party.log],
            party_load:replace_party_state(Log),
            {reply, {ok, PriceType, Price, Time, BaseData}, State#st_party{date_list = DateList, log = LogList}};
        Err ->
            {reply, Err, State}
    end;

%%%%检查是否可采集
%%handle_call({check_eat_state, Pkey, PartyKey, PartyTimes}, _From, State) ->
%%    Ref =
%%        case lists:keyfind(PartyKey, #party.akey, State#st_party.party_list) of
%%            false -> false;
%%            Party ->
%%                if PartyTimes >= ?EAT_TIME_LIM -> false;
%%                    true ->
%%                        Base = data_party:get(Party#party.type),
%%                        case lists:keyfind(Pkey, 1, Party#party.invite_list) of
%%                            false -> true;
%%                            {_, Times} ->
%%                                Base = data_party:get(Party#party.type),
%%                                Times < Base#base_party.eat_times
%%                        end
%%                end
%%        end,
%%    {reply, Ref, State};

handle_call(_Msg, _From, State) ->
    ?DEBUG("party handle call ~p~n", [_Msg]),
    {reply, ok, State}.

%%查询状态
handle_cast({check_party_state, Sid}, State) ->
    Now = util:unixtime(),
    if State#st_party.party_state == 0 -> ok;
        true ->
            {ok, Bin} = pt_287:write(28701, {1, max(0, State#st_party.party_time - Now)}),
            server_send:send_to_sid(Sid, Bin)
    end,
    {noreply, State};

handle_cast({party_list, Pkey, Sid, DailyTimes}, State) ->
    F = fun(Party) ->
        Base = data_party:get(Party#party.type),
        [{_, X, Y} | _] = Base#base_party.table_list,
        IsEnjoy =
            if DailyTimes >= ?EAT_TIME_LIM -> 0;
                true ->
                    case lists:keyfind(Pkey, 1, Party#party.invite_list) of
                        false -> 1;
                        {_, Times} ->
                            ?IF_ELSE(Base#base_party.eat_times > Times, 1, 0)
                    end
            end,
        [Party#party.type, Party#party.nickname, Party#party.career, Party#party.sex, Party#party.avatar, ?SCENE_ID_MAIN, X, Y, IsEnjoy]
        end,
    Data = lists:map(F, State#st_party.party_list),
    LeftTime = max(0, State#st_party.party_time - util:unixtime()),
    {ok, Bin} = pt_287:write(28702, {LeftTime, Data}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_cast({date_list, Type, DayType, PKey, Sid}, State) ->
    Now = util:unixtime(),
    Now = util:unixtime(),
    Midnight = util:get_today_midnight(Now),
    Date =
        case DayType of
            1 -> Midnight;
            2 -> Midnight + ?ONE_DAY_SECONDS;
            _ -> Midnight + 2 * ?ONE_DAY_SECONDS
        end,
    Base = data_party:get(Type),
    LeftTimes = party:get_party_type_times(Type, PKey, State#st_party.date_list, Base#base_party.daily_times),
    F = fun(Id) ->
        {Hour, Min} = data_party_time:get(Id),
        Sec = Hour * ?ONE_HOUR_SECONDS + Min * 60,
        PartyTime = Date + Sec,
        PartyState = party:check_app_state(Type, State#st_party.date_list, PKey, PartyTime, Now),
        [Id, Hour, Min, PartyState]
        end,
    Data = lists:map(F, data_party_time:get_all()),
    {ok, Bin} = pt_287:write(28703, {LeftTimes, Data}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_cast({party_into, Sid, Lv, Akey}, State) ->
    Data =
        case lists:keyfind(Akey, #party.akey, State#st_party.party_list) of
            false ->
                {0, 0, 0, <<>>, 0, 0, <<>>, 0, []};
            Party ->
                Base = data_party:get(Party#party.type),
                Exp = party:party_exp(Lv, Base#base_party.exp_add),
                GoodsList = goods:pack_goods(tuple_to_list(Base#base_party.guest_goods)),
                {1, Party#party.type, Party#party.pkey, Party#party.nickname, Party#party.career, Party#party.sex, Party#party.avatar, Exp, GoodsList}
        end,
%%    ?DEBUG("party_into ~p L ~p~n", [Akey, Data]),
    {ok, Bin} = pt_287:write(28705, Data),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_cast(_Msg, State) ->
    ?DEBUG("party handle cast ~p~n", [_Msg]),
    {noreply, State}.

handle_info(init, State) ->
    DateList = party_init:init(),
    Log = party_init:init_party_state(),
    put(timer, erlang:send_after(?FIFTEEN_MIN_SECONDS * 1000, self(), timer)),
    {noreply, State#st_party{date_list = DateList, log = Log}};


handle_info(cmd_state, State) ->
    Now = util:unixtime(),
    io:format("party state ~p/~p~n", [State#st_party.party_state, State#st_party.party_time - Now]),
    {noreply, State};

%%重置
handle_info({reset, Now}, State) ->
    Midnight = util:get_today_midnight(Now),
    F = fun(Party) ->
        ?IF_ELSE(Party#party.date < Midnight, [], [Party])
        end,
    DateList = lists:flatmap(F, State#st_party.date_list),
    {noreply, State#st_party{date_list = DateList}};

handle_info(cmd_start, State) ->
    if State#st_party.party_state == 1 ->
        ok;
        true ->
            case [Party || Party <- State#st_party.date_list, Party#party.status == 0] of
                [] -> ok;
                L ->
                    self() ! {party_start, L}
            end
    end,
    {noreply, State};

handle_info(cmd_close, State) ->
    handle_info(party_end, State);

handle_info({party_timer, Now}, State) ->
    if State#st_party.party_state == 1 ->
        ok;
        true ->
            case [Party || Party <- State#st_party.date_list, Party#party.time >= Now - 10 andalso Party#party.time < Now + 10] of
                [] -> ok;
                L ->
                    self() ! {party_start, L}
            end
    end,
    {noreply, State};

handle_info({party_start, L}, State) ->
    ?DEBUG("party start ~n", []),
    PartyList = [init_party(Party) || Party <- L],
    Ref = erlang:send_after(?PARTY_TIME * 1000, self(), party_end),
    DateList = party_status(PartyList, State#st_party.date_list),
    LogList = party_state(State#st_party.log, PartyList),
    {ok, Bin} = pt_287:write(28701, {1, ?PARTY_TIME}),
    server_send:send_to_all(Bin),
    scene_copy_proc:set_default(?SCENE_ID_MAIN, true),
    self() ! party_msg,
    {noreply, State#st_party{party_list = PartyList, log = LogList, party_state = 1, party_time = util:unixtime() + ?PARTY_TIME, ref = Ref, date_list = DateList}};


handle_info(party_msg, State) when State#st_party.party_state == 1 ->
    F = fun(Party) ->
        Player = #player{key = Party#party.pkey, nickname = Party#party.nickname},
        Base = data_party:get(Party#party.type),
        notice_sys:add_notice(party, [Player, Base#base_party.desc])
        end,
    lists:foreach(F, State#st_party.party_list),
    misc:cancel_timer(party_msg),
    Ref = erlang:send_after(5 * 60 * 1000, self(), party_msg),
    put(party_msg, Ref),
    {noreply, State};

handle_info(party_end, State) ->
    ?DEBUG("party close ~n", []),
    [monster:stop_broadcast(Mon#mon.pid) || Mon <- mon_agent:get_scene_mon_by_kind(?SCENE_ID_MAIN, 0, ?MON_KIND_PARTY)],
    util:cancel_ref([State#st_party.ref]),
    {ok, Bin} = pt_287:write(28701, {0, 0}),
    server_send:send_to_all(Bin),
    %%结算
    party_reward(State#st_party.party_list),
    scene_copy_proc:set_default(?SCENE_ID_MAIN, false),
    {noreply, State#st_party{party_state = 0, party_time = 0, party_list = [], ref = 0}};

handle_info({party_eat, Pkey, Pid, PartyKey}, State) ->
    PartyList =
        case lists:keytake(PartyKey, #party.akey, State#st_party.party_list) of
            false -> State#st_party.party_list;
            {value, Party, T} ->
                Base = data_party:get(Party#party.type),
                case lists:keytake(Pkey, 1, Party#party.invite_list) of
                    false ->
                        InviteList = [{Pkey, 1} | Party#party.invite_list],
                        NewParty = Party#party{invite_list = InviteList},
                        Pid ! {give_goods, tuple_to_list(Base#base_party.guest_goods), 287},
                        Pid ! {party_exp, Base#base_party.exp_add},
                        [NewParty | T];
                    {value, {_, Times}, L} ->
                        InviteList = [{Pkey, Times + 1} | L],
                        NewParty = Party#party{invite_list = InviteList},
                        Pid ! {give_goods, tuple_to_list(Base#base_party.guest_goods), 287},
                        Pid ! {party_exp, Base#base_party.exp_add},
                        [NewParty | T]
                end
        end,
    {noreply, State#st_party{party_list = PartyList}};

handle_info(timer, State) ->
    misc:cancel_timer(timer),
    put(timer, erlang:send_after(?FIFTEEN_MIN_SECONDS * 1000, self(), timer)),
    F = fun(Log, L) ->
        case lists:keyfind(Log#party_state.party_key, #party.akey, State#st_party.date_list) of
            false ->
                party_load:delete_party_state(Log#party_state.party_key),
                party_init:mail_gold_back(Log#party_state.pkey, Log#party_state.price_type, Log#party_state.price),
                L;
            Party ->
                if Party#party.status == 0 ->
                    [Log | L];
                    true ->
                        party_load:delete_party_state(Log#party_state.party_key),
                        L
                end
        end
        end,
    LogList = lists:foldl(F, [], State#st_party.log),
    {noreply, State#st_party{log = LogList}};

handle_info(_Msg, State) ->
    ?DEBUG("party handle info ~p~n", [_Msg]),
    {noreply, State}.

init_party(Party) ->
    %%创建宴席
    case data_party:get(Party#party.type) of
        [] -> Party;
        Base ->
            F = fun({Mid, X, Y}) ->
                mon_agent:create_mon([Mid, ?SCENE_ID_MAIN, X, Y, 0, 1, [{life, ?PARTY_TIME}, {party_key, Party#party.akey}]])
                end,
            MonKeyList = lists:map(F, Base#base_party.table_list),
            {Title, Content} = t_mail:mail_content(112),
            Content1 =
                case version:get_lan_config() of
                    vietnam ->
                        io_lib:format(Content, [util:unixtime_to_time_string4(Party#party.time), Base#base_party.desc]);
                    _ ->
                        io_lib:format(Content, [util:unixtime_to_time_string3(Party#party.time), Base#base_party.desc])
                end,

            mail:sys_send_mail([Party#party.pkey], Title, Content1, tuple_to_list(Base#base_party.master_goods)),
            Player = shadow_proc:get_shadow(Party#party.pkey),
            Party#party{
                nickname = Player#player.nickname,
                career = Player#player.career,
                sex = Player#player.sex,
                avatar = Player#player.avatar,
                mon_key_list = MonKeyList
            }
    end.

party_status(PartyList, DateList) ->
    F = fun(Party, L) ->
        case lists:keytake(Party#party.akey, #party.akey, L) of
            false -> L;
            {value, Party1, T} ->
                NewParty = Party1#party{status = 1},
                party_load:replace_party(NewParty),
                [NewParty | T]
        end
        end,
    lists:foldl(F, DateList, PartyList).


party_state(LogList, PartyList) ->
    F = fun(Party, L) ->
        case lists:keytake(Party#party.akey, #party.akey, L) of
            false -> L;
            {value, _Log, T} ->
                party_load:delete_party_state(Party#party.akey),
                T
        end
        end,
    lists:foldl(F, LogList, PartyList).


party_reward(PartyList) ->
    F = fun(Party) ->
        Base = data_party:get(Party#party.type),
        EatNum = lists:sum([Times || {_, Times} <- Party#party.invite_list]),
        {Title, Content} = t_mail:mail_content(111),
        Content1 = io_lib:format(Content, [Base#base_party.desc, EatNum]),
        F1 = fun({GoodsId, Num}) ->
            case util:floor(Num * EatNum / Base#base_party.guest_num) of
                0 -> [];
                NewNUm ->
                    [{GoodsId, NewNUm}]
            end
             end,
        MasterGoodsRatio = lists:flatmap(F1, tuple_to_list(Base#base_party.master_goods_ratio)),
        GoodsList = goods:merge_goods(MasterGoodsRatio),
        mail:sys_send_mail([Party#party.pkey], Title, Content1, GoodsList),
        ok
        end,
    lists:foreach(F, PartyList),
    ok.

