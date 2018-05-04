%%----------------------------------------------------
%% @doc 账号防沉迷身份证信息
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_fcm).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table = #merge_table{server = #merge_server{index = 1}}) ->
    merge_util:batch_insert_offset(Table, undefined);
do_init(Table = #merge_table{server = #merge_server{schema = Schema, target_schema = TargetSchema}}) ->
    Sql = util:fbin(<<"insert into ~s.sys_fcm (select * from ~s.sys_fcm s where not exists (select * from ~s.sys_fcm t where s.account = t.account))">>, [TargetSchema, Schema, TargetSchema]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> {ok, [], Table};
        {error, Reason} -> {error, Reason}
    end.

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> 
    ignore.
