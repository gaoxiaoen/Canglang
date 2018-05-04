%% @filename main_exec.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2015-12-15 
%% @doc 
%% 入口函数模块.


-module(main_exec).

-compile(export_all).

-include("common.hrl").
-include("common_server.hrl").

-define(main_exec_op_code_0,0).               %% 操作成功
-define(main_exec_op_code_100,100).           %% 表示参数出错，无法执行
-define(main_exec_op_code_101,101).           %% 节点参数出错
-define(main_exec_op_code_102,102).           %% 执行的动作参数出错
-define(main_exec_op_code_103,103).           %% 此命令无法执行
-define(main_exec_op_code_104,104).           %% 远程调用游戏节点执行命令出错

-define(main_exec_op_code_110,110).           %% 服务正在运行无法启动
-define(main_exec_op_code_111,111).           %% 数据库schema.DAT加载失败
-define(main_exec_op_code_112,112).           %% 数据表信息出错
-define(main_exec_op_code_113,113).           %% 数据表节点信息出错
-define(main_exec_op_code_114,114).           %% master_host 配置出错
-define(main_exec_op_code_115,115).           %% erlang_web_port 配置出错
-define(main_exec_op_code_116,116).           %% erlang_web_port 程序无法监听此端口
-define(main_exec_op_code_117,117).           %% gateway 配置出错
-define(main_exec_op_code_118,118).           %% gateway 程序无法监听此端口
-define(main_exec_op_code_119,119).           %% 日志节点无法连通

-define(main_exec_op_code_120,120).           %% 日志服务日志数据库配置出现重复配置
-define(main_exec_op_code_121,121).           %% 日志数据库连接失败

-define(main_exec_op_code_122,122).           %% 更新数据库操作出错，当前没有数据库文件
-define(main_exec_op_code_123,123).           %% 更新数据库操作出错，更载数据出错
-define(main_exec_op_code_124,124).           %% 更新数据库操作出错，执行结果出错
-define(main_exec_op_code_125,125).           %% 更新数据库操作出错，执行过程出错
-define(main_exec_op_code_126,126).           %% IP变化，执行撤机操作出错
%% 获取当前服务端目标
get_server_dir() ->
    {ok, [[ServerDir]]} = init:get_argument(server_dir),
    ServerDir.
%% 获取当前服务端config目录
get_config_dir() ->
    get_server_dir() ++ "/config".
%% 获取当前服务端setting目录
get_setting_file() ->
    {ok, [[SettingFile]]} = init:get_argument(setting_file),
    SettingFile.
%% 获取Database Dir 数据库目录
get_database_dir() ->
    {ok, [[DatabaseDir]]} = init:get_argument(database_dir),
    DatabaseDir.
%% 获取Mnesia数据库目录
get_mnesia_dir() ->
    {ok, [[MnesiaDir]]} = init:get_argument(mnesia_dir),
    MnesiaDir.
%% 获取服务端数据目录
get_server_data_dir() ->
    {ok, [[ServerDataDir]]} = init:get_argument(server_data_dir),
    ServerDataDir.
%% 获取当前服务端logs目录
get_log_dir() ->
    {ok, [[LogDir]]} = init:get_argument(log_dir),
    LogDir.

%% 记录启动程序状态
-spec 
do_status_log(StatusCode) -> ok when
    StatusCode :: integer().
do_status_log(StatusCode) ->
    LogDir = main_exec:get_log_dir(),
    LogFiePath = lists:concat([LogDir,"/","boot_status.log"]),
    file:write_file(LogFiePath, erlang:integer_to_binary(StatusCode), [write]),
    ok.

%% 外部操作入口命令
-spec start() -> ok | error.
start() ->
    case catch do_start() of
        ok ->
            io:format("EXIT_CODE:0", []);
        {error,OpCode} ->
            io:format("EXIT_CODE:~s", [erlang:integer_to_list(OpCode)])
    end.
