%% Author: Haiming Li
%% Created: 2012-12-7
%% Description: 字符串资源工具
-module(common_lang).

-include("common.hrl").
-include("common_server.hrl").

%%
%% Exported Functions
%%
-export([get_lang/1,
         get_lang/2,
         get_format_lang_resources/2,
         get_json_lang/2,
         get_json_lang/3
         ]).


%%获取对应的字符串资源
get_lang(LangId) ->
    {Content,_}=cfg_lang:find(LangId),
    Content.

%%获取格式化后的字符串资源
%% @args ConfigID 资源ID
%%       Args 格式化参数
get_lang(LangId, Args) ->
    Res = get_lang(LangId),
    get_format_lang_resources(Res, Args).


%% 格式化资源
get_format_lang_resources(LangResources,ParamList)->
    lists:flatten(io_lib:format(LangResources,[common_tool:to_list(PR)|| PR <- ParamList])).


%% 获取json格式字符
get_json_lang(LangId,Args)->
    get_json_lang(LangId,Args,[]).

%% LangId :cfg_lang 的id
%% Args: ~s 匹配的参数列表
%% AddLinkList 追加的链接
get_json_lang(LangId,Args,AddLinkList) when erlang:is_integer(LangId)->
    {Lang,LinkList} = cfg_lang:find(LangId),
    get_json_lang(Lang,Args,LinkList++AddLinkList);
get_json_lang(Lang,Args,LinkList)->
    JsonLinkList = make_link_json(lists:reverse(LinkList),[]),
    LangResource = lists:flatten(io_lib:format("{\"content\":\"~s\",\"link\":[~s]}", [Lang,JsonLinkList])),
    get_format_lang_resources(LangResource,Args).
    

make_link_json([],JsonLinkList)->
    JsonLinkList;
make_link_json([{Name,Args}],JsonLinkList)->
    io_lib:format("{\"name\":\"~s\",\"args\":\"~s\"}", [Name,Args])++JsonLinkList;
make_link_json([{Name,Args}|List],JsonLinkList)->
    JsonLinkList2 = io_lib:format(",{\"name\":\"~s\",\"args\":\"~s\"}", [Name,Args])++JsonLinkList,
    make_link_json(List,JsonLinkList2).
