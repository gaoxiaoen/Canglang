%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2015 下午3:26
%%%-------------------------------------------------------------------
-module(util).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-compile(export_all).

%% --------------------------------------------------
%%                 列表工具函数
%% --------------------------------------------------
%% 在List中的每两个元素之间插入一个分隔符
implode(_S, []) ->
    [<<>>];
implode(S, L) when is_list(L) ->
    implode(S, L, []).
implode(_S, [H], NList) ->
    lists:reverse([thing_to_list(H) | NList]);
implode(S, [H | T], NList) ->
    L = [thing_to_list(H) | NList],
    implode(S, T, [S | L]).

%% 字符->列
explode(S, B) ->
    re:split(B, S, [{return, list}]).
explode(S, B, int) ->
    [list_to_integer(Str) || Str <- explode(S, B), length(Str) > 0].


%% record 转 list
%% @return 一个LIST 成员同 Record一样
record_to_list(Record) when erlang:is_tuple(Record) ->
    RecordList = erlang:tuple_to_list(Record),
    [_ | ListLeft] = RecordList,
    ListLeft;
record_to_list(_Record) ->
    [].

%% list 转 record
%% @param List 必须长度跟rocrod一样
%% @param RecordAtom record的名字,是一个原子
%% @return RecordAtom类型的RECORD
list_to_record(List, RecordAtom) ->
    RecordList = [RecordAtom | List],
    erlang:list_to_tuple(RecordList).

%%列表去重
list_filter_repeat(List) ->
    lists:foldl(fun(Id, List1) ->
        case lists:member(Id, List1) of
            true -> List1;
            false -> List1 ++ [Id]
        end
                end, [], List).
%%列表去异
list_filter_dif(List) ->
    lists:foldl(fun(Id, List1) ->
        case lists:member(Id, List1) of
            false -> List1;
            true -> List1 ++ [Id]
        end
                end, [], List).


%% 扩展版lists:min/1
%% @param: (List, N), List为元组列表，N为元组中第N个元素
min_ex([H | T], N) -> min_ex(T, H, N).

min_ex([H | T], Min, N) when element(N, H) < element(N, Min) -> min_ex(T, H, N);
min_ex([_ | T], Min, N) -> min_ex(T, Min, N);
min_ex([], Min, _) -> Min.

%% 扩展版lists:min/1
%% @param: (List, N), List为元组列表，N为元组中第N个元素
max_ex([H | T], N) -> max_ex(T, H, N).

max_ex([H | T], Min, N) when element(N, H) > element(N, Min) -> max_ex(T, H, N);
max_ex([_ | T], Min, N) -> max_ex(T, Min, N);
max_ex([], Min, _) -> Min.


%%合并keyval
merge_kv(List) ->
    F = fun({Key, Val}, L) ->
        case lists:keytake(Key, 1, L) of
            false -> [{Key, Val} | L];
            {value, {_, Val1}, T} ->
                [{Key, Val + Val1} | T]
        end
        end,
    lists:foldl(F, [], List).

%%获取两个列表的公共部分
list_the_same_path(List1, List2) ->
    F = fun(Id) ->
        lists:member(Id, List2)
        end,
    lists:filter(F, List1).

%%去重复
list_unique(List) ->
    F = fun(Item, L) ->
        case lists:member(Item, L) of
            true ->
                L;
            false ->
                [Item | L]
        end
        end,
    lists:foldl(F, [], List).


%%随机从集合中选出指定个数的元素length(List) >= Num
%%[1,2,3,4,5,6,7,8,9]中选出三个不同的数字[1,2,4]
get_random_list(List, Num) ->
    ListSize = length(List),
    if ListSize =< Num -> List;
        true ->
            F = fun(N, List1) ->
                Random = rand(1, (ListSize - N + 1)),
                Elem = lists:nth(Random, List1),
                List2 = lists:delete(Elem, List1),
                List2
                end,
            Result = lists:foldl(F, List, lists:seq(1, Num)),
            List -- Result
    end.

%% 随机打乱list元素顺序
list_shuffle(L) ->
    Len = length(L),
    List1 = [{rand(1, Len + 10000), X} || X <- L],
    List2 = lists:sort(List1),
    [E || {_, E} <- List2].

%% 查找ListOfList中某个字段值为Key的结果
%% @spec keyfind(Key, N, ListList) -> false | Value
keyfind(_, _, []) ->
    false;
keyfind(Key, N, List) ->
    [List1 | NewList] = List,
    case lists:nth(N, List1) of
        Key ->
            List1;
        _ ->
            keyfind(Key, N, NewList)
    end.

%% 扩展的foreach函数
foreach_ex(_Fun, [], _Arg) ->
    void;
foreach_ex(Fun, [H | T], Arg) ->
    Fun(H, Arg),
    foreach_ex(Fun, T, Arg).

%% 扩展的map函数
map_ex(_Fun, [], _Arg) ->
    [];
map_ex(Fun, [H | T], Arg) ->
    [Fun(H, Arg) | map_ex(Fun, T, Arg)].

%% 根据lists的元素值获得下标
get_list_elem_index(Elem, List) ->
    get_lists_elem_index_helper(List, Elem, 0).
get_lists_elem_index_helper([], _Elem, _Index) ->
    0;
get_lists_elem_index_helper([H | T], Elem, Index) ->
    if H =:= Elem ->
        Index + 1;
        true ->
            get_lists_elem_index_helper(T, Elem, Index + 1)
    end.

%% 增加lists相应元素的值并获得新lists
replace_list_elem(Index, NewElem, List) ->
    replace_list_elem_helper(List, Index, NewElem, 1, []).
replace_list_elem_helper([], _Index, _NewElem, _CurIndex, NewList) ->
    lists:reverse(NewList);
replace_list_elem_helper([H | T], Index, NewElem, CurIndex, NewList) ->
    if Index =:= CurIndex ->
        replace_list_elem_helper(T, Index, NewElem, CurIndex + 1, [NewElem | NewList]);
        true ->
            replace_list_elem_helper(T, Index, NewElem, CurIndex + 1, [H | NewList])
    end.

%% 将record转换成key-val列表
record_to_proplist(Record, Fields) ->
    record_to_proplist(Record, Fields, '__record').

record_to_proplist(Record, Fields, TypeKey)
    when tuple_size(Record) - 1 =:= length(Fields) ->
    lists:zip([TypeKey | Fields], tuple_to_list(Record)).

%%dict获取列表
dict_to_list([]) ->
    [];
dict_to_list(Dict) ->
    get_list(dict:to_list(Dict), []).

get_list([], L) ->
    L;
get_list([{_Key, List} | T], L) ->
    get_list(T, [List | L]).

%% for循环
for(Max, Max, F) ->
    F(Max);
for(I, Max, F) ->
    F(I),
    for(I + 1, Max, F).

