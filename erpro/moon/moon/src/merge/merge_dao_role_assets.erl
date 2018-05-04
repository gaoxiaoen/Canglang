%%----------------------------------------------------
%% @doc 角色资产表
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_role_assets).

-export([
        get_exp/3
    ]
).

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
    merge_util:batch_insert_offset(Table, <<"rid, srv_id, exp, gold, coin, honor, gold_bind, coin_bind, spt, attainment, badge, hearsay, charm, flower, gold_integral, arena, acc_arena, charge, career_devote, both_time, guild_war, guild_war_acc, guard_acc, lilian, wc_lev, practice_acc, practice, seal_exp, soul, soul_acc">>).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

%% 纠正SrvId
update_srv_id(Table) ->
    merge_util:update_srv_id(Table, "srv_id").

get_exp(DataSource, RoleId, SrvId) ->
    Sql = "select exp from role_assets where rid = ~s and srv_id = ~s",
    case merge_db:get_one(DataSource, Sql, [RoleId, SrvId]) of
        {ok, undefined} -> 
            ?INFO("角色没有资产信息DataSource:~w, RoleId:~w, SrvId:~s", [DataSource, RoleId, SrvId]),
            {ok, 1};
        {error, undefined} -> 
            ?INFO("角色没有资产信息DataSource:~w, RoleId:~w, SrvId:~s", [DataSource, RoleId, SrvId]),
            {ok, 1};
        {ok, Exp} -> {ok, Exp};
        {error, Msg} -> 
            ?INFO("角色没有资产信息DataSource:~w, RoleId:~w, SrvId:~s", [DataSource, RoleId, SrvId]),
            throw({db_error, role_assets_get_exp, Msg})
    end.

%% 删除数据(1级，15天未登录)
delete_expire(Table) ->
    merge_util:delete_expire(Table, <<"rid, srv_id">>).
