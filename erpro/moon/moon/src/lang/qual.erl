%%----------------------------------------------------
%% 语言文件检测模块
%% @author weihua@jieyou.cn 
%%----------------------------------------------------
-module(qual).
-export([trincn/2                   %% 校验翻译文件中是否有中文
        ,changed_cn/2               %% 检测语言文件中原简体内容是否修改了
        ,arg_union/2                %% 检测参数匹配，上下行格式文件, 无法处理换行的词条
        ,arg_div/3                  %% 检测参数匹配, 无法处理换行的词条
        ,misstr/0                   %% 检测服务还有没有没有翻译的
        ,multr_union/1
        ,multr_div/2
        ,re_err/2
    ]
).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("lang.hrl").

%% @spec trincn(Type, FileName) -> ok
%% Type = xml | server
%% FileName = binary() | string()
%% @doc 检查翻译内容中是否含有中文
trincn(Type, FileName) ->
    ErrorFile = case Type of
        xml -> ?lang_xml_translation_error;
        server -> ?lang_server_translation_error
    end,
    case file:open(FileName, [read, binary]) of
        {ok, IoDev} -> 
            case file:open(ErrorFile, [write, append]) of
                {ok, IoDevError} ->
                    file:write(IoDevError, io_lib:format("第一类：翻译内容中含有中文字符, 对应文件: ~s\n", [filename:basename(FileName)])),
                    trincn(IoDev, IoDevError, 0),
                    file:close(IoDevError);
                {error, Reason} ->
                    ?ERR("open file error [file:~s] [reason:~w]", [ErrorFile, Reason]),
                    error
            end,
            file:close(IoDev);
        {error, Reason} ->
            ?ERR("open file error [file:~s] [reason:~w]", [FileName, Reason]),
            error
    end.

%% @spec changed_cn(CnFile, TrFile) -> ok
%% CnFile = TrFile = binary() | string()
%% @doc CnFile 作为基准，检测 TrFile 中的简体内容是否被改动了, 适用于上下行格式情况
changed_cn(CnFile, TrFile) ->
    case file:open(CnFile, [read, binary]) of
        {ok, IoDevCn} ->
            case file:open(TrFile, [read, binary]) of
                {ok, IoDevTr} ->
                    changed_cn(IoDevCn, IoDevTr, 0),
                    file:close(IoDevTr);
                {error, Reason} ->
                    ?ERR("open file error [file:~s] [reason:~w]", [TrFile, Reason]),
                    error
            end,
            file:close(IoDevCn);
        {error, Reason} ->
            ?ERR("open file error [file:~s] [reason:~w]", [CnFile, Reason]),
            error
    end.

%% @spec arg_union(Type) -> error | ok
%% Type = xml | server
%% BasicFile = binary() | string()
%% @doc 检测简体原文与翻译内容字符匹配
arg_union(Type, BasicFile) ->
    ErrorFile = case Type of
        server -> ?lang_server_translation_error;
        xml -> ?lang_xml_translation_error
    end,
    case file:open(BasicFile, [read, binary]) of
        {ok, IoDev} ->
            case file:open(ErrorFile, [write, append]) of
                {ok, IoDevEr} ->
                    file:write(IoDevEr, io_lib:format("\n第二类：翻译内容中 特殊符号 对不上，请检查是否遗漏或多余，可能引发严重 bug, 对应文件: ~s\n", [filename:basename(BasicFile)])),
                    arg_union(IoDev, IoDevEr, 0),
                    file:close(IoDevEr);
                {error, Reason} ->
                    ?ERR("open file error [file:~s] [reason:~w]", [ErrorFile, Reason]),
                    error
            end,
            file:close(IoDev);
        {error, Reason} ->
            ?ERR("open file error [file:~s] [reason:~w]", [BasicFile, Reason]),
            error
    end.

