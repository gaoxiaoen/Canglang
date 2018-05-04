%%----------------------------------------------------
%% export module
%% @author weihua@jieyou.cn 
%%----------------------------------------------------
-module(export).
-export([union/2                    %% 导出上下行格式语言包
        ,divide/2                   %% 分别导出纯简体，纯翻译语言包
        ,activity/0                 %% 导出服务端活动语言包
        ,lib/1                      %% 导出词库数据
    ]
).

-include_lib("kernel/include/file.hrl").
-include("common.hrl").
-include("lang.hrl").

%% @spec union(Type) -> ok 
%% @doc 导出语言包文件, Type 为 server 时对应 server.txt; Type 值为 xml 时对应 xml.txt
union(Type, Status) ->
    {FilePath, DetsName, DetsPath} = case {Type, Status} of
        {xml, false} -> {?lang_xml_undone_union, ?lang_xml_dets_name, ?lang_xml_dets};
        {xml, true} -> {?lang_xml_done_union, ?lang_xml_dets_name, ?lang_xml_dets};
        {server, false} -> {?lang_server_undone_union, ?lang_server_dets_name, ?lang_server_dets};
        {server, true} -> {?lang_server_done_union, ?lang_server_dets_name, ?lang_server_dets}
    end,
    case file:open(FilePath, [write]) of
        {ok, IoDev} ->
            dets:open_file(DetsName, [{file, DetsPath}, {keypos, #lang.file}, {type, set}]),
            file:write(IoDev, ?lang_export_note),
            ?INFO("开始开始导出语言包数据..."),
            Lang = fun(Lang = #lang{dicts = Dicts}) -> Lang#lang{dicts = [Dict || Dict = #dict{ver = now} <- Dicts]} end,
            Lans = lists:keysort(#lang.index, dets:foldl(fun(Elem, Acc) -> [Lang(Elem)|Acc] end, [], DetsName)),
            export(Lans, IoDev, Status, u),           %% 生成需翻译的数据
            ?INFO("语言包数据导出完毕！"),
            dets:close(DetsName),
            file:close(IoDev),
            ok;
        {error, Reason} ->
            ?ERR("语言包文件 [file:~s] 创建失败 [file:~w]", [FilePath, Reason]),
            ok
    end.

%% @spec divide(Type, Status) -> ok
%% @doc 导出翻译文件，针对不同需求, Status 为 true 时，导出的是已经翻译过的数据，false 是还没翻译过的数据
divide(Type, Status) ->
    {Cn, Tr, DetsName, DetsPath} = case {Type, Status} of
        {xml, true} -> {?lang_xml_done_cn, ?lang_xml_done_nation(?lang_nation), ?lang_xml_dets_name, ?lang_xml_dets};
        {xml, false} -> {?lang_xml_undone_cn, ?lang_xml_undone_nation(?lang_nation), ?lang_xml_dets_name, ?lang_xml_dets};
        {server, true} -> {?lang_server_done_cn, ?lang_server_done_nation(?lang_nation), ?lang_server_dets_name, ?lang_server_dets};
        {server, false} -> {?lang_server_undone_cn, ?lang_server_undone_nation(?lang_nation), ?lang_server_dets_name, ?lang_server_dets}
    end,
    ?INFO("开始开始导出语言包数据..."),
    dets:open_file(DetsName, [{file, DetsPath}, {keypos, #lang.file}, {type, set}]),
    Lang = fun(Lang = #lang{dicts = Dicts}) -> Lang#lang{dicts = [Dict || Dict = #dict{ver = now} <- Dicts]} end,
    Lans = lists:keysort(#lang.index, dets:foldl(fun(Elem, Acc) -> [Lang(Elem)|Acc] end, [], DetsName)),
    case file:open(Cn, [write]) of
        {ok, IoDevCn} ->
            file:write(IoDevCn, ?lang_export_note),
            export(Lans, IoDevCn, Status, s),
            file:close(IoDevCn);
        {error, Reason} ->
            ?ERR("语言文件 [file:~s] 创建失败, [reason:~w]", [Cn, Reason]),
            ok
    end,
    case file:open(Tr, [write]) of
        {ok, IoDevTr} ->
            file:write(IoDevTr, ?lang_export_note),
            export(Lans, IoDevTr, Status, t),
            file:close(IoDevTr);
        {error, Reason_1} ->
            ?ERR("语言文件 [file:~s] 创建失败, [reason:~w]", [Tr, Reason_1]),
            ok
    end,
    ?INFO("语言包数据导出完毕！"),
    dets:close(DetsName),
    ok.

%% @spec lib(Type) -> ok | {error, Reason}
%% Type = xml | server
%% Reason = term()
%% @doc 导出词库数据
lib(Type) ->
    {DetsName, DetsFile, LibFile} = case Type of
        xml -> {xml_words, ?lang_xml_words, ?lang_xml_lib};
        server -> {server_words, ?lang_server_words, ?lang_server_lib}
    end,
    case file:open(LibFile, [write]) of
        {ok, IoDev} ->
            dets:open_file(DetsName, [{file, DetsFile}, {keypos, #word.cn}, {type, set}]),
            case dets:first(DetsName) of
                '$end_of_table' -> ?INFO("没有任何字典数据");
                _ ->
                    ?INFO("开始扫描字典数据..."),
                    dets:traverse(DetsName,
                        fun(#word{cn = Cn, tr = Tr}) ->
                                file:write(IoDev, io_lib:format("[S]:~s~n[T]:~s~n~n", [Cn, Tr])),
                                continue
                        end
                    ),
                    ?INFO("本次字典数据扫描完毕！")
            end,
            dets:close(DetsName),
            file:close(IoDev);
        {error, Reason} ->
            ?ERR("语言文件 [file:~s] 创建失败, [reason:~w]", [LibFile, Reason]),
            {error, Reason}
    end.

%% @spec activity() -> ok
%% @doc 导出服务端活动语言包
activity() ->
    case file:open(?lang_server_activity_txt, [write]) of
        {ok, IoDev} ->
            dets:open_file(?lang_server_activity_dets_name, [{file, ?lang_server_activity_dets_file}, {keypos, #lang.file}, {type, set}]),
            file:write(IoDev, ?lang_export_note),
            ?INFO("开始开始导出语言包数据..."),
            Lans = lists:keysort(#lang.index, dets:foldl(fun(Elem, Acc) -> [Elem|Acc] end, [], ?lang_server_activity_dets_name)),
            export(Lans, IoDev, false, u),          %% 生成已经翻译的数据
            export(Lans, IoDev, true, u),           %% 生成需翻译的数据
            ?INFO("语言包数据导出完毕！"),
            dets:close(?lang_server_activity_dets_name),
            file:close(IoDev),
            ok;
        {error, Reason} ->
            ?ERR("语言包文件 [file:~s] 创建失败 [file:~w]", [?lang_server_activity_txt, Reason]),
            ok
    end.

%% ------------------------------------------------------------------------
%% 私有函数
%% ------------------------------------------------------------------------
%% 导出翻译文件
export([], _IoDev, _Status, _STU) -> 
    ok;
export([#lang{file = FilePath, dicts = Dicts, index = Index} | Lans], IoDev, Status, STU) ->
    ?INFO("开始导出文件 [~w] [~s]", [Index, FilePath]),
    export(FilePath, IoDev, lists:keysort(#dict.index, Dicts), Status, false, STU),
    export(Lans, IoDev, Status, STU).

export(_FilePath, IoDev, [], _Status, true, _STU) ->
    file:write(IoDev, ["[E]:\n\n"]),
    ok;
export(_FilePath, _IoDev, [], _Status, _Bool, _STU) -> 
    ok;
export(FilePath, IoDev, [#dict{cn = Cn, tr = Tr, status = Status} | Dicts], Status, Bool, STU) ->
    case Bool =:= false of
        true -> 
            case STU of
                u -> file:write(IoDev, io_lib:format("[F]:~s\n\n", [FilePath]));
                _ -> file:write(IoDev, io_lib:format("[F]:~s\n", [FilePath]))
            end;
        false -> ok
    end,
    case STU of
        s -> file:write(IoDev, io_lib:format("[S]:~s\n", [Cn]));
        t -> file:write(IoDev, io_lib:format("[T]:~s\n", [Tr]));
        u -> file:write(IoDev, io_lib:format("[S]:~s\n[T]:~s\n\n", [Cn, Tr]))
    end,
    export(FilePath, IoDev, Dicts, Status, true, STU);
export(FilePath, IoDev, [_Dict | Dicts], Status, Bool, STU) ->
    export(FilePath, IoDev, Dicts, Status, Bool, STU).


