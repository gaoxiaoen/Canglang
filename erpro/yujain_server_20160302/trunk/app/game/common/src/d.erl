%%%-------------------------------------------------------------------
%%% @author jiangxw@ucweb.com
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 调试模块 => dbg 调试封装
%%% @end
%%% Created : 24. 七月 2015 18:14
%%%-------------------------------------------------------------------
-module(d).

%% API
-export([t/1, t/2, t/3]).
-export([ct/0, ct/1, ct/2, ct/3]).
-export([m/1, m/2, cm/1]).
-export([stop/0]).

%% @doc 函数调用跟踪
t(Module) when is_atom(Module) ->
    ensure_dbg_started(),
    dbg:p(all, c),
    dbg:tpl(Module, cx).
t(Module, Fun) ->
    ensure_dbg_started(),
    dbg:p(all, c),
    dbg:tpl(Module, Fun, cx).
t(Module, Fun, Arity) ->
    ensure_dbg_started(),
    dbg:p(all, c),
    dbg:tpl(Module, Fun, Arity, cx).

%% @doc 清除跟踪设置
ct() ->
    dbg:ctp().
ct(Module) when is_atom(Module) ->
    dbg:ctp(Module).
ct(Module, Function) ->
    dbg:ctp(Module, Function).
ct(Module, Function, Arity) ->
    dbg:ctp(Module, Function, Arity).


%% @doc 进程消息跟踪
m(Pid) ->
    ensure_dbg_started(),
    dbg:p(Pid, m).
m(Pid, send) ->
    ensure_dbg_started(),
    dbg:p(Pid, s);
m(Pid, recv) ->
    ensure_dbg_started(),
    dbg:p(Pid, r).

%% @doc 清除进程消息跟踪
cm(Pid) ->
    ensure_dbg_started(),
    dbg:p(Pid, clear).

%% @doc 关闭tracer
stop() ->
    case dbg:get_tracer() of
        {ok, TracerPid} ->
            dbg:stop_trace_client(TracerPid);
        _ ->
            ignore
    end.

%% @hidden
ensure_dbg_started() ->
    case dbg:get_tracer() of
        {ok, _TracerPid} -> ignore;
        _ ->
            dbg:tracer()
    end.

