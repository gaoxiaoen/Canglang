%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 七月 2017 17:07
%%%-------------------------------------------------------------------
-module(god_treasure_init).

-author("hxming").

-include("god_treasure.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([init/1, timer_update/0, logout/0, get_attribute/0, calc_attribute/1]).
-export([upgrade_lv/1, activate/1, calc_spirit_attribute/1]).
init(Player) ->
    StGodTreasure =
        case player_util:is_new_role(Player) of
            true ->
                GodTreasure = #st_god_treasure{pkey = Player#player.key},
                lib_dict:put(?PROC_STATUS_GOD_TREASURE, GodTreasure),
                GodTreasure;
            false ->
                case god_treasure_load:load(Player#player.key) of
                    [] ->
                        GodTreasure = #st_god_treasure{pkey = Player#player.key},
                        lib_dict:put(?PROC_STATUS_GOD_TREASURE, GodTreasure),
                        GodTreasure;
                    [Stage, Exp, BlessCd, GodTreasureId, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit, Spirit] ->
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
                                        god_treasure:mail_bless_reset(Player#player.key, Stage),
                                        god_treasure:log_god_treasure_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                    end),
                                    {0, 0, 1}
                            end,
                        GodTreasure = #st_god_treasure{
                            pkey = Player#player.key,
                            stage = Stage,
                            exp = NewExp,
                            bless_cd = NewCd,
                            god_treasure_id = GodTreasureId,
                            skill_list = SkillList,
                            equip_list = EquipList,
                            grow_num = GrowNum,
                            spirit_list = SpiritList,
                            last_spirit = LastSpirit,
                            is_change = IsChange,
                            spirit = Spirit

                        },
                        GodTreasure1 = calc_attribute(GodTreasure),
                        lib_dict:put(?PROC_STATUS_GOD_TREASURE, GodTreasure1),
                        GodTreasure1
                end
        end,
    upgrade_lv(Player),
    StGodTreasure1 = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    NewStGodTreasure = calc_attribute(StGodTreasure1),
    lib_dict:put(?PROC_STATUS_GOD_TREASURE, NewStGodTreasure),
    PassiveSkillList = god_treasure_skill:filter_skill_for_passive_battle(StGodTreasure1#st_god_treasure.skill_list) ++ Player#player.passive_skill,
    Player#player{god_treasure_id = StGodTreasure1#st_god_treasure.god_treasure_id, passive_skill = PassiveSkillList}.

%%定时更新
timer_update() ->
    StGodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    if StGodTreasure#st_god_treasure.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_GOD_TREASURE, StGodTreasure#st_god_treasure{is_change = 0}),
        god_treasure_load:replace(StGodTreasure);
        true -> ok
    end.

%%离线
logout() ->
    StGodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    if StGodTreasure#st_god_treasure.is_change =:= 1 ->
        god_treasure_load:replace(StGodTreasure);
        true -> ok
    end.

%%提升等级
upgrade_lv(Player) ->
    case Player#player.lv >= ?GOD_TREASURE_OPEN_LV of
        false -> Player;
        true ->
            StGodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
            if StGodTreasure#st_god_treasure.stage == 0 ->
                NewStGodTreasure = new_god_treasure(Player#player.key),
                lib_dict:put(?PROC_STATUS_GOD_TREASURE, NewStGodTreasure),
                player_util:func_open_tips(Player, 13, NewStGodTreasure#st_god_treasure.god_treasure_id),
                Player;
                true ->
                    Player
            end
    end.


%% task_in_finish() ->
%%     case data_menu_open:get_task(48) of
%%         [] -> true;
%%         {0, _} -> true;
%%         {Tid, 3} ->
%%             task:in_finish(Tid);
%%         {Tid, 2} ->
%%             task:in_trigger(Tid);
%%         {Tid, 1} ->
%%             task:in_can_trigger(Tid);
%%         _ -> false
%%     end.

activate(Player) ->
    StGodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    NewStGodTreasure = calc_attribute(StGodTreasure),
    lib_dict:put(?PROC_STATUS_GOD_TREASURE, NewStGodTreasure),
    NewPlayer = player_util:count_player_attribute(Player#player{god_treasure_id = NewStGodTreasure#st_god_treasure.god_treasure_id}, true),
    scene_agent_dispatch:god_treasure_update(NewPlayer),
    NewPlayer.

new_god_treasure(Pkey) ->
    Base = data_god_treasure_stage:get(1),
    StGodTreasure =
        #st_god_treasure{
            pkey = Pkey,
            stage = 1,
            god_treasure_id = Base#base_god_treasure_stage.god_treasure_id,
            is_change = 1
        },
    StGodTreasure.

%%计算属性
calc_attribute(GodTreasure) ->
    Percent = get_grow_dan(GodTreasure),
    StageAttr =
        case data_god_treasure_stage:get(GodTreasure#st_god_treasure.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(GodTreasure#st_god_treasure.exp, BaseData#base_god_treasure_stage.exp, BaseData#base_god_treasure_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_god_treasure_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,
    SkillAttr = calc_skill_attribute(GodTreasure#st_god_treasure.skill_list),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, GodTreasure#st_god_treasure.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),

    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_GOD_TREASURE),
    %%灵脉属性
    SpiritAttribute = calc_spirit_attribute(GodTreasure#st_god_treasure.spirit_list),

    SumAttribute = attribute_util:sum_attribute([StageAttr, SkillAttr, EquipAttribute, DanAttr, SpiritAttribute]),
    Cbp = attribute_util:calc_combat_power(SumAttribute),
    GodTreasure#st_god_treasure{attribute = SumAttribute, cbp = Cbp}.

%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_god_treasure_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_god_treasure_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case god_treasure_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_god_treasure_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_god_treasure_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).

get_grow_dan(GodTreasure) ->
    case data_grow_dan:get(?GOODS_GROW_ID_GOD_TREASURE) of
        [] -> 0;
        Base ->
            GodTreasure#st_god_treasure.grow_num * Base#base_grow_dan.attr_percent
    end.

%%计算技能属性
calc_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_god_treasure_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_god_treasure_skill_upgrade.attrs
        end
    end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%获取属性
get_attribute() ->
    StGodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    StGodTreasure#st_god_treasure.attribute.