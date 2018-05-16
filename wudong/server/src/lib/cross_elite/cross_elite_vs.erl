%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 六月 2016 19:44
%%%-------------------------------------------------------------------
-module(cross_elite_vs).
-author("hxming").

-behaviour(gen_server).

-include("cross_elite.hrl").
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
    vs_list = [],
    is_finish = 0,
    ref = 0,
    time = 0
}).
-define(SERVER, ?MODULE).

-define(SHOT_TIME, 15000).
-define(TIMER, 120).

%%出生点
-define(POS_LIST, [{14, 30}, {22, 22}]).
%% API
-export([start/1, stop/1]).

%%创建房间
start(VsList) ->
    gen_server:start(?MODULE, [VsList], []).

%%停止
stop(Pid) ->
    case is_pid(Pid) of
        false -> skip;
        true ->
            Pid ! close
    end.

init([VsList]) ->
    Ref = erlang:send_after(100, self(), ready),
    scene_init:priv_create_scene(?SCENE_ID_CROSS_ELITE,self()),
    {ok, #state{vs_list = VsList, ref = Ref}}.


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
            ?ERR("cross elite vs handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.


terminate(_Reason, _State) ->
    misc:cancel_timer([_State#state.ref]),
%%    scene_agent:clean_scene_area(?SCENE_ID_CROSS_ELITE, self()),
    scene_init:priv_stop_scene(?SCENE_ID_CROSS_ELITE,self()),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

info(ready, State) ->
    Timer = 3,
    F = fun(Gamer) ->
        [Gamer1 | _] = lists:keydelete(Gamer#ce_vs.key, #ce_vs.key, State#state.vs_list),
        {ok, Bin} = pt_580:write(58006, {Timer, Gamer1#ce_vs.name, Gamer1#ce_vs.career, Gamer1#ce_vs.sex, Gamer1#ce_vs.lv, Gamer1#ce_vs.cbp, Gamer1#ce_vs.avatar, Gamer1#ce_vs.key}),
        ?DO_IF(Gamer#ce_vs.pid /= none,
            server_send:send_to_sid(Gamer#ce_vs.node, Gamer#ce_vs.sid, Bin)
%%            center:apply(Gamer#ce_vs.node, server_send, send_to_sid, [Gamer#ce_vs.sid, Bin])
        )
        end,
    lists:foreach(F, State#state.vs_list),
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(Timer * 1000, self(), fight),
    {noreply, State#state{ref = Ref}};

%%通知玩家进入
info(fight, State) ->
    F = fun(Gamer, [{X, Y} | L]) ->
        if Gamer#ce_vs.type == 0 ->
            server_send:send_node_pid(Gamer#ce_vs.node, Gamer#ce_vs.pid, {enter_cross_elite, self(), X, Y});
            true ->
                shadow:create_shadow_for_cross_elite(Gamer#ce_vs.shadow, ?SCENE_ID_CROSS_ELITE, self(), X, Y)
        end,
        L
        end,
    lists:foldl(F, ?POS_LIST, State#state.vs_list),
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(?TIMER * 1000, self(), timeout),
    {noreply, State#state{ref = Ref, time = util:unixtime() + ?TIMER}};

%%获取我的挑战信息58007
info({vs_info, Pkey}, State) ->
    case lists:keyfind(Pkey, #ce_vs.key, State#state.vs_list) of
        false -> skip;
        Gamer ->
            [Gamer1 | _] = lists:keydelete(Gamer#ce_vs.key, #ce_vs.key, State#state.vs_list),
            Now = util:unixtime(),
            LeftTime = max(0, State#state.time - Now),
            {ok, Bin} = pt_580:write(58007, {LeftTime, Gamer1#ce_vs.key, Gamer1#ce_vs.career, Gamer1#ce_vs.sex, Gamer1#ce_vs.hp, Gamer1#ce_vs.avatar}),
            ?DO_IF(Gamer#ce_vs.type == 0,
                server_send:send_to_sid(Gamer#ce_vs.node, Gamer#ce_vs.sid, Bin)
%%                center:apply(Gamer#ce_vs.node, server_send, send_to_sid, [Gamer#ce_vs.sid, Bin])
            )
    end,
    {noreply, State};

%%玩家死亡
info({die, DieKey}, State) ->
    if State#state.is_finish == 1 ->
        {noreply, State};
        true ->
            case lists:keytake(DieKey, #ce_vs.key, State#state.vs_list) of
                false ->
                    {noreply, State};
                {value, Die, [Killer | _]} ->
                    util:cancel_ref([State#state.ref]),
                    Ref = erlang:send_after(?SHOT_TIME, self(), stop),
                    game_over(Killer, Die),
                    {noreply, State#state{is_finish = 1, ref = Ref}}
            end
    end;

%%挑战时间结束
info(timeout, State) ->
    if State#state.is_finish == 1 ->
        {noreply, State};
        true ->
            util:cancel_ref([State#state.ref]),
            Ref = erlang:send_after(?SHOT_TIME, self(), stop),
            [M1, M2] = State#state.vs_list,
            %%战力低的胜利
            if M1#ce_vs.cbp < M2#ce_vs.cbp ->
                game_over(M1, M2);
                true ->
                    game_over(M2, M1)
            end,
            {noreply, State#state{is_finish = 1, ref = Ref}}
    end;

%%玩家掉线,判断结果
info({logout, Pkey}, State) ->
    if State#state.is_finish == 1 ->
        {noreply, State};
        true ->
            case lists:keytake(Pkey, #ce_vs.key, State#state.vs_list) of
                false ->
                    self() ! stop,
                    {noreply, State};
                {value, Gamer, [Gamer1 | _]} ->
                    game_over(Gamer1, Gamer#ce_vs{pid = none}),
                    util:cancel_ref([State#state.ref]),
                    Ref = erlang:send_after(?SHOT_TIME, self(), stop),
                    {noreply, State#state{is_finish = 1, ref = Ref}}
            end
    end;


info(close, State) ->
    info(timeout, State);
%%    if State#state.is_finish == 1 ->
%%        {noreply, State};
%%        true ->
%%            {ok, Bin} = pt_580:write(58008, {2, 0, 0}),
%%            F = fun(Gamer) ->
%%                ?DO_IF(Gamer#ce_vs.type == 0, center:apply(Gamer#ce_vs.node, server_send, send_to_sid, [Gamer#ce_vs.sid, Bin]))
%%                end,
%%            lists:foreach(F, State#state.vs_list),
%%            info(stop, State)
%%    end;

info(stop, State) ->
    send_out(),
    {stop, State};

info(_Msg, State) ->
    {noreply, State}.


%%传出
send_out() ->
    PlayerList = scene_agent:get_copy_scene_player(?SCENE_ID_CROSS_ELITE, self()),
    F1 = fun(ScenePlayer) ->
        server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_elite)
         end,
    lists:foreach(F1, PlayerList).


%%比赛结算
game_over(Win, Lose) ->
    ?DO_IF(Win#ce_vs.type == 0, center:apply(Win#ce_vs.node, cross_elite, cross_elite_msg, [1, Win#ce_vs.key])),
    ?DO_IF(Lose#ce_vs.type == 0, center:apply(Lose#ce_vs.node, cross_elite, cross_elite_msg, [0, Lose#ce_vs.key])),
    ok.