%% 带返回状态的for循环
%% @return {ok, State}
for(Max, Min, _F, State) when Min < Max -> {ok, State};
for(Max, Max, F, State) -> F(Max, State);
for(I, Max, F, State) -> {ok, NewState} = F(I, State), for(I + 1, Max, F, NewState).


%% List = [integer()]
%% 在list中,按照概率抽取出第N项
%% 例 [1,2,3],有1/(2+3+1)的概率返回1，2/(2+3+1)的概率返回2，3/(2+3+1)的概率返回3
probability_list_nth(List) ->
    Fun1 = fun(I, {CurrntNum, SumList}) ->
        NewCurrntNum = CurrntNum + I,
        {NewCurrntNum, [NewCurrntNum | SumList]}
           end,
    {Sum, NewList} = lists:foldl(Fun1, {0, []}, List),
    RandValue = util:rand(1, Sum),
    probability_list_nth1(1, RandValue, lists:reverse(NewList)).

probability_list_nth1(Nth, RandValue, [H | _List]) when RandValue =< H ->
    Nth;
probability_list_nth1(Nth, RandValue, [_H | List]) ->
    probability_list_nth1(Nth + 1, RandValue, List).

%% List = [{...},{...}]
get_weight_item(WeightNth, List) ->
    ProbList = [erlang:element(WeightNth, Tuple) || Tuple <- List],
    Nth = probability_list_nth(ProbList),
    lists:nth(Nth, List).


%% 从一个list中随机取出一项
%% null | term()
list_rand([]) -> null;
list_rand([I]) -> I;
list_rand(List) ->
    Len = length(List),
    Index = rand(1, Len),
    get_term_from_list(List, Index).
get_term_from_list(List, 1) ->
    [Term | _R] = List,
    Term;
get_term_from_list(List, Index) ->
    [_H | R] = List,
    get_term_from_list(R, Index - 1).


%% @doc lists 的每一项执行函数，ok则继续
list_handle(F, Data, [H | T]) ->
    case F(H, Data) of
        {ok, Data2} ->
            list_handle(F, Data2, T);
        Error ->
            Error
    end;
list_handle(_F, Data, []) ->
    {ok, Data}.

list_handle2(F, [H | T]) ->
    case F(H) of
        ok ->
            list_handle2(F, T);
        Error ->
            Error
    end;
list_handle2(_F, []) ->
    ok.

%%处理物品
list_handle_goods(_F, Data, [], InfoList) ->
    {ok, Data, InfoList};

list_handle_goods(F, Data, [H | T], InfoList) ->
    case F(H, Data) of
        {ok, Data2, Info} ->
            list_handle_goods(F, Data2, T, [Info | InfoList]);
        Error ->
            Error
    end.

%%处理物品，没有物品累加
list_handle_goods(_F, Data, []) ->
    {ok, Data};
list_handle_goods(F, Data, [H | T]) ->
    case F(H, Data) of
        {ok, Data2} ->
            list_handle_goods(F, Data2, T);
        Error ->
            Error
    end.

%% @doc get random list
list_random(List) ->
    case List of
        [] ->
            {};
        _ ->
            RS = lists:nth(random:uniform(length(List)), List),
            ListTail = lists:delete(RS, List),
            {RS, ListTail}
    end.

%% @doc get a random integer between Min and Max
random(Min, Max) ->
    Min2 = Min - 1,
    random:uniform(Max - Min2) + Min2.

%% 合并列表
combine_lists(L1, L2) ->
    Rtn =
        lists:foldl(
            fun(T, Acc) ->
                case lists:member(T, Acc) of
                    true ->
                        Acc;
                    false ->
                        [T | Acc]
                end
            end, lists:reverse(L1), L2),
    lists:reverse(Rtn).

%%删除list中的第N个元素
delete_list_by_index(List, N) ->
    case N > length(List) orelse N =< 0 of
        true ->
            List;
        false ->
            {List1, List2} = lists:split(N - 1, List),
            [_ | List3] = List2,
            List1 ++ List3
    end.

%%删除列表的所有目标元素
list_delete_target(List, Target) ->
    list_delete_action(List, Target, []).
list_delete_action([], _Target, L2) ->
    L2;
list_delete_action([Target | L], Target, L2) ->
    list_delete_action(L, Target, L2);
list_delete_action([Other | L], Target, L2) ->
    list_delete_action(L, Target, [Other | L2]).


%%列表删除指定的所有目标列表
list_delete([], List) -> List;
list_delete([Target | T], List) ->
    NewList = list_delete_target(List, Target),
    list_delete(T, NewList).


%% -----------------------------------------------------------
%%                  时间相关工具函数
%% ---------------------------------------------------------
%% 取得当前的unix时间戳（秒）
unixtime() ->
    case config:is_debug() of
        true ->
            case config:is_center_node() of
                false ->
                    %%--------------gm 增加时间，方便活动测试-------
                    AtTime = get(at_time),
                    AtTime1 = ?IF_ELSE(AtTime == undefined, 0, AtTime * ?ONE_DAY_SECONDS),
                    {M, S, _} = erlang:timestamp(),
                    M * 1000000 + S + AtTime1;
                true ->
                    {M, S, _} = erlang:timestamp(),
                    Now = M * 1000000 + S,
                    AtTime =
                        case get(at_time_cache) of
                            undefined ->
                                Cache = cache:get(at_time),
                                put(at_time_cache, {Cache, Now}),
                                Cache;
                            {CacheTime, LastTime} ->
                                if Now - LastTime > 10 ->
                                    Cache = cache:get(at_time),
                                    put(at_time_cache, {Cache, Now}),
                                    Cache;
                                    true ->
                                        CacheTime
                                end
                        end,
                    AtTime1 = ?IF_ELSE(AtTime == [], 0, AtTime * ?ONE_DAY_SECONDS),
                    Now + AtTime1
            end;
        _ ->
            dyc_cross_platform:system_time() div 1000000000
    end.

sync_at_time(Day) ->
    cache:set(at_time, Day).

%% 取得某个时间点的unix时间戳
% LocalTime = {{Y,M,D},{H,M,S}}
unixtime(LocalTime) ->
    localtime2unixtime(LocalTime).

%% 取得当天零点的unix时间戳
unixdate() ->
    case config:is_debug() of
        true ->
            unixdate(unixtime());
        _ ->
            Now = erlang:timestamp(),
            {_, Time} = calendar:now_to_local_time(Now),
            Ds = calendar:time_to_seconds(Time),
            {M, S, _} = Now,
            M * 1000000 + S - Ds
    end.

unixdate(UnixTime) ->
    Now = unixtime_to_now(UnixTime),
    {_, Time} = calendar:now_to_local_time(Now),
    Ds = calendar:time_to_seconds(Time),
    {M, S, _} = Now,
    M * 1000000 + S - Ds.


