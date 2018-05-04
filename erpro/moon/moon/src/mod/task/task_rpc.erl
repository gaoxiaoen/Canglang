%%----------------------------------------------------
%%% 任务系统远程调用
%% @author yeahoo2000@gmail.com, yqhuang*
%%----------------------------------------------------
-module(task_rpc).
-export([
        handle/3
        ,send_upd_accepted_task/2
        ,send_add_accepted_task/2
        ,send_del_accepted_task/2
        ,send_add_acceptable_task/3
        ,send_add_acceptable_tasks/3
        ,send_del_acceptable_task/2
        ,send_upd_npc_status/2
        ,send_batch_npc_status/4
        ,send_batch_npc_status/5
        ,pack_send_10226/2
        ,accept_growup_task/2
        ,convert_progress/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("task.hrl").
-include("task_wanted.hrl").
-include("condition.hrl").
-include("link.hrl").
-include("escort.hrl").
-include("pos.hrl").
-include("npc.hrl").
-include("combat.hrl").
-include("gain.hrl").
-include("map.hrl").

%%
-define(task_xx_finish_all_item, [{29178, 1, 1}]). %% 修行任务完成10次后通过邮件发这个礼包
-define(suc, 1).
-define(three_day_secs, 3 * 24 * 3600). %% 三天秒数
-define(all_my_delegate, 0).
-define(add_a_new_delegate, 1).

%% 获取已接任务列表
handle(10200, {}, #role{task = TaskList}) ->
    ?DEBUG("任务列表  ~w", [TaskList]),
    TaskList1 = [Task#task{progress = convert_progress(Progress)} || Task = #task{progress = Progress} <- TaskList],
    {reply, {TaskList1}};

%% 获取可接任务列表
handle(10201, {}, Role = #role{name = _Name, career = Career}) ->
    TaskList = task:get_all_type_acceptabel(),
    task:update_next_lev_task(?task_type_zhux, Role),
    {reply, {task:convert_accept_num(acceptable, Career, TaskList)}};

%% 更新指定任务
%% 当任务进度发现变化的时候需要更新客户端相应的任务信息
%% 测试协议
handle(10202, {TaskId}, #role{task = TaskList}) ->
    %% TOGO:任务进度发生变化
    MatchList = [Task || Task = #task{task_id = Tid} <- TaskList, Tid =:= TaskId],
    case length(MatchList) >= 1 of
        true ->
            [#task{task_id = TaskId, status = Status, progress = Progress, accept_num = AcceptNum, item_base_id = ItemBaseId, item_num = ItemNum}|_T] = MatchList,
            ?DEBUG(" 任务状态!!!!!!!!!! ~w", [Status]),
            {reply, {TaskId, Status, AcceptNum, ItemBaseId, ItemNum, Progress}};
        false ->
            ?DEBUG("没有找到任务任务:~w", [TaskId]), 
            {ok}
    end;

%% 增加可接任务（单个任务）,当放弃任务的时候自动推送
%% 测试协议
handle(10203, {}, _Role) ->
    %% TODO:获取可接任务
    {reply, {10005}};

%% 增加已接任务，接受任务的时候自动推送消息
%% 测试协议
handle(10205, {}, #role{task = TaskList}) ->
    %% TODO:获取已接任务
    case length(TaskList) >= 1 of
        true ->
            [#task{task_id = TaskId, status = Status, accept_num = AcceptNum, item_base_id = ItemBaseId, item_num = ItemNum, quality = Quality, progress = Progress}|_T] = TaskList,
            {reply, {TaskId, Status, AcceptNum, ItemBaseId, ItemNum, Quality, Progress}};
        false ->
            ?DEBUG("没有新增可接任务:~w"),
            {ok}
    end;

%% 删除已接任务应该消息是服务器主动发给客户端
%% 测试协议
handle(10206, {TaskId}, _Role) ->
    %% TODO:删除已接任务
    {reply, {TaskId}};

%% 接收任务
handle(10207, {TaskId, NpcId}, Role) -> 
    case handle_accept(#task_param_accept{role = Role, task_id = TaskId, npc_id_accept = NpcId}) of
        {ok, Role1} ->
            {Role2, DailyIds} = activity2:fire_tasks(Role1),
            activity2:push_13803(Role2, DailyIds),  %% 通知客户端增加任务
            {Role3} = accept_task_do(Role2, TaskId),
            {reply, {?true, TaskId}, Role3};
        {false, Reason} ->
            notice:alert(error, Role, Reason),
            {reply, {?false, 0}}
    end;

%% 完成任务
handle(10208, {TaskId, NpcId}, Role = #role{event = Event, link = #link{conn_pid = ConnPid}}) ->
    TaskParamCommit = #task_param_commit{role = Role, task_id = TaskId, npc_id_commit = NpcId},
    role:send_buff_begin(),
    case task:commit_chain(TaskParamCommit) of
        {ok, #task_param_commit{role = NewRole, task_base = TaskBase}} ->
            NewRole2 = role_listener:finish_task(NewRole, TaskId),
            role:send_buff_flush(),
            LogTask = util:fbin(<<"ID:~w">>, [TaskId]),
            NewRole3 = case TaskBase of
                #task_base{type = ?task_type_rc, sec_type = 1} when Event =/= ?event_escort -> %% 护送
                    log:log(log_coin, {<<"护送">>, LogTask, Role, NewRole2}),
                    role_listener:special_event(NewRole2, {30004, 1});
                #task_base{type = ?task_type_rc, sec_type = 1} -> %% 护送
                    misc_mgr:lock(NewRole2, escort),
                    log:log(log_coin, {<<"任务">>, LogTask, Role, NewRole2}),
                    role_listener:special_event(NewRole2, {30004, 1});
                #task_base{type = ?task_type_zrc} -> %% 周日常
                    log:log(log_coin, {<<"任务">>, LogTask, Role, NewRole2}),
                    role_listener:special_event(NewRole2, {30014, 1});
                _ ->
                    log:log(log_coin, {<<"任务">>, LogTask, Role, NewRole2}),
                    log:log(log_stone, {<<"任务">>, LogTask, Role, NewRole2}),
                    NewRole2
            end,

            log:log(log_attainment, {<<"任务">>, LogTask, Role, NewRole2}),
            %% log:log(log_integral, {career_devote, <<"任务">>, [], Role, NewRole}),
            activity2_log:mark_task(NewRole3, TaskId, 2),
            random_award:task(NewRole3, TaskId),
            sys_conn:pack_send(ConnPid, 10208, {?true, TaskId}),
            NewRole4 = task:finish_task_fire_star_dun(NewRole3),
            {ok, NewRole4};
        {false, #task_param_commit{update_role = ?false, reason = Reason}} ->
            role:send_buff_clean(),
            notice:alert(error, Role, Reason),
            {reply, {?false, 0}};
        {false, #task_param_commit{role = NewRole, update_role = ?true, reason = Reason}} ->
            role:send_buff_flush(),
            notice:alert(error, Role, Reason),
            {reply, {?false, 0}, NewRole}
    end;

handle(10209, {TaskId}, Role = #role{id = {RoleId, SrvId},  link = #link{conn_pid = ConnPid}, daily_task = TaskList}) ->
    case lists:keyfind(TaskId, #daily_task.task_id, TaskList) of
        false ->
            TaskParamGiveup = #task_param_giveup{role = Role, task_id = TaskId},
            role:send_buff_begin(),
            case task:giveup_chain(TaskParamGiveup) of
                {ok, #task_param_giveup{role = NewRole}} ->
                    role:send_buff_flush(),
                    log:log(log_coin, {<<"任务">>, util:fbin(<<"放弃ID:~w">>, [TaskId]), Role, NewRole}),
                    notice:alert(succ, Role, ?MSGID(<<"成功放弃任务">>)),
                    sys_conn:pack_send(ConnPid, 10209, {?true, TaskId}),
                    {reply, {?true, TaskId}, NewRole};
                {false, Reason} ->
                    role:send_buff_clean(),
                    notice:alert(error, Role, Reason),
                    {reply, {?false, TaskId}}
            end;
        #daily_task{} ->
            NewList = lists:keydelete(TaskId, #daily_task.task_id, TaskList),
            daily_task_dao:delete_task(RoleId, SrvId, TaskId),
            notice:alert(succ, Role, ?MSGID(<<"成功放弃任务">>)),
            {reply, {?true, TaskId}, Role#role{daily_task = NewList}}
    end;

%% 获取NPC状态信息
%% 协议测试
handle(10211, {}, #role{id = _Rid, task = TaskList, link = #link{conn_pid = ConnPid}}) ->
    Acceptable = task:get_all_type_acceptabel(),
    send_batch_npc_status(acceptable, ConnPid, Acceptable, 1, []),
    send_batch_npc_status(accepted, ConnPid, TaskList, []),
    {ok};

%% GM命令，无条件完成任务
handle(10212, {TaskId}, Role = #role{id = {RoleId, SrvId}, career = Career, link = #link{conn_pid = ConnPid}}) ->
    case task:commit(TaskId, Role) of
        {ok, _Task, NewRole} ->
            ?DEBUG("提交任务成功:~w", [TaskId]),
            {ok, #task_base{type = Type, npc_commit = NpcCommit}} = task_data:get_conf(TaskId),
            task_dao:delete_task(RoleId, SrvId, TaskId),    %% 删除数据库中已接任务
            task:delete_cache(accepted, Type, [TaskId]),    %% 删除已接任务缓存
            send_del_accepted_task(ConnPid, TaskId),        %% 发送删除已接任务消息
            send_upd_npc_status(ConnPid, [{NpcCommit, TaskId, 0}]), %% 删除Npc状态

            %% 添加新的可接任务
            NewAcceptableTaskidList = task:refresh_acceptable_task(by_type, Role, Type, TaskId),
            {ok, Data} = task:get_dict(acceptable, Type),
            AddAcceptable = NewAcceptableTaskidList --  Data,
            case length(AddAcceptable) > 0 of
                true -> %% 有新的可接任务
                    send_batch_npc_status(acceptable, ConnPid, AddAcceptable, 1, []), %% 更新Npc状态
                    send_add_acceptable_tasks(ConnPid, Career, AddAcceptable), %% 推送可接任务
                    task:add_cache(acceptable, Type, AddAcceptable);
                false ->
                    skip 
            end,
            {reply, {1, ?L(<<"提交任务成功">>)}, NewRole};
        {false, Reason} ->
            ?DEBUG("提交任务出错:~s", [Reason]),
            {reply, {0, Reason}, Role};
        {false, Reason, NewRole} ->
            ?DEBUG("提交任务出错:~s", [Reason]),
            {reply, {0, Reason}, NewRole}
    end;

%% 地图资源特别事件
handle(10213, {1016}, Role) ->
    NewRole = role_listener:special_event(Role, {1016, finish}),
    {ok, NewRole};
handle(10213, {MapElemBaseId}, Role) ->
    case map_data_elem:get(MapElemBaseId) of
        false -> {ok};
        _ ->
            case MapElemBaseId of
                1005 -> %% 祈福灯
                    NewRole = role_listener:special_event(Role, {1005, finish}),
                    {ok, NewRole};
                1006 -> %% 五行之阵
                    NewRole = role_listener:special_event(Role, {1006, finish}),
                    {ok, NewRole};
                _ ->
                    {ok}
            end
    end;

%% 接受任务-扣除物品
handle(10215, {TaskId, NpcId, ItemId, Num}, Role) -> 
    case handle_accept(#task_param_accept{role = Role, task_id = TaskId, npc_id_accept = NpcId, litem_id = ItemId, litem_num = Num}) of
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"接受任务成功">>)}, NewRole};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;

%% 立即完成 
handle(10217, {TaskId}, Role) ->
    TaskParamCommit = #task_param_commit{role = Role, task_id = TaskId, finish_imm = ?true},
    role:send_buff_begin(),
    case task:commit_chain(TaskParamCommit) of
        {ok, #task_param_commit{role = NewRole, task_base = #task_base{type = Type}}} ->
            NewRole2 = role_listener:finish_task(NewRole, TaskId),
            role:send_buff_flush(),
            log:log(log_coin, {<<"任务">>, util:fbin(<<"ID:~w">>, [TaskId]), Role, NewRole2}),
            log:log(log_item_del_loss, {<<"任务">>, NewRole2}),
            log:log(log_attainment, {<<"任务">>, <<>>, Role, NewRole2}),

            case lists:member(Type, [?task_type_sm, ?task_type_bh]) of
                true -> role:apply(async, self(), {fun auto_accept_task/2, [Type]});
                false -> ignore
            end,
            {reply, {?true, <<"">>}, NewRole2};
        {false, #task_param_commit{update_role = ?false, reason = ?gold_less}} ->
            role:send_buff_clean(),
            {reply, {?gold_less, ?L(<<"晶钻不足">>)}};
        {false, #task_param_commit{update_role = ?false, reason = Reason}} ->
            role:send_buff_clean(),
            {reply, {?false, Reason}};
        {false, #task_param_commit{role = NewRole, update_role = ?true, reason = ?gold_less}} ->
            role:send_buff_flush(),
            {reply, {?gold_less, ?L(<<"晶钻不足">>)}, NewRole};
        {false, #task_param_commit{role = NewRole, update_role = ?true, reason = Reason}} ->
            role:send_buff_flush(),
            {reply, {?false, Reason}, NewRole}
    end;
%% ------------ 悬赏任务处理------

%% 获取悬赏任务列表
handle(10223, {Page}, _Role) -> 
    Reply = get_task_wanted_by_page(Page),
    {reply, Reply};

%% 接受一个悬赏任务
handle(10224, {TaskId}, Role = #role{pid = Pid}) when is_integer(TaskId) -> 
    Page = task_wanted:get_id_page(TaskId),
    case task_wanted:accept(Role, TaskId) of
        {ok, NewRole} ->
            notice:inform(Pid, ?L(<<"消耗 精力值 10">>)),
            activity:pack_send_table(NewRole),
            PageData = get_task_wanted_by_page(Page),
            role:pack_send(Pid, 10223, PageData),
            {reply, {?true, ?L(<<"成功领取悬赏任务">>)}, NewRole};
        lev_lower ->
            {reply, {?false, ?L(<<"等级不够，不能领取悬赏任务">>)}};
        no_activity ->
            {reply, {?false, ?L(<<"精力值不足10点">>)}};
        timeout_limit ->
            {reply, {?false, util:fbin(?L(<<"请在~w:~w悬赏任务刷新好后再接任务">>), task_wanted:get_next_tick())}};
        accepted ->
            {reply, {?false, util:fbin(?L(<<"您已接受过本时段任务，请~w:~w再来领取">>), task_wanted:get_next_tick())}};
        theirs ->
            PageData = get_task_wanted_by_page(Page),
            role:pack_send(Pid, 10223, PageData),
            {reply, {?false, ?L(<<"你慢了一步，这个任务已经被其他人接了">>)}};
        _ ->
            {reply, {?false, ?L(<<"悬赏任务领取失败">>)}}
    end;

%% 请求是否有未完成的悬赏怪任务
handle(10225, {}, Role) -> 
    Res = task_wanted:has_task(Role),
    {reply, {Res}};

handle(10235, {Event, Target}, Role = #role{}) ->
    Role1 = role_listener:special_event(Role, {Event, Target}),
    {reply, {1}, Role1};


handle(10238, {}, Role = #role{}) ->
    Role1 = role_listener:special_event(Role, {1070, finish}),
    {reply, {}, Role1};

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%% 批量发送Npc状态信息
send_batch_npc_status(acceptable, ConnPid, [TaskId | T], Status, Protos) ->
    {ok, #task_base{npc_accept = NpcAccept, npc_commit = _NpcCommit}} = task_data:get_conf(TaskId),
    case NpcAccept =/= 0 of
        true ->
            send_batch_npc_status(acceptable, ConnPid, T, Status, [{NpcAccept, TaskId, Status} | Protos]);
        false ->
            skip
    end;
send_batch_npc_status(acceptable, ConnPid, [], _Status, Protos) ->
    case length(Protos) > 0 of
        true ->
            send_upd_npc_status(ConnPid, Protos);
        false ->
            skip
    end.

%% 批量发送已接任务Npc状态信息
send_batch_npc_status(accepted, ConnPid, [#task{task_id = TaskId, status = 0} | T], Protos) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{npc_accept = NpcAccept}} ->
            NewProtos = case NpcAccept =/= 0 of true -> [{NpcAccept, TaskId, 2} | Protos]; false -> Protos end,
            send_batch_npc_status(accepted, ConnPid, T, NewProtos);
        _ ->
            send_batch_npc_status(accepted, ConnPid, T, Protos)
    end;
send_batch_npc_status(accepted, ConnPid, [#task{task_id = TaskId, status = 1} | T], Protos) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{npc_commit = NpcCommit}} ->
            NewProtos = case NpcCommit =/= 0 of true ->[{NpcCommit, TaskId, 3} | Protos]; false -> Protos end,
            send_batch_npc_status(accepted, ConnPid, T, NewProtos);
        _ ->
            send_batch_npc_status(accepted, ConnPid, T, Protos)
    end;

send_batch_npc_status(accepted, ConnPid, [], Protos) ->
    case length(Protos) > 0 of
        true ->
            send_upd_npc_status(ConnPid, Protos);
        false ->
            skip
    end.

%% 接受任务入口
handle_accept(TaskParamAccept = #task_param_accept{role = Role}) ->
    role:send_buff_begin(),
    case task:accept_chain(TaskParamAccept) of
        {ok, #task_param_accept{role = NewRole, task_id = TaskId}} ->
            role:send_buff_flush(),
            log:log(log_coin, {<<"任务">>, <<"">>, Role, NewRole}),
            log:log(log_item_del_loss, {<<"任务">>, NewRole}),
            activity2_log:mark_task(NewRole, TaskId, 1),
            {ok, NewRole};
        {false, Reason} ->
            role:send_buff_clean(),
            {false, Reason}
    end.

%% 自动接受任务
auto_accept_task(Role, TaskType) ->
    {ok, List} = case TaskType of
        ?task_type_sm -> role:get_dict(task_acceptable_sm);    %% 师门
        ?task_type_bh -> role:get_dict(task_acceptable_bh)    %% 帮会
    end,
    case List of
        [] -> {ok};
        [TaskId | _] ->
            case handle_accept(#task_param_accept{role = Role, task_id = TaskId, npc_id_accept = uncheck}) of
                {ok, NewRole} ->
                    {ok, NewRole};
                {false, Reason} ->
                    ?ERR("自动接受任务失败[TaskId:~w]Reason:~w", [TaskId, Reason]),
                    {ok}
            end
    end.

accept_growup_task(Role, TaskId) ->
    case handle_accept(#task_param_accept{role = Role, task_id = TaskId}) of
        {ok, Role1} ->
            Role1;
        {false, _Reason} ->
            ?DEBUG("接受成长任务失败 原因 ~w", [_Reason]),
            Role
    end.

%%----------------------------------------------------
%% 业务逻辑主动发送消息
%%----------------------------------------------------

%% Progress -> [#task_progress{}]
convert_progress(Progress) ->
    case Progress of
        [] ->
            [];
        [P = #task_progress{trg_label= star_dungeon, target = {_DunId, Star}}] ->
            [P#task_progress{target = Star}];
        Ret ->
            Ret
    end.

%% cmd:10205 增加已接任务
send_add_accepted_task(ConnPid, #task{task_id = TaskId, status = Status, accept_num = AcceptNum, item_base_id = ItemBaseId, item_num = ItemNum, quality = Quality, progress = Progress}) ->
    ?DEBUG(" ********* 增加已接任务  任务进度: ~p ", [Progress]), 
    sys_conn:pack_send(ConnPid, 10205, {TaskId, Status, AcceptNum, ItemBaseId, ItemNum, Quality, convert_progress(Progress)}).

%% cmd:10202 更新已接任务
send_upd_accepted_task(ConnPid, #task{task_id = TaskId, status = Status, accept_num = AcceptNum, item_base_id = ItemBaseId, item_num = ItemNum, progress = Progress, quality = Quality}) ->
    ?DEBUG(" 更新任务进度  ~p", [Progress]),
    sys_conn:pack_send(ConnPid, 10202, {TaskId, Status, AcceptNum, ItemBaseId, ItemNum, Quality, convert_progress(Progress)}).

%% cmd:10206 删除已接任务
send_del_accepted_task(ConnPid, TaskId) ->
    sys_conn:pack_send(ConnPid, 10206, {TaskId}).

%% cmd:10203 增加可接任务
send_add_acceptable_task(ConnPid, Career, TaskId) ->
    [{TaskId, AcceptNum}] = task:convert_accept_num(acceptable, Career, [TaskId]),
    sys_conn:pack_send(ConnPid, 10203, {TaskId, AcceptNum}).

%% cmd:10212 增加可接任务列表
send_add_acceptable_tasks(ConnPid, Career, TaskList) ->
    sys_conn:pack_send(ConnPid, 10212, {task:convert_accept_num(acceptable, Career, TaskList)}).

%% cmd:10204 删除可接任务
send_del_acceptable_task(ConnPid, TaskId) ->
    sys_conn:pack_send(ConnPid, 10204, {TaskId}).

%% cmd:10211 刷新NPC任务状态
send_upd_npc_status(_ConnPid, []) -> ok;
send_upd_npc_status(ConnPid, NpcStatusList) ->
    List = [{NpcId, TaskId, Status} || {NpcId, TaskId, Status} <- NpcStatusList, NpcId > 0],
    case List of
        [] -> ok;
        _ -> sys_conn:pack_send(ConnPid, 10211, {List})
    end.

%% 获取某一页的悬赏任务数据
get_task_wanted_by_page(Page) ->
    {NewPage, List, Total} = task_wanted:get_info({list, Page}),
    F = fun(#task_wanted_data{id = Id, type = Type, npc_base_id = NpcId, map_id = MapId, x = X, y = Y, owner_id = OwnerId, owner_name = Name, status = Status, reward = Reward, accepted = Accepted}) ->
            {NewStatus, Timeout} = task_wanted:get_status_timeout(Type, Status, Accepted),
            case OwnerId of
                {0, <<>>} ->
                    {Id, 0, NpcId, MapId, X, Y, Reward, NewStatus, 0, <<>>, <<>>, Timeout};
                {Rid, SrvId} ->
                    {Id, Type, NpcId, MapId, X, Y, Reward, NewStatus, Rid, SrvId, Name, Timeout}
            end
    end,
    NewList = [F(T) || T <- List],
    {NewPage, Total, NewList}.

%% 接受完某任务所需要做的操作，比如打开某个副本等
accept_task_do(Role, AcceptedTaskId) ->
     case task_data:get_conf(AcceptedTaskId) of
         {ok, #task_base{accept_open_map = All}} -> 
             accept_task_open_map(Role, All)
         %%{false, Reason} -> {false, Reason}
     end.

 %% 接受任务要开启的地图
 accept_task_open_map(Role, []) -> {Role};
 accept_task_open_map(Role, [{IdType, IdVal} | T]) ->
     case open(Role, IdType, IdVal) of
         {false, Role1} -> {Role1};
         {ok, NewRole} ->
             accept_task_open_map(NewRole, T)
     end.

open(Role = #role{pid = RolePid, dungeon = Dungeon}, dungeon_id, Id) ->
    ?DEBUG("  ROLE DUNGEON : ~w", [Dungeon]),
    NewDungeon = dungeon_api:unlock_dungeon(RolePid, Dungeon, Id),
    {ok, Role#role{dungeon = NewDungeon}};
open(Role = #role{link = #link{conn_pid = ConnPid}}, map_id, Id) ->
    sys_conn:pack_send(ConnPid, 10102, {Id}),
    Role1 =
    case Id =/= 1400 of %% 新手村特殊处理。因为创号时就已经设了新手村的新篇章，在这处理防止接受任务再次触发。
        true ->
            case map_data:get(Id) of
                #map_data{type = 1} ->
                    %% sys_conn:pack_send(ConnPid, 10163, {Id}),
                    Role#role{scene_id = Id};
                _ ->
                    Role
            end;
        false ->
            Role
    end,
    {ok, Role1#role{max_map_id = Id}};
open(Role = #role{link = #link{conn_pid = ConnPid}, dungeon_map = DungeonMap}, dungeon_map_id, Id) ->
    sys_conn:pack_send(ConnPid, 13506, {Id}),
    {ok, Role#role{dungeon_map = [{Id, 0, 0, ?false, ?false, []} | DungeonMap]}};
open(Role, _Type, _Id) ->
    {false, Role}.

%% 增一个任务信, 推送 10226
pack_send_10226(#role{link = #link{conn_pid = ConnPid}, task_role = #task_role{daily_info = #daily_info{fresh_cnt = FreshCnt, accept_delegate_cnt = AcceptCnt}}}, Data) ->
    sys_conn:pack_send(ConnPid, 10226, {1, FreshCnt, AcceptCnt, [Data]}).

