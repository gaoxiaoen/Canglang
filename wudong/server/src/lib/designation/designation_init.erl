%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2017 14:39
%%%-------------------------------------------------------------------
-module(designation_init).


-include("server.hrl").
-include("common.hrl").
-include("designation.hrl").


%% ====================================================================
%% API functions
%% ====================================================================
-export([init/1, designation2string/1, designation2list/2, timer_update/0, logout/0, check_designation_timeout/2, get_attribute/0, calc_attribute/1, calc_single_attribute/1]).

init(Player) ->
    Now = util:unixtime(),
    StDesignation =
        case player_util:is_new_role(Player) of
            true ->
                #st_designation{pkey = Player#player.key};
            false ->
                GlobalList = init_global(Player, Now),
                case designation_load:load_designation(Player#player.key) of
                    [] ->
                        #st_designation{pkey = Player#player.key, g_designation_list = GlobalList};
                    [DesignationList] ->
                        NewDesignationList = designation2list(DesignationList, Now),
                        #st_designation{pkey = Player#player.key, designation_list = NewDesignationList, g_designation_list = GlobalList}
                end
        end,
    NewStDesignation = calc_attribute(StDesignation),
    lib_dict:put(?PROC_STATUS_DESIGNATION, NewStDesignation),
    F = fun(DesId) ->
        case lists:keyfind(DesId, #designation.designation_id, NewStDesignation#st_designation.designation_list) of
            false ->
                case lists:keymember(DesId, #designation.designation_id, NewStDesignation#st_designation.g_designation_list) of
                    true -> [DesId];
                    false -> []
                end;
            Des ->
                ?IF_ELSE(Des#designation.is_enable, [DesId], [])
        end
    end,
    Design = lists:flatmap(F, Player#player.design),
    NewDesign = filter_des(Design),
    Player#player{design = NewDesign}.

filter_des(Design) ->
    F1 = fun(Id, {L1, L2}) ->
        case data_designation:get(Id) of
            [] -> {L1, L2};
            Base ->
                if Base#base_designation.type == 2 ->
                    {L1, [Id | L2]};
                    true ->
                        {[Id | L1], L2}
                end
        end
    end,
    {L11, L22} = lists:foldl(F1, {[], []}, Design),
    case length(L22) > 1 of
        true ->
            [lists:max(L22) | L11];
        false ->
            Design
    end.

%%初始化全局称号
init_global(Player, Now) ->
    Data = ets:match_object(?ETS_DESIGNATION_GLOBAL, #designation_global{pkey = Player#player.key, _ = '_'}),
    F = fun(DesignationGlobal, L) ->
        case data_designation:get(DesignationGlobal#designation_global.designation_id) of
            [] -> L;
            Base ->
                case lists:keymember(DesignationGlobal#designation_global.designation_id, #designation.designation_id, L) of
                    true -> L;
                    false ->
                        if Base#base_designation.time_bar == 0 ->
                            [#designation{designation_id = DesignationGlobal#designation_global.designation_id, stage = 1, is_enable = true} | L];
                            DesignationGlobal#designation_global.get_time + Base#base_designation.time_bar > Now ->
                                [#designation{
                                    designation_id = DesignationGlobal#designation_global.designation_id,
                                    stage = 1,
                                    is_enable = true,
                                    time = DesignationGlobal#designation_global.get_time + Base#base_designation.time_bar
                                } | L];
                            true -> L
                        end
                end
        end
    end,
    lists:foldl(F, [], Data).


designation2list(DesignationList, Now) ->
    F = fun(Info) ->
        {DesignationId, Time, Stage, ActivationList} =
            case Info of
                {FashionId0, Time0, Stage0} -> {FashionId0, Time0, Stage0, []};
                {FashionId0, Time0, Stage0, ActivationList0} -> {FashionId0, Time0, Stage0, ActivationList0}
            end,
        IsEnable = ?IF_ELSE(Time == 0 orelse Time > Now, true, false),
        #designation{designation_id = DesignationId, time = Time, stage = Stage, is_enable = IsEnable, activation_list = ActivationList}
    end,
    lists:map(F, util:bitstring_to_term(DesignationList)).
designation2string(DesignationList) ->
    F = fun(Designation) ->
        {Designation#designation.designation_id, Designation#designation.time, Designation#designation.stage, Designation#designation.activation_list}
    end,
    util:term_to_bitstring(lists:map(F, DesignationList)).

%%计算属性
calc_attribute(StDesignation) ->
    F = fun(Designation) ->
        if Designation#designation.is_enable ->
            calc_single_attribute(Designation);
            true -> Designation
        end
    end,
    DesignationList = lists:map(F, StDesignation#st_designation.designation_list),
    GDesignationList = lists:map(F, StDesignation#st_designation.g_designation_list),
    AttributeList = [Designation#designation.attribute || Designation <- DesignationList ++ GDesignationList],
    Attribute = attribute_util:sum_attribute(AttributeList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    StDesignation#st_designation{designation_list = DesignationList, g_designation_list = GDesignationList, attribute = Attribute, cbp = Cbp}.

%%计算单称号属性
calc_single_attribute(Designation) ->
    AttrList1 =
        case data_designation:get(Designation#designation.designation_id) of
            [] ->
                [];
            Base -> Base#base_designation.attrs
        end,
    AttrList2 =
        case data_designation_upgrade:get(Designation#designation.designation_id, Designation#designation.stage) of
            [] -> [];
            Base1 -> Base1#base_designation_upgrade.attrs
        end,
    F = fun(Stage) ->
        case data_designation_upgrade:get(Designation#designation.designation_id, Stage) of
            [] -> [];
            Base2 -> Base2#base_designation_upgrade.lv_attr
        end
    end,
    AttrList3 = lists:flatmap(F, Designation#designation.activation_list), %% 等级额外属性
    AttrList = AttrList1 ++ AttrList2 ++ AttrList3,
    Attribute = attribute_util:make_attribute_by_key_val_list(AttrList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    Designation#designation{attribute = Attribute, cbp = Cbp}.

get_attribute() ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    StDesignation#st_designation.attribute.

%%检查称号过期
check_designation_timeout(Player, Now) ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    case [Designation || Designation <- StDesignation#st_designation.designation_list ++ StDesignation#st_designation.g_designation_list, Designation#designation.time > 0, Designation#designation.time < Now, Designation#designation.is_enable] of
        [] -> Player;
        L ->
            F = fun(Designation, T) ->
                case lists:keytake(Designation#designation.designation_id, #designation.designation_id, T) of
                    false ->
                        T;
                    {value, _, T1} ->
                        designation_load:log_designation(Player#player.key, Player#player.nickname, 3, Designation#designation.designation_id, Designation#designation.stage),
                        [Designation#designation{attribute = #attribute{}, cbp = 0, is_enable = false} | T1]
                end
            end,
            DesignationList = lists:foldl(F, StDesignation#st_designation.designation_list, L),
            GDesignationList = lists:foldl(F, StDesignation#st_designation.g_designation_list, L),
            StDesignation1 = StDesignation#st_designation{designation_list = DesignationList, g_designation_list = GDesignationList, is_change = 1},
            NewStDesignation = calc_attribute(StDesignation1),
            lib_dict:put(?PROC_STATUS_DESIGNATION, NewStDesignation),
            Player1 = player_util:count_player_attribute(Player, true),
            F1 = fun(Id) ->
                case lists:keymember(Id, #designation.designation_id, L) of
                    true -> [];
                    false -> [Id]
                end
            end,
            DesignList = lists:flatmap(F1, Player#player.design),
            NewPlayer = Player1#player{design = DesignList},
            ?DO_IF(Player#player.design /= DesignList, scene_agent_dispatch:designation_update(NewPlayer)),
            NewPlayer
    end.


%%定时更新
timer_update() ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    if StDesignation#st_designation.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_DESIGNATION, StDesignation#st_designation{is_change = 0}),
        designation_load:replace_designation(StDesignation);
        true ->
            ok
    end.

%%玩家离线
logout() ->
    StDesignation = lib_dict:get(?PROC_STATUS_DESIGNATION),
    if StDesignation#st_designation.is_change == 1 ->
        designation_load:replace_designation(StDesignation);
        true ->
            ok
    end.
