%% **************************************
%% 日志信息记录接口
%% (各模块日志信息保存内容)
%% @author wpf (wprehard@qq.com)
%% **************************************
-module(log).
-export([
        init/0
        ,timer_init/0
        ,log/1
        ,log/2
        ,log_rollback/1
        %% ----------------
        ,log_gold/4
    ]).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("dungeon.hrl").
-include("assets.hrl").
-include("market.hrl").
-include("link.hrl").
-include("pet.hrl").
-include("storage.hrl").
-include("guild.hrl").
-include("item.hrl").
-include("activity.hrl").

%% 不同类型日志写数据库表的间隔时间 (秒)
%% 支持热更新，需要运行log_mgr:adm_reload/0
-define(SYNC_CD_COMMON,     16).
-define(SYNC_CD_COIN,       3).
-define(SYNC_CD_STORAGE,    5).
-define(SYNC_CD_ITEM,       7).
-define(SYNC_CD_LOGIN,      10).
-define(SYNC_CD_GOLD,       20).
-define(SYNC_CD_LOTTERY,    25).
-define(SYNC_CD_BLACKSMITH, 40).
-define(SYNC_CD_CHANNEL,    50).
-define(SYNC_CD_UP_LEV,     55).
-define(SYNC_CD_PET_UPDATE, 70).
-define(SYNC_CD_GIFT_AWARD, 85).
-define(SYNC_CD_INTEGRAL,   100).
-define(SYNC_CD_GIFT_OPEN,  80).
-define(SYNC_CD_ATTAINTMENT,30).
-define(SYNC_CD_LILIAN,     12).
-define(SYNC_CD_MOUNT,      18).
-define(SYNC_CD_DEMON,      13).

%% @spec init() -> true
%% @doc 初始化所有日志ets表
init() ->
    ets:new(log_role_login, [public, duplicate_bag, named_table]),
    ets:new(log_shop, [public, duplicate_bag, named_table]),
    ets:new(log_item_drop, [public, duplicate_bag, named_table]),
    ets:new(log_item_del, [public, duplicate_bag, named_table]),
    ets:new(log_storage_handle, [public, duplicate_bag, named_table]),
    ets:new(log_coin, [public, duplicate_bag, named_table]),
    ets:new(log_stone, [public, duplicate_bag, named_table]),
    ets:new(log_gold, [public, duplicate_bag, named_table]),
    ets:new(log_market, [public, duplicate_bag, named_table]),
    ets:new(log_lottery, [public, duplicate_bag, named_table]),
    ets:new(log_role_up_lev, [public, duplicate_bag, named_table]),
    ets:new(log_exchange, [public, duplicate_bag, named_table]),
    ets:new(log_pet_update, [public, duplicate_bag, named_table]),
    ets:new(log_pet2, [public, duplicate_bag, named_table]),
    ets:new(log_bind_gold, [public, duplicate_bag, named_table]),
    ets:new(log_integral, [public, duplicate_bag, named_table]),
    ets:new(log_blacksmith, [public, duplicate_bag, named_table]),
    ets:new(log_channel_state, [public, duplicate_bag, named_table]),
    ets:new(log_activity, [public, duplicate_bag, named_table]),
    ets:new(log_channel, [public, duplicate_bag, named_table]),
    ets:new(log_gift_award, [public, duplicate_bag, named_table]),
    ets:new(log_gift_open, [public, duplicate_bag, named_table]),
    ets:new(log_intimacy, [public, duplicate_bag, named_table]),
    ets:new(log_mount_feed, [public, duplicate_bag, named_table]),
    ets:new(log_npc_store_live, [public, duplicate_bag, named_table]),
    ets:new(log_pet_del, [public, duplicate_bag, named_table]),
    ets:new(log_attainment, [public, duplicate_bag, named_table]),
    ets:new(log_xd_lilian, [public, duplicate_bag, named_table]),
    ets:new(log_mount_handle, [public, duplicate_bag, named_table]),
    ets:new(log_handle_all, [public, duplicate_bag, named_table]),
    ets:new(log_demon_update, [public, duplicate_bag, named_table]),
    ets:new(log_task_wanted, [public, duplicate_bag, named_table]),
    ets:new(log_dungeon_box, [public, duplicate_bag, named_table]),
    ets:new(log_soul_world, [public, duplicate_bag, named_table]),
    ets:new(log_item_output, [public, duplicate_bag, named_table]),
    ets:new(log_world_compete_section, [public, duplicate_bag, named_table]),
    ets:new(log_shop_activity, [public, duplicate_bag, named_table]),
    ets:new(log_soul, [public, duplicate_bag, named_table]),
    ets:new(log_taobao, [public, duplicate_bag, named_table]),
    ets:new(log_demon2, [public, duplicate_bag, named_table]),
    ets:new(log_guild_wishshop, [public, duplicate_bag, named_table]),
    ets:new(log_pet_dragon, [public, duplicate_bag, named_table]),
    ets:new(log_super_boss, [public, duplicate_bag, named_table]),
    ets:new(log_activity_activeness, [public, duplicate_bag, named_table]),
    ets:new(log_medal, [public, duplicate_bag, named_table]),
    ets:new(log_dungeon_drop, [public, duplicate_bag, named_table]),
    ok.

