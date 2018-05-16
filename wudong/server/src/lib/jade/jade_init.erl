%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 七月 2017 17:07
%%%-------------------------------------------------------------------
-module(jade_init).

-author("hxming").

-include("jade.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([init/1, timer_update/0, logout/0, get_attribute/0, calc_attribute/1]).
-export([upgrade_lv/1, activate/1, calc_spirit_attribute/1]).
init(Player) ->
    StJade =
        case player_util:is_new_role(Player) of
            true ->
                Jade = #st_jade{pkey = Player#player.key},
                lib_dict:put(?PROC_STATUS_JADE, Jade),
                Jade;
            false ->
                case jade_load:load(Player#player.key) of
                    [] ->
                        Jade = #st_jade{pkey = Player#player.key},
                        lib_dict:put(?PROC_STATUS_JADE, Jade),
                        Jade;
                    [Stage, Exp, BlessCd, JadeId, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit, Spirit] ->
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
                                        jade:mail_bless_reset(Player#player.key, Stage),
                                        jade:log_jade_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                    end),
                                    {0, 0, 1}
                            end,
                        Jade = #st_jade{
                            pkey = Player#player.key,
                            stage = Stage,
                            exp = NewExp,
                            bless_cd = NewCd,
                            jade_id = JadeId,
                            skill_list = SkillList,
                            equip_list = EquipList,
                            grow_num = GrowNum,
                            spirit_list = SpiritList,
                            last_spirit = LastSpirit,
                            is_change = IsChange,
                            spirit = Spirit
                        },
                        Jade1 = calc_attribute(Jade),
                        lib_dict:put(?PROC_STATUS_JADE, Jade1),
                        Jade1
                end
        end,
    upgrade_lv(Player),
    StJade1 = lib_dict:get(?PROC_STATUS_JADE),
    NewStJade = calc_attribute(StJade1),
    lib_dict:put(?PROC_STATUS_JADE, NewStJade),
    PassiveSkillList = jade_skill:filter_skill_for_passive_battle(StJade1#st_jade.skill_list) ++ Player#player.passive_skill,
    Player#player{jade_id = StJade1#st_jade.jade_id, passive_skill = PassiveSkillList}.

%%定时更新
timer_update() ->
    StJade = lib_dict:get(?PROC_STATUS_JADE),
    if StJade#st_jade.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_JADE, StJade#st_jade{is_change = 0}),
        jade_load:replace(StJade);
        true -> ok
    end.

%%离线
logout() ->
    StJade = lib_dict:get(?PROC_STATUS_JADE),
    if StJade#st_jade.is_change =:= 1 ->
        jade_load:replace(StJade);
        true -> ok
    end.

%%提升等级
upgrade_lv(Player) ->
    case Player#player.lv >= ?JADE_OPEN_LV of
        false -> Player;
        true ->
            StJade = lib_dict:get(?PROC_STATUS_JADE),
            if StJade#st_jade.stage == 0 ->
                NewStJade = new_jade(Player#player.key),
                lib_dict:put(?PROC_STATUS_JADE, NewStJade),
                player_util:func_open_tips(Player, 12, NewStJade#st_jade.jade_id),
                Player;
                true ->
                    Player
            end
    end.

%%
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
    StJade = lib_dict:get(?PROC_STATUS_JADE),
    NewStJade = calc_attribute(StJade),
    lib_dict:put(?PROC_STATUS_JADE, NewStJade),
    NewPlayer = player_util:count_player_attribute(Player#player{jade_id = NewStJade#st_jade.jade_id}, true),
    scene_agent_dispatch:jade_update(NewPlayer),
    NewPlayer.

new_jade(Pkey) ->
    Base = data_jade_stage:get(1),
    StJade =
        #st_jade{
            pkey = Pkey,
            stage = 1,
            jade_id = Base#base_jade_stage.jade_id,
            is_change = 1
        },
    StJade.

%%计算属性
calc_attribute(Jade) ->
    Percent = get_grow_dan(Jade),
    StageAttr =
        case data_jade_stage:get(Jade#st_jade.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(Jade#st_jade.exp, BaseData#base_jade_stage.exp, BaseData#base_jade_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_jade_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,
    SkillAttr = calc_skill_attribute(Jade#st_jade.skill_list),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, Jade#st_jade.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),

    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_JADE),
    ?DEBUG("DanAttr ~p~n",[DanAttr]),
    %%灵脉属性
    SpiritAttribute = calc_spirit_attribute(Jade#st_jade.spirit_list),

    SumAttribute = attribute_util:sum_attribute([StageAttr, SkillAttr, EquipAttribute, DanAttr, SpiritAttribute]),
    Cbp = attribute_util:calc_combat_power(SumAttribute),
    Jade#st_jade{attribute = SumAttribute, cbp = Cbp}.

%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_jade_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_jade_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case jade_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_jade_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_jade_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).

get_grow_dan(Jade) ->
    case data_grow_dan:get(?GOODS_GROW_ID_JADE) of
        [] -> 0;
        Base ->
            Jade#st_jade.grow_num * Base#base_grow_dan.attr_percent
    end.

%%计算技能属性
calc_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_jade_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_jade_skill_upgrade.attrs
        end
    end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%获取属性
get_attribute() ->
    StJade = lib_dict:get(?PROC_STATUS_JADE),
    StJade#st_jade.attribute.