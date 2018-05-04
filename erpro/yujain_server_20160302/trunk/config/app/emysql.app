%% Emysql .app file template
%% This template is filled out by rebar, 
%% or make (Makefile made to fill modules in)
%% and then cp src/emysql.app.src ebin/emysql.app

%% Settings (defaults in include/emysql.hrl):
%% default_timeout (TIMEOUT = 8000)
%% lock_timeout (LOCK_TIMEOUT = 5000)

{application, emysql, [
    {description, "Emysql - Erlang MySQL driver"},
    {vsn, "0.3.0"},
    {{modules, [emysql_app, emysql_auth, emysql_conn, emysql_conn_mgr, emysql, emysql_statements, emysql_sup, emysql_tcp, emysql_tracer, emysql_util, emysql_worker]}}, 
    {mod, {emysql_app, ["Tue Oct 29 11:00:14 CST 2013"]}},
    {registered, []},
    {applications, [kernel, stdlib, crypto]},
    {env, [{default_timeout, 5000}, {conn_test_period, 28000}]}
]}.
