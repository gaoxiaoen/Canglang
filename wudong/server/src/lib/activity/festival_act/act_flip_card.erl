%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 幸运翻牌
%%% @end
%%% Created : 23. 九月 2017 17:43
%%%-------------------------------------------------------------------
-module(act_flip_card).
-author("Administrator").
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    update/0,
    log_out/0,
    re_set/1,
    get_info/1,
    flip_card/2,
    get_state/1
]).


init(#player{key = Pkey} = Player) ->
    St =
        case player_util:is_new_role(Player) of
            true -> #st_act_flip_card{pkey = Pkey};
            false ->
                activity_load:dbget_act_flip_card(Pkey)
        end,
    put_dict(St),
    update(),
    Player.

update() ->
    St = get_dict(),
    #st_act_flip_card{
        pkey = Pkey,
        last_login_time = LastLoginTime
    } = St,
    Now = util:unixtime(),
    Flag = util:is_same_date(Now, LastLoginTime),
    if
        Flag == false ->
            NewSt = #st_act_flip_card{pkey = Pkey, last_login_time = Now};
        true ->
            NewSt = St#st_act_flip_card{last_login_time = Now}
    end,
    put_dict(NewSt).

get_dict() ->
    lib_dict:get(?PROC_STATUS_ACT_FLIP_CARD).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_ACT_FLIP_CARD, St).

log_out() ->
    St = get_dict(),
    activity_load:dbup_act_flip_card(St),
    ok.

