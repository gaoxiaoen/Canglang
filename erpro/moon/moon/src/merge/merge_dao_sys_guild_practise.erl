%%----------------------------------------------------
%% @doc 帮会历练数据
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_guild_practise).

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
    merge_util:batch_insert_offset(Table, undefined).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

%% 纠正SrvId
update_srv_id(Table) ->
    merge_util:update_srv_id(Table, "gsrv_id").
