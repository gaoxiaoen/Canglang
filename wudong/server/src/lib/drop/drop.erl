%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 通用掉落逻辑
%%% @end
%%% Created : 20. 一月 2015 下午7:37
%%%-------------------------------------------------------------------
-module(drop).
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("drop.hrl").
-include("goods.hrl").
-include("task.hrl").
-include("battle.hrl").
-include("dungeon.hrl").
-include("battle.hrl").
-include("cross_hunt.hrl").
-include("daily.hrl").
-include("achieve.hrl").
-include("cross_boss.hrl").
-export([drop/3
    , drop/4
    , mon_drop/4
    , hunt_boss_drop/4
    , do_drop_pool/13
    , drop_goods/7
    , pickup/7
    , get_goods_from_drop_pool/3
    , get_goods_from_drop_rule/2
    , cmd_drop/2
    , drop_to_scene/10
]).
-export([cmd/0]).


%%怪物掉落
mon_drop(Mon, _Klist, _TotalHurt, _Attacker) when Mon#mon.shadow_key /= 0 ->
    skip;
%%世界boss掉落
mon_drop(Mon, _Klist, _TotalHurt, _Attacker) when Mon#mon.boss == ?BOSS_TYPE_HUNT ->
    skip;
mon_drop(Mon, Klist, _TotalHurt, Attacker) when Mon#mon.boss == ?BOSS_TYPE_FIELD ->
    Node = node(),
    kill_event(Mon#mon.mid, Mon#mon.lv, Klist, Node, Mon#mon.scene, Mon#mon.copy),
    %%成就
    achieve:trigger_achieve(Attacker#attacker.key, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3006, 0, 1),
    F1 = fun(#st_hatred{key = Key, hurt = Hurt} = _Hatred) ->
        achieve:trigger_achieve(Key, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3004, 0, 1),
        achieve:trigger_achieve(Key, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3007, 0, Hurt)
         end,
    lists:foreach(F1, Klist),
    ok;
%%野外boss掉落
mon_drop(Mon, Klist, TotalHurt, _Attacker) when Mon#mon.boss == ?BOSS_TYPE_ELITE orelse Mon#mon.boss == ?BOSS_ACT_FESTIVE ->
    Node = node(),
    kill_event(Mon#mon.mid, Mon#mon.lv, Klist, Node, Mon#mon.scene, Mon#mon.copy),
    BossIdList = data_field_elite:ids()++data_elite_boss:get_all_boss_id(),
    case lists:member(Mon#mon.mid, util:list_filter_repeat(BossIdList)) of
        false -> ok;
        true ->
            IsEliteCrossScene = scene:is_cross_elite_boss_scene(Mon#mon.scene),
            F1 = fun(#st_hatred{key = Key, node = Node0} = _Hatred) ->
                case IsEliteCrossScene of
                    true ->
                        center:apply(Node0, achieve, trigger_achieve, [Key, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3005, 0, 1]);
                    false ->
                        achieve:trigger_achieve(Key, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3005, 0, 1)
                end
            end,
            lists:foreach(F1, Klist)
    end,
    do_mon_drop(Mon, Klist, TotalHurt, _Attacker),
    ok;

%%普通怪物掉落
mon_drop(Mon, Klist, TotalHurt, _Attacker) when Mon#mon.scene == ?SCENE_ID_CROSS_BOSS_ONE orelse Mon#mon.scene == ?SCENE_ID_CROSS_BOSS_TWO orelse Mon#mon.scene == ?SCENE_ID_CROSS_BOSS_THREE orelse Mon#mon.scene == ?SCENE_ID_CROSS_BOSS_FOUR orelse Mon#mon.scene == ?SCENE_ID_CROSS_BOSS_FIVE ->
    case data_cross_boss:get(Mon#mon.mid) of
        [] ->
            do_mon_drop(Mon, Klist, TotalHurt, _Attacker);
        #base_cross_boss{type = Type} ->
            case Type of
                2 -> %% mon
                    do_mon_drop(Mon, Klist, TotalHurt, _Attacker);
                1 -> %% boss
                    Pkey = ?CALL(cross_boss_proc:get_server_pid(), {get_drop_has_key, Mon#mon.mid}),
                    F = fun(#st_hatred{key = Key}) ->
                        Key == Pkey
                    end,
                    NewKlill = lists:filter(F, Klist),
                    do_mon_drop(Mon, NewKlill, TotalHurt, _Attacker)
            end
    end;

%%普通怪物掉落
mon_drop(Mon, Klist, TotalHurt, _Attacker) ->
    do_mon_drop(Mon, Klist, TotalHurt, _Attacker).

do_mon_drop(Mon, Klist, TotalHurt, _Attacker) ->
    Scene = Mon#mon.scene,
    Copy = Mon#mon.copy,
    X = Mon#mon.x,
    Y = Mon#mon.y,
    IsAct = act_double:get_mon_drop_act(),
    DropRuleList = ?IF_ELSE(IsAct == 0, [Mon#mon.drop_rule], [Mon#mon.drop_rule, Mon#mon.act_drop_rule]),
    SortKlist = mon_util:sort_klist(Klist), %%伤害倒序
    OrderKlist = lists:reverse(Klist),   %%出手顺序
    DropItem = Mon#mon.drop_item,
    Node = node(),
    kill_event(Mon#mon.mid, Mon#mon.lv, SortKlist, Node, Mon#mon.scene, Mon#mon.copy),
    DropMonInfo = drop_mon_info(Mon),
    if
        DropRuleList /= [] orelse DropItem /= [] ->
            scene_share_drop(Mon, DropRuleList, Klist),
            Klen = length(Klist),
            F = fun(Hatred, Rank) ->
                #st_hatred{key = _Key, pid = Pid, team_pid = TeamPid, hurt = Hurt, node = SelfNode} = Hatred,
                HurtPerc = Hurt / ?IF_ELSE(TotalHurt == 0, 1, TotalHurt),
                Order0 = util:get_list_elem_index(Hatred, OrderKlist),
                Order = ?IF_ELSE(Order0 == Klen, 0, Order0),
                DropInfo = #drop_info{perc = HurtPerc, rank = Rank, order = Order, hurt = Hurt, total_hurt = TotalHurt, scene = Scene, copy = Copy, x = X, y = Y,
                    drop_item = DropItem, mon = DropMonInfo},
                case is_pid(TeamPid) of
                    true ->
                        server_send:send_node_pid(SelfNode, TeamPid, {drop, DropRuleList, DropInfo});
                    false ->
                        server_send:send_node_pid(SelfNode, Pid, {drop, DropRuleList, DropInfo})
                end,
                Rank + 1
                end,
            lists:foldl(F, 1, SortKlist);
        true ->
            ok
    end.

hunt_boss_drop(Mon, DamageList, _Attacker, CopyList) ->
    Scene = Mon#mon.scene,
    X = Mon#mon.x,
    Y = Mon#mon.y,
    DropRule = Mon#mon.drop_rule,
    DropItem = Mon#mon.drop_item,
    DropMonInfo = drop_mon_info(Mon),
    if
        DropRule > 0 orelse DropItem /= [] ->
            Klist = [#st_hatred{key = Damage#ch_boss_damage.pkey} || Damage <- DamageList],
            [scene_share_drop(Mon#mon{copy = Copy}, [Mon#mon.drop_rule], Klist) || Copy <- CopyList],
            TotalHurt = lists:sum([D#ch_boss_damage.damage || D <- DamageList]),
            %%伤害排名奖励
            F = fun(Damage) ->
                HurtPerc = Damage#ch_boss_damage.damage / TotalHurt,
                DropInfo = #drop_info{perc = HurtPerc, rank = Damage#ch_boss_damage.rank, order = -1, hurt = Damage#ch_boss_damage.damage, total_hurt = TotalHurt, scene = Scene, copy = 0, x = X, y = Y,
                    drop_item = DropItem, mon = DropMonInfo},
                case Damage#ch_boss_damage.pid of
                    0 ->
                        GoodsList = get_goods_from_drop_rule(DropRule, DropInfo#drop_info{lvup = Damage#ch_boss_damage.lv, lvdown = Damage#ch_boss_damage.lv, career = Damage#ch_boss_damage.career}),
                        case goods:make_give_goods_list(64, GoodsList) of
                            [] -> skip;
                            NewGoodsList ->
                                center:apply(Damage#ch_boss_damage.node, cross_hunt, boss_mail, [Damage#ch_boss_damage.pkey, NewGoodsList])
                        end;
                    _Pid ->
                        server_send:send_node_pid(Damage#ch_boss_damage.node, Damage#ch_boss_damage.pid, {drop, DropRule, DropInfo})
                end
                end,
            lists:foreach(F, DamageList),
            ok;
        true ->
            ok
    end,
    ok.

%%怪物死亡,经验/任务共享处理
kill_event(_Mid, _Mlv, _Klist, _Node, Scene, _Copy) when Scene == ?SCENE_ID_CROSS_WAR ->
    skip;

kill_event(Mid, Mlv, Klist, Node, Scene, Copy) ->
    Damage = lists:sum([H#st_hatred.hurt || H <- Klist]),
    F = fun(Hatred) ->
        if Hatred#st_hatred.sign == ?SIGN_MON -> ok;
            Hatred#st_hatred.node == none orelse Hatred#st_hatred.node == Node ->
                Hatred#st_hatred.pid ! {kill_mon_exp, Mid, Mlv, Hatred#st_hatred.hurt / Damage},
                case is_pid(Hatred#st_hatred.team_pid) of
                    false ->
                            catch Hatred#st_hatred.pid ! {task_event, [?TASK_ACT_KILL, Mid]};
                    true ->
                        %%队伍共享杀怪
                            catch Hatred#st_hatred.team_pid ! {task_event_kill, [Mid, Scene, Copy]}
                end;
            true ->
                if
                    Damage == 0 -> skip;
                    true ->
                        server_send:send_node_pid(Hatred#st_hatred.node, Hatred#st_hatred.pid, {kill_mon_exp, Mid, Mlv, Hatred#st_hatred.hurt / Damage})
                end,
                server_send:send_node_pid(Hatred#st_hatred.node, Hatred#st_hatred.pid, {task_event, [?TASK_ACT_KILL, Mid]})
        end
        end,
    lists:foreach(F, Klist).

%%掉落物品的怪物信息
drop_mon_info(Mon) ->
    #drop_mon_info{
        mon_id = Mon#mon.mid,
        mon_kind = Mon#mon.kind,
        mon_name = Mon#mon.name,
        mon_boss = Mon#mon.boss,
        owner_key = Mon#mon.owner_key,
        sid = Mon#mon.scene,
        x = Mon#mon.x,
        y = Mon#mon.y,
        lv = Mon#mon.lv
    }.


%%场景共享掉落
scene_share_drop(Mon, DropRuleList, Klist) ->
    DropInfoList0 = get_goods_for_scene_share(DropRuleList),
    DropInfoList = get_goods_for_cross_scene(Mon, DropInfoList0, Klist),
    AreaList = scene:get_drop_area_list(Mon#mon.scene, Mon#mon.mid, Mon#mon.x, Mon#mon.y),
    F = fun(GiveGoods, {[{X, Y} | AList], GoodsList}) ->
        Pkeys =
            if Mon#mon.boss == ?BOSS_TYPE_HUNT orelse Mon#mon.boss == ?BOSS_TYPE_FIELD ->
                [T#st_hatred.key || T <- Klist];
                GiveGoods#give_goods.share == 1 ->
                    [T#st_hatred.key || T <- Klist];
                true -> []
            end,
        ?DO_IF(GiveGoods#give_goods.goods_id > 0, drop_to_scene(0, GiveGoods, 1, Mon#mon.scene, Mon#mon.copy, X, Y, Pkeys, none, Mon#mon.mid)),
        NewGoodsList = [{GiveGoods#give_goods.goods_id, GiveGoods#give_goods.num} | GoodsList],
        {AList ++ [{X, Y}], NewGoodsList}
        end,
    {_, DropGoodsList} = lists:foldl(F, {AreaList, []}, DropInfoList),
    scene_drop_msg(Mon#mon.boss, Mon#mon.name, Mon#mon.scene, goods:merge_goods(DropGoodsList)).


scene_drop_msg(_Type, _Mid, _SceneId, _GoodsList) ->
    ok.

get_goods_for_cross_scene(Mon, DropInfoList, Klist) ->
    case scene:is_cross_boss_scene(Mon#mon.scene) of
        false -> DropInfoList;
        true ->
            F = fun(GiveGoods) ->
                case lists:keyfind(start_recv_time, 1, GiveGoods#give_goods.args) of
                    false ->
                        GiveGoods;
                    {_, StartRecvTime} ->
                        if
                            Klist == [] ->
                                case Mon#mon.scene == ?SCENE_ID_CROSS_BOSS_ONE orelse Mon#mon.scene == ?SCENE_ID_CROSS_BOSS_TWO of
                                    true ->
                                        GiveGoods#give_goods{
                                            args = [{drop_pickup_limit_lv, Mon#mon.lv + 30} | GiveGoods#give_goods.args]
                                        };
                                    false ->
                                        GiveGoods
                                end;
                            true ->
                                StHatred = hd(Klist),
                                case Mon#mon.scene == ?SCENE_ID_CROSS_BOSS_ONE orelse Mon#mon.scene == ?SCENE_ID_CROSS_BOSS_TWO of
                                    true -> %% 掉落拾取等级限制
                                        GiveGoods#give_goods{
                                            args = [{drop_pickup_limit_lv, Mon#mon.lv + 30}, {drop_has_pkey, StHatred#st_hatred.key, util:unixtime() + StartRecvTime}, {drop_pickup_time, util:unixtime() + 60} | GiveGoods#give_goods.args]
                                        };
                                    false ->
                                        GiveGoods#give_goods{
                                            args = [{drop_has_pkey, StHatred#st_hatred.key, util:unixtime() + StartRecvTime}, {drop_pickup_time, util:unixtime() + 60} | GiveGoods#give_goods.args]
                                        }
                                end
                        end
                end
            end,
            lists:map(F, DropInfoList)
    end.


%% 根据规则掉落
%%player 玩家记录
%%dropid 掉落id
%%from  触发掉落途径
%%MyDropInfo #drop_info{} 怪物掉落时附带的掉落信息,其他掉落途径可选
drop(Player, DropID, From) ->
    #player{career = Career, lv = Lv} = Player,
    MyDropInfo = #drop_info{career = Career, lvdown = Lv, lvup = Lv, num = 1, x = Player#player.x, y = Player#player.y},
    drop(Player, [DropID], From, MyDropInfo).

drop(Player, DropRuleList, From, MyDropInfo) ->
    %%固定掉落
    Player2 = do_drop_item(Player, MyDropInfo#drop_info.mon#drop_mon_info.mon_id, MyDropInfo#drop_info.drop_item, From, MyDropInfo#drop_info.x, MyDropInfo#drop_info.y, MyDropInfo#drop_info.mon#drop_mon_info.mon_kind),
    %%任务掉落
    [drop_task(DropId1) || DropId1 <- DropRuleList],
    %%根据掉落规则的随机掉落
    F = fun(DropId) -> drop_filter(DropId, MyDropInfo) end,
    DropInfoList = lists:flatmap(F, DropRuleList),
    AreaList = scene:get_drop_area_list(Player#player.scene, MyDropInfo#drop_info.mon#drop_mon_info.mon_id, MyDropInfo#drop_info.x, MyDropInfo#drop_info.y),
    F2 = fun(DropInfo, {PlayerX, [{Dx, Dy} | Alist]}) ->
        %%单服掉落计数
        PlayerXX = do_drop_pool(PlayerX, MyDropInfo#drop_info.mon#drop_mon_info.mon_id, DropInfo#drop_info.poolid, DropInfo#drop_info.num, DropInfo#drop_info.bind, From, DropInfo#drop_info.where, DropInfo#drop_info.share, Dx, Dy, MyDropInfo#drop_info.mon, MyDropInfo#drop_info.rank, MyDropInfo#drop_info.scene),
        {PlayerXX, Alist ++ [{Dx, Dy}]}
         end,
    {Player3, _} = lists:foldl(F2, {Player2, AreaList}, DropInfoList),
    Player3.

%%掉落规则过滤
drop_filter(DropId, MyDropInfo) ->
    DropRule = data_drop_rule:get(DropId),
    DropInfoList1 = parse_rule_career(DropRule#drop_rule.career, []),
    DropInfoList2 = parse_rule_lv(DropRule#drop_rule.lv, []),
    DropInfoList3 = parse_rule_rank(DropRule#drop_rule.hurtrank, []),
    DropInfoList4 = parse_rule_order(DropRule#drop_rule.hurtorder, []),
    DropInfoList5 = parse_rule_perc(DropRule#drop_rule.hurtperc, []),
    F = fun({Type, DropList}) ->
        do_drop_filter(Type, DropList, MyDropInfo)
        end,
    lists:flatmap(F, [{career, DropInfoList1}, {lv, DropInfoList2}, {rank, DropInfoList3}, {order, DropInfoList4}, {perc, DropInfoList5}]).


do_drop_filter(career, DropList, MyDropInfo) ->
    lists:filter(fun(DropInfo) ->
        DropInfo#drop_info.career =:= 0 orelse (DropInfo#drop_info.career > 0 andalso DropInfo#drop_info.career =:= MyDropInfo#drop_info.career) end, DropList);
do_drop_filter(lv, DropList, MyDropInfo) ->
    lists:filter(fun(DropInfo) ->
        (DropInfo#drop_info.lvdown > 0 orelse DropInfo#drop_info.lvup > 0) andalso
            DropInfo#drop_info.lvdown =< MyDropInfo#drop_info.lvdown andalso DropInfo#drop_info.lvup >= MyDropInfo#drop_info.lvup end, DropList);
do_drop_filter(order, DropList, MyDropInfo) ->
    lists:filter(fun(DropInfo) ->
        DropInfo#drop_info.order >= 0 andalso DropInfo#drop_info.order =:= MyDropInfo#drop_info.order end, DropList);
do_drop_filter(rank, DropList, MyDropInfo) ->
    lists:filter(fun(DropInfo) ->
        DropInfo#drop_info.rank > 0 andalso DropInfo#drop_info.rank =:= MyDropInfo#drop_info.rank end, DropList);
do_drop_filter(perc, DropList, MyDropInfo) ->
    lists:filter(fun(DropInfo) ->
        DropInfo#drop_info.perc > 0 andalso DropInfo#drop_info.perc < MyDropInfo#drop_info.perc end, DropList);
do_drop_filter(_, _DropList, _MyDropInfo) -> false.


%%任务掉落
drop_task(DropId) ->
    DropRule = data_drop_rule:get(DropId),
    DropInfoList = parse_rule_task(DropRule#drop_rule.task, []),
    F = fun(DropInfo) ->
        GoodsList = get_goods_from_drop_pool(DropInfo#drop_info.poolid, DropInfo#drop_info.num, DropInfo#drop_info.bind),
        [task_event:event(?TASK_ACT_GOODS, {Goods#goods.goods_id, Goods#goods.num}) || Goods <- GoodsList]
        end,
    lists:foreach(F, DropInfoList).

%%直接掉落 [根据掉落包]
%%Player 玩家记录
%%Poolid 掉落包id
%%DropNum 掉落的数量
%%Bind 绑定状态
%%from   掉落来源
%%where  0进包1掉地上
%%share  是否共享
%% Dropx Dropy 掉落坐标
%%scene 掉落的场景
do_drop_pool(Player, Mid, PoolID, DropNum, Bind, From, Where, Share, DropX, DropY, DropMonInfo, Rank, _Scene) ->
    DropPoolList = data_drop_pool:get(PoolID),
    F1 = fun(_Times, {Player1, DPList, Glist}) ->
        F = fun(DropPool, N) ->
            Ratio = DropPool#drop_pool.ratio,
            {DropPool#drop_pool{ratio_st = N, ratio_et = Ratio + N}, Ratio + N}
            end,
        {DPList1, Total} = lists:mapfoldl(F, 0, DPList),
        R = util:rand(1, Total),
        case fetch_pool(DPList1, R) of
            [] ->
                {Player1, DPList, Glist};
            DropPool ->
                if DropPool#drop_pool.goodstype == 0 ->
                    {Player1, DPList, Glist};
                    true ->
                        GiveGoods = #give_goods{
                            goods_id = DropPool#drop_pool.goodstype,
                            num = DropPool#drop_pool.num,
                            bind = Bind,
                            from = From
                        },
                        Player2 = drop_goods(Player, Mid, GiveGoods, Where, Share, DropX, DropY),
                        DPList2 = ?IF_ELSE(DropPool#drop_pool.type == 0, DPList1, lists:delete(DropPool, DPList1)),
                        %%掉落统计
                        case lists:member(DropPool#drop_pool.goodstype, data_drop_limit:get_unlimited(Player#player.lv)) of
                            false ->
                                ?DO_IF(DropMonInfo#drop_mon_info.mon_kind /= ?MON_KIND_GRACE_COLLECT, daily:increment(?DAILY_DROP_LIMIT, 1));
                            true -> ok
                        end,
                        {Player2, DPList2, [{DropPool#drop_pool.goodstype, DropPool#drop_pool.num} | Glist]}
                end
        end
         end,
    {NewPlayer, _, GoodsList} = lists:foldl(F1, {Player, DropPoolList, []}, lists:seq(1, DropNum)),
    if
        DropMonInfo#drop_mon_info.mon_boss == ?BOSS_TYPE_FIELD orelse DropMonInfo#drop_mon_info.mon_kind == ?MON_KIND_FIELD_BOSS_BOX ->
            field_boss:log_field_boss(Player#player.key, Player#player.nickname, DropMonInfo#drop_mon_info.mon_id, Rank, GoodsList);
        true -> skip
    end,
    NewPlayer.


%%直接掉落 [根据固定掉落]
%% player 玩家记录
%% DropItem [{goodstype,num,bind,where}|L]
%% from 掉落来源
do_drop_item(Player, Mid, DropItem, From, DropX, DropY, MonKind) ->
    %%固定掉落
    Fix = fun({GoodsType, GoodsNum, Bind, Where, Share}, Playerx) ->
        %%掉落统计
        case lists:member(GoodsType, data_drop_limit:get_unlimited(Player#player.lv)) of
            false ->
                ?DO_IF(MonKind /= ?MON_KIND_GRACE_COLLECT, daily:increment(?DAILY_DROP_LIMIT, 1));
            true -> ok
        end,
        GiveGoods = #give_goods{goods_id = GoodsType, num = GoodsNum, bind = Bind, from = From},
        drop_goods(Playerx, Mid, GiveGoods, Where, Share, DropX, DropY)
          end,
    lists:foldl(Fix, Player, DropItem).

%%拾取物品
pickup(Player, Mid, GoodsType, GoodsNum, Bind0, From, Args) ->
    Bind = ?IF_ELSE(Bind0 == 0 andalso Player#player.drop_bind == 1, 1, Bind0),
    GiveGoods = #give_goods{goods_id = GoodsType, num = GoodsNum, bind = Bind, args = Args, from = From},
    drop_goods(Player, Mid, GiveGoods, 1, 0, Player#player.x, Player#player.y).

%%掉落物品
drop_goods(Player, Mid, GiveGoods, Where, Share, DropX, DropY) ->
    Bind = ?IF_ELSE(GiveGoods#give_goods.bind == 0 andalso Player#player.drop_bind == 1, 1, GiveGoods#give_goods.bind),
    if
        GiveGoods#give_goods.goods_id > 0 andalso GiveGoods#give_goods.num > 0 ->
            case Where of
                1 ->
                    %%掉落到背包
                    case catch goods:give_goods(Player, [GiveGoods#give_goods{location = ?GOODS_LOCATION_BAG, bind = Bind}]) of
                        {ok, Player2} ->
                            Player2;
                        _Err ->
                            ?ERR("drop_goods_err:~p/~p~n", [_Err, GiveGoods]),
                            Player
                    end;
                _ ->
                    %%掉落到场景
                    drop_to_scene(Player#player.key, GiveGoods, Share, Player#player.scene, Player#player.copy, DropX, DropY, [], Player#player.node, Mid),
                    Player
            end;
        true ->
            Player
    end.

drop_to_scene(Pkey, GiveGoods, Share, Scene, Copy, DropX, DropY, Pkeys, Node, Mid) ->
    if GiveGoods#give_goods.goods_id > 0 andalso GiveGoods#give_goods.num > 0 ->
        %%掉落到场景
        Key = misc:unique_key_auto(),
        Time = util:unixtime(),
        Owner = ?IF_ELSE(Share == 0, Pkey, 0),
        ExpireTime = 300,
        DropGoods = #drop_goods{
            mid = Mid,
            node = Node,
            key = Key,
            goodstype = GiveGoods#give_goods.goods_id,
            num = GiveGoods#give_goods.num,
            bindtype = GiveGoods#give_goods.bind,
            from = GiveGoods#give_goods.from,
            args = GiveGoods#give_goods.args,
            owner = Owner,
            droptime = Time,
            expire = Time + ExpireTime,
            hurt_share = Pkeys,
            scene = Scene,
            copy = Copy,
            x = DropX,
            y = DropY
        },
        drop_scene:drop_to_scene(DropGoods);
        true -> ok
    end.


fetch_pool([], _r) -> [];
fetch_pool([DropPool | L], R) ->
    if
        DropPool#drop_pool.ratio_st =< R andalso DropPool#drop_pool.ratio_et >= R ->
            DropPool;
        true ->
            fetch_pool(L, R)
    end.



parse_rule_career([], DropInfoList) -> DropInfoList;
parse_rule_career([{Career, Poolid, Num, Bind, Where, Share} | L], DropInfoList) ->
    parse_rule_career(L, [#drop_info{career = Career, poolid = Poolid, num = Num, bind = Bind, where = Where, share = Share} | DropInfoList]);
parse_rule_career([Err | L], DropInfoList) ->
    ?ERR("drop_rule_format_err:~p~n", [Err]),
    parse_rule_career(L, DropInfoList).


parse_rule_lv([], DropInfoList) -> DropInfoList;
parse_rule_lv([{LvDown, LvUp, Poolid, Num, Bind, Where, Share} | L], DropInfoList) ->
    parse_rule_lv(L, [#drop_info{lvup = LvUp, lvdown = LvDown, poolid = Poolid, num = Num, bind = Bind, where = Where, share = Share} | DropInfoList]);
parse_rule_lv([Err | L], DropInfoList) ->
    ?ERR("drop_rule_format_err:~p~n", [Err]),
    parse_rule_lv(L, DropInfoList).

parse_rule_rank([], DropInfoList) -> DropInfoList;
parse_rule_rank([{Rank, Poolid, Num, Bind, Where, Share} | L], DropInfoList) ->
    parse_rule_rank(L, [#drop_info{rank = Rank, poolid = Poolid, num = Num, bind = Bind, where = Where, share = Share} | DropInfoList]);
parse_rule_rank([Err | L], DropInfoList) ->
    ?ERR("drop_rule_format_err:~p~n", [Err]),
    parse_rule_rank(L, DropInfoList).

parse_rule_order([], DropInfoList) -> DropInfoList;
parse_rule_order([{Order, Poolid, Num, Bind, Where, Share} | L], DropInfolist) ->
    parse_rule_order(L, [#drop_info{order = Order, poolid = Poolid, num = Num, bind = Bind, where = Where, share = Share} | DropInfolist]);
parse_rule_order([Err | L], DropInfoList) ->
    ?ERR("drop_rule_format_err:~p~n", [Err]),
    parse_rule_order(L, DropInfoList).


parse_rule_share([], DropInfoList) -> DropInfoList;
parse_rule_share([{Poolid, Num, Bind, IsHurt} | L], DropInfolist) ->
    parse_rule_share(L, [#drop_info{poolid = Poolid, num = Num, bind = Bind, is_hurt = IsHurt} | DropInfolist]);
parse_rule_share([Err | L], DropInfoList) ->
    ?ERR("drop_rule_format_err:~p~n", [Err]),
    parse_rule_share(L, DropInfoList).



parse_rule_task([], DropInfoList) -> DropInfoList;
parse_rule_task([{Poolid, Num} | L], DropInfolist) ->
    parse_rule_task(L, [#drop_info{poolid = Poolid, num = Num} | DropInfolist]);
parse_rule_task([Err | L], DropInfoList) ->
    ?ERR("drop_rule_format_err:~p~n", [Err]),
    parse_rule_share(L, DropInfoList).

parse_rule_perc([], DropInfoList) -> DropInfoList;
parse_rule_perc([{Perc, Poolid, Num, Bind, Where, Share} | L], DropInfoList) ->
    parse_rule_perc(L, [#drop_info{perc = Perc, poolid = Poolid, num = Num, bind = Bind, where = Where, share = Share} | DropInfoList]);
parse_rule_perc([Err | L], DropInfoList) ->
    ?ERR("drop_rule_format_err:~p~n", [Err]),
    parse_rule_perc(L, DropInfoList).


%%掉落池提取物品
%%return [{goodsid,num},{}...]
get_goods_from_drop_pool(DropId, Num, Bind) ->
    case data_drop_pool:get(DropId) of
        [] -> [];
        PoolList ->
            F1 = fun(_Times, {DropList, PList}) ->
                F = fun(DropPool, N) ->
                    Ratio = DropPool#drop_pool.ratio,
                    {DropPool#drop_pool{ratio_st = N, ratio_et = Ratio + N}, Ratio + N}
                    end,
                {PList1, Total} = lists:mapfoldl(F, 0, PList),
                R = util:rand(1, Total),
                case fetch_pool(PList1, R) of
                    [] ->
                        {DropList, PList1};
                    Pool ->
                        if Pool#drop_pool.goodstype == 0 -> {DropList, PList1};
                            true ->
                                GiveGoods = #give_goods{
                                    goods_id = Pool#drop_pool.goodstype,
                                    num = Pool#drop_pool.num,
                                    bind = Bind,
                                    from = 276,
                                    args = [{start_recv_time, Pool#drop_pool.start_recv_time}]
                                },
                                PList2 = ?IF_ELSE(Pool#drop_pool.type == 0, PList1, lists:delete(Pool, PList1)),
                                {[GiveGoods | DropList], PList2}
                        end
                end
                 end,
            {NewDropList, _} = lists:foldl(F1, {[], PoolList}, lists:seq(1, Num)),
            NewDropList
    end.

%%根据掉落规则ID提取物品
get_goods_from_drop_rule(DropId, MyDropInfo) ->
    DropInfoList = drop_filter(DropId, MyDropInfo),
    F1 = fun(DropInfo) ->
        get_goods_from_drop_pool(DropInfo#drop_info.poolid, DropInfo#drop_info.num, DropInfo#drop_info.bind)
         end,
    lists:flatmap(F1, DropInfoList).

%%场景共享掉落
get_goods_for_scene_share(DropRuleList) ->
    F = fun(DropId) ->
        DropRule = data_drop_rule:get(DropId),
        DropInfoList = parse_rule_share(DropRule#drop_rule.share, []),
        F1 = fun(DropInfo) ->
            GoodsList = get_goods_from_drop_pool(DropInfo#drop_info.poolid, DropInfo#drop_info.num, DropInfo#drop_info.bind),
            [Goods#give_goods{share = DropInfo#drop_info.is_hurt} || Goods <- GoodsList]
             end,
        lists:flatmap(F1, DropInfoList)
        end,
    lists:flatmap(F, DropRuleList).



cmd_drop(Player, DropId) ->
    DropInfo = #drop_info{lvdown = Player#player.lv, lvup = Player#player.lv, career = Player#player.career, order = 1, rank = 1, perc = 100},
    GoodsDropList = drop:get_goods_from_drop_rule(DropId, DropInfo),
    goods:give_goods(Player, GoodsDropList).




cmd() ->
    DropInfo = #drop_info{lvdown = 145, lvup = 145, career = 1, order = 1, rank = 1, perc = 100},
    drop:get_goods_from_drop_rule(3003, DropInfo).


