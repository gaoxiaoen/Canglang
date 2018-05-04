%%----------------------------------------------------
%% 阐述基本的翻译工作，提供基本的自动化API操作
%% @author weihua@jieyou.cn 
%%----------------------------------------------------
-module(lapi).
-export([ext/1, gen/0, replace/0]).

-include("lang.hrl").

%% ---------------------------------------------------
%% 抽取服务端语言包
%% ---------------------------------------------------
ext(server) ->
    lang:del(server),   %% 删除 服务端语言包处理 中介文件 dets
    IsKr = ?lang_nation =:= "kr",
    case IsKr of
        true ->
            import:add_lib_div(server, ?lang_server_undone_cn, ?lang_server_undone_nation(?lang_nation)),  %% 更新词库数据
            import:add_lib_div(server, ?lang_server_done_cn, ?lang_server_done_nation(?lang_nation)),      %% 更新词库数据
            import:by_div(server, ?lang_server_undone_cn, ?lang_server_undone_nation(?lang_nation)),       %% 导入当前语言包
            import:by_div(server, ?lang_server_done_cn, ?lang_server_done_nation(?lang_nation)),           %% 导入当前语言包
            ok;
        _ ->
            import:add_lib_union(server, ?lang_server_done_union),     %% 更新词库数据
            import:by_union(server, ?lang_server_done_union),          %% 导入当前语言包
            ok
    end,
    lang:set_ver(server, pre),  %% 将当前语言包置过期
    ext_re:ext(server),         %% 抽取最新语言包
    lang:lib_tr(server),        %% 当前没有翻译的尝试去词库中查找，若有则提取出来，更新到当前语言包中介 dets 文件
    case IsKr of
        true ->
            export:divide(server, true),    %% 导出当前新版本已经翻译好了的语言包
            export:divide(server, false),   %% 导出当前新版本未翻译的语言包
            ok;
        false ->
            export:union(server, true),     %% 导出当前新版本已经翻译好了的语言包
            export:union(server, false),    %% 导出当前新版本未翻译的语言包
            ok
    end;

%% ---------------------------------------------------
%% 抽取策划数据语言包
%% ---------------------------------------------------
ext(xml) ->
    lang:del(xml),   %% 删除 策划语言包处理 中介文件 dets
    IsKr = ?lang_nation =:= "kr", 
    case IsKr of
        true ->
            import:add_lib_div(xml, ?lang_xml_undone_cn, ?lang_xml_undone_nation(?lang_nation)),  %% 更新词库数据
            import:add_lib_div(xml, ?lang_xml_done_cn, ?lang_xml_done_nation(?lang_nation)),      %% 更新词库数据
            import:by_div(xml, ?lang_xml_undone_cn, ?lang_xml_undone_nation(?lang_nation)),       %% 导入当前语言包
            import:by_div(xml, ?lang_xml_done_cn, ?lang_xml_done_nation(?lang_nation)),           %% 导入当前语言包
            ok;
        _ ->
            import:add_lib_union(xml, ?lang_xml_done_union),     %% 更新词库数据
            import:by_union(xml, ?lang_xml_done_union),          %% 导入当前语言包
            ok
    end,
    lang:set_ver(xml, pre),  %% 将当前语言包置过期
    ext_re:clear_xml_std(),  %% 清除 xml 数据文件的标准的 命名空间信息 ext_re:ext(xml),         %% 抽取最新语言包
    ext_re:ext(xml),         %% 抽取最新语言包
    lang:lib_tr(xml),        %% 当前没有翻译的尝试去词库中查找，若有则提取出来，更新到当前语言包中介 dets 文件
    case IsKr of
        true ->
            export:divide(xml, true), %% 导出当前新版本已经翻译好了的语言包
            export:divide(xml, false),%% 导出当前新版本未翻译的语言包
            ok;
        _ ->
            export:union(xml, true),     %% 导出当前新版本已经翻译好了的语言包
            export:union(xml, false),    %% 导出当前新版本未翻译的语言包
            ok
    end.

%% =====================================================
%% 生成服务端语言包
%% =====================================================
gen() ->
    lang:gen().

%% =====================================================
%% 替换策划数据
%% =====================================================
replace() ->
    lang:del(xml),      %% 删除 策划语言包处理中介文件
    case ?lang_nation =:= "kr" of
        true ->
            import:add_lib_div(xml, ?lang_xml_undone_cn, ?lang_xml_undone_nation(?lang_nation)),  %% 更新词库数据
            import:add_lib_div(xml, ?lang_xml_done_cn, ?lang_xml_done_nation(?lang_nation)),      %% 更新词库数据
            import:by_div(xml, ?lang_xml_undone_cn, ?lang_xml_undone_nation(?lang_nation)),       %% 导入当前语言包
            import:by_div(xml, ?lang_xml_done_cn, ?lang_xml_done_nation(?lang_nation)),           %% 导入当前语言包
            ok;
        _ ->
            import:add_lib_union(xml, ?lang_xml_done_union),     %% 更新词库数据
            import:by_union(xml, ?lang_xml_done_union),          %% 导入当前语言包
            ok
    end,
    ext_re:clear_xml_std(),  %% 清除 xml 数据文件的标准的 命名空间信息
    ext_re:replace(xml).
