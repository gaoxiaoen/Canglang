%%----------------------------------------------------
%%  锻造物品系统
%%
%% @author shawnoyc@163.com
%%----------------------------------------------------

-module(blacksmith).
-export([
        enchant_equip/4
        ,enchant_equip10/3
        ,embed_equip/4
        ,embed_equip_special/4
        ,remove_eqm/3
        ,polish_equip/4
        ,batch_polish/4
        ,add_polish/4
        ,fuse_stone/5
        ,broad_combine/3
        ,broad_refine/2
        ,refining_eqm/2
        ,check_hole/2
        ,re_calc_eqm/2
        ,swap_attr/2
        ,recalc_attr/1
        ,check_items/1
        ,find_base_attr/2
        ,replace_base_attr/3
        ,check_enchant_hole/1
        %% 装备升级
        ,lvlup_equip/3
        ,lvlup_stone/3
        ,gm_batch_polish/3
        ,broad_enchant_msg/5
    ]
).

-include("common.hrl").
-include("item.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("gain.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("blacksmith.hrl").
-include("guild.hrl").
-include("manor.hrl").

-define(ENCHANT_STONE, 111001).

%% ------------------------------------------------------------------
%% 功能处理
%% ------------------------------------------------------------------

%% 强化10次
enchant_equip10(EqmItem = #item{enchant = Enchant, base_id = BaseId}, AutoBuy, Role) ->
    Lev = item:get_item_lev(BaseId),
    MaxEnchant = enchant_data:max_lev(Lev),   
    case Enchant + 1 > MaxEnchant of
        true ->
            {false, ?L(<<"最高强化等级">>)};
        false ->
            do_enchant10(EqmItem, Role, AutoBuy, EqmItem, 0, [])
    end.

do_enchant10(OrigItem = #item{enchant = _OrigEnchant}, Role, _AutoBuy, EqmItem = #item{enchant = NewEnchant}, 10, Res) ->
    {ok, Role1, {NewEnchant, {0, 0}}} = enchant_fresh_client(true, Role, EqmItem, OrigItem),
    {ok, Role1, {NewEnchant, {0, 0}}, 10, Res, <<"">>};

do_enchant10(OrigItem = #item{enchant = _OrigEnchant}, Role, AutoBuy, EqmItem = #item{enchant = NewEnchant}, Count, Res) ->
    case enchant_equip(EqmItem, AutoBuy, false, Role) of
        {false, MsgStr} ->
            case Count >= 1 of
                true ->
                    {ok, Role1, {NewEnchant, {0, 0}}} = enchant_fresh_client(true, Role, EqmItem, OrigItem),
                    {ok, Role1, {NewEnchant, {0, 0}}, Count, Res, MsgStr};
                false ->
                    {false, MsgStr}
            end;
        {Role1, EqmItem1, IsSuc} ->
            do_enchant10(OrigItem, Role1, AutoBuy, EqmItem1, Count+1, [IsSuc | Res])
    end.

enchant_equip(EqmItem = #item{enchant = Enchant, base_id = BaseId}, AutoBuy, Refresh, Role = #role{bag = Bag}) ->
    Lev = item:get_item_lev(BaseId),
    MaxEnchant = enchant_data:max_lev(Lev),
    case Enchant + 1 > MaxEnchant of
        true ->
            {false, ?L(<<"当前已是最高强化等级">>)};
        false ->
            EqmLabel = eqm_api:get_type_name(BaseId),
            {_BaseRate, NeedStone} = enchant_data:get_rate_cost(EqmLabel, Enchant + 1),
            HasStoneNum = storage:count(Bag, ?ENCHANT_STONE),
            case HasStoneNum >= NeedStone of
                true ->
                    LossStone = [#loss{label = itemsall, val = [{?ENCHANT_STONE, NeedStone}]}],
                    {ok, Role1} = role_gain:do(LossStone, Role),
                    do_enchant(EqmItem, Refresh, Role1);
                false ->
                    case AutoBuy of
                        0 ->
                            {false, ?L(<<"强化石不足">>)};
                        1 ->    %% 自动购买
                            Price = shop:item_price(?ENCHANT_STONE) * (NeedStone - HasStoneNum),
                            LossStone = case HasStoneNum of 0 -> []; _ -> [#loss{label = itemsall, val = [{?ENCHANT_STONE, HasStoneNum}], msg = ?L(<<"强化石不足">>)}] end,
                            LossGold = [#loss{label = gold, val = Price, msg = ?L(<<"晶钻不足">>)}],
                            Loss = LossStone ++ LossGold,
                            case role_gain:do(Loss, Role) of
                                {ok, Role1} ->
                                    do_enchant(EqmItem, Refresh, Role1);
                                {false, #loss{msg = RetMsg}} ->
                                    {false, RetMsg}
                            end
                    end
            end
    end.

%% bRefresh -> true | false false 强化十次使用
do_enchant(EqmItem = #item{enchant = Enchant, base_id = BaseId, enchant_fail = EnchantFail}, Refresh, Role) ->
    EqmLabel = eqm_api:get_type_name(BaseId),   
    {BaseRate, _NeedStone} = enchant_data:get_rate_cost(EqmLabel, Enchant + 1), %% 基础概率万分比
    GuildRate = guild_role:tran_ratio(Role) * 10,   %% 军团千分比
    VipRate = round(vip:enchant_ratio(Role) * 100), %% 
    {NpcId, ManorRate, _} = manor:get_enchant_rate(Role, Enchant + 1),  %% 庄园百分比

    Role1 = manor:set_npc_old(NpcId, Role),

    SumRate = BaseRate + VipRate * 100 + GuildRate + ManorRate * 100,

    ?DEBUG("总成功率  ~w", [SumRate]),

    SumRate1 = case SumRate >= 10000 of true -> 10000; false -> SumRate end,
    Rate = util:rand(1, 10000),
    IsSuc = Rate =< SumRate1,

    case IsSuc of true -> ?DEBUG("***********强化成功  ****"); false -> ?DEBUG("******** 强化失败  **********") end,

    Flag = case IsSuc of true -> 1; false -> 0 end,

    EqmItem1 = case IsSuc of true -> EqmItem#item{enchant = Enchant+1}; false -> EqmItem#item{enchant_fail = EnchantFail+1} end,
    
    case Refresh of
        true ->
            enchant_fresh_client(IsSuc, Role1, EqmItem1, EqmItem);
        false ->
            {Role, EqmItem1, Flag}
    end.

%% @spec enchant_fresh_client(SucOrFail, Role, EqmItem, StoneItem, LuckItems) -> {ok, NewRole}
%% @doc 强化刷新客户端数据
enchant_fresh_client(IsSuc, Role = #role{career = Career, dress = Dress, eqm = EqmList, link = #link{conn_pid = ConnPid}}, EqmItem = #item{enchant = Enchant}, OrigItem) ->
    case IsSuc of    
        false ->
            {fail, Role, {Enchant, {0, 0}}};
        true ->
            EqmItem1 = recalc_attr(EqmItem),
            %%broad_enchant_msg(SucOrFail, Protect, Enchant, NewEnchant, Role),
            EqmItem3 = eqm_api:calc_point(EqmItem1, Career), %% 装备评分
            EqmList1 = lists:keyreplace(EqmItem3#item.id, #item.id, EqmList, EqmItem3),
            %% BroadItem2 = eqm_api:calc_all_enchant_add(BroadItem1, NewItems),
            {ok, EqmList2, #item{}} = storage_api:fresh_item(OrigItem, EqmItem3, EqmList1, ConnPid),
            Dress1 = storage_api:fresh_dress(EqmItem3, Dress, ConnPid),
            Role1 = looks:calc(Role#role{eqm = EqmList2, dress = Dress1}),
            Role2 = role_api:push_attr(Role1),
            looks:refresh(Role, Role2),
            Role3 = role_listener:eqm_event(Role2, update),
            {ok, Role3, {Enchant, {0, 0}}}
    end.

broad_enchant_msg(SucOrFail, Protect, OldEnchant, NewEnchant, Role = #role{}) when OldEnchant >= 14 ->
    RoleInfo = notice:get_role_msg(Role),
    case SucOrFail of
        suc ->
            role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"伟大的冒险家~s在铁匠铺将装备强化到了+~w，战斗力大幅提升">>),[RoleInfo, NewEnchant])});
        fail ->
            case Protect =/= 0 of
                true ->
                    role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"伟大的冒险家~s在铁匠铺强化+~w时运气不佳，好在有护纹保护，强化没有掉级">>),[RoleInfo, OldEnchant])});
                false ->
                    case OldEnchant =/= NewEnchant of
                        true -> %% 掉级了
                            role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"伟大的冒险家~s在铁匠铺强化+~w时运气不佳，装备掉落到+~w，不如加上幸运水晶试试吧">>),[RoleInfo, OldEnchant+1, NewEnchant])});
                        false ->
                            role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"伟大的冒险家~s在铁匠铺强化+~w时运气不佳，好在有保护等级，强化没有掉级">>),[RoleInfo, OldEnchant+1])})
                    end
            end
    end;
