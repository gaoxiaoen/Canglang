%%---------------------------------------------------- 
%% 物品存储系统 
%% @author yeahoo2000@gmail.com 
%%---------------------------------------------------- 
-module(storage). 
-export([ 
        sort/2 
        ,sort/1
        ,add/3 
        ,make_and_add_fresh/4 
        ,add_no_refresh/2 
        ,use/3 
        ,use/4 
        ,use_id/3 
        ,use_id/4 
        ,del/2 
        ,del/5 
        ,del_pos/2 
        ,del_pos/3 
        ,del_item_by_id/3
        ,del_item_by_id/6
        ,del_base_by_bind_fst/2
        ,del_base_by_Ubind_fst/2
        ,get_del_base_bindlist/4
        ,get_del_base_ubindlist/4
        ,split_item/4
        ,find/3 
        ,swap_by_pos_same/4
        ,swap_by_pos/4 
        ,move_eqm/4 
        ,move_bag_eqm/3 
        ,count/2 
        ,check_exchange/1
        ,bind_mount/1
        ,check_fly_and_mount/2
        ,clean_no_fresh/2
        %%----store----% 
        ,combine/2 
        ,check_same_item/2
        ,deal_pet_eqm/2
    ] 
). 
-include("common.hrl"). 
-include("item.hrl"). 
-include("role.hrl"). 
-include("storage.hrl"). 
%% 
-include("link.hrl"). 
-include("condition.hrl"). 
-include("gain.hrl").
-include("pet.hrl").

