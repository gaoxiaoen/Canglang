%%%-------------------------------------------------------------------
%%% File        :mgeec_goods_cache_server.erl
%%% @doc
%%%     聊天中道具物品缓存进程
%%% @end
%%%-------------------------------------------------------------------


-module(chat_goods_cache_server).

-include("chat.hrl").

%% API
-export([start/0, 
         start_link/0
         ]).

-export([get_cache_goods/1]).

%% gen_server callback
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% record defin
-record(state, {}).

%% 最新的道具id
-define(DICT_LAST_GOODS_ID, dict_last_goods_id).
%% 道具ID列表
-define(DICT_GOODS_ID_LIST, dict_goods_id_list).
%% 存放道具ETS
-define(ETS_GOODS_CACHE, ets_goods_cache).
%% 定时清缓冲循环
-define(MSG_CACHE_LOOP, msg_cache_loop).
%% 清除时间
-define(CLEAR_DIFF, 3600).
%% 循环时间
-define(LOOP_DIFF, 1800*1000).

%%%===================================================================
%%% API
%%%===================================================================
start() ->
    {ok, _} = supervisor:start_child(chat_sup, {?MODULE,
                                                 {?MODULE, start_link, []},
                                                 transient, brutal_kill, worker, 
                                                 [?MODULE]}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_cache_goods(GoodsId) ->
    case ets:lookup(?ETS_GOODS_CACHE, GoodsId) of
        [] ->
            {error, goods_not_found};
        [{_, GoodsDetail}] ->
            {ok, GoodsDetail}
    end.

%% gen_server callback
init([]) ->
    %% 道具缓存
    ets:new(?ETS_GOODS_CACHE, [set, protected, named_table]),
    %% 最新道具ID
    put(?DICT_LAST_GOODS_ID, 1),
    %% 缓存ID列表
    put(?DICT_GOODS_ID_LIST, []),
    %% 定时清缓冲消息
    erlang:send_after(?LOOP_DIFF, self(), ?MSG_CACHE_LOOP),

    {ok, #state{}}.
 

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info,State),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

do_handle_info(?MSG_CACHE_LOOP) ->
    do_cache_loop();

do_handle_info({?CHAT,?CHAT_GET_GOODS,DataRecord,RoleId,PId,_Line}) ->
    do_chat_get_goods(RoleId,DataRecord,PId);

do_handle_info({insert_goods, Info}) ->
    do_insert(Info);
do_handle_info({bc_send_msg_world, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList}) ->
    do_bc_send_msg_world(Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList);
do_handle_info({bc_send_msg_category, Category, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList}) ->
    do_send_msg_category(Category, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList);
do_handle_info({bc_send_msg_family, FamilyId, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList}) ->
    do_send_msg_family(FamilyId, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList);
do_handle_info({bc_send_msg_team, TeamId, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList}) ->
    do_send_msg_team(TeamId, Type, SubType, Msg, RoleId, RoleName, Sex, GoodsList);

do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w", [Info]).

do_bc_send_msg_world(Type, SubType, Msg, _RoleId, RoleName, Sex, GoodsList) when erlang:is_list(GoodsList) ->
    NewMsg = wrap_broadcast_msg_include_goods(Msg, RoleName, Sex, GoodsList),
    common_broadcast:bc_send_msg_world(Type, SubType, NewMsg);
do_bc_send_msg_world(Type, SubType, Msg, _RoleId, RoleName, Sex, Goods) ->
    do_bc_send_msg_world(Type, SubType, Msg, _RoleId, RoleName, Sex, [Goods]).

do_send_msg_category(Category, Type, SubType, Msg, _RoleId, RoleName, Sex, GoodsList) when erlang:is_list(GoodsList) ->
    NewMsg = wrap_broadcast_msg_include_goods(Msg, RoleName, Sex, GoodsList),
    common_broadcast:bc_send_msg_category(Category, Type, SubType, NewMsg);
do_send_msg_category(Category, Type, SubType, Msg, _RoleId, RoleName, Sex, Goods) ->
    do_send_msg_category(Category, Type, SubType, Msg, _RoleId, RoleName, Sex, [Goods]).

do_send_msg_family(FamilyId, Type, SubType, Msg, _RoleId, RoleName, Sex, GoodsList) when erlang:is_list(GoodsList) ->
    NewMsg = wrap_broadcast_msg_include_goods(Msg, RoleName, Sex, GoodsList),
    common_broadcast:bc_send_msg_family(FamilyId, Type, SubType, NewMsg);
do_send_msg_family(FamilyId, Type, SubType, Msg, _RoleId, RoleName, Sex, Goods) ->
    do_send_msg_family(FamilyId, Type, SubType, Msg, _RoleId, RoleName, Sex, [Goods]).

do_send_msg_team(TeamId, Type, SubType, Msg, _RoleId, RoleName, Sex, GoodsList) when erlang:is_list(GoodsList) ->
    NewMsg = wrap_broadcast_msg_include_goods(Msg, RoleName, Sex, GoodsList),
    common_broadcast:bc_send_msg_team(TeamId, Type, SubType, NewMsg);
do_send_msg_team(TeamId, Type, SubType, Msg, _RoleId, RoleName, Sex, Goods) ->
    do_send_msg_team(TeamId, Type, SubType, Msg, _RoleId, RoleName, Sex, [Goods]).

wrap_broadcast_msg_include_goods(Msg, _RoleName, _Sex, GoodsList) ->
    AddLinkList= 
        [begin 
             {ok, #p_goods{id=GoodsId}=ChatGoods} = do_insert_into_cache(Goods),
             GoodsName = common_goods:get_notify_goods_name(ChatGoods),
             {GoodsName,"showGoods|"++common_tool:to_list(GoodsId)}
         end||Goods<-GoodsList],
    common_lang:get_json_lang(Msg, [], AddLinkList).

%% @doc 定时清缓冲
do_cache_loop() ->
    Now = common_tool:now(),
    GoodsList = get(?DICT_GOODS_ID_LIST),

    GoodsList2 =
        lists:foldl(
          fun({GoodsID, Time}, GoodsListT) ->
                  case Now - Time > ?CLEAR_DIFF of
                      true ->
                          ets:delete(?ETS_GOODS_CACHE, GoodsID),
                          lists:delete({GoodsID, Time}, GoodsList);
                      _ ->
                          GoodsListT
                  end
          end, GoodsList, GoodsList),
    put(?DICT_GOODS_ID_LIST, GoodsList2),
    
    erlang:send_after(?LOOP_DIFF, self(), ?MSG_CACHE_LOOP).

%% 聊天频道获取炫耀物品信息
do_chat_get_goods(_RoleId,DataRecord,PId) ->
    case catch do_chat_get_goods2(DataRecord) of
        {ok,Goods} ->
            SendSelf = #m_chat_get_goods_toc{op_code=0,goods=Goods},
            common_misc:unicast(PId, ?CHAT, ?CHAT_GET_GOODS, SendSelf);
        {error,OpCode} ->
            SendSelf = #m_chat_get_goods_toc{op_code=OpCode},
            common_misc:unicast(PId, ?CHAT, ?CHAT_GET_GOODS, SendSelf)
    end.
do_chat_get_goods2(DataRecord) ->
    #m_chat_get_goods_tos{goods_id=GoodsId} = DataRecord,
    case get_cache_goods(GoodsId) of
        {ok,Goods} ->
            next;
        _ ->
            Goods = undefined,
            erlang:throw({error,?_RC_CHAT_GET_GOODS_000})
    end,
    {ok,Goods}.

%% @doc 插入纪录
do_insert({RoleId,DataRecord,_PId,_RoleName,_RoleSex,Goods}) ->
    {ok, #p_goods{id=GoodsId}=CacheGoods} = do_insert_into_cache(Goods),
    GoodsName = common_goods:get_notify_goods_name(CacheGoods),
    Msg = common_lang:get_json_lang("", [], [{GoodsName,"showGoods|"++common_tool:to_list(GoodsId)}]),
    #m_goods_show_tos{channel_type=ChannelType, to_role_id = _ToRoleId,to_role_name=_ToRoleName, show_type=_ShowType} = DataRecord,
    ChatInChannelTos = #m_chat_in_channel_tos{channel_type=ChannelType,msg=Msg,msg_type=?CHAT_MSG_TYPE_JSON},
    Info = {mod,mod_chat,{RoleId,?CHAT,?CHAT_IN_CHANNEL,ChatInChannelTos}},
    common_misc:send_to_role(RoleId, Info),
    ok.

get_goods_id() ->
    GoodsId = get(?DICT_LAST_GOODS_ID),
    put(?DICT_LAST_GOODS_ID, GoodsId+1),
    {ok, GoodsId}.

%% @doc 将道具插入缓存
do_insert_into_cache(Goods) ->
    {ok, GoodsId} = get_goods_id(),
    NewGoods = Goods#p_goods{id=GoodsId},
    ets:insert(?ETS_GOODS_CACHE, {GoodsId, NewGoods}),

    GoodsIdList = get(?DICT_GOODS_ID_LIST),
    put(?DICT_GOODS_ID_LIST, [{GoodsId, common_tool:now()}|GoodsIdList]),
    {ok, NewGoods}.

