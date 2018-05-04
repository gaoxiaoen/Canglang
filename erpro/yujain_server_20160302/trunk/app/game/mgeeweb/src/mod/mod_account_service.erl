%%%-------------------------------------------------------------------
%%%
%%%
%%% @doc
%%%
%%% @end
%%%
%%%-------------------------------------------------------------------
-module(mod_account_service).

%% API
-export([
         get/3
        ]).

-include("mgeeweb.hrl").

get("/is_role" ++ _, Req, _) ->
    do_is_role(Req);

get("/get_login_info" ++ _, Req, _) ->
    get_login_info(Req);

get("/create_role" ++ _, Req, _) ->
    do_create_role(Req);

get("/get_random_role_name" ++ _, Req, _) ->
    get_random_role_name(Req);

get("/get_client_version" ++ _, Req, _) ->
	get_client_version(Req);

get(Path, Req, _) ->
    ?ERROR_MSG("~ts,Path=~w,Req=~w",["receive unknown message",Path,Req]),
    Req:not_found().

%% 检查是否有角色
do_is_role(Req) ->
    case catch do_is_role2(Req) of
        {error,OpCode,OpReason} ->
            case OpCode of
                ?_RC_ADMIN_API_012 ->%% TODO 没有判断是否已经存在此角色名称
                    MaleName = cfg_random_role_name:get_male_role_name(),
                    FemaleName = cfg_random_role_name:get_female_role_name(),
                    Rtn = [{op_code,OpCode},{op_reason,OpReason},
						   {client_version,common_misc:get_client_version()},
						   {male_name,MaleName},{female_name,FemaleName}];
                _ ->
                    Rtn = [{op_code,OpCode},{op_reason,OpReason},
						   {client_version,common_misc:get_client_version()}]
            end;
        {ok,Rtn} ->
            next
    end,
    ?DEBUG("check has role,Rtn=~w",[Rtn]),
    mgeeweb_tool:return_json(Rtn, Req).
