%%----------------------------------------------------
%% 解析物品数据，转换旧版本数据
%% @author shawn 
%% @end
%%----------------------------------------------------
-module(item_parse).
-export([
        do/1
       ,do/2
       ,login/1
       ,parse_eqm/1
       ,parse_dress/1
       ,parse_bag/1
       ,parse_store/1
       ,parse_collect/1
       ,parse_taskbag/1
       ,parse_casino/1
       ,parse_guildbag/1
       ,parse_super_boss_store/1
       ,parse_pet_magic/1
    ]
).

-include("version.hrl").
-include("item.hrl").
-include("common.hrl").
-include("storage.hrl").
%%
-include("condition.hrl").
-include("role.hrl").

-define(MAX_ID, 300000000).
-define(EXPIRE_TIME, 24 * 3600 * 6).
-define(DATE, 1389412200).  %% 时间 2014/1/ 11/11/50/0

-define(FIX_ENCHANT, [
        ?item_chang_qiang, ?item_fei_jian, ?item_bi_shou, ?item_fa_zhang, ?item_shen_gong,
        ?item_hu_shou, ?item_hu_wan, ?item_yao_dai, ?item_xie_zi, ?item_ku_zi, ?item_yi_fu,
        ?item_hu_fu, ?item_jie_zhi
    ]
).

do(Data) when is_list(Data) ->
    do(Data, []);

% do({item, Ver = 8, Id, BaseId, Type, UseType, Bind, Source, Quality, Upgrade, Enchant, EnchantFail, Quantity, Status, Pos, LastTime, Durability, Attr, RequireLev, Career, Special, MaxBaseAttr, PolishList, Craft, Extra, Xisui, SecCareerAttr}) ->
%     NewAttr = parse_mount(Type, Enchant, Attr),
%     Item = {item, Ver + 1, Id, BaseId, Type, UseType, Bind, Source, Quality, Upgrade, Enchant, EnchantFail, Quantity, Status, Pos, LastTime, Durability, NewAttr, RequireLev, Career, Special, MaxBaseAttr, PolishList, Craft, Extra, Xisui, SecCareerAttr},
%     do(Item);

%% 检查最终的数据格式是否跟当前的版本号一致
% do(Item = {item, Ver, _Id, _BaseId, _Type, _UseType, _Bind, _Source, _Quality, _Upgrade, _Enchant, _EnchantFail, _Quantity, _wash_cnt, _Status, _Pos, _LastTime, _Durability, _Attr, _RequireLev, _Career, _Special, _MaxBaseAttr, _PolishList, _Polish, _Craft, _Extra, _XisuiList, _SecCareerAttr}) -> 
%     case Ver =:= ?ITEM_VER andalso is_record(Item, item) of
%         false -> {false, ?L(<<"物品数据转换时发生异常">>)};
%         true -> {ok, Item}
%     end.
do(Item) -> 
    case is_record(Item, item) of
        false -> {false, ?L(<<"物品数据转换时发生异常">>)};
        true -> {ok, Item}
    end.

%% 物品列表转换
do([], Data) ->
    case fix_field(Data, [wish]) of %% 去掉了 enchant_hole, wish, mount_feed， 暂时不需要修复
        {false, Reason} -> {false, Reason};
        {ok, NewData} -> {ok, NewData}
    end;
do([Item | T], Data) -> 
    case do(Item) of
        {false, Reason} -> 
            ?ELOG("物品转换失败:~w",[Item]),
            {false, Reason};
        {ok, NewItem} -> do(T, [NewItem | Data])
    end.

