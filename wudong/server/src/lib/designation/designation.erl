%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2017 14:54
%%%-------------------------------------------------------------------
-module(designation).

-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("designation.hrl").

%% API
-export([
    designation_list/1
    , put_on_designation/2
    , put_off_designation/2
    , activate_designation/2
    , upgrade_designation/2
    , check_activate_by_goods/2
    , activate_by_goods/2
    , activate_by_goods_1/2
    , add_designation/2
    , add_designation_global/2
    , del_designation_global/2
    , is_activate/1
    , is_activate2/1
    , add_designation_offline/3
    , get_notice_player/1
    , activation_stage_lv/2
]).


%%称号列表
designation_list(Player) ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    Now = util:unixtime(),
    F = fun(Designation) ->
        IsUse = ?IF_ELSE(lists:member(Designation#designation.designation_id, Player#player.design), 1, 0),
        if Designation#designation.time == 0 ->
            AttrList = attribute_util:pack_attr(Designation#designation.attribute),
            ActivationListInfo0 = get_activation_list_info(Designation#designation.activation_list, Designation#designation.designation_id, 1, Designation#designation.stage, []),
            ActivationListInfo = [tuple_to_list(X) || X <- ActivationListInfo0],
            [[Designation#designation.designation_id, 0, Designation#designation.stage, IsUse, Designation#designation.cbp, AttrList, ActivationListInfo]];
            Designation#designation.time < Now -> [];
            true ->
                AttrList = attribute_util:pack_attr(Designation#designation.attribute),
                [[Designation#designation.designation_id, Designation#designation.time - Now, Designation#designation.stage, IsUse, Designation#designation.cbp, AttrList, []]]
        end
    end,
    DesignationList = lists:flatmap(F, StDesignation#st_designation.designation_list ++ StDesignation#st_designation.g_designation_list),
    AllAttrList = attribute_util:pack_attr(StDesignation#st_designation.attribute),
    {StDesignation#st_designation.cbp, AllAttrList, DesignationList}.

get_activation_list_info(ActivationList, DesignationId, Stage, NowStage, List) ->
    case data_designation_upgrade:get(DesignationId, Stage) of
        [] -> List;
        #base_designation_upgrade{lv_attr = LvAttr} ->
            if
                LvAttr == [] ->
                    get_activation_list_info(ActivationList, DesignationId, Stage + 1, NowStage, List);
                true ->
                    case lists:member(Stage, ActivationList) of
                        false ->
                            ActState = ?IF_ELSE(NowStage >= Stage, 2, 0),
                            get_activation_list_info(ActivationList, DesignationId, Stage + 1, NowStage, [{Stage, ActState, attribute_util:pack_attr(LvAttr)} | List]);
                        _ ->
                            get_activation_list_info(ActivationList, DesignationId, Stage + 1, NowStage, [{Stage, 1, attribute_util:pack_attr(LvAttr)} | List])
                    end
            end
    end.

%%使用称号
put_on_designation(Player, DesignationId) ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    case lists:member(DesignationId, Player#player.design) of
        true -> {2, Player};
        false ->
            DesignationList = StDesignation#st_designation.designation_list ++ StDesignation#st_designation.g_designation_list,
            case lists:keyfind(DesignationId, #designation.designation_id, DesignationList) of
                false -> {3, Player};
                Designation ->
                    Now = util:unixtime(),
                    if Designation#designation.time > 0 andalso Designation#designation.time < Now ->
                        {4, Player};
                        true ->
                            case data_designation:get(DesignationId) of
                                [] -> {3, Player};
                                Base ->
                                    if Base#base_designation.type == 1 orelse Base#base_designation.type == 2 orelse Base#base_designation.type == 3 ->
                                        L = filter_des(Player#player.design),
                                        case length(L) >= 3 of
                                            true -> {13, Player};
                                            false ->
                                                NewPlayer = Player#player{design = [DesignationId | L]},
                                                player:apply_state(async, self(), {activity, sys_notice, [94]}),
                                                {1, NewPlayer}
                                        end;
                                        true ->
                                            case length(Player#player.design) >= 3 of
                                                true -> {13, Player};
                                                false ->
                                                    NewPlayer = Player#player{design = [DesignationId | Player#player.design]},
                                                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                                                    {1, NewPlayer}
                                            end
                                    end
                            end
                    end
            end
    end.

filter_des(DesList) ->
    F = fun(DesId) ->
        case data_designation:get(DesId) of
            [] -> [];
            Base ->
                if Base#base_designation.type == 1 orelse Base#base_designation.type == 2 orelse Base#base_designation.type == 3 ->
                    [];
                    true -> [DesId]
                end
        end
    end,
    lists:flatmap(F, DesList).

%%脱下称号
put_off_designation(Player, DesignationId) ->
    DesignationList = lists:delete(DesignationId, Player#player.design),
    {1, Player#player{design = DesignationList}}.


%%激活称号
activate_designation(Player, DesignationId) ->
    case data_designation:get(DesignationId) of
        [] -> {5, Player};
        Base ->
            StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
            Now = util:unixtime(),
            GoodsCount = goods_util:get_goods_count(Base#base_designation.goods_id),
            if Base#base_designation.goods_num > GoodsCount -> {7, Player};
                Base#base_designation.is_global == 1 -> {10, Player};
                true ->
                    case lists:keytake(DesignationId, #designation.designation_id, StDesignation#st_designation.designation_list) of
                        false ->
                            NewPlayer = activate(DesignationId, Base, Now, Player, StDesignation, 1),
                            goods:subtract_good(Player, [{Base#base_designation.goods_id, Base#base_designation.goods_num}], 233),
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer};
                        {value, DesignationOld, T} ->
                            if DesignationOld#designation.time == 0 orelse DesignationOld#designation.time > Now ->
                                {6, Player};
                                true ->
                                    NewPlayer = activate(DesignationId, Base, Now, Player, StDesignation#st_designation{designation_list = T}, 1),
                                    goods:subtract_good(Player, [{Base#base_designation.goods_id, Base#base_designation.goods_num}], 233),
                                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

activate(DesignationId, Base, Now, Player, StDesignation, Type) ->
    Time = ?IF_ELSE(Base#base_designation.time_bar == 0, 0, Base#base_designation.time_bar + Now),
    Designation = #designation{designation_id = DesignationId, time = Time, stage = 1, is_enable = true},
    NewDesignation = designation_init:calc_single_attribute(Designation),
    StDesignation1 = StDesignation#st_designation{designation_list = [NewDesignation | StDesignation#st_designation.designation_list]},
    designation_load:replace_designation(StDesignation1),
    NewStDesignation = designation_init:calc_attribute(StDesignation1),
    lib_dict:put(?PROC_STATUS_DESIGNATION, NewStDesignation),
    NewPlayer = player_util:count_player_attribute(Player, true),
    designation_load:log_designation(Player#player.key, Player#player.nickname, 1, DesignationId, 1),
    NewPlayer1 =
        if
            Type == 0 -> %% 不替换称号
                NewPlayer;
            Base#base_designation.type == 1 orelse Base#base_designation.type == 2 orelse Base#base_designation.type == 3 ->
                L = filter_des(NewPlayer#player.design),
                NewPlayer#player{design = [DesignationId | L]};
            true ->
                case length(NewPlayer#player.design) >= 3 of
                    false ->
                        NewPlayer#player{design = [DesignationId | NewPlayer#player.design]};
                    true ->
                        NewPlayer
                end
        end,
    scene_agent_dispatch:designation_update(NewPlayer1),
    %% 主动推送44001更新称号列表
    Data = designation:designation_list(NewPlayer1),
    {ok, Bin} = pt_440:write(44001, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    fashion_suit:active_icon_push(NewPlayer),
    NewPlayer1.


%%检查成品激活
check_activate_by_goods(_Player, Args) ->
    DesignationId = ?IF_ELSE(is_list(Args), hd(Args), Args),
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    case data_designation:get(DesignationId) of
        [] -> {false, 6};
        _ ->
            case lists:keyfind(DesignationId, #designation.designation_id, StDesignation#st_designation.designation_list) of
                false -> true;
                Designation ->
                    Now = util:unixtime(),
                    if Designation#designation.time == 0 -> {false, 34};
                        Designation#designation.time > Now -> {false, 34};
                        true ->
                            true
                    end
            end
    end.

%%成品激活
activate_by_goods(Player, Args) ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    Now = util:unixtime(),
    [DesignationId, TimeBar] =
        case is_list(Args) of
            true -> Args;
            false ->
                [Args, 0]
        end,
    Base = data_designation:get(DesignationId),
    NewTimeBar = ?IF_ELSE(TimeBar > 0, TimeBar, Base#base_designation.time_bar),
    case lists:keytake(DesignationId, #designation.designation_id, StDesignation#st_designation.designation_list) of
        false ->
            activate(DesignationId, Base#base_designation{time_bar = NewTimeBar}, Now, Player, StDesignation, 1);
        {value, DesignationOld, T} ->
            if DesignationOld#designation.time == 0 -> Player;
                true ->
                    activate(DesignationId, Base#base_designation{time_bar = NewTimeBar}, Now, Player, StDesignation#st_designation{designation_list = T}, 1)
            end
    end.

%%增加称号
add_designation(Player, DesignationId) ->
    activate_by_goods(Player, DesignationId).

add_designation_global(Player, DesignationId) ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    Now = util:unixtime(),
    Base = data_designation:get(DesignationId),
    case lists:keytake(DesignationId, #designation.designation_id, StDesignation#st_designation.g_designation_list) of
        false ->
            activate_global(DesignationId, Base, Now, Player, StDesignation);
        {value, DesignationOld, T} ->
            if DesignationOld#designation.time == 0 -> Player;
                true ->
                    activate_global(DesignationId, Base, Now, Player, StDesignation#st_designation{g_designation_list = T})
            end
    end.

del_designation_global(Player, DesignationId) ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    case lists:keytake(DesignationId, #designation.designation_id, StDesignation#st_designation.g_designation_list) of
        false ->
            Player;
        {value, _, T} ->
            StDesignation1 = StDesignation#st_designation{g_designation_list = T},
            NewStDesignation = designation_init:calc_attribute(StDesignation1),
            lib_dict:put(?PROC_STATUS_DESIGNATION, NewStDesignation),
            NewPlayer = player_util:count_player_attribute(Player, true),
            NewPlayer1 = NewPlayer#player{design = lists:delete(DesignationId, Player#player.design)},
            scene_agent_dispatch:designation_update(NewPlayer1),
            NewPlayer1
    end.



activate_global(DesignationId, Base, Now, Player, StDesignation) ->
    Time = ?IF_ELSE(Base#base_designation.time_bar == 0, 0, Base#base_designation.time_bar + Now),
    Designation = #designation{designation_id = DesignationId, time = Time, stage = 1, is_enable = true},
    NewDesignation = designation_init:calc_single_attribute(Designation),
    StDesignation1 = StDesignation#st_designation{g_designation_list = [NewDesignation | StDesignation#st_designation.g_designation_list]},
    NewStDesignation = designation_init:calc_attribute(StDesignation1),
    lib_dict:put(?PROC_STATUS_DESIGNATION, NewStDesignation),
    NewPlayer = player_util:count_player_attribute(Player, true),
    designation_load:log_designation(Player#player.key, Player#player.nickname, 1, DesignationId, Designation#designation.stage),
    NewPlayer1 =
        if
            Base#base_designation.type == 1 orelse Base#base_designation.type == 2 orelse Base#base_designation.type == 3 ->
                L = filter_des(NewPlayer#player.design),
                NewPlayer#player{design = [DesignationId | L]};
            true ->
                case length(NewPlayer#player.design) >= 3 of
                    false ->
                        NewPlayer#player{design = [DesignationId | NewPlayer#player.design]};
                    true ->
                        NewPlayer
                end
        end,
    scene_agent_dispatch:designation_update(NewPlayer1),
    NewPlayer1.


%%玩家离线,增加称号
add_designation_offline(Pkey, DesignationId, Now) ->
    Base = data_designation:get(DesignationId),
    Time = ?IF_ELSE(Base#base_designation.time_bar == 0, 0, Base#base_designation.time_bar + Now),
    Designation = #designation{designation_id = DesignationId, time = Time, stage = 1},
    designation_load:log_designation(Pkey, shadow_proc:get_name(Pkey), 1, DesignationId, Designation#designation.stage),
    case designation_load:load_designation(Pkey) of
        [] ->
            StDesignation = #st_designation{pkey = Pkey, designation_list = [Designation], is_change = 1},
            designation_load:replace_designation(StDesignation),
            ok;
        [DesignationList] ->
            NewDesignationList = designation_init:designation2list(DesignationList, Now),
            case lists:keytake(DesignationId, #designation.designation_id, NewDesignationList) of
                false ->
                    StDesignation = #st_designation{pkey = Pkey, designation_list = [Designation | NewDesignationList], is_change = 1},
                    designation_load:replace_designation(StDesignation);
                {value, _Desination, T} ->
                    if Base#base_designation.time_bar == 0 -> ok;
                        true ->
                            StDesignation = #st_designation{pkey = Pkey, designation_list = [Designation | T], is_change = 1},
                            designation_load:replace_designation(StDesignation)
                    end
            end

    end.


%%是否激活
is_activate(DesignationId) ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    case lists:keyfind(DesignationId, #designation.designation_id, StDesignation#st_designation.designation_list) of
        false -> false;
        Designation ->
            if Designation#designation.time == 0 -> true;
                true ->
                    false
            end
    end.


%%包括限时的是否激活
is_activate2(DesignationId) ->
    NowTime = util:unixtime(),
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    case lists:keyfind(DesignationId, #designation.designation_id, StDesignation#st_designation.designation_list) of
        false -> {false, 0};
        Designation ->
            if Designation#designation.time == 0 -> {true, Designation#designation.stage};
                Designation#designation.time > NowTime -> {true, Designation#designation.stage};
                true ->
                    {false, 0}
            end
    end.

%%升级
upgrade_designation(Player, DesignationId) ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    case lists:keytake(DesignationId, #designation.designation_id, StDesignation#st_designation.designation_list) of
        false -> {3, Player};
        {value, Designation, T} ->
            case data_designation_upgrade:get(DesignationId, Designation#designation.stage + 1) of
                [] -> {8, Player};
                _ ->
                    Base = data_designation_upgrade:get(DesignationId, Designation#designation.stage),
                    GoodsCount = goods_util:get_goods_count(Base#base_designation_upgrade.goods_id),
                    if GoodsCount < Base#base_designation_upgrade.goods_num -> {9, Player};
                        Designation#designation.is_enable == false -> {2, Player};
                        Designation#designation.time > 0 -> {12, Player};
                        true ->
                            Designation1 = Designation#designation{stage = Designation#designation.stage + 1},
                            NewDesignation = designation_init:calc_single_attribute(Designation1),
                            StDesignation1 = StDesignation#st_designation{designation_list = [NewDesignation | T], is_change = 1},
                            NewStDesignation = designation_init:calc_attribute(StDesignation1),
                            lib_dict:put(?PROC_STATUS_DESIGNATION, NewStDesignation),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            goods:subtract_good(Player, [{Base#base_designation_upgrade.goods_id, Base#base_designation_upgrade.goods_num}], 234),
                            designation_load:log_designation(Player#player.key, Player#player.nickname, 2, DesignationId, Designation1#designation.stage),
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer}
                    end
            end
    end.

get_notice_player(_Player) ->
    Ids = data_designation:id_list(),
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    Now = util:unixtime(),
    F = fun(DesignationId) ->
        Base = data_designation:get(DesignationId),
        GoodsCount = goods_util:get_goods_count(Base#base_designation.goods_id),
        if
            Base#base_designation.goods_num == 0 -> [];
            Base#base_designation.is_global == 1 -> [];
            Base#base_designation.goods_num > GoodsCount -> [];
            true ->
                case lists:keytake(DesignationId, #designation.designation_id, StDesignation#st_designation.designation_list) of
                    false ->
                        [1];
                    {value, DesignationOld, _T} ->
                        if
                            DesignationOld#designation.time == 0 orelse DesignationOld#designation.time > Now -> [];
                            true -> [1]
                        end
                end
        end
    end,
    List = lists:flatmap(F, Ids),
    F2 = fun(DesignationId) ->
        case lists:keytake(DesignationId, #designation.designation_id, StDesignation#st_designation.designation_list) of
            false -> [];
            {value, Designation, _T} ->
                case data_designation_upgrade:get(DesignationId, Designation#designation.stage + 1) of
                    [] -> [];
                    _ ->
                        Base = data_designation_upgrade:get(DesignationId, Designation#designation.stage),
                        GoodsCount = goods_util:get_goods_count(Base#base_designation_upgrade.goods_id),
                        if
                            GoodsCount < Base#base_designation_upgrade.goods_num -> [];
                            Designation#designation.is_enable == false -> [];
                            Designation#designation.time > 0 -> [];
                            true -> [1]
                        end
                end
        end
    end,
    List2 = lists:flatmap(F2, Ids),
    ?IF_ELSE(List ++ List2 == [], 0, 1).


%%成品激活 不替换
activate_by_goods_1(Player, GoodsId) ->
    Count = goods_util:get_goods_count(GoodsId),
    if
        Count =< 0 -> {false, 7};
        true ->
            StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
            Now = util:unixtime(),
            GoodsTypeInfo = data_goods:get(GoodsId),
            Args = GoodsTypeInfo#goods_type.special_param_list,
            [DesignationId, TimeBar] =
                case is_list(Args) of
                    true -> Args;
                    false ->
                        [Args, 0]
                end,
            Base = data_designation:get(DesignationId),
            NewTimeBar = ?IF_ELSE(TimeBar > 0, TimeBar, Base#base_designation.time_bar),
            goods:subtract_good(Player, [{GoodsId, 1}], 233),
            case lists:keytake(DesignationId, #designation.designation_id, StDesignation#st_designation.designation_list) of
                false ->
                    activate(DesignationId, Base#base_designation{time_bar = NewTimeBar}, Now, Player, StDesignation, 0);
                {value, DesignationOld, T} ->
                    IsSpDesignation = lists:member(GoodsTypeInfo#goods_type.subtype, [546, 548, 549]),
                    if
                        IsSpDesignation -> {false, 14};
                        DesignationOld#designation.time == 0 -> Player;
                        true ->
                            activate(DesignationId, Base#base_designation{time_bar = NewTimeBar}, Now, Player, StDesignation#st_designation{designation_list = T}, 0)
                    end
            end
    end.

activation_stage_lv(Player, DesignationId) ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    case lists:keytake(DesignationId, #designation.designation_id, StDesignation#st_designation.designation_list) of
        false -> {3, Player};
        {value, Designation, T} ->
            StageList = get_stage_list(DesignationId, Designation#designation.stage),
            NewActivationList = StageList -- Designation#designation.activation_list,
            if
                NewActivationList == [] -> {15, Player};
                true ->
                    Designation1 = Designation#designation{activation_list =NewActivationList ++ Designation#designation.activation_list},
                    NewDesignation = designation_init:calc_single_attribute(Designation1),
                    StDesignation1 = StDesignation#st_designation{designation_list = [NewDesignation | T], is_change = 1},
                    NewStDesignation = designation_init:calc_attribute(StDesignation1),
                    lib_dict:put(?PROC_STATUS_DESIGNATION, NewStDesignation),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    {1, NewPlayer}
            end
    end.

get_stage_list(Id, Stage) ->
    F = fun(Stage0, List) ->
        case data_designation_upgrade:get(Id, Stage0) of
            [] -> List;
            #base_designation_upgrade{lv_attr = LvAttr} ->
                if
                    LvAttr == [] -> List;
                    true -> [Stage0 | List]
                end
        end
    end,
    lists:foldl(F, [], lists:seq(1, Stage)).


