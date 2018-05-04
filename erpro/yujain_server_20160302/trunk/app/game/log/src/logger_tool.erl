%% Author: markycai<tomarky.cai@gmail.com>
%% Created: 2013-10-21
%% Description: TODO: Add description to logger_tool

-module(logger_tool).

%%
%% Include files
%%
-include("logger.hrl").
%%
%% Exported Functions
%%
-export([get_receiver_name/0,
         get_receiver_name/2,
         get_pool_name/2,
         get_logger_node/0,
         conn_status/0,
         stop_receiver/2,
         get_dump_mod/2,
         make_sql/3,
         error_msg/1,
         sync_code/0,
         reset_pool/2]).

reset_pool(AgentId,ServerId)->
    PoolName = logger_tool:get_pool_name(AgentId,ServerId),
    emysql:remove_pool(PoolName),
    [{Host,User,Password,Database}]=common_config_dyn:find(common, {mysql_config,AgentId,ServerId}),
    emysql:add_pool(PoolName, ?POOL_SIZE, User, Password, Host, ?POOL_PORT, Database, ?ENCODING).

%%
%% API Functions
%%
%% 生成mysql语句
make_sql(SqlHead,SqlBody,Queue)->
    SqlHead ++ make_body(SqlBody,Queue).

make_body(SqlBody,[H|Queue])->    
    lists:foldl(
      fun(Info,Acc)->
              common_lang:get_format_lang_resources(SqlBody,Info)++","++Acc
              end, 
      common_lang:get_format_lang_resources(SqlBody,H), Queue);
make_body(_SqlBody,[])->
    [].

%% 停止接收进程
stop_receiver(AgentId,ServerId)->
    erlang:exit(global:whereis_name(logger_tool:get_receiver_name(AgentId,ServerId)), gm).

%% 检查连接状态
conn_status()->
    ReceiverName = get_receiver_name(),
    case global:whereis_name(ReceiverName) of
        undefined->
            {error,ReceiverName};
        _->
            {ok,ReceiverName}
    end.

sync_code()->
    case global:whereis_name(logger_tool:get_receiver_name()) of
        Pid when is_pid(Pid)->
            logger_dump_code:sync_code(Pid),
            ok;
        _->
            ignore
    end.

%% 获取接收日志进程名
get_receiver_name()->
    get_receiver_name(common_config:get_agent_id(),common_config:get_server_id()).
get_receiver_name(AgentId,ServerId)->
    lists:concat(["logger_receiver_",AgentId,"_",ServerId]).

%% 获取数据库连接池名
get_pool_name(AgentId,ServerId)->
    list_to_atom(integer_to_list(AgentId)++"_"++integer_to_list(ServerId)).

%% 获取日志节点名字
get_logger_node()->
    case common_config_dyn:find(common,log_node) of
        []->
            {error,not_found};
        [Node]->
            {ok,Node}
    end.

%% 获取入库模块名
get_dump_mod(AgentId,ServerId)->
    list_to_atom(lists:concat(["logger_dump_",AgentId,"_",ServerId])).


error_msg(Msg)->
    ?ERROR_MSG("-----~w",[Msg]).

%%
%% Local Functions
%%

