%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 14:24
%%%-------------------------------------------------------------------
-module(guild_war_init).
-author("hxming").

-include("guild_war.hrl").
%% API
-export([init/0, init_figure/0]).


init() ->
    Data = guild_war_load:get_all(),
    F = fun([Gkey, Group, Time], Dict) ->
        dict:store(Gkey, #guild_war{gkey = Gkey, group = Group, time = Time}, Dict)
        end,
    NewDict = lists:foldl(F, dict:new(), Data),
    case dict:size(NewDict) > 0 of
        false ->
            erlang:send_after(10 * 1000, self(), {auto_apply});
        true ->
            skip
    end,
    NewDict.

init_figure() ->
    Data = guild_war_load:load_figure(),
    F = fun([Pkey, FigureList]) ->
        Record = #st_figure{pkey = Pkey, figure_list = guild_war_figure:format_figure(FigureList)},
        ets:insert(?ETS_ST_FIGURE, Record)
        end,
    lists:foreach(F, Data),
    ok.
