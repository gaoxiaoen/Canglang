%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2017 15:19
%%%-------------------------------------------------------------------
-module(mon_photo_init).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("mon_photo.hrl").

%% API
-export([init/1, timer_update/0, logout/0, photo2list/1, calc_attribute/1, get_attribute/0]).

init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_MON_PHOTO, #st_mon_photo{pkey = Player#player.key});
        false ->
            case mon_photo_load:load(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_MON_PHOTO, #st_mon_photo{pkey = Player#player.key});
                [PhotoList, MonList] ->
                    StMonPhoto = #st_mon_photo{pkey = Player#player.key, photo_list = list2photo(PhotoList), mon_list = util:bitstring_to_term(MonList)},
                    StMonPhoto1 = calc_attribute(StMonPhoto),
                    lib_dict:put(?PROC_STATUS_MON_PHOTO, StMonPhoto1)
            end
    end,
    Player.

photo2list(PhotoList) ->
    F = fun(Photo) -> {Photo#mon_photo.mid, Photo#mon_photo.lv, Photo#mon_photo.num} end,
    util:term_to_bitstring(lists:map(F, PhotoList)).

list2photo(PhotoList) ->
    F = fun({Mid, Lv, Num}) ->
        #mon_photo{mid = Mid, lv = Lv, num = Num}
        end,
    lists:map(F, util:bitstring_to_term(PhotoList)).

calc_attribute(StMonPhoto) ->
    F = fun(Photo) ->
        case data_mon_photo_upgrade:get(Photo#mon_photo.mid, Photo#mon_photo.lv) of
            [] -> [];
            Base -> Base#base_mon_photo_upgrade.attrs
        end
        end,
    AttrsList = lists:flatmap(F, StMonPhoto#st_mon_photo.photo_list),
    Attribute = attribute_util:make_attribute_by_key_val_list(AttrsList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    StMonPhoto#st_mon_photo{attribute = Attribute, cbp = Cbp}.

get_attribute() ->
    StMonPhoto = lib_dict:get(?PROC_STATUS_MON_PHOTO),
    StMonPhoto#st_mon_photo.attribute.

timer_update() ->
    StMonPhoto = lib_dict:get(?PROC_STATUS_MON_PHOTO),
    if StMonPhoto#st_mon_photo.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_MON_PHOTO, StMonPhoto#st_mon_photo{is_change = 0}),
        mon_photo_load:replace(StMonPhoto);
        true -> ok
    end.

logout() ->
    StMonPhoto = lib_dict:get(?PROC_STATUS_MON_PHOTO),
    if StMonPhoto#st_mon_photo.is_change == 1 ->
        mon_photo_load:replace(StMonPhoto);
        true -> ok
    end.