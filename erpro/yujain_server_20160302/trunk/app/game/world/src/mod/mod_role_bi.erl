%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-5
%% Description: 玩家模块功能处理
-module(mod_role_bi).

%%
%% Include files
%%
-include("mgeew.hrl").
%%
%% Exported Functions
%%
-export([
         handle/1,
         hook_role_offline/2,
         do_add_exp/3,
         add_coin/3,
         auth_role_pos/4
         ]).


handle({sync_map_change_data,DataList}) ->
    do_sync_map_change_data(DataList);

handle({add_exp,RoleId,AddExpType,AddExp}) ->
    do_add_exp(RoleId,AddExpType,AddExp);

handle({Module,?ROLE_GET_INFO,DataRecord,RoleId,PId,_Line}) ->
    do_get_role_info(Module,?ROLE_GET_INFO,DataRecord,RoleId,PId);

handle({Module,?ROLE_SET,DataRecord,RoleId,PId,_Line}) ->
    do_role_set(Module,?ROLE_SET,DataRecord,RoleId,PId);

handle({Module,?ROLE_CURE,DataRecord,RoleId,PId,_Line}) ->
    do_role_cure(Module,?ROLE_CURE,DataRecord,RoleId,PId);

handle({sync_map_actor, Info}) ->
    do_sync_map_actor(Info);

handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

%% 地图进程同步地图数据
do_sync_map_change_data([H|T]) ->
    do_sync_map_change_data2(H),
    do_sync_map_change_data(T);
do_sync_map_change_data([]) ->
    ok;
do_sync_map_change_data(Info) ->
    ?ERROR_MSG("do sync map change data receive unknown message,Info=~w",[Info]).

do_sync_map_change_data2({role_pos,RoleId,IsChangeMap,MapId,MapProcessName,GroupId,NewPos}) ->
    {ok,RolePos} = mod_role:get_role_pos(RoleId),
    #r_role_pos{map_id=LastMapId,pos=LastPos,map_process_name=LastMapProcessName,group_id=LastGroupId} = RolePos,
    case IsChangeMap of
        true ->
            NewRolePos = RolePos#r_role_pos{map_id = MapId,
                                            pos=NewPos,
                                            map_process_name=MapProcessName,
                                            group_id=GroupId,
                                            last_map_id=LastMapId,
                                            last_pos=LastPos,
                                            last_map_process_name = LastMapProcessName,
                                            last_group_id=LastGroupId};
        _ ->
            NewRolePos = RolePos#r_role_pos{pos=NewPos}
    end,
    mod_role:set_role_pos(RoleId, NewRolePos),
    ok;
do_sync_map_change_data2(Info) ->
    ?ERROR_MSG("do sync map change data receive unknown message,Info=~w",[Info]).
    
%% 玩家下线数据操作
hook_role_offline(RoleId,NowSeconds) ->
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    case NowSeconds - RoleBase#p_role_base.last_login_time > 0 of
       true ->
           TotalOnlineTime = RoleBase#p_role_base.total_online_time + NowSeconds - RoleBase#p_role_base.last_login_time;
       _ ->
           TotalOnlineTime = RoleBase#p_role_base.total_online_time
    end,
    NewRoleBase = RoleBase#p_role_base{last_offline_time = NowSeconds,total_online_time = TotalOnlineTime},
    mod_role:set_role_base(RoleId, NewRoleBase),
    ok.

%% 玩家上线验证时，处理玩家位置信息，处理下线之后上线玩家位置变化
-spec 
auth_role_pos(RoleId,FactionId,LastOffineTime,RolePos) -> NewRolePos when
    RoleId :: integer,
    FactionId :: 0|1|2|3,
    LastOffineTime :: integer,
    RolePos :: #r_role_pos{},
    NewRolePos :: #r_role_pos{}.
