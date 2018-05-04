%%----------------------------------------------------
%% @doc 巅峰对决全局管理模块
%%
%% <pre>
%% 巅峰对决全局管理模块
%% 
%% 巅峰对决的几个状态
%%      idel         空闲
%%      notice       活动通知 
%%      prepare      报名阶段
%%      match_pre    比赛早期(可进战场)
%%      matching     比赛阶段
%%      expire       进入战区过期
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @author abu
%% @end
%%----------------------------------------------------
-module(top_fight_center_mgr).

-behaviour(gen_fsm).

%% 公共函数
-export([
        login/1
        ,logout/1
        ,start_link/0
        ,time/1
        ,sign_up/1
        ,expend_arena_pre/1
        ,enter_match/2
        ,exit_match/1
        ,del_cache/1
        ,update_hero/0
        ,do_enter_match/2
        ,leave_prepare/1
        ,update_last_win/5
        ,get_panel_info/0
        ,get_hero_rank/1
        ,get_hero_rank/2
        ,sync_hero_rank/0
        ,sync_status/0
        ,sync_top_hero/0
        ,update_top_hero_result/1
        ,update_top_hero/0
        ,update_honor/0

        ,adm_sync/0

        ,m/1
        ,next_all/1
        ,debug/0
    ]
).
%% 状态函数
-export([
        idel/2
        ,notice/2
        ,prepare/2
        ,match_pre/2
        ,matching/2
        ,expire/2
    ]
).

-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("common.hrl").
-include("top_fight.hrl").
-include("role.hrl").
-include("link.hrl").
-include("looks.hrl").
-include("pos.hrl").
-include("assets.hrl").
-include("attr.hrl").
-include("map.hrl").
%%
-include("pet.hrl").
-include("max_fc.hrl").

