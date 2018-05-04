%%%-------------------------------------------------------------------
%%% File        :common_tool.erl
%%%-------------------------------------------------------------------
-module(common_tool).

-export([
         ip/1,
         ip_to_str/1,
         get_intranet_address/0,
         get_all_bind_address/0,
         
         sort/1,
         for/3,	
         f2s/1,	 
         get_type/2,
         list_random/1,
         
         random_dice/2,
         random/2,
         
         odds/2,
         odds_list/1,
         odds_list/2,
         odds_list_sum/1,
         combine_lists/2,
         list_to_atom/1,
         shuff_list/1,
         
         ceil/1,
         floor/1,
         sleep/1,
         float/2,
         subatom/2,
         
         to_integer/1,
         to_binary/1,
         to_tuple/1,
         to_float/1,
         to_list/1,
         to_atom/1,
         index_of/2,
         
         md5/1,
         url_encode/1,
         utf8_len/1,
         sublist_utf8/3,
         
         
         now/0,
         now2/0,
         today/3,
         now_microseconds/0,
         now_nanosecond/0,
         minute_second_format/0,
         hour_minute_second_format/0,
         datetime_to_seconds/1,
         seconds_to_datetime/1,
         seconds_to_datetime_string/1,
         date_format/0,
         time_format/1,
         calc_weekgap_of_two_day/2
        ]).

-export([
         silver_to_string/1,
         get_money_cut/3,
         get_random_index/3,
         gen_multi_random_number/5,
         get_format_json_value/2
         ]).

-export([
         get_msg_queue/0,
         get_memory/0,
         get_memory/1,
         get_heap/0,
         get_heap/1,
         get_processes/0,
         get_memory_pids/1,
         gc/1,
         gc_nodes/1,
         get_process_info_and_zero_value/1,
         probability_choose/1
        ]).


-include("common.hrl").

-define(GREGORIAN_INTERVIAL_TIME,calendar:datetime_to_gregorian_seconds({{1970,1,1}, {8,0,0}})).

%% time format,
one_to_two(One) -> io_lib:format("~2..0B", [One]).

%%@doc 获取时间格式
time_format({A,B,C}) -> 
    {{Y,M,D},{H,MM,S}} = calendar:now_to_local_time({A,B,C}),
    time_format({{Y,M,D},{H,MM,S}});
time_format({{Y,M,D},{H,MM,S}})->
    lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", 
                        one_to_two(H) , ":", one_to_two(MM), ":", one_to_two(S)]).



%%@doc 获取日期格式
date_format() ->
    {Y,M,D} = erlang:date(),
    lists:concat([Y , "-", one_to_two(M), "-", one_to_two(D)]).

%%@doc 获取时间的分秒格式
minute_second_format() ->
    Now = erlang:now(),
    {{_Y,_M,_D},{H,MM,_S}} = calendar:now_to_local_time(Now),
    lists:concat([one_to_two(H) , "-", one_to_two(MM)]).

%%@doc 获取时间的时分秒格式
hour_minute_second_format() ->
    Now = erlang:now(),
    {{_Y,_M,_D},{H,MM,S}} = calendar:now_to_local_time(Now),
    lists:concat([one_to_two(H) , ":", one_to_two(MM), ":", one_to_two(S)]).


%% @doc get IP address string from Socket
ip(Socket) ->
    {ok, {IP, _Port}} = inet:peername(Socket),
    {Ip0,Ip1,Ip2,Ip3} = IP,
    list_to_binary(integer_to_list(Ip0)++"."++integer_to_list(Ip1)++"."++integer_to_list(Ip2)++"."++integer_to_list(Ip3)).


%% @doc quick sort
sort([]) ->
    [];
sort([H|T]) -> 
    sort([X||X<-T,X<H]) ++ [H] ++ sort([X||X<-T,X>=H]).

%% for
for(Max,Max,F)->[F(Max)];
for(I,Max,F)->[F(I)|for(I+1,Max,F)].


%% @doc convert float to string,  f2s(1.5678) -> 1.57
f2s(N) when is_integer(N) ->
    integer_to_list(N) ++ ".00";
f2s(F) when is_float(F) ->
    [A] = io_lib:format("~.2f", [F]),
    A.


