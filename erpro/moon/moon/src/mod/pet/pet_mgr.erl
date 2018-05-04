-module(pet_mgr).
-behaviour(gen_server).

-export([
        start_link/0,
        get_all/0,
        update_ets/2
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("rank.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("achievement.hrl").

-record(state, {
        loaded = 0
    }).

%% 查询ets表
%% lookup(Type) -> #rank{}
get_all() ->
    case ets:match(dragon_explore_rank, '$1') of
        [] ->
       	 	[];
        Data ->
        	format(Data,[])
    end.

%% 更新ets表
%% update_ets(State) -> ok
update_ets(Role_Name, Item_Name) ->
    Datas = get_all(),
    case erlang:length(Datas) >= 5 of 
        true -> 
            Key = ets:first(dragon_explore_rank),
            ets:delete(dragon_explore_rank, Key),
            ets:insert(dragon_explore_rank, {util:unixtime(), Role_Name, Item_Name});
        false ->
            ets:insert(dragon_explore_rank, {util:unixtime(), Role_Name, Item_Name})
    end.  



%%----------------------------------------------------
%% 系统函数
%%----------------------------------------------------
%% 启动排行榜进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(dragon_explore_rank, [public,ordered_set, named_table,{keypos, 1}]),
    % ets:insert(dragon_explore_rank,{util:unixtime(),<<"周杰伦">>,<<"魔晶石碎片">>}),
    %% erlang:register(?MODULE, self()), %% 注册一个名字，方便查看排行榜信息
    process_flag(trap_exit, true), 
    ?INFO("[~w] 宠物龙族探寻幸运榜启动完成", [?MODULE]),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
  {reply, _From, State}.
handle_cast(_Request, State) ->
  {noreply, State}.
handle_info(_Info, State) ->
  {noreply, State}. 
terminate(_Reason, _State) ->
  ok.
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


format([],L) -> L;
format([[{_Key,Role_Name,Item_Name}]|T],L) ->
	format(T,[{Role_Name,Item_Name}|L]).