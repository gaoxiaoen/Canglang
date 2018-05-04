%% --------------------------------------------------------------------
%% 洛水塔防管理器 
%% @author shawn 
%% --------------------------------------------------------------------
-module(guard_mgr).

-behaviour(gen_server).

%% 头文件
-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("guard.hrl").
-include("npc.hrl").
-include("mail.hrl").
-include("looks.hrl").
%%
-include("combat.hrl").
-include("assets.hrl").
-include("guild.hrl").

-define(LAST_PAGE_NUM, 9).
-define(ALL_PAGE_NUM, 9).

%% api funs
-export([
        start_link/0 
        ,guard_start/1
        ,guard_stop/1
        ,guard_counter_start/1
        ,guard_counter_stop/3
        ,kill_npc/4
        ,get_list/3
        ,sync_rank/1
        ,sync_c_rank/2
        ,get_rank/2
        ,get_boss/0
        ,get_c_boss/0
        ,get_mode/0
        ,get_status/0
        ,get_c_status/0
        ,login/1
        ,logout/1
        ,combat_over/1
        ,enter_zone/1
        ,next_timeout/0
        ,guard_boss_status/0
        ,exit_combat_area/2
        ,revive/3
        ,get_combat_rank/0
    ]).

%% adm funs
-export([
        gm_start/0
        ,save/2
        ,gm_stop/0
        ,stop_counter/0
        ,next_mode/1
        ,qsort_point/1
        ,qsort_all_point/1
        ,qsort_all_c_point/1
        ,to_boss/1
        ,save_to_db/0
        ,clean_db/0
        ,trans/2
        ,do_send_mail/2
        ,do_send_c_mail/2
    ]
).

%% gen_server callback
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% record
-record(state, {
        guard_pid = 0
        ,guard_counter_pid = 0
        ,last_rank = [] %% 上一次排行榜[]
        ,all_rank = [] %% 总榜[]
        ,boss = {} %% {Rid, SrvId, Name, Career, Lev, Sex, GuildName, Looks, Eqm}     
        ,last_mode = 0
        ,next_mode = 0
        ,last_c_rank = [] %% 上一次反击排行榜
        ,all_c_rank = []  %% 反击总榜
        ,c_boss = {} %% {Rid, SrvId, Name, Career, Lev, Sex, GuildName, Looks, Eqm}     
    }
).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 守卫洛水开启
guard_start(GuardPid) ->
    ?DEBUG("创建守卫洛水回调"),
    ?MODULE ! {guard_start, GuardPid}.

%% 守卫洛水时的回调
guard_stop(GuardState) ->
    ?DEBUG("关闭守卫洛水回调"),
    ?MODULE ! {guard_stop, GuardState}.

%% 反击开启
guard_counter_start(GuardPid) ->
    ?DEBUG("创建反击洛水回调"),
    ?MODULE ! {guard_counter_start, GuardPid}.

%% 反击关闭
guard_counter_stop(GuardState, IsDie, Boss) ->
    ?DEBUG("关闭反击洛水回调"),
    ?MODULE ! {guard_counter_stop, GuardState, IsDie, Boss}.

%% 同步消息
sync_rank(GuardState) ->
    ?MODULE ! {sync, GuardState}.

%% 同步消息
sync_c_rank(RoleList, MapId) ->
    ?MODULE ! {sync_c, RoleList, MapId}.

%% 下一次开启模式
next_mode(guard) ->
    ?MODULE ! {next_mode, ?guard_mode_dfd};
next_mode(c_guard) ->
    ?MODULE ! {next_mode, ?guard_mode_atk}.

next_timeout() ->
    ?MODULE ! next_timeout.

%% 退出 
exit_combat_area(Pid, RoleId) ->
    gen_server:cast(?MODULE, {exit_combat_area, Pid, RoleId}).

%% 复活
revive(Type, Rid, Pid) ->
    gen_server:cast(?MODULE, {revive, Type, Rid, Pid}).

%% NPC死亡消息
kill_npc(Type, RoleList, LossHp, Point) ->
    gen_server:cast(?MODULE, {kill_npc, Type, RoleList, LossHp, Point}).