%% @doc convert other type to atom
to_atom(Msg) when is_atom(Msg) -> 
    Msg;
to_atom(Msg) when is_binary(Msg) -> 
    common_tool:list_to_atom(binary_to_list(Msg));
to_atom(Msg) when is_list(Msg) -> 
    common_tool:list_to_atom(Msg);
to_atom(_) -> 
    throw(other_value).  %%list_to_atom("").

%% @doc convert other type to list
to_list(Msg) when is_list(Msg) -> 
    Msg;
to_list(Msg) when is_atom(Msg) -> 
    atom_to_list(Msg);
to_list(Msg) when is_binary(Msg) -> 
    binary_to_list(Msg);
to_list(Msg) when is_integer(Msg) -> 
    integer_to_list(Msg);
to_list(Msg) when is_float(Msg) -> 
    f2s(Msg);
to_list(Msg) when is_tuple(Msg) -> 
    tuple_to_list(Msg);
to_list(_) ->
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
to_float(Msg)->
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
to_integer(_Msg) ->
    throw(other_value).

%% @doc convert other type to tuple
to_tuple(T) when is_tuple(T) -> T;
to_tuple(T) -> {T}.


%% @doc get item index of list
%% @return 0:not_found
-spec index_of(Item, List) -> Index when Item :: term(), List :: [term()], Index :: 0 | integer().
index_of(_Item, []) ->
    0;
index_of(Item, List) -> index_of(Item, List, 1).

index_of(Item, [Item|_], Index) -> Index;
index_of(Item, [_|Tl], Index) -> index_of(Item, Tl, Index+1).

%% @doc convert IP(tuple) to string()
ip_to_str(IP) ->
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

%% @doc get data type {0=integer,1=list,2=atom,3=binary}
get_type(DataValue,DataType)->
    case DataType of
        0 ->
            DataValue2 = binary_to_list(DataValue),
            list_to_integer(DataValue2);
        1 ->
            binary_to_list(DataValue);
        2 ->
            DataValue2 = binary_to_list(DataValue),
            common_tool:list_to_atom(DataValue2);
        3 -> 
            DataValue
    end.



%% @doc get random list
list_random(List)->
    case List of
        [] ->
            {};
        _ ->
            RS		=	lists:nth(random:uniform(length(List)), List),
            ListTail	= 	lists:delete(RS,List),
            {RS,ListTail}
    end.

%% @doc get a random integer between Min and Max
random(Min,Max)->
    Min2 = Min-1,
    random:uniform(Max-Min2)+Min2.

random_dice(Face,Times)->
    if
        Times == 1 ->
            random(1,Face);
        true ->
            lists:sum(for(1,Times, fun(_)-> random(1,Face) end))
    end.

odds(Numerator,Denominator)->
    Odds = random:uniform(Denominator),
    if
        Odds =< Numerator -> 
            true;
        true ->
            false
    end.
odds_list(List)->
    Sum = odds_list_sum(List),
    odds_list(List,Sum).
odds_list([{Id,Odds}|List],Sum)->
    case odds(Odds,Sum) of
        true ->
            Id;
        false ->
            odds_list(List,Sum-Odds)
    end.
odds_list_sum(List)->
    {_List1,List2} = lists:unzip(List),
    lists:sum(List2).

shuff_list(List) ->
    lists:sort(fun(_, _) -> random(0, 1) == 1 end, List).

%% @doc get the minimum number that is bigger than X 
ceil(X) ->
    T = trunc(X),
    if 
        X - T == 0 ->
            T;
        true ->
            if
                X > 0 ->
                    T + 1;
                true ->
                    T
            end			
    end.


%% @doc get the maximum number that is smaller than X
floor(X) ->
    T = trunc(X),
    if 
        X - T == 0 ->
            T;
        true ->
            if
                X > 0 ->
                    T;
                true ->
                    T-1
            end
    end.

subatom(Atom,Len)->	
    common_tool:list_to_atom(lists:sublist(atom_to_list(Atom),Len)).

sleep(Msec) ->
    receive
    after Msec ->
            true
    end.

md5(S) ->        
    Md5_bin =  erlang:md5(S), 
    Md5_list = binary_to_list(Md5_bin), 
    lists:flatten(list_to_hex(Md5_list)). 

list_to_hex(L) -> 
    lists:map(fun(X) -> int_to_hex(X) end, L). 

