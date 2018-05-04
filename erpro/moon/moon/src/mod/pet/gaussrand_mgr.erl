-module(gaussrand_mgr).
-behaviour(gen_server).
-export([
		get_value/2,
		start_link/0
		]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
    }).


-include("common.hrl").


get_value(Min, Max) ->
	case Min =:= Max of 
		false ->
			Average = (Min + Max) div 2,
			Exp = (Max - Min) div 2,
			{A1, A2, A3} = erlang:now(),
			random:seed(A1, A2, A3),
			Arity = get_arity({Min, Max}),
			{X, NV2, NS, NPP} = do(Arity),
			update_arity({Min, Max}, {NV2, NS, NPP}),
			E1 = case {X < -3, X >3 } of 
					{true, _} -> -3;
					{false, true} -> 3;
					{false, false} -> X
				end,
			round(Average + Exp * E1 / 3 - 1);
		true ->
			Min
	end.

do({V2, S, PP})->
	case PP of 
		0 ->
			{X, NV2, NS} = do_circle(),
			{X, NV2, NS, 1 - PP};
		_ ->
			X = V2 * math:sqrt(-2 * math:log(S) / S),
			{X, V2, S, 1 - PP}	
	end.
		
do_circle()->
	U1 = random:uniform(),
	U2 = random:uniform(),
	V1 = 2 * U1 - 1,
	V2 = 2 * U2 - 1,
	S = V1 * V1 + V2 * V2,
	case S >= 1 orelse S == 0 of 
		true ->
			do_circle();
		false ->
			{V1 * math:sqrt(-2 * math:log(S) / S), V2, S}
	end.



start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(gaussrand_arity, [public, set, named_table, {keypos, 1}]),
    process_flag(trap_exit, true),    
    ?INFO("[~w] gaussrand启动完成 !!", [?MODULE]),
    {ok, #state{}}.
    
handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% handle_info
%%----------------------------------------------------
handle_info(_Msg, State) ->
    {noreply, State}.


%%----------------------------------------------------
%% 系统关闭
%%----------------------------------------------------
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%%----------------------------------------------------
%% internal use
%%----------------------------------------------------
update_arity(Key, Arity) ->
	ets:delete(gaussrand_arity, Key),
	ets:insert(gaussrand_arity, {Key, Arity}).
get_arity(Key) ->
	Data = ets:lookup(gaussrand_arity, Key),
	case Data of 
		[] -> {0, 0, 0};
		[{_, Arity}] ->
			Arity
	end.