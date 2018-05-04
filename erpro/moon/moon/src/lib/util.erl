%%----------------------------------------------------
%% 工具包
%% 
%% @author yeahoo2000@gmail.com
%% @author Qinxuan
%% @end
%%----------------------------------------------------
-module(util).
-include("common.hrl").
-export(
    [
        is_process_alive/1
        ,sleep/1
        ,bool2int/1
        ,for/3
        ,unixtime/0
        ,unixtime/1
        ,datetime_to_seconds/1
        ,seconds_to_datetime/1
        ,md5/1
        ,floor/1
        ,ceil/1
        ,rand/2
        ,rand_list/1
        ,rand_list/2
        ,fbin/2
        ,cn/1
        ,cn/2
        ,build_fun/1
        ,to_list/1
        ,parse_qs/1
        ,parse_qs/3
        ,term_to_string/1
        ,string_to_term/1
        ,bitstring_to_term/1
        ,term_to_bitstring/1
        ,all_to_binary/1
        ,to_binary/1
        ,check_name/1
        ,check_name2/1
        ,check_team_name/1
        ,text_filter/1
        ,text_banned/1
        ,text_filter/2
        ,text_banned/2
        ,text_banned_valid/1
        ,time_left/2
        ,is_same_day/2
        ,is_same_day2/2
        ,is_today/1
        ,valid_datetime/1
        ,check_range/3
        ,realm/1
        ,is_merge/0
        ,platform/1
        ,server_key/1
        ,platform_srv_sn/1
        ,day_diff/2
        ,normal_check_input/2
        ,urlencode/1
        ,trim/1
    ]
).

%% @spec is_process_alive(P) -> true | false
%% P = pid()
%% @doc 检查进程是否存活(可检查远程节点上的进程)
is_process_alive(P) when is_pid(P) ->
    case rpc:call(node(P), erlang, is_process_alive, [P]) of
        true -> true;
        false -> false;
        _ -> false
    end.

%% @spec day_diff(UnixTime, UnixTime) -> int()
%% @doc 两个unixtime相差的天数,相邻2天返回1
%% return int() 相差的天数
day_diff(FromTime, ToTime) when ToTime > FromTime ->
    FromDate = util:unixtime({today, FromTime}),
    ToDate = util:unixtime({today, ToTime}),
    case (ToDate - FromDate) / (3600 * 24) of
        Diff when Diff < 0 -> 0;
        Diff -> round(Diff)
    end;
day_diff(FromTime, ToTime) when ToTime=:=FromTime ->
    0;
day_diff(FromTime, ToTime) ->
    day_diff(ToTime, FromTime).

%% @spec sleep(T) -> ok
%% T = integer()
%% @doc 程序暂停执行时长(单位:毫秒)
sleep(T) ->
    receive
    after T ->
            true
    end.

%% @spec bool2int(Bool) -> 0 | 1
%% Bool = flase | true
%% @doc true false 值转成int值
bool2int(true) -> 1;
bool2int(false) -> 0.

%% @spec for(Begin::integer(), End::integer(), Fun::function()) -> ok 
%% @doc 模拟for循环
for(End, End, Fun) ->
    Fun(End),
    ok;
for(Begin, End, Fun) when Begin < End ->
    Fun(Begin),
    for(Begin + 1, End, Fun).

%% @spec unixtime() -> Timestamp
%% Timestamp = integer()
%% @doc 取得当前的unix时间戳
unixtime() ->
    {M, S, _} = erlang:now(),
    M * 1000000 + S.

%% @spec unixtime(ms) -> Timestamp
%% Timestamp = integer()
%% @doc 取得当前的unix时间戳，精确到毫秒
unixtime(ms) ->
    {S1, S2, S3} = erlang:now(),
    trunc(S1 * 1000000000 + S2 * 1000 + S3 / 1000);

%% 获取当天0时0分0秒的时间戳（这里是相对于当前时区而言，后面的unixtime调用都基于这个函数
unixtime(today) ->
    {M, S, MS} = now(),
    {_, Time} = calendar:now_to_local_time({M, S, MS}), %% 性能几乎和之前的一样
    M * 1000000 + S - calendar:time_to_seconds(Time);

