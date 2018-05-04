%%% -------------------------------------------------------------------
%%% Author  : caochuncheng2002@gmail.com
%%% Description :帮派主进程
%%%
%%% Created : 2013-8-22
%%% -------------------------------------------------------------------
-module(family_manager_server).

-behaviour(gen_server).

-include("mgeew.hrl").

-export([
         start/0, 
         start_link/0
        ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(loop_milliseconds_1000,1000).
-record(state, {}).

start() ->
    {ok, _} = supervisor:start_child(mgeew_sup, {?MODULE, {?MODULE, start_link, []},
                                                 permanent, 30000, worker, [?MODULE]}).
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    case db_api:transaction(
           fun() -> 
				   case common_config_dyn:find_common(is_merged) of
					   [false] ->
						   [ServerId] = common_config_dyn:find_common(server_id),
						   case db_api:read(?DB_FAMILY_COUNTER, ServerId, write) of
							   [] ->
								   InitKeyId = common_misc:get_init_key_id(),
								   db_api:write(?DB_FAMILY_COUNTER, #r_counter{key=ServerId, last_id=InitKeyId}, write);
							   _ ->
								   ignore
						   end;
					   _ ->
						   ignroe
				   end,
                   {ok}
           end) of
        {atomic, {ok}} ->
            erlang:process_flag(trap_exit, true),
            NowSeconds = common_tool:now(),
            erlang:put(milliseconds_1000, NowSeconds),
            set_cache_family_interval(NowSeconds + cfg_family:gen_family_cache_interval()),
            erlang:send_after(?loop_milliseconds_1000, erlang:self(), loop_milliseconds_1000),
            set_new_family_list([]),
            set_cache_family_list([]),
            gen_cache_family_list(),
            init_create_family_process(),
            {ok, #state{}};
        {aborted, Reason} ->
            ?ERROR_MSG("~ts,Reason=~w", [?_LANG_LOCAL_003, Reason]),
            {stop, Reason}
    end.
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.
handle_cast(_Msg, State) ->
    {noreply, State}.
handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info, State),
    {noreply, State}.
terminate(_Reason, _State) ->
    ok.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%%每秒大循环
do_handle_info(loop_milliseconds_1000) ->
    NowSeconds = common_tool:now(),
    erlang:put(milliseconds_1000, NowSeconds),
    erlang:send_after(?loop_milliseconds_1000, erlang:self(), loop_milliseconds_1000),
    loop();

do_handle_info({Module,?FAMILY_GET,DataRecord,RoleId,PId,_Line}) ->
    mod_family:handle({Module,?FAMILY_GET,DataRecord,RoleId,PId});

do_handle_info({Module,?FAMILY_QUERY,DataRecord,RoleId,PId,_Line}) ->
    do_family_query(Module,?FAMILY_QUERY,DataRecord,RoleId,PId);

do_handle_info({Module,?FAMILY_SET,DataRecord,RoleId,PId,_Line}) ->
    do_family_set(Module,?FAMILY_SET,DataRecord,RoleId,PId);


do_handle_info({hook_create_family,Info}) ->
    do_hook_create_family(Info);

do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;
do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).


get_now() ->
    erlang:get(milliseconds_1000).
%%每秒大循环
loop() ->
    NowSeconds = get_now(),
    case NowSeconds > get_cache_family_interval() of
        true ->
            set_cache_family_interval(NowSeconds + cfg_family:gen_family_cache_interval()),
            gen_cache_family_list();
        _ ->
            next
    end,
    ok.
-define(family_query_op_type_all,1).             %% 1查询全部
-define(family_query_op_type_family_name,2).     %% 2按帮派名称搜索,
-define(family_query_op_type_owner_name,3).      %% 3按帮派团长名称搜索
%% 查询帮派列表
do_family_query(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_query2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_query_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,TotalPage,FamilyList} ->
            do_family_query3(Module,Method,DataRecord,RoleId,PId,
                             TotalPage,FamilyList)
    end.
do_family_query2(RoleId,DataRecord) ->
    #m_family_query_tos{op_type=OpType,
                        page_id=PageId,
                        page_number=PageNumber,
                        content=Content} = DataRecord,
    case OpType of
        ?family_query_op_type_all ->
            next;
        ?family_query_op_type_family_name ->
            next;
        ?family_query_op_type_owner_name ->
            case Content =/= "" andalso Content =/= [] of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_FAMILY_QUERY_001})
            end;
        _ ->
            erlang:throw({error,?_RC_FAMILY_QUERY_001})
    end,
    case PageId > 0 andalso erlang:is_integer(PageId) of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_QUERY_001})
    end,
    case PageNumber > 0 andalso erlang:is_integer(PageNumber) of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_QUERY_001})
    end,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_FAMILY_QUERY_000})
    end,
    AddFamilyList = get_new_family_list(),
    FamilyList = get_cache_family_list(),
    
    #p_role_base{faction_id = FactionId} = RoleBase,
    FilterFunc = 
        fun(#p_family_list{faction_id = PFactionId,family_name=PFamilyName,owner_role_name=POwnerRoleName}) -> 
                  case PFactionId =:= FactionId of
                      true ->
                          case OpType of
                              ?family_query_op_type_all ->
                                  true;
                              ?family_query_op_type_family_name ->
                                  string:str(common_tool:to_list(PFamilyName), Content) > 0;
                              ?family_query_op_type_owner_name -> 
                                  string:str(common_tool:to_list(POwnerRoleName), Content) > 0
                          end;
                      _ ->
                          false
                  end
          end,
    NewFamilyList = lists:filter(FilterFunc, FamilyList),
    NewAddFamilyList = lists:filter(FilterFunc, AddFamilyList),
    case NewAddFamilyList of
        [] ->
            ResultList = NewFamilyList;
        _ ->
            ResultList = NewFamilyList ++ NewAddFamilyList
    end,
    TotalNumber = erlang:length(ResultList),
    case (PageId - 1) * PageNumber + 1 > TotalNumber of
        true -> 
            StartPage = 1;
        _ -> 
            StartPage = (PageId - 1) * PageNumber + 1
    end,
    case ResultList of
        [] -> 
            TotalPage = 0,
            NewResultList = [];
        _ ->
            TotalPage = common_tool:ceil(TotalNumber/PageNumber),
            NewResultList = lists:sublist(ResultList, StartPage, PageNumber)
    end,
    {ok,TotalPage,NewResultList}.
do_family_query3(Module,Method,DataRecord,_RoleId,PId,
                 TotalPage,FamilyList)->
    SendSelf = #m_family_query_toc{op_type=DataRecord#m_family_query_tos.op_type,
                                   op_from=DataRecord#m_family_query_tos.op_from,
                                   page_id=DataRecord#m_family_query_tos.page_id,
                                   total_page=TotalPage,
                                   faction_id=DataRecord#m_family_query_tos.faction_id,
                                   op_code=0,
                                   family_list=FamilyList},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.
