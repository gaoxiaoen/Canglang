%% @filename merge_misc.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-02-01 
%% @doc 
%% 合服工具模块.

-module(merge_misc).

-include("common.hrl").
-include("merge.hrl").

-export([
         get_merge_log_name/0,
         get_merge_master_name/0,
         get_merge_slave_name/1,
         get_server_data_file/1,
         get_merge_table_name/2,
         get_merge_table_temp_name/1,
         table_info/0,
         do_statistics/1,
         do_migration_record/2,
         get_real_name/2
        ]).

%% 合服日志进程名
-spec get_merge_log_name() -> PName when PName :: atom().
get_merge_log_name() ->
    merge_log_server.

%% 合服主进程名
-spec get_merge_master_name() -> PName when
          PName :: atom().
get_merge_master_name() ->
    merge_master.

%% 合服副进程名
-spec get_merge_slave_name(ServerId) -> PName when 
          ServerId :: integer(),
          PName :: atom().
get_merge_slave_name(ServerId) ->
    erlang:list_to_atom(lists:concat(["merge_slave_", ServerId])).

%% 合服表名
-spec get_merge_table_name(Tab, ServerId) -> NewTab when
          Tab :: atom(),
          ServerId :: integer(),
          NewTab :: atom().
get_merge_table_name(Tab, ServerId) ->
    common_tool:list_to_atom(lists:concat([Tab, "_", ServerId])).

%% 全服临时表名
-spec get_merge_table_temp_name(Tab) -> NewTab when
          Tab :: atom(),
          NewTab :: atom().
get_merge_table_temp_name(Tab) ->
    common_tool:list_to_atom(lists:concat([Tab, "_tmp"])).

%% 游戏名称后缀
-spec 
get_real_name(InName,ServerId) -> NewName when
    InName :: string(),
    ServerId :: integer(),
    NewName :: string().
get_real_name(InName,ServerId) ->
    [KeyNameSeparate] = common_config_dyn:find(etc,key_name_separate),
    [KeyNameRegular] = common_config_dyn:find(etc,key_name_regular),
    common_tool:to_binary(common_lang:get_format_lang_resources(KeyNameRegular, [InName,KeyNameSeparate,ServerId])).

%% 获取当前数据库所有表信息
%% {tablename,copies_type}
-spec 
table_info() -> InfoList when 
    InfoList :: [] | [{Tab,CopiesType,Size},...],
    Tab :: atom(),
    CopiesType :: ram_copies | disc_copies | disc_only_copies,
    Size :: integer().
table_info() ->
    TableList = mnesia:system_info(local_tables),
    SortTableList = lists:reverse(lists:sort(TableList)),
    table_info(SortTableList,[]).
table_info([],InfoList) -> InfoList;
table_info([Tab|TableList],InfoList) ->
    TabSize = mnesia:table_info(Tab,size),
    case mnesia:table_info(Tab,ram_copies) of
        [] ->
            case mnesia:table_info(Tab,disc_copies) of
                [] ->
                    CopiesType = disc_only_copies;
                _ ->
                    CopiesType = disc_copies
            end;
        _ ->
            CopiesType = ram_copies
    end,
    table_info(TableList,[{Tab,CopiesType,TabSize}|InfoList]).

%% 统计信息输出
-spec do_statistics(ServerId) -> ok when ServerId :: integer().
do_statistics(ServerId) ->
    SortTableList = get_statistics_tables(ServerId),
    InfoList = do_statistics(SortTableList,[]),
    case erlang:whereis(get_merge_log_name()) of
        LogPId when erlang:is_pid(LogPId) ->
            LogPId ! {statistics,{ServerId,InfoList}};
        _ ->
            ?MERGE_LOG("statistics server id=[~w] table info=~w",[ServerId,InfoList])
    end,
    ok.
do_statistics([],InfoList) -> InfoList;
do_statistics([{SrcTab,Tab} | TableList],InfoList) -> 
    TabSize = mnesia:table_info(Tab,size),
    do_statistics(TableList,[{SrcTab,Tab,TabSize}|InfoList]).
%% 获取统计的表列表
get_statistics_tables(ServerId) ->
    TabList = cfg_mnesia:find(tab_list),
    AllTableList = [T || #r_tab{table_name=T} <- TabList],
    TabFragList = lists:foldl(fun(T,AccTabList) -> db_misc:get_all_tab(T) ++ AccTabList end, [], AllTableList),
    case ServerId > 0 of
        true ->
            ServerTabList = [{T,merge_misc:get_merge_table_name(T, ServerId)} || T <- TabFragList];
        _ ->
            ServerTabList = [{T,T} || T <- TabFragList]
    end,
    LocalTableList = mnesia:system_info(local_tables),
    lists:sort(fun({_A1,A2},{_B1,B2}) -> 
                       A2 > B2 
               end,[ {T1,T2} || {T1,T2} <- ServerTabList, 
                                lists:member(T2, LocalTableList) == true]).
    
%% 根据服Id获取对应的数据库文件
-spec 
get_server_data_file(ServerId) ->  MergeFile when
    ServerId :: integer(),
    MergeFile :: string().
get_server_data_file(ServerId) -> 
    %% 合服数据库文件存放目录:/data/database/merge/[AgentId]_[ServerId].merge
    DatabaseDir = main_exec:get_database_dir(),
    [AgentId] = common_config_dyn:find_common(agent_id),
    lists:concat([DatabaseDir,"/merge/",AgentId, "_", ServerId, ".merge"]).

%% 合并记录，表数据合并
-spec
do_migration_record(SrcTabName,TargetTabName) -> ok when
    SrcTabName :: atom(),
    TargetTabName :: atom().
do_migration_record(SrcTabName,TargetTabName) ->
    case mnesia:dirty_first(SrcTabName) of
        '$end_of_table' ->
            ok;
        Key ->
            [KeyRecord] = mnesia:dirty_read(SrcTabName,Key),
            mnesia:dirty_write(TargetTabName, KeyRecord),
            do_merge_record2(Key,SrcTabName,TargetTabName)
    end.
do_merge_record2(Key,SrcTabName,TargetTabName) ->
    case mnesia:dirty_next(SrcTabName,Key) of
        '$end_of_table' ->
            ok;
        NextKey -> 
            [NextKeyRecord] = mnesia:dirty_read(SrcTabName,NextKey),
            mnesia:dirty_write(TargetTabName, NextKeyRecord),
            do_merge_record2(NextKey,SrcTabName,TargetTabName)
    end.