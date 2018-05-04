%% --------------------------------------------------------------------
%% 武神坛管理进程
%% @author shawn 
%% @end
%% --------------------------------------------------------------------
-module(cross_warlord_mgr).
-behaviour(gen_fsm).

%% export functions
-export([
        start_link/0
        ,get_team/1
        ,get_team/2
        ,get_trial_team/2
        ,get_war_list/1
        ,update_team/2
        ,update_role/2
        ,update_team_group/1
        ,zone_report/2
        ,zone_stop/2
        ,save/2
        ,async_leave_pre_map/1
        ,apply_enter_map/2
        ,role_enter/2
        ,role_leave/3
        ,enter_match/4
        ,sign/6
        ,login/2
        ,get_role_trial_info/1
        ,get_last_info/1
        ,get_last_winer/1
        ,get_camp_status/0
        ,get_camp_date/0
        ,do_notice_win_check/2
        ,broadcast_srv/3
        ,get_room_list/0
        ,send_match_mail/3
        ,match_mail/6
        ,do_notice_all_check/2
        ,bet_team/5
        ,bet_top_3/6
        ,bet_16_team/19
        ,switch_close/1
    ]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("pet.hrl").
-include("team.hrl").
-include("skill.hrl").
-include("cross_warlord.hrl").

%% gen_fsm callbacks
-export([init/1, handle_event/3,handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

%% state functions
-export(
    [
        idel/2                 %% 空闲状态
        ,notice/2              %% 公告/报名阶段
        ,prepare/2             %% 预备阶段
        ,trial_round_0/2       %% 海选阶段 
        ,expire_trial_0/2
        ,idel_trial_1/2
        ,trial_round_1/2       %% 选拔赛一阶段
        ,expire_trial_1/2
        ,idel_trial_2/2        %% 选拔赛二阶段空闲阶段
        ,trial_round_2/2       %% 选拔赛二阶段
        ,expire_trial_2/2
        ,idel_trial_3/2        %% 选拔赛决赛空闲阶段
        ,trial_round_3/2       %% 选拔赛决赛 -> 决出32强
        ,expire_trial_3/2
        ,idel_top_16/2         %% 16强空闲阶段
        ,top_16/2              %% 16强赛     -> 决出16强
        ,expire_top_16/2
        ,idel_top_8/2          %% 8强空闲阶段
        ,top_8/2               %% 8强赛      -> 决出8强
        ,expire_top_8/2
        ,idel_top_4/2          %% 4强空闲阶段
        ,top_4/2               %% 4强赛      -> 决出4强
        ,expire_top_4/2
        ,idel_semi_final_1/2   %% 半决赛空闲阶段
        ,semi_final_1/2        %% 半决赛     -> 胜者进入冠军决赛,败者进入季军决赛 
        ,expire_semi_final_1/2
        ,idel_semi_final_2/2   %% 半决赛空闲阶段
        ,semi_final_2/2        %% 半决赛     -> 胜者进入冠军决赛,败者进入季军决赛 
        ,expire_semi_final_2/2
        ,idel_third_final/2    %% 季军决赛空闲阶段
        ,third_final/2         %% 季军决赛   -> 胜者季军 
        ,expire_third_final/2
        ,idel_final/2          %% 决赛空闲阶段
        ,final/2               %% 决赛        
        ,expire/2              %% 统计阶段    
   ]
).

-export(
    [
        m/1            %% 进入下一状态
        ,switch/1      %% 暂停或开启,只能在空闲状态使用
        ,status/0      %% 获取状态
        ,clean_cd/0   %% 清除2次比赛的间隔
    ]
).

-record(state, {
        ts = 0                 %% 进入某状态的时刻
        ,zone_list_sky = []    %% 战区列表 
        ,zone_list_land = []   %% 战区列表
        ,timeout = 0           %% 超时时间
        ,sign_day = 0          %% 剩余天数  0:不剩余时间 1:第二天再执行
        ,next_start_time = 0   %% 下一次开启时间
        ,switch = ?true          %% 暂停
        ,sign_code = 1        %% 注册队伍号
        ,state_lev = 0        %% 第几届
        ,last_winner = []     %% [{Label, WinnerName, WinSrvId, WinTeam} | T]
        ,last_winner_ext = [] %% 缓存last_winner, 跳转idel时候进行赋值
    }
).


-define(start_time, (14 * 3600 + 1800)).

%% ------------------------------------
%% 外部接口 
%% ------------------------------------

login(Id, Pid) ->
    case ets:lookup(ets_cross_warlord_role, Id) of
        [#cross_warlord_role{team_code = TeamCode, zone_pid = ZonePid}] when is_pid(ZonePid) ->
            case gen_fsm:sync_send_all_state_event(ZonePid, {login, TeamCode, Id, Pid}) of
                {ok, MapId} -> {ok, MapId, ZonePid};
                {false, Reason} -> {false, Reason};
                _ -> {false, <<"">>}
            end;
        _ -> {false, <<"">>}
    end.

m(Event) ->
    gen_fsm:send_event(?MODULE, Event).

%% 开关活动 
switch(open) ->
    gen_fsm:send_all_state_event(?MODULE, {switch, ?false});
switch(close) ->
    gen_fsm:send_all_state_event(?MODULE, {switch, ?true});
switch(_) ->
    ?ERR("错误的命令"),
    ok.

%% 清除上一次开启间隔
clean_cd() ->
    gen_fsm:send_all_state_event(?MODULE, clean_cd).

%% 查询状态
status() ->
    gen_fsm:sync_send_all_state_event(?MODULE, status).

%% 查询活动状态
get_camp_status() ->
    gen_fsm:sync_send_all_state_event(?MODULE, get_camp_status).

%% 查询活动安排
get_camp_date() ->
    gen_fsm:sync_send_all_state_event(?MODULE, get_camp_date).

%% 查询房间
get_room_list() ->
    gen_fsm:sync_send_all_state_event(?MODULE, get_room_list).

%% 查询32强完整榜单
get_last_info(Label) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {get_last_info, Label}).

%% 查询上届冠军队伍信息
get_last_winer(Label) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {get_last_winer, Label}).

%% 投注某场比赛
bet_team({Rid, SrvId}, Label, Seq, TeamCode, Coin) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {bet_team, {Rid, SrvId}, Label, Seq, TeamCode, Coin}).

%% 投注前三甲
bet_top_3({Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, Coin) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {bet_top_3, {Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, Coin}).

%% 投注16强
bet_16_team({Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, TeamCode4, TeamCode5, TeamCode6, TeamCode7, TeamCode8, TeamCode9, TeamCode10, TeamCode11, TeamCode12, TeamCode13, TeamCode14, TeamCode15, TeamCode16, Coin) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {bet_16_team, {Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, TeamCode4, TeamCode5, TeamCode6, TeamCode7, TeamCode8, TeamCode9, TeamCode10, TeamCode11, TeamCode12, TeamCode13, TeamCode14, TeamCode15, TeamCode16, Coin}).

%% 进入比赛
enter_match(Id, Pid, Career, FightCapacity) ->
    case ets:lookup(ets_cross_warlord_role, Id) of
        [#cross_warlord_role{career = Career1, team_code = TeamCode, zone_pid = ZonePid}] when is_pid(ZonePid) ->
            case Career =:= Career1 of
                true ->
                    case gen_fsm:sync_send_all_state_event(ZonePid, {enter_match, TeamCode, Id, Pid, FightCapacity}) of
                        {ok, MapId} -> {ok, ZonePid, MapId};
                        {false, Reason} -> {false, Reason};
                        _Err ->
                            {false, ?L(<<"武神坛战区已经关闭,无法进入">>)}
                    end;
                false -> {false, ?L(<<"职业与报名时职业不相符, 无法进入武神坛正式比赛">>)}
            end;
        _Err ->
            {false, ?L(<<"您还未能参与本场比赛，请查看是否有资格参与该次比赛资格!">>)}
    end.

%% 进入报名
sign(TeamName, TeamInfo, PidInfo, TeamSrvId, TeamFight, TeamLineUpList) ->
    gen_fsm:send_all_state_event(?MODULE, {sign, TeamName, TeamInfo, PidInfo, TeamSrvId, TeamFight, TeamLineUpList}).

%% 进入报名
role_enter(PreRole, RoomId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_enter, PreRole, RoomId}).

%% 退出报名场
role_leave(RoleId, RolePid, MapId) ->
    gen_fsm:send_all_state_event(?MODULE, {role_leave, RoleId, RolePid, MapId}).

%% 战区报告
zone_report(Quality, Log) ->
    gen_fsm:send_all_state_event(?MODULE, {report, Quality, Log}).

%% 战区关闭
zone_stop(Seq, Label) ->
    gen_fsm:send_all_state_event(?MODULE, {zone_stop, Label, Seq}).

%% 存储状态
save(StateName, State) ->
    case sys_env:save(cross_warlord_state, {StateName, State}) of
        ok -> ?DEBUG("保存武神坛状态成功");
        _Err -> ?ERR("保存武神坛状态失败:~w",[_Err])
    end.

load() ->
    case catch sys_env:get(cross_warlord_state) of
        {StateName, {state, Ts, ZoneListSky, ZoneListLand, Timeout, SignDay, NextStartTime, Switch, SignCode, StateLev, LastWinner, LastWinnerExt}} ->
            NewLastWinner = convert_winner(LastWinner),
            NewLastWinnerExt = convert_winner(LastWinnerExt),
            NewState = #state{ts = Ts, zone_list_sky = ZoneListSky, zone_list_land = ZoneListLand, timeout = Timeout, sign_day = SignDay, next_start_time = NextStartTime, switch = Switch, sign_code = SignCode, state_lev = StateLev, last_winner = NewLastWinner, last_winner_ext = NewLastWinnerExt},
            do_load(StateName, NewState);
        undefined ->
            ?INFO("不存在武神坛状态, 初始化武神坛状态"),
            {idel, #state{}, 3600};
        Reason -> {false, Reason}
    end.

do_load(StateName, State = #state{sign_day = SignDay}) ->
    Today = util:unixtime(today),
    Now = util:unixtime(),
    TodayStart = Today + ?start_time, 
    {NewStateName, NewState, TimeOut} = case StateName of
        idel ->
            ?INFO("武神坛空闲状态, 3分钟后进行状态检测更新"),
            {idel, State, 180};
        notice ->
            case SignDay of
                0 ->
                    if
                        Now < (Today + 3600 * 22) ->
                            ?INFO("武神坛今日报名未过, 距离报名结束还有[~w]秒", [(Today + 3600 * 22) - Now]),
                            {notice, State, ((Today + 3600 * 22) - Now)};
                        true ->
                            ?INFO("武神坛剩余报名时间已过,不再接受报名, 明日开始选拔赛第一阶段"),
                            {prepare, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
                    end;
                _ ->
                    ?INFO("武神坛报名剩余一天, 明天晚上10点终止报名"),
                    erlang:send_after((util:unixtime({tomorrow, Now}) - Now + 10) * 1000, self(), check_sign_day),
                    {notice, State#state{sign_day = 1}, ((util:unixtime({tomorrow, Now}) - Now) + (3600 * 22))}
            end;
        prepare ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后进入海选赛",[TodayStart - Now]),
                    {prepare, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛海选, 推迟一天执行"),
                    {prepare, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        trial_round_0 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入海选赛",[TodayStart - Now]),
                    {prepare, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛海选赛回滚, 推迟一天执行"),
                    {prepare, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire_trial_0 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入海选赛",[TodayStart - Now]),
                    {prepare, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛海选赛回滚, 推迟一天执行"),
                    {prepare, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        idel_trial_1 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后进入选拔赛第一阶段",[TodayStart - Now]),
                    {idel_trial_1, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛选拔赛一阶段, 推迟一天执行"),
                    {idel_trial_1, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        trial_round_1 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入选拔赛第一阶段",[TodayStart - Now]),
                    {idel_trial_1, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛选拔赛一阶段回滚, 推迟一天执行"),
                    {idel_trial_1, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire_trial_1 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入选拔赛第一阶段",[TodayStart - Now]),
                    {idel_trial_1, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛选拔赛一阶段回滚, 推迟一天执行"),
                    {idel_trial_1, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        idel_trial_2 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后进入选拔赛第二阶段",[TodayStart - Now]),
                    {idel_trial_2, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛选拔赛二阶段, 推迟一天执行"),
                    {idel_trial_2, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        trial_round_2 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入选拔赛第二阶段",[TodayStart - Now]),
                    {idel_trial_2, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛选拔赛二阶段回滚, 推迟一天执行"),
                    {idel_trial_2, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire_trial_2 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入选拔赛第二阶段",[TodayStart - Now]),
                    {idel_trial_2, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛选拔赛二阶段回滚, 推迟一天执行"),
                    {idel_trial_2, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        idel_trial_3 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后进入选拔赛第三阶段",[TodayStart - Now]),
                    {idel_trial_3, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛选拔赛第三阶段, 推迟一天执行"),
                    {idel_trial_3, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        trial_round_3 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入选拔赛第三阶段",[TodayStart - Now]),
                    {idel_trial_3, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛选拔赛第三阶段回滚, 推迟一天执行"),
                    {idel_trial_3, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire_trial_3 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入选拔赛第三阶段",[TodayStart - Now]),
                    {idel_trial_3, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛选拔赛第三阶段回滚, 推迟一天执行"),
                    {idel_trial_3, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        idel_top_16 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后进入top_16",[TodayStart - Now]),
                    {idel_top_16, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛top_16, 推迟一天执行"),
                    {idel_top_16, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        top_16 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入top_16",[TodayStart - Now]),
                    {idel_top_16, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛top_16回滚, 推迟一天执行"),
                    {idel_top_16, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire_top_16 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入top_16",[TodayStart - Now]),
                    {idel_top_16, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛top_16回滚, 推迟一天执行"),
                    {idel_top_16, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        idel_top_8 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后进入top_8",[TodayStart - Now]),
                    {idel_top_8, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛top_8, 推迟一天执行"),
                    {idel_top_8, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        top_8 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入top_8",[TodayStart - Now]),
                    {idel_top_8, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛top_8回滚, 推迟一天执行"),
                    {idel_top_8, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire_top_8 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入top_8",[TodayStart - Now]),
                    {idel_top_8, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛top_8回滚, 推迟一天执行"),
                    {idel_top_8, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        idel_top_4 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后进入top_4",[TodayStart - Now]),
                    {idel_top_4, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛top_4, 推迟一天执行"),
                    {idel_top_4, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        top_4 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入top_4",[TodayStart - Now]),
                    {idel_top_4, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛top_4回滚, 推迟一天执行"),
                    {idel_top_4, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire_top_4 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入top_4",[TodayStart - Now]),
                    {idel_top_4, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛top_4回滚, 推迟一天执行"),
                    {idel_top_4, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        idel_semi_final_1 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后进入semi_final_1",[TodayStart - Now]),
                    {idel_semi_final_1, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛semi_final_1, 推迟一天执行"),
                    {idel_semi_final_1, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        semi_final_1 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入semi_final_1",[TodayStart - Now]),
                    {idel_semi_final_1, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛semi_final_1回滚, 推迟一天执行"),
                    {idel_semi_final_1, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire_semi_final_1 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入semi_final_1",[TodayStart - Now]),
                    {idel_semi_final_1, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛semi_final_1回滚, 推迟一天执行"),
                    {idel_semi_final_1, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        idel_semi_final_2 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后进入semi_final_2",[TodayStart - Now]),
                    {idel_semi_final_2, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛semi_final_2, 推迟一天执行"),
                    {idel_semi_final_2, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        semi_final_2 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入semi_final_2",[TodayStart - Now]),
                    {idel_semi_final_2, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛semi_final_2回滚, 推迟一天执行"),
                    {idel_semi_final_2, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire_semi_final_2 ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入semi_final_2",[TodayStart - Now]),
                    {idel_semi_final_2, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛semi_final_2回滚, 推迟一天执行"),
                    {idel_semi_final_2, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        idel_third_final ->
            Day = calendar:day_of_the_week(date()),
            if 
                Day >= 6 -> %% 星期6之后，今天开打
                    if
                        Now < TodayStart ->
                            ?INFO("武神坛[~w]秒后进入third_final",[TodayStart - Now]),
                            {idel_third_final, State, TodayStart - Now};
                        true ->
                            ?INFO("武神坛third_final, 推迟一天执行"),
                            {idel_third_final, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
                    end;
                Day =:= 5 -> %% 星期5，推迟1天开打
                    ?INFO("武神坛third_final, 星期五推迟到星期六执行"),
                    {idel_third_final, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)};
                Day =:= 4 -> %% 星期4，推迟2天开打
                    ?INFO("武神坛third_final, 星期四推迟到星期六执行"),
                    {idel_third_final, State, ((util:unixtime({tomorrow, Now}) - Now) + 86400 + ?start_time)};
                true ->
                    if
                        Now < TodayStart ->
                            ?INFO("非正常日期开打，武神坛[~w]秒后进入third_final",[TodayStart - Now]),
                            {idel_third_final, State, TodayStart - Now};
                        true ->
                            ?INFO("非正常日期开打，武神坛third_final, 推迟一天执行"),
                            {idel_third_final, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
                    end
            end;
        third_final ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入third_final",[TodayStart - Now]),
                    {idel_third_final, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛third_final回滚, 推迟一天执行"),
                    {idel_third_final, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire_third_final ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入third_final",[TodayStart - Now]),
                    {idel_third_final, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛third_final回滚, 推迟一天执行"),
                    {idel_third_final, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        idel_final ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后进入final",[TodayStart - Now]),
                    {idel_final, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛final, 推迟一天执行"),
                    {idel_final, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        final ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入final",[TodayStart - Now]),
                    {idel_final, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛final回滚, 推迟一天执行"),
                    {idel_final, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end;
        expire ->
            if
                Now < TodayStart ->
                    ?INFO("武神坛[~w]秒后回滚进入final",[TodayStart - Now]),
                    {idel_final, State, TodayStart - Now};
                true ->
                    ?INFO("武神坛final回滚, 推迟一天执行"),
                    {idel_final, State, ((util:unixtime({tomorrow, Now}) - Now) + ?start_time)}
            end
    end,
    {NewStateName, NewState, TimeOut}.
    
%% @doc 启动竞技场服务进程
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 战区报告收到时,需清空角色战区
update_zone_team([], Teams) -> Teams;
update_zone_team([Team = #cross_warlord_team{team_member = TeamMem} | T], Teams) ->
    NewTeamMem = update_zone_role(TeamMem, []),
    NewTeam = Team#cross_warlord_team{team_member = NewTeamMem},
    update_team(ets, NewTeam),
    update_zone_team(T, [NewTeam | Teams]);
update_zone_team([_ | T], Teams) ->
    ?ERR("收到错误的战斗报告"),
    update_zone_team(T, Teams).

update_zone_role([], NewTeamMem) -> NewTeamMem;
update_zone_role([R | T], NewTeamMem) ->
    NewR = R#cross_warlord_role{zone_seq = 0, zone_pid = undefined, pid = 0},
    update_role(ets, NewR),
    update_zone_role(T, [NewR | NewTeamMem]).

load_data() ->
    case dets:first(dets_cross_warlord_team) of
        '$end_of_table' -> ?INFO("没有武神坛队伍数据");
        _ ->
            dets:traverse(dets_cross_warlord_team,
                fun(Cteam) ->
                        NewCteam = convert_team(Cteam),
                        NewCteam1 = convert(NewCteam),
                        ets:insert(ets_cross_warlord_team, NewCteam1),
                        continue
                end
            ),
            ?INFO("武神坛队伍数据加载完毕")
    end,
    case dets:first(dets_cross_warlord_role) of
        '$end_of_table' -> ?INFO("没有武神坛角色数据");
        _ ->
            dets:traverse(dets_cross_warlord_role,
                fun(Crole) ->
                        NewCrole = convert(Crole),
                        ets:insert(ets_cross_warlord_role, NewCrole),
                        continue
                end
            ),
            ?INFO("武神坛角色数据加载完毕")
    end.

convert_winner(WinnerInfo) ->
    convert_winner(WinnerInfo, []).
convert_winner([], WinnerInfo) -> WinnerInfo;
convert_winner([{Label, TeamName, TeamSrvId, Team} | T], WinnerInfo) ->
    case convert_team(Team) of
        NewTeam when is_record(NewTeam, cross_warlord_team) ->
            convert_winner(T, [{Label, TeamName, TeamSrvId, NewTeam} | WinnerInfo]);
        _ ->
            ?ERR("武神坛冠军版本转换错误"),
            convert_winner(T, WinnerInfo)
    end.

convert_team({cross_warlord_team, TeamCode, TeamSrvId, TeamName, TeamFight, TeamLabel, TeamQuality, TeamZoneSeq, TeamZonePid, Team32Code, Group256, Group128, Group64,Group32, Group16, Group8, Group4, TeamTrialSeq, TeamTrialCode, TeamMem}) ->
    #cross_warlord_team{team_code = TeamCode, team_srv_id = TeamSrvId, team_name = TeamName, team_fight = TeamFight, team_label = TeamLabel, team_quality = TeamQuality, team_zone_seq = TeamZoneSeq, team_zone_pid = TeamZonePid, team_32code = Team32Code, team_group_256 = Group256, team_group_128 = Group128, team_group_64 = Group64,team_group_32 = Group32, team_group_16 = Group16, team_group_8 = Group8, team_group_4 = Group4, team_trial_seq = TeamTrialSeq,team_trial_code = TeamTrialCode, team_member = TeamMem};
convert_team({cross_warlord_team, TeamCode, TeamSrvId, TeamName, TeamFight, TeamLabel, TeamQuality, TeamZoneSeq, TeamZonePid, Team32Code, Group256, Group128, Group64,Group32, Group16, Group8, Group4, TeamTrialSeq, TeamTrialCode, TeamMem, LineId, LineList}) ->
    #cross_warlord_team{team_code = TeamCode, team_srv_id = TeamSrvId, team_name = TeamName, team_fight = TeamFight, team_label = TeamLabel, team_quality = TeamQuality, team_zone_seq = TeamZoneSeq, team_zone_pid = TeamZonePid, team_32code = Team32Code, team_group_256 = Group256, team_group_128 = Group128, team_group_64 = Group64,team_group_32 = Group32, team_group_16 = Group16, team_group_8 = Group8, team_group_4 = Group4, team_trial_seq = TeamTrialSeq,team_trial_code = TeamTrialCode, team_member = TeamMem, lineup_id = LineId, lineup_list = LineList};
convert_team(CrossTeam) when is_record(CrossTeam, cross_warlord_team) ->
    CrossTeam;
convert_team(_Err) ->
    ?DEBUG("~w",[_Err]),
    skip.

convert(CrossRole = #cross_warlord_role{combat_cache = {Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks}}) -> 
    convert(CrossRole#cross_warlord_role{combat_cache = {Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, ascend:init()}});
convert(CrossRole = #cross_warlord_role{combat_cache = {Sex, Career, Lev, HpMax, MpMax, Attr, Eqm, Skill, PetBag, RoleDemon, Looks, Ascend}}) -> 
    Eqm2 = case Eqm of
        [_|_] ->
            case item_parse:do(Eqm) of
                {ok, Eqm1} -> Eqm1;
                _ -> 
                    ?ERR("武神坛装备列表转换错误"),
                    []
            end;
        _ -> []
    end,
    PetBag2 = case pet_parse:do(PetBag) of
        {ok, NewPetPag1} -> 
            NewPetPag1;
        _ ->
            ?ERR("武神坛宠物数据版本转换失败"),
            #pet_bag{}
    end,
    Skill2 = case skill:ver_parse_2(Skill) of
        NewSkill when is_record(NewSkill, skill_all) ->
            NewSkill;
        _ ->
            ?ERR("武神坛技能数据版本转换失败"),
            #skill{}
    end,
    NewRoleDemon = demon:ver_parse(RoleDemon),
    NewAscend = ascend:ver_parse(Ascend),
    NewAttr = role_attr:ver_parse(Attr),
    CrossRole#cross_warlord_role{pid = undefined, zone_pid = undefined, combat_cache = {Sex, Career, Lev, HpMax, MpMax, NewAttr, Eqm2, Skill2, PetBag2, NewRoleDemon, Looks, NewAscend}};

convert(CrossTeam = #cross_warlord_team{team_member = TeamMem}) ->
    NewTeamMem = [convert(CrossRole) || CrossRole <- TeamMem],
    CrossTeam#cross_warlord_team{team_member = NewTeamMem}.

%% 收到暂停命令
switch_close(StateName) ->
    Fun = fun(idel) -> {2, 0, 0, 0, 0};
        (notice) -> {1, 1, 0, 0, 0};
        (prepare) -> {2, 2, 0, 0, 0};
        (trial_round_0) -> {2, 3, 0, 0, 0};
        (expire_trial_0) -> {2, 3, 0, 0, 0};
        (idel_trial_1) -> {2, 4, 0, 0, 0};
        (trial_round_1) -> {2, 5, 0, 0, 0};
        (expire_trial_1) -> {2, 5, 0, 0, 0};
        (idel_trial_2) -> {2, 6, 0, 0, 0};
        (trial_round_2) -> {2, 7, 0, 0, 0};
        (expire_trial_2) -> {2, 7, 0, 0, 0};
        (idel_trial_3) -> {2, 8, 0, 0, 0};
        (trial_round_3) -> {2, 9, 0, 0, 0};
        (expire_trial_3) -> {2, 9, 0, 0, 0};
        (idel_top_16) -> {2, 10, 0, 0, 0};
        (top_16) -> {2, 11, 0, 0, 0};
        (expire_top_16) -> {2, 11, 0, 0, 0};
        (idel_top_8) -> {2, 12, 0, 0, 0};
        (top_8) -> {2, 13, 0, 0, 0};
        (expire_top_8) -> {2, 13, 0, 0, 0};
        (idel_top_4) -> {2, 14, 0, 0, 0};
        (top_4) -> {2, 15, 0, 0, 0};
        (expire_top_4) -> {2, 15, 0, 0, 0};
        (idel_semi_final_1) -> {2, 16, 0, 0, 0};
        (semi_final_1) -> {2, 17, 0, 0, 0};
        (expire_semi_final_1) -> {2, 17, 0, 0, 0};
        (idel_semi_final_2) -> {2, 18, 0, 0, 0};
        (semi_final_2) -> {2, 19, 0, 0, 0};
        (expire_semi_final_2) -> {2, 19, 0, 0, 0};
        (idel_third_final) -> {2, 20, 0, 0, 0};
        (third_final) -> {2, 21, 0, 0, 0};
        (expire_third_final) -> {2, 21, 0, 0, 0};
        (idel_final) -> {2, 22, 0, 0, 0};
        (final) -> {2, 23, 0, 0, 0};
        (expire) -> {2, 23, 0, 0, 0};
        (_) -> {3, 0, 0, 0, 0}
    end,
    sys_env:set(cross_warlord_camp_date, Fun(StateName)),
    ok.

%% ------------------------------------
%% 状态机内部逻辑
%% ------------------------------------

%% 初始化
init([])->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(ets_cross_warlord_team, [named_table, public, set, {keypos, #cross_warlord_team.team_code}]),
    ets:new(ets_cross_warlord_pre, [named_table, public, set, {keypos, #cross_warlord_pre.id}]),
    ets:new(ets_cross_warlord_role, [named_table, public, set, {keypos, #cross_warlord_role.id}]),
    dets:open_file(dets_cross_warlord_role, [{file, "../var/cross_warlord_role.dets"}, {keypos, #cross_warlord_role.id}, {type, set}]),
    dets:open_file(dets_cross_warlord_team, [{file, "../var/cross_warlord_team.dets"}, {keypos, #cross_warlord_team.team_code}, {type, set}]),
    load_data(),
    cross_warlord_log:start_link(),
    cross_warlord_live:start_link(),
    {NewStateName, NewState, NewTimeOut} = case load() of
        {notice, State, TimeOut} -> %% 开启报名区 
            ?INFO("武神坛报名状态, 重新创建报名区"),
            erlang:send_after(10 * 1000, self(), start_pre_zone),
            erlang:send_after(30 * 60 * 1000, self(), sign_notice),
            {notice, State#state{zone_list_sky = [], zone_list_land = []}, TimeOut * 1000};
        {StateName, State, TimeOut} ->
            {StateName, State#state{zone_list_sky = [], zone_list_land = []}, TimeOut * 1000};
        {false, _Reason} ->
            ?ERR("加载武神坛状态异常,Reason:~w",[_Reason]),
            {idel, #state{}, 180 * 1000};
        _Err ->
            ?ERR("加载武神坛状态异常,Err:~w",[_Err]),
            {idel, #state{}, 180 * 1000}
    end,
    erlang:send_after(20 * 1000, self(), check_bet),
    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, NewStateName, NewState#state{ts = erlang:now(), timeout = NewTimeOut}, NewTimeOut}.

%% 开关活动 
handle_event({switch, Switch}, StateName, State) ->
    Fun = fun(?true) -> ?L(<<"关闭">>);
        (?false) -> ?L(<<"开启">>)
    end,
    ?INFO("在~w状态下收到~s命令",[StateName, Fun(Switch)]),
    case Switch of
        ?true ->
            c_mirror_group:cast(all, cross_warlord_mgr, switch_close, [StateName]);
        _ -> skip
    end,
    save(StateName, State#state{switch = Switch}),
    continue(StateName, State#state{switch = Switch});

handle_event(clean_cd, StateName, State) ->
    ?INFO("在~w状态下收到清除比赛冷却时间命令",[StateName]),
    continue(StateName, State#state{next_start_time = 10});

%% 战区结果 
handle_event({report, _, {type_one, [], []}}, StateName, State) ->
    continue(StateName, State);
handle_event({report, Quality, {type_one, WinTeams, LoseTeams}}, StateName, State) ->
    {NowWin, NowLose} = case get(cross_warlord_report) of
        undefined -> {[], []};
        {Win, Lose} when is_list(Win) andalso is_list(Lose) -> {Win, Lose};
        _Err ->
            ?ERR("武神坛取当前战区日志错误:~w",[_Err]),
            {[], []}
    end,
    Log = {type_one, WinTeams, LoseTeams},
    %% 分别发送到日志管理和下注计算
    cross_warlord_log:report(Quality, WinTeams), 
    cross_warlord_log:add_log(Log),
    spawn(fun() -> notice_all(Quality, WinTeams, LoseTeams) end),
    NewWinTeams = update_zone_team(WinTeams, []),
    NewLoseTeams = update_zone_team(LoseTeams, []),
    NewReport = {NowWin ++ NewWinTeams, NowLose ++ NewLoseTeams},
    put(cross_warlord_report, NewReport),
    continue(StateName, State);

handle_event({report, _, {type_two, [], [], []}}, StateName, State) ->
    continue(StateName, State);
handle_event({report, Quality, {type_two, WinTeams, LoseTeams, TeamPoint}}, StateName, State) ->
    {NowWin, NowLose} = case get(cross_warlord_report) of
        undefined -> {[], []};
        {Win, Lose} when is_list(Win) andalso is_list(Lose) -> {Win, Lose};
        _Err ->
            ?ERR("武神坛取当前战区日志错误:~w",[_Err]),
            {[], []}
    end,
    Log = {type_two, WinTeams, LoseTeams, TeamPoint},
    %% 分别发送到日志管理和下注计算
    cross_warlord_log:report(Quality, WinTeams), 
    cross_warlord_log:add_log(Log),
    spawn(fun() -> notice_all(Quality, WinTeams, LoseTeams) end),
    NewWinTeams = update_zone_team(WinTeams, []),
    NewLoseTeams = update_zone_team(LoseTeams, []),
    NewReport = {NowWin ++ NewWinTeams, NowLose ++ NewLoseTeams},
    put(cross_warlord_report, NewReport),
    continue(StateName, State);

%% 战区关闭
handle_event({zone_stop, ?cross_warlord_label_land, Seq}, StateName, State = #state{zone_list_land = LandZoneList}) ->
    case lists:keyfind(Seq, #cross_warlord_zone.seq, LandZoneList) of
        false -> 
            ?ERR("收到未知战区关闭:~w",[Seq]),
            continue(StateName, State);
        _ ->
            NewLandZoneList = lists:keydelete(Seq, #cross_warlord_zone.seq, LandZoneList),
            continue(StateName, State#state{zone_list_land = NewLandZoneList})
    end;
handle_event({zone_stop, ?cross_warlord_label_sky, Seq}, StateName, State = #state{zone_list_sky = SkyZoneList}) ->
    case lists:keyfind(Seq, #cross_warlord_zone.seq, SkyZoneList) of
        false -> 
            ?ERR("收到未知战区关闭:~w",[Seq]),
            continue(StateName, State);
        _ ->
            NewSkyZoneList = lists:keydelete(Seq, #cross_warlord_zone.seq, SkyZoneList),
            continue(StateName, State#state{zone_list_sky = NewSkyZoneList})
    end;

%% 角色进入报名区
handle_event({role_enter, PreRole = #cross_warlord_pre_role{id = RoleId, pid = RolePid}, RoomId}, notice, State) ->
    case lookup(by_id, RoomId) of
        false -> 
            role:pack_send(RolePid, 18100, {0, ?L(<<"请求进入的房间不存在">>)});
        #cross_warlord_pre{role_size = Num} when Num >= 250 ->
            role:pack_send(RolePid, 18100, {0, ?L(<<"该房间已满人，不可以再进入">>)});
        Map = #cross_warlord_pre{map_id = MapId, role_list = Roles} ->
            NewRoles = case lists:keyfind(RoleId, #cross_warlord_pre_role.id, Roles) of
                false -> [PreRole | Roles];
                Old ->
                    lists:keyreplace(RoleId, #cross_warlord_pre_role.id, Roles, Old#cross_warlord_pre_role{pid = RolePid})
            end,
            NewMap = Map#cross_warlord_pre{role_size = length(NewRoles), role_list = NewRoles},
            update_map(NewMap),
            role:apply(async, RolePid, {cross_warlord_mgr, apply_enter_map, [MapId]})
    end,
    continue(notice, State);
handle_event({role_enter, #cross_warlord_pre_role{pid = RolePid}, _}, StateName, State) ->
    role:pack_send(RolePid, 18100, {0, ?L(<<"当前不是报名阶段，不能进入报名区">>)}),
    continue(StateName, State);

%% 角色退出准备区
handle_event({role_leave, RoleId, _RolePid, MapId}, StateName, State) ->
    case lookup(by_mapid, MapId) of
        false -> skip;
        Map = #cross_warlord_pre{role_list = RoleList} ->
            NewRoles = [Role || Role <- RoleList, Role#cross_warlord_pre_role.id =/= RoleId],
            NewMap = Map#cross_warlord_pre{role_size = length(NewRoles), role_list = NewRoles},
            update_map(NewMap)
    end,
    continue(StateName, State);

handle_event({sign, TeamName, TeamInfo, PidInfo, TeamSrvId, TeamFight, TeamLineUpList}, notice, State = #state{sign_code = SignCode, sign_day = SignDay}) ->
    case lookup_roles(TeamInfo) of
        ok ->
            case lookup(team_name, TeamName) of
                false ->
                    NewTeamInfo = [T#cross_warlord_role{team_code = SignCode} || T <- TeamInfo], 
                    Team = #cross_warlord_team{team_code = SignCode, team_srv_id = TeamSrvId, team_name = TeamName, team_fight = TeamFight, team_member = NewTeamInfo, lineup_list = TeamLineUpList},
                    update_role(all, NewTeamInfo),
                    update_team(all, Team),
                    cross_warlord_log:add_team(Team),
                    cross_warlord:pack_to_team(PidInfo, 18103, {?true, util:fbin(?L(<<"报名成功, 队伍名为:~s">>), [TeamName])}), 
                    spawn(cross_warlord, pack_to_sign, [TeamName, NewTeamInfo, SignDay]),
                    NewState = State#state{sign_code = SignCode + 1},
                    save(notice, NewState),
                    continue(notice, NewState);
                _ ->
                    cross_warlord:pack_to_team(PidInfo, 18103, {?false, ?L(<<"已经有队伍注册该名字,请换个名字">>)}), 
                    continue(notice, State)
            end;
        {false, Reason} ->
            cross_warlord:pack_to_team(PidInfo, 18103, {?false, Reason}), 
            continue(notice, State)
    end;
handle_event({sign, _, _, PidInfo, _, _}, StateName, State) ->
    cross_warlord:pack_to_team(PidInfo, 18103, {?false, ?L(<<"当前不是报名阶段, 不能报名">>)}), 
    continue(StateName, State);

handle_event(_Event, StateName, State) ->
    continue(StateName, State).

%% 下注前三甲
handle_sync_event({bet_top_3, {Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, Coin}, _From, idel_top_16, State) ->
    case catch cross_warlord_log:bet_top_3({Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, Coin) of
        ok ->
            continue(idel_top_16, ok, State);
        {false, Reason} ->
            continue(idel_top_16, {false, Reason}, State);
        _ ->
            continue(idel_top_16, {false, ?L(<<"竞猜失败">>)}, State)
    end;
handle_sync_event({bet_top_3, _, _, _, _, _, _}, _From, StateName, State) ->
    continue(StateName, {false, ?L(<<"当前活动阶段不可以进行竞猜前三甲">>)}, State);

%% 下注16强
handle_sync_event({bet_16_team, {Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, TeamCode4, TeamCode5, TeamCode6, TeamCode7, TeamCode8, TeamCode9, TeamCode10, TeamCode11, TeamCode12, TeamCode13, TeamCode14, TeamCode15, TeamCode16, Coin}, _From, idel_top_16, State) ->
    case catch cross_warlord_log:bet_16_team({Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, TeamCode4, TeamCode5, TeamCode6, TeamCode7, TeamCode8, TeamCode9, TeamCode10, TeamCode11, TeamCode12, TeamCode13, TeamCode14, TeamCode15, TeamCode16, Coin) of
        ok ->
            continue(idel_top_16, ok, State);
        {false, Reason} ->
            continue(idel_top_16, {false, Reason}, State);
        _ ->
            continue(idel_top_16, {false, ?L(<<"竞猜失败">>)}, State)
    end;
handle_sync_event({bet_16_team, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _}, _From, StateName, State) ->
    continue(StateName, {false, ?L(<<"当前活动阶段不可以进行竞猜16强">>)}, State);

%% 下注某场比赛
handle_sync_event({bet_team, {Rid, SrvId}, Label, Seq, TeamCode, Coin},  _From, idel_top_4, State) ->
    case catch cross_warlord_log:bet_team({Rid, SrvId}, ?cross_warlord_quality_top_8, Label, Seq, TeamCode, Coin) of
        ok ->
            continue(idel_top_4, ok, State);
        {false, Reason} -> 
            continue(idel_top_4, {false, Reason}, State);
        _ ->
            continue(idel_top_4, {false, ?L(<<"投注失败">>)}, State)
    end;
handle_sync_event({bet_team, {Rid, SrvId}, Label, Seq, TeamCode, Coin},  _From, idel_semi_final_1, State) ->
    case catch cross_warlord_log:bet_team({Rid, SrvId}, ?cross_warlord_quality_top_4_1, Label, Seq, TeamCode, Coin) of
        ok ->
            continue(idel_semi_final_1, ok, State);
        {false, Reason} -> 
            continue(idel_semi_final_1, {false, Reason}, State);
        _ ->
            continue(idel_semi_final_1, {false, ?L(<<"投注失败">>)}, State)
    end;
handle_sync_event({bet_team, {Rid, SrvId}, Label, Seq, TeamCode, Coin},  _From, idel_semi_final_2, State) ->
    case catch cross_warlord_log:bet_team({Rid, SrvId}, ?cross_warlord_quality_top_4_2, Label, Seq, TeamCode, Coin) of
        ok ->
            continue(idel_semi_final_2, ok, State);
        {false, Reason} -> 
            continue(idel_semi_final_2, {false, Reason}, State);
        _ ->
            continue(idel_semi_final_2, {false, ?L(<<"投注失败">>)}, State)
    end;
handle_sync_event({bet_team, {Rid, SrvId}, Label, Seq, TeamCode, Coin},  _From, idel_third_final, State) ->
    case catch cross_warlord_log:bet_team({Rid, SrvId}, ?cross_warlord_quality_semi_final, Label, Seq, TeamCode, Coin) of
        ok ->
            continue(idel_third_final, ok, State);
        {false, Reason} -> 
            continue(idel_third_final, {false, Reason}, State);
        _ ->
            continue(idel_third_final, {false, ?L(<<"投注失败">>)}, State)
    end;
handle_sync_event({bet_team, {Rid, SrvId}, Label, Seq, TeamCode, Coin},  _From, idel_final, State) ->
    case catch cross_warlord_log:bet_team({Rid, SrvId}, ?cross_warlord_quality_final, Label, Seq, TeamCode, Coin) of
        ok ->
            continue(idel_final, ok, State);
        {false, Reason} -> 
            continue(idel_final, {false, Reason}, State);
        _ ->
            continue(idel_final, {false, ?L(<<"投注失败">>)}, State)
    end;
handle_sync_event({bet_team, _, _, _, _, _}, _From, StateName, State) ->
    continue(StateName, {false, ?L(<<"当前活动阶段不可以进行投注">>)}, State);

handle_sync_event(get_camp_status, _From, StateName, State = #state{ts = Ts, timeout = _Timeout}) ->
    Fun = fun(idel) -> {0, 0};
        (notice) -> {1, 0};
        (prepare) -> {2, 0};
        (trial_round_0) -> {3, Ts};
        (expire_trial_0) -> {4, 0};
        (idel_trial_1) -> {4, 0};
        (trial_round_1) -> {5, Ts};
        (expire_trial_1) -> {6, 0};
        (idel_trial_2) -> {6, 0};
        (trial_round_2) -> {7, Ts};
        (expire_trial_2) -> {8, 0};
        (idel_trial_3) -> {8, 0};
        (trial_round_3) -> {9, Ts};
        (expire_trial_3) -> {10, 0};

        (idel_top_16) -> {10, 0};
        (top_16) -> {11, Ts};
        (expire_top_16) -> {12, 0};

        (idel_top_8) -> {12, 0};
        (top_8) -> {13, Ts};
        (expire_top_8) -> {14, 0};

        (idel_top_4) -> {14, 0};
        (top_4) -> {15, Ts};
        (expire_top_4) -> {16, 0};

        (idel_semi_final_1) -> {16, 0};
        (semi_final_1) -> {17, Ts};
        (expire_semi_final_1) -> {18, 0};

        (idel_semi_final_2) -> {18, 0};
        (semi_final_2) -> {19, Ts};
        (expire_semi_final_2) -> {20, 0};

        (idel_third_final) -> {20, 0};
        (third_final) -> {21, Ts};
        (expire_third_final) -> {22, 0};

        (idel_final) -> {22, 0};
        (final) -> {23, Ts};
        (expire) -> {0, 0}
    end,
    continue(StateName, {ok, Fun(StateName)}, State);

handle_sync_event(get_camp_date, _From, StateName, State = #state{switch = Switch, ts = Ts, timeout = Timeout}) ->
    Flag = case Switch of
        ?true -> 2;
        ?false -> 1
    end,
    {M, S, _} = Ts,
    EndUnixTime = M * 1000000 + S + (Timeout div 1000),
    StartTime = M * 1000000 + S, 
    Fun = fun(idel) -> {Flag, 0, 0, 0, 0};
        (notice) -> {Flag, 1, 0, 0, 0};
        (prepare) -> {Flag, 2, EndUnixTime, 4, EndUnixTime + 86400};
        (trial_round_0) -> {Flag, 3, StartTime, 4, StartTime + 86400};
        (expire_trial_0) -> {Flag, 3, StartTime, 4, StartTime + 86400};
        (idel_trial_1) -> {Flag, 4, EndUnixTime, 6, EndUnixTime + 86400};
        (trial_round_1) -> {Flag, 5, StartTime, 6, StartTime + 86400};
        (expire_trial_1) -> {Flag, 5, StartTime, 6, StartTime + 86400};
        (idel_trial_2) -> {Flag, 6, EndUnixTime, 8, EndUnixTime + 86400};
        (trial_round_2) -> {Flag, 7, StartTime, 8, StartTime + 86400};
        (expire_trial_2) -> {Flag, 7, StartTime, 8, StartTime, + 86400};
        (idel_trial_3) -> {Flag, 8, EndUnixTime, 10, EndUnixTime + 86400};
        (trial_round_3) -> {Flag, 9, StartTime, 10, StartTime + 86400};
        (expire_trial_3) -> {Flag, 9, StartTime, 10, StartTime + 86400};
        (idel_top_16) -> {Flag, 10, EndUnixTime, 12, EndUnixTime + 86400};
        (top_16) -> {Flag, 11, StartTime, 12, StartTime + 86400};
        (expire_top_16) -> {Flag, 11, StartTime, 12, StartTime + 86400};
        (idel_top_8) -> {Flag, 12, EndUnixTime, 14, EndUnixTime + 86400};
        (top_8) -> {Flag, 13, StartTime, 14, StartTime + 86400};
        (expire_top_8) -> {Flag, 13, StartTime, 14, StartTime + 86400};
        (idel_top_4) -> {Flag, 14, EndUnixTime, 16, EndUnixTime + 86400};
        (top_4) -> {Flag, 15, StartTime, 16, StartTime + 86400};
        (expire_top_4) -> {Flag, 15, StartTime, 16, StartTime + 86400};
        (idel_semi_final_1) -> {Flag, 16, EndUnixTime, 18, EndUnixTime + 86400};
        (semi_final_1) -> {Flag, 17, StartTime, 18, StartTime + 86400};
        (expire_semi_final_1) -> {Flag, 17, StartTime, 18, StartTime + 86400};
        (idel_semi_final_2) -> {Flag, 18, EndUnixTime, 20, EndUnixTime + (86400 * 2)};
        (semi_final_2) -> {Flag, 19, StartTime, 20, StartTime + (86400 * 2)};
        (expire_semi_final_2) -> {Flag, 19, StartTime, 20, StartTime + (86400 * 2)};
        (idel_third_final) -> {Flag, 20, EndUnixTime, 22, EndUnixTime + 86400};
        (third_final) -> {Flag, 21, StartTime, 22, StartTime + 86400};
        (expire_third_final) -> {Flag, 21, StartTime, 22, StartTime + 86400};
        (idel_final) -> {Flag, 22, EndUnixTime, 0, 0};
        (final) -> {Flag, 23, StartTime, 0, 0};
        (expire) -> {Flag, 23, StartTime, 0, 0}
    end,
    continue(StateName, {ok, Fun(StateName)}, State);

handle_sync_event(get_room_list, _From, notice, State) ->
    L = ets:tab2list(ets_cross_warlord_pre),
    RoomList = [{Id, Size} || #cross_warlord_pre{id = Id, role_size = Size} <- L],
    continue(notice, {ok, RoomList}, State);
handle_sync_event(get_room_list, _From, StateName, State) ->
    continue(StateName, {ok, []}, State);

handle_sync_event(status, _From, StateName, State = #state{switch = Switch, ts = Ts, timeout = Timeout}) ->
    continue(StateName, {Switch, StateName, util:time_left(Timeout, Ts) div 1000}, State);

handle_sync_event({get_last_winer, Label}, _From, StateName, State = #state{last_winner = LastWinner}) ->
    Reply = case lists:keyfind(Label, 1, LastWinner) of
        {Label, _, _, #cross_warlord_team{team_name = TeamName, team_member = TeamMem}} ->
            RoleList = [{Rid, SrvId, Name, Career, Sex, Lev, Vip, FightCapacity, PetFight, Looks} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, lev = Lev, vip = Vip, fight_capacity = FightCapacity, pet_fight = PetFight, looks = Looks} <- TeamMem],
            {TeamName, RoleList};
        _ -> null
    end,
    continue(StateName, Reply, State);

handle_sync_event({get_last_info, Label}, _From, StateName, State = #state{state_lev = StateLev, last_winner = LastWinner}) ->
    case get_war_list(Label) of
        {InfoList, Code, Name, SrvId, Roles} -> 
            LastInfo = [{WinLabel, WinnerName, WinSrvId} || {WinLabel, WinnerName, WinSrvId, _} <- LastWinner],
            continue(StateName, {StateLev, LastInfo, InfoList, Code, Name, SrvId, Roles}, State);
        _ ->
            continue(StateName, false, State)
    end;

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(StateName, Reply, State).

handle_info(start_pre_zone, StateName, State) ->
    start_pre_zone(),
    continue(StateName, State);

handle_info(check_bet, idel_top_16, State) ->
    cross_warlord_log:make_top_32(),
    cross_warlord_log:make_16_bet(),
    continue(idel_top_16, State);
handle_info(check_bet, idel_top_4, State) ->
    cross_warlord_log:make_bet(?cross_warlord_quality_top_8),
    continue(idel_top_4, State);
handle_info(check_bet, idel_semi_final_1, State) ->
    cross_warlord_log:make_bet(?cross_warlord_quality_top_4_1),
    continue(idel_semi_final_1, State);
handle_info(check_bet, idel_semi_final_2, State) ->
    cross_warlord_log:make_bet(?cross_warlord_quality_top_4_2),
    continue(idel_semi_final_2, State);
handle_info(check_bet, idel_third_final, State) ->
    cross_warlord_log:make_bet(?cross_warlord_quality_semi_final),
    continue(idel_third_final, State);
handle_info(check_bet, idel_final, State) ->
    cross_warlord_log:make_bet(?cross_warlord_quality_final),
    continue(idel_final, State);
handle_info(check_bet, StateName, State) ->
    continue(StateName, State);

handle_info(sign_notice, notice, State = #state{state_lev = StateLev}) ->
    c_mirror_group:cast(all, cross_warlord, sign_notice, [StateLev]),
    erlang:send_after(30 * 60 * 1000, self(), sign_notice),
    continue(notice, State);

handle_info(sign_notice, StateName, State) ->
    continue(StateName, State);

handle_info(check_sign_day, notice, State = #state{sign_day = SignDay}) ->
    NewSignDay = case SignDay > 0 of
        true -> SignDay - 1;
        false -> 0
    end,
    NewState = State#state{sign_day = NewSignDay},
    ?INFO("报名剩余天数减一"),
    save(notice, NewState),
    continue(notice, NewState);

%% 保存信息
handle_info(save_state, StateName, State) ->
    save(StateName, State),
    erlang:send_after(30 * 60 * 1000, self(), save_state),
    continue(StateName, State);
handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------
lookup_roles([]) -> ok;
lookup_roles([#cross_warlord_role{id = Id, name = Name} | T]) ->
    case ets:lookup(ets_cross_warlord_role, Id) of
        [Crole] when is_record(Crole, cross_warlord_role) ->
            {false, util:fbin(?L(<<"~s已经报名武神坛,不能再次报名">>), [Name])};
        [] ->
            lookup_roles(T);
        _Err ->
            ?ERR("武神坛存在异常的角色数据,[~s]",[Name]),
            {false, util:fbin(?L(<<"~s已经报名武神坛,不能再次报名">>), [Name])}
    end.

lookup(by_id, Id) ->
    L = ets:tab2list(ets_cross_warlord_pre),
    lists:keyfind(Id, #cross_warlord_pre.id, L);

%% 查找对应准备区地图
lookup(by_mapid, MapId) ->
    L = ets:tab2list(ets_cross_warlord_pre),
    lists:keyfind(MapId, #cross_warlord_pre.map_id, L);

lookup(team_name, TeamName) ->
    L = ets:tab2list(ets_cross_warlord_team),
    lists:keyfind(TeamName, #cross_warlord_team.team_name, L).

%%  更新队伍数据
update_team(_, []) -> ok;
update_team(all, [Team | LastTeam]) ->
    update_team(all, Team),
    update_team(all, LastTeam); 
update_team(all, Team) when is_record(Team, cross_warlord_team) ->
    ets:insert(ets_cross_warlord_team, Team),
    dets:insert(dets_cross_warlord_team, Team);
update_team(ets, [Team | LastTeam]) ->
    update_team(ets, Team),
    update_team(ets, LastTeam); 
update_team(ets, Team) when is_record(Team, cross_warlord_team) ->
    ets:insert(ets_cross_warlord_team, Team);
update_team(_, _) -> skip.

%% 更新角色数据
update_role(_, []) -> ok;
update_role(all, [Role | LastRole]) ->
    update_role(all, Role),
    update_role(all, LastRole); 
update_role(all, Role) when is_record(Role, cross_warlord_role) ->
    ets:insert(ets_cross_warlord_role, Role),
    dets:insert(dets_cross_warlord_role, Role);
update_role(ets, [Role | LastRole]) ->
    update_role(ets, Role),
    update_role(ets, LastRole); 
update_role(ets, Role) when is_record(Role, cross_warlord_role) ->
    ets:insert(ets_cross_warlord_role, Role);
update_role(_, _) -> skip.

%% 获取TeamCode的队员
get_team(TeamCode) ->
    case ets:lookup(ets_cross_warlord_team, TeamCode) of
        [#cross_warlord_team{team_name = TeamName, team_member = TeamMem}] ->
            RoleList = [{Rid, SrvId, Name, Career, Sex, Lev, Vip, FightCapacity, PetFight, Looks} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, career = Career, sex = Sex, lev = Lev, vip = Vip, fight_capacity = FightCapacity, pet_fight = PetFight, looks = Looks} <- TeamMem],
            {TeamName, RoleList};
        _ -> false 
    end.

%% 获取Type资格的队伍
get_team(Type, Label) ->
    TeamMs = [{
            #cross_warlord_team{team_quality = '$1', team_label = '$2', _ = '_'},
            [{'andalso', {'=:=', '$1', Type}, {'=:=', '$2', Label}}],
            ['$_']
        }],
    ets:select(ets_cross_warlord_team, TeamMs).

%% 获取预选赛的战区队伍
get_trial_team(Zone, Label) ->
    TeamMs = [{
            #cross_warlord_team{team_trial_seq = '$1', team_label = '$2', _ = '_'},
            [{'andalso', {'=:=', '$1', Zone}, {'=:=', '$2', Label}}],
            ['$_']
        }],
    L = ets:select(ets_cross_warlord_team, TeamMs),
    {InfoList, Winner} = do_get_triail_team(L),
    case Winner of
        [] ->
            {InfoList, 0, <<"">>, <<"">>, []};
        {Code, Name, SrvId, Roles} ->
            {InfoList, Code, Name, SrvId, Roles}
    end.

do_get_triail_team(L) ->
    do_get_triail_team(L, [], []).
do_get_triail_team([], InfoList, Winner) -> {InfoList, Winner};
do_get_triail_team([#cross_warlord_team{team_code = Code, team_trial_code = TeamTrialCode, team_srv_id = TeamSrvId, team_name = TeamName, team_quality = Quality, team_member = TeamMem} | T], InfoList, _) when Quality >= ?cross_warlord_quality_top_32 ->
    Info = {Code, TeamTrialCode, TeamName, TeamSrvId, Quality},
    TeamRole = [{Id, SrvId, Name, FaceId} || #cross_warlord_role{id = {Id, SrvId}, name = Name, face_id = FaceId} <- TeamMem],
    do_get_triail_team(T, [Info | InfoList], {Code, TeamName, TeamSrvId, TeamRole});
do_get_triail_team([#cross_warlord_team{team_code = Code, team_trial_code = TeamTrialCode, team_name = TeamName, team_srv_id = TeamSrvId, team_quality = TeamQuality} | T], InfoList, Winner) ->
    Info = {Code, TeamTrialCode, TeamName, TeamSrvId, TeamQuality},
    do_get_triail_team(T, [Info | InfoList], Winner).

%% 获取角色所在的选拔赛区
get_role_trial_info(Id) ->
    case ets:lookup(ets_cross_warlord_role, Id) of
        [#cross_warlord_role{team_code = TeamCode}] ->
            case ets:lookup(ets_cross_warlord_team, TeamCode) of
                [#cross_warlord_team{team_label = Label, team_trial_seq = Seq}] when Seq =/= 0 ->
                    {Seq, Label};
                _ -> {0, 0}
            end;
        _ -> {0, 0}
    end.

%% 更新准备区地图
update_map(NewMap) when is_record(NewMap, cross_warlord_pre)->
    ets:insert(ets_cross_warlord_pre, NewMap);
update_map(_) -> skip.

%% 开启准备区
start_pre_zone() ->
    start_pre_zone(25).
start_pre_zone(Num) when Num =< 0 ->
    PreList = ets:tab2list(ets_cross_warlord_pre),
    ?INFO("创建武神坛报名地图完毕,共创建~w个报名地图",[length(PreList)]),
    ok;
start_pre_zone(Num) ->
    do_create_map(Num, prepare),
    start_pre_zone(Num - 1).

do_create_map(Num, prepare) ->
    case map_mgr:create(36021) of
        {false, Reason} ->
            ?ERR("创建武神坛报名地图失败[MapBaseId:~w]:~s", [36021, Reason]);
        {ok, MapPid, MapId} ->
            CrossPre = #cross_warlord_pre{id = Num, map_id = MapId, map_pid = MapPid},
            update_map(CrossPre)
    end.

clean_pre_role() ->
    RoomList = ets:tab2list(ets_cross_warlord_pre),
    clean_pre_role(RoomList).

%% 剔除准备区的所有角色
clean_pre_role([]) -> ok;
clean_pre_role([#cross_warlord_pre{map_id = MapId, role_list = RoleList} | T]) ->
    lists:foreach(fun(#cross_warlord_pre_role{pid = Pid}) ->
                case is_pid(Pid) of
                    true ->
                        role:apply(async, Pid, {cross_warlord_mgr, async_leave_pre_map, []});
                    _ ->
                        ok
                end
        end, RoleList),
    close_all_pre(MapId),
    clean_pre_role(T).

%% 关闭所有准备区地图
close_all_pre(MapId) ->
    ?DEBUG("关闭武神坛报名区:~w",[MapId]),
    map_mgr:stop(MapId).

%% 进入准备区
apply_enter_map(Role = #role{id = RoleId, pid = Pid, link = #link{conn_pid = ConnPid}, event = ?event_no}, MapId) ->
    {X1, Y1} = util:rand_list([{2460, 1830}, {2460, 930}]), %% 随机点
    {X, Y} = {X1 + util:rand(-100, 100), Y1 + util:rand(-100, 100)},
    case map:role_enter(MapId, X, Y, Role#role{event = ?event_cross_warlord_prepare, cross_srv_id = <<"center">>}) of
        {ok, NewRole} -> 
            {ok, NewRole};
        _E ->
            ?ERR("进入武神坛报名地图失败：~w", [_E]),
            center:cast(cross_warlord_mgr, role_leave, [RoleId, Pid, MapId]),
            sys_conn:pack_send(ConnPid, 18100, {0, ?L(<<"进入武神坛报名地图失败">>)}),
            {ok}
    end;
apply_enter_map(_Role, _MapId) ->
    ?ERR("玩家异步进入武神坛地图异常[NAME:~s, SRV:~s]", [_Role#role.name, _Role#role.cross_srv_id]),
    {ok}.

%% 离开准备区

async_leave_pre_map(Role = #role{event = ?event_cross_warlord_prepare, team_pid = TeamPid, team = #role_team{is_leader = ?true}}) when is_pid(TeamPid) ->
    team:stop(TeamPid),
    Rand = util:rand(-10, 10),
    {_, X1, Y1} = util:rand_list(?cross_warlord_exit),
    X = X1 + Rand,
    Y = Y1 + Rand,
    case map:role_enter(10003, X, Y, Role#role{cross_srv_id = <<>>, event = ?event_no}) of
        {ok, NewRole} -> {ok, NewRole};
        _E ->
            ?ERR("退出跨服地图失败：~w", [_E]),
            {ok}
    end;
async_leave_pre_map(Role = #role{event = ?event_cross_warlord_prepare}) ->
    Rand = util:rand(-10, 10),
    {_, X1, Y1} = util:rand_list(?cross_warlord_exit),
    X = X1 + Rand,
    Y = Y1 + Rand,
    case map:role_enter(10003, X, Y, Role#role{cross_srv_id = <<>>, event = ?event_no}) of
        {ok, NewRole} -> {ok, NewRole};
        _E ->
            ?ERR("退出跨服地图失败：~w", [_E]),
            {ok}
    end;
async_leave_pre_map(_Role) ->
    {ok}.

%% 开启战区
start_zone(Type, State) ->
    case cross_warlord_data:get_zone_type(Type) of
        false -> {false, ?L(<<"不存在该类型的比赛">>)};
        {mode_1, ZoneNum, StartSeq} ->
            SkyZoneList = do_start_zone(Type, ?cross_warlord_label_sky, mode_1, ZoneNum, StartSeq),
            LandZoneList = do_start_zone(Type, ?cross_warlord_label_land, mode_1, ZoneNum, StartSeq),
            NewState = State#state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList},
            SkyTeam = get_team(Type, ?cross_warlord_label_sky),
            LandTeam = get_team(Type, ?cross_warlord_label_land),
            set_team_zone(Type, SkyTeam, SkyZoneList),
            set_team_zone(Type, LandTeam, LandZoneList),
            {ok, NewState};
        {mode_2, ZoneNum, StartSeq} ->
            SkyZoneList = do_start_zone(Type, ?cross_warlord_label_sky, mode_2, ZoneNum, StartSeq),
            LandZoneList = do_start_zone(Type, ?cross_warlord_label_land, mode_2, ZoneNum, StartSeq),
            NewState = State#state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList},
            SkyTeam = get_team(Type, ?cross_warlord_label_sky),
            LandTeam = get_team(Type, ?cross_warlord_label_land),
            set_team_zone(Type, SkyTeam, SkyZoneList),
            set_team_zone(Type, LandTeam, LandZoneList),
            {ok, NewState};
        _Err -> {false, _Err}
    end.

do_start_zone(Type, Flag, Mode, Num, Seq) ->
    do_start_zone(Type, Flag, Mode, Num, Seq, []).
do_start_zone(_, _, _, 0, _, ZoneList) -> ZoneList;
do_start_zone(Type, Flag, mode_1, ZoneNum, ZoneSeq, ZoneList) ->
    case cross_warlord_type_one:start_link(ZoneSeq, Type, Flag) of
        {ok, Pid} ->
            ?INFO("武神坛类型[~w]第~w战区启动成功",[Flag, ZoneSeq]),
            do_start_zone(Type, Flag, mode_1, ZoneNum - 1, ZoneSeq + 1, [#cross_warlord_zone{seq = ZoneSeq, pid = Pid} | ZoneList]);
        _Err ->
            ?ERR("武神坛类型[~w]第~w战区启动失败,Reason:~w",[Flag, ZoneSeq, _Err]),
            do_start_zone(Type, Flag, mode_1, ZoneNum - 1, ZoneSeq + 1, ZoneList)
    end;
do_start_zone(Type, Flag, mode_2, ZoneNum, ZoneSeq, ZoneList) ->
    case cross_warlord_type_two:start_link(ZoneSeq, Type, Flag) of
        {ok, Pid} ->
            ?INFO("武神坛类型[~w]第~w战区启动成功",[Flag, ZoneSeq]),
            do_start_zone(Type, Flag, mode_2, ZoneNum - 1, ZoneSeq + 1, [#cross_warlord_zone{seq = ZoneSeq, pid = Pid} | ZoneList]);
        _Err ->
            ?ERR("武神坛类型[~w]第~w战区启动失败,Reason:~w",[Flag, ZoneSeq, _Err]),
            do_start_zone(Type, Flag, mode_2, ZoneNum - 1, ZoneSeq + 1, ZoneList)
    end.

%% 256强队伍 进行更新
update_trial_team(Teams, Label) ->
    update_trial_team(Teams, Label, 1).
update_trial_team([], _, _) -> ok;
update_trial_team([Team = #cross_warlord_team{team_member = TeamMem} | T], Label, Rank) ->
    %% {战区号, 编号}
    {TrialSeq, TrialCode} = cross_warlord_data:rank_to_zone(Rank),
    Group512 = util:ceil(TrialCode/2),
    Group256 = util:ceil(TrialCode/4),
    Group128 = util:ceil(TrialCode/8),
    Group64 = util:ceil(TrialCode/16),
    NewTeam = Team#cross_warlord_team{team_quality = ?cross_warlord_quality_trial_0, team_group_512 = Group512, team_group_256 = Group256, team_group_128 = Group128, team_group_64 = Group64, team_trial_seq = TrialSeq, team_label = Label, team_trial_code = TrialCode},
    update_team(all, NewTeam),
    update_role(all, TeamMem),
    update_trial_team(T, Label, Rank + 1).


%% 更新队伍和角色的战区数据
set_team_zone(_Type, [], _ZoneList) -> ok;
set_team_zone(?cross_warlord_quality_trial_0, [Team = #cross_warlord_team{team_group_512 = Group512, team_trial_seq = TrialSeq} | T], ZoneList) ->
    Seq = Group512 + ((TrialSeq - 1) * 8),
    case lists:keyfind(Seq, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集512强第~w战区异常, 无法获取战区进程",[Seq]),
            set_team_zone(?cross_warlord_quality_trial_0, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {Seq, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = Seq}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_trial_0, T, ZoneList)
    end;
set_team_zone(?cross_warlord_quality_trial_1, [Team = #cross_warlord_team{team_group_256 = Group256, team_trial_seq = TrialSeq} | T], ZoneList) ->
    Seq = Group256 + ((TrialSeq - 1) * 4),
    case lists:keyfind(Seq, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集256强第~w战区异常, 无法获取战区进程",[Seq]),
            set_team_zone(?cross_warlord_quality_trial_1, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {Seq, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = Seq}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_trial_1, T, ZoneList)
    end;
set_team_zone(?cross_warlord_quality_trial_2, [Team = #cross_warlord_team{team_group_128 = Group128, team_trial_seq = TrialSeq} | T], ZoneList) ->
    Seq = Group128 + ((TrialSeq - 1) * 2),
    case lists:keyfind(Seq, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集128强第~w战区异常, 无法获取战区进程",[Seq]),
            set_team_zone(?cross_warlord_quality_trial_2, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {Seq, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = Seq}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_trial_2, T, ZoneList)
    end;
set_team_zone(?cross_warlord_quality_trial_3, [Team = #cross_warlord_team{team_group_64 = Group64, team_trial_seq = TrialSeq} | T], ZoneList) ->
    Seq = Group64 + ((TrialSeq - 1) * 1),
    case lists:keyfind(Seq, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集64强第~w战区异常, 无法获取战区进程",[Seq]),
            set_team_zone(?cross_warlord_quality_trial_3, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {Seq, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = Seq}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_trial_3, T, ZoneList)
    end;
set_team_zone(?cross_warlord_quality_top_32, [Team = #cross_warlord_team{team_group_32 = Group32}| T], ZoneList) ->
    case lists:keyfind(Group32, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集32强第~w战区异常, 无法获取战区进程",[Group32]),
            set_team_zone(?cross_warlord_quality_top_32, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {Group32, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = Group32}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_top_32, T, ZoneList)
    end;
set_team_zone(?cross_warlord_quality_top_16, [Team = #cross_warlord_team{team_group_16 = Group16}| T], ZoneList) ->
    case lists:keyfind(Group16, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集16强第~w战区异常, 无法获取战区进程",[Group16]),
            set_team_zone(?cross_warlord_quality_top_16, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {Group16, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = Group16}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_top_16, T, ZoneList)
    end;
set_team_zone(?cross_warlord_quality_top_8, [Team = #cross_warlord_team{team_group_8 = Group8}| T], ZoneList) ->
    case lists:keyfind(Group8, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集8强第~w战区异常, 无法获取战区进程",[Group8]),
            set_team_zone(?cross_warlord_quality_top_8, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {Group8, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = Group8}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_top_8, T, ZoneList)
    end;
set_team_zone(?cross_warlord_quality_top_4_1, [Team = #cross_warlord_team{team_group_4 = Group4}| T], ZoneList) ->
    case lists:keyfind(Group4, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集4强第~w战区异常, 无法获取战区进程",[Group4]),
            set_team_zone(?cross_warlord_quality_top_4_1, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {Group4, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = Group4}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_top_4_1, T, ZoneList)
    end;
set_team_zone(?cross_warlord_quality_top_4_2, [Team = #cross_warlord_team{team_group_4 = Group4}| T], ZoneList) ->
    case lists:keyfind(Group4, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集4强第~w战区异常, 无法获取战区进程",[Group4]),
            set_team_zone(?cross_warlord_quality_top_4_2, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {Group4, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = Group4}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_top_4_2, T, ZoneList)
    end;
set_team_zone(?cross_warlord_quality_semi_final, [Team | T], ZoneList) ->
    case lists:keyfind(1, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集季军决赛数据分组异常,无法获取战区进程"),
            set_team_zone(?cross_warlord_quality_semi_final, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {1, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = 1}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_semi_final, T, ZoneList)
    end;
set_team_zone(?cross_warlord_quality_final, [Team | T], ZoneList) ->
    case lists:keyfind(1, #cross_warlord_zone.seq, ZoneList) of
        false ->
            ?ERR("采集决赛数据分组异常,无法获取战区进程"),
            set_team_zone(?cross_warlord_quality_final, T, ZoneList);
        #cross_warlord_zone{pid = ZonePid} ->
            NewTeam = set_role_zone(Team, {1, ZonePid}),
            ets:insert(ets_cross_warlord_team, NewTeam#cross_warlord_team{team_zone_pid = ZonePid, team_zone_seq = 1}),
            cross_warlord:add_team(ZonePid, NewTeam),
            set_team_zone(?cross_warlord_quality_final, T, ZoneList)
    end.

set_role_zone(Team = #cross_warlord_team{team_member = TeamMem}, {ZoneSeq, ZonePid}) ->
    NewTeamMem = set_role_zone(TeamMem, [], ZoneSeq, ZonePid),
    Team#cross_warlord_team{team_member = NewTeamMem}.

set_role_zone([], NewTeamMem, _, _) -> NewTeamMem;
set_role_zone([TeamRole | T], NewTeamMem, ZoneSeq, ZonePid) ->
    NewTeamRole = TeamRole#cross_warlord_role{zone_pid = ZonePid, zone_seq = ZoneSeq, pid = 0},
    ets:insert(ets_cross_warlord_role, NewTeamRole),
    set_role_zone(T, [NewTeamRole | NewTeamMem], ZoneSeq, ZonePid).


%% 获取一个类型的榜单
get_war_list(Label) ->
    TeamMs = [{
            #cross_warlord_team{team_32code = '$1', team_label = '$2',  _ = '_'},
            [{'andalso', {'=/=', '$1', 0}, {'=:=', '$2', Label}}],
            ['$_']
        }],
    L = ets:select(ets_cross_warlord_team, TeamMs),
    {InfoList, Winner} = do_get_war_list(L),
    case Winner of
        [] ->
            {InfoList, 0, <<"">>, <<"">>, []};
        {Code, Name, SrvId, Roles} ->
            {InfoList, Code, Name, SrvId, Roles}
    end.

do_get_war_list(L) ->
    do_get_war_list(L, [], []).
do_get_war_list([], InfoList, Winner) -> {InfoList, Winner};
do_get_war_list([#cross_warlord_team{team_code = Code, team_srv_id = TeamSrvId, team_name = TeamName, team_32code = RankId, team_quality = ?cross_warlord_quality_winer, team_member = TeamMem} | T], InfoList, _) ->
    Info = {Code, RankId, TeamName, TeamSrvId, ?cross_warlord_quality_winer},
    TeamRole = [{Id, SrvId, Name, FaceId} || #cross_warlord_role{id = {Id, SrvId}, name = Name, face_id = FaceId} <- TeamMem],
    do_get_war_list(T, [Info | InfoList], {Code, TeamName, TeamSrvId, TeamRole});
do_get_war_list([#cross_warlord_team{team_code = Code, team_srv_id = SrvId, team_name = Name, team_32code = RankId, team_quality = Quality} | T], InfoList, Winner) ->
    Info = {Code, RankId, Name, SrvId, Quality},
    do_get_war_list(T, [Info | InfoList], Winner).

split_teams(Teams, Num) when Num >= 0 -> split_teams(Teams, Num, []);
split_teams(Teams, _) -> {[], Teams}.

split_teams([], _Num, GetTeams) -> {lists:reverse(GetTeams), []};
split_teams(LastTeams, 0, GetTeams) -> {lists:reverse(GetTeams), LastTeams};
split_teams([Team | T], Num, GetTeams) -> split_teams(T, Num - 1, [Team | GetTeams]).

%% 按多键排序 后面优先 即第二个键优先于第一个键
keys_sort(N, TupleList) ->
    do_keys_sort(get_sort_key(N), TupleList).
do_keys_sort([],TupleList) -> lists:reverse(TupleList);
do_keys_sort([H|T], TupleList) ->
    NewTupleList = lists:keysort(H, TupleList),
    do_keys_sort(T,NewTupleList).

%% 获取排行榜排序key
get_sort_key(1) -> [#cross_warlord_team.team_code, #cross_warlord_team.team_fight].

%% 通知参加比赛
notice_sign([], []) -> 
    ?INFO("武神坛参赛资格已经通过邮件通知完毕"),
    ok;
notice_sign([], [#cross_warlord_team{team_name = TeamName, team_member = TeamMem} | T]) ->
    send_sign_mail(land, TeamName, TeamMem),
    notice_sign([], T);
notice_sign([#cross_warlord_team{team_name = TeamName, team_member = TeamMem} | T], LandTeams) ->
    send_sign_mail(sky, TeamName, TeamMem),
    notice_sign(T, LandTeams).

send_sign_mail(_Type, _, []) -> ok;
send_sign_mail(land, TeamName, [#cross_warlord_role{id = {Rid, SrvId}, name = Name} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_warlord, sign_mail, [land, {Rid, SrvId}, Name, TeamName]),
    send_sign_mail(land, TeamName, T);
send_sign_mail(sky, TeamName, [#cross_warlord_role{id = {Rid, SrvId}, name = Name} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_warlord, sign_mail, [sky, {Rid, SrvId}, Name, TeamName]),
    send_sign_mail(sky, TeamName, T).

%% 通知比赛无资格
notice_lost([]) ->
    ?INFO("武神坛资格未达到的邮件已经通知完毕"),
    ok;
notice_lost([#cross_warlord_team{team_name = TeamName, team_member = TeamMem} | T]) ->
    send_lost_mail(TeamName, TeamMem),
    notice_lost(T).

send_lost_mail(_, []) -> ok;
send_lost_mail(TeamName, [#cross_warlord_role{id = {Rid, SrvId}, name = Name} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_warlord, lost_sign, [Rid, SrvId, Name, TeamName]),
    send_lost_mail(TeamName, T).

%% 关闭战区
stop_zone([]) -> ok;
stop_zone([#cross_warlord_zone{pid = ZonePid} | T]) when is_pid(ZonePid) ->
    ZonePid ! time_stop,
    stop_zone(T);
stop_zone([_ | T]) ->
    ?ERR("武神坛异常战区关闭"),
    stop_zone(T).

%% 发送战斗奖励邮件
send_match_mail(_, [], []) -> ok;
send_match_mail(Type, [], [#cross_warlord_team{team_name = TeamName, team_member = TeamMem, team_label = TeamLabel} | T]) ->
    do_send_match_mail(Type, lose, TeamLabel, TeamName, TeamMem),
    send_match_mail(Type, [], T);
send_match_mail(Type, [], [_ | T]) ->
    ?ERR("错误的战斗结果"),
    send_match_mail(Type, [], T);
send_match_mail(Type, [#cross_warlord_team{team_name = TeamName, team_member = TeamMem, team_label = TeamLabel} | T], LoseTeam) ->
    do_send_match_mail(Type, win, TeamLabel, TeamName, TeamMem),
    send_match_mail(Type, T, LoseTeam);
send_match_mail(Type, [_ | T], LoseTeam) ->
    ?ERR("错误的战斗结果"),
    send_match_mail(Type, T, LoseTeam).


do_send_match_mail(_, _, _, _, []) -> ok;
do_send_match_mail(Type, win, TeamLabel, TeamName, [#cross_warlord_role{id = {Rid, SrvId}, name = Name} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_warlord_mgr, match_mail, [Type, win, TeamLabel, {Rid, SrvId}, Name, TeamName]),
    do_send_match_mail(Type, win, TeamLabel, TeamName, T);
do_send_match_mail(Type, lose, TeamLabel, TeamName, [#cross_warlord_role{id = {Rid, SrvId}, name = Name} | T]) ->
    c_mirror_group:cast(node, SrvId, cross_warlord_mgr, match_mail, [Type, lose, TeamLabel, {Rid, SrvId}, Name, TeamName]),
    do_send_match_mail(Type, lose, TeamLabel, TeamName, T).

match_mail(?cross_warlord_quality_trial_0, win, _TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级选拔赛第一轮">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战选拔赛第一轮，请在本周四下午14:30准时进入赛区参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = [{29438, 1, 1}],
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_trial_0, lose, _TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战">>),
    Content = util:fbin(?L(<<"很可惜，您的队伍【~s】在武神坛之战中止步海选赛，请再接再厉，争取在下一届武神坛取得更好的成绩。以下为您的参与奖励，请查收！">>), [TeamName]),
    Items = [{29437, 1, 1}],
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_trial_1, win, _TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级选拔赛第二轮">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战选拔赛第二轮，请在本周五下午14:30准时进入赛区参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = [{29438, 1, 1}],
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_trial_1, lose, _TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战">>),
    Content = util:fbin(?L(<<"很可惜，您的队伍【~s】在武神坛之战中止步选拔赛第一轮，请再接再厉，争取在下一届武神坛取得更好的成绩。以下为您的参与奖励，请查收！">>), [TeamName]),
    Items = [{29437, 1, 1}],
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});
    
match_mail(?cross_warlord_quality_trial_2, win, _TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级选拔赛决赛">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战选拔赛决赛，请在本周六下午14:30准时进入赛区参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = [{29438, 1, 1}],
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_trial_2, lose, _TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战">>),
    Content = util:fbin(?L(<<"很可惜，您的队伍【~s】在武神坛之战中止步选拔赛第二轮，请再接再厉，争取在下一届武神坛取得更好的成绩。以下为您的参与奖励，请查收！">>), [TeamName]),
    Items = [{29437, 1, 1}],
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_trial_3, win, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级32强">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战32强，请在本周日下午14:30准时进入赛区参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29439, 1, 1}];
        _ -> [{29454, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_trial_3, lose, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战">>),
    Content = util:fbin(?L(<<"很可惜，您的队伍【~s】在武神坛之战中止步选拔赛决赛，请再接再厉，争取在下一届武神坛取得更好的成绩。以下为您的参与奖励，请查收！">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29437, 1, 1}];
        _ -> [{29437, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_top_32, win, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级16强">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战16强，请在下周周一下午14:30准时进入赛区参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29440, 1, 1}];
        _ -> [{29447, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_top_32, lose, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战">>),
    Content = util:fbin(?L(<<"很可惜，您的队伍【~s】在武神坛之战中止步32强，请再接再厉，争取在下一届武神坛取得更好的成绩。以下为您的参与奖励，请查收！">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29437, 1, 1}];
        _ -> [{29437, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_top_16, win, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级8强">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战8强，请在本周周二下午14:30准时进入赛区参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29441, 1, 1}];
        _ -> [{29448, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_top_16, lose, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战">>),
    Content = util:fbin(?L(<<"很可惜，您的队伍【~s】在武神坛之战中止步16强，请再接再厉，争取在下一届武神坛取得更好的成绩。以下为您的参与奖励，请查收！">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29437, 1, 1}];
        _ -> [{29437, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_top_8, win, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级半决赛">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战半决赛，半决赛第一场和第二场将于本周周三、周四下午14:30举行，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29442, 1, 1}];
        _ -> [{29449, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_top_8, lose, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战">>),
    Content = util:fbin(?L(<<"很可惜，您的队伍【~s】在武神坛之战中止步8强，请再接再厉，争取在下一届武神坛取得更好的成绩。以下为您的参与奖励，请查收！">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29437, 1, 1}];
        _ -> [{29437, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_top_4_1, win, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级决赛">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战决赛，请在本周日下午14:30准时进入赛区参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29443, 1, 1}];
        _ -> [{29450, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_top_4_1, lose, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级季军争夺赛">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战季军争夺赛，请在本周六下午14:30准时进入赛区参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29437, 1, 1}];
        _ -> [{29437, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_top_4_2, win, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级决赛">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战决赛，请在本周日下午14:30准时进入赛区参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29443, 1, 1}];
        _ -> [{29450, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_top_4_2, lose, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战晋级季军争夺赛">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】晋级武神坛之战季军争夺赛，请在本周六下午14:30准时进入赛区参加比赛，比赛时间可能因为异常情况而提前或者延后，请查看当天的武神坛之战面板显示时间。以下为您的晋级礼包，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29437, 1, 1}];
        _ -> [{29437, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_semi_final, win, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战季军">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】获得本届武神坛之战季军。获得了武神坛季军称号，以下为您的奖品，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29444, 1, 1}];
        _ -> [{29451, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_semi_final, lose, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战季军争夺赛">>),
    Content = util:fbin(?L(<<"很可惜，您的队伍【~s】在武神坛之战中止步4强，请再接再厉，争取在下一届武神坛取得更好的成绩。以下为您的参与奖励，请查收！">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29437, 1, 1}];
        _ -> [{29437, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_final, win, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战冠军">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】获得本届武神坛之战冠军。获得了武神坛第一武神称号，以下为您的奖品，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29446, 1, 1}];
        _ -> [{29453, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(?cross_warlord_quality_final, lose, TeamLabel, {Rid, SrvId}, Name, TeamName) ->
    Subject = ?L(<<"武神坛之战亚军">>),
    Content = util:fbin(?L(<<"恭喜您的队伍【~s】获得本届武神坛之战亚军。获得了武神坛亚军称号，以下为您的奖品，请查收。">>), [TeamName]),
    Items = case TeamLabel of
        ?cross_warlord_label_sky -> [{29445, 1, 1}];
        _ -> [{29452, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items});

match_mail(_, _, _, _, _, _) -> ok.

%% 统计该次比赛结果
calc_match_report(Type) ->
    cross_warlord_log:match_over(Type),
    case get(cross_warlord_report) of
        undefined ->
            ?ERR("武神坛该次比赛无成绩,无法统计"),
            case Type of
                ?cross_warlord_quality_final ->
                    {[], []};
                _ -> skip
            end;
        {WinTeam, LoseTeam} ->
            case Type of
                ?cross_warlord_quality_trial_0 ->
                    update_match_team(?cross_warlord_quality_trial_1, WinTeam),
                    update_match_team(?cross_warlord_quality_trial_0, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_trial_0, WinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    skip;
                ?cross_warlord_quality_trial_1 ->
                    update_match_team(?cross_warlord_quality_trial_2, WinTeam),
                    update_match_team(?cross_warlord_quality_trial_1, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_trial_1, WinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    skip;
                ?cross_warlord_quality_trial_2 ->
                    update_match_team(?cross_warlord_quality_trial_3, WinTeam),
                    update_match_team(?cross_warlord_quality_trial_2, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_trial_2, WinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    skip;
                ?cross_warlord_quality_trial_3 ->
                    %% 进入32强进行32强编号
                    NewWinTeam = update_team_group(WinTeam),
                    update_match_team(?cross_warlord_quality_top_32, NewWinTeam),
                    update_match_team(?cross_warlord_quality_trial_3, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_trial_3, NewWinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    skip;
                ?cross_warlord_quality_top_32 ->
                    update_match_team(?cross_warlord_quality_top_16, WinTeam),
                    update_match_team(?cross_warlord_quality_top_32, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_top_32, WinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    skip;
                ?cross_warlord_quality_top_16 ->
                    update_match_team(?cross_warlord_quality_top_8, WinTeam),
                    update_match_team(?cross_warlord_quality_top_16, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_top_16, WinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    skip;
                ?cross_warlord_quality_top_8 ->
                    update_match_team(cross_warlord_quality_top_4, WinTeam),
                    update_match_team(?cross_warlord_quality_top_8, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_top_8, WinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    skip;
                ?cross_warlord_quality_top_4_1 ->
                    update_match_team(?cross_warlord_quality_final, WinTeam),
                    update_match_team(?cross_warlord_quality_semi_final, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_top_4_1, WinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    skip;
                ?cross_warlord_quality_top_4_2 ->
                    update_match_team(?cross_warlord_quality_final, WinTeam),
                    update_match_team(?cross_warlord_quality_semi_final, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_top_4_2, WinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    skip;
                ?cross_warlord_quality_semi_final ->
                    update_match_team(?cross_warlord_quality_third_place, WinTeam),
                    update_match_team(?cross_warlord_quality_4th_place, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_semi_final, WinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    skip;
                ?cross_warlord_quality_final ->
                    update_match_team(?cross_warlord_quality_winer, WinTeam),
                    update_match_team(?cross_warlord_quality_second_place, LoseTeam),
                    spawn(fun() -> send_match_mail(?cross_warlord_quality_final, WinTeam, LoseTeam) end),
                    put(cross_warlord_report, undefined),
                    add_last_winner_team(WinTeam, LoseTeam);
                _ ->
                    ?ERR("错误的武神坛比赛类型"),
                    put(cross_warlord_report, undefined),
                    skip
            end
    end.

%% 正式进入32强之后进行编号,分组 
update_team_group(Teams) ->
    update_team_group(Teams, []).
update_team_group([], NewTeams) -> NewTeams;
update_team_group([Team = #cross_warlord_team{team_trial_seq = TrialSeq} | T], NewTeams) ->
    %% 战区号直接变为32强编号
    Code32 = TrialSeq,
    Group32 = util:ceil(Code32/2), 
    Group16 = util:ceil(Code32/4), 
    Group8 = util:ceil(Code32/8),
    Group4 = util:ceil(Code32/16),
    NewTeam = Team#cross_warlord_team{team_32code = Code32, team_group_32 = Group32, team_group_16 = Group16, team_group_8 = Group8, team_group_4 = Group4},
    update_team_group(T, [NewTeam | NewTeams]).

%% 更新比赛队伍资格
update_match_team(_, []) -> ok;
%% 进入4强赛的时候需特殊处理资格 
update_match_team(cross_warlord_quality_top_4, [Team = #cross_warlord_team{team_name = _TeamName, team_group_8 = Team8} | T]) ->
    Quality = if
        Team8 >= 1 andalso Team8 =< 2 ->
            ?cross_warlord_quality_top_4_1;
        true ->
            ?cross_warlord_quality_top_4_2
    end,
    ?DEBUG("~s进入资格~w",[_TeamName, Team8]),
    NewTeam = Team#cross_warlord_team{team_quality = Quality},
    update_team(all, NewTeam),
    update_match_team(cross_warlord_quality_top_4, T);
update_match_team(Quality, [Team | T]) when is_record(Team, cross_warlord_team)->
    NewTeam = Team#cross_warlord_team{team_quality = Quality},
    update_team(all, NewTeam),
    update_match_team(Quality, T);
update_match_team(Quality, [_ | T]) ->
    ?ERR("错误的比赛数据, 无法更新"),
    update_match_team(Quality, T).

add_last_winner_team(WinTeam, LoseTeam) ->
    add_last_winner_team(WinTeam, LoseTeam, []).
add_last_winner_team([], LoseTeam, Winner) -> {Winner, LoseTeam};
add_last_winner_team([Team = #cross_warlord_team{team_label = Label, team_name = TeamName, team_srv_id = TeamSrvId, team_member = TeamMem} | T], LoseTeam, Winner) ->
    NewTeamMem = [R#cross_warlord_role{combat_cache = 0} || R<- TeamMem],
    NewTeam = Team#cross_warlord_team{team_member = NewTeamMem},
    case lists:keyfind(Label, 1, Winner) of
        false ->
            add_last_winner_team(T, LoseTeam, [{Label, TeamName, TeamSrvId, NewTeam} | Winner]);
        _ ->
            ?ERR("本次决赛结果异常"),
            add_last_winner_team(T, LoseTeam, lists:keyreplace(Label, 1, Winner, {Label, TeamName, TeamSrvId, NewTeam}))
    end.

%% 删除数据
delete(all) ->
    %% 清除投注和报名队伍数据
    cross_warlord_log:clean(),
    %% 清除录像
    spawn(fun() -> c_mirror_group:cast(all, combat_replay_mgr, clear_all_replay, []) end),
    %% 清除队伍数据
    ets:delete_all_objects(ets_cross_warlord_role),
    ets:delete_all_objects(ets_cross_warlord_team),
    dets:delete_all_objects(dets_cross_warlord_role),
    dets:delete_all_objects(dets_cross_warlord_team);

delete(ets) ->
    ets:delete_all_objects(ets_cross_warlord_role),
    ets:delete_all_objects(ets_cross_warlord_team).

%%----------------------------------------------------
%% 状态处理
%%----------------------------------------------------
%%      idel/2                 %% 空闲状态
%%      notice/2              %% 公告/报名阶段
%%      prepare/2             %% 预备阶段
%%      trial_round_0/2       %% 选拔赛一阶段
%%      idel_trial_1/2        %% 选拔赛一阶段空闲阶段
%%      trial_round_1/2       %% 选拔赛一阶段
%%      idel_trial_2/2        %% 选拔赛二阶段空闲阶段
%%      trial_round_2/2       %% 选拔赛二阶段
%%      idel_trial_3/2        %% 选拔赛决赛空闲阶段
%%      trial_round_3/2       %% 选拔赛决赛 -> 决出32强
%%      idel_top_16/2         %% 16强空闲阶段
%%      top_16/2              %% 16强赛     -> 决出16强
%%      idel_top_8/2          %% 8强空闲阶段
%%      top_8/2               %% 8强赛      -> 决出8强
%%      idel_top_4/2          %% 4强空闲阶段
%%      top_4/2               %% 4强赛      -> 决出4强
%%      idel_semi_final_1/2   %% 半决赛空闲阶段
%%      semi_final_1/2        %% 半决赛     -> 胜者进入冠军决赛,败者进入季军决赛 
%%      idel_semi_final_2/2   %% 半决赛空闲阶段
%%      semi_final_2/2        %% 半决赛     -> 胜者进入冠军决赛,败者进入季军决赛 
%%      idel_third_final/2    %% 季军决赛空闲阶段
%%      third_final/2         %% 季军决赛   -> 胜者季军 
%%      idel_final/2          %% 决赛空闲阶段
%%      final/2               %% 决赛        
%%      expire/2              %% 统计阶段    

%% 空闲时间
idel(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel状态"),
    {next_state, idel, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel(timeout, State = #state{next_start_time = 0, switch = ?false, last_winner_ext = LastWinner, state_lev = StateLev}) ->
    Now = util:unixtime(),
    ?INFO("武神坛第一次开启, 进入报名状态, 报名状态持续至明天晚上10点"),
    %% 删除旧数据
    delete(all),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + (3600 * 22)),
    start_pre_zone(),
    broadcast(notice, erlang:now(), 0),
    NewState = State#state{sign_day = 1, sign_code = 1, ts = erlang:now(), timeout = Time * 1000, last_winner = LastWinner, state_lev = StateLev + 1},
    save(notice, NewState),
    erlang:send_after((util:unixtime({tomorrow, Now}) - Now + 10) * 1000, self(), check_sign_day),
    erlang:send_after(30 * 60 * 1000, self(), sign_notice),
    {next_state, notice, NewState, Time * 1000};
idel(timeout, State = #state{next_start_time = StartTime, last_winner_ext = LastWinner, state_lev = StateLev}) ->
    Now = util:unixtime(),
    case Now >= StartTime of
        true ->
            ?INFO("武神坛开启, 进入报名状态, 持续至明天晚上10点"),
            delete(all),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + (3600 * 22)),
            start_pre_zone(),
            broadcast(notice, erlang:now(), 0),
            NewState = State#state{last_winner = LastWinner, state_lev = StateLev + 1, sign_day = 1, sign_code = 1, ts = erlang:now(), timeout = Time * 1000},
            save(notice, NewState),
            erlang:send_after(30 * 60 * 1000, self(), sign_notice),
            erlang:send_after((util:unixtime({tomorrow, Now}) - Now + 10) * 1000, self(), check_sign_day),
            {next_state, notice, NewState, Time * 1000};
        false ->
            Time = StartTime - Now + 5,
            ?INFO("武神坛空闲, 继续轮询, [~w]秒后准备进入报名状态", [Time]),
            {next_state, idel, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}
    end;
idel(_Any, State) ->
    continue(idel, State).

%% 报名时间
notice(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛报名阶段延长中, 再次进入notice状态"),
    {next_state, notice, State#state{ts = erlang:now(), timeout = 7200 * 1000}, 7200 * 1000};

notice(timeout, State = #state{}) ->
    ?INFO("武神坛报名时间到, 统计出比赛的队伍,发送报名成功邮件"),
    clean_pre_role(),
    Now = util:unixtime(),
    AllTeams = ets:tab2list(ets_cross_warlord_team),
    %% ---------------------------------
    %% 删除所有报名数据
    ets:delete_all_objects(ets_cross_warlord_team),
    ets:delete_all_objects(ets_cross_warlord_role),
    dets:delete_all_objects(dets_cross_warlord_team),
    dets:delete_all_objects(dets_cross_warlord_role),
    ets:delete_all_objects(ets_cross_warlord_pre),
    %% ---------------------------------
    SortTeams = keys_sort(1, AllTeams),
    {SkyTeams, LastTeams} = split_teams(SortTeams, 512),
    {LandTeams, LostTeams} = split_teams(LastTeams, 512),
    update_trial_team(SkyTeams, ?cross_warlord_label_sky), 
    update_trial_team(LandTeams, ?cross_warlord_label_land), 
    spawn(fun() -> notice_sign(SkyTeams, LandTeams) end),
    spawn(fun() -> notice_lost(LostTeams) end),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
    broadcast(prepare, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000},
    save(prepare, NewState),
    {next_state, prepare, NewState, Time * 1000};
notice(_Any, State) ->
    continue(notice, State).

%% 选拔赛前准备 
prepare(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入prepare状态"),
    {next_state, prepare, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
prepare(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_trial_0, State) of
        {false, Reason} ->
            ?INFO("启动256强正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, prepare, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入256强争夺赛"),
            broadcast(trial_round_0, erlang:now(), Now),
            {next_state, trial_round_0, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
prepare(_Any, State) ->
    continue(prepare, State).

%% 海选 
trial_round_0(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛海选结束"),
    {next_state, expire_trial_0, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
trial_round_0(_Any, State) ->
    continue(trial_round_0, State).

%% 海选
expire_trial_0(timeout, State) ->
    %%TODO 进行榜统计以及写数据
    calc_match_report(?cross_warlord_quality_trial_0),
    Now = util:unixtime(),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
    ?INFO("武神坛海选结果产出"),
    broadcast(idel_trial_1, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000, zone_list_sky = [], zone_list_land = []},
    save(idel_trial_1, NewState),
    {next_state, idel_trial_1, NewState, Time * 1000}; %% 时间设置
expire_trial_0(_Any, State) ->
    continue(expire_trial_0, State).

%% 选拔赛第一阶段空闲
idel_trial_1(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel_trial_1状态"),
    {next_state, idel_trial_1, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel_trial_1(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_trial_1, State) of
        {false, Reason} ->
            ?INFO("启动128强正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, idel_trial_1, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入128强争夺赛"),
            broadcast(trial_round_1, erlang:now(), Now),
            {next_state, trial_round_1, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
idel_trial_1(_Any, State) ->
    continue(idel_trial_1, State).

%% 选拔赛一阶段
trial_round_1(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛海选第一轮结束"),
    {next_state, expire_trial_1, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
trial_round_1(_Any, State) ->
    continue(trial_round_1, State).

%% 选拔赛一阶段
expire_trial_1(timeout, State) ->
    %%TODO 进行榜统计以及写数据
    calc_match_report(?cross_warlord_quality_trial_1),
    Now = util:unixtime(),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
    ?INFO("武神坛海选第一轮结果产出"),
    broadcast(idel_trial_2, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000, zone_list_sky = [], zone_list_land = []},
    save(idel_trial_2, NewState),
    {next_state, idel_trial_2, NewState, Time * 1000}; %% 时间设置
expire_trial_1(_Any, State) ->
    continue(expire_trial_1, State).

%% 选拔赛第二阶段空闲
idel_trial_2(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel_trial_2状态"),
    {next_state, idel_trial_2, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel_trial_2(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_trial_2, State) of
        {false, Reason} ->
            ?INFO("启动64强正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, idel_trial_2, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入64强争夺赛"),
            broadcast(trial_round_2, erlang:now(), Now),
            {next_state, trial_round_2, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
idel_trial_2(_Any, State) ->
    continue(idel_trial_2, State).

%% 选拔赛二阶段
trial_round_2(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛海选第二轮结束"),
    {next_state, expire_trial_2, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
trial_round_2(_Any, State) ->
    continue(trial_round_2, State).

%% 选拔赛二阶段结算
expire_trial_2(timeout, State) ->
    %%TODO 进行榜统计以及写数据
    calc_match_report(?cross_warlord_quality_trial_2),
    Now = util:unixtime(),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
    ?INFO("武神坛海选第二轮结果产出"),
    broadcast(idel_trial_3, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000, zone_list_sky = [], zone_list_land = []},
    save(idel_trial_3, NewState),
    {next_state, idel_trial_3, NewState, Time * 1000}; %% 时间设置
expire_trial_2(_Any, State) ->
    continue(expire_trial_2, State).

%% 选拔赛决赛空闲
idel_trial_3(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel_trial_3状态"),
    {next_state, idel_trial_3, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel_trial_3(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_trial_3, State) of
        {false, Reason} ->
            ?INFO("启动32强正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, idel_trial_3, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入32强争夺赛"),
            broadcast(trial_round_3, erlang:now(), Now),
            {next_state, trial_round_3, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
%% 选拔赛决赛空闲
idel_trial_3(_Any, State) ->
    continue(idel_trial_3, State).

%% 选拔赛三阶段
trial_round_3(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛海选赛决赛结束"),
    {next_state, expire_trial_3, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
trial_round_3(_Any, State) ->
    continue(trial_round_3, State).

%% 选拔赛三阶段
expire_trial_3(timeout, State) ->
    %%TODO 进行榜统计以及写数据
    calc_match_report(?cross_warlord_quality_trial_3),
    Now = util:unixtime(),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
    ?INFO("武神坛海选赛决赛结束, 32强统计完毕"),
    broadcast(idel_top_16, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000, zone_list_sky = [], zone_list_land = []},
    save(idel_top_16, NewState),
    cross_warlord_log:make_top_32(),
    cross_warlord_log:make_16_bet(),
    {next_state, idel_top_16, NewState, Time * 1000}; %% 时间设置
expire_trial_3(_Any, State) ->
    continue(expire_trial_3, State).

%% 空闲阶段
idel_top_16(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel_top_16空闲状态"),
    {next_state, idel_top_16, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel_top_16(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_top_32, State) of
        {false, Reason} ->
            ?INFO("启动16强正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, idel_top_16, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入16强争夺赛"),
            broadcast(top_16, erlang:now(), Now),
            %% 清掉投注榜数据
            cross_warlord_log:clean(top3),
            cross_warlord_log:clean(bet16),
            {next_state, top_16, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
idel_top_16(_Any, State) ->
    continue(idel_top_16, State).

%% 十六强
top_16(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛16强争夺赛结束"),
    {next_state, expire_top_16, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
top_16(_Any, State) ->
    continue(top_16, State).

%% 十六强结算
expire_top_16(timeout, State) ->
    %%TODO 进行榜统计以及写数据
    calc_match_report(?cross_warlord_quality_top_32),
    Now = util:unixtime(),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
    ?INFO("武神坛16强结果产出"),
    broadcast(idel_top_8, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000, zone_list_sky = [], zone_list_land = []},
    save(idel_top_8, NewState),
    cross_warlord_log:calc_16_bet(),
    {next_state, idel_top_8, NewState, Time * 1000}; %% 时间设置
expire_top_16(_Any, State) ->
    continue(expire_top_16, State).

%% 8强争夺赛空闲
idel_top_8(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel_top_8空闲状态"),
    {next_state, idel_top_8, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel_top_8(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_top_16, State) of
        {false, Reason} ->
            ?INFO("启动8强正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, idel_top_8, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入8强争夺赛"),
            broadcast(top_8, erlang:now(), Now),
            {next_state, top_8, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
idel_top_8(_Any, State) ->
    continue(idel_top_8, State).

%% 八强
top_8(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛8强争夺赛结束"),
    {next_state, expire_top_8, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
top_8(_Any, State) ->
    continue(top_8, State).

%% 8强争夺赛结算
expire_top_8(timeout, State) ->
    %%TODO 进行榜统计以及写数据
    calc_match_report(?cross_warlord_quality_top_16),
    Now = util:unixtime(),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
    ?INFO("武神坛8强结果产出"),
    broadcast(idel_top_4, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000, zone_list_sky = [], zone_list_land = []},
    save(idel_top_4, NewState),
    %% 进行投注榜更新
    cross_warlord_log:make_bet(?cross_warlord_quality_top_8),
    {next_state, idel_top_4, NewState, Time * 1000}; %% 时间设置
expire_top_8(_Any, State) ->
    continue(expire_top_8, State).

%% 4强争夺赛空闲
idel_top_4(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel_top_4空闲状态"),
    {next_state, idel_top_4, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel_top_4(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_top_8, State) of
        {false, Reason} ->
            ?INFO("启动4强正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, idel_top_4, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入4强争夺赛"),
            broadcast(top_4, erlang:now(), Now),
            %% 比赛开始后,不再进行投注
            cross_warlord_log:clean(bet),
            {next_state, top_4, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
idel_top_4(_Any, State) ->
    continue(idel_top_4, State).

%% 四强
top_4(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛4强争夺赛结束"),
    {next_state, expire_top_4, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
top_4(_Any, State) ->
    continue(top_4, State).

%% 4强争夺赛结算
expire_top_4(timeout, State) ->
    %%TODO 进行榜统计以及写数据
    calc_match_report(?cross_warlord_quality_top_8),
    Now = util:unixtime(),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
    ?INFO("武神坛4强结果产出"),
    broadcast(idel_semi_final_1, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000, zone_list_sky = [], zone_list_land = []},
    save(idel_semi_final_1, NewState),
    %% 进行投注榜更新
    cross_warlord_log:make_bet(?cross_warlord_quality_top_4_1),
    {next_state, idel_semi_final_1, NewState, Time * 1000}; %% 时间设置
expire_top_4(_Any, State) ->
    continue(expire_top_4, State).

%% 半决赛第一场空闲
idel_semi_final_1(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel_semi_final_1状态"),
    {next_state, idel_semi_final_1, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel_semi_final_1(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_top_4_1, State) of
        {false, Reason} ->
            ?INFO("启动季军冠军赛第一轮正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, idel_semi_final_1, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入季军冠军争夺赛第一轮"),
            broadcast(semi_final_1, erlang:now(), Now),
            %% 比赛开始后,不再进行投注
            cross_warlord_log:clean(bet),
            {next_state, semi_final_1, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
idel_semi_final_1(_Any, State) ->
    continue(idel_semi_final_1, State).

%% 半决赛
semi_final_1(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛季军冠军争夺赛第一轮结束"),
    {next_state, expire_semi_final_1, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
semi_final_1(_Any, State) ->
    continue(semi_final_1, State).

%% 半决赛第一场结算
expire_semi_final_1(timeout, State) ->
    %%TODO 进行榜统计以及写数据
    calc_match_report(?cross_warlord_quality_top_4_1),
    Now = util:unixtime(),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
    ?INFO("武神坛季军冠军争夺赛第一轮结果产出"),
    broadcast(idel_semi_final_2, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000, zone_list_sky = [], zone_list_land = []},
    save(idel_semi_final_2, NewState),
    cross_warlord_log:make_bet(?cross_warlord_quality_top_4_2),
    {next_state, idel_semi_final_2, NewState, Time * 1000}; %% 时间设置
expire_semi_final_1(_Any, State) ->
    continue(expire_semi_final_1, State).

%% 半决赛第二场空闲
idel_semi_final_2(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel_semi_final_2状态"),
    {next_state, idel_semi_final_2, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel_semi_final_2(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_top_4_2, State) of
        {false, Reason} ->
            ?INFO("启动季军冠军赛第二轮正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, idel_semi_final_2, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入季军冠军争夺赛第二轮"),
            broadcast(semi_final_2, erlang:now(), Now),
            %% 比赛开始后,不再进行投注
            cross_warlord_log:clean(bet),
            {next_state, semi_final_2, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
idel_semi_final_2(_Any, State) ->
    continue(idel_semi_final_2, State).

%% 半决赛
semi_final_2(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛季军冠军争夺赛第二轮结束"),
    {next_state, expire_semi_final_2, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
semi_final_2(_Any, State) ->
    continue(semi_final_2, State).

%% 半决赛第二场结算
expire_semi_final_2(timeout, State) ->
    %%TODO 进行榜统计以及写数据
    calc_match_report(?cross_warlord_quality_top_4_2),
    Now = util:unixtime(),
    %% TODO 半决赛第二场推迟1天
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time + (86400 * 1)),
    ?INFO("武神坛季军冠军争夺赛第二轮结果产出"),
    broadcast(idel_third_final, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000, zone_list_sky = [], zone_list_land = []},
    save(idel_third_final, NewState),
    cross_warlord_log:make_bet(?cross_warlord_quality_semi_final),
    {next_state, idel_third_final, NewState, Time * 1000}; %% 时间设置
expire_semi_final_2(_Any, State) ->
    continue(expire_semi_final_2, State).

%% 季军决赛空闲 
idel_third_final(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel_third_final状态"),
    {next_state, idel_third_final, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel_third_final(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_semi_final, State) of
        {false, Reason} ->
            ?INFO("启动季军决赛正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, idel_third_final, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入季军争夺赛"),
            broadcast(third_final, erlang:now(), Now),
            %% 比赛开始后,不再进行投注
            cross_warlord_log:clean(bet),
            {next_state, third_final, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
idel_third_final(_Any, State) ->
    continue(idel_third_final, State).

%% 季军决赛
third_final(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛季军争夺赛结束"),
    {next_state, expire_third_final, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
third_final(_Any, State) ->
    continue(third_final, State).

%% 季军决赛结算
expire_third_final(timeout, State) ->
    %%TODO 进行榜统计以及写数据
    calc_match_report(?cross_warlord_quality_semi_final),
    Now = util:unixtime(),
    Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
    ?INFO("武神坛季军争夺赛结果产出"),
    broadcast(idel_final, erlang:now(), Now + Time),
    NewState = State#state{ts = erlang:now(), timeout = Time * 1000, zone_list_sky = [], zone_list_land = []},
    save(idel_final, NewState),
    cross_warlord_log:make_bet(?cross_warlord_quality_final),
    {next_state, idel_final, NewState, Time * 1000}; %% 时间设置
expire_third_final(_Any, State) ->
    continue(expire_third_final, State).

%% 决赛空闲 
idel_final(timeout, State = #state{switch = ?true}) ->
    ?INFO("武神坛活动关闭中, 再次进入idel_final状态"),
    {next_state, idel_final, State#state{ts = erlang:now(), timeout = 3600 * 1000}, 3600 * 1000};
idel_final(timeout, State) ->
    Now = util:unixtime(),
    case start_zone(?cross_warlord_quality_final, State) of
        {false, Reason} ->
            ?INFO("启动冠军决赛正式区失败[Reason:~w]", [Reason]),
            Time = ((util:unixtime({tomorrow, Now}) - Now) + ?start_time),
            {next_state, idel_final, State#state{ts = erlang:now(), timeout = Time * 1000}, Time * 1000}; %% 时间设置
        {ok, NewState} -> 
            ?INFO("正式进入冠军争夺赛"),
            broadcast(final, erlang:now(), Now),
            %% 比赛开始后,不再进行投注
            cross_warlord_log:clean(bet),
            {next_state, final, NewState#state{ts = erlang:now(), timeout = 3300 * 1000}, 3300 * 1000}
    end;
idel_final(_Any, State) ->
    continue(idel_final, State).

%% 决赛
final(timeout, State = #state{zone_list_sky = SkyZoneList, zone_list_land = LandZoneList}) ->
    stop_zone(SkyZoneList),
    stop_zone(LandZoneList),
    cross_warlord_live:cast(clean),
    ?INFO("武神坛冠军争夺赛结束"),
    {next_state, expire, State#state{ts = erlang:now(), timeout = 30 * 1000}, 30 * 1000}; %% 时间设置
final(_Any, State) ->
    continue(final, State).

%% 决赛结算
expire(timeout, State = #state{state_lev = StateLev}) ->
    %%TODO 进行榜统计以及写数据
    {LastWinner, LoseTeams} = calc_match_report(?cross_warlord_quality_final),
    Now = util:unixtime(),
    Time = ((util:unixtime({tomorrow, Now}) + (10 * 3600) - Now) + 15),
    ?INFO("武神坛冠军结果产出"),
    spawn(fun() -> notice_win(LastWinner, LoseTeams, StateLev) end), 
    NewState = State#state{next_start_time = (util:unixtime({tomorrow, Now}) + (10 * 3600) + 10), ts = erlang:now(), timeout = Time * 1000, sign_code = 1, sign_day = 1, zone_list_sky = [], zone_list_land = [], last_winner_ext = LastWinner},
    save(idel, NewState),
    {next_state, idel, NewState, Time * 1000}; %% 时间设置
expire(_Any, State) ->
    continue(expire, State).

%% ---------------------------------
%% 活动通知
%% ---------------------------------
find_rival(_Type, _Label, _GroupId, []) -> [];
find_rival(?cross_warlord_quality_trial_0, Label, GroupId, [#cross_warlord_team{team_label = Label, team_group_512 = Group512, team_trial_seq = Seq, team_member = TeamMem} | T]) ->
    case GroupId =:= (Group512 + (Seq - 1) * 8) of
        true -> 
            [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
        false ->
            find_rival(?cross_warlord_quality_trial_1, Label, GroupId, T)
    end;
find_rival(?cross_warlord_quality_trial_1, Label, GroupId, [#cross_warlord_team{team_label = Label, team_group_256 = Group256, team_trial_seq = Seq, team_member = TeamMem} | T]) ->
    case GroupId =:= (Group256 + (Seq - 1) * 4) of
        true -> 
            [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
        false ->
            find_rival(?cross_warlord_quality_trial_1, Label, GroupId, T)
    end;
find_rival(?cross_warlord_quality_trial_2, Label, GroupId, [#cross_warlord_team{team_label = Label, team_group_128 = Group128, team_trial_seq = Seq, team_member = TeamMem} | T]) ->
    case GroupId =:= (Group128 + (Seq - 1) * 2) of
        true -> 
            [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
        false ->
            find_rival(?cross_warlord_quality_trial_2, Label, GroupId, T)
    end;
find_rival(?cross_warlord_quality_trial_3, Label, GroupId, [#cross_warlord_team{team_label = Label, team_group_64 = Group64, team_trial_seq = Seq, team_member = TeamMem} | T]) ->
    case GroupId =:= (Group64 + (Seq - 1) * 1) of
        true -> 
            [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
        false ->
            find_rival(?cross_warlord_quality_trial_3, Label, GroupId, T)
    end;
find_rival(?cross_warlord_quality_top_32, Label, GroupId, [#cross_warlord_team{team_label = Label, team_group_32 = GroupId, team_member = TeamMem} | _T]) ->
        [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
find_rival(?cross_warlord_quality_top_16, Label, GroupId, [#cross_warlord_team{team_label = Label, team_group_16 = GroupId, team_member = TeamMem} | _T]) ->
        [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
find_rival(?cross_warlord_quality_top_8, Label, GroupId, [#cross_warlord_team{team_label = Label, team_group_8 = GroupId, team_member = TeamMem} | _T]) ->
        [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
find_rival(?cross_warlord_quality_top_4_1, Label, GroupId, [#cross_warlord_team{team_label = Label, team_group_4 = GroupId, team_member = TeamMem} | _T]) ->
        [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
find_rival(?cross_warlord_quality_top_4_2, Label, GroupId, [#cross_warlord_team{team_label = Label, team_group_4 = GroupId, team_member = TeamMem} | _T]) ->
        [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
find_rival(?cross_warlord_quality_semi_final, Label, _GroupId, [#cross_warlord_team{team_label = Label, team_member = TeamMem} | _T]) ->
        [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
find_rival(?cross_warlord_quality_final, Label, _GroupId, [#cross_warlord_team{team_label = Label, team_member = TeamMem} | _T]) ->
        [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem];
find_rival(Quality, Label, GroupId, [_ | T]) ->
    find_rival(Quality, Label, GroupId, T).

%% 比赛公告
notice_all(Type, WinTeam, LoseTeam) ->
    notice_all(Type, WinTeam, LoseTeam, []).

notice_all(Type, [], _LoseTeam, Info) ->
    c_mirror_group:cast(all, cross_warlord_mgr, do_notice_all_check, [Type, Info]);
notice_all(Type, [#cross_warlord_team{team_member = TeamMem, team_label = TeamLabel, team_group_512 = Group512, team_group_256 = Group256, team_group_128 = Group128, team_group_64 = Group64, team_trial_seq = Seq, team_group_32 = Group1, team_group_16 = Group2, team_group_8 = Group3, team_group_4 = Group4} | T], LoseTeam, Info) ->
    GroupId = case Type of
        ?cross_warlord_quality_trial_0 -> (Group512 + ((Seq - 1) * 8));
        ?cross_warlord_quality_trial_1 -> (Group256 + ((Seq - 1) * 4));
        ?cross_warlord_quality_trial_2 -> (Group128 + ((Seq - 1) * 2));
        ?cross_warlord_quality_trial_3 -> (Group64 + ((Seq - 1) * 1));
        ?cross_warlord_quality_top_32 -> Group1;
        ?cross_warlord_quality_top_16 -> Group2;
        ?cross_warlord_quality_top_8 -> Group3;
        ?cross_warlord_quality_top_4_1 -> Group4;
        ?cross_warlord_quality_top_4_2 -> Group4;
        _ -> 0
    end,
    RoleList = [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem],
    RivalList = find_rival(Type, TeamLabel, GroupId, LoseTeam),
    notice_all(Type, T, LoseTeam, [{TeamLabel, RoleList, RivalList} | Info]).

do_notice_all_check(Type, Info) ->
    case cross_warlord:check_in_open_time() of 
        true -> do_notice_all(Type, Info);
        _ -> skip
    end.

is_local([]) -> false;
is_local([{_, SrvId, _} | T]) ->
    case role_api:is_local_role(SrvId) of
        true -> true;
        _ -> is_local(T)
    end.

do_notice_all(_Type, []) -> ok;
do_notice_all(?cross_warlord_quality_trial_0, [{_, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Msg = case RivalBin of
        <<"">> -> util:fbin(?L(<<"恭喜~s本次比赛没有对手，成功晋级海选赛第一轮！">>), [RoleBin]);
        _ -> util:fbin(?L(<<"众望所归，经过武神坛之战的激烈战斗，英勇的~s击败了~s成功晋级海选赛第一轮！">>), [RoleBin, RivalBin])
    end,
    case is_local(RoleList) of
        true -> notice:send(54, Msg);
        false -> skip
    end,
    do_notice_all(?cross_warlord_quality_trial_0, T);
do_notice_all(?cross_warlord_quality_trial_1, [{_, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Msg = case RivalBin of
        <<"">> -> util:fbin(?L(<<"恭喜~s本次比赛没有对手，成功晋级海选赛第二轮！">>), [RoleBin]);
        _ -> util:fbin(?L(<<"众望所归，经过武神坛之战的激烈战斗，英勇的~s击败了~s成功晋级海选赛第二轮！">>), [RoleBin, RivalBin])
    end,
    case is_local(RoleList) of
        true -> notice:send(54, Msg);
        false -> skip
    end,
    do_notice_all(?cross_warlord_quality_trial_1, T);
do_notice_all(?cross_warlord_quality_trial_2, [{_, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Msg = case RivalBin of
        <<"">> -> util:fbin(?L(<<"恭喜~s本次比赛没有对手，成功晋级海选赛决赛！">>), [RoleBin]);
        _ -> util:fbin(?L(<<"众望所归，经过武神坛之战的激烈战斗，英勇的~s击败了~s成功晋级海选赛决赛！">>), [RoleBin, RivalBin])
    end,
    case is_local(RoleList) of
        true -> notice:send(54, Msg);
        false -> skip
    end,
    do_notice_all(?cross_warlord_quality_trial_2, T);
do_notice_all(?cross_warlord_quality_trial_3, [{_, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Msg = case RivalBin of
        <<"">> -> util:fbin(?L(<<"恭喜~s本次比赛没有对手，成功晋级32强！">>), [RoleBin]);
        _ -> util:fbin(?L(<<"众望所归，经过武神坛之战的激烈战斗，英勇的~s击败了~s成功晋级32强！">>), [RoleBin, RivalBin])
    end,
    case is_local(RoleList) of
        true -> notice:send(54, Msg);
        false -> skip
    end,
    do_notice_all(?cross_warlord_quality_trial_3, T);
do_notice_all(?cross_warlord_quality_top_32, [{_, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Msg = case RivalBin of
        <<"">> ->
            util:fbin(?L(<<"恭喜~s本次比赛没有对手，成功晋级16强赛！">>), [RoleBin]);
        _ ->
            util:fbin(?L(<<"众望所归，经过武神坛之战的激烈战斗，英勇的~s击败了~s成功晋级16强赛！">>), [RoleBin, RivalBin])
    end,
    notice:send(54, Msg),
    do_notice_all(?cross_warlord_quality_top_32, T);
do_notice_all(?cross_warlord_quality_top_16, [{_, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Msg = case RivalBin of
        <<"">> ->
            util:fbin(?L(<<"恭喜~s本次比赛没有对手，成功晋级8强赛！">>), [RoleBin]);
        _ ->
            util:fbin(?L(<<"众望所归，经过武神坛之战的激烈战斗，英勇的~s击败了~s成功晋级8强赛！">>), [RoleBin, RivalBin])
    end,
    notice:send(54, Msg),
    do_notice_all(?cross_warlord_quality_top_16, T);
do_notice_all(?cross_warlord_quality_top_8, [{_, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Msg = case RivalBin of
        <<"">> ->
            util:fbin(?L(<<"恭喜~s本次比赛没有对手，成功晋级半决赛！">>), [RoleBin]);
        _ ->
            util:fbin(?L(<<"众望所归，经过武神坛之战的激烈战斗，英勇的~s击败了~s成功晋级半决赛！">>), [RoleBin, RivalBin])
    end,
    notice:send(54, Msg),
    do_notice_all(?cross_warlord_quality_top_8, T);
do_notice_all(?cross_warlord_quality_top_4_1, [{_, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Msg = case RivalBin of
        <<"">> ->
            util:fbin(?L(<<"恭喜~s本次比赛没有对手，成功晋级决赛！">>), [RoleBin]);
        _ ->
            util:fbin(?L(<<"众望所归，经过武神坛之战的激烈战斗，英勇的~s击败了~s成功晋级决赛！">>), [RoleBin, RivalBin])
    end,
    notice:send(54, Msg),
    do_notice_all(?cross_warlord_quality_top_4_1, T);
do_notice_all(?cross_warlord_quality_top_4_2, [{_, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Msg = case RivalBin of
        <<"">> ->
            util:fbin(?L(<<"恭喜~s本次比赛没有对手，成功晋级决赛！">>), [RoleBin]);
        _ ->
            util:fbin(?L(<<"众望所归，经过武神坛之战的激烈战斗，英勇的~s击败了~s成功晋级决赛！">>), [RoleBin, RivalBin])
    end,
    notice:send(54, Msg),
    do_notice_all(?cross_warlord_quality_top_4_2, T);
do_notice_all(?cross_warlord_quality_semi_final, [{Label, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Msg = case RivalBin of
        <<"">> ->
            util:fbin(?L(<<"恭喜~s本次比赛没有对手，成功获得本届比赛季军！">>), [RoleBin]);
        _ ->
            util:fbin(?L(<<"经过一番龙争虎斗，技高一筹的~s终于击败了~s获得了本届比赛的季军，真是可喜可贺！">>), [RoleBin, RivalBin])
    end,
    add_honor2(Label, RoleList, RivalList), 
    notice:send(54, Msg),
    do_notice_all(?cross_warlord_quality_semi_final, T);
do_notice_all(?cross_warlord_quality_final, [{Label, RoleList, RivalList} | T]) ->
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    Fun = fun(?cross_warlord_label_land) -> ?L(<<"玄虎">>);
        (?cross_warlord_label_sky) -> ?L(<<"天龙">>)
    end,
    Name2 = Fun(Label),
    Msg = case RivalBin of
        <<"">> ->
            util:fbin(?L(<<"经过一番暗无天日的仙技斗法，万众期待的~s没有对手，成为武神坛上的【~s】冠军队伍，武神之称，舍他其谁！">>), [RoleBin, Name2]);
        _ ->
            util:fbin(?L(<<"经过一番暗无天日的仙技斗法，万众期待的~s终于击败了~s，成为武神坛上的【~s】冠军队伍，武神之称，舍他其谁！">>), [RoleBin, RivalBin, Name2])
    end,
    notice:send(54, Msg),
    do_notice_all(?cross_warlord_quality_final, T);
do_notice_all(Type, [_ | T]) ->
    do_notice_all(Type, T).


%% 公告最后获胜的
notice_win(LastWinner, LoseTeams, StateLev) ->
    notice_win(LastWinner, LoseTeams, StateLev, []).
notice_win([], _LoseTeams, StateLev, Info) -> 
    c_mirror_group:cast(all, cross_warlord_mgr, do_notice_win_check, [Info, StateLev]);
notice_win([{Label, TeamName, _, #cross_warlord_team{team_member = TeamMem}} | T], LoseTeams, StateLev, Info) ->
    RoleList = [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem],
    RivalList = find_rival(?cross_warlord_quality_final, Label, 0, LoseTeams), 
    ThirdList = case cross_warlord_mgr:get_team(?cross_warlord_quality_third_place, Label) of
        [#cross_warlord_team{team_member = ThirdTeamMem}] ->
            [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- ThirdTeamMem];
        _ -> [] 
    end,
    notice_win(T, LoseTeams, StateLev, [{Label, TeamName, RoleList, RivalList, ThirdList} | Info]).

do_notice_win_check(Info, StateLev) ->
    case cross_warlord:check_in_open_time() of
        true -> do_notice_win(Info, StateLev);
        _ -> skip
    end.

do_notice_win([], _StateLev) ->
    sys_env:set(cross_warlord_camp_status, {0, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 0, 0, 0, 0}),
    role_group:pack_cast(world, 18110, {0, 0}),
    ok;
do_notice_win([{Label, _TeamName, RoleList, RivalList, ThirdList} | T], StateLev) ->
    add_honor(Label, RoleList, RivalList),
    RoleBin = to_role_info(RoleList),
    RivalBin = to_role_info(RivalList),
    ThirdBin = to_role_info(ThirdList),
    Fun = fun(?cross_warlord_label_land) -> ?L(<<"玄虎">>);
        (?cross_warlord_label_sky) -> ?L(<<"天龙">>)
    end,
    Third = case ThirdBin of
        <<"">> -> <<"">>;
        _ -> util:fbin("季军武神是~s，",[ThirdBin])
    end,
    Second = case RivalBin of
        <<"">> -> <<"">>;
        _ -> util:fbin("亚军武神是~s，",[RivalBin])
    end,
    First = case RoleBin of
        <<"">> -> <<"">>;
        _ -> util:fbin("飞仙第一武神是~s，",[RoleBin])
    end,
    Name2 = Fun(Label),
    Msg = util:fbin("本届武神坛比赛正式结束，【~s】榜~s~s~s实在是太令人崇拜了！",[Name2, Third, Second, First]),
    notice:send(54, Msg),
    sys_env:set(cross_warlord_camp_status, {0, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 0, 0, 0, 0}),
    role_group:pack_cast(world, 18110, {0, 0}),
    do_notice_win(T, StateLev).

%% 60009
%% 60010
add_honor2(?cross_warlord_label_sky, RoleList, _) ->
    H60011 = [{{Rid, SrvId}, 60011}  || {Rid, SrvId, _} <- RoleList],
    honor_mgr:replace_honor_gainer(cross_warlord_sky_3, H60011);
add_honor2(?cross_warlord_label_land, RoleList, _) ->
    H60014 = [{{Rid, SrvId}, 60014}  || {Rid, SrvId, _} <- RoleList],
    honor_mgr:replace_honor_gainer(cross_warlord_land_3, H60014);
add_honor2(_, _, _) -> ok.

add_honor(?cross_warlord_label_sky, RoleList, RivalList) ->
    H60009 = [{{Rid, SrvId}, 60009}  || {Rid, SrvId, _} <- RoleList],
    H60010 = [{{Rid, SrvId}, 60010}  || {Rid, SrvId, _} <- RivalList],
    honor_mgr:replace_honor_gainer(cross_warlord_sky_1, H60009),
    honor_mgr:replace_honor_gainer(cross_warlord_sky_2, H60010);

add_honor(?cross_warlord_label_land, RoleList, RivalList) ->
    H60012 = [{{Rid, SrvId}, 60012}  || {Rid, SrvId, _} <- RoleList],
    H60013 = [{{Rid, SrvId}, 60013}  || {Rid, SrvId, _} <- RivalList],
    honor_mgr:replace_honor_gainer(cross_warlord_land_1, H60012),
    honor_mgr:replace_honor_gainer(cross_warlord_land_2, H60013);

add_honor(_, _, _) -> ok.

to_role_info(RoleList) ->
    to_role_info(RoleList, <<"">>).
to_role_info([], Bin) -> Bin;
to_role_info([{Rid, SrvId, Name} | T], Bin) ->
    B = notice:role_to_msg({Rid, SrvId, Name}),
    case Bin of
        <<"">> ->
            to_role_info(T, B);
        _ ->
            to_role_info(T, util:fbin(<<"~s ~s">>, [Bin, B]))
    end.

broadcast(StateName, Ts, Now) ->
    c_mirror_group:cast(all, cross_warlord_mgr, broadcast_srv, [StateName, Ts, Now]).

broadcast_srv(StateName, Ts, Now) ->
    case cross_warlord:check_in_open_time() of
        true -> do_broadcast(StateName, Ts, Now);
        _ -> ok
    end.

do_broadcast(notice, _Ts, _Now) ->
    sys_env:set(cross_warlord_camp_status, {1, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 1, 0, 0, 0}),
    role_group:pack_cast(world, 18110, {1, 0}),
    sys_env:set(cross_warlord_last_state, undefined),
    sys_env:set(cross_warlord_last_winer_sky, undefined),
    sys_env:set(cross_warlord_last_winer_land, undefined),
    notice:send(54, ?L(<<"万众期待，武神争霸，武神坛之战正式开始接受报名，请各路飞仙同道踊跃报名。">>));
do_broadcast(prepare, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {2, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 2, Now, 4, Now + 86400}),
    role_group:pack_cast(world, 18110, {2, 0}),
    notice:send(54, ?L(<<"武神坛之战报名正式结束，请收到入围邮件的飞仙同道在指定时间内参加比赛。">>));
do_broadcast(trial_round_0, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {3, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 3, Now, 4, Now + 86400}),
    role_group:pack_cast(world, 18110, {3, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战海选赛即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(idel_trial_1, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {4, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 4, Now, 6, Now + 86400}),
    role_group:pack_cast(world, 18110, {4, 0}),
    notice:send(54, ?L(<<"武神坛之战海选赛正式结束, 恭喜比赛获得胜利的飞仙同道晋级下一轮比赛">>));
do_broadcast(trial_round_1, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {5, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 5, Now, 6, Now + 86400}),
    role_group:pack_cast(world, 18110, {3, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战海选赛第一轮即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(idel_trial_2, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {6, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 6, Now, 8, Now + 86400}),
    role_group:pack_cast(world, 18110, {6, 0}),
    notice:send(54, ?L(<<"武神坛之战海选赛第一轮正式结束, 恭喜比赛获得胜利的飞仙同道晋级下一轮比赛">>));
do_broadcast(trial_round_2, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {7, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 7, Now, 8, Now + 86400}),
    role_group:pack_cast(world, 18110, {7, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战海选赛第二轮即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(idel_trial_3, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {8, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 8, Now, 10, Now + 86400}),
    role_group:pack_cast(world, 18110, {8, 0}),
    notice:send(54, ?L(<<"武神坛之战海选赛第二轮正式结束, 恭喜比赛获得胜利的飞仙同道晋级下一轮比赛">>));
do_broadcast(trial_round_3, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {9, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 9, Now, 10, Now + 86400}),
    role_group:pack_cast(world, 18110, {9, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战32强争夺赛即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(idel_top_16, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {10, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 10, Now, 12, Now + 86400}),
    role_group:pack_cast(world, 18110, {10, 0}),
    notice:send(54, ?L(<<"武神坛之战32强争夺赛正式结束, 恭喜比赛获得胜利的飞仙同道晋级下一轮比赛">>));
do_broadcast(top_16, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {11, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 11, Now, 12, Now + 86400}),
    role_group:pack_cast(world, 18110, {11, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战16强争夺赛即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(idel_top_8, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {12, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 12, Now, 14, Now + 86400}),
    role_group:pack_cast(world, 18110, {12, 0}),
    notice:send(54, ?L(<<"武神坛之战16强争夺赛正式结束, 恭喜比赛获得胜利的飞仙同道晋级下一轮比赛">>));
do_broadcast(top_8, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {13, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 13, Now, 14, Now + 86400}),
    role_group:pack_cast(world, 18110, {13, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战8强争夺赛即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(idel_top_4, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {14, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 14, Now, 16, Now + 86400}),
    role_group:pack_cast(world, 18110, {14, 0}),
    notice:send(54, ?L(<<"武神坛之战8强争夺赛正式结束, 恭喜比赛获得胜利的飞仙同道晋级下一轮比赛">>));
do_broadcast(top_4, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {15, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 15, Now, 16, Now + 86400}),
    role_group:pack_cast(world, 18110, {15, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战4强争夺赛即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(idel_semi_final_1, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {16, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 16, Now, 18, Now + 86400}),
    role_group:pack_cast(world, 18110, {16, 0}),
    notice:send(54, ?L(<<"武神坛之战4强争夺赛正式结束, 恭喜比赛获得胜利的飞仙同道晋级下一轮比赛">>));
do_broadcast(semi_final_1, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {17, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 17, Now, 18, Now + 86400}),
    role_group:pack_cast(world, 18110, {17, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战半决赛第一场即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(idel_semi_final_2, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {18, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 18, Now, 20, Now + (86400 * 2)}),
    role_group:pack_cast(world, 18110, {18, 0}),
    notice:send(54, ?L(<<"武神坛之战半决赛第一场正式结束, 恭喜比赛获得胜利的飞仙同道晋级下一轮比赛">>));
do_broadcast(semi_final_2, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {19, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 19, Now, 20, Now + (86400 * 2)}),
    role_group:pack_cast(world, 18110, {19, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战半决赛第二场即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(idel_third_final, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {20, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 20, Now, 22, Now + 86400}),
    role_group:pack_cast(world, 18110, {20, 0}),
    notice:send(54, ?L(<<"武神坛之战半决赛第二场正式结束, 恭喜比赛获得胜利的飞仙同道晋级下一轮比赛">>));
do_broadcast(third_final, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {21, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 21, Now, 22, Now + 86400}),
    role_group:pack_cast(world, 18110, {21, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战季军争夺赛即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(idel_final, _Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {22, 0}),
    sys_env:set(cross_warlord_camp_date, {1, 22, Now, 0, 0}),
    role_group:pack_cast(world, 18110, {22, 0}),
    notice:send(54, ?L(<<"武神坛之战季军争夺赛正式结束, 恭喜比赛获得胜利的飞仙同道晋级下一轮比赛">>));
do_broadcast(final, Ts, Now) ->
    sys_env:set(cross_warlord_camp_status, {23, Ts}),
    sys_env:set(cross_warlord_camp_date, {1, 23, Now, 0, 0}),
    role_group:pack_cast(world, 18110, {23, 55 * 60}),
    notice:send(54, ?L(<<"武神坛之战冠军争夺赛即将开始，请参加比赛的飞仙同道准备好准时进入比赛场景，逾时将错失本次比赛！">>));
do_broadcast(_, _, _) -> ok.

%%----------------------------------------------------
%% 辅助函数
%%----------------------------------------------------
continue(StateName, State = #state{ts = Ts, timeout = Timeout}) ->
    {next_state, StateName, State, util:time_left(Timeout, Ts)}.

continue(StateName, Reply, State = #state{ts = Ts, timeout = Timeout}) ->
    {reply, Reply, StateName, State, util:time_left(Timeout, Ts)}.
