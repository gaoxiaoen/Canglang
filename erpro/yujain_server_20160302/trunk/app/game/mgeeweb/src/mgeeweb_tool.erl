%%%-------------------------------------------------------------------
%%%
%%%
%%% @doc
%%%
%%% @end
%%%
%%%-------------------------------------------------------------------
-module(mgeeweb_tool).

-include("mgeeweb.hrl").

%% API
-export([
         process_not_run/1,
         json/1,
         now_nanosecond/0,
         get_int_param/2,
         get_atom_param/2,
         get_string_param/2,
         call_nodes/3
        ]).
		
-export([
         return_json/2,
         return_json_ok/1,
         return_json_error/1,
         return_string/2,
         return_xml/2
        ]).

-export([
         check_api_request/4,
		 check_client_login_session/1,
         check_client_login_session/2,
         check_client_api_request/1,
         check_admin_api_request/1,
         check_pay_api_request/1
        ]).
         
json(List) ->
    lists:flatten(rfc4627:encode({obj, List})).

%%返回XML数据 【不】自动加上xml头
return_xml({no_auto_head, XmlResult}, Req) ->
    [GameName] = common_config_dyn:find_common(game_name),
    Req:ok({"text/xml; charset=utf-8", [{"Server",GameName}],XmlResult});
%%返回XML数据 自动加上xml头
return_xml({auto_head, XmlResult}, Req) ->
    [GameName] = common_config_dyn:find_common(game_name),
	XmlResult2 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"++XmlResult,
    Req:ok({"text/xml; charset=utf-8", [{"Server",GameName}], XmlResult2}).
	
return_string(StringResult, Req) ->
    Req:ok({"text/html; charset=utf-8",StringResult}).
return_json(List, Req) ->
    Result =(catch(common_json2:to_json(List))),
    Req:ok({"text/html; charset=utf-8",Result}).

return_json_ok(Req) ->
    List = [{result, ok}],
    return_json(List, Req).

return_json_error(Req) ->
    List = [{result, error}],
    return_json(List, Req).
    

process_not_run(Req) ->
    List = [{result, error}],
    return_json(List, Req).

now_nanosecond() ->
    {A, B, C} = erlang:now(),
    A * 1000000000000 + B*1000000 + C.

%%@doc 获取QueryString中的Int参数值
get_int_param(Key,QueryString)->
    Val = proplists:get_value(Key,QueryString),
    common_tool:to_integer(Val).

%%@doc 获取QueryString中的atom参数值
get_atom_param(Key,QueryString)->
    Val = proplists:get_value(Key,QueryString),
    common_tool:to_atom(Val).

%%@doc 获取QueryString中的string参数值
get_string_param(Key,QueryString)->
    proplists:get_value(Key, QueryString).


%%@doc 对所有的Node进行rpc:call 指定的MFA
call_nodes(Module,Method,Args) when is_atom(Module),is_atom(Method), is_list(Args)->
    Nodes = [node()|nodes()],
    [ rpc:call(Nod, Module, Method, Args) ||Nod<-Nodes ].
%% 检查前端请求是是否已经合法登录平台
check_client_login_session(Req) ->
    check_client_login_session(Req,normal).

