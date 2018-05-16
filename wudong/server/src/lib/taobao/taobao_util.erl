%%%-------------------------------------------------------------------
%%% @author and_me
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 13:49
%%%-------------------------------------------------------------------
-module(taobao_util).
-author("and_me").

-include("market.hrl").
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
%% 公用接口
-export([
  give_goods/2,
  transfer/2,
  cron_taobao/6
]).


give_goods(Player, InfoListAll) ->
  AllInfoListAll = goods_util:tans_give_goods(InfoListAll),
  GoodsStatus = lib_dict:get(?PROC_STATUS_TAOBAO_BAG),
  Fun = fun(Info, {AccCL, AccNL, GoodsStatusAcc}) ->
	{NumChangGoodsList, NewGoodsList, [], NGoodsStatus} = goods_util:do_add(Info, GoodsStatusAcc, false),
    {NumChangGoodsList ++ AccCL, NewGoodsList ++ AccNL, NGoodsStatus}
		end,
  {ChangeGoodsList, NewGoodsList, NewGoodsStatus0} = lists:foldl(Fun, {[], [], GoodsStatus}, AllInfoListAll),
  lib_dict:put(?PROC_STATUS_TAOBAO_BAG,NewGoodsStatus0),
  taobao_load:dbup_goods_num(ChangeGoodsList),
  taobao_load:dbadd_goods(NewGoodsList),
  taobao_pack:pack_send_goods_info(ChangeGoodsList ++ NewGoodsList, Player#player.sid),
  ok.

transfer(Player,"")->
  TaobaoGoodsSt = lib_dict:get(?PROC_STATUS_TAOBAO_BAG),
  GoodsList = [Goods||{_, [Goods]} <- dict:to_list(TaobaoGoodsSt#st_goods.dict)],
  List = lists:foldr(fun(Goods,Out)->
                      [#give_goods{goods_id = Goods#goods.goods_id,bind = Goods#goods.bind,num = Goods#goods.num,from = 73}|Out]
                   end,[],GoodsList),
  {ok, NewPlayer} = goods:give_goods_throw(Player,List),
  NewTaobaoGoodsSt = TaobaoGoodsSt#st_goods{leftover_cell_num = TaobaoGoodsSt#st_goods.max_cell,dict = dict:new()},
  lib_dict:put(?PROC_STATUS_TAOBAO_BAG, NewTaobaoGoodsSt),
  taobao_pack:pack_send_goods_info([Goods#goods{num = 0} || Goods<-GoodsList],Player#player.sid),
  taobao_load:dbdel_goods(GoodsList),
  {ok,NewPlayer};

transfer(Player,GoodsKey)->
  GoodsStatus = lib_dict:get(?PROC_STATUS_TAOBAO_BAG),
  Goods = goods_util:get_goods(GoodsKey,GoodsStatus#st_goods.dict),
  {ok, NewPlayer} = goods:give_goods_throw(Player,[#give_goods{goods_id = Goods#goods.goods_id,num = Goods#goods.num,from = 73,bind = Goods#goods.bind}]),
  NewGoods = Goods#goods{num = 0},
  taobao_pack:pack_send_goods_info(NewGoods,Player#player.sid),
  NewGoodsSt = goods_dict:update_goods([NewGoods], GoodsStatus),
  lib_dict:put(?PROC_STATUS_TAOBAO_BAG, NewGoodsSt#st_goods{leftover_cell_num = GoodsStatus#st_goods.leftover_cell_num + 1}),
  taobao_load:dbdel_goods(NewGoods),
  {ok, NewPlayer}.


cron_taobao(Pkey, Pname,Type, Cost_money, Get_goods, Time) ->
  Sql = io_lib:format(<<"insert into log_taobao set pkey = ~p,nickname = '~s',type =~p,cost_money =~p,get_goods = '~s',time = ~p">>,
	[Pkey, Pname,Type, Cost_money, Get_goods, Time]),
  log_proc:log(Sql),
  ok.
