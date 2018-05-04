%%% -------------------------------------------------------------------
%%% Author  : caochuncheng2002@gmail.com
%%% Description :
%%% 创建角色进程
%%% Created : 2013-10-26
%%% -------------------------------------------------------------------

-module(mgeew_account_server).

-behaviour(gen_server).

-include("mgeew.hrl").


-export([start/0, start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record( state, {} ).

%% ====================================================================

start() ->
    {ok, _} = supervisor:start_child(
                mgeew_sup, 
                {mgeew_account_server,
                 {mgeew_account_server, start_link, []},
                 transient, brutal_kill, worker, [mgeew_account_server]}),
    ok.


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% --------------------------------------------------------------------

init([]) ->
    case db_api:transaction( 
           fun() -> 
				   case common_config_dyn:find_common(is_merged) of
					   [false] ->
						   [ServerId] = common_config_dyn:find_common(server_id),
						   case db_api:read(?DB_ROLE_ID, ServerId, write) of
							   [] ->
								   InitKeyId = common_misc:get_init_key_id(),
								   db_api:write(?DB_ROLE_ID, #r_counter{key=ServerId, last_id=InitKeyId}, write);
							   [_] ->
								   ignore
						   end;
					   _ ->
						   ignroe
				   end
           end) of
        {'EXIT', _} ->
            {stop, read_mnesia_record_error};
        {atomic, _} ->
            {ok, #state{}}
    end.

%% --------------------------------------------------------------------

%% @doc 创建角色
handle_call({add_role, Info}, _From, State) ->
    Reply = do_add_role(Info),
    {reply, Reply, State};

handle_call(Request, From, State) ->
    ?DEBUG("~w handle_cal from ~w : ~w", [?MODULE, From, Request]),
    Reply = ok,
    {reply, Reply, State}.

%% --------------------------------------------------------------------

handle_cast(_Msg, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State),
    {noreply, State}.

%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------

do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;

do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message.Info=~w", [Info]).

%%获取出生点信息
get_born_info(FactionId,_Category,_Sex) ->
    case cfg_common:find({newer_born_map_id,FactionId}) of
        undefined ->
            error;
        MapId ->
            case cfg_common:find({newer_born_point,FactionId}) of
                {Tx,Ty} ->
                    {MapId,Tx,Ty};
                _ ->
                    error
            end
    end.

%% 创建角色
do_add_role({AccountName,AccountVia,AccountType,ServerId,
             RoleName,RoleSex,FactionId,FashionId,Category,FCM,IP,DeviceId}) ->
    case catch do_add_role2(AccountName,AccountVia,AccountType,ServerId,
                            RoleName,RoleSex,FactionId,FashionId,Category,FCM) of
        {error,OpCode,Reason} ->
            {error,OpCode,Reason};
        {ok} ->
            case db_api:transaction(
                   fun() -> 
                           t_add_role(AccountName,AccountVia,AccountType,ServerId,
                                      RoleName,RoleSex,FactionId,FashionId,Category,FCM,IP,DeviceId) 
                   end) 
                of
                {aborted, Error} ->                     
                    case Error of
                        {error,OpCode,Reason} ->
                            next;
                        _ ->
                            ?ERROR_MSG("~ts,Error=~w", [?_LANG_ROLE_003, Error]),
                            OpCode = ?_RC_ROLE_CREATE_000,
                            Reason = ""
                    end,
                    {error,OpCode,Reason};
                {atomic, {ok,PRoleInfo}} ->
                    hook_role:hook_role_create((PRoleInfo#p_role.base)#p_role_base.role_id),
					%% 向web节点发送阵营人数
					case FactionId > 0 of
						true ->
							catch erlang:send(mgeew_memory_server, {add_faction_role_number,{FactionId,1}});
						_ ->
							next
					end,
                    %% 向管理平台返回数据
                    [AgentId] = common_config_dyn:find_common(agent_id),
                    #p_role{base = RoleBase} = PRoleInfo,
                    ParamList = [{"module","player"},{"action","create"},
                                 {"via","server"},
                                 {"account_name",common_tool:to_list(AccountName)},
                                 {"account_via",RoleBase#p_role_base.account_via},
                                 {"agent_id",AgentId},
                                 {"server_id",ServerId},
                                 {"create_time",RoleBase#p_role_base.create_time},
                                 {"timestamp",common_tool:now()},
								 {"device_id",DeviceId}],
                    common_misc:do_portal_run_api(get, "", ParamList, undefined),
					{ok, (PRoleInfo#p_role.base)#p_role_base.role_id,
					 (PRoleInfo#p_role.base)#p_role_base.role_name}         
            end
    end.
%% 检查创建 角色是否正常
do_add_role2(_AccountName,AccountVia,AccountType,ServerId,
             RoleName,RoleSex,FactionId,_FashionId,Category,_FCM) ->
    %% 检查角色名称
    case common_validation:valid_username(RoleName) of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_CREATE_004,""})
    end,
    %% 检查性别
    case RoleSex =:= 1 orelse  RoleSex =:= 2 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_CREATE_005,""})
    end,
    %% 检查国家
    case FactionId =:= ?FACTION_ID_0 orelse FactionId =:= ?FACTION_ID_1 
		 orelse FactionId =:= ?FACTION_ID_2 orelse FactionId =:= ?FACTION_ID_3 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_CREATE_006,""})
    end, 
    %% 检查职业
    case Category =:= ?CATEGORY_0
        orelse Category =:= ?CATEGORY_1 
        orelse Category =:= ?CATEGORY_2 
        orelse Category =:= ?CATEGORY_3 
        orelse Category =:= ?CATEGORY_4
        orelse Category =:= ?CATEGORY_5
        orelse Category =:= ?CATEGORY_6 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_CREATE_007,""})
    end,
    %% 检查服务器id
    case common_config_dyn:find_common({can_login_id,ServerId}) of
        [true] ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_CREATE_009,""})
    end,
    %% 后台管理帐号创建测试
    case AccountVia of
        ?ACCOUNT_VIA_ADMIN ->
            case AccountType =:= ?ACCOUNT_TYPE_GM 
                 orelse AccountType =:= ?ACCOUNT_TYPE_ADMIN
                 orelse AccountType =:= ?ACCOUNT_TYPE_INTERNAL of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_ROLE_CREATE_010,""})
            end;
        _ ->
            next
    end,
    {ok}.
