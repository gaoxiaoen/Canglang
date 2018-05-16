%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:16
%%%-------------------------------------------------------------------
-module(footprint_skill).

-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("footprint_new.hrl").
-include("skill.hrl").
-include("tips.hrl").

%% API
-export([
    get_footprint_skill_list/1,
    calc_footprint_skill_attribute/1,
    activate_skill/2,
    upgrade_skill/2,
    filter_skill_for_passive_battle/1,
    calc_skill_cbp/0,
    check_upgrade_skill_state/2,
    check_activate_skill_state/2
]).

%%获取坐骑技能
get_footprint_skill_list(SkillList) ->
    F = fun(Cell) ->
        case lists:keyfind(Cell, 1, SkillList) of
            false ->
                BaseActivate = data_footprint_skill_activate:get(Cell),
                [Cell, BaseActivate#base_footprint_skill_activate.skill_id, 0];
            {_, SkillId} ->
                [Cell, SkillId, 1]
        end
        end,
    lists:map(F, data_footprint_skill_activate:cell_list()).


%%计算技能属性
calc_footprint_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_footprint_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_footprint_skill_upgrade.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).


%%激活技能
activate_skill(Player, Cell) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    case lists:keymember(Cell, 1, Footprint#st_footprint.skill_list) of
        true -> {10, Player};
        false ->
            case data_footprint_skill_activate:get(Cell) of
                [] -> {11, Player};
                BaseActivate ->
                    case Footprint#st_footprint.stage >= BaseActivate#base_footprint_skill_activate.stage of
                        false ->
                            {12, Player};
                        true ->
                            {GoodsId, Num} = BaseActivate#base_footprint_skill_activate.goods,
                            case goods_util:get_goods_count(GoodsId) >= Num of
                                false ->
                                    goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 196),
                                    {13, Player};
                                true ->
                                    goods:subtract_good(Player, [{GoodsId, Num}], 196),
                                    SkillList = [{Cell, BaseActivate#base_footprint_skill_activate.skill_id} | Footprint#st_footprint.skill_list],
                                    Footprint1 = Footprint#st_footprint{skill_list = SkillList, is_change = 1},
                                    NewFootprint = footprint_init:calc_attribute(Footprint1),
                                    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
                                    PassiveSkillList = [{Sid, Type} || {Sid, Type} <- Player#player.passive_skill, Type /= ?PASSIVE_SKILL_TYPE_FOOTPRINT] ++ filter_skill_for_passive_battle(SkillList),
                                    Player1 = Player#player{passive_skill = PassiveSkillList},
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:passive_skill(Player, PassiveSkillList),
                                    log_footprint_skill(Player#player.key, Player#player.nickname, Cell, 0, BaseActivate#base_footprint_skill_activate.skill_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

check_activate_skill_state(_Player, Tips) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    F = fun(Cell) ->
        case lists:keymember(Cell, 1, Footprint#st_footprint.skill_list) of
            true -> [];
            false ->
                case data_footprint_skill_activate:get(Cell) of
                    [] -> [];
                    BaseActivate ->
                        case Footprint#st_footprint.stage >= BaseActivate#base_footprint_skill_activate.stage of
                            false -> [];
                            true ->
                                {GoodsId, Num} = BaseActivate#base_footprint_skill_activate.goods,
                                case goods_util:get_goods_count(GoodsId) >= Num of
                                    false -> [];
                                    true -> [1]
                                end
                        end
                end
        end
        end,
    List = lists:flatmap(F, data_footprint_skill_activate:cell_list()),
    if
        List == [] -> Tips;
        true -> Tips#tips{state = 1}
    end.

%%升级技能
upgrade_skill(Player, Cell) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    case lists:keytake(Cell, 1, Footprint#st_footprint.skill_list) of
        false -> {11, Player};
        {value, {_, OldSkillId}, T} ->
            case data_footprint_skill_upgrade:get(OldSkillId) of
                [] -> {14, Player};
                BaseUpgrade ->
                    if Footprint#st_footprint.stage < BaseUpgrade#base_footprint_skill_upgrade.stage ->
                        {12, Player};
                        BaseUpgrade#base_footprint_skill_upgrade.new_skill_id == 0 -> {15, Player};
                        true ->
                            {GoodsId, Num} = BaseUpgrade#base_footprint_skill_upgrade.goods,
                            case goods_util:get_goods_count(GoodsId) >= Num of
                                false ->
                                    goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 196),
                                    {13, Player};
                                true ->
                                    goods:subtract_good(Player, [{GoodsId, Num}], 196),
                                    SkillList = [{Cell, BaseUpgrade#base_footprint_skill_upgrade.new_skill_id} | T],
                                    Footprint1 = Footprint#st_footprint{skill_list = SkillList, is_change = 1},
                                    NewFootprint = footprint_init:calc_attribute(Footprint1),
                                    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
                                    PassiveSkillList = [{Sid, Type} || {Sid, Type} <- Player#player.passive_skill, Type /= ?PASSIVE_SKILL_TYPE_FOOTPRINT] ++ filter_skill_for_passive_battle(SkillList),
                                    Player1 = Player#player{passive_skill = PassiveSkillList},
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    log_footprint_skill(Player#player.key, Player#player.nickname, Cell, OldSkillId, BaseUpgrade#base_footprint_skill_upgrade.new_skill_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

%%升级技能
check_upgrade_skill_state(Player, Tips) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    F = fun({_, OldSkillId}) ->
        case data_footprint_skill_upgrade:get(OldSkillId) of
            [] -> [];
            BaseUpgrade ->
                if Footprint#st_footprint.stage < BaseUpgrade#base_footprint_skill_upgrade.stage ->
                    [];
                    BaseUpgrade#base_footprint_skill_upgrade.new_skill_id == 0 -> {15, Player};
                    true ->
                        {GoodsId, Num} = BaseUpgrade#base_footprint_skill_upgrade.goods,
                        case goods_util:get_goods_count(GoodsId) >= Num of
                            false ->
                                [];
                            true ->
                                [1]
                        end
                end
        end
        end,
    List = lists:flatmap(F, Footprint#st_footprint.skill_list),
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
                    [{SkillId, ?PASSIVE_SKILL_TYPE_FOOTPRINT}];
                    true -> []
                end
        end
        end,
    lists:flatmap(F, SkillList).


%%计算技能战力
calc_skill_cbp() ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    Fun = fun({_, SkillId}, Out) ->
        case data_skill:get(SkillId) of
            [] -> Out;
            Skill ->
                Skill#skill.skill_cbp + Out
        end
          end,
    round(lists:foldl(Fun, 0, Footprint#st_footprint.skill_list)).


log_footprint_skill(Pkey, Nickname, Cell, OldSkillid, NewSkillId) ->
    Sql = io_lib:format("insert into log_footprint_skill set pkey=~p,nickname='~s',cell=~p,old_sid=~p,new_sid=~p,time=~p",
        [Pkey, Nickname, Cell, OldSkillid, NewSkillId, util:unixtime()]),
    log_proc:log(Sql).