%% 获取某时间戳的00:00:00的时间戳当Unixtime为0时，返回值有可能是负值，因为这里有时区偏移值（例如北京时间就可能是-28800
unixtime({today, Unixtime}) ->
    Base = unixtime(today),  %% 当前周一
    case Unixtime > Base of
        false -> Base - ceil((Base - Unixtime) / 86400) * 86400;
        true -> (Unixtime - Base) div 86400 * 86400 + Base
    end;

%% @spec unixtime({tomorrow, UnixTime}) -> UnixTime
%% @doc 获取明天的00:00:00的时间戳
unixtime({tomorrow, UnixTime}) ->
    unixtime({today, UnixTime}) + 86400;

%% @spec unixtime({nexttime, X}) -> NextTime;
%% @spec 当前距离每天某个时刻的时间 
%% 如当前9:00 距离10:00为3600秒 返回3600
%% 如当前时间 23:00 距离 1:00为7200秒 返回7200
unixtime({nexttime, X}) ->
    Now = unixtime(),
    TodayStartTime = unixtime({today, Now}),
    BaseTime = TodayStartTime + X, %% 取当天距离X的时间为指定时间
    case BaseTime > Now of 
        true -> BaseTime - Now; %% 当前时间比指定时间小 直接返回差距
        false -> BaseTime + 86400 - Now %% 当前时间比指定时间大 加上一天时间后求差
    end.

%% @spec datetime_to_seconds(DateTime) -> false | SecondsTime
%% DateTime = {{2011,11,15},{16,14,57}} = {{Y, M, D}, {h, m, s}} 
%% @doc 将日期转换unix时间戳
datetime_to_seconds({Year,Month,Day,Hour,Minute,Second}) ->
    datetime_to_seconds({{Year, Month, Day}, {Hour, Minute, Second}});
datetime_to_seconds(DateTime) ->
    case calendar:local_time_to_universal_time_dst(DateTime) of
        [] -> false;
        [_, Udate] -> 
            calendar:datetime_to_gregorian_seconds(Udate)-719528*24*3600;
        [Udate] ->
            calendar:datetime_to_gregorian_seconds(Udate)-719528*24*3600
    end.

%% @spec seconds_to_datetime(Unixtime) -> {{Y, M, D}, {h, m, s}}
%% Unixtime = unix时间戳
%% @doc 将unix时间戳转换成当地日期
seconds_to_datetime(Unixtime) ->
    Local = erlang:universaltime_to_localtime({{1970, 1, 1}, {0, 0, 0}}),
    LocalStamp = calendar:datetime_to_gregorian_seconds(Local),
    TimeStamp = Unixtime + LocalStamp,
    calendar:gregorian_seconds_to_datetime(TimeStamp).

%% @spec is_same_day(Timestamp1, Timestamp2) -> true | false
%% Timestamp1 = erlang:Timestamp()
%% Timestamp2 = erlang:Timestamp()
%% @doc 判断2个时间戳是否同一天
is_same_day(Timestamp1, Timestamp2) ->
    case {Timestamp1, Timestamp2} of
        {{_,_,_},{_,_,_}} ->
            {{Y1, M1, D1}, _} = calendar:now_to_local_time(Timestamp1),
            case calendar:now_to_local_time(Timestamp2) of
                {{Y1, M1, D1}, _} -> true;
                _ -> false
            end;
        _ -> false
    end.

%% @spec is_same_day(Time1, Time2) -> boolean()
%% @doc 根据unix时间戳判断是否为同一天
is_same_day2(OldTime, NewTime) ->
    Day1 = unixtime({today, OldTime}),
    Day2 = unixtime({today, NewTime}),
    Day1 =:= Day2.

%% @spec is_today(Time) -> boolean()
%% @doc 判断是否为今天时间
is_today(Time) ->
    Now = util:unixtime(),
    is_same_day2(Time, Now).

%% @spec md5(S) -> binary()
%% S = list()
%% @doc 生成16位格式的md5值
md5(S) ->
    list_to_binary([io_lib:format("~2.16.0b",[N]) || N <- binary_to_list(erlang:md5(S))]).

%% @spec floor(X) -> integer()
%% X = number()
%% @doc 取小于X的最大整数 
floor(X) ->
    T = erlang:trunc(X),
    case X < T of
        true -> T - 1;
        _ -> T
    end.

