%%----------------------------------------------------
%% @doc 合服主程序
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_main).

-behaviour(application).

-export([
        start/0
        ,start/2
        ,stop/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

-ifdef(debug_sql).
-define(DB_START(DataSource), mysql:start_link(DataSource, DbHost, DbPort, DbUser, DbPass, DbName)).
-else.
-define(DB_START(DataSource), mysql:start_link(DataSource, DbHost, DbPort, DbUser, DbPass, DbName, fun(_, _, _, _) -> ok end, DbEncode)).
-endif.

%%----------------------------------------------------
%% 接口
%%----------------------------------------------------
start() ->
    start_applications([sasl, merge_main], []).

%%----------------------------------------------------
%% application函数 
%%----------------------------------------------------
start(_Type, _Args) ->
    error_logger:logfile({open, lists:concat(["../var/error_merge", node(), ".log"])}),
    ok = connect_to_mysql(),
    merge_sup:start_link().

stop(_State) ->
    ok.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------
%% 启动应用
start_applications([], _SApp) -> ok;
start_applications([App | T], SApp) ->
    case application:start(App) of
        ok -> 
            start_applications(T, [App | SApp]);
        {error, Reason} ->
            stop_applications(lists:reverse(SApp)),
            throw({error, {already_started, App, Reason}})
    end.

%% 关闭应用            
stop_applications([]) -> ok;
stop_applications([App | T]) ->
    application:stop(App),
    stop_applications(T).

%% 创建链接
connect_to_mysql() ->
    {ok, [DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, DbConnNum]} = application:get_env(?merge_target),
    ?DB_START(?merge_target),
    util:for(1, DbConnNum,
        fun(_I) ->
                mysql:connect(?merge_target, DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, true)
        end
    ),
    {ok, SrcList} = application:get_env(?merge_src_list),
    connect_to_mysql(SrcList).
connect_to_mysql([]) -> ok;
connect_to_mysql([{Platform, DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, DbConnNum, _UpdateRealm, _Realm} | T]) ->
    DataSource = merge_util:dbsrc(Platform),
    ?DB_START(DataSource),
    util:for(1, DbConnNum,
        fun(_I) ->
                mysql:connect(DataSource, DbHost, DbPort, DbUser, DbPass, DbName, DbEncode, true)
        end
    ),
    connect_to_mysql(T).
