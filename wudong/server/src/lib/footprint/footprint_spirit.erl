%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 21:37
%%%-------------------------------------------------------------------
-module(footprint_spirit).
-author("hxming").

%% API
-include("footprint_new.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").

%% API
-export([calc_spirit_stage/1, spirit_info/0, spirit_upgrade/1, check_spirit_state/1, add_spirit/3]).


add_spirit(Player, GoodsId, Spirit) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    NewFootprint = Footprint#st_footprint{spirit = Footprint#st_footprint.spirit + Spirit, is_change = 1},
    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
    {ok, Bin} = pt_150:write(15030, {GoodsId, Spirit}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%% 计算灵脉阶数
calc_spirit_stage(SpiritList) ->
    case lists:keyfind(data_footprint_spirit:max_type(), 1, SpiritList) of
        false -> 0;
        {_, Lv} -> Lv
    end.

%%灵脉信息
spirit_info() ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    Stage = calc_spirit_stage(Footprint#st_footprint.spirit_list),
    TypeList = data_footprint_spirit:type_list(),
    F = fun(Type) ->
        case lists:keyfind(Type, 1, Footprint#st_footprint.spirit_list) of
            false -> [Type, 0];
            {_, Lv} -> [Type, Lv]
        end
        end,
    SpiritList = lists:map(F, TypeList),
    CurType = get_upgrade_type(Footprint#st_footprint.last_spirit, TypeList),
    Attribute = footprint_init:calc_spirit_attribute(Footprint#st_footprint.spirit_list),
    AttributeList = attribute_util:pack_attr(Attribute),
    Cbp = attribute_util:calc_combat_power(Attribute),
    Spirit = default_spirit(CurType, Footprint#st_footprint.spirit_list, Footprint#st_footprint.spirit),
    {Stage, CurType, SpiritList, Cbp, AttributeList, Spirit}.

default_spirit(CurType, SpiritList, Spirit) ->
    NextLv =
        case lists:keyfind(CurType, 1, SpiritList) of
            false -> 1;
            {_, LvOld} -> LvOld + 1
        end,
    case data_footprint_spirit:get(CurType, NextLv) of
        [] -> 0;
        Base ->
            {_, Count} = get_count(Base#base_footprint_spirit.goods_id, Spirit),
            Count
    end.

get_upgrade_type(LastType, TypeList) ->
    MaxType = lists:max(TypeList),
    MinType = lists:min(TypeList),
    if LastType == 0 orelse LastType == MaxType -> MinType;
        true ->
            LastType + 1
    end.

%%灵脉升级
spirit_upgrade(Player) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    TypeList = data_footprint_spirit:type_list(),
    CurType = get_upgrade_type(Footprint#st_footprint.last_spirit, TypeList),
    Lv = case lists:keyfind(CurType, 1, Footprint#st_footprint.spirit_list) of
             false -> 1;
             {_, LvOld} -> LvOld + 1
         end,
    case data_footprint_spirit:get(CurType, Lv) of
        [] -> {22, Player};
        Base ->
            {Subtype, Count} = get_count(Base#base_footprint_spirit.goods_id, Footprint#st_footprint.spirit),
            if Count < Base#base_footprint_spirit.goods_num -> {13, Player};
                Base#base_footprint_spirit.stage > Footprint#st_footprint.stage -> {17, Player};
                true ->
                    Spirit =
                        case Subtype of
                            ?GOODS_SUBTYPE_FOOTPRINT_SPIRIT ->
                                Footprint#st_footprint.spirit - Base#base_footprint_spirit.goods_num;
                            _ ->
                                goods:subtract_good(Player, [{Base#base_footprint_spirit.goods_id, Base#base_footprint_spirit.goods_num}], 247),
                                Footprint#st_footprint.spirit
                        end,
                    SpiritList = [{CurType, Lv} | lists:keydelete(CurType, 1, Footprint#st_footprint.spirit_list)],
                    Footprint1 = Footprint#st_footprint{spirit_list = SpiritList, last_spirit = CurType, spirit = Spirit, is_change = 1},
                    NewFootprint = footprint_init:calc_attribute(Footprint1),
                    lib_dict:put(?PROC_STATUS_FOOTPRINT, NewFootprint),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    log_footprint_spirit(Player#player.key, Player#player.nickname, CurType, Lv),
                    {1, NewPlayer}
            end
    end.

log_footprint_spirit(Pkey, Nickname, Type, Lv) ->
    Sql = io_lib:format("insert into log_footprint_spirit set pkey=~p,nickname='~s',`type`=~p,lv=~p,time=~p", [Pkey, Nickname, Type, Lv, util:unixtime()]),
    log_proc:log(Sql).

check_spirit_state(Footprint) ->
    TypeList = data_footprint_spirit:type_list(),
    CurType = get_upgrade_type(Footprint#st_footprint.last_spirit, TypeList),
    Lv = case lists:keyfind(CurType, 1, Footprint#st_footprint.spirit_list) of
             false -> 1;
             {_, LvOld} -> LvOld + 1
         end,
    case data_footprint_spirit:get(CurType, Lv) of
        [] -> 0;
        Base ->
            {_, Count} = get_count(Base#base_footprint_spirit.goods_id, Footprint#st_footprint.spirit),
            if Count < Base#base_footprint_spirit.goods_num -> 0;
                Base#base_footprint_spirit.stage > Footprint#st_footprint.stage -> 0;
                true -> 1
            end
    end.

get_count(GoodsId, Default) ->
    Goods = data_goods:get(GoodsId),
    case Goods#goods_type.subtype of
        ?GOODS_SUBTYPE_FOOTPRINT_SPIRIT ->
            {Goods#goods_type.subtype, Default};
        _ ->
            {Goods#goods_type.subtype, goods_util:get_goods_count(GoodsId)}
    end.