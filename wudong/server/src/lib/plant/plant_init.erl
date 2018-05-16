%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2017 10:40
%%%-------------------------------------------------------------------
-module(plant_init).
-author("hxming").
-include("plant.hrl").

%% API
-export([
    init/0,
    init_mb/0,
    check_plant_state/2]).


init() ->
    Data = plant_load:load_plant_all(),
    Now = util:unixtime(),
    F = fun([Key, Pkey, GoodsId, PlantState, Time, X, Y, WaterTimes, WaterTime, Collect, Log]) ->
        Plant =
            #plant{
                key = Key,
                pkey = Pkey,
                goods_id = GoodsId,
                plant_state = PlantState,
                time = Time,
                x = X,
                y = Y,
                water_times = WaterTimes,
                water_time = WaterTime,
                collect = util:bitstring_to_term(Collect),
                log = util:bitstring_to_term(Log)
            },
        check_plant_state(Plant, Now)
        end,
    lists:flatmap(F, Data).

check_plant_state(Plant, Now) ->
    if
        Plant#plant.plant_state == ?PLANT_STATE_GROW ->
            if Plant#plant.time > Now -> [Plant];
                true ->
                    NewPlant = Plant#plant{plant_state = ?PLANT_STATE_WATER},
                    plant_load:replace_plant(NewPlant),
                    plant:refresh_plant(NewPlant),
                    [NewPlant]
            end;
        Plant#plant.plant_state == ?PLANT_STATE_WATER ->
            BaseData = data_plant:get(Plant#plant.goods_id),
            case Plant#plant.water_times >= BaseData#base_plant.water_times of
                true ->
                    [Plant#plant{plant_state = ?PLANT_STATE_BUD, time = BaseData#base_plant.bud_time + Now}];
                false ->
                    [Plant]
            end;
        Plant#plant.plant_state == ?PLANT_STATE_BUD ->
            if Plant#plant.time > Now -> [Plant];
                true ->
                    NewPlant = Plant#plant{plant_state = ?PLANT_STATE_RIPE},
                    plant_load:replace_plant(NewPlant),
                    plant:refresh_plant(NewPlant),
                    self() ! {plant_state, Plant#plant.pkey},
                    [NewPlant]
            end;
        Plant#plant.plant_state == ?PLANT_STATE_RIPE ->
            BaseData = data_plant:get(Plant#plant.goods_id),
            case length(Plant#plant.collect) >= BaseData#base_plant.collect_times of
                true ->
                    plant_load:del_plant(Plant#plant.key),
                    [];
                false ->
                    [Plant]
            end;
        true ->
            []
    end.

init_mb() ->
    Data = plant_load:load_plant_mb_all(),
    F = fun([Pkey, CollectTimes]) ->
        #plant_mb{pkey = Pkey, collect_times = CollectTimes}
        end,
    lists:map(F, Data).