%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 装备强化
%%% @end
%%% Created : 17. 一月 2015 14:52
%%%-------------------------------------------------------------------
-module(equip_smelt).
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
-include("equip.hrl").

-define(SMELT_SUC_PROBABILITY, [20, 40, 60, 80, 100]).
-define(SMELT_SUB_TYPE_PROBABILITY, [1, 1, 2, 1, 1, 2, 1, 1]).
%% API
-export([
    add_smelt_value/3,
    cost_smelt_value/2,
    equip_smelt/2,
    check_smelt_state/0,
	cron_equip_smelt/9
]).

cost_smelt_value(Player, Value) ->
    NewPlayer = Player#player{smelt_value = Player#player.smelt_value - Value},
    player_load:dbup_smelt_value(NewPlayer),
    {ok, Bin} = pt_160:write(16012, {Player#player.smelt_value - Value}),
    server_send:send_to_sid(Player#player.sid, Bin),
    NewPlayer.

add_smelt_value(Player, EquipLv, Color) ->
    AddValue = data_smelt_value:get(EquipLv, Color),
    NewPlayer = Player#player{smelt_value = Player#player.smelt_value + AddValue},
    player_load:dbup_smelt_value(NewPlayer),
    {ok, Bin} = pt_160:write(16012, {Player#player.smelt_value + AddValue}),
    server_send:send_to_sid(Player#player.sid, Bin),
    NewPlayer.

equip_smelt(Player, List) when length(List) > 5 ->
	equip_smelt(Player, lists:sublist(List, 5));

equip_smelt(Player, List) ->
    case get_smelt_equip(List, Player#player.career) of
        {add_smelt_value, EquipLv, Color} ->
			cron_equip_smelt(Player#player.key,Player#player.nickname,[goods_util:get_goods(GoodsKey)||GoodsKey<-List], 2,0,data_smelt_value:get(EquipLv, Color), EquipLv, Color,util:unixtime()),
            NewPlayer = add_smelt_value(Player, EquipLv, Color),
            goods_util:reduce_goods_key_list(Player,[{Key, 1} || Key <- List],45),
            {ok, NewPlayer, ?ER_SUCCEED, 0};
        {GoodsId, EquipLv, Color} ->
            case is_smelt_succeed(List) of
                true -> %%本次熔炼成功
                    cron_equip_smelt(Player#player.key,Player#player.nickname,[goods_util:get_goods(GoodsKey)||GoodsKey<-List], 1,GoodsId,1, EquipLv, Color,util:unixtime()),
                    GiveGoodsList = goods:make_give_goods_list(45,[{GoodsId,1}]),
                    goods:give_goods(Player, GiveGoodsList),
                    goods_util:reduce_goods_key_list(Player,[{Key, 1} || Key <- List],45),
                    {ok, Player, ?ER_SUCCEED, GoodsId};
                _ ->%%本次熔炼失败，增加熔炼值
					cron_equip_smelt(Player#player.key,Player#player.nickname,[goods_util:get_goods(GoodsKey)||GoodsKey<-List], 0,0,data_smelt_value:get(EquipLv, Color),EquipLv, Color, util:unixtime()),
                    NewPlayer = add_smelt_value(Player, EquipLv, Color),
                    goods_util:reduce_goods_key_list(Player,[{Key, 1} || Key <- List],45),
                    {ok, NewPlayer, ?ER_SUCCEED, 0}
            end
    end.


is_smelt_succeed(List) ->
    Nth = length(List),
    {ProbabilityList, _} = data_smelt_probability:get(),
    Probability = lists:nth(Nth, ProbabilityList),
    util:rand(1, 100) =< Probability.


get_smelt_equip([GoodsKey | EquipList], Career) ->
    SameGoods = goods_util:get_goods(GoodsKey),
    SameGoodsType = data_goods:get(SameGoods#goods.goods_id),
    Fun = fun(InGoodsKey, IsSameEquip) ->
        Goods = goods_util:get_goods(InGoodsKey),
        GoodsType = data_goods:get(Goods#goods.goods_id),
		?ASSERT(GoodsType#goods_type.type =:= ?GOODS_TYPE_EQUIP, {false, 10011}),
        ?ASSERT(GoodsType#goods_type.equip_lv =:= SameGoodsType#goods_type.equip_lv, {false, 111}),
        ?ASSERT(GoodsType#goods_type.color =:= SameGoodsType#goods_type.color, {false, 11111}),
        if
            SameGoodsType#goods_type.subtype =/= GoodsType#goods_type.subtype ->
                false;
            SameGoodsType#goods_type.career =/= GoodsType#goods_type.career ->
                false;
            GoodsType#goods_type.career =/= 0 andalso GoodsType#goods_type.career =/= Career ->
                false;
            true ->
                IsSameEquip
        end
          end,
    case lists:foldl(Fun, true, EquipList) of
        true -> %%五件全是自己职业的同一部位的装备，所以融合后，也是同一部位的装备
            SmeltSubtype = SameGoodsType#goods_type.subtype;
        _ ->    %%五件是打乱的装备，部位也随机
            SmeltSubtype = util:probability_list_nth(?SMELT_SUB_TYPE_PROBABILITY)
    end,
    Equiplv = SameGoodsType#goods_type.equip_lv,
    Color = SameGoodsType#goods_type.color + 1,
    case catch data_smelt:get({SmeltSubtype, Career, Equiplv, Color}) of
		_ when Equiplv =< 37 andalso Color >= 3-> %%37级以下，不熔炼出紫色装备
			{add_smelt_value, SameGoodsType#goods_type.equip_lv, SameGoodsType#goods_type.color};
        GoodsId when is_integer(GoodsId) ->
            {GoodsId, SameGoodsType#goods_type.equip_lv, SameGoodsType#goods_type.color};
        _ ->
            {add_smelt_value, SameGoodsType#goods_type.equip_lv, SameGoodsType#goods_type.color}
    end.

%%检查是否有装备可熔炼
check_smelt_state() ->
    case goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP]) of
        [] -> 0;
        GoodsList ->
            F = fun(Goods) ->
                case data_goods:get(Goods#goods.goods_id) of
                    [] -> 0;
                    GoodsTypeInfo ->
                        if GoodsTypeInfo#goods_type.color == 1  ->
                            1;
                            true -> 0
                        end
                end
                end,
            %%背包中绿色5件以上
            case lists:sum(lists:map(F, GoodsList)) >= 5 of
                false -> 0;
                true -> 1
            end
    end.

cron_equip_smelt(Pkey,Nickname,GoodsIdList, Result,GetGoodsId, Num, EquipLv, Color,Time)->
	[G1,G2,G3,G4,G5] = 
		[case catch lists:nth(N, GoodsIdList) of
			Goods when is_record(Goods, goods)-> Goods#goods.goods_id;
			_-> 0
		end||N<-lists:seq(1, 5)],
			
	Sql = io_lib:format(<<"insert into log_equip_smelt set pkey = ~p,nickname = '~s',result=~p,goods_id1 =~p,
			goods_id2 =~p,goods_id3 =~p,goods_id4 =~p,goods_id5 =~p,color = ~p,lv = ~p,get_goods_id = ~p,get_num = ~p,time=~p">>,
      		[Pkey, Nickname,Result,G1,G2,G3,G4,G5,Color,EquipLv,GetGoodsId,Num ,Time]),
    log_proc:log(Sql),
    ok.
	
