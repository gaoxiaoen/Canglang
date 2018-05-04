%%-------------------------------------------------------------------
%% File              :mod_map_avatar.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-11-05
%% @doc
%%     地图场景 Avatar对角显示处理
%% @end
%%-------------------------------------------------------------------


-module(mod_map_avatar).

-include("mgeem.hrl").

-export([handle/1]).

handle({init_avatar,Info}) ->
    do_init_avatar(Info);

handle({del_avatar,Info}) ->
    do_del_avatar(Info);

handle(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

%% 初始map avatar
-spec
do_init_avatar(AvatarList) -> ok when
    AvatarList :: #p_map_avatar{} | [#p_map_avatar{}].
do_init_avatar(#p_map_avatar{avatar_id=_AvatarId}=MapAvaterInfo) ->
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    do_init_avatar2([MapAvaterInfo],McmModule);
do_init_avatar(AvatarList) ->
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    do_init_avatar2(AvatarList,McmModule).

do_init_avatar2([],_McmModule) ->
    ok;
do_init_avatar2([MapAvaterInfo|AvatarList],McmModule) ->
    #p_map_avatar{avatar_id=AvatarId,pos=#p_pos{x=X,y=Y}} = MapAvaterInfo,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    mod_map:set_actor_info(AvatarId, ?ACTOR_TYPE_AVATAR, MapAvaterInfo),
    mod_map:ref_tile_pos(AvatarId, ?ACTOR_TYPE_AVATAR, Tx, Ty),
    
    [#r_map_slice{slice_name=SliceName,slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
    mod_map:join_slice(SliceName, AvatarId, ?ACTOR_TYPE_AVATAR),
    %% 广播
    mod_map_actor:do_enter_slice_notify(AvatarId, ?ACTOR_TYPE_AVATAR, Slice9List),
    do_init_avatar2(AvatarList,McmModule).

%% 删除map avatar
-spec
do_del_avatar(AvatarIdList) -> ok when
    AvatarIdList :: avatar_id | [avatar_id].
do_del_avatar(AvatarId) when erlang:is_integer(AvatarId) ->
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    do_del_avatar2([AvatarId],McmModule);
do_del_avatar(AvatarIdList) ->
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    do_del_avatar2(AvatarIdList,McmModule).

do_del_avatar2([],_McmModule) ->
    ok;
do_del_avatar2([AvatarId|AvatarIdList],McmModule) ->
    case mod_map:get_actor_info(AvatarId, ?ACTOR_TYPE_AVATAR) of
        undefined ->
            next;
        #p_map_avatar{avatar_id=AvatarId,pos=#p_pos{x=X,y=Y}} ->
            {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
            [#r_map_slice{slice_name=SliceName,slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
            mod_map:erase_actor_info(AvatarId, ?ACTOR_TYPE_AVATAR),
            mod_map:deref_tile_pos(AvatarId, ?ACTOR_TYPE_AVATAR, Tx, Ty),
            mod_map:leave_slice(SliceName, AvatarId, ?ACTOR_TYPE_AVATAR),
            mod_map_actor:do_quit_slice_notify(AvatarId,?ACTOR_TYPE_AVATAR,Slice9List)
    end,
    do_del_avatar2(AvatarIdList,McmModule).
