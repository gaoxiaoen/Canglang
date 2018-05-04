%%----------------------------------------------------
%% @doc 合服
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_util).

-export([
        dbsrc/1
        ,all_server/0
        ,update_srv_id/2
        ,batch_insert_offset/2
        ,batch_insert_offset/3
        ,delete_expire/2
    ]
).

-include("common.hrl").
-include("merge.hrl").

dbsrc(Platform) ->
    {ok, DataSource} = util:string_to_term("data_source_" ++ util:to_list(Platform)),
    DataSource.

%% 获取全部源库
all_server() ->
    {ok, SrcList} = application:get_env(?merge_src_list),
    {ok, [_DbHost, _DbPort, _DbUser, _DbPass, DbName, _DbEncode, _DbConnNum]} = application:get_env(?merge_target),
    Size = length(SrcList),
    all_server(SrcList, Size, 1, DbName).
all_server([], _, _, _) -> [];
all_server([{Platform, _DbHost, _DbPort, _DbUser, _DbPass, DbName, _DbEncode, _DbConnNum, UpdateRealm, Realm} | T], Size, Index, TargetSchema) ->
    [#merge_server{platform = Platform, data_source = dbsrc(Platform), schema = list_to_bitstring(DbName), update_realm = UpdateRealm, realm = Realm, size = Size, index = Index, target_schema = TargetSchema} | all_server(T, Size, Index + 1, TargetSchema)].

update_srv_id(_Table = #merge_table{server = #merge_server{data_source = DataSource}, table = TableName, old_srv_id = OldSrvId, new_srv_id = NewSrvId}, SrvColumn) ->
    Sql = "update " ++ util:to_list(TableName) ++ " set " ++ util:to_list(SrvColumn) ++ "= ~s where " ++ util:to_list(SrvColumn) ++ " = ~s",
    case merge_db:execute(DataSource, Sql, [NewSrvId, OldSrvId]) of
        {ok, _} -> 
            ok;
        {error, Msg} -> 
            {error, Msg}
    end.


batch_insert_offset(Table = #merge_table{table = TableName, server = #merge_server{schema = Schema, target_schema = TargetSchema}}, undefined) ->
    Sql = util:fbin(<<"insert into ~s.~s select * from ~s.~s">>, [TargetSchema, TableName, Schema, TableName]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> {ok, [], Table};
        {error, Reason} -> {error, Reason}
    end;

batch_insert_offset(Table = #merge_table{table = TableName, server = #merge_server{schema = Schema, target_schema = TargetSchema}}, Cloumns) ->
    Sql = util:fbin(<<"insert into ~s.~s(~s) select ~s from ~s.~s">>, [TargetSchema, TableName, Cloumns, Cloumns, Schema, TableName]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> {ok, [], Table};
        {error, Reason} -> {error, Reason}
    end.

batch_insert_offset(Table = #merge_table{table = TableName, server = #merge_server{schema = Schema, target_schema = TargetSchema}}, Cloumns, Where) ->
    Sql = util:fbin(<<"insert into ~s.~s(~s) select ~s from ~s.~s ~s">>, [TargetSchema, TableName, Cloumns, Cloumns, Schema, TableName, Where]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> {ok, [], Table};
        {error, Reason} -> {error, Reason}
    end.

%% 删除过期数据
delete_expire(_Table = #merge_table{table = TableName}, Cloumns) ->
    Time = util:unixtime(today) - 86400 * 15,
    Sql = util:fbin(<<"delete from ~s where (~s) in (select id, srv_id from role where lev < 2 and login_time < ~w)">>, [TableName, Cloumns, Time]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> ok;
        {error, Reason} -> {error, Reason}
    end;
%% 最后才可以删除role表数据
delete_expire(role, undefined) ->
    Time = util:unixtime(today) - 86400 * 15,
    Sql = util:fbin(<<"delete from role where lev < 2 and login_time < ~w">>, [Time]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> ok;
        {error, Reason} -> {error, Reason}
    end.

%% batch_insert(Table = #merge_table{db_source = ?merge_db_master, table = TableName}, _KeyColumn) ->
%%     TargetSchema = merge_data:get(schema, ?merge_db_target),
%%     MasterSchema = merge_data:get(schema, ?merge_db_master),
%%     Sql = util:fbin(<<"insert into ~s.~s select * from ~s.~s">>, [TargetSchema, TableName, MasterSchema, TableName]),
%%     case merge_db:execute(?merge_db_target, Sql, []) of
%%         {ok, _Affected} -> {ok, [], Table};
%%         {error, Reason} -> {error, Reason}
%%     end;
%% batch_insert(Table = #merge_table{db_source = ?merge_db_slave, table = TableName}, undefined) ->
%%     TargetSchema = merge_data:get(schema, ?merge_db_target),
%%     SlaveSchema = merge_data:get(schema, ?merge_db_slave),
%%     Sql = util:fbin(<<"insert into ~s.~s select * from ~s.~s">>, [TargetSchema, TableName, SlaveSchema, TableName]),
%%     case merge_db:execute(?merge_db_target, Sql, []) of
%%         {ok, _Affected} -> {ok, [], Table};
%%         {error, Reason} -> {error, Reason}
%%     end;
%% batch_insert(Table = #merge_table{db_source = ?merge_db_slave, table = TableName}, KeyColumn) ->
%%     MaxId = get_max(?merge_db_master, TableName, KeyColumn),
%%     Sql = util:fbin(<<"update ~s set id = id + ~s order by id desc">>, [TableName, util:to_list(MaxId)]),
%%     TargetSchema = merge_data:get(schema, ?merge_db_target),
%%     SlaveSchema = merge_data:get(schema, ?merge_db_slave),
%%     case merge_db:execute(?merge_db_slave, Sql, []) of
%%         {ok, _Affected} -> 
%%             ISql = util:fbin(<<"insert into ~s.~s select * from ~s.~s">>, [TargetSchema, TableName, SlaveSchema, TableName]),
%%             case merge_db:execute(?merge_db_target, ISql, []) of
%%                 {ok, _Affected} -> {ok, [], Table};
%%                 {error, Reason} -> {error, Reason}
%%             end;
%%         {error, Reason} -> {error, Reason}
%%     end.