do_start() ->
    case init:get_plain_arguments() of
        [RpcNode | Args] ->
            next;
        _ ->
            RpcNode = undefined,Args = undefined,
            erlang:throw({error,?main_exec_op_code_100})
    end,
    case string:tokens(RpcNode, "@") of
        [_NodeName, _NodeHost] ->
            next;
        _ ->
            erlang:throw({error,?main_exec_op_code_101})
    end,
    case erlang:length(Args) > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?main_exec_op_code_102})
    end,
    Node = erlang:list_to_atom(RpcNode),
    [Command | ParamList] = Args,
    do_command(Command,Node,ParamList),
    ok.

do_command("stop",Node,[]) ->
    case rpc:call(Node, ?MODULE, do_stop_server, []) of
        {badrpc, _Reason} ->
            erlang:throw({error,?main_exec_op_code_104});
        _Result ->
            next
    end,
    ok;
do_command("kick_role",Node,[]) ->
    case rpc:call(Node, ?MODULE, do_kick_role, []) of
        {badrpc, _Reason} ->
            erlang:throw({error,?main_exec_op_code_104});
        _Result ->
            next
    end,
    ok;
do_command("mnesia_backup",Node,[]) ->
    case rpc:call(Node, ?MODULE, do_mnesia_backup, []) of
        {badrpc, _Reason} ->
            erlang:throw({error,?main_exec_op_code_104});
        _Result ->
            next
    end,
    ok;
do_command("stop_logger",Node,[]) ->
    case rpc:call(Node, ?MODULE, do_stop_logger_server, []) of
        {badrpc, _Reason} ->
            erlang:throw({error,?main_exec_op_code_104});
        _Result ->
            next
    end,
    ok;
do_command("hot_update_beam",Node,ParamList) ->
    case rpc:call(Node, ?MODULE, do_hot_update_beam, [ParamList]) of
        {badrpc, _Reason} ->
            erlang:throw({error,?main_exec_op_code_104});
        _Result ->
            next
    end,
    ok;
do_command("hot_update_config",Node,ParamList) ->
    case rpc:call(Node, ?MODULE, do_hot_update_config, [ParamList]) of
        {badrpc, _Reason} ->
            erlang:throw({error,?main_exec_op_code_104});
        _Result ->
            next
    end,
    ok;
do_command("exec_fun",Node,ParamList) ->
    case erlang:length(ParamList) == 2 of
        true ->
            case rpc:call(Node, ?MODULE, do_exec_fun, [ParamList]) of
                {badrpc, _Reason} ->
                    erlang:throw({error,?main_exec_op_code_104});
                _Result ->
                    next
            end;
        _ ->
            erlang:throw({error,?main_exec_op_code_100})
    end,
    ok;
do_command("verify_server",Node,[]) ->
    do_verify_server(Node);
do_command("verify_logger_server",Node,[]) ->
    do_verify_logger_server(Node);
do_command("update_database",Node,ParamList) ->
    case erlang:length(ParamList) == 2 of
        true ->
            do_update_database(Node,ParamList);
        _ ->
            erlang:throw({error,?main_exec_op_code_100})
    end,
    ok;
do_command("lixiancheji",Node,[]) ->
    do_lixiancheji(Node);
do_command("gen_merge_data",Node,[]) ->
    gen_merge_data(Node);
do_command(_Command,_Node,_ParamList) ->
    erlang:throw({error,?main_exec_op_code_103}).

