%% @author and_me
%% @doc @todo Add description to mount_pack.


-module(pray_pack).
-include("common.hrl").
-include("server.hrl").
-include("pray.hrl").
-include("error_code.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([send_pray_info/2]).





send_pray_info(StPray,Player)->
	BagList = StPray#st_pray.bag_list,
	GoodsList = 
	[begin 
		WashInfo = [[attribute_util:attr_tans_client(Type),Value]||{Type,Value}<-ShopItem#pray_goods.wash_attr],
		Gemstone = [[Type,Value]||{Type,Value}<-ShopItem#pray_goods.gemstone_groove],
		 [
		  ShopItem#pray_goods.goods_id,	 	
		  ShopItem#pray_goods.num,
		  ShopItem#pray_goods.state,
		  WashInfo,
		  Gemstone]
	end||ShopItem<-BagList],
		Now = util:unixtime(),
	FashionTime = ?IF_ELSE(StPray#st_pray.fashion_time - Now >0,StPray#st_pray.fashion_time - Now,0),
	%?PRINT("GoodsList ~p ~p ~n equip_remain_time ~p ~n ~p ~n",[StPray#st_pray.left_cell_num,length(GoodsList),StPray#st_pray.equip_remain_time - Now,GoodsList]),
	PrayEquip = data_pray_equip:get(Player#player.lv),
    NeedTime = ?IF_ELSE(is_record(PrayEquip,base_pray_equip),PrayEquip#base_pray_equip.need_time,0),
	EquipRemainRime = ?IF_ELSE(StPray#st_pray.equip_remain_time - Now >0,StPray#st_pray.equip_remain_time - Now,0),
	{ok,Bin} = pt_140:write(14001, {
									StPray#st_pray.fashion_id,
									10001,
									FashionTime,
									data_quick_pray_gold:get_max_times() - StPray#st_pray.quick_times,
									data_quick_pray_gold:get(StPray#st_pray.quick_times+1),
									EquipRemainRime,
                  					NeedTime,
									StPray#st_pray.cell_num,
									GoodsList}),
	server_send:send_to_sid(Player#player.sid,Bin).