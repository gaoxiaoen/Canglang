%%%
%% Created: 2011-6-22
%% Description: 特殊事件的侦听器 - 3次对话 - 中间状态去完成事件
%%      model_status: 必须是3个Status
%%      listener：必须是特殊事件的侦听器
-module(mission_model_4).

%%
%% Include files
%%
-include("mgeew.hrl").  

%%特殊事件模型的第二个状态
-define(MISSION_MODEL_4_STATUS_DOING, 1).

%%
%% Exported Functions
%%
-export([
         auth_accept/1,
         do/1,
         cancel/1,
         listener_trigger/1,
         init_pinfo/1]).
%%
%% API Functions
%%
%% 验证是否可接
auth_accept({RoleId,_PId,_MissionId,MissionBaseInfo,[_PInfo]}) -> 
    mod_mission_auth:auth_accept(RoleId,MissionBaseInfo).

%% 初始化任务pinfo
%% 返回#p_mission_info{} | false
init_pinfo({RoleId,_PId,MissionId,MissionBaseInfo,[OldPInfo]}) -> 
    case catch mod_mission_auth:auth_show(RoleId, MissionBaseInfo) of
        {error,OpCode,OpReason} ->
            ?ERROR_MSG("~ts,RoleId=~w,MissionId=~w,OpCode=~w,OpReason=~w",["初始化任务信息出错",RoleId,MissionId,OpCode,OpReason]),
            false;
        _ ->
            mission_model_common:init_pinfo(RoleId, OldPInfo, MissionBaseInfo)
    end.

%% 取消任务
cancel({RoleId,PId,MissionId,MissionBaseInfo,[PInfo,DataRecord]}) ->
    TransFun = 
        fun() ->
                Result = mission_model_common:common_cancel(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo),
                %% 删除此任务侦听器
                {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
                NewRoleMission = mod_mission_tool:del_mission_listener(RoleMission, MissionBaseInfo),
                mod_mission:t_set_role_mission(RoleId, NewRoleMission),
                Result
        end,
    ?DO_TRANS_FUN(TransFun).


%% 执行任务 接-做-交
do({RoleId,PId,MissionId,MissionBaseInfo,[PInfo,DataRecord]}) ->
    TransFun = 
        fun() ->
                case PInfo#p_mission_info.current_model_status =:= ?MISSION_MODEL_4_STATUS_DOING of
                    true ->
                        erlang:throw({error,?_RC_MISSION_DO_011,""});
                    _ ->
                        ignore
                end,
                NewPInfo = init_mission_listener(RoleId,PId,MissionId,MissionBaseInfo,PInfo),
                mission_model_common:common_do(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,NewPInfo)
        end,
    ?DO_TRANS_FUN(TransFun).



%% 初始化任务侦听器
%% 返回 #p_mission_info
init_mission_listener(RoleId,_PId,_MissionId,MissionBaseInfo,PInfo) ->
    #p_mission_info{current_model_status = CurrentModelStatus} = PInfo,
    #r_mission_base_info{max_model_status = MaxModelStatus,
                         listener_list = PListenerList} = MissionBaseInfo,
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    if CurrentModelStatus =:= ?MISSION_MODEL_STATUS_FIRST ->
           ListenerList = 
               lists:foldl(
                 fun(PListenerInfo,AccListenerList) -> 
                         #r_mission_base_listener{sub_type = SubType,need_num = NeedNum} = PListenerInfo,
                         PCurrentNum = 0, %%get_current_num(SubType,RoleId,PListenerInfo),
                         case PCurrentNum > NeedNum of
                             true ->
                                 CurrentNum = NeedNum;
                             _ ->
                                 CurrentNum = PCurrentNum
                         end,
                         ListenerInfo = #p_mission_listener{type=PListenerInfo#r_mission_base_listener.type,
                                                            sub_type=SubType,
                                                            value=PListenerInfo#r_mission_base_listener.value,
                                                            need_num=NeedNum,
                                                            current_num=CurrentNum},
                         [ListenerInfo|AccListenerList]
                 end, [], PListenerList),
           NewRoleMission = mod_mission_tool:add_mission_listener(RoleMission, MissionBaseInfo),
		   NewPInfo = PInfo#p_mission_info{listener_list = ListenerList},
		   MissionList = [NewPInfo|lists:keydelete(PInfo#p_mission_info.id, #p_mission_info.id, NewRoleMission#r_role_mission.mission_list)],
		   NewRoleMission2 = NewRoleMission#r_role_mission{mission_list=MissionList},
           mod_mission:t_set_role_mission(RoleId, NewRoleMission2),
           %% 任务是否已经完成
           case lists:member(false, [ANum >= BNum || #p_mission_listener{current_num = ANum,need_num = BNum} <- ListenerList]) of
               false -> %% 任务已经完成
				   Func = 
					   fun() ->
							   lists:foreach(
								 fun(#r_mission_base_listener{sub_type = SpecialEventId}) -> 
										 hook_mission:trigger({mission_event,RoleId,SpecialEventId})
								 end, PListenerList)
					   end,
				   mod_mission:add_mission_func(RoleId, Func);
               _ ->
				   next
           end,
           NewPInfo;
       CurrentModelStatus =:= MaxModelStatus -> %% 任务完成，删除侦听器
           NewRoleMission = mod_mission_tool:del_mission_listener(RoleMission, MissionBaseInfo),
           mod_mission:t_set_role_mission(RoleId, NewRoleMission),
           PInfo;
       true ->
           PInfo
    end.


%% 侦听器触发
%% ListenerInfo 结构 #r_mission_listener
%% PInfo 结构 #p_mission_info
%% 返回 {ok,NewListenerInfo,NewPInfo} | erlang:throw({error,OpCode,OpReason})
listener_trigger({RoleId,PId,MissionId,MissionBaseInfo,[ListenerInfo,PInfo]}) ->
    #p_mission_info{current_model_status = CurrentModelStatus} = PInfo,
    #r_mission_base_info{max_model_status = MaxModelStatus} = MissionBaseInfo,
    case CurrentModelStatus =:= MaxModelStatus of
        true ->
            {ok,ignore};
        _ ->
            TransFun = 
                fun() ->
                        mission_model_common:do_listener_trigger(RoleId,PId,MissionId,MissionBaseInfo,ListenerInfo,PInfo)
                end,
            ?DO_TRANS_FUN(TransFun)
    end.


    
    