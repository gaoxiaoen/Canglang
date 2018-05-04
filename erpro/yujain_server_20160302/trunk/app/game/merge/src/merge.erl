%% @filename merge.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-01-19
%% @doc 
%% 合服处理模块.
%% 合服操作：【分表、活跃数据、非活跃数据】不同存储的数据的合并
%% 步骤
%% 1.可以合服的数据必须是同一个平台的数据，【common.config.agent_id必须一样】
%% 2.备份数据，【配置整个数据库目录文件】
%% 3.针对每要合服的数据，进行最后更新操作，【更新代码，更新数据库结构，更新数据】
%% 4.执行删号，执行 sh run.sh del_die_account
%% 5.生成合服数据，执行 sh run.sh gen_merge_data 【生成的合服数据文件为[agent_id]_[server_id].merge】
%% 6.配置合服规则，修复 config/merge.config
%% 7.执行合服操作【必须是在新服的配置环境下执行】
%% 8.新服配置，并启动新服
%% 9.测试

%% 合服程序设计
%% 1.主进程合服的主数据库，使用disc_copies
%% 2.子进程加载要合服的数据，使用ram_copies，加载数据时，可设置加载表、每次加载表数量
%% 3.两两合并相应的数据，处理完一个服的数据之后，再加载另一个服的数据，同时删除已经处理完的服数据【减少内存】
%% 4.操作结果，持久化数据
%% 5.输出操作日志


-module(merge).

-include("common.hrl").
-include("merge.hrl").

-export([
         start/0
        ]).

%% 执行合服
-spec start() -> OpCode when OpCode :: 0 | integer(). 
start() ->
    case catch do_start() of
        ok ->
            io:format("EXIT_CODE:0", []);
        {error,OpCode} ->
            ?MERGE_LOG("merge error, OpCode=~w",[OpCode]),
            io:format("EXIT_CODE:~s", [erlang:integer_to_list(OpCode)])
    end.
do_start() ->
    common_config_dyn:reload(common),
    common_config_dyn:reload(merge),
    %% 合服日志服务初始化
    init_merge_log(),
    %% 检查合服配置文件
    ok = check_merge_config(),
    %% 启动主程序
    erlang:register(merge_misc:get_merge_master_name(), erlang:self()),
    %% 初始化主数据库【用于恢复数据】
    ok = init_master_mnesia(),
    %% 初始始化临时主数据库【用于合并数据】
    ok = init_master_temp_mnesia(),
    %% 根据合服配置执行合服
    %% 加载一个服数据，并且合并数据到主数据库，删除已经处理完成的数据，循环执行此操作
    [ServerIdList] = common_config_dyn:find(merge, server_id_list),
    SortServerIdList = lists:sort(ServerIdList),
    ok = do_start_slave(SortServerIdList),
    %% 昨时数据库表数据转入主数据库
    ok = migration_master_mnesia(),
    %% 删除临时主数据库
    ok = delete_master_temp_mnesia(),
    %% 打印日志
    merge_misc:do_statistics(0),
    receive
        ok ->
            next
    end,
    %% 数据合并完成
    ok = done_master_mnesia(),
    ok.

%% 创建子进程，加载数据，执行合并，删除进程
do_start_slave([]) -> ok;
do_start_slave([ServerId | ServerIdList]) ->
    merge_slave_server:start(ServerId,erlang:self()),
    receive
        ok ->
            timer:sleep(1000);
        {error,OpCode} ->
            erlang:throw({error,OpCode});
        Error ->
            ?MERGE_LOG("merge data error=~w",[Error]),
            erlang:throw({error,?MERGE_OP_CODE_903})
    end,
    do_start_slave(ServerIdList).

%% 合服配置文件检查
check_merge_config() ->
    [AgentName] = common_config_dyn:find_common(agent_name),
    %% 代理名称配置
    [PAgentName] = common_config_dyn:find(merge, agent_name),
    case PAgentName of
        AgentName ->
            next;
        _ ->
            erlang:throw({error,?MERGE_OP_CODE_900})
    end,
    %% 合服数据文件检查
    case common_config_dyn:find(merge, server_id_list) of
        [ServerIdList] ->
            case erlang:length(ServerIdList) > 0 of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?MERGE_OP_CODE_902})
            end;
        _ ->
            ServerIdList = [],
            erlang:throw({error,?MERGE_OP_CODE_902})
    end,
    lists:foreach(
      fun(ServerId) ->
             MergeFileName = merge_misc:get_server_data_file(ServerId), 
             case filelib:is_file(MergeFileName) of
                true ->
                    next;
                 _ ->
                    ?MERGE_LOG("data file not found.file=~w",[MergeFileName]),
                    erlang:throw({error,?MERGE_OP_CODE_901})
             end
      end, ServerIdList),
    ok.

%% 创建master数据库
%% 把表类型 disc_only_copies to disc_copies，提高数据操作速度
%% 合服完成需要转换一下
-spec init_master_mnesia() -> ok.
init_master_mnesia() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:change_table_copy_type(schema, node(), disc_copies),
    mnesia:wait_for_tables(mnesia:system_info(local_tables), infinity),

    do_create_table(),
    mnesia:dump_log(),
    ok.

%% 完成合服操作，数据库回写数据，并转换表类型
-spec done_master_mnesia() -> ok. 
done_master_mnesia() ->
    do_copy_type(),
    mnesia:dump_log(),
    ok.

%% 创建表格需要根据是分表数的创建
-spec do_create_table() -> ok.
do_create_table() ->
    TabList=cfg_mnesia:find(tab_list),
    do_create_table(TabList).