auth_role_pos(RoleId,FactionId,LastOffineTime,RolePos) ->
    case catch auth_role_pos2(LastOffineTime,RolePos) of
        {ok} ->
            auth_role_pos4(RoleId,FactionId,RolePos);
        {last} ->
            #r_role_pos{last_map_id=MapId,
                        last_pos=LastPos,
                        last_map_process_name=MapProcessName,
                        last_group_id=LastGroupId} = RolePos,
            case erlang:whereis(MapProcessName) of
                MapPId when erlang:is_pid(MapPId) ->
                    NewRolePos = RolePos#r_role_pos{map_id=MapId,pos=LastPos,map_process_name=MapProcessName,group_id=LastGroupId},
                    auth_role_pos4(RoleId,FactionId,NewRolePos);
                _ ->
                    auth_role_pos3(RoleId,FactionId)
            end;
        {ok,NewRolePos} ->
            auth_role_pos4(RoleId,FactionId,NewRolePos);
        _ ->
            auth_role_pos3(RoleId,FactionId)
    end.
auth_role_pos2(LastOffineTime,RolePos) ->
    #r_role_pos{map_id=MapId,map_process_name=MapProcessName} = RolePos,
    case cfg_map:get_map_info(MapId) of
        [#r_map_info{map_type=?MAP_TYPE_FB}] ->
            next;
        _ ->
            erlang:throw({ok})
    end,
    %% 根据副本的进程名称获取副本的id
    DataList = string:tokens(erlang:atom_to_list(MapProcessName), "_"),
    FbId = common_tool:to_integer(lists:nth(3, DataList)),
    case cfg_fb:find(FbId) of
        undefined ->
            ProtectTime = 0,
            erlang:throw({last});
        #r_fb_info{map_id=MapId,protect_time=ProtectTime} ->
            next;
        _ ->
            ProtectTime = 0,
            erlang:throw({last})
    end,
    case common_tool:now() - LastOffineTime > ProtectTime of
        true ->
            erlang:throw({last});
        _ ->
            next
    end,
    case erlang:whereis(MapProcessName) of
        undefined ->
            erlang:throw({last});
        MapPId when erlang:is_pid(MapPId) ->
            erlang:throw({ok})
    end,
    {ok}.
auth_role_pos3(RoleId,FactionId) ->
    MapId= cfg_common:find({newer_born_map_id,FactionId}),
    {X,Y} = cfg_common:find({newer_born_point,FactionId}),
    MapProcessName = common_map:get_common_map_name(MapId),
    #r_role_pos{
        role_id=RoleId,
        map_id=MapId,
        pos=#p_pos{x=X, y=Y},
        map_process_name=MapProcessName,
        group_id = 0,
        last_map_id = MapId,
        last_pos = #p_pos{x=X, y=Y},
        last_map_process_name=MapProcessName,
        last_group_id = 0
       }.
