%% ----------------------------------------------------
%% 服务端翻译处理模块
%% @author weihua@jieyou.cn 
%% ----------------------------------------------------
-module(lserver).
-export([
         ext/0
        ,export/1
        ,import/1
        ,transfer/1
        ,gen/0
        ,lib/0
        ,update/0
        ,set_ver/1
        ,trincn/1
        ,changed_cn/2
        ,arg/1
        ,dqm/1
    ]
).

-include_lib("kernel/include/file.hrl").
-include_lib("xmerl/include/xmerl.hrl").
-include("common.hrl").
-include("lserver.hrl").
-include("ldata.hrl").
-include("lutil.hrl").

%% --------------------------------------------------------------------------------
%% 宏定义
%% --------------------------------------------------------------------------------
-define(server_dets_name, server_dets).                         %% dets 名字
-define(server_dets_file, "../src/lang/server.dets").           %% dets 文件路径
-define(server_done_xml_file, "../src/lang/server_done.xml").   %% 语言包文件路径
-define(server_undone_xml_file, "../src/lang/server_undone.xml").   %% 语言包文件路径
-define(server_ext_re, "\\?L\\(<<\"(.*)\">>\\)").       %% 抽取简体正则 ?L(<<"六味">>)
-define(server_ext_re_two, "language:get\\(<<\"(.*)\">>\\)").  %% 抽取data文件中的中文

%% @spec ext() -> ok
%% @doc 抽取服务端语言包
ext() ->
    ext(one),
    ext(two).

