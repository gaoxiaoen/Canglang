%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:15
%%%-------------------------------------------------------------------
-module(footprint_init).

-author("hxming").
-include("footprint_new.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([init/1, timer_update/0, logout/0, get_attribute/0, calc_attribute/1]).
-export([upgrade_lv/1, activate/1, calc_spirit_attribute/1]).
init(Player) ->
    StFootprint =

        case player_util:is_new_role(Player) of
            true ->
                Footprint = #st_footprint{pkey = Player#player.key},
                lib_dict:put(?PROC_STATUS_FOOTPRINT, Footprint),
                Footprint;
            false ->
                case footprint_load:load(Player#player.key) of
                    [] ->
                        Footprint = #st_footprint{pkey = Player#player.key},
                        lib_dict:put(?PROC_STATUS_FOOTPRINT, Footprint),
                        Footprint;
                    [Stage, Exp, BlessCd, FootprintId, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit,Spirit] ->
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
                                    spawn(fun() -> footprint:mail_bless_reset(Player#player.key, Stage),
                                        footprint:log_footprint_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                          end),
                                    {0, 0, 1}
                            end,
                        Footprint = #st_footprint{
                            pkey = Player#player.key,
                            stage = Stage,
                            exp = NewExp,
                            bless_cd = NewCd,
                            footprint_id = FootprintId,
                            skill_list = SkillList,
                            equip_list = EquipList,
                            grow_num = GrowNum,
                            spirit_list = SpiritList,
                            last_spirit = LastSpirit,
                            is_change = IsChange,
                            spirit = Spirit

                        },
                        Footprint1 = calc_attribute(Footprint),
                        lib_dict:put(?PROC_STATUS_FOOTPRINT, Footprint1),
                        Footprint1
                end
        end,
    PassiveSkillList = footprint_skill:filter_skill_for_passive_battle(StFootprint#st_footprint.skill_list) ++ Player#player.passive_skill,
    Player#player{footprint_id = StFootprint#st_footprint.footprint_id, passive_skill = PassiveSkillList}.

%%定时更新
timer_update() ->
    StFootprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    if StFootprint#st_footprint.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_FOOTPRINT, StFootprint#st_footprint{is_change = 0}),
        footprint_load:replace(StFootprint);
        true -> ok
    end.

%%离线
logout() ->
    StFootprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    if StFootprint#st_footprint.is_change == 1 ->
        footprint_load:replace(StFootprint);
        true -> ok
    end.

%%提升等级
upgrade_lv(Player) ->
    case Player#player.lv >= ?FOOTPRINT_OPEN_LV andalso task_in_finish() of
        false -> Player;
        true ->
            StFootprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
            if StFootprint#st_footprint.stage == 0 ->
                NewStFootprint = new_footprint(Player#player.key),
                lib_dict:put(?PROC_STATUS_FOOTPRINT, NewStFootprint),
                player_util:func_open_tips(Player, 6, NewStFootprint#st_footprint.footprint_id),
                Player;
                true ->
                    Player
            end
    end.


task_in_finish() ->
    case data_menu_open:get_task(40) of
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
    StFootprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    NewStFootprint = calc_attribute(StFootprint),
    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewStFootprint),
    NewPlayer = player_util:count_player_attribute(Player#player{footprint_id = NewStFootprint#st_footprint.footprint_id}, true),
    scene_agent_dispatch:footprint_update(NewPlayer),
    NewPlayer.

new_footprint(Pkey) ->
    Base = data_footprint_stage:get(1),
    StFootprint =
        #st_footprint{
            pkey = Pkey,
            stage = 1,
            footprint_id = Base#base_footprint_stage.footprint_id,
            is_change = 1
        },
    StFootprint.

%%计算属性
calc_attribute(Footprint) ->
    Percent = get_grow_dan(Footprint),
    StageAttr =
        case data_footprint_stage:get(Footprint#st_footprint.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(Footprint#st_footprint.exp, BaseData#base_footprint_stage.exp, BaseData#base_footprint_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_footprint_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,
    SkillAttr = calc_skill_attribute(Footprint#st_footprint.skill_list),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, Footprint#st_footprint.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),

    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_FOOTPRINT),
    %%灵脉属性
    SpiritAttribute = calc_spirit_attribute(Footprint#st_footprint.spirit_list),

    SumAttribute = attribute_util:sum_attribute([StageAttr, SkillAttr, EquipAttribute, DanAttr, SpiritAttribute]),
    Cbp = attribute_util:calc_combat_power(SumAttribute),
    Footprint#st_footprint{attribute = SumAttribute, cbp = Cbp}.


%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_footprint_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_footprint_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case footprint_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_footprint_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_footprint_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).

get_grow_dan(Footprint) ->
    case data_grow_dan:get(?GOODS_GROW_ID_FOOTPRINT) of
        [] -> 0;
        Base ->
            Footprint#st_footprint.grow_num * Base#base_grow_dan.attr_percent
    end.

%%计算技能属性
calc_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_footprint_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_footprint_skill_upgrade.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%获取属性
get_attribute() ->
    StFootprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    StFootprint#st_footprint.attribute.