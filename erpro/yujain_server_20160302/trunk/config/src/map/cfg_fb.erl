%% Author: caochuncheng2002@gmail.com
%% Created: 2015-11-04
%% Description: 副本配置，不可以修改，必须由副本配置表生成

-module(cfg_fb).

-include("common.hrl").

-export([
         find/1,
         list/0,
         init_fb_maps/0
        ]).


find(20001) ->
    #r_fb_info{fb_id=20001,map_id=20001,fb_module=mod_map_fb,create_map_process_type=0,fb_type=1,create_avatar=0,min_number=1,times_type=1,enter_times=0,min_level=1,max_time=1800,protect_time=120,countdown=5};
find(20002) ->
    #r_fb_info{fb_id=20002,map_id=20001,fb_module=mod_map_fb,create_map_process_type=0,fb_type=1,create_avatar=1,min_number=1,times_type=1,enter_times=100,min_level=1,max_time=1800,protect_time=120,countdown=5};
find(30001) ->
    #r_fb_info{fb_id=30001,map_id=20001,fb_module=mod_map_arena_fb,create_map_process_type=1,fb_type=0,create_avatar=0,min_number=0,times_type=0,enter_times=0,min_level=1,max_time=0,protect_time=0,countdown=0};
find(30002) ->
    #r_fb_info{fb_id=30002,map_id=20001,fb_module=mod_map_battlefield_fb,create_map_process_type=0,fb_type=2,create_avatar=0,min_number=1,times_type=1,enter_times=100,min_level=1,max_time=1800,protect_time=120,countdown=5};
find(30003) ->
    #r_fb_info{fb_id=30003,map_id=20001,fb_module=mod_map_battlefield_fb,create_map_process_type=0,fb_type=2,create_avatar=0,min_number=1,times_type=1,enter_times=100,min_level=1,max_time=1800,protect_time=120,countdown=5};
find(_) -> 
    undefined.


list() -> 
    [20001,20002,30001,30002,30003].


init_fb_maps() -> 
    [30001].