%% @spec timer_init() -> list()
%% @doc 初始化回写数据库的定时器，按照不同类型
timer_init() ->
    [
        {log_role_login, ?SYNC_CD_LOGIN}
        ,{log_item_del, ?SYNC_CD_ITEM}
        ,{log_coin, ?SYNC_CD_COIN}
        ,{log_stone, ?SYNC_CD_COIN}
        ,{log_gold, ?SYNC_CD_GOLD}
        ,{log_shop, ?SYNC_CD_COMMON}
        ,{log_item_drop, ?SYNC_CD_COMMON}
        ,{log_storage_handle, ?SYNC_CD_STORAGE}
        ,{log_market, ?SYNC_CD_COMMON}
        ,{log_lottery, ?SYNC_CD_LOTTERY}
        ,{log_role_up_lev, ?SYNC_CD_UP_LEV}
        ,{log_exchange, ?SYNC_CD_COMMON}
        ,{log_pet_update, ?SYNC_CD_PET_UPDATE}
        ,{log_pet2, ?SYNC_CD_PET_UPDATE}
        ,{log_integral, ?SYNC_CD_INTEGRAL}
        ,{log_bind_gold, ?SYNC_CD_INTEGRAL}
        ,{log_blacksmith, ?SYNC_CD_BLACKSMITH}
        ,{log_channel_state, ?SYNC_CD_CHANNEL}
        ,{log_activity, ?SYNC_CD_COMMON}
        ,{log_channel, ?SYNC_CD_CHANNEL}
        ,{log_gift_award, ?SYNC_CD_GIFT_AWARD}
        ,{log_gift_open, ?SYNC_CD_GIFT_OPEN}
        ,{log_intimacy, ?SYNC_CD_COMMON}
        ,{log_mount_feed, ?SYNC_CD_STORAGE}
        ,{log_npc_store_live, ?SYNC_CD_INTEGRAL}
        ,{log_pet_del, ?SYNC_CD_INTEGRAL}
        ,{log_attainment, ?SYNC_CD_ATTAINTMENT}
        ,{log_xd_lilian, ?SYNC_CD_LILIAN}
        ,{log_mount_handle, ?SYNC_CD_MOUNT}
        ,{log_handle_all, ?SYNC_CD_COMMON}
        ,{log_demon_update, ?SYNC_CD_DEMON}
        ,{log_task_wanted, ?SYNC_CD_COMMON}
        ,{log_dungeon_box, ?SYNC_CD_COMMON}
        ,{log_soul_world, ?SYNC_CD_COMMON}
        ,{log_item_output, ?SYNC_CD_COMMON}
        ,{log_world_compete_section, ?SYNC_CD_COMMON}
        ,{log_shop_activity, ?SYNC_CD_GOLD}
        ,{log_soul, ?SYNC_CD_COMMON}
        ,{log_taobao, ?SYNC_CD_COMMON}
        ,{log_demon2, ?SYNC_CD_COMMON}
        ,{log_guild_wishshop, ?SYNC_CD_COMMON}
        ,{log_pet_dragon, ?SYNC_CD_COMMON}
        ,{log_super_boss, ?SYNC_CD_COMMON}
        ,{log_activity_activeness, ?SYNC_CD_COMMON}
        ,{log_medal, ?SYNC_CD_COMMON}
        ,{log_dungeon_drop, ?SYNC_CD_COMMON}
    ].

