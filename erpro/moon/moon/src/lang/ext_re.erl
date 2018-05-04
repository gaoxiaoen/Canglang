%%----------------------------------------------------
%% extract and replace module
%% @author weihua@jieyou.cn 
%%----------------------------------------------------
-module(ext_re).
-export([ext/1                      %% 抽取语言词断，保存到 DETS 
        ,replace/1                  %% 替换翻译好的内容到源文件
        ,clear/0                    %% 清理服务端不需要翻译的文件
        ,clear_pre/1                %% 清除语言包中间文件 dets 中的过期语言包数据
        ,analysis_xml_label/1       %% 分析字符串中 xml 标签
        ,clear_xml_std/0            %% 转换策划数据，清理一些标准的标签信息
        ,ratoq/0                    %% 将有引用 头文件 time.hrl 文件中 open 系列 的宏定义 引用改成 close 系列，rid_activity_time_open_quote
        ,transfer/0
        ,transfer/1
        ,transfer_spec/0
    ]
).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("lang.hrl").

%% 服务端抽取活动语言包 正则
-define(ext_server_activity_re, "(?<=lactivity:get\\(<<\").*(?=\">>\\))").
%% 服务端抽取中文使用 正则
-define(ext_server_re, "\"[^\"]*[\x{4e00}-\x{9fff}][^\"]*\"").
%% 服务端抽取中文使用 过滤正则
-define(ext_server_re_ignore, "INFO\\(|ELOG\\(|ERR\\(|DEBUG\\(|^%|log:log|guild_log").
%% 策划数据表使用正则
-define(ext_xml_re, "(?<=String\">).*[\x{4e00}-\x{9fff}].*(?=</Data>)").
%% 策划数据表使用正则   标准 xml 格式的
-define(ext_xml_std_re, "(?<=xmlns=\"http:\/\/www\.w3\.org\/TR\/REC-html40\">).*[\x{4e00}-\x{9fff}].*(?=</ss:Data)").
%% 清理策划数据 标准命令空间信息
-define(clear_xml_std_info_re, "<ss:Data.*</ss:Data>").

