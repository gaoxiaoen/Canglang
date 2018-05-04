%%----------------------------------------------------
%% @doc 悬赏任务处理
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(task_wanted).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
        login/1
        ,accept/2
        ,combat_check/2
        ,combat_over/2
        ,get_info/1
        ,refresh/0
        ,get_id_page/1
        ,get_status_timeout/3
        ,get_next_tick/0
        ,has_task/1
    ]).

-include("common.hrl").
-include("role.hrl").
-include("npc.hrl").
-include("gain.hrl").
-include("task_wanted.hrl").
%%

-record(state, {
        tasks = [],
        last_updated = 0,
        check_ref = 0,
        ref = 0
    }).

%% 默认怪点
-define(default_npc_located, {10002, 6000, 6000}).
-define(task_wanted_activity, 10).  %% 每次抢任务扣的精力值
-define(task_wanted_total_num, 100). %% 每次生成任务的总数量
-define(task_wanted_page_size, 10). %% 每页多少条
-define(task_wanted_npcs, [20700, 20701, 20702, 20703, 20704]). %% 悬赏怪类型
-define(task_wanted_expire, 1800). %% 任务超时30分钟
-define(task_wanted_check_timeout, 60000). %% 1分钟检查一次
-define(task_wanted_timeout_limit, 300). %% 刷新前5分钟内不能接任务
-define(task_wanted_finish_exp, 20000). %% 完成杀怪任务的奖励


