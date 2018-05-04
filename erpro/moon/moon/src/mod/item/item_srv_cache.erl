%% --------------------------
%% 物品缓存服务器
%% @author shawnoyc@vip.qq.com
%% --------------------------
-module(item_srv_cache).
-behaviour(gen_server).
-export([
        start_link/0
       ,add/1
       ,get/1
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("item.hrl").

%% 最大缓存物品数
-define(MAX_ID, 100000).


%% ---对外接口------------

%% 启动服务器
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% 添加一个物品缓存
add(Item) ->
    gen_server:call({global, ?MODULE}, {add, Item}).

%% 查询一个物品缓存
get(Id) ->
    gen_server:call({global, ?MODULE}, {query_data, Id}).

%% ----服务器内部实现--------

init([]) ->
    %% 保存角色聊天物品数据
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(ets_broadcast_item_cache, [named_table, public, ordered_set]),
%%  self() ! clear_cache,
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, 1}.

handle_call({add, Item}, _From, ?MAX_ID) ->
    ets:insert(ets_broadcast_item_cache, {1, Item}),
    {reply, 1, 2};

handle_call({add, Item}, _From, State) ->
    ets:insert(ets_broadcast_item_cache, {State, Item}),
    {reply, State, State + 1};

handle_call({query_data, Id}, _From, State) ->
    Item = case ets:lookup(ets_broadcast_item_cache, Id) of
        [] -> null;
        [{_Key, IR}] -> IR;
        _ -> null
    end,
    {reply, Item, State}.

handle_cast(_Info, State) ->
    {noreply, State}.

%%%% 定时清除广播物品过期数据
%%handle_info(clear_cache, State) ->
%%    LastT = util:unixtime() - ?EXPIRE_TIME,
%%    _Num = ets:select_delete(ets_broadcast_item_cache, [{
%%                {'_','$2','_'}
%%                ,[{'<','$2',LastT}]
%%                ,[true]
%%            }
%%        ]
%%    ),
%%    erlang:send_after(?CLEAR_NEXT_TIME, self(), clear_cache),
%%    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
