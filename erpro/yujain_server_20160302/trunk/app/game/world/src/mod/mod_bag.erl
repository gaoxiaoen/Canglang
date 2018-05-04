%% Author: Ansty
%% Created: 2013-5-21
%% Description: 玩家背包模块
-module(mod_bag).

-include("mgeew.hrl").

-export([
         get_dirty_role_bag/2,
         get_dirty_role_bag_basic/1,
         
         get_role_bag/2,
         set_role_bag/3,
         
         get_role_bag_basic/1,
         set_role_bag_basic/2,
         
         dump_role_bag_info/1,
         init_role_bag_info/1,
         t_new_role_bag_info/1
        ]).

-export([
		 get_bag_empty_pos_number/2,
		 
         get_goods_num_by_type_id/3,
         
         is_in_bag_by_id/2,
         is_in_bag_by_id/3,
         
         is_in_bag_by_pos/2,
         is_in_bag_by_pos/3,
         
         is_in_bag_by_type_id/2,
         is_in_bag_by_type_id/3,
         
         t_create_goods/2,
         t_create_goods/3,
         
         t_create_goods_by_p_goods/2,
         t_create_goods_by_p_goods/3,
         
         t_update_goods/2,
         t_update_goods/3,
         
         t_delete_goods/2,
         t_delete_goods/3,
         
         deduct_goods/3,
         
         t_deduct_goods/3,
         t_deduct_goods/4,
         
         t_deduct_goods_by_goodslist/3,
         t_deduct_goods_by_goodslist/4,
         
         t_deduct_goods_by_type_id/3,
         t_deduct_goods_by_type_id/4,
         
         t_tidy_bag/2
         
        ]).

%% 玩家上线初始化背包
init_role_bag_info(RoleId) ->
    case db_api:dirty_read(?DB_ROLE_BAG_BASIC, RoleId) of
        [] ->
            erlang:throw({bag_error, no_bag_basic_data});
        [#r_role_bag_basic{bag_id_list=BagIdList,max_goods_id = MaxGoodsId}=RoleBagBasic] ->
            init_role_bag_basic(RoleId, RoleBagBasic),
            lists:foreach(
              fun(BagId) ->
                      case db_api:dirty_read(?DB_ROLE_BAG, {RoleId, BagId}) of
                          [RoleBag] ->
                              next;
                          _ ->
                              [InitBagGrid] = common_config_dyn:find(role_bag, init_bag_grid),
                              RoleBag = #r_role_bag{role_bag_key = {RoleId,BagId},grid_number = InitBagGrid,bag_goods  = []}
                      end,
                      init_role_bag(RoleId,BagId,RoleBag)
              end,BagIdList),
            init_max_goods_id(RoleId,MaxGoodsId)
    end.
%% 初始化玩家的背包信息
t_new_role_bag_info(RoleId) ->
    [InitBagIdList] = common_config_dyn:find(role_bag, init_bag_id_list),
    [InitBagGrid] = common_config_dyn:find(role_bag, init_bag_grid),
    RoleBagBasicInfo = #r_role_bag_basic{role_id=RoleId,bag_id_list=InitBagIdList,max_goods_id = 0},
    db_api:write(?DB_ROLE_BAG_BASIC, RoleBagBasicInfo, write),
    [begin
         RoleBagInfo = #r_role_bag{role_bag_key = {RoleId,BagId},
                                   grid_number = InitBagGrid,
                                   bag_goods = [] },
         db_api:write(?DB_ROLE_BAG, RoleBagInfo, write)
     end || BagId<- InitBagIdList].

%% 获得背包的最大道具id
init_max_goods_id(RoleId,MaxId) ->
    erlang:put({max_goods_id,RoleId}, MaxId).
get_max_goods_id(RoleId) ->
    case erlang:get({max_goods_id,RoleId}) of
        undefined ->
            {error, max_goods_id_not_found};
        MaxGoodsId ->
            {ok,MaxGoodsId}
    end.
set_max_goods_id(RoleId,MaxId) ->
    common_transaction:set_transaction({max_goods_id,RoleId}),
    erlang:put({max_goods_id,RoleId}, MaxId).

get_dirty_role_bag(RoleId,BagId) ->
    case db_api:dirty_read(?DB_ROLE_BAG, {RoleId,BagId}) of
        [RoleBag] ->
            {ok, RoleBag};
        _ ->
            {error, not_found}
    end.
get_dirty_role_bag_basic(RoleId) ->
    case db_api:dirty_read(?DB_ROLE_BAG_BASIC, RoleId) of
        [RoleBagBasicInfo] ->
            {ok, RoleBagBasicInfo};
        _ ->
            {error, not_found}
    end.
