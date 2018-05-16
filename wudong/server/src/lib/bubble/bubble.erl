%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 二月 2017 19:41
%%%-------------------------------------------------------------------
-module(bubble).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("bubble.hrl").

%% API
-export([
    bubble_list/1
    , use_bubble/2
    , put_off_bubble/2
    , activate_bubble/2
    , upgrade_bubble/2
    , check_activate_by_goods/2
    , activate_by_goods/2
    , is_activate/1
    , is_activate2/1
    , get_notice_player/1
    , activation_stage_lv/2
]).


%%泡泡列表
bubble_list(_Player) ->
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    Now = util:unixtime(),
    F = fun(Bubble) ->
        if Bubble#bubble.time == 0 ->
            AttrList = attribute_util:pack_attr(Bubble#bubble.attribute),
            ActivationListInfo0 = get_activation_list_info(Bubble#bubble.activation_list, Bubble#bubble.bubble_id, 1, Bubble#bubble.stage, []),
            ActivationListInfo = [tuple_to_list(X) || X <- ActivationListInfo0],
            [[Bubble#bubble.bubble_id, 0, Bubble#bubble.stage, Bubble#bubble.is_use, Bubble#bubble.cbp, AttrList, ActivationListInfo]];
            Bubble#bubble.time < Now -> [];
            true ->
                AttrList = attribute_util:pack_attr(Bubble#bubble.attribute),
                [[Bubble#bubble.bubble_id, Bubble#bubble.time - Now, Bubble#bubble.stage, Bubble#bubble.is_use, Bubble#bubble.cbp, AttrList, []]]
        end
    end,
    BubbleList = lists:flatmap(F, StBubble#st_bubble.bubble_list),
    AllAttrList = attribute_util:pack_attr(StBubble#st_bubble.attribute),
    {StBubble#st_bubble.cbp, AllAttrList, BubbleList}.


get_activation_list_info(ActivationList, BubbleId, Stage, NowStage, List) ->
    case data_bubble_upgrade:get(BubbleId, Stage) of
        [] -> List;
        #base_bubble_upgrade{lv_attr = LvAttr} ->
            if
                LvAttr == [] ->
                    get_activation_list_info(ActivationList, BubbleId, Stage + 1, NowStage, List);
                true ->
                    case lists:member(Stage, ActivationList) of
                        false ->
                            ActState = ?IF_ELSE(NowStage >= Stage, 2, 0),
                            get_activation_list_info(ActivationList, BubbleId, Stage + 1, NowStage, [{Stage, ActState, attribute_util:pack_attr(LvAttr)} | List]);
                        _ ->
                            get_activation_list_info(ActivationList, BubbleId, Stage + 1, NowStage, [{Stage, 1, attribute_util:pack_attr(LvAttr)} | List])
                    end
            end
    end.

%%使用泡泡
use_bubble(Player, BubbleId) ->
    if Player#player.fashion#fashion_figure.fashion_bubble_id == BubbleId -> {2, Player};
        true ->
            StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
            case lists:keytake(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
                false -> {3, Player};
                {value, Bubble, T} ->
                    Now = util:unixtime(),
                    if Bubble#bubble.time > 0 andalso Bubble#bubble.time < Now -> {4, Player};
                        true ->
                            BubbleList = [Bubble#bubble{is_use = 1}] ++ [F#bubble{is_use = 0} || F <- T],
                            NewStBubble = StBubble#st_bubble{bubble_list = BubbleList, bubble_id = BubbleId, is_change = 1},
                            lib_dict:put(?PROC_STATUS_BUBBLE, NewStBubble),
                            NewPlayer = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_bubble_id = BubbleId}},
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer}
                    end
            end
    end.

put_off_bubble(Player, BubbleId) ->
    if Player#player.fashion#fashion_figure.fashion_bubble_id =/= BubbleId -> {11, Player};
        true ->
            StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
            case lists:keytake(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
                false -> {3, Player};
                {value, Bubble, T} ->
                    BubbleList = [Bubble#bubble{is_use = 0} | T],
                    NewStBubble = StBubble#st_bubble{bubble_list = BubbleList, bubble_id = 0, is_change = 1},
                    lib_dict:put(?PROC_STATUS_BUBBLE, NewStBubble),
                    NewPlayer = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_bubble_id = 0}},
                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                    {1, NewPlayer}
            end
    end.

%%激活泡泡
activate_bubble(Player, BubbleId) ->
    case data_bubble:get(BubbleId) of
        [] -> {5, Player};
        Base ->
            StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
            Now = util:unixtime(),
            GoodsCount = goods_util:get_goods_count(Base#base_bubble.goods_id),
            if Base#base_bubble.goods_num > GoodsCount -> {7, Player};
                true ->
                    case lists:keytake(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
                        false ->
                            NewPlayer = activate(BubbleId, Base, Now, Player, StBubble),
                            goods:subtract_good(Player, [{Base#base_bubble.goods_id, Base#base_bubble.goods_num}], 233),
                            {1, NewPlayer};
                        {value, BubbleOld, T} ->
                            if BubbleOld#bubble.time == 0 orelse BubbleOld#bubble.time > Now -> {6, Player};
                                true ->
                                    NewPlayer = activate(BubbleId, Base, Now, Player, StBubble#st_bubble{bubble_list = T}),
                                    goods:subtract_good(Player, [{Base#base_bubble.goods_id, Base#base_bubble.goods_num}], 233),
                                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

activate(BubbleId, Base, Now, Player, StBubble) ->
    Time = ?IF_ELSE(Base#base_bubble.time_bar == 0, 0, Base#base_bubble.time_bar + Now),
    Bubble = #bubble{bubble_id = BubbleId, time = Time, stage = 1, is_use = 1, is_enable = true},
    NewBubble = bubble_init:calc_single_attribute(Bubble),
    BubbleList = [NewBubble] ++ [Fa#bubble{is_use = 0} || Fa <- StBubble#st_bubble.bubble_list],
    StBubble1 = StBubble#st_bubble{bubble_list = BubbleList, bubble_id = BubbleId},
    bubble_load:replace_bubble(StBubble1),
    NewStBubble = bubble_init:calc_attribute(StBubble1),
    lib_dict:put(?PROC_STATUS_BUBBLE, NewStBubble),
    Player1 = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_bubble_id = BubbleId}},
    NewPlayer = player_util:count_player_attribute(Player1, true),
    bubble_load:log_bubble(Player#player.key, Player#player.nickname, 1, BubbleId, 1),
    fashion_suit:active_icon_push(NewPlayer),
    NewPlayer.


%%检查成品激活
check_activate_by_goods(_Player, Args) ->
    BubbleId = ?IF_ELSE(is_list(Args), hd(Args), Args),
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    case data_bubble:get(BubbleId) of
        [] -> {false, 6};
        _ ->
            case lists:keyfind(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
                false -> true;
                Bubble ->
                    Now = util:unixtime(),
                    if Bubble#bubble.time == 0 -> {false, 33};
                        Bubble#bubble.time > Now -> {false, 33};
                        true ->
                            true
                    end
            end
    end.

%%成品激活
activate_by_goods(Player, Args) ->
    [BubbleId, TimeBar] =
        case is_list(Args) of
            true -> Args;
            false ->
                [Args, 0]
        end,
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    Now = util:unixtime(),
    Base = data_bubble:get(BubbleId),
    NewTimeBar = ?IF_ELSE(TimeBar > 0, TimeBar, Base#base_bubble.time_bar),
    NewPlayer =
        case lists:keytake(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
            false ->
                activate(BubbleId, Base#base_bubble{time_bar = NewTimeBar}, Now, Player, StBubble);
            {value, BubbleOld, T} ->
                if BubbleOld#bubble.time == 0 -> Player;
                    true ->
                        activate(BubbleId, Base#base_bubble{time_bar = NewTimeBar}, Now, Player, StBubble#st_bubble{bubble_list = T})
                end
        end,
    player:apply_state(async, self(), {activity, sys_notice, [94]}),
    NewPlayer.


%%是否激活
is_activate(BubbleId) ->
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    case lists:keyfind(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
        false -> false;
        Bubble ->
            if Bubble#bubble.time == 0 -> true;
                true ->
                    false
            end
    end.

%%是否激活
is_activate2(BubbleId) ->
    NowTime = util:unixtime(),
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    case lists:keyfind(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
        false -> {false, 0};
        Bubble ->
            if Bubble#bubble.time == 0 -> {true, Bubble#bubble.stage};
                Bubble#bubble.time > NowTime -> {true, Bubble#bubble.stage};
                true ->
                    {false, 0}
            end
    end.

%%升级
upgrade_bubble(Player, BubbleId) ->
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    case lists:keytake(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
        false -> {3, Player};
        {value, Bubble, T} ->
            case data_bubble_upgrade:get(BubbleId, Bubble#bubble.stage + 1) of
                [] -> {8, Player};
                _ ->
                    Base = data_bubble_upgrade:get(BubbleId, Bubble#bubble.stage),
                    GoodsCount = goods_util:get_goods_count(Base#base_bubble_upgrade.goods_id),
                    if GoodsCount < Base#base_bubble_upgrade.goods_num -> {9, Player};
                        Bubble#bubble.is_enable == false -> {2, Player};
                        Bubble#bubble.time > 0 -> {10, Player};
                        true ->
                            Bubble1 = Bubble#bubble{stage = Bubble#bubble.stage + 1},
                            NewBubble = bubble_init:calc_single_attribute(Bubble1),
                            StBubble1 = StBubble#st_bubble{bubble_list = [NewBubble | T], is_change = 1},
                            NewStBubble = bubble_init:calc_attribute(StBubble1),
                            lib_dict:put(?PROC_STATUS_BUBBLE, NewStBubble),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            goods:subtract_good(Player, [{Base#base_bubble_upgrade.goods_id, Base#base_bubble_upgrade.goods_num}], 234),
                            bubble_load:log_bubble(Player#player.key, Player#player.nickname, 2, BubbleId, Bubble1#bubble.stage),
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer}
                    end
            end
    end.

get_notice_player(_Player) ->
    Ids = data_bubble:id_list(),
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    Now = util:unixtime(),
    F = fun(BubbleId) ->
        Base = data_bubble:get(BubbleId),
        GoodsCount = goods_util:get_goods_count(Base#base_bubble.goods_id),
        if
            Base#base_bubble.goods_num > GoodsCount -> [];
            true ->
                case lists:keytake(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
                    false -> [1];
                    {value, BubbleOld, _T} ->
                        if
                            BubbleOld#bubble.time == 0 orelse BubbleOld#bubble.time > Now -> [];
                            true -> [1]
                        end
                end
        end
    end,
    List = lists:flatmap(F, Ids),
    F2 = fun(BubbleId) ->
        case lists:keytake(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
            false -> [];
            {value, Bubble, _T} ->
                case data_bubble_upgrade:get(BubbleId, Bubble#bubble.stage + 1) of
                    [] -> [];
                    _ ->
                        Base = data_bubble_upgrade:get(BubbleId, Bubble#bubble.stage),
                        GoodsCount = goods_util:get_goods_count(Base#base_bubble_upgrade.goods_id),
                        if GoodsCount < Base#base_bubble_upgrade.goods_num -> [];
                            Bubble#bubble.is_enable == false -> [];
                            Bubble#bubble.time > 0 -> [];
                            true -> [1]
                        end
                end
        end
    end,
    List2 = lists:flatmap(F2, Ids),
    ?IF_ELSE(List ++ List2 == [], 0, 1).


activation_stage_lv(Player, BubbleId) ->
    StBubble = lib_dict:get(?PROC_STATUS_BUBBLE),
    case lists:keytake(BubbleId, #bubble.bubble_id, StBubble#st_bubble.bubble_list) of
        false -> {3, Player};
        {value, Bubble, T} ->
            StageList = get_stage_list(BubbleId, Bubble#bubble.stage),
            NewActivationList = StageList -- Bubble#bubble.activation_list,
            if
                NewActivationList == [] -> {12, Player};
                true ->
                    Bubble1 = Bubble#bubble{activation_list = NewActivationList ++ Bubble#bubble.activation_list},
                    NewBubble = bubble_init:calc_single_attribute(Bubble1),
                    StBubble1 = StBubble#st_bubble{bubble_list = [NewBubble | T], is_change = 1},
                    NewStBubble = bubble_init:calc_attribute(StBubble1),
                    lib_dict:put(?PROC_STATUS_BUBBLE, NewStBubble),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    {1, NewPlayer}
            end
    end.



get_stage_list(Id, Stage) ->
    F = fun(Stage0, List) ->
        case data_bubble_upgrade:get(Id, Stage0) of
            [] -> List;
            #base_bubble_upgrade{lv_attr = LvAttr} ->
                if
                    LvAttr == [] -> List;
                    true -> [Stage0 | List]
                end
        end
    end,
    lists:foldl(F, [], lists:seq(1, Stage)).