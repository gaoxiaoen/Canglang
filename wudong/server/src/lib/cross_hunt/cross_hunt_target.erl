%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2016 17:32
%%%-------------------------------------------------------------------
-module(cross_hunt_target).
-author("hxming").

-include("cross_hunt.hrl").
-include("server.hrl").
-include("common.hrl").
-include("team.hrl").
%% API
-compile(export_all).


%%初始化目标数据
init(Player) ->
    Pkey = Player#player.key,
    Now = util:unixtime(),
    Plv = Player#player.lv,
    StTarget =
        case player_util:is_new_role(Player) of
            true ->
                #ch_mb_target{pkey = Pkey, target = default_target(Plv), time = Now, is_change = 1};
            false ->
                case cross_hunt_load:load_target(Pkey) of
                    [] ->
                        #ch_mb_target{pkey = Pkey, target = default_target(Plv), time = Now, is_change = 1};
                    [Target, KillCount, Time] ->
                        NewTarget = format_target(Plv, Target),
                        case util:is_same_date(Time, Now) of
                            true ->
                                #ch_mb_target{pkey = Pkey, target = NewTarget, kill_count = util:bitstring_to_term(KillCount), time = Time};
                            false ->
                                %%隔天数据处理
                                TargetList = update_target(NewTarget, Plv),
                                #ch_mb_target{pkey = Pkey, target = TargetList, time = Now, is_change = 1}
                        end

                end
        end,
    set_target(StTarget),
    Player.

