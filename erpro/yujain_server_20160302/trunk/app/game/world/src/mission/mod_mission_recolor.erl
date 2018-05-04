%% Author: caochuncheng2002@gmail.com
%% Created: 2013-7-9
%% Description: 刷新任务颜色
-module(mod_mission_recolor).

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

handle({Module,?MISSION_RECOLOR,DataRecord,RoleId,PId,_Line}) ->
    do_mission_recolor(Module,?MISSION_RECOLOR,DataRecord,RoleId,PId);

handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

-define(mission_recolor_op_type_do_query,1).   %% 1查询
-define(mission_recolor_op_type_do_coin,2).    %% 2铜钱刷新
-define(mission_recolor_op_type_do_gold,3).    %% 3金币刷新
-define(mission_recolor_op_type_do_one_key,4). %% 4一键金币刷新
%% 刷新任务颜色
do_mission_recolor(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_mission_recolor2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_mission_recolor_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,ReColorInfo} ->
            do_mission_recolor_query(Module,Method,DataRecord,RoleId,PId,ReColorInfo);
        {ok,RoleBase,RoleMission,PInfo,ReColorInfo,OpFeeType,OpFee,NewColor,AddTimes} ->
            do_mission_recolor3(Module,Method,DataRecord,RoleId,PId,
                                RoleBase,RoleMission,PInfo,ReColorInfo,
                                OpFeeType,OpFee,NewColor,AddTimes)
    end.
do_mission_recolor2(RoleId,DataRecord) ->
    #m_mission_recolor_tos{op_type = OpType,
                           mission_id = MissionId,
                           to_color = ToColor} = DataRecord,
    case cfg_mission:find(MissionId) of
        [MissionBaseInfo] ->
            next;
        _ ->
            MissionBaseInfo = undefined,
            erlang:throw({error,?_RC_MISSION_RECOLOR_003})
    end,
    #r_mission_base_info{big_group = BigGroup} = MissionBaseInfo,
    case common_config_dyn:find(mission_etc, {can_mission_recolor_biggroup,BigGroup}) of
        [true] ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_RECOLOR_006})
    end,
    case OpType of
        ?mission_recolor_op_type_do_query ->
            next;
        ?mission_recolor_op_type_do_coin ->
            next;
        ?mission_recolor_op_type_do_gold ->
            next;
        ?mission_recolor_op_type_do_one_key ->
            case ToColor >= ?COLOR_GREEN andalso ToColor =< ?COLOR_ORANGE of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_RECOLOR_001})
            end,
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_RECOLOR_001})
    end,
    case mod_mission:get_role_mission(RoleId) of
        {ok,RoleMission} ->
            next;
        _ ->
            RoleMission = undefined,
            erlang:throw({error,?_RC_MISSION_RECOLOR_002})
    end,
    case mod_mission_tool:is_mission_auto(RoleMission, MissionBaseInfo) of
        true ->
            erlang:throw({error,?_RC_MISSION_RECOLOR_011});
        _ ->
            next
    end,
    case lists:keyfind(MissionId, #p_mission_info.id, RoleMission#r_role_mission.mission_list) of
        false ->
            PInfo = undefined,
            erlang:throw({error,?_RC_MISSION_RECOLOR_003});
        PInfo ->
            next
    end,
    case PInfo#p_mission_info.color >= ?COLOR_ORANGE of
        true ->
            erlang:throw({error,?_RC_MISSION_RECOLOR_004});
        _ ->
            next
    end,
    case OpType of
        ?mission_recolor_op_type_do_one_key ->
            case ToColor > PInfo#p_mission_info.color of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_RECOLOR_007})
            end;
         _->
             next
    end,
    case PInfo#p_mission_info.current_status of
        ?MISSION_STATUS_NOT_ACCEPT ->
            next;
        _ ->
            erlang:throw({error,?_RC_MISSION_RECOLOR_005})
    end,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_MISSION_RECOLOR_000})
    end,
    ReColorInfo = mod_mission_tool:get_mission_recolor(RoleMission, BigGroup),
    case OpType of
        ?mission_recolor_op_type_do_query ->
            erlang:throw({ok,ReColorInfo});
        _ ->
            next
    end,
    #r_mission_recolor{do_times = DoTimes} = ReColorInfo,
    #p_role_base{coin = Coin,gold = Gold} = RoleBase,
    case OpType of
        ?mission_recolor_op_type_do_coin ->
            case ReColorInfo#r_mission_recolor.coin_times > 0 of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_RECOLOR_008})
            end,
            [OpFee] = common_config_dyn:find(mission_etc, mission_recolor_fee_coin),
            case Coin >= OpFee of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_RECOLOR_009})
            end,
            OpFeeType = coin,
            {NewColor,_,AddTimes} = get_new_color({coin}),
            next;
        ?mission_recolor_op_type_do_gold ->
            OpFeeType = gold,
            [OpFee] = common_config_dyn:find(mission_etc, mission_recolor_fee_gold),
            case Gold >= OpFee of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_RECOLOR_010})
            end,
            {NewColor,_,AddTimes} = get_new_color({gold,DoTimes}),
            next;
        ?mission_recolor_op_type_do_one_key ->
            OpFeeType = gold,
            [PerOpFee] = common_config_dyn:find(mission_etc, mission_recolor_fee_gold),
            case Gold >= PerOpFee of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MISSION_RECOLOR_010})
            end,
            {NewColor,OpFee,AddTimes} = get_new_color({one_key,Gold,PerOpFee,DoTimes,ToColor,0,0,0}),
            next;
        _ ->
            OpFeeType = undefined,
            OpFee = 0,
            NewColor = 0,
            AddTimes = 0,
            next
    end,
    {ok,RoleBase,RoleMission,PInfo,ReColorInfo,OpFeeType,OpFee,NewColor,AddTimes}.

