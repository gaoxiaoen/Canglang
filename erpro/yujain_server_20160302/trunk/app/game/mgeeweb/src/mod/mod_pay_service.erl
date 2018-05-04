%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-15
%% Description: 充值接口
-module(mod_pay_service).

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
handle("/pay" ++ _, Req, _) ->
    do_pay(Req);

handle(Path, Req, _) ->
    ?ERROR_MSG("~ts,Path=~w,Req=~w",["receive unknown message",Path,Req]),
    mgeeweb_tool:return_json_error(Req).

do_pay(Req) ->
    case catch do_pay2(Req) of
        {error,OpCode,OpReason} ->
            RtnStr = lists:concat(["{\"op_code\":",OpCode,",\"op_reason\":\"",OpReason,"\"}"]),
            mgeeweb_tool:return_string(RtnStr, Req);
        {ok,RoleId,OrderId,AccountName,AccountVia,PayTime,PayMoney,PayGold,ServerId,PFOrderId} ->
            do_pay3(Req,RoleId,OrderId,AccountName,AccountVia,PayTime,PayMoney,PayGold,ServerId,PFOrderId);
        Error ->
            ?ERROR_MSG("~ts,Request Param=~w,Error=~w",[?_LANG_LOCAL_007,Req:parse_qs(),Error]),
            RtnStr = lists:concat(["{\"op_code\":",?_RC_ADMIN_API_005,",\"op_reason\":\"\"}"]),
            mgeeweb_tool:return_string(RtnStr, Req)
    end.

do_pay2(Req) ->
    ok = mgeeweb_tool:check_pay_api_request(Req),
    QueryString = Req:parse_post(),
    OrderId = proplists:get_value("order_id", QueryString),
    AccountName = common_tool:to_binary(proplists:get_value("account_name", QueryString)),
    AccountVia = proplists:get_value("account_via", QueryString,"0"),
    
    PPayTime = proplists:get_value("pay_time", QueryString),
    PayTime = common_tool:to_integer(PPayTime),
    
    PPayMoney = proplists:get_value("pay_money", QueryString),
    PayMoney = to_money(PPayMoney),
    
    PPayGold = proplists:get_value("pay_gold", QueryString),
    PayGold = common_tool:to_integer(PPayGold),
    
    PServerId = proplists:get_value("server_id", QueryString),
    ServerId = common_tool:to_integer(PServerId),
    
    PFOrderId = mgeeweb_tool:get_string_param("pf_order_id", QueryString),
    
    case PayTime > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    
    case PayMoney > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    
    case PayGold > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    
    %% 判断此帐号在此服，是否有角色
    case db_api:dirty_read(?DB_ACCOUNT, AccountName) of
        [AccountInfo] ->
            case lists:keyfind(ServerId, #r_account_sub.server_id, AccountInfo#r_account.role_list) of
                false ->
                    RoleId = 0;
                #r_account_sub{role_id = RoleId} ->
                    next
            end;
        _ ->
            RoleId = 0,
            erlang:throw({error,?_RC_ADMIN_API_008,""})
    end,
    {ok,RoleId,OrderId,AccountName,AccountVia,PayTime,PayMoney,PayGold,ServerId,PFOrderId}.

do_pay3(Req,RoleId,OrderId,AccountName,AccountVia,PayTime,PayMoney,PayGold,ServerId,PFOrderId) ->
    case erlang:whereis(mgeew_pay_server) of
        undefined ->
            OpCode = ?_RC_ADMIN_API_006,
            OpReason = "";
        PId ->
            case gen_server:call(PId, {pay,{RoleId,OrderId,AccountName,AccountVia,PayTime,PayMoney,PayGold,ServerId,PFOrderId}}) of
                ok ->
                    OpCode = 0,
                    OpReason = "";
                {error,OpCode,OpReason} ->
                    next;
                Error ->
                    ?ERROR_MSG("~ts,AccountName=~s,Error=~w",[?_LANG_LOCAL_006,AccountName,Error]),
                    OpCode = ?_RC_ADMIN_API_007,
                    OpReason = ""
            end
    end,
    RtnStr = lists:concat(["{\"op_code\":",OpCode,",\"op_reason\":\"",OpReason,"\"}"]),
    mgeeweb_tool:return_string(RtnStr, Req).
to_money(MoneyArg) when is_float(MoneyArg)->
    MoneyArg;
to_money(MoneyArg)->
    case is_list(MoneyArg) andalso string:str(MoneyArg,".")>0 of
        true->
            erlang:list_to_float(MoneyArg);
        _ ->
            common_tool:to_integer(MoneyArg)
    end.


