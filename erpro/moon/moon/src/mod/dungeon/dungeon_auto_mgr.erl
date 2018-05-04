%%----------------------------------------------------
%% 副本扫荡管理
%% @author wangweibiao
%%----------------------------------------------------
-module(dungeon_auto_mgr).
-behaviour(gen_server).
-export([
		start_link/0,

		fetch_info/1,
		insert_info/1,
		update_info/2,
		delete_info/1,

		insert_reward/1,
		fetch_reward/1,
		delete_reward/1
		]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
    }).


-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("dungeon.hrl").


fetch_info(Rid) ->
	case ets:lookup(sys_dungeon_auto_info, Rid) of 
		[] ->
			[];
		[Val] ->
			% ?DEBUG("---fetch_dungeon_clear_info--~p~n~n~n",[Val]),
			Val
	end.

insert_info({Rid, SrvId, DungeonId, Count, Cur_Count, Time, Is_Stop}) ->
    ets:insert(sys_dungeon_auto_info, {Rid, SrvId, DungeonId, Count, Cur_Count, Time, Is_Stop}).

update_info(rest_count, {Rid, Cur_Count}) ->
    ets:update_element(sys_dungeon_auto_info, Rid, {5, Cur_Count});

update_info(stop_clear, {Rid, Is_Stop}) ->
    ets:update_element(sys_dungeon_auto_info, Rid, {7, Is_Stop}).


delete_info(Rid) ->
	ets:delete(sys_dungeon_auto_info, Rid).

insert_reward({Rid, Value, DungeonDrop}) ->
	ets:delete(sys_dungeon_auto_reward, Rid),
    ets:insert(sys_dungeon_auto_reward, {Rid, Value, DungeonDrop}).

fetch_reward(Rid) ->
	case ets:lookup(sys_dungeon_auto_reward, Rid) of 
		[] ->
			{};
		 [{_, Val, DungeonDrop}] ->
			{Val, DungeonDrop}
	end.

delete_reward(Rid) ->
	ets:delete(sys_dungeon_auto_reward, Rid).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(sys_dungeon_auto_info, [public, set, named_table, {keypos, 1}]),
    ets:new(sys_dungeon_auto_reward, [public, set, named_table, {keypos, 1}]),
    process_flag(trap_exit, true), 
    case dungeon_auto_dao:load_info() of 
    	ok ->
		    ?INFO("[~w] 副本扫荡管理启动完成 !!", [?MODULE]),
		    {ok, #state{}};
        _ ->
            ?ERR("副本扫荡管理启动失败"),
            {stop, load_failure}
	end.


%%----------------------------------------------------
%% handle_call
%%----------------------------------------------------

handle_call(_Request, _From, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% handle_info
%%----------------------------------------------------

handle_info(_Request, State) ->
    {noreply, State}.
%%----------------------------------------------------
%% handle_cast
%%----------------------------------------------------

handle_cast(_Msg, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% 系统关闭
%%----------------------------------------------------
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%---------------------------------------------------------
%% 内部函数
%%---------------------------------------------------------
