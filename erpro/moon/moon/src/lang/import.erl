%%----------------------------------------------------
%% 导入语言包
%% @author weihua@jieyou.cn 
%%----------------------------------------------------
-module(import).
-export([by_div/3                   %% 导入翻译好的数据到 DETS
        ,by_union/2                 %% 导入翻译好的数据到 DETS
        ,add_lib_union/2            %% 导入翻译创建词库
        ,add_lib_div/3
    ]
).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("lang.hrl").

%% @spec by_div(Type, Ver) -> error | ok
%% @doc 通过 _cn 和 _nation 文件导入
by_div(Type, Cn, Tr) ->
    {DetsName, DetsPath} = case Type of
        xml -> {?lang_xml_dets_name, ?lang_xml_dets};
        server -> {?lang_server_dets_name, ?lang_server_dets}
    end,
    case file:read_file(Cn) of
        {ok, CnBin} ->
            case file:read_file(Tr) of
                {ok, TrBin} ->
                    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #lang.file}, {type, set}]),
                    sibr(CnBin, TrBin, DetsName),
                    dets:close(DetsName);
                {error, Reason} ->
                    ?ERR("open file error [file:~s] [reason:~w]", [Tr, Reason]),
                    error
            end;
        {error, Reason} ->
            ?ERR("open file error [file:~s] [reason:~w]", [Cn, Reason]),
            error
    end.

