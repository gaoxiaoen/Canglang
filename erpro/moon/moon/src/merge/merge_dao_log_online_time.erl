%%----------------------------------------------------
%% @doc 实时在线日志
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_log_online_time).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table) ->
    Time = util:unixtime() - 86400 * 90, %% 6个月
    merge_util:batch_insert_offset(Table, <<"rid, srv_id, name, ol_time, ctime">>, util:fbin(<<"where ctime > ~w">>, [Time])).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.
