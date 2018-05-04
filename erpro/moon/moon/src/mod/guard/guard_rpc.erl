%%----------------------------------------------------
%% 守卫洛水相关远程调用
%% @author shawnoyc@163.com
%%----------------------------------------------------

-module(guard_rpc).
-export([handle/3]).

-include("role.hrl").
-include("common.hrl").
%%
-include("guard.hrl").
-include("attr.hrl").

handle(15400, {}, _Role) ->
    case guard_mgr:get_status() of
        {State, Lev, Hp, Time} ->
            {reply, {State, Lev, Hp, Time}};
        _ ->
            {ok}
    end;

handle(15401, {}, _Role) ->
    case guard_mgr:get_boss() of
        {} -> {ok};
        Boss ->
            {reply, Boss}
    end;

%%  获取积分榜Page页数据
handle(15402, {Page}, #role{}) ->
    case guard_mgr:get_rank(last_rank, Page) of
        {AllPage, GetPage, GetList} -> 
            {reply, {GetList, GetPage, AllPage}};
        _X ->
            {ok}
    end;

%%  获取累计积分榜Page页数据
handle(15403, {Page}, #role{}) ->
    case guard_mgr:get_rank(all_rank, Page) of
        {AllPage, GetPage, GetList} -> 
            {reply, {GetList, GetPage, AllPage}};
        _X ->
            {ok}
    end;

%% 查看自己的排行
handle(15404, {}, #role{id = Id}) ->
    Reply =  guard_mgr:get_rank(owner, {Id, last_rank}),
    {reply, Reply};

handle(15405, {}, #role{id = Id}) ->
    Reply =  guard_mgr:get_rank(owner, {Id, all_rank}),
    {reply, Reply};

handle(15406, {_}, #role{event = Event}) when Event =/= ?event_no ->
    {reply, {?false, ?L(<<"当前状态无法参加守卫洛水">>)}};
handle(15406, {_}, #role{combat_pid = CPid}) when is_pid(CPid) ->
    {reply, {?false, ?L(<<"战斗中,无法传送参加守卫洛水">>)}};
handle(15406, {Type}, Role) when Type =:= 1 orelse Type =:= 2 ->
    case guard_mgr:trans(Type, Role) of
        {ok, NewRole} -> {reply, {?true, <<"">>}, NewRole};
        {false, M} -> {reply, {?false, M}};
        _E ->
            ?ERR("守卫洛水传送出错:~w", [_E]),
            {ok}
    end;

%% 进入洛水反击
handle(15407, {}, #role{lev = Lev}) when Lev < 40 ->
    {reply, {?false, ?L(<<"40级以上才能参与洛水反击">>)}};
handle(15407, {}, #role{attr = #attr{fight_capacity = Fight}}) when Fight < 3500 ->
    {reply, {?false, ?L(<<"3500战力以上才能参与洛水反击">>)}};
handle(15407, {}, #role{event = Event}) when Event =/= ?event_no ->
    {reply, {?false, ?L(<<"当前状态不能参与洛水反击">>)}};
handle(15407, {}, #role{combat_pid = CPid}) when is_pid(CPid) ->
    {reply, {?false, ?L(<<"战斗中不能参与洛水反击">>)}};
handle(15407, {}, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {?false, ?L(<<"队伍中不能参与洛水反击">>)}};
handle(15407, {}, #role{cross_srv_id = <<"center">>}) ->
    {reply, {?false, ?L(<<"跨服场景中不能参与洛水反击">>)}};
handle(15407, {}, #role{ride = ?ride_fly}) ->
    {reply, {?false, ?L(<<"飞行中不能参与洛水反击">>)}};
handle(15407, {}, Role) ->
    guard_mgr:enter_zone(Role),
    {ok};

%% 退出洛水反击
handle(15408, {}, #role{combat_pid = CPid}) when is_pid(CPid) ->
    {reply, {?false, ?L(<<"战斗中不能退出洛水反击">>)}};
handle(15408, {}, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {?false, ?L(<<"队伍中不能退出洛水反击">>)}};
handle(15408, {}, #role{event = Event}) when Event =/= ?event_guard_counter ->
    {reply, {?false, ?L(<<"您当前不在洛水反击中,无法退出">>)}};
handle(15408, {}, #role{status = ?status_normal, pid = Pid, id = RoleId}) ->
    guard_mgr:exit_combat_area(Pid, RoleId),
    {ok};
handle(15408, {}, _) ->
    {reply, {?false, ?L(<<"您当前状态无法退出洛水反击">>)}};

%% 处理复活
handle(15409, {Type}, #role{event = ?event_guard_counter, id = Rid, pid = Pid, status = ?status_die}) when Type =:= 0 orelse Type =:= 1 ->
    guard_mgr:revive(Type, Rid, Pid),
    {ok};
handle(15409, _, _) -> {ok};

%% 获取反击boss状态 
handle(15410, {}, #role{event = ?event_guard_counter}) ->
    case guard_mgr:guard_boss_status() of
        {ok, ?true, Hp, MaxHp} -> {reply, {?true, Hp, MaxHp}};
        _ -> {reply, {?false, ?guard_counter_boss_hp, ?guard_counter_boss_hp}}
    end;
handle(15410, {}, _) -> {ok};

%% 获取榜 
handle(15411, {}, #role{event = ?event_guard_counter}) ->
    case catch guard_mgr:get_combat_rank() of
        Ranks when is_list(Ranks) -> {reply, {Ranks}};
        _ -> {ok} 
    end;
handle(15411, {}, _) -> {ok};

%% 获取榜 
handle(15412, {}, #role{}) ->
    case catch guard_mgr:get_c_status() of
        {Status, Time} when is_integer(Status) ->
            {reply, {Status, Time}};
        _ -> {ok} 
    end;
handle(15412, {}, _) -> {ok};

%%  获取积分榜Page页数据
handle(15413, {Page}, #role{}) ->
    case guard_mgr:get_rank(last_c_rank, Page) of
        {AllPage, GetPage, GetList} -> 
            {reply, {GetList, GetPage, AllPage}};
        _X ->
            {ok}
    end;

%%  获取累计积分榜Page页数据
handle(15414, {Page}, #role{}) ->
    case guard_mgr:get_rank(all_c_rank, Page) of
        {AllPage, GetPage, GetList} -> 
            {reply, {GetList, GetPage, AllPage}};
        _X ->
            {ok}
    end;

%% 屠魔勇士
handle(15415, {}, _Role) ->
    case guard_mgr:get_c_boss() of
        {} -> {ok};
        Boss ->
            {reply, Boss}
    end;

%% 查看洛水情况
handle(15416, {}, _Role) ->
    case guard_mgr:get_mode() of
        {Mode1, Mode2} ->
            {reply, {Mode1, Mode2}};
        _ ->
            {ok}
    end;

%% 查看自己的排行
handle(15417, {}, #role{id = Id}) ->
    Reply =  guard_mgr:get_rank(owner, {Id, last_c_rank}),
    {reply, Reply};

handle(15418, {}, #role{id = Id}) ->
    Reply =  guard_mgr:get_rank(owner, {Id, all_c_rank}),
    {reply, Reply};

handle(_Cmd, _Data, _Role) ->
    {error, guard_rpc_unknow_command}.
