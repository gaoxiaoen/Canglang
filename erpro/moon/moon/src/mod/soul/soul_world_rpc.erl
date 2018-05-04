%%----------------------------------------------------
%% @doc 灵戒洞天协议处理
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(soul_world_rpc).
-export([
        handle/3
        ,push/3
    ]).

-include("common.hrl").
-include("role.hrl").
-include("soul_world.hrl").
%%
-include("dungeon.hrl").

%% 查看仙魔居
handle(17900, {}, Role = #role{pid = Pid}) ->
    push(17900, Pid, Role),
    {ok};

%% 召唤妖灵
handle(17901, {Type, IsBatch}, Role) ->
    case soul_world:call_out(Role, Type, IsBatch) of
        {ok, NewRole = #role{soul_world = #soul_world{calleds = Calleds, orange_luck = OrangeLuck, purple_luck = PurpleLuck, last_called = LastCalled, today_called = TodayCalled}}} ->
            FreeTime = case util:is_same_day2(util:unixtime(), LastCalled) of
                true -> max(0, ?soul_world_free_call_time - TodayCalled);
                _ -> ?soul_world_free_call_time
            end,
            ?DEBUG("橙色幸运值 ~w 紫色幸运值 ~w", [OrangeLuck, PurpleLuck]),
            {reply, {?true, ?L(<<"召唤成功">>), IsBatch, round(OrangeLuck * 100 / ?soul_world_gold_call_max_luck), round(PurpleLuck * 100 / ?soul_world_coin_call_max_luck), FreeTime, Calleds}, NewRole};
        wrong_event ->
            {reply, {?false, ?L(<<"当前状态不能进行灵戒洞天相关操作">>), IsBatch, 0, 0, 0, []}};
        gold_less ->
            {reply, {?gold_less, ?L(<<"召唤失败">>), IsBatch, 0, 0, 0, []}};
        coin_less ->
            {reply, {?coin_less, ?L(<<"召唤失败">>), IsBatch, 0, 0, 0, []}};
        role_lev_lower ->
            {reply, {?false, ?L(<<"需要角色提升到62级才能使用灵戒洞天功能">>), IsBatch, 0, 0, 0, []}};
        max_num ->
            {reply, {?false, ?L(<<"你已经收集完所有的妖灵，不用再召唤">>), IsBatch, 0, 0, 0, []}};
        _Else ->
            {reply, {?false, ?L(<<"召唤失败">>), IsBatch, 0, 0, 0, []}}
    end;

%% 唤醒妖灵
handle(17902, {Id}, Role = #role{pid = Pid}) ->
    case soul_world:wake_up(Role, Id) of
        {ok, NewRole} ->
            role:pack_send(Pid, 17902, {?true, ?L(<<"成功唤醒妖灵">>), Id}),
            push(17900, Pid, NewRole),
            NewRole2 = role_api:push_attr(NewRole),
            NewRole3 = soul_world:listener(NewRole2),
            {ok, NewRole3};
        role_lev_lower ->
            {reply, {?false, ?L(<<"需要角色提升到62级才能使用灵戒洞天功能">>), Id}};
        wrong_event ->
            {reply, {?false, ?L(<<"当前状态不能进行灵戒洞天相关操作">>), Id}};
        exist ->
            {reply, {?false, ?L(<<"该妖灵已经被唤醒过">>), Id}};
        no_called ->
            {reply, {?false, ?L(<<"该妖灵已经被唤醒过">>), Id}};
        _Else ->
            {reply, {?false, ?L(<<"唤醒失败">>), Id}}
    end;

%% 喂养妖灵
handle(17903, {Id, Items}, Role) ->
    case soul_world:feed(Role, Items, Id) of
        {ok, NewRole, AddExp, true} ->
            NewRole1 = soul_world:listener(NewRole),
            {reply, {?true, AddExp, util:fbin(?L(<<"今天是灵戒吉日，受到运势作用，您喂养妖灵获得双倍经验：~w点">>), [AddExp])}, NewRole1};
        {ok, NewRole, AddExp, _} ->
            NewRole1 = soul_world:listener(NewRole),
            {reply, {?true, AddExp, util:fbin(?L(<<"喂养成功,妖灵获得~w经验">>), [AddExp])}, NewRole1};
        wrong_event ->
            {reply, {?false, 0, ?L(<<"当前状态不能进行灵戒洞天相关操作">>)}};
        max_lev ->
            {reply, {?false, 0, ?L(<<"妖灵已经是最高级别了">>)}};
        exp_over ->
            {reply, {?false, 0, ?L(<<"喂养的物品增加的经验已经超过精灵所能接受的最大值了">>)}};
        role_lev_lower ->
            {reply, {?false, 0, ?L(<<"需要角色提升到62级才能使用灵戒洞天功能">>)}};
        not_found ->
            {reply, {?false, 0, ?L(<<"妖灵不存在">>)}};
        {false, Msg} ->
            {reply, {?false, 0, Msg}};
        _Else ->
            {reply, {?false, 0, ?L(<<"喂养成功">>)}}
    end;

%% 查看单个妖灵
handle(17904, {Id}, #role{pid = Pid, soul_world = #soul_world{spirits = Spirits}}) ->
    case lists:keyfind(Id, #soul_world_spirit.id, Spirits) of
        Sp = #soul_world_spirit{} ->
            push(17904, Pid, Sp);
        _ ->
            ok
    end,
    {ok};

%% 神魔阵
handle(17905, {}, Role = #role{pid = Pid}) ->
    push(17905, Pid, Role),
    {ok};

%% 封印妖灵
handle(17906, {SpId, ArrayId}, Role) ->
    case soul_world:seal(Role, SpId, ArrayId) of
        {ok, NewRole} ->
            NewRole1 = soul_world:listener(NewRole),
            {reply, {?true, ?L(<<"封印成功">>)}, NewRole1};
        wrong_event ->
            {reply, {?false, ?L(<<"当前状态不能进行灵戒洞天相关操作">>)}};
        lev_lower ->
            {reply, {?false, ?L(<<"1级以阵印才能进行封印操作">>)}};
        sealed ->
            {reply, {?false, ?L(<<"对应的妖灵已经在封印中，不能再次封印">>)}};
        array_used ->
            {reply, {?false, ?L(<<"该阵印已经在使用中">>)}};
        array_not_found ->
            {reply, {?false, ?L(<<"封印不存在">>)}};
        _Else ->
            {reply, {?false, ?L(<<"封印失败">>)}}
    end;

%% 解开妖灵封印
handle(17907, {SpId}, Role) ->
    case soul_world:unseal(Role, SpId) of
        {ok, NewRole} ->
            NewRole1 = soul_world:listener(NewRole),
            {reply, {?true, ?L(<<"成功释放妖灵">>)}, NewRole1};
        wrong_event ->
            {reply, {?false, ?L(<<"当前状态不能进行灵戒洞天相关操作">>)}};
        unsealed ->
            {reply, {?false, ?L(<<"妖灵不在封印状态">>)}};
        spirit_not_found ->
            {reply, {?false, ?L(<<"妖灵不存在">>)}};
        _Else ->
            {reply, {?false, ?L(<<"释放妖灵失败">>)}}
    end;

%% 封印升级
handle(17908, {ArrayId}, Role) ->
    case soul_world:upgrade_array(Role, ArrayId) of
        {ok, NewRole} ->
            log:log(log_coin, {<<"神魔阵升级">>, <<"">>, Role, NewRole}),
            {reply, {?true, ?L(<<"封印开始升级">>)}, NewRole};
        wrong_event ->
            {reply, {?false, ?L(<<"当前状态不能进行灵戒洞天相关操作">>)}};
        max_lev ->
            {reply, {?false, ?L(<<"封印已经是最高等级">>)}};
        coin_less ->
            {reply, {?coin_less, ?L(<<"封印升级失败">>)}};
        item_less ->
            {reply, {?false, ?L(<<"神魔阵升级丹不足">>)}};
        role_lev_lower ->
            {reply, {?false, ?L(<<"需要角色提升到62级才能使用灵戒洞天功能">>)}};
        pre_lev_lower ->
            {reply, {?false, ?L(<<"前置封印等级不够">>)}};
        upgrading ->
            {reply, {?false, ?L(<<"已经有一个封印在升级中">>)}};
        not_found ->
            {reply, {?false, ?L(<<"封印不存在">>)}};
        _Else ->
            {reply, {?false, ?L(<<"封印升级失败">>)}}
    end;

%% 封印升级加速
handle(17909, {ArrayId, Reduce}, Role) ->
    case soul_world:speed_up(Role, ArrayId, Reduce) of
        {ok, NewRole} ->
            NewRole1 = soul_world:listener(NewRole),
            {reply, {?true, ?L(<<"升级加速成功">>)}, NewRole1};
        wrong_event ->
            {reply, {?false, ?L(<<"当前状态不能进行灵戒洞天相关操作">>)}};
        gold_less ->
            {reply, {?gold_less, ?L(<<"封印加速失败">>)}};
        not_found ->
            {reply, {?false, ?L(<<"封印不存在">>)}};
        no_upgrading ->
            {reply, {?false, ?L(<<"阵印不在升级中">>)}};
        _Else ->
            {reply, {?false, ?L(<<"封印加速失败">>)}}
    end;

%% 查看好友列表或排行
handle(17910, {Type}, _Role) ->
    List = case Type of
        0 -> soul_world:get_friends();
        _ -> soul_world:get_rank()
    end,
    F = fun(#soul_world_role{id = {Id, SrvId}, name = Name, sex = Sex, array_lev = ArrayLev}) ->
            {Id, SrvId, Name, Sex, ArrayLev}
    end,
    {reply, {Type, [F(One) || One <- List]}};

%% 查看其他玩家的妖灵信息
handle(17911, {Id, SrvId}, _Role) ->
    case soul_world:lookup({Id, SrvId}) of
        R = #soul_world_role{ name = Name, career = Career, face_id = FaceId, spirits = Spirits, arrays = Arrays, pet_arrays = PetArrays} ->
            AllFc = soul_world:calc_fight_capacity(R),
            AllPetFc = soul_world:calc_pet_fc(R),
            {reply, {Id, SrvId, Name, Career, FaceId, Spirits, Arrays, AllFc, PetArrays, AllPetFc}};
        _ ->
            {ok}
    end;

%% 妖灵法宝升级
handle(17912, {SpId, Type}, Role) ->
    case soul_world:upgrade_magic(Role, SpId, Type) of
        {ok, AddLuck, NewRole} ->
            log:log(log_coin, {<<"妖灵法宝升级">>, <<"">>, Role, NewRole}),
            NewRole2 = role_api:push_attr(NewRole),
            NewRole3 = role_listener:special_event(NewRole2, {1063, 1}),
            {reply, {?true, util:fbin(?L(<<"法宝增加~w点幸运值，幸运值越高，升级成功的概率越高">>), [AddLuck])}, NewRole3};
        {double, AddLuck, NewRole} ->
            log:log(log_coin, {<<"妖灵法宝升级">>, <<"">>, Role, NewRole}),
            NewRole2 = role_api:push_attr(NewRole),
            NewRole3 = role_listener:special_event(NewRole2, {1063, 1}),
            {reply, {?true, util:fbin(?L(<<"今天是灵戒吉日，受到运势作用，您本次提升获得双倍幸运值：~w点。">>), [AddLuck])}, NewRole3};
        {up, NewLev, NewRole} ->
            log:log(log_coin, {<<"妖灵法宝升级">>, <<"">>, Role, NewRole}),
            NewRole2 = role_api:push_attr(NewRole),
            NewRole3 = role_listener:special_event(NewRole2, {1063, 1}),
            NewRole4 = soul_world:listener(NewRole3),
            {reply, {?true, util:fbin(?L(<<"法宝成功升到~w级">>), [NewLev])}, NewRole4};
        wrong_event ->
            {reply, {?false, ?L(<<"当前状态不能进行灵戒洞天相关操作">>)}};
        spirit_not_found ->
            {reply, {?false, ?L(<<"妖灵不存在">>)}};
        coin_less ->
            {reply, {?coin_less, ?L(<<"妖灵法宝升级失败">>)}};
        item_less ->
            {reply, {?false, ?L(<<"法宝进阶丹不够">>)}};
        _Else ->
            {reply, {?false, ?L(<<"妖灵法宝升级失败">>)}}
    end;

%% 获取妖灵兑换商城信息
handle(17913, {}, _Role) ->
    Shop = soul_world:get_shop(),
    {reply, {Shop}};

%% 兑换物品
handle(17914, {Type, GoodsId}, Role) ->
    case soul_world:exchange(Role, Type, GoodsId) of
        {ok, NewRole} when Type =:= 1 ->
            {reply, {?true, ?L(<<"兑换成功">>)}, NewRole};
        {ok, NewRole} ->
            NewRole2 = role_api:push_attr(NewRole),
            NewRole3 = soul_world:listener(NewRole2),
            {reply, {?true, ?L(<<"兑换成功">>)}, NewRole3};
        no_goods ->
            {reply, {?false, ?L(<<"没有指定的妖魂或妖灵">>)}};
        item_less ->
            {reply, {?false, ?L(<<"没有足够的妖灵残魂">>)}};
        exist ->
            {reply, {?false, ?L(<<"该妖灵已经被唤醒过">>)}};
        _Else ->
            {reply, {?false, ?L(<<"兑换失败">>)}}
    end;

%% 预览妖灵合并
handle(17915, {MasterId, SlaveId}, Role) ->
    case soul_world:view_merge_spirits(Role, MasterId, SlaveId) of
        #soul_world_spirit{id = Id, name = Name, lev = Lev, quality = Quality, fc = Fc, exp = Exp, max_exp = MaxExp, array_id = ArrayId, generation = Generation, magics = Magics} ->
            ?DEBUG("预览妖灵融合 "),
            Data = {Id, Name, Lev, Quality, Fc, Exp, MaxExp, Generation, ArrayId, Magics},
            {reply, Data};
        _R ->
            ?DEBUG("预览妖灵融合错误 ~w", [_R]),
        {ok}
    end;

%% 妖灵合并
handle(17916, {MasterId, SlaveId}, Role = #role{pid = Pid}) ->
    case soul_world:merge_spirits(Role, MasterId, SlaveId) of
        {ok, NewRole} ->
            push(17900, Pid, NewRole),
            push(17905, Pid, NewRole),
            NewRole2 = role_api:push_attr(NewRole),
            NewRole3 = soul_world:listener(NewRole2),
            {reply, {?true, ?L(<<"妖灵成功融合">>)}, NewRole3};
        sealed ->
            {reply, {?false, ?L(<<"封印中的妖灵不能融合">>)}};
        quality_wrong ->
            {reply, {?false, ?L(<<"这么高级的祭品，主妖灵消受不起">>)}};
        spirit_not_found ->
            {reply, {?false, ?L(<<"妖灵不存在">>)}};
        _Else ->
            {reply, {?false, ?L(<<"妖灵成功失败">>)}}
    end;

%% 宠物阵
handle(17917, {}, Role = #role{pid = Pid}) ->
    push(17917, Pid, Role),
    {ok};

%% 一键提升阵法
handle(17918, {Type, Lev}, Role) ->
    case soul_world:fast_upgrade_array(Role, Type, Lev) of
        {ok, NewRole} ->
            log:log(log_coin, {<<"一键提升灵宠阵">>, <<"">>, Role, NewRole}),
            {reply, {?true, util:fbin(?L(<<"成功把所有封印升级到~w级">>), [Lev])}, NewRole};
        too_low ->
            {reply, {?false, ?L(<<"目标等级不能小于当前等级">>)}};
        coin_less ->
            {reply, {?coin_less, ?L(<<"升级失败">>)}};
        gold_less ->
            {reply, {?gold_less, ?L(<<"升级失败">>)}};
        _R ->
            {reply, {?false, ?L(<<"升级失败">>)}}
    end;

%% 获取工作坊配置和已激活列表
handle(17919, {}, #role{soul_world = #soul_world{workshop = WorkShop}}) ->
    Bases = [soul_world_data:get_workshop(Id) || Id <- soul_world_data:get_workshop_ids()],
    {reply, {Bases, WorkShop}};

%% 工作坊已激活列表
handle(17920, {}, Role = #role{pid = Pid}) ->
    push(17920, Pid, Role),
    {ok};

%% 激活工作坊
handle(17921, {ItemId}, Role = #role{pid = Pid}) ->
    case soul_world:unlock_workshop(Role, ItemId) of
        {ok, NewRole} ->
            log:log(log_coin, {<<"激活妖灵工坊">>, <<"">>, Role, NewRole}),
            push(17920, Pid, NewRole),
            {reply, {?true, ?L(<<"成功激活">>)}, NewRole};
        coin_less ->
            {reply, {?coin_less, ?L(<<"激活失败">>)}};
        gold_less ->
            {reply, {?gold_less, ?L(<<"激活失败">>)}};
        no_workshop ->
            {reply, {?false, ?L(<<"没有这个物品">>)}};
        no_worker->
            {reply, {?false, ?L(<<"工坊还没封印任何妖灵，不能进行激活">>)}};
        fc_lower ->
            {reply, {?false, ?L(<<"您的妖灵总战力还达不到激活该工坊的要求">>)}};
        _Else ->
            {reply, {?false, ?L(<<"激活失败">>)}}
    end;

%% 开始生产
handle(17922, {ItemId, Num}, Role = #role{pid = Pid}) ->
    case soul_world:start_produce(Role, ItemId, Num) of
        {ok, NewRole} ->
            log:log(log_coin, {<<"妖灵工坊开始生产">>, <<"">>, Role, NewRole}),
            push(17925, Pid, NewRole),
            {reply, {?true, ?L(<<"成功开始生产">>)}, NewRole};
        coin_less ->
            {reply, {?coin_less, ?L(<<"不能开始生产">>)}};
        gold_less ->
            {reply, {?gold_less, ?L(<<"不能开始生产">>)}};
        no_workshop ->
            {reply, {?false, ?L(<<"没有这个物品">>)}};
        workshop_busy ->
            {reply, {?false, ?L(<<"没有可用的生产线">>)}};
        no_worker ->
            {reply, {?false, ?L(<<"工坊还没封印任何妖灵，不能进行生产">>)}};
        _Else ->
            {reply, {?false, ?L(<<"不能开始生产">>)}}
    end;

%% 获取产品
handle(17923, {Id}, Role = #role{pid = Pid}) ->
    case soul_world:get_product(Role, Id) of
        {ok, NewRole} ->
            push(17925, Pid, NewRole),
            {reply, {?true, ?L(<<"成功获取物品">>)}, NewRole};
        not_producing->
            {reply, {?false, ?L(<<"不在生产中">>)}};
        not_finish ->
            {reply, {?false, ?L(<<"还没完成生产">>)}};
        _Else ->
            {reply, {?false, ?L(<<"获取物品失败">>)}}
    end;

%% 增加生产线
handle(17924, {}, Role = #role{pid = Pid}) ->
    case soul_world:add_product_line(Role) of
        {ok, NewRole} ->
            push(17925, Pid, NewRole),
            {reply, {?true, ?L(<<"成功激活一个生产线">>)}, NewRole};
        max_product_line ->
            {reply, {?false, ?L(<<"您的生产线已经满了">>)}};
        no_worker ->
            {reply, {?false, ?L(<<"工坊还没封印任何妖灵，不能进行激活">>)}};
        coin_less ->
            {reply, {?coin_less, ?L(<<"激活失败">>)}};
        gold_less ->
            {reply, {?gold_less, ?L(<<"激活失败">>)}};
        _Else ->
            {reply, {?false, ?L(<<"激活失败">>)}}
    end;

%% 获取生产线状态
handle(17925, {}, Role = #role{pid = Pid}) ->
    push(17925, Pid, Role),
    {ok};

%% 获取封印在工坊的妖灵
handle(17926, {}, #role{soul_world = #soul_world{workshop_spirit_id = SpId}}) ->
    {reply, {SpId}};

%% 花晶钻快速获取产品
handle(17927, {Id}, Role = #role{pid = Pid}) ->
    case soul_world:fast_get_product(Role, Id) of
        {ok, NewRole} ->
            push(17925, Pid, NewRole),
            {reply, {?true, ?L(<<"成功获取物品">>)}, NewRole};
        not_producing->
            {reply, {?false, ?L(<<"不在生产中">>)}};
        not_finish ->
            {reply, {?false, ?L(<<"还没完成生产">>)}};
        gold_less ->
            {reply, {?gold_less, ?L(<<"获取物品失败">>)}};
        _Else ->
            {reply, {?false, ?L(<<"获取物品失败">>)}}
    end;

%% 取消生产
handle(17928, {Id}, Role) ->
    case soul_world:cancel_producing(Role, Id) of
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"已成功取消生产">>)}, NewRole};
        {false, Reason} when is_bitstring(Reason) ->
            {reply, {?false, Reason}};
        _Else ->
            {reply, {?false, ?L(<<"取消失败">>)}}
    end;


handle(_Cmd, _Arg, _Role = #role{name = _Name}) ->
    ?ERR("角色[~s]发起无效的协议 ~w [~w]", [_Name, _Arg]).

%% 推送相关
push(17900, Pid, #role{soul_world = #soul_world{orange_luck = OrangeLuck, purple_luck = PurpleLuck, spirits = Spirits, calleds = Calleds, today_called = TodayCalled, last_called = LastCalled}}) ->
    FreeTime = case util:is_same_day2(util:unixtime(), LastCalled) of
        true -> max(0, ?soul_world_free_call_time - TodayCalled);
        _ -> ?soul_world_free_call_time
    end,
    role:pack_send(Pid, 17900, {round(OrangeLuck * 100 / ?soul_world_gold_call_max_luck), round(PurpleLuck * 100 / ?soul_world_coin_call_max_luck), FreeTime, Spirits, Calleds});
push(17904, Pid, #soul_world_spirit{id = Id, name = Name, lev = Lev, quality = Quality, fc = Fc, exp = Exp, max_exp = MaxExp, array_id = ArrayId, generation = Generation, magics = Magics}) ->
    Data = {Id, Name, Lev, Quality, Fc, Exp, MaxExp, Generation, ArrayId, Magics},
    role:pack_send(Pid, 17904, Data);
push(17905, Pid, Role = #role{soul_world = #soul_world{arrays = Arrays}}) ->
    Now = util:unixtime(),
    F = fun(A = #soul_world_array{upgrade_finish = 0}) ->
            A;
        (A = #soul_world_array{upgrade_finish = Timeout}) ->
            A#soul_world_array{upgrade_finish = max(0, Timeout - Now)}
    end,
    AllFc = soul_world:calc_fight_capacity(Role),
    role:pack_send(Pid, 17905, {[F(One) || One <- Arrays], AllFc});
push(17917, Pid, Role = #role{soul_world = #soul_world{pet_arrays = Arrays}}) ->
    Now = util:unixtime(),
    F = fun(A = #soul_world_array{upgrade_finish = 0}) ->
            A;
        (A = #soul_world_array{upgrade_finish = Timeout}) ->
            A#soul_world_array{upgrade_finish = max(0, Timeout - Now)}
    end,
    AllFc = soul_world:calc_pet_fc(Role),
    role:pack_send(Pid, 17917, {[F(One) || One <- Arrays], AllFc});
push(17920, Pid, #role{soul_world = #soul_world{workshop = WorkShop}}) ->
    role:pack_send(Pid, 17920, {WorkShop});
push(17925, Pid, #role{soul_world = #soul_world{workshop_producing = Producing, product_line = ProductLine}}) ->
    Now = util:unixtime(),
    Data = {[P#soul_world_workshop{produce_time = max(0, ProduceTime - Now)} || P = #soul_world_workshop{produce_time = ProduceTime} <- Producing], ProductLine},
    role:pack_send(Pid, 17925, Data);
push(17926, Pid, SpId) ->
    role:pack_send(Pid, 17926, {SpId}).
