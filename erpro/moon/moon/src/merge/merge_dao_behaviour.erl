%%----------------------------------------------------
%% @doc DAO behaviour
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_behaviour).

-export([
        merge/1
        ,truncate/1
        ,update_srv_id/1
        ,delete_expire/1
    ]
).

-include("common.hrl").
-include("merge.hrl").


%%----------------------------------------------------
%% 接口
%%----------------------------------------------------
%% 合并
merge(Table = #merge_table{dao = DaoMod}) ->
    {ok, Data, NewTable} = case DaoMod:do_init(Table) of
        {ok, Rs, NT} -> {ok, Rs, NT};
        {error, Msg} ->
            catch ?DEBUG("初始失败[Reason:~s]", [Msg]),
            throw({dao_init_error, DaoMod, Msg})
    end,
    case DaoMod:do_convert(Data, NewTable) of
        {ok, NewTable2} -> DaoMod:do_end(NewTable2);
        {error, Reason} ->
            ?INFO("~w处理do_convert出错:~s", [DaoMod, Reason]),
            throw({dao_do_convert_error, DaoMod, Reason})
    end.

%% 工具函数，清档
truncate(#merge_table{table = TableName}) ->
    Sql = util:fbin(<<"truncate ~s">>, [TableName]),
    merge_db:execute(?merge_target, Sql, []).

%% 纠正SrvId
update_srv_id(Table = #merge_table{dao = DaoMod}) ->
    case DaoMod:update_srv_id(Table) of
        {error, Msg} ->
            throw({dao_update_srv_id_error, DaoMod, Msg});
        _ -> ok
    end.

%% 删除数据(1级，15天未登录)
delete_expire(Table = #merge_table{table = TableName, dao = DaoMod}) ->
    case DaoMod:delete_expire(Table) of
        {error, Msg} ->
            catch ?INFO("删除~s过期数据有误:~s", [TableName, Msg]),
            throw({dao_delete_expire, DaoMod, Msg});
        _ -> ok
    end.

