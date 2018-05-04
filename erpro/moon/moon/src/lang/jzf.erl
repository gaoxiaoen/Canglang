%% xml 简转繁 辅助工具
-module(jzf).
-export([merge/0, split/0, re/0]).

-include_lib("kernel/include/file.hrl").

-define(xml_file_dir, "d:/mhfx//xml/zh_cn").
-define(xml_file_union, "d:/mhfx/xml/xml.txt").
-define(xml_fanti, "d:/mhfx/xml/zh_tw").

-define(file_start, "<file-lwh-file>").
-define(file_content, "<content-lwh-content>").
-define(file_end, "<end-lwh-end>").

merge() ->
    case get_xml_files() of
        {ok, FileList} ->
            generate_merge_file(FileList);
        {error, Reason} ->
            io:format("================== [line:~w] [error:~w] ================", [?LINE, Reason])
    end.

split() ->
    case file:read_file(?xml_file_union) of
        {ok, Bin} ->
            split(Bin);
        {error, Reason} ->
            io:format("================== [line:~w] [error:~w] ================", [?LINE, Reason])
    end.

re() ->
    case file:read_file(?xml_file_union) of
        {ok, Bin} ->
            case file:open(?xml_file_union, [write]) of
                {ok, IoDev} ->
                    NewBin = re(Bin),
                    file:write(IoDev, NewBin),
                    case get(re_num) of
                        undefined -> io:format("none item replaced~n");
                        _Num -> io:format("done!~n")
                    end,
                    file:close(IoDev);
                {error, Reason} ->
                    io:format("================== [line:~w] [error:~w] ================", [?LINE, Reason])
            end;
        {error, Reason} ->
            io:format("================== [line:~w] [error:~w] ================", [?LINE, Reason])
    end.

get_xml_files() ->
    case file:list_dir(?xml_file_dir) of
        {ok, L} ->
            {ok, file_filter(L, ?xml_file_dir, ".xml", [])};
        _Other ->
            {error, _Other}
    end.

%% 文件过滤，查找指定目录下的所有文件(包括子目录)，返回指定扩展名的文件列表
file_filter([], _Dir, _Ext, List) ->
    List;
file_filter([H | T], Dir, Ext, List) ->
    F = Dir ++ "/" ++ H,
    NewList = case file:read_file_info(F) of
        {ok, #file_info{type = directory}} ->
            case file:list_dir(F) of
                {ok, L} ->
                    List ++ file_filter(L, Dir ++ "/" ++ H, Ext, []);
                _Err ->
                    io:format("================== [line:~w] [error:~w] ================", [?LINE, _Err]),
                    List
            end;
        {ok, #file_info{type = regular}} ->
            case filename:extension(F) =:= Ext of
                true -> [{filename:basename(filename:rootname(F)), F}| List];
                false -> List
            end;
        _Other ->
            io:format("================== [line:~w] [file:~s] [error:~w] ================", [?LINE, F, _Other]),
            List
    end,
    file_filter(T, Dir, Ext, NewList).

generate_merge_file(FileList) ->
    case file:open(?xml_file_union, [write]) of
        {ok, IoDev} ->
            generate_merge_file(FileList, IoDev),
            io:format("done!~n"),
            file:close(IoDev);
        {error, Reason} ->
            io:format("================== [line:~w] [error:~w] ================", [?LINE, Reason])
    end.

generate_merge_file([], _IoDev) ->
    ok;
generate_merge_file([{FileName, FilePath} | FileList], IoDev) ->
    case file:read_file(FilePath) of
        {ok, Bin} ->
            file:write(IoDev, io_lib:format("~s~s~s~s~s~n", [?file_start, FileName, ?file_content, Bin, ?file_end])),
            io:format("~s is done!~n", [FileName]),
            generate_merge_file(FileList, IoDev);
        {error, Reason} ->
            io:format("================== [line:~w] [error:~w] ================", [?LINE, Reason]),
            generate_merge_file(FileList, IoDev)
    end.

split(Bin) ->
    case re:run(Bin, "<file-lwh-file>.*<end-lwh-end>", [unicode, global, ungreedy, dotall]) of
        {match, M} ->
            split(Bin, M);
        nomatch ->
            io:format("file xml.txt is empty~n")
    end.

split(_Bin, []) ->
    io:format("done!~n"),
    ok;
split(Bin, [[{P, L}] | M]) ->
    split_file(binary:part(Bin, P, L)),
    split(Bin, M).

split_file(Bin) ->
    case re:run(Bin, "(?<=<file-lwh-file>).*(?=<content-lwh-content>)", [unicode, global, ungreedy, dotall]) of
        {match, [[{FP, FL}]]} ->
            FileName = binary:part(Bin, FP, FL),
            case re:run(Bin, "<content-lwh-content>.*<end-lwh-end>", [unicode, global, ungreedy, dotall]) of
                {match, [[{CP, CL}]]} ->
                    ConTagSize = byte_size(<<"<content-lwh-content>">>),
                    EndTagSize = byte_size(<<"<end-lwh-end>">>),
                    Content = binary:part(Bin, CP + ConTagSize, CL - ConTagSize - EndTagSize),
                    case file:open(?xml_fanti ++ "/" ++ binary_to_list(FileName) ++ ".xml", [write]) of
                        {ok, IoDev} ->
                            file:write(IoDev, Content),
                            io:format("~s is done!~n", [FileName]),
                            file:close(IoDev);
                        {error, Reason} ->
                            io:format("================== [line:~w] [file:~s] [error:~w] ================", [?LINE, FileName, Reason])
                    end;
                nomatch ->
                    io:format("================== [line:~w] [file:~s] [error:nomatch] ================", [?LINE, FileName])
            end;
        nomatch ->
            io:format("================== [line:~w] [file:nomath] [error:nomatch] ================", [?LINE])
    end.

re(Bin) ->
    %% 如果存在內嵌，需要注意替換順序
    List = [{<<"梦幻飞仙">>, <<"萌飛仙">>}, {<<"夢幻飛仙">>, <<"萌飛仙">>}, {<<"充值">>, <<"儲值">>}, {<<"首充">>, <<"首儲">>}],
    re(Bin, List).

re(Bin, []) -> Bin;
re(Bin, [{Re, Sub} | List]) ->
    NewBin = re:replace(Bin, Re, Sub, [unicode, global, {return, binary}]),
    case NewBin =:= Bin of
        true -> ok;
        false ->
            case get(re_num) of
                undefined -> put(re_num, 1);
                Num -> put(re_num, Num + 1)
            end
    end,
    re(NewBin, List).
