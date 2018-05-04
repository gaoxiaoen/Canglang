%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-24
%% Description: 任务模块工具类
-module(mod_mission_tool).

%%
%% Include files
%%
-include("mgeew.hrl").
%%
%% Exported Functions
%%
-export([
         get_p_mission_info/2,
         
         get_succ_times/2,
         set_succ_times/3,
		 set_succ_times/4,
         get_fail_times/2,
         
         get_counter_key/2,
         get_counter_info/2,
         
         get_listener_key/2,
         get_listener_list/2,
         get_listener_list/3,
         
         get_group_random_one/2,
         
         add_mission_listener/2,
         del_mission_listener/2,
         
         get_mission_recolor/2,
         get_mission_color/2,
         
         is_mission_auto/2,
         is_mission_complete/2,
         
         get_group_mission_id_list/1,
         get_no_group_mission_id_list/1
         ]).

%%
%% API Functions
%%
%% 获取任务当前信息
get_p_mission_info(RoleId,MissionId) when erlang:is_integer(RoleId) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    get_p_mission_info(RoleMission,MissionId);
get_p_mission_info(RoleMission,MissionId) ->
    case lists:keyfind(MissionId, #p_mission_info.id, RoleMission#r_role_mission.mission_list) of
        false ->
            {error,not_found};
        PInfo ->
            {ok,PInfo}
    end.

%% 获取任务成功次数
get_succ_times(RoleId,MissionBaseInfo) when erlang:is_integer(RoleId) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    get_succ_times(RoleMission,MissionBaseInfo);
get_succ_times(RoleMission,MissionBaseInfo) ->
    CounterInfo = get_counter_info(RoleMission,MissionBaseInfo),
    CounterInfo#r_mission_counter.succ_times.

%% 设置任务次数
%% 返回 {ok,RoleMission,NewCommitTimes}
set_succ_times(RoleId,MissionBaseInfo,AddNum) when erlang:is_integer(RoleId) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    set_succ_times(RoleMission,MissionBaseInfo,AddNum,undefined);
set_succ_times(RoleMission,MissionBaseInfo,AddNum) ->
    set_succ_times(RoleMission,MissionBaseInfo,AddNum,undefined).

set_succ_times(RoleId,MissionBaseInfo,AddNum,OpData) when erlang:is_integer(RoleId) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    set_succ_times(RoleMission,MissionBaseInfo,AddNum,OpData);
set_succ_times(RoleMission,MissionBaseInfo,AddNum,OpData) ->
	CounterInfo = get_counter_info(RoleMission,MissionBaseInfo),
    #r_mission_counter{key = Key,commit_times = CommitTimes,succ_times = SuccTimes} = CounterInfo,
    case CommitTimes + AddNum < 0 of
        true ->
            NewCommitTimes = 0;
        _ ->
            NewCommitTimes = CommitTimes + AddNum
    end,
    case SuccTimes + AddNum < 0 of
        true ->
            NewSuccTimes = 0;
        _ ->
            NewSuccTimes = SuccTimes + AddNum
    end,
    NewCounterInfo = CounterInfo#r_mission_counter{commit_times = NewCommitTimes,
												   succ_times = NewSuccTimes,
												   op_data=OpData},
    CounterList = [NewCounterInfo|lists:keydelete(Key, #r_mission_counter.key, RoleMission#r_role_mission.counter_list)],
    NewRoleMission = RoleMission#r_role_mission{counter_list = CounterList},
    {ok,NewRoleMission,NewCommitTimes}.

%% 获取任务失败次数
get_fail_times(RoleId,MissionBaseInfo) when erlang:is_integer(RoleId) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    get_fail_times(RoleMission,MissionBaseInfo);
get_fail_times(RoleMission,MissionBaseInfo) ->
    CounterInfo = get_counter_info(RoleMission,MissionBaseInfo),
    CounterInfo#r_mission_counter.commit_times - CounterInfo#r_mission_counter.succ_times.

%% 获取任务记数器key
get_counter_key(MissionId,0) ->
    {0, MissionId};
get_counter_key(_MissionId, MissionBigGroup) ->
    {3, MissionBigGroup}.
%% 获取任务记录器信息
%% 返回 #r_mission_counter
get_counter_info(RoleId,MissionBaseInfo) when erlang:is_integer(RoleId)->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    get_counter_info(RoleMission,MissionBaseInfo);
get_counter_info(RoleMission,MissionBaseInfo) ->
    #r_mission_base_info{id= MissionId,type=MissionType,big_group = BigGroup} = MissionBaseInfo,
    Key = get_counter_key(MissionId,BigGroup),
    NowSeconds = common_tool:now(),
	case lists:keyfind(Key, #r_mission_counter.key, RoleMission#r_role_mission.counter_list) of
		false ->
			#r_mission_counter{key = Key,id=MissionId,commit_times = 0,succ_times = 0,op_time = NowSeconds};
		CounterInfo ->
			case MissionType of
				?MISSION_TYPE_LOOP ->
					{NowDay,_} = common_tool:seconds_to_datetime(NowSeconds),
					{OpDay,_} = common_tool:seconds_to_datetime(CounterInfo#r_mission_counter.op_time),
					case NowDay =:= OpDay of
						true ->
							CounterInfo;
						_ ->
							#r_mission_counter{key = Key,id=MissionId,commit_times = 0,succ_times = 0,op_time = NowSeconds}
					end;
				_ ->
					CounterInfo
			end
	end.
    

%% 获取任务侦听key
get_listener_key(Type,SubType) ->
    {Type,SubType}.
get_listener_list(RoleId,Type,SubType) when erlang:is_integer(RoleId) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    get_listener_list(RoleMission,get_listener_key(Type,SubType));
get_listener_list(RoleMission,Type,SubType) ->
    get_listener_list(RoleMission,get_listener_key(Type,SubType)).

get_listener_list(RoleId,Key) when erlang:is_integer(RoleId) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    get_listener_list(RoleMission,Key);
get_listener_list(RoleMission,Key) ->
    case lists:keyfind(Key, #r_mission_listener.key, RoleMission#r_role_mission.listener_list) of
        false ->
            {error,not_found};
        ListenerInfo ->
            {ok,ListenerInfo}
    end.

%% 添加任务侦听器数据
%% 返回 NewRoleMission
add_mission_listener(RoleId,MissionBaseInfo) when erlang:is_integer(RoleId) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    add_mission_listener(RoleMission,MissionBaseInfo);
add_mission_listener(RoleMission,MissionBaseInfo) ->
    #r_mission_base_info{id = MissionId,listener_list = BaseListenerList} = MissionBaseInfo,
    ListenerList = 
        lists:foldl(
          fun(#r_mission_base_listener{type=Type,sub_type=SubType},AccListenerList) -> 
                  Key = get_listener_key(Type, SubType),
                  case lists:keyfind(Key, #r_mission_listener.key, AccListenerList) of
                      false ->
                          [#r_mission_listener{key = Key,
                                               type = Type,
                                               sub_type = SubType,
                                               mission_id_list = [MissionId]}|AccListenerList];
                      ListenerInfo ->
                          MissionIdList = [MissionId|lists:delete(MissionId, ListenerInfo#r_mission_listener.mission_id_list)],
                          [ListenerInfo#r_mission_listener{mission_id_list = MissionIdList}
                                                              |lists:keydelete(Key, #r_mission_listener.key, AccListenerList)]
                  end
          end, RoleMission#r_role_mission.listener_list, BaseListenerList),
    RoleMission#r_role_mission{listener_list = ListenerList}.

%% 删除任务侦听器
%% 返回 NewRoleMission
del_mission_listener(RoleId,MissionBaseInfo)when erlang:is_integer(RoleId) ->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    del_mission_listener(RoleMission,MissionBaseInfo);
del_mission_listener(RoleMission,MissionBaseInfo) ->
    #r_mission_base_info{id = MissionId,listener_list = BaseListenerList} = MissionBaseInfo,
    ListenerList = 
        lists:foldl(
          fun(#r_mission_base_listener{type=Type,sub_type=SubType},AccListenerList) -> 
                  Key = get_listener_key(Type, SubType),
                  case lists:keyfind(Key, #r_mission_listener.key, AccListenerList) of
                      false ->
                          AccListenerList;
                      ListenerInfo ->
                          case lists:delete(MissionId, ListenerInfo#r_mission_listener.mission_id_list) of
                              [] ->
                                  lists:keydelete(Key, #r_mission_listener.key, AccListenerList);
                              MissionIdList ->
                                  [ListenerInfo#r_mission_listener{mission_id_list = MissionIdList}
                                                                      |lists:keydelete(Key, #r_mission_listener.key, AccListenerList)]
                          end
                  end
          end, RoleMission#r_role_mission.listener_list, BaseListenerList),
    RoleMission#r_role_mission{listener_list = ListenerList}.

%% 获取任务颜色信息
%% 返回 #r_mission_recolor{}
get_mission_recolor(RoleId,BigGroup)when erlang:is_integer(RoleId)->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    get_mission_recolor(RoleMission,BigGroup);
get_mission_recolor(RoleMission,BigGroup) ->
    NowSeconds = common_tool:now(),
    #r_role_mission{recolor_list = ReColorList} = RoleMission,
    case lists:keyfind(BigGroup, #r_mission_recolor.big_group, ReColorList) of
        false ->
            [InitCoinTimes] = common_config_dyn:find(mission_etc, mission_recolor_init_coin_times),
            #r_mission_recolor{big_group=BigGroup,op_time=NowSeconds,coin_times=InitCoinTimes};
        ReColorInfo ->
            [RefreshTime] = common_config_dyn:find(mission_etc, mission_recolor_coin_refresh_time),
            [AddTimes] = common_config_dyn:find(mission_etc, mission_recolor_coin_refresh_add_times),
            #r_mission_recolor{color = Color,do_times = DoTimes,op_time = OpTime,
                               coin_times = CoinTimes,last_coin_time = LastCoinTime} = ReColorInfo,
            {OpDay,_} = common_tool:seconds_to_datetime(OpTime),
            {NowDay,_} = common_tool:seconds_to_datetime(NowSeconds),
            case OpDay =/= NowDay of
                true ->
                    NewDoTimes = 0,
                    NewColor = 1,
                    NewOpTime = NowSeconds;
                _ ->
                    NewDoTimes = DoTimes,
                    NewColor = Color,
                    NewOpTime = OpTime
            end,
            case LastCoinTime =/= 0 andalso NowSeconds > LastCoinTime + RefreshTime of
                true ->
                    NewCoinTimes = CoinTimes + AddTimes,
                    NewLastCoinTime = 0;
                _ ->
                    NewCoinTimes = CoinTimes,
                    NewLastCoinTime = LastCoinTime
            end,
            ReColorInfo#r_mission_recolor{color = NewColor,do_times = NewDoTimes,op_time = NewOpTime,
                                          coin_times = NewCoinTimes,last_coin_time = NewLastCoinTime}
    end.
%% 获取任务颜色
get_mission_color(RoleId,MissionBaseInfo) when erlang:is_integer(RoleId)->
    {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
    get_mission_color(RoleMission,MissionBaseInfo);
get_mission_color(RoleMission,MissionBaseInfo) ->
    #r_mission_base_info{big_group = BigGroup,color = InitColor} = MissionBaseInfo,
    case common_config_dyn:find(mission_etc, {can_mission_recolor_biggroup,BigGroup}) of
        [true] ->
            ReColorInfo = get_mission_recolor(RoleMission,BigGroup),
            ReColorInfo#r_mission_recolor.color;
        _ ->
            InitColor
    end.
    
  
%% 根据任务分随机获取任务id
%% MissionId | 0
get_group_random_one(BigGroup,RoleLevel) ->
    GroupInfoList = cfg_mission:get_mission_group(BigGroup),
    {MinLevel,MaxLevel} =  
        (catch lists:foldl(
           fun({PMinLevel,PMaxLevel},Acc) -> 
                   case RoleLevel >= PMinLevel andalso RoleLevel =< PMaxLevel of
                       true ->
                           erlang:throw({PMinLevel,PMaxLevel});
                       _ ->
                           Acc
                   end
           end, {0,0}, GroupInfoList)),
    case cfg_mission:get_mission_id_list({BigGroup,MinLevel,MaxLevel}) of
        [{TotalMissionIdNumber,MissionIdList}] ->
            random:seed(erlang:now()),
            lists:nth(common_tool:random(1, TotalMissionIdNumber), MissionIdList);
        _->
            0
    end.

%% 判断任务是否未完成
%% RoleInfo: RoleId|RoleMission
%% return true|false
is_mission_complete(RoleInfo,MissionBaseInfo) when erlang:is_record(MissionBaseInfo, r_mission_base_info)->
    get_succ_times(RoleInfo,MissionBaseInfo) >= 1;
is_mission_complete(RoleInfo,MissionId)->
    case cfg_mission:find(MissionId) of
        [MissionBaseInfo] ->
            is_mission_complete(RoleInfo,MissionBaseInfo);
        _->false
    end.

    
%% 判断此任务是正在委托
%% 返回 true | false
is_mission_auto(RoleId,MissionBaseInfo) when erlang:is_integer(RoleId) ->
    case MissionBaseInfo#r_mission_base_info.big_group > 0 of
        true ->
            {ok,RoleMission} = mod_mission:get_role_mission(RoleId),
            is_mission_auto(RoleMission,MissionBaseInfo);
        _ ->
            false
    end;
is_mission_auto(RoleMission,MissionBaseInfo) ->
    BigGroup = MissionBaseInfo#r_mission_base_info.big_group,
    case lists:keyfind(BigGroup, #p_mission_auto.big_group, RoleMission#r_role_mission.auto_list) of
        false ->
            false;
        PAutoInfo ->
            case PAutoInfo#p_mission_auto.status of
                ?MISSION_AUTO_STATUS_START ->
                    true;
                _ ->
                    false
            end
    end.

%% 根据玩家等获取玩家当前可以接受的循环任务id列表
%% 返回[MissionId,...]
get_group_mission_id_list(RoleLevel) ->
    GroupIdList = cfg_mission:get_mission_all_group(),
    get_group_mission_id_list2(GroupIdList,RoleLevel,[]).
get_group_mission_id_list2([],_RoleLevel,MissionIdList) ->
    MissionIdList;
get_group_mission_id_list2([BigGroup|GroupIdList],RoleLevel,MissionIdList) ->
    case mod_mission_tool:get_group_random_one(BigGroup, RoleLevel) of
        0 ->
            get_group_mission_id_list2(GroupIdList,RoleLevel,MissionIdList);
        MissionId ->
            get_group_mission_id_list2(GroupIdList,RoleLevel,[MissionId|MissionIdList])
    end.

%% 根据玩家等获取玩家当前可以接受的主线和支线任务id列表
%% 返回[MissionId,...]
get_no_group_mission_id_list(RoleLevel) ->
    LevelList = cfg_mission:get_no_group_level_list(),
    get_no_group_mission_id_list2(LevelList,RoleLevel,[]).
get_no_group_mission_id_list2([],_RoleLevel,MissionIdList) ->
    MissionIdList;
get_no_group_mission_id_list2([{MinLevel,MaxLevel}|LevelList],RoleLevel,MissionIdList) ->
    case RoleLevel >= MinLevel andalso  RoleLevel =< MaxLevel of
        true ->
            AddMissionIdList = cfg_mission:get_no_group_mission_id_list({MinLevel,MaxLevel}),
            get_no_group_mission_id_list2(LevelList,RoleLevel,AddMissionIdList ++ MissionIdList);
        _ ->
            get_no_group_mission_id_list2(LevelList,RoleLevel,MissionIdList)
    end.
    
