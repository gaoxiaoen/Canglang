%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-24
%% Description: 任务模块
-module(mod_mission).

%%
%% Include files
%%
-include("mgeew.hrl").
%%
%% Exported Functions
%%
-export([
         init_role_mission/1,
         get_role_mission/1,
         set_role_mission/2,
         t_set_role_mission/2,
         
         init_mission_func/1,
         add_mission_func/2,
         erase_mission_func/1,
         do_mission_func/1,
         
         handle/1,
         
         role_online/1
        
         ]).

%% 任务进程字典操作函数定义
init_role_mission(RoleId) ->
    case db_api:dirty_read(?DB_ROLE_MISSION,RoleId) of
        [RoleMission] ->
            next;
        _ ->
            %% 初始化第一个任务
            {ok,#p_role_base{faction_id = FactionId,level=RoleLevel}} = mod_role:get_role_base(RoleId),
            case common_config_dyn:find(mission_etc, {role_first_mission_id,FactionId}) of
                [FirstMissionId] ->
                    next;
                _ ->
                    case common_config_dyn:find(mission_etc,{role_first_mission_id,0}) of
                        [FirstMissionId] ->
                            next;
                        _ ->
                            FirstMissionId = 0
                    end
            end,
            InitRoleMission = #r_role_mission{role_id = RoleId},
            mod_role:init_dict({?DB_ROLE_MISSION,RoleId}, InitRoleMission),
            %% 初始化可接的循环任务
            GroupMissionIdList = mod_mission_tool:get_group_mission_id_list(RoleLevel),
            MissionList = 
                lists:foldl(
                  fun(InitMissionId,AccMissionList)-> 
                          case cfg_mission:find(InitMissionId) of
                              [MissionBaseInfo] ->
                                  case catch mod_mission_auth:auth_show(RoleId, MissionBaseInfo) of
                                      {ok} ->
                                          PInfo = mission_model_common:init_pinfo(RoleId, false, MissionBaseInfo),
                                          [PInfo|AccMissionList];
                                      _ ->
                                          AccMissionList
                                  end;
                              _ ->
                                  AccMissionList
                          end
                  end, [], [FirstMissionId|GroupMissionIdList]),
            RoleMission = InitRoleMission#r_role_mission{mission_list = MissionList}
    end,
    mod_role:init_dict({?DB_ROLE_MISSION,RoleId}, RoleMission).
get_role_mission(RoleId) ->
    mod_role:get_dict({?DB_ROLE_MISSION,RoleId}).
set_role_mission(RoleId,RoleMission) ->
    mod_role:set_dict({?DB_ROLE_MISSION,RoleId}, RoleMission).
t_set_role_mission(RoleId,RoleMission) ->
    mod_role:t_set_dict({?DB_ROLE_MISSION,RoleId}, RoleMission).

-define(mission_func_dict,mission_func_dict).
init_mission_func(RoleId) ->
    erlang:put({?mission_func_dict,RoleId}, []).
get_mission_func(RoleId) ->
    erlang:get({?mission_func_dict,RoleId}).
add_mission_func(RoleId,Func) ->
    common_misc:update_dict_queue({?mission_func_dict,RoleId}, Func).
erase_mission_func(RoleId) ->
    erlang:erase({?mission_func_dict,RoleId}).

do_mission_func(RoleId) ->
    case get_mission_func(RoleId) of
        [] ->
            next;
        FuncList ->
            [?TRY_CATCH(Func(),MissionFuncErr) || Func <- lists:reverse(FuncList)]
    end,
    erase_mission_func(RoleId).



handle({Module,?MISSION_QUERY,DataRecord,RoleId,PId,_Line}) ->
    do_mission_query(Module,?MISSION_QUERY,DataRecord,RoleId,PId);

handle({admin_do,{RoleId,PId,DataRecord}}) ->
    do_mission_do(?MISSION,?MISSION_DO,DataRecord,RoleId,PId);
handle({Module,?MISSION_DO,DataRecord,RoleId,PId,_Line}) ->
    do_mission_do(Module,?MISSION_DO,DataRecord,RoleId,PId);

handle({Module,?MISSION_DO_COMPLETE,DataRecord,RoleId,PId,_Line}) ->
    do_mission_do_complete(Module,?MISSION_DO_COMPLETE,DataRecord,RoleId,PId);

handle({Module,?MISSION_DO_SUBMIT,DataRecord,RoleId,PId,_Line}) ->
    do_mission_do_submit(Module,?MISSION_DO_SUBMIT,DataRecord,RoleId,PId);

handle({admin_cancel,{RoleId,PId,DataRecord}}) ->
    do_mission_cancel(?MISSION,?MISSION_CANCEL,DataRecord,RoleId,PId);
handle({Module,?MISSION_CANCEL,DataRecord,RoleId,PId,_Line}) ->
    do_mission_cancel(Module,?MISSION_CANCEL,DataRecord,RoleId,PId);

handle({Module,?MISSION_RECOLOR,DataRecord,RoleId,PId,Line}) ->
    mod_mission_recolor:handle({Module,?MISSION_RECOLOR,DataRecord,RoleId,PId,Line});
handle({Module,?MISSION_AUTO,DataRecord,RoleId,PId,Line}) ->
    mod_mission_auto:handle({Module,?MISSION_AUTO,DataRecord,RoleId,PId,Line});

handle({listener_dispatch, Info}) ->
    do_listener_dispatch(Info);

handle({role_level_up, Info}) ->
    do_role_level_up(Info);

handle({admin_complete_mission,Info}) ->
	do_admin_complete_mission(Info);

handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

%% GM命令完成主线任务
do_admin_complete_mission({RoleId,0,_IsComplete}) ->
	{ok,RoleMission} = mod_mission:get_role_mission(RoleId),
	#r_role_mission{mission_list=MissionList} = RoleMission,
	db_api:dirty_delete(?DB_ROLE_MISSION,RoleId),
	mod_mission:init_role_mission(RoleId),
	{ok,NewRoleMission} = mod_mission:get_role_mission(RoleId),
	#r_role_mission{mission_list=NewMissionList} = NewRoleMission,
	UpdateSendSelf = #m_mission_update_toc{del_list=[DelId||#p_mission_info{id=DelId} <- MissionList],update_list=NewMissionList},
	common_misc:unicast({role,RoleId}, ?MISSION, ?MISSION_UPDATE,UpdateSendSelf);
do_admin_complete_mission({RoleId,MissionId,IsComplete}) ->
	NowSeconds = mgeew_role:get_now(),
	[MissionBaseInfo] = cfg_mission:find(MissionId),
	case IsComplete of
        true ->
            MissionIdList = [MissionId | get_pre_mission_id_list(MissionId,[])];
        _ ->
            MissionIdList = get_pre_mission_id_list(MissionId,[])
    end,
	{ok,RoleMission} = mod_mission:get_role_mission(RoleId),
	#r_role_mission{mission_list=MissionList,counter_list=CounterList} = RoleMission,
	AddTotalExp = 
		lists:foldl(
		  fun(PMissionId,AccAddTotalExp) -> 
				  case lists:keyfind(PMissionId, #r_mission_counter.id, CounterList) of
					  false ->
						  [#r_mission_base_info{reward_info=#r_mission_reward{exp=Exp}}] = cfg_mission:find(PMissionId),
						  AccAddTotalExp + Exp;
					  _ ->
						  AccAddTotalExp
				  end
		  end, 0, MissionIdList),
	NewCounterList =
		lists:foldl(
		  fun(DoneMissionId,AccNewCounterList) -> 
				  case lists:keyfind(DoneMissionId, #r_mission_counter.id, CounterList) of
					  false ->
						  [#r_mission_counter{key={0,DoneMissionId},
											  id=DoneMissionId,
											  commit_times=1,
											  succ_times=1,
											  op_time=NowSeconds,
											  op_data=undefined} | AccNewCounterList] ;
					  _->
						  AccNewCounterList
				  end
		  end, [], MissionIdList),
	case IsComplete of
		true ->
			NewMissionList = [];
		_ ->
			NewPInfo=mission_model_common:init_pinfo(RoleId, false,MissionBaseInfo),
			NewMissionList = [NewPInfo]
	end,
	NewRoleMission=#r_role_mission{role_id=RoleId,
								   mission_list=NewMissionList,
								   listener_list= [],
								   counter_list=NewCounterList ++ CounterList,
								   recolor_list = [],
								   auto_list = []},
	db_api:dirty_write(?DB_ROLE_MISSION, NewRoleMission),
	mod_mission:init_role_mission(RoleId),
	UpdateSendSelf = #m_mission_update_toc{del_list=[DelId||#p_mission_info{id=DelId} <- MissionList],update_list=NewMissionList},
	common_misc:unicast({role,RoleId}, ?MISSION, ?MISSION_UPDATE,UpdateSendSelf),
	mod_role_bi:do_add_exp(RoleId, ?ADD_EXP_TYPE_GM_MISSION, AddTotalExp),
	ok.
%% 找出此任务的前置任务
get_pre_mission_id_list(0,MissionIdList)->
	MissionIdList;
get_pre_mission_id_list(MissionId,MissionIdList)->
	[#r_mission_base_info{pre_mission_id_list=PreMissionIdList}] = cfg_mission:find(MissionId),
	case PreMissionIdList of
		[] ->
			get_pre_mission_id_list(0,MissionIdList);
		[PreMissionId|_]  ->
			get_pre_mission_id_list(PreMissionId,[PreMissionId|MissionIdList])
	end.

%% 查询任务信息
do_mission_query(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_mission_query2(RoleId,DataRecord) of
        {error,OpCode,OpReason} ->
            do_mission_query_error(Module,Method,DataRecord,RoleId,PId,OpCode,OpReason);
        {ok,MissionList} ->
            do_mission_query3(Module,Method,DataRecord,RoleId,PId,MissionList)
    end.
do_mission_query2(RoleId,DataRecord) ->
    #m_mission_query_tos{op_type = OpType,id_list = IdList} = DataRecord,
    case OpType of
        1 ->
            next;
        2 ->
            case IdList =/= [] of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_QUERY_001,""})
            end;
        _ ->
            erlang:throw({error,?_RC_MISSION_QUERY_000,""})
    end,
    case mod_mission:get_role_mission(RoleId) of
        {ok,RoleMission} ->
            next;
        _ ->
            RoleMission = undefined,
            erlang:throw({error,?_RC_MISSION_QUERY_002,""})
    end,
    case OpType of
        1 -> 
            MissionList = RoleMission#r_role_mission.mission_list;
        2 ->
            MissionList = 
                lists:foldl(
                  fun(MissionId,AccMissionList) ->  
                          case lists:keyfind(MissionId, #p_mission_info.id, RoleMission#r_role_mission.mission_list) of
                              false ->
                                  erlang:throw({error,?_RC_MISSION_QUERY_003,""});
                              MissionInfo ->
                                  [MissionInfo|AccMissionList]
                          end
                  end, [], IdList)
    end,
    {ok,MissionList}.

do_mission_query3(Module,Method,DataRecord,_RoleId,PId,MissionList) ->
    SendSelf = #m_mission_query_toc{op_type=DataRecord#m_mission_query_tos.op_type,
                                    id_list=DataRecord#m_mission_query_tos.id_list,
                                    op_code=0,
                                    op_reason="",
                                    mission_list=MissionList},
    ?DEBUG("mission query succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).

do_mission_query_error(Module,Method,DataRecord,_RoleId,PId,OpCode,OpReason) ->
    SendSelf = #m_mission_query_toc{op_type=DataRecord#m_mission_query_tos.op_type,
                                    id_list=DataRecord#m_mission_query_tos.id_list,
                                    op_code=OpCode,
                                    op_reason=OpReason,
                                    mission_list=[]},
    ?DEBUG("mission query fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).
%% 做任务
do_mission_do(Module,Method,DataRecord,RoleId,PId) ->
    init_mission_func(RoleId),
    case catch b_mission_model:do(RoleId,PId,DataRecord) of
        {ok,SendSelf} ->
            ?DEBUG("mission do succ,SendSelf=~w",[SendSelf]),
            common_misc:unicast(PId,Module,Method,SendSelf),
            do_mission_func(RoleId);
        {error,OpCode,OpReason} ->
            do_mission_do_error(Module,Method,DataRecord,RoleId,PId,OpCode,OpReason);
        Error ->
            ?ERROR_MSG("mission do fail,Error=~w",[Error]),
            OpCode = ?_RC_MISSION_DO_008,
            OpReason = "",
            do_mission_do_error(Module,Method,DataRecord,RoleId,PId,OpCode,OpReason)
    end.
do_mission_do_error(Module,Method,DataRecord,RoleId,PId,OpCode,OpReason) ->
    erase_mission_func(RoleId),
    SendSelf = #m_mission_do_toc{op_type=DataRecord#m_mission_do_tos.op_type,
                                 id=DataRecord#m_mission_do_tos.id,
                                 npc_id=DataRecord#m_mission_do_tos.npc_id,
                                 prop_choose=DataRecord#m_mission_do_tos.prop_choose,
                                 op_code=OpCode,
                                 op_reason=OpReason},
    ?DEBUG("mission do fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).

-define(mission_do_complete_op_fee_type_silver,11).
-define(mission_do_complete_op_fee_type_gold,21).
%% 立即完成任务
do_mission_do_complete(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_mission_do_complete2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_mission_do_complete_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,RoleBase,PInfo,MissionBaseInfo,OpFeeType,OpFee} ->
            do_mission_do_complete3(Module,Method,DataRecord,RoleId,PId,
                                    RoleBase,PInfo,MissionBaseInfo,OpFeeType,OpFee)
    end.
do_mission_do_complete2(RoleId,DataRecord) ->
    #m_mission_do_complete_tos{id=MissionId} = DataRecord,
    case MissionId =:= 0 of
        true ->
            erlang:throw({error,?_RC_MISSION_DO_COMPLETE_002});
        _ ->
            next
    end,
    case cfg_mission:find(MissionId) of
        [MissionBaseInfo] ->
            next;
        _ ->
            MissionBaseInfo = undefined,
            erlang:throw({error,?_RC_MISSION_DO_COMPLETE_003})
    end,
    case common_config_dyn:find(mission_etc, {can_do_complete_biggroup,MissionBaseInfo#r_mission_base_info.big_group}) of
        [{OpFeeType,OpFee}] ->
            next;
        _ ->
            OpFeeType = 0,OpFee = 0,
            erlang:throw({error,?_RC_MISSION_DO_COMPLETE_004})
    end,
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    #p_role_base{gold=Gold,silver=Silver} = RoleBase,
    case OpFeeType of
        ?mission_do_complete_op_fee_type_silver ->
            case Silver >= OpFee of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_DO_COMPLETE_005})
            end;
        ?mission_do_complete_op_fee_type_gold ->
            case Gold >= OpFee of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_DO_COMPLETE_010})
            end;
        _ ->
            erlang:throw({error,?_RC_MISSION_DO_COMPLETE_001})
    end,
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    case lists:keyfind(MissionId, #p_mission_info.id, RoleMission#r_role_mission.mission_list) of
        false ->
            PInfo = undefined,
            erlang:throw({error,?_RC_MISSION_DO_COMPLETE_008});
        PInfo ->
            next
    end, 
    case PInfo#p_mission_info.current_status of
        ?MISSION_STATUS_NOT_ACCEPT ->
            erlang:throw({error,?_RC_MISSION_DO_COMPLETE_008});
        ?MISSION_STATUS_FINISH ->
            erlang:throw({error,?_RC_MISSION_DO_COMPLETE_009});
        _ ->
            next
    end,
    {ok,RoleBase,PInfo,MissionBaseInfo,OpFeeType,OpFee}.
do_mission_do_complete3(Module,Method,DataRecord,RoleId,PId,
                        RoleBase,PInfo,MissionBaseInfo,OpFeeType,OpFee) ->
    init_mission_func(RoleId),
    case common_transaction:transaction(
           fun() ->
                   do_t_mission_do_complete(RoleId,PId,RoleBase,PInfo,MissionBaseInfo,OpFeeType,OpFee)
           end) of
        {atomic,{ok,NewRoleBase,DoSendSelf}} ->
            do_mission_do_complete4(Module,Method,DataRecord,RoleId,PId,
                                    OpFeeType,OpFee,NewRoleBase,DoSendSelf);
        {aborted, Error} ->
            erase_mission_func(RoleId),
            case erlang:is_integer(Error) of
                true ->
                    OpCode = Error;
                _ ->
                    OpCode = ?_RC_MISSION_DO_COMPLETE_001
            end,
            do_mission_do_complete_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end.
do_t_mission_do_complete(RoleId,PId,RoleBase,PInfo,MissionBaseInfo,OpFeeType,OpFee) ->
    #p_role_base{gold=Gold,silver=Silver} = RoleBase,
    case OpFeeType of
        ?mission_do_complete_op_fee_type_silver ->
            NewSilver = Silver - OpFee,
            NewGold = Gold;
        ?mission_do_complete_op_fee_type_gold ->
            NewSilver = Silver,
            NewGold = Gold -OpFee
    end, 
    NewRoleBase = RoleBase#p_role_base{silver=NewSilver,gold=NewGold},
    mod_role:t_set_role_base(RoleId, NewRoleBase),
    %% 完成任务
    MissionId = PInfo#p_mission_info.id,
    MaxModelStatus = MissionBaseInfo#r_mission_base_info.max_model_status,
    CurrentModelStatus = PInfo#p_mission_info.current_model_status,
    ChangeStep = MaxModelStatus - CurrentModelStatus,
    DoDataRecord = #m_mission_do_tos{op_type=?MISSION_DO_OP_TYPE_FINISH,id=MissionId,npc_id=0,prop_choose=[]},
    {ok,DoSendSelf} = mission_model_common:change_model_status(RoleId,PId,MissionId,MissionBaseInfo,DoDataRecord,PInfo,ChangeStep),
    {ok,NewRoleBase,DoSendSelf}.

do_mission_do_complete4(Module,Method,DataRecord,RoleId,PId,
                        OpFeeType,OpFee,NewRoleBase,DoSendSelf) ->
    LogTime = common_tool:now(),
    case OpFeeType of
        ?mission_do_complete_op_fee_type_gold->
            common_log:log_gold({NewRoleBase,?LOG_CONSUME_GOLD_MISSION_DO_COMPLETE,LogTime,OpFee}),
            common_misc:send_role_attr_change_gold(PId, NewRoleBase);
        ?mission_do_complete_op_fee_type_silver ->
            common_log:log_silver({NewRoleBase,?LOG_CONSUME_SILVER_MISSION_DO_COMPLETE,LogTime,OpFee}),
            common_misc:send_role_attr_change_silver(PId, NewRoleBase)
    end,
    common_misc:unicast(PId,?MISSION,?MISSION_DO,DoSendSelf),
    SendSelf = #m_mission_do_complete_toc{id=DataRecord#m_mission_do_complete_tos.id,
                                          op_code = 0,
                                          op_fee_type=OpFeeType,op_fee=OpFee},
    ?DEBUG("mission complete succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf),
    do_mission_func(RoleId),
    ok.
do_mission_do_complete_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_mission_do_complete_toc{id=DataRecord#m_mission_do_complete_tos.id,
                                          op_code = OpCode},
    ?DEBUG("mission complete fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).
%% 完成任务并提交任务获得奖励接口
do_mission_do_submit(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_mission_do_submit2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_mission_do_submit_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,RoleBase,RoleMission,MissionBaseInfo,OpFeeType,OpFee} ->
            do_mission_do_submit3(Module,Method,DataRecord,RoleId,PId,
                                  RoleBase,RoleMission,MissionBaseInfo,OpFeeType,OpFee)
    end.
do_mission_do_submit2(RoleId,DataRecord) ->
    #m_mission_do_submit_tos{big_group=BigGroup,do_times = DoTimes} = DataRecord,
    case BigGroup =:= 0 of
        true ->
            erlang:throw({error,?_RC_MISSION_DO_SUBMIT_002});
        _ ->
            next
    end,
    [MaxDoTimes] = common_config_dyn:find(mission_etc, can_do_submit_max_times),
    case DoTimes > 0 andalso erlang:is_integer(DoTimes) =:= true of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_DO_SUBMIT_011})
    end,
    case DoTimes > MaxDoTimes of
        true ->
            erlang:throw({error,?_RC_MISSION_DO_SUBMIT_013});
        _ ->
            next
    end,
    case common_config_dyn:find(mission_etc, {can_do_submit_biggroup,BigGroup}) of
        [{OpFeeType,Fee}] ->
            next;
        _ ->
            OpFeeType = 0,Fee = 0,
            erlang:throw({error,?_RC_MISSION_DO_SUBMIT_004})
    end,
    OpFee = Fee * DoTimes,
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    #p_role_base{level = RoleLevel,
                 gold=Gold,
                 silver=Silver} = RoleBase,
    case OpFeeType of
        ?mission_do_complete_op_fee_type_silver ->
            case Silver >= OpFee of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_DO_SUBMIT_005})
            end;
        ?mission_do_complete_op_fee_type_gold ->
            case Gold >= OpFee of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_DO_SUBMIT_010})
            end;
        _ ->
            erlang:throw({error,?_RC_MISSION_DO_SUBMIT_001})
    end,
    BigGroupMissionId = mod_mission_tool:get_group_random_one(BigGroup, RoleLevel),
    case BigGroupMissionId of
        0 ->
            erlang:throw({error,?_RC_MISSION_DO_SUBMIT_015});
        _ ->
            next
    end,
    [MissionBaseInfo] = cfg_mission:find(BigGroupMissionId),
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    MissionTimes = mod_mission_tool:get_succ_times(RoleMission, MissionBaseInfo),
    case MissionBaseInfo#r_mission_base_info.max_do_times - MissionTimes >= DoTimes of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_DO_SUBMIT_012})
    end,
    {ok,RoleBase,RoleMission,MissionBaseInfo,OpFeeType,OpFee}.