%% @spec ceil(X) -> integer()
%% X = number()
%% @doc 取大于X的最小整数
ceil(X) ->
    T = erlang:trunc(X),
    case X > T of
        true -> T + 1;
        _ -> T
    end.

%% @spec rand(Min, Max) -> integer()
%% Min = integer()
%% Max = integer()
%% @doc 产生一个介于Min到Max之间的随机整数
rand(Min, Min) -> Min;
rand(Min, Max) ->
    %% 如果没有种子，将从核心服务器中去获取一个种子，以保证不同进程都可取得不同的种子
    %% TODO:这个机制需改进
    case get("rand_seed") of
        undefined ->
            Seed = case catch sys_rand:get_seed() of
                N = {_, _, _} -> N;
                _ -> erlang:now()
            end,
            random:seed(Seed),
            put("rand_seed", Seed);
        _ -> ignore
    end,
    M = Min - 1,
    random:uniform(Max - M) + M.

%% @spec rand_list(L::list()) -> null | term()
%% @doc 从一个list中随机取出一项
rand_list([]) -> null;
rand_list([I]) -> I;
rand_list(List) -> 
    Idx = rand(1, length(List)),
    get_term_from_list(List, Idx).
get_term_from_list([H | _T], 1) ->
    H;
get_term_from_list([_H | T], Idx) ->
    get_term_from_list(T, Idx - 1).

rand_list(L, N) ->
    rand_list(L, N, []).

rand_list([], _N, A) ->
    A; 
rand_list(_L, 0, A) ->
    A;
rand_list(L, N, A) ->
    case rand_list(L) of
        null -> A;
        R -> rand_list(lists:delete(R, L), N-1, [R|A])
    end.

%% @spec fbin(Bin, Args) -> binary()
%% Bin = binary()
%% Args = list()
%% @doc 返回格式化的二进制字符串
%% <ul>
%% <li>Bin: 待格式化的二进制字符串</li>
%% <li>Args: 格式化参数</li>
%% </ul>
fbin(Bin, Args) ->
    list_to_binary(io_lib:format(Bin, Args)).

%% @spec cn(Str) -> ok
%% Str = list()
%% @doc 在控制台显示带中文的字符串
cn(Str) ->
    io:format("~ts", [iolist_to_binary(io_lib:format(Str, []))]).

%% @spec cn(F, A) -> ok
%% F = list()
%% A = list()
%% @doc 在控制台显示带中文的字符串
%% <ul>
%% <li>F: 待显示的中文字符串（可带格式化参数）</li>
%% <li>A: 格式化参数</li>
%% </ul>
cn(F, A) ->
    io:format("~ts", [iolist_to_binary(io_lib:format(F, A))]).

%% @spec to_list(X) -> list()
%% X = any()
%% @doc 将任意类型的数据转成list()类型(主要用于控制台打印).
%% 注意:tuple类型有特殊处理
to_list(X) when is_integer(X)     -> integer_to_list(X);
to_list(X) when is_float(X)       -> float_to_list(X);
to_list(X) when is_atom(X)        -> atom_to_list(X);
to_list(X) when is_binary(X)      -> binary_to_list(X);
to_list(X) when is_pid(X)         -> pid_to_list(X);
to_list(X) when is_function(X)    -> erlang:fun_to_list(X);
to_list(X) when is_port(X)        -> erlang:port_to_list(X);
to_list(X) when is_tuple(X)       -> do_tuple(tuple_to_list(X), []);
to_list(X) when is_list(X)        -> X.
do_tuple([], L) ->
    ["{" | lists:reverse(["}" | L])];
do_tuple([T], L) ->
    do_tuple([], [to_list(T) | L]);
do_tuple([H | T], L) ->
    S = to_list(H),
    S1 = [S | ", "],
    do_tuple(T, [S1 | L]).

%% @spec build_fun(String) -> fun()
%% String = list()
%% @doc 根据字符串内容生成函数
build_fun(String)->
    {ok, Tokens, _} = erl_scan:string(String),
    {ok, L} = erl_parse:parse_exprs(Tokens),
    B = erl_eval:new_bindings(),
    BS = erl_eval:bindings(B),
    {[F], []} = erl_eval:expr_list(L, BS),
    F.

