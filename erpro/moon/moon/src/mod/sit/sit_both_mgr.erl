%% **********************
%% 打坐双修全局初始进程
%% wpf wprehard@qq.com
%% **********************
-module(sit_both_mgr).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-behaviour(gen_server).

-include("common.hrl").
-include("sit.hrl").

-record(state, {
        num = 1
    }).

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Pid = pid()
%% Error = string()
%% @doc 双修打坐数据管理器
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% *****************************
%% 内部接口
%% *****************************
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(ets_sit_both, [{keypos, #sit_both.id_one}, named_table, public, set]),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% TODO:处理队伍进程异常挂掉
handle_info({'EXIT', Pid, Why}, State) ->
    ?ERR("双修数据管理进程[~w]异常挂掉: ~w", [Pid, Why]),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

