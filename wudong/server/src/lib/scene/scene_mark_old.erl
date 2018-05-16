%%%------------------------------------
%%% @Module  : mod_scene_mark
%%% @Author  : fancy
%%% @email   : 1812338@qq.com
%%% @Description: 场景阻挡区配置
%%%------------------------------------
-module(scene_mark_old).
-behaviour(gen_server).
-include("scene.hrl").

-include("common.hrl").

-export([
    start_link/0,
    load_mask/1,
    is_blocked/1,
    is_blocked2/1,%%障碍区判断2  障碍区+跳跃区
    sync_mon_pos/6,
    is_crash/6,
    is_safe/1
]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {scene_poses, scene_safe_poses, scene_water_poses, scene_mon_poses, scene_jump_poses, sid_list = []}).

-record(mon_pos, {key = {0, 0}, scene = 0, copy = 0, xy_list = []}).

-define(TIMER, 60).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 加载mask
load_mask(SceneId) ->
    gen_server:cast(get_server_pid(), {load_mask, SceneId}).


%%获取进程PID
get_server_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

%% 判断是否阻挡 有缓存
%% true 不可走 false 可走
is_blocked({SceneId, X, Y}) ->
    try
        gen_server:call(get_server_pid(), {is_blocked, {SceneId, X, Y}})
    catch
        _:_ ->
            false
    end.
%%障碍区+跳跃区
is_blocked2({SceneId, X, Y}) ->
    try
        gen_server:call(get_server_pid(), {is_blocked2, {SceneId, X, Y}})
    catch
        _:_ ->
            false
    end.


%%怪物坐标点碰撞/障碍检查
is_crash(SceneId, Copy, X, Y, OldX, OldY) ->
    try
        gen_server:call(get_server_pid(), {is_crash, SceneId, Copy, X, Y, OldX, OldY})
    catch
        _:_ ->
            false
    end.

%%设置怪物坐标点
sync_mon_pos(SceneId, Copy, X, Y, OldX, OldY) ->
    get_server_pid() ! {sync_mon_pos, SceneId, Copy, X, Y, OldX, OldY},
    ok.

%%是否安全区
is_safe({SceneId, X, Y}) ->
    try
        gen_server:call(get_server_pid(), {is_safe, {SceneId, X, Y}})
    catch
        _:_ ->
            false
    end.

init([]) ->
    State = #state{
        scene_poses = dict:new(),
        scene_safe_poses = dict:new(),
        scene_water_poses = dict:new(),
        scene_mon_poses = dict:new(),
        scene_jump_poses = dict:new()
    },
    Ref = erlang:send_after(?TIMER * 1000, self(), timer),
    put(timer, Ref),
    erlang:send_after(1000, self(), init),
    {ok, State}.


