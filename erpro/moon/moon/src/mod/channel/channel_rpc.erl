%% ****************************
%% 元神的rpc处理
%% @author wpf (wprehard@qq.com)
%% ****************************

-module(channel_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("channel.hrl").
%%
-include("assets.hrl").
-include("link.hrl").
-include("dungeon.hrl").

-define(channel_open_lvl, 20).

%% 查看其他角色元神列表
handle(12910, {Rid, SrvId}, #role{id = {Rid, SrvId}, channels = #channels{list = Channels}}) ->
    {reply, channel:pack_proto_msg(12910, Channels)};
handle(12910, {Rid, SrvId}, _) ->
    case role_api:c_lookup(by_id, {Rid, SrvId}, #role.channels) of
        {ok, _N, #channels{list = Channels}} ->
            {reply, channel:pack_proto_msg(12910, Channels)};
        _ -> {reply, {[]}}
    end;

%% 元神列表

%%handle(12900, {}, #role{lev = Lev}) when Lev < ?channel_open_lvl ->
%%    {ok};
handle(12900, {}, #role{channels = C}) ->
    Ret = channel:pack_proto_msg(12900, C),
    ?DEBUG("------->> 12900: ~p~n", [Ret]),
    {reply, Ret};

%% 限制
handle(_, _, #role{status = ?status_fight}) -> {ok};
handle(_, _, #role{status = ?status_die}) -> {ok};

%% 修炼
handle(12901, {ChannelId}, Role = #role{link=#link{conn_pid=ConnPid}, lev = Rlev, channels = Ch = #channels{cd_time = Cd, flag = Flag, list = Channels}}) ->
    case lists:keyfind(ChannelId, #role_channel.id, Channels) of
        false -> 
            {reply, {?false, ?MSGID(<<"神觉不存在">>)}};
        Rc = #role_channel{lev = Lev}  ->
            case channel_data:get(ChannelId, Lev + 1) of
                NextChannel=#channel{cost_time = Ct, cost_spirit = CostYb}->
                    case channel:check_can_practice(NextChannel, Ch, Rlev) of
                        {false, Reason} ->
                            {reply, {?false, Reason}};
                        true ->
                            case role_gain:do([#loss{label = stone, val = CostYb}], Role) of
                                {ok, Role1} ->
                                    SumCd = Ct + Cd,
                                    NewRc = Rc#role_channel{lev = Lev + 1},
                                    {ClientCd, Role3 = #role{channels = Ch1}} = 
                                        case ((Flag + 1) rem 5) =:= 0 of
                                            true ->
                                                case vip:channel_up(Role1) of
                                                    true ->
                                                        {0, Role1#role{channels = Ch#channels{cd_time = SumCd}}};
                                                    false ->
                                                        Role2 = role_timer:set_timer(channel, SumCd * 1000, {channel, practice_callback, []}, 1, Role1),
                                                        Now = util:unixtime(),
                                                        {SumCd, Role2#role{channels = Ch#channels{time = Now, cd_time = SumCd}}}
                                                end;
                                            false ->
                                                {0, Role1#role{channels = Ch#channels{cd_time = SumCd}}}
                                        end,

                                    Role4 = Role3#role{channels = Ch1#channels{flag = Flag + 1, list = lists:keyreplace(ChannelId, #role_channel.id, Channels, NewRc)}},
                                    Role5 = role_listener:special_event(Role4, {1004, finish}),
                                    rank:listener(soul, Role5), %% 排行榜更新
                                    % rank_celebrity:listener(channel_lev, Role5, {ChannelId, Lev + 1}), %% 全服称号
                                    % campaign_listener:handle(channel_lev, Role5, Lev + 1), %% 活动事件
                                    Role6 = role_api:push_attr(Role5),
                                    log:log(log_stone, {<<"神觉升级">>, <<"">>, Role, Role6}),
                                    %%log:log(log_channel, {up_over, NewRc, Role6}),
                                    log:log(log_channel, {up, NewRc, Role6}),
                                    manor_rpc:pack_send_19521(Role6),
                                    sys_conn:pack_send(ConnPid, 12901, {?true, ?MSGID(<<"神觉升级成功">>)}),
                                    sys_conn:pack_send(ConnPid, 12902, {ChannelId, Lev+1, ClientCd}),
                                    Role7 = medal:listener(divine2, Role6),

                                    random_award:divine(Role7, ChannelId, Lev+1),
                                    random_award:divine_2(Role7, Lev+1),

                                    rank_celebrity:divine_lev(Role7),
                                    Role8 = role_listener:special_event(Role7, {3012, 1}),  %%触发日常
                                    {ok, Role8};
                                {false, _Reason} ->
                                    {reply, {?false, ?MSGID(<<"符石不足，挑战困难副本可以获得符石">>)}}
                            end
                    end;
                false ->
                    {reply, {?false, ?MSGID(<<"该神觉已修炼至最高级">>)}}
            end
    end;


%% 加速
%% SpeedType: 加速时间类型
handle(12903, {}, Role) ->
    case channel:speed_up(Role) of
        {ok, Role1} ->
            manor_rpc:pack_send_19521(Role1),
            {reply, {?true, ?MSGID(<<"成功消除冷却时间">>)}, Role1};
        {false, Reason} ->
            {reply, {?false, Reason}} 
    end;

%% 神觉强化
handle(12904, {ChannelId, IsProtected, AutoBuy}, Role = #role{channels = C = #channels{list = Channels}}) ->
    case lists:keyfind(ChannelId, #role_channel.id, Channels) of
        false ->
            ?ELOG("角色[ID:~w]请求提升的元神不存在[Channel:~w]", [Role#role.id, ChannelId]),
            {reply, {?false, ?MSGID(<<"神觉数据错误">>), 0, 0}};
        #role_channel{lev = 0} -> 
            {reply, {?false, ?MSGID(<<"神觉还未升级">>), 0, 0}};
        Rc = #role_channel{state = State} ->
            {Rate, Coin} = channel_data:get_rate(State+1),
            LossList = channel:get_upgrade_loss(Role, AutoBuy, IsProtected) ++ [#loss{label = coin_all, val = Coin, msg = ?MSGID(<<"金币不足">>)}],
            role:send_buff_begin(),
            case role_gain:do(LossList, Role) of
                {false, _L = #loss{msg = Msg}} ->
                    role:send_buff_clean(),
                    {reply, {?false, Msg, ChannelId, State}}; 
                {ok, NR} ->
                    NR_0 = role_listener:special_event(NR, {3013, 1}),  %%触发日常
                    role:send_buff_flush(),
                    log:log(log_item_del_loss, {<<"元神提升">>, NR_0}),
                    log:log(log_coin, {<<"神觉强化">>, <<"消费5000">>, Role, NR_0}),
                    SeedRate = util:rand(1, 10000),
                    case SeedRate >= 1 andalso SeedRate =< Rate of
                        false ->
                            case IsProtected =:= 0 of
                                false ->
                                    log:log(log_channel_state, {upgrade_fail, IsProtected, Rc, Rc, Role}),
                                    {reply, {?false, ?MSGID(<<"强化失败，神觉受到保护没有下降">>), ChannelId, State}, NR_0};
                                true ->
                                    {NewState, _Msg} = case State > 0 of
                                        true -> {State-1, util:fbin(?L(<<"很可惜，提升失败，境界降为~w级">>), [State-1])};
                                        false -> {State, ?L(<<"提升失败，境界值不变">>)}
                                    end,
                                    NewRc = Rc#role_channel{state = NewState},
                                    NewRole = NR_0#role{channels = C#channels{list = lists:keyreplace(ChannelId, #role_channel.id, Channels, NewRc)}},
                                    rank:listener(soul, NewRole),
                                    log:log(log_channel_state, {upgrade_drop, IsProtected, Rc, NewRc, NewRole}),
                                    {reply, {?false, ?MSGID(<<"神觉强化失败，等级下降一级">>), ChannelId, State-1}, role_api:push_attr(NewRole)} %% 返回失败，且通知属性更新
                            end;
                        true -> %% 成功
                            NewState =  State + 1,
                            NewRc = Rc#role_channel{state = NewState},
                            NR1 = NR_0#role{channels = C#channels{list = lists:keyreplace(ChannelId, #role_channel.id, Channels, NewRc)}},
                            NewRole = role_listener:special_event(NR1, {20012, update}),
                            rank:listener(soul, NewRole),
                            rank_celebrity:listener(channel_step, Role, {ChannelId, erlang:round(NewState / 10)}), %% 元神境界改变
                            campaign_listener:handle(channel_step, Role, erlang:round(NewState / 10)), %% 元神境界提升 后台活动
                            %% channel:broad_msg(NewRole, ChannelId, State, NewState),
                            NewRole2 = role_listener:special_event(NewRole, {1018, finish}),
                            log:log(log_channel_state, {upgrade_suc, IsProtected, Rc, NewRc, NewRole}),
                            NewRole3 = role_listener:acc_event(NewRole2, {130, 1}), %%元神境界提升一级
                            Role4 = medal:listener(divine_3, NewRole3),
                            random_award:divine_str(Role4, ChannelId, NewState),
                            
                            rank_celebrity:divine_jd(Role4),
                            ?DEBUG("--After medal--"),                    
                            {reply, {?true, ?MSGID(<<"神觉强化成功">>), ChannelId, NewState}, role_api:push_attr(Role4)}
                    end
            end
    end;


%% 容错
handle(_, _, _Role) ->
    {error, unknow_command}.

