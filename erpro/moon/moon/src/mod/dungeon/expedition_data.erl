%%----------------------------------------------------
%% 远征王军数据
%% @author mobin
%% @end
%%----------------------------------------------------
-module(expedition_data).
-export([
        cooperation/2
        ,get/1
        ,change_items/0
    ]
).
-include("change.hrl").
-include("dungeon.hrl").

cooperation(20, 2) ->
    5;

cooperation(20, 3) ->
    10;

cooperation(30, 2) ->
    8;

cooperation(30, 3) ->
    16;

cooperation(40, 2) ->
    10;

cooperation(40, 3) ->
    20;

cooperation(50, 2) ->
    10;

cooperation(50, 3) ->
    20;

cooperation(_, _) ->
    0.

get(16000) ->
    [16012, 16015];

get(16003) ->
    [16006, 16009];

get(16122) ->
    [];

get(16018) ->
    [16030];

get(16021) ->
    [16024];

get(16027) ->
    [16033, 16123];

get(16036) ->
    [];

get(16039) ->
    [16042];

get(16045) ->
    [16048, 16051, 16124];

get(16054) ->
    [];

get(16057) ->
    [16060, 16063, 16066, 16069];

get(16125) ->
    [];

get(16072) ->
    [];

get(16075) ->
    [];

get(16081) ->
    [16078, 16084, 16087, 16126];

get(16090) ->
    [16096];

get(16093) ->
    [16102, 16105];

get(16099) ->
    [16127];

get(16128) ->
    [16134, 16137];

get(16131) ->
    [16140, 16143];

get(16146) ->
    [];

get(16147) ->
    [16156];

get(16150) ->
    [16159];

get(16153) ->
    [16162, 16165];

get(_) ->
    [].

change_items() ->
    [
        #change_item{id = 1, base_id = 111601, price = 80, count = 1, bind = 1},
        #change_item{id = 2, base_id = 111602, price = 80, count = 1, bind = 1},
        #change_item{id = 3, base_id = 111603, price = 80, count = 1, bind = 1},
        #change_item{id = 4, base_id = 111451, price = 30, count = 10, bind = 1},
        #change_item{id = 5, base_id = 111452, price = 60, count = 5, bind = 1},
        #change_item{id = 6, base_id = 111611, price = 360, count = 1, bind = 1},
        #change_item{id = 7, base_id = 111612, price = 360, count = 1, bind = 1},
        #change_item{id = 8, base_id = 111613, price = 360, count = 1, bind = 1},
        #change_item{id = 9, base_id = 111453, price = 40, count = 20, bind = 1},
        #change_item{id = 10, base_id = 111454, price = 80, count = 6, bind = 1},
        #change_item{id = 11, base_id = 111621, price = 600, count = 1, bind = 1},
        #change_item{id = 12, base_id = 111622, price = 600, count = 1, bind = 1},
        #change_item{id = 13, base_id = 111623, price = 600, count = 1, bind = 1},
        #change_item{id = 14, base_id = 111455, price = 50, count = 20, bind = 1},
        #change_item{id = 15, base_id = 111456, price = 80, count = 6, bind = 1},
        #change_item{id = 16, base_id = 621201, price = 120, count = 5, bind = 1}
    ].
