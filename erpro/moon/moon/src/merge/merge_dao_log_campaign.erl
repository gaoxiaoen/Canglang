%%----------------------------------------------------
%% @doc 参加活动记录
%% 
%% @author wpf
%% @end
%%----------------------------------------------------
-module(merge_dao_log_campaign).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table) ->
    Time = util:unixtime() - 86400 * 5,
    merge_util:batch_insert_offset(Table, <<"rid, srv_id, name, time, camp_id">>, util:fbin(<<"where time > ~w">>, [Time])).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.
