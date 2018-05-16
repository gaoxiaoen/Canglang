%% @author and_me
%% @doc @todo Add description to mount_init.


-module(random_shop_init).

-include("common.hrl").
-include("server.hrl").
-include("shop.hrl").


-export([init/1]).
-export([mystical_shop_refresh/1,
    black_shop_refresh/1,
    smelt_shop_refresh/1,
    athletics_shop_refresh/1,
    guild_shop_refresh/1,
    battlefield_shop_refresh/1,
    star_shop_refresh/1,
    online_refresh/2
]).


init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            InsertSql = io_lib:format("insert into random_shop_refresh_time (pkey ,mystical_shop_refresh_time,black_shop_refresh_time,smelt_shop_refresh_time,athletics_shop_refresh_time,guild_shop_refresh_time,battlefield_shop_refresh_time,star_shop_refresh_time) values (~p,~p,~p,~p,~p,~p,~p,~p)", [Player#player.key, 0, 0, 0, 0, 0, 0, 0]),
            db:execute(InsertSql),
            InsertSql1 = io_lib:format("insert into random_shop_refresh_count (pkey ,mystical_shop_refresh_time,black_shop_refresh_time,smelt_shop_refresh_time,athletics_shop_refresh_time,guild_shop_refresh_time,battlefield_shop_refresh_time,star_shop_refresh_time) values (~p,~p,~p,~p,~p,~p,~p,~p)", [Player#player.key, 0, 0, 0, 0, 0, 0, 0]),
            db:execute(InsertSql1),
            {MysticalShopRefreshTime, BlackShopRefreshTime, SmeltShopRefreshTime, AthleticsShopRefreshTime, GuildShopRefreshTime, BattleShopRefreshTime, StarShopRefreshTime} = {0, 0, 0, 0, 0, 0, 0},
            SmeltShopList = [],
            BlShopList = [],
            AtShopList = [],
            BattleShopList = [],
            GuildShopList = [],
            MyShopList = [],
            StarShopList = [],
            MysticalShopCount = 0;
        _ ->
            {MysticalShopCount} = random_shop_load:get_last_refresh_count(Player),
            {MysticalShopRefreshTime, BlackShopRefreshTime, SmeltShopRefreshTime, AthleticsShopRefreshTime, GuildShopRefreshTime, BattleShopRefreshTime, StarShopRefreshTime} = random_shop_load:get_last_refresh_time(Player#player.key),
            BlShopList = random_shop_load:load_all_shop(Player#player.key, "random_shop_black"),
            BattleShopList = random_shop_load:load_all_shop(Player#player.key, "random_shop_battlefield"),
            SmeltShopList = random_shop_load:load_all_shop(Player#player.key, "random_shop_smelt"),
            AtShopList = random_shop_load:load_all_shop(Player#player.key, "random_shop_athletics"),
            GuildShopList = random_shop_load:load_all_shop(Player#player.key, "random_shop_guild"),
            MyShopList = random_shop_load:load_all_shop(Player#player.key, "random_shop_mystical"),
            StarShopList = random_shop_init:star_shop_refresh(Player)
    end,
    MystycalShop = #st_shop{
        is_change = 0,
        refresh_count = MysticalShopCount,
        refresh_time = MysticalShopRefreshTime,
        shop_list = MyShopList
    },
    lib_dict:put(?PROC_STATUS_MYSTICAL_SHOP, MystycalShop),

    BlShop = #st_shop{
        is_change = 0,
        refresh_time = BlackShopRefreshTime,
        shop_list = BlShopList
    },
    lib_dict:put(?PROC_STATUS_BLACK_SHOP, BlShop),

    SmeltShop = #st_shop{
        is_change = 0,
        refresh_time = SmeltShopRefreshTime,
        shop_list = SmeltShopList
    },
    lib_dict:put(?PROC_STATUS_SMELT_SHOP, SmeltShop),
    AtShop = #st_shop{
        is_change = 0,
        refresh_time = AthleticsShopRefreshTime,
        shop_list = AtShopList
    },
    lib_dict:put(?PROC_STATUS_ATHLETICS_SHOP, AtShop),
    GuildShop = #st_shop{
        is_change = 0,
        refresh_time = GuildShopRefreshTime,
        shop_list = GuildShopList
    },
    lib_dict:put(?PROC_STATUS_GUILD_SHOP, GuildShop),

    BattleShop = #st_shop{
        is_change = 0,
        refresh_time = BattleShopRefreshTime,
        shop_list = BattleShopList
    },
    lib_dict:put(?PROC_STATUS_BATTLE_FIELD_SHOP, BattleShop),

    StarShop = #st_shop{
        is_change = 0,
        refresh_time = StarShopRefreshTime + 1,
        shop_list = StarShopList
    },
    lib_dict:put(?PROC_STATUS_STAR_SHOP, StarShop),
    Player.

online_refresh(?RANDOM_SHOP_BLACK, Player) when Player#player.vip_lv < 5 ->
    skip;

online_refresh(Type, Player) ->
    StShop = random_shop_util:get_shop_st(Type),
    Now = util:unixtime(),
    Table = random_shop_util:get_shoptable_by_type(Type),
    case StShop#st_shop.refresh_time =:= 0 orelse login_check_refresh(StShop#st_shop.refresh_time, Table) of
        true ->
            InitFun = random_shop_util:get_initfun_by_type(Type),
            NewShopList = apply(InitFun, [Player]),
            random_shop_load:replace_all_shop(Player#player.key, NewShopList, Table),
            TypeString = random_shop_util:get_refresh_time_field_name(Type),
            random_shop_load:replace_single_refresh_time(Player#player.key, TypeString, Now),
            NewStShop = StShop#st_shop{shop_list = NewShopList, refresh_time = Now},
            random_shop_util:put_shop_st(Type, NewStShop);
        _ ->
            skip
    end.

mystical_shop_refresh(Player) ->
    common_shop_refresh(Player, data_mystical_shop, undefined).

black_shop_refresh(Player) ->
    common_shop_refresh(Player, data_black_shop, undefined).

smelt_shop_refresh(Player) ->
    common_shop_refresh(Player, data_smelt_shop, data_smelt_shop_wash_gem).

athletics_shop_refresh(Player) ->
    common_shop_refresh(Player, data_athletics_shop, undefined).

guild_shop_refresh(Player) ->
    common_shop_refresh(Player, data_guild_shop, undefined).

battlefield_shop_refresh(Player) ->
    common_shop_refresh(Player, data_battlefield_shop, undefined).

star_shop_refresh(Player) ->
    common_shop_refresh(Player, data_random_star_shop, undefined).

common_shop_refresh(Player, DataModule, _WashInitModule) ->
    F = fun(I) ->
        case apply(DataModule, get_probability, [Player#player.lv, I]) of
            [] -> [];
            RefreshShopList ->
                {ShopId, _} = util:get_weight_item(2, RefreshShopList),
                MysticalShop = DataModule:get(ShopId),
                [{GoodsId, Num} | _] = [{Gid, N} || {Carr, Gid, N} <- MysticalShop#base_random_shop.goods_id, Carr == Player#player.career orelse Carr == 0],
                [
                    #shop_item{
                        id = I,
                        goods_id = GoodsId,
                        num = Num,
                        gemstone_groove = [],
                        diamond = MysticalShop#base_random_shop.diamond,
                        money = MysticalShop#base_random_shop.shop_money,
                        discount = MysticalShop#base_random_shop.discount}
                ]
        end
        end,
    lists:flatmap(F, lists:seq(1, 9)).


%%星运商店不用定时刷新
login_check_refresh(_, Table) when Table == "random_shop_star" ->
    false;

login_check_refresh(LastRefreshTime, Table) ->
    Now = util:unixtime(),
    TodayMidnightTime = util:get_today_midnight(Now),
    LastMidnightTime = util:get_today_midnight(LastRefreshTime),
    TimeList = random_shop_util:get_refresh_time_list(Table),
    login_check_time(Now, LastRefreshTime, TodayMidnightTime, LastMidnightTime, TimeList).

login_check_time(_, _, _, _, []) ->
    false;
login_check_time(Now, LastRefreshTime, TodayMidnightTime, LastMidnightTime, [H | TimeList]) ->
    TodayRefreshTime = TodayMidnightTime + H,
    LastDayRefreshTime = LastMidnightTime + H,
    case (util:is_same_date(LastRefreshTime, Now) =:= false andalso (LastRefreshTime < LastDayRefreshTime orelse Now - LastRefreshTime >= 3600 * 24)) of
        true -> %%上次刷新时间是在昨天或者更早以前
            true;
        false when LastRefreshTime < TodayRefreshTime andalso Now >= TodayRefreshTime ->
            true;
        _ ->
            login_check_time(Now, LastRefreshTime, TodayMidnightTime, LastMidnightTime, TimeList)
    end.