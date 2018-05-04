%% Author: caochuncheng2002@gmail.com
%% Created: 2013-8-23
%% Description: 帮派hook
-module(hook_family).

%%
%% Include files
%%
-include("mgeew.hrl").
%%
%% Exported Functions
%%
-export([
         role_online/2,
         role_offline/2,
         
         
         create_family/1,
         join_family/1,
         leave_family/1
         ]).

%% 玩家上线
role_online(RoleId,RoleBase) ->
    #p_role_base{role_name = RoleName,
                 family_id = FamilyId,
                 sex = Sex,
                 level = Level,
                 category = Category,
                 last_login_time = LastLoginTime} = RoleBase,
    Param = {RoleId,RoleName,Sex,Level,Category,LastLoginTime},
    case FamilyId> 0 of
        true ->
            FamilyName = common_family:get_family_process_name(FamilyId),
            case erlang:whereis(FamilyName) of
                undefined -> %% 创建帮派进程
                    case common_family:create_family_process(?FAMILY_PROCESS_OP_TYPE_INIT,FamilyId) of
                        {ok,FamilyPId} ->
                            FamilyPId ! {role_online,Param};
                        _ ->
                            ignore
                    end;
                FamilyPId ->
                    FamilyPId ! {role_online,Param}
            end;
        _ ->
            ignore
    end.
%% 玩家下线
role_offline(RoleId,RoleBase) ->
    #p_role_base{family_id = FamilyId,
                 level = Level} = RoleBase,
    Param = {RoleId,Level},
    case FamilyId> 0 of
        true ->
            FamilyName = common_family:get_family_process_name(FamilyId),
            case erlang:whereis(FamilyName) of
                undefined ->
                    ignore;
                FamilyPId ->
                    FamilyPId ! {role_offline,Param}
            end;
        _ ->
            ignore
    end.

%% 创建帮派hook，同时会触发加入帮派hook
create_family({_RoleId,_FamilyId,_FamilyName}) ->
	
    ok.

%% 加入帮派hook
join_family({RoleId,FamilyId,FamilyName}) ->
    chat_misc:notice_join_channel(RoleId, ?CHANNEL_TYPE_FAMILY),
    hook_mission:trigger({mission_event,RoleId,?MISSION_EVENT_JOIN_FAMILY}),
	MapRoleAttrList = [{#p_map_role.family_id,FamilyId},{#p_map_role.family_name,FamilyName}],
	common_misc:send_to_role_map(RoleId, {mod,mod_map_role,{update_map_role_info,{RoleId,MapRoleAttrList}}}),
    ok.
%% 离开帮派
leave_family({RoleId,_FamilyId}) ->
    chat_misc:notice_leave_channel(RoleId, ?CHANNEL_TYPE_FAMILY),
	MapRoleAttrList = [{#p_map_role.family_id,0},{#p_map_role.family_name,""}],
	common_misc:send_to_role_map(RoleId, {mod,mod_map_role,{update_map_role_info,{RoleId,MapRoleAttrList}}}),
    ok.