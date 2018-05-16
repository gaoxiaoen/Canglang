%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 一月 2017 14:06
%%%-------------------------------------------------------------------
-module(magic_weapon_init).
-author("hxming").
-include("magic_weapon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("skill.hrl").
%% API
-export([init/1, timer_update/0, logout/0, get_attribute/0, calc_attribute/1]).
-export([upgrade_lv/1, activate/1, calc_spirit_attribute/1]).

init(Player) ->
    StMagicWeapon =
        case player_util:is_new_role(Player) of
            true ->
                MagicWeapon = #st_magic_weapon{pkey = Player#player.key},
                lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, MagicWeapon),
                MagicWeapon;
            false ->
                case magic_weapon_load:load(Player#player.key) of
                    [] ->
                        MagicWeapon = #st_magic_weapon{pkey = Player#player.key},
                        lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, MagicWeapon),
                        MagicWeapon;
                    [Stage, Exp, BlessCd, WeaponId, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit,Spirit] ->
                        SkillList = util:bitstring_to_term(SkillListBin),
                        EquipList = util:bitstring_to_term(EquipListBin),
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
                                        magic_weapon:mail_bless_reset(Player#player.key, Stage),
                                        magic_weapon:log_magic_weapon_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                          end),
                                    {0, 0, 1}
                            end,
                        MagicWeapon = #st_magic_weapon{
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
                            spirit = Spirit,
                            is_change = IsChange
                        },
                        MagicWeapon1 = calc_attribute(MagicWeapon),
                        lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, MagicWeapon1),
                        MagicWeapon1
                end
        end,
    PassiveSkillList = magic_weapon_skill:filter_skill_for_passive_battle(StMagicWeapon#st_magic_weapon.skill_list) ++ Player#player.passive_skill,
    MWSkill = magic_weapon_skill:filter_skill_for_battle(StMagicWeapon#st_magic_weapon.skill_list),
    Player#player{magic_weapon_id = StMagicWeapon#st_magic_weapon.weapon_id, passive_skill = PassiveSkillList, magic_weapon_skill = MWSkill}.

%%定时更新
timer_update() ->
    StMagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    if StMagicWeapon#st_magic_weapon.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, StMagicWeapon#st_magic_weapon{is_change = 0}),
        magic_weapon_load:replace(StMagicWeapon);
        true -> ok
    end.

%%离线
logout() ->
    StMagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    if StMagicWeapon#st_magic_weapon.is_change == 1 ->
        magic_weapon_load:replace(StMagicWeapon);
        true -> ok
    end.

upgrade_lv(Player) ->
    case Player#player.lv >= ?MAGIC_WEAPON_OPEN_LV andalso task_in_finish() of
        false -> Player;
        true ->
            StMagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
            if StMagicWeapon#st_magic_weapon.stage == 0 ->
                NewStMagicWeapon = new_magic_weapon(Player#player.key),
                lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewStMagicWeapon),
                player_util:func_open_tips(Player, 3, NewStMagicWeapon#st_magic_weapon.weapon_id),
                Player;
                true ->
                    Player
            end
    end.

task_in_finish() ->
    case data_menu_open:get_task(3) of
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
    StMagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    NewStMagicWeapon = calc_attribute(StMagicWeapon),
    lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewStMagicWeapon),
    InitiativeSkillList = magic_weapon_skill:filter_skill_for_battle(NewStMagicWeapon#st_magic_weapon.skill_list),

    PassiveSkillList = [{Sid, Type} || {Sid, Type} <- Player#player.passive_skill, Type /= ?PASSIVE_SKILL_TYPE_MAGIC_WEAPON] ++ magic_weapon_skill:filter_skill_for_passive_battle(NewStMagicWeapon#st_magic_weapon.skill_list),

    Player1 = Player#player{magic_weapon_id = NewStMagicWeapon#st_magic_weapon.weapon_id, passive_skill = PassiveSkillList, magic_weapon_skill = InitiativeSkillList},
    NewPlayer = player_util:count_player_attribute(Player1, true),
    scene_agent_dispatch:passive_skill(NewPlayer, PassiveSkillList),
    scene_agent_dispatch:magic_weapon_skill(NewPlayer, InitiativeSkillList),
    scene_agent_dispatch:magic_weapon_id(NewPlayer),
    NewPlayer.

new_magic_weapon(Pkey) ->
    Base = data_magic_weapon_stage:get(1),
    SKill = data_magic_weapon_skill_activate:get(1),
    StMagicWeapon =
        #st_magic_weapon{
            pkey = Pkey,
            stage = 1,
            weapon_id = Base#base_magic_weapon_stage.weapon_id,
            skill_list = [{1, SKill#base_magic_weapon_skill_activate.skill_id}],
            is_change = 1
        },
    StMagicWeapon.

calc_attribute(MagicWeapon) ->
    Percent = get_grow_dan(MagicWeapon),
    StageAttr =
        case data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(MagicWeapon#st_magic_weapon.exp, BaseData#base_magic_weapon_stage.exp, BaseData#base_magic_weapon_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_magic_weapon_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,
    SkillAttr = calc_skill_attribute(MagicWeapon#st_magic_weapon.skill_list),

    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_MAGIC_WEAPON),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, MagicWeapon#st_magic_weapon.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),

    %%灵脉属性
    SpiritAttribute = calc_spirit_attribute(MagicWeapon#st_magic_weapon.spirit_list),

    SumAttribute = attribute_util:sum_attribute([StageAttr, SkillAttr, EquipAttribute, DanAttr, SpiritAttribute]),
    Cbp = attribute_util:calc_combat_power(SumAttribute),
    MagicWeapon#st_magic_weapon{attribute = SumAttribute, cbp = Cbp}.


%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_magic_weapon_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_magic_weapon_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case magic_weapon_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_magic_weapon_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_magic_weapon_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).

get_grow_dan(MagicWeapon) ->
    case data_grow_dan:get(?GOODS_GROW_ID_MAGIC_WEAPON) of
        [] -> 0;
        Base ->
            MagicWeapon#st_magic_weapon.grow_num * Base#base_grow_dan.attr_percent
    end.


calc_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_mount_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_magic_weapon_skill_upgrade.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).


get_attribute() ->
    StMagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    StMagicWeapon#st_magic_weapon.attribute.