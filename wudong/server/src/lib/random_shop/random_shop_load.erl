%% @author and_me
%% @doc @todo Add description to mount_load.


-module(random_shop_load).

-include("server.hrl").
-include("common.hrl").
-include("shop.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([
		 get_last_refresh_time/1,
		 load_all_shop/2,
		 replace_all_shop/3,
		 update_shop_num/3,
		 replace_all_refresh_time/2,
         get_last_refresh_count/1,
		 replace_single_refresh_time/3,
         replace_single_refresh_count/3]).



get_last_refresh_time(Pkey)->
	Sql = io_lib:format("select mystical_shop_refresh_time,black_shop_refresh_time,smelt_shop_refresh_time,athletics_shop_refresh_time,guild_shop_refresh_time,battlefield_shop_refresh_time,star_shop_refresh_time from random_shop_refresh_time where pkey = ~p", [Pkey]),
    case db:get_all(Sql) of
          [] ->
			  InsertSql = io_lib:format("insert into random_shop_refresh_time (pkey ,mystical_shop_refresh_time,black_shop_refresh_time,smelt_shop_refresh_time,athletics_shop_refresh_time,guild_shop_refresh_time,battlefield_shop_refresh_time,star_shop_refresh_time) values (~p,~p,~p,~p,~p,~p,~p,~p)"
				  , [Pkey, 0, 0, 0, 0, 0,0,0]),
			  	db:execute(InsertSql),
			  {0, 0, 0, 0, 0,0,0};
		[[MysticalShopRefreshTime, BlackShopRefreshTime, SmeltShopRefreshTime, AthleticsShopRefreshTime, GuildShopRefreshTime,BattlefieldShopRefreshTime,StarShopRefresh_time]] ->
			{MysticalShopRefreshTime, BlackShopRefreshTime, SmeltShopRefreshTime, AthleticsShopRefreshTime, GuildShopRefreshTime,BattlefieldShopRefreshTime,StarShopRefresh_time}
    end.

get_last_refresh_count(Player)->
    case util:is_same_date(Player#player.logout_time,util:unixtime()) of
        true->
            Sql = io_lib:format("select mystical_shop_refresh_time,black_shop_refresh_time,smelt_shop_refresh_time,athletics_shop_refresh_time,guild_shop_refresh_time,battlefield_shop_refresh_time,star_shop_refresh_time from random_shop_refresh_count where pkey = ~p", [Player#player.key]),
            case db:get_all(Sql) of
                [] ->
                    InsertSql = io_lib:format("insert into random_shop_refresh_count (pkey ,mystical_shop_refresh_time,black_shop_refresh_time,smelt_shop_refresh_time,athletics_shop_refresh_time,guild_shop_refresh_time,battlefield_shop_refresh_time,star_shop_refresh_time) values (~p,~p,~p,~p,~p,~p,~p,~p)", [Player#player.key, 0, 0, 0, 0, 0,0,0]),
                    db:execute(InsertSql),
                    {0};
                [[MysticalShopRefreshTime, _BlackShopRefreshTime, _SmeltShopRefreshTime, __AthleticsShopRefreshTime,_GuildShopRefreshTime,_BattlefieldShopRefreshTime,_StarShopRefresh_time]] ->
                    {MysticalShopRefreshTime}
            end;
        _->
            InsertSql = io_lib:format("replace into random_shop_refresh_count (pkey ,mystical_shop_refresh_time,black_shop_refresh_time,smelt_shop_refresh_time,athletics_shop_refresh_time,guild_shop_refresh_time,battlefield_shop_refresh_time,star_shop_refresh_time) values (~p,~p,~p,~p,~p,~p,~p,~p)", [Player#player.key, 0, 0, 0, 0, 0,0,0]),
            db:execute(InsertSql),
            {0}
    end.


load_all_shop(Pkey,ShopTable)->
	Sql = io_lib:format("select id,goods_id,wash_attr,num,gemstone_groove,money,diamond from ~s where pkey = ~p",[ShopTable,Pkey]),
    case db:get_all(Sql) of
          [] -> 
				[];
          List ->
				[#shop_item{id = Id,
							goods_id = GoodsId,
							wash_attr = util:bitstring_to_term(WashAttr),
							num = Num,
							gemstone_groove = util:bitstring_to_term(GemstoneGroove),
							money = Money,
							diamond = Diamond}
				 ||[Id,GoodsId,WashAttr,Num,GemstoneGroove,Money,Diamond]<-List]
    end.

replace_all_shop(Pkey,ShopList,ShopTable)->
	[
	 begin
	 SQL = io_lib:format("replace into ~s (pkey ,id,goods_id,wash_attr,num,gemstone_groove,money,diamond) values (~p,~p,~p,'~s',~p,'~s',~p,~p)",
        [ShopTable,
		 Pkey,
		 ShopItem#shop_item.id,
		 ShopItem#shop_item.goods_id,
		 util:term_to_bitstring(ShopItem#shop_item.wash_attr),
		 ShopItem#shop_item.num,
		 util:term_to_bitstring(ShopItem#shop_item.gemstone_groove),
		 ShopItem#shop_item.money,
		 ShopItem#shop_item.diamond]),
	 	 db:execute(SQL)
	   end||ShopItem<-ShopList],
	 ok.

update_shop_num(Pkey,ShopItem,Type)->
	ShopTable = random_shop_util:get_shoptable_by_type(Type),
	SQL = io_lib:format("update ~s set num = ~p where pkey = ~p and id = ~p",[ShopTable,ShopItem#shop_item.num,Pkey,ShopItem#shop_item.id]),
    db:execute(SQL),
	ok.

replace_all_refresh_time(Pkey,Time)->
	SQL = io_lib:format("update random_shop_refresh_time set mystical_shop_refresh_time =  ~p, black_shop_refresh_time =  ~p, smelt_shop_refresh_time =  ~p, athletics_shop_refresh_time =  ~p ,guild_shop_refersh_time =~p ,battlefield_shop_refresh_time = ~p where pkey = ~p", [Time, Time, Time, Time, Time,Time, Pkey]),
    db:execute(SQL),
	ok.

replace_single_refresh_time(Pkey,TypeString,Time)->
	SQL = io_lib:format("update random_shop_refresh_time set ~s =  ~p where pkey = ~p",[TypeString,Time,Pkey]),
    db:execute(SQL),
	ok.

replace_single_refresh_count(Pkey,TypeString,Time)->
    SQL = io_lib:format("update random_shop_refresh_count set ~s =  ~p where pkey = ~p",[TypeString,Time,Pkey]),
    db:execute(SQL),
    ok.