%% @spec parse_qs(String) -> list()
%% String = binary() | list()
%% @doc 解析 QueryString
parse_qs(String) when is_bitstring(String) ->
    parse_qs(bitstring_to_list(String));
parse_qs(String) ->
    parse_qs(String, "&", "=").

%% @spec parse_qs(String, Token1, Token2) -> list()
%% String = binary() | list()
%% Token1 = list()
%% Token2 = list()
%% @doc 按指定的字符切割字符串
parse_qs(String, Token1, Token2) when is_bitstring(String) ->
    parse_qs(bitstring_to_list(String), Token1, Token2);
parse_qs(String, Token1, Token2) ->
    [list_to_tuple(string:tokens(KV, Token2)) || KV <- string:tokens(String, Token1)].

%% @spec term_to_string(Term::term()) -> list()
%% @doc term序列化，term转换为string格式
term_to_string(Term) -> io_lib:format("~w", [Term]).

%% @spec term_to_bitstring(Term::term()) -> bitstring()
%% term序列化，term转换为bitstring格式，e.g., [{a},1] => <<"[{a},1]">> 
term_to_bitstring(Term) -> list_to_bitstring(term_to_string(Term)).

%% @spec bitstring_to_term(String::list()) -> {error, Why::term()} | {ok, term()}
%% @doc term反序列化，bitstring转换为term
bitstring_to_term(undefined) -> {ok, undefined};
bitstring_to_term(BitString) -> string_to_term(binary_to_list(BitString)).

%% @spec string_to_term(String::list()) -> {error, Why::term()} | {ok, term()}
%% @doc term反序列化，string转换为term，e.g., "[{a},1]"  => [{a},1]
string_to_term(String) ->
    case erl_scan:string(String ++ ".") of
        {ok, Tokens, _} -> erl_parse:parse_term(Tokens);
        {error, Err, _ErrorLocation} -> io:format("erl_scan:string error ~p~n", [_ErrorLocation]), {error, Err};
        Err -> {error, Err}
    end.

%% @spec all_to_binary(List::list()) -> binary()
%% @doc 将列里的不同类型转行成字节型，如 [&lt;&lt;"字节"&gt;&gt;, 123, asd, "assd"] 输出 &lt;&lt;"字节123asdassd"&gt;&gt;
all_to_binary(List) -> all_to_binary(List, []).
all_to_binary([], Result) -> list_to_binary(Result);
all_to_binary([P | T], Result) when is_list(P) ->
    all_to_binary(T, lists:append(Result, P));
all_to_binary([P | T], Result) when is_integer(P) ->
    all_to_binary(T, lists:append(Result, integer_to_list(P)));
all_to_binary([P | T], Result) when is_binary(P) ->
    all_to_binary(T, lists:append(Result, binary_to_list(P)));
all_to_binary([P | T], Result) when is_float(P) ->
    all_to_binary(T, lists:append(Result, float_to_list(P)));
all_to_binary([P | T], Result) when is_atom(P) ->
    all_to_binary(T, lists:append(Result, atom_to_list(P))).

%% @spec to_binary(Val) -> binary()
%% Val = any()
%% @doc 将Val值转换为binary格式（8位二进制）
to_binary(Val) when is_integer(Val) -> list_to_binary(integer_to_list(Val));
to_binary(Val) when is_float(Val) -> list_to_binary(float_to_list(Val));
to_binary(Val) when is_list(Val) -> list_to_binary(Val);
to_binary(Val) when is_binary(Val) -> Val;
to_binary(_Val) -> <<>>.

%% @spec check_name(Text) -> ok | {false, Reason}
%% @doc 检查名称（会对长度、特殊字符屏蔽、敏感词屏蔽）
check_name(Text) ->
    case name_banned_len(Text) of
        true ->
            case name_banned_valid(Text) of
                true ->
                    case name_banned_special(Text) of
                        true ->
                            case util:text_banned(Text) of
                                true -> {false, ?MSGID(<<"角色名称不合法">>)};
                                false -> ok
                            end;
                        false -> 
                            {false, ?MSGID(<<"角色名称含有系统限制文字，请重新输入">>)}
                    end;
                false -> {false, ?MSGID(<<"角色名称含有限制字符">>)}
            end;
        Other -> Other
    end.