do_is_role2(Req) ->
    ok = mgeeweb_tool:check_client_api_request(Req),
	ok = mgeeweb_tool:check_client_login_session(Req,is_role),
    Get = Req:parse_qs(),
    AccountName = common_tool:to_binary(proplists:get_value("account_name", Get)),
    AccountVia = proplists:get_value("account_via", Get,"0"),
    ServerId = common_tool:to_integer(proplists:get_value("server_id", Get)),
    FCM = common_tool:to_integer(proplists:get_value("fcm", Get, 0)),
    PRoleId = common_tool:to_integer(proplists:get_value("role_id", Get,0)),
    case common_config_dyn:find_common({can_login_id,ServerId}) of
        [true] ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_018,""})
    end,
    ok = check_games_portal_state(AccountVia),
    case PRoleId of
        0 ->
            case db_api:dirty_read(?DB_ACCOUNT, AccountName) of
                [Account] ->
                    case lists:keyfind(ServerId, #r_account_sub.server_id, Account#r_account.role_list) of
                        false ->
                            RoleId = 0;
                        #r_account_sub{role_id = RoleId} ->
                            next
                    end;
                _ ->
                    RoleId = 0
            end;
        _ ->
            RoleId = PRoleId
    end,
    %% 活跃数据中查询
    case db_active_api:dirty_read(?DB_ROLE_BASE,RoleId) of 
        [#p_role_base{level = RoleLevel}] ->
            next;
        _ ->
            %% 不活跃数据中查询
            case cfg_mnesia:is_inactive_storage() of
                true ->
                    case db_inactive_api:dirty_read(?DB_ROLE_BASE,RoleId) of 
                        [#p_role_base{level = RoleLevel}] -> 
                            db_migration:to_active(RoleId);
                        _ ->
                            RoleLevel = 0
                    end;
                _ ->
                    RoleLevel = 0
            end
    end,
    %% 角色已经存在
    case RoleLevel > 0 of
        true ->
            case mgeew_line_server:get_line() of
                undefined ->
                    Rtn = [],
                    erlang:throw({error,?_RC_ADMIN_API_011,""});
                {Host,Port} ->
                    [#r_role_pos{map_id=MapId, pos=#p_pos{x=X, y=Y}}] = db_api:dirty_read(?DB_ROLE_POS, RoleId),
                    GatewayTime = common_tool:now(),
                    GatewayKey = common_misc:get_gateway_key({AccountName, GatewayTime, FCM}),
                    Rtn = [{op_code,0},
                           {op_reason,""},
                           {role_id,RoleId},
                           {level, RoleLevel}, 
                           {map_id, MapId}, {tx, X}, {ty, Y},  
                           {gateway_host, Host}, 
                           {gateway_port, Port},
                           {gateway_key, GatewayKey},
                           {gateway_time,GatewayTime}]
            end;
        _ ->
            Rtn = [],
			%% 判断当前服务器是人数控制
			TotalOnlineNumber =db_api:table_info(?DB_ROLE_ONLINE,size),
			{ok,#r_system_config{value=MaxOnlineNumberStr}} = common_misc:get_system_config(max_online_number),
			MaxOnlineNumber = common_tool:to_integer(MaxOnlineNumberStr),
			case TotalOnlineNumber > MaxOnlineNumber of
				true -> %% 不可以在创建角色
					erlang:throw({error,?_RC_ADMIN_API_025,""});
				_ ->
					next
			end,
			{ok,#r_system_config{value=WaitOnlineNumberStr}} = common_misc:get_system_config(wait_online_number),
			WaitOnlineNumber = common_tool:to_integer(WaitOnlineNumberStr),
			case TotalOnlineNumber > WaitOnlineNumber of
				true -> %% 提示玩家排队
					case common_tool:random(1, 10000) > 5000 of
						true ->
							erlang:throw({error,?_RC_ADMIN_API_026,""});
						_ ->
							next
					end;
				_ ->
					next
			end,
            %% 记录日志
            LogRoleFollow = #r_log_role_follow{account_name = AccountName,account_via = AccountVia,
                                               role_id = 0,role_name = "",
                                               mtime = common_tool:now(),step = ?ROLE_FOLLOW_STEP_2,
                                               ip = ""},
            common_log:insert_log(role_follow,LogRoleFollow),
            erlang:throw({error,?_RC_ADMIN_API_012,""})
    end,
    {ok,Rtn}.

%% 获取帐号登录信息
get_login_info(Req) ->
    case catch get_login_info2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason},
				   {client_version,common_misc:get_client_version()}],
            ?DEBUG("get login info fail,Rtn=~w",[Rtn]),
            mgeeweb_tool:return_json(Rtn, Req);
        {ok,AccountName,RoleId,FCM} ->
            get_login_info3(Req,AccountName,RoleId,FCM)
    end.
get_login_info2(Req) ->
    ok = mgeeweb_tool:check_client_api_request(Req),
	ok = mgeeweb_tool:check_client_login_session(Req,login_info),
    Get = Req:parse_qs(),
    AccountName = common_tool:to_binary(proplists:get_value("account_name", Get)),
    AccountVia = proplists:get_value("account_via", Get,"0"),
    RoleId = common_tool:to_integer(proplists:get_value("role_id", Get,0)),
    FCM = common_tool:to_integer(proplists:get_value("fcm", Get)),
    ok = check_games_portal_state(AccountVia),
    {ok,AccountName,RoleId,FCM}.
get_login_info3(Req,AccountName,RoleId,FCM) ->
     case mgeew_line_server:get_line() of
        undefined ->
            Rtn = [{op_code,?_RC_ADMIN_API_011},{op_reason,""}];
         {Host,Port} ->
             case db_api:dirty_read(?DB_ROLE_BASE, RoleId) of
                 [#p_role_base{level = RoleLevel}] ->
                     [#r_role_pos{map_id=MapId, pos=#p_pos{x=X, y=Y}}] = db_api:dirty_read(?DB_ROLE_POS, RoleId),
                     GatewayTime = common_tool:now(),
                     GatewayKey = common_misc:get_gateway_key({AccountName, GatewayTime, FCM}),
                     Rtn = [{op_code,0},
                            {op_reason,""},
                            {role_id,RoleId},
                            {level, RoleLevel}, 
                            {map_id, MapId}, {tx, X}, {ty, Y},  
                            {gateway_host, Host}, 
                            {gateway_port, Port},
                            {gateway_key, GatewayKey},
                            {gateway_time,GatewayTime}];
                 _ ->
                     MaleName = cfg_random_role_name:get_male_role_name(),
                     FemaleName = cfg_random_role_name:get_female_role_name(),
                     Rtn = [{op_code,?_RC_ADMIN_API_012},{op_reason,""},
							{client_version,common_misc:get_client_version()},
							{male_name,MaleName},{female_name,FemaleName}]
             end
     end,
     ?DEBUG("get login info succ,Rtn=~w",[Rtn]),
     mgeeweb_tool:return_json(Rtn, Req).

%% 创建角色
do_create_role(Req) ->
    case catch do_create_role2(Req) of
        {error, OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}],
            ?DEBUG("create role fail,Rtn=~w",[Rtn]),
            mgeeweb_tool:return_json(Rtn, Req);
        {ok,Param} ->
            do_create_role3(Req,Param)
    end.
do_create_role2(Req) ->
    ok = mgeeweb_tool:check_client_api_request(Req),
	ok = mgeeweb_tool:check_client_login_session(Req,create_role),
    case common_misc:get_system_config(is_create_role) of
        {ok,#r_system_config{key = is_create_role,value = "true"}} ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_017,""})
    end,
    Get = Req:parse_qs(),
    AccountName = common_tool:to_binary(proplists:get_value("account_name", Get)),
    AccountVia = proplists:get_value("account_via", Get),
    AccountType = common_tool:to_integer(proplists:get_value("account_type", Get,?ACCOUNT_TYPE_NORMAL)),
    ServerId = common_tool:to_integer(proplists:get_value("server_id", Get)),
    RoleName = common_tool:to_binary(proplists:get_value("role_name", Get)),
    RoleSex = common_tool:to_integer(proplists:get_value("role_sex", Get)),
    _FactionId = common_tool:to_integer(proplists:get_value("faction_id", Get)),
    FashionId = common_tool:to_integer(proplists:get_value("fashion_id", Get)),
    Category = common_tool:to_integer(proplists:get_value("category", Get)),
    FCM = common_tool:to_integer(proplists:get_value("fcm", Get, 0)),
%%     IP = common_tool:ip_to_str(proplists:get_value("ip", Get,"")),
    IP = common_tool:ip_to_str(Req:get(peer)),
	DeviceId = proplists:get_value("device_id", Get,""),
    ok = check_games_portal_state(AccountVia),
    case common_config_dyn:find_common({can_login_id,ServerId}) of
        [true] ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_CREATE_009,""})
    end,
    Param = {AccountName,AccountVia,AccountType,
             ServerId,
             RoleName,RoleSex,?FACTION_ID_0,FashionId,Category,
             FCM,IP,DeviceId},
    {ok,Param}.
do_create_role3(Req,Param) ->
    {AccountName,AccountVia,_AccountType,
             _ServerId,
             _RoleName,_RoleSex,_FactionId,_FashionId,_Category,
             _FCM,IP,_DeviceId} = Param,
    case catch gen_server:call(mgeew_account_server, {add_role, Param}) of
        {ok, RoleId,NewRoleName} ->
            %% 记录日志
            LogRoleFollow = #r_log_role_follow{account_name = AccountName,account_via = AccountVia,
                                               role_id = RoleId,role_name = NewRoleName,
                                               mtime = common_tool:now(),step = ?ROLE_FOLLOW_STEP_3,
                                               ip = IP},
            common_log:insert_log(role_follow,LogRoleFollow),
            Rtn = [{op_code,0},{op_reason,""},{role_id, RoleId}],
            ?DEBUG("create role succ,Rtn=~w",[Rtn]),
            mgeeweb_tool:return_json(Rtn, Req);
        {error, OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}],
            ?DEBUG("create role fail,Rtn=~w",[Rtn]),
            mgeeweb_tool:return_json(Rtn, Req);
        Error ->
            ?ERROR_MSG("create role fail,Error=~w", [Error]),
            Rtn = [{op_code,?_RC_ROLE_CREATE_000},{op_reason,""}],
            mgeeweb_tool:return_json(Rtn, Req)
    end.

%% 检查游戏入口
check_games_portal_state(AccountVia) ->
    case common_config:is_debug() of
        true ->
            %% debug模式下不验证key，直接通过登录
            next;
        false ->
            %% 验证游戏入口状态
            case common_misc:is_platform_state() =:= true andalso AccountVia =/= ?ACCOUNT_VIA_ADMIN of
                true ->
                    erlang:throw({error,?_RC_ADMIN_API_014,""});
                _ ->
                    next
            end,
            %% 验证管理平台游戏入口状态
            case common_misc:is_platform_admin_state() of
                true ->
                    erlang:throw({error,?_RC_ADMIN_API_015,""});
                _ ->
                    next
            end
    end,
    ok.


%% 根据参数获取随机角色名称
get_random_role_name(Req) ->
    case catch get_random_role_name2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code, OpCode},{op_reason,OpReason}],
            mgeeweb_tool:return_json(Rtn, Req);
        {ok,RoleSex,ServerId} ->
            get_random_role_name3(Req,RoleSex,ServerId)
    end.
