%%----------------------------------------------------
%% 敏感词过滤服务
%% 
%% @author qingxuan
%%----------------------------------------------------
-module(forbid_name_psr).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").

-record(state, {}).


%% ---------------------------------
init([]) ->
    %process_flag(trap_exit, true),
	FilterNames = forbid_word_data:name(),
    List = lists:sort(FilterNames),
    %List = ["123", "aaa", "ddb", "abc"],
    init_data(List),
    {ok, #state{}}.
 
handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({check, String, From}, State) ->
    try begin
        Reply = check(String),
        gen_server:reply(From, Reply)
    end catch A:B ->
        catch ?ERR("~w : ~w : ~w", [A,B,erlang:get_stacktrace()])
    end,
    {noreply, State};

handle_info(destroy, State) ->
    {stop, destroy, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% ---------------------------------
init_data([]) ->
    ok;
init_data([H|T]) ->
    split_bin(list_to_binary(H)),
    init_data(T).

split_bin(<<>>) ->
    ok;
split_bin(Bin) ->
    split_bin(Bin, <<>>).

split_bin(Bin, Acc) ->
    case get_char(Bin) of
        {Char, <<>>} ->
            NewAcc = <<Acc/binary, Char/binary>>,
            put(NewAcc, 'break'), %% TODO 有bug，如果前一个词包含后一个词时，只取用后一个词，前一个词有部分内存白白占用了
            ok;
        {Char, Tail} ->
            NewAcc = <<Acc/binary, Char/binary>>,
            case put(NewAcc, 'continue') of
                'break' -> %% 上一个词已存在
                    put(NewAcc, 'break'); %% 恢复break，并结束
                _ ->
                    split_bin(Tail, NewAcc)
            end
    end.

check(<<>>) ->
    false;
check(String) ->
    case matching(String) of
        true -> true;
        false ->
            {_Char, Rest} = get_char(String),
            check(Rest)
    end.

matching(String) ->
    matching(String, <<>>).

matching(<<>>, _Acc) -> 
    false;
matching(String, Acc) ->
    {Char, Rest} = get_char(String),
    Acc0 = <<Acc/binary, Char/binary>>,
    case get(Acc0) of
        'break' -> 
            true;
        'continue' ->
            matching(Rest, Acc0);
        _ ->
            false
    end.
    

%% 获取utf8字符
get_char(<<H:8, Rest/binary>>) when H =< 127 -> {<<H>>, Rest};  %% ASCII
get_char(<<H:8, B:1/binary, Rest/binary>>) when H >= 192, H =< 223 -> {<<H:8, B/binary>>, Rest};   %% 2位
get_char(<<H:8, B:2/binary, Rest/binary>>) when H >= 224, H =< 239 -> {<<H:8, B/binary>>, Rest};   %% 3位
get_char(<<H:8, B:3/binary, Rest/binary>>) when H >= 240, H =< 247 -> {<<H:8, B/binary>>, Rest};   %% 4位
get_char(<<H:8, B:4/binary, Rest/binary>>) when H >= 248, H =< 251 -> {<<H:8, B/binary>>, Rest};   %% 5位
get_char(<<H:8, B:5/binary, Rest/binary>>) when H >= 252, H =< 253 -> {<<H:8, B/binary>>, Rest};   %% 6位
get_char(<<H:8, Rest/binary>>) -> {<<H>>, Rest}.

