%%----------------------------------------------------
%% @doc 求购信息表
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_market_buy).

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
    Sql = "select buy_id, role_id, srv_id, role_name, begin_time, end_time, assets_type, unit_price, quantity, item_base_id, item_name, type, quality, lev, career from sys_market_buy",
    case merge_db:get_all4page(DataSource, Sql, [], 3000) of
        {ok, Data} -> 
            MaxSaleId = max_buy_id(?merge_target),
            {ok, Data, Table#merge_table{next_key = MaxSaleId + 1}};
        {error, Reason} -> {error, Reason}
    end.

do_convert([], Table) -> {ok, Table};
do_convert([[BuyId, RoleId, SrvId, RoleName, BeginTime, EndTime, AssetsType, UnitPrice, Quantity, ItemBaseId, ItemName, Type, Quality, Lev, Career] | T], Table = #merge_table{next_key = NextKey}) ->
    Sql = "insert into sys_market_buy(buy_id, role_id, srv_id, role_name, begin_time, end_time, assets_type, unit_price, quantity, item_base_id, item_name, type, quality, lev, career) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    NewBuyId = case BuyId > NextKey of
        true -> BuyId;
        false -> NextKey
    end,
    case merge_db:execute(?merge_target, Sql, [NewBuyId, RoleId, SrvId, RoleName, BeginTime, EndTime, AssetsType, UnitPrice, Quantity, ItemBaseId, ItemName, Type, Quality, Lev, Career]) of
        {ok, 1} ->
            do_convert(T, Table#merge_table{next_key = NewBuyId + 1});
        {error, Reason} ->
            {error, Reason}
    end.

do_end(#merge_table{server = #merge_server{index = Size, size = Size}}) ->
    MaxSaleId = max_buy_id(?merge_target),
    Sql = <<"update sys_keyval set value = ~s where key_type = ~s">>,
    case merge_db:execute(?merge_target, Sql, [MaxSaleId + 1, market_key_buy]) of
        {ok, _Affected} -> ok; 
        {error, Reason} ->
            ?ERR("更新健值出错了[KeyType:~w, Msg:~w]", [market_key_buy, Reason]),
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
max_buy_id(DataSource) ->
    Sql = <<"select max(buy_id) from sys_market_buy">>,
    case merge_db:get_one(DataSource, Sql) of
        {ok, undefined} -> 1;
        {ok, Max} -> Max;
        {error, Msg} -> throw({db_error, max_buy_id, Msg})
    end.
