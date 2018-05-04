-module(mod_limit_account_service).

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

handle("/limit" ++ _, Req, _) ->
    do_limit(Req);

handle("/unlimit" ++ _, Req, _) ->
    do_unlimit(Req);

handle(Path, Req, _) ->
    ?ERROR_MSG("~ts,Path=~w,Req=~w",["receive unknown message",Path,Req]),
    mgeeweb_tool:return_json_error(Req).

%% 禁言玩家列表
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
    case db_api:dirty_match_object(?DB_LIMIT_ACCOUNT,#r_limit_account{_='_'}) of
        []-> 
            Data = "";
        List ->
            NewList = [ common_misc:record_to_json(Rec) ||Rec<-List ],
            Data = lists:concat(["[",string:join(NewList, ","),"]"])
    end,
    {ok,Data}.

%% 禁言玩家
do_limit(Req) -> 
    case catch do_limit2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).

do_limit2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    AccountName = common_tool:to_list(proplists:get_value("account_name",QueryString,"")),
    LimitTime = common_tool:to_integer(proplists:get_value("limit_time",QueryString,"")),
    case LimitTime >= 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    LimitAccount = #r_limit_account{account_name = AccountName,limit_time = LimitTime},
    db_api:dirty_write(?DB_LIMIT_ACCOUNT,LimitAccount),
    common_misc:gen_limit_account_beam(),
    {ok}.
%% 解禁玩家
do_unlimit(Req) ->
    case catch do_unlimit2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_unlimit2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    AccountName = common_tool:to_list(proplists:get_value("account_name",QueryString,"")),
    db_api:dirty_delete(?DB_LIMIT_ACCOUNT,AccountName),
    common_misc:gen_limit_account_beam(),
    {ok}.
