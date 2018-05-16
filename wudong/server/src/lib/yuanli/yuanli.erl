%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 下午2:26
%%%-------------------------------------------------------------------
-module(yuanli).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("yuanli.hrl").

%% 协议接口
-export([
    get_yuanli_info/1,
    yuanli_up/2,
    clear_cd/1,
    check_yuanli_state/1,
    get_yuanli_lv_total/0
]).

-export([
    get_yuanli_attr/0,
    timer_update/0
]).

-define(YUANLI_NUM, 6).
-define(TUPO_COST_GOODS_ID, 28400).

get_yuanli_info(Player) ->
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    #st_yuanli{
        dict = Dict,
        cd_time = CdTime,
        tupo_lv = TupoLv,
        spec_times = UseSpecTimes
    } = YuanliSt,
    Now = util:unixtime(),
    LeaveTime = max(0, CdTime - Now),
    ClearCdCost = get_clear_cost(LeaveTime),
    F = fun(Id) ->
        YuanliLv =
            case dict:find(Id, Dict) of
                error -> 0;
                {ok, Yuanli} ->
                    Yuanli#yuanli.lv
            end,
        [Id, YuanliLv]
        end,
    YuanliList = lists:map(F, lists:seq(1, 6)),
    SumAttr = get_yuanli_attr(),
    SumAttrList = attribute_util:pack_attr(SumAttr),
    Combatpower = attribute_util:calc_combat_power(SumAttr),
    MinLv = lists:min([Lv || [_, Lv] <- YuanliList]),
    %%突破
    CanTupoLv = get_can_tupo_lv(),
    case CanTupoLv > 0 of
        true ->
            IsTupo = 1,
            BaseTupo = data_yuanli_tupo:get(CanTupoLv),
            #base_yuanli_tupo{
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
    NextTupoLv0 = get_can_tupo_lv_helper(data_yuanli_tupo:get_all(), TupoLv, 999),
    NextTupoLv = ?IF_ELSE(NextTupoLv0 == 0, TupoLv, NextTupoLv0),
    NextTupoAttr = attribute_util:pack_attr(calc_tupo_attr(NextTupoLv)),
    %%提升
    {NextUpId, NextUpLv} = get_next_up_yuanli(),
    NowAttrList =
        case NextUpLv == 1 of
            true -> [];
            false ->
                NowBase = data_yuanli:get(NextUpId, NextUpLv - 1),
                attribute_util:pack_attr(NowBase#base_yuanli.attrs)
        end,
    NextBase = data_yuanli:get(NextUpId, NextUpLv),
    #base_yuanli{
        attrs = NextBaseAttr,
        need_lv = NeedLv
    } = NextBase,
    NextAttrList = attribute_util:pack_attr(NextBaseAttr),
    CostCoin0 = NextBase#base_yuanli.cost_coin,
    CostCoin = ?IF_ELSE(is_spec_time(Player), round(CostCoin0 * 0.5), CostCoin0),
    HaveGoodsNum = goods_util:get_goods_count(?TUPO_COST_GOODS_ID),
    %%半价次数
    MaxSpecTimes = get_max_spec_times(Player),
    LeaveTimes = max(0, MaxSpecTimes - UseSpecTimes),
    VipLv = Player#player.vip_lv,
    {ok, Bin} = pt_290:write(29000, {YuanliList, SumAttrList, Combatpower, MinLv, IsTupo, TupoPro, TupoCostNum, CurTupoLv, CurTupoAttr, NextTupoLv, NextTupoAttr,
        NeedLv, NextUpId, NowAttrList, NextAttrList, CostCoin, LeaveTime, ClearCdCost, HaveGoodsNum, VipLv, MaxSpecTimes, LeaveTimes}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_max_spec_times(Player) ->
    data_vip_args:get(37, Player#player.vip_lv).

is_spec_time(Player) ->
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    #st_yuanli{
        spec_times = UseSpecTimes
    } = YuanliSt,
    MaxSpecTimes = get_max_spec_times(Player),
    MaxSpecTimes > UseSpecTimes.

%%检查原力是否提示
check_yuanli_state(Player) ->
    case check_yuanli_up(Player, 0) of
        {false, _} -> 0;
        _ -> 1
    end.

yuanli_up(Player, IsAuto) ->
    case check_yuanli_up(Player, IsAuto) of
        {false, Res} ->
            {false, Res};
        {ok, Base} ->
            Player#player.pid ! {d_v_trigger, 9, 1},
            if
                is_record(Base, base_yuanli) ->
                    NewPlayer = do_yuanli_up(Player, Base),
                    {ok, NewPlayer, 1};
                true ->
                    {NewPlayer, TupoRes} = do_yuanli_tupo(Player, Base),
                    {ok, NewPlayer, TupoRes}
            end
    end.
check_yuanli_up(Player, IsAuto) ->
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    #st_yuanli{
        dict = Dict,
        cd_time = CdTime
    } = YuanliSt,
    Now = util:unixtime(),
    if
        Now < CdTime -> {false, 4};
        true ->
            %% 是否突破
            CanTupoLv = get_can_tupo_lv(),
            case CanTupoLv > 0 of
                true -> %%突破
                    BaseTupo = data_yuanli_tupo:get(CanTupoLv),
                    #base_yuanli_tupo{
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
                    MaxLv = data_yuanli:get_max_lv(),
                    IsFullLv =
                        case dict:find(?YUANLI_NUM, Dict) of
                            error -> false;
                            {ok, LastYuanli} -> LastYuanli#yuanli.lv >= MaxLv
                        end,
                    {YuanliId, YuanliLv} = get_next_up_yuanli(),
                    if
                        IsFullLv -> {false, 6};
                        true ->
                            Res =
                                case dict:find(YuanliId, Dict) of
                                    {ok, Yuanli} ->
                                        case Yuanli#yuanli.lv >= YuanliLv of
                                            true -> false;
                                            false -> ok
                                        end;
                                    error -> ok
                                end,
                            if
                                Res == false -> {false, 0};
                                true ->
                                    Base = data_yuanli:get(YuanliId, YuanliLv),
                                    #base_yuanli{
                                        cost_coin = CostCoin0,
                                        need_lv = NeedLv
                                    } = Base,
                                    CostCoin = ?IF_ELSE(is_spec_time(Player), round(CostCoin0 * 0.5), CostCoin0),
                                    IsEnough = money:is_enough(Player, CostCoin, coin),
                                    if
                                        not IsEnough -> {false, 3};
                                        NeedLv > Player#player.lv -> {false, 8};
                                        true -> {ok, Base}
                                    end
                            end
                    end
            end
    end.

