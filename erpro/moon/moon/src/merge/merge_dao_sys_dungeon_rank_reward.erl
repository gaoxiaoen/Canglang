%%----------------------------------------------------
%% @doc 副本分数
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_dungeon_rank_reward).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table) ->
    merge_util:batch_insert_offset(Table, <<"role_id, srv_id, clear_id, rank, rank_score, status, create_time">>).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.


