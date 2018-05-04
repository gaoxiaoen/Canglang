%%----------------------------------------------------
%% 抽取语言文件 翻译流程 extract --> export --> translate --> replace
%% @author weihua@jieyou.cn 
%%----------------------------------------------------
-module(move).
-export([move/0]).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("lang.hrl").


%% 搬迁宏定义
move() ->
    dets:open_file(?lang_server_dets_name, [{file, ?lang_server_dets}, {keypos, #lang.file}, {type, set}]),
    case dets:first(?lang_server_dets_name) of
        '$end_of_table' -> ?INFO("没有任何字典数据");
        _ ->
            dets:traverse(?lang_server_dets_name,
                fun(#lang{file = FilePath, dicts = Dicts}) ->
                        ?INFO("开始处理文件 [~s]", [FilePath]),
                        move(FilePath, lists:reverse(lists:keysort(4,Dicts))),
                        continue
                end
            ),
            ?INFO("本次字典数据扫描完毕！")
    end,
    dets:close(?lang_server_dets_name).

%%----------------------------------------------------------------
%% 私有函数
%%----------------------------------------------------------------
move(FilePath, Dicts) ->
    case get_folder_file_dir(FilePath, byte_size(FilePath)) of
        error -> error;
        {Folder, Dir, File} ->
             case file:read_file(FilePath) of
                 {ok, FileBin} ->
                     case file:open(FilePath, [write]) of
                         {ok, IoDevS} ->
                             CommonLangFile = <<Dir/binary, Folder/binary, <<"_common_lang.hrl">>/binary>>,
                             case file:open(CommonLangFile, [write, append]) of
                                 {ok, IoDevC} ->
                                     NewFileBin = move(FileBin, IoDevC, Dicts, Folder, File),
                                     file:write(IoDevS, NewFileBin),
                                     file:close(IoDevC);
                                 {error, Reason} ->
                                     ?ERR("open file error [file:~s] [reason:~w]", [CommonLangFile, Reason]),
                                     error
                             end,
                             file:close(IoDevS);
                         {error, Reason} ->
                             ?ERR("open file error [file:~s] [reason:~w]", [FilePath, Reason]),
                             error
                     end;
                 {error, Reason} ->
                     ?ERR("read file error [file:~s] [reason:~w]", [FilePath, Reason]),
                     error
             end
    end.

%% 获取文件夹名字
get_folder_file_dir(FilePath, Len) ->
    get_folder_file_dir(FilePath, Len, <<>>, <<>>, <<>>, 0).
get_folder_file_dir(<<>>, 0, Folder, Dir, File, _Times) ->
    {Folder, Dir, File};
get_folder_file_dir(<<>>, _Len, _Folder, _Dir, _File, _Times) ->
    error;
get_folder_file_dir(_FilePath, 0, _Folder, _Dir, _File, _Times) ->
    error;
get_folder_file_dir(FilePath, Len, Folder, Dir, File, Times) ->
    NextLen = Len - 1,
    <<HRem:NextLen/binary, Ch:1/binary>> = FilePath,
    case Ch of
        <<"/">> ->
            if
                Times =:= 0 ->
                    get_folder_file_dir(HRem, Len - 1, <<>>, FilePath, File, 1);
                true ->
                    {Folder, Dir, File}
            end;
        <<".">> ->
            if
                Times =:= 0 ->
                    get_folder_file_dir(HRem, Len - 1, <<>>, <<>>, <<>>, 0);
                true ->
                    get_folder_file_dir(HRem, Len - 1, Folder, Dir, File, Times)
            end;
        _ ->
            if
                Times =:= 0 ->
                    get_folder_file_dir(HRem, NextLen, <<>>, <<>>, <<Ch/binary, File/binary>>, Times);
                true ->
                    get_folder_file_dir(HRem, NextLen, <<Ch/binary, Folder/binary>>, Dir, File, Times)
            end
    end.

move(FileBin, IoDev, Dicts, Folder, File) ->
    move(FileBin, IoDev, Dicts, Folder, File, 0001).
move(FileBin, _IoDev, [], _Folder, _File, _Index) ->
    FileBin;
move(FileBin, IoDev, [{Cn, _Tr, _Status, _Size} | Dicts], Folder, File, Index) ->
    Macro = get_macro_name(Folder, File, Index),
    write_macro(IoDev, Macro, Cn),
    try re:replace(FileBin, ext_re:escape(Cn), << <<"?">>/binary, Macro/binary>>, [global]) of
        ReBin -> 
            case FileBin =:= ReBin of
                true -> ?ERR("替宏定义换失败词断,【~s】", [Cn]);
                false -> ok
            end,
            move(ReBin, IoDev, Dicts, Folder, File, Index + 1)
    catch
        Error:Info -> {error, util:fbin("正则匹配替换发生 ~w ,Reason ~w, 词汇 ~s", [Error, Info, Cn])}
    end.

get_macro_name(Folder, File, Index) ->
    IndexBin = list_to_binary(integer_to_list(Index)),
    <<Folder/binary, <<"_">>/binary, File/binary, <<"_fx_">>/binary, IndexBin/binary>>.

write_macro(IoDev, Macro, Cn) ->
    file:write(IoDev, io_lib:format("~n-define(~s, ~s).", [Macro, Cn])).
