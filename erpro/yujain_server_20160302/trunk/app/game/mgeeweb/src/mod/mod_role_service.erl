%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-14
%% Description: 角色信息接口处理模块
-module(mod_role_service).

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
handle("/get_role_info" ++ _, Req, _) ->
    get_role_info(Req);

handle("/get_role_bag" ++ _, Req, _) ->
	get_role_bag(Req);

handle("/get_role_family" ++ _, Req, _) ->
	get_role_family(Req);

handle("/update" ++ _, Req, _) ->
	update_role_info(Req);


handle(Path, Req, _) ->
    ?ERROR_MSG("~ts,Path=~w,Req=~w",["receive unknown message",Path,Req]),
    mgeeweb_tool:return_json_error(Req).

%% op_type 查询类型,1脏读玩家数据,2当前最新数据
%% op_sub_type 查询子类型
%% 1查询p_role_base
%% 2查询p_role_attr
%% 3查询r_role_pos
%% 4查询p_role_ext
%% 5查询p_role
%% 6查询p_role_state
%% 7查询玩家背包数据
%% 8查询玩家帮派信息
-define(get_role_info_op_type_dirty,1).
-define(get_role_info_op_type_cur,2).

-define(get_role_info_op_sub_type_base,1).
-define(get_role_info_op_sub_type_attr,2).
-define(get_role_info_op_sub_type_pos,3).
-define(get_role_info_op_sub_type_ext,4).
-define(get_role_info_op_sub_type_p_role,5).
-define(get_role_info_op_sub_type_state,6).

-define(set_role_info_level,1014).
-define(set_role_info_is_pay,1020).
-define(set_role_info_total_gold,1021).
get_role_info(Req) ->
    case catch mgeeweb_tool:check_admin_api_request(Req) of
        {error,OpCode,OpReason} ->
            RtnStr = lists:concat(["{\"op_code\":",OpCode,",\"op_reason\":\"",OpReason,"\"}"]),
            mgeeweb_tool:return_string(RtnStr, Req);
        _ ->
            QueryString = Req:parse_post(),
            OpType = mgeeweb_tool:get_int_param("op_type",QueryString),
            OpSubType = mgeeweb_tool:get_int_param("op_sub_type",QueryString),
            RoleId = mgeeweb_tool:get_int_param("role_id",QueryString),
            case catch get_role_info2(OpType,OpSubType,RoleId) of
                {error,OpCode,OpReason} ->
                    RtnStr = lists:concat(["{\"op_code\":",OpCode,",\"op_reason\":\"",OpReason,"\"}"]),
                    mgeeweb_tool:return_string(RtnStr, Req);
                {ok,role_offline} ->
                    case catch get_role_info2(?get_role_info_op_type_dirty,OpSubType,RoleId) of
                        {error,OpCode,OpReason} ->
                            RtnStr = lists:concat(["{\"op_code\":",OpCode,",\"op_reason\":\"",OpReason,"\"}"]),
                            mgeeweb_tool:return_string(RtnStr, Req);
                        {ok,RtnStr} ->
                            mgeeweb_tool:return_string(RtnStr, Req)
                    end;
                {ok,RtnStr} ->
                    mgeeweb_tool:return_string(RtnStr, Req)
            end
    end.
get_role_info2(?get_role_info_op_type_dirty,OpSubType,RoleId) ->
    case OpSubType of
        ?get_role_info_op_sub_type_base ->
            case common_misc:get_role_base(RoleId) of
                {ok,RoleBase} ->
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(RoleBase),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        ?get_role_info_op_sub_type_attr ->
            case common_misc:get_role_attr(RoleId) of
                {ok,RoleAttr} ->
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(RoleAttr),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        ?get_role_info_op_sub_type_pos ->
            case common_misc:get_role_pos(RoleId) of
                {ok,RolePos} ->
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(RolePos),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        ?get_role_info_op_sub_type_ext ->
            case common_misc:get_role_ext(RoleId) of
                {ok,RoleExt} ->
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(RoleExt),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        ?get_role_info_op_sub_type_p_role ->
            case common_misc:get_role_base(RoleId) of
                {ok,RoleBase} ->
                    {ok,RoleAttr} = common_misc:get_role_attr(RoleId),
                    PRole = #p_role{base = RoleBase,attr = RoleAttr},
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(PRole),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        ?get_role_info_op_sub_type_state ->
            case common_misc:get_role_state(RoleId) of
                {ok,RoleState} ->
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(RoleState),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        _ ->
            RtnStr = "",
            erlang:throw({error,?_RC_ADMIN_API_001,""})
    end,
    {ok,RtnStr};
get_role_info2(?get_role_info_op_type_cur,OpSubType,RoleId) ->
    case erlang:whereis(common_misc:get_role_world_process_name(RoleId)) of
        undefined ->
            erlang:throw({ok,role_offline});
        _ ->
            next
    end,
    case OpSubType of
        ?get_role_info_op_sub_type_base ->
            case mod_role:get_role_base(RoleId) of
                {ok,RoleBase} ->
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(RoleBase),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        ?get_role_info_op_sub_type_attr ->
            case mod_role:get_role_attr(RoleId) of
                {ok,RoleAttr} ->
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(RoleAttr),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        ?get_role_info_op_sub_type_pos ->
            case mod_role:get_role_pos(RoleId) of
                {ok,RolePos} ->
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(RolePos),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        ?get_role_info_op_sub_type_ext ->
            case common_misc:get_role_ext(RoleId) of
                {ok,RoleExt} ->
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(RoleExt),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        ?get_role_info_op_sub_type_p_role ->
            case mod_role:get_role_base(RoleId) of
                {ok,RoleBase} ->
                    {ok,RoleAttr} = mod_role:get_role_attr(RoleId),
                    PRole = #p_role{base = RoleBase,attr = RoleAttr},
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(PRole),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        ?get_role_info_op_sub_type_state ->
            case mod_role:get_role_state(RoleId) of
                {ok,RoleState} ->
                    RtnStr = lists:concat(["{\"op_code\":0,\"op_reason\":\"\",\"data\":",common_misc:record_to_json(RoleState),"}"]);
                _ ->
                    RtnStr = "",
                    erlang:throw({error,?_RC_ADMIN_API_002,""})
            end;
        _ ->
            RtnStr = "",
            erlang:throw({error,?_RC_ADMIN_API_001,""})
    end,
    {ok,RtnStr};