do_mission_do_submit3(Module,Method,DataRecord,RoleId,PId,
                      RoleBase,RoleMission,MissionBaseInfo,OpFeeType,OpFee) ->
    init_mission_func(RoleId),
    case common_transaction:transaction(
           fun() ->
                   do_t_mission_do_submit(RoleId,PId,DataRecord,RoleBase,RoleMission,MissionBaseInfo,OpFeeType,OpFee)
           end) of
        {atomic,{ok,NewRoleBase,NewRoleMission}} ->
            do_mission_do_submit4(Module,Method,DataRecord,RoleId,PId,
                                  NewRoleBase,NewRoleMission,MissionBaseInfo,OpFeeType,OpFee);
        {aborted, Error} ->
            erase_mission_func(RoleId),
            case erlang:is_integer(Error) of
                true ->
                    OpCode = Error;
                _ ->
                    ?ERROR_MSG("mission submit fail,RoleId=~w,DataRecord=~w,Error=~w",[RoleId,DataRecord,Error]),
                    OpCode = ?_RC_MISSION_DO_SUBMIT_001
            end,
            do_mission_do_submit_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end.
do_t_mission_do_submit(RoleId,PId,DataRecord,RoleBase,RoleMission,MissionBaseInfo,OpFeeType,OpFee) ->
    #p_role_base{level = RoleLevel,category = RoleCategory,
                 gold=Gold,silver=Silver} = RoleBase,
    case OpFeeType of
        ?mission_do_complete_op_fee_type_silver ->
            NewSilver = Silver - OpFee,
            NewGold = Gold;
        ?mission_do_complete_op_fee_type_gold ->
            NewSilver = Silver,
            NewGold = Gold -OpFee
    end, 
    NewRoleBase = RoleBase#p_role_base{silver=NewSilver,gold=NewGold},
    %% 任务处理
    case mod_mission_tool:get_succ_times(RoleMission, MissionBaseInfo) of
        0 ->
            CurTimes = 1;
        CurTimes ->
            next
    end,
    %% 任务次数
    #m_mission_do_submit_tos{do_times = DoTimes} = DataRecord,
    {ok,NewRoleMission,_NewCommitTimes} = mod_mission_tool:set_succ_times(RoleMission, MissionBaseInfo, DoTimes),
    mod_mission:t_set_role_mission(RoleId, NewRoleMission),
    %% 任务奖励
    MissionColor = mod_mission_tool:get_mission_color(RoleMission,MissionBaseInfo),
    PMissionReward = mod_mission_reward:reward_calc(RoleLevel,RoleCategory,MissionBaseInfo,MissionColor,CurTimes,DoTimes),
    {ok,NewRoleBase2} = mod_mission_reward:do_mission_reward(RoleId,PId,NewRoleBase,PMissionReward,DoTimes),
    mod_role:t_set_role_base(RoleId, NewRoleBase2),
    {ok,NewRoleBase2,NewRoleMission}.