%% 取得某个时间点的unix时间戳
% LocalTime = {{Y,M,D},{H,M,S}}
localtime2unixtime(LocalTime) ->
    UniversalTime = erlang:localtime_to_universaltime(LocalTime),
    S1 = calendar:datetime_to_gregorian_seconds(UniversalTime),
    S2 = ?DIFF_SECONDS_0000_1900,
    S1 - S2.

unixtime_to_now(Time) ->
    M = Time div 1000000,
    S = Time rem 1000000,
    {M, S, 0}.

diff_day(UnixTime) ->
    {Date1, _} = calendar:now_to_local_time(unixtime_to_now(UnixTime)),
    {Date2, _} = calendar:local_time(),
    calendar:date_to_gregorian_days(Date2) - calendar:date_to_gregorian_days(Date1).

longunixtime() ->
    dyc_cross_platform:system_time() div 1000000.

%% 今天是星期几
get_day_of_week() ->
    Seconds = unixtime(),
    {{Year, Month, Day}, _Time} = seconds_to_localtime(Seconds),
    calendar:day_of_the_week(Year, Month, Day).
get_day_of_week(Seconds) ->
    {{Year, Month, Day}, _Time} = seconds_to_localtime(Seconds),
    calendar:day_of_the_week(Year, Month, Day).

%% 根据1970年以来的秒数获得日期
seconds_to_localtime(Seconds) ->
    DateTime = calendar:gregorian_seconds_to_datetime(Seconds + ?DIFF_SECONDS_0000_1900),
    calendar:universal_time_to_local_time(DateTime).

%% 判断是否同一天
is_same_date(Seconds1, Seconds2) ->
    {{Year1, Month1, Day1}, _Time1} = seconds_to_localtime(Seconds1),
    {{Year2, Month2, Day2}, _Time2} = seconds_to_localtime(Seconds2),
    if ((Year1 /= Year2) or (Month1 /= Month2) or (Day1 /= Day2)) -> false;
        true -> true
    end.

%% 判断是否同一星期
is_same_week(Seconds1, Seconds2) ->
    {{Year1, Month1, Day1}, Time1} = seconds_to_localtime(Seconds1),
    % 星期几
    Week1 = calendar:day_of_the_week(Year1, Month1, Day1),
    % 从午夜到现在的秒数
    Diff1 = calendar:time_to_seconds(Time1),
    Monday = Seconds1 - Diff1 - (Week1 - 1) * ?ONE_DAY_SECONDS,
    Sunday = Seconds1 + (?ONE_DAY_SECONDS - Diff1) + (7 - Week1) * ?ONE_DAY_SECONDS,
    if ((Seconds2 >= Monday) and (Seconds2 < Sunday)) -> true;
        true -> false
    end.

%% 获取当天0点和第二天0点
get_midnight_seconds(Seconds) ->
    {{_Year, _Month, _Day}, Time} = seconds_to_localtime(Seconds),
    % 从午夜到现在的秒数
    Diff = calendar:time_to_seconds(Time),
    % 获取当天0点
    Today = Seconds - Diff,
    % 获取第二天0点
    NextDay = Seconds + (?ONE_DAY_SECONDS - Diff),
    {Today, NextDay}.

%% 计算相差的天数
get_diff_days(Seconds1, Seconds2) ->
    {{Year1, Month1, Day1}, _} = seconds_to_localtime(Seconds1),
    {{Year2, Month2, Day2}, _} = seconds_to_localtime(Seconds2),
    Days1 = calendar:date_to_gregorian_days(Year1, Month1, Day1),
    Days2 = calendar:date_to_gregorian_days(Year2, Month2, Day2),
    DiffDays = abs(Days2 - Days1),
    DiffDays.

%% 获取当天0点到现在的秒数
get_seconds_from_midnight() ->
    NowTime = unixtime(),
    get_seconds_from_midnight(NowTime).
get_seconds_from_midnight(Seconds) ->
    {{_Year, _Month, _Day}, Time} = seconds_to_localtime(Seconds),
    calendar:time_to_seconds(Time).

%% 获取当天0点
get_today_midnight() ->
    NowTime = unixtime(),
    {{_Year, _Month, _Day}, Time} = seconds_to_localtime(NowTime),
    % 从午夜到现在的秒数
    Diff = calendar:time_to_seconds(Time),
    % 获取当天0点
    NowTime - Diff.

get_today_midnight(Seconds) ->
    {{_Year, _Month, _Day}, Time} = seconds_to_localtime(Seconds),
    % 从午夜到现在的秒数
    Diff = calendar:time_to_seconds(Time),
    % 获取当天0点
    Seconds - Diff.

%% 时间戳（秒级）转为易辨别时间字符串
%% 例如： 1291014369 -> "2010年11月29日15时6分"
unixtime_to_time_string(Timestamp) ->
    {{Year, Month, Day}, {Hour, Minute, _Second}} = calendar:now_to_local_time({Timestamp div 1000000, Timestamp rem 1000000, 0}),
    ?T(lists:concat([Year, "年", Month, "月", Day, "日", Hour, "时", Minute, "分"])).

%%格式化时间戳 “2010-2-23”
unixtime_to_time_string2(Timestamp) ->
    {{Year, Month, Day}, {_Hour, _Minute, _Second}} = calendar:now_to_local_time({Timestamp div 1000000, Timestamp rem 1000000, 0}),
    lists:concat([Year, "-", Month, "-", Day]).

%%格式化时间戳 “2010-2-23 12:18”
unixtime_to_time_string3(Timestamp) ->
    {{Year, Month, Day}, {Hour, Minute, _Second}} = calendar:now_to_local_time({Timestamp div 1000000, Timestamp rem 1000000, 0}),
    lists:concat([Year, "-", Month, "-", Day, " ", Hour, ":", Minute]).

%%格式化时间戳 “12:18-23-2-2010”
unixtime_to_time_string4(Timestamp) ->
    {{Year, Month, Day}, {Hour, Minute, _Second}} = calendar:now_to_local_time({Timestamp div 1000000, Timestamp rem 1000000, 0}),
    lists:concat([Hour, ":", Minute, "-", Day, "-", Month, "-", Year]).

%% 查询一周时间范围
get_week_time() ->
    Timestamp = unixtime(),
    get_week_time(Timestamp).

get_week_time(Timestamp) ->
    {MegaSecs, Secs, MicroSecs} = unixtime_to_now(Timestamp),
    {Date, Time} = calendar:now_to_local_time({MegaSecs, Secs, MicroSecs}),
    TodaySecs = calendar:time_to_seconds(Time),
    WeekDay = calendar:day_of_the_week(Date),
    Monday = Timestamp - ?ONE_DAY_SECONDS * (WeekDay - 1) - TodaySecs,
    NextMonday = Monday + 7 * ?ONE_DAY_SECONDS,
    {Monday, NextMonday}.

