%%----------------------------------------------------
%% @doc 飞仙历练
%% @author weihua@jieyou.cn
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_train).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table = #merge_table{server = #merge_server{index = Size, size = Size}}) ->
    SrvList = merge_util:all_server(),
    List = [Platform || #merge_server{platform = Platform} <- SrvList],
    train_merge:merge(List),
    {ok, [], Table};
do_init(Table) -> {ok, [], Table}.

%% 处理数据
do_convert(_Data, Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.
