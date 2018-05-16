%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 下午9:11
%%%-------------------------------------------------------------------
-module(xiulian).
-author("fengzhenlin").

-include("server.hrl").
-include("common.hrl").
-include("xiulian.hrl").

%% 协议接口
-export([
    get_xiulian_info/1,
    xiulian_up/2,
    clear_cd/1,
    check_xiulian_state/1,
    get_xiulian_lv_total/0
]).

%% api
-export([
    get_xiulian_attr/0,
    timer_update/0
]).

-define(XIULIAN_NUM, 6).
-define(TUPO_COST_GOODS_ID, 28400).
-define(XIULIAN_GOODS_ID, 10401).

get_xiulian_info(Player) ->
    XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    #st_xiulian{
        dict = Dict,
        cd_time = CdTime,
        tupo_lv = TupoLv,
        spec_times = UseSpecTimes
    } = XiulianSt,
    Now = util:unixtime(),
    LeaveTime = max(0, CdTime - Now),
    ClearCdCost = get_clear_cost(LeaveTime),
    F = fun(Id) ->
        XiulianLv =
            case dict:find(Id, Dict) of
                error -> 0;
                {ok, Xiulian} ->
                    Xiulian#xiulian.lv
            end,
        [Id, XiulianLv]
        end,
    XiulianList = lists:map(F, lists:seq(1, 6)),
    SumAttr = get_xiulian_attr(),
    SumAttrList = attribute_util:pack_attr(SumAttr),
    Combatpower = attribute_util:calc_combat_power(SumAttr),
    MinLv = lists:min([Lv || [_, Lv] <- XiulianList]),
    %%突破
    CanTupoLv = get_can_tupo_lv(),
    case CanTupoLv > 0 of
        true ->
            IsTupo = 1,
            BaseTupo = data_xiulian_tupo:get(CanTupoLv),
            #base_xiulian_tupo{
                pro = TupoPro,
                cost_num = TupoCostNum
            } = BaseTupo;
        false ->
            IsTupo = 0,
            TupoPro = 0,
            TupoCostNum = 0
    end,
    %%当前突破等级
    CurTupoLv = TupoLv,
    CurTupoAttr = attribute_util:pack_attr(calc_tupo_attr(CurTupoLv)),
    %%下一突破等级
    NextTupoLv0 = get_can_tupo_lv_helper(data_xiulian_tupo:get_all(), TupoLv, 999),
    NextTupoLv = ?IF_ELSE(NextTupoLv0 == 0, TupoLv, NextTupoLv0),
    NextTupoAttr = attribute_util:pack_attr(calc_tupo_attr(NextTupoLv)),
    %%提升
    {NextUpId, NextUpLv} = get_next_up_xiulian(),
    NowAttrList =
        case NextUpLv == 1 of
            true -> [];
            false ->
                NowBase = data_xiulian:get(NextUpId, NextUpLv - 1),
                attribute_util:pack_attr(NowBase#base_xiulian.attrs)
        end,
    NextBase = data_xiulian:get(NextUpId, NextUpLv),
    #base_xiulian{
        attrs = NextBaseAttrs,
        need_lv = NeedLv,
        need_vip = NeedVip
    } = NextBase,
    NextAttrList = attribute_util:pack_attr(NextBaseAttrs),
    CostGold0 = NextBase#base_xiulian.cost_gold,
    CostGold = ?IF_ELSE(is_spec_time(Player), round(CostGold0 * 0.5), CostGold0),
    HaveGoodsNum = goods_util:get_goods_count(?TUPO_COST_GOODS_ID),
    %%半价次数
    MaxSpecTimes = get_max_spec_times(Player),
    LeaveTimes = max(0, MaxSpecTimes - UseSpecTimes),
    VipLv = Player#player.vip_lv,
    GoodsCount = goods_util:get_goods_count(?XIULIAN_GOODS_ID),
    {ok, Bin} = pt_280:write(28000, {XiulianList, SumAttrList, Combatpower, MinLv, IsTupo, TupoPro, TupoCostNum, CurTupoLv, CurTupoAttr, NextTupoLv, NextTupoAttr,
        NeedLv, NextUpId, NowAttrList, NextAttrList, CostGold, LeaveTime, ClearCdCost, HaveGoodsNum, VipLv, MaxSpecTimes, LeaveTimes, NeedVip, GoodsCount}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_max_spec_times(Player) ->
    data_vip_args:get(38, Player#player.vip_lv).

is_spec_time(Player) ->
    XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    #st_xiulian{
        spec_times = UseSpecTimes
    } = XiulianSt,
    MaxSpecTimes = get_max_spec_times(Player),
    MaxSpecTimes > UseSpecTimes.

%%检查觉醒是否可升级
check_xiulian_state(Player) ->
    case check_xiulian_up(Player, 0) of
        {false, _} -> 0;
        _ -> 1
    end.

xiulian_up(Player, IsAuto) ->
    case check_xiulian_up(Player, IsAuto) of
        {false, Res} ->
            {false, Res};
        {ok, Base} ->
            if
                is_record(Base, base_xiulian) ->
                    NewPlayer = do_xiulian_up(Player, Base),
                    {ok, NewPlayer, 1};
                true ->
                    {NewPlayer, TupoRes} = do_xiulian_tupo(Player, Base),
                    {ok, NewPlayer, TupoRes}
            end
    end.
check_xiulian_up(Player, IsAuto) ->
    XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    #st_xiulian{
        dict = Dict,
        cd_time = CdTime
    } = XiulianSt,
    Now = util:unixtime(),
    if
        Player#player.vip_lv =< 0 -> {false, 9};
        Now < CdTime -> {false, 4};
        true ->
            %% 是否突破
            CanTupoLv = get_can_tupo_lv(),
            case CanTupoLv > 0 of
                true -> %%突破
                    BaseTupo = data_xiulian_tupo:get(CanTupoLv),
                    #base_xiulian_tupo{
                        cost_num = CostNum
                    } = BaseTupo,
                    HaveNum = goods_util:get_goods_count(?TUPO_COST_GOODS_ID),
                    if
                        HaveNum < CostNum andalso IsAuto == 0 ->
                            {false, 2};
                        true ->
                            case HaveNum < CostNum of
                                true ->
                                    BuyNum = CostNum - HaveNum,
                                    case new_shop:get_goods_price(?TUPO_COST_GOODS_ID) of
                                        false -> {false, 0};
                                        {ok, Type, Price} ->
                                            Cost = Price * BuyNum,
                                            IsEnough = money:is_enough(Player, Cost, Type),
                                            if
                                                not IsEnough -> {false, 5};
                                                true ->
                                                    {ok, BaseTupo}
                                            end
                                    end;

                                false ->
                                    {ok, BaseTupo}
                            end
                    end;
                false -> %%升级
                    %%是否满级
                    MaxLv = data_xiulian:get_max_lv(),
                    IsFullLv =
                        case dict:find(?XIULIAN_NUM, Dict) of
                            error -> false;
                            {ok, LastXiulian} -> LastXiulian#xiulian.lv >= MaxLv
                        end,
                    {XiulianId, XiulianLv} = get_next_up_xiulian(),
                    if
                        IsFullLv -> {false, 6};
                        true ->
                            Res =
                                case dict:find(XiulianId, Dict) of
                                    {ok, Xiulian} ->
                                        case Xiulian#xiulian.lv >= XiulianLv of
                                            true -> false;
                                            false -> ok
                                        end;
                                    error -> ok
                                end,
                            if
                                Res == false -> {false, 0};
                                true ->
                                    Base = data_xiulian:get(XiulianId, XiulianLv),
                                    #base_xiulian{
                                        cost_gold = CostGold0,
                                        need_lv = NeedLv,
                                        need_vip = NeedVip
                                    } = Base,
                                    CostGold = ?IF_ELSE(is_spec_time(Player), round(CostGold0 * 0.5), CostGold0),