get_last_day_string(Date) ->
    {LastDate, _} = get_last_day_local_time({Date, {0, 0, 0}}),
    get_date_string(LastDate).

get_last_day_local_time(LocalTime) ->
    NowTime = unixtime(LocalTime),
    LastDayNowTime = NowTime - ?ONE_DAY_SECONDS,
    LastDayNow = unixtime_to_now(LastDayNowTime),
    calendar:now_to_local_time(LastDayNow).

get_date_string(Date) ->
    {Y, M, D} = Date,
    io_lib:format("~p年~p月~p日", [Y, M, D]).

%%获取月份天数
get_month_days(Now) ->
    {{Year, Month, _Day}, _} = seconds_to_localtime(Now),
    calendar:last_day_of_the_month(Year, Month).

%%获取天数
get_days(Now) ->
    {{_Year, _Month, Day}, _} = seconds_to_localtime(Now),
    Day.

format_sec(Sec) ->
    Hour = Sec div ?ONE_HOUR_SECONDS,
    Sec1 = Sec - Hour * ?ONE_HOUR_SECONDS,
    Min = Sec1 div 60,
    Sec2 = Sec1 - Min * 60,
    io_lib:format("~p小时~p分~p秒", [Hour, Min, Sec2]).

%%获取上一个指定时间点的时间
get_last_time(WeekDay, Hour, Min) ->
    Now = util:unixtime(),
    Date = util:unixdate(Now),
    NowWeekDay = util:get_day_of_week(Now),
    TodayHourTime = Date + Hour * ?ONE_HOUR_SECONDS + Min * 60,
    case NowWeekDay == WeekDay of
        true ->
            case Now > TodayHourTime of
                true -> TodayHourTime;
                false ->
                    TodayHourTime - 7 * ?ONE_DAY_SECONDS
            end;
        false ->
            case NowWeekDay > WeekDay of
                true ->
                    TodayHourTime - (NowWeekDay - WeekDay) * ?ONE_DAY_SECONDS;
                false ->
                    TodayHourTime - (7 - (WeekDay - NowWeekDay)) * ?ONE_DAY_SECONDS
            end
    end.


%% --------------------------------------------
%%             转换工具函数
%% --------------------------------------------
%% 转换成HEX格式的md5
md5(S) ->
    lists:flatten([io_lib:format("~2.16.0b", [N]) || N <- binary_to_list(erlang:md5(S))]).

md5_2(S) ->
    Md5_bin = erlang:md5(S),
    Md5_list = binary_to_list(Md5_bin),
    lists:flatten(list_to_hex(Md5_list)).
list_to_hex(L) ->
    lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 256 ->
    [hex(N div 16), hex(N rem 16)].
hex(N) when N < 10 ->
    $0 + N;
hex(N) when N >= 10, N < 16 ->
    $a + (N - 10).
%%urlencode
urlencode([H | T]) ->
    if
        H >= $a, $z >= H ->
            [H | urlencode(T)];
        H >= $A, $Z >= H ->
            [H | urlencode(T)];
        H >= $0, $9 >= H ->
            [H | urlencode(T)];
        H == $_; H == $.; H == $-; H == $/; H == $: -> %
            [H | urlencode(T)];
        true ->
            case integer_to_hex(H) of
                [X, Y] ->
                    [$%, X, Y | urlencode(T)];
                [X] ->
                    [$%, $0, X | urlencode(T)]
            end
    end;
urlencode([]) ->
    [].
integer_to_hex(I) ->
    case catch erlang:integer_to_list(I, 16) of
        {'EXIT', _} ->
            old_integer_to_hex(I);
        Int ->
            Int
    end.
old_integer_to_hex(I) when I < 10 ->
    integer_to_list(I);
old_integer_to_hex(I) when I < 16 ->
    [I - 10 + $A];
old_integer_to_hex(I) when I >= 16 ->
    N = trunc(I / 16),
    old_integer_to_hex(N) ++ old_integer_to_hex(I rem 16).


%% @doc Decode a URL encoded binary.
%% @equiv urldecode(Bin, crash)
urldecode(List) when is_list(List) ->
    urldecode(list_to_binary(List));

urldecode(Bin) when is_binary(Bin) ->
    urldecode(Bin, <<>>, crash).

urldecode(<<$%, H, L, Rest/binary>>, Acc, OnError) ->
    G = unhex(H),
    M = unhex(L),
    if G =:= error; M =:= error ->
        case OnError of skip -> ok; crash -> erlang:error(badarg) end,
        urldecode(<<H, L, Rest/binary>>, <<Acc/binary, $%>>, OnError);
        true ->
            urldecode(Rest, <<Acc/binary, (G bsl 4 bor M)>>, OnError)
    end;
urldecode(<<$%, Rest/binary>>, Acc, OnError) ->
    case OnError of skip -> ok; crash -> erlang:error(badarg) end,
    urldecode(Rest, <<Acc/binary, $%>>, OnError);
urldecode(<<$+, Rest/binary>>, Acc, OnError) ->
    urldecode(Rest, <<Acc/binary, $ >>, OnError);
urldecode(<<C, Rest/binary>>, Acc, OnError) ->
    urldecode(Rest, <<Acc/binary, C>>, OnError);
urldecode(<<>>, Acc, _OnError) ->
    Acc.

-spec unhex(byte()) -> byte() | error.
unhex(C) when C >= $0, C =< $9 -> C - $0;
unhex(C) when C >= $A, C =< $F -> C - $A + 10;
unhex(C) when C >= $a, C =< $f -> C - $a + 10;
unhex(_) -> error.

%% term序列化，term转换为string格式，e.g., [{a},1] => "[{a},1]"
term_to_string(Term) ->
    lists:flatten(io_lib:format("~p", [Term])).
%%     binary_to_list(list_to_binary(io_lib:format("~w", [Term]))).

%% term序列化，term转换为bitstring格式，e.g., [{a},1] => <<"[{a},1]">>
term_to_bitstring(Term) ->
    erlang:list_to_bitstring(io_lib:format("~w", [Term])).

%% term反序列化，string转换为term，e.g., "[{a},1]"  => [{a},1]
string_to_term(String) ->
    case erl_scan:string(String ++ ".") of
        {ok, Tokens, _} ->
            case erl_parse:parse_term(Tokens) of
                {ok, Term} -> Term;
                _Err -> []
            end;
        _Error ->
            []
    end.

%% term反序列化，bitstring转换为term，e.g., <<"[{a},1]">>  => [{a},1]
bitstring_to_term(undefined) -> [];
bitstring_to_term(BitString) ->
    case binary_to_list(BitString) of
        "undefined" -> [];
        undefined -> [];
        List -> string_to_term(List)
    end.


