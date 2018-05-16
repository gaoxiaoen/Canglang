%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 红装限时抢购
%%% @end
%%% Created : 14. 十一月 2017 15:54
%%%-------------------------------------------------------------------
-module(buy_red_equip).
-author("Administrator").
-include("activity.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("equip.hrl").

%% API
-export([
    init/1,
    update/1,
    get_act/0,
    get_leave_time/0,
    re_set/1,
    get_info/1,
    buy/2,
    get_notice_state/1,
    get_reset_cost/2
]).

init(Player) ->
    St = activity_load:dbget_buy_red_equip(Player#player.key),
    put_dict(St),
    update(Player),
    Player.

update(Player) ->
    St = get_dict(),
    #st_buy_red_equip{
        act_id = ActId
    } = St,
    NewSt =
        case get_act() of
            [] -> St;
            Base ->
                NewList = re_set_help(Base),

                #base_buy_red_equip{
                    act_id = BaseActId
                } = Base,
                case ActId == BaseActId of
                    false ->
                        #st_buy_red_equip{
                            act_id = BaseActId,
                            pkey = Player#player.key,
                            info_list = NewList
                        };
                    true ->
                        St
                end
        end,
    put_dict(NewSt),
    ok.

get_info(_Player) ->
    case get_act() of
        [] -> {0, 0, []};
        Base ->
            St = get_dict(),
            F = fun({Id, State}) ->
                case lists:keyfind(Id, #base_buy_red_equip_info.id, Base#base_buy_red_equip.list) of
                    false -> [];
                    BaseInfo ->
                        [[
                            BaseInfo#base_buy_red_equip_info.id,
                            BaseInfo#base_buy_red_equip_info.goods_id,
                            BaseInfo#base_buy_red_equip_info.goods_num,
                            BaseInfo#base_buy_red_equip_info.old_cost,
                            BaseInfo#base_buy_red_equip_info.now_cost,
                            BaseInfo#base_buy_red_equip_info.discount,
                            State,
                            ?IF_ELSE(BaseInfo#base_buy_red_equip_info.is_paper == 0, 0, 1),
                            get_next(BaseInfo)
                        ]]
                end
            end,
            ?DEBUG("St#st_buy_red_equip.info_list ~p~n", [St#st_buy_red_equip.info_list]),
            Data = lists:flatmap(F, St#st_buy_red_equip.info_list),
            {get_leave_time(), get_reset_cost(Base#base_buy_red_equip.reset_cost, St#st_buy_red_equip.re_count), Data}
    end.

re_set(Player) ->
    case check_re_set(Player) of
        {false, Res} -> {Res, Player};
        {ok, Base} ->
            St = get_dict(),
            Cost = get_reset_cost(Base#base_buy_red_equip.reset_cost, St#st_buy_red_equip.re_count),
            NewPlayer = money:add_no_bind_gold(Player, -Cost, 318, 0, 0),
            log_buy_red_equip(Player#player.key, Player#player.nickname, Cost, []),
            NewList = re_set_help(Base),
            NewSt = St#st_buy_red_equip{info_list = NewList, re_count = St#st_buy_red_equip.re_count + 1},
            put_dict(NewSt),
            activity_load:dbup_buy_red_equip(NewSt),
            activity:get_notice(NewPlayer, [172], true),
            {1, NewPlayer}
    end.

re_set_help(Base) ->
    List1 = re_set_help1(Base#base_buy_red_equip.list),
%%     ?DEBUG("Base#base_buy_red_equip.list ~p~n",[Base#base_buy_red_equip.list]),
%%     ?DEBUG("List1 ~p~n",[List1]),
    List = [{X#base_buy_red_equip_info.id, X#base_buy_red_equip_info.ratio} || X <- List1],
    F = fun(_, {List0, ReList}) ->
        Id = util:list_rand_ratio(List0),
        {lists:keydelete(Id, 1, List0), [{Id, 1} | ReList]}
    end,
    Len = length(List),
    {_, NewList} = lists:foldl(F, {List, []}, lists:seq(1, min(6, Len))),
    NewList.


re_set_help1(List) ->
    SubtypeList = equip_subtype_list(),
    F = fun({Subtype, GoodsId}, List1) ->
        GoodsNum = goods_util:get_goods_count(GoodsId),
        if
            GoodsNum > 0 ->
                case lists:keyfind(GoodsId, #base_buy_red_equip_info.goods_id, List) of
                    false ->
                        List1;
                    Base ->
                        lists:keyreplace(GoodsId, #base_buy_red_equip_info.goods_id, List1, Base#base_buy_red_equip_info{ratio = 0})
                end;
            true ->
                GoodsList = goods:get_goods_list(?GOODS_LOCATION_BODY),
                %% 判断该位置是否有装备
                F = fun(Goods) ->
                    GoodsType = data_goods:get(Goods#goods.goods_id),
                    if
                        GoodsType#goods_type.subtype == Subtype ->
                            true;
                        true ->
                            false
                    end
                end,
                Tmp = lists:filter(F, GoodsList),
                case Tmp of
                    [] ->
                        if
                            GoodsNum =< 0 -> List1;
                            true ->
                                case lists:keyfind(GoodsId, #base_buy_red_equip_info.goods_id, List) of
                                    false ->
                                        List1;
                                    Base ->
                                        lists:keyreplace(GoodsId, #base_buy_red_equip_info.goods_id, List1, Base#base_buy_red_equip_info{ratio = 0})
                                end
                        end;
                    GoodsList1 ->
                        Star = lists:max([Goods#goods.star || Goods <- GoodsList1]),
                        if
                            Star >= 3 ->
                                case lists:keyfind(GoodsId, #base_buy_red_equip_info.goods_id, List) of
                                    false ->
                                        List1;
                                    Base ->
                                        lists:keyreplace(GoodsId, #base_buy_red_equip_info.goods_id, List1, Base#base_buy_red_equip_info{ratio = 0})
                                end;
                            true -> List1
                        end
                end
        end
    end,
    lists:foldl(F, List, SubtypeList).

check_re_set(Player) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            St = get_dict(),
            Cost = get_reset_cost(Base#base_buy_red_equip.reset_cost, St#st_buy_red_equip.re_count),
            case money:is_enough(Player, Cost, gold) of
                false ->
                    {false, 2};
                true ->
                    {ok, Base}
            end
    end.

buy(Player, Id) ->
    case check_buy(Player, Id) of
        {false, Res} -> {Res, Player};
        {ok, _Base, Cost, GoodsId, GoodsNum} ->
            NewPlayer = money:add_no_bind_gold(Player, -Cost, 318, 0, 0),
            St = get_dict(),
            NewInfoList = lists:keyreplace(Id, 1, St#st_buy_red_equip.info_list, {Id, 0}),
            NewSt = St#st_buy_red_equip{info_list = NewInfoList},
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(318, [{GoodsId, GoodsNum}])),
            put_dict(NewSt),
            activity_load:dbup_buy_red_equip(NewSt),
            activity:get_notice(NewPlayer, [172], true),
            log_buy_red_equip(Player#player.key, Player#player.nickname, Cost, [{GoodsId, GoodsNum}]),
            {1, NewPlayer1}
    end.

check_buy(Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            case lists:keyfind(Id, #base_buy_red_equip_info.id, Base#base_buy_red_equip.list) of
                false -> {false, 0};
                BaseInfo ->
                    case money:is_enough(Player, BaseInfo#base_buy_red_equip_info.now_cost, gold) of
                        false -> {false, 2};
                        true ->
                            St = get_dict(),
                            case lists:keyfind(Id, 1, St#st_buy_red_equip.info_list) of
                                false -> {false, 0};
                                {Id, State} ->
                                    if
                                        State /= 1 -> {false, 6};
                                        true ->
                                            {ok, Base, BaseInfo#base_buy_red_equip_info.now_cost, BaseInfo#base_buy_red_equip_info.goods_id, BaseInfo#base_buy_red_equip_info.goods_num}
                                    end
                            end
                    end
            end
    end.

get_next(BaseInfo) ->
    if
        BaseInfo#base_buy_red_equip_info.is_paper == 0 -> 0;
        true ->
            get_count(BaseInfo#base_buy_red_equip_info.is_paper, BaseInfo#base_buy_red_equip_info.goods_id)
    end.

get_count(Index, GoodsId0) ->
    GoodsList = goods:get_goods_list(?GOODS_LOCATION_BODY),
    %% 判断该位置是否有装备
    F = fun(Goods) ->
        GoodsType = data_goods:get(Goods#goods.goods_id),
        if
            GoodsType#goods_type.subtype == Index ->
                true;
            true ->
                false
        end
    end,
    Tmp = lists:filter(F, GoodsList),
    case Tmp of
        [] ->
            Goods0 = data_goods:get(GoodsId0),
            Base = data_equip_upgrade:get(max(1, Goods0#goods_type.color - 2), Index),
            [_H | T] = Base#base_equip_upgrade.need_goods,
            {GoodsId, GoodsNum} = hd(T),
            Count0 = goods_util:get_goods_count(GoodsId),
            max(0, GoodsNum - Count0);
        GoodsList1 ->
            Star = lists:max([Goods#goods.star || Goods <- GoodsList1]),
            Limit = data_equip_upgrade:get_max(),
            if
                Star > Limit ->
                    0;
                true ->
                    Base = data_equip_upgrade:get(max(Star, 3), Index),
                    [_H | T] = Base#base_equip_upgrade.need_goods,
                    {GoodsId, GoodsNum} = hd(T),
                    Count0 = goods_util:get_goods_count(GoodsId),
                    max(0, GoodsNum - Count0)
            end
    end.

get_notice_state(_Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            St = get_dict(),
            F = fun({Id, State}) ->
                case lists:keyfind(Id, #base_buy_red_equip_info.id, Base#base_buy_red_equip.list) of
                    false -> false;
                    BaseInfo ->
                        ?IF_ELSE(BaseInfo#base_buy_red_equip_info.now_cost == 0 andalso State == 1, true, false)
                end
            end,
            Args = activity:get_base_state(Base#base_buy_red_equip.act_info),
            case lists:any(F, St#st_buy_red_equip.info_list) of
                true -> {1, Args};
                _ -> {0, Args}
            end
    end.

get_dict() ->
    lib_dict:get(?PROC_STATUS_BUY_RED_EQUIP).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_BUY_RED_EQUIP, St).

get_act() ->
    case activity:get_work_list(data_buy_red_equip) of
        [] -> [];
        [Base | _] -> Base
    end.

get_leave_time() ->
    LeaveTime = activity:get_leave_time(data_buy_red_equip),
    ?IF_ELSE(LeaveTime < 0, 0, LeaveTime).


log_buy_red_equip(Pkey, Nickname, Cost, GoodsList) ->
    Sql = io_lib:format("insert into  log_buy_red_equip (pkey, nickname,cost,goods_list,time) VALUES(~p,'~s',~p,'~s',~p)",
        [Pkey, Nickname, Cost, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.

get_reset_cost(ReSetList, Count) ->
    List = [Cost0 || {Count0, Cost0} <- ReSetList, Count0 >= Count + 1],
    if
        List == [] ->
            {_, Cost} = lists:last(ReSetList),
            Cost;
        true ->
            Cost = hd(List),
            Cost
    end.

equip_subtype_list() ->
    [{7, 2601002},
        {2, 2602002},
        {130, 2603002},
        {6, 2604002},
        {5, 2605002},
        {1, 2606002},
        {3, 2607002},
        {4, 2608002}].
