%%----------------------------------------------------
%% @doc 市场拍卖信息表
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_market_sale).

-export([]).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
        ,update_srv_id/1
        ,delete_expire/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

%%----------------------------------------------------
%% API
%%----------------------------------------------------
do_init(Table = #merge_table{server = #merge_server{data_source = DataSource}}) ->
    Sql = "select sale_id, role_id, srv_id, begin_time, end_time, assets_type, price, item_id, item_base_id, item_name, type, use_type, bind, source, quality, lev, career, upgrade, enchant, enchant_fail, quantity, status, pos, lasttime, durability, attr, special, max_base_attr, saler_name, saler_lev from sys_market_sale",
    case merge_db:get_all4page(DataSource, Sql, [], 3000) of
        {ok, Data} -> 
            MaxSaleId = max_sale_id(?merge_target),
            {ok, Data, Table#merge_table{next_key = MaxSaleId + 1}};
        {error, Reason} -> {error, Reason}
    end.

do_convert([], Table) -> {ok, Table};
do_convert([[SaleId, RoleId, SrvId, BeginTime, EndTime, AssetsType, Price, ItemId, ItemBaseId, ItemName, Type, UseType, Bind, Source, Quality, Lev, Career, Upgrade, Enchant, EnchantFail, Quantity, Status, Pos, Lasttime, Durability, Attr, Special, MaxBaseAttr, SalerName, SalerLev] | T], Table = #merge_table{next_key = NextKey}) ->
    Sql = "insert into sys_market_sale (sale_id, role_id, srv_id, begin_time, end_time, assets_type, price, item_id, item_base_id, item_name, type, use_type, bind, source, quality, lev, career, upgrade, enchant, enchant_fail, quantity, status, pos, lasttime, durability, attr, special, max_base_attr, saler_name, saler_lev) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    NewSaleId = case SaleId > NextKey of
        true -> SaleId;
        false -> NextKey
    end,
    case merge_db:execute(?merge_target, Sql, [NewSaleId, RoleId, SrvId, BeginTime, EndTime, AssetsType, Price, ItemId, ItemBaseId, ItemName, Type, UseType, Bind, Source, Quality, Lev, Career, Upgrade, Enchant, EnchantFail, Quantity, Status, Pos, Lasttime, Durability, Attr, Special, MaxBaseAttr, SalerName, SalerLev]) of
        {ok, 1} ->
            do_convert(T, Table#merge_table{next_key = NewSaleId + 1});
        {error, Reason} ->
            {error, Reason}
    end.

do_end(#merge_table{server = #merge_server{index = Size, size = Size}}) ->
    MaxSaleId = max_sale_id(?merge_target),
    Sql = <<"update sys_keyval set value = ~s where key_type = ~s">>,
    case merge_db:execute(?merge_target, Sql, [MaxSaleId + 1, market_key_sale]) of
        {ok, _Affected} -> ok; 
        {error, Reason} ->
            ?ERR("更新健值出错了[KeyType:~w, Msg:~w]", [market_key_sale, Reason]),
            {false, Reason}
    end;
do_end(_Table) -> ok.

%% 纠正SrvId
update_srv_id(Table) ->
    merge_util:update_srv_id(Table, "srv_id").

%% 删除数据(1级，15天未登录)
delete_expire(Table) ->
    merge_util:delete_expire(Table, <<"role_id, srv_id">>).

%%----------------------------------------------------
%%----------------------------------------------------
max_sale_id(DataSource) ->
    Sql = <<"select max(sale_id) from sys_market_sale">>,
    case merge_db:get_one(DataSource, Sql) of
        {ok, undefined} -> 1;
        {ok, Max} -> Max;
        {error, Msg} -> throw({db_error, max_sale_id, Msg})
    end.