do_mission_recolor_query(Module,Method,DataRecord,_RoleId,PId,ReColorInfo) ->
    SendSelf = #m_mission_recolor_toc{op_type=DataRecord#m_mission_recolor_tos.op_type,
                                      mission_id=DataRecord#m_mission_recolor_tos.mission_id,
                                      to_color=DataRecord#m_mission_recolor_tos.to_color,
                                      op_code=0,
                                      new_color=ReColorInfo#r_mission_recolor.color,
                                      coin_tims=ReColorInfo#r_mission_recolor.coin_times,
                                      last_coin_time=ReColorInfo#r_mission_recolor.last_coin_time
                                      },
    ?DEBUG("do mission recolor query succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).

do_mission_recolor3(Module,Method,DataRecord,RoleId,PId,
                    RoleBase,RoleMission,PInfo,ReColorInfo,
                    OpFeeType,OpFee,NewColor,AddTimes) ->
    OldColor = ReColorInfo#r_mission_recolor.color,
    case common_transaction:transaction(
           fun() ->
                   do_t_mission_recolor(RoleId,RoleBase,RoleMission,PInfo,ReColorInfo,OpFeeType,OpFee,NewColor,AddTimes)
           end) of
        {atomic,{ok,NewRoleBase,NewPInfo,NewReColorInfo}} ->
            do_mission_recolor4(Module,Method,DataRecord,RoleId,PId,
                                NewRoleBase,NewPInfo,NewReColorInfo,OpFeeType,OpFee,OldColor,NewColor,AddTimes);
        {aborted, Error} ->
            case erlang:is_integer(Error) of
                true ->
                    OpCode = Error;
                _ ->
                    OpCode = ?_RC_MISSION_RECOLOR_000
            end,
            do_mission_recolor_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end. 
do_t_mission_recolor(RoleId,RoleBase,RoleMission,PInfo,ReColorInfo,OpFeeType,OpFee,NewColor,AddTimes) ->
    #p_role_base{coin = Coin,gold = Gold} = RoleBase,
    #r_mission_recolor{do_times = DoTimes,coin_times = CoinTimes,last_coin_time = LastCoinTime} = ReColorInfo,
    case OpFeeType of
        coin ->
            NewCoinTimes = CoinTimes - AddTimes,
            NewLastCoinTime = 0,
            NewCoin = Coin - OpFee,
            NewGold = Gold;
        gold ->
            NewCoinTimes = CoinTimes,
            NewLastCoinTime = LastCoinTime,
            NewCoin = Coin,
            NewGold = Gold - OpFee
    end,
    NewRoleBase = RoleBase#p_role_base{coin = NewCoin,gold = NewGold},
    mod_role:t_set_role_base(RoleId, NewRoleBase),
    
    NewReColorInfo = ReColorInfo#r_mission_recolor{color = NewColor,
                                                   do_times = DoTimes + AddTimes,
                                                   op_time = common_tool:now(),
                                                   coin_times = NewCoinTimes,
                                                   last_coin_time = NewLastCoinTime},
    #r_role_mission{recolor_list = ReColorList,mission_list = MissionList} = RoleMission,
    
    NewReColorList = [NewReColorInfo|lists:keydelete(ReColorInfo#r_mission_recolor.big_group, #r_mission_recolor.big_group, ReColorList)],
    NewPInfo = PInfo#p_mission_info{color = NewColor},
    NewMissionList = [NewPInfo|lists:keydelete(PInfo#p_mission_info.id, #p_mission_info.id, MissionList)],
    
    NewRoleMission = RoleMission#r_role_mission{recolor_list = NewReColorList,mission_list = NewMissionList},
    
    mod_mission:t_set_role_mission(RoleId, NewRoleMission),
    {ok,NewRoleBase,NewPInfo,NewReColorInfo}.
do_mission_recolor4(Module,Method,DataRecord,_RoleId,PId,
                    NewRoleBase,NewPInfo,NewReColorInfo,OpFeeType,OpFee,_OldColor,NewColor,AddTimes) ->
    LogTime = common_tool:now(),
    case OpFeeType of
        coin ->
            common_log:log_coin({NewRoleBase,?LOG_CONSUME_COIN_MISSION_RECOLOR,LogTime,OpFee});
        gold ->
            common_log:log_gold({NewRoleBase,?LOG_CONSUME_GOLD_MISSION_RECOLOR,LogTime,OpFee,common_tool:to_list(AddTimes)})
    end,
    UpdateSendSelf = #m_mission_update_toc{update_list = [NewPInfo]},
    common_misc:unicast(PId, ?MISSION, ?MISSION_UPDATE,UpdateSendSelf),
    
    SendSelf = #m_mission_recolor_toc{op_type=DataRecord#m_mission_recolor_tos.op_type,
                                      mission_id=DataRecord#m_mission_recolor_tos.mission_id,
                                      to_color=DataRecord#m_mission_recolor_tos.to_color,
                                      op_code=0,
                                      new_color = NewColor,
                                      coin_tims = NewReColorInfo#r_mission_recolor.coin_times,
                                      last_coin_time = NewReColorInfo#r_mission_recolor.last_coin_time,
                                      op_fee = OpFee
                                      },
    ?DEBUG("do mission recolor succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.
do_mission_recolor_error(Module,Method,DataRecord,_RoleId,PId,OpCode)->
    SendSelf = #m_mission_recolor_toc{op_type=DataRecord#m_mission_recolor_tos.op_type,
                                      mission_id=DataRecord#m_mission_recolor_tos.mission_id,
                                      to_color=DataRecord#m_mission_recolor_tos.to_color,
                                      op_code=OpCode},
    ?DEBUG("do mission recolor fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).



%% 计算任务颜色
%% {NewColor,OpFee,AddTimes} | {NewColor,0,AddTimes}
get_new_color({coin}) ->
    [WeightList] = common_config_dyn:find(mission_etc, mission_recolor_coin_weight),
    NewColor = common_tool:get_random_index(WeightList, 0, 1),
    {NewColor,0,1};
get_new_color({gold,DoTimes}) ->
    [GoldWeightList] = common_config_dyn:find(mission_etc, mission_recolor_gold_weight),
    WeightList = 
        lists:foldl(
          fun({MinTimes,MaxTimes,PWeightList},AccWeightList) ->
                  case AccWeightList =:= [] andalso DoTimes >= MinTimes 
                      andalso (MaxTimes =:= 0 orelse MaxTimes > DoTimes) of
                      true ->
                          PWeightList;
                      _ ->
                          AccWeightList
                  end
          end, [], GoldWeightList),
    NewColor = common_tool:get_random_index(WeightList, 0, 1),
    {NewColor,0,1};
get_new_color({one_key,TotalGold,PerGold,DoTimes,ToColor,CurColor,TotalFee,TotalTimes}) ->
    case PerGold > TotalGold orelse CurColor >= ToColor of
        true ->
            {CurColor,TotalFee,TotalTimes};
        _ ->
            [GoldWeightList] = common_config_dyn:find(mission_etc, mission_recolor_gold_weight),
            WeightList = 
                lists:foldl(
                  fun({MinTimes,MaxTimes,PWeightList},AccWeightList) ->
                          case AccWeightList =:= [] andalso DoTimes >= MinTimes 
                              andalso (MaxTimes =:= 0 orelse MaxTimes > DoTimes) of
                              true ->
                                  PWeightList;
                              _ ->
                                  AccWeightList
                          end
                  end, [], GoldWeightList),
            random:seed(erlang:now()),
            NewColor = common_tool:get_random_index(WeightList, 0, 1),
            case NewColor >= ToColor orelse (TotalGold - PerGold) <  PerGold of
                true ->
                    {NewColor,TotalFee + PerGold,TotalTimes + 1};
                _ ->
                    get_new_color({one_key,TotalGold - PerGold,PerGold,DoTimes + 1,ToColor,NewColor,TotalFee + PerGold,TotalTimes + 1})
            end
    end.
