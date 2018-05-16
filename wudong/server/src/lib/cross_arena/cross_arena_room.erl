%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%     竞技场挑战
%%% @end
%%% Created : 21. 六月 2016 15:37
%%%-------------------------------------------------------------------
-module(cross_arena_room).
-author("hxming").

-include("dungeon.hrl").

-behaviour(gen_server).

-include("cross_arena.hrl").
-include("scene.hrl").
-include("common.hrl").

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-record(state, {
    pkey = 0,   %%挑战玩家key
    ekey = 0,    %%被挑战玩家key
    dun_arena = [],
    ref = 0,
    time = 0,
    is_finish = 0
}).
-define(SERVER, ?MODULE).

%% API
-export([start/3, stop/1, logout/1, quit/1, kill_mon/1, dungeon_target/3]).

-define(TIMER, 90).
-define(CLOSE_TIME, 15000).

%%创建房间
start(Pkey, Key, DunArena) ->
    gen_server:start(?MODULE, [Pkey, Key, DunArena], []).

%%停止
stop(Pid) ->
    case is_pid(Pid) of
        false -> skip;
        true ->
            Pid ! close
    end.

logout(Copy) ->
        catch Copy ! logout.

quit(Copy) ->
        catch Copy ! quit.

dungeon_target(Node, Copy, Sid) ->
        catch Copy ! {dungeon_target, Node, Sid}.

%%击杀怪物
kill_mon(Mon) ->
    case scene:is_cross_arena_scene(Mon#mon.scene) of
        false -> skip;
        true ->
            Mon#mon.copy ! {kill, Mon#mon.shadow_key}
    end.


init([Pkey, Key, InfoList]) ->
    scene_init:priv_create_scene(?SCENE_ID_CROSS_ARENA, self()),
    Ref = erlang:send_after(?TIMER * 1000, self(), timeout),
    {ok, #state{pkey = Pkey, ekey = Key, dun_arena = InfoList, time = ?TIMER + util:unixtime(), ref = Ref}}.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.


handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(Request, State) ->
    case catch info(Request, State) of
        {stop, NewState} ->
            {stop, normal, NewState};
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross arena handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.


terminate(_Reason, _State) ->
    misc:cancel_timer([_State#state.ref]),
    [monster:stop_broadcast(Pid) || Pid <- mon_agent:get_scene_mon_pids(?SCENE_ID_CROSS_ARENA, self())],
    scene_init:priv_stop_scene(?SCENE_ID_CROSS_ARENA, self()),
%%    scene_agent:clean_scene_area(?SCENE_ID_CROSS_ARENA, self()),

    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================


%%击杀对手
info({kill, Pkey}, State) ->
    if State#state.is_finish == 1 -> {noreply, State};
        true ->
            misc:cancel_timer([State#state.ref]),
            Ret = if Pkey =/= State#state.pkey -> 1; true -> 0 end,
            cross_arena_proc:get_server_pid() ! {arena_challenge_ret, State#state.pkey, State#state.ekey, Ret},
            Ref = erlang:send_after(?CLOSE_TIME, self(), stop),
            {noreply, State#state{is_finish = 1, ref = Ref}}
    end;

%%挑战时间结束
info(timeout, State) ->
    if State#state.is_finish == 1 -> {noreply, State};
        true ->
            misc:cancel_timer([State#state.ref]),
            cross_arena_proc:get_server_pid() ! {arena_challenge_ret, State#state.pkey, State#state.ekey, 0},
            Ref = erlang:send_after(?CLOSE_TIME, self(), stop),
            {noreply, State#state{is_finish = 1, ref = Ref}}
    end;

%%玩家掉线,判断结果
info(logout, State) ->
    if State#state.is_finish == 1 -> {noreply, State};
        true ->
            misc:cancel_timer([State#state.ref]),
            cross_arena_proc:get_server_pid() ! {arena_challenge_ret, State#state.pkey, State#state.ekey, 0},
            Ref = erlang:send_after(?CLOSE_TIME, self(), stop),
            {noreply, State#state{is_finish = 1, ref = Ref}}
    end;

%%离开
info(quit, State) ->
    if State#state.is_finish == 1 ->
        info(stop, State);
        true ->
            {noreply, State}
    end;

info(stop, State) ->
    send_out(),
    {stop, State};

info({dungeon_target, Node, Sid}, State) ->
    Now = util:unixtime(),
    LeftTime = max(0, State#state.time - Now),
    F = fun(DunArena) ->
        [DunArena#dun_arena.pkey, DunArena#dun_arena.nickname, DunArena#dun_arena.career, DunArena#dun_arena.sex,
            DunArena#dun_arena.avatar, DunArena#dun_arena.hp_lim, DunArena#dun_arena.cbp]
        end,
    {ok, Bin} = pt_231:write(23112, {LeftTime, lists:map(F, State#state.dun_arena)}),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};


info(_Msg, State) ->
    {noreply, State}.


send_out() ->
    PlayerList = scene_agent:get_copy_scene_player(?SCENE_ID_CROSS_ARENA, self()),
    F1 = fun(ScenePlayer) ->
        server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_arena)
         end,
    lists:foreach(F1, PlayerList).
