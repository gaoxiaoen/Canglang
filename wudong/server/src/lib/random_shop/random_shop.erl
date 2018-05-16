%% @author and_me
%% @doc @todo Add description to mount.


-module(random_shop).
-include("common.hrl").
-include("server.hrl").
-include("shop.hrl").
-include("goods.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([buy_mystycal_shop/3, refresh/2, cron_random_market/8, times_refresh_midnight/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================

buy_mystycal_shop(Player, Type, ShopId) ->
    StShop = random_shop_util:get_shop_st(Type),
    ShopList = StShop#st_shop.shop_list,
    {value, ShopItem, LShopList} = lists:keytake(ShopId, #shop_item.id, ShopList),
    ?ASSERT(ShopItem#shop_item.num > 0, 2),
    ?IF_ELSE(Type =/= ?RANDOM_SHOP_GUILD, ok, ?ASSERT(Player#player.guild#st_guild.guild_key /= 0, 11)),
    ?ASSERT(Type =/= ?RANDOM_SHOP_BLACK orelse (Type =:= ?RANDOM_SHOP_BLACK andalso Player#player.vip_lv >= 5), {false, 9}),
    case Type of
        ?RANDOM_SHOP_STAR ->
            case star_luck:is_star_luck(ShopItem#shop_item.goods_id) of
                true -> ?ASSERT(star_luck:get_free_bag_num() > 0, {false, 12});
                false -> skip
            end;
        _ -> skip
    end,
    NewShopItem = ?IF_ELSE(Type =:= ?RANDOM_SHOP_STAR, ShopItem, ShopItem#shop_item{num = 0}),
    NewStShop = StShop#st_shop{shop_list = [NewShopItem | LShopList]},
    check_cost_money(Type, Player, ShopItem),
    Player1 = buy_cost_money(Type, Player, ShopItem, ShopItem#shop_item.goods_id, ShopItem#shop_item.num),
    {ok, NewPlayer} = goods:give_goods_throw(Player1, [{ShopItem#shop_item.goods_id, ShopItem#shop_item.num, ?GOODS_LOCATION_BAG, ?BIND, 25, {ShopItem#shop_item.wash_attr, ShopItem#shop_item.gemstone_groove}}]),
    random_shop_load:update_shop_num(Player#player.key, NewShopItem, Type),
    random_shop_util:put_shop_st(Type, NewStShop),
    {ok, NewPlayer, 0}.


refresh(Player, Type) ->
    StShop = random_shop_util:get_shop_st(Type),
    NewPlayer = refresh_cost_money(Type, Player, StShop),
    ShopTable = random_shop_util:get_shoptable_by_type(Type),
    case Type of
        ?RANDOM_SHOP_MYSTERIOUS ->
            ShopList = random_shop_init:mystical_shop_refresh(Player);
        ?RANDOM_SHOP_BLACK ->
            ShopList = random_shop_init:black_shop_refresh(Player);
        ?RANDOM_SHOP_SMELT ->
            ShopList = random_shop_init:smelt_shop_refresh(Player);
        ?RANDOM_SHOP_ATHLETICS ->
            ShopList = random_shop_init:athletics_shop_refresh(Player);
        ?RANDOM_SHOP_GUILD ->
            ShopList = random_shop_init:guild_shop_refresh(Player);
        ?RANDOM_SHOP_BATTLE ->
            ShopList = random_shop_init:battlefield_shop_refresh(Player);
        ?RANDOM_SHOP_STAR ->
            ShopList = random_shop_init:star_shop_refresh(Player)
    end,
    NewSt = StShop#st_shop{refresh_count = StShop#st_shop.refresh_count + 1, shop_list = ShopList},
    random_shop_load:replace_all_shop(Player#player.key, ShopList, ShopTable),
    random_shop_util:put_shop_st(Type, NewSt),
    {ok, NewPlayer}.

check_cost_money(_Type, Player, ShopItem) when ShopItem#shop_item.diamond > 0 ->
    ?ASSERT(Player#player.gold + Player#player.bgold >= ShopItem#shop_item.diamond, 3);

check_cost_money(Type, Player, ShopItem) ->
    case Type of
        ?RANDOM_SHOP_MYSTERIOUS -> %扣银币
            ?ASSERT(Player#player.coin >= ShopItem#shop_item.money, 4);
        ?RANDOM_SHOP_BLACK ->
            ?ASSERT(Player#player.coin >= ShopItem#shop_item.money, 5);
        ?RANDOM_SHOP_SMELT ->
            ?ASSERT(Player#player.smelt_value >= ShopItem#shop_item.money, 6);
        ?RANDOM_SHOP_ATHLETICS ->
            ?ASSERT(Player#player.arena_pt >= ShopItem#shop_item.money, 7);
        ?RANDOM_SHOP_BATTLE ->
            ?ASSERT(Player#player.honor >= ShopItem#shop_item.money, 6);
        ?RANDOM_SHOP_STAR ->
            ?ASSERT(Player#player.xingyun_pt >= ShopItem#shop_item.money, 6)
    end.

buy_cost_money(Type, Player, ShopItem, GoodsId, GoodsNum) when ShopItem#shop_item.diamond > 0 ->
    cron_random_market(Player#player.key, Player#player.nickname, Type, ShopItem#shop_item.goods_id, {ShopItem#shop_item.wash_attr, ShopItem#shop_item.gemstone_groove}, ShopItem#shop_item.diamond, ShopItem#shop_item.money, util:unixtime()),
    money:add_gold(Player, -ShopItem#shop_item.diamond, 25, GoodsId, GoodsNum);

buy_cost_money(Type, Player, ShopItem, GoodsId, GoodsNum) ->
    cron_random_market(Player#player.key, Player#player.nickname, Type, ShopItem#shop_item.goods_id, {ShopItem#shop_item.wash_attr, ShopItem#shop_item.gemstone_groove}, ShopItem#shop_item.diamond, ShopItem#shop_item.money, util:unixtime()),
    case Type of
        ?RANDOM_SHOP_MYSTERIOUS -> %扣银币
            money:add_coin(Player, -ShopItem#shop_item.money, 25, GoodsId, GoodsNum);
        ?RANDOM_SHOP_BLACK ->
            money:add_coin(Player, -ShopItem#shop_item.money, 25, GoodsId, GoodsNum);
        ?RANDOM_SHOP_SMELT ->
            equip_smelt:cost_smelt_value(Player, ShopItem#shop_item.money);
        ?RANDOM_SHOP_ATHLETICS ->
            money:add_arena_pt(Player, -ShopItem#shop_item.money);
        ?RANDOM_SHOP_BATTLE ->
            money:add_honor(Player, -ShopItem#shop_item.money);
        ?RANDOM_SHOP_STAR ->
            money:add_xingyun_pt(Player, -ShopItem#shop_item.money)
    end.

refresh_cost_money(Type, Player, StShop) ->
    case Type of
        ?RANDOM_SHOP_SMELT -> %扣熔炼值
            ?ASSERT(Player#player.smelt_value >= 50, 6),
            equip_smelt:cost_smelt_value(Player, 50);
        ?RANDOM_SHOP_BLACK ->
            ?ASSERT(Player#player.gold + Player#player.bgold >= 200, 3),
            money:add_gold(Player, -300, 27, 0, 0);
        ?RANDOM_SHOP_MYSTERIOUS ->
            PriceList = [50, 100, 200, 400, 800, 1000],
            if StShop#st_shop.refresh_count + 1 > 6 ->
                NeedMoney = 1000;
                true ->
                    NeedMoney = lists:nth(StShop#st_shop.refresh_count + 1, PriceList)
            end,
            random_shop_load:replace_single_refresh_count(Player#player.key, "mystical_shop_refresh_time", StShop#st_shop.refresh_count + 1),
            ?ASSERT(Player#player.gold + Player#player.bgold >= NeedMoney, 3),
            money:add_gold(Player, -NeedMoney, 27, 0, 0);
        ?RANDOM_SHOP_ATHLETICS ->
            ?ASSERT(Player#player.arena_pt >= 50, 7),
            money:add_arena_pt(Player, -50);
        ?RANDOM_SHOP_BATTLE ->
            ?ASSERT(Player#player.honor >= 400, 6),
            money:add_honor(Player, -400);
        ?RANDOM_SHOP_STAR ->
            ?ASSERT(Player#player.xingyun_pt >= 50, 6),
            money:add_xingyun_pt(Player, -50)
    end.

cron_random_market(Pkey, Nickname, Type, Goods_id, Goods_attr, Gold, Money, Time) ->
    Sql = io_lib:format(<<"insert into log_random_market set pkey = ~p,nickname = '~s',type=~p,goods_id = ~p,goods_attr = '~s',gold = ~p,money = ~p,time=~p">>,
        [Pkey, Nickname, Type, Goods_id, util:term_to_bitstring(Goods_attr), Gold, Money, Time]),
    log_proc:log(Sql),
    ok.


times_refresh_midnight(Player) ->
    StShop = random_shop_util:get_shop_st(?RANDOM_SHOP_MYSTERIOUS),
    if
        StShop#st_shop.refresh_count > 0 ->
            NewSt = StShop#st_shop{refresh_count = 0},
            random_shop_load:replace_single_refresh_count(Player#player.key, "mystical_shop_refresh_time", 0),
            random_shop_util:put_shop_st(?RANDOM_SHOP_MYSTERIOUS, NewSt),
            ok;
        true ->
            ok
    end.
