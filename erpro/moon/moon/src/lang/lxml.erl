%% ----------------------------------------------------
%% 策划数据翻译处理模块
%% @author weihua@jieyou.cn 
%% ----------------------------------------------------
-module(lxml).
-export([
         ext/0
        ,export/1
        ,done/0
        ,undone/0
        ,import/1
        ,transfer/1
        ,gen/0
        ,convert/0
        ,lib/0
        ,update/0
    ]
).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("lutil.hrl").

%% --------------------------------------------------------------------------------
%% 宏定义
%% --------------------------------------------------------------------------------
-define(xml_dets_name, xml_dets).                         %% dets 名字
-define(xml_dets_file, "../src/lang/xml.dets").           %% dets 文件路径
-define(xml_done_xml_file, "../src/lang/xml_done.xml").   %% 语言包文件路径
-define(xml_undone_xml_file, "../src/lang/xml_undone.xml").   %% 语言包文件路径
-define(xml_ext_re, "String\">(.*[\x{4e00}-\x{9fff}].*)</Data>").

%% ------------------------------------------------------
%% 定义策划数据 语言包控制文件
%% ------------------------------------------------------
-define(xml_extre_dets_file, "../src/lang/xml_extre.dets").
-define(xml_extre_dets_name, xml_extre).

%% =======================================================================
%% 抽取
%% =======================================================================
%% @spec ext() -> ok
%% @doc 抽取策划文件中文
ext() ->
    case re:compile(?xml_ext_re, [unicode, ungreedy]) of
        {error, _ErrSpec} ->
            ?ERR("编译正则表达式【~s】时发生错误", [?xml_ext_re]),
            error;
        {ok, MP} ->
            T1 = util:unixtime(),
            dets:open_file(?xml_extre_dets_name, [{file, ?xml_extre_dets_file}, {keypos, #lang.file}, {type, set}]),
            ?INFO("开始抽取出中文..."),
            Result = ext_xml_files(file_list(xml), MP, ?xml_extre_dets_name),
            case Result of
                ok -> ok;
                _ -> lists:foreach(fun(Error) -> ?ERR("~s", [Error]) end, Result)
            end,
            dets:close(?xml_extre_dets_name),
            T2 = util:unixtime(),
            ?INFO("抽取完成, 总共耗时 ~w  秒", [T2 - T1]),
            ok
    end.

ext_xml_files(FileList, MP, DetsName) ->
    ext_xml_files(FileList, MP, DetsName, ldets:get_file_index(DetsName), []).

ext_xml_files([], _MP, _DetsName, _Index,  []) -> ok;
ext_xml_files([], _MP, _DetsName, _Index, Fails) -> Fails;
ext_xml_files([File | FileList], MP, DetsName, Index, Fails) -> 
    case file:read_file(File) of
        {ok, Bin} ->
            ?INFO("开始抽取文件 [~w] [~s]", [Index, File]),
            case re:run(Bin, MP, [global, {capture, [1], binary}]) of
                nomatch -> 
                    ext_xml_files(FileList, MP, DetsName, Index + 1, Fails);
                {match, M} -> 
                    EntryIndex = ldets:get_entry_index(DetsName, File),
                    Fun = fun([Cn], Acc) -> ldets:insert(DetsName, File, Index, Cn, <<>>, false, Acc), Acc + 1 end,
                    lists:foldl(Fun, EntryIndex, M),
                    ext_xml_files(FileList, MP, DetsName, Index + 1, Fails)
            end;
        {error, Reason} ->
            ext_xml_files(FileList, MP, DetsName, Index + 1, [util:fbin("读取文件 [~s] 发生错误, 错误信息: [~w]", [File, Reason]) | Fails])
    end.

%% =========================================================================
%% 转换没有文件信息的 DETS文件
%% =========================================================================
convert() ->
    ExDets = ?xml_extre_dets_name,
    Dets = ?xml_dets_name,
    dets:open_file(?xml_extre_dets_name, [{file, ?xml_extre_dets_file}, {keypos, #lang.file}, {type, set}]),
    dets:open_file(?xml_dets_name, [{file, ?xml_dets_file}, {keypos, #word.cn}, {type, set}]),
    Lans = lists:keysort(#lang.index, dets:foldl(fun(Elem, Acc) -> [Elem | Acc] end, [], ExDets)),
    Fun = fun(#lang{dicts = Dicts}) -> convert(Dets, lists:keysort(#dict.index, Dicts)) end,
    lists:foreach(Fun, Lans),
    dets:close(?xml_dets_name),
    dets:close(?xml_extre_dets_name).

convert(_Dets, []) -> ok;
convert(Dets, [#dict{cn = Cn, tr = Tr, ver = now} |Dicts]) ->
    insert(Dets, Cn, Tr, 1),
    convert(Dets, Dicts);
convert(Dets, [#dict{cn = Cn, tr = Tr, ver = _} |Dicts]) ->
    insert(Dets, Cn, Tr, 0),
    convert(Dets, Dicts).

%% ======================================================================
%% 导出语言包
%% =====================================================================
%% @spec export(Type) -> ok
%% @doc 导出语言包
export(Type) ->
    DetsName = ?xml_dets_name,
    DetsPath = ?xml_dets_file,
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
    Words = dets:foldl(fun(Word, Acc) -> [Word | Acc] end, [], DetsName),
    {File, NewWords} = case Type of 
        done -> {"../src/lang/xml_done", [Word || Word = #word{tr = Tr, ver = 1} <- Words, Tr =/= <<>>]};
        undone -> {"../src/lang/xml_undone", [Word || Word = #word{tr = <<>>, ver = 1} <- Words]}
    end,
    lutil:export(File, lists:keysort(#word.index, NewWords)),
    dets:close(DetsName).

%% @spec done() -> ok
%% @doc 导出语言包
done() ->
    FilePath = ?xml_done_xml_file,
    DetsName = ?xml_dets_name,
    DetsPath = ?xml_dets_file,
    case file:open(FilePath, [write]) of
        {ok, IoDev} ->
            dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
            done(IoDev, DetsName),
            dets:close(DetsName),
            file:close(IoDev),
            ok;
        {error, Reason} ->
            ?INFO("open file error [file:~w] [error:~w]", [FilePath, Reason]),
            error
    end.

%% @spec done() -> ok
%% @doc 导出语言包
undone() ->
    FilePath = ?xml_undone_xml_file,
    DetsName = ?xml_dets_name,
    DetsPath = ?xml_dets_file,
    case file:open(FilePath, [write]) of
        {ok, IoDev} ->
            dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
            undone(IoDev, DetsName),
            dets:close(DetsName),
            file:close(IoDev),
            ok;
        {error, Reason} ->
            ?INFO("open file error [file:~w] [error:~w]", [FilePath, Reason]),
            error
    end.

%% @spec import(Type) -> ok
%% Type = done | undone
%% @doc 导入翻译
import(File) ->
    DetsName = ?xml_dets_name,
    DetsPath = ?xml_dets_file,
    case file:read_file(File) of
        {error, Reason} ->
            ?ERR("read file error [file:~s] [reason:~w]", [File, Reason]),
            ok;
        {ok, Bin} ->
            dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
            import(DetsName, Bin),
            dets:close(DetsName),
            ok
    end.

%% @spec lib() -> ok
%% @doc 导入到词库
lib() ->
    DetsName = ?xml_dets_name,
    DetsPath = ?xml_dets_file,
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
    dets:open_file(?xml_extre_dets_name, [{file, ?xml_extre_dets_file}, {keypos, #lang.file}, {type, set}]),
    lutil:open_lib(),
    Lang = fun(Lang) -> update_file(Lang) end,
    Lans = lists:keysort(#lang.index, dets:foldl(fun(Elem, Acc) -> [Lang(Elem)|Acc] end, [], ?xml_extre_dets_name)),
    dets:insert(?xml_extre_dets_name, Lans),
    lutil:close_lib(),
    dets:close(?xml_extre_dets_name).

update_file(Lang = #lang{dicts = Dicts}) ->
    Lang#lang{dicts = update_dicts(Dicts)}.

update_dicts(Dicts) ->
    update_dicts(Dicts, []).

update_dicts([], Dicts) -> Dicts;
update_dicts([Dict = #dict{cn = Cn, status = false} | Dicts], NewDicts) ->
    case lutil:lib_lookup(Cn) of
        false -> update_dicts(Dicts, [Dict | NewDicts]);
        Tr -> update_dicts(Dicts, [Dict#dict{tr = Tr, status = true} | NewDicts])
    end;
update_dicts([Dict | Dicts], NewDicts) ->
    update_dicts(Dicts, [Dict | NewDicts]).

%% @spec transfer(File) -> ok
%% File = string()
%% @spec 转换以前的翻译格式
transfer(File) ->
    DetsName = ?xml_dets_name,
    DetsPath = ?xml_dets_file,
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
    DetsName = ?xml_dets_name,
    DetsPath = ?xml_dets_file,
    case file:open("../src/lang/language.erl", [write]) of
        {ok, IoDev} ->
            ?INFO("开始生成语言包文件 language.erl ..."),
            dets:open_file(DetsName, [{file, DetsPath}, {keypos, #word.cn}, {type, set}]),
            Words = lists:keysort(#word.index, dets:foldl(fun(Word, Acc) -> [Word | Acc] end, [], DetsName)),
            file:write(IoDev, "%%------------------------------\n%% 语言包\n%%------------------------------\n"),
            file:write(IoDev, "-module(language).\n-export([get/1]).\n\n"),
            gen(IoDev, Words),
            file:write(IoDev, "get(Bin) -> Bin."),
            ?INFO("生成完毕！"),
            dets:close(DetsName),
            file:close(IoDev);
        {error, Reason} ->
            {error, Reason}
    end.

%% -------------------------------------------------------------------------------
%% 私有函数
%% -------------------------------------------------------------------------------
%% 策划数据文件列表
file_list(xml) ->
    {ok, Cwd} = file:get_cwd(),
    SrcFiles = lutil:ls(Cwd ++ "/../src/xml"),
    Files = lutil:file_filter(SrcFiles, [".xml"]),
    [list_to_binary(FilePath) || FilePath <- Files].


insert(DetsName, CnBin, TrBin, Ver) ->
    case dets:lookup(DetsName, CnBin) of
        [Word] ->
            dets:insert(DetsName, Word#word{tr = TrBin, ver = Ver});
        _ -> 
            NextIndex = case get(word_index) of
                undefined ->
                    init_word_index(DetsName);
                Index -> Index
            end,
            put(word_index, NextIndex + 1),
            dets:insert(DetsName, #word{cn = CnBin, tr = TrBin, ver = Ver, index = NextIndex})
    end.

init_word_index(DetsName) ->
    dets:foldl(fun(#word{index = Index}, Acc) ->
                case Index > Acc of
                    true -> Index;
                    false -> Acc 
                        end
                end, 1, DetsName).

done(IoDev, DetsName) ->
    Words = dets:foldl(fun(Word, Acc) -> [Word | Acc] end, [], DetsName),
    file:write(IoDev, "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n"),
    file:write(IoDev, "<translation xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"),
    done_export(IoDev, lists:keysort(#word.index, Words)).
    
done_export(IoDev, []) ->
    file:write(IoDev, "</translation>"),
    ok;
done_export(IoDev, [#word{cn = Cn, tr = Tr, index = Index, ver = 1} | Words]) when Tr =/= <<>> ->
    file:write(IoDev, io_lib:format("\t<word>\n\t\t<index>~w</index>\n\t\t<cn>~s</cn>\n\t\t<tr>~s</tr>\n\t</word>\n", [Index, Cn, Tr])),
    done_export(IoDev, Words);
done_export(IoDev, [_Word | Words]) ->
    done_export(IoDev, Words).

undone(IoDev, DetsName) ->
    Words = dets:foldl(fun(Word, Acc) -> [Word | Acc] end, [], DetsName),
    file:write(IoDev, "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n"),
    file:write(IoDev, "<translation xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"),
    undone_export(IoDev, lists:keysort(#word.index, Words)).
    
undone_export(IoDev, []) ->
    file:write(IoDev, "</translation>"),
    ok;
undone_export(IoDev, [#word{cn = Cn, tr = <<>>, index = Index, ver = 1} | Words]) ->
    file:write(IoDev, io_lib:format("\t<word>\n\t\t<index>~w</index>\n\t\t<cn>~s</cn>\n\t\t<tr></tr>\n\t</word>\n", [Index, Cn])),
    undone_export(IoDev, Words);
undone_export(IoDev, [_Word | Words]) ->
    undone_export(IoDev, Words).

%% 导入数据
import(DetsName, Bin) ->
    case re:run(Bin, "<word>(.*)</word>", [unicode, ungreedy, dotall, global, {capture, [1], binary}]) of
        nomatch ->
            ?INFO("找不到任何词条"),
            ok;
        {match, M} ->
            import_by_word(DetsName, M)
    end.

import_by_word(DetsName, M) ->
    case re:compile("<cn>(.*)</cn>", [unicode, ungreedy]) of
        {ok, CnMp} ->
            case re:compile("<tr>(.*)</tr>", [unicode, ungreedy]) of
                {ok, TrMp} ->
                    import_by_word(DetsName, M, CnMp, TrMp);
                {error, Reason} ->
                    ?ERR("编译正则发生错误 [re:\"<tr>(.*)</tr>\"] [reason:~w]", [Reason]),
                    ok
            end;
        {error, Reason} ->
            ?ERR("编译正则发生错误 [re:\"<cn>(.*)</cn>\"] [reason:~w]", [Reason]),
            ok
    end.

import_by_word(_DetsName, [], _CnMp, _TrMp) -> ok;
import_by_word(DetsName, [[Bin] |NewBin], CnMp, TrMp) ->
    case re:run(Bin, CnMp, [global, {capture, [1], binary}]) of
        nomatch ->
            ?ERR("词条中找不到简体内容"),
            ok;
        {match, [[Cn]]} ->
            case re:run(Bin, TrMp, [global, {capture, [1], binary}]) of
                nomatch ->
                    ?ERR("词条中找不到简体内容"),
                    ok;
                {match, [[Tr]]} ->
                    insert(DetsName, Cn, Tr, 1);
                {match, Mtr} ->
                    ?ERR("翻译错误 【~w】", [Mtr]),
                    ok
            end;
        {match, Mcn} ->
            ?ERR("翻译错误 【~w】", [Mcn]),
            ok
    end,
    import_by_word(DetsName, NewBin, CnMp, TrMp).

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
            insert(DetsName, rid_quote(CnEntry), rid_quote(TrEntry), 1);
        _ ->
            insert(DetsName, rid_quote(CnEntry), rid_quote(TrEntry), 1)
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


