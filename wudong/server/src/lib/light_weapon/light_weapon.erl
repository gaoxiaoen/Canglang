%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%     神兵
%%% @end
%%% Created : 26. 九月 2016 14:40
%%%-------------------------------------------------------------------
-module(light_weapon).
-author("hxming").

-include("light_weapon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("tips.hrl").
-include("activity.hrl").
-include("achieve.hrl").

%% API
-export([
    get_light_weapon_info/0,
    view_other/1,
    change_figure/2,
    upgrade_stage/2,
    bless_cd_reset/2,
    check_bless_state/1,
    mail_bless_reset/2,
    equip_goods/2,
    use_light_weapon_dan/1,
    check_upgrade_stage_state/2,
    check_use_light_weapon_dan_state/2,
    goods_add_stage/3,
    goods_add_stage_limit/3,
    goods_add_to_stage/3,
    get_equip_smelt_state/0,
    upgrade_star/2,
    log_light_weapon_stage/7,
    check_upgrade_star/0,
    have_light_weapon/1,
    activation_stage_lv/2
]).

%%获取法宝信息
get_light_weapon_info() ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    Now = util:unixtime(),
    Cd = max(0, LightWeapon#st_light_weapon.bless_cd - Now),
    SkillList =
        light_weapon_skill:get_light_weapon_skill_list(LightWeapon#st_light_weapon.skill_list),
    AttributeList = attribute_util:pack_attr(LightWeapon#st_light_weapon.attribute),
    EquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- LightWeapon#st_light_weapon.equip_list],
    SpiritState = light_weapon_spirit:check_spirit_state(LightWeapon),
    StarList = [tuple_to_list(Star) || Star <- LightWeapon#st_light_weapon.star_list],
    {LightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.exp, Cd, LightWeapon#st_light_weapon.weapon_id,
        LightWeapon#st_light_weapon.cbp, LightWeapon#st_light_weapon.grow_num, AttributeList, SkillList, EquipList,
        SpiritState, StarList}.

view_other(Pkey) ->
    Key = {light_weapon_view, Pkey},
    case cache:get(Key) of
        [] ->
            case light_weapon_load:load_view(Pkey) of
                [] -> {0, 0, [], [], [], 0, []};
            %%stage,cbp,attribute,skill_list,equip_list,grow_num,spirit_list
                [Stage, Cbp, AttributeList, SkillList, EquipList, GrowNum] ->
                    NewAttributeList = attribute_util:pack_attr(util:bitstring_to_term(AttributeList)),
                    NewSkillList = light_weapon_skill:get_light_weapon_skill_list(util:bitstring_to_term(SkillList)),
                    NewEquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- util:bitstring_to_term(EquipList)],
                    DanList = goods_attr_dan:get_dan_list_by_type(Pkey, ?GOODS_DAN_TYPE_LIGHT_WEAPON),
                    Data = {Stage, Cbp, NewAttributeList, NewSkillList, NewEquipList, GrowNum, DanList},
                    cache:set(Key, Data, ?FIFTEEN_MIN_SECONDS),
                    Data
            end;
        Data -> Data
    end.


%%幻化
change_figure(Player, FigureId) ->
    StLightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    case lists:keymember(FigureId, 1, StLightWeapon#st_light_weapon.own_special_image) of
        false -> {8, Player};
        true ->
            NewStLightWeapon = StLightWeapon#st_light_weapon{weapon_id = FigureId, is_change = 1},
            lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewStLightWeapon),
            {1, Player#player{light_weaponid = FigureId}}
    end.

%%物品增加1阶
goods_add_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    MaxStage = data_light_weapon_stage:max_stage(),
    if LightWeapon#st_light_weapon.stage >= MaxStage -> {Player, GoodsList};
        LightWeapon#st_light_weapon.stage >= Stage ->
            BaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage),
            NewExp = LightWeapon#st_light_weapon.exp + Exp,
            if NewExp >= BaseData#base_light_weapon_stage.exp ->
                NextBaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage + 1),
                ImageList = upgrade_image_list(NextBaseData#base_light_weapon_stage.weapon_id, LightWeapon#st_light_weapon.own_special_image),
                NewLightWeapon = LightWeapon#st_light_weapon{exp = 0, stage = LightWeapon#st_light_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_light_weapon_stage.weapon_id, is_change = 1, own_special_image = ImageList},
                NewLightWeapon1 = light_weapon_init:calc_attribute(NewLightWeapon),
                lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon1),
                NewPlayer = player_util:count_player_attribute(Player#player{light_weaponid = NewLightWeapon1#st_light_weapon.weapon_id}, true),
                scene_agent_dispatch:light_weapon_update(NewPlayer),
                log_light_weapon_stage(Player#player.key, Player#player.nickname, NewLightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, NewLightWeapon#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_light_weapon_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1016, 0, NewLightWeapon#st_light_weapon.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_light_weapon_stage.award));
                true ->
                    LightWeapon1 = set_bless_cd(LightWeapon, BaseData#base_light_weapon_stage.cd),
                    NewLightWeapon = LightWeapon1#st_light_weapon{exp = LightWeapon#st_light_weapon.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon),
                    log_light_weapon_stage(Player#player.key, Player#player.nickname, NewLightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, NewLightWeapon#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage + 1),
            ImageList = upgrade_image_list(NextBaseData#base_light_weapon_stage.weapon_id, LightWeapon#st_light_weapon.own_special_image),
            NewLightWeapon = LightWeapon#st_light_weapon{exp = 0, stage = LightWeapon#st_light_weapon.stage + 1, own_special_image = ImageList, bless_cd = 0, weapon_id = NextBaseData#base_light_weapon_stage.weapon_id, is_change = 1},
            NewLightWeapon1 = light_weapon_init:calc_attribute(NewLightWeapon),
            notice_sys:add_notice(player_view, [Player, 4, NewLightWeapon1#st_light_weapon.stage]),
            lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon1),
            NewPlayer = player_util:count_player_attribute(Player#player{light_weaponid = NewLightWeapon1#st_light_weapon.weapon_id}, true),
            scene_agent_dispatch:light_weapon_update(NewPlayer),
            BaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_light_weapon_stage.award))),
            log_light_weapon_stage(Player#player.key, Player#player.nickname, NewLightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, NewLightWeapon#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1016, 0, NewLightWeapon#st_light_weapon.stage),
            goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_light_weapon_stage.award))
    end.

%%使用物品增加到指定阶数 1 3
goods_add_to_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_to_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    MaxStage = data_light_weapon_stage:max_stage(),
    if LightWeapon#st_light_weapon.stage >= MaxStage -> {Player, GoodsList};
        LightWeapon#st_light_weapon.stage >= Stage ->
            BaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage),
            NewExp = LightWeapon#st_light_weapon.exp + Exp,
            if NewExp >= BaseData#base_light_weapon_stage.exp ->
                NextBaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage + 1),
                ImageList = upgrade_image_list(NextBaseData#base_light_weapon_stage.weapon_id, LightWeapon#st_light_weapon.own_special_image),
                NewLightWeapon = LightWeapon#st_light_weapon{exp = 0, stage = LightWeapon#st_light_weapon.stage + 1, own_special_image = ImageList, bless_cd = 0, weapon_id = NextBaseData#base_light_weapon_stage.weapon_id, is_change = 1},
                NewLightWeapon1 = light_weapon_init:calc_attribute(NewLightWeapon),
                lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon1),
                NewPlayer = player_util:count_player_attribute(Player#player{light_weaponid = NewLightWeapon1#st_light_weapon.weapon_id}, true),
                scene_agent_dispatch:light_weapon_update(NewPlayer),
                log_light_weapon_stage(Player#player.key, Player#player.nickname, NewLightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, NewLightWeapon#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_light_weapon_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1016, 0, NewLightWeapon#st_light_weapon.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_light_weapon_stage.award));
                true ->
                    LightWeapon1 = set_bless_cd(LightWeapon, BaseData#base_light_weapon_stage.cd),
                    NewLightWeapon = LightWeapon1#st_light_weapon{exp = LightWeapon#st_light_weapon.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon),
                    log_light_weapon_stage(Player#player.key, Player#player.nickname, NewLightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, NewLightWeapon#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            F = fun(_, {M, GList}) ->
                NextBaseData = data_light_weapon_stage:get(M#st_light_weapon.stage + 1),
                ImageList = upgrade_image_list(NextBaseData#base_light_weapon_stage.weapon_id, M#st_light_weapon.own_special_image),
                NewM = M#st_light_weapon{exp = 0, stage = M#st_light_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_light_weapon_stage.weapon_id, own_special_image = ImageList, is_change = 1},
                BaseData = data_light_weapon_stage:get(M#st_light_weapon.stage),
                {NewM, GList ++ tuple_to_list(BaseData#base_light_weapon_stage.award)}
            end,
            {NewLightWeapon, GoodsList1} = lists:foldl(F, {LightWeapon, []}, lists:seq(LightWeapon#st_light_weapon.stage, Stage - 1)),

            NewLightWeapon1 = light_weapon_init:calc_attribute(NewLightWeapon),
            notice_sys:add_notice(player_view, [Player, 4, NewLightWeapon1#st_light_weapon.stage]),
            lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon1),
            NewPlayer = player_util:count_player_attribute(Player#player{light_weaponid = NewLightWeapon1#st_light_weapon.weapon_id}, true),
            scene_agent_dispatch:light_weapon_update(NewPlayer),
            log_light_weapon_stage(Player#player.key, Player#player.nickname, NewLightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, NewLightWeapon#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 0),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, goods:merge_goods(GoodsList))),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1016, 0, NewLightWeapon#st_light_weapon.stage),
            goods_add_to_stage(NewPlayer, T, GoodsList ++ GoodsList1)
    end.


%%物品增加1阶 特定等级
goods_add_stage_limit(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage_limit(Player, [{Stage, Exp} | T], GoodsList) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    MaxStage = data_light_weapon_stage:max_stage(),
    if LightWeapon#st_light_weapon.stage >= MaxStage -> {Player, GoodsList};
        LightWeapon#st_light_weapon.stage > Stage ->
            BaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage),
            NewExp = LightWeapon#st_light_weapon.exp + Exp,
            if NewExp >= BaseData#base_light_weapon_stage.exp ->
                NextBaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage + 1),
                ImageList = upgrade_image_list(NextBaseData#base_light_weapon_stage.weapon_id, LightWeapon#st_light_weapon.own_special_image),
                NewLightWeapon = LightWeapon#st_light_weapon{exp = 0, stage = LightWeapon#st_light_weapon.stage + 1, own_special_image = ImageList, bless_cd = 0, weapon_id = NextBaseData#base_light_weapon_stage.weapon_id, is_change = 1},
                NewLightWeapon1 = light_weapon_init:calc_attribute(NewLightWeapon),
                lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon1),
                NewPlayer = player_util:count_player_attribute(Player#player{light_weaponid = NewLightWeapon1#st_light_weapon.weapon_id}, true),
                scene_agent_dispatch:light_weapon_update(NewPlayer),
                log_light_weapon_stage(Player#player.key, Player#player.nickname, NewLightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, NewLightWeapon#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_light_weapon_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1016, 0, NewLightWeapon#st_light_weapon.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_light_weapon_stage.award));
                true ->
                    LightWeapon1 = set_bless_cd(LightWeapon, BaseData#base_light_weapon_stage.cd),
                    NewLightWeapon = LightWeapon1#st_light_weapon{exp = LightWeapon#st_light_weapon.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon),
                    log_light_weapon_stage(Player#player.key, Player#player.nickname, NewLightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, NewLightWeapon#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage + 1),
            ImageList = upgrade_image_list(NextBaseData#base_light_weapon_stage.weapon_id, LightWeapon#st_light_weapon.own_special_image),
            NewLightWeapon = LightWeapon#st_light_weapon{exp = 0, stage = LightWeapon#st_light_weapon.stage + 1, own_special_image = ImageList, bless_cd = 0, weapon_id = NextBaseData#base_light_weapon_stage.weapon_id, is_change = 1},
            NewLightWeapon1 = light_weapon_init:calc_attribute(NewLightWeapon),
            notice_sys:add_notice(player_view, [Player, 4, NewLightWeapon1#st_light_weapon.stage]),
            lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon1),
            NewPlayer = player_util:count_player_attribute(Player#player{light_weaponid = NewLightWeapon1#st_light_weapon.weapon_id}, true),
            scene_agent_dispatch:light_weapon_update(NewPlayer),
            BaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_light_weapon_stage.award))),
            log_light_weapon_stage(Player#player.key, Player#player.nickname, NewLightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, NewLightWeapon#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1016, 0, NewLightWeapon#st_light_weapon.stage),
            goods_add_stage_limit(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_light_weapon_stage.award))
    end.

%%升阶
upgrade_stage(Player, IsAuto) ->
    OpenLv = ?LIGHT_WEAPON_OPEN_LV,
    if Player#player.lv < OpenLv -> {false, 2};
        true ->
            MaxStage = data_light_weapon_stage:max_stage(),
            LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
            if LightWeapon#st_light_weapon.stage >= MaxStage -> {false, 3};
                LightWeapon#st_light_weapon.stage == 0 -> {false, 0};
                true ->
                    BaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage),
                    case check_goods(Player, BaseData, IsAuto) of
                        {false, Err} -> {false, Err};
                        {true, Player1} ->
                            LightWeapon1 = add_exp(LightWeapon, BaseData, Player#player.vip_lv),
                            log_light_weapon_stage(Player#player.key, Player#player.nickname, LightWeapon1#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, LightWeapon1#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 0),
                            OldExpPercent = util:floor(LightWeapon#st_light_weapon.exp / BaseData#base_light_weapon_stage.exp * 100),
                            NewExpPercent = util:floor(LightWeapon1#st_light_weapon.exp / BaseData#base_light_weapon_stage.exp * 100),
                            if
                                LightWeapon1#st_light_weapon.stage /= LightWeapon#st_light_weapon.stage ->
                                    NewLightWeapon = light_weapon_init:calc_attribute(LightWeapon1),
                                    lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon),
                                    NewPlayer = player_util:count_player_attribute(Player1#player{light_weaponid = LightWeapon1#st_light_weapon.weapon_id}, true),
                                    scene_agent_dispatch:attribute_update(NewPlayer),
                                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(225, tuple_to_list(BaseData#base_light_weapon_stage.award))),
                                    open_act_all_target:act_target(Player#player.key, ?OPEN_All_TARGET_LIGHT_WEAPON, NewLightWeapon#st_light_weapon.stage),
                                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1016, 0, NewLightWeapon#st_light_weapon.stage),
                                    notice_sys:add_notice(player_view, [Player, 4, LightWeapon1#st_light_weapon.stage]),
                                    activity:get_notice(Player, [33, 46], true),
                                    {ok, 7, NewPlayer1};
                                OldExpPercent /= NewExpPercent ->
                                    NewLightWeapon = light_weapon_init:calc_attribute(LightWeapon1),
                                    lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon),
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:attribute_update(NewPlayer),
                                    {ok, 1, NewPlayer};
                                true ->
                                    lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, LightWeapon1),
                                    {ok, 1, Player1}
                            end
                    end
            end
    end.

%%升阶
check_upgrade_stage_state(Player, Tips) ->
    OpenLv = ?LIGHT_WEAPON_OPEN_LV,
    if Player#player.lv < OpenLv -> Tips;
        true ->
            MaxStage = data_light_weapon_stage:max_stage(),
            LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
            if LightWeapon#st_light_weapon.stage >= MaxStage -> Tips;
                true ->
                    BaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage),
                    if
                        BaseData#base_light_weapon_stage.cd < 1 ->
                            case check_goods(Player, BaseData, 0, false) of
                                {false, _Err} -> Tips;
                                {true, _Player1} ->
                                    Tips#tips{state = 1}
                            end;
                        true ->
                            Tips
                    end
            end
    end.

log_light_weapon_stage(Pkey, NickName, NewStage, Stage, NewExp, Exp, Type) ->
    Sql = io_lib:format("insert into log_light_weapon_stage set pkey=~p,nickname='~s',stage=~p,old_stage=~p,exp=~p,old_exp=~p,time=~p,`type`=~p",
        [Pkey, NickName, NewStage, Stage, NewExp, Exp, util:unixtime(), Type]),
    log_proc:log(Sql),
    ok.

%%今日是否有双倍
check_double(_Vip) -> false.


%%增加经验
add_exp(LightWeapon, BaseData, Vip) ->
    IsDouble = check_double(Vip),
    Mult = ?IF_ELSE(IsDouble, 2, 1),
    Exp = util:rand(BaseData#base_light_weapon_stage.exp_min, BaseData#base_light_weapon_stage.exp_max) * Mult,
    %%经验满了,升阶
    if LightWeapon#st_light_weapon.exp + Exp >= BaseData#base_light_weapon_stage.exp ->
        NextBaseData = data_light_weapon_stage:get(LightWeapon#st_light_weapon.stage + 1),
        ImageList = upgrade_image_list(NextBaseData#base_light_weapon_stage.weapon_id, LightWeapon#st_light_weapon.own_special_image),
        NewLightWeapon = LightWeapon#st_light_weapon{exp = 0, stage = LightWeapon#st_light_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_light_weapon_stage.weapon_id, own_special_image = ImageList, is_change = 1},
        light_weapon_load:replace(NewLightWeapon),
        NewLightWeapon;
        true ->
            LightWeapon1 = set_bless_cd(LightWeapon, BaseData#base_light_weapon_stage.cd),
            LightWeapon1#st_light_weapon{exp = LightWeapon#st_light_weapon.exp + Exp, is_change = 1}
    end.


upgrade_image_list(WeaponId, ImageList) ->
    case lists:keytake(WeaponId, 1, ImageList) of
        false ->
            [{WeaponId, 0} | ImageList];
        {value, _, OL} ->
            [{WeaponId, 0} | OL]
    end.

%%检查物品是否足够
check_goods(Player, BaseData, IsAuto) ->
    check_goods(Player, BaseData, IsAuto, true).

check_goods(Player, BaseData, IsAuto, IsNotice) ->
    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_light_weapon_stage.goods_ids)],
    Num = BaseData#base_light_weapon_stage.num,
    Alight_weapon = lists:sum([Val || {_, Val} <- CountList]),
    if Alight_weapon >= Num ->
        if
            IsNotice == true ->
                DelGoodsList = goods_num(CountList, Num, []),
                goods:subtract_good(Player, DelGoodsList, 244);
            true ->
                ok
        end,
        {true, Player};
        Alight_weapon < Num andalso IsAuto == 1 ->
            case new_shop:get_goods_price(BaseData#base_light_weapon_stage.gid_auto) of
                false -> {false, 4};
                {ok, Type, Price} ->
                    Money = Price * (Num - Alight_weapon),
                    case money:is_enough(Player, Money, Type) of
                        false -> {false, 5};
                        true ->
                            if
                                IsNotice == true ->
                                    DelGoodsList = goods_num(CountList, Num, []),
                                    goods:subtract_good(Player, DelGoodsList, 244),
                                    NewPlayer = money:cost_money(Player, Type, -Money, 244, BaseData#base_light_weapon_stage.gid_auto, Num - Alight_weapon),
                                    {true, NewPlayer};
                                true ->
                                    {true, Player}
                            end
                    end
            end;
        true ->
            if
                IsNotice == true ->
                    goods_util:client_popup_goods_not_enough(Player, BaseData#base_light_weapon_stage.gid_auto, Num, 244);
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
set_bless_cd(LightWeapon, Cd) ->
    if LightWeapon#st_light_weapon.bless_cd > 0 -> LightWeapon;
        LightWeapon#st_light_weapon.exp > 0 -> LightWeapon;
        Cd > 0 ->
            LightWeapon#st_light_weapon{bless_cd = Cd + util:unixtime()};
        true ->
            LightWeapon
    end.


%%祝福重置
bless_cd_reset(Player, Now) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    if LightWeapon#st_light_weapon.bless_cd > 0 ->
        if LightWeapon#st_light_weapon.bless_cd > Now ->
            Player;
            true ->
                mail_bless_reset(Player#player.key, LightWeapon#st_light_weapon.stage),
                LightWeapon1 = LightWeapon#st_light_weapon{bless_cd = 0, exp = 0, is_change = 1},
                NewLightWeapon = light_weapon_init:calc_attribute(LightWeapon1),
                lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon),
                player_bless:refresh_bless(Player#player.sid, 4, 0),
                NewPlayer = player_util:count_player_attribute(Player, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
                log_light_weapon_stage(Player#player.key, Player#player.nickname, NewLightWeapon#st_light_weapon.stage, LightWeapon#st_light_weapon.stage, NewLightWeapon#st_light_weapon.exp, LightWeapon#st_light_weapon.exp, 1),
                NewPlayer
        end;
        true -> Player
    end.

%%祝福经验清0通知
mail_bless_reset(Key, Lv) ->
    Content = io_lib:format(?T("您的~p级神兵祝福时间到期,祝福值清零"), [Lv]),
    mail:sys_send_mail([Key], ?T("祝福清零"), Content),
    ok.

%%获取祝福状态
check_bless_state(Now) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    if LightWeapon#st_light_weapon.bless_cd > Now -> [[4, LightWeapon#st_light_weapon.bless_cd - Now]];
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
                    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
                    if GoodsType#goods_type.need_lv > LightWeapon#st_light_weapon.stage -> {17, Player};
                        true ->
                            SubtypeList = [?GOODS_SUBTYPE_EQUIP_LIGHT_WEAPON_1, ?GOODS_SUBTYPE_EQUIP_LIGHT_WEAPON_2, ?GOODS_SUBTYPE_EQUIP_LIGHT_WEAPON_3, ?GOODS_SUBTYPE_EQUIP_LIGHT_WEAPON_4],
                            case lists:member(GoodsType#goods_type.subtype, SubtypeList) of
                                false -> {18, Player};
                                true ->
                                    NeedGoods = Goods#goods{location = ?GOODS_LOCATION_LIGHT_WEAPON, cell = GoodsType#goods_type.subtype, bind = ?BIND},

                                    GoodsDict = goods_dict:update_goods(NeedGoods, GoodsSt#st_goods.dict),
                                    goods_pack:pack_send_goods_info([NeedGoods], GoodsSt#st_goods.sid),

                                    EquipList =
                                        case lists:keytake(GoodsType#goods_type.subtype, 1, LightWeapon#st_light_weapon.equip_list) of
                                            false ->
                                                _OldGoodsId = 0,
                                                NewGoodsSt = GoodsSt#st_goods{leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1, dict = GoodsDict},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | LightWeapon#st_light_weapon.equip_list];
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
                                    LightWeapon1 = LightWeapon#st_light_weapon{equip_list = EquipList, is_change = 1},
                                    NewLightWeapon = light_weapon_init:calc_attribute(LightWeapon1),
                                    lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_light_weapon_equip(Player#player.key, Player#player.nickname, GoodsType#goods_type.subtype, _OldGoodsId, Goods#goods.goods_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.


have_light_weapon(WeaponId) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    case lists:keyfind(WeaponId, 1, LightWeapon#st_light_weapon.star_list) of
        false -> {false, 0};
        {_, Lv} -> {true, Lv}
    end.


%% 检查是否有装备可以熔炼
get_equip_smelt_state() ->
    GoodsList = goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP10]),
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    F = fun(Goods) ->
        if
            Goods#goods.bind /= ?BIND -> false;
            true ->
                GoodsType = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, LightWeapon#st_light_weapon.equip_list) of
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

log_light_weapon_equip(Pkey, Nickname, Subtype, OldGid, NewGid) ->
    Sql = io_lib:format("insert into log_light_weapon_equip set pkey=~p,nickname='~s',subtype=~p,old_gid=~p,new_gid=~p,time=~p", [Pkey, Nickname, Subtype, OldGid, NewGid, util:unixtime()]),
    log_proc:log(Sql).

use_light_weapon_dan(Player) ->
    case data_grow_dan:get(?GOODS_GROW_ID_LIGHT_WEAPON) of
        [] -> {false, 0}; %% 配表错误
        Base ->
            LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),  %% 玩家神兵
            case lists:keyfind(LightWeapon#st_light_weapon.stage, 1, Base#base_grow_dan.stage_max_num) of
                false -> {false, 0};
                {_, MaxNum} ->
                    if
                        LightWeapon#st_light_weapon.grow_num >= MaxNum ->
                            {false, 19}; %% 成长丹已达到使用上限
                        true ->
                            if
                                Base#base_grow_dan.step_lim > LightWeapon#st_light_weapon.stage ->
                                    {false, 20};  %% 未达到使用阶级
                                true ->
                                    GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_LIGHT_WEAPON),
                                    if
                                        GrowNum == 0 ->
                                            goods_util:client_popup_goods_not_enough(Player, Base#base_grow_dan.goods_id, 0, 228),
                                            {false, 21}; %% 成长丹不足
                                        true ->
                                            DeleteGrowNum = min(MaxNum - LightWeapon#st_light_weapon.grow_num, GrowNum),
                                            goods:subtract_good(Player, [{?GOODS_GROW_ID_LIGHT_WEAPON, DeleteGrowNum}], 228), %% 扣除成长丹
                                            NewLightWeapon0 = LightWeapon#st_light_weapon{grow_num = LightWeapon#st_light_weapon.grow_num + DeleteGrowNum, is_change = 1},
                                            NewLightWeapon1 = light_weapon_init:calc_attribute(NewLightWeapon0),
                                            lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon1),
                                            NewPlayer = player_util:count_player_attribute(Player#player{light_weaponid = NewLightWeapon1#st_light_weapon.weapon_id}, true),
                                            scene_agent_dispatch:attribute_update(NewPlayer),
                                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1017, 0, DeleteGrowNum),
                                            {ok, NewPlayer}
                                    end
                            end
                    end
            end
    end.

check_use_light_weapon_dan_state(_Player, Tips) ->
    case data_grow_dan:get(?GOODS_GROW_ID_LIGHT_WEAPON) of
        [] -> Tips; %% 配表错误
        Base ->
            LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),  %% 玩家神兵
            {_, MaxNum} = lists:keyfind(LightWeapon#st_light_weapon.stage, 1, Base#base_grow_dan.stage_max_num),
            if
                LightWeapon#st_light_weapon.grow_num >= MaxNum ->
                    Tips; %% 成长丹已达到使用上限
                true ->
                    if
                        Base#base_grow_dan.step_lim > LightWeapon#st_light_weapon.stage ->
                            Tips;  %% 未达到使用阶级
                        true ->
                            GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_LIGHT_WEAPON),
                            if
                                GrowNum == 0 ->
                                    Tips; %% 成长丹不足
                                true ->
                                    Tips#tips{state = 1}
                            end
                    end
            end
    end.

check_upgrade_star() ->
    F = fun(WeaponId) ->
        LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
        {Star, _NewStarList} =
            case lists:keytake(WeaponId, 1, LightWeapon#st_light_weapon.star_list) of
                {value, {_, OldStar}, L} ->
                    {OldStar, [{WeaponId, OldStar + 1} | L]};
                _ ->
                    {0, [{WeaponId, 1} | LightWeapon#st_light_weapon.star_list]}
            end,
        case data_light_weapon_star:get(WeaponId, Star + 1) of
            [] -> [];
            BaseData ->
                case BaseData#base_light_weapon_star.need_goods of
                    [] -> [];
                    [{GoodsId, Num} | _] ->
                        GoodsCount = goods_util:get_goods_count(GoodsId),
                        if GoodsCount < Num -> [];
                            true ->
                                [1]
                        end
                end
        end
    end,
    LL = lists:flatmap(F, data_light_weapon_star:weapon_list()),

    F0 = fun(LightWeaponId) ->
        LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
        case lists:keyfind(LightWeaponId, 1, LightWeapon#st_light_weapon.star_list) of
            false ->
                [];
            {LightWeaponId, Stage} ->
                StageList = get_stage_list(LightWeaponId, Stage),
                case lists:keytake(LightWeaponId, 1, LightWeapon#st_light_weapon.activation_list) of
                    {value, {LightWeaponId, ActList}, _T} ->
                        NewActivationList = StageList -- ActList,
                        if
                            NewActivationList == [] ->
                                [];
                            true ->
                               [1]
                        end;
                    false ->
                        if
                            StageList == [] ->
                               [];
                            true ->
                               [1]
                        end
                end
        end
    end,
    LL1 = lists:flatmap(F0, data_light_weapon_star:weapon_list()),
    ?IF_ELSE(LL ++ LL1 == [], 0, 1).

%%升星
upgrade_star(Player, WeaponId) ->
    case lists:member(WeaponId, data_light_weapon_star:weapon_list()) of
        false -> {false, 23};
        true ->
            LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
            {Star, NewStarList} =
                case lists:keytake(WeaponId, 1, LightWeapon#st_light_weapon.star_list) of
                    {value, {_, OldStar}, L} ->
                        {OldStar, [{WeaponId, OldStar + 1} | L]};
                    _ ->
                        {0, [{WeaponId, 1} | LightWeapon#st_light_weapon.star_list]}
                end,
            case data_light_weapon_star:get(WeaponId, Star + 1) of
                [] -> {false, 24};
                BaseData ->
                    case BaseData#base_light_weapon_star.need_goods of
                        [] -> {false, 25};
                        [{GoodsId, Num} | _] ->
                            GoodsCount = goods_util:get_goods_count(GoodsId),
                            if GoodsCount < Num -> {false, 26};
                                true ->
                                    goods:subtract_good_throw(Player, [{GoodsId, Num}], 151),
                                    OwnSpecialImage = [{WeaponId, 0} | lists:keydelete(WeaponId, 1, LightWeapon#st_light_weapon.own_special_image)],
                                    NewLightWeapon = LightWeapon#st_light_weapon{star_list = NewStarList, own_special_image = OwnSpecialImage, is_change = 1},
                                    NewLightWeapon1 = light_weapon_init:calc_attribute(NewLightWeapon),
                                    lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon1),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_light_weapon_star(Player#player.key, Player#player.nickname, WeaponId, Star + 1),
                                    {ok, NewPlayer}
                            end
                    end
            end
    end.

log_light_weapon_star(Pkey, Nickname, MountId, Star) ->
    Sql = io_lib:format("insert into log_light_weapon_star set pkey=~p,nickname='~s',mount_id=~p,star=~p,time=~p",
        [Pkey, Nickname, MountId, Star, util:unixtime()]),
    log_proc:log(Sql).



activation_stage_lv(Player, LightWeaponId) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    ?DEBUG("LightWeaponId ~p~n", [LightWeaponId]),
    ?DEBUG(" LightWeapon#st_light_weapon.star_list ~p~n", [LightWeapon#st_light_weapon.star_list]),
    case lists:keyfind(LightWeaponId, 1, LightWeapon#st_light_weapon.star_list) of
        false ->
            {8, Player};
        {LightWeaponId, Stage} ->
            StageList = get_stage_list(LightWeaponId, Stage),
            case lists:keytake(LightWeaponId, 1, LightWeapon#st_light_weapon.activation_list) of
                {value, {LightWeaponId, ActList}, T} ->
                    NewActivationList = StageList -- ActList,
                    if
                        NewActivationList == [] -> ?DEBUG("222~n"),
                            {28, Player};
                        true ->
                            LightWeapon1 = LightWeapon#st_light_weapon{activation_list = [{LightWeaponId, NewActivationList ++ ActList} | T], is_change = 1},
                            NewLightWeapon1 = light_weapon_init:calc_attribute(LightWeapon1),
                            lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon1),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            {1, NewPlayer}
                    end;
                false ->
                    if
                        StageList == [] ->
                            ?DEBUG("111~n"),
                            {28, Player};
                        true ->
                            LightWeapon1 = LightWeapon#st_light_weapon{activation_list = [{LightWeaponId, StageList} | LightWeapon#st_light_weapon.activation_list], is_change = 1},
                            NewLightWeapon1 = light_weapon_init:calc_attribute(LightWeapon1),
                            lib_dict:put(?PROC_STATUS_LIGHT_WEAPON, NewLightWeapon1),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            {1, NewPlayer}
                    end
            end
    end.

get_stage_list(Id, Stage) ->
    F = fun(Stage0, List) ->
        case data_light_weapon_star:get(Id, Stage0) of
            [] -> List;
            #base_light_weapon_star{lv_attr = LvAttr} ->
                if
                    LvAttr == [] -> List;
                    true -> [Stage0 | List]
                end
        end
    end,
    lists:foldl(F, [], lists:seq(1, Stage)).
