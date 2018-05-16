%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 五月 2016 下午3:31
%%%-------------------------------------------------------------------
-module(star_luck).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("star_luck.hrl").
-include("goods.hrl").

%%协议接口
-export([
    get_star_luck_info/1,
    put_on_star_luck/3,
    lock_star_luck/2,
    one_key_compos/2,
    player_tunshi/3,
    get_zx_info/1,
    player_zx/3,
    pickup/3,
    get_open_bag_cost/2,
    open_bag/2

]).


%% API
-export([
    get_dict/0,
    put_dict/1,
    add_xingyun_by_goods/2,
    pack_star/2,
    get_star_luck_attr/0,
    is_star_luck/1,
    get_free_bag_num/0
]).

-define(POS_LIST, lists:seq(1, 8)).
-define(INIT_BAG_NUM, 8).
-define(MAX_ZX_NUM, 16).
-define(MAX_FREE_TIME, 5).
-define(MAX_ZX_TYPE, 5). %%最高级占星类型
-define(EXP_GOODS_ID, 46044).  %%经验星运
-define(FIRST_GET_STAR_LUCK, [46007, 46001]).  %%第一次占星必得星运

get_star_luck_info(Player) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict,
        open_bag_num = OpenBagNum
    } = StStarLuck,
    %%身上的星运
    F = fun(Pos) ->
        BaseLvOpen = data_star_luck_lv_open:get(Pos),
        #base_star_lv_open{
            lv = NeedLv
        } = BaseLvOpen,
        State =
            case NeedLv > Player#player.lv of
                true -> 1;
                false ->
                    case get_player_star_luck_by_pos(Pos, Dict) of
                        [] -> 0;
                        _Star -> 2
                    end
            end,
        [Pos, State, NeedLv]
        end,
    PlayerInfoList = lists:map(F, ?POS_LIST),
    F1 = fun(Pos, {PStarList, AccAttrsList}) ->
        case get_player_star_luck_by_pos(Pos, Dict) of
            [] -> {PStarList, AccAttrsList};
            Star ->
                PackInfo = pack_star(Player, Star),
                Base = data_star_luck:get(Star#star.goods_id, Star#star.lv),
                {PStarList ++ [[Star#star.pos, PackInfo]], AccAttrsList ++ Base#base_star_luck.attrs}
        end
         end,
    {PutonList, SumAttrsList} = lists:foldl(F1, {[], []}, ?POS_LIST),
    SumAttrs = attribute_util:make_attribute_by_key_val_list(SumAttrsList),
    PackSumAttrs = attribute_util:pack_attr(SumAttrs),
    Combatpower = attribute_util:calc_combat_power(SumAttrs),
    %%背包星运物品
    OpenNum = ?INIT_BAG_NUM + OpenBagNum,
    BagList = get_bag_star_luck(Dict),
    BagList1 = sort_star_luck(BagList),
    F2 = fun(Star) ->
        pack_star(Player, Star)
         end,
    BagStarList = lists:map(F2, BagList1),
    Info = {PlayerInfoList, PutonList, PackSumAttrs, Combatpower, OpenNum, BagStarList},
    {ok, Bin} = pt_384:write(38401, Info),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%穿戴星运
put_on_star_luck(Player, Pos, GKey) ->
    case check_put_on_star_luck(Player, Pos, GKey) of
        {false, Res} ->
            {false, Res};
        {ok, Star} ->
            case Star#star.pos > 0 of
                true -> %%卸下
                    NewStar = Star#star{
                        location = 2,
                        pos = 0
                    },
                    update_star_luck(Player, NewStar),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    {ok, NewPlayer};
                false -> %%佩戴
                    %%已佩戴相同类型，替换掉
                    StStarLuck = get_dict(),
                    #st_star_luck{
                        dict = Dict
                    } = StStarLuck,
                    BaseGoods = data_goods:get(Star#star.goods_id),
                    PutonList = get_player_star_luck(Dict),
                    F = fun(S) ->
                        BaseG = data_goods:get(S#star.goods_id),
                        case BaseGoods#goods_type.subtype == BaseG#goods_type.subtype of
                            true ->
                                NewStar = S#star{
                                    location = 2,
                                    pos = 0
                                },
                                update_star_luck(Player, NewStar);
                            false ->
                                skip
                        end
                        end,
                    lists:foreach(F, PutonList),

                    %%穿上新物品
                    NewStar = Star#star{
                        location = 1,
                        pos = Pos
                    },
                    update_star_luck(Player, NewStar),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    {ok, NewPlayer}
            end
    end.
check_put_on_star_luck(Player, Pos, GKey) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict
    } = StStarLuck,
    case get_star_luck_by_key(GKey, Dict) of
        [] -> {false, 0};
        Star ->
            PosStar = get_player_star_luck_by_pos(Pos, Dict),
            IsExpStarLuck = is_exp_star_luck(Star),
            if
                IsExpStarLuck -> {false, 15};
                Pos =< 0 orelse Pos > 8 -> {false, 0};
                Star#star.pos > 0 andalso Star#star.pos =/= Pos -> {false, 3};
                Star#star.pos == 0 andalso Star#star.location =/= 2 -> {false, 6};
                true ->
                    case Star#star.pos > 0 of
                        true -> %%卸下
                            FreeBagNum = get_free_bag_num(),
                            if
                                FreeBagNum =< 0 -> {false, 5};
                                true -> {ok, Star}
                            end;
                        false -> %%佩戴
                            Res =
                                case PosStar =/= [] of
                                    true ->  %%是否替换
                                        BaseG = data_goods:get(PosStar#star.goods_id),
                                        BaseG1 = data_goods:get(Star#star.goods_id),
                                        BaseG#goods_type.subtype == BaseG1#goods_type.subtype;
                                    false ->
                                        true
                                end,
                            if
                                not Res -> {false, 4};
                                true ->
                                    BaseLvOpen = data_star_luck_lv_open:get(Pos),
                                    #base_star_lv_open{
                                        lv = NeedLv
                                    } = BaseLvOpen,
                                    if
                                        NeedLv > Player#player.lv -> {false, 7};
                                        true ->
                                            {ok, Star}
                                    end
                            end
                    end
            end
    end.

%%锁定/解锁
lock_star_luck(Player, GKey) ->
    case check_lock_star_luck(Player, GKey) of
        {false, Res} ->
            {false, Res};
        {ok, Star} ->
            Lock = ?IF_ELSE(Star#star.lock == 1, 0, 1),
            NewStar = Star#star{lock = Lock},
            update_star_luck(Player, NewStar),
            ok
    end.
check_lock_star_luck(_Player, GKey) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict
    } = StStarLuck,
    case get_star_luck_by_key(GKey, Dict) of
        [] -> {false, 2};
        Star -> {ok, Star}
    end.

sort_star_luck(StarList) ->
    %%根据颜色、等级排序
    F = fun(S1, S2) ->
        Base1 = data_goods:get(S1#star.goods_id),
        Base2 = data_goods:get(S2#star.goods_id),
        case Base1#goods_type.color == Base2#goods_type.color of
            true -> S1#star.lv > S2#star.lv;
            false -> Base1#goods_type.color > Base2#goods_type.color
        end
        end,
    lists:sort(F, StarList).

%%一键合成
one_key_compos(Player, Type) ->
    case check_one_key_compos(Player, Type) of
        {false, Res} ->
            {false, Res};
        {ok, NorList, ExpList, MaxLvList} ->
            StarList2 = sort_star_luck(NorList),
            Star = hd(StarList2),
            %%不同颜色的满级星运也会被合成
            BaseGoods = data_goods:get(Star#star.goods_id),
            F2 = fun(S) ->
                Base = data_goods:get(S#star.goods_id),
                Base#goods_type.color < BaseGoods#goods_type.color
                 end,
            MaxLvList1 = [S || S <- MaxLvList, F2(S)],
            DelStarList0 = lists:keydelete(Star#star.key, #star.key, StarList2 ++ ExpList ++ MaxLvList1),
            %%去掉橙色的星运
            F3 = fun(S) ->
                Base = data_goods:get(S#star.goods_id),
                Base#goods_type.color < 4
                 end,
            DelStarList = [S || S <- DelStarList0, F3(S)],
            tunshi(Player, Star, DelStarList, 1),
            StStarLuck = get_dict(),
            #st_star_luck{
                dict = Dict
            } = StStarLuck,
            NewStar = get_star_luck_by_key(Star#star.key, Dict),
            {ok, NewStar}

    end.
check_one_key_compos(_Player, Type) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict
    } = StStarLuck,
    L =
        case Type of
            1 -> get_bag_star_luck(Dict);
            _ -> get_zx_star_luck(Dict)
        end,
    case L of
        [] -> {false, 8};
        List ->
            MaxLv = data_star_luck:get_max_lv(),
            List1 = [S || S <- List, S#star.lock == 0, S#star.lv < MaxLv],
            case List1 of
                [] -> {false, 8};
                _ ->
                    F1 = fun(S, {AccNorList, AccExpList}) ->
                        IsExpStarLuck = is_exp_star_luck(S),
                        case IsExpStarLuck of
                            true -> {AccNorList, [S | AccExpList]};
                            false -> {[S | AccNorList], AccExpList}
                        end
                         end,
                    {NorList, ExpList} = lists:foldl(F1, {[], []}, List1),
                    case NorList of
                        [] -> {false, 8};
                        _ ->
                            MaxLvList = [S || S <- List, S#star.lock == 0, S#star.lv == MaxLv],
                            {ok, NorList, ExpList, MaxLvList}
                    end
            end
    end.

player_tunshi(Player, StarKey, DelKeyList) ->
    case check_player_tunshi(Player, StarKey, DelKeyList) of
        {false, Res} ->
            {false, Res};
        {ok, Star, DelList} ->
            tunshi(Player, Star, DelList, 2),
            NewPlayer =
                case Star#star.location == 1 of
                    true -> player_util:count_player_attribute(Player, true);
                    false -> Player
                end,
            StStarLuck = get_dict(),
            #st_star_luck{
                dict = Dict
            } = StStarLuck,
            NewStar = get_star_luck_by_key(Star#star.key, Dict),
            {ok, NewPlayer, NewStar}
    end.
check_player_tunshi(_Player, StarKey, DelKeyList) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict
    } = StStarLuck,
    Star = get_star_luck_by_key(StarKey, Dict),
    if
        Star == [] -> {false, 2};
        true ->
            MaxLv = data_star_luck:get_max_lv(),
            IsExpStarLuck = is_exp_star_luck(Star),
            if
                IsExpStarLuck -> {false, 15};
                Star#star.lv >= MaxLv -> {false, 19};
                true ->
                    case check_player_tunshi_1(Dict, DelKeyList, []) of
                        {false, Res} -> {false, Res};
                        {ok, List} ->
                            {ok, Star, List}
                    end
            end
    end.
check_player_tunshi_1(_Dict, [], AccList) -> {ok, AccList};
check_player_tunshi_1(Dict, [Key | Tail], AccList) ->
    case lists:keyfind(Key, #star.key, AccList) of
        false ->
            case get_star_luck_by_key(Key, Dict) of
                [] -> {false, 13};
                Star -> check_player_tunshi_1(Dict, Tail, AccList ++ [Star])
            end;
        _ ->
            {false, 0}
    end.

%%吞噬 Type:1合成 2吞噬
tunshi(Player, Star, DelStarList, Type) ->
    tunshi_helper(Player, Star#star.key, DelStarList, Type),
    ok.
tunshi_helper(_Player, _Key, [], _Type) -> ok;
tunshi_helper(Player, Key, [Star | Tail], Type) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict
    } = StStarLuck,
    case get_star_luck_by_key(Key, Dict) of
        [] ->
            ok;
        S ->
            %%是否吞噬的星运确实存在
            DelS = get_star_luck_by_key(Star#star.key, Dict),
            MaxLv = data_star_luck:get_max_lv(),
            if
                S#star.lv >= MaxLv -> ok;
                DelS == [] -> tunshi_helper(Player, Key, Tail, Type);
                true ->
                    AddExp = get_star_luck_exp(Star),
                    NewS = add_exp(AddExp, S),
                    update_star_luck(Player, NewS),
                    del_star_luck(Player, Star),
                    log_star_luck(Player, NewS, DelS, Type),
                    tunshi_helper(Player, Key, Tail, Type)
            end
    end.

add_exp(0, Star) -> Star;
add_exp(AddExp, S) ->
    NewExp = AddExp + S#star.exp,
    case data_star_luck:get(S#star.goods_id, S#star.lv) of
        [] -> %%满级
            S#star{exp = NewExp};
        Base ->
            case NewExp >= Base#base_star_luck.exp of
                true -> %%升级
                    case data_star_luck:get(S#star.goods_id, S#star.lv + 1) of
                        [] -> %%满级了
                            S#star{exp = NewExp};
                        _ ->
                            NewS = S#star{
                                lv = S#star.lv + 1,
                                exp = 0
                            },
                            add_exp(NewExp - Base#base_star_luck.exp, NewS)
                    end;
                false -> %%不升级
                    S#star{exp = NewExp}
            end
    end.

%%获取占星信息
get_zx_info(Player) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict,
        star_pos = ZXStarPos,
        free_times = FreeTimes,
        zx_double_times = ZXDoubleTimes
    } = StStarLuck,
    MyPoint = Player#player.xingyun_pt,
    LeaveFreeTimes = ?MAX_FREE_TIME - FreeTimes,
    Base = data_star_luck_cost:get(0),
    #base_star_luck_cost{
        cost_gold = CostGold
    } = Base,
    F = fun(ZXPos) ->
        Basezx = data_star_luck_cost:get(ZXPos),
        #base_star_luck_cost{
            cost_bgold = CostBGold,
            cost_coin = CostCoin
        } = Basezx,
        [ZXPos, CostBGold, CostCoin]
        end,
    ZXTypeList = lists:map(F, ZXStarPos),
    XingyunList0 = get_zx_star_luck(Dict),
    XingyunList = lists:keysort(#star.create_time, XingyunList0),
    XingyunList1 = [pack_star(Player, Star) || Star <- XingyunList],
    VipLv = Player#player.vip_lv,
    NeedVip = get_zx_one_key_need_vip(),
    MaxTimes = get_zx_double_max_times(Player),
    LeaveTimes = max(0, MaxTimes - ZXDoubleTimes),
    Info = {MyPoint, LeaveFreeTimes, ?MAX_FREE_TIME, CostGold, VipLv, NeedVip, LeaveTimes, MaxTimes, ZXTypeList, XingyunList1},
    {ok, Bin} = pt_384:write(38408, Info),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%占星
player_zx(Player, Opt, Type) ->
    case check_player_zx(Player, Opt, Type) of
        {false, Res} ->
            {false, Res};
        {ok, CostGold, CostBGold, CostCoin} ->
            InitStStarLuck = get_dict(),
            #st_star_luck{
                star_pos = ZXStarPos,
                zx_double_times = DoubleTimes,
                free_times = FreeTimes,
                dict = Dict
            } = InitStStarLuck,
            case Opt of
                2 -> %%元宝占星
                    NewPlayer = money:add_no_bind_gold(Player, -CostGold, 156, 0, 0),
                    %%必得经验星运
                    StarList = [init_star(Player, ?EXP_GOODS_ID, 3)],
                    NewStStarLuck = InitStStarLuck#st_star_luck{
                        star_pos = [?MAX_ZX_TYPE | lists:delete(?MAX_ZX_TYPE, ZXStarPos)]
                    },
                    put_dict(NewStStarLuck),
                    star_luck_load:dbup_star_luck_info(NewStStarLuck),
                    [add_xingyun(Player, Star) || Star <- StarList],
                    [log_star_luck(Player, Star, #star{}, 3) || Star <- StarList],
                    {ok, NewPlayer, [pack_star(Player, Star) || Star <- StarList]};
                1 -> %%普通占星
                    %%是否双倍
                    MaxDoubleTimes = get_zx_double_max_times(Player),
                    GetNum = ?IF_ELSE(DoubleTimes < MaxDoubleTimes, 2, 1),
                    NewDoubleTimes = ?IF_ELSE(GetNum > 1, DoubleTimes + 1, DoubleTimes),
                    NewPlayer0 =
                        case CostBGold > 0 of
                            true -> money:add_gold(Player, -CostBGold, 157, 0, 0);
                            false -> Player
                        end,
                    NewPlayer =
                        case CostCoin > 0 of
                            true -> money:add_coin(NewPlayer0, -CostCoin, 157, 0, 0);
                            false -> NewPlayer0
                        end,
                    StarList =
                        case dict:size(Dict) == 0 of
                            true ->  %%第一次占星，固定获得物品
                                GetList = lists:sublist(?FIRST_GET_STAR_LUCK, GetNum),
                                [init_star(Player, GoodsId, 3) || GoodsId <- GetList];
                            false ->
                                Base = data_star_luck_pro:get(Type),
                                #base_star_luck_pro{
                                    goods_list = GoodsList
                                } = Base,
                                GoodsId = util:list_rand_ratio(GoodsList),
                                _BaseGoods = data_goods:get(GoodsId),
%%                                 case BaseGoods#goods_type.color >= 4 andalso BaseGoods#goods_type.subtype =/= ?GOODS_SUBTYPE_STAR_LUCK_9 of
%%                                     true ->
%%                                         notice_sys:add_notice(star_luck, [Player, BaseGoods]);
%%                                     false ->
%%                                         skip
%%                                 end,
                                [init_star(Player, GoodsId, 3) || _N <- lists:seq(1, GetNum)]
                        end,
                    [add_xingyun(Player, Star) || Star <- StarList],
                    StStarLuck = get_dict(),
                    %%进阶
                    NewFreeTimes = ?IF_ELSE(CostBGold > 0, FreeTimes, FreeTimes + 1),
                    NextZXPos = Type + 1,
                    NextIsAct = lists:member(NextZXPos, ZXStarPos),  %%下一占星类型
                    NewZXStarPos =
                        case Type == 1 of
                            true -> ZXStarPos;
                            false -> lists:delete(Type, ZXStarPos)
                        end,
                    BaseCost = data_star_luck_cost:get(Type),
                    #base_star_luck_cost{
                        pro = Pro,
                        pt = Pt
                    } = BaseCost,
                    NewStStarLuck =
                        case NextIsAct == false andalso NextZXPos =< ?MAX_ZX_TYPE of
                            true -> %%激活下一个占星类型
                                Rand = util:rand(1, 10000),
                                NewZXStarPos1 =
                                    case Rand =< Pro of
                                        true -> NewZXStarPos ++ [NextZXPos];
                                        false -> NewZXStarPos
                                    end,
                                StStarLuck#st_star_luck{
                                    star_pos = NewZXStarPos1,
                                    free_times = NewFreeTimes,
                                    zx_double_times = NewDoubleTimes
                                };
                            false ->
                                StStarLuck#st_star_luck{
                                    star_pos = NewZXStarPos,
                                    free_times = NewFreeTimes,
                                    zx_double_times = NewDoubleTimes
                                }
                        end,
                    put_dict(NewStStarLuck),
                    star_luck_load:dbup_star_luck_info(NewStStarLuck),
                    NewPlayer1 = money:add_xingyun_pt(NewPlayer, Pt),
                    [log_star_luck(Player, Star, #star{}, 3) || Star <- StarList],
                    target_act:trigger_tar_act(Player, 10, CostBGold),
                    ?IF_ELSE(Type == ?MAX_ZX_TYPE, target_act:trigger_tar_act(Player, 11, 1), ok),
                    {ok, NewPlayer1, [pack_star(NewPlayer1, Star) || Star <- StarList]};
                _ -> %%一键占星
                    do_one_key_zx(Player)
            end
    end.
do_one_key_zx(Player) ->
    {NewPlayer, StarList} = do_one_key_zx_1(Player, []),
    {ok, NewPlayer, StarList}.
do_one_key_zx_1(Player, AccStarList) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        star_pos = ZXStarPos
    } = StStarLuck,
    MaxPos = lists:max(ZXStarPos),
    case player_zx(Player, 1, MaxPos) of
        {false, _Res} ->
            {Player, AccStarList};
        {ok, NewPlayer, StarList} ->
            do_one_key_zx_1(NewPlayer, AccStarList ++ StarList)
    end.
check_player_zx(Player, Opt, Type) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict,
        star_pos = ZXStarPos,
        zx_double_times = DoubleTimes,
        free_times = FreeTimes
    } = StStarLuck,
    LeaveFreeTimes = ?MAX_FREE_TIME - FreeTimes,
    ZXGoodsList = get_zx_star_luck(Dict),
    ZXNum = length(ZXGoodsList),
    MaxDoubleTimes = get_zx_double_max_times(Player),
    GetNum = ?IF_ELSE(DoubleTimes < MaxDoubleTimes, 2, 1),
    case Opt of
        2 -> %%元宝占星
            Base = data_star_luck_cost:get(0),
            #base_star_luck_cost{cost_gold = CostGold} = Base,
            IsEnough = money:is_enough(Player, CostGold, gold),
            if
                not IsEnough -> {false, 9};
                ZXNum >= ?MAX_ZX_NUM -> {false, 10};
                true ->
                    {ok, CostGold, 0, 0}
            end;
        1 -> %%普通占星
            IsMember = lists:member(Type, ZXStarPos),
            if
                ZXNum >= ?MAX_ZX_NUM -> {false, 10};
                ZXNum + GetNum > ?MAX_ZX_NUM -> {false, 20};
                not IsMember -> {false, 11};
                true ->
                    Base = data_star_luck_cost:get(Type),
                    case LeaveFreeTimes > 0 of
                        true ->
                            {ok, 0, 0, 0};
                        false ->
                            #base_star_luck_cost{
                                cost_bgold = CostBGold,
                                cost_coin = CostCoin
                            } = Base,
                            IsEnough = ?IF_ELSE(CostBGold > 0, money:is_enough(Player, CostBGold, bgold), true),
                            IsCoinEnough = ?IF_ELSE(CostCoin > 0, money:is_enough(Player, CostCoin, coin), true),
                            if
                                not IsEnough -> {false, 9};
                                not IsCoinEnough -> {false, 16};
                                true ->
                                    {ok, 0, CostBGold, CostCoin}
                            end
                    end
            end;
        _ -> %%一键占星
            NeedVip = get_zx_one_key_need_vip(),
            MaxType = lists:max(ZXStarPos),
            Base = data_star_luck_cost:get(MaxType),
            #base_star_luck_cost{
                cost_bgold = CostBGold,
                cost_coin = CostCoin
            } = Base,
            IsEnough = ?IF_ELSE(CostBGold > 0, money:is_enough(Player, CostBGold, bgold), true),
            IsCoinEnough = ?IF_ELSE(CostCoin > 0, money:is_enough(Player, CostCoin, coin), true),
            if
                not IsEnough -> {false, 9};
                not IsCoinEnough -> {false, 16};
                ZXNum >= ?MAX_ZX_NUM -> {false, 10};
                ZXNum + GetNum > ?MAX_ZX_NUM -> {false, 20};
                NeedVip > Player#player.vip_lv -> {false, 18};
                true ->
                    {ok, 0, 0, 0}
            end
    end.

%%拾取
pickup(Player, Opt, GKey) ->
    case check_pickup(Player, Opt, GKey) of
        {false, Res} ->
            {false, Res};
        {ok, Star} ->
            case Opt of
                1 ->
                    NewStar = Star#star{
                        location = 2
                    },
                    update_star_luck(Player, NewStar),
                    {ok, [pack_star(Player, Star)]};
                _ ->
                    {ok, PickupList} = do_one_key_pickup(Player, []),
                    {ok, PickupList}
            end
    end.
do_one_key_pickup(Player, AccList) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict
    } = StStarLuck,
    ZXList = get_zx_star_luck(Dict),
    case ZXList == [] of
        true -> {ok, AccList};
        false ->
            Star = hd(ZXList),
            case pickup(Player, 1, Star#star.key) of
                {false, _Res} ->
                    {ok, AccList};
                {ok, GetList} ->
                    do_one_key_pickup(Player, AccList ++ GetList)
            end
    end.

check_pickup(_Player, Opt, GKey) ->
    FreeBagNum = get_free_bag_num(),
    if
        FreeBagNum =< 0 -> {false, 5};
        true ->
            StStarLuck = get_dict(),
            #st_star_luck{
                dict = Dict
            } = StStarLuck,
            case Opt of
                1 ->
                    case get_star_luck_by_key(GKey, Dict) of
                        [] -> {false, 2};
                        Star -> {ok, Star}
                    end;
                _ ->
                    ZXList = get_zx_star_luck(Dict),
                    case ZXList == [] of
                        true -> {false, 12};
                        false -> {ok, ""}
                    end
            end
    end.

get_open_bag_cost(Player, Num) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        open_bag_num = OpenBagNum
    } = StStarLuck,
    F = fun(OpneNum) ->
        case data_star_luck_bag_open:get(OpneNum) of
            [] -> 9999999;
            Base -> Base#base_star_bag_open.cost_gold
        end
        end,
    Cost = lists:sum(lists:map(F, lists:seq(OpenBagNum + 1, OpenBagNum + Num))),
    {ok, Bin} = pt_384:write(38406, {Cost, Num}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

open_bag(Player, Num) ->
    case check_open_bag(Player, Num) of
        {false, Res} ->
            {false, Res};
        {ok, Cost} ->
            NewPlayer = money:add_gold(Player, -Cost, 159, 0, 0),
            StStarLuck = get_dict(),
            NewStStarLuck = StStarLuck#st_star_luck{
                open_bag_num = Num + StStarLuck#st_star_luck.open_bag_num
            },
            put_dict(NewStStarLuck),
            star_luck_load:dbup_star_luck_info(NewStStarLuck),
            {ok, NewPlayer}
    end.
check_open_bag(Player, Num) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        open_bag_num = OpenBagNum
    } = StStarLuck,
    if
        Num =< 0 -> {false, 0};
        true ->
            case check_open_bag_1(OpenBagNum, Num, 0) of
                false -> {false, 0};
                CostGold ->
                    IsEnough = money:is_enough(Player, CostGold, bgold),
                    if
                        not IsEnough -> {false, 9};
                        true -> {ok, CostGold}
                    end
            end
    end.
