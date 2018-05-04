%%----------------------------------------------------
%% @doc 可接任务过滤
%%
%% <pre>
%% 可接任务过滤
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(task_filter).

-export([
        filter/4
        ,time_diff/1
    ]
).

-include("common.hrl").
-include("task.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("guild.hrl").
-include("activity.hrl").
-include("vip.hrl").

%%----------------------------------------------------
%% 接口 
%%----------------------------------------------------
%% 过滤可接任务
filter([], _Role, TaskIdList, _TaskFilterParam) ->
    TaskIdList;
filter([Opt | T], Role, TaskIdList, TaskFilterParam) ->
    NewTaskIdList = filter(Opt, Role, TaskIdList, TaskFilterParam),
    filter(T, Role, NewTaskIdList, TaskFilterParam);
    
%% 任务类型
filter(type, Role = #role{id = {_, SrvId}}, [27006 | T], Param = #task_fparam{type = ?task_type_zhix}) ->
    case lists:member(util:platform(SrvId), ["4399", "360", "qq163"]) of
        true -> [27006 | filter(type, Role, T, Param)];
        false -> filter(type, Role, T, Param)
    end;
%% 缘分摇一摇的最低要求
filter(type, Role = #role{attr = Attr, lev = Lev}, [83023 | T], Param = #task_fparam{type = ?task_type_xx}) ->
    case Attr of
        #attr{fight_capacity = Fc} when Lev >= 52 andalso Fc >= 6500 ->
            [83023 | filter(type, Role, T, Param)];
        _ -> 
            filter(type, Role, T, Param)
    end;
filter(type, Role, [TaskId | T], Param = #task_fparam{type = Type}) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{type = TaskType}} ->
            case TaskType =:= Type of
                true -> [TaskId | filter(type, Role, T, Param)];
                false -> filter(type, Role, T, Param)
            end;
        {false, _Reason} ->
            ?ERR("过滤可接任务[Id=~w]出错:~s", [TaskId, _Reason]),
            filter(type, Role, T, Param)
    end;

%% 职业
filter(career, Role = #role{career = Career}, [TaskId | T], Param) ->
    {ok, #task_base{career = TaskCareer}} = task_data:get_conf(TaskId),
    case TaskCareer =:= 9 orelse TaskCareer =:= Career of
        true -> [TaskId | filter(career, Role, T, Param)];
        false -> filter(career, Role, T, Param)
    end;

%% 完成一次任务可过滤
filter(finish_one, Role, [TaskId | T], Param = #task_fparam{finish_task_list = FinishTaskList}) ->
    case get_finish_task(TaskId, FinishTaskList) of
        not_found -> [TaskId | filter(finish_one, Role, T, Param)];
        _ -> filter(finish_one, Role, T, Param)
    end;

%% 重复多次的任务
filter(finish_num, Role, [TaskId | T], Param = #task_fparam{finish_task_list = FinishTaskList}) ->
    case lists:keyfind(TaskId, #task_finish.task_id, FinishTaskList) of
        TaskFinish = #task_finish{} ->
            case filter_finish_num(exist, Role, TaskId, TaskFinish, Param) of
                true -> 
                    [TaskId | filter(finish_num, Role, T, Param)];
                false -> 
                    filter(finish_num, Role, T, Param)
            end;
        false ->
            case filter_finish_num(non_exist, Role, TaskId, false, Param) of
                true -> 
                    [TaskId | filter(finish_num, Role, T, Param)];
                false -> 
                    filter(finish_num, Role, T, Param)
            end
    end;

%% 过滤已接任务
filter(accepted, Role, [TaskId | T], Param = #task_fparam{type = ?task_type_zrc, accept_task_list = AcceptTaskList}) ->
    case filter_has_accepted_zrc(AcceptTaskList) of
        true -> [];
        false ->
            case lists:member(TaskId, AcceptTaskList) of
                true -> filter(accepted, Role, T, Param);
                false -> [TaskId | filter(accepted, Role, T, Param)]
            end
    end;
filter(accepted, Role, [TaskId | T], Param = #task_fparam{accept_task_list = AcceptTaskList}) ->
    case lists:member(TaskId, AcceptTaskList) of
        true -> filter(accepted, Role, T, Param);
        false -> [TaskId | filter(accepted, Role, T, Param)]
    end;

%% 前置任务
filter(prev, Role, [TaskId | T], Param) ->
    {ok, #task_base{prev = PrevList}}= task_data:get_conf(TaskId),
    case is_list(PrevList) andalso length(PrevList) > 0 of
        true ->
            case filter_prev(TaskId, PrevList, Param) of
                true -> [TaskId | filter(prev, Role, T, Param)];
                false -> filter(prev, Role, T, Param)
            end;
        false -> [TaskId | filter(prev, Role, T, Param)]
    end;

%% 接受任务条件
filter(cond_accept, #role{guild = #role_guild{gid = GuildId}}, [_TaskId | _T], #task_fparam{type = ?task_type_bh}) when GuildId =:= 0 ->
    [];
%% filter(cond_accept, Role = #role{guild = #role_guild{gid = GuildId}}, [TaskId | T], Param = #task_fparam{type = ?task_type_rc}) ->
%%     {ok, #task_base{cond_accept = CondAccept, type = Type, sec_type = SecType}} = task_data:get(TaskId),
%%     case Type =:= ?task_type_rc andalso SecType =:= 11 andalso GuildId =:= 0 of %% 日常兑换任务需要加入帮会才可以换
%%         true -> filter(cond_accept, Role, T, Param);
%%         false ->
%%             case task:check_finish_cond(CondAccept, Role, []) of
%%                 {true, _} -> [TaskId | filter(cond_accept, Role, T, Param)];
%%                 {false, _Msg} -> filter(cond_accept, Role, T, Param)
%%             end
%%     end;
filter(cond_accept, Role = #role{guild = #role_guild{gid = GuildId}}, [TaskId | T], Param) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{type = ?task_type_rc, sec_type = 14, cond_accept = CondAccept}} -> %% vip日常任务
            #vip{expire = Expire} = Role#role.vip,
            case util:unixtime() < Expire of
                true -> 
                    case task:check_finish_cond(CondAccept, Role, []) of
                        {true, _} -> [TaskId | filter(cond_accept, Role, T, Param)];
                        {false, _Msg} -> filter(cond_accept, Role, T, Param)
                    end;
                false -> filter(cond_accept, Role, T, Param)
            end;
        {ok, #task_base{type = ?task_type_rc, sec_type = 22, cond_accept = CondAccept}} -> %% 小屁孩活动
            case escort_child_mgr:is_escorting() of
                true -> 
                    case task:check_finish_cond(CondAccept, Role, []) of
                        {true, _} -> [TaskId | filter(cond_accept, Role, T, Param)];
                        {false, _Msg} -> filter(cond_accept, Role, T, Param)
                    end;
                _ -> filter(cond_accept, Role, T, Param)
            end;
        {ok, #task_base{type = ?task_type_rc, sec_type = 27, cond_accept = CondAccept}} -> %% 重阳节护送美女登高活动
            case escort_cyj_mgr:is_escorting() of
                true -> 
                    case task:check_finish_cond(CondAccept, Role, []) of
                        {true, _} -> [TaskId | filter(cond_accept, Role, T, Param)];
                        {false, _Msg} -> filter(cond_accept, Role, T, Param)
                    end;
                _ -> filter(cond_accept, Role, T, Param)
            end;
        {ok, #task_base{type = ?task_type_rc, sec_type = 16, cond_accept = CondAccept}} -> %% 帮贡
            case GuildId =/= 0 of
                true ->
                    case task:check_finish_cond(CondAccept, Role, []) of
                        {true, _} -> [TaskId | filter(cond_accept, Role, T, Param)];
                        {false, _Msg} -> filter(cond_accept, Role, T, Param)
                    end;
                false -> filter(cond_accept, Role, T, Param)
            end;
        {ok, #task_base{task_id = 27030, type = ?task_type_zhix, cond_accept = CondAccept}} -> %% 夫妻任务
            case ?task_poll_end > util:unixtime() of
                true ->
                    case task:check_finish_cond(CondAccept, Role, []) of
                        {true, _} -> [TaskId | filter(cond_accept, Role, T, Param)];
                        {false, _Msg} -> filter(cond_accept, Role, T, Param)
                    end;
                _ ->
                    filter(cond_accept, Role, T, Param)
            end;
        {ok, #task_base{cond_accept = CondAccept}} ->
            case task:check_finish_cond(CondAccept, Role, []) of
                {true, _} -> [TaskId | filter(cond_accept, Role, T, Param)];
                {false, _Msg} -> filter(cond_accept, Role, T, Param)
            end;
        _ -> filter(cond_accept, Role, T, Param)
    end;

%% 同类型任务只能接一个
%% 环任务
filter(only_one, _Role = #role{career = Career}, [TaskId | T], #task_fparam{is_ring = ?true, type = Type, finish_task_list = FinishTaskList, accept_task_list = AcceptTaskList}) ->
    case filter_ring_only_one(accepted, AcceptTaskList, Type) of
        true ->
            FnsMaxLev = max_lev_task_finished(FinishTaskList),
            RingHeadList = case Type of
                ?task_type_sm -> task_data_ring:get_ring_head(Type, Career);
                ?task_type_bh -> task_data_ring:get_ring_head(Type)
            end,
            NotRingHead = [TaskId | T] -- RingHeadList,
            case not_ring_head_lev_task(NotRingHead, FnsMaxLev) of
                {ok, TaskId2} -> [TaskId2];
                false ->
                    {MaxTaskId, MaxLev} = max_lev_task_acceptable([TaskId | T]),
                    case FnsMaxLev > MaxLev of
                        true -> [];
                        false -> 
                            [MaxTaskId]
                    end
            end;
        false -> []
    end;

%% 日常任务
%% 一种日常任务同时只能接一个任务
filter(only_one, _Role = #role{lev = Lev, attr = Attr}, [TaskId | T], #task_fparam{is_ring = ?false, type = ?task_type_rc, accept_task_list = AcceptTaskList, finish_task_list = FinishTaskList}) ->
    %% 夫妻任务要特殊处理
    WedTasks = case Attr of
        #attr{fight_capacity = Fc} when Lev >= 55 andalso Fc >= 6500 ->
            [85001, 85002, 85003, 85004, 85005, 85006, 85007];
        #attr{fight_capacity = Fc} when Lev >= 52 andalso Fc >= 6500 ->
            [85001, 85002, 85003, 85004, 85005, 85006];
        _ when Lev >= 55 ->
            [85001, 85002, 85003, 85005, 85006, 85007];
        _ -> 
            [85001, 85002, 85003, 85005, 85006]
    end,
    TaskTupleList = max_lev_task_rc_acceptable([TaskId | T], WedTasks),
    TaskTupleList2 = max_lev_task_rc_finished(FinishTaskList, TaskTupleList),
    TaskTupleList3 = filter_rc_only_one(accepted, AcceptTaskList, TaskTupleList2),
    [RcTaskId || {_SecType, RcTaskId, _Lev} <- TaskTupleList3];

%% 周日常
%% 某天只能接某个任务 
filter(only_one, #role{lev = Lev, activity = #activity{reg_time = RegTime}}, [TaskId | T], Param = #task_fparam{is_ring = ?false, type = ?task_type_zrc}) ->
    WeekTaskList = lists:reverse(task_data_ring:get(daily)),
    TaskIdList = get_week_task_list(WeekTaskList, Lev),
    case length(TaskIdList) of
        0 -> [];
        Length ->
            RegDate = time_diff(RegTime),
            ListIndex = (RegDate rem Length) + 1,
            TargetTaskId = lists:nth(ListIndex, TaskIdList),
            filter_only_one_week(TargetTaskId, [TaskId | T], Param)
    end;

%% 修行任务 同一类型只可以接受四次
%% 这个限制目前版本去掉 Jange 2012/8/21
filter(four_per_type, Role, [TaskId | T], Param = #task_fparam{type = ?task_type_xx, finish_task_list = FinishTaskList}) ->
    FinishNum = [FNum || #task_finish{finish_num = FNum} <- FinishTaskList],
    case lists:sum(FinishNum) >= 10 of
        true -> 
            [];
        false ->
            case task_data:get_conf(TaskId) of
                {ok, #task_base{type = ?task_type_xx}} ->
                        [TaskId | filter(four_per_type, Role, T, Param)];
                _ -> 
                    filter(four_per_type, Role, T, Param)
            end
    end;

%% 根据等级过滤某几个指定的支线任务
filter(lev_special, Role = #role{lev = Lev}, [TaskId | T], Param) ->
    FilterList = [26013, 26014, 26015, 26016],
    case Lev > 45 andalso lists:member(TaskId, FilterList) of
        true ->
            filter(lev_special, Role, T, Param);
        _ -> 
            [TaskId | filter(lev_special, Role, T, Param)]
    end;

%% 空任务列表
filter(_Opt, _Role, [], _TaskFilterParam) ->
    [];
%% 容错函数
filter(_Opt, _Role, TaskIdList, _TaskFilterParam = #task_fparam{type = _Type}) ->
    ?DEBUG("[任务系统]未处理过滤类型[Opt:~w, Type:~w]", [_Opt, _Type]),
    TaskIdList.

%%----------------------------------------------------
%% 私有函数 
%%----------------------------------------------------
%% 获取完成任务信息 
get_finish_task(TaskId, [TaskFinish = #task_finish{task_id = FinishTaskId} | T]) ->
    case TaskId =:= FinishTaskId of
        true -> TaskFinish;
        false -> get_finish_task(TaskId, T)
    end;
get_finish_task(_TaskId, []) ->
    not_found.

%% @spec filter_finish_num(P...) -> true | false
%% 二级过滤:完成次数
%% 已有完成记录  && 非环任务 && 日常任务
filter_finish_num(exist, _Role, TaskId, #task_finish{}, #task_fparam{is_ring = ?false, type = ?task_type_rc, finish_task_list = FinishTaskList}) ->
    {ok, #task_base{times = Times, sec_type = SecType}} = task_data:get_conf(TaskId),
    FtlFinishNumList = [FtlFinishNum || #task_finish{sec_type = FtlSecType, finish_num = FtlFinishNum} <- FinishTaskList, FtlSecType =:= SecType],
    case Times > lists:sum(FtlFinishNumList) of
        true -> true;
        false -> false 
    end;
%% 已有完成记录 && 非环任务
filter_finish_num(exist, _Role, TaskId, #task_finish{finish_num = FinishNum}, #task_fparam{is_ring = ?false}) ->
    {ok, #task_base{times = Times}} = task_data:get_conf(TaskId),
    case Times > FinishNum of
        true -> true;
        false -> false 
    end;
%% 已有完成记录 && 环任务
filter_finish_num(exist, Role, TaskId, #task_finish{finish_num = FinishNum}, #task_fparam{is_ring = ?true, type = Type, finish_task_list = FinishTaskList}) ->
    {ok, #task_base{times = Times}} = task_data:get_conf(TaskId),
    RingHeadList = get_ring_head(Type, Role),
    case lists:member(TaskId, RingHeadList) of
        true -> %% 环头任务
            RingInfo = get_ringinfo_by_head(Type, TaskId),
            EndRingTaskId = lists:nth(length(RingInfo), RingInfo),
            case lists:keyfind(EndRingTaskId, #task_finish.task_id, FinishTaskList) of %% 环尾任务完成后，环头任务可再接
                #task_finish{task_id = EndRingTaskId, finish_num = EndFinishNum} ->
                    case FinishNum =< EndFinishNum of
                        true -> %% 环尾任务已经结束
                            AllNum = ring_task_finish_num(FinishTaskList, RingHeadList),
                            case AllNum < Times of
                                true -> true;
                                false -> false
                            end;
                        false -> false
                    end;
                false -> %% 没有环尾任务历史
                    AllNum = ring_task_finish_num(FinishTaskList, RingHeadList),
                    case AllNum > 0 of %% 第一环的情况 上一级别的环任务做完后才可以开始新一环的任务
                        true -> false;
                        false -> true
                    end
            end;
        false -> %% 非环头任务
            case FinishNum < Times of
                true -> 
                    true;
                false -> false
            end
    end;
%% 木有已完成记录 && 环任务
filter_finish_num(non_exist, Role, TaskId, _False, #task_fparam{is_ring = ?true, type = Type, finish_task_list = FinishTaskList}) ->
    {ok, #task_base{times = Times}} = task_data:get_conf(TaskId),
    RingHeadList = get_ring_head(Type, Role),
    case lists:member(TaskId, RingHeadList) of
        true ->
            AllNum = ring_task_finish_num(FinishTaskList, RingHeadList),
            case AllNum < Times of
                true -> 
                    true;
                false -> 
                    false %% 如果今天已经完成了上一级别的任务，升级后不可以再接
            end;
        false -> 
            true 
    end;

%% 木有已完成记录 && 日常任务
filter_finish_num(non_exist, _Role, TaskId, _False, #task_fparam{is_ring = ?false, type = ?task_type_rc, finish_task_list = FinishTaskList}) ->
    {ok, #task_base{times = Times, sec_type = SecType}} = task_data:get_conf(TaskId),
    TFList = [TFFinishNum || #task_finish{type = TFType, sec_type = TFSecType, finish_num = TFFinishNum} <- FinishTaskList, TFType =:= ?task_type_rc, TFSecType =:= SecType], 
    TotalTimes = lists:sum(TFList),
    case Times > TotalTimes of
        true -> true; 
        false -> false
    end;

%% 木有已完成记录
filter_finish_num(non_exist, _Role, TaskId, _False, #task_fparam{is_ring = ?false, type = ?task_type_zrc, finish_task_list = FinishTaskList}) ->
    {ok, #task_base{times = Times}} = task_data:get_conf(TaskId),
    FtlFinishNumList = [FtlFinishNum || #task_finish{type = Type, finish_num = FtlFinishNum} <- FinishTaskList, Type =:= ?task_type_zrc],
    case Times > lists:sum(FtlFinishNumList) of
        true -> true;
        false -> false
    end;

%% 木有已完成记录
filter_finish_num(non_exist, _Role, _TaskId, _False, #task_fparam{is_ring = ?false}) ->
    true.

%% 前置任务条件
%% 非环任务
filter_prev(TaskId, [PrevTaskId | T], Param = #task_fparam{is_ring = ?false, finish_task_list = FinishTaskList}) ->
    case lists:keyfind(PrevTaskId, #task_finish.task_id, FinishTaskList) of
        false -> 
            false;
        _ -> 
            filter_prev(TaskId, T, Param)
    end;
filter_prev(_TaskId, [], #task_fparam{is_ring = ?false}) ->
    true;
%% 环任务
filter_prev(TaskId, [PrevTaskId | _], #task_fparam{is_ring = ?true, finish_task_list = FinishTaskList}) ->
    case lists:keyfind(PrevTaskId, #task_finish.task_id, FinishTaskList) of
        #task_finish{finish_num = PrevNum} ->
            case lists:keyfind(TaskId, #task_finish.task_id, FinishTaskList) of
                #task_finish{finish_num = CurrNum} ->
                    case PrevNum > CurrNum of
                        true -> true;
                        false -> false
                    end;
                false -> true
            end;
        false -> false
    end.

%% 获取环头信息
get_ring_head(?task_type_sm, #role{career = Career}) ->
    task_data_ring:get_ring_head(?task_type_sm, Career);
get_ring_head(?task_type_bh, _Role) ->
    task_data_ring:get_ring_head(?task_type_bh).

%% 通过环头获取环信息 
get_ringinfo_by_head(?task_type_sm, TaskId) ->
    {_Type2, _Lev, RingTaskIdList} = task_data_ring:get(by_sm_head, TaskId),
    RingTaskIdList;
get_ringinfo_by_head(?task_type_bh, TaskId) ->
    {_Lev, RingTaskIdList} = task_data_ring:get(by_bh_head, TaskId),
    RingTaskIdList.

%% 获取环头任务完成次数
ring_task_finish_num([], _HeadTaskIdList) ->
    0;
ring_task_finish_num([#task_finish{task_id = TaskId, finish_num = Num} | T], HeadTaskIdList) ->
    case lists:member(TaskId, HeadTaskIdList) of
        false ->
            ring_task_finish_num(T, HeadTaskIdList);
        true ->
            Num + ring_task_finish_num(T, HeadTaskIdList)
    end.

%% 级别最大的可接任务
max_lev_task_acceptable([TaskId | T]) ->
    {ok, #task_base{lev = Lev}} = task_data:get_conf(TaskId),
    {MaxTaskId, MaxLev} = max_lev_task_acceptable(T),
    case Lev > MaxLev of
        true -> {TaskId, Lev};
        false -> {MaxTaskId, MaxLev}
    end;
max_lev_task_acceptable([]) ->
    {0, 0}.

not_ring_head_lev_task([], _FnsMaxLev) -> false;
not_ring_head_lev_task([TaskId | T], FnsMaxLev) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{lev = FnsMaxLev}} ->
            {ok, TaskId};
        _ -> not_ring_head_lev_task(T, FnsMaxLev)
    end.

%% 级别最大的已完成任end;
max_lev_task_finished([#task_finish{task_id = TaskId} | T]) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{lev = Lev}} ->
            MaxLev = max_lev_task_finished(T),
            case Lev > MaxLev of
                true -> Lev;
                false -> MaxLev
            end;
        _ -> max_lev_task_finished(T)
    end;
max_lev_task_finished([]) ->
    0.

finish_num_sum([]) ->
    0;
finish_num_sum([#task_finish{finish_num = Num} | T]) ->
    Num + finish_num_sum(T).

%% 级别最大日常任务元组列表
max_lev_task_rc_acceptable([TaskId | T], WedTasks) ->
    {ok, #task_base{lev = Lev, sec_type = SecType}} = task_data:get_conf(TaskId),
    MaxTupleList = max_lev_task_rc_acceptable(T, WedTasks),
    case lists:keyfind(SecType, 1, MaxTupleList) of
        {_MaxSecType, _MaxTaskId, MaxLev} ->
            case Lev > MaxLev of
                _ when SecType =:= 28 -> %% 夫妻任务特殊处理
                    MarriedTask = util:rand_list(WedTasks),
                    lists:keyreplace(SecType, 1, MaxTupleList, {SecType, MarriedTask, Lev});
                true -> lists:keyreplace(SecType, 1, MaxTupleList, {SecType, TaskId, Lev});
                false -> MaxTupleList 
            end;
        false -> 
            [{SecType, TaskId, Lev} | MaxTupleList]
    end;
max_lev_task_rc_acceptable([], _) ->
    [].

%% 后选任务不可以比已完成的任务等级还底
max_lev_task_rc_finished([#task_finish{task_id = FnsTaskId} | T], TaskTupleList) ->
    case task_data:get_conf(FnsTaskId) of
        {ok, #task_base{lev = Lev, sec_type = SecType}} ->
            case lists:keyfind(SecType, 1, TaskTupleList) of
                {_MaxSecType, _MaxTaskId, MaxLev} ->
                    case Lev > MaxLev of
                        true ->
                            max_lev_task_rc_finished(T, lists:keydelete(SecType, 1, TaskTupleList));
                        false ->
                            max_lev_task_rc_finished(T, TaskTupleList)
                    end;
                false ->
                    max_lev_task_rc_finished(T, TaskTupleList)
            end;
        _ -> 
            max_lev_task_rc_finished(T, TaskTupleList)
    end;
max_lev_task_rc_finished([], TaskTupleList) ->
    TaskTupleList.

%% 日常任务过滤
%% 同一类任务如存在已接任务则不可以再出现可接任务
filter_rc_only_one(accepted, [], TaskTupleList) ->
    TaskTupleList;
filter_rc_only_one(accepted, [TaskId | T], TaskTupleList) ->
    {ok, #task_base{sec_type = BaseSecType}} = task_data:get_conf(TaskId),
    NewTaskList = [{SecType, TaskId2, Lev} || {SecType, TaskId2, Lev} <- TaskTupleList, SecType =/= BaseSecType],
    filter_rc_only_one(accepted, T, NewTaskList).

%% 环任务只能接一个
filter_ring_only_one(accepted, [], _Type) -> true;
filter_ring_only_one(accepted, [TaskId | T], Type) ->
    {ok, #task_base{type = TaskType}} = task_data:get_conf(TaskId),
    case TaskType =:= Type of
        true -> false;
        false -> filter_ring_only_one(accepted, T, Type)
    end.

%% 是否存在周日常已接任务
filter_has_accepted_zrc([]) -> false;
filter_has_accepted_zrc([TaskId | T]) ->
    case task_data:get_conf(TaskId) of
        {ok, #task_base{type = ?task_type_zrc}} -> true;
        _ -> filter_has_accepted_zrc(T)
    end.

%% 计算时间差(天)
time_diff(RegTime) ->
    RegToday = util:unixtime({today, RegTime}),
    Today = util:unixtime({today, util:unixtime()}),
    round((Today - RegToday)/86400).

get_week_task_list([{WLev, List} | T], Lev) ->
    case Lev >= WLev of
        true -> List;
        false -> get_week_task_list(T, Lev)
    end;
get_week_task_list([], _Lev) ->
    [].

%% 周日常任务过滤为指定任务
filter_only_one_week(_TargetTaskId, [], _Param) ->
    [];
filter_only_one_week(TargetTaskId, [TaskId | _T], #task_fparam{finish_task_list = FinishTaskList}) when TargetTaskId =:= TaskId ->
    {ok, #task_base{lev = Lev, times = Times}} = task_data:get_conf(TaskId),
    MaxLevFinish = max_lev_task_finished(FinishTaskList),
    case Lev >= MaxLevFinish of
        true ->
            FinishNumSum = finish_num_sum(FinishTaskList),
            case Times > FinishNumSum of
                true -> [TargetTaskId];
                false -> []
            end;
        false -> []
    end;
filter_only_one_week(TargetTaskId, [_TaskId | T], Param) ->
    filter_only_one_week(TargetTaskId, T, Param).