%% @spec check_name(Text) -> ok | {false, Reason}
%% @doc 检查名称（会对长度、特殊字符屏蔽、敏感词屏蔽）
check_name2(Text) ->
    case name_banned_len2(Text) of
        true ->
            case name_banned_valid(Text) of
                true ->
                    case name_banned_special(Text) of
                        true ->
                            %%case util:text_banned(Text) of
                            case forbid_name:check(Text) of
                                true -> {false, ?MSGID(<<"角色名称不合法">>)};
                                false -> ok
                            end;
                        false -> 
                            {false, ?MSGID(<<"角色名称含有系统限制文字，请重新输入">>)}
                    end;
                false -> {false, ?MSGID(<<"角色名称含有限制字符">>)}
            end;
        Other -> Other
    end.

%% @spec check_team_name(Text) -> ok | {false, Reason}
%% @doc 检查名称（会对长度、特殊字符屏蔽、敏感词屏蔽）
check_team_name(Text) ->
    case team_name_banned_len(Text) of
        true ->
            case name_banned_valid(Text) of
                true ->
                    case name_banned_special(Text) of
                        true ->
                            case util:text_banned(Text) of
                                true -> {false, ?MSGID(<<"队伍名称不合法">>)};
                                false -> ok
                            end;
                        false -> 
                            {false, ?MSGID(<<"队伍名称含有系统限制文字，请重新输入">>)}
                    end;
                false -> {false, ?MSGID(<<"队伍名称含有限制字符">>)}
            end;
        Other -> Other
    end.

%% @spec normal_check_input(Text, MaxLen) -> ok | FailReason
%% Text = bitstring() | list()
%% MaxLen = integer()
%% @doc 普通检查输入（会对长度、特殊字符屏蔽、敏感词屏蔽）
normal_check_input(Text, MaxLen) ->
    case MaxLen >= length(unicode:characters_to_list(Text)) of
        true ->
            case name_banned_special(Text) of
                true -> ok;
                false -> sys_limit
            end;
        Other -> Other
    end.

%% @spec text_filter(T) -> Any
%% T = bitstring() | list()
%% Any = bitstring() | list()
%% @doc 文字内容过滤，将关键词替换为"*"
%% <div> 传入字符串，返回list(); 传入字节流串，返回bitstring() </div>
text_filter(Text) when is_bitstring(Text) ->
    do_text_filter(bitstring_to_list(Text));
text_filter(Text) when is_list(Text) ->
    do_text_filter(Text);
text_filter(Text) ->
    Text.
do_text_filter(Text) ->
    L = filter_data:get(),
    Result = text_filter(Text, L),
    list_to_bitstring(Result).

%% @spec text_banned_valid(Text) -> bool()
%% @doc 检查文本：是否含有英文半角符号等半角符号--- 防止sql注入
%% <div> true表示正常 false表示非法文本 </div>
text_banned_valid(Text) when is_list(Text) ->
    text_banned_valid(Text);
text_banned_valid(Text) when is_bitstring(Text) ->
    %% 反斜杠\的匹配，使用了双重转义，因为erlang里面\字符本身也需要转义
    %% [和]的匹配，也特殊处理了
    case re:run(Text, "[\;\^\,\.\"\'\:\+\=\!\?\<\>\/\*\|\~\`\@\#\$\%\(\)\{\}\\\-\\\[\\\]\\\\]", [{capture, none}, caseless, unicode]) of
        match -> false;
        nomatch -> true
    end.

%% @spec text_banned(Text) -> bool()
%% Text = string()
%% @doc 检查文本中是否含有非法字符或者关键词，返回true表示需要屏蔽，false表示可以通过
text_banned(Text) when is_bitstring(Text) ->
    do_text_banned(Text);
text_banned(Text) when is_list(Text) ->
    do_text_banned(list_to_bitstring(Text));
text_banned(_) ->
    false.
do_text_banned(Text) ->
    L = filter_data:get(),
    case text_banned_valid(Text) of
        true ->
            text_banned(Text, L);
        false ->
            true
    end.

