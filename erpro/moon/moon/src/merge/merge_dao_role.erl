%%----------------------------------------------------
%% @doc 角色表
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_role).

-export([
        get_roles_name/1
    ]
).
-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
        ,update_srv_id/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

%% 只执行一次
do_init(Table = #merge_table{server = #merge_server{data_source = DataSource, update_realm = true, realm = Realm}}) ->
    Sql = <<"update role set realm = ~s">>,
    case merge_db:execute(DataSource, Sql, [Realm]) of
        {ok, _} -> 
            merge_util:batch_insert_offset(Table, undefined);
        {error, Msg} -> 
            throw({update_role_realm, Msg})
    end;
do_init(Table = #merge_table{server = #merge_server{update_realm = false}}) ->
    merge_util:batch_insert_offset(Table, undefined).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table = #merge_table{server = #merge_server{index = Index, size = Size}}) when  Index =:= Size -> 
    ?INFO("正在修改角色名称..."),
    RoleNameList = ets:tab2list(ets_merge_role_name),
    update_role_name(RoleNameList),
    ?INFO("完成修改角色名称"),
    ignore;
do_end(_Table) -> ignore.

%% 纠正SrvId
update_srv_id(_Table = #merge_table{old_srv_id = OldSrvId, new_srv_id = NewSrvId}) ->
    Sql = <<"update role set srv_id = ~s where srv_id = ~s">>,
    case merge_db:execute(?merge_target, Sql, [NewSrvId, OldSrvId]) of
        {ok, _} -> 
            ok;
        {error, Msg} -> 
            {error, Msg}
    end.

%%----------------------------------------------------
%%----------------------------------------------------

%% 获取角色名字信息
get_roles_name(DataSource) ->
    Sql = "select id, srv_id, name, lev from role",
    case merge_db:get_all4page(DataSource, Sql, [], 3000) of
        {ok, Data} -> {ok, Data};
        {error, Reason} -> {error, Reason}
    end.

update_role_name([]) -> ok;
update_role_name([#merge_role_name{key = {RoleId, SrvId}, name = RoleName} | T]) ->
    Sql = <<"update role set name = ~s where id = ~s and srv_id = ~s">>,
    case merge_db:execute(?merge_target, Sql, [RoleName, RoleId, SrvId]) of
        {ok, _} -> update_role_name(T);
        {error, Msg} -> 
            throw({update_role_name, {RoleId, SrvId}, Msg})
    end;
update_role_name(_) -> ok.
