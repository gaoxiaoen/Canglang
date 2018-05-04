%% Author: chixiaosheng
%% Created: 2011-4-5
%% Description: 打怪模型
%%      model_status: 必须是3个Status
%%      listener：必须是怪物的侦听器
-module(mission_model_2).

%%
%% Include files
%%
-include("mgeew.hrl").  

%%
%% Exported Functions
%%
-export([
         auth_accept/1,
         do/1,
         cancel/1,
         listener_trigger/1,
         init_pinfo/1]).

%%打怪模型的第二个状态
-define(MISSION_MODEL_2_STATUS_DOING, 1).

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
            ?ERROR_MSG("~ts,RoleId=~w,MissionId=~w,OpCode=~w,OpReason=~w",[?_LANG_LOCAL_008,RoleId,MissionId,OpCode,OpReason]),
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
                case PInfo#p_mission_info.current_model_status =:= ?MISSION_MODEL_2_STATUS_DOING of
                    true ->
                        erlang:throw({error,?_RC_MISSION_DO_011,""});
                    _ ->
                        ignore
                end,
                NewPInfo = init_mission_listener(RoleId,MissionBaseInfo,PInfo),
                mission_model_common:common_do(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,NewPInfo)
        end,
    ?DO_TRANS_FUN(TransFun).

%% 初始化任务侦听器
%% 返回 #p_mission_info
init_mission_listener(RoleId,MissionBaseInfo,PInfo) ->
    #p_mission_info{current_model_status = CurrentModelStatus} = PInfo,
    #r_mission_base_info{max_model_status = MaxModelStatus,
                         listener_list = PListenerList} = MissionBaseInfo,
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    if CurrentModelStatus =:= ?MISSION_MODEL_STATUS_FIRST ->
           ListenerList = 
               lists:foldl(
                 fun(PListenerInfo,AccListenerList) -> 
                         #r_mission_base_listener{sub_type =BarrierId,
                                                  need_num=NeedNum} = PListenerInfo,
                         ListenerInfo = #p_mission_listener{type=PListenerInfo#r_mission_base_listener.type,
                                                            sub_type=BarrierId,
                                                            value=PListenerInfo#r_mission_base_listener.value,
                                                            need_num=NeedNum,
                                                            current_num=0},
                         [ListenerInfo|AccListenerList]
                 end, [], PListenerList),
           NewRoleMission = mod_mission_tool:add_mission_listener(RoleMission, MissionBaseInfo),
           mod_mission:t_set_role_mission(RoleId, NewRoleMission),
           PInfo#p_mission_info{listener_list = ListenerList};
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