get_random_role_name2(Req) ->
    ok = mgeeweb_tool:check_client_api_request(Req),
    Get = Req:parse_qs(),
    RoleSex = common_tool:to_integer(proplists:get_value("role_sex", Get,0)),
    ServerId = common_tool:to_integer(proplists:get_value("server_id", Get)),
    case common_config_dyn:find_common({can_login_id,ServerId}) of
        [true] ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_018,""})
    end,
    {ok,RoleSex,ServerId}.

get_random_role_name3(Req,RoleSex,ServerId) ->
    RoleName = get_random_role_name4(10,RoleSex,ServerId,""),
    case RoleSex of
        1 ->
            Rtn = [{op_code, 0},{op_reason,""}, {male_name, RoleName},{female_name,""}];
        _ ->
            Rtn = [{op_code, 0},{op_reason,""}, {male_name,""},{female_name,RoleName}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).

get_random_role_name4(0,RoleSex,_ServerId,PRoleName) ->
    case PRoleName of
        "" ->
            case RoleSex of
                1 ->
                    cfg_random_role_name:get_male_role_name();
                _ ->
                    cfg_random_role_name:get_female_role_name()
            end;
        _ ->
            PRoleName
    end;
get_random_role_name4(Index,RoleSex,ServerId,PRoleName) ->
    case RoleSex of
        1 ->
            PName = cfg_random_role_name:get_male_role_name(),
			RoleName = common_misc:get_real_name(PName, ServerId),
            case db_api:dirty_read(?DB_ROLE_NAME,RoleName) of
                [] ->
                    get_random_role_name4(0,RoleSex,ServerId,PName);
                _ ->
                    get_random_role_name4(Index - 1,RoleSex,ServerId,PRoleName)
            end;
        _ ->
            PName = cfg_random_role_name:get_female_role_name(),
			RoleName = common_misc:get_real_name(PName, ServerId),
            case db_api:dirty_read(?DB_ROLE_NAME,RoleName) of
                [] ->
                    get_random_role_name4(0,RoleSex,ServerId,PName);
                _ ->
                    get_random_role_name4(Index - 1,RoleSex,ServerId,PRoleName)
            end
    end.
%% 获取当前端版本号
get_client_version(Req) ->
	case catch get_client_version2(Req) of
		{error,OpCode,OpReason} ->
			Rtn = [{op_code, OpCode},{op_reason,OpReason}];
		{ok,ClientVersion} ->
			Rtn = [{op_code, 0},{op_reason,""},
				   {client_version,ClientVersion}]
	end,
	mgeeweb_tool:return_json(Rtn, Req).
get_client_version2(Req) ->
	ok = mgeeweb_tool:check_client_api_request(Req),
	{ok,common_misc:get_client_version()}.
    