%% 整理 
%% 规则:合并所有能合并的物品，然后按品质高低依次从第一格开始排列物品 
%% @spec sort(Storage, Role) -> {ok, NewStorage} 
%% Storage = NewStorage = #bag{} | #store{} 背包或仓库 
sort(Bag = #bag{volume = Volume, items = Items}, _Role) -> 
    ItemList = lists:sort(fun sort_type/2, combine(Items, [])), %% 合并后进行排序 
    %%{ok, Bag#bag{free_pos = ?FREEPOS(1, Volume), items = ItemList}}
    add_for_sort(Bag#bag{free_pos = ?FREEPOS(1, Volume), items = [] }, ItemList, []);
%%    add(bag, Role#role{bag = Bag#bag{free_pos = ?FREEPOS(1, Volume), items = []}}, ItemList);

sort(Store = #store{volume = Volume, items = Items}, Role) -> 
    ItemList = lists:sort(fun sort_type/2, combine(Items, [])), %% 合并后进行排序 
    add(store, Role#role{store = Store#store{free_pos = ?FREEPOS(1, Volume), items = []}}, ItemList);

sort(Casino = #casino{volume = Volume, items = Items}, Role) -> 
    ItemList = lists:sort(fun sort_type/2, combine(Items, [])), %% 合并后进行排序 
    add(casino, Role#role{casino = Casino#casino{free_pos = ?FREEPOS(1, Volume), items = []}}, ItemList);

sort(Store = #super_boss_store{volume = Volume, items = Items}, Role) -> 
    ItemList = lists:sort(fun sort_type/2, combine(Items, [])), %% 合并后进行排序 
    add(super_boss_store, Role#role{super_boss_store = Store#super_boss_store{free_pos = ?FREEPOS(1, Volume), items = []}}, ItemList).

%% @spec sort(Storage) -> {ok, NewStorage}.
sort(GuildStore = #guild_store{volume = Volume, items = Items}) ->
    ItemList = lists:sort(fun sort_type/2, combine(Items, [])),
    add(guild_store, GuildStore#guild_store{free_pos = ?FREEPOS(1, Volume), items = []}, ItemList).

check_exchange([]) -> true;
check_exchange([#item{status = Status}| T]) ->
    case Status =:= ?lock_release of
        true -> 
            check_exchange(T);
        false ->
            {false, ?L(<<"物品锁定,整理失败">>)}
    end.

%% 专门用于整理背包
add_for_sort(Storage, [], _BackItem) -> 
    {ok, Storage}; 

add_for_sort(Storage, [H | T], BackItem) -> 
    case do_add(Storage, H, BackItem) of 
        false -> false; 
        {ok, Ns, NewBack} -> add_for_sort(Ns, T, NewBack) 
    end. 


%% 添加物品 
%% @spec add(type, Role, Items) -> false | {ok, NewStorage} 
%% type = bag | store 背包或仓库 
%% Items = [#item{} | ...] 物品数据，单个或多个 
%% 添加完之后会给客户端发送增加物品消息,无需再手动推送 
add(bag, Role, Items) -> 
    add(Role#role.bag, Role, Items, []); 
add(store, Role, Items) -> 
    add(Role#role.store, Role, Items, []); 
add(task_bag, Role, Items) ->
    add(Role#role.task_bag, Role, Items, []);
add(casino, Role, Items) ->
    add(Role#role.casino, Role, Items, []);
add(super_boss_store, Role, Items) ->
    add(Role#role.super_boss_store, Role, Items, []);
add(pet_magic, Role, Items) ->
    add(Role#role.pet_magic, Role, Items, []);
add(guild_store, GuildStore, Items) ->
    add(GuildStore, #role{}, Items, []).

add(Storage, #role{link = #link{conn_pid = ConnPid}}, [], BackItem) when is_record(Storage, bag) -> 
    ?DEBUG("----:~w~n",[BackItem]),
    storage_api:refresh_client_item(add, ConnPid, [{?storage_bag, BackItem}]),
    {ok, Storage}; 
add(Storage, #role{link = #link{conn_pid = ConnPid}}, [], BackItem) when is_record(Storage, store) -> 
    storage_api:refresh_client_item(add, ConnPid, [{?storage_store, BackItem}]),
    {ok, Storage}; 
add(Storage, #role{link = #link{conn_pid = ConnPid}}, [], BackItem) when is_record(Storage, task_bag) -> 
    storage_api:refresh_client_item(add, ConnPid, [{?storage_task, BackItem}]),
    {ok, Storage};
add(Storage, #role{link = #link{conn_pid = ConnPid}}, [], BackItem) when is_record(Storage, casino) -> 
    storage_api:refresh_client_item(add, ConnPid, [{?storage_casino, BackItem}]),
    {ok, Storage}; 
add(Storage, #role{link = #link{conn_pid = ConnPid}}, [], BackItem) when is_record(Storage, super_boss_store) -> 
    storage_api:refresh_client_item(add, ConnPid, [{?storage_super_boss, BackItem}]),
    {ok, Storage}; 
add(Storage, #role{link = #link{conn_pid = ConnPid}}, [], BackItem) when is_record(Storage, pet_magic) -> 
    storage_api:refresh_client_item(add, ConnPid, [{?storage_pet_magic, BackItem}]),
    {ok, Storage}; 
add(Storage, _Role, [], _BackItem) when is_record(Storage, guild_store) ->
    {ok, Storage};
add(Storage, Role, [H | T], BackItem) -> 
    case do_add(Storage, H, BackItem) of 
        false -> false; 
        {ok, Ns, NewBack} -> add(Ns, Role, T, NewBack) 
    end. 

%% 处理背包 
do_add(Bag = #bag{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    PosList = lists:seq(1, Volume), 
    do_add(Bag#bag{free_pos = PosList}, Item, BackItem); 
do_add(#bag{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
do_add(Bag, Item = #item{base_id=BaseId}, BackItem) -> 
    case item_data:get(BaseId) of
        {ok,#item_base{overlap=OverLap}} when OverLap > 1 ->
            case do_add_overlap(Bag, Item, BackItem) of
                false -> add_to_new_pos(Bag, Item, BackItem);
                Ret = {ok, _NewBag, _NewBackItem} -> Ret
            end;
        _ ->
            add_to_new_pos(Bag, Item, BackItem)
    end;
%%    I = Item#item{id = Id, pos = P}, 
%%    {ok, Bag#bag{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]}; 
%% 处理仓库 
do_add(Store = #store{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    PosList = lists:seq(1, Volume), 
    do_add(Store#store{free_pos = PosList}, Item, BackItem); 
do_add(#store{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
do_add(Store = #store{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) -> 
    I = Item#item{id = Id, pos = P}, 
    {ok, Store#store{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]};
%% 处理任务背包
do_add(TaskBag = #task_bag{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    PosList = lists:seq(1, Volume), 
    do_add(TaskBag#task_bag{free_pos = PosList}, Item, BackItem); 
do_add(#task_bag{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
do_add(TaskBag = #task_bag{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) -> 
    I = Item#item{id = Id, pos = P}, 
    {ok, TaskBag#task_bag{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]};
%% 处理仙境寻宝开宝箱仓库
do_add(Casino = #casino{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    PosList = lists:seq(1, Volume), 
    do_add(Casino#casino{free_pos = PosList}, Item, BackItem); 
do_add(#casino{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
do_add(Casino = #casino{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) -> 
    I = Item#item{id = Id, pos = P}, 
    {ok, Casino#casino{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]};
%% 处理盘龙仓库
do_add(Store = #super_boss_store{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    PosList = lists:seq(1, Volume), 
    do_add(Store#super_boss_store{free_pos = PosList}, Item, BackItem); 
do_add(#super_boss_store{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
do_add(Store = #super_boss_store{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) -> 
    I = Item#item{id = Id, pos = P}, 
    {ok, Store#super_boss_store{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]};
%% 处理宠物魔晶背包
do_add(Store = #pet_magic{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    PosList = lists:seq(1, Volume), 
    do_add(Store#pet_magic{free_pos = PosList}, Item, BackItem); 
do_add(#pet_magic{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
do_add(Store = #pet_magic{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) -> 
    I = Item#item{id = Id, pos = P}, 
    {ok, Store#pet_magic{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]};

%% 处理帮会仓库
do_add(Storeage = #guild_store{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    do_add(Storeage#guild_store{free_pos = lists:seq(1, Volume)}, Item, BackItem); 
do_add(#guild_store{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
do_add(Storeage = #guild_store{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) -> 
    I = Item#item{id = Id, pos = P}, 
    {ok, Storeage#guild_store{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]}.

%% 堆叠一个物品到背包
do_add_overlap(Bag = #bag{items = Items}, Item, BackItem) ->
    case overlap_item(Item, Items) of
        false -> false;
        {ok, NewItem=#item{id=Id}} ->
            NewItems = lists:keyreplace(Id, #item.id, Items, NewItem),
            BackItem1 = lists:keydelete(Id, #item.id, BackItem),
            {ok, Bag#bag{items = NewItems}, [NewItem|BackItem1]}
    end.

%% 找一个可推迭的物品，并返回推迭后的新物品
%% overlap_item
overlap_item(_Item, []) -> false;
overlap_item(StackItem=#item{base_id=BaseId, quantity=Num, bind = Bind}, [Item=#item{base_id=BaseId1,quantity=Num1, bind = Bind1}| T]) ->
    case BaseId =:= BaseId1 andalso Bind =:= Bind1 of
        false ->
            overlap_item(StackItem, T);
        true ->
            case item_data:get(BaseId) of
                {ok,#item_base{overlap=OverLap}} when Num+Num1 =< OverLap ->
                    {ok, Item#item{quantity=Num+Num1}};
                _ ->
                    overlap_item(StackItem, T)
            end
    end.

add_to_new_pos(Bag = #bag{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) -> 
    I = Item#item{id = Id, pos = P}, 
    {ok, Bag#bag{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]}.


%% @spec make_and_add_fresh(BaseId, Bind, Quantity, Role) -> {ok, NewRole} | {make_error, Reason} | {add_error, Reason} 
%% BaseId = integer() 
%% Bind = 0 | 1  
%% Quantity = integer() 
%% Role = #role{} 
%% @doc  产生物品,并且添加,根据BaseId判断属于背包还是任务背包 
make_and_add_fresh(BaseId, Bind, Quantity, Role) -> 
    case item:make(BaseId, Bind, Quantity) of 
        {ok, [Item | T]} -> 

            % {NPet, NItem} = 
            %     case BaseId div 1000 =:= 107 andalso is_record(Pet, pet) of %%判断是宠物装备且已经有了宠物 
            %         true ->
            %             check_advanced_eqm(Pet, Item);
            %         false -> {Pet, Item}
            %     end,

            {NRole, NItem} = deal_pet_eqm(Role, Item),

%           case Item#item.type =:= ?item_task of 
%                false -> %% 非任务物品直接产生在背包  
            case add(bag, NRole, [NItem | T]) of 
                false -> {add_error, ?L(<<"背包已满">>)}; 
                {ok, NewBag} ->
                    % NR = Role#role{bag = NewBag, pet = PetBag#pet_bag{active = NPet}},
                    NR = NRole#role{bag = NewBag},
                    NRole1 = medal:listener(item, NR, {BaseId, Quantity}),
                    {ok, NRole1, [NItem | T]} 
            end; 
%               true -> %% 任务物品产生在任务包 
%                   case add(task_bag, Role, [Item | T]) of
%                       false -> {add_error, ?L(<<"任务背包已满">>)};
%                       {ok, NewTaskBag} -> {ok, Role#role{task_bag = NewTaskBag}, [Item | T]} 
%                   end
%           end; 
        false -> {make_error, ?L(<<"物品数据不合法">>)} 
    end. 

deal_pet_eqm(Role = #role{pet = PetBag = #pet_bag{active = Pet}}, Item = #item{base_id = BaseId}) ->
    {NPet, NItem} = 
        case BaseId div 1000 =:= 107 andalso is_record(Pet, pet) of %%判断是宠物装备且已经有了宠物 
            true ->
                check_advanced_eqm(Pet, Item);
            false -> {Pet, Item}
        end,
    {Role#role{pet = PetBag#pet_bag{active = NPet}}, NItem}.


 check_advanced_eqm(Pet = #pet{eqm = Eqm}, Item = #item{base_id = BaseId, special = Special}) ->
    case Eqm of 
        [] -> {Pet, Item};
        _ ->
            % L1 = [I||I = #item{base_id = Base_Id} <- Eqm, BaseId div 100 =:= Base_Id div 100 andalso BaseId rem 10 rem 4 =:= Base_Id rem 10 rem 4],
            L1 = [I||I = #item{base_id = Base_Id} <- Eqm, BaseId div 100 =:= Base_Id div 100],
            case erlang:length(L1) > 0 of 
                true ->
                    [Item_Old = #item{special = Special_Old}|_] = L1,
                    {Fight_Old, Item_Old1} = 
                        case lists:keyfind(?special_eqm_point, 1, Special_Old) of 
                            false ->
                                Eqm_Fight_Old = pet_api:calc_eqm_fight_capacity(Item_Old),
                                {Eqm_Fight_Old, Item_Old#item{special = [{?special_eqm_point, Eqm_Fight_Old}] ++ Special_Old}};
                            {_, Power1} ->
                                {Power1, Item_Old}
                        end,
                    {Fight_New, Item_New = #item{special = Special2}} = 
                        case lists:keyfind(?special_eqm_point, 1, Special) of 
                            false ->
                                Eqm_Fight_New = pet_api:calc_eqm_fight_capacity(Item),
                                {Eqm_Fight_New, Item#item{special = [{?special_eqm_point, Eqm_Fight_New}] ++ Special}};
                            {_, Power2} ->
                                {Power2, Item}
                        end,
                    Item_New2 = 
                        case Fight_New > Fight_Old of 
                            true ->
                                Item_New#item{special = [{?special_eqm_advance, 1}] ++ Special2};
                            false ->
                                Item_New
                        end,
                    NEqm = lists:keyreplace(Item_Old#item.base_id, #item.base_id, Eqm, Item_Old1),
                    {Pet#pet{eqm = NEqm}, Item_New2};
                false ->
                    {Pet, Item}
            end
    end.



%% 添加物品不刷新客户端 
%% @spec add_no_refresh(Storage, Items) -> false | {ok, NewStorage} 
%% Storage = #bag{} | #storage{} 存储空间 
%% Items = [#item{} | ...]  物品数据 
add_no_refresh(Storage, Items) -> 
    add_no_refresh(Storage, Items, []). 

add_no_refresh(Storage, [], BackItem) -> {ok, Storage, BackItem}; 
add_no_refresh(Storage, [H | T], BackItem) -> 
    case do_add_no_refresh(Storage, H, BackItem) of 
        false -> false; 
        {ok, Ns, NewBack} -> add_no_refresh(Ns, T, NewBack) 
    end. 

%% 处理背包 
do_add_no_refresh(Bag = #bag{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    PosList = lists:seq(1, Volume), 
    do_add(Bag#bag{free_pos = PosList}, Item, BackItem); 
do_add_no_refresh(#bag{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
%% 旧代码
%%do_add_no_refresh(Bag = #bag{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) ->
    %%I = Item#item{id = Id, pos = P}, 
    %%{ok, Bag#bag{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]};
do_add_no_refresh(Bag = #bag{}, Item, BackItem) ->
    do_add(Bag, Item, BackItem);

do_add_no_refresh(TaskBag = #task_bag{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    PosList = lists:seq(1, Volume), 
    do_add(TaskBag#task_bag{free_pos = PosList}, Item, BackItem); 
do_add_no_refresh(#task_bag{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
do_add_no_refresh(TaskBag = #task_bag{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) -> 
    I = Item#item{id = Id, pos = P}, 
    {ok, TaskBag#task_bag{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]};

do_add_no_refresh(Casino = #casino{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    PosList = lists:seq(1, Volume), 
    do_add(Casino#casino{free_pos = PosList}, Item, BackItem); 
do_add_no_refresh(#casino{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
do_add_no_refresh(Casino = #casino{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) -> 
    I = Item#item{id = Id, pos = P}, 
    {ok, Casino#casino{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]};

do_add_no_refresh(Store = #super_boss_store{volume = Volume, free_pos = undefined}, Item, BackItem) -> 
    %% 初始化可用空间 
    PosList = lists:seq(1, Volume), 
    do_add(Store#super_boss_store{free_pos = PosList}, Item, BackItem); 
do_add_no_refresh(#super_boss_store{free_pos = []}, _Item, _BackItem) -> false; %% 空间不足 
do_add_no_refresh(Store = #super_boss_store{next_id = Id, free_pos = [P | FreePos], items = Items}, Item, BackItem) -> 
    I = Item#item{id = Id, pos = P}, 
    {ok, Store#super_boss_store{next_id = Id + 1, free_pos = FreePos, items = [I | Items]}, [I | BackItem]}. 

%% 清掉背包某类型物品不刷新
%% @spec clean_no_fresh(Storage, BaseId) -> false | {ok, NewStorage} 
%% Storage = #bag{} | #task_bag{} 存储空间 
%% BaseId = integer() 物品类型id
clean_no_fresh(Bag = #task_bag{free_pos = PosList, items = Items}, BaseId) ->
    {NewPosList, NewItems} = do_clean_no_fresh(Items, BaseId, PosList, []),
    Bag#task_bag{free_pos = NewPosList, items = NewItems};
clean_no_fresh(Bag = #bag{free_pos = PosList, items = Items}, BaseId) ->
    {NewPosList, NewItems} = do_clean_no_fresh(Items, BaseId, PosList, []),
    Bag#bag{free_pos = NewPosList, items = NewItems};
clean_no_fresh(_, _) ->
    false.

do_clean_no_fresh([], _, Pos, Items) ->
    {lists:sort(Pos), Items};
do_clean_no_fresh([#item{base_id = BaseId, pos = Pos} | T], BaseId, PosList, Items) ->
    do_clean_no_fresh(T, BaseId, [Pos | PosList], Items);
do_clean_no_fresh([I | T], BaseId, PosList, Items) ->
    do_clean_no_fresh(T, BaseId, PosList, [I | Items]).


%% 同时使用多个物品 
%% @spec use(StorageType, Role, Items) -> {ok, NewRole} | {false, Reason} 
%% StorageType = bag | store 背包或仓库 
%% Role = #role{} 角色数据 
%% Items = [{Baseid, Num} | ...] 待删除的物品 
%%      BaseId = integer() 物品基础ID 
%%      Num = integer() 删除数量 
%% NewRole =  新的角色数据 
%% Reason =  使用失败原因 
use(_StorageType, Role, []) -> {ok, Role}; 
use(StorageType, Role, [{BaseId, Num} | T]) -> 
    case use(StorageType, Role, BaseId, Num) of 
        {false, Reason} -> {false, Reason}; 
        {ok, NewRole} -> use(StorageType, NewRole, T) 
    end. 

%% 使用N个指定类型的物品 
%% @spec use(StorageType, Role, BaseId, Num) -> {false, Reason} | {ok, NewRole} 
%% StorageType = bag | store 背包或仓库 
%% Role = #role{} 角色数据 
%% BaseId = integer() 物品基础ID 
%% Num = integer() 删除数量 
%% NewRole =  新的角色数据 
%% Reason =  使用失败原因 
use(bag, Role = #role{}, BaseId, Num) -> 
    case do_use(Role, BaseId, [], Num) of 
        {false, Reason} -> {false, Reason}; 
        {ok, NewRole = #role{bag = NewBag = #bag{free_pos = FreePos}}, Pos} -> 
            P = lists:sort(FreePos ++ Pos), %% 重新排序可用位置 
            {ok, NewRole#role{bag = NewBag#bag{free_pos = P}}} 
    end. 

%% 同时使用多个物品 
%% @spec use_id(StorageType, Role, Items) -> {ok, NewRole} | {false, Reason} 
%% StorageType = bag | store 背包或仓库 
%% Role = #role{} 角色数据 
%% Items = [{Id, Num} | ...] 待删除的物品 
%%      Id = integer() 物品ID 
%%      Num = integer() 删除数量 
%% NewRole =  新的角色数据 
%% Reason =  使用失败原因 
use_id(_StorageType, Role, []) -> {ok, Role}; 
use_id(StorageType, Role, [{Id, Num} | T]) -> 
    case use_id(StorageType, Role, Id, Num) of 
        {false, Reason} -> {false, Reason}; 
        {ok, NewRole} -> use_id(StorageType, NewRole, T) 
    end. 

%% 使用N个指定ID的物品 
%% @spec use_id(StorageType, Role, Id, Num) -> {false, Reason} | {ok, NewRole} 
%% StorageType = bag | store 背包或仓库 
%% Role = #role{} 角色数据 
%% Id = integer() 物品ID 
%% Num = integer() 删除数量 
%% NewRole =  新的角色数据 
%% Reason =  使用失败原因 
use_id(bag, Role = #role{}, Id, Num) -> 
    role:send_buff_begin(),
    case do_use_by_id(Role, Id, [], Num) of 
        {false, Reason} -> 
            role:send_buff_clean(),
            {false, Reason}; 
        {ok, NewRole = #role{bag = NewBag = #bag{free_pos = FreePos}}, Pos} -> 
            P = lists:sort(FreePos ++ Pos), %% 重新排序可用位置
            role:send_buff_flush(),
            {ok, NewRole#role{bag = NewBag#bag{free_pos = P}}} 
    end. 

%% 删除多个指定类型的物品 
%% @spec del(Storage, Items) -> {ok, NewStorage, DelList, FreshList} | false 
%% Storage = NewStorage = #bag{} | #store{} 背包或仓库 
%% Items = [{BaseId, Num} | ...] 待删除的物品 
%%      BaseId = integer() 物品基础ID 
%%      Num = all | integer() 删除数量，all表示全部删除
del(Storage, Items) ->
    del(Storage, Items, [], []).

del(Storage, [], DelList, FreshList) -> {ok, Storage, DelList, FreshList}; 
del(Storage, [{BaseId, Num} | T], DelList, FreshList) -> 
    case del(Storage, BaseId, Num, DelList, FreshList) of 
        false -> false; 
        {ok, Ni, NewDel, NewFresh} -> del(Ni, T, NewDel, NewFresh) 
    end. 

%% 删除N个指定类型的物品 
%% @spec del(Storage, BaseId, Num) -> {ok, NewStorage} | false 
%% Storage = NewStorage = #bag{} | #store{} 背包或仓库 
%% BaseId = integer() 物品基础ID 
%% Num = all | integer() 删除数量，all表示全部删除 

del(Bag, _BaseId, Num, DelList, FreshList) when Num =:= 0->
    {ok, Bag, DelList, FreshList};
del(Bag = #bag{free_pos = FreePos, items = Items}, BaseId, Num, DelList, FreshList) when Num > 0-> 
    case do_del(Items, [], BaseId, [], Num, DelList, FreshList) of 
        false -> false; 
        {ok, NewItems, Pos, NewDel, NewFresh} -> 
            P = lists:sort(FreePos ++ Pos), %% 重新排序可用位置 
            {ok, Bag#bag{free_pos = P, items = NewItems}, NewDel, NewFresh} 
    end; 
del(Store = #store{free_pos = FreePos, items = Items}, BaseId, Num, DelList, FreshList) when Num > 0-> 
    case do_del(Items, [], BaseId, [], Num, DelList, FreshList) of 
        false -> false; 
        {ok, NewItems, Pos, NewDel, NewFresh} -> 
            P = lists:sort(FreePos ++ Pos), %% 重新排序可用位置 
            {ok, Store#store{free_pos = P, items = NewItems}, NewDel, NewFresh} 
    end;
del(TaskBag = #task_bag{free_pos = FreePos, items = Items}, BaseId, Num, DelList, FreshList) when Num > 0 ->
    case do_del(Items, [], BaseId, [], Num, DelList, FreshList) of
        false -> false;
        {ok, NewItems, Pos, NewDel, NewFresh} ->
            P = lists:sort(FreePos ++ Pos),
            {ok, TaskBag#task_bag{free_pos = P, items = NewItems}, NewDel, NewFresh}
    end;
del(Collect = #collect{free_pos = FreePos, items = Items}, BaseId, Num, DelList, FreshList) when Num > 0 ->
    case do_del(Items, [], BaseId, [], Num, DelList, FreshList) of
        false -> false;
        {ok, NewItems, Pos, NewDel, NewFresh} ->
            P = lists:sort(FreePos ++ Pos),
            {ok, Collect#collect{free_pos = P, items = NewItems}, NewDel, NewFresh}
    end;
del(Casino = #casino{free_pos = FreePos, items = Items}, BaseId, Num, DelList, FreshList) when Num > 0 ->
    case do_del(Items, [], BaseId, [], Num, DelList, FreshList) of
        false -> false;
        {ok, NewItems, Pos, NewDel, NewFresh} ->
            P = lists:sort(FreePos ++ Pos),
            {ok, Casino#casino{free_pos = P, items = NewItems}, NewDel, NewFresh}
    end;
del(Store = #super_boss_store{free_pos = FreePos, items = Items}, BaseId, Num, DelList, FreshList) when Num > 0 ->
    case do_del(Items, [], BaseId, [], Num, DelList, FreshList) of
        false -> false;
        {ok, NewItems, Pos, NewDel, NewFresh} ->
            P = lists:sort(FreePos ++ Pos),
            {ok, Store#super_boss_store{free_pos = P, items = NewItems}, NewDel, NewFresh}
    end;
del(_Storage, _BaseId, _Num, _DelList, _FreshList) ->
    false.

%% 删除指定位置的多个物品 
%% @spec del_pos(Storage, PosInfo) -> {ok, NewStorage} | false 
%% Storage = NewStorage = #bag{} | #store{} 背包或仓库 
%% PosInfo = [{Pos,Num} | ...] 待删除的物品 
%%        Pos = integer() 物品的位置 
%%        Num = integer() 删除数量 
del_pos(Storage, []) -> {ok, Storage}; 
del_pos(Storage, [{Pos, Num} | T]) -> 
    case del_pos(Storage, Pos, Num) of 
        {false, Reason} -> {false, Reason}; 
        {ok, Ni} -> del_pos(Ni, T) 
    end. 

%% 删除指定位置的N个物品 
%% @spec del_pos(Storage, Pos, Num) -> {ok, NewStorage} | false 
%% Storage = NewStorage = #bag{} | #store{} 背包或仓库 
%% Pos = integer() 物品的pos 
%% Num = integer() 删除数量 
del_pos(Bag = #bag{free_pos = FreePos, items = Items}, Pos, Num) when Num > 0 -> 
    case do_pos_del(Items, [], Pos, [], Num) of 
        {false, Reason} -> {false, Reason}; 
        {ok, NewItems, NewPos} -> 
            P = lists:sort(NewPos ++ FreePos), 
            {ok, Bag#bag{free_pos = P, items = NewItems}} 
    end; 
del_pos(Store = #store{free_pos = FreePos, items = Items}, Pos, Num) when Num > 0-> 
    case do_pos_del(Items, [], Pos, [], Num) of 
        {false, Reason} -> {false, Reason}; 
        {ok, NewItems, NewPos} -> 
            P = lists:sort(NewPos ++ FreePos), 
            {ok, Store#store{free_pos = P, items = NewItems}} 
    end;
del_pos(_Storage, _Pos, _Num) -> {false, <<>>}.

%% 删除指定ID的多个物品 
%% @spec del_item_by_id(Storage, ItemIdInfo, CheckStatus) -> {ok, NewStorage} | {false, Reason} 
%% Storage = #bag{} | #store{} 
%% ItemIdInfo = [{ItemId, Num} | ...] 待删除的物品列表 
%% CheckStatus = true | false  检测锁定 | 不检测锁定 
del_item_by_id(Storage, Items, CheckStatus) ->
    del_item_by_id(Storage, Items, CheckStatus, [], []).
del_item_by_id(Storage, [], _CheckStatus, Del, Fresh) -> {ok, Storage, Del, Fresh}; 
del_item_by_id(Storage, [{ItemId, Num} | T], CheckStatus, Del, Fresh) -> 
    case del_item_by_id(Storage, ItemId, Num, CheckStatus, Del, Fresh) of 
        {false, Reason} -> {false, Reason}; 
        {ok, Ni, NewDel, NewFresh} -> del_item_by_id(Ni, T, CheckStatus, NewDel, NewFresh) 
    end. 

%% 删除指定ID多个物品 
%% @spec del_item_by_id(Storage, ItemId, Num, CheckStatus) -> {ok, NewStorage} | {false, Reason} 
%% Storage = #bag{} | #store{} 
del_item_by_id(Bag = #bag{free_pos = FreePos, items = Items}, ItemId, Num, CheckStatus, Del, Fresh) when Num > 0 -> 
    case do_del_by_id(Items, [], ItemId, [], Num, CheckStatus, Del, Fresh) of 
        {false, Reason} -> {false, Reason}; 
        {ok, NewItems, NewPos, NewDel, NewFresh} -> 
            P = lists:sort(NewPos ++ FreePos), 
            {ok, Bag#bag{free_pos = P, items = NewItems}, NewDel, NewFresh} 
    end; 
del_item_by_id(Store = #store{free_pos = FreePos, items = Items}, ItemId, Num, CheckStatus, Del, Fresh) when Num > 0 -> 
    case do_del_by_id(Items, [], ItemId, [], Num, CheckStatus, Del, Fresh) of 
        {false, Reason} -> {false, Reason}; 
        {ok, NewItems, NewPos, NewDel, NewFresh} -> 
            P = lists:sort(NewPos ++ FreePos), 
            {ok, Store#store{free_pos = P, items = NewItems}, NewDel, NewFresh} 
    end;
del_item_by_id(Casino = #casino{free_pos = FreePos, items = Items}, ItemId, Num, CheckStatus, Del, Fresh) when Num > 0 -> 
    case do_del_by_id(Items, [], ItemId, [], Num, CheckStatus, Del, Fresh) of 
        {false, Reason} -> {false, Reason}; 
        {ok, NewItems, NewPos, NewDel, NewFresh} -> 
            P = lists:sort(NewPos ++ FreePos), 
            {ok, Casino#casino{free_pos = P, items = NewItems}, NewDel, NewFresh} 
    end;
del_item_by_id(Store = #super_boss_store{free_pos = FreePos, items = Items}, ItemId, Num, CheckStatus, Del, Fresh) when Num > 0 -> 
    case do_del_by_id(Items, [], ItemId, [], Num, CheckStatus, Del, Fresh) of 
        {false, Reason} -> {false, Reason}; 
        {ok, NewItems, NewPos, NewDel, NewFresh} -> 
            P = lists:sort(NewPos ++ FreePos), 
            {ok, Store#super_boss_store{free_pos = P, items = NewItems}, NewDel, NewFresh} 
    end;
del_item_by_id(_Storage, _, _, _, _, _) -> {false, <<>>}.

%% 判断pos的合法性 
check_pos(#bag{volume = Volume}, Pos1, Pos2) -> 
    Pos1 >= 1 andalso Pos1 =< Volume andalso Pos2 >= 1 andalso Pos2 =< Volume; 
check_pos(#store{volume = Volume}, Pos1, Pos2) -> 
    Pos1 >= 1 andalso Pos1 =< Volume andalso Pos2 >= 1 andalso Pos2 =< Volume;
check_pos(#casino{volume = Volume}, Pos1, Pos2) -> 
    Pos1 >= 1 andalso Pos1 =< Volume andalso Pos2 >= 1 andalso Pos2 =< Volume;
check_pos(#super_boss_store{volume = Volume}, Pos1, Pos2) -> 
    Pos1 >= 1 andalso Pos1 =< Volume andalso Pos2 >= 1 andalso Pos2 =< Volume. 
check_pos(#bag{volume = Volume1}, Pos1, #store{volume = Volume2}, Pos2) -> 
    Pos1 >= 1 andalso Pos1 =< Volume1 andalso Pos2 >=1 andalso Pos2 =< Volume2; 
check_pos(#store{volume = Volume1}, Pos1, #bag{volume = Volume2}, Pos2) -> 
    Pos1 >= 1 andalso Pos1 =< Volume1 andalso Pos2 >=1 andalso Pos2 =< Volume2;
check_pos(#casino{volume = Volume1}, Pos1, #bag{volume = Volume2}, Pos2) -> 
    Pos1 >= 1 andalso Pos1 =< Volume1 andalso Pos2 >=1 andalso Pos2 =< Volume2;
check_pos(#super_boss_store{volume = Volume1}, Pos1, #bag{volume = Volume2}, Pos2) -> 
    Pos1 >= 1 andalso Pos1 =< Volume1 andalso Pos2 >=1 andalso Pos2 =< Volume2. 

%% 拆分同一存储单元的物品
%% @spec split_item(Atom, Role, Item, Num) -> NewRole 
%% Atom = bag | store
split_item(bag, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Items, next_id = NextId, free_pos = FreePos}}, Item = #item{quantity = Q, pos = Pos}, Num) when Q >= Num andalso FreePos =/= [] ->
    [NewPos | P] = FreePos,
    NewAddItem = Item#item{id = NextId, quantity = Num, pos = NewPos},
    NewItem = Item#item{quantity = Q - Num},
    {NewItems, NewFreePos} = case Q =:= Num of
        true ->
            {[NewAddItem | lists:keydelete(Item#item.id, #item.id, Items)], P ++ [Pos]};
        false ->
            {[NewAddItem | lists:keyreplace(Item#item.id, #item.id, Items, NewItem)], P}
    end,
    case Q =:= Num of
        true -> storage_api:del_item_info(ConnPid, [{?storage_bag, NewItem}]);
        false -> storage_api:refresh_single(ConnPid, {?storage_bag, NewItem})
    end,
    storage_api:add_item_info(ConnPid, [{?storage_bag, NewAddItem}]),
    {ok, Role#role{bag = Bag#bag{items = NewItems, next_id = NextId + 1, free_pos = lists:sort(NewFreePos)}}};

split_item(store, Role = #role{link = #link{conn_pid = ConnPid}, store = Store = #store{items = Items, next_id = NextId, free_pos = FreePos}}, Item = #item{quantity = Q, pos = Pos}, Num) when Q >= Num andalso FreePos =/= [] ->
    [NewPos | P] = FreePos,
    NewAddItem = Item#item{id = NextId, quantity = Num, pos = NewPos},
    NewItem = Item#item{quantity = Q - Num},
    {NewItems, NewFreePos} = case Q =:= Num of
        true ->
            {[NewAddItem | lists:keydelete(Item#item.id, #item.id, Items)], P ++ [Pos]};
        false ->
            {[NewAddItem | lists:keyreplace(Item#item.id, #item.id, Items, NewItem)], P}
    end,
    case Q =:= Num of
        true -> storage_api:del_item_info(ConnPid, [{?storage_store, NewItem}]);
        false -> storage_api:refresh_single(ConnPid, {?storage_store, NewItem})
    end,
    storage_api:add_item_info(ConnPid, [{?storage_store, NewAddItem}]),
    {ok, Role#role{store = Store#store{items = NewItems, next_id = NextId + 1, free_pos = lists:sort(NewFreePos)}}};

split_item(_, _, _, _) -> {false, <<>>}.

%% 根据位置交换同一存储单元中的两个物品 
%% @spec swap_by_pos_same(Atom, Role, Id, Pos2) -> {ok, NewRole} | {false, Reason} 
%% Storage = bag | store
%% Pos1 = Pos2 = integer() 物品的位置
swap_by_pos_same(StorageType, Role = #role{bag = Bag, store = Store, casino = Casino, super_boss_store = SuperBoss}, Id, Pos2) ->
    {Storage, Items} = case StorageType of
        bag -> {Bag, Bag#bag.items};
        store -> {Store, Store#store.items};
        casino -> {Casino, Casino#casino.items};
        super_boss_store -> {SuperBoss, SuperBoss#super_boss_store.items}
    end,
    case find(Items, #item.id, Id) of
        {false, _Reason} -> {false, <<>>};
        {ok, Sitem = #item{pos = Pos1, status = ?lock_release}}  ->
            case check_pos(Storage, Pos1, Pos2) of
                true ->
                    case find(Items, #item.pos, Pos2) of
                        {false, _R2} -> swap_by_pos_same(StorageType, move, Pos1, Sitem, Pos2, Sitem, Role);
                        {ok, Titem = #item{status = ?lock_release}} ->
                            swap_by_pos_same(StorageType, swap, Pos1, Sitem, Pos2, Titem, Role);
                        _ -> {false, ?L(<<"目标位置锁定,不能移动">>)}
                    end;
                false -> {false, ?L(<<"目标位置未开通">>)}
            end;
        _ -> {false, ?L(<<"物品锁定,不能移动">>)}
    end.

swap_by_pos_same(bag, Mode, Pos1, Item1, Pos2, Item2, Role = #role{bag = Bag = #bag{items = Items}, link = #link{conn_pid = ConnPid}}) when Pos1 =/= Pos2->
    case Mode of
        move ->
            {ok, NewBag, _NewItem} = storage_api:fresh_item(Item1, Item1#item{pos = Pos2}, Bag, ConnPid),
            {ok, Role#role{bag = NewBag}};
        swap ->
            case check_can_stack(Item1, Item2) of 
                false -> 
                    NewItems = do_swap(Item1, Item2, Item1#item{pos = Pos2}, Item2#item{pos = Pos1},
                        ?storage_bag, Items, ConnPid),
                    {ok, Role#role{bag = Bag#bag{items = NewItems}}};
                {true, OverLap} -> 
                    case stacking_item(Bag, OverLap, Item1, Item2, ConnPid) of
                        {false, R} -> {false, R};
                        {ok, NewBag} -> {ok, Role#role{bag = NewBag}}
                    end;
                {false, R1} -> {false, R1}
            end 
    end; 

swap_by_pos_same(store, Mode, Pos1, Item1, Pos2, Item2, Role = #role{store = Store = #store{items = Items}, link = #link{conn_pid = ConnPid}}) when Pos1 =/= Pos2-> 
    case Mode of
        move ->
            {ok, NewStore, _NewItem} = storage_api:fresh_item(Item1, Item1#item{pos = Pos2}, Store, ConnPid),
            {ok, Role#role{store = NewStore}};
        swap ->
            case check_can_stack(Item1, Item2) of 
                false -> 
                    NewItems = do_swap(Item1, Item2, Item1#item{pos = Pos2}, Item2#item{pos = Pos1},
                        ?storage_store, Items, ConnPid),
                    {ok, Role#role{store = Store#store{items = NewItems}}};
                {true, OverLap} -> 
                    case stacking_item(Store, OverLap, Item1, Item2, ConnPid) of
                        {false, R} -> {false, R};
                        {ok, NewStore} -> {ok, Role#role{store = NewStore}}
                    end;
                {false, R1} -> {false, R1}
            end 
    end; 

swap_by_pos_same(casino, Mode, Pos1, Item1, Pos2, Item2, Role = #role{casino = Store = #casino{items = Items}, link = #link{conn_pid = ConnPid}}) when Pos1 =/= Pos2-> 
    case Mode of
        move ->
            {ok, NewStore, _NewItem} = storage_api:fresh_item(Item1, Item1#item{pos = Pos2}, Store, ConnPid),
            {ok, Role#role{casino = NewStore}};
        swap ->
            case check_can_stack(Item1, Item2) of 
                false -> 
                    NewItems = do_swap(Item1, Item2, Item1#item{pos = Pos2}, Item2#item{pos = Pos1},
                        ?storage_casino, Items, ConnPid),
                    {ok, Role#role{casino = Store#casino{items = NewItems}}};
                {true, OverLap} -> 
                    case stacking_item(Store, OverLap, Item1, Item2, ConnPid) of
                        {false, R} -> {false, R};
                        {ok, NewStore} -> {ok, Role#role{casino = NewStore}}
                    end;
                {false, R1} -> {false, R1}
            end 
    end; 

swap_by_pos_same(super_boss_store, Mode, Pos1, Item1, Pos2, Item2, Role = #role{super_boss_store = Store = #super_boss_store{items = Items}, link = #link{conn_pid = ConnPid}}) when Pos1 =/= Pos2-> 
    case Mode of
        move ->
            {ok, NewStore, _NewItem} = storage_api:fresh_item(Item1, Item1#item{pos = Pos2}, Store, ConnPid),
            {ok, Role#role{super_boss_store = NewStore}};
        swap ->
            case check_can_stack(Item1, Item2) of 
                false -> 
                    NewItems = do_swap(Item1, Item2, Item1#item{pos = Pos2}, Item2#item{pos = Pos1},
                        ?storage_super_boss, Items, ConnPid),
                    {ok, Role#role{super_boss_store = Store#super_boss_store{items = NewItems}}};
                {true, OverLap} -> 
                    case stacking_item(Store, OverLap, Item1, Item2, ConnPid) of
                        {false, R} -> {false, R};
                        {ok, NewStore} -> {ok, Role#role{super_boss_store = NewStore}}
                    end;
                {false, R1} -> {false, R1}
            end 
    end; 

swap_by_pos_same(_, _Mode, _Pos1, _Item1, _Pos2, _Item2, Role) -> {ok, Role}.

%% 判断是否为可堆叠物品,最大堆叠数为1的 也属于非同类 
%% 同类返回true,否则返回false 
check_same_item(#item{base_id = BaseId1, bind = Bind1}, #item{base_id = BaseId2, bind = Bind2}) -> 
    BaseId1 =:= BaseId2 andalso Bind1 =:= Bind2. 
check_can_stack(Item1 = #item{base_id = BaseId1, bind = Bind1}, Item2 = #item{base_id = BaseId2, bind = Bind2}) -> 
    case BaseId1 =:= BaseId2 andalso Bind1 =:= Bind2 of
        false -> false;
        true ->
            case item_data:get(BaseId1) of
                {ok, #item_base{overlap = OverLap}} ->
                    case (Item1#item.quantity =:= OverLap andalso Item2#item.quantity =/= OverLap) orelse OverLap =:= 1 of
                        true -> false;
                        false -> {true, OverLap}
                    end;
                _ -> {false, ?L(<<"不存在的物品">>)}
            end
    end.

do_swap(OldItem1, OldItem2, NewItem1, NewItem2, StorageType, Items, ConnPid) ->
    Items1 = lists:keyreplace(OldItem1#item.id, #item.id, Items, NewItem1),
    NewItems = lists:keyreplace(OldItem2#item.id, #item.id, Items1, NewItem2),
    storage_api:refresh_client_item(refresh, ConnPid, [{StorageType, [NewItem1, NewItem2]}]),
    NewItems.
do_stack(OldItem1, OldItem2, NewItem2, StorageType, Items, ConnPid) ->
    Items1 = lists:keydelete(OldItem1#item.id, #item.id, Items),
    NewItems = lists:keyreplace(OldItem2#item.id, #item.id, Items1, NewItem2),
    storage_api:refresh_client_item(del, ConnPid, [{StorageType, [OldItem1]}]),
    storage_api:refresh_client_item(refresh, ConnPid, [{StorageType, [NewItem2]}]),
    NewItems.

%% 处理堆叠物品 
%% @spec stacking_item(Storage, Item1, Item2) -> {ok, NewStorage} | {false, Reason} 
%% Item1堆叠到Item2, 
%% Bag = #bag{..} 
%% Item1 = Item2 = #item{...}
stacking_item(Storage, OverLap, Item1 = #item{quantity = Num1, pos = Pos1}, Item2 = #item{quantity = Num2}, ConnPid) -> 
    if
        Num2 =:= OverLap -> {false, ?L(<<"目标堆叠数满">>)}; 
        Num1 + Num2 =< OverLap -> %% 2堆变1堆处理 
            NewItem2 = Item2#item{quantity = Num1 + Num2},
            if
                is_record(Storage, bag) ->
                    NewItems = do_stack(Item1, Item2, NewItem2, ?storage_bag, Storage#bag.items, ConnPid),
                    {ok, Storage#bag{items = NewItems, free_pos = [Pos1 | Storage#bag.free_pos]}};
                is_record(Storage, store) -> 
                    NewItems = do_stack(Item1, Item2, NewItem2, ?storage_store, Storage#store.items, ConnPid),
                    {ok, Storage#store{items = NewItems, free_pos = [Pos1 | Storage#store.free_pos]}};
                is_record(Storage, casino) -> 
                    NewItems = do_stack(Item1, Item2, NewItem2, ?storage_casino, Storage#casino.items, ConnPid),
                    {ok, Storage#casino{items = NewItems, free_pos = [Pos1 | Storage#casino.free_pos]}};
                true -> 
                    NewItems = do_stack(Item1, Item2, NewItem2, ?storage_super_boss, Storage#super_boss_store.items, ConnPid),
                    {ok, Storage#super_boss_store{items = NewItems, free_pos = [Pos1 | Storage#super_boss_store.free_pos]}}
            end;
        Num1 + Num2 > OverLap -> 
            NewItem1 = Item1#item{quantity = Num1 + Num2 - OverLap},
            NewItem2 = Item2#item{quantity = OverLap},
            if
                is_record(Storage, bag) ->
                    NewItems = do_swap(Item1, Item2, NewItem1, NewItem2, ?storage_bag, Storage#bag.items, ConnPid),
                    {ok, Storage#bag{items = NewItems}};
                is_record(Storage, store) ->
                    NewItems = do_swap(Item1, Item2, NewItem1, NewItem2, ?storage_store, Storage#store.items, ConnPid),
                    {ok, Storage#store{items = NewItems}};
                is_record(Storage, casino) ->
                    NewItems = do_swap(Item1, Item2, NewItem1, NewItem2, ?storage_casino, Storage#casino.items, ConnPid),
                    {ok, Storage#casino{items = NewItems}};
                true ->
                    NewItems = do_swap(Item1, Item2, NewItem1, NewItem2, ?storage_super_boss, Storage#super_boss_store.items, ConnPid),
                    {ok, Storage#super_boss_store{items = NewItems}}
            end
    end.

%% 从背包穿戴装备 
move_bag_eqm(Id, Tpos, Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm, bag = Bag = #bag{items = Items, free_pos = FreePos}}) -> 
    case find(Bag#bag.items, #item.id, Id) of
        {false , _Reason} -> {false, <<>>};
        {ok, Sitem = #item{type = ?item_shi_zhuang, status = ?lock_release}} ->
            case item:put_dress(Sitem, Role) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole} -> {ok, NewRole, Sitem}
            end;
        {ok, Sitem = #item{type = ?item_weapon_dress, status = ?lock_release}} ->
            case item:put_dress(Sitem, Role) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole} -> {ok, NewRole, Sitem}
            end;
        {ok, Sitem = #item{type = ?item_footprint, status = ?lock_release}} ->
            case item:put_dress(Sitem, Role) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole} -> {ok, NewRole, Sitem}
            end;
        {ok, Sitem = #item{type = ?item_chat_frame, status = ?lock_release}} ->
            case item:put_dress(Sitem, Role) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole} -> {ok, NewRole, Sitem}
            end;
        {ok, Sitem = #item{type = ?item_text_style, status = ?lock_release}} ->
            case item:put_dress(Sitem, Role) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole} -> {ok, NewRole, Sitem}
            end;
        {ok, Sitem = #item{type = ?item_wing, status = ?lock_release}} ->
            case check_fly_and_mount(Role, Sitem) of
                {false, Reason} -> {false, Reason};
                true -> 
                    case wing:put_wing(Role, Sitem) of
                        {false, Reason} -> {false, Reason};
                        {ok, NewRole} -> {ok, NewRole, Sitem}
                    end
            end;
        {ok, Sitem = #item{type = ?item_zuo_qi, status = ?lock_release}} ->
            case mount:put_mount(Sitem, Role) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole} -> {ok, NewRole, Sitem}
            end;
        {ok, Sitem = #item{use_type = 3, pos = Pos1, status = ?lock_release}} ->
            {ok, #item_base{condition = Cond}} = item_data:get(Sitem#item.base_id),
            case eqm:find_eqm_by_id(Eqm, Tpos) of 
                false -> %% 直接穿戴 
                    case {role_cond:check(Cond, Role), eqm:check_swap_eqm(Tpos, eqm:type_to_pos(Sitem#item.type))} of
                        {{false, RCond}, _R} -> {false, RCond#condition.msg}; 
                        {_R, false} -> {false, <<>>};
                        {true, true} -> 
                            NewFreePos = lists:sort([Pos1 | FreePos]),
                            NewBag = Bag#bag{items = lists:keydelete(Sitem#item.id, #item.id, Items),
                                free_pos = NewFreePos},
                            NewPut = Sitem#item{pos = Tpos, id = Tpos}, 
                            PutItem = bind_mount(NewPut),
                            storage_api:del_item_info(ConnPid, [{?storage_bag, Sitem}]),
                            storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem}]),
                            NR = looks:calc(Role#role{eqm = Eqm ++ [PutItem], bag = NewBag}),
                            NR1 = role_api:push_attr(NR),
                            looks:refresh(Role, NR1),
                            {ok, NR1, Sitem}
                    end;
                {ok, Titem} -> %% 考虑替换装备 
                    case check_fly_and_mount(Role, Sitem) of
                        {false, Reason} -> {false, Reason};
                        true ->
                            case {role_cond:check(Cond, Role), eqm:check_swap_eqm(Tpos, eqm:type_to_pos(Sitem#item.type))} of 
                                {{false, RCond}, _R} -> {false, RCond#condition.msg}; 
                                {_R, false} -> {false, <<>>}; 
                                {true, true} -> 
                                    NewPut = Sitem#item{pos = Tpos, id = Tpos},
                                    Getoff = Titem#item{pos = Pos1, id = Sitem#item.id},
                                    PutItem = bind_mount(NewPut),
                                    NewBag = Bag#bag{items = [Getoff |lists:keydelete(Sitem#item.id, #item.id, Items)]},
                                    storage_api:del_item_info(ConnPid, [{?storage_eqm, Titem}, {?storage_bag, Sitem}]),
                                    storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem}, {?storage_bag, Getoff}]),
                                    NR = looks:calc(Role#role{eqm = [PutItem | (Eqm -- [Titem])], bag = NewBag}),
                                    NR1 = role_api:push_attr(eqm:check_suit_lock(NR)),
                                    looks:refresh(Role, NR1),
                                    {ok, NR1, Sitem}
                            end 
                    end
            end;
        _X -> {false, <<>>}
    end.

%% 移动装备物品 
move_eqm(Id, ?storage_eqm, Pos, Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm}) -> 
    case eqm:find_eqm_by_id(Eqm, Id) of 
        false -> {false, ?L(<<"不存在的物品">>)}; 
        {ok, Item} -> 
            case eqm:check_swap_eqm(Id, Pos) of 
                false -> {false, <<>>}; 
                true -> 
                    case eqm:find_eqm_by_id(Eqm, Pos) of 
                        false ->
                            storage_api:del_item_info(ConnPid, [{?storage_eqm, Item}]),
                            storage_api:add_item_info(ConnPid, [{?storage_eqm, Item#item{id = Pos, pos = Pos}}]),
                            {ok, Role#role{eqm = [Item#item{id = Pos, pos = Pos} | Eqm -- [Item]]}};
                        {ok, Item2} ->
                            NewItem1 = Item#item{id = Pos, pos = Pos},
                            NewItem2 = Item2#item{id = Id, pos = Id},
                            storage_api:del_item_info(ConnPid, [{?storage_eqm, Item},{?storage_eqm, Item2}]),
                            storage_api:add_item_info(ConnPid, [{?storage_eqm, NewItem1},{?storage_eqm, NewItem2}]), 
                            NewEqm = [NewItem1, NewItem2 ] ++ (Eqm -- [Item, Item2]),
                            {ok, Role#role{eqm = NewEqm}}
                    end
            end
    end;
move_eqm(Id, ?storage_bag, Pos, Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm, bag = Bag = #bag{free_pos = FreePos, items = Items, next_id = NextId}}) -> 
    case eqm:find_eqm_by_id(Eqm, Id) of 
        false -> {false, ?L(<<"不存在的物品">>)}; 
        {ok, Item = #item{type = Type}} -> 
            case check_fly_and_mount(Role, Item) of
                {false, Msg} -> {false, Msg};
                true ->
                    case find(Bag#bag.items, #item.pos, Pos) of 
                        {false, _Reason} ->  %% 脱装备
                            Getoff = Item#item{pos = Pos, id = NextId},
                            storage_api:del_item_info(ConnPid, [{?storage_eqm, Item}]),
                            storage_api:add_item_info(ConnPid, [{?storage_bag, Getoff}]),
                            NewBag = Bag#bag{items = [Getoff | Items], free_pos = FreePos -- [Pos], next_id = NextId +1},
                            NR = looks:calc(Role#role{eqm = Eqm -- [Item], bag = NewBag}),
                            NR1 = role_api:push_attr(eqm:check_suit_lock(NR)),
                            looks:refresh(Role, NR1),
                            {ok, NR1};
                        {ok, Item2 = #item{base_id = BaseId, type = Type2, pos = Pos}} -> %% 交换装备
                            {ok, #item_base{condition = Cond}} = item_data:get(BaseId), 
                            case {role_cond:check(Cond, Role), Type =:= Type2} of 
                                {{false, _RCond}, _R} -> {false, <<>>}; 
                                {_R, false} -> {false, <<>>};                             
                                {true, true} -> 
                                    NewPut = Item2#item{pos = Id, id = Id},
                                    Getoff = Item#item{pos = Pos, id = NextId},
                                    PutItem = bind_mount(NewPut),
                                    storage_api:del_item_info(ConnPid, [{?storage_bag, Item2}, {?storage_eqm, Item}]),
                                    storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem}, {?storage_bag, Getoff}]),
                                    NewItems = lists:keydelete(Item2#item.id, #item.id, Items),
                                    NewBag = Bag#bag{items = [Getoff | NewItems], next_id = NextId + 1},
                                    NR = looks:calc(Role#role{eqm = [PutItem | (Eqm -- [Item])], bag = NewBag}),
                                    NR1 = role_api:push_attr(eqm:check_suit_lock(NR)),
                                    looks:refresh(Role, NR1),
                                    {ok, NR1}
                            end 
                    end
            end
    end. 

%% @spec find(Items, KeyPos, Key) -> {ok, Item} | {ok, Num, ItemList, Bindlist, Ubindlist} |{false, Reason} 
%% Items = #bag.items 
%% KeyPos = #items.pos | #items.id 
%% Key = integer() 
%% Reason = string() 
%% @doc 根据Pos或者ID查找物品 
find(Items, KeyPos, Key) when KeyPos =:= #item.id orelse KeyPos =:= #item.pos -> 
    case lists:keyfind(Key, KeyPos, Items) of 
        false -> {false, ?L(<<"未发现物品">>)}; 
        Item -> {ok, Item} 
    end;

find(Items, KeyPos, Key) when KeyPos =:= #item.base_id ->
    find(Items, KeyPos, Key, 0, [], [], []).    
find([], _KeyPos, _Key, Num, _ItemList, _BindList, _UbindList) when Num =:= 0 -> {false, ?L(<<"未发现物品">>)};
find([], _KeyPos, _Key, Num, ItemList, BindList, UbindList) when Num =/= 0 -> {ok, Num, ItemList, BindList, UbindList};
find([Item = #item{bind = Bind, quantity = Q, base_id = Bid} | T], _KeyPos, Key, Num, ItemList, BindList, UbindList)
when Bid =:= Key ->
    case Bind =:= 1 of
        true ->  find(T, _KeyPos, Key, Num + Q, [Item | ItemList], [Item | BindList], UbindList);
        false ->  find(T, _KeyPos, Key, Num + Q, [Item | ItemList], BindList, [Item | UbindList])
    end;
find([_Item | T], _KeyPos, Key, Num, ItemList, BindList, UbindList) ->
    find(T, _KeyPos, Key, Num, ItemList, BindList, UbindList).

%% @spec del_base_by_bind_fst(Role, BaseIdInfo) -> {false, Reason} | {ok, NewRole} 
%% @doc 删除baseid的物品Num个, 优先删除Bind列表的物品
%%      使用role_gain删除,带刷新消息,注意事务
%% BaseIdInfo = [{BaseId, DelNum} | ..]
del_base_by_bind_fst(Role, []) -> {ok, Role};
del_base_by_bind_fst(Role, BaseIdInfo) ->
    del_base_by_bind_fst(Role, BaseIdInfo, []).

%%执行Role_gain
del_base_by_bind_fst(Role, [], DelList) ->
    case role_gain:do([#loss{label = item_id, val = DelList}], Role) of
        {false, L} -> {false, L#loss.msg};
        {ok, NewRole} -> {ok, NewRole}
    end;
del_base_by_bind_fst(Role = #role{bag = #bag{items = Items}}, [{BaseId, DelNum} | T], DelList) ->
    case do_del_base(Items, BaseId, DelNum, 1) of
        {false, Reason} -> {false, Reason};
        {ok, Del} -> del_base_by_bind_fst(Role, T, Del ++ DelList)
    end.

%% role_gain删除
%% 获取按照绑定优先删除,得到一个删除列表,以及各个BaseId绑定和非绑定删除列表
%% get_del_base_bindlist(Role, BaseIdInfo, [], []) -> {ok, Dellist, BindAndUbind} | {false, Reason}
%% Dellist = [{Id, Num} |...]
%% BindAndUbind = [{BaseId, BindDelList, UbindDelList} |..]
%% BaseidInfo = [{Baseid, DelNum} | ..]
get_del_base_bindlist(_Role, [], DelList, BindInfo) -> {ok, DelList, BindInfo};
get_del_base_bindlist(Role = #role{bag = #bag{items = Items}}, [{BaseId, DelNum} | T], DelList, BindInfo) ->
    case do_del_base(Items, BaseId, DelNum, 1) of
        {false, Reason} -> {false, Reason};
        {ok, Del, BindNum} ->
            get_del_base_bindlist(Role, T, Del ++ DelList, [{BaseId, BindNum} | BindInfo])
    end.

get_del_base_ubindlist(_Role, [], DelList, BindInfo) -> {ok, DelList, BindInfo};
get_del_base_ubindlist(Role = #role{bag = #bag{items = Items}}, [{BaseId, DelNum} | T], DelList, BindInfo) ->
    case do_del_base(Items, BaseId, DelNum, 0) of
        {false, Reason} -> {false, Reason};
        {ok, Del, BindNum} ->
            get_del_base_ubindlist(Role, T, Del ++ DelList, [{BaseId, BindNum} | BindInfo])
    end.

%% @spec del_base_by_Ubind_fst(Role, BaseIdInfo) -> {false, Reason} | {ok, NewRole} 
%% @doc 删除baseid的物品Num个, 优先删除非绑定列表的物品
%%      使用role_gain删除,带刷新消息,注意事务
%% BaseIdInfo = [{BaseId, DelNum} | ..]
del_base_by_Ubind_fst(Role, []) -> {ok, Role};
del_base_by_Ubind_fst(Role, BaseIdInfo) ->
    del_base_by_Ubind_fst(Role, BaseIdInfo, []).

%%执行Role_gain
del_base_by_Ubind_fst(Role, [], DelList) ->
    case role_gain:do([#loss{label = item_id, val = DelList}], Role) of
        {false, L} -> {false, L#loss.msg};
        {ok, NewRole} -> {ok, NewRole}
    end;
del_base_by_Ubind_fst(Role = #role{bag = #bag{items = Items}}, [{BaseId, DelNum} | T], DelList) ->
    case do_del_base(Items, BaseId, DelNum, 0) of
        {false, Reason} -> {false, Reason};
        {ok, Del, _BindNum} -> del_base_by_Ubind_fst(Role, T, Del ++ DelList)
    end.

%% 执行BaseId查找并删除
do_del_base(Items, BaseId, DelNum, BindOrUbind) when BindOrUbind =:= 1 ->
    case find(Items, #item.base_id, BaseId) of
        {false, _R} -> {false, ?MSGID(<<"物品数量不足">>)};
        {ok, Num, _, _, _} when Num < DelNum -> {false, ?MSGID(<<"物品数量不足">>)};
        {ok, _Num, _Item, BindList, UbindList} -> do_del_base_by_bind(DelNum, BindList, UbindList)
    end;
do_del_base(Items, BaseId, DelNum, BindOrUbind) when BindOrUbind =:= 0 ->
    case find(Items, #item.base_id, BaseId) of
        {false, _R} -> {false, ?MSGID(<<"物品数量不足">>)};
        {ok, Num, _, _, _} when Num < DelNum -> {false, ?MSGID(<<"物品数量不足">>)};
        {ok, _Num, _Item, BindList, UbindList} -> do_del_base_by_Ubind(DelNum, UbindList, BindList)
    end.

do_del_base_by_bind(Num, BindList, UbindList) ->
    do_del_base_by_bind(Num, BindList, UbindList, [], 0).
do_del_base_by_bind(0, _, _, DelList, BindNum) -> {ok, DelList, BindNum};
do_del_base_by_bind(Num, [], [], _, _) when Num =/= 0 -> {false,?MSGID(<<"物品数量不足">>)};
do_del_base_by_bind(Num, [], [#item{id = Id, quantity = Q} | T], DelList, BindNum) when Q >= Num ->
    do_del_base_by_bind(0, [], T, [{Id, Num} | DelList], BindNum);
do_del_base_by_bind(Num, [], [#item{id = Id, quantity = Q} | T], DelList, BindNum) ->
    do_del_base_by_bind(Num - Q, [], T, [{Id, Q} | DelList], BindNum);
do_del_base_by_bind(Num, [#item{id = Id, quantity = Q} | T], Ubind, DelList, BindNum) when Q >= Num ->
    do_del_base_by_bind(0, T, Ubind, [{Id, Num} | DelList], BindNum + Num);
do_del_base_by_bind(Num, [#item{id = Id, quantity = Q} | T], Ubind, DelList, BindNum) ->
    do_del_base_by_bind(Num - Q, T, Ubind, [{Id, Q} | DelList], BindNum + Q).


do_del_base_by_Ubind(Num, UbindList, BindList) ->
    do_del_base_by_Ubind(Num, UbindList, BindList, [], 0).
do_del_base_by_Ubind(0, _, _, DelList, BindNum) -> {ok, DelList, BindNum};
do_del_base_by_Ubind(Num, [], [], _, _) when Num =/= 0 -> {false, ?MSGID(<<"物品数量不足">>)};
do_del_base_by_Ubind(Num, [], [#item{id = Id, quantity = Q} | T], DelList, BindNum) when Q >= Num ->
    do_del_base_by_Ubind(0, [], T, [{Id, Num} | DelList], BindNum + Num);
do_del_base_by_Ubind(Num, [], [#item{id = Id, quantity = Q} | T], DelList, BindNum) ->
    do_del_base_by_Ubind(Num - Q, [], T, [{Id, Q} | DelList], BindNum + Q);
do_del_base_by_Ubind(Num, [#item{id = Id, quantity = Q} | T], Bind, DelList, BindNum) when Q >= Num ->
    do_del_base_by_Ubind(0, T, Bind, [{Id, Num} | DelList], BindNum);
do_del_base_by_Ubind(Num, [#item{id = Id, quantity = Q} | T], Bind, DelList, BindNum) ->
    do_del_base_by_Ubind(Num - Q, T, Bind, [{Id, Q} | DelList], BindNum).

%% 根据位置交换两个物品，同时自动处理堆叠 
%% @spec swap_by_pos(A, Id1, B, Id2) -> {ok, NewA, NewB} | {false, Reason} 
%% A = B = NewA = NewB = #store{} | #bag{} 背包或仓库 
%% Id1 = Id2 = #integer() 背包或仓库 
%% Reason =  交换失败原因 
swap_by_pos(StorageType = casino, Id, Pos2, Role = #role{bag = Bag = #bag{items = ItemsB}, casino = Casino = #casino{items = ItemsA}}) ->
    case find(ItemsA, #item.id, Id) of
        {false, Reason} -> {false, Reason};
        {ok, Item1 = #item{pos = Pos1, status = ?lock_release}} ->
            case check_pos(Casino, Pos1, Bag, Pos2) of
                true ->
                    case find(ItemsB, #item.pos, Pos2) of
                        {false, _R2} -> %% 目标位置无物品 采取移动方式
                            swap_by_pos(StorageType, move, Pos1, Item1, Pos2, Item1, Role);
                        {ok, Item2 = #item{status = ?lock_release}} -> %% 目标位置存在物品
                            swap_by_pos(StorageType, swap, Pos1, Item1, Pos2, Item2, Role);
                        _ -> 
                            {false, ?L(<<"目标位置锁定,不能移动">>)}
                    end;
                false -> {false, ?L(<<"目标位置未开通">>)}
            end;
        _ -> {false, ?L(<<"物品锁定,不能移动">>)}
    end;
swap_by_pos(StorageType = super_boss_store, Id, Pos2, Role = #role{bag = Bag = #bag{items = ItemsB}, super_boss_store = Store = #super_boss_store{items = ItemsA}}) ->
    case find(ItemsA, #item.id, Id) of
        {false, Reason} -> {false, Reason};
        {ok, Item1 = #item{pos = Pos1, status = ?lock_release}} ->
            case check_pos(Store, Pos1, Bag, Pos2) of
                true ->
                    case find(ItemsB, #item.pos, Pos2) of
                        {false, _R2} -> %% 目标位置无物品 采取移动方式
                            swap_by_pos(StorageType, move, Pos1, Item1, Pos2, Item1, Role);
                        {ok, Item2 = #item{status = ?lock_release}} -> %% 目标位置存在物品
                            swap_by_pos(StorageType, swap, Pos1, Item1, Pos2, Item2, Role);
                        _ -> 
                            {false, ?L(<<"目标位置锁定,不能移动">>)}
                    end;
                false -> {false, ?L(<<"目标位置未开通">>)}
            end;
        _ -> {false, ?L(<<"物品锁定,不能移动">>)}
    end;
swap_by_pos(StorageType, Id, Pos2, Role = #role{bag = Bag, store = Store}) ->
    {StorageA, ItemsA, StorageB, ItemsB} = case StorageType of
        bag -> {Bag, Bag#bag.items, Store, Store#store.items};
        store -> {Store, Store#store.items, Bag, Bag#bag.items}
    end,
    case find(ItemsA, #item.id, Id) of
        {false, _Reason} -> {false, <<>>};
        {ok, Sitem = #item{pos = Pos1, status = ?lock_release}} ->
            case check_pos(StorageA, Pos1, StorageB, Pos2) of
                true ->
                    case find(ItemsB, #item.pos, Pos2) of
                        {false, _R2} -> 
                            swap_by_pos(StorageType, move, Pos1, Sitem, Pos2, Sitem, Role);
                        {ok, Titem = #item{status = ?lock_release}} ->
                            swap_by_pos(StorageType, swap, Pos1, Sitem, Pos2, Titem, Role);
                        _ -> {false, ?L(<<"目标位置锁定,不能移动">>)}
                    end;
                false -> {false, ?L(<<"目标位置未开通">>)}
            end;
        _ -> {false, ?L(<<"物品锁定,不能移动">>)}
    end.

do_move(Item, NewItem, Type, NewType, Items1, Items2, ConnPid) ->
    NewItems1 = lists:keydelete(Item#item.id, #item.id, Items1),
    NewItems2 = [NewItem | Items2],
    storage_api:del_item_info(ConnPid, [{Type, Item}]),
    storage_api:add_item_info(ConnPid, [{NewType, NewItem}]),
    {NewItems1, NewItems2}.

do_swap_other(Item1, Item2, Nitem1, Nitem2, Type1, Type2, Items1, Items2, ConnPid) ->
    NewItems1 = lists:keydelete(Item1#item.id, #item.id, Items1),
    NewItems2 = lists:keydelete(Item2#item.id, #item.id, Items2),
    storage_api:del_item_info(ConnPid, [{Type1, Item1}, {Type2, Item2}]),
    storage_api:add_item_info(ConnPid, [{Type1, Nitem2}, {Type2, Nitem1}]),
    {[Nitem2 | NewItems1], [Nitem1 | NewItems2]}.

do_stack_other(Item1, Item2, Nitem2, Type1, Type2, Items1, Items2, ConnPid) ->
    NewItems1 = lists:keydelete(Item1#item.id, #item.id, Items1),
    NewItems2 = lists:keyreplace(Item2#item.id, #item.id, Items2, Nitem2),
    storage_api:refresh_client_item(del, ConnPid, [{Type1, [Item1]}]),
    storage_api:refresh_client_item(refresh, ConnPid, [{Type2, [Nitem2]}]),
    {NewItems1, NewItems2}.

do_stack_other(Item1, Item2, Nitem1, Nitem2, Type1, Type2, Items1, Items2, ConnPid) ->
    NewItems1 = lists:keyreplace(Item1#item.id, #item.id, Items1, Nitem1),
    NewItems2 = lists:keyreplace(Item2#item.id, #item.id, Items2, Nitem2),
    storage_api:refresh_mulit(ConnPid, [{Type1, Nitem1}, {Type2, Nitem2}]),
    {NewItems1, NewItems2}.

swap_by_pos(bag, move, Pos1, Item1, Pos2, _Item2, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Bitems, free_pos = Bfree}, store = Store = #store{items = Sitems, next_id = NextId, free_pos = Sfree}}) ->
    NewItem = Item1#item{pos = Pos2, id = NextId},
    {NewBitems, NewSitems} = do_move(Item1, NewItem, ?storage_bag, ?storage_store, Bitems, Sitems, ConnPid),
    NewBag = Bag#bag{items = NewBitems, free_pos = lists:sort([Pos1 | Bfree])},
    NewStore = Store#store{items = NewSitems, free_pos = Sfree -- [Pos2], next_id = NextId + 1},
    log:log(log_storage_handle, {<<"->仓库">>, Item1, Role}),
    {ok, Role#role{bag = NewBag, store = NewStore}};

swap_by_pos(bag, swap, Pos1, Item1, Pos2, Item2, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Bitems}, store = Store = #store{items = Sitems}}) ->
    case check_can_stack(Item1, Item2) of
        false ->
            Nitem1 = Item1#item{pos = Pos2, id = Item2#item.id},
            Nitem2 = Item2#item{pos = Pos1, id = Item1#item.id},
            {NewBitems, NewSitems} = 
            do_swap_other(Item1, Item2, Nitem1, Nitem2, ?storage_bag, ?storage_store, Bitems, Sitems, ConnPid),
            NewBag = Bag#bag{items = NewBitems},
            NewStore = Store#store{items = NewSitems},
            log:log(log_storage_handle, {<<"->仓库(交换)">>, Item1, Role}),
            log:log(log_storage_handle, {<<"<-仓库(交换)">>, Item2, Role}),
            {ok, Role#role{bag = NewBag, store = NewStore}};
        {true, OverLap} ->
            case stacking_item_other(Bag, Store, OverLap, Item1, Item2, ConnPid) of
                {false, R} -> {false, R};
                {ok, NewBag, NewStore} ->
                    log:log(log_storage_handle, {<<"->仓库(交换堆叠)">>, Item1, Role}),
                    {ok, Role#role{bag = NewBag, store = NewStore}}
            end;
        {false, R1} -> {false, R1}
    end;

swap_by_pos(store, move, Pos1, Item1, Pos2, _Item2, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Bitems, free_pos = Bfree, next_id = NextId}, store = Store = #store{items = Sitems, free_pos = Sfree}}) ->
    NewItem = Item1#item{pos = Pos2, id = NextId},
    {NewSitems, NewBitems} = do_move(Item1, NewItem, ?storage_store, ?storage_bag, Sitems, Bitems, ConnPid),
    NewStore = Store#store{items = NewSitems, free_pos = lists:sort([Pos1 | Sfree])},
    NewBag = Bag#bag{items = NewBitems, free_pos = Bfree -- [Pos2], next_id = NextId + 1},
    log:log(log_storage_handle, {<<"<-仓库">>, Item1, Role}),
    {ok, Role#role{bag = NewBag, store = NewStore}, Item1};

swap_by_pos(store, swap, Pos1, Item1, Pos2, Item2, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Bitems}, store = Store = #store{items = Sitems}}) ->
    case check_can_stack(Item1, Item2) of
        false ->
            Nitem1 = Item1#item{pos = Pos2, id = Item2#item.id},
            Nitem2 = Item2#item{pos = Pos1, id = Item1#item.id},
            {NewSitems, NewBitems} = 
            do_swap_other(Item1, Item2, Nitem1, Nitem2, ?storage_store, ?storage_bag, Sitems, Bitems, ConnPid),
            NewStore = Store#store{items = NewSitems},
            NewBag = Bag#bag{items = NewBitems},
            log:log(log_storage_handle, {<<"->仓库(交换)">>, Item2, Role}),
            log:log(log_storage_handle, {<<"<-仓库(交换)">>, Item1, Role}),
            {ok, Role#role{bag = NewBag, store = NewStore}, Item1};
        {true, OverLap} ->
            case stacking_item_other(Store, Bag, OverLap, Item1, Item2, ConnPid) of
                {false, R} -> {false, R};
                {ok, NewStore, NewBag, Item} -> 
                    log:log(log_storage_handle, {<<"<-仓库(交换堆叠)">>, Item1, Role}),
                    {ok, Role#role{bag = NewBag, store = NewStore}, Item}
            end;
        {false, R1} -> {false, R1}
    end;

swap_by_pos(casino, move, Pos1, Item1, Pos2, _Item2, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Bitems, free_pos = Bfree, next_id = NextId}, casino = Store = #casino{items = Sitems, free_pos = Sfree}}) ->
    NewItem = Item1#item{pos = Pos2, id = NextId},
    {NewSitems, NewBitems} = do_move(Item1, NewItem, ?storage_casino, ?storage_bag, Sitems, Bitems, ConnPid),
    NewStore = Store#casino{items = NewSitems, free_pos = lists:sort([Pos1 | Sfree])},
    NewBag = Bag#bag{items = NewBitems, free_pos = Bfree -- [Pos2], next_id = NextId + 1},
    log:log(log_storage_handle, {<<"<-寻宝仓库">>, Item1, Role}),
    {ok, Role#role{bag = NewBag, casino = NewStore}, Item1};

swap_by_pos(casino, swap, Pos1, Item1 = #item{quantity = Num1}, _Pos2, Item2 = #item{quantity = Num2}, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = ItemsB}, casino = Casino = #casino{items = ItemsA, free_pos = CFreePos}}) ->
    case check_can_stack(Item1, Item2) of
        {true, OverLap} when Num1 + Num2 =< OverLap -> %% 目标位置物品相同 且可叠加
            NewI2 = Item2#item{quantity = Num1 + Num2},
            {NewItemsA, NewItemsB} = do_stack_other(Item1, Item2, NewI2, ?storage_casino, ?storage_bag,
                ItemsA, ItemsB, ConnPid),
            NewCasino = Casino#casino{items = NewItemsA, free_pos = lists:sort([Pos1 | CFreePos])},
            NewBag = Bag#bag{items = NewItemsB},
            log:log(log_storage_handle, {<<"<-寻宝仓库">>, Item1, Role}),
            {ok, Role#role{bag = NewBag, casino = NewCasino}, Item1};
        {false, Reason} -> 
            {false, Reason};
        _ ->
            {false, ?L(<<"目标位置存在物品, 不能移动">>)}
    end;

swap_by_pos(super_boss_store, move, Pos1, Item1, Pos2, _Item2, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Bitems, free_pos = Bfree, next_id = NextId}, super_boss_store = Store = #super_boss_store{items = Sitems, free_pos = Sfree}}) ->
    NewItem = Item1#item{pos = Pos2, id = NextId},
    {NewSitems, NewBitems} = do_move(Item1, NewItem, ?storage_super_boss, ?storage_bag, Sitems, Bitems, ConnPid),
    NewStore = Store#super_boss_store{items = NewSitems, free_pos = lists:sort([Pos1 | Sfree])},
    NewBag = Bag#bag{items = NewBitems, free_pos = Bfree -- [Pos2], next_id = NextId + 1},
    log:log(log_storage_handle, {<<"<-盘龙仓库">>, Item1, Role}),
    {ok, Role#role{bag = NewBag, super_boss_store = NewStore}, Item1};

swap_by_pos(super_boss_store, swap, Pos1, Item1 = #item{quantity = Num1}, _Pos2, Item2 = #item{quantity = Num2}, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = ItemsB}, super_boss_store = Store = #super_boss_store{items = ItemsA, free_pos = CFreePos}}) ->
    case check_can_stack(Item1, Item2) of
        {true, OverLap} when Num1 + Num2 =< OverLap -> %% 目标位置物品相同 且可叠加
            NewI2 = Item2#item{quantity = Num1 + Num2},
            {NewItemsA, NewItemsB} = do_stack_other(Item1, Item2, NewI2, ?storage_super_boss, ?storage_bag,
                ItemsA, ItemsB, ConnPid),
            NewStore = Store#super_boss_store{items = NewItemsA, free_pos = lists:sort([Pos1 | CFreePos])},
            NewBag = Bag#bag{items = NewItemsB},
            log:log(log_storage_handle, {<<"<-盘龙仓库">>, Item1, Role}),
            {ok, Role#role{bag = NewBag, super_boss_store = NewStore}, Item1};
        {false, Reason} -> 
            {false, Reason};
        _ ->
            {false, ?L(<<"目标位置存在物品, 不能移动">>)}
    end.

stacking_item_other(Storage1, Storage2, OverLap, Item1 = #item{quantity = Num1, pos = Pos1}, Item2 = #item{quantity = Num2}, ConnPid) ->
    if
        Num2 =:= OverLap -> {false, ?L(<<"目标堆叠数满">>)};
        Num1 + Num2 =< OverLap ->
            NewI2 = Item2#item{quantity = Num1 + Num2},
            case is_record(Storage1, bag) of
                true ->
                    {NewBitems, NewSitems} =
                    do_stack_other(Item1, Item2, NewI2, ?storage_bag, ?storage_store,
                        Storage1#bag.items, Storage2#store.items, ConnPid),
                    NewBag = Storage1#bag{items = NewBitems, free_pos = lists:sort([Pos1 | Storage1#bag.free_pos])},
                    NewStore = Storage2#store{items = NewSitems},
                    {ok, NewBag, NewStore};
                false ->
                    {NewSitems, NewBitems} =
                    do_stack_other(Item1, Item2, NewI2, ?storage_store, ?storage_bag,
                        Storage1#store.items, Storage2#bag.items, ConnPid),
                    NewStore = Storage1#store{items = NewSitems, free_pos = lists:sort([Pos1 | Storage1#store.free_pos])},
                    NewBag = Storage2#bag{items = NewBitems},
                    {ok, NewStore, NewBag, Item1}
            end;
        Num1 + Num2 > OverLap ->
            New1 = Item1#item{quantity = Num1 + Num2 - OverLap},
            New2 = Item2#item{quantity = OverLap},
            case is_record(Storage1, bag) of
                true ->
                    {NewBitems, NewSitems} = 
                    do_stack_other(Item1, Item2, New1, New2, ?storage_bag, ?storage_store, 
                        Storage1#bag.items, Storage2#store.items, ConnPid),
                    NewBag = Storage1#bag{items = NewBitems},
                    NewStore = Storage2#store{items = NewSitems},
                    {ok, NewBag, NewStore};
                false ->
                    {NewSitems, NewBitems} = 
                    do_stack_other(Item1, Item2, New1, New2, ?storage_store, ?storage_bag, 
                        Storage1#store.items, Storage2#bag.items, ConnPid),
                    NewStore = Storage1#store{items = NewSitems},
                    NewBag = Storage2#bag{items = NewBitems},
                    {ok, NewStore, NewBag, Item1#item{quantity = OverLap - Num2}}
            end
    end.

%% 统计某类物品的数量 
%% @spec count(Storage, BaseId) -> integer() 
%% Storage = #bag{} | #store{} 待统计的物品存储器 
%% BaseId = integer() 需要统计的物品base_id 
count(#bag{items = Items}, BaseId) -> 
    do_count(Items, BaseId, 0); 
count(#store{items = Items}, BaseId) -> 
    do_count(Items, BaseId, 0). 

%% 检测飞行状态,不能脱坐骑
check_fly_and_mount(#role{ride = ?ride_fly}, #item{type = 17}) -> {false, ?L(<<"飞行中不能更换坐骑">>)};
check_fly_and_mount(#role{ride = ?ride_fly}, #item{type = 38}) -> {false, ?L(<<"飞行中不能更换翅膀">>)};
check_fly_and_mount(#role{ride = ?ride_fly}, Item) when is_record(Item, item) -> true;

check_fly_and_mount(#role{ride = ?ride_fly}, BaseId) when is_integer(BaseId) ->
    case item_data:get(BaseId) of
        {ok, #item_base{type = ?item_wing}} -> {false, ?L(<<"飞行中不能更换翅膀">>)};
        {ok, #item_base{type = ?item_zuo_qi}} -> {false, ?L(<<"飞行中不能更换坐骑">>)};
        {ok, _} -> true;
        _ ->
            ?ERR("发现未知物品:~w",[BaseId]),
            {false, <<"">>}
    end;
check_fly_and_mount(_, _) -> true.

%%---------------------------------------------------- 
%% 私有函数 
%%---------------------------------------------------- 

%% 合并相同物品 
combine([], Rtn) -> Rtn; 
combine([I = #item{base_id = BaseId, quantity = Q, bind = Bind} | T], Rtn) -> 
    case item_data:get(BaseId) of 
        {ok, #item_base{overlap = O}} when O > 1 andalso Q =/= O -> %% 需要合并的 
            {Same1, Other1} = find_same(T, BaseId, [], []), %% 找出所有的同类物品 
            {Same, Other2} = find_bind(Same1, Bind, [], []), %% 同类物品分出绑定与非绑定 
            L = do_combine([I | Same], O, []), %% 合并同类物品 
            combine(Other1 ++ Other2, L ++ Rtn); 
        _ -> %% 不存在的物品不作处理 
            combine(T, [I | Rtn]) 
    end. 
do_combine([#item{quantity = Q}], _O, Sorted) when Q =:= 0 -> Sorted; %% 最后一个需特殊处理，如果数量为0则丢弃 
do_combine([I], _O, Sorted) -> [I | Sorted]; 
do_combine([I1 = #item{quantity = Q1} | [I2 = #item{quantity = Q2} | T]], O, Sorted) -> 
    Q = Q1 + Q2, 
    case Q >= O of 
        true -> 
            do_combine([I2#item{quantity = Q - O} | T], O, [I1#item{quantity = O} | Sorted]); 
        false -> 
            do_combine([I1#item{quantity = Q} | T], O, Sorted) 
    end. 

%% 找出所有的相同类型物品 
find_same([], _BaseId, Same, Other) -> {Same, Other}; 
find_same([I = #item{base_id = Bid} | T], BaseId, Same, Other) when Bid =:= BaseId -> 
    find_same(T, BaseId, [I | Same], Other); 
find_same([I | T], BaseId, Same, Other) -> 
    find_same(T, BaseId, Same, [I | Other]). 

%% 从同类物品中找出区分绑定与非绑定 
find_bind([], _Bind, Same, Other) -> {Same, Other}; 
find_bind([Item = #item{bind = Bd} | T], Bind, Same, Other) when Bd =:= Bind -> 
    find_bind(T, Bind, [Item | Same], Other); 
find_bind([Item | T], Bind, Same, Other) -> 
    find_bind(T, Bind, Same, [Item | Other]). 

%% 品质排序函数 
%%sort_quality(#item{quality = Q1}, #item{quality = Q2}) when Q1 > Q2 -> true; 
%%sort_quality(Item1 = #item{quality = Q1}, Item2 = #item{quality = Q2}) when Q1 =:= Q2 ->
%%    sort_baseid(Item1, Item2);
%%sort_quality(_, _) -> false. 

%% Type排序函数
sort_type(#item{type = T1}, #item{type = T2}) when T1 < T2 ->true;
sort_type(Item1 = #item{type = T1}, Item2 = #item{type = T2}) when T1 =:= T2 ->
    sort_baseid(Item1, Item2);
sort_type(_, _) -> false.

sort_baseid(#item{base_id = Bid1}, #item{base_id = Bid2}) when Bid1 < Bid2 -> true;
sort_baseid(_, _) -> false.

%% do_use_id(Role, Id, Fpos, Num)
%% Id = 要删除的ID, Num = 删除的个数 Fpos = 释放的格子
do_use(Role = #role{bag = #bag{items = Items}}, BaseId, Pos, Num) ->
    case lists:keyfind(BaseId, #item.base_id, Items) of
        false -> {false, ?L(<<"物品数量不足">>)};
        Item ->
            case check_fly_and_mount(Role, Item) of
                {false, Reason} -> {false, Reason};
                true ->
                    case item:use(Role, Item, Num) of
                        {false, Reason} -> {false, Reason};
                        {ok, NewRole = #role{bag = NewBag}, NewItem = #item{quantity = Q}, _NewNum} when Q > 0 ->
                            %% 非消耗品, 或者消耗品用足了
                            NewItems = lists:keyreplace(Item#item.id, #item.id, NewBag#bag.items, NewItem),
                            {ok, NewRole#role{bag = NewBag#bag{items = NewItems}}, Pos};
                        {ok, NewRole = #role{bag = NewBag}, NewItem = #item{quantity = Q}, NewNum} when NewNum =:= 0 ->
                            case Q =:= 0 of
                                true -> 
                                    %% 消耗品 刚好用完
                                    NewItems = lists:keydelete(Item#item.id, #item.id, NewBag#bag.items),
                                    {ok, NewRole#role{bag = NewBag#bag{items = NewItems}}, [Item#item.pos |Pos]};
                                false ->
                                    %% 消耗品 有剩余
                                    NewItems = lists:keyreplace(Item#item.id, #item.id, NewBag#bag.items, NewItem),
                                    {ok, NewRole#role{bag = NewBag#bag{items = NewItems}}, Pos}
                            end;
                        {ok, NewRole = #role{bag = NewBag}, NewItem = #item{quantity = Q}, NewNum} 
                        when Q =:= 0 andalso NewNum =:= 0 ->
                            %% 消耗品 不足, 继续找
                            NewItems = lists:keyreplace(Item#item.id, #item.id, NewBag#bag.items, NewItem),
                            do_use(NewRole#role{bag = NewBag#bag{items = NewItems}}, BaseId, [Item#item.pos | Pos], NewNum) 
                    end
            end
    end.

%% do_use_id(Role, Id, Fpos, Num)
%% Id = 要删除的ID, Num = 删除的个数 Fpos = 释放的格子
do_use_by_id(Role = #role{bag = #bag{items = Items}}, Id, Pos, Num) ->
    case find(Items, #item.id, Id) of
        {false, R} -> {false, R};
        {ok, Item} ->
            case check_fly_and_mount(Role, Item) of
                {false, Reason} -> {false, Reason};
                true ->
                    case item:use(Role, Item, Num) of
                        {false, Reason} -> {false, Reason};
                        {ok, NewRole = #role{bag = NewBag}, NewItem = #item{quantity = Q}, _NewNum} when Q > 0 ->
                            NewItems = lists:keyreplace(Id, #item.id, NewBag#bag.items, NewItem),
                            {ok, NewRole#role{bag = NewBag#bag{items = NewItems}}, Pos};
                        {ok, NewRole = #role{bag = NewBag}, NewItem = #item{quantity = Q}, NewNum} when NewNum =:= 0 ->
                            case Q =:= 0 of
                                true -> 
                                    NewItems = lists:keydelete(Id, #item.id, NewBag#bag.items),
                                    {ok, NewRole#role{bag = NewBag#bag{items = NewItems}}, [Item#item.pos |Pos]};
                                false ->
                                    NewItems = lists:keyreplace(Id, #item.id, NewBag#bag.items, NewItem),
                                    {ok, NewRole#role{bag = NewBag#bag{items = NewItems}}, Pos}
                            end;
                        {ok, _NewRole, #item{quantity = Q}, NewNum} when Q =:= 0 andalso NewNum > 0 ->
                            {false, ?L(<<"物品数量不足">>)}
                    end
            end
    end.

%% 执行删除 
do_del([], Items, _BaseId, Pos, all, DelList, FreshList) -> {ok, Items, Pos, DelList, FreshList}; 
do_del([], _Items, _BaseId, _Pos, Num, _DelList, _FreshList) when Num > 0 -> false; 
do_del([Item = #item{base_id = Bid, pos = P} | T], Items, BaseId, Pos, all, DelList, FreshList) when Bid =:= BaseId -> 
    %% 删除所有该类物品 
    do_del(T, Items, BaseId, [P | Pos], all, [Item | DelList], FreshList); 
do_del([Item = #item{status = Status, base_id = Bid, quantity = Q, pos = P} | T], Items, BaseId, Pos, Num, DelList, FreshList) when Bid =:= BaseId andalso Status =:= ?lock_release -> 
    N = Q - Num, 
    if 
        N =:= 0 -> %% 数量刚好 
            {ok, T ++ Items, [P | Pos], [Item | DelList], FreshList}; 
        N > 0 -> %% 数量足够，还有剩余 
            {ok, [Item#item{quantity = N} | T] ++ Items, Pos, DelList, [Item#item{quantity = N} | FreshList]}; 
        true -> %% 数量不够，继续查找 
            do_del(T, Items, BaseId, [P | Pos], Num - Q, [Item | DelList], FreshList) 
    end; 
do_del([Item | T], Items, BaseId, Pos, Num, DelList, FreshList) -> %% 不匹配的物品，跳过 
    do_del(T, [Item | Items], BaseId, Pos, Num, DelList, FreshList). 

%% 执行删除-根据位置 
do_pos_del([], _Items, _Pos, _NewPos, _Num) -> {false, ?L(<<"未发现物品">>)}; 
do_pos_del([Item = #item{pos = Fpos, quantity = Q} | T], Items, Pos, NewPos, Num) when Fpos =:= Pos -> 
    N = Q - Num, 
    if 
        N =:= 0 -> %% 全部删除 
            {ok, T ++ Items, [Pos | NewPos]}; 
        N > 0 ->  
            {ok, [Item#item{quantity = N} | T] ++ Items, NewPos}; 
        true -> 
            {false, ?L(<<"物品数量不足">>)} 
    end; 
do_pos_del([Item | T], Items, Pos, NewPos, Num) -> 
    do_pos_del(T, [Item | Items], Pos, NewPos, Num). 

%% 执行删除-根据Id 
do_del_by_id([], _Items, _Id, _NewPos, _Num, _CheckStatus, _Del, _Fresh) -> {false, ?L(<<"未发现物品">>)}; 
do_del_by_id([Item = #item{id = Fid} | T], Items, Id, NewPos, Num, true, Del, Fresh) when Fid =:= Id -> 
    case Item#item.status of 
        ?lock_release -> 
            do_del_by_id([Item | T], Items, Id, NewPos, Num, false, Del, Fresh); 
        _ -> 
            {false, ?L(<<"物品已经被锁定">>)} 
    end; 
do_del_by_id([Item = #item{pos = Pos, quantity = Q, id = Fid} | T], Items, Id, NewPos, Num, false, Del, Fresh) when Fid =:= Id ->
    N = Q - Num, 
    if 
        N =:= 0 -> 
            {ok, T ++ Items, [Pos | NewPos], [Item | Del], Fresh}; 
        N > 0 -> 
            {ok, [Item#item{quantity = N} | T] ++ Items, NewPos, Del, [Item#item{quantity = N} | Fresh]}; 
        true -> 
            {false, ?L(<<"物品数量不足">>)} 
    end; 
do_del_by_id([Item | T], Items, Id, NewPos, Num, CheckStatus, Del, Fresh) -> 
    do_del_by_id(T, [Item | Items], Id, NewPos, Num, CheckStatus, Del, Fresh). 


%% 执行统计 
do_count([], _BaseId, Num) -> Num; 
do_count([#item{base_id = Bid, quantity = N} | T], BaseId, Num) when Bid =:= BaseId -> 
    do_count(T, BaseId, Num + N); 
do_count([_ | T], BaseId, Num) -> 
    do_count(T, BaseId, Num). 

%% 坐骑穿戴即绑定
bind_mount(Item = #item{type = Type}) when Type =:= ?item_zuo_qi ->
    Item#item{bind = 1};
bind_mount(Item) ->
    Item.