%% 检查坐标点是否合法，即如果更新了地图，即直接在当前地图的出生点
%% 如果地图也更新了，直接使用出生点
auth_role_pos4(RoleId,FactionId,RolePos) ->
    #r_role_pos{pos=#p_pos{x=X,y=Y},map_id=MapId} = RolePos,
    case cfg_map:get_map_info(MapId) of
        [#r_map_info{mcm_module=McmModule}] ->
            {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
            case McmModule:get_slice_name({Tx,Ty}) of
                [#r_map_slice{}] ->
                    RolePos;
                _ ->
                    [{NewX,NewY}] = cfg_map:get_map_bron_point(MapId),
                    RolePos#r_role_pos{pos=#p_pos{x=NewX,y=NewY}}
            end;
        _ ->
            auth_role_pos3(RoleId,FactionId)
    end.
            

%% 玩家加经验操作
do_add_exp(RoleId,AddExpType,PAddExp) ->
    AddExp = common_tool:ceil(PAddExp),
    case catch do_add_exp2(RoleId,AddExpType,AddExp) of
        {ignore,Reason} ->
            ?ERROR_MSG("~ts,Reason=~w",[?_LANG_ROLE_001,Reason]);
        {error,OpCode} ->
            do_add_exp_error(RoleId,AddExpType,AddExp,OpCode);
        {ok,RoleBase,NewLevel,NewExp,NewNextLevelExp} ->
            do_add_exp3(RoleId,AddExpType,AddExp,
                        RoleBase,NewLevel,NewExp,NewNextLevelExp)
    end.

do_add_exp2(RoleId,AddExpType,AddExp) ->
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({ignore,not_found_role_base})
    end,
    case mod_role:get_role_state(RoleId) of
        {ok,RoleState} ->
            next;
        _ ->
            RoleState = undefined,
            erlang:throw({ignore,not_found_role_state})
    end,
    [MaxRoleLevel] = common_config_dyn:find(etc,max_role_level),
    [AutoLevelUp] = common_config_dyn:find(etc, auto_level_up),
    [StoreRoleExpMulti] = common_config_dyn:find(etc, store_role_exp_multi),
    %% 当前状态是否可以增加经验
    case RoleState#r_role_state.status of
        ?ACTOR_STATUS_NORMAL ->
            next;
        _ ->
            case AddExpType of
                ?ADD_EXP_TYPE_MISSION ->
                    next;
                ?ADD_EXP_TYPE_EXP_GOODS ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_ROLE_EXP_CHANGE_002})
            end
    end,
    %% 当前经验是否已经储存满了，则不能增加经验
    #p_role_base{exp=Exp, level=Level, next_level_exp=NextLevelExp} = RoleBase,
    case Level =:= MaxRoleLevel andalso  Exp >= NextLevelExp * StoreRoleExpMulti of
        true -> %% 玩家已经最大等级，且经验储存满了，不可获得经验
            erlang:throw({error,?_RC_ROLE_EXP_CHANGE_001});
        _ ->
            next
    end,
    case Exp >= NextLevelExp * StoreRoleExpMulti andalso Level >= AutoLevelUp  of
        true ->
            erlang:throw({error,?_RC_ROLE_EXP_CHANGE_003});
        _ ->
            next
    end,
    %% 计算当前等级
    case (Exp + AddExp) >= NextLevelExp of
        true ->
            case Level < AutoLevelUp  andalso MaxRoleLevel >= (Level + 1) of
                true -> %% 升级
                    {NewExp,NewLevel} = calc_new_level(Exp + AddExp,Level),
                    #r_level_exp{exp = NewNextLevelExp} = cfg_role_level_exp:find(NewLevel);
                _ ->
                    NewExp =  Exp + AddExp,
                    NewLevel = Level,
                    NewNextLevelExp = NextLevelExp
            end;
        _ ->
            NewExp =  Exp + AddExp,
            NewLevel = Level,
            NewNextLevelExp = NextLevelExp
    end,
    {ok,RoleBase,NewLevel,NewExp,NewNextLevelExp}.

calc_new_level(CurExp,CurLevel) ->
    #r_level_exp{exp = NextLevelExp} = cfg_role_level_exp:find(CurLevel),
    case CurExp >= NextLevelExp of
        true ->
            calc_new_level(CurExp - NextLevelExp,CurLevel + 1);
        _ ->
            {CurExp,CurLevel}
    end.
    
do_add_exp3(RoleId,AddExpType,AddExp,
            RoleBase,NewLevel,NewExp,NewNextLevelExp) ->
    case common_transaction:transaction(
           fun() ->
                   do_t_add_exp(RoleId,RoleBase,NewLevel,NewExp,NewNextLevelExp)
           end) of
        {atomic,{ok,NewRoleBase}} ->
            OldLevel = RoleBase#p_role_base.level,
            do_add_exp4(RoleId,AddExpType,AddExp,NewRoleBase,OldLevel,NewLevel);
        {aborted, Error} ->
            case Error of
                {error,OpCode} ->
                    next;
                _ ->
                    ?ERROR_MSG("~ts,RoleId=~w,AddExpType=~w,AddExp=~w,Error=~w",[?_LANG_ROLE_002,RoleId,AddExpType,AddExp,Error]),
                    OpCode = ?_RC_ROLE_EXP_CHANGE_000
            end,
            do_add_exp_error(RoleId,AddExpType,AddExp,OpCode)
    end.
do_t_add_exp(RoleId,RoleBase,NewLevel,NewExp,NewNextLevelExp) ->
    NewRoleBase = RoleBase#p_role_base{level = NewLevel,exp = NewExp,next_level_exp = NewNextLevelExp},
    mod_role:t_set_role_base(RoleId, NewRoleBase),
    {ok,NewRoleBase}.
do_add_exp4(RoleId,AddExpType,AddExp,NewRoleBase,OldLevel,NewLevel) ->
    %% 通知属性变化
    #p_role_base{role_name=RoleName,
                 account_name = AccountName,
                 faction_id=FactionId,
                 exp=NewExp,
                 next_level_exp=NewNextLevelExp,
                 last_login_ip=LastLoginIP} = NewRoleBase,
    AttrList = [#p_attr{attr_code = ?ROLE_BASE_EXP,int_value =NewExp},
                #p_attr{attr_code = ?ROLE_BASE_NEXT_LEVEL_EXP,int_value = NewNextLevelExp},
                #p_attr{attr_code = ?ROLE_BASE_LEVEL,int_value = NewLevel}],
    common_misc:send_role_attr_change(RoleId, AttrList),
    case OldLevel =/= NewLevel of
        true -> %% 记录升级日志
            LogRoleLevelUpList = 
                lists:foldl(
                  fun(LogLevel,AccLogRoleLevelUpList) -> 
                          [#r_log_role_level_up{role_id=RoleId,
                                                role_name=RoleName,
                                                account_name=AccountName,
                                                prev_level=LogLevel - 1,
                                                level=LogLevel,
                                                level_up_reason=AddExpType,
                                                mtime=common_tool:now(),
                                                log_desc="",
                                                ip=LastLoginIP}|AccLogRoleLevelUpList]
                  end,[],lists:seq(OldLevel + 1,NewLevel,1)),
            common_log:insert_log(role_level_up, LogRoleLevelUpList),
            SendSelf = #m_role_level_up_toc{op_code=0,
                                            role_id=RoleId,
                                            add_exp_type = AddExpType,
                                            add_exp=AddExp,
                                            old_level=OldLevel,
                                            new_level=NewLevel},
            ?DEBUG("add role exp return,SendSelf=~w",[SendSelf]),
            common_misc:unicast({role,RoleId},?ROLE,?ROLE_LEVEL_UP,SendSelf),
            next;
        _ ->
            SendSelf=#m_role_add_exp_toc{op_code=0,
                                         role_id=RoleId,
                                         add_exp_type = AddExpType,
                                         add_exp=AddExp,
                                         old_level=OldLevel,
                                         new_level=NewLevel},
            ?DEBUG("add role exp return,SendSelf=~w",[SendSelf]),
            common_misc:unicast({role,RoleId},?ROLE,?ROLE_ADD_EXP,SendSelf),
            next
    end,
	case OldLevel =/= NewLevel of
		true ->
			?TRY_CATCH(hook_role:hook_role_level_up(RoleId, OldLevel, NewLevel, FactionId),LevelUpErr);
		_ ->
			next
	end,
    ok.
