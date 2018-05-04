%% --------------------
%% 角色定时器处理
%% wpf wprehard@qq.com
%% --------------------

-module(role_timer).
-export([
        new_timing/4
        ,set_timer/5
        ,set_timer/2
        ,del_timer/2
        ,handle_timer/2
        ,have_timer/2
        ,get_remain_time/2
]).

-include("common.hrl").
-include("timing.hrl").
-include("role.hrl").

%% @spec new_timing(Id, Timeout, MFA, Count) -> NewTiming
%% Id = atom() | int() | tuple() 定时器标识
%% Timeout = integer() 超时时间millionseconds
%% MFA = {M, F, A} 参数
%% Count = atom() | int() 0:自动无限循环 1-~:超时循环次数 day_check:隔天0点检查类定时器
%% @doc 生成timing
new_timing(Id, Timeout, {M, F, A}, Count) ->
    #timing{
        id = Id
        ,timeout = Timeout
        ,mfa = {M, F, A}
        ,count = Count
        ,num = 0
    }.

%% @spec set_timer(Id, Timeout, MFA, Count, Role) -> NewRole
%% Id = atom() | int() | tuple() 定时器标识
%% Timeout = int() 超时时间，毫秒
%% MFA = {M, F, A} 参数回调函数 要求其返回：{ok, State} | {ok}
%% Count = atom() | int() 0:自动无限循环 1-~:超时循环次数 day_check:隔天0点检查类定时器
%% NewRole = Role = #role{} 角色数据结构
%% @doc 设置定时器
%% <div> 
%%  如果需要结束定时器的话，可以在回调函数中手动结束并删除定时器
%% </div>
set_timer(_, Timeout, _, _, Role) when Timeout =< 0 -> Role;
set_timer(TimingId, Timeout, MFA, Count, Role) ->
    set_timer(new_timing(TimingId, Timeout, MFA, Count), Role).

