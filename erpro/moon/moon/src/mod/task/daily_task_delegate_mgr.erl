%% 日常任务代理管理器

-module(daily_task_delegate_mgr).
-behaviour(gen_server).

-export([

        start_link/0
        ,delegate_task/2
        ,lookup_task/2
        ,get_task/5
        ,cancle_task/3
        ,test/0

    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("task.hrl").
-include("role.hrl").
-include("notification.hrl").

-define(EXPIRE_TIME, 3600 * 24 * 3). %% 信件保留时间

delegate_task(DelegateTask, Role) -> gen_server:call({global, ?MODULE}, {delegate_task, DelegateTask, Role}).

lookup_task(RoleId, SrvId) -> gen_server:call({global, ?MODULE}, {lookup, RoleId, SrvId}).

get_task(RoleId, SrvId, Ids, Lvl, Cmd) -> gen_server:call({global, ?MODULE}, {get_task, RoleId, SrvId, Ids, Lvl, Cmd}).

cancle_task(RoleId, SrvId, TaskId) -> gen_server:call({global, ?MODULE}, {cancle, RoleId, SrvId, TaskId}).

test() -> 
    ?DEBUG("***** 发送SEND *******"),
    gen_server:cast({global, ?MODULE},{send}).

%%----------------------------------------------------
%% 系统函数
%%----------------------------------------------------

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]), 
    Tab = ets:new(?MODULE, []),
    case delegate_task_dao:load_data() of
        {ok, Data} ->
            init_data(Data, Tab),
            
            ?INFO("[~w]启动完成~~", [?MODULE]),
            Now = util:unixtime(),
            erlang:send_after((util:unixtime(today) + 86400 - Now) * 1000, self(), do_hour_24),
            {ok, Tab};  
        _ ->
            ?ERR("加载委托日常任务出错")
    end.

%%----------------------------------------------------
%% handle_call
%%----------------------------------------------------

handle_call({delegate_task, DelegateTask, _Role}, _From, Tab) ->
    #delegate_task{id = Id, time = Time, rid = Rid, srv_id = SrvId, mail_id = TaskId, quality = Q} = DelegateTask,
    case ets:lookup(Tab, {Rid, SrvId}) of
        [] ->
            ets:insert(Tab, {{Rid, SrvId}, [{Id, Time, TaskId, Q}]});
        [{Key, TaskList}] ->
            ets:insert(Tab, {Key, [{Id, Time, TaskId, Q} | TaskList]})
    end,
    delegate_task_dao:save_task(Id, Time, Rid, SrvId, TaskId, Q),
    put_dict([Id, Time, Rid, SrvId, TaskId, Q]),
    {reply, {ok}, Tab};

handle_call({lookup, Rid, SrvId}, _From, Tab)->
    case ets:lookup(Tab, {Rid, SrvId}) of
        [] ->
            {reply, [], Tab};
        [{_Key, List}] ->
            Now = util:unixtime(),
            List1 = [I || I = {_Id, Time, _TaskId, _Q} <- List, Now - Time <  ?EXPIRE_TIME],
            Expire = [I || I = {_Id, Time, _TaskId, _Q} <- List, Now - Time >= ?EXPIRE_TIME],
            {reply, {List1, Expire}, Tab}
    end;

handle_call({get_task, _Rid, _SrvId, Ids, Lvl, _Cmd}, _From, Tab) ->
    case task_data:get_lvl_range(Lvl) of
        false ->
            {reply, [], Tab};
        Range ->
            TaskConf = task_data:get_daily_task(Range),
            LvlId = [TaskId || {TaskId,_,_,_} <- TaskConf],
            ?DEBUG(" Range : ~w", [Range]),
            case get(Range) of
                undefined ->
                    Tasks3 = get_sys_task(LvlId, Ids, 3),
                    {reply, Tasks3, Tab};
                List ->
                    ?DEBUG(" 符合等级的玩家委托任务 ~w", [List]),
                    FiltedIds = [Data || Data = {{_Rid1, _SrvId1, TaskId1}, _, _, _} <- List, lists:member(TaskId1, Ids) =:= false],
                    ?DEBUG(" 符合玩家条件的任务ID  ~w", [FiltedIds]),
                    Task = get_rand_task(FiltedIds, Ids, 3),
                    case length(Task) < 3 of
                        true -> %% 系统补足
                            Num = 3 - length(Task),
                            Tasks2 = get_sys_task(LvlId, Ids, Num),
                            {reply, Task++Tasks2, Tab};
                        false -> %% 取够了3个
                            {reply, Task, Tab}
                    end
            end
    end;