int_to_hex(N) when N < 256 -> 
    [hex(N div 16), hex(N rem 16)]. 
hex(N) when N < 10 -> 
    $0+N; 
hex(N) when N >= 10, N < 16 ->      
    $a + (N-10).

list_to_atom(List) when is_list(List) ->
    case catch(list_to_existing_atom(List)) of
        {'EXIT', _} -> erlang:list_to_atom(List);
        Atom when is_atom(Atom) -> Atom
    end.

combine_lists(L1, L2) ->
    Rtn = 
	lists:foldl(
          fun(T, Acc) ->
                  case lists:member(T, Acc) of
                      true ->
                          Acc;
                      false ->
                          [T|Acc]
                  end
          end, lists:reverse(L1), L2),
    lists:reverse(Rtn).


get_process_info_and_zero_value(InfoName) ->
    PList = erlang:processes(),
    ZList = lists:filter( 
              fun(T) -> 
                      case erlang:process_info(T, InfoName) of 
                          {InfoName, 0} -> false; 
                          _ -> true 	
                      end
              end, PList ),
    ZZList = lists:map( 
               fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)} 
               end, ZList ),
    [ length(PList), InfoName, length(ZZList), ZZList ].

get_memory_pids(Memory) ->
    PList = erlang:processes(),
    lists:filter( 
      fun(T) -> 
              case erlang:process_info(T, memory) of 
                  {_, VV} -> 
                      if VV >  Memory -> true;
                         true -> false
                      end;
                  _ -> true 	
              end
      end, PList ).

gc(Memory) ->
    lists:foreach(
      fun(PID) ->
              erlang:garbage_collect(PID)
      end, get_memory_pids(Memory)).

gc_nodes(Memory) ->
    lists:foreach(
      fun(Node) ->
              lists:foreach(
                fun(PID) ->
                        rpc:call(Node, erlang, garbage_collect, [PID])
                end, rpc:call(Node, common_tool, get_memory_pids, [Memory]))
      end, [node() | nodes()]).

get_process_info_and_large_than_value(InfoName, Value) ->
    PList = erlang:processes(),
    ZList = lists:filter( 
              fun(T) -> 
                      case erlang:process_info(T, InfoName) of 
                          {InfoName, VV} -> 
                              if VV >  Value -> true;
                                 true -> false
                              end;
                          _ -> true 	
                      end
              end, PList ),
    ZZList = lists:map( 
               fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)} 
               end, ZList ),
    [ length(PList), InfoName, Value, length(ZZList), ZZList ].

get_msg_queue() ->
    io:fwrite("process count:~p~n~p value is not 0 count:~p~nLists:~p~n", 
              get_process_info_and_zero_value(message_queue_len) ).

get_memory() ->
    io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
              get_process_info_and_large_than_value(memory, 1048576) ).

get_memory(Value) ->
    io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
              get_process_info_and_large_than_value(memory, Value) ).

get_heap() ->
    io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
              get_process_info_and_large_than_value(heap_size, 1048576) ).

get_heap(Value) ->
    io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
              get_process_info_and_large_than_value(heap_size, Value) ).

get_processes() ->
    io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
              get_process_info_and_large_than_value(memory, 0) ).

%% seconds
now() ->
    {A, B, _} = erlang:now(),
    A * 1000000 + B.

%% milliseconds
now2() ->
    {A, B, C} = erlang:now(),
    A * 1000000000 + B*1000 + trunc(C/1000).

%% microseconds
now_microseconds() ->
    {A, B, C} = erlang:now(),
    A * 1000000000 + B*1000 + C.

now_nanosecond() ->
    {A, B, C} = erlang:now(),
    A * 1000000000000 + B*1000000 + C.

url_encode([H|T]) -> 
     if
          H >= $a, $z >= H -> 
	[H|url_encode(T)];
         H >= $A, $Z >= H ->
             [H|url_encode(T)];
         H >= $0, $9 >= H ->
             [H|url_encode(T)];
         H == $_; H == $.; H == $-; H == $/; H == $: -> % FIXME: more..
             [H|url_encode(T)];
         true ->
             case yaws:integer_to_hex(H) of
                 [X, Y] ->
                     [$%, X, Y | url_encode(T)];
                 [X] ->
                     [$%, $0, X | url_encode(T)]
             end
      end;
 
