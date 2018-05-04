%% Author: caochuncheng2002@gmail.com
%% Created: 2013-7-9
%% Description: 任务委托
-module(mod_mission_auto).

%%
%% Include files
%%
-include("mgeew.hrl").

%%
%% Exported Functions
%%
-export([
         handle/1
         ]).

handle({Module,?MISSION_AUTO,DataRecord,RoleId,PId,_Line}) ->
    do_mission_auto(Module,?MISSION_AUTO,DataRecord,RoleId,PId);

handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

-define(mission_auto_op_type_query,1).       %% 1查询
-define(mission_auto_op_type_auto,2).        %% 2委托
-define(mission_auto_op_type_speed_up,3).    %% 3加速
-define(mission_auto_op_type_complete,4).    %% 4完成通知

%% 任务委托
do_mission_auto(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_mission_auto2(RoleId,PId,DataRecord) of
        {error,OpCode} ->
            do_mission_auto_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,do_query,RoleBase,RoleMission} ->
            do_mission_auto_query(Module,Method,DataRecord,RoleId,PId,
                                  RoleBase,RoleMission);
        {ok,RoleBase,RoleMission,AutoInfo,PAutoInfo,OpFee} ->
            do_mission_auto3(Module,Method,DataRecord,RoleId,PId,
                             RoleBase,RoleMission,AutoInfo,PAutoInfo,OpFee)
    end.
do_mission_auto2(RoleId,PId,DataRecord) ->
    #m_mission_auto_tos{op_type=OpType,big_group=BigGroup,loop_times= LoopTimes} = DataRecord,
    case OpType of
        ?mission_auto_op_type_query ->
            next;
        ?mission_auto_op_type_auto ->
            next;
        ?mission_auto_op_type_speed_up ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_AUTO_000})
    end,
    case mod_mission:get_role_mission(RoleId) of
        {ok,RoleMission} ->
            next;
        _ ->
            RoleMission = undefined,
            erlang:throw({error,?_RC_MISSION_AUTO_001})
    end,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_MISSION_AUTO_001})
    end,
    case OpType of
        ?mission_auto_op_type_query ->
            erlang:throw({ok,do_query,RoleBase,RoleMission});
        _->
            next
    end,
	case common_config_dyn:find(mission_etc, {mission_base_auto,BigGroup}) of
        [AutoInfo] ->
            next;
        _ ->
            AutoInfo =undefined,
            erlang:throw({error,?_RC_MISSION_AUTO_002})
    end, 
    case LoopTimes > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_AUTO_002})
    end,
    #p_role_base{level = RoleLevel,gold = Gold} = RoleBase,
    #r_mission_base_auto{min_level=MinLevel,op_fee=Fee,do_fee=DoFee} = AutoInfo,
    case RoleLevel >= MinLevel of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_AUTO_003})
    end,
    case get_p_mission_auto(RoleId,PId,RoleLevel,RoleMission,BigGroup) of
        {ok,PAutoInfo} ->
            next;
        _ ->
            PAutoInfo = undefined,
            erlang:throw({error,?_RC_MISSION_AUTO_002})
    end,
    case OpType of
        ?mission_auto_op_type_auto ->
            case PAutoInfo#p_mission_auto.status of
                ?MISSION_AUTO_STATUS_NO ->
                    next;
                ?MISSION_AUTO_STATUS_START ->
                    erlang:throw({error,?_RC_MISSION_AUTO_004})
            end,
            OpFee = LoopTimes * Fee,
            case Gold >= OpFee of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_AUTO_007})
            end,
            %% 次数判断
            case LoopTimes + PAutoInfo#p_mission_auto.cur_times > PAutoInfo#p_mission_auto.max_loop_times of
                true ->
                    erlang:throw({error,?_RC_MISSION_AUTO_010});
                _ ->
                    next
            end,
            next;
        _ ->
            case PAutoInfo#p_mission_auto.status of
                ?MISSION_AUTO_STATUS_START ->
                    next;
                ?MISSION_AUTO_STATUS_NO ->
                    erlang:throw({error,?_RC_MISSION_AUTO_008})
            end,
            OpFee = PAutoInfo#p_mission_auto.loop_times * DoFee,
            case Gold >= OpFee of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_AUTO_007})
            end,
            next
    end,
    {ok,RoleBase,RoleMission,AutoInfo,PAutoInfo,OpFee}.

