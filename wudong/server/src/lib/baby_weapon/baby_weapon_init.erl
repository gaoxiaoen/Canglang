%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2017 14:59
%%%-------------------------------------------------------------------
-module(baby_weapon_init).
-author("hxming").

-include("baby_weapon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([init/1, timer_update/0, logout/0, get_attribute/0, calc_attribute/1]).
-export([upgrade_lv/1, activate/1, calc_spirit_attribute/1]).
init(Player) ->
    StBabyWeapon =

        case player_util:is_new_role(Player) of
            true ->
                BabyWeapon = #st_baby_weapon{pkey = Player#player.key},
                lib_dict:put(?PROC_STATUS_BABY_WEAPON, BabyWeapon),
                BabyWeapon;
            false ->
                case baby_weapon_load:load(Player#player.key) of
                    [] ->
                        BabyWeapon = #st_baby_weapon{pkey = Player#player.key},
                        lib_dict:put(?PROC_STATUS_BABY_WEAPON, BabyWeapon),
                        BabyWeapon;
                    [Stage, Exp, BlessCd, BabyWeaponId, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit,Spirit] ->
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
                                        baby_weapon:mail_bless_reset(Player#player.key, Stage),
                                        baby_weapon:log_baby_weapon_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                          end),
                                    {0, 0, 1}
                            end,
                        BabyWeapon = #st_baby_weapon{
                            pkey = Player#player.key,
                            stage = Stage,
                            exp = NewExp,
                            bless_cd = NewCd,
                            baby_weapon_id = BabyWeaponId,
                            skill_list = SkillList,
                            equip_list = EquipList,
                            grow_num = GrowNum,
                            spirit_list = SpiritList,
                            last_spirit = LastSpirit,
                            is_change = IsChange,
                            spirit = Spirit

                        },
                        BabyWeapon1 = calc_attribute(BabyWeapon),
                        lib_dict:put(?PROC_STATUS_BABY_WEAPON, BabyWeapon1),
                        BabyWeapon1
                end
        end,
    PassiveSkillList = baby_weapon_skill:filter_skill_for_passive_battle(StBabyWeapon#st_baby_weapon.skill_list) ++ Player#player.passive_skill,
    Player#player{baby_weapon_id = StBabyWeapon#st_baby_weapon.baby_weapon_id, passive_skill = PassiveSkillList}.

%%定时更新
timer_update() ->
    StBabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
    if StBabyWeapon#st_baby_weapon.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_BABY_WEAPON, StBabyWeapon#st_baby_weapon{is_change = 0}),
        baby_weapon_load:replace(StBabyWeapon);
        true -> ok
    end.

%%离线
logout() ->
    StBabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
    if StBabyWeapon#st_baby_weapon.is_change =:= 1 ->
        baby_weapon_load:replace(StBabyWeapon);
        true -> ok
    end.

%%提升等级
upgrade_lv(Player) ->
    case Player#player.lv >= ?BABY_WEAPON_OPEN_LV andalso task_in_finish() andalso Player#player.baby#fbaby.type_id /= 0 of
        false -> Player;
        true ->
            StBabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
            if StBabyWeapon#st_baby_weapon.stage == 0 ->
                NewStBabyWeapon = new_baby_weapon(Player#player.key),
                lib_dict:put(?PROC_STATUS_BABY_WEAPON, NewStBabyWeapon),
                player_util:func_open_tips(Player, 11, NewStBabyWeapon#st_baby_weapon.baby_weapon_id),
                Player;
                true ->
                    Player
            end
    end.


task_in_finish() ->
    case data_menu_open:get_task(0) of
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
    StBabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
    NewStBabyWeapon = calc_attribute(StBabyWeapon),
    lib_dict:put(?PROC_STATUS_BABY_WEAPON, NewStBabyWeapon),
    NewPlayer = player_util:count_player_attribute(Player#player{baby_weapon_id = NewStBabyWeapon#st_baby_weapon.baby_weapon_id}, true),
    scene_agent_dispatch:baby_weapon_update(NewPlayer),
    NewPlayer.

new_baby_weapon(Pkey) ->
    Base = data_baby_weapon_stage:get(1),
    StBabyWeapon =
        #st_baby_weapon{
            pkey = Pkey,
            stage = 1,
            baby_weapon_id = Base#base_baby_weapon_stage.baby_weapon_id,
            is_change = 1
        },
    StBabyWeapon.

%%计算属性
calc_attribute(BabyWeapon) ->
    Percent = get_grow_dan(BabyWeapon),
    StageAttr =
        case data_baby_weapon_stage:get(BabyWeapon#st_baby_weapon.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(BabyWeapon#st_baby_weapon.exp, BaseData#base_baby_weapon_stage.exp, BaseData#base_baby_weapon_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_baby_weapon_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,
    SkillAttr = calc_skill_attribute(BabyWeapon#st_baby_weapon.skill_list),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, BabyWeapon#st_baby_weapon.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),

    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_BABY_WEAPON),
    %%灵脉属性
    SpiritAttribute = calc_spirit_attribute(BabyWeapon#st_baby_weapon.spirit_list),

    SumAttribute = attribute_util:sum_attribute([StageAttr, SkillAttr, EquipAttribute, DanAttr, SpiritAttribute]),
    Cbp = attribute_util:calc_combat_power(SumAttribute),
    BabyWeapon#st_baby_weapon{attribute = SumAttribute, cbp = Cbp}.

%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_baby_weapon_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_baby_weapon_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case baby_weapon_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_baby_weapon_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_baby_weapon_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).

get_grow_dan(BabyWeapon) ->
    case data_grow_dan:get(?GOODS_GROW_ID_BABY_WEAPON) of
        [] -> 0;
        Base ->
            BabyWeapon#st_baby_weapon.grow_num * Base#base_grow_dan.attr_percent
    end.

%%计算技能属性
calc_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_baby_weapon_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_baby_weapon_skill_upgrade.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%获取属性
get_attribute() ->
    StBabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
    StBabyWeapon#st_baby_weapon.attribute.