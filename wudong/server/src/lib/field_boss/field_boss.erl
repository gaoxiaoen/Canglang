%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 五月 2016 14:50
%%%-------------------------------------------------------------------
-module(field_boss).

-include("field_boss.hrl").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("daily.hrl").
-include("guild.hrl").
%% API
-compile(export_all).

midnight_refresh() ->
    ets:delete_all_objects(?ETS_FIELD_BOSS_BUY).

get_field_boss_buy(Pkey) ->
    case ets:lookup(?ETS_FIELD_BOSS_BUY, Pkey) of
        [] -> 0;
        [#ets_field_boss_buy{buy_num = BuyNum}] -> BuyNum
    end.

update_feild_boss_buy(Ets) ->
    ets:insert(?ETS_FIELD_BOSS_BUY, Ets),
    field_boss_load:update_buy(Ets),
    ok.

buy_challenge(Player, 0) -> {0, Player};

buy_challenge(Player, BuyNum) ->
    Price = data_field_boss_buy:get_price(),
    BaseBuyNum = data_field_boss_buy:get_buy_max_num(),
    Now = util:unixtime(),
    case ets:lookup(?ETS_FIELD_BOSS_BUY, Player#player.key) of
        [] ->
            case money:is_enough(Player, Price * BuyNum, bgold) of
                false -> {10, Player};
                true ->
                    if
                        BaseBuyNum < BuyNum -> {11, Player};
                        true ->
                            NewPlayer = money:add_gold(Player, -Price * BuyNum, 766, 0, 0),
                            NewEts =
                                #ets_field_boss_buy{
                                    pkey = Player#player.key,
                                    buy_num = BuyNum,
                                    op_time = Now
                                },
                            ets:insert(?ETS_FIELD_BOSS_BUY, NewEts),
                            field_boss_load:update_buy(NewEts),
                            {1, NewPlayer}
                    end
            end;
        [#ets_field_boss_buy{buy_num = OldBuyNum} = Ets] ->
            case money:is_enough(Player, Price * BuyNum, bgold) of
                false -> {10, Player};
                true ->
                    if
                        BaseBuyNum < BuyNum + OldBuyNum -> {11, Player};
                        true ->
                            NewPlayer = money:add_gold(Player, -Price * BuyNum, 999, 0, 0),
                            NewEts =
                                Ets#ets_field_boss_buy{
                                    buy_num = OldBuyNum + BuyNum,
                                    op_time = Now
                                },
                            ets:insert(?ETS_FIELD_BOSS_BUY, NewEts),
                            field_boss_load:update_buy(NewEts),
                            {1, NewPlayer}
                    end
            end
    end.

%%获取ets boss信息
get_ets_boss(SceneId) ->
    case ets:lookup(?ETS_FIELD_BOSS, SceneId) of
        [] -> [];
        [Boss | _] -> Boss
    end.

%%获取ets 积分信息
get_ets_point(Pkey) ->
    case ets:lookup(?ETS_FIELD_BOSS_POINT, Pkey) of
        [] -> [];
        [Ppoint | _] -> Ppoint
    end.

%%更新
update_ets_point(Ppoint) ->
    Ppoint1 = Ppoint#f_point{
        is_db_update = 1,
        update_time = util:unixtime()
    },
    ets:insert(?ETS_FIELD_BOSS_POINT, Ppoint1).

updb() ->
    case config:is_center_node() of
        true -> skip;
        _ ->
            case ets:tab2list(?ETS_FIELD_BOSS_POINT) of
                [] ->
                    skip;
                EtsList ->
                    F = fun(Ets) ->
                        field_boss_load:update(Ets)
                    end,
                    lists:map(F, EtsList)
            end
    end.