do_mission_auto_query(Module,Method,DataRecord,RoleId,PId,
                      RoleBase,RoleMission) ->
    RoleLevel = RoleBase#p_role_base.level,
    [BigGroupList] = common_config_dyn:find(mission_etc, mission_base_auto_list),
    case DataRecord#m_mission_auto_tos.big_group > 0 of
        true -> %% 查询单个委托信息
            case get_p_mission_auto(RoleId,PId,RoleLevel,RoleMission,DataRecord#m_mission_auto_tos.big_group) of
                {ok,PAutoInfo} ->
                    SendSelf = #m_mission_auto_toc{op_type=DataRecord#m_mission_auto_tos.op_type,
                                                   big_group=DataRecord#m_mission_auto_tos.big_group,
                                                   loop_times=DataRecord#m_mission_auto_tos.loop_times,
                                                   op_code=0,
                                                   auto_list = [],
                                                   auto_info = PAutoInfo};
                _ ->
                     SendSelf = #m_mission_auto_toc{op_type=DataRecord#m_mission_auto_tos.op_type,
                                                   big_group=DataRecord#m_mission_auto_tos.big_group,
                                                   loop_times=DataRecord#m_mission_auto_tos.loop_times,
                                                   op_code=?_RC_MISSION_AUTO_006}
            end;
        _ ->
            PAutoList = 
                lists:foldl(
                  fun(BigGroup,AccMissionAutoList) -> 
                          case get_p_mission_auto(RoleId,PId,RoleLevel,RoleMission,BigGroup) of
                              {ok,PAutoInfo} ->
                                  [PAutoInfo|AccMissionAutoList];
                              _ ->
                                  AccMissionAutoList
                          end
                  end, [], BigGroupList),
            SendSelf = #m_mission_auto_toc{op_type=DataRecord#m_mission_auto_tos.op_type,
                                           big_group=DataRecord#m_mission_auto_tos.big_group,
                                           loop_times=DataRecord#m_mission_auto_tos.loop_times,
                                           op_code=0,
                                           auto_list = PAutoList}
    end,
    ?DEBUG("do mission auto query,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).
                            
                      
do_mission_auto3(Module,Method,DataRecord,RoleId,PId,
                 RoleBase,RoleMission,AutoInfo,PAutoInfo,OpFee) ->
    mod_mission:init_mission_func(RoleId),
    case common_transaction:transaction(
           fun() ->
                   do_t_mission_auto(RoleId,PId,DataRecord,RoleBase,RoleMission,AutoInfo,PAutoInfo,OpFee)
           end) of
        {atomic,{ok,NewRoleBase,NewRoleMission,NewPAutoInfo,PMissionReward}} ->
            do_mission_auto4(Module,Method,DataRecord,RoleId,PId,
                                NewRoleBase,NewRoleMission,PAutoInfo,NewPAutoInfo,PMissionReward,OpFee);
        {aborted, Error} ->
            mod_mission:erase_mission_func(RoleId),
            case erlang:is_integer(Error) of
                true ->
                    OpCode = Error;
                _ ->
					?ERROR_MSG("do mission auto fail,RoleId=~w,DataRecord=~w,Error=~w,",[RoleId,DataRecord,Error]),
                    OpCode = ?_RC_MISSION_AUTO_000
            end,
            do_mission_auto_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end. 
do_t_mission_auto(RoleId,PId,DataRecord,RoleBase,RoleMission,AutoInfo,PAutoInfo,OpFee) ->
    #p_role_base{level = RoleLevel,gold = Gold} = RoleBase,
    NewRoleBase = RoleBase#p_role_base{gold = Gold - OpFee},
    
    #r_mission_base_auto{need_time = NeedTime} = AutoInfo,
    #m_mission_auto_tos{big_group = BigGroup,loop_times = LoopTimes} = DataRecord,

    case DataRecord#m_mission_auto_tos.op_type of
        ?mission_auto_op_type_auto ->
            [MissionBaseInfo] = cfg_mission:find(PAutoInfo#p_mission_auto.mission_id),
            StartTime = common_tool:now(),
            EndTime = StartTime + NeedTime * LoopTimes,
            NewPAutoInfo = PAutoInfo#p_mission_auto{status = ?MISSION_AUTO_STATUS_START,
                                                    start_time = StartTime,
                                                    end_time = EndTime,
                                                    loop_times = LoopTimes},
            {ok,NewRoleMission,_NewCommitTimes} = mod_mission_tool:set_succ_times(RoleMission, MissionBaseInfo, LoopTimes),
            NewRoleBase2 = NewRoleBase,
            PMissionReward = undefined,
            next;
        ?mission_auto_op_type_speed_up ->
            MissionId = mod_mission_tool:get_group_random_one(BigGroup, RoleLevel),
            [MissionBaseInfo] = cfg_mission:find(MissionId),
            #r_mission_base_info{reward_info = RewardInfo,
                                 max_do_times = MaxDoTimes} = MissionBaseInfo,
            #r_mission_reward{rollback_times = RollbackTimes} = RewardInfo,
            CurTimes = mod_mission_tool:get_succ_times(RoleMission, MissionBaseInfo),
            MissionColor = mod_mission_tool:get_mission_color(RoleMission, MissionBaseInfo),
            NewPAutoInfo = PAutoInfo#p_mission_auto{mission_id=MissionId,
                                                    role_level=RoleLevel,
                                                    rollback_times=RollbackTimes,
                                                    cur_times=CurTimes,
                                                    status=?MISSION_AUTO_STATUS_NO,
                                                    start_time=0,
                                                    end_time=0,
                                                    max_loop_times=MaxDoTimes - CurTimes,
                                                    loop_times=0,
                                                    color=MissionColor},
            {ok,NewRoleBase2,NewRoleMission,PMissionReward} = 
                do_t_mission_auto_reward(RoleId,PId,PAutoInfo,NewPAutoInfo,NewRoleBase,RoleMission),
            next
    end,
    AutoList = [NewPAutoInfo|lists:keydelete(BigGroup, #p_mission_auto.big_group, NewRoleMission#r_role_mission.auto_list)],
    NewRoleMission2 = NewRoleMission#r_role_mission{auto_list = AutoList},
    mod_mission:t_set_role_mission(RoleId, NewRoleMission2),
    mod_role:t_set_role_base(RoleId, NewRoleBase2),
    {ok,NewRoleBase2,NewRoleMission2,NewPAutoInfo,PMissionReward}.
do_mission_auto4(Module,Method,DataRecord,RoleId,PId,
                 NewRoleBase,_NewRoleMission,PAutoInfo,NewPAutoInfo,PMissionReward,OpFee) ->
    LogTime = common_tool:now(),
    case DataRecord#m_mission_auto_tos.op_type of
        ?mission_auto_op_type_auto ->
            LogType = ?LOG_CONSUME_GOLD_MISSION_AUTO;
        ?mission_auto_op_type_speed_up ->
            LogType = ?LOG_CONSUME_GOLD_MISSION_AUTO_SPEED_UP
    end,
    common_log:log_gold({NewRoleBase,LogType,LogTime,OpFee}),
    case DataRecord#m_mission_auto_tos.op_type of
        ?mission_auto_op_type_auto ->
            SendSelf = #m_mission_auto_toc{op_type=DataRecord#m_mission_auto_tos.op_type,
                                           big_group=DataRecord#m_mission_auto_tos.big_group,
                                           loop_times=DataRecord#m_mission_auto_tos.loop_times,
                                           op_code=0,
                                           auto_info = NewPAutoInfo};
        ?mission_auto_op_type_speed_up ->
            SendSelf = #m_mission_auto_toc{op_type=DataRecord#m_mission_auto_tos.op_type,
                                           big_group=DataRecord#m_mission_auto_tos.big_group,
                                           loop_times=DataRecord#m_mission_auto_tos.loop_times,
                                           op_code=0,
                                           auto_info = NewPAutoInfo,
                                           mission_reward = PMissionReward}
    end,
    ?DEBUG("do mission auto succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf),
    mod_mission:do_mission_func(RoleId),
    case DataRecord#m_mission_auto_tos.op_type of
        ?mission_auto_op_type_speed_up ->
            [MissionBaseInfo] = cfg_mission:find(PAutoInfo#p_mission_auto.mission_id),
            hook_mission:hook({mission_finish,RoleId,MissionBaseInfo,PAutoInfo#p_mission_auto.loop_times}),
            hook_mission:hook({mission_commit,RoleId,MissionBaseInfo,PAutoInfo#p_mission_auto.loop_times}),
			hook_mission:trigger({mission_event,RoleId,?MISSION_EVENT_LOOP_MISSION_2});
        _ ->
            next
    end,
    ok.
do_mission_auto_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_mission_auto_toc{op_type=DataRecord#m_mission_auto_tos.op_type,
                                   big_group=DataRecord#m_mission_auto_tos.big_group,
                                   loop_times=DataRecord#m_mission_auto_tos.loop_times,
                                   op_code=OpCode},
    ?DEBUG("do mission auto fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).

%% 获取委托信息
%% 返回 {ok,PAutoInfo} | {error,Reason}
get_p_mission_auto(RoleId,PId,RoleLevel,RoleMission,BigGroup) ->
    case catch get_p_mission_auto2(RoleId,PId,RoleLevel,RoleMission,BigGroup) of
		{ok,PAutoInfo} ->
			{ok,PAutoInfo};
		Error ->
			?ERROR_MSG("~ts,RoleId=~w,Error=~w",[?_LANG_LOCAL_011,RoleId,Error]),
			Error
	end.
get_p_mission_auto2(RoleId,PId,RoleLevel,RoleMission,BigGroup) ->
    #r_role_mission{auto_list = AutoList} = RoleMission,
    case common_config_dyn:find(mission_etc, {mission_base_auto,BigGroup}) of
        [AutoInfo] ->
            next;
        _ ->
            AutoInfo = undefined,
            erlang:throw({error,mission_base_info})
    end,
    #r_mission_base_auto{min_level=MinLevel} = AutoInfo,
    case RoleLevel >= MinLevel of
        true ->
            next;
        _ ->
            erlang:throw({error,min_level})
    end,
    case lists:keyfind(BigGroup, #p_mission_auto.big_group, AutoList) of
        false -> 
            MissionId = mod_mission_tool:get_group_random_one(BigGroup, RoleLevel),
            [MissionBaseInfo] = cfg_mission:find(MissionId),
            #r_mission_base_info{reward_info = RewardInfo,
                                 max_do_times = MaxDoTimes} = MissionBaseInfo,
            #r_mission_reward{rollback_times = RollbackTimes} = RewardInfo,
            CurTimes = mod_mission_tool:get_succ_times(RoleMission, MissionBaseInfo),
            MissionColor = mod_mission_tool:get_mission_color(RoleMission, MissionBaseInfo),
            PAutoInfo = #p_mission_auto{big_group=BigGroup,
                                        mission_id=MissionId,
                                        role_level=RoleLevel,
                                        rollback_times=RollbackTimes,
                                        cur_times=CurTimes,
                                        status=?MISSION_AUTO_STATUS_NO,
                                        start_time=0,
                                        end_time=0,
                                        max_loop_times=MaxDoTimes - CurTimes,
                                        loop_times=0,
                                        color=MissionColor};
        PAutoInfoT ->
            PAutoInfo = get_p_mission_auto3(PAutoInfoT#p_mission_auto.status,RoleId,PId,RoleLevel,RoleMission,BigGroup,PAutoInfoT),
            next
    end,
    {ok,PAutoInfo}.
get_p_mission_auto3(?MISSION_AUTO_STATUS_NO,_RoleId,_PId,RoleLevel,RoleMission,BigGroup,PAutoInfo) ->
    %% 判断玩家等是否发生变化
    case RoleLevel =:= PAutoInfo#p_mission_auto.role_level of
        true ->
            MissionId = PAutoInfo#p_mission_auto.mission_id;
        _ ->
            MissionId = mod_mission_tool:get_group_random_one(BigGroup, RoleLevel)
    end,
    case MissionId of
        0 ->
            erlang:throw({error,mission_id});
        _ ->
            next
    end,
    [MissionBaseInfo] = cfg_mission:find(MissionId),
    #r_mission_base_info{reward_info = RewardInfo,
                         max_do_times = MaxDoTimes} = MissionBaseInfo,
    #r_mission_reward{rollback_times = RollbackTimes} = RewardInfo,
    CurTimes = mod_mission_tool:get_succ_times(RoleMission, MissionBaseInfo),
    MissionColor = mod_mission_tool:get_mission_color(RoleMission, MissionBaseInfo),
    PAutoInfo#p_mission_auto{mission_id=MissionId,
                             role_level=RoleLevel,
                             rollback_times=RollbackTimes,
                             cur_times=CurTimes,
                             status=?MISSION_AUTO_STATUS_NO,
                             start_time=0,
                             end_time=0,
                             max_loop_times=MaxDoTimes - CurTimes,
                             loop_times=0,
                             color=MissionColor};
get_p_mission_auto3(?MISSION_AUTO_STATUS_START,RoleId,PId,RoleLevel,RoleMission,BigGroup,PAutoInfo) ->
    %% 判断是否已经完成
    NowSeconds = common_tool:now(),
    case NowSeconds >= PAutoInfo#p_mission_auto.end_time of
        true ->
            MissionId = mod_mission_tool:get_group_random_one(BigGroup, RoleLevel),
            [MissionBaseInfo] = cfg_mission:find(MissionId),
            #r_mission_base_info{reward_info = RewardInfo,
                                 max_do_times = MaxDoTimes} = MissionBaseInfo,
            #r_mission_reward{rollback_times = RollbackTimes} = RewardInfo,
            CurTimes = mod_mission_tool:get_succ_times(RoleMission, MissionBaseInfo),
            MissionColor = mod_mission_tool:get_mission_color(RoleMission, MissionBaseInfo),
            NewPAutoInfo = PAutoInfo#p_mission_auto{mission_id=MissionId,
                                                    role_level=RoleLevel,
                                                    rollback_times=RollbackTimes,
                                                    cur_times=CurTimes,
                                                    status=?MISSION_AUTO_STATUS_NO,
                                                    start_time=0,
                                                    end_time=0,
                                                    max_loop_times=MaxDoTimes - CurTimes,
                                                    loop_times=0,
                                                    color=MissionColor},
            case do_mission_auto_reward(RoleId,PId,PAutoInfo,NewPAutoInfo) of
                {ok} ->
                    NewPAutoInfo;
                _ ->
                    PAutoInfo
            end;
        _ ->
            PAutoInfo
    end.
    

%% 委托任务奖励
do_mission_auto_reward(RoleId,PId,PAutoInfo,NewPAutoInfo) ->
    case catch do_mission_auto_reward2(RoleId) of
        {ok,RoleBase,RoleMission} ->
            do_mission_auto_reward3(RoleId,PId,PAutoInfo,NewPAutoInfo,RoleBase,RoleMission);
        Error ->
            Error
    end.

do_mission_auto_reward2(RoleId) ->
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,not_found_role_base})
    end,
    case mod_mission:get_role_mission(RoleId) of
        {ok,RoleMission} ->
            next;
         _->
             RoleMission = undefined,
             erlang:throw({error,not_found_role_mission})
    end,
    {ok,RoleBase,RoleMission}.

do_mission_auto_reward3(RoleId,PId,PAutoInfo,NewPAutoInfo,RoleBase,RoleMission) ->
    mod_mission:init_mission_func(RoleId),
    case common_transaction:transaction(
           fun() ->
                   do_t_mission_auto_reward(RoleId,PId,PAutoInfo,NewPAutoInfo,RoleBase,RoleMission)
           end) of
        {atomic,{ok,_NewRoleBase,_NewRoleMission,PMissionReward}} ->
            SendSelf = #m_mission_auto_toc{op_type=?mission_auto_op_type_complete,
                                           big_group=NewPAutoInfo#p_mission_auto.big_group,
                                           loop_times=NewPAutoInfo#p_mission_auto.loop_times,
                                           op_code=0,
                                           auto_info = NewPAutoInfo,
                                           mission_reward = PMissionReward},
            ?DEBUG("do mission auto reward succ,SendSelf=~w",[SendSelf]),
            common_misc:unicast(PId,?MISSION,?MISSION_AUTO,SendSelf),
            mod_mission:do_mission_func(RoleId),
            [MissionBaseInfo] = cfg_mission:find(PAutoInfo#p_mission_auto.mission_id),
            hook_mission:hook({mission_finish,RoleId,MissionBaseInfo,PAutoInfo#p_mission_auto.loop_times}),
            hook_mission:hook({mission_commit,RoleId,MissionBaseInfo,PAutoInfo#p_mission_auto.loop_times}),
            {ok};
        {aborted, Error} ->
            mod_mission:erase_mission_func(RoleId),
            ?ERROR_MSG("~ts,Error=~w",[?_LANG_LOCAL_012,Error]),
            erlang:throw({error,Error})
    end.
do_t_mission_auto_reward(RoleId,PId,PAutoInfo,NewPAutoInfo,RoleBase,RoleMission) ->
    #p_role_base{category = RoleCategory} = RoleBase,
    #p_mission_auto{big_group = BigGroup,mission_id = MissionId,
                    color = MissionColor,role_level = RoleLevel,
                    cur_times = PCurTimes,loop_times = LoopTimes} = PAutoInfo,
    [MissionBaseInfo] = cfg_mission:find(MissionId),
    case PCurTimes =:= 0 of
        true ->
            CurTimes = 1;
        _ ->
            CurTimes = PCurTimes
    end,
    %% 任务奖励
    PMissionReward = mod_mission_reward:reward_calc(RoleLevel,RoleCategory,MissionBaseInfo,MissionColor,CurTimes,LoopTimes),
    {ok,NewRoleBase} = mod_mission_reward:do_mission_reward(RoleId,PId,RoleBase,PMissionReward,LoopTimes),
    mod_role:t_set_role_base(RoleId, NewRoleBase),
    
    AutoList = [NewPAutoInfo|lists:keydelete(BigGroup, #p_mission_auto.big_group, RoleMission#r_role_mission.auto_list)],
    NewRoleMission = RoleMission#r_role_mission{auto_list = AutoList},
    mod_mission:t_set_role_mission(RoleId, NewRoleMission),
    {ok,NewRoleBase,NewRoleMission,PMissionReward}.