check_open_bag_1(_OpenBagNum, 0, AccCost) -> AccCost;
check_open_bag_1(OpenBagNum, Num, AccCost) ->
    case data_star_luck_bag_open:get(OpenBagNum + 1) of
        [] -> false;
        Base ->
            check_open_bag_1(OpenBagNum + 1, Num - 1, AccCost + Base#base_star_bag_open.cost_gold)
    end.

get_star_luck_exp(Star) ->
    Star#star.exp + get_star_luck_exp(Star#star.goods_id, Star#star.lv, 0).
get_star_luck_exp(_StarId, 0, AccExp) -> AccExp;
get_star_luck_exp(_StarId, 1, AccExp) -> AccExp;
get_star_luck_exp(StarId, Lv, AccExp) ->
    case data_star_luck:get(StarId, Lv - 1) of
        [] ->
            get_star_luck_exp(StarId, Lv - 1, AccExp);
        Base ->
            get_star_luck_exp(StarId, Lv - 1, AccExp + Base#base_star_luck.exp)
    end.

%%获取背包空格子数
get_free_bag_num() ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict,
        open_bag_num = OpenBagNum
    } = StStarLuck,
    List = get_bag_star_luck(Dict),
    max(0, OpenBagNum + ?INIT_BAG_NUM - length(List)).

pack_star(Player, Star) ->
    MaxLv = data_star_luck:get_max_lv(),
    #player{key = Pkey} = Player,
    #star{
        key = GKey,
        goods_id = GoodsId,
        lv = Lv,
        exp = Exp,
        lock = IsLock
    } = Star,
    Base = data_star_luck:get(GoodsId, Lv),
    case Base of
        [] ->
            ?ERR("######star_luck unknow err GoodsId, Lv ~p~n", [{GoodsId, Lv}]),
            MaxExp = 10000, Attrs = [];
        _ ->
            #base_star_luck{
                exp = MaxExp,
                attrs = Attrs
            } = Base
    end,
    Cbp = attribute_util:calc_combat_power(attribute_util:make_attribute_by_key_val_list(Attrs)),
    Attrs1 = attribute_util:pack_attr(Attrs),
    NextAttrs1 =
        case Lv >= MaxLv of
            true -> Attrs1;
            false ->
                NextBase = data_star_luck:get(GoodsId, Lv + 1),
                case NextBase of
                    [] -> Attrs1;
                    _ ->

                        #base_star_luck{
                            attrs = NextAttrs
                        } = NextBase,
                        attribute_util:pack_attr(NextAttrs)
                end
        end,
    [GKey, Pkey, GoodsId, Lv, Exp, MaxExp, IsLock, Cbp, Attrs1, NextAttrs1].

