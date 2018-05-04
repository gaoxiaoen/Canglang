%%----------------------------------------------------
%% 敏感词过滤服务
%% 
%% @author qingxuan
%%----------------------------------------------------
-module(forbid_word_filter_psr).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([get_char/1]).

-include("common.hrl").

-record(state, {}).


%% ---------------------------------
init([]) ->
    %process_flag(trap_exit, true),
    % FilterTalk = data_filter:talk(),
	FilterTalk = forbid_word_data:talk(),
    List = lists:sort(FilterTalk),
    %List = ["123", "aaa", "ddb", "abc"],
    init_data(List),
    {ok, #state{}}.
 
handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({filter, String, From}, State) when is_binary(String) ->
    try begin
        Reply = replace(String),
        gen_server:reply(From, Reply)
    end catch A:B ->
        catch ?ERR("~w : ~w : ~w",[A,B,erlang:get_stacktrace()])
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

replace(String) ->
    replace_split(String, String, <<>>, <<>>).

replace_split(<<>>, _, _, NewString) ->
    NewString;
replace_split(RestString, <<>>, _Acc, NewString) ->
    {_, NewRestString} = get_char(RestString),
    replace_split(NewRestString, NewRestString, <<>>, NewString);
replace_split(RestString, ToCheckString, Acc, NewString) ->
    case get_char(ToCheckString) of
        {Char, <<>>} ->
            Acc0 = <<Acc/binary, Char/binary>>,
            %io:format("~p ~p\n", [Acc0, get(Acc0)]),
            case get(Acc0) of
                'break' -> 
                    <<NewString/binary, "*">>;
                _ -> %% 'undefined' or 'continue'
                    {Char0, NewRestString} = get_char(RestString),
                    replace_split(NewRestString, NewRestString, <<>>, <<NewString/binary, Char0/binary>>)
            end;
        {Char, Tail} ->
            Acc0 = <<Acc/binary, Char/binary>>,
            %io:format("~p ~p\n", [Acc0, get(Acc0)]),
            case get(Acc0) of
                'continue' -> 
                    replace_split(RestString, Tail, Acc0, <<NewString/binary>>);
                'break' ->
                    replace_split(Tail, Tail, <<>>, <<NewString/binary, "*">>);
                'undefined' ->
                    {Char0, NewRestString} = get_char(RestString),
                    replace_split(NewRestString, NewRestString, <<>>, <<NewString/binary, Char0/binary>>)
            end
    end.

%% 获取utf8字符
get_char(<<H:8, Rest/binary>>) when H =< 127 -> {<<H>>, Rest};  %% ASCII
get_char(<<H:8, B:1/binary, Rest/binary>>) when H >= 192, H =< 223 -> {<<H:8, B/binary>>, Rest};   %% 2位
get_char(<<H:8, B:2/binary, Rest/binary>>) when H >= 224, H =< 239 -> {<<H:8, B/binary>>, Rest};   %% 3位
get_char(<<H:8, B:3/binary, Rest/binary>>) when H >= 240, H =< 247 -> {<<H:8, B/binary>>, Rest};   %% 4位
get_char(<<H:8, B:4/binary, Rest/binary>>) when H >= 248, H =< 251 -> {<<H:8, B/binary>>, Rest};   %% 5位
get_char(<<H:8, B:5/binary, Rest/binary>>) when H >= 252, H =< 253 -> {<<H:8, B/binary>>, Rest};   %% 6位
get_char(<<H:8, Rest/binary>>) -> {<<H>>, Rest}.

