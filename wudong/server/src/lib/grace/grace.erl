%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 二月 2016 15:35
%%%-------------------------------------------------------------------
-module(grace).
-author("hxming").

-include("scene.hrl").
-include("grace.hrl").
-include("achieve.hrl").
%% API
-compile(export_all).

update_collect_count(Pkey) ->
    achieve:trigger_achieve(Pkey, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4016, 0, 1),
        catch grace_proc:get_server_pid() ! {update_collect_count, Pkey}.