url_encode([]) ->
     [].

datetime_to_seconds({_Date,_Time}=Datetime)->
    calendar:datetime_to_gregorian_seconds(Datetime)
        - ?GREGORIAN_INTERVIAL_TIME.

seconds_to_datetime(MTime)->
    calendar:gregorian_seconds_to_datetime( 
      ?GREGORIAN_INTERVIAL_TIME+ MTime).

seconds_to_datetime_string(MTime)->
    {{Y,M,D},{HH,MM,SS}} = seconds_to_datetime(MTime),
    io_lib:format("~w-~w-~w ~w:~w:~w",[Y,M,D,HH,MM,SS]).


%%@doc 把银两数转换为带单位的字符串
silver_to_string(Number) ->
    lists:concat([Number]).


today(H,M,S) ->
    A = calendar:datetime_to_gregorian_seconds({date(),{H,M,S}}),
    B = calendar:datetime_to_gregorian_seconds({{1970,1,1}, {8,0,0}}),
    A-B.

%% 获得内网IP地址
%% return list()
get_intranet_address() ->
    Result = os:cmd("/sbin/ifconfig -a | grep 'inet ' | grep '192.168.' | awk '{print $2}' | cut -d ':' -f 2 | grep -v '^127'"),
    string:tokens(Result, "\n").

get_all_bind_address() ->
    Result = os:cmd("/sbin/ifconfig -a | grep 'inet ' | awk '{print $2}' | cut -d ':' -f 2 | grep -v '^127'"),
    string:tokens(Result, "\n").
    

utf8_len(List) when erlang:is_list(List) ->
    len(List, 0);
utf8_len(Binary) when erlang:is_binary(Binary) ->
    len(erlang:binary_to_list(Binary), 0).
    
    
len([], N) ->
    N;
len([A, _, _, _, _, _ | T], N) when A =:= 252 orelse A =:= 253 ->
    len(T, N+1);
len([A, _, _, _, _ | T], N) when A >=248 andalso A =< 251 ->
    len(T, N+1);
len([A, _, _, _ |T], N) when A >= 240 andalso A =< 247 ->
    len(T, N+1);
len([A, _, _ | T], N) when A >= 224 ->
    len(T, N+1);
len([A, _ | T], N) when A >= 192 ->
    len(T, N+1);
len([_A | T], N) ->
    len(T, N+1).



sublist_utf8(List, Start, Length) when erlang:is_list(List) ->
    sublist_utf8_2(List, Start, Start + Length - 1, 0, []);
sublist_utf8(Binary, Start, Length) when erlang:is_binary(Binary) ->
    sublist_utf8_2(erlang:binary_to_list(Binary), Start, Start + Length - 1, 0, []).

sublist_utf8_2(List, Start, End, Cur, Result) ->
    if Cur =:= End ->
            lists:reverse(Result);
       true ->
            sublist_utf8_3(List, Start, End, Cur, Result)
    end.

sublist_utf8_3([], _Start, _End, _Cur, Result) ->
    lists:reverse(Result);
sublist_utf8_3([A, A2, A3, A4, A5, A6 | T], Start, End, Cur, Result) when A =:= 252 orelse A =:= 253 ->
    if Cur + 1 >= Start ->
            Result2 = [A6, A5, A4, A3, A2, A | Result];
       true ->
            Result2 = Result
    end,
    sublist_utf8_2(T, Start, End, Cur+1, Result2);
sublist_utf8_3([A, A2, A3, A4, A5 | T], Start, End, Cur, Result) when A >= 248 andalso A =< 251 ->
    if Cur + 1 >= Start ->
            Result2 = [A5, A4, A3, A2, A | Result];
       true ->
            Result2 = Result
    end,
    sublist_utf8_2(T, Start, End, Cur+1, Result2);
sublist_utf8_3([A, A2, A3, A4 | T], Start, End, Cur, Result) when A >= 240 andalso A =< 247 ->
    if Cur + 1 >= Start ->
            Result2 = [A4, A3, A2, A | Result];
       true ->
            Result2 = Result
    end,
    sublist_utf8_2(T, Start, End, Cur+1, Result2);
