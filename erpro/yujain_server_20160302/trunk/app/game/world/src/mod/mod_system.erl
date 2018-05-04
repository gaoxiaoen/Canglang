%%% -------------------------------------------------------------------
%%% Author  : Luo.JCheng
%%% Description :
%%%
%%% Created : 2010-9-3
%%% -------------------------------------------------------------------
-module(mod_system).

-include("mgeew.hrl").

-export([handle/1, 
         role_online/2,
         get_default_value/1,
         get_dirty_role_sys_conf/2]).


handle({_Module, ?SYSTEM_CONFIG_UPDATE, DataIn, RoleId,Pid, _Line}) ->
    do_config_update(DataIn, RoleId,Pid);

handle(Info) ->
    ?ERROR_MSG("receive unknown message,info=~w", [Info]).


		
%% 脏读数据
%% return default value
get_dirty_role_sys_conf(RoleId,Key) when erlang:is_integer(RoleId)->
    case db_api:dirty_read(?DB_ROLE_SYS_CONF,RoleId) of
        [RoleConf]->
            get_dirty_role_sys_conf(RoleConf#r_role_sys_conf.conf_list,Key);
        _->
            get_default_value(Key)
    end;
get_dirty_role_sys_conf(ConfigList,Key)->
    case lists:keyfind(Key,#p_key_value.key,ConfigList) of
        false->
            get_default_value(Key);
        Config->
            get_convert_value(Config)
    end.


get_convert_value(#p_key_value{key=?SYS_CHAT,value=IntList})->
    [int_2_bool(Int)||Int<-IntList].

-define(GET_DEFAULT_VALUE(Key),
        [IntValue]= common_config_dyn:find(sys_conf, Key),
        case IntValue of
            [0]->false;
            _->true
        end).

%%开启私聊频道 阵营频道 帮派频道 世界频道 组队频道 中央广播
get_default_value(?SYS_CHAT)->
    [IntList]= common_config_dyn:find(sys_conf, ?SYS_CHAT),
    [int_2_bool(Int)||Int<-IntList].


role_online(RoleId,PId)->
    case db_api:dirty_read(?DB_ROLE_SYS_CONF,RoleId) of
        []->
            ConfigList = [];
        [Info]->
            ConfigList = Info#r_role_sys_conf.conf_list
    end,
    SendSelf = #m_system_config_update_toc{config_list=ConfigList},
    common_misc:unicast(PId, ?SYSTEM, ?SYSTEM_CONFIG_UPDATE, SendSelf).

do_config_update(DataIn, RoleId,Pid)->
    case catch can_config_update(DataIn,RoleId) of
        {ok,NewConfigList,FuncList}->
            db_api:dirty_write(?DB_ROLE_SYS_CONF,#r_role_sys_conf{role_id=RoleId,conf_list=NewConfigList}),
            lists:foreach(fun(Fun)-> catch Fun() end, FuncList),
            R = #m_system_config_update_toc{config_list=DataIn#m_system_config_update_tos.config_list};
        {error,ErrCode}->
            R = #m_system_config_update_toc{err_code = ErrCode}
    end,
    common_misc:unicast(Pid, ?SYSTEM, ?SYSTEM_CONFIG_UPDATE, R).
            

can_config_update(DataIn,RoleId) ->
    #m_system_config_update_tos{config_list=ConfigList} = DataIn,
    case db_api:dirty_read(?DB_ROLE_SYS_CONF,RoleId) of
        [RoleConfig]->
            RoleConfigList = RoleConfig#r_role_sys_conf.conf_list;
        _->
            RoleConfigList = []
    end,
    {RoleConfigList2,FuncList}= 
        lists:foldl(
          fun(Config,{AccConfList,AccFuncList})->
				  %% 检查参数
				  #p_key_value{key=Key,value=Value} = Config,
				  [IgnoreList] = common_config_dyn:find(sys_conf, cannot_change_list),
				  
				  case lists:member(Key, IgnoreList) of
					  true ->
						  {AccConfList,AccFuncList};
					  _ ->
						  case common_config_dyn:find(sys_conf,Key) of
							  []->
								  erlang:throw({error,?_RC_SYS_CONF_UPDATE_001}),
								  DefaultValue=[];
							  [DefaultValue]->
								  ingore
						  end,
						  lists:foreach(
							fun(ValueT)-> 
									case erlang:is_integer(ValueT) of
										true->
											next;
										false->
											erlang:throw({error,?_RC_SYS_CONF_UPDATE_001})
									end
							end, Value),
						  
						  %% 获取返回函数
						  AccFuncList2 = 
							  case get_func(RoleId,Config) of
								  {ok,Fun}->
									  [Fun|AccFuncList];
								  _->
									  AccFuncList
							  end,
						  %% 配置文件
						  AccConfList2 = 
							  case DefaultValue =:= Value of
								  true->
									  lists:keydelete(Key,#p_key_value.key, AccConfList);
								  false->
									  case lists:keyfind(Config#p_key_value.key, #p_key_value.key, AccConfList) of
										  false->
											  [Config|AccConfList];
										  OldConfig->
											  [Config|lists:delete(OldConfig, AccConfList)]
									  end
							  end,
						  {AccConfList2,AccFuncList2}
				  end
          end,{RoleConfigList,[]},ConfigList),
    {ok,RoleConfigList2,FuncList}.


get_func(_,_)->
    {error,not_found}.



int_2_bool(IntValue)->
    case IntValue of ?FALSE->false; ?TRUE->true end.

    