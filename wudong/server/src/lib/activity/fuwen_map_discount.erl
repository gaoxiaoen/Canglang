%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 四月 2018 15:01
%%%-------------------------------------------------------------------
-module(fuwen_map_discount).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").

%% API
-export([
    get_act/0,
    get_state/1,
    get_discount/0
]).

get_act() ->
    case activity:get_work_list(data_fuwen_map_discount) of
        [] -> [];
        [Base | _] -> Base
    end.

get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        #base_fuwen_map_discount{discount = Discount} ->
            {1, [{icon, Discount}]}
    end.

get_discount() ->
    case get_act() of
        [] -> 100;
        #base_fuwen_map_discount{discount = DisCount} ->
            %% 防止数值配置错误
            ?IF_ELSE(DisCount == 0, 100, DisCount)
    end.