%% 将列里的不同类型转行成字节型，如 [<<"字节">>, 123, asdasd, "asdasd"] 输出 <<"字节123asdasdasdasd">>
all_to_binary(List) -> all_to_binary(List, []).

all_to_binary([], Result) -> list_to_binary(Result);
all_to_binary([P | T], Result) when is_list(P) -> all_to_binary(T, lists:append(Result, P));
all_to_binary([P | T], Result) when is_integer(P) -> all_to_binary(T, lists:append(Result, integer_to_list(P)));
all_to_binary([P | T], Result) when is_binary(P) -> all_to_binary(T, lists:append(Result, binary_to_list(P)));
all_to_binary([P | T], Result) when is_float(P) -> all_to_binary(T, lists:append(Result, float_to_list(P)));
all_to_binary([P | T], Result) when is_atom(P) -> all_to_binary(T, lists:append(Result, atom_to_list(P))).

%%转换成list
thing_to_list(X) when is_integer(X) -> integer_to_list(X);
thing_to_list(X) when is_float(X) -> float_to_list(X);
thing_to_list(X) when is_atom(X) -> atom_to_list(X);
thing_to_list(X) when is_binary(X) -> binary_to_list(X);
thing_to_list(X) when is_list(X) -> X.

%% @doc convert other type to list
to_list(Msg) when is_list(Msg) ->
    Msg;
to_list(Msg) when is_atom(Msg) ->
    atom_to_list(Msg);
to_list(Msg) when is_binary(Msg) ->
    binary_to_list(Msg);
to_list(Msg) when is_integer(Msg) ->
    integer_to_list(Msg);
to_list(Msg) when is_tuple(Msg) ->
    tuple_to_list(Msg);
to_list(Msg) when is_float(Msg) ->
    f2s(Msg);
to_list(_) ->
    throw(other_value).

%% @doc convert other type to atom
to_atom(Msg) when is_atom(Msg) ->
    Msg;
to_atom(Msg) when is_binary(Msg) ->
    list_to_atom2(binary_to_list(Msg));
to_atom(Msg) when is_list(Msg) ->
    list_to_atom2(Msg);
to_atom(_) ->
    throw(other_value).

%% @doc convert other type to binary
to_binary(Msg) when is_binary(Msg) ->
    Msg;
to_binary(Msg) when is_atom(Msg) ->
    list_to_binary(atom_to_list(Msg));
%%atom_to_binary(Msg, utf8);
to_binary(Msg) when is_list(Msg) ->
    list_to_binary(Msg);
to_binary(Msg) when is_integer(Msg) ->
    list_to_binary(integer_to_list(Msg));
to_binary(Msg) when is_float(Msg) ->
    list_to_binary(f2s(Msg));
to_binary(_Msg) ->
    throw(other_value).

%% @doc convert other type to float
to_float(Msg) ->
    Msg2 = to_list(Msg),
    list_to_float(Msg2).

%% @doc convert other type to integer
-spec to_integer(Msg :: any()) -> integer().
to_integer(Msg) when is_integer(Msg) ->
    Msg;
to_integer(Msg) when is_binary(Msg) ->
    Msg2 = binary_to_list(Msg),
    list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) ->
    list_to_integer(Msg);
to_integer(Msg) when is_float(Msg) ->
    round(Msg);
to_integer(Msg) when is_atom(Msg) ->
    list_to_integer(atom_to_list(Msg));
to_integer(_Msg) ->
    throw(other_value).

%% @doc convert other type to bool
to_bool(D) when is_integer(D) ->
    D =/= 0;
to_bool(D) when is_list(D) ->
    length(D) =/= 0;
to_bool(D) when is_binary(D) ->
    to_bool(binary_to_list(D));
to_bool(D) when is_boolean(D) ->
    D;
to_bool(_D) ->
    throw(other_value).

%% @doc convert other type to tuple
to_tuple(T) when is_tuple(T) -> T;
to_tuple(T) -> {T}.

%% @doc get data type {0=integer,1=list,2=atom,3=binary}
get_type(DataValue, DataType) ->
    case DataType of
        0 ->
            DataValue2 = binary_to_list(DataValue),
            list_to_integer(DataValue2);
        1 ->
            binary_to_list(DataValue);
        2 ->
            DataValue2 = binary_to_list(DataValue),
            list_to_atom(DataValue2);
        3 ->
            DataValue
    end.

%% @spec is_string(List)-> yes|no|unicode
is_string([]) -> yes;
is_string(List) -> is_string(List, non_unicode).

is_string([C | Rest], non_unicode) when C >= 0, C =< 255 -> is_string(Rest, non_unicode);
is_string([C | Rest], _) when C =< 65000 -> is_string(Rest, unicode);
is_string([], non_unicode) -> yes;
is_string([], unicode) -> unicode;
is_string(_, _) -> no.

list_to_atom2(List) when is_list(List) ->
    case catch (list_to_existing_atom(List)) of
        {'EXIT', _} -> erlang:list_to_atom(List);
        Atom when is_atom(Atom) -> Atom
    end.

%% @doc convert float to string,  f2s(1.5678) -> 1.57
f2s(N) when is_integer(N) ->
    integer_to_list(N) ++ ".00";
f2s(F) when is_float(F) ->
    [A] = io_lib:format("~.2f", [F]),
    A.

%% 截取utf8字符串
substr_utf8(Utf8EncodedString, Length) ->
    substr_utf8(Utf8EncodedString, 1, Length).
substr_utf8(Utf8EncodedString, Start, Length) ->
    ByteLength = 2 * Length,
    Ucs = xmerl_ucs:from_utf8(Utf8EncodedString),
    Utf16Bytes = xmerl_ucs:to_utf16be(Ucs),
    SubStringUtf16 = lists:sublist(Utf16Bytes, Start, ByteLength),
    Ucs1 = xmerl_ucs:from_utf16be(SubStringUtf16),
    xmerl_ucs:to_utf8(Ucs1).


%% -----------------------------------------------------------------
%% 确保字符串类型为二进制
%% -----------------------------------------------------------------
make_sure_binary(String) when is_binary(String) ->
    String;
make_sure_binary(String) when is_list(String) ->
    list_to_binary(String);
make_sure_binary(String) ->
    ?ERR("make_sure_binary: Error string=[~w]", [String]),
    String.

%% -----------------------------------------------------------------
%% 确保字符串类型为列表
%% -----------------------------------------------------------------
make_sure_list(String) when is_list(String) ->
    String;
make_sure_list(String) when is_binary(String) ->
    binary_to_list(String);
make_sure_list(String) when is_integer(String) ->
    integer_to_list(String);
make_sure_list(String) ->
    ?ERR("make_sure_list: Error string=[~w]", [String]),
    String.

%% 转换为list
object_to_list(Object) when is_binary(Object) ->
    binary_to_list(Object);