sublist_utf8_3([A, A2, A3 | T], Start, End, Cur, Result) when A >= 224 ->
    if Cur + 1 >= Start ->
            Result2 = [A3, A2, A | Result];
       true ->
            Result2 = Result
    end,
    sublist_utf8_2(T, Start, End, Cur+1, Result2);
sublist_utf8_3([A, A2 | T], Start, End, Cur, Result) when A >= 192 ->
    if Cur + 1 >= Start ->
            Result2 = [A2, A | Result];
       true ->
            Result2 = Result
    end,
    sublist_utf8_2(T, Start, End, Cur+1, Result2);
sublist_utf8_3([A | T], Start, End, Cur, Result) ->
    if Cur + 1 >= Start ->
            Result2 = [A | Result];
       true ->
            Result2 = Result
    end,
    sublist_utf8_2(T, Start, End, Cur+1, Result2).

 
%% SilverBind 绑定银两数量
%% Silver 不绑定银两数量
%% Cut 扣去的费用
%% return {error,not_enough_money}|{ok,SilverBindCut,SilverCut}
get_money_cut(SilverBind,Silver,Cut)->
    case Cut > SilverBind of
        true->
            SilverCut = Cut-SilverBind,
            case SilverCut >Silver of
                true->
                    {error,not_enough_money};
                false->
                    {ok,SilverBind,SilverCut}
            end;
        false->
            {ok,Cut,0}
    end.

%% 计算两个日期之间相差的星期数
calc_weekgap_of_two_day(Day1, Day2) ->
    {Y1, W1} = calendar:iso_week_number(Day1),
    {Y2, W2} = calendar:iso_week_number(Day2),
    (Y2 - Y1) * 52 + W2 - W1. 

%% 根据 [1,2,3,4,5,6] 格式的概率配置
%% 随机计算命中那一个概率
%% SumNumber 为 0 即计算 DataList 的总和为SumNumber
%% 返回计算命中概率的数据下标，如果不有命中即返回 DefaultValue
get_random_index([],_SumNumber,DefaultValue) ->
    DefaultValue;
get_random_index(DataList,SumNumber,DefaultValue) ->
    Length = erlang:length(DataList),
    case SumNumber =:= 0 of
        true ->
            Sum = lists:sum(DataList);
        _ ->
            Sum = SumNumber
    end,
    case Sum =< 0 of
        true ->
            DefaultValue;
        _ ->
            RandomNumber = random:uniform(Sum),
            LenList = lists:seq(1,Length,1),
            get_random_index2(LenList,DataList,RandomNumber,false, DefaultValue)
    end.

get_random_index2([],_DataList,_RandomNumber,_Flag, Result) ->
    Result;
get_random_index2(_LenList,_DataList,_RandomNumber,true,Result) ->
    Result;
get_random_index2([H|T],DataList,RandomNumber,Flag,Result) ->
    Value = lists:nth(H,DataList),
    case (H - 1) > 0 of
        true ->
            V1 = get_sum_lists_by_index(H - 1,DataList);
        _ ->
            V1 = 0
    end,
    V2 = get_sum_lists_by_index(H,DataList),
    case Value =/= 0 
             andalso RandomNumber > V1
             andalso RandomNumber =< V2 of
        true ->
            get_random_index2(T,DataList,RandomNumber,true,H);
        _ ->
            get_random_index2(T,DataList,RandomNumber,Flag,Result)
    end.
get_sum_lists_by_index(Index,DataList) ->
    lists:foldl(
      fun(V,Acc) ->
              Acc + V
      end,0,lists:sublist(DataList,Index)).

%% List = [1,2,3,4,5,6]
%% 根据每个值的权重返回第n位的list
probability_choose([])->0;
probability_choose(List)->
    SumWeight = lists:sum(List),
    Cursor = common_tool:random(1, SumWeight),
    probability_choose(List,0,0,Cursor).

%% Sections 调整范围值
%% Order 第几次调整
%% Cursor 命中值
%% [H|T] 权重列表
probability_choose([H|T],Sections,Order,Cursor)->
    case Sections <Cursor  of
        true->probability_choose(T,Sections+H,Order+1,Cursor);
        false->Order
    end;
probability_choose([],_Sections,Order,_Cursor)->
    Order.

