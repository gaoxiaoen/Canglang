%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 三月 2017 15:26
%%%-------------------------------------------------------------------
-module(pet_weapon_skill).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("pet_weapon.hrl").
-include("skill.hrl").
-include("tips.hrl").

%% API
-export([
    get_pet_weapon_skill_list/1,
    calc_pet_weapon_skill_attribute/1,
    activate_skill/2,
    upgrade_skill/2,
    filter_skill_for_passive_battle/1,
    calc_skill_cbp/0,
    check_upgrade_skill_state/2,
    check_activate_skill_state/2
]).

%%获取坐骑技能
get_pet_weapon_skill_list(SkillList) ->
    F = fun(Cell) ->
        case lists:keyfind(Cell, 1, SkillList) of
            false ->
                BaseActivate = data_pet_weapon_skill_activate:get(Cell),
                [Cell, BaseActivate#base_pet_weapon_skill_activate.skill_id, 0];
            {_, SkillId} ->
                [Cell, SkillId, 1]
        end
        end,
    lists:map(F, data_pet_weapon_skill_activate:cell_list()).


%%计算技能属性
calc_pet_weapon_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_pet_weapon_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_pet_weapon_skill_upgrade.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).


%%激活技能
activate_skill(Player, Cell) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    case lists:keymember(Cell, 1, PetWeapon#st_pet_weapon.skill_list) of
        true -> {10, Player};
        false ->
            case data_pet_weapon_skill_activate:get(Cell) of
                [] -> {11, Player};
                BaseActivate ->
                    case PetWeapon#st_pet_weapon.stage >= BaseActivate#base_pet_weapon_skill_activate.stage of
                        false ->
                            {12, Player};
                        true ->
                            {GoodsId, Num} = BaseActivate#base_pet_weapon_skill_activate.goods,
                            case goods_util:get_goods_count(GoodsId) >= Num of
                                false ->
                                    goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 196),
                                    {13, Player};
                                true ->
                                    goods:subtract_good(Player, [{GoodsId, Num}], 196),
                                    SkillList = [{Cell, BaseActivate#base_pet_weapon_skill_activate.skill_id} | PetWeapon#st_pet_weapon.skill_list],
                                    PetWeapon1 = PetWeapon#st_pet_weapon{skill_list = SkillList, is_change = 1},
                                    NewPetWeapon = pet_weapon_init:calc_attribute(PetWeapon1),
                                    lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon),
                                    PassiveSkillList = [{Sid, Type} || {Sid, Type} <- Player#player.passive_skill, Type /= ?PASSIVE_SKILL_TYPE_PET_WEAPON] ++ filter_skill_for_passive_battle(SkillList),
                                    Player1 = Player#player{passive_skill = PassiveSkillList},
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:passive_skill(Player, PassiveSkillList),
                                    log_pet_weapon_skill(Player#player.key, Player#player.nickname, Cell, 0, BaseActivate#base_pet_weapon_skill_activate.skill_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

check_activate_skill_state(_Player, Tips) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    F = fun(Cell) ->
        case lists:keymember(Cell, 1, PetWeapon#st_pet_weapon.skill_list) of
            true -> [];
            false ->
                case data_pet_weapon_skill_activate:get(Cell) of
                    [] -> [];
                    BaseActivate ->
                        case PetWeapon#st_pet_weapon.stage >= BaseActivate#base_pet_weapon_skill_activate.stage of
                            false -> [];
                            true ->
                                {GoodsId, Num} = BaseActivate#base_pet_weapon_skill_activate.goods,
                                case goods_util:get_goods_count(GoodsId) >= Num of
                                    false -> [];
                                    true -> [1]
                                end
                        end
                end
        end
        end,
    List = lists:flatmap(F, data_pet_weapon_skill_activate:cell_list()),
    if
        List == [] -> Tips;
        true -> Tips#tips{state = 1}
    end.

%%升级技能
upgrade_skill(Player, Cell) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    case lists:keytake(Cell, 1, PetWeapon#st_pet_weapon.skill_list) of
        false -> {11, Player};
        {value, {_, OldSkillId}, T} ->
            case data_pet_weapon_skill_upgrade:get(OldSkillId) of
                [] -> {14, Player};
                BaseUpgrade ->
                    if PetWeapon#st_pet_weapon.stage < BaseUpgrade#base_pet_weapon_skill_upgrade.stage ->
                        {12, Player};
                        BaseUpgrade#base_pet_weapon_skill_upgrade.new_skill_id == 0 -> {15, Player};
                        true ->
                            {GoodsId, Num} = BaseUpgrade#base_pet_weapon_skill_upgrade.goods,
                            case goods_util:get_goods_count(GoodsId) >= Num of
                                false ->
                                    goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 196),
                                    {13, Player};
                                true ->
                                    goods:subtract_good(Player, [{GoodsId, Num}], 196),
                                    SkillList = [{Cell, BaseUpgrade#base_pet_weapon_skill_upgrade.new_skill_id} | T],
                                    PetWeapon1 = PetWeapon#st_pet_weapon{skill_list = SkillList, is_change = 1},
                                    NewPetWeapon = pet_weapon_init:calc_attribute(PetWeapon1),
                                    lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon),
                                    PassiveSkillList = [{Sid, Type} || {Sid, Type} <- Player#player.passive_skill, Type /= ?PASSIVE_SKILL_TYPE_PET_WEAPON] ++ filter_skill_for_passive_battle(SkillList),
                                    Player1 = Player#player{passive_skill = PassiveSkillList},
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    log_pet_weapon_skill(Player#player.key, Player#player.nickname, Cell, OldSkillId, BaseUpgrade#base_pet_weapon_skill_upgrade.new_skill_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

%%升级技能
check_upgrade_skill_state(Player, Tips) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    F = fun({_, OldSkillId}) ->
        case data_pet_weapon_skill_upgrade:get(OldSkillId) of
            [] -> [];
            BaseUpgrade ->
                if PetWeapon#st_pet_weapon.stage < BaseUpgrade#base_pet_weapon_skill_upgrade.stage ->
                    [];
                    BaseUpgrade#base_pet_weapon_skill_upgrade.new_skill_id == 0 -> {15, Player};
                    true ->
                        {GoodsId, Num} = BaseUpgrade#base_pet_weapon_skill_upgrade.goods,
                        case goods_util:get_goods_count(GoodsId) >= Num of
                            false ->
                                [];
                            true ->
                                [1]
                        end
                end
        end
        end,
    List = lists:flatmap(F, PetWeapon#st_pet_weapon.skill_list),
    if
        List == [] -> Tips;
        true -> Tips#tips{state = 1}
    end.


%%过滤战斗技能
filter_skill_for_passive_battle(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_skill:get(SkillId) of
            [] -> [];
            Skill ->
                if Skill#skill.type == ?SKILL_TYPE_PASSIVE ->
                    [{SkillId, ?PASSIVE_SKILL_TYPE_PET_WEAPON}];
                    true -> []
                end
        end
        end,
    lists:flatmap(F, SkillList).


%%计算技能战力
calc_skill_cbp() ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    Fun = fun({_, SkillId}, Out) ->
        case data_skill:get(SkillId) of
            [] -> Out;
            Skill ->
                Skill#skill.skill_cbp + Out
        end
          end,
    round(lists:foldl(Fun, 0, PetWeapon#st_pet_weapon.skill_list)).


log_pet_weapon_skill(Pkey, Nickname, Cell, OldSkillid, NewSkillId) ->
    Sql = io_lib:format("insert into log_pet_weapon_skill set pkey=~p,nickname='~s',cell=~p,old_sid=~p,new_sid=~p,time=~p",
        [Pkey, Nickname, Cell, OldSkillid, NewSkillId, util:unixtime()]),
    log_proc:log(Sql).

