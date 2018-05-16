%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 三月 2017 15:15
%%%-------------------------------------------------------------------
-module(pet_weapon).
-author("hxming").

-include("pet_weapon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("tips.hrl").
-include("activity.hrl").
-include("achieve.hrl").

%% API
-export([
    get_pet_weapon_info/0,
    view_other/1,
    change_figure/2,
    upgrade_stage/2,
    bless_cd_reset/2,
    check_bless_state/1,
    mail_bless_reset/2,
    equip_goods/2,
    use_pet_weapon_dan/1,
    check_upgrade_stage_state/2,
    check_use_pet_weapon_dan_state/2,
    check_upgrade_jp_state/3,
    goods_add_stage/3,
    goods_add_stage_limit/3,
    goods_add_to_stage/3,
    get_equip_smelt_state/0,
    log_pet_weapon_stage/7
]).

%%获取法宝信息
get_pet_weapon_info() ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    Now = util:unixtime(),
    Cd = max(0, PetWeapon#st_pet_weapon.bless_cd - Now),
    SkillList =
        pet_weapon_skill:get_pet_weapon_skill_list(PetWeapon#st_pet_weapon.skill_list),
    AttributeList = attribute_util:pack_attr(PetWeapon#st_pet_weapon.attribute),
    EquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- PetWeapon#st_pet_weapon.equip_list],
    SpiritState = pet_weapon_spirit:check_spirit_state(PetWeapon),
    {PetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.exp, Cd, PetWeapon#st_pet_weapon.weapon_id,
        PetWeapon#st_pet_weapon.cbp, PetWeapon#st_pet_weapon.grow_num, AttributeList, SkillList, EquipList, SpiritState}.

view_other(Pkey) ->
    Key = {pet_weapon_view, Pkey},
    case cache:get(Key) of
        [] ->
            case pet_weapon_load:load_view(Pkey) of
                [] -> {0, 0, [], [], [], 0, []};
                %%stage,cbp,attribute,skill_list,equip_list,grow_num,spirit_list
                [Stage, Cbp, AttributeList, SkillList, EquipList, GrowNum] ->
                    NewAttributeList = attribute_util:pack_attr(util:bitstring_to_term(AttributeList)),
                    NewSkillList = pet_weapon_skill:get_pet_weapon_skill_list(util:bitstring_to_term(SkillList)),
                    NewEquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- util:bitstring_to_term(EquipList)],
                    DanList = goods_attr_dan:get_dan_list_by_type(Pkey, ?GOODS_DAN_TYPE_PET_WEAPON),
                    Data = {Stage, Cbp, NewAttributeList, NewSkillList, NewEquipList, GrowNum, DanList},
                    cache:set(Key, Data, ?FIFTEEN_MIN_SECONDS),
                    Data
            end;
        Data -> Data
    end.

%%幻化
change_figure(Player, FigureId) ->
    StPetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    case data_pet_weapon_stage:figure2stage(FigureId) of
        [] -> {8, Player};
        Stage ->
            if StPetWeapon#st_pet_weapon.stage < Stage -> {9, Player};
                true ->
                    NewStPetWeapon = StPetWeapon#st_pet_weapon{weapon_id = FigureId, is_change = 1},
                    lib_dict:put(?PROC_STATUS_PET_WEAPON, NewStPetWeapon),
                    {1, Player#player{pet_weaponid = FigureId}}
            end
    end.

%%物品增加1阶
goods_add_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    MaxStage = data_pet_weapon_stage:max_stage(),
    if PetWeapon#st_pet_weapon.stage >= MaxStage -> {Player, GoodsList};
        PetWeapon#st_pet_weapon.stage >= Stage ->
            BaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage),
            NewExp = PetWeapon#st_pet_weapon.exp + Exp,
            if NewExp >= BaseData#base_pet_weapon_stage.exp ->
                NextBaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage + 1),
                NewPetWeapon = PetWeapon#st_pet_weapon{exp = 0, stage = PetWeapon#st_pet_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_pet_weapon_stage.weapon_id, is_change = 1},
                NewPetWeapon1 = pet_weapon_init:calc_attribute(NewPetWeapon),
                lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon1),
                NewPlayer = player_util:count_player_attribute(Player#player{pet_weaponid = NewPetWeapon1#st_pet_weapon.weapon_id}, true),
                scene_agent_dispatch:pet_weapon_update(NewPlayer),
                log_pet_weapon_stage(Player#player.key, Player#player.nickname, NewPetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, NewPetWeapon#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_pet_weapon_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1025, 0, NewPetWeapon#st_pet_weapon.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_pet_weapon_stage.award));
                true ->
                    PetWeapon1 = set_bless_cd(PetWeapon, BaseData#base_pet_weapon_stage.cd),
                    NewPetWeapon = PetWeapon1#st_pet_weapon{exp = PetWeapon#st_pet_weapon.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon),
                    log_pet_weapon_stage(Player#player.key, Player#player.nickname, NewPetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, NewPetWeapon#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage + 1),
            NewPetWeapon = PetWeapon#st_pet_weapon{exp = 0, stage = PetWeapon#st_pet_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_pet_weapon_stage.weapon_id, is_change = 1},
            NewPetWeapon1 = pet_weapon_init:calc_attribute(NewPetWeapon),
            notice_sys:add_notice(player_view, [Player, 5, NewPetWeapon1#st_pet_weapon.stage]),
            lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon1),
            NewPlayer = player_util:count_player_attribute(Player#player{pet_weaponid = NewPetWeapon1#st_pet_weapon.weapon_id}, true),
            scene_agent_dispatch:pet_weapon_update(NewPlayer),
            BaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_pet_weapon_stage.award))),
            log_pet_weapon_stage(Player#player.key, Player#player.nickname, NewPetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, NewPetWeapon#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1025, 0, NewPetWeapon#st_pet_weapon.stage),
            goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_pet_weapon_stage.award))
    end.

%%使用物品增加到指定阶数 1 3
goods_add_to_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_to_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    MaxStage = data_pet_weapon_stage:max_stage(),
    if PetWeapon#st_pet_weapon.stage >= MaxStage -> {Player, GoodsList};
        PetWeapon#st_pet_weapon.stage >= Stage ->
            BaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage),
            NewExp = PetWeapon#st_pet_weapon.exp + Exp,
            if NewExp >= BaseData#base_pet_weapon_stage.exp ->
                NextBaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage + 1),
                NewPetWeapon = PetWeapon#st_pet_weapon{exp = 0, stage = PetWeapon#st_pet_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_pet_weapon_stage.weapon_id, is_change = 1},
                NewPetWeapon1 = pet_weapon_init:calc_attribute(NewPetWeapon),
                lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon1),
                NewPlayer = player_util:count_player_attribute(Player#player{pet_weaponid = NewPetWeapon1#st_pet_weapon.weapon_id}, true),
                scene_agent_dispatch:pet_weapon_update(NewPlayer),
                log_pet_weapon_stage(Player#player.key, Player#player.nickname, NewPetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, NewPetWeapon#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_pet_weapon_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1025, 0, NewPetWeapon#st_pet_weapon.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_pet_weapon_stage.award));
                true ->
                    PetWeapon1 = set_bless_cd(PetWeapon, BaseData#base_pet_weapon_stage.cd),
                    NewPetWeapon = PetWeapon1#st_pet_weapon{exp = PetWeapon#st_pet_weapon.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon),
                    log_pet_weapon_stage(Player#player.key, Player#player.nickname, NewPetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, NewPetWeapon#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            F = fun(_, {M, GList}) ->
                NextBaseData = data_pet_weapon_stage:get(M#st_pet_weapon.stage + 1),
                NewM = M#st_pet_weapon{exp = 0, stage = M#st_pet_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_pet_weapon_stage.weapon_id, is_change = 1},
                BaseData = data_pet_weapon_stage:get(M#st_pet_weapon.stage),
                {NewM, GList ++ tuple_to_list(BaseData#base_pet_weapon_stage.award)}
                end,
            {NewPetWeapon, GoodsList1} = lists:foldl(F, {PetWeapon, []}, lists:seq(PetWeapon#st_pet_weapon.stage, Stage - 1)),
            log_pet_weapon_stage(Player#player.key, Player#player.nickname, NewPetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, NewPetWeapon#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 0),
            NewPetWeapon1 = pet_weapon_init:calc_attribute(NewPetWeapon),
            notice_sys:add_notice(player_view, [Player, 5, NewPetWeapon1#st_pet_weapon.stage]),
            lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon1),
            NewPlayer = player_util:count_player_attribute(Player#player{pet_weaponid = NewPetWeapon1#st_pet_weapon.weapon_id}, true),
            scene_agent_dispatch:pet_weapon_update(NewPlayer),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1025, 0, NewPetWeapon#st_pet_weapon.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, goods:merge_goods(GoodsList))),
            goods_add_to_stage(NewPlayer, T, GoodsList ++ GoodsList1)
    end.


%%物品增加1阶 特定等级
goods_add_stage_limit(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage_limit(Player, [{Stage, Exp} | T], GoodsList) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    MaxStage = data_pet_weapon_stage:max_stage(),
    if PetWeapon#st_pet_weapon.stage >= MaxStage -> {Player, GoodsList};
        PetWeapon#st_pet_weapon.stage > Stage ->
            BaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage),
            NewExp = PetWeapon#st_pet_weapon.exp + Exp,
            if NewExp >= BaseData#base_pet_weapon_stage.exp ->
                NextBaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage + 1),
                NewPetWeapon = PetWeapon#st_pet_weapon{exp = 0, stage = PetWeapon#st_pet_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_pet_weapon_stage.weapon_id, is_change = 1},
                NewPetWeapon1 = pet_weapon_init:calc_attribute(NewPetWeapon),
                lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon1),
                NewPlayer = player_util:count_player_attribute(Player#player{pet_weaponid = NewPetWeapon1#st_pet_weapon.weapon_id}, true),
                scene_agent_dispatch:pet_weapon_update(NewPlayer),
                log_pet_weapon_stage(Player#player.key, Player#player.nickname, NewPetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, NewPetWeapon#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_pet_weapon_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1025, 0, NewPetWeapon#st_pet_weapon.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_pet_weapon_stage.award));
                true ->
                    PetWeapon1 = set_bless_cd(PetWeapon, BaseData#base_pet_weapon_stage.cd),
                    NewPetWeapon = PetWeapon1#st_pet_weapon{exp = PetWeapon#st_pet_weapon.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon),
                    log_pet_weapon_stage(Player#player.key, Player#player.nickname, NewPetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, NewPetWeapon#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage + 1),
            NewPetWeapon = PetWeapon#st_pet_weapon{exp = 0, stage = PetWeapon#st_pet_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_pet_weapon_stage.weapon_id, is_change = 1},
            NewPetWeapon1 = pet_weapon_init:calc_attribute(NewPetWeapon),
            notice_sys:add_notice(player_view, [Player, 5, NewPetWeapon1#st_pet_weapon.stage]),
            lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon1),
            NewPlayer = player_util:count_player_attribute(Player#player{pet_weaponid = NewPetWeapon1#st_pet_weapon.weapon_id}, true),
            scene_agent_dispatch:pet_weapon_update(NewPlayer),
            BaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_pet_weapon_stage.award))),
            log_pet_weapon_stage(Player#player.key, Player#player.nickname, NewPetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, NewPetWeapon#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1025, 0, NewPetWeapon#st_pet_weapon.stage),
            goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_pet_weapon_stage.award))
    end.

%%升阶
upgrade_stage(Player, IsAuto) ->
    OpenLv = ?PET_WEAPON_OPEN_LV,
    if Player#player.lv < OpenLv -> {false, 2};
        true ->
            MaxStage = data_pet_weapon_stage:max_stage(),
            PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
            if PetWeapon#st_pet_weapon.stage >= MaxStage -> {false, 3};
                PetWeapon#st_pet_weapon.stage == 0 -> {false, 0};
                true ->
                    BaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage),
                    case check_goods(Player, BaseData, IsAuto) of
                        {false, Err} -> {false, Err};
                        {true, Player1} ->
                            PetWeapon1 = add_exp(PetWeapon, BaseData, Player#player.vip_lv),
                            log_pet_weapon_stage(Player#player.key, Player#player.nickname, PetWeapon1#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, PetWeapon1#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 0),
                            OldExpPercent = util:floor(PetWeapon#st_pet_weapon.exp / BaseData#base_pet_weapon_stage.exp * 100),
                            NewExpPercent = util:floor(PetWeapon1#st_pet_weapon.exp / BaseData#base_pet_weapon_stage.exp * 100),
                            if
                                PetWeapon1#st_pet_weapon.stage /= PetWeapon#st_pet_weapon.stage ->
                                    NewPetWeapon = pet_weapon_init:calc_attribute(PetWeapon1),
                                    lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon),
                                    NewPlayer = player_util:count_player_attribute(Player1#player{pet_weaponid = PetWeapon1#st_pet_weapon.weapon_id}, true),
                                    scene_agent_dispatch:attribute_update(NewPlayer),
                                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_pet_weapon_stage.award))),
                                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1025, 0, NewPetWeapon#st_pet_weapon.stage),
                                    open_act_all_target:act_target(5, Player#player.key, PetWeapon1#st_pet_weapon.stage),
                                    notice_sys:add_notice(player_view, [Player, 5, PetWeapon1#st_pet_weapon.stage]),
                                    activity:get_notice(Player, [33, 46], true),
                                    {ok, 7, NewPlayer1};
                                OldExpPercent /= NewExpPercent ->
                                    NewPetWeapon = pet_weapon_init:calc_attribute(PetWeapon1),
                                    lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon),
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:attribute_update(NewPlayer),
                                    {ok, 1, NewPlayer};
                                true ->
                                    lib_dict:put(?PROC_STATUS_PET_WEAPON, PetWeapon1),
                                    {ok, 1, Player1}
                            end
                    end
            end
    end.

%%升阶
check_upgrade_stage_state(Player, Tips) ->
    OpenLv = ?PET_WEAPON_OPEN_LV,
    if Player#player.lv < OpenLv -> Tips;
        true ->
            MaxStage = data_pet_weapon_stage:max_stage(),
            PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
            BaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage),
            if
                PetWeapon#st_pet_weapon.stage >= MaxStage -> Tips;
                BaseData#base_pet_weapon_stage.cd > 0 -> Tips;
                true ->
                    case check_goods(Player, BaseData, 0, false) of
                        {false, _Err} -> Tips;
                        {true, _Player1} ->
                            Tips#tips{state = 1}
                    end
            end
    end.

%%今日是否有双倍
check_double(_Vip) -> false.

log_pet_weapon_stage(Pkey, NickName, NewStage, Stage, NewExp, Exp, Type) ->
    Sql = io_lib:format("insert into log_pet_weapon_stage set pkey=~p,nickname='~s',stage=~p,old_stage=~p,exp=~p,old_exp=~p,time=~p,`type`=~p",
        [Pkey, NickName, NewStage, Stage, NewExp, Exp, util:unixtime(), Type]),
    log_proc:log(Sql),
    ok.

%%增加经验
add_exp(PetWeapon, BaseData, Vip) ->
    IsDouble = check_double(Vip),
    Mult = ?IF_ELSE(IsDouble, 2, 1),
    Exp = util:rand(BaseData#base_pet_weapon_stage.exp_min, BaseData#base_pet_weapon_stage.exp_max) * Mult,
    %%经验满了,升阶
    if PetWeapon#st_pet_weapon.exp + Exp >= BaseData#base_pet_weapon_stage.exp ->
        NextBaseData = data_pet_weapon_stage:get(PetWeapon#st_pet_weapon.stage + 1),
        NewPetWeapon = PetWeapon#st_pet_weapon{exp = 0, stage = PetWeapon#st_pet_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_pet_weapon_stage.weapon_id, is_change = 1},
        pet_weapon_load:replace(NewPetWeapon),
        NewPetWeapon;
        true ->
            PetWeapon1 = set_bless_cd(PetWeapon, BaseData#base_pet_weapon_stage.cd),
            PetWeapon1#st_pet_weapon{exp = PetWeapon#st_pet_weapon.exp + Exp, is_change = 1}
    end.

%%检查物品是否足够
check_goods(Player, BaseData, IsAuto) ->
    check_goods(Player, BaseData, IsAuto, true).

check_goods(Player, BaseData, IsAuto, IsNotice) ->
    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_pet_weapon_stage.goods_ids)],
    Num = BaseData#base_pet_weapon_stage.num,
    Apet_weapon = lists:sum([Val || {_, Val} <- CountList]),
    if Apet_weapon >= Num ->
        if
            IsNotice == true ->
                DelGoodsList = goods_num(CountList, Num, []),
                goods:subtract_good(Player, DelGoodsList, 245);
            true ->
                ok
        end,
        {true, Player};
        Apet_weapon < Num andalso IsAuto == 1 ->
            case new_shop:get_goods_price(BaseData#base_pet_weapon_stage.gid_auto) of
                false -> {false, 4};
                {ok, Type, Price} ->
                    Money = Price * (Num - Apet_weapon),
                    case money:is_enough(Player, Money, Type) of
                        false -> {false, 5};
                        true ->
                            if
                                IsNotice == true ->
                                    DelGoodsList = goods_num(CountList, Num, []),
                                    goods:subtract_good(Player, DelGoodsList, 245),
                                    NewPlayer = money:cost_money(Player, Type, -Money, 245, BaseData#base_pet_weapon_stage.gid_auto, Num - Apet_weapon),
                                    {true, NewPlayer};
                                true ->
                                    {true, Player}
                            end
                    end
            end;
        true ->
            if
                IsNotice == true ->
                    goods_util:client_popup_goods_not_enough(Player, BaseData#base_pet_weapon_stage.gid_auto, Num, 245);
                true -> skip
            end,
            {false, 6}
    end.

goods_num([], _, GoodsList) -> GoodsList;
goods_num(_, 0, GoodsList) -> GoodsList;
goods_num([{Gid, Num} | T], NeedNum, GoodsList) ->
    if Num =< 0 -> goods_num(T, NeedNum, GoodsList);
        Num < NeedNum ->
            goods_num(T, NeedNum - Num, [{Gid, Num} | GoodsList]);
        true ->
            [{Gid, NeedNum} | GoodsList]
    end.


%%设置超时CD
set_bless_cd(PetWeapon, Cd) ->
    if PetWeapon#st_pet_weapon.bless_cd > 0 -> PetWeapon;
        PetWeapon#st_pet_weapon.exp > 0 -> PetWeapon;
        Cd > 0 ->
            PetWeapon#st_pet_weapon{bless_cd = Cd + util:unixtime()};
        true ->
            PetWeapon
    end.


%%祝福重置
bless_cd_reset(Player, Now) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    if PetWeapon#st_pet_weapon.bless_cd > 0 ->
        if PetWeapon#st_pet_weapon.bless_cd > Now ->
            Player;
            true ->
                mail_bless_reset(Player#player.key, PetWeapon#st_pet_weapon.stage),
                PetWeapon1 = PetWeapon#st_pet_weapon{bless_cd = 0, exp = 0, is_change = 1},
                NewPetWeapon = pet_weapon_init:calc_attribute(PetWeapon1),
                lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon),
                player_bless:refresh_bless(Player#player.sid, 5, 0),
                NewPlayer = player_util:count_player_attribute(Player, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
                log_pet_weapon_stage(Player#player.key, Player#player.nickname, NewPetWeapon#st_pet_weapon.stage, PetWeapon#st_pet_weapon.stage, NewPetWeapon#st_pet_weapon.exp, PetWeapon#st_pet_weapon.exp, 1),
                NewPlayer
        end;
        true -> Player
    end.

%%祝福经验清0通知
mail_bless_reset(Key, Lv) ->
    Content = io_lib:format(?T("您的~p级妖灵祝福时间到期,祝福值清零"), [Lv]),
    mail:sys_send_mail([Key], ?T("祝福清零"), Content),
    ok.

%%获取祝福状态
check_bless_state(Now) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    if PetWeapon#st_pet_weapon.bless_cd > Now -> [[5, PetWeapon#st_pet_weapon.bless_cd - Now]];
        true -> []
    end.


%%装备物品
equip_goods(Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {16, Player};
        Goods ->
            case data_goods:get(Goods#goods.goods_id) of
                [] -> {16, Player};
                GoodsType ->
                    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
                    if GoodsType#goods_type.need_lv > PetWeapon#st_pet_weapon.stage -> {17, Player};
                        true ->
                            SubtypeList = [?GOODS_SUBTYPE_EQUIP_PET_WEAPON_1, ?GOODS_SUBTYPE_EQUIP_PET_WEAPON_2, ?GOODS_SUBTYPE_EQUIP_PET_WEAPON_3, ?GOODS_SUBTYPE_EQUIP_PET_WEAPON_4],
                            case lists:member(GoodsType#goods_type.subtype, SubtypeList) of
                                false -> {18, Player};
                                true ->
                                    NeedGoods = Goods#goods{location = ?GOODS_LOCATION_PET_WEAPON, cell = GoodsType#goods_type.subtype, bind = ?BIND},

                                    GoodsDict = goods_dict:update_goods(NeedGoods, GoodsSt#st_goods.dict),
                                    goods_pack:pack_send_goods_info([NeedGoods], GoodsSt#st_goods.sid),

                                    EquipList =
                                        case lists:keytake(GoodsType#goods_type.subtype, 1, PetWeapon#st_pet_weapon.equip_list) of
                                            false ->
                                                _OldGoodsId = 0,
                                                NewGoodsSt = GoodsSt#st_goods{leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1, dict = GoodsDict},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | PetWeapon#st_pet_weapon.equip_list];
                                            {value, {_, _OldGoodsId, OldGoodsKey}, T} ->
                                                case catch goods_util:get_goods(OldGoodsKey, GoodsSt#st_goods.dict) of
                                                    {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
                                                        GoodsDict1 = GoodsDict;
                                                    GoodsOld ->
                                                        NewGoodsOld = GoodsOld#goods{location = ?GOODS_LOCATION_BAG, cell = 0},
                                                        goods_pack:pack_send_goods_info([NewGoodsOld], GoodsSt#st_goods.sid),
                                                        goods_load:dbup_goods_cell_location(NewGoodsOld),
                                                        GoodsDict1 = goods_dict:update_goods(NewGoodsOld, GoodsDict)
                                                end,
                                                NewGoodsSt = GoodsSt#st_goods{dict = GoodsDict1},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | T]
                                        end,
                                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                                    goods_load:dbup_goods_cell_location(NeedGoods),
                                    PetWeapon1 = PetWeapon#st_pet_weapon{equip_list = EquipList, is_change = 1},
                                    NewPetWeapon = pet_weapon_init:calc_attribute(PetWeapon1),
                                    lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_pet_weapon_equip(Player#player.key, Player#player.nickname, GoodsType#goods_type.subtype, _OldGoodsId, GoodsType#goods_type.goods_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

%% 检查是否有装备可以熔炼
get_equip_smelt_state() ->
    GoodsList = goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP10]),
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    F = fun(Goods) ->
        if
            Goods#goods.bind /= ?BIND -> false;
            true ->
                GoodsType = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, PetWeapon#st_pet_weapon.equip_list) of
                    false -> false;
                    {_Subtype, _GoodsId, GoodsKey} ->
                        if
                            GoodsKey == Goods#goods.key -> false;
                            true ->
                                WearGoods = goods_util:get_goods(GoodsKey),
                                if
                                    Goods#goods.combat_power > WearGoods#goods.combat_power -> false;
                                    true -> true
                                end
                        end
                end
        end
        end,
    case lists:any(F, GoodsList) of
        false -> 0;
        true -> 1
    end.

log_pet_weapon_equip(Pkey, Nickname, Subtype, OldGid, NewGid) ->
    Sql = io_lib:format("insert into log_pet_weapon_equip set pkey=~p,nickname='~s',subtype=~p,old_gid=~p,new_gid=~p,time=~p", [Pkey, Nickname, Subtype, OldGid, NewGid, util:unixtime()]),
    log_proc:log(Sql).


use_pet_weapon_dan(Player) ->
    case data_grow_dan:get(?GOODS_GROW_ID_PET_WEAPON) of
        [] -> {false, 0}; %% 配表错误
        Base ->
            PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),  %% 玩家神兵
            case lists:keyfind(PetWeapon#st_pet_weapon.stage, 1, Base#base_grow_dan.stage_max_num) of
                false ->
                    {false, 0};
                {_, MaxNum} ->
                    if
                        PetWeapon#st_pet_weapon.grow_num >= MaxNum ->
                            {false, 19}; %% 成长丹已达到使用上限
                        true ->
                            if
                                Base#base_grow_dan.step_lim > PetWeapon#st_pet_weapon.stage ->
                                    {false, 20};  %% 未达到使用阶级
                                true ->
                                    GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_PET_WEAPON),
                                    if
                                        GrowNum == 0 ->
                                            goods_util:client_popup_goods_not_enough(Player, Base#base_grow_dan.goods_id, 0, 241),
                                            {false, 21}; %% 成长丹不足
                                        true ->
                                            DeleteGrowNum = min(MaxNum - PetWeapon#st_pet_weapon.grow_num, GrowNum),
                                            goods:subtract_good(Player, [{?GOODS_GROW_ID_PET_WEAPON, DeleteGrowNum}], 241), %% 扣除成长丹
                                            NewPetWeapon0 = PetWeapon#st_pet_weapon{grow_num = PetWeapon#st_pet_weapon.grow_num + DeleteGrowNum, is_change = 1},
                                            NewPetWeapon1 = pet_weapon_init:calc_attribute(NewPetWeapon0),
                                            lib_dict:put(?PROC_STATUS_PET_WEAPON, NewPetWeapon1),
                                            NewPlayer = player_util:count_player_attribute(Player#player{pet_weaponid = NewPetWeapon1#st_pet_weapon.weapon_id}, true),
                                            scene_agent_dispatch:attribute_update(NewPlayer),
                                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1026, 0, DeleteGrowNum),
                                            {ok, NewPlayer}
                                    end
                            end
                    end
            end
    end.

check_use_pet_weapon_dan_state(_Player, Tips) ->
    case data_grow_dan:get(?GOODS_GROW_ID_PET_WEAPON) of
        Base ->
            PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),  %% 玩家神兵
            {_, MaxNum} = lists:keyfind(PetWeapon#st_pet_weapon.stage, 1, Base#base_grow_dan.stage_max_num),
            if
                PetWeapon#st_pet_weapon.grow_num >= MaxNum ->
                    Tips; %% 成长丹已达到使用上限
                true ->
                    if
                        Base#base_grow_dan.step_lim > PetWeapon#st_pet_weapon.stage ->
                            Tips;  %% 未达到使用阶级
                        true ->
                            GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_PET_WEAPON),
                            if
                                GrowNum == 0 ->
                                    Tips; %% 成长丹不足
                                true ->
                                    Tips#tips{state = 1}
                            end
                    end
            end
    end.

check_upgrade_jp_state(Player, Tips, GoodsType) ->
    if
        Player#player.lv < GoodsType#goods_type.need_lv ->
            Tips;
        true ->
            NewNum = case catch goods_attr_dan:use_goods_check(GoodsType#goods_type.goods_id, goods_util:get_goods_count(GoodsType#goods_type.goods_id), Player) of
                         N when is_integer(N) ->
                             N;
                         _Other ->
                             0
                     end,
            if
                NewNum > 0 ->
                    Tips#tips{state = 1};
                true ->
                    Tips
            end
    end.