object_to_list(Object) when is_list(Object) ->
    Object;
object_to_list(_) ->
    [].

to_term(BinString) ->
    case bitstring_to_term(BinString) of
        undefined -> [];
        Term -> Term
    end.

boolean_to_integer(Boolean) ->
    case Boolean of
        true -> 1;
        false -> 0
    end.

integer_to_boolean(Integer) ->
    case Integer of
        0 -> false;
        _ -> true
    end.

%%转换副本id特定使用
convert_copy_id(Copy) ->
%%     if
%%         is_pid(Copy) ->
%%             pid_to_list(Copy);
%%         true ->
%%             Copy
%%     end.
    Copy.
%% --------------------------------------------------------
%%                      工具类函数
%% -------------------------------------------------------
%% 产生一个介于Min到Max之间的随机整数
rand(Same, Same) -> Same;
rand(Min, Max) when Max < Min -> 0;
rand(Min, Max) ->
    Key = "rand_seed",
    %% 以保证不同进程都可取得不同的种子
    case get(Key) of
        undefined ->
            seed(),
            put(Key, 1);
        N when N < 10 ->
            put(Key, N + 1);
        _ ->
            seed(),
            put(Key, 1)
    end,
    M = Min - 1,
    if
        Max - M =< 0 ->
            0;
        true ->
            random:uniform(Max - M) + M
    end.

%% 向上取整
ceil(N) ->
    T = trunc(N),
    case N == T of
        true -> T;
        false -> 1 + T
    end.

%% 向下取整
floor(X) ->
    T = trunc(X),
    case X < T of
        true -> T - 1;
        _ -> T
    end.

sleep(T) ->
    receive
    after T -> ok
    end.

sleep(T, F) ->
    receive
    after T -> F()
    end.

do_try_catch(Arg, Fun) ->
    try Fun(Arg) of
        Res -> Res
    catch
        throw:Res -> Res
    end.

%% @doc 掷骰子
random_dice(Face, Times) ->
    if
        Times == 1 ->
            random(1, Face);
        true ->
            lists:sum(for(1, Times, fun(_) -> random(1, Face) end))
    end.

%% @doc 机率
odds(Numerator, Denominator) ->
    seed(),
    Odds = random:uniform(Denominator),
    if
        Odds =< Numerator ->
            true;
        true ->
            false
    end.
odds_list(List) ->
    Sum = odds_list_sum(List),
    odds_list(List, Sum).
odds_list([{Id, Odds} | List], Sum) ->
    case odds(Odds, Sum) of
        true ->
            Id;
        false ->
            odds_list(List, Sum - Odds)
    end.
odds_list_sum(List) ->
    {_List1, List2} = lists:unzip(List),
    lists:sum(List2).


%%获取客户端ip
get_ip(Socket) ->
    case inet:peername(Socket) of
        {ok, {Ip, _Port}} -> Ip;
        {error, _Reason} -> {0, 0, 0, 0}
    end.

%% @doc get IP address string from Socket
ip(Socket) ->
    {ok, {IP, _Port}} = inet:peername(Socket),
    {Ip0, Ip1, Ip2, Ip3} = IP,
    list_to_binary(integer_to_list(Ip0) ++ "." ++ integer_to_list(Ip1) ++ "." ++ integer_to_list(Ip2) ++ "." ++ integer_to_list(Ip3)).

%% IP元组转字符
ip2bin({A, B, C, D}) ->
    [integer_to_list(A), ".", integer_to_list(B), ".", integer_to_list(C), ".", integer_to_list(D)].

%% 网络所在地
ip_location(Socket) ->
    Ip = get_ip(Socket),
    IpStr = ip_str(Ip),
    LookupAPI = "http://ip.taobao.com/service/getIpInfo.php?ip=",
    Query = lists:concat([LookupAPI, IpStr]),
    case catch httpc:request(get, {Query, []}, [{timeout, 2000}], []) of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, JSONlist}, _} ->
                    %%?ERR("JSONlist:~p~n",[JSONlist]),
                    case lists:keyfind("data", 1, JSONlist) of
                        {_, <<"ip info not found.">>} ->
                            <<>>;
                        {_, <<>>} ->
                            <<>>;
                        {_, Data} ->
                            case rfc4627:get_field(Data, "city") of
                                {ok, <<>>} ->
                                    case rfc4627:get_field(Data, "region") of
                                        {ok, <<>>} ->
                                            case rfc4627:get_field(Data, "country") of
                                                {ok, <<"韩国"/utf8>>} ->
                                                    <<"한국"/utf8>>;
                                                {ok, Country} ->
                                                    Country;
                                                _ ->
                                                    <<"未知领域"/utf8>>
                                            end;
                                        {ok, <<"台湾省"/utf8>>} ->
                                            <<"台灣"/utf8>>;
                                        {ok, Region} ->
                                            Region;
                                        _ ->
                                            <<>>
                                    end;
                                {ok, City} ->
                                    City;
                                _ ->
                                    <<>>
                            end;
                        _ ->
                            <<>>
                    end;
                _ ->
                    <<>>
            end;
        _ ->
            <<>>
    end.

%% 把ip转换成字符串
ip_str(IP) ->
    case IP of
        {A, B, C, D} ->
            lists:concat([A, ".", B, ".", C, ".", D]);
        {A, B, C, D, E, F, G, H} ->
            lists:concat([A, ":", B, ":", C, ":", D, ":", E, ":", F, ":", G, ":", H]);
        Str when is_list(Str) ->
            Str;
        _ ->
            []
    end.

%%写入文件
write(File, Data) ->
    case file:open(File, [append, raw]) of
        {ok, Fd} ->
            file:write(Fd, Data);
        _ ->
            skip
    end.

%%计数器
counter(Type) ->
    counter(Type, 1).
counter(Type, Inc) ->
    ets:update_counter(ets_counter, Type, Inc).

%% 字符加密
check_char_encrypt(Id, Time, TK) ->
    TICKET = "8YnELt8MmA4jVED8",
    Hex = md5(lists:concat([Time, Id, TICKET])),
%%    NowTime = unixtime(),
%%    Hex =:= TK andalso NowTime - Time < 86400.
    Hex =:= TK.

%% 插入字典
add_dict(Key, Obj, Dict) ->
    case dict:is_key(Key, Dict) of
        true ->
            Dict1 = dict:erase(Key, Dict),
            dict:append(Key, Obj, Dict1);
        false ->
            dict:append(Key, Obj, Dict)
    end.

%%删除字典
del_dict(Key, Dict) ->
    case dict:is_key(Key, Dict) of
        true ->
            dict:erase(Key, Dict);
        false ->
            Dict
    end.

%% --------------------------------------------------
%%                 过滤检测函数
%% --------------------------------------------------
filter_text_gm(Text) when is_bitstring(Text) ->
    Text;
