%%%-------------------------------------------------------------------
%%% File        :mod_ban_service.erl
%%%-------------------------------------------------------------------
-module(mod_ban_service).

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

handle("/list" ++ _, Req, _) ->
    do_list(Req);

handle("/ban" ++ _, Req, _) ->
    do_ban(Req);

handle("/unban" ++ _, Req, _) ->
    do_unban(Req);

handle(Path, Req, _) ->
    ?ERROR_MSG("~ts,Path=~w,Req=~w",["receive unknown message",Path,Req]),
    mgeeweb_tool:return_json_error(Req).

%% 禁言列表
do_list(Req) ->
    case catch do_list2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok,Data} ->
            Rtn = [{op_code,0},{op_reason,""},{data,Data}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).

do_list2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    case db_api:dirty_match_object(?DB_BAN_CHAT_USER,#r_ban_chat_user{_='_'}) of
        []-> 
            Data = "";
        List ->
            NewList = [ common_misc:record_to_json(Rec) ||Rec<-List ],
            Data = lists:concat(["[",string:join(NewList, ","),"]"])
    end,
    {ok,Data}.

%% 禁言
do_ban(Req) -> 
    case catch do_ban2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).

do_ban2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    RoleId = common_tool:to_integer(proplists:get_value("role_id",QueryString,0)),
    _RoleName = common_tool:to_binary(proplists:get_value("role_name",QueryString,"")),
    Duration = common_tool:to_integer(proplists:get_value("duration",QueryString,0)),
    PReason = proplists:get_value("reason",QueryString,""),
    Reason = common_tool:to_binary(base64:decode_to_string(base64:decode_to_string(PReason))),
    case RoleId > 0 andalso Duration > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    case common_misc:get_role_base(RoleId) of
        {ok,_RoleBase} ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_016,""})
    end,
    mod_chat:ban(RoleId,Duration,Reason),
    {ok}.

%% 解禁
do_unban(Req) ->
    case catch do_unban2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_unban2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    RoleId = common_tool:to_integer(proplists:get_value("role_id",QueryString,0)),
    case RoleId > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    case common_misc:get_role_base(RoleId) of
        {ok,_RoleBase} ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_016,""})
    end,
    mod_chat:unban(RoleId),
    {ok}.

