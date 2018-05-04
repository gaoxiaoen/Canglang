%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-6
%% Description: 信件模块
-module(mod_letter).
%%
%% Include files
%%
-include("mgeew.hrl").
-define(ALL_FAMILY_MEMBERS,0).
-define(ONLINE_FAMILY_MEMBERS,1).
-define(OFFLINE_FAMILY_MEMBERS,2).
-define(LETTER_ACCEPT_ALL_GOODS,0).
%%
%% Exported Functions
%%
-export([
         handle/1
        ]).


%%---------------------------------角色模块调用的借口-------------------------------
handle({send_p2p,RoleId,DataIn,PId})->
    send_p2p_letter(RoleId,DataIn,PId);
handle({accept_goods,DataIn,RoleId,PId,LetterInfo})->
    accept_goods(DataIn,RoleId,PId,LetterInfo).



%% ====================start 玩家发送个人信件 ===================
send_p2p_letter(RoleId,DataIn,PId)->
    case catch send_p2p_letter2(RoleId,DataIn) of
        {error,OpCode,OpReason} ->
            send_p2p_letter_error(RoleId,DataIn,PId,OpCode,OpReason);
        {ok,RoleBase,RecvId,OpFee} ->
            send_p2p_letter3(RoleId,DataIn,PId,RoleBase,RecvId,OpFee)
    end.
send_p2p_letter2(RoleId,DataIn) ->
    #m_letter_p2p_send_tos{receiver = RecvName, 
                           text = Text, 
                           goods_id_list = GoodsIdList} = DataIn,
    %%  检查对方是否存在 
    case common_misc:get_role_id(RecvName) of
        {ok,RecvId} ->
            next;
        _ ->
            RecvId = 0,
            erlang:throw({error,?_RC_LETTER_P2P_SEND_001,""})
    end,
    %%  检查信件长度
    case length(Text) of
        Length when Length>?LIMIT_LETTER_LENGTH->
            erlang:throw({error,?_RC_LETTER_P2P_SEND_002,""});
        0->
            erlang:throw({error,?_RC_LETTER_P2P_SEND_003,""});
        _->
            next
    end,
    %%  检查是否有物品
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_LETTER_P2P_SEND_004,""})
    end,
    lists:foreach(
      fun(GoodsId) -> 
              case mod_bag:is_in_bag_by_id(RoleId, GoodsId) of
                  {ok,_Goods} ->
                      next;
                  _ ->
                      erlang:throw({error,?_RC_LETTER_P2P_SEND_005,""})
              end
      end, GoodsIdList),
    %%   检查是否够钱        
    #p_role_base{gold=Gold} =RoleBase,
    OpFee = ?LETTER_SEND_COST * erlang:length(GoodsIdList),
    case Gold >= OpFee of
        true->
            next;
        false->
            erlang:throw({error,?_RC_LETTER_P2P_SEND_006,""})
    end,
    {ok,RoleBase,RecvId,OpFee}.

send_p2p_letter3(RoleId,DataIn,PId,RoleBase,RecvId,OpFee) ->
    case common_transaction:transaction(
           fun()->
                   t_send_p2p_letter(RoleId,DataIn,RoleBase,OpFee)
           end) of
        {atomic,{ok,NewRoleBase,DelGoodsList}} ->
            send_p2p_letter4(RoleId,DataIn,PId,NewRoleBase,RecvId,OpFee,DelGoodsList);
        {aborted,Error} ->
            OpCode = ?_RC_LETTER_P2P_SEND_004,
            OpReason = "",
            ?ERROR_MSG("~ts,Error=~w",[?_LANG_LOCAL_026,Error]),
            send_p2p_letter_error(RoleId,DataIn,PId,OpCode,OpReason)
    end.

