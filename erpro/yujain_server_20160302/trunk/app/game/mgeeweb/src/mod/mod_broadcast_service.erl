%%%-------------------------------------------------------------------
%%% File        :mod_broadcast_service.erl
%%% @doc
%%%     消息广播接口
%%% @end
%%%-------------------------------------------------------------------
-module(mod_broadcast_service).


-include("mgeeweb.hrl").

%% API
-export([
         handle/3
        ]).

%% @post
handle("/reset" ++ _,Req, _DocRoot) ->
    do_reset(Req);
handle("/send" ++ _,Req, _DocRoot) ->
    do_send(Req);
handle("/del" ++ _,Req, _DocRoot) ->
    do_del(Req);
handle(RemainPath, Req, DocRoot) ->
    ?ERROR_MSG("~ts,RemainPath=~w, Req=~w, DocRoot=~w",["receive unknown message", RemainPath, Req, DocRoot]),
    Req:not_found().
%% 重置消息
do_reset(Req) ->
    case catch do_reset2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_reset2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    Msgs = proplists:get_value("msgs", QueryString,""),
    MsgInfoList = get_msg_list_by_param(Msgs),
    ?TRY_CATCH(erlang:send(mgeew_broadcast_server, {admin_reset_message,{MsgInfoList}}),Err),
    {ok}.


%% 消息参数格式
%% id:消息id
%% type 消息类型 1:广播消息，在底部显示 2:聊天频道
%% sub_type 消息子类型 msg_type=2 时 msg_sub_type 对应聊天频道的频道类型
%% send_strategy 发送策略 0:立即,1:特定日期时间范围, 2:星期 3:开服后,4:持续一段时间内间隔发送
%% start_date 如果是日期，即格式为：yyyy-MM-dd  开服后发送策略表示开始天数 星期发送策略即表示开始星期几
%% end_date 如果是日期，即格式为：yyyy-MM-dd 开服后发送策略表示结束天数 星期发送策略即表示结束星期几
%% start_time 如果为时间，即格式为：HH:mm:ss
%% end_time 如果为时间，即格式为：HH:mm:ss
%% interval 间隔时间 单位：秒
%% msg 消息内容需要两次base64加密
%% 
%% id,type,sub_type,send_strategy,start_date,end_time,interval,msg|…
%% 返回 [#r_broadcast_message{},...] | []
get_msg_list_by_param("") ->
    [];
get_msg_list_by_param(Args) ->
    StrArgsList = string:tokens(Args,"|"),
    get_msg_list_by_para2(StrArgsList,[]).
get_msg_list_by_para2([],MsgInfoList) ->
    MsgInfoList;
get_msg_list_by_para2([StrArgs|StrArgsList],MsgInfoList) ->
    StrParamList =string:tokens(StrArgs, ","),
    {MsgInfo,_Index}=
        lists:foldl(
          fun(StrParam,{AccMsgInfo,AccIndex})->
                  NewAccIndex = AccIndex + 1,
                  case AccIndex of
                      1-> {AccMsgInfo#r_broadcast_message{id = common_tool:to_integer(StrParam)},NewAccIndex};
                      2-> {AccMsgInfo#r_broadcast_message{msg_type = common_tool:to_integer(StrParam)},NewAccIndex};
                      3-> {AccMsgInfo#r_broadcast_message{msg_sub_type = common_tool:to_integer(StrParam)},NewAccIndex};
                      4-> {AccMsgInfo#r_broadcast_message{send_strategy = common_tool:to_integer(StrParam)},NewAccIndex};
                      5-> {AccMsgInfo#r_broadcast_message{start_date = common_tool:to_list(StrParam)},NewAccIndex};
                      6-> {AccMsgInfo#r_broadcast_message{end_date = common_tool:to_list(StrParam)},NewAccIndex};
                      7-> {AccMsgInfo#r_broadcast_message{start_time = common_tool:to_list(StrParam)},NewAccIndex};
                      8-> {AccMsgInfo#r_broadcast_message{end_time = common_tool:to_list(StrParam)},NewAccIndex};
                      9-> {AccMsgInfo#r_broadcast_message{interval = common_tool:to_integer(StrParam)},NewAccIndex};
                      10-> 
                          Msg =common_tool:to_binary(base64:decode_to_string(base64:decode_to_string(StrParam))),
                          {AccMsgInfo#r_broadcast_message{msg = Msg},NewAccIndex}
                  end      
          end, {#r_broadcast_message{},1}, StrParamList),
    get_msg_list_by_para2(StrArgsList,[MsgInfo|MsgInfoList]).

%% 删除消息
do_del(Req) ->
    case catch do_del2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_del2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    Ids = proplists:get_value("ids", QueryString,""),
    StrIds = string:tokens(Ids,","),
    IdList = [common_tool:to_integer(IdR) || IdR <- StrIds],
    case IdList of
        [] ->
            erlang:throw({error,?_RC_ADMIN_API_005,""});
        _ ->
            next
    end,
    ?TRY_CATCH(erlang:send(mgeew_broadcast_server, {admin_del_message,IdList}),Err),
    {ok}.

%% 发送消息
do_send(Req) ->
    case catch do_send2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_send2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    Id = proplists:get_value("id", QueryString),
    Type = proplists:get_value("type", QueryString),
    SubType = proplists:get_value("sub_type", QueryString),
    SendStrategy = proplists:get_value("send_strategy", QueryString),
    StartDate = proplists:get_value("start_date", QueryString),
    EndDate = proplists:get_value("end_date", QueryString),
    StartTime = proplists:get_value("start_time", QueryString),
    EndTime = proplists:get_value("end_time", QueryString),
    Interval = proplists:get_value("interval", QueryString),
    Base64Content = proplists:get_value("msg", QueryString),
    Msg = common_tool:to_binary(base64:decode_to_string(base64:decode_to_string(Base64Content))),
    R = #r_broadcast_message{id = common_tool:to_integer(Id),
                             msg_type = common_tool:to_integer(Type),
                             msg_sub_type = common_tool:to_integer(SubType),
                             msg = Msg,
                             send_strategy = common_tool:to_integer(SendStrategy),
                             start_date = StartDate,
                             end_date = EndDate,
                             start_time = StartTime,
                             end_time = EndTime,
                             interval = common_tool:to_integer(Interval)
                            },
    ?TRY_CATCH(erlang:send(mgeew_broadcast_server, {admin_send_message,R}), Err),
    {ok}.
 