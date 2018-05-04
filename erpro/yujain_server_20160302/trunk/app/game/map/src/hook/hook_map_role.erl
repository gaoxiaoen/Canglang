%% Author: caochuncheng2002@gmail.com
%% Created: 2013-5-17
%% Description: 地图Role Hook

-module(hook_map_role).

-include("mgeem.hrl").

-export([
         role_dead/3,
         role_online/1,
         role_offline/1,
         role_map_enter/2,
         role_map_enter_confirm/1,
         role_map_quit/1
        ]).


%% 玩家上线
role_online(RoleId) ->
    #r_map_state{fb_id=FbId} = MapState = mgeem_map:get_map_state(),
    case cfg_fb:find(FbId) of
        undefined ->
            next;
        _ ->
            ?TRY_CATCH(mod_common_fb:role_online(RoleId),ErrFb)
    end,
    ?TRY_CATCH(mod_map_chat:hook_role_online(RoleId,MapState),ErrChat),
    ok.
%% 玩家下线
role_offline(RoleId) ->
    #r_map_state{fb_id=FbId} = MapState = mgeem_map:get_map_state(),
    case cfg_fb:find(FbId) of
        undefined ->
            next;
        _ ->
            ?TRY_CATCH(mod_common_fb:role_offline(RoleId),ErrFb)
    end,
    ?TRY_CATCH(mod_map_pet:role_offline(RoleId),ErrPet),
    ?TRY_CATCH(mod_map_chat:hook_role_offline(RoleId,MapState),ErrChat),
    ok.

%% 进入地图，等待前端确认加载资源是否完成
-spec 
role_map_enter(RoleId,ExtInfo) -> ok when
    RoleId :: integer,
    ExtInfo :: [] | [{key,value},...].
role_map_enter(RoleId,ExtInfo) ->
    #r_map_state{fb_id=FbId} = mgeem_map:get_map_state(),
    case cfg_fb:find(FbId) of
        undefined ->
            next;
        _ ->
            ?TRY_CATCH(mod_common_fb:role_map_enter(RoleId,ExtInfo),ErrFb)
    end,
    ok.
%% 进入地图，前端确认已经加载资源
role_map_enter_confirm(RoleId) ->
    ?TRY_CATCH(mod_map_pet:role_map_enter_confirm(RoleId),ErrPet),
    ?TRY_CATCH(mod_map_chat:hook_role_map_enter_confirm(RoleId),ErrChat),
    ok.

%% 角色退出地图
role_map_quit(RoleId) ->
    ?TRY_CATCH(mod_map_chat:hook_role_map_quit(RoleId),ErrChat),
    ok.

% 玩家死亡
role_dead(_ActorId, _ActorType, _RoleId) ->
    
    ok.