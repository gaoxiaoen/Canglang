%%----------------------------------------------------
%% @doc 新媒体卡数据
%% 
%% @author lishen(QQ:105326073)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_media_card).

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
    Sql = util:fbin(<<"insert into ~s.sys_media_card (select * from ~s.sys_media_card where card_id not in (select card_id from ~s.sys_media_card))">>, [TargetSchema, Schema, TargetSchema]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> {ok, [], Table};
        {error, Reason} -> {error, Reason}
    end.

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

%% 纠正SrvId
update_srv_id(Table) ->
    merge_util:update_srv_id(Table, "srv_id").