%% 玩家背包信息
init_role_bag(RoleId,BagId,RoleBag) ->
    erlang:put({?DB_ROLE_BAG,RoleId,BagId}, RoleBag).
get_role_bag(RoleId,BagId) ->
    case erlang:get({?DB_ROLE_BAG,RoleId,BagId}) of
        undefined ->
            {error, role_bag_not_found};
        RoleBag ->
            {ok, RoleBag}
    end.
set_role_bag(RoleId,BagId,RoleBag) ->
    common_transaction:set_transaction({?DB_ROLE_BAG,RoleId,BagId}),
    erlang:put({?DB_ROLE_BAG,RoleId,BagId}, RoleBag).
dump_role_bag(RoleId,BagId) ->
    case get_role_bag(RoleId,BagId) of
        {ok,RoleBag} ->
            db_api:dirty_write(?DB_ROLE_BAG, RoleBag);
        _ ->
            next
    end.

%% @return {ok, r_role_bag_basic}
init_role_bag_basic(RoleId,RoleBagBasic) ->
    erlang:put({?DB_ROLE_BAG_BASIC,RoleId}, RoleBagBasic).
get_role_bag_basic(RoleId) ->
    case erlang:get({?DB_ROLE_BAG_BASIC,RoleId}) of
        undefined ->
            {error, role_bag_basic_not_found};
        RoleBagBasic ->
            {ok, RoleBagBasic}
    end.
set_role_bag_basic(RoleId,RoleBagBasic) ->
    common_transaction:set_transaction({?DB_ROLE_BAG_BASIC,RoleId}),
    erlang:put({?DB_ROLE_BAG_BASIC,RoleId}, RoleBagBasic).

