%%----------------------------------------------------
%% 商城商品数据配置
%% @author mobin
%%----------------------------------------------------
-module(shop_data).
-export([
        common_items/0
        ,open_items/1
        ,week_items/1
        ,special_items_info/0
    ]
).
-include("shop.hrl").
-include("item.hrl").

common_items() ->
    [
        #shop_item{id = 1, base_id = 221102, type = 1, price = 10, label = 0, alias = <<"金币">>},
        #shop_item{id = 2, base_id = 221103, type = 1, price = 10, label = 0, alias = <<"符石">>},
        #shop_item{id = 3, base_id = 601001, type = 1, price = 1, label = 0, alias = <<"背包">>},
        #shop_item{id = 4, base_id = 111001, type = 1, price = 2, label = 0, alias = <<"强化">>},
        #shop_item{id = 5, base_id = 621100, type = 1, price = 5, label = 0, alias = <<"潜能">>},
        #shop_item{id = 6, base_id = 111301, type = 1, price = 8, label = 0, alias = <<"鉴定">>},
        #shop_item{id = 7, base_id = 641201, type = 1, price = 10, label = 0, alias = <<"妖精">>},
        #shop_item{id = 8, base_id = 231001, type = 1, price = 10, label = 0, alias = <<"神源">>},
        #shop_item{id = 9, base_id = 611101, type = 1, price = 50, label = 0, alias = <<"炸弹">>},
        #shop_item{id = 10, base_id = 611102, type = 1, price = 150, label = 0, alias = <<"炸弹">>},
        #shop_item{id = 11, base_id = 111701, type = 1, price = 120, label = 0, alias = <<"卷轴">>}
    ].

special_items_info() ->
    [
        {#shop_item{id = 1, base_id = 221102, price = 8, label = 5, origin_price = 10, count = 200, type = 4}, 100},
        {#shop_item{id = 2, base_id = 111301, price = 6, label = 5, origin_price = 8, count = 200, type = 4}, 100},
        {#shop_item{id = 3, base_id = 131001, price = 8, label = 5, origin_price = 10, count = 200, type = 4}, 100},
        {#shop_item{id = 4, base_id = 231001, price = 8, label = 5, origin_price = 10, count = 200, type = 4}, 100},
        {#shop_item{id = 5, base_id = 641201, price = 8, label = 5, origin_price = 10, count = 200, type = 4}, 100},
        {#shop_item{id = 6, base_id = 111701, price = 98, label = 5, origin_price = 120, count = 30, type = 4}, 100},
        {#shop_item{id = 7, base_id = 111102, price = 38, label = 5, origin_price = 50, count = 200, type = 4}, 100},
        {#shop_item{id = 8, base_id = 611101, price = 38, label = 4, origin_price = 50, count = 1, type = 4}, 100},
        {#shop_item{id = 9, base_id = 111701, price = 98, label = 4, origin_price = 120, count = 1, type = 4}, 100},
        {#shop_item{id = 10, base_id = 621501, price = 28, label = 4, origin_price = 40, count = 1, type = 4}, 100},
        {#shop_item{id = 11, base_id = 621502, price = 58, label = 4, origin_price = 75, count = 1, type = 4}, 100},
        {#shop_item{id = 12, base_id = 535603, price = 168, label = 4, origin_price = 200, count = 1, type = 4}, 20},
        {#shop_item{id = 13, base_id = 611102, price = 128, label = 4, origin_price = 150, count = 1, type = 4}, 50}
    ].

open_items(1) ->
    [
    ];
open_items(2) ->
    [
    ];
open_items(3) ->
    [
    ];
open_items(4) ->
    [
    ];
open_items(5) ->
    [
    ];
open_items(6) ->
    [
    ];
open_items(7) ->
    [
    ];
open_items(_) ->
    [].

week_items(1) ->
    [
    ];
week_items(2) ->
    [
    ];
week_items(3) ->
    [
    ];
week_items(4) ->
    [
    ];
week_items(5) ->
    [
    ];
week_items(6) ->
    [
    ];
week_items(7) ->
    [
    ];
week_items(_) ->
    [].