%% ----------------------------------------------------------------
%% 版本转换辅助函数
%% ----------------------------------------------------------------
%% 坐骑属性增加孔
% parse_mount(?item_zuo_qi, Enchant, Attr) ->
%     HoleAttr = [{?attr_hole1, 0, 0}, {?attr_hole2, 0, 0}, {?attr_hole3, 0, 0}],
%     EnchantAttr = if
%         Enchant >= 8 andalso Enchant < 10 ->
%             case lists:keyfind(?attr_hole4, 1, Attr) of
%                 false -> [{?attr_hole4, 101, 0} | Attr];
%                 _ -> Attr
%             end;
%         Enchant >= 10 andalso Enchant =< 12 ->
%             case lists:keyfind(?attr_hole5, 1, Attr) of
%                 false ->
%                     case lists:keyfind(?attr_hole4, 1, Attr) of
%                         false -> [{?attr_hole4, 101, 0}, {?attr_hole5, 101, 0} | Attr];
%                         _ -> [{?attr_hole5, 101, 0} | Attr]
%                     end;
%                 _ -> Attr
%             end;
%         true -> Attr
%     end,
%     NewAttr = case lists:keyfind(?attr_hole1, 1, Attr) of
%         false ->
%             HoleAttr ++ EnchantAttr;
%         _ -> EnchantAttr
%     end,
%     NewAttr;
% parse_mount(_, _, Attr) -> Attr.

fix_field(Data, []) -> {ok, Data};
fix_field(Data, [Field | T]) ->
    case fix_field(Data, Field) of
        {false, Reason} -> {false, Reason};
        {ok, NewData} ->
            fix_field(NewData, T)
    end;

%% 强化孔
fix_field(Data, enchant_hole) ->
    NewData = fix_enchant_hole(?FIX_ENCHANT, Data, []),
    {ok, NewData};

%% 强化祝福
fix_field(Data, wish) ->
    NewData = fix_wish_eqm(Data, []),
    {ok, NewData};

fix_field(Data, mount_feed) ->
    NewData = fix_mount_feed(Data, []),
    {ok, NewData};

fix_field(_, Field) ->
    {false, util:fbin(?L(<<"无法识别数据项:~w">>), [Field])}.