handle_call( {cancle, RoleId, SrvId, TaskId}, _From, Tab) ->
    case ets:lookup(Tab, {RoleId, SrvId}) of
        [] ->
            {reply, false, Tab}; %% 没有找到此任务
        [{Key, List}] ->
            case lists:keyfind(TaskId, 3, List) of
                false ->
                    {reply, false, Tab};
                Data -> 
                    NewList = lists:keydelete(TaskId, 3, List),
                    ets:insert(Tab, {Key, NewList}),
                    LvlRange = task_data:get_task_lvl(TaskId),
                    TaskList = get(LvlRange),
                    case get(LvlRange) of
                        undefined ->
                            skip;
                        TaskList ->
                            NList = lists:keydelete({RoleId, SrvId, TaskId}, 1, TaskList),
                            put(LvlRange, NList)
                    end,
                    delegate_task_dao:delete_task(RoleId, SrvId, TaskId),                   
                    {reply, Data, Tab}
                end
    end;


handle_call(_Request, _From, Tab) ->
    {noreply, Tab}.

%%----------------------------------------------------
%% handle_cast
%%----------------------------------------------------

handle_cast({send}, Tab) ->
    ?DEBUG("向服务发送清理过期委托日常任务消息"),
    erlang:send_after(1 * 1000, self(), do_hour_24),
    {noreply, Tab};

handle_cast(_Msg, Tab) ->
    {noreply, Tab}.

%%----------------------------------------------------
%% handle_info
%%----------------------------------------------------

%% 每天午夜12点
handle_info(do_hour_24, Tab) ->
    ?DEBUG(" 委托任务  正在清理过期委托任务  ...."),
    Data = check_expire(Tab),
    ets:delete_all_objects(Tab),
    [ets:insert(Tab, Item) || Item <- Data],
    erase(),
    [[put_dict([Id, Time, RoleId, RoleSrvId, TaskId, Q]) || {Id, Time, TaskId, Q} <- L] || {{RoleId, RoleSrvId}, L} <- Data],
    Now = util:unixtime(),
    erlang:send_after((util:unixtime(today) + 86400 - Now) * 1000, self(), do_hour_24),
    _Dict = get(),
    ?DEBUG("进程字典信息  ~w", [_Dict]),
    {noreply, Tab};