%% 检查当前服务器状态
do_verify_server(Node) ->
    %% 检查当前服务是否正在运行，不可以重复启动
    case net_adm:ping(Node) of
        pang ->
            next;
        _ ->
            erlang:throw({error,?main_exec_op_code_110})
    end,
    error_logger:add_report_handler(common_logger_h, ""),
    common_loglevel:set(3),
    common_config_dyn:reload(common),
    %% 检查当前数据库是否一致，通过dets:open_file加载schema.DAT文件，来检查数据
    SchemaDatFile = get_mnesia_dir() ++ "/schema.DAT",
    case filelib:is_file(SchemaDatFile) of
        true ->
            SchemaTab=db_schema_tab,
            case dets:open_file(SchemaTab, [{file, SchemaDatFile},{repair,false},{keypos, 2}]) of
                {ok, SchemaTab} ->
                    next;
                ErrSchemaTab ->
                    io:format("Mnesia File Error=~w", [ErrSchemaTab]),
                    erlang:throw({error,?main_exec_op_code_111})
            end,
            TableList = get_schema_tables(dets:first(SchemaTab),SchemaTab,[]),
            case check_mnesia_structure(TableList,SchemaTab,Node,ok) of
                ok ->
                    next;
                {error,OpCode,CheckTab,ErrMnesiaStructure} ->
                    io:format("OpCode=~w,CheckTab=~w,Error=~w", [OpCode,CheckTab,ErrMnesiaStructure]),
                    erlang:throw({error,OpCode})
            end,
            dets:close(SchemaTab),
            ok;
        _ ->
            next
    end,
    %% 检查主机配置是否正确
    [_,IP] = string:tokens(erlang:atom_to_list(Node), "@"),
    case common_config_dyn:find_common(master_host) of
        [MasterHost] ->
            case MasterHost of
                IP ->
                    next;
                _ ->
                    erlang:throw({error,?main_exec_op_code_114})
            end;
        _ ->
            erlang:throw({error,?main_exec_op_code_114})
    end,
    %% 检查服务web服务配置是否正确
    case common_config_dyn:find_common(erlang_web_port) of
        [{ErlangWebIP,ErlangWebPort}] ->
            case ErlangWebIP of
                IP ->
                    next;
                _ ->
                    erlang:throw({error,?main_exec_op_code_115})
            end,
            case gen_tcp:listen(ErlangWebPort, [binary, {packet, 0},{active, false}]) of
                {ok,ErlangWebSocket} ->
                    gen_tcp:close(ErlangWebSocket);
                {error,_} ->
                    erlang:throw({error,?main_exec_op_code_116})
            end,
            ok;
        _ ->
            erlang:throw({error,?main_exec_op_code_115})
    end,
    %% 检查网关内网ip和端口是否正确
    case common_config_dyn:find_common(gateway) of
        [[{IntranetIP,_ExternalIP,PortList}|_]] ->
            case IntranetIP of
                IP ->
                    next;
                _ ->
                    erlang:throw({error,?main_exec_op_code_117})
            end,
            lists:foreach(
              fun(GatewayPort) -> 
                      case gen_tcp:listen(GatewayPort, [binary, {packet, 0},{active, false}]) of
                            {ok,GatewaySocket} ->
                                gen_tcp:close(GatewaySocket);
                            {error,_} ->
                                erlang:throw({error,?main_exec_op_code_118})
                        end
              end, PortList),
            ok;
        _ ->
            erlang:throw({error,?main_exec_op_code_117})
    end,
    %% 检查日志节点是否可以连接
    case common_config_dyn:find_common(log_node) of
        [LogNode] ->
            case net_adm:ping(LogNode) of
                pong ->
                    next;
                _ ->
                    io:format("Log Node not connect =~w", [LogNode]),
                    erlang:throw({error,?main_exec_op_code_119})
            end;
        _ ->
            erlang:throw({error,?main_exec_op_code_119})
    end,
    ok.
%% 获取当前数据库存在的所有表
get_schema_tables('$end_of_table',_SchemaTab,TableList) ->
    TableList;
get_schema_tables(Table,SchemaTab,TableList) ->
    get_schema_tables(dets:next(SchemaTab, Table),SchemaTab,[Table|TableList]).

%% 检查数据表的节点名称是否合法
check_mnesia_structure([],_SchemaTab,_Node,Result) ->
    Result;
check_mnesia_structure([Tab | TableList],SchemaTab,Node,Result) ->
    case dets:lookup(SchemaTab, Tab) of
        [{schema, Tab, Def}] ->
            case lists:keyfind(disc_copies, 1, Def) of
                {disc_copies,[CheckNode]} ->
                    next;
                {disc_copies,[]} ->
                    case lists:keyfind(ram_copies, 1, Def) of
                        {ram_copies,[CheckNode]} ->
                            next;
                        {ram_copies,[]} ->
                            {disc_only_copies,[CheckNode]} = lists:keyfind(disc_only_copies, 1, Def)
                    end
            end,
            case CheckNode of
                Node ->
                    check_mnesia_structure(TableList,SchemaTab,Node,Result);
                _ ->
                    check_mnesia_structure([],SchemaTab,Node,{error,?main_exec_op_code_113, Tab, CheckNode})
            end;
        Error ->
            check_mnesia_structure([],SchemaTab,Node,{error,?main_exec_op_code_112, Tab,Error})
    end.

