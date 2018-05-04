%%----------------------------------------------------
%% 商城相关远程调用
%%
%% @author mobin
%%----------------------------------------------------
-module(shop_rpc).
-export([handle/3]).
-include("common.hrl").
-include("shop.hrl").
-include("role.hrl").
-include("item.hrl").
-include("storage.hrl").
-include("gain.hrl").

%% 获取普通商品列表
handle(12000, {ItemsType}, _Role) ->
    Items = shop:list(ItemsType),
    ?DEBUG("common_items, ~w~n", [Items]),
    {reply, {ItemsType, Items}};

%%获取优惠商品列表
handle(12001, {}, #role{id = Rid}) ->
    {reply, {shop:list_special(Rid)}};

%%获取人气商品列表
handle(12002, {}, _Role) ->
    Items = shop:list_rank(),
    ?DEBUG("rank_items, ~w~n", [Items]),
    {reply, {Items}};

%% 购买商品
handle(12010, {Id, Num, Type}, Role) when Num >= 1 ->
    buy_common(Id, Num, Type, Role);
    
%% 购买限购商品
handle(12011, {Id, Num, Type}, Role) when Num >= 1 ->
    ?DEBUG("quota ~w, ~w, ~w~n", [Id, Num, Type]),
    case shop:buy_quota(Id, Num, Type, Role) of
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok};
        {ok, LogGoldType, Items, NewAssets, NewBag} ->
            Role2 = Role#role{assets = NewAssets, bag = NewBag},
            Role3 = role_api:push_assets(Role, Role2),
            log:log(LogGoldType, {<<"购买限购商品">>, log_conv:parse_shop_buy_items(Items), <<"购买限购商品">>, Role, Role3}),
            notice:alert(succ, Role, ?MSGID(<<"购买成功，物品已经发送到你的背包">>)),
            {reply, {Id}, Role3}
    end;

%% 购买抢购商品
handle(12012, {Id, Type}, Role) ->
    ?DEBUG("limit ~w, ~w~n", [Id, Type]),
    case shop:buy_limited(Id, Type, Role) of
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok};
        {ok, LogGoldType, Items, NewAssets, NewBag} ->
            Role2 = Role#role{assets = NewAssets, bag = NewBag},
            Role3 = role_api:push_assets(Role, Role2),
            log:log(LogGoldType, {<<"购买抢购商品">>, log_conv:parse_shop_buy_items(Items), <<"购买抢购商品">>, Role, Role3}),
            Role4 = role_listener:special_event(Role3, {1032, finish}),
            notice:alert(succ, Role, ?MSGID(<<"购买成功，物品已经发送到你的背包">>)),
            {reply, {Id}, Role4}
    end;

%% 购买时装
handle(12013, {OprType, Id, Expire, Attr_idx, 0}, Role)  ->
    buy_fashion(OprType, Id, Expire, Attr_idx, 0, Role);
