%% Author: caochuncheng2002@gmail.com
%% Created: 2013-11-14
%% Description: 帮派信息接口处理模块
-module(mod_family_service).

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
handle("/get_family" ++ _, Req, _) ->
	get_family(Req);

handle(Path, Req, _) ->
    ?ERROR_MSG("~ts,Path=~w,Req=~w",["receive unknown message",Path,Req]),
    mgeeweb_tool:return_json_error(Req).

%% 查询帮派信息
get_family(Req) ->
	case catch get_family2(Req) of
		{error,OpCode,OpReason} ->
			Rtn = [{op_code,OpCode},{op_reason,OpReason}];
		{ok,Data} ->
			Rtn = [{op_code,0},{op_reason,""},{data,Data}]
	end,
	mgeeweb_tool:return_json(Rtn, Req).
get_family2(Req) ->
	ok = mgeeweb_tool:check_admin_api_request(Req),
	QueryString = Req:parse_post(),
	FamilyId = mgeeweb_tool:get_int_param("family_id",QueryString),
	case FamilyId > 0 andalso erlang:is_integer(FamilyId) of
		true ->
			next;
		_ ->
			erlang:throw({error,?_RC_ADMIN_API_005})
	end,
	case mod_family:get_dirty_family(FamilyId) of
		{ok,FamilyInfo} ->
			Data = common_misc:record_to_json(FamilyInfo);
		_ ->
			Data = ""
	end,
	{ok,Data}.