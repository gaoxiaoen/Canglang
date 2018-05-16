%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 六月 2016 下午4:51
%%%-------------------------------------------------------------------
-module(open_egg).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("goods.hrl").

%% 协议接口
-export([
    get_open_egg_info/1,
    open_egg/2,
    refresh/1
]).

%% API
-export([
    init/1,
    update/1,
    add_charge/2,
    get_state/1
]).

init(Player) ->
    StOpenEgg = activity_load:dbget_open_egg(Player),
    put_dict(StOpenEgg),
    update(Player),
    Player.

update(_Player) ->
    StOpenEgg = get_dict(),
    #st_open_egg{
        act_id = ActId,
        update_time = UpdateTime
    } = StOpenEgg,
    Now = util:unixtime(),
    NewStOpenEgg =
        case get_act() of
            [] -> StOpenEgg;
            Base ->
                #base_open_egg{
                    act_id = BaseActId
                } = Base,
                case ActId == BaseActId of
                    false ->
                        StOpenEgg#st_open_egg{
                            act_id = BaseActId,
                            charge_val = 0,
                            use_times = 0,
                            get_list = [],
                            goods_list = [],
                            update_time = Now
                        };
                    true ->
                        case util:is_same_date(Now, UpdateTime) of
                            false ->
                                StOpenEgg#st_open_egg{
                                    act_id = BaseActId,
                                    charge_val = 0,
                                    use_times = 0,
                                    get_list = [],
                                    goods_list = [],
                                    update_time = Now
                                };
                            true ->
                                StOpenEgg
                        end
                end
        end,
    put_dict(NewStOpenEgg),
    case NewStOpenEgg#st_open_egg.goods_list of
        [] -> refresh_goods();
        _ -> skip
    end,
    ok.

get_open_egg_info(Player) ->
    case get_act() of
        [] -> skip;
        Base ->
            #base_open_egg{
                open_info = OpenInfo,
                one_charge = OneCharge,
                goods_list = BaseGoodsList
            } = Base,
            StOpenEgg = get_dict(),
            #st_open_egg{
                goods_list = GoodsList,
                get_list = GetList,
                charge_val = ChargeVal
            } = StOpenEgg,
            CostGold = get_next_cost(),
            LeaveTime = activity:calc_act_leave_time(OpenInfo),
            LeaveTimes = get_leave_times(),
            NextMul = get_next_mul(),
            F = fun(BaseOpenEggGoods, {AccList, AccId}) ->
                case BaseOpenEggGoods#base_open_egg_goods.lv == 1 of
                    true ->
                        GList = [[AccId, GoodsId, Num, 1, 0] || {GoodsId, Num, _Pro, _Pro1} <- BaseOpenEggGoods#base_open_egg_goods.goods_list],
                        {AccList ++ GList, AccId + 1};
                    false ->
                        {AccList, AccId}

                end
                end,
            {GoodsStateList, _AccId} = lists:foldl(F, {[], 1}, BaseGoodsList),
            F1 = fun(PosId) ->
                case lists:keyfind(PosId, 1, GetList) of
                    false -> [PosId, 0, 0, 0];
                    {PosId, Id} ->
                        {Id, GoodsId, Num, _Lv, _Pro} = lists:keyfind(Id, 1, GoodsList),
                        [PosId, 1, GoodsId, Num]
                end
                 end,
            EggStateList = lists:map(F1, lists:seq(1, length(GoodsList))),
            Data = {LeaveTime, OneCharge, ChargeVal, LeaveTimes, CostGold, NextMul, GoodsStateList, EggStateList},
            {ok, Bin} = pt_431:write(43181, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

open_egg(Player, PosId) ->
    case check_open_egg(Player, PosId) of
        {false, Res} ->
            {false, Res};
        {ok, CostGold} ->
            StOpenEgg = get_dict(),
            #st_open_egg{
                use_times = UseTimes,
                get_list = GetList,
                goods_list = GoodsList
            } = StOpenEgg,
            HaveGetNum = length(GetList),
            ProList =
                case HaveGetNum < 1 of
                    true -> %%每轮第一次 一等奖权重=原来的权重/5
                        F = fun({Id, _GoodsId, _Num, Lv, Pro}) ->
                            case Lv of
                                1 -> {Id, round(Pro / 5)};
                                _ -> {Id, Pro}
                            end
                            end,
                        lists:map(F, GoodsList);
                    false ->
                        case HaveGetNum == 8 of
                            true -> %%尽量保证最后一抽不是翻倍
                                L = [{Id, Pro} || {Id, _GoodsId, _Num, Lv, Pro} <- GoodsList, lists:keyfind(Id, 2, GetList) == false, Lv == 5],
                                case L of
                                    [] ->
                                        [{Id, Pro} || {Id, _GoodsId, _Num, _Lv, Pro} <- GoodsList, lists:keyfind(Id, 2, GetList) == false];
                                    _ -> L
                                end;
                            false ->
                                [{Id, Pro} || {Id, _GoodsId, _Num, _Lv, Pro} <- GoodsList, lists:keyfind(Id, 2, GetList) == false]
                        end
                end,
            Id = util:list_rand_ratio(ProList),
            {Id, GoodsId, Num, Lv, _Pro} = lists:keyfind(Id, 1, GoodsList),
            NextMul = get_next_mul(),
            Now = util:unixtime(),
            NewStOpenEgg = StOpenEgg#st_open_egg{
                use_times = UseTimes + 1,
                get_list = GetList ++ [{PosId, Id}],
                update_time = Now
            },
            put_dict(NewStOpenEgg),
            activity_load:dbup_open_egg(NewStOpenEgg),
            NewPlayer = money:add_no_bind_gold(Player, -CostGold, 167, GoodsId, Num),
            Mul = is_mul_goods(GoodsId),
            activity:get_notice(Player, [22], true),
            case Mul > 0 of
                true ->
                    NewPlayer1 = money:add_coin(NewPlayer, 50000, 167, 0, 0),
                    %%倍数物品
                    {ok, NewPlayer1, 0, 0, Lv, Mul};
                false ->
                    GetNum = Num * NextMul,
                    GiveGoodsList = goods:make_give_goods_list(167, [{GoodsId, GetNum}]),
                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, GiveGoodsList),
                    case Lv == 1 of
                        true -> %%广播
                            skip;%notice_sys:add_notice(open_egg, [Player, GoodsId]);
                        false ->
                            skip
                    end,
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, GoodsId, GetNum, 167),
                    {ok, NewPlayer1, GoodsId, GetNum, Lv, 1}
            end
    end.