dump_role_bag_info(RoleId) ->
    case get_role_bag_basic(RoleId) of
        {ok,RoleBagBasic} ->
            {ok,MaxGoodsId} = get_max_goods_id(RoleId),
            [begin dump_role_bag(RoleId,BagId) end || BagId <- RoleBagBasic#r_role_bag_basic.bag_id_list],
            db_api:dirty_write(?DB_ROLE_BAG_BASIC, RoleBagBasic#r_role_bag_basic{max_goods_id = MaxGoodsId});
        _ ->
            next
    end.

%% 获取当前背包空格子数
get_bag_empty_pos_number(RoleId,BagId) ->
	case get_role_bag(RoleId, BagId) of
		{ok,#r_role_bag{grid_number=GridNumber,bag_goods=BagGoodsList}} ->
			GridNumber - erlang:length(BagGoodsList);
		_ ->
			0
	end.
			

%% 查询道具数量
%% 返回 {ok,Number}
get_goods_num_by_type_id(RoleId,BagIdList,TypeId) ->
    TotalNumber = 
        lists:foldl(
          fun(BagId,AccTotalNumber) ->
                  case get_role_bag(RoleId, BagId) of
                      {ok,RoleBag} ->
                          PAccTotalNumber = 
                              lists:foldl(
                                fun(#p_goods{type_id = PTypeId,number = PNumber},Acc) -> 
                                        case PTypeId =:= TypeId of
                                            true ->
                                                Acc + PNumber;
                                            _ ->
                                                Acc
                                        end
                                end, 0, RoleBag#r_role_bag.bag_goods),
                          AccTotalNumber + PAccTotalNumber;
                      _ ->
                          AccTotalNumber
                  end
          end, 0, BagIdList),
    {ok,TotalNumber}.


%% 判断物品是否存在
%% 成功返回 {ok,Goods} or {error,Reason}
is_in_bag_by_id(RoleId,GoodsId) ->
    case get_role_bag_basic(RoleId) of
        {ok,#r_role_bag_basic{bag_id_list = BagIdList}} ->
            is_in_bag_by_id(RoleId,BagIdList,GoodsId);
        _ ->
            {error,bag_basic_not_found}
    end.
is_in_bag_by_id(RoleId,BagId,GoodsId) when erlang:is_integer(BagId) ->
    is_in_bag_by_id(RoleId,[BagId],GoodsId);
is_in_bag_by_id(RoleId,BagIdList,GoodsId) ->
    is_in_bag_by_id2(RoleId,BagIdList,GoodsId,false,{error,not_found}).

is_in_bag_by_id2(_RoleId,[],_GoodsId,_Flag,Result) ->
    Result;
is_in_bag_by_id2(_RoleId,_BagIdList,_GoodsId,true,Result) ->
    Result;
is_in_bag_by_id2(RoleId,[BagId|BagIdList],GoodsId,Flag,Result) ->
    case get_role_bag(RoleId, BagId) of
        {ok,#r_role_bag{bag_goods = BagGoods}} ->
            case lists:keyfind(GoodsId, #p_goods.id, BagGoods) of
                false ->
                    NewFlag = Flag,
                    NewResult = Result;
                Goods ->
                    NewFlag = true,
                    NewResult = {ok,Goods}
            end;
        _ ->
            NewFlag = Flag,
            NewResult = Result
    end,
    is_in_bag_by_id2(RoleId,BagIdList,GoodsId,NewFlag,NewResult).

%% 判断背包位置是否有物品
is_in_bag_by_pos(RoleId,Pos) ->
    is_in_bag_by_pos(RoleId,[?MAIN_BAG_ID],Pos).

is_in_bag_by_pos(RoleId,BagId,Pos) when erlang:is_integer(BagId) ->
    is_in_bag_by_pos(RoleId,[BagId],Pos);
is_in_bag_by_pos(RoleId,BagIdList,Pos) ->
    is_in_bag_by_pos2(RoleId,BagIdList,Pos,false,{error,not_found}).

is_in_bag_by_pos2(_RoleId,[],_Pos,_Flag,Result) ->
    Result;
is_in_bag_by_pos2(_RoleId,_BagIdList,_Pos,true,Result) ->
    Result;
is_in_bag_by_pos2(RoleId,[BagId|BagIdList],Pos,Flag,Result) ->
    case get_role_bag(RoleId, BagId) of
        {ok,#r_role_bag{bag_goods = BagGoods}} ->
            case lists:keyfind(Pos, #p_goods.bag_position, BagGoods) of
                false ->
                    NewFlag = Flag,
                    NewResult = Result;
                Goods ->
                    NewFlag = true,
                    NewResult = {ok,Goods}
            end;
        _ ->
            NewFlag = Flag,
            NewResult = Result
    end,
    is_in_bag_by_pos2(RoleId,BagIdList,Pos,NewFlag,NewResult).


%% 判断物品是否存在
%% {error,not_found} or {ok,GoodsList}
is_in_bag_by_type_id(RoleId,TypeId) ->
    case get_role_bag_basic(RoleId) of
        {ok,#r_role_bag_basic{bag_id_list = BagIdList}} ->
            is_in_bag_by_type_id(RoleId,BagIdList,TypeId);
        _ ->
            {error,bag_basic_not_found}
    end.
is_in_bag_by_type_id(RoleId,BagId,TypeId) when erlang:is_integer(BagId) ->
    is_in_bag_by_type_id(RoleId,[BagId],TypeId);
is_in_bag_by_type_id(RoleId,BagIdList,TypeId) ->
    case is_in_bag_by_type_id2(RoleId,BagIdList,TypeId,[]) of
        [] ->
            {error,not_found};
        GoodsList ->
            {ok,GoodsList}
    end.

is_in_bag_by_type_id2(_RoleId,[],_TypeId,GoodsList) ->
    GoodsList;
is_in_bag_by_type_id2(RoleId,[BagId|BagIdList],TypeId,GoodsList) ->
    case get_role_bag(RoleId, BagId) of
        {ok,#r_role_bag{bag_goods = BagGoodsList}} ->
            NewGoodsList = is_in_bag_by_type_id3(BagGoodsList,TypeId,GoodsList);
        _ ->
            NewGoodsList = GoodsList
    end,
    is_in_bag_by_type_id2(RoleId,BagIdList,TypeId,NewGoodsList).
is_in_bag_by_type_id3([],_TypeId,GoodsList) ->
    GoodsList;
is_in_bag_by_type_id3([Goods|BagGoodsList],TypeId,GoodsList) ->
    case Goods#p_goods.type_id =:= TypeId of
        true ->
            is_in_bag_by_type_id3(BagGoodsList,TypeId,[Goods|GoodsList]);
        _ ->
            is_in_bag_by_type_id3(BagGoodsList,TypeId,GoodsList)
    end.

%% 背包基本操作接口
%% 创建物品，删除物品 ，更新物品等

%% 创建物品
%% 返回 {ok,GoodsList,LogGoodsList} or {bag_error,Reason}
t_create_goods(RoleId,CreateInfo) ->
    t_create_goods(RoleId,?MAIN_BAG_ID,CreateInfo).
    
t_create_goods(RoleId,BagId,CreateInfo) ->
    {ok,GoodsList} = common_goods:create_goods(CreateInfo),
    t_create_goods_by_p_goods(RoleId,BagId,GoodsList).

t_create_goods_by_p_goods(RoleId,Goods) when erlang:is_record(Goods, p_goods) ->
    t_create_goods_by_p_goods(RoleId,[Goods]);
t_create_goods_by_p_goods(RoleId,GoodsList) ->
    t_create_goods_by_p_goods(RoleId,?MAIN_BAG_ID,GoodsList).

t_create_goods_by_p_goods(RoleId,BagId,GoodsList) ->
    case get_role_bag(RoleId, BagId) of
        {ok,#r_role_bag{bag_goods = BagGoodsList} = RoleBag} ->
            next;
        _ ->
            BagGoodsList = [],RoleBag = undefined,
            erlang:throw({bag_error,bag_info_not_found})
    end,
    %% 自动合并道具
    {NewGoodsList,UpdateGoodsList,NewBagGoodsList} = atmoic_merge(atmoic_merge_new(GoodsList,[]),BagGoodsList,[],[]),
    NewRoleBag = RoleBag#r_role_bag{bag_goods = NewBagGoodsList},
    {ok,PosList} = get_empty_bag_pos(RoleBag,erlang:length(NewGoodsList)),
    {ok,MaxGoodsId} = get_max_goods_id(RoleId),
    {NewGoodsList2,NewMaxGoodsId,_} = 
        lists:foldl(
          fun(PNewGoods,{AccNewGoodsList,AccMaxGoodsId,[PosPosition|AccPosList]}) -> 
                  NewGoods = PNewGoods#p_goods{
                                               id = AccMaxGoodsId + 1,
                                               target_id = RoleId,
                                               bag_id = BagId, 
                                               bag_position = PosPosition
                                              },
                  {[NewGoods|AccNewGoodsList],AccMaxGoodsId + 1,AccPosList}
          end, {[],MaxGoodsId,PosList}, NewGoodsList),
    NewBagGoodsList2 = NewGoodsList2 ++ NewBagGoodsList,
    NewRoleBag2 = NewRoleBag#r_role_bag{bag_goods = NewBagGoodsList2},
    set_role_bag(RoleId, BagId, NewRoleBag2),
    set_max_goods_id(RoleId, NewMaxGoodsId),
    {ok,NewGoodsList2 ++ UpdateGoodsList,GoodsList}.
%% 更新背包道具
%% 返回{ok,OldGoodsList} or {bag_error,Reason}
t_update_goods(RoleId,Goods) when erlang:is_record(Goods, p_goods) ->
    t_update_goods(RoleId,[Goods]);
t_update_goods(RoleId,GoodsList) ->
    t_update_goods(RoleId,?MAIN_BAG_ID,GoodsList).
t_update_goods(RoleId,BagId,GoodsList) ->
    case get_role_bag(RoleId, BagId) of
        {ok,#r_role_bag{bag_goods = BagGoodsList} = RoleBag} ->
            next;
        _ ->
            BagGoodsList = [],RoleBag = undefined,
            erlang:throw({bag_error,bag_info_not_found})
    end,
    {NewBagGoodsList,OldGoodsList} = t_update_goods2(GoodsList,BagId,BagGoodsList,[]),
    NewRoleBag = RoleBag#r_role_bag{bag_goods = NewBagGoodsList},
    set_role_bag(RoleId, BagId, NewRoleBag),
    {ok,OldGoodsList}.
t_update_goods2([],_BagId,BagGoodsList,OldGoodsList) ->
    {BagGoodsList,OldGoodsList};
t_update_goods2([UpdateGoods|GoodsList],BagId,BagGoodsList,OldGoodsList) ->
    case BagId =:= UpdateGoods#p_goods.bag_id of
        true ->
            next;
        _ ->
            erlang:throw({bag_error,bag_id_valid})
    end,
    case lists:keyfind(UpdateGoods#p_goods.id, #p_goods.id, BagGoodsList) of
        false ->
            erlang:throw({bag_error,update_goods_not_found});
        OldGoods ->
            NewBagGoodsList = [UpdateGoods|lists:keydelete(UpdateGoods#p_goods.id, #p_goods.id, BagGoodsList)],
            t_update_goods2(GoodsList,BagId,NewBagGoodsList,[OldGoods|OldGoodsList])
    end.

%% 删除道具
%% {ok,DelGoodsList} or {bag_error,Reason}
t_delete_goods(RoleId,GoodsId) when erlang:is_integer(GoodsId) ->
    t_delete_goods(RoleId,[GoodsId]);
t_delete_goods(RoleId,GoodsIdList) ->
    t_delete_goods(RoleId,?MAIN_BAG_ID,GoodsIdList).
t_delete_goods(RoleId,BagId,GoodsIdList) ->
    case get_role_bag(RoleId, BagId) of
        {ok,#r_role_bag{bag_goods = BagGoodsList} = RoleBag} ->
            next;
        _ ->
            BagGoodsList = [],RoleBag = undefined,
            erlang:throw({bag_error,bag_info_not_found})
    end,
    {NewBagGoodsList,DelGoodsList} = t_delete_goods2(GoodsIdList,BagGoodsList,[]),
    NewRoleBag = RoleBag#r_role_bag{bag_goods = NewBagGoodsList},
    set_role_bag(RoleId, BagId, NewRoleBag),
    {ok,DelGoodsList}.
    
t_delete_goods2([],BagGoodsList,DelGoodsList) ->
    {BagGoodsList,DelGoodsList};
t_delete_goods2([GoodsId|GoodsIdList],BagGoodsList,DelGoodsList) ->
    case lists:keyfind(GoodsId, #p_goods.id, BagGoodsList) of
        false ->
            erlang:throw({bag_error,del_goods_not_found});
        DelGoods ->
            NewBagGoodsList = lists:keydelete(GoodsId, #p_goods.id, BagGoodsList),
            t_delete_goods2(GoodsIdList,NewBagGoodsList,[DelGoods|DelGoodsList])
    end.

%% 扣除道具
%% 先扣除绑定的，再扣除不绑定的
%% 返回 {ok,UpdateGoodsList,DelGoodsList} | {bag_error,Reason}
t_deduct_goods(RoleId,GoodsId,DeductNumber) when erlang:is_integer(GoodsId) ->
    t_deduct_goods(RoleId,[GoodsId],DeductNumber);
t_deduct_goods(RoleId,GoodsIdList,DeductNumber) ->
    t_deduct_goods(RoleId,?MAIN_BAG_ID,GoodsIdList,DeductNumber).
t_deduct_goods(RoleId,BagId,GoodsId,DeductNumber) when erlang:is_integer(GoodsId) ->
    t_deduct_goods(RoleId,BagId,[GoodsId],DeductNumber);
t_deduct_goods(RoleId,BagId,GoodsIdList,DeductNumber) ->
    {ok,#r_role_bag{bag_goods = BagGoodsList} = RoleBag} =  get_role_bag(RoleId, BagId),
    GoodsList = 
        lists:foldl(
          fun(#p_goods{id=PGoodsId}=PGoods,AccGoodsList) ->
                  case lists:member(PGoodsId, GoodsIdList) of
                      true ->
                          [PGoods|AccGoodsList];
                      _ ->
                          AccGoodsList
                  end
          end, [], BagGoodsList),
    {ok,NewBagGoodsList,UpdateGoodsList,DelGoodsList} = deduct_goods(BagGoodsList,GoodsList,DeductNumber),
    NewRoleBag = RoleBag#r_role_bag{bag_goods = NewBagGoodsList},
    set_role_bag(RoleId, BagId, NewRoleBag),
    {ok,UpdateGoodsList,DelGoodsList}.

t_deduct_goods_by_goodslist(RoleId,GoodsList,DeductNumber) ->
    t_deduct_goods_by_goodslist(RoleId,?MAIN_BAG_ID,GoodsList,DeductNumber).
t_deduct_goods_by_goodslist(RoleId,BagId,GoodsList,DeductNumber) ->
    {ok,#r_role_bag{bag_goods = BagGoodsList} = RoleBag} =  get_role_bag(RoleId, BagId),
    {ok,NewBagGoodsList,UpdateGoodsList,DelGoodsList} = deduct_goods(BagGoodsList,GoodsList,DeductNumber),
    NewRoleBag = RoleBag#r_role_bag{bag_goods = NewBagGoodsList},
    set_role_bag(RoleId, BagId, NewRoleBag),
    {ok,UpdateGoodsList,DelGoodsList}.
  
%% 根据道具类型扣除道具
%% 先扣除绑定的，再扣除不绑定的
%% 返回 {ok,UpdateGoodsList,DelGoodsList} | {bag_error,Reason}
t_deduct_goods_by_type_id(RoleId,TypeId,DeductNumber) ->
    t_deduct_goods_by_type_id(RoleId,?MAIN_BAG_ID,TypeId,DeductNumber).
t_deduct_goods_by_type_id(RoleId,BagId,TypeId,DeductNumber) ->
    case mod_bag:is_in_bag_by_type_id(RoleId,BagId,TypeId) of
        {ok,GoodsList} ->
            {ok,#r_role_bag{bag_goods = BagGoodsList} = RoleBag} =  get_role_bag(RoleId, BagId),
            {ok,NewBagGoodsList,UpdateGoodsList,DelGoodsList} = deduct_goods(BagGoodsList,GoodsList,DeductNumber),
            NewRoleBag = RoleBag#r_role_bag{bag_goods = NewBagGoodsList},
            set_role_bag(RoleId, BagId, NewRoleBag),
            {ok,UpdateGoodsList,DelGoodsList};
    _ ->
          {bag_error,goods_not_found}
end.

%% 扣除物品排序规则
%% 1,绑定的道具排前
%% 2,数量少的排前
sort_deduct_goods(GoodsList) ->
    lists:sort(
      fun(#p_goods{number=ANumber},#p_goods{number=BNumber}) -> 
              ANumber < BNumber
      end,GoodsList).
%% 先扣除绑定的，再扣除不绑定的
%% 返回 {ok,UpdateGoodsList,DelGoodsList} | {bag_error,Reason}
%% 扣除物品
deduct_goods(BagGoodsList,GoodsList,DeductNumber) ->
    SortGoodsList = sort_deduct_goods(GoodsList),
    {ok,UpdateGoodsList,DelGoodsList} = deduct_goods2(SortGoodsList,DeductNumber,[],[]),
    NewBagGoodsList = 
        lists:foldl(
          fun(#p_goods{id=DelGoodsId},Acc) -> 
                  lists:keydelete(DelGoodsId, #p_goods.id, Acc)
          end, BagGoodsList, UpdateGoodsList ++ DelGoodsList),
    {ok,UpdateGoodsList ++ NewBagGoodsList,UpdateGoodsList,DelGoodsList}.
deduct_goods2(_GoodsList,0,UpdateGoodsList,DelGoodsList) ->
    {ok,UpdateGoodsList,DelGoodsList};
deduct_goods2([],_DeductNumber,_UpdateGoodsList,_DelGoodsList) ->
    erlang:throw({bag_error,goods_not_enough});
deduct_goods2([Goods|GoodsList],DeductNumber,UpdateGoodsList,DelGoodsList) ->
    case Goods#p_goods.number >= DeductNumber of
        true ->
            NewNumber = Goods#p_goods.number - DeductNumber,
            NewDeductNumber = 0;
        _ ->
            NewNumber = 0,
            NewDeductNumber = DeductNumber - Goods#p_goods.number
    end,
    case NewNumber of
        0 ->
            NewUpdateGoodsList = UpdateGoodsList,
            NewDelGoodsList = [Goods|DelGoodsList];
        _ ->
            NewUpdateGoodsList = [Goods#p_goods{number = NewNumber}|UpdateGoodsList],
            NewDelGoodsList = DelGoodsList
    end,
    deduct_goods2(GoodsList,NewDeductNumber,NewUpdateGoodsList,NewDelGoodsList).
            
    
%% 新道具进行合并
%% 返回 NewGoodsList
atmoic_merge_new([],NewGoodsList) ->
    NewGoodsList;
atmoic_merge_new([Goods|T],GoodsList) ->
   case catch is_goods_overlap(Goods) of
       {ok} ->
           NewGoodsList = atmoic_merge_new2(GoodsList,Goods,[]),
           atmoic_merge_new(T,NewGoodsList);
       _ ->
           atmoic_merge_new(T,[Goods|GoodsList])
   end.
%% 将新的道具与已经有的道具进行合并
%% NewGoodsList
atmoic_merge_new2([],undefined,NewGoodsList) ->
    NewGoodsList;
atmoic_merge_new2([],AddGoods,NewGoodsList) ->
    [AddGoods|NewGoodsList];
atmoic_merge_new2([H|T],AddGoods,NewGoodsList) ->
    case catch is_goods_overlap(H,AddGoods) of
        {ok} ->
            MergeGoods = H#p_goods{number = H#p_goods.number + AddGoods#p_goods.number},
            atmoic_merge_new2([],undefined, [MergeGoods|NewGoodsList] ++ T);
        _ ->
            atmoic_merge_new2(T,AddGoods,[H|NewGoodsList])
    end.

%% 合并道具
%% 返回 {NewGoodsList,UpdateGoodsList,NewBagGoodsList}
atmoic_merge([],BagGoodsList,NewGoodsList,UpdateGoodsList) ->
    {NewGoodsList,UpdateGoodsList,BagGoodsList};
atmoic_merge([Goods|GoodsList],BagGoodsList,NewGoodsList,UpdateGoodsList) ->
    #p_goods{number = Number} = Goods,
    case Number > ?MAX_ITEM_NUMBER orelse Number < 1 of
        true ->
            throw({bag_error,goods_number_valid});
        _ ->
            next
    end,
   case catch is_goods_overlap(Goods) of
       {ok} ->
           {NewGoods,UpdateGoods,NewBagGoodsList} = atmoic_merge3(BagGoodsList,Goods,Goods,undefined,[]),
           case NewGoods of
               undefined ->
                   NewGoodsList1 = NewGoodsList,
                   UpdateGoodsList1 = [UpdateGoods|lists:keydelete(UpdateGoods#p_goods.id, #p_goods.id, UpdateGoodsList)];
               _ ->
                   NewGoodsList1 = [NewGoods|NewGoodsList],
                   UpdateGoodsList1 = UpdateGoodsList
           end,
           atmoic_merge(GoodsList,NewBagGoodsList,NewGoodsList1,UpdateGoodsList1);
       _ ->
           atmoic_merge(GoodsList,BagGoodsList,[Goods|NewGoodsList],UpdateGoodsList)
   end.
%% 将新的道具与背包已经有的道具进行合并
%% 只返回以下结构
%% {undefined,UpdateGoods,NewBagGoodsList} or %% {NewGoods,undefined,BagGoodsList}
atmoic_merge3([],_Goods,NewGoods,UpdateGoods,NewBagGoodsList) ->
    {NewGoods,UpdateGoods,NewBagGoodsList};
atmoic_merge3([BagGoods|BagGoodsList],Goods,NewGoods,UpdateGoods,NewBagGoodsList) ->
    case catch is_goods_overlap(BagGoods,Goods) of
        {ok} ->
            NewBagGoods = BagGoods#p_goods{number = BagGoods#p_goods.number + Goods#p_goods.number},
            atmoic_merge3([],Goods,undefined,NewBagGoods,[NewBagGoods|NewBagGoodsList] ++ BagGoodsList);
        _ ->
            atmoic_merge3(BagGoodsList,Goods,NewGoods,UpdateGoods,[BagGoods|NewBagGoodsList])
    end.
%% 检查道具基本信息，是否可叠加
is_goods_overlap(Goods) ->
    #p_goods{type = ItemType,type_id = TypeId,number = Number} = Goods,
    case ItemType of
        ?TYPE_ITEM ->
            [#r_item_info{is_overlap = IsOverlap,use_num = UseNum}] = cfg_item:find(TypeId),
            case UseNum =:= 1 andalso IsOverlap =:= ?CAN_OVERLAP andalso Number < ?MAX_ITEM_NUMBER of
                true ->
                    erlang:throw({ok});
                _ ->
                    erlang:throw({error})
            end;
        ?TYPE_STONE ->
            case cfg_stone:find(TypeId) of
                [#r_stone_info{is_overlap=?CAN_OVERLAP}] ->
                    case Number < ?MAX_ITEM_NUMBER of
                        true ->
                            erlang:throw({ok});
                        _ ->
                            erlang:throw({error})
                    end;
                _ ->
                    erlang:throw({error})
            end;
        ?TYPE_EQUIP ->
            erlang:throw({error})
    end.
%% 检查这两个物品
is_goods_overlap(AGoods,BGoods) ->
    #p_goods{type = AType,type_id = ATypeId,
             number = ANumber,
             start_time = AStartTime, end_time = AEndTime
            } = AGoods,
    #p_goods{type = BType,type_id = BTypeId,
             number = BNumber,
             start_time = BStartTime, end_time = BEndTime} = BGoods,
    case ANumber + BNumber =< ?MAX_ITEM_NUMBER of
        true ->
            next;
        _ ->
            erlang:throw({error})
    end,
    case AType =:= BType andalso ATypeId =:= BTypeId
        andalso AStartTime =:= BStartTime andalso AEndTime =:= BEndTime of
        true ->
            next;
        _ ->
            erlang:throw({error})
    end,
    {ok}.
%% 获取背包空格子
%% RoleBag 背包信息
%% PosNumber 获取空格子数
%% 返回 {ok,PosList} or 直接抛出异常 {bag_error,not_enough_pos}
get_empty_bag_pos(RoleBag,PosNumber) ->
    #r_role_bag{bag_goods = BagGoodsList,grid_number = GridNumber} = RoleBag,
    BagPositionList = [ BagGoods#p_goods.bag_position || BagGoods <- BagGoodsList ],
    GoodsNumber = erlang:length(BagPositionList),
    case PosNumber + GoodsNumber > GridNumber of
        true ->
            erlang:throw({bag_error,not_enough_pos});
        _ ->
            next
    end,
    {PosList,_} = 
        lists:foldl(
          fun(Index,{AccPosList,AccNumber}) -> 
                  case AccNumber =:= PosNumber of
                      true ->
                          {AccPosList,AccNumber};
                      _ ->
                          case lists:member(Index, BagPositionList)  of
                              true ->
                                  {AccPosList,AccNumber};
                              _ ->
                                  {[Index|AccPosList],AccNumber + 1}
                          end
                  end
          end, {[],0}, lists:seq(1, GridNumber,1)),
    {ok,PosList}.


%% 整理背包
%% {ok,RoleBag} or {error,Reason}
t_tidy_bag(RoleId,BagId) ->
    case get_role_bag(RoleId,BagId) of
        {ok,RoleBag} ->
            next;
        _ ->
            RoleBag = undefined,
            erlang:throw({bag_error,bag_info_not_found})
    end,
    %% 需要合并道具，排序道具
    #r_role_bag{bag_goods = BagGoodsList,grid_number = GridNumber} = RoleBag,
    NewBagGoodsList = t_tidy_bag2(BagGoodsList,GridNumber),
    NewRoleBag = RoleBag#r_role_bag{bag_goods = NewBagGoodsList},
    set_role_bag(RoleId,BagId,NewRoleBag),
    {ok,NewRoleBag}.

t_tidy_bag2(BagGoodsList,_GridNumber)->
    %% 合并道具
    NewBagGoodsList = t_tidy_bag3(BagGoodsList,[]),
    %% 排序
    NewBagGoodsList2 = 
        lists:sort(
          fun(GoodsA,GoodsB) -> 
                  goods_sort(GoodsA,GoodsB)
          end,NewBagGoodsList),
    %% 重新分格子
    {_,NewBagGoodsList3} = 
        lists:foldl(
          fun(PGoods,{AccIndex,AccGoodsList}) -> 
                  {AccIndex + 1,[PGoods#p_goods{bag_position = AccIndex}|AccGoodsList]}
          end, {1,[]}, NewBagGoodsList2),
    NewBagGoodsList3.

%% 返回 NewBagGoodsList
t_tidy_bag3([],BagGoodsList) ->
    BagGoodsList;
t_tidy_bag3([Goods|GoodsList],BagGoodsList) ->
    case catch is_goods_overlap(Goods) of
       {ok} -> %% 可叠加
           case lists:keyfind(Goods#p_goods.type_id, #p_goods.type_id, BagGoodsList) of
               false ->
                   t_tidy_bag3(GoodsList,[Goods|BagGoodsList]);
               _ ->
                   NewBagGoodsList = t_tidy_bag4(BagGoodsList,Goods,[]),
                   t_tidy_bag3(GoodsList,NewBagGoodsList)
           end;
        _ ->
            t_tidy_bag3(GoodsList,[Goods|BagGoodsList])
    end.
t_tidy_bag4([],_Goods,NewBagGoodsList) ->
    NewBagGoodsList;
t_tidy_bag4([BagGoods|BagGoodsList],Goods,NewBagGoodsList) ->
    case catch is_goods_overlap(BagGoods,Goods) of
        {ok} ->
            NewBagGoods = BagGoods#p_goods{number = BagGoods#p_goods.number + Goods#p_goods.number},
            t_tidy_bag4([],Goods,[NewBagGoods|NewBagGoodsList] ++ BagGoodsList);
        _ ->
            t_tidy_bag4(BagGoodsList,Goods,[BagGoods|NewBagGoodsList])
    end.

%% 物品排序
%% 道具类型排序
goods_sort(GoodsA,GoodsB) ->
    case catch goods_sort2(GoodsA,GoodsB) of
        {true} ->
            true;
        _ ->
            false
    end.
goods_sort2(GoodsA,GoodsB) ->
    %% 道具类型排序
    if GoodsA#p_goods.type < GoodsB#p_goods.type ->
           erlang:throw({true});
       GoodsA#p_goods.type > GoodsB#p_goods.type ->
           erlang:throw({false});
       true ->
           next
    end,
    Type = GoodsA#p_goods.type,
    %% 道具id排序
    case Type of
        ?TYPE_ITEM ->
            if GoodsA#p_goods.type_id < GoodsB#p_goods.type_id ->
                   erlang:throw({true});
               GoodsA#p_goods.type_id > GoodsB#p_goods.type_id ->
                   erlang:throw({false});
               true ->
                   next
            end;
        ?TYPE_STONE ->
            if GoodsA#p_goods.type_id < GoodsB#p_goods.type_id ->
                   erlang:throw({true});
               GoodsA#p_goods.type_id > GoodsB#p_goods.type_id ->
                   erlang:throw({false});
               true ->
                   next
            end;
        ?TYPE_EQUIP ->
            if GoodsA#p_goods.type_id < GoodsB#p_goods.type_id ->
                   erlang:throw({true});
               GoodsA#p_goods.type_id > GoodsB#p_goods.type_id ->
                   erlang:throw({false});
               true ->
                   next
            end;
        _ ->
            erlang:throw({false})
    end,

    %% 道具有效期排序
    if GoodsA#p_goods.end_time < GoodsB#p_goods.end_time ->
           erlang:throw({true});
       GoodsA#p_goods.end_time > GoodsB#p_goods.end_time ->
           erlang:throw({false});
       true ->
           next
    end,
    %% 道具数量排序
    case Type of 
        ?TYPE_EQUIP ->
            %% 战力值
            {GoodsA#p_goods.power >=  GoodsB#p_goods.power};
        _ ->
            {GoodsA#p_goods.number >= GoodsB#p_goods.number}
    end.

    