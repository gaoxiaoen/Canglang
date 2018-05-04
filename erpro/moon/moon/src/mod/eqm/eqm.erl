%%----------------------------------------------------
%% 装备处理
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(eqm).
-export([
        newhand_equip/1
        ,puton/2
        ,puton_init_eqm/2
        ,calc/1
        ,calc_mount/1
        ,calc_embed/1
        ,find_eqm/2
        ,find_eqm_by_id/2
        ,type_to_pos/1
        ,check_swap_eqm/2
        ,check_eqm_pos/1
        ,loss_durability/2
        ,check_suit_lock/1
        ,suit_lock/2
        ,suit_unlock/2
        ,eqm_type/1
        ,puton_newhand_equip/3
    ]
).
-include("common.hrl").
-include("role.hrl").
-include("item.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("eqm.hrl").
-include("dungeon.hrl").
-include("condition.hrl").

-define(eqm_attacktype, [?item_fei_jian, ?item_fa_zhang, ?item_chang_qiang, ?item_jie_zhi, ?item_shen_gong, ?item_bi_shou]).
-define(eqm_injuredtype, [?item_hu_shou, ?item_hu_wan, ?item_ku_zi, ?item_yao_dai, ?item_yi_fu, ?item_xie_zi,
                ?item_shi_zhuang, ?item_wing, ?item_hu_fu, ?item_weapon_dress, ?item_jewelry_dress,
                ?item_footprint, ?item_chat_frame, ?item_text_style
            ]).

puton_init_eqm(EqmBaseId, Role = #role{career = Career}) ->
    role:send_buff_begin(),
    case item:make(EqmBaseId, 1, 1) of
        {false, Reason} -> 
            role:send_buff_clean(),
            {false, Reason};
        {ok, [Item = #item{}]} ->
            Item1 = eqm_api:calc_point(Item, Career),
            case item_data:get(EqmBaseId) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {false, Reason};
                {ok, #item_base{condition = Cond, use_type = UseType}} when UseType =:= 3 ->
                        case role_cond:check(Cond, Role) of %% 检查是否满足使用条件
                            {false, RCond} ->
                                role:send_buff_clean(),
                                {false, RCond#condition.msg};
                            true ->
                                case do_puton_init_eqm(Role, Item1) of
                                    {false, Reason} ->
                                        role:send_buff_clean(),
                                        {false, Reason};
                                    {ok, Role1} ->
                                        Role2 = role_listener:special_event(Role1, {1070, EqmBaseId}), %% 触发远方来信
                                        rank:listener(equip, Role, Role2),
                                        Role3 = eqm:check_suit_lock(Role2),
                                        Role4 = looks:calc(Role3),
                                        role_listener:eqm_event(Role4, update),
                                        Role6 = role_api:push_attr(Role4),
                                        rank:listener(equip, Role, Role6),
                                        Role7 = medal:listener(eqm, Role6),
                                        Role8 = medal:listener(item, Role7, {EqmBaseId, 1}),
                                        rank_celebrity:c_suit(Role8),
                                        looks:refresh(Role, Role8),
                                        role:send_buff_flush(),
                                        {ok, Role8}
                                end
                        end;
                {ok, _} ->
                    role:send_buff_clean(),
                    ?ERR("此物品不可穿戴"),
                    {ok, Role}
        end
    end.

do_puton_init_eqm(Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm}, Item = #item{type = Type}) ->
    case Type =:= ?item_equip of
        false ->
            {false, ?L(<<"此物品无法穿戴">>)};
        true ->
            case find_eqm(Eqm, Item) of
                {Eqm_pos} ->
                    NewItem = Item#item{pos = Eqm_pos, id = Eqm_pos},
                    PutItem = storage:bind_mount(NewItem),
                    NewEqm = [PutItem | Eqm],
                    storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem}]),
                    {ok, Role#role{eqm = NewEqm}};
                {Eqm_pos, [Getoff]} ->
                    NewPut = Item#item{pos = Eqm_pos, id = Eqm_pos},
                    PutItem = storage:bind_mount(NewPut),
                    storage_api:del_item_info(ConnPid, [{?storage_eqm, Getoff}]),
                    storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem}]),
                    {ok, Role#role{eqm = [PutItem | (Eqm -- [Getoff])]}} %% BackItem 直接扔掉了
            end
    end.


%% 此函数只能用于新手穿装备，缺少很多条件检查
%% newhand_equip() -> Eqms = [#item]
newhand_equip(Career) ->
    case newhand_equip_data:get(Career) of
        [] -> [];
        EquipIds ->
            case make_eqm(EquipIds,[]) of
                false -> [];
                Equips ->
                    puton_newhand_equip(Career, Equips, [])
            end
    end.

make_eqm([], Items) -> Items;
make_eqm([BaseId|T], Items) ->
    case item:make(BaseId, 1, 1) of
        {ok, Items1} -> item:make(T, Items1++Items);
        false -> false
    end.

puton_newhand_equip(_Career, [], Eqms) -> Eqms;
puton_newhand_equip(Career, [Item = #item{base_id = BaseId, type = Type} | T], Eqms) ->
    case Type =:= ?item_equip of
        false ->
            ?ERR("新手装备不是装备..."),
            puton_newhand_equip(Career, T, Eqms);
        true ->
            Pos = baseid_to_pos(BaseId),
            NewItem = Item#item{pos = Pos, id = Pos},
            NewItem1 = eqm_api:calc_point(NewItem, Career),
            NewEqms = [NewItem1 | Eqms],
            puton_newhand_equip(Career, T, NewEqms)
    end.

%% 穿上某件装备
puton(Role = #role{career = Career, link = #link{conn_pid = ConnPid}, eqm = Eqm, bag = Bag}, Item = #item{type = Type, pos = Pos}) ->
%%    case lists:member(Type, ?eqm_type) of
    case Type =:= ?item_equip of
        false -> {false, ?L(<<"此物品无法穿戴">>)};
        true ->
            case find_eqm(Eqm, Item) of
                {Eqm_pos} ->
                    {ok, NewBag = #bag{free_pos = FreePos}} = storage:del_pos(Bag, [{Item#item.pos, 1}]),
                    NewItem = Item#item{pos = Eqm_pos, id = Eqm_pos},
                    PutItem = storage:bind_mount(NewItem),
                    PutItem1 = eqm_api:calc_point(PutItem, Career),
                    NewEqm = [PutItem1 | Eqm],
                    storage_api:del_item_info(ConnPid, [{?storage_bag, Item}]),
                    storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem1}]),
                    {ok, Role#role{eqm = NewEqm, bag = NewBag#bag{free_pos = FreePos -- [Pos]}}, Item#item{quantity = 0}};
                {Eqm_pos, [Getoff]} ->
                    NewPut = Item#item{pos = Eqm_pos, id = Eqm_pos},
                    BackItem = Getoff#item{id = Item#item.id, pos = Pos, quantity = 1},
                    PutItem = storage:bind_mount(NewPut),
                    PutItem1 = eqm_api:calc_point(PutItem, Career),
                    storage_api:del_item_info(ConnPid, [{?storage_eqm, Getoff},{?storage_bag, Item}]),
                    storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem1}, {?storage_bag, BackItem}]),
                    {ok, Role#role{eqm = [PutItem1 | (Eqm -- [Getoff])]}, BackItem}
            end
    end.

%% 检测当前装备列表是否销毁锁
check_suit_lock(Role) -> Role.

%% %% 判断装备套装ID
%% check_armor_suit(Eqm, ArmorId) ->
%%     NewEqm = [Item || Item = #item{type = Type} <- Eqm, lists:member(Type, [6, 7, 8, 9, 10, 11]) =:= true],
%%     do_get(armor, NewEqm, ArmorId).
%% 
%% %% 获取饰品套装ID
%% check_jewelry_suit(Eqm, JewelryId) ->
%%     NewEqm = [Item || Item = #item{type = Type} <- Eqm, lists:member(Type, [12, 13]) =:= true],
%%     do_get(jewelry, NewEqm, JewelryId).
%% 
%% do_get(armor, Eqm, ArmorId) ->
%%     do_get(armor, Eqm, ArmorId, []);
%% do_get(jewelry, Eqm, JewelryId) ->
%%     do_get(jewelry, Eqm, JewelryId, []).
%% do_get(armor, [], _ArmorId, Armor) ->
%%     case length(Armor) >= 1 of
%%         true -> true;
%%         false -> false
%%     end;
%% do_get(jewelry, [], _JewelryId, Jewelry) ->
%%     case length(Jewelry) >= 1 of
%%         true -> true;
%%         false -> false
%%     end;
%% do_get(Flag, [Item | T], SuitId, Suit) ->
%%     S = get_set(Item),
%%     case S =:= SuitId of
%%         true -> do_get(Flag, T, SuitId, [Item | Suit]);
%%         false -> do_get(Flag, T, SuitId, Suit)
%%     end.

%% 锁定
suit_lock(armor, Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm, suit_attr = {_, _, JewelryFlag, JewelryId}}) ->
    SetList = [get_set(Item) || Item = #item{type = Type} <- Eqm, lists:member(Type, [6, 7, 8, 9, 10, 11]) =:= true],
    case find_suit(armor, SetList) of
        0 -> %%不能锁定
            {false, ?L(<<"没有套装属性,无法锁定">>)};
        SetId ->
            NewLock = {1, SetId, JewelryFlag, JewelryId},
            ?DEBUG("NewLock:~w",[NewLock]),
            sys_conn:pack_send(ConnPid, 10346, NewLock),
            {ok, Role#role{suit_attr = NewLock}}
    end;

suit_lock(jewelry, Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm, suit_attr = {ArmorFlag, ArmorId, _, _}}) ->
    SetList = [get_set(Item) || Item = #item{type = Type} <- Eqm, lists:member(Type, [12, 13]) =:= true],
    case find_suit(jewelry, SetList) of
        0 -> %%不能锁定
            {false, ?L(<<"没有集齐套装属性,无法锁定">>)};
        SetId ->
            NewLock = {ArmorFlag, ArmorId, 1, SetId},
            ?DEBUG("NewLock:~w",[NewLock]),
            sys_conn:pack_send(ConnPid, 10346, NewLock),
            {ok, Role#role{suit_attr = NewLock}}
    end.

suit_unlock(armor, #role{suit_attr = {0, _, _JewelryFlag, _JewelryId}}) ->
    {false, ?L(<<"没有锁定套装属性,无需解除锁定">>)};
suit_unlock(armor, Role = #role{link = #link{conn_pid = ConnPid}, suit_attr = {_ArmorFlag, _, JewelryFlag, JewelryId}}) ->
    sys_conn:pack_send(ConnPid, 10346, {0, 0, JewelryFlag, JewelryId}),
    {ok, Role#role{suit_attr = {0, 0, JewelryFlag, JewelryId}}};
suit_unlock(jewelry, #role{suit_attr = {_ArmorFlag, _ArmorId, 0, _}}) ->
    {false, ?L(<<"没有锁定套装属性,无需解除锁定">>)};
suit_unlock(jewelry, Role = #role{link = #link{conn_pid = ConnPid}, suit_attr = {ArmorFlag, ArmorId, _JewelryFlag, _}}) ->
    sys_conn:pack_send(ConnPid, 10346, {ArmorFlag, ArmorId, 0, 0}),
    {ok, Role#role{suit_attr = {ArmorFlag, ArmorId, 0, 0}}}.

find_suit(armor, SetList) -> 
    case length(SetList) of
        6 ->
            [Id | _T] = SetList,
            do_find_suit(SetList, Id);
        _ -> 0
    end;
find_suit(jewelry, SetList) ->
    case length(SetList) of
        4 ->
            [Id | _T] = SetList,
            do_find_suit(SetList, Id);
        _ -> 0
    end.

do_find_suit([], SetId) -> SetId;
do_find_suit([0 | _T], _SetId) -> 0;
do_find_suit([SetId | T], SetId) -> do_find_suit(T, SetId);
do_find_suit([_ | _T], _SetId) -> 0. 

%% 获取Item的set_id
get_set(#item{base_id = BaseId}) ->
    case item_data:get(BaseId) of
        {ok, BaseItem} ->
            BaseItem#item_base.set_id;
        {false, _R} ->
            0
    end.

%% 查找装备
find_eqm(Eqm, #item{base_id=BaseId}) ->
    case baseid_to_pos(BaseId) of
         Pos ->
             case do_find(Pos, Eqm) of
                 [] -> {Pos};
                 I -> {Pos, I}
            end
    end.

%% 通过ID/Pos查找装备 
%% 在装备栏中,Id=Pos
find_eqm_by_id(Eqm, Id) ->
   List = [Item || Item <- Eqm, eqm_type(Item#item.base_id)=:=Id],
   case List of
       [] ->
           false;
       [Item] ->
           {ok, Item}
   end.

% get_pos(BaseId)->
%     BaseId rem 10000 div 100 rem 10.

%% 比较2个装备是否能交换
check_swap_eqm(Id1, Id2) ->
    if
        Id1 =:= 8 andalso Id2 =:= 9 -> true;
        Id1 =:= 9 andalso Id2 =:= 8 -> true;
        Id1 =:= 11 andalso Id2 =:= 12 -> true;
        Id1 =:= 12 andalso Id2 =:= 11 -> true;
        Id1 =:= Id2 -> true;
        true -> false
    end.

%% 检查装备位置合法性
check_eqm_pos(Pos) ->
    Pos >= 1 andalso Pos =< 20.

%% 计算装备属性效果: 穿脱一件装备时由role进程调用计算
%% 基本属性(base/宝石/洗练) + 套装属性 + 强化  
%% @spec calc_attr(Role) -> NewRole
%% Eqm = [{Type, #item{}} | ...] 装备列表
%% Type = 装备位置
%% Role = NewRole = #role{} 角色属性
calc(Role = #role{eqm = Eqm}) when is_list(Eqm)->
%    SumEqmAttr = eqm_api:calc_all_eqm_attr(Eqm),
    R1 = calc(Eqm, Role),
    {ok, R2} = eqm_effect:do_hole(Eqm, R1),
%    {ok, R4} = eqm_effect:do_sets(Eqm, R2),
%    {ok, R5} = eqm_effect:do_enchant_add(Eqm, R4),
%    {ok, R6} = eqm_effect:do_enchant(Eqm, SumEqmAttr, R5),
%    {ok, R7} = eqm_effect:do_all(Eqm, SumEqmAttr, R6),
    R2;
calc(R) -> R.
calc([], Role) -> Role;
calc([#item{attr = Attr, type = Type} | T], Role) when Type =/= ?item_zuo_qi ->
    case eqm_effect:do_attr(Attr, Role) of
        {false, _Reason} ->
            ?DEBUG("角色~w装备属性计算失败：~w, 原因：~w~n", [Role#role.id, Attr, _Reason]),
            calc(T, Role); %% 不能识别的装备属性,跳过处理下一条
        {ok, NewRole} ->
            calc(T, NewRole)
    end;
calc([_H | T], Role) ->
    calc(T, Role). %% 容错

calc_embed(Role = #role{eqm = Eqm}) when is_list(Eqm) ->
    NewEqm = [I || I = #item{durability = Durab} <- Eqm, Durab =/= 0], %% 过滤耐久为0装备
    {ok, R1} = eqm_effect:do_embed(NewEqm, Role),
    R1.

%% 计算坐骑属性
calc_mount(Role = #role{eqm = Eqm}) when is_list(Eqm) ->
    NewEqm = [I || I = #item{durability = Durab} <- Eqm, Durab =/= 0], %% 过滤耐久为0装备
    R1 = calc_mount(NewEqm, Role),
    R1;
calc_mount(R) -> R.
calc_mount([], Role) -> Role;
calc_mount([#item{attr = Attr, type = ?item_zuo_qi} | T], Role) ->
    case eqm_effect:do_attr(Attr, Role) of
        {false, _Reason} ->
            ?DEBUG("角色坐骑~w装备属性计算失败：~w, 原因：~w~n", [Role#role.id, Attr, _Reason]),
            calc_mount(T, Role); %% 不能识别的装备属性,跳过处理下一条
        {ok, NewRole} ->
            calc_mount(T, NewRole)
    end;
calc_mount([_H | T], Role) ->
    calc_mount(T, Role). %% 容错

%% @spec loss_durability(Role, Tuple) -> NewRole 
%% @doc 耐久度损失
%% List = {AttackTimes, InjuredTimes} {命中攻击次数, 被命中攻击次数}
loss_durability(Role, [{0, 0}]) -> Role;
loss_durability(Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm}, {AttackTimes, InjuredTimes}) ->
    role:send_buff_begin(),
    NewEqm = do_loss_durability(ConnPid, Eqm, {AttackTimes, InjuredTimes}, []),
    role:send_buff_flush(),
    Role#role{eqm = NewEqm}.
do_loss_durability(_ConnPid, [], {_AttackTimes, _InjuredTimes}, NewEqm) -> NewEqm;
do_loss_durability(ConnPid, [Item = #item{require_lev = Lev, quality = Quality, type = Type, durability = D} | T], {AttackTimes, InjuredTimes}, NewEqm) ->
    NewAttackTimes = case Quality >= ?quality_orange andalso Lev >= 50 of 
        true -> erlang:round(AttackTimes * 1.3);
        false -> AttackTimes
    end,
    NewInjuredTimes = case Quality >= ?quality_orange andalso Lev >= 50 of
        true -> erlang:round(InjuredTimes * 1.3);
        false -> InjuredTimes
    end,
    NewD = case lists:member(Type, ?eqm_attacktype) of
        true ->
            case D > NewAttackTimes of
                true -> D - NewAttackTimes;
                false -> 0
            end;
        false ->
            case lists:member(Type, ?eqm_injuredtype) of
                true ->
                    case D > NewInjuredTimes of
                        true -> D - NewInjuredTimes;
                        false -> 0
                    end;
                false -> D
            end
    end,
    NewItem = Item#item{durability = NewD},
    case NewD =/= D of
        true -> storage_api:refresh_single(ConnPid, {?storage_eqm, NewItem});
        false -> skip
    end,
    do_loss_durability(ConnPid, T, {AttackTimes, InjuredTimes}, [NewItem | NewEqm]).

eqm_type(BaseId) -> baseid_to_pos(BaseId).

baseid_to_pos(BaseId) ->
    Pos = BaseId rem 100000 div 100,
    Pos1 = if
        Pos >= 20 andalso Pos =< 29 -> Pos-10;
        Pos >= 30 andalso Pos =< 39 -> Pos-20;
        true -> Pos
    end,
    Pos1.

type_to_pos(_Type) -> 0.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------

%% find执行函数
do_find(Key, Items) ->
    [Item || Item <- Items, Item#item.pos =:= Key]. 
