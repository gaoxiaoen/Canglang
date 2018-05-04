%%----------------------------------------------------
%% 随意奖励管理
%% @author bwang
%%----------------------------------------------------

-module(random_award_mgr).
-behaviour(gen_server).
-export([
		start_link/0,
		get_cur_cond/1,
		update_cur_cond/2
		]).



-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
    }).

-include("common.hrl").
-include("role.hrl").
-include("random_award.hrl").

update_cur_cond(Rid, Condition) ->
    ets:delete(random_award, Rid),
    ets:insert(random_award, {Rid, Condition}),
    random_award_mgr ! {update_cond, Rid, Condition},
    ok.


get_cur_cond(#role{id = {Rid, _}}) ->
    case ets:lookup(random_award, Rid) of 
        [{_, Cond}]->
            Cond;
        _ ->
            Cond = random_award_data:get_random_cond(),
            update_cur_cond(Rid, Cond),
            Cond
    end.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(random_award, [public, set, named_table, {keypos, 1}]),
    process_flag(trap_exit, true), 
    case load_cond() of 
    	ok ->
		    ?INFO("[~w] 随意奖励系统启动完成 !!", [?MODULE]),
		    {ok, #state{}};

		_ ->
			?ERR("随意奖励系统启动失败"),
			{stop, load_failure}
	end.
    
handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% handle_info
%%----------------------------------------------------

%% 定时保存数据
handle_info({update_cond, Rid, Condition}, State) ->
    update_cond(Rid, Condition),
    {noreply, State};

handle_info(_Request, State) ->
    {noreply, State}.


%%----------------------------------------------------
%% 系统关闭
%%----------------------------------------------------
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

update_cond(Rid, Condition) ->
    Sql = "replace into sys_random_mgr (rid, value) values(~s, ~s)",
    db:execute(Sql, [Rid, util:term_to_string(Condition)]),
    ok.

load_cond() -> 
    Sql = "select rid, value from sys_random_mgr",
    case db:get_all(Sql, []) of
        {ok, Data} ->
            % ?DEBUG("--Data---:~w~n",[Data]),
            do_format(to_award_cond, Data),            
            ok;
        {error, undefined} -> 
            false;
        _ ->
            false
    end.

do_format(to_award_cond, []) -> ok;
do_format(to_award_cond, [[Rid, Condition] | T]) ->
    {ok, Cond} = util:bitstring_to_term(Condition),
    update_cur_cond(Rid, Cond),
    do_format(to_award_cond, T).