%% @spec arg_div(Type, CnFile, TrFile) -> error | ok
%% Type = xml | server
%% CnFile = TrFile = binary() | string()
%% @doc 检测简体原文与翻译内容字符匹配
arg_div(Type, CnFile, TrFile) ->
    ErFile = case Type of
        server -> ?lang_server_translation_error;
        xml -> ?lang_xml_translation_error
    end,
    case file:open(CnFile, [read, binary]) of
        {ok, IoDevCn} ->
            case file:open(TrFile, [read, binary]) of
                {ok, IoDevTr} ->
                    case file:open(ErFile, [write, append]) of
                        {ok, IoDevEr} ->
                            file:write(IoDevEr, io_lib:format("\n第二类：翻译内容中 特殊符号 对不上，请检查是否遗漏或多余，可能引发严重 bug, 对应文件: ~s\n", [filename:basename(CnFile)])),
                            arg_div(IoDevCn, IoDevTr, IoDevEr, 0),
                            file:close(IoDevEr);
                        {error, Reason} ->
                            ?ERR("open file error [file:~s] [reason:~w]", [ErFile, Reason]),
                            error
                    end,
                    file:close(IoDevTr);
                {error, Reason} ->
                    ?ERR("open file error [file:~s] [reason:~w]", [TrFile, Reason]),
                    error
            end,
            file:close(IoDevCn);
        {error, Reason} ->
            ?ERR("open file error [file:~s] [reason:~w]", [CnFile, Reason]),
            error
    end.

