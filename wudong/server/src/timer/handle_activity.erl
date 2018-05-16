%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 五月 2016 下午2:02
%%%-------------------------------------------------------------------
-module(handle_activity).
-author("fengzhenlin").
-compile(export_all).
-include("common.hrl").

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
handle(State, _NowTime) ->
    spawn(fun() -> activity_proc:get_act_pid() ! act_rank_notice end),
    spawn(fun() -> open_act_all_rank:sys_midnight_cacl() end),
    spawn(fun() -> open_act_all_rank2:sys_midnight_cacl() end),
    spawn(fun() -> open_act_all_rank3:sys_midnight_cacl() end),
    spawn(fun() -> open_act_guild_rank:sys_midnight_cacl() end),
    spawn(fun() -> merge_act_guild_rank:sys_midnight_cacl() end),
    spawn(fun() -> act_jbp:sys_back() end),
    spawn(fun() -> limit_buy:ets_to_db() end),
    spawn(fun() -> gold_silver_tower:ets_to_db() end),
    spawn(fun() -> consume_rank:sys_midnight_cacl() end),
    spawn(fun() -> recharge_rank:sys_midnight_cacl() end),
    spawn(fun() -> act_wishing_well:sys_midnight_cacl() end),
    spawn(fun() -> cross_act_wishing_well:sys_midnight_cacl() end),
    spawn(fun() -> marry_rank:sys_midnight_cacl() end),
    spawn(fun() -> act_one_gold_buy:timer() end),
    spawn(fun() -> festival_red_gift:timer() end),
    spawn(fun() -> festival_red_gift:sys_notice_all_client() end),
    spawn(fun() -> act_limit_xian:timer() end),
    spawn(fun() -> act_limit_pet:timer() end),
    spawn(fun() -> act_cbp_rank:timer() end),
    spawn(fun() -> cross_1vn:sys_midnight_cacl(_NowTime) end),
    spawn(fun() -> cron_activity(_NowTime) end),
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


cron_activity(Now) ->
    case config:is_center_node() of
        true -> skip;
        false ->
            {_, {_, Min, _}} = util:seconds_to_localtime(Now),
            case Min rem 20 == 0 of
                false -> skip;
                true ->
                    cron_activity:cron_activity()
            end
    end.