%%---------------------------------------------------
%% @doc 名人榜数据
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_rank_celebrity).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
        ,update_srv_id/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table = #merge_table{server = #merge_server{schema = Schema, target_schema = TargetSchema}}) ->    
    Sql = util:fbin("insert into ~s.sys_rank_celebrity select ctype, rid, srv_id, CONCAT('[', SUBSTRING_INDEX(srv_id, '_', -1),'服]', name), sex, career, in_time from ~s.sys_rank_celebrity", [TargetSchema, Schema]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> {ok, [], Table};
        {error, Reason} -> {error, Reason}
    end.

%% 处理数据
do_convert(_, Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

%% 纠正SrvId
update_srv_id(Table) ->
    merge_util:update_srv_id(Table, "srv_id").
