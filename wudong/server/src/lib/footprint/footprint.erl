%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:14
%%%-------------------------------------------------------------------
-module(footprint).
-author("hxming").

-include("footprint_new.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("tips.hrl").
-include("activity.hrl").
-include("achieve.hrl").

%% API
-export([
    get_footprint_info/0,
    view_other/1,
    change_figure/2,
    upgrade_stage/2,
    bless_cd_reset/2,
    check_bless_state/1,
    mail_bless_reset/2,
    equip_goods/2,
    use_footprint_dan/1,
    check_upgrade_stage_state/2,
    check_use_footprint_dan_state/2,
    check_upgrade_jp_state/3,
    goods_add_stage/3,
    goods_add_stage_limit/3,
    goods_add_to_stage/3,
    get_attribute/0,
    get_equip_smelt_state/0,
    log_footprint_stage/7
]).

get_attribute() ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    Footprint#st_footprint.attribute.

%%获取法宝信息
get_footprint_info() ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    Now = util:unixtime(),
    Cd = max(0, Footprint#st_footprint.bless_cd - Now),
    SkillList =
        footprint_skill:get_footprint_skill_list(Footprint#st_footprint.skill_list),
    AttributeList = attribute_util:pack_attr(Footprint#st_footprint.attribute),
    EquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- Footprint#st_footprint.equip_list],
    SpiritState = footprint_spirit:check_spirit_state(Footprint),
    {Footprint#st_footprint.stage, Footprint#st_footprint.exp, Cd, Footprint#st_footprint.footprint_id,
        Footprint#st_footprint.cbp, Footprint#st_footprint.grow_num, AttributeList, SkillList, EquipList, SpiritState}.

view_other(Pkey) ->
    Key = {footprint_view, Pkey},
    case cache:get(Key) of
        [] ->
            case footprint_load:load_view(Pkey) of
                [] -> {0, 0, [], [], [], 0, []};
                %%stage,cbp,attribute,skill_list,equip_list,grow_num,spirit_list
                [Stage, Cbp, AttributeList, SkillList, EquipList, GrowNum] ->
                    NewAttributeList = attribute_util:pack_attr(util:bitstring_to_term(AttributeList)),
                    NewSkillList = footprint_skill:get_footprint_skill_list(util:bitstring_to_term(SkillList)),
                    NewEquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- util:bitstring_to_term(EquipList)],
                    DanList = goods_attr_dan:get_dan_list_by_type(Pkey, ?GOODS_DAN_TYPE_FOOTPRINT),
                    Data = {Stage, Cbp, NewAttributeList, NewSkillList, NewEquipList, GrowNum, DanList},
                    cache:set(Key, Data, ?FIFTEEN_MIN_SECONDS),
                    Data
            end;
        Data -> Data
    end.


%%幻化
change_figure(Player, FigureId) ->
    StFootprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    case data_footprint_stage:figure2stage(FigureId) of
        [] -> {8, Player};
        Stage ->
            if StFootprint#st_footprint.stage < Stage -> {9, Player};
                true ->
                    NewStFootprint = StFootprint#st_footprint{footprint_id = FigureId, is_change = 1},
                    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewStFootprint),
                    {1, Player#player{footprint_id = FigureId}}
            end
    end.

%%物品增加1阶
goods_add_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    MaxStage = data_footprint_stage:max_stage(),
    if Footprint#st_footprint.stage >= MaxStage -> {Player, GoodsList};
        Footprint#st_footprint.stage >= Stage ->
            BaseData = data_footprint_stage:get(Footprint#st_footprint.stage),
            NewExp = Footprint#st_footprint.exp + Exp,
            if NewExp >= BaseData#base_footprint_stage.exp ->
                NextBaseData = data_footprint_stage:get(Footprint#st_footprint.stage + 1),
                NewFootprint = Footprint#st_footprint{exp = 0, stage = Footprint#st_footprint.stage + 1, bless_cd = 0, footprint_id = NextBaseData#base_footprint_stage.footprint_id, is_change = 1},
                NewFootprint1 = footprint_init:calc_attribute(NewFootprint),
                lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint1),
                NewPlayer = player_util:count_player_attribute(Player#player{footprint_id = NewFootprint1#st_footprint.footprint_id}, true),
                scene_agent_dispatch:footprint_update(NewPlayer),
                log_footprint_stage(Player#player.key, Player#player.nickname, NewFootprint#st_footprint.stage, Footprint#st_footprint.stage, NewFootprint#st_footprint.exp, Footprint#st_footprint.exp, 0),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1028, 0, NewFootprint#st_footprint.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_footprint_stage.award));
                true ->
                    Footprint1 = set_bless_cd(Footprint, BaseData#base_footprint_stage.cd),
                    NewFootprint = Footprint1#st_footprint{exp = Footprint#st_footprint.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
                    log_footprint_stage(Player#player.key, Player#player.nickname, NewFootprint#st_footprint.stage, Footprint#st_footprint.stage, NewFootprint#st_footprint.exp, Footprint#st_footprint.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_footprint_stage:get(Footprint#st_footprint.stage + 1),
            NewFootprint = Footprint#st_footprint{exp = 0, stage = Footprint#st_footprint.stage + 1, bless_cd = 0, footprint_id = NextBaseData#base_footprint_stage.footprint_id, is_change = 1},
            NewFootprint1 = footprint_init:calc_attribute(NewFootprint),
            notice_sys:add_notice(player_view, [Player, 6, NewFootprint1#st_footprint.stage]),
            lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint1),
            NewPlayer = player_util:count_player_attribute(Player#player{footprint_id = NewFootprint1#st_footprint.footprint_id}, true),
            scene_agent_dispatch:footprint_update(NewPlayer),
            BaseData = data_footprint_stage:get(Footprint#st_footprint.stage),
            log_footprint_stage(Player#player.key, Player#player.nickname, NewFootprint#st_footprint.stage, Footprint#st_footprint.stage, NewFootprint#st_footprint.exp, Footprint#st_footprint.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1028, 0, NewFootprint#st_footprint.stage),
            goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_footprint_stage.award))
    end.

%%使用物品增加到指定阶数 1 3
goods_add_to_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_to_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    MaxStage = data_footprint_stage:max_stage(),
    if Footprint#st_footprint.stage >= MaxStage -> {Player, GoodsList};
        Footprint#st_footprint.stage >= Stage ->
            BaseData = data_footprint_stage:get(Footprint#st_footprint.stage),
            NewExp = Footprint#st_footprint.exp + Exp,
            if NewExp >= BaseData#base_footprint_stage.exp ->
                NextBaseData = data_footprint_stage:get(Footprint#st_footprint.stage + 1),
                NewFootprint = Footprint#st_footprint{exp = 0, stage = Footprint#st_footprint.stage + 1, bless_cd = 0, footprint_id = NextBaseData#base_footprint_stage.footprint_id, is_change = 1},
                NewFootprint1 = footprint_init:calc_attribute(NewFootprint),
                lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint1),
                NewPlayer = player_util:count_player_attribute(Player#player{footprint_id = NewFootprint1#st_footprint.footprint_id}, true),
                scene_agent_dispatch:footprint_update(NewPlayer),
                log_footprint_stage(Player#player.key, Player#player.nickname, NewFootprint#st_footprint.stage, Footprint#st_footprint.stage, NewFootprint#st_footprint.exp, Footprint#st_footprint.exp, 0),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1028, 0, NewFootprint#st_footprint.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_footprint_stage.award));
                true ->
                    Footprint1 = set_bless_cd(Footprint, BaseData#base_footprint_stage.cd),
                    NewFootprint = Footprint1#st_footprint{exp = Footprint#st_footprint.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
                    log_footprint_stage(Player#player.key, Player#player.nickname, NewFootprint#st_footprint.stage, Footprint#st_footprint.stage, NewFootprint#st_footprint.exp, Footprint#st_footprint.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            F = fun(_, {M, GList}) ->
                NextBaseData = data_footprint_stage:get(M#st_footprint.stage + 1),
                NewM = M#st_footprint{exp = 0, stage = M#st_footprint.stage + 1, bless_cd = 0, footprint_id = NextBaseData#base_footprint_stage.footprint_id, is_change = 1},
                BaseData = data_footprint_stage:get(M#st_footprint.stage),
                {NewM, GList ++ tuple_to_list(BaseData#base_footprint_stage.award)}
                end,
            {NewFootprint, GoodsList1} = lists:foldl(F, {Footprint, []}, lists:seq(Footprint#st_footprint.stage, Stage - 1)),

            NewFootprint1 = footprint_init:calc_attribute(NewFootprint),
            notice_sys:add_notice(player_view, [Player, 6, NewFootprint1#st_footprint.stage]),
            lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint1),
            NewPlayer = player_util:count_player_attribute(Player#player{footprint_id = NewFootprint1#st_footprint.footprint_id}, true),
            scene_agent_dispatch:footprint_update(NewPlayer),
            log_footprint_stage(Player#player.key, Player#player.nickname, NewFootprint#st_footprint.stage, Footprint#st_footprint.stage, NewFootprint#st_footprint.exp, Footprint#st_footprint.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1028, 0, NewFootprint#st_footprint.stage),
            goods_add_to_stage(NewPlayer, T, GoodsList ++ GoodsList1)
    end.


%%物品增加1阶 特定等级
goods_add_stage_limit(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage_limit(Player, [{Stage, Exp} | T], GoodsList) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    MaxStage = data_footprint_stage:max_stage(),
    if Footprint#st_footprint.stage >= MaxStage -> {Player, GoodsList};
        Footprint#st_footprint.stage > Stage ->
            BaseData = data_footprint_stage:get(Footprint#st_footprint.stage),
            NewExp = Footprint#st_footprint.exp + Exp,
            if NewExp >= BaseData#base_footprint_stage.exp ->
                NextBaseData = data_footprint_stage:get(Footprint#st_footprint.stage + 1),
                NewFootprint = Footprint#st_footprint{exp = 0, stage = Footprint#st_footprint.stage + 1, bless_cd = 0, footprint_id = NextBaseData#base_footprint_stage.footprint_id, is_change = 1},
                NewFootprint1 = footprint_init:calc_attribute(NewFootprint),
                lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint1),
                NewPlayer = player_util:count_player_attribute(Player#player{footprint_id = NewFootprint1#st_footprint.footprint_id}, true),
                scene_agent_dispatch:footprint_update(NewPlayer),
                log_footprint_stage(Player#player.key, Player#player.nickname, NewFootprint#st_footprint.stage, Footprint#st_footprint.stage, NewFootprint#st_footprint.exp, Footprint#st_footprint.exp, 0),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1028, 0, NewFootprint#st_footprint.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_footprint_stage.award));
                true ->
                    Footprint1 = set_bless_cd(Footprint, BaseData#base_footprint_stage.cd),
                    NewFootprint = Footprint1#st_footprint{exp = Footprint#st_footprint.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
                    log_footprint_stage(Player#player.key, Player#player.nickname, NewFootprint#st_footprint.stage, Footprint#st_footprint.stage, NewFootprint#st_footprint.exp, Footprint#st_footprint.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_footprint_stage:get(Footprint#st_footprint.stage + 1),
            NewFootprint = Footprint#st_footprint{exp = 0, stage = Footprint#st_footprint.stage + 1, bless_cd = 0, footprint_id = NextBaseData#base_footprint_stage.footprint_id, is_change = 1},
            NewFootprint1 = footprint_init:calc_attribute(NewFootprint),
            notice_sys:add_notice(player_view, [Player, 6, NewFootprint1#st_footprint.stage]),
            lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint1),
            NewPlayer = player_util:count_player_attribute(Player#player{footprint_id = NewFootprint1#st_footprint.footprint_id}, true),
            scene_agent_dispatch:footprint_update(NewPlayer),
            BaseData = data_footprint_stage:get(Footprint#st_footprint.stage),
            log_footprint_stage(Player#player.key, Player#player.nickname, NewFootprint#st_footprint.stage, Footprint#st_footprint.stage, NewFootprint#st_footprint.exp, Footprint#st_footprint.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1028, 0, NewFootprint#st_footprint.stage),
            goods_add_stage_limit(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_footprint_stage.award))
    end.

%%升阶
upgrade_stage(Player, IsAuto) ->
    OpenLv = ?FOOTPRINT_OPEN_LV,
    if Player#player.lv < OpenLv -> {false, 2};
        true ->
            MaxStage = data_footprint_stage:max_stage(),
            Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
            if Footprint#st_footprint.stage >= MaxStage -> {false, 3};
                Footprint#st_footprint.stage == 0 -> {false, 0};
                true ->
                    BaseData = data_footprint_stage:get(Footprint#st_footprint.stage),
                    case check_goods(Player, BaseData, IsAuto) of
                        {false, Err} -> {false, Err};
                        {true, Player1} ->
                            Footprint1 = add_exp(Footprint, BaseData, Player#player.vip_lv),
                            log_footprint_stage(Player#player.key, Player#player.nickname, Footprint1#st_footprint.stage, Footprint#st_footprint.stage, Footprint1#st_footprint.exp, Footprint#st_footprint.exp, 0),
                            OldExpPercent = util:floor(Footprint#st_footprint.exp / BaseData#base_footprint_stage.exp * 100),
                            NewExpPercent = util:floor(Footprint1#st_footprint.exp / BaseData#base_footprint_stage.exp * 100),
                            if
                                Footprint1#st_footprint.stage /= Footprint#st_footprint.stage ->
                                    NewFootprint = footprint_init:calc_attribute(Footprint1),
                                    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
                                    NewPlayer = player_util:count_player_attribute(Player1#player{footprint_id = Footprint1#st_footprint.footprint_id}, true),
                                    scene_agent_dispatch:attribute_update(NewPlayer),
                                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(246, tuple_to_list(BaseData#base_footprint_stage.award))),
                                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1028, 0, NewFootprint#st_footprint.stage),
                                    notice_sys:add_notice(player_view, [Player, 6, Footprint1#st_footprint.stage]),
                                    activity:get_notice(Player, [33, 46], true),
                                    {ok, 7, NewPlayer1};
                                OldExpPercent /= NewExpPercent ->
                                    NewFootprint = footprint_init:calc_attribute(Footprint1),
                                    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:attribute_update(NewPlayer),
                                    {ok, 1, NewPlayer};
                                true ->
                                    lib_dict:put(?PROC_STATUS_FOOTPRINT, Footprint1),
                                    {ok, 1, Player1}
                            end
                    end
            end
    end.

%%升阶
check_upgrade_stage_state(Player, Tips) ->
    OpenLv = ?FOOTPRINT_OPEN_LV,
    if Player#player.lv < OpenLv -> Tips;
        true ->
            MaxStage = data_footprint_stage:max_stage(),
            Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
            if Footprint#st_footprint.stage >= MaxStage -> Tips;
                true ->
                    BaseData = data_footprint_stage:get(Footprint#st_footprint.stage),
                    if
                        BaseData#base_footprint_stage.cd < 1 ->
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

log_footprint_stage(Pkey, NickName, NewStage, Stage, NewExp, Exp, Type) ->
    Sql = io_lib:format("insert into log_footprint_stage set pkey=~p,nickname='~s',stage=~p,old_stage=~p,exp=~p,old_exp=~p,time=~p,`type`=~p",
        [Pkey, NickName, NewStage, Stage, NewExp, Exp, util:unixtime(), Type]),
    log_proc:log(Sql),
    ok.

%%今日是否有双倍
check_double(_Vip) -> false.


%%增加经验
add_exp(Footprint, BaseData, Vip) ->
    IsDouble = check_double(Vip),
    Mult = ?IF_ELSE(IsDouble, 2, 1),
    Exp = util:rand(BaseData#base_footprint_stage.exp_min, BaseData#base_footprint_stage.exp_max) * Mult,
    %%经验满了,升阶
    if Footprint#st_footprint.exp + Exp >= BaseData#base_footprint_stage.exp ->
        NextBaseData = data_footprint_stage:get(Footprint#st_footprint.stage + 1),
        NewFootprint = Footprint#st_footprint{exp = 0, stage = Footprint#st_footprint.stage + 1, bless_cd = 0, footprint_id = NextBaseData#base_footprint_stage.footprint_id, is_change = 1},
        footprint_load:replace(NewFootprint),
        NewFootprint;
        true ->
            Footprint1 = set_bless_cd(Footprint, BaseData#base_footprint_stage.cd),
            Footprint1#st_footprint{exp = Footprint#st_footprint.exp + Exp, is_change = 1}
    end.

%%检查物品是否足够
check_goods(Player, BaseData, IsAuto) ->
    check_goods(Player, BaseData, IsAuto, true).

check_goods(Player, BaseData, IsAuto, IsNotice) ->
    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_footprint_stage.goods_ids)],
    Num = BaseData#base_footprint_stage.num,
    Afootprint = lists:sum([Val || {_, Val} <- CountList]),
    if Afootprint >= Num ->
        if
            IsNotice == true ->
                DelGoodsList = goods_num(CountList, Num, []),
                goods:subtract_good(Player, DelGoodsList, 246);
            true ->
                ok
        end,
        {true, Player};
        Afootprint < Num andalso IsAuto == 1 ->
            case new_shop:get_goods_price(BaseData#base_footprint_stage.gid_auto) of
                false -> {false, 4};
                {ok, Type, Price} ->
                    Money = Price * (Num - Afootprint),
                    case money:is_enough(Player, Money, Type) of
                        false -> {false, 5};
                        true ->
                            if
                                IsNotice == true ->
                                    DelGoodsList = goods_num(CountList, Num, []),
                                    goods:subtract_good(Player, DelGoodsList, 246),
                                    NewPlayer = money:cost_money(Player, Type, -Money, 246, BaseData#base_footprint_stage.gid_auto, Num - Afootprint),
                                    {true, NewPlayer};
                                true ->
                                    {true, Player}
                            end
                    end
            end;
        true ->
            if
                IsNotice == true ->
                    goods_util:client_popup_goods_not_enough(Player, BaseData#base_footprint_stage.gid_auto, Num, 246);
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
set_bless_cd(Footprint, Cd) ->
    if Footprint#st_footprint.bless_cd > 0 -> Footprint;
        Footprint#st_footprint.exp > 0 -> Footprint;
        Cd > 0 ->
            Footprint#st_footprint{bless_cd = Cd + util:unixtime()};
        true ->
            Footprint
    end.


%%祝福重置
bless_cd_reset(Player, Now) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    if Footprint#st_footprint.bless_cd > 0 ->
        if Footprint#st_footprint.bless_cd > Now ->
            Player;
            true ->
                mail_bless_reset(Player#player.key, Footprint#st_footprint.stage),
                Footprint1 = Footprint#st_footprint{bless_cd = 0, exp = 0, is_change = 1},
                NewFootprint = footprint_init:calc_attribute(Footprint1),
                lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
                player_bless:refresh_bless(Player#player.sid, 6, 0),
                NewPlayer = player_util:count_player_attribute(Player, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
                log_footprint_stage(Player#player.key, Player#player.nickname, NewFootprint#st_footprint.stage, Footprint#st_footprint.stage, NewFootprint#st_footprint.exp, Footprint#st_footprint.exp, 1),
                NewPlayer
        end;
        true -> Player
    end.

%%祝福经验清0通知
mail_bless_reset(Key, Lv) ->
    Content = io_lib:format(?T("您的~p级足迹祝福时间到期,祝福值清零"), [Lv]),
    mail:sys_send_mail([Key], ?T("祝福清零"), Content),
    ok.

%%获取祝福状态
check_bless_state(Now) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    if Footprint#st_footprint.bless_cd > Now -> [[6, Footprint#st_footprint.bless_cd - Now]];
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
                    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
                    if GoodsType#goods_type.need_lv > Footprint#st_footprint.stage -> {17, Player};
                        true ->
                            SubtypeList = [?GOODS_SUBTYPE_EQUIP_FOOTPRINT_1, ?GOODS_SUBTYPE_EQUIP_FOOTPRINT_2, ?GOODS_SUBTYPE_EQUIP_FOOTPRINT_3, ?GOODS_SUBTYPE_EQUIP_FOOTPRINT_4],
                            case lists:member(GoodsType#goods_type.subtype, SubtypeList) of
                                false -> {18, Player};
                                true ->
                                    NeedGoods = Goods#goods{location = ?GOODS_LOCATION_FOOTPRINT, cell = GoodsType#goods_type.subtype, bind = ?BIND},

                                    GoodsDict = goods_dict:update_goods(NeedGoods, GoodsSt#st_goods.dict),
                                    goods_pack:pack_send_goods_info([NeedGoods], GoodsSt#st_goods.sid),

                                    EquipList =
                                        case lists:keytake(GoodsType#goods_type.subtype, 1, Footprint#st_footprint.equip_list) of
                                            false ->
                                                _OldGoodsId = 0,
                                                NewGoodsSt = GoodsSt#st_goods{leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1, dict = GoodsDict},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | Footprint#st_footprint.equip_list];
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
                                    Footprint1 = Footprint#st_footprint{equip_list = EquipList, is_change = 1},
                                    NewFootprint = footprint_init:calc_attribute(Footprint1),
                                    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_footprint_equip(Player#player.key, Player#player.nickname, GoodsType#goods_type.subtype, _OldGoodsId, Goods#goods.goods_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

%% 检查是否有装备可以熔炼
get_equip_smelt_state() ->
    GoodsList = goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP10]),
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    F = fun(Goods) ->
        if
            Goods#goods.bind /= ?BIND -> false;
            true ->
                GoodsType = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, Footprint#st_footprint.equip_list) of
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

log_footprint_equip(Pkey, Nickname, Subtype, OldGid, NewGid) ->
    Sql = io_lib:format("insert into log_footprint_equip set pkey=~p,nickname='~s',subtype=~p,old_gid=~p,new_gid=~p,time=~p", [Pkey, Nickname, Subtype, OldGid, NewGid, util:unixtime()]),
    log_proc:log(Sql).

use_footprint_dan(Player) ->
    case data_grow_dan:get(?GOODS_GROW_ID_FOOTPRINT) of
        [] -> {false, 0}; %% 配表错误
        Base ->
            Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),  %% 玩家神兵
            case lists:keyfind(Footprint#st_footprint.stage, 1, Base#base_grow_dan.stage_max_num) of
                false -> {false, 0};
                {_, MaxNum} ->
                    if
                        Footprint#st_footprint.grow_num >= MaxNum ->
                            {false, 19}; %% 成长丹已达到使用上限
                        true ->
                            if
                                Base#base_grow_dan.step_lim > Footprint#st_footprint.stage ->
                                    {false, 20};  %% 未达到使用阶级
                                true ->
                                    GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_FOOTPRINT),
                                    if
                                        GrowNum == 0 ->
                                            goods_util:client_popup_goods_not_enough(Player, Base#base_grow_dan.goods_id, 0, 258),
                                            {false, 21}; %% 成长丹不足
                                        true ->
                                            DeleteGrowNum = min(MaxNum - Footprint#st_footprint.grow_num, GrowNum),
                                            goods:subtract_good(Player, [{?GOODS_GROW_ID_FOOTPRINT, DeleteGrowNum}], 258), %% 扣除成长丹
                                            NewFootprint0 = Footprint#st_footprint{grow_num = Footprint#st_footprint.grow_num + DeleteGrowNum, is_change = 1},
                                            NewFootprint1 = footprint_init:calc_attribute(NewFootprint0),
                                            lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint1),
                                            NewPlayer = player_util:count_player_attribute(Player#player{footprint_id = NewFootprint1#st_footprint.footprint_id}, true),
                                            scene_agent_dispatch:attribute_update(NewPlayer),
                                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1029, 0, DeleteGrowNum),
                                            {ok, NewPlayer}
                                    end
                            end
                    end
            end
    end.

check_use_footprint_dan_state(_Player, Tips) ->
    case data_grow_dan:get(?GOODS_GROW_ID_FOOTPRINT) of
        [] -> Tips; %% 配表错误
        Base ->
            Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),  %% 玩家
            {_, MaxNum} = lists:keyfind(Footprint#st_footprint.stage, 1, Base#base_grow_dan.stage_max_num),
            if
                Footprint#st_footprint.grow_num >= MaxNum ->
                    Tips; %% 成长丹已达到使用上限
                true ->
                    if
                        Base#base_grow_dan.step_lim > Footprint#st_footprint.stage ->
                            Tips;  %% 未达到使用阶级
                        true ->
                            GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_FOOTPRINT),
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