-record(state, {
        low = #top_fight_zone{arena_lev = ?top_fight_lev_low, last_win = #top_fight_lw{}}         %% 初级区准备区
        ,middle = #top_fight_zone{arena_lev = ?top_fight_lev_middle, last_win = #top_fight_lw{}}  %% 中级区准备区
        ,hight = #top_fight_zone{arena_lev = ?top_fight_lev_hight, last_win = #top_fight_lw{}}    %% 高级区准备区
        ,super = #top_fight_zone{arena_lev = ?top_fight_lev_super, last_win = #top_fight_lw{}}    %% 超级区准备区
        ,angle = #top_fight_zone{arena_lev = ?top_fight_lev_angle, last_win = #top_fight_lw{}}    %% 仙区准备区地
        ,hero_rank = #top_fight_hero_rank{}                       %% 巅峰对决英雄榜
        ,ts = 0                                               %% 进入某状态的时刻
        ,timeout = 0                                          %% 超时时间
        ,top_hero
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
%% 登陆
login(Role = #role{id = {RoleId, SrvId}, event = ?event_top_fight_prepare, pos = Pos, pid = Pid}) ->
    case ?top_fight_CALL(gen_fsm, sync_send_all_state_event, [?MODULE, {login, prepare, RoleId, SrvId, Pid}]) of
        {ok, _Time} -> 
            Role;
        _Any -> 
         {MapId, X, Y} = ?top_fight_exit,
         NewX = util:rand(X - 50, X + 50),
         NewY = util:rand(Y - 50, Y + 50),
         Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>}
    end;
login(Role = #role{id = {RoleId, SrvId}, pid = Pid, event = ?event_top_fight_match, pos = Pos, looks = Looks}) ->
    {MapId, X, Y} = ?top_fight_exit,
    NewX = util:rand(X - 50, X + 50),
    NewY = util:rand(Y - 50, Y + 50),
    case ?top_fight_CALL(gen_fsm, sync_send_all_state_event, [?MODULE, {login, match, RoleId, SrvId, Pid}]) of
        {ok, ArenaRole = #top_fight_role{arena_pid = ArenaPid}} ->
            case is_pid(ArenaPid) andalso util:is_process_alive(ArenaPid) of
                true -> 
                    NewLooks = update_looks(Looks, ArenaRole),
                    Role#role{event_pid = ArenaPid, looks = NewLooks};
                false -> 
                    Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>}
            end;
        false -> 
            Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>};
        _Any -> 
            Role#role{pos = Pos#pos{map = MapId, x = NewX, y = NewY}, event = ?event_no, cross_srv_id = <<>>}
    end;
login(Role) ->
    Role.

%% 下线
logout(_Role = #role{id = {RoleId, SrvId}, event = ?event_top_fight_prepare}) ->
    ?top_fight_CALL(gen_fsm, send_all_state_event, [?MODULE, {logout, RoleId, SrvId}]);
logout(_Role = #role{id = {RoleId, SrvId}, event = ?event_top_fight_match}) ->
    ?top_fight_CALL(gen_fsm, send_all_state_event, [?MODULE, {logout, RoleId, SrvId}]);
logout(_Role) ->
    ok.

%% @doc 启动巅峰对决服务进程
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @time(Type) -> Time
%% Time = integer()
%% @doc 获取指定类型的时间
time(StateName) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {time, StateName}).

%% @spec sign_up(Role) -> {ok, NewRole} | {false, Reason}
%% Role = #role{}
%% Reason = binary()
%% @doc
%% 角色报名参加巅峰对决比赛
sign_up(Role) ->
    case check(sign_up, Role) of
        ok -> do_sign_up(Role);
        {false, Reason} -> {false, Reason}
    end.

%% 获取当前巅峰对决状态
expend_arena_pre(Lev) ->
    ?top_fight_CALL(gen_fsm, sync_send_all_state_event, [?MODULE, {expend_arena_pre, Lev}]).

%% @spec enter_arena(Role, Mask) -> ok | {false, Reason}
%% @doc 进入战场
enter_match(_Role = #role{id = {RoleId, SrvId}, event = ?event_top_fight_prepare}, Mask) ->
    %%case ?top_fight_CALL(gen_fsm, sync_send_all_state_event, [?MODULE, {enter_match, {RoleId, SrvId}, Mask}]) of
    %%    {ok} -> %% 好像有点多余
    %%        {ok};
    %%    {false, Reason} ->
    %%        {false, Reason}
    %%end;
    case center:is_connect() of
        {true, _} ->
            ?top_fight_CAST(gen_fsm, sync_send_all_state_event, [?MODULE, {enter_match, {RoleId, SrvId}, Mask}]),
            {ok};
        false ->
            {false, ?L(<<"时空不稳定，无法进入跨服巅峰对决">>)}
    end;
enter_match(_Role, _Mask) ->
    {false, ?L(<<"你目前不是在仙法竞技的准备区，不可以进入竞技场战斗">>)}.

%% @spec exit_match(Role) -> {ok, NewRole} | {false, Reason}
%% @doc 退出战区
exit_match(#role{id = {RoleId, SrvId}, event = ?event_top_fight_match, event_pid = EventPid}) ->
    case is_pid(EventPid) andalso util:is_process_alive(EventPid) of
        false ->
            {false, ?L(<<"竞技场已经关闭">>)};
        true ->
            case top_fight_center:exit_match(EventPid, {RoleId, SrvId}) of
                {false, Reason} ->
                    {false, Reason};
                _Any ->
                    ok
            end
    end;
exit_match(#role{id = {RoleId, SrvId}, event = ?event_top_fight_prepare})->
    case ?top_fight_CALL(gen_fsm, sync_send_all_state_event, [?MODULE, {exit_prepare, {RoleId, SrvId}}]) of
        ok ->
            ok;
        {false, Reason} ->
            {false, Reason}
    end;
exit_match(_Role) ->
    {false, <<"">>}.

%% 删除缓存
del_cache(ArenaRole) ->
    gen_fsm:send_all_state_event(?MODULE, {del_cache, ArenaRole}).

%% 转换竞技角色-准备区
convert(init, PreSeq, PreMapId, PreMapPid, #role{id = {RoleId, SrvId}, pid = Pid, name = RoleName, lev = Lev, career = Career, max_fc = #max_fc{max = FightCapacity}, pet = #pet_bag{active = Active}}) ->
    ArenaLev = to_arena_lev(Lev),
    PetFc = case Active of
        #pet{fight_capacity = Pfc} ->
            Pfc;
        _ ->
            0
    end,
    #top_fight_role{pre_seq = PreSeq, pre_map_id = PreMapId, pre_map_pid = PreMapPid, fight_capacity = FightCapacity, pet_fight_capacity = PetFc, role_id = {RoleId, SrvId}, role_pid = Pid, name = RoleName, lev = Lev, arena_lev = ArenaLev, career = Career}.

%% 更新上次优胜者
update_last_win(_ArenaLev, _RoleId, _SrvId, _Name, _KillNum) ->
    %%?top_fight_NCAST(SrvId, gen_fsm, send_all_state_event, [arena_mgr, {update_last_win, ArenaLev, RoleId, SrvId, Name, KillNum}]).
    ok.

%% 获取面板信息
get_panel_info() ->
    case gen_fsm:sync_send_all_state_event(?MODULE, get_panel_info) of
        {ok, Data} -> {ok, Data};
        _ -> 
            ?DEBUG("[巅峰对决]获取面板信息失败"),
            {false, ?L(<<"获取面板信息失败">>)}
    end.

%% 获取英雄榜信息
get_hero_rank(ArenaSeq) ->
    case gen_fsm:sync_send_all_state_event(?MODULE, {get_hero_rank, ?top_fight_lev_low, ArenaSeq}) of
        {ok, Num, ArenaHeroZone} -> {ok, Num, ArenaHeroZone};
        _ -> 
            {false, ?L(<<"获取巅峰对决英雄榜信息有误">>)}
    end.
get_hero_rank(_, ArenaSeq) ->
    get_hero_rank(ArenaSeq).

%% 节点请求同步排行榜
sync_hero_rank() ->
    ?top_fight_CALL(gen_fsm, sync_send_all_state_event, [?MODULE, {sync_hero_rank}]).

sync_top_hero() ->
    ?top_fight_CALL(gen_fsm, sync_send_all_state_event, [?MODULE, {sync_top_hero}]).

sync_status() ->
    ?top_fight_CALL(gen_fsm, sync_send_all_state_event, [?MODULE, {sync_status}]).

%% 更新英雄榜
update_hero() ->
    ok.
    %%gen_fsm:send_all_state_event(?MODULE, {update_hero_rank}).

%% 更新霸主
update_top_hero_result(TopHero) ->
    gen_fsm:send_all_state_event(?MODULE, {update_top_hero_result, TopHero}).

update_top_hero() ->
    ?MODULE ! {update_top_hero}.

update_honor() ->
    ?MODULE ! {update_honor}.

%% 同步数据到节点服
adm_sync() ->
    ?MODULE ! {adm_sync}.

%% 测试
m(Event) ->
    gen_fsm:send_event(?MODULE, Event).

next_all(Event) ->
    ?top_fight_CAST(m, [Event]).

%%
debug() ->
    ?MODULE ! {debug}.

%%----------------------------------------------------
%% 状态机内部逻辑
%%----------------------------------------------------

%% 初始化
init([])->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    IdelTime = get_idel_time(),
    State = #state{},
    NewState2 = case top_fight_dao_log:get_last_time() of
        {ok, Data} -> 
            %NewState = init_last_win(Data, State),
            Fun = fun([Time, _ArenaLev], MaxTime) ->
                case Time > MaxTime of
                    true -> Time;
                    false -> MaxTime
                end
            end,
            MTime = lists:foldl(Fun, 0, Data),
            NewState1 = init_hero_rank(State, MTime),
            case catch init_top_hero(NewState1) of
                Ns = #state{} ->
                    Ns;
                _Other ->
                    ?DEBUG("~w", [_Other]),
                    NewState1
            end;
         _ -> State
    end,
    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, idel, NewState2#state{ts = erlang:now(), timeout = IdelTime}, IdelTime}.

%% 删除准备区的角色信息
handle_event({del_cache, ArenaRole}, StateName, State) ->
    NewState = delete_arena_role(ArenaRole, State),
    continue(StateName, NewState);

%% 更新英雄榜 
handle_event({update_hero_rank}, StateName, State) ->
    self() ! {init_hero_rank},
    continue(StateName, State);

%% 更新霸主
handle_event({update_top_hero_result, TopHero = #top_fight_top_hero{}}, StateName, State) ->
    ?INFO("更新霸主"),
    top_fight_dao_log:save_top_hero(TopHero),
    c_mirror_group:cast(all, top_fight_mgr, update_top_hero, [TopHero]),
    continue(StateName, State#state{top_hero = TopHero});

%% 角色下线
handle_event({logout, RoleId, SrvId}, StateName, State) ->
    case get_arena_role({RoleId, SrvId}, State) of
        ArenaRole = #top_fight_role{status = ?top_fight_role_status_prepare} ->
            NewState = update_arena_role(ArenaRole#top_fight_role{status = ?top_fight_role_status_logout}, State),
            continue(StateName, NewState);
        ArenaRole = #top_fight_role{status = ?top_fight_role_status_match, arena_pid = ArenaPid} ->
            catch top_fight_center:logout(ArenaPid, RoleId, SrvId),
            NewState = update_arena_role(ArenaRole#top_fight_role{status = ?top_fight_role_status_logout}, State),
            continue(StateName, NewState);
        _ ->
            continue(StateName, State)
    end;

%% 更新优胜者信息
handle_event({update_last_win, ArenaLev, RoleId, SrvId, Name, KillNum}, StateName, State) ->
    NewState = write_last_win(ArenaLev, RoleId, SrvId, Name, KillNum, State),
    continue(StateName, NewState);

%% 容错函数
handle_event(_Event, StateName, State) ->
    continue(StateName, State).

%% 获取竞技开始报名时间 notice状态
handle_sync_event({time, notice}, _From, notice, State = #state{ts = Ts}) ->
    Reply = round(util:time_left(?top_fight_timeout_notice, Ts) / 1000),
    continue(notice, {ok, Reply}, State);
%% 获取竞技开始报名时间 prepare状态
handle_sync_event({time, notice}, _From, prepare, State) ->
    continue(prepare, {ok, 0}, State);
%% 获取竞技开始报名时间 其它状态
handle_sync_event({time, notice}, _From, StateName, State) ->
    continue(StateName, {ok, -1}, State);

%% 获取准备时间
handle_sync_event({time, prepare}, _From, prepare, State = #state{ts = Ts}) ->
    Reply = round(util:time_left(?top_fight_timeout_prepare_cross, Ts) / 1000),
    continue(prepare, {ok, Reply}, State);
handle_sync_event({time, prepare}, _From, StateName, State) ->
    continue(StateName, {ok, 0}, State);

%% 获取竞技时间
handle_sync_event({time, match}, _From, match_pre, State = #state{ts = Ts}) ->
    Reply = round((util:time_left(?top_fight_timeout_match_pre_cross, Ts) + ?top_fight_timeout_matching) / 1000),
    continue(match_pre, {ok, Reply}, State);
handle_sync_event({time, match}, _From, matching, State = #state{ts = Ts}) ->
    Reply = round(util:time_left(?top_fight_timeout_matching, Ts) / 1000),
    continue(matching, {ok, Reply}, State);

%% 获取巅峰对决地图信息
handle_sync_event({expend_arena_pre, Lev}, _From, prepare, State) ->
    StateName = prepare,
    ArenaZone = #top_fight_zone{arena_lev = ArenaLev, pre_seq = PreSeq, pre_role_size = PreRoleSize, pre_list = PreList} = case to_arena_lev(Lev) of
        ?top_fight_lev_low -> State#state.low;
        ?top_fight_lev_middle -> State#state.middle;
        ?top_fight_lev_hight -> State#state.hight;
        ?top_fight_lev_super -> State#state.super;
        ?top_fight_lev_angle -> State#state.angle
    end,
    case PreRoleSize >= 100 of
        true ->
            case map_mgr:create(?top_fight_prepare_map_id) of
                {false, Reason} ->
                    ?ERR("创建巅峰对决准备区地图失败[ArenaLev:~w, MapBaseId:~w]:~s", [ArenaLev, ?top_fight_prepare_map_id, Reason]),
                    continue(StateName, {false, Reason}, State);
                {ok, MapPid, MapId} ->
                    NewPreSeq = PreSeq + 1,
                    ?DEBUG("[巅峰对决]创建新的准备区Lev:~w, PreSeq:~w", [Lev, PreSeq]),
                    ArenaPrep = #top_fight_pre{pre_seq = NewPreSeq, map_id = MapId, map_pid = MapPid},
                    NewArenaZone = ArenaZone#top_fight_zone{pre_seq = NewPreSeq, pre_role_size = 0, pre_list = [ArenaPrep | PreList]},
                    NewState = case ArenaLev of
                        ?top_fight_lev_low -> State#state{low = NewArenaZone};
                        ?top_fight_lev_middle -> State#state{middle = NewArenaZone};
                        ?top_fight_lev_hight -> State#state{hight = NewArenaZone};
                        ?top_fight_lev_super -> State#state{super = NewArenaZone};
                        ?top_fight_lev_angle -> State#state{angle = NewArenaZone}
                    end,
                    continue(StateName, {StateName, PreSeq, MapId, MapPid}, NewState)
            end;
        false ->
            case lists:keyfind(PreSeq, #top_fight_pre.pre_seq, PreList) of
                false ->
                    continue(StateName, {false, ?L(<<"没有准备区地图信息">>)}, State);
                #top_fight_pre{pre_seq = PreSeq, map_id = MapId, map_pid = MapPid} ->
                    continue(StateName, {StateName, PreSeq, MapId, MapPid}, State)
            end
    end;
handle_sync_event({expend_arena_pre, _Lev}, _From, StateName, State) ->
    continue(StateName, {false, ?L(<<"巅峰对决开放时间为周日晚上 21:00 --- 21:40，敬请准时参加">>)}, State);

%% 角色进入准备区
handle_sync_event({enter_prepare, ArenaRole = #top_fight_role{arena_lev = ArenaLev, role_pid = RolePid}}, _From, prepare, State = #state{low = Low, middle = Middle, hight = Hight, super = Super, angle = Angle, ts = Ts}) ->
    role:pack_send(RolePid, 17311, {1, round(util:time_left(?top_fight_timeout_prepare_cross, Ts)/ 1000)}),
    case ArenaLev of
        ?top_fight_lev_low -> continue(prepare, {ok}, State#state{low = Low#top_fight_zone{pre_role_size = (Low#top_fight_zone.pre_role_size + 1), role_list = [ArenaRole | Low#top_fight_zone.role_list]}});
        ?top_fight_lev_middle -> continue(prepare, {ok}, State#state{middle = Middle#top_fight_zone{pre_role_size = (Middle#top_fight_zone.pre_role_size + 1), role_list = [ArenaRole | Middle#top_fight_zone.role_list]}});
        ?top_fight_lev_hight -> continue(prepare, {ok}, State#state{hight = Hight#top_fight_zone{pre_role_size = (Hight#top_fight_zone.pre_role_size + 1), role_list = [ArenaRole | Hight#top_fight_zone.role_list]}});
        ?top_fight_lev_super -> continue(prepare, {ok}, State#state{super = Super#top_fight_zone{pre_role_size = (Super#top_fight_zone.pre_role_size + 1), role_list = [ArenaRole | Super#top_fight_zone.role_list]}});
        ?top_fight_lev_angle -> continue(prepare, {ok}, State#state{angle = Angle#top_fight_zone{pre_role_size = (Angle#top_fight_zone.pre_role_size + 1), role_list = [ArenaRole | Angle#top_fight_zone.role_list]}})
    end;
handle_sync_event({enter_prepare, _ArenaRole}, _From, StateName, State) ->
    continue(StateName, {false, ?L(<<"现在不可以进入战场">>)}, State);

%% 角色离开准备区
handle_sync_event({exit_prepare, {RoleId, SrvId}}, _From, StateName, State) ->
    case get_arena_role({RoleId, SrvId}, State) of
        undefined ->
            continue(StateName, {false, ?L(<<"你貌似不在准备区中">>)}, State);
        ArenaRole = #top_fight_role{role_pid = RolePid} ->
            role:apply(async, RolePid, {top_fight_center_mgr, leave_prepare, []}),
            NewState = delete_arena_role(ArenaRole, State),
            continue(StateName, ok, NewState)
    end;

%% 进入巅峰对决
handle_sync_event({enter_match, {RoleId, SrvId}, Mask}, _From, match_pre, State) ->
    case get_arena_role({RoleId, SrvId}, State) of
        undefined ->
            continue(match_pre, {false, ?L(<<"你貌似不在准备区中">>)}, State);
        ArenaRole = #top_fight_role{role_pid = RolePid} ->
            NewArenaRole = ArenaRole#top_fight_role{mask = Mask, status = ?top_fight_role_status_match},
            role:apply(async, RolePid, {top_fight_center_mgr, do_enter_match, [NewArenaRole]}),
            NewState = update_arena_role(NewArenaRole, State),
            continue(match_pre, {ok}, NewState)
    end;
handle_sync_event({enter_match, {_RoleId, _SrvId}, _Mask}, _From, StateName, State) ->
    continue(StateName, {false, ?L(<<"进入战场的时间已过，施主请回">>)}, State);

%% 登录
handle_sync_event({login, prepare, RoleId, SrvId, Pid}, _From, prepare, State = #state{ts = Ts}) ->
    case get_arena_role({RoleId, SrvId}, State) of
        undefined -> continue(prepare, false, State);
        ArenaRole = #top_fight_role{} ->
            Time = round(util:time_left(?top_fight_timeout_prepare_cross, Ts)/ 1000),
            NewState = update_arena_role(ArenaRole#top_fight_role{status = ?top_fight_role_status_prepare, role_pid = Pid}, State),
            continue(prepare, {ok, Time}, NewState)
    end;
handle_sync_event({login, match, RoleId, SrvId, Pid}, _From, StateName, State) when StateName =:= match_pre orelse StateName =:= matching->
    case get_arena_role({RoleId, SrvId}, State) of
        _ArenaRole = #top_fight_role{arena_pid = ArenaPid} when is_pid(ArenaPid) ->
            case is_process_alive(ArenaPid) of
                true ->
                    case catch top_fight_center:login(ArenaPid, RoleId, SrvId, Pid) of
                        {ok, ArenaRole2} ->
                            NewArenaRole = ArenaRole2#top_fight_role{status = ?top_fight_role_status_match, role_pid = Pid},
                            NewState = update_arena_role(NewArenaRole, State),
                            continue(StateName, {ok, NewArenaRole}, NewState);
                        _ -> continue(StateName, false, State)
                    end;
                false -> continue(StateName, false, State)
            end;
        _ -> continue(StateName, false, State)
    end;

%% 获取巅峰对决面板信息
handle_sync_event(get_panel_info, _From, StateName, State) ->
    Reply = parse_panel_info(StateName, State),
    continue(StateName, {ok, Reply}, State);

%% 获取巅峰对决英雄榜信息
handle_sync_event({get_hero_rank, ArenaLev, ArenaSeq}, _From, StateName, State = #state{hero_rank = HeroRank}) ->
    Reply = case do_get_hero_rank(HeroRank, ArenaLev, ArenaSeq) of
        {ok, Num, ArenaHeroZone} -> {ok, Num, ArenaHeroZone};
        {false, Reason} -> {false, Reason}
    end,
    continue(StateName, Reply, State);

%% 获取巅峰对决排行榜
handle_sync_event({sync_hero_rank}, _From, StateName, State = #state{hero_rank = HeroRank}) ->
    continue(StateName, {ok, HeroRank}, State);

handle_sync_event({sync_top_hero}, _From, StateName, State = #state{top_hero = Thero}) ->
    continue(StateName, {ok, Thero}, State);

handle_sync_event({sync_status}, _From, StateName, State = #state{ts = Ts}) ->
    continue(StateName, {ok, Ts, StateName}, State);

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(StateName, Reply, State).

%% 处理地图进程正常退出
handle_info({'EXIT', Pid, normal}, StateName, State) ->
    case delete_arena_online(Pid, State) of
        {false, _Reason} ->
            %% ?DEBUG("[巅峰对决]接收到巅峰对决进程退出信息有误:~w", [_Reason]),
            continue(StateName, State);
        {#top_fight_online{arena_id = {_ArenaLev, _ArenaSeq}}, NewState} ->
            ?DEBUG("[巅峰对决]巅峰对决已经正常退出[ArenaLev:~w, ArenaSeq:~w]", [_ArenaLev, _ArenaSeq]),
            continue(StateName, NewState)
    end;

%% 处理地图进程异常退出
handle_info({'EXIT', Pid, Why}, StateName, State) ->
    ?ELOG("连接的进程[~w]异常退出: ~w", [Pid, Why]),
    continue(StateName, State);

%% 广播
handle_info({send_msg_notic}, notice, State = #state{ts = _Ts}) ->
    %{_, M, S} = calendar:seconds_to_time(round(util:time_left(?top_fight_timeout_notice, Ts)/ 1000)),
    %case M > 0 of
    %    true ->
    %        notice:send(54, util:fbin(?L(<<"仙法竞技，决胜巅峰，谁是飞仙第一霸主，还看巅峰之决战，决战开启在即，请各飞仙高人做好准备！">>), [M, S]));
    %    false ->
    %        notice:send(54, util:fbin(?lang_topfight_notice_sign2, [S]))
    %end,
    %erlang:send_after(60 * 1000, self(), {send_msg_notic}),
    continue(notice, State);

handle_info({send_msg_prepare}, prepare, State) ->
    notice:send(54, util:fbin(?L(<<"巅峰对决正在火热报名中...">>), [])),
    erlang:send_after(60 * 1000, self(), {send_msg_prepare}),
    continue(prepare, State);

%% 初始化
handle_info({init_hero_rank}, StateName, State) ->
    ?DEBUG("更新英雄榜数据"),
    NewState = case top_fight_dao_log:get_last_time() of
        {ok, Data} -> 
            Fun = fun([Time, _ArenaLev], MaxTime) ->
                case Time > MaxTime of
                    true -> Time;
                    false -> MaxTime
                end
            end,
            MTime = lists:foldl(Fun, 0, Data),
            init_hero_rank(State#state{hero_rank = #top_fight_hero_rank{}}, MTime);
         _ -> 
             ?DEBUG("没有更新英雄榜数据"),
             State
    end,
    c_mirror_group:cast(all, top_fight_mgr, update_hero_rank, [NewState#state.hero_rank]),
    continue(StateName, NewState);

%% 更新霸主
handle_info({update_top_hero}, StateName, State = #state{hero_rank = #top_fight_hero_rank{low = Zones}}) ->
    case get_top_hero(Zones) of
        {ok, Hero = #top_fight_hero{srv_id = SrvId}} ->
            c_mirror_group:cast(node, SrvId, top_fight_mgr, handle_top_hero, [Hero]),
            ok;
        _ ->
            ok
    end,
    continue(StateName, State);

handle_info({update_honor}, StateName, State = #state{hero_rank = #top_fight_hero_rank{low = Zones}}) ->
    ?INFO("更新巅峰对决称号"),
    case get_seq_winner(Zones) of
        {ok, Winners} ->
            c_mirror_group:cast(all, top_fight_mgr, handle_seq_winners, [Winners]),
            ok;
        _ ->
            ok
    end,
    continue(StateName, State);

%% 同步数据到节点服
handle_info({adm_sync}, StateName, State = #state{top_hero = TopHero, hero_rank = HeroRank, ts = Ts}) ->
    c_mirror_group:cast(all, top_fight_mgr, update_top_hero, [TopHero]),
    c_mirror_group:cast(all, top_fight_mgr, update_hero_rank, [HeroRank]),
    c_mirror_group:cast(all, top_fight_mgr, update_status, [Ts, StateName]),
    ?INFO("同步巅峰对决数据到节点服"),
    continue(StateName, State);

handle_info({debug}, StateName, State) ->
    ?DEBUG("top_fight_center_mgr state: ~w", [State]),
    continue(StateName, State);

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%----------------------------------------------------
%% 状态处理
%%----------------------------------------------------

%% 开始报名 
idel(timeout, State) ->
    ?INFO("[巅峰对决]发送活动通知-准备阶段1"),
    c_mirror_group:cast(all, top_fight_mgr, change_status, [notice]),
    {next_state, notice, State#state{ts = erlang:now(), timeout = ?top_fight_timeout_notice}, ?top_fight_timeout_notice};
idel(_Any, State) ->
    continue(idel, State).

%% 通知巅峰对决活动
notice(timeout, State) ->
    ?INFO("[巅峰对决]发送活动通知-报名阶段"),
    case create_map(prepare, State, [?top_fight_lev_low, ?top_fight_lev_middle, ?top_fight_lev_hight, ?top_fight_lev_super, ?top_fight_lev_angle]) of
        {false, Reason} ->
            ?ERR("创建巅峰对决准备区地图失败:~s", [Reason]),
            {stop, normal, State};
        NewState ->
            c_mirror_group:cast(all, top_fight_mgr, change_status, [prepare]),
            {next_state, prepare, NewState#state{ts = erlang:now(), timeout = ?top_fight_timeout_prepare_cross_st}, ?top_fight_timeout_prepare_cross_st}
    end;
notice(_Any, State) ->
    continue(notice, State).

%% 准备时间已经结束
prepare(timeout, State) ->
    ?INFO("[巅峰对决]比赛前期，可进入战场"),
    %% notice:send(54, util:fbin(?L(<<"巅峰对决比赛正式开始!">>), [])),
    %% PanelInfo = parse_panel_info(match_pre, State),
    %% role_group:pack_cast(world, 13322, PanelInfo),
    %% role_group:pack_cast(world, 13300, {-1}),
    State2 = reset_role_list(State, [?top_fight_lev_angle, ?top_fight_lev_super, ?top_fight_lev_hight, ?top_fight_lev_middle]), %% 最底等级不处理,
    Time = util:unixtime(),
    case startup_branch(State2, Time, [?top_fight_lev_low, ?top_fight_lev_middle, ?top_fight_lev_hight, ?top_fight_lev_super, ?top_fight_lev_angle]) of
        {ok, NewState} ->
            c_mirror_group:cast(all, top_fight_mgr, change_status, [match_pre]),
            {next_state, match_pre, NewState#state{ts = erlang:now(), timeout = ?top_fight_timeout_match_pre_cross}, ?top_fight_timeout_match_pre_cross};
        {false, Reason} ->
            ?INFO("启动巅峰对决失败[Reason:~w]", [Reason]),
            {stop, normal, #state{}}
    end;
prepare(_Any, State) ->
    continue(prepare, State).

match_pre(timeout, State) ->
    ?INFO("[巅峰对决]比赛后期，不可进入战场，准备区玩家离开"),
    NewState = role_leave(State),
    ArenaOnlineList = get_all_arena_online(State),
    check_after_pre(ArenaOnlineList),
    %% PanelInfo = parse_panel_info(matching, State),
    %% role_group:pack_cast(world, 13322, PanelInfo),
    c_mirror_group:cast(all, top_fight_mgr, change_status, [matching]),
    {next_state, matching, NewState#state{ts = erlang:now(), timeout = ?top_fight_timeout_matching}, ?top_fight_timeout_matching}; %% 时间临时设置
match_pre(_Any, State) ->
    continue(match_pre, State).

%% 比赛已经结束
matching(timeout, State) ->
    ?INFO("[巅峰对决]比赛结束 - 停止比赛"),
    ArenaOnlineList = get_all_arena_online(State),
    stop_all_arena(ArenaOnlineList),
    %% PanelInfo = parse_panel_info(expire, State),
    %% role_group:pack_cast(world, 13322, PanelInfo),
    c_mirror_group:cast(all, top_fight_mgr, change_status, [expire]),
    {next_state, expire, State#state{ts = erlang:now(), timeout = ?top_fight_timeout_expire}, ?top_fight_timeout_expire}; %% 时间临时设置
matching(_Any, State) ->
    continue(matching, State).

%% 等级各战区结束
expire(timeout, State = #state{low = Low, middle = Middle, hight = Hight, super = Super, angle = Angle}) ->
    ?INFO("[巅峰对决]比赛结束 - 关闭巅峰对决"),
    ArenaOnlineList = get_all_arena_online(State),
    PreList = get_all_arena_pre(State),
    close_all_arena(ArenaOnlineList),
    close_all_pre(PreList),
    erlang:send_after(10 * 1000, self(), {init_hero_rank}), %% 十秒后更新巅峰对决英雄榜
    erlang:send_after(20 * 1000, self(), {update_top_hero}),
    erlang:send_after(20 * 1000, self(), {update_honor}),
    IdelTime = get_idel_time(),
    c_mirror_group:cast(all, top_fight_mgr, change_status, [idel]),
    {next_state, idel, State#state{ts = erlang:now(), timeout = IdelTime
            ,low = Low#top_fight_zone{role_list = [], pre_list = [], arena_list = [], pre_seq = 1, pre_role_size = 0}
            ,middle = Middle#top_fight_zone{role_list = [], pre_list = [], arena_list = [], pre_seq = 1, pre_role_size = 0}
            ,hight = Hight#top_fight_zone{role_list = [], pre_list = [], arena_list = [], pre_seq = 1, pre_role_size = 0}
            ,super = Super#top_fight_zone{role_list = [], pre_list = [], arena_list = [], pre_seq = 1, pre_role_size = 0}
            ,angle = Angle#top_fight_zone{role_list = [], pre_list = [], arena_list = [], pre_seq = 1, pre_role_size = 0}}, IdelTime}; %% 时间临时设置
expire(_Any, State) ->
    continue(expire, State).

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

%% @spec create_map(State) -> NewState
%% 创建所有级别的准备区地图
create_map(prepare, State, []) ->
    State;
create_map(prepare, State = #state{low = Low = #top_fight_zone{last_win = LowLastWin}, 
        middle = Middle = #top_fight_zone{last_win = MiddleLastWin}, 
        hight = Hight = #top_fight_zone{last_win = HightLastWin}, 
        super = Super = #top_fight_zone{last_win = SuperLastWin}, 
        angle = Angle = #top_fight_zone{last_win = AngleLastWin} 
    }, [Type| T]) ->
    case map_mgr:create(?top_fight_prepare_map_id) of
        {false, Reason} ->
            ?ERR("创建巅峰对决准备区地图失败[Type:~w, MapBaseId:~w]:~s", [Type, ?top_fight_prepare_map_id, Reason]),
            {false, Reason};
        {ok, MapPid, MapId} ->
            ArenaPrep = #top_fight_pre{pre_seq = 1, map_id = MapId, map_pid = MapPid},
            case Type of
                ?top_fight_lev_low    -> create_map(prepare, State#state{low = Low#top_fight_zone{pre_seq = 1, pre_role_size = 0, arena_lev = ?top_fight_lev_low, pre_list = [ArenaPrep], last_win = LowLastWin#top_fight_lw{kill = 0}}}, T);
                ?top_fight_lev_middle -> create_map(prepare, State#state{middle = Middle#top_fight_zone{pre_seq = 1, pre_role_size = 0, arena_lev = ?top_fight_lev_middle, pre_list = [ArenaPrep], last_win = MiddleLastWin#top_fight_lw{kill = 0}}}, T);
                ?top_fight_lev_hight  -> create_map(prepare, State#state{hight = Hight#top_fight_zone{pre_seq = 1, pre_role_size = 0, arena_lev = ?top_fight_lev_hight, pre_list = [ArenaPrep], last_win = HightLastWin#top_fight_lw{kill = 0}}}, T);
                ?top_fight_lev_super  -> create_map(prepare, State#state{super = Super#top_fight_zone{pre_seq = 1, pre_role_size = 0, arena_lev = ?top_fight_lev_super, pre_list = [ArenaPrep], last_win = SuperLastWin#top_fight_lw{kill = 0}}}, T);
                ?top_fight_lev_angle  -> create_map(prepare, State#state{angle = Angle#top_fight_zone{pre_seq = 1, pre_role_size = 0, arena_lev = ?top_fight_lev_angle, pre_list = [ArenaPrep], last_win = AngleLastWin#top_fight_lw{kill = 0}}}, T);
                _ -> {false, ?L(<<"非法级别">>)}
            end
    end.

%% 检查条件
check(sign_up, _Role = #role{lev = Lev, attr = #attr{fight_capacity = Fc}, assets = #assets{coin = Coin, coin_bind = CoinBind}}) ->
    case Lev < 70 of
        true ->
            {false, ?L(<<"您等级不足70级，暂时不能报名巅峰对决">>)};
        false ->
            case Fc < 22000 of
                true ->
                    {false, ?L(<<"您的战斗力没有达到22000，暂时不能报名巅峰对决">>)};
                false ->
                    case (Coin + CoinBind) >= 1000 of
                        false -> {false, ?L(<<"你金币不足1000，不可报名。">>)};
                        true -> ok
                    end
            end
    end.

%% 报名
do_sign_up(Role = #role{lev = Lev, ride = Ride}) ->
    case catch expend_arena_pre(Lev) of
        {StateName, PreSeq, MapId, MapPid} ->
            case StateName of
                prepare ->
                    ArenaRole = convert(init, PreSeq, MapId, MapPid, Role),
                    case ?top_fight_CALL(gen_fsm, sync_send_all_state_event, [?MODULE, {enter_prepare, ArenaRole#top_fight_role{status = ?top_fight_role_status_prepare}}]) of
                        {ok} ->
                            {X, Y} = util:rand_list([{1140, 1500}, {1980, 1500}, {1560, 1290}, {1560, 1710}]),
                            %% {X, Y} = ?top_fight_prepare_pos,
                            NewX = util:rand(X - 80, X + 80),
                            NewY = util:rand(Y - 80, Y + 80),
                            Role2 = case Ride of
                                ?ride_no -> Role;
                                _ -> Role#role{ride = ?ride_no}
                            end,
                            Role3 = role_listener:special_event(Role2, {30029, 1}), 
                            case map:role_enter(MapId, NewX, NewY, Role3#role{cross_srv_id = <<"center">>, event = ?event_top_fight_prepare}) of
                                {ok, NewRole = #role{assets = Assets = #assets{coin = Coin, coin_bind = CoinBind}}} ->
                                    {NewCoin, NewCoinBind} = case CoinBind >= 1000 of
                                        true -> {Coin, CoinBind - 1000};
                                        false -> {Coin + CoinBind - 1000, 0}
                                    end,
                                    NewRole2 = NewRole#role{assets = Assets#assets{coin = NewCoin, coin_bind = NewCoinBind}},
                                    role_api:push_assets(Role, NewRole2),
                                    {ok, NewRole2};
                                {false, Why} ->
                                    ?top_fight_CALL(gen_fsm, send_all_state_event, [?MODULE, {del_cache, ArenaRole}]),
                                    {false, Why}
                            end;
                        {false, Reason} ->
                            {false, Reason};
                        ok ->
                            {false, ?L(<<"报名时间已过，请注意下次报名时间">>)}
                    end;
                _ ->
                    {false, ?L(<<"巅峰对决开放时间为周日晚上 21:00 --- 21:40，敬请准时参加">>)}
            end;
        {false, Reason} -> {false, Reason};
        _ -> {false, ?L(<<"你与时空隧道失去联系">>)}
    end.

%% @spec startup_branch(State) -> {ok, NewState} | {false, Reason}
%% @doc 启动各级别的巅峰对决
startup_branch(State, _Time, []) -> {ok, State};
startup_branch(State = #state{low = ArenaZone}, Time, [?top_fight_lev_low | T]) ->
    NewArenaZone = startup_zone(ArenaZone, Time),
    startup_branch(State#state{low = NewArenaZone}, Time, T);
startup_branch(State = #state{middle = ArenaZone}, Time, [?top_fight_lev_middle | T]) ->
    NewArenaZone = startup_zone(ArenaZone, Time),
    startup_branch(State#state{middle = NewArenaZone}, Time, T);
startup_branch(State = #state{hight = ArenaZone}, Time, [?top_fight_lev_hight| T]) ->
    NewArenaZone = startup_zone(ArenaZone, Time),
    startup_branch(State#state{hight = NewArenaZone}, Time, T);
startup_branch(State = #state{super = ArenaZone}, Time, [?top_fight_lev_super| T]) ->
    NewArenaZone = startup_zone(ArenaZone, Time),
    startup_branch(State#state{super = NewArenaZone}, Time, T);
startup_branch(State = #state{angle = ArenaZone}, Time, [?top_fight_lev_angle| T]) ->
    NewArenaZone = startup_zone(ArenaZone, Time),
    startup_branch(State#state{angle = NewArenaZone}, Time, T).

%% @spec startup_branch(Type, ArenaZone) -> NewArenaZone
%% @doc
%% 启动一个级别的战场
%% 一个战场可能有多个战区
startup_zone(ArenaZone = #top_fight_zone{pre_list = _PreList, role_list = RoleList, arena_lev = ArenaLev}, Time) ->
    Length = length(RoleList),
    ?INFO("[巅峰对决]正式开始ArenaLev:~w, RoleListSize:~w", [ArenaLev, Length]),
    case Length < ?top_fight_player_least of
        true -> 
            send_to_arena_role(RoleList, {17304, {4, []}}),
            ArenaZone#top_fight_zone{arena_list = []};
        false ->
            NewRoleList = group_split_qsort(RoleList),
            NumList = split_num(Length, ArenaLev),
            RoleGroup = split_role_list(NumList, NewRoleList),
            GroupNum = length(NumList),
            start_link_arena(ArenaZone, RoleGroup, lists:seq(1, GroupNum), Time)
    end.

%% 按等级快速排序
%% zone_split_qsort([]) -> [];
%% zone_split_qsort([ArenaRole = #top_fight_role{lev = Lev} | T]) ->
%%     zone_split_qsort([AR || AR = #top_fight_role{lev = ARLev} <- T, ARLev > Lev])
%%     ++ [ArenaRole] ++
%%     zone_split_qsort([AR || AR = #top_fight_role{lev = ARLev} <- T, ARLev =< Lev]).

%% 按战斗力快速排序
group_split_qsort([]) -> [];
group_split_qsort([ArenaRole = #top_fight_role{fight_capacity = Fight} | T]) ->
    group_split_qsort([AR || AR = #top_fight_role{fight_capacity = ARFight} <- T, ARFight > Fight])
    ++ [ArenaRole] ++
    group_split_qsort([AR || AR = #top_fight_role{fight_capacity = ARFight} <- T, ARFight =< Fight]).

%% @spec split_num(Num) -> [integer()]
%% @doc 一个区最少N个人
split_num(Num, ArenaLev) ->
    GroupNum = zone_group(Num, ArenaLev),
    Div = Num div GroupNum,
    Rem = Num rem GroupNum,
    average_num(convert_num_list(GroupNum, Div), 0, Rem).

convert_num_list(0, _Div) -> [];
convert_num_list(Num, Div) when Num > 0 ->
    [Div | convert_num_list((Num - 1), Div)];
convert_num_list(Num, _Div) when Num =< 0 -> [].

%% 增加平均分配
average_num([], _Div, _Rem) -> [];
average_num([Elen | T], Div, Rem) when Rem > 0 ->
    [(Elen + Div + 1) | average_num(T, Div, (Rem - 1))];
average_num([Elen | T], Div, Rem) ->
    [(Elen + Div) | average_num(T, Div, Rem)].

%% 分组角色列表
split_role_list(_NumList, []) -> [];
split_role_list([], _RoleList) -> [];
split_role_list([Num | T], RoleList) ->
    {List1, List2} = lists:split(Num, RoleList),
    [List1 | split_role_list(T, List2)].

%% 启动战区进程
start_link_arena(ArenaZone, [], _, _) -> ArenaZone;
start_link_arena(ArenaZone, _, [], _) -> ArenaZone;
start_link_arena(ArenaZone = #top_fight_zone{arena_lev = ArenaLev, arena_list = ArenaList, role_list = ZoneRoleList}, [RoleList | RT], [ArenaSeq | AT], Time) ->
    case top_fight_center:start_link(ArenaLev, ArenaSeq, Time, length(RoleList)) of
        {ok, Pid} ->
            %%send_to_arena_role(RoleList, {17307, {}}),
            rpc_to_arena_role(RoleList),
            QSortRoleList = group_split_qsort(RoleList),
            NewRoleList = grouping_role(role_list, QSortRoleList, {Pid, ArenaLev, ArenaSeq}),
            NewZoneRoleList = update_zone_role(ZoneRoleList, NewRoleList),
            start_link_arena(ArenaZone#top_fight_zone{arena_list = [#top_fight_online{arena_id = {ArenaLev, ArenaSeq}, arena_pid = Pid} | ArenaList], role_list = NewZoneRoleList}, RT, AT, Time);
        _ ->
            send_to_arena_role(RoleList, {17304, {4, []}}),
            ?DEBUG("[巅峰对决]启动巅峰对决战区进程失败ArenaLev:~w ArenaSeq:~w", [ArenaLev, ArenaSeq]),
            start_link_arena(ArenaZone, RT, AT, Time)
    end.

%% 给指定的角色列表发送消息
send_to_arena_role([], {_Cmd, _Data}) -> ok;
send_to_arena_role([#top_fight_role{role_pid = RolePid} | T], {Cmd, Data}) ->
    role:pack_send(RolePid, Cmd, Data),
    send_to_arena_role(T, {Cmd, Data}).

%% 给指定角色执行某个操作
rpc_to_arena_role([]) -> ok;
rpc_to_arena_role([#top_fight_role{role_pid = RolePid} | T]) ->
    role:rpc(RolePid, top_fight_rpc, 17302, {}),
    rpc_to_arena_role(T).

%% 发送到同一个级别的多个准备区
%% send_to_pre_map([], {_Cmd, _Data}) -> ok;
%% send_to_pre_map([#top_fight_pre{map_id = MapId} | T], {Cmd, Data}) ->
%%     map:pack_send_to_all(MapId, Cmd, Data),
%%     send_to_pre_map(T, {Cmd, Data}).

%% 一级分组情况 
zone_group(Num, ?top_fight_lev_super) ->
    Num div 40 + 1;
zone_group(Num, ?top_fight_lev_angle) ->
    Num div 40 + 1;
zone_group(Num, _) ->
    Num div 40 + 1.

%% 更新角色信息
update_zone_role(ZoneRoleList, []) -> ZoneRoleList;
update_zone_role(ZoneRoleList, [ArenaRole = #top_fight_role{role_id = {RoleId, SrvId}} | T]) ->
    NewZoneRoleList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, ZoneRoleList, ArenaRole),
    update_zone_role(NewZoneRoleList, T).

%% 竞技时间到了
role_leave(State = #state{low = Low, middle = Middle, hight = Hight, super = Super, angle = Angle}) ->
    NewLowList = do_role_leave(Low#top_fight_zone.role_list),
    NewMiddleList = do_role_leave(Middle#top_fight_zone.role_list),
    NewHightList = do_role_leave(Hight#top_fight_zone.role_list),
    NewSuperList = do_role_leave(Super#top_fight_zone.role_list),
    NewAngleList = do_role_leave(Angle#top_fight_zone.role_list),
    State#state{low = Low#top_fight_zone{role_list = NewLowList}, middle = Middle#top_fight_zone{role_list = NewMiddleList}, hight = Hight#top_fight_zone{role_list = NewHightList}, super = Super#top_fight_zone{role_list = NewSuperList}, angle = Angle#top_fight_zone{role_list = NewAngleList}}.

do_role_leave([#top_fight_role{name = _Name, status = ?top_fight_role_status_prepare, role_pid = RolePid} | T]) ->
    role:apply(async, RolePid, {top_fight_center_mgr, leave_prepare, []}),
    do_role_leave(T);
do_role_leave([ArenaRole | T]) ->
    [ArenaRole | do_role_leave(T)];
do_role_leave([]) ->
    [].

%% 停止所有巅峰对决
stop_all_arena([#top_fight_online{arena_pid = ArenaPid} | T]) ->
    ?DEBUG("停止所有巅峰对决"),
    top_fight_center:stop(ArenaPid),
    stop_all_arena(T);
stop_all_arena([]) ->
    ok.

%% 检查巅峰对决成员
check_after_pre([#top_fight_online{arena_pid = ArenaPid} | T]) ->
    top_fight_center:check_after_pre(ArenaPid),
    check_after_pre(T);
check_after_pre([]) ->
    ok.

%% 关闭所有巅峰对决
close_all_arena([#top_fight_online{arena_pid = ArenaPid} | T]) ->
    top_fight_center:close(ArenaPid),
    close_all_arena(T);
close_all_arena([]) ->
    ok.

%% 关闭所有准备区地图
close_all_pre([]) -> ok;
close_all_pre([#top_fight_pre{map_id = MapId} | T]) ->
    map_mgr:stop(MapId),
    close_all_pre(T).

%% 角色离开准备区
leave_prepare(Role = #role{name = _Name, looks = Looks, pos = #pos{last = _LastPos}, event = _Event}) ->
    {ExitMapId, X, Y} = ?top_fight_exit,
    NewX = util:rand(X - 50, X + 50),
    NewY = util:rand(Y - 50, Y + 50),
    NewLooks = lists:keydelete(?LOOKS_TYPE_MODEl, 1, Looks),
    case map:role_enter(ExitMapId, NewX, NewY, Role#role{event = ?event_no, looks = NewLooks, cross_srv_id = <<>>}) of
        {ok, NewRole} ->
            {ok, NewRole};
        {false, _Why} ->
            ?DEBUG("[~s]退出准备区失败[Reason:~w]", [_Name, _Why]),
            {ok}
    end.

%% 玩家列表分组
grouping_role(role_list, RoleList, {Pid, ArenaLev, ArenaSeq}) ->
    Fun = fun(Elen, {Flag, Dragon, Tiger}) ->
        case Flag of
            1 -> {2, [Elen#top_fight_role{group_id = 1, arena_id = {ArenaLev, ArenaSeq}, arena_pid = Pid, arena_seq = ArenaSeq} | Dragon], Tiger};
            2 -> {1, Dragon, [Elen#top_fight_role{group_id = 2, arena_id = {ArenaLev, ArenaSeq}, arena_pid = Pid, arena_seq = ArenaSeq} | Tiger]}
        end
    end,
    {_Flag, Dragon, Tiger} = lists:foldl(Fun, {1, [], []}, RoleList),
    Dragon ++ Tiger.

%% 获取玩家信息
%% 玩家可能在准备升级导致玩家进入战场的时候计算的分组不一样。所以不可以重新计算
get_arena_role({RoleId, SrvId}, #state{low = Low, middle = Middle, hight = Hight, super = Super, angle = Angle}) ->
    case lists:keyfind({RoleId,SrvId}, #top_fight_role.role_id, Low#top_fight_zone.role_list) of
        false ->
            case lists:keyfind({RoleId,SrvId}, #top_fight_role.role_id, Middle#top_fight_zone.role_list) of
                false ->
                    case lists:keyfind({RoleId,SrvId}, #top_fight_role.role_id, Hight#top_fight_zone.role_list) of
                        false ->
                            case lists:keyfind({RoleId,SrvId}, #top_fight_role.role_id, Super#top_fight_zone.role_list) of
                                false ->
                                    case lists:keyfind({RoleId,SrvId}, #top_fight_role.role_id, Angle#top_fight_zone.role_list) of
                                        false -> undefined;
                                        ArenaRole -> ArenaRole
                                    end;
                                ArenaRole -> ArenaRole
                            end;
                        ArenaRole -> ArenaRole
                    end;
                ArenaRole -> ArenaRole
            end;
        ArenaRole -> ArenaRole
    end.
    
%% 删除玩家信息
delete_arena_role(#top_fight_role{role_id = {RoleId, SrvId}, arena_lev = ArenaLev}, State = #state{low = Low, middle = Middle, hight = Hight, super = Super, angle = Angle}) ->
    case ArenaLev of
        ?top_fight_lev_low ->
            NewList = lists:keydelete({RoleId, SrvId}, #top_fight_role.role_id, Low#top_fight_zone.role_list),
            State#state{low = Low#top_fight_zone{role_list = NewList}};
        ?top_fight_lev_middle ->
            NewList = lists:keydelete({RoleId, SrvId}, #top_fight_role.role_id, Middle#top_fight_zone.role_list),
            State#state{middle = Middle#top_fight_zone{role_list = NewList}};
        ?top_fight_lev_hight ->
            NewList = lists:keydelete({RoleId, SrvId}, #top_fight_role.role_id, Hight#top_fight_zone.role_list),
            State#state{hight = Hight#top_fight_zone{role_list = NewList}};
        ?top_fight_lev_super ->
            NewList = lists:keydelete({RoleId, SrvId}, #top_fight_role.role_id, Super#top_fight_zone.role_list),
            State#state{super = Super#top_fight_zone{role_list = NewList}};
        ?top_fight_lev_angle ->
            NewList = lists:keydelete({RoleId, SrvId}, #top_fight_role.role_id, Angle#top_fight_zone.role_list),
            State#state{angle = Angle#top_fight_zone{role_list = NewList}}
    end.

%% @spec delete_arena_online(ArenaPid::pid(), State::#state{}) -> NewState::#state() | {false, Reason}
%% @doc 删除战场记录
delete_arena_online(ArenaPid, State = #state{low = Low, middle = Middle, hight = Hight, super = Super, angle = Angle}) ->
    case lists:keyfind(ArenaPid, #top_fight_online.arena_pid, Low#top_fight_zone.arena_list) of
        ArenaOnline when is_record(ArenaOnline, top_fight_online) ->
            NewArenaOnlineList = lists:keydelete(ArenaPid, #top_fight_online.arena_pid, Low#top_fight_zone.arena_list),
            {ArenaOnline, State#state{low = Low#top_fight_zone{arena_list = NewArenaOnlineList}}};
        false ->
            case lists:keyfind(ArenaPid, #top_fight_online.arena_pid, Middle#top_fight_zone.arena_list) of
                ArenaOnline when is_record(ArenaOnline, top_fight_online) ->
                    NewArenaOnlineList = lists:keydelete(ArenaPid, #top_fight_online.arena_pid, Middle#top_fight_zone.arena_list),
                    {ArenaOnline, State#state{middle = Middle#top_fight_zone{arena_list = NewArenaOnlineList}}};
                false ->
                    case lists:keyfind(ArenaPid, #top_fight_online.arena_pid, Hight#top_fight_zone.arena_list) of
                        ArenaOnline when is_record(ArenaOnline, top_fight_online) ->
                            NewArenaOnlineList = lists:keydelete(ArenaPid, #top_fight_online.arena_pid, Hight#top_fight_zone.arena_list),
                            {ArenaOnline, State#state{hight = Hight#top_fight_zone{arena_list = NewArenaOnlineList}}};
                        false ->
                            case lists:keyfind(ArenaPid, #top_fight_online.arena_pid, Super#top_fight_zone.arena_list) of
                                ArenaOnline when is_record(ArenaOnline, top_fight_online) ->
                                    NewArenaOnlineList = lists:keydelete(ArenaPid, #top_fight_online.arena_pid, Super#top_fight_zone.arena_list),
                                    {ArenaOnline, State#state{super = Super#top_fight_zone{arena_list = NewArenaOnlineList}}};
                                false ->
                                    case lists:keyfind(ArenaPid, #top_fight_online.arena_pid, Angle#top_fight_zone.arena_list) of
                                        ArenaOnline when is_record(ArenaOnline, top_fight_online) ->
                                            NewArenaOnlineList = lists:keydelete(ArenaPid, #top_fight_online.arena_pid, Angle#top_fight_zone.arena_list),
                                            {ArenaOnline, State#state{angle = Angle#top_fight_zone{arena_list = NewArenaOnlineList}}};
                                        false ->
                                            {false, ?L(<<"没有找到相关进程信息">>)}
                                    end
                            end
                    end
            end
    end.

%% 更新玩家信息
update_arena_role(ArenaRole = #top_fight_role{role_id = {RoleId, SrvId}, arena_lev = ArenaLev}, State = #state{low = Low, middle = Middle, hight = Hight, super = Super, angle = Angle}) ->
    case ArenaLev of
        ?top_fight_lev_low ->
            NewList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, Low#top_fight_zone.role_list, ArenaRole),
            State#state{low = Low#top_fight_zone{role_list = NewList}};
        ?top_fight_lev_middle ->
            NewList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, Middle#top_fight_zone.role_list, ArenaRole),
            State#state{middle = Middle#top_fight_zone{role_list = NewList}};
        ?top_fight_lev_hight ->
            NewList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, Hight#top_fight_zone.role_list, ArenaRole),
            State#state{hight = Hight#top_fight_zone{role_list = NewList}};
        ?top_fight_lev_super ->
            NewList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, Super#top_fight_zone.role_list, ArenaRole),
            State#state{super = Super#top_fight_zone{role_list = NewList}};
        ?top_fight_lev_angle ->
            NewList = lists:keyreplace({RoleId, SrvId}, #top_fight_role.role_id, Angle#top_fight_zone.role_list, ArenaRole),
            State#state{angle = Angle#top_fight_zone{role_list = NewList}}
    end.

%% 进入战场
do_enter_match(Role = #role{looks = Looks, max_fc = #max_fc{max = FightCapacity}}, ArenaRole = #top_fight_role{arena_pid = ArenaPid, group_id = GroupId}) ->
    NewArenaRole = ArenaRole#top_fight_role{fight_capacity = FightCapacity, score = 0},
    case top_fight_center:enter_match(ArenaPid, NewArenaRole) of
        {ok, MapId} ->
            {X, Y} = case GroupId of
                1 -> ?top_fight_relive_dragon;
                _ -> ?top_fight_relive_tiger
            end,
            NewX = util:rand(X - 100, X + 100),
            NewY = util:rand(Y - 100, Y + 100),
            GroupLooks = update_looks(Looks, NewArenaRole),
            case map:role_enter(MapId, NewX, NewY, Role#role{cross_srv_id = <<"center">>, event = ?event_top_fight_match, looks = GroupLooks, event_pid = ArenaPid}) of
                {ok, NewRole} ->
                    NewRole2 = role_listener:special_event(NewRole, {1009, finish}),
                    NewRole3 = role_listener:acc_event(NewRole2, {109, 1}), 
                    {ok, NewRole3};
                {false, _Why} ->
                    {ok}
            end;
        _Any ->
            {ok}
    end.

%% 算计空闲时间
%%get_idel_time() ->
%%    Now = util:unixtime(),
%%    Today = util:unixtime({today, Now}),
%%    IdelTime = case (Today + ?top_fight_begin_time) > Now of
%%        true -> (Today + ?top_fight_begin_time - Now);
%%        false ->
%%            util:unixtime({tomorrow, Now}) - Now + ?top_fight_begin_time
%%    end,
%%    IdelTime * 1000.
get_idel_time() ->
    Now = util:unixtime(),
    Today = util:unixtime({today, Now}),
    Day = calendar:day_of_the_week(date()),
    TodayPass = Now - Today,
    TimeLeft = case {Day, ?top_fight_begin_time1 - TodayPass >= 0} of
        {D1, true} when D1 =< 7 ->
            ?top_fight_begin_time1 - TodayPass + (7 - D1) * ?top_fight_date_seconds;
        {D1, false} when D1 =< 6 ->
            ?top_fight_begin_time1 - TodayPass + (7 - D1) * ?top_fight_date_seconds;
        {D1, false} when D1 =:= 7 ->
            ?top_fight_begin_time1 - TodayPass + 7 * ?top_fight_date_seconds;
        _ ->
            ?top_fight_begin_time1 - TodayPass + 7 * ?top_fight_date_seconds
    end,
    ?DEBUG("idel time: ~w, ~w", [TimeLeft div 86400, TimeLeft rem 86400]),
    case TimeLeft =< 0 of
        true ->
            1;
        false ->
            TimeLeft * 1000
    end.

%% 更新外观
update_looks(Looks, #top_fight_role{group_id = GroupId, mask = Mask, death = Death, kill = Kill}) ->
    MaskLooks = case Mask of
        1 -> %% 蒙面
            case lists:keyfind(?LOOKS_TYPE_MODEl, 1, Looks) of
                false ->
                    [{?LOOKS_TYPE_MODEl, 0, ?LOOKS_VAL_MODEL_ARENA} | Looks];
                _Other ->
                    lists:keyreplace(?LOOKS_TYPE_MODEl, 1, Looks, {?LOOKS_TYPE_MODEl, 0, ?LOOKS_VAL_MODEL_ARENA})
            end;
        0 -> %% 不蒙面
            Looks
    end,
    NewLooks = case GroupId of
        1 -> %% 青龙
            case lists:keyfind(?LOOKS_TYPE_ACT, 1, Looks) of
                false ->
                    [{?LOOKS_TYPE_ACT, 0, ?LOOKS_VAL_ACT_ARENA_DRAGON} | MaskLooks];
                _ ->
                    lists:keyreplace(?LOOKS_TYPE_ACT, 1, MaskLooks, {?LOOKS_TYPE_ACT, 0, ?LOOKS_VAL_ACT_ARENA_DRAGON})
            end;
        _ -> %% 白虎
            case lists:keyfind(?LOOKS_TYPE_ACT, 1, Looks) of
                false ->
                    [{?LOOKS_TYPE_ACT, 0, ?LOOKS_VAL_ACT_ARENA_TIGER} | MaskLooks];
                _ ->
                    lists:keyreplace(?LOOKS_TYPE_ACT, 1, MaskLooks, {?LOOKS_TYPE_ACT, 0, ?LOOKS_VAL_ACT_ARENA_TIGER})
            end
    end,
    NewLooks2 = case Kill >= 10 of
        true -> 
            case lists:keyfind(?LOOKS_TYPE_ARENA_SUPERMAN, 1, NewLooks) of
                false ->
                    [{?LOOKS_TYPE_ARENA_SUPERMAN, 0, ?LOOKS_VAL_ARENA_SUPERMAN} | NewLooks];
                _ ->
                    lists:keyreplace(?LOOKS_TYPE_ARENA_SUPERMAN, 1, NewLooks, {?LOOKS_TYPE_ARENA_SUPERMAN, 0, ?LOOKS_VAL_ARENA_SUPERMAN})
            end;
        _ -> NewLooks
    end,
    case Death >= 3 of 
        true ->
            case lists:keyfind(?LOOKS_TYPE_ALPHA, 1, NewLooks2) of
                false -> [{?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA} | NewLooks2];
                _ -> lists:keyreplace(?LOOKS_TYPE_ALPHA, 1, NewLooks2, {?LOOKS_TYPE_ALPHA, 0, ?LOOKS_VAL_ALPHA_ARENA})
            end;
        _ -> NewLooks2 
    end.

%% 初始化上次战场信息
%init_last_win([], State) -> State;
%init_last_win([[Time, ArenaLev] | T], State) ->
%    NewState = case top_fight_dao_log:get_winner(Time, ArenaLev) of
%        {ok, Data} -> 
%            case role_max_kill_num(Data) of
%                false -> State;
%                [RoleId, SrvId, Name, KillNum] ->
%                    write_last_win(ArenaLev, RoleId, SrvId, Name, KillNum, State)
%            end;
%        _ -> 
%            State
%    end,
%    init_last_win(T, NewState).
%
%role_max_kill_num([]) -> false;
%role_max_kill_num([[RoleId, SrvId, Name, KillNum] | T]) ->
%    case role_max_kill_num(T) of
%        false -> [RoleId, SrvId, Name, KillNum];
%        [MaxRoleId, MaxSrvId, MaxName, MaxKillNum] when MaxKillNum > KillNum ->
%            [MaxRoleId, MaxSrvId, MaxName, MaxKillNum];
%        _ ->
%            [RoleId, SrvId, Name, KillNum]
%    end.

write_last_win(?top_fight_lev_low, RoleId, SrvId, Name, KillNum, State = #state{low = ArenaZone = #top_fight_zone{last_win = #top_fight_lw{kill = Kill}}}) ->
    case KillNum > Kill of
        true -> State#state{low = ArenaZone#top_fight_zone{last_win = #top_fight_lw{role_id = RoleId, srv_id = SrvId, name = Name, kill = KillNum}}};
        false -> State
    end;
write_last_win(?top_fight_lev_middle, RoleId, SrvId, Name, KillNum, State = #state{middle = ArenaZone = #top_fight_zone{last_win = #top_fight_lw{kill = Kill}}}) ->
    case KillNum > Kill of
        true -> State#state{middle = ArenaZone#top_fight_zone{last_win = #top_fight_lw{role_id = RoleId, srv_id = SrvId, name = Name, kill = KillNum}}};
        false -> State
    end;
write_last_win(?top_fight_lev_hight, RoleId, SrvId, Name, KillNum, State = #state{hight = ArenaZone = #top_fight_zone{last_win = #top_fight_lw{kill = Kill}}}) ->
    case KillNum > Kill of
        true -> State#state{hight = ArenaZone#top_fight_zone{last_win = #top_fight_lw{role_id = RoleId, srv_id = SrvId, name = Name, kill = KillNum}}};
        false -> State
    end;
write_last_win(?top_fight_lev_super, RoleId, SrvId, Name, KillNum, State = #state{super = ArenaZone = #top_fight_zone{last_win = #top_fight_lw{kill = Kill}}}) ->
    case KillNum > Kill of
        true -> State#state{super = ArenaZone#top_fight_zone{last_win = #top_fight_lw{role_id = RoleId, srv_id = SrvId, name = Name, kill = KillNum}}};
        false -> State
    end;
write_last_win(?top_fight_lev_angle, RoleId, SrvId, Name, KillNum, State = #state{angle = ArenaZone = #top_fight_zone{last_win = #top_fight_lw{kill = Kill}}}) ->
    case KillNum > Kill of
        true -> State#state{angle = ArenaZone#top_fight_zone{last_win = #top_fight_lw{role_id = RoleId, srv_id = SrvId, name = Name, kill = KillNum}}};
        false -> State
    end;
write_last_win(_ArenaLev, _RoleId, _SrvId, _Name, _KillNum, State) ->
    ?DEBUG("[巅峰对决]更新优胜者信息失败:没有找到对应的级别标签:~s, State:~w", [_ArenaLev, State]),
    State.

%% 获取竞技面板信息
parse_panel_info(StateName, _State = #state{low = #top_fight_zone{last_win = #top_fight_lw{name = LowName}}
        ,middle = #top_fight_zone{last_win = _MiddleLw = #top_fight_lw{name = MiddleName}}
        ,hight = #top_fight_zone{last_win = #top_fight_lw{name = HightName}}
        ,super = #top_fight_zone{last_win = #top_fight_lw{name = SuperName}}
        ,angle = #top_fight_zone{last_win = #top_fight_lw{name = AngleName}}}) ->
    Status = case StateName of
        idel -> 
            Now = util:unixtime(),
            Today = util:unixtime({today, Now}),
            case (Today + ?top_fight_begin_time2) < Now of
                true -> 4;
                false -> 0
            end;
        notice -> 1;
        prepare -> 2;
        match_pre -> 3;
        matching -> 3;
        expire -> 4
    end,
    {Status, LowName, MiddleName, HightName, SuperName, AngleName, <<>>}.

%% 根据角色等级转换到对应的战区级别
to_arena_lev(_Lev) ->
    ?top_fight_lev_low.

%% 获取所有#top_fight_online{}
get_all_arena_online(_State = #state{low = Low, middle = Middle, hight = Hight, super = Super, angle = Angle}) ->
    Low#top_fight_zone.arena_list ++
    Middle#top_fight_zone.arena_list ++
    Hight#top_fight_zone.arena_list ++
    Super#top_fight_zone.arena_list ++
    Angle#top_fight_zone.arena_list.

%% 获取所有#top_fight_pre{}
get_all_arena_pre(_State = #state{low = Low, middle = Middle, hight = Hight, super = Super, angle = Angle}) ->
    Low#top_fight_zone.pre_list ++
    Middle#top_fight_zone.pre_list ++
    Hight#top_fight_zone.pre_list ++
    Super#top_fight_zone.pre_list ++
    Angle#top_fight_zone.pre_list.

%% 检查重置级别的角色列表
%% 当高等级场的参加人数低于4个人（不包括4）时候，进入正式区时候将其分配到低一级的巅峰对决中去
reset_role_list(State, []) -> State;
reset_role_list(State = #state{low = Low = #top_fight_zone{arena_lev = ArenaLev, role_list = RoleList1}, middle = Middle = #top_fight_zone{role_list = RoleList2}}, [?top_fight_lev_middle| T]) ->
    case length(RoleList2) < ?top_fight_player_least_lev of
        true ->
            NewRoleList = reset_role_list_update(RoleList2, ArenaLev),
            reset_role_list(State#state{low = Low#top_fight_zone{role_list = (RoleList1 ++ NewRoleList)}, middle = Middle#top_fight_zone{role_list = []}}, T);
        false ->
            reset_role_list(State, T)
    end;
reset_role_list(State = #state{middle = Middle = #top_fight_zone{arena_lev = ArenaLev, role_list = RoleList1}, hight = Hight = #top_fight_zone{role_list = RoleList2}}, [?top_fight_lev_hight| T]) ->
    case length(RoleList2) < ?top_fight_player_least_lev of
        true ->
            NewRoleList = reset_role_list_update(RoleList2, ArenaLev),
            reset_role_list(State#state{middle = Middle#top_fight_zone{role_list = (RoleList1 ++ NewRoleList)}, hight = Hight#top_fight_zone{role_list = []}}, T);
        false ->
            reset_role_list(State, T)
    end;
reset_role_list(State = #state{hight = Hight= #top_fight_zone{arena_lev = ArenaLev, role_list = RoleList1}, super = Super = #top_fight_zone{role_list = RoleList2}}, [?top_fight_lev_super| T]) ->
    case length(RoleList2) < ?top_fight_player_least_lev of
        true ->
            NewRoleList = reset_role_list_update(RoleList2, ArenaLev),
            reset_role_list(State#state{hight = Hight#top_fight_zone{role_list = (RoleList1 ++ NewRoleList)}, super = Super#top_fight_zone{role_list = []}}, T);
        false ->
            reset_role_list(State, T)
    end;
reset_role_list(State = #state{super = Super = #top_fight_zone{arena_lev = ArenaLev, role_list = RoleList1}, angle = Angle = #top_fight_zone{role_list = RoleList2}}, [?top_fight_lev_angle| T]) ->
    case length(RoleList2) < ?top_fight_player_least_lev of
        true ->
            NewRoleList = reset_role_list_update(RoleList2, ArenaLev),
            reset_role_list(State#state{super = Super#top_fight_zone{role_list = (RoleList1 ++ NewRoleList)}, angle = Angle#top_fight_zone{role_list = []}}, T);
        false ->
            reset_role_list(State, T)
    end;
reset_role_list(State, [_ArenaLev | T]) ->
    ?ELOG("[巅峰对决]重置角色列表巅峰对决级别有误[ArenaLev:~w]:没有匹配方法", [_ArenaLev]),
    reset_role_list(State, T).

reset_role_list_update([], _ArenaLev) -> [];
reset_role_list_update([ArenaRole | T], ArenaLev) ->
    [ArenaRole#top_fight_role{arena_lev = ArenaLev} | reset_role_list_update(T, ArenaLev)].

%% @spec init_hero_rank(State::#state{}, Time::integer()) -> NewState::#state{}
%% @doc 初始化英雄榜
init_hero_rank(State, Time) ->
    ?DEBUG("init_hero_rank: ~w", [Time]),
    case top_fight_dao_log:get_hero_data(Time) of
        {ok, Data} ->
            parse_hero_rank(Data, State);
        _ -> 
            State
    end.

%% 初始化霸主
init_top_hero(State) ->
    case top_fight_dao_log:get_top_hero() of
        {ok, T} ->
            State#state{top_hero = T};
        _ ->
            State
    end.

%% 遍历日志信息
parse_hero_rank([], State) -> State;
parse_hero_rank([[RoleId, SrvId, Name, Score, KillNum, ArenaLev, ArenaSeq, Career, Lev, GroupId, Death, Winner, Fc, PetFc] | T], State = #state{hero_rank = HeroRank}) ->
    ArenaHero = #top_fight_hero{role_id = RoleId, srv_id = SrvId, name = Name, career = Career, lev = Lev, group_id = GroupId, kill = KillNum, death = Death, score = Score, arena_lev = ArenaLev, arena_seq = ArenaSeq, winner = Winner, fight_capacity = Fc, pet_fight_capacity = PetFc},
    NewHeroRank = add_hero_rank(ArenaHero, HeroRank),
    parse_hero_rank(T, State#state{hero_rank = NewHeroRank}).

add_hero_rank(ArenaHero = #top_fight_hero{arena_lev = ArenaLev, arena_seq = ArenaSeq, group_id = GroupId, winner = Winner}, HeroRank) ->
    ZoneList = get_hero_zone_list(ArenaLev, HeroRank),
    NewZoneList = case lists:keyfind(ArenaSeq, #top_fight_hero_zone.arena_seq, ZoneList) of
        HeroZone = #top_fight_hero_zone{hero_list = HeroList} ->
            NewHeroZone = case Winner of
                ?true -> HeroZone#top_fight_hero_zone{winner = GroupId, hero_list = [ArenaHero | HeroList]};
                ?false -> HeroZone#top_fight_hero_zone{hero_list = [ArenaHero | HeroList]}
            end,
            lists:keyreplace(ArenaSeq, #top_fight_hero_zone.arena_seq, ZoneList, NewHeroZone);
        false ->
            HeroZone = case Winner of
                ?true -> #top_fight_hero_zone{arena_seq = ArenaSeq, winner = GroupId, hero_list = [ArenaHero]};
                ?false -> #top_fight_hero_zone{arena_seq = ArenaSeq, hero_list = [ArenaHero]}
            end,
            [HeroZone | ZoneList]
    end,
    update_hero_rank(ArenaLev, NewZoneList, HeroRank).

get_hero_zone_list(?top_fight_lev_low, #top_fight_hero_rank{low = ZoneList}) -> ZoneList;
get_hero_zone_list(?top_fight_lev_middle, #top_fight_hero_rank{middle = ZoneList}) -> ZoneList;
get_hero_zone_list(?top_fight_lev_hight, #top_fight_hero_rank{hight = ZoneList}) -> ZoneList;
get_hero_zone_list(?top_fight_lev_super, #top_fight_hero_rank{super = ZoneList}) -> ZoneList;
get_hero_zone_list(?top_fight_lev_angle, #top_fight_hero_rank{angle = ZoneList}) -> ZoneList.

update_hero_rank(?top_fight_lev_low, ZoneList, HeroRank) -> HeroRank#top_fight_hero_rank{low = ZoneList};
update_hero_rank(?top_fight_lev_middle, ZoneList, HeroRank) -> HeroRank#top_fight_hero_rank{middle = ZoneList};
update_hero_rank(?top_fight_lev_hight, ZoneList, HeroRank) -> HeroRank#top_fight_hero_rank{hight = ZoneList};
update_hero_rank(?top_fight_lev_super, ZoneList, HeroRank) -> HeroRank#top_fight_hero_rank{super = ZoneList};
update_hero_rank(?top_fight_lev_angle, ZoneList, HeroRank) -> HeroRank#top_fight_hero_rank{angle = ZoneList}.

do_get_hero_rank(#top_fight_hero_rank{low = ZoneList}, ?top_fight_lev_low, ArenaSeq) ->
    keyfind_hero_rank(ArenaSeq, ZoneList);
do_get_hero_rank(#top_fight_hero_rank{middle = ZoneList}, ?top_fight_lev_middle, ArenaSeq) ->
    keyfind_hero_rank(ArenaSeq, ZoneList);
do_get_hero_rank(#top_fight_hero_rank{hight = ZoneList}, ?top_fight_lev_hight, ArenaSeq) ->
    keyfind_hero_rank(ArenaSeq, ZoneList);
do_get_hero_rank(#top_fight_hero_rank{super = ZoneList}, ?top_fight_lev_super, ArenaSeq) ->
    keyfind_hero_rank(ArenaSeq, ZoneList);
do_get_hero_rank(#top_fight_hero_rank{angle = ZoneList}, ?top_fight_lev_angle, ArenaSeq) ->
    keyfind_hero_rank(ArenaSeq, ZoneList).

keyfind_hero_rank(ArenaSeq, ZoneList) ->
    case lists:keyfind(ArenaSeq, #top_fight_hero_zone.arena_seq, ZoneList) of
        false -> 
            ?DEBUG("没找到巅峰对决战区信息"),
            {false, ?L(<<"没找到竞技场战区信息">>)};
        HeroZone -> {ok, length(ZoneList), HeroZone}
    end.
%%----------------------------------------------------
%% 辅助函数
%%----------------------------------------------------
continue(StateName, State = #state{ts = Ts, timeout = Timeout}) ->
    {next_state, StateName, State, util:time_left(Timeout, Ts)}.

continue(StateName, Reply, State = #state{ts = Ts, timeout = Timeout}) ->
    {reply, Reply, StateName, State, util:time_left(Timeout, Ts)}.

%% 获取霸主
get_top_hero([]) ->
    false;
get_top_hero([#top_fight_hero_zone{arena_seq = Seq, hero_list = HeroList} | T]) ->
    case Seq of
        1 ->
            get_winner(HeroList);
        _ ->
            get_top_hero(T)
    end.

get_winner([]) ->
    false;
get_winner([H = #top_fight_hero{winner = 1} | _]) ->
    {ok, H};
get_winner([_ | T]) ->
    get_winner(T).

%% 获取各战区的第一名
get_seq_winner(Zones) ->
    get_seq_winner(Zones, []).

get_seq_winner([], Back) ->
    {ok, Back};
get_seq_winner([#top_fight_hero_zone{hero_list = Hlist} | T], Back) ->
    case get_winner(Hlist) of
        {ok, W} ->
            get_seq_winner(T, [W | Back]);
        _ ->
            get_seq_winner(T, Back)
    end.

