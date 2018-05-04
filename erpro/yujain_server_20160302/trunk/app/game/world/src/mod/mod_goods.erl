%% Author: caochuncheng2002@gmail.com
%% Created: 2013-5-28
%% Description: 道具操作
-module(mod_goods).

-include("mgeew.hrl").

-export([handle/1]).

handle({_Module, ?GOODS_USE, _DataRecord, _RoleId, _PId, _Line}) ->
	ignore;
%%     mod_goods_use:handle({Module, ?GOODS_USE, DataRecord, RoleId,PId, Line});

handle({Module, ?GOODS_QUERY, DataRecord, RoleId, PId, _Line}) ->
    do_goods_query(Module,?GOODS_QUERY,DataRecord,RoleId,PId);

handle({Module, ?GOODS_SWAP, DataRecord, RoleId, PId, _Line}) ->
    do_goods_swap(Module,?GOODS_SWAP,DataRecord,RoleId,PId);

handle({Module, ?GOODS_DESTROY, DataRecord, RoleId, PId, _Line}) ->
    do_goods_destroy(Module,?GOODS_DESTROY,DataRecord,RoleId,PId);

handle({Module, ?GOODS_DIVIDE, DataRecord, RoleId, PId, _Line}) ->
    do_goods_divide(Module,?GOODS_DIVIDE,DataRecord,RoleId,PId);

handle({Module, ?GOODS_TIDY, DataRecord, RoleId, PId, _Line}) ->
    do_goods_tidy(Module,?GOODS_TIDY,DataRecord,RoleId,PId);

handle({Module, ?GOODS_SHOW, DataRecord, RoleId, PId, _Line}) ->
    do_goods_show(Module,?GOODS_SHOW,DataRecord,RoleId,PId);

handle({Module, ?GOODS_ADD_GRID, DataRecord, RoleId, PId, _Line}) ->
    do_goods_add_grid(Module,?GOODS_ADD_GRID,DataRecord,RoleId,PId);

handle({admin_goods_query,Info}) ->
    do_admin_goods_query(Info);

handle(Info) ->
    ?ERROR_MSG("receive unknown message,Info: ~w", [Info]).

%% 查询物品和背包信息
-define(goods_query_op_type_self,1). %%查询物品信息
-define(goods_query_op_type_bag_info,2). %%查询背包信息
-define(goods_query_op_type_other,3). %%查询别人物品信息

do_goods_query(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_goods_query2(RoleId,DataRecord#m_goods_query_tos.op_type,DataRecord) of
        {error,OpCode} ->
            do_goods_query_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,?goods_query_op_type_other} ->
            do_goods_query_other(Module,Method,DataRecord,RoleId,PId);
        {ok,_OpType,GoodsList,GridNumber} ->
            do_goods_query3(Module,Method,DataRecord,RoleId,PId,GoodsList,GridNumber);
        {ok,ignore} ->
            ignore
    end.
do_goods_query2(RoleId,?goods_query_op_type_self,DataRecord) ->
    #m_goods_query_tos{
                       bag_id = BagId,
                       goods_id = GoodsId
                      } = DataRecord,
    case mod_bag:is_in_bag_by_id(RoleId, BagId, GoodsId) of
        {ok,Goods} ->
            next;
        _ ->
            Goods = undefined,
            erlang:throw({error,?_RC_GOODS_QUERY_001})
    end,
    {ok,?goods_query_op_type_self,[Goods],0};
do_goods_query2(RoleId,?goods_query_op_type_bag_info,DataRecord) ->
    #m_goods_query_tos{bag_id = BagId} = DataRecord,
    case mod_bag:get_role_bag(RoleId, BagId) of
        {ok,#r_role_bag{bag_goods = BagGoodsList,grid_number = GridNumber}} ->
            next;
        _ ->
            BagGoodsList = [],GridNumber = 0,
            erlang:throw({error,?_RC_GOODS_QUERY_002})
    end,
    {ok,?goods_query_op_type_bag_info,BagGoodsList,GridNumber};
do_goods_query2(RoleId,?goods_query_op_type_other,DataRecord) ->
    #m_goods_query_tos{
                       role_id = PRoleId,
                       bag_id = BagId,
                       goods_id = GoodsId
                      } = DataRecord,
    case PRoleId of
        RoleId ->
            case mod_bag:is_in_bag_by_id(RoleId, BagId, GoodsId) of
                {ok,Goods} ->
                    erlang:throw({ok,?goods_query_op_type_other,[Goods],0});
                _ ->
                    erlang:throw({error,?_RC_GOODS_QUERY_001})
            end;
        _ ->
            next
    end,
    {ok,?goods_query_op_type_other};
