%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 二月 2017 17:44
%%%-------------------------------------------------------------------
-module(smelt_init).
-author("hxming").

-include("smelt.hrl").
-include("common.hrl").
%% API
-export([init/1,
    timer_update/0,
    logout/0,
    calc_attribute/1,
    get_attribute/0,
    upgrade_lv/1
]).

init(Player) ->
    StSmelt =
        case player_util:is_new_role(Player) of
            true ->
                #st_smelt{pkey = Player#player.key};
            false ->
                case Player#player.lv < ?SMELT_OPEN_LV of
                    true ->
                        #st_smelt{pkey = Player#player.key};
                    false ->
                        case smelt_load:load_player_smelt(Player#player.key) of
                            [] ->
                                #st_smelt{pkey = Player#player.key, stage = 1, is_change = 1};
                            [Stage, Exp] ->
                                #st_smelt{pkey = Player#player.key, stage = Stage, exp = Exp}
                        end
                end
        end,
    NewStSmelt = calc_attribute(StSmelt),
    lib_dict:put(?PROC_STATUS_SMELT, NewStSmelt),
    Player.

calc_attribute(StSmelt) ->
    case data_smelt:get(StSmelt#st_smelt.stage) of
        [] -> StSmelt;
        Base ->
            Attribute = attribute_util:make_attribute_by_key_val_list(Base#base_smelt.attrs),
            Cbp = attribute_util:calc_combat_power(Attribute),
            StSmelt#st_smelt{attribute = Attribute, cbp = Cbp}
    end.

get_attribute() ->
    St = lib_dict:get(?PROC_STATUS_SMELT),
    St#st_smelt.attribute.

timer_update() ->
    St = lib_dict:get(?PROC_STATUS_SMELT),
    if St#st_smelt.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_SMELT, St#st_smelt{is_change = 1}),
        smelt_load:replace_player_smelt(St);
        true ->
            ok
    end.

logout() ->
    St = lib_dict:get(?PROC_STATUS_SMELT),
    if St#st_smelt.is_change == 1 ->
        smelt_load:replace_player_smelt(St);
        true ->
            ok
    end.

upgrade_lv(Player) ->
    case Player#player.lv < ?SMELT_OPEN_LV of
        true -> Player;
        false ->
            St = lib_dict:get(?PROC_STATUS_SMELT),
            if St#st_smelt.stage =/= 0 -> Player;
                true ->
                    St1 = St#st_smelt{stage = 1, is_change = 1},
                    NewSt = calc_attribute(St1),
                    lib_dict:put(?PROC_STATUS_SMELT, NewSt),
                    player_util:count_player_attribute(Player, true)
            end
    end.