get_dict() ->
    lib_dict:get(?PROC_STATUS_STAR_LUCK).

put_dict(StStarLuck) ->
    lib_dict:put(?PROC_STATUS_STAR_LUCK, StStarLuck).

%%获取玩家已佩戴的星运
get_player_star_luck(Dict) ->
    List = dict:to_list(Dict),
    [S || {_Key, S} <- List, S#star.location == 1].

%%获取星运背包的星运
get_bag_star_luck(Dict) ->
    List = dict:to_list(Dict),
    [S || {_Key, S} <- List, S#star.location == 2].

%%获取占星的星运
get_zx_star_luck(Dict) ->
    List = dict:to_list(Dict),
    [S || {_Key, S} <- List, S#star.location == 3].

%%根据佩戴位置获取星运
get_player_star_luck_by_pos(Pos, Dict) ->
    List = get_player_star_luck(Dict),
    case [S || S <- List, S#star.pos == Pos] of
        [] -> [];
        [Star | _] -> Star
    end.

%%根据星运key获取星运
get_star_luck_by_key(Key, Dict) ->
    case dict:find(Key, Dict) of
        error -> [];
        {_, Star} -> Star
    end.

%%更新星运
update_star_luck(Player, Star) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict
    } = StStarLuck,
    NewDict = dict:store(Star#star.key, Star, Dict),
    NewStStarLuck = StStarLuck#st_star_luck{dict = NewDict},
    star_luck_load:dbup_star_luck_goods(Player, Star),
    put_dict(NewStStarLuck),
    NewStStarLuck.

%%删除星运
del_star_luck(Player, Star) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict
    } = StStarLuck,
    NewDict = dict:erase(Star#star.key, Dict),
    NewStStarLuck = StStarLuck#st_star_luck{dict = NewDict},
    star_luck_load:dbdel_star_luck_goods(Player, Star),
    put_dict(NewStStarLuck),
    NewStStarLuck.

add_xingyun_by_goods(Player, BaseGoods) ->
    #goods_type{
        goods_id = GoodsId
    } = BaseGoods,
    case data_star_luck:get(GoodsId, 1) of
        [] -> ?ERR("star_luck can not find star_luck by goods_type ~p~n", [GoodsId]), ok;
        _Base ->
            Star = init_star(Player, GoodsId, 2),
            add_xingyun(Player, Star)
    end.

add_xingyun(Player, Star) ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict
    } = StStarLuck,
    NewDict = dict:store(Star#star.key, Star, Dict),
    NewStStarLuck = StStarLuck#st_star_luck{dict = NewDict},
    star_luck_load:dbup_star_luck_goods(Player, Star),
    put_dict(NewStStarLuck).

init_star(_Player, GoodsId, Location) ->
    Base = data_star_luck:get(GoodsId, 1),
    #base_star_luck{
        init_exp = InitExp
    } = Base,
    Key = misc:unique_key(),
    Now = util:unixtime(),
    Star = #star{
        key = Key,
        goods_id = GoodsId,
        lv = 1,
        exp = InitExp,
        location = Location,
        pos = 0,
        lock = 0,
        create_time = Now
    },
    Star.

is_exp_star_luck(S) ->
    BaseGoods = data_goods:get(S#star.goods_id),
    BaseGoods#goods_type.subtype == ?GOODS_SUBTYPE_STAR_LUCK_9.

get_star_luck_attr() ->
    StStarLuck = get_dict(),
    #st_star_luck{
        dict = Dict
    } = StStarLuck,
    StarLuckList = get_player_star_luck(Dict),
    F = fun(Star) ->
        #star{
            goods_id = GoodsId,
            lv = Lv
        } = Star,
        Base = data_star_luck:get(GoodsId, Lv),
        #base_star_luck{
            attrs = Attrs
        } = Base,
        attribute_util:make_attribute_by_key_val_list(Attrs)
        end,
    AttrList = lists:map(F, StarLuckList),
    attribute_util:sum_attribute(AttrList).

