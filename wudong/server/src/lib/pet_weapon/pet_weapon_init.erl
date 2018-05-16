%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 三月 2017 15:22
%%%-------------------------------------------------------------------
-module(pet_weapon_init).
-author("hxming").
-include("pet_weapon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([init/1, timer_update/0, logout/0, get_attribute/0, calc_attribute/1]).
-export([upgrade_lv/1, activate/1, calc_spirit_attribute/1]).
init(Player) ->
    StPetWeapon =
        case player_util:is_new_role(Player) of
            true ->
                PetWeapon = #st_pet_weapon{pkey = Player#player.key},
                lib_dict:put(?PROC_STATUS_PET_WEAPON, PetWeapon),
                PetWeapon;
            false ->
                case pet_weapon_load:load(Player#player.key) of
                    [] ->
                        PetWeapon = #st_pet_weapon{pkey = Player#player.key},
                        lib_dict:put(?PROC_STATUS_PET_WEAPON, PetWeapon),
                        PetWeapon;
                    [Stage, Exp, BlessCd, WeaponId, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit,Spirit] ->
                        SkillList = util:bitstring_to_term(SkillListBin),
                        EquipList = [{Subtype, EquipId, EquipKey} || {Subtype, EquipId, EquipKey} <- util:bitstring_to_term(EquipListBin)],
                        SpiritList = util:bitstring_to_term(SpiritListBin),
                        Now = util:unixtime(),
                        {NewCd, NewExp, IsChange} =
                            if BlessCd == 0 ->
                                {BlessCd, Exp, 0};
                                BlessCd > Now ->
                                    {BlessCd, Exp, 0};
                                true ->
                                    %% 经验清0
                                    spawn(fun() ->
                                        pet_weapon:mail_bless_reset(Player#player.key, Stage),
                                        pet_weapon:log_pet_weapon_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                          end),
                                    {0, 0, 1}
                            end,
                        PetWeapon = #st_pet_weapon{
                            pkey = Player#player.key,
                            stage = Stage,
                            exp = NewExp,
                            bless_cd = NewCd,
                            weapon_id = WeaponId,
                            skill_list = SkillList,
                            equip_list = EquipList,
                            grow_num = GrowNum,
                            spirit_list = SpiritList,
                            last_spirit = LastSpirit,
                            is_change = IsChange,
                            spirit = Spirit

                        },
                        PetWeapon1 = calc_attribute(PetWeapon),
                        lib_dict:put(?PROC_STATUS_PET_WEAPON, PetWeapon1),
                        PetWeapon1
                end
        end,
    PassiveSkillList = pet_weapon_skill:filter_skill_for_passive_battle(StPetWeapon#st_pet_weapon.skill_list) ++ Player#player.passive_skill,
    Player#player{pet_weaponid = StPetWeapon#st_pet_weapon.weapon_id, passive_skill = PassiveSkillList}.

%%定时更新
timer_update() ->
    StPetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    if StPetWeapon#st_pet_weapon.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_PET_WEAPON, StPetWeapon#st_pet_weapon{is_change = 0}),
        pet_weapon_load:replace(StPetWeapon);
        true -> ok
    end.

%%离线
logout() ->
    StPetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    if StPetWeapon#st_pet_weapon.is_change == 1 ->
        pet_weapon_load:replace(StPetWeapon);
        true -> ok
    end.

%%提升等级
upgrade_lv(Player) ->
    case Player#player.lv >= ?PET_WEAPON_OPEN_LV andalso task_in_finish() of
        false -> Player;
        true ->
            StPetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
            if StPetWeapon#st_pet_weapon.stage == 0 ->
                NewStPetWeapon = new_pet_weapon(Player#player.key),
                lib_dict:put(?PROC_STATUS_PET_WEAPON, NewStPetWeapon),
                player_util:func_open_tips(Player, 5, NewStPetWeapon#st_pet_weapon.weapon_id),
                Player;
                true ->
                    Player
            end
    end.


task_in_finish() ->
    case data_menu_open:get_task(5) of
        [] -> true;
        {0, _} -> true;
        {Tid, 3} ->
            task:in_finish(Tid);
        {Tid, 2} ->
            task:in_trigger(Tid);
        {Tid, 1} ->
            task:in_can_trigger(Tid);
        _ -> false
    end.

activate(Player) ->
    StPetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    NewStPetWeapon = calc_attribute(StPetWeapon),
    lib_dict:put(?PROC_STATUS_PET_WEAPON, NewStPetWeapon),
    NewPlayer = player_util:count_player_attribute(Player#player{pet_weaponid = NewStPetWeapon#st_pet_weapon.weapon_id}, true),
    scene_agent_dispatch:pet_weapon_update(NewPlayer),
    NewPlayer.

new_pet_weapon(Pkey) ->
    Base = data_pet_weapon_stage:get(1),
    StPetWeapon =
        #st_pet_weapon{
            pkey = Pkey,
            stage = 1,
            weapon_id = Base#base_pet_weapon_stage.weapon_id,
            is_change = 1
        },
    StPetWeapon.

%%计算属性
calc_attribute(PetWeapon) ->
    Percent = get_grow_dan(PetWeapon),
    StageAttr =
        case data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(PetWeapon#st_pet_weapon.exp, BaseData#base_pet_weapon_stage.exp, BaseData#base_pet_weapon_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_pet_weapon_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,
    SkillAttr = calc_skill_attribute(PetWeapon#st_pet_weapon.skill_list),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, PetWeapon#st_pet_weapon.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),

    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_PET_WEAPON),
    %%灵脉属性
    SpiritAttribute = calc_spirit_attribute(PetWeapon#st_pet_weapon.spirit_list),

    SumAttribute = attribute_util:sum_attribute([StageAttr, SkillAttr, EquipAttribute, DanAttr, SpiritAttribute]),
    Cbp = attribute_util:calc_combat_power(SumAttribute),
    PetWeapon#st_pet_weapon{attribute = SumAttribute, cbp = Cbp}.

%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_pet_weapon_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_pet_weapon_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case pet_weapon_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_pet_weapon_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_pet_weapon_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).

get_grow_dan(PetWeapon) ->
    case data_grow_dan:get(?GOODS_GROW_ID_PET_WEAPON) of
        [] -> 0;
        Base ->
            PetWeapon#st_pet_weapon.grow_num * Base#base_grow_dan.attr_percent
    end.

%%计算技能属性
calc_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_pet_weapon_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_pet_weapon_skill_upgrade.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%获取属性
get_attribute() ->
    StPetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    StPetWeapon#st_pet_weapon.attribute.