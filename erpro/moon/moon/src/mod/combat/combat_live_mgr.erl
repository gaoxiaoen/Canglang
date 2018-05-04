%%----------------------------------------------------
%% 战斗直播管理器
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(combat_live_mgr).
-behaviour(gen_server).

-export([
        start_link/0,
        sign_up/2,
        recv_live/2,
        stop_live/1
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("combat.hrl").

-define(CHECK_TIME, 1000*60*60).    %% 定期检查已死亡的战斗进程

-record(state, {
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 报名看一场战斗的直播
%% CombatPid :: pid()
%% RolePid :: pid()
sign_up(CombatPid, RolePid) ->
    gen_server:cast(?MODULE, {sign_up, CombatPid, RolePid}).

%% 接收直播消息
%% CombatPid :: pid()
%% Msg :: tuple
recv_live(CombatPid, Msg) ->
    gen_server:cast(?MODULE, {recv_live, CombatPid, Msg}).

%% 停止直播
%% CombatPid :: pid()
stop_live(CombatPid) ->
    gen_server:cast(?MODULE, {stop_live, CombatPid}).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(combat_live, [set, named_table, public, {keypos, 1}]),
    State = #state{},
    erlang:send_after(?CHECK_TIME, self(), check_dead_combat_pid),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({sign_up, CombatPid, RolePid}, State) ->
    case ets:lookup(combat_live, CombatPid) of
        [{CombatPid, LivePid}] ->
            LivePid ! {sign_up, RolePid};
        _ ->
            %% 创建直播进程
            {ok, LivePid} = combat_live:start(CombatPid),
            ets:insert(combat_live, {CombatPid, LivePid}),
            LivePid ! {sign_up, RolePid}
    end,
    {noreply, State};

handle_cast({recv_live, CombatPid, Msg}, State) ->
    case ets:lookup(combat_live, CombatPid) of
        [{CombatPid, LivePid}] ->
            LivePid ! {recv_live, Msg};
        _ ->
            ignore
    end,
    {noreply, State};

handle_cast({stop_live, CombatPid}, State) ->
    ets:delete(combat_live, CombatPid),
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

handle_info(check_dead_combat_pid, State) ->
    case ets:tab2list(combat_live) of
        Lives = [_|_] ->
            lists:foreach(fun({CombatPid, LivePid}) ->
                        case util:is_process_alive(CombatPid) of
                            true -> ignore;
                            false ->
                                ets:delete(combat_live, CombatPid),
                                LivePid ! stop
                        end
                    end, Lives);
        _ -> ignore
    end,
    {noreply, State};

handle_info(Info, State) ->
    ?ERR("收到未知消息: ~w", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
