%%
-module(manor_rpc).

-export(
    [
        handle/3
        ,pack_send_19521/1
    ]
).

-include("common.hrl").
-include("manor.hrl").
-include("link.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("gain.hrl").
-include("item.hrl").

-define(npc_func_baoshi, 1). %% 宝石打造NPC

%% 获取当前NPC列表
handle(19500, {}, #role{manor_baoshi = #manor_baoshi{hole_col = #hole_col{last_time=LastTime,cd_time=Cd, holes=Holes}}}) ->
    Now = util:unixtime(),
    Cd1 = case Now - LastTime > Cd of
        true -> 0;
        false -> Cd - (Now-LastTime)
    end,
    HoleData = [{Pos, ItemId, HasCd} || #hole{pos=Pos, item_id=ItemId, have_cd=HasCd} <- Holes],
    ?DEBUG("------>> ~p~n", [HoleData]),
    {reply, {Cd1, HoleData}};

%% 打造宝石
handle(19502, {NpcId}, Role = #role{link = #link{conn_pid = ConnPid}, manor_baoshi=#manor_baoshi{baoshi_npc=MyNpc, hole_col=#hole_col{holes=OldHoles}}}) ->
    case manor:is_my_npc(NpcId, MyNpc) of
        false ->
            {reply, {?false, ?MSGID(<<"你没有此NPC">>)}};
        true ->
            case manor:have_free_hole(OldHoles) of
                false -> {reply, {?false, ?MSGID(<<"没有可用的打造孔">>)}};
                Hole = #hole{pos=Pos} ->
                    {_NpcFunc, ItemType, Cost} = manor_baoshi_data:get(NpcId), %%  消耗符石
                    Ret = manor:get_baoshi(ItemType),
                    case Ret of
                        false -> {reply, {?false, ?MSGID(<<"获取宝石发生未知错误">>)}};
                        BaoshiId ->
                                case role_gain:do([#loss{label = stone, val=Cost}], Role) of
                                    {ok, Role0} ->
                                        log:log(log_stone, {<<"庄园打造宝石">>, <<"">>, Role, Role0}),
                                        Role1 = #role{manor_baoshi=ManorBaoshi=#manor_baoshi{hole_col=HoleCol=#hole_col{cd_time = Cd, holes = Holes}}} = manor:set_baoshi_cd_timer(Role0),
                                        NewHoles = lists:keyreplace(Pos, #hole.pos, Holes, Hole#hole{item_id = BaoshiId, have_cd = ?true}),
                                        %% {ok, #item_base{name = Name}} = item_data:get(BaoshiId),
                                        %% Msg = util:fbin(?L(<<"~s成功打造">>), [Name]),
                                        %% notice:alert(succ, ConnPid, Msg),
                                        Role2 = manor:set_npc_old(NpcId, Role1),
                                        Role3 = Role2#role{manor_baoshi = ManorBaoshi#manor_baoshi{hole_col = HoleCol#hole_col{holes = NewHoles}}},
                                        pack_send_19521(Role3),
                                        sys_conn:pack_send(ConnPid, 19502, {?true, ?MSGID(<<"打造成功">>)}),
                                        sys_conn:pack_send(ConnPid, 19501, {1, Cd, Pos, BaoshiId, 1}),
                                        Role4 = role_listener:special_event(Role3, {2014, finish}),
                                        Role5 = role_listener:special_event(Role4, {3011, 1}),
                                        random_award:gemstone(Role5),
                                        {ok, Role5};
                                    {false, _} ->
                                        {reply, {?false, ?MSGID(<<"符石不足，挑战困难副本可以获得符石">>)}}
                                end
                    end
            end
    end;

%% 消除CD
handle(19503, {}, Role = #role{manor_baoshi=ManorBaoshi=#manor_baoshi{hole_col=HoleCol=#hole_col{cd_time = Cd, last_time=LastTime,holes=Holes}}}) ->
    Now = util:unixtime(),
    RemainSec = Cd - (Now - LastTime),
    case RemainSec > 0 of
        false ->
            {reply, {?false, ?MSGID(<<"不需消除冷却时间">>)}};
        true ->
            Yb = manor:sec2yb(RemainSec),
            %%去掉计时器
            case role_gain:do([#loss{label=gold, val=Yb}], Role) of
                {ok, Role1} ->
                    Role3 = 
                    case role_timer:del_timer(manor_baosi_timer, Role1) of
                        false ->
                            ?DEBUG("------------->>> 没发现定时器，可能计时误差"), Role1;
                        {ok, _, Role2} ->
                            Role2
                    end,
                    %% 去掉孔上CD标志
                    Holes1 = lists:keymap(fun(_X)-> 0 end, #hole.have_cd, Holes),
                    Role4 = Role3#role{manor_baoshi = ManorBaoshi#manor_baoshi{hole_col=HoleCol#hole_col{holes = Holes1, cd_time = 0}}},
                    pack_send_19521(Role4),
                    notice:alert(succ, Role, ?MSGID(<<"成功消除冷却时间">>)),
                    {reply, {?true, ?MSGID(<<"成功消除冷却时间">>)}, Role4};
                {false, _} ->
                    {reply, {?false, ?MSGID(<<"晶钻不足">>)}}
            end
        end;

%% 领取宝石
handle(19504, {}, Role = #role{id = Rid, manor_baoshi=ManorBaoshi=#manor_baoshi{hole_col=HoleCol=#hole_col{holes=Holes}}}) ->
    BaoshiIdList = [Id || #hole{item_id = Id} <- Holes, Id =/= 0],
    case length(BaoshiIdList) of
        0->
            {reply, {?false, ?MSGID(<<"没有宝石领取">>)}};
        _Num ->
            case manor:make_baoshi(BaoshiIdList, []) of
                {false, _Reason} ->
                    ?DEBUG("生成宝石失败"),
                    {reply, {?false, ?MSGID(<<"生成宝石失败">>)}};
                Items ->
                    ?DEBUG("---------->> 生成宝石为: ~p~n", [Items]),
                    NewHoles = lists:keymap(fun(_X)->0 end, #hole.item_id, Holes),
                    case storage:add(bag, Role, Items) of
                        false -> %% 背包满加到奖励大厅
                            Gains = [#gain{label = item, val = [BaseId, 1, 1]} || BaseId <- BaoshiIdList],
                            award:send(Rid, 202001, Gains),
                            {reply, {?true, 0}, Role#role{manor_baoshi=ManorBaoshi#manor_baoshi{hole_col=HoleCol#hole_col{holes=NewHoles}}}};
                        {ok, NewBag} ->
                            {reply, {?true, ?MSGID(<<"宝石领取成功">>)}, Role#role{bag=NewBag, manor_baoshi=ManorBaoshi#manor_baoshi{hole_col=HoleCol#hole_col{holes=NewHoles}}}}
                    end
            end
    end;

%% 魔药NPC信息
handle(19505, {}, #role{manor_moyao = #manor_moyao{hole_col = #hole_col{last_time=LastTime,cd_time=Cd, holes=Holes}, material=Material}}) ->
    Now = util:unixtime(),
    Cd1 = case Now - LastTime > Cd of
        true -> 0;
        false -> Cd - (Now-LastTime)
    end,
    HoleData = [{Pos, ItemId, HasCd} || #hole{pos=Pos, item_id=ItemId, have_cd=HasCd} <- Holes],
    MaterialData = [{manor_moyao_data:get_npcid(Id), Id, Num} || #material{id=Id, num=Num} <- Material],
    ?DEBUG("---------->> 材料信息 ~p~n", [Material]),
    {reply, {Cd1, HoleData, MaterialData}};

%% 打造材料
handle(19506, {NpcId, ItemId}, Role = #role{link=#link{conn_pid=ConnPid}, manor_moyao = #manor_moyao{material_npc=MyNpc,hole_col=#hole_col{holes=OldHoles}}}) ->
    case manor:is_my_npc(NpcId, MyNpc) of
        false ->
            {reply, {?false, ?MSGID(<<"你没有此NPC">>)}};
        true ->
            case manor:have_free_hole(OldHoles) of
                false -> {reply, {?false, ?MSGID(<<"没有可用的炼制空间">>)}};
                Hole = #hole{pos=Pos} ->
                    {_NpcFunc, Items, Cost} = manor_moyao_data:get_npc_conf(NpcId),
                    case lists:member(ItemId, Items) of
                        false ->
                            {reply, {?false, ?MSGID(<<"NPC不能打造此物品">>)}};
                        true ->
                            case role_gain:do([#loss{label=coin, val=Cost}], Role) of
                                {ok, Role0} ->
                                    log:log(log_coin, {<<"庄园打造材料">>, <<"">>, Role, Role0}),
                                    Role1 = manor:set_npc_old(NpcId, Role0),
                                    Role2 = #role{manor_moyao = ManorMoyao = #manor_moyao{hole_col = HoleCol = #hole_col{cd_time = Cd, holes=Holes}}} = manor:set_moyao_cd_timer(Role1),
                                    Holes1 = lists:keyreplace(Pos, #hole.pos, Holes, Hole#hole{item_id = ItemId, have_cd=?true}),
                                    Role3 = Role2#role{manor_moyao=ManorMoyao#manor_moyao{hole_col = HoleCol#hole_col{holes = Holes1}}},
                                    pack_send_19521(Role3),
                                    sys_conn:pack_send(ConnPid, 19506, {?true, ?MSGID(<<"打造成功">>)}),
                                    sys_conn:pack_send(ConnPid, 19511, {Cd, Pos, ItemId, ?true}),
                                    Role4 = role_listener:special_event(Role3, {2015, finish}),

                                    {ok, Role4};
                                {false, _} ->
                                    {reply, {?false, ?MSGID(<<"金币不足">>)}}
                            end
                    end
            end
    end;


%% 消除打造材料Cd
handle(19507, {}, Role = #role{manor_moyao=ManorMoyao=#manor_moyao{hole_col=HoleCol=#hole_col{cd_time = Cd, last_time=LastTime,holes=Holes}}}) ->
    Now = util:unixtime(),
    RemainSec = Cd - (Now - LastTime),
    case RemainSec > 0 of
        false ->
            {reply, {?false, ?MSGID(<<"不需消除冷却时间">>)}};
        true ->
            Yb = manor:sec2yb(RemainSec),
            case role_gain:do([#loss{label = gold, val = Yb}], Role) of
                {ok, Role1} ->
                    %%去掉计时器
                    Role3 =
                    case role_timer:del_timer(manor_moyao_timer, Role1) of
                        false ->
                            ?DEBUG("------------->>> 没发现定时器，可能计时误差"), Role1;
                        {ok, _, Role2} -> Role2
                    end,
                    %% 去掉孔上CD标志
                    Holes1 = lists:keymap(fun(_X)->0 end, #hole.have_cd, Holes),
                    Role4 = Role3#role{manor_moyao=ManorMoyao#manor_moyao{hole_col=HoleCol#hole_col{holes = Holes1, cd_time=0}}},
                    pack_send_19521(Role4),
                    notice:alert(succ, Role, ?MSGID(<<"成功消除冷却时间">>)),
                    {reply, {?true, ?MSGID(<<"成功消除冷却时间">>)}, Role4};
                {false, _} ->
                    {reply, {?false, ?MSGID(<<"晶钻不足">>)}}
            end
    end;


%% 领取打造出来的材料
handle(19508, {}, Role = #role{link=#link{conn_pid=ConnPid}, manor_moyao=#manor_moyao{hole_col=HoleCol=#hole_col{holes=Holes}}}) ->
    ItemIdList = [ItemId || #hole{item_id=ItemId} <- Holes, ItemId =/= 0],
    case length(ItemIdList) > 0 of
        false ->
            {reply, {?false, ?MSGID(<<"没有材料可领取">>)}};
        true ->
            NewRole=#role{manor_moyao=ManorMoyao1} = manor:get_material(ItemIdList, Role),
            sys_conn:pack_send(ConnPid, 19508, {?true, ?MSGID(<<"材料领取成功">>)}),
            pack_send_19512(NewRole),
            NewHoles = lists:keymap(fun(_X)->0 end, #hole.item_id, Holes),
            {ok, NewRole#role{manor_moyao=ManorMoyao1#manor_moyao{hole_col=HoleCol#hole_col{holes=NewHoles}}}}
    end;

%% 打造药水
handle(19509, {NpcId, Recipe}, Role = #role{link=#link{conn_pid=ConnPid}, manor_moyao=#manor_moyao{material_npc=MyNpc}}) ->
    case check_npc(NpcId, MyNpc) of
        false -> {reply, {?false,?MSGID(<<"你没有此NPC">>)}};
        {ok, {_CostType, _CanGenList, _CostVal}} ->
                case check_npc_plan(NpcId, Recipe) of
                    false -> 
                        %% ?DEBUG("此NPC没有此配方 NPC:~p, 配方:~p~n", [NpcId, Recipe]),
                        {reply, {?false, ?MSGID(<<"此NPC没有此配方">>)}};
                    {ok, MaterialList} ->
                        case manor:cost_material(MaterialList, Role) of
                            {false, _Reason} -> 
                                %% ?DEBUG("扣除材料失败~p~n", [_Reason]),
                                {reply, {?false, ?MSGID(<<"你没有足够的材料">>)}};
                            {ok, NewRole} ->
                                    case manor:gen_moyao(Recipe) of
                                        false -> ?DEBUG("------>>should never reach here"), {ok};
                                        ItemId ->
                                            case add_moyao(NewRole, ItemId) of
                                                {false, Reason} ->
                                                    ?DEBUG("生成物品失败"),
                                                    sys_conn:pack_send(ConnPid, 19509, {?false, Reason}),
                                                    {ok};
                                                {ok, NewRole1} ->
                                                    {ok, #item_base{name = Name}} = item_data:get(ItemId),
                                                    Msg = util:fbin(?L(<<"~s成功打造">>), [Name]),
                                                    notice:alert(succ, ConnPid, Msg), 
                                                    pack_send_19512(NewRole1),
                                                    sys_conn:pack_send(ConnPid, 19509, {?true, ?MSGID(<<"魔药制作成功">>)}),
                                                    random_award:drug_make(NewRole1),
                                                    NewRole2 = role_listener:special_event(NewRole1, {3014,1}),   %% 触发日常
                                                    {ok, NewRole2}
                                            end
                                    end
                        end
                end
    end;

%% 喝药
handle(19510, {YaoBaseId}, Role) ->
    case role_gain:do([#loss{label=itemsall, val=[{YaoBaseId, 1}]}], Role) of
        {false, _} -> {reply, {?false, ?MSGID(<<"您没有此魔药">>),0}};
        {ok, NewRole} ->
            NewRole1 = manor:add_moyao_num(NewRole, YaoBaseId, 1),
            pack_send_19513(NewRole1),
            NewRole2 = medal:listener(drug, NewRole1),
            random_award:drug(NewRole2, YaoBaseId rem 10),
            {reply, {?true, ?MSGID(<<"喝药成功">>), YaoBaseId}, role_api:push_attr(NewRole2)}
    end;

%% 请求已喝魔药信息
handle(19513, {}, Role) ->
    pack_send_19513(Role),
    {ok, Role};

%% 跑商信息
handle(19514, {}, Role = #role{manor_trade=ManorTrade =#manor_trade{has_cd=HasCd, trade_time=TradeTime, has_gain=HasGain, trade_npc=TradeNpc}}) ->
    case TradeNpc =:= 0 of
        true -> {reply, {0,0,0}};
        false ->
            {_Cost, TotalTime, PerProfit}=manor_trade_data:get_npc_conf(TradeNpc),
            MaxGain = TotalTime div 10,
            %% ?DEBUG("-------------------> HasGain: ~p~n", [HasGain]),
            Now = util:unixtime(),
            case Now - TradeTime >= TotalTime orelse HasCd =:= 0 of
                true -> %% CD 时间已过
                    {reply, {0, (MaxGain-HasGain)*PerProfit, 0}, Role#role{manor_trade = ManorTrade#manor_trade{has_cd=0}}};
                false -> %% CD 时间未过
                    {reply, {TotalTime-(Now-TradeTime), ((Now-(TradeTime+HasGain*10)) div 10)*PerProfit , TradeNpc}}
            end
    end;

%% 跑商
handle(19515, {NpcId}, Role = #role{manor_trade=#manor_trade{has_npc=Npc,trade_time=TradeTime, has_cd=HasCd, has_gain=HasGain, trade_npc=TradeNpc}}) ->
    case manor:is_my_npc(NpcId, Npc) of
        false -> ?DEBUG("没有此NPC"), {reply, {?false, ?MSGID(<<"您没有此NPC">>)}};
        true ->
            Now = util:unixtime(),
            case TradeNpc =:= 0 of %% 当前是否有另一场跑商
                false ->
                    {_Cost, TotalTime, PerProfit} = manor_trade_data:get_npc_conf(TradeNpc),
                    case (Now-TradeTime >= TotalTime) orelse (HasCd =:= 0) of %% 检查是否能完成
                        false -> 
                            {reply, {?false, ?MSGID(<<"您正在行商中，不能开始新的行商">>)}};
                        true -> %% CD已过或者玩家花钱消了CD，直接帮它收钱，然后开始新的跑商
                            case start_new_trade(Role, NpcId) of
                                {ok, Role1} ->
                                    Coin =  ((TotalTime div 10) - HasGain) * PerProfit,
                                    Msg = util:fbin(?L(<<"获得~w金币">>), [Coin]),
                                    notice:alert(succ, Role1, Msg),
                                    {ok, Role2} = role_gain:do([#gain{label=coin, val= Coin}], Role1),
                                    log:log(log_coin, {<<"庄园跑商">>, <<"金币">>, Role, Role2}),
                                    {ok, Role2};
                                Ret ->
                                    Ret
                            end
                    end;
                true ->
                    start_new_trade(Role, NpcId)
            end
    end;

%% 加速
handle(19516, {}, #role{manor_trade=#manor_trade{trade_npc=0}}) ->
    {reply, {?false, ?MSGID(<<"您还没有开始跑商">>)}};
handle(19516, {}, Role = #role{link=#link{conn_pid=ConnPid},manor_trade=ManorTrade =#manor_trade{has_gain=HasGain, trade_time=TradeTime, has_cd=HasCd, trade_npc=TradeNpc}}) ->
    Now = util:unixtime(),
    {_Cost, TotalTime, PerProfit} = manor_trade_data:get_npc_conf(TradeNpc),
    case Now-TradeTime >= TotalTime orelse HasCd=:=0 of
        true -> {reply, {?false, ?MSGID(<<"当前不能加速">>)}};
        false ->
            RemainSec=TotalTime-(Now-TradeTime),
            Yb = manor:sec2yb(RemainSec),
            case role_gain:do([#loss{label=gold, val=Yb}], Role) of
                {ok, NewRole} ->
                    Role1 = NewRole#role{manor_trade=ManorTrade#manor_trade{has_cd=0}},
                    Role2 = manor:stop_trade_timer(Role1),
                    pack_send_19521(Role2),
                    notice:alert(succ, Role2, ?MSGID(<<"成功消除冷却时间">>)),
                    %%sys_conn:pack_send(ConnPid, 19516, {?true, ?MSGID(<<"成功消除冷却时间">>)}),
                    sys_conn:pack_send(ConnPid, 19514, {0, (TotalTime div 10-HasGain)*PerProfit, 0}),
                    {ok, Role2};
                {false,_} ->
                    {reply, {?false, ?MSGID(<<"晶钻不足">>)}}
            end
    end;

%% 领金币
handle(19517, {}, #role{ manor_trade = #manor_trade{trade_npc = 0}}) ->
    {reply, {?false, ?MSGID(<<"您还没有跑商">>)}};
handle(19517, {}, Role = #role{link=#link{conn_pid=ConnPid}, manor_trade=ManorTrade =#manor_trade{trade_time=TradeTime, has_cd=HasCd, has_gain=HasGain, trade_npc=TradeNpc}}) ->
    Now = util:unixtime(),
    {_Cost, TotalTime, PerProfit} = manor_trade_data:get_npc_conf(TradeNpc),
    case TradeNpc =:= 0 of
        false -> %%没有
            case (Now-TradeTime >= TotalTime) orelse (HasCd =:= 0) of %% check cd is OK
                true -> %% 全领
                    %% ?DEBUG("全领金币: ~p~n", [ ((TotalTime div 10)-HasGain)*PerProfit ]),
                    {ok, NewRole} = role_gain:do([#gain{label=coin, val=((TotalTime div 10)-HasGain)*PerProfit}], Role),
                    log:log(log_coin, {<<"庄园跑商">>, <<"金币">>, Role, NewRole}),
                    NewRole1 = NewRole#role{manor_trade=ManorTrade#manor_trade{trade_npc=0, has_cd=0}},
                    pack_send_19521(NewRole1),
                    sys_conn:pack_send(ConnPid, 19517, {?true, ?MSGID(<<"领取成功">>)}),
                    sys_conn:pack_send(ConnPid, 19514, {0, 0, 0}),
                    {ok, NewRole1};
                false ->
                    Time = Now-(TradeTime+(HasGain*10)),
                    NewRole1 = 
                                if
                                    Time >= 10 -> %% 至少可以领一份
                                        CanGain = Time div 10,
                                        {ok, NewRole} = role_gain:do([#gain{label=coin, val=CanGain*PerProfit}], Role),
                                        sys_conn:pack_send(ConnPid, 19517, {?true, ?MSGID(<<"领取成功">>)}),
                                        sys_conn:pack_send(ConnPid, 19514, {TotalTime - (Now-TradeTime), 0, TradeNpc}),
                                        NewRole#role{manor_trade=ManorTrade#manor_trade{has_gain=HasGain+CanGain}};
                                    Time < 10 ->
                                        sys_conn:pack_send(ConnPid, 19517, {?false, ?MSGID(<<"没有可领的金币">>)}),
                                        Role;
                                    true -> 
                                        Role
                                end,
                    {ok, NewRole1}
            end;
        true ->
            {reply, {?false, ?MSGID(<<"您还没有跑商">>)}}
    end;

%% 请求训龙信息
handle(19518, {}, #role{manor_train=#manor_train{train_npc=TrainNpc, train_time=TrainTime}}) ->
    case TrainNpc =:= 0 of
        true -> {reply, {0,0}};
        false ->
            {_Cost, Time, _Exp} = manor_train_data:get_npc_conf(TrainNpc),
            {reply, {TrainNpc, Time*60 - (util:unixtime()-TrainTime)}}
    end;

%% 请求训龙
handle(19519, {NpcId}, Role=#role{link = #link{conn_pid = ConnPid}, manor_train=ManorTrain=#manor_train{has_npc=MyNpc, train_npc=TrainNpc}}) ->
    case TrainNpc =/= 0 of
        true -> {reply, {?false, ?MSGID(<<"不能重复训龙">>)}};
        false ->
            case manor:is_my_npc(NpcId, MyNpc) of
                true ->
                    {Cost, Time, _Exp} = manor_train_data:get_npc_conf(NpcId),
                    case role_gain:do([#loss{label = coin, val = Cost}], Role) of
                        {ok, Role0} ->
                            log:log(log_coin, {<<"庄园训龙">>, <<"">>, Role, Role0}),
                            Role1 = manor:set_npc_old(NpcId, Role0),
                            Role2 = manor:set_train_pet_timer(60, Role1),
                            Role3 = Role2#role{manor_train = ManorTrain#manor_train{has_gain = 0, train_npc = NpcId, train_time=util:unixtime()}},
                            Role4 = manor:del_train_pet_timer(Role3),
                            Role5 = role_listener:special_event(Role4, {2010, finish}), %% 训龙活跃度触发
                            pack_send_19521(Role5),
                            sys_conn:pack_send(ConnPid, 19519, {?true, ?MSGID(<<"训龙成功">>)}),
                            sys_conn:pack_send(ConnPid, 19518, {NpcId, Time*60}),
                            random_award:dragon_train(Role5),
                            Role6 = role_listener:special_event(Role5, {3008, 1}), %% 日常触发
                            {ok, Role6};
                        {false, _Reason} ->
                            {reply, {?false, ?MSGID(<<"金币不足">>)}}
                    end;
                false ->
                    {reply, {?false, ?MSGID(<<"您没有此NPC">>)}}
            end
    end;

%% 消除训龙CD
handle(19520, {}, Role = #role{link = #link{conn_pid = ConnPid}, manor_train=ManorTrain=#manor_train{has_gain=HasGain, train_npc=TrainNpc, train_time=TrainTime}}) ->
    case TrainNpc =:= 0 of
        true -> {reply, {?false, ?MSGID(<<"您还没有开始训龙">>)}};
        false ->
            {_, SumMin, P} = manor_train_data:get_npc_conf(TrainNpc),
            Now = util:unixtime(),
            RemainSec = SumMin*60 - (Now - TrainTime),
            case RemainSec > 0 of
                true ->
                    NeedYb = manor:sec2yb(RemainSec),
                    case role_gain:do([#loss{label=gold, val=NeedYb}], Role) of
                        {ok, Role1} ->
                            Role2 = manor:del_train_pet_timer(Role1),
                            Exp =  (SumMin-HasGain) * P,
                            ?DEBUG("消除CD后  SumMin: ~w, HasGain: ~w, Exp: ~w", [SumMin, HasGain, Exp]),
                            Role3 = pet_api:asc_pet_exp(Role2, Exp),
                            Role4 = Role3#role{manor_train = ManorTrain#manor_train{has_gain = 0, train_npc=0, train_time=0}},
                            pack_send_19521(Role4),
                            notice:alert(succ, Role, ?MSGID(<<"成功消除冷却时间">>)),
                            %% sys_conn:pack_send(ConnPid, 19520, {?true, ?MSGID(<<"成功消除冷却时间">>)}),
                            sys_conn:pack_send(ConnPid, 19518, {0, 0}),
                            {ok, Role4};
                        {false,_Reason} ->
                            {reply, {?false,?MSGID(<<"晶钻不足">>)}}
                    end;
                false ->
                    {reply, {?false, ?MSGID(<<"您还没有开始训龙">>)}}
            end
    end;

handle(19521, {}, Role = #role{}) ->
    {A, I} = manor:status(Role),
    {reply, {A, I}};

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%% ----------------------------------------------------------------------

start_new_trade(Role, NpcId) ->
    case do_start_new_trade(Role, NpcId) of
        Ret = {ok, _NewRole} ->
            random_award:trade(_NewRole),
            Ret;
        Ret = {?false, _Reason} ->
            {reply, Ret}
    end.

do_start_new_trade(Role = #role{link = #link{conn_pid = ConnPid}, manor_trade = ManorTrade = #manor_trade{has_npc = _HasNpc}}, TradeNpc) ->
    {Cost, TotalTime, _PerProfit}=manor_trade_data:get_npc_conf(TradeNpc),
    case role_gain:do([#loss{label = stone, val=Cost}], Role) of
        {ok, Role0} ->
            log:log(log_stone, {<<"庄园跑商">>, <<"">>, Role, Role0}),
            Role1 = manor:set_npc_old(TradeNpc, Role0),
            Now = util:unixtime(),
            Role2 = Role1#role{manor_trade = ManorTrade#manor_trade{trade_time = Now, has_cd = 1, has_gain = 0, trade_npc = TradeNpc}},
            pack_send_19521(Role2),
            Role3 = manor:set_trade_timer(TotalTime, Role2),
            sys_conn:pack_send(ConnPid, 19515, {?true, ?MSGID(<<"跑商成功">>)}),
            sys_conn:pack_send(ConnPid, 19514, {TotalTime, 0, TradeNpc}),
            Role4 = role_listener:special_event(Role3, {2013, finish}),
            {ok, Role4};
        {false, _} ->
            {?false, ?MSGID(<<"符石不足，挑战困难副本可以获得符石">>)}
    end.

%notify_new_trade(Role = #role{link = #link{conn_pid = ConnPid}}, TradeNpc) ->
%    {_Cost, TotalTime, _PerProfit}=manor_trade_data:get_npc_conf(TradeNpc),
%    pack_send_19521(Role),
%    sys_conn:pack_send(ConnPid, 19515, {?true, ?MSGID(<<"跑商成功">>)}),
%    sys_conn:pack_send(ConnPid, 19514, {TotalTime, 0, TradeNpc}).

%% 更新原材料信息
pack_send_19512(#role{link=#link{conn_pid=ConnPid}, manor_moyao=#manor_moyao{material=Material}}) ->
    MaterialData = [{manor_moyao_data:get_npcid(Id), Id, Num} ||#material{id=Id, num=Num} <- Material],
    ?DEBUG("---------->> 当前材料列表:~p~n", [MaterialData]),
    sys_conn:pack_send(ConnPid, 19512, {MaterialData}).

%% 检查玩家是否有此NPC
check_npc(NpcId, MyNpc) -> 
   case manor:is_my_npc(NpcId, MyNpc) of
        false -> ?DEBUG("你没有此NPC"), false;
        true ->
            case manor_moyao_data:get_npc_conf(NpcId) of
                false -> ?DEBUG("找不到此NPC配置 ~p~n", [NpcId]), false;
                Conf = {_CostType, _CanGenList, _CostVal} -> {ok, Conf}
            end
    end.

%% 检查NPC是否符合配方,符合返回材料列表
check_npc_plan(NpcId, Recipe) ->
    PlanList = manor_moyao_data:get_npc_plan(NpcId),
    case lists:member(Recipe, PlanList) of
        false -> ?DEBUG("此NPC没有此配方 NPC:~p, 配方:~p~n", [NpcId, Recipe]), false;
        true -> {_Num, MaterialList} = manor_moyao_data:get_cost(Recipe), {ok, MaterialList}
    end.

%% 将生成的魔药ID，生成ITEM，加到玩家背包或奖励大厅中
add_moyao(Role = #role{id = Rid}, MoyaoId) ->
    case item:make(MoyaoId, 0, 1) of
        false-> ?DEBUG("生成物品失败"), {false, ?MSGID(<<"生成魔药失败">>)};
        {ok, ItemList} ->
                case storage:add(bag, Role, ItemList) of
                    false-> 
                        ?DEBUG("玩家背包满..."),
                        award:send(Rid, 202000, [#gain{label = item, val = [MoyaoId, 0, 1]}]),
                        notice:alert(succ, Role, ?MSGID(<<"你的背包已满，魔药已发送到奖励大厅">>)),
                        {ok, Role};
                        %% {false, ?MSGID(<<"你的背包已满，魔药已发送到奖励大厅">>)};
                    {ok, NewBag}-> {ok, Role#role{bag=NewBag}}
                end
    end.

 %% 喝药信息
pack_send_19513(#role{link=#link{conn_pid=ConnPid}, manor_moyao=#manor_moyao{has_eat_yao=HasEat}}) ->
    HasEatData = [{manor_moyao_data:yaoid_npcid(Id), Id, Num} || #has_eat_yao{id=Id, num=Num} <- HasEat],
    ?DEBUG("------->> pack_send_19513 ~p~n", [HasEatData]),
    sys_conn:pack_send(ConnPid, 19513, {HasEatData}).

%% 打包庄园信息
pack_send_19521(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    ?DEBUG("------->> pack_send_19521 ~n"),
    {NewNpc, Info} = manor:status(Role),
    sys_conn:pack_send(ConnPid, 19521, {NewNpc, Info}).