%% 角色战斗结束处理
combat_over(#combat{loser = Loser}) ->
    Deads = [{Rid, SrvId, Pid} || #fighter{rid = Rid, srv_id = SrvId, pid = Pid, type = Type, is_die = IsDie} <- Loser, Type=:=?fighter_type_role andalso IsDie=:=?true],
    case Deads of
        [_|_] -> gen_server:cast(?MODULE, {combat_over, Deads});
        _ -> ignore
    end,
    ok.

gm_start() ->
    ?MODULE ! start.

gm_stop() ->
    ?MODULE ! stop.

stop_counter() ->
    ?MODULE ! stop_counter.

get_mode() ->
    gen_server:call(?MODULE, get_mode).

get_combat_rank() ->
    gen_server:call(?MODULE, get_combat_rank).

guard_boss_status() ->
    gen_server:call(?MODULE, guard_boss_status).

get_rank(last_rank, Page) ->
    gen_server:call(?MODULE, {last_rank, Page});

get_rank(all_rank, Page) ->
    gen_server:call(?MODULE, {all_rank, Page});

get_rank(last_c_rank, Page) ->
    gen_server:call(?MODULE, {last_c_rank, Page});

get_rank(all_c_rank, Page) ->
    gen_server:call(?MODULE, {all_c_rank, Page});

get_rank(owner, {Id, Type}) ->
    gen_server:call(?MODULE, {owner, {Id, Type}}).

get_boss() ->
    gen_server:call(?MODULE, boss).

get_c_boss() ->
    gen_server:call(?MODULE, c_boss).

get_status() ->
    gen_server:call(?MODULE, status).

get_c_status() ->
    gen_server:call(?MODULE, c_status).

save_to_db() ->
    ?MODULE ! save_to_db.

login(Role = #role{event = ?event_guard_counter, id = RoleId, pid = Pid, pos = Pos, status = Status}) ->
    case catch gen_server:call(?MODULE, {login, RoleId, Pid}) of
        {ok, ZonePid} ->
            Role#role{event_pid = ZonePid};
        _Any ->
            case Status of
                ?status_die ->
                    {MapId, X, Y} = {10003, 1440 + util:rand(-5, 5), 5640 + util:rand(-5, 5)},
                    Role#role{hp = 1, status = ?status_normal, pos = Pos#pos{map = MapId, x = X, y = Y}, event = ?event_no};
                _ ->
                    {MapId, X, Y} = {10003, 1440 + util:rand(-5, 5), 5640 + util:rand(-5, 5)},
                    Role#role{pos = Pos#pos{map = MapId, x = X, y = Y}, event = ?event_no}
            end
    end;

login(Role) -> Role.

logout(#role{event = ?event_guard_counter, id = RoleId}) ->
    gen_server:cast(?MODULE, {logout, RoleId});
logout(_) -> skip.


clean_db() ->
    ?MODULE ! clean_db.

trans(_Type, #role{lev = Lev}) when Lev < 40 ->
    {false, ?L(<<"40级后才能参加活动哦，亲">>)};
trans(Type, Role) ->
    case get_status() of
        {?GUARD_STATE_OVER, _, _, _} -> {false, ?L(<<"活动已经结束">>)};
        _ -> 
            ToTrans = to_trans(Type),
            role_api:trans_hook(free, ToTrans, Role)
    end.

to_trans(1) -> %% 传至主城
    ?guard_trans_map;
to_trans(2) -> %% 传至许愿池
    ?guard_trans_npc;
to_trans(_) -> ignore.

%% 发送奖励
send_mail([]) -> skip;
send_mail(#guard{join_role = JoinRole, td_lev = TdLev}) ->
    spawn(guard_mgr, do_send_mail, [JoinRole, TdLev]).

send_c_mail(RoleList, IsDie) ->
    spawn(guard_mgr, do_send_c_mail, [RoleList, IsDie]).

send_special_mail([], _) -> ok;
send_special_mail([#role_guard{id = Id} | T], Num) ->
    ItemList = to_items(Num, 29179, []),  
    case mail:send_system(Id,
            {?L(<<"守卫洛水奖励">>), 
                util:fbin(?L(<<"本次守卫洛水结束,恭喜你在本次守卫洛水中排名第~w,获得洛水英杰礼盒奖励">>), [Num]),
                [], ItemList}) of
        ok -> ok;
        {false, _R} ->
            ?ERR("守卫洛水奖励发送邮件失败:id:~p 原因:~p",[Id, _R]),
            false 
    end,
    send_special_mail(T, Num + 1).

to_items(1, BaseId, ItemList) -> 
    case item:make(BaseId, 1, 5) of
        false -> ItemList;
        {ok, Items} -> Items
    end;
to_items(Pos, BaseId, ItemList) when Pos =:= 2 orelse Pos =:= 3 -> 
    case item:make(BaseId, 1, 3) of
        false -> ItemList; 
        {ok, Items} -> Items
    end;
to_items(Pos, BaseId, ItemList) when Pos =:= 4 orelse Pos =:= 5 -> 
    case item:make(BaseId, 1, 2) of
        false -> ItemList; 
        {ok, Items} -> Items
    end;
to_items(Pos, BaseId, ItemList) when Pos >= 6 andalso Pos =< 10 -> 
    case item:make(BaseId, 1, 1) of
        false -> ItemList; 
        {ok, Items} -> Items
    end.

send_special_c_mail([], _) -> ok;
send_special_c_mail([#guard_counter_role{id = {Rid, SrvId}, name = Name} | T], Num) ->
    Subject = ?L(<<"洛水反击战奖励">>),
    ItemList = if
        Num =:= 1 -> [{29278, 1, 5}];
        Num >= 2 andalso Num =< 3 -> [{29278, 1, 3}];
        Num >= 4 andalso Num =< 5 -> [{29278, 1, 2}];
        Num >= 6 andalso Num =< 10 -> [{29278, 1, 1}];
        true -> []
    end,
    Content = util:fbin(?L(<<"本次洛水反击结束,恭喜你在本次洛水反击中排名第~w,获得洛水反击英杰礼盒奖励">>), [Num]),
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], ItemList}),
    send_special_c_mail(T, Num + 1).

do_send_mail([], _) -> ok;
do_send_mail([#role_guard{point = 0} | T], TdLev) -> do_send_mail(T, TdLev);
do_send_mail([R = #role_guard{id = Id, point = Point} | T], TdLev) ->
    {Msg, Award} = to_msg(R, TdLev),
    ItemList = to_normal_items(Point), 
    case mail:send_system(Id,
            {?L(<<"守卫洛水奖励">>), Msg, Award, ItemList}) of
        ok -> ok;
        {false, _R} ->
            ?ERR("守卫洛水奖励发送邮件失败:id:~p 原因:~p",[Id, _R]),
            false 
    end,
    do_send_mail(T, TdLev).

do_send_c_mail([], _) -> ok;
do_send_c_mail([#guard_counter_role{point = 0} | T], IsDie) -> do_send_c_mail(T, IsDie);
do_send_c_mail([#guard_counter_role{id = {Rid, SrvId}, name = Name, point = Point, lev = Lev} | T], IsDie) ->
    Subject = ?L(<<"洛水反击战奖励">>),
    ItemList = case Point >= 30 of
        true -> [{29279, 1, 1}]; 
        false -> []
    end,
    Exp = round(math:pow(Point*5000, 0.5) * 0.3 * math:pow(Lev, 1.5)),
    Att = round(Point * 3),
    Sm = round(Point / 8),
    Content = case IsDie of
        ?true ->
            util:fbin(?L(<<"恭喜仙友成功击杀妖魔首领保卫了洛水百姓的安全，为表达谢意，您获得了积分:~w, 经验:~w, 阅历:~w, 师门贡献:~w">>), [Point, Exp, Att, Sm]);
        ?false ->
            util:fbin(?L(<<"很遗憾，没有成功击退妖魔首领，为了鼓励众仙友再接再厉，您获得了积分:~w, 经验:~w, 阅历:~w, 师门贡献:~w">>), [Point, Exp, Att, Sm])
    end,
    Assest = [{?mail_exp, Exp}, {?mail_attainment, Att}, {?mail_career_devote, Sm}],
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, Assest, ItemList}),
    do_send_c_mail(T, IsDie).

to_normal_items(Point) when Point >= 30 ->
    make_list([{29184, 1}], []);
to_normal_items(_) -> [].

make_list([], Items) -> Items;
make_list([{BaseId, Num} | T], Items) ->
    case item:make(BaseId, 1, Num) of
        false -> make_list(T, Items);
        {ok, MakeItems} ->
            make_list(T, MakeItems ++ Items)
    end.

to_msg(#role_guard{lev = Lev, point = Point}, TdLev) ->
    Exp = erlang:round(Point * math:pow(Lev, 1.5)),
    Att = erlang:round(Point * 1.5),
    Sm = erlang:round(Point / 4),
    Msg = util:fbin(?L(<<"本次守卫已经结束，通过大家同心协力，共抵挡~w波妖魔的侵袭，您在本次守卫中表现优异，获得~w积分。 折算成\n 经验:~w， 阅历:~w，师门积分:~w\n积分超过30分将会有额外奖励1个守卫洛水参与礼包。">>), [TdLev, Point, Exp, Att, Sm]),
    {Msg, [{?mail_exp, Exp}, {?mail_attainment, Att}, {?mail_career_devote, Sm}]}.

enter_zone(#role{id = {Rid, SrvId}, pid = Pid, name = Name, career = Career, lev = Lev, sex = Sex, looks = Looks, assets = #assets{guard_acc = AllPoint}, guild = Guild, eqm = Eqm}) ->
    GuildName = case Guild of
        #role_guild{name = Gname} -> Gname;
        _ -> <<>> 
    end,
    gen_server:cast(?MODULE, {enter_zone, {Rid, SrvId}, Pid, Name, GuildName, Career, Lev, Sex, Looks, Eqm, AllPoint}).

save(LastMode, NextMode) ->
    case sys_env:save(guard_mgr_state, {LastMode, NextMode}) of
        ok -> ?DEBUG("保存洛水状态成功");
        _Err -> ?ERR("保存洛水状态失败:~w",[_Err])
    end.
load() ->
    case catch sys_env:get(guard_mgr_state) of
        {LastMode, NextMode} when is_integer(LastMode) andalso is_integer(NextMode) ->
            {LastMode, NextMode};
        undefined ->
            ?DEBUG("初始洛水状态"),
            {0, 0};
        _ ->
            ?ERR("加载洛水状态失败"),
            {0, 0}
    end.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    self() ! init,
    erlang:send_after((util:unixtime(today) + 86420 - util:unixtime()) * 1000, self(), day_check),
    {LastMode, NextMode} = load(),
    ?INFO("[~w] 启动完成", [?MODULE]),
    save(LastMode, NextMode),
    {ok, #state{last_mode = LastMode, next_mode = NextMode}}.

handle_call({login, RoleId, Pid}, _From, State = #state{guard_counter_pid = GuardCounterPid}) ->
    case is_pid(GuardCounterPid) of
        false ->
            {reply, false, State};
        true ->
            case catch guard_counter:login(GuardCounterPid, RoleId, Pid) of
                {ok, ZonePid} ->
                    {reply, {ok, ZonePid}, State};
                _ ->
                    {reply, false, State}
            end
    end;

handle_call(get_mode, _From, State = #state{last_mode = LastMode, next_mode = NextMode}) ->
    {reply, {LastMode, NextMode}, State};

handle_call(get_combat_rank, _From, State = #state{last_c_rank = LastRank}) ->
    {reply, LastRank, State};

handle_call({last_rank, Page}, _From, State = #state{last_rank = LastRank}) ->
    Reply = get_page(last_rank, LastRank, Page),
    {reply, Reply, State};

handle_call({all_rank, Page}, _From, State = #state{all_rank = AllRank}) ->
    Reply = get_page(all_rank, AllRank, Page),
    {reply, Reply, State};

handle_call({last_c_rank, Page}, _From, State = #state{last_c_rank = LastRank}) ->
    Reply = get_page(last_c_rank, LastRank, Page),
    {reply, Reply, State};

handle_call({all_c_rank, Page}, _From, State = #state{all_c_rank = AllRank}) ->
    Reply = get_page(all_c_rank, AllRank, Page),
    {reply, Reply, State};

handle_call({owner, {Id, last_rank}}, _From, State = #state{last_rank = LastRank}) ->
    Num = get_owner(LastRank, Id),
    Reply = case Num of
        0 -> {Num, [], 0, 0};
        _ ->
            P = util:ceil(Num / ?LAST_PAGE_NUM),
            {AllPage, Page, Get} = get_page(last_rank, LastRank, P),
            {Num, Get, Page, AllPage}
    end,
    {reply, Reply, State};

handle_call({owner, {Id, all_rank}}, _From, State = #state{all_rank = AllRank}) ->
    Num = get_owner(AllRank, Id),
    Reply = case Num of
        0 -> {Num, [], 0, 0};
        Num -> 
            P = util:ceil(Num / ?ALL_PAGE_NUM),
            {AllPage, Page, Get} = get_page(all_rank, AllRank, P),
            {Num, Get, Page, AllPage}
    end,
    {reply, Reply, State};

handle_call({owner, {Id, last_c_rank}}, _From, State = #state{last_c_rank = LastRank}) ->
    Num = get_c_owner(LastRank, Id),
    Reply = case Num of
        0 -> {Num, [], 0, 0};
        _ ->
            P = util:ceil(Num / ?LAST_PAGE_NUM),
            {AllPage, Page, Get} = get_page(last_c_rank, LastRank, P),
            {Num, Get, Page, AllPage}
    end,
    {reply, Reply, State};

handle_call({owner, {Id, all_c_rank}}, _From, State = #state{all_c_rank = AllRank}) ->
    Num = get_c_owner(AllRank, Id),
    Reply = case Num of
        0 -> {Num, [], 0, 0};
        Num -> 
            P = util:ceil(Num / ?ALL_PAGE_NUM),
            {AllPage, Page, Get} = get_page(all_c_rank, AllRank, P),
            {Num, Get, Page, AllPage}
    end,
    {reply, Reply, State};

handle_call(boss, _From, State = #state{boss = Boss}) ->
    {reply, Boss, State};

handle_call(c_boss, _From, State = #state{c_boss = Boss}) ->
    {reply, Boss, State};

handle_call(guard_boss_status, _From, State = #state{guard_counter_pid = Pid}) ->
    Reply = case is_pid(Pid) of
        true ->
            case catch guard_counter:get_current_status() of
                {ok, CurHp} ->
                    {ok, ?true, CurHp, ?guard_counter_boss_hp};
                _ ->
                    {?false, ?guard_counter_boss_hp, ?guard_counter_boss_hp}
            end;
        false ->
            {?false, ?guard_counter_boss_hp, ?guard_counter_boss_hp}
    end,
    {reply, Reply, State};

handle_call(status, _From, State = #state{guard_pid = GuardPid}) ->
    Reply = case is_pid(GuardPid) of
        false -> {?GUARD_STATE_OVER, 0, 0, 0};
        true ->
            case guard:get_status(GuardPid) of
                {?GUARD_STATE_OVER, _} -> {?GUARD_STATE_OVER, 0, 0, 0};
                {?GUARD_STATE_RUN, #guard{td_lev = TdLev, hp = Hp, end_time = EndTime}} ->
                    Now = util:unixtime(),
                    {?GUARD_STATE_RUN, TdLev, Hp, EndTime - Now};
                {?GUARD_STATE_READY, #guard{ts = Ts}} ->
                    Time = util:time_left(?GUARD_TIME_PRE_START, Ts) div 1000,
                    {?GUARD_STATE_READY, 0, 0, Time};
                _ -> {?GUARD_STATE_OVER, 0, 0, 0}
            end
    end,
    {reply, Reply, State};

handle_call(c_status, _From, State = #state{guard_counter_pid = GuardCounterPid}) ->
    Reply = case is_pid(GuardCounterPid) of
        false -> {0, 0};
        true ->
            case catch guard_counter:get_status(GuardCounterPid) of
                {ok, {Status, Time}} -> {Status, Time};
                _ -> {0, 0}
            end
    end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({logout, RoleId}, State = #state{guard_counter_pid = GuardCounterPid}) ->
    case is_pid(GuardCounterPid) of
        false ->
            {noreply, State};
        true -> 
            guard_counter:logout(GuardCounterPid, RoleId),
            {noreply, State}
    end;

handle_cast({enter_zone, {Rid, SrvId}, Pid, Name, GuildName, Career, Lev, Sex, Looks, Eqm, AllPoint}, State = #state{guard_counter_pid = GuardCounterPid}) ->
    case is_pid(GuardCounterPid) of
        false ->
            role:pack_send(Pid, 15407, {?false, ?L(<<"洛水反击关闭中,不能进入">>)}), 
            {noreply, State};
        true ->
            GuardCounterPid ! {enter_zone, {Rid, SrvId}, Pid, Name, GuildName, Career, Lev, Sex, Looks, Eqm, AllPoint},
            {noreply, State}
    end;

handle_cast({exit_combat_area, Pid, {Rid, SrvId}}, State = #state{guard_counter_pid = GuardCounterPid}) ->
    case is_pid(GuardCounterPid) of
        false -> skip;
        true ->
            ?DEBUG("退出战区:~w,~s",[Rid, SrvId]),
            GuardCounterPid ! {exit_zone, {Rid, SrvId}}
    end,
    role:apply(async, Pid, {guard_counter, do_exit_combat_area, []}),
    {noreply, State};

handle_cast({kill_npc, Type, [], LossHp, _}, State = #state{guard_pid = GuardPid}) ->
    case is_pid(GuardPid) of
        false -> {noreply, State};
        true ->
            GuardPid ! {loss_npc, Type, LossHp},
            {noreply, State}
    end;

handle_cast({kill_npc, Type, RoleList, _, Point}, State = #state{guard_pid = GuardPid}) ->
    case is_pid(GuardPid) of
        false -> {noreply, State};
        true ->
            GuardPid ! {result, Type, Point, RoleList},
            {noreply, State}
    end;

handle_cast({combat_over, DeadRoles}, State = #state{guard_counter_pid = GuardCounterPid}) ->
    case is_pid(GuardCounterPid) of
        false ->
            lists:foreach(fun({_, _, Pid}) ->
                        role:apply(async, Pid, {guard_counter, do_revive_and_exit_combat_area, []})
                end, DeadRoles),
            {noreply, State};
        true ->
            GuardCounterPid ! {combat_over, DeadRoles},
            {noreply, State}
    end;

handle_cast({revive, Type, Rid, Pid}, State = #state{guard_counter_pid = GuardCounterPid}) ->
    case is_pid(GuardCounterPid) of
        false ->
            {noreply, State};
        true ->
            GuardCounterPid ! {revive, Type, Rid, Pid},
            {noreply, State}
    end;

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 每次检测
handle_info(day_check, State) ->
    CurDayOfWeek = calendar:day_of_the_week(date()),
    OpenTime = sys_env:get(srv_open_time),
    Now = util:unixtime(),
    case lists:member(CurDayOfWeek, ?GUARD_START_DAY) of
        true ->
            case day_diff(OpenTime, Now) of
                Day when Day < 2 ->
                    ?DEBUG("开服不够3天:~w",[Day]),
                    skip;
                _D ->
                    erlang:send_after(?GUARD_START_TIME * 1000, self(), start)
            end;
        false -> skip
    end,
    erlang:send_after(86400 * 1000, self(), day_check),
    {noreply, State};

%% 开启加载数据
handle_info(init, State) ->
    CurDayOfWeek = calendar:day_of_the_week(date()),
    OpenTime = sys_env:get(srv_open_time),
    Now = util:unixtime(),
    StartTime = util:unixtime(today) + ?GUARD_START_TIME,
    case lists:member(CurDayOfWeek, ?GUARD_START_DAY) of
        true ->
            case Now >= StartTime of
                true ->
                    ?DEBUG("时间已过,无法开启"),
                    skip;
                false ->
                    case day_diff(OpenTime, Now) of
                        Day when Day < 2 ->
                            ?DEBUG("开服不够3天"),
                            skip;
                        _D -> 
                            ?DEBUG("D:~w, StartTime - Now:~w",[_D, StartTime - Now]),
                            erlang:send_after((StartTime - Now) * 1000, self(), start)
                    end
            end;
        false ->
            ?DEBUG("今天没有守卫洛水活动"),
            skip
    end,
    State1 = case guard_dao:get_rank_from_db() of
        {Boss, LastRank, AllRank} ->
            ?INFO("守卫洛水排行榜加载数据成功"),
            State#state{last_rank = LastRank, all_rank = AllRank, boss = Boss};
        _ ->
            ?ERR("从数据库加载洛水排行榜数据失败"),
            State
    end,
    case guard_dao:get_c_rank_from_db() of
        {Boss1, LastRank1, AllRank1} ->
            ?INFO("反击洛水排行榜加载数据成功"),
            {noreply, State1#state{last_c_rank = LastRank1, all_c_rank = AllRank1, c_boss = Boss1}};
        _ ->
            ?ERR("从数据库加载反击洛水排行榜数据失败"),
            {noreply, State1}
    end;

handle_info(start, State = #state{guard_counter_pid = Pid}) when is_pid(Pid) -> 
    ?DEBUG("守卫反击正在进行中,不能开启"),
    {noreply, State};
handle_info(start, State = #state{guard_pid = Pid}) when is_pid(Pid) -> 
    ?DEBUG("守卫洛水正在进行中,不能开启"),
    {noreply, State};

handle_info(start, State = #state{next_mode = Mode}) -> 
    case Mode of
        ?guard_mode_atk ->
            case guard_counter:start() of
                {ok, _} ->
                    ?INFO("开启守卫洛水成功"),
                    role_group:pack_cast(world, 15416, {Mode, Mode}),
                    save(Mode, Mode),
                    {noreply, State#state{last_mode = Mode}};
                _X ->
                    ?ERR("开启守卫洛水失败:原因:~w",[_X]),
                    {noreply, State}
            end;
        ?guard_mode_dfd ->
            case guard:start() of
                {ok, _} ->
                    ?INFO("开启洛水反击成功"),
                    role_group:pack_cast(world, 15416, {Mode, Mode}),
                    save(Mode, Mode),
                    {noreply, State#state{last_mode = Mode}};
                _X ->
                    ?ERR("开启守卫洛水失败:原因:~w",[_X]),
                    {noreply, State}
            end
    end;

handle_info(stop, State = #state{guard_pid = Pid}) when is_pid(Pid) ->
    Pid ! stop,
    {noreply, State};

handle_info(stop, State) ->
    ?ERR("守卫洛水未开启"),
    {noreply, State};

handle_info(stop_counter, State = #state{guard_counter_pid = CounterPid}) when is_pid(CounterPid) ->
    CounterPid ! stop,
    {noreply, State};

handle_info(stop_counter, State) ->
    ?ERR("洛水反击未开启"),
    {noreply, State};

%% 修改下一次开启的模式
handle_info({next_mode, Mode}, State) ->
    Fun = fun(?guard_mode_atk) -> <<"洛水反击">>;
        (?guard_mode_dfd) -> <<"守卫洛水">>
    end,
    ?INFO("下一次开启将开启[~s]",[Fun(Mode)]),
    {noreply, State#state{next_mode = Mode}};

%% 洛水反击进入下一阶段
handle_info(next_timeout, State = #state{guard_counter_pid = Pid}) ->
    case is_pid(Pid) of
        false ->
            skip;
        true ->
            guard_counter:m(Pid, timeout)
    end,
    {noreply, State};

%% 同步数据
handle_info({sync, #guard{join_role = JoinRole}}, State) ->
    SortRank = lists:sort(fun sort_point/2, JoinRole),  
    LastRank = get_list(SortRank, 1, 99), 
    {noreply, State#state{last_rank = LastRank}};

%% 同步数据
handle_info({sync_c, JoinRole, MapId}, State) ->
    SortRank = lists:sort(fun sort_c_point/2, JoinRole),  
    LastRank = get_list(SortRank, 1, 99), 
    spawn(fun() -> map:pack_send_to_all(MapId, 15411, {LastRank}) end),  
    {noreply, State#state{last_c_rank = LastRank}};

%% 守卫洛水开启
handle_info({guard_start, GuardPid}, State = #state{boss = {}}) ->
    {noreply, State#state{guard_pid = GuardPid, last_rank = [], boss = {}}};
handle_info({guard_start, GuardPid}, State = #state{boss = _Boss}) ->
    H60001 = [],
    honor_mgr:replace_honor_gainer(guard_rank_1, H60001),
    {noreply, State#state{guard_pid = GuardPid, last_rank = [], boss = {}}};

%% 守卫反击开启
handle_info({guard_counter_start, GuardPid}, State = #state{c_boss = {}}) ->
    {noreply, State#state{guard_counter_pid = GuardPid, last_c_rank = [], c_boss = {}}};
handle_info({guard_counter_start, GuardPid}, State = #state{c_boss = _Boss}) ->
    H60015 = [],
    honor_mgr:replace_honor_gainer(guard_rank_2, H60015),
    {noreply, State#state{guard_counter_pid = GuardPid, last_c_rank = [], c_boss = {}}};

%% 清除旧的排行榜数据
handle_info(clean_db, State) ->
    case guard_dao:clean_db_rank() of
        true -> ?INFO("清除洛水排行榜数据库成功");
        _ -> ?INFO("清除洛水排行榜数据失败")
    end,
    {noreply, State};

%% 保存到数据库
handle_info(save_to_db, State = #state{last_rank = LastRank, all_rank = AllRank}) ->
    guard_dao:save_rank_to_db(LastRank, AllRank),
    ?INFO("保存守卫洛水排行榜数据完成"),
    {noreply, State};

%% 守卫洛水关闭
handle_info({guard_stop, G = #guard{join_role = JoinRole, hp = Hp}}, State = #state{all_rank = OldAllRank, last_mode = LastMode}) ->
    SortRank = lists:sort(fun sort_point/2, JoinRole),  
    campaign_listener:handle(guard_rank, SortRank, 1),
    LastRank = get_list(SortRank, 1, 99), 
    AllRank = get_list(qsort_all_point(merge(JoinRole, OldAllRank)), 1, 99),
    Boss = to_boss(LastRank),
    ?DEBUG("进行整理后的积分榜LastRank"),
    to_table(LastRank),
    ?DEBUG("进行整理后的总榜AllRank"),
    to_table(AllRank),
    case LastRank of
        [] -> skip;
        [_R = #role_guard{rid = Rid, srv_id = SrvId, name = Name} | _] -> 
            ?DEBUG("洛水城主信息Name:~s, Point:~w",[_R#role_guard.name, _R#role_guard.point]),
            notice:send(53, util:fbin(?L(<<"{role, ~w, ~s, ~s, #3ad6f0}在守卫洛水城中英勇奋战，诛灭最多的妖魔，为此城主灵威仰让贤城主之位于{role, ~w, ~s, ~s, #3ad6f0}">>), [Rid, SrvId, Name, Rid, SrvId, Name])),
            H60001 = [{{Rid, SrvId}, 60001}],
            honor_mgr:replace_honor_gainer(guard_rank_1, H60001)
    end,
    case guard_dao:clean_db_rank() of
        true -> guard_dao:save_rank_to_db(LastRank, AllRank);
        false -> skip
    end,
    ?DEBUG("存储排行榜完成"),
    send_mail(G),
    send_special_mail(get_list(LastRank, 1, 10), 1),
    NextMode = case Hp =< 0 of
        true ->  ?guard_mode_dfd;
        false -> ?guard_mode_atk
    end,
    role_group:pack_cast(world, 15416, {LastMode, NextMode}),
    save(LastMode, NextMode),
    {noreply, State#state{guard_pid = 0, last_rank = LastRank, all_rank = AllRank, boss = Boss, next_mode = NextMode}};

%% 守卫反击关闭
handle_info({guard_counter_stop, RoleList, IsDie, Boss}, State = #state{all_c_rank = OldAllRank, last_mode = LastMode}) ->
    SortRank = lists:sort(fun sort_c_point/2, RoleList),  
    LastRank = get_list(SortRank, 1, 99), 
    AllRank = get_list(qsort_all_c_point(merge_c(RoleList, OldAllRank)), 1, 99),
    case guard_dao:clean_db_c_rank() of
        true ->
            guard_dao:save_c_boss_to_db(Boss),
            guard_dao:save_c_rank_to_db(LastRank, AllRank);
        false -> skip
    end,
    send_c_mail(RoleList, IsDie),
    send_special_c_mail(get_list(LastRank, 1, 10), 1),
    NextMode = case IsDie of
        ?true -> ?guard_mode_atk;
        ?false -> ?guard_mode_dfd
    end,
    CBoss = to_c_boss(Boss),
    case CBoss of
        {Rid, SrvId, _Name, _, _, _, _, _, _} ->
            ?INFO("参与人数共有:~w人, 巨龙BOSS状态:~w, 采集封印角色[~s]",[length(RoleList), IsDie, _Name]),
            H60015 = [{{Rid, SrvId}, 60015}],
            honor_mgr:replace_honor_gainer(guard_rank_2, H60015);
        _ ->
            ?INFO("参与人数共有:~w人, 巨龙BOSS状态:~w, 没有采集封印角色",[length(RoleList), IsDie]),
            skip
    end,
    role_group:pack_cast(world, 15416, {LastMode, NextMode}),
    save(LastMode, NextMode),
    {noreply, State#state{guard_counter_pid = 0, last_c_rank = LastRank, all_c_rank = AllRank, next_mode = NextMode, c_boss = CBoss}};

handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, #state{}) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ---------------------

to_boss([]) -> {};
to_boss([#role_guard{id = {Rid, SrvId}, name = Name, career = Career, lev = Lev, sex = Sex, guild_name = GuildName, looks = Looks , eqm = Eqm}| _]) ->
    {Rid, SrvId, Name, Career, Lev, Sex, GuildName, Looks, Eqm}.

to_c_boss(#guard_counter_role{id = {Rid, SrvId}, name = Name, career = Career, lev = Lev, sex = Sex, guild_name = GuildName, looks = Looks, eqm = Eqm}) ->
    {Rid, SrvId, Name, Career, Lev, Sex, GuildName, Looks, Eqm};
to_c_boss(_) -> {}.

get_owner(Rank, Id) ->
    get_owner(Rank, Id, 0).
get_owner([], _Id, Num) -> Num;
get_owner([#role_guard{id = Id} | _T], Id, Num) -> Num + 1;
get_owner([_ | T], Id, Num) -> get_owner(T, Id, Num + 1).


get_c_owner(Rank, Id) ->
    get_c_owner(Rank, Id, 0).
get_c_owner([], _Id, Num) -> Num;
get_c_owner([#guard_counter_role{id = Id} | _T], Id, Num) -> Num + 1;
get_c_owner([_ | T], Id, Num) -> get_c_owner(T, Id, Num + 1).

get_page(Type, Rank, Page) when Page < 1 -> get_page(Type, Rank, 1);
get_page(last_rank, Rank, Page) when Page >= 1 ->
    AllPage = util:ceil(length(Rank) / ?LAST_PAGE_NUM),
    case  AllPage < Page of
        true ->
            Get = get_list(Rank, (AllPage - 1) * ?LAST_PAGE_NUM + 1, Page * ?LAST_PAGE_NUM),
            {AllPage, AllPage, Get};
        false ->
            Get = get_list(Rank, (Page - 1) * ?LAST_PAGE_NUM + 1, Page * ?LAST_PAGE_NUM), 
            {AllPage, Page, Get} 
    end;

get_page(all_rank, Rank, Page) when Page >= 1 ->
    AllPage = util:ceil(length(Rank) / ?ALL_PAGE_NUM),
    case  AllPage < Page of
        true ->
            Get = get_list(Rank, (AllPage - 1) * ?ALL_PAGE_NUM + 1, Page * ?ALL_PAGE_NUM),
            {AllPage, AllPage, Get};
        false ->
            Get = get_list(Rank, (Page - 1) * ?ALL_PAGE_NUM + 1, Page * ?ALL_PAGE_NUM), 
            {AllPage, Page, Get} 
    end;

get_page(last_c_rank, Rank, Page) when Page >= 1 ->
    AllPage = util:ceil(length(Rank) / ?LAST_PAGE_NUM),
    case  AllPage < Page of
        true ->
            Get = get_list(Rank, (AllPage - 1) * ?LAST_PAGE_NUM + 1, Page * ?LAST_PAGE_NUM),
            {AllPage, AllPage, Get};
        false ->
            Get = get_list(Rank, (Page - 1) * ?LAST_PAGE_NUM + 1, Page * ?LAST_PAGE_NUM), 
            {AllPage, Page, Get} 
    end;

get_page(all_c_rank, Rank, Page) when Page >= 1 ->
    AllPage = util:ceil(length(Rank) / ?ALL_PAGE_NUM),
    case  AllPage < Page of
        true ->
            Get = get_list(Rank, (AllPage - 1) * ?ALL_PAGE_NUM + 1, Page * ?ALL_PAGE_NUM),
            {AllPage, AllPage, Get};
        false ->
            Get = get_list(Rank, (Page - 1) * ?ALL_PAGE_NUM + 1, Page * ?ALL_PAGE_NUM), 
            {AllPage, Page, Get} 
    end.

merge([], All) -> All;
merge([R = #role_guard{id = Id} | T], All) ->
    case lists:keyfind(Id, #role_guard.id, All) of
        false -> merge(T, [R | All]);
        _ ->
            merge(T, lists:keyreplace(Id, #role_guard.id, All, R))
    end.

merge_c([], All) -> All;
merge_c([R = #guard_counter_role{id = Id} | T], All) ->
    case lists:keyfind(Id, #guard_counter_role.id, All) of
        false -> merge_c(T, [R | All]);
        _ ->
            merge_c(T, lists:keyreplace(Id, #guard_counter_role.id, All, R))
    end.

get_list(List, Head, Tail) when Head =< Tail -> get_list(List, Head, Tail, [], 1);
get_list(List, Head, Tail) -> get_list(List, Tail, Head).

get_list([], _, _, GetList, _Flag) -> lists:reverse(GetList);
get_list(_List, Head, Tail, GetList, _Flag) when Head =:= Tail + 1 -> lists:reverse(GetList);
get_list([R | T], Flag, Tail, GetList, Flag) ->
    get_list(T, Flag + 1, Tail, [R | GetList], Flag + 1);
get_list([_ | T], Head, Tail, GetList, Flag) ->
    get_list(T, Head, Tail, GetList, Flag + 1).

%% 按积分快速排序
qsort_point([]) -> [];
qsort_point([Rank = #role_guard{point = Point1} | T]) ->
    qsort_point([R || R = #role_guard{point = Point2} <- T, Point2 > Point1])
    ++ [Rank] ++
    qsort_point([R || R = #role_guard{point = Point3} <- T, Point3 =< Point1]).

sort_point(#role_guard{point = Point1}, #role_guard{point = Point2}) when Point1 > Point2 -> true;
sort_point(R1 = #role_guard{point = Point}, R2 = #role_guard{point = Point}) ->
    sort_all_point(R1, R2);
sort_point(_, _) -> false.

sort_all_point(#role_guard{all_point = Point1}, #role_guard{all_point = Point2}) when Point1 > Point2 -> true;
sort_all_point(_, _) -> false.

sort_c_point(#guard_counter_role{point = Point1}, #guard_counter_role{point = Point2}) when Point1 > Point2 -> true;
sort_c_point(R1 = #guard_counter_role{point = Point}, R2 = #guard_counter_role{point = Point}) ->
    sort_c_all_point(R1, R2);
sort_c_point(_, _) -> false.

sort_c_all_point(#guard_counter_role{all_point = Point1}, #guard_counter_role{all_point = Point2}) when Point1 > Point2 -> true;
sort_c_all_point(_, _) -> false.


qsort_all_point([]) -> [];
qsort_all_point([Rank = #role_guard{all_point = Point1} | T]) ->
    qsort_all_point([R || R = #role_guard{all_point = Point2} <- T, Point2 > Point1])
    ++ [Rank] ++
    qsort_all_point([R || R = #role_guard{all_point = Point3} <- T, Point3 =< Point1]).

qsort_all_c_point([]) -> [];
qsort_all_c_point([Rank = #guard_counter_role{all_point = Point1} | T]) ->
    qsort_all_c_point([R || R = #guard_counter_role{all_point = Point2} <- T, Point2 > Point1])
    ++ [Rank] ++
    qsort_all_c_point([R || R = #guard_counter_role{all_point = Point3} <- T, Point3 =< Point1]).


to_table([]) -> [];
to_table([#role_guard{name = _Name, kill_npc = _KillNpc, kill_boss = _KillBoss, point = _Point, all_point = _AllPoint} | T]) ->
    ?DEBUG("Name:~s, KillNpc:~w, KillBoss:~w, Point:~w, AllPoint:~w",[_Name, _KillNpc, _KillBoss, _Point, _AllPoint]),
    to_table(T).

%% @spec day_diff(UnixTime, UnixTime) -> int()
%% @doc 两个unixtime相差的天数,相邻2天返回1
%% return int() 相差的天数
day_diff(FromTime, ToTime) when ToTime > FromTime ->
    FromDate = util:unixtime({today, FromTime}),
    ToDate = util:unixtime({today, ToTime}),
    case (ToDate - FromDate) / (3600 * 24) of
        Diff when Diff < 0 -> 0;
        Diff -> round(Diff)
    end;

day_diff(FromTime, ToTime) when ToTime=:=FromTime ->
    0;

day_diff(FromTime, ToTime) ->
    day_diff(ToTime, FromTime).
