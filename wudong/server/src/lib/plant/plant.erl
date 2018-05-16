%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2017 11:24
%%%-------------------------------------------------------------------
-module(plant).
-author("hxming").
-include("common.hrl").
-include("plant.hrl").
-include("scene.hrl").

%% API
-compile(export_all).


%%植物列表
plant_list(Sid, PlantList) ->
    F = fun(Plant) ->
        [Plant#plant.key, Plant#plant.goods_id, Plant#plant.x, Plant#plant.y, Plant#plant.plant_state]
        end,
    Data = lists:flatmap(F, PlantList),
    {ok, Bin} = pt_159:write(15901, {Data}),
    server_send:send_to_sid(Sid, Bin),
    ok.

%%查询植物信息
plant_info(Pkey, Sid, Plant, WaterTimes, IsCollectLim) ->
    Now = util:unixtime(),
    LeftTime = max(0, Plant#plant.time - Now),
    WaterLim = ?IF_ELSE(WaterTimes >= ?PLANT_DAILY_WATER_TIMES_LIM, 0, 1),
    BaseData = data_plant:get(Plant#plant.goods_id),
    F = fun({Msg, Time}) -> [Msg, Now - Time] end,
    LogList =
        lists:map(F, Plant#plant.log),
    Data =
        if Plant#plant.plant_state == ?PLANT_STATE_GROW ->
            {Plant#plant.key, Plant#plant.goods_id, Plant#plant.plant_state, LeftTime, 0, 0, WaterLim, 0, 0, 0, LogList};
            Plant#plant.plant_state == ?PLANT_STATE_WATER ->
                {Plant#plant.key, Plant#plant.goods_id, Plant#plant.plant_state, LeftTime, Plant#plant.water_times, BaseData#base_plant.water_times, WaterLim, 0, 0, 0, LogList};
            Plant#plant.plant_state == ?PLANT_STATE_BUD ->
                {Plant#plant.key, Plant#plant.goods_id, Plant#plant.plant_state, LeftTime, 0, 0, WaterLim, 0, 0, 0, LogList};
            true ->
                CanCollect =
                    if IsCollectLim -> 0;
                        true ->
                            case lists:member(Pkey, Plant#plant.collect) of
                                true -> 0;
                                false -> 1
                            end
                    end,
                {Plant#plant.key, Plant#plant.goods_id, Plant#plant.plant_state, 0, 0, 0, WaterLim, length(Plant#plant.collect), BaseData#base_plant.collect_times, CanCollect, LogList}
        end,
    {ok, Bin} = pt_159:write(15905, Data),
    server_send:send_to_sid(Sid, Bin),
    ok.

%%查询我的种植
my_plant(Player, WaterTimes, PlantList, MbList) ->
    Now = util:unixtime(),
    F = fun(Plant, {L, Log}) ->
        if Player#player.key =/= Plant#plant.pkey -> {L, Log};
            true ->
                BaseData = data_plant:get(Plant#plant.goods_id),
                LeftTime = max(0, Plant#plant.time - Now),
                Info = [Plant#plant.key, Plant#plant.goods_id, Plant#plant.x, Plant#plant.y, Plant#plant.plant_state, LeftTime, Plant#plant.water_times, BaseData#base_plant.water_times, length(Plant#plant.collect), BaseData#base_plant.collect_times],
                {[Info | L], Plant#plant.log ++ Log}
        end
        end,
    {Data, LogList} = lists:foldl(F, {[], []}, PlantList),
    CollectTimes =
        case lists:keyfind(Player#player.key, #plant_mb.pkey, MbList) of
            false -> 0;
            Mb -> Mb#plant_mb.collect_times
        end,
    F1 = fun({Msg, Time}) -> [Msg, Now - Time] end,
    LogInfoList = lists:map(F1, lists:keysort(1, LogList)),
    CollectLim = get_collect_lim(Player#player.vip_lv),
    {ok, Bin} = pt_159:write(15908, {WaterTimes, ?PLANT_DAILY_WATER_TIMES_LIM, CollectTimes, CollectLim, Data, LogInfoList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.


get_collect_lim(_Vip) ->
    10.

%%通知刷新/新增植物
refresh_plant(Plant) ->
    Data = {Plant#plant.key, Plant#plant.goods_id, Plant#plant.x, Plant#plant.y, Plant#plant.plant_state},
    {ok, Bin} = pt_159:write(15903, Data),
    server_send:send_to_scene(?SCENE_ID_MAIN, Bin),
    ok.

%%通知删除植物
delete_plant(Plant) ->
    {ok, Bin} = pt_159:write(15903, {Plant#plant.key}),
    server_send:send_to_scene(?SCENE_ID_MAIN, Bin),
    ok.

%%浇水
plant_water(Player, Key, PlantList, DailyWaterTimes) ->
    case lists:keytake(Key, #plant.key, PlantList) of
        false ->
            {fail, 4};
        {value, Plant, T} ->
            Now = util:unixtime(),
            if Plant#plant.plant_state /= ?PLANT_STATE_WATER ->
                {fail, 5};
                Plant#plant.time > Now ->
                    {fail, 5};
                DailyWaterTimes >= ?PLANT_DAILY_WATER_TIMES_LIM ->
                    {fail, 6};
                true ->
                    BaseData = data_plant:get(Plant#plant.goods_id),
                    WaterTimes = Plant#plant.water_times + 1,
                    Msg = io_lib:format("~s对花儿进行了浇水操作,快去感谢TA吧", [t_tv:pn(Player)]),
                    Log = [{Msg, Now} | Plant#plant.log],
                    NewPlant =
                        if WaterTimes >= BaseData#base_plant.water_times ->
                            Plant1 = Plant#plant{plant_state = ?PLANT_STATE_BUD, time = Now + BaseData#base_plant.bud_time, log = Log},
                            refresh_plant(Plant1),
                            Plant1;
                            true ->
                                Plant#plant{water_times = WaterTimes, water_time = Now + BaseData#base_plant.water_time, log = Log}
                        end,
                    plant_load:replace_plant(NewPlant),
                    {ok, [NewPlant | T], BaseData#base_plant.water_goods}
            end
    end.

plant_collect(Player, Key, Type, PlantList, MbList) ->
    case lists:keytake(Key, #plant.key, PlantList) of
        false ->
            {fail, 4};
        {value, Plant, T} ->
            if Plant#plant.plant_state /= ?PLANT_STATE_RIPE ->
                {fail, 7};
                true ->
                    Now = util:unixtime(),
                    BaseData = data_plant:get(Plant#plant.goods_id),
                    Mb = get_mb(Player#player.key, MbList),
                    CollectLim = plant:get_collect_lim(Player#player.vip_lv),
                    if Mb#plant_mb.collect_times >= CollectLim ->
                        {fail, 9};
                        true ->
                            case Type of
                                1 ->
                                    if Plant#plant.time > Now ->
                                        {fail, 8};
                                        true ->
                                            NewPlant = Plant#plant{time = Now + BaseData#base_plant.collect_time},
                                            {ok, [NewPlant | T]}
                                    end;
                                _2 ->
                                    if Plant#plant.time - 1 > Now ->
                                        {fail, 0};
                                        true ->
                                            Collect = [Player#player.key | Plant#plant.collect],
                                            NewMb = Mb#plant_mb{collect_times = Mb#plant_mb.collect_times + 1},
                                            plant_load:replace_plant_mb(NewMb),
                                            MbList = [NewMb | lists:keydelete(Player#player.key, #plant_mb.pkey, MbList)],
                                            case length(Collect) >= BaseData#base_plant.collect_times of
                                                true ->
                                                    delete_plant(Plant),
                                                    plant_load:del_plant(Key),
                                                    self() ! {plant_state, Plant#plant.pkey},
                                                    {ok, T, MbList, BaseData#base_plant.collect_goods};
                                                false ->
                                                    Msg = io_lib:format("~s对花儿进行了采集操作,快去感谢TA吧", [t_tv:pn(Player)]),
                                                    Log = [{Msg, Now} | Plant#plant.log],
                                                    NewPlant = Plant#plant{collect = Collect, log = Log},
                                                    {ok, [NewPlant | T], MbList, BaseData#base_plant.collect_goods}
                                            end
                                    end
                            end
                    end
            end
    end.


get_mb(Pkey, MbList) ->
    case lists:keytake(Pkey, #plant_mb.pkey, MbList) of
        false ->
            #plant_mb{pkey = Pkey};
        Mb -> Mb
    end.
