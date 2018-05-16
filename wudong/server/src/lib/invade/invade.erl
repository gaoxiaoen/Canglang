%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 二月 2016 14:55
%%%-------------------------------------------------------------------
-module(invade).
-author("hxming").

-include("scene.hrl").
-include("invade.hrl").
-include("common.hrl").

-compile(export_all).

%%击杀怪物
kill_mon(Mon, KList) ->
    if Mon#mon.kind == ?MON_KIND_INVADE_MON ->
        ?CAST(invade_proc:get_server_pid(), {kill_mon, Mon#mon.pid, Mon#mon.mid, Mon#mon.copy, Mon#mon.d_x, Mon#mon.d_y, KList});
        true ->
            skip
    end.


collect(Mon, Pkey) ->
    if Mon#mon.kind == ?MON_KIND_INVADE_BOX ->
        ?CAST(invade_proc:get_server_pid(), {collect, Mon#mon.pid, Pkey});
        true -> skip
    end.