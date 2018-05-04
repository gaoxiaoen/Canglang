%%----------------------------------------------------
%% @doc 运镖系统远程过程调用模块
%%
%% <pre>
%% 运镖系统远程过程调用模块
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(escort_rpc).

-export([
        handle/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("escort.hrl").
-include("task.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("attr.hrl").
-include("activity.hrl").
%%
-include("misc.hrl").


%% 打开接镖界面 
handle(13100, {}, Role = #role{escort = _Escort}) ->
    role:send_buff_begin(),
    case escort:accept(Role) of
        {ok, NewRole, Quality, Times} ->
            role:send_buff_flush(),
            {reply, {?escort_op_succ, ?L(<<"接受成功">>), Quality, Times}, NewRole};
        {false, Reason} ->
            role:send_buff_clean(),
            {reply, {?escort_op_fail, Reason, ?escort_quality_fail, 0}}
    end;

%% 刷镖
handle(13101, {_RefreshType}, _Role = #role{activity = #activity{summary = Summary}}) when Summary < 20 ->
    {reply, {?escort_op_fail, ?L(<<"精力值不足20点，不能护送美女">>), ?escort_quality_fail}};
handle(13101, {RefreshType}, Role) ->
    role:send_buff_begin(),
    case escort:refresh(Role, RefreshType) of
        {ok, NewRole, NewQuality} ->
            role:send_buff_flush(),
            {reply, {?escort_op_succ, ?L(<<"刷新美女成功!">>), NewQuality}, NewRole};
        {false, gold_notenough} ->
            role:send_buff_clean(),
            {reply, {2, ?L(<<"晶钻不足">>), ?escort_quality_fail}};
        {false, Reason} ->
            role:send_buff_clean(),
            {reply, {?escort_op_fail, Reason, ?escort_quality_fail}}
    end;

%% 开始运镖
handle(13102, {?escort_type_coin, _NpcId}, _Role = #role{attr = #attr{fight_capacity = FightCapacity}}) when FightCapacity < 3500 ->
    {reply, {?escort_op_fail, ?L(<<"你战斗力不够3500，还不具备保护美女的能力。\n请选择低调护送。低调护送美女，不能被打劫！">>), 0, 0}};
handle(13102, {?escort_type_coin, _NpcId}, _Role = #role{escort = #escort{quality = ?escort_quality_white}}) ->
    {reply, {?false, ?L(<<"素女只能选择绑定护送！">>), 0, 0}};
handle(13102, {EscortType, NpcId}, Role = #role{anticrack = Anticrask}) ->
    {ok, Data} = task:get_dict(acceptable, ?task_type_rc),
    Fun = fun(TaskId) ->
        {ok, #task_base{type = Type, sec_type = SecType}} = task_data:get(TaskId),
        case Type =:= ?task_type_rc andalso SecType =:= 1 of
            true -> true;
            false -> false
        end
    end,
    TaskIds = lists:filter(Fun, Data),
    case length(TaskIds) > 0 of
        true ->
            [TaskId | _T] = TaskIds,
            TaskParamAccept = #task_param_accept{role = Role, task_id = TaskId, npc_id_accept = NpcId, escort_type = EscortType},
            role:send_buff_begin(),
            case task:accept_chain(TaskParamAccept) of
                {ok, #task_param_accept{role = NewRole}} ->
                    role:send_buff_flush(),
                    log:log(log_coin, {<<"运镖">>, <<"">>, Role, NewRole}),
                    {reply, {?true, ?L(<<"接受任务成功">>), 0, 0}, NewRole#role{anticrack = Anticrask#anticrack{escort = util:unixtime()}}};
                {false, Reason} ->
                    {ok, NewData} = task:get_dict(acceptable, ?task_type_rc),
                    case lists:member(TaskId, NewData) of
                        true -> ignore;
                        false -> role:put_dict(task_acceptable_rc, [TaskId | NewData])
                    end,
                    role:send_buff_clean(),
                    {reply, {?false, Reason, 0, 0}}
            end;
        false ->
            {reply, {?escort_op_fail, ?L(<<"没有护送任务">>), 0, 0}}
    end;

%% 放弃运镖
handle(13103, {}, Role = #role{task = TaskList}) ->
    Fun = fun(#task{task_id = TaskId}) ->
        {ok, #task_base{type = Type, sec_type = SecType}} = task_data:get(TaskId),
        case Type =:= ?task_type_rc andalso (SecType =:= 1 orelse SecType =:= 22 orelse SecType =:= 27) of
            true -> true;
            _ -> false
        end
    end,
    NewTaskList = lists:filter(Fun, TaskList),
    case length(NewTaskList) > 0 of
        true ->
            [#task{task_id = TaskId} | _T] = NewTaskList,
            TaskParamGiveup = #task_param_giveup{role = Role, task_id = TaskId},
            role:send_buff_begin(),
            case task:giveup_chain(TaskParamGiveup) of
                {ok, #task_param_giveup{role = NewRole}} ->
                    role:send_buff_flush(),
                    {reply, {?escort_op_succ, ?L(<<"操作成功">>)}, NewRole};
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {?escort_op_fail, Reason}}
            end;
        false ->
            {reply, {?escort_op_fail, ?L(<<"你没有护送任务">>)}}
    end;

%% 交镖
handle(13104, {}, Role) ->
    case escort:finish(Role) of
        {ok, NewRole} ->
            ?DEBUG("=================交镖"),
            log:log(log_coin, {<<"交镖">>, <<"">>, Role, NewRole}),
            {reply, {?escort_op_succ, ?L(<<"操作成功">>)}, NewRole};
        {false, Reason} ->
            {reply, {?escort_op_fail, Reason}}
    end;

%% 获取双倍运镖时间值
handle(13106, {}, _Role) ->
    case escort_mgr:time_leave() of
        {ok, Status, TimeLeave} ->
            {reply, {Status, TimeLeave}};
        _ ->
            {reply, {0, 0}}
    end;

%% 获取运镖任务剩余次数 
handle(13107, {1}, Role) ->
    case escort:get_task_leave(Role) of
        {ok, Num} -> {reply, {Num}};
        {false, _Reason} -> {reply, {0}}
    end;
handle(13107, {2}, Role) ->
    Result = case escort_cyj_mgr:get_escort_act_type() of
        ?escort_act_type_child ->
            escort_child:get_task_leave(Role);
        _ ->
            escort_cyj:get_task_leave(Role)
    end,
    case Result of
        {ok, Num} -> {reply, {Num}};
        {false, _Reason} -> {reply, {0}}
    end;

%% 打开护送小屁孩
handle(13108, {}, Role) ->
    Result = case escort_cyj_mgr:get_escort_act_type() of
        ?escort_act_type_child ->
            escort_child:open_panel(Role);
        _ ->
            escort_cyj:open_panel(Role)
    end,
    case Result of
        {ok, NewRole, Quality, Times} ->
            {reply, {?true, <<"">>, Quality, Times}, NewRole};
        {false, Reason} ->
            {reply, {?false, Reason, ?escort_quality_fail, 0}}
    end;

%% 刷小屁孩
handle(13109, {RefreshType}, Role) ->
    {Result, Msg} = case escort_cyj_mgr:get_escort_act_type() of
        ?escort_act_type_child ->
            {escort_child:refresh(Role, RefreshType), ?L(<<"刷小屁孩成功!">>)};
        ?escort_act_type_cyj ->
            {escort_cyj:refresh(Role, RefreshType), ?L(<<"刷重阳节美女成功!">>)};
        ?escort_act_type_chrismas ->
            {escort_cyj:refresh(Role, RefreshType), ?L(<<"刷圣诞老人成功!">>)};
        ?escort_act_type_gen ->
            {escort_cyj:refresh(Role, RefreshType), ?L(<<"刷重美女成功!">>)}
    end,
    case Result of
        {ok, NewRole, NewQuality} ->
            {reply, {?escort_op_succ, Msg, NewQuality}, NewRole};
        {false, gold_notenough} ->
            {reply, {2, ?L(<<"晶钻不足">>), ?escort_quality_fail}};
        {false, Reason} ->
            {reply, {?escort_op_fail, Reason, ?escort_quality_fail}}
    end;

%% 开始护送小屁孩
handle(13110, {?escort_type_coin, _NpcId}, _Role = #role{attr = #attr{fight_capacity = FightCapacity}}) when FightCapacity < 2800 ->
    Msg = case escort_cyj_mgr:get_escort_act_type() of
        ?escort_act_type_child ->    
            ?L(<<"你战斗力不够2800，还不具备保护小屁孩的能力。\n请选择低调护送。低调护送不能被打劫！">>);
        ?escort_act_type_cyj ->
            ?L(<<"你战斗力不够2800，还不具备保护美女的能力。\n请选择低调护送。低调护送不能被打劫！">>);
        ?escort_act_type_chrismas ->
            ?L(<<"你战斗力不够2800，还不具备保护圣诞老人的能力。\n请选择低调护送。低调护送不能被打劫！">>);
        ?escort_act_type_gen ->
            ?L(<<"你战斗力不够2800，还不具备保护圣诞老人的能力。\n请选择低调护送。低调护送不能被打劫！">>)
    end,
    {reply, {?false, Msg, 0, 0}};
%%handle(13110, {?escort_type_coin, _NpcId}, _Role) when ?escort_daily_type =:= escort_cyj ->
%%    {reply, {?false, ?L(<<"护送重阳节美女只能选择低调护送">>), 0, 0}};
handle(13110, {EscortType, NpcId}, Role) ->
    {Result, Msg} = case escort_cyj_mgr:get_escort_act_type() of
        ?escort_act_type_child ->
            {22, ?L(<<"护送小屁孩">>)};
        ?escort_act_type_chrismas ->
            {27, ?L(<<"护送圣诞老人">>)};
        ?escort_act_type_cyj ->
            {27, ?L(<<"护送重阳节美女">>)};
        ?escort_act_type_gen ->
            {27, ?L(<<"护送重阳节美女">>)}
    end,
    {ok, Data} = task:get_dict(acceptable, ?task_type_rc),
    Fun = fun(TaskId) ->
        {ok, #task_base{type = Type, sec_type = SecType}} = task_data:get(TaskId),
        case Type =:= ?task_type_rc andalso SecType =:= Result of
            true -> true;
            false -> false
        end
    end,
    TaskIds = lists:filter(Fun, Data),
    case length(TaskIds) > 0 of
        true ->
            [TaskId | _T] = TaskIds,
            TaskParamAccept = #task_param_accept{role = Role, task_id = TaskId, npc_id_accept = NpcId, escort_type = EscortType},
            role:send_buff_begin(),
            case task:accept_chain(TaskParamAccept) of
                {ok, #task_param_accept{role = NewRole}} ->
                    role:send_buff_flush(),
                    log:log(log_coin, {Msg, <<"">>, Role, NewRole}),
                    {reply, {?true, ?L(<<"接受任务成功">>), 0, 0}, NewRole};
                {false, Reason} ->
                    {ok, NewData} = task:get_dict(acceptable, ?task_type_rc),
                    case lists:member(TaskId, NewData) of
                        true -> ignore;
                        false -> role:put_dict(task_acceptable_rc, [TaskId | NewData])
                    end,
                    role:send_buff_clean(),
                    {reply, {?false, Reason, 0, 0}}
            end;
        false ->
            {reply, {?escort_op_fail, ?L(<<"没有护送任务">>), 0, 0}}
    end;


%%-------------------------------------------
%% 重阳节护送美女登高活动
%%-------------------------------------------
%% 猜拳游戏
handle(13115, {Finger}, Role = #role{event = ?event_escort_cyj}) ->
    case can_play_game(Role, finger_guessing) of
        true ->
            escort_cyj:check_finger_guessing_result(Role, Finger);
        _ -> {ok}
    end;
handle(13115, _, _) ->
    {ok};

%% 对诗游戏获取问题
handle(13116, _, Role = #role{event = ?event_escort_cyj}) ->
    case can_play_game(Role, question) of
        true ->
            Question = escort_cyj:choose_question(),
            {reply, Question};
        _ -> {ok}
    end;
handle(13116, _, _) ->
    {ok};

%% 对诗问题校对答案
handle(13117, {Id, Answer}, Role = #role{event = ?event_escort_cyj}) ->
    case can_play_game(Role, question) of
        true ->
            escort_cyj:check_question_result(Role, Id, Answer);
        _ -> {ok}
    end;
handle(13117, _, #role{event = ?event_escort_cyj}) ->
    {ok};

%% 丢骰子游戏
handle(13118, {RolePoint}, Role = #role{event = ?event_escort_cyj}) ->
    case can_play_game(Role, roll_dice) of
        true ->
            escort_cyj:check_roll_dice_result(Role, RolePoint);
        _ -> {ok}
    end;
handle(13118, _, _) ->
    {ok};

%% 容错函数
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%% 判断是否有指定的重阳节护送任务 -> true|false
%% TaskId = integer()  指定的重阳节护送任务环节
can_play_game(#role{task = TaskList}, GameType) ->
    EscortTasks = [Task || Task = #task{type = ?task_type_rc, sec_type = 27} <- TaskList],
    case EscortTasks of
        [EscortTask|_] -> can_play_game(EscortTask, GameType);
        _ -> false
    end;
can_play_game(#task{progress = [#task_progress{value = 0}]}, finger_guessing) -> true;
can_play_game(#task{progress = [#task_progress{value = 1}]}, question) -> true;
can_play_game(#task{progress = [#task_progress{value = 2}]}, roll_dice) -> true;
can_play_game(_, _) -> false.
