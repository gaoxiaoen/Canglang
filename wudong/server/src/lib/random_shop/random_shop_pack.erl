%% @author and_me
%% @doc @todo Add description to mount_pack.


-module(random_shop_pack).
-include("common.hrl").
-include("server.hrl").
-include("shop.hrl").
-include("error_code.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([send_mystycal_shop_info/2]).

send_mystycal_shop_info(Player, Type) ->
    MystycalShop = random_shop_util:get_shop_st(Type),
    ShopList = MystycalShop#st_shop.shop_list,
    LeftTime = left_time_to_client(Type),
    GoodsList =
        [begin
             {ConsumeType, Value} = consume_to_client(ShopItem, Type),
             %% WashInfo = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- ShopItem#shop_item.wash_attr],
             WashInfo = [],
             Gemstone = [[Type1, Value1] || {Type1, Value1} <- ShopItem#shop_item.gemstone_groove],
             [ShopItem#shop_item.id,
                 ShopItem#shop_item.goods_id,
                 ShopItem#shop_item.num,
                 WashInfo,
                 Gemstone,
                 ConsumeType,
                 Value]
         end || ShopItem <- ShopList],
    {RConsumeType, RValue} = refresh_money_to_client(Type, MystycalShop),
    {ok, Bin} = pt_180:write(18001, {Type, LeftTime, RConsumeType, RValue, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin).


consume_to_client(ShopItem, _ShopType) when ShopItem#shop_item.diamond > 0 ->
    {1, ShopItem#shop_item.diamond};

consume_to_client(ShopItem, ShopType) ->
    case ShopType of
        ?RANDOM_SHOP_MYSTERIOUS -> {2, ShopItem#shop_item.money};
        ?RANDOM_SHOP_BLACK -> {2, ShopItem#shop_item.money};
        ?RANDOM_SHOP_SMELT -> {4, ShopItem#shop_item.money};
        ?RANDOM_SHOP_ATHLETICS -> {5, ShopItem#shop_item.money};
        ?RANDOM_SHOP_GUILD -> {6, ShopItem#shop_item.money};
        ?RANDOM_SHOP_BATTLE -> {4, ShopItem#shop_item.money};
        ?RANDOM_SHOP_STAR -> {10, ShopItem#shop_item.money}
    end.

refresh_money_to_client(ShopType, MystycalShop) ->
    case ShopType of
        ?RANDOM_SHOP_MYSTERIOUS ->
            if MystycalShop#st_shop.refresh_count + 1 > 6 ->
                NeedMoney = 1000;
                true -> NeedMoney = lists:nth(MystycalShop#st_shop.refresh_count + 1, [50, 100, 200, 400, 800, 1000])
            end,
            {1, NeedMoney};
        ?RANDOM_SHOP_BLACK -> {1, 300};
        ?RANDOM_SHOP_SMELT -> {4, 50};
        ?RANDOM_SHOP_ATHLETICS -> {5, 50};
        ?RANDOM_SHOP_GUILD -> {6, 50};
        ?RANDOM_SHOP_BATTLE -> {4, 400};
        ?RANDOM_SHOP_STAR -> {10, 50}
    end.

left_time_to_client(?RANDOM_SHOP_MYSTERIOUS) -> 12 * 3600;
left_time_to_client(Type) ->
    Now = util:unixtime(),
    MidnightTime = util:get_today_midnight(Now),
    TimeList = random_shop_util:get_refresh_time_list(Type),

    case [Time || Time <- TimeList, MidnightTime + Time > Now] of
        [] ->
            [FirstTime | _] = TimeList,
            FirstTime;
        [FirstTime | _] ->
            FirstTime
    end.