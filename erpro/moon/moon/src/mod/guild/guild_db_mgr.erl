%----------------------------------------------------
%%  帮会数据数据库操作 管理进程
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_db_mgr).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([execute/2, create_child/0]).

-include("common.hrl").
-define(guild_db_childs, 5).
-define(guild_db_childs_limit, 10).

execute(Sql, Args) ->
    gen_server:cast({global, ?MODULE}, {execute, Sql, Args}).

create_child() ->
    gen_server:cast({global, ?MODULE}, create_child).

%%-----------------------------------------------------------
%% 系统函数
%%-----------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    ?INFO("[~w] 正在启动...", [?MODULE]),
    case create_guild_db_child_manage(?guild_db_childs) of
        error ->
            create_guild_db_child_error;
        Pids ->
            ?INFO("[~w] 启动完成", [?MODULE]),
            {ok, Pids}
    end.

%%----------------------------------------------------------
%% handle_call
%%----------------------------------------------------------
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%----------------------------------------------------------
%% handle_cast
%%----------------------------------------------------------
handle_cast({execute, Sql, Args}, [Pid | Pids]) ->
    case guild_db_child:info(Pid, Sql, Args) of
        error ->
            erlang:send_after(3000, self(), {execute, Sql, Args}),
            self() ! create_child,
            {noreply, Pids};
        _ ->
            {noreply, Pids ++ [Pid]}
    end;

handle_cast(create_child, State) ->
    case length(State) =< ?guild_db_childs_limit of
        true ->
            case create_guild_db_child_manage(1) of
                error ->
                    ?ELOG("create_guild_db_child_error"),
                    {noreply, State};
                Pid ->
                    {noreply, State ++ Pid}
            end;
        false ->
            ?ELOG("创建的数据库操作子进程过多，【~w】", [length(State)]),
            {noreply, State}
    end;

%% 容错
handle_cast(_Data, State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% handle_info
%%-----------------------------------------------------------
handle_info({execute, Sql, Args}, [Pid | Pids]) ->
    case guild_db_child:info(Pid, Sql, Args) of
        error ->
            erlang:send_after(3000, self(), {execute, Sql, Args}),
            self() ! create_child,
            {noreply, Pids};
        _ ->
            {noreply, Pids ++ [Pid]}
    end;

handle_info(create_child, State) ->
    case length(State) =< ?guild_db_childs_limit of
        true ->
            case create_guild_db_child_manage(1) of
                error ->
                    ?ELOG("创建的数据库操作子进程失败"),
                    {noreply, State};
                Pid ->
                    {noreply, State ++ Pid}
            end;
        false ->
            ?ELOG("创建的数据库操作子进程过多，【~w】", [length(State)]),
            {noreply, State}
    end;

handle_info({'EXIT', Pid, _REASON}, State) ->
    ?ERR("帮会数据库操作管理进程收到 子进程 EXIT 消息，【~w】", [_REASON]),
    self() ! create_child,
    {noreply, State -- [Pid]};

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

%% 私有函数
create_guild_db_child_manage(Nums) when Nums > 0->
    create_guild_db_child_manage(Nums, []);
create_guild_db_child_manage(_Nums) ->
    [].
create_guild_db_child_manage(0, Pids) ->
    Pids;
create_guild_db_child_manage(Nums, Pids) ->
    case guild_db_child:start_link() of    %% 创建帮会进程
        {ok, Pid} ->
            create_guild_db_child_manage(Nums - 1, [Pid | Pids]);
        _ ->
            error
    end.