set_timer(Timing = #timing{id = TimingId, timeout = Timeout, mfa = MFA}, Role = #role{pid = RolePid, timer = Timers}) ->
    case lists:keyfind(TimingId, #timing.id, Timers) of
        T = #timing{id = TimingId, ref = Ref, mfa = MFA} ->
            ?DEBUG("角色[NAME:~w]定时器已经存在[TimingID:~w]，重新设置", [Role#role.name, TimingId]),
            case erlang:read_timer(Ref) of
                false ->
                    NewRef = erlang:send_after(Timeout, RolePid, {timing, TimingId, MFA}),
                    Role#role{timer = lists:keyreplace(TimingId, #timing.id, Timers, T#timing{ref = NewRef, num = 1})};
                _Remain ->
                    ?ERR("角色[NAME:~w]定时器已经存在[TimingID:~w]且未超时，忽略处理", [Role#role.name, TimingId]),
                    Role
            end;
        false ->
            ?DEBUG("设置角色定时器[NAME:~s TimingID:~w, Timeout:~w]", [Role#role.name, TimingId, Timeout]),
            NewRef1 = erlang:send_after(Timeout, RolePid, {timing, TimingId, MFA}),
            Role#role{timer = [Timing#timing{ref = NewRef1, num = 1} | Timers]}; %% 添加定时器
        _Other ->
            ?ERR("角色定时器设置异常[TimingID:~w, Timer:~w], 直接忽略", [TimingId, _Other]),
            Role
    end.

%% @spec del_timer(Id, Role = #role{timer = TimerList}) -> {ok, {Timeout, Remain}, NewRole} | false
%% Id = atom() | int() | tuple() 定时器标识
%% Timeout = Remain = int() 定时超时/剩余的时间
%% NewRole = Role = #role{}
%% @doc 结束并删除定时器
del_timer(TimingId, Role = #role{timer = Timers}) ->
    case lists:keyfind(TimingId, #timing.id, Timers) of
        #timing{ref = Ref, timeout = Timeout} ->
            Remain = case erlang:cancel_timer(Ref) of
                false -> Timeout;
                Time -> Time
            end,
            %% ?DEBUG("删除定时器[Role:~s, TimingID:~w, Timeout:~w, Remain:~w]", [Role#role.name, TimingId, Timeout, Remain]),
            {ok, {Timeout, Remain}, Role#role{timer = lists:keydelete(TimingId, #timing.id, Timers)}};
        false ->
            %% ?DEBUG("没找到要删除的定时器[Role:~s, TimingID:~w]", [Role#role.name, TimingId]),
            false
    end.

%% 检查是否有此定时器
have_timer(TimingId, #role{timer = Timers}) ->
    case lists:keyfind(TimingId, #timing.id, Timers) of
        #timing{} ->
            true;
        false ->
            false
    end.

%% 检查定时器
get_remain_time(TimingId, #role{timer = Timers}) ->
    case lists:keyfind(TimingId, #timing.id, Timers) of
        #timing{ref = Ref} ->
            case erlang:read_timer(Ref) of
                false ->
                    0;
                Remain ->
                    Remain div 1000
            end;
        false ->
            0
    end.

%% @spec handle_timer(State, Id) -> {ok} | {ok, NewState}
%% Id = atom() | int() | tuple() 定时器标识
%% State = #role{}
%% @doc 定时器循环处理; 由role进程默认调用
handle_timer(State = #role{timer = Timers}, TimingId) ->
    case lists:keyfind(TimingId, #timing.id, Timers) of
        false ->
            ?DEBUG("定时器回调处理循环时找不到TimingId:~w", [TimingId]),
            State;
        T ->
            do_handle_timer(State, T)
    end.

%% -------------------------------------------------
%% 内部处理
%% -------------------------------------------------

%% 处理定时器的循环
do_handle_timer(State = #role{pid = Pid, timer = Timers}, T = #timing{id = TimingId, mfa = MFA, count = Count})
when Count =:= day_check ->
    LoopTimeout = 86400000 + util:rand(0, 5000), %% 隔天24h
    NewRef = erlang:send_after(LoopTimeout, Pid, {timing, TimingId, MFA}),
    State#role{timer = lists:keyreplace(TimingId, #timing.id, Timers, T#timing{ref = NewRef})};
do_handle_timer(State = #role{pid = Pid, timer = Timers}, T = #timing{id = TimingId, timeout = Timeout, mfa = MFA, count = Count, num = Num})
when Count > 0 ->
    case Num >= Count of
        true -> %% 超过次数，停止定时器
            %% ?DEBUG("角色定时器超过次数停止[Role:~s, TimerID:~w]", [State#role.name, TimingId]),
            State#role{timer = lists:keydelete(TimingId, #timing.id, Timers)};
        false -> %% 循环开启定时
            %% ?DEBUG("角色定时器循环开启[Role:~w, TimerID:~w]", [State#role.id, TimingId]),
            NewRef = erlang:send_after(Timeout, Pid, {timing, TimingId, MFA}),
            State#role{timer = lists:keyreplace(TimingId, #timing.id, Timers, T#timing{ref = NewRef, num = Num + 1})}
    end;
do_handle_timer(State = #role{pid = Pid, timer = Timers}, T = #timing{id = TimingId, timeout = Timeout, mfa = MFA, count = Count})
when Count =:= 0 ->
    %% 循环开启定时
    %% ?DEBUG("角色定时器循环开启[Role:~w, TimerID:~w]", [State#role.id, TimingId]),
    NewRef = erlang:send_after(Timeout, Pid, {timing, TimingId, MFA}),
    State#role{timer = lists:keyreplace(TimingId, #timing.id, Timers, T#timing{ref = NewRef})};
do_handle_timer(State, _T) ->
    ?ERR("角色定时器处理异常[Role:~s, TimerID:~w]", [State, _T]),
    State.
