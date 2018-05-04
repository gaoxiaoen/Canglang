%----------------------------------------------------
%% 商城相关数据结构定义
%% @author mobin
%%----------------------------------------------------
-define(gold_item, 1).
-define(bind_gold_item, 2).
-define(fashion_item, 3).
-define(special_item, 4).
-define(bind_special_item, 5).


%% 商城物品数据结构
-record(shop_item, {
        id = 0              %% ID
        ,base_id = 0        %% 物品ID
        ,type = 0           %% 物品类型 1:道具 2:绑定 3:时装 4:晶钻优惠商品 5:绑定晶钻优惠商品
        ,price = 9999       %% 价格
        ,label = 0          %% 商品标签 1:新品 2:置顶 3:热卖 4:限购 5：抢购
        ,alias = <<>>        %%搜索别名
        %%优惠物品专用
        ,origin_price = 10000    %% 原价   
        ,count = 0               %% 数量

    }
).
