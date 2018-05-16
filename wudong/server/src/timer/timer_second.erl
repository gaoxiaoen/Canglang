%%%-----------------------------------
%%% @Module  : timer_server_fewsecond
%%% @Author  : zj
%%% @Created : 2013.8.6
%%% @Description: 每秒执行一次，!!注意不能在此定时器每次执行数据操作，此定时器应该用于时间检测和触发。
%%% @ 每个节点都在执行，如只需执行一次，需在逻辑代码加上节点号限制。
%%%-----------------------------------
-module(timer_second).
-behaviour(gen_fsm).
-export([
		start_link/0,
		stop/0
	]
).
-export([init/1, waiting/2, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-include("common.hrl").
%%=========================================================================
%% 一些定义
%% TODO: 在回调模块列表中增加新模块。
%%=========================================================================

% 回调模块列表
-define(MODLE_LIST, [

]).

% 休眠间隔1秒
-define(TIMEOUT, 1000).

%%=========================================================================
%% 接口函数
%%=========================================================================

%% 启动服务器
start_link() ->
    % 启动进程{服务名称，回调模块名称，初始参数，列表选项}
    % 使用初始参数回调init()方法
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 关闭服务器时回调
stop() ->
    ok.

%%=========================================================================
%% 回调函数
%%=========================================================================

init([]) ->
    case do_init(?MODLE_LIST, [], []) of
         {ok, NewModuleList, NewStateList} ->
             put_unixtime(),
             {ok, waiting, {NewModuleList, NewStateList}, ?TIMEOUT};
          {stop, Reason} ->
             {stop, Reason}
    end.

waiting(timeout, State) ->
    {ModuleList, StateList} = State,
    TotalTime = update_unixtime(),
    NowTime = util:unixtime(),
    if        %%校正时间
        TotalTime =:= NowTime ->
            NextTime = ?TIMEOUT;
        TotalTime > NowTime ->
            NextTime = ?TIMEOUT + 500;
        true ->
            NextTime = ?TIMEOUT - 500
    end,
    case catch do_handle(ModuleList, StateList, [], [], [],[]) of
         {ok, NewModuleList, NewStateList} ->
             {next_state, waiting, {NewModuleList, NewStateList}, NextTime};
         {stop, Reason, IgnoreModuleList, _IgnoreStateList} ->
             {TerminateModuleList, TerminateStateList} = filter_module(IgnoreModuleList, ModuleList, StateList),
             do_terminate(TerminateModuleList, TerminateStateList, Reason),
             {stop, Reason};
         Err ->
            ?ERR("~p~n", [Err]),
            {next_state, waiting, {ModuleList, StateList}, NextTime}
    end.

handle_event(stop, _StateName, State) ->
    {stop, normal, State}.

handle_sync_event(_Any, _From, StateName, State) ->
    {reply, {error, unhandled}, StateName, State}.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

handle_info(_Any, StateName, State) ->
    {next_state, StateName, State}.

terminate(_Any, _StateName, _Opts) ->
    ok.


%%=========================================================================
%% 内部函数
%%=========================================================================

do_init([], NewModuleList, NewStateList) ->
    {ok, NewModuleList, NewStateList};
do_init(ModuleList, NewModuleList, NewStateList) ->
    [Module|ModuleLeft] = ModuleList,    
    case Module:init() of
        {ok, NewSate} ->            
            % 保留该模块，收集该模块状态
            do_init(ModuleLeft, NewModuleList++[Module], NewStateList++[NewSate]);
        {ignore, _Reason} ->
            % 删除该模块，不收集该模块状态
            do_init(ModuleLeft, NewModuleList, NewStateList);
        {stop, Reason} ->
        	% 初始化失败
        	{stop, Reason}
    end.


do_handle([], [], NewModuleList, NewStateList, _IgnoreModuleList, _IgnoreStateList) ->
    {ok, NewModuleList, NewStateList};
do_handle(ModuleList, StateList, NewModuleList, NewStateList, IgnoreModuleList, IgnoreStateList) ->
    [Module|ModuleLeft] = ModuleList,
    [State|StateLeft]   = StateList,
    case Module:handle(State,get_unixtime()) of
        {ok, NewState} ->
            % 保留该模块，收集该模块状态
            do_handle(ModuleLeft, StateLeft, NewModuleList++[Module], NewStateList++[NewState], IgnoreModuleList, IgnoreStateList);
        {ignore, Reason} ->
            % 回调该模块的terminate方法
            Module:terminate(Reason, State),
            % 删除该模块，不收集该模块状态，加入忽略列表
            do_handle(ModuleLeft, StateLeft, NewModuleList, NewStateList, IgnoreModuleList++[Module], IgnoreStateList++[State]);
        {stop, Reason} ->
            % 处理失败
            {stop, Reason, IgnoreModuleList, IgnoreStateList}
    end.
   

do_terminate([], [], _Reason) ->
    ok;
do_terminate(ModuleList, StateList, Reason) ->
    [Module|ModuleLeft] = ModuleList,
    [State|StateLeft]   = StateList,
    Module:terminate(Reason, State),
    do_terminate(ModuleLeft, StateLeft, Reason).

filter_module([], ModuleList, StateList) ->
    {ModuleList, StateList};
filter_module(IgnoreModuleList, ModuleList, StateList) ->
    [Module|ModuleLeft] = IgnoreModuleList,
    Index = get_elem_index(ModuleList, Module, 0),
    State = lists:nth(Index, StateList),
    filter_module(ModuleLeft, lists:delete(Module, ModuleList),lists:delete(State, StateList)).

get_elem_index([], _Elem, _Index) ->
    0;
get_elem_index(List, Elem, Index) ->
    [E|ListLeft] = List,
    if  E =:= Elem ->
            Index+1;
        true ->
            get_elem_index(ListLeft, Elem, Index+1)
    end.

%%获取当前时间
get_unixtime() ->
    case get(timer_second_time) of
        undefined ->
            put_unixtime();
        T ->
            T
    end.

%%写入当前时间
put_unixtime() ->
    Time = util:unixtime(),
    put(timer_second_time,Time),
    Time.

%%根据刷新频率更新时间
update_unixtime() ->
    T = get_unixtime(),
    Now = T + 1,
    put(timer_second_time, Now),
    Now.