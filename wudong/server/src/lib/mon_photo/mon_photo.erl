%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 一月 2017 15:19
%%%-------------------------------------------------------------------
-module(mon_photo).
-author("hxming").
-include("server.hrl").
-include("common.hrl").
-include("mon_photo.hrl").
-include("tips.hrl").
-include("scene.hrl").

%% API
-compile(export_all).

-define(MON_PHOTO_STATE_LOCK, 0).
-define(MON_PHOTO_STATE_UNLOCK, 1).
-define(MON_PHOTO_STATE_NORMAL, 2).


cmd_kill(Player, Mid, Num) ->
    case data_mon_photo_upgrade:ratio(Mid, 0) of
        0 -> ok;
        _ ->
            StMonPhoto = lib_dict:get(?PROC_STATUS_MON_PHOTO),
            PhotoList =
                case lists:keytake(Mid, #mon_photo.mid, StMonPhoto#st_mon_photo.photo_list) of
                    false ->
                        [#mon_photo{mid = Mid, num = Num} | StMonPhoto#st_mon_photo.photo_list];
                    {value, Photo, T} ->
                        [Photo#mon_photo{num = Photo#mon_photo.num + Num} | T]
                end,
            notice_msg(Player, Mid, Num),
            NewStMonPhoto = StMonPhoto#st_mon_photo{photo_list = PhotoList, is_change = 1},
            lib_dict:put(?PROC_STATUS_MON_PHOTO, NewStMonPhoto)
    end.

add_by_goods(Player, Mid, Num) ->
    StMonPhoto = lib_dict:get(?PROC_STATUS_MON_PHOTO),
    PhotoList =
        case lists:keytake(Mid, #mon_photo.mid, StMonPhoto#st_mon_photo.photo_list) of
            false ->
                [#mon_photo{mid = Mid, num = Num} | StMonPhoto#st_mon_photo.photo_list];
            {value, Photo, T} ->
                [Photo#mon_photo{num = Photo#mon_photo.num + Num} | T]
        end,
    notice_msg(Player, Mid, Num),
    NewStMonPhoto = StMonPhoto#st_mon_photo{photo_list = PhotoList, is_change = 1},
    lib_dict:put(?PROC_STATUS_MON_PHOTO, NewStMonPhoto).

check_first_kill(Player, Mon) ->
    Mid = Mon#mon.mid,
    StMonPhoto = lib_dict:get(?PROC_STATUS_MON_PHOTO),
    case lists:keytake(Mid, 1, StMonPhoto#st_mon_photo.mon_list) of
        false ->
            {ok, NewPlayer} =
                case ratio_goods(Mon#mon.drop_kill) of
                    [] -> {ok, Player};
                    GoodsList ->
                        goods:give_goods(Player, goods:make_give_goods_list(238, GoodsList))
                end,
            %%首次击杀有掉落
            NewStMonPhoto = StMonPhoto#st_mon_photo{mon_list = [{Mid, 1} | StMonPhoto#st_mon_photo.mon_list], is_change = 1},
            {NewStMonPhoto, NewPlayer};
        _ ->
            {StMonPhoto, Player}
    end.

ratio_goods(GoodsList) ->
    F = fun({GoodsId, Num, Ratio}) ->
        case util:odds(Ratio, 100) of
            false -> [];
            true -> [{GoodsId, Num}]
        end
        end,
    lists:flatmap(F, GoodsList).

%%击杀怪物
kill_mon(Player, Mon) ->
    Mid = Mon#mon.mid,
    {StMonPhoto, NewPlayer} = check_first_kill(Player, Mon),
    case data_mon_photo_upgrade:ratio(Mid, 0) of
        0 ->
            lib_dict:put(?PROC_STATUS_MON_PHOTO, StMonPhoto);
        Ratio0 ->
            case lists:keytake(Mid, #mon_photo.mid, StMonPhoto#st_mon_photo.photo_list) of
                false ->
                    case util:odds(Ratio0 * 100, 10000) of
                        true ->
                            PhotoList = [#mon_photo{mid = Mid, num = 1} | StMonPhoto#st_mon_photo.photo_list],
                            NewStMonPhoto = StMonPhoto#st_mon_photo{photo_list = PhotoList, is_change = 1},
                            notice_msg(Player, Mid, 1),
                            lib_dict:put(?PROC_STATUS_MON_PHOTO, NewStMonPhoto);
                        false ->
                            lib_dict:put(?PROC_STATUS_MON_PHOTO, StMonPhoto)
                    end;
                {value, Photo, T} ->
                    case util:odds(data_mon_photo_upgrade:ratio(Mid, Photo#mon_photo.lv), 100) of
                        true ->
                            PhotoList = [Photo#mon_photo{num = Photo#mon_photo.num + 1} | T],
                            NewStMonPhoto = StMonPhoto#st_mon_photo{photo_list = PhotoList, is_change = 1},
                            notice_msg(Player, Mid, 1),
                            lib_dict:put(?PROC_STATUS_MON_PHOTO, NewStMonPhoto);
                        false ->
                            lib_dict:put(?PROC_STATUS_MON_PHOTO, StMonPhoto)
                    end
            end

    end,
    {ok, NewPlayer}.

%%图鉴信息
mon_photo_info() ->
    StMonPhoto = lib_dict:get(?PROC_STATUS_MON_PHOTO),
    AttributeList = attribute_util:pack_attr(StMonPhoto#st_mon_photo.attribute),
    F = fun(Type) ->
        [Type, get_scene(Type, StMonPhoto#st_mon_photo.photo_list)]
        end,
    PhotoList = lists:map(F, data_mon_photo:type_list()),
    {StMonPhoto#st_mon_photo.cbp, AttributeList, PhotoList}.

get_scene(Type, PhotoList) ->
    F1 = fun(Mid) ->
        case lists:keyfind(Mid, #mon_photo.mid, PhotoList) of
            false -> false;
            Photo ->
                Base = data_mon_photo_upgrade:get(Mid, Photo#mon_photo.lv),
                if Photo#mon_photo.num >= Base#base_mon_photo_upgrade.num_lim ->
                    NextBase = data_mon_photo_upgrade:get(Mid, Photo#mon_photo.lv + 1),
                    NextBase /= [];
                    true -> false
                end
        end
         end,
    F = fun(SceneId) ->
        IsUpgrade =
            case lists:any(F1, data_mon_photo:get_mon(SceneId)) of
                true -> 1;
                false -> 0
            end,
        [SceneId, IsUpgrade]
        end,
    lists:map(F, data_mon_photo:get_scene(Type)).

%%获取怪物图鉴
get_mon_photo(SceneId) ->
    StMonPhoto = lib_dict:get(?PROC_STATUS_MON_PHOTO),
    F = fun(Mid) ->
        case lists:keyfind(Mid, #mon_photo.mid, StMonPhoto#st_mon_photo.photo_list) of
            false ->
                Base = data_mon_photo_upgrade:get(Mid, 0),
                [Mid, 0, 0, Base#base_mon_photo_upgrade.num_lim, ?MON_PHOTO_STATE_LOCK];
            Photo ->
                Base = data_mon_photo_upgrade:get(Mid, Photo#mon_photo.lv),
                NextBase = data_mon_photo_upgrade:get(Mid, Photo#mon_photo.lv + 1),
                State = ?IF_ELSE(Photo#mon_photo.num >= Base#base_mon_photo_upgrade.num_lim andalso NextBase /= [], ?MON_PHOTO_STATE_UNLOCK, ?MON_PHOTO_STATE_NORMAL),
                [Mid, Photo#mon_photo.lv, Photo#mon_photo.num, Base#base_mon_photo_upgrade.num_lim, State]
        end
        end,
    lists:map(F, data_mon_photo:get_mon(SceneId)).

%%升级
upgrade(Player, Mid) ->
    StMonPhoto = lib_dict:get(?PROC_STATUS_MON_PHOTO),
    case lists:keytake(Mid, #mon_photo.mid, StMonPhoto#st_mon_photo.photo_list) of
        false -> {2, Player};
        {value, Photo, T} ->
            Base = data_mon_photo_upgrade:get(Mid, Photo#mon_photo.lv),
            IsLim = ?IF_ELSE(data_mon_photo_upgrade:get(Mid, Photo#mon_photo.lv + 1) == [], true, false),
            if IsLim -> {4, Player};
                Base#base_mon_photo_upgrade.num_lim > Photo#mon_photo.num -> {3, Player};
                true ->
                    NewPhoto = Photo#mon_photo{lv = Photo#mon_photo.lv + 1, num = Photo#mon_photo.num - Base#base_mon_photo_upgrade.num_lim},
                    StMonPhoto1 = StMonPhoto#st_mon_photo{photo_list = [NewPhoto | T], is_change = 1},
                    NewStMonPhoto = mon_photo_init:calc_attribute(StMonPhoto1),
                    lib_dict:put(?PROC_STATUS_MON_PHOTO, NewStMonPhoto),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    refresh_photo(Player, NewPhoto, NewStMonPhoto),
                    mon_photo_load:log_mon_photo(Player#player.key, Player#player.nickname, Mid, NewPhoto#mon_photo.lv),
                    activity:get_notice(Player, [95], true),
                    {1, NewPlayer}
            end
    end.

get_notice_player(Player) ->
    Tips = check_upgrade_state(Player, #tips{}),
    ?IF_ELSE(Tips#tips.state == 1, 1, 0).

check_upgrade_state(_Player, Tips) ->
    StMonPhoto = lib_dict:get(?PROC_STATUS_MON_PHOTO),
    F = fun(Photo) ->
        Mid = Photo#mon_photo.mid,
        Base = data_mon_photo_upgrade:get(Mid, Photo#mon_photo.lv),
        IsLim = ?IF_ELSE(data_mon_photo_upgrade:get(Mid, Photo#mon_photo.lv + 1) == [], true, false),
        if IsLim -> [];
            Base#base_mon_photo_upgrade.num_lim > Photo#mon_photo.num -> [];
            true -> [1]
        end
        end,
    List = lists:flatmap(F, StMonPhoto#st_mon_photo.photo_list),
    if
        List == [] -> Tips;
        true -> Tips#tips{state = 1}
    end.


refresh_photo(Player, Photo, StMonPhoto) ->
    Base = data_mon_photo_upgrade:get(Photo#mon_photo.mid, Photo#mon_photo.lv),
    State = ?IF_ELSE(Photo#mon_photo.num >= Base#base_mon_photo_upgrade.num_lim, ?MON_PHOTO_STATE_UNLOCK, ?MON_PHOTO_STATE_NORMAL),
    AttributeList = attribute_util:pack_attr(StMonPhoto#st_mon_photo.attribute),
    Data = {Photo#mon_photo.mid, Photo#mon_photo.lv, Photo#mon_photo.num, Base#base_mon_photo_upgrade.num_lim, State, StMonPhoto#st_mon_photo.cbp, AttributeList},
    {ok, Bin} = pt_201:write(20104, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

notice_msg(Player, Mid, Num) ->
    activity:get_notice(Player, [95], false),
    {ok, Bin} = pt_201:write(20105, {Mid, Num}),
    server_send:send_to_sid(Player#player.sid, Bin).
