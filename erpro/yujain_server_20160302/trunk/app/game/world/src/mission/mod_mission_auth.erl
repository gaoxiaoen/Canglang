%%% -------------------------------------------------------------------
%%% Author  : xiaosheng
%%% Description : 任务 验证模块
%%%
%%% Created : 2010-9-2
%%% -------------------------------------------------------------------
-module(mod_mission_auth).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("mgeew.hrl").  

-export([
         auth_accept/2,
         auth_show/2
        ]).

%% @doc 验证是否可接
%% @return {ok} | throw({error,OpCode,OpReason})
auth_accept(RoleId,MissionBaseInfo) -> 
    #r_mission_base_info{id=MissionId,
                         min_level = MinLevel,max_level = MaxLevel,
                         pre_mission_id_list=PreMissionIdList,
                         max_do_times = MaxDoTimes,
                         need_item_list = NeedItemList} = MissionBaseInfo,
    %% 检查最小等级，最大等级
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_MISSION_DO_001,""})
    end,
    case RoleBase#p_role_base.level >= MinLevel andalso RoleBase#p_role_base.level =< MaxLevel of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_DO_002,""})
    end,
    %% 检查玩家任务数据
    case mod_mission:get_role_mission(RoleId) of
        {ok,RoleMission} ->
            next;
        _ ->
            RoleMission = undefined,
            erlang:throw({error,?_RC_MISSION_DO_003,""})
    end,
    %% 检查是否已经接受了任务
    PInfo = lists:keyfind(MissionId, #p_mission_info.id, RoleMission#r_role_mission.mission_list),
    case PInfo#p_mission_info.current_status =:= ?MISSION_STATUS_NOT_ACCEPT of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_DO_006,""})
    end,
    %% 检查前置任务
    case PreMissionIdList of
        [] ->
            next;
        _ ->
			case catch lists:foldl(
				   fun(PreMissionId,AccCheckPreMission) -> 
						   [PreMissionBaseInfo] = cfg_mission:find(PreMissionId),
						   PreMaxDoTimes = PreMissionBaseInfo#r_mission_base_info.max_do_times,
						   case mod_mission_tool:get_succ_times(RoleMission, PreMissionBaseInfo) >=  PreMaxDoTimes of
							   true ->
								   erlang:throw(true);
							   _ ->
								   AccCheckPreMission
						   end
				   end, false, PreMissionIdList) of
				true ->
					next;
				_ ->
					erlang:throw({error,?_RC_MISSION_DO_004,""})
			end
    end,
    %% 检查任务次数
    case mod_mission_tool:get_succ_times(RoleMission, MissionBaseInfo) >= MaxDoTimes of
        true ->
            erlang:throw({error,?_RC_MISSION_DO_005,""});
        _ ->
            next
    end,
    %% 检查接受需要的任务道具
    case NeedItemList of
        [] ->
            next;
        _ ->
            lists:foreach(
              fun(#r_mission_need_item{item_type_id = ItemTypeId,item_num = ItemNum}) -> 
                      {ok,GoodsNumber}=mod_bag:get_goods_num_by_type_id(RoleId,[?MAIN_BAG_ID],ItemTypeId),
                      case GoodsNumber >= ItemNum of
                          true ->
                              next;
                          _ ->
                              erlang:throw({error,?_RC_MISSION_DO_007,""})
                      end
              end, NeedItemList)
    end,
    {ok}.
auth_show(RoleId,MissionBaseInfo) ->
    #r_mission_base_info{id=MissionId,
						 type=MissionType,
                         min_level = MinLevel,max_level = MaxLevel,
                         pre_mission_id_list=PreMissionIdList,
                         max_do_times = MaxDoTimes} = MissionBaseInfo,
    %% 检查最小等级，最大等级
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_MISSION_DO_001,""})
    end,
	case MissionType of
		?MISSION_TYPE_MAIN ->
			next;
		_ ->
			case RoleBase#p_role_base.level >= MinLevel andalso RoleBase#p_role_base.level =< MaxLevel of
				true ->
					next;
				_ ->
					erlang:throw({error,?_RC_MISSION_DO_002,""})
			end
	end,
    %% 检查玩家任务数据
    case mod_mission:get_role_mission(RoleId) of
        {ok,RoleMission} ->
            next;
        _ ->
            RoleMission = undefined,
            erlang:throw({error,?_RC_MISSION_DO_003,""})
    end,
    case lists:keyfind(MissionId, #p_mission_info.id, RoleMission#r_role_mission.mission_list) of
        false ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_DO_006,""})
    end,
    %% 检查前置任务
    case PreMissionIdList of
        [] ->
            next;
        _ ->
			case catch lists:foldl(
				   fun(PreMissionId,AccCheckPreMission) ->
						   [PreMissionBaseInfo] = cfg_mission:find(PreMissionId),
						   PreCounterInfo = mod_mission_tool:get_counter_info(RoleMission, PreMissionBaseInfo),
						   PreMaxDoTimes = PreMissionBaseInfo#r_mission_base_info.max_do_times,
						   case PreCounterInfo#r_mission_counter.succ_times >= PreMaxDoTimes of
							   true ->
								   case PreMissionBaseInfo#r_mission_base_info.model of
									   ?MISSION_MODEL_5 ->
										   case PreCounterInfo#r_mission_counter.op_data of
											   MissionId ->
												   erlang:throw(true);
											   _ ->
												   AccCheckPreMission
										   end;
									   _ ->
										   erlang:throw(true)
								   end;
							   _ ->
								   AccCheckPreMission
						   end
				   end, false, PreMissionIdList) of
				true ->
					next;
				_ ->
					erlang:throw({error,?_RC_MISSION_DO_004,""})
			end
	end,

    %% 检查任务次数
    case mod_mission_tool:get_succ_times(RoleMission, MissionBaseInfo) >= MaxDoTimes of
        true ->
            erlang:throw({error,?_RC_MISSION_DO_005,""});
        _ ->
            next
    end,
    {ok}.
