%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     神器副本
%%% @end
%%% Created : 15. 五月 2017 19:54
%%%-------------------------------------------------------------------
-module(dungeon_god_weapon).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("dungeon.hrl").
-include("tips.hrl").
-include("task.hrl").
-include("achieve.hrl").

%% API
-export([init/2,
    midnight_refresh/1,
    timer_update/0,
    logout/0,
    dungeon_list/0,
    sweep/1,
    get_cur_layer/0,
    check_enter/2,
    check_enter_state/2,
    get_enter_dungeon_extra/1,
    update_dun_god_weapon_layer/4,
    dungeon_god_weapon_ret/4,
    is_first_pass/4,
    get_notice_player/1,
    check_sweep/0,
    check_sweep_state/1
]).

init(Player, Now) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_DUN_GOD_WEAPON, #st_dun_god_weapon{pkey = Player#player.key, time = Now});
        false ->
            case dungeon_load:load_dun_god_weapon(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_DUN_GOD_WEAPON, #st_dun_god_weapon{pkey = Player#player.key, time = Now});
                [Layer, LayerH, Round, RoundH, Time] ->
                    case util:is_same_date(Now, Time) of
                        true ->
                            lib_dict:put(?PROC_STATUS_DUN_GOD_WEAPON, #st_dun_god_weapon{pkey = Player#player.key, layer = Layer, layer_h = LayerH, round = Round, round_h = RoundH, time = Time});
                        false ->
                            lib_dict:put(?PROC_STATUS_DUN_GOD_WEAPON, #st_dun_god_weapon{pkey = Player#player.key, layer_h = LayerH, round_h = RoundH, time = Now, is_change = 1})
                    end
            end
    end.

midnight_refresh(Now) ->
    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    NewSt = St#st_dun_god_weapon{layer = 0, round = 0, time = Now, is_change = 1},
    lib_dict:put(?PROC_STATUS_DUN_GOD_WEAPON, NewSt),
    ok.

timer_update() ->
    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    if St#st_dun_god_weapon.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_DUN_GOD_WEAPON, St#st_dun_god_weapon{is_change = 0}),
        dungeon_load:replace_dun_god_weapon(St);
        true -> ok
    end.

logout() ->
    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    if St#st_dun_god_weapon.is_change == 1 ->
        dungeon_load:replace_dun_god_weapon(St);
        true -> ok
    end.

%%副本列表
dungeon_list() ->
    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    {CurLayer, CurRound} = get_cur_layer(St),
    IsSweep =
        if
            St#st_dun_god_weapon.layer == St#st_dun_god_weapon.layer_h andalso St#st_dun_god_weapon.round == St#st_dun_god_weapon.round_h ->
                0;
            true ->
                1
        end,
    F = fun(Layer) ->
        DunId = data_dungeon_god_weapon:layer2scene(Layer),
        [Layer, DunId]
        end,
    DunList =
        lists:map(F, data_dungeon_god_weapon:layer_list()),
    {CurLayer, CurRound, St#st_dun_god_weapon.layer_h, St#st_dun_god_weapon.round_h, IsSweep, DunList}.

get_cur_layer() ->
    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    get_cur_layer(St).
get_cur_layer(St) ->
    LayerList = data_dungeon_god_weapon:layer_list(),
    MaxLayer = lists:max(LayerList),
    if
        St#st_dun_god_weapon.layer == 0 -> {1, 1};
        true ->
            MaxRound = data_dungeon_god_weapon:max_round(St#st_dun_god_weapon.layer),
            if St#st_dun_god_weapon.layer >= MaxLayer andalso St#st_dun_god_weapon.round >= MaxRound -> {0, 0};
                St#st_dun_god_weapon.round >= MaxRound ->
                    {St#st_dun_god_weapon.layer + 1, 1};
                true ->
                    {St#st_dun_god_weapon.layer, St#st_dun_god_weapon.round + 1}
            end
    end.

%%扫荡
sweep(Player) ->
    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    if St#st_dun_god_weapon.layer == St#st_dun_god_weapon.layer_h andalso St#st_dun_god_weapon.round == St#st_dun_god_weapon.round_h ->
        {16, [], Player};
        true ->
            case get_sweep_goods_list(Player, St#st_dun_god_weapon.layer_h, St#st_dun_god_weapon.round_h, St#st_dun_god_weapon.layer, St#st_dun_god_weapon.round) of
                [] ->
                    {16, [], Player};
                GoodsList ->
                    NewSt = St#st_dun_god_weapon{layer = St#st_dun_god_weapon.layer_h, round = St#st_dun_god_weapon.round_h, is_change = 1},
                    lib_dict:put(?PROC_STATUS_DUN_GOD_WEAPON, NewSt),
                    GiveGoodsList = goods:make_give_goods_list(263, GoodsList),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity:get_notice(Player, [100], true),
                    {1, goods:pack_goods(GoodsList), NewPlayer}
            end
    end.

check_sweep() ->
    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    if
        St#st_dun_god_weapon.layer == St#st_dun_god_weapon.layer_h andalso St#st_dun_god_weapon.round == St#st_dun_god_weapon.round_h ->
            0;
        true ->
            case get_sweep_goods_list(#player{}, St#st_dun_god_weapon.layer_h, St#st_dun_god_weapon.round_h, St#st_dun_god_weapon.layer, St#st_dun_god_weapon.round) of
                [] ->
                    0;
                _GoodsList ->
                    1
            end
    end.

check_sweep_state(Tips) ->
    Ret = check_sweep(),
    ?IF_ELSE(Ret == 0, Tips, Tips#tips{state = 1, saodang_dungeon_list = [?TIPS_DUNGEON_TYPE_DAILY_TWO | Tips#tips.saodang_dungeon_list]}).


get_sweep_goods_list(Player, LayerH, RoundH, CurLayer, CurRound) ->
    F = fun(Layer) ->
        if Layer < CurLayer -> [];
            Layer == CurLayer ->
                if RoundH =< CurRound -> [];
                    true ->
                        sweep_goods(Player, Layer, CurRound, RoundH, [])
                end;
            Layer == LayerH ->
                sweep_goods(Player, Layer, 1, RoundH, []);
            true ->
                sweep_goods(Player, Layer, 1, data_dungeon_god_weapon:max_round(Layer), [])
        end
        end,
    GoodsList = lists:flatmap(F, lists:seq(1, LayerH)),
    goods:merge_goods(GoodsList).


sweep_goods(Player, Layer, Round, MaxRound, GoodsList) ->
    if Round == MaxRound ->
        DunId = data_dungeon_god_weapon:layer2scene(Layer),
        task_event:event(?TASK_ACT_DUN_GOD_WEAPON, {DunId, MaxRound}),
        ?DO_IF(Player#player.key /= 0, achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2006, 0, Layer)),
        GoodsList;
        true ->
            case data_dungeon_god_weapon:get_goods(Layer, Round + 1) of
                [] ->
                    sweep_goods(Player, Layer, Round, MaxRound, GoodsList);
                Goods ->

                    sweep_goods(Player, Layer, Round + 1, MaxRound, tuple_to_list(Goods) ++ GoodsList)
            end
    end.


%%副本进入检查
check_enter(_Player, DunId) ->
    case dungeon_util:is_dungeon_god_weapon(DunId) of
        false -> true;
        true ->
            case data_dungeon_god_weapon:scene2layer(DunId) of
                0 ->
                    {false, ?T("层数配置错误")};
                Layer ->
                    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
                    {CurLayer, _CurRound} = get_cur_layer(St),
                    if St#st_dun_god_weapon.layer == 0 andalso Layer == 1 -> true;
                        Layer == CurLayer -> true;
                        true ->
                            {false, ?T("前置层未通关")}
                    end
            end

    end.

check_enter_state(Player, Tips) ->
    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    {CurLayer, _CurRound} = get_cur_layer(St),
    if
        CurLayer == St#st_dun_god_weapon.layer ->
            Tips;
        CurLayer == 0 ->
            Tips;
        true ->
            DunId = data_dungeon_god_weapon:layer2scene(CurLayer),
            case data_dungeon:get(DunId) of
                [] ->
                    Tips;
                #dungeon{lv = LimitLv} ->
                    ?IF_ELSE(Player#player.lv >= LimitLv, Tips#tips{state = 1, args2 = DunId, uplv_dungeon_list = [?TIPS_DUNGEON_TYPE_DAILY_TWO | Tips#tips.uplv_dungeon_list]}, Tips)
            end
    end.

get_notice_player(_Player) ->
%%     Tips = check_enter_state(_Player, #tips{}),
    State = check_sweep(),
    if
        State == 1 -> 1;
%%         Tips#tips.state > 0 -> 1;
        true ->
%%             St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
%%             MaxRound = data_dungeon_god_weapon:max_round(St#st_dun_god_weapon.layer),
%%             ?IF_ELSE(St#st_dun_god_weapon.round < MaxRound, 1, 0)
            0
    end.

%%获取进入副本额外参数
get_enter_dungeon_extra(DunId) ->
    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    {_CurLayer, CurRound} = get_cur_layer(St),
    Layer = data_dungeon_god_weapon:scene2layer(DunId),
    MaxRound = data_dungeon_god_weapon:max_round(Layer),
    [{dun_god_weapon_round, CurRound, MaxRound, St#st_dun_god_weapon.layer_h, St#st_dun_god_weapon.round_h}].


%%更新波数
update_dun_god_weapon_layer(Player, DunId, Round, GoodsList) ->
    St = lib_dict:get(?PROC_STATUS_DUN_GOD_WEAPON),
    Layer = data_dungeon_god_weapon:scene2layer(DunId),
    case is_new(St#st_dun_god_weapon.layer, St#st_dun_god_weapon.round, Layer, Round) of
        true ->

            {LayerH, RoundH} =
                case is_first_pass(Layer, Round, St#st_dun_god_weapon.layer_h, St#st_dun_god_weapon.round_h) of
                    true ->
                        {Layer, Round};
                    false ->
                        {St#st_dun_god_weapon.layer_h, St#st_dun_god_weapon.round_h}
                end,
            NewSt = St#st_dun_god_weapon{layer = Layer, round = Round, layer_h = LayerH, round_h = RoundH, is_change = 1},
            lib_dict:put(?PROC_STATUS_DUN_GOD_WEAPON, NewSt),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(264, GoodsList)),
            activity:get_notice(Player, [100, 109], true),
            task_event:event(?TASK_ACT_DUN_GOD_WEAPON, {DunId, Round}),
            MaxRound = data_dungeon_god_weapon:max_round(Layer),
            if Round >= MaxRound ->
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_2, ?ACHIEVE_SUBTYPE_2006, 0, Layer);
                true -> ok
            end,
            NewPlayer;
        false ->
            Player
    end.

is_new(Layer, Round, NewLayer, NewRound) ->
    NewLayer * 100 + NewRound > Layer * 100 + Round.

is_first_pass(Layer, Round, LayerH, RoundH) ->
    Layer * 100 + Round > LayerH * 100 + RoundH.

%%副本结算
dungeon_god_weapon_ret(Player, DunId, Round, GoodsList) ->
    Layer = data_dungeon_god_weapon:scene2layer(DunId),
    MaxRound = data_dungeon_god_weapon:max_round(Layer),
    NextDunId =
        if Round < MaxRound -> 0;
            true ->
                data_dungeon_god_weapon:layer2scene(Layer + 1)
        end,
    {ok, Bin} = pt_121:write(12152, {DunId, NextDunId, goods:pack_goods(GoodsList)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [100, 109], true),
    ok.