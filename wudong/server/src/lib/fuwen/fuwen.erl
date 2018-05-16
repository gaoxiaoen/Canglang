%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2017 15:47
%%%-------------------------------------------------------------------
-module(fuwen).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("fuwen.hrl").
-include("goods.hrl").
-include("dungeon.hrl").
-include("tips.hrl").

%% API
-export([
    gm_pos/0,
    repair/0,

    get_my_fuwen_info/1, %% 获取自己的符文信息
    put_on_fuwen/3, %%穿上符文
    upgrade/2, %% 符文升级
    resolved_fuwen/2, %%分解符文
    exchange/2, %%兑换符文
    update_pos/1, %% 挑战符文副本后开启镶孔
    check_state/2,
    lookup/3, %%符文预览
    lookup_notice/1,
    compound/3
]).

%% 内部接口
-export([
    goods_add_exp/1,
    goods_add_chip/1,
    notice_client/3,
    get_notice_player/1
]).

repair() ->
    Sql = io_lib:format("select pkey,dungeon_id from log_dungeon_pass_info where `time` > 1509577320 and `time` < 1509606000 and dungeon_type = 18 ORDER BY pkey ", []),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([Pkey, DungeonId], AccList) ->
                #base_dun_fuwen_tower{first_reward = FirstRewardList} = data_dungeon_fuwen_tower:get_by_dunid(DungeonId),
                {11117, BaseNum} = lists:keyfind(11117, 1, FirstRewardList),
                case lists:keytake(Pkey, 1, AccList) of
                    false ->
                        [{Pkey, BaseNum} | AccList];
                    {value, {Pkey, AccExp}, Rest} ->
                        [{Pkey, BaseNum + AccExp} | Rest]
                end
            end,
            RepairList = lists:foldl(F, [], Rows),
            FF = fun({Pkey, Exp}) ->
                Title = ?T("符文精华返还"),
                Content = ?T("尊敬的玩家：由于网络波动，导致你挑战符文塔玩法有部分符文精华没有获得，在攻城狮的努力下，现已找回您丢失的符文精华；感谢您对游戏的支持，有任何意见可以反馈给我们！"),
                mail:sys_send_mail([Pkey], Title, Content, [{11117, Exp}])
            end,
            lists:map(FF, RepairList),
            ok;
        _ -> skip
    end.

%% gm相关
%% @fuwenpos 激活8个孔
%% @goods_5101001_1 加1件蓝色攻击符文
gm_pos() ->
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    NewStFuwen = StFuwen#st_fuwen{pos = 8},
    lib_dict:put(?PROC_STATUS_FUWEN, NewStFuwen),
    fuwen_load:dbup_self_fuwen_info(NewStFuwen),
    ok.

