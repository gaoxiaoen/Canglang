%%----------------------------------------------------
%% @doc 晶钻日志
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_log_gold).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
        ,delete_expire/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table = #merge_table{server = #merge_server{schema = Schema, target_schema = TargetSchema}}) ->
    Sql = util:fbin(<<"insert into ~s.log_gold(rid, srv_id, name, lev, type, gold_b, gold, remark, stat_key, ctime) select rid, srv_id, name, lev, type, gold_b, gold, remark, stat_key, ctime from ~s.log_gold">>, [TargetSchema, Schema]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> {ok, [], Table};
        {error, Reason} -> {error, Reason}
    end.

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

%% 删除数据(1级，15天未登录)
delete_expire(Table) ->
    merge_util:delete_expire(Table, <<"rid, srv_id">>).