do_add_exp_error(RoleId,AddExpType,AddExp,OpCode) ->
    SendSelf=#m_role_add_exp_toc{op_code=OpCode,
                                 role_id=RoleId,
                                 add_exp_type = AddExpType,
                                 add_exp=AddExp,
                                 old_level=0,
                                 new_level=0},
    ?ERROR_MSG("add role exp error,SendSelf=~w",[SendSelf]),
    common_misc:unicast({role,RoleId},?ROLE,?ROLE_ADD_EXP,SendSelf).

%% 加铜钱
add_coin(RoleId,AddCoin,LogType)->
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    case AddCoin > 0 of
        true->
            NewRoleBase = RoleBase#p_role_base{coin=RoleBase#p_role_base.coin+AddCoin},
            Now = mgeew_role:get_now(),
            mod_role:set_role_base(RoleId, NewRoleBase),
            common_log:log_coin({NewRoleBase,LogType,Now,AddCoin}),
            common_misc:send_role_attr_change_coin(RoleId, NewRoleBase);
        _->
            ignore
    end.

-define(get_role_info_op_type_role,1).           %% 查询玩家信息 
%% 查询玩家信息
do_get_role_info(Module,Method,DataRecord,RoleId,PId) ->
	case catch do_get_role_info2(RoleId,DataRecord) of
		{error,OpCode} ->
			do_get_role_info_error(Module,Method,DataRecord,RoleId,PId,OpCode);
		{ok,PRoleInfo} ->
			do_get_role_info3(Module,Method,DataRecord,RoleId,PId,PRoleInfo)
	end.