%%Boss信息
get_boss_list(Player) ->
    NextRefreshTime = get_next_refresh_time(),
    F = fun(Sid) ->
        case get_ets_boss(Sid) of
            [] ->
                ?ERR("can not find field boss ~n"),
                [];
            Boss ->
                #field_boss{
                    boss_id = Bid,
                    type = Type,
                    boss_state = State,
                    lv = Lv,
                    is_pk = IsPk,
                    goods_list = GoodsList
                } = Boss,
                LeaveTime =
                    case State of
                        ?FIELD_BOSS_OPEN -> 0;
                        _ -> NextRefreshTime
                    end,
                GoodsList1 = util:list_tuple_to_list(GoodsList),
                [[Sid, Bid, Type, Lv, State, IsPk, LeaveTime, GoodsList1]]
        end
        end,
    BossList = lists:flatmap(F, data_field_boss:ids()),
    Count = daily:get_count(?DAILY_FIELD_BOSS),
    BuyCount = get_field_boss_buy(Player#player.key),
    Price = data_field_boss_buy:get_price(),
    RemainBuyCount = max(0, data_field_boss_buy:get_buy_max_num() - BuyCount),
    {Price, RemainBuyCount, BossList, Count, ?DAILY_MAX_FIELD_BOSS + BuyCount}.

%%飞鞋进入场景
fly_to_scene(Player, Sid) ->
    case check_fly_to_scene(Player, Sid) of
        {false, Msg} ->
            {false, Msg};
        {ok, GoodsId, _NewPlayer, X, Y, CostNum} ->
            case CostNum > 0 of
                true ->
                    goods:subtract_good(Player, [{GoodsId, 1}], 509);
                false ->
                    skip
            end,
            Player1 = scene_change:change_scene(Player, Sid, 0, X, Y, false),
            {ok, Player1}
    end.
check_fly_to_scene(Player, Sid) ->
    FlyVip = 2,
    GoodsId = 1015000,
    GoodsCount = goods_util:get_goods_count(GoodsId),
    if
        GoodsCount =< 0 andalso Player#player.vip_lv < FlyVip -> {false, ?T("没有飞行符物品")};
        true ->
            Base = data_scene:get(Sid),
            case scene_check:enter_field_boss_scene(Player, Base, 0) of
                {false, Msg} -> {false, Msg};
                {true, NewPlayer, _Sid, _Copy, X, Y, _Name, _TSid} ->
                    CostNum = ?IF_ELSE(Player#player.vip_lv >= FlyVip, 0, 1),
                    {ok, GoodsId, NewPlayer, X, Y, CostNum}
            end
    end.

%%伤害信息
damage_info(Player) ->
    #player{
        scene = SceneId,
        key = Pkey
    } = Player,
    case scene:is_field_boss_scene(SceneId) of
        false -> skip;
        true ->
            Boss = get_ets_boss(SceneId),
            if
                Boss == [] -> skip;
                true ->
                    {MyDamage, MyRank} =
                        case lists:keyfind(Pkey, #f_damage.pkey, Boss#field_boss.damage_list) of
                            false -> {0, 0};
                            Damage ->
                                {round(Damage#f_damage.damage / Damage#f_damage.hp_lim * 1000), Damage#f_damage.rank}
                        end,
                    TopN = damage_top_n(Boss#field_boss.damage_list, 5),
                    LeaveTime =
                        case Boss#field_boss.boss_state of
                            ?FIELD_BOSS_OPEN -> 0;
                            _ -> get_next_refresh_time()

                        end,
                    Data = {Boss#field_boss.boss_id, MyDamage, MyRank, TopN, LeaveTime},
                    {ok, Bin} = pt_560:write(56003, Data),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end
    end.

%%排行榜
get_rank(Player) ->
    F = fun(SceneId, AccPList) ->
        Boss = data_field_boss:get(SceneId),
        #field_boss{
            type = Type
        } = Boss,
        case Type == ?SERVER_TYPE_NORMAL of
            true ->
                PlayerInfo = get_rank_player_info(SceneId),
                AccPList ++ [PlayerInfo];
            false -> AccPList
        end
        end,
    AllId = data_field_boss:ids(),
    RankList = lists:foldl(F, [], AllId),
    F1 = fun(Sid) ->
        Boss = data_field_boss:get(Sid),
        case Boss#field_boss.type == ?SERVER_TYPE_CROSS of
            true -> [Boss];
            false -> []
        end
         end,
    KfList = lists:flatmap(F1, AllId),
    case KfList == [] of
        true -> %%不需要去跨服数据
            {ok, Bin} = pt_560:write(56004, {RankList}),
            server_send:send_to_sid(Player#player.sid, Bin);
        false ->
            cross_area:apply(field_boss_proc, rpc_get_week_rank, [Player#player.node, Player#player.sid, RankList])
    end.

%%获取具体榜单
get_scene_rank(Player, SceneId) ->
    Boss = data_field_boss:get(SceneId),
    if
        Boss == [] -> skip;
        true ->
            if
                Boss#field_boss.type == ?SERVER_TYPE_NORMAL ->
                    get_scene_rank_1(node(), Player#player.key, Player#player.sid, SceneId);
                Boss#field_boss.type == ?SERVER_TYPE_CROSS ->
                    cross_area:apply(field_boss, get_scene_rank_1, [Player#player.node, Player#player.key, Player#player.sid, SceneId])
            end,
            ok
    end.
get_scene_rank_1(Node, Mykey, Sid, SceneId) ->
%%    CurNode = node(),
    FPointList = get_point_top_n(SceneId, 20),
    Boss = data_field_boss:get(SceneId),
    F = fun({FPoint, Point}, {Order, AccMyRank}) ->
        #f_point{
            sn = Sn,
            pkey = Pkey,
            name = Name,
            lv = Lv,
            cbp = Cbp
        } = FPoint,
        GoodsList = data_field_boss_rank:get(Boss#field_boss.boss_id, Order),
        GoodsList1 = util:list_tuple_to_list(GoodsList),
        NewAccMyRank = ?IF_ELSE(Pkey == Mykey, Order, AccMyRank),
        {[Sn, Pkey, Name, Lv, Point, Cbp, GoodsList1], {Order + 1, NewAccMyRank}}
        end,
    {RankList, {_, MyRank}} = lists:mapfoldl(F, {1, 0}, FPointList),
    {ok, Bin} = pt_560:write(56005, {Boss#field_boss.lv, MyRank, RankList}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    case CurNode == Node of
%%        true ->
%%            server_send:send_to_sid(Sid, Bin);
%%        false ->
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
%%    end,
    ok.

%%获取精英怪列表
get_elite_info(Player) ->
    All = data_field_elite:ids(),
    Now = util:unixtime(),
    F = fun(FId) ->
        FieldElite = data_field_elite:get(FId),
        #field_elite{
            mon_id = Monid,
            scene_id = SceneId,
            lv = Lv,
            drop_goods = DropGoodslist
        } = FieldElite,
        MonList = mon_agent:get_scene_mon_by_mid(SceneId, Monid),
        F1 = fun(Mon) ->
            State = ?IF_ELSE(Mon#mon.hp =< 0, 0, 1),
            LeaveTime = ?IF_ELSE(Mon#mon.hp =< 0, max(0, Now + Mon#mon.retime - Mon#mon.time_mark#time_mark.ldt), 1),
            Copy =
                case is_integer(Mon#mon.copy) of
                    true -> Mon#mon.copy;
                    false -> 0
                end,
            [Copy, State, LeaveTime, Mon#mon.x, Mon#mon.y]
             end,
        CopyList = lists:map(F1, MonList),
        DropGoodslist1 = util:list_tuple_to_list(DropGoodslist),
        [SceneId, Monid, Lv, CopyList, DropGoodslist1]
        end,
    List = lists:map(F, All),
    Count = daily:get_count(?DAILY_FIELD_ELITE),
    MaxCount = ?DAILY_MAX_FIELD_ELITE,
    {ok, Bin} = pt_560:write(56021, {min(MaxCount, Count), MaxCount, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%飞鞋去精英场景
fly_to_elite_scene(Player, SceneId, Copy, MonId, X, Y) ->
    case check_fly_to_elite_scene(Player, SceneId, Copy, MonId) of
        {false, Res} ->
            {false, Res};
        {ok, GoodsId, CostNum} ->
            case CostNum > 0 of
                true ->
                    goods:subtract_good(Player, [{GoodsId, 1}], 509);
                false ->
                    skip
            end,
            case SceneId == Player#player.scene of
                true ->
                    {ok, Bin} = pt_120:write(12047, {1, 1, SceneId, X, Y}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    {ok, Player};
                false ->
                    Player1 = scene_change:change_scene(Player, SceneId, Copy, X, Y, false),
                    {ok, Player1}
            end
    end.
check_fly_to_elite_scene(Player, SceneId, Copy, MonId) ->
    FlyVip = 2,
    GoodsId = 1015000,
    GoodsCount = goods_util:get_goods_count(GoodsId),
    if
        Player#player.scene == SceneId andalso Player#player.copy == Copy -> {false, ?T("已在当前场景线路")};
        GoodsCount =< 0 andalso Player#player.vip_lv < FlyVip -> {false, ?T("没有神行靴物品")};
        true ->
            case mon_agent:get_scene_mon_by_mid(SceneId, Copy, MonId) of
                [] -> {false, ?T("该场景线路没有精英首领")};
                _ ->
                    CostNum = ?IF_ELSE(Player#player.vip_lv >= FlyVip, 0, 1),
                    {ok, GoodsId, CostNum}
            end
    end.

%%获取排行榜top1玩家信息
get_rank_player_info(SceneId) ->
    Boss = data_field_boss:get(SceneId),
    #field_boss{
        lv = Lv,
        boss_id = BossId
    } = Boss,
    Goodslist = util:list_tuple_to_list(data_field_boss_rank:get(BossId, 1)),
    case get_point_top_n(SceneId, 1) of
        [] -> [SceneId, BossId, Lv, 0, 0, "", 0, 0, 0, 0, 0, 0, 0, 0, 0, Goodslist];
        [{Fpoint, _}] ->
            #f_point{
                sn = Sn,
                pkey = Pkey
            } = Fpoint,
            case config:is_center_node() of
                false ->
                    PlayerInfo = get_player_info(Pkey, node()),
                    [SceneId, BossId, Lv | PlayerInfo] ++ [Goodslist];
                true ->
                    case center:get_node_by_sn(Sn) of
                        false ->
                            [SceneId, BossId, Lv, 0, 0, "", 0, 0, 0, 0, 0, 0, 0, 0, 0, Goodslist];
                        Node ->
                            PlayerInfo = get_player_info(Pkey, Node),
                            [SceneId, BossId, Lv | PlayerInfo] ++ [Goodslist]
                    end
            end
    end.

%%获取积分排行top N
get_point_top_n(SceneId, N) ->
    All = ets:tab2list(?ETS_FIELD_BOSS_POINT),
    F = fun(Fpoint) ->
        case lists:keyfind(SceneId, 1, Fpoint#f_point.point_list) of
            false -> [];
            {_, Point} -> [{Fpoint, Point}]
        end
        end,
    List = lists:flatmap(F, All),
    SortList = lists:reverse(lists:keysort(2, List)),
    lists:sublist(SortList, N).

%%获取玩家信息
get_player_info(Pkey, Node) ->
    Player1 = shadow_proc:get_shadow(Pkey, Node),
    Player =
        case is_record(Player1, player) of
            false -> #player{};
            true -> Player1
        end,
    [
        Player#player.sn,
        Player#player.key,
        Player#player.nickname,
        Player#player.career,
        Player#player.sex,
        Player#player.vip_lv,
        Player#player.wing_id,
        Player#player.equip_figure#equip_figure.weapon_id,
        Player#player.equip_figure#equip_figure.clothing_id,
        Player#player.light_weaponid,
        Player#player.fashion#fashion_figure.fashion_cloth_id,
        Player#player.fashion#fashion_figure.fashion_head_id
    ].

%%刷新全部boss
refresh_boss_all() ->
    ServerType = ?IF_ELSE(center:is_center_area(), ?SERVER_TYPE_CROSS, ?SERVER_TYPE_NORMAL),
    F = fun(SceneId) ->
        Boss = data_field_boss:get(SceneId),
        if
            Boss#field_boss.type == ServerType ->
                Mon = data_mon:get(Boss#field_boss.boss_id),
                NewBoss = Boss#field_boss{lv = Mon#mon.lv, boss_state = ?FIELD_BOSS_OPEN, damage_list = [], kill_pkey = 0},
                ets:insert(?ETS_FIELD_BOSS, NewBoss),
                sync_cross_field_boss(NewBoss),
                refresh_boss(Boss);
            true -> skip
        end
        end,
    lists:foreach(F, data_field_boss:ids()).

%%同步中心服boss信息到各单服节点
sync_cross_field_boss(Boss) ->
    case Boss#field_boss.type == ?SERVER_TYPE_CROSS andalso center:is_center_area() of
        true ->
            F = fun(Node) ->
                center:apply(Node, field_boss, sync_to_local, [Boss])
                end,
            lists:foreach(F, center:get_nodes());
        false -> skip
    end.

%%同步到单服
sync_to_local(Boss) ->
    ets:insert(?ETS_FIELD_BOSS, Boss),
    ok.

%%通知单服同步boss排名信息到中心服
sync_node_rank(SceneId) ->
    Nodes = center:get_nodes(),
    F = fun(Node) ->
        center:apply(Node, field_boss, sync_rank_to_corss, [SceneId])
        end,
    lists:foreach(F, Nodes),

    ok.
sync_rank_to_corss(SceneId) ->
    %%获取单服前20名同步到中心服
    List = get_point_top_n(SceneId, 20),
    PList = [FPoint || {FPoint, _} <- List],
    cross_area:apply(field_boss_proc, rpc_syc_node_rank, [PList]),
    ok.

%%创建boss
refresh_boss(Boss) ->
    case mon_agent:get_scene_mon_by_mid(Boss#field_boss.scene_id, Boss#field_boss.boss_id) of
        [] ->
            %%boss不存在才刷新
            mon_agent:create_mon_cast([Boss#field_boss.boss_id, Boss#field_boss.scene_id, Boss#field_boss.x, Boss#field_boss.y, 0, 1, []]),
            case Boss#field_boss.type of
                ?SERVER_TYPE_NORMAL ->
                    activity_notice();
                ?SERVER_TYPE_CROSS ->
                    F = fun(Node) ->
                        center:apply(Node, field_boss, activity_notice, [])
                        end,
                    lists:foreach(F, center:get_nodes());
                _ -> skip
            end,
            ok;
        _ ->
            ok
    end.

%%更新boss伤害列表
update_field_boss_klist(Mon, KList, AttKey, AttNode, FieldBossTimes) ->
    IsFieldScene = scene:is_field_boss_scene(Mon#mon.scene),
    if
        Mon#mon.boss =/= ?BOSS_TYPE_FIELD -> skip;
        not IsFieldScene -> skip;
        Mon#mon.hp =< 0 ->
            field_boss_proc:get_server_pid() ! {update_field_boss, Mon#mon.scene, Mon#mon.hp, Mon#mon.hp_lim, KList, AttKey, FieldBossTimes};
        true ->
            BuyCount = get_field_boss_buy(AttKey),
            ?DO_IF(Mon#mon.mana > 0 andalso FieldBossTimes < ?DAILY_MAX_FIELD_BOSS + BuyCount, field_boss_roll:hurt_roll(Mon#mon.key, AttKey, AttNode)),
            Now = util:unixtime(),
            Key = update_field_boss_klist,
            case get(Key) of
                undefined ->
                    put(Key, Now),
                    field_boss_proc:get_server_pid() ! {update_field_boss, Mon#mon.scene, Mon#mon.hp, Mon#mon.hp_lim, KList, AttKey, FieldBossTimes};
                Time ->
                    case Now - Time >= 1 of
                        true ->
                            put(Key, Now),
                            field_boss_proc:get_server_pid() ! {update_field_boss, Mon#mon.scene, Mon#mon.hp, Mon#mon.hp_lim, KList, AttKey, FieldBossTimes};
                        false -> false
                    end
            end
    end.

%%boss伤害排名#st_hatred{}
rank_damage_list(SceneId, Klist, DamageList, LimHp, Hp, _BossLv) ->
    F = fun(Hatred, L) ->
        BuyCount = get_field_boss_buy(Hatred#st_hatred.key),
        DailyMax = data_version_different:get(12) + BuyCount,
        if Hatred#st_hatred.field_boss_times >= DailyMax -> L;
            Hatred#st_hatred.hurt =< 0 -> L;
            true ->
                case lists:keyfind(Hatred#st_hatred.key, #f_damage.pkey, DamageList) of
                    false ->
                        [#f_damage{pkey = Hatred#st_hatred.key, name = Hatred#st_hatred.nickname, sn = Hatred#st_hatred.sn, hp = Hp, hp_lim = LimHp, damage = Hatred#st_hatred.hurt, gkey = Hatred#st_hatred.gkey, node = Hatred#st_hatred.node, lv = Hatred#st_hatred.lv, cbp = Hatred#st_hatred.cbp} | L];
                    Damage ->
                        [Damage#f_damage{damage = Hatred#st_hatred.hurt, hp = Hp} | L]
                end
        end
        end,
    List = lists:foldl(F, [], Klist),
    %%计算伤害比例
%%    SumDamage = max(1, lists:sum([D#f_damage.damage || D <- DamageList])),
%%    HurtRatio =
%%        case DamageList of
%%            [] -> 0;
%%            [Hd | _] -> 1 - Hd#f_damage.hp / Hd#f_damage.hp_lim
%%        end,
    F11 = fun(D) ->
        DHurtRatio = round(D#f_damage.damage / LimHp * 1000),
        D#f_damage{damage_ratio = DHurtRatio}
          end,
    List1 = lists:map(F11, List),
    F1 = fun(Damage, {Rank, L}) ->
        {Rank + 1, L ++ [Damage#f_damage{rank = Rank}]}
         end,
    {_, List2} = lists:foldr(F1, {1, []}, lists:keysort(#f_damage.damage, List1)),
    spawn(fun() -> refresh_damage_to_client(SceneId, List2) end),
    List2.

%%更新伤害到客户端
refresh_damage_to_client(SceneId, DamageList) ->
    Boss = data_field_boss:get(SceneId),
    UserList = scene_agent:get_scene_player(SceneId),
    TopN = damage_top_n(DamageList, 5),
%%    Node = node(),
    F = fun(ScenePlayer) ->
        {ok, Bin} =
            case lists:keyfind(ScenePlayer#scene_player.key, #f_damage.pkey, DamageList) of
                false ->
                    pt_560:write(56003, {Boss#field_boss.boss_id, 0, 0, TopN, 0});
                Damage ->
                    pt_560:write(56003, {Boss#field_boss.boss_id, Damage#f_damage.damage_ratio, Damage#f_damage.rank, TopN, 0})
            end,
        server_send:send_to_sid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.sid, Bin)
%%        if
%%            ScenePlayer#scene_player.node == Node orelse ScenePlayer#scene_player.node == none ->
%%                server_send:send_to_sid(ScenePlayer#scene_player.sid, Bin);
%%            true ->
%%                center:apply(ScenePlayer#scene_player.node, server_send, send_to_sid, [ScenePlayer#scene_player.sid, Bin])
%%        end
        end,
    lists:foreach(F, UserList).

damage_top_n(DamageList, N) ->
    [[D#f_damage.sn, D#f_damage.name, D#f_damage.damage_ratio] || D <- lists:sublist(DamageList, N)].


%%掉落日记
log_field_boss(Pkey, Nickname, BossId, RankId, GoodsList) ->
    Sql = io_lib:format(<<"insert into log_field_boss set pkey=~p,nickname = '~s',boss_id=~p,rank=~p,reward='~s'">>,
        [Pkey, Nickname, BossId, RankId, util:term_to_bitstring(GoodsList)]),
    log_proc:log(Sql),
    ok.

%%boss参与伤害日志
log_join(BossId, DamageList) ->
    Name = mon_util:get_mon_name(BossId),
    Now = util:unixtime(),
    F = fun(Damage) ->
        log:log_boss_join(BossId, Name, Damage#f_damage.pkey, Damage#f_damage.name, Damage#f_damage.gkey, Damage#f_damage.damage, Now)
        end,
    lists:foreach(F, DamageList).

%%周排行日志
log_field_boss_rank(Pkey, SceneId, Rank, Point) ->
    Sql = io_lib:format(<<"insert into log_field_boss_rank set scene_id=~p,pkey=~p,point=~p,rank=~p,time=~p">>,
        [SceneId, Pkey, Point, Rank, util:unixtime()]),
    log_proc:log(Sql),
    ok.

%%消息状态
get_notice_state() ->
    F = fun(Boss) ->
        Boss#field_boss.boss_state == ?FIELD_BOSS_OPEN
        end,
    case lists:any(F, ets:tab2list(?ETS_FIELD_BOSS)) of
        true -> 1;
        false -> 0
    end.

%%活动红点回调
activity_notice() ->
    F = fun(Online) ->
        Online#ets_online.pid ! {activity_notice, 85}
        end,
    lists:foreach(F, ets:tab2list(?ETS_ONLINE)).

%%初始化boss数据
init_field_boss() ->
    F = fun(SceneId) ->
        Boss = data_field_boss:get(SceneId),
        Mon = data_mon:get(Boss#field_boss.boss_id),
        NewBoss = Boss#field_boss{lv = Mon#mon.lv, boss_state = ?FIELD_BOSS_CLOSE},
        ets:insert(?ETS_FIELD_BOSS, NewBoss)
        end,
    lists:foreach(F, data_field_boss:ids()).

%%击杀发送积分
reward_point(Boss) ->
    #field_boss{
        scene_id = SceneId,
        kill_point = KillPoint,
        rank_point = RankPointList,
        kill_pkey = KillerKey,
        damage_list = DamageList
    } = Boss,
    IsCenterNode = center:is_center_area(),
    F = fun(D) ->
        #f_damage{
            node = Node,
            pkey = Pkey,
            rank = Rank
        } = D,
        GetPoint1 = ?IF_ELSE(KillerKey == Pkey, KillPoint, 0),
        GetPoint2 = get_rank_point(Rank, RankPointList),
        Point = GetPoint1 + GetPoint2,
        case IsCenterNode of
            false ->
                reward_point_node(D, Point, SceneId);
            true ->
                center:apply(Node, field_boss, reward_point_node, [D, Point, SceneId])
        end
        end,
    lists:foreach(F, lists:sublist(DamageList, 100)).

reward_point_node(FDamage, Point, SceneId) ->
    #f_damage{
        pkey = Pkey,
        sn = Sn,
        lv = Lv,
        name = Name,
        cbp = Cbp
    } = FDamage,
    case get_ets_point(Pkey) of
        [] ->
            Fpoint = #f_point{
                pkey = Pkey,
                point_list = [{SceneId, Point}],
                sn = Sn,
                lv = Lv,
                name = Name,
                cbp = Cbp
            },
            update_ets_point(Fpoint);
        Fpoint ->
            #f_point{
                point_list = PointList
            } = Fpoint,
            NewPointList =
                case lists:keyfind(SceneId, 1, PointList) of
                    false -> [{SceneId, Point} | PointList];
                    {_, OldPoint} ->
                        [{SceneId, OldPoint + Point} | lists:keydelete(SceneId, 1, PointList)]
                end,
            NewFPoint = Fpoint#f_point{
                point_list = NewPointList
            },
            update_ets_point(NewFPoint)
    end.

%%获取排名可得积分
get_rank_point(_Rank, []) -> 0;
get_rank_point(Rank, [{Min, Max, Point} | _Tail]) when Min =< Rank andalso Max >= Rank -> Point;
get_rank_point(Rank, [_ | Tail]) ->
    get_rank_point(Rank, Tail).

%%幸运奖
luck_reward(Boss) ->
    #field_boss{
        boss_id = BossId,
        kill_pkey = KillerKey,
        luck_goods = LuckGoods,
        damage_list = DamageList
    } = Boss,
    DamageList1 = [D || D <- DamageList, D#f_damage.pkey =/= KillerKey, D#f_damage.rank > 5],
    case util:list_shuffle(DamageList1) of
        [] -> ok;
        [Hd | _] ->
            #f_damage{
                pkey = Pkey,
                node = Node
            } = Hd,
            IsCenterNode = center:is_center_area(),
            case IsCenterNode of
                false ->
                    luck_reward_1(Pkey, LuckGoods, BossId);
                true ->
                    center:apply(Node, field_boss, luck_reward_1, [Pkey, LuckGoods, BossId])
            end
    end,
    ok.
luck_reward_1(Pkey, LuckGoods, BossId) ->
    Mon = data_mon:get(BossId),
    Now = util:unixtime(),
    NowStr =
        case version:get_lan_config() of
            vietnam ->
                util:unixtime_to_time_string4(Now);
            _ ->
                util:unixtime_to_time_string3(Now)
        end,
    Title = ?T("boss星运奖"),
    Content = io_lib:format(?T("你于~s对~s世界首领的攻击中获得了幸运奖励，奖励如下："), [NowStr, Mon#mon.name]),
    mail:sys_send_mail([Pkey], Title, Content, LuckGoods),
    ok.


%%获取下次开启时间
get_next_refresh_time() ->
    Now = util:unixtime(),
    Date = util:unixdate(),
    TodayS = Now - Date,
    get_next_refresh_time_1(TodayS, 0, ?FIELD_BOSS_REFRESH_TIME, ?FIELD_BOSS_REFRESH_TIME).
get_next_refresh_time_1(_TodayS, 10, _RefreshTimeList, _AccRefreshTimeList) ->
    ?ERR("get next refresh time err ~n"), ?ONE_DAY_SECONDS;
get_next_refresh_time_1(TodayS, Day, RefreshTimeList, []) ->
    get_next_refresh_time_1(TodayS, Day + 1, RefreshTimeList, RefreshTimeList);
get_next_refresh_time_1(TodayS, Day, RefreshTimeList, [{H, M} | Tail]) ->
    OpenTime = H * 3600 + M * 60 + Day * ?ONE_DAY_SECONDS,
    case OpenTime > TodayS of
        true -> OpenTime - TodayS;
        false ->
            get_next_refresh_time_1(TodayS, Day, RefreshTimeList, Tail)
    end.

week_rank_reward() ->
    All = data_field_boss:ids(),
    IsCenterNode = center:is_center_area(),
    ServerType = ?IF_ELSE(IsCenterNode, ?SERVER_TYPE_CROSS, ?SERVER_TYPE_NORMAL),
    F = fun(Sid) ->
        B = data_field_boss:get(Sid),
        #field_boss{
            type = Type,
            boss_id = BossId
        } = B,
        case Type == ServerType of
            true ->
                TopN = field_boss:get_point_top_n(Sid, 100),
                Title = ?T("周排行榜"),
                F1 = fun({FPoint, Point}, Order) ->
                    GoodsList = data_field_boss_rank:get(BossId, Order),
                    case GoodsList == [] of
                        true -> Order + 1;
                        false ->
                            Mon = data_mon:get(BossId),
                            Content = io_lib:format(?T("您在世界首领-~s周排行榜，第~p名，获得奖励："), [Mon#mon.name, Order]),
                            case IsCenterNode of
                                false ->
                                    mail:sys_send_mail([FPoint#f_point.pkey], Title, Content, GoodsList);
                                true ->
                                    case center:get_node_by_sn(FPoint#f_point.sn) of
                                        false -> ok;
                                        Node ->
                                            center:apply(Node, mail, sys_send_mail, [[FPoint#f_point.pkey], Title, Content, GoodsList])
                                    end
                            end,
                            field_boss:log_field_boss_rank(FPoint#f_point.pkey, Sid, Order, Point),
                            Order + 1
                    end
                     end,
                lists:foldl(F1, 1, TopN);
            false ->
                skip
        end
        end,
    lists:foreach(F, All),
    %%清排行榜数据
    case config:is_debug() of
        true -> ets:delete_all_objects(?ETS_FIELD_BOSS_POINT);
        false ->
            spawn(fun() -> timer:sleep(3600 * 1000), ets:delete_all_objects(?ETS_FIELD_BOSS_POINT) end)
    end,
    ok.


%%击杀boss
kill_mon(Boss, FieldBossTimes) ->
    #field_boss{
        scene_id = SceneId,
        boss_id = BossId,
        kill_pkey = KillKey,
        damage_list = DamageList,
        red_bag_id = RedBagId
    } = Boss,
    Base = data_field_boss:get(SceneId),
    #field_boss{
        kill_goods = KillGoods,
        hurt_goods = HurtGoodsList,
        join_goods = JoinGoodslist
    } = Base,
    Mon = data_mon:get(BossId),
    #mon{
        name = MonName
    } = Mon,
    ServerType = ?IF_ELSE(config:is_center_node(), ?SERVER_TYPE_CROSS, ?SERVER_TYPE_NORMAL),
    Now = util:unixtime(),
    NowStr =
        case version:get_lan_config() of
            vietnam ->
                util:unixtime_to_time_string4(Now);
            _ ->
                util:unixtime_to_time_string3(Now)
        end,
    %%击杀奖励
    kill_drop(ServerType, KillKey, KillGoods, NowStr, MonName, FieldBossTimes),
    %%帮派红包
    guild_red_bag(DamageList, ServerType, KillKey, RedBagId),
    %%伤害前5奖励
    top_n_drop(DamageList, HurtGoodsList, ServerType, SceneId, NowStr, MonName),
    %%参与奖励
    F1 = fun(D) ->
        case ServerType == ?SERVER_TYPE_CROSS of
            true ->
                center:apply(D#f_damage.node, field_boss, join_drop, [D#f_damage.pkey, SceneId, JoinGoodslist, ServerType]);
            false ->
                join_drop(D#f_damage.pkey, SceneId, JoinGoodslist, ServerType)
        end
         end,
    spawn(fun() -> lists:foreach(F1, DamageList) end),
    ok.

%%击杀奖励
kill_drop(ServerType, KillKey, KillGoods, NowStr, MonName, FieldBossTimes) ->
    BuyCount = get_field_boss_buy(KillKey),
    DailyMax = data_version_different:get(12) + BuyCount,
    if FieldBossTimes < DailyMax ->
        %%击杀奖励
        Title = ?T("首领最后一击奖励"),
        Content = io_lib:format(?T("你于~s对~s世界首领进行了最后一击，恭喜您获得了最后一击奖励。"), [NowStr, MonName]),
        case ServerType == ?SERVER_TYPE_CROSS of
            true ->
                K_fpoint = get_ets_point(KillKey),
                if
                    K_fpoint == [] -> ?ERR("can not find killer in kf server ~p~n", [KillKey]), skip;
                    true ->
                        case center:get_node_by_sn(K_fpoint#f_point.sn) of
                            false ->
                                skip;
                            Node ->
                                center:apply(Node, field_boss, field_boss_mail, [KillKey, Title, Content, KillGoods])
                        end
                end;
            false ->
                field_boss_mail(KillKey, Title, Content, KillGoods)
        end;
        true ->
            ok
    end.

%%伤害前5奖励
top_n_drop(DamageList, HurtGoodsList, ServerType, SceneId, NowStr, MonName) ->
    TopN = lists:sublist(DamageList, 5),
    F = fun(D, Order) ->
        #f_damage{
            node = Node,
            pkey = DPkey
        } = D,
        case lists:keyfind(Order, 1, HurtGoodsList) of
            false -> ?ERR("can not find hurt goods ~p~n", [{SceneId, Order}]), skip;
            {_, HGoodsList} ->
                case scene_agent:get_scene_player(SceneId, 0, DPkey) of
                    [] -> skip;
                    _DPlayer ->
                        DTitle = ?T("首领伤害排名奖励"),
                        DContent = io_lib:format(?T("你于~s参与对~s世界首领的围剿，恭喜您获得了伤害第~p的奖励。"), [NowStr, MonName, Order]),
                        case ServerType == ?SERVER_TYPE_CROSS of
                            true ->
                                center:apply(Node, field_boss, field_boss_mail, [DPkey, DTitle, DContent, HGoodsList]);
                            false ->
                                field_boss_mail(DPkey, DTitle, DContent, HGoodsList)
                        end
                end
        end,
        Order + 1
        end,
    spawn(fun() -> lists:foldl(F, 1, TopN) end).


field_boss_mail(Pkey, Title, Content, GoodsList) ->
    mail:sys_send_mail([Pkey], Title, Content, GoodsList),
    ok.


guild_red_bag(DamageList, ServerType, KillKey, RedBagId) ->
    case DamageList of
        [] -> skip;
        [Top1 | _] ->
            #f_damage{
                node = TopKillerNode,
                pkey = TopKiller
            } = Top1,
            KillMem =
                case ServerType == ?SERVER_TYPE_CROSS of
                    true -> center:apply_call(TopKillerNode, guild_ets, get_guild_member, [TopKiller]);
                    false -> guild_ets:get_guild_member(TopKiller)
                end,
            case is_record(KillMem, g_member) of
                false -> skip;
                true ->
                    #g_member{
                        gkey = KillGkey,
                        name = Name
                    } = KillMem,
                    case ServerType == ?SERVER_TYPE_CROSS of
                        true ->
                            K_fpoint1 = get_ets_point(KillKey),
                            if
                                K_fpoint1 == [] -> ?ERR("can not find killer in kf server ~p~n", [KillKey]), skip;
                                true ->
                                    case center:get_node_by_sn(K_fpoint1#f_point.sn) of
                                        false ->
                                            skip;
                                        Node ->
                                            center:apply(Node, red_bag_proc, add_red_bag_guild_by_sys, [RedBagId, KillGkey, Name, KillKey])
                                    end
                            end;
                        false ->
                            red_bag_proc:add_red_bag_guild_by_sys(RedBagId, KillGkey, Name, KillKey)
                    end
            end
    end.


%%参与奖励
join_drop(Pkey, SceneId, JoinGoodsList, ServerType) ->
    case player_util:get_player_online(Pkey) of
        [] ->
            daily:increment_count_outline(Pkey, ?DAILY_FIELD_BOSS, 1),
            skip;
        Online ->
            Online#ets_online.pid ! {apply_state, {field_boss, join_drop_1, [JoinGoodsList, SceneId, ServerType]}}
    end,
    ok.
join_drop_1([JoinGoodsList, SceneId, ServerType], Player) ->
    Count = daily:get_count(?DAILY_FIELD_BOSS),
    NewCount = daily:increment(?DAILY_FIELD_BOSS, 1),
    scene_agent_dispatch:update_field_boss_times(Player, NewCount),
    case ServerType == ?SERVER_TYPE_CROSS of
        true ->
            act_hi_fan_tian:trigger_finish_api(Player, 9, 1);
        _ ->
            act_hi_fan_tian:trigger_finish_api(Player, 9, 1)
    end,
    BuyCount = get_field_boss_buy(Player#player.key),
    case Player#player.scene == SceneId andalso Count < ?DAILY_MAX_FIELD_BOSS + BuyCount of
        true ->
            Goodslist = goods:make_give_goods_list(509, JoinGoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, Goodslist),
            JoinGoodsList1 = util:list_tuple_to_list(JoinGoodsList),
            {ok, Bin} = pt_560:write(56010, {JoinGoodsList1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        false ->
            ok
    end.

%%击杀野外精英怪
kill_elite_mon(Mon, Klist, AtterKey) ->
    case data_field_elite:get(Mon#mon.mid) of
        [] -> skip;
        Elite ->
            last_kill_reward(Elite, AtterKey),
            F = fun(StHurt) ->
                #st_hatred{
                    key = Pkey
                } = StHurt,
                case player_util:get_player_online(Pkey) of
                    [] -> %%离线处理
                        daily:increment_count_outline(Pkey, ?DAILY_FIELD_ELITE, 1);
                    Online ->
                        Online#ets_online.pid ! {apply_state, {field_boss, kill_elite_mon_1, []}}
                end
                end,
            lists:foreach(F, Klist)
    end,
    ok.

kill_elite_mon_1([], _Player) ->
    daily:increment(?DAILY_FIELD_ELITE, 1),
    ok.

%%最后一刀击杀奖励
last_kill_reward(Elite, AtterKey) ->
    #field_elite{
        mon_id = Mid,
        kill_goods = KillGoods
    } = Elite,
    Mon = data_mon:get(Mid),
    case player_util:get_player_online(AtterKey) of
        [] -> %%离线处理
            Count = daily:get_count_outline(AtterKey, ?DAILY_FIELD_ELITE),
            case Count >= ?DAILY_MAX_FIELD_ELITE of
                true ->
                    skip;
                false ->
                    Now = util:unixtime(),
                    TimeStr =
                        case version:get_lan_config() of
                            vietnam ->
                                util:unixtime_to_time_string4(Now);
                            _ ->
                                util:unixtime_to_time_string3(Now)
                        end,
                    Title = ?T("精英首领击杀奖励"),
                    Content = io_lib:format(?T("你于~s对~s精英首领进行了最后一击，恭喜您获得了最后一击奖励。"), [TimeStr, Mon#mon.name]),
                    mail:sys_send_mail([AtterKey], Title, Content, KillGoods)
            end;
        Online -> %%在线处理
            Online#ets_online.pid ! {apply_state, {field_boss, last_kill_reward_1, [KillGoods, Mon]}}
    end,
    ok.

last_kill_reward_1([KillGoods, Mon], Player) ->
    Count = daily:get_count(?DAILY_FIELD_ELITE),
    case Count >= ?DAILY_MAX_FIELD_ELITE of
        true -> skip;
        false ->
            Now = util:unixtime(),
            TimeStr =
                case version:get_lan_config() of
                    vietnam ->
                        util:unixtime_to_time_string4(Now);
                    _ ->
                        util:unixtime_to_time_string3(Now)
                end,
            Title = ?T("精英首领击杀奖励"),
            Content = io_lib:format(?T("你于~s对~s精英首领进行了最后一击，恭喜您获得了最后一击奖励。"), [TimeStr, Mon#mon.name]),
            mail:sys_send_mail([Player#player.key], Title, Content, KillGoods)
    end,
    ok.

%%更新场景所有玩家 boss信息
notice_field_boss(SceneId) ->
    ScenePlayers = scene_agent:get_scene_player(SceneId),
    Node = node(),
    F = fun(ScenePlayer) ->
        if
            ScenePlayer#scene_player.node == Node orelse ScenePlayer#scene_player.node == none ->
                ScenePlayer#scene_player.pid ! {apply_state, {field_boss, notice_field_boss_1, []}};
            true ->
                center:apply(ScenePlayer#scene_player.node, erlang, send_after, [1000, ScenePlayer#scene_player.pid, {apply_state, {field_boss, notice_field_boss_1, []}}])
        end
        end,
    lists:foreach(F, ScenePlayers),
    ok.
notice_field_boss_1([], Player) ->
    damage_info(Player),
    ok.