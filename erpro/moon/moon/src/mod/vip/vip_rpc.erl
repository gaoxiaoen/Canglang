%%----------------------------------------------------
%% 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(vip_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("vip.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("item.hrl").
%%

%% 获取VIP信息
handle(12400, {}, Role) ->
    case vip:get_info(Role) of
        {ok, NRole, Info} -> {reply, Info, NRole};
        Info -> {reply, Info} 
    end;

%% 领取祝福
handle(12401, {}, Role) ->
    case vip:get_bless(Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {false, Reason, NRole} -> {reply, {0, Reason}, NRole};
        {ok, NRole} -> {reply, {1, ?L(<<"领取VIP祝福成功">>)}, NRole}
    end;

%% 头像更换
handle(12402, {0}, Role = #role{career = Career, sex = Sex}) ->
    FaceId = vip:get_face_id(Career, Sex),
    case vip:set_face(Role, FaceId) of 
        {false, Reason} -> {reply, {FaceId, 0, Reason}};
        {false, Reason, NRole} -> {reply, {FaceId, 0, Reason}, NRole};
        {ok, NRole} -> {reply, {FaceId, 1, ?L(<<"设置头像成功">>)}, NRole}
    end;
handle(12402, {FaceId}, Role) ->
    case vip:set_face(Role, FaceId) of 
        {false, Reason} -> {reply, {FaceId, 0, Reason}};
        {false, Reason, NRole} -> {reply, {FaceId, 0, Reason}, NRole};
        {ok, NRole} -> {reply, {FaceId, 1, ?L(<<"设置头像成功">>)}, NRole}
    end;

%% VIP增量财产处理
handle(12403, {}, _Role = #role{vip = #vip{hearsay = Hearsay, fly_sign = FlySign}}) ->
    {reply, {Hearsay, FlySign}};

%% VIP卡购买使用
handle(12404, {Type}, Role) ->
    case vip:buy(Type, Role) of
        {ok, NRole} -> 
            {reply, {1, <<>>}, NRole};
        {gold, Reason} -> {reply, {?gold_less, Reason}};
        {false, Reason} -> {reply, {0, Reason}};
        {false, Reason, NRole} -> 
            {reply, {0, Reason}, NRole}
    end;

%% VIP奖励领取
handle(12405, {Type}, Role) ->
    case vip:reward(Type, Role) of
        {false, Reason} -> {reply, {0, Reason, Type}};
        {map, NRole} -> {reply, {1, <<>>, Type}, NRole};
        {ok, NRole} ->
            log:log(log_bind_gold, {<<"vip领取">>, <<"">>, Role, NRole}),
            {reply, {1, ?L(<<"领取奖励成功">>), Type}, NRole}
    end;

%% 获取VIp活动头像列表
handle(12406, {}, #role{vip = #vip{face_list = FaceList}}) ->
    {reply, {FaceList}};

%% 获取当前VIp信息
% handle(12411, {}, #role{vip = #vip{all_gold = All, type = Lev, reward_times = Reward_times}}) ->
handle(12411, {}, Role) ->
    % Rewarded = [ID || {ID, _} <- Reward_times, is_number(ID) == true],
    % {Had_gain, Expire} = 
    %     case lists:keyfind(risk_gift, 1, Reward_times) of 
    %         false -> 
    %             {0, 0};
    %         {_, ContractId, _, ExpTime} ->
    %             Now = util:unixtime(),
    %             LeftTime = util:day_diff(Now, ExpTime),
    %             case ExpTime > Now andalso LeftTime =/= 0 of 
    %                 true -> {ContractId, LeftTime};
    %                 false -> {0, 0}
    %             end
    %     end,
    Reply = vip:get_role_vip_info(Role),
    {reply, Reply};

%% 购买特权礼包
handle(12412, {GiftLev}, Role = #role{link = #link{conn_pid = ConnPid}, vip = Vip =#vip{reward_times = Reward_times, type = VipLev}}) ->
    case GiftLev > VipLev of 
        true -> 
            notice:alert(error, ConnPid, ?MSGID(<<"未达到Vip等级，不能购买哈">>)),
            {ok};
        false ->
            case vip_data2:get_gift_base(GiftLev) of 
                {ok, #vip_gift_base{base_id = BaseId, price = Price}} ->
                    case lists:keyfind(GiftLev, 1, Reward_times) of 
                        false ->
                            case role_gain:do([#loss{label = gold, val = Price, msg = ?MSGID(<<"晶钻不足">>)}], Role) of
                                {false, #loss{msg = Msg}} -> 
                                    notice:alert(error, ConnPid, Msg),
                                    {ok};
                                {ok, NRole} ->
                                    case storage:make_and_add_fresh(BaseId, 0, 1, NRole) of
                                        {ok, NewRole, _} -> 
                                            NewRole2 = role_listener:get_item(NewRole, #item{base_id = BaseId, quantity = 1}),
                                            % NewRole3 = medal:listener(item, NewRole2, {BaseId, 1}),
                                            NReward_times = Reward_times ++ [{GiftLev, util:unixtime()}],
                                            NewRole4 = NewRole2#role{vip = Vip#vip{reward_times = NReward_times}},
                                            notice:alert(succ, ConnPid, ?MSGID(<<"恭喜你，购买成功">>)),
                                            {reply, {1}, NewRole4};
                                        {_, Reason} -> 
                                            notice:alert(error, ConnPid, Reason),
                                            {ok}
                                    end
                            end;
                        _ ->
                            notice:alert(error, ConnPid, ?MSGID(<<"特权礼包只能购买一次哈">>)),
                            {ok}
                    end;
                {false, Msg} ->
                    notice:alert(error, ConnPid, Msg),
                    {ok}
            end
    end;


% 领取冒险契约
handle(12413, {ContractId}, Role = #role{link = #link{conn_pid = ConnPid}, vip = #vip{reward_times = Reward_times}}) ->
    Now = util:unixtime(),
    case lists:keyfind(risk_gift, 1, Reward_times) of 
        false ->
            do_gain(ContractId, Role);
        {_, _, _, Expire} ->
            case Now > Expire of 
                true ->
                    do_gain(ContractId, Role);
                false ->
                    notice:alert(error, ConnPid, ?MSGID(<<"冒险契约未到期，还不能领取呢">>)),
                    {ok}
            end
    end;

%% 收取一个神秘来信
handle(12416, {MailId}, Role = #role{id = Rid, link = #link{conn_pid = ConnPid}, vip = Vip = #vip{mail_list = MailList}}) ->
    ?DEBUG(" --->>>> ~w, MailList: ~w", [MailId, MailList]),
    case lists:member(MailId, MailList) of
        false ->
            notice:alert(error, ConnPid, ?MSGID(<<"不存在此神秘来信">>)),
            sys_conn:pack_send(ConnPid, 12416, {0}),
            {ok};
        true ->
            case charge_data:get_discount_info(MailId) of
                false ->
                    notice:alert(error, ConnPid, ?MSGID(<<"收取失败">>)),
                    sys_conn:pack_send(ConnPid, 12416, {0}),
                    {ok};
                {Gold, {ItemBaseId, Num}} ->
                    case role_gain:do([#loss{label = gold, val = Gold}], Role) of
                        {ok, Role1} ->
                            sys_conn:pack_send(ConnPid, 12416, {1}),
                            Role2 = Role1#role{vip = Vip#vip{mail_list = MailList -- [MailId]}},
                            case role_gain:do([#gain{label = item, val = [ItemBaseId, 0, Num]}], Role2) of
                                {ok, Role3} ->
                                    notice:alert(succ, ConnPid, ?MSGID(<<"领取成功">>)),
                                    {ok, Role3};
                                _ ->
                                    award:send(Rid, 202001, [#gain{label = item, val = [ItemBaseId, 0, Num]}]),
                                    {ok, Role2}
                            end;
                        _ ->
                            notice:alert(error, ConnPid, ?MSGID(<<"晶钻不足">>)),
                            sys_conn:pack_send(ConnPid, 12416, {0}),
                            {ok}
                    end
            end
    end;

handle(_Cmd, _Data, _Role) -> %% 容错处理
    {error, unknow_command}.


do_gain(ContractId, Role = #role{id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}, vip = Vip = #vip{type = Lev, effect = Eff, reward_times = Reward_times}}) ->
    Now = util:unixtime(),
    case vip_data2:get_risk_gift_base(ContractId) of 
        {ok, #risk_gift_base{lev = GLev, time = Time, coin = Coin, effect = Effect}} ->
            case Lev >= GLev of 
                true ->
                    role:send_buff_begin(),
                    case role_gain:do([#loss{label = coin, val = Coin, msg = ?MSGID(<<"金币不足,无法领取噢">>)}], Role) of 
                        {_, #loss{msg = Msg}} ->
                            role:send_buff_clean(),
                            notice:alert(error, ConnPid, Msg),
                            {ok};
                        {false, Rea} ->
                            role:send_buff_clean(),
                            notice:alert(error, ConnPid, Rea),
                            {ok}; 
                        {ok, NRole} -> 
                            log:log(log_coin, {<<"vip领取冒险契约">>, <<"vip领取冒险契约">>, Role, NRole}),
                            case lists:keyfind(gift_id, 1, Effect) of 
                                {gift_id, RewardId} ->
                                    NewReward = Reward_times ++ [{risk_gift, ContractId, RewardId, Now + Time * 24 * 60 * 60}],
                                    NEff = Eff ++ lists:keydelete(gift_id, 1, Effect),
                                    award:send({Rid, SrvId}, RewardId),
                                    notice:alert(succ, ConnPid, ?MSGID(<<"恭喜你，领取成功">>)),
                                    role:send_buff_flush(),
                                    {reply, {Time}, NRole#role{vip = Vip#vip{effect = NEff, reward_times = NewReward}}};
                                false ->
                                    NEff = Eff ++ Effect,
                                    notice:alert(succ, ConnPid, ?MSGID(<<"恭喜你，领取成功">>)),
                                    role:send_buff_flush(),
                                    {reply, {Time}, NRole#role{vip = Vip#vip{effect = NEff}}}
                            end
                    end;
                false ->
                    notice:alert(error, ConnPid, ?MSGID(<<"Vip等级不足，还不能领取呢">>)),
                    {ok}
            end;
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok}
    end.
