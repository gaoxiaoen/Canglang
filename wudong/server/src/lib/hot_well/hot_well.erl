%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 五月 2017 下午8:07
%%%-------------------------------------------------------------------
-module(hot_well).
-author("fengzhenlin").
-include("hot_well.hrl").
-include("server.hrl").
-include("common.hrl").
-include("scene.hrl").

%% API
-compile(export_all).

get_state(Node, Pkey, Sid) ->
    ?CAST(hot_well_proc:get_server_pid(), {get_state, Pkey, Sid, Node}).

get_info(Node, Pkey, Sid) ->
    ?CAST(hot_well_proc:get_server_pid(), {get_info, Node, Pkey, Sid}).

apply_sx(Node, Pkey, Sid) ->
    ?CAST(hot_well_proc:get_server_pid(), {apply_sx, Node, Pkey, Sid}).

stop_sx(Pkey, Sid) ->
    ?CAST(hot_well_proc:get_server_pid(), {stop_sx, Pkey, Sid}).

start_sx(Node, Pkey, Sid) ->
    ?CAST(hot_well_proc:get_server_pid(), {start_sx, Node, Pkey, Sid}).

invite_sx(Node, Mkey, Msid, Okey) ->
    ?CAST(hot_well_proc:get_server_pid(), {invite_sx, Node, Mkey, Msid, Okey}).

start_joke(Node, Mkey, Msid, Okey) ->
    ?CAST(hot_well_proc:get_server_pid(), {start_joke, Node, Mkey, Msid, Okey}).

get_state_call() ->
    ?CALL(hot_well_proc:get_server_pid(), get_state).

enter_hot_well(Mb) ->
    ?CAST(hot_well_proc:get_server_pid(), {enter_hot_well, Mb}).

%%退出温泉
exit_hot_well(Key, Sid) ->
    ?CAST(hot_well_proc:get_server_pid(), {exit_hot_well, Key, Sid}).

check_open_time(Now) ->
    {_, {H, M, _S}} = util:seconds_to_localtime(Now),

    case lists:keyfind(H, 1, ?HOT_WELL_OPEN_TIME) of
        false ->
            skip;
        {_, M} ->
            hot_well_proc:get_server_pid() ! {open_hot_well, ?HOT_WELL_TIME},
            ok;
        _ ->
            skip
    end,
    case lists:keyfind(H, 1, ?HOT_WELL_READY_TIME) of
        false ->
            skip;
        {_, M} ->
            hot_well_proc:get_server_pid() ! {ready_hot_well, 1800},
            ok;
        _ ->
            skip
    end.

logout(Player) ->
    cross_area:apply(hot_well, logout1, [Player#player.key, Player#player.sid]),
    ok.

logout1(Key, Sid) ->
    ?CAST(hot_well_proc:get_server_pid(), {exit_hot_well, Key, Sid}),
    ok.

%%断线重连
back(_Pkey) ->
    Copy = scene_copy_proc:get_scene_copy(?SCENE_ID_HOT_WELL, 0),
    Scene = data_scene:get(?SCENE_ID_HOT_WELL),
    erlang:send_after(500, self(), {apply_state, {hot_well, back_1, []}}),
    {?SCENE_ID_HOT_WELL, Copy, Scene#scene.x, Scene#scene.y}.
back_1([], Player) ->
    Mb = make_mb(Player),
    cross_area:apply(hot_well, enter_hot_well, [Mb]), ok.

%%传送出场景
send_out([], Player) ->
    NewPlayer = scene_change:change_scene_back(Player),
    {ok, NewPlayer}.


%%温泉定时加经验
reward_exp([AddExp, AddTypeList], Player) ->
    NewPlayer = player_util:add_exp(Player, AddExp, 20, AddTypeList),
    {ok, NewPlayer}.

make_mb(Player) ->
    #hot_well{
        pkey = Player#player.key,
        sid = Player#player.sid,
        sex = Player#player.sex,
        vip_lv = Player#player.vip_lv,
        pid = Player#player.pid,
        pf = Player#player.pf,
        sn = Player#player.sn_cur,
        node = node()
    }.
