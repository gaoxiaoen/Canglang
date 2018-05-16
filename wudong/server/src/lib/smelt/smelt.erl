%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 二月 2017 9:32
%%%-------------------------------------------------------------------
-module(smelt).
-author("hxming").

-include("smelt.hrl").
-include("common.hrl").
-include("goods.hrl").

%% API
-export([smelt_info/1, smelt/2, cmd_smelt/2]).

%%熔炼信息
smelt_info(_Player) ->
    StSmelt = lib_dict:get(?PROC_STATUS_SMELT),
    case data_smelt:get(StSmelt#st_smelt.stage) of
        [] -> [];
        Base ->
            AttributeList = attribute_util:pack_attr(StSmelt#st_smelt.attribute),
            {StSmelt#st_smelt.stage, StSmelt#st_smelt.exp, Base#base_smelt.exp, StSmelt#st_smelt.cbp, AttributeList}
    end.

%%熔炼
smelt(Player, EquipKeyList) ->
    StSmelt = lib_dict:get(?PROC_STATUS_SMELT),
    case calc_exp(EquipKeyList) of
        {[], _, _} ->
            {3, Player, 0};
        {NewEquipKeyList, PartNum, Exp} ->
            goods:subtract_good_by_keys(NewEquipKeyList),
            StSmelt1 = add_exp(Exp, StSmelt),
            NewStSmelt = ?IF_ELSE(StSmelt1#st_smelt.is_upgrade, smelt_init:calc_attribute(StSmelt1), StSmelt1),
            smelt_load:log_smelt(Player#player.key, Player#player.nickname, NewStSmelt#st_smelt.stage, NewStSmelt#st_smelt.exp, PartNum),
            NewPlayer = money:add_equip_part(Player, PartNum),
            lib_dict:put(?PROC_STATUS_SMELT, NewStSmelt#st_smelt{is_change = 1, is_upgrade = false}),
            NewPlayer1 = ?IF_ELSE(NewStSmelt#st_smelt.is_upgrade, player_util:count_player_attribute(NewPlayer, true), NewPlayer),
            Count = lists:sum([Num || {_Key, Num} <- NewEquipKeyList]),
            {1, NewPlayer1, Count}
    end.

calc_exp(EquipKeyList) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    F = fun(GoodsKey, {L, PartNum, Exp}) ->
        case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
            {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
                {L, PartNum, Exp};
            Goods ->
                if Goods#goods.location =/= ?GOODS_LOCATION_BAG -> {L, Exp};
                    true ->
                        GoodsType = data_goods:get(Goods#goods.goods_id),
                        case GoodsType#goods_type.smelt of
                            [] ->
                                {L, PartNum, Exp};
                            0 ->
                                {L, PartNum, Exp};
                            {Exp0, Num0} ->
                                {[{GoodsKey, Goods#goods.num} | L], PartNum + Num0 * Goods#goods.num, Exp + Exp0 * Goods#goods.num};
                            Exp0 when is_integer(Exp0) ->
                                {[{GoodsKey, Goods#goods.num} | L], PartNum, Exp + Exp0 * Goods#goods.num};
                            _ ->
                                {L, PartNum, Exp}
                        end
                end
        end
    end,
    lists:foldl(F, {[], 0, 0}, EquipKeyList).

add_exp(0, StSmelt) -> StSmelt;
add_exp(Exp, StSmelt) ->
    case data_smelt:get(StSmelt#st_smelt.stage) of
        [] ->
            StSmelt#st_smelt{stage = StSmelt#st_smelt.stage - 1, exp = 0};
        Base ->
            if Base#base_smelt.exp == 0 ->
                StSmelt#st_smelt{exp = 0};
                Exp + StSmelt#st_smelt.exp >= Base#base_smelt.exp ->
                    NewStSmelt = StSmelt#st_smelt{exp = 0, stage = StSmelt#st_smelt.stage + 1, is_upgrade = true},
                    add_exp(Exp + StSmelt#st_smelt.exp - Base#base_smelt.exp, NewStSmelt);
                true ->
                    StSmelt#st_smelt{exp = StSmelt#st_smelt.exp + Exp}
            end
    end.

cmd_smelt(Player, Exp) ->
    StSmelt = lib_dict:get(?PROC_STATUS_SMELT),
    StSmelt1 = add_exp(Exp, StSmelt),
    NewStSmelt = ?IF_ELSE(StSmelt1#st_smelt.is_upgrade, smelt_init:calc_attribute(StSmelt1), StSmelt1),
    lib_dict:put(?PROC_STATUS_SMELT, NewStSmelt#st_smelt{is_change = 1, is_upgrade = false}),
    NewPlayer = ?IF_ELSE(NewStSmelt#st_smelt.is_upgrade, player_util:count_player_attribute(Player, true), Player),
    {ok, NewPlayer}.