%%原力提升
do_yuanli_up(Player, Base) ->
    #base_yuanli{
        id = Id,
        lv = Lv,
        cost_coin = CostCoin0,
        cd_time = AddCdTime
    } = Base,
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    #st_yuanli{
        dict = Dict,
        spec_times = SpecTimes
    } = YuanliSt,
    CostCoin = ?IF_ELSE(is_spec_time(Player), round(CostCoin0 * 0.5), CostCoin0),
    NewSpecTimes = ?IF_ELSE(is_spec_time(Player), SpecTimes + 1, SpecTimes),
    NewPlayer = money:add_coin(Player, -CostCoin, 130, 0, 0),
    CdTime =
        case data_vip_args:get(31, Player#player.vip_lv) > 0 of
            true -> 0;
            false -> AddCdTime
        end,
    Now = util:unixtime(),
    NewDict = dict:store(Id, #yuanli{id = Id, lv = Lv}, Dict),
    NewYuanliSt = YuanliSt#st_yuanli{
        dict = NewDict,
        cd_time = Now + CdTime,
        spec_times = NewSpecTimes,
        spec_update_time = Now,
        dirty = 1
    },
    lib_dict:put(?PROC_STATUS_YUANLI, NewYuanliSt),
    NewPlayer1 = player_util:count_player_attribute(NewPlayer, true),
    NewPlayer1.

%%原力突破
do_yuanli_tupo(Player, BaseTupo) ->
    #base_yuanli_tupo{
        lv = Lv,
        pro = Pro,
        cost_num = CostNum
    } = BaseTupo,
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    HaveCount = goods_util:get_goods_count(?TUPO_COST_GOODS_ID),
    BuyNum = max(0, CostNum - HaveCount),
    case BuyNum > 0 of
        true ->
            DelNum = HaveCount,
            {ok, Type, Price} = new_shop:get_goods_price(?TUPO_COST_GOODS_ID),
            Cost = Price * BuyNum,
            Player2 =
                money:cost_money(Player, Type, Cost, 130, ?TUPO_COST_GOODS_ID, BuyNum);
        false ->
            DelNum = CostNum,
            Player2 = Player
    end,
    %%先扣除物品
    DelRes =
        case DelNum > 0 of
            true ->
                case goods:subtract_good(Player, [{?TUPO_COST_GOODS_ID, DelNum}], 130) of
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
                    NewYuanliSt = YuanliSt#st_yuanli{
                        tupo_lv = Lv
                    },
                    lib_dict:put(?PROC_STATUS_YUANLI, NewYuanliSt),
                    yuanli_load:dbup_yuanli_info(NewYuanliSt),
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
            NewPlayer = money:add_gold(Player, -CostGold, 131, 0, 0),
            YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
            NewYuanliSt = YuanliSt#st_yuanli{
                cd_time = 0
            },
            lib_dict:put(?PROC_STATUS_YUANLI, NewYuanliSt),
            yuanli_load:dbup_yuanli_info(NewYuanliSt),
            {ok, NewPlayer}
    end.
