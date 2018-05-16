%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 一月 2017 14:06
%%%-------------------------------------------------------------------
-module(light_weapon_init).
-author("hxming").
-include("light_weapon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([init/1, timer_update/0, logout/0, get_attribute/0, calc_attribute/1]).
-export([upgrade_lv/1, activate/1, calc_spirit_attribute/1]).
init(Player) ->
    StLightWeapon =
        case player_util:is_new_role(Player) of
            true ->
                LightWeapon = #st_light_weapon{pkey = Player#player.key},
                lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, LightWeapon),
                LightWeapon;
            false ->
                case light_weapon_load:load(Player#player.key) of
                    [] ->
                        LightWeapon = #st_light_weapon{pkey = Player#player.key},
                        lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, LightWeapon),
                        LightWeapon;
                    [Stage, Exp, BlessCd, WeaponId, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit, StarListBin, Own_special_imageBin, Spirit, ActivationListBin] ->
                        SkillList = util:bitstring_to_term(SkillListBin),
                        ActivationList = ?IF_ELSE(ActivationListBin == null, [], util:bitstring_to_term(ActivationListBin)),
                        EquipList = [{Subtype, EquipId, EquipKey} || {Subtype, EquipId, EquipKey} <- util:bitstring_to_term(EquipListBin)],
                        SpiritList = util:bitstring_to_term(SpiritListBin),
                        StarList =
                            case StarListBin of
                                null -> [];
                                _ -> util:bitstring_to_term(StarListBin)
                            end,
                        Own_special_image =
                            case Own_special_imageBin of
                                null -> default_image(Stage);
                                _ ->
                                    case util:bitstring_to_term(Own_special_imageBin) of
                                        [] -> default_image(Stage);
                                        ImageList ->
                                            fix_image(ImageList, Stage)
                                    end
                            end,
                        Now = util:unixtime(),
                        {NewCd, NewExp, IsChange} =
                            if BlessCd == 0 ->
                                {BlessCd, Exp, 0};
                                BlessCd > Now ->
                                    {BlessCd, Exp, 0};
                                true ->
                                    %% 经验清0
                                    spawn(fun() ->
                                        light_weapon:mail_bless_reset(Player#player.key, Stage),
                                        light_weapon:log_light_weapon_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                    end),
                                    {0, 0, 1}
                            end,
                        LightWeapon = #st_light_weapon{
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
                            star_list = StarList,
                            activation_list = ActivationList,
                            own_special_image = Own_special_image,
                            spirit = Spirit

                        },
                        LightWeapon1 = calc_attribute(LightWeapon),
                        lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, LightWeapon1),
                        LightWeapon1
                end
        end,
    PassiveSkillList = light_weapon_skill:filter_skill_for_passive_battle(StLightWeapon#st_light_weapon.skill_list) ++ Player#player.passive_skill,
    Player#player{light_weaponid = StLightWeapon#st_light_weapon.weapon_id, passive_skill = PassiveSkillList}.

%%初始化默认图鉴
default_image(0) -> [];
default_image(Stage) ->
    F = fun(CurStage) ->
        case data_light_weapon_stage:get(CurStage) of
            [] -> [];
            Base -> [{Base#base_light_weapon_stage.weapon_id, 0}]
        end
    end,
    lists:flatmap(F, lists:seq(1, Stage)).

fix_image(ImageList, 0) -> ImageList;
fix_image(ImageList, Stage) ->
    F = fun(CurStage, L) ->
        case data_light_weapon_stage:get(CurStage) of
            [] -> L;
            Base ->
                case lists:keymember(Base#base_light_weapon_stage.weapon_id, 1, L) of
                    true -> L;
                    false ->
                        [{Base#base_light_weapon_stage.weapon_id, 0} | L]
                end
        end
    end,
    lists:foldl(F, ImageList, lists:seq(1, Stage)).

%%定时更新
timer_update() ->
    StLightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    if StLightWeapon#st_light_weapon.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, StLightWeapon#st_light_weapon{is_change = 0}),
        light_weapon_load:replace(StLightWeapon);
        true -> ok
    end.

%%离线
logout() ->
    StLightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    if StLightWeapon#st_light_weapon.is_change == 1 ->
        light_weapon_load:replace(StLightWeapon);
        true -> ok
    end.

%%提升等级
upgrade_lv(Player) ->
    case Player#player.lv >= ?LIGHT_WEAPON_OPEN_LV andalso task_in_finish() of
        false -> Player;
        true ->
            StLightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
            if StLightWeapon#st_light_weapon.stage == 0 ->
                NewStLightWeapon = new_light_weapon(Player#player.key),
                lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewStLightWeapon),
                player_util:func_open_tips(Player, 4, NewStLightWeapon#st_light_weapon.weapon_id),
                Player;
                true ->
                    Player
            end
    end.


task_in_finish() ->
    case data_menu_open:get_task(4) of
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
    StLightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    NewStLightWeapon = calc_attribute(StLightWeapon),
    lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewStLightWeapon),
    NewPlayer = player_util:count_player_attribute(Player#player{light_weaponid = NewStLightWeapon#st_light_weapon.weapon_id}, true),
    scene_agent_dispatch:light_weapon_update(NewPlayer),
    NewPlayer.

new_light_weapon(Pkey) ->
    Base = data_light_weapon_stage:get(1),
    StLightWeapon =
        #st_light_weapon{
            pkey = Pkey,
            stage = 1,
            weapon_id = Base#base_light_weapon_stage.weapon_id,
            own_special_image = [{Base#base_light_weapon_stage.weapon_id, 0}],
            is_change = 1
        },
    StLightWeapon.

%%计算属性
calc_attribute(LightWeapon) ->
    Percent = get_grow_dan(LightWeapon),
    StageAttr =
        case data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(LightWeapon#st_light_weapon.exp, BaseData#base_light_weapon_stage.exp, BaseData#base_light_weapon_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_light_weapon_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,
    SkillAttr = calc_skill_attribute(LightWeapon#st_light_weapon.skill_list),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, LightWeapon#st_light_weapon.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),

    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_LIGHT_WEAPON),
    %%灵脉属性

    SpiritAttribute = calc_spirit_attribute(LightWeapon#st_light_weapon.spirit_list),

    StarAttrList =
        lists:flatmap(
            fun({WeaponId, Star}) ->
                case data_light_weapon_star:get(WeaponId, Star) of
                    [] -> [];
                    StarBase -> StarBase#base_light_weapon_star.attr_list
                end
            end, LightWeapon#st_light_weapon.star_list),
    StarAttr = attribute_util:make_attribute_by_key_val_list(StarAttrList),

    F = fun({LightWeapon0, ActList}) ->
        F0 = fun(Lv) ->
            case data_light_weapon_star:get(LightWeapon0, Lv) of
                [] -> [];
                #base_light_weapon_star{lv_attr = LvAttr} ->
                    LvAttr
            end
        end,
        lists:flatmap(F0, ActList)
    end,
    Attr3 = attribute_util:make_attribute_by_key_val_list(lists:flatmap(F, LightWeapon#st_light_weapon.activation_list)),

    SumAttribute = attribute_util:sum_attribute([StageAttr, SkillAttr, EquipAttribute, DanAttr, SpiritAttribute, StarAttr, Attr3]),
    Cbp = attribute_util:calc_combat_power(SumAttribute),
    LightWeapon#st_light_weapon{attribute = SumAttribute, cbp = Cbp}.


%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_light_weapon_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_light_weapon_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case light_weapon_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_light_weapon_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_light_weapon_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).


get_grow_dan(LightWeapon) ->
    case data_grow_dan:get(?GOODS_GROW_ID_LIGHT_WEAPON) of
        [] -> 0;
        Base ->
            LightWeapon#st_light_weapon.grow_num * Base#base_grow_dan.attr_percent
    end.

%%计算技能属性
calc_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_light_weapon_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_light_weapon_skill_upgrade.attrs
        end
    end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%获取属性
get_attribute() ->
    StLightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    StLightWeapon#st_light_weapon.attribute.