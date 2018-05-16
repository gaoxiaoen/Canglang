%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2017 10:40
%%%-------------------------------------------------------------------
-module(plant_load).
-author("hxming").

-include("plant.hrl").

%% API
-compile(export_all).

load_plant_all() ->
    Sql = "select `key`,pkey,goods_id,plant_state,time,x,y,water_times,water_time,collect,log from plant",
    db:get_all(Sql).

replace_plant(Plant) ->
    Sql = io_lib:format("replace into plant set `key`=~p,pkey=~p,goods_id=~p,plant_state=~p,time=~p,x=~p,y=~p,water_times=~p,water_time=~p,collect='~s',log='~s'",
        [Plant#plant.key,
            Plant#plant.pkey,
            Plant#plant.goods_id,
            Plant#plant.plant_state,
            Plant#plant.time,
            Plant#plant.x,
            Plant#plant.y,
            Plant#plant.water_times,
            Plant#plant.water_time,
            util:term_to_bitstring(Plant#plant.collect),
            util:term_to_bitstring(Plant#plant.log)]),
    db:execute(Sql).


del_plant(Key) ->
    Sql = io_lib:format("delete from plant where `key`=~p", [Key]),
    db:execute(Sql).

clean_plant() ->
    db:execute("truncate plant").


load_plant_mb_all() ->
    Sql = "select pkey,collect_times from plant_mb",
    db:get_all(Sql).

replace_plant_mb(Mb) ->
    Sql = io_lib:format("replace into plant_mb set pkey=~p,collect_times=~p",
        [Mb#plant_mb.pkey, Mb#plant_mb.collect_times]),
    db:execute(Sql).

clean_plant_mb() ->
    db:execute("truncate plant_mb").