handle_info(_Info, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% 系统关闭
%%----------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%----------------------------------------------------
%% 热代码切换
%%----------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 私有函数。
%%----------------------------------------------------
init_data([],  _RidMailTab) -> ok;
init_data([D = [Id, Time, Rid, SrvId, TaskId, Quality] | T], Tab) ->
    RoleKey = {Rid, SrvId},
    case ets:lookup(Tab, RoleKey) of
        [] ->
            ets:insert(Tab, {RoleKey, [{Id, Time, TaskId, Quality}]});
        [{Key, V}] ->
            ets:insert(Tab, {Key, [{Id, Time, TaskId, Quality} | V]})
    end,
    put_dict(D),
    init_data(T, Tab).


%% 根据任务等级范围分别存进进程字典，方便根据等级范围找出任务
put_dict([]) -> ok;
put_dict([Id, Time, Rid, SrvId, TaskId, Quality]) ->
    Range = task_data:get_task_lvl(task_data:convert_id(TaskId)),
    case Range of
        false ->
            skip;
        _ ->
            case get(Range) of
                undefined ->
                    ?DEBUG(" 空 "),
                    put(Range, [{{Rid, SrvId, TaskId}, Id, Quality, Time}]);
                List ->
                    put(Range, [{{Rid, SrvId, TaskId}, Id, Quality, Time} | List])
            end
    end.
       
%% 符合基本要求的日常任务列表(等级，已接等), FilterList = [{{Rid, SrvId, TaskId}, Id, Q, Time} | ]
%% Num = int()
%% 输出结果 Res = [{Rid, SrvId, TaskId} | {}]
get_rand_task(FilterList, HasId, Num) ->
    List = [{Rid, SrvId, TaskId} || {{Rid, SrvId, TaskId}, _Id, _Q, _Time} <- FilterList], %% 找出每个任务的权重
    List1 = convert(List, []),
    do_get_rand_task(List1, HasId, Num, []).

%% List = [{{Rid, SrvId, TaskId}, Rate} | xxx]
%% do_get_rand_task() -> [{Rid, SrvId, TaskId}]
do_get_rand_task([], _HasId, _Num, Res) -> ?DEBUG("还没取够给定的数量,只取了~p~n", [length(Res)]),  Res;
do_get_rand_task(_List, _HasId, 0, Res) -> Res;
do_get_rand_task(List, HasId, Num, Res) ->
    SumRate = count_sum_rate(List),
    RandNum = util:rand(1, SumRate),
    case get_task_by_rand(RandNum, 0, List) of
        false ->
            false;
        {Rid, SrvId, TaskId} ->
            List1 = [Data || Data = {{_, _, TaskId1}, _Rate} <- List, TaskId1 =/= TaskId], %% 过滤掉已经拿出来的任务
            do_get_rand_task(List1, HasId, Num - 1, [{Rid, SrvId, TaskId} | Res])
    end.

%% List = [{_, Rate}]
count_sum_rate(List) ->
    lists:foldl(fun({{_Rid, _SrvId, _TaskId},Rate}, Sum) -> Sum+Rate end, 0, List).

%% 根据权值找出一个任务
%% List = [{{Rid, SrvId, TaskId}, Rate}]
get_task_by_rand(_Random, _Range, []) -> false;
get_task_by_rand(RandNum, Range, [{D = {_Rid, _SrvId, _TaskId}, Rate} | T]) ->
    case RandNum =< Range + Rate of
        true ->
            D;
        false ->
            get_task_by_rand(RandNum, Range+Rate, T)
    end.

%%  NUM -> int， 要获取的数量
%%  Tasks -> [task_id | ] 任务ID列表
%%  HasId -> [task_id] 已有任务ID
%%  get_sys_task() -> [task_id]
get_sys_task(Tasks, HasId, Num) ->
    List = [{0, <<"">>, TaskId} || TaskId <- Tasks],
    List1 = convert(List, []),
    do_get_sys_task(List1, HasId, Num, []).

%% Tasks -> [{{Rid, SrvId, TaskId}, Rate} | ]
%% Num -> int() 要取的任务数量
%% do_get_sys_task() -> [{Rid, SrvId, TaskId}]
%% do_get_sys_task(Tasks, HasId, Num) ->
%%    do_get_rand_task(Tasks, HasId, Num, []).

%% List = [{{Rid, SrvId, TaskId}, Rate} | xxx]
%% do_get_rand_task() -> [{Rid, SrvId, TaskId}]
do_get_sys_task([], _HasId, _Num, Res) -> ?DEBUG("还没取够给定的数量,只取了~p~n", [length(Res)]),  Res;
do_get_sys_task(_List, _HasId, 0, Res) -> Res;
do_get_sys_task(List, HasId, Num, Res) ->
    SumRate = count_sum_rate(List),
    RandNum = util:rand(1, SumRate),
    case get_task_by_rand(RandNum, 0, List) of
        false ->
            false;
        {Rid, SrvId, OrigTaskId} ->
            %% List1 = [Data || Data = {{_, _, TaskId1}, _Rate} <- List, TaskId1 =/= TaskId], %% 过滤掉已经拿出来的任务
            HasGet = [Id || {_, _, Id} <- Res],
            CanGet = task_data:id2id(OrigTaskId) -- HasId, %% 去掉已接
            CanGet1 = CanGet -- HasGet, %% 去掉已抽
            ?DEBUG(" 可抽选的日常任务ID为 ~w", [CanGet1]),
            case CanGet1 of
                [] ->
                    do_get_sys_task(List, HasId, Num - 1, Res);
                _ ->
                    GetId = lists:nth(util:rand(1, length(CanGet1)), CanGet1),
                    do_get_sys_task(List, HasId, Num - 1, [{Rid, SrvId, GetId} | Res])
            end
    end.

%% 数据加上权重
convert([], Res) -> Res;
convert([D = {_Rid, _SrvId, TaskId} | T], Res) ->
    case task_data:get_rate(task_data:convert_id(TaskId)) of
        0 ->
            convert(T, Res);
        RateNum ->
            convert(T, [{D, RateNum} | Res])
    end.
 
check_expire(Tab) ->
    List = ets:tab2list(Tab),
    do_check_expire(List, []).

%% TaskList -> {Id, Time, TaskId, Quality} 
do_check_expire([], NewList) -> NewList;
do_check_expire([{RID = {RoleId, RoleSrvId}, TaskList} | T], List) ->
    Fun = fun(V = {_Id, Time, _TaskId, _Q}, {Vaild, Expire}) ->
                Now = util:unixtime(),
                case Now - Time < ?EXPIRE_TIME of
                    true ->
                        {[V | Vaild], Expire};
                    false ->
                        {Vaild, [V | Expire]}
                end end,
    {Vaild1, Expire1} = lists:foldl(Fun, {[], []}, TaskList),
    ?DEBUG("过期的信件数量 ~w  ", [length(Expire1)]),
    ?DEBUG("有效信件数量 ~w", [length(Vaild1)]),
    del_from_db(Expire1, {RoleId, RoleSrvId}),
    notify(Expire1, RID),
    case length(Vaild1) > 0 of
        true ->
            do_check_expire(T, [{RID, Vaild1} | List]);
        false ->
            do_check_expire(T, List)
    end.

del_from_db([], _) -> ok;
del_from_db([{_Id, _Time, TaskId, _Q} | T], {RoleId, RoleSrvId}) ->
    delegate_task_dao:delete_task(RoleId, RoleSrvId, TaskId),
    del_from_db(T, {RoleId, RoleSrvId}).

notify(Expire, RID) ->
    Len = length(Expire),
    case Len > 0 of
        true ->
            Msg = util:fbin(?L(<<"您在委托中转站有~w封信因到期已被漂流出去">>), [Len]),
            ?DEBUG("*************  发言  ~p", [Msg]),
            notification:send(offline, RID, ?notify_type_wanted, Msg, []);
        false ->
            skip
    end.