%% @spec text_filter(Text, Keywords) -> iolist()
%% Text = string()
%% Keywords = list()
%% @doc 文字内容过滤，将关键词替换为"*"
text_filter(Text, []) -> Text;
text_filter(Text, [H | L]) ->
    T = re:replace(Text, H, "\*", [caseless, global]),
    text_filter(T, L).

%% @spec text_banned(Text, Keywords) -> bool()
%% Text = string()
%% Keywords = list()
%% @doc 检查文本中是否含有指定的关键词; true表示含有屏蔽词 false表示不含
text_banned(_Text, []) -> false;
text_banned(Text, [H | L]) ->
    case re:run(Text, H, [{capture, none}, caseless]) of
        match -> true;
        _ -> text_banned(Text, L)
    end.

%% @spec time_left(TimeMax::integer(), Begin::erlang:timestamp()) -> integer()
%% @doc 计算剩余时间，单位：毫秒
time_left(TimeMax, Begin)->
    TL = util:floor(TimeMax - timer:now_diff(erlang:now(), Begin) / 1000),
    case TL > 0 of
        true -> TL;
        false -> 0
    end.

%% @spec valid_datetime(datetime()) -> true | false
%% @doc 检测datetime()是否为有效的
valid_datetime({Date, Time}) ->
    try
        calendar:valid_date(Date) andalso valid_time(Time)
    catch
        error:function_clause -> false
    end;
valid_datetime(_) -> false.

valid_time({H,M,S}) -> valid_time(H,M,S).
valid_time(H,M,S) when H >= 0, H < 24,
                       M >= 0, M < 60,
                       S >= 0, S < 60 -> true;
valid_time(_,_,_) -> false.

%% @spec check_range(Val, Min, Max) -> number()
%% Val = number()
%% Min = number()
%% Max = number()
%% @doc 取值范围限制
check_range(Val, Min, Max) ->
    if
        Val > Max -> Max;
        Val < Min -> Min;
        true -> Val
    end.

%% -----------------------------------------
%% 内部函数
%% -----------------------------------------
%% 检查字符：符合通用命名长度规范
name_banned_len(Text) ->
    case asn1rt:utf8_binary_to_list(Text) of
        {error, _Reason} -> {false, <<"非法字符">>};
        {ok, CharList} ->
            Len = string_width(CharList),
            case Len < 21 andalso Len > 1 of
                true -> true;
                false -> {false, ?MSGID(<<"角色名称长度为1~10个汉字">>)}
            end
    end.

name_banned_len2(Text) ->
    case asn1rt:utf8_binary_to_list(Text) of
        {error, _Reason} -> {false, ?MSGID(<<"非法字符">>)};
        {ok, CharList} ->
            Len = string_width(CharList),
            case Len < 11 andalso Len > 1 of
                true -> true;
                false -> {false, ?MSGID(<<"角色名称长度为1~5个汉字">>)}
            end
    end.

team_name_banned_len(Text) ->
    case asn1rt:utf8_binary_to_list(Text) of
        {error, _Reason} -> {false, ?MSGID(<<"非法字符">>)};
        {ok, CharList} ->
            Len = string_width(CharList),
            case Len < 15 andalso Len > 1 of
                true -> true;
                false -> {false, ?MSGID(<<"队伍名称长度为1~7个汉字">>)}
            end
    end.

%% 检查名字：只允许使用汉字(不含标点符号)、字母、数字和下划线
name_banned_valid(Text) when is_list(Text) ->
    name_banned_valid(list_to_bitstring(Text));
name_banned_valid(Text) when is_bitstring(Text) ->
    %% 貌似测试只有bitstring才能正确执行到结果
    %% unicode字符集：
    %% {FF00}-{FFEF} 通用ASCII全角标点符号集
    %% {3000}-{303F} 中日韩标点符号集
    %% {4E00}-{9FBF} 中日韩统一汉字
    case re:run(Text, "[^a-zA-Z0-9\\x{4E00}-\\x{9FA5}_]", [{capture, none}, caseless, unicode]) of
        match -> false; %%<<"角色名只允许使用汉字、字母、数字和下划线">>}; %% 含有非法字符 
        nomatch -> true
    end;
name_banned_valid(_Text) -> false.