get_role_info2(_OpType,_OpSubType,_RoleId) ->
    {error,?_RC_ADMIN_API_000,""}.

%% 查询玩家背包数据
get_role_bag(Req) ->
	case catch get_role_bag2(Req) of
		{error,OpCode,OpReason} ->
			Rtn = [{op_code,OpCode},{op_reason,OpReason}];
		{ok,GridNumber,Data} ->
			Rtn = [{op_code,0},{op_reason,""},{grid_number,GridNumber},{data,Data}]
	end,
	mgeeweb_tool:return_json(Rtn, Req).
get_role_bag2(Req) ->
	ok = mgeeweb_tool:check_admin_api_request(Req),
	QueryString = Req:parse_post(),
	RoleId = mgeeweb_tool:get_int_param("role_id",QueryString),
	BagId = mgeeweb_tool:get_int_param("bag_id",QueryString),
	case RoleId > 0 andalso erlang:is_integer(RoleId) of
		true ->
			next;
		_ ->
			erlang:throw({error,?_RC_ADMIN_API_005})
	end,
	case BagId > 0 andalso erlang:is_integer(BagId) of
		true ->
			next;
		_ ->
			erlang:throw({error,?_RC_ADMIN_API_005})
	end,
	case common_misc:get_role_base(RoleId) of
		{ok,_RoleBase} ->
			next;
		_ ->
			erlang:throw({error,?_RC_ADMIN_API_016})
	end,
	case mod_bag:get_dirty_role_bag(RoleId, BagId) of
		{ok,#r_role_bag{grid_number=GridNumber,bag_goods=BagGoodsList}} ->
			next;
		_ ->
			GridNumber = 0,BagGoodsList=[]
	end,
	NewList = [ common_misc:record_to_json(Rec) ||Rec <- BagGoodsList ],
	Data = lists:concat(["[",string:join(NewList, ","),"]"]),
	{ok,GridNumber,Data}.
%% 查询玩家帮派信息
get_role_family(Req) ->
	case catch get_role_family2(Req) of
		{error,OpCode,OpReason} ->
			Rtn = [{op_code,OpCode},{op_reason,OpReason}];
		{ok,FamilyId,FamilyName,Data} ->
			Rtn = [{op_code,0},{op_reason,""},{family_id,FamilyId},{family_name,FamilyName},{data,Data}]
	end,
	mgeeweb_tool:return_json(Rtn, Req).
get_role_family2(Req) ->
	ok = mgeeweb_tool:check_admin_api_request(Req),
	QueryString = Req:parse_post(),
	RoleId = mgeeweb_tool:get_int_param("role_id",QueryString),
	case RoleId > 0 andalso erlang:is_integer(RoleId) of
		true ->
			next;
		_ ->
			erlang:throw({error,?_RC_ADMIN_API_005})
	end,
	case mod_role:get_role_base(RoleId) of
		{ok,RoleBase} ->
			next;
		_ ->
			case common_misc:get_role_base(RoleId) of
				{ok,RoleBase} ->
					next;
				_ ->
					RoleBase = undefined,
					erlang:throw({error,?_RC_ADMIN_API_016})
			end
	end,
	case mod_family:get_dirty_family_member(RoleId) of
		{ok,FamilyMemberInfo} ->
			Data = common_misc:record_to_json(FamilyMemberInfo);
		_ ->
			Data = ""
	end,
	{ok,RoleBase#p_role_base.family_id,RoleBase#p_role_base.family_name,Data}.

update_role_info(Req)->
    case catch update_role_info2(Req) of
        {error,OpCode,OpReason}->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok,_NewRoleBase}->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).

update_role_info2(Req)->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    RoleId = mgeeweb_tool:get_int_param("role_id",QueryString),
    FieldId = mgeeweb_tool:get_int_param("field_id", QueryString),
    FieldValue = mgeeweb_tool:get_int_param("field_value", QueryString),
    case RoleId > 0 andalso erlang:is_integer(RoleId) of
        true->
            next;
        _->
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase}->
            RoleOnline=true;
        _->
            case common_misc:get_role_base(RoleId) of
                {ok,RoleBase}->
                    next;
                _->
                    RoleBase = undefined,
                    erlang:throw({error,?_RC_ADMIN_API_016,""})
            end,
            RoleOnline=false
    end,
    case FieldId of
        ?set_role_info_level->
            NewRoleBase=RoleBase#p_role_base{level=FieldValue};
        ?set_role_info_is_pay->
            case FieldValue of
                0->
                    next;
                1-> 
                    next;
                _->
                    erlang:throw({error,?_RC_ADMIN_API_005,""})
            end,
            
            NewRoleBase=RoleBase#p_role_base{is_pay=FieldValue};
        ?set_role_info_total_gold->
            NewRoleBase=RoleBase#p_role_base{total_gold=FieldValue};
        _->
            NewRoleBase = RoleBase,
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    case RoleOnline of
        true->
            mod_role:set_role_base(RoleId, NewRoleBase);
        _->
            db_api:dirty_write(?DB_ROLE_BASE,NewRoleBase)
    end,
    {ok,NewRoleBase}.
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    