%% Author: caochuncheng2002@gmail.com
%% Created: 2013-5-13
%% Description: 角色操作hook

-module(hook_role).

-include("mgeew.hrl").

-export([hook_role_create/1,
         hook_loop/1,
         hook_loop_ms/1,
         hook_role_online/1,
         hook_role_offline/2,
         hook_role_level_up/4,
         hook_role_relive/1,
         hook_role_dead/1
         ]).


%% 创建角色
hook_role_create(RoleId) ->
	%% 创建信件处理
	LetterTitle = common_lang:get_lang(100101),
	LetterContent = common_letter:create_temp(1601001, []),
	common_letter:sys2p(RoleId,LetterContent,LetterTitle,14),

    ok.

hook_loop_ms(RoleId) ->
    ?TRY_CATCH(mod_buff:loop_ms(RoleId, ?ACTOR_TYPE_ROLE), ErrBuff),
    ?TRY_CATCH(mod_pet:loop_ms(RoleId), ErrPet),
    ok.
%% 玩家进程每秒循环
hook_loop(_RoleId) ->
    %%     {ok,RoleBase} = mod_role:get_role_base(RoleId),
    %%     NowSeconds = mgeew_role:get_now(),
    ok.

%% 玩家上线
hook_role_online(RoleId) ->
    {ok,#r_role_world_state{gateway_pid = PId}} = mgeew_role:get_role_world_state(),
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    ?TRY_CATCH(mod_pet:role_online(RoleId),ErrPet),
    ?TRY_CATCH(mod_system:role_online(RoleId, PId),ErrSystem),
    ?TRY_CATCH(mod_chat:role_online(RoleId),ErrChat),
    ?TRY_CATCH(mod_mission:role_online(RoleId),ErrMission),
    ?TRY_CATCH(hook_family:role_online(RoleId,RoleBase),ErrFamily),
    ?TRY_CATCH(mod_multi_exp:role_online(RoleId,RoleBase),ErrMultiExp),
    ok.
%% 玩家下线
hook_role_offline(RoleId,NowSeconds) ->
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    ?TRY_CATCH(mod_role_bi:hook_role_offline(RoleId, NowSeconds),RoleBIErr),
    ?TRY_CATCH(hook_family:role_offline(RoleId,RoleBase),ErrFamily),
    ?TRY_CATCH(mod_chat:role_offline(RoleId),ErrChat),
    ok.
%% 玩家升级
hook_role_level_up(RoleId,OldLevel,NewLevel,_FactionId) ->
    ?TRY_CATCH(mod_mission:handle({role_level_up, {RoleId,NewLevel}}),Err1),
	%% 地图等同步
	MapRoleAttrList = [{#p_map_role.level,NewLevel}],
	common_misc:send_to_role_map(RoleId, {mod,mod_map_role,{update_map_role_info,{RoleId,MapRoleAttrList}}}),
	%% 聊天同步等级
    ?TRY_CATCH(mod_chat:hook_level_up(RoleId,OldLevel,NewLevel),Err5),
    ok.
%% 玩家复活
hook_role_relive(RoleId) ->
    ?TRY_CATCH(mod_pet:role_relive(RoleId),ErrPet),
    ok.
%% 玩家死亡
hook_role_dead(RoleId) ->
    ?TRY_CATCH(mod_pet:role_dead(RoleId),ErrPet),
    ok.