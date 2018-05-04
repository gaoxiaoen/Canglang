%% 
%% @author qingxuan
%% --------------------------------------------------------------------
-module(campaign_rpc).
-export([
        handle/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("campaign.hrl").
-include("npc_store.hrl").
-include("link.hrl").

%% 后台活动奖励领取、兑换、购买
handle(15830, {}, _Role) ->
    CampTotal = campaign_adm:get_main_camp_total(),
    case CampTotal of
        #campaign_total{name = Name, title = Title, camp_list = CampList} ->
            {reply, {Name, Title, CampList}};
        _ ->
            {reply, {<<>>, <<>>, []}}
    end;

%% 获取某个分活动数据
handle(15831, {CampId}, Role) ->
    CampTotal = campaign_adm:get_main_camp_total(Role),
    case CampTotal of
        #campaign_total{camp_list = CampList} ->
            case lists:keyfind(CampId, #campaign_adm.id, CampList) of
                false -> 
                    {ok};
                Camp ->
                    campaign_adm:pack_send_camp_info(Role, Camp),
                    {ok}
            end;
        _ ->
            {ok}
    end;

%% 活动奖励领取、兑换、购买
handle(15845, {CampId, CondId}, Role) ->
    CampTotal = campaign_adm:get_main_camp_total(Role),
    case CampTotal of
        undefined ->
            {reply, {0, ?MSG_NULL}};
        #campaign_total{id = TotalId, camp_list = CampList} ->
            ?DEBUG("================================>[~p, ~p, ~p]", [TotalId, CampId, CondId]),
            role:send_buff_begin(),
            case campaign_adm_reward:exchange(Role, TotalId, CampId, CondId, _Card = <<>>) of
                {false, coin} ->
                    role:send_buff_clean(),
                    notice:alert(error, Role, ?MSGID(<<"金币不足">>)),
                    {reply, {?false}};
                {false, coin_bind} ->
                    role:send_buff_clean(),
                    notice:alert(error, Role, ?MSGID(<<"金币不足">>)),
                    {reply, {?false}};
                {false, gold} ->
                    role:send_buff_clean(),
                    notice:alert(error, Role, ?MSGID(<<"晶钻不足">>)),
                    {reply, {?false}};
                {false, gold_bind} ->
                    role:send_buff_clean(),
                    notice:alert(error, Role, ?MSGID(<<"晶钻不足">>)),
                    {reply, {?false}};
                {false, coin_all} ->
                    role:send_buff_clean(),
                    notice:alert(error, Role, ?MSGID(<<"所有金币不足">>)),
                    {reply, {?false}};
                {false, Reason} ->
                    role:send_buff_clean(),
                    notice:alert(error, Role, Reason),
                    {reply, {?false}};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    notice:alert(succ, Role, ?MSGID(<<"奖励领取成功">>)),
                    case lists:keyfind(CampId, #campaign_adm.id, CampList) of
                        false -> ignore;
                        Camp -> campaign_adm:pack_send_camp_info(NewRole, Camp)
                    end,
                    {reply, {?true}, NewRole}
            end
    end;

%% 兑换激活码
handle(15846, {CampId, CondId, Card}, Role) ->
    CampTotal = campaign_adm:get_main_camp_total(Role),
    case CampTotal of
        undefined ->
            {reply, {0, ?MSG_NULL}};
        #campaign_total{id = TotalId, camp_list = CampList} ->
            ?DEBUG("================================>[~p, ~p, ~p]", [TotalId, CampId, CondId]),
            role:send_buff_begin(),
            case campaign_adm_reward:exchange(Role, TotalId, CampId, CondId, Card) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    notice:alert(error, Role, Reason),
                    {reply, {?false}};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    notice:alert(succ, Role, ?MSGID(<<"奖励领取成功">>)),
                    case lists:keyfind(CampId, #campaign_adm.id, CampList) of
                        false -> ignore;
                        Camp -> campaign_adm:pack_send_camp_info(NewRole, Camp)
                    end,
                    {reply, {?true}, NewRole}
            end
    end;

handle(_Cmd, _Data, _Role) ->
    ?ERR("campaign, 错误的协议请求, ~w, ~w", [_Cmd, _Data]),
    {error, unknow_command}.