broad_enchant_msg(_SucOrFail, _Protec, _OldEnchant, _Enchant, #role{}) ->
    skip.

%% 镶嵌
embed_equip(Role = #role{bag = Bag}, EqmItem, StoneId, HolePos) ->
    case storage:find(Bag#bag.items, #item.id, StoneId) of  %% 镶嵌宝石是否存在
        {false, _Reason} -> {false, ?L(<<"镶嵌石不存在，请检查物品是否存在">>)};
        {ok, StoneItem} ->
            case check_xq(EqmItem, StoneItem, HolePos) of
                {false, Reason} -> {false, Reason};
                {ok} ->
                    case role_gain:do([#loss{label = item_id, val = [{StoneItem#item.id, 1}], msg = ?L(<<"镶嵌石不存在，请检查物品是否存在">>)}], Role) of
                        {false, #loss{msg = Msg}} -> {false, Msg};
                        {ok, NewRole} ->
                            {NewList, NewDress, NewWing, NewMounts} = fresh_embed(NewRole, EqmItem, StoneItem, HolePos),
                            NR = NewRole#role{eqm = NewList, dress = NewDress, wing = NewWing, mounts = NewMounts},
                            NR2 = medal:listener(bs_eqm, NR),
                            rank_celebrity:bs_suit(NR2),
                            {suc, StoneItem, NR2}
                   end
            end
    end.

%% 特殊镶嵌
embed_equip_special(Role = #role{bag = Bag}, EqmItem = #item{attr = _Attr}, StoneId, HolePos) ->
    case storage:find(Bag#bag.items, #item.id, StoneId) of  %% 镶嵌宝石是否存在
        {false, _Reason} -> {false, ?MSGID(<<"镶嵌石不存在，请检查物品是否存在">>)};
        {ok, StoneItem} ->
            case check_xq_special(EqmItem, StoneItem, HolePos) of
                {false, Reason} -> {false, Reason};
                {ok} ->
                    %% NeedCoin = 10000,
                    case role_gain:do(
                            [#loss{label = item_id, val = [{StoneItem#item.id, 1}], msg = ?L(<<"镶嵌石不存在，请检查物品是否存在">>)}], Role) of
                        {false, #loss{label = coin_all, msg = Msg}} -> {?coin_less, Msg};
                        {false, #loss{msg = Msg}} -> {false, Msg};
                        {ok, NewRole} ->
                            {NewList, NewDress, NewWing, NewMounts} = fresh_embed(NewRole, EqmItem, StoneItem, HolePos),
                            NR = NewRole#role{eqm = NewList, dress = NewDress, wing = NewWing, mounts = NewMounts},
                            NR2 = medal:listener(bs_eqm, NR),
                            rank_celebrity:bs_suit(NR2),
                            {suc, StoneItem, NR2}
                    end
            end
    end.

%% 镶嵌刷新客户端
fresh_embed(_Role = #role{career = Career, wing = Wing, eqm = EqmList, mounts = Mounts, dress = Dress, link =#link{conn_pid = ConnPid}}, EqmItem = #item{attr = Attr}, #item{base_id = BaseId}, HolePos) ->
    NewAttr = lists:keyreplace(HolePos, 1, Attr, {HolePos, 101, BaseId}),
    NewEqm = EqmItem#item{attr = NewAttr},
    NewEqm1 = eqm_api:calc_point(NewEqm, Career),
    NewItems = lists:keyreplace(NewEqm1#item.id, #item.id, EqmList, NewEqm1),
    NewEqm2 = eqm_api:calc_all_enchant_add(NewEqm1, NewItems),

    {ok, NewEqmList, _NewItem} = storage_api:fresh_item(EqmItem, NewEqm2, EqmList, ConnPid),
    NewDress = storage_api:fresh_dress(NewEqm1, Dress, ConnPid),
    NewWing = storage_api:fresh_wing(EqmItem, NewEqm1, Wing, ConnPid), 
    NewMounts = storage_api:fresh_mounts(EqmItem, NewEqm1, Mounts, ConnPid),
    {NewEqmList, NewDress, NewWing, NewMounts}.

%% 摘除
remove_eqm(Role, EqmItem = #item{attr = Attr}, Name) ->
    case lists:keyfind(Name, 1, Attr) of
        false ->
            {false, ?L(<<"不存在的宝石孔">>)};
        {_, _Flag, 0} ->
            {false, ?L(<<"该孔没有宝石">>)};
        {Name, _Flag, BaseId} when BaseId =/= 0 -> 
            fresh_remove(Role, EqmItem, Name, BaseId)
    end.

fresh_remove(Role = #role{id = _Rid, career = Career, eqm = EqmList, link = #link{conn_pid = ConnPid}}, EqmItem = #item{attr = Attr},  Name, BaseId) -> 
    NewAttr = lists:keyreplace(Name, 1, Attr, {Name, 101, 0}),
    EqmItem1 = recalc_attr(EqmItem#item{attr = NewAttr}),
    EqmItem2 = eqm_api:calc_point(EqmItem1, Career),
    NewItems = lists:keyreplace(EqmItem2#item.id, #item.id, EqmList, EqmItem2),
    EqmItem3 = eqm_api:calc_all_enchant_add(EqmItem2, NewItems),

    {ok, Ne, _} = storage_api:fresh_item(EqmItem, EqmItem3, EqmList, ConnPid),
    Role1 = role_api:push_attr(Role#role{eqm = Ne}),
    case role_gain:do([#gain{label = item, val = [BaseId, 1, 1]}], Role1) of
        {false, _G} ->
            {false, ?L(<<"你背包已满，拆除失败">>)};
        {ok, Role2} -> {suc, BaseId, Role2}
    end.


%% 检查洗炼石和金币是否足够，如果足够则扣除
check_wash_things(Role = #role{bag = #bag{items = Items}}, StoneNum, Coin, 1) ->
    case shop:item_price(111301) of
        false ->
            {false, ?L(<<"洗炼石不可购买">>)};
        Price ->
            ?DEBUG("******* 鉴定石价格  ~p ", [Price]),
            LossList =
            case storage:find(Items, #item.base_id, 111301) of
                {false, _Reason} ->
                    [
                        #loss{label = coin_all, val = Coin, msg = <<"金币不足">>},
                        #loss{label = gold, val = StoneNum * Price, msg = <<"晶钻不足">>}
                    ];           
                {ok, HaveNum, _, _, _} when HaveNum >= StoneNum ->
                    [
                        #loss{label = itemsall, val = [{111301, StoneNum}], msg = <<"鉴定石不足">>},
                        #loss{label = coin_all, val = Coin, msg = <<"金币不足">>}
                    ];
                {ok, HaveNum,_,_,_} -> 
                    NeedGold = (StoneNum - HaveNum) * Price,
                    [
                        #loss{label = itemsall, val = [{111301, HaveNum}], msg = <<"鉴定石不足">>},
                        #loss{label = coin_all, val = Coin, msg = <<"金币不足">>},
                        #loss{label = gold, val = NeedGold, msg = <<"晶钻不足">>}
                    ]
            end,

            case role_gain:do(LossList, Role) of
                {false, L} -> {false, L#loss.msg};
                {ok, NewRole} -> {ok, NewRole}
            end
    end;
 check_wash_things(Role, StoneNum, Coin, 0) ->
    LossList =
            [
                #loss{label = itemsall, val = [{111301, StoneNum}], msg = <<"鉴定石不足">>},
                #loss{label = coin_all, val = Coin, msg = <<"金币不足">>}
            ],
    case role_gain:do(LossList, Role) of
        {false, L} -> {false, L#loss.msg};
        {ok, NewRole} -> {ok, NewRole}
    end.

polish_equip(Role = #role{career = Career}, EqmItem = #item{require_lev = Lev, base_id = BaseId, wash_cnt = EqmWashCnt}, _Mode, AutoBuy) ->
    case equip_wash_data:get(BaseId) of
        {false} -> 
            {false, ?L(<<"此装备不能洗炼">>)};
        WashConf = {ok, {_, _, _, StoneNum, Coin}} ->
            case check_wash_things(Role, StoneNum, Coin, AutoBuy) of
                {false, Msg} -> {false, Msg};
                {ok, NewRole} ->
                    case get_batch_polish(EqmWashCnt, 1, WashConf, Career, Lev) of
                        {false, Reason} -> {false, Reason};
                        {ok, NewEqmWashCnt, Polish = [{_, _, Attr}]} ->
                            broad_polish(Role, Attr),
                            {ok, NewRole, EqmItem#item{wash_cnt = NewEqmWashCnt, polish = Polish}}
                    end
            end
    end.

%% 批量洗练
batch_polish(Role = #role{career = Career}, EqmItem = #item{require_lev = Lev, base_id = BaseId, wash_cnt = EqmWashCnt}, _Mode, AutoBuy) ->
    case equip_wash_data:get(BaseId) of
        false -> {false, ?MSGID(<<"此装备不能洗炼">>)};
        WashConf = {ok, {_, _, _, StoneNum, Coin}} ->
            case check_wash_things(Role, StoneNum * 5, Coin, AutoBuy) of
                {false,Reason} -> {false, Reason};
                {ok, NewRole} ->
                    case get_batch_polish(EqmWashCnt, 5, WashConf, Career, Lev) of
                        {false, Reason} -> {false, Reason};
                        {ok, NewEqmWashCnt, Polish} ->
                            AllAttr = lists:foldl(fun({_,_, Attr}, Sum) -> Attr ++ Sum end, [], Polish),
                            broad_polish(Role, AllAttr),
                            {ok, NewRole, EqmItem#item{wash_cnt = NewEqmWashCnt, polish_list = Polish}}
                    end
            end
    end.


add_polish(Role, Id, 1, EqmItem = #item{polish = PolishList}) -> 
    case lists:keyfind(Id, 1, PolishList) of
        false -> {false, ?L(<<"该装备还未洗练过,请先洗练">>)};
        {Id, _Bind, Attr} ->
            fresh_polish(Role, ?storage_eqm, EqmItem#item{polish = []}, EqmItem#item{bind = ?item_unbind}, Attr)
    end;

add_polish(Role, Id, 2, EqmItem = #item{polish_list = PolishList}) ->
     case lists:keyfind(Id, 1, PolishList) of
        false -> {false, ?L(<<"该装备还未洗练过,请先洗练">>)};
        {Id, _Bind, Attr} ->
            fresh_polish(Role, ?storage_eqm, EqmItem#item{polish_list = []}, EqmItem#item{bind = ?item_unbind}, Attr)
    end.


%% 洗练刷新客户端
fresh_polish(Role = #role{career = Career, dress = Dress, wing = Wing, eqm = EqmList, bag = Bag, link = #link{conn_pid = ConnPid}}, StorageType, EqmItem = #item{attr = EqmAttr, bind = _Bind1}, #item{bind = _Bind2}, Attr) ->
    BaseAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- EqmAttr, Flag < 1000],
    NewAttr = BaseAttr ++ Attr,

    NewEqmItem = EqmItem#item{attr = NewAttr},
%%  broad_polish(Role, NewEqmItem, Attr),
    {NewBagItems, NewEqmItems, NewDressList, _NewEqm, NewWingList} = case StorageType of
        ?storage_bag ->
            {ok, NewBag, NewItem} = storage_api:fresh_item(EqmItem, NewEqmItem, Bag, ConnPid),
            {NewBag, EqmList, Dress, NewItem, Wing};
        ?storage_eqm ->
            NewEqmItem1 = eqm_api:calc_point(NewEqmItem, Career),
            NewItems = lists:keyreplace(NewEqmItem1#item.id, #item.id, EqmList, NewEqmItem1),
            NewEqmItem2 = eqm_api:calc_all_enchant_add(NewEqmItem1, NewItems),

            {ok, NewEqmList, NewItem} = storage_api:fresh_item(EqmItem, NewEqmItem2, EqmList, ConnPid),
            NewDress = storage_api:fresh_dress(NewItem, Dress, ConnPid),
            NewWing = storage_api:fresh_wing(EqmItem, NewEqmItem1, Wing, ConnPid), 
            {Bag, NewEqmList, NewDress, NewEqmItem1, NewWing}
    end,
    {ok, Role#role{bag = NewBagItems, dress = NewDressList, eqm = NewEqmItems, wing = NewWingList}, NewEqmItem}.

%% 炼炉合成
fuse_stone(Role, StoneId, Type, Num, Mode) ->
    case get_fuse_list(StoneId, Type) of
        {false, Reason} -> {false, Reason};
        List ->
            {Coin, Suc} = combine_data:get_coin_and_suc(StoneId, Type),
            check_fuse(Role, List, StoneId, Coin, Suc, Num, Mode)
    end.

refining_eqm(Role = #role{career = Career, link = #link{conn_pid = ConnPid}, eqm = Eqm}, [EqmItem = #item{bind = _Bind1}]) -> 
    case check_can_refining(Role, EqmItem) of
        {false, Reason} -> 
            ?DEBUG("精炼失败.... 原因   ~p~n", [Reason]),
            {false, Reason};
        {true, NextId, DelList, _Lvl, NeedCoin} ->
            case role_gain:do([#loss{label= items_bind_fst, val = DelList, msg = ?L(<<"物品不存在，请检查是否存在物品">>)},
                        #loss{label = coin_all, val = NeedCoin, msg = ?L(<<"您没有足够的金币精炼">>)}],
                    Role) of
                {false, L = #loss{label = coin_all}} -> {?coin_less, L#loss.msg};
                {false, L} -> {false, L#loss.msg};
                {ok, NewRole} ->

                    case item:make(NextId, 1, 1) of
                        false -> {ok};
                        {ok, [RefItem]} ->
                            NewItem = blacksmith:swap_attr(EqmItem, RefItem),
                            {ok, #item_base{condition = Cond}} = item_data:get(NewItem#item.base_id),
                            PutItem = case role_cond:check(Cond, Role) of
                                {false, _} -> NewItem;
                                true -> NewItem
                            end,
                            PutItem1 = eqm_api:calc_point(PutItem, Career),
                            NewItems = lists:keyreplace(PutItem1#item.id, #item.id, Eqm, PutItem1),
                            PutItem2 = eqm_api:calc_all_enchant_add(PutItem1, NewItems),
                            {ok, NewEqmList, _} = storage_api:fresh_item(EqmItem, PutItem2, Eqm, ConnPid),
                            NR = NewRole#role{eqm = NewEqmList},
                            NR0 = role_api:push_attr(NR),
                            {ok, NR0}
                    end

              
            end
    end.



%% 装备属性重新计算
%% @spec re_calc_eqm(Item, BaseItem) -> 
re_calc_eqm(Item, BaseItem) ->
    case calc_enchant(Item, BaseItem) of %% 非武器类直接计算强化属性
        {ok, NewItem} -> NewItem; 
        {false, _Reason} -> Item
    end.

%% -----------------------------------------------------------
%% 强化调用计算
%% -----------------------------------------------------------

%% 尝试开孔
open_hole(Item = #item{attr = Attr}, HolePos) ->
    case lists:keyfind(HolePos, 1, Attr) of
        false -> 
            Item#item{attr = [{HolePos, 101, 0} | Attr]};
        {HolePos, 0, 0}-> 
            Attr1 = lists:keyreplace(HolePos, 1, Attr, {HolePos, 101, 0}),
            Item#item{attr = Attr1};
        _ -> Item
    end.

check_enchant_hole(Item = #item{base_id=BaseId, enchant = Enchant}) ->
    case lists:member(eqm:eqm_type(BaseId), ?blacksmith_hole) of
        true ->
            Flag1 = Enchant >= 5 andalso Enchant < 8, %% hole2
            Flag2 = Enchant >= 8 andalso Enchant < 11, %% hole2, hole3
            Flag3 = Enchant >= 11 andalso Enchant < 14, %% hole2, hole3, hole4
            Flag4 = Enchant >= 14,  %% hole2, hole3, hole4, hole5
            if
                Flag1 ->
                    open_hole(Item, ?attr_hole2);
                Flag2 ->
                    Item1 = open_hole(Item, ?attr_hole2),
                    open_hole(Item1, ?attr_hole3);
                Flag3 ->
                    Item1 = open_hole(Item, ?attr_hole2),
                    Item2 = open_hole(Item1, ?attr_hole3),
                    open_hole(Item2, ?attr_hole4);
                Flag4 ->
                    Item1 = open_hole(Item, ?attr_hole2),
                    Item2 = open_hole(Item1, ?attr_hole3),
                    Item3 = open_hole(Item2, ?attr_hole4),
                    open_hole(Item3, ?attr_hole5);
                true ->
                    Item
            end;
        false -> Item
    end.

%% @spec recalc_attr(Item) -> NewItem
%% @doc 重新计算强化的属性
recalc_attr(Item = #item{base_id = BaseId, enchant = Enchant}) ->
    case item_data:get(BaseId) of
        {ok, BaseItem} ->
            re_calc_eqm(Item#item{enchant = Enchant}, BaseItem);
        _ ->
            ?ELOG("未知装备BaseId:~w,无法计算属性",[BaseId]),
            Item
    end.

%% 计算装备强化之后的基础属性
calc_enchant(Item = #item{base_id = BaseId, enchant = Enchant,  attr = Eattr}, #item_base{attr = Attr}) ->
    Label = eqm_api:get_type_name(BaseId),
    AttrList = enchant_data:get_attr(Label, Enchant),
    AttrList1 = add_enchant_attr(Attr, AttrList),
    {ok, Item#item{attr = attr_replace(AttrList1, Eattr)}}.

add_enchant_attr(BaseAttr, []) -> BaseAttr;
add_enchant_attr(BaseAttr, [{Label, Val} | T]) ->
    case lists:keyfind(Label, 1, BaseAttr) of
        {Label, _, BaseVal} ->
            BaseAttr1 = lists:keyreplace(Label, 1, BaseAttr, {Label, 100, erlang:trunc(BaseVal + Val)}),
            add_enchant_attr(BaseAttr1, T);
        false ->
            ?DEBUG("无法找到基础属性，无法附加强化属性  ~w", [{Label, Val}]),
            add_enchant_attr(BaseAttr, T)
    end.

attr_replace([], Attr2) -> Attr2;
attr_replace([E = {Name, _F, _V} | T], Attr2) ->
    A = find_base_attr(Name, Attr2),
    Attr3 = [E | Attr2 -- [A]],
    attr_replace(T, Attr3).


find_base_attr(Name, Attr) ->
    L = [{N, Flag, Value} || {N, Flag, Value} <- Attr, N =:= Name, Flag =:= 100],
    case L of
        [] -> false;
        [List] -> List
    end.
replace_base_attr(Name, Attr, NewA) ->
    A = find_base_attr(Name, Attr),
    [NewA | (Attr -- [A])].

%% -----------------------------------------------------------
%% 打孔镶嵌摘除调用
%% -----------------------------------------------------------

%% @spec check_hole(Item, HolePos)
%% @doc 检查孔号是否可镶嵌
check_hole(#item{base_id = BaseId, attr = Attr}, HolePos) ->
    case lists:member(eqm:eqm_type(BaseId), ?blacksmith_hole) of
        true ->
            Ret = lists:keyfind(HolePos, 1, Attr),
            case Ret =:= false of
                true ->
                    {false, ?MSGID(<<"这装备没有此孔属性">>)};
                false ->
                    {_Label, Flag, Value} = Ret,
                    case Flag =:= 101 andalso Value =:= 0 of
                        true ->
                            {ok};
                        false ->
                            {false, ?MSGID(<<"此装备还没开孔或已镶了宝石">>)}
                    end
            end;
        false -> {false, ?MSGID(<<"该装备不能镶嵌">>)}
    end.

%% @spec check_xq(EqmItem, StoneItem) -> {ok, HoleNum} | {false, Reason}
%% @doc 镶嵌检测
check_xq(EqmItem, StoneItem, HolePos) ->
    case check_same_stone(normal, EqmItem, StoneItem) of
        {false, Reason} -> {false, Reason};
        true -> check_can_xq(normal, EqmItem, StoneItem, HolePos)
    end.

check_xq_special(EqmItem, StoneItem, HolePos) ->
    case check_same_stone(special, EqmItem, StoneItem) of
        {false, Reason} -> {false, Reason};
        true -> check_can_xq(special, EqmItem, StoneItem, HolePos)
    end.

%% @spec check_can_xq(EqmItem, XqItem) ->
%% @doc 镶嵌宝石限制
check_can_xq(normal, EqmItem = #item{base_id = EqmBaseId}, #item{base_id = StoneBaseId}, HolePos) ->
    case stone_data:type(StoneBaseId) of
        false -> {false, ?MSGID(<<"没有该宝石类型">>)};
        StoneType ->
            EqmTypeInlayTypes = stone_data:item_type_to_inlay_stone_type(default, eqm:eqm_type(EqmBaseId)),
            TypeChk = lists:member(StoneType, EqmTypeInlayTypes),
            case TypeChk of
                true ->    
                    check_hole(EqmItem, HolePos);
                false -> {false, ?MSGID(<<"您的镶嵌石不适用这个类型的装备">>)}
            end
    end;

check_can_xq(special, EqmItem = #item{base_id = EqmBaseId}, #item{base_id = StoneBaseId}, HolePos) ->
    case stone_data:type(StoneBaseId) of
        false -> {false, ?MSGID(<<"没有该宝石类型">>)};
        StoneType ->
            Res = check_hole(EqmItem, HolePos),
            case Res of
                {false, Reason} -> 
                    {false, Reason};
                {ok} ->
                    AbleInlayTypes = case HolePos of
                        8 ->
                            stone_data:item_type_to_inlay_stone_type(eight, eqm:eqm_type(EqmBaseId));
                        9 ->
                            stone_data:item_type_to_inlay_stone_type(ten, eqm:eqm_type(EqmBaseId))
                    end,
                    case lists:member(StoneType, AbleInlayTypes) of
                        true -> {ok};
                        false -> {false, ?MSGID(<<"该宝石不可镶嵌在这个孔上">>)}
                    end
            end %% end case Res of
    end. 

%% @spec check_same_stone(EqmItem, XqItem) -> {false, Reason} | true 
%% @doc 判断装备中是否已有该类宝石
check_same_stone(normal, #item{base_id = EqmBaseId, attr = Attr}, #item{base_id = BaseId}) ->
    case lists:member(eqm:eqm_type(EqmBaseId), ?blacksmith_hole) of
        true ->
            Ret1 = lists:keyfind(?attr_hole1, 1, Attr),
            ListCheck1 = case Ret1 =:= false of
                true -> [];
                _ -> {?attr_hole1, Flag1, Value1} = Ret1, [{Flag1, Value1}]
            end,
            
            Ret2 = lists:keyfind(?attr_hole2, 1, Attr),
            ListCheck2 = case Ret2 =:= false of
                true -> ListCheck1;
                false -> {?attr_hole2, Flag2, Value2} = Ret2, [{Flag2, Value2} | ListCheck1]
            end,

            Ret3 = lists:keyfind(?attr_hole3, 1, Attr),
            ListCheck3 = case Ret3 =:= false of
                true -> ListCheck2;
                false -> {?attr_hole3, Flag3, Value3} = Ret3, [{Flag3, Value3} | ListCheck2]
            end,

            do_check_same_stone(ListCheck3, BaseId);

        false -> {false, ?MSGID(<<"该装备不能镶嵌">>)}
    end;
check_same_stone(special, #item{base_id = EqmBaseId, attr = Attr}, #item{base_id = BaseId}) ->
    case lists:keyfind(?attr_hole4, 1, Attr) of
        false -> {false, ?MSGID(<<"不存在镶嵌孔, 无法镶嵌">>)};
        _ ->
            case lists:member(eqm:eqm_type(EqmBaseId), ?blacksmith_hole) of
                true ->
                    {_, Flag1, Value1} = lists:keyfind(?attr_hole4, 1, Attr),
                    List = case lists:keyfind(?attr_hole5, 1, Attr) of
                        false -> [{Flag1, Value1}];
                        {_, Flag2, Value2} -> [{Flag1, Value1}, {Flag2, Value2}]
                    end,
                    do_check_same_stone(List, BaseId);
                false -> {false, ?MSGID(<<"该装备不能镶嵌">>)}
            end
    end.

do_check_same_stone([], _BaseId) -> true;
do_check_same_stone([{Flag, Value} | T], BaseId) ->
    case Flag =:= 101 andalso Value =/= 0 of
        true ->
            case stone_data:type(BaseId) of
                false -> {false, ?L(<<"不存在的宝石类型">>)};
                TypeOne ->
                    case stone_data:type(Value) of
                        false -> {false, ?L(<<"不存在的宝石类型">>)};
                        TypeTwo when TypeOne =:= TypeTwo ->
                            {false, ?L(<<"同类型的镶嵌石只能镶嵌一个">>)};
                        _ ->
                            do_check_same_stone(T, BaseId)
                    end
            end;
        false -> do_check_same_stone(T, BaseId)
    end.

%% -----------------------------------------------------------
%%  装备洗练调用
%% -----------------------------------------------------------

%% @spec check_stone_polish(Item, StoneBaseId) -> true | false
%% @doc 判断洗练石是否满足条件
%%check_stone_polish(?quality_green, StoneBaseId) ->
%%    lists:member(StoneBaseId, polish_data:get_polish_stone(?quality_green));
%%check_stone_polish(?quality_blue, StoneBaseId) ->
%%    lists:member(StoneBaseId, polish_data:get_polish_stone(?quality_blue));
%%check_stone_polish(?quality_purple, StoneBaseId) ->
%%    lists:member(StoneBaseId, polish_data:get_polish_stone(?quality_purple));
%%check_stone_polish(?quality_orange, StoneBaseId) ->
%%    lists:member(StoneBaseId, polish_data:get_polish_stone(?quality_orange));
%%check_stone_polish(?quality_golden, StoneBaseId) ->
%%    lists:member(StoneBaseId, polish_data:get_polish_stone(?quality_golden));
%%check_stone_polish(_, _) -> false.

%%check_stone_polish(?quality_green) -> 27000;
%%check_stone_polish(?quality_blue) -> 27001;
%%check_stone_polish(?quality_purple) -> 27002;
%%check_stone_polish(?quality_orange) -> 27003;
%%check_stone_polish(?quality_golden) -> 27004;
%%check_stone_polish(_) -> false.

%%check_lock_num(EqmItem, LockList) ->
%%    TagList = get_polish_tag(EqmItem),
%%    check_lock_num(TagList, LockList, 0).

%%check_lock_num(_TagList, [], Num) -> Num;
%5check_lock_num(TagList, [{Tag, 1} | T], Num) ->
%%    case lists:keyfind(Tag, 1, TagList) of
%%        false ->
%%            check_lock_num(TagList, T, Num);
%%        _ ->
%%            check_lock_num(TagList, T, Num + 1)
%%    end;
%%check_lock_num(TagList, [{_Tag, 0} | T], Num) ->
%%    check_lock_num(TagList, T, Num).

%% 批量洗练
get_batch_polish(EqmWashCnt, WashCnt, WashConf, Career, Lev) ->
    get_batch_polish(EqmWashCnt, WashCnt, WashConf, Career, Lev, []).

get_batch_polish(EqmWashCnt, 0, _, _, _,PolishList) -> {ok, EqmWashCnt, PolishList};
get_batch_polish(EqmWashCnt, WashCnt, WashConf = {_, {{MinNum, MaxNum}, AttrList, {MinN, MaxN}, _,_}}, Career, Lev, PolishList) ->
    RandNum = get_wash_attr_cnt(MinNum, MaxNum),
    case get_random_attr(RandNum, AttrList) of
        {false, Reason2} -> {false, Reason2};
        {ok, GetAttr} ->
            MinN1 = case EqmWashCnt =:= 0 of
                true -> MinN;
                false ->
                    N25 = EqmWashCnt div 25,
                     case N25 >= MaxN of
                         true -> MaxN-1;
                         false-> case N25 =/= 0 of true -> N25; false -> MinN end
                     end
                end,
            ?DEBUG("wash_cnt:~p MinN1:~p  MaxN ~w", [EqmWashCnt, MinN1, MaxN]),
            N = {MinN, MinN1, MaxN},
            Attr = data_to_attr(GetAttr, N, Career, Lev), 
            get_batch_polish(EqmWashCnt + 1, WashCnt - 1, WashConf, Career, Lev, [{WashCnt, 0, Attr} | PolishList])
    end.

%% @spec get_random_attr(Item) -> {ok, GetAttr} | {false, Reason}
%% @doc 根据Item随机获取洗练属性
get_random_attr(RandNum, AttrList) ->
    AllRate = get_all_rate(AttrList),
    get_attr(AttrList, RandNum, AllRate, []).


%% @spec get_attr(AttrList, Num, MaxRate, GetAttr, LockAttr) -> {ok, GetAttr, LockAttr}
%% @doc 从AttrList随机取Num个,放入GetAttr里面
get_attr(_AttrList, 0, _MaxRate, GetAttr) -> {ok, GetAttr};
get_attr(AttrList, Num, MaxRate, GetAttr) ->
    SeedRate = util:rand(1, MaxRate),
    case do_get_attr(AttrList, SeedRate, MaxRate) of
        {false, Reason} -> {false, Reason};
        {NewAttrList, Get, NewMaxRate} ->
            get_attr(NewAttrList, Num - 1, NewMaxRate, [Get | GetAttr])
    end.

%%  获取配置中所有权重之和
get_all_rate(AttrList) ->
    do_get_all_rate(AttrList, 0).

do_get_all_rate([], AllRate) -> AllRate;
do_get_all_rate([{_, _, Rate} | T], AllRate) ->
    do_get_all_rate(T, AllRate + Rate).



%% @spec do_get_attr(AttrList, Seed) -> {false, Reason} | {NewAttrList, Get, NewRate}
%% @doc 按照seed取出对应的Attr
do_get_attr(AttrList, Seed, MaxRate) ->
    do_get_attr(AttrList, Seed, [], 0, MaxRate).

do_get_attr([], _Seed, _BackList, _Range, _MaxRate) -> {false, ?MSGID(<<"无法取得属性">>)};
do_get_attr([Attr = {_Name, Type, Rate} | T], Seed, BackList, Range, MaxRate) ->
    case Seed =< (Rate + Range) of %% 判断区间掉落
        true -> %% 取到属性
            case Type =:= 1 of %% 判断取到的是否是可重复
                true -> {[Attr | T] ++ BackList, Attr, MaxRate}; %% 取到可重复的，全部保留
                false -> {T ++ BackList, Attr, MaxRate - Rate} %% 取到不可重复的，剔除掉，相应的权重也要减掉
            end;
        false -> %% 没有掉落,取下一个
            do_get_attr(T, Seed, [Attr | BackList], Range + Rate, MaxRate)
    end.

%% @spec data_to_attr(GetAttr) -> Attr
%% @doc 把取得的数据转换为实际的属性
data_to_attr(GetAttr, N, Career, Lev) ->
    data_to_attr(GetAttr, N, Career, Lev, []).
data_to_attr([], _N, _Career, _Lev, Attr) -> Attr;
data_to_attr([{Name, _Type, _Rate} | T], N = {OrigMinN, MinN, MaxN}, Career, Lev, Attr) ->
    case Name =:= ?attr_skill_lev of
        false ->
            X = getX(Name),
            MinV = OrigMinN * X,
            MaxV = MaxN * X,
            MinV1 = case MinV > MaxV of true -> MaxV; false -> MinV end, %% 暂时作保护
            %% Val = erlang:abs(gaussrand_mgr:get_value(MinV1, MaxV)),
            %% Val = gen_wash_gauss(MinV1, MaxV, 10),
            _RandN = count_n(MinN, MaxN),
            ?DEBUG("  随机到N值为  ~w", [_RandN]),
            Val = count_n(MinN, MaxN) * X,
            ?INFO(" ------------->>> 装备鉴定值 :~p", [Val]),
            Star = util:floor((Val - MinV1 +1) / (MaxV - MinV1 + 1) * 10)+1,
            NewStar = case Star >= 10 of true -> 10; false -> Star end,
            EquipCraft = get_equip_craft(Lev),
            ?INFO("装备鉴定阶数~p 星级为:~p~n", [EquipCraft, NewStar]),
            AttrVal = util:floor(Val * get_career_ratio(Career, Name)),
            data_to_attr(T, N, Career, Lev, [{Name, NewStar * 1000 + EquipCraft, AttrVal} | Attr]);
        true ->
            Star = 10,
            data_to_attr(T, N, Career, Lev, [{Name, Star * 1000, 1000} | Attr])
    end.

%gen_wash_gauss(_MinV, _MaxV, 0) ->
%    ?ERR("***** 洗炼出0属性 MaxV: ~w, MinV: ~w", [_MaxV, _MinV]),
%    1;  %% 默认值
%gen_wash_gauss(MinV, MaxV, Times) ->
%    Val = erlang:abs(gaussrand_mgr:get_value(MinV, MaxV)),
%    case Val =/= 0 of
%        true ->
%            Val;
%        false ->
%            gen_wash_gauss(MaxV, MinV, Times-1)
%    end.

%% 计算N值
count_n(MinN, MaxN) ->
    ConfRate = get_range_n(MinN, MaxN),
    SumRate = lists:foldl(fun({_Idx,V}, Acc) -> Acc+V end, 0, ConfRate),
    RandNum = util:rand(1, SumRate),
    select_n(ConfRate, RandNum, 0, MinN).

select_n([], _RandNum, _AccRate, MinN) -> MinN;
select_n([{Idx, Rate} | T], RandNum, AccRate, MinN)  ->
    case RandNum =< Rate + AccRate of
        true ->
            Idx + MinN - 1;
        false ->
            select_n(T, RandNum, Rate + AccRate, MinN)
    end.

%% 获取范围内所有N值
%% -> [{idx, V}]
get_range_n(MinN, MaxN) ->
    Num = MaxN - MinN + 1,
    do_get_range_n(1, Num, []).

do_get_range_n(End, End, Res) -> Res;
do_get_range_n(Beg, End, Res) ->
    V = equip_wash_data:get_rate(Beg),
    do_get_range_n(Beg+1, End, [{Beg, V} | Res]).
    

%% 获取装备阶数
get_equip_craft(EquipLvl) when EquipLvl >= 1 andalso EquipLvl =< 19 -> 1;
get_equip_craft(EquipLvl) -> EquipLvl div 10.


%% X值
getX(?attr_dmg) -> 5;
getX(?attr_critrate) -> 3;
getX(?attr_hp_max) -> 28;
getX(?attr_defence) -> 28;
getX(?attr_js) -> 7;
getX(?attr_rst_all) -> 6;
getX(?attr_hitrate) -> 1;
getX(?attr_evasion) -> 1;
getX(?attr_tenacity) -> 3;
getX(?attr_dmg_magic) -> 3;
getX(_I) -> 0.

%% 职业系数
get_career_ratio(?career_cike, ?attr_dmg) -> 1.1;
get_career_ratio(?career_cike, ?attr_critrate) -> 1.1;
get_career_ratio(?career_cike, ?attr_hitrate) -> 1.1;
get_career_ratio(?career_xianzhe, ?attr_hp_max) -> 1.2;
get_career_ratio(?career_xianzhe, ?attr_tenacity) -> 1.2;
get_career_ratio(?career_qishi,?attr_defence) -> 1.3;
get_career_ratio(?career_qishi, ?attr_rst_all) -> 1.2;
get_career_ratio(?career_qishi, ?attr_hp_max) -> 1.1;
get_career_ratio(?career_qishi, ?attr_evasion) -> 1.1;
get_career_ratio(_Career, _AttrType) -> 1.



broad_polish(#role{}, []) ->
    skip;
broad_polish(Role = #role{}, [{_AttrName, Flag, _} | T]) ->
    case (Flag div 1000) >= 10 of %% 十星以上广播
        true ->
            RoleInfo = notice:get_role_msg(Role),
            role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"伟大的冒险家~s在铁匠铺鉴定获得了十星属性，真是好运气啊">>),[RoleInfo])});
        false ->
            broad_polish(Role, T)
    end.

broad_combine(Role = #role{}, BaseId, _Num) ->
    case combine_data:need_notify(BaseId) of
        true ->
            RoleInfo = notice:get_role_msg(Role),
            ItemMsg = notice:item_msg({BaseId, 1, 1}),
            %% {ok, #item_base{name = ItemName}} = item_data:get(BaseId),
            role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"伟大的冒险家~s在铁匠铺合成了~s，瞬间高富帅">>),[RoleInfo, ItemMsg])});
        false ->
            skip
    end.

broad_refine(Role = #role{}, BaseId) ->
    {ok, #item_base{quality = Quality}} = item_data:get(BaseId),
    case Quality >= ?quality_orange of
        true ->
            RoleInfo = notice:get_role_msg(Role),
            ItemMsg = notice:item_msg({BaseId, 1, 1}),
            role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"伟大的冒险家~s在铁匠铺打造了~s，实在让人羡慕">>),[RoleInfo, ItemMsg])});
        false ->
            skip
    end.


%% @spec get_fuse_list(Id, Type) -> {false, Reason} | [{Id, Num} | ..]
%% @doc 获取物品ID的Type合成列表
get_fuse_list(Id, Type) ->
    case combine_data:get(Id, Type) of
        [] -> {false, ?L(<<"这物品不能合成">>)};
        List -> List
    end.

%% @spec check_fuse(Bag, List, Coin) -> {false, Reason} | {true, NewRole}
%% @doc 合成材料,并删除, 成功即生成,失败则无新物品,带刷新客户端
check_fuse(Role, List, StoneId, Coin, Suc, Num, 1) ->
    DelList = [{Id, N * Num} || {Id, N} <- List],
    case storage:get_del_base_bindlist(Role, DelList, [], []) of
        {false, _Reason} -> {false, ?L(<<"材料不足,无法合成">>)};
        {ok, Del, BindInfo} ->
            BindNum = get_bind_num(List, BindInfo),
            case role_gain:do([#loss{label = coin_all, val = Coin * Num, msg = ?L(<<"金币不足">>)},
                        #loss{label = item_id, val = Del, msg = ?L(<<"材料不足,无法合成">>)}], Role) of
                {false, L = #loss{label = coin_all}} -> {?coin_less, L#loss.msg};
                {false, L} -> {false, L#loss.msg};
                {ok, NewRole} ->
                    SucBindNum = get_rand(BindNum, Suc * 10),
                    SucUbinNum = get_rand(Num - BindNum, Suc * 10),
                    add_fuse_item(SucBindNum, SucUbinNum, NewRole, StoneId)
            end
    end;

check_fuse(Role, List, StoneId, Coin, Suc, Num, 0) ->
    DelList = [{Id, N * Num} || {Id, N} <- List],
    case storage:get_del_base_ubindlist(Role, DelList, [], []) of
        {false, _Reason} -> {false, ?L(<<"材料不足,无法合成">>)};
        {ok, Del, BindInfo} ->
            BindNum = get_bind_num(List, BindInfo),
            case role_gain:do([#loss{label = coin_all, val = Coin * Num, msg = ?L(<<"金币不足">>)},
                        #loss{label = item_id, val = Del, msg = ?L(<<"材料不足,无法合成">>)}], Role) of
                {false, L = #loss{label = coin_all}} -> {?coin_less, L#loss.msg};
                {false, L} -> {false, L#loss.msg};
                {ok, NewRole} ->
                    SucBindNum = get_rand(BindNum, Suc * 10),
                    SucUbinNum = get_rand(Num - BindNum, Suc * 10),
                    add_fuse_item(SucBindNum, SucUbinNum, NewRole, StoneId)
            end
    end.

add_fuse_item(0, 0, Role, _) -> {fail, Role};
add_fuse_item(SucBindNum, 0, Role, StoneId) ->
    case role_gain:do([#gain{label = item, val = [StoneId, 1, SucBindNum]}], Role) of
        {ok, NewRole} -> 
            {ok, NewRole, SucBindNum};
        {false, _G} -> {false, ?L(<<"背包已满,无法炼制">>)}
    end;
add_fuse_item(0, SucUbinNum, Role, StoneId) ->
    case role_gain:do([#gain{label = item, val = [StoneId, 0, SucUbinNum]}], Role) of
        {ok, NewRole} -> {ok, NewRole, SucUbinNum};
        {false, _G} -> {false, ?L(<<"背包已满,无法炼制">>)}
    end;
add_fuse_item(SucBindNum, SucUbinNum, Role, StoneId) ->
    case role_gain:do([#gain{label = item, val = [StoneId, 0, SucUbinNum]},
                #gain{label = item, val = [StoneId, 1, SucBindNum]}], Role) of
        {ok, NewRole} -> {ok, NewRole, SucBindNum + SucUbinNum};
        {false, _G} -> {false, ?L(<<"背包已满,无法炼制">>)}
    end.

get_rand(Num, SucRate) ->
    get_rand(Num, SucRate, 0).
get_rand(0, _SucRate, SucNum) -> SucNum;
get_rand(Num, SucRate, SucNum) ->
    SeedRate = util:rand(1, 1000),
    case SeedRate >= 1 andalso SeedRate =< SucRate of
        true -> get_rand(Num - 1, SucRate, SucNum + 1);
        false -> get_rand(Num - 1, SucRate, SucNum)
    end.

get_bind_num(List, BindInfo) ->
    get_bind_num(List, BindInfo, 0).
get_bind_num([], _BindInfo, Num) -> Num;
get_bind_num([{BaseId, Q} | T], BindInfo, Num) ->
    {BaseId, Bind} = lists:keyfind(BaseId, 1, BindInfo),
    BindNum = util:ceil(Bind / Q),
    case BindNum > Num of
        true -> get_bind_num(T, BindInfo, BindNum);
        false -> get_bind_num(T, BindInfo, Num)
    end.


check_can_refining(#role{lev = Lev}, #item{base_id = BaseID}) ->
    case equip_refine_data:get(BaseID) of
        false -> {false, ?L(<<"找不到配置">>)};
        {NextId, NeedList, NeedLvl, Coin} ->
            case Lev >= NeedLvl of
                true -> {true, NextId, NeedList, NeedLvl, Coin};
                false -> {false, ?L(<<"等级不足">>)}
            end
    end.


check_items([]) -> true;
check_items([#item{attr = Attr} | T]) ->
    List = [{Name, Flag, Value} || {Name, Flag, Value} <- Attr, Flag =:= 101 andalso Value =/= 0],
    case List =:= [] of
        true -> check_items(T);
        false -> false
    end.


%% 保留精炼 升级前物品的属性
swap_attr(#item{id = Id, pos = Pos, enchant = Enchant, upgrade = Upgrade, attr = Attr, craft = Craft}, NewItem = #item{attr = Attr2}) ->
    FunAttr = fun({A, F, _V}) ->
            if
                F >= 1001 andalso F =< 10010 -> %% 保留洗练
                    true;
                A >= ?attr_hole1 andalso A =< ?attr_hole5 -> %% 保留镶嵌
                    true;
                true ->
                    false
            end
    end,
    OldAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- Attr, FunAttr({Name, Flag, Value})],

    Holes = [?attr_hole1, ?attr_hole2, ?attr_hole3, ?attr_hole4, ?attr_hole5],
    Attr3 = [Attr_Elem || Attr_Elem = {Name, _F, _V} <- Attr2, lists:member(Name, Holes) =:= false], %% 去掉新装备的孔及宝石信息，用旧装备上的就好
    recalc_attr(NewItem#item{id = Id, pos = Pos, enchant = Enchant, upgrade = Upgrade, attr = Attr3 ++ OldAttr, craft = Craft}).

lvlup_equip(Role = #role{eqm = EqmList, career = Career, link = #link{conn_pid=ConnPid}}, SrcEquip = #item{base_id = BaseId, enchant = Enchant, require_lev=Lev}, IsUse) ->
    case equip_lvlup_data:get(BaseId) of
        {ok, {DstEquip, Material, M, Coin}} ->
            M1 =
            case IsUse =/= 0 of
                true ->
                    M;
                false ->
                    []
            end,
            case role_gain:do(
                        [
                        #loss{label = itemsall, val = Material, msg = ?L(<<"材料不足">>)},
                        #loss{label = itemsall, val = M1, msg = ?L(<<"护纹不足">>)},
                        #loss{label = coin, val = Coin, msg = ?L(<<"金币不足">>)}], Role) of
                {ok, NewRole} ->
                    NewEnchant =
                    case IsUse =/= 0 of
                        true -> Enchant;
                        false ->
                            case Lev >= 40  andalso Enchant > 0 of true-> Enchant-1; false -> Enchant end
                    end,

                    case item:make(DstEquip, 1, 1) of
                        false -> {ok};
                        {ok, [RefItem]} ->
                            NewItem = blacksmith:swap_attr(SrcEquip, RefItem),
                            NewItem1 = item:open_hole(NewItem), %% 升级开孔
                            {ok, #item_base{condition = Cond}} = item_data:get(NewItem1#item.base_id),
                            PutItem = case role_cond:check(Cond, Role) of
                                {false, _} -> NewItem1;
                                true -> NewItem1
                            end,
                            PutItem1 = eqm_api:calc_point(PutItem#item{enchant = NewEnchant}, Career),
                            NewItems = lists:keyreplace(PutItem1#item.id, #item.id, EqmList, PutItem1),
                            PutItem2 = eqm_api:calc_all_enchant_add(PutItem1, NewItems),
                            {ok, NewEqmList, _} = storage_api:fresh_item(SrcEquip, PutItem2, EqmList, ConnPid),
                            %% ?DEBUG("**********  新装备: ~w", [PutItem1]),
                            NR = NewRole#role{eqm = NewEqmList},
                            NR0 = role_api:push_attr(NR),
                            {ok, NR0, PutItem2}
                    end;
                {false, #loss{msg = Msg}} -> 
                    {false, Msg}
            end;
        false ->
            {false, <<"此装备不能升级">>}
    end.

lvlup_stone(Role = #role{career = Career, eqm = EqmList, link = #link{conn_pid=ConnPid}}, EqmItem = #item{attr = Attr}, HolePos) ->
    case lists:keyfind(HolePos, 1, Attr) of
        false ->
            {false, ?L(<<"这装备没有此孔属性">>)};
        {Label, Flag, Value} ->
            case Flag =:= 101 andalso Value =/= 0 of
                false ->
                    {false, ?L(<<"">>)};
                true ->
                    case combine_data:stone_lvlup_conf(Value) of
                        {DstStone, Coin, M} ->
                            case role_gain:do([#loss{label = coin_all, val = Coin, msg = ?L(<<"金币不足">>)}, 
                                        %%#loss{label = item, val = [Value, 0, 3], msg = ?L(<<"宝石不足">>)},
                                        #loss{label = itemsall, val = M, msg = ?L(<<"材料不足">>)}], Role) of
                                {ok, Role1} ->
                                    Attr1 = lists:keyreplace(HolePos, 1, Attr, {Label, Flag, DstStone}),
                                    NewItem = recalc_attr(EqmItem#item{attr = Attr1}),
                                    NewItem1 = eqm_api:calc_point(NewItem, Career),
                                    NewItems = lists:keyreplace(NewItem1#item.id, #item.id, EqmList, NewItem1),
                                    NewItem2 = eqm_api:calc_all_enchant_add(NewItem1, NewItems),
                                    {ok, NewEqmList, _} = storage_api:fresh_item(EqmItem, NewItem2, EqmList, ConnPid),
                                    Role2 = Role1#role{eqm = NewEqmList},
                                    Role3 = role_api:push_attr(Role2),
                                    rank_celebrity:bs_suit(Role3),
                                    blacksmith:broad_combine(Role3, DstStone, 1),
                                    {ok, DstStone, Role3};
                                {false, #loss{msg = Msg}} ->
                                    {false, Msg}
                            end;
                        false ->
                            {false, ?L(<<"宝石不能升级">>)}
                    end
            end
    end.

%% 获取洗炼可以洗出的属性条数
get_wash_attr_cnt(MinNum, MaxNum) ->
    util:rand(MinNum, MaxNum).

%%  测试
%% 批量洗练
gm_batch_polish(#role{career = Career}, #item{require_lev = Lev, base_id = BaseId, wash_cnt = EqmWashCnt}, WashCnt) ->
    case equip_wash_data:get(BaseId) of
        false -> {false, ?MSGID(<<"此装备不能洗炼">>)};
        WashConf = {ok, {_, _, _, _StoneNum, _Coin}} ->
            case get_batch_polish(EqmWashCnt, WashCnt, WashConf, Career, Lev) of
                {false, Reason} -> {false, Reason};
                {ok, _NewEqmWashCnt, Polish} ->
                    case check_wash(Polish) of
                        true -> ?DEBUG(" ------>> 洗炼正常 ...");
                        false -> ?DEBUG(" big error occur ...  ")
                    end
            end
    end.

check_wash([]) -> true;
check_wash([{_,_,Attr} | T]) ->
    case check_wash_attr(Attr) of
        true -> check_wash(T);
        false ->
            false
    end.

check_wash_attr([]) ->
    true;
check_wash_attr([{_N, _F, V} | T]) ->
    case V =< 0 orelse V >= 10000 of
        true ->
            ?DEBUG("$$$$$$$$$$$$$$  异常的洗炼属性  N:~p F:~p V:~p", [_N, _F, V]),
            false;
        false ->
            check_wash_attr(T)       
    end.
    

