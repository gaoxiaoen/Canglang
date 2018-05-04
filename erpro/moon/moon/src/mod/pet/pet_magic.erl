%%----------------------------------------------------
%% 宠物魔晶系统
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(pet_magic).
-export([
        magic_info_client/1
        ,do_gm/2
        %% ,call_npc/2
        ,hunt/2
        ,sell/2
        ,pick/2
        ,exchange/2
        ,add_new_items_to_bag/2
        ,add_volume/2
        ,bag_to_bag/3
        ,bag_to_eqm/4
        ,eqm_to_eqm/4
        ,eqm_to_bag/4
        ,devour_all/1
        ,polish_bag/3
        ,polish_batch_bag/3
        ,polish_eqm/5
        ,polish_select_bag/3
        ,polish_select_eqm/4
        ,do_item_polish/2
        ,lock_item_bag/3
        ,lock_item_eqm/4
        ,gm_make_pet_eqm/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("pet.hrl").
-include("item.hrl").
-include("gain.hrl").
-include("vip.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("assets.hrl").

%% GM生成指定宠物魔晶数据
gm_make_pet_eqm([{BaseId, Lev, PL} | T], Eqm) when is_list(PL) ->
    case item:make(BaseId, 0, 1) of
        {ok, [Item = #item{use_type = 3, attr = BaseAttr}]} -> 
            {Exp, AppLevAttr} = case pet_magic_data:get_item_attr(BaseId, Lev - 1) of
                #pet_item_attr{exp = Exp1, attr = AppAttr1} -> {Exp1, AppAttr1};
                _ -> {1, []}
            end,
            PolishL = gm_make_pet_eqm_polish(Lev, PL, []),
            NewBaseAttr = attr_join(BaseAttr, AppLevAttr),
            NewItem = Item#item{
                id = length(Eqm) + 1
                ,pos = length(Eqm) + 1                
                ,attr = [{?attr_pet_eqm_lev, 100, Lev}, {?attr_pet_eqm_exp, 100, Exp} 
                    | NewBaseAttr] ++ PolishL
            },
            gm_make_pet_eqm(T, [NewItem | Eqm]);
        _ ->
            gm_make_pet_eqm(T, Eqm)
    end;
gm_make_pet_eqm([_ | T], Eqm) ->
    gm_make_pet_eqm(T, Eqm);
gm_make_pet_eqm(_, Eqm) ->
    Eqm.
gm_make_pet_eqm_polish(Lev, [{Name, Star, Value} | T], PolishL) ->
    NameCode = label_to_code(Name),
    AttrPos = length(PolishL) + 1,
    Flag = (Star * 1000 + Lev) * 100 + AttrPos * 10,
    gm_make_pet_eqm_polish(Lev, T, [{NameCode, Flag, Value} | PolishL]);
gm_make_pet_eqm_polish(_Lev, _, PolishL) ->
    PolishL.

%%GM命令
do_gm(Role = #role{pet_magic = PetMagic = #pet_magic{items = Items}}, {exp, Exp}) ->
    NewItems = [Item#item{attr = update_attr(Attr, {?attr_pet_eqm_exp, 100, Exp})} || Item = #item{attr = Attr} <- Items],
    storage_api:refresh_client_item(refresh, Role#role.link#link.conn_pid, [{?storage_pet_magic, NewItems}]),
    {ok, Role#role{pet_magic = PetMagic#pet_magic{items = NewItems}}};
do_gm(Role, {bag, BaseId}) ->
    case item:make(BaseId, 0, 1) of
        {ok, [Item = #item{use_type = UseType}]} when BaseId >= 50000 andalso BaseId < 60000 andalso UseType =/= 0 ->
            add_new_items_to_bag(Role, [Item]);
        _ ->
            {false, ?L(<<"非法物品，魔晶物品才能出现在魔晶背包">>)}
    end.

%% 获取猎魔面版数据信息
magic_info_client(Role = #role{pet = #pet_bag{hunt = #pet_hunt{items = Items}}}) ->
    {{_Type, _T, Free}, _Logs} = pet:everyday_limit_log(?pet_log_type_magic, Role),
    ItemInfo0 = [{Id, get_item_info(BaseId)} || {Id, BaseId, _Num} <- Items],
    ItemInfo = [{Id, BaseId, Price} || {Id, {BaseId, _UseType, Price}} <- ItemInfo0],
    {[], Free, ItemInfo}.

%% 召唤NPC
%% call_npc(#role{vip = #vip{type = Type}}, _NpcId) when Type =:= ?vip_no orelse Type =:= ?vip_try ->
%%    {false, <<"非VIP不能使用召唤功能">>};
%% call_npc(#role{pet = #pet_bag{hunt = #pet_hunt{items = Items}}}, _NpcId) when length(Items) >= 12 ->
%%    {false, <<"猎魔物品栏已满，请先拾取或出售">>};
%% call_npc(Role = #role{pet = PetBag = #pet_bag{hunt = Hunt = #pet_hunt{npc_ids = NpcIds}}}, NpcId) ->
%%     Flag = lists:keyfind(NpcId, 1, NpcIds),
%%     case call_npc_price(NpcId) of
%%         false -> 
%%             {false, <<"此猎魔NPC不能召唤">>};
%%         _ when Flag =/= false -> 
%%             {false, <<"当前猎魔NPC已激活">>};
%%         GL ->
%%             case role_gain:do(GL, Role) of
%%                 {false, _} -> {false, gold};
%%                 {ok, NRole} ->
%%                     Inform = notice_inform:gain_loss(GL, <<"猎魔召唤">>),
%%                     notice:inform(Role#role.pid, Inform),
%%                     NewNpcIds = [{NpcId, 1} | NpcIds],
%%                     NewRole = NRole#role{pet = PetBag#pet_bag{hunt = Hunt#pet_hunt{npc_ids = NewNpcIds}}},
%%                     {ok, NewRole, to_client_npc_id(NewNpcIds, [])}
%%             end
%%     end.

%% 进行猎魔
hunt(#role{pet = #pet_bag{hunt = #pet_hunt{items = Items}}}, _NpcId) when length(Items) >= 18 ->
    {false, ?L(<<"猎魔物品栏已满，请先拾取或出售">>)};
hunt(Role = #role{pet = PetBag = #pet_bag{hunt = Hunt = #pet_hunt{next_id = NextId, items = Items}}}, NpcId) ->
    case pet_magic_data:get_npc(NpcId) of
        _Npc = #pet_npc{coin = Coin, gold = Gold} ->
            #pet_npc_item{base_id = BaseId, item_name = ItemName, is_notice = IsNotice} = rand_item(NpcId),
            case item:make(BaseId, 0, 1) of
                {ok, MagicItems} ->
                    {{LogType, LogTime, Free}, Logs} = pet:everyday_limit_log(?pet_log_type_magic, Role),
                    GL = case Gold > 0 of
                        _ when NpcId =:= 1 andalso Free > 0 -> [];
                        true -> [#loss{label = gold, val = Gold}];
                        false when Coin > 0 -> [#loss{label = coin_all, val = Coin}];
                        _ -> [#loss{label = gold, val = 99999999999999}]
                    end,
                    case role_gain:do(GL, Role) of
                        {false, #loss{label = Label}} -> {false, Label};
                        {ok, NRole} ->
                            Inform = notice_inform:gain_loss(GL, ?L(<<"进行猎魔">>)),
                            notice:inform(Role#role.pid, Inform), 
                            {NewFree, NewLogs} = case GL of
                                [] -> {Free - 1, lists:keyreplace(LogType, 1, Logs, {LogType, LogTime, Free - 1})};
                                _ -> {Free, Logs}
                            end,
                            {_BaseId, _UseType, Price} = get_item_info(BaseId),
                            NewItems = [{NextId, BaseId, 1} | Items],
                            NewHunt = Hunt#pet_hunt{items = NewItems, next_id = NextId + 1},
                            NewRole = NRole#role{pet = PetBag#pet_bag{log = NewLogs, hunt = NewHunt}},
                            log:log(log_coin, {<<"猎魔">>, util:fbin("猎魔NPC:~p 获得:~s,~p", [NpcId, ItemName, BaseId]), Role, NRole}),
                            log:log(log_handle_all, {12662, <<"猎魔">>, util:fbin("猎魔NPC:~p 获得:~s,~p", [NpcId, ItemName, BaseId]), Role}),
                            case IsNotice of
                                1 ->
                                    RoleMsg = notice:role_to_msg(Role),
                                    ItemMsg = notice:item_to_msg(MagicItems),
                                    notice:send(53, util:fbin(?L(<<"霎时间天降风雷，原来是~s在猎魔时竟然猎得了传说中的极品魔晶~s！{open, 27, 我要猎魔, #00ff00}">>), [RoleMsg, ItemMsg]));
                                _ ->
                                    ok
                            end,
                            {ok, NewRole, 0, [], NewFree, [{NextId, BaseId, Price}]}
                    end;
                _ ->
                    {false, util:fbin(?L(<<"相关物品[~p]不存在">>), [BaseId])}
            end;
        _ ->
            {false, ?L(<<"此猎魔NPC不存在">>)}
    end.

%% 更新激活NPC列表
%% update_npc_list(NpcIds, {NpcId, _CallType}) when NpcId < 1 orelse NpcId > 5 ->
%%    NpcIds;
%% update_npc_list(NpcIds, {NpcId, CallType}) ->
%%    case lists:keyfind(NpcId, 1, NpcIds) of
%%        {NpcId, CallType1} when CallType1 >= CallType -> NpcIds;
%%        {NpcId, _} -> lists:keyreplace(NpcId, 1, NpcIds, {NpcId, CallType});
%%        _ -> [{NpcId, CallType} | NpcIds]
%%    end.

%% 出售物品
sell(Role = #role{pet = PetBag = #pet_bag{hunt = Hunt = #pet_hunt{items = Items}}}, Id) ->
    case lists:keyfind(Id, 1, Items) of
        {_, BaseId, _Num} ->
            case get_item_info(BaseId) of
                {_BaseId, _UseType, Price} when Price > 0 ->
                    GL = [#gain{label = coin_bind, val = Price}],
                    case role_gain:do(GL, Role) of
                        {false, _} -> {false, <<>>};
                        {ok, NRole} ->
                            ItemName = case item_data:get(BaseId) of
                                {ok, #item_base{name = Name1}} -> Name1;
                                _ -> ?L(<<"未知物品">>)
                            end,
                            log:log(log_coin, {<<"魔晶物品出售">>, util:fbin("出售物品:~s", [ItemName]), Role, NRole}),
                            Inform = notice_inform:gain_loss(GL, ?L(<<"猎魔物品出售">>)),
                            notice:inform(Role#role.pid, Inform),
                            NewItems = lists:keydelete(Id, 1, Items),
                            NewRole = NRole#role{pet = PetBag#pet_bag{hunt = Hunt#pet_hunt{items = NewItems}}},
                            {ok, NewRole}
                    end;
                _ ->
                    {false, ?L(<<"价格异常，出售失败">>)}
            end;
        _ ->
            {false, ?L(<<"物品不存在">>)}
    end.

%% 拾取物品
pick(Role = #role{pet = PetBag = #pet_bag{hunt = Hunt = #pet_hunt{items = Items}}}, Id) ->
    case lists:keyfind(Id, 1, Items) of
        {_, BaseId, _Num} ->
            case item:make(BaseId, 0, 1) of
                {ok, [#item{use_type = 0}]} ->
                    {false, ?L(<<"此物品只能出售，不能拾取">>)};
                {ok, GetItems} ->
                    case add_new_items_to_bag(Role, GetItems) of
                        {ok, NRole} ->
                            NewItems = lists:keydelete(Id, 1, Items),
                            NewRole = NRole#role{pet = PetBag#pet_bag{hunt = Hunt#pet_hunt{items = NewItems}}},
                            {ok, NewRole};
                        _ ->
                            {false, ?L(<<"魔晶背包已满，请先清理后拾取">>)}
                    end;
                _ ->
                    {false, ?L(<<"物品数据异常，拾取失败">>)}
            end;
        _ ->
            {false, ?L(<<"物品不存在">>)}
    end.

%% 魔晶兑换
exchange(Role, BaseId) ->
    case pet_magic_data:get_exchange(BaseId) of
        Num when is_integer(Num) andalso Num > 0 ->
            GL = [#loss{label = item, val = [33085, 0, Num]}],
            case role_gain:do(GL, Role) of
                {false, _} -> {false, ?L(<<"兑换失败，魔晶碎片不足">>)};
                {ok, NRole} ->
                    case add_new_items_to_bag(NRole, BaseId) of
                        {ok, NewRole} ->
                            %% Inform = notice_inform:gain_loss(GL ++ [#gain{label = item, val = [BaseId, 0, 1]}], ?L(<<"魔晶兑换">>)),
                            %% notice:inform(Role#role.pid, Inform),
                            {ok, NewRole};
                        {false, Reason} ->
                            {false, Reason}
                    end
            end;
        _ ->
            {false, ?L(<<"该魔晶无法兑换">>)}
    end.

%% 增加[新生成物品]到魔晶背包
add_new_items_to_bag(Role, []) -> 
    {ok, Role};
add_new_items_to_bag(Role, BaseId) when is_integer(BaseId) ->
    case item:make(BaseId, 0, 1) of
        {ok, GetItems} -> add_new_items_to_bag(Role, GetItems);
        _ -> {false, ?L(<<"无法生成魔晶数据">>)}
    end;
add_new_items_to_bag(Role, Items) ->
    NewItems = update_new_item_attr(Items, []),
    case storage:add(pet_magic, Role, NewItems) of
        {ok, NewPetMagic} ->
            NewRole = Role#role{pet_magic = NewPetMagic},
            {ok, NewRole};
        _ ->
            {false, ?L(<<"魔晶背包已满">>)}
    end.

%% 更新物品属性
update_new_item_attr([], Items) -> Items;
update_new_item_attr([Item = #item{base_id = BaseId, attr = Attr} | T], Items) ->
    Exp = case item_data:get(BaseId) of
        {ok, #item_base{feed_exp = Feed}} -> Feed;
        _ -> 1
    end,
    NewAttr0 = update_attr(Attr, {?attr_pet_eqm_lev, 100, 1}),
    NewAttr = update_attr(NewAttr0, {?attr_pet_eqm_exp, 100, Exp}),
    update_new_item_attr(T, [Item#item{attr = NewAttr} | Items]).

%% 魔晶背包开新格子
add_volume(Role = #role{pet_magic = PetMagic = #pet_magic{volume = Volume, free_pos = FreePos}}, Num) ->
    case sum_volume_price(Volume + 1, Num, 0, []) of
        {ok, NewVol, Price, AddPos} when Price > 0 ->
            GL = [#loss{label = gold, val = Price}],
            case role_gain:do(GL, Role) of
                {false, L} -> {false, L#loss.label};
                {ok, NRole} ->
                    Inform = notice_inform:gain_loss(GL, ?L(<<"魔晶背包开格子">>)),
                    notice:inform(Role#role.pid, Inform),
                    NewFreePos = lists:sort(AddPos ++ FreePos),
                    NewRole = NRole#role{pet_magic = PetMagic#pet_magic{volume = NewVol, free_pos = NewFreePos}},
                    {ok, NewRole}
            end;
        _ -> {false, ?L(<<"格子已开满，不能继续开启">>)}
    end.

%%----------------------------------------
%% 物品移动处理
%%----------------------------------------

%% 魔晶背包到魔晶背包
bag_to_bag(Role = #role{link = #link{conn_pid = ConnPid}, pet_magic = PetMagic = #pet_magic{items = Items, free_pos = FreePos}}, ItemId, Pos) ->
    case lists:keyfind(ItemId, #item.id, Items) of
        false -> {false, ?L(<<"魔晶物品不存在">>)};
        #item{pos = Pos} ->
            {false, ?L(<<"非法操作">>)};
        Item1 = #item{pos = Pos1} ->
            Flag = lists:member(Pos, FreePos),
            case lists:keyfind(Pos, #item.pos, Items) of
                Item2 = #item{id = ItemId2} -> %% 目标位置存在物品 吞噬
                    case item_devour(0, Role, Item1, Item2) of
                        {false, Reason} -> {false, Reason};
                        {ok, _AddExp, NewItem} ->
                            storage_api:refresh_client_item(del, ConnPid, [{?storage_pet_magic, [Item1]}]),
                            storage_api:refresh_client_item(refresh, ConnPid, [{?storage_pet_magic, [NewItem]}]),
                            NewItems0 = lists:keydelete(ItemId, #item.id, Items),
                            NewItems = lists:keyreplace(ItemId2, #item.id, NewItems0, NewItem),
                            NewFreePos = lists:sort([Pos1 | FreePos]),
                            NewRole = Role#role{pet_magic = PetMagic#pet_magic{items = NewItems, free_pos = NewFreePos}},
                            log:log(log_item_del, {[Item1], <<"魔晶背包">>, <<"魔晶吞噬">>, Role}),
                            NewRole1 = role_listener:acc_event(NewRole, {134, {get_item_attr(lev, NewItem) - get_item_attr(lev, Item2), NewItem}}), %%宠物魔晶升N级
                            {ok, NewRole1}
                    end;
                false when Flag =:= true -> %% 目标位置空 移动
                    NewItem1 = Item1#item{pos = Pos},
                    storage_api:refresh_client_item(refresh, ConnPid, [{?storage_pet_magic, [NewItem1]}]),
                    NewItems = lists:keyreplace(ItemId, #item.id, Items, NewItem1),
                    NewFreePos = lists:sort([Pos1 | [P || P <- FreePos, P =/= Pos]]),
                    NewRole = Role#role{pet_magic = PetMagic#pet_magic{items = NewItems, free_pos = NewFreePos}},
                    {ok, NewRole};
                _ ->
                    {false, ?L(<<"非法目标位置，操作失败">>)}
            end
    end.

%% 魔晶背包到装备栏
bag_to_eqm(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = PetId}}}, PetId, ItemId, Pos) -> %% 出战宠物
    case do_bag_to_eqm(Role, Pet, ItemId, Pos) of
        {false, Reason} -> {false, Reason};
        {ok, NPet, NRole} ->
            NewPet = pet_api:reset(NPet, Role),
            pet_api:push_pet(refresh, [NewPet], Role),
            NRole1 = NRole#role{pet = PetBag#pet_bag{active = NewPet}},
            NewRole = role_listener:special_event(NRole1, {20020, NewPet#pet.fight_capacity}),
            rank:listener(pet, NewRole),
            {ok, NewRole}
    end;
bag_to_eqm(Role = #role{pet = PetBag = #pet_bag{pets = Pets}}, PetId, ItemId, Pos) -> %% 非出战宠物
    case lists:keyfind(PetId, #pet.id, Pets) of
        false -> {false, ?L(<<"查找不到仙宠数据">>)};
        Pet ->
            case do_bag_to_eqm(Role, Pet, ItemId, Pos) of
                {false, Reason} -> {false, Reason};
                {ok, NPet, NRole} ->
                    NewPet = pet_api:reset(NPet, Role),
                    pet_api:push_pet(refresh, [NewPet], Role),
                    NewPets = lists:keyreplace(PetId, #pet.id, Pets, NewPet),
                    NewRole = NRole#role{pet = PetBag#pet_bag{pets = NewPets}},
                    rank:listener(pet, NewRole),
                    {ok, NewRole}
            end
    end.

do_bag_to_eqm(Role = #role{link = #link{conn_pid = ConnPid}, pet_magic = PetMagic = #pet_magic{items = Items, free_pos = FreePos}}, Pet = #pet{eqm_num = EqmNum, eqm = Eqm}, ItemId, Pos) ->
    case lists:keyfind(ItemId, #item.id, Items) of
        false -> {false, ?L(<<"查找不到魔晶物品数据">>)};
        Item1 = #item{pos = Pos1, type = Type, use_type = UseType} ->
            TypeNum = length([It || It <- Eqm, It#item.type =:= Type]),
            case lists:keyfind(Pos, #item.pos, Eqm) of
                Item2 = #item{id = ItemId2} -> %% 目标物品存在 吞噬
                    case item_devour(0, Role, Item1, Item2) of
                        {false, Reason} -> {false, Reason};
                        {ok, _AddExp, NewItem} ->
                            NewItems = lists:keydelete(ItemId, #item.id, Items),
                            NewFreePos = lists:sort([Pos1 | FreePos]),
                            NewRole = Role#role{pet_magic = PetMagic#pet_magic{items = NewItems, free_pos = NewFreePos}},
                            NewEqm = lists:keyreplace(ItemId2, #item.id, Eqm, NewItem),
                            NewPet = Pet#pet{eqm = NewEqm},
                            storage_api:refresh_client_item(del, ConnPid, [{?storage_pet_magic, [Item1]}]),
                            pet_api:push_pet(refresh_item, {NewPet, [NewItem]}, Role),
                            log:log(log_item_del, {[Item1], <<"背包->装备栏">>, <<"魔晶吞噬">>, Role}),
                            NewRole1 = role_listener:acc_event(NewRole, {134, {get_item_attr(lev, NewItem) - get_item_attr(lev, Item2), NewItem}}), %%宠物魔晶升N级
                            {ok, NewPet, NewRole1}
                    end;
                false when UseType =/= 3 ->
                    {false, ?L(<<"该物品不可装备">>)};
                false when Pos > 0 andalso Pos =< EqmNum andalso TypeNum >= 2 -> %% 目标位置为空 移动
                    {false, ?L(<<"同一类型魔晶同时只能穿戴2件">>)};
                false when Pos > 0 andalso Pos =< EqmNum -> %% 目标位置为空 移动
                    NewItem1 = Item1#item{pos = Pos},
                    NewItems = lists:keydelete(ItemId, #item.id, Items),
                    NewFreePos = lists:sort([Pos1 | FreePos]),
                    NewRole = Role#role{pet_magic = PetMagic#pet_magic{items = NewItems, free_pos = NewFreePos}},
                    NewEqm = [NewItem1 | Eqm],
                    NewPet = Pet#pet{eqm = NewEqm},
                    storage_api:refresh_client_item(del, ConnPid, [{?storage_pet_magic, [Item1]}]),
                    pet_api:push_pet(add_item, {NewPet, [NewItem1]}, Role),
                    rank_celebrity:listener(pet_magic_lev, Role, get_item_attr(lev, NewItem1)), %% 名人榜 魔晶升级
                    {ok, NewPet, NewRole};
                _ ->
                    {false, ?L(<<"目标位置非法">>)}
            end
    end.

%% 装备栏到装备栏
eqm_to_eqm(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = PetId}}}, PetId, ItemId, Pos) -> %% 出战宠物
    case do_eqm_to_eqm(Role, Pet, ItemId, Pos) of
        {false, Reason} -> {false, Reason};
        {ok, NewPet, NRole} ->
            NRole1 = NRole#role{pet = PetBag#pet_bag{active = NewPet}},
            NewRole = role_listener:special_event(NRole1, {20020, NewPet#pet.fight_capacity}),
            rank:listener(pet, NewRole),
            {ok, NewRole}
    end;
eqm_to_eqm(Role = #role{pet = PetBag = #pet_bag{pets = Pets}}, PetId, ItemId, Pos) -> %% 非出战宠物
    case lists:keyfind(PetId, #pet.id, Pets) of
        false -> {false, ?L(<<"查找不到仙宠数据">>)};
        Pet ->
            case do_eqm_to_eqm(Role, Pet, ItemId, Pos) of
                {false, Reason} -> {false, Reason};
                {ok, NewPet, NRole} ->
                    NewPets = lists:keyreplace(PetId, #pet.id, Pets, NewPet),
                    NewRole = NRole#role{pet = PetBag#pet_bag{pets = NewPets}},
                    rank:listener(pet, NewRole),
                    {ok, NewRole}
            end
    end.

do_eqm_to_eqm(Role, Pet = #pet{eqm_num = EqmNum, eqm = Eqm}, ItemId, Pos) ->
    case lists:keyfind(ItemId, #item.id, Eqm) of
        false -> {false, ?L(<<"查找不到仙宠装备数据">>)};
        #item{pos = Pos} ->
            {false, ?L(<<"非法操作">>)};
        Item1 ->
            case lists:keyfind(Pos, #item.pos, Eqm) of
                Item2 = #item{id = ItemId2} -> %% 目标存在物品 吞噬
                    case item_devour(0, Role, Item1, Item2) of
                        {false, Reason} -> {false, Reason};
                        {ok, _AddExp, NewItem} ->
                            NewEqm0 = lists:keydelete(ItemId, #item.id, Eqm),
                            NewEqm = lists:keyreplace(ItemId2, #item.id, NewEqm0, NewItem),
                            NewPet = pet_api:reset(Pet#pet{eqm = NewEqm}, Role),
                            pet_api:push_pet(refresh, [NewPet], Role), 
                            pet_api:push_pet(del_item, {NewPet, [Item1]}, Role),
                            pet_api:push_pet(refresh_item, {NewPet, [NewItem]}, Role),
                            log:log(log_item_del, {[Item1], <<"装备栏">>, <<"魔晶吞噬">>, Role}),
                            NewRole = role_listener:acc_event(Role, {134, {get_item_attr(lev, NewItem) - get_item_attr(lev, Item2), NewItem}}), %%宠物魔晶升N级
                            {ok, NewPet, NewRole}
                    end;
                false when Pos > 0 andalso Pos =< EqmNum -> %% 目标位置为空
                    NewItem = Item1#item{pos = Pos},
                    NewEqm = lists:keyreplace(ItemId, #item.id, Eqm, NewItem),
                    NewPet = Pet#pet{eqm = NewEqm},
                    pet_api:push_pet(del_item, {NewPet, [Item1]}, Role),
                    pet_api:push_pet(add_item, {NewPet, [NewItem]}, Role),
                    {ok, NewPet, Role};
                _ ->
                    {false, ?L(<<"目标位置非法">>)}
            end
    end.

%% 装备栏到魔晶背包
eqm_to_bag(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = PetId}}}, PetId, ItemId, Pos) -> %% 出战宠物
    case do_eqm_to_bag(Role, Pet, ItemId, Pos) of
        {false, Reason} -> {false, Reason};
        {ok, NPet, NRole} ->
            NewPet = pet_api:reset(NPet, Role),
            pet_api:push_pet(refresh, [NewPet], Role),
            NewRole = NRole#role{pet = PetBag#pet_bag{active = NewPet}},
            rank:listener(pet, NewRole),
            {ok, NewRole}
    end;
eqm_to_bag(Role = #role{pet = PetBag = #pet_bag{pets = Pets}}, PetId, ItemId, Pos) -> %% 非出战宠
    case lists:keyfind(PetId, #pet.id, Pets) of
        false -> {false, ?L(<<"查找不到仙宠数据">>)};
        Pet ->
            case do_eqm_to_bag(Role, Pet, ItemId, Pos) of
                {false, Reason} -> {false, Reason};
                {ok, NPet, NRole} ->
                    NewPet = pet_api:reset(NPet, Role),
                    pet_api:push_pet(refresh, [NewPet], Role),
                    NewPets = lists:keyreplace(PetId, #pet.id, Pets, NewPet),
                    NewRole = NRole#role{pet = PetBag#pet_bag{pets = NewPets}},
                    rank:listener(pet, NewRole),
                    {ok, NewRole}
            end
    end.

do_eqm_to_bag(Role = #role{link = #link{conn_pid = ConnPid}, pet_magic = PetMagic = #pet_magic{next_id = NextId, items = Items, free_pos = FreePos}}, Pet = #pet{eqm = Eqm}, ItemId, Pos) ->
    case lists:keyfind(ItemId, #item.id, Eqm) of
        false -> {false, ?L(<<"仙宠装备不存在">>)};
        Item1 ->
            Flag = lists:member(Pos, FreePos),
            case lists:keyfind(Pos, #item.pos, Items) of
                Item2 = #item{id = ItemId2} -> %% 目标存在物品 吞噬
                    case item_devour(0, Role, Item1, Item2) of
                        {false, Reason} -> {false, Reason};
                        {ok, _AddExp, NewItem} ->
                            storage_api:refresh_client_item(refresh, ConnPid, [{?storage_pet_magic, [NewItem]}]),
                            NewEqm = lists:keydelete(ItemId, #item.id, Eqm),
                            NewItems = lists:keyreplace(ItemId2, #item.id, Items, NewItem),
                            NewRole = Role#role{pet_magic = PetMagic#pet_magic{items = NewItems}},
                            NewPet = Pet#pet{eqm = NewEqm},
                            log:log(log_item_del, {[Item1], <<"装备栏->背包">>, <<"魔晶吞噬">>, Role}),
                            pet_api:push_pet(del_item, {NewPet, [Item1]}, Role),
                            rank:listener(pet, NewRole),
                            NewRole1 = role_listener:acc_event(NewRole, {134, {get_item_attr(lev, NewItem) - get_item_attr(lev, Item2), NewItem}}), %%宠物魔晶升N级
                            {ok, NewPet, NewRole1}
                    end;
                false when Flag =:= true -> %% 目标为空 移动
                    NewItem1 = Item1#item{id = NextId, pos = Pos},
                    storage_api:refresh_client_item(add, ConnPid, [{?storage_pet_magic, [NewItem1]}]),
                    NewItems = [NewItem1 | Items],
                    NewFreePos = [P || P <- FreePos, P =/= Pos],
                    NewRole = Role#role{pet_magic = PetMagic#pet_magic{next_id = NextId + 1, items = NewItems, free_pos = NewFreePos}},
                    NewEqm = lists:keydelete(ItemId, #item.id, Eqm),
                    NewPet = Pet#pet{eqm = NewEqm},
                    pet_api:push_pet(del_item, {NewPet, [Item1]}, Role),
                    rank:listener(pet, NewRole),
                    {ok, NewPet, NewRole};
                _ ->
                    {false, ?L(<<"目标位置非法">>)}
            end
    end.

%% 一键吞噬
devour_all(Role = #role{link = #link{conn_pid = ConnPid}, pet_magic = PetMagic = #pet_magic{volume = Volume, items = Items}}) ->
    case devour_item_diff(Items, false, [], []) of
        {false, _, _} -> {false, ?L(<<"当前没有可吞噬魔晶">>)};
        {TargetItem, UnDoItems, DoItems} ->
            case do_devour_all(Role, [TargetItem | DoItems], [], 0) of
                {false, Reason} -> 
                    {false, Reason};
                {ok, _NewItems, [], _AddExp} ->
                    {false, ?L(<<"当前没有可吞噬魔晶">>)};
                {ok, NItems = [NewTargetItem | _], DelItems, AddExp} ->
                    PosList = lists:seq(1, Volume), 
                    {NewFreePos, NewItems} = sort_item(NItems ++ UnDoItems, PosList, []),
                    storage_api:refresh_client_item(del, ConnPid, [{?storage_pet_magic, DelItems}]),
                    storage_api:refresh_client_item(refresh, ConnPid, [{?storage_pet_magic, NewItems}]),
                    log:log(log_item_del, {DelItems, <<"一键吞噬">>, <<"魔晶吞噬">>, Role}),
                    NewRole = role_listener:acc_event(Role, {134, {get_item_attr(lev, NewTargetItem) - get_item_attr(lev, TargetItem), NewTargetItem}}), %%宠物魔晶升N级
                    {ok, AddExp, NewRole#role{pet_magic = PetMagic#pet_magic{free_pos = NewFreePos, items = NewItems}}}
            end
    end.
do_devour_all(_Role, Items, DelItems, AddExp) when length(Items) < 2 -> 
    {ok, Items, DelItems, AddExp};
do_devour_all(Role, Items = [Item1, Item2 | T], DelItems, AddExp) ->
    case item_devour(1, Role, Item2, Item1) of
        {false, Reason} when DelItems =:= [] -> 
            {false, Reason};
        {false, _Reason} -> 
            {ok, Items, DelItems, AddExp};
        {ok, Exp, NewItem} ->
            do_devour_all(Role, [NewItem | T], [Item2 | DelItems], AddExp + Exp)
    end.
devour_item_diff([], TargetItem, UnItems, Items) -> {TargetItem, UnItems, Items};
devour_item_diff([Item = #item{bind = 1} | T], TargetItem, UnItems, Items) -> %% 绑定物品不参与
    devour_item_diff(T, TargetItem, [Item | UnItems], Items);
devour_item_diff([Item = #item{attr = Attr} | T], TargetItem, UnItems, Items) ->
    case lists:keyfind(?attr_pet_eqm_lev, 1, Attr) of
        {_, _, 12} -> devour_item_diff(T, TargetItem, [Item | UnItems], Items); %% 满级魔晶不参与
        _ when TargetItem =:= false -> devour_item_diff(T, Item, UnItems, Items);
        _ ->
            {Item1, NewTargetItem} = find_devour_item_target(TargetItem, Item),
            devour_item_diff(T, NewTargetItem, UnItems, [Item1 | Items])
    end.
find_devour_item_target(Item1 = #item{use_type = UseType1}, Item2 = #item{use_type = UseType2}) when UseType1 > UseType2 -> {Item2, Item1};
find_devour_item_target(Item1 = #item{use_type = UseType1}, Item2 = #item{use_type = UseType2}) when UseType1 < UseType2 -> {Item1, Item2};
find_devour_item_target(Item1 = #item{quality = Q1}, Item2 = #item{quality = Q2}) when Q1 > Q2 -> {Item2, Item1};
find_devour_item_target(Item1 = #item{quality = Q1}, Item2 = #item{quality = Q2}) when Q1 < Q2 -> {Item1, Item2};
find_devour_item_target(Item1 = #item{base_id = BaseId1, attr = Attr1}, Item2 = #item{base_id = BaseId2, attr = Attr2}) ->
    case {lists:keyfind(?attr_pet_eqm_lev, 1, Attr1), lists:keyfind(?attr_pet_eqm_lev, 1, Attr2)} of
        {{_Type1, _Flag1, Lev1}, {_Type2, _Flag2, Lev2}} when Lev1 > Lev2 -> {Item2, Item1};
        {{_Type1, _Flag1, Lev1}, {_Type2, _Flag2, Lev2}} when Lev1 < Lev2 -> {Item1, Item2};
        _ when BaseId1 >= BaseId2 -> {Item2, Item1};
        _ -> {Item1, Item2}
    end.
sort_item([], FreePos, Items) -> %% 整理物品
    {FreePos, Items};
sort_item([Item | T], [Pos | FreePos], Items) ->
    sort_item(T, FreePos, [Item#item{pos = Pos} | Items]).

%% 物品吞噬 
%% Item1 = #item{} 被吞噬物品
%% Item2 = #item{} 目标吞噬物品
item_devour(_Type, _Role, #item{bind = 1}, _Item2) ->
    {false, ?L(<<"锁定物品不能被吞噬">>)};
item_devour(_Type, _Role, #item{use_type = 3}, #item{use_type = UseType}) when UseType < 3 ->
    {false, ?L(<<"晶核不能吞噬魔晶">>)};
item_devour(_Type, _Role, #item{use_type = 3, quality = Q1}, #item{use_type = 3, quality = Q2}) when Q1 > Q2 ->
    {false, ?L(<<"低品质魔晶不能吞噬高品质魔晶">>)};
item_devour(Type, Role, Item1 = #item{base_id = BaseId1, attr = Attr1}, Item2 = #item{quality = Color, polish_list = PolishList, base_id = BaseId2, attr = Attr2}) -> 
    case {lists:keyfind(?attr_pet_eqm_lev, 1, Attr2), lists:keyfind(?attr_pet_eqm_exp, 1, Attr2)} of
        {{_, FlagLev2, Lev2}, {_, FlagExp2, Exp2}} ->
            case pet_magic_data:get_item_attr(BaseId2, Lev2 + 1) of
                false when Lev2 =/= 1 -> 
                    {false, ?L(<<"魔晶已满级，不级继续吞噬">>)};
                _ ->
                    case lists:keyfind(?attr_pet_eqm_exp, 1, Attr1) of
                        {_, _Flag, Exp1} ->
                            {NewLev, NewExp} = do_pet_item_lev(BaseId2, Lev2, Exp1 + Exp2),
                            {ItemName2, BaseAttr} = case item_data:get(BaseId2) of
                                {ok, #item_base{name = Name2, attr = BAttr1}} when is_list(BAttr1) -> {Name2, BAttr1};
                                _ -> {?L(<<"未知物品">>), []}
                            end,
                            ItemName1 = case item_data:get(BaseId1) of
                                {ok, #item_base{name = Name1}} -> Name1;
                                _ -> ?L(<<"未知物品">>)
                            end,
                            {AppLevAttr, CondPolishAttr} = case pet_magic_data:get_item_attr(BaseId2, NewLev) of
                                #pet_item_attr{attr = AppAttr2, polish_list = PolishAttr2} when is_list(AppAttr2) -> 
                                    {AppAttr2, [{label_to_code(AttrLabel), A1, A2, A3} || {AttrLabel, A1, A2, A3} <- PolishAttr2]};
                                _ -> 
                                    {[], []}
                            end,
                            case NewLev > Lev2 of
                                false when Type =:= 0 ->
                                    role:pack_send(Role#role.pid, 10931, {57, util:fbin(?L(<<"[~s]将[~s]吞噬，获得了~p经验">>), [ItemName2, ItemName1, NewExp - Exp2]), []});
                                true when Type =:= 0 ->
                                    role:pack_send(Role#role.pid, 10931, {57, util:fbin(?L(<<"[~s]将[~s]吞噬，获得了~p经验，等级升至~p级">>), [ItemName2, ItemName1, NewExp - Exp2, NewLev]), []});
                                _ -> ok
                            end,
                            %% 重新计算装备的基础属性数据
                            NewBaseAttr = attr_join(BaseAttr, AppLevAttr),
                            OtherAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- Attr2, Flag =/= 100],
                            NewAttr0 = NewBaseAttr ++ OtherAttr,
                            NewAttr1 = update_attr(NewAttr0, {?attr_pet_eqm_lev, FlagLev2, NewLev}),
                            NewAttr2 = update_attr(NewAttr1, {?attr_pet_eqm_exp, FlagExp2, NewExp}),
                            NewAttr = update_polish_attr(Lev2, NewLev, NewAttr2, CondPolishAttr, []),
                            NewPolishList = [{PoId, update_polish_attr(Lev2, NewLev, PoAttr, CondPolishAttr, [])} || {PoId, PoAttr} <- PolishList], 
                            NewItem2 = Item2#item{attr = NewAttr, polish_list = NewPolishList},
                            log:log(log_handle_all, {12666, <<"魔晶吞噬">>, util:fbin("(~s:~p,经验:~p->~p,等级~p->~p)(被吞噬物品=>~s:~p,经验:~p)", [ItemName2, BaseId2, Exp2, NewExp, Lev2, NewLev, ItemName1, BaseId1, Exp1]), [Item1, Item2, NewItem2], Role}),
                            rank_celebrity:listener(pet_magic_lev, Role, NewLev), %% 名人榜 魔晶升级
                            campaign_listener:handle({pet_magic_lev, Color}, Role, Lev2, NewLev), %% 魔晶升级活动
                            {ok, NewExp - Exp2, NewItem2};
                        _ ->
                            {false, ?L(<<"魔晶数据异常，操作失败">>)}
                    end
            end;
        _ -> 
            {false, ?L(<<"目标魔晶数据异常，操作失败">>)}
    end.

%% 属性整合
attr_join(BaseAttr, []) -> BaseAttr;
attr_join(BaseAttr, [{Label, Val1} | T]) ->
    case label_to_code(Label) of
        false -> %% 配置数据错误 找不到相关Label对应号
            attr_join(BaseAttr, T);
        CodeName ->
            NewBaseAttr = case lists:keyfind(CodeName, 1, BaseAttr) of
                {CodeName, _Flag2, Val2} -> lists:keyreplace(CodeName, 1, BaseAttr, {CodeName, 100, Val1 + Val2});
                _ -> [{CodeName, 100, Val1} | BaseAttr]
            end,
            attr_join(NewBaseAttr, T)
    end;
attr_join(BaseAttr, [_ | T]) ->
    attr_join(BaseAttr, T).

%% 魔晶升级 洗练属性更新
update_polish_attr(_OldLev, _NewLev, [], _PolistAttr, Attr) -> Attr; 
update_polish_attr(OldLev, NewLev, [{CodeName, Flag, Val} | T], PolishAttr, Attr) when OldLev =/= NewLev andalso Flag >= 100010 -> %% 等级发生变化 洗炼属性重新计算 
    Star = Flag div 100000,
    PosBind = Flag rem 100,
    NewFlag = (Star * 1000 + NewLev) * 100 + PosBind,
    Tuple = case lists:keyfind(CodeName, 1, PolishAttr) of
        {_, _A1, [Min, Max], _B1} when (Max - Min) >= 10 andalso CodeName =/= ?attr_pet_skill_id -> 
            NewVal = round(Min + (Max - Min) * Star / 10),
            ?DEBUG("重新计算洗炼属性数据 ~p -> ~p", [Val, NewVal]),
            {CodeName, NewFlag, NewVal};
        _ ->
            {CodeName, NewFlag, Val}
    end,
    update_polish_attr(OldLev, NewLev, T, PolishAttr, [Tuple | Attr]);
update_polish_attr(OldLev, NewLev, [I | T], PolishAttr, Attr) -> 
    update_polish_attr(OldLev, NewLev, T, PolishAttr, [I | Attr]).

%% 魔晶吞噬升级
do_pet_item_lev(BaseId, Lev, Exp) ->
    case pet_magic_data:get_item_attr(BaseId, Lev) of
        #pet_item_attr{exp = NeedExp} when Exp >= NeedExp andalso NeedExp =/= 0 ->
            case pet_magic_data:get_item_attr(BaseId, Lev + 1) of
                false -> %% 没有下一级
                    {Lev, NeedExp};
                #pet_item_attr{exp = NeedExp1} when NeedExp1 =/= 0 -> %% 魔晶还有下一级数据 升级
                    do_pet_item_lev(BaseId, Lev + 1, Exp);
                _ -> %% 魔晶满级
                    {Lev + 1, NeedExp}
            end;
        _ ->
            {Lev, Exp}
    end.

%%-------------------------------------------------
%% 魔晶锁定、解锁
%%-------------------------------------------------

%% 背包物品
lock_item_bag(Role = #role{link = #link{conn_pid = ConnPid}, pet_magic = PetMagic = #pet_magic{items = Items}}, ItemId, Bind) ->
    case lists:keyfind(ItemId, #item.id, Items) of
        false -> 
            {false, ?L(<<"查找不到魔晶">>)};
        #item{use_type = UseType} when UseType =/= 3 ->
            {false, ?L(<<"只能对魔晶装备进行锁定">>)};
        Item ->
            NewItem = Item#item{bind = Bind},
            NewItems = lists:keyreplace(ItemId, #item.id, Items, NewItem),
            NewRole = Role#role{pet_magic = PetMagic#pet_magic{items = NewItems}},
            storage_api:refresh_client_item(refresh, ConnPid, [{?storage_pet_magic, [NewItem]}]),
            {ok, NewRole}
    end.

%% 装备栏物品
lock_item_eqm(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = PetId}}}, PetId, ItemId, Bind) ->
    case do_lock_item_eqm(Role, Pet, ItemId, Bind) of
        {false, Reason} ->
            {false, Reason};
        {ok, NewPet} ->
            NewRole = Role#role{pet = PetBag#pet_bag{active = NewPet}},
            {ok, NewRole}
    end;
lock_item_eqm(Role = #role{pet = PetBag = #pet_bag{pets = Pets}}, PetId, ItemId, Bind) ->
    case lists:keyfind(PetId, #pet.id, Pets) of
        false -> 
            {false, ?L(<<"查找不到宠物">>)};
        Pet ->
            case do_lock_item_eqm(Role, Pet, ItemId, Bind) of
                {false, Reason} -> 
                    {false, Reason};
                {ok, NewPet} ->
                    NewPets = lists:keyreplace(PetId, #pet.id, Pets, NewPet),
                    NewRole = Role#role{pet = PetBag#pet_bag{pets = NewPets}},
                    {ok, NewRole}
            end
    end.
do_lock_item_eqm(Role, Pet = #pet{eqm = Eqm}, ItemId, Bind) ->
    case lists:keyfind(ItemId, #item.id, Eqm) of
        false -> 
            {false, ?L(<<"查找不到魔晶">>)};
        Item ->
            NewItem = Item#item{bind = Bind},
            NewEqm = lists:keyreplace(ItemId, #item.id, Eqm, NewItem),
            NewPet = Pet#pet{eqm = NewEqm},
            pet_api:push_pet(refresh_item, {NewPet, [NewItem]}, Role),
            {ok, NewPet}
    end.

%%-------------------------------------------------
%% 魔晶洗炼
%%-------------------------------------------------

%% 背包魔晶洗炼
polish_bag(Role = #role{link = #link{conn_pid = ConnPid}, pet_magic = PetMagic = #pet_magic{items = Items}}, ItemId, LockInfo) -> 
    case do_polish_item(Role, Items, ItemId, 0, LockInfo) of
        {false, Reason} -> {false, Reason};
        {ok, NRole, NewItems, NewItem} ->
            storage_api:refresh_client_item(refresh, ConnPid, [{?storage_pet_magic, [NewItem]}]),
            NewRole = NRole#role{pet_magic = PetMagic#pet_magic{items = NewItems}},
            {ok, NewRole, NewItem}
    end.

%% 背包魔晶批量洗炼
polish_batch_bag(Role = #role{pet_magic = PetMagic = #pet_magic{items = Items}}, ItemId, LockInfo) -> 
    case do_polish_item(Role, Items, ItemId, 1, LockInfo) of
        {false, Reason} -> {false, Reason};
        {ok, NRole, NewItems, NewItem} ->
            NewRole = NRole#role{pet_magic = PetMagic#pet_magic{items = NewItems}},
            {ok, NewRole, NewItem}
    end.

%% 宠物装备栏魔晶洗炼
polish_eqm(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = PetId, eqm = Eqm}}}, PetId, ItemId, Type, LockInfo) ->
    case do_polish_item(Role, Eqm, ItemId, Type, LockInfo) of
        {false, Reason} -> {false, Reason};
        {ok, NRole, NewEqm, Item} ->
            NewPet = case Type of
                0 -> %% 单洗 直接改变属性 需重新计算 
                    Pet1 = pet_api:reset(Pet#pet{eqm = NewEqm}, Role),
                    pet_api:push_pet(refresh, [Pet1], Role),
                    pet_api:push_pet(refresh_item, {Pet1, [Item]}, Role),
                    Pet1;
                _ ->
                    Pet#pet{eqm = NewEqm}
            end,
            NRole1 = NRole#role{pet = PetBag#pet_bag{active = NewPet}},
            NewRole = role_listener:special_event(NRole1, {20020, NewPet#pet.fight_capacity}),
            rank:listener(pet, NewRole),
            {ok, NewRole, Item}
    end;
polish_eqm(Role = #role{pet = PetBag = #pet_bag{pets = Pets}}, PetId, ItemId, Type, LockInfo) -> 
    case lists:keyfind(PetId, #pet.id, Pets) of 
        false -> {false, ?L(<<"查找不到宠物数据">>)};
        Pet = #pet{eqm = Eqm} ->
            case do_polish_item(Role, Eqm, ItemId, Type, LockInfo) of
                {false, Reason} -> {false, Reason};
                {ok, NRole, NewEqm, Item} ->
                    NewPet = case Type of
                        0 -> %% 单洗 直接改变属性 需重新计算
                            Pet1 = pet_api:reset(Pet#pet{eqm = NewEqm}, Role),
                            pet_api:push_pet(refresh, [Pet1], Role),
                            pet_api:push_pet(refresh_item, {Pet1, [Item]}, Role),
                            Pet1;
                        _ ->
                            Pet#pet{eqm = NewEqm}
                    end,
                    NewPets = lists:keyreplace(PetId, #pet.id, Pets, NewPet),
                    NewRole = NRole#role{pet = PetBag#pet_bag{pets = NewPets}},
                    rank:listener(pet, NewRole),
                    {ok, NewRole, Item}
            end
    end.

%% 背包魔晶洗炼结果选择
polish_select_bag(Role = #role{link = #link{conn_pid = ConnPid}, pet_magic = PetMagic = #pet_magic{items = Items}}, ItemId, PolishId) -> 
    case lists:keyfind(ItemId, #item.id, Items) of
        false -> {false, ?L(<<"物品不存在">>)};
        Item = #item{polish_list = PolishL} ->
            case lists:keyfind(PolishId, 1, PolishL) of
                false -> {false, ?L(<<"查找不到洗炼结果数据">>)};
                {_Id, PolishAttr} ->
                    NewItem = replace_polish_attr(Item#item{polish_list = []}, PolishAttr),
                    storage_api:refresh_client_item(refresh, ConnPid, [{?storage_pet_magic, [NewItem]}]),
                    NewItems = lists:keyreplace(ItemId, #item.id, Items, NewItem),
                    NewRole = Role#role{pet_magic = PetMagic#pet_magic{items = NewItems}},
                    {ok, NewRole}
            end
    end.

%% 装备栏魔晶洗炼选择
polish_select_eqm(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = PetId, eqm = Eqm}}}, PetId, ItemId, PolishId) -> %% 出战宠物
    case lists:keyfind(ItemId, #item.id, Eqm) of
        false -> {false, ?L(<<"魔晶物品不存在">>)};
        Item = #item{polish_list = PolishL} ->
            case lists:keyfind(PolishId, 1, PolishL) of
                false -> {false, ?L(<<"查找不到洗炼结果数据">>)};
                {_Id, PolishAttr} ->
                    NewItem = replace_polish_attr(Item#item{polish_list = []}, PolishAttr),
                    NewEqm = lists:keyreplace(ItemId, #item.id, Eqm, NewItem),
                    NewPet = pet_api:reset(Pet#pet{eqm = NewEqm}, Role),
                    pet_api:push_pet(refresh, [NewPet], Role),
                    pet_api:push_pet(refresh_item, {NewPet, [NewItem]}, Role),
                    NRole1 = Role#role{pet = PetBag#pet_bag{active = NewPet}},
                    NewRole = role_listener:special_event(NRole1, {20020, NewPet#pet.fight_capacity}),
                    rank:listener(pet, NewRole),
                    {ok, NewRole}
            end
    end;
polish_select_eqm(Role = #role{pet = PetBag = #pet_bag{pets = Pets}}, PetId, ItemId, PolishId) -> %% 非出战宠物
    case lists:keyfind(PetId, #pet.id, Pets) of
        false -> {false, ?L(<<"查找不到宠物">>)};
        Pet = #pet{eqm = Eqm} ->
            case lists:keyfind(ItemId, #item.id, Eqm) of
                false -> {false, ?L(<<"魔晶物品不存在">>)};
                Item = #item{polish_list = PolishL} ->
                    case lists:keyfind(PolishId, 1, PolishL) of
                        false -> {false, ?L(<<"查找不到洗炼结果数据">>)};
                        {_Id, PolishAttr} ->
                            NewItem = replace_polish_attr(Item#item{polish_list = []}, PolishAttr),
                            NewEqm = lists:keyreplace(ItemId, #item.id, Eqm, NewItem),
                            NewPet = pet_api:reset(Pet#pet{eqm = NewEqm}, Role),
                            pet_api:push_pet(refresh, [NewPet], Role),
                            pet_api:push_pet(refresh_item, {NewPet, [NewItem]}, Role),
                            NewPets = lists:keyreplace(PetId, #pet.id, Pets, NewPet),
                            NewRole = Role#role{pet = PetBag#pet_bag{pets = NewPets}},
                            rank:listener(pet, NewRole),
                            {ok, NewRole}
                    end
            end
    end.

%% 洗炼物品价格
polish_loss(0, #item{quality = ?quality_green}) -> [#loss{label = coin_all, val = 1000}, #loss{label = item, val = [27000, 0, 1]}];
polish_loss(0, #item{quality = ?quality_blue}) -> [#loss{label = coin_all, val = 1000}, #loss{label = item, val = [27001, 0, 1]}];
polish_loss(0, #item{quality = ?quality_purple}) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [27002, 0, 1]}];
polish_loss(0, #item{quality = ?quality_orange}) -> [#loss{label = coin_all, val = 3000}, #loss{label = item, val = [27003, 0, 1]}];
polish_loss(1, #item{quality = ?quality_green}) -> [#loss{label = coin_all, val = 6000}, #loss{label = item, val = [27000, 0, 6]}];
polish_loss(1, #item{quality = ?quality_blue}) -> [#loss{label = coin_all, val = 6000}, #loss{label = item, val = [27001, 0, 6]}];
polish_loss(1, #item{quality = ?quality_purple}) -> [#loss{label = coin_all, val = 12000}, #loss{label = item, val = [27002, 0, 6]}];
polish_loss(1, #item{quality = ?quality_orange}) -> [#loss{label = coin_all, val = 18000}, #loss{label = item, val = [27003, 0, 6]}];
polish_loss(_, _Item) -> false.

%% 装备栏魔晶洗炼
do_polish_item(Role, Items, ItemId, Type, LockInfo) when is_integer(ItemId) ->
    case lists:keyfind(ItemId, #item.id, Items) of
        false -> {false, ?L(<<"魔晶物品不存在">>)};
        Item ->
            do_polish_item(Role, Items, Item, Type, LockInfo)
    end;
do_polish_item(Role, Items, Item, Type, LockInfo) -> 
    LockAttr = get_lock_attr(Item, LockInfo),
    case item_polish(Item, Type, LockAttr) of
        {false, Reason} -> {false, Reason};
        {ok, _NewAttrL, NewItem} ->
            case polish_loss(Type, Item) of
                false -> {false, ?L(<<"查找不到物品洗炼价格">>)};
                GL1 ->
                    HasLockNum = case storage:find(Role#role.bag#bag.items, #item.base_id, 33101) of
                        {false, _R} -> 0;
                        {ok, Num2, _, _, _} -> Num2
                    end,
                    NeedLockNum = case Type of
                        0 -> length(LockAttr);
                        1 -> length(LockAttr) * 6
                    end,
                    GL2 = if
                        NeedLockNum =:= 0 -> [];   %% 不需要洗炼锁
                        HasLockNum =:= 0 -> [#loss{label = gold, val = pay:price(?MODULE, do_polish, NeedLockNum)}]; %% 身上无洗炼锁
                        HasLockNum >= NeedLockNum -> [#loss{label = item, val = [33101, 0, NeedLockNum]}];      %% 身上洗炼锁足够
                        true -> [#loss{label = gold, val = pay:price(?MODULE, do_polish, (NeedLockNum - HasLockNum))}, #loss{label = item, val = [33101, 0, HasLockNum]}]
                    end,
                    GL = GL1 ++ GL2,
                    case role_gain:do(GL, Role) of
                        {false, #loss{label = coin_all}} -> {false, coin_all};
                        {false, #loss{label = gold}} -> {false, gold};
                        {false, _} -> {false, ?L(<<"洗炼石不足">>)};
                        {ok, NRole} ->
                            Inform = notice_inform:gain_loss(GL, ?L(<<"魔晶洗炼">>)),
                            notice:inform(Role#role.pid, Inform),
                            NewItems = lists:keyreplace(Item#item.id, #item.id, Items, NewItem),
                            log:log(log_coin, {<<"魔晶洗炼">>, util:fbin("洗炼类型[是否批洗:~p]", [Type]), Role, NRole}),
                            {ok, NRole, NewItems, NewItem}
                    end
            end
    end.

%% 洗炼传闻
%% notice_polish(Role, AttrL) ->
%%     case activity_luck:get_luck(petmagic, Role) of
%%         N when N > 0 ->
%%             SkillAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- AttrL, Name =:= ?attr_pet_skill_id, Flag rem 10 =/= 1], %% 天赋技能列表
%%             HighStarAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- AttrL, Name =/= ?attr_pet_skill_id, Flag rem 10 =/= 1, Flag div 100000 =:= 10],
%%             do_notice_polish(Role, SkillAttr =/= [], HighStarAttr =/= []);
%%         _ ->
%%             ok
%%     end.
%% do_notice_polish(Role, true, true) -> 
%%     RoleMsg = notice:role_to_msg(Role),
%%     Msg = util:fbin(?L(<<"">>), [RoleMsg]),
%%     notice:send(62, Msg);
%% do_notice_polish(_Role, _, _) ->
%%     ok.

%% 获取一个物品的锁定属性
get_lock_attr(#item{attr = Attr}, LockInfo) ->
    PolishAttr = [{Flag rem 100 div 10, {Name, Flag, Value}} || {Name, Flag, Value} <- Attr, Flag >= 100010], %% 过滤旧洗炼属性数据
    get_lock_attr(PolishAttr, LockInfo, []).
get_lock_attr([], _LockList, LockAttr) -> LockAttr;
get_lock_attr([{Pos, {CodeName, Flag, Value}} | T], LockInfo, LockAttr) ->
    case element(Pos, LockInfo) of
        1 -> %% 此属性标志为锁定 洗炼不改变
            NewPos = length(LockAttr) + 1,
            NewFlag = Flag div 100 * 100 + NewPos * 10 + 1,
            get_lock_attr(T, LockInfo, [{CodeName, NewFlag, Value} | LockAttr]);
        _ -> 
            get_lock_attr(T, LockInfo, LockAttr)
    end.

%% 更换物品洗炼属性
replace_polish_attr(Item = #item{attr = Attr}, PolishAttr) ->
    NewAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- Attr, Flag < 100010], %% 过滤旧洗炼属性数据
    Item#item{attr = NewAttr ++ PolishAttr}.

%% 物品洗炼
item_polish(Item, 0, LockAttr) -> %% 单洗 
    case do_item_polish(Item, LockAttr) of
        {false, Reason} -> {false, Reason};
        {ok, AttrL} ->
            ?DEBUG("新洗炼属性数据~w", [AttrL]),
            NewItem = replace_polish_attr(Item, AttrL),
            {ok, AttrL, NewItem}
    end;
item_polish(Item, 1, LockAttr) -> %% 批洗
    case item_polish_batch(Item, LockAttr, 6, []) of
        {false, Reason} -> {false, Reason};
        {ok, PolishL} ->
            NewItem = Item#item{polish_list = PolishL},
            {ok, PolishL, NewItem}
    end.

%% 物品批量洗
item_polish_batch(_Item, _LockAttr, 0, PolishL) -> 
    {ok, PolishL};
item_polish_batch(Item, LockAttr, N, PolishL) ->
    case do_item_polish(Item, LockAttr) of
        {false, Reason} -> {false, Reason};
        {ok, AttrL} ->
            item_polish_batch(Item, LockAttr, N - 1, [{N, AttrL} | PolishL])
    end.

%% 对物品进行洗炼
do_item_polish(_Item = #item{base_id = BaseId, attr = Attr}, LockAttr) ->
    ItemLev = case lists:keyfind(?attr_pet_eqm_lev, 1, Attr) of
        {_Type, _Flag, Lev} -> Lev;
        _ -> 1
    end,
    case pet_magic_data:get_item_attr(BaseId, ItemLev) of
        ItemAttr = #pet_item_attr{} ->
            do_item_polish(ItemAttr, LockAttr);
        _ ->
            {false, ?L(<<"查找不到洗炼配置数据">>)}
    end;
do_item_polish(#pet_item_attr{polish = {_Min, Max}}, LockAttr) when length(LockAttr) >= Max ->
    {false, ?L(<<"当前锁定属性条件已是最大洗炼条数">>)};
do_item_polish(ItemAttr = #pet_item_attr{polish = {Min, Max}, polish_list = PolishL = [_ | _]}, LockAttr) when Min > 0 andalso Max >= Min ->
    N = util:rand(Min, Max), %% 随机生成洗炼条数
    RandL = [Rand || {_Label, _N, _L, Rand} <- PolishL],
    MaxRand = round(lists:sum(RandL)),
    polish_attr(N - length(LockAttr), length(LockAttr), MaxRand, ItemAttr, LockAttr);
do_item_polish(_ItemAttr, _LockAttr) -> 
    {false, ?L(<<"此魔晶物品不支持洗炼">>)}.

%% 进行多条属性洗炼
polish_attr(0, _LockNum, _MaxRand, _ItemAttr, []) ->
    {false, ?L(<<"洗炼配置数据异常，无法洗出属性">>)};
polish_attr(N, _LockNum, _MaxRand, _ItemAttr, AttrL) when N =< 0 -> 
    {ok, AttrL};
polish_attr(N, LockNum, MaxRand, ItemAttr, AttrL) ->
    case do_polish_attr(0, LockNum, MaxRand, ItemAttr, AttrL) of
        {false, Reason} -> {false, Reason};
        {ok, NewAttrL} ->
            polish_attr(N - 1, LockNum, MaxRand, ItemAttr, NewAttrL)
    end.

%% 尝试洗出一条属性
do_polish_attr(N, _LockNum, _MaxRand, _ItemAttr, AttrL) when N >= 100 -> %% 洗超出一定次数仍无法出属性 放弃
    {ok, AttrL};
do_polish_attr(N, LockNum, MaxRand, ItemAttr = #pet_item_attr{polish_list = PolishL, lev = Lev}, AttrL) -> 
    RandVal = util:rand(1, MaxRand),
    case rand_polish_attr(RandVal, PolishL) of
        {Label, A, L, _Rand} when is_list(L) andalso (length(L) >= 2 orelse Label =:= attr_pet_skill_id) -> 
            case label_to_code(Label) of
                false ->
                    ?ERR("魔晶洗炼数据配置错误Label:~s", [Label]),
                    {false, ?L(<<"洗炼数据Label配置错误">>)};
                NameCode ->
                    {Star, Value} = case NameCode of
                        ?attr_pet_skill_id -> 
                            {rand_star(LockNum), util:rand_list(L)};
                        _ ->
                            case L of
                                [X1, X1] -> %% 数值一致 无范围 10星
                                    {10, X1};
                                [X1, X2 | _] when X2 - X1 < 10 andalso X1 > 0 andalso X2 > X1 ->
                                    Val = util:rand(X1, X2),
                                    X = round(1 + 9 * (Val - X1) / (X2 - X1)),
                                    {X, Val};
                                [Min, Max | _] ->
                                    X = rand_star(LockNum),
                                    Val = round(Min + (Max - Min) * X / 10),
                                    {X, Val}
                            end
                    end,
                    AttrPos = length(AttrL) + 1,
                    Flag = (Star * 1000 + Lev) * 100 + AttrPos * 10,
                    NewAttr = {NameCode, Flag, Value},
                    case [Code1 || {Code1, _X, _Y} <- AttrL, Code1 =:= NameCode] of
                        Records when length(Records) < A -> %% 可以出现
                            {ok, [NewAttr | AttrL]};
                        _ ->
                            do_polish_attr(N + 1, LockNum, MaxRand, ItemAttr, AttrL)
                    end
            end;
        _ ->
            {false, ?L(<<"洗炼数据配置错误">>)}
    end.
rand_polish_attr(_RandVal, [Attr]) -> Attr;
rand_polish_attr(RandVal, [{Label, N, L, Rand} | _T]) when RandVal =< Rand -> {Label, N, L, Rand};
rand_polish_attr(RandVal, [{_Label, _N, _L, Rand} | T]) ->
    rand_polish_attr(RandVal - Rand, T);
rand_polish_attr(RandVal, [_ | T]) -> 
    rand_polish_attr(RandVal, T).

%% 随机生成星数
rand_star(LockNum) ->
    RandVal = util:rand(1, 10000),
    pet_magic_data:get_polish_star(LockNum, RandVal).

%% 标签转换成相应数值
label_to_code(attr_pet_hp) -> ?attr_pet_hp;
label_to_code(attr_pet_mp) -> ?attr_pet_mp;
label_to_code(attr_pet_dmg) -> ?attr_pet_dmg;
label_to_code(attr_pet_critrate) -> ?attr_pet_critrate;
label_to_code(attr_pet_defence) -> ?attr_pet_defence;
label_to_code(attr_pet_tenacity) -> ?attr_pet_tenacity;
label_to_code(attr_pet_hitrate) -> ?attr_pet_hitrate;
label_to_code(attr_pet_evasion) -> ?attr_pet_evasion;
label_to_code(attr_pet_dmg_magic) -> ?attr_pet_dmg_magic;
label_to_code(attr_pet_anti_js) -> ?attr_pet_anti_js;
label_to_code(attr_pet_anti_attack) -> ?attr_pet_anti_attack;
label_to_code(attr_pet_anti_seal) -> ?attr_pet_anti_seal;
label_to_code(attr_pet_anti_stone) -> ?attr_pet_anti_stone;
label_to_code(attr_pet_anti_stun) -> ?attr_pet_anti_stun;
label_to_code(attr_pet_anti_sleep) -> ?attr_pet_anti_sleep;
label_to_code(attr_pet_anti_taunt) -> ?attr_pet_anti_taunt;
label_to_code(attr_pet_anti_silent) -> ?attr_pet_anti_silent;
label_to_code(attr_pet_anti_poison) -> ?attr_pet_anti_poison;
label_to_code(attr_pet_blood) -> ?attr_pet_blood;
label_to_code(attr_pet_rebound) -> ?attr_pet_rebound;
label_to_code(attr_pet_skill_kill) -> ?attr_pet_skill_kill;
label_to_code(attr_pet_skill_protect) -> ?attr_pet_skill_protect;
label_to_code(attr_pet_skill_anima) -> ?attr_pet_skill_anima;
label_to_code(attr_pet_resist_metal) -> ?attr_pet_resist_metal;
label_to_code(attr_pet_resist_wood) -> ?attr_pet_resist_wood;
label_to_code(attr_pet_resist_water) -> ?attr_pet_resist_water;
label_to_code(attr_pet_resist_fire) -> ?attr_pet_resist_fire;
label_to_code(attr_pet_resist_earth) -> ?attr_pet_resist_earth;
label_to_code(attr_pet_skill_id) -> ?attr_pet_skill_id;
label_to_code(Label) when is_integer(Label) -> Label;
label_to_code(_Label) -> false.

%%-------------------------------------------------
%% 内部方法
%%-------------------------------------------------

%% 随机生成激活NPC
%% rand_npc(NpcId, #pet_npc{rand = {V1, V2, V3}}) ->
%%     Sum = trunc(V1 + V2 + V3),
%%     case util:rand(1, Sum) of
%%         Rand when Rand =< V1 -> NpcId;
%%         Rand when Rand =< V1 + V2 -> 0;
%%         _ -> NpcId + 1
%%     end.

%% 随机获得一个物品
rand_item(NpcId) ->
    ItemIds = pet_magic_data:list_npc_item(NpcId),
    ItemList = [pet_magic_data:get_npc_item(NpcId, BaseId) || BaseId <- ItemIds],
    RandList = [Item#pet_npc_item.rand || Item <- ItemList],
    Max = trunc(lists:sum(RandList)),
    RandVal = util:rand(1, Max),
    rand_item(RandVal, ItemList).
rand_item(_RandVal, [NpcItem]) -> NpcItem;
rand_item(RandVal, [NpcItem = #pet_npc_item{rand = Rand} | _T]) when RandVal =< Rand -> NpcItem;
rand_item(RandVal, [#pet_npc_item{rand = Rand} | T]) ->
    rand_item(RandVal - Rand, T);
rand_item(_RandVal, _L) -> false.

%% 获取物品相关信息
get_item_info(BaseId) ->
    case item_data:get(BaseId) of 
        {ok, #item_base{use_type = UseType, value = Value}} -> 
            Price = sell_npc_price(Value),
            {BaseId, UseType, Price};
        _ -> 
            {BaseId, 0, 0}
    end.

%% 查找物品出售价格
sell_npc_price([{sell_npc, Price} | _]) -> Price;
sell_npc_price([_ | T]) -> sell_npc_price(T);
sell_npc_price(_) -> 0.

%% 召唤NPC价格
%% call_npc_price(4) -> [#loss{label = gold, val = 200}];
%% call_npc_price(_NpcId) -> false.

%% 开启魔晶背包格子价格
sum_volume_price(Pos, 0, Val, AddPos) -> {ok, Pos - 1, Val, AddPos};
sum_volume_price(Pos, N, Val, AddPos) ->
    case storage_volume_price(Pos) of
        false -> {ok, Pos - 1, Val, AddPos};
        Price ->
            sum_volume_price(Pos + 1, N -1, Val + Price, [Pos | AddPos])
    end.
storage_volume_price(Pos) when Pos =< 24 -> pay:price(?MODULE, add_volume, null);
storage_volume_price(_) -> false.

%% 获取列表最大值
%% to_client_npc_id([], L) -> 
%%     [NpcId || NpcId <- L, NpcId =/= 0];
%% to_client_npc_id([{NpcId, _I} | T], L) -> 
%%     to_client_npc_id(T, [NpcId | L]);
%% to_client_npc_id([_I | T], L) -> 
%%     to_client_npc_id(T, L).

%% 更新属性
update_attr(AttrL, {Type, Flag, Value}) ->
    case lists:keyfind(Type, 1, AttrL) of
        {Type, _Flag, _Value} -> lists:keyreplace(Type, 1, AttrL, {Type, Flag, Value});
        _ -> [{Type, Flag, Value} | AttrL]
    end.

%% 获取魔晶等级
get_item_attr(lev, #item{attr = Attr}) ->
    case lists:keyfind(?attr_pet_eqm_lev, 1, Attr) of
        {_, _, Lev} -> Lev;
        _ -> 1
    end;
get_item_attr(exp, #item{attr = Attr}) ->
    case lists:keyfind(?attr_pet_eqm_exp, 1, Attr) of
        {_, _, Exp} -> Exp;
        _ -> 1
    end;
get_item_attr(_, _Item) -> 1.