%% @spec log_gold(Cmd, Args, Role, NewRole) -> any()
%% @doc 晶钻日志记录
log_gold(Cmd, Args, Role = #role{assets = #assets{gold = Gold}}, #role{assets = #assets{gold = NewGold}}) ->
    DetGold = NewGold - Gold,
    case abs(DetGold) > 0 of
        false -> ignore;
        true ->
            case log_cfg:conv_gold(Cmd, Args) of
                {HandleType, Remark} ->
                    log:log(log_gold, {HandleType, Remark, HandleType, Role, {Gold, DetGold}});
                {HandleType, Remark, StatKey} ->
                    log:log(log_gold, {HandleType, Remark, StatKey, Role, {Gold, DetGold}});
                _ -> ignore
            end
    end;
log_gold(_, _, _, _) -> ignore.

%% ----------------------------------------------
%% 日志的内容记录: 将不同类型的日志信息保存至ets；各模块在需要记录日志的地方调用

%% @spec log(LogList) -> any()
%% @doc 记录一组日志信息
log([]) -> ignore;
log([{Type, Data} | T]) ->
    log(Type, Data),
    log(T);
log([_ | T]) ->
    log(T).

%% @spec log(Type, Data) -> any()
%% @doc 记录日志

%% 登入登出
log(log_role_login, #role{id = {Rid, SrvId}, account = Account, platform = Platform, name = Name, career = Career, lev = Lev, link = #link{ip = {N1, N2, N3, N4}}, login_info = #login_info{login_time = Ctime, reg_time = RegTime, device_id = DeviceId}}) ->
    log_host:log(log_role_login, {Rid, SrvId, Platform, Name, Lev, Career, 0, Ctime, log_conv:ip2bitstring(N1, N2, N3, N4), Account, RegTime, DeviceId, 0});
log(log_role_logout, #role{id = {Rid, SrvId}, account = Account, platform = Platform, name = Name, career = Career, lev = Lev, link = #link{ip = {N1, N2, N3, N4}}, login_info = #login_info{login_time = LoginTime, reg_time = RegTime, device_id = DeviceId}}) ->
    Ctime = util:unixtime(),
    Online = try Ctime - LoginTime catch _:_ -> 0 end,
    log_host:log(log_role_login, {Rid, SrvId, Platform, Name, Lev, Career, 1, Ctime, log_conv:ip2bitstring(N1, N2, N3, N4), Account, RegTime, DeviceId, Online});

%% 交易日志
log(log_exchange, {FromId, FromSrvid, FromName, FromLock, FromCoin, FromGold, FromItems, FromCon, ToId, ToSrvid, ToName, ToLock, ToCoin, ToGold, ToItems, ToCon}) ->
    I1 = log_conv:exchange(item, FromItems),
    I2 = log_conv:exchange(item, ToItems),
    S = log_conv:exchange(state, {FromLock, ToLock, FromCon, ToCon}),
    Now = util:unixtime(),
    log_host:log(log_exchange, [
            {FromId, FromSrvid, FromName, FromCoin, FromGold, I1, ToId, ToSrvid, ToName, ToCoin, ToGold, I2, S, Now},
            {ToId, ToSrvid, ToName, ToCoin, ToGold, I2, FromId, FromSrvid, FromName, FromCoin, FromGold, I1, S, Now}
        ]);

%% 商城消费
log(log_shop, {BaseId, Num, ShopType, GoldType, GoldNum, #role{id = {Id, SrvId}, name = Name}}) ->
    ItemName = log_conv:item(name, BaseId),
    log_host:log(log_shop, {BaseId, ItemName, ShopType, Num, GoldType, GoldNum, Id, SrvId, Name, util:unixtime()});
log(log_shop, _) -> ignore;

%% 物品掉落
%% Drops = [{NpcId, ItemId} | ...]
log(log_item_drop, {Drops, Rid, Rsrvid, Rname}) ->
    Now = util:unixtime(),
    DataList = log_item_drop(Drops, Rid, Rsrvid, Rname, Now, []),
    log_host:log(log_item_drop, DataList);

%% 副本翻牌掉落
log(log_dungeon_box, {#role{id = {Rid, SrvId}, name = Name}, DunId, #gain{label = item, val = [BaseId, _Bind, Num]}}) ->
    DunName = case dungeon_data:get(DunId) of
            #dungeon_base{name = Dname} ->
                Dname;
            _ ->
                <<>>
        end,
    ItemName = log_conv:item(name, BaseId),
    ItemQua = log_conv:item(quality, BaseId),
    Now = util:unixtime(),
    log_host:log(log_dungeon_box, {Rid, SrvId, Name, DunId, DunName, BaseId, ItemName, ItemQua, Num, Now});
log(log_dungeon_box, {Role, DunId, [I | T]}) ->
    log(log_dungeon_box, {Role, DunId, I}),
    log(log_dungeon_box, {Role, DunId, T});
log(log_dungeon_box, {_Role, _DunId, _}) ->
    ok;
log(log_dungeon_box, _) -> ignore;


%% 角色物品消耗 %% TODO: 
%% DelType = <<"删除">> | <<"使用">> | <<"转移到帮会仓库">> | <<"合成">> ...
%% Pos = <<"仓库">> | <<"背包">> | <<"寻宝仓库">> ...
%% --------------------------------
%% 通过role_gain:do产生的物品消耗
%% DelType = bitstring() 20个字符
log(log_item_del_loss, {DelType, #role{id = {Rid, Rsrvid}, name = Rname}}) ->
    case get(item_del) of
        undefined -> ignore;
        L when is_list(L) ->
            put(item_del, undefined),
            log_item_del_loss(L, DelType, Rid, Rsrvid, Rname);
        _E ->
            put(item_del, undefined),
            ?ERR("物品删除日志数据错误:~w", [_E]),
            ignore
    end;
%% 直接物品消耗
%% Items = [I | ...]
%% I = #item{} | {BaseId, Bind}
log(log_item_del, {Items, DelType, PosStr, #role{id = {Rid, Rsrvid}, name = Rname}}) ->
    log(log_item_del, {Items, DelType, PosStr, Rid, Rsrvid, Rname});
log(log_item_del, {Items, DelType, PosStr, Rid, Rsrvid, Rname}) ->
    Now = util:unixtime(),
    DataList = log_item_del(Items, DelType, PosStr, Rid, Rsrvid, Rname, Now, []),
    log_host:log(log_item_del, DataList);

%% 仓库操作日志
%% HandleStr = bitstring() 30个字节
log(log_storage_handle, {_HandleStr, [], _Role}) -> ignore;
log(log_storage_handle, {HandleStr, [Item | T], Role}) ->
    log(log_storage_handle, {HandleStr, Item, Role}),
    log(log_storage_handle, {HandleStr, T, Role});
log(log_storage_handle, {HandleStr, Item, #role{id = {Id, SrvId}, name = Name}}) ->
    BaseId = log_conv:item(base_id, Item),
    ItemName = log_conv:item(name, BaseId),
    log_host:log(log_storage_handle, {Id, SrvId, Name, HandleStr, BaseId, ItemName, util:term_to_bitstring(Item), util:unixtime()});

%% 角色金币操作
%% HandleType = bitstring() 30个字节内
%% Remark = bitstring()
log(log_coin, {HandleType, Remark, #role{id = {Id, SrvId}, name = Name, assets = #assets{coin = Coin, coin_bind = CoinBind}},
        #role{assets = #assets{coin = NewCoin, coin_bind = NewCoinBind}}}) ->
    DetCoin = NewCoin - Coin,
    DetCoinBind = NewCoinBind - CoinBind,
    case (abs(DetCoin) + abs(DetCoinBind)) < 1000 of
        true -> ignore;
        false ->
            Now = util:unixtime(),
            log_host:log(log_coin, {Id, SrvId, Name, HandleType, CoinBind, Coin, DetCoinBind, DetCoin, Remark, Now})
    end;

%% 角色符石操作
%% HandleType = bitstring() 30个字节内
%% Remark = bitstring()
log(log_stone, {HandleType, Remark, #role{id = {Id, SrvId}, name = Name, assets = #assets{stone = Stone}},
        #role{assets = #assets{stone = NewStone}}}) ->
    DetStone = NewStone - Stone,
    log_host:log(log_stone, {Id, SrvId, Name, HandleType, Stone, DetStone, Remark, util:unixtime()});


%% 角色晶钻操作
%% HandleType = bitstring() 30个字节内
%% Remark = bitstring()
%% StatKey = bitstring() 统计字段，30个字节内
log(log_gold, {HandleType, Remark, StatKey, #role{id = {Id, SrvId}, name = Name, lev = Lev, assets = #assets{gold = Gold}},
        #role{assets = #assets{gold = NewGold}}}) ->
    DetGold = NewGold - Gold,
    case abs(DetGold) > 0 of
        false -> ignore;
        true ->
            Now = util:unixtime(),
            log_host:log(log_gold, {Id, SrvId, Name, Lev, HandleType, Gold, DetGold, Remark, StatKey, Now})
    end;
log(log_gold, {HandleType, Remark, StatKey, #role{id = {Id, SrvId}, name = Name, lev = Lev}, {Gold, DetGold}}) ->
    Now = util:unixtime(),
    log_host:log(log_gold, {Id, SrvId, Name, Lev, HandleType, Gold, DetGold, Remark, StatKey, Now});
%% 
log(log_gold, {HandleType, Remark, #role{id = {Id, SrvId}, name = Name, lev = Lev, assets = #assets{gold = Gold}},
        #role{assets = #assets{gold = NewGold}}}) ->
    DetGold = NewGold - Gold,
    case abs(DetGold) > 0 of
        false -> ignore;
        true ->
            Now = util:unixtime(),
            log_host:log(log_gold, {Id, SrvId, Name, Lev, HandleType, Gold, DetGold, Remark, HandleType, Now})
    end;
log(log_gold, {HandleType, Remark, #role{id = {Id, SrvId}, name = Name, lev = Lev}, {Gold, DetGold}}) ->
    Now = util:unixtime(),
    log_host:log(log_gold, {Id, SrvId, Name, Lev, HandleType, Gold, DetGold, Remark, HandleType, Now});

%% 市场拍卖交易日志
log(log_market, {HandleType,
        #market_sale2{sale_id = SaleId, srv_id = SaleSrvid, saler_name = SaleName, saler_lev = SaleLev
            , item_base_id = ItemId, item_name = ItemName, quantity = Num, price = Price
            , begin_time = BeginTime, end_time = EndTime
        },
        #role{id = {BuyId, BuySrvid}, name = BuyName, lev = BuyLev}}) ->
    T = (EndTime - BeginTime) div 3600,
    log_host:log(log_market, {SaleId, SaleSrvid, SaleName, SaleLev, BuyId, BuySrvid, BuyName, BuyLev,
            HandleType, ItemId, ItemName, Num, Price, log_conv:market(assets_type, 0), (Price div Num),
            0, T, util:unixtime()});
log(log_market, {HandleType,
        #market_sale2{sale_id = SaleId, srv_id = SaleSrvid, saler_name = SaleName, saler_lev = SaleLev
            ,item_base_id = ItemId, item_name = ItemName, quantity = Num, price = Price
            , begin_time = BeginTime, end_time = EndTime
        }, _}) ->
    T = (EndTime - BeginTime) div 3600,
    log_host:log(log_market, {SaleId, SaleSrvid, SaleName, SaleLev, 0, <<"">>, <<"">>, 0,
            HandleType, ItemId, ItemName, Num, Price, log_conv:market(assets_type, 0), (Price div Num),
            0, T, util:unixtime()});
%% 拍卖
log(log_market, {Now, HandleType, Hour,
        #market_sale2{sale_id = SaleId, srv_id = SaleSrvid, saler_name = SaleName, saler_lev = SaleLev
            ,item_base_id = ItemId, item_name = ItemName, quantity = Num, price = Price
        }, _}) ->
    log_host:log(log_market, {SaleId, SaleSrvid, SaleName, SaleLev, 0, <<"">>, <<"">>, 0,
            HandleType, ItemId, ItemName, Num, Price, log_conv:market(assets_type, 0), (Price div Num),
            market:add_price_tax(Price) - Price, Hour, Now});

%% 幸运抽奖
log(log_lottery, {free, AwardId, AwardName, AwardNum, #role{id = {Rid, SrvId}, name = Name}}) ->
    Now = util:unixtime(),
    log_host:log(log_lottery, {Rid, SrvId, Name, 0, AwardId, AwardName, AwardNum, Now});
log(log_lottery, {pay, AwardId, AwardName, AwardNum, #role{id = {Rid, SrvId}, name = Name}}) ->
    Now = util:unixtime(),
    log_host:log(log_lottery, {Rid, SrvId, Name, 1, AwardId, AwardName, AwardNum, Now});

%% 角色升级
log(log_role_up_lev, #role{id = {Rid, SrvId}, account = Acc, name = Name, lev = Lev, assets = #assets{exp = Exp}})
when Lev >= 20 ->
    Now = util:unixtime(),
    log_host:log(log_role_up_lev, {Rid, SrvId, Acc, Name, Lev, Exp, Now});
log(log_role_up_lev, _) -> ignore;

%% 宠物变化
log(log_pet_update, {#role{id = {Rid, SrvId}, name = RName}, OldPets, NewPet = #pet{id = PetId, name = PName, mod = Status,  lev = PLev, exp = PExp}, Msg}) when is_list(OldPets) ->
    Now = util:unixtime(),
    log_host:log(log_pet_update, {Rid, SrvId, RName, PetId, PName, Status, PLev, PExp, Msg, util:term_to_bitstring(NewPet), util:term_to_bitstring(OldPets), pet_to_msg(OldPets, <<>>), pet_to_msg(NewPet), Now});
log(log_pet_update, {#role{id = {Rid, SrvId}, name = RName}, OldPet, NewPet = #pet{id = PetId, name = PName, mod = Status,  lev = PLev, exp = PExp}, Msg}) ->
    Now = util:unixtime(),
    log_host:log(log_pet_update, {Rid, SrvId, RName, PetId, PName, Status, PLev, PExp, Msg, util:term_to_bitstring(NewPet), util:term_to_bitstring(OldPet), pet_to_msg(OldPet), pet_to_msg(NewPet), Now});
log(log_pet_update, {#role{id = {Rid, SrvId}, name = RName}, NewPet = #pet{id = PetId, name = PName, mod = Status,  lev = PLev, exp = PExp}, Msg}) ->
    Now = util:unixtime(),
    log_host:log(log_pet_update, {Rid, SrvId, RName, PetId, PName, Status, PLev, PExp, Msg, util:term_to_bitstring(NewPet), util:term_to_bitstring(NewPet), pet_to_msg(NewPet), pet_to_msg(NewPet), Now});

%% 角色积分类相关日志
%% HandleType = bitstring() 30字节内
%% Type = atom() | integer() 指定记录类型 career_devote | arena_score | ...
log(log_integral, {Type, HandleType, BuyList, Role = #role{id = {Rid, SrvId}, name = Name}, NewRole}) ->
    ScoreType = log_conv:score(type, Type),
    ScoreName = log_conv:score(name, Type),
    case calc_integral_use(ScoreType, Role, NewRole) of
        {_, 0} -> ok;
        {BeforeVal, Val} ->
            Remark = integral_items_remark(BuyList),
            log_host:log(log_integral, {Rid, SrvId, Name, HandleType, ScoreName, BeforeVal, Val, Remark, util:unixtime()})
    end;

%%兼容商城日志
log(log_bind_gold, {HandleType, Remark, _StatKey, Role, Role2}) ->
    log(log_bind_gold, {HandleType, Remark, Role, Role2});
%% 绑定晶钻日志
log(log_bind_gold, {HandleType, Remark, #role{id = {Id, SrvId}, name = Name, assets = #assets{gold_bind = GoldBind}}, #role{assets = #assets{gold_bind = NewGoldBind}}}) ->
    DetGoldBind = NewGoldBind - GoldBind,
    case abs(DetGoldBind) > 0 of
        false -> ignore;
        true ->
            Now = util:unixtime(),
            log_host:log(log_bind_gold, {Id, SrvId, Name, HandleType, GoldBind, DetGoldBind, Remark, Now})
    end;

%% 锻造操作日志
%% enchant = atom() | bitstring()
%% HandleRemark = bitstring() | {bitstring(), [EqmItem, Str, Num]}
%% UseItems = list()
%% Result = bitstring()
log(log_blacksmith, {Type, {Str, Args}, Result, UseItems, #role{id = {Id, SrvId}, name = Name, account = Acc}, _NewRole}) ->
    Now = util:unixtime(),
    HandleRemark = blacksmith_handle_parse(Str, Args),
    StrItems = util:term_to_bitstring(UseItems),
    log_host:log(log_blacksmith, {Id, SrvId, Acc, Name, Type, HandleRemark, Result, 0, 0, StrItems, Now});
 log(log_blacksmith, {Type, HandleRemark, Result, UseItems, #role{id = {Id, SrvId}, name = Name, account = Acc}, _NewRole}) ->
    Now = util:unixtime(),
    StrItems = util:term_to_bitstring(UseItems),
    log_host:log(log_blacksmith, {Id, SrvId, Acc, Name, Type, HandleRemark, Result, 0, 0, StrItems, Now});

%% 元神日志
%% Handle = up | up_cancel | up_over | speed_up
%% Channel = #channel{}
log(log_channel, {Handle, Channel, #role{id = {Id, SrvId}, name = Name, account = Acc}}) ->
    Now = util:unixtime(),
    Cname = log_conv:channel(name, Channel),
    Ctext = log_conv:channel(Handle, {Now, Channel}),
    log_host:log(log_channel, {Id, Name, SrvId, Acc, Cname, Ctext, Now});
%% Handle = upgrade_suc | upgrade_fail | upgrade_drop
log(log_channel_state, {Handle, IsProtect, Channel, NewChannel, #role{id = {Id, SrvId}, name = Name, account = Acc}}) ->
    Now = util:unixtime(),
    Cname = log_conv:channel(name, Channel),
    {State, NewState, Result} = log_conv:channel(handle, {Handle, Channel, NewChannel}),
    log_host:log(log_channel_state, {Id, SrvId, Name, Acc, Cname, State, NewState, IsProtect, Result, Now});

%% 精力值日志
log(log_activity, {OldSummary, NowSummary, Dot, Desc, #role{id = {Id, SrvId}, lev = Lev, name = Name, account = Acc, activity = #activity{sum_limit = SumLimit}}}) ->
    Now = util:unixtime(),
    log_host:log(log_activity, {Id, SrvId, Name, Acc, Lev, NowSummary, OldSummary, Desc, Dot, SumLimit, Now});

%% 礼包奖励领取日志
%% Gift = bitstring() | integer() 礼包名称或者ID
%% Activity = bitstring() 活动名称
%% Remark = bitstring() 备注
%% log(log_gift_award, {Gift, Num, Activity, Remark, #role{id = {Id, SrvId}, name = Name}}) when is_integer(Gift) ->
%%     Now = util:unixtime(),
%%     GiftName = award:type2log_str(Gift),
%%     log_host:log(log_gift_award, {Id, SrvId, Name, GiftName, Num, Activity, Remark, Now});
%% log(log_gift_award, {Gift, Num, Activity, Remark, #role{id = {Id, SrvId}, name = Name}}) ->
%%     Now = util:unixtime(),
%%     log_host:log(log_gift_award, {Id, SrvId, Name, Gift, Num, Activity, Remark, Now});

%% 礼包/礼盒 开启日志
log(log_gift_open, {Gift, ItemsInfo, #role{id = {Id, SrvId}, name = Name}}) ->
    Now = util:unixtime(),
    GiftName = log_conv:item(name, Gift),
    log_host:log(log_gift_open, {Id, SrvId, Name, GiftName, ItemsInfo, Now});

%% 亲密度日志
log(log_intimacy, {Rid, RsrvId, Rname, FrId, FrSrvId, FrName, IntiBefore, Inti, Remark}) ->
    Now = util:unixtime(),
    log_host:log(log_intimacy, {Rid, RsrvId, Rname, FrId, FrSrvId, FrName, IntiBefore, Inti, Remark, Now});

%% 坐骑喂养日志
log(log_mount_feed, {Rid, Rsrvid, Rname, Items, AddExp, Mount, OldLev, NewLev, OldExp, NewExp, OldFeed, NewFeed}) ->
    Now = util:unixtime(),
    log_host:log(log_mount_feed, {Rid, Rsrvid, Rname, Items, AddExp, Mount, OldLev, NewLev, OldExp, NewExp, OldFeed, NewFeed, Now});

%% 金银商店价格变化日志
log(log_npc_store_live, {Coin, Gold, Num, Price1, Price2, CoinGoldPer, NumPer}) ->
    Now = util:unixtime(),
    log_host:log(log_npc_store_live, {Coin, Gold, Num, Price1, Price2, CoinGoldPer, NumPer, Now});

%% 宠物删除日志
log(Label = log_pet_del, {Msg, #role{id = {Rid, SrvId}, name = RName}, Pet = #pet{id = PetId, name = PName, lev = PLev, grow_val = Grow, evolve = Evo, attr = #pet_attr{avg_val = AvgP}}}) ->
    Now = util:unixtime(),
    PetMsg = pet_to_msg(Pet),
    log_host:log(Label, {Rid, SrvId, RName, Msg, PetId, PName, PLev, Grow, AvgP, Evo, PetMsg, util:term_to_bitstring(Pet), Now});

%% 阅历日志
log(log_attainment, {Handle, Remark, #role{id = {Rid, SrvId}, name = Name, assets = #assets{attainment = Att}}, #role{assets = #assets{attainment = NewAtt}}})
when Att =/= NewAtt ->
    Now = util:unixtime(),
    log_host:log(log_attainment, {Rid, SrvId, Name, Handle, Att, NewAtt - Att, Remark, Now});
log(log_attainment, {Handle, Remark, Att, Val, #role{id = {Rid, SrvId}, name = Name}}) ->
    Now = util:unixtime(),
    log_host:log(log_attainment, {Rid, SrvId, Name, Handle, Att, Val, Remark, Now});
log(log_attainment, _) -> ignore;

%% 阅历日志
log(log_xd_lilian, {Handle, Remark, #role{id = {Rid, SrvId}, name = Name, assets = #assets{lilian = LL}}, #role{assets = #assets{lilian = NewLL}}})
when LL =/= NewLL ->
    Now = util:unixtime(),
    log_host:log(log_xd_lilian, {Rid, SrvId, Name, Handle, LL, NewLL - LL, Remark, Now});
log(log_xd_lilian, {Handle, Remark, LL, Val, #role{id = {Rid, SrvId}, name = Name}}) ->
    Now = util:unixtime(),
    log_host:log(log_xd_lilian, {Rid, SrvId, Name, Handle, LL, Val, Remark, Now});
log(log_xd_lilian, _) -> ignore;

%% 坐骑日志
log(log_mount_handle, {Handle, Items, OldMount = #item{base_id = BaseId}, NewMount, #role{id = {Id, SrvId}, name = Name}}) ->
    Now = util:unixtime(),
    ItemsInfo = items_to_info1(Items),
    log_host:log(log_mount_handle, {Id, SrvId, Name, log_conv:item(name, BaseId), Handle, ItemsInfo, mount_to_info(OldMount), mount_to_info(NewMount), Now});

%% 各类描述类操作日志
log(log_handle_all, {Proto, Title, Msg, Role}) ->
    log(log_handle_all, {Proto, Title, Msg, [], Role});
log(log_handle_all, {Proto, Title, Msg, RecordList, #role{id = {Id, SrvId}, name = Name}}) ->
    Now = util:unixtime(),
    log_host:log(log_handle_all, {Id, SrvId, Name, Title, Proto, Msg, util:term_to_bitstring(RecordList), Now});

%% 精灵守护操作日志
%% HandleType = Handle = bitstring()
log(log_demon_update, {HandleType, Handle, RD, _NewRD, #role{id = {Id, SrvId}, name = Name}}) ->
    Now = util:unixtime(),
    %% TODO: util:term_to_bitstring(NewRD)信息暂时不记录
    log_host:log(log_demon_update, {Id, SrvId, Name, HandleType, Handle, util:term_to_bitstring(RD), <<>>, Now});

%% 悬赏任务操作日志
%% Type = integer()
log(log_task_wanted, {Type, Activity, Accepted, #role{id = {Id, SrvId}, name = Name}}) ->
    Now = util:unixtime(),
    %% TODO: util:term_to_bitstring(NewRD)信息暂时不记录
    TaskType = case Type of
        1 -> <<"经验">>;
        2 -> <<"宝图">>;
        _ -> <<"精英怪">>
    end,
    log_host:log(log_task_wanted, {Id, SrvId, Name, TaskType, Activity, Accepted, Now});

%% 灵戒洞天操作日志
log(log_soul_world, {Type, Items, BeforeVal, AfterVal, #role{id = {Id, SrvId}, name = Name}}) ->
    Now = util:unixtime(),
    HandleType= case Type of
        feed -> <<"喂养妖灵">>;
        upgrade_magic -> <<"法宝进阶">>;
        upgrade_array -> <<"升级神魔阵">>;
        _ -> util:fbin("~w", [Type])
    end,
    log_host:log(log_soul_world, {Id, SrvId, Name, Items, HandleType, BeforeVal, AfterVal, Now});

%% 物品产出记录日志
%% ItemList = [{Id, Num} | ...] | [#item{} | ...]
log(log_item_output, {ItemList, GetType}) ->
    Now = util:unixtime(),
    case item_output_parse(Now, GetType, ItemList, []) of
        [] -> ignore;
        DataList ->
            log_host:log(log_item_output, DataList)
    end;

%% 仙道会段位积分日志
log(log_world_compete_section, {{Rid, SrvId}, Name, SectionMark, SectionLev, OldSectionMark, OldSectionLev}) ->
    Now = util:unixtime(),
    Remark = case SectionLev =:= OldSectionLev of
        true ->
            case OldSectionMark =< 0 of
                true -> <<"（第一次参加段位赛或赛季末重置过）">>;
                false -> <<"">>
            end;
        false ->
            case OldSectionMark =< 0 of
                true -> util:fbin(<<"（第一次参加段位赛或赛季末重置过）段位等级改变:~w => ~w">>, [OldSectionLev, SectionLev]);
                false -> util:fbin(<<"段位等级改变:~w => ~w">>, [OldSectionLev, SectionLev])
            end
    end,
    log_host:log(log_world_compete_section, {Rid, SrvId, Name, OldSectionMark, SectionMark, Remark, Now});

%% 角色活动商城操作
log(log_shop_activity, {ItemsInfo, #role{id = {Id, SrvId}, name = Name, lev = Lev, assets = #assets{gold = Gold}},
        #role{assets = #assets{gold = NewGold}}}) ->
    DetGold = NewGold - Gold,
    case abs(DetGold) > 0 of
        false -> ignore;
        true ->
            Now = util:unixtime(),
            save_shop_activity_data(ItemsInfo, {Id, SrvId, Name, Lev, Gold, DetGold, Now})
    end;

%% 魂气日志
log(log_soul, {HandleType, Remark, #role{id = {Id, SrvId}, name = Name, assets = #assets{soul = Soul}}, #role{assets = #assets{soul = NewSoul}}}) ->
    Diff = abs(NewSoul - Soul),
    case Diff > 0 of
        true -> log_host:log(log_soul, {Id, SrvId, Name, HandleType, Soul, Diff, NewSoul, Remark, util:unixtime()});
        false -> ok
    end;

%% 淘宝日志
%% Items 表示物品列表
log(log_taobao, {Remark, Items, Type, ItemNum, Bombs, #role{id = {Id, SrvId}, name = Name}}) -> 
    log_host:log(log_taobao, {Id, SrvId, Name, Remark, Items, Type, ItemNum, Bombs, util:unixtime()});

%% 妖精吞噬日志
%% Demons 表示被吞噬列表
log(log_demon2, {Remark, Demons, AddGrow, AddExp, #role{id = {Id, SrvId}, name = Name}}) -> 
    log_host:log(log_demon2, {Id, SrvId, Name, Remark, Demons, AddGrow, AddExp, util:unixtime()});

%% 军团许愿 军团商城购买日志
%% Type = <<"许愿">> or <<"购买">>
%% BaseId = 物品基础Id
%% Devote = 消耗的军团贡献
log(log_guild_wishshop, {Type, BaseId, Num, Devote, #role{id = {Id, SrvId}, name = Name}}) ->
    ItemName = log_conv:item(name, BaseId),
    log_host:log(log_guild_wishshop, {Type, BaseId, ItemName, Num, Devote, Id, SrvId, Name, util:unixtime()});
log(log_guild_wishshop, _) -> ignore;


%% 宠伙伴龙族遗迹日志
log(log_pet_dragon, {Remark, Items, #role{id = {Id, SrvId}, name = Name, assets = #assets{gold = Gold}}, #role{assets = #assets{gold = NewGold}}}) ->
    DetGold = NewGold - Gold,
    case abs(DetGold) > 0 of
        false -> ignore;
        true ->
            log_host:log(log_pet_dragon, {Id, SrvId, Name, Remark, Items, abs(DetGold), util:unixtime()})
    end;

%% 宠伙伴龙族遗迹日志
log(log_super_boss, {Remark, Id, SrvId, Name, BossId}) ->
    log_host:log(log_super_boss, {Id, SrvId, Name, Remark, BossId, util:unixtime()});

%% 玩法活跃度日志
log(log_activity_activeness, {Remark, Type, #role{id = {Id, SrvId}, name = Name}}) ->
    log_host:log(log_activity_activeness, {Id, SrvId, Name, Remark, Type, util:unixtime()});

%% 伙伴日志：潜能提升，天赋，技能升级，学习，遗忘
log(log_pet2, {Remark, Result, #role{id = {Id, SrvId}, name = Name, pet = #pet_bag{active = Pet}}}) ->
    log_host:log(log_pet2, {Id, SrvId, Name, Remark, Result, util:unixtime(), util:term_to_bitstring(Pet)});

%% 勋章日志：获得勋章， 勋章条件领取
log(log_medal, {Remark, Result, #role{id = {Id, SrvId}, name = Name}}) ->
    log_host:log(log_medal, {Id, SrvId, Name, Remark, Result, util:unixtime()});

%% 副本掉落日志
log(log_dungeon_drop, {Remark, DungeonId, Result, #role{id = {Id, SrvId}, name = Name}}) ->
    log_host:log(log_dungeon_drop, {Id, SrvId, DungeonId, Name, Remark, util:unixtime(), Result});
    
%% 容错
log(_Type, _Data) ->
    ?ELOG("日志记录忽略[Type:~w, Data:~w]", [_Type, _Data]),
    ignore.

%% @spec log_rollback(Type, Data) -> any()
%% @doc 回滚日志
%% <div> 目前仅支持1层嵌套调用的回滚，暂时不能保证精确性 </div>
log_rollback(Type) ->
    LogType = to_type(Type),
    case get(LogType) of
        undefined -> ignore;
        Data ->
            ets:delete_object(LogType, Data)
    end.

%% --------------------------------
%% 内部处理
%% --------------------------------
%% 操作分类转换为日志分类
to_type(log_item_del_loss) -> log_item_del;
to_type(Type) -> Type.

%% 物品role_gain事务方式删除记录提取
log_item_del_loss([], _DelType, _Rid, _Rsrvid, _Rname) -> ignore;
log_item_del_loss([{?storage_task, _Items} | _], _DelType, _Rid, _Rsrvid, _Rname) -> ignore; %% 任务背包忽略
log_item_del_loss([{Pos, Items} | T], DelType, Rid, Rsrvid, Rname) ->
    PosStr = log_conv:item(storage, Pos),
    log(log_item_del, {Items, DelType, PosStr, Rid, Rsrvid, Rname}),
    log_item_del_loss(T, DelType, Rid, Rsrvid, Rname);
log_item_del_loss(_, _, _, _, _) -> ignore.

%% 物品消耗分开处理
log_item_del([], _DelType, _Pos, _Rid, _Rsrvid, _Rname, _Now, DataList) -> DataList;
log_item_del([{BaseId, Bind} | T], DelType, Pos, Rid, Rsrvid, Rname, Now, DataList) ->
    ItemName = log_conv:item(name, BaseId),
    NewDataList = [{Rid, Rsrvid, Rname, BaseId, ItemName, Bind, DelType, Pos, <<>>, Now} | DataList],
    log_item_del(T, DelType, Pos, Rid, Rsrvid, Rname, Now, NewDataList);
log_item_del([Item | T], DelType, Pos, Rid, Rsrvid, Rname, Now, DataList) ->
    BaseId = log_conv:item(base_id, Item),
    ItemName = log_conv:item(name, BaseId),
    Bind = log_conv:item(bind, Item),
    Bin = util:term_to_bitstring(Item),
    NewDataList = [{Rid, Rsrvid, Rname, BaseId, ItemName, Bind, DelType, Pos, Bin, Now} | DataList],
    log_item_del(T, DelType, Pos, Rid, Rsrvid, Rname, Now, NewDataList).

%% 掉落数据处理
log_item_drop([], _Rid, _Rsrvid, _Rname, _Now, DataList) -> DataList;
log_item_drop([{NpcId, ItemId} | T], Rid, Rsrvid, Rname, Now, DataList) ->
    NpcType = log_conv:npc(type, NpcId),
    NpcName = log_conv:npc(name, NpcId),
    ItemType = log_conv:item(type, ItemId),
    ItemName = log_conv:item(name, ItemId),
    ItemQua = log_conv:item(quality, ItemId),
    NewDataList = [{NpcId, NpcName, NpcType, ItemId, ItemName, ItemQua, ItemType, Rid, Rsrvid, Rname, Now} | DataList],
    log_item_drop(T, Rid, Rsrvid, Rname, Now, NewDataList);
log_item_drop(_, _, _, _, _, D) -> D.

%% 积分兑换计算处理
calc_integral_use(career_devote, #role{assets = #assets{career_devote = CareerDevote}}, #role{assets = #assets{career_devote = NewCareerDevote}}) ->
    {CareerDevote, NewCareerDevote - CareerDevote};
calc_integral_use(arena_score, #role{assets = #assets{arena = Arena}}, #role{assets = #assets{arena = NewArena}}) ->
    {Arena, NewArena - Arena};
calc_integral_use(guild_war, #role{assets = #assets{guild_war = GuildWar}}, #role{assets = #assets{guild_war = NewGuildWar}}) ->
    {GuildWar, NewGuildWar - GuildWar};
calc_integral_use(guild_devote, #role{guild = #role_guild{devote = D}}, #role{guild = #role_guild{devote = NewD}}) ->
    {D, NewD - D};
calc_integral_use(lilian, #role{assets = #assets{lilian = OldVal}}, #role{assets = #assets{lilian = NewVal}}) ->
    {OldVal, NewVal - OldVal};
calc_integral_use(_, _, _) -> {0, 0}.

%% 兑换物品转换信息
integral_items_remark(List) -> 
    integral_items_remark(List, <<"">>).
integral_items_remark([], Str) -> Str;
integral_items_remark([[BaseId, Num] | T], Str) ->
    NewStr = util:fbin(<<"~s~sx~w;">>, [Str, log_conv:item(name, BaseId), Num]),
    integral_items_remark(T, NewStr);
integral_items_remark([{BaseId, Num} | T], Str) ->
    NewStr = util:fbin(<<"~s;~sx~w">>, [Str, log_conv:item(name, BaseId), Num]),
    integral_items_remark(T, NewStr);
integral_items_remark([_ | T], Str) ->
    integral_items_remark(T, Str).

%% 锻造模块操作内容解析
blacksmith_handle_parse(Str, Args) ->
    NewArgs = do_args_parse(Args),
    util:fbin(Str, NewArgs).
do_args_parse(Args) when is_list(Args) -> 
    lists:reverse(do_args_parse(Args, []));
do_args_parse(_) -> [].
do_args_parse([], Args) -> Args;
do_args_parse([Cargs = [_ | _] | T], Args) ->
    Str = do_args_row_parse(Cargs),
    do_args_parse(T, [Str | Args]);
do_args_parse([#item{base_id = BaseId} | T], Args) ->
    ItemName = log_conv:item(name, BaseId),
    do_args_parse(T, [ItemName | Args]);
do_args_parse([H | T], Args) when is_integer(H) ->
    do_args_parse(T, [H | Args]).
%% 多组物品名字信息组合
do_args_row_parse(Items) ->
    do_args_row_parse(Items, <<>>).
do_args_row_parse([], Str) -> Str;
do_args_row_parse([#item{base_id = BaseId, quantity = Num} | T], Str) ->
    ItemName = log_conv:item(name, BaseId),
    NewStr = util:fbin(<<"~s~sx~w">>, [Str, ItemName, Num]),
    do_args_row_parse(T, NewStr);
do_args_row_parse([_ | T], Str) ->
    do_args_row_parse(T, Str).

%% 物品转换
items_to_info1(Items) ->
    items_to_info1(Items, <<>>).
items_to_info1([], Str) -> Str;
items_to_info1([#item{base_id = BaseId, quantity = Num} | T], Str) ->
    ItemName = log_conv:item(name, BaseId),
    NewStr = util:fbin(<<"~s~sx~w">>, [Str, ItemName, Num]),
    items_to_info1(T, NewStr);
items_to_info1([_ | T], Str) ->
    items_to_info1(T, Str).

%%-----------------------------------------------
%% 宠物数据转换成描述信息
%%-----------------------------------------------

pet_to_msg([], Str) -> Str;
pet_to_msg([Pet | Pets], Str) ->
    PetStr = pet_to_msg(Pet),
    pet_to_msg(Pets, <<Str/binary, <<"\n">>/binary, PetStr/binary>>).

pet_to_msg(#pet{name = Name, base_id = BaseId, lev = Lev, grow_val = Grow, exp = Exp, skill_num = SkillNum, wish_val = Wish, evolve = Evo, attr_sys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}, attr = #pet_attr{xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal, xl_max = XlMax, tz_max = TzMax, js_max = JsMax, lq_max = LqMax}, skill = Skills, append_attr = AppendAttr, ext_attr = ExtAttrL, ext_attr_limit = ExtAttrLimit}) ->
    SkillMsg = pet_skill_to_msg(Skills, <<>>),
    ChangeType = case AppendAttr of
        [{CType, _} | _] -> CType;
        _ -> 0
    end,
    util:fbin("[名称:~s][形象:~p][等级:~p][经验:~p][成长:~p][祝福值:~p][技能格子数:~p][进化:~p][变身类型:~p][洗髓比例:~p,~p,~p,~p][潜力:~p,~p,~p,~p][潜力上限:~p,~p,~p,~p][技能:~s][附加属性:~w][丹药使用:~w]", [Name, BaseId, Lev, Exp, Grow, Wish, SkillNum, Evo, ChangeType, XlPer, TzPer, JsPer, LqPer, XlVal, TzVal, JsVal, LqVal, XlMax, TzMax, JsMax, LqMax, SkillMsg, ExtAttrL, ExtAttrLimit]).

pet_skill_to_msg([], Str) -> Str;
pet_skill_to_msg([{SkillId, Exp,_,_} | T], Str) ->
    SkillName = case pet_data_skill:get(SkillId) of
        {ok, #pet_skill{name = Name, step = Step, lev = Lev}} -> util:fbin("~s:阶数:~p,等级:~p", [Name, Step, Lev]);
        _ -> <<"未知技能">>
    end,
    NewStr = util:fbin("(~p:~s,经验:~p)", [SkillId, SkillName, Exp]),
    pet_skill_to_msg(T, <<Str/binary, NewStr/binary>>).

%% 坐骑信息转换
mount_to_info(#item{base_id = BaseId, extra = Extra}) ->
    do_mount_to_info(Extra, util:fbin(<<"~s--">>, [log_conv:item(name, BaseId)])).
do_mount_to_info([], Info) -> Info;
do_mount_to_info([{Type, Val, _} | T], Info)
when Type =:= 3 orelse Type =:= 4 ->
    Info1 = util:fbin(<<"~s~s:~w">>, [Info, mount_extra_type_str(Type), Val]),
    do_mount_to_info(T, Info1);
do_mount_to_info([{Type, Val, _} | T], Info)
when (Type >= 18 andalso Type =< 20) ->
    Info1 = util:fbin(<<"~s~s:~w">>, [Info, mount_extra_type_str(Type), Val]),
    do_mount_to_info(T, Info1);
do_mount_to_info([_ | T], Info) ->
    do_mount_to_info(T, Info).
%% 信息类型
mount_extra_type_str(3) -> <<"等级">>;
mount_extra_type_str(4) -> <<"经验">>;
%% mount_extra_type_str(6) -> <<"攻击">>;
%% mount_extra_type_str(7) -> <<"防御">>;
%% mount_extra_type_str(8) -> <<"暴击">>;
%% mount_extra_type_str(9) -> <<"坚韧">>;
%% mount_extra_type_str(10) -> <<"生命">>;
%% mount_extra_type_str(11) -> <<"精神">>;
%% mount_extra_type_str(12) -> <<"攻击比">>;
%% mount_extra_type_str(13) -> <<"防御比">>;
%% mount_extra_type_str(14) -> <<"暴击比">>;
%% mount_extra_type_str(15) -> <<"坚韧比">>;
%% mount_extra_type_str(16) -> <<"生命比">>;
%% mount_extra_type_str(17) -> <<"精神比">>;
mount_extra_type_str(18) -> <<"幸运值">>;
mount_extra_type_str(19) -> <<"阶数">>;
mount_extra_type_str(20) -> <<"洗髓品质">>;
%% mount_extra_type_str(21) -> <<"灵犀值">>;
mount_extra_type_str(_) -> <<>>.

%% 产出物品记录
item_output_parse(_Now, _GetType, [], L) -> L;
item_output_parse(Now, GetType, [#gain{label = item, val = [Id, _Bind, Num]} | T], L) ->
    Data = {Id, log_conv:item(name, Id), Num, GetType, Now},
    item_output_parse(Now, GetType, T, [Data | L]);
item_output_parse(Now, GetType, [{Id, _Bind, Num} | T], L) ->
    Data = {Id, log_conv:item(name, Id), Num, GetType, Now},
    item_output_parse(Now, GetType, T, [Data | L]);
item_output_parse(Now, GetType, [{Id, Num} | T], L) ->
    Data = {Id, log_conv:item(name, Id), Num, GetType, Now},
    item_output_parse(Now, GetType, T, [Data | L]);
item_output_parse(Now, GetType, [#item{base_id = Id, quantity = Num} | T], L) ->
    Data = {Id, log_conv:item(name, Id), Num, GetType, Now},
    item_output_parse(Now, GetType, T, [Data | L]);
item_output_parse(Now, GetType, [_ | T], L) ->
    item_output_parse(Now, GetType, T, L).

%% 保存活动商城数据
save_shop_activity_data([], _) -> ok;
save_shop_activity_data([{BaseId, ItemName, ItemNum} | T], {Id, SrvId, Name, Lev, Gold, DetGold, Now}) ->
    log_host:log(log_shop_activity, {Id, SrvId, Name, Lev, ItemName, ItemNum, Gold, DetGold, Now, BaseId}),
    save_shop_activity_data(T, {Id, SrvId, Name, Lev, Gold, DetGold, Now}).
