%%----------------------------------------------------
%% @doc 功能活跃度(数据中心统计)
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(activity2_log).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([
        login/1
        ,log/2
        ,mark_task/3
        ,adm_statis/0
    ]).

-include("role.hrl").
-include("activity2.hrl").

-define(activity_statis_sync_time, 3600000).    %% 一小时统计一次
-define(activity_statis_start_lev, 30).    %% 30级以上才开始统计
-define(activity2_log_file, "../var/activity2_log.dets").    %% 统计数据收集表

-record(state, {
        sync_ref = 0
    }).

%% ---------- 外部接口 -------------------------
%% @spec login(Role) -> ok
%% Role = #role{}
%% @doc 登录处理
login(#role{lev = Lev}) when Lev < ?activity_statis_start_lev ->
    ok;
login(#role{id = Id, lev = Lev}) ->
    Date = date(),
    case ets:lookup(ets_activity2_log, Id) of
        [R = #activity2_log_role{date = Date}] ->
            ets:insert(ets_activity2_log, R#activity2_log_role{lev = Lev});
        _ ->
            ets:insert(ets_activity2_log, #activity2_log_role{id = Id, date = Date, lev = Lev})
    end.

%% @spec log(Role, Aid) -> ok
%% Role = #role{}
%% Id = integer()
%% @doc 记录事件
log(#role{lev = Lev}, _) when Lev < ?activity_statis_start_lev ->
    ok;
log(#role{id = Id, lev = Lev, cross_srv_id = CrossSrvId}, Aid) ->
    Date = date(),
    %% 竞技场要特殊处理
    ExactAid = case {Aid, time(), CrossSrvId} of
        {1, {14, _, _}, <<"center">>} -> 102;
        {1, {14, _, _}, _} -> 101;
        {1, _, <<"center">>} -> 100;
        _ -> Aid
    end,
    case ets:lookup(ets_activity2_log, Id) of
        [R = #activity2_log_role{date = Date, activitys = Acts}] ->
            NewActs = case lists:keyfind(ExactAid, #activity2_log_event.id, Acts) of
                A = #activity2_log_event{finish = Finish} ->
                    lists:keyreplace(ExactAid, #activity2_log_event.id, Acts, A#activity2_log_event{finish = Finish + 1});
                _ ->
                    [#activity2_log_event{id = ExactAid, finish = 1} | Acts]
            end,
            ets:insert(ets_activity2_log, R#activity2_log_role{lev = Lev, activitys = NewActs});
        _ ->
            NewActs = [#activity2_log_event{id = ExactAid, finish = 1}],
            ets:insert(ets_activity2_log, #activity2_log_role{id = Id, date = Date, lev = Lev, activitys = NewActs})
    end.

%% @spec mark_task(Role, TaskId, Status) -> ok
%% Role = #role{}
%% TaskId = integer()
%% Status = integer() 1：接受，2：完成
%% @doc 添加任务状态标识
mark_task(#role{lev = Lev}, _, _) when Lev < ?activity_statis_start_lev ->
    ok;
mark_task(#role{id = Id, lev = Lev}, TaskId, Status) ->
    Date = date(),
    case activity2_data:task_to_activity(TaskId) of
        1 ->
            case ets:lookup(ets_activity2_log, Id) of
                [R = #activity2_log_role{date = Date, activitys = Acts}] ->
                    NewActs = update_log_tasks([1, 100, 101, 102], Status, Acts),
                    ets:insert(ets_activity2_log, R#activity2_log_role{lev = Lev, activitys = NewActs});
                _ ->
                    NewActs = update_log_tasks([1, 100, 101, 102], Status, []),
                    ets:insert(ets_activity2_log, #activity2_log_role{id = Id, date = Date, lev = Lev, activitys = NewActs})
            end;
        Aid when is_integer(Aid) ->
            case ets:lookup(ets_activity2_log, Id) of
                [R = #activity2_log_role{date = Date, activitys = Acts}] ->
                    NewActs = update_log_tasks([Aid], Status, Acts),
                    ets:insert(ets_activity2_log, R#activity2_log_role{lev = Lev, activitys = NewActs});
                _ ->
                    NewActs = update_log_tasks([Aid], Status, []),
                    ets:insert(ets_activity2_log, #activity2_log_role{id = Id, date = Date, lev = Lev, activitys = NewActs})
            end;
        _ -> 
            ok
    end.

%% gm命令立马统计
adm_statis() ->
    ?MODULE ! sync_statis.


%% ---------- opt api --------------------------

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    Date = date(),
    dets:open_file(dets_activity2_log, [{file, ?activity2_log_file}, {keypos, #activity2_log_role.id}, {type, set}]),
    ets:new(ets_activity2_log, [set, named_table, {keypos, #activity2_log_role.id}, public]),
    case dets:match_object(dets_activity2_log, #activity2_log_role{date = Date, _ = '_'}) of
        [] -> ok;
        L -> ets:insert(ets_activity2_log, L)
    end,
    Ref = erlang:send_after(?activity_statis_sync_time, self(), sync_statis),
    State = #state{sync_ref = Ref},
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 开始统计一次
handle_info(sync_statis, State = #state{sync_ref = OldRef}) ->
    case erlang:is_reference(OldRef) of
        true -> erlang:cancel_timer(OldRef);
        _ -> ok
    end,
    Date = {Y, M, D} = date(),
    case ets:match_object(ets_activity2_log, #activity2_log_role{date = Date, _ = '_'}) of
        [] -> ok;
        Roles -> 
            Events = activity2_data:get_events(100) ++ get_add_events(),
            StrDate = util:fbin("~w-~w-~w", [Y, M, D]),
            Time = util:unixtime(),
            Logs = statis_logs(Events, Roles, StrDate, Time, []),
            save_logs(Logs)
    end,
    dets:open_file(dets_activity2_log, [{file, ?activity2_log_file}, {keypos, #activity2_log_role.id}, {type, set}]),
    ets:to_dets(ets_activity2_log, dets_activity2_log),
    Ref = erlang:send_after(?activity_statis_sync_time, self(), sync_statis),
    {noreply, State#state{sync_ref = Ref}};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    dets:open_file(dets_activity2_log, [{file, ?activity2_log_file}, {keypos, #activity2_log_role.id}, {type, set}]),
    ets:to_dets(ets_activity2_log, dets_activity2_log),
    dets:close(dets_activity2_log),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------- 内部方法 --------------------------
%% 部分活动要区分下
get_add_events() ->
    [
        %% 竞技场
        #activity2_event{ 
            id = 100,
            label = acc_event,
            type = 109,
            lev = 60,
            target = 1,
            point = 15
        },
        #activity2_event{ 
            id = 101,
            label = acc_event,
            type = 109,
            target = 1,
            point = 15
        },
        #activity2_event{ 
            id = 102,
            label = acc_event,
            type = 109,
            lev = 60,
            target = 1,
            point = 15
        }].

%% 更新任务标识
update_log_tasks([], _Status, Acts) ->
    Acts;
update_log_tasks([Aid | T], Status, Acts) ->
    NewActs = case lists:keyfind(Aid, #activity2_log_event.id, Acts) of
        A = #activity2_log_event{} ->
            lists:keyreplace(Aid, #activity2_log_event.id, Acts, A#activity2_log_event{has_task = Status});
        _ ->
            [#activity2_log_event{id = Aid, has_task = Status} | Acts]
    end,
    update_log_tasks(T, Status, NewActs).


%% 统计开始
statis_logs([], _, _, _, Logs) ->
    Logs;
statis_logs([E | T], Roles, Date, Time, Logs) ->
    Log = statis_roles(Roles, E, 0, 0, 0, 0, []),
    SqlLog = make_sql(Log, Date, Time),
    statis_logs(T, Roles, Date, Time, [SqlLog | Logs]).

statis_roles([], #activity2_event{id = Id, lev = Lev}, Total, Join, HasTask, FinishTask, JoinDetail) ->
    F = fun({K1, _}, {K2, _}) ->
            K1 < K2
    end,
    JoinDetail2 = lists:sort(F, JoinDetail),
    {Id, Lev, Total, Join, HasTask, FinishTask, JoinDetail2};
statis_roles([#activity2_log_role{lev = Lev} | T], E = #activity2_event{lev = BaseLev}, Total, Join, HasTask, FinishTask, JoinDetail) when Lev < BaseLev->
    statis_roles(T, E, Total, Join, HasTask, FinishTask, JoinDetail);
statis_roles([#activity2_log_role{activitys = Acts} | T], E = #activity2_event{id = Id, label = Label, type = Type}, Total, Join, HasTask, FinishTask, JoinDetail) ->
    case lists:keyfind(Id, #activity2_log_event.id, Acts) of
        %% 参加并完成任务
        #activity2_log_event{has_task = 2, finish = Finish} when Finish > 0 ->
            statis_roles(T, E, Total + 1, Join + 1, HasTask + 1, FinishTask + 1, calc_dungeon(Label, Type, Finish, JoinDetail));
        %% 参加但没完成任务
        #activity2_log_event{has_task = 1, finish = Finish} when Finish > 0 ->
            statis_roles(T, E, Total + 1, Join + 1, HasTask + 1, FinishTask, calc_dungeon(Label, Type, Finish, JoinDetail));
        %% 有任务没参加
        #activity2_log_event{has_task = 1} ->
            statis_roles(T, E, Total + 1, Join, HasTask + 1, FinishTask, JoinDetail);
        %% 参加但没接任务
        #activity2_log_event{finish = Finish} when Finish > 0 ->
            statis_roles(T, E, Total + 1, Join + 1, HasTask, FinishTask, calc_dungeon(Label, Type, Finish, JoinDetail));
        _ ->
            statis_roles(T, E, Total + 1, Join, HasTask, FinishTask, JoinDetail)
    end.

%% 统计副本次数
calc_dungeon(kill_npc, _, Finish, JoinDetail) ->
    case lists:keyfind(Finish, 1, JoinDetail) of
        {Finish, Times} ->
            lists:keyreplace(Finish, 1, JoinDetail, {Finish, Times + 1});
        _ ->
            [{Finish, 1} | JoinDetail]
    end;
calc_dungeon(special_event, 30027, Finish, JoinDetail) ->
    case lists:keyfind(Finish, 1, JoinDetail) of
        {Finish, Times} ->
            lists:keyreplace(Finish, 1, JoinDetail, {Finish, Times + 1});
        _ ->
            [{Finish, 1} | JoinDetail]
    end;
calc_dungeon(_, _, _, JoinDetail) ->
   JoinDetail. 

%% 生成sql
make_sql({Id, Lev, Total, Join, HasTask, FinishTask, JoinDetail}, Date, Time) ->
    Name = activity2_data:get_name(Id),
    Joins = util:term_to_bitstring(JoinDetail),
    erlang:bitstring_to_list(db:format_sql("(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",[Id, Lev, Name, Date, Total, Join, HasTask, FinishTask, Time, Joins]));
make_sql(_, _, _) ->
    <<>>.

%% 保存到数据库
save_logs(Logs) ->
    Sql = "replace into `sys_activity2_log`(`id`, `lev`, `name`, `log_date`, `total_num`, `join_num`, `has_task`, `finish_task`, `log_time`, `join_detail`) values",
    FullSql = Sql ++ string:join(Logs, ","),
    db:execute(FullSql).
