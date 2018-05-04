%% Author: markycai<tomarky.cai@gmail.com>
%% Created: 2013-10-29
%% Description: 日志入库代码
%% 生成日志持久化代码
%% 每次游戏服连接日志将发送最新代码 （避免游戏服更新的时候日志服重启）
-module(logger_dump_code).

%%
%% Include files
%%
-include("logger.hrl").

%%
%% Exported Functionsz
%%
-export([sync_code/1,
         make_log_type_list/0]).

%%
%% API Functions
%%

%% 原来是rpc:call 后改成发消息
%% 防止原来进程旧代码没执行完就更新成新代码
%% ...
%% 改成在游戏服注册进程之前就更新最新代码，
%% 更新代码失败则不注册进程，防止新的日志发送到日志服而入库代码还没到
sync_code(Pid)->
    {Mod,Code} = dynamic_compile:from_string(unicode:characters_to_list(code_src())),
    gen_server:call(Pid, {load_beam,Mod,Code}).

make_log_type_list()->
    [begin
         SqlBody = "("++make_sql_body(RecordFields)++")",
         H = if WriteType =:=?insert ->" insert into ";
                true-> " replace into "
             end,
         SqlHead=H ++ atom_to_list(TabName) ++" ("++ make_sql_field(RecordFields) ++ ") values ",
         {r_log_cfg,RecordName, SqlHead,SqlBody, DumpInterval, MaxDumpNum}
     end
     ||#r_log_type{record_name = RecordName,
                   record_fields = RecordFields,
                   table_name = TabName,
                   write_type = WriteType,
                   dump_interval = DumpInterval,
                   max_dump_num = MaxDumpNum}<-cfg_logger:find(log_type_list)].


make_sql_field([H|T])->
    "`"++atom_to_list(H) ++ lists:append(["`,`" ++ atom_to_list(X) || X <- T])++"`";
make_sql_field([])->[].

make_sql_body([_H|T])->    
    lists:foldl(
      fun(_E,Acc)->
              "'~s',"++Acc
      end, "'~s'", T);
make_sql_body([])->
    [].


%% 数据入库代码
code_src()->
    AId= common_config:get_agent_id(),
    SId= common_config:get_server_id(),
    LogList =  lists:flatten(io_lib:format("~p",[make_log_type_list()])),
	"-module(logger_dump_"++ integer_to_list(AId) ++"_"++ integer_to_list(SId) ++").

%% 日志结构配置
%% log_key 日志类型  (实际上是日志record_name)
%% sql_head 数据库操作语句 
%% sql_body 数据库插入语句的动态添加部分
%% dump_interval 入库时间间隔
%% max_dump_num 等待入库最大日志条数
-record(r_log_cfg,{log_key,sql_head,sql_body,dump_interval=0,max_dump_num=0}).

-record(ok_packet, {seq_num, affected_rows, insert_id, status, warning_count, msg}).

-export([init/0,
         loop/1,
         dump_all/0,
         log/1,
         test/0]).
    
%% 测试函数
test()->"++ LogList ++".

%% 日志加入队列
log(LogList) when is_list(LogList) ->
    lists:foreach(fun(Log)->log(Log) end,LogList);
log(Log)->
    [LogKey|LogData]=tuple_to_list(Log),
    add_log_length(LogKey),
    add_log_queue(LogKey,LogData).
    
%% 秒循环判断哪些日志可以入库
loop(Now)->
    lists:foreach(
      fun(#r_log_cfg{log_key=LogKey,
                     max_dump_num=MaxDumpNum}=LogCfg)->
              %% 当前时间是否大于入库时间
              %% 数据等待入库最大条数
              case Now > get_log_dump_ts(LogKey) orelse get_log_length(LogKey) > MaxDumpNum of
                  true->
                      dump(LogCfg,Now);
                  false->
                      ignore
              end
      end, "++ LogList ++").

%% 全部日志入库 
%% 重载代码 或者进程关闭的时候调用
dump_all()->
    Now = common_tool:now(),
    lists:foreach(
      fun(LogCfg)->
              dump(LogCfg,Now)
      end,"++ LogList ++").

%% 日志入库
dump(LogCfg,Now)->
    catch dump2(LogCfg),
    reset_log(LogCfg,Now).

dump2(LogCfg)->
    #r_log_cfg{log_key=LogKey,
               sql_head = SqlHead,
               sql_body =SqlBody} = LogCfg,
    case get_log_queue(LogKey) of
        []->
            ignore;
        Queue->
            Sql = logger_tool:make_sql(SqlHead,SqlBody,Queue),
            PoolName=logger_receiver:get_pool_name(),
            case emysql:execute(PoolName, Sql) of
                #ok_packet{}->
                    ignore;
                Info->
                    logger_tool:error_msg({Sql,Info})
            end
    end.

%% 初始化日志
init()->
    Now = common_tool:now(),
    lists:foreach(
      fun(LogCfg)->
              reset_log(LogCfg,Now)
      end, "++ LogList ++").

reset_log(LogCfg,Now)->
    #r_log_cfg{log_key=LogKey,
               dump_interval=DumpInterval} = LogCfg,
    set_log_queue(LogKey,[]),
    set_log_dump_ts(LogKey,Now+DumpInterval),
    set_log_length(LogKey,0).

%% 日志队列
set_log_queue(LogKey,Queue)->
    erlang:put({log_queue,LogKey},Queue).

get_log_queue(LogKey)->
    erlang:get({log_queue,LogKey}).

add_log_queue(LogKey,Info)->
    set_log_queue(LogKey,[Info|get_log_queue(LogKey)]).

%% 入库时间
set_log_dump_ts(LogKey,TS)->
    erlang:put({log_dump_ts,LogKey},TS).

get_log_dump_ts(LogKey)->
    erlang:get({log_dump_ts,LogKey}).

%% 日志长度
add_log_length(LogKey)->
    set_log_length(LogKey,get_log_length(LogKey)+1).

set_log_length(LogKey,Length)->
    erlang:put({log_length,LogKey},Length).

get_log_length(LogKey)->
    erlang:get({log_length,LogKey}).

    ".

%%
%% Local Functions
%%

