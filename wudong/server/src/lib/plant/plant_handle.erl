%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2017 10:38
%%%-------------------------------------------------------------------
-module(plant_handle).
-author("hxming").

-include("plant.hrl").
-include("scene.hrl").
-include("common.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

handle_call({plant, Pkey, GoodsId, X, Y, Time}, _From, State) ->
    Plant = #plant{
        key = misc:unique_key(),
        pkey = Pkey,
        goods_id = GoodsId,
        plant_state = ?PLANT_STATE_GROW,
        time = Time,
        x = X,
        y = Y
    },
    plant_load:replace_plant(Plant),
    plant:refresh_plant(Plant),
    PlantList = [Plant | State#st_plant.plant_list],
    self() ! {plant_state, Pkey},
    {replu, ok, State#st_plant{plant_list = PlantList}};

handle_call({plant_water, Player, Key, DailyWaterTimes}, _from, State) ->
    case plant:plant_water(Player, Key, State#st_plant.plant_list, DailyWaterTimes) of
        {fail, Err} ->
            {reply, {fail, Err}, State};
        {ok, PlantList, GoodsList} ->
            {reply, {ok, GoodsList}, State#st_plant{plant_list = PlantList}}
    end;

handle_call({plant_collect, Player, Key, Type}, _from, State) ->
    case plant:plant_collect(Player, Key, Type, State#st_plant.plant_list, State#st_plant.mb_list) of
        {fail, Err} ->
            {reply, {fail, Err}, State};
        {ok, PlantList} ->
            {reply, ok, State#st_plant{plant_list = PlantList}};
        {ok, PlantList, MbList, GoodsList} ->
            {reply, {ok, GoodsList}, State#st_plant{plant_list = PlantList, mb_list = MbList}}
    end;

handle_call(_msg, _from, State) ->
    {reply, ok, State}.

%%获取植物列表
handle_cast({plant_list, Sid}, State) ->
    plant:plant_list(Sid, State#st_plant.plant_list),
    {noreply, State};

handle_cast({plant_info, Pkey, Sid, Key, WaterTimes, Vip}, State) ->
    case lists:keyfind(Key, #plant.key, State#st_plant.plant_list) of
        false -> skip;
        Plant ->
            CollectLim = plant:get_collect_lim(Vip),
            IsCollectLim =
                case lists:keyfind(Pkey, #plant_mb.pkey, State#st_plant.mb_list) of
                    false -> false;
                    Mb -> Mb#plant_mb.collect_times >= CollectLim
                end,
            plant:plant_info(Pkey, Sid, Plant, WaterTimes, IsCollectLim)
    end,
    {noreply, State};

handle_cast({my_plant, Player, WaterTimes}, State) ->
    plant:my_plant(Player, WaterTimes, State#st_plant.plant_list, State#st_plant.mb_list),
    {noreply, State};


handle_cast({plant_state, Player}, State) ->
    PlantState =
        case [Plant || Plant <- State#st_plant.plant_list, Plant#plant.pkey == Player#player.key] of
            [] -> 0;
            PlantList ->
                F = fun(Plant) -> Plant#plant.plant_state == ?PLANT_STATE_RIPE end,
                case lists:any(F, PlantList) of
                    false -> 1;
                    true -> 2
                end
        end,
    {ok, Bin} = pt_159:write(15909, {PlantState}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {noreply, State};

handle_cast(_msg, State) ->
    {noreply, State}.


handle_info(init, State) ->
    PlantList = plant_init:init(),
    MbList = plant_init:init_mb(),
    {noreply, State#st_plant{plant_list = PlantList, mb_list = MbList}};


%%清理所有的植物
handle_info(reset_all, State) ->
    plant_load:clean_plant_mb(),
    plant_load:clean_plant(),
    F = fun(Plant) ->
        plant:delete_plant(Plant)
        end,
    lists:foreach(F, State#st_plant.plant_list),
    {noreply, State#st_plant{plant_list = [], mb_list = []}};

%%
handle_info(timer, State) ->
    misc:cancel_timer(timer),
    Ref = erlang:send_after(5000, self(), timer),
    put(timer, Ref),
    Now = util:unixtime(),
    F = fun(Plant) ->
        plant_init:check_plant_state(Plant, Now)
        end,
    PlantList = lists:flatmap(F, State#st_plant.plant_list),
    {noreply, State#st_plant{plant_list = PlantList}};


handle_info({plant_state, Pkey}, State) ->
    PlantState =
        case [Plant || Plant <- State#st_plant.plant_list, Plant#plant.pkey == Pkey] of
            [] -> 0;
            PlantList ->
                F = fun(Plant) -> Plant#plant.plant_state == ?PLANT_STATE_RIPE end,
                case lists:any(F, PlantList) of
                    false -> 1;
                    true -> 2
                end
        end,
    {ok, Bin} = pt_159:write(15909, {PlantState}),
    server_send:send_to_key(Pkey, Bin),
    {noreply, State};

handle_info(_msg, State) ->
    {noreply, State}.


