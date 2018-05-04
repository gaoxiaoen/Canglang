%%%-------------------------------------------------------------------
%%% File        :common_misc.erl
%%%-------------------------------------------------------------------
-module(common_misc).

-include("common.hrl").
-include("common_server.hrl").

-export([
         manage_applications/6, 
         start_applications/1, 
         stop_applications/1
        ]).

-export([
         unicast/2,
         unicast/4
        ]).

-export([
		 get_game_config_list/0,
		 get_client_version/0,
		 gen_system_config_beam/0,
         gen_limit_ip_beam/0,
         gen_limit_account_beam/0,
		 gen_limit_device_id_beam/0,
         merge_goods/1,
         game_name/0,
         get_role_color_name/3,
         get_faction_name/1,
         record_to_json/1,
         do_portal_run_api/4,
         do_admin_run_api/4,
         do_run_api/6,
         is_platform_state/0,
         is_platform_admin_state/0,
         get_system_config/1,
         is_fcm_open/0,
         is_reset_times/1,
         is_reset_times/2,
         is_reset_times/3,
         get_reset_ts/0
         ]).

-export([
         get_role_gateway_process_name/1,
         get_role_world_process_name/1,
         get_unicast_server_name/1   
         ]).

-export([
         get_init_key_id/0,
         get_init_pet_key_id/0,
		 get_real_name/2,
         get_key_name_suffix/1,
         get_server_id_by_id/1,
		 get_agent_id_by_id/1,
         get_map_avatar_id_by_id/1,
         get_gateway_key/1,
         get_quick_key/1,
         get_newer_mapid/1,
         is_has_role/2,
         update_dict_queue/2,
		 get_random_faction_id/0,
         
         get_role_id/1,
         get_role_base/1,
         get_role_attr/1,
         get_role_pos/1,
         get_role_ext/1,
         get_role_state/1,
         get_role_skill/1,
         send_to_role/2,
         send_to_role_map/2,
         send_role_attr_change/2,
         send_role_attr_change/3,
         send_role_attr_change_gold/2,
         send_role_attr_change_silver/2,
         send_role_attr_change_coin/2,
         send_role_attr_change_gold_and_silver/2,
         
         send_role_goods_change/3,
         send_role_goods_change/4
        ]).


manage_applications(Iterate, Do, Undo, SkipError, ErrorTag, Apps) ->
    Iterate(fun (App, Acc) ->
                    case Do(App) of
                        ok -> [App | Acc];
                        {error, {SkipError, _}} -> Acc;
                        {error, Reason} ->
                            lists:foreach(Undo, Acc),
                            throw({error, {ErrorTag, App, Reason}})
                    end
            end, [], Apps),
    ok.
start_applications(Apps) ->
    manage_applications(fun lists:foldl/3,
                        fun application:start/1,
                        fun application:stop/1,
                        already_started,
                        cannot_start_application,
                        Apps).
stop_applications(Apps) ->
    manage_applications(fun lists:foldr/3,
                        fun application:stop/1,
                        fun application:start/1,
                        not_started,
                        cannot_stop_application,
                        Apps).

%% 消息广播
unicast(undefined, _Msg) ->
    ignore;