update_pos(Pos) ->
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    NewStFuwen = StFuwen#st_fuwen{pos = max(Pos, StFuwen#st_fuwen.pos)},
    lib_dict:put(?PROC_STATUS_FUWEN, NewStFuwen),
    ?IF_ELSE(Pos == StFuwen#st_fuwen.pos, ok, fuwen_load:dbup_self_fuwen_info(NewStFuwen)),
    ok.

lookup(_Player, GoodsKey1, GoodsKey2) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    Goods1 = goods_util:get_goods(GoodsKey1, GoodsSt#st_goods.dict),
    Goods2 = goods_util:get_goods(GoodsKey2, GoodsSt#st_goods.dict),
    TotalExp = get_exp(Goods1),
    NewGoods = cacl_upgrade(Goods2, TotalExp),
    Attr1 = fuwen_attr:calc_singleton_fuwen_attribute(Goods1),
    Attr2 = fuwen_attr:calc_singleton_fuwen_attribute(NewGoods),
    Cbp1 = attribute_util:calc_combat_power(Attr1),
    Cbp2 = attribute_util:calc_combat_power(Attr2),
    [[GoodsKey1, Cbp1, Goods1#goods.goods_lv] ++ get_pro_attr(Attr1), [GoodsKey2, Cbp2, NewGoods#goods.goods_lv] ++ get_pro_attr(Attr2)].

get_pro_attr(Attr) ->
    #attribute{
        hp_lim = HpLim,
        att = Att,     %%攻击
        def = Def,    %%防御
        hit = Hit,     %%命中
        dodge = Dodge,   %%闪躲
        crit = Crit,    %%暴击
        ten = Ten,     %%坚韧
        crit_inc = CritInc,%%暴击伤害
        crit_dec = CritDec,%%暴击免伤
        hurt_inc = HurtInc,%%伤害加成
        hurt_dec = HurtDec,%%伤害减免
        exp_add = ExpAdd
    } = Attr,
    [round(lists:max([Att, HpLim, Def, Hit, Dodge, Crit, Ten, CritInc, CritDec, HurtInc, HurtDec, ExpAdd]))].

cacl_upgrade(Goods, 0) ->
    Goods;

cacl_upgrade(Goods, Total) ->
    case excharge(Goods, Total) of
        {true, Fuwen, NeedExp} ->
            cacl_upgrade(Fuwen#goods{goods_lv = Goods#goods.goods_lv+1, exp = 0}, Total - NeedExp);
        {add_exp, Fuwen, TotalExp} ->
            Fuwen#goods{exp = Fuwen#goods.exp + TotalExp};
        _ ->
            Goods
    end.

get_exp(Goods) ->
    GoodsTypeInfo = data_goods:get(Goods#goods.goods_id),
    F = fun(GoodsLv) ->
        #base_fuwen{need_exp = NeedExp} = data_fuwen:get(GoodsTypeInfo#goods_type.subtype, GoodsLv, GoodsTypeInfo#goods_type.color),
        NeedExp
    end,
    AddExp =
        if
            Goods#goods.goods_lv > 1 ->
                lists:sum(lists:map(F, lists:seq(1, Goods#goods.goods_lv - 1)));
            true ->0
        end,
    AddExp.

check_state(Player, Tips) ->
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    State = get_notice_player(Player),
    if
        State == 1 ->
            AllFuwen = goods_util:get_goods_list_by_location(?GOODS_LOCATION_FUWEN),
            GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
            WearFuwenList = GoodsSt#st_goods.weared_fuwen,
            F = fun(Fuwen) ->
                #goods_type{subtype = FuwenSubType} = data_goods:get(Fuwen#goods.goods_id),
                F0 = fun(#goods{goods_id = GoodsId0}) ->
                    #goods_type{subtype = FuwenSubType0} = data_goods:get(GoodsId0),
                    FuwenSubType0
                end,
                WerFuwenSubTypeList = lists:map(F0, WearFuwenList),
                case lists:member(FuwenSubType,WerFuwenSubTypeList) of
                    false ->
                        case check_put_on_fuwen(Fuwen, StFuwen#st_fuwen.pos) of
                            true -> true;
                            _ -> false
                        end;
                    _ -> false
                end
            end,
            R = lists:any(F, AllFuwen),
            ?IF_ELSE(R == true, Tips#tips{state = 1}, Tips);
        true ->
            Tips
    end.

goods_add_exp(Num) ->
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    NewStFuwen = StFuwen#st_fuwen{exp = StFuwen#st_fuwen.exp + Num},
    lib_dict:put(?PROC_STATUS_FUWEN, NewStFuwen),
    fuwen_load:dbup_self_fuwen_info(NewStFuwen),
    ok.

goods_add_chip(Num) ->
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    NewStFuwen = StFuwen#st_fuwen{chips = StFuwen#st_fuwen.chips + Num},
    lib_dict:put(?PROC_STATUS_FUWEN, NewStFuwen),
    fuwen_load:dbup_self_fuwen_info(NewStFuwen),
    ok.

notice_client(Player, GiveGiftList, BaseGoodsId) ->
    L = lists:map(fun(#give_goods{goods_id = GoodsId}) -> GoodsId end, GiveGiftList),
    F1 = fun(GoodsId1, AccList) ->
        F0 = fun(#give_goods{goods_id = GoodsId0, num = Num0}) ->
            ?IF_ELSE(GoodsId1 == GoodsId0, [Num0], [])
        end,
        L1 = lists:flatmap(F0, GiveGiftList),
        [[GoodsId1, lists:sum(L1)]|AccList]
    end,
    L2 = lists:foldl(F1, [], util:list_filter_repeat(L)),
    L3 = util:list_shuffle(L2),
    {ok, Bin} = pt_150:write(15025, {BaseGoodsId, L3}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_notice_player(_Player) ->
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    FuwenList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_FUWEN),
    if
        length(FuwenList) == 0 ->
            Code1 = 0;
        true ->
            Code1 = ?IF_ELSE(StFuwen#st_fuwen.pos > length(GoodsSt#st_goods.weared_fuwen), 1, 0)
    end,
    F = fun(#weared_fuwen{goods_key = GoodsKey}) ->
        case catch check_upgrade(_Player, GoodsKey) of
            {true, _, _} -> true;
            _ -> false
        end
    end,
    R = lists:any(F, GoodsSt#st_goods.weared_fuwen),
    Code2 = ?IF_ELSE(R == true, 1, 0),
    max(Code1, Code2).

%%获取符文信息
get_my_fuwen_info(_Player) ->
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    #st_fuwen{exp = Exp, chips = Chips, pos = Pos} = StFuwen,
    {Layer, SubLayer} = dungeon_fuwen_tower:get_dun_info(_Player),
    StDungeonFuwenTower = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    UnLockList = StDungeonFuwenTower#st_dun_fuwen_tower.unlock_fuwen_subtype,
    {Exp, Chips, Pos, Layer, SubLayer, UnLockList}.

check_put_on_fuwen(Fuwen, Pos) ->
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    #st_fuwen{pos = ActPos} = StFuwen,
    StDungeonFuwen = lib_dict:get(?PROC_STATUS_DUN_FUWEN_TOWER),
    #st_dun_fuwen_tower{unlock_fuwen_subtype = UnLocalSubTypeList} = StDungeonFuwen,
    GoodsTypeInfo = data_goods:get(Fuwen#goods.goods_id),
    IsUnlock = lists:member(GoodsTypeInfo#goods_type.subtype, UnLocalSubTypeList),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    if
        IsUnlock == false -> {false, 11}; %% 当前子类型符文为解锁
        Pos > ActPos -> {false, 2}; %% 当前位置没有激活，不可配带
        GoodsTypeInfo#goods_type.color == 1 -> {false, 3}; %% 白色符文不可配带
        GoodsTypeInfo#goods_type.subtype == ?GOODS_SUBTYPE_FUWEN_WHITE -> {false, 3}; %% 经验类型的符文不可配带
        GoodsTypeInfo#goods_type.type /= ?GOODS_TYPE_FUWEN -> {false, 4}; %% 不是符文
        Fuwen#goods.cell > 0 -> {false, 5}; %% 该符文已经配带
        true ->
            F = fun(#weared_equip{pos = Pos0, goods_id = GoodsId0}) ->
                #goods_type{subtype = SubType0} = data_goods:get(GoodsId0),
                if
                    SubType0 == GoodsTypeInfo#goods_type.subtype andalso Pos /= Pos0 -> [{Pos0, SubType0}];
                    true -> []
                end
            end,
            PosInfoList =  lists:flatmap(F, GoodsSt#st_goods.weared_equip),
            if
                length(PosInfoList) > 0 ->
                    {false, 5}; %% 该类型的符文已佩戴
                true ->
                    true
            end
    end.


%%穿上符文
put_on_fuwen(Player, GoodsKey, Pos) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {0, Player}; %% 系统物品不存在
        Fuwen ->
            case check_put_on_fuwen(Fuwen, Pos) of
                {false, Code} ->
                    {Code, Player};
                true ->
                    F = fun(#weared_fuwen{pos = Pos0} = WearFuwen) ->
                        ?IF_ELSE(Pos0 == Pos, [WearFuwen], [])
                    end,
                    case lists:flatmap(F, GoodsSt#st_goods.weared_fuwen) of
                        [] ->
                            NewFuwen = Fuwen#goods{
                                cell = Pos,
                                location = ?GOODS_LOCATION_BODY_FUWEN
                            },
                            goods_load:dbup_goods_cell_location(NewFuwen),
                            NewGoodsDict = goods_dict:update_goods(NewFuwen, GoodsSt#st_goods.dict),
                            goods_pack:pack_send_goods_info([NewFuwen], GoodsSt#st_goods.sid),
                            GoodsSt1 = GoodsSt#st_goods{
                                leftfuwen_cell_num = GoodsSt#st_goods.leftfuwen_cell_num + 1,
                                dict = NewGoodsDict
                            };
                        [OldWearedFuwen] ->
                            #goods_type{subtype = Subtype1} = data_goods:get(OldWearedFuwen#weared_fuwen.goods_id),
                            #goods_type{subtype = Subtype2} = data_goods:get(Fuwen#goods.goods_id),
                            OldFuwen1 = goods_util:get_goods(OldWearedFuwen#weared_fuwen.goods_key),
                            if
                                Subtype1 == Subtype2 -> %% 同种类型的符文，替换后，分界掉
                                    OldFuwen2 = OldFuwen1#goods{
                                        cell = 0,
                                        location = ?GOODS_LOCATION_FUWEN
                                    },
                                    goods_load:dbup_goods_cell_location(OldFuwen2),
                                    NewFuwen = Fuwen#goods{
                                        cell = Pos,
                                        location = ?GOODS_LOCATION_BODY_FUWEN
                                    },
                                    fuwen_log:put_on(Fuwen, NewFuwen, Player),
                                    fuwen_log:put_on(OldFuwen1, OldFuwen2, Player);
                                true ->
                                    OldFuwen2 = OldFuwen1#goods{
                                        cell = 0,
                                        location = ?GOODS_LOCATION_FUWEN
                                    },
                                    goods_load:dbup_goods_cell_location(OldFuwen2),
                                    NewFuwen = Fuwen#goods{
                                        cell = Pos,
                                        location = ?GOODS_LOCATION_BODY_FUWEN
                                    },
                                    fuwen_log:put_on(Fuwen, NewFuwen, Player),
                                    fuwen_log:put_on(OldFuwen1, OldFuwen2, Player)
                            end,
                            GoodsSt1 = goods_dict:update_goods([OldFuwen2, NewFuwen], GoodsSt),
                            goods_load:dbup_goods_cell_location(NewFuwen),
                            goods_pack:pack_send_goods_info([OldFuwen2, NewFuwen], GoodsSt#st_goods.sid)
%%                             ?DEBUG("OldFuwen2~p, NewFuwen:~p~n", [OldFuwen2#goods.exp, NewFuwen#goods.exp])
                    end,
                    NewGoodsSt = fuwen_attr:fuwen_change_recalc_attribute(GoodsSt1, NewFuwen),
                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    activity:get_notice(Player, [118], true),
                    {1, NewPlayer}
            end
    end.

%%符文升级
upgrade(Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    case check_upgrade(Player, GoodsKey) of
        {false, Code} ->
            {Code, Player};
        {true, Fuwen, NeedExp} ->
            NewStFuwen = StFuwen#st_fuwen{exp = StFuwen#st_fuwen.exp - NeedExp},
            lib_dict:put(?PROC_STATUS_FUWEN, NewStFuwen),
            fuwen_load:dbup_self_fuwen_info(NewStFuwen),
            NewFuwen = Fuwen#goods{goods_lv = Fuwen#goods.goods_lv + 1, exp = 0},
            goods_load:dbup_goods_lv_exp(NewFuwen),
            GoodsSt1 = goods_dict:update_goods([NewFuwen], GoodsSt),
            goods_pack:pack_send_goods_info([NewFuwen], GoodsSt#st_goods.sid),
            NewGoodsSt = fuwen_attr:fuwen_change_recalc_attribute(GoodsSt1, NewFuwen),
            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
            NewPlayer = player_util:count_player_attribute(Player, true),
            activity:get_notice(Player, [118], true),
            fuwen_log:upgrade(NewFuwen, Player),
            {1, NewPlayer}
    end.

check_upgrade(_Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {false, 6}; %% 系统物品不存在
        Fuwen ->
            FuwenLv = Fuwen#goods.goods_lv,
            GoodsTypeInfo = data_goods:get(Fuwen#goods.goods_id),
            BaseFuwen = data_fuwen:get(GoodsTypeInfo#goods_type.subtype, FuwenLv, GoodsTypeInfo#goods_type.color),
            if
                GoodsTypeInfo#goods_type.subtype == ?GOODS_SUBTYPE_FUWEN_WHITE ->
                    {false, 0}; %% 白色符文不能升级
                StFuwen#st_fuwen.exp < 1 ->
                    {false, 8}; %% 经验不足
                GoodsTypeInfo#goods_type.subtype < ?GOODS_SUBTYPE_DOUBLE_FUWEN_1 andalso FuwenLv >= 50 ->
                    {false, 7}; %% 满级了
                GoodsTypeInfo#goods_type.subtype >= ?GOODS_SUBTYPE_DOUBLE_FUWEN_1 andalso FuwenLv >= 60 ->
                    {false, 7}; %% 满级了
                StFuwen#st_fuwen.exp < BaseFuwen#base_fuwen.need_exp ->
                    {false, 8}; %% 经验不足
                true ->
                    {true, Fuwen, max(0, BaseFuwen#base_fuwen.need_exp - Fuwen#goods.exp)}
            end
    end.

excharge(Fuwen, TotalExp) ->
    FuwenLv = Fuwen#goods.goods_lv,
    GoodsTypeInfo = data_goods:get(Fuwen#goods.goods_id),
    BaseFuwen = data_fuwen:get(GoodsTypeInfo#goods_type.subtype, FuwenLv, GoodsTypeInfo#goods_type.color),
    if
        GoodsTypeInfo#goods_type.subtype == ?GOODS_SUBTYPE_FUWEN_WHITE ->
            {false, 0}; %% 白色符文不能升级
        TotalExp < 1 ->
            {false, 8}; %% 经验不足
        FuwenLv >= 50 ->
            {false, 7}; %% 满级了
        Fuwen#goods.exp + TotalExp < BaseFuwen#base_fuwen.need_exp ->
            {add_exp, Fuwen, TotalExp}; %% 所需经验不足
        true ->
            {true, Fuwen, max(0, BaseFuwen#base_fuwen.need_exp - Fuwen#goods.exp)}
    end.

%%分解符文
resolved_fuwen(Player, []) ->
    {0, Player};

resolved_fuwen(Player, GoodsKeyList) ->
    resolved_fuwen(Player, util:list_filter_repeat(GoodsKeyList), 0, 0, []).

resolved_fuwen(Player, [], AccExp, AccBestExp, DelGoodsList) ->
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    NewStFuwen = StFuwen#st_fuwen{exp = StFuwen#st_fuwen.exp + AccExp},
    goods_util:reduce_goods_key_list(Player,[{Goods#goods.key, 1} || Goods <- DelGoodsList],568,false),
    goods_load:dbdel_goods_key_list([Goods#goods.key || Goods <- DelGoodsList]),
    lib_dict:put(?PROC_STATUS_FUWEN, NewStFuwen),
    fuwen_load:dbup_self_fuwen_info(NewStFuwen),
    if
        AccBestExp == 0 -> NewPlayer = Player;
        true ->
            GiveGoodsList = goods:make_give_goods_list(742, [{11120, AccBestExp}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList)
    end,
    {1, NewPlayer};

resolved_fuwen(OldPlayer, [GoodsKey | T], OldAccExp, OldAccBestExp, DelGoodsList) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            ?ERR("resolved_fuwen no exit ~p~n", [GoodsKey]),
            resolved_fuwen(OldPlayer, T, OldAccExp, OldAccBestExp, DelGoodsList); %% 系统物品不存在
        Fuwen ->
            FuwenExp = Fuwen#goods.exp,
            GoodsTypeInfo = data_goods:get(Fuwen#goods.goods_id),
            if
                Fuwen#goods.cell > 0 -> %% 穿在身上的符文不可以分解
                    resolved_fuwen(OldPlayer, T, OldAccExp, OldAccBestExp, DelGoodsList);
                true ->
                    F = fun(GoodsLv) ->
                        #base_fuwen{need_exp = NeedExp} = data_fuwen:get(GoodsTypeInfo#goods_type.subtype, GoodsLv, GoodsTypeInfo#goods_type.color),
                        NeedExp
                    end,
                    AddExp =
                        if
                            Fuwen#goods.goods_lv > 1 ->
                                lists:sum(lists:map(F, lists:seq(1, Fuwen#goods.goods_lv - 1))) + GoodsTypeInfo#goods_type.extra_val;
                            true ->
                                GoodsTypeInfo#goods_type.extra_val
                        end,
                    AddBestExp =
                        case data_double_fuwen:get(GoodsTypeInfo#goods_type.goods_id) of
                            [] -> 0;
                            #base_double_attr_fuwen{need_exp = Val} -> Val
                        end,
                    fuwen_log:resolved(Fuwen, AddExp, AddBestExp, OldPlayer),
                    resolved_fuwen(OldPlayer, T, OldAccExp + AddExp + FuwenExp, OldAccBestExp+AddBestExp, [Fuwen | DelGoodsList])
            end
    end.

%% 兑换符文
exchange(Player, GoodsId) ->
    StFuwen = lib_dict:get(?PROC_STATUS_FUWEN),
    #goods_type{color = Color, subtype = SubType} = data_goods:get(GoodsId),
    #base_fuwen{need_chip = CostChip} = data_fuwen:get(SubType, 1, Color),
    if
        CostChip == 0 -> {0, Player};
        StFuwen#st_fuwen.chips < CostChip -> {9, Player};
        true ->
            NewStFuwen = StFuwen#st_fuwen{chips = StFuwen#st_fuwen.chips - CostChip},
            lib_dict:put(?PROC_STATUS_FUWEN, NewStFuwen),
            fuwen_load:dbup_self_fuwen_info(NewStFuwen),
            GiveGoodsList = goods:make_give_goods_list(623, [{GoodsId, 1, ?GOODS_LOCATION_FUWEN, 0, []}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            {1, NewPlayer}
    end.

lookup_notice(_Player) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    F = fun(#weared_fuwen{pos = Pos, goods_id = GoodsId, goods_key = GoodsKey}) ->
        #goods_type{subtype = Subtype, color = Color} = data_goods:get(GoodsId),
        FuwenList = goods_util:get_goods_list_by_type(?GOODS_TYPE_FUWEN, Subtype, GoodsSt#st_goods.dict),
        F0 = fun(#goods{goods_id = GoodsId0, key = GoodsKey0}) ->
            #goods_type{color = Color0} = data_goods:get(GoodsId0),
            ?IF_ELSE(Color0 > Color, [GoodsKey0], [])
        end,
        LL = lists:flatmap(F0, FuwenList),
        ?IF_ELSE(LL == [], [], [[Pos, GoodsKey, hd(LL)]])
    end,
    lists:flatmap(F, GoodsSt#st_goods.weared_fuwen).

%% 合成双属性符文
compound(Player, GoodsKeyList, GoodsId) ->
    case check_compound(GoodsKeyList, GoodsId) of
        {fail, Code} ->
            {Code, Player};
        {true, ConsumeGoodsList, CostExp} ->
            {ok, _} = goods:subtract_good(Player, [{11120, CostExp}], 740),
            goods_util:reduce_goods_key_list(Player,[{Goods#goods.key, 1} || Goods <- ConsumeGoodsList],740),
            SumBackExp = lists:sum(lists:map(fun(Goods) -> get_exp(Goods) end, ConsumeGoodsList)),
            {RemainExp, FuwenLv} = back_fuwen_lv(SumBackExp, GoodsId),
            GiveGoodsList = goods:make_give_goods_list(741, [{GoodsId, 1, ?GOODS_LOCATION_FUWEN, 0, [{back_fuwen_lv, FuwenLv}, {exp, RemainExp}]}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            Sql = io_lib:format("insert into log_fuwen_compound set pkey=~p,goods_id=~p,goods_lv=~p,cost_exp=~p,consume='~s',`time`=~p",
                [Player#player.key,GoodsId,FuwenLv,CostExp, util:term_to_bitstring(GoodsKeyList),util:unixtime()]),
            log_proc:log(Sql),
            LogF = fun(Goods) ->
                Sql0 = io_lib:format("insert into log_fuwen_compound_consume set pkey=~p,goods_key=~p,goods_id=~p,color=~p,goods_lv=~p,`time`=~p",
                    [Player#player.key,Goods#goods.key,Goods#goods.goods_id,Goods#goods.color,Goods#goods.goods_lv,util:unixtime()]),
                log_proc:log(Sql0)
            end,
            lists:map(LogF, ConsumeGoodsList),
            {1, NewPlayer}
    end.

back_fuwen_lv(SumBackExp, GoodsId) ->
    #goods_type{subtype = SubType, color = Color} = data_goods:get(GoodsId),
    back_fuwen_lv(SumBackExp, SubType, Color, 1).

back_fuwen_lv(0, _SubType, _Color, Lv) -> {0, Lv};
back_fuwen_lv(SumBackExp, SubType, Color, Lv) ->
    case data_fuwen:get(SubType, Lv, Color) of
        [] -> {SumBackExp, Lv};
        #base_fuwen{need_exp = NeedExp} ->
            if
                SumBackExp < NeedExp -> {SumBackExp, Lv};
                true ->
                    back_fuwen_lv(SumBackExp-NeedExp, SubType, Color, Lv+1)
            end
    end.

check_compound(GoodsKeyList, GoodsId) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    F = fun(GoodsKey) ->
        case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
            {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} -> [];
            Goods ->
                if  %% 只有闲置在符文背包的道具，才可以被使用
                    Goods#goods.cell > 0 -> [];
                    Goods#goods.location /= ?GOODS_LOCATION_FUWEN -> [];
                    true -> [Goods]
                end
        end
    end,
    ConsumeGoodsList = lists:flatmap(F, GoodsKeyList),
    if
        length(ConsumeGoodsList) /= length(GoodsKeyList) -> {fail, 13};
        true ->
            #base_double_attr_fuwen{
                consume_fuwen1 = ConsumeFuwen1,
                consume_fuwen2 = ConsumeFuwen2,
                need_exp = NeedExp
            } = data_double_fuwen:get(GoodsId),
            SumCount = goods_util:get_goods_count_by_subtype(?GOODS_SUBTYPE_DOUBLE_FUWEN_EXP),
            if
                SumCount < NeedExp -> {fail, 13};
                true ->
                    F1 = fun(Goods, AccList) ->
                        case lists:keytake(Goods#goods.goods_id, 1, AccList) of
                            false ->
                                [{Goods#goods.goods_id, 1} | AccList];
                            {value, {GoodsId0, Num}, Ret} ->
                                [{GoodsId0, Num+1} | Ret]
                        end
                    end,
                    ConsumeL1 = lists:foldl(F1, [], ConsumeGoodsList),
                    ConsumeL2 = [ConsumeFuwen1, ConsumeFuwen2],
                    NewL1 = lists:sort(ConsumeL1),
                    NewL2 = lists:sort(ConsumeL2),
                    if
                        NewL1 /= NewL2 -> {fail, 13};
                        true ->
                            {true, ConsumeGoodsList, NeedExp}
                    end
            end
    end.