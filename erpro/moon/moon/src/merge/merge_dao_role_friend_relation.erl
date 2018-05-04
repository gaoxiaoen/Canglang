%%----------------------------------------------------
%% @doc 好友关系表
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_role_friend_relation).

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
do_end(#merge_table{server = #merge_server{index = Index, size = Size}}) when Index =:= Size -> 
    %% 合并完最后一张game库的数据表之后，处理好友类型的转换
    Sql1 = <<"select distinct owner_srv_id from role_friend_relation">>,
    Sql2 = <<"update role_friend_relation set fr_type = 0, fr_group_id = 0 where fr_type = 4 and fr_srv_id = ~s">>,
    case merge_db:get_all(?merge_target, Sql1, []) of
        {ok, Data} ->
            set_type(Sql2, Data);
        {error, Reason} ->
            {error, Reason}
    end;
do_end(_MergeTable) -> 
    ignore.

%% 纠正SrvId
update_srv_id(Table) ->
    case merge_util:update_srv_id(Table, "owner_srv_id") of
        {error, Reason} -> {error, Reason};
        _ ->
            merge_util:update_srv_id(Table, "fr_srv_id")
    end.

%% 删除数据(1级，15天未登录)
delete_expire(Table) ->
    case merge_util:delete_expire(Table, <<"owner_rid, owner_srv_id">>) of
        ok ->
            merge_util:delete_expire(Table, <<"fr_rid, fr_srv_id">>);
        {false, Reason} -> {false, Reason}
    end.

%% 跨服好友合服后处理成普通好友
set_type(_Sql, []) -> ok;
set_type(Sql, [[SrvId] | T]) ->
    case merge_db:execute(?merge_target, Sql, [SrvId]) of
        {ok, _N} ->
            ?DEBUG("合服处理玩家的跨服[~s]好友个数:~w", [SrvId, _N]);
        _ -> ?ERR("合服处理跨服好友的类型处理[~s]失败", [SrvId])
    end,
    set_type(Sql, T).
