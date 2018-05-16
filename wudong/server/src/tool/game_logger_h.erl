%%%-------------------------------------------------------------------
%%% @author zj
%%% @doc 系统事件处理器
%%% @Email   : 1812338@gmail.com
%%% Created : 2013.10.28
%%%-------------------------------------------------------------------
-module(game_logger_h).
-behaviour(gen_event).
-include("common.hrl").
%% gen_event callbacks
-export([
         init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2,
     code_change/3
        ]).


%%%----------------------------------------------------------------------
%%% Callback functions from gen_event
%%%----------------------------------------------------------------------

%%----------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok, State}          |
%%          Other
%%----------------------------------------------------------------------
init(_File) ->
    {ok, none}.

%%----------------------------------------------------------------------
%% Func: handle_event/2
%% Returns: {ok, State}                                |
%%          {swap_handler, Args1, State1, Mod2, Args2} |
%%          remove_handler                              
%%----------------------------------------------------------------------
handle_event(Event, State) ->
    spawn(fun() ->
        LocalTime  = erlang:localtime(),
        File = make_log_file(LocalTime),
        write_event(File, {LocalTime,Event})
     end),
    {ok, State}.

%%----------------------------------------------------------------------
%% Func: handle_call/2
%% Returns: {ok, Reply, State}                                |
%%          {swap_handler, Reply, Args1, State1, Mod2, Args2} |
%%          {remove_handler, Reply}                            
%%----------------------------------------------------------------------
handle_call(_Request, State) ->
    Reply = ok,
    {ok, Reply, State}.

%%----------------------------------------------------------------------
%% Func: handle_info/2
%% Returns: {ok, State}                                |
%%          {swap_handler, Args1, State1, Mod2, Args2} |
%%          remove_handler                              
%%----------------------------------------------------------------------
handle_info({'EXIT', _Fd, _Reason}, _State) ->
    remove_handler;
handle_info(_Info, State) ->
    {ok, State}.

%%----------------------------------------------------------------------
%% Func: terminate/2
%% Purpose: Shutdown the server
%% Returns: any
%%----------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%----------------------------------------------------------------------
%%% Internal functions
%%%----------------------------------------------------------------------
%% 写文件
do_write(_, _, _, [], _) ->
    skip;
do_write(Fd, Time, Type, Format, Args) ->
    {{Y,Mo,D},{H,Mi,S}} = Time, 
    LBin = erlang:iolist_to_binary(Type),
    InfoMsg = unicode:characters_to_list(LBin),
    Time2 = io_lib:format("< ~w-~.2.0w-~.2.0w ~.2.0w:~.2.0w:~.2.0w >~n",
          [Y, Mo, D, H, Mi, S]),
    L2 = lists:concat([InfoMsg, Time2]),
    B = unicode:characters_to_binary(L2),
    file:write_file(Fd, B, [append]),
    try 
        M = 
            case Args of
                [] -> format_report(Format);
                _ -> io_lib:format(Format, Args)
            end,
        file:write_file(Fd, string:sub_string(M,1,3000), [append])
    catch _:Error ->
            io:format("log error ~p ~p ~p", [Error, Format, Args])
    end.

%% 事件匹配
write_event(Fd, {Time, {error, _GL, {Pid, Format, Args}}}) ->
    [L] = io_lib:format("~ts", [add_node("error:",Pid)]),
    do_write(Fd, Time, L, Format, Args);

write_event(Fd, {Time, {emulator, _GL, Chars}}) ->
    [L] = io_lib:format("~ts",["emulator:~n"]),
    do_write(Fd,Time,L,Chars,[]);

write_event(Fd, {Time, {info, _GL, {Pid, Info,Args}}}) ->
    [L] = io_lib:format("~ts",[add_node("info:",Pid)]),
    do_write(Fd,Time,L,Info,Args);

write_event(Fd, {Time, {error_report, _GL, {Pid, ErrorReportType, Rep}}}) ->
    [L] = io_lib:format("~ts",[add_node(ErrorReportType,Pid)]),
    do_write(Fd,Time,L,Rep,[]);

write_event(Fd, {Time, {info_report, _GL, {Pid, std_info, Rep}}}) ->
    [L] = io_lib:format("~ts",[add_node("info_report:",Pid)]),
    do_write(Fd,Time,L,Rep,[]);

write_event(Fd, {Time, {info_msg, _GL, {Pid, Format, Args}}}) ->
    [L] = io_lib:format("~ts", [add_node("info_msg:",Pid)]),
    do_write(Fd, Time, L, Format, Args);

write_event(_, {_time,_e}) ->
    %%io:format("event_no_match:~p~n",[_e]),
    ok.

format_report(Rep) when is_list(Rep) ->
    case string_p(Rep) of
    true ->
        io_lib:format("~s~n",[Rep]);
    _ ->
        format_rep(Rep)
    end;
format_report(Rep) ->
    io_lib:format("~p~n",[Rep]).

format_rep([{Tag,Data}|Rep]) ->
    io_lib:format("    ~p: ~p~n",[Tag,Data]) ++ format_rep(Rep);


format_rep([Other|Rep]) ->
    io_lib:format("    ~p~n",[Other]) ++ format_rep(Rep);

format_rep(_) ->
    [].

add_node(X, Pid) when node(Pid) /= node() ->
    lists:concat([X,"** at node ",node(Pid)," **"]);
add_node(X, _) ->
    X.

string_p([]) ->
    false;
string_p(Term) ->
    string_p1(Term).

string_p1([H|T]) when is_integer(H), H >= $\s, H < 255 ->
    string_p1(T);
string_p1([$\n|T]) -> string_p1(T);
string_p1([$\r|T]) -> string_p1(T);
string_p1([$\t|T]) -> string_p1(T);
string_p1([$\v|T]) -> string_p1(T);
string_p1([$\b|T]) -> string_p1(T);
string_p1([$\f|T]) -> string_p1(T);
string_p1([$\e|T]) -> string_p1(T);
string_p1([H|T]) when is_list(H) ->
    case string_p1(H) of
    true -> string_p1(T);
    _    -> false
    end;
string_p1([]) -> true;
string_p1(_) ->  false.


%%生成日志文件名
make_log_file(LocalTime) ->
    {{_Year, Month, Day}, {Hour, _, _}} = LocalTime,
    io_lib:format("../logs/log_~p_~p_~p.log", [Month, Day, Hour]).

%% 日志记录函数2
%% errlog(F, A) ->
%%     {{Y, M, D},{H, I, S}} = erlang:localtime(),
%%     case get("errlog") of
%%         undefined ->
%%             LogPath = config:get_log_path(),
%%             File1 = LogPath ++  "/errlog_" ++ integer_to_list(Y) ++ "_" ++ integer_to_list(M) ++ "_"  ++ integer_to_list(D) ++ ".txt",
%%             {ok, Fl} = file:open(File1, [write, append]),
%%             put("errlog", Fl),
%%             F3 = Fl;
%%         F2 ->
%%             F3 = F2
%%     end,
%%     Format = list_to_binary("#error" ++ " ~s \r\n" ++ F ++ "\r\n~n"),
%%     Date = list_to_binary([integer_to_list(Y),"-", integer_to_list(M), "-", integer_to_list(D), " ", integer_to_list(H), ":", integer_to_list(I), ":", integer_to_list(S)]),
%%     io:format(F3, unicode:characters_to_list(Format), [Date] ++ A).  


        