%% @spec by_union(Type, Ver) -> error | ok
%% @doc 通过 _union 文件导入
by_union(Type, File) ->
    {DetsName, DetsPath} = case Type of
        xml -> {?lang_xml_dets_name, ?lang_xml_dets};
        server -> {?lang_server_dets_name, ?lang_server_dets};
        notice -> {?lang_notice_dets_name, ?lang_notice_dets}
    end,
    case file:read_file(File) of
        {ok, FileBin} ->
            dets:open_file(DetsName, [{file, DetsPath}, {keypos, #lang.file}, {type, set}]),
            uibr(FileBin, DetsName),
            dets:close(DetsName);
        {error, Reason} ->
            ?ERR("open file error [file:~s] [reason:~w]", [File, Reason]),
            error
    end.

%% @spec create_lib(Type, FilePath) -> error | ok
%% @doc 创建词库
add_lib_union(Type, FilePath) ->
    {DetsName, DetsFile} = case Type of
        xml -> {xml_words, ?lang_xml_words};
        server -> {server_words, ?lang_server_words}
    end,
    case file:open(FilePath, [read, binary]) of
        {ok, IoDev} ->
            dets:open_file(DetsName, [{file, DetsFile}, {keypos, #word.cn}, {type, set}]),
            add_lib_union(DetsName, IoDev, 1),
            dets:close(DetsName),
            file:close(IoDev);
        {error, Reason} ->
            {error, Reason}
    end.

%% @spec create_lib(Type, FilePath) -> error | ok
%% @doc 创建词库
add_lib_div(Type, CnFile, TrFile) ->
    {DetsName, DetsFile} = case Type of
        xml -> {xml_words, ?lang_xml_words};
        server -> {server_words, ?lang_server_words}
    end,
    case file:open(CnFile, [read, binary]) of
        {ok, CnIoDev} ->
            case file:open(TrFile, [read, binary]) of
                {ok, TrIoDev} ->
                    dets:open_file(DetsName, [{file, DetsFile}, {keypos, #word.cn}, {type, set}]),
                    add_lib_div(DetsName, CnIoDev, TrIoDev, 1),
                    dets:close(DetsName),
                    file:close(CnIoDev),
                    file:close(TrIoDev);
                {error, Reason} ->
                    file:close(CnIoDev),
                    {error, Reason}
            end;
        {error, Reason} ->
            {error, Reason}
    end.

%% 通过分开的简体，翻译文件来导入翻译
sibr(CnBin, TrBin, DetsName) ->
    try re:run(CnBin, "\\[F\\]:.*\\[E\\]:", [unicode, global, ungreedy, dotall]) of
        {match, CnM} ->
            try re:run(TrBin, "\\[F\\]:.*\\[E\\]:", [unicode, global, ungreedy, dotall]) of
                {match, TrM} when length(CnM) =:= length(TrM) ->
                    sibr(CnBin, CnM, TrBin, TrM, DetsName);
                nomatch ->
                    ?ERR("翻译文件中匹配不出任何文件数据"),
                    error;
                _ ->
                    ?ERR("简体文件和翻译文件匹配出的文件数目对不上!"),
                    error
            catch
                Error:Info -> 
                    ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
                    error
            end;
        nomatch ->
            ?ERR("简体文件中匹配不出任何文件数据")
    catch
        Error:Info -> 
            ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
            error
    end.

sibr(CnBin, CnM, TrBin, TrM, DetsName) ->
    sibr(CnBin, CnM, TrBin, TrM, DetsName, ldets:get_file_index(DetsName)).

sibr(_CnBin, [], _TrBin, _TrM, _DetsName, _FileIndex) ->
    ok;
sibr(CnBin, [[{CnP, CnL}]| CnM], TrBin, [[{TrP, TrL}] | TrM], DetsName, FileIndex) ->
    sibr_file(binary:part(CnBin, CnP, CnL), binary:part(TrBin, TrP, TrL), DetsName, FileIndex),
    sibr(CnBin, CnM, TrBin, TrM, DetsName, FileIndex + 1).

sibr_file(Cn, Tr, DetsName, FileIndex) ->
    try re:run(Cn, "(?<=\\[F\\]:).*(?=\\[S\\]:)", [unicode, global, ungreedy, dotall]) of
        {match, [[{CnP, CnL}]]} ->
            try re:run(Tr, "(?<=\\[F\\]:).*(?=\\[T\\]:)", [unicode, global, ungreedy, dotall]) of
                {match, [[{TrP, TrL}]]} ->
                    FilePathCn = lutil:nocrlf(binary:part(Cn, CnP, CnL)),
                    FilePathTr = lutil:nocrlf(binary:part(Tr, TrP, TrL)),
                    case FilePathCn =:= FilePathTr of
                        true ->
                            ?INFO("开始导入文件 [~w][~s]", [FileIndex, FilePathCn]),
                            sibr_file(Cn, Tr, DetsName, FilePathCn, FileIndex);
                        false ->
                            ?ERR("第 [~w] 个文件的路径对不上，~n[简体：~s]~n[翻译：~s]", [FileIndex, FilePathCn, FilePathTr]),
                            error
                    end;
                nomatch ->
                    ?ERR("第 [~w] 翻译文件中匹配不出文件路径数据", [FileIndex]),
                    error
            catch
                Error:Info -> 
                    ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
                    error
            end;
        nomatch ->
            ?ERR("第 [~w] 简体文件中匹配不出文件路径数据", [FileIndex]),
            error
    catch
        Error:Info -> 
            ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
            error
    end.

sibr_file(Cn, Tr, DetsName, FilePath, FileIndex) ->
    try re:run(Cn, "(?<=\\[S\\]:).*(?=(\\[E\\]:|\\[S\\]:))", [unicode, global, ungreedy, dotall]) of
        {match, CnM} ->
            try re:run(Tr, "(?<=\\[T\\]:).*(?=(\\[E\\]:|\\[T\\]:))", [unicode, global, ungreedy, dotall]) of
                {match, TrM} when length(CnM) =:= length(TrM) ->
                    sibr_entry(Cn, CnM, Tr, TrM, DetsName, FilePath, FileIndex);
                nomatch ->
                    ?ERR("翻译文件块 [~s] 没有任何词条数据", [FilePath]),
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
            ?ERR("翻译文件块 [~s] 没有任何数据文件")
    catch
        Error:Info -> 
            ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
            error
    end.

sibr_entry(Cn, CnM, Tr, TrM, DetsName, FilePath, FileIndex) ->
    sibr_entry(Cn, CnM, Tr, TrM, DetsName, FilePath, FileIndex, ldets:get_entry_index(DetsName, FilePath)).

sibr_entry(_Cn, [], _Tr, _TrM, _DetsName, _FilePath, _FileIndex, _EntryIndex) ->
    ok;
sibr_entry(Cn, [[{CnP, CnL}, _]|CnM], Tr,  [[{TrP, TrL}, _]|TrM], DetsName, FilePath, FileIndex, EntryIndex) ->
    CnEntry = lutil:nocrlf(binary:part(Cn, CnP, CnL)),
    TrEntry = lutil:nocrlf(binary:part(Tr, TrP, TrL)),
    case TrEntry of
        <<>> -> 
            ?ERR("文件块 [~s] 下的词条 [~s] 未翻译", [FilePath, CnEntry]),
            ldets:insert(DetsName, FilePath, FileIndex, CnEntry, TrEntry, false, EntryIndex);
        _ ->
            ldets:insert(DetsName, FilePath, FileIndex, CnEntry, TrEntry, true, EntryIndex)
    end,
    sibr_entry(Cn, CnM, Tr, TrM, DetsName, FilePath, FileIndex, EntryIndex + 1).

%% 通过 union 文件来导入翻译
uibr(Bin, DetsName) ->
    try re:run(Bin, "\\[F\\]:.*\\[E\\]:", [unicode, global, ungreedy, dotall]) of
        {match, M} ->
            uibr(Bin, M, DetsName);
        nomatch ->
            ?ERR("翻译文件中匹配不到任何 文件块 数据")
    catch
        Error:Info -> 
            ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
            error
    end.

uibr(Bin, M, DetsName) ->
    uibr(Bin, M, DetsName, ldets:get_file_index(DetsName)).
uibr(_Bin, [], _DetsName, _FileIndex) ->
    ok;
uibr(Bin, [[{P, L}]| M], DetsName, FileIndex) ->
    uibr_file(binary:part(Bin, P, L), DetsName, FileIndex),
    uibr(Bin, M, DetsName, FileIndex + 1).

uibr_file(Bin, DetsName, FileIndex) ->
    try re:run(Bin, "(?<=\\[F\\]:).*(?=\\[S\\]:)", [unicode, global, ungreedy, dotall]) of
        {match, [[{P, L}]]} ->
            FilePath = lutil:nocrlf(binary:part(Bin, P, L)),
            ?INFO("开始导入文件 [~w] [~s]", [FileIndex, FilePath]),
            uibr_file(Bin, DetsName, FilePath, FileIndex);
        nomatch ->
            ?ERR("第 [~w] 个文件块 匹配不出文件路径", [FileIndex])
    catch
        Error:Info -> 
            ?ERR("正则匹配发生 ~w ,Reason ~w", [Error, Info]),
            error
    end.

uibr_file(Bin, DetsName, FilePath, FileIndex) ->
    try re:run(Bin, "(?<=\\[S\\]:).*(?=\\[T\\]:)", [unicode, global, ungreedy, dotall]) of
        {match, CnM} ->
            try re:run(Bin, "(?<=\\[T\\]:).*(?=(\\[E\\]:|\\[S\\]:))", [unicode, global, ungreedy, dotall]) of
                {match, TrM} when length(CnM) =:= length(TrM) ->
                    uibr_entry(Bin, CnM, TrM, DetsName, FilePath, FileIndex);
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

uibr_entry(Bin, CnM, TrM, DetsName, FilePath, FileIndex) ->
    uibr_entry(Bin, CnM, TrM, DetsName, FilePath, FileIndex, ldets:get_entry_index(DetsName, FilePath)).
uibr_entry(_Bin, [], _TrM, _DetsName, _FilePath, _FileIndex, _EntryIndex) ->
    ok;
uibr_entry(Bin, [[{CnP, CnL}]|CnM],  [[{TrP, TrL}, _]|TrM], DetsName, FilePath, FileIndex, EntryIndex) ->
    CnEntry = lutil:nocrlf(binary:part(Bin, CnP, CnL)),
    TrEntry = lutil:nocrlf(binary:part(Bin, TrP, TrL)),
    case TrEntry of
        <<>> -> 
            ?ERR("文件块 [~s] 下 词条 [~s] 未翻译", [FilePath, CnEntry]),
            ldets:insert(DetsName, FilePath, FileIndex, CnEntry, TrEntry, false, EntryIndex);
        _ ->
            ldets:insert(DetsName, FilePath, FileIndex, CnEntry, TrEntry, true, EntryIndex)
    end,
    uibr_entry(Bin, CnM, TrM, DetsName, FilePath, FileIndex, EntryIndex + 1).

%% 加入到词库
add_lib_union(DetsName, IoDev, Line) ->
    case file:read_line(IoDev) of
        eof -> eof;
        {erro, Reason} ->
            ?ERR("read line error [line:~w] [error:~w]", [Line, Reason]),
            error;
        {ok, DataS} ->
            BinS = lutil:nocrlf(DataS),
            case byte_size(BinS) >= ?pre_head of
                true ->
                    <<PreS:?pre_head/binary, CnRem/binary>> = BinS,
                    case PreS of
                        <<"[S]:">> ->
                            case file:read_line(IoDev) of
                                eof -> eof;
                                {error, Reason} -> 
                                    ?ERR("read line error [line:~w] [error:~w]", [Line, Reason]),
                                    error;
                                {ok, DataT} ->
                                    BinT = lutil:nocrlf(DataT),
                                    case byte_size(BinT) >= ?pre_head of
                                        true ->
                                            <<PreT:?pre_head/binary, TrRem/binary>> = BinT,
                                            case PreT of
                                                <<"[T]:">> when TrRem =:= <<>> ->
                                                    ?ERR("line [~w], cn [~s] have no translation", [Line, CnRem]),
                                                    add_lib_union(DetsName, IoDev, Line + 2);
                                                <<"[T]:">> ->
                                                    dets:insert(DetsName, #word{cn = CnRem, tr = TrRem}),
                                                    add_lib_union(DetsName, IoDev, Line + 2);
                                                _ ->
                                                    ?ERR("line [~w] file data format error", [Line + 1])
                                            end;
                                        _ ->
                                            ?ERR("line [~w] file data format error", [Line + 1])
                                    end
                            end;
                        <<"[T]:">> ->
                            ?ERR("line [~w] file data format error", [Line]);
                        _ ->
                            add_lib_union(DetsName, IoDev, Line + 1)
                    end;
                _ ->
                    add_lib_union(DetsName, IoDev, Line + 1)
            end
    end.

add_lib_div(DetsName, CnIoDev, TrIoDev, Line) ->
    case file:read_line(CnIoDev) of
        eof -> eof;
        {erro, Reason} ->
            ?ERR("read line error [line:~w] [error:~w]", [Line, Reason]),
            error;
        {ok, DataS} ->
            case file:read_line(TrIoDev) of
                eof -> eof;
                {error, Reason} -> 
                    ?ERR("read line error [line:~w] [error:~w]", [Line, Reason]),
                    error;
                {ok, DataT} ->
                    BinS = lutil:nocrlf(DataS),
                    BinT = lutil:nocrlf(DataT),
                    case {byte_size(BinS) >= ?pre_head, byte_size(BinT) >= ?pre_head} of
                        {true, true} ->
                            <<PreS:?pre_head/binary, CnRem/binary>> = BinS,
                            <<PreT:?pre_head/binary, TrRem/binary>> = BinT,
                            case {PreS, PreT} of
                                {<<"[S]:">>, <<"[T]:">>}->
                                    dets:insert(DetsName, #word{cn = CnRem, tr = TrRem}),
                                    add_lib_div(DetsName, CnIoDev, TrIoDev, Line + 1);
                                {PreCo, PreCo} ->
                                    add_lib_div(DetsName, CnIoDev, TrIoDev, Line + 1);
                                {Pre1, Pre2} ->
                                    ?ERR("line data format error , pre1 is [~s], pre2 is [~s]", [Pre1, Pre2]),
                                    error
                            end;
                        {false, false} ->
                            add_lib_div(DetsName, CnIoDev, TrIoDev, Line + 1);
                        _ ->
                            ?ERR("data format error [line:~w]", [Line]),
                            error
                    end
            end
    end.