%% 检查名字是否有特殊名称
name_banned_special(Text) ->
    L = filter_data:get_name_ban_special(),
    case text_banned(Text, L) of
        true -> false;
        false -> true
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

%% 获取阵营
%% @spec realm(SrvId::bitstring()) -> {ok, Realm::integer()} | {false, Reason::binary()}
realm(SrvId) ->
    case sys_env:get(srv_ids) of
        [] -> {ok, 0};
        SrvList when is_list(SrvList) ->
            StrSrvId = util:to_list(SrvId),
            case lists:member(StrSrvId, SrvList) of
                true ->
                    case sys_env:get(realm_a) of
                        [] -> {ok, 0};
                        RealmA ->
                            RealmB = sys_env:get(realm_b),
                            case lists:member(StrSrvId, RealmA) of
                                true -> {ok, 1};
                                false ->
                                    case lists:member(StrSrvId, RealmB) of
                                        true -> {ok, 2};
                                        false -> {ok, ?MSGID(<<"服务器阵营信息有误">>)}
                                    end
                            end
                    end;
                false -> {false, ?MSGID(<<"非法SrvId">>)}
            end;
        _ -> {false, ?MSGID(<<"缺少srv_ids">>)}
    end.

%% @spec platform(SrvId::bitstring()) -> Platform::list() | {false, Reason::binary()}
%% 获取平台标志
platform(undefined) ->
    sys_env:get(platform);
platform(SrvId) ->
    [Platform | _T] = re:split(to_list(SrvId), "_", [{return, list}]),
    case Platform of
        "yy" -> "duowan";
        "522you" -> "552you";
        _ -> Platform
    end.

%% @spec server_key(SrvId::bitstring()) -> ServerKey::list()
%% 获取平台server_key
server_key(undefined) ->
    sys_env:get(server_key);
server_key(SrvId) ->
    case sys_env:get(platform_srvs) of
        [] -> server_key(undefined);
        undefined -> server_key(undefined);
        PlatformList ->
            case lists:keyfind(to_list(SrvId), 2, PlatformList) of
                false ->
                    catch logger:error("没有找到匹配的平台标志符信息[SrvId:~s]", [SrvId], ?MODULE, ?LINE),
                    server_key(undefined);
                {_, _, ServerKey} -> ServerKey
            end
    end.

%% @spec platform_srv_sn(SrvId::BitString()) -> PlatformSrvSn::list()
%% 获取平台分配服务编号
platform_srv_sn(SrvId) ->
    [SrvSn | _T] = lists:reverse(re:split(bitstring_to_list(SrvId), "_", [{return, list}])),
    case platform(SrvId) of
        "baidu" -> "s" ++ SrvSn;
        _ -> "S" ++ SrvSn
    end.

%% @spec is_merge() -> true | false
%% 是否已经合服
is_merge() ->
    case sys_env:get(realm_a) of
        [] -> false;
        Realm when is_list(Realm) -> true;
        _ -> false
    end.

urlencode(S) when is_list(S) ->
    urlencode(unicode:characters_to_binary(S));
urlencode(<<C:8, Cs/binary>>) when C >= $a, C =< $z ->
    [C] ++ urlencode(Cs);
urlencode(<<C:8, Cs/binary>>) when C >= $A, C =< $Z ->
    [C] ++ urlencode(Cs);
urlencode(<<C:8, Cs/binary>>) when C >= $0, C =< $9 ->
    [C] ++ urlencode(Cs);
urlencode(<<C:8, Cs/binary>>) when C == $. ->
    [C] ++ urlencode(Cs);
urlencode(<<C:8, Cs/binary>>) when C == $- ->
    [C] ++ urlencode(Cs);
urlencode(<<C:8, Cs/binary>>) when C == $_ ->
    [C] ++ urlencode(Cs);
urlencode(<<C:8, Cs/binary>>) ->
    escape_byte(C) ++ urlencode(Cs);
urlencode(<<>>) ->
    "".

escape_byte(C) ->
    "%" ++ hex_octet(C).

hex_octet(N) when N =< 9 ->
    [$0 + N];
hex_octet(N) when N > 15 ->
    hex_octet(N bsr 4) ++ hex_octet(N band 15);
hex_octet(N) ->
    [N - 10 + $a].


trim(S) -> string:strip(S,both,32).

