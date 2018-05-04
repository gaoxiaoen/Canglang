%%----------------------------------------------------
%% 战斗直播进程
%% （对应一次播放）
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(combat_live).
-behaviour(gen_server).

-export([
        start_link/1,
        start/1
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("link.hrl").

-record(state, {
        rp_10710,
        waiting = [],       %% 在建立直播连接前，所有角色都放进等待列表
        combat_pid = 0,     %% 战斗进程
        role_pids = [],     %% 需要接收直播消息的角色进程
        mref_combat         %% 监控器：战斗进程
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
start_link(CombatPid) ->
    gen_server:start_link(?MODULE, [CombatPid], []).

start(CombatPid) ->
    gen_server:start(?MODULE, [CombatPid], []).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([CombatPid]) ->
    MrefCombat = erlang:monitor(process, CombatPid),
    State = #state{combat_pid = CombatPid, mref_combat = MrefCombat},
    %% 向指定的战斗进程注册直播管理器
    CombatPid ! {register_live, sys_env:get(srv_id)},
    erlang:send_after(8000, self(), check_connect),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(Msg, State) ->
    ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

handle_info(check_connect, State = #state{rp_10710 = undefined, combat_pid = CombatPid, waiting = Waiting}) ->
    Msg = ?L(<<"申请观看直播失败，连接超时，请稍后再试">>),
    lists:foreach(fun(RolePid) ->
                role:pack_send(RolePid, 10931, {55, Msg, []})
            end, Waiting),
    combat_live_mgr:stop_live(CombatPid),
    {stop, normal, State};
handle_info(check_connect, State) ->
    {noreply, State};

handle_info({sign_up, RolePid}, State = #state{rp_10710 = undefined, waiting = Waiting}) -> %% 连接中的时候
    Waiting1 = [RolePid | (Waiting--[RolePid])],
    {noreply, State#state{waiting = Waiting1}};
handle_info({sign_up, RolePid}, State = #state{rp_10710 = RP_10710, role_pids = RolePids}) ->
    case RP_10710 of
        undefined ->
            {noreply, State};
        _ ->
            role:apply(async, RolePid, {fun do_start_live/2, [self()]}),
            role:pack_send(RolePid, 10710, RP_10710),
            RolePids1 = [RolePid | (RolePids -- [RolePid])],
            {noreply, State#state{role_pids = RolePids1}}
    end;

%% 连接成功后往等待的所有人发送10710
handle_info({recv_live, {10710, MsgBody}}, State = #state{rp_10710 = undefined, waiting = Waiting}) ->
    lists:foreach(fun(RolePid) ->
                role:apply(async, RolePid, {fun do_start_live/2, [self()]}),
                role:pack_send(RolePid, 10710, MsgBody)
        end, Waiting),
    {noreply, State#state{rp_10710 = MsgBody, waiting = [], role_pids = Waiting}};
%% 连接成功后若还受到10710，则只更新缓存
handle_info({recv_live, {10710, MsgBody}}, State) ->
    {noreply, State#state{rp_10710 = MsgBody}};
%% 其他播报就直接发送
handle_info({recv_live, _}, State = #state{rp_10710 = undefined}) ->
    {noreply, State};
handle_info({recv_live, {Proto, MsgBody}}, State = #state{role_pids = RolePids}) ->
    lists:foreach(fun(RolePid) ->
                role:pack_send(RolePid, Proto, MsgBody)
        end, RolePids),
    {noreply, State};

%% 角色下线、顶号，退出观看直播
handle_info({exit_live, RolePid}, State = #state{role_pids = RolePids}) ->
    RolePids1 = RolePids--[RolePid],
    {noreply, State#state{role_pids = RolePids1}};

%% 战斗进程结束
handle_info({'DOWN', MrefCombat, _Type, _Object, _Reason}, State = #state{combat_pid = CombatPid, mref_combat = MrefCombat, role_pids = RolePids}) ->
    ?DEBUG("战斗进程[~w]结束，直播结束", [CombatPid]),
    combat_live_mgr:stop_live(CombatPid),
    lists:foreach(fun(RolePid) ->
                role:apply(async, RolePid, {fun do_stop_live/1, []})
            end, RolePids),
    {stop, normal, State};

handle_info(stop, State) ->
    {stop, normal, State};

handle_info(Info, State) ->
    ?ERR("收到未知消息: ~w", [Info]),
    {stop, normal, State}.

terminate(_Reason, #state{combat_pid = _CombatPid}) ->
    ?DEBUG("直播[~w]结束", [_CombatPid]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% 把直播进程保存到角色中
do_start_live(Role = #role{combat = CombatParams}, LivePid) ->
    {ok, Role#role{combat = [{live_pid, LivePid}|lists:keydelete(live_pid, 1, CombatParams)]}}.

%% 战斗结束，角色退出直播
do_stop_live(Role = #role{link = #link{conn_pid = ConnPid}, combat = CombatParams}) ->
    sys_conn:pack_send(ConnPid, 10708, {?true, <<>>}),
    {ok, Role#role{combat = lists:keydelete(live_pid, 1, CombatParams)}}.
