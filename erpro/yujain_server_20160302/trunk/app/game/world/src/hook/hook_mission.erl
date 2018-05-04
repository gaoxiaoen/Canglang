%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-26
%% Description: 任务hook
-module(hook_mission).

-include("mgeew.hrl").

%%
%% Include files
%%
-export([
         hook/1
        ]).

-export([trigger/1]).

hook({MissionStatus,RoleId,MissionBaseInfo}) ->
    do_mission_hook(MissionStatus,RoleId,MissionBaseInfo);
hook({MissionStatus,RoleId,MissionBaseInfo,DoTimes}) ->
    lists:foreach(
      fun(_Index) -> 
              do_mission_hook(MissionStatus,RoleId,MissionBaseInfo)
      end, lists:seq(1, DoTimes,1));
hook(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

do_mission_hook(MissionStatus,RoleId,MissionBaseInfo) ->
    do_mission_hook2(MissionStatus,RoleId,MissionBaseInfo),
    do_mission_log(MissionStatus,RoleId,MissionBaseInfo),
    ok.


do_mission_hook2(mission_accept,RoleId,MissionBaseInfo) ->
    do_mission_accept(RoleId,MissionBaseInfo);
do_mission_hook2(mission_finish,RoleId,MissionBaseInfo) ->
    do_mission_finish(RoleId,MissionBaseInfo);
do_mission_hook2(mission_commit,RoleId,MissionBaseInfo) ->
    do_mission_commit(RoleId,MissionBaseInfo);
do_mission_hook2(mission_cancel,RoleId,MissionBaseInfo) ->
    do_mission_cancel(RoleId,MissionBaseInfo).

%% 接受任务
do_mission_accept(_RoleId,_MissionBaseInfo) ->
    ignore.

%% 完成任务
do_mission_finish(_RoleId,_MissionBaseInfo) ->
	ignore.
%% 接交任务（领取任务奖励）
do_mission_commit(RoleId,MissionBaseInfo) ->
	#r_mission_base_info{type = MissionType} = MissionBaseInfo,
	case MissionType =:= ?MISSION_TYPE_LOOP of
		true->
			hook_mission:trigger({mission_event,RoleId,?MISSION_EVENT_LOOP_MISSION_1});
		_->
			next
	end,
	ok.
%% 取消任务
do_mission_cancel(_RoleId,_MissionBaseInfo) ->
    ok.


%% 任务日志记录
do_mission_log(MissionStatus,RoleId,MissionBaseInfo) ->
    #r_mission_base_info{id= MissionId,type = MissionType} = MissionBaseInfo,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            {ok,RoleBase} = common_misc:get_role_base(RoleId)
    end,
    LogTime = common_tool:now(),
    case MissionStatus of
        mission_commit ->
            [FristMissIdList] = common_config_dyn:find(mission_etc,first_mission_id),
            case lists:member(MissionId, FristMissIdList) of
                true-> %% 写日志
                    LogRoleFollow=#r_log_role_follow{account_name = RoleBase#p_role_base.account_name,
                                                     account_via = RoleBase#p_role_base.account_via, 
                                                     role_id = RoleId,
                                                     role_name = RoleBase#p_role_base.role_name,
                                                     mtime = LogTime,
                                                     step = ?ROLE_FOLLOW_STEP_7,
                                                     ip = RoleBase#p_role_base.last_login_ip},
                    common_log:insert_log(role_follow, LogRoleFollow);
                _ ->
                    next
            end;
        _ ->
            next
    end,
    case MissionStatus of
        mission_accept ->
            LogMissionStatus = ?LOG_MISSION_STATUS_ACCEPT;
        mission_finish ->
            LogMissionStatus = ?LOG_MISSION_STATUS_FINISH;
        mission_commit ->
            LogMissionStatus = ?LOG_MISSION_STATUS_COMMIT;
        mission_cancel ->
            LogMissionStatus = ?LOG_MISSION_STATUS_CANCEL
    end,
    LogMission = #r_log_mission{role_id=RoleId,
                                role_name=RoleBase#p_role_base.role_name,
                                account_name=RoleBase#p_role_base.account_name,
                                role_level=RoleBase#p_role_base.level,
                                mtime=LogTime,
                                mission_id=MissionId,
                                mission_type=MissionType,
                                status=LogMissionStatus},
    common_log:insert_log(mission, LogMission),
    ok.

trigger({mission_event,RoleId,SpecialEventId})->
	case mgeew_role:get_role_world_state() of
		{ok,#r_role_world_state{role_id=RoleId}} ->
			mod_mission:handle({listener_dispatch,{RoleId,?MISSION_LISTENER_TYPE_SPECIAL_EVENT,SpecialEventId}});
		_ ->
			Param = {listener_dispatch,{RoleId,?MISSION_LISTENER_TYPE_SPECIAL_EVENT,SpecialEventId}},
			case erlang:whereis(common_misc:get_role_world_process_name(RoleId)) of
				undefined -> 
					ignore;
				RolePId ->
					RolePId ! {mod,mod_mission,Param}
			end
	end;
trigger(_)->
    ok.