%% 计算多个数的随机数
%% 根据总数和每一个数的最小值、最大值控制生成一个随机数列表
%% 如果：总数100，最小值11，最大值29生成5个随机数
%% Count 要计算的随机数个数
%% Total  总数
%% Min    最小数
%% Max    最大数
%% NumberList 返回结果
gen_multi_random_number(Count,Min,Max,Total,NumberList) ->
    MinCount = gen_multi_random_number2(true,Min,Max,Total,Count,1),
    MaxCount = gen_multi_random_number3(true,Min,Max,Total,Count,1),
    gen_multi_random_number4(Count,Min,Max,MinCount,MaxCount,Total,NumberList).

gen_multi_random_number4(0,_Min,_Max,_MinCount,_MaxCount,_Total,NumberList) ->
    NumberList;
gen_multi_random_number4(1,_Min,_Max,_MinCount,_MaxCount,Total,NumberList) ->
    [Total | NumberList];
gen_multi_random_number4(Count,Min,Max,MinCount,MaxCount,Total,NumberList) ->
    CurCount = Count - 1,
    random:seed(erlang:now()),
    Val = common_tool:random(Min, Max),
    case Val == Min andalso MinCount == 0 of
        true -> %% 不合法，需要调整最小数
            gen_multi_random_number4(Count,Min,Max,MinCount,MaxCount,Total,NumberList);
        _ ->
            case Val == Max andalso MaxCount == 0 of
                true -> %% 不合法，需要调整最大数
                    gen_multi_random_number4(Count,Min,Max,MinCount,MaxCount,Total,NumberList);
                _ ->
                    case CurCount * Max >= (Total - Val) 
                        andalso (Total - Val) >= Min * CurCount of
                        true -> %% 些次随机的值有效
                            case Val == Min andalso MinCount > 0 of
                                true ->
                                    NewMinCount = MinCount - 1;
                                _ ->
                                    NewMinCount = MinCount
                            end,
                            case Val == Max andalso MaxCount > 0 of
                                true ->
                                    NewMaxCount = MaxCount - 1;
                                _ ->
                                    NewMaxCount = MaxCount
                            end,
                            gen_multi_random_number4(CurCount,Min,Max,NewMinCount,NewMaxCount,Total - Val,[Val|NumberList]);
                        _ ->
                            gen_multi_random_number4(Count,Min,Max,MinCount,MaxCount,Total,NumberList)
                    end
            end
    end.
%% 计算最多可以存在多少个最小值
gen_multi_random_number2(false,_Min,_Max,_Total,_TotalCount,MinCount) ->
    MinCount;
gen_multi_random_number2(true,Min,Max,Total,TotalCount,MinCount) ->
    case MinCount >= TotalCount of
        true ->
            gen_multi_random_number2(false,Min,Max,Total,TotalCount,MinCount);
        _ ->
            case ((Total - MinCount * Min) div (TotalCount - MinCount) ) =< Max of
                true ->
                    gen_multi_random_number2(true,Min,Max,Total,TotalCount,MinCount + 1);
                _ ->
                    gen_multi_random_number2(false,Min,Max,Total,TotalCount,MinCount - 1)
            end
    end.
%% 计算最多可以存在多少个最大值
gen_multi_random_number3(false,_Min,_Max,_Total,_TotalCount,MaxCount) ->
    MaxCount;
gen_multi_random_number3(true,Min,Max,Total,TotalCount,MaxCount) ->
    case MaxCount >= TotalCount of
        true ->
            gen_multi_random_number3(false,Min,Max,Total,TotalCount,MaxCount);
        _ ->
            case ((Total - MaxCount * Max) div (TotalCount - MaxCount) ) >= Min of
                true ->
                    gen_multi_random_number3(true,Min,Max,Total,TotalCount,MaxCount + 1);
                _ ->
                    gen_multi_random_number3(false,Min,Max,Total,TotalCount,MaxCount - 1)
            end
    end.
    
%% 格式化json值
get_format_json_value(string,Value) ->
    "\"" ++ common_tool:to_list(Value) ++ "\"";
get_format_json_value(_Type,Value) ->
    Value.

%% Number 需要处理的小数
%% X 要保留几位小数
%% float(8.22986, 3).
%% output: 8.230
float(Number, X) ->
    N = math:pow(10,X),
    round(Number*N)/N.
