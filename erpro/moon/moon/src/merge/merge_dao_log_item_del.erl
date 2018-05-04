%%----------------------------------------------------
%% @doc 物品删除日志
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_log_item_del).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table) ->
    Time = util:unixtime() - 86400 * 15,
    merge_util:batch_insert_offset(Table, <<"rid, srv_id, name, item_id, item_name, bind, del_type, pos, item_info, ctime, recovered">>, util:fbin(<<"where ctime > ~w">>, [Time])).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.
