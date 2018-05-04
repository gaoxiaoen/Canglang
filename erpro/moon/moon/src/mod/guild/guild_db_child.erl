%----------------------------------------------------
%%  帮会数据数据库操作 子进程
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_db_child).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([info/3]).

-include("common.hrl").

info(Pid, Sql, Args) when is_pid(Pid) ->
    Pid ! {execute, Sql, Args}, 
    ok;
info(_Pid, _Sql, _Args) ->
    error.

%%-----------------------------------------------------------
%% 系统函数
%%-----------------------------------------------------------
start_link() ->
    gen_server:start_link(?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, []}.

%%----------------------------------------------------------
%% handle_call
%%----------------------------------------------------------
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%----------------------------------------------------------
%% handle_cast
%%----------------------------------------------------------
%% 容错
handle_cast(_Data, State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% handle_info
%%-----------------------------------------------------------
handle_info({execute, Sql, Args}, State) ->
    case db:execute(Sql, Args) of
        {ok, _Result} ->
            {noreply, State};
        {error, _Why} ->
            ?ERR("帮会数据管理进程执行数据操作时发生错误, 【Reason: ~s】~n【~s】【~w】", [_Why, Sql, Args]),
            {noreply, State}
    end;

%% 容错
handle_info(_Data , State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% 系统关闭
%%-----------------------------------------------------------
terminate(_Reason, _State) ->
    {noreply, _State}.

%%-----------------------------------------------------------
%% 热代码切换
%%-----------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