filter_text_gm(Text) when is_list(Text) ->
    list_to_bitstring(Text).

%% 敏感词过滤
%% @param Text list() | bitstring()
%% @return bitstring() 过滤后的文本
filter_text(Text, Lv) when is_bitstring(Text) ->
    S = bitstring_to_list(Text),
    filter_text(S, Lv);
filter_text(Text, Lv) when is_list(Text) ->
    [Term] = io_lib:format("~ts", [Text]),
    mod_word:replace_sensitive_talk(Term, Lv).

%% 名字过滤
%% @param Text list() | bitstring()
%% @return bitstring() 过滤后的文本
filter_name(Text) when is_bitstring(Text) ->
    S = bitstring_to_list(Text),
    filter_name(S);
filter_name(Text) when is_list(Text) ->
    [Term] = io_lib:format("~ts", [Text]),
    mod_word:replace_sensitive_name(Term).

%% @spec text_banned_valid(Text) -> bool()
%% @doc 检查文本：是否含有英文半角符号等半角符号--- 防止sql注入
%% <div> true表示正常 false表示非法文本 </div>
text_valid(Text) when is_list(Text) ->
    text_valid(util:to_binary(Text));
text_valid(Text) when is_bitstring(Text) ->
    %% 反斜杠\的匹配，使用了双重转义，因为erlang里面\字符本身也需要转义
    %% [和]的匹配，也特殊处理了
    case re:run(Text, "[\;\^\,\.\"\'\:\+\=\!\?\<\>\/\*\|\~\`\@\#\$\%\(\)\{\}\\\-\\\[\\\]\\\\]", [{capture, none}, caseless, unicode]) of
        match -> false;
        nomatch -> true
    end;
text_valid(_) ->
    false.

%%简单过滤特殊字符
filter_spec(String) ->
    try
        re:replace(String, "[\ \;\"\'\:\+\=\<\>\/\*\|\~\`\@\#\$\%\(\)\{\}\\\-\\\[\\\]\\\\]", "", [global, {return, list}, caseless, unicode])
    catch
        _:_ ->
            ""
    end.

filter_spec_chat(String) ->
    try
        re:replace(String, "[\ \,\.\,\.\;\"\'\:\+\=\<\>\/\*\|\~\`\@\#\$\%\(\)\{\}\\\-\\\[\\\]\\\\]", "", [global, {return, list}, caseless, unicode])
    catch
        _:_ ->
            ""
    end.
%%过滤出utf8字符
filter_utf8(String) ->
    filter_spec(get_utf8_char(unicode:characters_to_list(String), [])).

get_utf8_char([], Utf8Chars) ->
    lists:reverse(Utf8Chars);
get_utf8_char([C | Rest], Utf8Chars) when C < 16#80 ->
    get_utf8_char(Rest, [C | Utf8Chars]);
get_utf8_char([C, C1 | Rest], Utf8Chars) when C < 16#E0 ->
    get_utf8_char(Rest, [C1, C | Utf8Chars]);
get_utf8_char([C, C1, C2 | Rest], Utf8Chars) when C < 16#F0 ->
    get_utf8_char(Rest, [C2, C1, C | Utf8Chars]);
get_utf8_char([C, _C1, _C2, _C3 | Rest], Utf8Chars) when C < 16#F8 -> %% 屏蔽4字节utf8
    get_utf8_char(Rest, Utf8Chars);
get_utf8_char([C, _C1, _C2, _C3, _C4 | Rest], Utf8Chars) when C < 16#FC -> %% 屏蔽5字节utf8
    get_utf8_char(Rest, Utf8Chars);
get_utf8_char([C, _C1, _C2, _C3, _C4, _C5 | Rest], Utf8Chars) when C < 16#FE -> %% 屏蔽6字节utf8
    get_utf8_char(Rest, Utf8Chars);
get_utf8_char([_C | Rest], Utf8Chars) ->
    get_utf8_char(Rest, Utf8Chars).

%% 聊天敏感词过滤
keyword_filter(Text) ->
    case version:get_check_words() of
        true ->
            if
                is_list(Text) ->
                    word:chat_word_in_filter_all(Text);
                true ->
                    []
            end;
        false ->
            []
    end.


%% 敏感词检测
%% @return true 存在关键词
%%          false 不存在关键词
%% @var Text：字符串
check_keyword(Text) ->
    case version:get_check_words() of
        true ->
            if
                is_list(Text) ->
                    word:word_in_filter_all(Text);
                true ->
                    true
            end;
        false ->
            false
    end.

%% 敏感词检测 基础
%% @return true 存在关键词
%%          false 不存在关键词
%% @var Text：字符串
check_keyword_base(Text) ->
    case version:get_check_words() of
        true ->
            if
                is_list(Text) ->
                    word:word_in_filter_base(Text);
                true ->
                    true
            end;
        false ->
            false
    end.


%% 长度合法性检查
check_length(Item, LenLimit) ->
    check_length(Item, 1, LenLimit).

check_length(Item, MinLen, MaxLen) ->
    case catch unicode:characters_to_list(Item) of
        {'EXIT', _Reason} ->
            false;
        UnicodeList ->
            Len = string_width(UnicodeList),
            Len =< MaxLen andalso Len >= MinLen
    end.

%% 字符宽度，1汉字=2单位长度，1数字字母=1单位长度
string_width(String) ->
    string_width(String, 0).
string_width([], Len) ->
    Len;
string_width([H | T], Len) ->
    case H > 255 of
        true ->
            string_width(T, Len + 2);
        false ->
            string_width(T, Len + 1)
    end.


%%字符数，1汉字=1数字字母=1单位长度
char_len(String) ->
    case catch unicode:characters_to_list(String) of
        {'EXIT', _Reason} ->
            0;
        CharList ->
            char_width(CharList)
    end.
%% 字符宽度，1汉字=1单位长度，1数字字母=1单位长度
char_width(String) ->
    char_width(String, 0).
char_width([], Len) ->
    Len;
char_width([H | T], Len) ->
    case H > 255 of
        true ->
            char_width(T, Len + 1);
        false ->
            char_width(T, Len + 1)
    end.

%% 过滤掉字符串中的特殊字符
filter_string(String, CharList) ->
    case is_list(String) of
        true ->
            filter_string_helper(String, CharList, []);
        false when is_binary(String) ->
            ResultString = filter_string_helper(binary_to_list(String), CharList, []),
            list_to_binary(ResultString);
        false ->
            ?ERR("filter_string: Error string=[~w]", [String]),
            String
    end.

filter_string_helper([], _CharList, ResultString) ->
    ResultString;
filter_string_helper([H | T], CharList, ResultString) ->
    case lists:member(H, CharList) of
        true -> filter_string_helper(T, CharList, ResultString);
        false -> filter_string_helper(T, CharList, ResultString ++ [H])
    end.