%% 启动游戏日志服务器检查
do_verify_logger_server(Node) ->
    %% 检查当前服务是否正在运行，不可以重复启动
    case net_adm:ping(Node) of
        pang ->
            next;
        _ ->
            erlang:throw({error,?main_exec_op_code_110})
    end,
    error_logger:add_report_handler(common_logger_h, ""),
    common_loglevel:set(3),
    common_config_dyn:reload(common),
    %% 检查主机配置是否正确
    [_,IP] = string:tokens(erlang:atom_to_list(Node), "@"),
    case common_config_dyn:find_common(master_host) of
        [MasterHost] ->
            case MasterHost of
                IP ->
                    next;
                _ ->
                    erlang:throw({error,?main_exec_op_code_114})
            end;
        _ ->
            erlang:throw({error,?main_exec_op_code_114})
    end,
    
    %% 检查数据库配置是否正常
    %% MysqlList = [{mysql_config,AgentId,ServerId,Localhost,User,Pwd,DB},....]
    MysqlList = lists:foldl(
                  fun(Data,AccMysqlList) ->
                          case Data of
                              {{mysql_config,AgentId,ServerId},{Localhost,User,Pwd,DB}} ->
                                  [{mysql_config,AgentId,ServerId,Localhost,User,Pwd,DB} | AccMysqlList];
                              _ ->
                                  AccMysqlList
                          end
                  end, [], common_config_dyn:list(common)),
    %% 是否有重复配置，即日志数据库名出现重复
    lists:foreach(
      fun({mysql_config,_,_,_,_,_,DB}) ->
              CheckMysqlList = lists:keydelete(DB,7,MysqlList),
              case lists:keyfind(DB,7,CheckMysqlList) of
                  false ->
                      next;
                  _ ->
                      io:format("repeat database name=~w", [DB]),
                      erlang:throw({error,?main_exec_op_code_120})
              end
      end, MysqlList),
    %% 检查数据库连接
    crypto:start(),
    application:start(emysql),
    ok=check_mysql_connect(MysqlList),
    ok.

check_mysql_connect([]) ->
    ok;
check_mysql_connect([{mysql_config,_AgentId,_ServerId,Host,User,Pwd,Database} = Info|MysqlList]) ->
    PoolName = check_pool,
    case catch emysql:add_pool(PoolName, 1, User, Pwd, Host, 3306, Database, utf8) of
        ok ->
            next;
        Error ->
            io:format("check mysql connect Info=~w,Error=~w", [Info,Error]),
            erlang:throw({error,?main_exec_op_code_121})
    end,
    SQL = erlang:list_to_binary("select table_name from information_schema.tables where table_schema='" ++ Database ++ "' limit 1;"),
    case emysql:execute(PoolName,SQL) of
        {result_packet,_,_,_,_} ->
            next;
        _ ->
            erlang:throw({error,?main_exec_op_code_121})
    end,
    emysql:remove_pool(PoolName),
    check_mysql_connect(MysqlList).

