%% @author and_me
%% @doc @todo Add description to goods_pack.


-module(taobao_pack).
-include("common.hrl").
-include("goods.hrl").


%%打包并且推送消息
-export([pack_send_goods_info/2]).

%%仅仅是打包数据
-export([pack_goods_info_bin/1]).

pack_send_goods_info(_,undefined)->
  ok;

pack_send_goods_info(GoodsInfo,Sid) when is_record(GoodsInfo, goods)->
  pack_send_goods_info([GoodsInfo],Sid);

pack_send_goods_info(GoodsInfoList,Sid)->
  GoodsUpdateBin = pack_goods_info_bin(GoodsInfoList),
  server_send:send_to_sid(Sid,GoodsUpdateBin).

%% 打包物品信息
pack_goods_info_bin(GoodsInfoList)->
  GoodsList = [[GoodsInfo#goods.key,
	GoodsInfo#goods.goods_id,
	GoodsInfo#goods.num,
	  GoodsInfo#goods.bind]||GoodsInfo<-GoodsInfoList],
   {ok,Bin} = pt_250:write(25002,{GoodsList}),
  Bin.


