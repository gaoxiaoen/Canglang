%% -------------------------------------------------------------------
%% Description : 帮战机器人
%% Author  : abu
%% -------------------------------------------------------------------
-module(guild_war_npc).

-behaviour(gen_server).

%% export functions
-export([
        start_link/1

        ,create_npc/1       %% 创建机器人
        ,clear_npc/0        %% 清理机器人
        ,action/2           %% 机器人行为

        ,info/0
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

%% record
-record(state, {npcs = [], war_map, role_count = 0, avg_lev = 0}). 
-record(guild_war_npc, {npc_id, npc_status, status_change_time, attack_elem}).

%% macro
-define(white_npcs, [22400, 22401, 22402, 22403, 22404, 22405, 22406, 22407, 22408, 22409]).

%% 路径
-define(paths, [{3, [{480, 5490}, {480, 5370}, {480, 5280}, {540, 5190}, {600, 5070}, {720, 4980}, {780, 4890}, {840, 4800}, {900, 4710}, {960, 4620}, {1020, 4530}, {1080, 4440}, {1140, 4350}, {1200, 4230}, {1200, 4110}, {1260, 3990}, {1260, 3870}, {1260, 3750}, {1260, 3630}, {1260, 3510}, {1260, 3390}, {1260, 3270}, {1260, 3150}, {1260, 3030}, {1260, 2910}, {1260, 2790}, {1260, 2670}, {1260, 2580}]}
        ,{1, [{840, 5700}, {1020, 5700}, {1200, 5730}, {1380, 5700}, {1560, 5700}, {1740, 5700}, {1920, 5670}, {2040, 5610}, {2220, 5550}, {2340, 5490}, {2520, 5430}, {2700, 5370}, {2880, 5370}, {3060, 5340}, {3180, 5280}, {3360, 5220}, {3540, 5190}, {3720, 5160}, {3840, 5100}, {4020, 5010}, {4200, 4920}, {4320, 4830}, {4440, 4740}, {4560, 4650}, {4680, 4560}, {4860, 4470}, {5040, 4410}, {5160, 4350}, {5340, 4320}]}
        ,{2, [{1980, 4590}, {2100, 4500}, {2220, 4380}, {2340, 4290}, {2400, 4170}, {2520, 4080}, {2580, 3960}, {2700, 3840}, {2820, 3720}, {2940, 3600}, {3060, 3510}, {3240, 3450}, {3360, 3390}, {3480, 3300}, {3600, 3210}, {3720, 3120}]}
    ]).

%% include
-include("common.hrl").
-include("guild_war.hrl").
-include("npc.hrl").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link(#guild_war{war_map = WarMap}) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [WarMap], []).

%% @spec create_npc(#guild_war{}) 
%% 产生机器人
create_npc(#guild_war{opp_flag = ?false, roles = Groles}) ->
    {Rcount, AvgLev} = get_rcount_avglev(Groles),
    async_apply({fun handle_create_npc/3, [Rcount, AvgLev]});
create_npc(_) ->
    ok.

handle_create_npc(State = #state{}, Rcount, AvgLev) ->
    CreateCount = max(10, min(50, util:floor(Rcount / 10))),
    NpcBaseId = get_closed_npc(AvgLev, ?white_npcs),
    ?debug_log([create_npc, {CreateCount, NpcBaseId}]),
    NewState = do_handle_create_npc(NpcBaseId, CreateCount, State),
    {noreply, NewState}.

do_handle_create_npc(_, 0, State) ->
    State;
do_handle_create_npc(NpcBaseId, Count, State = #state{npcs = Npcs, war_map = {_, Mid}}) ->
    {ElemNo, Paths = [{X, Y} | _]} = util:rand_list(?paths),
    case npc_mgr:create(NpcBaseId, Mid, X, Y, Paths) of
        {ok, NpcId} ->
            NewState = State#state{npcs = [#guild_war_npc{npc_id = NpcId, npc_status = patrol, status_change_time = util:unixtime(), attack_elem = ElemNo} | Npcs]},
            do_handle_create_npc(NpcBaseId, Count - 1, NewState);
        _ ->
            do_handle_create_npc(NpcBaseId, Count - 1, State)
    end.

%% clear_npc()
%% 清空npc
clear_npc() ->
    async_apply({fun handle_clear_npc/1, []}).

handle_clear_npc(State = #state{npcs = Npcs}) ->
    Fun = fun(#guild_war_npc{npc_id = NpcId}) ->
            npc:stop(NpcId) 
    end,
    lists:foreach(Fun, Npcs),
    {noreply, State#state{npcs = []}}.

%% action(_Type, _NpcId)
%% 机器人的行为回调
action(Type, NpcId) ->
    async_apply({fun handle_action/2, [{Type, NpcId}]}).

%% 机器人被创建
handle_action(State = #state{}, {create, _NpcId}) ->
    ?debug_log([npc_created, _NpcId]),
    {noreply, State};
%% 机器人进入战斗
handle_action(State = #state{npcs = Npcs}, {combat, NpcId}) ->
    NewNpcs = case lists:keyfind(NpcId, #guild_war_npc.npc_id, Npcs) of
        Gnpc = #guild_war_npc{} ->
            lists:keyreplace(NpcId, #guild_war_npc.npc_id, Npcs, Gnpc#guild_war_npc{npc_status = combat, status_change_time = util:unixtime()});
        _ ->
            Npcs
    end,
    {noreply, State#state{npcs = NewNpcs}};
%% 机器人被击杀
handle_action(State = #state{npcs = Npcs}, {kill, NpcId}) ->
    {noreply, State#state{npcs = lists:keydelete(NpcId, #guild_war_npc.npc_id, Npcs)}};
%% 机器人开始点击晶石
handle_action(State = #state{npcs = Npcs}, {attack_elem, NpcId}) ->
    NewNpcs = case lists:keyfind(NpcId, #guild_war_npc.npc_id, Npcs) of
        #guild_war_npc{npc_status = attack_elem} ->
            Npcs;
        Gnpc = #guild_war_npc{} ->
            ?debug_log([attack_elem, NpcId]),
            lists:keyreplace(NpcId, #guild_war_npc.npc_id, Npcs, Gnpc#guild_war_npc{npc_status = attack_elem, status_change_time = util:unixtime()});
        _ ->
            Npcs
    end,
    {noreply, State#state{npcs = NewNpcs}};

handle_action(State, _) ->
    {noreply, State}.

%% 打印进程信息
info() ->
    async_apply({fun handle_debug_info/1, []}).

handle_debug_info(State = #state{npcs = _Npcs}) ->
    ?debug_log([npcs, _Npcs]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([WarMap]) ->
    process_flag(trap_exit, true),
    erlang:send_after(1000, self(), {check}),
    {ok, #state{war_map = WarMap}}.

%% @spec: handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages

%% 定时检查
handle_info({check}, State = #state{npcs = Npcs}) ->
    erlang:send_after(1000, self(), {check}),
    NewNpcs = lists:map(
        fun(Npc = #guild_war_npc{npc_id = _NpcId, npc_status = attack_elem, status_change_time = Stime, attack_elem = ElemNo}) ->
                case Stime + 20 =< util:unixtime() of
                    true ->
                        ?debug_log([guild_war_npc_destroy, _NpcId]),
                        guild_war_elem:destroy(ElemNo),
                        Npc#guild_war_npc{status_change_time = util:unixtime()};
                    false ->
                        Npc
                end;
            (Npc) ->
                Npc
        end, 
        Npcs),
    {noreply, State#state{npcs = NewNpcs}};

%% 异步处理
handle_info({async_apply, Mfa}, State) ->
    do_async_apply(Mfa, State);

handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

%% 向进程发送消息
send_info(Msg) ->
    case whereis(?MODULE) of
        Pid when is_pid(Pid) ->
            ?MODULE ! Msg;
        _ ->
            ok
    end.
    

%% 发送异步执行消息
async_apply(Mfa) ->
    send_info({async_apply, Mfa}).

do_async_apply({F, A}, State) ->
    erlang:apply(F, [State | A]);
do_async_apply({M, F, A}, State) ->
    erlang:apply(M, F, [State | A]);
do_async_apply(_, State) ->
    {noreply, State}.

%% 取人数与平均等级
get_rcount_avglev(Groles) ->
    get_rcount_avglev(Groles, {0, 0}).
get_rcount_avglev([], {Rcount, Levs}) ->
    {Rcount, util:floor(Levs / Rcount)};
get_rcount_avglev([#guild_war_role{lev = Lev} | T], {Rcount, Levs}) ->
    get_rcount_avglev(T, {Rcount + 1, Levs + Lev}).

%% 取等级相距最近的机器人
get_closed_npc(_Lev, []) ->
    22400;
get_closed_npc(Lev, [H | T]) ->
    case npc_data:get(H) of
        {ok, #npc_base{lev = L}} ->
            case abs(Lev - L) < 3 of
                true ->
                    H;
                false ->
                    get_closed_npc(Lev, T)
            end;
        _ ->
            get_closed_npc(Lev, T)
    end.

