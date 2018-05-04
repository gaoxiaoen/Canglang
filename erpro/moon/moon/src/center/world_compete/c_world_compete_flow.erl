%%----------------------------------------------------
%% 跨服仙道会计时器及排行榜更新
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(c_world_compete_flow).

-behaviour(gen_fsm).

-export([
        create/1,
        idle/2,
        active/2
    ]
).

-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("common.hrl").
-include("world_compete.hrl").
-include("rank.hrl").

-define(world_compete_start_time1, {[1,2,3,4,5,6,7], 16, 0, 0}).     %% 活动开启时间 {每周几,时,分,秒}
-define(world_compete_start_time2, {[1,2,3,4,5,6,7], 21, 30, 0}).     %% 活动开启时间 {每周几,时,分,秒}
-define(world_compete_duration1, 1000*3600*2).                  %% 活动持续时间（单位：毫秒）
-define(world_compete_duration2, 1000*3600*2).                %% 活动持续时间（单位：毫秒）

-define(world_compete_cast_rank_delay, 1000 * 60 * 3).   %% 广播排行榜数据延后时间（单位：毫秒）
-ifdef(debug).
-define(world_compete_cast_rank_day_delay, 1000 * 30). %% 每隔一段时间广播一次每日战绩（单位：毫秒）
-else.
-define(world_compete_cast_rank_day_delay, 1000 * 60 * 5). %% 每隔一段时间广播一次每日战绩（单位：毫秒）
-endif.

-record(state, {
        mgr_pid = 0,
        next_period = 1,
        ts = 0,
        t_idle = 0
    }
).

%%------------------------------------------------------
%% 外部方法
%%------------------------------------------------------
create(MgrPid)->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [MgrPid], []).