t_send_p2p_letter(RoleId,DataIn,RoleBase,OpFee) ->
    NewRoleBase = RoleBase#p_role_base{gold = RoleBase#p_role_base.gold - OpFee},
    mod_role:t_set_role_base(RoleId, NewRoleBase),
    {ok,DelGoodsList} = mod_bag:t_delete_goods(RoleId, DataIn#m_letter_p2p_send_tos.goods_id_list),
    {ok,NewRoleBase,DelGoodsList}.
send_p2p_letter4(RoleId,DataIn,PId,NewRoleBase,RecvId,OpFee,DelGoodsList) ->
    #m_letter_p2p_send_tos{receiver = RecvName,
                           text = Text,
                           goods_id_list = GoodsIdList} = DataIn,
    LogTime = common_tool:now(),
    case DelGoodsList =/= [] of
        true ->
            common_log:log_goods_list({NewRoleBase,?LOG_CONSUME_GOODS_LETTER_P2P_SEND,LogTime,DelGoodsList,""}),
            common_misc:send_role_goods_change(PId, [], GoodsIdList);
        _ ->
            next
    end,
    common_misc:send_role_attr_change_gold(PId, NewRoleBase),
    common_log:log_gold({NewRoleBase,?LOG_CONSUME_GOLD_SEND_LETTER,LogTime,OpFee}),
    
    SendParam = {send_p2p_letter_succ,{RoleId,NewRoleBase#p_role_base.role_name,RecvId,RecvName,Text,DelGoodsList}},
    ?TRY_CATCH(erlang:send(mgeew_letter_server, SendParam),Err),
    
    case common_misc:get_role_base(RoleId) of
        {ok,#p_role_base{account_name = RecvAccountName}} ->
            next;
        _ ->
            RecvAccountName = ""
    end,
    LogLetterInfo = #r_log_letter{sender_role_id = NewRoleBase#p_role_base.role_id,
                                  sender_role_name = NewRoleBase#p_role_base.role_name,
                                  sender_account_name = NewRoleBase#p_role_base.account_name, 
                                  receiver_role_id = RecvId,
                                  receiver_role_name = RecvName,
                                  receiver_account_name = RecvAccountName, 
                                  mtime = LogTime,is_system = 0,letter_type = ?TYPE_LETTER_PRIVATE,
                                  title = "", content = Text, 
                                  gold = 0, money = 0,coin = 0,
                                  attachments = DelGoodsList,
                                  log_desc = ""},
    common_log:log_letter(LogLetterInfo),
    ok.
send_p2p_letter_error(_RoleId,_DataIn,PId,OpCode,OpReason) ->
    SendSelf = #m_letter_send_toc{op_code = OpCode, op_reason = OpReason},
    common_misc:unicast(PId,?LETTER,?LETTER_SEND,SendSelf).

%% ====================end 玩家发送个人信件 ===================

%% ====================start 玩家获取物品 ========================

%% LetterAttr:atom() public|personal
%% LetterID:int() 
accept_goods(DataIn,RoleId,PId,LetterInfo)->
	#r_letter_info{role_id=_SendRoleId,goods_list=OldGoodsList} = LetterInfo,
    {GoodsList,ReGoodsList}=remain_letter_goods(DataIn,OldGoodsList),
    %% 后台赠送物品需要扩展属性
    case common_transaction:transaction(
           fun() ->
                   {ok,RoleBase} = mod_role:get_role_base(RoleId),
                   {ok,NewGoodsList,LogGoodsList} = mod_bag:t_create_goods_by_p_goods(RoleId, GoodsList),
                   {ok,RoleBase,NewGoodsList,LogGoodsList}
           end) 
        of
        {atomic,{ok,RoleBase,NewGoodsList,LogGoodsList}}->
            LogTime = common_tool:now(),
            common_log:log_goods_list({RoleBase,?LOG_GAIN_GOODS_LETTER_ACCEPT_GOODS,LogTime,LogGoodsList,""}),
            common_misc:send_role_goods_change(PId, NewGoodsList, []),
            
            %% 通知前端 
            SendSelf = #m_letter_accept_goods_toc{op_code=0,
                                                  letter_id=DataIn#m_letter_accept_goods_tos.letter_id,
                                                  goods_id= DataIn#m_letter_accept_goods_tos.goods_id,
                                                  goods_num=length(ReGoodsList)},
            common_misc:unicast(PId, ?LETTER, ?LETTER_ACCEPT_GOODS, SendSelf),
            %% 通知世界节点
            ?TRY_CATCH(erlang:send(mgeew_letter_server,{accept_goods_succ,RoleId,DataIn,ReGoodsList}),Err),
            %% TODO 信件日志
            next;
        {aborted,{bag_error, not_enough_pos}}->
            SendSelf = #m_letter_accept_goods_toc{op_code = ?_RC_LETTER_ACCEPT_GOODS_004, 
                                                  op_reason = "",
                                                  letter_id=DataIn#m_letter_accept_goods_tos.letter_id,
                                                  goods_id= DataIn#m_letter_accept_goods_tos.goods_id},
            common_misc:unicast(PId, ?LETTER, ?LETTER_ACCEPT_GOODS, SendSelf),
            ?TRY_CATCH(erlang:send(mgeew_letter_server, {accept_goods_fail,RoleId,DataIn}),Err);
        {aborted,Error}->
            ?ERROR_MSG("~ts,Error=~w",[?_LANG_LOCAL_027,Error]),
            SendSelf = #m_letter_accept_goods_toc{op_code = ?_RC_LETTER_ACCEPT_GOODS_005, 
                                                  op_reason = "",
                                                  letter_id=DataIn#m_letter_accept_goods_tos.letter_id,
                                                  goods_id= DataIn#m_letter_accept_goods_tos.goods_id},
            common_misc:unicast(PId, ?LETTER, ?LETTER_ACCEPT_GOODS, SendSelf),
            ?TRY_CATCH(golbal:send(mgeew_letter_server, {accept_goods_fail,RoleId,DataIn}),Err)
    end.

%%返回信件剩余的附件物品
remain_letter_goods(DataIn,OldGoodsList) ->
    case DataIn#m_letter_accept_goods_tos.goods_id of
        ?LETTER_ACCEPT_ALL_GOODS ->
            ReGoodsList = [],
            GoodsList = OldGoodsList;
        Id ->
            Goods = lists:keyfind(Id,#p_goods.id, OldGoodsList),
            ReGoodsList = lists:delete(Goods, OldGoodsList),
            GoodsList = [Goods]
    end,
    {GoodsList,ReGoodsList}.
%% =========================end 玩家获取物品 ========================

