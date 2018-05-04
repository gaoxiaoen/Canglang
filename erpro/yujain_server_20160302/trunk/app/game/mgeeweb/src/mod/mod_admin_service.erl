%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-20
%% Description: 管理平台接口
-module(mod_admin_service).

%%
%% Include files
%%
-include("mgeeweb.hrl").
%%
%% Exported Functions
%%
-export([
         handle/3
         ]).

%%
%% API Functions
%%

handle("/get_online_role_count" ++ _, Req, _) ->
    get_online_role_count(Req);

handle("/get_all_online_role_info" ++ _, Req, _) ->
    get_all_online_role_info(Req);

handle("/gen_role_snapshot" ++ _, Req, _) ->
    gen_role_snapshot(Req);

handle("/get_role_id" ++ _, Req, _) ->
    get_role_id(Req);

handle("/gm_cmd" ++ _, Req, _) ->
    do_gm_cmd(Req);

handle("/dict" ++ _, Req, _) ->
    mod_dict_service:do(Req);

handle("/system" ++ Path, Req, _) ->
    mod_system_service:do(Path,Req);

handle(Path, Req, _) ->
    ?ERROR_MSG("~ts,Path=~w,Req=~w",["receive unknown message",Path,Req]),
    mgeeweb_tool:return_json_error(Req).

%% 在线玩家数
get_online_role_count(Req) ->
    case catch get_online_role_count2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason},{online,0},{time,common_tool:now()}];
        {ok,TotalOnlineNumber,NowSeconds} ->
            Rtn = [{op_code,0},{op_reason,""},{online,TotalOnlineNumber},{time,NowSeconds}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
get_online_role_count2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    TotalOnlineNumber =db_api:table_info(?DB_ROLE_ONLINE,size), 
    NowSeconds = common_tool:now(),
    {ok,TotalOnlineNumber,NowSeconds}.
%% 在线玩家信息列表
get_all_online_role_info(Req) ->
    case catch get_all_online_role_info2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason},{"data",[]}];
        {ok,RoleIdList} ->
            NowSeconds = common_tool:now(),
            InfoStr = get_all_online_role_info3(RoleIdList,NowSeconds,[]),
            Rtn = [{op_code,0},{op_reason,""},{"data",InfoStr}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
get_all_online_role_info2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    RoleIdList = db_api:dirty_all_keys(?DB_ROLE_ONLINE),
    {ok,RoleIdList}.

get_all_online_role_info3([],_NowSeconds,InfoStrList) ->
    "[" ++ string:join(InfoStrList, ",") ++ "]";
get_all_online_role_info3([RoleId|RoleIdList],NowSeconds,InfoStrList) ->
    case mod_role:get_role_base(RoleId) of
        {ok,#p_role_base{role_name = RoleName,
                         account_name = AccountName,
                         account_via = AccountVia,
                         account_type = AccountType,
                         faction_id = FactionId,
                         category = Category,
                         level = RoleLevel,
                         sex = RoleSex,
                         last_login_time = LastLoginTime,
                         last_login_ip = LastLoginIp
                         }} ->
            next;
        _ ->
            RoleName = "",
            AccountName = "",AccountVia ="",AccountType = 0,
            FactionId = 0,Category = 0,RoleLevel = 0,RoleSex = 0,
            LastLoginTime = 0,LastLoginIp = ""
    end,
    case mod_role:get_role_pos(RoleId) of
        {ok,#r_role_pos{map_id = MapId}} ->
            next;
        _ ->
            MapId = 0
    end,
    case NowSeconds - LastLoginTime > 0 of
        true ->
            TotalOnlineTime = NowSeconds - LastLoginTime;
        _ ->
            TotalOnlineTime = 0
    end,
    StringList = ["{" ++ lists:concat(["\"roleId\":",RoleId]),
                  lists:concat(["\"roleName\":",common_tool:get_format_json_value(string,RoleName)]),
                  lists:concat(["\"accountName\":",common_tool:get_format_json_value(string,AccountName)]),
                  lists:concat(["\"accountVia\":",common_tool:get_format_json_value(string,AccountVia)]),
                  lists:concat(["\"accountType\":",AccountType]),
                  lists:concat(["\"mapId\":",MapId]),
                  lists:concat(["\"factionId\":",FactionId]),
                  lists:concat(["\"category\":",Category]),
                  lists:concat(["\"level\":",RoleLevel]),
                  lists:concat(["\"sex\":",RoleSex]),
                  lists:concat(["\"ip\":",common_tool:get_format_json_value(string, LastLoginIp)]),
                  lists:concat(["\"totalOnlineTime\":",TotalOnlineTime]) ++ "}"],
    InfoStr = string:join(StringList, ","),
    get_all_online_role_info3(RoleIdList,NowSeconds,[InfoStr|InfoStrList]).

%% 生成全量玩家信息快照日志
gen_role_snapshot(Req) ->
    case catch gen_role_snapshot2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok,RoleIdList} ->
            gen_role_snapshot3(RoleIdList,0,[]),
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
gen_role_snapshot2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    LastLoginTime =  common_tool:to_integer(proplists:get_value("last_login_time",QueryString,"0")),
    case LastLoginTime of
        0 ->
            RoleIdList = db_api:dirty_all_keys(?DB_ROLE_BASE);
        _ ->
            MatchHead = #p_role_base{role_id='$1',_='_',last_login_time='$2'},
            Guard = [{'>=','$2',LastLoginTime}],
            RoleIdList = db_api:dirty_select(?DB_ROLE_BASE, [{MatchHead, Guard, ['$1']}])
    end,
    {ok,RoleIdList}.

