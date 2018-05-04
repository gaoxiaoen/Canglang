%%----------------------------------------------------
%% 配合海外工作的一些工具
%% @author weihua@jieyou.cn 
%%----------------------------------------------------
-module(lutil).
-export([
        gm/0        %% 提取 GM 命令
        ,gift/0     %% 提取 礼包 数据
        ,nocrlf/1   %% 去除一个 binary() 末尾的 CRLF 字符
        ,rescape/2  %% 转义正则表达式的 相关转义
        ,ls/1       %% 获取指定目录下的所有文件列表
        ,file_filter/2      %% 过滤文件，返回指定后缀名列表的文件
        ,lib/1
        ,open_lib/0
        ,close_lib/0
        ,lib_lookup/1
        ,export/2
        ,replace/2
    ]
).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("item.hrl").
-include("lutil.hrl").

-define(lang_lib_dets_name, lang_lib).    %% 词库dets文件名
-define(lang_lib_dets_file, "../src/lang/lang_lib.dets").   %% 词库DETS文件路径
-define(each_xml_file_words, 50000).

%% 词库数据结构
-record(lang_lib, {
        cn = <<>>,
        tr = <<>>
    }
).

%% @spec gm() -> ok | error
%% @doc extract gm cmd
gm() ->
    case file:read_file("../src/mod/role/role_adm_rpc.erl") of
        {ok, FileBin} ->
            case file:open("../src/lang/gm.txt", [write]) of
                {ok, IoDev} ->
                    ?INFO("start to extract GM cmd..."),
                    try re:run(FileBin, "\\[\"[^\"]*\"[^\"]*\\]", [unicode, global, ungreedy]) of
                        nomatch ->
                            ?INFO("can not find any GM cmd!"),
                            ok;
                        {match, M} -> 
                            Fun = fun([{P, L}]) -> 
                                    Cmd = binary:part(FileBin, P, L),
                                    file:write(IoDev, <<Cmd/binary, <<"\r\n">>/binary>>) 
                            end,
                            lists:foreach(Fun, M),
                            ?INFO("GM cmd extract success!"),
                            file:close(IoDev),
                            ok
                    catch
                        Error:Info -> 
                            ?ERR("regex exception [error: ~w] [reason ~w]", [Error, Info]),
                            error
                    end;
                {error, Reason} ->
                    ?ERR("create GM cmd file [gm.txt] failed, [reason: ~w]", [Reason]),
                    error
            end;
        {error, Reason} ->
            ?ERR("read file [role_adm_rpc.erl] failed, [reason: ~w]", [Reason]),
            error
    end.

%% @spec gift() -> ok | error
%% @doc extract gifts data
gift() ->
    case file:read_file("../src/mod/misc/award_data.erl") of
        {ok, FileBin} ->
            case file:open("../src/lang/gift.txt", [write]) of
                {ok, IoDev} ->
                    get_gift(FileBin, IoDev),
                    file:close(IoDev),
                    ok;
                {error, Reason} ->
                    ?ERR("An error occurred while create file [gift.txt] [reason: ~w]", [Reason]),
                    error
            end;
        {error, Reason} ->
            ?ERR("An error occurred while reading file [award_data.erl] [reason: ~w]", [Reason]),
            error
    end.

%% @spec nocrlf(binary()) -> binary()
%% @doc get rid of the character CR and  character LF at the end of the binary string
nocrlf(<<>>) ->
    <<>>;
nocrlf(Bin) ->
    case binary:last(Bin) of
        10 -> nocrlf(binary:part(Bin, {0, byte_size(Bin)-1}));
        13 -> nocrlf(binary:part(Bin, {0, byte_size(Bin)-1}));
        _ -> Bin
    end.

%% @spec rescape(Type, Bin) -> NewBin | badarg
%% Type = regexp | replacement
%% Bin = NewBin = binary()
%% @doc escape the regexp or replacement, please don't use this function if you have arleady done some escape by yourself
rescape(Type, Bin) when is_binary(Bin) andalso (Type =:= regexp orelse Type =:= replacement) ->
    rescape(Type, Bin, <<>>);
rescape(_Type, _Bin) ->
    badarg_error_type_value.

%% @spec ls(Dir) -> List
%% Dir = string()
%% List = [string() | ..]
%% @doc get the file list of the dir
ls(Dir) ->
    case file:list_dir(Dir) of
        {ok, L} ->
            ls(Dir, L, []);
        _Other ->
            ?ERR("error occured when list the dir ~s", [Dir]),
            []
    end.

%% @spec file_filter(Files, ExtList) -> NewFiles
%% Files = NewFiles = ExtList = [string() | ..]
%% @doc fileter the files, return the ExtList Extensions files
file_filter(Files, ExtList) ->
    file_filter(Files, ExtList, []).
file_filter([], _ExtList, Files) ->
    Files;
file_filter([F | L], ExtList, Files) ->
    case lists:member(filename:extension(F), ExtList) of
        true ->
            file_filter(L, ExtList, [F|Files]);
        false ->
            file_filter(L, ExtList, Files)
    end.

