%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 抢购商店
%%% @end
%%% Created : 18. 二月 2016 下午2:38
%%%-------------------------------------------------------------------
-module(lim_shop).
-author("fengzhenlin").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").

%%协议接口
-export([
    get_lim_shop_info/1,
    buy_lim_shop/3
]).

%% API
-export([
    init/1,
    init_global_lim_shop/0,
    night_refresh_player/0,
    night_refresh_global/1,
    auto_del_global_buy_num/1,
    update_lim_shop/0,
    get_state/0
]).

init_global_lim_shop() ->
    LimShop = activity_load:dbget_lim_shop(),
    P = activity_proc:get_act_pid(),
    Ref = erlang:send_after(?ONE_HOUR_SECONDS, P, global_auto_del_buy_num),
    LimShop#lim_shop{auto_del_ref = Ref}.

init(Player) ->
    LimShopSt = activity_load:dbget_player_lim_shop(Player),
    lib_dict:put(?PROC_STATUS_LIM_SHOP, LimShopSt),
    Player.

%%更新玩家抢购信息
update_lim_shop() ->
    LimShopSt = lib_dict:get(?PROC_STATUS_LIM_SHOP),
    NewLimShopSt =
        case get_act_list() of
            [] -> LimShopSt;
            BaseLimShop ->
                #base_lim_shop{
                    act_id = Actid
                } = BaseLimShop,
                Now = util:unixtime(),
                case LimShopSt#st_lim_shop.act_id == Actid of
                    false ->
                        LimShopSt#st_lim_shop{
                            act_id = Actid,
                            dict = dict:new(),
                            update_time = Now
                        };
                    true ->
                        case util:is_same_date(Now, LimShopSt#st_lim_shop.update_time) of
                            true -> LimShopSt;
                            false -> night_refresh_player()
                        end
                end
        end,
    lib_dict:put(?PROC_STATUS_LIM_SHOP, NewLimShopSt).

get_lim_shop_info(Player) ->
    case get_act_list() of
        [] -> skip;
        BaseLimShop ->
            LeaveTime = get_act_leave_time(BaseLimShop#base_lim_shop.open_info),
            #base_lim_shop{
                goods_list = GoodsList
            } = BaseLimShop,
            LimShopSt = lib_dict:get(?PROC_STATUS_LIM_SHOP),
            GlobalLimShopDict = get_global_lim_shop_info(),
            F = fun(Base) ->
                #base_lim_shop_goods{
                    id = Id,
                    lim_type = LimType,
                    goods_id = GoodsId,
                    goods_num = GoodsNum,
                    max_num = MaxNum,
                    can_buy_num = CanBuyNum,
                    cost_gold = CostGold,
                    cost_bgold = CostBGold,
                    old_cost_gold = OldPirce
                } = Base,
                case LimType == 1 orelse LimType == 2 of
                    true -> GlobalMaxNum = 0, GlobalHaveBuyNum = 0;
                    false ->
                        GlobalMaxNum = MaxNum,
                        case dict:find(Id, GlobalLimShopDict) of
                            error -> GlobalHaveBuyNum = 0;
                            {ok, {_, GlobalHaveBuyNum}} -> ok
                        end
                end,
                case dict:find(Id, LimShopSt#st_lim_shop.dict) of
                    error -> HaveBuyNum = 0;
                    {ok, {_, HaveBuyNum}} -> ok
                end,
                [Id, GoodsId, GoodsNum, GlobalMaxNum, GlobalHaveBuyNum, CanBuyNum, HaveBuyNum, CostGold, CostBGold, OldPirce]
                end,
            ShopGoodsList = lists:map(F, GoodsList),
            {ok, Bin} = pt_380:write(38010, {LeaveTime, ShopGoodsList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

%%获取全服抢购商品信息 有缓存
get_global_lim_shop_info() ->
    Now = util:unixtime(),
    case get(get_global_lim_shop) of
        undefined ->
            GlobalLimShop = ?CALL(activity_proc:get_act_pid(), get_lim_shop_info),
            case GlobalLimShop == [] of
                true -> dict:new();
                false ->
                    put(get_global_lim_shop, {GlobalLimShop, Now}),
                    GlobalLimShop
            end;
        {GlobalLimShop, Time} ->
            case Now - Time > 60 of
                true ->
                    put(get_global_lim_shop, undefined),
                    get_global_lim_shop_info();
                false ->
                    GlobalLimShop
            end
    end.

%%清全服购买数量缓存
clear_global_lim_shop_info() ->
    put(get_global_lim_shop, undefined).

%%购买抢购商店物品
buy_lim_shop(Player, Id, GoodsId) ->
    case check_buy_lim_shop(Player, Id, GoodsId) of
        {false, Res} -> {false, Res};
        {ok, BaseGoods, GlobalHaveBuyNum} ->
            #base_lim_shop_goods{
                lim_type = LimType,
                goods_num = GoodsNum,
                cost_gold = CostGold,
                cost_bgold = CostBGold,
                max_num = MaxNum,
                is_sell_out = IsSellOut
            } = BaseGoods,
            %%扣元宝
            NewPlayer =
                case CostGold > 0 of
                    true -> money:add_no_bind_gold(Player, -CostGold, 124, GoodsId, GoodsNum);
                    false -> Player
                end,
            NewPlayer1 =
                case CostBGold > 0 of
                    true -> money:add_gold(NewPlayer, -CostBGold, 124, GoodsId, GoodsNum);
                    false -> NewPlayer
                end,
            %%给物品
            GiveGoodsList = goods:make_give_goods_list(124, [{GoodsId, GoodsNum}]),
            {ok, NewPlayer2} = goods:give_goods(NewPlayer1, GiveGoodsList),
            %%增加个人购买记录
            LimShopSt = lib_dict:get(?PROC_STATUS_LIM_SHOP),
            #st_lim_shop{
                dict = Dict
            } = LimShopSt,
            NewDict =
                case dict:find(Id, Dict) of
                    error ->
                        dict:store(Id, {Id, 1}, Dict);
                    {ok, {_, BuyNum}} ->
                        dict:store(Id, {Id, BuyNum + 1}, Dict)
                end,
            NewLimShopSt = LimShopSt#st_lim_shop{dict = NewDict},
            lib_dict:put(?PROC_STATUS_LIM_SHOP, NewLimShopSt),
            activity_load:dbup_player_lim_shop(NewLimShopSt),
            %%增加全服购买记录
            case LimType == 1 orelse LimType == 2 of
                true -> skip;
                false ->
                    case IsSellOut == 0 orelse MaxNum - GlobalHaveBuyNum > 5 of %%不会售罄的物品不减次数
                        true -> activity_proc:get_act_pid() ! {add_lim_shop_buy, Id, 1};
                        false -> skip
                    end
            end,
            %%清全服购买数量缓存
            clear_global_lim_shop_info(),

            case GoodsId of
%%                 22517 -> notice_sys:add_notice(lim_shop, Player);
%%                 24993 -> notice_sys:add_notice(lim_shop_1, Player);
                _ -> skip
            end,
            {ok, NewPlayer2}
    end.
check_buy_lim_shop(Player, Id, GoodsId) ->
    case get_act_list() of
        [] -> {false, 0};
        Base ->
            LimShopSt = lib_dict:get(?PROC_STATUS_LIM_SHOP),
            #st_lim_shop{
                act_id = ActId,
                dict = Dict
            } = LimShopSt,
            #base_lim_shop{
                act_id = BaseActId
            } = Base,
            if
                ActId =/= BaseActId ->
                    update_lim_shop(),
                    {false, 13};
                true ->
                    case lists:keyfind(Id, #base_lim_shop_goods.id, Base#base_lim_shop.goods_list) of
                        false -> {false, 12};
                        BaseGoods ->
                            #base_lim_shop_goods{
                                goods_id = BaseGoodsId,
                                lim_type = LimType,
                                can_buy_num = CanBuyNum,
                                max_num = MaxNum,
                                cost_gold = CostGold,
                                cost_bgold = CostBGold
                            } = BaseGoods,
                            IsEngouhGold = money:is_enough(Player, CostGold, gold),
                            IsEngouhBGold = money:is_enough(Player, CostBGold, bgold),
                            HaveBuyNum =
                                case dict:find(Id, Dict) of
                                    error -> 0;
                                    {ok, {_, HaveBuyNum0}} -> HaveBuyNum0
                                end,
                            if
                                GoodsId =/= BaseGoodsId -> {false, 0};
                                not IsEngouhGold -> {false, 15};
                                not IsEngouhBGold -> {false, 3};
                                HaveBuyNum >= CanBuyNum -> {false, 14};
                                true ->
                                    case LimType == 1 orelse LimType == 2 of
                                        true -> %%个人抢购物品
                                            {ok, BaseGoods, 0};
                                        false -> %%全服抢购物品
                                            GlobalLimShopDict = get_global_lim_shop_info(),
                                            GlobalHaveBuyNum =
                                                case dict:find(Id, GlobalLimShopDict) of
                                                    error -> 0;
                                                    {ok, {_, GlobalHaveBuyNum0}} -> GlobalHaveBuyNum0
                                                end,
                                            if
                                                GlobalHaveBuyNum >= MaxNum -> {false, 16};
                                                true ->
                                                    {ok, BaseGoods, GlobalHaveBuyNum}
                                            end
                                    end
                            end
                    end
            end
    end.

