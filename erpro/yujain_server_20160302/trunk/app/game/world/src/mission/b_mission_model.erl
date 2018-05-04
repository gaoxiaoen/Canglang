%%% -------------------------------------------------------------------
%%% Author  : xiaosheng
%%% Description : 任务模块 Behaviour
%%%
%%% Created : 2011-03-22
%%% -------------------------------------------------------------------
-module(b_mission_model).
-include("mgeew.hrl").  
  
-export([
         do/3,
         cancel/3,
         dispatch_listener/4,
         call_mission_model/5
        ]).


%% --------------------------------------------------------------------
%% 操作任务模型里的方法
%% -------------------------------------------------------------------- 
%%调用模型里的方法
call_mission_model(RoleId,PId,MissionId, Func, Params) ->
    [MissionBaseInfo] = cfg_mission:find(MissionId), 
    ModelId = MissionBaseInfo#r_mission_base_info.model,
    ModuleName = erlang:list_to_atom(lists:concat(["mission_model_", ModelId])),
	ModuleName:Func({RoleId,PId,MissionId,MissionBaseInfo,Params}).

%% 取消任务
%% 返回 {ok,SendSelf}
cancel(RoleId,PId,DataRecord)->
    MissionId = DataRecord#m_mission_cancel_tos.id,
    case mod_mission_tool:get_p_mission_info(RoleId, MissionId) of
        {ok,PInfo} ->
            case PInfo#p_mission_info.current_model_status of
                ?MISSION_MODEL_STATUS_FIRST ->
                    erlang:throw({error,?_RC_MISSION_CANCEL_002,""});
                _ ->
                    call_mission_model(RoleId,PId,MissionId, cancel, [PInfo, DataRecord])
            end;
        _ ->
            erlang:throw({error,?_RC_MISSION_CANCEL_001,""})
    end.

%% 执行任务
%% 返回 {ok,SendSelf}
do(RoleId,PId,DataRecord) ->
    MissionId = DataRecord#m_mission_do_tos.id, 
    case mod_mission_tool:get_p_mission_info(RoleId, MissionId) of
        {ok,PInfo} ->
            case PInfo#p_mission_info.current_model_status =:= ?MISSION_MODEL_STATUS_FIRST
                 andalso PInfo#p_mission_info.current_status =:= ?MISSION_STATUS_NOT_ACCEPT of
                true ->
                    call_mission_model(RoleId,PId,MissionId,auth_accept,[PInfo]);
                _ ->
                    next
            end,
            %% 任务是否在委托
            [MissionBaseInfo] = cfg_mission:find(MissionId),
            case mod_mission_tool:is_mission_auto(RoleId, MissionBaseInfo) of
                true ->
                    erlang:throw({error,?_RC_MISSION_DO_014,""});
                _->
                    next
            end,
            call_mission_model(RoleId,PId,MissionId,do,[PInfo, DataRecord]);
        _ ->
            erlang:throw({error,?_RC_MISSION_DO_000,""})
    end.
            

%% 派发侦听器
%% ListenerInfo 结构为 #r_mission_listener
%% 返回{ok,[#p_mission_info,...]}
dispatch_listener(RoleId,PId, MissionId, ListenerInfo) when is_integer(MissionId) ->
    dispatch_listener(RoleId,PId,[MissionId], ListenerInfo);
dispatch_listener(RoleId,PId,MissionIdList, ListenerInfo) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    {NewMissionIdList,NewListenerInfo} = 
        lists:foldl(
          fun(MissionId,{AccMissionIdList,AccListenerInfo}) -> 
                  case lists:keyfind(MissionId, #p_mission_info.id, RoleMission#r_role_mission.mission_list) of
                      false ->
                          NewIdList = lists:delete(MissionId, AccListenerInfo#r_mission_listener.mission_id_list),
                          {AccMissionIdList,AccListenerInfo#r_mission_listener{mission_id_list = NewIdList}};
                      _PInfo ->
                          {[MissionId|AccMissionIdList],AccListenerInfo}
                  end
          end, {[],ListenerInfo}, MissionIdList),
    case NewListenerInfo#r_mission_listener.mission_id_list of
        [] ->
            NewListenerList = lists:keydelete(ListenerInfo#r_mission_listener.key, #r_mission_listener.key, RoleMission#r_role_mission.listener_list);
        _ ->
            NewListenerList = [NewListenerInfo|lists:keydelete(ListenerInfo#r_mission_listener.key, #r_mission_listener.key, RoleMission#r_role_mission.listener_list)]
    end,
    NewRoleMission = RoleMission#r_role_mission{listener_list = NewListenerList},
	mod_mission:set_role_mission(RoleId, NewRoleMission),
	dispatch_listener2(NewMissionIdList,RoleId,PId,NewListenerInfo,[]).

dispatch_listener2([],_RoleId,_PId,_ListenerInfo,PInfoList) ->
    {ok,PInfoList};
dispatch_listener2([MissionId|MissionIdList],RoleId,PId,ListenerInfo,PInfoList) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    case lists:keyfind(MissionId, #p_mission_info.id, RoleMission#r_role_mission.mission_list) of
        false -> %% 当前任务列表没有此任务，更新侦听器信息
           dispatch_listener2(MissionIdList,RoleId,PId,ListenerInfo,PInfoList);
        PInfo ->
            case call_mission_model(RoleId,PId,MissionId, listener_trigger, [ListenerInfo,PInfo]) of
                {ok,ignore} ->
                    dispatch_listener2(MissionIdList,RoleId,PId,ListenerInfo,PInfoList);
                {ok,NewListenerInfo,NewPInfo} ->
                    dispatch_listener2(MissionIdList,RoleId,PId,NewListenerInfo,[NewPInfo|PInfoList])
            end
    end.
