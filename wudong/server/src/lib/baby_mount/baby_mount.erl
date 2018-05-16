%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2017 12:07
%%%-------------------------------------------------------------------
-module(baby_mount).
-author("hxming").

-include("baby_mount.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("tips.hrl").
-include("activity.hrl").
-include("achieve.hrl").

%% API
-export([
    get_baby_mount_info/0,
    view_other/1,
    change_figure/2,
    upgrade_stage/2,
    bless_cd_reset/2,
    check_bless_state/1,
    mail_bless_reset/2,
    equip_goods/2,
    use_baby_mount_dan/1,
    check_upgrade_stage_state/2,
    check_use_baby_mount_dan_state/2,
    check_upgrade_jp_state/3,
    goods_add_stage/3,
    goods_add_stage_limit/3,
    goods_add_to_stage/3,
    get_equip_smelt_state/0,
    log_baby_mount_stage/7
]).

%%获取信息
get_baby_mount_info() ->
    BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    Now = util:unixtime(),
    Cd = max(0, BabyMount#st_baby_mount.bless_cd - Now),
    SkillList =
        baby_mount_skill:get_baby_mount_skill_list(BabyMount#st_baby_mount.skill_list),
    AttributeList = attribute_util:pack_attr(BabyMount#st_baby_mount.attribute),
    EquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- BabyMount#st_baby_mount.equip_list],
    SpiritState = baby_mount_spirit:check_spirit_state(BabyMount),
    {BabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.exp, Cd, BabyMount#st_baby_mount.baby_mount_id,
        BabyMount#st_baby_mount.cbp, BabyMount#st_baby_mount.grow_num, AttributeList, SkillList, EquipList, SpiritState}.

view_other(Pkey) ->
    Key = {baby_mount_view, Pkey},
    case cache:get(Key) of
        [] ->
            case baby_mount_load:load_view(Pkey) of
                [] -> {0, 0, [], [], [], 0, []};
                %%stage,cbp,attribute,skill_list,equip_list,grow_num,spirit_list
                [Stage, Cbp, AttributeList, SkillList, EquipList, GrowNum] ->
                    NewAttributeList = attribute_util:pack_attr(util:bitstring_to_term(AttributeList)),
                    NewSkillList = baby_mount_skill:get_baby_mount_skill_list(util:bitstring_to_term(SkillList)),
                    NewEquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- util:bitstring_to_term(EquipList)],
%%                    DanList = goods_attr_dan:get_dan_list_by_type(Pkey, ?GOODS_DAN_TYPE_BABY_MOUNT),
                    Data = {Stage, Cbp, NewAttributeList, NewSkillList, NewEquipList, GrowNum, []},
                    cache:set(Key, Data, ?FIFTEEN_MIN_SECONDS),
                    Data
            end;
        Data -> Data
    end.

%%幻化
change_figure(Player, FigureId) ->
    StBabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    case data_baby_mount_stage:figure2stage(FigureId) of
        [] -> {8, Player};
        Stage ->
            if StBabyMount#st_baby_mount.stage < Stage -> {9, Player};
                true ->
                    NewStBabyMount = StBabyMount#st_baby_mount{baby_mount_id = FigureId, is_change = 1},
                    lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewStBabyMount),
                    {1, Player#player{baby_mount_id = FigureId}}
            end
    end.

%%物品增加1阶
goods_add_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    MaxStage = data_baby_mount_stage:max_stage(),
    if BabyMount#st_baby_mount.stage >= MaxStage -> {Player, GoodsList};
        BabyMount#st_baby_mount.stage >= Stage ->
            BaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage),
            NewExp = BabyMount#st_baby_mount.exp + Exp,
            if NewExp >= BaseData#base_baby_mount_stage.exp ->
                NextBaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage + 1),
                NewBabyMount = BabyMount#st_baby_mount{exp = 0, stage = BabyMount#st_baby_mount.stage + 1, bless_cd = 0, baby_mount_id = NextBaseData#base_baby_mount_stage.baby_mount_id, is_change = 1},
                NewBabyMount1 = baby_mount_init:calc_attribute(NewBabyMount),
                lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount1),
                NewPlayer = player_util:count_player_attribute(Player#player{baby_mount_id = NewBabyMount1#st_baby_mount.baby_mount_id}, true),
                scene_agent_dispatch:baby_mount_update(NewPlayer),
                log_baby_mount_stage(Player#player.key, Player#player.nickname, NewBabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.stage, NewBabyMount#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 0),
%%                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewBabyMount#st_baby_mount.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_baby_mount_stage.award));
                true ->
                    BabyMount1 = set_bless_cd(BabyMount, BaseData#base_baby_mount_stage.cd),
                    NewBabyMount = BabyMount1#st_baby_mount{exp = BabyMount#st_baby_mount.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount),
                    log_baby_mount_stage(Player#player.key, Player#player.nickname, NewBabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.stage, NewBabyMount#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage + 1),
            NewBabyMount = BabyMount#st_baby_mount{exp = 0, stage = BabyMount#st_baby_mount.stage + 1, bless_cd = 0, baby_mount_id = NextBaseData#base_baby_mount_stage.baby_mount_id, is_change = 1},
            NewBabyMount1 = baby_mount_init:calc_attribute(NewBabyMount),
%%            notice_sys:add_notice(player_view, [Player, 7, NewBabyMount1#st_baby_mount.stage]),
            lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount1),
            NewPlayer = player_util:count_player_attribute(Player#player{baby_mount_id = NewBabyMount1#st_baby_mount.baby_mount_id}, true),
            scene_agent_dispatch:baby_mount_update(NewPlayer),
            BaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, tuple_to_list(BaseData#base_baby_mount_stage.award))),
            log_baby_mount_stage(Player#player.key, Player#player.nickname, NewBabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.stage, NewBabyMount#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 0),
%%            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewBabyMount#st_baby_mount.stage),
            goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_baby_mount_stage.award))
    end.

%%使用物品增加到指定阶数 1 3
goods_add_to_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_to_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    MaxStage = data_baby_mount_stage:max_stage(),
    if BabyMount#st_baby_mount.stage >= MaxStage -> {Player, GoodsList};
        BabyMount#st_baby_mount.stage >= Stage ->
            BaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage),
            NewExp = BabyMount#st_baby_mount.exp + Exp,
            if NewExp >= BaseData#base_baby_mount_stage.exp ->
                NextBaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage + 1),
                NewBabyMount = BabyMount#st_baby_mount{exp = 0, stage = BabyMount#st_baby_mount.stage + 1, bless_cd = 0, baby_mount_id = NextBaseData#base_baby_mount_stage.baby_mount_id, is_change = 1},
                NewBabyMount1 = baby_mount_init:calc_attribute(NewBabyMount),
                lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount1),
                NewPlayer = player_util:count_player_attribute(Player#player{baby_mount_id = NewBabyMount1#st_baby_mount.baby_mount_id}, true),
                scene_agent_dispatch:baby_mount_update(NewPlayer),
                log_baby_mount_stage(Player#player.key, Player#player.nickname, NewBabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.stage, NewBabyMount#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 0),
%%                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewBabyMount#st_baby_mount.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_baby_mount_stage.award));
                true ->
                    BabyMount1 = set_bless_cd(BabyMount, BaseData#base_baby_mount_stage.cd),
                    NewBabyMount = BabyMount1#st_baby_mount{exp = BabyMount#st_baby_mount.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount),
                    log_baby_mount_stage(Player#player.key, Player#player.nickname, NewBabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.stage, NewBabyMount#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            F = fun(_, {M, GList}) ->
                NextBaseData = data_baby_mount_stage:get(M#st_baby_mount.stage + 1),
                NewM = M#st_baby_mount{exp = 0, stage = M#st_baby_mount.stage + 1, bless_cd = 0, baby_mount_id = NextBaseData#base_baby_mount_stage.baby_mount_id, is_change = 1},
                BaseData = data_baby_mount_stage:get(M#st_baby_mount.stage),
                {NewM, GList ++ tuple_to_list(BaseData#base_baby_mount_stage.award)}
                end,
            {NewBabyMount, GoodsList1} = lists:foldl(F, {BabyMount, []}, lists:seq(BabyMount#st_baby_mount.stage, Stage - 1)),
            log_baby_mount_stage(Player#player.key, Player#player.nickname, NewBabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.stage, NewBabyMount#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 0),
            NewBabyMount1 = baby_mount_init:calc_attribute(NewBabyMount),
%%            notice_sys:add_notice(player_view, [Player, 7, NewBabyMount1#st_baby_mount.stage]),
            lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount1),
            NewPlayer = player_util:count_player_attribute(Player#player{baby_mount_id = NewBabyMount1#st_baby_mount.baby_mount_id}, true),
            scene_agent_dispatch:baby_mount_update(NewPlayer),
%%            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewBabyMount#st_baby_mount.stage),
            goods_add_to_stage(NewPlayer, T, GoodsList ++ GoodsList1)
    end.


%%物品增加1阶 特定等级
goods_add_stage_limit(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage_limit(Player, [{Stage, Exp} | T], GoodsList) ->
    BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    MaxStage = data_baby_mount_stage:max_stage(),
    if BabyMount#st_baby_mount.stage >= MaxStage -> {Player, GoodsList};
        BabyMount#st_baby_mount.stage > Stage ->
            BaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage),
            NewExp = BabyMount#st_baby_mount.exp + Exp,
            if NewExp >= BaseData#base_baby_mount_stage.exp ->
                NextBaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage + 1),
                NewBabyMount = BabyMount#st_baby_mount{exp = 0, stage = BabyMount#st_baby_mount.stage + 1, bless_cd = 0, baby_mount_id = NextBaseData#base_baby_mount_stage.baby_mount_id, is_change = 1},
                NewBabyMount1 = baby_mount_init:calc_attribute(NewBabyMount),
                lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount1),
                NewPlayer = player_util:count_player_attribute(Player#player{baby_mount_id = NewBabyMount1#st_baby_mount.baby_mount_id}, true),
                scene_agent_dispatch:baby_mount_update(NewPlayer),
                log_baby_mount_stage(Player#player.key, Player#player.nickname, NewBabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.stage, NewBabyMount#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, tuple_to_list(BaseData#base_baby_mount_stage.award))),
%%                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewBabyMount#st_baby_mount.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_baby_mount_stage.award));
                true ->
                    BabyMount1 = set_bless_cd(BabyMount, BaseData#base_baby_mount_stage.cd),
                    NewBabyMount = BabyMount1#st_baby_mount{exp = BabyMount#st_baby_mount.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount),
                    log_baby_mount_stage(Player#player.key, Player#player.nickname, NewBabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.stage, NewBabyMount#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage + 1),
            NewBabyMount = BabyMount#st_baby_mount{exp = 0, stage = BabyMount#st_baby_mount.stage + 1, bless_cd = 0, baby_mount_id = NextBaseData#base_baby_mount_stage.baby_mount_id, is_change = 1},
            NewBabyMount1 = baby_mount_init:calc_attribute(NewBabyMount),
%%            notice_sys:add_notice(player_view, [Player, 7, NewBabyMount1#st_baby_mount.stage]),
            lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount1),
            NewPlayer = player_util:count_player_attribute(Player#player{baby_mount_id = NewBabyMount1#st_baby_mount.baby_mount_id}, true),
            scene_agent_dispatch:baby_mount_update(NewPlayer),
            BaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, tuple_to_list(BaseData#base_baby_mount_stage.award))),
            log_baby_mount_stage(Player#player.key, Player#player.nickname, NewBabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.stage, NewBabyMount#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 0),
%%            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewBabyMount#st_baby_mount.stage),
            goods_add_stage_limit(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_baby_mount_stage.award))
    end.


%%升阶
upgrade_stage(Player, IsAuto) ->
    OpenLv = ?BABY_MOUNT_OPEN_LV,
    if Player#player.lv < OpenLv -> {false, 2};
        true ->
            MaxStage = data_baby_mount_stage:max_stage(),
            BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
            if BabyMount#st_baby_mount.stage >= MaxStage -> {false, 3};
                BabyMount#st_baby_mount.stage == 0 -> {false, 0};
                true ->
                    BaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage),
                    case check_goods(Player, BaseData, IsAuto) of
                        {false, Err} -> {false, Err};
                        {true, Player1} ->
                            BabyMount1 = add_exp(BabyMount, BaseData, Player#player.vip_lv),
                            log_baby_mount_stage(Player#player.key, Player#player.nickname, BabyMount1#st_baby_mount.stage, BabyMount#st_baby_mount.stage, BabyMount1#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 0),
                            OldExpPercent = util:floor(BabyMount#st_baby_mount.exp / BaseData#base_baby_mount_stage.exp * 100),
                            NewExpPercent = util:floor(BabyMount1#st_baby_mount.exp / BaseData#base_baby_mount_stage.exp * 100),
                            if
                                BabyMount1#st_baby_mount.stage /= BabyMount#st_baby_mount.stage ->
                                    NewBabyMount = baby_mount_init:calc_attribute(BabyMount1),
                                    lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount),
                                    NewPlayer = player_util:count_player_attribute(Player1#player{baby_mount_id = BabyMount1#st_baby_mount.baby_mount_id}, true),
                                    scene_agent_dispatch:baby_mount_update(NewPlayer),
                                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, tuple_to_list(BaseData#base_baby_mount_stage.award))),
%%                                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewBabyMount#st_baby_mount.stage),
%%                                    notice_sys:add_notice(player_view, [Player, 7, BabyMount1#st_baby_mount.stage]),
%%                                    activity:get_notice(Player, [33, 46], true),
                                    {ok, 7, NewPlayer1};
                                OldExpPercent /= NewExpPercent ->
                                    NewBabyMount = baby_mount_init:calc_attribute(BabyMount1),
                                    lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount),
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:attribute_update(NewPlayer),
                                    {ok, 1, NewPlayer};
                                true ->
                                    lib_dict:put(?PROC_STATUS_BABY_MOUNT, BabyMount1),
                                    {ok, 1, Player1}
                            end
                    end
            end
    end.

%%升阶
check_upgrade_stage_state(Player, Tips) ->
    OpenLv = ?BABY_MOUNT_OPEN_LV,
    if Player#player.lv < OpenLv -> Tips;
        true ->
            MaxStage = data_baby_mount_stage:max_stage(),
            BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
            BaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage),
            if
                BabyMount#st_baby_mount.stage >= MaxStage -> Tips;
                BaseData#base_baby_mount_stage.cd > 0 -> Tips;
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

log_baby_mount_stage(Pkey, NickName, NewStage, Stage, NewExp, Exp, Type) ->
    Sql = io_lib:format("insert into log_baby_mount_stage set pkey=~p,nickname='~s',stage=~p,old_stage=~p,exp=~p,old_exp=~p,time=~p,`type`=~p",
        [Pkey, NickName, NewStage, Stage, NewExp, Exp, util:unixtime(), Type]),
    log_proc:log(Sql),
    ok.

%%增加经验
add_exp(BabyMount, BaseData, Vip) ->
    IsDouble = check_double(Vip),
    Mult = ?IF_ELSE(IsDouble, 2, 1),
    Exp = util:rand(BaseData#base_baby_mount_stage.exp_min, BaseData#base_baby_mount_stage.exp_max) * Mult,
    %%经验满了,升阶
    if BabyMount#st_baby_mount.exp + Exp >= BaseData#base_baby_mount_stage.exp ->
        NextBaseData = data_baby_mount_stage:get(BabyMount#st_baby_mount.stage + 1),
        BabyMount#st_baby_mount{exp = 0, stage = BabyMount#st_baby_mount.stage + 1, bless_cd = 0, baby_mount_id = NextBaseData#base_baby_mount_stage.baby_mount_id, is_change = 1};
        true ->
            BabyMount1 = set_bless_cd(BabyMount, BaseData#base_baby_mount_stage.cd),
            BabyMount1#st_baby_mount{exp = BabyMount#st_baby_mount.exp + Exp, is_change = 1}
    end.

%%检查物品是否足够
check_goods(Player, BaseData, IsAuto) ->
    check_goods(Player, BaseData, IsAuto, true).

check_goods(Player, BaseData, IsAuto, IsNotice) ->
    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_baby_mount_stage.goods_ids)],
    Num = BaseData#base_baby_mount_stage.num,
    Ababy_mount = lists:sum([Val || {_, Val} <- CountList]),
    if Ababy_mount >= Num ->
        if
            IsNotice == true ->
                DelGoodsList = goods_num(CountList, Num, []),
                goods:subtract_good(Player, DelGoodsList, 553);
            true ->
                ok
        end,
        {true, Player};
        Ababy_mount < Num andalso IsAuto == 1 ->
            case new_shop:get_goods_price(BaseData#base_baby_mount_stage.gid_auto) of
                false -> {false, 4};
                {ok, Type, Price} ->
                    Money = Price * (Num - Ababy_mount),
                    case money:is_enough(Player, Money, Type) of
                        false -> {false, 5};
                        true ->
                            if
                                IsNotice == true ->
                                    DelGoodsList = goods_num(CountList, Num, []),
                                    goods:subtract_good(Player, DelGoodsList, 553),
                                    NewPlayer = money:cost_money(Player, Type, -Money, 553, BaseData#base_baby_mount_stage.gid_auto, Num - Ababy_mount),
                                    {true, NewPlayer};
                                true ->
                                    {true, Player}
                            end
                    end
            end;
        true ->
            if
                IsNotice == true ->
                    goods_util:client_popup_goods_not_enough(Player, BaseData#base_baby_mount_stage.gid_auto, Num, 553);
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
set_bless_cd(BabyMount, Cd) ->
    if BabyMount#st_baby_mount.bless_cd > 0 -> BabyMount;
        BabyMount#st_baby_mount.exp > 0 -> BabyMount;
        Cd > 0 ->
            BabyMount#st_baby_mount{bless_cd = Cd + util:unixtime()};
        true ->
            BabyMount
    end.


%%祝福重置
bless_cd_reset(Player, Now) ->
    BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    if BabyMount#st_baby_mount.bless_cd > 0 ->
        if BabyMount#st_baby_mount.bless_cd > Now ->
            Player;
            true ->
                mail_bless_reset(Player#player.key, BabyMount#st_baby_mount.stage),
                BabyMount1 = BabyMount#st_baby_mount{bless_cd = 0, exp = 0, is_change = 1},
                NewBabyMount = baby_mount_init:calc_attribute(BabyMount1),
                lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount),
                player_bless:refresh_bless(Player#player.sid, 10, 0),
                NewPlayer = player_util:count_player_attribute(Player, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
                log_baby_mount_stage(Player#player.key, Player#player.nickname, NewBabyMount#st_baby_mount.stage, BabyMount#st_baby_mount.stage, NewBabyMount#st_baby_mount.exp, BabyMount#st_baby_mount.exp, 1),
                NewPlayer
        end;
        true -> Player
    end.

%%祝福经验清0通知
mail_bless_reset(Key, Lv) ->
    Content = io_lib:format(?T("您的~p级灵骑祝福时间到期,祝福值清零"), [Lv]),
    mail:sys_send_mail([Key], ?T("祝福清零"), Content),
    ok.

%%获取祝福状态
check_bless_state(Now) ->
    BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    if BabyMount#st_baby_mount.bless_cd > Now -> [[10, BabyMount#st_baby_mount.bless_cd - Now]];
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
                    BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
                    if GoodsType#goods_type.need_lv > BabyMount#st_baby_mount.stage -> {17, Player};
                        true ->
                            SubtypeList = [?GOODS_SUBTYPE_EQUIP_BABY_MOUNT_1, ?GOODS_SUBTYPE_EQUIP_BABY_MOUNT_2, ?GOODS_SUBTYPE_EQUIP_BABY_MOUNT_3, ?GOODS_SUBTYPE_EQUIP_BABY_MOUNT_4],
                            case lists:member(GoodsType#goods_type.subtype, SubtypeList) of
                                false -> {18, Player};
                                true ->
                                    NeedGoods = Goods#goods{location = ?GOODS_LOCATION_BABY_MOUNT, cell = GoodsType#goods_type.subtype, bind = ?BIND},

                                    GoodsDict = goods_dict:update_goods(NeedGoods, GoodsSt#st_goods.dict),
                                    goods_pack:pack_send_goods_info([NeedGoods], GoodsSt#st_goods.sid),

                                    EquipList =
                                        case lists:keytake(GoodsType#goods_type.subtype, 1, BabyMount#st_baby_mount.equip_list) of
                                            false ->
                                                _OldGoodsId = 0,
                                                NewGoodsSt = GoodsSt#st_goods{leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1, dict = GoodsDict},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | BabyMount#st_baby_mount.equip_list];
                                            {value, {_, _OldGoodsId, OldGoodsKey}, T} ->
                                                case catch goods_util:get_goods(OldGoodsKey, GoodsSt#st_goods.dict) of
                                                    {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
                                                        GoodsDict1 = GoodsDict;
                                                    GoodsOld ->
                                                        NewGoodsOld = GoodsOld#goods{location = ?GOODS_LOCATION_BABY_MOUNT, cell = 0},
                                                        goods_pack:pack_send_goods_info([NewGoodsOld], GoodsSt#st_goods.sid),
                                                        goods_load:dbup_goods_cell_location(NewGoodsOld),
                                                        GoodsDict1 = goods_dict:update_goods(NewGoodsOld, GoodsDict)
                                                end,
                                                NewGoodsSt = GoodsSt#st_goods{dict = GoodsDict1},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | T]
                                        end,
                                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                                    goods_load:dbup_goods_cell_location(NeedGoods),
                                    BabyMount1 = BabyMount#st_baby_mount{equip_list = EquipList, is_change = 1},
                                    NewBabyMount = baby_mount_init:calc_attribute(BabyMount1),
                                    lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_baby_mount_equip(Player#player.key, Player#player.nickname, GoodsType#goods_type.subtype, _OldGoodsId, GoodsType#goods_type.goods_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

%% 检查是否有装备可以熔炼
get_equip_smelt_state() ->
    GoodsList = goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP10]),
    BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    F = fun(Goods) ->
        if
            Goods#goods.bind /= ?BIND -> false;
            true ->
                GoodsType = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, BabyMount#st_baby_mount.equip_list) of
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

log_baby_mount_equip(Pkey, Nickname, Subtype, OldGid, NewGid) ->
    Sql = io_lib:format("insert into log_baby_mount_equip set pkey=~p,nickname='~s',subtype=~p,old_gid=~p,new_gid=~p,time=~p", [Pkey, Nickname, Subtype, OldGid, NewGid, util:unixtime()]),
    log_proc:log(Sql).


use_baby_mount_dan(Player) ->
    case data_grow_dan:get(?GOODS_GROW_ID_BABY_MOUNT) of
        [] -> {false, 0}; %% 配表错误
        Base ->
            BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),  %% 玩家神兵
            case lists:keyfind(BabyMount#st_baby_mount.stage, 1, Base#base_grow_dan.stage_max_num) of
                false ->
                    {false, 0};
                {_, MaxNum} ->
                    if
                        BabyMount#st_baby_mount.grow_num >= MaxNum ->
                            {false, 19}; %% 成长丹已达到使用上限
                        true ->
                            if
                                Base#base_grow_dan.step_lim > BabyMount#st_baby_mount.stage ->
                                    {false, 20};  %% 未达到使用阶级
                                true ->
                                    GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_BABY_MOUNT),
                                    if
                                        GrowNum == 0 ->
                                            goods_util:client_popup_goods_not_enough(Player, Base#base_grow_dan.goods_id, 0, 554),
                                            {false, 21}; %% 成长丹不足
                                        true ->
                                            DeleteGrowNum = min(MaxNum - BabyMount#st_baby_mount.grow_num, GrowNum),
                                            goods:subtract_good(Player, [{?GOODS_GROW_ID_BABY_MOUNT, DeleteGrowNum}], 554), %% 扣除成长丹
                                            NewBabyMount0 = BabyMount#st_baby_mount{grow_num = BabyMount#st_baby_mount.grow_num + DeleteGrowNum, is_change = 1},
                                            NewBabyMount1 = baby_mount_init:calc_attribute(NewBabyMount0),
                                            lib_dict:put(?PROC_STATUS_BABY_MOUNT, NewBabyMount1),
                                            NewPlayer = player_util:count_player_attribute(Player#player{baby_mount_id = NewBabyMount1#st_baby_mount.baby_mount_id}, true),
                                            scene_agent_dispatch:baby_mount_update(NewPlayer),
                                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1032, 0, DeleteGrowNum),
                                            {ok, NewPlayer}
                                    end
                            end
                    end
            end
    end.

check_use_baby_mount_dan_state(_Player, Tips) ->
    case data_grow_dan:get(?GOODS_GROW_ID_BABY_MOUNT) of
        Base ->
            BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),  %% 玩家神兵
            {_, MaxNum} = lists:keyfind(BabyMount#st_baby_mount.stage, 1, Base#base_grow_dan.stage_max_num),
            if
                BabyMount#st_baby_mount.grow_num >= MaxNum ->
                    Tips; %% 成长丹已达到使用上限
                true ->
                    if
                        Base#base_grow_dan.step_lim > BabyMount#st_baby_mount.stage ->
                            Tips;  %% 未达到使用阶级
                        true ->
                            GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_BABY_MOUNT),
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