%%修改为消耗物品
                                    GoodsCount = goods_util:get_goods_count(?XIULIAN_GOODS_ID),
                                    if
                                        CostGold > GoodsCount -> {false, 10};
                                        NeedLv > Player#player.lv -> {false, 8};
                                        NeedVip > Player#player.vip_lv -> {false, 11};
                                        true -> {ok, Base}
                                    end
                            end
                    end
            end
    end.

%%原力提升
do_xiulian_up(Player, Base) ->
    #base_xiulian{
        id = Id,
        lv = Lv,
        cost_gold = CostGold0,
        cd_time = AddCdTime
    } = Base,
    XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    #st_xiulian{
        dict = Dict,
        spec_times = SpecTimes
    } = XiulianSt,
    CostGold = ?IF_ELSE(is_spec_time(Player), round(CostGold0 * 0.5), CostGold0),
    NewSpecTimes = ?IF_ELSE(is_spec_time(Player), SpecTimes + 1, SpecTimes),
    case goods:subtract_good(Player, [{?XIULIAN_GOODS_ID, CostGold}], 130) of
        {false, _} -> {false, 0};
        _ ->
            CdTime =
                case data_vip_args:get(32, Player#player.vip_lv) > 0 of
                    true -> 0;
                    false -> AddCdTime
                end,
            Now = util:unixtime(),
            NewDict = dict:store(Id, #xiulian{id = Id, lv = Lv}, Dict),
            NewXiulianSt = XiulianSt#st_xiulian{
                dict = NewDict,
                cd_time = Now + CdTime,
                spec_times = NewSpecTimes,
                spec_update_time = Now,
                dirty = 1
            },
            lib_dict:put(?PROC_STATUS_XIULIAN, NewXiulianSt),
            NewPlayer1 = player_util:count_player_attribute(Player, true),
            NewPlayer1
    end.

%%原力突破
do_xiulian_tupo(Player, BaseTupo) ->
    #base_xiulian_tupo{
        lv = Lv,
        pro = Pro,
        cost_num = CostNum
    } = BaseTupo,
    XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    HaveCount = goods_util:get_goods_count(?TUPO_COST_GOODS_ID),
    BuyNum = max(0, CostNum - HaveCount),
    Player2 =
        case BuyNum > 0 of  %%物品不够，代表自动购买
            true ->
                DelNum = HaveCount,
                {ok, Type, Price} = new_shop:get_goods_price(?TUPO_COST_GOODS_ID),
                money:cost_money(Player, Type, Price * BuyNum, 152, ?TUPO_COST_GOODS_ID, BuyNum);
            false ->
                DelNum = CostNum,
                Player
        end,
    %%先扣除物品
    DelRes =
        case DelNum > 0 of
            true ->
                case goods:subtract_good(Player, [{?TUPO_COST_GOODS_ID, DelNum}], 152) of
                    {false, _Res} -> false;
                    _ -> true
                end;
            false ->
                true
        end,
    case DelRes of
        false -> {Player2, 0};
        true ->
            Rand = util:rand(1, 100),
            case Rand =< Pro of
                true ->
                    NewXiulianSt = XiulianSt#st_xiulian{
                        tupo_lv = Lv
                    },
                    lib_dict:put(?PROC_STATUS_XIULIAN, NewXiulianSt),
                    xiulian_load:dbup_xiulian_info(NewXiulianSt),
                    NewPlayer = player_util:count_player_attribute(Player2, true),
                    {NewPlayer, 1};
                false ->
                    {Player2, 0}
            end
    end.

