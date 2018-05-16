%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 四月 2018 下午6:02
%%%-------------------------------------------------------------------
-module(new_free_gift).
-author("luobaqun").

-author("luobq").

-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    get_info/1,
    get_gift/2,
    get_leave_time/0,
    get_state/1
]).

init(Player) ->
    Sql = io_lib:format("select act_id,type,state,buy_time,delay_day,reward,`desc` from player_new_free_gift where pkey = ~p",
        [Player#player.key]),
    Now = util:unixdate(),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([ActId, Type, State, BuyTime, DelayDay, Reward0, Desc]) ->
                Reward = util:bitstring_to_term(Reward0),
                IsSameData = ?IF_ELSE(BuyTime + DelayDay * ?ONE_DAY_SECONDS < Now + ?ONE_DAY_SECONDS, true, false),
                if IsSameData andalso State == 1 ->
                    [{_, Num}] = Reward,
                    Msg = io_lib:format(?T("上仙您购买的~s，返还元宝已到账啦，这里是~p元宝，请查收附件哦"), [?T(Desc), Num]),
                    spawn(fun() ->
                        delete_record(Player#player.key, ActId, Type),
                        mail:sys_send_mail([Player#player.key], ?T("零元礼包"), Msg, Reward)
                          end),
                    [];
                    State == 2 -> delete_record(Player#player.key, ActId, Type);
                    true ->
                        [[ActId, Type, State, BuyTime, DelayDay, Reward, Desc]]
                end
                end,
            NewList = lists:flatmap(F, Rows),
            case get_act() of
                [] -> St = #st_new_free_gift{pkey = Player#player.key};
                Base ->
                    ActId1 = Base#base_act_new_free_gift.act_id,
                    F0 = fun([ActId2, Type2, State2, BuyTime2, DelayDay2, Reward2, Desc2]) ->
                        if
                            ActId1 == ActId2 ->
                                make_st(ActId2, Type2, State2, BuyTime2, DelayDay2, Reward2, Desc2);
                            true -> []
                        end
                         end,
                    List = lists:flatmap(F0, NewList),
                    St = #st_new_free_gift{pkey = Player#player.key, list = List}
            end,
            lib_dict:put(?PROC_STATUS_NEW_FREE_GIFT, St),
            ok;
        _ ->
            St = #st_new_free_gift{pkey = Player#player.key},
            lib_dict:put(?PROC_STATUS_NEW_FREE_GIFT, St)
    end,
    Player.

get_info(_Player) ->
    St = lib_dict:get(?PROC_STATUS_NEW_FREE_GIFT),
    List = St#st_new_free_gift.list,
    case get_act() of
        [] ->
            [];
        Base ->
            F = fun(Base0) ->
                Type = Base0#base_act_new_free_gift_help.type,
                case lists:keyfind(Type, #base_new_free_gift.type, List) of
                    false ->
                        GetLeaveTime = 0,
                        State = 0;
                    Base1 ->
                        GetLeaveTime = max(0, Base1#base_new_free_gift.buy_time + Base1#base_new_free_gift.delay_day * ?ONE_DAY_SECONDS - util:unixtime()),
                        State = Base1#base_new_free_gift.state
                end,
                [State,
                    GetLeaveTime,
                    Base0#base_act_new_free_gift_help.type,
                    Base0#base_act_new_free_gift_help.cost,
                    Base0#base_act_new_free_gift_help.delay_day,
                    ?T(Base0#base_act_new_free_gift_help.desc),
                    [tuple_to_list(X) || X <- Base0#base_act_new_free_gift_help.reward],
                    [tuple_to_list(X) || X <- Base0#base_act_new_free_gift_help.re_reward]
                ]
                end,
            lists:map(F, Base#base_act_new_free_gift.gift_list)
    end.

get_gift(Player, Type) ->
    St = lib_dict:get(?PROC_STATUS_NEW_FREE_GIFT),
    List = St#st_new_free_gift.list,
    case get_act() of
        [] ->
            {0, Player};
        Base ->
            [Base0] = [X || X <- Base#base_act_new_free_gift.gift_list, X#base_act_new_free_gift_help.type == Type],
            case lists:keyfind(Type, #base_new_free_gift.type, List) of
                false ->
                    State = 0;
                Base1 ->
                    State = Base1#base_new_free_gift.state
            end,
            if State == 0 ->
                IsEnough = money:is_enough(Player, Base0#base_act_new_free_gift_help.cost, gold),
                if Player#player.lv < Base0#base_act_new_free_gift_help.cost andalso Type == 1 ->
                    {16, Player};
                    not IsEnough andalso Type =/= 1 ->
                        {5, Player};
                    true ->
                        NewBaseGift = #base_new_free_gift{
                            act_id = Base#base_act_new_free_gift.act_id,
                            type = Type,
                            state = 1,
                            buy_time = util:unixtime(),
                            delay_day = Base0#base_act_new_free_gift_help.delay_day,
                            desc = Base0#base_act_new_free_gift_help.desc,
                            reward = Base0#base_act_new_free_gift_help.re_reward
                        },
                        [{_GoodsId, Num}] = Base0#base_act_new_free_gift_help.re_reward,
                        Cost = ?IF_ELSE(Type == 1, 0, Base0#base_act_new_free_gift_help.cost),
                        case lists:keytake(Type, #base_new_free_gift.type, List) of
                            false ->
                                NewSt = St#st_new_free_gift{list = [NewBaseGift | List]},
                                dbreplace_player_new_free_gift(NewBaseGift, Player#player.key),
                                lib_dict:put(?PROC_STATUS_NEW_FREE_GIFT, NewSt),
                                Title = ?T("零元礼包"),
                                Day = unixtime_to_time_string(util:unixtime() + Base0#base_act_new_free_gift_help.delay_day * ?ONE_DAY_SECONDS),
                                Content = io_lib:format(?T("上仙您的~s已经购买成功，~s登陆将获得~p元宝返还，届时请留意邮件哦"), [?T(Base0#base_act_new_free_gift_help.desc), Day, Num]),
                                mail:sys_send_mail([Player#player.key], Title, Content),
                                NewPlayer0 = money:add_no_bind_gold(Player, -Cost, 533, 0, 0),
                                {ok, NewPlayer} = goods:give_goods(NewPlayer0, goods:make_give_goods_list(533, Base0#base_act_new_free_gift_help.reward)),
                                log_new_free_gift(NewPlayer#player.key, NewPlayer#player.nickname, NewPlayer#player.lv, Type),
                                activity:get_notice(Player, [144], true),
                                notice(Type, Player, Base0),
                                {1, NewPlayer};
                            {value, _BaseGift, List0} ->
                                NewSt = St#st_new_free_gift{list = [NewBaseGift | List0]},
                                dbreplace_player_new_free_gift(NewBaseGift, Player#player.key),
                                lib_dict:put(?PROC_STATUS_NEW_FREE_GIFT, NewSt),
                                Title = ?T("零元礼包"),
                                Day = unixtime_to_time_string(util:unixtime() + Base0#base_act_new_free_gift_help.delay_day * ?ONE_DAY_SECONDS),
                                Content = io_lib:format(?T("上仙您的~s已经购买成功，~s登陆将获得~p元宝返还，届时请留意邮件哦"), [?T(Base0#base_act_new_free_gift_help.desc), Day, Num]),
                                mail:sys_send_mail([Player#player.key], Title, Content),
                                NewPlayer0 = money:add_no_bind_gold(Player, -Cost, 533, 0, 0),
                                {ok, NewPlayer} = goods:give_goods(NewPlayer0, goods:make_give_goods_list(533, Base0#base_act_new_free_gift_help.reward)),
                                log_new_free_gift(NewPlayer#player.key, NewPlayer#player.nickname, NewPlayer#player.lv, Type),
                                notice(Type, Player, Base0),
                                activity:get_notice(Player, [144], true),
                                {1, NewPlayer}
                        end
                end;
                true -> {15, Player}
            end
    end.

unixtime_to_time_string(Timestamp) ->
    {{_Year, Month, Day}, {_Hour, _Minute, _Second}} = calendar:now_to_local_time({Timestamp div 1000000, Timestamp rem 1000000, 0}),
    ?T(lists:concat([Month, "月", Day, "日"])).

get_act() ->
    case activity:get_work_list(data_new_free_gift) of
        [] ->
            [];
        [Base | _] ->
            Base
    end.

get_leave_time() ->
    activity:get_leave_time(data_new_free_gift).

delete_record(Pkey, ActId, Type) ->
    SQL = io_lib:format("DELETE FROM player_new_free_gift where pkey = ~p and act_id = ~p and type = ~p", [Pkey, ActId, Type]),
    db:execute(SQL).

dbreplace_player_new_free_gift(NewBaseGift, Pkey) ->
    #base_new_free_gift{
        act_id = ActId,
        type = Type,
        state = State,
        buy_time = BuyTime,
        delay_day = DelayDay,
        desc = Desc,
        reward = Reward
    } = NewBaseGift,
    Sql = io_lib:format("replace into player_new_free_gift set act_id = ~p,type = ~p,state=~p,buy_time=~p,delay_day=~p,reward='~s',`desc` ='~s', pkey = ~p",
        [ActId, Type, State, BuyTime, DelayDay, util:term_to_bitstring(Reward), ?T(Desc), Pkey]),
    db:execute(Sql).

make_st(ActId, Type, State, BuyTime, DelayDay, Reward, Desc) ->
    [#base_new_free_gift{
        act_id = ActId,
        type = Type,
        state = State,
        buy_time = BuyTime,
        delay_day = DelayDay,
        desc = Desc,
        reward = Reward
    }].

get_state(Player) ->
    case get_act() of
        [] -> -1;
        #base_act_new_free_gift{act_info = ActInfo} = Base ->
            St = lib_dict:get(?PROC_STATUS_NEW_FREE_GIFT),
            List = St#st_new_free_gift.list,
            F = fun(Type) ->
                [Base0] = [X || X <- Base#base_act_new_free_gift.gift_list, X#base_act_new_free_gift_help.type == Type],
                case lists:keyfind(Type, #base_new_free_gift.type, List) of
                    false ->
                        State = 0;
                    Base1 ->
                        State = Base1#base_new_free_gift.state
                end,
                if
                    State == 0 ->
                        IsEnough = money:is_enough(Player, Base0#base_act_new_free_gift_help.cost, gold),
                        if Player#player.lv < Base0#base_act_new_free_gift_help.cost andalso Type == 1 ->
                            16;
                            not IsEnough andalso Type =/= 1 ->
                                5;
                            true -> 1
                        end;
                    true ->
                        15
                end
                end,
            List0 = lists:map(F, lists:seq(1, 1)),
            Args = activity:get_base_state(ActInfo),
            case lists:member(1, List0) of
                true -> {1, Args};
                _ -> {0, Args}
            end
    end.

notice(Type, Player, Base) ->
    case Type of
        1 ->
            [{_GoodsId, Num}] = Base#base_act_new_free_gift_help.re_reward,
            Content = io_lib:format(t_tv:get(252), [t_tv:pn(Player), Base#base_act_new_free_gift_help.cost, ?T(Base#base_act_new_free_gift_help.desc), Base#base_act_new_free_gift_help.delay_day, Num]),
            notice:add_sys_notice(Content, 252);
        2 ->
            [{_GoodsId, _Num}] = Base#base_act_new_free_gift_help.re_reward,
            Content = io_lib:format(t_tv:get(253), [t_tv:pn(Player), ?T(Base#base_act_new_free_gift_help.desc), Base#base_act_new_free_gift_help.delay_day]),
            notice:add_sys_notice(Content, 253);
        3 ->
            [{_GoodsId, _Num}] = Base#base_act_new_free_gift_help.re_reward,
            Content = io_lib:format(t_tv:get(254), [t_tv:pn(Player), ?T(Base#base_act_new_free_gift_help.desc), Base#base_act_new_free_gift_help.delay_day]),
            notice:add_sys_notice(Content, 254)
    end,
    ok.

log_new_free_gift(Pkey, Nickname, Lv, Type) ->
    Sql = io_lib:format("insert into log_new_free_gift set pkey=~p,nickname='~s',lv=~p,time=~p,type = ~p", [Pkey, Nickname, Lv, util:unixtime(), Type]),
    log_proc:log(Sql).