%% @spec ext(activity) -> ok | error
%% @doc 抽取服务端活动中文语言包
ext(activity) ->
    case re:compile(?ext_server_activity_re, [unicode, ungreedy]) of
        {error, _ErrSpec} ->
            ?ERR("编译正则表达式【~s】时发生错误", [?ext_server_activity_re]),
            error;
        {ok, MP} ->
            dets:open_file(?lang_server_activity_dets_name, [{file, ?lang_server_activity_dets_file}, {keypos, #lang.file}, {type, set}]),
            ?INFO("开始抽取活动语言包..."),
            case ext_server_files(get_file_list(server), MP, [], ?lang_server_activity_dets_name) of
                ok -> ok;
                Result -> lists:foreach(fun(Error) -> ?ERR("~s", [Error]) end, Result)
            end,
            dets:close(?lang_server_activity_dets_name),
            ?INFO("抽取完成"),
            ok
    end;

%% @spec ext(server) -> ok
%% @doc 抽取服务端中文语言包
ext(server) ->
    T1 = util:unixtime(),
    case re:compile(?ext_server_re, [unicode, ungreedy]) of
        {error, _ErrSpec} ->
            ?ERR("编译正则表达式【~s】时发生错误", [?ext_server_re]),
            error;
        {ok, MP} ->
            case re:compile(?ext_server_re_ignore, [unicode]) of
                {error, _ErrSpec} ->
                    ?ERR("编译正则表达式【~s】时发生错误", [?ext_server_re_ignore]),
                    error;
                {ok, IMP} ->
                    dets:open_file(?lang_server_dets_name, [{file, ?lang_server_dets}, {keypos, #lang.file}, {type, set}]),
                    ?INFO("开始抽取出中文..."),
                    case ext_server_files(get_file_list(server), MP, [IMP], ?lang_server_dets_name) of
                        ok -> ok;
                        Result -> lists:foreach(fun(Error) -> ?ERR("~s", [Error]) end, Result)
                    end,
                    dets:close(?lang_server_dets_name),
                    T2 = util:unixtime(),
                    ?INFO("抽取完成, 总共耗时 ~w  秒", [T2 - T1]),
                    ok
            end
    end;

%% @spec ext(xml) -> ok
%% @doc 抽取策划文件中文
ext(xml) ->
    case re:compile(?ext_xml_re, [unicode, ungreedy]) of
        {error, _ErrSpec} ->
            ?ERR("编译正则表达式【~s】时发生错误", [?ext_xml_re]),
            error;
        {ok, MP} ->
            T1 = util:unixtime(),
            dets:open_file(?lang_xml_dets_name, [{file, ?lang_xml_dets}, {keypos, #lang.file}, {type, set}]),
            ?INFO("开始抽取出中文..."),
            case ext_xml_files(get_file_list(xml), MP, ?lang_xml_dets_name) of
                ok -> ok;
                Result -> lists:foreach(fun(Error) -> ?ERR("~s", [Error]) end, Result)
            end,
            dets:close(?lang_xml_dets_name),
            T2 = util:unixtime(),
            ?INFO("抽取完成, 总共耗时 ~w  秒", [T2 - T1]),
            ok
    end.

%% @spec replace(server) -> ok
%% @doc 替换翻译回源文件
replace(server) ->
    clear(),
    clear_pre(server),
    {DetsName, DetsPath} = {?lang_server_dets_name, ?lang_server_dets},
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #lang.file}, {type, set}]),
    case re:compile(?ext_server_re_ignore, [unicode]) of
        {error, _ErrSpec} ->
            ?ERR("编译正则表达式【~s】时发生错误", [?ext_server_re_ignore]),
            error;
        {ok, IMp} ->
            case dets:first(DetsName) of
                '$end_of_table' ->
                    ?INFO("没有任何字典数据");
                _ ->
                    ?INFO("开始扫描字典数据..."),
                    T1 = util:unixtime(),
                    dets:traverse(DetsName,
                        fun(#lang{file = FilePath, dicts = Dicts}) ->
                                case is_related_info(FilePath) of
                                    true ->
                                        case compile_re_mps(Dicts) of
                                            error -> error;
                                            NewDicts -> catch replace_file_1(FilePath, lists:reverse(lists:keysort(#dict.len, NewDicts)), [IMp])
                                        end;
                                    false ->
                                        replace_file_2(FilePath, lists:reverse(lists:keysort(#dict.len, Dicts)))
                                end,
                                continue
                        end
                    ),
                    T2 = util:unixtime(),
                    ?INFO("本次字典数据扫描完毕！耗时 ~w 秒", [T2-T1])
            end,
            dets:close(DetsName)
    end;

%% @spec replace(Type) -> ok
%% @doc 替换翻译回源文件, xml, notice
replace(Type) ->
    {DetsName, DetsPath} = case Type of
        xml -> {?lang_xml_dets_name, ?lang_xml_dets};
        notice -> {?lang_notice_dets_name, ?lang_notice_dets}
    end,
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #lang.file}, {type, set}]),
    case dets:first(DetsName) of
        '$end_of_table' ->
            ?INFO("没有任何字典数据");
        _ ->
            ?INFO("开始扫描字典数据..."),
            dets:traverse(DetsName,
                fun(#lang{file = FilePath, dicts = Dicts}) ->
                        replace_file_2(FilePath, lists:reverse(lists:keysort(#dict.len, Dicts))),
                        continue
                end
            ),
            ?INFO("本次字典数据扫描完毕！")
    end,
    dets:close(DetsName).

%% @spec clear(Type) -> ok
%% @doc 清除过滤冗余不需要翻译的文件
clear() ->
    {DetsName, DetsPath} = {?lang_server_dets_name, ?lang_server_dets},
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #lang.file}, {type, set}]),
    case dets:first(DetsName) of
        '$end_of_table' -> ?INFO("没有任何字典数据");
        _ ->
            ?INFO("开始清理忽略字典数据..."),
            IgnoreFiles = get_ignore_files(),
            erase(ignorefiles),
            dets:traverse(DetsName,
                fun(#lang{file = FilePath}) ->
                        case lists:member(binary_to_list(FilePath), IgnoreFiles) of
                            true ->
                                case get(ignorefiles) of
                                    undefined -> put(ignorefiles, [FilePath]);
                                    FilePaths -> put(ignorefiles, [FilePath | FilePaths])
                                end;
                            false -> ok
                        end,
                        continue
                end
            ),
            case get(ignorefiles) of
                undefined -> ok;
                FilePaths ->
                    ?DEBUG("已经清理 ~w 个文件，如下：~n~p", [length(FilePaths), FilePaths]),
                    lists:foreach(fun(FilePath) -> dets:delete(DetsName, FilePath) end, FilePaths)
            end,
            ?INFO("清理完毕！")
    end,
    dets:close(DetsName).

%% @spec clear_pre(Type) -> Result
%% @doc 清理前期版本词条
clear_pre(Type) ->
    {DetsName, DetsPath} = case Type of
        server -> {?lang_server_dets_name, ?lang_server_dets};
        xml -> {?lang_xml_dets_name, ?lang_xml_dets}
    end,
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #lang.file}, {type, set}]),
    clear_pre_entry(DetsName),
    dets:close(DetsName).

%% @spec ratoq() -> ok
%% 将有引用 头文件 time.hrl 文件中 open 系列 的宏定义 引用改成 close 系列，rid_activity_time_open_quote
ratoq() ->
    {ok, Cwd} = file:get_cwd(),
    ratoq(get_file_list(server), list_to_binary(Cwd ++ "/../inc/time.hrl")).

%% @spec transfer() -> ok
%% @doc 轉換
transfer() ->
    case re:compile("<<\".*?[\x{4e00}-\x{9fff}].*?\">>", [unicode]) of
        {error, _ErrSpec} ->
            error;
        {ok, MP} ->
            case re:compile("INFO\\(|ELOG\\(|ERR\\(|DEBUG\\(|^%|log:log|guild_log", [unicode]) of
                {error, _ErrSpec} ->
                    error;
                {ok, IMP} ->
                    transfer(get_file_list(server), MP, [IMP])
            end
    end.

%% @spec 将活动于语言包涉及改成通用的语言包处理
transfer(activity) ->
    case re:compile("lactivity:get", [unicode]) of
        {error, _ErrSpec} ->
            error;
        {ok, MP} ->
            transfer_activity(get_file_list(server), MP)
    end.

%%----------------------------------------------------------------
%% 私有函数
%%----------------------------------------------------------------
%% 获取文件列表
get_file_list(xml) ->
    case adm:get_xml() of
        {ok, FileList} -> [list_to_binary(FilePath) || {_FileName, FilePath} <- FileList];
        _ -> []
    end;
get_file_list(xml_std) ->
    case adm:get_xml() of
        {ok, FileList} -> [list_to_binary(FilePath) || {_FileName, FilePath} <- FileList];
        _ -> []
    end;

get_file_list(server) ->
    case adm:get_src_erl() of
        {ok, FileList1} ->
            case adm:get_src_hrl() of
                {ok, FileList2} ->
                    case adm:get_inc_hrl() of
                        {ok, FileList3} ->
                            [list_to_binary(FilePath) || {_FileName, FilePath} <- remove_ignoreplace_file_1s(FileList1 ++ FileList2 ++ FileList3)];
                        _ ->
                            ?INFO("inc 目录下找不到任何的 hrl 文件"),
                            []
                    end;
                _ ->
                    ?INFO("src 目录下找不到任何 hrl 文件"),
                    []
            end;
        _ ->
            ?INFO("src 目录下找不到任何 erl 文件"),
            []
    end.

%% 过滤被忽略的文件
remove_ignoreplace_file_1s(FileLists) ->
    remove_ignoreplace_file_1s(FileLists, get_ignore_files()).
remove_ignoreplace_file_1s(FileLists, []) -> FileLists;
remove_ignoreplace_file_1s(FileLists, [IgnoreFile | IgnoreFiles]) ->
    remove_ignoreplace_file_1s(lists:keydelete(IgnoreFile, 2, FileLists), IgnoreFiles).

%% 获取需要过滤的文件列表
get_ignore_files() ->
    {ok, Cwd} = file:get_cwd(),
    Files1 = get_specify_files(?common_ignore_dirs_exts),
    Files2 = [Cwd ++ File ||File <- ?common_ignore_files],
    Files3 = [Cwd ++ File ||File <- ?ignore_files],
    Files1 ++ Files2 ++ Files3.
get_specify_files(DirExts) ->
    get_specify_files(DirExts, []).
get_specify_files([], FileLists) -> 
    [FilePath || {_FileName, FilePath} <- FileLists];
get_specify_files([{Dir, Ext} | DirExts], FileLists) ->
    case adm:get_dir_files(Dir, Ext) of
        {ok, L} ->
            get_specify_files(DirExts, L ++ FileLists);
        _ ->
            ?ERR("获取目录【~s】下【~s】后缀文件时发生错误", [Dir, Ext]),
            get_specify_files(DirExts, FileLists)
    end.

%% 抽取中文，开始处理服务端文件列表
ext_server_files(FileList, MP, IMPList, DetsName) ->
    ext_server_files(FileList, MP, IMPList, DetsName, ldets:get_file_index(DetsName), []).

ext_server_files([], _MP, _IMPList, _DetsName, _Index, []) -> ok;
ext_server_files([], _MP, _IMPList, _DetsName, _Index, Fails) -> Fails;
ext_server_files([File | FileList], MP, IMPList, DetsName, Index, Fails) ->
    case file:open(File, [read, binary]) of
        {error, Reason} ->
            ext_server_files(FileList, MP, IMPList, DetsName, Index + 1, [util:fbin("open file error [file:~s] [reason:~w]", [File, Reason]) | Fails]);
        {ok, IoDev} ->
            ?INFO("开始抽取文件 [~w] [~s]", [Index, File]),
            case ext_server_file(File, IoDev, MP, IMPList, DetsName, Index) of
                {error, Reasons} -> 
                    file:close(IoDev),
                    ext_server_files(FileList, MP, IMPList, DetsName, Index + 1, Reasons ++ Fails);
                ok -> 
                    file:close(IoDev),
                    ext_server_files(FileList, MP, IMPList, DetsName, Index + 1, Fails)
            end
    end.

%% 开始抽取单个文件中中文，按行抽取
ext_server_file(File, IoDev, MP, IMPList, DetsName, FileIndex) ->
    ext_server_file(File, IoDev, MP, IMPList, DetsName, FileIndex, ldets:get_entry_index(DetsName, File), []).

ext_server_file(File, IoDev, MP, IMPList, DetsName, FileIndex, EntryIndex, Fails) ->
    case file:read_line(IoDev) of
        eof ->
            ok;
        {error, Reason} ->
            {error, [util:fbin("file read line error [file:~s] [reason:~w]", [File, Reason]) | Fails]};
        {ok, Bin} ->
            case is_ignored(Bin, IMPList) of
                true ->
                    ext_server_file(File, IoDev, MP, IMPList, DetsName, FileIndex, EntryIndex, Fails);
                false ->
                    case re:run(Bin, MP, [global]) of
                        nomatch ->
                            ext_server_file(File, IoDev, MP, IMPList, DetsName, FileIndex, EntryIndex, Fails);
                        {match, M} ->
                            save_entry(File, Bin, M, DetsName, FileIndex, EntryIndex),
                            ext_server_file(File, IoDev, MP, IMPList, DetsName, FileIndex, EntryIndex + length(M), Fails)
                    end
            end
    end.

%% 抽取中文 策划使用 单文件处理
ext_xml_files(FileList, MP, DetsName) ->
    ext_xml_files(FileList, MP, DetsName, ldets:get_file_index(DetsName), []).

ext_xml_files([], _MP, _DetsName, _Index,  []) -> ok;
ext_xml_files([], _MP, _DetsName, _Index, Fails) -> Fails;
ext_xml_files([File | FileList], MP, DetsName, Index, Fails) -> 
    case file:read_file(File) of
        {ok, Bin} ->
            ?INFO("开始抽取文件 [~w] [~s]", [Index, File]),
            case re:run(Bin, MP, [global]) of
                nomatch -> 
                    ext_xml_files(FileList, MP, DetsName, Index + 1, Fails);
                {match, M} -> 
                    save_entry(File, Bin, M, DetsName, Index, ldets:get_entry_index(DetsName, File)),
                    ext_xml_files(FileList, MP, DetsName, Index + 1, Fails)
            end;
        {error, Reason} ->
            ext_xml_files(FileList, MP, DetsName, Index + 1, [util:fbin("读取文件 [~s] 发生错误, 错误信息: [~w]", [File, Reason]) | Fails])
    end.

%% 将抽取出来的数据回写dets
save_entry(_File, _Bin, [], _DetsName, _FileIndex, _EntryIndex) ->
    ok;
save_entry(File, Bin, [[{P, L}] | M], DetsName, FileIndex, EntryIndex) ->
    ldets:insert(DetsName, File, FileIndex, binary:part(Bin, P, L), <<>>, false, EntryIndex),
    save_entry(File, Bin, M, DetsName, FileIndex, EntryIndex + 1).

%% 检测当前行是否忽略翻译处理
is_ignored(_Data, []) -> false;
is_ignored(Data, [MP | IMPS]) ->
    case re:run(Data, MP) of
        nomatch -> is_ignored(Data, IMPS);
        _ -> true
    end.

%% 判断文件是否与 DEBUG, INFO, ELOG, ERR, LOG 等有关系
is_related_info(FilePath) ->
    case filename:extension(FilePath) of
        <<".hrl">> -> false;
        <<".erl">> -> not(lists:member(filename:basename(FilePath, <<".erl">>), ?direct_replace_files));
        _ -> false
    end.

%% 将字典数据中简体字段作为正则表达式，进行编译
compile_re_mps(Dicts) ->
    compile_re_mps(Dicts, []).

compile_re_mps([], NewDicts) ->
    NewDicts;
compile_re_mps([Dict = #dict{cn = Cn} | Dicts], NewDicts) ->
    case re:compile(escape(Cn), [unicode]) of
        {ok, MP} ->
            compile_re_mps(Dicts, [Dict#dict{mp = MP} | NewDicts]);
        {error, ErrSpec} ->
            ?ERR("re compile error , [cn:~s] [reason:~w]", [Cn, ErrSpec]),
            error
    end.

%% 替换语言包
replace_file_1(File, Dicts, IMPS) ->
    ?INFO("开始替换文件 [~s]", [File]),
    Dir = filename:dirname(File),
    FileTemp = <<Dir/binary, <<"_temp">>/binary>>,
    {ok, _ByteCopied} = file:copy(File, FileTemp),
    {ok, IoDevTemp} = file:open(FileTemp, [read, binary]),
    {ok, IoDev} = file:open(File, [write]),
    replace_file_1(IoDevTemp, IoDev, Dicts, IMPS),
    file:close(IoDevTemp),
    file:close(IoDev),
    file:delete(FileTemp).

%% 需要过滤 DEBUG, INFO, ELOG, ERR, LOG 等
replace_file_1(Source, Dest, Dicts, IMPS) ->
    case file:read_line(Source) of
        eof ->
            eof;
        {error, Reason} ->
            ?ERR("file read line error [error:~w]", [Reason]),
            error;
        {ok, Data} ->
            case is_ignored(Data, IMPS) of
                true -> file:write(Dest, Data);
                false -> file:write(Dest, re_data(Data, Dicts))
            end,
            replace_file_1(Source, Dest, Dicts, IMPS)
    end.

re_data(Data, []) -> Data;
re_data(Data, [#dict{mp = MP, tr = Tr} | Dicts]) ->
    re_data(re:replace(Data, MP, escape_erl(Tr), [global]), Dicts).

%% 替换文件内容
replace_file_2(FilePath, Dicts) ->
    ?INFO("开始替换文件 [~s]", [FilePath]),
    case file:read_file(FilePath) of
        {ok, FileBin} ->
            case file:open(FilePath, [write]) of
                {ok, IoDev} ->
                    case replace_strs(Dicts, FileBin) of
                        {error, Reason} -> 
                            ?ERR("语言替换发生错误 [~s] [~s]", [Reason, FilePath]),
                            file:write(IoDev, FileBin);
                        NewFileBin -> 
                            file:write(IoDev, NewFileBin)
                    end,
                    file:close(IoDev);
                {error, Reason} ->
                    ?ERR("文件回写发生错误 [~s] [~s]", [Reason, FilePath]),
                    ok
            end;
        {error, Reason} ->
            ?ERR("读取文件 [~s] 发生错误 [Reason: ~w]", [FilePath, Reason]),
            ok
    end.

replace_strs([], FileBin) -> FileBin;
replace_strs([#dict{cn = Cn, tr = Tr, status = true} | Dicts], FileBin) -> 
    try re:replace(FileBin, escape(Cn), escape_erl(Tr), [unicode, global]) of
        ReBin -> 
            case FileBin =:= ReBin of
                true -> ?ERR("替换失败词断,【~s】", [Cn]);
                false -> ok
            end,
            replace_strs(Dicts, ReBin)
    catch
        Error:Info -> {error, util:fbin("正则匹配替换发生 ~w ,Reason ~w, 词汇 ~s", [Error, Info, Cn])}
    end;
replace_strs([_ | Dicts], FileBin) -> 
    replace_strs(Dicts, FileBin).

%% 转义 替换对象 内容
escape(Simplified) ->
    escape(Simplified, <<>>).
escape(<<>>, EscapeBin) -> EscapeBin;
escape(<< Byte:1/binary, Simplified/binary>>, EscapeBin) ->
    case Byte of
        <<"[">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"[">>/binary>>);
        <<"]">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"]">>/binary>>);
        <<"(">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"(">>/binary>>);
        <<")">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<")">>/binary>>);
        <<"*">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"*">>/binary>>);
        <<"+">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"+">>/binary>>);
        <<".">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<".">>/binary>>);
        <<"?">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"?">>/binary>>);
        <<"\\">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"\\">>/binary>>);
        <<"^">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"^">>/binary>>);
        <<"{">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"{">>/binary>>);
        <<"}">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"}">>/binary>>);
        <<"|">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"|">>/binary>>);
        <<"$">> ->
            escape(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"$">>/binary>>);
        _ ->
            escape(Simplified, <<EscapeBin/binary, Byte/binary>>)
    end.

%% 转义替换后内容
escape_erl(Simplified) ->
    escape_erl(Simplified, <<>>).
escape_erl(<<>>, EscapeBin) -> EscapeBin;
escape_erl(<< Byte:1/binary, Simplified/binary>>, EscapeBin) ->
    case Byte of
        <<"\\">> ->
            escape_erl(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"\\">>/binary>>);
        <<"&">> ->
            escape_erl(Simplified, <<EscapeBin/binary, <<"\\">>/binary, <<"&">>/binary>>);
        _ ->
            escape_erl(Simplified, <<EscapeBin/binary, Byte/binary>>)
    end.

%% 将有引用 头文件 time.hrl 文件中 open 系列 的宏定义 引用改成 close 系列，rid_activity_time_open_quote
ratoq([], _) -> ok;
ratoq([TimeHrl | FileList], TimeHrl) ->
    ratoq(FileList, TimeHrl);
ratoq([FilePath | FileList], _TimeHrl) ->
    case file:read_file(FilePath) of
        {ok, FileBin} ->
            case file:open(FilePath, [write]) of
                {ok, IoDev} ->
                    ReBin = ratoq_re(FileBin),
                    case ReBin =:= FileBin of
                        true ->
                            file:write(IoDev, FileBin);
                        false ->
                            ?INFO("已更新文件 [~s]", [filename:basename(FilePath)]),
                            file:write(IoDev, ReBin)
                    end,
                    file:close(IoDev),
                    ratoq(FileList, _TimeHrl);
                {error, Reason} ->
                    ?ERR("open file error [file:~s] [reason:~w]", [FilePath, Reason]),
                    ratoq(FileList, _TimeHrl)
            end;
        {error, Reason} ->
            ?ERR("open file error [file:~s] [reason:~w]", [FilePath, Reason]),
            ratoq(FileList, _TimeHrl)
    end.

%% 将有引用 头文件 time.hrl 文件中 open 系列 的宏定义 引用改成 close 系列
ratoq_re(FileBin) ->
    ratoq_re(FileBin, ratoq_re_list()).
ratoq_re(FileBin, []) -> FileBin;
ratoq_re(FileBin, [{Open, Close} | ReList]) ->
    ratoq_re(re:replace(FileBin, Open, Close, [global]), ReList).

ratoq_re_list() ->
    [
        {"time_open_beg", "time_close_beg"}
%%        ,{"time_open_beg_sec", "time_close_beg_sec"}
%%        ,{"time_open_beg_zero", "time_close_beg_zero"}
%%        ,{"time_open_beg_zero_sec", "time_close_beg_zero_sec"}
        ,{"time_open_pre", "time_close_pre"}
%%        ,{"time_open_pre_sec", "time_close_pre_sec"}
%%        ,{"time_open_pre_zero", "time_close_pre_zero"}
%%        ,{"time_open_pre_zero_sec", "time_close_pre_zero_sec"}
        ,{"time_open_end", "time_close_end"}
%%        ,{"time_open_end_sec", "time_close_end_sec"}
%%        ,{"time_open_end_zero", "time_close_end_zero"}
%%        ,{"time_open_end_zero_sec", "time_close_end_zero_sec"}
    ].

clear_pre_entry(DetsName) ->
    clear_pre_entry(DetsName, dets:foldl(fun(Elem, Acc) -> [Elem | Acc] end, [], DetsName)).

clear_pre_entry(_DetsName, []) ->
    ok;
clear_pre_entry(DetsName, [Lang = #lang{file = File, dicts = Dicts} | Langs]) ->
    case [Dict || Dict <- Dicts, Dict#dict.ver =:= now] of
        [] ->
            ?INFO("已经 清理 文件 [~s]", [File]),
            dets:delete(DetsName, File);
        NewDicts ->
            ?INFO("已经 更新 文件 [~s]", [File]),
            dets:insert(DetsName, Lang#lang{dicts = NewDicts})
    end,
    clear_pre_entry(DetsName, Langs).

transfer_spec() ->
    case file:read_file("../src/lang/xml_spec_union.txt") of
        {ok, Bin} ->
            NewBin = get_xml_std_info_subsitute(Bin),
            case file:open("../src/lang/xml_spec_union.txt", [write]) of
                {ok, IoDev} ->
                    file:write(IoDev, NewBin),
                    file:close(IoDev);
                {error, _Reason} ->
                    ok
            end;
        {error, _Reason} ->
            ok
    end.

%% 处理带标准命名空间信息的元素段信息
clear_xml_std() ->
    case re:compile(?clear_xml_std_info_re, [unicode, ungreedy, dotall]) of
        {error, Reason} ->
            ?ERR("compile clear_xml_std_info_re error [reason:~w]", [Reason]),
            error;
        {ok, MP} ->
            clear_xml_std(get_file_list(xml), MP)
    end.

clear_xml_std([], _MP) ->
    ok;
clear_xml_std([File | FileList], MP) ->
    case file:read_file(File) of
        {error, Reason} ->
            ?ERR("read file error, [file:~s] [reason:~w]", [File, Reason]);
        {ok, Bin} ->
            case re:run(Bin, MP, [global]) of
                nomatch -> ok;
                {match, M} ->
                    NewBin = clear_xml_std_info(Bin, M),
                    case file:open(File, [write]) of
                        {ok, IoDev} ->
                            file:write(IoDev, NewBin),
                            file:close(IoDev);
                        {error, Reason} ->
                            ?ERR("open file error [file:~s] [reason:~w]", [File, Reason])
                    end
            end
    end,
    clear_xml_std(FileList, MP).

clear_xml_std_info(Bin, M) ->
    StdInfos = get_xml_std_info(Bin, M),
    handle_xml_std_info(Bin, StdInfos).
handle_xml_std_info(NewBin, []) ->
    NewBin;
handle_xml_std_info(Bin, [StdInfo | StdInfos]) ->
    Sub = get_xml_std_info_subsitute(StdInfo),
    NewBin = re:replace(Bin, escape(StdInfo), escape_erl(Sub), [unicode, global]),
    case NewBin =:= Bin of
        true -> ?ERR("处理xml std 信息时，替换回去失败, [~s]", [StdInfo]);
        false -> ok
    end,
    handle_xml_std_info(NewBin, StdInfos).

get_xml_std_info(Bin, M) ->
    get_xml_std_info(Bin, M, []).
get_xml_std_info(_Bin, [], StdInfos) ->
    [StdInfo || {StdInfo, _L} <- lists:reverse(lists:keysort(2, StdInfos))];
get_xml_std_info(Bin, [[{P, L}] | M], StdInfos) ->
    StdInfo = binary:part(Bin, P, L),
    case lists:member({StdInfo, L}, StdInfos) of
        true -> get_xml_std_info(Bin, M, StdInfos);
        false -> get_xml_std_info(Bin, M, [{StdInfo, L} | StdInfos])
    end.

get_xml_std_info_subsitute(StdInfo) ->
    get_xml_std_info_subsitute(StdInfo, lists:reverse(lists:keysort(3, get_xml_std_info_mp()))).

get_xml_std_info_subsitute(NewStdInfo, []) ->
    NewStdInfo;
get_xml_std_info_subsitute(StdInfo, [{Mp, Re, _} | Mps]) ->
    get_xml_std_info_subsitute(re:replace(StdInfo, Mp, Re, [global, {return, binary}]), Mps).

analysis_xml_label(Bin) ->
    case re:run(Bin, "<.*>", [unicode, ungreedy, global, dotall]) of
        nomatch -> ok;
        {match, M} ->
            Fun = fun([{P, L}]) ->
                    Label = binary:part(Bin, P, L),
                    case get(xml_label) of
                        undefined -> put(xml_label, [Label]);
                        Labels ->
                            case lists:member(Label, Labels) of
                                true -> ok;
                                false -> put(xml_label, [Label | Labels])
                            end
                    end
            end,
            lists:foreach(Fun, M)
    end.

get_xml_std_info_mp() ->
    {ok, U_mp_1} = re:compile("<U>", [unicode, ungreedy, dotall]),
    {ok, U_mp_0} = re:compile("</U>", [unicode, ungreedy, dotall]),
    {ok, F_mp_1} = re:compile("<Font.*>", [unicode, ungreedy, dotall]),
    {ok, F_mp_0} = re:compile("</Font>", [unicode, ungreedy, dotall]),
    {ok, B_mp_1} = re:compile("<B>", [unicode, ungreedy, dotall]),
    {ok, B_mp_0} = re:compile("</B>", [unicode, ungreedy, dotall]),
    {ok, S_mp_1} = re:compile("<ss:Data.*>", [unicode, ungreedy, dotall]),
    {ok, S_mp_2} = re:compile("<ss:Data.*ss:Type=\"String\".*>", [unicode, ungreedy, dotall]),
    {ok, S_mp_0} = re:compile("</ss:Data>", [unicode, ungreedy, dotall]),
    [{F_mp_0, <<>>, 0}, {F_mp_1, <<>>, 0}, {B_mp_0, <<>>, 0}, {B_mp_1, <<>>, 0}, {U_mp_0, <<>>, 0}, {U_mp_1, <<>>, 0}, {S_mp_0, <<"</Data>">>, 0}, {S_mp_1, <<"<Data>">>, 1}, {S_mp_2, <<"<Data ss:Type=\"String\">">>, 2}].



transfer([], _MP, _IMPS) ->
    ok;
transfer([File | FileList], MP, IMPS) ->
    Dir = filename:dirname(File),
    FileTemp = <<Dir/binary, <<"_temp">>/binary>>,
    {ok, _ByteCopied} = file:copy(File, FileTemp),
    case file:open(FileTemp, [read, binary]) of
        {error, _Reason} ->
            ?ERR("read file error [file:~w] [reason:~w]", [File, _Reason]),
            file:delete(FileTemp),
            transfer(FileList, MP, IMPS);
        {ok, FIO} ->
            case file:open(File, [write]) of
                {error, _Reason} ->
                    ?ERR("read file error [file:~w] [reason:~w]", [File, _Reason]);
                {ok, TIO} ->
                    transfer_file(FIO, TIO, MP, IMPS),
                    file:close(TIO)
            end,
            file:close(FIO),
            file:delete(FileTemp),
            transfer(FileList, MP, IMPS)
    end.

transfer_file(FIO, TIO, MP, IMPS) ->
    case file:read_line(FIO) of
        eof ->
            eof;
        {error, Reason} ->
            ?ERR("file read line error [error:~w]", [Reason]),
            error;
        {ok, Bin} ->
            case is_ignored(Bin, IMPS) of
                true ->
                    file:write(TIO, Bin),
                    transfer_file(FIO, TIO, MP, IMPS);
                false ->
                    case re:run(Bin, MP, [global]) of
                        nomatch ->
                            file:write(TIO, Bin),
                            transfer_file(FIO, TIO, MP, IMPS);
                        {match, M} ->
                            file:write(TIO, transfer_bin(Bin, lists:reverse(lists:keysort(1, get_matchs(Bin, M))))),
                            transfer_file(FIO, TIO, MP, IMPS)
                    end
            end
    end.

get_matchs(Bin, M) ->   
    get_matchs(Bin, M, []).
get_matchs(_Bin, [], Matchs) -> Matchs;
get_matchs(Bin, [[{P, L}] | M], Matchs) ->
    get_matchs(Bin, M, [{L, binary:part(Bin, P, L)} | Matchs]).

transfer_bin(Bin, []) ->
    Bin;
transfer_bin(Bin, [{_, Str} | Matchs]) ->
    NewStr = util:fbin("language:get(~s)", [Str]),
    transfer_bin(re:replace(Bin, escape(Str), escape_erl(NewStr), [unicode, global]), Matchs).

%%
transfer_activity([], _MP) ->
    ok;
transfer_activity([File | FileList], MP) ->
    case file:read_file(File) of
        {error, _Reason} ->
            ?ERR("read file error [file:~w] [reason:~w]", [File, _Reason]),
            transfer_activity(FileList, MP);
        {ok, Bin} ->
            case file:open(File, [write]) of
                {error, _Reason} ->
                    ?ERR("open file error [file:~w] [reason:~w]", [File, _Reason]),
                    transfer_activity(FileList, MP);
                {ok, IoDev} ->
                    NewBin = re:replace(Bin, MP, "language:get", [global]),
                    file:write(IoDev, NewBin),
                    file:close(IoDev)
            end,
            transfer_activity(FileList, MP)
    end.
