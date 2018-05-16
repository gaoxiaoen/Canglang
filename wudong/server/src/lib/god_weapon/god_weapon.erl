%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     十荒神器
%%% @end
%%% Created : 04. 一月 2017 15:18
%%%-------------------------------------------------------------------
-module(god_weapon).
-author("hxming").

-include("common.hrl").
-include("god_weapon.hrl").
-include("server.hrl").
-include("tips.hrl").
-include("achieve.hrl").
%% API
-compile(export_all).

god_weapon_info(Player) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    SkillId = get_rec_skill(StGodWeapon#st_god_weapon.weapon_list),
    F = fun(WeaponId) ->
        BaseData = data_god_weapon:get(WeaponId),
        case lists:keyfind(WeaponId, #god_weapon.weapon_id, StGodWeapon#st_god_weapon.weapon_list) of
            false ->
                WeaponState = check_activate(Player, BaseData),
                [WeaponId, WeaponState, 0, BaseData#base_god_weapon.skill_id, 0, 0, 0, []];
            GodWeapon ->
                SkillState = ?IF_ELSE(BaseData#base_god_weapon.skill_id == StGodWeapon#st_god_weapon.skill_id, 1, 0),
                IsRec = ?IF_ELSE(BaseData#base_god_weapon.skill_id == SkillId, ?IF_ELSE(SkillState == 1, 0, 1), 0),
                AttributeList = attribute_util:pack_attr(GodWeapon#god_weapon.attribute),
                State = ?IF_ELSE(WeaponId == StGodWeapon#st_god_weapon.weapon_id, ?GOD_WEAPON_STATE_USED, ?GOD_WEAPON_STATE_ACTIVATED),
                [GodWeapon#god_weapon.weapon_id, State, GodWeapon#god_weapon.stage, BaseData#base_god_weapon.skill_id, SkillState, IsRec, GodWeapon#god_weapon.cbp, AttributeList]
        end
        end,
    lists:map(F, data_god_weapon:id_list()).


skill_list() ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    F = fun(Weapon) ->
        BaseData = data_god_weapon:get(Weapon#god_weapon.weapon_id),
        [Weapon#god_weapon.weapon_id, BaseData#base_god_weapon.skill_id]
        end,
    SkillList = lists:map(F, StGodWeapon#st_god_weapon.weapon_list),
    {StGodWeapon#st_god_weapon.skill_id, SkillList}.


%%获取推荐的技能
get_rec_skill(WeaponList) ->
    F = fun(Weapon) ->
        BaseData = data_god_weapon:get(Weapon#god_weapon.weapon_id),
        {BaseData#base_god_weapon.skill_id, BaseData#base_god_weapon.ratio}
        end,
    case lists:map(F, WeaponList) of
        [] -> 0;
        L ->
            {SkillId, _} = lists:last(lists:keysort(2, L)),
            SkillId
    end.

%%查询解锁状态
check_activate(Player, BaseData) ->
    F = fun({Key, Val}) ->
        case Key of
            days -> Player#player.login_days >= Val;
            vip -> Player#player.vip_lv >= Val;
            lv -> Player#player.lv >= Val;
            charge_gold -> charge:charge_gold(Val)
        end
        end,
    case lists:all(F, BaseData#base_god_weapon.condition) of
        true ->
            ?GOD_WEAPON_STATE_UNLOCK;
        false ->
            ?GOD_WEAPON_STATE_LOCK
    end.

%%激活
activate(Player, WeaponId) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    case data_god_weapon:get(WeaponId) of
        [] -> {2, Player};
        BaseData ->
            case lists:keymember(WeaponId, #god_weapon.weapon_id, StGodWeapon#st_god_weapon.weapon_list) of
                true -> {3, Player};
                false ->
                    case check_activate(Player, BaseData) of
                        ?GOD_WEAPON_STATE_LOCK ->
                            {4, Player};
                        _ ->
                            Attribute = attribute_util:make_attribute_by_key_val_list(BaseData#base_god_weapon.attrs),
                            Cbp = attribute_util:calc_combat_power(Attribute),
                            Weapon = #god_weapon{weapon_id = WeaponId, stage = 1, cbp = Cbp, attribute = Attribute},
                            WeaponList = [Weapon | StGodWeapon#st_god_weapon.weapon_list],
                            NewStGodWeapon = StGodWeapon#st_god_weapon{weapon_list = WeaponList, weapon_id = WeaponId, skill_id = BaseData#base_god_weapon.skill_id, is_change = 1},
                            NewStGodWeapon1 = god_weapon_init:calc_attribute(NewStGodWeapon),
                            lib_dict:put(?PROC_STATUS_GOD_WEAPON, NewStGodWeapon1),
                            Player1 = Player#player{god_weapon_id = WeaponId, god_weapon_skill = BaseData#base_god_weapon.skill_id},
                            scene_agent_dispatch:god_weapon_id(Player1, WeaponId, BaseData#base_god_weapon.skill_id),
                            NewPlayer = player_util:count_player_attribute(Player1, true),
                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1045, 0, length(WeaponList)),
                            {1, NewPlayer}
                    end
            end
    end.

check_activate_state(Player, Tips) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    F = fun(WeaponId) ->
        BaseData = data_god_weapon:get(WeaponId),
        case lists:keymember(WeaponId, #god_weapon.weapon_id, StGodWeapon#st_god_weapon.weapon_list) of
            true -> [];
            false ->
                case check_activate(Player, BaseData) of
                    ?GOD_WEAPON_STATE_LOCK ->
                        [];
                    _ ->
                        [WeaponId]
                end
        end
        end,
    List = lists:flatmap(F, data_god_weapon:id_list()),
%%     ?DEBUG("List:~p~n", [List]),
    if
        List == [] ->
            Tips;
        true ->
            Tips#tips{state = 1, args1 = lists:min(List)}
    end.

get_notice_player(Player) ->
    %% 检查激活
    Tips0 = check_activate_state(Player, #tips{}),
    %% 检查注灵
    Tips = check_upgrade_spirit_state(Player, Tips0),
    ?IF_ELSE(Tips#tips.state == 1, 1, 0).

%%装备武器
equip_weapon(Player, WeaponId) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    case lists:keymember(WeaponId, #god_weapon.weapon_id, StGodWeapon#st_god_weapon.weapon_list) of
        false -> {5, Player};
        true ->
            if StGodWeapon#st_god_weapon.weapon_id == WeaponId -> {6, Player};
                true ->
                    NewStGodWeapon = StGodWeapon#st_god_weapon{weapon_id = WeaponId, is_change = 1},
                    lib_dict:put(?PROC_STATUS_GOD_WEAPON, NewStGodWeapon),
                    NewPlayer = Player#player{god_weapon_id = WeaponId},
                    scene_agent_dispatch:god_weapon_id(Player, WeaponId, StGodWeapon#st_god_weapon.skill_id),
                    {1, NewPlayer}
            end
    end.

%%装备技能
equip_skill(Player, WeaponId) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    case lists:keymember(WeaponId, #god_weapon.weapon_id, StGodWeapon#st_god_weapon.weapon_list) of
        false -> {5, Player};
        true ->
            BaseData = data_god_weapon:get(WeaponId),
            if BaseData#base_god_weapon.skill_id == StGodWeapon#st_god_weapon.skill_id -> {7, Player};
                true ->
                    NewStGodWeapon = StGodWeapon#st_god_weapon{skill_id = BaseData#base_god_weapon.skill_id, is_change = 1},
                    lib_dict:put(?PROC_STATUS_GOD_WEAPON, NewStGodWeapon),
                    NewPlayer = Player#player{god_weapon_skill = NewStGodWeapon#st_god_weapon.skill_id},
                    scene_agent_dispatch:god_weapon_id(Player, NewStGodWeapon#st_god_weapon.weapon_id, NewStGodWeapon#st_god_weapon.skill_id),
                    {1, NewPlayer}
            end
    end.

%%器灵信息
spirit_info(WeaponId) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    case lists:keyfind(WeaponId, #god_weapon.weapon_id, StGodWeapon#st_god_weapon.weapon_list) of
        false -> {WeaponId, 0, []};
        Weapon ->
            TypeList = data_god_weapon_spirit:get_type(WeaponId),
            F = fun(Type) ->
                case lists:keyfind(Type, 1, Weapon#god_weapon.spirit_list) of
                    false ->
                        [Type, 0];
                    {_, Lv} ->
                        [Type, Lv]
                end
                end,
            SpiritList = lists:map(F, TypeList),
            CurType = get_upgrade_type(Weapon#god_weapon.type, TypeList),
            {WeaponId, CurType, SpiritList}
    end.

%%获取下一个可升级的类型
get_upgrade_type(LastType, TypeList) ->
    MaxType = lists:max(TypeList),
    MinType = lists:min(TypeList),
    if LastType == 0 orelse LastType == MaxType -> MinType;
        true ->
            LastType + 1
    end.


%%提升器灵
upgrade_spirit(Player, WeaponId) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    case lists:keytake(WeaponId, #god_weapon.weapon_id, StGodWeapon#st_god_weapon.weapon_list) of
        false -> {5, Player};
        {value, Weapon, T} ->
            TypeList = data_god_weapon_spirit:get_type(WeaponId),
            CurType = get_upgrade_type(Weapon#god_weapon.type, TypeList),
            Lv = case lists:keyfind(CurType, 1, Weapon#god_weapon.spirit_list) of
                     false -> 0;
                     {_, Val} -> Val
                 end,
            case data_god_weapon_spirit:get(WeaponId, CurType, Lv + 1) of
                [] -> {8, Player};
                Base ->
                    case check_god_weapon(Base, Player) of
                        {false, Res} ->
                            goods_util:client_popup_goods_not_enough(Player, Base#base_god_weapon_spirit.goods_id, Base#base_god_weapon_spirit.goods_num, 20),
                            {Res, Player};
                        true ->
                            NewPlayer0 =
                                if
                                    Base#base_god_weapon_spirit.goods_id == ?REIKI ->
                                        money:add_reiki(Player, -Base#base_god_weapon_spirit.goods_num);
                                    true ->
                                        goods:subtract_good(Player, [{Base#base_god_weapon_spirit.goods_id, Base#base_god_weapon_spirit.goods_num}], 0),
                                        Player
                                end,
                            SpiritList = [{CurType, Lv + 1} | lists:keydelete(CurType, 1, Weapon#god_weapon.spirit_list)],
                            Attribute = god_weapon_init:calc_weapon_attribute(WeaponId, SpiritList),
                            Cbp = attribute_util:calc_combat_power(Attribute),
                            Stage = calc_stage(Weapon#god_weapon.stage, SpiritList, length(TypeList)),
                            NewWeapon = Weapon#god_weapon{stage = Stage, spirit_list = SpiritList, type = CurType, attribute = Attribute, cbp = Cbp},
                            StGodWeapon1 = StGodWeapon#st_god_weapon{weapon_list = [NewWeapon | T], is_change = 1},
                            NewStGodWeapon = god_weapon_init:calc_attribute(StGodWeapon1),
                            lib_dict:put(?PROC_STATUS_GOD_WEAPON, NewStGodWeapon),
                            NewPlayer = player_util:count_player_attribute(NewPlayer0, true),
                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1046, 0, 1),

                            F = fun(Weapon1, L) ->
                                case lists:keytake(Weapon1#god_weapon.stage, 1, L) of
                                    false ->
                                        [{Weapon1#god_weapon.stage, 1} | L];
                                    {value, {_, Val1}, L1} ->
                                        [{Weapon1#god_weapon.stage, 1 + Val1} | L1]
                                end
                                end,
                            CountList = lists:foldl(F, [], StGodWeapon1#st_god_weapon.weapon_list),
                            F1 = fun({Stage1, Count}) ->
                                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1047, Stage1, Count)
                                 end,
                            lists:foreach(F1, CountList),

                            {1, NewPlayer}
                    end
            end
    end.

check_upgrade_spirit_state(_Player, Tips) ->
    List = get_upgrade_spirit_list(_Player),
    if
        List == [] ->
            Tips;
        true ->
            Tips#tips{state = 1, args1 = lists:min(List)}
    end.

get_upgrade_spirit_list(_Player) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    F = fun(#god_weapon{weapon_id = WeaponId} = Weapon) ->
        TypeList = data_god_weapon_spirit:get_type(WeaponId),
        CurType = get_upgrade_type(Weapon#god_weapon.type, TypeList),
        Lv = case lists:keyfind(CurType, 1, Weapon#god_weapon.spirit_list) of
                 false -> 0;
                 {_, Val} -> Val
             end,
        case data_god_weapon_spirit:get(WeaponId, CurType, Lv + 1) of
            [] -> [];
            Base ->
                Check = check_god_weapon(Base, _Player),
                if
                    Check /= true -> [];
                    true -> [WeaponId]
                end
        end
        end,
    lists:flatmap(F, StGodWeapon#st_god_weapon.weapon_list).

calc_stage(Stage, SpiritList, TypeLen) ->
    case length(SpiritList) == TypeLen of
        false -> Stage;
        true ->
            [{_, Lv} | T] = SpiritList,
            F = fun({_, Lv1}) -> Lv1 == Lv end,
            case lists:all(F, T) of
                true -> Stage + 1;
                false ->
                    Stage
            end
    end.


check_god_weapon(Base, Player) ->
    if
        Base#base_god_weapon_spirit.goods_id == ?REIKI ->
            ?IF_ELSE(Base#base_god_weapon_spirit.goods_num > Player#player.reiki, {false, 9}, true); %%
        true ->
            GoodsCount = goods_util:get_goods_count(Base#base_god_weapon_spirit.goods_id),
            ?IF_ELSE(GoodsCount < Base#base_god_weapon_spirit.goods_num, {false, 9}, true) %%
    end.