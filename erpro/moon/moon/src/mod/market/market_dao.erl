%%----------------------------------------------------
%% @doc 市场模块数据库访问 
%%
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------
-module(market_dao).

-export([
        get_all_sale/0
        ,get_all_sale2/0
        ,delete_sale/1
        ,delete_sale2/1
        ,insert_sale/1
        ,insert_sale2/1

        ,get_all_buy/0
        ,insert_buy/1
        ,delete_buy/1
        ,update_buy_quantity/2

        ,get_key/1
        ,update_key/1
        ,insert_key/1
    ]
).

-include("common.hrl").
-include("market.hrl").

%% 获取全部拍卖物品信息
get_all_sale() ->
    Sql = <<"select sale_id, role_id, srv_id, begin_time, end_time, assets_type, price, item_id, item_base_id, item_name, type, use_type, bind, source, quality, lev, career, upgrade, enchant, enchant_fail, quantity, status, pos, lasttime, durability, attr, special, max_base_attr, saler_name, saler_lev from sys_market_sale">>,
    case db:get_all(Sql, []) of
        {ok, []} ->
            {false, []};
        {ok, Data} ->
            {true, Data};
        {error, Msg} ->
            ?ERR("执行数据库出错了[Msg:~w]", [Msg]),
            {false, []}
    end. 

get_all_sale2() ->
    Sql = <<"select sale_id, role_id, srv_id, begin_time, end_time, origin_price, price, quantity, item_base_id, type, saler_name, saler_lev, saler_career from sys_market_sale2">>,
    case db:get_all(Sql, []) of
        {ok, []} ->
            {false, []};
        {ok, Data} ->
            {true, Data};
        {error, Msg} ->
            ?ERR("执行数据库出错了[Msg:~w]", [Msg]),
            {false, []}
    end.

%% 删除拍卖物品
delete_sale(SaleId) ->
    Sql = <<"delete from sys_market_sale where sale_id = ~s">>,
    case db:execute(Sql, [SaleId]) of
        {ok, Affected} ->
            {ok, Affected};
        {error, Msg} ->
            ?ERR("DB ERROR:删除拍卖物品出错了[Msg:~w]", [Msg]),
            {false, Msg}
    end.

delete_sale2(SaleId) ->
    Sql = <<"delete from sys_market_sale2 where sale_id = ~s">>,
    case db:execute(Sql, [SaleId]) of
        {ok, Affected} ->
            {ok, Affected};
        {error, Msg} ->
            ?ERR("DB ERROR:删除拍卖物品出错了[Saleid:~w][Msg:~w]", [SaleId, Msg]),
            {false, Msg}
    end.