do_get_role_info2(_RoleId,DataRecord) ->
	#m_role_get_info_tos{id=PId} = DataRecord,
	case PId > 0 andalso erlang:is_integer(PId) of
		true ->
			next;
		_ ->
			erlang:throw({error,?_RC_ROLE_GET_INFO_000})
	end,
	case mod_role:get_role_base(PId) of
		{ok,RoleBase} ->
			next;
		_ ->
			case common_misc:get_role_base(PId) of
				{ok,RoleBase} ->
					next;
				_ ->
					RoleBase = undefined,
					erlang:throw({error,?_RC_ROLE_GET_INFO_001})
			end
	end,
	PRoleInfo = #p_role_info{role_id=RoleBase#p_role_base.role_id,
							 role_name=RoleBase#p_role_base.role_name,
							 sex=RoleBase#p_role_base.sex,
                             skin=RoleBase#p_role_base.skin,
							 faction_id=RoleBase#p_role_base.faction_id,
							 category=RoleBase#p_role_base.category,
							 level=RoleBase#p_role_base.level,
							 family_id=RoleBase#p_role_base.family_id,
							 family_name=RoleBase#p_role_base.family_name},
	{ok,PRoleInfo}.

do_get_role_info3(Module,Method,DataRecord,_RoleId,PId,PRoleInfo) ->
	SendSelf = #m_role_get_info_toc{op_type=DataRecord#m_role_get_info_tos.op_type,
									id=DataRecord#m_role_get_info_tos.id,
									op_code=0,
									role_info=PRoleInfo},
	?DEBUG("get role info succ,SendSelf=~w",[SendSelf]),
	common_misc:unicast(PId,Module,Method,SendSelf),
	ok.
do_get_role_info_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
	SendSelf = #m_role_get_info_toc{op_type=DataRecord#m_role_get_info_tos.op_type,
									id=DataRecord#m_role_get_info_tos.id,
									op_code=OpCode},
	?DEBUG("get role info fail,SendSelf=~w",[SendSelf]),
	common_misc:unicast(PId,Module,Method,SendSelf).



%% 修改玩家属性
do_role_set(Module,Method,DataRecord,RoleId,PId) ->
	case catch do_role_set2(RoleId,DataRecord) of
		{error,OpCode} ->
			do_role_set_error(Module,Method,DataRecord,RoleId,PId,OpCode);
		{ok,RoleBase,NewRoleBase} ->
			do_role_set3(Module,Method,DataRecord,RoleId,PId,RoleBase,NewRoleBase)
	end.
do_role_set2(RoleId,DataRecord) ->
	#m_role_set_tos{attr_list=AttrList} = DataRecord,
	case AttrList =/= [] andalso erlang:is_list(AttrList) of
		true ->
			next;
		_ ->
			erlang:throw({error,?_RC_ROLE_SET_001})
	end,
	case mod_role:get_role_base(RoleId) of
		{ok,RoleBase} ->
			next;
		_ ->
			RoleBase = undefined,
			erlang:throw({error,?_RC_ROLE_SET_000})
	end,
	lists:foreach(
	  fun(Attr) -> 
			  case Attr#p_attr.attr_code of
				  ?ROLE_BASE_FACTION_ID ->
					  case Attr#p_attr.int_value of
						  ?FACTION_ID_0 ->
							  next;
						  ?FACTION_ID_1 ->
							  next;
						  ?FACTION_ID_2 ->
							  next;
						  ?FACTION_ID_3 ->
							  next;
						  _ ->
							  erlang:throw({error,?_RC_ROLE_SET_003})
					  end,
					  case RoleBase#p_role_base.faction_id =:= 0 of
						  true ->
							  next;
						  _ ->
							  erlang:throw({error,?_RC_ROLE_SET_004})
					  end;
				  _ ->
					  erlang:throw({error,?_RC_ROLE_SET_002})
			  end
	  end, AttrList),
	NewRoleBase = 
		lists:foldl(
		  fun(Attr,AccRoleBase) -> 
				  case Attr#p_attr.attr_code of
					  ?ROLE_BASE_FACTION_ID ->
						  case Attr#p_attr.int_value of
							  ?FACTION_ID_0 ->
								  NewFactionId = common_misc:get_random_faction_id();
							  _ ->
								  NewFactionId = Attr#p_attr.int_value
						  end,
						  AccRoleBase#p_role_base{faction_id=NewFactionId}
				  end
		  end, RoleBase, AttrList),
	{ok,RoleBase,NewRoleBase}.
