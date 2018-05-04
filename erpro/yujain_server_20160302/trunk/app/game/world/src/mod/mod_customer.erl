%% Author: caochuncheng2002@gmail.com
%% Created: 2013-8-15
%% Description: 客服系统模块处理
-module(mod_customer).


-include("mgeew.hrl").

-export([
         handle/1,
         
         set_role_customer/2,
         t_set_role_customer/2
        ]).

%% 最大的客服消息长度
-define(max_customer_topic,100). 
%% 最大的消息回复长度
-define(max_customer_reply,30).
%% 最大内容长度
-define(max_customer_content,140).


get_role_customer2(RoleId)->
    case get_role_customer(RoleId) of
        {ok,RoleCustomer}->
            RoleCustomer;
        _->
            #r_role_customer_service{role_id = RoleId}
    end.

%% 客服进程字典操作
get_role_customer(RoleId) ->
    mod_role:get_dict_with_init(?DB_ROLE_CUSTOMER_SERVICE,RoleId).
set_role_customer(RoleId,RoleCustomer) ->
    mod_role:set_dict({?DB_ROLE_CUSTOMER_SERVICE,RoleId}, RoleCustomer).
t_set_role_customer(RoleId,RoleCustomer) ->
    mod_role:t_set_dict({?DB_ROLE_CUSTOMER_SERVICE,RoleId}, RoleCustomer).


handle({Module,?CUSTOMER_SERVICE_QUERY,DataRecord,RoleId,PId,_Line}) ->
    do_customer_query(Module,?CUSTOMER_SERVICE_QUERY,DataRecord,RoleId,PId);
handle({Module,?CUSTOMER_SERVICE_DO,DataRecord,RoleId,PId,_Line}) ->
    do_customer_do(Module,?CUSTOMER_SERVICE_DO,DataRecord,RoleId,PId);
handle({Module,?CUSTOMER_SERVICE_DEL,DataRecord,RoleId,PId,_Line}) ->
    do_customer_del(Module,?CUSTOMER_SERVICE_DEL,DataRecord,RoleId,PId);

handle({admin_reply,Info}) ->
    do_admin_reply(Info);

handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).


-define(customer_query_op_type_all,1). %% 查询列表
-define(customer_query_op_type_one,2). %% 根据id查询所有回复信息
%% 查询
do_customer_query(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_customer_query2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_customer_query_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,RoleCustomer} ->
            do_customer_query3(Module,Method,DataRecord,RoleId,PId,RoleCustomer)
    end.
