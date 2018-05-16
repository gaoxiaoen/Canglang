%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 十一月 2015 11:12
%%%-------------------------------------------------------------------
-module(treasure).
-author("hxming").

-include("server.hrl").
-include("treasure.hrl").
-include("scene.hrl").
-include("common.hrl").
-include("drop.hrl").
-include("task.hrl").
-include("goods.hrl").
-define(KILL_LIMIT, 20).
%% API
-export([
    init/1
    , timer_update/0
    , logout/0
    , refresh_midnight/1
    , treasure_info/2
    , treasure_transport/2
    , treasure_hunt/2
    , check_kill_limit/3
    , check_treasure_times/1
    , cmd_check_pos/0
]).


%%初始化
init(Player) ->
    Now = util:unixtime(),
    case player_util:is_new_role(Player) of
        true ->
            Treasure = #treasure{pkey = Player#player.key, time = Now, is_change = 1},
            set_treasure1(Treasure);
        false ->
            case treasure_load:select_treasure(Player#player.key) of
                [] ->
                    Treasure = #treasure{pkey = Player#player.key, time = Now, is_change = 1},
                    set_treasure1(Treasure);
                [MapId, Scene, X, Y, ShadowKill, PetKill, Time, Times] ->
                    case util:is_same_date(Now, Time) of
                        true ->
                            Treasure =
                                #treasure{pkey = Player#player.key, map_id = MapId, scene = Scene, x = X, y = Y, shadow_kill = ShadowKill, pet_kill = PetKill, time = Time, times = Times},
                            set_treasure1(Treasure);
                        false ->
                            Treasure =
                                #treasure{pkey = Player#player.key, map_id = MapId, scene = Scene, x = X, y = Y, time = Now},
                            set_treasure(Treasure)
                    end
            end
    end,
    Player.

%%玩家离线
logout() ->
    Treasure = get_treasure(),
    if Treasure#treasure.is_change /= 0 ->
        treasure_load:replace_treasure(Treasure);
        true -> skip
    end.

timer_update() ->
    Treasure = get_treasure(),
    if Treasure#treasure.is_change /= 0 ->
        treasure_load:replace_treasure(Treasure),
        set_treasure1(Treasure#treasure{is_change = 0});
        true -> skip
    end.

%%零点刷新
refresh_midnight(Now) ->
    Treasure = get_treasure(),
    NewTreasure = Treasure#treasure{shadow_kill = 0, pet_kill = 0, time = Now, times = 0},
    set_treasure(NewTreasure),
    ok.

set_treasure(Treasure) ->
    lib_dict:put(?PROC_STATUS_TREASURE, Treasure#treasure{is_change = 1}).
set_treasure1(Treasure) ->
    lib_dict:put(?PROC_STATUS_TREASURE, Treasure).

get_treasure() ->
    lib_dict:get(?PROC_STATUS_TREASURE).


%%检查藏宝图次数
check_treasure_times(Player) ->
    Treasure = get_treasure(),
    MaxTimes = data_vip_args:get(15, Player#player.vip_lv),
    ?IF_ELSE(Treasure#treasure.times >= MaxTimes, 0, 1).

%%获取藏宝图信息
treasure_info(Player, MapId) ->
    Treasure = get_treasure(),
    MaxTimes = data_vip_args:get(15, Player#player.vip_lv),
    if Treasure#treasure.times >= MaxTimes ->
        {11, 0, 0, 0, 0};
        Treasure#treasure.map_id == MapId ->
            {1, MapId, Treasure#treasure.scene, Treasure#treasure.x, Treasure#treasure.y};
        true ->
            case data_treasure:get(MapId, Player#player.lv) of
                [] ->
                    {2, 0, 0, 0, 0};
                Base ->
                    {Scene, X, Y} = util:list_rand(Base#base_treasure.use_area),
                    NewTreasure = Treasure#treasure{map_id = MapId, scene = Scene, x = X, y = Y},
                    set_treasure(NewTreasure),
                    {1, MapId, Scene, X, Y}
            end
    end.

%%藏宝图传送
treasure_transport(Player, MapId) ->
    Treasure = get_treasure(),
    VipState = data_vip_args:get(16, Player#player.vip_lv),
    if
        Treasure#treasure.map_id =/= MapId -> {3, Player};
        VipState == 0 -> {4, Player};
        true ->
            case scene:is_normal_scene(Player#player.scene) of
                false -> {5, Player};
                true ->
                    Copy = scene_copy_proc:get_scene_copy(Treasure#treasure.scene, Player#player.copy),
                    NewPlayer = scene_change:change_scene(Player, Treasure#treasure.scene, Copy, Treasure#treasure.x, Treasure#treasure.y, false),
                    {1, NewPlayer}
            end
    end.


%%挖宝
treasure_hunt(Player, MapId) ->
    Treasure = get_treasure(),
    MaxTimes = data_vip_args:get(15, Player#player.vip_lv),
    if Treasure#treasure.map_id /= MapId -> {6, Player, []};
        Player#player.scene /= Treasure#treasure.scene -> {7, Player, []};
        Treasure#treasure.times >= MaxTimes ->
            {11, Player, []};
        true ->
            case check_position(Player#player.x, Player#player.y, Treasure#treasure.x, Treasure#treasure.y) of
                false ->
                    ?ERR("treasure pos err player ~p/~p map ~p/~p~n", [Player#player.x, Player#player.y, Treasure#treasure.x, Treasure#treasure.y]),
                    NewPlayer = scene_change:change_scene(Player, Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, false),
                    {8, NewPlayer, []};
                true ->
                    case data_treasure:get(MapId, Player#player.lv) of
                        [] -> {2, Player, []};
                        Base ->
                            case goods:subtract_good(Player, [{MapId, 1}], 51) of
                                {ok, _} ->
                                    Act = util:list_rand_ratio(Base#base_treasure.map_type),
                                    {NewPlayer, GoodList} = map_act(Act, Player, Base),
                                    NewTreasure = Treasure#treasure{map_id = 0, scene = 0, x = 0, y = 0, times = Treasure#treasure.times + 1},
                                    set_treasure(NewTreasure),
                                    task_event:event(?TASK_ACT_TREASURE, {1}),
                                    task_event:event(?TASK_ACT_TREASURE_BY_ID, {MapId, 1}),
                                    treasure_load:log_treasure(Player#player.key, Player#player.nickname, MapId, Act, util:unixtime()),
                                    {1, NewPlayer, goods:pack_goods(GoodList)};
                                _ -> {9, Player, []}
                            end
                    end
            end
    end.

%%检查位置
check_position(X, Y, TarX, TarY) ->
    TarX - 3 =< X andalso X =< TarX + 3 andalso TarY - 3 =< Y andalso Y =< TarY + 3.

%%直接掉落
map_act(1, Player, Base) ->
    DropId = util:list_rand(Base#base_treasure.drop_normal),
    drop_goods(Player, DropId);
%%玩家镜像
map_act(2, Player, Base) ->
    MonId = util:list_rand(Base#base_treasure.shadow_list),
    SceneId = util:list_rand_ratio(Base#base_treasure.shadow_area),
    AreaList =
        case data_treasure_pos:get(SceneId) of
            [] -> [];
            Val -> tuple_to_list(Val)
        end,
    Shadow = shadow_init:init_shadow(Player),
    NewShadow = Shadow#player{shadow = #st_shadow{att_per = 1, hp_per = 0.5, def_m_per = 0.5, def_p_per = 0.5}},
    F = fun({X, Y}) ->
        {NewX, NewY} = scene:random_xy(SceneId, X, Y),
        shadow:create_shadow_for_treasure(NewShadow, MonId, SceneId, 0, NewX, NewY, [{life, Base#base_treasure.life_time}])
        end,
    lists:foreach(F, util:get_random_list(AreaList, 3)),
%%     notice_sys:add_notice(treasure_player, [Player, scene:get_scene_name(SceneId)]),
    DropId = util:list_rand(Base#base_treasure.drop_shadow),
    drop_goods(Player, DropId);
%%精英怪
map_act(3, Player, Base) ->
    MonId = util:list_rand(Base#base_treasure.pet_list),
    {SceneId, AreaList} = util:list_rand(Base#base_treasure.pet_area),
    F = fun({X, Y}) ->
        {NewX, NewY} = scene:random_xy(SceneId, X, Y),
        mon_agent:create_mon_cast([MonId, SceneId, NewX, NewY, 0, 1, [{owner_key, Player#player.key}, {life, Base#base_treasure.life_time}]])
        end,
    lists:foreach(F, util:get_random_list(AreaList, 3)),
    %%公告
%%     notice_sys:add_notice(treasure_pet_mon, [Player, scene:get_scene_name(SceneId)]),
    DropId = util:list_rand(Base#base_treasure.drop_pet),
    drop_goods(Player, DropId);

map_act(_, Player, _) ->
    {Player, []}.

%%挖宝掉落
drop_goods(Player, DropId) ->
    DropInfo = #drop_info{lvdown = Player#player.lv, lvup = Player#player.lv, career = Player#player.career, order = 1, rank = 1, perc = 100},
    GoodsList = drop:get_goods_from_drop_rule(DropId, DropInfo),
    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(51, GoodsList)),
    %%挖宝公告
    F = fun(GoodsGive) ->
        case data_goods:get(GoodsGive#give_goods.goods_id) of
            [] -> skip;
            _Goods -> skip
%%                 if Goods#goods_type.type == ?GOODS_TYPE_EQUIP ->
%%                     notice_sys:add_notice(treasure_drop_goods, [Player, Goods#goods_type.goods_name, Goods#goods_type.goods_id]);
%%                     true -> skip
%%                 end
        end
        end,
    lists:foreach(F, GoodsList),
    {NewPlayer, GoodsList}.

%%检查是否击杀到上限
check_kill_limit(Player, MonKind, OwnerKey) ->
    kill_check(MonKind, Player, OwnerKey).


kill_check(?MON_KIND_TREASURE_MON, Player, _OwnerKey) ->
    Treasure = get_treasure(),
    KillLimit = data_vip_args:get(17, Player#player.vip_lv),
    if Treasure#treasure.pet_kill >= KillLimit ->
        NewPlayer = money:add_coin(Player, 1000, 17, 0, 0),
        {ok, Bin} = pt_151:write(15103, {10, [[?GOODS_SUBTYPE_COIN, 1000]]}),
        server_send:send_to_sid(Player#player.sid, Bin),
        {false, NewPlayer};
%%        OwnerKey == Player#player.key ->
%%            NewTreasure = Treasure#treasure{shadow_kill = Treasure#treasure.shadow_kill + 1},
%%            set_treasure(NewTreasure),
%%            NewPlayer = money:add_coin(Player, 1000, 17),
%%            {ok, Bin} = pt_151:write(15103, {12, [[?GOODS_SUBTYPE_COIN, 1000]]}),
%%            server_send:send_to_sid(Player#player.sid, Bin),
%%            {false, NewPlayer};
        true ->
            NewTreasure = Treasure#treasure{pet_kill = Treasure#treasure.pet_kill + 1},
            set_treasure(NewTreasure),
            true
    end;
kill_check(?MON_KIND_TREASURE_PET, Player, _OwnerKey) ->
    Treasure = get_treasure(),
    KillLimit = data_vip_args:get(17, Player#player.vip_lv),
    if Treasure#treasure.shadow_kill >= KillLimit ->
        NewPlayer = money:add_coin(Player, 1000, 17, 0, 0),
        {ok, Bin} = pt_151:write(15103, {10, [[?GOODS_SUBTYPE_COIN, 1000]]}),
        server_send:send_to_sid(Player#player.sid, Bin),
        {false, NewPlayer};
%%        OwnerKey == Player#player.key ->
%%            NewTreasure = Treasure#treasure{shadow_kill = Treasure#treasure.shadow_kill + 1},
%%            set_treasure(NewTreasure),
%%            NewPlayer = money:add_coin(Player, 1000, 17),
%%            {ok, Bin} = pt_151:write(15103, {12, [[?GOODS_SUBTYPE_COIN, 1000]]}),
%%            server_send:send_to_sid(Player#player.sid, Bin),
%%            {false, NewPlayer};
        true ->
            NewTreasure = Treasure#treasure{shadow_kill = Treasure#treasure.shadow_kill + 1},
            set_treasure(NewTreasure),
            true
    end.


cmd_check_pos() ->
    F = fun(Lv) ->
        pos_check([23001, 23002, 23003], Lv)
        end,
    lists:foreach(F, lists:seq(1, 100)),
    ok.

pos_check([], _Lv) -> skip;
pos_check([Gid | T], Lv) ->
    case data_treasure:get(Gid, Lv) of
        [] -> skip;
        Base ->
            F = fun(Item) ->
                case scene_mark:is_blocked(Item) of
                    true ->
                        ?ERR("gid:~p scene:~p~n", [Gid, Item]);
                    false -> skip
                end
                end,
            lists:foreach(F, Base#base_treasure.use_area),
            ok
    end,
    pos_check(T, Lv).