%% @spec ext(server) -> ok
%% @doc 抽取服务端语言包
ext(one) ->
    init_word_index(),
    case re:compile(?server_ext_re, [unicode, ungreedy]) of
        {error, _ErrSpec} ->
            ?ERR("编译正则发生错误 [re:~w] [error:~w]", [?server_ext_re, _ErrSpec]),
            ok;
        {ok, MP} ->
            dets:open_file(?server_dets_name, [{file, ?server_dets_file}, {keypos, #word.cn}, {type, set}]),
            ?INFO("开始抽取出中文..."),
             case ext_server_files(file_list(server), MP, ?server_dets_name) of
                 ok -> ok;
                 Result -> lists:foreach(fun(Error) -> ?ERR("~s", [Error]) end, Result)
             end,
            dets:close(?server_dets_name),
            ?INFO("抽取完成"),
            ok
    end;

%% @spec ext(data) -> ok
%% @doc 抽取服务端语言包
ext(two) ->
    init_word_index(),
    case re:compile(?server_ext_re_two, [unicode, ungreedy]) of
        {error, _ErrSpec} ->
            ?ERR("编译正则发生错误 [re:~w] [error:~w]", [?server_ext_re_two, _ErrSpec]),
            ok;
        {ok, MP} ->
            dets:open_file(?server_dets_name, [{file, ?server_dets_file}, {keypos, #word.cn}, {type, set}]),
            ?INFO("开始抽取出中文..."),
            case ext_server_files(file_list(server), MP, ?server_dets_name) of
                 ok -> ok;
                 Result -> lists:foreach(fun(Error) -> ?ERR("~s", [Error]) end, Result)
             end,
            dets:close(?server_dets_name),
            ?INFO("抽取完成"),
            ok
    end.

%% @spec export(Type) -> ok
%% @doc 导出语言包
export(Type) ->
    DetsName = ?server_dets_name,
    DetsPath = ?server_dets_file,
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
    Words = lists:keysort(#word.index, dets:foldl(fun(Word, Acc) -> [Word | Acc] end, [], DetsName)),
    dets:close(DetsName),
    {File, ExportWords} = case Type of 
        done -> {"../src/lang/server_done.xml", [[integer_to_list(Index), Cn, Tr] || #word{index = Index, cn = Cn, tr = Tr, ver = 1} <- Words, Tr =/= <<>>]};
        undone -> {"../src/lang/server_undone.xml", [[integer_to_list(Index), Cn, <<>>] || #word{index = Index, cn = Cn, tr = <<>>, ver = 1} <- Words]}
    end,
    xmserl:generate(File, [["index","cn","tr"]|ExportWords]).

%% @spec set_ver(Ver) -> ok
%% @doc 设置版本
set_ver(Ver) when Ver =:= 0 orelse Ver =:= 1 ->
    DetsName = ?server_dets_name,
    DetsPath = ?server_dets_file,
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
    Words = dets:foldl(fun(Word, Acc) -> [Word#word{ver = 0} | Acc] end, [], DetsName),
    dets:insert(DetsName, Words),
    dets:close(DetsName).

%% @spec transfer(File) -> ok
%% File = string()
%% @spec 转换以前的翻译格式
transfer(File) ->
    init_word_index(),
    DetsName = ?server_dets_name,
    DetsPath = ?server_dets_file,
    case file:read_file(File) of
        {error, Reason} ->
            ?ERR("read file error [file:~s] [reason:~w]", [File, Reason]),
            ok;
        {ok, Bin} ->
            dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
            transfer(DetsName, Bin),
            dets:close(DetsName),
            ok
    end.

%% @spec gen() -> ok
%% @doc 生成 languge ERL 文件
gen() ->
    DetsName = ?server_dets_name,
    DetsPath = ?server_dets_file,
    case file:open("../src/lang/language.erl", [write]) of
        {ok, IoDev} ->
            ?INFO("开始生成语言包文件 language.erl ..."),
            dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
            Words = dets:foldl(fun(Word, Acc) -> [Word | Acc] end, [], DetsName),
            NewWords = lists:keysort(#word.index, [W || W = #word{tr = Tr} <- Words, Tr =/= <<>>]),
            file:write(IoDev, "%%------------------------------\n%% 语言包\n%%------------------------------\n"),
            file:write(IoDev, "-module(language).\n-export([get/1]).\n\n"),
            gen(IoDev, NewWords),
            file:write(IoDev, "get(Bin) -> Bin."),
            ?INFO("生成完毕！"),
            dets:close(DetsName),
            file:close(IoDev);
        {error, Reason} ->
            {error, Reason}
    end.

%% @spec lib() -> ok
%% @doc 导入到词库
lib() ->
    DetsName = ?server_dets_name,
    DetsPath = ?server_dets_file,
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
    Fun = fun(#word{cn = Cn, tr = Tr}, Acc) -> [{Cn, Tr} | Acc] end,
    Words = dets:foldl(Fun, [], DetsName),
    lutil:open_lib(),
    lutil:lib(Words),
    lutil:close_lib(),
    dets:close(DetsName).

%% @spec update() -> ok
%% @doc 尝试去词库找翻译
update() ->
    DetsName = ?server_dets_name,
    DetsPath = ?server_dets_file,
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
    Fun = fun(Word, Acc) -> [Word | Acc] end,
    Words = dets:foldl(Fun, [], DetsName),
    lutil:open_lib(),
    Fun = fun(Word = #word{cn = Cn, tr = Tr}) ->
            case Tr =:= <<>> of
                true ->
                    case lutil:lib_lookup(Cn) of
                        false -> Word;
                        NewTr -> Word#word{tr = NewTr}
                    end;
                false -> Word
            end
    end,
    NewWords = lists:map(Fun, Words),
    dets:insert(DetsName, NewWords),
    lutil:close_lib(),
    dets:close(DetsName).

%% @spec path(Type) -> ok
%% Type = done | undone
%% @doc 导入翻译
import(File) ->
    init_word_index(),
    DetsName = ?server_dets_name,
    DetsPath = ?server_dets_file,
    {XmlElement, _} = xmerl_scan:file(File),
    [_H | Rows] = xmerl_xpath:string("//Row", XmlElement),
    Words = lists:foldl(fun(Row, Acc) ->
                [EI, EC, ET | _ ] = xmerl_xpath:string("//Data", Row),
                Index = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", EI)]),
                Cn = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", EC)]),
                Tr = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", ET)]),
                [{list_to_integer(Index), unicode:characters_to_binary(Cn), unicode:characters_to_binary(Tr)} | Acc]
        end, [], Rows),
    OrderWords = lists:keysort(1, Words),
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
    ?INFO("开始导入..."),
    lists:foreach(fun({_Index, Cn, Tr}) -> insert(DetsName, Cn, Tr) end, OrderWords),
    ?INFO("导入完成"),
    dets:close(DetsName).

%% @spec trincn(File) -> ok
%% @doc 检测翻译是否含有中文
trincn(File) ->
    case re:compile("[\x{4e00}-\x{9fff}]*[\x{4e00}-\x{9fff}]", [unicode]) of
        {ok, MP} ->
            {M, _R} = xmerl_scan:file(File),
            [_H | Rows] = xmerl_xpath:string("//Row", M),
            ErrorWords = lists:foldl(fun(Row, Acc) ->
                        [EI, _EC, ET | _] = xmerl_xpath:string("//Data", Row),
                        Index = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", EI)]),
                        Tr = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", ET)]),
                        case re:run(Tr, MP) of
                            nomatch -> Acc;
                            {match , _} -> [{list_to_integer(Index), unicode:characters_to_binary(Tr)} | Acc]
                        end
                end, [], Rows),
            case ErrorWords of
                [] -> ok;
                _ ->
                    case file:open("../src/lang/server_translation_error.txt", [write, append]) of
                        {ok, IoDev} ->
                            file:write(IoDev, io_lib:format("第一类：翻译内容中含有中文字符, 对应文件: ~s\n", [filename:basename(File)])),
                            lists:foreach(fun({K, V}) -> file:write(IoDev, io_lib:format("第 [~w] 个翻译内容中有中文字符 ~n[~s]~n~n", [K, V])) end, lists:keysort(1, ErrorWords)),
                            file:close(IoDev);
                        {error, Reason} ->
                            ?ERR("打开文件 [~s] 失败: ~w", [<<"../src/lang/server_translation_error.txt">>, Reason]),
                            lists:foreach(fun({K, V}) -> ?ERR("第 [~w] 个翻译内容中有中文字符 ~n[~s]\n", [K, V]) end, ErrorWords),
                            ok
                    end
            end;
        {error, Reason} ->
            ?ERR("compile re error, ~w",[Reason])
    end.

%% @spec changed_cn(OriginFile, NewFile) -> ok
%% @doc 检测简体部分有没有被修改
changed_cn(Origin, New) ->
    {OM, _OR} = xmerl_scan:file(Origin),
    [_OH | ORows] = xmerl_xpath:string("//Row", OM),
    OWords = lists:foldl(fun(Row, Acc) ->
                [OEI, OEC, _OET | _] = xmerl_xpath:string("//Data", Row),
                Index = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", OEI)]),
                Cn = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", OEC)]),
                [{list_to_integer(Index), unicode:characters_to_binary(Cn)} | Acc]
        end, [], ORows),
    {NM, _NR} = xmerl_scan:file(New),
    [_NH | NRows] = xmerl_xpath:string("//Row", NM),
    NWords = lists:foldl(fun(Row, Acc) ->
                [NEI, NEC, _NET | _] = xmerl_xpath:string("//Data", Row),
                Index = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", NEI)]),
                Cn = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", NEC)]),
                [{list_to_integer(Index), unicode:characters_to_binary(Cn)} | Acc]
        end, [], NRows),
    do_changed_cn(lists:keysort(1, OWords), lists:keysort(1, NWords)).

do_changed_cn([], []) -> ok;
do_changed_cn([{K, V} |OWords], [{K, V} | NWords]) ->
    do_changed_cn(OWords, NWords);
do_changed_cn([{K, _V1} |OWords], [{K, _V2} | NWords]) ->
    ?ERR("第 [~w] 个词条中文被修改了", [K]),
    do_changed_cn(OWords, NWords);
do_changed_cn([{_K, _V} |_OWords], [{_K1, _V1} | _NWords]) ->
    ?ERR("第 [~w] 个词条匹配不上了，已终止", [_K]),
    ok.

%% @spec arg(File) -> ok
%% @doc 检测翻译中参数问题
arg(File) ->
    {M, _R} = xmerl_scan:file(File),
    [_H | Rows] = xmerl_xpath:string("//Row", M),
    Words = lists:foldl(fun(Row, Acc) ->
                [EI, EC, ET | _] = xmerl_xpath:string("//Data", Row),
                Index = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", EI)]),
                Cn = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", EC)]),
                Tr = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", ET)]),
                [{list_to_integer(Index), unicode:characters_to_binary(Cn), unicode:characters_to_binary(Tr)} | Acc]
        end, [], Rows),
    case file:open("../src/lang/server_translation_error.txt", [write, append]) of
        {ok, IoDev} ->
            file:write(IoDev, io_lib:format("\n第二类：特殊符号 对不上，请检查是否遗漏或多余，可能引发严重 bug, 对应文件: ~s\n", [filename:basename(File)])),
            do_arg(IoDev, lists:keysort(1, Words)),
            file:close(IoDev);
        {error, Reason} ->
            ?ERR("打开文件 [~s] 失败: ~w", [<<"../src/lang/server_translation_error.txt">>, Reason]),
            ok
    end.

do_arg(_IoDev, []) ->
    ok;
do_arg(IoDev, [{Index, Cn, Tr} | Words]) ->
    CnArgs = get_arg_char(Cn),
    TrArgs = get_arg_char(Tr),
    case CnArgs =:= TrArgs of
        true -> do_arg(IoDev, Words);
        false ->
            file:write(IoDev, io_lib:format("第 ~w 个词条参数对不上 原始参数顺序是 [~s] 翻译内容中是[~s]~n", [Index, CnArgs, TrArgs])),
            do_arg(IoDev, Words)
    end.

%% double_quotation_marks 
%% @spec dqm(File) -> ok
%% @doc 检测翻译中含有双引号
dqm(File) ->
    {M, _R} = xmerl_scan:file(File),
    [_H | Rows] = xmerl_xpath:string("//Row", M),
    Words = lists:foldl(fun(Row, Acc) ->
                [EI, _EC, ET | _] = xmerl_xpath:string("//Data", Row),
                Index = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", EI)]),
                Tr = lists:flatten([V || #xmlText{value = V} <- xmerl_xpath:string("text()", ET)]),
                [{list_to_integer(Index), unicode:characters_to_binary(Tr)} | Acc]
        end, [], Rows),
    do_dqm(Words).
do_dqm([]) -> ok;
do_dqm([{Index, Str} | Words]) ->
    do_dqm(Index, Str, <<>>),
    do_dqm(Words).

do_dqm(_Index, <<>>, _Pre) -> ok;
do_dqm(Index, <<Ch:1/binary, Str/binary>>, Pre) ->
    case Ch =:= <<"\"">> of
        true when Pre =/= <<"\\">> ->
            ?ERR("第 ~w 个词条含有非法双引号", [Index]);
        _ -> do_dqm(Index, Str, Ch)
    end.

%% -------------------------------------------------------------------------------
%% 私有函数
%% -------------------------------------------------------------------------------
%% 服务端源码文件列表
file_list(server) ->
    {ok, Cwd} = file:get_cwd(),
    SrcFiles = lutil:ls(Cwd ++ "/../src"),
    IncFiles = lutil:ls(Cwd ++ "/../inc"),
    Files = lutil:file_filter(SrcFiles ++ IncFiles, [".hrl", ".erl"]),
    [list_to_binary(FilePath) || FilePath <- remove_ignore_files(Files)].

%% 过滤忽略的文件
remove_ignore_files(FileLists) ->
    remove_ignore_files(FileLists, ignore_files()).
remove_ignore_files(FileLists, []) -> FileLists;
remove_ignore_files(FileLists, [IgnoreFile | IgnoreFiles]) ->
    remove_ignore_files(lists:delete(IgnoreFile, FileLists), IgnoreFiles).

%% 获取需要过滤的文件列表
ignore_files() ->
    {ok, Cwd} = file:get_cwd(),
    Files1 = ignore_files_dir_ext(Cwd, ?common_ignore_dirs_exts),
    Files2 = [Cwd ++ File ||File <- ?common_ignore_files],
    Files3 = [Cwd ++ File ||File <- ?ignore_files],
    Files1 ++ Files2 ++ Files3.

ignore_files_dir_ext(Cwd, DirExts) ->
    ignore_files_dir_ext(Cwd, DirExts, []).
ignore_files_dir_ext(_Cwd, [], FileLists) -> 
    FileLists;
ignore_files_dir_ext(Cwd, [{Dir, Ext} | DirExts], FileLists) ->
    Files = lutil:file_filter(lutil:ls(Cwd ++ Dir), [Ext]),
    ignore_files_dir_ext(Cwd, DirExts, Files ++ FileLists).

%% -------------------------------------------------
%% 抽取中文
%% -------------------------------------------------
%% 抽取中文，开始处理服务端文件列表
ext_server_files(FileList, MP, DetsName) ->
    ext_server_files(FileList, MP, DetsName, []).

ext_server_files([], _MP, _DetsName, []) -> ok;
ext_server_files([], _MP, _DetsName, Fails) -> Fails;
ext_server_files([File | FileList], MP, DetsName, Fails) ->
    case file:read_file(File) of
        {error, Reason} ->
            ext_server_files(FileList, MP, DetsName, [util:fbin("open file error [file:~s] [reason:~w]", [File, Reason]) | Fails]);
        {ok, Bin} ->
            ?INFO("开始抽取文件[~s]", [File]),
            case re:run(Bin, MP, [global, {capture, [1], binary}]) of
                nomatch ->
                    ext_server_files(FileList, MP, DetsName, Fails);
                {match, M} ->
                    save_entry(Bin, M, DetsName),
                    ext_server_files(FileList, MP, DetsName, Fails)
            end
    end.

%% 将抽取出来的数据回写dets
save_entry(_Bin, [], _DetsName) ->
    ok;
save_entry(Bin, [[Cn] | M], DetsName) ->
    insert(DetsName, Cn, <<>>),
    save_entry(Bin, M, DetsName).

insert(DetsName, CnBin, TrBin) ->
    case dets:lookup(DetsName, CnBin) of
        [Word] when TrBin =/= <<>> ->
            dets:insert(DetsName, Word#word{tr = TrBin, ver = 1});
        [Word] ->
            dets:insert(DetsName, Word#word{ver = 1});
        _ -> 
            NextIndex = case get(word_index) of
                undefined -> 1;
                Index -> Index
            end,
            put(word_index, NextIndex + 1),
            dets:insert(DetsName, #word{cn = CnBin, tr = TrBin, ver = 1, index = NextIndex})
    end.

%% 初始化 DETS 
init_word_index() ->
    dets:open_file(?server_dets_name, [{file, ?server_dets_file}, {keypos, #word.cn}, {type, set}]),
    erase(word_index),
    Max  = dets:foldl(fun(#word{index = Index}, Acc) ->
                case Index > Acc of
                    true -> Index;
                    false -> Acc 
                end
        end, 1, ?server_dets_name),
    put(word_index, Max),
    dets:close(?server_dets_name).

transfer(DetsName, Bin) ->
    try re:run(Bin, "\\[F\\]:.*\\[E\\]:", [unicode, global, ungreedy, dotall]) of
        {match, M} ->
            transfer(Bin, M, DetsName);
        nomatch ->
            ?ERR("翻译文件中匹配不到任何 文件块 数据")
    catch
        Error:Info -> 
            ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
            error
    end.

transfer(_Bin, [], _DetsName) ->
    ok;
transfer(Bin, [[{P, L}]| M], DetsName) ->
    transfer_file(binary:part(Bin, P, L), DetsName),
    transfer(Bin, M, DetsName).

transfer_file(Bin, DetsName) ->
    try re:run(Bin, "(?<=\\[F\\]:).*(?=\\[S\\]:)", [unicode, global, ungreedy, dotall]) of
        {match, [[{P, L}]]} ->
            FilePath = lutil:nocrlf(binary:part(Bin, P, L)),
            ?INFO("开始导入文件[~s]", [FilePath]),
            transfer_file(Bin, DetsName, FilePath);
        nomatch ->
            ?ERR("匹配不出文件路径")
    catch
        Error:Info -> 
            ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
            error
    end.

transfer_file(Bin, DetsName, FilePath) ->
    try re:run(Bin, "(?<=\\[S\\]:).*(?=\\[T\\]:)", [unicode, global, ungreedy, dotall]) of
        {match, CnM} ->
            try re:run(Bin, "(?<=\\[T\\]:).*(?=(\\[E\\]:|\\[S\\]:))", [unicode, global, ungreedy, dotall]) of
                {match, TrM} when length(CnM) =:= length(TrM) ->
                    transfer_entry(Bin, CnM, TrM, DetsName);
                nomatch ->
                    ?ERR("文件块 [~s] 匹配不出任何翻译词条数据文件", [FilePath]),
                    error;
                {match, TrM} ->
                    ?ERR("文件词条数目对不上 [cn: ~w] [tr: ~w] [file:~s]", [length(CnM), length(TrM), FilePath]),
                    error
            catch
                Error:Info -> 
                    ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
                    error
            end;
        nomatch ->
            ?ERR("文件块 [~s] 匹配不出任何简体词条数据文件", [FilePath])
    catch
        Error:Info -> 
            ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
            error
    end.

transfer_entry(_Bin, [], _TrM, _DetsName) ->
    ok;
transfer_entry(Bin, [[{CnP, CnL}]|CnM],  [[{TrP, TrL}, _]|TrM], DetsName) ->
    CnEntry = lutil:nocrlf(binary:part(Bin, CnP, CnL)),
    TrEntry = lutil:nocrlf(binary:part(Bin, TrP, TrL)),
    case TrEntry of
        <<>> -> 
            ?ERR("词条 [~s] 未翻译", [CnEntry]),
            insert(DetsName, rid_quote(CnEntry), rid_quote(TrEntry));
        _ ->
            insert(DetsName, rid_quote(CnEntry), rid_quote(TrEntry))
    end,
    transfer_entry(Bin, CnM, TrM, DetsName).

rid_quote(B = << Byte:1/binary, Rem/binary>>) ->
    Bin = case Byte of
        <<"\"">> -> Rem;
        _ -> B
    end,
    case binary:last(Bin) of
        34 ->
            Len = byte_size(Bin),
            binary:part(Bin, 0, Len - 1);
        _ ->
            Bin
    end;

rid_quote(Bin) ->
    Bin.

%% 生成语言包文件
gen(_IoDev, []) -> ok;
gen(IoDev, [#word{cn = Cn, tr = Tr, ver = 1} | Words]) ->
    file:write(IoDev, io_lib:format("get(<<\"~s\">>) ->\n\t<<\"~s\">>;\n", [Cn, Tr])),
    gen(IoDev, Words);
gen(IoDev, [_Word | Words]) ->
    gen(IoDev, Words).

%% 获取 参数字符  ~ ~w
get_arg_char(Cn) ->
    get_arg_char(Cn, []).
get_arg_char(<<>>, List) -> lists:reverse(List);
get_arg_char(<<"~">>, List) -> lists:reverse([$~ | List]);
get_arg_char(<<"~", Rem/binary>>, List) ->
    <<Char:1/binary, NewRem/binary>> = Rem,
    case check_arg_char(Char) of
        {ok, Ch} -> get_arg_char(NewRem, [Ch, $~ | List]);
        false -> get_arg_char(Rem, [$~ | List])
    end;
get_arg_char(<<_Char:1/binary, Rem/binary >>, List) ->
    get_arg_char(Rem, List).


check_arg_char(<<"c">>) -> {ok, $c};
check_arg_char(<<"f">>) -> {ok, $f};
check_arg_char(<<"e">>) -> {ok, $e};
check_arg_char(<<"g">>) -> {ok, $g};
check_arg_char(<<"s">>) -> {ok, $s};
check_arg_char(<<"w">>) -> {ok, $w};
check_arg_char(<<"p">>) -> {ok, $p};
check_arg_char(<<"W">>) -> {ok, $W};
check_arg_char(<<"P">>) -> {ok, $p};
check_arg_char(<<"B">>) -> {ok, $B};
check_arg_char(<<"X">>) -> {ok, $X};
check_arg_char(<<"#">>) -> {ok, $#};
check_arg_char(<<"b">>) -> {ok, $b};
check_arg_char(<<"x">>) -> {ok, $x};
check_arg_char(<<"+">>) -> {ok, $+};
check_arg_char(<<"i">>) -> {ok, $i};
check_arg_char(_Char) -> false.