%%零点刷新玩家抢购信息
night_refresh_player() ->
    put(get_lim_shop_default_day, undefined),
    LimShopSt = lib_dict:get(?PROC_STATUS_LIM_SHOP),
    #st_lim_shop{
        act_id = ActId,
        dict = Dict
    } = LimShopSt,
    case get_act_list() of
        [] ->
            LimShopSt#st_lim_shop{
                act_id = 0,
                dict = dict:new()
            };
        Base ->
            #base_lim_shop{
                act_id = BaseActId,
                goods_list = GoodsList
            } = Base,
            Now = util:unixtime(),
            NewLimShopSt =
                case BaseActId == ActId of
                    false ->
                        LimShopSt#st_lim_shop{
                            act_id = BaseActId,
                            dict = dict:new(),
                            update_time = Now
                        };
                    true ->
                        F = fun(BaseGoods, AccDict) ->
                            #base_lim_shop_goods{
                                id = Id,
                                lim_type = LimType
                            } = BaseGoods,
                            case LimType == 1 orelse LimType == 3 of
                                true -> dict:erase(Id, AccDict);
                                false -> AccDict
                            end
                            end,
                        NewDict = lists:foldl(F, Dict, GoodsList),
                        LimShopSt#st_lim_shop{
                            dict = NewDict,
                            update_time = Now
                        }
                end,
            lib_dict:put(?PROC_STATUS_LIM_SHOP, NewLimShopSt),
            NewLimShopSt
    end.