%% 插入拍卖信息
insert_sale(#market_sale{sale_id = SaleId, role_id = RoleId, srv_id = SrvId, begin_time = BeginTime, end_time = EndTime, assets_type = AssetsType, price = Price, item_id = ItemId, item_base_id = ItemBaseId, item_name = ItemName, type = Type, use_type = UseType, bind = Bind, source = Source, quality = Quality, lev = Lev, career = Career, upgrade = Upgrade, enchant = Enchant, enchant_fail = EnchantFail, quantity = Quantity, status = Status, pos = Pos, lasttime = Lasttime, durability = Durability, attr = Attr, special = Special, max_base_attr = MaxBaseAttr, saler_name = SalerName, saler_lev = SalerLev}) ->
    Sql = <<"insert into sys_market_sale (sale_id, role_id, srv_id, begin_time, end_time, assets_type, price, item_id, item_base_id, item_name, type, use_type, bind, source, quality, lev, career, upgrade, enchant, enchant_fail, quantity, status, pos, lasttime, durability, attr, special, max_base_attr, saler_name, saler_lev) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    NewAttr = util:term_to_bitstring(Attr),
    NewMaxAttr = util:term_to_bitstring(MaxBaseAttr),
    NewSpecial = util:term_to_bitstring(Special),
    db:execute(Sql, [SaleId, RoleId, SrvId, BeginTime, EndTime, AssetsType, Price, ItemId, ItemBaseId, ItemName, Type, UseType, Bind, Source, Quality, Lev, Career, Upgrade, Enchant, EnchantFail, Quantity, Status, Pos, Lasttime, Durability, NewAttr, NewSpecial, NewMaxAttr, SalerName, SalerLev]).

%% 插入拍卖信息
insert_sale2(#market_sale2{sale_id = SaleId, role_id = RoleId, srv_id = SrvId, begin_time = BeginTime, end_time = EndTime, origin_price = Origin_Price, price = Price, item_base_id = ItemBaseId, type = Type, quantity = Quantity, saler_name = SalerName, saler_lev = SalerLev, saler_career = Career}) ->
    Sql = <<"insert into sys_market_sale2 (sale_id, role_id, srv_id, begin_time, end_time, origin_price, price, quantity, item_base_id, type, saler_name, saler_lev, saler_career) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    db:execute(Sql, [SaleId, RoleId, SrvId, BeginTime, EndTime, Origin_Price, Price, Quantity, ItemBaseId, Type, SalerName, SalerLev, Career]).


%% 获取全部求购信息
get_all_buy() ->
    Sql = <<"select buy_id, role_id, srv_id, role_name, begin_time, end_time, assets_type, unit_price, quantity, item_base_id, item_name, type, quality, lev, career from sys_market_buy">>,
    case db:get_all(Sql, []) of
        {ok, []} ->
            {false, []};
        {ok, Data} ->
            {true, Data};
        {error, _Msg} ->
            ?INFO("执行数据库出错了[Msg:~w]", [_Msg]),
            {false, []}
    end.

%% 删除求购信息
delete_buy(BuyId) ->
    Sql = <<"delete from sys_market_buy where buy_id = ~s">>,
    db:execute(Sql, [BuyId]).

%% 插入求购信息
insert_buy(#market_buy{buy_id = BuyId, role_id = RoleId, srv_id = SrvId, role_name = RoleName, begin_time = BeginTime, end_time = EndTime, assets_type = AssetsType, unit_price = UnitPrice, quantity = Quantity, item_base_id = ItemBaseId, item_name = ItemName, type = Type, quality = Quality, lev = Lev, career = Career}) ->
    Sql = <<"insert into sys_market_buy (buy_id, role_id, srv_id, role_name, begin_time, end_time, assets_type, unit_price, quantity, item_base_id, item_name, type, quality, lev, career) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>,
    db:execute(Sql, [BuyId, RoleId, SrvId, RoleName, BeginTime, EndTime, AssetsType, UnitPrice, Quantity, ItemBaseId, ItemName, Type, Quality, Lev, Career]).

%% 更新求购数量
update_buy_quantity(BuyId, Quantity) ->
    Sql = <<"update sys_market_buy set quantity = ~s where buy_id = ~s">>,
    db:execute(Sql, [Quantity, BuyId]).

%% 获取得主键值
get_key(KeyType) ->
    Sql = <<"select value from sys_market where key_type = ~s">>,
    case db:get_one(Sql, [KeyType]) of
        {error, _Msg} ->
            {false, 0};
        {ok, Value} ->
            {true, Value}
    end.

%% 新增一条主键类型
insert_key(KeyType) ->
    Sql = <<"insert into sys_market(key_type, value) values (~s, ~s)">>,
    db:execute(Sql, [KeyType, 1]).

%% 更新键值
update_key(KeyType) ->
    Sql = <<"update sys_market set value = (value + 1) where key_type = ~s">>,
    case db:execute(Sql, [KeyType]) of
        {ok, Affected} ->
            Affected;
        {error, _Msg} ->
            ?INFO("更新市场主键出错了[Msg:~w]", [_Msg]),
            0
    end.

