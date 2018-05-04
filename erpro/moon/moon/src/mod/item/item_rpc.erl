%%----------------------------------------------------
%% 物品系统相关远程调用
%% @author shawnoyc@163.com
%%----------------------------------------------------

-module(item_rpc).
-export([handle/3]).

-include("common.hrl").
-include("item.hrl").
%%
-include("storage.hrl").
-include("role.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("condition.hrl").
-include("pet.hrl").
-include("setting.hrl").
-include("vip.hrl").
-include("pos.hrl").
-include("npc.hrl").
-include("guild.hrl").
-include("treasure.hrl").
-include("dungeon.hrl").
-include("attr.hrl").
-include("assets.hrl").

-define(item_seed1, 33174).              %% 圣诞树 
-define(item_seed2, 33175).              %% 雪堆 
-define(item_seed3, 33191).              %% 雪堆 
-define(item_seed4, 33111).              %% 玫瑰花
-define(item_seed5, 33221).              %% 周年庆礼花
-define(item_seed6, 33227).              %% 低级散财树
-define(item_seed7, 33228).              %% 中级散财树
-define(item_seed8, 33229).              %% 高级散财树

-define(ITEM_ID, 111411).   %% 修复有问题的物品

%% 获取背包中的物品列表
handle(10300, {}, Role = #role{bag = Bag = #bag{free_pos = _FreePos, volume = Volume, items = Items}}) ->
    Items1 = [Item || Item = #item{base_id = BaseId} <- Items, BaseId =/= ?ITEM_ID],
    Items2 = [I#item{attr = []} || I = #item{base_id = ?ITEM_ID} <- Items],
    Items3 = Items1 ++ Items2,
    {reply, {Volume, Items3}, Role#role{bag = Bag#bag{items = Items3}}};

%% 获取任务背包中的物品列表
handle(10301, {}, #role{task_bag = #task_bag{items = Items}}) ->
    %%?DEBUG("Items = ~w~n",[Items]),
    {reply, {Items}};

%% 获取仓库中的物品列表
handle(10305, {}, #role{store = #store{volume = Volume, items = Items}}) ->
    {reply, {Volume, Items}};

%% 获取装备列表
handle(10306, {}, #role{pid = _Pid, eqm = Eqm}) ->
    {reply, {Eqm}};

%% 查看其他玩家装备列表
handle(10307, {Rid, SrvId}, #role{eqm = Eqm, id = {Rid, SrvId}}) ->
    {reply, {Eqm}};
handle(10307, {Rid, SrvId}, #role{name = Name, sex = Sex}) ->
    case role_api:c_lookup(by_id, {Rid, SrvId}, [#role.sex, #role.eqm, #role.link]) of
        {ok, _N, [InforSex, Eqm, #link{conn_pid = ConnPid}]} ->
           case role_api:is_local_role(SrvId) of
                true -> pack_inform(Name, Sex, InforSex, ConnPid);
                false -> ok
            end,
            {reply, {Eqm}};
        _ -> {ok}
    end;

%% 获取其他玩家外观模型
handle(10308, {Rid, SrvId}, #role{id = {Rid, SrvId}, looks = Looks}) ->
    {reply, {Looks}};
handle(10308, {Rid, SrvId}, #role{}) ->
    case role_api:c_lookup(by_id, {Rid, SrvId}, #role.looks) of
        {ok, _N, Looks} ->
            {reply, {Looks}};
        _ -> {ok}
    end;

%% 获取衣柜
handle(10342, {}, Role) ->
    %% Ret = [{Flag, BaseId, Bind} || {Flag, #item{base_id = BaseId, bind = Bind}} <- Dress],
    dress:pack_send_dress_info(Role),
    {ok};

%% 获取套装属性
handle(10346, {}, #role{suit_attr = LockSuit}) ->
    {reply, LockSuit};

%% 死亡状态:屏蔽所有物品操作
%% 复活: 在角色100协议处理
handle(_Cmd, _Data, #role{status = Status}) when Status =/= ?status_normal ->
    ?DEBUG("该角色状态不允许对物品的操作"),
    {ok};

%% 使用物品
handle(10315, {Id, Num}, Role = #role{bag = Bag = #bag{}}) when Num > 0->
    case storage:find(Bag#bag.items, #item.id, Id) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, #item{quantity = Q, status = ?lock_release}} when Q < Num -> 
            {reply, {0, ?L(<<"物品数量不足">>)}};
        {ok, #item{status = Status}} when Status =/= ?lock_release -> 
            {reply, {0, ?L(<<"物品锁定,不能使用">>)}};
        {ok, Item} -> 
            Flag = item_to_rule(Item),
            case branch_use_item(Flag, Item, Num, Role) of
                {false, Msg} -> {reply, {?false, Msg}};
                {ErrCode, Msg} when is_integer(ErrCode) -> {reply, {ErrCode, Msg}};
                {ok, NewRole} ->
                    {reply, {?true, <<>>}, NewRole};
                {ok, ProtoMsg, NewRole} ->
                    {reply, ProtoMsg, NewRole}
            end
    end;

%% 拆分背包物品
handle(10320, {Id, Num}, Role = #role{bag = Bag}) when Num > 0 ->
    case storage:find(Bag#bag.items, #item.id, Id) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, Item} ->
            role:send_buff_begin(),
            case storage:split_item(bag, Role, Item, Num) of
                {false, Reason} -> 
                    role:send_buff_clean(),
                    {reply, {0, Reason}};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    {reply, {1, ?L(<<"拆分成功">>)}, NewRole}
            end
    end;

%% 拆分仓库物品
handle(10321, {Id, Num}, Role = #role{store = Store}) when Num > 0->
    case storage:find(Store#store.items, #item.id, Id) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, Item} ->
            role:send_buff_begin(),
            case storage:split_item(store, Role, Item, Num) of
                {false, Reason} -> 
                    role:send_buff_clean(),
                    {reply, {0, Reason}};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    {reply, {1, ?L(<<"拆分成功">>)}, NewRole}
            end
    end;

%% 移动背包物品
%% 背包和背包交换
handle(10325, {Id, ?storage_bag, Tpos}, Role = #role{}) when Tpos >= 0 ->
    role:send_buff_begin(),
    case storage:swap_by_pos_same(bag, Role, Id, Tpos) of
        {false, Reason} -> 
            role:send_buff_clean(),
            {reply, {0, Id, Reason}};
        {ok, NewRole} ->
            role:send_buff_flush(),
            {reply, {1, Id, <<>>}, NewRole}
    end;
%% 背包到仓库交换
handle(10325, {Id, ?storage_store, Tpos}, Role = #role{}) when Tpos >= 0 ->
    case check_distance(11009, Role) of
        {false, Reason} -> 
            {reply, {0, Id, Reason}};
        ok ->
            role:send_buff_begin(),
            case storage:swap_by_pos(bag, Id, Tpos, Role) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {0, Id, Reason}};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    {reply, {1, Id, <<>>}, NewRole}
            end
    end;
%% 背包到身上
handle(10325, {_Id, _StorageType, _Tpod}, #role{event = Event}) when ?EventCantPutItem ->
    {reply, {0, _Id, ?L(<<"竞技比赛时，不能随便穿装备的啦">>)}}; 
handle(10325, {Id, ?storage_eqm, Tpos}, Role) when Tpos >= 0 ->
    role:send_buff_begin(),
    case eqm:check_eqm_pos(Tpos) of  %% 目标位置合法以及是可穿戴物品
        true ->
            case storage:move_bag_eqm(Id, Tpos, Role) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {0, Id, Reason}};
                {ok, NewRole, #item{type = _Type, require_lev = ItemLev, quality = ItemQuality}} -> 
                    eqm_api:find_skill_attr_push(NewRole),
                    rank:listener(equip, Role, NewRole),
                    NewRole0 = role_listener:special_event(NewRole, {20013, update}), %%技能等级改变
                    NewRole1 = role_listener:eqm_event(NewRole0, update),
                    Nr = case ItemLev >= 40 andalso ItemQuality >= ?quality_purple  of
                        true -> role_listener:special_event(NewRole1, {1027, finish}); %% 一件紫装
                        false -> NewRole1
                    end,
                    looks:refresh_set(Nr),
                    role:send_buff_flush(),
                    {reply, {1, Id, <<>>}, Nr}
            end;
        _Info ->
            role:send_buff_clean(),
            {reply, {0, Id, <<>>}}  %% 不可穿戴物品
    end;

%% 移动仓库物品
%% 仓库到仓库
handle(10326, {Id, ?storage_store, Tpos}, Role = #role{}) when Tpos >= 0 ->
    case check_distance(11009, Role) of
        {false, Reason} -> 
            {reply, {0, Id, Reason}};
        ok ->
            role:send_buff_begin(),
            case storage:swap_by_pos_same(store, Role, Id, Tpos) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {0, Id, Reason}};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    {reply, {1, Id, <<>>}, NewRole}
            end
    end;
%% 仓库到背包
handle(10326, {Id, ?storage_bag, Tpos}, Role = #role{}) when Tpos >= 0 ->
    case check_distance(11009, Role) of
        {false, Reason} ->  
            {reply, {0, Id, Reason}};
        ok ->
            role:send_buff_begin(),
            case storage:swap_by_pos(store, Id, Tpos, Role) of
                {false, Reason} -> 
                    role:send_buff_clean(),
                    {reply, {0, Id, Reason}};
                {ok, NewRole, Item} ->
                    NewRole2 = role_listener:get_item(NewRole, Item),
                    role:send_buff_flush(),
                    {reply, {1, Id, <<>>}, NewRole2}
            end
    end;

%% 移动身上装备
handle(10327, {10, _, _}, _Role) -> {reply, {0, 10, <<"">>}}; %% 时装
handle(10327, {15, _, _}, _Role) -> {reply, {0, 15, <<"">>}}; %% 翅膀
handle(10327, {13, _, _}, _Role) -> {reply, {0, 13, <<"">>}}; %% 婚戒
handle(10327, {14, _, _}, _Role) -> {reply, {0, 14, <<"">>}}; %% 坐骑
handle(10327, {16, _, _}, _Role) -> {reply, {0, 14, <<"">>}}; %% 武器饰品
handle(10327, {17, _, _}, _Role) -> {reply, {0, 14, <<"">>}}; %% 挂饰
handle(10327, {18, _, _}, _Role) -> {reply, {0, 18, <<"">>}}; %% 挂饰
handle(10327, {19, _, _}, _Role) -> {reply, {0, 19, <<"">>}}; %% 挂饰
handle(10327, {20, _, _}, _Role) -> {reply, {0, 20, <<"">>}}; %% 挂饰
handle(10327, {Id, _StorageType, _Pos}, #role{event = Event}) when ?EventCantPutItem -> 
    {reply, {0, Id, ?L(<<"唉哟，竞技比赛的时候就不要脱装备啦">>)}};
handle(10327, {Id, StorageType, Pos}, Role = #role{})
when Pos >= 1 andalso (StorageType =:= ?storage_bag orelse StorageType =:= ?storage_eqm) ->
    case Pos > Role#role.bag#bag.volume of
        false -> 
            role:send_buff_begin(),
            case storage:move_eqm(Id, StorageType, Pos, Role) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {0, Id, Reason}};
                {ok, NewRole} ->
                    eqm_api:find_skill_attr_push(NewRole),
                    role:send_buff_flush(),
                    rank:listener(equip, Role, NewRole),
                    {reply, {1, Id, <<>>}, NewRole}
            end;
        true -> {reply, {0, Id, ?L(<<"目标位置未开通">>)}}
    end;

%% 删除物品
%% 删除背包物品
handle(10330, {Id, ?storage_bag}, Role = #role{bag = #bag{items = BagItems}}) ->
    role:send_buff_begin(),
    case storage:find(BagItems, #item.id, Id) of
        {false, _Reason} -> {reply, {Id, ?storage_bag, 0, <<>>}};
        {ok, Item = #item{quantity = Num}} ->
            case role_gain:do([#loss{label = item_id, val = [{Id, Num}], msg = ?L(<<"物品删除失败">>)}], Role) of
                {false, L} ->
                    role:send_buff_clean(),
                    {reply, {Id, ?storage_bag, 0, L#loss.msg}};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    log:log(log_item_del, {[Item], <<"删除">>, <<"背包">>, Role}),
                    {reply, {Id, ?storage_bag, 1, <<>>}, NewRole}
            end
    end;
%% 删除仓库物品
handle(10330, {Id, ?storage_store}, Role = #role{link = #link{conn_pid = ConnPid}, store = Store = #store{items = StoreItems}}) ->
    role:send_buff_begin(),
    case storage:find(StoreItems, #item.id, Id) of
        {false, _Reason} -> {reply, {Id, ?storage_store, 0, <<>>}};
        {ok, Item = #item{quantity = Num}} ->
            case storage:del_item_by_id(Store, [{Id, Num}], true) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {Id, ?storage_store, 0, Reason}};
                {ok, NewStore, _, _} ->
                    storage_api:del_item_info(ConnPid, [{?storage_store, Item}]),  
                    role:send_buff_flush(),
                    log:log(log_item_del, {[Item], <<"删除">>, <<"仓库">>, Role}),
                    {reply, {Id, ?storage_store, 1, <<>>}, Role#role{store = NewStore}}
            end
    end;
%% 删除开封印仓库物品
handle(10330, {Id, ?storage_casino}, Role = #role{link = #link{conn_pid = ConnPid}, casino = Casino = #casino{items = Items}}) ->
    role:send_buff_begin(),
    case storage:find(Items, #item.id, Id) of
        {false, _Reason} -> {reply, {Id, ?storage_casino, 0, <<>>}};
        {ok, Item = #item{quantity = Num}} ->
            case storage:del_item_by_id(Casino, [{Id, Num}], true) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {Id, ?storage_casino, 0, Reason}};
                {ok, NewCasino, _, _} ->
                    storage_api:del_item_info(ConnPid, [{?storage_casino, Item}]),  
                    role:send_buff_flush(),
                    log:log(log_item_del, {[Item], <<"删除">>, <<"寻宝仓库">>, Role}),
                    {reply, {Id, ?storage_casino, 1, <<>>}, Role#role{casino = NewCasino}}
            end
    end;
%% 删除盘龙仓库物品
handle(10330, {Id, ?storage_super_boss}, Role = #role{link = #link{conn_pid = ConnPid}, super_boss_store = Store = #super_boss_store{items = Items}}) ->
    role:send_buff_begin(),
    case storage:find(Items, #item.id, Id) of
        {false, _Reason} -> {reply, {Id, ?storage_super_boss, 0, <<>>}};
        {ok, Item = #item{quantity = Num}} ->
            case storage:del_item_by_id(Store, [{Id, Num}], true) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {Id, ?storage_super_boss, 0, Reason}};
                {ok, NewStore, _, _} ->
                    storage_api:del_item_info(ConnPid, [{?storage_super_boss, Item}]),  
                    role:send_buff_flush(),
                    log:log(log_item_del, {[Item], <<"删除">>, <<"盘龙仓库">>, Role}),
                    {reply, {Id, ?storage_super_boss, 1, <<>>}, Role#role{super_boss_store = NewStore}}
            end
    end;

%% 整理背包
handle(10331, {}, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Items}}) ->
    case allow(sort_bag) of
        true ->
            _DelInfo = case Items =:= [] of
                true -> [];
                false ->
                    [{?storage_bag, Item} || Item <- Items]
            end,
            case storage:check_exchange(Items) of
                true ->
                    %% storage_api:del_item_info(ConnPid, DelInfo),
                    {ok, NewBag = #bag{volume = Vol, items = Items1}} = storage:sort(Bag, Role),
                    ?DEBUG("背包内容: ~w", [Items1]),
                    sys_conn:pack_send(ConnPid, 10300, {Vol, Items1}),
                    {reply, {1, <<>>}, Role#role{bag = NewBag}};
                {false, Reason} ->
                    {reply, {0, Reason}}
            end;
        false ->
            {reply, {0, ?L(<<"整理冷却中">>)}}
    end;

%% 整理仓库
handle(10332, {}, Role = #role{link = #link{conn_pid = ConnPid}, store = Store = #store{items = Items}}) ->
    case check_distance(11009, Role) of
        {false, Reason} ->
            {reply, {0, Reason}};
        ok ->
            case allow(sort_store) of
                true ->
                    DelInfo = case Items =:= [] of
                        true -> [];
                        false ->
                            [{?storage_store, Item} || Item <- Items]
                    end,
                    case storage:check_exchange(Items) of
                        true ->
                            storage_api:del_item_info(ConnPid, DelInfo),
                            {ok, NewStore} = storage:sort(Store, Role),
                            {reply, {1, <<>>}, Role#role{store = NewStore}};
                        {false, Reason} -> {reply, {0, Reason}}
                    end;
                false -> {reply, {0, ?L(<<"整理冷却中">>)}}
            end
    end;

%% 增加格子数
handle(10333, {NewVol}, Role = #role{}) ->
    case storage_api:add_storage_volume(NewVol, Role) of
        {false, _Reason} ->
            ?DEBUG("扩展失败, 原因: ~p", [_Reason]),
            {reply, {0, 0, 0}};
        {ok, NowVolume, NewRole} ->
            {reply, {1, NowVolume, ?MSGID(<<"扩充成功">>)}, NewRole}
    end;

%% 自动使用加血药
handle(10340, {}, #role{event = ?event_arena_match}) ->
    {reply, {0, 0, 0, ?L(<<"仙法竞技中不能使用快速回复">>)}};
handle(10340, {}, #role{event = ?event_top_fight_match}) ->
    {reply, {0, 0, 0, ?L(<<"巅峰对决中不能使用快速回复">>)}};
handle(10340, {}, #role{event = ?event_guild_arena}) ->
    {reply, {0, 0, 0, ?L(<<"帮战过程中不能使用血气药">>)}};
handle(10340, {}, Role) ->
    NewRole = #role{hp = Hp, hp_max = HpMax} = do_auto_hp_list(?auto_hp_items, Role),
    case Hp < HpMax of
        true ->
            team:update_attr(NewRole),
            {reply, {?true, Hp, HpMax, ?L(<<"背包里没有足够气血丹药，可通过左侧操作快捷栏“买药”按钮购买">>)}, NewRole};
        false ->
            NewRole1 = NewRole#role{hp = HpMax},
            team:update_attr(NewRole1),
            {reply, {?true, HpMax, HpMax, ?L(<<"气血已加满">>)}, NewRole1}
    end;

%% 自动使用加法力药
handle(10341, {}, #role{event = ?event_arena_match}) ->
    {reply, {0, 0, 0, ?L(<<"仙法竞技中不能使用快速回复">>)}};
handle(10341, {}, #role{event = ?event_top_fight_match}) ->
    {reply, {0, 0, 0, ?L(<<"巅峰对决中不能使用快速回复">>)}};
handle(10341, {}, #role{event = ?event_guild_arena}) ->
    {reply, {0, 0, 0, ?L(<<"帮战过程中不能使用法力药">>)}};
handle(10341, {}, Role) ->
    NewRole = #role{mp = Mp, mp_max = MpMax} = do_auto_mp_list(?auto_mp_items, Role),
    case Mp < MpMax of
        true ->
            team:update_attr(NewRole),
            {reply, {?true, Mp, MpMax, ?L(<<"背包里没有足够法力丹药，可通过左侧操作快捷栏“买药”按钮购买">>)}, NewRole};
        false ->
            NewRole1 = NewRole#role{mp = MpMax},
            team:update_attr(NewRole1),
            {reply, {?true, Mp, MpMax, ?L(<<"法力已加满">>)}, NewRole1}
    end;

%% 换装 
handle(10343, {_}, #role{event = Event}) when ?EventCantPutItem -> 
    {reply, {?false, ?L(<<"竞技比赛时，不能随便穿装备的啦">>)}};
handle(10343, {Ids}, Role) ->
    role:send_buff_begin(),
    case dress:change_dress(Ids, Role) of
        {false, Reason} -> 
            role:send_buff_clean(),
            {reply, {?false, Reason}};
        {ok, Role1} ->
            Role2 = looks:calc(Role1),
            Role3 = role_api:push_attr(Role2),
            looks:refresh(Role, Role3),
            looks:refresh_set(Role3),
            role:send_buff_flush(),
            dress:pack_send_dress_info(Role3),
            {reply, {?true, ?L(<<"换装成功">>)}, Role3}
    end;

%% 属性转移
handle(10344, {_, _}, #role{event = Event}) when ?EventCantPutItem ->
    {reply, {?false, ?L(<<"参加仙法竞技时是不能进行属性转移的啦">>)}};
handle(10344, {BaseId1, BaseId2}, Role) ->
    case storage:check_fly_and_mount(Role, BaseId1) of
        {false, Reason} -> {reply, {?false, Reason}};
        true ->
            case storage:check_fly_and_mount(Role, BaseId2) of
                {false, Reason} -> {reply, {?false, Reason}};
                true -> 
                    role:send_buff_begin(),
                    case item:swap_dress_attr(BaseId1, BaseId2, Role) of
                        {false, Reason} -> 
                            role:send_buff_clean(),
                            {reply, {?false, Reason}};
                        {ErrCode, Reason} when is_integer(ErrCode) -> 
                            role:send_buff_clean(),
                            {reply, {ErrCode, Reason}};
                        {ok, NewRole} ->
                            looks:refresh_set(NewRole),
                            role:send_buff_flush(),
                            {reply, {?true, ?L(<<"属性转移成功">>)}, NewRole}
                    end
            end
    end;

%% 脱时装
handle(10345, {_Id}, #role{event = Event}) when ?EventCantPutItem ->
    {reply, {?false, ?L(<<"唉哟，竞技比赛的时候就不要脱装备啦">>)}};
handle(10345, {Id}, Role) ->
    role:send_buff_begin(),
    case dress:takeoff_dress(Id, Role) of
        {false, Reason} ->
            role:send_buff_clean(),
            {reply, {?false, Reason}};
        {ok, Role1} ->
            role:send_buff_flush(),
            {reply, {?true, ?L(<<"脱下时装,您的时装保存到衣柜中了 ^.^">>)}, Role1}
    end;

%% 获取挖宝信息 
handle(10348, {}, #role{treasure = #treasure{status = 0}}) ->
    {reply, {0, 0, 0, 0, 0}};  
handle(10348, {}, #role{treasure = #treasure{status = 1, type = Type, map = {Map, X, Y}}}) ->
    {reply, {1, Type, Map, X, Y}};

%% 挖宝
handle(10349, {}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case item_treasure:treasure(Role) of
        {false, Reason} ->
            {reply, {?false, Reason}};
        {ok, NewRole} ->
            Msg = {0, 0, 0, 0, 0},
            sys_conn:pack_send(ConnPid, 10348, Msg),
            {reply, {?true, ?L(<<"挖宝成功">>)}, NewRole}
    end;

%% 放弃挖宝
handle(10350, {}, #role{treasure = #treasure{status = 0}}) ->
    {reply, {?false, ?L(<<"当前没有挖宝任务,无需放弃">>)}};
handle(10350, {}, Role = #role{link = #link{conn_pid = ConnPid}, treasure = Treasure = #treasure{status = 1}}) ->
    NewTreasure = Treasure#treasure{status = 0, type = white, map = {0, 0, 0}},
    Msg = {0, 0, 0, 0, 0},
    sys_conn:pack_send(ConnPid, 10348, Msg),
    {reply, {?true, ?L(<<"放弃挖宝任务成功">>)}, Role#role{treasure = NewTreasure}};

%% 时装染色 
handle(10351, {Type, BaseId}, Role) when Type >= 0 andalso Type =< 3 ->
    role:send_buff_begin(),
    case item:dye_dress(Type, BaseId, Role) of
        {false, Msg} ->
            role:send_buff_clean(),
            {reply, {?false, Msg}};
        {ok, NewRole} ->
            role:send_buff_flush(),
            {reply, {?true, ?L(<<"时装染色成功">>)}, NewRole};
        {ErrCode, Msg} ->
            role:send_buff_clean(),
            {reply, {ErrCode, Msg}}
    end;

%% 物品礼包幸运值
handle(10352, {BaseId}, _Role = #role{item_gift_luck = ItemGL}) when BaseId > 0 ->
    case lists:keyfind(BaseId, 1, ItemGL) of
        false ->
            {reply, {0}};
        {_BaseId, LuckVal} ->
            {reply, {LuckVal}}
    end;

%% 礼包物品信息
handle(10353, {BaseId}, Role) when BaseId > 0 ->
    case item_gift_data:get(BaseId) of
        {false, _Reason} ->
            {reply, {0, [{0, 0, 0}], [{0, 0, 0}]}};
        {Bind, Type, Num, List, _, BestItems, _, MaxLuckVal} ->
            {_, _, GiftList} = item:get_gift_list(Type, Num, Bind, List, Role),
            GiftItemInfo = [{GBaseId, GBind, GNum} || {GBaseId, _, GNum, _, _, GBind} <- GiftList, BaseId > 0],
            BestItemInfo = [{BestItemId, 1, 1} || {BestItemId, _} <- BestItems, BestItemId > 0],
            {reply, {MaxLuckVal, GiftItemInfo, BestItemInfo}}
    end;

%% 一键开启礼包
handle(10355, {Id, Num}, Role = #role{bag = Bag = #bag{}}) when Num > 0->
    case storage:find(Bag#bag.items, #item.id, Id) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, #item{quantity = Q, status = ?lock_release}} when Q < Num -> 
            {reply, {0, ?L(<<"物品数量不足">>)}};
        {ok, #item{status = Status}} when Status =/= ?lock_release -> 
            {reply, {0, ?L(<<"物品锁定,不能使用">>)}};
        {ok, Item} -> 
            case branch_use_luck_gift(Item, Num, Role) of
                {false, Msg} -> {reply, {?false, Msg}};
                {ErrCode, Msg} when is_integer(ErrCode) -> {reply, {ErrCode, Msg}};
                {ok, NewRole} ->
                    {reply, {?true, <<>>}, NewRole};
                {ok, ProtoMsg, NewRole} ->
                    {reply, ProtoMsg, NewRole}
            end
    end;

%% 出售物品
handle(10356, {Id, Num}, Role = #role{bag = Bag = #bag{}}) when Num > 0->
    case storage:find(Bag#bag.items, #item.id, Id) of
        {false, _Reason} -> {reply, {0, ?MSGID(<<"你没有此物品">>)}};
        {ok, #item{quantity = Q}} when Q < Num -> 
            {reply, {0, ?MSGID(<<"物品数量不足">>)}};
        {ok, #item{base_id = BaseId}} ->
            case item_data:get(BaseId) of
                {ok,#item_base{value = Val}} ->
                    case lists:keyfind(sell_npc, 1, Val) of
                        {sell_npc, Price} ->
                            {ok, NewRole} = role_gain:do([#loss{label=item_id, val=[{Id,Num}]}, #gain{label=coin, val=Price*Num}], Role),
                            {reply, {?true, ?MSGID(<<"出售成功">>)}, NewRole};
                        false ->
                            {reply, {?false, ?MSGID(<<"此物品不可以出售">>)}}
                    end;
                {false,_Reaon} ->
                    ?DEBUG("....  never reach here"),
                    {reply, {?false, ?MSGID("出售失败")}}
            end
    end;

%% 获取背包中的物品列表
handle(10357, {}, #role{bag = #bag{free_pos = _FreePos, volume = Volume, items = Items}}) ->
    Items = [{Id, BaseId, Bind, Q}||#item{id=Id, base_id=BaseId, quantity=Q, bind = Bind}<-Items],
%%    ?DEBUG("*********  所有物品ID 数量 ~p~n", [IdNum]),
    {reply, {Volume, Items}};

handle(10358, {}, #role{}) ->
    {ok};
%%    {reply, {}, dress:puton_exp_fashion(Role)};

handle(10360, {}, #role{guaguale = []}) ->
    {reply, {0, ?MSGID(<<"没有可领取的物品">>)}};
handle(10360, {}, Role = #role{guaguale = Guaguale}) ->
    case get_guaguale_item(Guaguale, Role) of
        {?false, ErrMsgid} ->
            {reply, {?false, ErrMsgid}};
        {ok, Role1} ->
            {reply, {?true, ?MSGID(<<"领取成功">>)}, Role1}
    end;

handle(10361, {Num}, Role) when Num >= 1 andalso Num =< 99 ->
    case role_gain:do([#loss{label = gold, val = 10*Num}], Role) of
        {ok, Role1 = #role{assets = Ast = #assets{coin = Coin}}} ->
            BuyCoin = 10000 * Num,
            Role2 = Role1#role{assets = Ast#assets{coin = BuyCoin + Coin}},
            role_api:push_assets(Role, Role2),
            log:log(log_coin, {<<"购买金币">>, <<"">>, Role, Role2}),
            {reply, {?true, ?MSGID(<<"购买成功">>)}, Role2};
        {false, _} ->
            {reply, {?false, ?MSGID(<<"晶钻不足">>)}}
    end;


handle(_Cmd, _Data, _Role) ->
    {error, item_rpc_unknow_command}.

%% --------------------------
%% 内部处理函数
%% --------------------------
get_guaguale_item([], Role) -> 
    {ok, Role};
get_guaguale_item(_L = [{ItemBaseId, Bind, Num} | T], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    ?DEBUG("当前瓜瓜乐数据 ~w", [_L]),
    case item:make(ItemBaseId, Bind, Num) of
        false ->
            ?ERR("生成物品失败  BaseId ~w", [ItemBaseId]),
            {?false, ?MSGID(<<"没有可领取的物品">>)};
        {ok, [Item]} ->
            case storage:add(bag, Role, [Item]) of
                false ->
                    ?DEBUG("背包已满"),
                    {?false, ?MSGID(<<"背包已满">>)};
                {ok, Bag} ->
                    Name = item:name(ItemBaseId),
                    Msg = case Num > 1 of true -> util:fbin("获得了~s X ~w", [Name, Num]); false -> util:fbin("获得了~s", [Name]) end,
                    notice:alert(succ, ConnPid, Msg),
                    get_guaguale_item(T, Role#role{bag = Bag, guaguale = T})
            end
    end.

allow(sort_bag) -> %% 整理冷却4S
    do_check(sort_bag, 4);

allow(sort_store) ->
    do_check(sort_store, 4).

do_check(Type, N) ->
    case get(Type) of
        T when is_integer(T) ->
            case util:unixtime() - T > N of
                true ->
                    put(Type, util:unixtime()),
                    true;
                false ->
                    false
            end;
        _ ->
            put(Type, util:unixtime()),
            true
    end.

do_auto(HasNum, _, P, _) when HasNum =:= 0 ->
    {P, HasNum};
do_auto(HasNum, AddHp, P, Pmax) ->
    NeedNum = ((Pmax - P) div AddHp) + 1,
    case NeedNum =< HasNum of
        true ->
            {Pmax, NeedNum};
        false ->
            {HasNum * AddHp + P, HasNum}
    end.

%% @spec do_auto_hp_list(List, Role) -> NewRole
%% Type = hp | mp 补血或者补蓝
%% List = list() 按优先级的丹药BaseId列表
%% Role = #role{}
%% RetType = {?false, Reason} | {?true, Msg} 返回那种提示语
%% @doc 按丹药优先级执行自动加血
do_auto_hp_list([], Role) -> Role;
do_auto_hp_list([BaseId | T], Role = #role{hp = Hp, hp_max = HpMax, bag = #bag{items = Items}})
when Hp < HpMax ->
    case item_data:get(BaseId) of
        {ok, #item_base{condition = Conds, effect = [{hp, AddHp}]}} ->
            case role_cond:check(Conds, Role) of
                true ->
                    case storage:find(Items, #item.base_id, BaseId) of
                        {false, _} -> do_auto_hp_list(T, Role);
                        {ok, HasNum, _, _, _} ->
                            {NowHp, LossNum} = do_auto(HasNum, AddHp, Hp, HpMax),
                            LossList = [#loss{label = item, val = [BaseId, 0, LossNum]}],
                            case role_gain:do(LossList, Role#role{hp = NowHp}) of
                                {false, _} -> Role;
                                {ok, NewRole} ->
                                    do_auto_hp_list(T, NewRole)
                            end
                    end;
                _ -> Role
            end;
        _ -> %% 后面的不用循环查找了，肯定等级不够
            Role
    end;
do_auto_hp_list([_BaseId | _], Role = #role{hp = _Hp, hp_max = HpMax}) ->
    Role#role{hp = HpMax}.

%% do_auto_mp_list(List, Role) -> NewRole
%% List = list() 按优先级的丹药BaseId列表
%% Role = #role{}
%% 按丹药优先级执行自动加蓝
do_auto_mp_list([], Role) -> Role;
do_auto_mp_list([BaseId | T], Role = #role{mp = Mp, mp_max = MpMax, bag = #bag{items = Items}})
when Mp < MpMax ->
    case item_data:get(BaseId) of
        {ok, #item_base{condition = Conds, effect = [{mp, AddMp}]}} ->
            case role_cond:check(Conds, Role) of
                true ->
                    case storage:find(Items, #item.base_id, BaseId) of
                        {false, _} -> do_auto_mp_list(T, Role);
                        {ok, HasNum, _, _, _} ->
                            {NowMp, LossNum} = do_auto(HasNum, AddMp, Mp, MpMax),
                            LossList = [#loss{label = item, val = [BaseId, 0, LossNum]}],
                            case role_gain:do(LossList, Role#role{mp = NowMp}) of
                                {false, _} -> Role;
                                {ok, NewRole} ->
                                    do_auto_mp_list(T, NewRole)
                            end
                    end;
                _ -> Role
            end;
        _ -> %% 后面的不用循环查找了，肯定等级不够
            Role
    end;
do_auto_mp_list([_BaseId | _], Role = #role{mp = Mp, mp_max = MpMax})
when Mp >= MpMax ->
    Role#role{mp = MpMax}. %% 如果已经加满则返回

%% 根据一些规则,转换物品对应的类型处理
%% item_to_rule(#item{base_id = ?pet_item_baseid}) -> pet_item;
item_to_rule(#item{base_id = BaseId}) when BaseId  =:=  201001 -> energy;
item_to_rule(#item{base_id = BaseId}) when BaseId  =:= 532523 -> guagua;    %% 瓜瓜卡
item_to_rule(#item{base_id = BaseId}) when BaseId  =:= 532525 -> guagua;    %% 瓜瓜卡
item_to_rule(#item{base_id = BaseId}) when (BaseId div 10000) =:= ?item_gift -> gift;
item_to_rule(_) -> normal.

%% @spec branch_use_item(Flag, Item, Role) -> {reply, {0, Reason}} | {reply, {1, <<>>}, NewRole}
%% @doc 物品使用判定,对于一些特定物品的使用,特定物品的使用要在normal前面
%% <div> 返回0:失败 1:成功 </div>
%%branch_use_item(_Flag, #item{career = ReCareer}, _Num, #role{career = Career})
%%when ReCareer =/= Career andalso ReCareer =/= 9 ->
%%    {false, ?L(<<"您的职业不能使用此物品">>)};
%%branch_use_item(_Flag, #item{require_lev = ReLev}, _Num, #role{lev = Lev}) when ReLev > Lev ->
%%    {false, ?L(<<"等级不足，无法使用">>)};
branch_use_item(pet_item, Item, _Num, Role) ->
    case pet:item_to_pet(Item, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NRole} ->
            NRole1 = role_listener:use_item(NRole, Item),
            log:log(log_item_del, {[Item], <<"使用宠粮">>, <<"背包">>, Role}),
            {ok, NRole1}
    end;
%% 技能类
branch_use_item(skill_book, #item{id = Id, base_id = BaseId}, _Num, Role) ->
    case item_data:get(BaseId) of
        %% 仙宠技能飞升
        {ok, #item_base{effect = [{pet_skill_book, [SkillId]}]}} ->
            role:send_buff_begin(),
            case role_gain:do([#loss{label = item_id, val = [{Id, 1}]}], Role) of
                {ok, Role1} ->
                    case pet:ascend_skill(Role1, SkillId) of
                        {ok, NewRole, Msg} -> 
                            role:send_buff_flush(),
                            log:log(log_item_del_loss, {<<"仙宠技能飞升">>, Role}),
                            {ok, {?true, Msg}, NewRole};
                        {false, Why} ->
                            role:send_buff_clean(),
                            {false, Why};
                        _R ->
                            role:send_buff_clean(),
                            ?ERR("宠物技能飞升失败 ~w", [_R]),
                            {false, ?L(<<"该物品不能直接使用">>)}
                    end;
                {false, Reason} ->
                    role:send_buff_clean(),
                    {false, Reason}
            end;
        _ ->
            {false, ?L(<<"该物品不能直接使用">>)}
    end;

branch_use_item(wing, _Item, _Num, #role{event = Event}) when ?EventCantPutItem ->
    {false, ?L(<<"竞技比赛时，不能随便穿装备的啦">>)};
branch_use_item(wing, Item = #item{enchant = N}, _Num, Role) ->
    case storage:check_fly_and_mount(Role, Item) of
        {false, Reason} -> {false, Reason};
        true ->
            role:send_buff_begin(),
            case wing:put_wing(Role, Item) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {false, Reason};
                {ok, NewRole} ->
                    rank_celebrity:listener(on_eqm, NewRole, {15, N}),
                    Nr = role_listener:eqm_event(NewRole, update),
                    role:send_buff_flush(),
                    {ok, Nr}
            end
    end;
branch_use_item(wing_skin, Item, _Num, Role) ->
    role:send_buff_begin(),
    case wing:use_skin_item(Role, Item) of
        {ok, NewRole} ->
            role:send_buff_flush(),
            NewRole1 = role_listener:eqm_event(NewRole, update),
            {ok, NewRole1};
        {false, Reason} ->
            role:send_buff_clean(),
            {false, Reason}
    end;


%% 开礼包
branch_use_item(gift, Item = #item{base_id = BaseId}, Num1, Role = #role{link = #link{conn_pid = ConnPid}}) when is_integer(Num1)->
    {ok, #item_base{condition = Cond}} = item_data:get(BaseId),
    case role_cond:check(Cond, Role) of %% 检查是否满足使用条件
        {false, _RCond} -> {false, ?L(<<"等级不足，不能使用">>)};
        true ->
            role:send_buff_begin(),
            case role_gain:do([#loss{label = item_id, val = [{Item#item.id, Num1}]}], Role) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {false, Reason};
                {ok, NewRole = #role{bag = #bag{free_pos = FreePos}}} ->
                    case item_gift_data:get(BaseId) of
                        {false, Reason} -> 
                            role:send_buff_clean(),
                            {false, Reason};
                        {_Bind, _Type, Num, _L, _IsLuck, _ResetLuck, _LuckVal, _MaxLuckVal} when length(FreePos) < Num ->
                            role:send_buff_clean(),
                            {false, ?L(<<"背包空间不足, 请先整理背包再来打开礼包">>)};
                        {Bind, Type, Num, L, IsLuck, ResetLuck, LuckVal, MaxLuckVal} ->
                            case IsLuck of %% 是否需要幸运值界面玩法
                                ?true ->
                                    case use_luck_gift(BaseId, {Bind, Type, Num, L, Num1, ResetLuck, LuckVal, MaxLuckVal}, NewRole, Item) of
                                        {false, Reason} ->
                                            role:send_buff_clean(),
                                            {false, Reason};
                                        {ok, {?true, InfoMsg}, NR} ->
                                            role:send_buff_flush(),
                                            {ok, {?true, InfoMsg}, NR}
                                    end;
                                ?false ->
                                    GetL = item:get_gift_list(Type, Num, Bind, L, NewRole),
                                    case item:make_all_gift_list(Num1, GetL) of
                                        {false, Reason} ->
                                            role:send_buff_clean(),
                                            {false, Reason};
                                        {ok, GainList, CastItems} ->
                                            {NewGainList, _NewCastItems} = case Num1 >1 of
                                                true->
                                                    item:do_lots_gift(GainList,CastItems);
                                                false->
                                                    {GainList, CastItems}
                                            end,
                                            case role_gain:do(NewGainList, NewRole) of
                                                {false, G} ->
                                                    role:send_buff_clean(),
                                                    {false, G#gain.msg};
                                                {ok, NR} ->
                                                    case CastItems =:= [] of
                                                        true -> skip;
                                                        false ->
                                                            broadmsg_open_gift(Role, L, CastItems, BaseId)
                                                    end,
                                                    case NewGainList of
                                                        [#gain{label = fragile, val = [ItemBaseId, _Num]}] ->
                                                            Msg = util:fbin(<<"~w">>, [ItemBaseId]),
                                                            role:send_buff_flush(),
                                                            {ok, {2, Msg}, NR};
                                                        _ ->
                                                            InfoMsg = gainlist_to_msg(NewGainList, <<"">>),
                                                            notice:alert(succ, ConnPid, InfoMsg),
                                                            %% gainlist_to_inform(NR, NewGainList, Item, [],Num1),
                                                            log:log(log_coin, {<<"开礼包">>, <<>>, Role, NR}),
                                                            log:log(log_gift_open, {Item, InfoMsg, Role}),
                                                            log:log(log_item_output, {NewGainList, <<"开礼包">>}),
                                                            role:send_buff_flush(),
                                                            {ok, {?true, InfoMsg}, NR}
                                                    end
                                            end
                                    end
                            end
                    end
            end
end;

branch_use_item(energy, #item{id = Id}, Num, Role) ->
     energy:use_energy_water(by_id, Id, Num, Role);

 branch_use_item(guagua, #item{}, Num, #role{}) when Num =/= 1 ->
     {false, ?L(<<"一次只能使用一张刮刮卡！">>)};
 branch_use_item(guagua, Item = #item{base_id = BaseId}, 1, Role = #role{bag = #bag{free_pos = FreePos}}) ->
     case length(FreePos) =< 0 of
         true ->
            {false, ?L(<<"背包空间不足, 请先整理背包再来打开礼包">>)};
        false ->
            {ok, Role1} = do_use_guagua(BaseId, Role),
            {ok, Role2} = role_gain:do([#loss{label = item_id, val = [{Item#item.id, 1}]}], Role1),
            {ok, {?true, ?L(<<"使用成功">>)}, Role2}
    end;
        
%% 种子类使用
branch_use_item(seed, Item, _Num, Role) ->
    role:send_buff_begin(),
    case campaign_plant:seed(Role, Item) of
        {ok, NewRole} ->
            role:send_buff_flush(),
            {ok, NewRole};
        {false, Reason} ->
            role:send_buff_clean(),
            {false, Reason}
    end;

%% 散财树使用
branch_use_item(tree, _Item, _Num, #role{ride = ?ride_fly}) ->
    {false, ?L(<<"飞行状态无法使用该物品">>)};
branch_use_item(tree, _Item, _Num, #role{pos = #pos{map = MapId}}) when MapId =/= 10003 ->
    {false, ?L(<<"非洛水城区域无法使用">>)};
branch_use_item(tree, Item, _Num, Role) ->
    role:send_buff_begin(),
    case campaign_tree:seed(Role, Item) of
        {ok, NewRole} ->
            role:send_buff_flush(),
            {ok, NewRole};
        {false, Reason} ->
            role:send_buff_clean(),
            {false, Reason}
    end;

branch_use_item(treasure, Item, _Num, Role = #role{team_pid = TeamPid}) ->
    role:send_buff_begin(),
    case is_pid(TeamPid) of
        true ->
            role:send_buff_clean(),
            {false, ?L(<<"组队不能挖宝哦, 好宝物要珍惜啊！">>)};
        false ->
            case item_treasure:use_treasure(Item, Role) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {false, Reason};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    {ok, NewRole}
            end
    end;

branch_use_item(item_jinlanpu, Item, _Num, Role) ->
    role:send_buff_begin(),
    case sworn:use_jinlanpu(Role, Item) of
        {ok, NewRole} ->
            role:send_buff_flush(),
            {ok, NewRole};
        {false, Reason} ->
            role:send_buff_clean(),
            {false, Reason}
    end;

branch_use_item(item_lingxidan, Item, Num, Role) ->
    role:send_buff_begin(),
    case wing:use_lingxidan(Role, Item, Num) of
        {ok, Msg, NewRole} ->
            role:send_buff_flush(),
            {ok, {?true, Msg}, NewRole};
        {false, Reason} ->
            role:send_buff_clean(),
            {false, Reason}
    end;


%% 使用直接传送到跨服中心城的道具
branch_use_item(item_transport_to_center_city, _, _, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"组队状态下不能使用时光穿梭">>)};
branch_use_item(item_transport_to_center_city, _, _, #role{attr = #attr{fight_capacity = RolePower}}) when RolePower < 6500 ->
    {false, util:fbin(?L(<<"暂时不能使用时光穿梭，战斗力未达到~w">>), [6500])};
branch_use_item(item_transport_to_center_city, _, _, #role{lev = Lev}) when Lev < 52 ->
    {false, util:fbin(?L(<<"暂时不能使用时光穿梭，等级未达到~w级">>), [52])};
branch_use_item(item_transport_to_center_city, _, _, #role{cross_srv_id = <<"center">>}) ->
    {false, ?L(<<"跨服地图下不能使用时光穿梭">>)};
branch_use_item(item_transport_to_center_city, #item{id = Id}, Num, Role = #role{event = ?event_no}) ->
    case trip_mgr:is_enter_limited() of
        true -> {false, ?L(<<"暂时不能使用时光穿梭，圣城太拥挤">>)};
        false ->
            case center:is_connect() of
                false ->
                    {false, ?L(<<"时空不稳定，暂时不能使用时光穿梭">>)};
                _ ->
                    LL = [#loss{label = item_id, val = [{Id, Num}]}],
                    case role_gain:do(LL, Role) of
                        {false, Reason} -> 
                            {false, Reason};
                        {ok, Role1} ->
                            trip_mgr:enter_center_city_by_item(Role1),
                            {ok, Role1}
                    end
            end
    end;
branch_use_item(item_transport_to_center_city, _, _, _Role) ->
    {false, ?L(<<"当前状态下不能使用时光穿梭">>)};

%% 使用宠物真身卡
branch_use_item(pet_rb, Item = #item{id = Id, base_id = BaseId}, _Num, Role) ->
    role:send_buff_begin(),
    case role_gain:do([#loss{label = item_id, val = [{Id, 1}]}], Role) of
        {false, Reason} ->
            role:send_buff_clean(),
            {false, Reason};
        {ok, Role1} ->
            case pet_rb:active(Role1, BaseId) of
                {false, Msg} ->
                    role:send_buff_clean(),
                    {false, Msg};
                {ok, Role2} ->
                    NewRole = pet_collect:collect(Role2, Item), %% 星宠
                    role:send_buff_flush(),
                    log:log(log_item_del, {[Item], <<"使用宠物真身卡">>, <<"数量 1">>, NewRole}),
                    {ok, NewRole}
            end
    end;

%% 梦幻宝盒打开
branch_use_item(pandora_box, Item = #item{special = Special}, _Num, Role = #role{bag = Bag, link = #link{conn_pid = ConnPid}}) ->
    case pandora_box:open(Item, Role) of
        {ok, LuckyL} ->
            {ok, NewBag, _} = storage_api:fresh_item(Item, Item#item{special = [{pandora_box, LuckyL} | Special]}, Bag, ConnPid),
            {ok, Role#role{bag = NewBag}};
        {ok} ->
            {ok, Role};
        _E ->
            ?DEBUG("_E:~w", [_E]),
            {false, ?L(<<"梦幻宝盒打开失败，快去攒人品吧">>)}
    end;

%% 使用帮会VIP令
branch_use_item(guild_upgrade_vip, Item = #item{id = Id}, _Num, Role) ->
    role:send_buff_begin(),
    case role_gain:do([#loss{label = item_id, val = [{Id, 1}]}], Role) of
        {false, Reason} ->
            role:send_buff_clean(),
            {false, Reason};
        {ok, Role1} ->
            case guild_common:upgrade(Role1) of
                {false, Msg} ->
                    role:send_buff_clean(),
                    {false, Msg};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    log:log(log_item_del, {[Item], <<"使用VIP帮会令">>, <<"数量 1">>, NewRole}),
                    {ok, NewRole}
            end
    end;

branch_use_item(normal, Item = #item{id = Id, use_type = UseType, require_lev = ItemLev, quality = ItemQuality}, Num, Role) ->
    role:send_buff_begin(),
    case storage:use_id(bag, Role, Id, Num) of
        {false, Reason} -> 
            role:send_buff_clean(),
            {false, Reason};
        {ok, NewRole} ->
            eqm_api:find_skill_attr_push(NewRole),
            Now = case UseType =:= 3 of  %% 穿戴
                true ->
                    rank:listener(equip, Role, NewRole),
                    NewRole1 = eqm:check_suit_lock(NewRole),
                    Now1 = looks:calc(NewRole1),
                    Now2 = case ItemLev >= 40 andalso ItemQuality >= ?quality_purple of
                        true -> role_listener:special_event(Now1, {1027, finish}); %% 一件紫装
                        false -> Now1
                    end,
                    Now3 = medal:listener(eqm,Now2),
                    role_listener:eqm_event(Now3, update);
                false -> NewRole 
            end,
            Nr = role_api:push_attr(Now),
            Nr1 = role_listener:use_item(Nr, Item),
            looks:refresh(Role, Nr1),
            notice_vip_face(NewRole, Item), %% vip头像广播
            role:send_buff_flush(),
            {ok, Nr1}
    end.

%% @spec branch_use_item(Item, Num, Role) -> {reply, {0, Reason}} | {reply, {1, <<>>}, NewRole}
%% @doc 一键开启礼包
%% <div> 返回0:失败 1:成功 </div>
branch_use_luck_gift(Item = #item{base_id = BaseId}, UseNum, Role = #role{link = #link{conn_pid = ConnPid}, bag = #bag{free_pos = FreePos}, item_gift_luck = GL}) ->
    role:send_buff_begin(),
    case item_gift_data:get(BaseId) of
        {false, Reason} -> 
            role:send_buff_clean(),
            {false, Reason};
        {_Bind, _Type, Num, _L, _IsLuck, _ResetLuck, _LuckVal, _MaxLuckVal} when length(FreePos) < Num ->
            role:send_buff_clean(),
            {false, ?L(<<"背包空间不足, 请先整理背包再来打开礼包">>)};
        {Bind, Type, Num, L, _IsLuck, ResetLuck, LuckVal, MaxLuckVal} ->
            GetL = item:get_gift_list(Type, Num, Bind, L, Role),
            CurrentLuck = case lists:keyfind(BaseId, 1, GL) of
                {BaseId, BLuck} -> BLuck;
                _ -> 0
            end,
            case use_all_gift_list(CurrentLuck, {UseNum, GetL, GL}, {ResetLuck, LuckVal, MaxLuckVal}) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {false, Reason};
                {ok, {GainList, CastItems, GNum, NewLuckVal}} ->
                    NewGL = case lists:keyfind(BaseId, 1, GL) of
                        {_, _} ->
                            lists:keyreplace(BaseId, 1, GL, {BaseId, NewLuckVal});
                        _ -> [{BaseId, NewLuckVal} | GL]
                    end,
                    NewRole = Role#role{item_gift_luck = NewGL},
                    case role_gain:do([#loss{label = item_id, val = [{Item#item.id, GNum}]}], NewRole) of
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {false, Reason};
                        {ok, NewRole2} ->
                            {NewGainList, NewCastItems} = case UseNum > 1 of
                                true->
                                    item:do_lots_gift(GainList,CastItems);
                                false->
                                    {GainList, CastItems}
                            end,
                            case role_gain:do(NewGainList, NewRole2) of
                                {false, G} ->
                                    role:send_buff_clean(),
                                    {false, G#gain.msg};
                                {ok, NR} ->
                                    case CastItems =:= [] of
                                        true -> skip;
                                        false ->
                                            ItemMsg = notice:item_to_msg(NewCastItems),
                                            RoleMsg = notice:role_to_msg(NR),
                                            GiftMsg = notice:item_to_msg(Item#item{quantity = GNum}),
                                            _M = util:fbin(?L(<<"福星高照, ~s打开~s竟幸运的获得了~s">>), [RoleMsg, GiftMsg, ItemMsg])
                                            %%notice:send(62, M)
                                    end,
                                    InfoMsg = gainlist_to_msg(NewGainList, <<"">>),
                                    %%sys_conn:pack_send(ConnPid, 10352, {NewLuckVal}),
                                    notice:alert(succ, ConnPid, InfoMsg),
                                    gainlist_to_inform(NR, NewGainList, Item, [], GNum),
                                    log:log(log_coin, {<<"开礼包">>, <<>>, Role, NR}),
                                    log:log(log_gift_open, {Item, InfoMsg, Role}),
                                    log:log(log_item_output, {NewGainList, <<"开礼包">>}),
                                    role:send_buff_flush(),
                                    {ok, {?true, InfoMsg}, NR}
                            end
                    end
            end
    end.

%% -------------------
%% 内部函数
%% -------------------
%% 转换成返回语句
gainlist_to_msg([], Msg) -> Msg;
gainlist_to_msg([#gain{label = item, val = [BaseId, _Bind, Q]} | T], Msg) ->
    case item_data:get(BaseId) of
        {ok, #item_base{name = Name}} ->
            NewMsg = case Msg of
                <<"">> ->
                    case Q =:= 1 of
                        true -> util:fbin(<<"获得了~s">>,[Name]);
                        false -> util:fbin(<<"获得了~sx~w">>,[Name, Q])
                    end;
                _ ->
                    case Q =:= 1 of
                        true -> util:fbin(<<"~s\n获得了~s">>,[Msg, Name]);
                        false -> util:fbin(<<"~s\n获得了~sx~w">>,[Msg, Name, Q]) 
                    end
            end,
            gainlist_to_msg(T, NewMsg);
        _ -> gainlist_to_msg(T, Msg)
    end;
gainlist_to_msg([#gain{label = fragile, val = [BaseId, Q]} | T], Msg) ->
    case item_data:get(BaseId) of
        {ok, #item_base{name = Name}} ->
            NewMsg = case Msg of
                <<"">> ->
                    case Q =:= 1 of
                        true -> util:fbin(<<"获得了~s">>,[Name]);
                        false -> util:fbin(<<"获得了~sx~w">>,[Name, Q])
                    end;
                _ ->
                    case Q =:= 1 of
                        true -> util:fbin(<<"~s\n获得了~s">>,[Msg, Name]);
                        false -> util:fbin(<<"~s\n获得了~sx~w">>,[Msg, Name, Q]) 
                    end
            end,
            gainlist_to_msg(T, NewMsg);
        _ -> gainlist_to_msg(T, Msg)
    end.

gainlist_to_inform(Nr, [], Item, ItemList,Num) ->
    GiftMsg = notice:item3_to_inform(Item#item{quantity=Num}),
    ItemMsg = notice:item3_to_inform(ItemList),
    TypeList = ?eqm ++ ?armor ++ [?item_hu_fu, ?item_jie_zhi],
    reward_list(Nr, ItemList, TypeList),
    notice:inform(util:fbin(?L(<<"打开~s\n获得~s">>), [GiftMsg, ItemMsg]));
gainlist_to_inform(Nr, [#gain{label = item, val = [BaseId, Bind, Q]} | T], Item, ItemList,Num) ->
    case item:make(BaseId, Bind, Q) of
        false -> gainlist_to_inform(Nr, T, Item, ItemList,Num);
        {ok, Items} -> gainlist_to_inform(Nr, T, Item, Items ++ ItemList,Num)
    end.

reward_list(_Nr, [], _) -> ok;
reward_list(Nr, [#item{require_lev = Lev, type = Type, quality = ?quality_purple} | T], TypeList) when Lev >= 40 andalso Lev < 50 ->
    case lists:member(Type, TypeList) of
        true -> blacksmith_reward:listener(purple, Nr, Lev);
        false -> skip
    end,
    reward_list(Nr, T, TypeList);
reward_list(Nr, [_ | T], TypeList) ->
    reward_list(Nr, T, TypeList).

%% 女看男  [斯文文]娇羞地看着[瓶子]
%% 男看女 [瓶子]温柔地看着[斯文文]
%% 男看男 [瓶子]淡定地瞄了[时光]一眼
%% 女看女 [斯文文]调皮地看着[凯敏]
%% 男#0095ff  女#ff00f0

%% 发送到被查看玩家角色的事件通知里面
%% 女看男
pack_inform(Name, ?female, ?male, ConnPid) when is_pid(ConnPid) ->
    Msg = util:fbin(?L(<<"{str,【~s】, #f65e6a}娇羞地看着你">>),[Name]),
    sys_conn:pack_send(ConnPid, 10932, {8, 0, Msg});
%% 男看女
pack_inform(Name, ?male, ?female, ConnPid) when is_pid(ConnPid) ->
    Msg = util:fbin(?L(<<"{str,【~s】, #0095ff}温柔地看着你">>),[Name]),
    sys_conn:pack_send(ConnPid, 10932, {8, 0, Msg});
%% 男看男
pack_inform(Name, ?male, ?male, ConnPid) when is_pid(ConnPid) ->
    Msg = util:fbin(?L(<<"{str,【~s】, #0095ff}淡定地瞄了你一眼">>),[Name]),
    sys_conn:pack_send(ConnPid, 10932, {8, 0, Msg});
%% 女看女
pack_inform(Name, ?female, ?female, ConnPid) when is_pid(ConnPid) ->
    Msg = util:fbin(?L(<<"{str,【~s】, #f65e6a}调皮地看着你">>),[Name]),
    sys_conn:pack_send(ConnPid, 10932, {8, 0, Msg});
pack_inform(_, _, _, _) -> skip.


%% 判断距离
check_distance(_NpcId, #role{vip = #vip{type = Type}}) when Type =/= ?vip_no ->
    ok;
check_distance(NpcId, _Role = #role{pos = #pos{map_pid = MapPid, x = X1, y = Y1}}) -> 
    case npc_mgr:lookup(by_base_id, NpcId) of
        [#npc{pos = #pos{map_pid = MapPid, x = X2, y = Y2}} | _] ->
            DistX = erlang:abs(X1 - X2),
            DistY = erlang:abs(Y1 - Y2),
            if
                DistX =< 500 andalso DistY =< 500 -> 
                    ok;
                true ->
                    ?DEBUG("距离太远 NpcId:~p [npc: ~p, ~p] [role: ~p, ~p]", [NpcId, X2, Y2, X1, Y1]),
                    {false, ?L(<<"距离NPC太远">>)}
            end;
        _ ->
            ?DEBUG("本地图不存在的NPC:[~p]", [NpcId]),
            {false, ?L(<<"本地图不存在相关NPC">>)}
    end.

%% vip头像广播
notice_vip_face(#role{id = {RoleId, SrvId}, name = RoleName}, #item{base_id = Id}) ->
    List = [29477, 33144, 33145, 33216, 33219], %% 礼包id列表
    case lists:member(Id, List) of
        true ->
            {ok, [Item]} = item:make(Id, 1, 1),
            ItemMsg = notice:item_to_msg(Item),
            notice:send(53, util:fbin(?L(<<"酷炫头像，张扬个性。{role, ~w, ~s, ~s, #3ad6f0}打开~s，获得了数个精美头像。">>), [RoleId, SrvId, RoleName, ItemMsg]));
        false -> ignore
    end.

%% 礼包幸运值玩法
use_luck_gift(GetItemId, {Bind, Type, Num, L, UseNum, ResetLuck, LuckVal, MaxLuckVal}, Role = #role{item_gift_luck = GL}, Item) ->
    case get_gift(Type, Num, Bind, L, Role) of
        {false, Reason} ->
            {false, Reason};
        {ok, GainList, CastItems} ->
            case check_best_item(GainList, ResetLuck) of %% 检测是否为极品
                false -> %% 不是极品
                    {NewRole, NewGainList} = case lists:keyfind(GetItemId, 1, GL) of
                        false ->
                            NRole = Role#role{item_gift_luck = [{GetItemId, LuckVal} | GL]},
                            %% sys_conn:pack_send(ConnPid, 10352, {LuckVal}),
                            {NRole, GainList};
                        {_GiftID, GLuckVal} ->
                            NewGLuckVal = GLuckVal + LuckVal,
                            case NewGLuckVal >= MaxLuckVal of %% 是否达到最大幸运值
                                false ->
                                    NewItemGL = lists:keyreplace(GetItemId, 1, GL, {GetItemId, NewGLuckVal}),
                                    %% sys_conn:pack_send(ConnPid, 10352, {NewGLuckVal}),
                                    NRole = Role#role{item_gift_luck = NewItemGL},
                                    {NRole, GainList};
                                true ->
                                    NewItemGL = lists:keyreplace(GetItemId, 1, GL, {GetItemId, 0}),
                                    %% sys_conn:pack_send(ConnPid, 10352, {0}),
                                    NRole = Role#role{item_gift_luck = NewItemGL},
                                    ItemGiftId = get_rand_gift(ResetLuck),
                                    {_, _, GiftList} = item:get_gift_list(Type, Num, Bind, L, NRole),
                                    GList = case lists:keyfind(ItemGiftId, 1, GiftList) of
                                        {_, _, GNum, _, _, GBind} -> [#gain{label = item, val = [ItemGiftId, GBind, GNum]}];
                                        _ -> [#gain{label = item, val = [ItemGiftId, 1, 1]}]
                                    end,
                                    {NRole, GList}
                            end
                    end,
                    case gift_reward(NewGainList, CastItems, Item, UseNum, NewRole) of
                        {false, Msg} ->
                            %% sys_conn:pack_send(ConnPid, 10354, {}),
                            {false, Msg};
                        {ok, {?true, InfoMsg}, NR} ->
                            %% PushReward = [{GiftId, GBind, GNum} || #gain{val = [GiftId, GBind, GNum]} <- NewGainList, GiftId > 0],
                            %% sys_conn:pack_send(ConnPid, 10354, {PushReward}),
                            {ok, {?true, InfoMsg}, NR}
                    end;
                true ->
                    NewItemGL = lists:keyreplace(GetItemId, 1, GL, {GetItemId, 0}),
                    NewRole = Role#role{item_gift_luck = NewItemGL},
                    case gift_reward(GainList, CastItems, Item, UseNum, NewRole) of
                        {false, Msg} ->
                            {false, Msg};
                        {ok, {?true, InfoMsg}, NR} ->
                            %% sys_conn:pack_send(ConnPid, 10352, {0}),
                            {ok, {?true, InfoMsg}, NR}
                    end
            end
    end.

%% 礼包奖励
gift_reward(GainList, CastItems, Item, _UseNum, Role) ->
    role:send_buff_begin(),
    case role_gain:do(GainList, Role) of
        {false, G} ->
            role:send_buff_clean(),
            {false, G#gain.msg};
        {ok, NR} ->
            case CastItems =:= [] of
                true -> skip;
                false ->
                    skip
                    %%ItemMsg = notice:item_to_msg(CastItems),
                    %%RoleMsg = notice:role_to_msg(NR),
                    %%GiftMsg = notice:item_to_msg(Item#item{quantity = UseNum}),
                    %%M = util:fbin(?L(<<"福星高照, ~s打开~s竟幸运的获得了~s!">>), [RoleMsg, GiftMsg, ItemMsg]),
                    %%notice:send(62, M)
            end,
            InfoMsg = gainlist_to_msg(GainList, <<"">>),
            %% gainlist_to_inform(NR, GainList, Item, [], UseNum),
            log:log(log_coin, {<<"开礼包">>, <<>>, Role, NR}),
            log:log(log_gift_open, {Item, InfoMsg, Role}),
            log:log(log_item_output, {GainList, <<"开礼包">>}),
            role:send_buff_flush(),
            {ok, {?true, InfoMsg}, NR}
    end.

%% 获取礼包物品
get_gift(Type, Num, Bind, L, Role) ->
    GetL = item:get_gift_list(Type, Num, Bind, L, Role),
    case item:make_gift_list(GetL) of
        {false, Reason} ->
            {false, Reason};
        {ok, GainList, CastItems} ->
            {ok, GainList, CastItems}
    end.

%% 检查是否为极品物品
check_best_item(GainList, ResetLuck) ->
    GiftIds = [GItemId || #gain{val = [GItemId, _, _]} <- GainList, GItemId > 0],
    is_best_item(GiftIds, ResetLuck).
%% 检查是否为极品物品
is_best_item([], _ResetLuck) ->
    false;
is_best_item([GiftId | T], ResetLuck) ->
    case lists:keyfind(GiftId, 1, ResetLuck) of
        false ->
            is_best_item(T, ResetLuck);
        {_, _} -> true
    end.

%% 随机获取物品
get_rand_gift(ResetLuck) ->
    RandL = [Rand || {_BaseId, Rand} <- ResetLuck, Rand > 0], %% 随机列表
    SumRand = lists:sum(RandL), %% 计算和
    RandVal = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    get_randlist_val(RandVal, ResetLuck).

get_randlist_val(RandVal, [{BaseId, Rand} | T]) when RandVal =< Rand orelse T =:= [] ->
    BaseId;
get_randlist_val(RandVal, [{_BaseId, Rand} | T]) ->
    get_randlist_val(RandVal - Rand, T).

%% 一键礼包全部使用
use_all_gift_list(CurrentLuck, {UseNum, GetL, GL}, {BestItem, LuckVal, MaxLuckVal})->
    use_all_gift_list(CurrentLuck, {UseNum, GetL, GL}, {BestItem, LuckVal, MaxLuckVal}, {[], [], 0}).
use_all_gift_list(CurrentLuck, {UseNum, _GetL, _GL}, _, {GainList, CastItems, GNum}) when UseNum < 1 ->
    {ok, {GainList, CastItems, GNum, CurrentLuck}};
use_all_gift_list(CurrentLuck, {UseNum, GetL = {_, _, GiftList}, GL}, {BestItem, LuckVal, MaxLuckVal}, {AllGainList, AllCastItems, AllNum})->
    case item:make_gift_list(GetL) of
        {false, Reason}->
            {false, Reason};
        {ok, GainList, CastItems}->
            case check_best_item(GainList, BestItem) of %% 检测是否为极品
                false -> %% 不是极品
                    NewGLuckVal = CurrentLuck + LuckVal,
                    case NewGLuckVal >= MaxLuckVal of %% 是否达到最大幸运值
                        false ->
                            use_all_gift_list(NewGLuckVal, {UseNum - 1, GetL, GL}, {BestItem, LuckVal, MaxLuckVal}, {GainList ++ AllGainList, CastItems ++ AllCastItems, AllNum + 1});
                        true ->
                            ItemGiftId = get_rand_gift(BestItem),
                            GList = [#gain{val = [_, CBind, CNum]}] = case lists:keyfind(ItemGiftId, 1, GiftList) of
                                {_, _, GNum, _, _, GBind} -> [#gain{label = item, val = [ItemGiftId, GBind, GNum]}];
                                _ -> [#gain{label = item, val = [ItemGiftId, 1, 1]}]
                            end,
                            {ok, I} = item:make(ItemGiftId, CBind, CNum),
                            {ok, {GList ++ AllGainList, I ++ AllCastItems, AllNum + 1, 0}}
                    end;
                true ->
                    {ok, {GainList ++ AllGainList, CastItems ++ AllCastItems, AllNum + 1, 0}}
            end
    end.

%% L = []
broadmsg_open_gift(Role, L, Items, GiftBaseId) ->
    {ok, #item_base{name = Name}} = item_data:get(GiftBaseId),
    Items1 = [{BaseId, Bind, Q} || #item{base_id = BaseId, bind = Bind, quantity = Q} <- Items],
    GainBaseId = [BaseId || #item{base_id = BaseId} <- Items],
    L1 = [I ||I = {BaseId, _, _, _, _, _} <- L, lists:member(BaseId, GainBaseId)],
    ItemMsg = notice:get_item_msg(Items1),
    RoleMsg = notice:get_role_msg(Role),
    case lists:keyfind(2, 2, L1) of
        false ->
            case lists:keyfind(1, 2, L1) of
                false ->
                    skip;
                _ -> 
                    role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"~s打开~s竟幸运的获得了~s">>),[RoleMsg, Name, ItemMsg])})
            end;
        _ ->
            role_group:pack_cast(world, 10932, {7, 1, util:fbin(?L(<<"~s打开~s竟幸运的获得了~s">>),[RoleMsg, Name, ItemMsg])})
    end.

do_use_guagua(ItemId, Role = #role{link = #link{conn_pid = ConnPid}, guaguale = Guaguale}) ->
    case guagua_data:get(ItemId) of
        false ->
            {false, ?L(<<"此刮刮卡不能使用">>)};
        L when is_list(L) ->
            SumRate = lists:sum([Rate|| {Rate, _, _} <- L]),
            ?DEBUG("总概率  ~w", [SumRate]),
            Rate = util:rand(1, SumRate),
            {[BaseId, Bind, Num], _Notice} = get_rand_guagua_item(Rate, L),
            sys_conn:pack_send(ConnPid, 10359, {ItemId, BaseId, Bind, Num}),
            ?DEBUG("抽到物品 ~w", [BaseId]),
            {ok, Role#role{guaguale = [{BaseId, Bind, Num} | Guaguale]}}
            %% role_gain:do([#gain{label = item, val = GainItem}], Role)
    end.

get_rand_guagua_item(Rate, L) ->
    do_get_rand_guagua_item(0, Rate, L).

do_get_rand_guagua_item(AccRate, Rate, [{ItemRate, GainItem, Notice} | T]) ->
    case Rate =< AccRate + ItemRate of
        true ->
            {GainItem, Notice};
        false ->
            do_get_rand_guagua_item(AccRate+ItemRate, Rate, T)
    end.
%%do_guagua_notice(Notice, ItemBaseId) ->
%%    case Notice of
%%        0 ->
%%            skip;
%%        1 ->
%%            skip;
%%        2 ->
%%            skip;
%%        _ ->
%%            skip
%%    end.
