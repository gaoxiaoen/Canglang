%%--------------------------------------------------
%% 采集系统
%% @author 252563398@qq.com 
%%--------------------------------------------------
-module(collect).
-export([
        find/2
        ,addItem/2
        ,add_collect/2
        ,collect_to_bag/5
        ,collect_to_bag/4
        ,del_all_item/2
        ,del_item_by_pos/2
        ,del_item/2
        ,refresh_bag/2
        ,all_to_bag/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("item.hrl").
-include("storage.hrl").
-include("link.hrl").
%%

%% 查找物品数量
%% @spec find(Role, BaseId) -> {ok, Num, Items, BindItems, UnBindItems} | {false, Reason}
find(#role{collect = #collect{items = Items}}, BaseId) ->
    storage:find(Items, #item.base_id, BaseId).

%% 增加物品到背包
%% @spec addItem(Collect, Items) -> {false, Reason} | {ok, NewCollect, NewItems}
addItem(Collect, Items) ->
    do_add(Collect, Items, []).
do_add(Collect, [], NewItems) -> {ok, Collect, NewItems};
do_add(Collect, [Item | T], NewItems) ->
    case add_collect(Collect, Item) of
        {false, Reason} -> {false, Reason};
        {ok, NewCollect, NewItem} -> 
            do_add(NewCollect, T, [NewItem | NewItems])
    end.

%% 添加某个物品到背包
%% @spec add_collect(Collect, Item) -> {ok, NewCollect, NewItem} | {false, Reason}
add_collect(Collect = #collect{volume = Volume, free_pos = undefined}, Item) ->
    PosList = lists:seq(1, Volume),
    add_collect(Collect#collect{free_pos = PosList}, Item);
add_collect(#collect{free_pos = []}, _Item) -> {false, ?L(<<"采集背包空间不足">>)};
add_collect(Collect = #collect{free_pos = [P | FreePos], items = Items}, Item) ->
    I = Item#item{id = P, pos = P},
    {ok, Collect#collect{free_pos = FreePos, items = [I | Items]}, I}.


%% 移动采集背包物品到背包
collect_to_bag(_Collect, _CPos, _Bag = #bag{free_pos=[]}, _Role) ->
    {false, ?L(<<"领取奖励失败，请检查背包是否已满">>)};
collect_to_bag(Collect, CPos, Bag = #bag{free_pos = undefined}, Role) ->
    collect_to_bag(Collect, CPos, Bag, 1, Role);
collect_to_bag(Collect, CPos, Bag = #bag{free_pos = [Pos | _]}, Role) ->
    collect_to_bag(Collect, CPos, Bag, Pos, Role).

%% @spec collect_to_bag(Collect, Id, Bag, Tpos, ConnPid) -> {ok, NewCollect, NewBag} | {false, Reason}
%% Collect = #collect{}  采集背包
%% Bag = #bag{} 背包
%% Spos = int() 采集背包Pos
%% Tpos = int() 背包Pos
%% Role  角色
%% 移动成功需要调用storage_api:del_item_info/2和storage_api:add_item_info通知客户端
collect_to_bag(Collect, Spos, Bag = #bag{volume = Volume, free_pos = undefined}, Tpos, Role) ->
    collect_to_bag(Collect, Spos, Bag#bag{free_pos=lists:seq(1, Volume)}, Tpos, Role);
collect_to_bag(Collect = #collect{items = Items}, Spos, Bag = #bag{items = BagItems}, Tpos, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case check_pos(Collect, Spos) andalso check_pos(Bag, Tpos) of
        true ->
            case {storage:find(Items, #item.pos, Spos), storage:find(BagItems, #item.pos, Tpos)} of
                {{ok, Item}, {false, _Info}}->
                    case storage:add(bag, Role, [Item]) of
                        {ok, NewBag} ->
                            case del_item(Collect, Spos) of
                                {ok, NewCollect} ->
                                    DelItemList = [{?storage_collect, Item}],
                                    storage_api:del_item_info(ConnPid, DelItemList),
                                    {ok, NewCollect, NewBag};
                                {false, Reason} -> {false, Reason}
                            end;
                        false -> {false, ?L(<<"领取奖励失败，请检查背包是否已满">>)}
                    end;    
                _ ->
                    {false, <<>>}
            end;
        false ->
            {false, ?L(<<"位置非法">>)}
    end.

%% 移动采集背包所有物品到背包
all_to_bag(Collect = #collect{items = CItems}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case storage:add(bag, Role, CItems) of
        {ok, NewBag} -> 
            {ok, NewCollect} = del_all_item(ConnPid, Collect),
            {ok, NewCollect, NewBag};
        false -> {false, ?L(<<"领取奖励失败，请检查背包是否已满">>)}
    end.

%% 删除整个采集背包的物品
%% @spec del_all_item(ConnPid, Collect) -> {ok, NewCollect} | {false, Reason}
%% ConnPid = #role{link = #link{conn_pid = ConnPid}}
%% Collect = #collect{}
%% 已经推送删除通知到客户端
del_all_item(ConnPid, Collect = #collect{items = Items, free_pos = FreePos, volume = Volume}) ->
    DelList = lists:seq(1, Volume) -- FreePos,
    case del_item_by_pos(Collect, DelList) of
        {ok, NewCollect} ->
            SendList = [{?storage_collect, Item} || Item <- Items],
            storage_api:del_item_info(ConnPid, SendList),
            {ok, NewCollect};
        {false, Reason} ->
            {false, Reason}
    end.

%% 整理采集背包物品
%% 物品位置从小到大使用
%% 合并所有能合并的物品
%% 已经推送更新通知到客户端
refresh_bag(Collect = #collect{free_pos = FreePos, items = Items}, _Role) when FreePos =:= undefined orelse Items =:= []  ->
    Collect;
refresh_bag(Collect = #collect{volume = Volume, items = Items}, _Role = #role{link = #link{conn_pid = ConnPid}}) ->
    FreePos = lists:seq(1, Volume),
    ItemList = lists:sort(fun sort_item/2, storage:combine(Items, [])),
    {NewItems, NewFreePos} = refresh_bag(ItemList, FreePos, []),
    sys_conn:pack_send(ConnPid, 12300, {Volume, NewItems}),
    Collect#collect{items = NewItems, free_pos = NewFreePos}.

refresh_bag([], FreePos, Items) -> {Items, FreePos}; 
refresh_bag([I | T], [P | FreePos], Items) ->
    Item = I#item{id = P, pos = P},
    refresh_bag(T, FreePos, [Item | Items]).

sort_item(#item{quantity = Q1}, #item{quantity = Q2}) when Q1 > Q2 -> true;
sort_item(_, _) -> false.

%% 删除采集背包指定位置物品
%% @spec del_item_by_pos(Collect, PosInfo) -> {ok, NewCollect} | {false, Reason}
%% Collect = #collect{}
%% PosInfo = [Pos,...]
del_item_by_pos(Collect, []) -> {ok, Collect};
del_item_by_pos(Collect, [Pos | T]) ->
    case del_item(Collect, Pos) of
        {false, Reason} -> {false, Reason};
        {ok, Ni} -> del_item_by_pos(Ni, T)
    end.

%% 删除指定位置的采集物品
del_item(Collect = #collect{free_pos = FreePos, items = Items}, Pos) ->
    case do_del(Items, [], Pos, []) of
        {false, Reason} -> {false, Reason};
        {ok, NewItems, NewPos} ->
            P = lists:sort(NewPos++FreePos),
            {ok, Collect#collect{free_pos = P, items = NewItems}}
    end.

%% 执行删除
do_del([], Items, _Pos, NewPos) -> {ok, Items, NewPos};
do_del([#item{pos = Fpos} | T], Items, Pos, NewPos) when Fpos =:= Pos ->
    {ok, T ++ Items, [Pos | NewPos]};
do_del([Item | T], Items, Pos, NewPos) ->
    do_del(T, [Item | Items], Pos, NewPos).

%% 检查Pos是否合法
check_pos(#collect{volume = Volume}, Pos) ->
    Pos >= 1 andalso Pos =< Volume;
check_pos(#bag{volume = Volume}, Pos) ->
    Pos >= 1 andalso Pos =< Volume.

