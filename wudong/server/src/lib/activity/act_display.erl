%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 广告显示
%%% @end
%%% Created : 22. 九月 2017 10:16
%%%-------------------------------------------------------------------
-module(act_display).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("daily.hrl").

%% API
-export([
    get_act_info/0,
    get_act/0,
    gm/1
]).

get_act_info() ->
    case get_act() of
        #base_display{display_id = DisplayId} ->
            DisplayId;
%%             case daily:get_count(?DAILY_DISPLAY) of
%%                 0 ->
%%                     daily:set_count(?DAILY_DISPLAY, 1),
%%                     DisplayId;
%%                 _ ->
%%                     {0, 0, 0}
%%             end;
        _ ->
            {0, 0, 0, 0, 0}
    end.

get_act() ->
    case activity:get_work_list(data_act_display) of
        [] -> [];
        [Base | _] -> Base
    end.

gm(Player) ->
    case get_act() of
        [] ->
            {0, 0, 0, 0, 0};
        #base_display{display_id = DisplayId} ->
            ?DEBUG("DisplayId:~p", [DisplayId]),
            {ok,Bin} = pt_439:write(43913, DisplayId),
            server_send:send_to_sid(Player#player.sid, Bin)
    end.