gen_role_snapshot3([],_Index,LogRoleSnapShotList) ->
    case LogRoleSnapShotList =/= [] of
        true ->
            common_log:insert_log(role_snapshot, LogRoleSnapShotList);
        _ ->
            ignore
    end;
gen_role_snapshot3(RoleIdList,Index,LogRoleSnapShotList) when Index > 50 ->
    common_log:insert_log(role_snapshot, LogRoleSnapShotList),
    gen_role_snapshot3(RoleIdList,0,[]);
gen_role_snapshot3([RoleId|RoleIdList],Index,LogRoleSnapShotList) ->
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            [RoleBase] = db_api:dirty_all_read(?DB_ROLE_BASE, RoleId)
    end,
    case mod_role:get_role_pos(RoleId) of
        {ok,RolePos} ->
            next;
        _ ->
            [RolePos] = db_api:dirty_all_read(?DB_ROLE_POS, RoleId)
    end,
    LogRoleSnapshot = common_log:get_log_role_snapshot(RoleBase,RolePos),
    gen_role_snapshot3(RoleIdList,Index + 1,[LogRoleSnapshot|LogRoleSnapShotList]).

%% 根据玩家帐号，角色名称查询玩家Id
get_role_id(Req) ->
	case catch get_role_id2(Req) of
		{error,OpCode,OpReason} ->
			Rtn = [{op_code,OpCode},{op_reason,OpReason}];
		{ok,Data} ->
			Rtn = [{op_code,0},{op_reason,""},{data,Data}]
	end,
	mgeeweb_tool:return_json(Rtn, Req).
get_role_id2(Req) ->
	ok = mgeeweb_tool:check_admin_api_request(Req),
	QueryString = Req:parse_post(),
	AccountName = common_tool:to_binary(proplists:get_value("account_name",QueryString,"")),
	RoleName = common_tool:to_binary(base64:decode_to_string(base64:decode_to_string(proplists:get_value("role_name",QueryString,"")))),
	case db_api:dirty_read(?DB_ACCOUNT,AccountName) of
		[#r_account{role_list=RoleList}] ->
			RoleInfoList = [ begin
								 case db_api:dirty_read(?DB_ROLE_BASE,PRoleId) of
									 [#p_role_base{role_name=PRoleName}] ->
										 next;
									 _ ->
										 PRoleName = ""
								 end,
								 #r_role_name{role_id=PRoleId,role_name=PRoleName}
							 end || #r_account_sub{role_id=PRoleId} <- RoleList];
		_ ->
			case db_api:dirty_read(?DB_ROLE_NAME,RoleName) of
				[RoleInfo] ->
					RoleInfoList = [RoleInfo];
				_ ->
					RoleInfoList = [],
					erlang:throw({error,?_RC_ADMIN_API_016,""})
			end
	end,
	NewList = [ common_misc:record_to_json(Rec) ||Rec<-RoleInfoList ],
	Data = lists:concat(["[",string:join(NewList, ","),"]"]),
	{ok,Data}.

do_gm_cmd(Req) ->
	case catch do_gm_cmd2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason},{cmd_desc,""}];
		{ok,CmdDesc} ->
            Rtn = [{op_code,0},{op_reason,""},{cmd_desc,CmdDesc}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_gm_cmd2(Req) ->
	case common_config:is_debug() of
		true ->
			next;
		_ ->
			erlang:throw({error,?_RC_ADMIN_API_021,""})
	end,
	ok = mgeeweb_tool:check_admin_api_request(Req),
	QueryString = Req:parse_post(),
    OpType =  common_tool:to_integer(proplists:get_value("op_type",QueryString,0)),
	RoleId =  common_tool:to_integer(proplists:get_value("role_id",QueryString,0)),
	Cmd = base64:decode_to_string(base64:decode_to_string(proplists:get_value("cmd",QueryString,""))),
    case OpType of
        1 ->
			CmdDesc = mod_gm:do_cmd(RoleId, "help"),
			erlang:throw({ok,CmdDesc});
		2 ->
			case Cmd =/= [] andalso Cmd =/= "" of
				true ->
					next;
				_ ->
					erlang:throw({error,?_RC_ADMIN_API_005,""})
			end,
			case common_misc:get_role_base(RoleId) of
				{ok,_} ->
					next;
				_ ->
					erlang:throw({error,?_RC_ADMIN_API_022,""})
			end,
			next;
		_ ->
			erlang:throw({error,?_RC_ADMIN_API_023,""})
	end,
	{ok,mod_gm:do_cmd(RoleId, Cmd)}.