%%------------------------------------------------------
%% 状态机消息处理
%%------------------------------------------------------
init([MgrPid]) ->
    ?INFO("跨服仙道会计时器启动"),
    IdleTime1 = get_idle_time(?world_compete_start_time1),
    IdleTime2 = get_idle_time(?world_compete_start_time2),
    {NextPeriod, IdleTime} = case IdleTime1 =< IdleTime2 of
        true -> {?world_compete_period1, IdleTime1};
        false -> {?world_compete_period2, IdleTime2}
    end,
    ets:new(world_compete_marks, [set, named_table, public, {keypos, #world_compete_mark.id}]),
    dets:open_file(world_compete_mark_list, [{file, "../var/world_compete_mark.dets"}, {keypos, #world_compete_mark.id}, {type, set}]),
    dets:open_file(world_compete_mark_list_yesterday, [{file, "../var/world_compete_mark_yesterday.dets"}, {keypos, 1}, {type, set}]),
    load_marks(),
    %% 提前一点提示玩家活动即将开始
    if
        IdleTime < 1000 * 60 * 5 andalso IdleTime > 1000 * 60 ->
            erlang:send_after(1000 * 60, self(), {prepare_start});
        IdleTime >= 1000 * 60 * 5 ->
            erlang:send_after(IdleTime - 1000 * 60 * 5, self(), {prepare_start});
        true -> ignore
    end,
    State = #state{ts = erlang:now(), t_idle = IdleTime, next_period = NextPeriod, mgr_pid = MgrPid},
    ?INFO("跨服仙道会计时器启动完成"),
    {ok, idle, State, IdleTime}.

handle_event(_Event, StateName, State) ->
    continue(StateName, State).

handle_sync_event(_Event, _From, StateName, State) ->
    continue(StateName, ok, State).

handle_info(start_activity, idle, State) ->
    start_activity(State);
handle_info(start_activity, active, State = #state{mgr_pid = MgrPid, next_period = NextPeriod}) ->
    MgrPid ! {start_activity, NextPeriod},
    continue(active, State);

handle_info(stop_activity, active, State) ->
    stop_activity(State);
handle_info(stop_activity, idle, State = #state{mgr_pid = MgrPid}) ->
    MgrPid ! stop_activity,
    continue(idle, State);

%% 仙道会排行榜排序和广播
handle_info(rank_data_sort, idle, State) ->
    case ets:tab2list(world_compete_marks) of
        OriginGainLilianList = [_|_] ->
            %% 胜率榜条件：打了不小于20场，且7天内有打过仙道会
            MinUpdateTime = util:unixtime() - 3600 * 24 * 7,
            OriginWinRateList = [Mark || Mark = #world_compete_mark{combat_count = CombatCount, update_time = UpdateTime} <- OriginGainLilianList, (CombatCount >= 20) andalso (UpdateTime >= MinUpdateTime)],
            %% 全服排行暂时不要了
            GlobalWinRateList = [], %%lists:sublist(lists:reverse(lists:keysort(#world_compete_mark.win_rate, OriginWinRateList)), 100),
            GlobalGainLilianList = [], %%lists:sublist(lists:reverse(lists:keysort(#world_compete_mark.gain_lilian, OriginGainLilianList)), 100),
            spawn(fun() ->
                        ?INFO("开始广播仙道会排行榜数据"),
                        %% 筛选出同平台排行
                        L1 = filter_rank_by_platform(OriginWinRateList),
                        L2 = filter_rank_by_platform(OriginGainLilianList),
                        cast_rank_by_platform(?rank_platform_world_compete_winrate, L1),
                        cast_rank_by_platform(?rank_platform_world_compete_lilian, L2),
                        cast_rank_by_platform(?rank_platform_world_compete_section, L2),
                        %% 筛选出单服排行
                        filter_rank_by_srv(OriginWinRateList, OriginGainLilianList, GlobalWinRateList, GlobalGainLilianList),
                        ?INFO("广播仙道会排行榜数据结束")
                end);
        _ -> ignore
    end,
    continue(idle, State);

handle_info(send_activity_over_rewards, idle, State) ->
    send_activity_over_rewards(),
    continue(idle, State);

handle_info(print_activity_status, idle, State = #state{next_period = NextPeriod, ts = Ts, t_idle = IdleTime}) ->
    ?INFO("仙道会处于关闭状态，计时器下一个阶段是:~w，离该阶段剩余时间:~w", [NextPeriod, util:time_left(IdleTime, Ts)]),
    continue(idle, State);
handle_info(print_activity_status, active, State = #state{next_period = NextPeriod, ts = Ts, t_idle = IdleTime}) ->
    ?INFO("仙道会处于开启状态，计时器下一个阶段是:~w，离活动结束还有:~w", [NextPeriod, util:time_left(IdleTime, Ts)]),
    continue(active, State);

handle_info({reset_next_period, NextPeriod}, idle, State) ->
    ?INFO("重设仙道会下一个阶段为:~w", [NextPeriod]),
    IdleTime = case NextPeriod of
        ?world_compete_period1 ->
            get_idle_time(?world_compete_start_time1);
        ?world_compete_period2 ->
            get_idle_time(?world_compete_start_time2)
    end,
    continue(idle, State#state{ts = erlang:now(), t_idle = IdleTime, next_period = NextPeriod});

handle_info({reset_next_period, _}, active, State) ->
    ?INFO("仙道会处于开启状态，不能重设阶段"),
    continue(active, State);

handle_info({prepare_start}, idle, State = #state{mgr_pid = MgrPid}) ->
    MgrPid ! prepare_start,
    continue(idle, State);

handle_info(cast_rank_day, idle, State) ->
    case ets:tab2list(world_compete_marks) of
        L = [_|_] ->
            ?INFO("广播当日战绩"),
            TopWinCounts = filter_top_win_count_by_platform(L, 10),
            cast_rank_by_platform(?rank_platform_world_compete_win_today, TopWinCounts);
        _ -> ignore
    end,
    continue(idle, State);
handle_info(cast_rank_day, active, State) ->
    case ets:tab2list(world_compete_marks) of
        L = [_|_] ->
            ?INFO("广播当日战绩"),
            TopWinCounts = filter_top_win_count_by_platform(L, 10),
            cast_rank_by_platform(?rank_platform_world_compete_win_today, TopWinCounts);
        _ -> ignore
    end,
    erlang:send_after(?world_compete_cast_rank_day_delay, self(), cast_rank_day),
    continue(active, State);

handle_info({do_save_prev_mvp, Mvps}, StateName, State) ->
    put(prev_mvp, Mvps),
    cast_rank_by_platform(?rank_platform_world_compete_win_yesterday, Mvps),
    dets:delete_all_objects(world_compete_mark_list_yesterday),
    do_save_prev_mvp(Mvps),
    ?INFO("广播昨日MVP信息完毕"),
    erlang:send_after(5000, self(), send_day_section_rewards),
    continue(StateName, State);

handle_info(send_day_section_rewards, idle, State) ->
    ?INFO("发送每日段位奖励"),
    send_day_section_rewards(),
    ?INFO("发送每日段位奖励完毕"),
    continue(idle, State);

handle_info(update_prev_mvp, StateName, State) ->
    save_prev_mvp(),
    continue(StateName, State);

handle_info({print_section_info, RoleId}, StateName, State) ->
    case ets:lookup(world_compete_marks, RoleId) of
        [#world_compete_mark{name = _Name, section_mark = SectionMark, section_lev = SectionLev}] ->
            ?INFO("[~s]的段位信息:mark=~w, lev=~w", [_Name, SectionMark, SectionLev]);
        _ ->
            ?INFO("找不到这个角色的段位信息")
    end,
    continue(StateName, State);

handle_info(reset_section_info, idle, State) ->
    ?INFO("开始重设仙道会段位信息"),
    reset_section_info(),
    ?INFO("重设仙道会段位信息完毕"),
    continue(idle, State);
handle_info(reset_section_info, active, State) ->
    ?INFO("仙道会进行期间不能重设段位信息"),
    continue(active, State);

handle_info(fix_section_info, idle, State) ->
    ?INFO("开始修复仙道会段位信息"),
    case ets:tab2list(world_compete_marks) of
        L = [_|_] ->
            lists:foreach(fun(Mark = #world_compete_mark{id = _RoleId, role_power = RolePower, section_mark = OldSectionMark}) ->
                        SectionMark = util:check_range(round(c_world_compete:calc_first_section_mark(RolePower) + OldSectionMark), 0, 99999999),
                        SectionLev = c_world_compete_section_data:section_mark_to_section_lev(SectionMark),
                        ets:insert(world_compete_marks, Mark#world_compete_mark{section_mark = SectionMark, section_lev = SectionLev})
                end, L),
            save_marks();
        _ -> ignore
    end,
    ?INFO("修复仙道会段位信息完毕"),
    continue(idle, State);
handle_info(fix_section_info, active, State) ->
    ?INFO("仙道会进行期间不能修复段位信息"),
    continue(active, State);

handle_info(fix_section_info2, idle, State) ->
    ?INFO("开始修复仙道会段位信息"),
    case ets:tab2list(world_compete_marks) of
        L = [_|_] ->
            lists:foreach(fun(Mark = #world_compete_mark{id = _RoleId, role_power = RolePower, section_mark = OldSectionMark}) ->
                        SectionMark = util:check_range(round(OldSectionMark) - c_world_compete:calc_first_section_mark(RolePower), 0, 99999999),
                        SectionLev = c_world_compete_section_data:section_mark_to_section_lev(SectionMark),
                        ets:insert(world_compete_marks, Mark#world_compete_mark{section_mark = SectionMark, section_lev = SectionLev})
                end, L),
            save_marks();
        _ -> ignore
    end,
    ?INFO("修复仙道会段位信息完毕"),
    continue(idle, State);
handle_info(fix_section_info2, active, State) ->
    ?INFO("仙道会进行期间不能修复段位信息"),
    continue(active, State);

handle_info({set_section_lev, RoleId = {_Rid, _SrvId}, SectionLev}, idle, State) ->
    case ets:lookup(world_compete_marks, RoleId) of
        [Mark = #world_compete_mark{}] ->
            case c_world_compete_section_data:get(SectionLev) of
                #world_compete_section_data{mark = SectionMark} ->
                    Mark1 = Mark#world_compete_mark{section_mark = SectionMark, section_lev = SectionLev},
                    ets:insert(world_compete_marks, Mark1),
                    dets:insert(world_compete_mark_list, Mark1),
                    ?INFO("设仙道会段位等级:[~w], Lev=~w", [RoleId, SectionLev]);
                _ ->
                    ?ERR("根据Lev=~w找不到对应的段位数据", [SectionLev])
            end;
        _ ->
            ?ERR("根据RoleId=[~w, ~s]找不到对应的仙道会积分记录", [_Rid, _SrvId])
    end,
    continue(idle, State);
handle_info({set_section_lev, _RoleId, _SectionLev}, active, State) ->
    ?ERR("仙道会进行期间不能设段位等级"),
    continue(active, State);

handle_info(_Info, StateName, State) ->
    ?ERR("仙道会时间管理进程收到错误的异步消息：~w", [_Info]),
    continue(StateName, State).

terminate(_Reason, _StateName, _State) ->
    ?INFO("仙道会FLOW进程关闭"),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.


idle(timeout, State) ->
    ?INFO("定时器时间到，开启仙道会"),
    start_activity(State);
idle(_Any, State) ->
    ?ERR("定时器在idle阶段收到错误消息:~w", [_Any]),
    continue(idle, State).

active(timeout, State) ->
    ?INFO("定时器时间到，关闭仙道会"),
    stop_activity(State);
active(_Any, State) ->
    ?ERR("定时器在active阶段收到错误消息:~w", [_Any]),
    continue(active, State).

%%------------------------------------------------------
%% 内部实现
%%------------------------------------------------------
%% 活动开始
start_activity(State = #state{mgr_pid = MgrPid, next_period = NextPeriod}) ->
    %% 如果跨日，则清掉每日战绩
    case sys_env:get(world_compete_mark_day_time) of
        undefined ->
            %% save_prev_mvp(),
            clear_mark_day();
        PrevMarkDayTime ->
            case util:is_today(PrevMarkDayTime) of
                true -> ignore;
                false ->
                    %% save_prev_mvp(),
                    clear_mark_day()
            end
    end,
    sys_env:save(world_compete_mark_day_time, util:unixtime()),
    %% 通知仙道会管理进程活动开始
    MgrPid ! {start_activity, NextPeriod},
    Duration = case NextPeriod of
        ?world_compete_period1 -> ?world_compete_duration1;
        ?world_compete_period2 -> ?world_compete_duration2
    end,
    erlang:send_after(?world_compete_cast_rank_day_delay, self(), cast_rank_day),
    ?INFO("离活动结束还有~w秒", [util:floor(Duration/1000)]),
    continue(active, State#state{ts = erlang:now(), t_idle = Duration}).

%% 活动结束
stop_activity(State = #state{mgr_pid = MgrPid, next_period = NextPeriod}) ->
    MgrPid ! stop_activity,
    %% 保存一次仙道会战绩
    save_marks(),
    {IdleTime, NextPeriod1} = case NextPeriod of
        ?world_compete_period1 -> %% 当前是第一阶段的比赛（下午）
            {get_idle_time(?world_compete_start_time2), ?world_compete_period2};
        ?world_compete_period2 -> %% 当前是第二阶段的比赛（晚上）
            %% 过了第二天0点一些时间就告诉全服更新昨天MVP信息
            UpdatePrevMvpTime = (util:unixtime(today) + 86400 + 60*10) - util:unixtime(),
            case UpdatePrevMvpTime > 0 of
                true ->
                    erlang:send_after(UpdatePrevMvpTime * 1000, self(), update_prev_mvp);
                false ->
                    ?ERR("更新昨天MVP信息的时间算错了:~w", [UpdatePrevMvpTime]),
                    erlang:send_after(60*30*1000, self(), update_prev_mvp)
            end,
            {get_idle_time(?world_compete_start_time1), ?world_compete_period1}
    end,
    %% 提前一点提示玩家活动即将开始
    if
        IdleTime < 1000 * 60 * 5 andalso IdleTime > 1000 * 60 ->
            erlang:send_after(1000 * 60, self(), {prepare_start});
        IdleTime >= 1000 * 60 * 5 ->
            erlang:send_after(IdleTime - 1000 * 60 * 5, self(), {prepare_start});
        true -> ignore
    end,
    %% 发送活动结束奖励
    %% erlang:send_after(10000, self(), send_activity_over_rewards),
    erlang:send_after(20000, self(), rank_data_sort),
    ?INFO("离下一场活动还有~w秒", [util:floor(IdleTime/1000)]),
    continue(idle, State#state{ts = erlang:now(), t_idle = IdleTime, next_period = NextPeriod1}).

%% 载入角色仙道会战绩
load_marks() ->
    put(need_update_ver_mark_list, []),
    case dets:first(world_compete_mark_list) of
        '$end_of_table' -> ?INFO("中央服仙道会战绩数据导入ets完成，DETS没有数据");
        _ ->
            dets:traverse(world_compete_mark_list,
                fun(Mark) when is_record(Mark, world_compete_mark) ->
                        ets:insert(world_compete_marks, eqm_parse(Mark)),
                        continue;
                    (Data) ->
                        Mark = ver_parse_mark_data(Data),
                        Mark1 = eqm_parse(Mark),
                        ets:insert(world_compete_marks, Mark1),
                        put(need_update_ver_mark_list, [Mark1|get(need_update_ver_mark_list)]),
                        continue
                end
            ),
            ?INFO("中央服仙道会战绩数据导入ets完成，共~w条数据", [ets:info(world_compete_marks, size)])
    end,
    lists:foreach(fun(NewMark) ->
                dets:insert(world_compete_mark_list, NewMark)
        end, get(need_update_ver_mark_list)),
    put(need_update_ver_mark_list, undefined),
    case dets:first(world_compete_mark_list_yesterday) of
        '$end_of_table' -> ?INFO("中央服仙道会战绩数据导入昨天mvp数据导入进程字典完成，DETS没有数据");
        _ ->
            put(prev_mvp, []),
            dets:traverse(world_compete_mark_list_yesterday,
                fun({Platform, L}) when is_list(L) ->
                        L1 = [ver_parse_mark_data(Mark) || Mark <- L],
                        dets:insert(world_compete_mark_list_yesterday, {Platform, L1}),
                        L2 = eqm_parse(L1, []),
                        put(prev_mvp, [{Platform, L2}|get(prev_mvp)]),
                        continue;
                    (_Data) ->
                        continue
                end
            ),
            ?INFO("中央服仙道会战绩数据导入昨天mvp数据导入进程字典完成，共~w条数据", [length(get(prev_mvp))])
    end.

%% 装备版本转换
eqm_parse(Mark = #world_compete_mark{eqm = Eqm}) ->
    Eqm2 = case item_parse:do(Eqm) of
        {ok, Eqm1} -> Eqm1;
        _ -> []
    end,
    Mark#world_compete_mark{eqm = Eqm2}.
eqm_parse([], Result) -> lists:reverse(Result);
eqm_parse([Mark = #world_compete_mark{eqm = Eqm}|T], Result) ->
    Eqm2 = case item_parse:do(Eqm) of
        {ok, Eqm1} -> Eqm1;
        _ -> []
    end,
    eqm_parse(T, [Mark#world_compete_mark{eqm = Eqm2}|Result]).

%% 把每日战绩清零
clear_mark_day() ->
    L = ets:tab2list(world_compete_marks),
    L1 = [Mark#world_compete_mark{win_count_today = 0} || Mark <- L],
    lists:foreach(fun(Mark) ->
                ets:insert(world_compete_marks, Mark),
                dets:insert(world_compete_mark_list, Mark)
        end, L1).

%% 保存昨日战绩MVP信息
save_prev_mvp() ->
    ?INFO("保存昨日MVP信息，并广播到全服"),
    RankList = ets:tab2list(world_compete_marks),
    Pid = self(),
    spawn(fun() -> 
                Mvps = filter_top_win_count_by_platform(RankList, 1),
                Pid ! {do_save_prev_mvp, Mvps}
        end).
do_save_prev_mvp([]) -> ok;
do_save_prev_mvp([{Platform, L}|T]) ->
    dets:insert(world_compete_mark_list_yesterday, {Platform, L}),
    do_save_prev_mvp(T).

%% 回写dets数据，关机或者进程关闭时执行
save_marks() ->
    L = ets:tab2list(world_compete_marks),
    save_marks(L).
save_marks([]) -> ok; 
save_marks([H | T]) ->
    dets:insert(world_compete_mark_list, H),
    save_marks(T).

%% 发送每日段位奖励
send_day_section_rewards() ->
    case ets:tab2list(world_compete_marks) of
        L = [_|_] ->
            L1 = [{Mark, c_mirror_group:get_merge_dest_srv_id(SrvId)} || Mark = #world_compete_mark{id = {_, SrvId}} <- L],
            L2 = lists:sublist(lists:reverse(lists:keysort(#world_compete_mark.section_mark, L)), 100),
            L3 = [{RoleId, c_mirror_group:get_merge_dest_srv_id(SrvId), Name} || #world_compete_mark{id = RoleId = {_, SrvId}, name = Name} <- L2],
            L4 = gen_section_season_over_top_rewards(L3),
            IsSectionSeasonOver = is_section_season_over(),
            send_day_section_rewards_by_srv(c_mirror_group:get_all_dest_srv_id(), IsSectionSeasonOver, L1, L4),
            case IsSectionSeasonOver of
                true -> erlang:send_after(1000 * 60, self(), reset_section_info);
                _ -> ignore
            end;
        _ -> ignore
    end.


send_day_section_rewards_by_srv([], _, _, _) -> 
    ?INFO("发送仙道会每日段位奖励结束");
send_day_section_rewards_by_srv([DestSrvId|T], IsSectionSeasonOver, Marks, SeasonOverTopRewards) ->
    {LocalMarkList, OtherMarkList} = split_rank_by_srv(DestSrvId, Marks, [], []),
    Rewards = case IsSectionSeasonOver of
        true ->
            LocalSeasonOverTopRewards = [{RoleId, TopRewards} || {RoleId, DestSrvId1, TopRewards} <- SeasonOverTopRewards, DestSrvId1 =:= DestSrvId],
            [gen_day_section_reward(LocalMarkList, []), gen_section_season_over_rewards(LocalMarkList, []), LocalSeasonOverTopRewards];
        false ->
            [gen_day_section_reward(LocalMarkList, []), [], []]
    end,
    CompressedData = term_to_binary(Rewards, [compressed]),
    c_mirror_group:cast(node, DestSrvId, world_compete_mgr, send_day_section_rewards, [CompressedData]),
    ?INFO("已发送[~s]的仙道会每日段位奖励", [DestSrvId]),
    send_day_section_rewards_by_srv(T, IsSectionSeasonOver, OtherMarkList, SeasonOverTopRewards).

gen_day_section_reward([], Result) -> Result;
gen_day_section_reward([#world_compete_mark{id = RoleId, section_lev = SectionLev}|T], Result) ->
    case c_world_compete_section_data:get(SectionLev) of
        #world_compete_section_data{day_lilian = DayLilian, day_attainment = DayAttainment, day_item_rewards = ItemRewards} when DayLilian>0 orelse DayAttainment>0 ->
            gen_day_section_reward(T, [{RoleId, SectionLev, DayLilian, DayAttainment, ItemRewards}|Result]);
        _ -> gen_day_section_reward(T, Result)
    end.

%% 是否段位赛每月赛结束 -> true|false
is_section_season_over() ->
    case sys_env:get(is_debug_section_reward) of
        true -> true;
        _ ->
            case util:seconds_to_datetime(util:unixtime()) of
                {{_, _, 1}, _} -> %% 每月的第一天
                    true;
                _ -> false
            end
    end.

%% 段位赛每月奖励，并且把段位积分重置 -> [{RoleId, SectionLev, Rewards}]
gen_section_season_over_rewards([], Result) -> Result;
gen_section_season_over_rewards([#world_compete_mark{id = RoleId, section_lev = SectionLev}|T], Result) ->
    case c_world_compete_section_data:get(SectionLev) of
        #world_compete_section_data{section_over_rewards = Rewards} ->
            gen_section_season_over_rewards(T, [{RoleId, SectionLev, Rewards}|Result]);
        _ ->
            gen_section_season_over_rewards(T, [{RoleId, SectionLev, []}|Result])
    end.

%% 生成段位赛前100名的奖励 -> [{RoleId, DestSrvId, Rewards :: [{ItemBaseId, Bind, Quantity}]}]
gen_section_season_over_top_rewards(L) ->
    ?INFO("段位赛前100名的奖励名单:"),
    gen_section_season_over_top_rewards(L, [], 1).
gen_section_season_over_top_rewards([], Result, _) -> Result;
gen_section_season_over_top_rewards([{RoleId = {_, _SrvId}, DestSrvId, _Name}|T], Result, N) ->
    Rewards = if
        N =:= 1 -> [{29484, 1, 5}, {29483, 1, 5}];
        N =:= 2 orelse N =:= 3 -> [{29484, 1, 4}, {29483, 1, 3}];
        N =:= 4 orelse N =:= 5 -> [{29484, 1, 3}, {29483, 1, 2}];
        N > 5 andalso N =< 10 -> [{29484, 1, 2}, {29482, 1, 3}];
        N > 10 andalso N =< 50 -> [{29484, 1, 1}, {29482, 1, 2}];
        N > 50 andalso N =< 100 -> [{29484, 1, 1}, {29481, 1, 2}];
        true -> []
    end,
    ?INFO("第~w名[来自:~s的~s]的奖励:~w", [N, _SrvId, _Name, Rewards]),
    gen_section_season_over_top_rewards(T, [{RoleId, DestSrvId, Rewards}|Result], N+1).


%% 重设段位赛积分（清零）
reset_section_info() ->
    case ets:tab2list(world_compete_marks) of
        L = [_|_] ->
            lists:foreach(fun(Mark = #world_compete_mark{id = _RoleId}) ->
                        ets:insert(world_compete_marks, Mark#world_compete_mark{section_mark = 0, section_lev = 0})
                end, L),
            save_marks();
        _ -> ignore
    end.

%% 重新解析战绩数据
ver_parse_mark_data({world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt_33, ComCnt_33, LilianCnt_33}) ->
    Mark1 = {world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, 0, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt_33, ComCnt_33, LilianCnt_33},
    ver_parse_mark_data(Mark1);
ver_parse_mark_data({world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, KoPerCnt, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt_33, ComCnt_33, LilianCnt_33}) ->
    ver_parse_mark_data({world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, KoPerCnt, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt_33, ComCnt_33, LilianCnt_33, 0, 0, 0});
ver_parse_mark_data({world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, KoPerCnt, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt_33, ComCnt_33, LilianCnt_33, WinCntToday, RolePower, PetPower}) ->
    ver_parse_mark_data({world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, KoPerCnt, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt_33, ComCnt_33, LilianCnt_33, WinCntToday, RolePower, PetPower, 0});
ver_parse_mark_data({world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, KoPerCnt, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt_33, ComCnt_33, LilianCnt_33, WinCntToday, RolePower, PetPower, WinTopPower}) ->
    ver_parse_mark_data({world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, KoPerCnt, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt_33, ComCnt_33, LilianCnt_33, WinCntToday, RolePower, PetPower, WinTopPower, util:unixtime()});
ver_parse_mark_data({world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, KoPerCnt, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt_33, ComCnt_33, LilianCnt_33, WinCntToday, RolePower, PetPower, WinTopPower, UpdateTime}) ->
    ver_parse_mark_data({world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, KoPerCnt, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt_33, ComCnt_33, LilianCnt_33, WinCntToday, RolePower, PetPower, WinTopPower, UpdateTime, 0, 1});
ver_parse_mark_data(Mark) ->
    Mark.
%% %% 2012/07/27 全服更新
%% ver_parse_mark_data({world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt, WinCnt, LossCnt, DrawCnt, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt33, WinCnt33, WinCnt33}) ->
%%     {world_compete_mark, RoleId, Name, Lev, Career, Sex, Looks, Eqm, ComCnt+DrawCnt, WinCnt, LossCnt, DrawCnt, 0, CWinCnt, CLossCnt, CDrawCnt, Lilian, WinRate, WinCnt_11, ComCnt_11, Lilian_11, WinCnt_22, ComCnt_22, Lilian_22, WinCnt33, WinCnt33, WinCnt33};
%% ver_parse_mark_data(Mark = #world_compete_mark{combat_count = ComCnt, draw_count = DrawCnt}) ->
%%     Mark#world_compete_mark{combat_count = ComCnt+DrawCnt}.

%% 计算空闲时间 -> integer()
%% NextTime = ?world_compete_start_time1 | ?world_compete_start_time2
get_idle_time(_NextTime = {_DaysOfWeek, Hour, Min, Sec}) ->
    Now = util:unixtime(),
    Today = util:unixtime({today, Now}),
    Time = Hour * 3600 + Min * 60 + Sec,
    IdleTime = case (Today + Time) > Now of
        true -> (Today + Time - Now);
        false ->
            Tomorrow = util:unixtime({tomorrow, Now}),
            Tomorrow + Time - Now
    end,
    ?DEBUG("离活动时间还有:~w秒", [IdleTime]),
    IdleTime * 1000.


%% 活动结束时发送特殊节日奖励
send_activity_over_rewards() ->
    Time1 = util:datetime_to_seconds({{2012,6,20},{8,0,0}}),
    Time2 = util:datetime_to_seconds({{2012,6,23},{0,0,0}}),
    Now = util:unixtime(),
    case Time1>= Now andalso Now<Time2 of
        true ->
            Platforms = c_mirror_group:get_all_platforms(),
            lists:foreach(fun(Platform) ->
                        case get({world_compete_marks, Platform}) of
                            L = [_|_] -> do_send_activity_over_rewards(L);
                            _ -> ignore
                        end
                end, Platforms);
        false -> ignore
    end.
do_send_activity_over_rewards([]) -> ok;
do_send_activity_over_rewards([#world_compete_mark{id = RoleId = {_, SrvId}, win_count = WinCount}|T]) when WinCount >= 10 ->
    case get_activity_over_rewards(WinCount) of
        Rewards = [_|_] -> 
            c_mirror_group:cast(node, SrvId, world_compete_mgr, send_activity_over_rewards, [RoleId, Rewards]);
        _ -> ignore
    end,
    do_send_activity_over_rewards(T).

get_activity_over_rewards(10) -> [{32301, 1, 1}];
get_activity_over_rewards(11) -> [{32301, 1, 3}];
get_activity_over_rewards(12) -> [{32301, 1, 6}];
get_activity_over_rewards(13) -> [{32301, 1, 9}, {23003, 1, 2}];
get_activity_over_rewards(14) -> [{32301, 1, 12}, {23003, 1, 3}];
get_activity_over_rewards(WinCount) when WinCount >= 15 -> [{32301, 1, 15}, {23003, 1, 8}];
get_activity_over_rewards(_) -> [].


%% 按照服务器ID切分排行榜数据
split_rank_by_srv(_DestSrvId, [], Result, Other) -> {Result, Other};
split_rank_by_srv(DestSrvId, [{Mark, DestSrvId}|T], Result, Other) ->
    split_rank_by_srv(DestSrvId, T, [Mark|Result], Other);
split_rank_by_srv(DestSrvId, [{Mark, DestSrvId1}|T], Result, Other) ->
    split_rank_by_srv(DestSrvId, T, Result, [{Mark, DestSrvId1}|Other]).

%% 广播单服排行榜数据
filter_rank_by_srv(OriginWinRateList, OriginGainLilianList, GlobalWinRateList, GlobalGainLilianList) ->
    ?INFO("开始广播仙道会单服排行榜数据"),
    erlang:statistics(wall_clock),
    OriginWinRateList1 = [{Mark, c_mirror_group:get_merge_dest_srv_id(SrvId)} || Mark = #world_compete_mark{id = {_, SrvId}} <- OriginWinRateList],
    OriginGainLilianList1 = [{Mark, c_mirror_group:get_merge_dest_srv_id(SrvId)} || Mark = #world_compete_mark{id = {_, SrvId}} <- OriginGainLilianList],
    {_, Time} = erlang:statistics(wall_clock),
    ?INFO("排行榜数据附带上合服信息花费时间:~w ms", [Time]),
    do_filter_rank_by_srv(c_mirror_group:get_all_dest_srv_id(), {OriginWinRateList1, OriginGainLilianList1, GlobalWinRateList, GlobalGainLilianList}).
do_filter_rank_by_srv([], _) -> 
    ?INFO("广播仙道会单服排行榜数据结束");
do_filter_rank_by_srv([DestSrvId|T], {OriginWinRateList1, OriginGainLilianList1, GlobalWinRateList, GlobalGainLilianList}) ->
    {LocalWinRateList, OtherWinRateList} = split_rank_by_srv(DestSrvId, OriginWinRateList1, [], []),
    {LocalGainLilianList, OtherGainLilianList} = split_rank_by_srv(DestSrvId, OriginGainLilianList1, [], []),
    LocalWinRateList1 = lists:sublist(lists:reverse(lists:keysort(#world_compete_mark.win_rate, LocalWinRateList)), 100),
    LocalGainLilianList1 = lists:sublist(lists:reverse(lists:keysort(#world_compete_mark.gain_lilian, LocalGainLilianList)), 100),
    LocalSectionList1 = lists:sublist(lists:reverse(lists:keysort(#world_compete_mark.section_mark, LocalGainLilianList)), 100),
    CompressedData = term_to_binary([GlobalWinRateList, GlobalGainLilianList, LocalWinRateList1, LocalGainLilianList1, LocalSectionList1], [compressed]),
    c_mirror_group:cast(node, DestSrvId, world_compete_mgr, rank_data_update, [CompressedData]),
    ?INFO("已发送[~s]的仙道会单服排行榜数据", [DestSrvId]),
    do_filter_rank_by_srv(T, {OtherWinRateList, OtherGainLilianList, GlobalWinRateList, GlobalGainLilianList}).

%% 筛选排行榜数据，按平台广播
filter_rank_by_platform(OriginList) ->
    do_filter_rank_by_platform(OriginList, []).
do_filter_rank_by_platform([], PlatformRankList) ->
    ?DEBUG("仙道会排行榜数据分平台筛选完毕，数据长度：~w", [length(PlatformRankList)]),
    PlatformRankList;
do_filter_rank_by_platform([H = #world_compete_mark{id = {_, SrvId}} | T], PlatformRankList) ->
    Platform = c_mirror_group:get_platform(SrvId),
    case lists:keyfind(Platform, 1, PlatformRankList) of
        {Platform, List} ->
            NewPRL = lists:keyreplace(Platform, 1, PlatformRankList, {Platform, [H | List]}),
            do_filter_rank_by_platform(T, NewPRL);
        false ->
            do_filter_rank_by_platform(T, [{Platform, [H]} | PlatformRankList])
    end;
do_filter_rank_by_platform([_H | T], PlatformRankList) ->
    do_filter_rank_by_platform(T, PlatformRankList).

%% 分出每个平台的前N名胜利数最高的 -> [{Platform, [#world_compete_mark{}]}]
filter_top_win_count_by_platform(OriginList, N) ->
    OriginList1 = [Mark || Mark = #world_compete_mark{win_count_today = WinCntToday} <- OriginList, WinCntToday > 0],
    L = filter_rank_by_platform(OriginList1),
    do_filter_win_count_by_platform(L, N, []).
do_filter_win_count_by_platform([], _, Result) -> Result;
do_filter_win_count_by_platform([{Platform, Ranks}|T], N, Result) ->
    Rank1 = lists:sublist(lists:reverse(lists:keysort(type2key(?rank_platform_world_compete_win_today), Ranks)), N),
    do_filter_win_count_by_platform(T, N, [{Platform, Rank1}|Result]).

%% 分平台广播
cast_rank_by_platform(_RankType, []) -> ok;
cast_rank_by_platform(RankType, [{Platform, List} | T]) ->
    RankList = lists:sublist(lists:reverse(lists:keysort(type2key(RankType), List)), 100),
    CompressData = term_to_binary(RankList, [compressed]),
    %% ?INFO("平台[~s]排行榜[~w]已完成筛选排序，共~w条数据，开始广播平台服务器", [Platform, RankType, length(RankList)]),
    c_mirror_group:cast(platform, [Platform], world_compete_mgr, rank_data_update, [RankType, CompressData]),
    cast_rank_by_platform(RankType, T);
cast_rank_by_platform(RankType, [_ | T]) ->
    cast_rank_by_platform(RankType, T).


%% 排行榜类型转为排序主键
type2key(?rank_platform_world_compete_winrate) -> #world_compete_mark.win_rate;
type2key(?rank_platform_world_compete_lilian) -> #world_compete_mark.gain_lilian;
type2key(?rank_platform_world_compete_win_today) -> #world_compete_mark.win_count_today;
type2key(?rank_platform_world_compete_win_yesterday) -> #world_compete_mark.win_count_today;
type2key(?rank_platform_world_compete_section) -> #world_compete_mark.section_mark;
type2key(_) -> #world_compete_mark.id.

continue(StateName, Reply, State = #state{ts = Ts, t_idle = IdleTime}) ->
    {reply, Reply, StateName, State, util:time_left(IdleTime, Ts)}.
continue(StateName, State = #state{ts = Ts, t_idle = IdleTime}) ->
    {next_state, StateName, State, util:time_left(IdleTime, Ts)}.
