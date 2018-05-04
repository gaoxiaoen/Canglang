%%----------------------------------------------------
%% 
%% 
%% @author
%% @end
%%----------------------------------------------------
-module(map_line).
-behaviour(gen_server).
-export([
        info/0
        ,switch/2
        ,fix/1
        %,line_num/0
        ,line_num/0
        %,set_actived_line_num/1
        ,each_line/1
        ,each_line/2
        ,each_line/3
        ,enter/2
        ,leave/1
        ,size/1
        ,start_link/0
]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("map_line.hrl").

%%
-record(state, {num}).

info() ->
    [ {Line, Size} || {Line, Size} <- ets:tab2list(?MODULE) ].

switch(Line, Role = #role{pid = Pid, pos = Pos = #pos{x = X, y = Y, map = MapId}}) ->
    enter(Pid, Line),
    map:role_enter(MapId, X, Y, Role#role{pos = Pos#pos{line = Line}}).

fix(Role = #role{pid = Pid, pos = Pos = #pos{line = Line}, login_info = #login_info{last_logout = LogoutTime}}) ->
    NewLine = case is_integer(LogoutTime) 
        andalso util:unixtime() - LogoutTime < ?LINE_OFFLINE_TIMEOUT of  %% 离线不足5分钟，先尝试进入上次线路
        true ->
            LineNum = line_num(),
            case Line > 0 andalso Line =< LineNum of
                true -> Line;
                _ -> auto_select()  %% 自动选一条
            end;
        _ -> %% 自动选一条
            auto_select()
    end,
    enter(Pid, NewLine),
    ?DEBUG("from line ~p to ~p", [Line, NewLine]),
    Role#role{pos = Pos#pos{line = NewLine}}.

%line_num() ->
%    case sys_env:get(line_num) of
%        L when is_integer(L) , L > 0 -> L;
%        _ -> 1
%    end.

%actived_line_num() ->
%    LineNum = line_num(),
%    case sys_env:get(actived_line_num) of
%        L when is_integer(L) , L > 0, L =< LineNum -> L;
%        _ -> LineNum
%    end.

line_num() ->
    ets:info(size, ?MODULE).

%% -> ok | {error, Reason}
% set_actived_line_num(Num) ->
%     Max = line_num(),
%     if not is_integer(Num) ->
%             {error, bad_arg};
%         Num =< 0 ->
%             {error, bad_arg};
%         Num > Max ->
%             {error, bad_arg};
%         true ->
%             sys_env:set(actived_line_num, Num),
%             ok
%     end.

each_line(F) ->
    util:for(1, ?LINE_MAX, fun(I)-> F(I) end).

each_line(F, A) ->
    util:for(1, ?LINE_MAX, fun(_)-> F(A) end).

each_line(M, F, A) ->
    util:for(1, ?LINE_MAX, fun(_)-> M:F(A) end).

enter(Pid, Line) ->
    gen_server:cast(?MODULE, {enter, Pid, Line}).

leave(Pid) ->
    gen_server:cast(?MODULE, {leave, Pid}).

size(Line) ->
    case ets:lookup(?MODULE, Line) of
        [] -> 0;
        [{Line, Size}|_] -> Size
    end.

%% @doc 启动分线管理器
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    init_lines(?LINE_DEF_COUNT),
    erlang:send_after(?LINE_RESET_INTERVL, self(), check),
    ?INFO("[~w] 启动成功", [?MODULE]),
    {ok, #state{num = ?LINE_DEF_COUNT}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({enter, Pid, Line}, State = #state{num = Num}) ->
    case Line > Num of %% 可能有不存在的线(异步问题)
        true -> 
            make_sure_lines(Num, Line),
            {noreply, State#state{num = Line}};
        _ -> 
            case put(Pid, Line) of
                undefined -> 
                    group_add(Line, Pid),
                    do_monitor(Pid);
                OldLine -> decrease(OldLine)
            end,
            increase(Line),
            {noreply, State}
    end;

handle_cast({leave, Pid}, State) ->
    case erase(Pid) of
        undefined -> ignore;
        Line -> 
            group_delete(Line, Pid),
            do_demonitor(Pid),
            decrease(Line)
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(check, State = #state{num = Num}) ->
    erlang:send_after(?LINE_RESET_INTERVL, self(), check),
    %% 
    L = lists:map(fun(N) ->
        case get(N) of
            Cnt when is_integer(Cnt) -> Cnt;
            _ -> 0
        end
    end, lists:seq(1, Num)),
    Sum = lists:sum(L),
    case Num * ?LINE_CAPACITY - Sum of
        Remain when Remain > ?LINE_CAPACITY + ?LINE_CREATE_CONDITION -> %% 空间过多
            case Num > ?LINE_DEF_COUNT of %% 保持最小3条线
                false -> 
                    %?INFO("keep line ~p", [Num]),
                    {noreply, State};
                true ->
                    case get(Num) of  %% 最大线
                        Size when Size =:= 0 orelse Size =:= undefined -> %% 最后一条线没有人，自动减线
                            NewNum = deactive_line(Num),
                            %?INFO("deactive line ~p", [Num]),
                            {noreply, State#state{num = NewNum}};
                        _ -> %% 最后一条线还有人，不减线
                            %?INFO("keep line ~p", [Num]),
                            {noreply, State}
                    end
            end; 
        Remain when Remain > ?LINE_CREATE_CONDITION -> %% 适合的剩余空间
            %?INFO("keep line ~p", [Num]),
            {noreply, State};
        _Remain -> 
            NewNum = active_line(Num + 1),  %% 创建新线
            %?INFO("active line ~p", [NewNum]),
            {noreply, State#state{num = NewNum}}
    end;

%% 处理地图进程异常退出
handle_info({'EXIT', Pid, Why}, State) ->
    ?ELOG("连接的进程[~w]异常退出: ~w", [Pid, Why]),
    {noreply, State};

handle_info({'DOWN', Ref, _Type, _Object, _Info}, State) ->
    case do_demonitor(Ref) of
        undefined -> ignore;
        Pid ->
            case erase(Pid) of
                undefined -> ignore;
                Line -> 
                    group_delete(Line, Pid),
                    decrease(Line)
            end
    end,
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
init_lines(Num) ->
    ets:new(?MODULE, [public, set, named_table]),
    util:for(1, Num, fun(N) ->
        put(N, 0),
        ets:insert(?MODULE, {N, 0})
    end).

decrease(Line) ->
    NewNum = case get(Line) of
        undefined -> 0;
        Num when Num > 0 -> Num - 1;
        _ -> 0
    end,
    put(Line, NewNum),
    check_line_status(decrease, Line, NewNum),
    ets:insert(?MODULE, {Line, NewNum}).

increase(Line) ->
    NewNum = case get(Line) of
        undefined -> 1;
        Num -> Num + 1
    end,
    put(Line, NewNum),
    check_line_status(increase, Line, NewNum),
    ets:insert(?MODULE, {Line, NewNum}).

do_monitor(Pid) ->
    Ref = erlang:monitor(process, Pid),
    put({ref, Pid}, Ref),
    put({pid, Ref}, Pid).

%% -> ref() | undefined
do_demonitor(Pid) when is_pid(Pid) ->
    case erase({ref, Pid}) of
        undefined -> undefined;
        Ref -> 
            catch erlang:demonitor(Ref),
            erase({pid, Ref}), Ref
    end;
%% -> pid() | undefined
do_demonitor(Ref) ->
    case erase({pid, Ref}) of
        undefined -> undefined;
        Pid -> erase({ref, Pid}), Pid
    end.

deactive_line(Line) when Line > 1 ->
    erase(Line),
    ets:delete(?MODULE, Line),
    Line - 1;
deactive_line(Line) -> 
    Line.

active_line(Line) ->
    put(Line, 0),
    ets:insert(?MODULE, {Line, 0}),
    Line.

%% -> Line
auto_select() ->
    L = lists:keysort(1, ets:tab2list(?MODULE)),   %% 按线路编号排序
    auto_select(L, L).

auto_select([], L) -> %% 找不到通畅的线路, 就找最少人的线路
    select_min_size(L);
auto_select([{Line, Size}|_], _L) when Size < ?LINE_CAPACITY -> %% 选择第一个通畅的线路
    Line;
auto_select([_|T], L) ->
    auto_select(T, L).

select_min_size([]) -> 1;
select_min_size([{Line, _Size}]) -> Line; 
select_min_size([{Line, Size}|T]) ->
    select_min_size(T, {Line, Size}).

select_min_size([], {Line, _}) -> Line;
select_min_size([{Line, Size}|T], {_, Size0}) when Size < Size0 ->
    select_min_size(T, {Line, Size});
select_min_size([{_, _}|T], {Line, Size}) ->
    select_min_size(T, {Line, Size}).
   
make_sure_lines(From, To) ->
    util:for(From + 1, To, fun(Line)->
        case get(Line) of
            undefined -> 
                put(Line, 0),
                ets:insert(?MODULE, {Line, 0});
            _ ->
                ignore
        end
    end).

group_add(Line, Pid) ->
    case get({group, Line}) of
        undefined ->
            put({group, Line}, [Pid]);
        L ->
            put({group, Line}, [Pid|L])
    end.

group_delete(Line, Pid) ->
    case get({group, Line}) of
        undefined ->
            put({group, Line}, []);
        L ->
            put({group, Line}, lists:delete(Pid, L))
    end.

check_line_status(increase, Line, Num) when Num =:= ?LINE_CAPACITY + 1 ->
    broadcast(Line, 1);
check_line_status(decrease, Line, ?LINE_CAPACITY) ->
    broadcast(Line, 0);
check_line_status(_, _, _) ->
    ok.

broadcast(Line, Status) ->
    case get({group, Line}) of
        undefined -> ok;
        L -> [ sys_conn:pack_send(Pid, 10166, {Line, Status}) || Pid <- L]
    end.