unicast({role,RoleId}, Msg) ->
    case mgeew_role:get_role_world_state() of
        {ok,#r_role_world_state{gateway_pid = PId}} ->
            PId ! {message, Msg};
        _ ->
            case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
                undefined ->
                    next;
                PId ->
                    PId ! {message, Msg}
            end
    end;
unicast(PId,Msg) ->
    PId ! {message,Msg}.

%% 消息广播
unicast(undefined, _Module, _Method, _Msg) ->
    ignore;
unicast({role,RoleId}, Module, Method, Msg) ->
    case mgeew_role:get_role_world_state() of
        {ok,#r_role_world_state{gateway_pid = PId}} ->
            PId ! {message, Module, Method, Msg};
        _ ->
            case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
                undefined ->
                    next;
                PId ->
                    PId ! {message, Module, Method, Msg}
            end
    end;
unicast(PId, Module, Method, Msg) ->
    PId ! {message, Module, Method, Msg}.

%% #p_attr.attr_code 值
%% 101:开服日期,#p_attr.string_value=YYYY-MM-DD
%% 102:开服时间戳,#p_attr.int_value=1384945709
%% 103:代理Id,#p_attr.int_value=1
%% 104:当前服Id,#p_attr.int_value=1
%% 105:是否合服,#p_attr.int_value=true or false
%% 106:入口URL,#p_attr.string_value=http://www.portal.com/index.php
%% 107:是否debug模式,#p_attr.int_value=true or false
%% 108:是否开户充值入口,#p_attr.int_value=true or false
%% 获取信息配置信息
%% 返回 [#p_attr{},...] | []
get_game_config_list() ->
	[{{Year,Month,Day},{HH,MM,SS}}] = common_config_dyn:find_common(server_start_datetime),
	StrOpenDate = lists:concat([Year,"-",Month, "-", Day]),
	OpenSeconds = common_tool:datetime_to_seconds({{Year,Month,Day},{HH,MM,SS}}),
	
	[AgentId] = common_config_dyn:find_common(agent_id),
	[ServerId] = common_config_dyn:find_common(server_id),
	[IsMerged] = common_config_dyn:find_common(is_merged),
	[PortalApiHomeUrl] = common_config_dyn:find_common(portal_api_home_url),
	[IsDebug] = common_config_dyn:find_common(is_debug),
	{ok,#r_system_config{value = IsOpenRecharge}} = common_misc:get_system_config(is_open_recharge),
	
	[#p_attr{attr_code=101,string_value=StrOpenDate},
	 #p_attr{attr_code=102,int_value=OpenSeconds},
	 #p_attr{attr_code=103,int_value=AgentId},
	 #p_attr{attr_code=104,int_value=ServerId},
	 #p_attr{attr_code=105,int_value=?BOOL_TO_INT(IsMerged)},
	 #p_attr{attr_code=106,string_value=PortalApiHomeUrl},
	 #p_attr{attr_code=107,int_value=?BOOL_TO_INT(IsDebug)},
	 #p_attr{attr_code=108,int_value=?BOOL_TO_INT(common_tool:to_atom(IsOpenRecharge))}].
%% 获取当前服务器前端版本
get_client_version() ->
    ServerDataDir = main_exec:get_server_data_dir(),
    FileName = io_lib:format("~s/version_client.txt",[ServerDataDir]),
	case file:read_file(FileName) of
		{ok,Binary} ->
			[_,_|Version] = lists:reverse(erlang:binary_to_list(Binary)),
			erlang:list_to_integer(Version);
		_ ->
			0
	end.
%% 生成系统配置
gen_system_config_beam() ->
    LimitIpList =  db_api:dirty_match_object(?DB_SYSTEM_CONFIG,#r_system_config{_='_'}),
	KeyValueList = 
		lists:foldl(
		  fun(#r_system_config{key = Key,value = Value},AccKeyValueList) -> 
				  [{Key,{r_system_config,Key,Value}} | AccKeyValueList]
		  end, [], LimitIpList),
    ConfigModuleName = "system_p_config_codegen",
    try
        Src = common_config_code:gen_src(ConfigModuleName,key_value_consult,KeyValueList,KeyValueList),
        {Mod, Code} = dynamic_compile:from_string(Src),
        code:load_binary(Mod, ConfigModuleName ++ ".erl", Code),
        {ok, Code}
    catch
        Type:Reason -> 
            ?ERROR_MSG("gen system config banned account data error,Type=~w,Reason=~w",[Type,Reason])
    end. 
%% 生成内存封禁IP数据
gen_limit_ip_beam() ->
    LimitIpList =  db_api:dirty_match_object(?DB_LIMIT_IP,#r_limit_ip{_='_'}),
    NowSeconds = common_tool:now(),
    KeyValueList = 
        lists:foldl(
          fun(#r_limit_ip{ip = Ip,limit_time = LimitTime},AccKeyValueList) -> 
                  case LimitTime =/= 0 andalso NowSeconds > LimitTime of
                      true ->
                          db_api:dirty_delete(?DB_LIMIT_IP,Ip),
                          AccKeyValueList;
                      _ ->
                          [{Ip,{r_limit_ip,Ip,LimitTime}}| AccKeyValueList]
                  end
          end, [], LimitIpList),
    ConfigModuleName = "limit_ip_config_codegen",
    try
        Src = common_config_code:gen_src(ConfigModuleName,key_value_consult,KeyValueList,KeyValueList),
        {Mod, Code} = dynamic_compile:from_string(Src),
        code:load_binary(Mod, ConfigModuleName ++ ".erl", Code),
        {ok, Code}
    catch
        Type:Reason -> 
            ?ERROR_MSG("gen system config limit ip error,Type=~w,Reason=~w",[Type,Reason])
    end.
%% 生成内存封禁账号数据
gen_limit_account_beam() ->
    LimitIpList =  db_api:dirty_match_object(?DB_LIMIT_ACCOUNT,#r_limit_account{_='_'}),
    NowSeconds = common_tool:now(),
    KeyValueList = 
        lists:foldl(
          fun(#r_limit_account{account_name = AccountName,limit_time = LimitTime},AccKeyValueList) -> 
                  case LimitTime =/= 0 andalso NowSeconds > LimitTime of
                      true ->
                          db_api:dirty_delete(?DB_LIMIT_ACCOUNT,AccountName),
                          AccKeyValueList;
                      _ ->
                          [{AccountName,{r_limit_account,AccountName,LimitTime}} | AccKeyValueList]
                  end
          end, [], LimitIpList),
    ConfigModuleName = "limit_account_config_codegen",
    try
        Src = common_config_code:gen_src(ConfigModuleName,key_value_consult,KeyValueList,KeyValueList),
        {Mod, Code} = dynamic_compile:from_string(Src),
        code:load_binary(Mod, ConfigModuleName ++ ".erl", Code),
        {ok, Code}
    catch
        Type:Reason -> 
            ?ERROR_MSG("gen limit account data error,Type=~w,Reason=~w",[Type,Reason])
    end. 

%% 生成内存封禁设备数据
gen_limit_device_id_beam() ->
    LimitIpList =  db_api:dirty_match_object(?DB_LIMIT_DEVICE_ID,#r_limit_device_id{_='_'}),
    NowSeconds = common_tool:now(),
    KeyValueList = 
        lists:foldl(
          fun(#r_limit_device_id{device_id = DeviceId,limit_time = LimitTime},AccKeyValueList) -> 
                  case LimitTime =/= 0 andalso NowSeconds > LimitTime of
                      true ->
                          db_api:dirty_delete(?DB_LIMIT_DEVICE_ID,DeviceId),
                          AccKeyValueList;
                      _ ->
                          [{DeviceId,{r_limit_device_id,DeviceId,LimitTime}} | AccKeyValueList]
                  end
          end, [], LimitIpList),
    ConfigModuleName = "limit_device_id_config_codegen",
    try
        Src = common_config_code:gen_src(ConfigModuleName,key_value_consult,KeyValueList,KeyValueList),
        {Mod, Code} = dynamic_compile:from_string(Src),
        code:load_binary(Mod, ConfigModuleName ++ ".erl", Code),
        {ok, Code}
    catch
        Type:Reason -> 
            ?ERROR_MSG("gen limit device data error,Type=~w,Reason=~w",[Type,Reason])
    end.


merge_goods(GoodsList)->
    GoodsList2=
        lists:foldl(
          fun(GoodsT,Acc)->
                  Key = {GoodsT#p_goods.type_id},
                  IsMerge = 
                      case GoodsT#p_goods.type of
                          ?TYPE_EQUIP-> false;
                          ?TYPE_STONE ->
                              case cfg_stone:find(GoodsT#p_goods.type_id) of
                                  [#r_item_info{is_overlap = ?CAN_OVERLAP}] -> true;
                                  _ -> false
                              end;
                          ?TYPE_ITEM ->
                              [BaseInfo] = cfg_item:find(GoodsT#p_goods.type_id),
                              case BaseInfo#r_item_info.is_overlap =:= ?CAN_OVERLAP 
                                    andalso BaseInfo#r_item_info.use_num =:= 1 of
                                  true ->true;
                                  _ ->false
                              end;
                          _ ->false
                      end,
                  case IsMerge of
                      true->
                          case lists:keyfind(Key, 1, Acc) of
                              {Key,Num,Goods}->
                                  lists:keyreplace(Key, 1, Acc, {Key,Num+GoodsT#p_goods.number,Goods});
                              false->
                                  [{Key,GoodsT#p_goods.number,GoodsT}|Acc]
                          end;
                      false->
                          [{Key,GoodsT#p_goods.number,GoodsT}|Acc]
                  end
          end,[],GoodsList),
    lists:foldl(
      fun({_Key,Num,GoodsT},Acc)->
              case Num < ?MAX_ITEM_NUMBER of
                  true->
                      [GoodsT#p_goods{number=Num}|Acc];
                  false->
                      split_goods(Num,GoodsT,Acc)
              end
        end, [], GoodsList2).


split_goods(Num,Goods,List)->
    RemainNum = Num rem ?MAX_ITEM_NUMBER,
    GroupNum = Num div ?MAX_ITEM_NUMBER,
    List2 = 
        case RemainNum > 0 of
            true->[Goods#p_goods{number=RemainNum}|List];
            false->List
        end,
    split_goods2(GroupNum,Goods,List2).

split_goods2(0,_Goods,List)->List;
split_goods2(GroupNum,Goods,List)->
    split_goods2(GroupNum-1,Goods,[Goods#p_goods{number=?MAX_ITEM_NUMBER}|List]).


game_name()->
	?_LANG_GAME_NAME.

get_role_color_name(RoleId,RoleName,FactionId)->
    case FactionId of
        ?FACTION_ID_1->
            common_lang:get_lang(507, [RoleId,RoleName,RoleName]);
        ?FACTION_ID_2->
            common_lang:get_lang(508, [RoleId,RoleName,RoleName]);
        ?FACTION_ID_3->
            common_lang:get_lang(509, [RoleId,RoleName,RoleName]);
		_ ->
			""
    end.

get_faction_name(FactionId) ->
    case FactionId of
        ?FACTION_ID_1 ->
            common_lang:get_lang(501);
        ?FACTION_ID_2 ->
            common_lang:get_lang(502);
        ?FACTION_ID_3 ->
            common_lang:get_lang(503);
		_ ->
			""
    end.
        
%% 网关进程名称
get_role_gateway_process_name(RoleId) ->
    erlang:list_to_atom(lists:concat(["gateway_", RoleId])).
%% 世界进程名称
get_role_world_process_name(RoleId) ->
    erlang:list_to_atom(lists:concat(["world_", RoleId])).

get_unicast_server_name(Gateway) ->
    erlang:list_to_atom(lists:concat(["unicast_server_", Gateway])).

%% 玩家初始化Id
get_init_key_id() ->
	[AgentId] = common_config_dyn:find_common(agent_id),
    [ServerId] = common_config_dyn:find_common(server_id),
    [KeyIdMaxDigit] = common_config_dyn:find(etc, key_id_max_digit),
	((AgentId + 100) * 10000 + ServerId) * KeyIdMaxDigit.
%% 宠物初始化Id
get_init_pet_key_id() ->
    [AgentId] = common_config_dyn:find_common(agent_id),
    [ServerId] = common_config_dyn:find_common(server_id),
    [KeyIdMaxDigit] = common_config_dyn:find(etc, key_id_max_digit),
    ((AgentId + 100) * 10000 + ServerId) * KeyIdMaxDigit * 10.
%% 游戏名称后缀
get_real_name(InName,ServerId) ->
	%% 如果是合服，则玩家名称和帮派名称都需要加上后缀
	%% 如果是正常服，则玩家名称和帮派名称可以根据配置是否需要添加后缀
	case ?IS_NAME_SUFFIX =:= true orelse common_config_dyn:find_common(is_merged) =:= [true] of
		true ->
			[KeyNameSeparate] = common_config_dyn:find(etc,key_name_separate),
            [KeyNameRegular] = common_config_dyn:find(etc,key_name_regular),
            common_tool:to_binary(common_lang:get_format_lang_resources(KeyNameRegular, [InName,KeyNameSeparate,ServerId]));
		_ ->
			common_tool:to_binary(InName)
	end.
%% 玩家名称后缀
get_key_name_suffix(OldRoleName) ->
    [KeyNameSeparate] = common_config_dyn:find(etc,key_name_separate),
    StrOldRoleName = common_tool:to_list(OldRoleName),
    KeyStartIndex = string:str(StrOldRoleName, KeyNameSeparate),
    case KeyStartIndex > 0 of
        true ->
            string:substr(StrOldRoleName,KeyStartIndex);
        _ ->
            [ServerId] = common_config_dyn:find_common(server_id),
            KeyNameSeparate ++ common_tool:to_list(ServerId)
    end.
%% 根据id（玩家Id,帮派id）获取玩家服Id
get_server_id_by_id(Id) ->
    [KeyIdMaxDigit] = common_config_dyn:find(etc, key_id_max_digit),
	AgentId = Id div (KeyIdMaxDigit * 10000) - 100,
    Id div KeyIdMaxDigit - (100 + AgentId) * 10000.
get_agent_id_by_id(Id) ->
	[KeyIdMaxDigit] = common_config_dyn:find(etc, key_id_max_digit),
    Id div (KeyIdMaxDigit * 10000) - 100.
%% 根据玩家Id获取玩家地图镜像id
get_map_avatar_id_by_id(Id) ->
    [KeyIdMaxDigit] = common_config_dyn:find(etc, key_id_max_digit),
    AvatarId = Id - (Id div KeyIdMaxDigit) * KeyIdMaxDigit,
    AvatarId + KeyIdMaxDigit * 10.
%% 网关验证key
get_gateway_key({AccountName,GatewayTime,FCM}) ->
    [MD5Key] = common_config_dyn:find(system, md5key),
    common_tool:md5(lists:concat([common_tool:to_list(AccountName),"gateway_key", GatewayTime,FCM,MD5Key])).

get_quick_key({AccountName,RoleId,QuickKeyTime}) ->
    [MD5Key] = common_config_dyn:find(system, md5key),
    common_tool:md5(lists:concat([common_tool:to_list(AccountName),"quick_key", RoleId,QuickKeyTime,MD5Key])).

%% 返回新手村地图
get_newer_mapid(FactionId) ->
    case cfg_common:find({newer_born_map_id,FactionId}) of
        undefined ->
            0;
        MapId ->
            MapId
    end.

%% 根据帐号和服务器id，判断是否有角色
%% 返回 {error,Reason} or {ok,RoleId}
is_has_role(AccountName,ServerId) ->
    case catch is_has_role2(AccountName,ServerId) of
        {ok,RoleId} ->
            {ok,RoleId};
        Error ->
            Error
    end.
is_has_role2(AccountName,ServerId) ->
    case common_config_dyn:find_common({can_login_id,ServerId}) of
        [true] ->
            next;
        _ ->
            erlang:throw({error,error_server_id})
    end,
    case db_api:dirty_read(?DB_ACCOUNT, AccountName) of
        [Account] ->
            next;
        _ ->
            Account=undefined,
            erlang:throw({error,not_account})
    end,
    case lists:keyfind(ServerId, #r_account_sub.server_id, Account#r_account.role_list) of
        false ->
            RoleId = 0,
            erlang:throw({error,server_not_role});
        #r_account_sub{role_id = RoleId} ->
            case db_api:dirty_read(?DB_ROLE_BASE,RoleId) of
                [#p_role_base{role_id=RoleId}] ->
                    next;
                _ ->
                    RoleId = 0,
                    erlang:throw({error,role_base_not_role})
            end
    end,
    {ok,RoleId}.
%% 将数据值更新到进程字典的队列
update_dict_queue(Key,Value)->
    case erlang:get(Key) of
        undefined ->
            erlang:put(Key, [Value]);
        ValueList ->
            erlang:put( Key,[ Value|ValueList ] )
    end.

%% 根据国家分布人数，随机一个国家id
get_random_faction_id() ->
	case ets:lookup(?ETS_FACTION_ROLE, ?FACTION_ID_1) of
		[#r_faction_role{number=NumberA}] ->
			next;
		_ ->
			NumberA = 0
	end,
	case ets:lookup(?ETS_FACTION_ROLE, ?FACTION_ID_2) of
		[#r_faction_role{number=NumberB}] ->
			next;
		_ ->
			NumberB = 0
	end,
	case ets:lookup(?ETS_FACTION_ROLE, ?FACTION_ID_3) of
		[#r_faction_role{number=NumberC}] ->
			next;
		_ ->
			NumberC = 0
	end,
	Min = lists:min([NumberA, NumberB, NumberC]),
	case Min of
        NumberA ->
            ?FACTION_ID_1;
        NumberB ->
            ?FACTION_ID_2;
        NumberC ->
            ?FACTION_ID_3;
		_ ->
			?FACTION_ID_1
    end.
get_role_id(RoleName) ->
    case db_api:dirty_read(?DB_ROLE_NAME,common_tool:to_binary(RoleName)) of
        [#r_role_name{role_id = RoleId}] ->
            {ok,RoleId};
        _ ->
            {error,not_found}
    end.
get_role_base(RoleId) -> 
    case db_api:dirty_read(?DB_ROLE_BASE, RoleId) of
        [RoleBase] ->
            {ok, RoleBase};
        _ ->
            {error, not_found}
    end.
get_role_attr(RoleId) ->
    case db_api:dirty_read(?DB_ROLE_ATTR, RoleId) of
        [RoleAttr] ->
            {ok, RoleAttr};
        _ ->
            {error, not_found}
    end.
get_role_pos(RoleId) ->
    case db_api:dirty_read(?DB_ROLE_POS, RoleId) of
        [RolePos] ->
            {ok, RolePos};
        _ ->
            {error, not_found}
    end.
get_role_skill(RoleId) ->
    case db_api:dirty_read(?DB_ROLE_SKILL, RoleId) of
        [RoleSkill] ->
            {ok, RoleSkill};
        _ ->
            {error, not_found}
    end.
get_role_ext(RoleId) ->
    case db_api:dirty_read(?DB_ROLE_EXT, RoleId) of
        [RoleExt] ->
            {ok, RoleExt};
        _ ->
            {error, not_found}
    end.
get_role_state(RoleId) ->
    case db_api:dirty_read(?DB_ROLE_STATE, RoleId) of
        [RoleState] ->
            {ok, RoleState};
        _ ->
            {error, not_found}
    end.

%% 玩家逻辑进程发送消息
send_to_role(PId,Msg) when erlang:is_pid(PId) ->
    PId ! Msg;
send_to_role(RoleId,Msg) ->
    RoleProcessName = common_misc:get_role_world_process_name(RoleId),
    case erlang:whereis(RoleProcessName) of
        undefined ->
			case Msg of
				{mod,mod_money,{pay,_Info}} ->
					ignore;
				_ ->
					?ERROR_MSG("role PID does not exist,RoleId=~w,Msg=~w",[RoleId,Msg])
			end,
            ignore;
        PId ->
            PId ! Msg
    end.

%% 玩家所在地图进程发送消息
send_to_role_map(PId,Msg) when erlang:is_pid(PId) ->
    PId ! {mod,mod_map_role,{pre_role_map,Msg}};
send_to_role_map(RoleId,Msg) ->
    case mod_role:get_role_pos(RoleId) of
        {ok,#r_role_pos{map_process_name = MapProcessName}} ->
            case erlang:whereis(MapProcessName) of
                undefined ->
                    ?ERROR_MSG("role location map process does not exist,RoleId=~w,Msg=~w",[RoleId,Msg]),
                    ignore;
                PId ->
                    PId ! {mod,mod_map_role,{pre_role_map,RoleId,Msg}}
            end;
        _ ->
            ?ERROR_MSG("role location map process does not exist,RoleId=~w,Msg=~w",[RoleId,Msg]),
            ignore
    end.

send_role_attr_change(RoleBase,ChangeList) when erlang:is_record(RoleBase,p_role_base)->
    RoleId = RoleBase#p_role_base.role_id,
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            ignore;
        PId ->
            AttrList = get_role_attr_list(RoleBase,ChangeList),
            send_role_attr_change(PId,RoleId,AttrList)
    end;
%% 玩家属性变化通知接口
send_role_attr_change(RoleId,AttrList) when erlang:is_integer(RoleId)->
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            ignore;
        PId ->
            send_role_attr_change(PId,RoleId,AttrList)
    end.
send_role_attr_change(PId,_RoleId,AttrList) ->
    SendSelf = #m_role_attr_change_toc{attr_list = AttrList},
    common_misc:unicast(PId, ?ROLE, ?ROLE_ATTR_CHANGE, SendSelf).


get_role_attr_list(RoleBase,ChangeList)->
    get_role_attr_list(RoleBase,ChangeList,[]).

get_role_attr_list(RoleBase,[?ROLE_BASE_GOLD|List],AttrList)->
    Attr = #p_attr{attr_code = ?ROLE_BASE_GOLD,int_value = RoleBase#p_role_base.gold},
    get_role_attr_list(RoleBase,List,[Attr|AttrList]);
get_role_attr_list(RoleBase,[?ROLE_BASE_SILVER|List],AttrList)->
    Attr = #p_attr{attr_code = ?ROLE_BASE_SILVER,int_value = RoleBase#p_role_base.silver},
    get_role_attr_list(RoleBase,List,[Attr|AttrList]);
get_role_attr_list(RoleBase,[?ROLE_BASE_COIN|List],AttrList)->
    Attr = #p_attr{attr_code = ?ROLE_BASE_COIN,int_value = RoleBase#p_role_base.coin},
    get_role_attr_list(RoleBase,List,[Attr|AttrList]);
get_role_attr_list(_RoleBase,[],AttrList)->
    AttrList.

%% 元宝变化
send_role_attr_change_gold(RoleId,RoleBase) when erlang:is_integer(RoleId) ->
    AttrList = [#p_attr{attr_code = ?ROLE_BASE_GOLD,int_value = RoleBase#p_role_base.gold},
                #p_attr{attr_code = ?ROLE_BASE_TOTAL_GOLD,int_value = RoleBase#p_role_base.total_gold}],
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            ignore;
        PId ->
            send_role_attr_change(PId,RoleId,AttrList)
    end;
send_role_attr_change_gold(PId,RoleBase) ->
    AttrList = [#p_attr{attr_code = ?ROLE_BASE_GOLD,int_value = RoleBase#p_role_base.gold},
                #p_attr{attr_code = ?ROLE_BASE_TOTAL_GOLD,int_value = RoleBase#p_role_base.total_gold}],
    send_role_attr_change(PId,RoleBase#p_role_base.role_id,AttrList).
%% 银子变化
send_role_attr_change_silver(RoleId,RoleBase) when erlang:is_integer(RoleId) ->
    AttrList = [#p_attr{attr_code = ?ROLE_BASE_SILVER,int_value = RoleBase#p_role_base.silver}],
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            ignore;
        PId ->
            send_role_attr_change(PId,RoleId,AttrList)
    end;
send_role_attr_change_silver(PId,RoleBase) ->
    AttrList = [#p_attr{attr_code = ?ROLE_BASE_SILVER,int_value = RoleBase#p_role_base.silver}],
    send_role_attr_change(PId,RoleBase#p_role_base.role_id,AttrList).
%% 元宝和银子变化
send_role_attr_change_gold_and_silver(RoleId,RoleBase) when erlang:is_integer(RoleId) ->
    AttrList = [#p_attr{attr_code = ?ROLE_BASE_GOLD,int_value = RoleBase#p_role_base.gold},
                #p_attr{attr_code = ?ROLE_BASE_TOTAL_GOLD,int_value = RoleBase#p_role_base.total_gold},
                #p_attr{attr_code = ?ROLE_BASE_SILVER,int_value = RoleBase#p_role_base.silver},
                #p_attr{attr_code = ?ROLE_BASE_COIN,int_value = RoleBase#p_role_base.coin}],
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            ignore;
        PId ->
            send_role_attr_change(PId,RoleId,AttrList)
    end;
send_role_attr_change_gold_and_silver(PId,RoleBase) ->
    AttrList = [#p_attr{attr_code = ?ROLE_BASE_GOLD,int_value = RoleBase#p_role_base.gold},
                #p_attr{attr_code = ?ROLE_BASE_TOTAL_GOLD,int_value = RoleBase#p_role_base.total_gold},
                #p_attr{attr_code = ?ROLE_BASE_SILVER,int_value = RoleBase#p_role_base.silver},
                #p_attr{attr_code = ?ROLE_BASE_COIN,int_value = RoleBase#p_role_base.coin}],
    send_role_attr_change(PId,RoleBase#p_role_base.role_id,AttrList).

%% 铜钱变化
send_role_attr_change_coin(RoleId,RoleBase) when erlang:is_integer(RoleId) ->
    AttrList = [#p_attr{attr_code = ?ROLE_BASE_COIN,int_value = RoleBase#p_role_base.coin}],
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            ignore;
        PId ->
            send_role_attr_change(PId,RoleId,AttrList)
    end;
send_role_attr_change_coin(PId,RoleBase) ->
    AttrList = [#p_attr{attr_code = ?ROLE_BASE_COIN,int_value = RoleBase#p_role_base.coin}],
    send_role_attr_change(PId,RoleBase#p_role_base.role_id,AttrList).



%% 物品通知
send_role_goods_change(_RoleId,[],[]) ->
	ignroe;
send_role_goods_change(RoleId,GoodsList,DelGoodsIdList) when erlang:is_integer(RoleId) ->
     case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            ignore;
        PId ->
            send_role_goods_change(PId,?MAIN_BAG_ID,GoodsList,DelGoodsIdList)
    end;
send_role_goods_change(PId,GoodsList,DelGoodsIdList) ->
    send_role_goods_change(PId,?MAIN_BAG_ID,GoodsList,DelGoodsIdList).

send_role_goods_change(RoleId,BagId,GoodsList,DelGoodsIdList) when erlang:is_integer(RoleId) ->
    case erlang:whereis(common_misc:get_role_gateway_process_name(RoleId)) of
        undefined ->
            ignore;
        PId ->
            send_role_goods_change(PId,BagId,GoodsList,DelGoodsIdList)
    end;
send_role_goods_change(PId,BagId,GoodsList,DelGoodsIdList) ->
    SendSelf = #m_goods_update_toc{bag_id = BagId,goods_list = GoodsList,del_id_list = DelGoodsIdList},
    common_misc:unicast(PId, ?GOODS, ?GOODS_UPDATE, SendSelf).
    

%% 请求portal平台，只发送请求不接收数据
%% Method 请求方式 get,post
%% Options 参数为 Options
do_portal_run_api(Method,UrlSuffix,ParamList,ReturnFun) ->
    [HomeUrl] = common_config_dyn:find_common(portal_api_home_url),
    [ApiKey] = common_config_dyn:find_common(admin_api_key),
    erlang:spawn(?MODULE, do_run_api, [Method,UrlSuffix,ParamList,HomeUrl,ApiKey,ReturnFun]).

%% 请求admin平台
do_admin_run_api(Method,UrlSuffix,ParamList,ReturnFun) ->
    [HomeUrl] = common_config_dyn:find_common(admin_api_home_url),
    [ApiKey] = common_config_dyn:find_common(admin_api_key),
    erlang:spawn(?MODULE, do_run_api, [Method,UrlSuffix,ParamList,HomeUrl,ApiKey,ReturnFun]).

do_run_api(Method,UrlSuffix,ParamList,HomeUrl,ApiKey,ReturnFun) ->
    SortParamList = lists:sort(fun({AKey,_},{BKey,_}) -> AKey < BKey end,ParamList),
    %% 签名
    SignParamList = [ common_uri:quote_plus(common_tool:to_list(Key) ++ "=" ++ common_tool:to_list(Value)) 
                    || {Key,Value} <- SortParamList],
    SignParam = string:join(SignParamList, "&"),
    NewSign = crypto:hmac(sha,common_tool:to_binary(lists:concat([ApiKey,"&"])),common_tool:to_binary(SignParam)),
    Sign = common_uri:quote_plus(base64:encode_to_string(NewSign)),
    
    %% 参数
    Param = common_uri:urlencode([{"sign",Sign}|SortParamList]),
    ?DEBUG("SignParam=~s,Sign=~s,Param=~s",[SignParam,Sign,Param]),
    case Method of
        get ->
            Url = lists:concat([HomeUrl,UrlSuffix,"?",Param]),
            case ReturnFun of
                undefined ->
                    httpc:request(get, {Url,[]},[{timeout,5000}],[]);
                _ ->
                    case httpc:request(get, {Url,[]},[{timeout,5000}],[]) of
                        {ok, {_StatusLine, _Headers, Body}} ->
                            ReturnFun(Body);
                        {ok, {_StatusCode, Body}} ->
                            ReturnFun(Body);
                       	GetError ->
							?ERROR_MSG("~ts,Url=~w,Param=~w,Error=~w",["请求外部连接返回出错",Url,Param,GetError]),
                            ReturnFun(undefined)
                    end
            end;
        post ->
            Url = lists:concat([HomeUrl,UrlSuffix]),
            ContentType = "application/x-www-form-urlencoded", 
            case ReturnFun of
                undefined ->
                    httpc:request(post, {Url,[],ContentType,Param},[{timeout,5000}],[]);
                _ ->
                    case httpc:request(post, {Url,[],ContentType,Param},[{timeout,5000}],[]) of
                        {ok, {_StatusLine, _Headers, Body}} ->
                            ReturnFun(Body);
                        {ok, {_StatusCode, Body}} ->
                            ReturnFun(Body);
                        PostError ->
							?ERROR_MSG("do request api return error,Url=~w,Param=~w,Error=~w",[Url,Param,PostError]),
                            ReturnFun(undefined)
                    end
            end
    end,
    ok.

%% 是否开放了平台进入游戏
is_platform_state() ->
    ServerDataDir = main_exec:get_server_data_dir(),
    FileName = io_lib:format("~s/platform.lock",[ServerDataDir]),
    filelib:is_file(FileName).

%% 是否开放了后台进入游戏
is_platform_admin_state() ->
    ServerDataDir = main_exec:get_server_data_dir(),
    FileName = io_lib:format("~s/platform.admin.lock",[ServerDataDir]),
    filelib:is_file(FileName).

%% 获取系统配置
get_system_config(Key) ->
	case common_config_dyn:find(system, Key) of
		[ConfigValue] ->
			case common_config_dyn:find(system_p, Key) of
				[SystemConfig] ->
					{ok,SystemConfig};
				_ ->
					case db_api:dirty_read(?DB_SYSTEM_CONFIG,Key) of
						[SystemConfig] ->
							{ok,SystemConfig};
						_ ->
							{ok,#r_system_config{key = Key,value = ConfigValue}}
					end
			end;
		_ ->
			{error,not_found}
	end.
%% 判断防沉迷是否打开，直接从数据库中读取
is_fcm_open() ->
    case get_system_config(fcm) of
        {ok,#r_system_config{key = "true"}} ->
            true;
        _ ->
            false
    end.

%% 获取重算次数的时间戳
get_reset_ts() ->
    common_tool:datetime_to_seconds({erlang:date(),{5,0,0}}).
%% 检查是否需要重算交数
%% true 需要重置
%% false 不用重置
is_reset_times(LastTS)->
    is_reset_times(common_tool:now(),LastTS).

is_reset_times(NowTS,LastTS) ->
    is_reset_times(NowTS,LastTS,get_reset_ts()).

is_reset_times(NowTS,LastTS,ResetTS)->    
    %% 当天五点
    case NowTS >= ResetTS of
        true->
            LastTS < ResetTS;
        false->
            ResetTS - LastTS > 86400 
    end.


%% record to json
%% 将record 转换成 json
record_to_json(Record) when erlang:is_tuple(Record) ->
    [RecordName|ValueList] = erlang:tuple_to_list(Record),
    record_to_json(RecordName,ValueList);
record_to_json(_Record) ->
    {error,not_tuple}.

-define(RECORD_TO_JSON2(RecordName,ValueList),
        record_to_json(RecordName,ValueList)->
            FieldList = record_info(fields,RecordName),
            {FieldValueList,FieldFormat} = get_format_record_value(ValueList,FieldList,[],""),
            common_lang:get_format_lang_resources(lists:concat(["{",FieldFormat, "}"]), FieldValueList)
            ).


?RECORD_TO_JSON2(r_role_name,Rec);

?RECORD_TO_JSON2(r_ban_chat_user,Rec);

?RECORD_TO_JSON2(p_role_base,Rec);
?RECORD_TO_JSON2(p_role_attr,Rec);
?RECORD_TO_JSON2(r_role_pos,Rec);
?RECORD_TO_JSON2(p_role_ext,Rec);
?RECORD_TO_JSON2(r_role_state,Rec);
?RECORD_TO_JSON2(p_pos,Rec);
?RECORD_TO_JSON2(p_role,Rec);

?RECORD_TO_JSON2(p_tiny_goods,Rec);
?RECORD_TO_JSON2(p_goods,Rec);
?RECORD_TO_JSON2(p_equip_stone,Rec);

?RECORD_TO_JSON2(p_key_value,Rec);
?RECORD_TO_JSON2(r_limit_account,Rec);
?RECORD_TO_JSON2(r_limit_ip,Rec);
?RECORD_TO_JSON2(r_limit_device_id,Rec);

?RECORD_TO_JSON2(r_system_config,Rec);

?RECORD_TO_JSON2(r_family,Rec);
?RECORD_TO_JSON2(r_family_request,Rec);
?RECORD_TO_JSON2(r_family_member,Rec);



record_to_json(RecordName,_ValueList) ->
    {error,record_not_defined,RecordName}.

get_format_record_value([],[],FieldValueList,FieldFormat) ->
    {lists:reverse(FieldValueList),FieldFormat};
get_format_record_value([FieldValue|ValueList],[Field|FieldList],FieldValueList,FieldFormat) ->
    {FormatValue,FormatType} = get_format_record_value2(FieldValue,"",0),
    case FormatType of
        1 ->
            Format = "~s\"~s\":~s";
        _ ->
            Format = "~s\"~s\":\"~s\""
    end,
    case FieldList of
        [] ->
            NewFieldFormat = common_lang:get_format_lang_resources(Format, [FieldFormat,common_tool:to_list(Field),"~s"]);
        _ ->
            NewFieldFormat = common_lang:get_format_lang_resources(Format ++ ",", [FieldFormat,common_tool:to_list(Field),"~s"])
    end,
    get_format_record_value(ValueList,FieldList,[FormatValue|FieldValueList],NewFieldFormat).

get_format_record_value2([FieldValue],FileValueStr,OldFormatType) when erlang:is_tuple(FieldValue)->
    [RecordName|ValueList] = erlang:tuple_to_list(FieldValue),
    {FormatValue,FormatType} = 
        case record_to_json(RecordName,ValueList) of
            {error,record_not_defined,RecordName} ->
                {get_format_record_value3([RecordName|ValueList],FileValueStr) ,OldFormatType};
            TupleStr ->
                {FileValueStr ++ TupleStr,1}
        end,
    {"["++FormatValue++"]",FormatType};

get_format_record_value2([FieldValue|TFieldValueList],FileValueStr,OldFormatType)
  when erlang:is_tuple(FieldValue) ->
    [RecordName|ValueList] = erlang:tuple_to_list(FieldValue),
    {FormatValue,FormatType} = 
    case record_to_json(RecordName,ValueList) of
        {error,record_not_defined,RecordName} ->
            {get_format_record_value3([RecordName|ValueList],FileValueStr) ,OldFormatType};
        TupleStr ->
            {FileValueStr ++ TupleStr++",",1}
    end,
    get_format_record_value2(TFieldValueList,FormatValue,FormatType);
get_format_record_value2(FieldValue,FileValueStr,FormatType) when erlang:is_tuple(FieldValue) ->
    [RecordName|ValueList] = erlang:tuple_to_list(FieldValue),
    case record_to_json(RecordName,ValueList) of
        {error,record_not_defined,RecordName} ->
            {get_format_record_value3([RecordName|ValueList],FileValueStr),FormatType};
        TupleStr ->
            {FileValueStr ++ TupleStr,1}
    end;
get_format_record_value2(FieldValue,FileValueStr,FormatType) ->
    {FileValueStr ++ common_tool:to_list(FieldValue),FormatType}.

get_format_record_value3(FieldValue,FileValueStr) when erlang:is_tuple(FieldValue) ->
    ValueList = erlang:tuple_to_list(FieldValue),
    Len = erlang:length(ValueList),
    {AccStr,_} = 
        lists:foldl(
          fun(Value,{Acc,Index}) -> 
                  case Acc of
                      "{" ->
                          {Acc ++ get_format_record_value3(Value,""),Index  + 1};
                      _ ->
                          case Index + 1 =:= Len of
                              true ->
                                  {Acc ++ "," ++ get_format_record_value3(Value,"") ++ "}",Index + 1};
                              _ ->
                                  {Acc ++ "," ++ get_format_record_value3(Value,""),Index + 1}
                          end
                  end
          end, {"{",0}, ValueList),
    FileValueStr ++ AccStr;
get_format_record_value3(FieldValue,FileValueStr) ->
    FileValueStr ++ common_tool:to_list(FieldValue).
