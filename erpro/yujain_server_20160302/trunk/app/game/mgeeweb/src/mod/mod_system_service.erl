%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-20
%% Description: 管理平台字典接口
-module(mod_system_service).

%%
%% Include files
%%
-include("mgeeweb.hrl").
%%
%% Exported Functions
%%
-export([
         do/2
         ]).

%%
%% API Functions
%%
do("/admin_platform" ++ _,Req) ->
    do_admin_platform(Req);

do("/platform" ++ _,Req) ->
    do_platform(Req);

do("/kick_role" ++ _,Req) ->
    do_kick_role(Req);

do("/kick_all" ++ _,Req) ->
    do_kick_all(Req);

do("/setting/query" ++ _,Req) ->
    do_setting_query(Req);
do("/setting/reset" ++ _,Req) ->
    do_setting_reset(Req);
do("/setting/add" ++ _,Req) ->
    do_setting_add(Req);
do("/setting/del" ++ _,Req) ->
    do_setting_del(Req);

do("/get_client_version" ++ _, Req) ->
	get_client_version(Req);

do(Path,Req) ->
    ?ERROR_MSG("~ts,Path=~w,Req=~w",["receive unknown message",Path,Req]),
    mgeeweb_tool:return_json_error(Req).

%% 是否开放了平台进入游戏
do_platform(Req) ->
    case catch do_platform2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok,State} ->
            Rtn = [{op_code,0},{op_reason,""},{state,State}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_platform2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    OpType =  common_tool:to_integer(proplists:get_value("op_type",QueryString,0)),
    case OpType of
        1 ->
            case common_misc:is_platform_state() of
                false -> 
                    State = 0;
                _ -> %% 关闭入口
                    State = 1
            end;
        2 ->
            State =  common_tool:to_integer(proplists:get_value("state",QueryString,0)),
            ServerDataDir = main_exec:get_server_data_dir(),
            FileName = io_lib:format("~s/platform.lock",[ServerDataDir]),
            case State of
                0 -> 
                    case filelib:is_file(FileName) of
                        true ->
                            file:delete(FileName);
                        _ ->
                            next
                    end;
                _ ->
                    case filelib:is_file(FileName) of
                        true ->
                            next;
                        _ ->
                            file:write_file(FileName, ?_LANG_GAME_MAINTAIN, [binary])
                    end
            end;
        _ ->
            State = 0,
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    {ok,State}.

%% 是否开放了后台进入游戏
do_admin_platform(Req) ->
    case catch do_admin_platform2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok,State} ->
            Rtn = [{op_code,0},{op_reason,""},{state,State}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_admin_platform2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    OpType =  common_tool:to_integer(proplists:get_value("op_type",QueryString,0)),
    case OpType of
        1 ->
            case common_misc:is_platform_admin_state() of
                false -> 
                    State = 0;
                _ -> %% 关闭入口
                    State = 1
            end;
        2 ->
            State =  common_tool:to_integer(proplists:get_value("state",QueryString,0)),
            ServerDataDir = main_exec:get_server_data_dir(),
            FileName = io_lib:format("~s/platform.admin.lock",[ServerDataDir]),
            case State of
                0 -> 
                    case filelib:is_file(FileName) of
                        true ->
                            file:delete(FileName);
                        _ ->
                            next
                    end;
                _ ->
                    case filelib:is_file(FileName) of
                        true ->
                            next;
                        _ ->
                            file:write_file(FileName, ?_LANG_GAME_MAINTAIN, [binary])
                    end
            end;
        _ ->
            State = 0,
            erlang:throw({error,?_RC_ADMIN_API_005,""})
    end,
    {ok,State}.
%% 踢玩家下线
do_kick_role(Req) ->
    case catch do_kick_role2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_kick_role2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    RoleId = common_tool:to_integer(proplists:get_value("role_id",QueryString,0)),
    case RoleId of
        0 ->
            erlang:throw({error,?_RC_ADMIN_API_005,""});
        _ ->
            next
    end,
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            next;
        PId ->
            PId ! kick_by_admin
    end,
    {ok}.
%% 踢所有玩家下线
do_kick_all(Req) ->
    case catch do_kick_all2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_kick_all2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    ServerDataDir = main_exec:get_server_data_dir(),
    FileName = io_lib:format("~s/platform.lock",[ServerDataDir]),
    file:write_file(FileName, ?_LANG_GAME_MAINTAIN, [binary]),
    catch gen_server:call(mgeeg_role_sock_map, shutdown, infinity),
    {ok}.

%% 查询系统配置
do_setting_query(Req) ->
    case catch do_setting_query2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok,Data} ->
            Rtn = [{op_code,0},{op_reason,""},{data,Data}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_setting_query2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    Keys = proplists:get_value("keys", QueryString,""),
    StrKeyList = string:tokens(Keys,","),
    KeyList = [common_tool:to_atom(StrKey) || StrKey <- StrKeyList],
    [CanChangeList] = common_config_dyn:find(system, can_change_list),
    case KeyList of
        [] ->
            QueryKeyList = CanChangeList;
        _ ->
            QueryKeyList = 
                lists:foldl(
                  fun(PKey,AccQueryKeyList) -> 
                          case lists:member(PKey, CanChangeList) of
                              true ->
                                  [PKey|AccQueryKeyList];
                              _ ->
                                  AccQueryKeyList
                          end
                  end, [], KeyList)
    end,
    JsonList = 
        lists:foldl(
          fun(Key,AccJsonList) -> 
                  case common_misc:get_system_config(Key) of
                      {ok,SystemConfig} ->
                          Value = base64:encode_to_string(base64:encode_to_string(SystemConfig#r_system_config.value)), 
                          [common_misc:record_to_json(SystemConfig#r_system_config{value = Value}) | AccJsonList];
                      _ ->
                          AccJsonList
                  end
          end, [], QueryKeyList),
    Data = lists:concat(["[",string:join(JsonList, ","),"]"]),
    {ok,Data}.

%% 系统配置
do_setting_reset(Req) ->
    case catch do_setting_reset2(Req) of
        {error,OpCode,OpReason} ->
             Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_setting_reset2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    Settings = proplists:get_value("settings", QueryString,""),
    SystemConfigList = get_system_config_list_by_param(Settings),
    [CanChangeList] = common_config_dyn:find(system, can_change_list),
    lists:foreach(
      fun(Key) -> 
              db_api:dirty_delete(?DB_SYSTEM_CONFIG, Key)
      end, CanChangeList),
    lists:foreach(
      fun(SystemConfig) ->
              case lists:member(SystemConfig#r_system_config.key, CanChangeList) of
                  true ->
                      db_api:dirty_write(?DB_SYSTEM_CONFIG, SystemConfig);
                  _ ->
                      next
              end
      end, SystemConfigList),
	common_misc:gen_system_config_beam(),
    {ok}.

%% 消息参数格式
%% key:配置项
%% value:配置值，需要两次base64加密
%% 
%% key,value|…
%% 返回 [#r_system_config{},...] | []
get_system_config_list_by_param("") ->
    [];
get_system_config_list_by_param(Args) ->
    StrArgsList = string:tokens(Args,"|"),
    get_system_config_list_by_param2(StrArgsList,[]).
get_system_config_list_by_param2([],InfoList) ->
    InfoList;
get_system_config_list_by_param2([StrArgs|StrArgsList],InfoList) ->
    StrParamList =string:tokens(StrArgs, ","),
    {Info,_Index}=
        lists:foldl(
          fun(StrParam,{AccInfo,AccIndex})->
                  NewAccIndex = AccIndex + 1,
                  case AccIndex of
                      1-> {AccInfo#r_system_config{key = common_tool:to_atom(StrParam)},NewAccIndex};
                      2-> 
                          Value = base64:decode_to_string(base64:decode_to_string(StrParam)),
                          {AccInfo#r_system_config{value = Value},NewAccIndex}
                  end      
          end, {#r_system_config{},1}, StrParamList),
    get_system_config_list_by_param2(StrArgsList,[Info|InfoList]).

do_setting_add(Req) -> 
    case catch do_setting_add2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_setting_add2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    Key = common_tool:to_atom(proplists:get_value("key", QueryString,"")),
    Val = proplists:get_value("val", QueryString,""),
    Value = base64:decode_to_string(base64:decode_to_string(Val)),
    [CanChangeList] = common_config_dyn:find(system, can_change_list),
    case lists:member(Key, CanChangeList) of
        true ->
            db_api:dirty_write(?DB_SYSTEM_CONFIG,#r_system_config{key = Key,value = Value});
        _ ->
            next
    end,
	common_misc:gen_system_config_beam(),
    {ok}.
do_setting_del(Req) ->
    case catch do_setting_del2(Req) of
        {error,OpCode,OpReason} ->
             Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok} ->
            Rtn = [{op_code,0},{op_reason,""}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).
do_setting_del2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    Keys = proplists:get_value("keys", QueryString,""),
    StrKeyList = string:tokens(Keys,","),
    KeyList = [common_tool:to_atom(StrKey) || StrKey <- StrKeyList],
    case KeyList of
        [] ->
            erlang:throw({error,?_RC_ADMIN_API_005,""});
        _ ->
            next
    end,
    [CanChangeList] = common_config_dyn:find(system, can_change_list),
    lists:foreach(
      fun(Key) -> 
              case lists:member(Key, CanChangeList) of
                  true ->
                      db_api:dirty_delete(?DB_SYSTEM_CONFIG,Key);
                  _ ->
                      next
              end
      end, KeyList),
	common_misc:gen_system_config_beam(),
    {ok}.

%% 获取当前端版本号
get_client_version(Req) ->
	case catch get_client_version2(Req) of
		{error,OpCode,OpReason} ->
			Rtn = [{op_code, OpCode},{op_reason,OpReason}];
		{ok,ClientVersion} ->
			Rtn = [{op_code, 0},{op_reason,""},
				   {client_version,ClientVersion}]
	end,
	mgeeweb_tool:return_json(Rtn, Req).
get_client_version2(Req) ->
	ok = mgeeweb_tool:check_admin_api_request(Req),
	{ok,common_misc:get_client_version()}.