%% 字符长度
string_len(String) ->
    case catch unicode:characters_to_list(String) of
        {'EXIT', _Reason} ->
            0;
        CharList ->
            string_width(CharList)
    end.

%% @doc 组装 INSERT SQL 语句
make_insert_sql(Table, Proplists) ->
    {ColStr, ValStr} = trans_insert_sql_proplists(Proplists, "", ""),
    lists:concat(["INSERT INTO ", Table, " (", ColStr, ") VALUES (", ValStr, ")"]).
trans_insert_sql_proplists([], ColStr, ValStr) ->
    {string:strip(ColStr, right, $,), string:strip(ValStr, right, $,)};
trans_insert_sql_proplists([{Col, Val} | ValList], ColStr, ValStr) ->
    trans_insert_sql_proplists(ValList, ColStr ++ util:thing_to_list(Col) ++ ",", ValStr ++ util:thing_to_list(Val) ++ ",").


%%计算坐标距离
calc_coord_range(X, Y, X1, Y1) ->
    math:sqrt((math:pow(X - X1, 2) + math:pow(Y - Y1, 2))).

%%以x1 y1为中心 x2,y2的坐标相对方向
%%计算方向 1右 2下 3左 4上 5右上 6右下 7左下 8左上 0 重叠
get_direction(X1, Y1, X2, Y2) ->
    if
        X2 - X1 > 0 andalso Y2 == Y1 ->
            1;%%右
        X2 == X1 andalso Y2 - Y1 > 0 ->
            2;%%下
        X2 - X1 < 0 andalso Y2 == Y1 ->
            3;%%左
        X2 == X1 andalso Y2 - Y1 < 0 ->
            4;%%上
        X2 - X1 > 0 andalso Y2 - Y1 < 0 ->
            5;%%右上
        X2 - X1 > 0 andalso Y2 - Y1 > 0 ->
            6;%%右下
        X2 - X1 < 0 andalso Y2 - Y1 > 0 ->
            7;%%左下
        X2 - X1 < 0 andalso Y2 - Y1 < 0 ->
            8;%%左上
        true ->
            0
    end.

%% 根据位置计算跟踪方向
get_escape_direction(Direction) ->
    case Direction of
        1 -> [-2, 0];
        2 -> [0, -2];
        3 -> [2, 0];
        4 -> [0, 2];
        5 -> [-2, 2];
        6 -> [-2, -2];
        7 -> [2, -2];
        8 -> [2, 2];
        0 -> [0, 0]
    end.

%% 计算相对角度
get_angle(X1, Y1, X2, Y2) ->
    Angle = round((math:atan2(Y1 - Y2, X2 - X1) * 180) / math:pi()),
    ?IF_ELSE(Angle > 0, Angle, 360 + Angle).

%%列表权值概率[{1,ratio1},{2,ratio2},{3,ratio3}...]
list_rand_ratio(RatioList) ->
    RatioTotal = lists:sum([R || {_, R} <- RatioList]),
    list_rand_ratio(RatioList, RatioTotal).

list_rand_ratio(RatioList, RatioTotal) ->
    Rp = util:rand(1, RatioTotal),
    RandRatioFun = fun({Id, R}, [Ratio, First, Result]) ->
        End = First + R,
        if
            Ratio > First andalso Ratio =< End ->
                [Ratio, End, Id];
            true ->
                [Ratio, End, Result]
        end
                   end,
    [_RandRatio, _First, NewRule] = lists:foldl(RandRatioFun, [Rp, 0, 0], RatioList),
    NewRule.


%%取消引用
cancel_ref(RefList) ->
    %%取消计时器
    Fref = fun(Ref) ->
        case is_reference(Ref) of
            true ->
                erlang:cancel_timer(Ref);
            false ->
                skip
        end
           end,
    lists:foreach(Fref, RefList).

%%根据排序函数获取列表前N项
get_top_n(F, TopN, List) ->
    case length(List) =< 2 * TopN of
        true ->
            lists:sublist(lists:sort(F, List), TopN);
        false ->
            get_top_n_helper(F, TopN, List, [])
    end.

get_top_n_helper(F, TopN, List) ->
    lists:sublist(lists:sort(F, List), TopN).
get_top_n_helper(F, TopN, List, ResultL) ->
    H = util:list_rand(List),
    L_true = [V || V <- List, F(V, H)],
    L1 = L_true ++ ResultL,
    Ll_len = length(L1),
    case Ll_len >= TopN of
        true ->
            case Ll_len =< 2 * TopN of
                true ->
                    get_top_n(F, TopN, L1);
                false ->
                    get_top_n_helper(F, TopN, L_true, ResultL)
            end;
        false ->
            L_false = [V || V <- List, not F(V, H)],
            get_top_n_helper(F, TopN, L_false, L1)
    end.

%% ID 通过逗号连接起来
combine_id_by_comma(DataList) ->
    combine_id_by_comma(DataList, []).
combine_id_by_comma([], RetData) ->
    string:strip(RetData, right, $,);
combine_id_by_comma([H | T], RetData) ->
    combine_id_by_comma(T, lists:concat([RetData, H, ","])).


%% 用于显示服务器号（专服的服务器号会做扩大处理)
tran_server_id(ServerId) ->
    if
        ServerId > 1000 ->
            round(((ServerId / 1000) - (ServerId div 1000)) * 1000);
        true ->
            ServerId
    end.


%% 等待进程结束
wait_stop(Pid) when is_pid(Pid) ->
    wait_stop(Pid, 5000).
wait_stop(Pid, Time) when Time > 0 ->
    case is_process_alive(Pid) of
        true ->
            SleepTime = 20,
            sleep(SleepTime),
            wait_stop(Pid, Time - SleepTime);
        false ->
            ok
    end;
wait_stop(Pid, _Time) ->
    ?WARNING("wait Pid:~w stop fail", [Pid]),
    stop_timeout.


%%将列表的tuple元素转为列表元素
list_tuple_to_list(List) ->
    [tuple_to_list(I) || I <- List].

seed() ->
    random:seed(erlang:timestamp()).

u_sec() ->
    {_, S, T} = erlang:timestamp(),
    S * 1000000 + T.

%%返回{小时，分钟} ->
unixtime_hour_min(UnixTime) ->
    {_, {Hour, Min, _Sec}} = calendar:now_to_local_time(util:unixtime_to_now(UnixTime)),
    {Hour, Min}.


%% [{l,r,Val},{l,r,Val},{l,r,Val}]
%% 返回

lists_lr_check([], _Index) -> [];
lists_lr_check([{L, R, Val} | T], Index) ->
    if
        Index >= L andalso Index =< R -> {L, R, Val};
        true -> lists_lr_check(T, Index)
    end.


