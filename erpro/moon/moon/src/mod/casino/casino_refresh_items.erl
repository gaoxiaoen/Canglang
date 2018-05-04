%%----------------------------------------------------
%% 地下集市--交易
%% @author bwang 
%%----------------------------------------------------
-module(casino_refresh_items).
-export([
    get_items/3,
	% refresh_items/2,
	get_items_id/1,
    login/1,
    check_casino/1,
    send14239/1
	]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("casino.hrl").
-include("gain.hrl").
-include("guild.hrl").
-include("storage.hrl").
-include("item.hrl").

%%登录检查是否需要刷新淘宝界面剩余未爆炸的物品
login(Role = #role{id = {Rid, _}}) ->
    NRole = 
        case super_boss_casino:get_role_last_time(Rid) of 
            0 ->
                %%停服重启时，全部置为0.玩家重复登录而又不刷淘宝时不需要重复推送重置消息，保持每天0时重置一次
                super_boss_casino:update_role_last_time(Rid),
                role_timer:set_timer(send_14239, 5 * 1000, {casino_refresh_items, send14239, []}, 1, Role);
                % Role;
            LastTime ->
                Now = util:unixtime(),
                case util:is_same_day2(LastTime, Now) of 
                    true ->
                        Role;
                    false ->
                        super_boss_casino:update_role_last_time(Rid),
                        role_timer:set_timer(send_14239, 5 * 1000, {casino_refresh_items, send14239, []}, 1, Role)
                end
        end,
    role_timer:set_timer(check_casino, util:unixtime({nexttime, 86403}) * 1000, {casino_refresh_items, check_casino, []}, 1, NRole).
    % role_timer:set_timer(check_casino, 10* 1000, {casino_refresh_items, check_casino, []}, 1, Role).

check_casino(Role = #role{link = #link{conn_pid = ConnPid}}) ->
  
    sys_conn:pack_send(ConnPid, 14239, {}),        
    Time0 = util:unixtime(today),
    Tomorrow0 = (Time0 + 86400) - util:unixtime(),
    {ok, role_timer:set_timer(check_casino2, Tomorrow0*1000, {casino_refresh_items, check_casino, []}, day_check, Role)}.               

send14239(#role{link = #link{conn_pid = ConnPid}}) ->
    ?DEBUG("---SEND 14239-"),
    sys_conn:pack_send(ConnPid, 14239, {}),
    {ok}.


get_items(Type, N, Role = #role{name = Name}) ->
    Items = refresh_items(Type, N, Role),
    ItemIds = get_items_id(Items),
    {_NItems2, NRole} = put_into_storage(ItemIds, Role),
    check_rank(Type, Name, Items),
    {ItemIds, NRole}.


%%刷新n个物品
refresh_items(Type, Num, _Role = #role{id = {Rid, _}}) ->
    Items = super_boss_casino:get_role_all_items(Rid, Type), %%获取角色在ets的所有数据
    Items2 = 
        case Items of  %%玩家第一次刷新时ets中没有数据
            [] ->
                super_boss_casino:init_role_items(Rid, Type), %%初始化玩家在ets中的数据
                super_boss_casino:get_role_all_items(Rid, Type);
            _ -> Items
        end,    
    NLastItems = do_refresh_items(Num, Items2),     %%刷新获得物品
    NItems2 = update_role_allitems(Items2, NLastItems), %%更新所有数据
    super_boss_casino:update_role_all_items(Rid, Type, NItems2), %%更新所有数据到ets
    NLastItems. %%返回最后获得的数据


% -record(casino_base_item, {
%         item_id = 0                    %% 物品id
%         ,weight = 0                    %% 权重
%         ,weight_temp = 0               %% 存放暂时的权重
%         ,times_max                     %% 保底次数，表示连续N次内必须出现 
%         ,times_max_undisplay           %% 表示连续N次未出现 
%         ,times_limit_display           %% 限制次数内已经出现的次数 
%         ,times_limit                   %% 限制次数 
%         ,times_terminate               %% 禁用次数 
%         ,count                         %% 计算刷新的次数，概率被清零时开始计算，概率恢复则清零计数器 
%         ,is_notice                     %% 是否公告
%     }
% ).


do_refresh_items(Num, Items) ->
    Item_Weight = [Item_temp2||Item_temp2 <-Items, Item_temp2#casino_base_item.weight =/= 0], %%不是被限制的
    NewItems = lists:keysort(#casino_base_item.weight, Item_Weight), %%按第2个字段权重进行排序，默认为从小到大的序列
    Weight = [Item1#casino_base_item.weight || Item1 <- NewItems],

    Sum = lists:sum(Weight), %%weight的和

    refresh_items2(Num, 0, {NewItems, Weight, Sum}, []).

refresh_items2(Num, Num, _, L) ->  L;
refresh_items2(Num, Count, {NewItems, Weight, Sum}, L) ->
    Item = really_refresh_item({NewItems, Weight, Sum}),
    case Item == 0 of %%刷概率物品失败
        true -> 
             refresh_items2(Num, Count, {NewItems, Weight, Sum} ,L);
        false ->
            case Item of 
                {Re_Item, NewItems2} ->
                    refresh_items2(Num, Count + 1, {NewItems2, Weight, Sum}, [Re_Item|L]);
                _ ->
                    refresh_items2(Num, Count + 1, {NewItems, Weight, Sum}, [Item|L])
            end
    end.

really_refresh_item({NewItems, Weight, Sum}) ->
    Item_BaoDi = [Item_temp||Item_temp <-NewItems, Item_temp#casino_base_item.times_max - Item_temp#casino_base_item.times_max_undisplay == 1],
    case erlang:length(Item_BaoDi) of 
        0 -> %%没有即将达到保底的，则开始找weight 不为0的
            Rand = util:rand(1, Sum + 1), %%产生一个随机数
            % ?DEBUG("------Rand----~p~n", [Rand]),
            Item = get_item(Weight, Rand, NewItems), 

            Item; 
        Len -> 
            % ?DEBUG("***获得保底物品Item_BaoDi**长度**:~w~n",[Len]),
            Rand = util:rand(1, Len),
            Item_Temp = lists:nth(Rand, Item_BaoDi),
            [NItem_Temp] = do_update_role_allitems_displaytime([Item_Temp], []),
            NewItems2 = lists:keyreplace(Item_Temp#casino_base_item.item_id, #casino_base_item.item_id, NewItems, NItem_Temp),
            {Item_Temp , NewItems2}
    end.


%%获得符合条件的一个物品
get_item(Weights, Rand, Items) ->

    N = get_fit_item_num(Weights, Rand, 1),
    case (N == 0) or (erlang:length(Items) == 0) of 
        true -> 0;
        false ->
            case N > erlang:length(Items) of 
            	true -> lists:nth(N - 1, Items);
            	false -> lists:nth(N, Items)
            end
    end.

get_fit_item_num([], _, N) -> N; %%没有一个值可以匹配时选择最靠近的那一个
get_fit_item_num([Weight|T], Rand, N) ->
    case  Rand - Weight > 0 of 
        true ->
            get_fit_item_num(T, Rand - Weight, N + 1) ;
        false ->
            N
    end.

%%更新角色所有的物品数据，检查是否达到限制条件，是否可以解禁物品出现
update_role_allitems(Al_Items, Refresh_Items) ->
    Refresh_Items2 = del_duplicate(Refresh_Items),
    NRefresh_Items = do_update_role_allitems_displaytime(Refresh_Items2, []),%%更新出现的数据，检查各种条件
    List = Al_Items -- Refresh_Items,
    NLeftItems = do_update_role_allitems_undisplaytime(List, []),%%更新未出现的数据
    NRefresh_Items ++ NLeftItems.


del_duplicate(Items) ->
    do_del_duplicate(Items, []).

do_del_duplicate([], NItems) -> NItems;
do_del_duplicate([H = #casino_base_item{item_id = ItemId}|T], NItems) ->
    case lists:keyfind(ItemId, #casino_base_item.item_id, NItems) of 
        false ->
            do_del_duplicate(T, [H|NItems]);
        _ ->
            do_del_duplicate(T, NItems)
    end.

% -record(npc_store_base_item, {
%         item_id = 0                    %% 物品id
%         ,weight = 0                    %% 权重
%         ,weight_temp = 0               %% 存放暂时的权重
%         ,times_max                     %% 保底次数，表示连续N次内必须出现 
%         ,times_max_undisplay           %% 表示连续N次未出现 
%         ,times_limit_display           %% 限制次数内已经出现的次数 
%         ,times_limit                   %% 限制次数 
%         ,times_terminate               %% 禁用次数 
%         ,count                         %% 计算刷新的次数，概率被清零时开始计算，概率恢复则清零计数器 
%     }
% ).
do_update_role_allitems_displaytime([], L) -> L;
do_update_role_allitems_displaytime([H = #casino_base_item{weight = W, times_limit_display = Times, times_limit = Limit, times_terminate = Times_terminate}|T],L) -> 
    NH = 
        case Times - Limit == -1 andalso Times_terminate =/= 0 of 
            true ->     %%刚好达到了限制次数，暂时禁用，权重为0，未出现次数为0，出现次数为0，限制出现
                H#casino_base_item{weight = 0, weight_temp = W, times_max_undisplay = 0, times_limit_display = 0, count = 0};
            false ->    %%未达到限制次数，则更新未出现次数0，增加出现次数+1
                H#casino_base_item{times_max_undisplay = 0, times_limit_display= Times + 1}
        end,
    do_update_role_allitems_displaytime(T, [NH|L]).

do_update_role_allitems_undisplaytime([], TempList) -> 
    % ?DEBUG("**update_role_allitems*555*:~w~n",["Here"]),
    TempList;
do_update_role_allitems_undisplaytime([H = #casino_base_item{weight = W1, weight_temp = W, times_max_undisplay = UnDisplay, count = C, times_terminate =Ter}|T], TempList) ->
    NH =  
        case C + 1 == Ter of 
            true ->     %% 禁止出现的次数刚好达到了刷新的次数，则解禁，下一次刷新有机会出现
                 H#casino_base_item{
                 weight = W,
                 weight_temp = 0, times_max_undisplay = 0, times_limit_display = 0,
                 count = 0};
            false ->    %%仍然未达到解禁的条件
                case W1 == 0 of %%禁用的，只更新计数器
                    true ->
                        H#casino_base_item{count = C + 1};
                    false -> %% 不是被禁用的，只更新未出现+1
                        H#casino_base_item{times_max_undisplay = UnDisplay + 1}
                end
        end,
    do_update_role_allitems_undisplaytime(T, [NH|TempList]).

%%获得物品记录的id
get_items_id(Items) ->
    do_get_ids(Items, []).
do_get_ids([], L) ->L;
do_get_ids([H|T], L) ->
    do_get_ids(T, [H#casino_base_item.item_id|L]).

%%放入仓库
put_into_storage(NItems, Role = #role{id = {_Rid, _}, super_boss_store = #super_boss_store{items = Items, next_id = Next_Id, free_pos = Free_Pos}}) ->
    {NItemsNew, NNext_Id} = make_items(NItems, Next_Id, []),
    % ?DEBUG("--成功放入仓库--:~w~n",[NItemsRest]),
    NNFree_Pos = Free_Pos -- lists:seq(Next_Id, NNext_Id - 1), %%更新free_pos减去刚刚用掉的
    NewItems = lists:keysort(1, NItemsNew ++ Items),
    % super_boss_casino:update_role_last_items(Rid,[]),%%更新最后一次交易的物品为空
    {NItemsNew, Role#role{super_boss_store = #super_boss_store{items = NewItems, next_id = NNext_Id, free_pos = NNFree_Pos}}}.%%返回需要打开的页面数

%%检查是否上榜
check_rank(_Type, _RoleName, []) ->ok;
check_rank(Type, RoleName, [#casino_base_item{item_id = Id, is_notice = Notice}|T]) ->
    FromName = 
        case Type of
            1 -> <<"赤焰矿洞">>;
            2 -> <<"星河矿场">>
        end,
    case Notice of
        1 ->
            {ok, #item_base{name = ItemName, quality = Q}} = item_data:get(Id),

            RoleMsg = notice:role_to_msg(RoleName),
            ItemMsg = notice:item_to_msg({ItemName, Q, 1}),
           
            role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"天啊！~s竟然从~s中获得了珍稀道具~s, 真是让人羡慕啊！">>), [RoleMsg, FromName, ItemMsg])}),

            super_boss_casino:update_lucky_world(RoleName, ItemName);
        _ ->
            check_rank(Type, RoleName, T)
    end.

make_items([], Next_Id, L) -> {L, Next_Id};
make_items([ItemBaseId|T], Next_Id, L) ->
    make_items(T, Next_Id + 1, [{Next_Id, ItemBaseId, 1, ?new_item}|L]).
