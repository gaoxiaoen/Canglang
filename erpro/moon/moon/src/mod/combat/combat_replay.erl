%%----------------------------------------------------
%% 战斗录像进程
%% （对应一次播放）
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(combat_replay).
-behaviour(gen_server).

-export([
        start_link/2
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("role.hrl").
-include("combat.hrl").

-record(state, {
        role_pid = 0,
        mref = undefined,
        replay = undefined
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
start_link(RolePid, Replay) ->
    gen_server:start_link(?MODULE, [RolePid, Replay], []).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([RolePid, Replay]) ->
    role:apply(async, RolePid, {fun do_start_playback/2, [self()]}),
    Mref = erlang:monitor(process, RolePid),
    State = #state{role_pid = RolePid, mref = Mref, replay = Replay},
    erlang:send_after(1000, self(), start_playback),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(Msg, State) ->
    ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

handle_info(start_playback, State = #state{role_pid = RolePid, replay = #combat_replay{rp_10710 = RP_10710}}) ->
    {CombatType, FighterInfos, ActionFighterIdOrderList} = RP_10710,
    role:pack_send(RolePid, 10710, {1, CombatType, ?enter_combat_type_normal, ?true, FighterInfos, ActionFighterIdOrderList}),
    erlang:send_after(2000, self(), play_10721),
    {noreply, State};

handle_info(play_10721, State = #state{role_pid = RolePid, replay = Replay = #combat_replay{rp_10721 = [RP|T]}}) ->
    role:pack_send(RolePid, 10721, RP),
    erlang:send_after(1500, self(), play_10720),
    {noreply, State#state{replay = Replay#combat_replay{rp_10721 = T}}};
handle_info(play_10721, State = #state{replay = #combat_replay{rp_10721 = []}}) ->
    self() ! play_10720,
    {noreply, State};

handle_info(play_10720, State = #state{role_pid = RolePid, replay = Replay = #combat_replay{rp_10720 = [RP|T]}}) ->
    role:pack_send(RolePid, 10720, RP),
    {_, SkillPlays, _, _, _} = RP,
    Time = calc_wait_time(SkillPlays),
    erlang:send_after(Time, self(), play_10721),
    {noreply, State#state{replay = Replay#combat_replay{rp_10720 = T}}};
handle_info(play_10720, State = #state{role_pid = RolePid, replay = #combat_replay{rp_10720 = []}}) ->
    role:pack_send(RolePid, 10708, {?true, <<>>}),
    {stop, normal, State};

handle_info(stop, State = #state{role_pid = RolePid}) ->
    role:pack_send(RolePid, 10708, {?true, <<>>}),
    {stop, normal, State};

handle_info(stop_by_login, State) ->
    %% 重新登录的就不需要发送10708协议
    {stop, normal, State};

%% 角色已断开连接
handle_info({'DOWN', Mref, _Type, _Object, _Reason}, State = #state{mref = Mref}) ->
    ?DEBUG("角色断开连接，停止播放录像"),
    {stop, normal, State};

handle_info(Info, State) ->
    ?ERR("收到未知消息: ~w", [Info]),
    {stop, normal, State}.

terminate(_Reason, _State) ->
    ?DEBUG("播放录像结束"),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% 把播放进程保存到角色中
do_start_playback(Role = #role{combat = CombatParams}, ReplayPid) ->
    case lists:keyfind(replay_pid, 1, CombatParams) of
        {replay_pid, _OldReplayPid} ->
            CombatParams1 = [{replay_pid, ReplayPid}|lists:keydelete(replay_pid, 1, CombatParams)],
            {ok, Role#role{combat = CombatParams1}};
        _ ->
            CombatParams1 = [{replay_pid, ReplayPid}|CombatParams],
            {ok, Role#role{combat = CombatParams1}}
    end.

%% 计算每个回合等待播放时间 -> 毫秒
calc_wait_time(SkillPlays) ->
    combat_util:count_skill_play(SkillPlays),
    Count = case combat_util:count_skill_play(SkillPlays)  of
        C when C > 0 -> C;
        _ -> 1
    end,
    erlang:round(Count * 2500).