check_clear_cd(Player) ->
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    #st_yuanli{
        cd_time = CdTime
    } = YuanliSt,
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
get_yuanli_attr() ->
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    #st_yuanli{
        dict = Dict,
        tupo_lv = TupoLv
    } = YuanliSt,
    %%原力升级属性
    F = fun(Id) ->
        case dict:find(Id, Dict) of
            error -> #attribute{};
            {ok, Yuanli} ->
                Base = data_yuanli:get(Id, Yuanli#yuanli.lv),
                Base#base_yuanli.attrs
        end
        end,
    Attrs1 = attribute_util:sum_attribute(lists:map(F, lists:seq(1, 6))),
    %%原力突破属性
    Attrs2 = calc_tupo_attr(TupoLv),
    attribute_util:sum_attribute([Attrs1, Attrs2]).

%%获取突破属性
calc_tupo_attr(TupoLv) ->
    %%原力突破属性
    case data_yuanli_tupo:get(TupoLv) of
        [] -> #attribute{};
        Base ->
            #base_yuanli_tupo{
                attrs = Attrs
            } = Base,
            Attrs
    end.

%%获取可突破等级 返回0代表现在不可突破
get_can_tupo_lv() ->
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    #st_yuanli{
        dict = Dict,
        tupo_lv = TupoLv
    } = YuanliSt,
    F = fun({_Key, Yuanli}) ->
        Yuanli#yuanli.lv
        end,
    LvList = lists:map(F, dict:to_list(Dict)),
    Len = length(LvList),
    SumLv = lists:sum(LvList),
    if
        Len < ?YUANLI_NUM -> 0;
        SumLv rem ?YUANLI_NUM =/= 0 -> 0;
        true ->
            MinLv = lists:min(LvList),
            if
                MinLv =< TupoLv -> 0;
                true ->
                    get_can_tupo_lv_helper(data_yuanli_tupo:get_all(), TupoLv, MinLv)
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
get_next_up_yuanli() ->
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    #st_yuanli{
        dict = Dict
    } = YuanliSt,
    F = fun({_Key, Yuanli}) ->
        Yuanli#yuanli.lv
        end,
    LvList = lists:map(F, dict:to_list(Dict)),
    Len = length(LvList),
    case Len < ?YUANLI_NUM of
        true -> {Len + 1, 1};  %%第一次
        false ->
            SumLv = lists:sum(LvList),
            case SumLv rem ?YUANLI_NUM == 0 of
                true ->
                    FirLv = hd(LvList),
                    case data_yuanli:get(1, FirLv + 1) of
                        [] -> {1, FirLv};  %%满级
                        _Base -> {1, FirLv + 1}
                    end;
                false ->
                    case get_next_up_yuanli_helper(lists:seq(1, ?YUANLI_NUM), Dict, {0, 0}) of
                        false -> ?ERR("yuanli get next up lv err ~p~n", [dict:to_list(Dict)]), {1, 1};
                        {Id, Lv} -> {Id, Lv}
                    end
            end
    end.
get_next_up_yuanli_helper([], _Dict, _) -> false;
get_next_up_yuanli_helper([Id | Tail], Dict, {NextId, NextLv}) ->
    {ok, Yuanli} = dict:find(Id, Dict),
    #yuanli{id = YId, lv = YLv} = Yuanli,
    case NextId == 0 of
        true ->
            get_next_up_yuanli_helper(Tail, Dict, {YId, YLv});
        false ->
            case YLv < NextLv of
                true -> {YId, YLv + 1};
                false -> get_next_up_yuanli_helper(Tail, Dict, {YId, YLv})
            end
    end.

get_clear_cost(_LeaveTime) ->
    10.


%%获取原力总等级
get_yuanli_lv_total() ->
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    F = fun({_, Yuanli}) -> Yuanli#yuanli.lv
        end,
    lists:sum(lists:map(F, dict:to_list(YuanliSt#st_yuanli.dict))).

timer_update() ->
    YuanliSt = lib_dict:get(?PROC_STATUS_YUANLI),
    #st_yuanli{
        dirty = Dirty
    } = YuanliSt,
    case Dirty == 1 of
        true ->
            yuanli_load:dbup_yuanli_info(YuanliSt),
            NewYuanliSt = YuanliSt#st_yuanli{
                dirty = 0
            },
            lib_dict:put(?PROC_STATUS_YUANLI, NewYuanliSt);
        false ->
            skip
    end.