do_family_query_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_family_query_toc{op_type=DataRecord#m_family_query_tos.op_type,
                                   op_from=DataRecord#m_family_query_tos.op_from,
                                   page_id=DataRecord#m_family_query_tos.page_id,
                                   total_page=0,
                                   faction_id=DataRecord#m_family_query_tos.faction_id,
                                   op_code=OpCode,
                                   family_list=[]},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.

%% 玩家
do_hook_create_family({PFamily}) ->
    PFamilyList = get_new_family_list(),
    set_new_family_list([PFamily|PFamilyList]),
    ok.

%% 帮派列表缓存数据生成时间间隔
get_cache_family_interval() ->
    erlang:get(cache_family_interval_dict).
set_cache_family_interval(Interval) ->
    erlang:put(cache_family_interval_dict, Interval).

%% 新创建帮派列表
get_new_family_list() ->
    erlang:get(new_family_list_dict).
set_new_family_list(PFamilyList) ->
    erlang:put(new_family_list_dict, PFamilyList).

%% 帮派列表缓存处理
%% 返回 [#p_family_list{},...] | []
get_cache_family_list() ->
    erlang:get(cache_family_list_dict).
set_cache_family_list(PFamilyList) ->
    erlang:put(cache_family_list_dict, PFamilyList).
          
%% 生成帮派列表缓存数据
gen_cache_family_list() ->
    Func = 
        fun(#r_family{family_id=FamilyId,
                      family_name=FamilyName,
                      owner_role_id=OwnerRoleId,
                      owner_role_name=OwnerRoleName,
                      faction_id=FactionId,
                      level=Level,
                      cur_pop=CurPop,
                      max_pop=MaxPop,
                      total_contribute=TotalContribute,
                      public_notice=PublicNotic}) ->
                #p_family_list{family_id=FamilyId,
                               family_name=FamilyName,
                               owner_role_id=OwnerRoleId,
                               owner_role_name=OwnerRoleName,
                               faction_id=FactionId,
                               level=Level,
                               cur_pop=CurPop,
                               max_pop=MaxPop,
                               total_contribute=TotalContribute,
                               public_notice=PublicNotic}
                end,
    FamilyList = db_misc:do_each_dirty_read(?DB_FAMILY,Func,true),
    SortFamilyList = 
        lists:sort(
          fun(FamilyA,FamilyB) -> 
                  cache_family_list_sort(FamilyA,FamilyB)
          end,FamilyList),
    set_cache_family_list(SortFamilyList),
    set_new_family_list([]),
    SortFamilyList.
