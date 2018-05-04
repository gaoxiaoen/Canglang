%%----------------------------------------------------
%% 春节巡游NPC管理
%% @author jackguan@jieyou.cn
%% @end
%%----------------------------------------------------
-module(campaign_npc_mgr).
-behaviour(gen_fsm).
-export([
        start_link/0
        ,npc_move_over/1
        ,stop/0
        ,next/1
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([
        idel/2
        ,npc_over/2
    ]
).

-include("common.hrl").
-include("npc.hrl").

-define(START_TIME, util:datetime_to_seconds({{2013, 2, 1}, {0, 0, 1}})).   %% 开始时间
-define(END_TIME, util:datetime_to_seconds({{2013, 3, 20}, {23, 59, 59}})). %% 结束时间
-define(timeout_val, 5000). %% 超时值

-record(state, {
        ts = 0            %% 进入某状态时刻
        ,timeout_val = 0  %% 空闲时间
        ,npc_status = 0   %% 0:移除 1:创建
        ,npc_id = 0       %% NpcId
    }).

%%------------------------------------
%% 对外接口
%%------------------------------------
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% NPC移动到终点
npc_move_over(NpcId) ->
    gen_fsm:send_all_state_event(?MODULE, {npc_over_over, NpcId}).

%% 下一个状态
next(Event) ->
    gen_fsm:send_event(?MODULE, Event).

stop() ->
    gen_fsm:send_all_state_event(?MODULE, stop).

%%------------------------------------
%% 系统函数
%%------------------------------------
init([])->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    case get_idel_time() of
        {idel, T} ->
            ?INFO("[~w] 启动完成idel:~p", [?MODULE, T]),
            {ok, idel, #state{npc_id = undefined, ts = erlang:now(), timeout_val = T}, T};
        {npc_over, _T} ->
            ?INFO("[~w] 启动完成npc_over:~p", [?MODULE, _T]),
            {ok, idel, #state{npc_id = undefined, ts = erlang:now(), timeout_val = (5 * 1000)}, (5 * 1000)}
    end.

handle_event({npc_over_over, NpcId}, StateName, State) ->
    case StateName of
        npc_over -> 
            ?DEBUG("巡游NPC到达终点"),
            npc:stop(NpcId),
            erlang:send_after(5 * 1000, self(), {create_npc});
        _ -> ignore
    end,
    continue(npc_over, State#state{npc_id = undefined});

handle_event(stop, _StateName, State) ->
    {stop, normal, State};
handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

handle_info({create_npc}, npc_over, State) ->
    case create_npc() of
        {ok, NpcId} ->
            continue(npc_over, State#state{npc_id = NpcId});
        false -> 
            continue(npc_over, State#state{npc_id = undefined})
    end;

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

terminate(normal, _StateName, _State) ->
    ?INFO("春节巡游NPC进程正常关闭"),
    ok;
terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%------------------------------------
%% 状态处理函数 
%%------------------------------------
%% 空闲状态结束
idel(timeout, State) ->
    case get_idel_time() of
        {idel, T} ->
            {next_state, idel, State#state{npc_id = undefined, ts = erlang:now(), timeout_val = T}, T};
        {npc_over, T} ->
            case create_npc() of
                {ok, NpcId} ->
                    ?DEBUG("创建巡游NPC"),
                    {next_state, npc_over, State#state{npc_id = NpcId, ts = erlang:now(), timeout_val = T}, T};
                false ->
                    {next_state, idel, State#state{npc_id = undefined, ts = erlang:now(), timeout_val = 86400}, 86400}
            end
    end;
idel(_Event, State) ->
    continue(idel, State).

npc_over(timeout, State = #state{npc_id = NpcId}) when is_integer(NpcId) ->
    ?DEBUG("春节巡游NPC到达终点"),
    npc:stop(NpcId),
    {next_state, idel, State#state{npc_id = undefined, ts = erlang:now(), timeout_val = 86400}, 86400};
npc_over(timeout, State) ->
    ?DEBUG("春节巡游NPC到达终点"),
    {next_state, idel, State#state{npc_id = undefined, ts = erlang:now(), timeout_val = 86400}, 86400};
npc_over(_Event, State) ->
    continue(npc_over, State).

%%------------------------------------
%% 内部处理函数 
%%------------------------------------
%% 获取空闲时间 - 状态机为毫秒
get_idel_time() ->
    Now = util:unixtime(),
    {St, T}= case {?START_TIME < Now, Now < ?END_TIME} of
        {false, _} ->
            {idel, (?START_TIME - Now)}; %% 时间还没到
        {true, true} ->
            {npc_over, (?END_TIME - Now)}; %% 活动期间
        {_, false} ->
            {idel, 86400}
    end,
    {St, T * 1000}.

continue(StateName, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {next_state, StateName, State, util:time_left(TimeVal, Ts)}.
%% continue(StateName, Reply, State = #state{ts = Ts, timeout_val = TimeVal}) ->
%%     {reply, Reply, StateName, State, util:time_left(TimeVal, Ts)}.

%% 创建NPC ok | false
create_npc() ->
    case npc_mgr:create(11236, 10003, 1054, 5845, [[{1020, 5820}, {1320, 5670}, {1620, 5520}, {1800, 5310}, {2100, 5160}, {2400, 5010}, {2700, 4860}, {3000, 4710}, {3300, 4560}, {3540, 4230}, {3840, 4080}, {4140, 3930}, {4500, 3750}, {4500, 3510}, {4500, 3270}, {4320, 3030}, {4020, 2880}, {3540, 2490}, {3180, 2310}, {2820, 2130}, {2460, 1950}, {1920, 1560}, {1800, 1440}, {1800, 1350},{1920, 1440}, {2040, 1470}, {2580, 1890}, {2880, 2070}, {3180, 2220}, {3420, 2370}, {3660, 2520}, {3900, 2700}, {4200, 2940}, {4560, 3120}, {5040, 3210}, {5520, 3210},{5760, 3390}, {5700, 3480}, {5760, 3900}, {6060, 4050}, {6300, 4200}, {6540, 4410}, {6840, 4560}, {7080, 4710}, {7440, 4890}, {7800, 5070}, {8160, 5250},{8400, 5400}, {8880, 5760}, {8640, 5580}, {9180, 5940}, {9420, 6090}, {9120, 5940}, {8820, 5790}, {8520, 5640}, {8220, 5460}, {7980, 5250}, {7680, 5040}, {7320, 4860}, {6960, 4680}, {6600, 4500}, {6240, 4320}, {6000, 4080}, {5700, 3840}, {5700, 3240}, {6000, 3030},{6360, 2820}, {6600, 2730}, {6840, 2640}, {7020, 2520}, {7260, 2370}, {7500, 2250}, {7800, 2100}, {8100, 1950}, {8400, 1800}, {8640, 1650}, {8940, 1530}, {9180, 1380}, {9360, 1230}, {9540, 1050}, {9660, 870}, {9660, 690}, {9540, 540}, {9300, 540}, {9120, 690}, {9240, 870}, {9360, 1080}, {9240, 1350}, {9000, 1530}, {8700, 1650}, {8400, 1830}, {8100, 1980}, {7800, 2130}, {7500, 2280}, {7260, 2400}, {7020, 2550}, {6780, 2670}, {6480, 2820}, {6180, 2970}, {5880, 3120}, {5760, 3330}, {5640, 3540}, {5460, 3690}, {5220, 3780}, {4920, 3780}, {4680, 3690}, {4440, 3660}, {4200, 3720}, {3960, 3840}, {3780, 3990}, {3600, 4200}, {3360, 4410}, {3120, 4620}, {2820, 4770}, {2520, 4920}, {2160, 5100}, {1860, 5280}, {1620, 5460}, {1380, 5640}, {1140, 5640}, {900, 5580}, {720, 5760}]]) of
        {ok, NpcId} -> {ok, NpcId};
        _Err ->
            ?ERR("创建巡游NPC失败"),
            false
    end.