do_mission_do_submit4(Module,Method,DataRecord,RoleId,PId,
                      NewRoleBase,NewRoleMission,MissionBaseInfo,OpFeeType,OpFee) ->
    LogTime = common_tool:now(),
    case OpFeeType of
        ?mission_do_complete_op_fee_type_gold->
            common_log:log_gold({NewRoleBase,?LOG_CONSUME_GOLD_MISSION_DO_SUBMIT,LogTime,OpFee}),
            common_misc:send_role_attr_change_gold(PId, NewRoleBase);
        ?mission_do_complete_op_fee_type_silver ->
            common_log:log_silver({NewRoleBase,?LOG_CONSUME_SILVER_MISSION_DO_COMPLETE,LogTime,OpFee}),
            common_misc:send_role_attr_change_silver(PId, NewRoleBase)
    end,
    #m_mission_do_submit_tos{big_group = BigGroup,do_times = DoTimes} = DataRecord,
    SendSelf = #m_mission_do_submit_toc{big_group = BigGroup,
                                        do_times = DoTimes,
                                        op_code=0,
                                        op_fee_type = OpFeeType,
                                        op_fee = OpFee
                                       },
    ?DEBUG("mission submit succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId, Module, Method, SendSelf),
    do_mission_func(RoleId),
    
    hook_mission:hook({mission_finish,RoleId,MissionBaseInfo,DoTimes}),
    hook_mission:hook({mission_commit,RoleId,MissionBaseInfo,DoTimes}),
    
    case catch lists:foldl(
           fun(PInfo,{AccCurPInfo,AccCurMissionBaseInfo}) -> 
                   [PMissionBaseInfo] = cfg_mission:find(PInfo#p_mission_info.id),
                   case PMissionBaseInfo#r_mission_base_info.big_group of
                       BigGroup ->
                           erlang:throw({PInfo,PMissionBaseInfo});
                       _ ->
                           {AccCurPInfo,AccCurMissionBaseInfo}
                   end
           end, {undefined,undefined}, NewRoleMission#r_role_mission.mission_list) of
        {undefined,undefined} ->
            next;
        {CurPInfo,CurMissionBaseInfo} ->
            CurTimes = mod_mission_tool:get_succ_times(NewRoleMission, CurMissionBaseInfo),
            case CurPInfo#p_mission_info.current_status of
                ?MISSION_STATUS_NOT_ACCEPT ->
                    case CurTimes >= CurMissionBaseInfo#r_mission_base_info.max_do_times of
                        true ->
                            UpdateSendSelf = #m_mission_update_toc{del_list=[CurPInfo#p_mission_info.id]};
                        _ ->
                            UpdatePInfo = mission_model_common:init_pinfo(RoleId, false, CurMissionBaseInfo),
                            UpdateSendSelf = #m_mission_update_toc{update_list = [UpdatePInfo]}
                    end,
                    common_misc:unicast(PId,?MISSION,?MISSION_UPDATE,UpdateSendSelf),
                    next;
                _ ->
                    next
            end,
            case CurPInfo#p_mission_info.current_status =:= ?MISSION_STATUS_DOING
                 andalso CurTimes >= CurMissionBaseInfo#r_mission_base_info.max_do_times of
                true ->
                    CancelDataRecord = #m_mission_cancel_tos{id = CurPInfo#p_mission_info.id},
                    Param = {admin_cancel,{RoleId,PId,CancelDataRecord}},
                    common_misc:send_to_role(erlang:self(), {mod,mod_mission,Param}),
                    next;
                _ ->
                    next
            end
    end,
    ok.
do_mission_do_submit_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_mission_do_submit_toc{big_group=DataRecord#m_mission_do_submit_tos.big_group,
                                        do_times=DataRecord#m_mission_do_submit_tos.do_times,
                                        op_code=OpCode},
    ?DEBUG("mission submit fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).


%% 取消任务
do_mission_cancel(Module,Method,DataRecord,RoleId,PId) ->
    init_mission_func(RoleId),
    case catch b_mission_model:cancel(RoleId,PId,DataRecord) of
        {ok,SendSelf} ->
            ?DEBUG("~ts,SendSelf=~w",["取消息任务返回结果",SendSelf]),
            common_misc:unicast(PId,Module,Method,SendSelf),
            do_mission_func(RoleId);
        {error,OpCode,OpReason} ->
            do_mission_cancel_error(Module,Method,DataRecord,RoleId,PId,OpCode,OpReason);
        Error ->
            ?ERROR_MSG("~ts,Error=~w",["取消息任务出错",Error]),
            OpCode = ?_RC_MISSION_CANCEL_000,
            OpReason = "",
            do_mission_cancel_error(Module,Method,DataRecord,RoleId,PId,OpCode,OpReason)
    end.
do_mission_cancel_error(Module,Method,DataRecord,RoleId,PId,OpCode,OpReason) ->
    erase_mission_func(RoleId),
    SendSelf = #m_mission_cancel_toc{id=DataRecord#m_mission_cancel_tos.id,
                                     op_code=OpCode,
                                     op_reason=OpReason},
    ?DEBUG("~ts,SendSelf=~w",["取消息任务返回结果",SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).

%% 任务侦听器处理
do_listener_dispatch({RoleId,Type,SubType}) ->
    case catch do_listener_dispatch2(RoleId,Type,SubType) of
        {error,_Reason} ->
            %%?ERROR_MSG("~ts,Reason=~w",["处理此任务侦听器出错",Reason]),
            ignore;
        {ok,PId,ListenerInfo} ->
            do_listener_dispatch3(RoleId,PId,Type,SubType,ListenerInfo) 
    end;
do_listener_dispatch(Info) ->
    ?ERROR_MSG("~ts,Info=~w",["无法处理此任务侦听器",Info]).

do_listener_dispatch2(RoleId,Type,SubType) ->
    case mod_mission:get_role_mission(RoleId) of
        {ok,RoleMission} ->
            next;
        _ ->
            RoleMission =undefined,
            erlang:throw({error,not_found_role_mission})
    end,
    case mod_mission_tool:get_listener_list(RoleMission, Type, SubType) of
        {ok,ListenerInfo} ->
            next;
        _ ->
            ListenerInfo = undefined,
            erlang:throw({error,not_found_listener_info})
    end,
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            PId = undefined,
            erlang:throw({error,not_found_role_gateway_pid});
        PId ->
            next
    end,
    {ok,PId,ListenerInfo}.
do_listener_dispatch3(RoleId,PId,_Type,_SubType,ListenerInfo) ->
    init_mission_func(RoleId),
    MissionIdList = ListenerInfo#r_mission_listener.mission_id_list,
    case catch b_mission_model:dispatch_listener(RoleId,PId,MissionIdList,ListenerInfo) of
        {ok,PInfoList} ->
            SendSelf = #m_mission_update_toc{del_list=[],update_list=PInfoList},
            ?DEBUG("~ts,SendSelf=~w",["任务侦听处理返回",SendSelf]),
            common_misc:unicast({role,RoleId},?MISSION,?MISSION_UPDATE,SendSelf),
            do_mission_func(RoleId);
        Error ->
            erase_mission_func(RoleId),
            ?ERROR_MSG("~ts,Error=~w",["任务侦听处理出错",Error])
    end.

role_online(RoleId) ->
    case mod_role:get_role_base(RoleId) of
        {ok,#p_role_base{level=RoleLevel}} ->
            do_role_level_up({RoleId,RoleLevel});
        _ ->
            ignore
    end.
%% 玩家升级变化，相应的任务刷新处理
do_role_level_up({RoleId,Level}) ->
    case catch do_role_level_up2(RoleId,Level) of
        {error,Error} ->
            ?ERROR_MSG("~ts,RoleId=~w,RoleLevel=~w,Error=~w",["玩家升级重新任务列表出错",RoleId,Level,Error]);
        {ok,NewRoleMission,AddMissionIdList,DelMissionIdList} ->
            do_role_level_up3(RoleId,Level,NewRoleMission,AddMissionIdList,DelMissionIdList)
    end.
do_role_level_up2(RoleId,Level) ->
    case mod_mission:get_role_mission(RoleId) of
        {ok,RoleMission} ->
            next;
        _ ->
            RoleMission = undefined,
            erlang:throw({error,role_mission_not_found})
    end,
    #r_role_mission{mission_list = MissionList} = RoleMission,
    NewMissionIdListA = mod_mission_tool:get_group_mission_id_list(Level),
    NewMissionIdListB = mod_mission_tool:get_no_group_mission_id_list(Level),
    [FirtsMissionIdList] = common_config_dyn:find(mission_etc, first_mission_id),
    NewMissionIdList = [NewMissionId || NewMissionId <- NewMissionIdListA ++ NewMissionIdListB,
                                        lists:member(NewMissionId, FirtsMissionIdList) =:= false],
    {AddMissionIdList,DelMissionIdList}=
        lists:foldl(
          fun(NewMissionId,{AccAddMissionIdList,AccDelMissionIdList}) ->
                  case cfg_mission:find(NewMissionId) of
                      [#r_mission_base_info{type=MissionType,big_group=NewBigGroup}] ->
                          case MissionType of
                              ?MISSION_TYPE_LOOP ->
                                  case lists:foldl(
                                         fun(#p_mission_info{id=CurMissionId,color=Color,current_status=CurrentStatus},Acc) -> 
                                                 case cfg_mission:find(CurMissionId) of
                                                     [#r_mission_base_info{big_group=NewBigGroup}] ->
                                                         case Acc =:= {add,0} andalso Color =< ?COLOR_WHITE andalso CurrentStatus =:= ?MISSION_STATUS_NOT_ACCEPT of
                                                             true -> %% 可替换
                                                                 {replace,CurMissionId};
                                                             _ -> %% 不可替换
                                                                 {no,0}
                                                         end;
                                                     _ ->
                                                         Acc
                                                 end
                                         end, {add,0}, MissionList) of
                                      {add,0} ->
                                          {[NewMissionId|AccAddMissionIdList],AccDelMissionIdList};
                                      {replace,CurMissionId} ->
                                          {[NewMissionId|AccAddMissionIdList],[CurMissionId|
                                                                                   lists:delete(CurMissionId, AccDelMissionIdList)]};
                                      {no,0} ->
                                          {AccAddMissionIdList,AccDelMissionIdList}
                                  end;
                              _ -> %% 主线和支线没有直接追加就可以
                                  case lists:keyfind(NewMissionId, #p_mission_info.id, MissionList) of
                                      false ->
                                          {[NewMissionId|AccAddMissionIdList],AccDelMissionIdList};
                                      _ ->
                                          {AccAddMissionIdList,AccDelMissionIdList}
                                  end
                          end;
                      _ ->
                          {AccAddMissionIdList,AccDelMissionIdList}
                  end
          end, {[],[]}, NewMissionIdList),
    NewMissionList = [CurPInfo || #p_mission_info{id=CurMissionId} = CurPInfo <- MissionList,
                                  lists:member(CurMissionId, DelMissionIdList) =:= false ],
    NewRoleMission = 
        lists:foldl(
          fun(DelMissionId,AccRoleMission) -> 
                  case cfg_mission:find(DelMissionId) of
                      [DelMissionBaseInfo] ->
                          mod_mission_tool:del_mission_listener(AccRoleMission, DelMissionBaseInfo);
                      _ ->
                          AccRoleMission
                  end
          end, RoleMission, DelMissionIdList),
    NewRoleMission2 = NewRoleMission#r_role_mission{mission_list=NewMissionList},
    {ok,NewRoleMission2,AddMissionIdList,DelMissionIdList}.
do_role_level_up3(RoleId,Level,RoleMission,AddMissionIdList,DelMissionIdList) ->
    case common_transaction:transaction(
           fun() ->
                   do_t_role_level_up(RoleId,RoleMission,AddMissionIdList)
           end) of
        {atomic,{ok,NewRoleMission,AddPInfoList}} ->
            do_role_level_up4(RoleId,Level,NewRoleMission,AddPInfoList,DelMissionIdList);
        {aborted, Error} ->
            ?ERROR_MSG("~ts,RoleId=~w,RoleLevel=~w,Error=~w",["玩家升级重新任务列表出错",RoleId,Level,Error])
    end. 
do_t_role_level_up(RoleId,RoleMission,AddMissionIdList) ->
    mod_mission:t_set_role_mission(RoleId, RoleMission),
     AddPInfoList = 
        lists:foldl(
          fun(AddMissionId,AccAddPInfoList)-> 
                  case cfg_mission:find(AddMissionId) of
                      [AddMissionBaseInfo] ->
                          case catch mod_mission_auth:auth_show(RoleId, AddMissionBaseInfo) of
                              {ok} ->
                                  AddPInfo = mission_model_common:init_pinfo(RoleId, false, AddMissionBaseInfo),
                                  [AddPInfo|AccAddPInfoList];
                              _ ->
                                  AccAddPInfoList
                          end;
                      _ ->
                          AccAddPInfoList
                  end
          end, [], AddMissionIdList),
    NewRoleMission = RoleMission#r_role_mission{mission_list=AddPInfoList ++ RoleMission#r_role_mission.mission_list},
    mod_mission:t_set_role_mission(RoleId, NewRoleMission),
    {ok,NewRoleMission,AddPInfoList}.
do_role_level_up4(RoleId,_Level,NewRoleMission,AddPInfoList,DelMissionIdList) ->
    #r_role_mission{mission_list=MissionList}=NewRoleMission,
    NewDelMissionIdList = [DelMissionId || DelMissionId <- DelMissionIdList,lists:keyfind(DelMissionId,#p_mission_info.id, MissionList) =:= false],
    SendSelf=#m_mission_update_toc{del_list = NewDelMissionIdList,update_list=AddPInfoList},
    ?DEBUG("~ts,SendSelf=~w",["玩家升级任务重置返回",SendSelf]),
    common_misc:unicast({role, RoleId},?MISSION,?MISSION_UPDATE,SendSelf),
    ok.
    