%%清CD
clear_cd(Player) ->
    case check_clear_cd(Player) of
        {false, Res} ->
            {false, Res};
        {ok, CostGold} ->
            NewPlayer = money:add_gold(Player, -CostGold, 153, 0, 0),
            XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
            NewXiulianSt = XiulianSt#st_xiulian{
                cd_time = 0
            },
            lib_dict:put(?PROC_STATUS_XIULIAN, NewXiulianSt),
            xiulian_load:dbup_xiulian_info(NewXiulianSt),
            {ok, NewPlayer}
    end.
check_clear_cd(Player) ->
    XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    #st_xiulian{
        cd_time = CdTime
    } = XiulianSt,
    Now = util:unixtime(),
    if
        Now > CdTime -> {false, 0};
        true ->
            Now = util:unixtime(),
            LeaveTime = max(0, CdTime - Now),
            CostGold = get_clear_cost(LeaveTime),
            IsEnough = money:is_enough(Player, CostGold, bgold),
            if
                not IsEnough -> {false, 5};
                true ->
                    {ok, CostGold}
            end
    end.


%%获取原力属性
get_xiulian_attr() ->
    XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    #st_xiulian{
        dict = Dict,
        tupo_lv = TupoLv
    } = XiulianSt,
    %%原力升级属性
    F = fun(Id) ->
        case dict:find(Id, Dict) of
            error -> #attribute{};
            {ok, Xiulian} ->
                Base = data_xiulian:get(Id, Xiulian#xiulian.lv),
                Base#base_xiulian.attrs
        end
        end,
    Attrs1 = attribute_util:sum_attribute(lists:map(F, lists:seq(1, 6))),
    %%原力突破属性
    Attrs2 = calc_tupo_attr(TupoLv),
    attribute_util:sum_attribute([Attrs1, Attrs2]).

%%获取突破属性
calc_tupo_attr(TupoLv) ->
    %%原力突破属性
    case data_xiulian_tupo:get(TupoLv) of
        [] -> #attribute{};
        Base ->
            #base_xiulian_tupo{
                attrs = Attrs
            } = Base,
            Attrs
    end.

