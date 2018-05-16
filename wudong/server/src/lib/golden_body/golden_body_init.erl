%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 七月 2017 17:07
%%%-------------------------------------------------------------------
-module(golden_body_init).

-author("hxming").

-include("golden_body.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([init/1, timer_update/0, logout/0, get_attribute/0, calc_attribute/1]).
-export([upgrade_lv/1, activate/1, calc_spirit_attribute/1]).
init(Player) ->
    StGoldenBody =

        case player_util:is_new_role(Player) of
            true ->
                GoldenBody = #st_golden_body{pkey = Player#player.key},
                lib_dict:put(?PROC_STATUS_GOLDEN_BODY, GoldenBody),
                GoldenBody;
            false ->
                case golden_body_load:load(Player#player.key) of
                    [] ->
                        GoldenBody = #st_golden_body{pkey = Player#player.key},
                        lib_dict:put(?PROC_STATUS_GOLDEN_BODY, GoldenBody),
                        GoldenBody;
                    [Stage, Exp, BlessCd, GoldenBodyId, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit,Spirit] ->
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
                                        golden_body:mail_bless_reset(Player#player.key, Stage),
                                        golden_body:log_golden_body_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                          end),
                                    {0, 0, 1}
                            end,
                        GoldenBody = #st_golden_body{
                            pkey = Player#player.key,
                            stage = Stage,
                            exp = NewExp,
                            bless_cd = NewCd,
                            golden_body_id = GoldenBodyId,
                            skill_list = SkillList,
                            equip_list = EquipList,
                            grow_num = GrowNum,
                            spirit_list = SpiritList,
                            last_spirit = LastSpirit,
                            is_change = IsChange,
                            spirit = Spirit

                        },
                        GoldenBody1 = calc_attribute(GoldenBody),
                        lib_dict:put(?PROC_STATUS_GOLDEN_BODY, GoldenBody1),
                        GoldenBody1
                end
        end,
    PassiveSkillList = golden_body_skill:filter_skill_for_passive_battle(StGoldenBody#st_golden_body.skill_list) ++ Player#player.passive_skill,
    Player#player{golden_body_id = StGoldenBody#st_golden_body.golden_body_id, passive_skill = PassiveSkillList}.

%%定时更新
timer_update() ->
    StGoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
    if StGoldenBody#st_golden_body.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_GOLDEN_BODY, StGoldenBody#st_golden_body{is_change = 0}),
        golden_body_load:replace(StGoldenBody);
        true -> ok
    end.

%%离线
logout() ->
    StGoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
    if StGoldenBody#st_golden_body.is_change =:= 1 ->
        golden_body_load:replace(StGoldenBody);
        true -> ok
    end.

%%提升等级
upgrade_lv(Player) ->
    case Player#player.lv >= ?GOLDEN_BODY_OPEN_LV andalso task_in_finish() of
        false -> Player;
        true ->
            StGoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
            if StGoldenBody#st_golden_body.stage == 0 ->
                NewStGoldenBody = new_golden_body(Player#player.key),
                lib_dict:put(?PROC_STATUS_GOLDEN_BODY, NewStGoldenBody),
                player_util:func_open_tips(Player, 8, NewStGoldenBody#st_golden_body.golden_body_id),
                Player;
                true ->
                    Player
            end
    end.


task_in_finish() ->
    case data_menu_open:get_task(48) of
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
    StGoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
    NewStGoldenBody = calc_attribute(StGoldenBody),
    lib_dict:put(?PROC_STATUS_GOLDEN_BODY, NewStGoldenBody),
    NewPlayer = player_util:count_player_attribute(Player#player{golden_body_id = NewStGoldenBody#st_golden_body.golden_body_id}, true),
    scene_agent_dispatch:golden_body_update(NewPlayer),
    NewPlayer.

new_golden_body(Pkey) ->
    Base = data_golden_body_stage:get(1),
    StGoldenBody =
        #st_golden_body{
            pkey = Pkey,
            stage = 1,
            golden_body_id = Base#base_golden_body_stage.golden_body_id,
            is_change = 1
        },
    StGoldenBody.

%%计算属性
calc_attribute(GoldenBody) ->
    Percent = get_grow_dan(GoldenBody),
    StageAttr =
        case data_golden_body_stage:get(GoldenBody#st_golden_body.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(GoldenBody#st_golden_body.exp, BaseData#base_golden_body_stage.exp, BaseData#base_golden_body_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_golden_body_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,
    SkillAttr = calc_skill_attribute(GoldenBody#st_golden_body.skill_list),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, GoldenBody#st_golden_body.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),

    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_GOLDEN_BODY),
    %%灵脉属性
    SpiritAttribute = calc_spirit_attribute(GoldenBody#st_golden_body.spirit_list),

    SumAttribute = attribute_util:sum_attribute([StageAttr, SkillAttr, EquipAttribute, DanAttr, SpiritAttribute]),
    Cbp = attribute_util:calc_combat_power(SumAttribute),
    GoldenBody#st_golden_body{attribute = SumAttribute, cbp = Cbp}.

%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_golden_body_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_golden_body_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case golden_body_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_golden_body_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_golden_body_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).

get_grow_dan(GoldenBody) ->
    case data_grow_dan:get(?GOODS_GROW_ID_GOLDEN_BODY) of
        [] -> 0;
        Base ->
            GoldenBody#st_golden_body.grow_num * Base#base_grow_dan.attr_percent
    end.

%%计算技能属性
calc_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_golden_body_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_golden_body_skill_upgrade.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%获取属性
get_attribute() ->
    StGoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
    StGoldenBody#st_golden_body.attribute.