%% @spec open_lib() -> term()
%% @doc open the lib 
open_lib() ->
    dets:open_file(?lang_lib_dets_name, [{file, ?lang_lib_dets_file}, {keypos, #lang_lib.cn}, {type, set}]).

%% @spec close_lib() -> term()
%% @doc close the lib
close_lib() ->
    dets:close(?lang_lib_dets_name).

%% @spec lib(CnTr) -> ok
%% CnTr = [{Cn, Tr} | ..]
%% @doc update the lib
lib(CnTrs) ->
    Fun = fun({Cn, Tr}) ->
            case Tr =:= <<>> of
                false -> dets:insert(?lang_lib_dets_name, #lang_lib{cn = Cn, tr = Tr});
                true -> ok
            end
    end,
    lists:foreach(Fun, CnTrs).

%% @spec lib_lookup(Cn) -> false | Binary()
%% @doc lookup the cn translation from the lib
lib_lookup(Cn) ->
    case dets:lookup(?lang_lib_dets_name, Cn) of
        [] ->
            false;
        [#lang_lib{tr = Tr}] ->
            Tr;
        {error, Reason} ->
            ?ERR("dets lookup error, ~w", [Reason]),
            false
    end.

%% @spec export(File, Words) -> ok
%% File = string()
%% Words = [#word{} | ..]
%% @type export language pack xml files
export(File, Words) ->
    Num = length(Words),
    TotalFiles = case Num rem ?each_xml_file_words of
        0 -> Num div ?each_xml_file_words;
        _ -> Num div ?each_xml_file_words + 1
    end,
    export(File, Words, TotalFiles, 1).

export(_File, [], _TotalFiles, _CurrentFileNum) ->
    ok;
export(File, Words, TotalFiles, CurrentFileNum) ->
    FileName = gen_xml_file_name(File, TotalFiles, CurrentFileNum),
    case file:open(FileName, [write]) of
        {ok, IoDev} ->
            RemWords = gen_xml(IoDev, Words, 0),
            file:close(IoDev),
            export(File, RemWords, TotalFiles, CurrentFileNum + 1);
        {error, Reason} ->
            ?ERR("create file failed [file:~w] [reason:~w]", [FileName, Reason])
    end.
gen_xml(IoDev, Words, 0) ->
    file:write(IoDev, "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n"),
    file:write(IoDev, "<translation xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"),
    gen_xml(IoDev, Words, 1);
gen_xml(IoDev, [#word{cn = Cn, tr = Tr, index = Index} |Words], Num) when Num =< ?each_xml_file_words ->
    file:write(IoDev, io_lib:format("\t<word>\n\t\t<index>~w</index>\n\t\t<cn>~s</cn>\n\t\t<tr>~s</tr>\n\t</word>\n", [Index, Cn, Tr])),
    gen_xml(IoDev, Words, Num + 1);
gen_xml(IoDev, Words, _) ->
    file:write(IoDev, "</translation>"),
    Words.

gen_xml_file_name(File, 1, 1) ->
    File ++ ".xml";
gen_xml_file_name(File, _, Part) ->
    File ++ "_part_" ++ integer_to_list(Part) ++ ".xml".

%% @spec replace(RE, ReplaceMent) -> ok
%% @doc 在所有 erl 文件中查找 RE，并替换成 ReplaceMent
replace(RE, ReplaceMent) ->
    {ok, Cwd} = file:get_cwd(),
    SrcFiles = lutil:ls(Cwd ++ "/../src"),
    Files = [list_to_binary(FilePath) || FilePath <- lutil:file_filter(SrcFiles, [".erl"])],
    case re:compile(rescape(regexp, RE), [unicode, ungreedy]) of
        {error, _ErrorSpec} ->
            error_re_expression;
        {ok, MP} ->
            Fun = fun(File) ->
                    case file:read_file(File) of
                        {ok, Bin} ->
                            NewBin = re:replace(Bin, MP, rescape(replacement, ReplaceMent), [global]),
                            case Bin =:= NewBin of
                                true -> ok;
                                false ->
                                    case file:write_file(File, NewBin) of
                                        ok ->
                                            ?INFO("已更新文件[~s]", [File]);
                                        {error, Reason} ->
                                            ?ERR("更新文件失败[file:~s][reason:~w]", [File, Reason])
                                    end
                            end;
                        {error, Reason} ->
                            ?ERR("读取文件失败[file:~s][reason:~w]", [File, Reason])
                    end
            end,
            lists:foreach(Fun, Files)
    end.

%%----------------------------------------------------------------
%% private functions
%%----------------------------------------------------------------
%% @spec get_gitf(FileBin, IoDev) -> ok
%% @doc get all gifts data
get_gift(FileBin, IoDev) ->
    try re:run(FileBin, "(?<=get_gift\\()[^)]*(?=\\))", [unicode, global, ungreedy]) of
        {match, M} ->
            MaxType = get_max_gift_type(FileBin, M),
            get_gifts(MaxType, IoDev);
        nomatch ->
            ?INFO("can not find any gift data!")
    catch
        Error:Info -> 
            ?ERR("An exception occurred while running the re try to get the gift types. [error: ~w] [reason: ~w]", [Error, Info]),
            error
    end.

%% get the max gift data type value
get_max_gift_type(FileBin, M) ->
    get_max_gift_type(FileBin, M, 0).
get_max_gift_type(_FileBin, [], Max) ->
    Max;
get_max_gift_type(FileBin, [[{P, L}] | M], Max) ->
    Type = list_to_integer(binary_to_list(binary:part(FileBin, P, L))),
    get_max_gift_type(FileBin, M, erlang:max(Type, Max)).

%% get gift's data info by type
get_gifts(MaxType, IoDev) ->
    get_gifts(MaxType, IoDev, 1).
get_gifts(MaxType, _IoDev, Index) when Index > MaxType ->
    ok;
get_gifts(MaxType, IoDev, Index) ->
    try award_data:get_gift(Index) of
        [{GiftId, _, _}] ->
            case item_data:get(GiftId) of
                {ok, #item_base{name = GiftName}} ->
                    get_gift_context(GiftId, GiftName, IoDev, Index);
                {false, Reason} ->
                    ?ERR("An fail occurred while getting the item_data [~w] [reason: ~s]", [GiftId, Reason])
            end
    catch
        Error:Info ->
            ?ERR("An exception occurred while running the re try to getting the gift type data. [error: ~w] [reason: ~w] [type: ~w]", [Error, Info, Index])
    end,
    get_gifts(MaxType, IoDev, Index + 1).

%% get gift's data by id
get_gift_context(GiftId, GiftName, IoDev, Index) ->
    case item_gift_data:get(GiftId) of
        {false, Reason} ->
            ?ERR("An fail occurred while getting the gift_data [~w] [reason: ~s]", [GiftId, Reason]);
        {_Bind, _Type, _Num, L} ->
            file:write(IoDev, io_lib:format("Gift\tId:~w\tName:~s\tType:~w~n\tcontent:~n", [GiftId, GiftName, Index])),
            get_gift_items(IoDev, L),
            file:write(IoDev, <<"\n">>)
    end.

%% output the items' details of every gift by id
get_gift_items(_IoDev, []) ->
    ok;
get_gift_items(IoDev, [{ItemId, _, Num, _, _, _} | L]) ->
    case item_data:get(ItemId) of
        {ok, #item_base{name = ItemName}} ->
            file:write(IoDev, io_lib:format("\t~w\t~w X ~s~n", [ItemId, Num, ItemName]));
        {false, Reason} ->
            ?ERR("An fail occurred while getting the item_data [~w] [reason: ~s]", [ItemId, Reason])
    end,
    get_gift_items(IoDev, L);
get_gift_items(IoDev, [_ | L]) ->
    get_gift_items(IoDev, L).

%% escape of re
rescape(_Type, <<>>, EscapeBin) -> EscapeBin;

%% escape the regexp
rescape(Type = regexp, << Byte:1/binary, Bin/binary>>, EscapeBin) ->
    case Byte of
        <<"[">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"[">>/binary>>);
        <<"]">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"]">>/binary>>);
        <<"(">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"(">>/binary>>);
        <<")">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<")">>/binary>>);
        <<"*">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"*">>/binary>>);
        <<"+">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"+">>/binary>>);
        <<".">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<".">>/binary>>);
        <<"?">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"?">>/binary>>);
        <<"\\">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"\\">>/binary>>);
        <<"^">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"^">>/binary>>);
        <<"{">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"{">>/binary>>);
        <<"}">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"}">>/binary>>);
        <<"|">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"|">>/binary>>);
        <<"$">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"$">>/binary>>);
        _ -> rescape(Type, Bin, <<EscapeBin/binary, Byte/binary>>)
    end;

%% escape the replacement
rescape(Type = replacement, << Byte:1/binary, Bin/binary>>, EscapeBin) ->
    case Byte of
        <<"\\">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"\\">>/binary>>);
        <<"&">> -> rescape(Type, Bin, <<EscapeBin/binary, <<"\\">>/binary, <<"&">>/binary>>);
        _ -> rescape(Type, Bin, <<EscapeBin/binary, Byte/binary>>)
    end.

%% get all the files of the dir
ls(_Dir, [], List) -> List;
ls(Dir, [H | L], List) ->
    F = Dir ++ "/" ++ H,
    case file:read_file_info(F) of
        {ok, #file_info{type = Type}} ->
            case Type of
                directory ->
                    case file:list_dir(F) of
                        {ok, NL} ->
                            ls(Dir, L, List ++ ls(F, NL, []));
                        _Err ->
                            ?ERR("error occured when list the dir ~s", [F]),
                            ls(Dir, L, List)
                    end;
                regular ->
                    ls(Dir, L, [F | List])
            end;
        _ ->
            ?ERR("read file info error [file:~s]", [F]),
            ls(Dir, L, List)
    end.