check_client_login_session(Req,ApiType) ->
	case Req:get(method) of
		'GET'  ->
			QueryString = Req:parse_qs();
		'POST' ->
			QueryString = Req:parse_post()
	end,
	LoginKey = proplists:get_value("login_key", QueryString,""),
	LoginTime = common_tool:to_integer(proplists:get_value("login_ts", QueryString,0)),
	case LoginKey =:= "" orelse  LoginTime =:= 0 of
		true ->
			erlang:throw({error,?_RC_ADMIN_API_005,""});
		_ ->
			next
	end,
	AccountName = proplists:get_value("account_name", QueryString,""),
	AccountVia = proplists:get_value("account_via", QueryString,"0"),
	[ApiKey] = common_config_dyn:find_common(admin_api_key),
	[ApiValidInterval] = common_config_dyn:find_common(admin_api_valid_interval),
	CheckKey = common_tool:md5(lists:concat([AccountVia,AccountName,LoginTime,ApiKey])),
	?DEBUG("LoginKey=~s,LoginTime=~w,AccountName=~s,AccountVia=~s,CheckKey=~s",[LoginKey,LoginTime,AccountName,AccountVia,CheckKey]),
	case LoginKey =:=  CheckKey of
		true -> 
			next;
		_ ->
			erlang:throw({error,?_RC_ADMIN_API_024,""})
	end,
	case ApiValidInterval == 0 of
		true ->
			next;
		_ ->
            case ApiType == create_role orelse ApiType == login_info orelse ApiType == is_role of
                true ->
                    CheckValidInterval = 30 * ApiValidInterval;
                _ ->
                    CheckValidInterval = 5 * ApiValidInterval
            end,
			case common_tool:now() - LoginTime > CheckValidInterval of
				true -> %% 超时
					erlang:throw({error,?_RC_ADMIN_API_010,""});
				_ ->
					next
			end
	end,
	ok.
	 
%% 检查前端请求合法性
check_client_api_request(Req) ->
    [ApiKey] = common_config_dyn:find_common(client_api_key),
    check_api_request(Req,[],ApiKey,0).

%% 检查后台请求合法性
check_admin_api_request(Req) ->
    [AllowIpList] = common_config_dyn:find_common(admin_api_allow_ips),
    [ApiKey] = common_config_dyn:find_common(admin_api_key),
    [ApiValidInterval] = common_config_dyn:find_common(admin_api_valid_interval),
    check_api_request(Req,AllowIpList,ApiKey,ApiValidInterval).

%% 检查充值请求合法性
check_pay_api_request(Req) ->
    [AllowIpList] = common_config_dyn:find_common(pay_api_allow_ips),
    [ApiKey] = common_config_dyn:find_common(pay_api_key),
    [ApiValidInterval] = common_config_dyn:find_common(pay_api_valid_interval),
    check_api_request(Req,AllowIpList,ApiKey,ApiValidInterval).

%% 检查接口请求合法性
%% 合法返回 ok
%% 不合法 throw({error,OpCode,OpReason})
check_api_request(Req,AllowIpList,ApiKey,ApiValidInterval) ->
    case Req:get(method) of
        'GET'  ->
            QueryString = Req:parse_qs();
        'POST' ->
            QueryString = Req:parse_post()
    end,
    %% 请求IP
    RequestIp = Req:get(peer),
    case AllowIpList =:= [] orelse lists:member(RequestIp, AllowIpList) of
        true ->
            next;
        _ -> %% 此IP没有访问权限
            erlang:throw({error,?_RC_ADMIN_API_003,""})
    end,
    Sign = proplists:get_value("sign", QueryString),
    SignParamList = lists:keydelete("sign", 1, QueryString),
    SortSignParamList = lists:sort(fun({AKey,_},{BKey,_}) -> AKey < BKey end,SignParamList),
    
    SortSignParamListT = [ common_uri:quote_plus(Key ++ "=" ++ Value) || {Key,Value} <- SortSignParamList],
    SignParam = string:join(SortSignParamListT, "&"),
    
    NewSign = crypto:hmac(sha,common_tool:to_binary(lists:concat([ApiKey,"&"])),common_tool:to_binary(SignParam)),
    CheckSign = common_uri:quote_plus(base64:encode_to_string(NewSign)),
    ?DEBUG("Sign=~s,SignParam=~s,CheckSign=~s",[Sign,SignParam,CheckSign]),
    case Sign =:= CheckSign of
        true ->
            next;
        _ -> %% 接口加密验证失败
            erlang:throw({error,?_RC_ADMIN_API_004,""})
    end,
    case ApiValidInterval of
        0 ->
            next;
        _ ->
            Timestamp = mgeeweb_tool:get_int_param("timestamp", QueryString),
            case common_tool:now() - Timestamp > ApiValidInterval of
                true -> %% 超时
                    erlang:throw({error,?_RC_ADMIN_API_010,""});
                _ ->
                    next
            end
    end,
    ok.

