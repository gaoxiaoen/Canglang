%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 装备附魔
%%% @end
%%% Created : 21. 七月 2017 17:41
%%%-------------------------------------------------------------------
-module(equip_magic).
-author("Administrator").
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
-include("equip.hrl").
-include("error_code.hrl").
-include("money.hrl").
-include("new_shop.hrl").
-include("tips.hrl").

%% API
-export([
    magic_default/0,
    equip_magic/2,
    pack_equip_magic/1,
    format_equip_magic/1,
    add_goods_magic/1,
    gm_reset/0,
    gm_get/0,
    total_attribute/1,
    get_sbutype_lv/2,
    get_sbutype_exp/2,
    get_magic_info/1
]).

%% PROC_STATUS_EQUIP_MAGIC
-define(MAGIC_STONE, 1015001). %% 附魔石物品id
-define(MAGIC_EXP, 1). %% 附魔石经验

magic_default() ->
    [{hp_lim, 0}, {def, 0}, {att, 0}].

get_magic_info(SubType) ->
    case lists:member(SubType, ids()) of
        false -> [];
        _ ->
            St = lib_dict:get(?PROC_STATUS_EQUIP_MAGIC),
            case lists:keyfind(SubType, #st_magic_info.subtype, St#st_magic.magic_list) of
                false -> [];
                Base ->
                    [tuple_to_list(X) || X <- Base#st_magic_info.att_list]
            end
    end.

%% 装备附魔
equip_magic(Player, GoodsKey) ->
    case check_equip_magic(Player, GoodsKey) of
        {false, Res} ->
            {false, Res};
        {ok, EquipMagic} ->
            Goods = goods_util:get_goods(GoodsKey),
            GoodsType = data_goods:get(Goods#goods.goods_id),
            Lim = data_equip_magic_limit:get(Goods#goods.god_forging),
            AttList = EquipMagic#st_magic_info.att_list,
            {MaxLv, _MaxExp, _MaxIndex} = lists:max(AttList),
            {MinLv, MinExp, MinIndex} = lists:min(AttList),
            goods:subtract_good(Player, [{?MAGIC_STONE, 1}], 295), %% 扣物品
            if
                MaxLv - MinLv >= 3 -> %% 差值超过三级，默认升最低级
                    add_exp({MinLv, MinExp, MinIndex}, EquipMagic),
                    {ok, NewPlayer} = computation_attribute(Player, Goods, GoodsType),
                    {ok, NewPlayer, MinIndex};
                true ->
                    List = [Index0 || {Lv, _, Index0} <- AttList, Lv < Lim],
                    Index = util:list_rand(List), %% 随机升一个属性
                    {Lv0, Exp0, Index0} = lists:keyfind(Index, 3, AttList),
                    add_exp({Lv0, Exp0, Index0}, EquipMagic),
                    {ok, NewPlayer} = computation_attribute(Player, Goods, GoodsType),
                    {ok, NewPlayer, Index0}
            end
    end.

check_equip_magic(_Player, GoodsKey) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    Lim = data_equip_magic_limit:get(Goods#goods.god_forging),
    StEquipMagic = lib_dict:get(?PROC_STATUS_EQUIP_MAGIC), %% 附魔字典
    if
        Goods#goods.star < 4 -> {false, 43}; %% 非红装不可附魔
        true ->
            EquipMagic =
                case lists:keyfind(GoodsType#goods_type.subtype, #st_magic_info.subtype, StEquipMagic#st_magic.magic_list) of
                    false ->
                        #st_magic_info{subtype = GoodsType#goods_type.subtype};
                    Value ->
                        Value
                end,
            CheckLimit = check_limit(EquipMagic, Lim),
            if
                CheckLimit ->
                    {false, 44}; %% 已达附魔上限
                true ->
                    Count = goods_util:get_goods_count(?MAGIC_STONE),
                    if
                        Count =< 0 -> {false, 3};
                        true ->
                            {ok, EquipMagic}
                    end
            end
    end.

check_limit(EquipMagic, Limit) ->
    List = [Num || {Num, _, _} <- EquipMagic#st_magic_info.att_list, Num < Limit],
    List == [].

add_exp({Lv, Exp, Index}, EquipMagic) ->
    Base = data_equip_magic:get(EquipMagic#st_magic_info.subtype, Lv + 1, Index),
    {NewLv, NewExp} =
        if
            Base#base_equip_magic.exp =< Exp + ?MAGIC_EXP -> {Lv + 1, 0};
            true -> {Lv, Exp + ?MAGIC_EXP}
        end,
    StEquipMagic = lib_dict:get(?PROC_STATUS_EQUIP_MAGIC), %% 附魔字典
    NewEquipMagic = lists:keyreplace(Index, 3, EquipMagic#st_magic_info.att_list, {NewLv, NewExp, Index}),
    case lists:keytake(EquipMagic#st_magic_info.subtype, #st_magic_info.subtype, StEquipMagic#st_magic.magic_list) of
        false ->
            NewMagicList = [EquipMagic#st_magic_info{att_list = NewEquipMagic} | StEquipMagic#st_magic.magic_list];
        {value, _, List} ->
            NewMagicList = [EquipMagic#st_magic_info{att_list = NewEquipMagic} | List]
    end,
    lib_dict:put(?PROC_STATUS_EQUIP_MAGIC, StEquipMagic#st_magic{magic_list = NewMagicList}),
    ok.

computation_attribute(Player, Goods, GoodsType) ->
    StEquipMagic = lib_dict:get(?PROC_STATUS_EQUIP_MAGIC),
    EquipMagic =
        case lists:keyfind(GoodsType#goods_type.subtype, #st_magic_info.subtype, StEquipMagic#st_magic.magic_list) of
            false ->
                #st_magic_info{subtype = GoodsType#goods_type.subtype};
            Value ->
                Value
        end,
    AttributeAll = total_attribute(StEquipMagic#st_magic.magic_list),
    Attribute = total_attribute([EquipMagic]),
    lib_dict:put(?PROC_STATUS_EQUIP_MAGIC, StEquipMagic#st_magic{is_change = 1, attribute = AttributeAll}),
    Goods1 = Goods#goods{magic_attrs = Attribute},
    NewGoods = equip_attr:equip_combat_power(Goods1),
    GoodsUpdateBin = goods_pack:pack_goods_info_bin([NewGoods]),
    server_send:send_to_sid(Player#player.sid, GoodsUpdateBin),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsSt1 = goods_dict:update_goods(NewGoods, GoodsSt),
    GoodsSt2 = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewGoods),
    lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
    Player1 = equip_attr:equip_suit_calc(Player),
    NewPlayer1 = player_util:count_player_attribute(Player1, true),
    {ok, NewPlayer1}.

%% 根据装备附魔信息计算总属性加成
total_attribute(EquipMagicList) ->
    total_attribute(EquipMagicList, []).
total_attribute([], AttrList) -> AttrList;
total_attribute([EquipMagic | T], AttrList) ->
    AttList = EquipMagic#st_magic_info.att_list,
    SubType = EquipMagic#st_magic_info.subtype,
    F = fun({Lv, _Exp, Index}, AttributeList0) ->
        Base = data_equip_magic:get(SubType, Lv, Index),
        Base#base_equip_magic.attrs ++ AttributeList0
    end,
    AttributeList = lists:foldl(F, [], AttList),
    {MinLv, _, _} = ?IF_ELSE(AttList == [], {0, 1, 1}, lists:min(AttList)),
    GroupAtt = data_equip_magic_group:get(SubType, MinLv),
    total_attribute(T, lists:append([AttributeList, AttrList, GroupAtt])).

pack_equip_magic(ExpList) ->
    F = fun({AttList, SubType}) ->
        #st_magic_info{subtype = SubType, att_list = AttList}
    end,
    lists:map(F, ExpList).

format_equip_magic(MagicList) ->
    F = fun(EquipMagic) ->
        {
            EquipMagic#st_magic_info.att_list,
            EquipMagic#st_magic_info.subtype}
    end,
    lists:map(F, MagicList).

add_goods_magic(GoodsList) ->
    add_goods_magic(GoodsList, []).

add_goods_magic([], List) -> List;
add_goods_magic([Goods | T], List) ->
    GoodsType = data_goods:get(Goods#goods.goods_id),
    if
        GoodsType#goods_type.type == 1 ->
            NewGoods = add_goods_magic_help(Goods),
            add_goods_magic(T, [NewGoods | List]);
        true ->
            add_goods_magic(T, [Goods | List])
    end.

add_goods_magic_help(Goods) ->
    GoodsType = data_goods:get(Goods#goods.goods_id),
    GoodsType#goods_type.type,
    StMagic = get(?PROC_STATUS_EQUIP_MAGIC),
    EquipMagic =
        case lists:keyfind(GoodsType#goods_type.subtype, #st_magic_info.subtype, StMagic#st_magic.magic_list) of
            false ->
                #st_magic_info{att_list = [], subtype = GoodsType#goods_type.subtype};
            Value ->
                Value
        end,
    Attribute = total_attribute([EquipMagic]),
    NewGoods = Goods#goods{magic_attrs = Attribute},
    NewGoods.

gm_reset() ->
    lib_dict:put(?PROC_STATUS_EQUIP_MAGIC, #st_magic{}),
    ok.

get_sbutype_lv(Key, SubType) ->
    Type = attribute_util:attr_tans_client(Key),
    St = lib_dict:get(?PROC_STATUS_EQUIP_MAGIC),
    case lists:keyfind(SubType, #st_magic_info.subtype, St#st_magic.magic_list) of
        false -> 0;
        Base ->
            case lists:keyfind(Type, 3, Base#st_magic_info.att_list) of
                false -> 0;
                {Lv, _Exp, _} -> Lv
            end
    end.

get_sbutype_exp(Key, SubType) ->
    Type = attribute_util:attr_tans_client(Key),
    St = lib_dict:get(?PROC_STATUS_EQUIP_MAGIC),
    case lists:keyfind(SubType, #st_magic_info.subtype, St#st_magic.magic_list) of
        false -> 0;
        Base ->
            case lists:keyfind(Type, 3, Base#st_magic_info.att_list) of
                false -> 0;
                {_Lv, Exp, _Type} -> Exp
            end
    end.

ids() ->
    [7, 2, 130, 6, 5, 1, 3, 4].

gm_get() ->
    St = lib_dict:get(?PROC_STATUS_EQUIP_MAGIC),
    ?DEBUG("St ~p~n", [St]),
    ok.