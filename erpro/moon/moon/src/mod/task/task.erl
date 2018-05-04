%%----------------------------------------------------
%% @doc 任务系统
%%
%% <pre>
%% 任务系统公
%% </pre>
%% @author yeahoo2000@gmail.com
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(task).
-export([
        login/1 
        ,logoff/1 
        ,accept_chain/1
        ,accept/2
        ,giveup_chain/1
        ,giveup/2
        ,commit_chain/1
        ,commit/2
        ,finish/2
        ,combat_over/2
        ,winner_combat_over/2
        ,drop/2
        ,refresh_acceptable_task/4
        ,refresh_acceptable_task/3
        ,finish_link/2
        ,check_finish_cond/3
        ,get_all_type_acceptabel/0
        ,check_accep_cond/2
        ,get_task_base_by_prev/2
        ,lev_up_fire/1
        ,init_cache/1
        ,delete_cache/3
        ,add_cache/3
        ,get_dict/2
        ,update_cache/2
        ,get_dict/1
        ,get_count/2
        ,reload/1
        ,rebuild_trigger/1
        ,task_gain_prog/1
        ,update_next_lev_task/2
        ,convert_accept_num/3
        ,platform_task/2
        ,is_finish_sq_task/0        
        ,gm_accept/2
        ,add_eqm/2
        ,is_zhux_finish/1
        ,is_accepted/2
        ,finish_task_fire_star_dun/1
        ,clear_dungeon_fire/2
        ,accept_star_dungeon/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("task.hrl").
-include("condition.hrl").
%%
-include("link.hrl").
-include("gain.hrl").
-include("item.hrl").
-include("trigger.hrl").
-include("combat.hrl").
-include("guild.hrl").
-include("storage.hrl").
-include("pos.hrl").
-include("npc.hrl").
-include("assets.hrl").
-include("mail.hrl").
-include("team.hrl").
-include("dungeon.hrl").

-define(KEY_POS, 2).
-define(task_token_green, 31001).       %% 飞仙令牌.绿

-define(free_fresh_time, 3).        %% 每天免费刷新委托日常任务数
-define(accept_delegate_task, 5).   %% 每天可接委托日常任务数量

-define(max_daily_num, 20).         %% 最大日常任务数
-define(daily_open_lev, 32).        %% 日常任务开放等级
-define(daily_set_task_lev, 29).    %% 发放十封信等级
-define(daily_time, 300).           %% 在线五分钟给日常任务
-define(total_daily_time, 3000).    %% 日常任务总在线时长 10封 , 每封 300 秒

%%----------------------------------------------------
%% 与其它模块交互
%%----------------------------------------------------
%% @spec login(Role) -> NewRole
%% @doc
%% <pre>
%% Role = #role{} 角色
%% NewRole = #role{} 初始化任务数据后的角色
%% 初始化任务数据
%% </pre>
login(Role = #role{id = {RoleId, SrvId}, task_role = TaskRole = #task_role{elem_list = ElemList}}) ->

    delete_expire_data(Role),
    Data = case role:get_dict({init_task_list, RoleId, SrvId}) of
        {ok, Data2} when Data2 =/= undefined -> 
            Data2;
        _ ->
            ?ERR("角色读不到进程字典数据task_list[RoleId:~w, SrvId:~w]", [RoleId, SrvId]),
            task_dao:get_task_list(RoleId, SrvId)
    end,
    {TaskList, NRole} = load_data(Data, Role),

    NewElemList = login_task_role_elem(TaskList, ElemList),
    NewRole = NRole#role{task = TaskList, task_role = TaskRole#task_role{elem_list = NewElemList}},

    init_cache(NewRole), %% 初始化可接，已接 的各种任务
    Now = util:unixtime(),
    Tomorrow = util:unixtime({tomorrow, Now}),
    erlang:send_after((Tomorrow - Now) * 1000, self(), {apply_async, {task, reload, []}}),
    rebuild_trigger(NewRole).

load_data([[Rid, SrvId, TaskId, Status, Type, SecType, Owner, AcceptTime, FinishTime, AcceptNum, Progress, AttrList, ItemBaseId, ItemNum] | T], Role = #role{}) ->
    case task_data:get_conf(TaskId) of
        {ok, _} ->
            {ok, Prog} = util:bitstring_to_term(Progress),
            {ok, NewAttrList} = util:bitstring_to_term(AttrList),
            NewProgress = task_util:lists_to_records(Prog),
            FilterProgress = [P || P = #task_progress{status = 0} <- NewProgress],
            NewStatus = case FilterProgress of
                [] -> 1;
                _ -> Status
            end,
            Quality = case lists:keyfind(quality, 1, NewAttrList) of
                {quality, Qtt} -> Qtt;
                _ -> ?task_quality_white
            end,
            Task = #task{task_id = TaskId, status = NewStatus, type = Type, sec_type = SecType, owner = Owner, accept_time = AcceptTime, finish_time = FinishTime, accept_num = AcceptNum, progress = NewProgress, attr_list = NewAttrList, item_base_id = ItemBaseId, item_num = ItemNum, quality = Quality},
            %% TODO 临时处理
            {NewTaskList, NewRole} = load_data(T, Role),
            {[Task | NewTaskList], NewRole};
        _ ->
            task_dao:delete_task(Rid, SrvId, TaskId), %% 删除过期任务
            load_data(T, Role)
    end;
load_data([], Role) ->
    {[], Role}.

%% @spec logoff(Role) -> Result
%% @doc
%% <pre>
%% Role = #role{} 角色
%% Result = integer() 运行结
%% 保存任务数据
%% </pre>
logoff(Role = #role{id = {Rid, SrvId}, task = Task}) ->
    save_task_data(Task, Rid, SrvId),
    {ok, Role}.

save_task_data([Task | T], Rid, SrvId) ->
    task_dao:save_task(Task, Rid, SrvId),
    save_task_data(T, Rid, SrvId);
save_task_data([], _Rid, _SrvId) ->
    ok.

%% 获取所有类型的可接任务类型
get_all_type_acceptabel() ->
    {ok, List0} = role:get_dict(task_acceptable_zhux),   %% 主线
    {ok, List1} = role:get_dict(task_acceptable_zhix),   %% 支线
    List0 ++ List1.

%% 接受任务接口
accept_chain(TaskParamAccept = #task_param_accept{task_id = TaskId}) ->
    case task_data:get_conf(TaskId) of
        {ok, TaskBase = #task_base{type = Type}} ->
            case Type of
                ?task_type_rc ->
                    do_accept_chain([accept_daily_task], TaskParamAccept#task_param_accept{task_base = TaskBase});
                ?task_type_spec ->
                    do_accept_chain([accept_spec], TaskParamAccept#task_param_accept{task_base = TaskBase});
                ?task_type_star_dun ->    %% 副本星级任务
                    do_accept_chain([accept_stardun], TaskParamAccept#task_param_accept{task_base = TaskBase});
                _ ->    
                    do_accept_chain([check_acceptable, check_distance, accept, loss_item], TaskParamAccept#task_param_accept{task_base = TaskBase})
            end;
        {false, Reason} ->
            {false, Reason}
    end.

%% @spec accept(TaskId, Role) -> {false, Reason} | {ok, NewRole}
%% @doc
%% <pre>
%% TaskId = integer() 基础任务ID
%% Role = #role{} 角色数据
%% NewRole = #role{} 新角色数据
%% Reason = binary() 失败原因
%% 接受任务
%% </pre>
accept(TaskId, Role = #role{career = Career, task = TaskList, trigger = Trigger}) ->
    case task_data:get_conf(TaskId) of
        {ok, Task = #task_base{type = Type, sec_type = SecType, cond_finish = TaskCondFinish, accept_rewards = AcceptRewards}} ->
            case lists:keyfind(TaskId, ?KEY_POS, TaskList) of
                false ->
                    case check_accep_cond(Role, Task) of %%是否可接任务
                        {false, Reason} ->
                            {false, Reason};
                        true ->
                            AcceptNum = get_accept_num(Type, Career, TaskId),
                            case check_finish_cond(TaskCondFinish, Role, []) of
                                {true, ProgList} -> %% 生成一条已完成的任务数据
                                    case role_gain:do(AcceptRewards, Role) of
                                        {ok, NewRole} ->
                                            {ok, NewRole#role{task = [#task{task_id = TaskId, type = Type, sec_type = SecType, accept_time = util:unixtime(), accept_num = AcceptNum, status = 1, progress = ProgList} | TaskList]}};
                                        {false, _} ->
                                            {false, ?L(<<"接受任务失败，可能因为您背包空间不足">>)}
                                    end;
                                {false, _Reason} -> %% 注册触发器和生成任务进度信息 接受接受
                                    case reg_trigger(TaskCondFinish, [], TaskId, Trigger, Role) of
                                        {ok, P, Nt} ->
                                            case role_gain:do(AcceptRewards, Role) of
                                                {ok, NewRole} ->
                                                    {ok, NewRole#role{trigger = Nt, task = [#task{task_id = TaskId, type = Type, sec_type = SecType, accept_time = util:unixtime(), accept_num = AcceptNum, status = 0, progress = P} | TaskList]}};
                                                {false, _} ->
                                                    {false, ?L(<<"接受任务失败，可能因为您背包空间不足">>)}
                                            end;
                                        _E ->
                                            ?ELOG("接受任务失败: TaskId:~w, Reason:~w", [TaskId, _E]),
                                            {false, ?L(<<"接受任务失败">>)}
                                    end
                            end
                    end;
                _ ->
                    {false, <<"">>}
                    %% {false, ?L(<<"你已经接下了此任务">>)}
            end;
        _ ->
            {false, ?L(<<"不存在此任务">>)}
    end.

%% 提交任务后置事件
commit_chain(TaskParamCommit = #task_param_commit{task_id = TaskId}) ->
    case task_data:get_conf(TaskId) of
        {ok, TaskBase = #task_base{type = ?task_type_star_dun}} ->
            do_commit_chain([finish_progress, commit, gain_loss_notice, misc_fire], TaskParamCommit#task_param_commit{task_base = TaskBase});
        {ok, TaskBase} ->
            do_commit_chain([finish_progress, distance, commit, gain_loss_notice, misc_fire], TaskParamCommit#task_param_commit{task_base = TaskBase});
        {false, Reason} ->
            {false, TaskParamCommit#task_param_commit{reason = Reason}}
    end.

%% @spec commit(TaskId, Role) -> {ok, NewRole} | {false, Reason} | {false, Reason, NewRole}
%% @doc
%% <pre>
%% TaskId = integer() 任务ID
%% Role = #role{} 角色数据
%% NewRole = #role{} 新角色数据
%% Reason = binary() 失败原因
%% 提交任务
%% </pre>
commit(#task_param_commit{task_id = TaskId, finish_imm = FinishImm}, Role = #role{id = {RoleId, SrvId}, lev = Lev, task = TaskList}) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{finish_rewards = Rewards, kind = Kind, type = Type, sec_type = SecType}} ->
            SRewards = gainloss_qsort(Rewards),
            case lists:keyfind(TaskId, ?KEY_POS, TaskList) of
                false -> 
                    {false, <<>>};
                    %% {false, ?L(<<"你并未接受该任务">>)};
                Task = #task{accept_time = AcceptTime, status = ?true, progress = Progress, item_base_id = ItemBaseId, item_num = ItemNum, quality = Quality} -> %% 任务已完成，可提交
                    Rewards2 = case {Kind, Type} of
                        {2, _} -> %% 飞仙令
                            case task_data_item:get(TaskId, ItemBaseId, ItemNum) of
                                {ok, #task_base_item{finish_rewards = ItemRewards}} ->
                                    ItemRewards;
                                {false, _Reason} ->
                                    ?ELOG("飞仙令任务数据有误[TaskId:~w, ItemBaseId:~w, ItemNum:~w]", [TaskId, ItemBaseId, ItemNum]),
                                    SRewards
                            end;
                        {_, ?task_type_xx} ->
                            case task_util:gain_xx(Lev, Quality) of
                                {ok, XxRewards} -> 
                                    %% 加入采集修行任务后，修行任务可能也要扣除物品
                                    SRewards ++ XxRewards;
                                {false, _Reason} ->
                                    ?ERR("修行任务奖励数据有误[Lev:~w, TaskId:~w, SecType:~w, Quality:~w]", [Lev, TaskId, SecType, Quality]),
                                    SRewards
                            end;
                        _ -> SRewards %% 普通
                    end,
                    NewRewards = task_gain:rebuild_rewards(Rewards2, Task, FinishImm),
                    case role_gain:do(NewRewards, Role) of %% 发放奖励
                        {false, #gain{label = item}} ->
                            %% award:send(Rid, 202000, [#gain{label = item, val = [MoyaoId, 0, 1]}]),
                            {false, ?L(<<"无法完成任务，可能是你背包已满!">>)};
                        {false, #gain{label = GLabel}} -> {false, util:fbin(?L(<<"未完成任务条件[Gain:~w]">>), [GLabel])};
                        {false, #loss{label = item}} -> 
                            case rebuild_item_progess(Role, Task, Progress) of
                                {ok, NewRole} -> {false, ?L(<<"你可能缺少某些物品，不可以完成任务">>), NewRole};
                                _ -> {false, ?L(<<"你可能缺少某些物品，不可以完成任务">>)}
                            end;
                        {false, #loss{label = cn_item}} -> 
                            case rebuild_item_progess(Role, Task, Progress) of
                                {ok, NewRole} -> {false, ?L(<<"你可能缺少某些物品，不可以完成任务">>), NewRole};
                                _ -> {false, ?L(<<"你可能缺少某些物品，不可以完成任务">>)}
                            end;
                        {false, #loss{label = guild_devote, val = Val}} -> {false, util:fbin(?L(<<"需要献上~w帮会贡献才能助城主一臂之力，完成任务!">>), [Val])};
                        {false, #loss{label = LLabel}} -> {false, util:fbin(?L(<<"未完成任务条件[Loss:~w]">>), [LLabel])};
                        {ok, NewRole = #role{trigger = NewTrigger, task = TaskList2}} ->
                            add_cache_term(finish, sync_db_yes, Type, TaskId, {RoleId, SrvId, AcceptTime, util:unixtime()}),
                            Nt = del_trigger(Progress, NewTrigger), %% 清除触发器
                            Tl = lists:keydelete(TaskId, ?KEY_POS, TaskList2),
                            {ok, NewRole2} = check_item_progess(NewRole#role{task = Tl, trigger = Nt}, NewRewards),
                            campaign_task:listener(NewRole, task, Task),
                            campaign_listener:handle(task, NewRole, Task#task{attr_list = NewRewards}), %% 后台活动
                            
                            {ok, Task, NewRole2}
                    end;
                Task2 = #task{status = ?false, progress = Progress} ->
                    ?DEBUG("~w任务进度未完成", [TaskId]),
                    case rebuild_item_progess(Role, Task2, Progress) of
                        {ok, NewRole} -> {false, ?L(<<"你可能缺少某些物品，不可以完成任务">>), NewRole};
                        _ -> {false, ?L(<<"任务进度未完成，不可以完成任务">>)}
                    end
            end;
        _ ->
            {false, ?L(<<"不存在此任务">>)}
    end.

%% 放弃任务
giveup_chain(TaskParamGiveup = #task_param_giveup{task_id = TaskId}) ->
    case task_data:get_conf(TaskId) of
        {ok, TaskBase} ->
            do_giveup_chain([escort, giveup_task, giveup_misc_fire], TaskParamGiveup#task_param_giveup{task_base = TaskBase});
        {false, Reason} ->
            {false, Reason}
    end.

%% @spec giveup(TaskId, Role) -> {ok, NewRole} | {false, Reason}
%% @doc
%% <pre>
%% TaskId = integer() 任务ID
%% Role = #role{} 角色数据
%% NewRole = #role{} 新角色数据
%% Reason = binary() 失败原因
%% 放弃任务
%% </pre>
giveup(TaskId, Role = #role{id = {RoleId, SrvId}, task = TaskList, trigger = Trigger}) ->
    case lists:keyfind(TaskId, ?KEY_POS, TaskList) of
        false ->
            {false, ?L(<<"你并未接受该任务">>)};
        #task{type = Type, accept_time = AcceptTime, progress = Progress} ->
            case Type of
                ?task_type_zhux ->
                    {false, ?L(<<"主线任务不可以放弃">>)};
                ?task_type_zhix ->
                    {false, ?L(<<"支线任务不可以放弃">>)};
                _Other -> %% 日常任务放弃后计算次数，但发放奖励
                    add_cache_term(finish, sync_db_yes, Type, TaskId, {RoleId, SrvId, AcceptTime, util:unixtime()}),
                    Nt = del_trigger(Progress, Trigger), %% 清除触发器
                    Tl = lists:keydelete(TaskId, ?KEY_POS, TaskList),
                    {ok, Role#role{task = Tl, trigger = Nt}}
            end
    end.

%% @spec finish(TaskId, Role) -> {ok, NewRole} | {false, Reason}
%% @doc
%% <pre>
%% TaskId = integer() 任务ID
%% Role = #role{} 角色数据
%% NewRole = #role{} 新角色数据
%% Reason = binary() 失败原因
%% GM命令使用 立即完成任务(不检查完成条件) 
%% </pre>
finish(TaskId, Role = #role{id = {RoleId, SrvId}, task = TaskList, trigger = Trigger}) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{finish_rewards = Rewards, type = Type}} ->
            case lists:keyfind(TaskId, ?KEY_POS, TaskList) of
                false -> 
                    {false, ?L(<<"你并未接受该任务">>)};
                #task{accept_time = AcceptTime, status = _Status, progress = Progress} ->
                    NewRole2 = case role_gain:do(Rewards, Role) of %% 发放奖励
                        {false, _G} -> 
                            Role;
                        {ok, NewRole} ->
                            NewRole
                    end,
                    add_cache_term(finish, sync_db_yes, Type, TaskId, {RoleId, SrvId, AcceptTime, util:unixtime()}),
                    Nt = del_trigger(Progress, Trigger), %% 清除触发器
                    Tl = lists:keydelete(TaskId, ?KEY_POS, TaskList),
                    {ok, NewRole2#role{task = Tl, trigger = Nt}}
            end;
        _ ->
            {false, ?L(<<"不存在此任务">>)}
    end.

%% @spec reg_trigger(Conds, Progress, TaskId, Trigger, Role) -> {ok, P, Nt} | false
%% @doc
%% <pre>
%% Conds = list() of [#condition{}] 条件列表
%% Progress = P = list() of [#task_progress{}] 任务进度列表
%% TaskId = integer() 任务基础ID
%% Trigger = #trigger{} 触发器类
%% Role = #role{} 角色信息
%% Nt = #trigger{} 新的触发器
%% 注册触发器，并将任务完成条件转换成任务进度
%% </pre>
reg_trigger([], Progress, _TaskId, Trigger, _Role) -> {ok, Progress, Trigger};
reg_trigger([Cond = #task_cond{label = Label, target = Target} | T], Progress, TaskId, Trigger, Role) ->
    case task_util:cond_trg_mapping(Label) of
        false ->
            ?INFO("未处理任务条件标签:~w", [Label]),
            {false, util:fbin(?L(<<"未处理任务条件标签:~w">>), [Label])};
        TrgLabel ->
            case add_trigger(Cond, TrgLabel, Trigger, {TrgLabel, [TaskId, Target]}, Role) of
                {true, P, Nt} ->
                    reg_trigger(T, [P | Progress], TaskId, Nt, Role);
                {false, Reason} ->
                    ?ELOG(Reason),
                    reg_trigger(T, Progress, TaskId, Trigger, Role)
            end
    end.

%% @spec add_trigger(TriggerLabel, Trigger, {task_callback, CBLabel, [TaskId, Target]})
%% @doc
%% <pre>
%% TriggerLabel = term() 触发器标签,也就是事件类型，该事情发生触发注册到该事情的所有回调函数
%% Trigger = #trigger{} 角色触发器,记录了所有事件及每个事件的回调函数
%% CBFunc = term() 回调方法
%% TaskId = integer() 任务ID
%% Target 条件Target
%% Role = #role{} 角色信息
%% 为触发器增加回调函数
%% </pre>
add_trigger(Cond = #task_cond{target = Target}, TrgLabel, Trigger, {CBFunc, [TaskId, Target]}, Role) ->
    try task_prg_fty:create(0, Cond, Role) of
        NewP = #task_progress{target = NewTarget} ->
            case role_trigger:add(TrgLabel, Trigger, {task_callback, CBFunc, [TaskId, NewTarget]}) of 
                {ok, Id, NewTrigger} ->
                    {true, NewP#task_progress{id = Id}, NewTrigger};
                _Other ->
                    {false, ?L(<<"任务系统添加触发器出错">>)}
            end
    catch
        _:_ErrMsg ->
            ?DEBUG("创建进度信息出错:ErrMsg:~w, TrgLabel~w, Cond:~w", [_ErrMsg, TrgLabel, Cond]),
            {false, ?L(<<"任务系统添加触发器出错">>)}
    end.

%% @spec del_trigger(PrgList, Trigger) -> NewTrigger
%% @doc
%% <pre>
%% PrgList = list() of #task_progress{} 进度列表
%% Trigger = #trigger{} 进度信息
%% NewTrigger = #trigger{} 新的进度信息
%% 清除任务进度中梆定的触发器
%% </pre>
del_trigger([], Trigger) -> Trigger;
del_trigger([#task_progress{id = Id, trg_label = Label} | T], Trigger) ->
    case role_trigger:del(Label, Trigger, Id) of
        {ok, Nt} -> del_trigger(T, Nt);
        _ -> del_trigger(T, Trigger)
    end.

%% GM命令
%% 完成任务链
finish_link(Role, []) ->
    Role;
finish_link(Role = #role{link = #link{conn_pid = ConnPid}}, [TaskId | T]) ->
    task_rpc:send_del_acceptable_task(ConnPid, TaskId),  %% 送发删除可接任务消息
    {ok, #task_base{type = Type}} = task_data:get_conf(TaskId),
    NewRole = finish_link_task(Role, TaskId, Type),
    {ok, #task_base{prev = PrevTaskList}} = task_data:get_conf(TaskId),
    NewRole2 = finish_link(NewRole, PrevTaskList),
    finish_link(NewRole2, T).

%% @spec check_finish_cond(CondList, Role, ProgList) -> {false, Reason} | {true, Progress}
%% @doc
%% <pre>
%% CondList = list() of #task_cond{} 条件列表
%% Role = #role{} 角色
%% Reason = term() 错误信息
%% 检查是否符合条件
%% </pre>
check_finish_cond([Cond = #task_cond{msg = Msg, label = Label} | T], Role, ProgList) ->
    Progress = #task_progress{status = Status} = task_prg_fty:create(0, Cond, Role),
    case Status =:= 1 of
        true ->
            check_finish_cond(T, Role, [Progress | ProgList]);
        false ->
            case Msg =:= <<>> of
                true ->
                    {false, util:fbin(?L(<<"条件不足:label:~w">>), [Label])};
                false ->
                    {false, Msg}
            end
    end;
check_finish_cond([], _Role, ProgList) ->
    {true, ProgList}.

%% @spec refresh_acceptable_task(by_type, Role, PrevTaskId) -> AcceptableTaskIds
%% @doc
%% <pre>
%% Role = #role{} 角色记录
%% PrevTaskId = 完成的任务ID(刷新以该任务为前置任务的新的可接任务) 已经不再使用了
%% AcceptableTaskIds = [integer()] 可接任务ID
%% 更新以该任务为前置任务的新的可接任务
%% </pre>
refresh_acceptable_task(by_type, Role = #role{lev = Lev}, ?task_type_zhux, _PrevTaskId) ->
    PrevTaskIds = data_all_task(Lev),
    {ok, FinishZhux} = role:get_dict(task_finish_zhux),
    {ok, AcceptedZhux} = role:get_dict(task_accepted_zhux),
    Opt = [type, career, finish_one, accepted, prev, cond_accept],
    task_filter:filter(Opt, Role, PrevTaskIds, #task_fparam{type = ?task_type_zhux, is_ring = ?false, finish_task_list = FinishZhux, accept_task_list = AcceptedZhux});

refresh_acceptable_task(by_type, Role = #role{lev = Lev}, ?task_type_zhix, _PrevTaskId) ->
    PrevTaskIds = data_all_task(Lev),
    {ok, FinishZhix} = role:get_dict(task_finish_zhix),
    {ok, AcceptedZhix} = role:get_dict(task_accepted_zhix),
    Opt = [type, career, finish_one, accepted, prev, cond_accept, lev_special],
    NewFinishZhix = case role:get_dict(task_finish_zhux) of
        {ok, Data} -> FinishZhix ++ Data;
        _ -> FinishZhix
    end,
    task_filter:filter(Opt, Role, PrevTaskIds, #task_fparam{type = ?task_type_zhix, is_ring = ?false, finish_task_list = NewFinishZhix, accept_task_list = AcceptedZhix});

refresh_acceptable_task(by_type, _Role, _, _PrevTaskId) -> %% 特殊任务
    [].

%% 刷新指定类型的可接任务
refresh_acceptable_task(ref_and_send, Role = #role{career = Career, link = #link{conn_pid = ConnPid}}, Type) ->
    NewAcceptable = task:refresh_acceptable_task(by_type, Role, Type, 1),
    {ok, OldAcceptable} = task:get_dict(acceptable, Type),
    AddAcceptable = NewAcceptable -- OldAcceptable,
    DelAcceptable = OldAcceptable -- NewAcceptable,
    case length(AddAcceptable) > 0 of
        true -> %% 有新的可接任务
            task_rpc:send_batch_npc_status(acceptable, ConnPid, AddAcceptable, 1, []), %% 更新Npc状态
            task_rpc:send_add_acceptable_tasks(ConnPid, Career, AddAcceptable), %% 推送可接任务
            task:add_cache(acceptable, Type, AddAcceptable);
        false -> ignore 
    end,
    case length(DelAcceptable) > 0 of
        true ->
            del_acceptable(ConnPid, DelAcceptable);
        false -> ignore
    end,
    ok.

%% 重新计算可接任务，并把增量通知客户端
lev_up_fire(Role = #role{id = {_Rid, _Srvid}, lev = Lev, career = Career, link = #link{conn_pid = ConnPid}}) ->
    LevTaskList = task_data:lev(Lev),
    TypeList = distinct_task_type(LevTaskList, []),
    AcceptableZhux = case lists:member(?task_type_zhux, TypeList) of
        true ->
            {ok, FinishZhux} = role:get_dict(task_finish_zhux),
            {ok, AcceptedZhux} = role:get_dict(task_accepted_zhux),
            {ok, Zhux} = role:get_dict(task_acceptable_zhux),
            Opt0 = [type, career, finish_one, accepted, prev, cond_accept],
            List0 = task_filter:filter(Opt0, Role, LevTaskList, #task_fparam{type = ?task_type_zhux, is_ring = ?false, finish_task_list = FinishZhux, accept_task_list = AcceptedZhux}),
            case (List0 -- Zhux) of
                [] -> skip;
                L0 -> add_cache(acceptable, ?task_type_zhux, L0)
            end,
            List0;
        false ->
            [] 
    end,
    AcceptableZhix = case lists:member(?task_type_zhix, TypeList) of
        true ->
            {ok, FinishZhix} = role:get_dict(task_finish_zhix),
            {ok, AcceptedZhix} = role:get_dict(task_accepted_zhix),
            {ok, Zhix} = role:get_dict(task_acceptable_zhix),
            Opt1 = [type, career, finish_one, accepted, prev, cond_accept, lev_special],
            NewFinishZhix = case role:get_dict(task_finish_zhux) of
                {ok, Data} -> FinishZhix ++ Data;
                _ -> FinishZhix
            end,
            List1 = task_filter:filter(Opt1, Role, LevTaskList, #task_fparam{type = ?task_type_zhix, is_ring = ?false, finish_task_list = NewFinishZhix, accept_task_list = AcceptedZhix}),
            case (List1 -- Zhix) of
                [] -> skip;
                L1 -> add_cache(acceptable, ?task_type_zhix, L1)
            end,
            List1;
        false ->
            [] 
    end,

    Add = AcceptableZhux ++ AcceptableZhix ,
    case length(Add) > 0 of
        true ->
            ?DEBUG("更新的任务： ~w", [Add]),
            task_rpc:send_add_acceptable_tasks(ConnPid, Career, Add),
            task_rpc:send_batch_npc_status(acceptable, ConnPid, Add, 1, []);
        false ->
            null
    end.

%% 删除可接任务
del_acceptable(_ConnPid, []) -> ok;
del_acceptable(ConnPid, [TaskId | T]) ->
    {ok, #task_base{type = Type, npc_accept = NpcAccept}} = task_data:get_conf(TaskId),
    delete_cache(acceptable, Type, [TaskId]),
    task_rpc:send_del_acceptable_task(ConnPid, TaskId),  %% 送发删除可接任务消息
    task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 0}]),
    del_acceptable(ConnPid, T).

%% 获取任务ID列表中的任务类型列表
distinct_task_type([TaskId | T], TypeList) ->
    {ok, #task_base{type = Type}} = task_data:get_conf(TaskId),
    case lists:member(Type, TypeList) of
        false ->
            distinct_task_type(T, [Type | TypeList]);
        true ->
            distinct_task_type(T, TypeList)
    end;
distinct_task_type([], TypeList) ->
    TypeList.

%% @get_task_base_by_prev(TaskId) -> TaskIdList
%% @doc
%% 当任务完成后,更新该任务为前置任务的可接任务列表
get_task_base_by_prev([TaskId | T], PrevTaskId) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{prev = PrevIdList}} ->
            case lists:member(PrevTaskId, PrevIdList) of
                true -> 
                    [TaskId | get_task_base_by_prev(T, PrevTaskId)];
                false ->
                    get_task_base_by_prev(T, PrevTaskId)
            end;
        {false, _Reason} ->
            get_task_base_by_prev(T, PrevTaskId)
    end;
get_task_base_by_prev([], _PrevTaskId) ->
    [].

%% @spec is_finish_task(TaskIdList, Type) -> false | true
%% @doc
%% <pre>
%% TaskIdList = list() of integer() 任务ID列表
%% Type = integer() 任务类型
%% 判断任务是否为全部已完成
%% </pre>
is_finish_task([TaskId | T], Type) ->
    {ok, Data} = case Type of
        ?task_type_zhux ->
            role:get_dict(task_finish_zhux);
        ?task_type_zhix ->
            {ok, DataZhux} = role:get_dict(task_finish_zhux),
            {ok, DataZhix} = role:get_dict(task_finish_zhix),
            {ok, DataZhux ++ DataZhix};
        ?task_type_star_dun ->
            {ok, DataZhux} = role:get_dict(task_finish_zhux),
            {ok, DataZhix} = role:get_dict(task_finish_zhix),
            {ok, DataStar} = role:get_dict(task_finish_stardun),
            {ok, DataZhux++DataZhix++DataStar}
    end,
    case lists:keyfind(TaskId, #task_finish.task_id, Data) of
        false ->
            false;
        _Other ->
            is_finish_task(T, Type)
    end;
is_finish_task([], _Type) ->
    true.

%% @spec combat_over(Winner, Loser) -> ok
%% @doc
%% <pre>
%% Winner = [#fighter{}] 胜方列表
%% Loser = [#fighter{}] 败方列表
%% </pre>
combat_over(Winner, Loser) ->
    LoserIdList = [FighterId || #fighter{rid = FighterId, type = Type} <- Loser, Type =:= ?fighter_type_npc],
    case length(LoserIdList) > 0 of
        true ->
            WinnerList = [Fighter || Fighter = #fighter{type = Type} <- Winner, Type =:= ?fighter_type_role],
            case length(WinnerList) > 0 of
                true ->
                    do_combat_over(WinnerList, LoserIdList);
                false ->
                    ok
            end;
        false ->
            ok
    end.

%% 任务掉落
%% @spec drop(Role, NpcBaseId) -> {NpcBaseId, ItemBaseId} | {false, Reason}
drop(_Role = #role{task = AccetedTask, trigger = #trigger{get_item = GetItemCb, special_event = SpecialCb}}, NpcBaseId) ->
    case task_data_drop:get_drop(by_npc, NpcBaseId) of
        {ok, TaskDrop = #task_drop{item_id = ?task_pet_base_id}} ->
            case filter_drop(special_event, SpecialCb, NpcBaseId) of
                {true, TaskId, TriggerId} ->
                    case drop(check_item, [{TaskId, TriggerId}], AccetedTask, TaskDrop) of
                        ok -> 
                            %% catch role:apply(async, RolePid, {fun apply_drop_pet/2, [124003]}),
                            {NpcBaseId, ?task_pet_base_id};
                        false -> {false, <<"">>}
                    end;
                false -> {false, <<"">>}
            end;
        {ok, TaskDrop = #task_drop{item_id = ItemBaseId}} ->
            case item_data:get(ItemBaseId) of
                {ok, #item_base{type = ItemType}} ->
                    case ItemType =:= ?item_task of
                        true ->
                            DropTaskList = filter_drop(get_item, GetItemCb, ItemBaseId),
                            case length(DropTaskList) > 0 of
                                true ->
                                    case drop(check_item, DropTaskList, AccetedTask, TaskDrop) of
                                        ok ->
                                            {NpcBaseId, ItemBaseId};
                                        false ->
                                            {false, <<"">>}
                                    end;
                                false ->
                                    {false, ?L(<<"没有掉落">>)}
                            end;
                        false ->
                            {false, ?L(<<"不是任务物品">>)}
                    end;
                {false, Reason} ->
                    {false, Reason}
            end;
        {false, Reason} ->
            {false, Reason}
    end.

%% 检查任务物品是否掉落
drop(check_item, [{TaskId, TriggerId} | T], TaskList, TaskDrop = #task_drop{prob = Prob}) ->
    case lists:keyfind(TaskId, #task.task_id, TaskList) of
        #task{status = TkStatus, progress = Progress} ->
            case TkStatus =:= 0 of
                true ->
                    case lists:keyfind(TriggerId, #task_progress.id, Progress) of
                        #task_progress{status = Status} ->
                            case Status =:= 0 of
                                true ->
                                    Domain = util:rand(1, 100),
                                    case Domain =< Prob of
                                        true ->
                                            ok;
                                        false ->
                                            drop(check_item, T, TaskList, TaskDrop)
                                    end;
                                false ->
                                    drop(check_item, T, TaskList, TaskDrop)
                            end;
                        false ->
                            drop(check_item, T, TaskList, TaskDrop)
                    end;
                false ->
                    drop(check_item, T, TaskList, TaskDrop)
            end;
        false ->
            drop(check_item, T, TaskList, TaskDrop)
    end;
drop(check_item, [], _TaskList, _TaskDrop) ->
    false.

%% 获取触发器中指定类型的任务
filter_drop(get_item, [{_Id, {Module, _F, Args}} | T], ItemBaseId) ->
    case Module =:= task_callback of
        true ->
            [TriggerId, TaskId, TrItemBaseId] = Args,
            case TrItemBaseId =:= ItemBaseId of
                true ->
                    [{TaskId, TriggerId} | filter_drop(get_item, T, ItemBaseId)];
                false ->
                    filter_drop(get_item, T, ItemBaseId)
            end;
        false ->
            filter_drop(get_item, T, ItemBaseId)
    end;
filter_drop(get_item, [], _ItemBaseId) ->
    [];
filter_drop(special_event, [{_Id, {Module, _F, Args}} | T], ItemBaseId) ->
    case Module =:= task_callback of
        true ->
            [TriggerId, TaskId, Key] = Args,
            case Key =:= 1050 of
                true -> {true, TaskId, TriggerId};
                false ->
                    filter_drop(special_event, T, ItemBaseId)
            end;
        false ->
            filter_drop(special_event, T, ItemBaseId)
    end;
filter_drop(special_event, [], _ItemBaseId) -> false.

%% 根据已接任务进度重建确发器
rebuild_trigger(Role) ->
    NewRole = rebuild_trigger_del(Role),
    NewRole2 = rebuild_trigger_create(NewRole),
    NewRole2.

%% 任务奖励:通过不同概率获得不同的物品
task_gain_prog({Key, Lev}) ->
    case task_util:get_task_gain(Key, Lev) of
        {ok, #task_gain{list = List}} ->
            SumList = [Domain || {_ItemBaseId, Domain} <- List],
            Random = util:rand(1, lists:sum(SumList)),
            do_task_gain_prog(List, Random);
        _ -> {false, ?L(<<"没有产出">>)}
    end.


%%----------------------------------------------------
%% 二级函数
%%----------------------------------------------------
init_cache(Role = #role{id = {Rid, SrvId}, lev = _Lev, task = AccetedTask}) ->
    {AcceptedZhux, AcceptedZhix, AcceptedStarDun} = sort_task(accepted, AccetedTask, {[], [], []}),
        OldZzxFinishTaskList = case role:get_dict({init_task_log, Rid, SrvId}) of
            {ok, Data2} when Data2 =/= undefined -> Data2;
            _ ->
                ?ERR("角色读不到进程字典数据task_log[RoleId:~w, SrvId:~w]", [Rid, SrvId]),
                task_dao_log:get_log(Rid, SrvId)
        end,
        ZzxFinishTaskList = filter_nonexist_task_log(OldZzxFinishTaskList),
    OldDailyFinishTaskList = case role:get_dict({init_task_daily_log, Rid, SrvId}) of
        {ok, Data3} when Data3 =/= undefined -> Data3;
        _ ->
            ?ERR("角色读不到进程字典数据task_log[RoleId:~w, SrvId:~w]", [Rid, SrvId]),
            task_dao_log:get_daily_log(Rid, SrvId)
    end,
    _DailyFinishTaskList = filter_nonexist_task_log(OldDailyFinishTaskList),
    {FinishZhux, FinishZhix, FinishStarDun} = sort_task(finish_zzx, ZzxFinishTaskList, {[], [], []}),
    init_cache_zhux(?task_type_zhux, Role, {AcceptedZhux, FinishZhux}),
    init_cache_zhix(?task_type_zhix, Role, {AcceptedZhix, FinishZhix}),
    init_cache_stardun(?task_type_star_dun, Role, {AcceptedStarDun, FinishStarDun}).

%% 初始化主线任务 
init_cache_zhux(?task_type_zhux, Role = #role{lev = Lev}, {AcceptedZhux, FinishZhux}) ->
    role:put_dict(task_accepted_zhux, AcceptedZhux),
    role:put_dict(task_finish_zhux, FinishZhux),
    AllTaskIds = data_all_task(Lev),
    Opt = [type, career, finish_one, accepted, prev, cond_accept],
    AcceptableTaskidList = task_filter:filter(Opt, Role, AllTaskIds, #task_fparam{type = ?task_type_zhux, is_ring = ?false, finish_task_list = FinishZhux, accept_task_list = AcceptedZhux}),
    role:put_dict(task_acceptable_zhux, AcceptableTaskidList).

%% 初始化支线任务 
init_cache_zhix(?task_type_zhix, Role = #role{lev = Lev}, {AcceptedZhix, FinishZhix}) ->
    role:put_dict(task_accepted_zhix, AcceptedZhix),
    role:put_dict(task_finish_zhix, FinishZhix),
    AllTaskIds = data_all_task(Lev),
    Opt = [type, career, finish_one, accepted, prev, cond_accept, lev_special],
    NewFinishZhix = case role:get_dict(task_finish_zhux) of
        {ok, Data} -> FinishZhix ++ Data;
        _ -> FinishZhix
    end,
    AcceptableTaskidList = task_filter:filter(Opt, Role, AllTaskIds, #task_fparam{type = ?task_type_zhix, is_ring = ?false, finish_task_list = NewFinishZhix, accept_task_list = AcceptedZhix}),
    role:put_dict(task_acceptable_zhix, AcceptableTaskidList).

%% 初始化星级副本任务 
init_cache_stardun(?task_type_star_dun, #role{}, {AcceptedStarDun, FinishStarDun}) ->
    role:put_dict(task_accepted_stardun, AcceptedStarDun),
    role:put_dict(task_finish_stardun, FinishStarDun).

%% 分类已接任务
sort_task(accepted, [#task{task_id = TaskId, type = Type} | T], {TypeZhux, TypeZhix, TypeStarDun}) ->
    case Type of
        ?task_type_zhux ->
            sort_task(accepted, T, {[TaskId | TypeZhux], TypeZhix, TypeStarDun});
        ?task_type_zhix ->
            sort_task(accepted, T, {TypeZhux, [TaskId | TypeZhix], TypeStarDun});
        ?task_type_star_dun ->
            sort_task(accepted, T, {TypeZhux, TypeZhix, [TaskId | TypeStarDun]});
         _ ->
            sort_task(accepted, T, {TypeZhux, TypeZhix, TypeStarDun})
           
    end;
sort_task(accepted, [], {TypeZhux, TypeZhix, TypeStarDun}) ->
    {TypeZhux, TypeZhix, TypeStarDun};

%% 分类主支线任务
sort_task(finish_zzx, [[_RoleId, _SrvId, TaskId, ?task_type_zhux, AcceptTime, FinishTime] | T], {FinishZhux, FinishZhix, FinishStarDun}) ->
    TaskFinish = #task_finish{task_id = TaskId, type = ?task_type_zhux, accept_time = AcceptTime, finish_time = FinishTime, finish_num = 1},
    sort_task(finish_zzx, T, {[TaskFinish | FinishZhux], FinishZhix, FinishStarDun});
sort_task(finish_zzx, [[_RoleId, _SrvId, TaskId, ?task_type_zhix, AcceptTime, FinishTime] | T], {FinishZhux, FinishZhix, FinishStarDun}) ->
    TaskFinish = #task_finish{task_id = TaskId, type = ?task_type_zhix, accept_time = AcceptTime, finish_time = FinishTime, finish_num = 1},
    sort_task(finish_zzx, T, {FinishZhux, [TaskFinish | FinishZhix], FinishStarDun});
sort_task(finish_zzx, [[_RoleId, _SrvId, TaskId, ?task_type_star_dun, AcceptTime, FinishTime] | T], {FinishZhux, FinishZhix, FinishStarDun}) ->
    TaskFinish = #task_finish{task_id = TaskId, type = ?task_type_star_dun, accept_time = AcceptTime, finish_time = FinishTime, finish_num = 1},
    sort_task(finish_zzx, T, {FinishZhux, FinishZhix, [TaskFinish | FinishStarDun]});
sort_task(finish_zzx, [], {FinishZhux, FinishZhix, FinishStarDun}) ->
    {FinishZhux, FinishZhix, FinishStarDun}.

%% @spec check_accep_cond(Role, TaskBase) -> {false, Reason} | true
%% <pre>
%% Role = #role{} 角色
%% TaskBase = #task_base{} 基础任务信息
%% Reason = binary() 失败原因
%% 检查是否合符条件
%% </pre>
check_accep_cond(Role, TaskBase) ->
    Checklist = [career, lev, prev, cond_accept],
    check_accep_cond(all, Checklist, Role, TaskBase).

check_accep_cond(all, [Opt | T], Role, TaskBase) ->
    case check_accep_cond(Opt, Role, TaskBase) of
        true ->
            check_accep_cond(all, T, Role, TaskBase);
        {false, Reason} ->
            %% notice:inform(Reason),  %% TODO:正式版要去掉
            {false, Reason}
    end;
check_accep_cond(all, [], _Role, _TaskBase) ->
    true.

check_accep_cond(career, _Role = #role{career = RoleCareer}, _TaskBase = #task_base{career = Career}) ->
    case Career =/= undefined
            andalso Career =/= 9 %% 不限职业
            andalso Career =/= RoleCareer of
        true ->
            {false, ?L(<<"非本职业任务">>)};
        false ->
            true
    end;

check_accep_cond(lev, _Role = #role{lev = RoleLev}, _TaskBase = #task_base{lev = Lev}) ->
    case Lev =/= undefined andalso Lev > RoleLev of
        true ->
            {false, ?L(<<"等级不够">>)};
        false ->
            true
    end;

check_accep_cond(prev, _Role, _TaskBase = #task_base{type = Type, prev = Prev}) ->
    case Prev =/= undefined andalso is_list(Prev) andalso length(Prev) > 0 of
        true ->
            case is_finish_task(Prev, Type) of
                false ->
                    {false, ?L(<<"前置任务未完成">>)};
                true ->
                    true
            end;
        false ->
            true
    end;

check_accep_cond(cond_accept, Role, _TaskBase = #task_base{cond_accept = CondAccept}) ->
    case check_finish_cond(CondAccept, Role, []) of
        {true, _} ->
            true;
        {false, Msg} ->
            {false, Msg}
    end.

%% 增加完全任务,如果已有记录，那么增次数
add_cache_term(finish, SyncDb, ?task_type_zhux, TaskId, {RoleId, SrvId, AcceptTime, FinishTime}) ->
    {ok, Data} = role:get_dict(task_finish_zhux),
    case lists:keyfind(TaskId, #task_finish.task_id, Data) of
        #task_finish{} -> skip;
        false ->
            case SyncDb =:= sync_db_yes of
                true -> task_dao_log:insert_log(RoleId, SrvId, TaskId, ?task_type_zhux, AcceptTime, FinishTime);
                false -> skip
            end,
            role:put_dict(task_finish_zhux, [#task_finish{task_id = TaskId, type = ?task_type_zhux, accept_time = AcceptTime, finish_time = FinishTime, finish_num = 1} | Data])
    end;
add_cache_term(finish, SyncDb, ?task_type_zhix, TaskId, {RoleId, SrvId, AcceptTime, FinishTime}) ->
    {ok, Data} = role:get_dict(task_finish_zhix),
    case lists:keyfind(TaskId, #task_finish.task_id, Data) of
        #task_finish{} -> skip;
        false ->
            case SyncDb =:= sync_db_yes of
                true -> catch task_dao_log:insert_log(RoleId, SrvId, TaskId, ?task_type_zhix, AcceptTime, FinishTime);
                false -> skip
            end,
            role:put_dict(task_finish_zhix, [#task_finish{task_id = TaskId, type = ?task_type_zhix, accept_time = AcceptTime, finish_time = FinishTime, finish_num = 1}| Data])
    end;

add_cache_term(finish, SyncDb, ?task_type_star_dun, TaskId, {RoleId, SrvId, AcceptTime, FinishTime}) ->
    {ok, Data} = role:get_dict(task_finish_stardun),
    case lists:keyfind(TaskId, #task_finish.task_id, Data) of
        #task_finish{} -> skip;
        false ->
            case SyncDb =:= sync_db_yes of
                true -> catch task_dao_log:insert_log(RoleId, SrvId, TaskId, ?task_type_star_dun, AcceptTime, FinishTime);
                false -> skip
            end,
            role:put_dict(task_finish_stardun, [#task_finish{task_id = TaskId, type = ?task_type_star_dun, accept_time = AcceptTime, finish_time = FinishTime, finish_num = 1}| Data])
    end;

add_cache_term(finish, _SyncDb, ?task_type_spec, _TaskId, {_RoleId, _SrvId, _AcceptTime, _FinishTime}) ->
    skip.

%% 增加已接任务
add_cache(acceptable, ?task_type_zhux, AddList) ->
    {ok, Data} = role:get_dict(task_acceptable_zhux),
    NewData = Data ++ AddList,
    role:put_dict(task_acceptable_zhux, NewData);
add_cache(acceptable, ?task_type_zhix, AddList) ->
    {ok, Data} = role:get_dict(task_acceptable_zhix),
    NewData = Data ++ AddList,
    role:put_dict(task_acceptable_zhix, NewData);
add_cache(acceptable, ?task_type_fb, AddList) ->
    {ok, Data} = role:get_dict(task_acceptable_fb),
    NewData = Data ++ AddList,
    role:put_dict(task_acceptable_fb, NewData);

%% 增加已接任务
add_cache(accepted, ?task_type_zhux, AddList) ->
    {ok, Data} = role:get_dict(task_accepted_zhux),
    NewData = Data ++ AddList,
    role:put_dict(task_accepted_zhux, NewData);
add_cache(accepted, ?task_type_zhix, AddList) ->
    {ok, Data} = role:get_dict(task_accepted_zhix),
    NewData = Data ++ AddList,
    role:put_dict(task_accepted_zhix, NewData);
add_cache(accepted, ?task_type_star_dun, AddList) ->
    {ok, Data} = role:get_dict(task_accepted_stardun),
    NewData = Data ++ AddList,
    role:put_dict(task_accepted_stardun, NewData).


%% 删除缓存信息
%% Key = acceptable | finish | accepted
%% Type = integer() 任务类型
%% DelVals = [integer()] 被删除的信息
delete_cache(acceptable, ?task_type_zhux, DelList) ->
    case role:get_dict(task_acceptable_zhux) of
        {ok, undefined} ->
            ok;
        {ok, Data} ->
            NewData = Data -- DelList,
            role:put_dict(task_acceptable_zhux, NewData)
    end;       
delete_cache(acceptable, ?task_type_zhix, DelList) ->
    {ok, Data} = role:get_dict(task_acceptable_zhix),
    NewData = Data -- DelList,
    role:put_dict(task_acceptable_zhix, NewData);
delete_cache(acceptable, _, _) -> ok;

%% 删除已接任务
delete_cache(accepted, ?task_type_zhux, DelList) ->
    {ok, Data} = role:get_dict(task_accepted_zhux),
    NewData = Data -- DelList,
    role:put_dict(task_accepted_zhux, NewData);
delete_cache(accepted, ?task_type_zhix, DelList) ->
    {ok, Data} = role:get_dict(task_accepted_zhix),
    NewData = Data -- DelList,
    role:put_dict(task_accepted_zhix, NewData);
delete_cache(accepted, ?task_type_star_dun, DelList) ->
    {ok, Data} = role:get_dict(task_accepted_stardun),
    NewData = Data -- DelList,
    role:put_dict(task_accepted_stardun, NewData);

delete_cache(accepted, _, _) ->
    ok.


get_dict(acceptable, TaskType) ->
    case TaskType of
        ?task_type_zhux ->
            role:get_dict(task_acceptable_zhux);
        ?task_type_zhix ->
            role:get_dict(task_acceptable_zhix);
        _ ->
            {ok, []}
    end;
get_dict(finish, TaskType) ->
    case TaskType of
        ?task_type_zhux ->
            role:get_dict(task_finish_zhux);
        ?task_type_zhix ->
            role:get_dict(task_finish_zhix);
        ?task_type_star_dun ->
            role:get_dict(task_finish_stardun);
        _ ->
            {ok, []}
    end;
get_dict(accepted, TaskType) ->
    case TaskType of
        ?task_type_zhux ->
            role:get_dict(task_accepted_zhux);
        ?task_type_zhix ->
            role:get_dict(task_accepted_zhix);
        ?task_type_star_dun ->
            role:get_dict(task_accepted_stardun);
        _ ->
            {ok, []}
    end.

update_cache(Key, Val) ->
    role:put_dict(Key, Val).

%% 获取任务完成次数(非日常任务)
get_count(log, TaskId) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{type = Type}} ->
            Tasks = case Type of
                ?task_type_zhux -> get_dict(task_finish_zhux);
                ?task_type_zhix -> get_dict(task_finish_zhix)
            end,
            L = [Task || Task <- Tasks, Task =:= TaskId],
            length(L);
        _ -> 0
    end;

%% 获取任务完成次数(日常任务)
get_count(log_daily, TaskId) ->
    get_count(log, TaskId).

get_dict(Key) ->
    {ok, Data} = role:get_dict(Key),
    Data.

%% @spec do_combat_over([#fighter{}], [integer()]) -> ok
%% 战斗完成处理任务物品掉落
do_combat_over([#fighter{pid = Pid, rid = _RoleId, srv_id = _SrvId} | T], LoserIdList) ->
    case role:apply(sync, Pid, {fun winner_combat_over/2, [LoserIdList]}) of
        ok ->
            do_combat_over(T, LoserIdList);
        {false, _Reason} ->
            ?DEBUG("战斗完成处理任务物品掉落出错了[RoleId:~w, SrvId:~w]:~w", [_RoleId, _SrvId, _Reason]),
            do_combat_over(T, LoserIdList);
        Other ->
            ?ELOG("战斗完成处理任务物品掉落有误:~w", [Other]),
            do_combat_over(T, LoserIdList)

    end;
do_combat_over([], _LoserIdList) ->
    ok.

%% 胜方获取任务物品
winner_combat_over(Role, [NpcBaseId | T]) ->
    case catch task:drop(Role, NpcBaseId) of
        {NpcBaseId, ItemBaseId} ->
            case storage:make_and_add_fresh(ItemBaseId, 1, 1, Role) of
                {ok, NewRole, _} ->
                    NewRole2 = role_listener:get_item(NewRole, #item{base_id = ItemBaseId, quantity = 1}),
                    winner_combat_over(NewRole2, T);
                _Any ->
                    winner_combat_over(Role, T)
            end;
        _Other ->
            winner_combat_over(Role, T)
    end;
winner_combat_over(Role, []) ->
    {ok, ok, Role}.

%% 删除过期数据
delete_expire_data(#role{id = {RoleId, SrvId}}) ->
    TodayTime = task_util:unixtime(today),
    task_dao_log:delete_daily_log(RoleId, SrvId, TodayTime).

%% 零点后重新加载任务
reload(#role{id = {_RoleId, _SrvId}, lev = _Lev, career = _Career, task = _AccetedTask, link = #link{conn_pid = _ConnPid}}) ->
    {ok}.

%% @spec finish_link_task(Role, TaskId) -> NewRole
%% GM命令完成指定任务, 增加db日志，增加缓存信息
%% 只处理主支线任务
finish_link_task(Role = #role{id = {RoleId, SrvId}}, TaskId, Type) when Type =:= ?task_type_zhux orelse Type =:= ?task_type_zhix ->
    add_cache_term(finish, sync_db_yes, Type, TaskId, {RoleId, SrvId, util:unixtime(), util:unixtime()}),
    Role;
finish_link_task(Role, _TaskId, _Type) ->
    Role.

%% 删除任务相关的触发回调函数
rebuild_trigger_del(Role = #role{trigger = Trigger}) ->
    Size = record_info(size, trigger),
    NewTrigger = rebuild_trigger_del(Size, Trigger),
    Role#role{trigger = NewTrigger}.

%% 循环删除
rebuild_trigger_del(Index, Trigger) when Index < 3 ->
    Trigger;
rebuild_trigger_del(Index, Trigger) ->
    Elem = element(Index, Trigger),
    NewElem = del_task_trigger(Elem),
    NewTrigger = setelement(Index, Trigger, NewElem),
    rebuild_trigger_del(Index - 1, NewTrigger).
del_task_trigger([]) -> [];
del_task_trigger([{_TriggerId, {task_callback, _F, _A}} | T]) ->
    del_task_trigger(T);
del_task_trigger([Call | T]) ->
    [Call | del_task_trigger(T)].

%% 根据任务进度信息重建触发器
rebuild_trigger_create(Role = #role{task = TaskList, trigger = Trigger}) ->
    NewTrigger = rebuild_trigger_task(TaskList, Trigger),
    Role#role{trigger = NewTrigger}.
%% 任务
rebuild_trigger_task([#task{task_id = TaskId, progress = Progress} | T], Trigger) ->
    %% 充值任务要特殊处理
    NewTrigger = rebuild_trigger_progress(Progress, TaskId, Trigger),
    rebuild_trigger_task(T, NewTrigger);
rebuild_trigger_task([], Trigger) ->
    Trigger.
%% 进度
rebuild_trigger_progress([Progress = #task_progress{} | T], TaskId, Trigger) ->
    NewTrigger = rebuild_trigger_cell(Progress, TaskId, Trigger),
    rebuild_trigger_progress(T, TaskId, NewTrigger);
rebuild_trigger_progress([], _TaskId, Trigger) ->
    Trigger.

%% 已完成
rebuild_trigger_cell(#task_progress{status = 1}, _TaskId, Trigger) ->
    Trigger;
rebuild_trigger_cell(#task_progress{id = Id, trg_label = TrgLabel, target = Target, status = 0}, TaskId, Trigger = #trigger{next_id = NextId}) ->
    Trg = {Id, {task_callback, TrgLabel, [Id, TaskId, Target]}},
    NewNextId = case Id >= NextId of
        true -> Id + 1;
        false -> NextId
    end,
    Fields = record_info(fields, trigger),
    case index(TrgLabel, Fields) of
        not_find -> Trigger;
        Index ->
            TriggerList = element((Index + 1), Trigger),
            NewTrigger = setelement((Index + 1), Trigger, [Trg | TriggerList]),
            NewTrigger#trigger{next_id = NewNextId}
    end;
rebuild_trigger_cell(_P, _TaskId, T) ->
    ?DEBUG("[任务系统]重建触发器时没有找到匹配的进程[~w]", [_P]),
    T.
index(TrgLabel, [Field | _T]) when TrgLabel =:= Field ->
    1;
index(TrgLabel, [_Field | T]) ->
    1 + index(TrgLabel, T);
index(_TrgLabel, []) ->
    ?DEBUG("[任务系统]重建触发器时没有找到匹配的标识符[~w]", [_TrgLabel]),
    not_find.

%% 任务奖励
do_task_gain_prog([{ItemBaseId, Domain} | T], Random) ->
    case Domain >= Random of
        true -> ItemBaseId;
        false -> do_task_gain_prog(T, Random - Domain)
    end;
do_task_gain_prog([], _Random) ->
    {false, ?L(<<"没有产出">>)}.

%% 针对多少收集任务收集同一种物品的情况
check_item_progess(Role = #role{task = TaskList}, Rewards) ->
    case check_reward_item(Rewards) of
        [] -> {ok, Role};
        ItemList -> recheck_item_progess(Role, TaskList, ItemList)
    end.

recheck_item_progess(Role, [], _ItemList) -> {ok, Role};
recheck_item_progess(Role, [Task = #task{progress = ProgList} | T], ItemList) ->
    case check_item_progess_getitem(ProgList) of
        [] -> recheck_item_progess(Role, T, ItemList);
        ItemList2 ->
            case ItemList2 -- ItemList of
                ItemList2 -> recheck_item_progess(Role, T, ItemList);
                _Other ->
                    case rebuild_item_progess(Role, Task, ProgList) of
                        {ok, NewRole} -> recheck_item_progess(NewRole, T, ItemList);
                        _ -> recheck_item_progess(Role, T, ItemList)
                    end
            end
    end.

%% 进程获取物品列表
check_item_progess_getitem([]) -> [];
check_item_progess_getitem([#task_progress{trg_label = get_item, target = ItemBaseId} | T]) -> [ItemBaseId | check_item_progess_getitem(T)];
check_item_progess_getitem([_Progress | T]) -> check_item_progess_getitem(T).
%% 扣除物品列表
check_reward_item([]) -> [];
check_reward_item([#loss{label = cn_item, val = [ItemBaseId, _Bind, _Quantity]} | T]) -> [ItemBaseId | check_reward_item(T)];
check_reward_item([#loss{label = item, val = [ItemBaseId, _Bind, _Quantity]} | T]) -> [ItemBaseId | check_reward_item(T)];
check_reward_item([_GL | T]) -> check_reward_item(T).

%% 重建item进度
rebuild_item_progess(Role, _Task, []) -> 
    {ok, Role};
rebuild_item_progess(Role = #role{bag = #bag{items = Items}, task_bag = #task_bag{items = TaskItems}, task = TaskList, link = #link{conn_pid = ConnPid}}, Task = #task{task_id = TaskId, accept_num = AcceptNum, item_base_id = FXItemBaseId, item_num = ItemNum, quality = Quality, progress = ProgList}, [Progress = #task_progress{id = ProgId, trg_label = get_item, target = ItemBaseId, target_value = TargetVal, value = _Val} | T]) ->
    NowVal = case storage:find(Items, #item.base_id, ItemBaseId) of
        {ok, Num, _, _, _} when Num > TargetVal-> TargetVal;
        {ok, Num, _, _, _}  -> Num;
        _ -> 0
    end,
    NewVal2 = case NowVal > 0 of
        true -> NowVal;
        false ->
            case storage:find(TaskItems, #item.base_id, ItemBaseId) of
                {ok, CNum, _, _, _} when CNum > TargetVal -> TargetVal;
                {ok, CNum, _, _, _}  -> CNum;
                _ -> 0
            end
    end,
    case NewVal2 >= TargetVal of
        true ->
            rebuild_item_progess(Role, Task, T);
        false ->
            NewProgress = Progress#task_progress{status = 0, value = NewVal2},
            NewProgList = lists:keyreplace(ProgId, #task_progress.id, ProgList, NewProgress),
            NewTask = Task#task{progress = NewProgList, status = 0},
            NewTaskList = lists:keyreplace(TaskId, #task.task_id, TaskList, NewTask),
            sys_conn:pack_send(ConnPid, 10202, {TaskId, 0, AcceptNum, FXItemBaseId, ItemNum, Quality, task_rpc:convert_progress(NewProgList)}),
            {ok, #task_base{npc_accept = NpcAccept, npc_commit = NpcCommit}} = task_data:get_conf(TaskId),
            task_rpc:send_upd_npc_status(ConnPid, [{NpcCommit, TaskId, 0}]),
            task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 2}]),
            NewRole = rebuild_trigger(Role#role{task = NewTaskList}),
            rebuild_item_progess(NewRole, NewTask, T)
    end;
rebuild_item_progess(Role, Task, [_Progress | T]) ->
    rebuild_item_progess(Role, Task, T).

%% @spec next_lev_task(Type::integer(), Role::#role{}) -> [TaskId::integer()]
%% @doc 获取下一等级任务
update_next_lev_task(?task_type_zhux, Role = #role{lev = Lev, link = #link{conn_pid = ConnPid}}) ->
    {ok, AcceptableZhux} = role:get_dict(task_acceptable_zhux),
    {ok, AcceptedZhux} = role:get_dict(task_accepted_zhux),
    case {AcceptableZhux, AcceptedZhux} of
        {[], []} ->
            TaskList = task_data:lev(Lev + 1),
            {ok, FinishZhux} = role:get_dict(task_finish_zhux),
            Opt = [type, career, finish_one, accepted, prev, cond_accept],
            NextLevTask = task_filter:filter(Opt, Role, TaskList, #task_fparam{type = ?task_type_zhux, is_ring = ?false, finish_task_list = FinishZhux, accept_task_list = AcceptedZhux}),
            %% ?DEBUG("下一等级任务:~w", [NextLevTask]),
            sys_conn:pack_send(ConnPid, 10214, {NextLevTask});
        _Any -> 
            %% ?DEBUG("没有下一级任务列表:~w", [_Any]),
            ignore
    end;
update_next_lev_task(_Type, _Role) -> ignore.

%% 可接任务
convert_accept_num(acceptable, _Career, []) -> [];
convert_accept_num(acceptable, Career, [TaskId | T]) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{type = Type}} ->
            [{TaskId, get_accept_num(Type, Career, TaskId)} | convert_accept_num(acceptable, Career, T)];
        _ ->
            [{TaskId, 1} | convert_accept_num(acceptable, Career, T)]
    end.

%% 获取第几次接受任务
get_accept_num(?task_type_zhux, Career, TaskId) ->
    {ok, FinishZhux} = role:get_dict(task_finish_zhux),
    keyfind_accept_num(?task_type_zhux, Career, FinishZhux, TaskId);
get_accept_num(?task_type_zhix, Career, TaskId) ->
    {ok, FinishZhix} = role:get_dict(task_finish_zhix),
    keyfind_accept_num(?task_type_zhix, Career, FinishZhix, TaskId);
get_accept_num(_Type, _Career, _TaskId) -> 1.

keyfind_accept_num(_Type, _Career, FinishTaskList, TaskId) ->
    Rs = case lists:keyfind(TaskId, #task_finish.task_id, FinishTaskList) of
        #task_finish{finish_num = FinishNum} ->
            FinishNum + 1;
        _ -> 1
    end,
    Rs.

%% 接受任务事件链
do_accept_chain([], TaskParamAccept) -> {ok, TaskParamAccept};
do_accept_chain([check_acceptable | T], TaskParamAccept = #task_param_accept{task_id = TaskId, task_base = #task_base{type = Type}}) ->
    {ok, Data} = task:get_dict(acceptable, Type),
    case lists:member(TaskId, Data) of
        true -> 
            do_accept_chain(T, TaskParamAccept);
        false -> 
            {false, <<"">>}
    end;

do_accept_chain([check_distance | T], TaskParamAccept = #task_param_accept{role = #role{pos = #pos{map_pid = RMapPid, x = RX, y = RY}, cross_srv_id = CrossSrvId}, npc_id_accept = NpcIdAccept, task_base = #task_base{npc_accept = NpcAccept}}) ->
    NpcRes = case CrossSrvId of
        <<"center">> -> center:call(npc_mgr, lookup, [by_id, NpcIdAccept]);
        _ -> npc_mgr:lookup(by_id, NpcIdAccept)
    end,
    case NpcRes of
        false ->
            ?DEBUG("不存在的NPC:[~p]", [NpcIdAccept]),
            {false, ?L(<<"NPC不存在">>)};
        _Npc = #npc{pos = #pos{map_pid = NpcMapPid, x = NpcX, y = NpcY}, base_id = BaseId} ->
            DistX = erlang:abs(RX - NpcX),
            DistY = erlang:abs(RY - NpcY),
            if
                RMapPid =:= NpcMapPid andalso DistX =< 500 andalso DistY =< 500 -> 
                    case NpcAccept =:= BaseId of
                        true -> do_accept_chain(T, TaskParamAccept);
                        false -> {false, ?L(<<"你距离NPC太远，请移动到NPC旁！">>)}
                    end;
                true ->
                    ?DEBUG("[任务系统]你距离NPC太远，请移动到NPC旁[~w]", [NpcIdAccept]),
                    {false, ?L(<<"你距离NPC太远，请移动到NPC旁。">>)}
            end
    end;
do_accept_chain([accept | T], TaskParamAccept = #task_param_accept{role = Role = #role{link = #link{conn_pid = ConnPid}, bag = #bag{items = Items}}, task_id = TaskId, litem_id = LItemId, litem_num = ItemNum, quality = Quality}) ->
    case task:accept(TaskId, Role) of
        {ok, NewRole = #role{task = TaskList}} ->
            case lists:keyfind(TaskId, #task.task_id, TaskList) of
                Task = #task{status = Status} ->
                    {ok, #task_base{type = Type, npc_accept = NpcAccept, npc_commit = NpcCommit}} = task_data:get_conf(TaskId),
                    ItemBaseId = case storage:find(Items, #item.id, LItemId) of
                            {ok, #item{base_id = LItemBaseId}} -> LItemBaseId;
                            _ -> 0
                    end,
                    task_rpc:send_add_accepted_task(ConnPid, Task#task{item_base_id = ItemBaseId, item_num = ItemNum, quality = Quality}),      %% 送发增加已接任务消息
                    task_rpc:send_del_acceptable_task(ConnPid, TaskId),  %% 送发删除可接任务消息
                    delete_cache(acceptable, Type, [TaskId]),
                    add_cache(accepted, Type, [TaskId]),

                  
                    task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 0}]),
                    case Status =:= 1 of
                        true -> %% 已完成
                            task_rpc:send_upd_npc_status(ConnPid, [{NpcCommit, TaskId, 3}]);
                        false -> %% 未完成
                            task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 2}])
                    end;
                false ->
                   skip 
            end,
           
            ?DEBUG("接受任务成功:~w", [TaskId]),
            do_accept_chain(T, TaskParamAccept#task_param_accept{role = NewRole});
        {false, Reason} ->
            {false, Reason}
    end;

do_accept_chain([accept_spec | T], TaskParamAccept = #task_param_accept{role = Role = #role{link = #link{conn_pid = ConnPid}}, task_id = TaskId}) ->
    case task:accept(TaskId, Role) of
        {ok, NewRole = #role{task = TaskList}} ->
            case lists:keyfind(TaskId, #task.task_id, TaskList) of
                Task = #task{status = Status} ->
                    {ok, #task_base{npc_accept = NpcAccept, npc_commit = NpcCommit}} = task_data:get_conf(TaskId),
                    task_rpc:send_add_accepted_task(ConnPid, Task),      %% 送发增加已接任务消息
                    case Status =:= 1 of
                        true -> %% 已完成
                            task_rpc:send_upd_npc_status(ConnPid, [{NpcCommit, TaskId, 3}]);
                        false -> %% 未完成
                            task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 2}])
                        end;
                false ->
                   skip 
            end,
            ?DEBUG("接受世界树任务成功:~w", [TaskId]),
            do_accept_chain(T, TaskParamAccept#task_param_accept{role = NewRole});
        {false, Reason} ->
            {false, Reason}
    end;

%% 通关星级副本
do_accept_chain([accept_stardun | T], TaskParamAccept = #task_param_accept{role = Role = #role{link = #link{conn_pid = ConnPid}}, task_id = TaskId}) ->
    case task:accept(TaskId, Role) of
        {ok, NewRole = #role{task = TaskList}} ->
            case lists:keyfind(TaskId, #task.task_id, TaskList) of
                Task = #task{} ->
                    task_rpc:send_add_accepted_task(ConnPid, Task);      %% 送发增加已接任务消息
                false ->
                   skip 
            end,
            add_cache(accepted, ?task_type_star_dun, [TaskId]),
            ?DEBUG("接受星级通关副本任务成功:~w", [TaskId]),
            do_accept_chain(T, TaskParamAccept#task_param_accept{role = NewRole});
        {false, Reason} ->
            {false, Reason}
    end;

%% 手动扣除物品
do_accept_chain([loss_item | T], TaskParamAccept = #task_param_accept{litem_id = 0, task_base = #task_base{kind = Kind}}) when Kind =/= 2 -> %% 普通
    do_accept_chain(T, TaskParamAccept);
do_accept_chain([loss_item | T], TaskParamAccept = #task_param_accept{role = Role = #role{bag = #bag{items = Items}}, litem_id = ItemId, litem_num = Num, task_id = TaskId, task_base = #task_base{kind = 2}}) ->
    case storage:find(Items, #item.id, ItemId) of
        {ok, #item{base_id = ItemBaseId, quantity = Quantity}} ->
            case task_data_item:get(TaskId, ItemBaseId, Num) of
                {ok, _} ->
                    case Quantity >= Num of
                        true ->
                            case role_gain:do([#loss{label = item_id, val = [{ItemId, Num}]}], Role) of
                                {ok, NewRole = #role{task = TaskList}} ->
                                    case lists:keyfind(TaskId, #task.task_id, TaskList) of
                                        false -> {false, ?L(<<"没找到任务">>)};
                                        Task ->
                                            NewTaskList = lists:keyreplace(TaskId, #task.task_id, TaskList, Task#task{item_base_id = ItemBaseId, item_num = Num}),
                                            do_accept_chain(T, TaskParamAccept#task_param_accept{role = NewRole#role{task = NewTaskList}})
                                    end;
                                {false, _} -> {false, ?L(<<"扣除物品失败">>)}
                            end;
                        false ->
                            {false, ?L(<<"物品数量不足">>)}
                    end;
                {false, _Reason} ->
                    {false, ?L(<<"任务的相关令牌数据有误">>)}
            end;
        {false, Reason} ->
            {false, Reason}
    end;
do_accept_chain([loss_item | _T], _TaskParamAccept) -> 
    {false, ?L(<<"任务数据有误:该任务非飞仙令任务">>)};

do_accept_chain([_Type | _T], _TaskParamAccept) ->
    ?ELOG("[任务系统]接受任务没有处理类型:~w", [_Type]),
    {false, util:fbin(?L(<<"接受任务没有处理类型:~w">>), [_Type])}.

%% 完成任务后置事件
do_commit_chain([], TaskParamCommit) -> {ok, TaskParamCommit};

%% 修改进度为完成
do_commit_chain([finish_progress | T], TaskParamCommit = #task_param_commit{role = Role = #role{task = TaskList, link = #link{conn_pid = ConnPid}}, task_id = TaskId, task_base = #task_base{kind = ?task_kind_xiuxing, npc_accept = NpcAccept}, finish_imm = ?true}) ->
    case lists:keyfind(TaskId, #task.task_id, TaskList) of
        false -> {false, TaskParamCommit#task_param_commit{reason = <<>>}}; %% 没有找到完成
        Task ->
            NewTask = finish_task(Task),
            NewTaskList = lists:keyreplace(TaskId, #task.task_id, TaskList, NewTask),
            task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 0}]),
            do_commit_chain(T, TaskParamCommit#task_param_commit{role = Role#role{task = NewTaskList}, task = NewTask})
    end;
do_commit_chain([finish_progress | T], TaskParamCommit = #task_param_commit{role = Role = #role{task = TaskList, link = #link{conn_pid = ConnPid}}, task_id = TaskId, task_base = #task_base{type = Type, npc_accept = NpcAccept}, finish_imm = ?true}) when Type =:= ?task_type_sm orelse Type =:= ?task_type_bh orelse Type =:= ?task_type_xx ->
    case lists:keyfind(TaskId, #task.task_id, TaskList) of
        false -> {false, TaskParamCommit#task_param_commit{reason = <<>>}}; %% 没有找到完成
        Task ->
            NewTask = finish_task(Task),
            NewTaskList = lists:keyreplace(TaskId, #task.task_id, TaskList, NewTask),
            task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 0}]),
            do_commit_chain(T, TaskParamCommit#task_param_commit{role = Role#role{task = NewTaskList}, task = NewTask})
    end;
do_commit_chain([finish_progress | T], TaskParamCommit) ->
    do_commit_chain(T, TaskParamCommit);

do_commit_chain([distance| T], TaskParamCommit = #task_param_commit{role = #role{pos = #pos{map_pid = RMapPid, x = RX, y = RY}, cross_srv_id = CrossSrvId}, npc_id_commit = NpcIdCommit, task_base = #task_base{npc_commit = NpcCommit}}) ->
    NpcRes = case CrossSrvId of
        <<"center">> -> center:call(npc_mgr, lookup, [by_id, NpcIdCommit]);
        _ -> npc_mgr:lookup(by_id, NpcIdCommit)
    end,
    case NpcRes of
        false ->
            ?DEBUG("不存在的NPC:[~p]", [NpcIdCommit]),
            {false, TaskParamCommit#task_param_commit{reason = ?L(<<"NPC不存在">>)}};
        _Npc = #npc{pos = #pos{map_pid = NpcMapPid, x = NpcX, y = NpcY}, base_id = BaseId} ->
            DistX = erlang:abs(RX - NpcX),
            DistY = erlang:abs(RY - NpcY),
            if
                RMapPid =:= NpcMapPid andalso DistX =< 500 andalso DistY =< 500 -> 
                    case NpcCommit =:= BaseId of
                        true -> do_commit_chain(T, TaskParamCommit);
                        false -> 
                            {false, TaskParamCommit#task_param_commit{reason = ?L(<<"你距离NPC太远，请移动到NPC旁">>)}}
                    end;
                true ->
                    ?DEBUG("[任务系统]你距离NPC太远，请移动到NPC旁[~w]", [NpcIdCommit]),
                    {false, TaskParamCommit#task_param_commit{reason = ?L(<<"你距离NPC太远，请移动到NPC旁">>)}}
            end
    end;
do_commit_chain([commit | T], TaskParamCommit = #task_param_commit{task_id = TaskId, role = Role = #role{id = {RoleId, SrvId}, career = Career, link = #link{conn_pid = ConnPid}}, task_base = #task_base{type = Type, npc_commit = NpcCommit}}) ->
    case commit(TaskParamCommit, Role) of
        {ok, Task = #task{accept_time = _AcceptTime}, NewRole = #role{task = Task1}} ->
            task_dao:delete_task(RoleId, SrvId, TaskId),    %% 删除数据库中已接任务
            delete_cache(accepted, Type, [TaskId]),    %% 删除已接任务缓存
            task_rpc:send_del_accepted_task(ConnPid, TaskId),        %% 发送删除已接任务消息
            case has_commit_flag(NpcCommit, Task1) of  %% 先检查是否还有同一个已完成的任务同一个NPC提交的任务，如果还有，则不用删除NPC状态
                true ->
                    skip;
                false ->
                    task_rpc:send_upd_npc_status(ConnPid, [{NpcCommit, TaskId, 0}])%% 删除Npc状态
            end,
            %% 添加新的可接任务
            NewAcceptableTaskidList = task:refresh_acceptable_task(by_type, NewRole, Type, TaskId),
            AddAcceptable = 
            case Type =/= ?task_type_spec andalso Type =/= ?task_type_star_dun of
                true ->
                    {ok, Data} = task:get_dict(acceptable, Type),
                    NewAcceptableTaskidList --  Data;
                false -> []
            end,
            %% AddAcceptable = NewAcceptableTaskidList --  Data,
            case length(AddAcceptable) > 0 of
                true -> %% 有新的可接任务
                    task_rpc:send_batch_npc_status(acceptable, ConnPid, AddAcceptable, 1, []), %% 更新Npc状态
                    task_rpc:send_add_acceptable_tasks(ConnPid, Career, AddAcceptable), %% 推送可接任务
                    task:add_cache(acceptable, Type, AddAcceptable);
                false ->
                    skip 
            end,
            task:update_next_lev_task(Type, NewRole),
            do_commit_chain(T, TaskParamCommit#task_param_commit{role = NewRole, task = Task});
        {false, Reason} ->
            {false, TaskParamCommit#task_param_commit{reason = Reason}};
        {false, Reason, NewRole} ->
            {false, TaskParamCommit#task_param_commit{reason = Reason, update_role = ?true, role = NewRole}}
    end;

do_commit_chain([gain_loss_notice | T], TaskParamCommit) ->
    %% TODO 发送动态损益信息
    do_commit_chain(T, TaskParamCommit);

%% 杂项

%% 完成主线
do_commit_chain([misc_fire | T], TaskParamCommit = #task_param_commit{role = Role = #role{}, task_base = #task_base{ type = ?task_type_zhux}}) ->
    {Role1, DailyIds} = activity2:fire_tasks(Role),
    activity2:push_13803(Role1, DailyIds),  %% 通知客户端增加任务
    do_commit_chain(T, TaskParamCommit#task_param_commit{role = Role1});

do_commit_chain([misc_fire | T], TaskParamCommit) ->
    do_commit_chain(T, TaskParamCommit);

do_commit_chain([_Other | _T], TaskParamCommit) ->
    {false, TaskParamCommit#task_param_commit{reason = util:fbin(?L(<<"未没处理commit_chain标签:~w">>), [_Other])}}.

%% 放弃任务
do_giveup_chain([], TaskParamGiveup) -> {ok, TaskParamGiveup};

do_giveup_chain([giveup_task | T], TaskParamGiveup = #task_param_giveup{role = Role = #role{id = {RoleId, SrvId}, career = Career, link = #link{conn_pid = ConnPid}, task = TaskList}, task_id = TaskId, task_base = #task_base{type = Type, npc_accept = NpcAccept, npc_commit = NpcCommit}}) ->
    case giveup(TaskId, Role) of
        {ok, NewRole} ->
            task_dao:delete_task(RoleId, SrvId, TaskId),    %% 删除数据库中已接任务数据
            task:delete_cache(accepted, Type, [TaskId]),    %% 删除已接任务缓存
            task_rpc:send_del_accepted_task(ConnPid, TaskId),
            case lists:keyfind(TaskId, #task.task_id, TaskList) of
                false ->
                    skip;
                #task{status = Status} ->
                    case Status of
                        0 -> %% 未完成
                            task_rpc:send_upd_npc_status(ConnPid, [{NpcAccept, TaskId, 0}]);
                        1 ->
                            task_rpc:send_upd_npc_status(ConnPid, [{NpcCommit, TaskId, 0}])
                    end
            end,
            %% 放弃任务如同完成任务,所以需要更新下一个任务,添加新的可接任务
            NewAcceptableTaskidList = task:refresh_acceptable_task(by_type, NewRole, Type, TaskId),
            {ok, Data} = task:get_dict(acceptable, Type),
            AddAcceptable = NewAcceptableTaskidList --  Data,
            case length(AddAcceptable) > 0 of
                true -> %% 有新的可接任务
                    task_rpc:send_batch_npc_status(acceptable, ConnPid, AddAcceptable, 1, []), %% 更新Npc状态
                    task_rpc:send_add_acceptable_tasks(ConnPid, Career, AddAcceptable), %% 推送可接任务
                    task:add_cache(acceptable, Type, AddAcceptable);
                false ->
                    skip 
            end,
            do_giveup_chain(T, TaskParamGiveup#task_param_giveup{role = NewRole});
        {false, Reason} ->
            ?DEBUG("放弃任务失败:~w", [Reason]),
            {false, Reason}
    end;

do_giveup_chain([giveup_misc_fire | T], TaskParamGiveup) ->
    do_giveup_chain(T, TaskParamGiveup);
do_giveup_chain([_Type | _T], _TaskParamGiveup) ->
    ?ELOG("[任务系统]放弃任务没有处理类型:~w", [_Type]),
    {false, util:fbin(?L(<<"放弃任务没有处理类型:~w">>), [_Type])}.

convert_finish_progress([]) -> [];
convert_finish_progress([P =#task_progress{trg_label = special_event, target = 1014, target_value = TargetVal} | T]) -> %% 入帮
    [P#task_progress{value = TargetVal, status = 1} | convert_finish_progress(T)];
convert_finish_progress([P =#task_progress{trg_label = special_event, target = 1001, target_value = TargetVal} | T]) -> %% 转职
    [P#task_progress{value = TargetVal, status = 1} | convert_finish_progress(T)];
convert_finish_progress([P | T]) ->
    [P | convert_finish_progress(T)].

%% 完成主线，星级副本任务触发星级副本任务
finish_task_fire_star_dun(Role) ->
    {ok, FinishZhux} = role:get_dict(task_finish_zhux),
    {ok, FinishZhix} = role:get_dict(task_finish_zhix),
    L = FinishZhux++FinishZhix,
    L1 = [TaskId || #task_finish{task_id = TaskId} <- L],
    check_accepte_star_dun(L1, Role).

check_accepte_star_dun(AcceptedFinishedTask, Role) ->
    AllStarTasks = task_data:all_star_dun_task(),
    do_check_accepte_star_dun(AllStarTasks, AcceptedFinishedTask, Role). 

do_check_accepte_star_dun([], _AccetedTask, Role) -> Role;
do_check_accepte_star_dun([TaskId | T], AcceptedFinishedTask, Role) ->
    {ok, #task_base{prev = Prev}} = task_data:get(TaskId),
    {ok, FinishStarDun} = role:get_dict(task_finish_stardun),
    {ok, AcceptedStarDun} = role:get_dict(task_accepted_stardun),
    L1 = [TaskId1 || #task_finish{task_id = TaskId1} <- FinishStarDun] ++ AcceptedStarDun,
    %%?DEBUG("开始检查支线任务ID ~w 是否可接", [TaskId]),
    %%?DEBUG("已接或已完成支线列表~w", [L1]),
    %%?DEBUG("已完成主线副本列表~w", [AcceptedFinishedTask]),
    case lists:member(TaskId, L1) of
        true -> %% 已接或已完成
            %%?DEBUG("已完成的支线"),
            do_check_accepte_star_dun(T, AcceptedFinishedTask, Role);
        false ->
            case Prev of
                [] ->
                    do_check_accepte_star_dun(T, AcceptedFinishedTask,  check_task_dungeon(TaskId, Role));
                [PrevId] ->
                    {ok, #task_base{type = Type}} = task_data:get(PrevId),
                    case Type of
                        ?task_type_zhux ->
                            case lists:member(PrevId, AcceptedFinishedTask) of
                                true ->
                                    %%?DEBUG("< 1 >"),
                                    do_check_accepte_star_dun(T, AcceptedFinishedTask, check_task_dungeon(TaskId, Role));
                                false ->
                                    %%?DEBUG("< 2 >"),
                                    do_check_accepte_star_dun(T, AcceptedFinishedTask, Role)
                            end;
                        ?task_type_star_dun ->
                            case lists:member(PrevId, L1) of
                                true ->
                                    %%?DEBUG("< 3 >"),
                                    do_check_accepte_star_dun(T, AcceptedFinishedTask, check_task_dungeon(TaskId, Role));
                                false ->
                                    %%?DEBUG("< 4 >"),
                                    do_check_accepte_star_dun(T, AcceptedFinishedTask, Role)
                            end                   
                    end
            end
    end.

check_task_dungeon(TaskId, Role = #role{dungeon = RoleDungeons}) ->
    DungeonId = task_data:task2dungeon(TaskId),
    case DungeonId of
        ok ->
            %%?DEBUG("< 5 >"),
            accept_star_dungeon(TaskId, Role);
        DungeonId when is_integer(DungeonId) ->
            case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of %% 通关了副本
                #role_dungeon{} ->
                    ?DEBUG("接受副本任务~w成功！", [TaskId]),
                    accept_star_dungeon(TaskId, Role);
                false ->
                    ?DEBUG("接受副本任务~w失败！还没通关副本 ~w", [TaskId, DungeonId]),
                    Role
            end;
        _ ->
            %%?DEBUG("< 6 >"),
            Role
    end.

%% 首次通关副本触发任务
clear_dungeon_fire(DungeonId, Role) ->
    TaskId = task_data:dungeon2task(DungeonId),
    case TaskId of
        false ->
            %%notice:inform(<<"此副本没有对应的任务">>),
            Role;
        _ ->
            {ok, FinishZhux} = role:get_dict(task_finish_zhux),
            {ok, FinishStarDun} = role:get_dict(task_finish_stardun),
            L = FinishZhux ++ FinishStarDun,
            L1 = [TaskId1 || #task_finish{task_id = TaskId1} <- L],
            case lists:member(TaskId, L1) of
                true ->
                    %%notice:inform(<<"此副本对应任务已经完成">>),
                    Role;
                false ->
                    {ok, #task_base{prev = Prev}} = task_data:get(TaskId),
                    case Prev of
                        [] ->
                            accept_star_dungeon(TaskId, Role);
                        [FinTaskId] ->
                            case lists:member(FinTaskId, L1) of
                                true ->
                                    accept_star_dungeon(TaskId, Role);
                                false ->
                                    %%notice:inform(<<"触发失败，前置任务还未完成">>),
                                    Role
                            end

                    end 
            end
    end.

%% 
accept_star_dungeon(TaskId, Role) ->
    case task:accept_chain(#task_param_accept{role = Role, task_id = TaskId}) of
        {ok, #task_param_accept{role = Role2}} ->
            Role2;
        _ ->
            Role
    end.


%% 任务过滤
filter_nonexist_task_log([]) -> [];
filter_nonexist_task_log([L = [_RoleId, _SrvId, TaskId, _Type, _SecType, _FinishNum, _AcceptTime, _FinishTime] | T]) ->
    case task_data:get_conf(TaskId) of
        {ok, _} -> [L | filter_nonexist_task_log(T)];
        _ -> filter_nonexist_task_log(T)
    end;
filter_nonexist_task_log([L = [_RoleId, _SrvId, TaskId, _Type, _AcceptTime, _FinishTime] | T]) ->
    case task_data:get_conf(TaskId) of
        {ok, _} -> [L | filter_nonexist_task_log(T)];
        _ -> filter_nonexist_task_log(T)
    end;
filter_nonexist_task_log([_L | T]) ->
    ?ELOG("过滤任务日志有误，日志结构匹配不上: ~w", [_L]),
    filter_nonexist_task_log(T).

platform_task(Rid, Lev)->
    case sys_env:get(srv_id) of
        undefined -> false;
        SrvId ->
            case role_api:lookup(by_id, {Rid, list_to_bitstring(SrvId)}, #role.pid) of
                {ok, _, RolePid} ->
                    role:apply(async, RolePid, {fun apply_platform_task/2, [Lev]});
                _Msg -> 
                    ignore
            end,
            ok
    end.

%% @spec is_finish_sq_task() -> bool
%% @doc 检查是否完成了赠送神器任务，这方法开放主要给开服活动列表检查用
%% @author Jange 2012/4/12
is_finish_sq_task() ->
    is_finish_task([26008], 2).

apply_platform_task(Role = #role{id = {RoleId, SrvId}}, Lev) ->
    TaskIdList = data_all_task(Lev - 1),
    process_task(TaskIdList, RoleId, SrvId),
    NewRole = Role#role{lev = Lev},
    map:role_update(NewRole),
    refresh_acceptable_task(ref_and_send, NewRole, ?task_type_zhux),
    refresh_acceptable_task(ref_and_send, NewRole, ?task_type_zhix),
    {ok, NewRole}.

process_task([], _RoleId, _SrvId) -> ok;
process_task([TaskId | T], RoleId, SrvId) when TaskId =/= 26008->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{type = TaskType}} when TaskType =:= ?task_type_zhux orelse TaskType =:= ?task_type_zhix -> 
            add_cache_term(finish, sync_db_yes, TaskType, TaskId, {RoleId, SrvId, util:unixtime(), util:unixtime()}),
            process_task(T, RoleId, SrvId);
        _ -> process_task(T, RoleId, SrvId)
    end;
process_task([_TaskId | T], RoleId, SrvId) ->
    process_task(T, RoleId, SrvId).

%% 完成任务
finish_task(Task = #task{progress = Progress}) ->
    NewProgress = finish_progress(Progress),
    Task#task{status = ?true, progress = NewProgress}.
finish_progress([]) -> [];
finish_progress([P =#task_progress{target_value = TargetVal} | T]) -> 
    [P#task_progress{value = TargetVal, status = ?true} | convert_finish_progress(T)].

%% 按杀人数快速排序
gainloss_qsort([]) -> [];
gainloss_qsort([Gain = #gain{label = guild_devote} | T]) ->
    gainloss_qsort(T) ++ [Gain];
gainloss_qsort([Gain | T]) ->
    gainloss_qsort([GL || GL = #loss{} <- T])
    ++ [Gain] ++
    gainloss_qsort([GL || GL <- T, not is_record(GL, loss)]).


%% 登录处理角色任务信息状态
login_task_role_elem(_TaskList, []) -> [];
login_task_role_elem(TaskList, [TaskElem = #task_xx_elem{list = XxList} | T]) ->
    NewXxList = login_task_role(TaskList, XxList),
    [TaskElem#task_xx_elem{list = NewXxList} | login_task_role_elem(TaskList, T)].
login_task_role(_TaskList, []) -> [];
login_task_role(TaskList, [{TaskId, Quality, ?task_xx_status_unfinish} | T]) ->
    case lists:keyfind(TaskId, #task.task_id, TaskList) of
        false -> [{TaskId, Quality, ?task_xx_status_unaccept} | login_task_role(TaskList, T)];
        _ -> [{TaskId, Quality, ?task_xx_status_unfinish} | login_task_role(TaskList, T)]
    end;
login_task_role(TaskList, [{TaskId, Quality, ?task_xx_status_finished} | T]) ->
    case lists:keyfind(TaskId, #task.task_id, TaskList) of
        false -> [{TaskId, Quality, ?task_xx_status_unaccept} | login_task_role(TaskList, T)];
        _ -> [{TaskId, Quality, ?task_xx_status_finished} | login_task_role(TaskList, T)]
    end;
login_task_role(TaskList, [{TaskId, Quality, Status} | T]) ->
    [{TaskId, Quality, Status} | login_task_role(TaskList, T)].

is_accepted(#role{task = Task}, TaskId) ->
    case lists:keyfind(TaskId, #task.task_id, Task) of
        false -> false;
        _ -> true
    end.

%% 新手装备
add_eqm(Role, ItemBaseId) ->
    case eqm:puton_init_eqm(ItemBaseId, Role) of 
        {ok, Role1} ->
            {ok, Role1};
        {false, _Reason} ->
            ?DEBUG("新手装备失败: ~p", [_Reason]),
            role_gain:do([#gain{label = item, val = [ItemBaseId, 1, 1]}], Role)
    end.

is_zhux_finish(TaskId) ->
   {ok, Data} = role:get_dict(task_finish_zhux),
    case lists:keyfind(TaskId, #task_finish.task_id, Data) of
        #task_finish{} ->
            true;
        false ->
            false
    end.

has_commit_flag(_NpcCommit, []) -> false;
has_commit_flag(NpcCommit, [#task{status = 0} | T]) -> has_commit_flag(NpcCommit, T);
has_commit_flag(NpcCommit, [#task{task_id = TaskId, status = 1} | T]) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{npc_commit = NpcCommit}} -> true;
        _ ->
            has_commit_flag(NpcCommit, T)
    end.

%%----------------------------------------------------
%% 工具函数
%%----------------------------------------------------

%% 获取Lev级别及以下级别的所有任务ID列表 from task_data
%% @spec get_all_task(Lev) -> List
%% Lev = integer() 等级
%% List = list() of integer() 任务ID列表
data_all_task(Lev) ->
    case Lev >= 1 of
        true ->
            L = task_data:lev(Lev),
            lists:append(L, data_all_task(Lev - 1));
        false ->
            []
    end.

gm_accept(TaskId, Role = #role{career = Career, task = TaskList, trigger = Trigger}) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{task_id = Id, type = Type, sec_type = SecType, cond_finish = TaskCondFinish, accept_rewards = AcceptRewards}} ->
            case lists:keyfind(TaskId, ?KEY_POS, TaskList) of
                false ->
                    AcceptNum = get_accept_num(Type, Career, TaskId),
                    case check_finish_cond(TaskCondFinish, Role, []) of
                        {true, ProgList} -> %% 生成一条已完成的任务数据
                            case role_gain:do(AcceptRewards, Role) of
                                {ok, NewRole} ->
                                    {ok, NewRole#role{task = [#task{task_id = Id, type = Type, sec_type = SecType, accept_time = util:unixtime(), accept_num = AcceptNum, status = 1, progress = ProgList} | TaskList]}};
                                {false, _} ->
                                    {false, ?L(<<"接受任务失败">>)}
                            end;
                        {false, _Reason} -> %% 注册触发器和生成任务进度信息 接受接受
                            case reg_trigger(TaskCondFinish, [], TaskId, Trigger, Role) of
                                {ok, P, Nt} ->
                                    case role_gain:do(AcceptRewards, Role) of
                                        {ok, NewRole} ->
                                            {ok, NewRole#role{trigger = Nt, task = [#task{task_id = Id, type = Type, sec_type = SecType, accept_time = util:unixtime(), accept_num = AcceptNum, status = 0, progress = P} | TaskList]}};
                                        {false, _} ->
                                            {false, ?L(<<"接受任务失败">>)}
                                    end;
                                _E ->
                                    ?ELOG("接受任务失败: TaskId:~w, Reason:~w", [TaskId, _E]),
                                    {false, ?L(<<"接受任务失败">>)}
                            end
                    end;
                _ ->
                    {false, <<"">>}
                    %% {false, ?L(<<"你已经接下了此任务">>)}
            end;
        _ ->
            {false, ?L(<<"不存在此任务">>)}
    end.



