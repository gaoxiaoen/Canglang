%%-------------------------------------------------------------------
%% File              :mod_map_fb.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-11-04
%% @doc
%%     地图副本模块逻辑处理
%% @end
%%-------------------------------------------------------------------


-module(mod_map_fb).

-include("mgeem.hrl").

-export([get_fb_map_name/1,
         role_map_enter/2]).


get_fb_map_name(FbId) ->
    common_map:get_fb_map_name(FbId).

role_map_enter(_RoleId,_FbId) ->
    
    ok.