%%初始化数据
format_target(Plv, Target) ->
    F = fun(Data) ->
        case Data of
            {_, GoodsId, Num, Cur, RewardId, IsReward, _Mid} ->
                [#h_target{goods_id = GoodsId, num = Num, cur = Cur, reward_id = RewardId, is_reward = IsReward}];
            {GoodsId, Num, Cur, RewardId, IsReward} ->
                [#h_target{goods_id = GoodsId, num = Num, cur = Cur, reward_id = RewardId, is_reward = IsReward}];
            _ -> []
        end
        end,
    case lists:flatmap(F, util:bitstring_to_term(Target)) of
        [] ->
            default_target(Plv);
        Data -> Data
    end.

pack_target(Target) ->
    F = fun(T) ->
        {T#h_target.goods_id, T#h_target.num, T#h_target.cur, T#h_target.reward_id, T#h_target.is_reward}
        end,
    lists:map(F, Target).

%%默认数据
default_target(Plv) ->
    case data_cross_hunt_target:get(Plv) of
        [] ->
            [];
        List ->
            F = fun({GoodsId, Num, RewardId}) ->
                #h_target{
                    goods_id = GoodsId,
                    num = Num,
                    reward_id = RewardId
                }
                end,
            lists:map(F, List)
    end.

cmd_reset(Player) ->
    StTarget = #ch_mb_target{pkey = Player#player.key, target = default_target(Player#player.lv), time = util:unixtime(), is_change = 1},
    set_target(StTarget),
    ok.


%%更新目标
update_target(OldTargetList, Plv) ->
    F = fun(Target) ->
        case lists:keyfind(Target#h_target.goods_id, #h_target.goods_id, OldTargetList) of
            false ->
                Target;
            Old ->
                %%之前未完成的目标保留
                if Old#h_target.is_reward == ?CH_TARGET_ST_REWARD ->
                    Target;
                    true ->
                        Old
                end
        end
        end,
    lists:map(F, default_target(Plv)).

%%定时更新
timer_update() ->
    StTarget = get_target(),
    if StTarget#ch_mb_target.is_change == 1 ->
        set_target(StTarget#ch_mb_target{is_change = 0}),
        cross_hunt_load:replace_target(StTarget);
        true ->
            ok
    end.

%%离线
logout() ->
    StTarget = get_target(),
    if StTarget#ch_mb_target.is_change == 1 ->
        cross_hunt_load:replace_target(StTarget);
        true ->
            ok
    end.


get_target() ->
    lib_dict:get(?PROC_STATUS_CROSS_HUNT).

set_target(HTarget) ->
    lib_dict:put(?PROC_STATUS_CROSS_HUNT, HTarget).

%%检查目标信息
check_target(Sid) ->
    Target = get_target(),
    Bin = to_bin(Target),
    server_send:send_to_sid(Sid, Bin),
    ok.

to_bin(Target) ->
    F = fun(T) ->
        case ets:lookup(?ETS_CROSS_HUNT_MON, T#h_target.goods_id) of
            [] -> [];
            [Record] ->
                [[
                    Record#base_hunt_target.mid,
                    T#h_target.goods_id,
                    T#h_target.num,
                    T#h_target.cur,
                    T#h_target.is_reward
                ]]
        end
        end,
    Data =
        lists:flatmap(F, Target#ch_mb_target.target),
    {ok, Bin} = pt_620:write(62004, {Data}),
    Bin.

%%怪物掉落
check_mon_die(Mb, GoodsId) ->
    HTarget = Mb#cross_hunt_mb.target,
    case lists:keyfind(GoodsId, #h_target.goods_id, HTarget#ch_mb_target.target) of
        false ->
            Mb;
        Target ->
            if Target#h_target.cur >= Target#h_target.num -> Mb;
                true ->
                    NewTarget = Target#h_target{cur = Target#h_target.cur + 1},
                    TargetList = lists:keyreplace(GoodsId, #h_target.goods_id, HTarget#ch_mb_target.target, NewTarget),
                    NewHTarget = HTarget#ch_mb_target{target = TargetList},
                    server_send:send_node_pid(Mb#cross_hunt_mb.node, Mb#cross_hunt_mb.pid, {cross_hunt_get, GoodsId, HTarget#ch_mb_target.kill_count}),
                    Mb#cross_hunt_mb{target = NewHTarget}
            end
    end.

%%更新个人猎场物品信息
cross_hunt_get(Player, GoodsId, KillCount) ->
    HTarget = get_target(),
    case lists:keyfind(GoodsId, #h_target.goods_id, HTarget#ch_mb_target.target) of
        false ->
            Player;
        Target ->
            if Target#h_target.cur >= Target#h_target.num -> Player;
                true ->
                    Cur = Target#h_target.cur + 1,
                    NewTarget =
                        if Cur >= Target#h_target.num ->
                            Target#h_target{cur = Cur, is_reward = ?CH_TARGET_ST_REWARD};
                            true ->
                                Target#h_target{cur = Cur}
                        end,
                    TargetList = lists:keyreplace(GoodsId, #h_target.goods_id, HTarget#ch_mb_target.target, NewTarget),
                    NewHTarget = HTarget#ch_mb_target{target = TargetList, is_change = 1, kill_count = KillCount},
                    set_target(NewHTarget),
                    server_send:send_to_sid(Player#player.sid, to_bin(NewHTarget)),
                    ?IF_ELSE(NewTarget#h_target.is_reward == ?CH_TARGET_ST_REWARD, hunt_reward(Player, GoodsId, Target#h_target.reward_id), Player)
            end
    end.

%%猎场奖励
hunt_reward(Player, GoodsId, RewardId) ->
    case data_cross_hunt_reward:get(RewardId) of
        [] ->
            ?ERR("goods ~p rewardid undef ~p~n", [GoodsId, RewardId]),
            Player;
        GoodsList ->
            {ok, Bin} = pt_620:write(62008, {1, [tuple_to_list(T) || T <- GoodsList]}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(71, GoodsList)),
            cross_hunt_load:log_cross_hunt_reward(Player#player.key, Player#player.nickname, GoodsId, GoodsList),
            NewPlayer
    end.

%%击杀玩家,检查掉落
check_role_die(Pdict, Pkey, AttKey) ->
    case dict:is_key(AttKey, Pdict) of
        false -> Pdict;
        true ->
            case dict:is_key(Pkey, Pdict) of
                false -> Pdict;
                true ->
                    AttMb = dict:fetch(AttKey, Pdict),
                    AttHTarget = AttMb#cross_hunt_mb.target,
                    {Kill, KillCount} =
                        case lists:keyfind(Pkey, 1, AttHTarget#ch_mb_target.kill_count) of
                            false ->
                                {0, [{Pkey, 1} | AttHTarget#ch_mb_target.kill_count]};
                            {_, Count} ->
                                {Count, lists:keyreplace(Pkey, 1, AttHTarget#ch_mb_target.kill_count, {Pkey, Count + 1})}
                        end,
                    if Kill >= ?MAX_CROSS_HUNT_KILL -> Pdict;
                        true ->
                            %%查询是否有需要抢的物品
                            F = fun(Target) ->
                                CanRob = data_cross_hunt_mon:can_rob(Target#h_target.goods_id),
                                if Target#h_target.is_reward == ?CH_TARGET_ST_UNFINISH andalso CanRob == 1 ->
                                    [Target#h_target.goods_id];
                                    true -> []
                                end
                                end,
                            case lists:flatmap(F, AttHTarget#ch_mb_target.target) of
                                [] -> Pdict;
                                GoodsIds ->
                                    DieMb = dict:fetch(Pkey, Pdict),
                                    case die_drop(Pdict, DieMb, GoodsIds, AttMb#cross_hunt_mb.nickname) of
                                        false ->
                                            Pdict;
                                        {GoodsId, Dict} ->
                                            case lists:keyfind(GoodsId, #h_target.goods_id, AttHTarget#ch_mb_target.target) of
                                                false ->
                                                    Pdict;
                                                Find ->
                                                    NewFind = Find#h_target{cur = Find#h_target.cur + 1},
                                                    TargetList = lists:keyreplace(GoodsId, #h_target.goods_id, AttHTarget#ch_mb_target.target, NewFind),
                                                    NewAttHTarget = AttHTarget#ch_mb_target{target = TargetList, kill_count = KillCount},
                                                    NewAttMb = AttMb#cross_hunt_mb{target = NewAttHTarget},
                                                    server_send:send_node_pid(AttMb#cross_hunt_mb.node, AttMb#cross_hunt_mb.pid, {cross_hunt_get, GoodsId, KillCount}),
                                                    dict:store(AttKey, NewAttMb, Dict)
                                            end
                                    end
                            end
                    end
            end
    end.


%%被击杀玩家掉落
die_drop(Dict, Mb, GoodsIds, NickName) ->
    HTarget = Mb#cross_hunt_mb.target,
    F = fun(GoodsId) ->
        case lists:keyfind(GoodsId, #h_target.goods_id, HTarget#ch_mb_target.target) of
            false -> [];
            Target ->
                if Target#h_target.cur < Target#h_target.num andalso Target#h_target.cur > 0 ->
                    [Target#h_target{cur = Target#h_target.cur - 1}];
                    true -> []
                end
        end
        end,
    case lists:flatmap(F, GoodsIds) of
        [] -> false;
        List ->
            Fetch = util:list_rand(List),
            TargetList = lists:keyreplace(Fetch#h_target.goods_id, #h_target.goods_id, HTarget#ch_mb_target.target, Fetch),
            NewHTarget = HTarget#ch_mb_target{target = TargetList},
            NewMb = Mb#cross_hunt_mb{target = NewHTarget},
            server_send:send_node_pid(Mb#cross_hunt_mb.node, Mb#cross_hunt_mb.pid, {cross_hunt_lose, Fetch#h_target.goods_id, NickName}),
            {Fetch#h_target.goods_id, dict:store(Mb#cross_hunt_mb.pkey, NewMb, Dict)}
    end.

%%猎场死亡损失物品
cross_hunt_lose(Player, GoodsId, _Name) ->
    HTarget = get_target(),
    case lists:keyfind(GoodsId, #h_target.goods_id, HTarget#ch_mb_target.target) of
        false -> skip;
        Target ->
            NewTarget = Target#h_target{cur = Target#h_target.cur - 1},
            TargetList = lists:keyreplace(Target#h_target.goods_id, #h_target.goods_id, HTarget#ch_mb_target.target, NewTarget),
            NewHTarget = HTarget#ch_mb_target{target = TargetList, is_change = 1},
            server_send:send_to_sid(Player#player.sid, to_bin(NewHTarget)),
            set_target(NewHTarget),
            ok
    end.


%%退出活动结果
target_ret_to_client(Dict) ->
    F = fun({_, Mb}) ->
        Data = reward_list(Mb#cross_hunt_mb.target),
        {ok, Bin} = pt_620:write(62009, {0, Data}),
        server_send:send_to_sid(Mb#cross_hunt_mb.node,Mb#cross_hunt_mb.sid,Bin)
%%        center:apply(Mb#cross_hunt_mb.node, server_send, send_to_sid, [Mb#cross_hunt_mb.sid, Bin])
        end,
    lists:foreach(F, dict:to_list(Dict)),

    ok.

reward_list(HTarget) ->
    F = fun(Target) ->
        if Target#h_target.is_reward == ?CH_TARGET_ST_REWARD ->
            data_cross_hunt_reward:get(Target#h_target.reward_id);
            true -> []
        end
        end,
    GoodsList = lists:flatmap(F, HTarget#ch_mb_target.target),
    F1 = fun({Gid, Num}, L) ->
        case lists:keyfind(Gid, 1, L) of
            false ->
                [{Gid, Num} | L];
            {_, Count} ->
                lists:keyreplace(Gid, 1, L, {Gid, Num + Count})
        end
         end,
    NewGoodsList = lists:foldl(F1, [], GoodsList),
    [tuple_to_list(T) || T <- NewGoodsList].

%%队伍共享
check_team_share(Pkey, GoodsId) ->
%%        %%组队共享
    case team_util:get_team_mb(Pkey) of
        false -> skip;
        Mb ->
            MbList = team_util:get_team_mbs(Mb#t_mb.team_key),
            F = fun(M) ->
                if M#t_mb.is_online /= 1 orelse M#t_mb.pkey == Pkey -> skip;
                    true ->
                        cross_area:apply(cross_hunt, check_share, [M#t_mb.pkey, GoodsId])
                end
                end,
            lists:foreach(F, MbList)

    end.