do_customer_query2(RoleId,DataRecord) ->
    #m_customer_service_query_tos{op_type=OpType,id=Id} = DataRecord,
    case OpType of
        ?customer_query_op_type_all ->
            next;
        ?customer_query_op_type_one ->
            next;
        _ ->
            erlang:throw({error,?_RC_CUSTOMER_SERVICE_QUERY_000})
    end,
    RoleCustomer = get_role_customer2(RoleId),
    case OpType of
        ?customer_query_op_type_one ->
            case lists:keyfind(Id,#r_role_customer_service_sub.id,RoleCustomer#r_role_customer_service.content_list) of
                false ->
                    erlang:throw({error,?_RC_CUSTOMER_SERVICE_QUERY_002});
                _ ->
                    next
            end;
        _ ->
            next
    end,
    {ok,RoleCustomer}.
do_customer_query3(Module,Method,DataRecord,_RoleId,PId,RoleCustomer) ->
    #m_customer_service_query_tos{op_type=OpType,id=Id} = DataRecord,
    case OpType of
        ?customer_query_op_type_all ->
            DataList = [ get_p_customer_service(Record) || Record <- RoleCustomer#r_role_customer_service.content_list];
        ?customer_query_op_type_one ->
            #r_role_customer_service_sub{reply_list=ReplyList}=lists:keyfind(Id,#r_role_customer_service_sub.id,RoleCustomer#r_role_customer_service.content_list),
            DataList = [ get_p_customer_service(Record) || Record <- ReplyList]
    end,
    SendSelf = #m_customer_service_query_toc{op_type=OpType,
                                             id=Id,
                                             op_code=0,
                                             data_list=DataList},
    common_misc:unicast(PId, Module, Method, SendSelf),
    ok.
do_customer_query_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_customer_service_query_toc{op_type=DataRecord#m_customer_service_query_tos.op_type,
                                             id=DataRecord#m_customer_service_query_tos.id,
                                             op_code=OpCode,
                                             data_list=[]},
    common_misc:unicast(PId, Module, Method, SendSelf).

-define(customer_do_op_type_new,1).    %% 1提交新内容
-define(customer_do_op_type_reply,2).  %% 2回复
-define(customer_do_op_type_set,3).    %% 2设置已读

-define(customer_content_type_bug,1).           %% Bug
-define(customer_content_type_complaints,2).    %% 投诉
-define(customer_content_type_proposal,3).      %% 建议
-define(customer_content_type_other,4).         %% 其它

-define(customer_content_status_init,1).        %% 未读
-define(customer_content_status_read,2).        %% 已读

%% 提交
do_customer_do(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_customer_do2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_customer_do_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,RoleBase,NewRoleCustomer,NewContentInfo} ->
            do_customer_do3(Module,Method,DataRecord,RoleId,PId,
                            RoleBase,NewRoleCustomer,NewContentInfo)
    end.
do_customer_do2(RoleId,DataRecord) ->
    #m_customer_service_do_tos{op_type=OpType,
                               type=Type,
                               content=Content,
                               id=Id} = DataRecord,
    case OpType of
        ?customer_do_op_type_new ->
            next;
        ?customer_do_op_type_reply ->
            next;
        ?customer_do_op_type_set ->
            next;
        _ ->
            erlang:throw({error,?_RC_CUSTOMER_SERVICE_DO_001})
    end,
    case OpType =:= ?customer_do_op_type_new orelse OpType =:= ?customer_do_op_type_reply of
        true ->
            case Type of
                ?customer_content_type_bug ->
                    next;
                ?customer_content_type_complaints ->
                    next;
                ?customer_content_type_proposal ->
                    next;
                ?customer_content_type_other ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_CUSTOMER_SERVICE_DO_001})
            end,
            case Content =:= "" orelse Content =:= [] of
                true ->
                    erlang:throw({error,?_RC_CUSTOMER_SERVICE_DO_002});
                _ ->
                    next
            end,
            case erlang:length(unicode:characters_to_list(erlang:list_to_binary(Content),unicode)) > ?max_customer_content of
                true ->
                    erlang:throw({error,?_RC_CUSTOMER_SERVICE_DO_003});
                _ ->
                    next
            end,
            next;
        _ ->
            next
    end,
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase=undefined,
            erlang:throw({error,?_RC_CUSTOMER_SERVICE_DO_000})
    end,
    #r_role_customer_service{max_id = MaxId,
                                 content_list = ContentList}=RoleCustomer = get_role_customer2(RoleId),
    case OpType of
        ?customer_do_op_type_new ->
            case erlang:length(ContentList) > ?max_customer_topic of
                true ->
                    erlang:throw({error,?_RC_CUSTOMER_SERVICE_DO_006});
                _ ->
                    next
            end,
            NewContentInfo = #r_role_customer_service_sub{id=MaxId,
                                                          reply_id=0,
                                                          type=Type,
                                                          title="",
                                                          content=Content,
                                                          op_time=common_tool:now(),
                                                          status=?customer_content_status_init,
                                                          reply_time=0,
                                                          reply_list=[]},
            NewMaxId = MaxId + 1,
            NewContentList = [NewContentInfo|ContentList],
            next;
        ?customer_do_op_type_reply ->
            case lists:keyfind(Id, #r_role_customer_service_sub.id, ContentList) of
                false ->
                    TopicContentInfo = undefined,
                    erlang:throw({error,?_RC_CUSTOMER_SERVICE_DO_004});
                TopicContentInfo ->
                    case erlang:length(TopicContentInfo#r_role_customer_service_sub.reply_list) > ?max_customer_reply of
                        true ->
                            erlang:throw({error,?_RC_CUSTOMER_SERVICE_DO_007});
                        _ ->
                            next
                    end
            end,
            NewContentInfo = #r_role_customer_service_sub{id=MaxId,
                                                          reply_id=TopicContentInfo#r_role_customer_service_sub.id,
                                                          type=Type,
                                                          title="",
                                                          content=Content,
                                                          op_time=common_tool:now(),
                                                          status=?customer_content_status_init,
                                                          reply_time=0,
                                                          reply_list=[]},
            NewMaxId = MaxId + 1,
            NewReplyList = [NewContentInfo|TopicContentInfo#r_role_customer_service_sub.reply_list],
            NewTopicContentInfo = TopicContentInfo#r_role_customer_service_sub{reply_list = NewReplyList},
            NewContentList = [NewTopicContentInfo|lists:keydelete(NewContentInfo#r_role_customer_service_sub.id, #r_role_customer_service_sub.id, ContentList)],
            next;
        ?customer_do_op_type_set ->
            case lists:keyfind(Id, #r_role_customer_service_sub.id, ContentList) of
                false ->
                    ContentInfo = undefined,
                    erlang:throw({error,?_RC_CUSTOMER_SERVICE_DO_005});
                ContentInfo ->
                    next
            end,
            NewContentInfo = ContentInfo#r_role_customer_service_sub{status=?customer_content_status_read},
            NewMaxId = MaxId,
            NewContentList = [NewContentInfo|lists:keydelete(NewContentInfo#r_role_customer_service_sub.id, #r_role_customer_service_sub.id, ContentList)],
            next
    end,
    NewRoleCustomer=RoleCustomer#r_role_customer_service{max_id = NewMaxId,content_list=NewContentList},
    {ok,RoleBase,NewRoleCustomer,NewContentInfo}.
do_customer_do3(Module,Method,DataRecord,RoleId,PId,
                RoleBase,NewRoleCustomer,NewContentInfo) ->
    #m_customer_service_do_tos{op_type=OpType} = DataRecord,
    case OpType =:= ?customer_do_op_type_new orelse OpType =:= ?customer_do_op_type_reply of
        true -> %% 通知平台管理
            %% 向管理平台返回数据
                    [AgentId] = common_config_dyn:find_common(agent_id),
                    ServerId = RoleBase#p_role_base.server_id,
                    Title = base64:encode_to_string(base64:encode_to_string(NewContentInfo#r_role_customer_service_sub.title)),
                    Content = base64:encode_to_string(base64:encode_to_string(NewContentInfo#r_role_customer_service_sub.content)),
                    ParamList = [{"agent_id",AgentId},
                                 {"server_id",ServerId},
                                 {"role_id",RoleId},
                                 {"role_name",common_tool:to_list(RoleBase#p_role_base.role_name)},
                                 {"account_name",common_tool:to_list(RoleBase#p_role_base.account_name)},
                                 {"level",RoleBase#p_role_base.level},
                                 {"total_gold",RoleBase#p_role_base.total_gold},
                                 {"vip_level",0},
                                 {"topic_id",NewContentInfo#r_role_customer_service_sub.id},
                                 {"reply_id",NewContentInfo#r_role_customer_service_sub.reply_id},
                                 {"type",NewContentInfo#r_role_customer_service_sub.type},
                                 {"title",Title},
                                 {"content",Content},
                                 {"status",NewContentInfo#r_role_customer_service_sub.status},
                                 {"op_time",NewContentInfo#r_role_customer_service_sub.op_time},
                                 {"extra",""}],
                    common_misc:do_admin_run_api(post, "/module/api/gm_recv.php", ParamList, undefined),
            next;
        _ -> 
            next
    end,
    set_role_customer(RoleId, NewRoleCustomer),
    SendSelf = #m_customer_service_do_toc{op_type=DataRecord#m_customer_service_do_tos.op_type,
                                          type=DataRecord#m_customer_service_do_tos.type,
                                          id=DataRecord#m_customer_service_do_tos.id,
                                          op_code=0,
										  new_id=NewContentInfo#r_role_customer_service_sub.id},
    common_misc:unicast(PId, Module, Method, SendSelf),
    ok.
do_customer_do_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_customer_service_do_toc{op_type=DataRecord#m_customer_service_do_tos.op_type,
                                          type=DataRecord#m_customer_service_do_tos.type,
                                          id=DataRecord#m_customer_service_do_tos.id,
                                          op_code=OpCode},
    common_misc:unicast(PId, Module, Method, SendSelf).
%% 管理平台回复消息处理
do_admin_reply({RoleId,TopicId,Title,Content,OpTime}) ->
    case catch do_admin_reply2(RoleId,TopicId,Title,Content,OpTime) of
        {error,OpCode} -> %% 发送消息失败，可以优化通知管理平台，目前处理不发送，只记录日志
            ?ERROR_MSG("~ts,OpCode=~w,Info=~w",[?_LANG_LOCAL_023,OpCode,{RoleId,TopicId,Title,Content,OpTime}]);
        {ok,NewRoleCustomer,ReplyContentInfo} ->
            do_admin_reply3(RoleId,TopicId,Title,Content,OpTime,
                            NewRoleCustomer,ReplyContentInfo)
    end.
do_admin_reply2(RoleId,TopicId,_Title,Content,OpTime) ->
    #r_role_customer_service{max_id = MaxId,
                                 content_list = ContentList}=RoleCustomer = get_role_customer2(RoleId),
    case lists:keyfind(TopicId, #r_role_customer_service_sub.id, ContentList) of
        false ->
            ContentInfo = undefined,
            erlang:throw({error,?_RC_ADMIN_API_020});
        ContentInfo ->
            next
    end,
    ReplyContentInfo = #r_role_customer_service_sub{id=MaxId,
                                                  reply_id=TopicId,
                                                  type=ContentInfo#r_role_customer_service_sub.type,
                                                  title="",
                                                  content=Content,
                                                  op_time=common_tool:now(),
                                                  status=?customer_content_status_init,
                                                  reply_time=OpTime,
                                                  reply_list=[]},
    NewMaxId = MaxId + 1,
    NewReplyList = [ReplyContentInfo|ContentInfo#r_role_customer_service_sub.reply_list],
    NewContentInfo = ContentInfo#r_role_customer_service_sub{reply_list = NewReplyList},
    NewContentList = [NewContentInfo|lists:keydelete(NewContentInfo#r_role_customer_service_sub.id, #r_role_customer_service_sub.id, ContentList)],
    NewRoleCustomer=RoleCustomer#r_role_customer_service{max_id = NewMaxId,content_list=NewContentList},
    {ok,NewRoleCustomer,ReplyContentInfo}.
do_admin_reply3(RoleId,_TopicId,_Title,_Content,_OpTime,
                NewRoleCustomer,ReplyContentInfo) ->
    set_role_customer(RoleId, NewRoleCustomer),
    Info = get_p_customer_service(ReplyContentInfo),
    SendSelf = #m_customer_service_update_toc{op_type = 0,
                                              info=Info},
    common_misc:unicast({role,RoleId}, ?CUSTOMER_SERVICE, ?CUSTOMER_SERVICE_UPDATE, SendSelf),
    ok.
    
-define(customer_del_op_type_topic,1). %% 1删除主题，包括主题的所有回复信息
-define(customer_del_op_type_reply,2). %% 2删除回复
%% 删除
do_customer_del(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_customer_del2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_customer_del_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok} ->
            do_customer_del3(Module,Method,DataRecord,RoleId,PId)
    end.
do_customer_del2(RoleId,DataRecord) ->
    #m_customer_service_del_tos{op_type=OpType,id=Id,del_ids=DelIdList} = DataRecord,
    case OpType of
        ?customer_del_op_type_topic ->
            next;
        ?customer_del_op_type_reply ->
            case Id > 0 andalso erlang:is_integer(Id) of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_CUSTOMER_SERVICE_DEL_001})
            end;
        _ ->
            erlang:throw({error,?_RC_CUSTOMER_SERVICE_DEL_001})
    end,
    RoleCustomer = get_role_customer2(RoleId),
    #r_role_customer_service{content_list = ContentList} = RoleCustomer,
     case OpType of
        ?customer_del_op_type_topic ->
            NewContentList = [ ContentInfo || ContentInfo <- ContentList,
                                              lists:member(ContentInfo#r_role_customer_service_sub.id, DelIdList) =:= false];
        ?customer_del_op_type_reply ->
            case lists:keyfind(Id, #r_role_customer_service_sub.id, ContentList) of
                false ->
                    NewContentList = ContentList;
                ContentInfo ->
                    #r_role_customer_service_sub{reply_list = ReplyList} = ContentInfo,
                    NewReplyList = [ReplyInfo || ReplyInfo <- ReplyList,
                                                 lists:member(ReplyInfo#r_role_customer_service_sub.id, DelIdList) =:= false],
                    NewContentInfo = ContentInfo#r_role_customer_service_sub{reply_list = NewReplyList},
                    NewContentList = [ NewContentInfo|| lists:keydelete(id, #r_role_customer_service_sub.id, ContentList)]
            end
    end,
    NewRoleCustomer = RoleCustomer#r_role_customer_service{content_list=NewContentList},
    set_role_customer(RoleId, NewRoleCustomer),
    {ok}.
do_customer_del3(Module,Method,DataRecord,_RoleId,PId) ->
    SendSelf = #m_customer_service_del_toc{op_type=DataRecord#m_customer_service_del_tos.op_type,
                                           id=DataRecord#m_customer_service_del_tos.id,
                                           del_ids=DataRecord#m_customer_service_del_tos.del_ids,
                                           op_code=0},
    common_misc:unicast(PId, Module, Method, SendSelf),
    ok.
do_customer_del_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_customer_service_del_toc{op_type=DataRecord#m_customer_service_del_tos.op_type,
                                           id=DataRecord#m_customer_service_del_tos.id,
                                           del_ids=DataRecord#m_customer_service_del_tos.del_ids,
                                           op_code=OpCode},
    common_misc:unicast(PId, Module, Method, SendSelf).

get_p_customer_service(Record) ->
    #p_customer_service{id=Record#r_role_customer_service_sub.id,
                        reply_id=Record#r_role_customer_service_sub.reply_id,
                        type=Record#r_role_customer_service_sub.type,
                        title=Record#r_role_customer_service_sub.title,
                        content=Record#r_role_customer_service_sub.content,
                        op_time=Record#r_role_customer_service_sub.op_time,
                        status=Record#r_role_customer_service_sub.status}.