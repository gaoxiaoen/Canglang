%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2017 13:49
%%%-------------------------------------------------------------------
-module(baby_mount_init).
-author("hxming").

-include("baby_mount.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
%% API
-export([init/1, timer_update/0, logout/0, get_attribute/0, calc_attribute/1]).
-export([upgrade_lv/1, activate/1, calc_spirit_attribute/1]).
init(Player) ->
    StBabyMount =
        case player_util:is_new_role(Player) of
            true ->
                BabyMount = #st_baby_mount{pkey = Player#player.key},
                lib_dict:put(?PROC_STATUS_BABY_MOUNT, BabyMount),
                BabyMount;
            false ->
                case baby_mount_load:load(Player#player.key) of
                    [] ->
                        BabyMount = #st_baby_mount{pkey = Player#player.key},
                        lib_dict:put(?PROC_STATUS_BABY_MOUNT, BabyMount),
                        BabyMount;
                    [Stage, Exp, BlessCd, BabyMountId, SkillListBin, EquipListBin, GrowNum, SpiritListBin, LastSpirit,Spirit] ->
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
                                        baby_mount:mail_bless_reset(Player#player.key, Stage),
                                        baby_mount:log_baby_mount_stage(Player#player.key, Player#player.nickname, Stage, Stage, 0, Exp, 1)
                                          end),
                                    {0, 0, 1}
                            end,
                        BabyMount = #st_baby_mount{
                            pkey = Player#player.key,
                            stage = Stage,
                            exp = NewExp,
                            bless_cd = NewCd,
                            baby_mount_id = BabyMountId,
                            skill_list = SkillList,
                            equip_list = EquipList,
                            grow_num = GrowNum,
                            spirit_list = SpiritList,
                            last_spirit = LastSpirit,
                            is_change = IsChange,
                            spirit = Spirit

                        },
                        BabyMount1 = calc_attribute(BabyMount),
                        lib_dict:put(?PROC_STATUS_BABY_MOUNT, BabyMount1),
                        BabyMount1
                end
        end,
    PassiveSkillList = baby_mount_skill:filter_skill_for_passive_battle(StBabyMount#st_baby_mount.skill_list) ++ Player#player.passive_skill,
    Player#player{baby_mount_id = StBabyMount#st_baby_mount.baby_mount_id, passive_skill = PassiveSkillList}.

%%定时更新
timer_update() ->
    StBabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    if StBabyMount#st_baby_mount.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_BABY_MOUNT, StBabyMount#st_baby_mount{is_change = 0}),
        baby_mount_load:replace(StBabyMount);
        true -> ok
    end.

%%离线
logout() ->
    StBabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    if StBabyMount#st_baby_mount.is_change =:= 1 ->
        baby_mount_load:replace(StBabyMount);
        true -> ok
    end.

%%提升等级
upgrade_lv(Player) ->
    case Player#player.lv >= ?BABY_MOUNT_OPEN_LV andalso task_in_finish() andalso Player#player.baby#fbaby.type_id /= 0 of
        false -> Player;
        true ->
            StBabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
            if StBabyMount#st_baby_mount.stage == 0 ->
                NewStBabyMount = new_baby_mount(Player#player.key),
                lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewStBabyMount),
                player_util:func_open_tips(Player, 10, NewStBabyMount#st_baby_mount.baby_mount_id),
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
    StBabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    NewStBabyMount = calc_attribute(StBabyMount),
    lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewStBabyMount),
    NewPlayer = player_util:count_player_attribute(Player#player{baby_mount_id = NewStBabyMount#st_baby_mount.baby_mount_id}, true),
    scene_agent_dispatch:baby_mount_update(NewPlayer),
    NewPlayer.

new_baby_mount(Pkey) ->
    Base = data_baby_mount_stage:get(1),
    StBabyMount =
        #st_baby_mount{
            pkey = Pkey,
            stage = 1,
            baby_mount_id = Base#base_baby_mount_stage.baby_mount_id,
            is_change = 1
        },
    StBabyMount.

%%计算属性
calc_attribute(BabyMount) ->
    Percent = get_grow_dan(BabyMount),
    StageAttr =
        case data_baby_mount_stage:get(BabyMount#st_baby_mount.stage) of
            [] -> #attribute{};
            BaseData ->
                ExpAttrs = player_util:calc_exp_attrs(BabyMount#st_baby_mount.exp, BaseData#base_baby_mount_stage.exp, BaseData#base_baby_mount_stage.bless_attrs),
                KeyValList = [{Key, round(Val * (1 + Percent))} || {Key, Val} <- util:merge_kv(BaseData#base_baby_mount_stage.attrs ++ ExpAttrs)],
                attribute_util:make_attribute_by_key_val_list(KeyValList)
        end,
    SkillAttr = calc_skill_attribute(BabyMount#st_baby_mount.skill_list),

    EquipAttrList = lists:flatmap(
        fun({_, EquipId, _}) ->
            case data_goods:get(EquipId) of
                [] ->
                    [];
                GoodsType ->
                    GoodsType#goods_type.attr_list
            end
        end, BabyMount#st_baby_mount.equip_list),
    EquipAttribute = attribute_util:make_attribute_by_key_val_list(EquipAttrList),

    DanAttr = goods_attr_dan:calc_dan_attr_by_type(?GOODS_DAN_TYPE_BABY_MOUNT),
    %%灵脉属性
    SpiritAttribute = calc_spirit_attribute(BabyMount#st_baby_mount.spirit_list),

    SumAttribute = attribute_util:sum_attribute([StageAttr, SkillAttr, EquipAttribute, DanAttr, SpiritAttribute]),
    Cbp = attribute_util:calc_combat_power(SumAttribute),
    BabyMount#st_baby_mount{attribute = SumAttribute, cbp = Cbp}.

%%计算灵脉属性
calc_spirit_attribute(SpiritList) ->
    %%灵脉属性
    L1 = lists:flatmap(
        fun({SpiritId, SpiritLv}) ->
            case data_baby_mount_spirit:get(SpiritId, SpiritLv) of
                [] -> [];
                BaseSpirit -> BaseSpirit#base_baby_mount_spirit.attrs
            end
        end, SpiritList),
    L2 =
        case baby_mount_spirit:calc_spirit_stage(SpiritList) of
            0 -> [];
            SpiritStage ->
                case [Val || Val <- data_baby_mount_spirit_stage:stage_list(), SpiritStage >= Val] of
                    [] -> [];
                    SpiritStageList ->
                        data_baby_mount_spirit_stage:get(lists:max(SpiritStageList))
                end

        end,
    attribute_util:make_attribute_by_key_val_list(L1 ++ L2).

get_grow_dan(BabyMount) ->
    case data_grow_dan:get(?GOODS_GROW_ID_BABY_MOUNT) of
        [] -> 0;
        Base ->
            BabyMount#st_baby_mount.grow_num * Base#base_grow_dan.attr_percent
    end.

%%计算技能属性
calc_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_baby_mount_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_baby_mount_skill_upgrade.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

%%获取属性
get_attribute() ->
    StBabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    StBabyMount#st_baby_mount.attribute.