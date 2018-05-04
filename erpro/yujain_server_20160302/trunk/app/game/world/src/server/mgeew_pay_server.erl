%%% -------------------------------------------------------------------
%%% Author  : caochuncheng2002@gmail.com
%%% Description :
%%% 充值功能处理服务
%%% Created : 2013-6-15
%%% -------------------------------------------------------------------
-module(mgeew_pay_server).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("mgeew.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([
         start/0, 
         start_link/0
        ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

start() ->
    {ok, _} = supervisor:start_child(mgeew_sup, {?MODULE, {?MODULE, start_link, []},
                                                 permanent, 30000, worker, [?MODULE]}).
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    erlang:process_flag(trap_exit, true),
    {ok, #state{}}.

handle_call(Request, _From, State) ->
    Reply = do_handle_call(Request),
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.


handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

do_handle_call({pay,Info}) ->
    do_pay(Info);
do_handle_call(Info) -> 
    ?ERROR_MSG("receive unknown message:Info=~w", [Info]).


do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;

do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).


do_pay({RoleId,OrderId,AccountName,AccountVia,PayTime,PayMoney,PayGold,ServerId,PFOrderId}) ->
    case catch do_pay2(RoleId,OrderId,AccountName,AccountVia,PayTime,PayMoney,PayGold,ServerId) of
        {error,OpCode,OpReason} ->
            {error,OpCode,OpReason};
        {ok,LogRoleBase} ->
            do_pay3(RoleId,OrderId,AccountName,AccountVia,PayTime,PayMoney,PayGold,ServerId,LogRoleBase,PFOrderId)
    end.
do_pay2(RoleId,OrderId,AccountName,_AccountVia,_PayTime,_PayMoney,_PayGold,_ServerId) ->
    %% 判断是否重复请求
    case db_api:dirty_read(?DB_PAY_REQUEST,{OrderId,AccountName}) of
        [_PayRequestInfo] ->
            erlang:throw({error,?_RC_ADMIN_API_009,""});
        _ ->
            next
    end,
    {ok,LogRoleBase} = common_misc:get_role_base(RoleId),
    {ok,LogRoleBase}.
do_pay3(RoleId,OrderId,AccountName,AccountVia,PayTime,PayMoney,PayGold,ServerId,LogRoleBase,PFOrderId) ->
    LogTime = common_tool:now(),
    %% 记录请求日志 
    LogPayRequest = #r_log_pay_request{order_id = OrderId,account_name = AccountName,account_via = AccountVia,
                                       mtime = LogTime,
                                       pay_money = PayMoney,gold = PayGold,pay_time = PayTime,
                                       server_id = ServerId,
                                       pf_order_id =PFOrderId},
    common_log:insert_log(pay_request, [LogPayRequest]),
    
    %% 充值请求记录
    PayRequest = #r_pay_request{key = {OrderId,AccountName},
                                order_id = OrderId,
                                account_name = AccountName,
                                account_via = AccountVia, 
                                pay_time = PayTime,
                                pay_money = PayMoney,
                                pay_gold = PayGold,
                                server_id = ServerId,
                                status = 0},
    
    %% 充值日志
    LogPay = #r_log_pay{order_id = OrderId,
                        account_name = AccountName,
                        account_via = AccountVia, 
                        account_type = LogRoleBase#p_role_base.account_type, 
                        role_id = RoleId, 
                        role_name = LogRoleBase#p_role_base.role_name, 
                        level = LogRoleBase#p_role_base.level, 
                        mtime = LogTime, 
                        pay_money = PayMoney,
                        gold = PayGold,
                        pay_time = PayTime,
                        pay_status = 1,
                        pf_order_id =PFOrderId},
    
    %% 充值处理
    case common_misc:send_to_role(RoleId, {mod,mod_money,{pay,{RoleId,PayGold,PayRequest,LogPay}}}) of
        ignore ->
            case db_api:transaction(
                   fun() -> 
                           [RoleBase] = db_api:read(?DB_ROLE_BASE, RoleId, write),
                           NewRoleBase = RoleBase#p_role_base{gold = RoleBase#p_role_base.gold + PayGold,
                                                              total_gold = RoleBase#p_role_base.total_gold + PayGold},
                           db_api:write(?DB_ROLE_BASE, NewRoleBase, write),
                           {ok,NewRoleBase}
                   end) of
                {atomic,{ok,NewRoleBase}} ->
                    %% 日志
                    NewLogPay = LogPay#r_log_pay{level = NewRoleBase#p_role_base.level,
                                                 pay_status = 1},
                    common_log:insert_log(pay, [NewLogPay]),
                    
                    common_log:log_gold({NewRoleBase,?LOG_GAIN_GOLD_PAY,LogTime,PayGold}),
                    
                    NewPayRequest = PayRequest#r_pay_request{status = 1},
                    db_api:dirty_write(?DB_PAY_REQUEST,NewPayRequest),
                    ok;
                {aborted,Error}->
                    ?ERROR_MSG("~ts,Error=~w",[?_LANG_LOCAL_000,Error]),
                    NewLogPay = LogPay#r_log_pay{pay_status = 2},
                    common_log:insert_log(pay, [NewLogPay]),
                    
                    NewPayRequest = PayRequest#r_pay_request{status = 2},
                    db_api:dirty_write(?DB_PAY_REQUEST,NewPayRequest),
                    {error,?_RC_ADMIN_API_007,""}
            end;
        _ ->
            db_api:dirty_write(?DB_PAY_REQUEST,PayRequest),
            ok
    end.



