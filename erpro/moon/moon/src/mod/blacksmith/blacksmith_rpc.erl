%%----------------------------------------------------
%% 炼器系统相关远程调用
%% @author shawnoyc@163.com
%%----------------------------------------------------

-module(blacksmith_rpc).
-export([handle/3]).

-include("item.hrl").
-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("guild.hrl").
-include("blacksmith.hrl").
-include("soul_mark.hrl").
-include("dungeon.hrl").
-include("gain.hrl").


%% 死亡状态:屏蔽所有物品操作
%% 复活: 在角色100协议处理
handle(_Cmd, _Data, #role{status = Status}) when Status =/= ?status_normal ->
    ?DEBUG("该角色状态不允许铸造操作:~w", [_Cmd]),
    {ok};

%% 获取强化信息
handle(10502, {Id}, Role = #role{eqm = Eqm}) ->
    case storage:find(Eqm, #item.id, Id) of
        {false, _Reason} -> {ok};
        {ok, #item{enchant = Enchant, base_id = BaseId, enchant_fail = Fail}} ->
            FailAdd = case Fail > 0 of true -> 0; false -> 0 end,   %% 失败加成概率暂时不用，记为0
            EqmLabel = eqm_api:get_type_name(BaseId),
            {BaseRate, _NeedStone} = enchant_data:get_rate_cost(EqmLabel, Enchant + 1),
            GuildRate = guild_role:tran_ratio(Role),    %% 军团概率保持千份比传给客户端，由客户端除以10
            VipRate = round(vip:enchant_ratio(Role) * 100),
            {_Npc, _ManorRate, F} = manor:get_enchant_rate(Role, Enchant + 1),
            ?DEBUG("------ 强化信息: 基础概率 ~p, 军团附加 ~p,  VIP概率 ~p,  庄园附加~p ~n ", [BaseRate, GuildRate, VipRate, F]),
            {reply, {BaseRate div 100, FailAdd, GuildRate, VipRate, F}} 
    end;

%% 强化10次
handle(10503, {Id, AutoBuy}, Role = #role{eqm = Eqm}) ->
    case storage:find(Eqm, #item.id, Id) of
        {false, _Reason} -> {reply, {0, ?L(<<"不存在该物品，请检查是否存在该物品">>)}};
        {ok, EqmItem = #item{enchant = Enchant}} when Enchant >= 0 ->
            role:send_buff_begin(),
            case blacksmith:enchant_equip10(EqmItem, AutoBuy, Role) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {Reason, []}};
                {ok, NewRole = #role{eqm = EqmList}, {LogEnchant, {LogWishLev, LogWishPoint}}, _Count, Flags, Msg} ->
                    rank:listener(equip, Role, NewRole),
                    Nrole = role_listener:special_event(NewRole, {1067, finish}),  
                    log:log(log_coin, {<<"强化">>, <<"成功">>, Role, NewRole}),
                    log:log(log_item_del_loss, {<<"强化">>, NewRole}),
                    log:log(log_blacksmith, {<<"强化">>, {<<"~s[(身上)强化+~w][结果+~w祝福~w:~w]">>, [EqmItem, Enchant+1, LogEnchant, LogWishLev, LogWishPoint]}, <<"成功">>, [], Role, NewRole}),
                    blacksmith_reward:listener(enchant, NewRole, LogEnchant),
                    Nrole1 = role_listener:acc_event(Nrole, {125, 1}), %%强化成功一次
                    Nrole2 = medal:listener(enchant, Nrole1),
                    {ok, EqmItem1} = storage:find(EqmList, #item.id, Id),
                    Nrole3 = set_enchant_discount_mail(EqmItem1, Nrole2),
                    rank_celebrity:enchant_suit(Nrole3),
                    role:send_buff_flush(),
                    {reply, {Msg, lists:reverse(Flags)}, Nrole3}
            end
    end;

%% 开始强化
handle(10505, {Id, AutoBuy}, Role = #role{eqm = Eqm}) ->
    case storage:find(Eqm, #item.id, Id) of
        {false, _Reason} -> {reply, {0, ?L(<<"不存在该物品，请检查是否存在该物品">>)}};
        {ok, EqmItem = #item{enchant = Enchant}} when Enchant >= 0 ->
            case storage:check_fly_and_mount(Role, EqmItem) of
                {false, _Reason} -> {reply, {0, ?L(<<"飞行中不能强化的啦">>)}};
                true -> 
                    role:send_buff_begin(),
                    case blacksmith:enchant_equip(EqmItem, AutoBuy, true, Role) of
                        {false} ->
                            {ok};
                        {false, Reason} ->
                            ?DEBUG("错误马：~w", [Reason]),
                            role:send_buff_clean(),
                            {reply, {0, Reason}};
                        {ErrCode, Reason} when is_integer(ErrCode) ->
                            role:send_buff_clean(),
                            {reply, {ErrCode, Reason}};
                        {fail, NewRole, {LogEnchant, {LogWishLev, LogWishPoint}}} ->
                            log:log(log_coin, {<<"强化">>, <<"失败">>, Role, NewRole}),
                            log:log(log_item_del_loss, {<<"强化">>, NewRole}),
                            log:log(log_blacksmith, {<<"强化">>, {<<"~s[(身上)强化+~w][结果+~w祝福~w:~w]">>, [EqmItem, Enchant+1, LogEnchant, LogWishLev, LogWishPoint]}, <<"失败">>, [], Role, NewRole}),
                            NR = role_listener:acc_event(NewRole, {108, 1}),
                            role:send_buff_flush(),
                            {reply, {0, ?L(<<"很可惜，强化没有成功">>)}, NR};
                        {ok, NewRole = #role{eqm = EqmList}, {LogEnchant, {LogWishLev, LogWishPoint}}} ->
                            rank:listener(equip, Role, NewRole),
                            Nrole = role_listener:special_event(NewRole, {1067, finish}),  
                            log:log(log_coin, {<<"强化">>, <<"成功">>, Role, NewRole}),
                            log:log(log_item_del_loss, {<<"强化">>, NewRole}),
                            log:log(log_blacksmith, {<<"强化">>, {<<"~s[(身上)强化+~w][结果+~w祝福~w:~w]">>, [EqmItem, Enchant+1, LogEnchant, LogWishLev, LogWishPoint]}, <<"成功">>, [], Role, NewRole}),
                            blacksmith_reward:listener(enchant, NewRole, LogEnchant),
                            Nrole1 = role_listener:acc_event(Nrole, {125, 1}), %%强化成功一次
                            Nrole2 = medal:listener(enchant, Nrole1),
                            {ok, EqmItem1} = storage:find(EqmList, #item.id, Id),
                            Nrole3 = set_enchant_discount_mail(EqmItem1, Nrole2),
                            rank_celebrity:enchant_suit(Nrole3),
                            role:send_buff_flush(),
                            {reply, {1, ?L(<<"恭喜您强化成功">>)}, Nrole3}
                    end
            end;
        _ -> {reply, {0, ?L(<<"物品被锁定了，不能强化">>)}}
    end;

%% 特殊孔镶嵌
handle(10509, {EqmId, StoneId, HolePos}, Role = #role{eqm = Eqm}) when HolePos =:= 8 orelse HolePos =:= 9 ->
    ItemList = Eqm,
    case storage:find(ItemList, #item.id, EqmId) of
        {false, _Reason} -> {reply, {0, ?L(<<"装备不存在，请检查是否存在该物品">>)}};
        {ok, EqmItem = #item{status = ?lock_release}} ->
            role:send_buff_begin(),
            case blacksmith:embed_equip_special(Role, EqmItem, StoneId, HolePos) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    %%{reply, {0, Reason}};
                    notice:alert(0, Role, Reason);
                {ErrCode, Reason} when is_integer(ErrCode) ->
                    role:send_buff_clean(),
                    {reply, {ErrCode, Reason}};
                {suc, StoneItem, NewRole} -> 
                    rank:listener(equip, Role, NewRole),
                    Nrole = role_listener:special_event(NewRole, {1003, finish}),  
                    log:log(log_coin, {<<"装备镶嵌">>, <<"优先">>, Role, NewRole}),
                    log:log(log_item_del_loss, {<<"镶嵌">>, NewRole}),
                    log:log(log_blacksmith, {<<"镶嵌">>, {<<"~s[宝石:~s]">>, [EqmItem, StoneItem]}, <<"成功">>, [], Role, NewRole}),
                    Nrole1 = medal:listener(bs_eqm, Nrole),
                    role:send_buff_flush(),
                    {reply, {1, ?L(<<"恭喜您镶嵌成功了，装备的能力提升了">>)}, role_api:push_attr(Nrole1)};
                {fail, StoneItem, NewRole} ->
                    rank:listener(equip, Role, NewRole),
                    log:log(log_coin, {<<"装备镶嵌">>, <<"优先">>, Role, NewRole}),
                    log:log(log_item_del_loss, {<<"镶嵌">>, NewRole}),
                    log:log(log_blacksmith, {<<"镶嵌">>, {<<"~s[宝石:~s]">>, [EqmItem, StoneItem]}, <<"失败，宝石掉级">>, [], Role, NewRole}),
                    role:send_buff_flush(),
                    {reply, {0, ?L(<<"很可惜您镶嵌没有成功，镶嵌石下降了一级">>)}, NewRole};
                {drop, StoneItem, NewRole} ->
                    rank:listener(equip, Role, NewRole),
                    log:log(log_coin, {<<"装备镶嵌">>, <<"优先">>, Role, NewRole}),
                    log:log(log_item_del_loss, {<<"镶嵌">>, Role}),
                    log:log(log_blacksmith, {<<"镶嵌">>, {<<"~s[宝石:~s]">>, [EqmItem, StoneItem]}, <<"失败，宝石消失">>, [], Role, NewRole}),
                    role:send_buff_flush(),
                    {reply, {0, ?L(<<"很可惜您镶嵌没有成功，一级的镶嵌石化成星光消逝了">>)}, NewRole}
            end;
        {ok, _} -> {reply, {0, ?L(<<"物品被锁定，不能镶嵌">>)}}
    end;

%% 开始镶嵌
handle(10509, {EqmId, StoneId, HolePos}, Role = #role{eqm = Eqm}) ->
    ItemList = Eqm,
    case storage:find(ItemList, #item.id, EqmId) of
        {false, _Reason} -> {reply, {0, ?L(<<"装备不存在，请检查是否存在该物品">>)}};
        {ok, EqmItem = #item{status = ?lock_release}} ->
            role:send_buff_begin(),
            case blacksmith:embed_equip(Role, EqmItem, StoneId, HolePos) of
                {false, _Reason} ->
                    role:send_buff_clean(),
                    ?DEBUG("----> ~p~n", [_Reason]),
                    %notice:alert(0, Role, Reason);
                    {reply, {0, ?L(<<"镶嵌失败">>)}};
                {ErrCode, Reason} when is_integer(ErrCode) ->
                    role:send_buff_clean(),
                    {reply, {ErrCode, Reason}};
                {suc, StoneItem, NewRole} -> 
                    rank:listener(equip, Role, NewRole),
                    Nrole = role_listener:special_event(NewRole, {1003, finish}),  
                    log:log(log_coin, {<<"装备镶嵌">>, <<"优先">>, Role, NewRole}),
                    log:log(log_item_del_loss, {<<"镶嵌">>, NewRole}),
                    log:log(log_blacksmith, {<<"镶嵌">>, {<<"~s[宝石:~s]">>, [EqmItem, StoneItem]}, <<"成功">>, [], Role, NewRole}),
                    NewRole1 = medal:listener(bs_eqm, Nrole),
                    role:send_buff_flush(),
                    {reply, {1, ?L(<<"恭喜您镶嵌成功了，装备的能力提升了">>)}, role_api:push_attr(NewRole1)};
                {fail, StoneItem, NewRole} ->
                    rank:listener(equip, Role, NewRole),
                    log:log(log_coin, {<<"装备镶嵌">>, <<"优先">>, Role, NewRole}),
                    log:log(log_item_del_loss, {<<"镶嵌">>, NewRole}),
                    log:log(log_blacksmith, {<<"镶嵌">>, {<<"~s[宝石:~s]">>, [EqmItem, StoneItem]}, <<"失败，宝石掉级">>, [], Role, NewRole}),
                    role:send_buff_flush(),
                    {reply, {0, ?L(<<"很可惜您镶嵌没有成功，镶嵌石下降了一级">>)}, NewRole};
                {drop, StoneItem, NewRole} ->
                    rank:listener(equip, Role, NewRole),
                    log:log(log_coin, {<<"装备镶嵌">>, <<"优先">>, Role, NewRole}),
                    log:log(log_item_del_loss, {<<"镶嵌">>, Role}),
                    log:log(log_blacksmith, {<<"镶嵌">>, {<<"~s[宝石:~s]">>, [EqmItem, StoneItem]}, <<"失败，宝石消失">>, [], Role, NewRole}),
                    role:send_buff_flush(),
                    {reply, {0, ?L(<<"很可惜您镶嵌没有成功，一级的镶嵌石化成星光消逝了">>)}, NewRole}
            end;
        {ok, _} -> {reply, {0, ?L(<<"物品被锁定，不能镶嵌">>)}}
    end;

%% 开始洗练
handle(10510, {EqmId, Mode, _}, Role = #role{eqm = Eqm}) when Mode =:= 2 ->
            case storage:find(Eqm, #item.id, EqmId) of
                {false, _Reason} -> {reply, {0, ?L(<<"装备不存在，请检查是否存在该物品">>),[]}};
                {ok, #item{polish = Polish}} ->
                    {reply, {1, ?L(<<"">>), Polish}, Role}
            end;

handle(10510, {EqmId, Mode, AutoBuy}, Role = #role{eqm = Eqm}) ->
    case storage:find(Eqm, #item.id, EqmId) of
        {false, _Reason} -> {reply, {0, <<"找不到装备">>,[]}};
        {ok, EqmItem = #item{status = ?lock_release, polish = Polish}} ->
            role:send_buff_begin(),
            case blacksmith:polish_equip(Role, EqmItem, Mode, AutoBuy) of
                {false} ->
                    {ok};
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {0, Reason, Polish}, Role};
                {ok, NewRole, NewEqmItem = #item{polish = NewPolish, wash_cnt = _WashCnt}} ->
                    NewEqmList = lists:keyreplace(NewEqmItem#item.id, #item.id, Eqm, NewEqmItem),
                    NewRole1 = NewRole#role{eqm = NewEqmList},
                    case blacksmith:add_polish(NewRole1, 1, 1, NewEqmItem) of
                        {false, Reason} -> {reply, {0, Reason}};
                        {ok, NewRole2, NewEqmItem1} ->
                            rank:listener(equip, NewRole1, NewRole2),
                            log:log(log_coin, {<<"洗炼">>, <<"单次洗炼">>, Role, NewRole}),
                            Nr1 = role_listener:eqm_event(NewRole2, update),
                            NR = role_listener:special_event(Nr1, {1064, finish}),
                            log:log(log_blacksmith, {<<"选定洗练">>, {<<"~s[背包]">>, [NewEqmItem]}, <<"成功">>, [NewEqmItem, NewEqmItem1], NewRole1, NewRole2}),
                            NR1 = medal:listener(jd_suit, NR),
                            NR2 = role_listener:special_event(NR1, {3015, 1}),  %%触发日常
                            role:send_buff_flush(),
                            {reply, {1, ?L(<<"洗练成功">>), NewPolish}, role_api:push_attr(NR2)}
                    end
            end
    end;       

%% 开始合成
handle(10511, {StoneId, Type, Num, Mode}, Role = #role{}) when Num > 0 ->
    role:send_buff_begin(),
    case blacksmith:fuse_stone(Role, StoneId, Type, Num, Mode) of
        {false, Reason} ->
            role:send_buff_clean(),
            {reply,{StoneId, 0, Reason}};
        {ErrCode, Reason} when is_integer(ErrCode) ->
            role:send_buff_clean(),
            {reply, {StoneId, ErrCode, Reason}};
        {ok, NewRole, SucNum} -> 
            Name = get_name(StoneId),
            log:log(log_coin, {<<"合成">>, <<"优先">>, Role, NewRole}),
            log:log(log_blacksmith, {<<"合成">>, util:fbin(<<"合成:~s~w个配方:~w成功:~w个">>, [Name, Num, Type, SucNum]), <<"成功">>, [], Role, NewRole}),
            Nr = role_listener:acc_event(NewRole, {117, SucNum}), %%生成成功一次
            Nrole = role_listener:special_event(Nr, {1007, finish}),  
            blacksmith:broad_combine(NewRole, StoneId, SucNum),
            case Num > 1 of
                true -> 
                    Info = util:fbin(?L(<<"恭喜您成功合成了~w个物品">>), [SucNum]),
                    role:send_buff_flush(),
                    {reply, {StoneId, 1, Info}, Nrole};
                false ->
                    role:send_buff_flush(),
                    {reply, {StoneId, 1, ?L(<<"恭喜您合成成功了，继续收集材料吧">>)}, Nrole}
            end;
        {fail, NewRole} ->
            Name = get_name(StoneId),
            log:log(log_coin, {<<"合成">>, <<"优先">>, Role, NewRole}),
            log:log(log_blacksmith, {<<"合成">>, util:fbin(<<"生产:~s~w个配方:~w">>, [Name, Num, Type]), <<"失败">>, [], Role, NewRole}),
            role:send_buff_flush(),
            {reply, {StoneId, 0, ?L(<<"很可惜，合成没有成功">>)}, NewRole}
    end;


%% 精炼预览
handle(10515, {StorageType1, EqmId1, StorageType2, _, Mode, Type}, Role = #role{eqm = EqmList, bag = Bag})
when (StorageType1 =:= ?storage_eqm orelse StorageType1 =:= ?storage_bag)
andalso Mode >= 1 andalso Mode =< 4
andalso StorageType2 =:= 0 ->
    ?DEBUG("类型精炼类型 ~w", [Type]),
    Items = case StorageType1 of
        ?storage_bag -> Bag#bag.items;
        ?storage_eqm -> EqmList
    end,
    case storage:find(Items, #item.id, EqmId1) of
        {false, _R} -> {ok};
        {ok, EqmItem = #item{base_id = BaseId}} ->
            case refine_data:get(BaseId, Type) of
                {false, _R2} -> {ok};
                {NextId, _Del, _NeedCoin, _} ->
                    case item:make(NextId, 0, 1) of
                        false -> {ok};
                        {ok, [RefItem]} ->
                            NewItem = blacksmith:swap_attr(EqmItem, RefItem),
                            {ok, #item_base{condition = Cond}} = item_data:get(NewItem#item.base_id),
                            PutItem = case role_cond:check(Cond, Role) of
                                {false, _} -> NewItem;
                                true -> NewItem
                            end,
                            item:item_to_view(PutItem)
                    end
            end
    end;

%% 装备精炼 
handle(10516, {EqmId}, Role = #role{eqm = EqmList}) ->
    case storage:find(EqmList, #item.id, EqmId) of
        {false, _R} ->
            {reply, {?false, ?L(<<"装备不存在，请检查是否存在该物品">>)}};
        {ok, EqmItem = #item{base_id = BaseId, require_lev = Lev, quality = Q}} ->
            role:send_buff_begin(),
            case blacksmith:refining_eqm(Role, [EqmItem]) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {?false, Reason}};
                {ErrCode, Reason} when is_integer(ErrCode) ->
                    role:send_buff_clean(),
                    {reply, {ErrCode, Reason}};
                {ok, Role1} ->
                    log:log(log_coin, {<<"装备精炼">>, <<"精炼方式1">>, Role, Role1}),
                    log:log(log_item_del_loss, {<<"装备精炼">>, Role1}),
                    log:log(log_blacksmith, {<<"精炼">>, {<<"~s[装备精炼]">>, [EqmItem]}, <<"成功">>, [], Role, Role1}),
                    rank:listener(equip, Role, Role1),
                    Role2 = role_listener:eqm_event(Role1, update),
                    Role3 = role_listener:special_event(Role2, {1066, finish}),
                    role:send_buff_flush(),
                    blacksmith:broad_refine(Role3, BaseId),
                    Role4 = medal:listener(eqm, Role3),
                    Role5 =
                    case eqm:eqm_type(BaseId) =:= ?item_weapon andalso Lev =:= 30 andalso Q =:= ?quality_green of
                        true ->
                            vip:set_discount_mail(refine_30_blue_eqm, Role4);
                        false ->
                            Role4
                    end,
                    {reply, {?true, ?L(<<"恭喜您精炼成功了">>)}, Role5}
            end
    end;

%% 摘除宝石
handle(10518, {EqmId, Stonepos}, Role = #role{eqm = Eqm}) ->
    ItemList = Eqm,
    case storage:find(ItemList, #item.id, EqmId) of
        {false, _Reason} -> {reply, {0, ?L(<<"装备不存在，请检查是否存在该物品">>)}};
        {ok, EqmItem = #item{status = ?lock_release}} ->
            role:send_buff_begin(),
            case blacksmith:remove_eqm(Role, EqmItem, Stonepos) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {0, Reason}};
                {suc, _Sid, Role1} -> 
                    log:log(log_item_del_loss, {<<"摘除宝石">>, Role1}),
                    rank:listener(equip, Role, Role1),
                    role:send_buff_flush(),
                    {reply, {1, ?L(<<"摘除成功">>)}, role_api:push_attr(Role1)}
            end;
        {ok, _} -> {reply, {0, ?L(<<"物品被锁定，不能摘除">>)}}
    end;


%% 批量洗练
handle(10522, {Id, 2, _}, #role{eqm = Eqms}) ->
    case storage:find(Eqms, #item.id, Id) of
        {false, _Reason} -> {reply, {0, <<>>, []}};
        {ok, #item{polish_list = PolishList}} ->
            {reply, {1, <<>>, PolishList}}
    end;

handle(10522, {Id, Mode, AutoBuy}, Role = #role{eqm = Eqm}) when Mode =:= 1 ->
    case storage:find(Eqm, #item.id, Id) of
        {false, Reason} -> {reply, {0, Reason, []}};
        {ok, EqmItem = #item{polish_list = Polish}} ->
            role:send_buff_begin(),
            case blacksmith:batch_polish(Role, EqmItem, Mode, AutoBuy) of
                {false} ->
                    ok;
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {?false, Reason, Polish}};
                {ErrCode, Reason} when is_integer(ErrCode) ->
                    role:send_buff_clean(),
                    ?DEBUG(" Reason : ~s", [Reason]),
                    {reply, {?false, Reason, []}};
                {ok, NewRole, NewEqmItem = #item{polish_list = PolishList, wash_cnt = _WashCnt}} ->
                    ?DEBUG("当前洗练次数  : ~w", [_WashCnt]),
                    NewEqmList = lists:keyreplace(NewEqmItem#item.id, #item.id, Eqm, NewEqmItem),
                    NewRole1 = NewRole#role{eqm = NewEqmList},
                    log:log(log_coin, {<<"批量洗练">>, <<"洗炼">>, Role, NewRole1}),
                    log:log(log_item_del_loss, {<<"批量洗练">>, NewRole1}),
                    log:log(log_blacksmith, {<<"批量洗练">>, {<<"~s[装备]">>, [EqmItem]}, <<"成功">>, [], Role, NewRole1}),
                    NR = role_listener:acc_event(NewRole1, {111, 1}),
                    NR1 = role_listener:special_event(NR, {1064, finish}),
                    NR2 = medal:listener(jd_suit, NR1),
                    NR3 = role_listener:special_event(NR2, {3015, 5}),  %%触发日常
                    role:send_buff_flush(),
                    {reply, {?true, <<"">>, PolishList}, NR3}
                end
    end;


%% 选定洗练属性
handle(10523, {_, _, Polish_Id}, _Role) when Polish_Id > 8 ->
    {reply, {?false, ?L(<<"不存在该洗练属性">>)}};
handle(10523, {Id, 1, Polish_Id}, Role = #role{eqm = Eqm}) -> %% 选定单次洗炼属性
    case storage:find(Eqm, #item.id, Id) of
        {false, _Reason} -> {reply, {0, <<>>}};
        {ok, EqmItem} ->
            case blacksmith:add_polish(Role, Polish_Id, 1, EqmItem) of
                {false, Reason} -> {reply, {0, Reason}};
                {ok, NewRole, NewEqmItem} ->
                    rank:listener(equip, Role, NewRole),
                    Nr1 = role_listener:eqm_event(NewRole, update),
                    NR = role_listener:special_event(Nr1, {1013, finish}),
                    log:log(log_blacksmith, {<<"选定洗练">>, {<<"~s[背包]">>, [EqmItem]}, <<"成功">>, [EqmItem, NewEqmItem], Role, NewRole}),
                    {reply, {1, ?L(<<"选定洗练属性成功">>)}, NR}
            end
    end;
handle(10523, {Id, 2, Polish_Id}, Role = #role{eqm = Eqm}) -> %% 选定批量洗炼属性
    case storage:find(Eqm, #item.id, Id) of
        {false, _Reason} -> {reply, {0, <<>>}};
        {ok, EqmItem} ->
            case blacksmith:add_polish(Role, Polish_Id, 2, EqmItem) of
                {false, Reason} -> {reply, {0, Reason}};
                {ok, NewRole, NewEqmItem} ->
                    rank:listener(equip, Role, NewRole),
                    eqm_api:find_skill_attr_push(NewRole),
                    Nr1 = role_listener:eqm_event(NewRole, update),
                    NR = role_listener:special_event(Nr1, {1013, finish}),
                    log:log(log_blacksmith, {<<"选定洗练">>, {<<"~s[装备]">>, [EqmItem]}, <<"成功">>, [EqmItem, NewEqmItem], Role, NewRole}),
                    {reply, {1, ?L(<<"选定洗练属性成功">>)}, role_api:push_attr(NR)}
            end
    end;

%% 开始升级装备 -- 也叫合成装备 制造装备
handle(10544, {Id, IsUse}, Role = #role{eqm = Eqms}) ->
    case storage:find(Eqms, #item.id, Id) of
        {false, _Reason} -> {reply, {?false, ?L(<<"不存在该物品，请检查是否存在该物品">>)}};
        {ok, EqmItem = #item{require_lev = Lev, base_id = BaseId}}  ->
            role:send_buff_begin(),
            case blacksmith:lvlup_equip(Role, EqmItem, IsUse) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {?false, Reason}};
                {ok, Role1, NewItem} ->
                    Role2 = role_listener:special_event(Role1, {1063, 1}),  
                    log:log(log_coin, {<<"升级装备">>, <<"成功,优先绑定">>, Role, Role2}),
                    log:log(log_item_del_loss, {<<"升级装备">>, Role2}),
                    log:log(log_blacksmith, {<<"升级装备">>, {<<"~s[装备]">>, [NewItem]}, <<"成功">>, [], Role, Role1}),
                    Role3 = medal:listener(eqm, Role2),
                    rank_celebrity:c_suit(Role3),
                    Role4 = case Lev =:= 20 andalso eqm:eqm_type(BaseId) =:= ?item_weapon of %% 制造了30级武器，给它一个优惠邮件
                        true -> vip:set_discount_mail(make_30_eqm, Role3);
                        false -> Role3
                    end,
                    role:send_buff_flush(),
                    {reply, {?true, ?L(<<"恭喜您升级成功">>)}, Role4}
            end;
        _ ->
            ?DEBUG(" -- >> 失败"),
            {reply, {0, ?L(<<"物品被锁定了，不能升级">>)}}
    end;

%% 升级宝石
handle(10545, {EqmId, HolePos}, Role = #role{eqm = Eqms}) ->
    case storage:find(Eqms, #item.id, EqmId) of
        {false, _Reason} -> {reply, {?false, 0, ?L(<<"不存在该物品，请检查是否存在该物品">>)}};
        {ok, EqmItem}  ->
            role:send_buff_begin(),
            case blacksmith:lvlup_stone(Role, EqmItem, HolePos) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {?false, 0, Reason}};
                {ok, NewStoneId, Role1} ->
                    Role2 = role_listener:special_event(Role1, {1063, 1}),  
                    log:log(log_coin, {<<"升级宝石">>, <<"成功,优先绑定">>, Role, Role2}),
                    log:log(log_item_del_loss, {<<"升级">>, Role2}),
                    role:send_buff_flush(),
                     rank_celebrity:c_suit(Role2),
                     blacksmith:broad_combine(Role2, NewStoneId, 0),
                     Role3 = medal:listener(eqm, Role2),
                     Role4 = medal:listener(bs_eqm, Role3),
                    {reply, {?true, NewStoneId, ?L(<<"恭喜您升级成功">>)}, Role4}
            end;
        _ ->
            ?DEBUG(" -- >> 失败"),
            {reply, {0, 0, ?L(<<"物品被锁定了，不能升级">>)}}
    end;


%% 容错
handle(_Cmd, _Data, _Role) ->
    {error, blacksmith_rpc_unknow_command}.

%% ---------------------------------------------------------------------------------
%% 内部函数
%% ---------------------------------------------------------------------------------

set_enchant_discount_mail(#item{base_id = BaseId, enchant = Enchant}, Role) -> 
    case eqm:eqm_type(BaseId) =:= ?item_weapon andalso Enchant =:= 5 of
            true ->
                vip:set_discount_mail(weapon_enchant_5, Role);
            false ->
                case eqm:eqm_type(BaseId) =:= ?item_yi_fu andalso Enchant =:= 5 of
                    true ->
                        vip:set_discount_mail(cloth_enchant_5, Role);
                    false ->
                        Role
                end
    end.

get_name(BaseId) ->
    case item_data:get(BaseId) of
        {ok, #item_base{name = Name}} -> Name;
        _ -> <<"">>
    end.
