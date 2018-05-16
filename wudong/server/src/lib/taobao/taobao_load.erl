%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2015 下午7:13
%%%-------------------------------------------------------------------
-module(taobao_load).
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
-include("taobao.hrl").
%% API
-export([
  load_player_goods/1,
  load_taobao_info/1
]).

-export([
  dbadd_goods/1,
  dbdel_goods/1,
  dbup_goods_num/1,
  updata_taobao_info_times/2,
  updata_taobao_info_luck/2
]).


-define(GETS,"select gkey ,pkey ,goods_id,location ,cell ,num ,bind ,expiretime ,goods_lv,star,stren ,color,wash_luck_value,wash_attrs,gemstone_groove,total_attrs,combat_power from taobao_bag ").

-define(GET_PLAYER_GOODS(Pkey),io_lib:format("~s where pkey = ~p",[?GETS,Pkey])).
-define(GET_PLAYER_GOODS_LOC(Pkey,Location),io_lib:format("~s where pkey = ~p and location = ~p",[?GETS,Pkey,Location])).

%%加载玩家所有物品信息
load_player_goods(Pkey) ->
  SQL = ?GET_PLAYER_GOODS(Pkey),
  db:get_all(SQL).


%%加载玩家背包信息
load_taobao_info(Player) ->
	case player_util:is_new_role(Player) of
		true->
			[];
		false->
			Sql = io_lib:format("select luck_value,times,refresh_times,recently_goods from taobao_info where pkey = ~p", [Player#player.key]),
			case db:get_row(Sql) of
				[] ->
					[];
				[LuckValue,Times,RefreshTime,RecentlyGoods] ->
					[LuckValue,Times,RefreshTime,RecentlyGoods]
			end
	end.


updata_taobao_info_times(TaobaoInfo,Pkey)->
  SQL = io_lib:format("update taobao_info set times = '~s',refresh_times = '~s' where pkey = ~p",[util:term_to_bitstring(TaobaoInfo#taobao_info.times),util:term_to_bitstring(TaobaoInfo#taobao_info.refresh_times),Pkey]),
  db:execute(SQL).

updata_taobao_info_luck(TaobaoInfo,Pkey)->
  SQL = io_lib:format("update taobao_info set luck_value = ~p,recently_goods = '~s' where pkey = ~p",[TaobaoInfo#taobao_info.luck_value,util:term_to_bitstring(TaobaoInfo#taobao_info.recently_goods),Pkey]),
  db:execute(SQL).
dbadd_goods(GoodsInfoList) when is_list(GoodsInfoList)->
  [dbadd_goods(GoodsInfo)||GoodsInfo<-GoodsInfoList];

dbadd_goods(GoodsInfo) ->
  #goods{
	key = Key,
	pkey = Pkey,
	goods_id = GoodsId,
	location = Location,
	cell = Cell,
	num = Num,
	bind = Bind,
	expire_time = ExpireTime,
	%create_time = CreateTime,
	origin = Origin,
	goods_lv = GoodsLv,
	stren = Stren,
	wash_attr = WashSttrs,
	total_attrs = TotalAttrs,
	gemstone_groove = BaseGemstoneGroove,
	combat_power = CombatPower

  } = GoodsInfo,
  CreateTime = util:unixtime(),
  TotalAttrsS = util:term_to_bitstring(TotalAttrs),
  WashSttrsString = util:term_to_bitstring(WashSttrs),
  GemstoneGroove = util:term_to_bitstring(BaseGemstoneGroove),

  SQL = io_lib:format("insert into taobao_bag (gkey ,pkey ,goods_id,location ,cell ,num ,bind ,expiretime ,createtime, origin,goods_lv,stren ,wash_attrs, gemstone_groove,total_attrs,combat_power) values
    (~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,~p,'~s','~s','~s',~p)",
	[Key,Pkey,GoodsId,Location,Cell,Num,Bind,ExpireTime,CreateTime,Origin,GoodsLv,Stren,WashSttrsString , GemstoneGroove, TotalAttrsS, CombatPower]),
  db:execute(SQL),
  GoodsInfo#goods{key = Key}.


dbup_goods_num(GoodsInfoList) when is_list(GoodsInfoList)->
  [dbup_goods_num(GoodsInfo)||GoodsInfo<-GoodsInfoList],
  ok;

dbup_goods_num(GoodsInfo) ->
  Gkey = GoodsInfo#goods.key,
  Num = GoodsInfo#goods.num,
  if
	is_integer(Num) andalso Num > 0 ->
	  SQL = io_lib:format("update taobao_bag set num = ~p where gkey = ~p",[Num,Gkey]),
	  db:execute(SQL);
	is_integer(Num) andalso Num =:= 0->
	  dbdel_goods(GoodsInfo);
	true ->
	  throw({dbup_goods_num,Num}),
	  skip
  end.

dbdel_goods(GoodsInfoList) when is_list(GoodsInfoList) ->
  [dbdel_goods(GoodsInfo)||GoodsInfo<-GoodsInfoList];

dbdel_goods(GoodsInfo) ->
  SQL = io_lib:format("DELETE FROM taobao_bag where gkey = ~p",[GoodsInfo#goods.key]),
  db:execute(SQL).
