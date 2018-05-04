%% -----------------------
%% vip配置表
%% @autor wangweibiao
%% ------------------------
-module(vip_data2).
-export([get_vip_base/1,
		get_risk_gift_base/1,
		get_gift_base/1,
		get_all_lev/0
		]).
-include("vip.hrl").
-include("common.hrl").




get_all_lev() ->
	[100,300,500,1000,3000,5000,10000,30000,60000,120000].
get_vip_base(1) ->
	{ok, #vip_base{
			effect = [{buy_energy,1},{clear_item, 306001},{dungeon_reset,1},{arena_buy,1},{expedition_buy,1}]
		}
	};
get_vip_base(2) ->
	{ok, #vip_base{
			effect = [{buy_energy,2},{clear_item, 306002},{npc_store,1},{enchant_ratio,0.02}]
		}
	};
get_vip_base(3) ->
	{ok, #vip_base{
			effect = [{buy_energy,3},{clear_item, 306003},{dungeon_reset,2}]
		}
	};
get_vip_base(4) ->
	{ok, #vip_base{
			effect = [{buy_energy,4},{clear_item, 306004},{arena_buy,2},{expedition_buy,2}]
		}
	};
get_vip_base(5) ->
	{ok, #vip_base{
			effect = [{buy_energy,5},{clear_item, 306005},{dungeon_reset,3},{npc_store,2}]
		}
	};
get_vip_base(6) ->
	{ok, #vip_base{
			effect = [{buy_energy,6},{clear_item, 306006},{enchant_ratio,0.04}]
		}
	};
get_vip_base(7) ->
	{ok, #vip_base{
			effect = [{buy_energy,7},{clear_item, 306007},{arena_buy,3},{expedition_buy,3}]
		}
	};
get_vip_base(8) ->
	{ok, #vip_base{
			effect = [{buy_energy,8},{clear_item, 306008},{dungeon_reset,4},{npc_store,3}]
		}
	};
get_vip_base(9) ->
	{ok, #vip_base{
			effect = [{buy_energy,9},{clear_item, 306009},{arena_buy,4},{expedition_buy,4}]
		}
	};
get_vip_base(10) ->
	{ok, #vip_base{
			effect = [{buy_energy,10},{clear_item, 306010},{dungeon_reset,5},{enchant_ratio,0.06}]
		}
	};
	
get_vip_base(_Id) ->
	{false,?L(<<"数据不存在">>)}.
	
get_gift_base(1) ->
	{ok, #vip_gift_base{
			base_id = 532501,
			price = 5		}
	};
get_gift_base(2) ->
	{ok, #vip_gift_base{
			base_id = 532502,
			price = 200		}
	};
get_gift_base(3) ->
	{ok, #vip_gift_base{
			base_id = 532503,
			price = 300		}
	};
get_gift_base(4) ->
	{ok, #vip_gift_base{
			base_id = 532504,
			price = 500		}
	};
get_gift_base(5) ->
	{ok, #vip_gift_base{
			base_id = 532505,
			price = 1000		}
	};
get_gift_base(6) ->
	{ok, #vip_gift_base{
			base_id = 532506,
			price = 3000		}
	};
get_gift_base(7) ->
	{ok, #vip_gift_base{
			base_id = 532507,
			price = 5000		}
	};
get_gift_base(8) ->
	{ok, #vip_gift_base{
			base_id = 532508,
			price = 3500		}
	};
get_gift_base(9) ->
	{ok, #vip_gift_base{
			base_id = 532509,
			price = 10000		}
	};
get_gift_base(10) ->
	{ok, #vip_gift_base{
			base_id = 532510,
			price = 12000		}
	};
	
get_gift_base(_Id) ->
	{false,?L(<<"数据不存在">>)}.	

get_risk_gift_base(1) ->
	{ok, #risk_gift_base{
			lev = 1,
			time = 30,
			coin = 400000,
			effect = [{gift_id,204000}]
		}
	};
get_risk_gift_base(2) ->
	{ok, #risk_gift_base{
			lev = 3,
			time = 30,
			coin = 1000000,
			effect = [{gift_id,204001},{arena_loss,1}]
		}
	};
get_risk_gift_base(3) ->
	{ok, #risk_gift_base{
			lev = 5,
			time = 30,
			coin = 2000000,
			effect = [{gift_id,204002},{arena_loss,1},{channle_up,1}]
		}
	};
		
	
get_risk_gift_base(_Id) ->
	{false,?L(<<"数据不存在">>)}.
	
