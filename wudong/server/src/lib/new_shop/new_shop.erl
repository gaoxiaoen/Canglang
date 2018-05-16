%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 二月 2016 下午1:51
%%%-------------------------------------------------------------------
-module(new_shop).
-author("fengzhenlin").
-include("server.hrl").
-include("new_shop.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("baby.hrl").


%% API
-export([
    get_shop_info/2,
    buy_shop_goods/4
]).

-export([
    get_goods_price/1,
    check_auto_buy/3,
    auto_buy/4
]).

%%获取商店信息
get_shop_info(Player, ShopType) ->
    IdList = data_new_shop:get_by_shop_type(ShopType),
    F = fun(Id, AccList) ->
        BaseShop = data_new_shop:get(Id),
        #base_shop{
            id = Id,
            goods_id = GoodsId,
            goods_num = GoodsNum,
            cost = Cost,
            discount = Discount,
            icon_type = IconTypr,
            base = Base,
            max_num = MaxNum
        } = BaseShop,
        Count = daily:get_count(?DAILY_NEW_SHOP(Id)),
        List = [Id, GoodsId, GoodsNum - Count, IconTypr, Cost, Discount, Base, MaxNum],
        case GoodsId == ?GOODS_BABY_CREATE_GOODS_ID of
            true ->
                case baby_util:is_has_baby(Player) of
                    true ->
                        AccList;
                    false ->
                        [List | AccList]
                end;
            false ->
                [List | AccList]
        end
        end,
    GoodsList = lists:reverse(lists:foldl(F, [], IdList)),
    {ok, Bin} = pt_380:write(38000, {ShopType, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

buy_shop_goods(Player, ShopType, GoodsId0, BuyNum) ->
    case check_buy_shop_goods(Player, ShopType, GoodsId0, BuyNum) of
        {false, Res} ->
            {false, Res};
        {ok, BaseShop} ->
            #base_shop{
                goods_id = GoodsId,
                cost = Cost,
                discount = Discount,
                base = Base
            } = BaseShop,
            Player1 = reduce_coin(Player, ShopType, Cost * BuyNum * Discount div 100, GoodsId, BuyNum * Base),
            log_new_shop(Player#player.key, Player#player.nickname, shoptype_to_name(ShopType), Cost * BuyNum * Discount div 100, GoodsId, BuyNum * Base),
            GiveGoodsList = goods:make_give_goods_list(128, [{GoodsId, BuyNum * Base}]),
            {ok, Player2} = goods:give_goods(Player1, GiveGoodsList),
            {ok, Player2}
    end.

check_buy_shop_goods(Player, ShopType, GoodsId, BuyNum) ->
    BaseShop = data_new_shop:get_by_type_goods_id(ShopType, GoodsId),
    case BaseShop of
        [] -> {false, 2}; %% 商品不存在
        _ ->
            Count = daily:get_count(?DAILY_NEW_SHOP(BaseShop#base_shop.id)),
            IsEnough = is_enough(Player, BaseShop#base_shop.cost * BuyNum * BaseShop#base_shop.discount div 100, ShopType),
            if
                not IsEnough ->
                    {false, 17}; %% 消耗不足
                BuyNum =< 0 -> {false, 0};
                BaseShop#base_shop.goods_num =:= -1 -> {ok, BaseShop};
                BaseShop#base_shop.goods_num < Count + BuyNum -> {false, 18}; %% 购买数量不足
                true ->
                    if
                        BaseShop#base_shop.goods_num >= Count + BuyNum ->
                            daily:increment(?DAILY_NEW_SHOP(BaseShop#base_shop.id), BuyNum);
                        true -> daily:set_count(?DAILY_NEW_SHOP(BaseShop#base_shop.id), BaseShop#base_shop.goods_num)
                    end,
                    {ok, BaseShop}
            end
    end.

%%获取商品在商店出售的单价
%%返还 {type,price} type 1银币,2绑钻,3元宝
get_goods_price(GoodsId) ->
    case data_new_shop:get_by_goods_id(GoodsId) of
        [] -> false;
        Base ->
            #base_shop{
                %% goods_num = GoodsNum,
                gold = Gold,
                bgold = BGold,
                coin = Coin
            } = Base,
            if Coin > 0 ->
                {ok, coin, util:ceil(Coin)};
                BGold > 0 ->
                    {ok, bgold, util:ceil(BGold)};
                Gold > 0 ->
                    {ok, gold, util:ceil(Gold)};
                true ->
                    false
            end
    end.

%%检查自动购买 return  {false,1}价格不存在 {false,2}银币不足 {false,3}元宝不足 {ok,type,price} type 1银币,2绑钻,3元宝
check_auto_buy(Player, GoodsId, Num) ->
    case data_new_shop:get_by_goods_id(GoodsId) of
        [] -> {false, 1};
        Base ->
            #base_shop{
                %%goods_num = GoodsNum,
                coin = Coin,
                gold = Gold,
                bgold = BGold
            } = Base,
            if Coin > 0 ->
                Price = util:ceil(Coin * Num),
                case money:is_enough(Player, Price, coin) of
                    false -> {false, 2};
                    true ->
                        {ok, coin, Price}
                end;
                BGold > 0 ->
                    Price = util:ceil(BGold * Num),
                    case money:is_enough(Player, Price, bgold) of
                        false -> {false, 3};
                        true ->
                            {ok, bgold, Price}
                    end;
                Gold > 0 ->
                    Price = util:ceil(Gold * Num),
                    case money:is_enough(Player, Price, gold) of
                        false -> {false, 3};
                        true ->
                            {ok, gold, Price}
                    end;
                true ->
                    {false, 1}
            end
    end.

%%自动购买
auto_buy(Player, GoodsId, Num, From) ->
    case data_new_shop:get_by_goods_id(GoodsId) of
        [] -> {false, 1};
        Base ->
            #base_shop{
                goods_num = GoodsNum0,
                coin = Coin,
                gold = Gold,
                bgold = BGold
            } = Base,
            GoodsNum = ?IF_ELSE(GoodsNum0 < 0, 1, GoodsNum0),
            if Coin > 0 ->
                Price = util:ceil(Coin / GoodsNum * Num),
                case money:is_enough(Player, Price, coin) of
                    false -> {false, 2};
                    true ->
                        NewPlayer = money:add_coin(Player, -Price, From, GoodsId, GoodsNum * Num),
                        {ok, NewPlayer, Price}
                end;
                BGold > 0 ->
                    Price = util:ceil(BGold / GoodsNum * Num),
                    case money:is_enough(Player, Price, bgold) of
                        false -> {false, 3};
                        true ->
                            NewPlayer = money:add_gold(Player, -Price, From, GoodsId, GoodsNum * Num),
                            {ok, NewPlayer, Price}
                    end;
                Gold > 0 ->
                    Price = util:ceil(Gold / GoodsNum * Num),
                    case money:is_enough(Player, Price, gold) of
                        false -> {false, 3};
                        true ->
                            NewPlayer = money:add_no_bind_gold(Player, -Price, From, GoodsId, GoodsNum * Num),
                            {ok, NewPlayer, Price}
                    end;
                true ->
                    {false, 1}
            end
    end.


%% 判断消耗是否足够
is_enough(Player, Cost, ShopType) ->
    case ShopType of
        ?GOLD_SHOP -> money:is_enough(Player, Cost, gold);
        ?BGOLD_SHOP ->
            [_Gold, BGold] = money:get_gold(Player#player.key),
            ?IF_ELSE(BGold >= Cost, true, false);
        %% money:is_enough(Player, Cost, bgold);
        ?REPUTE_SHOP -> ?IF_ELSE(Player#player.repute >= Cost, true, false);
        ?HONOUR_SHOP -> ?IF_ELSE(Player#player.honor >= Cost, true, false);
        ?EXPLOIT_SHOP -> ?IF_ELSE(Player#player.exploit_pri >= Cost, true, false);
        ?SD_PT_SHOP -> ?IF_ELSE(Player#player.sd_pt >= Cost, true, false);
        ?FAIRY_CRYSTAL_SHOP -> ?IF_ELSE(Player#player.fairy_crystal >= Cost, true, false);
        _ -> ?ERR("Can't find shop! ShopType ~p cost ~p ~n ", [ShopType, Cost]), false
    end.

%% 扣除相应消耗
reduce_coin(Player, ShopType, Cost, GoodsId, GoodsNum) ->
    case ShopType of
        ?GOLD_SHOP -> money:add_no_bind_gold(Player, -Cost, 237, GoodsId, GoodsNum);
        ?BGOLD_SHOP -> money:only_add_bind_gold(Player, -Cost, 237, GoodsId, GoodsNum);
        ?REPUTE_SHOP -> money:add_repute(Player, -Cost);
        ?HONOUR_SHOP -> money:add_honor(Player, -Cost);
        ?EXPLOIT_SHOP -> money:add_exploit_pri(Player, -Cost);
        ?SD_PT_SHOP -> money:add_sd_pt(Player, -Cost);
        ?FAIRY_CRYSTAL_SHOP -> money:fairy_crystal(Player, -Cost);
        _ -> ?ERR("Can't find shop! ShopType ~p cost ~p gid ~p/~p~n ", [ShopType, Cost, GoodsId, GoodsNum]), false
    end.

shoptype_to_name(ShopType) ->
    case ShopType of
        ?GOLD_SHOP -> ?T("元宝");
        ?BGOLD_SHOP -> ?T("绑定元宝");
        ?REPUTE_SHOP -> ?T("声望");
        ?HONOUR_SHOP -> ?T("荣誉");
        ?EXPLOIT_SHOP -> ?T("功勋");
        ?SD_PT_SHOP -> ?T("历练");
        ?FAIRY_CRYSTAL_SHOP -> ?T("仙晶");
        _ ->
            ?ERR("Can't find shop! ShopType ~p ~n ", [ShopType]),
            ?T("未知")
    end.

log_new_shop(Pkey, Nickname, CostType, Cost, GoodsId, GoodsNum) ->
    Sql = io_lib:format(<<"insert into log_new_shop set pkey = ~p,nickname = '~s', cost_type = '~s', cost = ~p, goods_id = ~p,goods_num = ~p,time=~p">>,
        [Pkey, Nickname, CostType, Cost, GoodsId, GoodsNum, util:unixtime()]),
    log_proc:log(Sql),
    ok.
