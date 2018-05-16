%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%     法器
%%% @end
%%% Created : 26. 九月 2016 14:40
%%%-------------------------------------------------------------------
-module(magic_weapon).
-author("hxming").

-include("magic_weapon.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("tips.hrl").
-include("activity.hrl").
-include("achieve.hrl").

%% API
-export([
    get_magic_weapon_info/0,
    view_other/1,
    change_figure/2,
    upgrade_stage/2,
    bless_cd_reset/2,
    check_bless_state/1,
    mail_bless_reset/2,
    equip_goods/2,
    use_magic_weapon_dan/1,
    check_use_magic_weapon_dan_state/2,
    check_upgrade_stage_state/2,
    goods_add_stage/3,
    goods_add_stage_limit/3,
    goods_add_to_stage/3,

    get_equip_smelt_state/0,
    log_magic_weapon_stage/7
]).

%%获取法宝信息
get_magic_weapon_info() ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    Now = util:unixtime(),
    Cd = max(0, MagicWeapon#st_magic_weapon.bless_cd - Now),
    SkillList =
        magic_weapon_skill:get_magic_weapon_skill_list(MagicWeapon#st_magic_weapon.skill_list),
    AttributeList = attribute_util:pack_attr(MagicWeapon#st_magic_weapon.attribute),
    EquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- MagicWeapon#st_magic_weapon.equip_list],
    SpiritState = magic_weapon_spirit:check_spirit_state(MagicWeapon),
    {MagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.exp, Cd, MagicWeapon#st_magic_weapon.weapon_id,
        MagicWeapon#st_magic_weapon.cbp, MagicWeapon#st_magic_weapon.grow_num, AttributeList, SkillList, EquipList, SpiritState}.

view_other(Pkey) ->
    Key = {magic_weapon_view, Pkey},
    case cache:get(Key) of
        [] ->
            case magic_weapon_load:load_view(Pkey) of
                [] -> {0, 0, [], [], [], 0, []};
                %%stage,cbp,attribute,skill_list,equip_list,grow_num,spirit_list
                [Stage, Cbp, AttributeList, SkillList, EquipList, GrowNum] ->
                    NewAttributeList = attribute_util:pack_attr(util:bitstring_to_term(AttributeList)),
                    NewSkillList = magic_weapon_skill:get_magic_weapon_skill_list(util:bitstring_to_term(SkillList)),
                    NewEquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- util:bitstring_to_term(EquipList)],
                    DanList = goods_attr_dan:get_dan_list_by_type(Pkey, ?GOODS_DAN_TYPE_MAGIC_WEAPON),
                    Data = {Stage, Cbp, NewAttributeList, NewSkillList, NewEquipList, GrowNum, DanList},
                    cache:set(Key, Data, ?FIFTEEN_MIN_SECONDS),
                    Data
            end;
        Data -> Data
    end.


%%幻化
change_figure(Player, FigureId) ->
    StMagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    case data_magic_weapon_stage:figure2stage(FigureId) of
        [] -> {8, Player};
        Stage ->
            if StMagicWeapon#st_magic_weapon.stage < Stage -> {9, Player};
                true ->
                    NewStMagicWeapon = StMagicWeapon#st_magic_weapon{weapon_id = FigureId, is_change = 1},
                    lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewStMagicWeapon),
                    NewPlayer = Player#player{magic_weapon_id = FigureId},
                    scene_agent_dispatch:magic_weapon_id(NewPlayer),
                    {1, NewPlayer}
            end
    end.

%%物品增加1阶
goods_add_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    MaxStage = data_magic_weapon_stage:max_stage(),
    if MagicWeapon#st_magic_weapon.stage >= MaxStage -> {Player, GoodsList};
        MagicWeapon#st_magic_weapon.stage >= Stage ->
            BaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage),
            NewExp = MagicWeapon#st_magic_weapon.exp + Exp,
            if NewExp >= BaseData#base_magic_weapon_stage.exp ->
                NextBaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage + 1),
                NewMagicWeapon = MagicWeapon#st_magic_weapon{exp = 0, stage = MagicWeapon#st_magic_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_magic_weapon_stage.weapon_id, is_change = 1},
                NewMagicWeapon1 = magic_weapon_init:calc_attribute(NewMagicWeapon),
                lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon1),
                NewPlayer = player_util:count_player_attribute(Player#player{magic_weapon_id = NewMagicWeapon1#st_magic_weapon.weapon_id}, true),
                scene_agent_dispatch:magic_weapon_id(NewPlayer),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1022, 0, NewMagicWeapon#st_magic_weapon.stage),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(224, tuple_to_list(BaseData#base_magic_weapon_stage.award))),
                log_magic_weapon_stage(Player#player.key, Player#player.nickname, NewMagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, NewMagicWeapon#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 0),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_magic_weapon_stage.award));
                true ->
                    MagicWeapon1 = set_bless_cd(MagicWeapon, BaseData#base_magic_weapon_stage.cd),
                    NewMagicWeapon = MagicWeapon1#st_magic_weapon{exp = MagicWeapon#st_magic_weapon.exp + Exp, is_change = 1},
                    log_magic_weapon_stage(Player#player.key, Player#player.nickname, NewMagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, NewMagicWeapon#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 0),
                    lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage + 1),
            NewMagicWeapon = MagicWeapon#st_magic_weapon{exp = 0, stage = MagicWeapon#st_magic_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_magic_weapon_stage.weapon_id, is_change = 1},
            NewMagicWeapon1 = magic_weapon_init:calc_attribute(NewMagicWeapon),
            notice_sys:add_notice(player_view, [Player, 3, NewMagicWeapon1#st_magic_weapon.stage]),
            lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon1),
            NewPlayer = player_util:count_player_attribute(Player#player{magic_weapon_id = NewMagicWeapon1#st_magic_weapon.weapon_id}, true),
            scene_agent_dispatch:magic_weapon_id(NewPlayer),
            BaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(224, tuple_to_list(BaseData#base_magic_weapon_stage.award))),
            log_magic_weapon_stage(Player#player.key, Player#player.nickname, NewMagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, NewMagicWeapon#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1022, 0, NewMagicWeapon#st_magic_weapon.stage),
            goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_magic_weapon_stage.award))
    end.

%%使用物品增加到指定阶数 1 3
goods_add_to_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_to_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),

    MaxStage = data_magic_weapon_stage:max_stage(),
    if MagicWeapon#st_magic_weapon.stage >= MaxStage -> {Player, GoodsList};
        MagicWeapon#st_magic_weapon.stage >= Stage ->
            BaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage),
            NewExp = MagicWeapon#st_magic_weapon.exp + Exp,
            if NewExp >= BaseData#base_magic_weapon_stage.exp ->
                NextBaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage + 1),
                NewMagicWeapon = MagicWeapon#st_magic_weapon{exp = 0, stage = MagicWeapon#st_magic_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_magic_weapon_stage.weapon_id, is_change = 1},
                NewMagicWeapon1 = magic_weapon_init:calc_attribute(NewMagicWeapon),
                lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon1),
                NewPlayer = player_util:count_player_attribute(Player#player{magic_weapon_id = NewMagicWeapon1#st_magic_weapon.weapon_id}, true),
                scene_agent_dispatch:magic_weapon_id(NewPlayer),
                log_magic_weapon_stage(Player#player.key, Player#player.nickname, NewMagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, NewMagicWeapon#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(224, tuple_to_list(BaseData#base_magic_weapon_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1022, 0, NewMagicWeapon#st_magic_weapon.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_magic_weapon_stage.award));
                true ->
                    MagicWeapon1 = set_bless_cd(MagicWeapon, BaseData#base_magic_weapon_stage.cd),
                    NewMagicWeapon = MagicWeapon1#st_magic_weapon{exp = MagicWeapon#st_magic_weapon.exp + Exp, is_change = 1},
                    log_magic_weapon_stage(Player#player.key, Player#player.nickname, NewMagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, NewMagicWeapon#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 0),
                    lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon),
                    {Player, GoodsList}
            end;
        true ->
            F = fun(_, {M, GList}) ->
                NextBaseData = data_magic_weapon_stage:get(M#st_magic_weapon.stage + 1),
                NewM = M#st_magic_weapon{exp = 0, stage = M#st_magic_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_magic_weapon_stage.weapon_id, is_change = 1},
                BaseData = data_magic_weapon_stage:get(M#st_magic_weapon.stage),
                {NewM, GList ++ tuple_to_list(BaseData#base_magic_weapon_stage.award)}
                end,
            {NewMagicWeapon, GoodsList1} = lists:foldl(F, {MagicWeapon, []}, lists:seq(MagicWeapon#st_magic_weapon.stage, Stage - 1)),

            NewMagicWeapon1 = magic_weapon_init:calc_attribute(NewMagicWeapon),
            notice_sys:add_notice(player_view, [Player, 3, NewMagicWeapon1#st_magic_weapon.stage]),
            lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon1),
            NewPlayer = player_util:count_player_attribute(Player#player{magic_weapon_id = NewMagicWeapon1#st_magic_weapon.weapon_id}, true),
            scene_agent_dispatch:magic_weapon_id(NewPlayer),
            log_magic_weapon_stage(Player#player.key, Player#player.nickname, NewMagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, NewMagicWeapon#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 0),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(224, goods:merge_goods(GoodsList))),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1022, 0, NewMagicWeapon#st_magic_weapon.stage),
            goods_add_to_stage(NewPlayer, T, GoodsList ++ GoodsList1)
    end.


%%物品增加1阶
goods_add_stage_limit(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage_limit(Player, [{Stage, Exp} | T], GoodsList) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    MaxStage = data_magic_weapon_stage:max_stage(),
    if MagicWeapon#st_magic_weapon.stage >= MaxStage -> {Player, GoodsList};
        MagicWeapon#st_magic_weapon.stage > Stage ->
            BaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage),
            NewExp = MagicWeapon#st_magic_weapon.exp + Exp,
            if NewExp >= BaseData#base_magic_weapon_stage.exp ->
                NextBaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage + 1),
                NewMagicWeapon = MagicWeapon#st_magic_weapon{exp = 0, stage = MagicWeapon#st_magic_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_magic_weapon_stage.weapon_id, is_change = 1},
                NewMagicWeapon1 = magic_weapon_init:calc_attribute(NewMagicWeapon),
                lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon1),
                NewPlayer = player_util:count_player_attribute(Player#player{magic_weapon_id = NewMagicWeapon1#st_magic_weapon.weapon_id}, true),
                scene_agent_dispatch:magic_weapon_id(NewPlayer),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1022, 0, NewMagicWeapon#st_magic_weapon.stage),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(224, tuple_to_list(BaseData#base_magic_weapon_stage.award))),
                log_magic_weapon_stage(Player#player.key, Player#player.nickname, NewMagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, NewMagicWeapon#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 0),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_magic_weapon_stage.award));
                true ->
                    MagicWeapon1 = set_bless_cd(MagicWeapon, BaseData#base_magic_weapon_stage.cd),
                    NewMagicWeapon = MagicWeapon1#st_magic_weapon{exp = MagicWeapon#st_magic_weapon.exp + Exp, is_change = 1},
                    log_magic_weapon_stage(Player#player.key, Player#player.nickname, NewMagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, NewMagicWeapon#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 0),
                    lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage + 1),
            NewMagicWeapon = MagicWeapon#st_magic_weapon{exp = 0, stage = MagicWeapon#st_magic_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_magic_weapon_stage.weapon_id, is_change = 1},
            NewMagicWeapon1 = magic_weapon_init:calc_attribute(NewMagicWeapon),
            notice_sys:add_notice(player_view, [Player, 3, NewMagicWeapon1#st_magic_weapon.stage]),
            lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon1),
            NewPlayer = player_util:count_player_attribute(Player#player{magic_weapon_id = NewMagicWeapon1#st_magic_weapon.weapon_id}, true),
            scene_agent_dispatch:magic_weapon_id(NewPlayer),
            BaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(224, tuple_to_list(BaseData#base_magic_weapon_stage.award))),
            log_magic_weapon_stage(Player#player.key, Player#player.nickname, NewMagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, NewMagicWeapon#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1022, 0, NewMagicWeapon#st_magic_weapon.stage),
            goods_add_stage_limit(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_magic_weapon_stage.award))
    end.

%%升阶
upgrade_stage(Player, IsAuto) ->
    OpenLv = ?MAGIC_WEAPON_OPEN_LV,
    if Player#player.lv < OpenLv -> {false, 2};
        true ->
            MaxStage = data_magic_weapon_stage:max_stage(),
            MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
            if MagicWeapon#st_magic_weapon.stage >= MaxStage -> {false, 3};
                MagicWeapon#st_magic_weapon.stage == 0 -> {false, 0};
                true ->
                    BaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage),
                    case check_goods(Player, BaseData, IsAuto) of
                        {false, Err} -> {false, Err};
                        {true, Player1} ->
                            MagicWeapon1 = add_exp(MagicWeapon, BaseData, Player#player.vip_lv),

                            log_magic_weapon_stage(Player#player.key, Player#player.nickname, MagicWeapon1#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, MagicWeapon1#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 0),
                            OldExpPercent = util:floor(MagicWeapon#st_magic_weapon.exp / BaseData#base_magic_weapon_stage.exp * 100),
                            NewExpPercent = util:floor(MagicWeapon1#st_magic_weapon.exp / BaseData#base_magic_weapon_stage.exp * 100),
                            if
                                MagicWeapon1#st_magic_weapon.stage /= MagicWeapon#st_magic_weapon.stage ->
                                    NewMagicWeapon = magic_weapon_init:calc_attribute(MagicWeapon1),
                                    lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon),
                                    NewPlayer = player_util:count_player_attribute(Player1#player{magic_weapon_id = MagicWeapon1#st_magic_weapon.weapon_id}, true),
                                    scene_agent_dispatch:magic_weapon_id(NewPlayer),
                                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(224, tuple_to_list(BaseData#base_magic_weapon_stage.award))),
                                    ?CAST(activity_proc:get_act_pid(), {update_open_act_all_target, Player#player.key, ?OPEN_ALL_TARGET_MAGIC_WEAPON, NewMagicWeapon#st_magic_weapon.stage}),
                                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1022, 0, NewMagicWeapon#st_magic_weapon.stage),
                                    notice_sys:add_notice(player_view, [Player, 3, MagicWeapon1#st_magic_weapon.stage]),
                                    activity:get_notice(Player, [33,46], true),
                                    {ok, 7, NewPlayer1};
                                OldExpPercent /= NewExpPercent ->
                                    NewMagicWeapon = magic_weapon_init:calc_attribute(MagicWeapon1),
                                    lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon),
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:attribute_update(NewPlayer),
                                    {ok, 1, NewPlayer};
                                true ->
                                    lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, MagicWeapon1),
                                    {ok, 1, Player1}
                            end
                    end
            end
    end.

check_upgrade_stage_state(Player, Tips) ->
    OpenLv = ?MAGIC_WEAPON_OPEN_LV,
    if Player#player.lv < OpenLv -> Tips;
        true ->
            MaxStage = data_magic_weapon_stage:max_stage(),
            MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
            if MagicWeapon#st_magic_weapon.stage >= MaxStage -> Tips;
                true ->
                    BaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage),
                    if
                        BaseData#base_magic_weapon_stage.cd < 1 ->
                            case check_goods(Player, BaseData, 0, false) of
                                {false, _Err} -> Tips;
                                {true, _Player1} -> Tips#tips{state = 1}
                            end;
                        true ->
                            Tips
                    end
            end
    end.

%%今日是否有双倍
check_double(_Vip) -> false.

log_magic_weapon_stage(Pkey, NickName, NewStage, Stage, NewExp, Exp, Type) ->
    Sql = io_lib:format("insert into log_magic_weapon_stage set pkey=~p,nickname='~s',stage=~p,old_stage=~p,exp=~p,old_exp=~p,time=~p,`type`=~p",
        [Pkey, NickName, NewStage, Stage, NewExp, Exp, util:unixtime(), Type]),
    log_proc:log(Sql),
    ok.


%%增加经验
add_exp(MagicWeapon, BaseData, Vip) ->
    IsDouble = check_double(Vip),
    Mult = ?IF_ELSE(IsDouble, 2, 1),
    Exp = util:rand(BaseData#base_magic_weapon_stage.exp_min, BaseData#base_magic_weapon_stage.exp_max) * Mult,
    %%经验满了,升阶
    if MagicWeapon#st_magic_weapon.exp + Exp >= BaseData#base_magic_weapon_stage.exp ->
        NextBaseData = data_magic_weapon_stage:get(MagicWeapon#st_magic_weapon.stage + 1),
        NewMagicWeapon = MagicWeapon#st_magic_weapon{exp = 0, stage = MagicWeapon#st_magic_weapon.stage + 1, bless_cd = 0, weapon_id = NextBaseData#base_magic_weapon_stage.weapon_id, is_change = 1},
        magic_weapon_load:replace(NewMagicWeapon),
        NewMagicWeapon;
        true ->
            MagicWeapon1 = set_bless_cd(MagicWeapon, BaseData#base_magic_weapon_stage.cd),
            MagicWeapon1#st_magic_weapon{exp = MagicWeapon#st_magic_weapon.exp + Exp, is_change = 1}
    end.

%%检查物品是否足够
check_goods(Player, BaseData, IsAuto) ->
    check_goods(Player, BaseData, IsAuto, true).

%%检查物品是否足够
check_goods(Player, BaseData, IsAuto, IsNotice) ->
    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_magic_weapon_stage.goods_ids)],
    Num = BaseData#base_magic_weapon_stage.num,
    Amagic_weapon = lists:sum([Val || {_, Val} <- CountList]),
    if Amagic_weapon >= Num ->
        if
            IsNotice == true ->
                DelGoodsList = goods_num(CountList, Num, []),
                goods:subtract_good(Player, DelGoodsList, 243);
            true ->
                ok
        end,
        {true, Player};
        Amagic_weapon < Num andalso IsAuto == 1 ->
            case new_shop:get_goods_price(BaseData#base_magic_weapon_stage.gid_auto) of
                false -> {false, 4};
                {ok, Type, Price} ->
                    Money = Price * (Num - Amagic_weapon),
                    case money:is_enough(Player, Money, Type) of
                        false -> {false, 5};
                        true ->
                            if
                                IsNotice == true ->
                                    DelGoodsList = goods_num(CountList, Num, []),
                                    goods:subtract_good(Player, DelGoodsList, 243),
                                    NewPlayer = money:cost_money(Player, Type, -Money, 243, BaseData#base_magic_weapon_stage.gid_auto, Num - Amagic_weapon),
                                    {true, NewPlayer};
                                true ->
                                    {true, Player}
                            end
                    end
            end;
        true ->
            if
                IsNotice == true ->
                    goods_util:client_popup_goods_not_enough(Player, BaseData#base_magic_weapon_stage.gid_auto, Num, 243);
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
set_bless_cd(MagicWeapon, Cd) ->
    if MagicWeapon#st_magic_weapon.bless_cd > 0 -> MagicWeapon;
        MagicWeapon#st_magic_weapon.exp > 0 -> MagicWeapon;
        Cd > 0 ->
            MagicWeapon#st_magic_weapon{bless_cd = Cd + util:unixtime()};
        true ->
            MagicWeapon
    end.


%%祝福重置
bless_cd_reset(Player, Now) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    if MagicWeapon#st_magic_weapon.bless_cd > 0 ->
        if MagicWeapon#st_magic_weapon.bless_cd > Now ->
            Player;
            true ->
                mail_bless_reset(Player#player.key, MagicWeapon#st_magic_weapon.stage),
                MagicWeapon1 = MagicWeapon#st_magic_weapon{bless_cd = 0, exp = 0, is_change = 1},
                NewMagicWeapon = magic_weapon_init:calc_attribute(MagicWeapon1),
                lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon),
                player_bless:refresh_bless(Player#player.sid, 3, 0),
                NewPlayer = player_util:count_player_attribute(Player, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
                log_magic_weapon_stage(Player#player.key, Player#player.nickname, NewMagicWeapon#st_magic_weapon.stage, MagicWeapon#st_magic_weapon.stage, NewMagicWeapon#st_magic_weapon.exp, MagicWeapon#st_magic_weapon.exp, 1),
                NewPlayer
        end;
        true -> Player
    end.

%%祝福经验清0通知
mail_bless_reset(Key, Lv) ->
    Content = io_lib:format(?T("您的~p级法宝祝福时间到期,祝福值清零"), [Lv]),
    mail:sys_send_mail([Key], ?T("祝福清零"), Content),
    ok.

%%获取祝福状态
check_bless_state(Now) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    if MagicWeapon#st_magic_weapon.bless_cd > Now -> [[3, MagicWeapon#st_magic_weapon.bless_cd - Now]];
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
                    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
                    if GoodsType#goods_type.need_lv > MagicWeapon#st_magic_weapon.stage -> {17, Player};
                        true ->
                            SubtypeList = [?GOODS_SUBTYPE_EQUIP_MAGIC_WEAPON_1, ?GOODS_SUBTYPE_EQUIP_MAGIC_WEAPON_2, ?GOODS_SUBTYPE_EQUIP_MAGIC_WEAPON_3, ?GOODS_SUBTYPE_EQUIP_MAGIC_WEAPON_4],
                            case lists:member(GoodsType#goods_type.subtype, SubtypeList) of
                                false -> {18, Player};
                                true ->
                                    NeedGoods = Goods#goods{location = ?GOODS_LOCATION_MAGIC_WEAPON, cell = GoodsType#goods_type.subtype, bind = ?BIND},

                                    GoodsDict = goods_dict:update_goods(NeedGoods, GoodsSt#st_goods.dict),
                                    goods_pack:pack_send_goods_info([NeedGoods], GoodsSt#st_goods.sid),

                                    EquipList =
                                        case lists:keytake(GoodsType#goods_type.subtype, 1, MagicWeapon#st_magic_weapon.equip_list) of
                                            false ->
                                                _OldGoodsId = 0,
                                                NewGoodsSt = GoodsSt#st_goods{leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1, dict = GoodsDict},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | MagicWeapon#st_magic_weapon.equip_list];
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
                                    MagicWeapon1 = MagicWeapon#st_magic_weapon{equip_list = EquipList, is_change = 1},
                                    NewMagicWeapon = magic_weapon_init:calc_attribute(MagicWeapon1),
                                    lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_magic_weapon_equip(Player#player.key, Player#player.nickname, GoodsType#goods_type.subtype, _OldGoodsId, Goods#goods.goods_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.


%% 检查是否有装备可以熔炼
get_equip_smelt_state() ->
    GoodsList = goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP10]),
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    F = fun(Goods) ->
        if
            Goods#goods.bind /= ?BIND -> false;
            true ->
                GoodsType = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, MagicWeapon#st_magic_weapon.equip_list) of
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

log_magic_weapon_equip(Pkey, Nickname, Subtype, OldGid, NewGid) ->
    Sql = io_lib:format("insert into log_magic_weapon_equip set pkey=~p,nickname='~s',subtype=~p,old_gid=~p,new_gid=~p,time=~p", [Pkey, Nickname, Subtype, OldGid, NewGid, util:unixtime()]),
    log_proc:log(Sql).

use_magic_weapon_dan(Player) ->
    case data_grow_dan:get(?GOODS_GROW_ID_MAGIC_WEAPON) of
        [] -> {false, 0}; %% 配表错误
        Base ->
            MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON), %% 玩家法宝
            case lists:keyfind(MagicWeapon#st_magic_weapon.stage, 1, Base#base_grow_dan.stage_max_num) of
                false -> {false, 0};
                {_, MaxNum} ->
                    if
                        MagicWeapon#st_magic_weapon.grow_num >= MaxNum ->
                            {false, 19}; %% 成长丹已达到使用上限
                        true ->
                            if
                                Base#base_grow_dan.step_lim > MagicWeapon#st_magic_weapon.stage ->
                                    {false, 20};  %% 未达到使用阶级
                                true ->
                                    GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_MAGIC_WEAPON),
                                    if
                                        GrowNum == 0 ->
                                            goods_util:client_popup_goods_not_enough(Player, Base#base_grow_dan.goods_id, 0, 229),
                                            {false, 21}; %% 成长丹不足
                                        true ->
                                            DeleteGrowNum = min(MaxNum - MagicWeapon#st_magic_weapon.grow_num, GrowNum),
                                            goods:subtract_good(Player, [{?GOODS_GROW_ID_MAGIC_WEAPON, DeleteGrowNum}], 229), %% 扣除成长丹
                                            NewMagicWeapon0 = MagicWeapon#st_magic_weapon{grow_num = MagicWeapon#st_magic_weapon.grow_num + DeleteGrowNum, is_change = 1},
                                            NewMagicWeapon1 = magic_weapon_init:calc_attribute(NewMagicWeapon0),
                                            lib_dict:put(?PROC_STATUS_MAGIC_WEAPON, NewMagicWeapon1),
                                            NewPlayer = player_util:count_player_attribute(Player#player{magic_weapon_id = MagicWeapon#st_magic_weapon.weapon_id}, true),
                                            scene_agent_dispatch:attribute_update(NewPlayer),
                                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1023, 0, DeleteGrowNum),
                                            {ok, NewPlayer}
                                    end
                            end
                    end
            end
    end.

check_use_magic_weapon_dan_state(_Player, Tips) ->
    case data_grow_dan:get(?GOODS_GROW_ID_MAGIC_WEAPON) of
        [] -> Tips; %% 配表错误
        Base ->
            MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON), %% 玩家法宝
            {_, MaxNum} = lists:keyfind(MagicWeapon#st_magic_weapon.stage, 1, Base#base_grow_dan.stage_max_num),
            if
                MagicWeapon#st_magic_weapon.grow_num >= MaxNum ->
                    Tips; %% 成长丹已达到使用上限
                true ->
                    if
                        Base#base_grow_dan.step_lim > MagicWeapon#st_magic_weapon.stage ->
                            Tips;  %% 未达到使用阶级
                        true ->
                            GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_MAGIC_WEAPON),
                            if
                                GrowNum == 0 ->
                                    Tips; %% 成长丹不足
                                true ->
                                    Tips#tips{state = 1}
                            end
                    end
            end
    end.