do_create_table([]) -> ok;
do_create_table([ #r_tab{copies_type=ram_copies} | TabList]) ->
    do_create_table(TabList);
do_create_table([ TabInfo | TabList]) ->
    #r_tab{table_name=TabName,
           type=Type,
           record_name=RecordName,
           record_fields= RecordFields,
           index_list=Intlist} = TabInfo,
    TabDef = [{disc_copies, [node()]},
              {type, Type},
              {record_name, RecordName},
              {attributes, RecordFields},
              {local_content, true},
              {index, Intlist}],
    TabNameList = db_misc:get_all_tab(TabName),
    lists:foreach(fun(NewTabName) -> mnesia:create_table(NewTabName, TabDef) end, TabNameList),
    do_create_table(TabList).    

%% 把master数据库表类型转换为正确的
%% disc_copies to disc_only_copies
do_copy_type() ->
    case cfg_mnesia:is_inactive_storage() of
        true ->
            TabList=cfg_mnesia:find(tab_list),
            do_copy_type(TabList);
        _ ->
            ok
    end.
do_copy_type([]) -> ok;
do_copy_type([#r_tab{table_name=TabName} | TabList]) ->
    case cfg_mnesia:is_tab_inactive(TabName) of
        true ->
            TabNameList = db_misc:get_inactive_tab(TabName),
            ok = do_copy_type2(TabNameList),
            ok;
        _ ->
            next
    end,
    do_copy_type(TabList).
do_copy_type2([]) -> ok;
do_copy_type2([TabName | TabNameList]) ->
    case mnesia:change_table_copy_type(TabName, erlang:node(), disc_only_copies) of
        {atomic, ok} ->
            next;
        {aborted, R} ->
            ?MERGE_LOG("change mnesia table copy type fail.TabName=~w,Error=~w",[TabName,R]),
            erlang:throw({error,?MERGE_OP_CODE_906})
    end,
    do_copy_type2(TabNameList).

%% 初始始化临时主数据库
-spec init_master_temp_mnesia() -> ok.
init_master_temp_mnesia() -> 
    TabList=cfg_mnesia:find(tab_list),
    init_master_temp_mnesia(TabList).
init_master_temp_mnesia([]) -> ok;
init_master_temp_mnesia([ #r_tab{copies_type=ram_copies} | TabList]) ->
    init_master_temp_mnesia(TabList);
init_master_temp_mnesia([ TabInfo | TabList]) ->
    #r_tab{table_name=TabName,
           type=Type,
           record_name=RecordName,
           record_fields= RecordFields,
           index_list=Intlist} = TabInfo,
    TabDef = [{disc_copies, [node()]},
              {type, Type},
              {record_name, RecordName},
              {attributes, RecordFields},
              {local_content, true},
              {index, Intlist}],
    TabNameList = db_misc:get_all_tab(TabName),
    lists:foreach(
      fun(NewTabName) -> 
              Tab = merge_misc:get_merge_table_temp_name(NewTabName),
              mnesia:create_table(Tab, TabDef) 
      end, TabNameList),
    init_master_temp_mnesia(TabList).

%% 删除临时主数据库
-spec delete_master_temp_mnesia() -> ok.
delete_master_temp_mnesia() ->
    TabList=cfg_mnesia:find(tab_list),
    delete_master_temp_mnesia(TabList).
delete_master_temp_mnesia([]) -> ok;
delete_master_temp_mnesia([#r_tab{copies_type=ram_copies}|TabList]) ->
    delete_master_temp_mnesia(TabList);
delete_master_temp_mnesia([#r_tab{table_name=TabName}|TabList]) ->
    TabNameList = db_misc:get_all_tab(TabName),
    delete_master_temp_mnesia2(TabNameList),
    delete_master_temp_mnesia(TabList).
delete_master_temp_mnesia2([]) -> ok;
delete_master_temp_mnesia2([TabName | TabNameList]) ->
    TempTabName = merge_misc:get_merge_table_temp_name(TabName),
    case mnesia:delete_table(TempTabName) of
        {atomic, _} ->
            next;
        {aborted, Error} ->
            ?MERGE_LOG("delete master mnesia table error.TabName=~w,Error=~w", [TabName,Error]),
            erlang:throw({error,?MERGE_OP_CODE_905})
    end,
    delete_master_temp_mnesia2(TabNameList).

%% 昨时数据库表数据转入主数据库
-spec migration_master_mnesia() -> ok.
migration_master_mnesia() ->
    TabList=cfg_mnesia:find(tab_list),
    migration_master_mnesia(TabList).
migration_master_mnesia([]) -> ok;
migration_master_mnesia([#r_tab{copies_type=ram_copies}|TabList]) ->
    migration_master_mnesia(TabList);
migration_master_mnesia([#r_tab{table_name=TabName}|TabList]) ->
    TabNameList = db_misc:get_all_tab(TabName),
    migration_master_mnesia2(TabNameList),
    migration_master_mnesia(TabList).
migration_master_mnesia2([]) -> ok;
migration_master_mnesia2([TabName|TabNameList]) ->
    TempTabName = merge_misc:get_merge_table_temp_name(TabName),
    merge_misc:do_migration_record(TempTabName, TabName),
    migration_master_mnesia2(TabNameList).
    
%% 初始合服操作日志文件
-spec init_merge_log() -> ok.
init_merge_log() ->
    LogDir = main_exec:get_log_dir(),
    [GameName] = common_config_dyn:find_common(game_name),
    LogFile = lists:concat([LogDir,"/",GameName,"_","merge.log"]),
    case filelib:is_file(LogFile) of
        true ->
            next;
        _ ->
            os:cmd(lists:flatten(lists:concat(["echo '' > ", LogFile])))
    end,
    merge_log_server:start(LogFile),
    ok.