%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 七月 2017 17:59
%%%-------------------------------------------------------------------
-module(fairy_soul).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("dungeon.hrl").
-include("tips.hrl").
-include("fairy_soul.hrl").
-include("daily.hrl").
-include("pet.hrl").

%% API
-export([
    get_my_fairy_soul_info/1
    , put_on_fairl_soul/3
    , upgrade/2
    , resolved_fairy_soul/2
    , exchange/2
    , put_down_fairl_soul/2
    , get_left_fairy_soul_cell_num/0
    , draw/2
    , open_draw/1
    , get_draw/1
    , get_draw_info/1
    , goods_add_exp/1
    , goods_add_chip/1
    , quick_get_draw/2
    , get_fairy_soul/2
    , check_state/1
    , get_cost/0
]).

-define(SOUL_CHIP_GOODS_ID, 30073).
%%获取仙魂信息
get_my_fairy_soul_info(Player) ->
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    #st_fairy_soul{exp = Exp, chips = Chips, pos = Pos} = StFairySoul,
    #fpet{
        type_id = PetTypeId,
        star = PetStar,
        name = PetName
    } = Player#player.pet,
    StPet = lib_dict:get(?PROC_STATUS_PET),
    PetStage = StPet#st_pet.stage,
    BasePet = data_pet:get(PetTypeId),
    case BasePet of
        [] -> Figure = 0;
        _ -> {Figure, _} = hd(tuple_to_list(BasePet#base_pet.figure))
    end,
    AttributeFairySoul = fairy_soul_attr:get_fairy_soul_all_attribute(),
    Attr = attribute_util:sum_attribute([AttributeFairySoul]),
    Cbp = attribute_util:calc_combat_power(Attr),
    Attrs = attribute_util:pack_attr(Attr),
    {Exp, Chips, Pos, PetTypeId, Figure, PetStar, PetStage, PetName, Cbp, Attrs}.

%%穿上仙魂
put_on_fairl_soul(Player, GoodsKey, Pos) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {0, Player}; %% 系统物品不存在
        FairySoul ->
            case check_put_on_fairl_soul(FairySoul, Pos) of
                {false, Code} ->
                    {Code, Player};
                true ->
                    F = fun(#weared_fairy_soul{pos = Pos0} = WearFairySoul) ->
                        ?IF_ELSE(Pos0 == Pos, [WearFairySoul], [])
                    end,
                    case lists:flatmap(F, GoodsSt#st_goods.weared_fairy_soul) of
                        [] ->
                            NewFairySoul = FairySoul#goods{
                                cell = Pos,
                                location = ?GOODS_LOCATION_BODY_FAIRY_SOUL,
                                lock = 0
                            },
                            goods_load:dbup_goods_cell_location(NewFairySoul),
                            NewGoodsDict = goods_dict:update_goods(NewFairySoul, GoodsSt#st_goods.dict),
                            goods_pack:pack_send_goods_info([NewFairySoul], GoodsSt#st_goods.sid),
                            GoodsSt1 = GoodsSt#st_goods{
                                left_fairy_soul_cell_num = GoodsSt#st_goods.left_fairy_soul_cell_num + 1,
                                dict = NewGoodsDict
                            };
                        [OldWearedFairySoul] ->
                            OldFairySoul1 = goods_util:get_goods(OldWearedFairySoul#weared_fairy_soul.goods_key),
                            OldFairySoul2 = OldFairySoul1#goods{
                                cell = 0,
                                location = ?GOODS_LOCATION_FAIRY_SOUL
                            },
                            goods_load:dbup_goods_cell_location(OldFairySoul2),
                            NewFairySoul = FairySoul#goods{
                                cell = Pos,
                                location = ?GOODS_LOCATION_BODY_FAIRY_SOUL
                            },
                            GoodsSt1 = goods_dict:update_goods([OldFairySoul2, NewFairySoul], GoodsSt),
                            goods_load:dbup_goods_cell_location(NewFairySoul),
                            goods_pack:pack_send_goods_info([OldFairySoul2, NewFairySoul], GoodsSt#st_goods.sid)
                    end,
                    NewGoodsSt = fairy_soul_attr:fairy_soul_change_recalc_attribute(GoodsSt1, NewFairySoul),
                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                    NewPlayer = player_util:count_player_attribute(Player, true),
%%                     activity:get_notice(Player, [118], true),
                    {1, NewPlayer}
            end
    end.

check_put_on_fairl_soul(FairlSoul, Pos) ->
    StFairlSoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    #st_fairy_soul{pos = ActPos} = StFairlSoul,
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    WearedSoulList = GoodsSt#st_goods.weared_fairy_soul,
    GoodsTypeInfo = data_goods:get(FairlSoul#goods.goods_id),
    if
        Pos > ActPos -> {false, 2}; %% 当前位置没有激活，不可配带
        GoodsTypeInfo#goods_type.type /= ?GOODS_TYPE_FAIRL_SOUL -> {false, 4}; %% 不是仙魂
        FairlSoul#goods.cell > 0 -> {false, 5}; %% 该仙魂已经配带
        true ->
            GoodsType0 = data_goods:get(FairlSoul#goods.goods_id),
            F = fun(WearedSoul) ->
                GoodsType = data_goods:get(WearedSoul#weared_fairy_soul.goods_id),
                GoodsType#goods_type.subtype == GoodsType0#goods_type.subtype andalso WearedSoul#weared_fairy_soul.pos =/= Pos
            end,
            case lists:any(F, WearedSoulList) of
                true -> {false, 16};
                _ ->
                    true
            end
    end.

%%仙魂升级
upgrade(Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    case check_upgrade(Player, GoodsKey) of
        {false, Code} ->
            {Code, Player};
        {add_exp, FairySoul, NeedExp} ->
            NewStFairySoul = StFairySoul#st_fairy_soul{exp = 0},
            lib_dict:put(?PROC_STATUS_FAIRY_SOUL, NewStFairySoul),
            fairy_soul_load:dbup_fairy_soul_info(NewStFairySoul),
            NewFairySoul = FairySoul#goods{exp = FairySoul#goods.exp + NeedExp},
            goods_load:dbup_goods_lv_exp(NewFairySoul),
            NewGoodsSt = goods_dict:update_goods([NewFairySoul], GoodsSt),
            goods_pack:pack_send_goods_info([NewFairySoul], GoodsSt#st_goods.sid),
            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
            log_fairy_soul_upgrade(Player#player.key, Player#player.nickname, Player#player.lv, NeedExp, FairySoul#goods.goods_lv, FairySoul#goods.goods_lv, FairySoul#goods.key, FairySoul#goods.goods_id),
            activity:get_notice(Player, [110], true),
            {1, Player};
        {true, FairySoul, NeedExp} ->
            NewStFairySoul = StFairySoul#st_fairy_soul{exp = StFairySoul#st_fairy_soul.exp - NeedExp},
            lib_dict:put(?PROC_STATUS_FAIRY_SOUL, NewStFairySoul),
            fairy_soul_load:dbup_fairy_soul_info(NewStFairySoul),
            NewFairySoul = FairySoul#goods{goods_lv = FairySoul#goods.goods_lv + 1, exp = 0},
            goods_load:dbup_goods_lv_exp(NewFairySoul),
            GoodsSt1 = goods_dict:update_goods([NewFairySoul], GoodsSt),
            goods_pack:pack_send_goods_info([NewFairySoul], GoodsSt#st_goods.sid),
            NewGoodsSt = fairy_soul_attr:fairy_soul_change_recalc_attribute(GoodsSt1, NewFairySoul),
            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
            NewPlayer = player_util:count_player_attribute(Player, true),
            log_fairy_soul_upgrade(Player#player.key, Player#player.nickname, Player#player.lv, NeedExp, FairySoul#goods.goods_lv, FairySoul#goods.goods_lv + 1, FairySoul#goods.key, FairySoul#goods.goods_id),
            activity:get_notice(Player, [110], true),
            {1, NewPlayer}
    end.

check_upgrade(_Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {false, 6}; %% 系统物品不存在
        FairySoul ->
            FairySoulLv = FairySoul#goods.goods_lv,
            GoodsTypeInfo = data_goods:get(FairySoul#goods.goods_id),
            BaseFairySoul = data_fairy_soul:get(GoodsTypeInfo#goods_type.subtype, FairySoulLv, GoodsTypeInfo#goods_type.color),
            if
                StFairySoul#st_fairy_soul.exp < 1 ->
                    {false, 8}; %% 经验不足
                BaseFairySoul == [] ->
                    {false, 7}; %% 满级了
                BaseFairySoul#base_fairy_soul.need_exp == 0 ->
                    {false, 7}; %% 满级了
                StFairySoul#st_fairy_soul.exp =< 0 ->
                    {false, 8}; %% 经验不足
                StFairySoul#st_fairy_soul.exp + FairySoul#goods.exp < BaseFairySoul#base_fairy_soul.need_exp ->
                    {add_exp, FairySoul, StFairySoul#st_fairy_soul.exp}; %% 剩余经验全加上
                true ->
                    {true, FairySoul, max(0, BaseFairySoul#base_fairy_soul.need_exp - FairySoul#goods.exp)}
            end
    end.


%%分解仙魂
resolved_fairy_soul(Player, []) ->
    {0, Player, 0};

resolved_fairy_soul(Player, GoodsKeyList) ->
    resolved_fairy_soul(Player, util:list_filter_repeat(GoodsKeyList), 0, []).

resolved_fairy_soul(Player, [], AccExp, DelGoodsList) ->
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    NewStFairySoul = StFairySoul#st_fairy_soul{exp = StFairySoul#st_fairy_soul.exp + AccExp},
    goods_util:reduce_goods_key_list(Player, [{Goods#goods.key, 1} || Goods <- DelGoodsList], 567),
    lib_dict:put(?PROC_STATUS_FAIRY_SOUL, NewStFairySoul),
    fairy_soul_load:dbup_fairy_soul_info(NewStFairySoul),
    activity:get_notice(Player, [110], true),
    {1, Player, AccExp};

resolved_fairy_soul(OldPlayer, [GoodsKey | T], OldAccExp, DelGoodsList) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            resolved_fairy_soul(OldPlayer, T, OldAccExp, DelGoodsList); %% 系统物品不存在
        FairySoul ->
            FairySoulExp = FairySoul#goods.exp,
            GoodsTypeInfo = data_goods:get(FairySoul#goods.goods_id),
            if
                FairySoul#goods.cell > 0 -> %% 穿在身上的符文不可以分解
                    resolved_fairy_soul(OldPlayer, T, OldAccExp, DelGoodsList);
                true ->
                    F = fun(GoodsLv) ->
                        #base_fairy_soul{need_exp = NeedExp} = data_fairy_soul:get(GoodsTypeInfo#goods_type.subtype, GoodsLv, GoodsTypeInfo#goods_type.color),
                        NeedExp
                    end,
                    AddExp =
                        if FairySoul#goods.goods_lv > 1 ->
                            lists:sum(lists:map(F, lists:seq(1, FairySoul#goods.goods_lv - 1))) + GoodsTypeInfo#goods_type.extra_val;
                            true ->
                                GoodsTypeInfo#goods_type.extra_val
                        end,
                    log_fairy_soul_resolved(OldPlayer#player.key, OldPlayer#player.nickname, OldPlayer#player.lv, AddExp, GoodsKey, FairySoul#goods.goods_id),
                    resolved_fairy_soul(OldPlayer, T, OldAccExp + AddExp + FairySoulExp, [FairySoul | DelGoodsList])
            end
    end.

%% 兑换仙魂
exchange(Player, GoodsId) ->
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    CostChip = data_fairy_soul_exchange:get(GoodsId),
    Cell = get_left_fairy_soul_cell_num(),
    if
        StFairySoul#st_fairy_soul.chips < CostChip -> {9, Player};
        Cell =< 0 -> {15, Player};
        true ->
            NewStFairySoul = StFairySoul#st_fairy_soul{chips = StFairySoul#st_fairy_soul.chips - CostChip},
            lib_dict:put(?PROC_STATUS_FAIRY_SOUL, NewStFairySoul),
            fairy_soul_load:dbup_fairy_soul_info(NewStFairySoul),
            GiveGoodsList = goods:make_give_goods_list(623, [{GoodsId, 1, ?GOODS_LOCATION_FAIRY_SOUL, 0, []}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            activity:get_notice(Player, [110], true),
            {1, NewPlayer}
    end.

put_down_fairl_soul(Player, Pos) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case check_put_down_fairl_soul(Pos) of
        {false, Code} ->
            {Code, Player};
        {true, OldWearedFairySoul} ->
            OldFairySoul1 = goods_util:get_goods(OldWearedFairySoul#weared_fairy_soul.goods_key),
            OldFairySoul2 = OldFairySoul1#goods{
                cell = 0,
                location = ?GOODS_LOCATION_FAIRY_SOUL
            },
            goods_load:dbup_goods_cell_location(OldFairySoul2),
            GoodsSt1 = goods_dict:update_goods([OldFairySoul2], GoodsSt),
            {value, _, List} = lists:keytake(Pos, #weared_fairy_soul.pos, GoodsSt#st_goods.weared_fairy_soul),
            GoodsSt2 = GoodsSt1#st_goods{weared_fairy_soul = List, left_fairy_soul_cell_num = GoodsSt#st_goods.left_fairy_soul_cell_num - 1},
            lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
            fairy_soul_attr:fairy_soul_recalc_attribute(),
            goods_pack:pack_send_goods_info([OldFairySoul2], GoodsSt#st_goods.sid),
            NewPlayer = player_util:count_player_attribute(Player, true),
            activity:get_notice(Player, [110], true),
            {1, NewPlayer}
    end.

check_put_down_fairl_soul(Pos) ->
    StFairlSoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    #st_fairy_soul{pos = ActPos} = StFairlSoul,
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    if
        Pos > ActPos -> {false, 2}; %% 当前位置没有激活，不可配带
        true ->
            case lists:keyfind(Pos, #weared_fairy_soul.pos, GoodsSt#st_goods.weared_fairy_soul) of
                false ->
                    {false, 3};
                OldWearedFairySoul ->
                    {true, OldWearedFairySoul}
            end
    end.

draw(Player, Color) ->
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    case check_draw(Player, StFairySoul#st_fairy_soul.floor) of
        {false, Res} ->
            {Res, Player, 0, 0};
        {ok, Base, Cost} ->
            daily:increment(?DAILY_FAIRY_SOUL_TIMES, 1),
            {ok, NewFloor, GoodsId, IsFirst} = draw_one(Player, Base, StFairySoul#st_fairy_soul.floor, StFairySoul#st_fairy_soul.is_first),
            List = StFairySoul#st_fairy_soul.list,
            GoodsType = data_goods:get(GoodsId),
            if Color >= GoodsType#goods_type.color ->
                IsResolved = 1,
                NewStFairySoul = StFairySoul#st_fairy_soul{list = List, floor = NewFloor, is_first = IsFirst},
                lib_dict:put(?PROC_STATUS_FAIRY_SOUL, NewStFairySoul),
                fairy_soul_load:dbup_fairy_soul_info(NewStFairySoul),
                goods_add_exp(GoodsType#goods_type.extra_val);
                true ->
                    NewList = [GoodsId | List],
                    IsResolved = 0,
                    NewStFairySoul = StFairySoul#st_fairy_soul{list = NewList, floor = NewFloor, is_first = IsFirst},
                    lib_dict:put(?PROC_STATUS_FAIRY_SOUL, NewStFairySoul),
                    fairy_soul_load:dbup_fairy_soul_info(NewStFairySoul)
            end,
            log_fairy_soul(Player#player.key, Player#player.nickname, Player#player.lv, Cost, [{GoodsId, 1}]),
            NewPlayer = money:add_coin(Player, -Cost, 299, GoodsId, 1),
            {1, NewPlayer, GoodsId, IsResolved}
    end.

draw_one(Player, Base, Floor0, IsFirst0) ->
    #base_fairy_soul_draw{
        type_ratio = TypeRatio,
        color_ratio = ColorRatio,
        floor_ratio = FloorRatio
    } = Base,
    Type0 = util:list_rand_ratio(TypeRatio),
    Color = util:list_rand_ratio(ColorRatio),
    Floor = util:list_rand_ratio(FloorRatio),
    NewFloor = if Floor0 == 5 -> 1;
                   Floor < 0 -> 1;
                   true -> Floor0 + 1
               end,
    Type = ?IF_ELSE(IsFirst0 == 1, 4, Type0),
    case Type of
        1 -> %% 仙魂
            GoodsList = data_fairy_soul_goods:get_color(Color),
            F = fun({Id, _}) ->
                GoodsType = data_goods:get(Id),
                GoodsType#goods_type.subtype /= ?GOODS_SUBTYPE_FAIRY_SOUL_EXP andalso GoodsType#goods_type.subtype /= ?GOODS_SUBTYPE_FAIRY_SOUL_CHIP
            end,
            GoodsList1 = lists:filter(F, GoodsList),
            GoodsId = util:list_rand_ratio(GoodsList1),
            if Color >= 4 ->
                Content = io_lib:format(t_tv:get(250), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
                notice:add_sys_notice(Content, 250);
                true -> skip
            end,
            IsFirst = IsFirst0;
        2 -> %% 经验
            GoodsId = get_exp(Color),
            IsFirst = IsFirst0;
        3 -> %% 碎片
            GoodsId = ?SOUL_CHIP_GOODS_ID,
            IsFirst = IsFirst0;
        4 -> %% 首次付费，必得金色仙魂
            GoodsList = data_fairy_soul_goods:get_color(4),
            F = fun({Id, _}) ->
                GoodsType = data_goods:get(Id),
                GoodsType#goods_type.subtype /= ?GOODS_SUBTYPE_FAIRY_SOUL_EXP andalso GoodsType#goods_type.subtype /= ?GOODS_SUBTYPE_FAIRY_SOUL_CHIP
            end,
            GoodsList1 = lists:filter(F, GoodsList),
            GoodsId = util:list_rand_ratio(GoodsList1),
            Content = io_lib:format(t_tv:get(250), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
            notice:add_sys_notice(Content, 250),
            IsFirst = 2
    end,
    {ok, NewFloor, GoodsId, IsFirst}.

check_draw(Player, Id) ->
    Base = data_fairy_soul_draw:get(Id),
    Count = daily:get_count(?DAILY_FAIRY_SOUL_TIMES),
    Cost = ?IF_ELSE(Count =< ?DAILY_FAIRY_SOUL_FREE_TIMES, 0, Base#base_fairy_soul_draw.cost),
    case money:is_enough(Player, Cost, coin) of
        false -> {false, 10};
        _ ->
            StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
            Len = length(StFairySoul#st_fairy_soul.list),
            if
                Len >= ?FAIRY_SOUL_LIST_LIMIT ->
                    {false, 13};
                true ->
                    {ok, Base, Cost}
            end
    end.

open_draw(Player) ->
    case check_open_draw(Player) of
        {false, Res} ->
            {Res, Player};
        ok ->
            NewPlayer = money:add_no_bind_gold(Player, -get_cost(), 300, 0, 0),
            St = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
            IsFirst = ?IF_ELSE(St#st_fairy_soul.is_first == 0, 1, St#st_fairy_soul.is_first),
            NewSt = St#st_fairy_soul{is_first = IsFirst, floor = 4},
            lib_dict:put(?PROC_STATUS_FAIRY_SOUL, NewSt),
            fairy_soul_load:dbup_fairy_soul_info(NewSt),
            daily:increment(?DAILY_GOLD_FAIRY_SOUL_TIMES, 1),
            {1, NewPlayer}
    end.

check_open_draw(Player) ->
    St = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    Floor = St#st_fairy_soul.floor,
    Flag = money:is_enough(Player, get_cost(), gold),
    Count = daily:get_count(?DAILY_GOLD_FAIRY_SOUL_TIMES),
    if
        Floor >= 4 -> {false, 12};
        Player#player.vip_lv < 4 -> {false, 17};
        not Flag -> {false, 11};
        Count >= 50 -> {false, 18};
        true -> ok
    end.

get_draw(Player) ->
    St = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    List = St#st_fairy_soul.list,
    F = fun(GoodsId, {ExpList0, List0}) ->
        GoodsType = data_goods:get(GoodsId),
        if
            GoodsType#goods_type.subtype == ?GOODS_SUBTYPE_FAIRY_SOUL_CHIP ->
                {[GoodsId | ExpList0], List0};
            true ->
                {ExpList0, [GoodsId | List0]}
        end
    end,
    {ChipList1, SoulList1} = lists:foldl(F, {[], []}, List),
    ChipList = [{X, 1} || X <- ChipList1],
    SoulList = [{X, 1} || X <- SoulList1],
    CellNum = get_left_fairy_soul_cell_num(),
    if
        CellNum >= length(SoulList) ->
            lib_dict:put(?PROC_STATUS_FAIRY_SOUL, St#st_fairy_soul{list = []}),
            fairy_soul_load:dbup_fairy_soul_info(St#st_fairy_soul{list = []}),
            {ok, NewPlayer1} = goods:give_goods(Player, goods:make_give_goods_list(299, SoulList ++ ChipList)),
            activity:get_notice(Player, [110], true),
            {1, NewPlayer1};
        true ->
            GiveList = lists:sublist(SoulList, CellNum),
            RemainList0 = lists:sublist(SoulList, CellNum + 1, length(SoulList1)),
            RemainList = [X || {X, _} <- RemainList0],
            lib_dict:put(?PROC_STATUS_FAIRY_SOUL, St#st_fairy_soul{list = RemainList}),
            fairy_soul_load:dbup_fairy_soul_info(St#st_fairy_soul{list = RemainList}),
            {ok, NewPlayer1} = goods:give_goods(Player, goods:make_give_goods_list(299, GiveList ++ ChipList)),
            activity:get_notice(Player, [110], true),
            {15, NewPlayer1}
    end.

get_draw_info(_Player) ->
    St = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    Exp = St#st_fairy_soul.exp,
    Chips = St#st_fairy_soul.chips,
    Floor = St#st_fairy_soul.floor,
%%     MaxFloor = St#st_fairy_soul.max_floor,
    List = St#st_fairy_soul.list,
    {Floor, Floor, Exp, Chips, get_cost(), lists:reverse(List)}.

goods_add_exp(Num) ->
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    NewStFairySoul = StFairySoul#st_fairy_soul{exp = StFairySoul#st_fairy_soul.exp + Num},
    lib_dict:put(?PROC_STATUS_FAIRY_SOUL, NewStFairySoul),
    fairy_soul_load:dbup_fairy_soul_info(NewStFairySoul),
    ok.

goods_add_chip(Num) ->
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    NewStFairySoul = StFairySoul#st_fairy_soul{chips = StFairySoul#st_fairy_soul.chips + Num},
    lib_dict:put(?PROC_STATUS_FAIRY_SOUL, NewStFairySoul),
    fairy_soul_load:dbup_fairy_soul_info(NewStFairySoul),
    ok.

quick_get_draw(Player, ColorLimit) ->
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    List = StFairySoul#st_fairy_soul.list,
    Remain = ?FAIRY_SOUL_LIST_LIMIT - length(List),
    %% 猎取到满背包为止
    F = fun(_Id, {Res0, List0, {Floor0, IsFirst0}, Player0,AllCost0}) ->
        case check_draw(Player0, Floor0) of
            {false, Res} ->
                {Res, List0, {Floor0, IsFirst0}, Player0,AllCost0};
            {ok, Base, Cost} ->
                daily:increment(?DAILY_FAIRY_SOUL_TIMES, 1),
                {ok, Floor1, GoodsId, IsFirst1} = draw_one(Player, Base, Floor0, IsFirst0),
%%                 GoodsType = data_goods:get(GoodsId),
%%                 Player1 = money:add_coin(Player0, -Cost, 299, GoodsId, 1),
                log_fairy_soul(Player#player.key, Player#player.nickname, Player#player.lv, Cost, [{GoodsId, 1}]),
                {Res0, [GoodsId | List0], {Floor1, IsFirst1}, Player0#player{coin = Player0#player.coin-Cost},AllCost0+Cost}
        end
    end,
    {Res1, BeforeList0, {NewFloor, NewIsFirst}, _NewPlayer0,AllCost} = lists:foldl(F, {1, [], {StFairySoul#st_fairy_soul.floor, StFairySoul#st_fairy_soul.is_first}, Player,0}, lists:seq(1, Remain)),
    NewPlayer = money:add_coin(Player, -AllCost, 299, 0, 0),
    BeforeList1 = BeforeList0 ++ List,
    %% 一键转化
    F2 = fun(GoodsId, {List2, Num}) ->
        GoodsType = data_goods:get(GoodsId),
        if ColorLimit >= GoodsType#goods_type.color ->
%%             goods_add_exp(GoodsType#goods_type.extra_val),
            {List2, Num + GoodsType#goods_type.extra_val};
            true ->
                {[GoodsId | List2], Num}
        end
    end,
    {LaterList1, SumExp} = lists:foldl(F2, {[], 0}, BeforeList1),
    NewStFairySoul = StFairySoul#st_fairy_soul{list = LaterList1, floor = NewFloor, is_first = NewIsFirst, exp = StFairySoul#st_fairy_soul.exp + SumExp},
    fairy_soul_load:dbup_fairy_soul_info(NewStFairySoul),
    lib_dict:put(?PROC_STATUS_FAIRY_SOUL, NewStFairySoul),
    Res2 = ?IF_ELSE(Remain == 0, 13, Res1),
    activity:get_notice(Player, [110], true),
    {Res2, NewPlayer, BeforeList1, LaterList1, BeforeList0}.

get_fairy_soul(Player, GoodsId) ->
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    List = StFairySoul#st_fairy_soul.list,
    case lists:member(GoodsId, List) of
        false -> {14, Player};
        true ->
            Cell = get_left_fairy_soul_cell_num(),
            if
                Cell =< 0 -> {15, Player};
                true ->
                    List2 = lists:delete(GoodsId, List),
                    lib_dict:put(?PROC_STATUS_FAIRY_SOUL, StFairySoul#st_fairy_soul{list = List2}),
                    fairy_soul_load:dbup_fairy_soul_info(StFairySoul#st_fairy_soul{list = List2}),
                    {ok, NewPlayer1} = goods:give_goods(Player, goods:make_give_goods_list(299, [{GoodsId, 1}])),
                    activity:get_notice(Player, [110], true),
                    {1, NewPlayer1}
            end
    end.

check_state(_Player) ->
    StFairySoul = lib_dict:get(?PROC_STATUS_FAIRY_SOUL),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    FairySoulList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_FAIRY_SOUL),
    if
        length(FairySoulList) == 0 ->
            Code1 = 0;
        true ->
            Code1 = ?IF_ELSE(StFairySoul#st_fairy_soul.pos > length(GoodsSt#st_goods.weared_fairy_soul), 1, 0)
    end,
    F = fun(#weared_fairy_soul{goods_key = GoodsKey}) ->
        case check_upgrade(_Player, GoodsKey) of
            {true, _, _} -> true;
            {add_exp, _, _} -> true;
            _ -> false
        end
    end,
    R = lists:any(F, GoodsSt#st_goods.weared_fairy_soul),
    Code2 = ?IF_ELSE(R == true, 1, 0),
    max(Code1, Code2).

get_left_fairy_soul_cell_num() ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsSt#st_goods.left_fairy_soul_cell_num.

get_exp(Color) when Color >= 3 -> 30072;
get_exp(Color) when Color >= 2 -> 30071;
get_exp(Color) when Color >= 1 -> 30070;
get_exp(_Color) -> 30070.

get_cost() ->
    Count = daily:get_count(?DAILY_GOLD_FAIRY_SOUL_TIMES),
    data_fairy_soul_open_cost:get(Count + 1).

log_fairy_soul(Pkey, Nickname, _Lv, LogCost, GoodsList) ->
    Sql = io_lib:format("insert into  log_fairy_soul (pkey, nickname,gold,goods_list,time) VALUES(~p,'~s',~p,'~s',~p)",
        [Pkey, Nickname, LogCost, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.

log_fairy_soul_upgrade(Pkey, Nickname, _Lv, Exp, OldLv, NewLv, GoodsKey, GoodsId) ->
    Sql = io_lib:format("insert into  log_fairy_soul_upgrade (pkey, nickname,exp,old_lv,new_lv,goods_key,goods_id, time) VALUES(~p,'~s',~p,~p,~p,~p,~p,~p)",
        [Pkey, Nickname, Exp, OldLv, NewLv, GoodsKey, GoodsId, util:unixtime()]),
    log_proc:log(Sql),
    ok.

log_fairy_soul_resolved(Pkey, Nickname, _Lv, Exp, GoodsKey, GoodsId) ->
    Sql = io_lib:format("insert into  log_fairy_soul_resolved (pkey, nickname,exp,goods_key,goods_id, time) VALUES(~p,'~s',~p,~p,~p,~p)",
        [Pkey, Nickname, Exp, GoodsKey, GoodsId, util:unixtime()]),
    log_proc:log(Sql),
    ok.