get_zx_double_max_times(Player) ->
    data_vip_args:get(51, Player#player.vip_lv).

get_zx_one_key_need_vip() ->
    get_zx_one_key_need_vip_1(lists:seq(1, data_vip_args:get_max_lv())).
get_zx_one_key_need_vip_1([]) -> data_vip_args:get_max_lv() + 1;
get_zx_one_key_need_vip_1([Vip | Tail]) ->
    case data_vip_args:get(50, Vip) of
        1 -> Vip;
        _ -> get_zx_one_key_need_vip_1(Tail)
    end.

log_star_luck(Player, Star, Star2, Type) ->
    #player{
        key = Pkey,
        nickname = Name
    } = Player,
    #star{
        key = Key,
        goods_id = GoodsId,
        lv = Lv,
        exp = Exp
    } = Star,
    BaseGoods = data_goods:get(GoodsId),
    #star{
        key = Key2,
        goods_id = GoodsId2,
        lv = Lv2,
        exp = Exp2
    } = Star2,
    BaseGoods2 =
        case data_goods:get(GoodsId2) of
            [] -> #goods_type{goods_name = ""};
            B -> B
        end,
    Sql = io_lib:format("insert into log_star_luck set pkey=~p,nickname='~s',star_luck_key=~p,star_luck_id=~p,star_luck_name='~s',lv=~p,exp=~p,type=~p,star_luck_key2=~p,star_luck_id2=~p,star_luck_name2='~s',lv2=~p,exp2=~p,time=~p",
        [Pkey, Name, Key, GoodsId, BaseGoods#goods_type.goods_name, Lv, Exp, Type, Key2, GoodsId2, BaseGoods2#goods_type.goods_name, Lv2, Exp2, util:unixtime()]),
    log_proc:log(Sql),
    ok.

is_star_luck(GoodsId) ->
    BaseGoods = data_goods:get(GoodsId),
    BaseGoods#goods_type.subtype >= ?GOODS_SUBTYPE_STAR_LUCK_1 andalso BaseGoods#goods_type.subtype =< ?GOODS_SUBTYPE_STAR_LUCK_9.