get_info(_Player) ->
    case get_act() of
        [] -> {0, 0, [], [], [], []};
        Base ->
            LeaveTime = get_leave_time(),
            SameList = make_same_list(Base#base_act_flip_card.luck_reward),
            RewardList = make_reward_list(Base#base_act_flip_card.reward_list),
            St = get_dict(),
            F = fun(Id) ->
                case lists:keyfind(Id, 1, St#st_act_flip_card.card_list) of
                    false -> [Id, 0, 0, 0];
                    {Id, State, Goods_id, Goods_num} ->
                        [Id, State, Goods_id, Goods_num]
                end
            end,
            CardList = lists:map(F, lists:seq(1, 4)),
            {LeaveTime, Base#base_act_flip_card.cost, SameList, CardList, RewardList, goods:pack_goods(St#st_act_flip_card.log_list)}
    end.
make_same_list(LuckReward) ->
    F = fun({Same, GoodsList}) ->
        [Same | [goods:pack_goods(GoodsList)]]
    end,
    lists:map(F, LuckReward).

make_reward_list(LuckReward) ->
    F = fun({_Id, GoodsId, GoodsNum, _Ratio}) ->
        [GoodsId, GoodsNum]
    end,
    lists:map(F, LuckReward).

get_act() ->
    case activity:get_work_list(data_act_flip_card) of
        [] -> [];
        [Base | _] -> Base
    end.

get_leave_time() ->
    LeaveTime = activity:get_leave_time(data_act_flip_card),
    ?IF_ELSE(LeaveTime < 0, 0, LeaveTime).

init_card_list(Base, St) ->
    Same = util:list_rand_ratio(Base#base_act_flip_card.ratio_list), %% 随机相同数
    RewardList = [{{GoodsId, GoodsNum}, Ratio} || {_, GoodsId, GoodsNum, Ratio} <- Base#base_act_flip_card.reward_list],
    Result = lists_random(RewardList, max(1, 5 - Same)),
    [LuckList | OtherList] = Result,
    CardList0 = lists:duplicate(Same, LuckList) ++ OtherList,
    CardList1 = util:list_shuffle(CardList0),
    F = fun({GoodsId, GoodsNum}, {Id0, List0}) ->
        {Id0 + 1, [{Id0, 0, GoodsId, GoodsNum} | List0]}
    end,
    {_, CardList2} = lists:foldl(F, {1, []}, CardList1),
    St#st_act_flip_card{same_flag = Same, card_list = CardList2}.

%%ID 0一键翻牌
flip_card(Player, 0) ->
    case get_act() of
        [] -> {0, Player};
        Base ->
            St0 = get_dict(),
            St = ?IF_ELSE(St0#st_act_flip_card.card_list == [], init_card_list(Base, St0), St0),
            case lists:filter(fun({_, State, _, _}) -> State == 0 end, St#st_act_flip_card.card_list) of
                [] ->
                    {12, Player};
                FilterList ->
                    Times = length(FilterList),
                    Price = Base#base_act_flip_card.cost * Times,
                    case money:is_enough(Player, Price, gold) of
                        false -> {5, Player};
                        true ->
                            Player1 = money:add_no_bind_gold(Player, - Price, 305, 0, 0),
                            NewSt = St#st_act_flip_card{card_list = [{Id, 1, Gid, Num} || {Id, _, Gid, Num} <- St#st_act_flip_card.card_list]},
                            put_dict(NewSt),
                            activity_load:dbup_act_flip_card(NewSt),
                            GoodsList = [{Gid, Num} || {_, _, Gid, Num} <- FilterList],
                            {ok, NewPlayer} = goods:give_goods(Player1, goods:make_give_goods_list(305, GoodsList)),
                            case lists:keyfind(St#st_act_flip_card.same_flag, 1, Base#base_act_flip_card.luck_reward) of
                                false ->
                                    ?ERR("not same reward ~p~n", [St#st_act_flip_card.same_flag]),
                                    LogList = [],
                                    NewPlayer1 = NewPlayer;
                                {_, GoodsList1} ->
                                    log_act_flip_card(Player#player.key, Player#player.nickname, 0, St#st_act_flip_card.same_flag, GoodsList1),
                                    LogList = GoodsList1,
                                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(305, GoodsList1))
                            end,
                            log_act_flip_card(Player#player.key, Player#player.nickname, Base#base_act_flip_card.cost, 0, GoodsList),
                            LogList1 = LogList ++ GoodsList,
                            put_dict(NewSt#st_act_flip_card{log_list = lists:sublist(NewSt#st_act_flip_card.log_list ++ LogList1, 20)}),
                            act_daily_task:trigger_finish(Player, ?ACT_FLIP_CARD, Times),
                            festival_state:send_all(NewPlayer1),
                            {1, NewPlayer1}
                    end
            end
    end;
flip_card(Player, Id) ->
    case check_flip(Player, Id) of
        {false, Err} ->
            {Err, Player};
        {ok, St, Base} ->
            {value, {Id, _State, GoodsId, GoodsNum}, List} = lists:keytake(Id, 1, St#st_act_flip_card.card_list),
            Player1 = money:add_no_bind_gold(Player, - Base#base_act_flip_card.cost, 305, GoodsId, GoodsNum),
            NewSt = St#st_act_flip_card{card_list = [{Id, 1, GoodsId, GoodsNum} | List]},
            put_dict(NewSt),
            activity_load:dbup_act_flip_card(NewSt),
            {ok, NewPlayer} = goods:give_goods(Player1, goods:make_give_goods_list(305, [{GoodsId, GoodsNum}])),
            case check_all_flip(NewSt#st_act_flip_card.card_list) of
                true ->
                    case lists:keyfind(St#st_act_flip_card.same_flag, 1, Base#base_act_flip_card.luck_reward) of
                        false ->
                            ?ERR("not same reward ~p~n", [St#st_act_flip_card.same_flag]),
                            LogList = [],
                            NewPlayer1 = NewPlayer;
                        {_, GoodsList} ->
                            log_act_flip_card(Player#player.key, Player#player.nickname, 0, St#st_act_flip_card.same_flag, GoodsList),
                            LogList = GoodsList,
                            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(305, GoodsList))
                    end;
                false ->
                    LogList = [],
                    NewPlayer1 = NewPlayer
            end,
            log_act_flip_card(Player#player.key, Player#player.nickname, Base#base_act_flip_card.cost, 0, [{GoodsId, GoodsNum}]),
            LogList1 = LogList ++ [{GoodsId, GoodsNum}],
            put_dict(NewSt#st_act_flip_card{log_list = lists:sublist(NewSt#st_act_flip_card.log_list ++ LogList1, 20)}),
            act_daily_task:trigger_finish(Player, ?ACT_FLIP_CARD, 1),
            festival_state:send_all(NewPlayer1),
            {1, NewPlayer1}
    end.

check_all_flip(CardList) ->
    F = fun({_, State, _, _}) -> State == 1 end,
    lists:all(F, CardList).

check_flip(Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            case money:is_enough(Player, Base#base_act_flip_card.cost, gold) of
                false -> {false, 5};
                true ->
                    St = get_dict(),
                    if
                        St#st_act_flip_card.card_list == [] ->
                            NewSt = init_card_list(Base, St),
                            case lists:keymember(Id, 1, NewSt#st_act_flip_card.card_list) of
                                false -> {false, 19};
                                true ->
                                    {ok, NewSt, Base}
                            end;
                        true ->
                            case lists:keyfind(Id, 1, St#st_act_flip_card.card_list) of
                                false ->
                                    {false, 19};
                                {_, State, _, _} ->
                                    if State == 1 -> {false, 18};
                                        true ->
                                            {ok, St, Base}
                                    end
                            end
                    end
            end
    end.



lists_random(List, Num) ->
    ListSize = length(List),
    if ListSize < Num ->
        List;
        true ->
            F = fun(_N, {List1, List2}) ->
                Random = util:list_rand_ratio(List1),
                List3 = lists:keydelete(Random, 1, List1),
                {List3, [Random | List2]}
            end,
            {_, Result} = lists:foldl(F, {List, []}, lists:seq(1, Num)),
            Result
    end.


re_set(Player) ->
    case check_reset(Player) of
        {false, Res} -> {Res, Player};
        ok ->
            St = get_dict(),
            NewSt = St#st_act_flip_card{same_flag = 1, card_list = []},
            put_dict(NewSt),
            activity_load:dbup_act_flip_card(NewSt),
            {1, Player}
    end.

check_reset(_Player) ->
    case get_act() of
        [] -> {false, 0};
        _ ->
            St = get_dict(),
            F = fun({_Id, State, _GoodsId, _GoodsNum}) ->
                ?IF_ELSE(State == 1, true, false)
            end,
            case lists:all(F, St#st_act_flip_card.card_list) of
                false -> {false, 13};
                true -> ok
            end
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        _Base ->
            0
    end.

log_act_flip_card(Pkey, Nickname, Cost, Same, GoodsList) ->
    Sql = io_lib:format("insert into log_act_flip_card set pkey=~p,nickname='~s',cost = ~p,same = ~p,goods_list = '~s',time=~p",
        [Pkey, Nickname, Cost, Same, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.