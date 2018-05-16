%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十一月 2015 14:46
%%%-------------------------------------------------------------------
-module(handle_arena).
-author("hxming").
-compile(export_all).
-include("common.hrl").
-include("server.hrl").

%%=========================================================================
%% 一些定义
%% TODO: 定义模块状态。
%%=========================================================================

%%=========================================================================
%% 回调接口
%% TODO: 实现回调接口。
%%=========================================================================

%% -----------------------------------------------------------------
%% @desc     启动回调函数，用来初始化资源。
%% @param
%% @return  {ok, State}     : 启动正常
%%           {ignore, Reason}: 启动异常，本模块将被忽略不执行
%%           {stop, Reason}  : 启动异常，需要停止所有后台定时模块
%% -----------------------------------------------------------------
init() ->
    {ok, ?MODULE}.

%% -----------------------------------------------------------------
%% @desc     服务回调函数，用来执行业务操作。
%% @param    State          : 初始化或者上一次服务返回的状态
%% @return  {ok, NewState}  : 服务正常，返回新状态
%%           {ignore, Reason}: 服务异常，本模块以后将被忽略不执行，模块的terminate函数将被回调
%%           {stop, Reason}  : 服务异常，需要停止所有后台定时模块，所有模块的terminate函数将被回调
%% -----------------------------------------------------------------
handle(State, NowTime) ->
    RewardTime = 22 * 3600,
    TodaySec = util:get_seconds_from_midnight(NowTime),
    if TodaySec >= RewardTime andalso RewardTime + 600 > TodaySec ->
        arena_proc:get_server_pid() ! {arena_daily_reward, NowTime},
        cross_arena_proc:get_server_pid() ! {arena_daily_reward, NowTime};
        true -> skip
    end,
%%    RewardTime1 = 6 * 3600,
%%    if TodaySec >= RewardTime1 andalso RewardTime1 + 600 > TodaySec ->
%%        arena_proc:get_server_pid() ! {load_arena};
%%        true -> skip
%%    end,
%%     Rand = util:rand(2000, 30000),
%%     spawn(fun() -> timer:sleep(1000 + Rand), online_hour_reward() end),
    spawn(fun() -> cross_war_repair:timer_day1() end),
    spawn(fun() -> timer:sleep(500), cross_war_repair:timer() end),
    spawn(fun() -> guild_fight:clean_log_data() end),
    spawn(fun() -> guild_fight:update_to_db() end),
    {ok, State}.

%% -----------------------------------------------------------------
%% @desc     停止回调函数，用来销毁资源。
%% @param    Reason        : 停止原因
%% @param    State         : 初始化或者上一次服务返回的状态
%% @return   ok
%% -----------------------------------------------------------------
terminate(Reason, State) ->
    ?DEBUG("================Terming..., Reason=[~w], Statee = [~w]", [Reason, State]),
    ok.

online_hour_reward() ->
    {{_Y, _Mon, _D},{H, _M, _S}} = erlang:localtime(),
    case lists:member(H, [0, 9, 12, 15, 18, 20, 22, 23]) of
        false ->
            skip;
        true ->
            OnlineList = ets:tab2list(ets_online),
            F = fun(#ets_online{key = Pkey}) ->
                {Title, Content} = t_mail:mail_content(71),
                mail:sys_send_mail([Pkey], Title, Content, [{1015000,2},{1008000,2},{1016001,2},{10199,100},{10101,100000}])
            end,
            lists:map(F, OnlineList)
    end.