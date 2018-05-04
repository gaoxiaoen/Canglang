%%----------------------------------------------------
%% 物品系统
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(item).
-export([
        make/3
        ,make/2
        ,use/3
        ,item_to_view/1
        ,item_to_view2/1
        ,check_item_cd/3
        ,get_gift_list/5
        ,make_gift_list/1
        ,cast_item/1
        ,put_dress/2
        ,dye_dress/3
        ,swap_dress_attr/3
        ,takeoff_dress/2
        ,recover_from_log/1
        ,check_is_gs/1
        ,check_is_gs/3
        ,check_is_gs_attr/1
        ,check_is_fumo/1
        ,check_fumo_and_make/1
        ,get_gs_pingfeng_args/1
        ,calc_field_guide/1
        ,do_lots_gift/2
        ,make_all_gift_list/2
        ,name/1
        ,main_type/1
        ,sub_type/1
        ,get_item_price/1
        ,check_pet_item/1
        ,is_demon_item/1
        ,get_baoshi_lev/1
        ,get_item_lev/1
        ,open_hole/1

    ]
).
-include("common.hrl").
-include("item.hrl").
-include("condition.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("version.hrl").
-include("setting.hrl").
-include("wing.hrl").
-include("demon.hrl").

-define(item_cd, []).
-define(gift_normal, 0).
-define(gift_career, 1).
-define(gift_lev, 2).
-define(gift_sex, 3).
-define(gift_sexcareer, 4).

%% 所有物品产出都改出非绑了，由宏 ?item_unbind 控制

%% 
make([], Items) -> Items;
make([BaseId|T], Items) ->
    case make(BaseId, 0, 1) of
        {ok, Items1} -> make(T, Items1++Items);
        false -> false
    end.

%% @spec main_type(BaseId) -> int()
%% @doc 获取物品大类
main_type(BaseId) ->
    case item_data:get(BaseId) of
        {ok, #item_base{type = Type}} -> Type;
        _ -> 0
    end.

%% @spec sub_type(BaseId) -> int()
%% @doc 获取物品子类
sub_type(BaseId) ->
    case item_data:get(BaseId) of
        {ok, _} -> BaseId rem 100000 div 100;
        _ -> 0
    end.

%% @spec name(BaseId) -> binary()
%% @doc 获取物品名字
name(BaseId) ->
    case item_data:get(BaseId) of
        {ok, #item_base{name = Name}} -> Name;
        _ -> <<>>
    end.

%% 生成一个物品数据
%% @spec make_item(BaseId, Bind, Quantity) -> false | {ok, [Item]} | {ok, Items}
%% BaseId = integer() 基础物品编号 
%% Bind = integer() 是否梆定 0:未梆定 1:已梆定
%% Quantity = integer() 数量
%% Item = #item{} 生成的物品
%% Items = [#item{} | ...] 生成了多个物品
make(BaseId, _Bind, Quantity) ->
    case Quantity =:= 0 of 
        true -> false;
        false -> 
            case item_data:get(BaseId) of
                {ok, _BaseItem = #item_base{durability_max = DurabilityMax, quality = Quality, attr = Attr, type = Type, use_type = UseType, condition = Condition, overlap = Overlap, effect = Effect}} ->
                    Upgrade = case Type =:= ?item_equip of
                        false -> 0; %% 非武器不可修炼
                        true -> 1 %% 武器修炼默认为1
                    end,
                    NewAttr = case Type =:= ?item_equip andalso dress:is_dress(BaseId) =/= true of
                        false -> Attr;
                        true -> init_hole(BaseId) ++ Attr
                    end,
                    Enchant = case Type =:= ?item_equip of
                        true ->
                            case lists:member(eqm:eqm_type(BaseId), ?enchant_type) of
                                false -> -1; %% 非强化类型不可强化
                                true -> 0 %% 强化类型默认为0
                            end;
                        false -> -1
                    end,
                    Require_lev = case lists:keyfind(lev, #condition.label, Condition) of
                        false -> 1;
                        #condition{target_value = Lev} -> Lev
                    end,
                    Career = case lists:keyfind(career, #condition.label, Condition) of
                        false -> 9;
                        #condition{target_value = GetCareer} -> GetCareer
                    end,
                    _Special = campaign_data:to_expire(BaseId), %% 去掉了过期信息
                    Item = #item{ver = ?ITEM_VER, base_id = BaseId, quality = Quality, upgrade = Upgrade,
                        enchant = Enchant, bind = ?item_unbind, attr = NewAttr, durability = DurabilityMax, require_lev = Require_lev, 
                        quantity = Quantity, type = Type, use_type = UseType, career = Career},
                    Item1 = item_treasure:make(Item),
                    Item2 = campaign_plant:make(Item1),
                    Item3 = mount:make(Item2),
                    Item4 = check_gs_and_make(Item3),
                    NewItem = Item4,
                    %%宠物装备，计算属性值
                    NewItem2 = case BaseId div 1000 of 
                                107 ->
                                    ValueList = [{Key, 100, gaussrand_mgr:get_value(Min, Max)}||{Key, Min, Max} <- Effect],
                                    NewItem1 = #item{special = Special1} = NewItem#item{attr = ValueList, bind = 1},
                                    Eqm_Fight = pet_api:calc_eqm_fight_capacity(NewItem1),
                                    NewItem1#item{special = [{?special_eqm_point, Eqm_Fight}] ++ Special1};
                                _ -> NewItem
                            end,
                    case Quantity =< Overlap of
                        true -> {ok, [NewItem2]};
                        false ->
                            make(NewItem2#item{quantity = Overlap}, Overlap, Quantity, [])
                    end;
                _ -> false
            end
    end.

make(_BaseItem, _Overlap, 0, Items) -> {ok, Items};
make(BaseItem, Overlap, Quantity, Items) when Quantity >= Overlap ->
    make(BaseItem, Overlap, Quantity - Overlap, [BaseItem | Items]);
make(BaseItem, Overlap, Quantity, Items) when Overlap > Quantity ->
    make(BaseItem, Overlap, 0, [BaseItem#item{quantity = Quantity} | Items]).

%% 使用物品 
%% @spec use(Role, Item, Num) -> {ok, NewRole, NewItem, NewNum} | {false, Reason}
%% Role = NewRole = #role{} 角色数据
%% Item = #item{} 物品数据
%% Num = integer() 期望使用掉的数量
%% NewItem = #item{} 使用过后的物品数据
%% NewNum = Int() 剩余的期望使用掉的数量
%% Reason = binary() 失败原因
use(_Role, #item{quantity = Q}, _Num) when Q < 1 -> {false, ?L(<<"物品数量异常">>)};
use(Role = #role{event = Event}, Item = #item{base_id = BaseId, quantity = Q}, Num) ->
    case item_data:get(BaseId) of
        {false, Reason} -> {false, Reason};
        %% 不能直接使用
        {ok, #item_base{use_type = UseType}} when UseType =:= 0 ->
            {false, ?L(<<"该物品不能直接使用">>)};
        %% 消耗型
        {ok, ItemBase = #item_base{use_type = UseType}} when UseType =:= 1 ->
            %% 消耗型物品需处理物品数量
            N = Q - Num,
            {UseNum, NQ, NewNum} = if  %% {用几个, 剩几个, 缺几个}
                N =:= 0 -> {Q, 0, 0};      %% 数量刚好
                N > 0 -> {Num, N, 0};        %% 还有剩余
                true -> {Q, 0, Num - Q}    %% 数量不够
            end,
            case do_use(Role, UseNum, ItemBase) of
                {false, Reason} -> {false, Reason};
                {ok, NewRole = #role{link = #link{conn_pid = ConnPid}}} ->
                    NewItem = Item#item{quantity = NQ},
                    case NQ =:= 0 of
                        true -> storage_api:refresh_client_item(del, ConnPid, [{?storage_bag, [NewItem]}]);
                        false -> storage_api:refresh_client_item(refresh, ConnPid, [{?storage_bag, [NewItem]}])
                    end,
                    log:log(log_item_del, {[Item], <<"使用消耗">>, <<"背包">>, Role}),
                    log:log(log_attainment, {<<"见闻录">>, <<>>, Role, NewRole}),
                    pack_send_gain_msg(ItemBase, UseNum, NewRole),
                    {ok, NewRole, Item#item{quantity = NQ}, NewNum}
            end;
        %% 非消耗型
        {ok, ItemBase = #item_base{use_type = UseType}} when UseType =:= 2 ->
            case do_use(Role, 1, ItemBase) of
                {ok, NewRole} -> {ok, NewRole, Item, 0};
                {false, Reason} -> {false, Reason}
            end;
        %% 穿戴物品
        {ok, #item_base{use_type = 3}} when ?EventCantPutItem ->
            {false, ?L(<<"竞技比赛时，不能随便穿装备的啦">>)};
        {ok, ItemBase = #item_base{type = Type, use_type = UseType}} when UseType =:= 3 ->
            case lists:member(Type, ?eqm_type) of
                false -> 
                    {false, ?L(<<"不可以穿戴的物品">>)};
                true ->
                    case do_use(Role, 1, ItemBase) of
                        {false, Reason} -> 
                            {false, Reason};
                        {ok, NewRole} ->
                            case eqm:puton(NewRole, Item) of
                                {false, Reason} -> {false, Reason};
                                {ok, R2, BackItem} -> {ok, R2, BackItem, 0}
                            end
                    end
            end
    end.
%% 执行使用操作
do_use(Role, Num, #item_base{id = BaseId, condition = Cond, effect = Effect}) ->
    case role_cond:check(Cond, Role) of %% 检查是否满足使用条件
        {false, RCond} -> {false, RCond#condition.msg};
        true ->
            case do(Effect, Num, Role) of
                {ok, NewRole = #role{cooldown = Cdlist}} ->
                    case check_item_cd(BaseId, Cdlist, Num) of
                        skip ->
                            {ok, NewRole};
                        {true, NewCdList} ->
                            {ok, NewRole#role{cooldown = NewCdList}};
                        {false, Reason} -> {false, Reason}
                    end;
                {false, Reason} -> {false, Reason}
            end
    end.

%% 如果使用量大的，可以在这处理一下
do([{coin, V}], Num, Role)  when Num >= 5 ->
    case role_gain:do([#gain{label = coin, val = V * Num}], Role) of
        {ok, Role1} ->
            log:log(log_coin, {<<"使用金币卡">>, <<"">>, Role, Role1}),
            {ok, Role1};
        _ -> {false, ?L(<<"增加金币失败">>)}
    end;
do(_Effect, 0, Role) -> {ok, Role};  %%只有一个item可以使用
do(Effect, Num, Role) ->        %%有多个items可以使用
    case item_effect:do(Effect, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} -> do(Effect, Num - 1, NewRole) %%使用下一个item
    end.

%% 检测特殊物品的冷却时间
check_item_cd(BaseId, Cdlist, Num) ->
    case lists:keyfind(BaseId, 1, ?item_cd) of
        {_BaseId, _CdTime} when Num > 1 -> {false, ?L(<<"该物品一次只能使用一个">>)};
        {BaseId, _CdTime} ->
            case lists:keyfind(BaseId, 1, Cdlist) of
                {BaseId, Q, LastTime} ->
                    case day_diff(util:unixtime(), LastTime) >= 1 of
                        true -> {true, lists:keyreplace(BaseId, 1, Cdlist, {BaseId, 1, util:unixtime()})};
                        false ->
                            case Q < 20 of
                                true -> {true, lists:keyreplace(BaseId, 1, Cdlist, {BaseId, Q + 1, util:unixtime()})};
                                false -> {false, ?L(<<"每天只能使用20次">>)}
                            end
                    end;
                false -> {true, [{BaseId, 1, util:unixtime()} | Cdlist]}
            end;
        false -> skip 
    end.

%% @spec item_to_view(Item) -> {reply, 参考协议}
%% @doc 把一个物品组装成一个tips信息, 用于不实际存在物品的tips组装
item_to_view(null) -> {reply, {0, 0, 0, 0, 0, 0, 0, [], [], []}}; 
item_to_view(#item{enchant = Enchant, base_id = BaseId, bind = Bind, upgrade = Upgrade, enchant_fail = Enchant_fail, durability = Durability, craft = Craft, attr = Attr, max_base_attr = MaxBaseAttr, extra = Extra}) ->
    {reply, {BaseId, Bind, Upgrade, Enchant, Enchant_fail, Durability, Craft, Attr, MaxBaseAttr, Extra}}.

%% @spec item_to_view2(Item) -> {reply, 参考协议}
%% @doc 把一个物品组装成一个tips信息, 用于不实际存在物品的tips组装
item_to_view2(null) -> {reply, {0, 0, 0, 0, 0, 0, 0, [], []}}; 
item_to_view2(#item{enchant = Enchant, base_id = BaseId, bind = Bind, upgrade = Upgrade, enchant_fail = Enchant_fail, durability = Durability, craft = Craft, attr = Attr, extra = Extra}) ->
    {reply, {BaseId, Bind, Upgrade, Enchant, Enchant_fail, Durability, Craft, Attr, Extra}}.

%% @spec get_gift_list(Type, Num, AllList, Role) -> {Num, List}
%% @doc 根据Type类型从AllList里面抽取一条用于取物品的随机列表
%% Type: 0:1条列表  1:按照职业取对应   2:按照等级区间取  3:按性别取
get_gift_list(?gift_normal, Num, Bind, L, _Role) ->
    {Num, Bind, L};

get_gift_list(?gift_career, Num, Bind, L, #role{career = C}) ->
    RL = case lists:nth(1, L) of
        new ->  %% 新礼包规则
            %% Type = {C, ascend:get_ascend(Role)},
            [_ | NL ] = L,
            get_gift_list_by_type(C, NL);
        _ ->
            lists:nth(C, L)
    end,
    {Num, Bind, RL};
get_gift_list(?gift_lev, Num, Bind, L, #role{lev = Lev}) ->
    RL = case lists:nth(1, L) of
        new ->  %% 新礼包规则
            Type = Lev div 10 * 10,
            [_ | NL ] = L,
            get_gift_list_by_type(Type, NL);
        _ when Lev >= 40 andalso Lev < 50 ->
            lists:nth(1, L);
        _ when Lev >= 50 andalso Lev < 60 ->
            lists:nth(2, L);
        _ when Lev >= 60 andalso Lev < 70 ->
            lists:nth(3, L);
        _ when Lev >= 70 andalso Lev < 80 ->
            lists:nth(4, L);
        _ when Lev >= 80 andalso Lev < 90 ->
            lists:nth(5, L);
        _ when Lev >= 90 andalso Lev < 100 ->
            lists:nth(6, L);
        _ ->
            lists:nth(1, L)
    end,
    {Num, Bind, RL};
get_gift_list(?gift_sex, Num, Bind, L, #role{sex = Sex}) ->
    RL = case lists:nth(1, L) of
        new ->  %% 新礼包规则
            [_ | NL ] = L,
            get_gift_list_by_type(Sex, NL);
        _ when Sex =:= 0 ->
            lists:nth(1, L);
        _ ->
            lists:nth(2, L)
    end,
    {Num, Bind, RL};
get_gift_list(?gift_sexcareer, Num, Bind, L, #role{sex = Sex, career = Career}) ->
    RL = case lists:nth(1, L) of
        new ->  %% 新礼包规则
            [_ | NL ] = L,
            get_gift_list_by_type({Sex, Career}, NL);
        _ when Sex =:= 0 ->
            lists:nth(1, L);
        _ ->
            lists:nth(2, L)
    end,
    {Num, Bind, RL};

get_gift_list(_, Num, Bind, L, _Role) ->
    {Num, Bind, L}.

get_gift_list_by_type(Type, []) ->
    ?ERR("error item gift type [type:~w]", [Type]),
    erlang:error("error item gift type");
get_gift_list_by_type(Type, [{Types, ItemList} |L]) ->
    case lists:member(Type, Types) of
        false -> get_gift_list_by_type(Type, L);
        true -> ItemList
    end.
%% @doc 循环调用 make_gift_list
%% 礼包全部使用产生物品
make_all_gift_list(Num1, GetL)->
    make_all_gift_list(Num1, GetL, [], []).
make_all_gift_list(0, _GetL, GainList, CastItems)->
    {ok, GainList, CastItems};
make_all_gift_list(N, GetL, AllGainList, AllCastItems)->
    case item:make_gift_list(GetL) of
        {false, Reason}->
            {false, Reason};
        {ok, GainList, CastItems}->
            make_all_gift_list(N - 1, GetL, GainList ++ AllGainList, CastItems++AllCastItems)
    end.
%% @spec make_gift_list({Num, List}) -> {ok, Gains, CastItems}
%% @doc 从随机列表List中取出Num个随机数
%%  {3,[{10725,1,1,20,0},{21010,0,1,10,0}]};
%% List = [{ID, 是否公告,数量,概率,是否受掉落控制}|..]
make_gift_list({Num, Bind, L}) ->
    TL = lists:sum([R || {_, _, _, R, _, _} <- L]),
    make_gift_list(Num, Bind, L, TL, [], []).

make_gift_list(0, _Bind, _L, _Rate, Gains, CastItems) -> {ok, Gains, CastItems};
make_gift_list(Num, Bind, L, Rate, Gains, CastItems) ->
    SeedRate = util:rand(1, Rate),
    case do_get_item(Bind, L, SeedRate, Rate) of
        {NewL, Gain, NewRate} ->
            make_gift_list(Num - 1, Bind, NewL, NewRate, [Gain | Gains], CastItems);
        {NewL, Gain, NewRate, CastItem} ->
            make_gift_list(Num - 1, Bind, NewL, NewRate, [Gain | Gains], CastItem ++ CastItems);
        {false, Reason} -> {false, Reason}
    end.


check_pet_item({Bid, _Cast, Q, _R, _IsControl, Bind}) ->
    case lists:member(Bid, drop_data:pet_item_type()) of
        true ->
            case drop_data:get_pet_item(Bid) of
                [] -> {Bid, Bind, Q};
                L -> 
                    {Bid1, Bind1, _Notify} = lists:nth(util:rand(1, length(L)), L),
                    {Bid1, Bind1, Q}
            end;
        false -> {Bid, Bind, Q}
    end.

is_demon_item(BaseId) ->
    (BaseId div 100) =:= 6410.


do_get_item(_B, L, SeedRate, Rate) ->
    do_get_item(_B, L, SeedRate, [], 0, Rate).
do_get_item(_B, [Item = {Bid, Cast, Q, R, IsControl, Bind} | T], Seed, BackItems, Range, Rate) ->
    case Seed =< (R + Range) orelse R =:= 999 of  %%判断掉落区间
        true ->
            case IsControl of
                1 ->
                    case center:is_cross_center() orelse item_srv_gift:query_data(Bid) of
                        true ->
                            {Bid1, Bind1, Q1} = check_pet_item(Item),
                            case Cast =:= 1 orelse Cast =:= 2 of
                                true ->
                                    {G, Items} = case item:make(Bid1, Bind1, Q1) of
                                        false ->
                                            {ok, I} = item:make(30011, 1, 1),
                                            {#gain{label = item, val = [30011, Bind, Q]}, I};
                                        {ok, I} ->
                                            {#gain{label = item, val = [Bid1, Bind1, Q1], misc = [{drop_notice, Cast}]}, I}
                                    end,
                                    {T ++ BackItems, G, Rate - R, Items}; 
                                false ->
                                    G = case item:make(Bid1, Bind1, Q1) of
                                        false ->
                                            #gain{label = item, val = [30011, Bind, Q]};
                                        {ok, _} ->
                                            #gain{label = item, val = [Bid1, Bind1, Q1]}
                                    end,
                                    {T ++ BackItems, G, Rate - R}
                            end;
                        {over, _Msg} -> 
                            GetId = item_gift_data:get_recoup(Bid),
                            G = #gain{label = item, val = [GetId, Bind, 1]},
                            {T ++ BackItems, G, Rate - R};
                        _Err -> ?ELOG("获取礼包极品信息出错:~w",[_Err])

                    end;
                0 ->
                    {Bid1, Bind1, Q1} = check_pet_item(Item),
                    case is_demon_item(Bid1) of
                        true ->
                            {T ++ BackItems, #gain{label = fragile, val = [Bid1, Q1]}, Rate - R};
                        false ->
                            case Cast =:= 1 orelse Cast =:= 2 of
                                true ->
                                    {G, Items} = case item:make(Bid1, Bind1, Q1) of
                                        false ->
                                            {ok, I} = item:make(30011, 1, 1),
                                            {#gain{label = item, val = [30011, Bind, Q]}, I};
                                        {ok, I} ->
                                            {#gain{label = item, val = [Bid1, Bind1, Q1], misc = [{drop_notice, Cast}]}, I}
                                    end,
                                    {T ++ BackItems, G, Rate - R, Items}; 
                                false ->
                                    G = case item:make(Bid1, Bind1, Q1) of
                                        false ->
                                            #gain{label = item, val = [30011, Bind, Q]};
                                        {ok, _} ->
                                            #gain{label = item, val = [Bid1, Bind1, Q1]}
                                    end,
                                    {T ++ BackItems, G, Rate - R}
                            end
                    end
            end;
        false ->
            do_get_item(_B, T, Seed, [Item | BackItems], Range + R, Rate)
    end.

%% @spec do_lots_gift(GainList, ItemList) -> {[#gain{}], [#item{}]}
%% Num = integer()
%% GainList =[#gain{}]
%% ItemList = [#gain{}]
%% 使用多个礼包返回后的数据
do_lots_gift(GainList, ItemList)->
    NewGainList = do_lots_gift(GainList, [], gain),
    NewItemList = do_lots_gift(ItemList, [], item),
    {NewGainList, NewItemList}.

do_lots_gift([], [], _Atom)->
    [];
do_lots_gift([], List, _Atom)->
    List;
do_lots_gift([X|T], [], Atom)->
    do_lots_gift(T, [X], Atom);
do_lots_gift([X|T], List, Atom)->
    NewList = case Atom of
        gain->
            do_lots_gift_gan(X, List,List);
        item->
            do_lots_gift_item(X,List,List)
    end,
    do_lots_gift(T, NewList, Atom).

do_lots_gift_gan(X, [], List)->
    [X|List];
do_lots_gift_gan(Y = #gain{val = [A, _B, C]},[X = #gain{val = [A1, B1, C1]} | L], List)->
    case A =:= A1 of
        true->
            [X#gain{val = [A1, B1, C1 + C]} | lists:delete(X, List)];
        false->
            do_lots_gift_gan(Y, L, List)
    end;
do_lots_gift_gan(Y = #gain{val = [A, C]},[X = #gain{val = [A1, C1]} | L], List)->
    case A =:= A1 of
        true->
            [X#gain{val = [A1, C1 + C]} | lists:delete(X, List)];
        false->
            do_lots_gift_gan(Y, L, List)
    end.
do_lots_gift_item(X, [], List)->
    [X|List];
do_lots_gift_item(Y = #item{base_id = A, quantity = B},[X = #item{base_id = A1, quantity = B1} | L], List)->
    case A =:= A1 of
        true->
            [X#item{quantity = B1 + B} | lists:delete(X, List)];
        false->
            do_lots_gift_item(Y, L, List)
    end.



%%do_lots_gift_gan([], _, NewGainList)->
%%    NewGainList;
%%
%%do_lots_gift_gan([Gain|T], GainList, NewGainList)->
%%    [NewGain] = lists:foldl(fun(#gain{val = [BaseId, Bind, N]}, Acc0 = [#gain{val = [BaseId0, _Bind0, N0]}])->
%%        case BaseId =:= BaseId0 of
%%            true->
%%               [Gain#gain{val = [BaseId,Bind ,N+N0]}];
%%           false->
%%               Acc0
%%        end
%%    end, [Gain], lists:delete(Gain, GainList)),
%%    case lists:member(NewGain, NewGainList) of
%%        true->
%%            do_lots_gift_gan(T, GainList, NewGainList);
%%        false->
%%            do_lots_gift_gan(T, GainList, [NewGain|NewGainList])
%%    end.
%%do_lots_gift_item([], _, NewItemList)->
%%    NewItemList;
%%do_lots_gift_item([Item|T], ItemList, NewItemList)->
%%    [NewItem] = lists:foldl(fun(#item{base_id = BaseId, quantity = N}, Acc0 = [#item{base_id = BaseId0, quantity = N0}])->
%%            case BaseId =:= BaseId0 of
%%                true->
%%                    [Item#item{quantity = N+N0}];
%%                false->
%%                    Acc0
%%            end
%%
%%    end, [Item], lists:delete(Item, ItemList)),
%%    case lists:member(NewItem,NewItemList) of
%%        true->
%%            do_lots_gift_item(T, ItemList, NewItemList);
%%        false->
%%            do_lots_gift_item(T, ItemList, [NewItem|NewItemList])
%%    end.
    
    

%% 广播物品,使用成功礼包之后,从进程字段取广播数据,否则清空该消息
cast_item(CastItems) ->
    case CastItems =/= [] of
        true ->
            ItemMsg = notice:item_to_msg(CastItems),
            role:put_dict(gift_castmsg, ItemMsg);
        false -> skip
    end.

%% @spec day_diff(UnixTime, UnixTime) -> int()
%% @doc 两个unixtime相差的天数,相邻2天返回1
%% return int() 相差的天数
day_diff(FromTime, ToTime) when ToTime > FromTime ->
    FromDate = util:unixtime({today, FromTime}),
    ToDate = util:unixtime({today, ToTime}),
    case (ToDate - FromDate) / (3600 * 24) of
        Diff when Diff < 0 -> 0;
        Diff -> round(Diff)
    end;

day_diff(FromTime, ToTime) when ToTime=:=FromTime ->
    0;

day_diff(FromTime, ToTime) ->
    day_diff(ToTime, FromTime).

check_can_dress(#item{base_id = BaseId, type = ?item_shi_zhuang}, Role = #role{dress = Dress}) ->
    case lists:keyfind(BaseId, #item.base_id, Dress) of
        false ->
            case item_data:get(BaseId) of
                {ok, #item_base{condition = Cond}} ->
                    case role_cond:check(Cond, Role) of
                        {false, RCond} -> {false, RCond#condition.msg};
                        true -> true
                    end;
                _ ->
                    ?ELOG("发现未知物品:~w",[BaseId]),
                    {false, <<"">>}
            end;
        _ -> {false, ?L(<<"您的衣柜已经有这件时装了，不要老是穿同样的衣服嘛！">>)}
    end;
check_can_dress(#item{base_id = BaseId, type = ?item_wing}, Role = #role{dress = Dress}) ->
    case lists:keyfind(BaseId, #item.base_id, Dress) of
        false ->
            case item_data:get(BaseId) of
                {ok, #item_base{condition = Cond}} ->
                    case role_cond:check(Cond, Role) of
                        {false, RCond} -> {false, RCond#condition.msg};
                        true -> true
                    end;
                _ ->
                    ?ERR("发现未知物品:~w",[BaseId]),
                    {false, <<"">>}
            end;
        _ -> {false, ?L(<<"您的衣柜已经有这对翅膀了，不要老是穿同样的翅膀嘛！^.^">>)}
    end;
check_can_dress(#item{base_id = BaseId, type = ?item_weapon_dress}, Role = #role{dress = Dress}) ->
    case lists:keyfind(BaseId, #item.base_id, Dress) of
        false ->
            case item_data:get(BaseId) of
                {ok, #item_base{condition = Cond}} ->
                    case role_cond:check(Cond, Role) of
                        {false, RCond} -> {false, RCond#condition.msg};
                        true -> true
                    end;
                _ ->
                    ?ERR("发现未知物品:~w",[BaseId]),
                    {false, <<"">>}
            end;
        _ -> {false, ?L(<<"您的兵器库已经有这个武饰了，不要老是拿同样的武饰嘛！^.^">>)}
    end;
check_can_dress(#item{base_id = BaseId, type = ?item_jewelry_dress}, Role = #role{dress = Dress}) ->
    case lists:keyfind(BaseId, #item.base_id, Dress) of
        false ->
            case item_data:get(BaseId) of
                {ok, #item_base{condition = Cond}} ->
                    case role_cond:check(Cond, Role) of
                        {false, RCond} -> {false, RCond#condition.msg};
                        true -> true
                    end;
                _ ->
                    ?ERR("发现未知物品:~w",[BaseId]),
                    {false, <<"">>}
            end;
        _ -> {false, ?L(<<"您的首饰盒已经有这个挂饰了，不要老是戴同样的挂饰嘛！^.^">>)}
    end;
check_can_dress(#item{base_id = BaseId, type = ?item_footprint}, Role = #role{dress = Dress}) ->
    case lists:keyfind(BaseId, #item.base_id, Dress) of
        false ->
            case item_data:get(BaseId) of
                {ok, #item_base{condition = Cond}} ->
                    case role_cond:check(Cond, Role) of
                        {false, RCond} -> {false, RCond#condition.msg};
                        true -> true
                    end;
                _ ->
                    ?ERR("发现未知物品:~w",[BaseId]),
                    {false, <<"">>}
            end;
        _ -> {false, ?L(<<"您的首饰盒已经有这个足迹了，不要老是戴同样的足迹嘛！^.^">>)}
    end;
check_can_dress(#item{base_id = BaseId, type = ?item_chat_frame}, Role = #role{dress = Dress}) ->
    case lists:keyfind(BaseId, #item.base_id, Dress) of
        false ->
            case item_data:get(BaseId) of
                {ok, #item_base{condition = Cond}} ->
                    case role_cond:check(Cond, Role) of
                        {false, RCond} -> {false, RCond#condition.msg};
                        true -> true
                    end;
                _ ->
                    ?ERR("发现未知物品:~w",[BaseId]),
                    {false, <<"">>}
            end;
        _ -> {false, ?L(<<"您的首饰盒已经有这个聊天框了，不要老是戴同样的聊天框嘛！^.^">>)}
    end;
check_can_dress(#item{base_id = BaseId, type = ?item_text_style}, Role = #role{dress = Dress}) ->
    case lists:keyfind(BaseId, #item.base_id, Dress) of
        false ->
            case item_data:get(BaseId) of
                {ok, #item_base{condition = Cond}} ->
                    case role_cond:check(Cond, Role) of
                        {false, RCond} -> {false, RCond#condition.msg};
                        true -> true
                    end;
                _ ->
                    ?ERR("发现未知物品:~w",[BaseId]),
                    {false, <<"">>}
            end;
        _ -> {false, ?L(<<"您的首饰盒已经有这个炫酷文字了，不要老是戴同样的炫酷文字嘛！^.^">>)}
    end;
check_can_dress(_, _) -> {false, <<"">>}.

%% 时装修改设置,翅膀不修改
type_to_setting(?item_shi_zhuang, Setting = #setting{dress_looks = DressLooks}) ->
    Setting#setting{dress_looks = DressLooks#dress_looks{dress = 1}};
type_to_setting(?item_wing, Setting) -> Setting;
type_to_setting(?item_weapon_dress, Setting = #setting{dress_looks = DressLooks}) ->
    Setting#setting{dress_looks = DressLooks#dress_looks{weapon_dress = 1}};
type_to_setting(?item_footprint, Setting = #setting{dress_looks = DressLooks}) -> 
    Setting#setting{dress_looks = DressLooks#dress_looks{footprint = 1}};
type_to_setting(?item_chat_frame, Setting = #setting{dress_looks = DressLooks}) -> 
    Setting#setting{dress_looks = DressLooks#dress_looks{chat_frame = 1}};
type_to_setting(?item_text_style, Setting) -> 
    Setting;
type_to_setting(_Type, Setting) ->
    Setting.

put_dress(Item = #item{type = Type, base_id = BaseId}, Role = #role{link = #link{conn_pid = ConnPid}, setting = Setting, eqm = Eqm, bag = Bag, dress = Dress}) ->
    %% ?DEBUG("=============== ~w ", [Dress]),
    case check_can_dress(Item, Role) of
        {false, Reason} -> {false, Reason};
        true ->
            Id = item_dress_data:baseid_to_id(BaseId),
            DressItem = Item#item{bind = 1, id = Id, pos = Id},
            PutItem = Item#item{bind = 1, id = eqm:type_to_pos(Type), pos = eqm:type_to_pos(Type)},
            NewDress = [DressItem | Dress],
            case storage:del_item_by_id(Bag, [{Item#item.id, 1}], true) of
                {false, R} -> {false, R};
                {ok, NewBag, _, _} -> 
                    {PutOrCg, NewEqm} = case lists:keyfind(eqm:type_to_pos(Type), #item.id, Eqm) of
                        false -> {put, [PutItem | Eqm]};
                        In -> {In, [PutItem | (Eqm -- [In])]}
                    end,
                    case PutOrCg =:= put of
                        true -> 
                            storage_api:del_item_info(ConnPid, [{?storage_bag, Item}]), 
                            storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem},{?storage_dress, DressItem}]);
                        false ->
                            storage_api:del_item_info(ConnPid, [{?storage_bag, Item}, {?storage_eqm, PutOrCg}]), 
                            storage_api:add_item_info(ConnPid, [{?storage_eqm, PutItem},{?storage_dress, DressItem}])
                    end,
                    New = looks:calc(Role#role{setting = type_to_setting(Type, Setting), bag = NewBag, eqm = NewEqm, dress = NewDress}),
                    Nr = role_api:push_attr(New),
                    looks:refresh(Role, Nr),
                    {ok, Nr}
            end
    end.

takeoff_dress(Id, Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm}) ->
    case lists:keyfind(Id, #item.id, Eqm) of
        false -> {false, ?L(<<"亲，您现在还没有穿这件装备，怎么脱">>)};
        Item ->
            NewEqm = Eqm -- [Item],
            storage_api:del_item_info(ConnPid, [{?storage_eqm, Item}]),
            New = looks:calc(Role#role{eqm = NewEqm}),
            Nr = role_api:push_attr(New),
            looks:refresh(Role, Nr),
            {ok, Nr}
    end.

%% @spec recover_from_log(LogId) -> ok | {false, Reason} | list()
%% LogId -> integer() | list() -> [integer()..] 日志ID,支持以列表方式传送多个
%% Reason: wrong_param无效参数，not_exists 没有该日志，fetch_failure数据库读取错误，has_recovered已经恢复过, other()邮件发送错误
%% @doc 从物品删除日志里回复一个或多个物品通过邮件发个原玩家
%% @author Jange 2012/4/18
recover_from_log(LogIds) when is_list(LogIds) ->
    L = [recover_from_log(LogId) || LogId <- LogIds],
    %% 全部成功就只返回OK，否则返回出错部分
    case [I || I <- L, I =/= ok] of
        [] -> ok;
        EL -> EL
    end;
recover_from_log(LogId) when is_integer(LogId) ->
    case db:get_row(log_db:to_sql(get_del_item_log), [LogId]) of
        {error, undefined} -> 
            {LogId, not_exists};
        {error, _Err} ->
            {LogId, fetch_failure};
        %% 只能恢复一次
        {ok, [Rid, SrvId, Name,ItemId, ItemName, Bind, DelType, _Pos, ItemInfo, 0]} ->            
            Items = case ItemInfo of
                <<>> ->
                    {_, DelItems} = make(ItemId, Bind, 1),
                    DelItems;
                _ -> 
                    {_, OldData} = util:bitstring_to_term(ItemInfo),
                    {_, Item} = item_parse:do(OldData),
                    [Item]
            end,
            case DelType =:= ?L(<<"坐骑喂养">>) of
                true ->
                    mount:recover_feed_item({Rid, SrvId}, Items);
                false ->
                    ignore
            end,
            Title = ?L(<<"物品恢复通知">>),
            Content = util:fbin(?L(<<"~s您好，您因~s而消失的[~s]现在通过附件已恢复给您，请注意查收!">>), [Name, DelType, ItemName]),
            Info = {Title, Content, [], Items},
            case mail:send_system({Rid, SrvId}, Info) of
                ok -> 
                    db:execute(log_db:to_sql(update_del_item_log), [LogId]),
                    ok;
                {false, MailErr} -> 
                    {LogId, MailErr}
            end;
        _ -> 
            {LogId, has_recovered}
    end;
recover_from_log(Para) -> 
    {Para, wrong_param}.

swap_dress_attr(BaseId1, BaseId2, Role = #role{link = #link{conn_pid = ConnPid}, setting = Setting, eqm = Eqm, dress = Dress}) ->
    case lists:keyfind(BaseId1, #item.base_id, Dress) of
        false -> {false, ?L(<<"亲，您暂时没有这件装备哦！请到商城处购买">>)};
        Sitem = #item{type = Type, enchant = Enchant, attr = Attr, base_id = BaseId, special = Special, enchant_fail = EnchantFail} ->
            case lists:keyfind(BaseId2, #item.base_id, Dress) of
                false -> {false, ?L(<<"亲，您暂时没有这件装备哦！请到商城处购买">>)};
                #item{type = Type, enchant = Tenchant} when Tenchant > Enchant ->
                    {false, ?L(<<"亲，强化等级低的装备不能转移到较高的装备上">>)};
                Titem  = #item{type = Type, base_id = Tbaseid, enchant = Tenchant} -> 
                    case role_gain:do([#loss{label = coin_all, val = 2000, msg = ?L(<<"金币不足,无法进行属性转移">>)}],
                            Role) of
                        {false, L} -> {?coin_less, L#loss.msg};
                        {ok, NewRole} -> 
                            {ok, [#item{attr = BaseAttr}]} = make(BaseId, 1, 1),
                            NewItem1 = Sitem#item{attr = BaseAttr, enchant = 0, enchant_fail = 0, special = []},
                            NewItem2 = blacksmith:recalc_attr(Titem#item{enchant_fail = EnchantFail, attr = Attr, enchant = Enchant, special = Special}),
                            DressItem = NewItem2#item{id = eqm:type_to_pos(Type), pos = eqm:type_to_pos(Type)},
                            Dress1 = lists:keyreplace(BaseId1, #item.base_id, Dress, NewItem1),
                            Dress2 = lists:keyreplace(BaseId2, #item.base_id, Dress1, NewItem2),
                            {PutOrCg, NewEqm} = case lists:keyfind(eqm:type_to_pos(Type), #item.id, Eqm) of
                                false -> {put, [DressItem | Eqm]};
                                GetItem -> {GetItem, [DressItem | (Eqm -- [GetItem])]}
                            end,
                            case PutOrCg =:= put of
                                true -> 
                                    storage_api:refresh_mulit(ConnPid, [{?storage_dress, NewItem1}, {?storage_dress, NewItem2}]),
                                    storage_api:add_item_info(ConnPid, [{?storage_eqm, DressItem}]);
                                false -> 
                                    storage_api:refresh_mulit(ConnPid, [{?storage_dress, NewItem1}, {?storage_dress, NewItem2}]),
                                    storage_api:del_item_info(ConnPid, [{?storage_eqm, PutOrCg}]), 
                                    storage_api:add_item_info(ConnPid, [{?storage_eqm, DressItem}])
                            end,
                            New = looks:calc(NewRole#role{setting = type_to_setting(Type, Setting), eqm = NewEqm, dress = Dress2}),
                            Nr = role_api:push_attr(New),
                            looks:refresh(Role, Nr),
                            log:log(log_blacksmith, {<<"属性转移">>, util:fbin(<<"[+~w]~w转移到[+~w]~w">>, [Enchant, BaseId, Tenchant, Tbaseid]), <<"成功">>, [Sitem, Titem], Role, Nr}),
                            {ok, Nr}
                    end;
                _ -> {false, ?L(<<"亲，同类装备才能进行属性转移的啦. ^.^">>)}
            end
    end.

%% 时装染色
dye_dress(Type, BaseId, Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm, dress = Dress}) ->
    case lists:keyfind(BaseId, #item.base_id, Dress) of
        false -> {false, ?L(<<"亲，您暂时没有这件装备哦！请到商城处购买">>)};
        Sitem = #item{extra = Extra, base_id = BaseId, type = ?item_shi_zhuang} ->
            OldColor = case lists:keyfind(?extra_dress_color, 1, Extra) of
                {_, Color, _} -> Color;
                _ -> 0
            end,
            case OldColor =:= Type of
                true -> {false, ?L(<<"时装本来就是这个颜色了,无需再次染色">>)};
                false ->
                    case role_gain:do([#loss{label = coin_all, val = 1000, msg = ?L(<<"金币不足, 无法染色">>)},
                                #loss{label = item, val = [32201, 1, 1], msg = ?L(<<"染色剂不足, 无法染色">>)}], Role) of
                        {false, #loss{msg = Msg, label = coin_all}} -> {?coin_less, Msg};
                        {false, L} -> {false, L#loss.msg};
                        {ok, NewRole} ->
                            NewExtra = case lists:keyfind(?extra_dress_color, 1, Extra) of
                                false -> [{?extra_dress_color, Type, <<>>} | Extra];
                                _ -> lists:keyreplace(?extra_dress_color, 1, Extra, {?extra_dress_color, Type, <<>>})
                            end,
                            NewItem = Sitem#item{extra = NewExtra},
                            NewDress = storage_api:fresh_dress(NewItem, Dress, ConnPid), 
                            {Flag, NewEqm} = case lists:keyfind(BaseId, #item.base_id, Eqm) of
                                GetItem = #item{base_id = BaseId} ->
                                    NewGetItem = GetItem#item{extra = NewExtra},
                                    storage_api:refresh_single(ConnPid, {?storage_eqm, NewGetItem}),
                                    {?L(<<"身上">>), lists:keyreplace(BaseId, #item.base_id, Eqm, NewGetItem)};
                                _ -> {?L(<<"衣柜">>), Eqm}
                            end,
                            Nr = looks:calc(NewRole#role{eqm = NewEqm, dress = NewDress}),
                            looks:refresh(Role, Nr),
                            log:log(log_blacksmith, {<<"时装染色">>, util:fbin(<<"[~s的~w]由第~w种染成第~w种">>, [Flag, BaseId, OldColor, Type]), <<"成功">>, [Sitem], Role, Nr}),
                            {ok, Nr}
                    end
            end;
        _ -> {false, ?L(<<"只有时装才能染色的">>)}
    end.

%% 判断是否需要添加附魔字段并生成物品item
check_fumo_and_make(Item = #item{extra = Extra}) ->
    case check_is_fumo(Item) of
        true ->
            NewExtra = case lists:keyfind(?extra_eqm_fumo, 1, Extra) of
                false -> [{?extra_eqm_fumo, 0, <<>>} | Extra]; %% 默认0级
                _ -> Extra
            end,
            Item#item{extra = NewExtra};
        false -> Item
    end.

%% 判断是否需要添加附魔等级字段
check_is_fumo(#item{type = Type, quality = Q}) when Q >= ?quality_orange ->
    lists:member(Type, ?eqm_base_type);
check_is_fumo(_) -> false.

%% 判断并添加神佑等级字段
check_gs_and_make(Item= #item{extra = Extra}) ->
    case check_is_gs(Item) of
        true ->
            NewExtra = case lists:keyfind(?extra_eqm_gs_lev, 1, Extra) of
                false -> [{?extra_eqm_gs_lev, 1, <<>>} | Extra]; %% 默认1级
                _ -> Extra
            end,
            Item#item{extra = NewExtra};
        false -> Item
    end;
check_gs_and_make(Item) -> Item.

%% 判断是否是神佑装备
check_is_gs(#item{type = Type, require_lev = ReqLev, quality = Q})
when ReqLev >= 70 andalso Q >= ?quality_orange ->
    %% 70级以上橙装
    lists:member(Type, ?eqm_base_type);
check_is_gs(_) ->
    false.

check_is_gs(Type, ReqLev, Q)
when ReqLev >= 70 andalso Q >= ?quality_orange -> %% 处理70级装备
    case lists:member(Type, ?eqm_base_type) of
        true -> true;
        false -> false
    end;
check_is_gs(_, _, _) ->
    false.

%% 判断是否神佑属性
check_is_gs_attr({A, _F, _V}) ->
    A >= ?attr_gs_hp andalso A =< ?attr_gs_anti_stone;
check_is_gs_attr(_) -> false.

%% 筛选装备神佑评分参数: {GsLev, GsCraft}
get_gs_pingfeng_args(#item{extra = Extra, attr = Attr}) ->
    case get_gs_craft(Attr) of
        false -> {0, 0};
        Cft ->
            {get_gs_lev(Extra), Cft}
    end.
get_gs_lev([]) -> 0;
get_gs_lev(Extra) ->
    case lists:keyfind(?extra_eqm_gs_lev, 1, Extra) of
        false -> 0;
        {_, GsLv, _} -> GsLv
    end.
%% 获取神佑装备品质
get_gs_craft(Attr) ->
    case [A || A <- Attr, check_is_gs_attr(A)] of
        [{_, F, _}] -> F;
        _ -> false
    end.

%% 获取物品价格
get_item_price(BaseId) ->
    case item_data:get(BaseId) of
        {ok,#item_base{value = Val}} ->
            case lists:keyfind(sell_npc, 1, Val) of
                {sell_npc, Price} ->
                    Price;
                false ->
                    false
            end;
        {false, _Reaon} ->
            false
    end.



%% 计算图鉴带来的属性 勋章
calc_field_guide(Role = #role{dress = Dress, wing = #wing{skin_list = SkinList}, mounts = #mounts{skins = MountList}}) ->
    ClothNum = length([Item || Item = #item{type = ?item_shi_zhuang} <- Dress]),
    WeaponNum = length([Item || Item = #item{type = ?item_weapon_dress} <- Dress]),
    FootPrintNum = length([Item || Item = #item{type = ?item_footprint} <- Dress]),
    ChatFrameNum = length([Item || Item = #item{type = ?item_chat_frame} <- Dress]),
    TextNum = length([Item || Item = #item{type = ?item_text_style} <- Dress]),
    WingNum = length(SkinList),
    MountNum = length(MountList),
    ClothAttr = get_cloth_attr(ClothNum),
    WeaponAttr = get_weapon_attr(WeaponNum),
    WingAttr = get_wing_attr(WingNum),
    MountAttr = get_mount_attr(MountNum),
    FootPrintAttr = get_footprint_attr(FootPrintNum),
    ChatAttr = get_chat_attr(ChatFrameNum),
    TextAttr = get_text_attr(TextNum),
    Attr = ClothAttr ++ WeaponAttr ++ WingAttr ++ MountAttr ++ FootPrintAttr ++ ChatAttr ++ TextAttr,
    case role_attr:do_attr(Attr, Role) of
        {ok, NewRole} -> NewRole;
        _ -> Role
    end.

get_cloth_attr(Num) when Num >= 2 andalso Num =< 4 -> [{hp_max, 100}, {defence, 100}]; 
get_cloth_attr(Num) when Num >= 5 andalso Num =< 7 -> [{hp_max, 200}, {defence, 200}];
get_cloth_attr(Num) when Num >= 8 andalso Num =< 11 -> [{hp_max, 300}, {defence, 300}];
get_cloth_attr(Num) when Num >= 12 andalso Num =< 19 -> [{hp_max, 500}, {defence, 500}];
get_cloth_attr(Num) when Num >= 20 -> [{hp_max, 800}, {defence, 800}];
get_cloth_attr(_) -> [].

get_weapon_attr(Num) when Num >= 2 andalso Num =< 3 -> [{dmg, 20}]; 
get_weapon_attr(Num) when Num >= 4 andalso Num =< 5 -> [{dmg, 100}];
get_weapon_attr(Num) when Num >= 6 andalso Num =< 7 -> [{dmg, 200}];
get_weapon_attr(Num) when Num >= 8 andalso Num =< 9 -> [{dmg, 300}];
get_weapon_attr(Num) when Num >= 10 -> [{dmg, 400}];
get_weapon_attr(_) -> [].

get_wing_attr(Num) when Num >= 2 andalso Num =< 5 -> [{dmg_magic, 20}]; 
get_wing_attr(Num) when Num >= 6 andalso Num =< 9 -> [{dmg_magic, 50}];
get_wing_attr(Num) when Num >= 10 andalso Num =< 14 -> [{dmg_magic, 120}];
get_wing_attr(Num) when Num >= 15 andalso Num =< 19 -> [{dmg_magic, 200}];
get_wing_attr(Num) when Num >= 20 -> [{dmg_magic, 300}];
get_wing_attr(_) -> [].


get_mount_attr(Num) when Num >= 2 andalso Num =< 4 -> [{tenacity, 10}]; 
get_mount_attr(Num) when Num >= 5 andalso Num =< 9 -> [{tenacity, 20}];
get_mount_attr(Num) when Num >= 10 andalso Num =< 14 -> [{tenacity, 40}];
get_mount_attr(Num) when Num >= 15 andalso Num =< 19 -> [{tenacity, 80}];
get_mount_attr(Num) when Num >= 20 andalso Num =< 24 -> [{tenacity, 120}];
get_mount_attr(Num) when Num >= 25 andalso Num =< 29 -> [{tenacity, 160}];
get_mount_attr(Num) when Num >= 30 -> [{tenacity, 200}];
get_mount_attr(_) -> [].

%% 足迹
get_footprint_attr(Num) when Num >= 2 andalso Num < 4 -> [{dmg, 20}];
get_footprint_attr(Num) when Num >= 4 andalso Num < 6 -> [{dmg, 100}];
get_footprint_attr(Num) when Num >= 6 andalso Num < 8 -> [{dmg, 200}];
get_footprint_attr(Num) when Num >= 8 andalso Num < 10 -> [{dmg, 300}];
get_footprint_attr(Num) when Num >= 10 -> [{dmg, 400}];
get_footprint_attr(_Num) -> [].

get_chat_attr(Num) when Num >= 2 andalso Num < 4 -> [{hp_max, 100}];
get_chat_attr(Num) when Num >= 4 andalso Num < 6 -> [{hp_max, 200}];
get_chat_attr(Num) when Num >= 6 andalso Num < 8 -> [{hp_max, 300}];
get_chat_attr(Num) when Num >= 8 andalso Num < 10 -> [{hp_max, 500}];
get_chat_attr(Num) when Num >= 10 -> [{hp_max, 800}];
get_chat_attr(_Num) -> [].

get_text_attr(Num) when Num >= 2 andalso Num < 4 -> [{defence, 100}];
get_text_attr(Num) when Num >= 4 andalso Num < 6 -> [{defence, 200}];
get_text_attr(Num) when Num >= 6 andalso Num < 8 -> [{defence, 300}];
get_text_attr(Num) when Num >= 8 andalso Num < 10 -> [{defence, 500}];
get_text_attr(Num) when Num >= 10 -> [{defence, 800}];
get_text_attr(_Num) -> [].


pack_send_gain_msg(#item_base{effect = Effect}, Num, #role{link = #link{conn_pid = ConnPid}}) ->
    case Effect of
        [] -> ok;
        [{Lable, V} | _] -> %% 这里默认只有一种收益！
            Msg = case Lable of
                coin ->
                    util:fbin(?L(<<"获得了~w金币">>), [V * Num]);
                coin_bind ->
                    util:fbin(?L(<<"获得了~w金币">>), [V * Num]);
                gold ->
                    util:fbin(?L(<<"获得了~w晶钻">>), [V * Num]);
                gold_bind ->
                    util:fbin(?L(<<"获得了~w晶钻">>), [V * Num]);
                stone ->
                    util:fbin(?L(<<"获得了~w符石">>), [V * Num]);
                attainment ->
                    util:fbin(?L(<<"获得了~w技能点">>), [V * Num]);
                exp ->
                    util:fbin(?L(<<"获得了~w经验">>), [V * Num]);
                vip ->
                    util:fbin(?L(<<"VIP等级提升到~w级">>), [V]);
                demon ->
                    {ok, #demon2{name = Name}} = demon_data2:get_demon_base(V),
                    util:fbin(?L(<<"获得了~s">>), [Name]);
                month_card ->
                    <<"获得月卡收益">>;
                _ -> nomsg
            end,
        case Msg of nomsg ->  skip; _ -> notice:alert(succ, ConnPid, Msg) end
    end.

get_baoshi_lev(BaseId) -> BaseId rem 10.
 
get_item_lev(BaseId) ->
    case item_data:get(BaseId) of
        {ok, #item_base{condition = Condition}} ->
            case lists:keyfind(lev, #condition.label, Condition) of
                false -> 1;
                #condition{target_value = Lev} -> Lev
            end;
        _ -> 1
    end.

open_hole(Item = #item{base_id = BaseId, attr = Attr}) ->
    Holes = lev_hole(get_item_lev(BaseId)),
    NeedOpen = [H || H = {_L, F, _} <- Holes, F =:= 101],
    Attr1 = do_open(Attr, NeedOpen),
    Item#item{attr = Attr1}.

do_open(Attr, []) -> Attr;
do_open(Attr, [H = {L,_F,_} | T]) ->
    case lists:keyfind(L, 1, Attr) of
        {L, 0, _} ->
            Attr1 = lists:keyreplace(L, 1, Attr, H),
            do_open(Attr1, T);
        {L, 101, _} ->
            do_open(Attr, T);
        false ->
            do_open(Attr, T)
    end.

%% 10 -> 1  20 -> 2  30 -> 3  ... 
init_hole(BaseId) ->
    lev_hole(get_item_lev(BaseId)).
lev_hole(1) -> [{?attr_hole1, 101, 0}, {?attr_hole2, 0, 0},{?attr_hole3, 0, 0},{?attr_hole4, 0, 0},{?attr_hole5, 0, 0}];
lev_hole(10) -> [{?attr_hole1, 101, 0}, {?attr_hole2, 101, 0},{?attr_hole3, 0, 0},{?attr_hole4, 0, 0},{?attr_hole5, 0, 0}];
lev_hole(20) -> [{?attr_hole1, 101, 0}, {?attr_hole2, 101, 0},{?attr_hole3, 101, 0},{?attr_hole4, 0, 0},{?attr_hole5, 0, 0}];
lev_hole(30) -> [{?attr_hole1, 101, 0}, {?attr_hole2, 101, 0},{?attr_hole3, 101, 0},{?attr_hole4, 101, 0},{?attr_hole5, 0, 0}];
lev_hole(40) -> [{?attr_hole1, 101, 0}, {?attr_hole2, 101, 0},{?attr_hole3, 101, 0},{?attr_hole4, 101, 0},{?attr_hole5, 101, 0}];
lev_hole(Lev) ->
    case Lev >= 50 of
        true -> [{?attr_hole1, 101, 0}, {?attr_hole2, 101, 0},{?attr_hole3, 101, 0},{?attr_hole4, 101, 0},{?attr_hole5, 101, 0}];
        false ->
            []
    end.