do_role_set3(Module,Method,DataRecord,RoleId,PId,_RoleBase,NewRoleBase) ->
	case common_transaction:transaction(
		   fun() ->
				   mod_role:t_set_role_base(RoleId, NewRoleBase),
				   {ok}
		   end) of
		{atomic,{ok}} ->
			case lists:keyfind(?ROLE_BASE_FACTION_ID, #p_attr.attr_code, DataRecord#m_role_set_tos.attr_list) of
				false ->
					IsChangeFactionId=false,
					AttrList = DataRecord#m_role_set_tos.attr_list;
				_ ->
					IsChangeFactionId=true,
					AttrList = [#p_attr{attr_code=?ROLE_BASE_FACTION_ID,int_value=NewRoleBase#p_role_base.faction_id}
								|lists:keydelete(?ROLE_BASE_FACTION_ID, #p_attr.attr_code, DataRecord#m_role_set_tos.attr_list)]
			end,
			common_misc:send_role_attr_change(PId, RoleId, AttrList),
			
			SendSelf = #m_role_set_toc{op_type=DataRecord#m_role_set_tos.op_type,
									   attr_list=DataRecord#m_role_set_tos.attr_list,
									   op_code=0},
			?DEBUG("set role info succ,SendSelf=~w",[SendSelf]),
			common_misc:unicast(PId,Module,Method,SendSelf),
			
			%% 国家修改需要处理其它逻辑
			case IsChangeFactionId of
				true ->
					%% #p_map_role{}
					MapRoleAttrList = [{#p_map_role.faction_id,NewRoleBase#p_role_base.faction_id}],
					common_misc:send_to_role_map(RoleId, {mod,mod_map_role,{update_map_role_info,{RoleId,MapRoleAttrList}}}),
					next;
				_ ->
					next
			end,
			ok;
		{aborted, Error} ->
			case erlang:is_integer(Error) of
				true ->
					OpCode = Error;
				_ ->
					OpCode = ?_RC_ROLE_SET_000
			end,
			do_role_set_error(Module,Method,DataRecord,RoleId,PId,OpCode)
	end.
do_role_set_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
	SendSelf = #m_role_set_toc{op_type=DataRecord#m_role_set_tos.op_type,
							   attr_list=DataRecord#m_role_set_tos.attr_list,
							   op_code=OpCode},
	?DEBUG("set role info fail,SendSelf=~w",[SendSelf]),
	common_misc:unicast(PId,Module,Method,SendSelf),
	ok.
%% 玩家治疗函数
do_role_cure(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_role_cure2(DataRecord,RoleId) of
        {error,OpCode} ->
            SendSelf = #m_role_cure_toc{op_code=OpCode},
            common_misc:unicast(PId, Module, Method, SendSelf);
        {ok,RoleHp,RoleMp,RoleAnger,PetId,PetHp,PetMp,PetAnger} ->
            %% 通知地图进程玩家和宠物的血量、魔法变化
            case PetHp == 0 of
                true -> ToMapInfo = {sync_hp_mp,RoleId,RoleHp,RoleMp,RoleAnger};
                _ -> ToMapInfo = {sync_hp_mp,RoleId,RoleHp,RoleMp,RoleAnger,PetId,PetHp,PetMp,PetAnger}
            end,
            common_misc:send_to_role_map(RoleId, {mod,mod_map_role,{update_fight_attr,ToMapInfo}})
    end.
do_role_cure2(_DataRecord,RoleId) ->
    case mod_role:get_role_pos(RoleId) of
        {ok,RolePos} ->
            next;
        _ ->
            RolePos = undefined,
            erlang:throw({error,?_RC_ROLE_CURE_000})
    end,
    #r_role_pos{map_id=MapId} = RolePos,
    [#r_map_info{map_type=MapType}] = cfg_map:get_map_info(MapId),
    case MapType of
        ?MAP_TYPE_NORMAL ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_CURE_002})
    end,
    case mod_role:get_role_attr(RoleId) of
        {ok,RoleAttr} ->
            next;
        _ ->
            RoleAttr = undefined,
            erlang:throw({error,?_RC_ROLE_CURE_000})
    end,
    #p_role_attr{attr=Attr} = RoleAttr,
    #p_fight_attr{max_hp=MaxHp,hp = Hp,max_mp=MaxMp,max_anger=MaxAnger} = Attr,
    case Hp > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_CURE_001})
    end,
    NewAttr = Attr#p_fight_attr{hp=MaxHp,mp=MaxMp,anger=MaxAnger},
    NewRoleAttr = RoleAttr#p_role_attr{attr=NewAttr},
    mod_role:set_role_attr(RoleId, NewRoleAttr),
    
    case mod_pet_data:get_role_pet(RoleId) of
        {ok,#r_role_pet{battle_id=PetId}} ->
            next;
        _ ->
            PetId = 0
    end,
    case mod_pet_data:get_pet(PetId) of
        {ok,Pet} ->
            next;
        _ ->
            Pet = undefined
    end,
    case Pet =/= undefined andalso Pet#r_pet.role_id == RoleId of
        true ->
            #r_pet{attr=#p_fight_attr{max_hp=PetMaxHp,max_mp=PetMaxMp,max_anger=PetMaxAnger}=PetAttr} = Pet,
            NewPetAttr = PetAttr#p_fight_attr{hp=PetMaxHp,mp=PetMaxMp,anger=PetMaxAnger},
            NewPet = Pet#r_pet{attr=NewPetAttr},
            mod_pet_data:set_pet(PetId, NewPet);
        _ ->
            PetMaxHp = 0,PetMaxMp = 0, PetMaxAnger=0
    end,
    {ok,MaxHp,MaxMp,MaxAnger,PetId,PetMaxHp,PetMaxMp,PetMaxAnger}.
    

do_sync_map_actor({role_relive,ActorId, ?ACTOR_TYPE_ROLE, Hp, Mp, Anger}) ->
    {ok, RoleAttr = #p_role_attr{attr = Attr}} = mod_role:get_role_attr(ActorId),
    NewAttr = Attr#p_fight_attr{hp = Hp, mp = Mp, anger = Anger},
    NewRoleAttr = RoleAttr#p_role_attr{attr = NewAttr},
    mod_role:set_role_attr(ActorId, NewRoleAttr),
    hook_role:hook_role_relive(ActorId),
    ok;
do_sync_map_actor({ActorId, ?ACTOR_TYPE_ROLE, Hp, Mp, Anger}) ->
    {ok, RoleAttr = #p_role_attr{attr = Attr}} = mod_role:get_role_attr(ActorId),
    NewAttr = Attr#p_fight_attr{hp = Hp, mp = Mp, anger = Anger},
    NewRoleAttr = RoleAttr#p_role_attr{attr = NewAttr},
    mod_role:set_role_attr(ActorId, NewRoleAttr),
    case Hp > 0 of
        true ->
            ignore;
        _ ->
            hook_role:hook_role_dead(ActorId)
    end;
do_sync_map_actor({PetId, ?ACTOR_TYPE_PET, Hp, Mp, Anger}) ->
    {ok, #r_pet{attr=Attr}=Pet} = mod_pet_data:get_pet(PetId),
    NewAttr = Attr#p_fight_attr{hp = Hp, mp = Mp, anger = Anger},
    NewPet = Pet#r_pet{attr = NewAttr},
    mod_pet_data:set_pet(PetId, NewPet),
    case Hp > 0 of
        true ->
            ignore;
        _ ->
            hook_pet:hook_pet_dead(PetId)
    end;
do_sync_map_actor(_Info) ->
    %% TODO 宠物的血量同步
    ok.
