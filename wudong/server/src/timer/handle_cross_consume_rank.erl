%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 六月 2016 11:00
%%%-------------------------------------------------------------------
-module(handle_cross_consume_rank).
-author("luobq").

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
handle(State, NowTime) ->
    {_, {_H, M, _S}} = util:seconds_to_localtime(NowTime),
    LeaveTime = cross_consume_rank:get_leave_time(),
    IsCenterAll = center:is_center_all(),
    if
        IsCenterAll andalso LeaveTime =< 60 andalso LeaveTime =/= 0 ->
            Base = cross_consume_rank:get_act(),
            spawn(fun() -> util:sleep(max(LeaveTime-1, 0) * 1000), cross_consume_rank_proc:end_reward(Base) end); %% 开奖
        true ->
            if
                M rem 10 == 0 ->
                    spawn(fun() -> cross_consume_rank_proc:cmd_refresh() end);
                true -> ok
            end
    end,
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