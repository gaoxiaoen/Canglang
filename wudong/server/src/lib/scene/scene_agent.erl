%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 场景进程   priv_** 场景进程下的内部函数 yy_** 九宫格玩家数据处理函数
%%% @end
%%% Created : 14. 七月 2015 下午2:05
%%%-------------------------------------------------------------------
-module(scene_agent).
-author("fancy").
-include("common.hrl").
-include("scene.hrl").
-include("manor_war.hrl").
-behaviour(gen_server).

-compile(export_all).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).
%% 场景统计时间
-define(SCENE_AGENT_TIMER, 5 * 1000).
-define(SCENE_AGENT_LONG_TIMER, 180 * 1000).


%%%===================================================================
%%% API
%%%===================================================================
start_link(Scene, WorkerId, Copy) ->
    gen_server:start_link(?MODULE, [Scene, WorkerId, Copy], []).

start(Scene, WorkerId, Copy) ->
    gen_server:start(?MODULE, [Scene, WorkerId, Copy], []).

%% 通过场景调用函数 - call
apply_call(Sid, Copy, Module, Method, Args) ->
    case scene:get_scene_pid(Sid, Copy) of
        none -> [];
        ?SCENE_TYPE_CROSS_All -> [];
        ?SCENE_TYPE_CROSS_AREA -> [];
        ?SCENE_TYPE_CROSS_WAR_AREA -> [];
        Pid ->
            if
                Pid == self() ->
                    apply(Module, Method, Args);
                true ->
                    case catch gen:call(Pid, '$gen_call', {apply_call, Module, Method, Args}) of
                        {ok, Res} ->
                            Res;
                        Reason ->
                            erase(?SCENE_PID(Sid, Copy)),
                            ?ERR("ERROR mod_scene_agent apply_call/4 sid: ~p function: ~p Reason : ~p~n", [Sid, [Module, Method, Args], Reason]),
                            []
                    end
            end
    end.

%% 通过场景调用函数 - cast
apply_cast(Scene, Copy, Module, Method, Args) ->
    case scene:get_scene_pid(Scene, Copy) of
        none ->
            [];
        ?SCENE_TYPE_CROSS_AREA ->
            cross_area:apply(?MODULE, apply_cast, [Scene, Copy, Module, Method, Args]);
        ?SCENE_TYPE_CROSS_All ->
            cross_all:apply(?MODULE, apply_cast, [Scene, Copy, Module, Method, Args]);
        ?SCENE_TYPE_CROSS_WAR_AREA ->
            cross_area:war_apply(?MODULE, apply_cast, [Scene, Copy, Module, Method, Args]);
        Pid ->
            if
                Pid == self() ->
                    apply(Module, Method, Args);
                true ->
                    gen_server:cast(Pid, {apply_cast, Module, Method, Args})
            end
    end.

set_receive_msg(SceneId, Bool) ->
    case scene:get_scene_pid(SceneId, 0) of
        Pid when is_pid(Pid) ->
            Pid ! {set_receive_msg, Bool},
            ok;
        _ -> ok
    end.

%% 给场景所有玩家发送信息
send_to_scene(Scene, Copy, Bin) ->
    case scene:get_scene_pid(Scene, Copy) of
        none ->
            skip;
        ?SCENE_TYPE_CROSS_AREA ->
            cross_area:apply(?MODULE, send_to_scene, [Scene, Copy, Bin]);
        ?SCENE_TYPE_CROSS_All ->
            cross_all:apply(?MODULE, send_to_scene, [Scene, Copy, Bin]);
        ?SCENE_TYPE_CROSS_WAR_AREA ->
            cross_area:war_apply(?MODULE, send_to_scene, [Scene, Copy, Bin]);
        Pid ->
            Pid ! {send_to_scene, Copy, Bin}
    end.

%% 给场景所有玩家发送信息
send_to_scene(Scene, Bin) ->
    case scene:check_cross_scene_type(Scene) of
        ?SCENE_TYPE_CROSS_All ->
            case config:is_center_node() of
                true ->
                    do_send_to_scene(Scene, Bin);
                false ->
                    cross_all:apply(?MODULE, send_to_scene, [Scene, Bin])
            end;
        ?SCENE_TYPE_CROSS_AREA ->
            case config:is_center_node() of
                true ->
                    do_send_to_scene(Scene, Bin);
                false ->
                    cross_area:apply(?MODULE, send_to_scene, [Scene, Bin])
            end;
        ?SCENE_TYPE_CROSS_WAR_AREA ->
            case config:is_center_node() of
                true ->
                    do_send_to_scene(Scene, Bin);
                false ->
                    cross_area:war_apply(?MODULE, send_to_scene, [Scene, Bin])
            end;

        false ->
            do_send_to_scene(Scene, Bin);
        _ -> skip
    end.


do_send_to_scene(Scene, Bin) ->
    CopyList = scene_copy_proc:get_scene_copy_ids(Scene),
    F = fun(Copy) ->
        send_to_scene(Scene, Copy, Bin)
    end,
    lists:foreach(F, CopyList).

%%    case scene:get_scene_pid(Scene, 0) of
%%        none ->
%%            skip;
%%        ?SCENE_TYPE_CROSS_AREA ->
%%            cross_area:apply(?MODULE, send_to_scene, [Scene, Bin]);
%%        ?SCENE_TYPE_CROSS_All ->
%%            cross_all:apply(?MODULE, send_to_scene, [Scene, Bin]);
%%        ?SCENE_TYPE_CROSS_WAR_AREA ->
%%            cross_area:war_apply(?MODULE, send_to_scene, [Scene, Bin]);
%%        _Pid ->
%%            _Pid ! {send_to_scene, Bin},
%%            CopyList = scene_copy_proc:get_scene_copy_ids(Scene),
%%            F = fun(Copy) ->
%%                if Copy == 0 -> ok;
%%                    true ->
%%                        Pid = scene:get_scene_pid(Scene, Copy),
%%                        Pid ! {send_to_scene, Bin}
%%                end
%%                end,
%%            lists:foreach(F, CopyList)
%%    end.