%%零点刷新全服抢购信息
night_refresh_global(LimShop) ->
    #lim_shop{
        act_id = ActId
%%         dict = _Dict,
%%         act_day = ActDay
    } = LimShop,
    NewActDay = get_default_act_day(),
%%         case ActId >= 100 of
%%             true -> ActDay + 1;
%%             false -> ActDay
%%         end,
    case get_act_list(NewActDay) of
        [] ->
            LimShop#lim_shop{
                act_id = 0,
                dict = dict:new()
            };
        Base ->
            #base_lim_shop{
                act_id = BaseActId,
                goods_list = _GoodsList
            } = Base,
            case ActId == BaseActId of
                false -> %%新抢购活动
                    LimShop#lim_shop{
                        act_id = BaseActId,
                        act_day = NewActDay,
                        dict = dict:new()
                    };
                true -> %%还是当前活动
                    LimShop
%%                     F = fun(BaseGoods,AccDict) ->
%%                         #base_lim_shop_goods{
%%                             id = Id,
%%                             lim_type = LimType
%%                         } = BaseGoods,
%%                         case LimType == 1 orelse LimType == 3 of
%%                             true -> dict:erase(Id,AccDict);
%%                             false -> AccDict
%%                         end
%%                     end,
%%                     NewDict = lists:foldl(F,Dict,GoodsList),
%%                     LimShop#lim_shop{
%%                         dict = NewDict
%%                     }
            end
    end.