%%获取可突破等级 返回0代表现在不可突破
get_can_tupo_lv() ->
    XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    #st_xiulian{
        dict = Dict,
        tupo_lv = TupoLv
    } = XiulianSt,
    F = fun({_Key, Xiulian}) ->
        Xiulian#xiulian.lv
        end,
    LvList = lists:map(F, dict:to_list(Dict)),
    Len = length(LvList),
    SumLv = lists:sum(LvList),
    if
        Len < ?XIULIAN_NUM -> 0;
        SumLv rem ?XIULIAN_NUM =/= 0 -> 0;
        true ->
            MinLv = lists:min(LvList),
            if
                MinLv =< TupoLv -> 0;
                true ->
                    get_can_tupo_lv_helper(data_xiulian_tupo:get_all(), TupoLv, MinLv)
            end
    end.
get_can_tupo_lv_helper([], _TupoLv, _MinLv) -> 0;
get_can_tupo_lv_helper([Lv | Tail], TupoLv, MinLv) ->
    case Lv =< TupoLv of
        true -> get_can_tupo_lv_helper(Tail, TupoLv, MinLv);
        false ->
            case Lv > MinLv of
                true -> 0;
                false -> Lv
            end
    end.

%%获取下一个可提升的原力 返回原力id 和 原力lv
get_next_up_xiulian() ->
    XiulianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    #st_xiulian{
        dict = Dict
    } = XiulianSt,
    F = fun({_Key, Xiulian}) ->
        Xiulian#xiulian.lv
        end,
    LvList = lists:map(F, dict:to_list(Dict)),
    Len = length(LvList),
    case Len < ?XIULIAN_NUM of
        true -> {Len + 1, 1};  %%第一次
        false ->
            MaxLv = data_xiulian:get_max_lv(),
            SumLv = lists:sum(LvList),
            case SumLv rem ?XIULIAN_NUM == 0 of
                true ->
                    FirLv = hd(LvList),
                    case data_xiulian:get(1, FirLv + 1) of
                        [] -> {1, FirLv};  %%满级
                        _Base -> {1, FirLv + 1}
                    end;
                false ->
                    case get_next_up_xiulian_helper(lists:seq(1, ?XIULIAN_NUM), Dict, {0, 0}) of
                        false -> ?ERR("xiulian get next up lv err ~p~n", [dict:to_list(Dict)]), {6, MaxLv};
                        {Id, Lv} -> {Id, Lv}
                    end
            end
    end.
get_next_up_xiulian_helper([], _Dict, _) -> false;
get_next_up_xiulian_helper([Id | Tail], Dict, {NextId, NextLv}) ->
    {ok, Xiulian} = dict:find(Id, Dict),
    #xiulian{id = YId, lv = YLv} = Xiulian,
    case NextId == 0 of
        true ->
            get_next_up_xiulian_helper(Tail, Dict, {YId, YLv});
        false ->
            case YLv < NextLv of
                true -> {YId, YLv + 1};
                false -> get_next_up_xiulian_helper(Tail, Dict, {YId, YLv})
            end
    end.

get_clear_cost(_LeaveTime) ->
    10.


%%获取原力总等级
get_xiulian_lv_total() ->
    XiuLianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    F = fun({_, XiuLian}) -> XiuLian#xiulian.lv
        end,
    lists:sum(lists:map(F, dict:to_list(XiuLianSt#st_xiulian.dict))).

timer_update() ->
    XiuLianSt = lib_dict:get(?PROC_STATUS_XIULIAN),
    #st_xiulian{
        dirty = Dirty
    } = XiuLianSt,
    case Dirty == 1 of
        true ->
            xiulian_load:dbup_xiulian_info(XiuLianSt),
            NewXiuLianSt = XiuLianSt#st_xiulian{
                dirty = 0
            },
            lib_dict:put(?PROC_STATUS_XIULIAN, NewXiuLianSt);
        false ->
            skip
    end.