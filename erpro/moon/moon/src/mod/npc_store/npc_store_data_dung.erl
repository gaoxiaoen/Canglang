%%----------------------------------------------------
%% 副本NPC神秘商店数据
%% @author wpf(wprehard@qq.com)
%%----------------------------------------------------
-module(npc_store_data_dung).
-export([
     list_default/0
     ,list/0
     ,get_default/1
     ,get/1
   ]
).

-include("npc_store.hrl").


%% NPC神秘商品默认产出列表（备用）
list_default() ->
    [32001,23003,23001,33051].

%% NPC神秘商品基础数据列表
list() ->
    [29216,29217,29218,29219,21021,21022,25023,33053,21035,26060,26061,26062,26063,26064,26065,26066,26067,26068,29220,25022,29295].

%% NPC神秘商品 -- 默认
%% @spec get_default(Reason}
%% BaseId -> integer() 
%% Items -> #store_item_base{}
get_default(32001) -> 
    {ok, #store_item_base{
           base_id = 32001
           ,name = <<"护神丹">>
           ,price = 100
           ,price_type = 3
           ,rand = 3
        }
    };
get_default(23003) -> 
    {ok, #store_item_base{
           base_id = 23003
           ,name = <<"仙宠潜力保护符">>
           ,price = 50
           ,price_type = 3
           ,rand = 3
        }
    };
get_default(23001) -> 
    {ok, #store_item_base{
           base_id = 23001
           ,name = <<"仙宠成长丹">>
           ,price = 27
           ,price_type = 3
           ,rand = 3
        }
    };
get_default(33051) -> 
    {ok, #store_item_base{
           base_id = 33051
           ,name = <<"圣域仙草">>
           ,price = 160
           ,price_type = 3
           ,rand = 3
        }
    };
get_default(_) ->
    error.

%% NPC神秘商品
%% @spec get(Id) -> {ok, #store_item_base{}} | {false, Msg}
get(29216) -> 
    {ok, #store_item_base{
           base_id = 29216
           ,name = <<"护神丹*10礼包">>
           ,price = 800
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(29217) -> 
    {ok, #store_item_base{
           base_id = 29217
           ,name = <<"仙宠潜力保护符*10礼包">>
           ,price = 500
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(29218) -> 
    {ok, #store_item_base{
           base_id = 29218
           ,name = <<"仙宠成长丹*10礼包">>
           ,price = 270
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(29219) -> 
    {ok, #store_item_base{
           base_id = 29219
           ,name = <<"圣域仙草*10礼包">>
           ,price = 1600
           ,price_type = 3
           ,num = 1
           ,rand = 600
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(21021) -> 
    {ok, #store_item_base{
           base_id = 21021
           ,name = <<"精品幸运石">>
           ,price = 100
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(21022) -> 
    {ok, #store_item_base{
           base_id = 21022
           ,name = <<"优良幸运石 ">>
           ,price = 245
           ,price_type = 3
           ,num = 1
           ,rand = 200
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(25023) -> 
    {ok, #store_item_base{
           base_id = 25023
           ,name = <<"火凤羽">>
           ,price = 300
           ,price_type = 3
           ,num = 1
           ,rand = 400
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(33053) -> 
    {ok, #store_item_base{
           base_id = 33053
           ,name = <<"仙法竞技神符">>
           ,price = 80
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(21035) -> 
    {ok, #store_item_base{
           base_id = 21035
           ,name = <<"继承保护符碎片">>
           ,price = 200
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(26060) -> 
    {ok, #store_item_base{
           base_id = 26060
           ,name = <<"四级气血石">>
           ,price = 250
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(26061) -> 
    {ok, #store_item_base{
           base_id = 26061
           ,name = <<"四级法力石">>
           ,price = 100
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(26062) -> 
    {ok, #store_item_base{
           base_id = 26062
           ,name = <<"四级攻击石">>
           ,price = 300
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(26063) -> 
    {ok, #store_item_base{
           base_id = 26063
           ,name = <<"四级防御石">>
           ,price = 150
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(26064) -> 
    {ok, #store_item_base{
           base_id = 26064
           ,name = <<"四级暴击石">>
           ,price = 200
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(26065) -> 
    {ok, #store_item_base{
           base_id = 26065
           ,name = <<"四级命中石">>
           ,price = 300
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(26066) -> 
    {ok, #store_item_base{
           base_id = 26066
           ,name = <<"四级躲闪石">>
           ,price = 300
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(26067) -> 
    {ok, #store_item_base{
           base_id = 26067
           ,name = <<"四级坚韧石">>
           ,price = 150
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(26068) -> 
    {ok, #store_item_base{
           base_id = 26068
           ,name = <<"四级敏捷石">>
           ,price = 800
           ,price_type = 3
           ,num = 1
           ,rand = 200
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(29220) -> 
    {ok, #store_item_base{
           base_id = 29220
           ,name = <<"仙宠精魂·蓝*10">>
           ,price = 480
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(25022) -> 
    {ok, #store_item_base{
           base_id = 25022
           ,name = <<"神器之魄">>
           ,price = 180
           ,price_type = 3
           ,num = 1
           ,rand = 500
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };
get(29295) -> 
    {ok, #store_item_base{
           base_id = 29295
           ,name = <<"灵幻石*10礼包">>
           ,price = 500
           ,price_type = 3
           ,num = 1
           ,rand = 600
           ,limit = 1
           ,limit_time = {0,0}
           ,limit_num = {0,0}
           ,is_notice = 1
        }
    };

get(_Id) ->
    {false, <<"无此物品信息">>}.
