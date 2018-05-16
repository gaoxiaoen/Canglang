%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 二月 2017 11:30
%%%-------------------------------------------------------------------
-module(fashion).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("fashion.hrl").
-include("achieve.hrl").
%% API
-export([
    fashion_list/1
    , use_fashion/2
    , put_off_fashion/2
    , activate_fashion/2
    , upgrade_fashion/2
    , check_activate_by_goods/2
    , activate_by_goods/2
    , is_activate/1
    , is_activate2/1
    , get_notice_player/1
    , get_present_list/0
    , present_fashion/4
    , activation_stage_lv/2
]).


%%时装列表
fashion_list(_Player) ->
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    Now = util:unixtime(),
    F = fun(Fashion) ->
        if Fashion#fashion.time == 0 ->
            AttrList = attribute_util:pack_attr(Fashion#fashion.attribute),
            ActivationListInfo0 = get_activation_list_info(Fashion#fashion.activation_list, Fashion#fashion.fashion_id, 1, Fashion#fashion.stage, []),
            ActivationListInfo = [tuple_to_list(X) || X <- ActivationListInfo0],
            [[Fashion#fashion.fashion_id, 0, Fashion#fashion.stage, Fashion#fashion.is_use, Fashion#fashion.cbp, AttrList, ActivationListInfo]];
            Fashion#fashion.time < Now -> [];
            true ->
                AttrList = attribute_util:pack_attr(Fashion#fashion.attribute),
                [[Fashion#fashion.fashion_id, Fashion#fashion.time - Now, Fashion#fashion.stage, Fashion#fashion.is_use, Fashion#fashion.cbp, AttrList, []]]
        end
    end,
    FashionList = lists:flatmap(F, StFashion#st_fashion.fashion_list),
    AllAttrList = attribute_util:pack_attr(StFashion#st_fashion.attribute),
    {StFashion#st_fashion.cbp, AllAttrList, FashionList}.

get_activation_list_info(ActivationList, FashionId, Stage, NowStage, List) ->
    case data_fashion_upgrade:get(FashionId, Stage) of
        [] -> List;
        #base_fashion_upgrade{lv_attr = LvAttr} ->
            if
                LvAttr == [] ->
                    get_activation_list_info(ActivationList, FashionId, Stage + 1, NowStage, List);
                true ->
                    case lists:member(Stage, ActivationList) of
                        false ->
                            ActState = ?IF_ELSE(NowStage >= Stage, 2, 0),
                            get_activation_list_info(ActivationList, FashionId, Stage + 1, NowStage, [{Stage, ActState, attribute_util:pack_attr(LvAttr)} | List]);
                        _ ->
                            get_activation_list_info(ActivationList, FashionId, Stage + 1, NowStage, [{Stage, 1, attribute_util:pack_attr(LvAttr)} | List])
                    end
            end
    end.

%%使用时装
use_fashion(Player, FashionId) ->
    if Player#player.fashion#fashion_figure.fashion_cloth_id == FashionId -> {2, Player};
        true ->
            StFashion = lib_dict:get(?PROC_STATUS_FASHION),
            case lists:keytake(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
                false -> {3, Player};
                {value, Fashion, T} ->
                    Now = util:unixtime(),
                    if Fashion#fashion.time > 0 andalso Fashion#fashion.time < Now -> {4, Player};
                        true ->
                            FashionList = [Fashion#fashion{is_use = 1}] ++ [F#fashion{is_use = 0} || F <- T],
                            NewStFashion = StFashion#st_fashion{fashion_list = FashionList, fashion_id = FashionId, is_change = 1},
                            lib_dict:put(?PROC_STATUS_FASHION, NewStFashion),
                            Player1 = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_cloth_id = FashionId}},
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            Base = data_fashion:get(FashionId),
                            NewPlayer = ?IF_ELSE(Base#base_fashion.head_id == 0, Player1, head:use_head_sys(Player1, Base#base_fashion.head_id)),
                            {1, NewPlayer}
                    end
            end
    end.

%%使用时装
put_off_fashion(Player, FashionId) ->
    if Player#player.fashion#fashion_figure.fashion_cloth_id =/= FashionId -> {11, Player};
        true ->
            StFashion = lib_dict:get(?PROC_STATUS_FASHION),
            case lists:keytake(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
                false -> {3, Player};
                {value, Fashion, T} ->
                    FashionList = [Fashion#fashion{is_use = 0} | T],
                    NewStFashion = StFashion#st_fashion{fashion_list = FashionList, fashion_id = 0, is_change = 1},
                    lib_dict:put(?PROC_STATUS_FASHION, NewStFashion),
                    Player1 = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_cloth_id = 0}},
                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                    Base = data_fashion:get(FashionId),
                    NewPlayer = ?IF_ELSE(Base#base_fashion.head_id == 0, Player1, head:put_off_head_sys(Player1, Base#base_fashion.head_id)),
                    {1, NewPlayer}
            end
    end.

get_notice_player(_Player) ->
    Ids = data_fashion:id_list(),
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    Now = util:unixtime(),
    F = fun(FashionId) ->
        Base = data_fashion:get(FashionId),
        GoodsCount = goods_util:get_goods_count(Base#base_fashion.goods_id),
        if
            Base#base_fashion.goods_num > GoodsCount -> [];
            Base#base_fashion.goods_num == 0 -> [];
            true ->
                case lists:keytake(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
                    false ->
                        [1];
                    {value, FashionOld, _T} ->
                        if
                            FashionOld#fashion.time == 0 orelse FashionOld#fashion.time > Now -> [];
                            true ->
                                [1]
                        end
                end
        end
    end,
    List = lists:flatmap(F, Ids),
    F2 = fun(FashionId) ->
        case lists:keytake(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
            false -> [];
            {value, Fashion, _T} ->
                case data_fashion_upgrade:get(FashionId, Fashion#fashion.stage + 1) of
                    [] -> [];
                    _ ->
                        Base = data_fashion_upgrade:get(FashionId, Fashion#fashion.stage),
                        GoodsCount = goods_util:get_goods_count(Base#base_fashion_upgrade.goods_id),
                        if GoodsCount < Base#base_fashion_upgrade.goods_num -> [];
                            Fashion#fashion.is_enable == false -> [];
                            Fashion#fashion.time > 0 -> [];
                            true -> [1]
                        end
                end
        end
    end,
    List2 = lists:flatmap(F2, Ids),

    F3 = fun(FashionId) ->
        case lists:keytake(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
            false -> [];
            {value, Fashion11, _T} ->
                StageList = get_stage_list(FashionId, Fashion11#fashion.stage),
                NewActivationList = StageList -- Fashion11#fashion.activation_list,
                if
                    NewActivationList == [] -> [];
                    true -> [1]
                end
        end
    end,
    List3 = lists:flatmap(F3, Ids),
    ?IF_ELSE(List ++ List2 ++ List3 == [], 0, 1).

%%激活时装
activate_fashion(Player, FashionId) ->
    case data_fashion:get(FashionId) of
        [] -> {5, Player};
        Base ->
            StFashion = lib_dict:get(?PROC_STATUS_FASHION),
            Now = util:unixtime(),
            GoodsCount = goods_util:get_goods_count(Base#base_fashion.goods_id),
            if Base#base_fashion.goods_num > GoodsCount -> {7, Player};
                true ->
                    case lists:keytake(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
                        false ->
                            NewPlayer = activate(FashionId, Base, Now, Player, StFashion),
                            goods:subtract_good(Player, [{Base#base_fashion.goods_id, Base#base_fashion.goods_num}], 233),
                            {1, NewPlayer};
                        {value, FashionOld, T} ->
                            if FashionOld#fashion.time == 0 orelse FashionOld#fashion.time > Now -> {6, Player};
                                true ->
                                    NewPlayer = activate(FashionId, Base, Now, Player, StFashion#st_fashion{fashion_list = T}),
                                    goods:subtract_good(Player, [{Base#base_fashion.goods_id, Base#base_fashion.goods_num}], 233),
                                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

activate(FashionId, Base, Now, Player, StFashion) ->
    Time = ?IF_ELSE(Base#base_fashion.time_bar == 0, 0, Base#base_fashion.time_bar + Now),
    Fashion = #fashion{fashion_id = FashionId, time = Time, stage = 1, is_use = 1, is_enable = true},
    NewFashion = fashion_init:calc_single_attribute(Fashion),
    FashionList = [NewFashion] ++ [Fa#fashion{is_use = 0} || Fa <- StFashion#st_fashion.fashion_list],
    StFashion1 = StFashion#st_fashion{fashion_list = FashionList, fashion_id = FashionId},
    fashion_load:replace_fashion(StFashion1),
    NewStFashion = fashion_init:calc_attribute(StFashion1),
    lib_dict:put(?PROC_STATUS_FASHION, NewStFashion),
    msg_activate(Player, FashionId),
    Player1 = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_cloth_id = FashionId}},
    Player2 = ?IF_ELSE(Base#base_fashion.head_id == 0, Player1, head:activate_by_goods(Player1, Base#base_fashion.head_id)),
    Player3 = player_util:count_player_attribute(Player2, true),
    fashion_load:log_fashion(Player#player.key, Player#player.nickname, 1, FashionId, 1),
    F = fun(Fashion1, Num) ->
        if Fashion1#fashion.time == 0 orelse Fashion1#fashion.time > Now -> Num + 1;
            true -> Num
        end
    end,
    FashionCount = lists:foldl(F, 0, FashionList),
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1043, 0, FashionCount),
    NewPlayer = ?IF_ELSE(Base#base_fashion.head_id == 0, Player3, head:use_head_sys(Player3, Base#base_fashion.head_id)),
    fashion_suit:active_icon_push(NewPlayer),
    NewPlayer.

%%检查成品激活
check_activate_by_goods(_Player, Args) ->
    FashionId = ?IF_ELSE(is_list(Args), hd(Args), Args),
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    case data_fashion:get(FashionId) of
        [] -> {false, 6};
        _ ->
            case lists:keyfind(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
                false -> true;
                Fashion ->
                    Now = util:unixtime(),
                    if Fashion#fashion.time == 0 -> {false, 31};
                        Fashion#fashion.time > Now -> {false, 31};
                        true ->
                            true
                    end
            end
    end.

%%成品激活
activate_by_goods(Player, Args) ->
    [FashionId, TimeBar] =
        case is_list(Args) of
            true -> Args;
            false ->
                [Args, 0]
        end,
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    Now = util:unixtime(),
    Base = data_fashion:get(FashionId),
    NewTimeBar = ?IF_ELSE(TimeBar > 0, TimeBar, Base#base_fashion.time_bar),
    case lists:keytake(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
        false ->
            NewPlayer = activate(FashionId, Base#base_fashion{time_bar = NewTimeBar}, Now, Player, StFashion),
            scene_agent_dispatch:fashion_update(NewPlayer),
            player:apply_state(async, self(), {activity, sys_notice, [94]}),
            NewPlayer;
        {value, FashionOld, T} ->
            if FashionOld#fashion.time == 0 -> Player;
                true ->
                    NewPlayer = activate(FashionId, Base#base_fashion{time_bar = NewTimeBar}, Now, Player, StFashion#st_fashion{fashion_list = T}),
                    scene_agent_dispatch:fashion_update(NewPlayer),
                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                    NewPlayer
            end
    end.

%%是否激活
is_activate(FashionId) ->
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    case lists:keyfind(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
        false -> false;
        Fashion ->
            if Fashion#fashion.time == 0 -> true;
                true ->
                    false
            end
    end.


%%包括限时时装是否激活
is_activate2(FashionId) ->
    NowTime = util:unixtime(),
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    case lists:keyfind(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
        false -> {false, 0};
        Fashion ->
            if Fashion#fashion.time == 0 -> {true, Fashion#fashion.stage};
                Fashion#fashion.time > NowTime -> {true, Fashion#fashion.stage};
                true ->
                    {false, 0}
            end
    end.

%%升级
upgrade_fashion(Player, FashionId) ->
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    case lists:keytake(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
        false -> {3, Player};
        {value, Fashion, T} ->
            case data_fashion_upgrade:get(FashionId, Fashion#fashion.stage + 1) of
                [] -> {8, Player};
                _ ->
                    Base = data_fashion_upgrade:get(FashionId, Fashion#fashion.stage),
                    GoodsCount = goods_util:get_goods_count(Base#base_fashion_upgrade.goods_id),
                    FullCount = goods_util:get_goods_count(Base#base_fashion_upgrade.full_goods_id),
                    if
                        Fashion#fashion.is_enable == false -> {2, Player};
                        Fashion#fashion.time > 0 -> {10, Player};
                        GoodsCount >= Base#base_fashion_upgrade.goods_num ->
                            Fashion1 = Fashion#fashion{stage = Fashion#fashion.stage + 1},
                            NewFashion = fashion_init:calc_single_attribute(Fashion1),
                            StFashion1 = StFashion#st_fashion{fashion_list = [NewFashion | T], is_change = 1},
                            NewStFashion = fashion_init:calc_attribute(StFashion1),
                            lib_dict:put(?PROC_STATUS_FASHION, NewStFashion),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            goods:subtract_good(Player, [{Base#base_fashion_upgrade.goods_id, Base#base_fashion_upgrade.goods_num}], 234),
                            fashion_load:log_fashion(Player#player.key, Player#player.nickname, 2, FashionId, Fashion1#fashion.stage),
                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1044, 0, Fashion1#fashion.stage),
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer};
                        FullCount >= 1 ->
                            Fashion1 = Fashion#fashion{stage = Fashion#fashion.stage + 1},
                            NewFashion = fashion_init:calc_single_attribute(Fashion1),
                            StFashion1 = StFashion#st_fashion{fashion_list = [NewFashion | T], is_change = 1},
                            NewStFashion = fashion_init:calc_attribute(StFashion1),
                            lib_dict:put(?PROC_STATUS_FASHION, NewStFashion),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            goods:subtract_good(Player, [{Base#base_fashion_upgrade.full_goods_id, 1}], 234),
                            fashion_load:log_fashion(Player#player.key, Player#player.nickname, 2, FashionId, Fashion1#fashion.stage),
                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1044, 0, Fashion1#fashion.stage),
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer};
                        true -> {9, Player}
                    end
            end
    end.

%%时装激活通知
msg_activate(Player, FashionId) ->
    {ok, Bin} = pt_330:write(33005, {FashionId}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_present_list() ->
    relation:get_friend_list_to_fashion().

present_fashion(Player, Pkey, Gkey, Content) ->
    case check_present_fashion(Pkey, Gkey) of
        {false, Res} -> {false, Res};
        {ok, TargetPlayer, _Base, Goods} ->
            case goods:subtract_good_by_key(Gkey, 1) of
                {false, _} ->
                    {false, 0};
                _ ->
                    Notice = io_lib:format(t_tv:get(224), [t_tv:pn(Player), t_tv:pn(TargetPlayer), t_tv:eq(Goods)]),
                    notice:add_sys_notice(Notice, 224),

                    %% 赠送日志
                    fashion_load:log_present_fashion(Player#player.key, Player#player.nickname, TargetPlayer#player.key, TargetPlayer#player.nickname, Goods#goods.goods_id, ?T("")),
                    TargetPlayer#player.pid ! {present_fashion, Player#player.key, Player#player.avatar, Player#player.nickname, Player#player.sex, Goods#goods.goods_id, Content},
                    ok
            end
    end.

check_present_fashion(Pkey, Gkey) ->
    case catch goods_util:get_goods(Gkey) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} -> {false, 0};
        Goods ->
            if
                Goods#goods.bind == ?BIND -> {false, 16};
                true ->
                    FriendList = relation:get_friend_list(),
                    case lists:member(Pkey, FriendList) of
                        false -> {false, 13};
                        true ->
                            case player_util:get_player(Pkey) of
                                [] -> {false, 14};
                                TargetPlayer ->
                                    GoodsType = data_goods:get(Goods#goods.goods_id),
                                    IsMember = lists:member(GoodsType#goods_type.type, [30, 56]),
                                    if
                                        not IsMember -> {false, 0};
                                        TargetPlayer#player.lv =< 40 -> {false, 15};
                                        true ->
                                            Base = data_fashion:get_icon(Goods#goods.goods_id),
                                            {ok, TargetPlayer, Base, Goods}
                                    end
                            end
                    end
            end
    end.

activation_stage_lv(Player, FashionId) ->
    StFashion = lib_dict:get(?PROC_STATUS_FASHION),
    case lists:keytake(FashionId, #fashion.fashion_id, StFashion#st_fashion.fashion_list) of
        false -> {3, Player};
        {value, Fashion, T} ->
            StageList = get_stage_list(FashionId, Fashion#fashion.stage),
            NewActivationList = StageList -- Fashion#fashion.activation_list,
            if
                NewActivationList == [] -> {19, Player};
                true ->
                    Fashion1 = Fashion#fashion{activation_list = NewActivationList ++ Fashion#fashion.activation_list},
                    NewFashion = fashion_init:calc_single_attribute(Fashion1),
                    StFashion1 = StFashion#st_fashion{fashion_list = [NewFashion | T], is_change = 1},
                    NewStFashion = fashion_init:calc_attribute(StFashion1),
                    lib_dict:put(?PROC_STATUS_FASHION, NewStFashion),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    {1, NewPlayer}
            end
    end.



get_stage_list(Id, Stage) ->
    F = fun(Stage0, List) ->
        case data_fashion_upgrade:get(Id, Stage0) of
            [] -> List;
            #base_fashion_upgrade{lv_attr = LvAttr} ->
                if
                    LvAttr == [] -> List;
                    true -> [Stage0 | List]
                end
        end
    end,
    lists:foldl(F, [], lists:seq(1, Stage)).
