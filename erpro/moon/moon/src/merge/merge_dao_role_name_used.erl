%%----------------------------------------------------
%% @doc 角色曾用名
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(merge_dao_role_name_used).

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
    merge_util:batch_insert_offset(Table, <<"rid, srv_id, name, new_name, sex, career, realm, vip, ctime">>).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

%% 纠正SrvId
update_srv_id(Table) ->
    merge_util:update_srv_id(Table, "srv_id").