handle(12013, {OprType, Id, Expire, Attr_idx, DiscountBaseId = 501010}, Role = #role{bag = #bag{items = Items}})  ->
    case storage:find(Items, #item.base_id, DiscountBaseId) of
        {false, _} ->
            notice:alert(error, Role, ?MSGID(<<"您没有此优惠券喔">>));
            {ok, _Num, _L, _BL, _UNL} ->
                buy_fashion(OprType, Id, Expire, Attr_idx, DiscountBaseId, Role)
    end;

%% 赠送时装
%%handle(12014, {SheRid, SheSrvid, Id, Expire, Attr_idx}, Role = #role{name = Name})  ->
%%    ?DEBUG("common ~w, ~w, ~w~n", [Id, Expire, Attr_idx]),
%%    case friend:is_friend({SheRid, SheSrvid}) of
%%        false ->
%%            notice:alert(error, Role, ?MSGID(<<"您没有此好友！">>)),
%%            {ok};
%%        _ ->
%%            case shop:buy_fashion(Id, Expire, Attr_idx, 0, Role) of
%%                {false, ReasonId} ->
%%                    notice:alert(error, Role, ReasonId),
%%                    {ok};
%%                {ok, LogGoldType, Item, NewAssets} ->
%%                    Content = util:fbin(?L(<<"您的好友~s送给您一件时装">>), [Name]),
%%                    case mail:send_system([{SheRid, SheSrvid}], {?L(<<"收到一件时装">>), Content, [], [Item]}) of
%%                        ok ->       
%%                            Role1 = role_listener:buy_item_shop(Role#role{assets = NewAssets}, [Item]),
%%                            Role2 = role_api:push_assets(Role, Role1),
%%                            log:log(LogGoldType, {<<"商城购买">>, log_conv:parse_shop_buy_items([Item]), <<"商城购买">>, Role, Role2}),
%%                            Role3 = role_listener:special_event(Role2, {1032, finish}),
%%                            notice:alert(succ, Role, ?MSGID(<<"赠送成功，时装已经发送给您好友">>)),
%%                            {ok, Role3};
%%                        {false, _R} ->
%%                            ?ERR("赠送时装失败了 ,  原因:~s",[_R]),
%%                            notice:alert(succ, Role, ?MSGID(<<"赠送失败，邮件功能暂时不可用，请稍后再试。">>)),
%%                            {ok, Role}
%%                    end
%%            end
%%end;

handle(12015, {BaseId, Num}, Role) when Num >= 1 ->
    case shop:get_id_by_base_id(BaseId) of
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok};
        Id ->
            buy_common(Id, Num, ?gold_item, Role)
    end;

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%% ----------- ----------------------------
buy_common(Id, Num, Type, Role) ->
    ?DEBUG("common ~w, ~w, ~w~n", [Id, Num, Type]),
    case shop:buy(Id, Num, Type, Role) of
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok};
        {ok, LogGoldType, Items, NewAssets, NewBag} ->
            Role2 = role_listener:buy_item_shop(Role, Items),
            Role3 = role_listener:get_item(Role2#role{assets = NewAssets, bag = NewBag}, Items),
            Role4 = role_api:push_assets(Role, Role3),
            log:log(LogGoldType, {<<"商城购买">>, log_conv:parse_shop_buy_items(Items), <<"商城购买">>, Role, Role4}),
            Role5 = role_listener:special_event(Role4, {1032, finish}),
            notice:alert(succ, Role, ?MSGID(<<"购买成功，物品已经发送到你的背包">>)),
            {ok, Role5}
    end.

buy_fashion(OprType, Id, Expire, Attr_idx, DiscountBaseId, Role)  ->
    ?DEBUG("common OprType: ~w,  ~w, ~w, ~w ~n", [OprType, Id, Expire, Attr_idx]),
    case shop:buy_fashion(Id, Expire, Attr_idx, DiscountBaseId, Role) of
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {reply, {?false}};
        {ok, LogGoldType, Item, NewAssets} ->
            {DressId, Role1} = dress:add_dress(Item, Role),
            Role2 = do_dress_misc(OprType, DressId, Role1),
            dress:pack_send_dress_info(Role2),
            Role3 = role_listener:buy_item_shop(Role2, [Item]),
            Role4 = role_listener:get_item(Role3#role{assets = NewAssets}, [Item]),
            Role5 = role_api:push_assets(Role, Role4),
            Role6 = role_api:push_attr(Role5),
            Role7 = looks:calc(Role6),
            looks:refresh(Role, Role7),
            log:log(LogGoldType, {<<"商城购买">>, log_conv:parse_shop_buy_items([Item]), <<"商城购买">>, Role, Role7}),
            Role8 = role_listener:special_event(Role7, {1032, finish}),
            case DiscountBaseId =/= 0 of
                true ->
                    {ok, Role9} = role_gain:do([#loss{label = itemsall, val = [{DiscountBaseId, 1}]}], Role8),
                    {reply, {?true}, Role9};
                false ->
                    {reply, {?true}, Role8}
            end
    end.

do_dress_misc(OprType, DressId, Role) ->
    case OprType =:= 0 of
        true ->
            notice:alert(succ, Role, ?MSGID(<<"购买成功，时装已经发送到你的衣柜">>)),
            Role;
        false ->
            case dress:change_dress([DressId], Role) of
                {ok, Role1} ->
                    notice:alert(succ, Role1, ?MSGID(<<"保存成功">>)),
                    Role1;
                {false, _Reason} ->
                    ?DEBUG(" 穿戴失败  ~p", [_Reason]),
                    notice:alert(succ, Role, ?MSGID(<<"20级才可穿戴，时装已保存在衣柜，快快升级吧">>)),
                    Role
            end
    end.

