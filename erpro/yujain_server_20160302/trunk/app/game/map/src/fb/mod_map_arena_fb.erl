%%-------------------------------------------------------------------
%% File              :mod_map_arena_fb.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-11-11
%% @doc
%%     擂台副本
%% @end
%%-------------------------------------------------------------------


-module(mod_map_arena_fb).

-include("mgeem.hrl").

-export([get_fb_map_name/1,
         role_map_enter/2]).


get_fb_map_name(FbId) ->
    common_map:get_fb_alive_map_name(FbId).

role_map_enter(_RoleId,_FbId) ->
    
    ok.
