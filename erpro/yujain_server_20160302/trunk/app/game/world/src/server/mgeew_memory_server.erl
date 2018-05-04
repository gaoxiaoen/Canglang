%%% -------------------------------------------------------------------
%%% Author  : caochuncheng2002@gmail.com
%%% Description :
%%% 游戏内存数据管理进程
%%% Created : 2013-12-2
%%% -------------------------------------------------------------------
-module(mgeew_memory_server).

-behaviour(gen_server).

-include("mgeew.hrl").

-export([
		 start/0, 
		 start_link/0
		 ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

start() ->
    {ok, _} = supervisor:start_child(mgeew_sup, {?MODULE, {?MODULE, start_link, []},
                                                 permanent, 30000, worker, [?MODULE]}).
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    erlang:process_flag(trap_exit, true),
	%% 缓存当前服务器玩家国家Id分布数据
	ets:new(?ETS_FACTION_ROLE, [named_table, public, set, {keypos, #r_faction_role.faction_id}]),
	init_faction_role_data(),
    {ok, #state{}}.

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

do_handle_info({add_faction_role_number,Info}) ->
	do_add_faction_role_number(Info);

do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;

do_handle_info(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).


%% 初始化国家玩家人数内存数据
init_faction_role_data() ->
    lists:foreach(
      fun(FactionId) ->
              Num = erlang:length(db_api:dirty_match_object(?DB_ROLE_BASE, #p_role_base{faction_id=FactionId, _='_'})),
              ets:insert(?ETS_FACTION_ROLE, #r_faction_role{faction_id=FactionId, number=Num})
      end, [?FACTION_ID_1,?FACTION_ID_2,?FACTION_ID_3]),    
    ok.
%% 增加一个国家人数操作
do_add_faction_role_number({FactionId,AddNumber}) ->
	case FactionId =:= ?FACTION_ID_1 orelse FactionId =:= ?FACTION_ID_2 orelse FactionId =:= ?FACTION_ID_3 of
		true ->
			case ets:lookup(?ETS_FACTION_ROLE, FactionId) of
				[FactionRoleInfo] when erlang:is_record(FactionRoleInfo, r_faction_role) ->
					ets:delete(?ETS_FACTION_ROLE, FactionId),
					ets:insert(?ETS_FACTION_ROLE, #r_faction_role{faction_id=FactionId,
																  number = FactionRoleInfo#r_faction_role.number + AddNumber});
				_ ->
					ets:insert(?ETS_FACTION_ROLE, #r_faction_role{faction_id=FactionId,number = AddNumber})
			end;
		_ ->
			ignore
	end.