%% 修复无孔装备
fix_enchant_hole(_List, [], Items) -> Items;
fix_enchant_hole(List, [Item = #item{attr = Attr, type = Type, enchant = Enchant} | T], Items) when Type =:= ?item_shi_zhuang orelse Type =:= ?item_wing orelse Type =:= ?item_jewelry_dress orelse Type =:= ?item_weapon_dress ->
    HoleAttr = [{?attr_hole1, 0, 0}, {?attr_hole2, 0, 0}, {?attr_hole3, 0, 0}],
    EnchantAttr = if
        Enchant >= 8 andalso Enchant < 10 ->
            case lists:keyfind(?attr_hole4, 1, Attr) of
                false -> [{?attr_hole4, 101, 0} | Attr];
                _ -> Attr
            end;
        Enchant >= 10 andalso Enchant =< 12 ->
            case lists:keyfind(?attr_hole5, 1, Attr) of
                false ->
                    case lists:keyfind(?attr_hole4, 1, Attr) of
                        false -> [{?attr_hole4, 101, 0}, {?attr_hole5, 101, 0} | Attr];
                        _ -> [{?attr_hole5, 101, 0} | Attr]
                    end;
                _ -> Attr
            end;
        true -> Attr
    end,
    NewAttr = case lists:keyfind(?attr_hole1, 1, Attr) of
        false ->
            HoleAttr ++ EnchantAttr;
        _ -> EnchantAttr
    end,
    fix_enchant_hole(List, T, [Item#item{attr = NewAttr} | Items]);

fix_enchant_hole(List, [Item = #item{attr = Attr, type = Type, enchant = Enchant, quality = Quality} | T], Items) when Enchant >= 8 andalso Enchant < 10 andalso (Quality =:= ?quality_purple orelse Quality =:= ?quality_orange orelse Quality =:= ?quality_golden)->
    case lists:member(Type, List) of
        true ->
            NewItem = case lists:keyfind(?attr_hole4, 1, Attr) of
                false -> Item#item{attr = [{?attr_hole4, 101, 0} | Attr]};
                _ -> Item 
            end,
            fix_enchant_hole(List, T, [NewItem | Items]);
        false -> fix_enchant_hole(List, T, [Item | Items])
    end;

fix_enchant_hole(List, [Item = #item{attr = Attr, type = Type, enchant = Enchant, quality = Quality} | T], Items) when Enchant >= 10 andalso Enchant =< 12 andalso (Quality =:= ?quality_purple orelse Quality =:= ?quality_orange orelse Quality =:= ?quality_golden)->
    case lists:member(Type, List) of
        true ->
            NewItem = case lists:keyfind(?attr_hole5, 1, Attr) of
                false -> 
                    case lists:keyfind(?attr_hole4, 1, Attr) of
                        false -> Item#item{attr = [{?attr_hole4, 101, 0}, {?attr_hole5, 101, 0} | Attr]};
                        _ -> Item#item{attr = [{?attr_hole5, 101, 0} | Attr]}
                    end;
                _ -> Item 
            end,
            fix_enchant_hole(List, T, [NewItem | Items]);
        false -> fix_enchant_hole(List, T, [Item | Items])
    end;
fix_enchant_hole(List, [Item | T], Items) ->
    fix_enchant_hole(List, T, [Item | Items]).

%% 修复祝福装备
fix_wish_eqm([], Items) -> Items;
fix_wish_eqm([Item = #item{special = Special} | T], Items) -> 
    NewItem = case lists:keyfind(?special_eqm_wish, 1, Special) of
        false -> 
            Item;
        _ ->
            Special1 = lists:keydelete(?special_eqm_wish, 1, Special),
            Item#item{special = Special1}
    end,
    fix_wish_eqm(T, [NewItem | Items]).


fix_mount_feed([], Items) -> Items;
fix_mount_feed([Item | T], Items) ->
    fix_mount_feed(T, [mount:make(Item) | Items]).


%% --------------------------------
%% 存储转换
%% --------------------------------

%% 修复敏捷度
%% get_aspd(?quality_green) -> [{?attr_aspd, 100, 5}];
%% get_aspd(?quality_blue) -> [{?attr_aspd, 100, 10}];
%% get_aspd(?quality_purple) -> [{?attr_aspd, 100, 15}];
%% get_aspd(?quality_orange) -> [{?attr_aspd, 100, 20}];
%% get_aspd(_) -> [].

parse_eqm(EqmList) ->
    case do(EqmList) of
        {false, _} ->
            ?ELOG("装备列表转换失败:~w", [EqmList]),
            {false, ?L(<<"装备列表转换失败">>)};
        {ok, Data} ->
            {_, NewData} = del_expire([], Data),
            NewData
    end.

parse_dress(DressList) ->
    check_dress_expire(DressList, 1, []).

check_dress_expire([], _NewId, Res) -> Res;
check_dress_expire([{_Id, F, Item = #item{durability = Durability, special = Spec}} | T], NewId, Res) ->
     Now = util:unixtime(),
    case lists:keyfind(?special_expire_time, 1, Spec) of
        {?special_expire_time, Expire} ->
            case Expire =:= -1 orelse Expire =:= -2 of  %% 永久时装或体验时装
                true ->
                    check_dress_expire(T, NewId + 1, [{NewId, F, Item#item{id = NewId}} | Res]);
                false ->
                    case Now - Durability >= Expire of
                        true ->
                            case get(fetch_role_info) of
                                undefined ->
                                    ?ERR("删除物品时,无法获取角色信息,删除的物品是:~w",[Item]);
                                {{Rid, SrvId}, Name} ->
                                    log:log(log_item_del, {[Item], <<"过期删除">>, <<"">>, Rid, SrvId, Name})
                            end,
                            check_dress_expire(T, NewId, Res);
                        false ->
                            Expire1 = Expire - (Now - Durability),
                            New = {NewId, F, Item#item{id = NewId, special = lists:keyreplace(?special_expire_time, 1, Spec, {?special_expire_time, Expire1}), durability = Now}},
                            check_dress_expire(T, NewId + 1, [New | Res])
                    end
            end;
        false ->
            check_dress_expire(T, NewId + 1, [{NewId, F, Item#item{id = NewId}} | Res])
    end.

parse_bag({bag, BagNextId, BagVolume, BagFreePos, BagItems}) ->
    case do(BagItems) of
        {false, _} -> 
            ?ELOG("背包物品转换失败:~w", [BagItems]),
            {false, ?L(<<"背包物品转换失败">>)};
        {ok, Data1} ->
            {NewBagItems, NewNextId} = case BagNextId > ?MAX_ID of
                true -> reset_items(Data1);
                false ->
                    {Data1, BagNextId}
            end,
            {NewBagVolume, NewFreePos} = case BagVolume < ?bag_def_volume of
                true -> {?bag_def_volume, BagFreePos ++ ?FREEPOS(BagVolume + 1, ?bag_def_volume)};
                false -> {BagVolume, BagFreePos}
            end,
            {NewFreePos2, NewBagItems2} = del_expire(NewFreePos, NewBagItems),
            {bag, NewNextId, NewBagVolume, lists:sort(NewFreePos2), NewBagItems2}
    end.

parse_store({store, StoreNextId, StoreVolume, StoreFreePos, StoreItems}) ->
    case do(StoreItems) of
        {false, _} -> 
            ?ELOG("仓库物品转换失败:~w",[StoreItems]),
            {false, ?L(<<"仓库物品转换失败">>)};
        {ok, Data2} ->
            {NewStoreItems, NewNextId} = case StoreNextId > ?MAX_ID of
                true -> reset_items(Data2);
                false ->
                    {Data2, StoreNextId}
            end,
            {NewStoreFreePos, NewStoreItems2} = del_expire(StoreFreePos, NewStoreItems),
            {store, NewNextId, StoreVolume, lists:sort(NewStoreFreePos), NewStoreItems2}
    end.

parse_collect({collect, CollectVolume, CollectFreePos, CollectItems}) ->
    case do(CollectItems) of
        {false, _} -> 
            ?ELOG("采集背包物品转换失败:~w",[CollectItems]),
            {false, ?L(<<"采集背包转换失败">>)};
        {ok, Data3} -> {collect, CollectVolume, CollectFreePos, Data3}
    end.

parse_taskbag({task_bag, TaskNextId, TaskVolume, TaskFreePos, TaskItems}) ->
    case do(TaskItems) of
        {false, _} -> 
            ?ELOG("任务物品转换失败:~w",[TaskItems]),
            {false, ?L(<<"任务物品转换失败">>)};
        {ok, Data4} ->
            {NewTaskItems, NewNextId} = case TaskNextId > ?MAX_ID of
                true -> reset_items(Data4);
                false -> {Data4, TaskNextId}
            end,
            {task_bag, NewNextId, TaskVolume, TaskFreePos, NewTaskItems}
    end.

parse_casino({casino, NextId, Volume, FreePos, Items}) ->
    case do(Items) of
        {false, _} -> 
            ?ELOG("封印仓库物品转换失败:~w",[Items]),
            {false, ?L(<<"封印仓库物品转换失败">>)};
        {ok, NewItems} ->
            {CasinoItems, NewNextId} = case NextId > ?MAX_ID of
                true -> reset_items(NewItems);
                false -> {NewItems, NextId}
            end,
            {casino, NewNextId, Volume, FreePos, CasinoItems}
    end.

parse_guildbag({guild_store, GuildNextId, GuildExten, GuildVolume, GuildFreePos, GuildItems}) ->
    case do(GuildItems) of
        {false, _} -> 
            ?ELOG("帮会仓库转换失败:~w",[GuildItems]),
            {false, ?L(<<"帮会仓库转换失败">>)};
        {ok, Data5} ->
            {guild_store, GuildNextId, GuildExten, GuildVolume, GuildFreePos, Data5}
    end.

parse_super_boss_store({super_boss_store, NextId, Volume, FreePos, Items}) ->
    case do(Items) of
        {false, _} -> 
            ?ELOG("盘龙仓库物品转换失败:~w",[Items]),
            {false, ?L(<<"盘龙仓库转换失败">>)};
        {ok, NewItems} ->
            {CasinoItems, NewNextId} = case NextId > ?MAX_ID of
                true -> reset_items(NewItems);
                false -> {NewItems, NextId}
            end,
            {super_boss_store, NewNextId, Volume, FreePos, CasinoItems}
    end.

parse_pet_magic({pet_magic, NextId, Volume, FreePos, Items}) ->
    case do(Items) of
        {false, _} -> 
            ?ELOG("魔晶仓库物品转换失败:~w",[Items]),
            {false, ?L(<<"魔晶仓库转换失败">>)};
        {ok, NewItems} ->
            {CasinoItems, NewNextId} = case NextId > ?MAX_ID of
                true -> reset_items(NewItems);
                false -> {NewItems, NextId}
            end,
            case Volume < 18 of
                true ->
                    {pet_magic, NewNextId, 18, FreePos ++ lists:seq(Volume + 1, 18), CasinoItems};
                false ->
                    {pet_magic, NewNextId, Volume, FreePos, CasinoItems}
            end
    end.

%% 登陆检测
login(Role = #role{eqm = Eqm, dress = Dress}) ->
    NewDress = check_eqm(Eqm, Dress),
    Role#role{dress = NewDress}.

%% ----------------------
check_eqm([], Dress) -> Dress;
check_eqm([Item = #item{base_id = BaseId, type = Type} | T], Dress)
when Type =:= ?item_weapon_dress ->
    case lists:keyfind(BaseId, #item.base_id, Dress) of
        false ->
            Id = item_dress_data:baseid_to_id(BaseId),
            DressItem = Item#item{bind = 1, id = Id, pos = Id},
            check_eqm(T, [DressItem | Dress]);
        _ ->
            check_eqm(T, Dress)
    end;
check_eqm([_Item | T], Dress) ->
    check_eqm(T, Dress).

%% 重置ID
reset_items(Items) ->
    reset_items(Items, [], 1).

reset_items([], NewItems, Id) -> {NewItems, Id};
reset_items([Item | T], NewItems, Id) ->
    reset_items(T, [Item#item{id = Id} | NewItems], Id + 1).

check_expire(BaseId, Enchant) ->
    case lists:member(BaseId, campaign_data:get_expire_list()) of
        true -> Enchant >= 8; 
        false -> true
    end.

%% 过期物品
del_expire(FreePos, Data) ->
    Now = util:unixtime(),
    del_expire(FreePos, Data, Now, []).

del_expire(FreePos, [], _, Items) -> {FreePos, Items};
del_expire(FreePos, [Item = #item{special = []} | T], Now, Items) ->
    del_expire(FreePos, T, Now, [Item | Items]);
del_expire(FreePos, [Item = #item{pos = Pos, base_id = BaseId, special = Special, enchant = Enchant} | T], Now, Items) ->
    case lists:keyfind(?special_expire_time, 1, Special) of
        false -> del_expire(FreePos, T, Now, [Item | Items]);
        {_, Time} when Now < Time ->
            del_expire(FreePos, T, Now, [Item | Items]);
        _ ->
            case check_expire(BaseId, Enchant) of
                true ->
                    del_expire(FreePos, T, Now, [Item#item{special = lists:keydelete(?special_expire_time, 1, Special)} | Items]);
                false ->
                    case get(fetch_role_info) of
                        undefined ->
                            ?ERR("删除物品时,无法获取角色信息,删除的物品是:~w",[Item]);
                        {{Rid, SrvId}, Name} ->
                            log:log(log_item_del, {[Item], <<"过期删除">>, <<"">>, Rid, SrvId, Name})
                    end,
                    del_expire([Pos | FreePos], T, Now, Items)
            end
    end.
