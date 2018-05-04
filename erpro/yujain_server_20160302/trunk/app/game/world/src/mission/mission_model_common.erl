%% Author: chixiaosheng
%% Created: 2011-4-5
%% Description: 任务通用模型
-module(mission_model_common).

%%
%% Include files
%%
-include("mgeew.hrl").  

%%
%% Exported Functions
%%
-export([
         common_do/6,
         common_cancel/6,
         init_pinfo/3,
         change_model_status/6,
		 change_model_status/7,
         do_listener_trigger/6
        ]).

%%-----------------------------任务执行逻辑处理区-Start-----------------------------
common_do(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo) ->
    MaxModelStatus = MissionBaseInfo#r_mission_base_info.max_model_status,
    CurrentModelStatus = PInfo#p_mission_info.current_model_status,
    case PInfo#p_mission_info.current_model_status of
        MaxModelStatus -> %% 提交任务
            common_complete(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo);
        _ -> %% 切换状态
            case MissionBaseInfo#r_mission_base_info.model =:= ?MISSION_MODEL_4 
                 andalso CurrentModelStatus =/= ?MISSION_MODEL_STATUS_FIRST of
                true ->
                    change_model_status(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo,0);
                _ ->
                    change_model_status(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo,+1)
            end
    end.

%% 完成任务，最后的提交任务
common_complete(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo) ->
    #r_mission_base_info{model=MissionModel,
						 max_model_status = MaxModelStatus,
                         next_mission_id_list = NextMissionIdList} = MissionBaseInfo,
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
	%% 如果是任务模型为5时，需要获取当前玩家选择的选项任务id
	%% 保存在#r_mission_counter.op_data中，以判断后续任务是否可接收
	ModelNextMissionIdList = get_next_mission_id_list_by_model_5(RoleId,RoleBase,DataRecord,MaxModelStatus,MissionBaseInfo),
	case MissionModel =:= ?MISSION_MODEL_5 andalso erlang:length(ModelNextMissionIdList) =:= 1 of
		true ->
			[CounterOpData] = ModelNextMissionIdList;
		_ ->
			CounterOpData = undefined
	end,
    {ok,NewRoleMission,NewCommitTimes} = mod_mission_tool:set_succ_times(RoleMission, MissionBaseInfo, 1, CounterOpData),
    MissionListA = lists:keydelete(MissionId, #p_mission_info.id, NewRoleMission#r_role_mission.mission_list),
    mod_mission:t_set_role_mission(RoleId, NewRoleMission#r_role_mission{mission_list=MissionListA}),
    %% 是否可以重接任务
    case MissionBaseInfo#r_mission_base_info.type of
        ?MISSION_TYPE_LOOP ->
            case do_retake_mission(RoleId,PId,MissionBaseInfo,true) of
                false ->
                    NewPInfo = false,
                    MissionList = MissionListA;
                NewPInfo ->
                    MissionList = [NewPInfo|MissionListA]
            end;
        _ ->
            NewPInfo = false,
            MissionList = MissionListA
    end,
    
    %% 触发后置任务
    PInfoList = update_next_mission(ModelNextMissionIdList ++ NextMissionIdList,RoleId,PId,[]),
    NewMissionList = PInfoList ++ MissionList,
    mod_mission:t_set_role_mission(RoleId, NewRoleMission#r_role_mission{mission_list = NewMissionList}),
                
    %% 任务奖励
    MissionColor = PInfo#p_mission_info.color,
    {ok,NewRoleBase,MissionReward} = mod_mission_reward:reward(RoleId,PId,DataRecord,RoleBase,MissionColor,NewCommitTimes,MissionBaseInfo),
    mod_role:t_set_role_base(RoleId, NewRoleBase),
    SendSelf =  #m_mission_do_toc{op_type=DataRecord#m_mission_do_tos.op_type,
                                id=DataRecord#m_mission_do_tos.id,
                                npc_id=DataRecord#m_mission_do_tos.npc_id,
                                prop_choose=DataRecord#m_mission_do_tos.prop_choose,
                                op_code=0,
                                op_reason="",
                                current_status=?MISSION_STATUS_FINISH,
                                current_model_status=MaxModelStatus,
                                mission_reward = MissionReward},
    
    %%调用hook
    Func = 
        fun()->  
                hook_mission:hook({mission_commit,RoleId,MissionBaseInfo}),
                case NewPInfo =:= false of
                    true ->
                        UpdateList = PInfoList;
                    _ ->
                        UpdateList = [NewPInfo|PInfoList]
                end,
                case UpdateList of
                    [] ->
                        next;
                    _ ->
                        UpdateSendSelf=#m_mission_update_toc{update_list = UpdateList},
                        ?DEBUG("~ts,UpdateSendSelf=~w",[?_LANG_LOCAL_009,UpdateSendSelf]),
                        common_misc:unicast(PId, ?MISSION, ?MISSION_UPDATE,UpdateSendSelf)
                end
        end,
    mod_mission:add_mission_func(RoleId, Func),
    {ok,SendSelf}.

%% --------------------------------------------------------------------
%% 切换状态
%% --------------------------------------------------------------------
change_model_status(RoleId,PId,MissionId,MissionBaseInfo,DataRecord,PInfo,ChangeStep) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    NewPInfo = change_model_status(RoleId,PId,MissionId,MissionBaseInfo,PInfo,ChangeStep),
    MissionList = [NewPInfo | lists:keydelete(PInfo#p_mission_info.id, #p_mission_info.id, RoleMission#r_role_mission.mission_list)],
    mod_mission:t_set_role_mission(RoleId, RoleMission#r_role_mission{mission_list = MissionList}),
    SendSelf =  #m_mission_do_toc{op_type=DataRecord#m_mission_do_tos.op_type,
                                  id=DataRecord#m_mission_do_tos.id,
                                  npc_id=DataRecord#m_mission_do_tos.npc_id,
                                  prop_choose=DataRecord#m_mission_do_tos.prop_choose,
                                  op_code=0,
                                  op_reason="",
                                  current_status=NewPInfo#p_mission_info.current_status,
                                  current_model_status=NewPInfo#p_mission_info.current_model_status},
    {ok,SendSelf}.
%% 切换状态
%% 返回 NewPInfo
change_model_status(RoleId,PId,MissionId,MissionBaseInfo,PInfo,ChangeStep) ->
    CurrentModelStatus = PInfo#p_mission_info.current_model_status,
    NewModelStatus = CurrentModelStatus+ChangeStep,
    #r_mission_base_info{big_group = BigGroup,
                         max_model_status = MaxModelStatus} = MissionBaseInfo,
    case NewModelStatus =:= MaxModelStatus of
        true ->
            %%调用hook
            FinishFunc = 
                fun()->  
                        hook_mission:hook({mission_finish,RoleId,MissionBaseInfo}) 
                end,
            mod_mission:add_mission_func(RoleId, FinishFunc),
            NewStatus = ?MISSION_STATUS_FINISH;
        _ ->
            NewStatus = ?MISSION_STATUS_DOING
    end,
    case CurrentModelStatus =:= ?MISSION_MODEL_STATUS_FIRST of
        true ->
            %%调用hook
            AcceptFunc = 
                fun()->  
                        hook_mission:hook({mission_accept,RoleId,MissionBaseInfo}) 
                end,
            mod_mission:add_mission_func(RoleId, AcceptFunc);
        _ ->
            next
    end,
    %% 当任务完成时，是否需要自动提交任务
    case NewModelStatus =:= MaxModelStatus 
             andalso (common_config_dyn:find(mission_etc,{auto_submit_biggroup,BigGroup}) =:= [true]
                          orelse common_config_dyn:find(mission_etc,{auto_submit_mission_id,MissionId}) =:= [true]) of
        true->
            AutoSubmitFunc = 
                fun() ->
                        DataRecord = #m_mission_do_tos{op_type=?MISSION_DO_OP_TYPE_FINISH,id=MissionId,npc_id=0,prop_choose=[]},
                        Param = {admin_do,{RoleId,PId,DataRecord}},
                        common_misc:send_to_role(erlang:self(), {mod,mod_mission,Param})
                end,
            mod_mission:add_mission_func(RoleId, AutoSubmitFunc);
        _ ->
            next
    end,
    PInfo#p_mission_info{current_status = NewStatus,
                         current_model_status = NewModelStatus}.

%% 是否能够重接任务
%% 返回 PInfo | false
do_retake_mission(RoleId,PId,MissionBaseInfo,GroupNoRandom) ->
    BigGroup = MissionBaseInfo#r_mission_base_info.big_group,
    {ok,#p_role_base{level = RoleLevel}} = mod_role:get_role_base(RoleId),
    if BigGroup =/= 0 andalso GroupNoRandom =:= true ->
           MissionId = mod_mission_tool:get_group_random_one(BigGroup,RoleLevel);
       BigGroup =/= 0 -> %% 循环
           MissionId = MissionBaseInfo#r_mission_base_info.id;
       true -> %% 主线,支线
           MissionId = MissionBaseInfo#r_mission_base_info.id
    end,
    case MissionId of
        0 ->
            false;
        _ ->
            b_mission_model:call_mission_model(RoleId,PId,MissionId, init_pinfo, [false])
    end.

%% 取消任务
common_cancel(RoleId,PId,MissionId,MissionBaseInfo,_DataRecord,_PInfo) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    %% 取消循环任务需要计算次数
    case MissionBaseInfo#r_mission_base_info.big_group > 0 of
        true ->
            [CancelMissionAddTiimesList] = common_config_dyn:find(mission_etc, cancel_mission_add_times_biggroup),
            case lists:member(MissionBaseInfo#r_mission_base_info.big_group, CancelMissionAddTiimesList) of
                true ->
                    {ok,NewRoleMission,_NewCommitTimes} = mod_mission_tool:set_succ_times(RoleMission, MissionBaseInfo, 1);
                _ ->
                    NewRoleMission = RoleMission
            end;
        _ ->
            NewRoleMission = RoleMission
    end,
    %% 是否可以重接任务
    MissionList = lists:keydelete(MissionId, #p_mission_info.id, NewRoleMission#r_role_mission.mission_list),
    mod_mission:t_set_role_mission(RoleId, NewRoleMission#r_role_mission{mission_list = MissionList}),
    case do_retake_mission(RoleId,PId,MissionBaseInfo,true) of
        false ->
            NewPInfo = false;
        NewPInfo ->
            mod_mission:t_set_role_mission(RoleId, NewRoleMission#r_role_mission{mission_list = [NewPInfo|MissionList]})
    end,
    %%调用hook
    Func = 
        fun()->  
                case NewPInfo of
                    false ->
                        next;
                    _->
                        UpdateSendSelf=#m_mission_update_toc{update_list = [NewPInfo]},
                        ?DEBUG("~ts,UpdateSendSelf=~w",[?_LANG_LOCAL_010,UpdateSendSelf]),
                        common_misc:unicast(PId, ?MISSION, ?MISSION_UPDATE,UpdateSendSelf)
                end,
                hook_mission:hook({mission_cancel,RoleId,MissionBaseInfo})
        end,
    mod_mission:add_mission_func(RoleId, Func),
    SendSelf = #m_mission_cancel_toc{id=MissionId,
                                     op_code=0,
                                     op_reason=""},
    {ok,SendSelf}.
    

init_pinfo(RoleId, false, MissionBaseInfo) ->
    new_pinfo(RoleId, MissionBaseInfo);
init_pinfo(RoleId, OldPInfo, MissionBaseInfo) ->
    %%循环任务，在每天重新加载任务列表时，需要将完成当前完成次数置零
    case MissionBaseInfo of
        #r_mission_base_info{type=?MISSION_TYPE_LOOP}->
            CounterInfo= mod_mission_tool:get_counter_info(RoleId, MissionBaseInfo),
            OldPInfo#p_mission_info{commit_times=CounterInfo#r_mission_counter.commit_times,
                                    succ_times=CounterInfo#r_mission_counter.succ_times};
        _ ->
            OldPInfo
    end.
new_pinfo(RoleId, MissionBaseInfo) ->
    case MissionBaseInfo#r_mission_base_info.max_model_status of
        ?MISSION_MODEL_STATUS_FIRST ->
            CurrentStatus = ?MISSION_STATUS_FINISH;
        _ ->
            CurrentStatus = ?MISSION_STATUS_NOT_ACCEPT
    end,
    CounterInfo= mod_mission_tool:get_counter_info(RoleId, MissionBaseInfo),
    #r_mission_counter{commit_times = CommitTimes,succ_times = SuccTimes} = CounterInfo,
    MissionColor = mod_mission_tool:get_mission_color(RoleId, MissionBaseInfo),
    #p_mission_info{id=MissionBaseInfo#r_mission_base_info.id,
                    current_status=CurrentStatus,
                    current_model_status=?MISSION_MODEL_STATUS_FIRST,
                    commit_times=CommitTimes,
                    succ_times=SuccTimes,
                    color=MissionColor,
                    %% 此数据放在每一个任务模型中初始化
                    listener_list=[]}.

%% 处理后置任务
%% 返回 PInfoList
update_next_mission([],_RoleId,_PId,PInfoList) ->
    PInfoList;
update_next_mission([NextMissionId|NextMissionIdList],RoleId,PId,PInfoList)->
    case lists:keyfind(NextMissionId, #p_mission_info.id, PInfoList) of
        false ->
            case b_mission_model:call_mission_model(RoleId,PId,NextMissionId, init_pinfo, [false]) of
                false->
                    update_next_mission(NextMissionIdList,RoleId,PId,PInfoList);
                NextPInfo->
                    [SystemAutoAcceptMissionIdList] = common_config_dyn:find(mission_etc, system_auto_accept_mission_id_list),
                    case lists:member(NextMissionId,SystemAutoAcceptMissionIdList) of
                        true -> %% 系统自动接收任务
                            Func = 
                                fun() ->
                                        DataRecord = #m_mission_do_tos{op_type=?MISSION_DO_OP_TYPE_ACCEPT,id=NextMissionId,npc_id=0,prop_choose=[]},
                                        Param = {admin_do,{RoleId,PId,DataRecord}},
                                        common_misc:send_to_role(erlang:self(), {mod,mod_mission,Param})
                                end,
                            mod_mission:add_mission_func(RoleId, Func);
                        _ ->
                            ignore
                    end,
                    update_next_mission(NextMissionIdList,RoleId,PId,[NextPInfo|PInfoList])
            end;
        _ ->
            update_next_mission(NextMissionIdList,RoleId,PId,PInfoList)
    end.

%% 获取下一个连接的任务id列表
%% DataRecord #m_mssion_do_tos{}
%% CurrentModelStatus 当前任务模型状态
%% 返回 [MissionId,...] | []
get_next_mission_id_list_by_model_5(_RoleId,RoleBase,DataRecord,CurrentModelStatus,MissionBaseInfo) ->
    #r_mission_base_info{model = MissionModel,model_status_list = ModelStatusList} = MissionBaseInfo,
    case MissionModel of
        ?MISSION_MODEL_5 ->
            #r_mission_model_status{ext_list = ExtList} = lists:nth(CurrentModelStatus + 1, ModelStatusList),
            [{RequireId,OptionList}|_] = ExtList,
            case RequireId of
                1 -> %% 按faction_id 自动区分
					OptionId = RoleBase#p_role_base.faction_id;
                _ ->
                    case DataRecord#m_mission_do_tos.prop_choose of
                        [OptionId|_] ->
                            next;
                        _ ->
                            [{OptionId,_}|_] = OptionList
                    end
            end,
            case lists:keyfind(OptionId, 1, OptionList) of
                {_,NextMissionId} ->
                    [NextMissionId];
                _ ->
                    []
            end;
        _ ->
            []
    end.

%% 侦听器触发
%% ListenerInfo 结构 #r_mission_listener
%% PInfo 结构 #p_mission_info
%% 返回 {ok,NewListenerInfo,NewPInfo} | erlang:throw({error,OpCode,OpReason})
do_listener_trigger(RoleId,PId,MissionId,MissionBaseInfo,ListenerInfo,PInfo) ->
    #r_mission_listener{type = Type,sub_type = SubType} = ListenerInfo,
    PListenerList = 
        lists:foldl(
          fun(PListenerInfo,AccPListenerList) -> 
                  case PListenerInfo#p_mission_listener.type =:= Type 
                       andalso PListenerInfo#p_mission_listener.sub_type =:= SubType of
                      true ->
                          case PListenerInfo#p_mission_listener.current_num + 1 > PListenerInfo#p_mission_listener.need_num of
                              true ->
                                  CurrentNum = PListenerInfo#p_mission_listener.need_num;
                              _ ->
                                  CurrentNum = PListenerInfo#p_mission_listener.current_num + 1
                          end,
                          [PListenerInfo#p_mission_listener{current_num = CurrentNum}|AccPListenerList];
                      _ ->
                          AccPListenerList
                  end
          end, [], PInfo#p_mission_info.listener_list),
    NewPInfo = PInfo#p_mission_info{listener_list = PListenerList},
    case lists:member(false, [ PCurrentNum >= PNeedNum  || #p_mission_listener{need_num = PNeedNum,current_num = PCurrentNum} <- PListenerList]) of
        false -> %% 任务状态完成
            NewPInfo2 = mission_model_common:change_model_status(RoleId, PId, MissionId, MissionBaseInfo, NewPInfo, +1),
            NewIdList = lists:delete(MissionId,ListenerInfo#r_mission_listener.mission_id_list),
            NewListenerInfo = ListenerInfo#r_mission_listener{mission_id_list = NewIdList};
        _ ->
            NewPInfo2 = NewPInfo,
            NewListenerInfo = ListenerInfo
    end,
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    case NewListenerInfo#r_mission_listener.mission_id_list of
        [] ->
            NewListenerList = lists:keydelete(ListenerInfo#r_mission_listener.key, #r_mission_listener.key, RoleMission#r_role_mission.listener_list);
        _ ->
            NewListenerList = [NewListenerInfo|lists:keydelete(ListenerInfo#r_mission_listener.key, #r_mission_listener.key, RoleMission#r_role_mission.listener_list)]
    end,
    MissionList = [NewPInfo2|lists:keydelete(PInfo#p_mission_info.id, #p_mission_info.id, RoleMission#r_role_mission.mission_list)],
    NewRoleMission = RoleMission#r_role_mission{listener_list = NewListenerList,mission_list = MissionList},
    mod_mission:t_set_role_mission(RoleId, NewRoleMission),
    {ok,NewListenerInfo,NewPInfo2}.