%% 给场景九宫格玩家发送信息
send_to_area_scene(Sid, Copy, X, Y, Bin) ->
    case scene:get_scene_pid(Sid, Copy) of
        none ->
            skip;
        ?SCENE_TYPE_CROSS_AREA ->
            cross_area:apply(?MODULE, send_to_area_scene, [Sid, Copy, X, Y, Bin]);
        ?SCENE_TYPE_CROSS_All ->
            cross_all:apply(?MODULE, send_to_area_scene, [Sid, Copy, X, Y, Bin]);
        ?SCENE_TYPE_CROSS_WAR_AREA ->
            cross_area:war_apply(?MODULE, send_to_area_scene, [Sid, Copy, X, Y, Bin]);
        Pid ->
            Pid ! {send_to_area_scene, Copy, X, Y, Bin}
    end.

%% 战斗信息发送到场景
send_to_area_scene(Sid, Copy, X, Y, ABin, DBin) ->
    case scene:get_scene_pid(Sid, Copy) of
        none ->
            skip;
        ?SCENE_TYPE_CROSS_AREA ->
            cross_area:apply(?MODULE, send_to_area_scene, [Sid, Copy, X, Y, ABin, DBin]);
        ?SCENE_TYPE_CROSS_All ->
            cross_all:apply(?MODULE, send_to_area_scene, [Sid, Copy, X, Y, ABin, DBin]);
        ?SCENE_TYPE_CROSS_WAR_AREA ->
            cross_area:war_apply(?MODULE, send_to_area_scene, [Sid, Copy, X, Y, ABin, DBin]);
        Pid ->
            Pid ! {send_to_area_scene, Copy, X, Y, ABin, DBin}
    end.

%% 给场景所有玩家发送信息
send_to_scene_group(Scene, Copy, Group, Bin) ->
    case scene:get_scene_pid(Scene, Copy) of
        none ->
            skip;
        ?SCENE_TYPE_CROSS_AREA ->
            cross_area:apply(?MODULE, send_to_scene_group, [Scene, Copy, Group, Bin]);
        ?SCENE_TYPE_CROSS_All ->
            cross_all:apply(?MODULE, send_to_scene_group, [Scene, Copy, Group, Bin]);
        ?SCENE_TYPE_CROSS_WAR_AREA ->
            cross_area:war_apply(?MODULE, send_to_scene_group, [Scene, Copy, Group, Bin]);
        Pid ->
            Pid ! {send_to_scene_group, Copy, Group, Bin}
    end.

%% 获取场景同组
get_player_scene_group(Node, Sid, Scene, Copy, Group) ->
    case scene:get_scene_pid(Scene, Copy) of
        none ->
            skip;
        ?SCENE_TYPE_CROSS_AREA ->
            cross_area:apply(?MODULE, get_player_scene_group, [Node, Sid, Scene, Copy, Group]);
        ?SCENE_TYPE_CROSS_All ->
            cross_all:apply(?MODULE, get_player_scene_group, [Node, Sid, Scene, Copy, Group]);
        ?SCENE_TYPE_CROSS_WAR_AREA ->
            cross_area:war_apply(?MODULE, get_player_scene_group, [Node, Sid, Scene, Copy, Group]);
        Pid ->
            Pid ! {get_player_scene_group, Node, Sid, Copy, Group}
    end.


%%获取场景单个玩家信息
get_scene_player(SceneId, Copy, Key) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, dict_get_player, [Key]).
%%获取场景范围玩家
get_scene_player_for_battle(SceneId, Copy, X, Y, Area, ExceptList, Group) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_scene_player_for_battle, [Copy, X, Y, Area, ExceptList, Group]).

%%获取场景范围玩家和怪物
get_scene_obj_for_battle(SceneId, Copy, X, Y, Area, ExceptList, Group) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_scene_obj_for_battle, [Copy, X, Y, Area, ExceptList, Group]).

%%获取直线范围玩家和怪物
get_line_obj_for_battle(SceneId, Copy, X, Y, Area, Angle, Diff, ExceptList, Group) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_line_obj_for_battle, [Copy, X, Y, Area, Angle, Diff, ExceptList, Group]).

%%获取场景队伍列表
get_scene_team(SceneId, Copy, Node) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, get_scene_team, [Copy, Node]).

%%获取场景没有组队玩家
get_scene_not_team(SceneId, Copy, Node, Lv) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, get_scene_not_team, [Copy, Node, Lv]).

%%场景（fe:副本）关闭，清除场景数据
clean_scene_area(SceneId, Copy) ->
    scene_agent:apply_cast(SceneId, Copy, scene_agent, priv_clean_scene_area, [Copy]).

%%获取场景人数
get_scene_count(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_scene_count, [Copy]).

get_scene_count_by_group(SceneId, Copy, Group) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_scene_count_by_group, [Copy, Group]).

%%获取场景仙盟统计
get_scene_guild_count(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_scene_guild_count, [Copy]).


%%获取场景玩家PID列表
get_scene_player_pids(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_scene_player_pids, [Copy]).

%%获取场景玩家key/pid
get_scene_player_key_pid(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_scene_player_key_pid, [Copy]).


get_scene_player(SceneId) ->
    CopyList = scene_copy_proc:get_scene_copy_ids(SceneId),
    F = fun(Copy) ->
        scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_scene_player, [])
    end,
    lists:flatmap(F, CopyList).



get_copy_scene_player(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_scene_player, [Copy]).

%%工会战获取玩家位置
get_scene_player_position(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_scene_player_position, [Copy]).

