%% @filename db_mnesia.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-01-11 
%% @doc 
%% 游戏数据库模块.

-module(db_mnesia).

-include("db.hrl").

-export([
         init/0,
         stop/0,
         do_create_table/0
        ]).

%% 初始化Mnesia数据库
init() ->
    ok = do_init(),
    ok = do_verify(),
    do_wait_for_tables(),
    ok.
%% 停止Mnesia数据库
stop() ->
    mnesia:stop().
    

%% 初始Mnesia数据库,根据启动参数获取数据库目录，并创建schema.DAT文件
-spec do_init() -> ok | Error when Error :: atom().
do_init() ->
    SchemaDatFile = get_mnesia_dir() ++ "/schema.DAT",
    ExistSchemaDAT = filelib:is_file(SchemaDatFile),
    case ExistSchemaDAT of
        true ->
            io:format("~nmnesia create schema no.~n", []),
            next;
        _ ->
            io:format("~nmnesia create schema yes.~n", []),
            mnesia:create_schema([node()])
    end,
    ok = application:start(mnesia, permanent),
    case ExistSchemaDAT of
        false ->
            mnesia:dump_log();
        _ ->
            next
    end,
    ok.
%% 验证数据库是否正常启动
-spec do_verify() -> ok | Error when Error :: atom().
do_verify() ->
    case mnesia:system_info(is_running) of
        yes -> 
            ok;
        no -> 
            throw({error, mnesia_not_running})
    end,
    MnesiaDir = get_mnesia_dir() ++ "/",
    case filelib:ensure_dir(MnesiaDir) of
        {error, Reason} ->
            throw({error, {cannot_create_mnesia_dir, MnesiaDir, Reason}});
        ok -> 
            ok
    end.

%% 获取当前Mnesia数据库目录路径
get_mnesia_dir() -> 
    mnesia:system_info(directory).

%% 加载表数据
-spec do_wait_for_tables() -> ok | Error when Error :: atom().
do_wait_for_tables() ->
    ok = do_create_table(),
    mnesia:wait_for_tables(mnesia:system_info(local_tables), infinity),
    ok.

%% 创建Mnesia表，系统每一次启动都执行一次，可以创建新增的表格
%% 创建表格需要根据是分表数的创建
-spec do_create_table() -> ok.
do_create_table() ->
    TabList=cfg_mnesia:find(tab_list),
    do_create_table(TabList).

do_create_table([]) -> ok;
do_create_table([ TabInfo | TabList]) ->
    #r_tab{table_name=TabName,
           copies_type=CopiesType,
           type=Type,
           record_name=RecordName,
           record_fields= RecordFields,
           index_list=Intlist} = TabInfo,
    TabDef = [{CopiesType, [node()]},
              {type, Type},
              {record_name, RecordName},
              {attributes, RecordFields},
              {local_content, true},
              {index, Intlist}],
    TabNameList = db_misc:get_all_tab(TabName),
    lists:foreach(fun(NewTabName) -> mnesia:create_table(NewTabName, TabDef) end, TabNameList),
    do_create_table(TabList).    
