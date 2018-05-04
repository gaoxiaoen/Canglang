%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-17
%% Description: 加钱模块
-module(mod_money).

%%
%% Include files
%%
-include("mgeew.hrl").
%%
%% Exported Functions
%%
-export([handle/1]).

%%
%% API Functions
%%
handle({pay,Info}) ->
    do_pay(Info);
handle({admin_pay,Info}) ->
    do_admin_pay(Info);

handle({admin_deduct_money,Info}) ->
    do_admin_deduct_money(Info);

handle(Info)->
	?ERROR_MSG("receive unknown message,Info=~w",[Info]).
%% 充值
do_pay({RoleId,PayGold,PayRequest,LogPay}) ->
    case common_transaction:t(
           fun() -> 
                   {ok,RoleBase} = mod_role:get_role_base(RoleId),
                   NewRoleBase = RoleBase#p_role_base{gold = RoleBase#p_role_base.gold + PayGold,
                                                      total_gold = RoleBase#p_role_base.total_gold + PayGold},
                   %% 判断是否是首次充值
                   case RoleBase#p_role_base.total_gold > 0 
                        andalso RoleBase#p_role_base.is_pay == 0 of
                       true->
                           IsFirstPay = true;
                       _->
                           IsFirstPay = false
                   end,
                   mod_role:t_set_role_base(RoleId, NewRoleBase),
                   {ok,NewRoleBase,IsFirstPay}
           end) of
        {atomic,{ok,NewRoleBase,_IsFirstPay}} ->
            %% 日志
            NewLogPay = LogPay#r_log_pay{level = NewRoleBase#p_role_base.level,
                                         pay_status = 1},
            common_log:insert_log(pay, [NewLogPay]),
            
            LogTime = common_tool:now(),
            common_log:log_gold({NewRoleBase,?LOG_GAIN_GOLD_PAY,LogTime,PayGold}),
            common_misc:send_role_attr_change_gold(RoleId, NewRoleBase),
            common_misc:send_role_attr_change(RoleId,[#p_attr{attr_code = ?ROLE_BASE_TOTAL_GOLD,int_value = NewRoleBase#p_role_base.total_gold}]),
            NewPayRequest = PayRequest#r_pay_request{status = 1},
            db_api:dirty_write(?DB_PAY_REQUEST,NewPayRequest),
            ok;
        {aborted,Error}->
            ?ERROR_MSG("~ts,Error=~w",[?_LANG_LOCAL_028,Error]),
            
            NewLogPay = LogPay#r_log_pay{pay_status = 2},
            common_log:insert_log(pay, [NewLogPay]),
            
            NewPayRequest = PayRequest#r_pay_request{status = 2},
            db_api:dirty_write(?DB_PAY_REQUEST,NewPayRequest),
            {error,?_RC_ADMIN_API_007,""}
    end.
%% 后台充值
do_admin_pay({RoleId,Gold,Silver,Coin}) ->
    case common_transaction:t(
           fun() -> 
                   {ok,RoleBase} = mod_role:get_role_base(RoleId),
                   NewRoleBase = RoleBase#p_role_base{gold = RoleBase#p_role_base.gold + Gold,
                                                      total_gold = RoleBase#p_role_base.total_gold+Gold,
                                                      silver = RoleBase#p_role_base.silver + Silver,
                                                      coin = RoleBase#p_role_base.coin + Coin
                                                     },
                   %% 判断是否是首次充值
                   case RoleBase#p_role_base.total_gold < 100 
                       andalso RoleBase#p_role_base.is_pay == 0 of
                       true->
                           IsFirstPay = true;
                       _->
                           IsFirstPay = false
                   end,
                   mod_role:t_set_role_base(RoleId, NewRoleBase),
                   {ok,NewRoleBase,Coin,IsFirstPay}
           end) of
        {atomic,{ok,NewRoleBase,NewCoin,_IsFirstPay}} ->
            %% 日志
            LogTime = common_tool:now(),
            case Gold > 0 of
                true ->
                    common_log:log_gold({NewRoleBase,?LOG_GAIN_GOLD_ADMIN_PAY,LogTime,Gold});
                _ ->
                    next
            end,
            case Silver > 0 of
                true ->
                    common_log:log_silver({NewRoleBase,?LOG_GAIN_SILVER_ADMIN_PAY,LogTime,Silver});
                _ ->
                    next
            end,
            case NewCoin > 0 of
                true ->
                    common_log:log_coin({NewRoleBase,?LOG_GAIN_COIN_ADMIN_PAY,LogTime,NewCoin});
                _ ->
                    next
            end,
            common_misc:send_role_attr_change_gold_and_silver(RoleId, NewRoleBase),
            ok;
        {aborted,Error}->
            ?ERROR_MSG("~ts,RoleId=~w,Error=~w",[?_LANG_LOCAL_029,RoleId,Error])
    end.

%% FromPId 从什么进程发启扣钱操作
%% ErlModule 返回的模块名称，此模块必须有handle/1函数处理
%% HandleKey 返回的消息定义
%% DeductList 扣除列表 [{gold,DeductGold},{silver,DeductSilver},{coin,DeductCoin}]
%% BackParam 返回参数
do_admin_deduct_money({RoleId,DeductList,FromPId,ErlModule,HandleKey,BackParam}) ->
    case catch do_admin_deduct_money2(RoleId,DeductList) of
        {error,OpCode} ->
            FromPId ! {mod,ErlModule,{HandleKey,{OpCode,BackParam}}};
        {ok,NewRoleBase,AttrList} ->
            do_admin_deduct_money3(RoleId,DeductList,FromPId,ErlModule,HandleKey,BackParam,
                                   NewRoleBase,AttrList)
    end.
do_admin_deduct_money2(RoleId,DeductList) ->
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_GLOBAL_MONEY_000})
    end,
    {NewRoleBase,AttrList} = 
        lists:foldl(
          fun({Key,Value},{AccRoleBase,AccAttrList}) -> 
                  case Key of
                      gold ->
                          case AccRoleBase#p_role_base.gold >= Value of
                              true ->
                                  NewValue = AccRoleBase#p_role_base.gold - Value,
                                  {AccRoleBase#p_role_base{gold=NewValue},
                                   [#p_attr{attr_code=?ROLE_BASE_GOLD,int_value=NewValue}|AccAttrList]};
                              _ ->
                                  erlang:throw({error,?_RC_GLOBAL_MONEY_001})
                          end;
                      silver ->
                          case AccRoleBase#p_role_base.silver >= Value of
                              true ->
                                  NewValue = AccRoleBase#p_role_base.silver - Value,
                                  {AccRoleBase#p_role_base{silver=NewValue},
                                   [#p_attr{attr_code=?ROLE_BASE_SILVER,int_value=NewValue}|AccAttrList]};
                              _ ->
                                  erlang:throw({error,?_RC_GLOBAL_MONEY_002})
                          end;
                      coin ->
                          case AccRoleBase#p_role_base.coin >= Value of
                              true ->
                                  NewValue = AccRoleBase#p_role_base.coin - Value,
                                 {AccRoleBase#p_role_base{coin=NewValue},
                                  [#p_attr{attr_code=?ROLE_BASE_COIN,int_value=NewValue}|AccAttrList]};
                              _ ->
                                  erlang:throw({error,?_RC_GLOBAL_MONEY_003})
                          end;
                      _ ->
                          erlang:throw({error,?_RC_GLOBAL_MONEY_004})
                  end
          end, {RoleBase,[]},DeductList),
    {ok,NewRoleBase,AttrList}.
do_admin_deduct_money3(RoleId,DeductList,FromPId,ErlModule,HandleKey,BackParam,
                       NewRoleBase,AttrList) ->
    case common_transaction:t(
           fun() -> 
                   mod_role:t_set_role_base(RoleId, NewRoleBase),
                   {ok}
           end) of
        {atomic,{ok}} ->
           FromPId ! {mod,ErlModule,{HandleKey,{0,AttrList,BackParam}}},
           ok;
        {aborted,Error}->
            ?ERROR_MSG("~ts,RoleId=~w,DeductList=~w,Error=~w",[?_LANG_LOCAL_030,RoleId,DeductList,Error]),
            FromPId ! {mod,ErlModule,{HandleKey,{?_RC_GLOBAL_MONEY_005,BackParam}}}
    end.

