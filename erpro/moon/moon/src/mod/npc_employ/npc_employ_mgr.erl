%%----------------------------------------------------
%% @doc 雇佣npc 管理模块
%%
%% <pre>
%% 雇佣npc管理模块
%% </pre>
%% @author yankai
%% @doc
%%----------------------------------------------------
-module(npc_employ_mgr).

-behaviour(gen_server).

-export([
        start_link/0,
        login/1,
        gift_npc/3,
        employ_npc/4,
        fire_npc/2,
        is_employee/2,
        get_employee/1,
        get_combat_employee/1,
        get_npc_impression_info/4,
        get_all_npc_impression_info/3,
        get_employ_left_time/1,
        set_npc_impression/3,
        register_employ_expire_event/3
    ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("item.hrl").
-include("buff.hrl").
-include("npc.hrl").
-include("attr.hrl").
-include("combat.hrl").
-include("offline_exp.hrl").
-include("pos.hrl").

-define(MAX_IMPRESSION, 50000000).
-define(MAX_EMPLOY_TIME, 12*3600).

%%---------------------------------------------------------
%% 外部接口
%%---------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% 登陆时初始化雇佣npc的外观
login(Role = #role{id = Rid, combat = CombatParams, offline_exp = OfflineExp, special = Special}) ->
    case lists:keyfind(employ_npc, 1, CombatParams) of
        {employ_npc, {NpcBaseId, Impression, EmployTime, EmployExpireTime}} ->
            EmployExpireTime1 = case OfflineExp of
                #offline_exp{last_logout_time = LastLogoutTime} when LastLogoutTime>0 ->
                    LogoutDuration = util:unixtime() - LastLogoutTime,
                    EmployExpireTime + LogoutDuration;
                _ -> EmployExpireTime
            end,
            case EmployExpireTime1 > 0 of
                true ->
                    register_employ_expire_event(Rid, NpcBaseId, EmployExpireTime1),
                    NewCombatParams = [{employ_npc, {NpcBaseId, Impression, EmployTime, EmployExpireTime1}}|lists:keydelete(employ_npc, 1, CombatParams)],
                    NewSpecial = [{?special_npc_employ, NpcBaseId, <<>>} | Special],
                    Role1 = Role#role{special = NewSpecial, combat = NewCombatParams},
                    {ok, Role2} = add_buff(Role1, Impression),
                    Role2;
                false ->
                    NewCombatParams = lists:keydelete(employ_npc, 1, CombatParams),
                    Role#role{combat = NewCombatParams}
            end;
        _ -> Role
    end.

%% 赠送金币或者物品给npc
gift_npc(RolePid, NpcBaseId, Gifts) ->
    %% ?DEBUG("gift_npc():NpcBaseId=~w, Gifts=~w", [NpcBaseId, Gifts]),
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {gift_npc, RolePid, NpcBaseId, Gifts};
        _ ->
            ok
    end.

%% 雇佣npc
employ_npc(Rid, RolePid, NpcBaseId, EmployHours) ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {employ_npc, Rid, RolePid, NpcBaseId, EmployHours};
        _ -> ok
    end.

%% 解雇npc
fire_npc(Rid, RolePid) ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {fire_npc, Rid, RolePid};
        _ -> ok
    end.

%% 获取已经雇佣的npc -> NpcBaseId | undefined
get_employee(#role{id = Rid, combat = CombatParams}) ->
    case lists:keyfind(employ_npc, 1, CombatParams) of
        {employ_npc, {NpcBaseId, _Impression, _EmployTime, EmployExpireTime}} ->
            %% 预防本进程崩溃导致计时器事件丢失，所以每次这里注册一下
            register_employ_expire_event(Rid, NpcBaseId, EmployExpireTime),
            NpcBaseId;
        _ -> undefined
    end.

%% 判断某npc是否被雇佣 -> true | false
is_employee(Role, NpcBaseId) ->
    EmployNpcBaseId = get_employee(Role),
    EmployNpcBaseId =:= NpcBaseId.

%% 获取可以参战的雇佣npc -> #converted_fighter{} | undefined
get_combat_employee(Role = #role{combat = CombatParams, pos = #pos{map = MapId}}) ->
    case lists:keyfind(employ_npc, 1, CombatParams) of
        {employ_npc, {NpcBaseId, Impression, _, _}} ->
            case npc_data:get(NpcBaseId) of
                {ok, NpcBase} ->
                    %% 重新计算属性
                    NpcBase1 = calc_combat_npc_attr(NpcBase, Role, Impression),
                    Npc = npc_convert:base_to_npc(0, NpcBase1, #pos{map = MapId}),
                    {ok, CF = #converted_fighter{fighter = F}} = npc_convert:do(to_fighter, Npc, Role, ?ms_rela_employ),
                    CF#converted_fighter{fighter = F#fighter{impression = Impression}};
                _ -> undefined
            end;
        _ -> undefined
    end;
get_combat_employee(_) -> undefined.

%% 获取某npc好感度信息
get_npc_impression_info(Rid, RolePid, NpcBaseId, Args) ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {get_npc_impression_info, Rid, RolePid, NpcBaseId, Args};
        _ -> ok
    end.

%% 获取全部npc好感度信息
get_all_npc_impression_info(Rid, RolePid, Args) ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {get_all_npc_impression_info, Rid, RolePid, Args};
        _ -> ok
    end.

%% 获取npc雇佣剩余时间（必须确保是登陆后调用了login调整了剩余时间再调用） -> integer()
get_employ_left_time(#role{combat = CombatParams}) ->
    case lists:keyfind(employ_npc, 1, CombatParams) of
        {employ_npc, {_NpcBaseId, _Impression, _EmployTime, EmployExpireTime}} ->
            util:check_range(EmployExpireTime-util:unixtime(), 0, ?MAX_EMPLOY_TIME);
        _ -> 0
    end.

%% 设置npc好感度
set_npc_impression(Rid, NpcBaseId, Impression) ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {set_npc_impression, Rid, NpcBaseId, Impression};
        _ -> ok
    end.

%% 注册到雇佣计时器去
register_employ_expire_event(Rid, NpcBaseId, EmployExpireTime) ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {register_employ_expire_event, Rid, NpcBaseId, EmployExpireTime};
        _ ->
            ok
    end.
        
%%---------------------------------------------------------
%% 内部实现
%%---------------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    init_impression(),
    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, {}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 赠送金币或者物品给npc
handle_info({gift_npc, RolePid, NpcBaseId, Gifts}, State) ->
    role:apply(async, RolePid, {fun do_gift_all/4, [Gifts, NpcBaseId, self()]}),
    {noreply, State};

%% 赠送物品成功
handle_info({gift_success, Rid, RolePid, NpcBaseId, ImpressionChanged}, State) ->
    save_impression(Rid, NpcBaseId, ImpressionChanged),
    role:pack_send(RolePid, 15610, {?true, ?L(<<"赠送物品成功">>), ImpressionChanged}),
    self() ! {get_all_npc_impression_info, Rid, RolePid, []},
    {noreply, State};

%% 雇佣
handle_info({employ_npc, Rid, RolePid, NpcBaseId, EmployHours}, State) ->
    case employ_one_npc(Rid, RolePid, NpcBaseId, EmployHours, self()) of
        true ->
            ok;
        {false, Reason} ->
            %% ?DEBUG("雇佣[~w]失败:~s", [NpcBaseId, Reason]),
            role:pack_send(RolePid, 15611, {?false, Reason, NpcBaseId, 0})
    end,
    {noreply, State};

%% 解雇
handle_info({fire_npc, Rid, RolePid}, State) ->
    fire_one_npc(Rid, RolePid),
    {noreply, State};

%% 获取某npc好感度信息
handle_info({get_npc_impression_info, Rid, RolePid, NpcBaseId, [FightCapacity, IsEmployee, EmployLeftTime]}, State) ->
    Impression = get_impression(Rid, NpcBaseId),
    case npc_data:get(NpcBaseId) of
        {ok, #npc_base{name = NpcName, career = Career, impression_ratio = ImpressionRatio}} ->
            Quality = get_npc_quality(ImpressionRatio),
            ImpressionLev = get_npc_impression_lev(Impression),
            IsEmployee1 = case IsEmployee of
                true -> ?true;
                false -> ?false
            end,
            FightCapacity1 = round(FightCapacity * get_impression_addt_ratio(ImpressionRatio, Impression)),
            %% ?DEBUG("Info=~w,~w,~w,~w,~w,~w,~w,~w,~w", [NpcBaseId, NpcName, Quality, Career, FightCapacity, Impression, ImpressionLev, IsEmployee, EmployLeftTime]),
            role:pack_send(RolePid, 15600, {NpcBaseId, NpcName, Quality, Career, FightCapacity1, Impression, ImpressionLev, IsEmployee1, EmployLeftTime});
        _ -> ignore
    end,
    {noreply, State};

%% 获取全部npc好感度信息
handle_info({get_all_npc_impression_info, Rid, RolePid, _Args}, State) ->
    NpcBaseIds = npc_employ_data:get_all(),
    Infos = do_get_npc_impression_info(Rid, NpcBaseIds, []),
    GoldBrickPrice = get_gold_brick_price(),
    %% ?DEBUG("Infos=~w", [Infos]),
    role:pack_send(RolePid, 15601, {Infos, GoldBrickPrice}),
    {noreply, State};

%% 设置npc好感度
handle_info({set_npc_impression, Rid, NpcBaseId, ImpressionChanged}, State) ->
    save_impression(Rid, NpcBaseId, ImpressionChanged),
    {noreply, State};

%% 注册雇佣超时事件
handle_info({register_employ_expire_event, Rid, NpcBaseId, EmployExpireTime}, State) ->
    add_to_employ_timer(Rid, NpcBaseId, EmployExpireTime),
    {noreply, State};

%% 处理超时检查
handle_info(check_employ_expire, State) ->
    check_employ_expire(),
    send_check_employ_expire_msg(),
    {noreply, State};

handle_info(stop, State) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%%---------------------------------------------------------
%% 初始化好感度和雇佣数据
init_impression() ->
    Data = npc_employ_dao:load_all_impression(),
    Impressions = do_init_impression(Data, []),
    put(impressions, Impressions),
    send_check_employ_expire_msg().

do_init_impression([], NI) -> NI;
do_init_impression([#npc_impression{role_id = RoleId, srv_id = SrvId, npc_base_id = NpcBaseId, impression = Impression}|T], Impressions) ->
    Rid = {RoleId, SrvId},
    NI = case lists:keyfind(Rid, 1, Impressions) of
        {{RoleId, SrvId}, Imps} -> 
            [{Rid, [{NpcBaseId, Impression}|Imps]}|lists:keydelete({RoleId, SrvId}, 1, Impressions)];
        _ -> 
            [{{RoleId, SrvId}, [{NpcBaseId, Impression}]}|Impressions]
    end,
    do_init_impression(T, NI).

%% 消耗金币或者物品
do_gift_all(Role = #role{id = Rid, pid = RolePid, name = _Name, bag = #bag{items = ItemList}}, Gifts, NpcBaseId, EmployMgrPid) ->
    {CoinAmount, Items, Flowers} = classify_gifts(Gifts, 0, [], []),
    LossList1 = case CoinAmount>0 of
        true -> [#loss{label = coin, val = CoinAmount}];
        false -> []
    end,
    LossList2 = case Items of
        [_|_] -> 
            [#loss{label = item_id, val = [{ItemId, Amount}]} || {ItemId, _Bind, Amount} <- Items];
        _ -> []
    end,
    LossList3 = case Flowers of
        [_|_] -> 
            LL3 = [#loss{label = item, val = [ItemBaseId, Bind, Amount]} || {ItemBaseId, Bind, Amount} <- Flowers],
            try_del_flower(Role, LL3);
        _ -> []
    end,
    LossList = LossList1 ++ LossList2 ++ LossList3,
    %% ?DEBUG("LossList=~w", [LossList]),
    NR = case role_gain:do(LossList, Role) of
        {false, #loss{msg = Msg}} ->
            ?ERR("[~s]赠送礼物~w给NPC[id=~w]失败:~w", [_Name, Gifts, NpcBaseId, Msg]),
            role:pack_send(RolePid, 15610, {?false, ?L(<<"赠送物品失败">>), 0}),
            Role;
        {ok, NewRole} ->
            ImpressionChanged = calc_impression_up(Gifts, ItemList, NpcBaseId, 0),
            ?DEBUG("[~s]赠送礼物~w给NPC[id=~w]成功，提升了~w点好感度", [_Name, Gifts, NpcBaseId, ImpressionChanged]),
            EmployMgrPid ! {gift_success, Rid, RolePid, NpcBaseId, ImpressionChanged},
            NewRole;
        _Other ->
            ?ERR("[~s]赠送礼物~w给NPC[id=~w]失败:~w", [_Name, Gifts, NpcBaseId, _Other]),
            role:pack_send(RolePid, 15610, {?false, ?L(<<"赠送物品失败">>), 0}),
            Role
    end,
    {ok, NR}.

%% 根据ItemId获取该Item的BaseId
get_item_base_id(Items, ItemId) ->
    %% ?DEBUG("Items=~w", [Items]),
    case storage:find(Items, #item.id, ItemId) of
        {ok, #item{base_id = ItemBaseId}} -> ItemBaseId;
        _ -> 0
    end.
    

%% 扣除鲜花不成功则扣晶钻
%% Flowers = [{ItemBaseId, Bind, Amount}]
try_del_flower(Role, Flowers) ->
    do_try_del_flower(Role, Flowers, []).
do_try_del_flower(_Role, [], Result) -> Result;
do_try_del_flower(Role, [LS = #loss{label = item, val = [ItemBaseId, _Bind, Amount]}|T], Result) ->
    %% LossItem = #loss{label = item, val = [ItemBaseId, Bind, Amount], msg = ?L(<<"物品不足">>)},
    LossItem = {ItemBaseId, Amount},
    LossList = [LossItem],
    case storage:get_del_base_bindlist(Role, LossList, [], []) of
        {false, _Reason} -> %% 鲜花不足则扣晶钻
            GoldAmount = case ItemBaseId of
                33002 -> 2;
                33003 -> 138;
                33004 -> 888;
                _ -> 0
            end,
            do_try_del_flower(Role, T, [#loss{label = gold, val = GoldAmount}|Result]);
        {ok, _DelList, _BindInfo} ->
            do_try_del_flower(Role, T, [LS|Result])
    end.

%% 对赠送物品进行归类 -> {CoinAmount, [{ItemBaseId, Bind, Amount}], [{ItemBaseId, Bind, Amount}]}
classify_gifts([], CoinAmount, Items, Flowers) -> {CoinAmount, Items, Flowers};
classify_gifts([[0, Amount, _, _]|T], CoinAmount, Items, Flowers) ->
    classify_gifts(T, CoinAmount+Amount, Items, Flowers);
classify_gifts([[1, ItemId, Bind, Amount]|T], CoinAmount, Items, Flowers) ->
    classify_gifts(T, CoinAmount, [{ItemId, Bind, Amount}|Items], Flowers);
classify_gifts([[2, FlowerType, _, _]|T], CoinAmount, Items, Flowers) ->
    case get_flower_item_base_id(FlowerType) of
        {ok, ItemBaseId} ->
            Flowers1 = case lists:keyfind(FlowerType, 1, Flowers) of
                {FlowerType, OldVal} -> [{ItemBaseId, 1, OldVal+1}|lists:keydelete(FlowerType, 1, Flowers)];
                _ -> [{ItemBaseId, 1, 1} | Flowers]
            end,
            classify_gifts(T, CoinAmount, Items, Flowers1);
        _ ->
            classify_gifts(T, CoinAmount, Items, Flowers)
    end;
classify_gifts([Other|T], CoinAmount, Items, Flowers) ->
    ?ERR("不支持的赠送物品分类类型:~w", [Other]),
    classify_gifts(T, CoinAmount, Items, Flowers).

%% 根据鲜花类型获取ItemBaseId
get_flower_item_base_id(FlowerType) ->
    case FlowerType of
        1 -> {ok, 33002};
        2 -> {ok, 33003};
        3 -> {ok, 33004};
        _ -> {false, 0}
    end.

%% 计算好感度提升度
calc_impression_up([], _Items, _NpcBaseId, Result) -> Result;
calc_impression_up([[0, Amount, _, _]|T], Items, NpcBaseId, Result) ->
    Val = do_calc_impression_up(coin, {Amount, NpcBaseId}),
    calc_impression_up(T, Items, NpcBaseId, Result + Val);
calc_impression_up([[1, ItemId, _Bind, Amount]|T], Items, NpcBaseId, Result) ->
    Val = do_calc_impression_up(item, {ItemId, Items, Amount, NpcBaseId}),
    calc_impression_up(T, Items, NpcBaseId, Result + Val);
calc_impression_up([[2, FlowerType, _, _]|T], Items, NpcBaseId, Result) ->
    Val = do_calc_impression_up(flower, {FlowerType, NpcBaseId}),
    calc_impression_up(T, Items, NpcBaseId, Result + Val);
calc_impression_up([_|T], Items, NpcBaseId, Result) ->
    calc_impression_up(T, Items, NpcBaseId, Result).
do_calc_impression_up(coin, {Amount, NpcBaseId}) ->
    NpcRatio = get_npc_impression_ratio(NpcBaseId),
    PlatformRatio = get_platform_impression_up_ratio(),
    GoldBrickPrice = get_gold_brick_price(),
    Up = case GoldBrickPrice=:=0 of
        true -> 0;
        false -> NpcRatio * PlatformRatio * Amount * GoldBrickPrice * 10 / (10000 * 1000)
    end,
    %% ?DEBUG("NpcBaseId=~w, NpcRatio=~w, GoldBrickRatio=~w, PlatformRatio=~w, Amount=~w, Up=~w", [NpcBaseId, NpcRatio, GoldBrickRatio, PlatformRatio, Amount, Up]),
    case Up > 0 andalso Up < 1 of
        true -> 0;
        false -> round(Up)
    end;
do_calc_impression_up(flower, {FlowerType, NpcBaseId}) ->
    F = case FlowerType of
        1 -> 1;
        2 -> 99;
        3 -> 999;
        _ -> 0
    end,
    NpcRatio = get_npc_impression_ratio(NpcBaseId),
    PlatformRatio = get_platform_impression_up_ratio(),
    Up = 2 * NpcRatio * PlatformRatio * F * 10,
    case Up > 0 andalso Up < 1 of
        true -> 0;
        false -> round(Up)
    end;
do_calc_impression_up(item, {ItemId, Items, Amount, NpcBaseId}) ->
    ItemBaseId = get_item_base_id(Items, ItemId),
    ItemRatio = get_item_gift_ratio(ItemBaseId),
    NpcRatio = get_npc_impression_ratio(NpcBaseId),
    PlatformRatio = get_platform_impression_up_ratio(),
    Up = ItemRatio * NpcRatio * PlatformRatio * Amount * 10,
    %% ?DEBUG("ItemBaseId=~w, Amount=~w, NpcBaseId=~w, ItemRatio=~w, NpcRatio=~w, PlatformRatio=~w, Amount=~w, Up=~w", [ItemBaseId, Amount, NpcBaseId, ItemRatio, NpcRatio, PlatformRatio, Amount, Up]),
    case Up > 0 andalso Up < 1 of
        true -> 0;
        false -> round(Up)
    end.


%% 获取物品赠送系数
get_item_gift_ratio(ItemBaseId) ->
    case item_data:get(ItemBaseId) of
        {ok, #item_base{type = ?item_task}} -> 0;
        {ok, #item_base{type = ?item_gift}} -> 0;
        {ok, #item_base{type = ?item_etc, id = 33002}} -> 0;
        {ok, #item_base{type = ?item_etc, id = 33003}} -> 0;
        {ok, #item_base{type = ?item_etc, id = 33004}} -> 0;
        {ok, #item_base{type = ?item_etc, id = 30010}} -> 0;
        {ok, #item_base{type = ?item_etc, id = 30011}} -> 0;
        {ok, #item_base{type = ?item_material}} -> 0.1;
        {ok, #item_base{}} -> 1;
        _ -> 0
    end.

%% 获取金砖价格
get_gold_brick_price() ->
    case catch npc_store_live:apply(sync, get) of
        {_, PriceList} ->
            [{_BaseId, Price} | _] = PriceList,
            Price;
        _Err ->
            ?ERR("获取金砖价格错误:~w", [_Err]),
            0
    end.


%% 获取npc好感度系数
get_npc_impression_ratio(NpcBaseId) ->
    case npc_data:get(NpcBaseId) of
        {ok, #npc_base{impression_ratio = ImpressionRatio}} -> ImpressionRatio;
        _ -> 0
    end.


%% 记录好感度到进程字典
%% [{{RoleId, SrvId}, [{NpcBaseId, Impression}]}]
save_impression_to_dict(Rid, NpcBaseId, NewImpression) ->
    Impressions = get(impressions),
    case Impressions of
        [_|_] ->
            MyImps = case lists:keyfind(Rid, 1, Impressions) of
                {Rid, L} when is_list(L) ->
                    [{NpcBaseId, NewImpression}|lists:keydelete(NpcBaseId, 1, L)];
                _ ->
                    [{NpcBaseId, NewImpression}]
            end,
            put(impressions, [{Rid, MyImps}|lists:keydelete(Rid, 1, Impressions)]);
        _ ->
            put(impressions, [{Rid, [{NpcBaseId, NewImpression}]}])
    end.

%% 记录好感度到数据库 -> true | {false, Reason}
save_impression_to_db({RoleId, SrvId}, NpcBaseId, NewImpression) ->
    NpcImpression = #npc_impression{role_id = RoleId, srv_id = SrvId, npc_base_id = NpcBaseId, impression = NewImpression}, 
    npc_employ_dao:save_impression(NpcImpression).

%% 记录好感度 -> true | false
save_impression(Rid, NpcBaseId, ImpressionChanged) ->
    NewImpression = calc_new_impression(Rid, NpcBaseId, ImpressionChanged),
    case save_impression_to_db(Rid, NpcBaseId, NewImpression) of
        true -> 
            save_impression_to_dict(Rid, NpcBaseId, NewImpression),
            true;
        {false, Reason} ->
            ?ERR("保存[~w]对npc[id=~w]的好感度失败:~w", [Rid, NpcBaseId, Reason]),
            false
    end.

%% 计算新的好感度
calc_new_impression(Rid, NpcBaseId, ImpressionChanged) ->
    OldImpression = get_impression(Rid, NpcBaseId),
    util:check_range(OldImpression + ImpressionChanged, 0, ?MAX_IMPRESSION).

%% 获取角色对指定npc的好感度 -> integer()
get_impression(Rid, NpcBaseId) ->
    Impressions = get(impressions),
    case Impressions of
        [_|_] ->
            case lists:keyfind(Rid, 1, Impressions) of
                {Rid, L} when is_list(L) ->
                    case lists:keyfind(NpcBaseId, 1, L) of
                        {NpcBaseId, OldImpression} -> OldImpression;
                        _ -> 0
                    end;
                _ -> 0
            end;
        _ -> 0
    end.

%% 消耗好感度 -> true | {false, Reason}
reduce_impression(Rid, NpcBaseId, EmployHours) ->
    Cost = EmployHours * 10,
    case get_impression(Rid, NpcBaseId) of
        OldImpression when OldImpression >= Cost ->
            case save_impression(Rid, NpcBaseId, -Cost) of
                true -> true;
                false -> {false, ?L(<<"好感度不足，无法雇佣">>)}
            end;
        _ -> {false, ?L(<<"好感度不足，无法雇佣">>)}
    end.    

%% 判断是否能雇佣该npc -> true | {false, Reason}
can_employ(Rid, NpcBaseId) ->
    case get_impression(Rid, NpcBaseId) of
        Impression when Impression >= 200 -> true;
        _ -> {false, ?L(<<"好感度未达到心腹之交，无法雇佣">>)}
    end.

%% 雇佣npc -> true | {false, Reason}
employ_one_npc(Rid, RolePid, NpcBaseId, EmployHours, EmployMgrPid) ->
    case can_employ(Rid, NpcBaseId) of
        true ->
            Impression = get_impression(Rid, NpcBaseId),
            case reduce_impression(Rid, NpcBaseId, EmployHours) of
                true ->
                    role:apply(async, RolePid, {fun do_employ_npc/5, [NpcBaseId, Impression, EmployHours, EmployMgrPid]}),
                    true;
                {false, Reason} -> {false, Reason}
            end;
    {false, Reason} -> {false, Reason}
    end.
do_employ_npc(Role = #role{id = Rid, pid = RolePid, special = Special, combat = CombatParams, link = #link{conn_pid = ConnPid}}, NpcBaseId, Impression, EmployHours, EmployMgrPid) ->
    NewSpecial = [{?special_npc_employ, NpcBaseId, <<>>} | Special],
    EmployTime = util:unixtime(),
    EmployExpireTime = EmployTime + EmployHours * 3600,
    NewCombatParams = [{employ_npc, {NpcBaseId, Impression, EmployTime, EmployExpireTime}}|lists:keydelete(employ_npc, 1, CombatParams)],
    Role1 = Role#role{special = NewSpecial, combat = NewCombatParams},
    {ok, Role2} = add_buff(Role1, Impression),
    Role3 = role_api:push_attr(Role2),
    map:role_update(Role3),
    EmployLeftTime = EmployHours * 3600,
    sys_conn:pack_send(ConnPid, 15611, {?true, <<>>, NpcBaseId, EmployLeftTime}),
    %% ?DEBUG("雇佣[~w]成功, 剩余时间:~w", [NpcBaseId, EmployLeftTime]),
    EmployMgrPid ! {get_all_npc_impression_info, Rid, RolePid, []},
    {ok, Role3}.

%% 解雇npc
fire_one_npc(Rid) ->
    case role_api:lookup(by_id, Rid, [#role.pid]) of
        {ok, _Node, [RolePid]} ->
            fire_one_npc(Rid, RolePid),
            true;
        _ ->
            false
    end.
fire_one_npc(_Rid, RolePid) ->
    role:apply(async, RolePid, {fun do_fire_npc/1, []}).
do_fire_npc(Role = #role{name = _Name, combat = CombatParams, special = Special, link = #link{conn_pid = ConnPid}}) ->
    case get_employee(Role) of
        undefined -> {ok, Role};
        NpcBaseId ->
            NewSpecial = lists:keydelete(?special_npc_employ, 1, Special),
            %% ?DEBUG("NewSpecial=~w", [NewSpecial]),
            Role1 = remove_all_buff(Role),
            Role2 = Role1#role{special = NewSpecial, combat = lists:keydelete(employ_npc, 1, CombatParams)},
            Role3 = role_api:push_attr(Role2),
            map:role_update(Role3),
            sys_conn:pack_send(ConnPid, 15612, {?true, <<>>, NpcBaseId}),
            %% ?DEBUG("[~s]解雇npc成功", [_Name]),
            {ok, Role3}
    end.


%% 添加雇佣buff
add_buff(Role, Buff) when is_record(Buff, buff)->
    NR = case buff:add(Role, Buff) of
        {ok, NewRole} -> NewRole;
        _ -> Role
    end,
    {ok, NR};
add_buff(Role, Impression) ->
    {_, Buff} = if
        Impression >= 6000 andalso Impression < 20000 -> buff_data:get(sns_buff_lv1);
        Impression >= 20000 andalso Impression < 40000 -> buff_data:get(sns_buff_lv2);
        Impression >= 40000 andalso Impression < 70000 -> buff_data:get(sns_buff_lv3);
        Impression >= 70000 andalso Impression < 120000 -> buff_data:get(sns_buff_lv4);
        Impression >= 120000 -> buff_data:get(sns_buff_lv5);
        true -> {false, undefined}
    end,
    case Buff of
        #buff{} -> add_buff(Role, Buff);
        _ -> {ok, Role}
    end.

%% 移除雇佣buff
remove_all_buff(Role) ->
    Labels = [sns_buff_lv1, sns_buff_lv2, sns_buff_lv3, sns_buff_lv4, sns_buff_lv5],
    do_remove_all_buff(Role, Labels).
do_remove_all_buff(Role, []) -> Role;
do_remove_all_buff(Role, [Label|T]) ->
    case buff:del_buff_by_label(Role, Label) of
        {ok, NewRole} -> do_remove_all_buff(NewRole, T);
        _ -> do_remove_all_buff(Role, T)
    end.

%% 计算好感度对属性和战斗力的转换系数
get_impression_addt_ratio(ImpressionRatio, Impression) ->
    AddtRatio1 = if
        Impression >= 40000 andalso Impression < 70000 -> 0.05;
        Impression >= 70000 andalso Impression < 120000 -> 0.1;
        Impression >= 120000 -> 0.15;
        true -> 0
    end,
    AddtRatio2 = case ImpressionRatio of
        0.1 -> 0.85;
        0.2 -> 0.75;
        0.3 -> 0.65;
        0.4 -> 0.55;
        0.5 -> 0.45;
        _ -> 0
    end,
    AddtRatio1 + AddtRatio2.

%% 计算参战npc属性 -> #npc_base{}
calc_combat_npc_attr(NpcBase = #npc_base{impression_ratio = ImpressionRatio}, #role{hp_max = HpMax, attr = #attr{aspd = Aspd, dmg_min = DmgMin, dmg_max = DmgMax, defence = Defence, hitrate = Hitrate, evasion = Evasion, critrate = Critrate, tenacity = Tenacity, anti_attack = AntiAttack, anti_stun = AntiStun, anti_taunt = AntiTaunt, anti_silent = AntiSilent, anti_sleep = AntiSleep, anti_stone = AntiStone, anti_poison = AntiPoison, anti_seal = AntiSeal, resist_metal = ResistMetal, resist_wood = ResistWood, resist_water = ResistWater, resist_fire = ResistFire, resist_earth = ResistEarth, dmg_wuxing = DmgWuxing, asb_metal = AsbMetal, asb_wood = AsbWood, asb_water = AsbWater, asb_fire = AsbFire, asb_earth = AsbEarth}}, Impression) ->
    Ratio = get_impression_addt_ratio(ImpressionRatio, Impression),
    HpMax1 = round(HpMax * Ratio),
    Aspd1 = round(Aspd * Ratio),
    DmgMin1 = round(DmgMin * Ratio),
    DmgMax1 = round(DmgMax * Ratio),
    Defence1 = round(Defence * Ratio),
    Hitrate1 = round(Hitrate * Ratio),
    Evasion1 = round(Evasion * Ratio),
    Critrate1 = round(Critrate * Ratio),
    Tenacity1 = round(Tenacity * Ratio),
    AntiAttack1 = round(AntiAttack * Ratio),
    AntiStun1 = round(AntiStun * Ratio),
    AntiTaunt1 = round(AntiTaunt * Ratio),
    AntiSilent1 = round(AntiSilent * Ratio),
    AntiSleep1 = round(AntiSleep * Ratio),
    AntiStone1 = round(AntiStone * Ratio),
    AntiPoison1 = round(AntiPoison * Ratio),
    AntiSeal1 = round(AntiSeal * Ratio),
    ResistMetal1 = round(ResistMetal * Ratio),
    ResistWood1 = round(ResistWood * Ratio),
    ResistWater1 = round(ResistWater * Ratio),
    ResistFire1 = round(ResistFire * Ratio),
    ResistEarth1 = round(ResistEarth * Ratio),
    DmgWuxing1 = round(DmgWuxing * Ratio),
    AsbMetal1 = round(AsbMetal * Ratio),
    AsbWood1 = round(AsbWood * Ratio),
    AsbWater1 = round(AsbWater * Ratio),
    AsbFire1 = round(AsbFire * Ratio),
    AsbEarth1 = round(AsbEarth * Ratio),
    NpcBase#npc_base{hp_max = HpMax1, hp = HpMax1, attr = #attr{aspd = Aspd1, dmg_min = DmgMin1, dmg_max = DmgMax1, defence = Defence1, hitrate = Hitrate1, evasion = Evasion1, critrate = Critrate1, tenacity = Tenacity1, anti_attack = AntiAttack1, anti_stun = AntiStun1, anti_taunt = AntiTaunt1, anti_silent = AntiSilent1, anti_sleep = AntiSleep1, anti_stone = AntiStone1, anti_poison = AntiPoison1, anti_seal = AntiSeal1, resist_metal = ResistMetal1, resist_wood = ResistWood1, resist_water = ResistWater1, resist_fire = ResistFire1, resist_earth = ResistEarth1, dmg_wuxing = DmgWuxing1, asb_metal = AsbMetal1, asb_wood = AsbWood1, asb_water = AsbWater1, asb_fire = AsbFire1, asb_earth = AsbEarth1}}.


%% 组装npc好感度信息
do_get_npc_impression_info(_Rid, [], Result) -> Result;
do_get_npc_impression_info(Rid, [NpcBaseId|T], Result) ->
    case npc_data:get(NpcBaseId) of
        {ok, #npc_base{name = NpcName, career = Career, impression_ratio = ImpressionRatio}} ->
            Impression = get_impression(Rid, NpcBaseId),
            Quality = get_npc_quality(ImpressionRatio),
            ImpressionLev = get_npc_impression_lev(Impression),
            do_get_npc_impression_info(Rid, T, [{NpcBaseId, NpcName, Quality, Career, Impression, ImpressionLev}|Result]);
        _ ->
            do_get_npc_impression_info(Rid, T, Result)
    end.

%% 获取npc好感度等级 -> integer()
get_npc_impression_lev(Impression) ->
    if
        Impression>=6000 andalso Impression<20000 -> 2;
        Impression>=20000 andalso Impression<40000 -> 3;
        Impression>=40000 andalso Impression<70000 -> 4;
        Impression>=70000 andalso Impression<120000 -> 5;
        Impression>=120000 -> 6;
        true -> 1
    end.

%% 获取npc品质 -> integer()
get_npc_quality(ImpressionRatio) ->
    if
        ImpressionRatio =:= 0.5 -> ?quality_white;
        ImpressionRatio =:= 0.4 -> ?quality_green;
        ImpressionRatio =:= 0.3 -> ?quality_blue;
        ImpressionRatio =:= 0.2 -> ?quality_purple;
        ImpressionRatio =:= 0.1 -> ?quality_orange;
        true -> 0
    end.

%% 读取平台好感度提升系数
get_platform_impression_up_ratio() ->
    case platform_cfg:get_cfg(impression_up_ratio) of
        false -> 1;
        Value -> Value / 100
    end.


%%--------------------------------------------------------
%% 雇佣计时
%%--------------------------------------------------------
add_to_employ_timer(Rid, NpcBaseId, ExpireTime) ->
    case get(expire_timer) of
        L when is_list(L) ->
            put(expire_timer, [{Rid, {NpcBaseId, ExpireTime}}|lists:keydelete(Rid, 1, L)]);
        _ ->
            put(expire_timer, [{Rid, {NpcBaseId, ExpireTime}}])
    end.

remove_from_employ_timer(Rid) ->
    case get(expire_timer) of
        L when is_list(L) ->
            put(expire_timer, lists:keydelete(Rid, 1, L));
        _ ->
            put(expire_timer, [])
    end.

is_employ_timeup(Rid) ->
    case get(expire_timer) of
        L when is_list(L) ->
            case lists:keyfind(Rid, 1, L) of
                {Rid, {_NpcBaseId, ExpireTime}} ->
                    (util:unixtime() - ExpireTime) =< 0;
                _ -> false
            end;
        _ ->
            false
    end.

check_employ_expire() ->
    case get(expire_timer) of
        L when is_list(L) ->
            lists:foreach(fun({Rid, _}) ->
                        case is_employ_timeup(Rid) of
                            true ->
                                fire_one_npc(Rid),
                                remove_from_employ_timer(Rid);
                            false -> ignore
                        end
                    end, L);
        _ -> ignore
    end.

send_check_employ_expire_msg() ->
    erlang:send_after(30000, self, check_employ_expire).

