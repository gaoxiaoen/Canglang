%%----------------------------------------------------
%% @doc 结拜数据
%% 
%% @author lishen(QQ:105326073)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_role_sworn).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
        ,delete_expire/1
        ,update_srv_id/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table) ->
    merge_util:batch_insert_offset(Table, undefined).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

%% 纠正SrvId
update_srv_id(Table) ->
    case merge_util:update_srv_id(Table, "srv_id") of
        {error, Reason} -> {error, Reason};
        _ ->
            merge_util:update_srv_id(Table, "member1_srv_id"),
            merge_util:update_srv_id(Table, "member2_srv_id"),
            merge_util:update_srv_id(Table, "out_member_srv_id")
    end.

%% 删除数据(1级，15天未登录)
delete_expire(Table) ->
    merge_util:delete_expire(Table, <<"rid, srv_id">>).
