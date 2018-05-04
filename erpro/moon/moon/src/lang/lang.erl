%%----------------------------------------------------
%% 抽取语言文件 翻译流程 extract --> export --> translate --> replace
%% @author weihua@jieyou.cn 
%%----------------------------------------------------
-module(lang).
-export([show/1                     %% 查看DETS数据
        ,del/1                      %% 删除 DETS 文件
        ,set_ver/2
        ,do/0
        ,cisc/2
        ,lib_tr/1
        ,gen/0
        ,gen/1
        ,stats/1
    ]
).

-export([test/2]).

%% 涉及到的文件说明
%% Boss文件 (所有数据)                                                  server.txt
%% 翻译过的文件         上下行格式                                      server_done_union.txt
%% 翻译过的简体文件     纯简体                                          server_done_cn.txt
%% 翻译过的翻译文件     纯翻译                                          server_done_xx.txt
%% 未翻译的文件         上下行格式  待翻译                              server_undone_union.txt
%% 未翻译的简体文件     纯简体                                          server_undone_cn.txt
%% 未翻译的翻译文件     纯翻译      翻译方可能会直接在纯简体上改动      server_undone_xx.txt

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("lang.hrl").

do() ->
    code:purge(ext_re),
    code:load_file(ext_re),
    code:purge(export),
    code:load_file(export),
    code:purge(import),
    code:load_file(import),
    code:purge(qual),
    code:load_file(qual),
    code:purge(ldets),
    code:load_file(ldets),
    code:purge(lutil),
    code:load_file(lutil),
    code:purge(language),
    code:load_file(language),
    code:purge(ldata),
    code:load_file(ldata),
    code:purge(lang),
    code:load_file(lang).

