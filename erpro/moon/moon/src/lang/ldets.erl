%% ---------------------------------------------------
%% 翻译数据 DETS 模块
%% @author weihua@jieyou.cn 
%% ---------------------------------------------------
-module(ldets).
-export([get_file_index/1           %% 获取文件顺序
        ,get_entry_index/2          %% 获取词条顺序
        ,insert/7                   %% 插入词条数据
    ]
).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("lang.hrl").

%% @spec get_file_index(DetsName) -> integer()
%% DetsName = atom()
%% @doc 获取dets文件下一个文件index
get_file_index(DetsName) ->
    Fun = fun(#lang{index = Index}, Acc) ->
            case Index > Acc of
                true -> Index;
                _ -> Acc
            end
    end,
    case dets:foldl(Fun, 0, DetsName) of
        {error, Reason} ->
            ?ERR("尝试获取下一个文件 Index 发生错误, [reason: ~w]", [Reason]),
            1;
        Max ->
            Max + 1
    end.

%% @spec get_entry_index(DetsName, FilePath) -> integer()
%% DetsName = atom()
%% FilePath = binary()
%% @doc 获取下一个词条 的 index
get_entry_index(DetsName, FilePath) ->
    case dets:lookup(DetsName, lutil:nocrlf(FilePath)) of
        [#lang{dicts = Dicts}] ->
            Fun = fun(#dict{index = Index}, Acc) ->
                    case Index > Acc of
                        true -> Index;
                        _ -> Acc
                    end
            end,
            case lists:foldl(Fun, 0, Dicts) of
                {error, Reason} ->
                    ?ERR("尝试获取下一个文件 Index 发生错误, [reason: ~w]", [Reason]),
                    1;
                Max ->
                    Max + 1
            end;
        _ ->
            1
    end.

%% @spec insert(DetsName, FilePath, FileIndex, Cn, Tr, Status, Entryindex) -> ok | {error, Reason}
%% DetsName = atom()
%% FilePath = Cn = Tr = binary()
%% FileIndex = Entryindex = integer()
%% Status = true | false
%% Reason = term()
%% @doc 将获取到的语言包词条保存到 dets 中, 新插入进来的词条都作为 当前版本处理，即，ver 都要改成 now
insert(DetsName, FilePathBin, FileIndex, CnBin, TrBin, Status, EntryIndex) ->
    Fp = lutil:nocrlf(FilePathBin),
    Cn = lutil:nocrlf(CnBin),
    Tr = lutil:nocrlf(TrBin),
    case dets:lookup(DetsName, Fp) of
        [Lang = #lang{dicts = Dicts}] ->
            case lists:keyfind(Cn, #dict.cn, Dicts) of
                false ->    %% 新抽取词段
                    dets:insert(DetsName, Lang#lang{dicts = [#dict{cn = Cn, tr = Tr, status = Status, index = EntryIndex, len = byte_size(Cn), ver = now} | Dicts]});
                #dict{status = true, ver = now} -> 
                    ok;   %% 当前版本 翻译过，跳过
                Dict = #dict{status = true} ->  %% 置为当前版本
                    dets:insert(DetsName, Lang#lang{dicts = lists:keyreplace(Cn, #dict.cn, Dicts, Dict#dict{ver = now})});
                Dict = #dict{status = false, ver = now} when Status =:= true ->   %% 没翻译，更新翻译
                    dets:insert(DetsName, Lang#lang{dicts = lists:keyreplace(Cn, #dict.cn, Dicts, Dict#dict{tr = Tr, status = true, index = EntryIndex})});
                Dict = #dict{status = false} when Status =:= true ->   %% 没翻译，更新翻译
                    dets:insert(DetsName, Lang#lang{dicts = lists:keyreplace(Cn, #dict.cn, Dicts, Dict#dict{tr = Tr, status = true, index = EntryIndex, ver = now})});
                _ -> 
                    ok   %% 未翻译 抽取到的重复词汇，跳过
            end;
        _ ->    %% 新文件
            dets:insert(DetsName, #lang{file = Fp, dicts = [#dict{cn = Cn, tr = Tr, status = Status, index = EntryIndex, len = byte_size(Cn), ver = now}], index = FileIndex})
    end.
