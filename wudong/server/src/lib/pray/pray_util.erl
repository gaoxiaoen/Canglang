%% @author and_me
%% @doc @todo Add description to mount_util.


-module(pray_util).
-include("common.hrl").
-include("pray.hrl").

-export([pray_goods_finsh/1]).

%%将祈祷物品置于
pray_goods_finsh(GoodsList)->
	[
	 begin
		if PrayGoods#pray_goods.state == ?PRAY_STATE_ING->
				pray_load:update_pray_goods_state(PrayGoods#pray_goods{state = ?PRAY_STATE_FINSH}),
					PrayGoods#pray_goods{state = ?PRAY_STATE_FINSH};
						true->
							PrayGoods
		end
	end||PrayGoods<-GoodsList].



%% ====================================================================
%% Internal functions
%% ====================================================================


