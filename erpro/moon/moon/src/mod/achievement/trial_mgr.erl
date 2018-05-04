%%----------------------------------------------------
%% 试炼场管理
%% @author bwang
%%----------------------------------------------------

-module(trial_mgr).
-behaviour(gen_server).
-export([
		start_link/0,
		update_trial_info/2,
		get_all/0,
		test/0
		]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
    }).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("link.hrl").
-include ("achievement.hrl").

%%更新角色当前修炼勋章的条件    
update_trial_info(TrialId, {Pass, FC}) ->
	%%需要先判断TrailId是否为试炼场id
	Data = case ets:lookup(sys_trial_info, TrialId) of 
				[] ->
					case Pass of 
						1 ->
							{TrialId, 1, 0, 100, FC};
						0 ->
							{TrialId, 0, 1, 0, 0}
					end;
				[{_, P, F, _, Avg_FC}] ->
					case Pass of 
						1 ->
							{TrialId, P + 1, F, erlang:round((P + 1) / (P + 1 + F) * 100), (P * Avg_FC + FC) div (P + 1)};
						0 ->
							{TrialId, P, F + 1, erlang:round(P / (P + 1 + F) * 100), Avg_FC}
					end
			end,
    ets:delete(sys_trial_info, TrialId),
    ets:insert(sys_trial_info, Data).

get_all() ->
	ets:tab2list(sys_trial_info).

test() ->
	erlang:send_after(1000, self(), save),
	?DEBUG("----"),
	self()!{save}.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(sys_trial_info, [public,set, named_table,{keypos, 1}]),
    process_flag(trap_exit, true), 
    case trial_dao:load_info() of 
    	ok ->
    		case get_all() of 
    			[] ->
    				init_trial_info();
    			_ -> ok
    		end,
    		erlang:send_after(1200000, self(), save),
		    ?INFO("[~w] 试炼场管理启动完成 !!", [?MODULE]),
		    {ok, #state{}};
        _ ->
            ?ERR("试炼场管理启动失败"),
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
handle_info(save, State) ->
	?DEBUG("--save--trial_mgr--"),
    trial_dao:save_info(),
    erlang:send_after(1200000, self(), save),
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
init_trial_info() ->
	List = [
		{10000,0,0,0,0},
		{10001,0,0,0,0},
		{10002,0,0,0,0},
		{10003,0,0,0,0},
		{10004,0,0,0,0},
		{10005,0,0,0,0},
		{10006,0,0,0,0},
		{10007,0,0,0,0},
		{10008,0,0,0,0},
		{10009,0,0,0,0},
		{10010,0,0,0,0},
		{10011,0,0,0,0},
		{10012,0,0,0,0},
		{10013,0,0,0,0}
	],
	ets:insert(sys_trial_info,List),
	trial_dao:save_info().


