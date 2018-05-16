%%%----------------------------------------------------------0---------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十二月 2017 11:26
%%%-------------------------------------------------------------------
-module(cross_1vn_play).
-author("Administrator").
-include("server.hrl").
-include("common.hrl").
-include("cross_1vN.hrl").
-include("scene.hrl").
-include("notice.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

%% API
-export([start/4,
    kill_mon/2
%%     stop/1, back/3, change_career/3
]).

%%创建房间
%% start(RedMbList, BlueMbList, Type,Floor) ->ok.
start(RedMbList, BlueMbList, Type, Floor) ->
%%     ?DEBUG("RedMbList ~p~n", [RedMbList]),
%%     ?DEBUG("BlueMbList ~p~n", [BlueMbList]),
    SceneId = ?IF_ELSE(Type == ?CROSS_1VN_PLAY_TYPE_0, ?SCENE_ID_CROSS_1VN_WAR, ?SCENE_ID_CROSS_1VN_FINAL_WAR),
    TimeTotal = ?IF_ELSE(Type == ?CROSS_1VN_PLAY_TYPE_0, ?CROSS_1VN_PLAY_TIME, ?CROSS_1VN_FINAL_PLAY_TIME),
    gen_server:start(?MODULE, [RedMbList, BlueMbList, Type, SceneId, Floor, TimeTotal], []).

-define(SERVER, ?MODULE).

-record(state, {
    mb_list = [],
    buff_list = [],
    is_finish = 0,
    ref = 0,
    type = 0, %% 比赛类型 0资格赛 1决赛
    scene = 0, %% 比赛场景
    time_total = 0, %% 比赛总时长
    floor = 0,
    time = 0
}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


init([RedMbList, BlueMbList, Type, SceneId, Floor, TimeTotal]) ->
%%    ?DEBUG("init scuffle play ~p~n", [self()]),
    scene_init:priv_create_scene(SceneId, self()),
    spawn(fun() -> log_cross_1vn_match(Floor, RedMbList ++ BlueMbList) end),
    RedList = lists:map(fun(Mb) ->
        Mb#cross_1vn_mb{group = ?CROSS_1VN_GROUP_RED, acc_combo = 0} end, RedMbList),
    BlueList = lists:map(fun(Mb) ->
        Mb#cross_1vn_mb{group = ?CROSS_1VN_GROUP_BLUE, acc_combo = 0} end, BlueMbList),
    Ref = erlang:send_after(100, self(), ready),
    {ok, #state{mb_list = RedList ++ BlueList, ref = Ref, type = Type, floor = Floor, scene = SceneId, time_total = TimeTotal}}.


info(ready, State) ->
    Timer = 5,
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(Timer * 1000, self(), fight),
    F = fun(Mb) ->
        [Mb#cross_1vn_mb.sn, Mb#cross_1vn_mb.pkey, Mb#cross_1vn_mb.nickname, Mb#cross_1vn_mb.guild_name, Mb#cross_1vn_mb.guild_position, Mb#cross_1vn_mb.career, Mb#cross_1vn_mb.sex, Mb#cross_1vn_mb.avatar, Mb#cross_1vn_mb.group, Mb#cross_1vn_mb.cbp, Mb#cross_1vn_mb.win, Mb#cross_1vn_mb.lose, Mb#cross_1vn_mb.lv, Mb#cross_1vn_mb.hp]
    end,
    InfoList = lists:map(F, State#state.mb_list),
    {ok, Bin} = pt_642:write(64205, {State#state.time_total, InfoList}),
    F1 = fun(Mb1) ->
        if Mb1#cross_1vn_mb.pid /= none andalso Mb1#cross_1vn_mb.robot_state /= 1 ->
            center:apply(Mb1#cross_1vn_mb.node, server_send, send_to_pid, [Mb1#cross_1vn_mb.pid, Bin]);
            true -> ok
        end
    end,
    lists:foreach(F1, State#state.mb_list),

    {noreply, State#state{ref = Ref}};

%%通知玩家进入 5s准备时间
info(fight, State) ->
    Time = State#state.time_total,
    Scene = State#state.scene,
    Copy = self(),
    spawn(fun() ->
        F = fun(Mb) ->
            util:sleep(util:rand(30, 80)),
            if Mb#cross_1vn_mb.pid /= none andalso Mb#cross_1vn_mb.robot_state /= 1 ->
                ?DEBUG("Mb#cross_1vn_mb.pid ~p~n", [Mb#cross_1vn_mb.pid]),
                server_send:send_node_pid(Mb#cross_1vn_mb.node, Mb#cross_1vn_mb.pid, {enter_cross_1vn, State#state.type, State#state.floor, Copy, Mb#cross_1vn_mb.group});
                true ->
                    if
                        State#state.scene == ?SCENE_ID_CROSS_1VN_WAR ->
                            {NewX, NewY} = {19, 22},
                            %%AI创建
                            shadow:create_shadow_for_cross_1vn(Mb#cross_1vn_mb.shadow, Scene, Copy, NewX, NewY);
                        true ->
                            L = data_cross_1vn_final_wait:get(State#state.floor),
                            {NewX, NewY} = util:list_rand(L),
                            %%AI创建
                            shadow:create_shadow_for_cross_1vn(Mb#cross_1vn_mb.shadow, Scene, Copy, NewX, NewY)
                    end
            end
        end,
        lists:foreach(F, State#state.mb_list)
    end),
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(Time * 1000, self(), timeout),
    {noreply, State#state{ref = Ref, time = util:unixtime() + Time}};


%%玩家死亡
info({role_die, DieKey, AttackKey, _AccDamage}, State) when State#state.is_finish == 0 ->
    MbList =
        case lists:keytake(DieKey, #cross_1vn_mb.pkey, State#state.mb_list) of
            false ->
                State#state.mb_list;
            {value, DieMb, T} ->
                case lists:keytake(AttackKey, #cross_1vn_mb.pkey, T) of
                    false ->
                        State#state.mb_list;
                    {value, AttMb, T2} ->
                        NewDieMb = DieMb#cross_1vn_mb{war_state = 1},
                        NewAttMb = AttMb#cross_1vn_mb{acc_combo = AttMb#cross_1vn_mb.acc_combo + 1},
                        Self = self(),
                        Self ! refresh_info,
                        L = [NewDieMb, NewAttMb] ++ T2,

                        if NewAttMb#cross_1vn_mb.acc_combo > 1 ->
                            {ok, BinCombo} = pt_642:write(64231, {AttackKey, NewAttMb#cross_1vn_mb.acc_combo}),
                            center:apply_sn(NewAttMb#cross_1vn_mb.sn, server_send, send_to_pid, [NewAttMb#cross_1vn_mb.pid, BinCombo]),
                            ok;
                            true -> ok
                        end,
                        L
                end
        end,
    ?DEBUG("State#state.mb_list ~p~n", [length(State#state.mb_list)]),
    ?DEBUG("MbList ~p~n", [length(MbList)]),
    {noreply, State#state{mb_list = MbList}};

info(refresh_info, State) when State#state.is_finish == 0 ->
    {RedState, BlueState} = acc_score(State#state.mb_list),
    LeftTime = max(0, State#state.time - util:unixtime()),
    UseTime = State#state.time_total - LeftTime,
    Ret = if
              BlueState > 0 -> %%蓝色方战败
                  final(?CROSS_1VN_GROUP_RED, State#state.mb_list, UseTime, State#state.floor, State#state.type);
              RedState > 0 -> %%红色方战败
                  final(?CROSS_1VN_GROUP_BLUE, State#state.mb_list, UseTime, State#state.floor, State#state.type);
              true -> skip
          end,
    IsFinish = ?IF_ELSE(Ret == ok, 1, 0),
    {noreply, State#state{is_finish = IsFinish}};

%%挑战时间结束
info(timeout, State) when State#state.is_finish == 0 ->
    if
        State#state.type == ?CROSS_1VN_PLAY_TYPE_1 ->
            final(?CROSS_1VN_GROUP_RED, State#state.mb_list, State#state.time_total, State#state.floor, State#state.type); %% 如果是决赛，时间到擂主胜
        true ->
            PlayerList = scene_agent:get_copy_scene_player(State#state.scene, self()),
            F1 = fun(Mb, {WinGroup0, Per}) ->
                case lists:keyfind(Mb#cross_1vn_mb.pkey, #scene_player.key, PlayerList) of
                    false -> {WinGroup0, Per};
                    ScenePlayer ->
                        #attribute{
                            hp_lim = Hplim
                        } = ScenePlayer#scene_player.attribute,
                        NowPer = ScenePlayer#scene_player.hp / Hplim,
                        if
                            NowPer > Per ->
                                {Mb#cross_1vn_mb.group, NowPer};
                            true -> {WinGroup0, Per}
                        end
                end
            end,
            {WinGroup0, _} = lists:foldl(F1, {?CROSS_1VN_GROUP_RED, 0}, State#state.mb_list),
            LeftTime = max(0, State#state.time - util:unixtime()),
            UseTime = State#state.time_total - LeftTime,
            final(WinGroup0, State#state.mb_list, UseTime, State#state.floor, State#state.type)
    end,
    {noreply, State#state{is_finish = 1}};

%%离开
info({quit, Pkey}, State) ->
    case lists:keytake(Pkey, #cross_1vn_mb.pkey, State#state.mb_list) of
        false ->
            {noreply, State};
        {value, Mb, T} ->
            case T of
                [] ->
                    {stop, State};
                _ ->
                    NewMb = Mb#cross_1vn_mb{war_state = 2},
                    case [M || M <- T, M#cross_1vn_mb.group == Mb#cross_1vn_mb.group, M#cross_1vn_mb.war_state == 0] of
                        [] ->
                            if State#state.is_finish == 0 ->
                                WinGroup = ?IF_ELSE(Mb#cross_1vn_mb.group == ?CROSS_1VN_GROUP_RED, ?CROSS_1VN_GROUP_BLUE, ?CROSS_1VN_GROUP_RED),
                                LeftTime = max(0, State#state.time - util:unixtime()),
                                UseTime = State#state.time_total - LeftTime,
                                final(WinGroup, State#state.mb_list, UseTime, State#state.floor, State#state.type),
                                {noreply, State#state{mb_list = [NewMb | T], is_finish = 1}};
                                true ->
                                    {noreply, State#state{mb_list = [NewMb | T]}}
                            end;
                        _ ->
                            {noreply, State#state{mb_list = [NewMb | T]}}
                    end
            end
    end;


%%击杀对手
info({kill, DieKey, AttackKey}, State) ->
    if State#state.is_finish == 1 -> {noreply, State};
        true ->
            self() ! {role_die, DieKey, AttackKey, []},
            {noreply, State}
    end;


info(stop, State) ->
    send_out(State#state.scene),
    {stop, State};

info(_Msg, State) ->
    {noreply, State}.

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
            ?ERR("cross scuffle play handle_info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
    {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================


kill_mon(Mon, AttKey) ->
    case scene:is_cross_1vn_war_all_scene(Mon#mon.scene) of
        false -> skip;
        true ->
            Mon#mon.copy ! {kill, Mon#mon.shadow_key, AttKey}
    end.

%%初赛结算
final(WinGroup, MbList, UseTime, _Floor, ?CROSS_1VN_PLAY_TYPE_0) ->
    erlang:send_after(?SHOT_TIME * 1000, self(), stop),
    Now = util:unixtime(),
    F1 = fun(Mb) ->
        if
            Mb#cross_1vn_mb.robot_state == 1 -> skip;
            true ->
                Ret = ?IF_ELSE(WinGroup == 0, 2, ?IF_ELSE(Mb#cross_1vn_mb.group == WinGroup, 1, 2)),
                if
                    Ret == 2 -> %% 失败
                        NewMb = Mb#cross_1vn_mb{
                            war_state = 0,
                            times = Mb#cross_1vn_mb.times + 1,
                            lose = Mb#cross_1vn_mb.lose + 1,
                            combo = 0,
                            score = Mb#cross_1vn_mb.score + 1, %% 战败积分加1
                            time = Now
                        },
                        GoodsList =
                            case data_cross_1vn_floor_reward:get(NewMb#cross_1vn_mb.times, Mb#cross_1vn_mb.lv_group, Ret) of
                                [] -> [];
                                Base -> tuple_to_list(Base)
                            end,

                        {Title, Content0} = t_mail:mail_content(157),
                        Content = io_lib:format(Content0, [NewMb#cross_1vn_mb.times, get_text(Ret)]),
                        center:apply(Mb#cross_1vn_mb.node, mail, sys_send_mail, [[Mb#cross_1vn_mb.pkey], Title, Content, lists:reverse(GoodsList)]),
                        ?CAST(cross_1vn_proc:get_server_pid(), {update_mb_info, [NewMb]}),
                        {ok, Bin} = pt_642:write(64206, {Ret, Mb#cross_1vn_mb.score, 1, ?CROSS_1VN_TIMES - NewMb#cross_1vn_mb.times, goods:pack_goods(GoodsList)}),
                        center:apply(Mb#cross_1vn_mb.node, server_send, send_to_pid, [Mb#cross_1vn_mb.pid, Bin]);
                    true ->
                        NewMb = Mb#cross_1vn_mb{
                            war_state = 0,
                            times = Mb#cross_1vn_mb.times + 1,
                            win = Mb#cross_1vn_mb.win + 1,
                            combo = Mb#cross_1vn_mb.combo + 1,
                            time = Now
                        },
                        GoodsList =
                            case data_cross_1vn_floor_reward:get(NewMb#cross_1vn_mb.times, Mb#cross_1vn_mb.lv_group, Ret) of
                                [] -> [];
                                Base -> tuple_to_list(Base)
                            end,
                        Score = get_score(NewMb, UseTime),
                        {Title, Content0} = t_mail:mail_content(157),
                        Content = io_lib:format(Content0, [NewMb#cross_1vn_mb.times, get_text(Ret)]),
                        center:apply(Mb#cross_1vn_mb.node, mail, sys_send_mail, [[Mb#cross_1vn_mb.pkey], Title, Content, lists:reverse(GoodsList)]),
                        ?CAST(cross_1vn_proc:get_server_pid(), {update_mb_info, [NewMb#cross_1vn_mb{score = NewMb#cross_1vn_mb.score + Score}]}),
                        {ok, Bin} = pt_642:write(64206, {Ret, Mb#cross_1vn_mb.score, Score, ?CROSS_1VN_TIMES - NewMb#cross_1vn_mb.times, goods:pack_goods(GoodsList)}),
                        center:apply(Mb#cross_1vn_mb.node, server_send, send_to_pid, [Mb#cross_1vn_mb.pid, Bin])
                end
        end
    end,
    lists:foreach(F1, MbList),
%%     ?CAST(cross_scuffle_proc:get_server_pid(), {del_play, self()}),
    ok;

%%决赛结算
final(WinGroup, MbList, UseTime, Floor, ?CROSS_1VN_PLAY_TYPE_1) ->
    erlang:send_after(?SHOT_TIME * 1000, self(), stop),
    Lives = [X || X <- MbList, X#cross_1vn_mb.war_state == 0, X#cross_1vn_mb.group /= 1],
    LiveNumber = length(Lives),
    [SpMb | _] = [X || X <- MbList, X#cross_1vn_mb.group == 1],
    ?DEBUG("LiveNumber ~p~n", [LiveNumber]),
    F1 = fun(Mb) ->
        if
            Mb#cross_1vn_mb.robot_state == 1 -> skip;
            true ->
                Ret = ?IF_ELSE(WinGroup == 0, 2, ?IF_ELSE(Mb#cross_1vn_mb.group == WinGroup, 1, 2)),
                if
                    Ret == 2 -> %% 失败
                        NewMb = Mb#cross_1vn_mb{
                            war_state = 0,
                            is_lose = 1,
                            lose = Mb#cross_1vn_mb.lose + 1
                        },
                        ?DO_IF(NewMb#cross_1vn_mb.group == ?CROSS_1VN_GROUP_RED,
                            ?CAST(cross_1vn_proc:get_server_pid(), {update_final_mb_info, [NewMb]})),
                        GoodsList =
                            case data_cross_1vn_final_floor_reward:get(Floor, Mb#cross_1vn_mb.lv_group, Ret, Mb#cross_1vn_mb.group) of
                                [] -> [];
                                Base -> tuple_to_list(Base)
                            end,
                        {Title, Content0} = t_mail:mail_content(156),
                        Content = io_lib:format(Content0, [Floor, get_text(Ret)]),
                        center:apply(Mb#cross_1vn_mb.node, mail, sys_send_mail, [[Mb#cross_1vn_mb.pkey], Title, Content, lists:reverse(GoodsList)]),
                        {ok, Bin} = pt_642:write(64210, {Ret, Mb#cross_1vn_mb.group, Floor, SpMb#cross_1vn_mb.nickname, LiveNumber, goods:pack_goods(GoodsList)}),
                        center:apply(Mb#cross_1vn_mb.node, server_send, send_to_pid, [Mb#cross_1vn_mb.pid, Bin]);
                    true ->
                        NewMb = Mb#cross_1vn_mb{
                            war_state = 0,
                            win = Mb#cross_1vn_mb.win + 1,
                            final_floor = Floor + 1
                        },
                        GoodsList =
                            case data_cross_1vn_final_floor_reward:get(Floor, Mb#cross_1vn_mb.lv_group, Ret, Mb#cross_1vn_mb.group) of
                                [] -> [];
                                Base -> tuple_to_list(Base)
                            end,
                        {Title, Content0} = t_mail:mail_content(156),
                        Score = get_final_score(NewMb, UseTime, Floor),
                        Content = io_lib:format(Content0, [Floor, get_text(Ret)]),
                        center:apply(Mb#cross_1vn_mb.node, mail, sys_send_mail, [[Mb#cross_1vn_mb.pkey], Title, Content, lists:reverse(GoodsList)]),
                        ?DO_IF(NewMb#cross_1vn_mb.group == ?CROSS_1VN_GROUP_RED,
                            ?CAST(cross_1vn_proc:get_server_pid(), {update_final_mb_info, [NewMb#cross_1vn_mb{score = NewMb#cross_1vn_mb.score + Score}]})),
                        {ok, Bin} = pt_642:write(64210, {Ret, Mb#cross_1vn_mb.group, Floor, SpMb#cross_1vn_mb.nickname, LiveNumber, goods:pack_goods(GoodsList)}),
                        center:apply(Mb#cross_1vn_mb.node, server_send, send_to_pid, [Mb#cross_1vn_mb.pid, Bin])
                end
        end
    end,
    lists:foreach(F1, MbList),
%%     ?CAST(cross_scuffle_proc:get_server_pid(), {del_play, self()}),
    ok.

%% 初赛积分加成
get_score(Mb, UseTime) ->
    ComboScore = get_combo_score(Mb#cross_1vn_mb.combo),
    UseTimeSore = get_usetime_score(UseTime),
    10 + ComboScore + UseTimeSore.

get_combo_score(2) -> 4;
get_combo_score(3) -> 8;
get_combo_score(4) -> 12;
get_combo_score(5) -> 16;
get_combo_score(6) -> 20;
get_combo_score(_) -> 0.

get_usetime_score(Time) when Time =< 5 -> 10;
get_usetime_score(Time) when Time =< 10 -> 8;
get_usetime_score(Time) when Time =< 15 -> 6;
get_usetime_score(Time) when Time =< 20 -> 4;
get_usetime_score(Time) when Time =< 30 -> 2;
get_usetime_score(Time) when Time =< 999 -> 1.


%% 决赛积分加成
get_final_score(_Mb, UseTime, Floor) ->
    FloorScore = get_final_floor_score(Floor),
    UseTimeSore = get_final_usetime_score(UseTime),
    FloorScore + UseTimeSore.

get_final_floor_score(1) -> 15;
get_final_floor_score(2) -> 15;
get_final_floor_score(3) -> 15;
get_final_floor_score(4) -> 15;
get_final_floor_score(5) -> 15;
get_final_floor_score(6) -> 15;
get_final_floor_score(_) -> 0.

get_final_usetime_score(Time) when Time =< 5 -> 12;
get_final_usetime_score(Time) when Time =< 10 -> 10;
get_final_usetime_score(Time) when Time =< 15 -> 8;
get_final_usetime_score(Time) when Time =< 20 -> 6;
get_final_usetime_score(Time) when Time =< 30 -> 4;
get_final_usetime_score(Time) when Time =< 60 -> 2;
get_final_usetime_score(Time) when Time =< 999 -> 1.

acc_score(MbList) ->
    F = fun(Mb, {RedState, BlueState}) ->
        if Mb#cross_1vn_mb.group == ?CROSS_1VN_GROUP_RED ->
            {min(RedState, Mb#cross_1vn_mb.war_state), BlueState};
            Mb#cross_1vn_mb.group == ?CROSS_1VN_GROUP_BLUE ->
                {RedState, min(BlueState, Mb#cross_1vn_mb.war_state)};
            true ->
                {RedState, BlueState}
        end
    end,
    lists:foldl(F, {2, 2}, MbList).


%%传出
send_out(Scene) ->
    PlayerList = scene_agent:get_copy_scene_player(Scene, self()),
    F1 = fun(ScenePlayer) ->
        util:sleep(util:rand(50, 100)),
%%         center:apply(ScenePlayer#scene_player.node, cross_six_dragon, enter_dungeon_scene, [ScenePlayer#scene_player.pkey])
        server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_1vn)
    end,
    lists:foreach(F1, PlayerList).

get_text(1) -> ?T("获胜");
get_text(2) -> ?T("战败");
get_text(_) -> ?T("").

log_cross_1vn_match(Floor, MbList) ->
    F = fun(Mb) ->
        {
            Mb#cross_1vn_mb.lv_group,
            Mb#cross_1vn_mb.group,
            Mb#cross_1vn_mb.pkey,
            Mb#cross_1vn_mb.sn,
            Mb#cross_1vn_mb.final_floor,
            Mb#cross_1vn_mb.robot_state
        }
    end,
    List = lists:map(F, MbList),
    Sql = io_lib:format("insert into  log_cross_1vn_match (floor,list,node,time) VALUES(~p,'~s','~s',~p)",
        [Floor, util:term_to_bitstring(List), node(), util:unixtime()]),
    log_proc:log(Sql),
    ok.