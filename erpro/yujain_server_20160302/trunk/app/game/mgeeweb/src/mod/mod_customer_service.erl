%% Author: caochuncheng2002@gmail.com
%% Created: 2013-8-15
%% Description: 客服后台管理
-module(mod_customer_service).

-include("mgeeweb.hrl").

%% API
-export([
         handle/3
        ]).

%% 最大内容长度
-define(max_customer_content,140).

handle("/reply" ++ _,Req,_DocRoot) ->
    do_reply(Req);
handle(RemainPath,Req,DocRoot) ->
    ?ERROR_MSG("~ts,RemainPath=~w, Req=~w, DocRoot=~w",["receive unknown message", RemainPath, Req, DocRoot]),
    Req:not_found().

%% 回复客服消息
do_reply(Req) ->
    case catch do_reply2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).

do_reply2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    RoleId = common_tool:to_integer(proplists:get_value("role_id", QueryString,0)),
    TopicId = common_tool:to_integer(proplists:get_value("topic_id", QueryString,0)),
    OpTime = common_tool:to_integer(proplists:get_value("op_time", QueryString,0)),
    Base64Title = proplists:get_value("title", QueryString,""),
    Title = common_tool:to_list(base64:decode_to_string(base64:decode_to_string(Base64Title))),
    Base64Content = proplists:get_value("content", QueryString,""),
    Content = common_tool:to_list(base64:decode_to_string(base64:decode_to_string(Base64Content))),
    case RoleId > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    case TopicId > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    case OpTime > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    case erlang:length(unicode:characters_to_list(erlang:list_to_binary(Content),unicode)) > ?max_customer_content of
        true ->
            erlang:throw({error,?_RC_ADMIN_API_019,""});
        _ ->
            next
    end,
    case erlang:whereis(common_misc:get_role_world_process_name(RoleId)) of
        undefined -> %% 不在线处理
            case db_api:dirty_read(?DB_ROLE_CUSTOMER_SERVICE,RoleId) of
                [RoleCustomer] ->
                    next;
                _ ->
                    RoleCustomer = undefined,
                    erlang:throw({error,?_RC_ADMIN_API_020,""})
            end,
            #r_role_customer_service{max_id = MaxId,
                                 content_list = ContentList}=RoleCustomer,
            case lists:keyfind(TopicId, #r_role_customer_service_sub.id, ContentList) of
                false ->
                    ContentInfo = undefined,
                    erlang:throw({error,?_RC_ADMIN_API_020,""});
                ContentInfo ->
                    next
            end,
			AdminContentInfo = #r_role_customer_service_sub{id=MaxId,
															reply_id=TopicId,
															type=ContentInfo#r_role_customer_service_sub.type,
															title="",
															content=Content,
															op_time=common_tool:now(),
															status=1,
															reply_time=OpTime,
															reply_list=[]},
            NewMaxId = MaxId + 1,
            NewReplyList = [AdminContentInfo|ContentInfo#r_role_customer_service_sub.reply_list],
            NewContentInfo = ContentInfo#r_role_customer_service_sub{reply_list = NewReplyList},
            NewContentList = [NewContentInfo|lists:keydelete(NewContentInfo#r_role_customer_service_sub.id, #r_role_customer_service_sub.id, ContentList)],
            NewRoleCustomer=RoleCustomer#r_role_customer_service{max_id = NewMaxId,content_list=NewContentList},
            db_api:dirty_write(?DB_ROLE_CUSTOMER_SERVICE,NewRoleCustomer),
            next;
        PId ->
            common_misc:send_to_role(PId, {mod,mod_customer,{admin_reply,{RoleId,TopicId,Title,Content,OpTime}}})
    end,
    {ok}.
