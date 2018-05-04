%%----------------------------------------------------
%% NPC商品 
%% @author yeahoo2000@gmail.com
%%         wpf (wprehard@qq.com)
%%----------------------------------------------------

%% 商品结构
-record(store_item, {
        base_id = 0            %% 物品BaseId
        ,name = <<>>            %% 物品名称
        ,price_type = 0         %% 价格类型
        ,price = 0              %% 单价
        ,num = 1                %% 可售数量(-1:不限)
        ,is_notice = 0          %% 是否需要公告
    }).
