%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 十一月 2017 11:38
%%%-------------------------------------------------------------------
-module(field_boss_init).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("field_boss.hrl").

%% API
-export([
    init/0,
    log_out/0,
    init_data/0
]).

init() ->
    ets:new(?ETS_FIELD_BOSS, [{keypos, #field_boss.scene_id} | ?ETS_OPTIONS]),
    ets:new(?ETS_FIELD_BOSS_POINT, [{keypos, #f_point.pkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_FIELD_BOSS_ROLL, [{keypos, #f_roll.mkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_FIELD_BOSS_BUY, [{keypos, #ets_field_boss_buy.pkey} | ?ETS_OPTIONS]),
    field_boss:init_field_boss(),
    spawn(fun() -> timer:sleep(200), init_data() end),
    ok.

init_data() ->
    case config:is_center_node() of
        true -> skip;
        _ ->
            FpointList = field_boss_load:load_all(),
            F = fun(F_point) ->
                ets:insert(?ETS_FIELD_BOSS_POINT, F_point)
            end,
            lists:map(F, FpointList),

            EtsFieldBossBuyList = field_boss_load:load_all_buy(),
            F99 = fun(Buy) ->
                ets:insert(?ETS_FIELD_BOSS_BUY, Buy)
            end,
            lists:map(F99, EtsFieldBossBuyList),
            ok
    end.

log_out() ->
    EtsList = ets:tab2list(?ETS_FIELD_BOSS_POINT),
    F = fun(Ets) ->
        ?DEBUG("Ets:~p", [Ets]),
        field_boss_load:update(Ets)
    end,
    lists:map(F, EtsList).