cache_family_list_sort(FamilyA,FamilyB) ->
    case catch cache_family_list_sort2(FamilyA,FamilyB) of
        {true} ->
            true;
        _ ->
            false
    end.
%% 先按照帮派等级排序、再按帮派总贡献度进行排序、再按照帮派Id进行排序
cache_family_list_sort2(FamilyA,FamilyB) ->
    if FamilyA#p_family_list.level > FamilyB#p_family_list.level ->
           erlang:throw({true});
       FamilyA#p_family_list.level < FamilyB#p_family_list.level ->
           erlang:throw({false});
       true ->
           next
    end,
    if FamilyA#p_family_list.total_contribute > FamilyB#p_family_list.total_contribute ->
           erlang:throw({true});
       FamilyA#p_family_list.total_contribute < FamilyB#p_family_list.total_contribute ->
           erlang:throw({false});
       true ->
           {FamilyA#p_family_list.family_id < FamilyB#p_family_list.family_id}
    end.

%% 启动游戏时，启动帮派排行前N名的帮派信息
init_create_family_process() ->
    FamilyList = lists:sublist(get_cache_family_list(), 1, cfg_family:init_max_family_process_number()),
    init_create_family_process2(FamilyList).
init_create_family_process2([]) ->
    ok;
init_create_family_process2([#p_family_list{family_id=FamilyId}|FamilyList]) ->
    ?TRY_CATCH(common_family:create_family_process(?FAMILY_PROCESS_OP_TYPE_INIT,FamilyId),ErrCreateFamily),
    init_create_family_process2(FamilyList).

%% 帮派信息设置
do_family_set(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_family_set2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_family_set_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FamilyPId} ->
            do_family_set3(Module,Method,DataRecord,RoleId,PId,FamilyPId)
    end.
do_family_set2(_RoleId,DataRecord) ->
    #m_family_set_tos{op_type = OpType,
                      family_id=FamilyId,
                      value=Value} = DataRecord,
    case OpType of
        ?FAMILY_SET_OP_TYPE_PUBLIC_NOTICE ->
            ValueLen = erlang:length(unicode:characters_to_list(erlang:list_to_binary(Value),unicode)),
            case ValueLen =< 140 of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_FAMILY_SET_005})
            end;
        _ ->
            erlang:throw({error,?_RC_FAMILY_SET_003})
    end,
    case FamilyId > 0 andalso erlang:is_integer(FamilyId) of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_FAMILY_SET_003})
    end,
    case common_family:get_family_pid(FamilyId) of
        undefined ->
            FamilyPId = undefined,
            erlang:throw({error,?_RC_FAMILY_SET_004});
        FamilyPId ->
            next
    end,
    {ok,FamilyPId}.
do_family_set3(Module,Method,DataRecord,RoleId,PId,FamilyPId) ->
    Param = {admin_set,{Module,Method,DataRecord,RoleId,PId}},
    common_family:send_to_family(FamilyPId, {mod,mod_family,Param}),
    ok.

do_family_set_error(Module,Method,DataRecord,_RoleId,PId,OpCode)->
    SendSelf = #m_family_set_toc{op_type=DataRecord#m_family_set_tos.op_type,
                                 family_id=DataRecord#m_family_set_tos.family_id,
                                 role_id=DataRecord#m_family_set_tos.role_id,
                                 op_code= OpCode},
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.
