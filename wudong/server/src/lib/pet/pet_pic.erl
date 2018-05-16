%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 15:13
%%%-------------------------------------------------------------------
-module(pet_pic).
-author("hxming").
-include("pet.hrl").
-include("common.hrl").

%% API
-export([
    pic_list/0,
    activate_pic/4,
    activate_pic_all/2,
    upgrade_pic/2,
    is_active/1,
    use_pic/2
]).

-export([check_pic_state/0, init_fix_pic/1]).


init_fix_pic(StPet) ->
    F = fun(Pet, L) ->
        case data_pet:get(Pet#pet.type_id) of
            [] -> L;
            BasePet ->
                F1 = fun({FigureId, Stage}) ->
                    case check_pic(FigureId, Stage, StPet#st_pet.stage, L) of
                        false -> [];
                        true ->
                            [{FigureId, 0}]
                    end
                     end,
                case lists:flatmap(F1, tuple_to_list(BasePet#base_pet.figure)) of
                    [] ->
                        L;
                    L1 ->
                        L1 ++ L
                end
        end
        end,
    PicList = lists:foldl(F, StPet#st_pet.pic_list, StPet#st_pet.pet_list),
    F1 = fun({Id, _State}, L) ->
        case lists:keymember(Id, 1, L) of
            true -> L;
            false ->
                [{Id, _State} | L]
        end
         end,
    NewPicList = lists:foldl(F1, [], PicList),

    StPet#st_pet{pic_list = NewPicList}.

%%经常图鉴是否可激活
check_pic_state() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case StPet#st_pet.pet_list == [] of
        true ->
            0;
        false ->
            F = fun({_, State}) -> State == 0 end,
            case lists:any(F, StPet#st_pet.pic_list) of
                true -> 1;
                false -> 0
            end
    end.

%%图鉴列表
pic_list() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    PicInfo = [tuple_to_list(Item) || Item <- StPet#st_pet.pic_list],
    PicNormalAcc = pet_attr:calc_pet_acc(StPet#st_pet.pic_list, 1),
    CbpNormal = attribute_util:calc_combat_power(StPet#st_pet.pic_normal_attribute),
    PicNormalAttributeList = attribute_util:pack_attr(StPet#st_pet.pic_normal_attribute),
    PicSpecialAcc = pet_attr:calc_pet_acc(StPet#st_pet.pic_list, 2),
    CbpSpecial = attribute_util:calc_combat_power(StPet#st_pet.pic_special_attribute),
    PicSpecialAttributeList = attribute_util:pack_attr(StPet#st_pet.pic_special_attribute),
    {PicInfo, PicNormalAcc, CbpNormal, PicNormalAttributeList, PicSpecialAcc, CbpSpecial, PicSpecialAttributeList}.

%%升级图鉴
upgrade_pic(Player, FigureId) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case lists:keytake(FigureId, 1, StPet#st_pet.pic_list) of
        false -> {24, Player};
        {value, {_, State}, L} ->
            if State /= 0 -> {25, Player};
                true ->
                    PicList = [{FigureId, 1} | L],
                    PicAttribute = pet_attr:calc_pet_pic_attribute(PicList),
                    PicNormalAttribute = pet_attr:calc_pet_acc_normal_attribute(PicList),
                    PicSpecialAttribute = pet_attr:calc_pet_acc_special_attribute(PicList),
                    StPet1 = StPet#st_pet{pic_list = PicList, pic_attribute = PicAttribute, pic_normal_attribute = PicNormalAttribute, pic_special_attribute = PicSpecialAttribute, is_change = 1},
                    StPet2 = pet_attr:calc_attribute(StPet1),
                    lib_dict:put(?PROC_STATUS_PET, StPet2),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    pet_log:log_pet_pic(Player#player.key, Player#player.nickname, FigureId, 1),
                    activity:get_notice(Player, [110], true),
                    {1, NewPlayer}
            end
    end.

%%幻化
use_pic(Player, FigureId) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case lists:keyfind(FigureId, 1, StPet#st_pet.pic_list) of
        false -> {24, Player};
        {_, State} ->
            if State == 0 -> {24, Player};
                Player#player.pet#fpet.type_id == 0 -> {26, Player};
                true ->
                    Fpet = Player#player.pet,
                    PetName =
                        case pet_util:pet_name(FigureId) of
                            false -> Fpet#fpet.name;
                            Name -> Name
                        end,
                    NewFpet = Fpet#fpet{figure = FigureId, name = PetName},
                    StPet1 = StPet#st_pet{figure = FigureId, is_change = 1},
                    lib_dict:put(?PROC_STATUS_PET, StPet1),
                    pet_log:log_pet_figure(Player#player.key, Player#player.nickname, StPet#st_pet.figure, FigureId),
                    {1, Player#player{pet = NewFpet}}
            end
    end.


%% 是否激活了
is_active(FigureId) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case lists:keyfind(FigureId, 1, StPet#st_pet.pic_list) of
        false -> {false,0};
        {_,Lv}  -> {true,Lv}
    end.

%%激活图鉴
activate_pic(Player, StPet, FigureList, PetState) ->
    F = fun({FigureId, Stage}, {IsUpdate, L}) ->
        case check_pic(FigureId, Stage, StPet#st_pet.stage, L) of
            false -> {IsUpdate, L};
            true ->
                {ok, Bin} = pt_501:write(50114, {FigureId}),
                server_send:send_to_sid(Player#player.sid, Bin),
                State = ?IF_ELSE(PetState == ?PET_STATE_FIGHT, 1, 0),
                {true, [{FigureId, State} | L]}
        end
        end,
    {Update, PicList} = lists:foldl(F, {false, StPet#st_pet.pic_list}, FigureList),
    if Update ->
        PicAttribute = pet_attr:calc_pet_pic_attribute(PicList),
        PicNormalAttribute = pet_attr:calc_pet_acc_normal_attribute(PicList),
        PicSpecialAttribute = pet_attr:calc_pet_acc_special_attribute(PicList),
        activity:get_notice(Player, [110], true),
        StPet#st_pet{pic_list = PicList, pic_attribute = PicAttribute, pic_normal_attribute = PicNormalAttribute, pic_special_attribute = PicSpecialAttribute};
        true ->
            activity:get_notice(Player, [110], true),
            StPet
    end.

check_pic(FigureId, Stage, CurStage, PicList) ->
    if CurStage < Stage -> false;
        true ->
            case data_pet_pic:get(FigureId) of
                [] ->
                    false;
                _ ->
                    case lists:keymember(FigureId, 1, PicList) of
                        true ->
                            false;
                        false ->
                            true
                    end
            end
    end.

%%升阶激活图鉴
activate_pic_all(Player, StPet) ->
    F = fun(Pet, {IsUpdate, L}) ->
        case data_pet:get(Pet#pet.type_id) of
            [] -> {IsUpdate, L};
            BasePet ->
                F1 = fun({FigureId, Stage}) ->
                    case check_pic(FigureId, Stage, StPet#st_pet.stage, L) of
                        false -> [];
                        true ->
                            {ok, Bin} = pt_501:write(50114, {FigureId}),
                            server_send:send_to_sid(Player#player.sid, Bin),
                            [{FigureId, 0}]
                    end
                     end,
                case lists:flatmap(F1, tuple_to_list(BasePet#base_pet.figure)) of
                    [] ->
                        {IsUpdate, L};
                    L1 ->
                        {true, L1 ++ L}
                end
        end

        end,
    {Update, PicList} = lists:foldl(F, {false, StPet#st_pet.pic_list}, StPet#st_pet.pet_list),
    if Update ->
        activity:get_notice(Player, [110], true),
        StPet#st_pet{pic_list = PicList};
        true ->
            activity:get_notice(Player, [110], true),
            StPet
    end.

