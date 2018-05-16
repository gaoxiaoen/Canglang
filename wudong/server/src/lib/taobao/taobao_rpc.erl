%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 17:16
%%%-------------------------------------------------------------------
-module(taobao_rpc).

-include("server.hrl").
-include("common.hrl").
-include("taobao.hrl").
-include("goods.hrl").



-export([handle/3]).



%%获取自己正在出售的物品
handle(25001,Player,_)->
  %% 获取玩家背包基础信息
  GoodsSt = lib_dict:get(?PROC_STATUS_TAOBAO_BAG),
  GoodsInfoList = goods_dict:dict_to_list(GoodsSt#st_goods.dict),
  GoodsList = [[GoodsInfo#goods.key,
	GoodsInfo#goods.goods_id,
	GoodsInfo#goods.num,
	  GoodsInfo#goods.bind]||GoodsInfo<-GoodsInfoList],
  {ok,Bin} = pt_250:write(25001,{GoodsList}),
  server_send:send_to_sid(Player#player.sid,Bin),
  ok;

%%淘宝
handle(25003,Player,{Type})->
  case catch taobao:taobao(Player,Type) of
	{ok,NewPlayer,Goodslist}->
	  NewGoodslist = [[G#give_goods.goods_id,G#give_goods.num,IsLuck]||{G,IsLuck}<-Goodslist],
	  {ok,Bin} = pt_250:write(25003,{1,NewGoodslist}),
	  server_send:send_to_sid(Player#player.sid,Bin),
		activity:get_notice(Player,[72],true),
	  {ok,NewPlayer};
	{false,Code}->
	  {ok,Bin} = pt_250:write(25003,{?IF_ELSE(Code == 2,4,Code),[]}),
	  server_send:send_to_sid(Player#player.sid,Bin),
	  ok
  end;

%%查看自己的淘宝记录
handle(25004,Player,_)->
  Binfo = lib_dict:get(?PROC_STATUS_TAOBAO_INFO),
  {ok,Bin} = pt_250:write(25004,{Binfo#taobao_info.recently_goods}),
  server_send:send_to_sid(Player#player.sid,Bin),
  ok;

%%查看他人的的淘宝记录
handle(25005,Player,_)->
  case ets:lookup(?ETS_TAOBAO_RECORD,record) of
	[]->
	  {ok,Bin} = pt_250:write(25005,{[]}),
	  server_send:send_to_sid(Player#player.sid,Bin);
	[{record,RecordList}]->
	  List = [[Name,GoodsId]||{_,Name,GoodsId}<-RecordList],
	  {ok,Bin} = pt_250:write(25005,{List}),
	  server_send:send_to_sid(Player#player.sid,Bin)
  end,
  ok;

%%转移淘宝物品
handle(25006 ,Player,{GoodsKey})->
  case catch taobao_util:transfer(Player,GoodsKey) of
	{ok, NewPlayer}->
	  {ok,Bin} = pt_250:write(25006,{1}),
	  server_send:send_to_sid(Player#player.sid,Bin),
	  {ok, NewPlayer};
	{false,Code}->
	  {ok,Bin} = pt_250:write(25006,{Code}),
	  server_send:send_to_sid(Player#player.sid,Bin),
	  ok
  end;

%%获得淘宝信息
handle(25007 ,Player,_)->
  TaoBaoInfo = lib_dict:get(?PROC_STATUS_TAOBAO_INFO),
  Now = util:unixtime(),
  TicketNum = goods_util:get_goods_count(20704),
  Fun = fun(Type,Out)->
		  {Type,Times} = lists:keyfind(Type,1,TaoBaoInfo#taobao_info.times),
		  {Type,ReTime} = lists:keyfind(Type,1,TaoBaoInfo#taobao_info.refresh_times),
		  T = data_taobao_config:get(Type),
		  Gold = ?IF_ELSE(T#base_taobao_config.gold >0,T#base_taobao_config.gold,T#base_taobao_config.bind_gold),
		  [[Type,Times,?IF_ELSE(Now > ReTime,0,ReTime - Now),Gold]|Out]
	end,
  List = lists:foldl(Fun,[],data_taobao_config:get_all_type()),
  {ok,Bin} = pt_250:write(25007,{TaoBaoInfo#taobao_info.luck_value,TicketNum,List}),
  server_send:send_to_sid(Player#player.sid,Bin),
  ok;

handle(_cmd,_Player,_Data) ->
	?PRINT("_cmd ~p _Data ~p ~n",[_cmd,_Data]),
    ok.


			
			
	