handle_call({is_blocked, {SceneId, X, Y}}, _From, State) ->
    Sid = get_sid(SceneId, State#state.sid_list),
    Reply =
        dict:is_key({Sid, X, Y}, State#state.scene_poses),
    {reply, Reply, State};

handle_call({is_safe, {SceneId, X, Y}}, _From, State) ->
    Sid = get_sid(SceneId, State#state.sid_list),
    Reply =
        dict:is_key({Sid, X, Y}, State#state.scene_safe_poses),
    {reply, Reply, State};

handle_call({is_blocked2, {SceneId, X, Y}}, _From, State) ->
    Sid = get_sid(SceneId, State#state.sid_list),
    Reply =
        dict:is_key({Sid, X, Y}, State#state.scene_poses) orelse
            dict:is_key({Sid, X, Y}, State#state.scene_jump_poses),
    {reply, Reply, State};


handle_call({is_crash, SceneId, Copy, X, Y, OldX, OldY}, _From, State) ->
    Key = {SceneId, Copy},
    Sid = get_sid(SceneId, State#state.sid_list),
    {Reply, NewSceneMonPoses} =
        case dict:is_key(Key, State#state.scene_mon_poses) of
            false ->
                %%障碍区判断
                case dict:is_key({Sid, X, Y}, State#state.scene_poses) orelse dict:is_key({Sid, X, Y}, State#state.scene_jump_poses) of
                    true ->
                        {false, State#state.scene_mon_poses};
                    false ->
                        SceneMonPoses = dict:store(Key, #mon_pos{key = Key, scene = SceneId, copy = Copy, xy_list = [{X, Y}]}, State#state.scene_mon_poses),
                        {{X, Y}, SceneMonPoses}
                end;
            true ->
                MonPos = dict:fetch(Key, State#state.scene_mon_poses),
                {NewX, NewY} = check_crash(X, Y, MonPos#mon_pos.xy_list),
                case dict:is_key({Sid, NewX, NewY}, State#state.scene_poses) orelse dict:is_key({Sid, X, Y}, State#state.scene_jump_poses) of
                    true ->
                        {false, State#state.scene_mon_poses};
                    false ->
                        MonPos = dict:fetch(Key, State#state.scene_mon_poses),
                        XYList = [{NewX, NewY} | lists:delete({OldX, OldY}, MonPos#mon_pos.xy_list)],
                        SceneMonPoses = dict:store(Key, MonPos#mon_pos{xy_list = XYList}, State#state.scene_mon_poses),
                        {{NewX, NewY}, SceneMonPoses}
                end

        end,
    {reply, Reply, State#state{scene_mon_poses = NewSceneMonPoses}};

handle_call(_Request, _From, State) ->
    {reply, State, State}.

handle_cast({load_mask, SceneId}, State) ->
    State1 =
        case data_scene:get(SceneId) of
            [] -> State;
            Scene ->
                case data_mask:get(Scene#scene.sid) of
                    "" -> State;
                    Mask1 -> load_mask(Mask1, 0, 0, SceneId, State)
                end
        end,
    {noreply, State1};

handle_cast(_Msg, State) ->
    {noreply, State}.

%%同步怪物坐标点
%%handle_info({sync_mon_pos, SceneId, Copy, X, Y, OldX, OldY}, State) ->
%%    Key = {SceneId, Copy},
%%    SceneMonPoses =
%%        case dict:is_key(Key, State#state.scene_mon_poses) of
%%            false ->
%%                dict:store(Key, #mon_pos{key = Key, scene = SceneId, copy = Copy, xy_list = [{X, Y}]}, State#state.scene_mon_poses);
%%            true ->
%%                MonPos = dict:fetch(Key, State#state.scene_mon_poses),
%%                XYList = [{X, Y} | lists:delete({OldX, OldY}, MonPos#mon_pos.xy_list)],
%%                dict:store(Key, MonPos#mon_pos{xy_list = XYList}, State#state.scene_mon_poses)
%%        end,
%%    {noreply, State#state{scene_mon_poses = SceneMonPoses}};

handle_info(timer, State) ->
    misc:cancel_timer(timer),
    Ref = erlang:send_after(?TIMER * 1000, self(), timer),
    put(timer, Ref),
    {noreply, State#state{scene_mon_poses = dict:new()}};

handle_info(init, State) ->
    NewState = load_mask_all(State),
    F = fun(SceneId) ->
        case data_scene:get(SceneId) of
            [] -> {SceneId, 0};
            Scene -> {SceneId, Scene#scene.sid}
        end
        end,
    SidList = lists:map(F, data_scene:get_all_scene_id()),
    {noreply, NewState#state{sid_list = SidList}};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.



get_sid(SceneId, SidList) ->
    case lists:keyfind(SceneId, 1, SidList) of
        false -> 0;
        {_, Sid} -> Sid
    end.

load_mask_all(State) ->
    F = fun(Sid, State1) ->
        case data_mask:get(Sid) of
            "" -> State1;
            Mask1 -> load_mask(Mask1, 0, 0, Sid, State1)
        end
        end,
    lists:foldl(F, State, data_mask:get_all()).

%% 从地图的mask中构建ETS坐标表，表中存放的是可移动的坐标
%% load_mask(Mask,0,0)，参数1表示地图的mask列表，参数2和3为当前产生的X,Y坐标
load_mask([], _, _, _, State) ->
    State;
load_mask([H | T], X, Y, SceneId, State) ->
    case H of
        10 -> % 等于\n
            load_mask(T, 0, Y + 1, SceneId, State);
        13 -> % 等于\r
            load_mask(T, X, Y, SceneId, State);
        48 -> % 0
            load_mask(T, X + 1, Y, SceneId, State);
        49 -> % 1 %% 不能行走
            D1 = dict:store({SceneId, X, Y}, 0, State#state.scene_poses),
            load_mask(T, X + 1, Y, SceneId, State#state{scene_poses = D1});
        50 -> % 2
            load_mask(T, X + 1, Y, SceneId, State);
        %%3跳跃点
        51 ->
            D1 = dict:store({SceneId, X, Y}, 0, State#state.scene_poses),
            load_mask(T, X + 1, Y, SceneId, State#state{scene_poses = D1});
        53 -> % 5 %% 安全区
            D1 = dict:store({SceneId, X, Y}, 0, State#state.scene_safe_poses),
            load_mask(T, X + 1, Y, SceneId, State#state{scene_safe_poses = D1});
%%        54 -> % 6 %% 安全区
%%            D1 = dict:store({SceneId, X, Y}, 0, State#state.scene_safe_poses),
%%            load_mask(T, X + 1, Y, SceneId, State#state{scene_safe_poses = D1});
        55 -> %%7跳跃点
            D1 = dict:store({SceneId, X, Y}, 0, State#state.scene_jump_poses),
            load_mask(T, X + 1, Y, SceneId, State#state{scene_jump_poses = D1});
%%        56 -> % 8
%%            %水面表（温泉专用）
%%            D1 = dict:store({SceneId, X, Y}, 0, State#state.scene_water_poses),
%%            load_mask(T, X + 1, Y, SceneId, State#state{scene_water_poses = D1});
        _ ->
            load_mask(T, X + 1, Y, SceneId, State)
    end.

%碰撞调整
check_crash(X, Y, XYList) ->
    XY = {X, Y},
    case lists:member(XY, XYList) of
        false -> {X, Y};
        true ->
%%            List = [{X + 1, Y}, {X, Y + 2}, {X - 1, Y}, {X, Y - 2}, {X + 1, Y + 2}, {X - 1, Y + 2}, {X + 1, Y - 2}, {X - 1, Y - 2}], %% 周围8格子
            List = [{X + 1, Y}, {X + 1, Y + 1}, {X, Y + 2}, {X - 1, Y + 1}, {X - 1, Y}, {X - 1, Y - 1}, {X, Y - 2}, {X + 1, Y - 1}], %% 周围8格子
%%            List = [{X + 1, Y}, {X, Y + 1}, {X - 1, Y}, {X, Y - 1}, {X + 1, Y + 1}, {X - 1, Y + 1}, {X + 1, Y - 1}, {X - 1, Y - 1}], %% 周围8格子
            F = fun(P, _P0) ->
                case lists:member(P, XYList) of
                    true ->
                        {P, _P0};
                    false ->
                        {X2, Y2} = P,
                        %非碰撞点
                        {X1, Y1} = _P0,
                        Dis1 = abs(X1 - X) * abs(X1 - X) + abs(Y1 - Y) * abs(Y1 - Y),
                        Dis2 = abs(X2 - X) * abs(X2 - X) + abs(Y2 - Y) * abs(Y2 - Y),
                        case (Dis2 =< Dis1 orelse {X, Y} =:= _P0) of
                            true ->
                                {P, P};
                            _ ->
                                {P, _P0}
                        end
                end
                end,
            {_, NewXY} = lists:mapfoldl(F, XY, List),
            if NewXY == XY -> XY;
                true -> NewXY
            end
    end.