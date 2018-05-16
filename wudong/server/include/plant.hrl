%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2017 10:20
%%%-------------------------------------------------------------------
-author("hxming").
-ifndef(PLANT_HRL).
-define(PLANT_HRL, 1).

%%生长期
-define(PLANT_STATE_GROW, 1).
%%缺水期
-define(PLANT_STATE_WATER, 2).
%%花蕾期
-define(PLANT_STATE_BUD, 3).
%%成熟期
-define(PLANT_STATE_RIPE, 4).

-define(PLANT_DAILY_WATER_TIMES_LIM, 10).

-record(st_plant, {
    plant_list = [],
    mb_list = []
}).


-record(plant, {
    key = 0,
    pkey = 0,
    goods_id = 0,
    plant_state = 0,
    time = 0,
    x = 0,
    y = 0,
    water_times = 0,
    water_time = 0,
    collect = [],
    log = []
}).

-record(plant_mb, {
    pkey = 0,
    collect_times = 0
}).

-record(base_plant, {
    goods_id = 0,
    plant_goods = [],
    water_goods = [],
    collect_goods = [],
    collect_times = 0,
    water_times = 0,
    grow_time = 0,
    water_time = 0,
    bud_time = 0,
    collect_time=0
}).
-endif.