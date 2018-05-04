%%----------------------------------------------------
%% @doc 通缉榜单
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_wanted_rank).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
        ,update_srv_id/1
        ,delete_expire/1
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
            merge_util:update_srv_id(Table, "offer_srv_id")
    end.

%% 删除数据(1级，15天未登录)
delete_expire(Table) ->
    case merge_util:delete_expire(Table, <<"rid, srv_id">>) of
        ok ->
            merge_util:delete_expire(Table, <<"offer_id, offer_srv_id">>);
        {false, Reason} -> {false, Reason}
    end.
