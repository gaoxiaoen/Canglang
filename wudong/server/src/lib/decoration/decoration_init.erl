%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 七月 2017 12:00
%%%-------------------------------------------------------------------
-module(decoration_init).
-author("hxming").


-include("server.hrl").
-include("common.hrl").
-include("decoration.hrl").


%% ====================================================================
%% API functions
%% ====================================================================
-export([init/1, decoration2string/1, timer_update/0, logout/0, check_decoration_timeout/2, get_attribute/0, calc_attribute/1, calc_single_attribute/1]).

init(Player) ->
    Now = util:unixtime(),
    StDecoration =
        case player_util:is_new_role(Player) of
            true ->
                #st_decoration{pkey = Player#player.key};
            false ->
                case decoration_load:load_decoration(Player#player.key) of
                    [] ->
                        #st_decoration{pkey = Player#player.key};
                    [DecorationList] ->
                        NewDecorationList = decoration2list(DecorationList, Now),
                        DecorationId = fetch_used_decoration(NewDecorationList),
                        #st_decoration{pkey = Player#player.key, decoration_list = NewDecorationList, decoration_id = DecorationId}
                end
        end,
    NewStDecoration = calc_attribute(StDecoration),
    lib_dict:put(?PROC_STATUS_DECORATION, NewStDecoration),
    Player#player{fashion = Player#player.fashion#fashion_figure{fashion_decoration_id = StDecoration#st_decoration.decoration_id}}.


decoration2list(DecorationList, Now) ->
    F = fun(Info) ->

        {DecorationId, Time, Stage, IsUse, ActivationList} =
            case Info of
                {DecorationId0, Time0, Stage0, IsUse0} -> {DecorationId0, Time0, Stage0, IsUse0, []};
                {DecorationId0, Time0, Stage0, IsUse0, ActivationList0} ->
                    {DecorationId0, Time0, Stage0, IsUse0, ActivationList0}
            end,
        NewIsUse =
            if IsUse == 1 ->
                if Time > 0 andalso Time < Now -> 0;
                    true -> IsUse
                end;
                true -> IsUse
            end,
        IsEnable = ?IF_ELSE(Time == 0 orelse Time > Now, true, false),
        #decoration{decoration_id = DecorationId, time = Time, stage = Stage, is_use = NewIsUse, is_enable = IsEnable, activation_list = ActivationList}
    end,
    lists:map(F, util:bitstring_to_term(DecorationList)).
decoration2string(DecorationList) ->
    F = fun(Decoration) ->
        {Decoration#decoration.decoration_id, Decoration#decoration.time, Decoration#decoration.stage, Decoration#decoration.is_use, Decoration#decoration.activation_list}
    end,
    util:term_to_bitstring(lists:map(F, DecorationList)).

%%计算属性
calc_attribute(StDecoration) ->
    F = fun(Decoration) ->
        if Decoration#decoration.is_enable ->
            calc_single_attribute(Decoration);
            true -> Decoration
        end
    end,
    DecorationList = lists:map(F, StDecoration#st_decoration.decoration_list),
    AttributeList = [Decoration#decoration.attribute || Decoration <- DecorationList],
    Attribute = attribute_util:sum_attribute(AttributeList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    StDecoration#st_decoration{decoration_list = DecorationList, attribute = Attribute, cbp = Cbp}.

%%计算单泡泡属性
calc_single_attribute(Decoration) ->
    AttrList1 =
        case data_decoration:get(Decoration#decoration.decoration_id) of
            [] ->
                [];
            Base -> Base#base_decoration.attrs
        end,
    AttrList2 =
        case data_decoration_upgrade:get(Decoration#decoration.decoration_id, Decoration#decoration.stage) of
            [] -> [];
            Base1 -> Base1#base_decoration_upgrade.attrs
        end,
    F = fun(Stage) ->
        case data_decoration_upgrade:get(Decoration#decoration.decoration_id, Stage) of
            [] -> [];
            Base2 -> Base2#base_decoration_upgrade.lv_attr
        end
    end,
    AttrList3 = lists:flatmap(F, Decoration#decoration.activation_list), %% 等级额外属性
    AttrList = AttrList1 ++ AttrList2 ++ AttrList3,
    Attribute = attribute_util:make_attribute_by_key_val_list(AttrList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    Decoration#decoration{attribute = Attribute, cbp = Cbp}.

get_attribute() ->
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    StDecoration#st_decoration.attribute.

%%检查泡泡过期
check_decoration_timeout(Player, Now) ->
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    case [Decoration || Decoration <- StDecoration#st_decoration.decoration_list, Decoration#decoration.time > 0, Decoration#decoration.time < Now, Decoration#decoration.is_enable] of
        [] -> Player;
        L ->
            F = fun(Decoration, T) ->
                decoration_load:log_decoration(Player#player.key, Player#player.nickname, 3, Decoration#decoration.decoration_id, Decoration#decoration.stage),
                [Decoration#decoration{attribute = #attribute{}, cbp = 0, is_enable = false, is_use = 0} | lists:keydelete(Decoration#decoration.decoration_id, #decoration.decoration_id, T)]
            end,
            DecorationList = lists:foldl(F, StDecoration#st_decoration.decoration_list, L),
            StDecoration1 = StDecoration#st_decoration{decoration_list = DecorationList, is_change = 1},
            NewStDecoration = calc_attribute(StDecoration1),
            lib_dict:put(?PROC_STATUS_DECORATION, NewStDecoration),
            Player1 = player_util:count_player_attribute(Player, true),
            case lists:keymember(Player#player.fashion#fashion_figure.fashion_decoration_id, #decoration.decoration_id, L) of
                false -> Player1;
                true ->
                    NewPlayer = Player1#player{fashion = Player#player.fashion#fashion_figure{fashion_decoration_id = 0}},
                    NewPlayer
            end
    end.

%%获取当前使用中的泡泡
fetch_used_decoration(DecorationList) ->
    case lists:keyfind(1, #decoration.is_use, DecorationList) of
        false -> 0;
        Decoration -> Decoration#decoration.decoration_id
    end.

%%定时更新
timer_update() ->
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    if StDecoration#st_decoration.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_DECORATION, StDecoration#st_decoration{is_change = 0}),
        decoration_load:replace_decoration(StDecoration);
        true ->
            ok
    end.

%%玩家离线
logout() ->
    StDecoration = lib_dict:get(?PROC_STATUS_DECORATION),
    if StDecoration#st_decoration.is_change == 1 ->
        decoration_load:replace_decoration(StDecoration);
        true ->
            ok
    end.