%% @spec misstr() -> ok
%% @doc 检测服务端没有翻译到的
misstr() ->
    case file:open(?lang_server_error, [write]) of
        {ok, IoDevErr} ->
            dets:open_file(?lang_server_dets_name, [{file, ?lang_server_dets}, {keypos, #lang.file}, {type, set}]),
            case dets:first(?lang_server_dets_name) of
                '$end_of_table' ->
                    ?INFO("没有任何字典数据");
                _ ->
                    ?INFO("开始扫描字典数据..."),
                    {ok, IMP} = re:compile("INFO|ELOG|ERR|DEBUG|^%|log:log|guild_log"),
                    {ok, CnMP} = re:compile("\"[^\"\n]*[\x{4e00}-\x{9fff}][^\"\n]*\"", [unicode]),
                    dets:traverse(?lang_server_dets_name,
                        fun(#lang{file = FilePath}) ->
                                misstr_file(FilePath, IoDevErr, IMP, CnMP),
                                continue
                        end
                    ),
                    ?INFO("本次字典数据扫描完毕！")
            end,
            file:close(IoDevErr),
            dets:close(?lang_server_dets_name);
        {error, Reason} ->
            ?ERR("open file error [file:~s] [reason:~w]", [?lang_server_error, Reason]),
            error
    end.

%% @spec multr_union(File) -> ok | {error, Reason}
%% File = binary() | string()
%% @doc 多版本翻译
multr_union(File) ->
    case file:open(File, [read, binary]) of
        {ok, IoDev} ->
            case file:open("../src/lang/multi_translation_error.txt", [write, exclusive]) of
                {ok, IoDevErr} ->
                    multi_translation_union(IoDev),
                    output_multi_translation(IoDevErr),
                    file:close(IoDev),
                    file:close(IoDevErr);
                {error, Reason} ->
                    {error, Reason}
            end;
        {error, Reason} ->
            {error, Reason}
    end.

%% @spec multr_div(CnFile, TrFile) -> ok | {error, Reason}
%% CnFile = TrFile = binary() | string()
%% @doc 多版本翻译
multr_div(CnFile, TrFile) ->
    case file:open(CnFile, [read, binary]) of
        {ok, CnIoDev} ->
            case file:open(TrFile, [read, binary]) of
                {ok, TrIoDev} ->
                    case file:open("../src/lang/multi_translation_error.txt", [write, exclusive]) of
                        {ok, IoDevErr} ->
                            multi_translation_div(CnIoDev, TrIoDev),
                            output_multi_translation(IoDevErr),
                            file:close(TrIoDev),
                            file:close(CnIoDev),
                            file:close(IoDevErr);
                        {error, Reason} ->
                            file:close(CnIoDev),
                            file:close(TrIoDev),
                            {error, Reason}
                    end;
                {error, Reason} ->
                    file:close(CnIoDev),
                    {error, Reason}
            end;
        {error, Reason} ->
            {error, Reason}
    end.

%% re_err(Type) -> ok
re_err(Type, File) ->
    Mps = get_re_err_mps(Type),
    case file:open(File, [read, binary]) of
        {ok, IoDev} ->
            re_err(IoDev, Mps, 1),
            file:close(IoDev);
        {error, Reason} ->
            {error, Reason}
    end.

%%----------------------------------------------------------------
%% 私有函数
%%----------------------------------------------------------------
%% 检测输入流中是否有中文字符
trincn(IoDev, IoDevError, Line) ->
    case re:compile("[\x{4e00}-\x{9fff}]*[\x{4e00}-\x{9fff}]", [unicode]) of
        {ok, MP} ->
            trincn(IoDev, IoDevError, Line, MP);
        {error, Reason} ->
            ?ERR("compile re error, ~w",[Reason])
    end.

trincn(IoDev, IoDevError, Line, MP) ->
    case file:read_line(IoDev) of
        eof -> eof;
        {error, Reason} -> ?ERR("read file line error [error:~w]", [Reason]);
        {ok, Data} ->
            Bin = lutil:nocrlf(Data),
            case byte_size(Bin) >= ?pre_head of
                true ->
                    <<Pre:?pre_head/binary, _Rem/binary>> = Bin,
                    case Pre =:= <<"[T]:">> of
                        true ->
                            case re:run(Bin, MP) of
                                nomatch ->
                                    trincn(IoDev, IoDevError, Line + 1, MP);
                                {match , [{P, L}]} ->
                                    ?ERR("第 [~w] 行翻译内容中有中文字符 [~s]", [Line + 1, binary:part(Bin, P, L)]),
                                    file:write(IoDevError, io_lib:format("第 [~w] 行翻译内容中有中文字符 [~s]\n", [Line + 1, binary:part(Bin, P, L)])),
                                    trincn(IoDev, IoDevError, Line + 1, MP)
                            end;
                        false ->
                            trincn(IoDev, IoDevError, Line + 1, MP)
                    end;
                false ->
                    trincn(IoDev, IoDevError, Line + 1, MP)
            end
    end.

changed_cn(IoDevCn, IoDevTr, Line) ->
    case file:read_line(IoDevCn) of
        eof -> eof;
        {error, Reason} -> ?ERR("read file line error [error:~w]", [Reason]);
        {ok, CnData} ->
            case file:read_line(IoDevTr) of
                eof -> eof;
                {error, Reason} -> ?ERR("read file line error [error:~w]", [Reason]);
                {ok, TrData} ->
                    CnBin = lutil:nocrlf(CnData),
                    TrBin = lutil:nocrlf(TrData),
                    case byte_size(CnBin) >= ?pre_head andalso byte_size(TrBin) >= ?pre_head of
                        true ->
                            <<CnPre:?pre_head/binary, CnRem/binary>> = CnBin,
                            <<TrPre:?pre_head/binary, TrRem/binary>> = TrBin,
                            case {CnPre, TrPre} of
                                {<<"[S]:">>, <<"[S]:">>} when CnRem =/= TrRem ->
                                    ?ERR("第 [~w] 行的简体内容与原文件内容不符合", [Line + 1]),
                                    changed_cn(IoDevCn, IoDevTr, Line + 1);
                                {<<"[S]:">>, <<"[S]:">>} ->
                                    changed_cn(IoDevCn, IoDevTr, Line + 1);
                                _ when CnPre =:= TrPre -> 
                                    changed_cn(IoDevCn, IoDevTr, Line + 1);
                                _ -> 
                                    ?ERR("第 [~w] 行内容格式有误", [Line + 1]),
                                    file_data_formt_error
                            end;
                        false -> changed_cn(IoDevCn, IoDevTr, Line + 1)
                    end
            end
    end.

arg_union(IoDev, IoDevError, Line) ->
    case file:read_line(IoDev) of
        eof -> eof;
        {error, Reason} -> ?ERR("read file line error [error:~w]", [Reason]);
        {ok, Data} ->
            Bin = lutil:nocrlf(Data),
            case byte_size(Bin) >= ?pre_head of
                true ->
                    <<Pre:?pre_head/binary, CnRem/binary>> = Bin,
                    case Pre of
                        <<"[S]:">> ->
                            case file:read_line(IoDev) of
                                eof -> eof;
                                {error, Reason} -> ?ERR("read file line error [error:~w]", [Reason]);
                                {ok, DataT} ->
                                    BinT = lutil:nocrlf(DataT),
                                    case byte_size(BinT) >= ?pre_head of
                                        true ->
                                            <<PreT:?pre_head/binary, TrRem/binary>> = BinT,
                                            case PreT of
                                                <<"[T]:">> ->
                                                    CnArgs = get_args_parts(CnRem),
                                                    TrArgs = get_args_parts(TrRem),
                                                    diff_args(CnArgs, CnRem, TrArgs, TrRem, Line + 1, IoDevError),
                                                    arg_union(IoDev, IoDevError, Line + 2);
                                                _ -> ?ERR("line [~w] file data format error", [Line + 2])
                                            end;
                                        _ -> ?ERR("line [~w] file data format error", [Line + 2])
                                    end
                            end;
                        <<"[T]:">> -> ?ERR("line [~w] file data format error", [Line + 1]);
                        _ -> arg_union(IoDev, IoDevError, Line + 1)
                    end;
                _ -> arg_union(IoDev, IoDevError, Line + 1)
            end
    end.

arg_div(IoDevCn, IoDevTr, IoDevEr, Line) ->
    case file:read_line(IoDevCn) of
        eof -> eof;
        {erro, Reason} ->
            ?ERR("read file line error [error:~w]", [Reason]),
            error;
        {ok, DataCn} ->
            case file:read_line(IoDevTr) of
                eof -> eof;
                {error, Reason} ->
                    ?ERR("read file line error [error:~w]", [Reason]),
                    error;
                {ok, DataTr} ->
                    CnBin = lutil:nocrlf(DataCn),
                    TrBin = lutil:nocrlf(DataTr),
                    case {byte_size(CnBin) >= ?pre_head, byte_size(TrBin) >= ?pre_head} of
                        {true, true} ->
                            <<CnPre:?pre_head/binary, CnRem/binary>> = CnBin,
                            <<TrPre:?pre_head/binary, TrRem/binary>> = TrBin,
                            case {CnPre, TrPre} of
                                {<<"[S]:">>, <<"[T]:">>} ->
                                    CnArgs = get_args_parts(CnRem),
                                    TrArgs = get_args_parts(TrRem),
                                    diff_args(CnArgs, CnRem, TrArgs, TrRem, Line + 1, IoDevEr),
                                    arg_div(IoDevCn, IoDevTr, IoDevEr, Line + 1);
                                {PreCo, PreCo} ->
                                    arg_div(IoDevCn, IoDevTr, IoDevEr, Line + 1);
                                {Pre1, Pre2} ->
                                    ?ERR("line data format error , pre1 is [~s], pre2 is [~s]", [Pre1, Pre2]),
                                    error
                            end;
                        {false, false} -> arg_div(IoDevCn, IoDevTr, IoDevEr, Line + 1);
                        _ ->
                            ?ERR("data format error [line:~w]", [Line + 1]),
                            error
                    end
            end
    end.

get_args_parts(Bin) ->
    case re:run(Bin, "\~", [unicode, global, ungreedy]) of
        {match, BM} -> BM;
        nomatch -> []
    end.

diff_args(BaseArgs, Base, FreshArgs, Fresh, BaseLine, ErrIoDev) ->
    diff_args(BaseArgs, Base, FreshArgs, Fresh, BaseLine, 1, ErrIoDev, normal).

diff_args([], _Base, [], _Fresh, _BaseLine, _Index, _ErrIoDev, normal) ->
    ok;
diff_args([], Base, [], Fresh, BaseLine, _Index, ErrIoDev, abnormal) ->
    file:write(ErrIoDev, io_lib:format("第 [~w] 行的简体内容以及对应的翻译内容如下两行:~n[S]:~s~n[T]:~s~n~n", [BaseLine, Base, Fresh]));
diff_args([], _Base, [[{P, L}] | FreshArgs], Fresh, BaseLine, _Index, ErrIoDev, _) ->
    ?ERR("第 [~w] 行参数匹配不上，翻译内容中多出了参数 [~s]", [BaseLine, binary:part(Fresh, P, L)]),
    file:write(ErrIoDev, io_lib:format("第 [~w] 行参数匹配不上，翻译内容中多出了参数 [~s]~n", [BaseLine, binary:part(Fresh, P, L)])),
    diff_args([], _Base, FreshArgs, Fresh, BaseLine, _Index, ErrIoDev, abnormal);
diff_args([[{P, L}] | BaseArgs], Base, [], _Fresh, BaseLine, Index, ErrIoDev, _) ->
    ?ERR("第 [~w] 行参数匹配不上，简体内容中第 [~w] 参数 [~s] 在翻译内容中找不到", [BaseLine, Index, binary:part(Base, P, L)]),
    file:write(ErrIoDev, io_lib:format("第 [~w] 行参数匹配不上，简体内容中第 [~w] 参数 [~s] 在翻译内容中找不到~n", [BaseLine, Index, binary:part(Base, P, L)])),
    diff_args(BaseArgs, Base, [], _Fresh, BaseLine, Index + 1, ErrIoDev, abnormal);
diff_args([[{BP, BL}] | BaseArgs], Base, [[{FP, FL}] | FreshArgs], Fresh, BaseLine, Index, ErrIoDev, Normal) ->
    BArg = binary:part(Base, BP, BL),
    FArg = binary:part(Fresh, FP, FL),
    NewNormal = case BArg =:= FArg of
        false -> 
            ?ERR("第 [~w] 行参数匹配不上，第 [~w] 个参数在简体内容中是 [~s], 在翻译内容中是 [~s]", [BaseLine, Index, BArg, FArg]),
            file:write(ErrIoDev, io_lib:format("第 [~w] 行参数匹配不上，第 [~w] 个参数在简体内容中是 [~s], 在翻译内容中是 [~s]~n", [BaseLine, Index, BArg, FArg])),
            abnormal;
        true -> Normal
    end,
    diff_args(BaseArgs, Base, FreshArgs, Fresh, BaseLine, Index + 1, ErrIoDev, NewNormal).

misstr_file(FilePath, IoDevErr, IMP, CnMP) ->
    ?INFO("开始检测文件 [~s]", [FilePath]),
    case file:open(FilePath, [read, binary]) of
        {ok, IoDev} ->
            misstr_line(FilePath, IoDevErr, IoDev, IMP, CnMP, 0, false),
            file:close(IoDev);
        {error, Reason} ->
            ?ERR("read file error [file:~s] [reason:~w]", [FilePath, Reason]),
            error
    end.

misstr_line(FilePath, IoDevErr, IoDev, IMP, CnMP, Line, Status) ->
    case file:read_line(IoDev) of
        eof -> eof;
        {error, Reason} ->
            ?ERR("read line error [reason:~w]", [Reason]),
            error;
        {ok, Data} ->
            case re:run(Data, IMP) of
                nomatch ->
                    case re:run(Data, CnMP) of
                        nomatch ->
                            misstr_line(FilePath, IoDevErr, IoDev, IMP, CnMP, Line + 1, Status);
                        {match , [{P, L}]} ->
                            ?ERR("第 [~w] 行中有未翻译中文字符 [~s]", [Line + 1, binary:part(Data, P, L)]),
                            case Status of
                                true -> ok;
                                false -> file:write(IoDevErr, io_lib:format("\n~s\n", [FilePath]))
                            end,
                            file:write(IoDevErr, io_lib:format("第 [~w] 行中有未翻译中文字符 [~s]\n", [Line + 1, binary:part(Data, P, L)])),
                            misstr_line(FilePath, IoDevErr, IoDev, IMP, CnMP, Line + 1, true)
                    end;
                _ ->
                    misstr_line(FilePath, IoDevErr, IoDev, IMP, CnMP, Line + 1, Status)
            end
    end.

%% 多版本翻译
multi_translation_union(IoDev) ->
    multi_translation_union(IoDev, 1).

multi_translation_union(IoDev, Line) ->
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
                                                    multi_translation_union(IoDev, Line + 2);
                                                <<"[T]:">> ->
                                                    multi_translation(CnRem, TrRem, Line),
                                                    multi_translation_union(IoDev, Line + 2);
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
                            multi_translation_union(IoDev, Line + 1)
                    end;
                _ ->
                    multi_translation_union(IoDev, Line + 1)
            end
    end.

%% 检测多版本翻译
multi_translation_div(CnIoDev, TrIoDev) ->
    multi_translation_div(CnIoDev, TrIoDev, 1).

multi_translation_div(CnIoDev, TrIoDev, Line) ->
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
                                {<<"[S]:">>, <<"[T]:">>} ->
                                    multi_translation(CnRem, TrRem, Line),
                                    multi_translation_div(CnIoDev, TrIoDev, Line + 1);
                                {PreCo, PreCo} ->
                                    multi_translation_div(CnIoDev, TrIoDev, Line + 1);
                                {Pre1, Pre2} ->
                                    ?ERR("line data format error , pre1 is [~s], pre2 is [~s]", [Pre1, Pre2]),
                                    error
                            end;
                        {false, false} ->
                            multi_translation_div(CnIoDev, TrIoDev, Line + 1);
                        _ ->
                            ?ERR("data format error [line:~w]", [Line]),
                            error
                    end
            end
    end.

%% 保存多版本数据到进程字典
multi_translation(Cn, Tr, Line) ->
    case get(multi) of
        undefined ->
            put(multi, [{Cn, [{Tr, [Line]}]}]);
        List ->
            case lists:keyfind(Cn, 1, List) of
                false ->
                    put(multi, [{Cn, [{Tr, [Line]}]} | List]);
                {Cn, Trs} ->
                    case lists:keyfind(Tr, 1, Trs) of
                        false ->
                            put(multi, lists:keyreplace(Cn, 1, List, {Cn, [{Tr, [Line]} | Trs]}));
                        {Tr, Lines} ->
                            put(multi, lists:keyreplace(Cn, 1, List, {Cn, lists:keyreplace(Tr, 1, Trs, {Tr, [Line | Lines]})}))
                    end
            end
    end.

%% 输出多版本翻译检测结果
output_multi_translation(IoDev) ->
    case get(multi) of
        undefined ->
            multi_undefined;
        List ->
            output_multi_translation(List, IoDev)
    end.

output_multi_translation([], _IoDev) ->
    ok;
output_multi_translation([{Cn, Trs} | List], IoDev) ->
    case Trs of
        [] -> ?ERR("empty translation");
        [{_Tr, _Lines}] -> ok;
        _ ->
            file:write(IoDev, io_lib:format("[S]:~s~n", [Cn])),
            output_multi_translation(Cn, Trs, IoDev),
            file:write(IoDev, "\n")
    end,
    output_multi_translation(List, IoDev).

output_multi_translation(_Cn, [], _IoDev) ->
    ok;
output_multi_translation(Cn, [{Tr, Lines} | Trs], IoDev) ->
    file:write(IoDev, "[N]:"),
    lists:foreach(fun(Line) -> file:write(IoDev, io_lib:format("~w\t", [Line])) end, Lines),
    file:write(IoDev, "\n"),
    file:write(IoDev, io_lib:format("[T]:~s~n", [Tr])),
    output_multi_translation(Cn, Trs, IoDev).

%% 获取 采用的 检错正则列表
get_re_err_mps(server) ->
    Re1 = "\\[T.*[^\"]$",                   %% 翻译内容那行，不是 引号结尾
    Re2 = "\\[T\\]:[^\"]",                  %% [T]: 后面不是引号
    Re3 = "\".*\".*\"",                     %% 有超过 3 个引号的
    Re4 = "\\[[ST]\\].*\\[[ST]\\]",         %% 一行中含有多个 [S]/[T]
    Re5 = "^[^\\[]",                        %% 开头不是 [
    Re6 = "\\[T\\][^:]",                    %% [S/T] 后面不是 :
    Res = [Re1, Re2, Re3, Re4, Re5, Re6],
    get_re_err_mps(Res, []);

get_re_err_mps(xml) ->
    Re1 = "&lt[^;]",
    Re2 = "&gt[^;]",
    Re3 = "[^&]lt",
    Re4 = "[^&]gt",
    Re5 = "[^{}]*{[^{}]*[^}]$",
    Re6 = "^[^{}]*}",
    Re7 = "&amp[^;]",
    Re8 = "[^&]amp",
    Re9 = "&#10[^;]",
    Re10 = "\\[[ST]\\].*\\[[ST]\\]",         %% 一行中含有多个 [S]/[T]
    Re11 = "^[^\\[]",                        %% 开头不是 [
    Re12 = "\\[T\\][^:]",                    %% [S/T] 后面不是 :
    Res = [Re1, Re2, Re3, Re4, Re5, Re6, Re7, Re8, Re9, Re10, Re11, Re12],
    get_re_err_mps(Res, []).

get_re_err_mps([], Mps) ->
    Mps;
get_re_err_mps([Re | Res], Mps) ->
    {ok, Mp} = re:compile(Re, [unicode]),
    get_re_err_mps(Res, [Mp |Mps]).

re_err(IoDev, Mps, Line) ->
    case file:read_line(IoDev) of
        eof -> eof;
        {error, Reason} -> {error, Reason};
        {ok, Bin} ->
            case lutil:nocrlf(Bin) of
                <<>> -> ok;
                NewBin -> 
                    case byte_size(NewBin) >= ?pre_head of
                        true ->
                            <<Pre:?pre_head/binary, _Bin/binary>> = NewBin,
                            case Pre =:= <<"[N]:">> of
                                false -> re_err_run(NewBin, Mps, Line);
                                true -> ok
                            end;
                        false -> ?ERR("line [~w] data format error", [Line])
                    end
            end,
            re_err(IoDev, Mps, Line + 1)
    end.

re_err_run(_Bin, [], _Line) ->
    ok;
re_err_run(Bin, [Mp | Mps], Line) ->
    case re:run(Bin, Mp, [global]) of
        nomatch -> re_err_run(Bin, Mps, Line);
        {match , Matchs} ->
            print_err_info(Bin, Matchs, Line),
            re_err_run(Bin, Mps, Line)
    end.

print_err_info(_Bin, [], _Line) ->
    ok;
print_err_info(Bin, [[{P, L}] | Matchs], Line) ->
    ?ERR("第 [~w] 行 存在可疑 字符串 【~s】", [Line, binary:part(Bin, P, L)]),
    print_err_info(Bin, Matchs, Line).
