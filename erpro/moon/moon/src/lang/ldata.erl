%%----------------------------------------------------
%% data file replace module
%% @author weihua@jieyou.cn 
%%----------------------------------------------------
-module(ldata).
-export([replace/0, replace/1, replace_file/1, find/0]).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("ldata.hrl").

%% @spec replace() -> ok
%% @doc 将所有 数据文件 中的中文 加上 language:get() 函数头
replace() ->
    {ok, Cwd} = file:get_cwd(),
    FileList = [list_to_binary(Cwd ++ File) || {_Type, File} <- ?ldatalist],
    lists:foreach(fun replace_file/1, FileList),
    done.

%% @spec replace(Type) -> ok
%% @doc 将制定类型 数据文件 中的中文 加上 language:get() 函数头
replace(Type) ->
    {ok, Cwd} = file:get_cwd(),
    case lists:keyfind(Type, 1, ?ldatalist) of
        false -> unknow_type;
        {_Type, File} -> replace_file(list_to_binary(Cwd ++ File))
    end.

%% @spec replace_file(File) -> ok
%% File = binary()
%% @doc 将指定文件 中的中文 加上 language:get() 函数头
replace_file(File) ->
    case file:read_file(File) of
        {error, _Reason} ->
            {error, _Reason};
        {ok, Data} ->
            case re:run(Data, "language:get", [unicode]) of
                nomatch ->
                    case re:run(Data, "\\?L\\(.*\\)", [unicode]) of
                        nomatch ->
                            case re:compile("<<\".*?[\x{4e00}-\x{9fff}].*?\">>", [unicode]) of
                                {error, _ErrSpec} ->
                                    {error, _ErrSpec};
                                {ok, MP} ->
                                    Dir = filename:dirname(File),
                                    FileTemp = <<Dir/binary, <<"_temp">>/binary>>,
                                    case file:copy(File, FileTemp) of
                                        {error, _Reason} ->
                                            {error, _Reason};
                                        {ok, _ByteCopied} ->
                                            case file:open(FileTemp, [read, binary]) of
                                                {error, _Reason} ->
                                                    ?ERR("read file error [file:~w] [reason:~w]", [File, _Reason]),
                                                    file:delete(FileTemp),
                                                    {error, _Reason};
                                                {ok, FIO} ->
                                                    case file:open(File, [write]) of
                                                        {error, _Reason} ->
                                                            ?ERR("read file error [file:~w] [reason:~w]", [File, _Reason]),
                                                            file:close(FIO),
                                                            file:delete(FileTemp),
                                                            {error, _Reason};
                                                        {ok, TIO} ->
                                                            replace_file(FIO, TIO, MP),
                                                            file:delete(FileTemp),
                                                            file:close(FIO),
                                                            file:close(TIO)
                                                    end
                                            end
                                    end
                            end;
                        _ ->
                            ?ERR("当前文件似乎曾经转换过，[file:~s]", [File]),
                            {error, arealdy_replaced}
                    end;
                _ ->
                    ?ERR("当前文件似乎曾经转换过，[file:~s]", [File]),
                    {error, arealdy_replaced}
            end
    end.

%% 找出可能性的 data 数据文件
find() ->
    {ok, Cwd} = file:get_cwd(),
    case adm:get_src_erl() of
        {ok, FileList} ->
            case file:open("../src/lang/ldata.hrl", [write]) of
                {ok, IoDev} ->
                    file:write(IoDev, "%% ---------------------------------------------------------------------------\n"),
                    file:write(IoDev, "%% @doc 这里指明 所有由 PHP 工具生成的涉及语言翻译的 erl 数据文件, 海外翻译用\n"),
                    file:write(IoDev, "%% @author weihua@jieyou.cn\n"),
                    file:write(IoDev, "%% ---------------------------------------------------------------------------\n"),
                    file:write(IoDev, "-define(ldatalist, [\n"),
                    Fun = fun
                        ({"ldata", _}) -> ok;
                        ({"merge_dao_admin_data_skill", _}) -> ok;
                        ({"merge_dao_admin_data_petskill", _}) -> ok;
                        ({"merge_dao_admin_data_item", _}) -> ok;
                        ({"merge_data", _}) -> ok;
                        ({FileName, FilePath}) ->
                            case re:run(FilePath, "data", [unicode]) of
                                nomatch -> false;
                                _ ->
                                    N = length(Cwd),
                                    RelativeFilePath = lists:nthtail(N, FilePath),
                                    case get(ldata_hrl) of
                                        undefined ->
                                            put(ldata_hrl, yes),
                                            file:write(IoDev, io_lib:format("        {~s, \"~s\"}\n", [FileName, RelativeFilePath]));
                                        _ ->
                                            file:write(IoDev, io_lib:format("        ,{~s, \"~s\"}\n", [FileName, RelativeFilePath]))
                                    end
                            end
                    end,
                    lists:foreach(Fun, lists:reverse(FileList)),
                    erase(ldata_hrl),
                    file:write(IoDev, "    ]\n)."),
                    file:close(IoDev);
                _ ->
                    ?ERR("创建数据文件 ldata.hrl 失败"),
                    ok
            end;
        _ ->
            ?INFO("src 目录下找不到任何 erl 文件"),
            ok
    end.

%% ----------------------------------------------------------
%% 私有函数
%% ----------------------------------------------------------
replace_file(FIO, TIO, MP) ->
    case file:read_line(FIO) of
        eof ->
            eof;
        {error, Reason} ->
            ?ERR("file read line error [error:~w]", [Reason]),
            error;
        {ok, Bin} ->
            case re:run(Bin, MP, [global]) of
                nomatch ->
                    file:write(TIO, Bin),
                    replace_file(FIO, TIO, MP);
                {match, M} ->
                    file:write(TIO, replace_line(Bin, lists:reverse(lists:keysort(1, get_matchs(Bin, M))))),
                    replace_file(FIO, TIO, MP)
            end
    end.

get_matchs(Bin, M) ->   
    get_matchs(Bin, M, []).
get_matchs(_Bin, [], Matchs) -> Matchs;
get_matchs(Bin, [[{P, L}] | M], Matchs) ->
    get_matchs(Bin, M, [{L, binary:part(Bin, P, L)} | Matchs]).

replace_line(Bin, []) ->
    Bin;
replace_line(Bin, [{_, Str} | Matchs]) ->
    NewStr = util:fbin("language:get(~s)", [Str]),
    replace_line(re:replace(Bin, lutil:rescape(regexp, Str), lutil:rescape(replacement, NewStr), [unicode, global]), Matchs).
