%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 一月 2018 15:31
%%%-------------------------------------------------------------------
-module(godness_attr).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("godness.hrl").
-include("goods.hrl").
-include("skill.hrl").

%% API
-export([
    god_soul_change_recalc_attribute/2,
    calc_singleton_god_soul_attribute/4,
    calc_singleton_god_soul_attribute/1,
    calc_player_attribute/1,
    get_attr/1,
    cacl_singleton_godness_attribute/1,
    calc_godness_all_attribute/1
]).

god_soul_change_recalc_attribute(GoodsSt, Goods) when Goods#goods.cell < 1 ->
    GoodsSt;
god_soul_change_recalc_attribute(GoodsSt, Goods) ->
    ?DEBUG("Pos:~p WearKey:~p", [Goods#goods.cell, Goods#goods.wear_key]),
    WearedGodSoulList = GoodsSt#st_goods.weared_god_soul,
    Attribute = calc_singleton_god_soul_attribute(Goods),
    F = fun(#weared_god_soul{pos = Pos, wear_key = WearKey} = GG) ->
        if
            Pos == Goods#goods.cell andalso WearKey == Goods#goods.wear_key -> [];
            true -> [GG]
        end
    end,
    case lists:flatmap(F, WearedGodSoulList) of
        NWearedGodSoulList -> %%穿神魂
            WearedGodSoul = #weared_god_soul{
                pos = Goods#goods.cell,
                goods_key = Goods#goods.key,
                goods_id = Goods#goods.goods_id,
                wear_key = Goods#goods.wear_key,
                god_soul_attribute = Attribute
            },
            NewWearedGodSoulList = [WearedGodSoul | NWearedGodSoulList]
    end,
    GoodsSt#st_goods{weared_god_soul = NewWearedGodSoulList}.

%% 计算单件神魂属性
calc_singleton_god_soul_attribute(Type, AttrList, GoodsLv, Color) ->
    if
        Type /= ?GOODS_TYPE_GOD_SOUL -> [];
        true ->
            lists:map(fun({Key, Val}) -> {Key, round(Val*get_m(Color)*(0.8+(GoodsLv+1)*0.1))} end, AttrList)
    end.

calc_singleton_god_soul_attribute(#goods{goods_lv = GoodsLv, goods_id = GoodsId}) ->
    case data_goods:get(GoodsId) of
        #goods_type{attr_list = Attrs, color = Color} ->
            NewAttrs = lists:map(fun({Key, Val}) -> {Key, round(Val*get_m(Color)*(0.8+(GoodsLv+1)*0.1))} end, Attrs),
            attribute_util:make_attribute_by_key_val_list(NewAttrs);
        _ ->
            #attribute{}
    end.

get_m(1) -> 1;
get_m(2) -> 1.4;
get_m(3) -> 2;
get_m(4) -> 2.8;
get_m(5) -> 4;
get_m(6) -> 5.6;
get_m(_) -> 5.6.

get_n(1) -> 1;
get_n(2) -> 1.5;
get_n(3) -> 2;
get_n(4) -> 2.5;
get_n(5) -> 4;
get_n(6) -> 4;
get_n(_) -> 4.


%% 计算玩家神祇总属性
calc_godness_all_attribute(StGodness) ->
    #st_godness{godness_list = OldGodnessList} = StGodness,
    FF = fun(Godness) ->
        cacl_singleton_godness_attribute(Godness)
    end,
    GodnessList = lists:map(FF, OldGodnessList),
    F = fun(#godness{is_war = IsWar, war_attr = WarAttr, sum_attr = SumAttr, suit_attr = SuitAttr, suit_percent_attr = SuitPercentAttr}) ->
        if
            IsWar == 0 -> [SumAttr, SuitAttr, SuitPercentAttr];
            true -> [SumAttr, WarAttr, SuitAttr, SuitPercentAttr]
        end
    end,
    AllAttrList = lists:flatmap(F, GodnessList),
    AllAttr = attribute_util:sum_attribute(AllAttrList),
    StGodness#st_godness{
        attr = AllAttr,
        godness_list = GodnessList
    }.

%% 计算玩家神祇总属性
calc_player_attribute(StGodness) ->
    #st_godness{godness_list = GodnessList} = StGodness,
    F = fun(#godness{is_war = IsWar, war_attr = WarAttr, sum_attr = SumAttr, suit_attr = SuitAttr, suit_percent_attr = SuitPercentAttr}) ->
        if
            IsWar == 0 -> [SumAttr, SuitAttr, SuitPercentAttr];
            true -> [SumAttr, WarAttr, SuitAttr, SuitPercentAttr]
        end
    end,
    AllAttrList = lists:flatmap(F, GodnessList),
    AllAttr = attribute_util:sum_attribute(AllAttrList),
    StGodness#st_godness{attr = AllAttr}.

%% 计算单件神祇属性
cacl_singleton_godness_attribute(Godness) ->
    #godness{godness_id = GodnessId, lv = Lv, star = Star, key = GodnessKey, suit_skill_list = SuitSkillList} = Godness,
    case data_godness:get(GodnessId) of
        [] ->
            Godness;
        #godness{
            uplv_attr = UplvAttrs,
            change_add_attr = ChangeAttrs
        } ->
            NUplvAttrs = lists:map(fun({Key, Val}) -> {Key, round(Val* get_n(Star)*((Lv-1)*0.03+1))} end, UplvAttrs),
            NChangeAttrs = lists:map(fun({Key, Val}) -> {Key, round(Val* get_n(Star)*((Lv-1)*0.3+1))} end, ChangeAttrs),
            NewUplvAttrs = attribute_util:make_attribute_by_key_val_list(NUplvAttrs),
            NewChangeAttrs = attribute_util:make_attribute_by_key_val_list(NChangeAttrs),
            StGoods = lib_dict:get(?PROC_STATUS_GOODS),
            F = fun(#weared_god_soul{wear_key = WearKey, god_soul_attribute = GodSoulAttr}) ->
                if
                    WearKey == GodnessKey -> [GodSoulAttr];
                    true -> []
                end
            end,
            WearGodSoulAttr = attribute_util:sum_attribute(lists:flatmap(F, StGoods#st_goods.weared_god_soul)),
            F1 = fun({_SuitId, _Star, SuitSkillId}) ->
                case data_skill:get(SuitSkillId) of
                    [] -> [#attribute{}];
                    #skill{attrs_percent = AttrsPercent} ->
                        F2 = fun({Key, Val}) ->
                            case lists:keyfind(Key, 1, AttrsPercent) of
                                false -> [];
                                {Key, P} ->
                                    ?DEBUG("Key:~p Val:~p P:~p", [Key, Val, P]),
                                    [{Key, round(Val*P/10000)}]
                            end
                        end,
                        KeyValL = lists:flatmap(F2, NUplvAttrs),
                        [attribute_util:make_attribute_by_key_val_list(KeyValL)]
                end
            end,
            SuitPercentAttr = attribute_util:sum_attribute(lists:flatmap(F1, SuitSkillList)),
            ?DEBUG("NewUplvAttrs:~p", [NewUplvAttrs]),
            Godness#godness{
                war_attr = NewChangeAttrs,
                sum_attr = attribute_util:sum_attribute([NewUplvAttrs, WearGodSoulAttr]),
                wear_god_soul_attr = WearGodSoulAttr,
                suit_percent_attr = SuitPercentAttr
            }
    end.

get_attr(Player) ->
    case data_menu_open:get(86) of
        Lv when Player#player.lv >= Lv ->
            StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
            StGodness#st_godness.attr;
        _ ->
            #attribute{}
    end.