%%自动减少全服可购买次数
auto_del_global_buy_num(LimShop) ->
    #lim_shop{
        act_id = ActId,
        dict = Dict,
        act_day = ActDay
    } = LimShop,
    case ActId == 1 orelse ActId == 2 of
        true -> LimShop;
        false ->
            case get_act_list(ActDay) of
                [] -> LimShop;
                Base ->
                    #base_lim_shop{
                        goods_list = GoodsList
                    } = Base,
                    F = fun(BaseGoods, AccDict) ->
                        #base_lim_shop_goods{
                            id = Id,
                            max_num = MaxNum,
                            is_auto_del = IsAutoDel
                        } = BaseGoods,
                        case IsAutoDel == 0 of
                            true -> AccDict;
                            false ->
                                DelNum = max(1, round(MaxNum * 0.01)),
                                case dict:find(Id, AccDict) of
                                    error -> dict:store(Id, {Id, DelNum}, AccDict);
                                    {ok, {_, BuyNum}} ->
                                        case round(BuyNum / MaxNum * 100) >= 95 orelse MaxNum - BuyNum < 15 of
                                            true -> AccDict;
                                            false -> dict:store(Id, {Id, BuyNum + DelNum}, AccDict)
                                        end
                                end
                        end
                        end,
                    NewDict = lists:foldl(F, Dict, GoodsList),
                    LimShop#lim_shop{dict = NewDict}
            end
    end.

%%获取有效活动
get_act_list() ->
    DefaultActDay = get_default_act_day(),
    get_act_list(DefaultActDay).
get_act_list(DefaultActDay) ->
    %%先获取开服和全服活动
    case activity:get_work_list(data_lim_shop) of
        [] -> %%获取默认活动
            CycleDay00 = DefaultActDay rem 6,
            CycleDay0 = ?IF_ELSE(CycleDay00 == 0, 6, CycleDay00),
            CycleDay = max(1, CycleDay0),
            case data_lim_shop_default:get(CycleDay) of
                [] -> [];
                BaseLimShop -> BaseLimShop
            end;
        [BaseLimShop | _] -> BaseLimShop
    end.

get_default_act_day() ->
%%     case get(get_lim_shop_default_day) of
%%         undefined ->
%%             case lib_dict:get(?LOGIN_FINISH) of
%%                 true ->
%%                     case ?CALL(activity_proc:get_act_pid(),get_lim_shop_default_day) of
%%                         [] -> 1;
%%                         Day ->
%%                             put(get_lim_shop_default_day,Day),
%%                             Day
%%                     end;
%%                 false ->
%%                     ?ERR("can not do call in self pid~n"),
%%                     1
%%             end;
%%         Day -> Day
%%     end.
    config:get_open_days().

get_act_leave_time(OpenInfo) ->
    LeaveTime = activity:calc_act_leave_time(OpenInfo),
    case LeaveTime == 0 of
        true ->
            ?ONE_DAY_SECONDS - (util:unixtime() - util:unixdate());
        false ->
            LeaveTime
    end.

get_state() ->
    case get_act_list() of
        [] -> 0;
        Base ->
            #base_lim_shop{
                act_info = ActInfo
            } = Base,
            Args = activity:get_base_state(ActInfo),
            {0, Args}
    end.