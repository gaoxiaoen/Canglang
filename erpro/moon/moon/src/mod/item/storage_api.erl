%%----------------------------------------------------
%% 物品系统的API调用
%% @author shawnoyc@163.com
%%----------------------------------------------------
-module(storage_api).
-export([
        refresh_single/2 %% 刷新单个物品
        ,refresh_client_item/ 3 %% 刷新客户端物品数据
        ,refresh_client/2 %% 批量刷新客户端物品数据
        ,refresh_mulit/2 %%  刷新多个物品
        ,del_item_info/2 %%  删除物品通知 
        ,add_item_info/2 %%  增加物品通知
        ,set_item_lock/4 %% 锁定物品
        ,add_storage_volume/2 %% 增加存储空间容量
        ,fresh_item/4
        ,fresh_dress/3 %% 刷新衣柜,仅当操作身上时装时需要使用
        ,fresh_mounts/4 %% 刷新坐骑栏
        ,fresh_wing/4   %% 刷新翅膀栏
        ,fresh_wing_not_push/2
        ,get_free_num/2 %% 获取背包的剩余格子数
        ,change_sex/1
        ,get_dress_to_change_sex/1
        ,has_item/2 %% 查找玩家是否含有某物品
        ,check_items_to_feed/4
        ,change_eqm/1
        ,pack_info/2
    ]).


-include("item.hrl").
-include("common.hrl").
-include("storage.hrl").
-include("role.hrl").
-include("gain.hrl").
%%
-include("link.hrl").
-include("wing.hrl").

