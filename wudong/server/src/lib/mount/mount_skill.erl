%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十一月 2016 11:51
%%%-------------------------------------------------------------------
-module(mount_skill).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("mount.hrl").
-include("skill.hrl").
-include("tips.hrl").

%% API
-export([
    get_mount_skill_list/1,
    calc_mount_skill_attribute/1,
    activate_skill/2,
    upgrade_skill/2,
    filter_skill_for_battle/1,
    calc_skill_cbp/0,
    check_upgrade_skill_state/2,
    check_activate_skill_state/2
]).

%%获取坐骑技能
get_mount_skill_list(SkillList) ->
    F = fun(Cell) ->
        case lists:keyfind(Cell, 1, SkillList) of
            false ->
                BaseActivate = data_mount_skill_activate:get(Cell),
                [Cell, BaseActivate#base_mount_skill_activate.skill_id, 0];
            {_, SkillId} ->
                [Cell, SkillId, 1]
        end
        end,
    lists:map(F, data_mount_skill_activate:cell_list()).


%%计算技能属性
calc_mount_skill_attribute(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_mount_skill_upgrade:get(SkillId) of
            [] -> [];
            BaseUpgrade -> BaseUpgrade#base_mount_skill_upgrade.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillList),
    attribute_util:make_attribute_by_key_val_list(AttrList).


%%激活技能
activate_skill(Player, Cell) ->
    Mount = mount_util:get_mount(),
    case lists:keymember(Cell, 1, Mount#st_mount.skill_list) of
        true -> {35, Player};
        false ->
            case data_mount_skill_activate:get(Cell) of
                [] -> {36, Player};
                BaseActivate ->
                    case Mount#st_mount.stage >= BaseActivate#base_mount_skill_activate.stage of
                        false ->
                            {37, Player};
                        true ->
                            {GoodsId, Num} = BaseActivate#base_mount_skill_activate.goods,
                            case goods_util:get_goods_count(GoodsId) >= Num of
                                false ->
                                    goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 196),
                                    {38, Player};
                                true ->
                                    goods:subtract_good(Player, [{GoodsId, Num}], 196),
                                    SkillList = [{Cell, BaseActivate#base_mount_skill_activate.skill_id} | Mount#st_mount.skill_list],
                                    NewMount = Mount#st_mount{skill_list = SkillList, is_change = 1},
                                    NewMount1 = mount_attr:calc_mount_attr(NewMount),
                                    mount_util:put_mount(NewMount1),
                                    PassiveSkillList = [{Sid, Type} || {Sid, Type} <- Player#player.passive_skill, Type /= ?PASSIVE_SKILL_TYPE_MOUNT] ++ filter_skill_for_battle(SkillList),
                                    Player1 = Player#player{passive_skill = PassiveSkillList},
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:passive_skill(Player, PassiveSkillList),
                                    log_mount_skill(Player#player.key, Player#player.nickname, Cell, 0, BaseActivate#base_mount_skill_activate.skill_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

check_activate_skill_state(_Player, Tips) ->
    Mount = mount_util:get_mount(),
    F = fun(Cell) ->
        case lists:keymember(Cell, 1, Mount#st_mount.skill_list) of
            true -> [];
            false ->
                case data_mount_skill_activate:get(Cell) of
                    [] -> [];
                    BaseActivate ->
                        case Mount#st_mount.stage >= BaseActivate#base_mount_skill_activate.stage of
                            false -> [];
                            true ->
                                {GoodsId, Num} = BaseActivate#base_mount_skill_activate.goods,
                                case goods_util:get_goods_count(GoodsId) >= Num of
                                    false -> [];
                                    true -> [1]
                                end
                        end
                end
        end
        end,
    List = lists:flatmap(F, data_mount_skill_activate:cell_list()),
    if
        List == [] -> Tips;
        true -> Tips#tips{state = 1}
    end.

%%升级技能
upgrade_skill(Player, Cell) ->
    Mount = mount_util:get_mount(),
    case lists:keytake(Cell, 1, Mount#st_mount.skill_list) of
        false -> {39, Player};
        {value, {_, OldSkillId}, T} ->
            case data_mount_skill_upgrade:get(OldSkillId) of
                [] -> {36, Player};
                BaseUpgrade ->
                    if Mount#st_mount.stage < BaseUpgrade#base_mount_skill_upgrade.stage -> {37, Player};
                        BaseUpgrade#base_mount_skill_upgrade.new_skill_id == 0 -> {41, Player};
                        true ->
                            {GoodsId, Num} = BaseUpgrade#base_mount_skill_upgrade.goods,
                            case goods_util:get_goods_count(GoodsId) >= Num of
                                false ->
                                    goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 196),
                                    {40, Player};
                                true ->
                                    goods:subtract_good(Player, [{GoodsId, Num}], 196),
                                    SkillList = [{Cell, BaseUpgrade#base_mount_skill_upgrade.new_skill_id} | T],
                                    NewMount = Mount#st_mount{skill_list = SkillList, is_change = 1},
                                    NewMount1 = mount_attr:calc_mount_attr(NewMount),
                                    mount_util:put_mount(NewMount1),
                                    PassiveSkillList = [{Sid, Type} || {Sid, Type} <- Player#player.passive_skill, Type /= ?PASSIVE_SKILL_TYPE_MOUNT] ++ filter_skill_for_battle(SkillList),
                                    Player1 = Player#player{passive_skill = PassiveSkillList},
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:passive_skill(Player, PassiveSkillList),
                                    log_mount_skill(Player#player.key, Player#player.nickname, Cell, OldSkillId, BaseUpgrade#base_mount_skill_upgrade.new_skill_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

check_upgrade_skill_state(_Player, Tips) ->
    Mount = mount_util:get_mount(),
    F = fun({_Cell, OldSkillId}) ->
        case data_mount_skill_upgrade:get(OldSkillId) of
            [] -> [];
            BaseUpgrade ->
                if Mount#st_mount.stage < BaseUpgrade#base_mount_skill_upgrade.stage -> [];
                    BaseUpgrade#base_mount_skill_upgrade.new_skill_id == 0 -> [];
                    true ->
                        {GoodsId, Num} = BaseUpgrade#base_mount_skill_upgrade.goods,
                        case goods_util:get_goods_count(GoodsId) >= Num of
                            false -> [];
                            true -> [1]
                        end
                end
        end
        end,
    List = lists:flatmap(F, Mount#st_mount.skill_list),
    if
        List == [] -> Tips;
        true -> Tips#tips{state = 1}
    end.

%%过滤战斗技能
filter_skill_for_battle(SkillList) ->
    F = fun({_Cell, SkillId}) ->
        case data_skill:get(SkillId) of
            [] -> [];
            Skill ->
                if Skill#skill.type == ?SKILL_TYPE_PASSIVE ->
                    [{SkillId, ?PASSIVE_SKILL_TYPE_MOUNT}];
                    true -> []
                end
        end
        end,
    lists:flatmap(F, SkillList).

%%计算技能战力
calc_skill_cbp() ->
    Mount = mount_util:get_mount(),
    Fun = fun({_, SkillId}, Out) ->
        case data_skill:get(SkillId) of
            [] -> Out;
            Skill ->
                Skill#skill.skill_cbp + Out
        end
          end,
    round(lists:foldl(Fun, 0, Mount#st_mount.skill_list)).


log_mount_skill(Pkey, Nickname, Cell, OldSkillid, NewSkillId) ->
    Sql = io_lib:format("insert into log_mount_skill set pkey=~p,nickname='~s',cell=~p,old_sid=~p,new_sid=~p,time=~p",
        [Pkey, Nickname, Cell, OldSkillid, NewSkillId, util:unixtime()]),
    log_proc:log(Sql).