%% @spec show() -> ok
%% @doc 查看DETS文件数据
show(Type) ->
    {DetsName, DetsPath} = case Type of
        xml -> {?lang_xml_dets_name, ?lang_xml_dets};
        server -> {?lang_server_dets_name, ?lang_server_dets}
    end,
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #lang.file}, {type, set}]),
    case dets:first(DetsName) of
        '$end_of_table' -> ?INFO("没有任何字典数据");
        _ ->
            ?INFO("开始扫描字典数据..."),
            dets:traverse(DetsName,
                fun(#lang{file = FilePath, dicts = Dicts}) ->
                        ?INFO("当前文件【~s】占用长度【~w】翻译字典数【~w】", [FilePath, byte_size(FilePath), length(Dicts)]),
                        Fun = fun({S, T, B, Size}) -> ?INFO("简体中文是: ~s~n翻译内容是: ~s~n翻译状态是: ~w, size is ~w",[S, T, B, Size]) end,
                        lists:foreach(Fun, Dicts),
                        continue
                end
            ),
            ?INFO("本次字典数据扫描完毕！")
    end,
    dets:close(DetsName).

%% @spec del(Type) -> ok
%% @doc 删除Dets文件
del(Type) ->
    DetsPath = case Type of
        xml -> ?lang_xml_dets;
        server -> ?lang_server_dets;
        notice -> ?lang_notice_dets_name
    end,
    file:delete(DetsPath).

%% @spec set_ver(Type, PreNow) -> ok
%% @doc 将当前字典数据置为以前的版本(pre)，或当前版本(Now)
set_ver(Type, PreNow) ->
    {DetsName, DetsPath} = case Type of
        server -> {?lang_server_dets_name, ?lang_server_dets};
        xml -> {?lang_xml_dets_name, ?lang_xml_dets}
    end,
    case PreNow =:= pre orelse PreNow =:= now of
        false ->
            error_ver_value;
        true ->
            dets:open_file(DetsName, [{file, DetsPath}, {keypos, #lang.file}, {type, set}]),
            Lang = fun(Lang = #lang{dicts = Dicts}) -> Lang#lang{dicts = [Dict#dict{ver = PreNow} || Dict <- Dicts]} end,
            NewLang = dets:foldl(fun(Elem, Acc) -> [Lang(Elem) | Acc] end, [], DetsName),
            dets:insert(DetsName, NewLang),
            dets:close(DetsName)
    end.

%% @spec cisc() -> ok | error
%% @doc 对翻译词条特殊处理，忽略标点字符，空白符，进行比对
cisc(Base, UnDone) ->
    cisc_base(Base),
    cisc_undone(UnDone).

%% @spec lib_tr(Type) -> ok | error
%% Type = server | xml
%% @doc 从词库中提取翻译，更到未翻译的。
lib_tr(Type) ->
    {DetsName, DetsFile, LibDetsName, LibFileName} = case Type of
        server -> {?lang_server_dets_name, ?lang_server_dets, server_lib, ?lang_server_words};
        xml -> {?lang_xml_dets_name, ?lang_xml_dets, xml_lib, ?lang_xml_words}
    end,
    dets:open_file(DetsName, [{file, DetsFile}, {keypos, #lang.file}, {type, set}]),
    dets:open_file(LibDetsName, [{file, LibFileName}, {keypos, #word.cn}, {type, set}]),
    lib_tr(DetsName, LibDetsName),
    dets:close(DetsName),
    dets:close(LibDetsName).

%% @spec gen(index) -> ok
%% @doc 生成 language.erl 语言包 带索引
gen(index) ->
    case file:open("../src/lang/language.erl", [write]) of
        {ok, IoDev} ->
            ?INFO("开始生成语言包文件 language.erl ..."),
            Lans = get_language_pair_list(server),
            file:write(IoDev, "%%------------------------------\n%% 语言包\n%%------------------------------\n"),
            file:write(IoDev, "-module(language).\n"),
            {Dlep, Group} = distribute(Lans),
            Funs = [util:fbin("get_~w", [GroupNum]) ||{GroupNum, _} <- Group],
            file:write(IoDev, "-export([\n"),
            lists:foreach(fun(FunName) -> file:write(IoDev, io_lib:format("\t\t~s/1,\n", [FunName])) end, Funs),
            file:write(IoDev, "\t\tget/1\n]).\n\n"),
            file:write(IoDev, "get(Bin) when is_binary(Bin) ->\n\tSize = byte_size(Bin),\n\tcase size_to_group(Size) of\n\t\terror -> Bin;\n\t\tFunName -> ?MODULE:FunName(Bin)\n\tend;\nget(Bin) -> Bin.\n\n"),
            StrList = size_to_group_str(Group),
            lists:foreach(fun(Str) -> file:write(IoDev, Str) end, StrList),
            gen_lan_erl(IoDev, Group, Dlep),
            ?INFO("生成完毕！"),
            file:close(IoDev);
        {error, Reason} ->
            {error, Reason}
    end.

%% @spec gen() -> ok
%% @doc 生成 language.erl 语言包
gen() ->
    case file:open("../src/lang/language.erl", [write]) of
        {ok, IoDev} ->
            ?INFO("开始生成语言包文件 language.erl ..."),
            Lans = get_language_pair_list(server),
            file:write(IoDev, "%%------------------------------\n%% 语言包\n%%------------------------------\n"),
            file:write(IoDev, "-module(language).\n-export([get/1]).\n\n"),
            gen(IoDev, Lans),
            file:write(IoDev, "get(Bin) -> Bin."),
            ?INFO("生成完毕！"),
            file:close(IoDev);
        {error, Reason} ->
            {error, Reason}
    end.

%% @spec stats(File) -> {error, Reason} | ok
%% File = iolist() | binary()
%% @doc analyse the entry size distribution
stats(File) ->
    case file:open(File, [read, binary]) of
        {error, Reason} ->
            {error, Reason};
        {ok, IoDev} ->
            lists:foreach(fun({Size, Count}) -> io:format("~w\t~w~n", [Size, Count]) end, stats_run(IoDev))
    end.

%%----------------------------------------------------------------
%% 私有函数
%%----------------------------------------------------------------
cisc_base(Base) ->
    case file:open(Base, [read, binary]) of
        {error, Reason} ->
            ?ERR("read base file error, reason ~w", [Reason]),
            error;
        {ok, IoDev} ->
            cisc_base_by_line(IoDev),
            file:close(IoDev)
    end.

cisc_base_by_line(IoDev) ->
    case file:open("../src/lang/cisc_0.txt", [write]) of
        {ok, IoDev1} ->
            case file:open("../src/lang/cisc_1.txt", [write]) of
                {ok, IoDev2} ->
                    cisc_base_by_line(IoDev, 1, IoDev1, IoDev2),
                    file:close(IoDev2);
                {error, Reason} ->
                    Reason
            end,
            file:close(IoDev1);
        {error, Reason} ->
            Reason
    end.

cisc_base_by_line(IoDev, Line, IoDev1, IoDev2) ->
    case file:read_line(IoDev) of
        eof ->
            eof;
        {error, Reason} ->
            ?ERR("read line error, reason ~w", [Reason]),
            error;
        {ok, Bin} ->
            cisc_base_line_data(Bin, Line, IoDev1, IoDev2),
            cisc_base_by_line(IoDev, Line + 1, IoDev1, IoDev2)
    end.

cisc_base_line_data(<<Pre:?pre_head/binary, Rem/binary>>, Line, IoDev1, IoDev2) when Pre =:= <<"[S]:">> ->
    cisc_data(Rem, Line, IoDev1, IoDev2);
cisc_base_line_data(<<Pre:?pre_head/binary, Rem/binary>>, _Line, _IoDev1, _IoDev2) when Pre =:= <<"[F]:">> ->
    put(cisc_file_path, lutil:nocrlf(Rem));
cisc_base_line_data(<<Pre:?pre_head/binary, Rem/binary>>, _Line, _IoDev1, _IoDev2) when Pre =:= <<"[T]:">> ->
    case get(current_bin) of
        undefined -> ?ERR("current_bin undefined");
        {NewBin, Path, Bin, Line} -> put({NewBin, Path}, {Bin, Line, lutil:nocrlf(Rem)})
    end;
cisc_base_line_data(_Bin, _Line, _IoDev1, _IoDev2) -> ok.

cisc_data(Bin, Line, IoDev1, IoDev2) ->
    NewBin = lutil:nocrlf(cisc_clean_data(Bin)),
    file:write(IoDev1, io_lib:format("~w:~s", [Line, Bin])),
    file:write(IoDev2, io_lib:format("~w:~s", [Line, NewBin])),
    case get(cisc_file_path) of
        undefined -> ?ERR("cisc_file_path undefined");
        Path -> put(current_bin, {NewBin, Path, Bin, Line})
    end.

%% —   2014        %% "    0022
%% ‘   2018        %% .    002E
%% ’   2019        %% <    003C
%% “   201C        %% >    003E
%% ”   201D        %% !    0021
%% 。   3002        %% ,    002C
%% 《   300A        %% :    003A
%% 》   300B        %% ;    003B
%% ！   FF01        %% ?    003F
%% （   FF08        %% (    0028
%% ）   FF09        %% )    0029
%% ，   FFOC
%% ：   FF1A
%% ；   FF1B
%% ？   FF1F

cisc_clean_data(Bin) ->
    case get(cisc_re) of
        undefined ->
            case re:compile("[\\x{0020}\\x{0027}\\x{0022}\\x{002E}\\x{003C}\\x{003E}\\x{0021}\\x{002C}\\x{003A}\\x{003B}\\x{003F}\\x{0028}\\x{0029}\\x{002D}\\x{2014}\\x{2018}\\x{2019}\\x{201C}\\x{201D}\\x{3002}\\x{300A}\\x{300B}\\x{FF01}\\x{FF08}\\x{FF09}\\x{FF0C}\\x{FF1A}\\x{FF1B}\\x{FF1F}]", [unicode]) of
                {ok, MP} ->
                    put(cisc_re, MP),
                    re:replace(Bin, MP, <<>>, [global, {return, binary}]);
                {error, ErrSpec} ->
                    ?ERR("compile re error, reason ~w", [ErrSpec]),
                    Bin
            end;
        MP -> re:replace(Bin, MP, <<>>, [global, {return, binary}])
    end.

cisc_undone(UnDone) ->
    case file:open(UnDone, [read, binary]) of
        {error, Reason} ->
            ?ERR("read undone file error, reason ~w", [Reason]),
            error;
        {ok, IoDev} ->
            cisc_undone_by_line(IoDev),
            file:close(IoDev)
    end.

cisc_undone_by_line(IoDev) ->
    case file:open("../src/lang/cisc.txt", [write]) of
        {ok, IoDev1} ->
            cisc_undone_by_line(IoDev, 1, IoDev1),
            file:close(IoDev1);
        {error, Reason} ->
            Reason
    end.

cisc_undone_by_line(IoDev, Line, IoDev1) ->
    case file:read_line(IoDev) of
        eof ->
            eof;
        {error, Reason} ->
            ?ERR("read line ~w error, reason ~w", [Line, Reason]),
            error;
        {ok, Bin} ->
            cisc_undone_line_data(Bin, Line, IoDev1),
            cisc_undone_by_line(IoDev, Line + 1, IoDev1)
    end.

cisc_undone_line_data(<<Pre:?pre_head/binary, Rem/binary>>, Line, IoDev) when Pre =:= <<"[S]:">> -> cisc_undone_data(Rem, Line, IoDev);
cisc_undone_line_data(<<Pre:?pre_head/binary, Rem/binary>>, _Line, _IoDev) when Pre =:= <<"[F]:">> ->
    put(cisc_file_path, lutil:nocrlf(Rem));
cisc_undone_line_data(_Bin, _Line, _IoDev) -> ok.

cisc_undone_data(Bin, Line, IoDev) ->
    NewBin = lutil:nocrlf(cisc_clean_data(Bin)),
    case get(cisc_file_path) of
        undefined -> ?ERR("cisc file path undefined");
        Path ->
            case get({NewBin, Path}) of
                undefined -> ok;
                {OldBin, OldLine, Trans} ->
                    file:write(IoDev, io_lib:format("file:~s~npreline:~w    nowline:~w~npre:~snow:~s[T]:~s~n~n", [Path, OldLine, Line, OldBin, Bin, Trans]))
            end
    end.

lib_tr(DetsName, LibDetsName) ->
    Lang = fun(Lang) -> lib_tr_new_lang(Lang, LibDetsName) end,
    Lans = lists:keysort(#lang.index, dets:foldl(fun(Elem, Acc) -> [Lang(Elem)|Acc] end, [], DetsName)),
    dets:insert(DetsName, Lans).

lib_tr_new_lang(Lang = #lang{dicts = Dicts}, LibDetsName) ->
    Lang#lang{dicts = lib_tr_new_dicts(Dicts, LibDetsName)}.

lib_tr_new_dicts(Dicts, DetsName) ->
    lib_tr_new_dicts(Dicts, [], DetsName).

lib_tr_new_dicts([], Dicts, _DetsName) -> Dicts;
lib_tr_new_dicts([Dict = #dict{cn = Cn, status = false} | Dicts], NewDicts, DetsName) ->
    case dets:lookup(DetsName, Cn) of
        [] ->
            lib_tr_new_dicts(Dicts, [Dict | NewDicts], DetsName);
        [#word{tr = Tr}] ->
            lib_tr_new_dicts(Dicts, [Dict#dict{tr = Tr, status = true} | NewDicts], DetsName);
        {error, Reason} ->
            ?ERR("dets lookup error, ~w", [Reason]),
            lib_tr_new_dicts(Dicts, [Dict | NewDicts], DetsName)
    end;
lib_tr_new_dicts([Dict | Dicts], NewDicts, DetsName) ->
    lib_tr_new_dicts(Dicts, [Dict | NewDicts], DetsName).

get_language_pair_list(server) ->
    dets:open_file(?lang_server_dets_name, [{file, ?lang_server_dets}, {keypos, #lang.file}, {type, set}]),
    Lans = lists:keysort(#lang.index, dets:foldl(fun(Elem, Acc) -> [Elem | Acc] end, [], ?lang_server_dets_name)),
    get_language_pair_list(Lans, []).

get_language_pair_list([], Pairs) ->
    lists:reverse(Pairs);
get_language_pair_list([#lang{dicts = Dicts} | Lang], Pairs) ->
    NewDicts = lists:keysort(#dict.index, [Dict || Dict <- Dicts]),
    NewPairs = dict_to_pair(NewDicts, Pairs),
    get_language_pair_list(Lang, NewPairs).

dict_to_pair([], Pairs) -> Pairs;
dict_to_pair([#dict{cn = Cn, tr = Tr} | Dicts], Pairs) ->
    case lists:keyfind(Cn, 1, Pairs) of
        false -> dict_to_pair(Dicts, [{Cn, Tr} | Pairs]);
        _ -> dict_to_pair(Dicts, Pairs)
    end.

%% analyse the entry size distribution
stats_run(IoDev) ->
    stats_run(IoDev, []).

stats_run(IoDev, List) ->
    case file:read_line(IoDev) of
        eof ->
            lists:keysort(1, List);
        {error, _Reason} ->
            ?ERR("read line error [error:~w]", [_Reason]),
            lists:keysort(1, List);
        {ok, Bin} ->
            BinSize = byte_size(Bin),
            case BinSize >= ?pre_head of
                true ->
                    <<Pre:?pre_head/binary, _Rem/binary>> = Bin,
                    case Pre of
                        <<"[S]:">> ->
                            Size = BinSize - ?pre_head,
                            case lists:keyfind(Size, 1, List) of
                                false ->
                                    stats_run(IoDev, [{Size, 1} | List]);
                                {_Size, Count} ->
                                    stats_run(IoDev, lists:keyreplace(Size, 1, List, {Size, Count + 1}))
                            end;
                        _ ->
                            stats_run(IoDev, List)
                    end;
                _ ->
                    stats_run(IoDev, List)
            end
    end.

%% @spec distribute(LanguageEntryPairs) -> ok
%% LanguageEntryPairs = [{Cn, Tr} |...]
%% Cn = Tr = binary()
%% @doc distribute the language pack by the entry size, return an descending order list of the second key
distribute(LEP) ->
    Dlep = distribute(LEP, []),
    Group = group(Dlep),
    {Dlep, Group}.

distribute([], PreLEP) ->
    lists:reverse(lists:keysort(2, PreLEP));
distribute([{Cn, Tr} | LEP], PreLEP) ->
    Size = byte_size(Cn),
    case lists:keyfind(Size, 1, PreLEP) of
        false -> distribute(LEP, [{Size, 1, [{Cn, Tr}]} | PreLEP]);
        {_, Count, List} -> distribute(LEP, lists:keyreplace(Size, 1, PreLEP, {Size, Count + 1, [{Cn, Tr} | List]}))
    end.

group(Lep) ->
    group(Lep, [], [], 1).
group([], [], Group, _GroupNum) ->
    Group;
group([], TempLep, Group, GroupNum) ->
    GroupIncSizes = [Size || {Size, _Count, _EntryList} <- TempLep],
    group([], [], [{GroupNum, GroupIncSizes} |Group], GroupNum + 1);
group([{Size, Count, _EntryList} | Lep], TempLep, Group, GroupNum) when Count >= 100 ->
    group(Lep, TempLep, [{GroupNum, [Size]} |Group], GroupNum + 1);
group([{Size, Count, EntryList} | Lep], TempLep, Group, GroupNum) ->
    AlreadyCount = lists:foldl(fun({_, C, _}, Acc) -> C + Acc end, 0, TempLep),
    case (AlreadyCount + Count) >= 100 of
        true ->
            GroupIncSizes = [S || {S, _Count, _EntryList} <- TempLep],
            group(Lep, [{Size, Count, EntryList}], [{GroupNum, GroupIncSizes} |Group], GroupNum + 1);
        false ->
            group(Lep, [{Size, Count, EntryList} | TempLep], Group, GroupNum)
    end.

gen_lan_erl(_IoDev, [], _) -> ok;
gen_lan_erl(IoDev, [{GroupNum, Sizes} | Group], Dlep) ->
    FunName = util:fbin("get_~w", [GroupNum]),
    gen_lan_fun(IoDev, FunName, Sizes, Dlep),
    gen_lan_erl(IoDev, Group, Dlep).


gen_lan_fun(IoDev, FunName, [], _Dlep) ->
    file:write(IoDev, io_lib:format("~s(Bin) -> \n\tBin.\n\n", [FunName]));
gen_lan_fun(IoDev, FunName, [Size | Sizes], Dlep) ->
    case lists:keyfind(Size, 1, Dlep) of
        false ->
            io:format("gen_lan_fun error , can not find the data of size ~w~n", [Size]);
        {_, _, EntryList} ->
            gen_lan_fun_entry(IoDev, FunName, Size, EntryList)
    end,
    gen_lan_fun(IoDev, FunName, Sizes, Dlep).

gen_lan_fun_entry(_IoDev, _FunName, _Size, []) ->
    ok;
gen_lan_fun_entry(IoDev, FunName, Size, [{Cn, Tr} | EntryList]) ->
    TrSize = byte_size(Tr),
    case TrSize > 0 of
        true ->
            case binary:part(Cn, Size - 2, 1) of  %% 词条最后字符是 "
                <<"\\">> -> file:write(IoDev, io_lib:format("~s(<<~s\\\">>) ->\n\t<<~s\\\"\>>;\n", [FunName, binary:part(Cn, 0, Size - 1), binary:part(Tr, 0, TrSize - 1)]));
                _ -> file:write(IoDev, io_lib:format("~s(<<~s>>) ->\n\t<<~s>>;\n", [FunName, Cn, Tr]))
            end;
        false -> ok
    end,
    gen_lan_fun_entry(IoDev, FunName, Size, EntryList).


size_to_group_str(Group) ->
    size_to_group_str(Group, []).
size_to_group_str([], StrList) ->
    lists:reverse([ <<"size_to_group(_) -> error.\n\n">> |StrList]);
size_to_group_str([{GroupNo, Sizes} |Group], StrList) ->
    SFNL = [util:fbin("size_to_group(~w) -> get_~w;\n", [Size-2, GroupNo]) || Size <- Sizes],
    size_to_group_str(Group, [SFNL | StrList]).

%% 导出服务端语言包, 不带索引
gen(_IoDev, []) -> ok;
gen(IoDev, [{Cn, Tr} | Pairs]) ->
    CnSize = byte_size(Cn),
    TrSize = byte_size(Tr),
    case TrSize > 0 of
        true ->
            case binary:part(Cn, CnSize - 2, 1) of  %% 词条最后字符是 "
                <<"\\">> -> file:write(IoDev, io_lib:format("get(<<~s\\\">>) ->\n\t<<~s\\\"\>>;\n", [binary:part(Cn, 0, CnSize - 1), binary:part(Tr, 0, TrSize - 1)]));
                _ -> file:write(IoDev, io_lib:format("get(<<~s>>) ->\n\t<<~s>>;\n", [Cn, Tr]))
            end;
        false -> ok
    end,
    gen(IoDev, Pairs).

%% 语言包性能测试
test(Time, Num) when Time > 0 andalso Num > 0 ->
    ReList = test(Time, Num, []),
    {{A, B}, {C, D}} = lists:foldl(
        fun({{Uo1, Uo2}, {Ut1, Ut2}}, {{TUo1, TUo2}, {TUt1, TUt2}}) ->
                {{Uo1 + TUo1, Uo2 + TUo2}, {Ut1 + TUt1, Ut2 + TUt2}} end, {{0,0}, {0,0}}, ReList),
    io:format("none index:time:~w\tNum:~w\tcpu:~w us\tact:~w us\n", [Time, Num, A/Time, B/Time]),
    io:format("size index:time:~w\tNum:~w\tcpu:~w us\tact:~w us\n", [Time, Num, C/Time, D/Time]),
    ok;
test(_Time, _Num) ->
    error.

test(0, _Num, Result) ->
    Result;
test(Time, Num, Result) ->
    io:format("time is ~w~n", [Time]),
    test(Time - 1, Num, [test(Num) | Result]).

test(Num) ->
    CnTrs = get_language_pair_list(server),
    Len = length(CnTrs),
    io:format("generate test cns...~n"),
    TestCns = gen_cn(CnTrs, Len, Num, []),
    io:format("staring...~n"),
    statistics(runtime),
    statistics(wall_clock),
    start_one(TestCns),
    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    statistics(runtime),
    statistics(wall_clock),
    start_two(TestCns),
    {_, Time3} = statistics(runtime),
    {_, Time4} = statistics(wall_clock),
    Uone1 = Time1 * 1000/Num,
    Uone2 = Time2 * 1000/Num,
    Utwo1 = Time3 * 1000/Num,
    Utwo2 = Time4 * 1000/Num,
    io:format("none index:Num:~w\tcpu:~w us\tact:~w us\n", [Num, Uone1, Uone2]),
    io:format("size index:Num:~w\tcpu:~w us\tact:~w us\n", [Num, Utwo1, Utwo2]),
    {{Uone1, Uone2}, {Utwo1, Utwo2}}.

gen_cn(_CnTrs, _Length, Num, Cns) when Num =< 0 ->
    Cns;
gen_cn(CnTrs, Length, Num, Cns) ->
    {Cn, _Tr} = lists:nth(util:rand(1, Length), CnTrs),
    gen_cn(CnTrs, Length, Num - 1, [Cn | Cns]).


start_one([]) ->
    ok;
start_one([Cn | Cns]) ->
    language:get(Cn),
    start_one(Cns).

start_two([]) ->
    ok;
start_two([Cn | Cns]) ->
    language2:get(Cn),
    start_two(Cns).