%% 加物品锁定状态
%% @spec lock_item(Bag, Id, Status, ConnPid) -> {ok, NewBag, Item} | {false, Reason}
%% Item = #item{} 物品数据
%% Status = integer() 物品状态
%% NewItem = #item{} 修改之后的物品数据
set_item_lock(Bag = #bag{items = Items}, Id, Status, ConnPid) ->
    case storage:find(Items, #item.id, Id) of
        {ok, #item{bind = ?true}} ->
            {false, <<>>};
        {ok, Item = #item{status = S}} -> 
            if
                Status =:= 0 andalso S =:= 0 -> %% 本身未锁,不必解锁
                    {ok, Bag, Item};
                S =:= 0 andalso Status =/= 0 -> %% 本身未锁,需要加锁
                    fresh_item(Item, Item#item{status = Status}, Bag, ConnPid);
                Status =:= 0 andalso S =/= 0 -> %% 本身加锁,需要解锁
                    fresh_item(Item, Item#item{status = 0}, Bag, ConnPid);
                Status =/= 0 andalso S =/= 0 -> %% 本身加锁,要求加锁
                    {false, ?L(<<"物品已经被锁定">>)}
            end;
        {false, Reason} ->
            {false, Reason}
    end.

%% 更新物品数据
%% @spec fresh_item(OldItem, NewItem, Storage) ->
fresh_item(OldItem, NewItem, Bag = #bag{items = Items, free_pos = FreePos}, ConnPid) ->
    NewItems = lists:keyreplace(OldItem#item.id, #item.id, Items, NewItem),
    refresh_single(ConnPid, {?storage_bag, NewItem}),
    case NewItem#item.pos =:= OldItem#item.pos of
        true -> {ok, Bag#bag{items = NewItems}, NewItem};
        false -> 
            NewFreePos = [OldItem#item.pos | (FreePos -- [NewItem#item.pos])],
            {ok, Bag#bag{items = NewItems, free_pos = lists:sort(NewFreePos)}, NewItem}
    end;
fresh_item(OldItem, NewItem, Store = #store{items = Items, free_pos = FreePos}, ConnPid) ->
    NewItems = lists:keyreplace(OldItem#item.id, #item.id, Items, NewItem),
    refresh_single(ConnPid, {?storage_store, NewItem}),
    case NewItem#item.pos =:= OldItem#item.pos of
        true -> {ok, Store#store{items = NewItems}, NewItem};
        false -> 
            NewFreePos = [OldItem#item.pos | (FreePos -- [NewItem#item.pos])],
            {ok, Store#store{items = NewItems, free_pos = lists:sort(NewFreePos)}, NewItem}
    end;
fresh_item(OldItem, NewItem, Store = #casino{items = Items, free_pos = FreePos}, ConnPid) ->
    NewItems = lists:keyreplace(OldItem#item.id, #item.id, Items, NewItem),
    refresh_single(ConnPid, {?storage_casino, NewItem}),
    case NewItem#item.pos =:= OldItem#item.pos of
        true -> {ok, Store#casino{items = NewItems}, NewItem};
        false -> 
            NewFreePos = [OldItem#item.pos | (FreePos -- [NewItem#item.pos])],
            {ok, Store#casino{items = NewItems, free_pos = lists:sort(NewFreePos)}, NewItem}
    end;
fresh_item(OldItem, NewItem, Store = #super_boss_store{items = Items, free_pos = FreePos}, ConnPid) ->
    NewItems = lists:keyreplace(OldItem#item.id, #item.id, Items, NewItem),
    refresh_single(ConnPid, {?storage_super_boss, NewItem}),
    case NewItem#item.pos =:= OldItem#item.pos of
        true -> {ok, Store#super_boss_store{items = NewItems}, NewItem};
        false -> 
            NewFreePos = [OldItem#item.pos | (FreePos -- [NewItem#item.pos])],
            {ok, Store#super_boss_store{items = NewItems, free_pos = lists:sort(NewFreePos)}, NewItem}
    end;
fresh_item(OldItem, NewItem, Eqm, ConnPid) when is_list(Eqm) ->
    NewEqm = lists:keyreplace(OldItem#item.id, #item.id, Eqm, NewItem),
    refresh_single(ConnPid, {?storage_eqm, NewItem}),
    {ok, NewEqm, NewItem}.

%% 刷新衣柜, 仅当操作身上的时装时使用
fresh_dress(Item = #item{base_id = BaseId, type = ?item_shi_zhuang}, Dress, ConnPid) ->
    Id = item_dress_data:baseid_to_id(BaseId),
    NewItem = Item#item{id = Id, pos = Id},
    NewDress = lists:keyreplace(BaseId, #item.base_id, Dress, NewItem),
    refresh_single(ConnPid, {?storage_dress, NewItem}),
    NewDress;

fresh_dress(Item = #item{base_id = BaseId, type = ?item_weapon_dress}, Dress, ConnPid) ->
    Id = item_dress_data:baseid_to_id(BaseId),
    NewItem = Item#item{id = Id, pos = Id},
    NewDress = lists:keyreplace(BaseId, #item.base_id, Dress, NewItem),
    refresh_single(ConnPid, {?storage_dress, NewItem}),
    NewDress;

fresh_dress(Item = #item{base_id = BaseId, type = ?item_footprint}, Dress, ConnPid) ->
    Id = item_dress_data:baseid_to_id(BaseId),
    NewItem = Item#item{id = Id, pos = Id},
    NewDress = lists:keyreplace(BaseId, #item.base_id, Dress, NewItem),
    refresh_single(ConnPid, {?storage_dress, NewItem}),
    NewDress;

fresh_dress(Item = #item{base_id = BaseId, type = ?item_chat_frame}, Dress, ConnPid) ->
    Id = item_dress_data:baseid_to_id(BaseId),
    NewItem = Item#item{id = Id, pos = Id},
    NewDress = lists:keyreplace(BaseId, #item.base_id, Dress, NewItem),
    refresh_single(ConnPid, {?storage_dress, NewItem}),
    NewDress;

fresh_dress(Item = #item{base_id = BaseId, type = ?item_text_style}, Dress, ConnPid) ->
    Id = item_dress_data:baseid_to_id(BaseId),
    NewItem = Item#item{id = Id, pos = Id},
    NewDress = lists:keyreplace(BaseId, #item.base_id, Dress, NewItem),
    refresh_single(ConnPid, {?storage_dress, NewItem}),
    NewDress;

fresh_dress(_, Dress, _) -> Dress.

%% 刷新坐骑栏
fresh_mounts(#item{type = ?item_zuo_qi}, NewItem = #item{type = ?item_zuo_qi, pos = Pos}, Mounts = #mounts{items = Items}, ConnPid) when Pos > 0 ->
    #item{id = Id} = lists:keyfind(Pos, #item.pos, Items),
    NewMount = NewItem#item{id = Id},
    refresh_single(ConnPid, {?storage_mount, NewMount}),
    NewItems = lists:keyreplace(Pos, #item.pos, Items, NewMount),
    Mounts#mounts{items = NewItems};
fresh_mounts(OldItem = #item{type = ?item_zuo_qi}, NewItem = #item{type = ?item_zuo_qi}, Mounts = #mounts{items = Items}, ConnPid) ->
    NewItems = lists:keyreplace(OldItem#item.id, #item.id, Items, NewItem),
    refresh_single(ConnPid, {?storage_mount, NewItem}),
    Mounts#mounts{items = NewItems};
fresh_mounts(_, _, Mounts, _) -> Mounts.

%% 刷新翅膀栏
fresh_wing(#item{enchant = OldEnchant, type = ?item_wing}, NewItem = #item{enchant = NewEnchant, type = ?item_wing, pos = Pos}, Wing = #wing{skin_grade = SkinGrade, items = Items}, ConnPid) when Pos > 0 ->
    #item{id = Id} = lists:keyfind(Pos, #item.pos, Items),
    NewWing = NewItem#item{id = Id},
    refresh_single(ConnPid, {?storage_wing, NewWing}),
    NewItems = lists:keyreplace(Pos, #item.pos, Items, NewWing),
    NewSkinGrade = case OldEnchant =:= NewEnchant of
        true -> SkinGrade;  %% 不是强化 不处理
        false when NewEnchant =:= 12 -> 2;  %% 强化升12
        false when NewEnchant >= 9 -> 1;    %% 强化升至9以上
        _ -> 0
    end,
    Wing#wing{skin_grade = NewSkinGrade, items = NewItems};
fresh_wing(OldItem = #item{type = ?item_wing}, NewItem = #item{type = ?item_wing}, Wing = #wing{items = Items}, ConnPid) ->
    NewItems = lists:keyreplace(OldItem#item.id, #item.id, Items, NewItem),
    refresh_single(ConnPid, {?storage_wing, NewItem}),
    Wing#wing{items = NewItems};
fresh_wing(_, _, Wing, _) -> Wing.

fresh_wing_not_push(NewItem = #item{type = ?item_wing, pos = Pos}, Wing = #wing{items = Items}) when Pos > 0 ->
    #item{id = Id} = lists:keyfind(Pos, #item.pos, Items),
    NewWing = NewItem#item{id = Id},
    NewItems = lists:keyreplace(Pos, #item.pos, Items, NewWing),
    Wing#wing{items = NewItems};
fresh_wing_not_push(NewItem = #item{id = Id, type = ?item_wing}, Wing = #wing{items = Items}) ->
    NewItems = lists:keyreplace(Id, #item.id, Items, NewItem),
    Wing#wing{items = NewItems};
fresh_wing_not_push( _, Wing) -> Wing.

%% @spec refresh_client_item(Atom, Sender, [{StorageType, Items}|..])
%% @doc 刷新客户端的物品
%% Atom = add | refresh | del
%% Send = #link.conn_pid
%% StorageType = ?storage_bag | ?storage_store | ?storage_eqm
%% Items = [#item{} | ..]
refresh_client_item(Mode, Sender, ItemInfo) ->
    refresh_client_item(Mode, Sender, ItemInfo, []).
refresh_client_item(Mode, Sender, [], SendList) ->
    case SendList =:= [] of
        true -> ok;
        false ->
            case Mode of
                add ->
                    add_item_info(Sender, SendList);
                del ->
                    del_item_info(Sender, SendList);
                refresh ->
                    refresh_mulit(Sender, SendList)
            end
    end;
refresh_client_item(Mode, Sender, [{StorageType, Items} | T], SendList) ->
    ItemList = [{StorageType, Item} || Item <- Items],
    refresh_client_item(Mode, Sender, T, SendList ++ ItemList).

%% @spec refresh_client([{Type, AddList, DelList, FreshList}|..], ConnPid) ->
%% @doc 批量刷新客户端物品信息
%% Type = ?storage_bag | ?storage_task ...
%% AddList = [#item{} |..]
refresh_client([], _ConnPid) -> ignore;
refresh_client([{Type, AddList, DelList, FreshList} | T], ConnPid) ->
    storage_api:refresh_client_item(del, ConnPid, [{Type, DelList}]),
    storage_api:refresh_client_item(add, ConnPid, [{Type, AddList}]),
    storage_api:refresh_client_item(refresh, ConnPid, [{Type, FreshList}]),
    refresh_client(T, ConnPid).


%% 刷新物品,推送数据
%% @spec refresh_single(Sender, {StPos, Item}) ->  sys_conn:pack_send(10310)
%% @spec refresh_mulit(Sender, ItemList) -> sys_conn:pack_send(10311)
%% StPos = 1.背包, 2.仓库 3.身上 4.采集背包
%% Item = #item{}.
%% ItemList = {StPos, #item{}}

refresh_single(Sender, {StPos, #item{id = Id, base_id = BaseId, bind = Bind, upgrade = Upgrade, enchant = Enchant, enchant_fail = EnchantFail, quantity = Quantity, status = Status, pos = Pos, lasttime = Lasttime, durability = Durability, craft = Craft, attr = Attr, max_base_attr = MaxBaseAttr, extra = Extra, special = Special}}) ->
    sys_conn:pack_send(Sender, 10310, {StPos, Id, BaseId, Bind, Upgrade, Enchant, EnchantFail, Quantity, Status, Pos, Lasttime, Durability, Craft, Attr, MaxBaseAttr, Extra, Special}).

refresh_mulit(_,[]) -> ok;
refresh_mulit(Sender, ItemList) ->
    SendList = [[StPos, Item#item.id, Item#item.base_id, Item#item.bind, Item#item.upgrade, Item#item.enchant, Item#item.enchant_fail, Item#item.quantity, Item#item.status, Item#item.pos, Item#item.lasttime, Item#item.durability, Item#item.craft, Item#item.attr, Item#item.max_base_attr, Item#item.extra, Item#item.special] ||  {StPos, Item} <- ItemList],
    sys_conn:pack_send(Sender, 10311, {SendList}).

%% 增加/删除物品,推送数据
%% @spec del_item_info(Sender, ItemList) ->  sys_conn:pack_send(10313)
%% @spec add_item_info(Sender, ItemList) -> sys_conn:pack_send(10312)
%% ItemList = [{StPos, #item{}}]
%% StPos = 1.背包, 2.仓库 3.身上
%% Item = #item{}.
del_item_info(_Sender,[{_,[]}]) ->
    ok;
del_item_info(Sender, ItemList) ->
    SendList = [[Item#item.id, StPos, Item#item.pos] || {StPos, Item} <- ItemList],
    sys_conn:pack_send(Sender, 10313, {SendList}).

add_item_info(Sender, ItemList) ->
    SendList = [[StPos, Item#item.id, Item#item.base_id, Item#item.bind, Item#item.upgrade, Item#item.enchant, Item#item.enchant_fail, Item#item.quantity, Item#item.status, Item#item.pos, Item#item.lasttime, Item#item.durability, Item#item.craft, Item#item.attr, Item#item.max_base_attr, Item#item.extra, Item#item.special] ||  {StPos, Item} <- ItemList],
    sys_conn:pack_send(Sender, 10312, {SendList}).

%% @spec add_storage_volume(Storage, Role, Value) -> {ok, NewRole}
%% Storage = bag | store
%% Role = #role{}
%% Value = integer()
%% @doc 增加背包或者仓库容量
add_storage_volume(NewVol, #role{bag = #bag{volume = BagVolume}}) when NewVol =< BagVolume orelse NewVol > ?bag_max_volume ->
    {false, ?MSGID(<<"扩展空间不合法">>)};
add_storage_volume(NewVol, Role = #role{bag = #bag{volume = BagVolume, free_pos = BagFree, items=Items}}) ->
    case BagVolume >= ?bag_max_volume of
        true ->
            {false, ?MSGID(<<"背包已经扩充满了,无需扩充">>)};
        false ->
            Range1 = BagVolume - ?bag_def_volume + 1,
            Range2 = NewVol - ?bag_def_volume,
            NeedOpenItem = lists:foldl(fun(X,Sum)-> Sum+bag_ext_data:get(X) end, 0, lists:seq(Range1, Range2)),
            ?DEBUG("扩展背包需要器物: ~p", [NeedOpenItem]),
            HaveItemNum = case storage:find(Items, #item.base_id, 601001) of {false,_}-> 0; {ok, Num,_,_,_}-> Num end,
            NeedYb = case HaveItemNum >= NeedOpenItem of true->0; false-> NeedOpenItem-HaveItemNum end,
            ?DEBUG("拥有扩展器个数: ~p", [HaveItemNum]),
            ?DEBUG("需要元宝数量: ~p 需要扩展器:~p", [NeedYb, NeedOpenItem-NeedYb]),
            case role_gain:do([#loss{label = gold, val = NeedYb, msg = ?MSGID(<<"晶钻不足">>)}, #loss{label=itemsall,val=[{601001,NeedOpenItem-NeedYb}], msg = ?MSGID(<<"背包拓展器不足">>)}], Role) of
                {false, #loss{msg = Msg}} ->
                    {false, Msg};
                {ok, NewRole = #role{bag = Bag1}} ->
                    {ok, NewVol, NewRole#role{bag = Bag1#bag{volume = NewVol, free_pos = BagFree ++ ?FREEPOS(BagVolume + 1, NewVol)}}}
            end

    end.

%% @spec get_free_num(Role) -> integer()
%% @doc 获取剩余格子数
get_free_num(bag, #role{bag = #bag{free_pos = FreePos}}) ->
    length(FreePos);
get_free_num(store, #role{store = #store{free_pos = FreePos}}) ->
    length(FreePos);
get_free_num(_, _) -> 0.

%% @spec change_sex(Role) -> NewRole
%% @doc 变性处理时装等
change_sex(Role = #role{eqm = Eqm, dress = Dress, link = #link{conn_pid = ConnPid}}) ->
    {DelList1, AddList1} = change_eqm(Eqm),
    DelInfo1 = pack_info(?storage_eqm, DelList1),
    AddInfo1 = pack_info(?storage_eqm, AddList1),
    storage_api:del_item_info(ConnPid, DelInfo1), %% 先发删除
    storage_api:add_item_info(ConnPid, AddInfo1),
    {DelList2, AddList2} = change_eqm(Dress),
    DelInfo2 = pack_info(?storage_dress, DelList2),
    AddInfo2 = pack_info(?storage_dress, AddList2),
    storage_api:del_item_info(ConnPid, DelInfo2), %% 先发删除
    storage_api:add_item_info(ConnPid, AddInfo2),
    Role#role{eqm = (Eqm -- DelList1) ++ AddList1, dress = (Dress -- DelList2) ++ AddList2}.

%% @spec get_dress_to_change_sex(Role) -> [{OldId, ToId} | ...]
%% @doc 获取变性要处理时装
get_dress_to_change_sex(#role{dress = Dress}) ->
    Fun1 = fun(BaseId) ->
            case item_dress_data:to_sex(BaseId) of
                false -> false;
                _ -> true
            end
    end,
    Fun2 = fun(BaseId) ->
            {BaseId, item_dress_data:to_sex(BaseId)}
    end,
    [Fun2(Id) || #item{base_id = Id} <- Dress, Fun1(Id)].

%% @spec has_item(ItemBaseId, Role) -> true | false
%% @doc 判断玩家背包是否有某物品(BaseId)
has_item(ItemBaseId, #role{bag = #bag{items = Items}}) ->
    case storage:find(Items, #item.base_id, ItemBaseId) of
        {false, _} -> false;
        _ -> true
    end.

%% @spec check_items_to_feed(FeedList, Items, BaseReturns, IdReturns) -> {Basereturns, Idreturns}
%% Items = [#item{} | ...]
%% FeedList = [[ItemId, Num] | ...]
%% @doc 检查一组喂养物品，返回一组待扣除BaseID的列表，一组ID列表
check_items_to_feed([], _, BaseL, IdL) -> {BaseL, IdL};
check_items_to_feed([[Id, Num] | T], Items, BaseL, IdL) ->
    case storage:find(Items, #item.id, Id) of
        {ok, I = #item{id = Id, base_id = BaseId, quantity = Q}} when Q > Num ->
            NewItems = lists:keyreplace(Id, #item.id, Items, I#item{quantity = Q-Num}),
            check_items_to_feed(T, NewItems, [{BaseId, Num} | BaseL], [{Id, Num} | IdL]);
        {ok, #item{id = Id, base_id = BaseId, quantity = Q}} when Q =:= Num ->
            NewItems = lists:keydelete(Id, #item.id, Items),
            check_items_to_feed(T, NewItems, [{BaseId, Num} | BaseL], [{Id, Num} | IdL]);
        _ -> %% TODO: 不合法的，忽略
            check_items_to_feed(T, Items, BaseL, IdL)
    end.

%% --------------------------------------------------------
%% 内部处理
%% --------------------------------------------------------
%% 替换相应装备
change_eqm(Eqm) ->
    change_eqm(Eqm, [], []).
change_eqm([], DelList, AddList) ->
    {DelList, AddList};
change_eqm([I = #item{base_id = BaseId} | T], DelList, AddList) ->
    case item_dress_data:to_sex(BaseId) of
        false ->
            change_eqm(T, DelList, AddList);
        NewBaseId ->
            change_eqm(T, [I | DelList], [I#item{base_id = NewBaseId} | AddList])
    end.

%% 通知装备更新
pack_info(StoPos, ItemList) ->
    pack_info(StoPos, ItemList, []).
pack_info(_StoPos, [], InfoList) -> InfoList;
pack_info(StoPos, [H | T], InfoList) ->
    pack_info(StoPos, T, [{StoPos, H} | InfoList]).
