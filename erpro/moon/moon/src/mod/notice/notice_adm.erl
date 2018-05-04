%%----------------------------------------------------
%% 公告系统后台接口
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(notice_adm).
-export([reload/0, stop/0, start/0, reload_board/0, restart/0
	,notice_said/0
	]).
-export([look/0]).

-include("notice.hrl").


%% @spec reload() -> Result
%% @doc 重载系统公告
notice_said() ->
    notice:notice_said(),
    ok.

%% @spec reload() -> Result
%% @doc 重载系统公告
reload() ->
    notice:reload().

%% @spec reload_board() -> ok
%% @doc 重载公告板内容
reload_board() ->
    notice:reload_board().

%% @doc restart() -> ok
%% @doc 重启公告系统
restart() -> 
    stop(),
    start(),
    ok.

%% @spec start() -> Result
%% @doc 启动公告系统
start() ->
    supervisor:restart_child(sup_master, notice).

%% @spec stop() -> Result
%% @doc 关闭公告系统
stop() ->
    supervisor:terminate_child(sup_master, notice).

%% @spec look() -> NoticeState
%% NoticeState = #notice_state{}
%% @doc 查看已有公告
look() ->
    notice:call(lookup).

