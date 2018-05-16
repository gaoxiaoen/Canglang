%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 七月 2017 11:59
%%%-------------------------------------------------------------------
-module(decoration).
-author("hxming").


-include("common.hrl").
-include("server.hrl").
-include("decoration.hrl").

%% API
-export([
    decoration_list/1
    , use_decoration/2
    , put_off_decoration/2
    , activate_decoration/2
    , upgrade_decoration/2
    , check_activate_by_goods/2
    , activate_by_goods/2
    , is_activate/1
    , is_activate2/1
    , get_notice_player/1
    , activation_stage_lv/2
]).


%%挂饰列表
decoration_list(_Player) ->
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    Now = util:unixtime(),
    F = fun(Decoration) ->
        if Decoration#decoration.time == 0 ->
            AttrList = attribute_util:pack_attr(Decoration#decoration.attribute),
            ActivationListInfo0 = get_activation_list_info(Decoration#decoration.activation_list, Decoration#decoration.decoration_id, 1, Decoration#decoration.stage, []),
            ActivationListInfo = [tuple_to_list(X) || X <- ActivationListInfo0],
            [[Decoration#decoration.decoration_id, 0, Decoration#decoration.stage, Decoration#decoration.is_use, Decoration#decoration.cbp, AttrList, ActivationListInfo]];
            Decoration#decoration.time < Now -> [];
            true ->
                AttrList = attribute_util:pack_attr(Decoration#decoration.attribute),
                [[Decoration#decoration.decoration_id, Decoration#decoration.time - Now, Decoration#decoration.stage, Decoration#decoration.is_use, Decoration#decoration.cbp, AttrList, []]]
        end
    end,
    DecorationList = lists:flatmap(F, StDecoration#st_decoration.decoration_list),
    AllAttrList = attribute_util:pack_attr(StDecoration#st_decoration.attribute),
    {StDecoration#st_decoration.cbp, AllAttrList, DecorationList}.


get_activation_list_info(ActivationList, DecorationId, Stage, NowStage, List) ->
    case data_decoration_upgrade:get(DecorationId, Stage) of
        [] -> List;
        #base_decoration_upgrade{lv_attr = LvAttr} ->
            if
                LvAttr == [] ->
                    get_activation_list_info(ActivationList, DecorationId, Stage + 1, NowStage, List);
                true ->
                    case lists:member(Stage, ActivationList) of
                        false ->
                            ActState = ?IF_ELSE(NowStage >= Stage, 2, 0),
                            get_activation_list_info(ActivationList, DecorationId, Stage + 1, NowStage, [{Stage, ActState, attribute_util:pack_attr(LvAttr)} | List]);
                        _ ->
                            get_activation_list_info(ActivationList, DecorationId, Stage + 1, NowStage, [{Stage, 1, attribute_util:pack_attr(LvAttr)} | List])
                    end
            end
    end.


%%使用挂饰
use_decoration(Player, DecorationId) ->
    if Player#player.fashion#fashion_figure.fashion_decoration_id == DecorationId -> {2, Player};
        true ->
            StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
            case lists:keytake(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
                false -> {3, Player};
                {value, Decoration, T} ->
                    Now = util:unixtime(),
                    if Decoration#decoration.time > 0 andalso Decoration#decoration.time < Now -> {4, Player};
                        true ->
                            DecorationList = [Decoration#decoration{is_use = 1}] ++ [F#decoration{is_use = 0} || F <- T],
                            NewStDecoration = StDecoration#st_decoration{decoration_list = DecorationList, decoration_id = DecorationId, is_change = 1},
                            lib_dict:put(?PROC_STATUS_DECORATION, NewStDecoration),
                            NewPlayer = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_decoration_id = DecorationId}},
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer}
                    end
            end
    end.

put_off_decoration(Player, DecorationId) ->
    if Player#player.fashion#fashion_figure.fashion_decoration_id =/= DecorationId -> {11, Player};
        true ->
            StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
            case lists:keytake(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
                false -> {3, Player};
                {value, Decoration, T} ->
                    DecorationList = [Decoration#decoration{is_use = 0} | T],
                    NewStDecoration = StDecoration#st_decoration{decoration_list = DecorationList, decoration_id = 0, is_change = 1},
                    lib_dict:put(?PROC_STATUS_DECORATION, NewStDecoration),
                    NewPlayer = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_decoration_id = 0}},
                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                    {1, NewPlayer}
            end
    end.

%%激活挂饰
activate_decoration(Player, DecorationId) ->
    ?DEBUG("DecorationId ~p~n",[DecorationId]),
    case data_decoration:get(DecorationId) of
        [] -> {5, Player};
        Base ->
            StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
            Now = util:unixtime(),
            GoodsCount = goods_util:get_goods_count(Base#base_decoration.goods_id),
            if Base#base_decoration.goods_num > GoodsCount -> {7, Player};
                true ->
                    case lists:keytake(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
                        false ->
                            NewPlayer = activate(DecorationId, Base, Now, Player, StDecoration),
                            goods:subtract_good(Player, [{Base#base_decoration.goods_id, Base#base_decoration.goods_num}], 233),
                            {1, NewPlayer};
                        {value, DecorationOld, T} ->
                            if DecorationOld#decoration.time == 0 orelse DecorationOld#decoration.time > Now ->
                                {6, Player};
                                true ->
                                    NewPlayer = activate(DecorationId, Base, Now, Player, StDecoration#st_decoration{decoration_list = T}),
                                    goods:subtract_good(Player, [{Base#base_decoration.goods_id, Base#base_decoration.goods_num}], 233),
                                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

activate(DecorationId, Base, Now, Player, StDecoration) ->
    Time = ?IF_ELSE(Base#base_decoration.time_bar == 0, 0, Base#base_decoration.time_bar + Now),
    Decoration = #decoration{decoration_id = DecorationId, time = Time, stage = 1, is_use = 1, is_enable = true},
    NewDecoration = decoration_init:calc_single_attribute(Decoration),
    DecorationList = [NewDecoration] ++ [Fa#decoration{is_use = 0} || Fa <- StDecoration#st_decoration.decoration_list],
    StDecoration1 = StDecoration#st_decoration{decoration_list = DecorationList, decoration_id = DecorationId},
    decoration_load:replace_decoration(StDecoration1),
    NewStDecoration = decoration_init:calc_attribute(StDecoration1),
    lib_dict:put(?PROC_STATUS_DECORATION, NewStDecoration),
    Player1 = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_decoration_id = DecorationId}},
    NewPlayer = player_util:count_player_attribute(Player1, true),
    decoration_load:log_decoration(Player#player.key, Player#player.nickname, 1, DecorationId, 1),
    fashion_suit:active_icon_push(NewPlayer),
    NewPlayer.


%%检查成品激活
check_activate_by_goods(_Player, Args) ->
    DecorationId = ?IF_ELSE(is_list(Args), hd(Args), Args),
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    case data_decoration:get(DecorationId) of
        [] -> {false, 6};
        _ ->
            case lists:keyfind(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
                false -> true;
                Decoration ->
                    Now = util:unixtime(),
                    if Decoration#decoration.time == 0 -> {false, 42};
                        Decoration#decoration.time > Now -> {false, 42};
                        true ->
                            true
                    end
            end
    end.

%%成品激活
activate_by_goods(Player, Args) ->
    [DecorationId, TimeBar] =
        case is_list(Args) of
            true -> Args;
            false ->
                [Args, 0]
        end,
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    Now = util:unixtime(),
    Base = data_decoration:get(DecorationId),
    NewTimeBar = ?IF_ELSE(TimeBar > 0, TimeBar, Base#base_decoration.time_bar),
    NewPlayer =
        case lists:keytake(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
            false ->
                activate(DecorationId, Base#base_decoration{time_bar = NewTimeBar}, Now, Player, StDecoration);
            {value, DecorationOld, T} ->
                if DecorationOld#decoration.time == 0 -> Player;
                    true ->
                        activate(DecorationId, Base#base_decoration{time_bar = NewTimeBar}, Now, Player, StDecoration#st_decoration{decoration_list = T})
                end
        end,
    player:apply_state(async, self(), {activity, sys_notice, [94]}),
    NewPlayer.


%%是否激活
is_activate(DecorationId) ->
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    case lists:keyfind(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
        false -> false;
        Decoration ->
            if Decoration#decoration.time == 0 -> true;
                true ->
                    false
            end
    end.


%%是否激活
is_activate2(DecorationId) ->
    NowTime = util:unixtime(),
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    case lists:keyfind(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
        false -> {false, 0};
        Decoration ->
            if Decoration#decoration.time == 0 -> {true, Decoration#decoration.stage};
                Decoration#decoration.time > NowTime -> {true, Decoration#decoration.stage};
                true ->
                    {false, 0}
            end
    end.

%%升级
upgrade_decoration(Player, DecorationId) ->
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    case lists:keytake(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
        false -> {3, Player};
        {value, Decoration, T} ->
            case data_decoration_upgrade:get(DecorationId, Decoration#decoration.stage + 1) of
                [] -> {8, Player};
                _ ->
                    Base = data_decoration_upgrade:get(DecorationId, Decoration#decoration.stage),
                    GoodsCount = goods_util:get_goods_count(Base#base_decoration_upgrade.goods_id),
                    if GoodsCount < Base#base_decoration_upgrade.goods_num -> {9, Player};
                        Decoration#decoration.is_enable == false -> {2, Player};
                        Decoration#decoration.time > 0 -> {10, Player};
                        true ->
                            Decoration1 = Decoration#decoration{stage = Decoration#decoration.stage + 1},
                            NewDecoration = decoration_init:calc_single_attribute(Decoration1),
                            StDecoration1 = StDecoration#st_decoration{decoration_list = [NewDecoration | T], is_change = 1},
                            NewStDecoration = decoration_init:calc_attribute(StDecoration1),
                            lib_dict:put(?PROC_STATUS_DECORATION, NewStDecoration),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            goods:subtract_good(Player, [{Base#base_decoration_upgrade.goods_id, Base#base_decoration_upgrade.goods_num}], 234),
                            decoration_load:log_decoration(Player#player.key, Player#player.nickname, 2, DecorationId, Decoration1#decoration.stage),
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer}
                    end
            end
    end.

get_notice_player(_Player) ->
    Ids = data_decoration:id_list(),
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    Now = util:unixtime(),
    F = fun(DecorationId) ->
        Base = data_decoration:get(DecorationId),
        GoodsCount = goods_util:get_goods_count(Base#base_decoration.goods_id),
        if
            Base#base_decoration.goods_num > GoodsCount -> [];
            true ->
                case lists:keytake(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
                    false -> [1];
                    {value, DecorationOld, _T} ->
                        if
                            DecorationOld#decoration.time == 0 orelse DecorationOld#decoration.time > Now -> [];
                            true -> [1]
                        end
                end
        end
    end,
    List = lists:flatmap(F, Ids),
    F2 = fun(DecorationId) ->
        case lists:keytake(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
            false -> [];
            {value, Decoration, _T} ->
                case data_decoration_upgrade:get(DecorationId, Decoration#decoration.stage + 1) of
                    [] -> [];
                    _ ->
                        Base = data_decoration_upgrade:get(DecorationId, Decoration#decoration.stage),
                        GoodsCount = goods_util:get_goods_count(Base#base_decoration_upgrade.goods_id),
                        if GoodsCount < Base#base_decoration_upgrade.goods_num -> [];
                            Decoration#decoration.is_enable == false -> [];
                            Decoration#decoration.time > 0 -> [];
                            true -> [1]
                        end
                end
        end
    end,
    List2 = lists:flatmap(F2, Ids),
    ?IF_ELSE(List ++ List2 == [], 0, 1).


activation_stage_lv(Player, DecorationId) ->
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    case lists:keytake(DecorationId, #decoration.decoration_id, StDecoration#st_decoration.decoration_list) of
        false -> {3, Player};
        {value, Decoration, T} ->
            StageList = get_stage_list(DecorationId, Decoration#decoration.stage),
            NewActivationList = StageList -- Decoration#decoration.activation_list,
            if
                NewActivationList == [] -> {12, Player};
                true ->
                    Decoration1 = Decoration#decoration{activation_list = NewActivationList ++ Decoration#decoration.activation_list},
                    NewDecoration = decoration_init:calc_single_attribute(Decoration1),
                    StDecoration1 = StDecoration#st_decoration{decoration_list = [NewDecoration | T], is_change = 1},
                    NewStDecoration = decoration_init:calc_attribute(StDecoration1),
                    lib_dict:put(?PROC_STATUS_DECORATION, NewStDecoration),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    {1, NewPlayer}
            end
    end.


get_stage_list(Id, Stage) ->
    F = fun(Stage0, List) ->
        case data_decoration_upgrade:get(Id, Stage0) of
            [] -> List;
            #base_decoration_upgrade{lv_attr = LvAttr} ->
                if
                    LvAttr == [] -> List;
                    true -> [Stage0 | List]
                end
        end
    end,
    lists:foldl(F, [], lists:seq(1, Stage)).