%%获取九宫玩家key
get_area_scene_pkeys(SceneId, Copy, X, Y) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_area_scene_pkeys, [Copy, X, Y]).

%%获取九宫玩家
get_area_scene_player(SceneId, Copy, X, Y) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_area_scene_player, [Copy, X, Y]).

%%获取场景分组玩家PID
get_pids_by_group(SceneId, Copy, Group) ->
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_pids_by_group, [Copy, Group]).

%%获取场景分组玩家
get_player_by_group(SceneId, Copy, Group) ->
    ?DEBUG("~p / ~p~n", [SceneId, Copy]),
    scene_agent:apply_call(SceneId, Copy, scene_agent, priv_get_player_by_group, [Copy, Group]).

%%获取城战晚宴玩家
get_scene_player_for_manor_war(SceneId, X, Y, Gkey) ->
    scene_agent:apply_call(SceneId, 0, scene_agent, priv_get_scene_player_for_manor_war, [Gkey, X, Y]).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================


init([Scene, WorkerId, Copy]) ->
    Self = self(),
    case WorkerId == 0 of
        true ->
            Ref = erlang:send_after(?SCENE_AGENT_TIMER, Self, {scene_agent_timer}),
            Ref1 = erlang:send_after(?SCENE_AGENT_LONG_TIMER, Self, {scene_agent_long_timer}),
            Ref2 = erlang:send_after(60000, self(), clean_scene_palyer),
            put(clean_scene_palyer, Ref2),
            SceneProcessName = misc:scene_process_name(Scene, Copy),
            ?DO_IF(is_integer(Copy), misc:register(local, SceneProcessName, Self)),
            scene_pid:update_scene_pid(Scene, Copy, Self),
            F = fun(Wid) ->
                {ok, WPid} = scene_agent:start_link(Scene, Wid, Copy),
                append_worker_pid(WPid),
                WPid
            end,
            DataScene = data_scene:get(Scene),
            WorkerNum =
                if
                    DataScene#scene.type == ?SCENE_TYPE_DUNGEON
                        orelse DataScene#scene.type == ?SCENE_TYPE_CROSS_ELITE
                        orelse DataScene#scene.type == ?SCENE_TYPE_CROSS_ELIMINATE
                        orelse DataScene#scene.type == ?SCENE_TYPE_CROSS_ARENA ->
                        1;
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_DUN -> 2;
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_GUARD_DUN -> 2;
                    DataScene#scene.type == ?SCENE_TYPE_NORMAL ->
                        ?SCENE_AGENT_NUM;
                    true ->
                        max(1, round(?SCENE_AGENT_NUM div 3))
                end,
            Worker = lists:map(F, lists:seq(1, WorkerNum)),
            load_scene_data(Scene, Copy),
            Npc = init_scene_npc(Scene),
            scene_copy_proc:init_scene_copy(Scene, Copy),
            ManorGuildName = ?IF_ELSE(Scene == ?SCENE_ID_MAIN, manor_war:get_manor_guild_name(Scene), <<>>),
            %%外观类攻击延迟进程
            {ok, DelayPid} = scene_agent:start_link(Scene, -1, Copy),
            scene:put_battle_delay_pid(DelayPid),
            {ok, #scene_state{sid = Scene, copy = Copy, timer = Ref, long_timer = Ref1, self = Self, worker = Worker, manor_guild_name = ManorGuildName, npc = Npc}};
        false ->
%%             WorkerName = worker_name(Scene, WorkerId),
%%             misc:register(local, WorkerName, Self),
            {ok, #scene_state{self = Self}}
    end.

%% 禁止scene_agent 接收额外call消息
%% 统一模块+过程调用(call)
handle_call({apply_call, Module, Method, Args}, _From, State) ->
    case config:is_catch_err() of
        true ->
            try
                {reply, apply(Module, Method, Args), State}
            catch
                _:_Err ->
                    ?PRINT("apply_call error:~p/~p/~p/~p", [_Err, Module, Method, Args]),
                    {noreply, State}
            end;
        false ->
            {reply, apply(Module, Method, Args), State}
    end;
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 禁止scene_agent 接收额外cast消息
handle_cast({apply_cast, Module, Method, Args}, State) when State#scene_state.is_receive_msg ->
%%    LongTime1 = util:longunixtime(),
    case config:is_catch_err() of
        true ->
            try
                apply(Module, Method, Args)
            catch
                _:_Err ->
                    ?PRINT("apply_cast error:~p/~p/~p/~p", [_Err, Module, Method, Args]),
                    skip
            end;
        false ->
            apply(Module, Method, Args)
    end,
    {noreply, State};
%%    LongTime2 = util:longunixtime(),
%%    Info = {{apply_cast, Module, Method}},
%%    NewMssgList = count_scene_msg(Info, State, LongTime1, LongTime2),
%%    {noreply, State#scene_state{msg_count = NewMssgList}};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(stop, State) ->
    [monster:stop_broadcast(MonPid) || MonPid <- mon_agent:priv_get_scene_mon_pids(State#scene_state.sid, State#scene_state.copy)],
    ?DEBUG("close scene normal ~p/~p~n", [State#scene_state.sid, State#scene_state.copy]),
    {stop, normal, State};

%% 场景定时器
handle_info({scene_agent_timer}, State) ->
    misc:cancel_timer(State#scene_state.timer),
    Ref = erlang:send_after(?SCENE_AGENT_TIMER, self(), {scene_agent_timer}),
    IsReceiveMsg = check_msg_queue(State#scene_state.sid, State#scene_state.is_receive_msg),
    {noreply, State#scene_state{timer = Ref, is_receive_msg = IsReceiveMsg}};

handle_info({scene_agent_long_timer}, State) ->
    misc:cancel_timer(State#scene_state.long_timer),
    Ref = erlang:send_after(?SCENE_AGENT_LONG_TIMER, self(), {scene_agent_long_timer}),
    check_scene_mon(State#scene_state.sid, State#scene_state.copy),
    %%同步场景线路
    scene_copy_proc:init_scene_copy(State#scene_state.sid, State#scene_state.copy),
    {noreply, State#scene_state{long_timer = Ref}};

handle_info(clean_scene_palyer, State) ->
    case scene:is_cross_normal_scene(State#scene_state.sid) of
        true ->
            PlayerList = priv_get_scene_player(),
            F = fun(P) ->
                case misc:is_process_alive(P#scene_player.pid) of
                    true -> ok;
                    false ->
                        scene_agent_info:handle({leave, [P#scene_player.key, P#scene_player.copy, P#scene_player.x, P#scene_player.y]}, State)
                end
            end,
            lists:map(F, PlayerList),
            misc:cancel_timer(clean_scene_player),
            Ref = erlang:send_after(60000, self(), clean_scene_palyer),
            put(clean_scene_palyer, Ref),
            ok;
        false -> ok
    end,
    {noreply, State};

handle_info({manor_name, [GuildName]}, State) ->
    {noreply, State#scene_state{manor_guild_name = GuildName}};

%%打印消息统计
handle_info(msg_count, State) ->
    io:format("####msg count ~p ~p~n",
        [
            State#scene_state.sid,
            State#scene_state.msg_count
        ]),
    {noreply, State};

handle_info({set_receive_msg, Bool}, State) ->
    ?DEBUG("set_receive_msg sid ~p bool ~p~n", [State#scene_state.sid, Bool]),
    {noreply, State#scene_state{is_receive_msg = Bool}};


handle_info({battle_delay, Timer, ScenePid, Msg}, State) ->
    erlang:send_after(Timer, self(), {battle_delay_after, ScenePid, Msg}),
    {noreply, State};

handle_info({battle_delay_after, ScenePid, Msg}, State) ->
    catch ScenePid ! Msg,
    {noreply, State};

%% 统一消息处理模块
handle_info(Info, State) when State#scene_state.is_receive_msg ->
%%    LongTime1 = util:longunixtime(),
%%     ?DO_IF(State#scene_state.sid == 10003, ?DEBUG("receive ~p~n", [Info])),
    case config:is_catch_err() of
        true ->
%%             scene_agent_info:handle(Info, State);
            try
                scene_agent_info:handle(Info, State)
            catch
                _:_Err ->
                    ?PRINT("scene_agent_info error:~p,reason:~p ~n", [Info, _Err]),
                    skip
            end;
        false ->
            scene_agent_info:handle(Info, State)
    end,
    {noreply, State};
%%    LongTime2 = util:longunixtime(),
%%    NewMssgList = count_scene_msg(Info, State, LongTime1, LongTime2),
%%    {noreply, State#scene_state{msg_count = NewMssgList}}.

handle_info(_msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% 加载场景数据
load_scene_data(SceneId, Copy) ->
    case data_scene:get(SceneId) of
        [] ->
            ok;
        DataScene ->
            case lists:member(SceneId, ?SCENE_ID_NORMAL_CROSS_LIST) of
                true ->
                    priv_create_mon(DataScene#scene.mon, SceneId, Copy);
                false ->
                    case config:is_center_node() of
                        true ->
                            case scene:is_cross_scene_type(SceneId) of
                                true ->
                                    priv_create_mon(DataScene#scene.mon, SceneId, Copy);
                                false ->
                                    skip
                            end;
                        false ->
                            case scene:is_cross_scene_type(SceneId) of
                                true ->
                                    skip;
                                false ->
                                    if DataScene#scene.type == ?SCENE_TYPE_DUNGEON -> skip;
                                        true ->
                                            priv_create_mon(DataScene#scene.mon, SceneId, Copy)

                                    end
                            end
                    end
            end
    end.

%% 初始化场景npc列表
init_scene_npc(Scene) ->
    case data_scene:get(Scene) of
        [] ->
            [];
        DataScene ->
            F = fun([NpcId, X, Y]) ->
                case data_npc:get(NpcId) of
                    [] -> [];
                    Npc ->
                        Key = misc:unique_key_auto(),
                        [[Key, NpcId, X, Y, Npc#npc.name, Npc#npc.icon, Npc#npc.image, Npc#npc.realm]]
                end
            end,
            lists:flatmap(F, DataScene#scene.npc)
    end.

%%@创建静态怪物信息
priv_create_mon([], _, _) ->
    ok;
priv_create_mon([[MonId, X, Y] | T], SceneId, Copy) ->
    mon_agent:create_mon_cast([MonId, SceneId, X, Y, Copy, 0, []]),
    priv_create_mon(T, SceneId, Copy).


%% @获取场景所有玩家数据
priv_get_scene_player() ->
    AllData = get(),
    [ScenePlayer || {_Key, ScenePlayer} <- AllData, is_record(ScenePlayer, scene_player)].

%% @获取场景玩家数据
priv_get_scene_player(Copy) ->
    AllPlayer = dict_get_id(Copy),
    get_scene_player_helper(AllPlayer, Copy, []).

get_scene_player_helper([], _, Data) ->
    Data;
get_scene_player_helper([Key | T], Copy, Data) ->
    case get(?PLAYER_KEY(Key)) of
        undefined ->
            dict_del_id(Copy, Key),
            get_scene_player_helper(T, Copy, Data);
        ScenePlayer ->
            get_scene_player_helper(T, Copy, [ScenePlayer | Data])
    end.

%% @获取场景区域玩家数据
priv_get_scene_area_player(Copy, X, Y) ->
    Area = scene_calc:get_the_area(X, Y),
    dict_get_all_area_player(Area, Copy).

%%获取场景的队伍列表
get_scene_team(Copy, Node) ->
    util:list_unique([ScenePlayer#scene_player.teamkey || ScenePlayer <- priv_get_scene_player(Copy), ScenePlayer#scene_player.teamkey > 0, (ScenePlayer#scene_player.node == Node orelse ScenePlayer#scene_player.node == none)]).

%%获取场景的无队伍玩家列表
get_scene_not_team(Copy, Node, Lv) ->
    util:list_unique([ScenePlayer#scene_player.key || ScenePlayer <- priv_get_scene_player(Copy), ScenePlayer#scene_player.teamkey == 0, ScenePlayer#scene_player.lv >= Lv, (ScenePlayer#scene_player.node == Node orelse ScenePlayer#scene_player.node == none)]).


%% 获取攻击范围内玩家
%% ExceptList 排除的玩家key列表
%% Group 排除非0 group
priv_get_scene_player_for_battle(Copy, X, Y, Area, ExceptList, Group) ->
    AllPlayer =
        if Area < 100 ->
            AllArea = scene_calc:get_the_area(X, Y),
            dict_get_all_area_player(AllArea, Copy);
            true ->
                priv_get_scene_player(Copy)
        end,
    X1 = X + Area,
    X2 = X - Area,
    Y1 = Y + Area,
    Y2 = Y - Area,
    F = fun(ScenePlayer) ->
        #scene_player{
            key = Key,
            x = X0,
            y = Y0,
            hp = Hp,
            group = MyGroup
        } = ScenePlayer,
        case lists:member(Key, ExceptList) of
            true ->
                false;
            false ->
                X0 >= X2 andalso X0 =< X1 andalso Y0 >= Y2 andalso Y0 =< Y1 andalso Hp > 0 andalso (Group == 0 orelse (MyGroup /= Group andalso Key /= Group))
        end
    end,
    sort_range_obj(lists:filter(F, AllPlayer), X, Y).

%%领地战boss选取攻击目标
priv_get_scene_player_for_manor_boss(Copy, X, Y, Area, ExceptList, Gkey) ->
    AllArea = scene_calc:get_the_area(X, Y),
    AllPlayer = dict_get_all_area_player(AllArea, Copy),
    X1 = X + Area,
    X2 = X - Area,
    Y1 = Y + Area,
    Y2 = Y - Area,
    F = fun(ScenePlayer) ->
        #scene_player{
            key = Key,
            x = X0,
            y = Y0,
            hp = Hp,
            guild_key = MyGKey
        } = ScenePlayer,
        case lists:member(Key, ExceptList) of
            true ->
                false;
            false ->
                case ets:lookup(?ETS_MANOR_WAR, MyGKey) of
                    [] -> false;
                    _ ->
                        X0 >= X2 andalso X0 =< X1 andalso Y0 >= Y2 andalso Y0 =< Y1 andalso Hp > 0 andalso (Gkey == 0 orelse (Gkey /= MyGKey))
                end
        end
    end,
    sort_range_obj(lists:filter(F, AllPlayer), X, Y).

%% 获取范围内的怪物和玩家
%% ExceptList 排除的obj key列表
%% Group 排除非0 group
priv_get_scene_obj_for_battle(Copy, X, Y, Area, ExceptList, Group) ->
    AllPlayer = priv_get_scene_area_player(Copy, X, Y),
    AllMon = mon_agent:priv_get_scene_area_mon(Copy, X, Y),
    X1 = X + Area,
    X2 = X - Area,
    Y1 = Y + Area,
    Y2 = Y - Area,
    F = fun(Obj) ->
        {Key, MyX, MyY, MyHp, MyGroup} =
            if
                is_record(Obj, scene_player) ->
                    {Obj#scene_player.key, Obj#scene_player.x, Obj#scene_player.y, Obj#scene_player.hp, Obj#scene_player.group};
                is_record(Obj, mon) ->
                    {Obj#mon.key, Obj#mon.x, Obj#mon.y, Obj#mon.hp, Obj#mon.group};
                true ->
                    {0, 0, 0, 0, 0}
            end,

        case lists:member(Key, ExceptList) of
            true ->
                false;
            false ->
                MyX >= X2 andalso MyX =< X1 andalso MyY >= Y2 andalso MyY =< Y1 andalso MyHp > 0 andalso (Group == 0 orelse (MyGroup /= Group andalso Key /= Group))
        end
    end,
    AllObj = AllPlayer ++ AllMon,
    sort_range_obj(lists:filter(F, AllObj), X, Y).

%% 直线攻击目标
%% Area  直线距离
%% Angle 角度
%% Diff 误差值
%% ExceptList 排除的key列表
%% Group 排除非0 group
priv_get_line_obj_for_battle(Copy, X, Y, Area, Angle, Diff, ExceptList, Group) ->
    ObjList = priv_get_scene_obj_for_battle(Copy, X, Y, Area, ExceptList, Group),
    F = fun(Obj) ->
        {X1, Y1} = if
                       is_record(Obj, scene_player) ->
                           {Obj#scene_player.x, Obj#scene_player.y};
                       is_record(Obj, mon) ->
                           {Obj#mon.x, Obj#mon.y};
                       true ->
                           {0, 0}
                   end,
        Anglex = util:get_angle(X, Y, X1, Y1),
        if
            Anglex < (Angle + Diff) orelse Anglex > (Angle - Diff) ->
                true;
            true ->
                false
        end
    end,
    lists:filter(F, ObjList).

%% 从近到远返回目标
sort_range_obj(ObjList, X, Y) ->
    F = fun(Obj1, Obj2) ->
        {X1, Y1} =
            if
                is_record(Obj1, scene_player) ->
                    {Obj1#scene_player.x, Obj1#scene_player.y};
                is_record(Obj1, mon) ->
                    {Obj1#mon.x, Obj1#mon.y};
                true ->
                    {0, 0}
            end,
        {X2, Y2} =
            if
                is_record(Obj2, scene_player) ->
                    {Obj2#scene_player.x, Obj2#scene_player.y};
                is_record(Obj2, mon) ->
                    {Obj2#mon.x, Obj2#mon.y};
                true ->
                    {0, 0}
            end,
        util:calc_coord_range(X1, Y1, X, Y) < util:calc_coord_range(X2, Y2, X, Y)
    end,
    lists:sort(F, ObjList).

%% 怪物追踪目标时获取目标信息
trace_target_info_by_id([MonAid, Key, MonGroup]) ->
    AttInfo = case dict_get_player(Key) of
                  ScenePlayer when is_record(ScenePlayer, scene_player), ScenePlayer#scene_player.hp > 0 ->
                      case MonGroup == 0 orelse MonGroup /= ScenePlayer#scene_player.group of
                          true ->
                              #scene_player{
                                  x = X,
                                  y = Y
                              } = ScenePlayer,
                              {true, Key, X, Y};
                          false ->
                              false
                      end;
                  _ ->
                      false
              end,
    monster:trace_info_back(MonAid, ?SIGN_PLAYER, AttInfo).

%% 发送到场景
priv_send_to_scene(Bin) ->
    PlayerList = priv_get_scene_player(),
    F = fun(ScenePlayer) ->
        server_send:send_to_sid(ScenePlayer#scene_player.sid,Bin)
%%        server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, {send, Bin})
    end,
    lists:foreach(F, PlayerList).

priv_send_to_scene(Copy, Bin) ->
    PlayerList = priv_get_scene_player(Copy),
    F = fun(ScenePlayer) ->
        server_send:send_to_sid(ScenePlayer#scene_player.sid,Bin)
%%        server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, {send, Bin})
    end,
    lists:foreach(F, PlayerList).

priv_send_to_scene_group(Copy, Group, Bin) ->
    PlayerList = priv_get_scene_player(Copy),
    F = fun(ScenePlayer) ->
        ?DO_IF(ScenePlayer#scene_player.group == Group,
            server_send:send_to_sid(ScenePlayer#scene_player.sid,Bin)
%%            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, {send, Bin})
        )
    end,
    lists:foreach(F, PlayerList).

priv_send_to_local_arena(Copy, X, Y, Bin) ->
    Areas = scene_calc:get_the_area(X, Y),
    priv_send_to_areas(Areas, Copy, Bin, []).

priv_send_to_spec_arena(Copy, X, Y, ABin, DBin) ->
    ?DO_IF(ABin /= <<>>, priv_send_to_local_arena(Copy, X, Y, ABin)),
    ?DO_IF(DBin /= <<>>, priv_send_to_scene(Copy, DBin)).


%% 发送消息给区域列表
%% ExceptList 排除的玩家key列表
priv_send_to_areas(Areas, Copy, Bin, ExceptList) ->
    F1 = fun(Key, A) ->
        case get(?PLAYER_KEY(Key)) of
            undefined ->
                dict_del_id(Copy, Key),
                dict_del_to_area(Copy, A, Key);
            ScenePlayer ->
                server_send:send_to_sid(ScenePlayer#scene_player.sid,Bin)
%%                server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, {send, Bin})
        end
    end,
    F2 = fun(A) ->
        List = dict_get_area(A, Copy),
        [F1(Key, A) || Key <- List -- ExceptList]
    end,
    [F2(A) || A <- Areas].

%%场景关闭，清除场景数据
priv_clean_scene_area(Copy) ->
    dict_del_all_area(Copy),
    mon_agent:dict_del_all_area(Copy),
    ok.

%%获取指定场景人数
priv_get_scene_count(Copy) ->
    length(priv_get_scene_player(Copy)).

priv_get_scene_count_by_group(Copy, Group) ->
    length([ScenePlayer || ScenePlayer <- priv_get_scene_player(Copy), ScenePlayer#scene_player.group == Group]).

priv_get_scene_guild_count(Copy) ->
    length(util:list_filter_repeat([ScenePlayer#scene_player.guild_key || ScenePlayer <- priv_get_scene_player(Copy), ScenePlayer#scene_player.guild_key =/= 0])).


%%获取场景玩家PID列表
priv_get_scene_player_pids(Copy) ->
    [ScenePlayer#scene_player.pid || ScenePlayer <- priv_get_scene_player(Copy)].

priv_get_scene_player_key_pid(Copy) ->
    [{ScenePlayer#scene_player.key, ScenePlayer#scene_player.pid} || ScenePlayer <- priv_get_scene_player(Copy)].


%%仙盟战获取玩家位置
priv_get_scene_player_position(Copy) ->
    [{ScenePlayer#scene_player.key, ScenePlayer#scene_player.pid, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y, ScenePlayer#scene_player.group} || ScenePlayer <- priv_get_scene_player(Copy), ScenePlayer#scene_player.hp > 0].

%%获取九宫玩家key列表
priv_get_area_scene_pkeys(Copy, X, Y) ->
    [ScenePlayer#scene_player.key || ScenePlayer <- priv_get_scene_area_player(Copy, X, Y)].

%%获取九宫玩家key列表
priv_get_area_scene_player(Copy, X, Y) ->
    [ScenePlayer || ScenePlayer <- priv_get_scene_area_player(Copy, X, Y)].

%%获取场景分组玩家pid
priv_get_pids_by_group(Copy, Group) ->
    [{ScenePlayer#scene_player.key, ScenePlayer#scene_player.pid} || ScenePlayer <- priv_get_scene_player(Copy), ScenePlayer#scene_player.group == Group].

%%获取场景分组玩家
priv_get_player_by_group(Copy, Group) ->
    [ScenePlayer || ScenePlayer <- priv_get_scene_player(Copy), ScenePlayer#scene_player.group == Group].


%%城战晚宴
priv_get_scene_player_for_manor_war(Gkey, X, Y) ->
    [ScenePlayer#scene_player.pid || ScenePlayer <- priv_get_scene_area_player(0, X, Y), ScenePlayer#scene_player.guild_key == Gkey].

%% -------------------move_** 走路广播专用 --------------------------
move_send_to_any_area(Area, Copy, Bin, []) ->
    priv_send_to_areas(Area, Copy, Bin, []);
move_send_to_any_area(Area, Copy, Bin, [MoveKey, _Sid]) ->
    F1 = fun(Key, A) ->
        case get(?PLAYER_KEY(Key)) of
            undefined ->
                case Key /= MoveKey of
                    true ->
                        dict_del_id(Copy, Key),
                        dict_del_to_area(Copy, A, Key);
                    false ->
                        skip
                end;
            ScenePlayer ->
                server_send:send_to_sid(ScenePlayer#scene_player.sid,Bin)
%%                server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, {send, Bin})
        end
    end,
    F2 = fun(A) ->
        List = dict_get_area(A, Copy),
        [F1(Key, A) || Key <- List]
    end,
    [F2(A) || A <- Area].


move_send_and_getuser(Area, Copy, Bin) ->
    lists:foldl(
        fun(A, L) ->
            List = dict_get_area(A, Copy),
            move_send_and_getuser_loop(List, {Copy, A}, Bin, []) ++ L
        end,
        [], Area).

move_send_and_getuser_loop([], _, _, Data) ->
    Data;
move_send_and_getuser_loop([Key | T], {Copy, A}, Bin, Data) ->
    case get(?PLAYER_KEY(Key)) of
        undefined ->
            dict_del_id(Copy, Key),
            dict_del_to_area(Copy, A, Key),
            move_send_and_getuser_loop(T, {Copy, A}, Bin, Data);
        ScenePlayer ->
            server_send:send_to_sid(ScenePlayer#scene_player.sid,Bin),
%%            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, {send, Bin}),
            move_send_and_getuser_loop(T, {Copy, A}, Bin, [ScenePlayer | Data])
    end.

move_send_and_getkey(Area, Copy, Bin) ->
    F = fun(Key, A) ->
        case get(?PLAYER_KEY(Key)) of
            undefined ->
                dict_del_id(Copy, Key),
                dict_del_to_area(Copy, A, Key),
                [];
            ScenePlayer ->
                server_send:send_to_sid(ScenePlayer#scene_player.sid,Bin),
%%                server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, {send, Bin}),
                ScenePlayer#scene_player.key
        end
    end,
    lists:foldl(
        fun(A, L) ->
            List = dict_get_area(A, Copy),
            List1 = [F(Key, A) || Key <- List],
            List1 ++ L
        end,
        [], Area).

%% ------------- 九宫格数据存储内部函数 --------------%%
dict_save_id(Copy, Key) ->
    case get(?COPY_KEY_PLAYER(Copy)) of
        undefined ->
            D1 = dict:new(),
            put(?COPY_KEY_PLAYER(Copy), dict:store(Key, 0, D1));
        D2 ->
            put(?COPY_KEY_PLAYER(Copy), dict:store(Key, 0, D2))
    end.

dict_get_id(Copy) ->
    case get(?COPY_KEY_PLAYER(Copy)) of
        undefined ->
            [];
        D ->
            dict:fetch_keys(D)
    end.

dict_del_id(Copy, Key) ->
    case get(?COPY_KEY_PLAYER(Copy)) of
        undefined ->
            skip;
        D ->
            put(?COPY_KEY_PLAYER(Copy), dict:erase(Key, D))
    end.

dict_get_area(XY, Copy) ->
    case get(?TABLE_AREA_PLAYER(XY, Copy)) of
        undefined ->
            [];
        D ->
            dict:fetch_keys(D)
    end.

dict_save_to_area(Copy, X, Y, Key) ->
    XY = scene_calc:get_xy(X, Y),
    dict_save_to_area(Copy, XY, Key).

dict_save_to_area(Copy, XY, Key) ->
    case get(?TABLE_AREA_PLAYER(XY, Copy)) of
        undefined ->
            D1 = dict:new(),
            put(?TABLE_AREA_PLAYER(XY, Copy), dict:store(Key, 0, D1));
        D2 ->
            put(?TABLE_AREA_PLAYER(XY, Copy), dict:store(Key, 0, D2))
    end.

dict_del_to_area(Copy, X, Y, Key) ->
    XY = scene_calc:get_xy(X, Y),
    dict_del_to_area(Copy, XY, Key).

dict_del_to_area(Copy, XY, Key) ->
    case get(?TABLE_AREA_PLAYER(XY, Copy)) of
        undefined ->
            skip;
        D ->
            put(?TABLE_AREA_PLAYER(XY, Copy), dict:erase(Key, D))
    end.

dict_put_player(ScenePlayer) when is_record(ScenePlayer, scene_player) ->
    #scene_player{
        key = Key,
        copy = Copy,
        x = X,
        y = Y
    } = ScenePlayer,
    case get(?PLAYER_KEY(Key)) of
        undefined ->
            dict_save_id(Copy, Key),
            dict_save_to_area(Copy, X, Y, Key);
        _SPlayer ->
            XY1 = scene_calc:get_xy(X, Y),
            XY2 = scene_calc:get_xy(_SPlayer#scene_player.x, _SPlayer#scene_player.y),
            if
                XY1 =:= XY2 ->
                    skip;
                true ->
                    dict_del_to_area(Copy, XY2, Key),
                    dict_save_to_area(Copy, XY1, Key)
            end
    end,
    put(?PLAYER_KEY(Key), ScenePlayer);
dict_put_player(_) -> ok.

dict_get_player(Key) ->
    case get(?PLAYER_KEY(Key)) of
        undefined ->
            [];
        User ->
            User
    end.

dict_get_player_for_battle(Key, AttKey, Now) ->
    case get(?PLAYER_KEY(Key)) of
        undefined ->
            [];
        User ->
            {LockKey, LockTime} = User#scene_player.att_lock,
            if LockKey == 0 orelse Now - LockTime > 50 ->
                put(?PLAYER_KEY(Key), User#scene_player{att_lock = {AttKey, Now}});
                User;
                true ->
                    {lock, User}
            end
    end.


dict_del_player(Key) ->
    case get(?PLAYER_KEY(Key)) of
        undefined ->
            [];
        ScenePlayer ->
            #scene_player{
                copy = Copy,
                x = X,
                y = Y
            } = ScenePlayer,
            dict_del_id(Copy, Key),
            dict_del_to_area(Copy, X, Y, Key),
            erase(?PLAYER_KEY(Key))
    end.

dict_del_all_area(Copy) ->
    Data = get(),
    F = fun({Key, _}) ->
        case Key of
            {tap, _, Cid} when Cid =:= Copy ->
                erase(Key);
            {ckp, Cid} when Cid =:= Copy ->
                erase(Key);
            _ ->
                skip
        end
    end,
    lists:foreach(F, Data).

dict_get_all_area_player(Area, Copy) ->
    List = lists:foldl(
        fun(A, L) ->
            dict_get_area(A, Copy) ++ L
        end,
        [], Area),
    get_scene_player_helper(List, Copy, []).


%% 增加子进程
append_worker_pid(WorkerPid) ->
    case get(scene_worker_list) of
        undefined ->
            put(scene_worker_list, [WorkerPid]);
        List ->
            put(scene_worker_list, [WorkerPid | lists:delete(WorkerPid, List)])
    end.

%% 随机获取子进程
rank_worker_pid() ->
    case get(scene_worker_list) of
        undefined -> [];
        List ->
            [Hd | Tail] = List,
            put(scene_worker_list, Tail ++ [Hd]),
            Hd
    end.

remove_dead() ->
    AllObj = get(),
    F = fun(Obj) ->
        if
            is_record(Obj, scene_player) ->
                case misc:is_process_alive(Obj#scene_player.pid) of
                    false ->
                        1;
                    _ ->
                        0
                end;
            true ->
                0
        end
    end,
    lists:sum(lists:map(F, AllObj)).


%%检查场景怪物是否存活
check_scene_mon(Sid, Copy) ->
    case data_scene:get(Sid) of
        [] -> ok;
        Scene ->
            %%非野外普通场景不检查
            if Scene#scene.type /= ?SCENE_TYPE_NORMAL -> ok;
                true ->
                    case config:is_center_node() of
                        true -> ok;
                        false ->
                            MonList = util:list_filter_repeat(lists:map(fun(Item) -> hd(Item) end, Scene#scene.mon)),
                            do_check_scene_mon(MonList, [Copy], Scene)
                    end
            end
    end.


do_check_scene_mon([], _CopyList, _Scene) -> ok;
do_check_scene_mon([Mid | T], CopyList, Scene) ->
    F = fun(Copy) ->
        case mon_agent:priv_get_scene_mon_by_mid(Copy, Mid) of
            [] ->
                lists:foreach(
                    fun([Id, X, Y]) ->
                        ?DO_IF(Id == Mid, mon_agent:create_mon_cast([Mid, Scene#scene.id, X, Y, Copy, 1, []]))
                    end, Scene#scene.mon);
            _MonList ->
                ok
        end
    end,
    lists:foreach(F, CopyList),
    do_check_scene_mon(T, CopyList, Scene).


check_msg_queue(Sid, IsReceiveMsg) ->
    ProcessInfo = erlang:process_info(self()),
    case lists:keyfind(message_queue_len, 1, ProcessInfo) of
        false -> IsReceiveMsg;
        {_, MsgLen} ->
            if not IsReceiveMsg -> MsgLen =< 10;
                true ->
                    if MsgLen =< 1000 -> IsReceiveMsg;
                        true ->
                            ?ERR("check_msg_queue sid ~p msg_queue ~p  ~n", [Sid, MsgLen]),
                            false
                    end
            end
    end.


%%%-----debug 统计消息
count_scene_msg(Info, State, LongTime1, LongTime2) ->
    NewList =
        case is_tuple(Info) of
            true ->
                [Head | _] = tuple_to_list(Info),
                case lists:keyfind(Head, 1, State#scene_state.msg_count) of
                    false ->
                        [{Head, 1, LongTime2 - LongTime1} | State#scene_state.msg_count];
                    {_, OldTimes, Time} ->
                        [{Head, OldTimes + 1, LongTime2 - LongTime1 + Time} | lists:keydelete(Head, 1, State#scene_state.msg_count)]
                end;
            false ->
                case Info of
                    [Head | _] ->
                        case lists:keyfind(Head, 1, State#scene_state.msg_count) of
                            false ->
                                [{Head, 1, LongTime2 - LongTime1} | State#scene_state.msg_count];
                            {_, OldTimes, Time} ->
                                [{Head, OldTimes + 1, LongTime2 - LongTime1 + Time} | lists:keydelete(Head, 1, State#scene_state.msg_count)]
                        end;
                    _ ->
                        ?ERR("unknown info ~p~n", [Info]),
                        State#scene_state.msg_count
                end
        end,
    F = fun({_, Times, _}, Acc) ->
        Acc + Times
    end,
    SumTimes = lists:foldl(F, 0, NewList),
    case SumTimes rem 100 == 0 of
        true ->
            ets:insert(ets_scene_msg, {State#scene_state.sid, NewList});
        false ->
            skip
    end,
    NewList.
