%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2017 11:21
%%%-------------------------------------------------------------------
-module(plant_rpc).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("plant.hrl").
-include("daily.hrl").
%% API
-export([handle/3]).

%%获取植物列表
handle(15901, Player, {}) ->
    ?CAST(plant_proc:get_server_pid(), {plant_list, Player#player.sid}),
    ok;

%%种植
handle(15902, Player, {GoodsKey, X, Y}) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    {Ret, NewPlayer} =
        case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
            {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} -> {2, Player};
            Goods ->
                case data_plant:get(Goods#goods.goods_id) of
                    [] -> {2, Player};
                    BaseData ->
                        Now = util:unixtime(),
                        if
                            Goods#goods.expire_time < Now -> {3, Player};
                            true ->
                                case ?CALL(plant_proc:get_server_pid(), {plant, Player#player.key, Goods#goods.goods_id, X, Y, BaseData#base_plant.grow_time + Now}) of
                                    ok ->
                                            catch goods_util:reduce_goods_key_list(Player, [{GoodsKey, 1}], 267),
                                        GiveGoodsList = goods:make_give_goods_list(267, BaseData#base_plant.plant_goods),
                                        {ok, Player1} = goods:give_goods(Player, GiveGoodsList),
                                        {1, Player1};
                                    [] -> {0, Player};
                                    {fail, Code} -> {Code, Player}
                                end
                        end
                end
        end,
    {ok, Bin} = pt_159:write(15902, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%查询植物信息
handle(15905, Player, {Key}) ->
    WaterTimes = daily:get_count(?DAILY_PLANT_WATER_TIMES),
    ?CAST(plant_proc:get_server_pid(), {plant_info, Player#player.key, Player#player.sid, Key, WaterTimes, Player#player.vip_lv}),
    ok;

%%浇水
handle(15906, Player, {Key}) ->
    WaterTimes = daily:get_count(?DAILY_PLANT_WATER_TIMES),
    case ?CALL(plant_proc:get_server_pid(), {plant_water, Player, Key, WaterTimes}) of
        [] ->
            {ok, Bin} = pt_159:write(15906, {0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, GoodsList} ->
            GiveGoodsList = goods:make_give_goods_list(267, GoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            {ok, Bin} = pt_159:write(15906, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            daily:increment(?DAILY_PLANT_WATER_TIMES, 1),
            {ok, NewPlayer};
        {fail, Err} ->
            {ok, Bin} = pt_159:write(15906, {Err}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%采集
handle(15907, Player, {Key, Type}) ->
    case ?CALL(plant_proc:get_server_pid(), {plant_collect, Player#player.key, Key, Type, Player#player.vip_lv}) of
        [] ->
            {ok, Bin} = pt_159:write(15907, {0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok -> ok;
        {ok, GoodsList} ->
            GiveGoodsList = goods:make_give_goods_list(268, GoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            {ok, Bin} = pt_159:write(15907, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {fail, Err} ->
            {ok, Bin} = pt_159:write(15907, {Err}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%获取我的种植列表
handle(15908, Player, {}) ->
    WaterTimes = daily:get_count(?DAILY_PLANT_WATER_TIMES),
    ?CAST(plant_proc:get_server_pid(), {my_plant, Player, WaterTimes}),
    ok;

%%查询我的种植状态
handle(15909, Player, {}) ->
    ?CAST(plant_proc:get_server_pid(), {plant_state, Player}),
    ok;

handle(_Cmd, _Player, {}) ->
    ok.