%%事务添加角色处理过程
t_add_role(AccountName,AccountVia,AccountType,ServerId,RoleName,RoleSex,FactionId,FashionId,Category,
		   FCM,IP,DeviceId) ->
    [IsOpenGuestAccount] = common_config_dyn:find(etc, is_open_guest_account),
    case AccountType =:= ?ACCOUNT_TYPE_GUEST of
        true ->
            case IsOpenGuestAccount of
                true ->
                    next;
                _ ->
                    db_api:abort({error,?_RC_ROLE_CREATE_011,""})
            end;
        _ ->
            ignore
    end,
	%%角色ID
	case db_api:read(?DB_ROLE_ID, ServerId, write) of
		[#r_counter{last_id=LastId}] ->
				next;
		_ ->
			LastId = 0,
			db_api:abort({error,?_RC_ROLE_CREATE_014,""})
	end,
    NewRoleId = LastId + 1,
    case db_api:read(?DB_ROLE_BASE, NewRoleId, write) of
        [] ->
			NewRoleName = common_misc:get_real_name(RoleName, ServerId),
            case db_api:read(?DB_ROLE_NAME, NewRoleName,write) of
                [] ->
                    case get_born_info(FactionId,Category,RoleSex) of
                        error ->
                            ?ERROR_MSG("~ts:~w", [?_LANG_ROLE_004, FactionId]),
                            db_api:abort({error,?_RC_ROLE_CREATE_012,""});
                        {MapId, Tx, Ty} ->
                            t_add_role2(AccountName,AccountVia,AccountType,ServerId,
                                        NewRoleName,RoleSex,FactionId,FashionId,Category,FCM,IP,DeviceId,
                                        NewRoleId,MapId,Tx,Ty)
                    end;
                [_] ->
                    db_api:abort({error,?_RC_ROLE_CREATE_013,""})
            end;
        _ ->
            db_api:abort({error,?_RC_ROLE_CREATE_014,""})
    end.
t_add_role2(AccountName,AccountVia,AccountType,ServerId,
            RoleName,RoleSex,FactionId,FashionId,Category,FCM,IP,DeviceId,
            RoleId,MapId,Tx,Ty) ->
    NowSeconds = common_tool:now(),
    %% 帐号表数据
    case db_api:read(?DB_ACCOUNT, AccountName,write) of
        [] ->
            AccountRecord = #r_account{account_name=AccountName, 
                                       create_time=NowSeconds, 
                                       role_num = 0, 
                                       role_list = [] };
        [AccountRecord] ->
            next
    end,
    case lists:keyfind(ServerId, #r_account_sub.server_id, AccountRecord#r_account.role_list) of
        false ->
            next;
        _ ->
            db_api:abort({error,?_RC_ROLE_CREATE_015,""})
    end,
    AccountSub = #r_account_sub{role_id = RoleId,server_id = ServerId,create_time = NowSeconds},
    NewAccountRecord = AccountRecord#r_account{role_num = AccountRecord#r_account.role_num + 1,
                                               role_list = [AccountSub|AccountRecord#r_account.role_list]},
    db_api:write(?DB_ACCOUNT,NewAccountRecord,write),
    db_api:write(?DB_ROLE_NAME, #r_role_name{role_name = RoleName,role_id = RoleId},write),
    %% 防沉迷数据
    case FCM =:= 1 of
        true ->
            db_api:write(?DB_FCM_DATA, #r_fcm_data{passed=true, account=AccountName}, write);
        false ->
            db_api:write(?DB_FCM_DATA, #r_fcm_data{passed=false, account=AccountName}, write)
    end,
    %% 角色id
    NewRoleIdInfo = #r_counter{key=ServerId, last_id=RoleId},
    db_api:write(?DB_ROLE_ID, NewRoleIdInfo, write),
    %% 角色基本数据
    RoleBase = make_new_role_base(RoleId,AccountName,AccountVia,AccountType,ServerId,
                                  RoleName,RoleSex,FactionId,FashionId,Category,IP,DeviceId,NowSeconds),
    RoleAttr = make_new_role_attr(RoleId,RoleName,Category),
    RolePos = make_new_role_pos(RoleId,MapId,Tx,Ty),
    RoleSkill = make_new_role_skill(RoleId,Category),
    RoleExt = make_new_role_ext(RoleId,RoleName,RoleSex),
    RoleState = make_new_role_state(RoleId),
    db_api:write(?DB_ROLE_BASE, RoleBase, write),
    db_api:write(?DB_ROLE_ATTR, RoleAttr, write),
    db_api:write(?DB_ROLE_POS, RolePos, write),
    db_api:write(?DB_ROLE_SKILL, RoleSkill, write),
    db_api:write(?DB_ROLE_EXT, RoleExt, write),
    db_api:write(?DB_ROLE_STATE, RoleState, write),
    
    PRoleInfo = #p_role{base=RoleBase,attr=RoleAttr},
	%% 初始化玩家背包
	mod_bag:t_new_role_bag_info(RoleId),
	
    {ok,PRoleInfo}.

make_new_role_base(RoleId,AccountName,AccountVia,AccountType,ServerId,
                   RoleName,RoleSex,FactionId,FashionId,Category,IP,DeviceId,NowSeconds) ->
    #r_level_exp{exp=InitNextLevelExp} = cfg_role_level_exp:find(1),
    #p_role_base{
                 role_id=RoleId,
                 role_name=RoleName,
                 account_via=AccountVia,
                 account_name=AccountName,
                 account_type=AccountType,
                 account_status=?ACCOUNT_STATUS_NORMAL,
                 create_time=NowSeconds,
                 sex=RoleSex,
                 skin=#p_skin{fashion_id=FashionId,arms_id=0,wing_id=0},
                 faction_id=FactionId,
                 category=Category,
                 exp=0,
                 next_level_exp=InitNextLevelExp,
                 level=0,
                 family_id=0,
                 family_name="",
                 couple_id=0,
                 couple_name="",
                 team_id=0,
                 is_pay=0,
                 gold=0,
                 silver=0,
                 coin= 0,
                 activity=0,
                 gongxun=0,
                 last_login_ip=IP,
                 last_login_time=NowSeconds,
                 last_offline_time=NowSeconds - 1,
				 device_id=DeviceId,
				 last_device_id=DeviceId,
				 server_id=ServerId
                }.

make_new_role_attr(RoleId,_RoleName,Category) ->
    RoleAttr = cfg_role_attr:init_attr(Category),
    NewRoleAttr = mod_attr:full(RoleAttr),
    #p_role_attr{role_id = RoleId,attr = NewRoleAttr}.

make_new_role_pos(RoleId, MapId, X, Y) ->
    MapPName = common_map:get_common_map_name(MapId),
    #r_role_pos{
                role_id=RoleId,
                map_id=MapId,
                pos=#p_pos{x=X, y=Y},
                map_process_name=MapPName,
                last_map_id = MapId,
                last_pos = #p_pos{x=X, y=Y},
                last_map_process_name=MapPName
               }.

make_new_role_skill(RoleId,Category) ->
    InitSkills = mod_skill:init_skill(Category,1),
    #r_role_skill{role_id = RoleId, skill_list = InitSkills}.

make_new_role_ext(RoleId,RoleName,RoleSex) ->
    #p_role_ext{
                role_id=RoleId,
                real_name=RoleName,
                sex=RoleSex,
                signature="",
                birthday=0,
                constellation=0,
                country=0,
                province=0,
                city=0,
                blog="",
                qq="",
                weixin="",
                weibo=""
               }.

make_new_role_state(RoleId) ->
    #r_role_state{
                  role_id = RoleId,
                  status = ?ACTOR_STATUS_NORMAL 
                 }.