%% ------ 外部接口部分 -----------
%% @spec has_task(Role) -> Result
%% Role = #role{}
%% Result = integer()
%% @doc 查看是否有未完成的悬赏任务
has_task(#role{id = Id}) ->
    gen_server:call(?MODULE, {has_task, Id}).

%% @spec login(Role) -> ok
%% @doc 登录处理
login(#role{id = Id, pid = Pid}) ->
    gen_server:cast(?MODULE, {login, Id, Pid}).


%% @spec accept(Role, TaskId) -> NewRole
%%Role = NewRole = #role{}
%% 接受任务处理
accept(#role{lev = Lev}, _) when Lev < 40 ->
    lev_lower;
accept(Role = #role{id = MyId, name = Name, lev = Lev, pid = Pid}, TaskId) ->
    case role_gain:do([#loss{label = activity, val = ?task_wanted_activity}], Role) of
        {ok, NewRole} ->
            case gen_server:call(?MODULE, {accept, MyId, Name, TaskId, Lev, Pid}) of
                [ok, 1] ->
                    ExpVal = get_exp_reward(Lev),
                    notice:inform(Pid, util:fbin(?L(<<"您触发了经验任务\n获得~w经验">>), [ExpVal])),
                    case role_gain:do(#gain{label = exp, val = ExpVal}, NewRole) of
                        {ok, NewRole1} -> 
                            log:log(log_task_wanted, {1, ?task_wanted_activity, util:unixtime(), NewRole1}),
                            {ok, NewRole1};
                        _ -> false
                    end;
                [ok, 2] ->
                    Gain = #gain{label = item, val = get_item_reward(Lev)},
                    Str = notice:gain_to_item3_inform(Gain),
                    notice:inform(Pid, ?L(<<"您触发了宝图任务">>)),
                    notice:inform(Pid, util:fbin(?L(<<"获得~s">>), [Str])),
                    case role_gain:do([Gain], NewRole) of
                        {ok, NewRole1} -> 
                            log:log(log_task_wanted, {2, ?task_wanted_activity, util:unixtime(), NewRole1}),
                            {ok, NewRole1};
                        _R -> 
                            ?DEBUG("失败 ~w", [_R]),
                            false
                    end;
                [ok, 3] ->
                    role:pack_send(Pid, 10225, {1}),
                    {ok, NewRole};
                Else ->
                    Else
            end;
        _ ->
            no_activity
    end.


%% @spec combat_check(Rid, NpcId) -> ok | {false, Why}
%% @doc 战前检查
combat_check(Rid, NpcId) ->
    case gen_server:call(?MODULE, {combat_check, Rid, NpcId}) of
        ok -> {ok};
        expire -> {false, ?L(<<"悬赏时间已过，不能击杀悬赏怪">>)};
        _ -> {false, ?L(<<"请领取悬赏任务后，击杀属于自己的悬赏怪">>)}
    end.

%% @spec combat_over(Rid, NpcId) -> ok | {false, Why}
%% @doc 战后处理 
combat_over(NpcId, NpcBaseId) ->
    case npc_data:get(NpcBaseId) of
        {ok, #npc_base{fun_type = ?npc_fun_type_task_wanted}} ->
            gen_server:cast(?MODULE, {combat_over, NpcId});
        _ ->
            ok
    end.

%% @spec get_info(all) -> Info
%% Info = #state{}
%% 获取对应的信息
get_info(all) ->
    gen_server:call(?MODULE, {info, all});

%% @spec get_info({task_type, Type) -> Info
%% 指定类型的任务列表
get_info({task_type, Type}) ->
    gen_server:call(?MODULE, {task_type, Type});

%% @spec get_info({list, Page}) -> Info
%% 获取指定页的任务
get_info({list, Page}) ->
    gen_server:call(?MODULE, {list, Page}).


%% 根据任务id获取当前页码
get_id_page(TaskId) ->
    util:ceil(TaskId / ?task_wanted_page_size).

%% @spec get_status_timeout(Type, Status, Accepted) -> {NewStatus, Timeout}
%% Type = Status = Accepted = NewStatus = Timeout = integer()
%% 根据当前类型和超时获取状态和倒计时
get_status_timeout(3, 1, Accepted) ->
    case util:unixtime() of
        Now when Now - Accepted >= ?task_wanted_expire ->
            {3, 0};
        Now ->
            {1, ?task_wanted_expire - (Now - Accepted)}
    end;
get_status_timeout(_Type, Status, _Accepted) ->
    {Status, 0}.

%% 刷新任务列表
refresh() ->
    ?MODULE ! refresh.


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    Tasks = make_tasks(1, []),
    NextTime = get_next_refresh() * 1000,
    Ref = erlang:send_after(NextTime, ?MODULE, refresh),
    Now = util:unixtime(),
    CheckRef = erlang:send_after(?task_wanted_check_timeout, ?MODULE, check_timeout),
    State = #state{tasks = Tasks, ref = Ref, check_ref = CheckRef, last_updated = Now},
    {ok, State}.

%% 接受一个任务
handle_call({accept, MyId, MyName, TaskId, Lev, Pid}, _From, State = #state{tasks = Tasks}) ->
    {Reply, NewTasks} = case get_next_refresh() < ?task_wanted_timeout_limit of
        true ->
            {timeout_limit, Tasks};
        _ ->
            case lists:keyfind(MyId, #task_wanted_data.owner_id, Tasks) of
                %% 一人只能接受一次
                #task_wanted_data{owner_id = MyId} ->
                    {accepted, Tasks};
                _ ->
                    case lists:keyfind(TaskId, #task_wanted_data.id, Tasks) of
                        %% 其他人没有接的情况下自己可以接
                        T = #task_wanted_data{owner_id = {0, <<>>}, type = Type} ->
                            {NpcId, NpcBaseId, MapId, X, Y} = create_npc(Type, MyName, Lev),
                            case NpcId of
                                0 -> ok;
                                _ ->
                                    notice:inform(Pid, ?L(<<"您触发了悬赏任务\n请前去击杀悬赏怪">>))
                            end,
                            {Status, Reward} = case Type of
                                3 -> {1, 0};
                                1 -> {2, get_exp_reward(Lev)};
                                2 ->
                                    [ItemId, _, _] = get_item_reward(Lev),
                                    {2, ItemId}
                            end,
                            NewT = T#task_wanted_data{
                                owner_id = MyId, 
                                owner_name = MyName, 
                                owner_pid = Pid,
                                npc_id = NpcId, 
                                npc_base_id = NpcBaseId,
                                map_id = MapId,
                                x = X,
                                y = Y,
                                accepted = util:unixtime(),
                                reward = Reward,
                                status = Status
                            },
                            {[ok, Type], lists:keyreplace(TaskId, #task_wanted_data.id, Tasks, NewT)};
                        #task_wanted_data{} ->
                            {theirs, Tasks};
                        _ ->
                            {not_found, Tasks}
                    end
            end
    end,
    {reply, Reply, State#state{tasks = NewTasks}};

%% 击杀悬赏怪检查
handle_call({combat_check, Rid, NpcId}, _From, State = #state{tasks = Tasks}) ->
    Now = util:unixtime(),
    Reply = case lists:keyfind(Rid, #task_wanted_data.owner_id, Tasks) of
        %% 时间过了
        #task_wanted_data{owner_id = Rid, npc_id = NpcId, accepted = Accepted} when Now - Accepted >= ?task_wanted_expire ->
            npc_mgr:remove(NpcId),
            expire;
        %% 是你的就开打吧
        #task_wanted_data{owner_id = Rid, npc_id = NpcId} ->
            ok;
        _ ->
            not_yours
    end,
    {reply, Reply, State};

%% 请求是否有悬赏怪任务
handle_call({has_task, Id}, _From, State = #state{tasks = Tasks}) ->
    Reply = case lists:keyfind(Id, #task_wanted_data.owner_id, Tasks) of
        #task_wanted_data{type = 3, status = 1} -> 1;
        _ ->0
    end,
    {reply, Reply, State};

%% 获取进程内部所有状态
handle_call({task_type, Type}, _From, State = #state{tasks = Tasks}) ->
    Reply = [Id || #task_wanted_data{id = Id, type = T} <- Tasks, T =:= Type],
    {reply, Reply, State};

%% 获取指定页任务列表
handle_call({list, Page}, _From, State = #state{tasks = Tasks}) ->
    Reply = get_page_list({?task_wanted_total_num, Tasks}, Page, ?task_wanted_page_size),
    {reply, Reply, State};

%% 获取进程内部所有状态
handle_call({info, all}, _From, State) ->
    {reply, State, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 战后把任务标识为已完成
handle_cast({combat_over, NpcId}, State = #state{tasks = Tasks}) ->
    NewTasks = case lists:keyfind(NpcId, #task_wanted_data.npc_id, Tasks) of
        T = #task_wanted_data{id = Id, npc_id = NpcId, owner_pid = Pid, accepted = Accepted} ->
            case is_pid(Pid) of
                true -> role:apply(async, Pid, {fun apply_add_exp/2, [Accepted]});
                _ -> ok
            end,
            lists:keyreplace(Id, #task_wanted_data.id, Tasks, T#task_wanted_data{status = 2});
        _ ->
            Tasks
    end,
    {noreply, State#state{tasks = NewTasks}};

%% 登录处理，如果接受过杀怪任务则更新下pid
handle_cast({login, Id, Pid}, State = #state{tasks = Tasks}) ->
    NewTasks = case lists:keyfind(Id, #task_wanted_data.owner_id, Tasks) of
        T = #task_wanted_data{type = 3, status = 1} ->
            lists:keyreplace(Id, #task_wanted_data.owner_id, Tasks, T#task_wanted_data{owner_pid = Pid});
        _ ->
            Tasks
    end,
    {noreply, State#state{tasks = NewTasks}};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 时间到更新任务
handle_info(refresh, State = #state{ref = OldRef, tasks = OldTasks}) ->
    Tasks = make_tasks(1, []),
    case erlang:is_reference(OldRef) of
        true -> erlang:cancel_timer(OldRef);
        _ -> ok
    end,
    [npc_mgr:remove(NpcId) || #task_wanted_data{npc_id = NpcId, type = Type} <- OldTasks, Type =:= 3 andalso NpcId =/= 0],
    NextTime = get_next_refresh() * 1000,
    Ref = erlang:send_after(NextTime, ?MODULE, refresh),
    Now = util:unixtime(),
    NewState = State#state{tasks = Tasks, ref = Ref, last_updated = Now},
    notice:send(52, ?L(<<"金镶玉发布了一批新的悬赏任务，诚招天下有能之士斩妖除魔。{open, 41, 我要领取, ffe100}">>)),
    {noreply, NewState};

%% 检查有没过期的任务，有则处理一下
handle_info(check_timeout, State = #state{check_ref = OldRef, tasks = OldTasks}) ->
    case erlang:is_reference(OldRef) of
        true -> erlang:cancel_timer(OldRef);
        _ -> ok
    end,
    Now = util:unixtime(),
    F = fun(T = #task_wanted_data{npc_id = NpcId, type = 3, accepted = Accepted, status = 1}) when NpcId =/= 0 andalso Now - Accepted >= ?task_wanted_expire ->
            npc_mgr:remove(NpcId),
            T#task_wanted_data{status = 3};
        (T) ->
            T
    end,
    Tasks = [F(One) || One <- OldTasks],
    Ref = erlang:send_after(?task_wanted_check_timeout, ?MODULE, check_timeout),
    NewState = State#state{check_ref = Ref, tasks = Tasks},
    {noreply, NewState};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------ 内部方法 -----
%% 生成任务列表
make_tasks(Id, Tasks) ->
    Type = case util:rand(1, 10) of
        I when I > 7 -> 3;
        I when I > 4 -> 2;
        _ -> 1
    end,
    case Id of
        ?task_wanted_total_num ->
            lists:reverse([#task_wanted_data{id = Id, type = Type} | Tasks]);
        _ ->
            make_tasks(Id + 1, [#task_wanted_data{id = Id, type = Type} | Tasks])
    end.

%% 生成任务怪
create_npc(3, RName, Lev) ->
    {MapId, X, Y} = util:rand_list(item_treasure_data:get_locates(2)),
    NpcBaseId = if
        Lev >= 80 -> 20704;
        Lev >= 70 -> 20703;
        Lev >= 60 -> 20702;
        Lev >= 50 -> 20701;
        true -> 20700
    end,
    case npc_mgr:create(NpcBaseId, MapId, X, Y, <<>>, [], util:fbin(?L(<<"~s的悬赏怪">>), [RName])) of
        {ok, NpcId} -> {NpcId, NpcBaseId, MapId, X, Y};
        _ -> {0, 0, 0, 0, 0}
    end;
create_npc(_, _, _) ->
    {0, 0, 0, 0, 0}.

%% 根据等级获取经验奖励
get_exp_reward(Lev) ->
    if
        Lev >= 80 -> 60000;
        Lev >= 70 -> 50000;
        Lev >= 60 -> 40000;
        Lev >= 50 -> 30000;
        true -> 20000
    end.
%% 根据等级获取宝图奖励
get_item_reward(Lev) ->
    if
        Lev >= 70 -> [29203, 1, 1];
        Lev >= 60 -> [29202, 1, 1];
        Lev >= 50 -> [29201, 1, 1];
        true -> [29200, 1, 1]
    end.

%% 获取分页列表
get_page_list({_N, []}, _P, _S) -> 
    {1, [], 0};
get_page_list({Num, List}, Page, Size) when is_integer(Num) andalso is_list(List) andalso is_integer(Page) ->
    NewPage = min(max(Page, 1), max(1, util:ceil(Num / Size))),
    StartId = (NewPage - 1) * Size + 1,
    %% ?DEBUG("page ~p size ~p", [NewPage, Size]),
    NewList = lists:sublist(List, StartId, Size),
    {NewPage, NewList, Num};
get_page_list(_Y, _P, _S) -> 
    {1, [], 0}.

%% 获取下一次刷新时间
get_next_refresh() ->
    case erlang:time() of
        {H, _, _} when H < 8 -> 
            util:datetime_to_seconds({date(), {8, 30, 0}}) - util:unixtime();
        {8, M, _} when M < 30 -> 
            util:datetime_to_seconds({date(), {8, 30, 0}}) - util:unixtime();
        %% 偶数小时要看看是否在半点前后
        {H, M, _} when H < 23 andalso M < 30 andalso H rem 2 =:= 0 ->
            util:datetime_to_seconds({date(), {H, 30, 0}}) - util:unixtime();
        {H, _, _} when H < 22 andalso H rem 2 =:= 0 ->
            NewH = case H + 2 of
                24 -> 0;
                I -> I
            end,
            util:datetime_to_seconds({date(), {NewH, 30, 0}}) - util:unixtime();
        %% 奇数就直接看看一小时后吧
        {H, _, _} when H < 22 ->
            NewH = case H + 1 of
                24 -> 0;
                I -> I
            end,
            util:datetime_to_seconds({date(), {NewH, 30, 0}}) - util:unixtime();
        _ ->
            util:datetime_to_seconds({date(), {8, 30, 0}}) - util:unixtime() + (3600 * 24)
    end.

%% 获取下一个时间点
get_next_tick() ->
    case erlang:time() of
        {H, _, _} when H < 8 -> 
            [8, 30];
        {8, M, _} when M < 30 -> 
            [8, 30];
        %% 偶数小时要看看是否在半点前后
        {H, M, _} when H < 23 andalso M < 30 andalso H rem 2 =:= 0 ->
            [H, 30];
        {H, _, _} when H < 22 andalso H rem 2 =:= 0 ->
            NewH = case H + 2 of
                24 -> 0;
                I -> I
            end,
            [NewH, 30];
        %% 奇数就直接看看一小时后吧
        {H, _, _} when H < 22 ->
            NewH = case H + 1 of
                24 -> 0;
                I -> I
            end,
            [NewH, 30];
        _ ->
            [8, 30]
    end.

apply_add_exp(Role = #role{pid = Pid}, Accepted) ->
    case role_gain:do([#gain{label = exp, val = ?task_wanted_finish_exp}], Role) of
        {ok, NewRole} ->
            role:pack_send(Pid, 10225, {0}),
            notice:inform(Pid, util:fbin(?L(<<"你完成悬赏任务\n获得~w经验">>), [?task_wanted_finish_exp])),
            log:log(log_task_wanted, {3, ?task_wanted_activity, Accepted, NewRole}),
            {ok, NewRole};
        _ ->
            {ok}
    end.
