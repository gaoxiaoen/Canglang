%%%-------------------------------------------------------------------
%%% @author lzxs
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%            装备随机属性
%%% @end
%%% Created : 17. 八月 2017 18:14
%%%-------------------------------------------------------------------
-module(equip_random).
-author("lzx").
-include("goods.hrl").
-include("player_mask.hrl").
-include("common.hrl").
-include("baby.hrl").


%% API
-export([
    gen_attr_api/3,
    is_gen_attr/2,
    make_sell_args/1,
    parse_sell_args/1
]).



%% 根据大类和子类来判断是否产生随机属性
is_gen_attr(Type,SubType) ->
    Con1 = lists:member(Type,?GOODS_TYPE_EQUIP_RANDOM_LIST),
    Con2 = lists:member(SubType,?GOODS_SUBTYPE_EQUIP_RANDOM_LIST),
    Con1 andalso Con2.


%% TODO 暂时只支持随机和固定属性
%% 初始化可交易属性
make_sell_args(Goods) ->
    GoodsInfo = data_goods:get(Goods#goods.goods_id),
    case is_gen_attr(GoodsInfo#goods_type.type,GoodsInfo#goods_type.subtype) of
        true ->
            [
                {color,Goods#goods.color},
                {sex,Goods#goods.sex},
                {combat_power,Goods#goods.combat_power},
                {fix_attrs,Goods#goods.fix_attrs},
                {random_attrs,Goods#goods.random_attrs}
            ];
        _ ->
            []
    end.


parse_sell_args(_Args) ->
    case lists:keyfind(color,1,_Args) of
        false -> NewColor = 0;
        {_,NewColor} -> ok
    end,
    case lists:keyfind(sex,1,_Args) of
        false -> Sex = 0;
        {_,Sex} -> ok
    end,
    case lists:keyfind(fix_attrs,1,_Args) of
        false ->FixAttrList = [];
        {_,FixAttrList} -> ok
    end,
    case lists:keyfind(random_attrs,1,_Args) of
        false -> RandAttrList =  [];
        {_,RandAttrList} -> ok
    end,
    case lists:keyfind(combat_power,1,_Args) of
        false -> Combat_power = 0;
        {_,Combat_power} -> ok
    end,
    {NewColor,Sex,Combat_power,FixAttrList,RandAttrList}.



%% 随机固定属性
gen_attr_api(#goods_type{type = Type,subtype = SubType,attr_list = AttrList,rand_attr_list = ConfigRandAttr,
                                     need_lv = EquipLv,color = InitColor},Color,_Args) ->
    case is_gen_attr(Type,SubType) of
        true ->
            case lists:keyfind(color,1,_Args) of
                false ->
                    NewColor = gen_new_color(_Args,InitColor);
                {_,NewColor} -> ok
            end,
            case lists:keyfind(fix_attrs,1,_Args) of
                false ->
                    FixAttrList = gen_fix_attr_list(NewColor,SubType,EquipLv,AttrList,ConfigRandAttr);
                {_,FixAttrList} -> ok
            end,
            case lists:keyfind(random_attrs,1,_Args) of
                false -> RandAttrList = gen_rand_attr_list(NewColor,SubType,EquipLv,AttrList,ConfigRandAttr);
                {_,RandAttrList} -> ok
            end,
            case lists:keyfind(sex,1,_Args) of
                false ->
                    Sex = gen_equip_sex(AttrList,ConfigRandAttr);
                {_,Sex} -> ok
            end,
%%            ?PRINT("NewColor,FixAttrList,RandAttrList,Sex ~w ~w ~w ~w",[NewColor,FixAttrList,RandAttrList,Sex]),
            {Sex,NewColor,FixAttrList,RandAttrList};
        false ->
            {0,Color,[],[]}
    end.


%% 随机男女
gen_equip_sex(AttrList,RandAttrList) ->
    case is_gen_attr2(AttrList,RandAttrList) of
        true ->
            case act_baby_equip_sex:is_open() of
                true ->
                    #baby_st{type_id = TypeId}  = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
                    case data_baby:get(TypeId) of
                        #base_baby{sex = Sex} -> Sex;
                        _ ->
                            1
                    end;
                false ->
                    Weight1 = data_baby_equip_sex_weight:get(1),
                    Weight2 = data_baby_equip_sex_weight:get(2),
                    util:list_rand_ratio([{1, Weight1}, {2, Weight2}])
            end;
        _ ->
            0
    end.


%% 物品品质数据
gen_new_color(_Args, Color) ->
    case lists:keyfind(from_gift_id, 1, _Args) of
        false ->
            Color;
        {_, FromGiftId} -> %%算下这个玩家使用了多少次这个礼包
%%            ?PRINT("FromGiftId ~w",[FromGiftId]),
            UseNum = player_mask:get(?PLAYER_USE_BABY_GIFT_NUM_MASK(FromGiftId), 0),
%%            ?PRINT("UseNum ~w",[UseNum]),
            {CurRange,RandList} = data_baby_equip_random:get(UseNum),
            case util:list_rand_ratio(RandList) of
                0 -> NewColor = Color;
                NewColor -> ok
            end,
            case NewColor == 5 of
                true -> %% 随机到红色装备区间减一
                    CutRange = max(CurRange - 1,1),
                    {MinNum,_} = data_baby_equip_random:id_range(CutRange),
                    player_mask:set(?PLAYER_USE_BABY_GIFT_NUM_MASK(FromGiftId), MinNum);
                _ ->
                    player_mask:set(?PLAYER_USE_BABY_GIFT_NUM_MASK(FromGiftId), UseNum + 1)
            end,
            NewColor
    end.



%% 固定属性
gen_fix_attr_list(NewColor,SubType,EquipLv,AttrList,RandAttrList) ->
    case is_gen_attr2(AttrList,RandAttrList) of %% 没有配置的属性，要随机属性
        true ->
            {_, FixAttrList} = data_baby_equip_attr_list:get(SubType, EquipLv),
            RandAttrList2 = [{attribute_util:attr_tans_client(K), K, V} || {K, V} <- FixAttrList],
            %%计算具体数值
            AttrList2 =
                lists:foldl(fun({_AttrId, AttrName, Value}, AccIds) when Value > 0 ->
                    %% 品质系数
                    {MinRate, MaxRate} = data_baby_equip_color_rate:get(NewColor),
                    RatePer = util:random(MinRate, MaxRate),
                    NewValue = round(Value * RatePer / 100),
                    [{AttrName, NewValue} | AccIds];
                    ({_AttrId, _AttrName, _Value},AccIds) -> AccIds
                            end, [],RandAttrList2),
            lists:reverse(AttrList2);
        _ ->
            %% 有配置的属性，读基础表就好了
            []
    end.


is_gen_attr2(AttrList,RandAttrList) ->
    Len1 = length(AttrList),
    Len2 = length(RandAttrList),
    Len1 =< 0 andalso Len2 =< 0.


%% 随机属性
gen_rand_attr_list(NewColor, SubType, EquipLv,AttrList,RandAttr2) ->
    %%随机属性数量
    case is_gen_attr2(AttrList,RandAttr2) of
        true ->
            AttrNum = data_baby_equip_attr_num:get(NewColor),
            case AttrNum > 0 of
                true ->
                    RandIds = data_baby_equip_attr_weight:all(),
                    InitRateList = lists:map(fun(Id) ->
                        {InitRate, _} = data_baby_equip_attr_weight:get(Id),
                        {Id, InitRate}
                                             end, RandIds),
                    %% 随机了数量
                    {AttrIdsList,_} =
                        lists:foldl(fun(_, {AccRandIds, GenRateInitS}) ->
                            RandAttrId = util:list_rand_ratio(GenRateInitS),
                            NewGenRateInitS =
                                case lists:member(RandAttrId, AccRandIds) of %% 已经随机过该属性了,扣取随机值
                                    true ->
                                        case lists:keytake(RandAttrId, 1, GenRateInitS) of
                                            false -> GenRateInitS;
                                            {value, {_, NowRate}, GenRateList} ->
                                                {_, DecRate} = data_baby_equip_attr_weight:get(RandAttrId),
                                                [{RandAttrId, max(NowRate - DecRate, 0)} | GenRateList]
                                        end;
                                    false ->
                                        GenRateInitS
                                end,
                            {[RandAttrId | AccRandIds], NewGenRateInitS}
                                    end, {[], InitRateList}, lists:seq(1, AttrNum)),

                    {RandAttrList, _} = data_baby_equip_attr_list:get(SubType, EquipLv),
                    RandAttrList2 = [{attribute_util:attr_tans_client(K), K, V} || {K, V} <- RandAttrList],
                    %%计算具体数值
                    RetList = lists:foldl(fun(AttrId,AccAttrList) ->
                        %% 品质系数
                        {MinRate, MaxRate} = data_baby_equip_color_rate:get(NewColor),
                        RatePer = util:random(MinRate, MaxRate),
                        case lists:keyfind(AttrId, 1, RandAttrList2) of
                            {_, AttrName,Value} when Value > 0 ->
                                NewValue = round(Value * RatePer / 100),
                                [{AttrName, NewValue}|AccAttrList];
                            _ ->
                                AccAttrList
                        end
                                          end, [],AttrIdsList),
                    lists:reverse(RetList);
                _ ->
                    []
            end;
        _ ->
            %% 直接使用配置表的
            RandAttr2
    end.



