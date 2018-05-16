%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 二月 2016 上午11:56
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(GOLD_SHOP, 1). %% 元宝商店
-define(BGOLD_SHOP, 2). %% 绑定元宝商店
-define(REPUTE_SHOP, 3).%%  声望商店
-define(HONOUR_SHOP, 4).%% 荣誉商店
-define(EXPLOIT_SHOP, 5).%% 功勋商店
-define(SD_PT_SHOP, 6).%% 历练商店
-define(FAIRY_CRYSTAL_SHOP, 7).%% 仙晶商店

-record(st_shop, {
    is_change = 0,
    refresh_time = 0,
    refresh_count = 0,
    shop_list = []
}).

-record(base_shop, {
    id = 0,         %% 商品id
    shop_type = 0,  %% 1元宝 2绑定元宝
    goods_id = 0,   %% 物品id
    goods_num = -1, %% -1 为不限购
    cost = 0,       %% 单价
    discount = 0,   %% 90代表9折
    icon_type = 0,  %% 1打折 2热卖 3新品 4限购
    base = 1,        %% 每次至少购买x个
    max_num = 0,    %% 单次购买最大组数
    %% 自动购买消耗
    gold = 0,
    bgold = 0,
    coin = 0
}).