do_goods_query2(_RoleId,_OpType,_DataRecord) ->
    {error,?_RC_GOODS_QUERY_000}.

do_goods_query3(Module,Method,DataRecord,_RoleId,PId,GoodsList,GridNumber) ->
    SendSelf = #m_goods_query_toc{
                                  op_type=DataRecord#m_goods_query_tos.op_type,
                                  role_id=DataRecord#m_goods_query_tos.role_id,
                                  bag_id=DataRecord#m_goods_query_tos.bag_id,
                                  goods_id=DataRecord#m_goods_query_tos.goods_id,
                                  op_code=0,
                                  goods_list=GoodsList,
                                  grid_number = GridNumber
                                 },
    common_misc:unicast(PId, Module, Method, SendSelf).
do_goods_query_other(Module,Method,DataRecord,RoleId,PId) ->
    #m_goods_query_tos{
                       role_id = PRoleId,
                       bag_id = BagId,
                       goods_id = GoodsId
                      } = DataRecord,
    Msg = {mod,mod_googs,{admin_goods_query,{Module,Method,DataRecord,RoleId,PId}}},
    case common_misc:send_to_role(PRoleId, Msg) of
        ignroe -> %% 玩家不在线
            case mod_bag:get_dirty_role_bag(RoleId, BagId) of
                {ok,#r_role_bag{bag_goods = BagGoodsList}} ->
                    case lists:keyfind(GoodsId, #p_goods.id, BagGoodsList) of
                        false ->
                            do_goods_query_error(Module,Method,DataRecord,RoleId,PId,?_RC_GOODS_QUERY_001);
                        Goods ->
                            do_goods_query3(Module,Method,DataRecord,RoleId,PId,[Goods],0)
                    end;
                _ ->
                    do_goods_query_error(Module,Method,DataRecord,RoleId,PId,?_RC_GOODS_QUERY_001)
            end;
        _ ->
            next
    end,
    ok.
do_admin_goods_query({Module,Method,DataRecord,RoleId,PId}) ->
    #m_goods_query_tos{
                       role_id = PRoleId,
                       bag_id = BagId,
                       goods_id = GoodsId
                      } = DataRecord,
    case mod_bag:is_in_bag_by_id(PRoleId, BagId, GoodsId) of
        {ok,Goods} ->
            do_goods_query3(Module,Method,DataRecord,RoleId,PId,[Goods],0);
        _ ->
            do_goods_query_error(Module,Method,DataRecord,RoleId,PId,?_RC_GOODS_QUERY_001)
    end.
do_goods_query_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_goods_query_toc{
                                  op_type=DataRecord#m_goods_query_tos.op_type,
                                  role_id=DataRecord#m_goods_query_tos.role_id,
                                  bag_id=DataRecord#m_goods_query_tos.bag_id,
                                  goods_id=DataRecord#m_goods_query_tos.goods_id,
                                  op_code=OpCode
                                 },
    common_misc:unicast(PId, Module, Method, SendSelf).
%% 背包交换物品
do_goods_swap(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_goods_swap2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_goods_swap_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,SrcRoleBag,SrcGoods,TargetRoleBag,TargetGoods} ->
            do_goods_swap3(Module,Method,DataRecord,RoleId,PId,
                           SrcRoleBag,SrcGoods,TargetRoleBag,TargetGoods)
    end.
do_goods_swap2(RoleId,DataRecord) ->
    #m_goods_swap_tos{
                      goods_id=GoodsId,
                      src_bag_id = SrcBagId,
                      bag_position=BagPosition,
                      bag_id=BagId} = DataRecord,
    case BagId =:= ?ACT_BAG_ID of
        true ->
            case SrcBagId =:= ?ACT_BAG_ID of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_GOODS_SWAP_004})
            end;
        _ ->
            next
    end,
    
    case mod_bag:is_in_bag_by_id(RoleId,SrcBagId,GoodsId) of
        {ok,SrcGoods} ->
            next;
        _ ->
            SrcGoods = undefined,
            erlang:throw({error,?_RC_GOODS_SWAP_000})
    end,
    case mod_bag:get_role_bag(RoleId, SrcBagId) of
        {ok,SrcRoleBag} ->
            next;
        _ ->
            SrcRoleBag = undefined,
            erlang:throw({error,?_RC_GOODS_SWAP_003})
    end,
    case mod_bag:get_role_bag(RoleId, BagId) of
        {ok,TargetRoleBag} ->
            next;
        _ ->
            TargetRoleBag = undefined,
            erlang:throw({error,?_RC_GOODS_SWAP_001})
    end,
    case lists:keyfind(BagPosition, #p_goods.bag_position, TargetRoleBag#r_role_bag.bag_goods) of
        false ->
            TargetGoods = undefined,
            erlang:throw({error,?_RC_GOODS_SWAP_002});
        TargetGoods ->
            next
    end,
    {ok,SrcRoleBag,SrcGoods,TargetRoleBag,TargetGoods}.
do_goods_swap3(Module,Method,DataRecord,RoleId,PId,
               SrcRoleBag,SrcGoods,TargetRoleBag,TargetGoods) ->
    case common_transaction:transaction(
           fun() ->
                   do_t_goods_swap(RoleId,DataRecord,SrcRoleBag,SrcGoods,TargetRoleBag,TargetGoods)
           end)of
        {atomic,{ok,NewSrcGoods,NewTargetGoods}} ->
            do_goods_swap4(Module,Method,DataRecord,RoleId,PId,NewSrcGoods,NewTargetGoods);
        {aborted,Error} ->
            case Error of
                {error,OpCode} ->
                    next;
                _ ->
                    ?ERROR_MSG("swap googs,Error=~w",[Error]),
                    OpCode = ?_RC_GOODS_SWAP_005
            end,
            do_goods_swap_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end.
do_t_goods_swap(RoleId,DataRecord,SrcRoleBag,SrcGoods,TargetRoleBag,TargetGoods) ->
    #m_goods_swap_tos{
                      src_bag_id = SrcBagId,
                      bag_position=BagPosition,
                      bag_id=BagId} = DataRecord,
    #r_role_bag{bag_goods = SrcBagGoodsList} = SrcRoleBag,
    #r_role_bag{bag_goods = TargetBagGoodsList} = TargetRoleBag,
    NewTargetGoods = SrcGoods#p_goods{bag_id = BagId,
                                      bag_position = BagPosition},
    case TargetGoods of
        undefined -> %% 目标格子没有物品
            NewSrcGoods = undefined,
            NewSrcBagGoodsList = lists:keydelete(SrcGoods#p_goods.id, #p_goods.id, SrcBagGoodsList),
            NewTargetBagGoodsList = [NewTargetGoods|TargetBagGoodsList];
        _ ->
            NewSrcGoods = TargetGoods#p_goods{bag_id = SrcBagId,
                                              bag_position = SrcGoods#p_goods.bag_position},
            NewSrcBagGoodsList = lists:keyreplace(SrcGoods#p_goods.id, #p_goods.id, SrcBagGoodsList, NewSrcGoods),
            NewTargetBagGoodsList = lists:keyreplace(TargetGoods#p_goods.id, #p_goods.id, TargetBagGoodsList, NewTargetGoods)
    end,
    mod_bag:set_role_bag(RoleId, SrcBagId, SrcRoleBag#r_role_bag{bag_goods = NewSrcBagGoodsList}),
    mod_bag:set_role_bag(RoleId, BagId, TargetRoleBag#r_role_bag{bag_goods = NewTargetBagGoodsList}),
    {ok,NewSrcGoods,NewTargetGoods}.
do_goods_swap4(Module,Method,DataRecord,_RoleId,PId,NewSrcGoods,NewTargetGoods) ->
    SendSelf = #m_goods_swap_toc{
                                 op_code=0,
                                 goods_id=DataRecord#m_goods_swap_tos.goods_id,
                                 src_bag_id =DataRecord#m_goods_swap_tos.src_bag_id,
                                 bag_position=DataRecord#m_goods_swap_tos.bag_position,
                                 bag_id=DataRecord#m_goods_swap_tos.bag_id,
                                 goods_1 = NewSrcGoods,
                                 goods_2 = NewTargetGoods
                                },
    common_misc:unicast(PId, Module, Method, SendSelf),
    ok.
do_goods_swap_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_goods_swap_toc{
                                 op_code=OpCode,
                                 goods_id=DataRecord#m_goods_swap_tos.goods_id,
                                 src_bag_id =DataRecord#m_goods_swap_tos.src_bag_id,
                                 bag_position=DataRecord#m_goods_swap_tos.bag_position,
                                 bag_id=DataRecord#m_goods_swap_tos.bag_id
                                },
    common_misc:unicast(PId, Module, Method, SendSelf).
%% 销毁物品
-define(goods_destroy_op_type_bag,1).
do_goods_destroy(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_goods_destroy2(RoleId,DataRecord#m_goods_destroy_tos.op_type,DataRecord) of
        {error,OpCode} ->
            do_goods_destroy_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,_OpType} ->
            do_goods_destroy3(Module,Method,DataRecord,RoleId,PId)
    end.
do_goods_destroy2(RoleId,?goods_destroy_op_type_bag,DataRecord) ->
    #m_goods_destroy_tos{bag_id=BagId,goods_id=GoodsIdList} = DataRecord,
    case mod_bag:get_role_bag(RoleId, BagId) of
        {ok,#r_role_bag{bag_goods = BagGoodsList}} ->
            next;
        _ ->
            BagGoodsList = [],
            erlang:throw({error,?_RC_GOODS_DESTROY_002})
    end,
    lists:foreach(
      fun(GoodsId) -> 
              case lists:keyfind(GoodsId, #p_goods.id, BagGoodsList) of
                  false ->
                      erlang:throw({error,?_RC_GOODS_DESTROY_002});
                  _ ->
                      next
              end
      end, GoodsIdList),
    {ok,?goods_destroy_op_type_bag};
do_goods_destroy2(_RoleId,_OpType,_DataRecord) ->
    {error,?_RC_GOODS_DESTROY_001}.
do_goods_destroy3(Module,Method,DataRecord,RoleId,PId) ->
    case common_transaction:transaction(
           fun() ->
                   do_t_goods_destroy(RoleId,DataRecord)
           end)of
        {atomic,{ok,DelGoodsList}} ->
            do_goods_destroy4(Module,Method,DataRecord,RoleId,PId,DelGoodsList);
        {aborted,Error} ->
            case Error of
                {error,OpCode} ->
                    next;
                _ ->
                    ?ERROR_MSG("destroy goods,Error=~w",[Error]),
                    OpCode = ?_RC_GOODS_DESTROY_000
            end,
            do_goods_destroy_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end. 
do_t_goods_destroy(RoleId,DataRecord) ->
    #m_goods_destroy_tos{bag_id=BagId,goods_id=GoodsIdList} = DataRecord,
    {ok,DelGoodsList} = mod_bag:t_delete_goods(RoleId, BagId, GoodsIdList),
    {ok,DelGoodsList}.
do_goods_destroy4(Module,Method,DataRecord,RoleId,PId,DelGoodsList) ->
    %% 道具日志
    {ok,RoleBase} = mod_role:get_role_base(RoleId),
    LogTime = common_tool:now(),
    common_log:log_goods_list({RoleBase,?LOG_CONSUME_GOODS_BAG_DESTROY,LogTime,DelGoodsList,""}),
    
    SendSelf = #m_goods_destroy_toc{op_type = DataRecord#m_goods_destroy_tos.op_type,
                                    bag_id=DataRecord#m_goods_destroy_tos.bag_id,
                                    goods_id=DataRecord#m_goods_destroy_tos.goods_id,
                                    op_code=0},
    common_misc:unicast(PId, Module, Method, SendSelf),

    ok.
do_goods_destroy_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_goods_destroy_toc{op_type = DataRecord#m_goods_destroy_tos.op_type,
                                    bag_id=DataRecord#m_goods_destroy_tos.bag_id,
                                    goods_id=DataRecord#m_goods_destroy_tos.goods_id,
                                    op_code=OpCode},
    common_misc:unicast(PId, Module, Method, SendSelf).
%% 拆分物品
do_goods_divide(_Module,_Method,_DataRecord,_RoleId,_PId) ->
    
    ok.
%% 整理物品
do_goods_tidy(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_goods_tidy2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_goods_tidy_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok} ->
            do_goods_tidy3(Module,Method,DataRecord,RoleId,PId)
    end.

do_goods_tidy2(RoleId,DataRecord) ->
    #m_goods_tidy_tos{bag_id = BagId} = DataRecord,
    case mod_bag:get_role_bag(RoleId, BagId) of
        {ok,_RoleBag} ->
            next;
        _ ->
            erlang:throw({error,?_RC_GOODS_TIDY_000})
    end,
    {ok}.
do_goods_tidy3(Module,Method,DataRecord,RoleId,PId) ->
    #m_goods_tidy_tos{bag_id = BagId} = DataRecord,
    case common_transaction:transaction(
           fun() ->
                   {ok,RoleBag} = mod_bag:t_tidy_bag(RoleId,BagId),
                   {ok,RoleBag}
           end)of
        {atomic,{ok,RoleBag}} ->
            do_goods_tidy4(Module,Method,DataRecord,RoleId,PId,RoleBag);
        {aborted,Error} ->
            case Error of
                {error,OpCode} ->
                    next;
                _ ->
                    ?ERROR_MSG("~ts,Error=~w",[?_LANG_LOCAL_024,Error]),
                    OpCode = ?_RC_GOODS_TIDY_001
            end,
            do_goods_tidy_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end.
do_goods_tidy4(Module,Method,DataRecord,_RoleId,PId,RoleBag) ->
    #r_role_bag{bag_goods = BagGoodsList} = RoleBag,
    SendSelf = #m_goods_tidy_toc{op_code=0,
                                 bag_id=DataRecord#m_goods_tidy_tos.bag_id,
                                 goods_list=BagGoodsList},
    common_misc:unicast(PId, Module, Method, SendSelf).
do_goods_tidy_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_goods_tidy_toc{op_code=OpCode,
                                 bag_id=DataRecord#m_goods_tidy_tos.bag_id,
                                 goods_list=[]},
    common_misc:unicast(PId, Module, Method, SendSelf).

%% 屏示物品
do_goods_show(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_goods_show2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_goods_show_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,RoleBase,Goods,GoodsCachePId} ->
            do_goods_show3(Module,Method,DataRecord,RoleId,PId,
                           RoleBase,Goods,GoodsCachePId)
    end.
do_goods_show2(RoleId,DataRecord) ->
    #m_goods_show_tos{goods_id = GoodsId} = DataRecord,
    case mod_bag:is_in_bag_by_id(RoleId, GoodsId) of
        {ok,Goods} ->
            next;
        _ ->
            Goods = undefined,
            erlang:throw({error,?_RC_GOODS_SHOW_000})
    end,
    case erlang:whereis(chat_goods_cache_server) of
        undefined ->
            GoodsCachePId = undefined,
            erlang:throw({error,?_RC_GOODS_SHOW_001});
        GoodsCachePId ->
            next
    end,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_GOODS_SHOW_001})
    end,
    {ok,RoleBase,Goods,GoodsCachePId}.
do_goods_show3(Module,Method,DataRecord,RoleId,PId,
               RoleBase,Goods,GoodsCachePId) ->
    #p_role_base{sex = RoleSex,role_name = RoleName} = RoleBase,
    GoodsCachePId ! {insert_goods,{RoleId,DataRecord,PId,RoleName,RoleSex,Goods}},
    SendSelf = #m_goods_show_toc{op_code=0},
    common_misc:unicast(PId, Module, Method, SendSelf),
    ok.
do_goods_show_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_goods_show_toc{op_code=OpCode},
    common_misc:unicast(PId, Module, Method, SendSelf).


%% 扩展背包格子
do_goods_add_grid(Module,Method,DataRecord,RoleId,PId) ->
	case catch do_goods_add_grid2(RoleId,DataRecord) of
		{error,OpCode} ->
			do_goods_add_grid_error(Module,Method,DataRecord,RoleId,PId,OpCode);
		{ok,NewRoleBase,NewRoleBag,OpFee} ->
			do_goods_add_grid3(Module,Method,DataRecord,RoleId,PId,
							   NewRoleBase,NewRoleBag,OpFee)
	end.
do_goods_add_grid2(RoleId,DataRecord) ->
	#m_goods_add_grid_tos{op_type=_OpType,
						  bag_id=BagId,
						  add_grid=AddGrid} = DataRecord,
	case BagId of
		?MAIN_BAG_ID ->
			next;
		_ ->
			erlang:throw({error,?_RC_GOODS_ADD_GRID_001})
	end,
	case AddGrid of
		5 ->
			next;
		_ ->
			erlang:throw({error,?_RC_GOODS_ADD_GRID_001})
	end,
	case mod_bag:get_role_bag(RoleId, BagId) of
		{ok,RoleBag} ->
			next;
		_ ->
			RoleBag = undefined,
			erlang:throw({error,?_RC_GOODS_ADD_GRID_000})
	end,
	#r_role_bag{grid_number=GridNumber} = RoleBag,
	[MaxBagGrid] = common_config_dyn:find(role_bag,max_bag_grid),
	case GridNumber >= MaxBagGrid of
		true ->
			erlang:throw({error,?_RC_GOODS_ADD_GRID_002});
		_ ->
			next
	end,
	case GridNumber + AddGrid > MaxBagGrid of
		true ->
			erlang:throw({error,?_RC_GOODS_ADD_GRID_003});
		_ ->
			next
	end,
	[AddGridList] = common_config_dyn:find(role_bag,add_grid_list),
	case catch lists:foldl(
		   fun({MinGrid,MaxGrid,PGridFee},AccGridFee) -> 
				   case GridNumber >= MinGrid andalso GridNumber < MaxGrid of
					   true ->
						   erlang:throw(PGridFee);
					   _ ->
						   AccGridFee
				   end
		   end, 0, AddGridList) of
		0 ->
			GridFee = 0,
			erlang:throw({error,?_RC_GOODS_ADD_GRID_003});
		GridFee ->
			next
	end,
	OpFee = GridFee * AddGrid,
	case mod_role:get_role_base(RoleId) of
		{ok,RoleBase} ->
			next;
		_ ->
			RoleBase = undefined,
			erlang:throw({error,?_RC_GOODS_ADD_GRID_000})
	end,
	case RoleBase#p_role_base.gold >= OpFee of
		true ->
			next;
		_ ->
			erlang:throw({error,?_RC_GOODS_ADD_GRID_004})
	end,
	NewRoleBase=RoleBase#p_role_base{gold=RoleBase#p_role_base.gold - OpFee},
	NewRoleBag = RoleBag#r_role_bag{grid_number=GridNumber + AddGrid},
	{ok,NewRoleBase,NewRoleBag,OpFee}.
do_goods_add_grid3(Module,Method,DataRecord,RoleId,PId,
				   NewRoleBase,NewRoleBag,OpFee) ->
	#m_goods_add_grid_tos{bag_id=BagId} = DataRecord,
	case common_transaction:transaction(
           fun() ->
				    mod_role:t_set_role_base(RoleId, NewRoleBase),
					mod_bag:set_role_bag(RoleId, BagId, NewRoleBag),
                   {ok}
           end)of
        {atomic,{ok}} ->
            do_goods_add_grid4(Module,Method,DataRecord,RoleId,PId,
							   NewRoleBase,NewRoleBag,OpFee);
        {aborted,Error} ->
            case Error of
                {error,OpCode} ->
                    next;
                _ ->
                    ?ERROR_MSG("~ts,Error=~w",[?_LANG_LOACL_025,Error]),
                    OpCode = ?_RC_GOODS_ADD_GRID_000
            end,
            do_goods_add_grid_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end.
do_goods_add_grid4(Module,Method,DataRecord,_RoleId,PId,
				   NewRoleBase,NewRoleBag,OpFee) ->
	LogTime = mgeew_role:get_now(),
	common_log:log_gold({NewRoleBase,?LOG_CONSUME_GOLD_GOODS_ADD_GRID,LogTime,OpFee}),
	common_misc:send_role_attr_change_gold(PId, NewRoleBase),
	SendSelf = #m_goods_add_grid_toc{op_type=DataRecord#m_goods_add_grid_tos.op_type,
									 bag_id=DataRecord#m_goods_add_grid_tos.bag_id,
									 add_grid=DataRecord#m_goods_add_grid_tos.add_grid,
									 op_code=0,
									 grid_number=NewRoleBag#r_role_bag.grid_number},
	common_misc:unicast(PId, Module, Method, SendSelf),
	ok.
do_goods_add_grid_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
	SendSelf = #m_goods_add_grid_toc{op_type=DataRecord#m_goods_add_grid_tos.op_type,
									 bag_id=DataRecord#m_goods_add_grid_tos.bag_id,
									 op_code=OpCode},
    common_misc:unicast(PId, Module, Method, SendSelf).
