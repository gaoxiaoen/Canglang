%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 六月 2017 17:06
%%%-------------------------------------------------------------------
-module(cat_init).
-author("hxming").

-include("cat.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([init/1, timer_update/0, logout/0, get_attribute/0, calc_attribute/1]).
-export([upgrade_lv/1, activate/1, calc_spirit_attribute/1]).
init(Player) ->
    StCat =
        case player_util:is_new_role(Player) of
            true ->
                Cat = #st_cat{pkey = Player#player.key},
                lib_dict:put(?PROC_STATUS_CAT, Cat),
                Cat;
            false ->
                case cat_load:load(Player#player.key) of
                    [] ->
                        Cat = #st_cat{pkey = Player#player.key},
                        lib_dict:put(?PROC_STATUS_CAT, Cat),
                        Cat;
                    [Stage, Exp, BlessCd, CatId, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit,Spirit] ->
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
                                        cat:mail_bless_reset(Player#player.key, Stage),
                                        cat:log_cat_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                          end),
                                    {0, 0, 1}
                            end,
                        Cat = #st_cat{
                            pkey = Player#player.key,
                            stage = Stage,
                            exp = NewExp,
                            bless_cd = NewCd,
                            cat_id = CatId,
                            skill_list = SkillList,
                            equip_list = EquipList,
                            grow_num = GrowNum,
                            spirit_list = SpiritList,
                            last_spirit = LastSpirit,
                            is_change = IsChange,
                            spirit = Spirit

                        },
                        Cat1 = calc_attribute(Cat),
                        lib_dict:put(?PROC_STATUS_CAT, Cat1),
                        Cat1
                end
        end,
    PassiveSkillList = cat_skill:filter_skill_for_passive_battle(StCat#st_cat.skill_list) ++ Player#player.passive_skill,
    Player#player{cat_id = StCat#st_cat.cat_id, passive_skill = PassiveSkillList}.

%%定时更新
timer_update() ->
    StCat = lib_dict:get(?PROC_STATUS_CAT),
    if StCat#st_cat.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_CAT, StCat#st_cat{is_change = 0}),
        cat_load:replace(StCat);
        true -> ok
    end.

%%离线
logout() ->
    StCat = lib_dict:get(?PROC_STATUS_CAT),
    if StCat#st_cat.is_change =:= 1 ->
        cat_load:replace(StCat);
        true -> ok
    end.

%%提升等级
upgrade_lv(Player) ->
    case Player#player.lv >= ?CAT_OPEN_LV andalso task_in_finish() of
        false -> Player;
        true ->
            StCat = lib_dict:get(?PROC_STATUS_CAT),
            if StCat#st_cat.stage == 0 ->
                NewStCat = new_cat(Player#player.key),
                lib_dict:put(?PROC_STATUS_CAT, NewStCat),
                player_util:func_open_tips(Player, 7, NewStCat#st_cat.cat_id),
                Player;
                true ->
                    Player
            end
    end.


task_in_finish() ->
    case data_menu_open:get_task(46) of
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
    StCat = lib_dict:get(?PROC_STATUS_CAT),
    NewStCat = calc_attribute(StCat),
    lib_dict:put(?PROC_STATUS_CAT, NewStCat),
    NewPlayer = player_util:count_player_attribute(Player#player{cat_id = NewStCat#st_cat.cat_id}, true),
    scene_agent_dispatch:cat_update(NewPlayer),
    NewPlayer.

new_cat(Pkey) ->
    Base = data_cat_stage:get(1),
    StCat =
        #st_cat{
            pkey = Pkey,
            stage = 1,
            cat_id = Base#base_cat_stage.cat_id,
            is_change = 1
        },
    StCat.

%%计算属性
calc_attribute(Cat) ->
    Percent = get_grow_dan(Cat),
    StageAttr =
        case data_cat_stage:get(Cat#st_cat.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(Cat#st_cat.exp, BaseData#base_cat_stage.exp, BaseData#base_cat_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_cat_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,
    SkillAttr = calc_skill_attribute(Cat#st_cat.skill_list),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, Cat#st_cat.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),

    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_CAT),
    %%灵脉属性
    SpiritAttribute = calc_spirit_attribute(Cat#st_cat.spirit_list),

    SumAttribute = attribute_util:sum_attribute([StageAttr, SkillAttr, EquipAttribute, DanAttr, SpiritAttribute]),
    Cbp = attribute_util:calc_combat_power(SumAttribute),
    Cat#st_cat{attribute = SumAttribute, cbp = Cbp}.

%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_cat_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_cat_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case cat_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_cat_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_cat_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).

get_grow_dan(Cat) ->
    case data_grow_dan:get(?GOODS_GROW_ID_CAT) of
        [] -> 0;
        Base ->
            Cat#st_cat.grow_num * Base#base_grow_dan.attr_percent
    end.

%%计算技能属性
calc_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_cat_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_cat_skill_upgrade.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%获取属性
get_attribute() ->
    StCat = lib_dict:get(?PROC_STATUS_CAT),
    StCat#st_cat.attribute.