%% 数据库更新
do_update_database(Node,ParamList) ->
    [StrModule,StrMethod] = ParamList,
    Module = erlang:list_to_atom(StrModule),
    Method = erlang:list_to_atom(StrMethod),
    error_logger:add_report_handler(common_logger_h, ""),
    common_loglevel:set(3),
    common_config_dyn:reload(common),
    %% 检查当前数据库是否一致，通过dets:open_file加载schema.DAT文件，来检查数据
    SchemaDatFile = get_mnesia_dir() ++ "/schema.DAT",
    case filelib:is_file(SchemaDatFile) of
        true ->
            SchemaTab=db_schema_tab,
            case dets:open_file(SchemaTab, [{file, SchemaDatFile},{repair,false},{keypos, 2}]) of
                {ok, SchemaTab} ->
                    next;
                ErrSchemaTab ->
                    io:format("Mnesia File Error=~w", [ErrSchemaTab]),
                    erlang:throw({error,?main_exec_op_code_111})
            end,
            TableList = get_schema_tables(dets:first(SchemaTab),SchemaTab,[]),
            case check_mnesia_structure(TableList,SchemaTab,Node,ok) of
                ok ->
                    next;
                {error,OpCode,CheckTab,ErrMnesiaStructure} ->
                    io:format("OpCode=~w,CheckTab=~w,Error=~w", [OpCode,CheckTab,ErrMnesiaStructure]),
                    erlang:throw({error,OpCode})
            end,
            dets:close(SchemaTab),
            ok;
        _ ->
            erlang:throw({error,?main_exec_op_code_122})
    end,
    %% 执行数据库更新操作
    case db_mnesia:init() of
        ok ->
            next;
        _ ->
            erlang:throw({error,?main_exec_op_code_123})
    end,
    try
        Result=erlang:apply(Module, Method, []),
        io:format("do update database.fun=~w:~w(),Result=~w",[Module,Method,Result]),
        case Result of
            ok ->
                next;
            _ ->
                erlang:throw({error,?main_exec_op_code_124})
        end
    catch 
        ErrType:ErrReason ->
            io:format("do update database.fun=~w:~w(),ErrType=~w,ErrReason=~w", [Module,Method,ErrType,ErrReason]),
            erlang:throw({error,?main_exec_op_code_125})
    end,
    db_api:dump_log(),
    ok.

%% 更新数据库,主要是更新Mnesia数据库的schema结构
do_lixiancheji(Node) ->
    error_logger:add_report_handler(common_logger_h, ""),
    common_loglevel:set(3),
    common_config_dyn:reload(common),
    %% 检查主机配置是否正确
    [_,IP] = string:tokens(erlang:atom_to_list(Node), "@"),
    case common_config_dyn:find_common(master_host) of
        [MasterHost] ->
            case MasterHost of
                IP ->
                    next;
                _ ->
                    erlang:throw({error,?main_exec_op_code_114})
            end;
        _ ->
            erlang:throw({error,?main_exec_op_code_114})
    end,
    MnesiaDir = mnesia:system_info(directory),
    SchemaDatFile = MnesiaDir++"/schema.dat",
    case filelib:is_file(SchemaDatFile) of
        true ->
            os:cmd(lists:flatten(lists:concat(["rm -rf ", MnesiaDir])));
        _ ->
            next
    end,
    db_mnesia:init(),
    db_api:dump_log(),
    db_mnesia:stop(),
    TargetMnesiaDIR = main_exec:get_mnesia_dir(),
    R = os:cmd(lists:flatten(lists:concat(["mv -f ", MnesiaDir, "/schema.DAT ", TargetMnesiaDIR]))),
    case R of
        [] ->
            os:cmd(lists:flatten(lists:concat(["rm -rf ", MnesiaDir]))),
            io:format("delete lixiancheji dir ok.");
        _ ->
            io:format("delete lixiancheji dir error=~s", [R]),
            erlang:throw({error,?main_exec_op_code_126})
    end,
    ok.

%% 获取合服的数据
-spec gen_merge_data(Node) -> ok when Node :: atom().
gen_merge_data(Node) ->
    error_logger:add_report_handler(common_logger_h, ""),
    common_loglevel:set(3),
    common_config_dyn:reload(common),
    %% 检查主机配置是否正确
    [_,IP] = string:tokens(erlang:atom_to_list(Node), "@"),
    case common_config_dyn:find_common(master_host) of
        [MasterHost] ->
            case MasterHost of
                IP ->
                    next;
                _ ->
                    erlang:throw({error,?main_exec_op_code_114})
            end;
        _ ->
            erlang:throw({error,?main_exec_op_code_114})
    end,
    db_mnesia:init(),
    %% 执行删号操作
    delete_account:do(),
    %% 生成数据备份文件
    db_api:dump_log(), %% 同步操作，不需要确认是否回写完成
    [AgentId] = common_config_dyn:find_common(agent_id),
    [ServerId] = common_config_dyn:find_common(server_id),
    BackFileName = lists:concat([AgentId, "_", ServerId, ".merge"]),
    DatabaseDir = main_exec:get_database_dir(),
    File = lists:concat([DatabaseDir,"/merge/",BackFileName]),
    case filelib:is_file(File) of
        true ->
            os:cmd(lists:flatten(lists:concat(["mv -f ", File])));
        _ ->
            next
    end,
    Dir = lists:concat([DatabaseDir,"/merge"]),
    case filelib:is_dir(Dir) of
        true ->
            next;
        _ ->
            file:make_dir(Dir)
    end,
    ok = db_api:backup(File),
    db_mnesia:stop(),
    ok.

