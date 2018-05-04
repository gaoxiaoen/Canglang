%%----------------------------------------------------
%% @doc 市场模块 
%% 
%% <pre>
%% 113
%% </pre>
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------
-module(market_rpc).

-export([
        handle/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("market.hrl").
-include("item.hrl").
-include("link.hrl").
-include("assets.hrl").
%%

%% 搜索拍卖物品
handle(11300, {Type, ItemName, MinLev, MaxLev, Quantity, Career, PageIndex, _SortType}, _Role) ->
    Result = market:search(sale, {Type, ItemName, MinLev, MaxLev, Quantity, Career, PageIndex, ?market_sort_type_price}),
    {reply, Result};

%% 查询我拍卖的物品
handle(11301, {}, #role{id = {RoleId, SrvId}}) ->
    Result = market:search(sale_self, {RoleId, SrvId}),
    {reply, {Result}};

%% 拍卖物品
handle(11302, {ItemId, AssetsType, Price, Time, Notice}, Role) ->
    case market:sale(item, Role, {ItemId, AssetsType, Price, Time, Notice}) of
        {ok, Msg, NewRole} ->
            role_api:push_assets(Role, NewRole),
            log:log(log_coin, {<<"拍卖">>, <<"">>, Role, NewRole}),
            NewRole2 = role_listener:special_event(NewRole, {1048, finish}), %% 在市城挂售或购买任意物品
            {reply, {?market_op_succ, Msg}, NewRole2};
        {false, lang_market_not_enough_tax} ->
            {reply, {11, ?L(<<"您不够铜币付保管费了哦">>)}};
        {false, lang_market_not_enough_gold} ->
            {reply, {13, ?L(<<"您身上的晶钻不够哦">>)}};
        {false, lang_market_not_enough_coin} ->
            {reply, {11, ?L(<<"你身上的铜币不够哦">>)}};
        {false, Reason} ->
            {reply, {?market_op_fail, list_to_bitstring(util:to_list(Reason))}}
    end;

%% 取消拍卖
handle(11303, {SaleId}, Role) ->
    Now = util:unixtime(),
    Cd = case get(market_canle_sale_cd) of
        undefined -> 0;
        C -> C
    end,
    case Cd < Now of
        true ->
            put(market_canle_sale_cd, Now),
            case market:cancle_sale(Role, SaleId) of
                {ok, NewRole} ->
                    {reply, {?market_op_succ, ?L(<<"撤销成功，物品已发送到你邮箱">>)}, NewRole};
                {false, Reason} ->
                    {reply, {?market_op_fail, Reason}}
            end;
        false ->
            {reply, {?market_op_fail, <<>>}}
    end;

%% 拍卖晶钻
%% handle(11304, {_GoldNum, _AssetsType, _Price, _Time, _Notice}, _Role) ->
%%     {reply, {?market_op_fail, <<"目前拍卖晶钻功能尚未开放">>}};
handle(11304, {GoldNum, AssetsType, Price, Time, Notice}, Role = #role{assets = #assets{gold = _RoleGold}}) ->
    case AssetsType =:= ?assets_type_coin of
        true ->
            case market:sale(gold, Role, {GoldNum, Price, Time, Notice}) of
                {ok, Msg, NewRole} ->
                    role_api:push_assets(Role, NewRole),
                    NewRole2 = role_listener:special_event(NewRole, {1048, finish}), %% 在市城挂售或购买任意物品
                    {reply, {?market_op_succ, Msg}, NewRole2};
                {false, lang_market_not_enough_tax} ->
                    {reply, {11, ?L(<<"您不够铜币付保管费了哦">>)}};
                {false, lang_market_not_enough_gold} ->
                    {reply, {13, ?L(<<"您身上的晶钻不够哦">>)}};
                {false, lang_market_not_enough_coin} ->
                    {reply, {11, ?L(<<"你身上的铜币不够哦">>)}};
                {false, Reason} ->
                    {reply, {?market_op_fail, list_to_bitstring(util:to_list(Reason))}}
            end;
        false ->
            {reply, {?market_op_fail, ?L(<<"只能用金币拍卖晶钻">>)}}
    end;

%% 拍卖金币
%% handle(11305, {_CoinNum, _AssetsType, _Price, _Time, _Notice}, _Role) ->
%%     {reply, {?market_op_fail, <<"目前拍卖金币功能尚未开放">>}};
handle(11305, {CoinNum, AssetsType, Price, Time, Notice}, Role) ->
    case AssetsType =:= ?assets_type_gold of
        true ->
            case market:sale(coin, Role, {CoinNum, Price, Time, Notice}) of
                {ok, Msg, NewRole} ->
                    role_api:push_assets(Role, NewRole),
                    NewRole2 = role_listener:special_event(NewRole, {1048, finish}), %% 在市城挂售或购买任意物品
                    {reply, {?market_op_succ, Msg}, NewRole2};
                {false, lang_market_not_enough_tax} ->
                    {reply, {11, ?L(<<"您不够铜币付保管费了哦">>)}};
                {false, lang_market_not_enough_gold} ->
                    {reply, {13, ?L(<<"您身上的晶钻不够哦">>)}};
                {false, lang_market_not_enough_coin} ->
                    {reply, {11, ?L(<<"你身上的铜币不够哦">>)}};
                {false, Reason} ->
                    {reply, {?market_op_fail, list_to_bitstring(util:to_list(Reason))}}
            end;
        false ->
            {reply, {?market_op_fail, ?L(<<"只能用晶钻拍卖金币">>)}}
    end;

%% 购买拍卖物品
handle(11306, {SaleId}, Role) ->
    case market:sale_buy(Role, SaleId) of
        {ok, Msg, NewRole} ->
            role_api:push_assets(Role, NewRole),
            log:log(log_coin, {<<"购买拍卖物品">>, <<"">>, Role, NewRole}),
            NewRole2 = role_listener:special_event(NewRole, {1048, finish}), %% 在市城挂售或购买任意物品
            {reply, {?market_op_succ, Msg}, NewRole2};
        {false, lang_market_not_enough_tax} ->
            {reply, {11, ?L(<<"您不够铜币付保管费了哦">>)}};
        {false, lang_market_not_enough_gold} ->
            {reply, {13, ?L(<<"您身上的晶钻不够哦">>)}};
        {false, lang_market_not_enough_coin} ->
            {reply, {11, ?L(<<"你身上的铜币不够哦">>)}};
        {false, lang_market_buy_gold_not_enough} ->
            {reply, {13, ?L(<<"您身上的晶钻不足以求购这么多东西">>)}};
        {false, lang_market_buy_coin_not_enough} ->
            {reply, {11, ?L(<<"您身上的铜币不足以求购这么多东西">>)}};
        {false, Reason} ->
            {reply, {?market_op_fail, Reason}};
        {?market_op_not_enough, Reason} ->
            {reply, {13, list_to_bitstring(util:to_list(Reason))}}
    end;

%% 发布信息到世界聊天
handle(11307, {SaleId}, Role) ->
    case market:send_sale_msg(SaleId, Role) of
        {ok, NewRole} ->
            role_api:push_assets(Role, NewRole),
            log:log(log_coin, {<<"发布拍卖信息">>, <<"世界窗口">>, Role, NewRole}),
            {reply, {?market_op_succ, ?L(<<"操作成功">>)}, NewRole};
        {false, lang_market_not_enough_tax} ->
            {reply, {11, ?L(<<"您不够铜币付保管费了哦">>)}};
        {false, lang_market_not_enough_gold} ->
            {reply, {13, ?L(<<"您身上的晶钻不够哦">>)}};
        {false, lang_market_not_enough_coin} ->
            {reply, {11, ?L(<<"你身上的铜币不够哦">>)}};
        {false, lang_market_buy_gold_not_enough} ->
            {reply, {13, ?L(<<"您身上的晶钻不足以求购这么多东西">>)}};
        {false, lang_market_buy_coin_not_enough} ->
            {reply, {11, ?L(<<"您身上的铜币不足以求购这么多东西">>)}};
        {false, Reason} ->
            {reply, {?market_op_fail, list_to_bitstring(util:to_list(Reason))}}
    end;

%% 查询求购物品
handle(11330, {Type, ItemName, MinLev, MaxLev, Quality, Career, PageIndex}, _Role) ->
    Result = market:search(buy, {Type, ItemName, MinLev, MaxLev, Quality, Career, PageIndex}),
    {reply, Result};

%% 查询我发布的求购信息
handle(11331, {}, #role{id = {RoleId, SrvId}}) ->
    Result = market:search(buy_self, {RoleId, SrvId}),
    {reply, {Result}};

%% 发布求购信息
%% handle(11332, _, _Role) ->
%%     {reply, {?market_op_fail, <<"该功能尚未开放">>}};
handle(11332, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice}, Role) ->
    case market:buy(item, Role, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice}) of
        {ok, Msg, NewRole} ->
            role_api:push_assets(Role, NewRole),
            log:log(log_coin, {<<"发布求购信息">>, <<"优先绑定">>, Role, NewRole}),
            {reply, {?market_op_succ, Msg}, NewRole};
        {false, lang_market_not_enough_tax} ->
            {reply, {11, ?L(<<"您不够铜币付保管费了哦">>)}};
        {false, lang_market_not_enough_gold} ->
            {reply, {13, ?L(<<"您身上的晶钻不够哦">>)}};
        {false, lang_market_not_enough_coin} ->
            {reply, {11, ?L(<<"你身上的铜币不够哦">>)}};
        {false, lang_market_buy_gold_not_enough} ->
            {reply, {13, ?L(<<"您身上的晶钻不足以求购这么多东西">>)}};
        {false, lang_market_buy_coin_not_enough} ->
            {reply, {11, ?L(<<"您身上的铜币不足以求购这么多东西">>)}};
        {false, Reason} ->
            {reply, {?market_op_fail, Reason}};
        {?market_op_not_enough, Reason} ->
            {reply, {13, list_to_bitstring(util:to_list(Reason))}}
    end;

%% 消息求购信息
handle(11333, {BuyId}, Role) ->
    case market:cancle_buy(Role, BuyId) of
        {ok, Msg, NewRole} ->
            role_api:push_assets(Role, NewRole),
            {reply, {?market_op_succ, Msg}, NewRole};
        {false, Reason} ->
            {reply, {?market_op_fail, Reason}}
    end;

%% 直接出售
handle(11334, {BuyId, ItemId, Quantity}, Role) ->
    case market:buy_sale(item, Role, {BuyId, ItemId, Quantity}) of
        {ok, Msg, NewRole} ->
            role_api:push_assets(Role, NewRole),
            {reply, {?market_op_succ, Msg}, NewRole};
        {false, Reason} ->
            {reply, {?market_op_fail, Reason}}
    end;

%% 获取市场均价
handle(11335, {ItemBaseId}, _Role) ->
    case market:average_price(ItemBaseId) of
        {false, _Reason} -> {reply, {?false, ?false}};
        {CoinAverPrice, GoldAverPrice} -> {reply, {CoinAverPrice, GoldAverPrice}};
        _ -> {reply, {?false, ?false}}
    end;

%% 搜索拍卖物品
handle(11336, {Type, ItemName}, _Role) ->
    Result = market:search(sale, {Type, ItemName, 0, 0, 9, 9, 1, 2}),
    {reply, Result};

%% 查询我出售的物品
handle(11340, {}, #role{id = {RoleId, SrvId}}) ->
    Result = market:search(sale_self, {RoleId, SrvId}),
    Data = format_data2(Result),
    Is_Full = 
        case erlang:length(Data) >= ?market_sale_max of 
            true -> 1;
            false -> 0
        end,
    {reply, {Is_Full, Data}};

%% 出售物品
%% @ItemId 表示物品的id,背包的位置
%% @Type 表示物品在客户端显示所属的类型，跟物品的类型不冲突
handle(11341, {ItemId, Price, Quantity, Notice}, Role = #role{id = {RoleId, SrvId},link = #link{conn_pid = ConnPid}}) ->
    Data = market:search(sale_self, {RoleId, SrvId}),
    Len =  erlang:length(Data),
    case Len >= ?market_sale_max of 
        false ->  
            case market:sale(item, Role, {ItemId, Price, Quantity, Notice}) of
                {ok, Msg, NewRole, SaleId} ->
                    role_api:push_assets(Role, NewRole),
                    log:log(log_coin, {<<"拍卖物品">>, <<"">>, Role, NewRole}),  
                    notice:alert(succ, ConnPid, Msg),
                    Is_Full = 
                        case Len + 1 >= ?market_sale_max of 
                            true -> 1;
                            false -> 0
                        end,
                    {reply, {SaleId, ItemId, Quantity, Is_Full}, NewRole};
                {false, lang_market_not_enough_tax} ->
                    notice:alert(error, ConnPid, ?MSGID(<<"您不够金币付保管费了哦">>)),
                    {reply, {0, ItemId, Quantity, 0}, Role};
                {false, lang_market_not_enough_coin} ->
                    notice:alert(error, ConnPid, ?MSGID(<<"你身上的金币不够哦">>)),
                    {reply, {0, ItemId, Quantity, 0}, Role};
                {false, Reason} ->
                    notice:alert(error, ConnPid, Reason),
                    {reply, {0, ItemId, Quantity, 0}, Role}
            end;
        true ->
            notice:alert(error, ConnPid, ?MSGID(<<"寄售空间20个已经满了">>)),
            {reply, {0, ItemId, Quantity, 1}, Role}
    end;

%% 进入购买页面
handle(11342, {}, _Role) ->
    {TotalPage, Result} = market:search(sale, {all, 1}), %%all表示所有的物品，1表示第一页 
    Data = format_data(Result),
    {reply, {TotalPage, Data}};

%% 进入查询具体某一种物品以及翻页
% @Type表示查询或者点击的类型
% @PageIndex表示查询第几页的数据
handle(11343, {Type, PageIndex}, _Role) ->
    {TotalPage, Result} = 
        case Type =:= 0 of 
            true ->
                market:search(sale, {all, PageIndex});  %%all表示所有的物品，1表示第一页
            _ ->
                market:search(sale, {Type, PageIndex})  %%all表示所有的物品，1表示第一页
        end,
    Data = format_data(Result),
    {reply, {TotalPage, Data}};

%% 购买物品
% @SaleId 表示拍卖纪录的id
handle(11344, {SaleId}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case market:sale_buy(Role, SaleId) of
        {ok, NewRole} ->
            % {reply, {SaleId}, NewRole};
            sys_conn:pack_send(ConnPid, 11344, {SaleId}),
            {ok, NewRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok}    
    end;

%% 取消出售
handle(11345, {SaleId}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case market:cancle_sale(Role, SaleId) of
        {ok, NewRole} ->
            % notice:alert(succ, ConnPid, ?MSGID(<<"撤销成功">>)),
            {reply, {SaleId}, NewRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok}
    end;

%% 进入查询相同物品以及翻页
% @Type表示查询或者点击的类型
% @PageIndex表示查询第几页的数据
handle(11346, {ItemBaseId, PageIndex}, _Role) ->
    {TotalPage, Result} = market:search(same_id, {ItemBaseId, PageIndex}),  %%all表示所有的物品，1表示第一页
    Data = format_data(Result),
    {reply, {TotalPage, Data}};

handle(_Cmd, _Data, _Role) ->
    {error, market_unknow_command}.

%% 获取部分数据
format_data(L) ->
    do_format_data(L,[]).
do_format_data([],L) ->L;
do_format_data([{_, SaleId, _, _, _, _, Price, _, Quantity, ItemBaseId, _, Type, _, Lev, Career}|T], L) ->
    do_format_data(T,[{SaleId, ItemBaseId, Quantity, Price, Type, Lev, Career}|L]).

format_data2(L) ->
    do_format_data2(L,[]).
do_format_data2([],L) ->L;
do_format_data2([{_, SaleId, _, _, _, _, _, Origin_Price, Quantity, ItemBaseId, _, Type, _, _, _}|T], L) ->
    do_format_data2(T,[{SaleId, ItemBaseId, Quantity, Origin_Price, Type}|L]).
