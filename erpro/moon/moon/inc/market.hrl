%%----------------------------------------------------
%% @doc 市场模块
%%
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------

-define(market_sale_max,           20). %% 拍卖最大上限
-define(market_buy_max,            10). %% 求购最大上限

-define(market_sale_key_str, <<"market_sale_key">>). %% 拍卖信息表主键标志符
-define(market_buy_key_str,  <<"market_buy_key">>).  %% 求购信息表主键标志符

-define(assets_type_coin,    0). %% 交易货币金币
-define(assets_type_gold,    1). %% 交易货币晶钻

-define(market_coin_id,  30000). %% 金币物品Id
-define(market_gold_id,  30003). %% 晶钻物品Id

-define(market_item_type_coin, 34). %% 金币类型
-define(market_item_type_gold, 36). %% 晶钻类型

-define(market_op_fail,      0). %% 操作失败
-define(market_op_succ,      1). %% 操作成功
-define(market_op_not_enough,2). %% 晶钻不足

-define(market_sale_row_count, 4). %% 每页多少条数据

-define(market_notice_tax,  2000). %% 发布到世界聊天费用
-define(market_sys_salerid, 0). %% 发布到世界聊天费用

-define(market_auto_idel_time,  3600 * 1000). %% 发布自动出售货物时间间隔
-define(market_auto_sale_time,  60 * 1000). %% 中间时间

-define(market_sort_type_time,  1).     %% 时间排序 
-define(market_sort_type_price, 2).     %% 价格排序 

-define(sail_time, 3*24*3600*1000).


%% 拍卖物品，应包括item记录的所有内容
-record(market_sale2, {
        sale_id = 0         %% 拍卖记录Id,为数据库生成Id
        ,role_id = 0        %% 角色Id
        ,srv_id = <<>>      %% 服务器标志符
        ,begin_time = 0     %% 开始时间
        ,end_time = 0       %% 到期时间
        ,price = 0          %% 价格 
        ,origin_price = 0   %% 原始价格
        ,quantity = 1       %% 数量
        ,item_base_id = 0   %% 物品基础Id
        ,item_name = <<>>   %% 物品名称
        ,type = 0           %% 物品类型
        ,saler_name = <<>>  %% 拍卖者名称
        ,saler_lev = 0      %% 拍卖者等级
        ,saler_career = 0   %% 职业 1:真武 2:魅影 3:天师 4:飞羽 5:天尊 6:新手 9:不限
    }).


%% 拍卖物品，应包括item记录的所有内容
-record(market_sale, {
        sale_id = 0         %% 拍卖记录Id,为数据库生成Id
        ,role_id = 0        %% 角色Id
        ,srv_id = <<>>      %% 服务器标志符
        ,begin_time = 0     %% 开始时间
        ,end_time = 0       %% 到期时间
        ,assets_type = 0    %% 交易货币种类 0:金币 1:晶钻
        ,price = 0          %% 价格 
        ,item_id = 0        %% 物品Id 
        ,item_base_id = 0   %% 物品基础Id
        ,item_name = <<>>   %% 物品名称
        ,type = 0           %% 物品类型
        ,use_type = 0       %% 物品的使用方式(0:不能直接使用 1:消耗, 2:不消耗，可重复使用 3:穿戴)
        ,bind = 0           %% 是否梆定(0:未梆定, 1:已梆定)
        ,source = 0         %% 物品来源。封印，锁妖塔，BOSS之类的
        ,quality = 0        %% 品质(0:白色 1:绿色 2:蓝色 3:黄色 4:紫色 9:不限)
        ,lev = 0            %% 物品级别
        ,career = 0         %% 职业 1:真武 2:魅影 3:天师 4:飞羽 5:天尊 6:新手 9:不限
        ,upgrade = 0        %% 修炼等级，0表示不可修炼
        ,enchant = -1       %% 强化等级，-1表示不可强化
        ,enchant_fail = 0   %% 强化失败次数 
        ,quantity = 1       %% 数量
        ,status = 0         %% 物品锁定状态标志, ?lock_release 0 才可以移动及交易
        ,pos = 0            %% 在包裹中的位置,添加到背包的时候重置
        ,lasttime = 0       %% 最后一次交易时间
        ,durability = -1    %% 当前耐久度(-1表示永不磨损)
        ,attr = []          %% 属性
        ,special = []       %% 特殊信息：[{Type, Val}, ...]
        ,max_base_attr = [] %% 最大基础属性
        ,saler_name = <<>>  %% 拍卖者名称
        ,saler_lev = 0      %% 拍卖者等级
        ,type_scort = 0         %% 物品归类，大类
        ,price_sort = {0, 0, 0}  %% 价格排序{PriceType, SinglePricc, SaleId} 
        ,price_tax = 0      %% 税后价格
        ,market_type = 0    %% 市场物品类型[由物品类型Type转换而成]
    }).

%% 求购物品
-record(market_buy, {
        buy_id = 0          %% 求购信息Id
        ,role_id            %% 角色Id
        ,srv_id             %% 服务器标识符
        ,role_name          %% 角色名称
        ,begin_time         %% 开始时间
        ,end_time           %% 结束时间
        ,assets_type        %% 价格货币类型
        ,unit_price         %% 单价
        ,quantity           %% 数量
        ,item_base_id       %% 物品基础Id
        ,item_name          %% 物品名称
        ,type               %% 物品类型
        ,quality            %% 品质
        ,lev                %% 等级
        ,career             %% 职业
        ,type_scort = 0     %% 物品归类，大类
        ,market_type = 0    %% 市场物品类型[由物品类型Type转换而成]
    }).

%% 均价情况
-record(market_avgprice, {
        item_base_id = 0        %% 物品基础ID
        ,coin_price_sum = 0     %% 总金币售价
        ,gold_price_sum = 0     %% 总晶钻售价
        ,coin_num = 0          %% 金币交易数量
        ,gold_num = 0          %% 晶钻交易数量
    }).

%% 系统自动出售
-record(market_auto_sale, {
        id = 0                  %% 自动出售记录序号 
        ,item_base_id = 0       %% 物品基础ID
        ,item_name = <<>>       %% 物品名称
        ,quantity = 0           %% 数量
        ,price_type = 0         %% 价格类型
        ,price = 0              %% 价格
        ,range = 0              %% 波动范围
        ,time = 0               %% 时长
        ,valid_time = 0         %% 时长
    }
).

