%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 六月 2017 17:06
%%%-------------------------------------------------------------------
-module(cat).
-author("hxming").

-include("cat.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("goods.hrl").
-include("tips.hrl").
-include("activity.hrl").
-include("achieve.hrl").

%% API
-export([
    get_cat_info/0,
    view_other/1,
    change_figure/2,
    upgrade_stage/2,
    bless_cd_reset/2,
    check_bless_state/1,
    mail_bless_reset/2,
    equip_goods/2,
    use_cat_dan/1,
    check_upgrade_stage_state/2,
    check_use_cat_dan_state/2,
    check_upgrade_jp_state/3,
    goods_add_stage/3,
    goods_add_stage_limit/3,
    goods_add_to_stage/3,
    get_equip_smelt_state/0,
    log_cat_stage/7
]).

%%获取法宝信息
get_cat_info() ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    Now = util:unixtime(),
    Cd = max(0, Cat#st_cat.bless_cd - Now),
    SkillList =
        cat_skill:get_cat_skill_list(Cat#st_cat.skill_list),
    AttributeList = attribute_util:pack_attr(Cat#st_cat.attribute),
    EquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- Cat#st_cat.equip_list],
    SpiritState = cat_spirit:check_spirit_state(Cat),
    {Cat#st_cat.stage, Cat#st_cat.exp, Cd, Cat#st_cat.cat_id,
        Cat#st_cat.cbp, Cat#st_cat.grow_num, AttributeList, SkillList, EquipList, SpiritState}.

view_other(Pkey) ->
    Key = {cat_view, Pkey},
    case cache:get(Key) of
        [] ->
            case cat_load:load_view(Pkey) of
                [] -> {0, 0, [], [], [], 0, []};
                %%stage,cbp,attribute,skill_list,equip_list,grow_num,spirit_list
                [Stage, Cbp, AttributeList, SkillList, EquipList, GrowNum] ->
                    NewAttributeList = attribute_util:pack_attr(util:bitstring_to_term(AttributeList)),
                    NewSkillList = cat_skill:get_cat_skill_list(util:bitstring_to_term(SkillList)),
                    NewEquipList = [[SubType, EquipId] || {SubType, EquipId, _} <- util:bitstring_to_term(EquipList)],
                    DanList = goods_attr_dan:get_dan_list_by_type(Pkey, ?GOODS_DAN_TYPE_CAT),
                    Data = {Stage, Cbp, NewAttributeList, NewSkillList, NewEquipList, GrowNum, DanList},
                    cache:set(Key, Data, ?FIFTEEN_MIN_SECONDS),
                    Data
            end;
        Data -> Data
    end.

%%幻化
change_figure(Player, FigureId) ->
    StCat = lib_dict:get(?PROC_STATUS_CAT),
    case data_cat_stage:figure2stage(FigureId) of
        [] -> {8, Player};
        Stage ->
            if StCat#st_cat.stage < Stage -> {9, Player};
                true ->
                    NewStCat = StCat#st_cat{cat_id = FigureId, is_change = 1},
                    lib_dict:put(?PROC_STATUS_CAT, NewStCat),
                    {1, Player#player{cat_id = FigureId}}
            end
    end.

%%物品增加1阶
goods_add_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    MaxStage = data_cat_stage:max_stage(),
    if Cat#st_cat.stage >= MaxStage -> {Player, GoodsList};
        Cat#st_cat.stage >= Stage ->
            BaseData = data_cat_stage:get(Cat#st_cat.stage),
            NewExp = Cat#st_cat.exp + Exp,
            if NewExp >= BaseData#base_cat_stage.exp ->
                NextBaseData = data_cat_stage:get(Cat#st_cat.stage + 1),
                NewCat = Cat#st_cat{exp = 0, stage = Cat#st_cat.stage + 1, bless_cd = 0, cat_id = NextBaseData#base_cat_stage.cat_id, is_change = 1},
                NewCat1 = cat_init:calc_attribute(NewCat),
                lib_dict:put(?PROC_STATUS_CAT, NewCat1),
                NewPlayer = player_util:count_player_attribute(Player#player{cat_id = NewCat1#st_cat.cat_id}, true),
                scene_agent_dispatch:cat_update(NewPlayer),
                log_cat_stage(Player#player.key, Player#player.nickname, NewCat#st_cat.stage, Cat#st_cat.stage, NewCat#st_cat.exp, Cat#st_cat.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, tuple_to_list(BaseData#base_cat_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewCat#st_cat.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_cat_stage.award));
                true ->
                    Cat1 = set_bless_cd(Cat, BaseData#base_cat_stage.cd),
                    NewCat = Cat1#st_cat{exp = Cat#st_cat.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_CAT, NewCat),
                    log_cat_stage(Player#player.key, Player#player.nickname, NewCat#st_cat.stage, Cat#st_cat.stage, NewCat#st_cat.exp, Cat#st_cat.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_cat_stage:get(Cat#st_cat.stage + 1),
            NewCat = Cat#st_cat{exp = 0, stage = Cat#st_cat.stage + 1, bless_cd = 0, cat_id = NextBaseData#base_cat_stage.cat_id, is_change = 1},
            NewCat1 = cat_init:calc_attribute(NewCat),
            notice_sys:add_notice(player_view, [Player, 7, NewCat1#st_cat.stage]),
            lib_dict:put(?PROC_STATUS_CAT, NewCat1),
            NewPlayer = player_util:count_player_attribute(Player#player{cat_id = NewCat1#st_cat.cat_id}, true),
            scene_agent_dispatch:cat_update(NewPlayer),
            BaseData = data_cat_stage:get(Cat#st_cat.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, tuple_to_list(BaseData#base_cat_stage.award))),
            log_cat_stage(Player#player.key, Player#player.nickname, NewCat#st_cat.stage, Cat#st_cat.stage, NewCat#st_cat.exp, Cat#st_cat.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewCat#st_cat.stage),
            goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_cat_stage.award))
    end.

%%使用物品增加到指定阶数 1 3
goods_add_to_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_to_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    MaxStage = data_cat_stage:max_stage(),
    if Cat#st_cat.stage >= MaxStage -> {Player, GoodsList};
        Cat#st_cat.stage >= Stage ->
            BaseData = data_cat_stage:get(Cat#st_cat.stage),
            NewExp = Cat#st_cat.exp + Exp,
            if NewExp >= BaseData#base_cat_stage.exp ->
                NextBaseData = data_cat_stage:get(Cat#st_cat.stage + 1),
                NewCat = Cat#st_cat{exp = 0, stage = Cat#st_cat.stage + 1, bless_cd = 0, cat_id = NextBaseData#base_cat_stage.cat_id, is_change = 1},
                NewCat1 = cat_init:calc_attribute(NewCat),
                lib_dict:put(?PROC_STATUS_CAT, NewCat1),
                NewPlayer = player_util:count_player_attribute(Player#player{cat_id = NewCat1#st_cat.cat_id}, true),
                scene_agent_dispatch:cat_update(NewPlayer),
                log_cat_stage(Player#player.key, Player#player.nickname, NewCat#st_cat.stage, Cat#st_cat.stage, NewCat#st_cat.exp, Cat#st_cat.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, tuple_to_list(BaseData#base_cat_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewCat#st_cat.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_cat_stage.award));
                true ->
                    Cat1 = set_bless_cd(Cat, BaseData#base_cat_stage.cd),
                    NewCat = Cat1#st_cat{exp = Cat#st_cat.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_CAT, NewCat),
                    log_cat_stage(Player#player.key, Player#player.nickname, NewCat#st_cat.stage, Cat#st_cat.stage, NewCat#st_cat.exp, Cat#st_cat.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            F = fun(_, {M, GList}) ->
                NextBaseData = data_cat_stage:get(M#st_cat.stage + 1),
                NewM = M#st_cat{exp = 0, stage = M#st_cat.stage + 1, bless_cd = 0, cat_id = NextBaseData#base_cat_stage.cat_id, is_change = 1},
                BaseData = data_cat_stage:get(M#st_cat.stage),
                {NewM, GList ++ tuple_to_list(BaseData#base_cat_stage.award)}
                end,
            {NewCat, GoodsList1} = lists:foldl(F, {Cat, []}, lists:seq(Cat#st_cat.stage, Stage - 1)),
            log_cat_stage(Player#player.key, Player#player.nickname, NewCat#st_cat.stage, Cat#st_cat.stage, NewCat#st_cat.exp, Cat#st_cat.exp, 0),
            NewCat1 = cat_init:calc_attribute(NewCat),
            notice_sys:add_notice(player_view, [Player, 7, NewCat1#st_cat.stage]),
            lib_dict:put(?PROC_STATUS_CAT, NewCat1),
            NewPlayer = player_util:count_player_attribute(Player#player{cat_id = NewCat1#st_cat.cat_id}, true),
            scene_agent_dispatch:cat_update(NewPlayer),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewCat#st_cat.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, goods:merge_goods(GoodsList))),
            goods_add_to_stage(NewPlayer, T, GoodsList ++ GoodsList1)
    end.


%%物品增加1阶 特定等级
goods_add_stage_limit(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage_limit(Player, [{Stage, Exp} | T], GoodsList) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    MaxStage = data_cat_stage:max_stage(),
    if Cat#st_cat.stage >= MaxStage -> {Player, GoodsList};
        Cat#st_cat.stage > Stage ->
            BaseData = data_cat_stage:get(Cat#st_cat.stage),
            NewExp = Cat#st_cat.exp + Exp,
            if NewExp >= BaseData#base_cat_stage.exp ->
                NextBaseData = data_cat_stage:get(Cat#st_cat.stage + 1),
                NewCat = Cat#st_cat{exp = 0, stage = Cat#st_cat.stage + 1, bless_cd = 0, cat_id = NextBaseData#base_cat_stage.cat_id, is_change = 1},
                NewCat1 = cat_init:calc_attribute(NewCat),
                lib_dict:put(?PROC_STATUS_CAT, NewCat1),
                NewPlayer = player_util:count_player_attribute(Player#player{cat_id = NewCat1#st_cat.cat_id}, true),
                scene_agent_dispatch:cat_update(NewPlayer),
                log_cat_stage(Player#player.key, Player#player.nickname, NewCat#st_cat.stage, Cat#st_cat.stage, NewCat#st_cat.exp, Cat#st_cat.exp, 0),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, tuple_to_list(BaseData#base_cat_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewCat#st_cat.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_cat_stage.award));
                true ->
                    Cat1 = set_bless_cd(Cat, BaseData#base_cat_stage.cd),
                    NewCat = Cat1#st_cat{exp = Cat#st_cat.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_CAT, NewCat),
                    log_cat_stage(Player#player.key, Player#player.nickname, NewCat#st_cat.stage, Cat#st_cat.stage, NewCat#st_cat.exp, Cat#st_cat.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NextBaseData = data_cat_stage:get(Cat#st_cat.stage + 1),
            NewCat = Cat#st_cat{exp = 0, stage = Cat#st_cat.stage + 1, bless_cd = 0, cat_id = NextBaseData#base_cat_stage.cat_id, is_change = 1},
            NewCat1 = cat_init:calc_attribute(NewCat),
            notice_sys:add_notice(player_view, [Player, 7, NewCat1#st_cat.stage]),
            lib_dict:put(?PROC_STATUS_CAT, NewCat1),
            NewPlayer = player_util:count_player_attribute(Player#player{cat_id = NewCat1#st_cat.cat_id}, true),
            scene_agent_dispatch:cat_update(NewPlayer),
            BaseData = data_cat_stage:get(Cat#st_cat.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, tuple_to_list(BaseData#base_cat_stage.award))),
            log_cat_stage(Player#player.key, Player#player.nickname, NewCat#st_cat.stage, Cat#st_cat.stage, NewCat#st_cat.exp, Cat#st_cat.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewCat#st_cat.stage),
            goods_add_stage_limit(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_cat_stage.award))
    end.


%%升阶
upgrade_stage(Player, IsAuto) ->
    OpenLv = ?CAT_OPEN_LV,
    if Player#player.lv < OpenLv -> {false, 2};
        true ->
            MaxStage = data_cat_stage:max_stage(),
            Cat = lib_dict:get(?PROC_STATUS_CAT),
            if Cat#st_cat.stage >= MaxStage -> {false, 3};
                Cat#st_cat.stage == 0 -> {false, 0};
                true ->
                    BaseData = data_cat_stage:get(Cat#st_cat.stage),
                    case check_goods(Player, BaseData, IsAuto) of
                        {false, Err} -> {false, Err};
                        {true, Player1} ->
                            Cat1 = add_exp(Cat, BaseData, Player#player.vip_lv),
                            log_cat_stage(Player#player.key, Player#player.nickname, Cat1#st_cat.stage, Cat#st_cat.stage, Cat1#st_cat.exp, Cat#st_cat.exp, 0),
                            OldExpPercent = util:floor(Cat#st_cat.exp / BaseData#base_cat_stage.exp * 100),
                            NewExpPercent = util:floor(Cat1#st_cat.exp / BaseData#base_cat_stage.exp * 100),
                            if
                                Cat1#st_cat.stage /= Cat#st_cat.stage ->
                                    NewCat = cat_init:calc_attribute(Cat1),
                                    lib_dict:put(?PROC_STATUS_CAT, NewCat),
                                    NewPlayer = player_util:count_player_attribute(Player1#player{cat_id = Cat1#st_cat.cat_id}, true),
                                    scene_agent_dispatch:cat_update(NewPlayer),
                                    {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(271, tuple_to_list(BaseData#base_cat_stage.award))),
                                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1031, 0, NewCat#st_cat.stage),
                                    notice_sys:add_notice(player_view, [Player, 7, Cat1#st_cat.stage]),
%%                                    activity:get_notice(Player, [33, 46], true),
                                    {ok, 7, NewPlayer1};
                                OldExpPercent /= NewExpPercent ->
                                    NewCat = cat_init:calc_attribute(Cat1),
                                    lib_dict:put(?PROC_STATUS_CAT, NewCat),
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:attribute_update(NewPlayer),
                                    {ok, 1, NewPlayer};
                                true ->
                                    lib_dict:put(?PROC_STATUS_CAT, Cat1),
                                    {ok, 1, Player1}
                            end
                    end
            end
    end.

%%升阶
check_upgrade_stage_state(Player, Tips) ->
    OpenLv = ?CAT_OPEN_LV,
    if Player#player.lv < OpenLv -> Tips;
        true ->
            MaxStage = data_cat_stage:max_stage(),
            Cat = lib_dict:get(?PROC_STATUS_CAT),
            BaseData = data_cat_stage:get(Cat#st_cat.stage),
            if
                Cat#st_cat.stage >= MaxStage -> Tips;
                BaseData#base_cat_stage.cd > 0 -> Tips;
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

log_cat_stage(Pkey, NickName, NewStage, Stage, NewExp, Exp, Type) ->
    Sql = io_lib:format("insert into log_cat_stage set pkey=~p,nickname='~s',stage=~p,old_stage=~p,exp=~p,old_exp=~p,time=~p,`type`=~p",
        [Pkey, NickName, NewStage, Stage, NewExp, Exp, util:unixtime(), Type]),
    log_proc:log(Sql),
    ok.

%%增加经验
add_exp(Cat, BaseData, Vip) ->
    IsDouble = check_double(Vip),
    Mult = ?IF_ELSE(IsDouble, 2, 1),
    Exp = util:rand(BaseData#base_cat_stage.exp_min, BaseData#base_cat_stage.exp_max) * Mult,
    %%经验满了,升阶
    if Cat#st_cat.exp + Exp >= BaseData#base_cat_stage.exp ->
        NextBaseData = data_cat_stage:get(Cat#st_cat.stage + 1),
        Cat#st_cat{exp = 0, stage = Cat#st_cat.stage + 1, bless_cd = 0, cat_id = NextBaseData#base_cat_stage.cat_id, is_change = 1};
        true ->
            Cat1 = set_bless_cd(Cat, BaseData#base_cat_stage.cd),
            Cat1#st_cat{exp = Cat#st_cat.exp + Exp, is_change = 1}
    end.

%%检查物品是否足够
check_goods(Player, BaseData, IsAuto) ->
    check_goods(Player, BaseData, IsAuto, true).

check_goods(Player, BaseData, IsAuto, IsNotice) ->
    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_cat_stage.goods_ids)],
    Num = BaseData#base_cat_stage.num,
    Acat = lists:sum([Val || {_, Val} <- CountList]),
    if Acat >= Num ->
        if
            IsNotice == true ->
                DelGoodsList = goods_num(CountList, Num, []),
                goods:subtract_good(Player, DelGoodsList, 271);
            true ->
                ok
        end,
        {true, Player};
        Acat < Num andalso IsAuto == 1 ->
            case new_shop:get_goods_price(BaseData#base_cat_stage.gid_auto) of
                false -> {false, 4};
                {ok, Type, Price} ->
                    Money = Price * (Num - Acat),
                    case money:is_enough(Player, Money, Type) of
                        false -> {false, 5};
                        true ->
                            if
                                IsNotice == true ->
                                    DelGoodsList = goods_num(CountList, Num, []),
                                    goods:subtract_good(Player, DelGoodsList, 271),
                                    NewPlayer = money:cost_money(Player, Type, -Money, 271, BaseData#base_cat_stage.gid_auto, Num - Acat),
                                    {true, NewPlayer};
                                true ->
                                    {true, Player}
                            end
                    end
            end;
        true ->
            if
                IsNotice == true ->
                    goods_util:client_popup_goods_not_enough(Player, BaseData#base_cat_stage.gid_auto, Num, 271);
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
set_bless_cd(Cat, Cd) ->
    if Cat#st_cat.bless_cd > 0 -> Cat;
        Cat#st_cat.exp > 0 -> Cat;
        Cd > 0 ->
            Cat#st_cat{bless_cd = Cd + util:unixtime()};
        true ->
            Cat
    end.


%%祝福重置
bless_cd_reset(Player, Now) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    if Cat#st_cat.bless_cd > 0 ->
        if Cat#st_cat.bless_cd > Now ->
            Player;
            true ->
                mail_bless_reset(Player#player.key, Cat#st_cat.stage),
                Cat1 = Cat#st_cat{bless_cd = 0, exp = 0, is_change = 1},
                NewCat = cat_init:calc_attribute(Cat1),
                lib_dict:put(?PROC_STATUS_CAT, NewCat),
                player_bless:refresh_bless(Player#player.sid, 7, 0),
                NewPlayer = player_util:count_player_attribute(Player, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
                log_cat_stage(Player#player.key, Player#player.nickname, NewCat#st_cat.stage, Cat#st_cat.stage, NewCat#st_cat.exp, Cat#st_cat.exp, 1),
                NewPlayer
        end;
        true -> Player
    end.

%%祝福经验清0通知
mail_bless_reset(Key, Lv) ->
    Content = io_lib:format(?T("您的~p级灵猫祝福时间到期,祝福值清零"), [Lv]),
    mail:sys_send_mail([Key], ?T("祝福清零"), Content),
    ok.

%%获取祝福状态
check_bless_state(Now) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    if Cat#st_cat.bless_cd > Now -> [[7, Cat#st_cat.bless_cd - Now]];
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
                    Cat = lib_dict:get(?PROC_STATUS_CAT),
                    if GoodsType#goods_type.need_lv > Cat#st_cat.stage -> {17, Player};
                        true ->
                            SubtypeList = [?GOODS_SUBTYPE_EQUIP_CAT_1, ?GOODS_SUBTYPE_EQUIP_CAT_2, ?GOODS_SUBTYPE_EQUIP_CAT_3, ?GOODS_SUBTYPE_EQUIP_CAT_4],
                            case lists:member(GoodsType#goods_type.subtype, SubtypeList) of
                                false -> {18, Player};
                                true ->
                                    NeedGoods = Goods#goods{location = ?GOODS_LOCATION_CAT, cell = GoodsType#goods_type.subtype, bind = ?BIND},

                                    GoodsDict = goods_dict:update_goods(NeedGoods, GoodsSt#st_goods.dict),
                                    goods_pack:pack_send_goods_info([NeedGoods], GoodsSt#st_goods.sid),

                                    EquipList =
                                        case lists:keytake(GoodsType#goods_type.subtype, 1, Cat#st_cat.equip_list) of
                                            false ->
                                                _OldGoodsId = 0,
                                                NewGoodsSt = GoodsSt#st_goods{leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1, dict = GoodsDict},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | Cat#st_cat.equip_list];
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
                                    Cat1 = Cat#st_cat{equip_list = EquipList, is_change = 1},
                                    NewCat = cat_init:calc_attribute(Cat1),
                                    lib_dict:put(?PROC_STATUS_CAT, NewCat),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_cat_equip(Player#player.key, Player#player.nickname, GoodsType#goods_type.subtype, _OldGoodsId, GoodsType#goods_type.goods_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

%% 检查是否有装备可以熔炼
get_equip_smelt_state() ->
    GoodsList = goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP10]),
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    F = fun(Goods) ->
        if
            Goods#goods.bind /= ?BIND -> false;
            true ->
                GoodsType = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, Cat#st_cat.equip_list) of
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

log_cat_equip(Pkey, Nickname, Subtype, OldGid, NewGid) ->
    Sql = io_lib:format("insert into log_cat_equip set pkey=~p,nickname='~s',subtype=~p,old_gid=~p,new_gid=~p,time=~p", [Pkey, Nickname, Subtype, OldGid, NewGid, util:unixtime()]),
    log_proc:log(Sql).


use_cat_dan(Player) ->
    case data_grow_dan:get(?GOODS_GROW_ID_CAT) of
        [] -> {false, 0}; %% 配表错误
        Base ->
            Cat = lib_dict:get(?PROC_STATUS_CAT),  %% 玩家神兵
            case lists:keyfind(Cat#st_cat.stage, 1, Base#base_grow_dan.stage_max_num) of
                false ->
                    {false, 0};
                {_, MaxNum} ->
                    if
                        Cat#st_cat.grow_num >= MaxNum ->
                            {false, 19}; %% 成长丹已达到使用上限
                        true ->
                            if
                                Base#base_grow_dan.step_lim > Cat#st_cat.stage ->
                                    {false, 20};  %% 未达到使用阶级
                                true ->
                                    GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_CAT),
                                    if
                                        GrowNum == 0 ->
                                            goods_util:client_popup_goods_not_enough(Player, Base#base_grow_dan.goods_id, 0, 272),
                                            {false, 21}; %% 成长丹不足
                                        true ->
                                            DeleteGrowNum = min(MaxNum - Cat#st_cat.grow_num, GrowNum),
                                            goods:subtract_good(Player, [{?GOODS_GROW_ID_CAT, DeleteGrowNum}], 272), %% 扣除成长丹
                                            NewCat0 = Cat#st_cat{grow_num = Cat#st_cat.grow_num + DeleteGrowNum, is_change = 1},
                                            NewCat1 = cat_init:calc_attribute(NewCat0),
                                            lib_dict:put(?PROC_STATUS_CAT, NewCat1),
                                            NewPlayer = player_util:count_player_attribute(Player#player{cat_id = NewCat1#st_cat.cat_id}, true),
                                            scene_agent_dispatch:cat_update(NewPlayer),
                                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1032, 0, DeleteGrowNum),
                                            {ok, NewPlayer}
                                    end
                            end
                    end
            end
    end.

check_use_cat_dan_state(_Player, Tips) ->
    case data_grow_dan:get(?GOODS_GROW_ID_CAT) of
        Base ->
            Cat = lib_dict:get(?PROC_STATUS_CAT),  %% 玩家神兵
            {_, MaxNum} = lists:keyfind(Cat#st_cat.stage, 1, Base#base_grow_dan.stage_max_num),
            if
                Cat#st_cat.grow_num >= MaxNum ->
                    Tips; %% 成长丹已达到使用上限
                true ->
                    if
                        Base#base_grow_dan.step_lim > Cat#st_cat.stage ->
                            Tips;  %% 未达到使用阶级
                        true ->
                            GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_CAT),
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
            NewNum =
                case catch goods_attr_dan:use_goods_check(GoodsType#goods_type.goods_id, goods_util:get_goods_count(GoodsType#goods_type.goods_id), Player) of
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