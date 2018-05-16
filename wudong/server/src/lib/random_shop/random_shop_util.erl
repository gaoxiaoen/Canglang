%% @author and_me
%% @doc @todo Add description to mount.


-module(random_shop_util).
-include("common.hrl").
-include("shop.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([get_shop_st/1,
    put_shop_st/2,
    get_shoptable_by_type/1,
    get_refresh_time_list/1,
    get_initfun_by_type/1,
    get_refresh_time_field_name/1]).


%% ====================================================================
%% Internal functions
%% ====================================================================

get_shop_st(Type) ->
    case Type of
        ?RANDOM_SHOP_MYSTERIOUS ->
            lib_dict:get(?PROC_STATUS_MYSTICAL_SHOP);
        ?RANDOM_SHOP_BLACK ->
            lib_dict:get(?PROC_STATUS_BLACK_SHOP);
        ?RANDOM_SHOP_SMELT ->
            lib_dict:get(?PROC_STATUS_SMELT_SHOP);
        ?RANDOM_SHOP_ATHLETICS ->
            lib_dict:get(?PROC_STATUS_ATHLETICS_SHOP);
        ?RANDOM_SHOP_GUILD ->
            lib_dict:get(?PROC_STATUS_GUILD_SHOP);
		?RANDOM_SHOP_BATTLE ->
			lib_dict:get(?PROC_STATUS_BATTLE_FIELD_SHOP);
		?RANDOM_SHOP_STAR->
			lib_dict:get(?PROC_STATUS_STAR_SHOP)
    end.

put_shop_st(Type, St) ->
    case Type of
        ?RANDOM_SHOP_MYSTERIOUS ->
            lib_dict:put(?PROC_STATUS_MYSTICAL_SHOP, St);
        ?RANDOM_SHOP_BLACK ->
            lib_dict:put(?PROC_STATUS_BLACK_SHOP, St);
        ?RANDOM_SHOP_SMELT ->
            lib_dict:put(?PROC_STATUS_SMELT_SHOP, St);
        ?RANDOM_SHOP_ATHLETICS ->
            lib_dict:put(?PROC_STATUS_ATHLETICS_SHOP, St);
        ?RANDOM_SHOP_GUILD ->
            lib_dict:put(?PROC_STATUS_GUILD_SHOP, St);
		?RANDOM_SHOP_BATTLE->
			lib_dict:put(?PROC_STATUS_BATTLE_FIELD_SHOP, St);
		?RANDOM_SHOP_STAR->
			lib_dict:put(?PROC_STATUS_STAR_SHOP, St)
    end.

get_shoptable_by_type(Type) ->
    case Type of
        ?RANDOM_SHOP_MYSTERIOUS ->
            ShopTable = "random_shop_mystical";
        ?RANDOM_SHOP_BLACK ->
            ShopTable = "random_shop_black";
        ?RANDOM_SHOP_SMELT ->
            ShopTable = "random_shop_smelt";
        ?RANDOM_SHOP_ATHLETICS ->
            ShopTable = "random_shop_athletics";
        ?RANDOM_SHOP_GUILD ->
            ShopTable = "random_shop_guild";
		?RANDOM_SHOP_BATTLE->
			ShopTable = "random_shop_battlefield";
		?RANDOM_SHOP_STAR->
			ShopTable = "random_shop_star"
    end,
    ShopTable.

get_initfun_by_type(Type) ->
    case Type of
        ?RANDOM_SHOP_MYSTERIOUS ->
            fun random_shop_init:mystical_shop_refresh/1;
        ?RANDOM_SHOP_BLACK ->
            fun random_shop_init:black_shop_refresh/1;
        ?RANDOM_SHOP_SMELT ->
            fun random_shop_init:smelt_shop_refresh/1;
        ?RANDOM_SHOP_ATHLETICS ->
            fun random_shop_init:athletics_shop_refresh/1;
        ?RANDOM_SHOP_GUILD ->
            fun random_shop_init:guild_shop_refresh/1;
		?RANDOM_SHOP_BATTLE->
			fun random_shop_init:battlefield_shop_refresh/1;
		?RANDOM_SHOP_STAR->
			fun random_shop_init:star_shop_refresh/1
    end.

get_refresh_time_field_name(Type) ->
    case Type of
        ?RANDOM_SHOP_MYSTERIOUS ->
            "mystical_shop_refresh_time";
        ?RANDOM_SHOP_BLACK ->
            "black_shop_refresh_time";
        ?RANDOM_SHOP_SMELT ->
            "smelt_shop_refresh_time";
        ?RANDOM_SHOP_ATHLETICS ->
            "athletics_shop_refresh_time";
        ?RANDOM_SHOP_GUILD ->
            "guild_shop_refresh_time";
		?RANDOM_SHOP_BATTLE->
			"battlefield_shop_refresh_time";
		?RANDOM_SHOP_STAR->
			"star_shop_refresh_time"
    end.


get_refresh_time_list(Table) ->
    if
        Table == "random_shop_mystical" orelse Table == ?RANDOM_SHOP_MYSTERIOUS ->
            [12 * 3600, 18 * 3600, 21 * 3600];
        true ->
            [21 * 3600]
    end.
