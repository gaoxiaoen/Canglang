%%----------------------------------------------------
%% @doc 合服主逻辑模块,上下文
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_context).

-behaviour(gen_server).

-export([
        start_link/0
        ,start/0
        ,start/1
        ,truncate/0
        ,truncate/1
        ,update_srv_id/2
        ,merge_finish/1
        ,all_finish/0
        ,delete_expire/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("merge.hrl").

-record(state, {
        process_list = []
    }
).

%%----------------------------------------------------
%% 接口
%%----------------------------------------------------
%% 启动进程
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% 启动合服过程
start() ->
    gen_server:cast({global, ?MODULE}, merge_begin).
start(TableName) ->
    gen_server:cast({global, ?MODULE}, {merge_begin, TableName}).

%% 完成
merge_finish(Process) ->
    gen_server:cast({global, ?MODULE}, {merge_finish, Process}).

%% 清档
truncate() ->
    gen_server:cast({global, ?MODULE}, truncate).
truncate(TableName) ->
    gen_server:cast({global, ?MODULE}, {truncate, TableName}).

%% 纠正SrvId
update_srv_id(OldSrvId, NewSrvId) ->
    gen_server:cast({global, ?MODULE}, {update_srv_id, OldSrvId, NewSrvId}).

%% 全部完成
all_finish() ->
    gen_server:cast({global, ?MODULE}, all_finish).

%%----------------------------------------------------
%% gen_server函数
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    %% process_flag(trap_exit, true),
    erlang:register(?MODULE, self()),
    ets:new(ets_merge_role_name_temp, [set, named_table, public, {keypos, #merge_role_name.name}]),
    ets:new(ets_merge_role_name, [set, named_table, public, {keypos, #merge_role_name.key}]),
    {ok, List} = merge_data:tables(),
    ProList = [Process || #merge_table{process = Process} <- List],
    NewProList = sets:to_list(sets:from_list(ProList)), %% 去重
    ?DEBUG("ProList:~w", [NewProList]),
    start_process(NewProList),
    ?INFO("[~w] 启动完成", [?MODULE]),
    case init:get_plain_arguments() of
        ["immediacy"] ->
            gen_server:cast({global, ?MODULE}, merge_begin);
        _Other ->
            ?DEBUG("没有直接运行:~s", [_Other])
    end,
    {ok, #state{process_list = NewProList}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% master库开始处理
handle_cast(merge_begin, State = #state{process_list = ProList}) ->
    case merge_checker:check_all() of
        ok ->
            ?INFO("正在全局性数据分析"),
            ok = merge_analyse:do([role_name, guild_name]),
            ?INFO("完成全局性数据分析"),
            start_merge(ProList);
        {false, Reason} ->
            catch ?INFO("检查有误"),
            catch ?INFO("检查有误:~w", [Reason]),
            catch ?INFO("检查有误:~s", [Reason])
    end,
    {noreply, State};

handle_cast({merge_begin, TableName}, State) ->
    {ok, List} = merge_data:tables(),
    case lists:keyfind(util:term_to_bitstring(TableName), #merge_table.table, List) of
        false -> ?INFO("没找到该表信息");
        Table ->
            Sql = util:fbin(<<"truncate ~w">>, [TableName]),
            merge_db:execute(?merge_target, Sql, []),
            SrvList = merge_util:all_server(),
            tables_merge_srv(Table, SrvList),
            ?INFO("转换完成:~w", [TableName])
    end,
    {noreply, State};

%% 子进程完成
handle_cast({merge_finish, Process}, State = #state{process_list = ProList}) ->
    ?INFO("进程~w完成处理", [Process]),
    case ProList -- [Process] of
        [] ->
            ?INFO("全部进程已经处理完成"),
            all_finish(),
            {noreply, State#state{process_list = []}};
        NewProList ->
            ?INFO("还有进程还没处理完成:~w", [NewProList]),
            {noreply, State#state{process_list = NewProList}}
    end;

%%  清档 
handle_cast(truncate, State) ->
    do_truncate(),
    {noreply, State};
handle_cast({truncate, TableName}, State) ->
    Sql = util:fbin(<<"truncate ~w">>, [TableName]),
    merge_db:execute(?merge_target, Sql, []),
    ?INFO("删除成功:~w", [TableName]),
    {noreply, State};

%%  纠正SrvId
handle_cast({update_srv_id, OldSrvId, NewSrvId}, State) ->
    do_update_srv_id(OldSrvId, NewSrvId),
    {noreply, State};

%%  全部完成
handle_cast(all_finish, State) ->
    ?INFO("开始删除过期数据..."),
    {ok, List} = merge_data:tables(),
    ok = delete_expire(List),
    ?INFO("完成删除过期数据..."),
    ?INFO("修改英文重名角色名..."),
    ok = update_english_role_name(),
    ?INFO("完成英文重名角色名"),
    Sql = "insert into sys_env(name, val) values (~s, ~s)",
    case merge_db:execute(?merge_target, Sql, [merge_time, util:unixtime()]) of
        {ok, _} -> 
            ?INFO("插入合服时间成功"),
            erlang:halt(),
            ok;
        {error, Reason} ->
            ?INFO("插入合服时间有误:~w", [Reason]),
            ignore
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------
%% 清档
do_truncate() ->
    {ok, List} = merge_data:tables(),
    do_truncate(List).
do_truncate([]) -> 
    ?INFO("清档完成"),
    ok;
do_truncate([Table | T]) ->
    merge_dao_behaviour:truncate(Table),
    do_truncate(T).

start_process([]) -> ok;
start_process([Process | T]) ->
    merge_srv:start_link(Process),
    start_process(T).

start_merge([]) -> ok;
start_merge([Process | T]) ->
    merge_srv:start_merge(Process),
    start_merge(T).

%% 纠正SrvId
do_update_srv_id(OldSrvId, NewSrvId) ->
    ?INFO("正在修正数据..."),
    {ok, List} = merge_data:tables(),
    do_update_srv_id(List, OldSrvId, NewSrvId).
do_update_srv_id([], _OldSrvId, _NewSrvId) ->
    ?INFO("完成修正数据");
do_update_srv_id([Table = #merge_table{dao = DaoMod} | T], OldSrvId, NewSrvId) ->
    case lists:keyfind(exports, 1, DaoMod:module_info()) of
        false -> 
            ?INFO("该模块没有方法[~w]", [DaoMod]),
            do_update_srv_id(T, OldSrvId, NewSrvId);
        {exports, FunList} ->
            case [Fun || Fun = {update_srv_id, 1} <- FunList] of
                [{update_srv_id, 1}] ->
                    ?INFO("处理模块:~w", [DaoMod]),
                    merge_dao_behaviour:update_srv_id(Table#merge_table{old_srv_id = OldSrvId, new_srv_id = NewSrvId, server = #merge_server{data_source = ?merge_target}}),
                    do_update_srv_id(T, OldSrvId, NewSrvId);
                _ -> 
                    do_update_srv_id(T, OldSrvId, NewSrvId)
            end
    end.

%% 删除过期数据
delete_expire([]) -> 
    ?INFO("删除role表过期数据..."),
    case merge_util:delete_expire(role, undefined) of
        ok -> ok;
        {error, Reason} ->
            ?INFO("删除role表过期数据出错了:~w", [Reason]),
            catch ?INFO("删除role表过期数据出错了:~s", [Reason]),
            {error, Reason}
    end;
delete_expire([Table = #merge_table{table = TableName, dao = DaoMod}| T]) ->
    case lists:keyfind(exports, 1, DaoMod:module_info()) of
        false -> 
            ?INFO("该模块没有方法[~w]", [DaoMod]),
            delete_expire(T);
        {exports, FunList} ->
            case [Fun || Fun = {delete_expire, 1} <- FunList] of
                [{delete_expire, 1}] ->
                    ?INFO("删除~s表过期数据...", [TableName]),
                    merge_dao_behaviour:delete_expire(Table),
                    delete_expire(T);
                _ -> 
                    delete_expire(T)
            end
    end.

tables_merge_srv(_, []) -> ok;
tables_merge_srv(Table, [Server| T]) ->
    merge_dao_behaviour:merge(Table#merge_table{server = Server}),
    tables_merge_srv(Table, T).

%% 修改英文重名问题
update_english_role_name() ->
    Sql = <<"select name from role group by name having count(*) > 1">>,
    case merge_db:get_all(?merge_target, Sql, []) of
        {ok, Data} ->
            update_role_name(Data);
        {error, Reason} ->
            {error, Reason}
    end.
update_role_name([]) -> ok;
update_role_name([RoleName | T]) ->
    Sql = ?L(<<"update role set name = concat('【', SUBSTRING_INDEX(srv_id,  '_', -1 ), '服】', name) where name = ~s">>),
    case merge_db:execute(?merge_target, Sql, [RoleName]) of
        {ok, _} -> update_role_name(T);
        {error, Msg} -> 
            {error, Msg}
    end.