check_open_egg(Player, PosId) ->
    case get_act() of
        [] -> {false, 0};
        _Base ->
            StOpenEgg = get_dict(),
            #st_open_egg{
                get_list = GetList
            } = StOpenEgg,
            LeaveTimes = get_leave_times(),
            CostGold = get_next_cost(),
            IsEnough = money:is_enough(Player, CostGold, gold),
            if
                LeaveTimes =< 0 -> {false, 13};
                not IsEnough -> {false, 5};
                true ->
                    case lists:keyfind(PosId, 1, GetList) of
                        {PosId, _} -> {false, 3};
                        _ ->
                            {ok, CostGold}
                    end
            end
    end.

refresh(_Player) ->
    case get_act() of
        [] -> {false, 0};
        _Base ->
            StOpenEgg = get_dict(),
            #st_open_egg{
                goods_list = GoodsList,
                get_list = GetList
            } = StOpenEgg,
            case GetList of
                [] -> {false, 0};
                _ ->
                    F = fun({_PosId, Id}) ->
                        case lists:keyfind(Id, 1, GoodsList) of
                            false -> 0;
                            {Id, _GoodsId, _Num, Lv, _Pro} ->
                                case Lv == 1 of
                                    true -> 1;
                                    false -> 0
                                end
                        end
                        end,
                    SumLv = lists:sum(lists:map(F, GetList)),
                    case SumLv > 0 orelse length(GetList) >= length(GoodsList) of
                        false -> {false, 0};
                        true ->
                            refresh_goods(),
                            NewOpenEgg = get_dict(),
                            put_dict(NewOpenEgg),
                            ok
                    end
            end
    end.

is_mul_goods(GoodsId) ->
    Base = data_goods:get(GoodsId),
    case Base#goods_type.subtype of
        ?GOODS_SUBTYPE_OPEN_EGG_MUL ->
            Base#goods_type.special_param_list;
        _ ->
            0
    end.

