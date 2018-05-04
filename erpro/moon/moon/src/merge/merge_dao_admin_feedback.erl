%%----------------------------------------------------
%% @doc 角色数据
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_admin_feedback).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
        ,update_srv_id/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table) ->
    merge_util:batch_insert_offset(Table, <<"state, role_id, srv_id, role_name, type, type_lev, type_fun, title, content, ip, post_time, gm, reply, reply_time">>).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

%% 纠正SrvId
update_srv_id(_Table = #merge_table{server = #merge_server{data_source = DataSource}, old_srv_id = OldSrvId, new_srv_id = NewSrvId}) ->
    Sql = <<"update admin_feedback set srv_id = ~s where srv_id = ~s">>,
    case merge_db:execute(DataSource, Sql, [NewSrvId, OldSrvId]) of
        {ok, _} -> 
            ok;
        {error, Msg} -> 
            {error, Msg}
    end.