%% 关闭游戏服务器，停止游戏服务器
do_stop_server() ->
    common_reloader:stop_game(),
    init:stop(),
    ?ERROR_MSG("################################do stop server.",[]),
    ok.

%% 踢所有玩家下线，并关闭服务器入口，游戏服继续运行
do_kick_role() ->
    common_reloader:stop_game_kick_role(),
    ?ERROR_MSG("################################do kick role.",[]),
    ok.

%% 关闭游戏日志服务节点
do_stop_logger_server() ->
    init:stop(),
    ?ERROR_MSG("################################do stop logger server.",[]),
    ok.

%% 数据库备份
do_mnesia_backup() ->
    {{Y, M, D}, {H, _, _}} = erlang:localtime(),
    [GameName] = common_config_dyn:find_common(game_name),
    [AgentName] = common_config_dyn:find(common, agent_name),
    [ServerName] = common_config_dyn:find(common, server_name),
    BackFileName = lists:concat([Y, M, D, ".", H]),
    DatabaseDir = main_exec:get_database_dir(),
    File = lists:concat([DatabaseDir,"/backup/",GameName,"_", AgentName, "_", ServerName,"/", BackFileName]),
    Dir = lists:concat([DatabaseDir,"/backup/",GameName,"_", AgentName, "_", ServerName]),
    case filelib:is_dir(Dir) of
        true ->
            next;
        _ ->
            file:make_dir(Dir)
    end,
    ok = db_api:backup(File),
    TarFileName = lists:concat([AgentName, "_", ServerName,"_",Y, M, D, ".", H]),
    os:cmd(lists:concat(["cd ",DatabaseDir,"/backup/",GameName,"_", AgentName, "_", ServerName,"/; tar cfz ", TarFileName, ".tar.gz ", BackFileName, "; rm -f ", BackFileName])),
    ?ERROR_MSG("################################do mnesia backup.File=~s",[File]),
    ok.



%% 热更新beam文件
do_hot_update_beam([]) ->
    ok;
do_hot_update_beam([StrModuleName | ParamList]) ->
    ModuleName = erlang:list_to_atom(StrModuleName),
    c:l(ModuleName),
    ?ERROR_MSG("################################do hot update beam.file=~w.beam",[ModuleName]),
    do_hot_update_beam(ParamList).
%% 热更新config文件
do_hot_update_config([]) ->
    ok;
do_hot_update_config([StrConfigName | ParamList]) ->
    ConfigName = erlang:list_to_atom(StrConfigName),
    common_config_dyn:reload(ConfigName),
    ?ERROR_MSG("################################do hot update config.file=~w.config",[ConfigName]),
    do_hot_update_config(ParamList).
%% 执行方法
do_exec_fun(ParamList) ->
    [StrModule,StrMethod] = ParamList,
    Module = erlang:list_to_atom(StrModule),
    Method = erlang:list_to_atom(StrMethod),
    try
        Result=erlang:apply(Module, Method, []),
        ?ERROR_MSG("################################do hot exec fun.fun=~w:~w(),Result=~w",[Module,Method,Result])
    catch 
        ErrType:ErrReason ->
            ?ERROR_MSG("################################do hot exec fun.fun=~w:~w(),ErrType=~w,ErrReason=~w", [Module,Method,ErrType,ErrReason])
    end,
    ok.
