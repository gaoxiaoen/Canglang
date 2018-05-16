%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 七月 2017 17:05
%%%-------------------------------------------------------------------
-module(act_double).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    get_dungeon_act/0,
    get_dungeon_mult/0,
    get_xj_map_act/0,
    get_xj_map_mult/0,
    get_xj_map_double_time/0,
    get_mon_drop_act/0
]).

get_dungeon_act() ->
    case activity:get_work_list(data_act_dungeon_double) of
        [] -> [];
        [Base | _] -> Base
    end.

get_dungeon_mult() ->
    case get_dungeon_act() of
        [] -> 1;
        _ -> 2
    end.

get_xj_map_act() ->
    case activity:get_work_list(data_act_xj_map_double) of
        [] -> [];
        [Base | _] -> Base
    end.

get_xj_map_mult() ->
    case get_xj_map_act() of
        [] -> 1;
        _ -> 2
    end.

get_xj_map_double_time() ->
    case get_xj_map_act() of
        [] -> 0;
        #base_act_xj_map_double{open_info = OpenInfo} ->
            activity:calc_act_leave_time(OpenInfo)
    end.

get_mon_drop_act() ->
    case activity:get_work_list(data_act_mon_drop) of
        [] -> 0;
        [_Base | _] -> 1
    end.