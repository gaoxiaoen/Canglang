%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十二月 2016 17:07
%%%-------------------------------------------------------------------
-module(hp_pool).
-author("hxming").

-include("server.hrl").
-include("hp_pool.hrl").
-include("common.hrl").

%% API
-compile(export_all).

%%初始化
init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_HP_POOL, #st_hp_pool{pkey = Player#player.key});
        false ->
            case get_row(Player) of
                [] ->
                    lib_dict:put(?PROC_STATUS_HP_POOL, #st_hp_pool{pkey = Player#player.key});
                [Hp, Recover] ->
                    lib_dict:put(?PROC_STATUS_HP_POOL, #st_hp_pool{pkey = Player#player.key, hp = Hp, recover = Recover})
            end
    end,
    Player.

get_row(Player) ->
    Sql = io_lib:format("select hp,recover from hp_pool where pkey=~p", [Player#player.key]),
    db:get_row(Sql).

replace(St) ->
    Sql = io_lib:format("replace into hp_pool set pkey=~p,hp=~p,recover=~p",
        [St#st_hp_pool.pkey, St#st_hp_pool.hp, St#st_hp_pool.recover]),
    db:execute(Sql).

%%定时更新
timer_update() ->
    St = lib_dict:get(?PROC_STATUS_HP_POOL),
    if St#st_hp_pool.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_HP_POOL, St#st_hp_pool{is_change = 0}),
        replace(St);
        true ->
            ok
    end.

%%离线
logout() ->
    St = lib_dict:get(?PROC_STATUS_HP_POOL),
    if St#st_hp_pool.is_change == 1 ->
        replace(St);
        true ->
            ok
    end.


%%获取血池信息
get_hp_pool() ->
    St = lib_dict:get(?PROC_STATUS_HP_POOL),
    {St#st_hp_pool.hp, St#st_hp_pool.recover}.

%%设置阈值
set_recover(Recover) ->
%%    case lists:member(Recover, tuple_to_list(data_hp_pool:hp_percent())) of
%%        false -> 2;
%%        true ->
    St = lib_dict:get(?PROC_STATUS_HP_POOL),
    NewSt = St#st_hp_pool{recover = Recover, is_change = 1},
    lib_dict:put(?PROC_STATUS_HP_POOL, NewSt),
    1.
%%    end.

%%使用血包
use_goods(Player, GoodsId, Num) ->
    case data_hp_pool_goods:get(GoodsId) of
        [] -> {3, 0};
        Base ->
            St = lib_dict:get(?PROC_STATUS_HP_POOL),
            Hp = round(Base#base_hp_pool_goods.hp * Num),
            Count = goods_util:get_goods_count(GoodsId),
            if Count < Num ->
                goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 205),
                {4, 0};
                St#st_hp_pool.hp + Hp > 2100000000 -> {0, 0};
                true ->
                    NewSt = St#st_hp_pool{hp = St#st_hp_pool.hp + Hp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_HP_POOL, NewSt),
                    goods:subtract_good(Player, [{GoodsId, Num}], 205),
                    {1, NewSt#st_hp_pool.hp}
            end
    end.

%%增加血量
add_hp(GoodsId, Num) ->
    case data_hp_pool_goods:get(GoodsId) of
        [] -> ok;
        Base ->
            Hp = round(Base#base_hp_pool_goods.hp * Num),
            St = lib_dict:get(?PROC_STATUS_HP_POOL),
            NewSt = St#st_hp_pool{hp = St#st_hp_pool.hp + Hp, is_change = 1},
            lib_dict:put(?PROC_STATUS_HP_POOL, NewSt)
    end.

%%购买血包
buy_goods(Player, GoodsId, Num) ->
    case data_hp_pool_goods:get(GoodsId) of
        [] -> {3, 0, Player};
        Base ->
            Price = Base#base_hp_pool_goods.price * Num,
            case check_price(Player, Base#base_hp_pool_goods.price_type, Price, GoodsId, Num) of
                {false, Err} -> {Err, 0, Player};
                NewPlayer ->
                    Hp = round(Base#base_hp_pool_goods.hp * Num),
                    St = lib_dict:get(?PROC_STATUS_HP_POOL),
                    NewSt = St#st_hp_pool{hp = St#st_hp_pool.hp + Hp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_HP_POOL, NewSt),
                    {1, NewSt#st_hp_pool.hp, NewPlayer}
            end
    end.

%%检查价格
check_price(Player, Type, Price, GoodsId, Num) ->
    case Type of
        1 ->
            case money:is_enough(Player, Price, coin) of
                false -> {false, 5};
                true ->
                    NewPlayer = money:add_coin(Player, -Price, 206, GoodsId, Num),
                    NewPlayer
            end;
        _ ->
            case money:is_enough(Player, Price, bgold) of
                false -> {false, 6};
                true ->
                    NewPlayer = money:add_gold(Player, -Price, 206, GoodsId, Num),
                    NewPlayer
            end
    end.


%%恢复血量
recover_hp(Player) ->
    case lists:member(Player#player.scene, data_hp_pool:scene_lim()) of
        true -> {7, 0, Player};
        false ->
            SceneType = scene:get_scene_type(Player#player.scene),
            case lists:member(SceneType, tuple_to_list(data_hp_pool:scene_type())) of
                false -> {7, 0, Player};
                true ->
                    St = lib_dict:get(?PROC_STATUS_HP_POOL),
                    Now = util:unixtime(),
                    if St#st_hp_pool.cd > Now ->
                        {8, 0, Player};
                        St#st_hp_pool.hp =< 0 -> {9, 0, Player};
                        true ->
                            HpLim = Player#player.attribute#attribute.hp_lim,
                            if Player#player.hp > HpLim ->
                                {10, 0, Player};
                                true ->
                                    Hp = min(HpLim - Player#player.hp, data_hp_recover:get(Player#player.lv)),
                                    Cd = Now + data_hp_pool:recover_cd(),
                                    NewSt = St#st_hp_pool{hp = max(0, St#st_hp_pool.hp - Hp), cd = Cd, is_change = 1},
                                    lib_dict:put(?PROC_STATUS_HP_POOL, NewSt),
                                    Player2 = Player#player{hp = Player#player.hp + Hp},
                                    {ok, Bin} = pt_200:write(20004, {[[?SIGN_PLAYER, Player#player.key, 1, Hp, Player2#player.hp]]}),
                                    server_send:send_to_sid(Player#player.sid, Bin),
                                    scene_agent_dispatch:hpmp_update(Player2),
                                    {1, NewSt#st_hp_pool.hp, Player2}
                            end
                    end
            end
    end.

%%系统自动回血
recover_hp_sys(Player, Now) ->
    case lists:member(Player#player.scene, data_hp_pool:scene_lim()) of
        true -> Player;
        false ->
            SceneType = scene:get_scene_type(Player#player.scene),
            case lists:member(SceneType, tuple_to_list(data_hp_pool:scene_type())) of
                false -> Player;
                true ->
                    St = lib_dict:get(?PROC_STATUS_HP_POOL),
                    HpLim = Player#player.attribute#attribute.hp_lim,
                    ReLim = round(HpLim * St#st_hp_pool.recover / 100),
                    if St#st_hp_pool.hp =< 0 -> Player;
                        Player#player.hp >= ReLim -> Player;
                        Player#player.hp =< 0 -> Player;
                        true ->
                            Hp = min(HpLim - Player#player.hp, data_hp_recover:get(Player#player.lv)),
                            Cd = Now + data_hp_pool:recover_cd(),
                            NewSt = St#st_hp_pool{hp = max(0, St#st_hp_pool.hp - Hp), cd = Cd, is_change = 1},
                            lib_dict:put(?PROC_STATUS_HP_POOL, NewSt),
                            Player2 = Player#player{hp = Player#player.hp + Hp},
                            {ok, Bin} = pt_200:write(20004, {[[?SIGN_PLAYER, Player#player.key, 1, Hp, Player2#player.hp]]}),
                            server_send:send_to_sid(Player#player.sid, Bin),
                            scene_agent_dispatch:hpmp_update(Player2),
                            Player2
                    end
            end
    end.