get_next_mul() ->
    StOpenEgg = get_dict(),
    #st_open_egg{
        get_list = GetList,
        goods_list = GoodsList
    } = StOpenEgg,
    get_next_mul_1(lists:reverse(GetList), GoodsList, 1).
get_next_mul_1([], _GoodsList, AccMul) -> AccMul;
get_next_mul_1([{_PosId, Id} | Tail], GoodsList, AccMul) ->
    case lists:keyfind(Id, 1, GoodsList) of
        false -> 1;
        {Id, GoodsId, _Num, _Lv, _Pro} ->
            Mul = is_mul_goods(GoodsId),
            case Mul > AccMul of
                true ->
                    get_next_mul_1(Tail, GoodsList, Mul);
                false ->
                    AccMul
            end
    end.

add_charge(_Player, ChargeVal) ->
    case get_act() of
        [] -> skip;
        _Base ->
            StOpenEgg = get_dict(),
            NewStOpenEgg = StOpenEgg#st_open_egg{
                charge_val = StOpenEgg#st_open_egg.charge_val + ChargeVal
            },
            put_dict(NewStOpenEgg),
            activity_load:dbup_open_egg(NewStOpenEgg),
            ok
    end.

get_dict() ->
    lib_dict:get(?PROC_STATUS_OPEN_EGG).

put_dict(StOpenEgg) ->
    lib_dict:put(?PROC_STATUS_OPEN_EGG, StOpenEgg).

get_act() ->
    case activity:get_work_list_mutex(data_open_egg) of
        [] -> [];
        [Base | _] -> Base
    end.

refresh_goods() ->
    case get_act() of
        [] -> skip;
        Base ->
            #base_open_egg{
                goods_list = GoodsList
            } = Base,
            F = fun(BaseGoods, AccId) ->
                #base_open_egg_goods{
                    lv = Lv,
                    goods_list = ProGoodsList,
                    num = GetNum
                } = BaseGoods,
                ProGoodsList1 = [{{GoodsId, Num, Pro}, Pro1} || {GoodsId, Num, Pro, Pro1} <- ProGoodsList],
                F1 = fun(_, {AccId1, AccProGoodsList}) ->
                    {GoodsId, Num, Pro} = util:list_rand_ratio(AccProGoodsList),
                    NewAccProGoodsList = lists:keydelete({GoodsId, Num, Pro}, 1, AccProGoodsList),
                    {{AccId1, GoodsId, Num, Lv, Pro}, {AccId1 + 1, NewAccProGoodsList}}
                     end,
                {GList, {NewAccId, _ProList}} = lists:mapfoldl(F1, {AccId, ProGoodsList1}, lists:seq(1, GetNum)),
                {GList, NewAccId}
                end,
            {List0, _AccId} = lists:mapfoldl(F, 1, GoodsList),
            List = lists:flatten(List0),
            StOpenEgg = get_dict(),
            NewStOpenEgg = StOpenEgg#st_open_egg{
                get_list = [],
                goods_list = List
            },
            put_dict(NewStOpenEgg),
            activity_load:dbup_open_egg(NewStOpenEgg),
            NewStOpenEgg
    end.

get_leave_times() ->
    Base = get_act(),
    #base_open_egg{
        one_charge = OneCharge
    } = Base,
    StOpenEgg = get_dict(),
    #st_open_egg{
        charge_val = ChargeVal,
        use_times = UseTimes
    } = StOpenEgg,
    case OneCharge =< 0 of
        true -> 999;
        false -> max(0, round(ChargeVal div OneCharge) - UseTimes)
    end.


get_state(_Player) ->
    case get_act() of
        [] -> -1;
        _Base ->
            LeaveTimes = get_leave_times(),
            Args = activity:get_base_state(_Base#base_open_egg.act_info),
            case LeaveTimes > 0 of
                true -> {1, Args};
                false -> {0, Args}
            end
    end.

get_next_cost() ->
    Base = get_act(),
    #base_open_egg{
        cost_gold_list = CostGoldList
    } = Base,
    StOpenEgg = get_dict(),
    #st_open_egg{
        goods_list = GoodsList,
        get_list = GetList
    } = StOpenEgg,
    NextTimes = min(length(GoodsList), length(GetList) + 1),
    case NextTimes > length(CostGoldList) of
        true -> 9999999;
        false -> lists:nth(NextTimes, CostGoldList)
    end.

