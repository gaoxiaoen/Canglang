%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 九月 2016 17:27
%%%-------------------------------------------------------------------
-module(prison).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("achieve.hrl").
%% API
-compile(export_all).

-define(PRISON_XY, {10, 17}).  %%监狱xy
-define(PROTECT_BUFF_ID, 56801). %%新手保护buff


%%罪恶值处理
check_pk_value(Player, Attacker) ->
    %%增加罪恶
    check_add_evil(Player, Attacker),
    %%增加侠义
    check_add_chivalry(Player, Attacker),
    %%增加击杀
    check_add_kill_count(Player, Attacker),
    %%红名掉东西
    NewPlayer = check_evil_drop(Player, Attacker),
    %%新手保护
    NewPlayer1 = check_protect(NewPlayer, Attacker),
    case Player#player.pk == NewPlayer1#player.pk of
        true -> skip;
        false -> scene_agent_dispatch:pk_value(NewPlayer1)
    end,
    NewPlayer1.


%%检查增加侠义值
check_add_chivalry(Player, Attacker) ->
    SceneType = scene:get_scene_type(Player#player.scene),
    case lists:member(SceneType, pk_scene_type()) of
        false ->
            ok;
        true ->
            RedNameVal = get_red_name_val(),
            %%击杀红名增加
            if Player#player.pk#pk.value > RedNameVal ->
                case scene:is_cross_scene(Player#player.scene) andalso Attacker#attacker.node /= none of
                    false ->
                        Attacker#attacker.pid ! {add_chivalry, Player#player.key, Player#player.pk#pk.value};
                    true ->
                        cross_area:apply(prison, chivalry_2kf, [Attacker#attacker.node, Attacker#attacker.pid, Player#player.key, Player#player.pk#pk.value]),
                        ok
                end;
                true -> ok
            end
    end.


chivalry_2kf(Node, Pid, Key, Evil) ->
    center:apply(Node, prison, chivalry_2local, [Pid, Key, Evil]).
chivalry_2local(Pid, Key, Evil) ->
    case is_pid(Pid) of
        false -> ok;
        true ->
            Pid ! {add_chivalry, Key, Evil}
    end.

%%增加侠义值
add_chivalry(Player, Key, Evil) ->
    Pk = Player#player.pk,
    RedNameVal = get_red_name_val(),
    if
        Pk#pk.pk =/= ?PK_TYPE_PEACE -> Player;
        Pk#pk.value > RedNameVal -> Player;
        true ->
            KeyKill = daily:get_count(?DAILY_PK_CHIVALRY(Key)),
            if
                KeyKill >= 5 -> Player;
                true ->
                    Add = get_kill_add_evil(Evil),
                    Chivalry = Pk#pk.chivalry + Add,
                    NewPk = Pk#pk{chivalry = Chivalry},
                    Player1 = Player#player{pk = NewPk},
                    scene_agent_dispatch:pk_value(Player1),
                    {NeedCheVal, CheDesId} = get_chivalry_add_des(),
                    case Chivalry >= NeedCheVal andalso Pk#pk.chivalry < NeedCheVal of
                        true ->
                            designation:add_designation(Player, CheDesId),
                            Title = ?T("pk提示"),
                            Content = ?T("侠肝义胆的你善良值超过75000点。御剑乘风去，除魔天地间。你获得称号[除魔卫道]"),
                            mail:sys_send_mail([Player#player.key], Title, Content),
                            ok;
                        false ->
                            ok
                    end,
                    daily:increment(?DAILY_PK_CHIVALRY(Key), 1),
                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3022, 0, Chivalry),
                    Player1
            end
    end.



check_add_kill_count(Player, Attacker) ->
    SceneType = scene:get_scene_type(Player#player.scene),
    case lists:member(SceneType, pk_scene_type()) of
        false ->
            ok;
        true ->
            case scene:is_cross_scene(Player#player.scene) andalso Attacker#attacker.node /= none of
                false ->
                    Attacker#attacker.pid ! {add_kill_count, Player#player.key};
                true ->
                    cross_area:apply(prison, add_kill_count_2kf, [Attacker#attacker.node, Attacker#attacker.pid, Player#player.key]),
                    ok
            end
    end.

add_kill_count_2kf(Node, Pid, Key) ->
    center:apply(Node, prison, add_kill_count_2local, [Pid, Key]).
add_kill_count_2local(Pid, Key) ->
    case is_pid(Pid) of
        false -> ok;
        true ->
            Pid ! {add_kill_count, Key}
    end.

%%增加杀人数
add_kill_count(Player, Pkey) ->
    Pk = Player#player.pk,
    KeyKill = daily:get_count(?DAILY_PK_EVIL(Pkey)),
    KillCount = ?IF_ELSE(KeyKill >= 3, Pk#pk.kill_count, Pk#pk.kill_count + 1),
    NewPk = Pk#pk{kill_count = KillCount},
    NewPlayer = Player#player{pk = NewPk},
    scene_agent_dispatch:pk_value(NewPlayer),
    daily:increment(?DAILY_PK_EVIL(Pkey), 1),
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3021, 0, KillCount),
    {NeedKillNum, DesId} = get_kill_add_des(),
    case KillCount >= NeedKillNum andalso Pk#pk.kill_count < NeedKillNum of
        true ->
            designation:add_designation(Player, DesId),
            Title = ?T("pk提示"),
            Content = ?T("冷血无情的你屠戮了超过500名和平玩家。血汇三途河，白骨筑王座。你获得称号[无恶不作]"),
            mail:sys_send_mail([Player#player.key], Title, Content),
            ok;
        false ->
            ok
    end,
    NewPlayer.

%%设置侠义值
set_chivalry(Player, Value) ->
    Pk = Player#player.pk,
    Chivalry = max(0, Value),
    NewPk = Pk#pk{chivalry = Chivalry, value = 0},
    NewPlayer = Player#player{pk = NewPk},
    scene_agent_dispatch:pk_value(NewPlayer),
    {NeedCheVal, CheDesId} = get_chivalry_add_des(),
    case Chivalry >= NeedCheVal of
        true ->
            designation:add_designation(Player, CheDesId),
            Title = ?T("pk提示"),
            Content = ?T("侠肝义胆的你善良值超过75000点。御剑乘风去，除魔天地间。你获得称号[除魔卫道]"),
            mail:sys_send_mail([Player#player.key], Title, Content),
            ok;
        false ->
            ok
    end,
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3022, 0, Chivalry),
    NewPlayer.

pk_scene_type() -> [0, 10, 11, 12, 14].

%%检查是否需要增加罪恶
check_add_evil(Player, Attacker) ->
    %%“全体模式”攻击>45级“和平模式”的玩家会增加杀戮值
    SceneType = scene:get_scene_type(Player#player.scene),
    case lists:member(SceneType, pk_scene_type()) of
        false ->
            ok;
        true ->
            RedNameVal = get_red_name_val(),
            ProtectLv = get_protect_lv(),
            if Player#player.pk#pk.value =< RedNameVal andalso Player#player.lv > ProtectLv andalso Player#player.pk#pk.pk == ?PK_TYPE_PEACE ->
                log_kill_player(Attacker#attacker.key, Attacker#attacker.name, Attacker#attacker.lv, Attacker#attacker.pk_status, Player#player.key, Player#player.nickname, Player#player.lv, Player#player.pk#pk.pk),
                case scene:is_cross_scene(Player#player.scene) of
                    false ->
                        Attacker#attacker.pid ! {add_evil, Player#player.key};
                    true ->
                        cross_area:apply(prison, evil_2kf, [Attacker#attacker.node, Attacker#attacker.pid, Player#player.key]),
                        ok
                end;
                true ->
                    ok
            end
    end.

evil_2kf(Node, Pid, Key) ->
    center:apply(Node, prison, evil_2local, [Pid, Key]).
evil_2local(Pid, Key) ->
    case is_pid(Pid) of
        false -> ok;
        true ->
            Pid ! {add_evil, Key}
    end.

%%设置罪恶值
gm_set_evil(Player, Value) ->
    Pk = Player#player.pk,
    MaxVal = get_prison_val(),
    NewVal = min(MaxVal, max(0, Value)),
    NewPk = Pk#pk{value = NewVal, chivalry = 0},
    NewPlayer = Player#player{pk = NewPk},
    scene_agent_dispatch:pk_value(NewPlayer),
    RedNameVal = get_red_name_val(),
    %%红名到1000,关监狱
    PrisonVal = get_prison_val(),
    if
        NewPk#pk.value >= PrisonVal ->
            {X, Y} = ?PRISON_XY,
            notice_sys:add_notice(prison, [NewPlayer]),
            scene_change:change_scene(NewPlayer, ?SCENE_ID_PRISON, 0, X, Y, false);
        Player#player.scene == ?SCENE_ID_PRISON andalso Value < RedNameVal ->
            scene_change:change_scene_back(NewPlayer);
        true ->
            NewPlayer
    end.

%%增加罪恶值
add_evil(Player, _Key) ->
    Add = get_kill_add_evil(Player#player.pk#pk.value),
    Pk = Player#player.pk,
    %%英雄值优先抵消杀戮
    {Chivalry, NewAdd} = ?IF_ELSE(Pk#pk.chivalry >= Add, {Pk#pk.chivalry - Add, 0}, {0, Add - Pk#pk.chivalry}),
    MaxVal = get_prison_val(),
    NewVal = min(MaxVal, Pk#pk.value + NewAdd),
    log_player_evil(Player#player.key, Player#player.nickname, Pk#pk.value, NewVal),

    NewPk = Pk#pk{value = NewVal, chivalry = Chivalry},
    NewPlayer = Player#player{pk = NewPk},
    scene_agent_dispatch:pk_value(NewPlayer),
    %%红名到1000,关监狱
    PrisonVal = get_prison_val(),
    if
        NewPk#pk.value >= PrisonVal ->
            {X, Y} = ?PRISON_XY,
            notice_sys:add_notice(prison, [NewPlayer]),
            scene_change:change_scene(NewPlayer, ?SCENE_ID_PRISON, 0, X, Y, false);
        true ->
            NewPlayer
    end.

%%设置杀人数目
set_kill_count(Player, Value) ->
    Pk = Player#player.pk,
    NewPk = Pk#pk{kill_count = max(0, Value)},
    NewPlayer = Player#player{pk = NewPk},
    {NeedKillNum, DesId} = get_kill_add_des(),
    case Value >= NeedKillNum of
        true ->
            designation:add_designation(Player, DesId),
            Title = ?T("pk提示"),
            Content = ?T("冷血无情的你屠戮了超过500名和平玩家。血汇三途河，白骨筑王座。你获得称号[无恶不作]"),
            mail:sys_send_mail([Player#player.key], Title, Content),
            ok;
        false ->
            ok
    end,
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3021, 0, Value),
    PrisonVal = get_prison_val(),
    if NewPk#pk.value > PrisonVal ->
        notice_sys:add_notice(prison, [NewPlayer]),
        {X, Y} = ?PRISON_XY,
        scene_change:change_scene(NewPlayer, ?SCENE_ID_PRISON, 0, X, Y, false);
        true ->
            NewPlayer
    end.

%%减少罪恶值
sub_evil(Player, Evil) ->
    NewPlayer = sub_evil_only(Player, Evil),
    RedNameVal = get_red_name_val(),
    if
        Player#player.scene == ?SCENE_ID_PRISON andalso NewPlayer#player.pk#pk.value < RedNameVal ->
            scene_change:change_scene_back(NewPlayer);
        true ->
            NewPlayer
    end.

%%减少罪恶值
sub_evil_only(Player, Evil) ->
    if
        Player#player.pk#pk.value > 0 ->
            Pk = Player#player.pk,
            Value = max(0, Pk#pk.value - Evil),
            NewPk = Pk#pk{value = Value},
            NewPlayer = Player#player{pk = NewPk},
            scene_agent_dispatch:pk_value(NewPlayer),
            NewPlayer;
        true ->
            Player
    end.

check_evil_drop(Player, Attacker) ->
    case scene:is_normal_scene(Player#player.scene) andalso Attacker#attacker.sign == ?SIGN_PLAYER of
        false -> Player;
        true ->
            RedNameVal = get_red_name_val(),
            %%红黑名玩家掉金币
            if Player#player.pk#pk.value > RedNameVal ->
                Player1 = drop_coin(Player),
                drop_goods(Player1),
                Player1;
                true ->
                    Player
            end
    end.

%%掉落金币
drop_coin(Player) ->
    Ratio = data_prison:get_drop_coin(),
    Coin = round(Player#player.coin * Ratio),
    case money:is_enough(Player, Coin, coin) of
        true ->
            {X, Y} = scene:random_xy(Player#player.scene, Player#player.x, Player#player.y),
            GiveGoods = #give_goods{goods_id = 10101, num = Coin, bind = 0, from = 307},
            drop:drop_goods(Player, 0, GiveGoods, 0, 1, X, Y),
            money:add_coin(Player, -Coin, 307, 0, 0);
        false -> Player
    end.

%%掉落物品
drop_goods(Player) ->
    case goods:get_unbind_goods_id_list(?GOODS_LOCATION_BAG) of
        [] -> ok;
        GoodsIds ->
            GoodsId = util:list_rand(GoodsIds),
            goods:subtract_good(Player, [{GoodsId, 1}], 307),
            {X, Y} = scene:random_xy(Player#player.scene, Player#player.x, Player#player.y),
            GiveGoods = #give_goods{goods_id = GoodsId, num = 1, bind = 0, from = 307},
            drop:drop_goods(Player, 0, GiveGoods, 0, 1, X, Y),
            ok
    end.


%%退出监狱
quit_prison(Player) ->
    if Player#player.scene /= ?SCENE_ID_PRISON ->
        {2, Player};
        Player#player.pk#pk.value > 0 ->
            {3, Player};
        true ->
            NewPlayer = scene_change:change_scene_back(Player),
            {1, NewPlayer}
    end.

%%洗刷罪恶
clean_evil(Player) ->
    if Player#player.pk#pk.value > 0 ->
        Ratio = data_prison:get_clean_evil_gold(),
        Gold = util:ceil(Player#player.pk#pk.value * Ratio),
        case money:is_enough(Player, Gold, bgold) of
            false -> {5, Player};
            true ->
                Player1 = money:add_gold(Player, -Gold, 193, 0, 0),
                Player2 = sub_evil(Player1, Player#player.pk#pk.value),
                {1, Player2}
        end;
        true -> {4, Player}
    end.

%%放狗
release_dog(Player) ->
    DogId = 37001,
    case mon_agent:get_scene_mon_by_mid(?SCENE_ID_PRISON, DogId) of
        [] ->
            GogGold = data_prison:get_dog_cost_gold(),
            case money:is_enough(Player, GogGold, bgold) of
                false -> {7, Player};
                true ->
                    Player1 = money:add_gold(Player, -GogGold, 194, 0, 0),
                    mon_agent:create_mon_cast([DogId, ?SCENE_ID_PRISON, 11, 26, 0, 1, [{group, 1}]]),
                    {1, Player1}
            end;
        _ ->
            {6, Player}
    end.

%%贿赂
bribe(Player) ->
    case scene:is_prison_scene(Player#player.scene) of
        false -> {8, Player};
        true ->
            if Player#player.pk#pk.value == 0 -> {11, Player};
                true ->
                    Gold = data_prison:get_bribe_cost_gold(),
                    case money:is_enough(Player, Gold, bgold) of
                        false -> {9, Player};
                        true ->
                            Player1 = money:add_gold(Player, -Gold, 306, 0, 0),
                            {R, M} = data_prison:get_release_prison(),
                            case util:odds(R, M) of
                                true ->
%%                                    SubEvil = data_prison:get_sub_evil_only(),
                                    Player2 = sub_evil_only(Player1, 1500),
                                    NewPlayer = scene_change:change_scene_back(Player2),
                                    {1, NewPlayer};
                                false -> {10, Player1}
                            end
                    end
            end

    end.

%%检查新手保护
check_protect(Player, Attacker) ->
    {MinLv, MaxLv} = get_first_kill_protect_lv(),
    if
        Attacker#attacker.sign =/= ?SIGN_PLAYER -> Player;
        not (Player#player.lv >= MinLv andalso Player#player.lv =< MaxLv) -> Player;
        true ->
            case scene:is_normal_scene(Player#player.scene) orelse
                scene:is_cross_normal_scene(Player#player.scene) of
                false -> Player;
                true ->
                    ProtectTime = data_prison:get_first_kill_protect_time(),
                    Now = util:unixtime(),
                    NewPk = Player#player.pk#pk{
                        protect_time = Now + ProtectTime
                    },
                    Player1 = Player#player{
                        pk = NewPk
                    },
                    buff_init:add_buff(?PROTECT_BUFF_ID),
                    buff:add_buff_to_player(Player1, ?PROTECT_BUFF_ID)
            end
    end.

%%获取红名罪恶值
get_red_name_val() ->
    data_prison:get_evil_red_val().

%%获取送进监狱所需罪恶值
get_prison_val() ->
    data_prison:get_prison_val().

%%保护等级
get_protect_lv() ->
    data_prison:get_protect_lv().

%%获取首杀保护等级
get_first_kill_protect_lv() ->
    data_prison:get_first_kill_protect_lv().

%%获取击杀数与获得称号id 返回：{num,des_id}
get_kill_add_des() ->
    data_prison:get_kill_num_add_des().

%%获取红名杀手英雄值和称号id
get_chivalry_add_des() ->
    data_prison:get_chivalry_add_des().

%%获取击杀增加罪恶值
get_kill_add_evil(EvilVal) ->
    L = data_prison:get_kill_add_evil(),
    get_kill_add_evil_1(L, EvilVal).
get_kill_add_evil_1([], _) -> 0;
get_kill_add_evil_1([{{Min, Max}, Add} | _Tail], EvilVal) when Min =< EvilVal andalso Max > EvilVal ->
    Add;
get_kill_add_evil_1([_ | Tail], EvilVal) ->
    get_kill_add_evil_1(Tail, EvilVal).

enter_prison(Player) ->
    RedNameVal = prison:get_red_name_val(),
    %%非红名玩家和怪物同组，避免被击
    case Player#player.pk#pk.value > RedNameVal of
        true -> Player#player{group = 0};
        false -> Player#player{group = 1}
    end.

exit_prison(Player) ->
    Player#player{group = 0}.

%%超过保护等级，去掉相应buff
protect_check(Player, Lv) ->
    {_Lv1, Lv2} = data_prison:get_first_kill_protect_lv(),
    case Lv == Lv2 + 1 of
        true ->
            del_protect(Player);
        false ->
            Player
    end.

%%去掉保护
del_protect(Player) ->
    NewPk = Player#player.pk#pk{
        protect_time = 0
    },
    Player1 = Player#player{
        pk = NewPk
    },
    scene_agent_dispatch:pk_value(Player1),
    buff_init:del_buff(?PROTECT_BUFF_ID),
    buff:del_buff(Player, ?PROTECT_BUFF_ID),
    Player1.

%%更新累计挂机
update_online_time(Player, Now) ->
    Pk = Player#player.pk,
    case Pk#pk.value > 0 of
        true ->
            AddTime = max(0, Now - Pk#pk.calc_time),
            NewTime = AddTime + Pk#pk.online_time,
            case NewTime > 3600 of
                true ->
                    DelVal = data_prison:get_time_del_evil(),
                    NewPk = Pk#pk{
                        online_time = NewTime - 3600,
                        calc_time = Now
                    },
                    Player1 = Player#player{pk = NewPk},
                    sub_evil(Player1, DelVal);
                false ->
                    NewPk = Pk#pk{
                        online_time = NewTime,
                        calc_time = Now
                    },
                    Player#player{pk = NewPk}
            end;
        false ->
            NewPk = Pk#pk{
                online_time = 0,
                calc_time = Now
            },
            Player#player{
                pk = NewPk
            }
    end.

log_kill_player(AttKey, AttName, AttLv, AttPkStatus, Derkey, DerNickname, DerLv, DerPkState) ->
    Sql = io_lib:format("insert into  log_kill_player (att_key, att_name,att_lv,att_pk_state,der_key, der_name,der_lv,der_pk_state, time)
     VALUES(~p,'~s',~p,~p,~p,'~s',~p,~p,~p)",
        [AttKey, AttName, AttLv, AttPkStatus, Derkey, DerNickname, DerLv, DerPkState, util:unixtime()]),
    log_proc:log(Sql),
    ok.

log_player_evil(Pkey, Pname, Old, New) ->
    Sql = io_lib:format("insert into  log_player_evil (pkey,pname,old_evil,new_evil, time) VALUES(~p,'~s',~p,~p,~p)",
        [Pkey, Pname, Old, New, util:unixtime()]),
    log_proc:log(Sql),
    ok.